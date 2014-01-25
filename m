Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:33080 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaAYVrm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 16:47:42 -0500
Received: by mail-bk0-f51.google.com with SMTP id w10so2012031bkz.24
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jan 2014 13:47:41 -0800 (PST)
Received: from ?IPv6:2001:470:8:414::10? (wolf.welp.gs. [2001:470:8:414::10])
        by mx.google.com with ESMTPSA id q5sm7600907bkr.5.2014.01.25.13.47.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 25 Jan 2014 13:47:40 -0800 (PST)
Message-ID: <52E430F7.7030801@gmail.com>
Date: Sat, 25 Jan 2014 16:47:35 -0500
From: Dan Merillat <dan.merillat@gmail.com>
MIME-Version: 1.0
To: BTRFS <linux-btrfs@vger.kernel.org>
Subject: Rapid memory exhaustion during normal operation
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to track this down - this started happening without changing the kernel in use, so probably
a corrupted filesystem. The symptoms are that all memory is suddenly used by no apparent source.  OOM
killer is invoked on every task, still can't free up enough memory to continue.

When it goes wrong, it's extremely rapid - system goes from stable to dead in less than 30 seconds.

Tested 3.9.0, 3.12.0, 3.12.8.   Limited testing on 3.13 shows I think the same problem but I need
to double-check that it's not a different issue.  Blows up the exact same way on a real kernel or in
UML.

All sorts of things can trigger it - defrag, random writes to files.  Balance and scrub don't,
readonly mount doesn't.

I can reproduce this trivially, mount the filesystem read-write and perform some activity.  It only
takes a few minutes.   The other btrfs filesystems on the same machine don't show similar problems.
Unfortunately, the output of btrfs-image -c9 is 75gb, much more than I can reasonably share.  I've got
a reliable reproducer in UML using UML-COW to always start with the same base image, defrag a file with
33,000 extents and the system explodes within a minute.

Here's the OOM report, the formatting is a bit off due to being delivered via netconsole.
Swap was disabled on this run, but it makes no difference.  I get insta-OOM issues out of the blue
with very little memory swapped out.

