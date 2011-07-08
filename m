From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Fri, 8 Jul 2011 13:44:29 +0100
Message-ID: <20110708124429.GB4284@yahoo.fr>
References: <20110703190913.GA4474@yahoo.fr>
 <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com>
 <20110706081111.GA6931@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110706081111.GA6931@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-06 09:11:11 +0100, Stephane Chazelas:
> 2011-07-03 13:38:57 -0600, cwillu:
> > On Sun, Jul 3, 2011 at 1:09 PM, Stephane Chazelas
> > <stephane_chazelas@yahoo.fr> wrote:
> [...]
> > > Now, on a few occasions (actually, most of the time), when I
> > > rsynced the data (about 2.5TB) onto the external drive, the
> > > system would crash after some time with "Out of memory and no
> > > killable process". Basically, something in kernel was allocating
> > > the whole memory, then oom mass killed everybody and crash.
> [...]
> > Look at the output of slabtop (should be installed by default, procfs
> > package), before rsync for comparison, and during.
> 
> Hi,
> 
> so, no crash this time
[...]

Another attempt, again onto an empty drive, this time with
3.0.0-rc6. Exact same scenario.

slabinfo:

             extent_map delayed_node btrfs_inode_cache btrfs_free_space_cache
            (in bytes)
2011-07-07_10:40     143264      29952          0     120832
2011-07-07_10:50   16088160   59593248  228140000     196352
2011-07-07_11:00   19549728   83101824  258900000     475776
2011-07-07_11:10   17695040   52438464  163416000     758976
2011-07-07_11:20   16723168   55321344  180820000    1095040
2011-07-07_11:30   15468640   46624032  166568000    1344256
2011-07-07_11:40   14651648   43962048  143916000    1944640
2011-07-07_11:50    9010144    2620800    9732000    2231616
2011-07-07_12:00    4224352    3646656    9224000    2473280
2011-07-07_12:10    2528416     456768    1984000    2511040
2011-07-07_12:20    2400640     426816    1452000    2590336
2011-07-07_12:30    2241888     336960    1052000    2590336
2011-07-07_12:40    4669632   10224864   36804000    2662080
2011-07-07_12:50    4386976    4320576    8032000    2662080
2011-07-07_13:00    4282432    1793376    5860000    2662080
2011-07-07_13:10    4270816    1231776    2848000    2662080
2011-07-07_13:20    4255328    1141920    2348000    2662080
2011-07-07_13:30    4255328    1134432    2232000    2662080
2011-07-07_13:40    4255328    1130688    2192000    2662080
2011-07-07_13:50    4255328    1130688    2172000    2662080
2011-07-07_14:00    4239840    1130688    2168000    2665856
2011-07-07_14:10    4212736    7259616   28420000    2669632
2011-07-07_14:20    7008320    9936576   23176000    2673408
2011-07-07_14:30    6915392    9929088   22512000    2677184
2011-07-07_14:40    7047040    9929088   25392000    2680960
2011-07-07_14:50    8537760    9929088   26368000    2707392
2011-07-07_15:00   10469888   12804480   40116000    2718720
2011-07-07_15:10   13195776   14028768   47080000    2726272
2011-07-07_15:20   13571360   13946400   45748000    2730048
2011-07-07_15:30   19580704   16200288   54596000    2737600
2011-07-07_15:40   19449056   16192800   52412000    2737600
2011-07-07_15:50   19445184   16192800   52412000    2737600
2011-07-07_16:00   19425824   19450080   66480000    2741376
2011-07-07_16:10   24858240   25994592   91076000    2756480
2011-07-07_16:20   24246464   25930944   77448000    2760256
2011-07-07_16:30   25477760   35144928  131312000    2767808
2011-07-07_16:40   40625024   85512960  326444000    2767808
2011-07-07_16:50   53247744  102390912  346560000    2767808
2011-07-07_17:00   63465952  113390784  388416000    2786688
2011-07-07_17:10   10020736   13523328   24960000    2805568
2011-07-07_17:20    8971424    9345024   28900000    2809344
2011-07-07_17:30    9257952   31408416   78040000    2805568
2011-07-07_17:40    9257952   31378464   76812000    2805568
2011-07-07_17:50    9257952   31374720   75828000    2805568
2011-07-07_18:00    6857312   13725504   21940000    2805568
2011-07-07_18:10    6605632   10707840   37816000    2813120
2011-07-07_18:20   10768032   17252352   54032000    2820672
2011-07-07_18:30   21737408   74595456  210492000    2824448
2011-07-07_18:40   14554848   16967808   41232000    2832000
2011-07-07_18:50    6594016   10281024   30876000    2832000
2011-07-07_19:00    6322976   11467872   40804000    2835776
2011-07-07_19:10    7798208   12227904   46520000    2843328
2011-07-07_19:20    9927808   13279968   46960000    2850880
2011-07-07_19:30   10237568   13272480   46644000    2854656
2011-07-07_19:40   17160704   16368768   56740000    2865984
2011-07-07_19:50   26039200   29105856  101828000    2881088
2011-07-07_20:00   27878400   33988032  115528000    2881088
2011-07-07_20:10   30604288   39151008  125960000    2881088
2011-07-07_20:20   31339968   39049920  125476000    2881088
2011-07-07_20:30   31297376   39042432  127928000    2881088
2011-07-07_20:40   31390304   39038688  129048000    2881088
2011-07-07_20:50   31390304   39038688  127280000    2888640
2011-07-07_21:00   31390304   39038688  127188000    2892416
2011-07-07_21:10   31738784   39038688  127160000    2892416
2011-07-07_21:20   40299776   49342176  173700000    2896192
2011-07-07_21:30   46041952   58904352  206176000    2899968
2011-07-07_21:40   54223488   61832160  216108000    2907520
2011-07-07_21:50   60728448   71034912  245064000    2915072
2011-07-07_22:00   67353440   70619328  240420000    2933952
2011-07-07_22:10   66517088   70619328  237640000    2933952
2011-07-07_22:20   66513216   70619328  237636000    2937728
2011-07-07_22:30   66505472   70619328  237632000    2937728
2011-07-07_22:40   66505472   70619328  237620000    2941504
2011-07-07_22:50   69936064   73266336  248200000    2945280
2011-07-07_23:00   69912832   73255104  246616000    2945280
2011-07-07_23:10   69912832   73247616  246596000    2949056
2011-07-07_23:20   69905088   73247616  249108000    2949056
2011-07-07_23:30   75043232   82573920  286540000    2949056
2011-07-07_23:40   76739168   82543968  274260000    2949056
2011-07-07_23:50   76638496   82543968  273060000    2949056
2011-07-08_00:00   76553312   82543968  278432000    2952832
2011-07-08_00:10   76708192   82543968  275812000    2956608
2011-07-08_00:20   80262688   84898944  293508000    2964160
2011-07-08_00:30   80549216   84895200  288516000    2971712
2011-07-08_00:40   86473376  105022944  361956000    2975488
2011-07-08_00:50   94937568  127599264  423384000    2986816
2011-07-08_01:00   94763328  127599264  405932000    2994368
2011-07-08_01:10   96285024  127599264  411020000    3001920
2011-07-08_01:20   97957728  127599264  417404000    3005696
2011-07-08_01:30  102999072  127599264  443520000    3009472
2011-07-08_01:40  108803200  132541344  463332000    3009472
2011-07-08_01:50  114324672  137056608  476084000    3009472
2011-07-08_02:00  114808672  137487168  478348000    3013248
2011-07-08_02:10  114897728  137505888  478428000    3013248
2011-07-08_02:20  118192800  140991552  491152000    3020800
2011-07-08_02:30  121724064  145641600  506520000    3035904
2011-07-08_02:40  127969600  152350848  529720000    3043456
2011-07-08_02:50  128864032  152324640  528980000    3043456
2011-07-08_03:00  134788192  158322528  553792000    3043456
2011-07-08_03:10  138338816  163425600  568052000    3043456
2011-07-08_03:20  141993984  166450752  579660000    3043456
2011-07-08_03:30  147368320  169322400  589688000    3047232
2011-07-08_03:40  153311840  173545632  602736000    3058560
2011-07-08_03:50  153346688  173508192  602076000    3062336
2011-07-08_04:00  157904032  182403936  634212000    3069888
2011-07-08_04:10  156808256  181778688  628016000    3069888
2011-07-08_04:20  160231104  183463488  637672000    3069888
2011-07-08_04:30  161733440  183399840  633880000    3069888
2011-07-08_04:40  161621152  183396096  633388000    3069888
2011-07-08_04:50  161474016  183396096  633376000    3069888
2011-07-08_05:00  161466272  183396096  633364000    3069888
2011-07-08_05:10  161466272  183396096  637660000    3069888
2011-07-08_05:20  161656000  183396096  635752000    3069888
2011-07-08_05:30  161640512  183396096  635752000    3069888
2011-07-08_05:40  161799264  183396096  636468000    3069888
2011-07-08_05:50  162298752  183396096  636828000    3077440
2011-07-08_06:00  162434272  183422304  637084000    3077440
2011-07-08_06:10  162434272  183414816  637068000    3081216
2011-07-08_06:20  162546560  183478464  637316000    3084992
2011-07-08_06:30  162527200  183568320  637432000    3084992
2011-07-08_06:40  162860192  183635712  637748000    3088768
2011-07-08_06:50  162879552  183950208  638912000    3092544
2011-07-08_07:00  162879552  184234752  639944000    3092544
2011-07-08_07:10  163181568  184635360  641692000    3096320
2011-07-08_07:20  165977152  193875552  673360000    3103872
2011-07-08_07:30  165946176  194493312  661292000    3103872
2011-07-08_07:40  167742784  194493312  668704000    3107648
2011-07-08_07:50  168219040  194493312  668896000    3111424
2011-07-08_08:00  171901312  200775744  697404000    3115200
2011-07-08_08:10  188078528  273997152  894600000    3115200
2011-07-08_08:20  188004960  273813696  891580000    3115200
2011-07-08_08:30  187780384  283016448 1327376000    3205824
2011-07-08_08:40  187633248  273832416  941688000    3254912
2011-07-08_08:50  187807488  273832416  891768000    3254912
2011-07-08_09:00  187950752  273832416  891768000    3258688
2011-07-08_09:10  188117248  273832416  891768000    3258688
2011-07-08_09:20  189166560  273832416  891748000    3266240
2011-07-08_09:30  195218496  273832416  891732000    3266240
2011-07-08_09:40  195795424  273832416  892996000    3270016
2011-07-08_09:50  200387616  273832416  892544000    3277568
2011-07-08_10:00  199044032  273832416  892284000    3277568
2011-07-08_10:10  199020800  273832416  892284000    3277568
2011-07-08_10:20  199202784  273832416  892280000    3281344
2011-07-08_10:30  199342176  273832416  902376000    3285120
2011-07-08_10:40  204933344  273832416  903660000    3296448
2011-07-08_10:50  209788832  273832416  909948000    3300224
2011-07-08_11:00  214113856  273832416  915596000    3307776
2011-07-08_11:10  218504704  281043360  964020000    3315328
2011-07-08_11:20  218961600  281039616  957752000    3315328
2011-07-08_11:30  245693888  397912320 1370312000    3315328
2011-07-08_11:40  318092544  635757408 2201932000    3387072
2011-07-08_11:50  390467968  877170528 3032756000    3451264
2011-07-08_11:54:30  408050720  935236224 3246892000    3466368
2011-07-08_11:54:50  408817376  938669472 3248144000    3470144
2011-07-08_11:55:00  409192960  938793024 3256076000    3470144

