Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42071 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751524AbcIDKAM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 4 Sep 2016 06:00:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 8C01F203F2
        for <linux-btrfs@vger.kernel.org>; Sun,  4 Sep 2016 05:59:37 -0400 (EDT)
Message-Id: <1472983177.1812484.715201857.036A622E@webmail.messagingengine.com>
From: Francesco Turco <fturco@fastmail.fm>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: OOM killer and Btrfs
Date: Sun, 04 Sep 2016 11:59:37 +0200
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I use Btrfs on a Gentoo Linux system with kernel 4.7.2. When my computer
is under heavy I/O load some application often crashes, for example
ClamAV, Firefox or Portage. I suspect the problem is due to Btrfs, but I
may be wrong.

These are the most recent error messages from journalctl, but I have
many other similar ones in my logs:

*** BEGIN ***

Sep 04 10:13:26 desktop kernel: gpg-agent invoked oom-killer:
gfp_mask=0x27080c0(GFP_KERNEL_ACCOUNT|__GFP_ZERO|__GFP_NOTRACK),
order=2, oom_
Sep 04 10:13:26 desktop kernel: gpg-agent cpuset=/ mems_allowed=0
Sep 04 10:13:26 desktop kernel: CPU: 1 PID: 15883 Comm: gpg-agent Not
tainted 4.7.2-gentoo #6
Sep 04 10:13:26 desktop kernel: Hardware name:                  /DQ35JO,
BIOS JOQ3510J.86A.1143.2010.1209.0048 12/09/2010
Sep 04 10:13:26 desktop kernel:  0000000000000000 ffff8801258ebbb0
ffffffff813db638 ffff8801258ebd48
Sep 04 10:13:26 desktop kernel:  ffff88009510c800 ffff8801258ebbe8
ffffffff811bbe3d ffff8801258ebd48
Sep 04 10:13:26 desktop kernel:  0000000000000000 ffff88009510c800
ffffffff81e30816 000000000000001c
Sep 04 10:13:26 desktop kernel: Call Trace:
Sep 04 10:13:26 desktop kernel:  [<ffffffff813db638>]
dump_stack+0x4d/0x65
Sep 04 10:13:26 desktop kernel:  [<ffffffff811bbe3d>]
dump_header+0x56/0x16e
Sep 04 10:13:26 desktop kernel:  [<ffffffff81160378>]
oom_kill_process+0x218/0x3e0
Sep 04 10:13:26 desktop kernel:  [<ffffffff8116098a>]
out_of_memory+0x3ba/0x460
Sep 04 10:13:26 desktop kernel:  [<ffffffff8116526d>]
__alloc_pages_nodemask+0xedd/0xf00
Sep 04 10:13:26 desktop kernel:  [<ffffffff8116571a>]
alloc_kmem_pages_node+0x4a/0xc0
Sep 04 10:13:26 desktop kernel:  [<ffffffff8109db34>]
copy_process.part.50+0x104/0x1760
Sep 04 10:13:26 desktop kernel:  [<ffffffff810cc0ca>] ?
check_preempt_wakeup+0x10a/0x240
Sep 04 10:13:26 desktop kernel:  [<ffffffff810ac37d>] ?
__set_task_blocked+0x2d/0x70
Sep 04 10:13:26 desktop kernel:  [<ffffffff8109f355>]
_do_fork+0xc5/0x370
Sep 04 10:13:26 desktop kernel:  [<ffffffff811d35fa>] ?
SyS_pselect6+0x13a/0x220
Sep 04 10:13:26 desktop kernel:  [<ffffffff8109f684>]
SyS_clone+0x14/0x20
Sep 04 10:13:26 desktop kernel:  [<ffffffff81001b7b>]
do_syscall_64+0x4b/0xa0
Sep 04 10:13:26 desktop kernel:  [<ffffffff81a1f9fc>]
entry_SYSCALL64_slow_path+0x25/0x25
Sep 04 10:13:26 desktop kernel: Mem-Info:
Sep 04 10:13:26 desktop kernel: active_anon:173869 inactive_anon:274253
isolated_anon:0
                                 active_file:888485 inactive_file:366424
                                 isolated_file:0
                                 unevictable:8 dirty:231 writeback:0
                                 unstable:0
                                 slab_reclaimable:240788
                                 slab_unreclaimable:10484
                                 mapped:46080 shmem:2372 pagetables:8521
                                 bounce:0
                                 free:36342 free_pcp:0 free_cma:0