[ 1184.871419] parent transid verify failed on 8049834639360 wanted 1736567 found 1734749
[ 1184.879873] parent transid verify failed on 8049834639360 wanted 1736567 found 1734749
[ 1184.894932] parent transid verify failed on 8049834639360 wanted 1736567 found 1734749
[ 1184.898207] parent transid verify failed on 8049834639360 wanted 1736567 found 1734749
[ 1184.902116] parent transid verify failed on 8049834639360 wanted 1736567 found 1734749
[ 1184.902454] parent transid verify failed on 8049834639360 wanted 1736567 found 1734749
[ 1184.903333] parent transid verify failed on 8049834639360 wanted 1736567 found 1734749
[ 1184.903588] parent transid verify failed on 8049834639360 wanted 1736567 found 1734749
[ 1184.904592] parent transid verify failed on 8049834639360 wanted 1736567 found 1734749
[ 1184.904839] parent transid verify failed on 8049834639360 wanted 1736567 found 1734749
[ 1192.113082] verify_parent_transid: 16 callbacks suppressed
[ 1192.113166] parent transid verify failed on 8049835315200 wanted 1736567 found 1736533
[ 1192.113269] parent transid verify failed on 8049835315200 wanted 1736567 found 1736533
[ 1192.176637] parent transid verify failed on 8049835315200 wanted 1736567 found 1736533
[ 1192.178119] parent transid verify failed on 8049835315200 wanted 1736567 found 1736533
[ 1192.203369] parent transid verify failed on 8049835315200 wanted 1736567 found 1736533
[ 1192.203503] parent transid verify failed on 8049835315200 wanted 1736567 found 1736533
[ 1192.204112] parent transid verify failed on 8049835315200 wanted 1736567 found 1736533
[ 1192.205324] parent transid verify failed on 8049835315200 wanted 1736567 found 1736533
[ 1192.814465] parent transid verify failed on 8049835315200 wanted 1736567 found 1736533
[ 1192.817226] parent transid verify failed on 8049835315200 wanted 1736567 found 1736533
[ 1219.366168] ntpd invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
[ 1219.366270] CPU: 1 PID: 5479 Comm: ntpd Not tainted 3.12.8-00848-g97f15f1 #2
[ 1219.366324] Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GPM-DS2H/GA-MA78GPM-DS2H, BIOS F1 06/03/2008
[ 1219.366402]  0000000000000000 ffff8800c02339a8 ffffffff815ccf3b 000000003f51a67e
[ 1219.366632]  ffff8800c557ae40 ffff8800c0233a48 ffffffff815c8551 0000000000000100
[ 1219.366861]  0000000000000001 ffff8800c02339e8 ffffffff815d4f46 00000000000ef3e4
[ 1219.367086] Call Trace:
[ 1219.367155]  [<ffffffff815ccf3b>] dump_stack+0x50/0x85
[ 1219.367262]  [<ffffffff815c8551>] dump_header.isra.14+0x6d/0x1b5
[ 1219.367322]  [<ffffffff815d4f46>] ? sub_preempt_count+0x33/0x46
[ 1219.367390]  [<ffffffff815d1b9d>] ? _raw_spin_unlock_irqrestore+0x2b/0x48
[ 1219.367448]  [<ffffffff8132849a>] ? ___ratelimit+0xda/0xf8
[ 1219.367514]  [<ffffffff810cf773>] oom_kill_process+0x70/0x303
[ 1219.367614]  [<ffffffff81041930>] ? has_capability_noaudit+0x12/0x16
[ 1219.367672]  [<ffffffff810cfe91>] out_of_memory+0x314/0x347
[ 1219.367734]  [<ffffffff810d3ee3>] __alloc_pages_nodemask+0x629/0x7c8
[ 1219.367798]  [<ffffffff811052db>] alloc_pages_current+0xb2/0xbb
[ 1219.367852]  [<ffffffff810cd36e>] __page_cache_alloc+0xb/0xd
[ 1219.367915]  [<ffffffff810ceb9a>] filemap_fault+0x249/0x362
[ 1219.367973]  [<ffffffff810eb378>] __do_fault+0xa7/0x418
[ 1219.368071]  [<ffffffff815d1b9d>] ? _raw_spin_unlock_irqrestore+0x2b/0x48
[ 1219.368130]  [<ffffffff810606c4>] ? get_parent_ip+0xe/0x3e
[ 1219.368184]  [<ffffffff810eed47>] handle_mm_fault+0x2b4/0x907
[ 1219.368239]  [<ffffffff815d1a93>] ? _raw_spin_unlock_irq+0x17/0x32
[ 1219.368297]  [<ffffffff815d4dc4>] __do_page_fault+0x489/0x4e6
[ 1219.368354]  [<ffffffff8100b22e>] ? __restore_xstate_sig+0x30a/0x4dc
[ 1219.368408]  [<ffffffff810606c4>] ? get_parent_ip+0xe/0x3e
[ 1219.368462]  [<ffffffff815d1cdd>] ? _raw_spin_lock_irq+0x19/0x38
[ 1219.368518]  [<ffffffff815d4f46>] ? sub_preempt_count+0x33/0x46
[ 1219.368575]  [<ffffffff8132da3a>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[ 1219.368633]  [<ffffffff815d4e2a>] do_page_fault+0x9/0xb
[ 1219.368687]  [<ffffffff815d25a2>] page_fault+0x22/0x30
[ 1219.370803] Mem-Info:
[ 1219.370858] Node 0
[ 1219.371146] CPU    0: hi:    0, btch:   1 usd:   0
[ 1219.371202] CPU    1: hi:    0, btch:   1 usd:   0
[ 1219.371264] Node 0
[ 1219.371555] CPU    0: hi:  186, btch:  31 usd:  42
[ 1219.371617] CPU    1: hi:  186, btch:  31 usd:  29
[ 1219.371670] Node 0
[ 1219.371772] CPU    0: hi:  186, btch:  31 usd:  30
[ 1219.371832] CPU    1: hi:  186, btch:  31 usd:  26
[ 1219.371893] active_anon:46310 inactive_anon:940 isolated_anon:0#012
[ 1219.371893]  active_file:768 inactive_file:1155 isolated_file:0#012
[ 1219.371893]  unevictable:0 dirty:827 writeback:0 unstable:0#012
[ 1219.371893]  free:21409 slab_reclaimable:5668 slab_unreclaimable:5883#012
[ 1219.371893]  mapped:1276 shmem:1261 pagetables:2591 bounce:0#012
[ 1219.371893]  free_cma:0
[ 1219.372411] Node 0
[ 1219.372628] lowmem_reserve[]: 0 3106 3811 3811
[ 1219.372970] Node 0
[ 1219.373149] lowmem_reserve[]: 0 0 705 705
[ 1219.373475] Node 0
[ 1219.373654] lowmem_reserve[]: 0 0 0 0
[ 1219.373930] Node 0 DMA: 3*4kB (M) 4*8kB (UM) 5*16kB (UM) 3*32kB (UM) 1*64kB (U) 1*128kB (U) 1*256kB (M) 1*512kB (M) 2*1024kB (UM) 2*2048kB (MR) 2*4096kB (EM) = 15516kB
[ 1219.375077] Node 0 DMA32: 945*4kB (UEM) 1764*8kB (UEM) 1107*16kB (UEM) 366*32kB (UEM) 84*64kB (UEM) 6*128kB (UEM) 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB (R) = 57556kB
[ 1219.376072] Node 0 Normal: 2139*4kB (UEM) 36*8kB (M) 0*16kB 0*32kB 1*64kB (R) 1*128kB (R) 1*256kB (R) 0*512kB 1*1024kB (R) 1*2048kB (R) 0*4096kB = 12364kB
[ 1219.377031] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1219.377100] 3230 total pagecache pages
[ 1219.377151] 0 pages in swap cache
[ 1219.377211] Swap cache stats: add 0, delete 0, find 0/0
[ 1219.377263] Free swap  = 0kB
[ 1219.377320] Total swap = 0kB
[ 1219.428078] 1015807 pages RAM
[ 1219.428154] 35867 pages reserved
[ 1219.428224] 536682 pages shared
[ 1219.428273] 953367 pages non-shared
[ 1219.428330] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[ 1219.428414] [ 1249]     0  1249     6103      316      16        0         -1000 udevd
[ 1219.428477] [ 1479]     0  1479     6092      313      15        0         -1000 udevd
[ 1219.428552] [ 3285]     0  3285     2130       39      10        0             0 dhcpcd-bin
[ 1219.428614] [ 3383]     0  3383     5989      208      15        0         -1000 udevd
[ 1219.428681] [ 3717]     0  3717     4779      104      15        0             0 rpcbind
[ 1219.428743] [ 3749]   106  3749     5872      148      17        0             0 rpc.statd
[ 1219.428811] [ 3761]     0  3761     6359       72      17        0             0 rpc.idmapd
[ 1219.428873] [ 3766]     0  3766     7681      108      19        0             0 rpc.gssd
[ 1219.428941] [ 4227]    13  4227     1169       44       8        0             0 polipo
[ 1219.429107] [ 4288]   130  4288     3165       98      12        0             0 syslogd
[ 1219.430837] [ 4309]   135  4309     4774       96      14        0             0 dirmngr
[ 1219.430899] [ 4367]     0  4367    17697      210      35        0             0 nmbd
[ 1219.430972] [ 4371]     0  4371    24778      284      48        0             0 smbd
[ 1219.431033] [ 4389]   101  4389     8094      137      19        0             0 dbus-daemon
[ 1219.431101] [ 4390]     0  4390    24804      264      47        0             0 smbd
[ 1219.431162] [ 4408]     0  4408    10567      120      24        0             0 krb5kdc
[ 1219.431230] [ 4439]     0  4439     7094      249      17        0             0 openvpn
[ 1219.431290] [ 4525]     0  4525    96084      181      31        0             0 automount
[ 1219.431358] [ 4531]     0  4531     4204       56      12        0             0 atd
[ 1219.431418] [ 4605]   136  4605    64452     7713      57        0             0 named
[ 1219.431485] [ 4664]     0  4664     2128       49       9        0             0 dd
[ 1219.431545] [ 4666]   131  4666     2073     1093       9        0             0 klogd
[ 1219.431613] [ 4674]     0  4674    10589      160      26        0             0 kadmind
[ 1219.431673] [ 4751]     0  4751     3297       80      11        0             0 mdadm
[ 1219.431742] [ 4772]   114  4772    33045      260      28        0             0 bacula-sd
[ 1219.431802] [ 4831]     0  4831    21770      629      46        0             0 apache2
[ 1219.431873] [ 4833]    33  4833    21703      544      45        0             0 apache2
[ 1219.431934] [ 4834]     0  4834    21703      545      44        0             0 apache2
[ 1219.432002] [ 4835]    33  4835    61700     1035      87        0             0 php5-cgi
[ 1219.432085] [ 4837]    33  4837    94011     1123      75        0             0 apache2
[ 1219.432147] [ 4839]    33  4839    94013     1128      75        0             0 apache2
[ 1219.432215] [ 4975]     0  4975     6155       88      18        0             0 cron
[ 1219.432275] [ 4977]     0  4977     2646       58      10        0             0 inetd
[ 1219.432342] [ 5039]     0  5039     3379     1410      10        0             0 dhcpd
[ 1219.432403] [ 5064]     0  5064     2368       98      10        0             0 mysqld_safe
[ 1219.432471] [ 5383]   103  5383   138079    16199      74        0             0 mysqld
[ 1219.432532] [ 5384]     0  5384     1057       49       8        0             0 logger
[ 1219.432599] [ 5399]   113  5399    27465      840      44        0             0 postgres
[ 1219.432660] [ 5449]   129  5449     5481      176      15        0             0 privoxy
[ 1219.432727] [ 5476]     0  5476     3691       48      11        0             0 radvd
[ 1219.432788] [ 5478]   119  5478     3691       65      12        0             0 radvd
[ 1219.432854] [ 5479]   110  5479     9911      231      24        0             0 ntpd
[ 1219.432915] [ 5660]     0  5660     5510      245      14        0             0 smartd
[ 1219.432982] [ 5763]     0  5763     3791      126      13        0             0 tincd
[ 1219.433043] [ 5780]     0  5780    13075      182      28        0         -1000 sshd
[ 1219.433110] [ 5798]   113  5798    27465      354      41        0             0 postgres
[ 1219.433172] [ 5799]   113  5799    27465      310      40        0             0 postgres
[ 1219.433239] [ 5800]   113  5800    27498      348      40        0             0 postgres
[ 1219.433300] [ 5801]   113  5801    20047      324      36        0             0 postgres
[ 1219.433368] [ 5894]     0  5894    20888      237      43        0             0 winbindd
[ 1219.433429] [ 5897]     0  5897    20887      232      41        0             0 winbindd
[ 1219.433497] [ 6010]   118  6010   421074     4794     354        0             0 asterisk
[ 1219.433558] [ 6367]   102  6367    11866      141      25        0             0 exim4
[ 1219.433625] [ 6399]   120  6399     1057       49       8        0             0 uml_switch
[ 1219.433686] [ 6443]     0  6443     1023       30       7        0             0 minissdpd
[ 1219.433754] [ 6472]     0  6472     2633       61      11        0             0 miniupnpd
[ 1219.433815] [ 6522]     0  6522     4542       68      14        0             0 getty
[ 1219.433882] [ 6523]     0  6523     4542       67      14        0             0 getty
[ 1219.433943] [ 6524]     0  6524     4542       67      14        0             0 getty
[ 1219.434010] [ 6525]     0  6525     4542       67      14        0             0 getty
[ 1219.434071] [ 6526]     0  6526     4542       66      13        0             0 getty
[ 1219.434137] [ 6527]     0  6527     4542       67      14        0             0 getty
[ 1219.434198] [ 6528]     0  6528    23174      345      49        0             0 sshd
[ 1219.434265] [ 6540]     0  6540   261278      379      44        0             0 console-kit-dae
[ 1219.434327] [ 6607]     0  6607    48754      209      33        0             0 polkitd
[ 1219.434395] [ 6613]     0  6613     5802      625      17        0             0 bash
[ 1219.434455] [ 6850]     0  6850    23138      302      50        0             0 sshd
[ 1219.434522] [ 6855]     0  6855     5801      619      17        0             0 bash
[ 1219.434582] [ 7006]     0  7006     6335      245      17        0             0 top
[ 1219.434649] [ 7021]     0  7021    23138      276      49        0             0 sshd
[ 1219.434710] [ 7026]     0  7026     5801      621      16        0             0 bash
[ 1219.434781] [ 7463]     0  7463    23138      300      48        0             0 sshd
[ 1219.434841] [ 7468]     0  7468     5801      618      17        0             0 bash
[ 1219.434909] [ 7623]     0  7623    14346     2321      33        0             0 iotop
[ 1219.434970] [ 7646]     0  7646     4096      187      14        0             0 watch
[ 1219.435037] [ 7657]     0  7657    23138      271      48        0             0 sshd
[ 1219.435097] [ 7662]     0  7662     5801      622      16        0             0 bash
[ 1219.435164] [ 7852]     0  7852     1948       48       9        0             0 xargs
[ 1219.435224] [ 7872]     0  7872     1886       47       9        0             0 tail
[ 1219.435292] [ 7892]     0  7892    20890      225      41        0             0 winbindd
[ 1219.435353] [ 7893]     0  7893    20886      235      41        0             0 winbindd
[ 1219.435423] [ 8666]     0  8666     3166       72      12        0             0 fixfrag
[ 1219.435484] [ 8675]     0  8675     1022       28       7        0             0 time
[ 1219.435551] [ 8676]     0  8676     2900       42      10        0             0 btrfs
[ 1219.435612] [ 8707]   113  8707    27710      686      42        0             0 postgres
[ 1219.435679] [ 8708]     0  8708     4095      104      10        0             0 watch
[ 1219.435740] [ 8709]     0  8709     2391       38       7        0             0 sh
[ 1219.435805] Out of memory: Kill process 5383 (mysqld) score 16 or sacrifice child
[ 1219.435874] Killed process 5383 (mysqld) total-vm:552316kB, anon-rss:64576kB, file-rss:220kB
[ 1220.014027] verify_parent_transid: 97 callbacks suppressed
[ 1220.014109] parent transid verify failed on 8049836576768 wanted 1736567 found 1736533
[ 1220.020710] parent transid verify failed on 8049836576768 wanted 1736567 found 1736533