After which the oom killer killed everybody. Just before that, we had:

==> /proc/slabinfo <==
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
fuse_request           0      0    608    6    1 : tunables   54   27    8 : slabdata      0      0      0
fuse_inode             0      0    768    5    1 : tunables   54   27    8 : slabdata      0      0      0
dm_crypt_io          416    625    152   25    1 : tunables  120   60    8 : slabdata     25     25    324
ext4_groupinfo_4k     80     84    136   28    1 : tunables  120   60    8 : slabdata      3      3      0
ext4_inode_cache     209    448    912    4    1 : tunables   54   27    8 : slabdata    112    112      0
ext4_xattr             0      0     88   44    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_free_data         0      0     56   67    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_allocation_context      0      0    136   28    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_prealloc_space      3     37    104   37    1 : tunables  120   60    8 : slabdata      1      1      0
ext4_system_zone       0      0     40   92    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_io_end            0      0   1128    3    1 : tunables   24   12    8 : slabdata      0      0      0
ext4_io_page           0      0     16  202    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_inode            51     77     48   77    1 : tunables  120   60    8 : slabdata      1      1      0
jbd2_journal_handle      0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_journal_head      0      0    112   34    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_revoke_table      2    202     16  202    1 : tunables  120   60    8 : slabdata      1      1      0
jbd2_revoke_record      0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
kcopyd_job             0      0   3384    2    2 : tunables   24   12    8 : slabdata      0      0      0
io                     0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
dm_uevent              0      0   2608    3    2 : tunables   24   12    8 : slabdata      0      0      0
dm_rq_clone_bio_info      0      0     16  202    1 : tunables  120   60    8 : slabdata      0      0      0
dm_rq_target_io        0      0    400   10    1 : tunables   54   27    8 : slabdata      0      0      0
dm_target_io        1596   3168     24  144    1 : tunables  120   60    8 : slabdata     22     22    420
dm_io               1612   2668     40   92    1 : tunables  120   60    8 : slabdata     29     29    480
delayed_node      3259698 3259698    288   13    1 : tunables   54   27    8 : slabdata 250746 250746      0
extent_map        4649920 4649920     88   44    1 : tunables  120   60    8 : slabdata 105680 105680      0
extent_buffers      7248  14520    128   30    1 : tunables  120   60    8 : slabdata    484    484     60
extent_state        3150   7740    128   30    1 : tunables  120   60    8 : slabdata    258    258      0
btrfs_free_space_cache  54194  54221     64   59    1 : tunables  120   60    8 : slabdata    919    919      0
btrfs_path_cache     135    135    144   27    1 : tunables  120   60    8 : slabdata      5      5      0
btrfs_transaction_cache     16     16    240   16    1 : tunables  120   60    8 : slabdata      1      1      0
btrfs_trans_handle_cache    111    159     72   53    1 : tunables  120   60    8 : slabdata      3      3      0
btrfs_inode_cache 3260160 3260160   1000    4    1 : tunables   54   27    8 : slabdata 815040 815040     27
sd_ext_cdb             2    112     32  112    1 : tunables  120   60    8 : slabdata      1      1      0
uhci_urb_priv         32     67     56   67    1 : tunables  120   60    8 : slabdata      1      1      0
scsi_sense_cache     210    210    128   30    1 : tunables  120   60    8 : slabdata      7      7      0
scsi_cmd_cache       210    210    256   15    1 : tunables  120   60    8 : slabdata     14     14     60
sgpool-128            19     19   4096    1    1 : tunables   24   12    8 : slabdata     19     19      0
sgpool-64              8      8   2048    2    1 : tunables   24   12    8 : slabdata      4      4      0
sgpool-32             40     40   1024    4    1 : tunables   54   27    8 : slabdata     10     10      0
sgpool-16             79     80    512    8    1 : tunables   54   27    8 : slabdata     10     10      0
sgpool-8             180    180    256   15    1 : tunables  120   60    8 : slabdata     12     12     60
scsi_data_buffer       0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
fib6_nodes             5     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
ip6_dst_cache          4     20    384   10    1 : tunables   54   27    8 : slabdata      2      2      0
ndisc_cache            1     12    320   12    1 : tunables   54   27    8 : slabdata      1      1      0
ip6_mrt_cache          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
RAWv6                  5      8   1024    4    1 : tunables   54   27    8 : slabdata      2      2      0
UDPLITEv6              0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
UDPv6                  0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
tw_sock_TCPv6          0      0    320   12    1 : tunables   54   27    8 : slabdata      0      0      0
request_sock_TCPv6      0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
TCPv6                  3      4   1856    2    1 : tunables   24   12    8 : slabdata      2      2      0
flow_cache             0      0     96   40    1 : tunables  120   60    8 : slabdata      0      0      0
btree_node             0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
cfq_io_context        85    120    128   30    1 : tunables  120   60    8 : slabdata      4      4      0
cfq_queue            133    136    232   17    1 : tunables  120   60    8 : slabdata      8      8      0
bsg_cmd                0      0    312   12    1 : tunables   54   27    8 : slabdata      0      0      0
mqueue_inode_cache      1      4    896    4    1 : tunables   54   27    8 : slabdata      1      1      0
hugetlbfs_inode_cache      1      6    608    6    1 : tunables   54   27    8 : slabdata      1      1      0
dquot                  0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
kioctx                 0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
kiocb                  0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
fanotify_response_event      0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
fsnotify_mark          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_event_private_data      0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_inode_mark     11     28    136   28    1 : tunables  120   60    8 : slabdata      1      1      0
dnotify_mark           0      0    136   28    1 : tunables  120   60    8 : slabdata      0      0      0
dnotify_struct         0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
fasync_cache           0      0     48   77    1 : tunables  120   60    8 : slabdata      0      0      0
khugepaged_mm_slot      0      0     40   92    1 : tunables  120   60    8 : slabdata      0      0      0
ksm_mm_slot            0      0     48   77    1 : tunables  120   60    8 : slabdata      0      0      0
ksm_stable_node        0      0     40   92    1 : tunables  120   60    8 : slabdata      0      0      0
ksm_rmap_item          0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
pid_namespace          0      0   2112    3    2 : tunables   24   12    8 : slabdata      0      0      0
user_namespace         0      0   1072    7    2 : tunables   24   12    8 : slabdata      0      0      0
nsproxy                0      0     48   77    1 : tunables  120   60    8 : slabdata      0      0      0
posix_timers_cache      0      0    176   22    1 : tunables  120   60    8 : slabdata      0      0      0
uid_cache              2     30    128   30    1 : tunables  120   60    8 : slabdata      1      1      0
UNIX                  16     27    832    9    2 : tunables   54   27    8 : slabdata      3      3      0
ip_mrt_cache           0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
UDP-Lite               0      0    832    9    2 : tunables   54   27    8 : slabdata      0      0      0
tcp_bind_bucket       13     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
inet_peer_cache       11     20    192   20    1 : tunables  120   60    8 : slabdata      1      1      0
secpath_cache          0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm_dst_cache         0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
ip_fib_trie            8     67     56   67    1 : tunables  120   60    8 : slabdata      1      1      0
ip_fib_alias           9     77     48   77    1 : tunables  120   60    8 : slabdata      1      1      0
ip_dst_cache         173    195    256   15    1 : tunables  120   60    8 : slabdata     13     13      0
arp_cache             10     24    320   12    1 : tunables   54   27    8 : slabdata      2      2      0
PING                   0      0    832    9    2 : tunables   54   27    8 : slabdata      0      0      0
RAW                    3      9    832    9    2 : tunables   54   27    8 : slabdata      1      1      0
UDP                    1      9    832    9    2 : tunables   54   27    8 : slabdata      1      1      0
tw_sock_TCP            0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCP       0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
TCP                   15     20   1728    4    2 : tunables   24   12    8 : slabdata      5      5      0
eventpoll_pwq          0      0     72   53    1 : tunables  120   60    8 : slabdata      0      0      0
eventpoll_epi          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_integrity       0      0    112   34    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_queue          25     28   1720    4    2 : tunables   24   12    8 : slabdata      7      7      0
blkdev_requests      345    539    360   11    1 : tunables   54   27    8 : slabdata     49     49    189
blkdev_ioc            67    159     72   53    1 : tunables  120   60    8 : slabdata      3      3      0
fsnotify_event_holder      0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
fsnotify_event         1     34    112   34    1 : tunables  120   60    8 : slabdata      1      1      0
bio-0                680   1280    192   20    1 : tunables  120   60    8 : slabdata     64     64    420
biovec-256           110    110   4096    1    1 : tunables   24   12    8 : slabdata    110    110     12
biovec-128           142    208   2048    2    1 : tunables   24   12    8 : slabdata     93    104     96
biovec-64             24     24   1024    4    1 : tunables   54   27    8 : slabdata      6      6      0
biovec-16            109    240    256   15    1 : tunables  120   60    8 : slabdata     16     16      7
bip-256                2      2   4224    1    2 : tunables    8    4    0 : slabdata      2      2      0
bip-128                0      0   2176    3    2 : tunables   24   12    8 : slabdata      0      0      0
bip-64                 0      0   1152    7    2 : tunables   24   12    8 : slabdata      0      0      0
bip-16                 0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
bip-4                  0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
bip-1                  0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
sock_inode_cache      54     66    640    6    1 : tunables   54   27    8 : slabdata     11     11      0
skbuff_fclone_cache      5      7    512    7    1 : tunables   54   27    8 : slabdata      1      1      0
skbuff_head_cache    591    690    256   15    1 : tunables  120   60    8 : slabdata     46     46    120
file_lock_cache        1     22    176   22    1 : tunables  120   60    8 : slabdata      1      1      0
net_namespace          0      0   2624    3    2 : tunables   24   12    8 : slabdata      0      0      0
shmem_inode_cache    787    805    816    5    1 : tunables   54   27    8 : slabdata    161    161      0
Acpi-Operand        1113   1272     72   53    1 : tunables  120   60    8 : slabdata     24     24      0
Acpi-ParseExt          0      0     72   53    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Parse             0      0     48   77    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-State             0      0     80   48    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Namespace       765    828     40   92    1 : tunables  120   60    8 : slabdata      9      9      0
task_delay_info      134    238    112   34    1 : tunables  120   60    8 : slabdata      7      7      0
taskstats              1     12    328   12    1 : tunables   54   27    8 : slabdata      1      1      0
proc_inode_cache     133    258    656    6    1 : tunables   54   27    8 : slabdata     41     43    128
sigqueue               1     24    160   24    1 : tunables  120   60    8 : slabdata      1      1      0
bdev_cache            30     32    832    4    1 : tunables   54   27    8 : slabdata      8      8      0
sysfs_dir_cache    13442  13536     80   48    1 : tunables  120   60    8 : slabdata    282    282      0
mnt_cache             24     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
filp                1044   1260    192   20    1 : tunables  120   60    8 : slabdata     63     63    300
inode_cache         1497   1680    592    6    1 : tunables   54   27    8 : slabdata    280    280      0
dentry              4420   6140    192   20    1 : tunables  120   60    8 : slabdata    307    307      0
names_cache           27     27   4096    1    1 : tunables   24   12    8 : slabdata     27     27      0
key_jar                1     20    192   20    1 : tunables  120   60    8 : slabdata      1      1      0
buffer_head          164    333    104   37    1 : tunables  120   60    8 : slabdata      9      9      0
vm_area_struct      2283   2552    176   22    1 : tunables  120   60    8 : slabdata    116    116      0
mm_struct             64     64    960    4    1 : tunables   54   27    8 : slabdata     16     16      0
fs_cache              54    177     64   59    1 : tunables  120   60    8 : slabdata      3      3      0
files_cache           55     88    704   11    2 : tunables   54   27    8 : slabdata      8      8      0
signal_cache         127    147   1088    7    2 : tunables   24   12    8 : slabdata     21     21      0
sighand_cache        115    129   2112    3    2 : tunables   24   12    8 : slabdata     43     43      0
task_xstate           67     80    512    8    1 : tunables   54   27    8 : slabdata     10     10      0
task_struct          129    144   1776    4    2 : tunables   24   12    8 : slabdata     36     36      0
cred_jar             312    400    192   20    1 : tunables  120   60    8 : slabdata     20     20      0
anon_vma_chain      1785   3619     48   77    1 : tunables  120   60    8 : slabdata     47     47     60
anon_vma            1217   1711     64   59    1 : tunables  120   60    8 : slabdata     29     29      0
pid                  136    210    128   30    1 : tunables  120   60    8 : slabdata      7      7      0
shared_policy_node      0      0     48   77    1 : tunables  120   60    8 : slabdata      0      0      0
numa_policy            0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
radix_tree_node    54739  82677    560    7    1 : tunables   54   27    8 : slabdata  11811  11811      0
idr_layer_cache      231    252    544    7    1 : tunables   54   27    8 : slabdata     36     36      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             3      3  65536    1   16 : tunables    8    4    0 : slabdata      3      3      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384            14     14  16384    1    4 : tunables    8    4    0 : slabdata     14     14      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192             24     32   8192    1    2 : tunables    8    4    0 : slabdata     24     32      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
size-4096            969    969   4096    1    1 : tunables   24   12    8 : slabdata    969    969      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
size-2048            630    630   2048    2    1 : tunables   24   12    8 : slabdata    315    315      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
size-1024            964    964   1024    4    1 : tunables   54   27    8 : slabdata    241    241      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
size-512             700    712    512    8    1 : tunables   54   27    8 : slabdata     89     89    135
size-256(DMA)          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
size-256            3213   3660    256   15    1 : tunables  120   60    8 : slabdata    244    244    120
size-192(DMA)          0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
size-192            1576   2100    192   20    1 : tunables  120   60    8 : slabdata    105    105    420
size-128(DMA)          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
size-64             9046  18408     64   59    1 : tunables  120   60    8 : slabdata    312    312    120
size-32(DMA)           0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
size-128            3990   5790    128   30    1 : tunables  120   60    8 : slabdata    193    193    120
size-32             7846   8064     32  112    1 : tunables  120   60    8 : slabdata     72     72     60
kmem_cache           193    193   4224    1    2 : tunables    8    4    0 : slabdata    193    193      0

