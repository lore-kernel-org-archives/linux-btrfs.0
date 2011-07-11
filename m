From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Mon, 11 Jul 2011 10:01:21 +0100
Message-ID: <20110711090121.GA2537@yahoo.fr>
References: <20110703190913.GA4474@yahoo.fr>
 <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com>
 <20110706081111.GA6931@yahoo.fr>
 <20110708124429.GB4284@yahoo.fr>
 <1310137241-sup-8158@shiny>
 <20110709170959.GC4294@yahoo.fr>
 <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com>
 <20110709203649.GE4294@yahoo.fr>
 <1310301809-sup-9903@shiny>
 <20110710183728.GB4277@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110710183728.GB4277@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-10 19:37:28 +0100, Stephane Chazelas:
> 2011-07-10 08:44:34 -0400, Chris Mason:
> [...]
> > Great, we're on the right track.  Does it trigger with mount -o compress
> > instead of mount -o compress_force?
> [...]
> 
> It does trigger. I get that same "invalid opcode".
> 
> BTW, I tried with CONFIG_SLUB and slub_debug and no more useful
> information than with SLAB_DEBUG.
> 
> I'm trying now without dmcrypt. Then I won't have much bandwidth
> for testing.
[...]

Same without dmcrypt. So to sum up, BUG() reached in btrfs-fixup
thread when doing an 

- rsync (though I also got (back when on ubuntu and 2.6.38) at
  least one occurrence using bsdtar | bsdtar)
- of a large amount of data (with a large number of files),
  though the bug occurs quite early probably after having
  transfered about 50-100GB
- the source FS being btrfs with compress-force on 3 devices
  (one of which slightly shorter than the others) and a lot of
  subvolumes and snapshots (I'm now copying from read-only
  snapshots but that happened with RW ones as well).
- to a newly created btrfs fs
- on one device (/dev/sdd or dmcrypt)
- mounted with compress or compress-force.

- noatime on either source or dest doesn't make a difference
  (wrt the occurrence of fixup BUG())
- can't reproduce it when dest is not mounted with compress
- beside that BUG(),
- kernel memory is being used up (mostly in
  btrfs_inode_cache) and can't be reclaimed (leading to crash
  with oom killing everybody)
- the target FS can be unmounted but that does not reclaim
  memory. However the *source* FS (that is not the one we tried
  with and without compress) cannot be unmounted (umount hangs,
  see another email for its stack trace).
- Only way to get out of there is reboot with sysrq-b
- happens with 2.6.38, 2.6.39, 3.0.0rc6
- CONFIG_SLAB_DEBUG, CONFIG_DEBUG_PAGEALLOC,
  CONFIG_DEBUG_SLAB_LEAK, slub_debug don't tell us anything
  useful (there's more info in /proc/slabinfo when
  CONFIG_SLAB_DEBUG is on, see below)
- happens with CONFIG_SLUB as well.


slabinfo every about 60-70 seconds which include the "globalstats"

