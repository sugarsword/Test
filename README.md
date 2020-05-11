# Test
Try out some commands

put a script file


| Model name | soure dimension | factor dimension | target dimension | Hidden dimension| BLEU | Time |
|  |--- |--- |--- |  (same for source and target)|---|---|
|---|---|---|---|---|---|   ------   |
|rnn_wmt16_deen|512|n/a|512|1024|8.9|46242sec (on a 4cpu engine)|
|rnn_wmt16_add_deen|512|512|512|1024|1.6|30566sec (on an 8cpu engine)|
|rnn_wmt16_concatenate_deen|256|256|512|1024|8.3|28932sec (on an 8cpu engine)|
|rnn_wmt16_add_256_deen|256|256|256|1024|8.6|27180sec (on an 8cpu engine)|