Sep 04 10:13:26 desktop kernel: Node 0 DMA free:15768kB min:20kB
low:32kB high:44kB active_anon:0kB inactive_anon:0kB active_file:0kB
inacti
Sep 04 10:13:26 desktop kernel: lowmem_reserve[]: 0 3219 7890 7890
Sep 04 10:13:26 desktop kernel: Node 0 DMA32 free:48736kB min:4632kB
low:7928kB high:11224kB active_anon:164348kB inactive_anon:560608kB act
Sep 04 10:13:26 desktop kernel: lowmem_reserve[]: 0 0 4671 4671
Sep 04 10:13:26 desktop kernel: Node 0 Normal free:80864kB min:6720kB
low:11500kB high:16280kB active_anon:531128kB inactive_anon:536404kB a
Sep 04 10:13:26 desktop kernel: lowmem_reserve[]: 0 0 0 0
Sep 04 10:13:26 desktop kernel: Node 0 DMA: 2*4kB (U) 2*8kB (U) 2*16kB
(U) 1*32kB (U) 1*64kB (U) 0*128kB 1*256kB (U) 0*512kB 1*1024kB (U) 1*
Sep 04 10:13:26 desktop kernel: Node 0 DMA32: 7240*4kB (UME) 2472*8kB
(UME) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0
Sep 04 10:13:26 desktop kernel: Node 0 Normal: 19846*4kB (UMEH) 29*8kB
(UH) 12*16kB (H) 7*32kB (H) 0*64kB 1*128kB (H) 3*256kB (H) 0*512kB 0*
Sep 04 10:13:26 desktop kernel: Node 0 hugepages_total=0
hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
Sep 04 10:13:26 desktop kernel: 1261746 total pagecache pages
Sep 04 10:13:26 desktop kernel: 4498 pages in swap cache
Sep 04 10:13:26 desktop kernel: Swap cache stats: add 927111, delete
922613, find 398281/626731
Sep 04 10:13:26 desktop kernel: Free swap  = 8024748kB
Sep 04 10:13:26 desktop kernel: Total swap = 8388604kB
Sep 04 10:13:26 desktop kernel: 2079412 pages RAM
Sep 04 10:13:26 desktop kernel: 0 pages HighMem/MovableOnly
Sep 04 10:13:26 desktop kernel: 53317 pages reserved
Sep 04 10:13:26 desktop kernel: [ pid ]   uid  tgid total_vm      rss
nr_ptes nr_pmds swapents oom_score_adj name
Sep 04 10:13:26 desktop kernel: [ 1655]     0  1655    46246    10346   
  88       3       79             0 systemd-journal
Sep 04 10:13:26 desktop kernel: [ 1665]     0  1665    25033      145   
  16       3       60             0 lvmetad
Sep 04 10:13:26 desktop kernel: [ 1686]     0  1686     8671      251   
  19       3      469         -1000 systemd-udevd
Sep 04 10:13:26 desktop kernel: [ 1805]   108  1805    28434      243   
  26       4      101             0 systemd-timesyn
Sep 04 10:13:26 desktop kernel: [ 1813]   109  1813     9863     1398   
  24       3      326          -900 dbus-daemon
Sep 04 10:13:26 desktop kernel: [ 1815]     0  1815   101452     1771   
  65       3      770             0 NetworkManager
Sep 04 10:13:26 desktop kernel: [ 1816]     0  1816     8238      461   
  21       3       82             0 systemd-logind
Sep 04 10:13:26 desktop kernel: [ 1860]     0  1860    69132      641   
  38       4       78             0 accounts-daemon
Sep 04 10:13:26 desktop kernel: [ 1874]   113  1874    95663     1277   
  48       4      540             0 polkitd
Sep 04 10:13:26 desktop kernel: [ 2025]     0  2025    69038      646   
  32       3      109             0 upowerd
Sep 04 10:13:26 desktop kernel: [ 2092]     0  2092    10529      187   
  24       3      104             0 wpa_supplicant
Sep 04 10:13:26 desktop kernel: [ 2098]   114  2098   131582      640   
  57       3      798             0 colord
Sep 04 10:13:26 desktop kernel: [ 2496]     0  2496     3560      103   
  12       3       39             0 agetty
Sep 04 10:13:26 desktop kernel: [14882]   117 14882    16789      679   
  33       3      340             0 freshclam
Sep 04 10:13:26 desktop kernel: [14892]     0 14892    90593      986   
  42       4       78             0 gdm
Sep 04 10:13:26 desktop kernel: [14895]     0 14895    57110      262   
  48       4      299             0 gdm-session-wor