slabinfo - version: 2.1 (statistics)
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail> : globalst
at <listallocs> <maxobjs> <grown> <reaped> <error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow> : cpustat <allochit> <allocmiss> <freehit> <freemiss>
btrfs_inode_cache  77610  77610   4096    1    1 : tunables   24   12    8 : slabdata  77610  77610      0 : globalstat   77610  77610 77610    0    0    0    0    0    0 : cpustat    104  77609     98      5
btrfs_inode_cache 165696 165696   4096    1    1 : tunables   24   12    8 : slabdata 165696 165696      0 : globalstat  174592 166889 173117    0    0   37    8    0    0 : cpustat  14375 174178  21198   1659
btrfs_inode_cache 173906 173906   4096    1    1 : tunables   24   12    8 : slabdata 173906 173906      0 : globalstat  231342 196133 228848    8    0   37    8    0    0 : cpustat  24914 230649  75318   6338
btrfs_inode_cache 201190 201190   4096    1    1 : tunables   24   12    8 : slabdata 201190 201190      0 : globalstat  338963 201190 331454    8    0   38   11    0    0 : cpustat  53954 335583 173512  14834
btrfs_inode_cache 224106 224143   4096    1    1 : tunables   24   12    8 : slabdata 224106 224143     96 : globalstat  453173 267189 442101    8    0   38   13    0    0 : cpustat  77063 448023 277242  23875
btrfs_inode_cache 126520 126520   4096    1    1 : tunables   24   12    8 : slabdata 126520 126520      0 : globalstat  486327 267189 472461   32    0   38   13    0    0 : cpustat  96675 479904 414073  35992
btrfs_inode_cache 144723 144723   4096    1    1 : tunables   24   12    8 : slabdata 144723 144723      0 : globalstat  537600 267189 521248   32    0   38   15    0    0 : cpustat 114446 530048 459922  39849
btrfs_inode_cache 176590 176590   4096    1    1 : tunables   24   12    8 : slabdata 176590 176590      0 : globalstat  626027 267189 605212   32    0   38   35    0    0 : cpustat 142336 616188 535659  46275
btrfs_inode_cache 225715 225752   4096    1    1 : tunables   24   12    8 : slabdata 225715 225752     96 : globalstat  766387 267189 739439   32    0   38   60    0    0 : cpustat 181607 753564 653165  56404
btrfs_inode_cache 179039 179076   4096    1    1 : tunables   24   12    8 : slabdata 179039 179076     84 : globalstat  821296 267189 793315   48    0   38   60    0    0 : cpustat 189640 808027 753396  65349
btrfs_inode_cache 139572 139609   4096    1    1 : tunables   24   12    8 : slabdata 139572 139609     96 : globalstat  890513 267189 858553   56    0   38   60    0    0 : cpustat 214964 875265 874796  75992
btrfs_inode_cache 122064 122101   4096    1    1 : tunables   24   12    8 : slabdata 122064 122101     96 : globalstat  936515 267189 903015   72    0   38   66    0    0 : cpustat 230345 920877 947006  82282
btrfs_inode_cache 136431 136468   4096    1    1 : tunables   24   12    8 : slabdata 136431 136468     96 : globalstat 1001394 267189 963758   88    0   38   67    0    0 : cpustat 256274 983686 1015526  88131
btrfs_inode_cache 111428 111465   4096    1    1 : tunables   24   12    8 : slabdata 111428 111465     96 : globalstat 1047868 267189 1007092   88    0   38   67    0    0 : cpustat 278315 1028765 1100279  95502
btrfs_inode_cache 143308 143308   4096    1    1 : tunables   24   12    8 : slabdata 143308 143308      0 : globalstat 1122732 267189 1078759   88    0   38   67    0    0 : cpustat 298923 1102028 1157303 100340
btrfs_inode_cache 108761 108798   4096    1    1 : tunables   24   12    8 : slabdata 108761 108798     96 : globalstat 1180806 267189 1133334  104    0   38   67    0    0 : cpustat 319122 1158203 1259376 109306
btrfs_inode_cache 144115 144152   4096    1    1 : tunables   24   12    8 : slabdata 144115 144152     84 : globalstat 1259003 267189 1208854  104    0   38   76    0    0 : cpustat 338025 1235163 1315124 114040
btrfs_inode_cache 138492 138529   4096    1    1 : tunables   24   12    8 : slabdata 138492 138529     36 : globalstat 1316265 267189 1264558  120    0   38   76    0    0 : cpustat 352376 1291923 1385679 120174
btrfs_inode_cache 125898 125898   4096    1    1 : tunables   24   12    8 : slabdata 125898 125898      0 : globalstat 1379943 267189 1323790  120    0   38   76    0    0 : cpustat 377547 1353189 1476746 128097
btrfs_inode_cache 143074 143111   4096    1    1 : tunables   24   12    8 : slabdata 143074 143111     72 : globalstat 1460219 267189 1399985  120    0   38   84    0    0 : cpustat 403813 1431515 1557263 135070
btrfs_inode_cache 140767 140804   4096    1    1 : tunables   24   12    8 : slabdata 140767 140804     96 : globalstat 1530279 267189 1466920  120    0   38   89    0    0 : cpustat 426902 1500267 1643922 142597
btrfs_inode_cache 122322 122359   4096    1    1 : tunables   24   12    8 : slabdata 122322 122359     96 : globalstat 1580762 267189 1514531  120    0   38   89    0    0 : cpustat 450503 1549707 1728127 149872
btrfs_inode_cache 167295 167332   4096    1    1 : tunables   24   12    8 : slabdata 167295 167332     72 : globalstat 1685301 267189 1613571  120    0   38   91    0    0 : cpustat 488967 1651795 1816243 157318
btrfs_inode_cache 129692 129729   4096    1    1 : tunables   24   12    8 : slabdata 129692 129729     84 : globalstat 1752216 267189 1677321  120    0   38  105    0    0 : cpustat 511333 1717315 1931582 167479
btrfs_inode_cache 133930 133967   4096    1    1 : tunables   24   12    8 : slabdata 133930 133967     84 : globalstat 1815698 267189 1736104  136    0   38  105    0    0 : cpustat 542451 1778567 2012803 174401
btrfs_inode_cache 115171 115208   4096    1    1 : tunables   24   12    8 : slabdata 115171 115208      0 : globalstat 1863438 267189 1780512  144    0   38  110    0    0 : cpustat 566046 1824830 2094266 181449
btrfs_inode_cache 149671 149671   4096    1    1 : tunables   24   12    8 : slabdata 149671 149671      0 : globalstat 1936523 267189 1850671  152    0   38  111    0    0 : cpustat 589089 1896761 2150041 186138
btrfs_inode_cache 117604 117641   4096    1    1 : tunables   24   12    8 : slabdata 117604 117641     96 : globalstat 1985533 267189 1896777  152    0   38  118    0    0 : cpustat 609612 1944469 2242380 194207
btrfs_inode_cache 123673 123710   4096    1    1 : tunables   24   12    8 : slabdata 123673 123710     96 : globalstat 2061550 267189 1969892  152    0   38  118    0    0 : cpustat 628820 2019061 2323136 201208
btrfs_inode_cache 106536 106536   4096    1    1 : tunables   24   12    8 : slabdata 106536 106536      0 : globalstat 2123063 267189 2027404  152    0   38  128    0    0 : cpustat 652365 2078445 2415076 209202
btrfs_inode_cache 123158 123195   4096    1    1 : tunables   24   12    8 : slabdata 123158 123195     96 : globalstat 2192496 267189 2091447  152    0   38  129    0    0 : cpustat 684828 2145107 2491235 215680
btrfs_inode_cache 111398 111435   4096    1    1 : tunables   24   12    8 : slabdata 111398 111435     96 : globalstat 2241767 267189 2137427  160    0   38  130    0    0 : cpustat 706721 2192791 2566095 222131
btrfs_inode_cache 116173 116210   4096    1    1 : tunables   24   12    8 : slabdata 116173 116210     48 : globalstat 2322912 267189 2214790  176    0   38  132    0    0 : cpustat 728839 2271902 2654784 229845
btrfs_inode_cache 105739 105739   4096    1    1 : tunables   24   12    8 : slabdata 105739 105739      0 : globalstat 2375200 267189 2264543  200    0   38  133    0    0 : cpustat 750581 2323318 2731690 236469
btrfs_inode_cache  99891  99928   4096    1    1 : tunables   24   12    8 : slabdata  99891  99928     96 : globalstat 2428901 267189 2316644  200    0   38  144    0    0 : cpustat 767974 2376721 2802354 242572
btrfs_inode_cache 109472 109509   4096    1    1 : tunables   24   12    8 : slabdata 109472 109509     96 : globalstat 2481915 267189 2367557  200    0   38  156    0    0 : cpustat 783035 2428814 2855341 247151
btrfs_inode_cache 106089 106126   4096    1    1 : tunables   24   12    8 : slabdata 106089 106126     84 : globalstat 2539989 267189 2422799  200    0   38  156    0    0 : cpustat 805498 2485800 2931573 253725
btrfs_inode_cache 104047 104084   4096    1    1 : tunables   24   12    8 : slabdata 104047 104084     96 : globalstat 2595552 267189 2475236  200    0   38  163    0    0 : cpustat 826719 2539916 3002833 259878
btrfs_inode_cache 126659 126696   4096    1    1 : tunables   24   12    8 : slabdata 126659 126696     96 : globalstat 2674478 267189 2550480  200    0   38  165    0    0 : cpustat 851791 2617102 3076213 266133
btrfs_inode_cache  94805  94842   4096    1    1 : tunables   24   12    8 : slabdata  94805  94842     96 : globalstat 2716094 267189 2589363  208    0   38  171    0    0 : cpustat 869515 2657400 3158839 273386
btrfs_inode_cache 136610 136610   4096    1    1 : tunables   24   12    8 : slabdata 136610 136610     72 : globalstat 2808055 267189 2675923  208    0   38  175    0    0 : cpustat 902598 2746580 3233055 279621
btrfs_inode_cache  57696  57733   4096    1    1 : tunables   24   12    8 : slabdata  57696  57733     96 : globalstat 2830215 267189 2697211  320    0   38  176    0    0 : cpustat 908085 2768282 3330428 288354
btrfs_inode_cache  18159  18196   4096    1    1 : tunables   24   12    8 : slabdata  18159  18196     96 : globalstat 2830274 267189 2697233  496    0   38  176    0    0 : cpustat 908209 2768316 3366842 291639
btrfs_inode_cache  41004  41004   4096    1    1 : tunables   24   12    8 : slabdata  41004  41004      0 : globalstat 2857575 267189 2723805  496    0   38  179    0    0 : cpustat 914262 2795352 3376245 292389
btrfs_inode_cache  93730  93767   4096    1    1 : tunables   24   12    8 : slabdata  93730  93767     84 : globalstat 2921315 267189 2786290  504    0   38  179    0    0 : cpustat 929670 2858965 3400706 294314
btrfs_inode_cache  57785  57822   4096    1    1 : tunables   24   12    8 : slabdata  57785  57822     96 : globalstat 2948640 267189 2812472  600    0   38  179    0    0 : cpustat 937340 2885746 3465355 300056
btrfs_inode_cache  19440  19477   4096    1    1 : tunables   24   12    8 : slabdata  19440  19477     96 : globalstat 2948640 267189 2812472  776    0   38  179    0    0 : cpustat 937340 2885746 3500561 303227
btrfs_inode_cache  13020  13057   4096    1    1 : tunables   24   12    8 : slabdata  13020  13057     96 : globalstat 2948640 267189 2812472  952    0   38  179    0    0 : cpustat 937340 2885746 3506433 303739
btrfs_inode_cache   9951   9981   4096    1    1 : tunables   24   12    8 : slabdata   9951   9981     76 : globalstat 2948640 267189 2812472 1128    0   38  179    0    0 : cpustat 937340 2885746 3509252 303970
btrfs_inode_cache   8508   8537   4096    1    1 : tunables   24   12    8 : slabdata   8508   8537     36 : globalstat 2948640 267189 2812472 1304    0   38  179    0    0 : cpustat 937342 2885746 3510539 304077
btrfs_inode_cache   8077   8101   4096    1    1 : tunables   24   12    8 : slabdata   8077   8101     96 : globalstat 2948640 267189 2812472 1469    0   38  179    0    0 : cpustat 937342 2885746 3511014 304114
btrfs_inode_cache   6656   6693   4096    1    1 : tunables   24   12    8 : slabdata   6656   6693     96 : globalstat 2948664 267189 2812472 1643    0   38  179    0    0 : cpustat 937385 2885751 3512371 304225
btrfs_inode_cache   6747   6781   4096    1    1 : tunables   24   12    8 : slabdata   6747   6781     76 : globalstat 2949480 267189 2813259 1798    0   38  179    0    0 : cpustat 937488 2886550 3513094 304280
btrfs_inode_cache   6257   6294   4096    1    1 : tunables   24   12    8 : slabdata   6257   6294     96 : globalstat 2949480 267189 2813259 1899    0   38  179    0    0 : cpustat 937488 2886550 3513575 304318
btrfs_inode_cache   4848   4848   4096    1    1 : tunables   24   12    8 : slabdata   4848   4848      0 : globalstat 2949480 267189 2813259 2033    0   38  179    0    0 : cpustat 937488 2886550 3514773 304417
btrfs_inode_cache   4839   4839   4096    1    1 : tunables   24   12    8 : slabdata   4839   4839      0 : globalstat 2949480 267189 2813259 2042    0   38  179    0    0 : cpustat 937488 2886550 3514782 304417
btrfs_inode_cache   4806   4814   4096    1    1 : tunables   24   12    8 : slabdata   4806   4814      6 : globalstat 2949482 267189 2813261 2069    0   38  179    0    0 : cpustat 937488 2886552 3514827 304418
btrfs_inode_cache   4490   4497   4096    1    1 : tunables   24   12    8 : slabdata   4490   4497      0 : globalstat 2949482 267189 2813261 2236    0   38  179    0    0 : cpustat 937494 2886556 3515125 304435
btrfs_inode_cache   4054   4085   4096    1    1 : tunables   24   12    8 : slabdata   4054   4085     56 : globalstat 2949482 267189 2813261 2430    0   38  179    0    0 : cpustat 937495 2886559 3515591 304466
btrfs_inode_cache   3972   3989   4096    1    1 : tunables   24   12    8 : slabdata   3972   3989     64 : globalstat 2949482 267189 2813261 2499    0   38  179    0    0 : cpustat 937495 2886559 3515690 304473
btrfs_inode_cache   3698   3727   4096    1    1 : tunables   24   12    8 : slabdata   3698   3727     36 : globalstat 2949487 267189 2813266 2600    0   38  179    0    0 : cpustat 937496 2886564 3515912 304488
btrfs_inode_cache   3189   3189   4096    1    1 : tunables   24   12    8 : slabdata   3189   3189      0 : globalstat 2949488 267189 2813266 2784    0   38  179    0    0 : cpustat 937496 2886568 3516353 304522
btrfs_inode_cache   3193   3193   4096    1    1 : tunables   24   12    8 : slabdata   3193   3193      0 : globalstat 2949492 267189 2813270 2784    0   38  179    0    0 : cpustat 937496 2886572 3516353 304522
btrfs_inode_cache   2861   2861   4096    1    1 : tunables   24   12    8 : slabdata   2861   2861      0 : globalstat 2949494 267189 2813272 2917    0   38  179    0    0 : cpustat 937496 2886574 3516664 304545
btrfs_inode_cache   2706   2706   4096    1    1 : tunables   24   12    8 : slabdata   2706   2706      0 : globalstat 2949494 267189 2813272 3021    0   38  179    0    0 : cpustat 937496 2886574 3516809 304555
btrfs_inode_cache   2709   2709   4096    1    1 : tunables   24   12    8 : slabdata   2709   2709      0 : globalstat 2949497 267189 2813275 3021    0   38  179    0    0 : cpustat 937496 2886577 3516809 304555
btrfs_inode_cache   2610   2610   4096    1    1 : tunables   24   12    8 : slabdata   2610   2610      0 : globalstat 2949505 267189 2813283 3086    0   38  179    0    0 : cpustat 937496 2886585 3516909 304562
btrfs_inode_cache   2610   2610   4096    1    1 : tunables   24   12    8 : slabdata   2610   2610      0 : globalstat 2949505 267189 2813283 3086    0   38  179    0    0 : cpustat 937496 2886585 3516909 304562
btrfs_inode_cache   2502   2502   4096    1    1 : tunables   24   12    8 : slabdata   2502   2502      0 : globalstat 2949506 267189 2813284 3163    0   38  179    0    0 : cpustat 937496 2886586 3517010 304570
btrfs_inode_cache   2493   2496   4096    1    1 : tunables   24   12    8 : slabdata   2493   2496      6 : globalstat 2949508 267189 2813286 3171    0   38  179    0    0 : cpustat 937496 2886588 3517035 304571
btrfs_inode_cache   2350   2350   4096    1    1 : tunables   24   12    8 : slabdata   2350   2350      0 : globalstat 2949508 267189 2813286 3266    0   38  179    0    0 : cpustat 937496 2886588 3517154 304580
btrfs_inode_cache   2237   2249   4096    1    1 : tunables   24   12    8 : slabdata   2237   2249      1 : globalstat 2949510 267189 2813288 3330    0   38  179    0    0 : cpustat 937496 2886590 3517262 304588
btrfs_inode_cache   2238   2238   4096    1    1 : tunables   24   12    8 : slabdata   2238   2238      0 : globalstat 2949512 267189 2813290 3343    0   38  179    0    0 : cpustat 937496 2886592 3517262 304588
btrfs_inode_cache   2238   2238   4096    1    1 : tunables   24   12    8 : slabdata   2238   2238      0 : globalstat 2949512 267189 2813290 3343    0   38  179    0    0 : cpustat 937496 2886592 3517262 304588
btrfs_inode_cache   2585   2585   4096    1    1 : tunables   24   12    8 : slabdata   2585   2585      0 : globalstat 2950149 267189 2813886 3439    0   38  179    0    0 : cpustat 937538 2887195 3517538 304610
btrfs_inode_cache  43128  43165   4096    1    1 : tunables   24   12    8 : slabdata  43128  43165     96 : globalstat 2991028 267189 2854761 3447    0   38  179    0    0 : cpustat 938115 2928095 3518521 304676
btrfs_inode_cache  32454  32491   4096    1    1 : tunables   24   12    8 : slabdata  32454  32491     96 : globalstat 2992689 267189 2856322 3519    0   38  179    0    0 : cpustat 939186 2929734 3530831 305766
btrfs_inode_cache  17499  17536   4096    1    1 : tunables   24   12    8 : slabdata  17499  17536     96 : globalstat 2993106 267189 2856673 3679    0   38  179    0    0 : cpustat 940032 2930139 3545708 307087

