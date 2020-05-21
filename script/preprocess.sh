#! /bin/bash
scripts=`dirname "$0"`
base=$scripts/..
tools=$base/tools  
data=$base/dataMOSES=$tools/moses-scripts/scripts
train_size=100000  
mkdir -p $base/shared_models  
bpe_num_operations=2000bpe_vocab_threshold=10
src=en 
trg=de
# if this leads to out-of-memory on your machine, use the argument --memory-efficient 
python $scripts/subsample.py
 --src-input $data/train.$src-$trg.$src \
 --trg-input $data/train.$src-$trg.$trg \
 --src-output $data/sub.train.$src-$trg.$src \
 --trg-output $data/sub.train.$src-$trg.$trg \
 --size $train_size   
 
 #for i in $data/sub.*; do mv "$i" "${i/sub/}"; done  
 for corpus in train test dev; do   
	$MOSES/tokenizer/tokenizer.perl -l $src < $data/$corpus.$src-$trg.$src > $data/$corpus.tokenized.$src $MOSES/tokenizer/tokenizer.perl -l $trg < $data/$corpus.$src-$trg.$trg > $data/$corpus.tokenized.$trg  
 done   
 
 wc -l $data/*tokenized.*  
 # prepare bpe data for bpe_level  
 
 # learn BPE model on train (concatenate both languages)
 
subword-nmt learn-joint-bpe-and-vocab -i $data/train.tokenized.$src $data/train.tokenized.$trg --write-vocabulary $base/shared_models/vocab.$src $base/shared_models/vocab.$trg -s $bpe_num_operations -o $base/shared_models/$src$trg.bpe 
 
# apply BPE model to train, test and dev   

for corpus in train dev test; do   
 subword-nmt apply-bpe -c $base/shared_models/$src$trg.bpe --vocabulary $base/shared_models/vocab.$src --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus.tokenized.$src > $data/$corpus.bpe.$src   
 subword-nmt apply-bpe -c $base/shared_models/$src$trg.bpe --vocabulary $base/shared_models/vocab.$trg --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus.tokenized.$trg > $data/$corpus.bpe.$trg   
done  

# sanity checks   

echo "At this point, please check that 1) file sizes are as expected, 2) languages are correct and 3) material is still parallel" 
echo "time taken:" 
echo "$SECONDS seconds"  