Sep 04 10:13:26 desktop kernel: [14899]   115 14899    12245      602   
  30       3      115             0 systemd
Sep 04 10:13:26 desktop kernel: [14900]   115 14900    37665       75   
  39       3      353             0 (sd-pam)
Sep 04 10:13:26 desktop kernel: [14914]   115 14914    48495      257   
  30       3      139             0 gdm-x-session
Sep 04 10:13:26 desktop kernel: [14916]   115 14916    37240      650   
  74       3     1137             0 Xorg
Sep 04 10:13:26 desktop kernel: [14921]   115 14921     8469      195   
  20       3      145             0 dbus-daemon
Sep 04 10:13:26 desktop kernel: [14923]   115 14923   140542      616   
  96       4      334             0 gnome-session-b
Sep 04 10:13:26 desktop kernel: [14932]   115 14932    81988      269   
  27       4      134             0 at-spi-bus-laun
Sep 04 10:13:26 desktop kernel: [14937]   115 14937     8410      165   
  23       3       90             0 dbus-daemon
Sep 04 10:13:26 desktop kernel: [14940]   115 14940    48722      297   
  31       4      140             0 at-spi2-registr
Sep 04 10:13:26 desktop kernel: [14949]   115 14949   372477     2680   
 276       5    15410             0 gnome-shell
Sep 04 10:13:26 desktop kernel: [14957]   115 14957   118259      299   
  77       3      302             0 pulseaudio
Sep 04 10:13:26 desktop kernel: [14958]   115 14958    24391      286   
  49       3      183             0 gconf-helper
Sep 04 10:13:26 desktop kernel: [14960]   115 14960    15428      315   
  33       3       97             0 gconfd-2
Sep 04 10:13:26 desktop kernel: [14966]   115 14966    85274      279   
  35       3      279             0 ibus-daemon
Sep 04 10:13:26 desktop kernel: [14970]   115 14970    65138      289   
  28       4      142             0 ibus-dconf
Sep 04 10:13:26 desktop kernel: [14974]   115 14974    85570      548   
 100       3     1237             0 ibus-x11
Sep 04 10:13:26 desktop kernel: [14984]   115 14984   247887     1215   
 156       4     1141             0 gnome-settings-
Sep 04 10:13:26 desktop kernel: [15002]   115 15002    46172      284   
  25       3      140             0 ibus-engine-sim
Sep 04 10:13:26 desktop kernel: [15010]     0 15010     3560      102   
  11       3       38             0 agetty
Sep 04 10:13:26 desktop kernel: [15019]     0 15019     3560      106   
  13       3       40             0 agetty
Sep 04 10:13:26 desktop kernel: [15024]     0 15024    61785      317   
  57       3      340             0 gdm-session-wor
Sep 04 10:13:26 desktop kernel: [15028]  1000 15028    12266      618   
  29       3      119             0 systemd
Sep 04 10:13:26 desktop kernel: [15029]  1000 15029    37667       77   
  39       3      353             0 (sd-pam)
Sep 04 10:13:26 desktop kernel: [15050]  1000 15050    88843      897   
  35       4       50             0 gnome-keyring-d
Sep 04 10:13:26 desktop kernel: [15056]  1000 15056    48495      257   
  30       3      138             0 gdm-x-session
Sep 04 10:13:26 desktop kernel: [15059]  1000 15059    63243    18942   
 122       3     1116             0 Xorg
Sep 04 10:13:26 desktop kernel: [15062]  1000 15062     8922      749   
  22       3       39             0 dbus-daemon
Sep 04 10:13:26 desktop kernel: [15064]  1000 15064   144792      891   
 103       3      273             0 gnome-session-b
Sep 04 10:13:26 desktop kernel: [15086]  1000 15086     3259       70   
  10       4       71             0 ssh-agent
Sep 04 10:13:26 desktop kernel: [15094]  1000 15094    86250      689   
  35       3       78             0 gvfsd
Sep 04 10:13:26 desktop kernel: [15099]  1000 15099    81990      501   
  28       3       54             0 at-spi-bus-laun
Sep 04 10:13:26 desktop kernel: [15123]  1000 15123   513274    72768   
 449       5    24555             0 gnome-shell
Sep 04 10:13:26 desktop kernel: [15131]  1000 15131   191181     1742   
 109       4      281             0 pulseaudio
Sep 04 10:13:26 desktop kernel: [15135]  1000 15135    24391      286   
  52       4      182             0 gconf-helper
Sep 04 10:13:26 desktop kernel: [15137]  1000 15137    15428      346   
  32       3       72             0 gconfd-2