==> /proc/vmstat <==
nr_free_pages 50700
nr_inactive_anon 2970
nr_active_anon 1007
nr_inactive_file 11130
nr_active_file 7157
nr_unevictable 0
nr_mlock 0
nr_anon_pages 2938
nr_mapped 363
nr_file_pages 19588
nr_dirty 6664
nr_writeback 0
nr_slab_reclaimable 1186454
nr_slab_unreclaimable 4799
nr_page_table_pages 1006
nr_kernel_stack 117
nr_unstable 0
nr_bounce 0
nr_vmscan_write 443674146
nr_writeback_temp 0
nr_isolated_anon 0
nr_isolated_file 0
nr_shmem 0
nr_dirtied 1979672411
nr_written 394329592
numa_hit 1442613360
numa_miss 0
numa_foreign 0
numa_interleave 14467
numa_local 1442613360
numa_other 0
nr_anon_transparent_hugepages 0
nr_dirty_threshold 14593
nr_dirty_background_threshold 7296
pgpgin 1166783994
pgpgout 1189551831
pswpin 561247
pswpout 527463
pgalloc_dma 1
pgalloc_dma32 817965569
pgalloc_normal 624704577
pgalloc_movable 0
pgfree 1461887065
pgactivate 35670010
pgdeactivate 11575599
pgfault 15571083
pgmajfault 159505
pgrefill_dma 0
pgrefill_dma32 3822790
pgrefill_normal 6083339
pgrefill_movable 0
pgsteal_dma 0
pgsteal_dma32 451541278
pgsteal_normal 317158520
pgsteal_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_dma32 456928166
pgscan_kswapd_normal 1030237072
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_dma32 5453588
pgscan_direct_normal 975367
pgscan_direct_movable 0
zone_reclaim_failed 0
pginodesteal 27622
slabs_scanned 49472512
kswapd_steal 763108137
kswapd_inodesteal 41027944
kswapd_low_wmark_hit_quickly 1660
kswapd_high_wmark_hit_quickly 212270
kswapd_skip_congestion_wait 9497
pageoutrun 6256294
allocstall 43035
pgrotated 2512196
compact_blocks_moved 472304
compact_pages_moved 6499644
compact_pagemigrate_failed 1402982
compact_stall 6988
compact_fail 2641
compact_success 4347
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 26833
unevictable_pgs_scanned 0
unevictable_pgs_rescued 28012
unevictable_pgs_mlocked 28646
unevictable_pgs_munlocked 28629
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
unevictable_pgs_mlockfreed 0
thp_fault_alloc 0
thp_fault_fallback 0
thp_collapse_alloc 0
thp_collapse_alloc_failed 0
thp_split 0


Got another "invalid opcode" in btrfs-fixup-0. That was in the
middle of transfering a 3.6GB file. I've got one and only one of
those during one boot time when doing that rsync.

When the btrfs_inode_cache grew dramatically before the crash,
It was in the middle of transferring an area that had hundreds
of thousands of little files

Any idea anyone?

Best regards,
Stephane