===> BUG() occurred here <===

btrfs_inode_cache  15331  15368   4096    1    1 : tunables   24   12    8 : slabdata  15331  15368     96 : globalstat 2995554 267189 2859045 3839    0   38  179    0    0 : cpustat 940758 2932563 3550613 307502
btrfs_inode_cache  31639  31639   4096    1    1 : tunables   24   12    8 : slabdata  31639  31639      0 : globalstat 3014974 267189 2877988 3855    0   38  179    0    0 : cpustat 945598 2951863 3557779 308061
btrfs_inode_cache  33820  33857   4096    1    1 : tunables   24   12    8 : slabdata  33820  33857     96 : globalstat 3023329 267189 2886224 3919    0   38  179    0    0 : cpustat 948158 2960257 3565994 308729
btrfs_inode_cache  51992  51992   4096    1    1 : tunables   24   12    8 : slabdata  51992  51992      0 : globalstat 3055265 267189 2917703 3991    0   38  180    0    0 : cpustat 953344 2992092 3583268 310175
btrfs_inode_cache  57834  57871   4096    1    1 : tunables   24   12    8 : slabdata  57834  57871     96 : globalstat 3073251 267189 2935329 4079    0   38  180    0    0 : cpustat 959228 3010099 3600080 311533
btrfs_inode_cache  22835  22872   4096    1    1 : tunables   24   12    8 : slabdata  22835  22872     96 : globalstat 3073974 267189 2936003 4247    0   38  180    0    0 : cpustat 959857 3010802 3633418 314528
btrfs_inode_cache  12362  12399   4096    1    1 : tunables   24   12    8 : slabdata  12362  12399     96 : globalstat 3073974 267189 2936003 4423    0   38  180    0    0 : cpustat 960103 3010813 3643282 315396
btrfs_inode_cache   8133   8170   4096    1    1 : tunables   24   12    8 : slabdata   8133   8170     96 : globalstat 3074309 267189 2936309 4591    0   38  180    0    0 : cpustat 960590 3011150 3647944 315791
btrfs_inode_cache   6556   6585   4096    1    1 : tunables   24   12    8 : slabdata   6556   6585     84 : globalstat 3074598 267189 2936569 4751    0   38  180    0    0 : cpustat 961159 3011447 3650181 315967
btrfs_inode_cache   5780   5817   4096    1    1 : tunables   24   12    8 : slabdata   5780   5817     96 : globalstat 3075142 267189 2937027 4879    0   38  180    0    0 : cpustat 961655 3011946 3651838 316093
btrfs_inode_cache   4959   4960   4096    1    1 : tunables   24   12    8 : slabdata   4959   4960      0 : globalstat 3075142 267189 2937027 5055    0   38  180    0    0 : cpustat 961663 3011947 3652506 316145
btrfs_inode_cache   4674   4674   4096    1    1 : tunables   24   12    8 : slabdata   4674   4674      0 : globalstat 3075176 267189 2937027 5220    0   38  180    0    0 : cpustat 961682 3011952 3652815 316162
btrfs_inode_cache   4569   4580   4096    1    1 : tunables   24   12    8 : slabdata   4569   4580      0 : globalstat 3075448 267189 2937270 5341    0   38  180    0    0 : cpustat 961863 3012211 3653321 316196
btrfs_inode_cache   4895   4900   4096    1    1 : tunables   24   12    8 : slabdata   4895   4900     48 : globalstat 3075986 267189 2937735 5468    0   38  180    0    0 : cpustat 961990 3012691 3653642 316212
btrfs_inode_cache   2943   2966   4096    1    1 : tunables   24   12    8 : slabdata   2943   2966      6 : globalstat 3076416 267189 2938145 5628    0   38  180    0    0 : cpustat 962105 3013112 3655887 316400
btrfs_inode_cache   3694   3731   4096    1    1 : tunables   24   12    8 : slabdata   3694   3731     96 : globalstat 3077820 267189 2939533 5769    0   38  180    0    0 : cpustat 962156 3014505 3656631 316454
btrfs_inode_cache   3458   3458   4096    1    1 : tunables   24   12    8 : slabdata   3458   3458      0 : globalstat 3077826 267189 2939539 5894    0   38  180    0    0 : cpustat 962161 3014512 3656751 316464
btrfs_inode_cache   3208   3237   4096    1    1 : tunables   24   12    8 : slabdata   3208   3237     36 : globalstat 3077838 267189 2939539 6019    0   38  180    0    0 : cpustat 962167 3014516 3657029 316482
btrfs_inode_cache   3100   3113   4096    1    1 : tunables   24   12    8 : slabdata   3100   3113      0 : globalstat 3077866 267189 2939543 6130    0   38  180    0    0 : cpustat 962169 3014526 3657110 316486
btrfs_inode_cache   2967   2994   4096    1    1 : tunables   24   12    8 : slabdata   2967   2994     40 : globalstat 3077886 267189 2939545 6236    0   38  180    0    0 : cpustat 962175 3014532 3657284 316496
btrfs_inode_cache   2840   2840   4096    1    1 : tunables   24   12    8 : slabdata   2840   2840      0 : globalstat 3077900 267189 2939547 6335    0   38  180    0    0 : cpustat 962178 3014535 3657372 316501
btrfs_inode_cache   2735   2735   4096    1    1 : tunables   24   12    8 : slabdata   2735   2735      0 : globalstat 3078008 267189 2939604 6445    0   38  180    0    0 : cpustat 962232 3014600 3657585 316512
btrfs_inode_cache   2374   2397   4096    1    1 : tunables   24   12    8 : slabdata   2374   2397      1 : globalstat 3078022 267189 2939606 6589    0   38  180    0    0 : cpustat 962237 3014607 3657935 316536
btrfs_inode_cache   2143   2172   4096    1    1 : tunables   24   12    8 : slabdata   2143   2172     36 : globalstat 3078125 267189 2939680 6707    0   38  180    0    0 : cpustat 962290 3014689 3658308 316564
btrfs_inode_cache   1522   1544   4096    1    1 : tunables   24   12    8 : slabdata   1522   1544     52 : globalstat 3078134 267189 2939680 6875    0   38  180    0    0 : cpustat 962298 3014693 3658918 316613
btrfs_inode_cache   1210   1239   4096    1    1 : tunables   24   12    8 : slabdata   1210   1239     24 : globalstat 3078138 267189 2939684 7007    0   38  180    0    0 : cpustat 962302 3014701 3659193 316634
btrfs_inode_cache    898    927   4096    1    1 : tunables   24   12    8 : slabdata    898    927     76 : globalstat 3078151 267189 2939684 7167    0   38  180    0    0 : cpustat 962338 3014709 3659562 316664
btrfs_inode_cache    714    714   4096    1    1 : tunables   24   12    8 : slabdata    714    714     12 : globalstat 3078157 267189 2939690 7268    0   38  180    0    0 : cpustat 962343 3014716 3659706 316672
btrfs_inode_cache    414    414   4096    1    1 : tunables   24   12    8 : slabdata    414    414      0 : globalstat 3078173 267189 2939694 7367    0   38  180    0    0 : cpustat 962344 3014723 3659959 316694
btrfs_inode_cache    424    424   4096    1    1 : tunables   24   12    8 : slabdata    424    424      0 : globalstat 3078183 267189 2939704 7367    0   38  180    0    0 : cpustat 962344 3014733 3659959 316694
btrfs_inode_cache    504    504   4096    1    1 : tunables   24   12    8 : slabdata    504    504      0 : globalstat 3078263 267189 2939784 7367    0   38  180    0    0 : cpustat 962344 3014813 3659959 316694
btrfs_inode_cache    528    528   4096    1    1 : tunables   24   12    8 : slabdata    528    528      0 : globalstat 3078287 267189 2939808 7367    0   38  180    0    0 : cpustat 962344 3014837 3659959 316694
btrfs_inode_cache    473    473   4096    1    1 : tunables   24   12    8 : slabdata    473    473      0 : globalstat 3078304 267189 2939820 7424    0   38  180    0    0 : cpustat 962350 3014851 3660029 316699
btrfs_inode_cache    493    493   4096    1    1 : tunables   24   12    8 : slabdata    493    493      0 : globalstat 3078324 267189 2939840 7424    0   38  180    0    0 : cpustat 962350 3014871 3660029 316699
btrfs_inode_cache    463    463   4096    1    1 : tunables   24   12    8 : slabdata    463    463      0 : globalstat 3078348 267189 2939852 7466    0   38  180    0    0 : cpustat 962352 3014885 3660073 316701
btrfs_inode_cache    483    483   4096    1    1 : tunables   24   12    8 : slabdata    483    483      0 : globalstat 3078368 267189 2939872 7466    0   38  180    0    0 : cpustat 962352 3014905 3660073 316701
btrfs_inode_cache    553    553   4096    1    1 : tunables   24   12    8 : slabdata    553    553      0 : globalstat 3078438 267189 2939942 7466    0   38  180    0    0 : cpustat 962352 3014975 3660073 316701
btrfs_inode_cache    537    537   4096    1    1 : tunables   24   12    8 : slabdata    537    537      0 : globalstat 3078486 267189 2939990 7527    0   38  180    0    0 : cpustat 962375 3015024 3660155 316707
btrfs_inode_cache    544    544   4096    1    1 : tunables   24   12    8 : slabdata    544    544      0 : globalstat 3078501 267189 2940004 7534    0   38  180    0    0 : cpustat 962376 3015039 3660164 316707
btrfs_inode_cache    568    568   4096    1    1 : tunables   24   12    8 : slabdata    568    568      0 : globalstat 3078525 267189 2940028 7534    0   38  180    0    0 : cpustat 962376 3015063 3660164 316707
btrfs_inode_cache    537    537   4096    1    1 : tunables   24   12    8 : slabdata    537    537      0 : globalstat 3078537 267189 2940040 7577    0   38  180    0    0 : cpustat 962380 3015075 3660209 316709
btrfs_inode_cache    531    531   4096    1    1 : tunables   24   12    8 : slabdata    531    531      0 : globalstat 3078563 267189 2940066 7609    0   38  180    0    0 : cpustat 962383 3015102 3660244 316710
btrfs_inode_cache    523    523   4096    1    1 : tunables   24   12    8 : slabdata    523    523      0 : globalstat 3078583 267189 2940082 7633    0   38  180    0    0 : cpustat 962385 3015120 3660271 316711
btrfs_inode_cache    535    535   4096    1    1 : tunables   24   12    8 : slabdata    535    535      0 : globalstat 3078631 267189 2940130 7669    0   38  180    0    0 : cpustat 962388 3015169 3660309 316713
btrfs_inode_cache    548    548   4096    1    1 : tunables   24   12    8 : slabdata    548    548      0 : globalstat 3078699 267189 2940180 7706    0   38  180    0    0 : cpustat 962425 3015224 3660385 316716
btrfs_inode_cache    558    558   4096    1    1 : tunables   24   12    8 : slabdata    558    558      0 : globalstat 3078709 267189 2940190 7706    0   38  180    0    0 : cpustat 962425 3015234 3660385 316716
btrfs_inode_cache    568    568   4096    1    1 : tunables   24   12    8 : slabdata    568    568      0 : globalstat 3078719 267189 2940200 7706    0   38  180    0    0 : cpustat 962425 3015244 3660385 316716
btrfs_inode_cache    542    542   4096    1    1 : tunables   24   12    8 : slabdata    542    542      0 : globalstat 3078731 267189 2940208 7740    0   38  180    0    0 : cpustat 962426 3015253 3660420 316717
btrfs_inode_cache    524    524   4096    1    1 : tunables   24   12    8 : slabdata    524    524      0 : globalstat 3078743 267189 2940220 7770    0   38  180    0    0 : cpustat 962426 3015265 3660449 316718
btrfs_inode_cache    500    500   4096    1    1 : tunables   24   12    8 : slabdata    500    500      0 : globalstat 3078755 267189 2940228 7802    0   38  180    0    0 : cpustat 962427 3015275 3660485 316720
btrfs_inode_cache    467    467   4096    1    1 : tunables   24   12    8 : slabdata    467    467      0 : globalstat 3078759 267189 2940232 7839    0   38  180    0    0 : cpustat 962431 3015280 3660522 316722
btrfs_inode_cache    429    429   4096    1    1 : tunables   24   12    8 : slabdata    429    429      0 : globalstat 3078763 267189 2940236 7881    0   38  180    0    0 : cpustat 962434 3015285 3660566 316724
btrfs_inode_cache    404    404   4096    1    1 : tunables   24   12    8 : slabdata    404    404      0 : globalstat 3078778 267189 2940246 7916    0   38  180    0    0 : cpustat 962436 3015297 3660603 316726
btrfs_inode_cache    420    420   4096    1    1 : tunables   24   12    8 : slabdata    420    420      0 : globalstat 3078794 267189 2940262 7916    0   38  180    0    0 : cpustat 962436 3015313 3660603 316726
btrfs_inode_cache    545    545   4096    1    1 : tunables   24   12    8 : slabdata    545    545      0 : globalstat 3078968 267189 2940414 7943    0   38  180    0    0 : cpustat 962543 3015475 3660738 316735
btrfs_inode_cache    520    520   4096    1    1 : tunables   24   12    8 : slabdata    520    520      0 : globalstat 3078972 267189 2940418 7972    0   38  180    0    0 : cpustat 962545 3015479 3660768 316736
btrfs_inode_cache    550    550   4096    1    1 : tunables   24   12    8 : slabdata    550    550      0 : globalstat 3079002 267189 2940448 7972    0   38  180    0    0 : cpustat 962545 3015509 3660768 316736
btrfs_inode_cache    567    567   4096    1    1 : tunables   24   12    8 : slabdata    567    567      0 : globalstat 3079057 267189 2940481 7988    0   38  180    0    0 : cpustat 962554 3015546 3660796 316737
btrfs_inode_cache    582    597   4096    1    1 : tunables   24   12    8 : slabdata    582    597      0 : globalstat 3079107 267189 2940519 7996    0   38  180    0    0 : cpustat 962563 3015587 3660837 316739
btrfs_inode_cache    574    574   4096    1    1 : tunables   24   12    8 : slabdata    574    574      0 : globalstat 3079107 267189 2940519 8019    0   38  180    0    0 : cpustat 962563 3015587 3660837 316739
btrfs_inode_cache    621    621   4096    1    1 : tunables   24   12    8 : slabdata    621    621      0 : globalstat 3079185 267189 2940597 8050    0   38  180    0    0 : cpustat 962564 3015666 3660869 316740
btrfs_inode_cache    614    614   4096    1    1 : tunables   24   12    8 : slabdata    614    614     24 : globalstat 3079193 267189 2940603 8063    0   38  180    0    0 : cpustat 962565 3015673 3660920 316742
btrfs_inode_cache    548    548   4096    1    1 : tunables   24   12    8 : slabdata    548    548      0 : globalstat 3079201 267189 2940605 8131    0   38  180    0    0 : cpustat 962566 3015676 3660951 316743
btrfs_inode_cache    532    532   4096    1    1 : tunables   24   12    8 : slabdata    532    532      0 : globalstat 3079209 267189 2940613 8155    0   38  180    0    0 : cpustat 962567 3015685 3660976 316744
btrfs_inode_cache    538    538   4096    1    1 : tunables   24   12    8 : slabdata    538    538      0 : globalstat 3079215 267189 2940619 8155    0   38  180    0    0 : cpustat 962567 3015691 3660976 316744
btrfs_inode_cache    523    523   4096    1    1 : tunables   24   12    8 : slabdata    523    523      0 : globalstat 3079233 267189 2940637 8188    0   38  180    0    0 : cpustat 962567 3015709 3661008 316745
btrfs_inode_cache    450    450   4096    1    1 : tunables   24   12    8 : slabdata    450    450      0 : globalstat 3079248 267189 2940645 8269    0   38  180    0    0 : cpustat 962573 3015721 3661095 316749
btrfs_inode_cache    430    431   4096    1    1 : tunables   24   12    8 : slabdata    430    431      0 : globalstat 3079276 267189 2940663 8306    0   38  180    0    0 : cpustat 962576 3015742 3661137 316751
btrfs_inode_cache    452    452   4096    1    1 : tunables   24   12    8 : slabdata    452    452      0 : globalstat 3079298 267189 2940685 8307    0   38  180    0    0 : cpustat 962576 3015764 3661137 316751
btrfs_inode_cache    451    456   4096    1    1 : tunables   24   12    8 : slabdata    451    456      0 : globalstat 3079327 267189 2940705 8323    0   38  180    0    0 : cpustat 962596 3015786 3661178 316753
btrfs_inode_cache   8029   8029   4096    1    1 : tunables   24   12    8 : slabdata   8029   8029      0 : globalstat 3086904 267189 2948278 8323    0   38  181    0    0 : cpustat 962730 3023366 3661308 316759
btrfs_inode_cache  17518  17518   4096    1    1 : tunables   24   12    8 : slabdata  17518  17518      0 : globalstat 3096531 267189 2957868 8368    0   38  181    0    0 : cpustat 962826 3032963 3661505 316766
btrfs_inode_cache  28854  28854   4096    1    1 : tunables   24   12    8 : slabdata  28854  28854      0 : globalstat 3107867 267189 2969204 8368    0   38  181    0    0 : cpustat 964636 3044394 3663315 316861
btrfs_inode_cache  28291  28291   4096    1    1 : tunables   24   12    8 : slabdata  28291  28291      0 : globalstat 3111532 267189 2972799 8416    0   38  181    0    0 : cpustat 965771 3048049 3668262 317267
btrfs_inode_cache  22247  22284   4096    1    1 : tunables   24   12    8 : slabdata  22247  22284     96 : globalstat 3112396 267189 2973663 8552    0   38  181    0    0 : cpustat 966145 3048940 3675091 317863
btrfs_inode_cache  16030  16067   4096    1    1 : tunables   24   12    8 : slabdata  16030  16067     96 : globalstat 3112396 267189 2973663 8752    0   38  181    0    0 : cpustat 966150 3048942 3680817 318363
btrfs_inode_cache  12213  12250   4096    1    1 : tunables   24   12    8 : slabdata  12213  12250     96 : globalstat 3112396 267189 2973663 8920    0   38  181    0    0 : cpustat 966159 3048942 3684344 318662
btrfs_inode_cache   7999   8028   4096    1    1 : tunables   24   12    8 : slabdata   7999   8028     76 : globalstat 3112396 267189 2973663 9096    0   38  181    0    0 : cpustat 966164 3048942 3688211 318991
btrfs_inode_cache   5993   6030   4096    1    1 : tunables   24   12    8 : slabdata   5993   6030     96 : globalstat 3113173 267189 2974384 9232    0   38  181    0    0 : cpustat 966667 3049702 3691264 319242
btrfs_inode_cache   4797   4824   4096    1    1 : tunables   24   12    8 : slabdata   4797   4824      4 : globalstat 3113173 267189 2974384 9416    0   38  181    0    0 : cpustat 966684 3049706 3692276 319321
btrfs_inode_cache   4443   4472   4096    1    1 : tunables   24   12    8 : slabdata   4443   4472     28 : globalstat 3113188 267189 2974384 9592    0   38  181    0    0 : cpustat 966688 3049712 3692652 319341
btrfs_inode_cache   4365   4402   4096    1    1 : tunables   24   12    8 : slabdata   4365   4402     96 : globalstat 3114014 267189 2975171 9669    0   38  181    0    0 : cpustat 966797 3050510 3693639 319422
btrfs_inode_cache   3011   3040   4096    1    1 : tunables   24   12    8 : slabdata   3011   3040     18 : globalstat 3114026 267189 2975171 9821    0   38  181    0    0 : cpustat 966828 3050513 3694825 319523
btrfs_inode_cache   2186   2203   4096    1    1 : tunables   24   12    8 : slabdata   2186   2203      0 : globalstat 3114062 267189 2975173 9954    0   38  181    0    0 : cpustat 966893 3050525 3695645 319587
btrfs_inode_cache   2161   2166   4096    1    1 : tunables   24   12    8 : slabdata   2161   2166      0 : globalstat 3114230 267189 2975292 10070    0   38  181    0    0 : cpustat 966926 3050649 3695817 319597
btrfs_inode_cache   2402   2424   4096    1    1 : tunables   24   12    8 : slabdata   2402   2424     76 : globalstat 3114624 267189 2975651 10144    0   38  181    0    0 : cpustat 966969 3051015 3696049 319613
btrfs_inode_cache   1627   1627   4096    1    1 : tunables   24   12    8 : slabdata   1627   1627      0 : globalstat 3114645 267189 2975653 10312    0   38  181    0    0 : cpustat 966991 3051022 3696722 319665
btrfs_inode_cache   1612   1612   4096    1    1 : tunables   24   12    8 : slabdata   1612   1612      0 : globalstat 3114760 267189 2975756 10389    0   38  181    0    0 : cpustat 967005 3051127 3696847 319673
btrfs_inode_cache   3060   3097   4096    1    1 : tunables   24   12    8 : slabdata   3060   3097     96 : globalstat 3116672 267189 2977661 10435    0   38  181    0    0 : cpustat 967237 3053046 3697631 319727
btrfs_inode_cache   2862   2862   4096    1    1 : tunables   24   12    8 : slabdata   2862   2862      0 : globalstat 3116704 267189 2977668 10526    0   38  181    0    0 : cpustat 967266 3053060 3697730 319734
btrfs_inode_cache   2971   2971   4096    1    1 : tunables   24   12    8 : slabdata   2971   2971      0 : globalstat 3116910 267189 2977861 10575    0   38  181    0    0 : cpustat 967268 3053255 3697813 319739
btrfs_inode_cache   4719   4755   4096    1    1 : tunables   24   12    8 : slabdata   4719   4755     96 : globalstat 3118780 267189 2979731 10653    0   38  181    0    0 : cpustat 967334 3055129 3698099 319756

-- 
Stephane