Sep 04 10:13:26 desktop kernel: [15142]  1000 15142   147312     1070   
  70       4      324             0 gnome-shell-cal
Sep 04 10:13:26 desktop kernel: [15143]  1000 15143    85306      669   
  35       3       86             0 ibus-daemon
Sep 04 10:13:26 desktop kernel: [15149]  1000 15149   303708      921   
 153       5      555             0 evolution-sourc
Sep 04 10:13:26 desktop kernel: [15153]  1000 15153    65140      303   
  28       3      121             0 ibus-dconf
Sep 04 10:13:26 desktop kernel: [15155]  1000 15155    85577      991   
 103       4      828             0 ibus-x11
Sep 04 10:13:26 desktop kernel: [15170]  1000 15170   116556     1001   
  60       3      177             0 mission-control
Sep 04 10:13:26 desktop kernel: [15172]  1000 15172   110967     1008   
  48       3       42             0 gvfs-udisks2-vo
Sep 04 10:13:26 desktop kernel: [15175]  1000 15175   157892      837   
 137       4     1057             0 goa-daemon
Sep 04 10:13:26 desktop kernel: [15183]     0 15183   144988      956   
  50       3      477             0 udisksd
Sep 04 10:13:26 desktop kernel: [15193]  1000 15193    68063      550   
  34       4      105             0 gvfs-gphoto2-vo
Sep 04 10:13:26 desktop kernel: [15198]  1000 15198    63491      513   
  26       3       45             0 gvfs-goa-volume
Sep 04 10:13:26 desktop kernel: [15207]  1000 15207   233931     2814   
 182       4      822             0 gnome-settings-
Sep 04 10:13:26 desktop kernel: [15225]  1000 15225   110717      560   
  71       3      602             0 tracker-miner-u
Sep 04 10:13:26 desktop kernel: [15229]  1000 15229   274241     5483   
 139       4     9896             0 tracker-miner-f
Sep 04 10:13:26 desktop kernel: [15231]  1000 15231   154835    27893   
 111       4     1219             0 tracker-store
Sep 04 10:13:26 desktop kernel: [15232]  1000 15232   339178     6727   
 205       5     2627             0 mailnag
Sep 04 10:13:26 desktop kernel: [15234]     0 15234    16205      398   
  36       3      227             0 cupsd
Sep 04 10:13:26 desktop kernel: [15250]  1000 15250    62381     3805   
  93       3      712             0 applet.py
Sep 04 10:13:26 desktop kernel: [15251]  1000 15251   165451      987   
  79       4      723             0 tracker-miner-a
Sep 04 10:13:26 desktop kernel: [15252]  1000 15252   454173    51867   
 472       4      920             0 tracker-extract
Sep 04 10:13:26 desktop kernel: [15263]  1000 15263   120404      639   
  93       4      291             0 gsd-printer
Sep 04 10:13:26 desktop kernel: [15285]  1000 15285   158676     7981   
 143       4      501             0 python2.7
Sep 04 10:13:26 desktop kernel: [15296]  1000 15296   189030      489   
 152       3     1299             0 evolution-calen
Sep 04 10:13:26 desktop kernel: [15308]  1000 15308   189429     1061   
  89       3      968             0 evolution-calen
Sep 04 10:13:26 desktop kernel: [15317]  1000 15317   171309     1064   
  87       3      925             0 evolution-calen
Sep 04 10:13:26 desktop kernel: [15320]  1000 15320   155734      667   
  84       3      414             0 evolution-addre
Sep 04 10:13:26 desktop kernel: [15328]  1000 15328   228262      978   
 109       4      485             0 evolution-addre
Sep 04 10:13:26 desktop kernel: [15343]  1000 15343    46205      516   
  27       3       47             0 ibus-engine-sim
Sep 04 10:13:26 desktop kernel: [15438]  1000 15438    46724      686   
  27       3       42             0 gvfsd-metadata
Sep 04 10:13:26 desktop kernel: [15709]  1000 15709   129458    27289   
 183       3      978             0 emacs
Sep 04 10:13:26 desktop kernel: [15757]  1000 15757    91297     1330   
  43       4       47             0 gvfsd-trash
Sep 04 10:13:26 desktop kernel: [15768]  1000 15768   143223      751   
  46       3      100             0 gvfsd-network
Sep 04 10:13:26 desktop kernel: [15774]  1000 15774   169842      903   
 127       4      162             0 gvfsd-smb-brows
Sep 04 10:13:26 desktop kernel: [15806]  1000 15806   424004     1498   
 153       5      839             0 epiphany-search
Sep 04 10:13:26 desktop kernel: [15883]  1000 15883    40900      307   
  17       3       16             0 gpg-agent
Sep 04 10:13:26 desktop kernel: [15890]  1000 15890    86160      625   
  34       3       69             0 gvfsd-burn
Sep 04 10:13:26 desktop kernel: [ 7359]     0  7359    11313      161   
  27       3       96             0 dbus-launch
Sep 04 10:13:26 desktop kernel: [ 7360]     0  7360     8435      287   
  20       3       31             0 dbus-daemon
Sep 04 10:13:26 desktop kernel: [ 7362]     0  7362    82305      379   
  28       3       59             0 at-spi-bus-laun
Sep 04 10:13:26 desktop kernel: [ 7367]     0  7367     8410      241   
  21       3       35             0 dbus-daemon
Sep 04 10:13:26 desktop kernel: [ 7369]     0  7369    48882      341   
  30       3       97             0 at-spi2-registr
Sep 04 10:13:26 desktop kernel: [11178]  1000 11178   113300     4117   
  73       4       80             0 gvfsd-http
Sep 04 10:13:26 desktop kernel: [14077]  1000 14077    44093      608   
  22       4        6             0 dconf-service
Sep 04 10:13:26 desktop kernel: [23834]  1000 23834    34775      493   
  34       3       19             0 dirmngr
Sep 04 10:13:26 desktop kernel: [12410]  1000 12410   100488     4578   
 129       4      701             0 python2.7
Sep 04 10:13:26 desktop kernel: [18147]     0 18147     9895      285   
  26       3      131         -1000 sshd
Sep 04 10:13:26 desktop kernel: [31229]   117 31229   157892   114246   
 275       3     1617             0 clamd
Sep 04 10:13:26 desktop kernel: [23807]  1000 23807     2015      219   
   9       3        8             0 idn
Sep 04 10:13:26 desktop kernel: [24060]  1000 24060   337570    18247   
 176       4     2121             0 transmission-gt
Sep 04 10:13:26 desktop kernel: [17531]  1000 17531   525655     8786   
 216       5        0             0 boincmgr
Sep 04 10:13:26 desktop kernel: [17147]   122 17147    18701     2097   
  37       4      200             0 boinc_client
Sep 04 10:13:26 desktop kernel: [27855]  1000 27855   457932    97438   
 659       5        0             0 firefox
Sep 04 10:13:26 desktop kernel: [28280]  1000 28280   154312     6304   
 130       4        0             0 gnome-terminal-
Sep 04 10:13:26 desktop kernel: [28286]  1000 28286     5163      923   
  14       3        0             0 bash
Sep 04 10:13:26 desktop kernel: [ 6464]  1000  6464     5192     1098   
  15       3        0             0 bash
Sep 04 10:13:26 desktop kernel: [ 9985]     0  9985     4196     2451   
  12       3        0             0 dhclient
Sep 04 10:13:26 desktop kernel: [10192]   122 10192     4960     1413   
  14       3        0             0 milkyway_1.36_x
Sep 04 10:13:26 desktop kernel: [10217]   122 10217     2541     2045   
  10       3        0             0 milkyway_nbody_
Sep 04 10:13:26 desktop kernel: Out of memory: Kill process 31229
(clamd) score 28 or sacrifice child
Sep 04 10:13:26 desktop kernel: Killed process 31229 (clamd)
total-vm:631568kB, anon-rss:447100kB, file-rss:9884kB, shmem-rss:0kB
Sep 04 10:13:26 desktop kernel: oom_reaper: reaped process 31229
(clamd), now anon-rss:4kB, file-rss:0kB, shmem-rss:0kB
Sep 04 10:13:26 desktop systemd[1]: clamd.service: Main process exited,
code=killed, status=9/KILL
Sep 04 10:13:26 desktop systemd[1]: clamd.service: Unit entered failed
state.
Sep 04 10:13:26 desktop systemd[1]: clamd.service: Failed with result
'signal'.
Sep 04 10:13:26 desktop systemd[1]: clamd.service: Service hold-off time
over, scheduling restart.
Sep 04 10:13:26 desktop systemd[1]: Stopped Generic ClamAV scanner
daemon.
-- Subject: Unit clamd.service has finished shutting down
-- Defined-By: systemd
-- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
-- 
-- Unit clamd.service has finished shutting down.

*** END ***

Is the problem already known? Should I report a bug? Is there a patch I
can try? Thanks.

-- 
https://www.fturco.net/
