Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48516 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3CDWHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 17:07:51 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs crash when low on memory.
Date: Mon, 4 Mar 2013 23:07:47 +0100
Cc: Ahmet Inan <ainan@mathematik.uni-freiburg.de>,
        Josef Bacik <jbacik@fusionio.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130227052247.GA20213@redhat.com> <20130227132736.GH19641@localhost.localdomain> <CAFDW0jK6zigx0YgVMHomUkRQkqpw5mUgkdeynv36LUiQn4XTxg@mail.gmail.com> (sfid-20130227_155526_844645_26A2F846)
In-Reply-To: <CAFDW0jK6zigx0YgVMHomUkRQkqpw5mUgkdeynv36LUiQn4XTxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303042307.47629.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 27. Februar 2013 schrieb Ahmet Inan:
> > Yeah we have a lot of
> > 
> > ptr = kmalloc();
> > BUG_ON(ptr);
> > 
> > everywhere.  I'll fix this one up but I really need to sit down and go
> > through all of them and make sure we do the right thing in all these
> > places.  Thanks,
> 
> But what would be the right thing to do when you got no memory?
> Spinlock until you can kmalloc? Pre-reserve some memory?
> 
> At the moment im using:
> 
> vm.min_free_kbytes = 65536
> 
> Which helps most of the time and i think is the better way to handle
> this kind of Situation.

Thank you.

Raising /proc/sys/vm/min_free_kbytes from about 65000 to 200000 KiB helped
here on a ThinkPad T520 equipped with a 8 MiB for RAM.

I now have the oom killer raised while Planeshift client was doing accesses
to BTRFS.

Thus I have a complete OOM backtrace and I bet thats likely the place where
before BTRFS crashed the kernel before the OOM killer could chime in to
clear up the situation.

The rtkit-daemon invoked the OOM killer, since I do not use Pulseaudio
anymore since it didn´t work to my satisfaction on this machine as well,
I might remove it. But then someone else will likely trigger it. :)

If need be, I would reduce the min_free_kbytes again until it crashes some
more time and do a screenshot, but a screenshot always only just shows
part of the trace. Some my memory the backtrace I saw on tty1 was similar
to the psclient.bin backtrace in the following OOM excerpt.

Otherwise I will leave it at that and make the min_free_kbytes setting
permanent :), or maybe disable the over commit to let Planeshift client
fail and possibly crash earlier on out of memory conditions.

Mar  4 22:56:00 merkaba rtkit-daemon[1575]: The canary thread is apparently starving. Taking action.
Mar  4 22:56:00 merkaba kernel: [183059.738831] rtkit-daemon invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
Mar  4 22:56:00 merkaba kernel: [183059.738837] rtkit-daemon cpuset=/ mems_allowed=0
Mar  4 22:56:00 merkaba kernel: [183059.738841] Pid: 1579, comm: rtkit-daemon Tainted: G           O 3.8.0-tp520 #40
Mar  4 22:56:00 merkaba kernel: [183059.738843] Call Trace:
Mar  4 22:56:00 merkaba kernel: [183059.738851]  [<ffffffff81423515>] ? _raw_spin_unlock+0x26/0x31
Mar  4 22:56:00 merkaba kernel: [183059.738856]  [<ffffffff8141d251>] dump_header.isra.9+0x6b/0x1cd
Mar  4 22:56:00 merkaba kernel: [183059.738860]  [<ffffffff81423869>] ? _raw_spin_unlock_irqrestore+0x2e/0x39
Mar  4 22:56:00 merkaba kernel: [183059.738865]  [<ffffffff811e0682>] ? ___ratelimit+0xc9/0xe7
Mar  4 22:56:00 merkaba kernel: [183059.738869]  [<ffffffff810d2e83>] oom_kill_process+0x62/0x2bc
Mar  4 22:56:00 merkaba kernel: [183059.738874]  [<ffffffff810aeaf4>] ? rcu_read_unlock_special+0x138/0x162
Mar  4 22:56:00 merkaba kernel: [183059.738877]  [<ffffffff810d3619>] out_of_memory+0x3c4/0x3f7
Mar  4 22:56:00 merkaba kernel: [183059.738881]  [<ffffffff810d76f3>] __alloc_pages_nodemask+0x548/0x6c7
Mar  4 22:56:00 merkaba kernel: [183059.738886]  [<ffffffff811066a1>] alloc_pages_current+0xc0/0xdd
Mar  4 22:56:00 merkaba kernel: [183059.738889]  [<ffffffff810d077c>] __page_cache_alloc+0x87/0x93
Mar  4 22:56:00 merkaba kernel: [183059.738893]  [<ffffffff810d20fb>] filemap_fault+0x250/0x35f
Mar  4 22:56:00 merkaba kernel: [183059.738897]  [<ffffffff810ee5e0>] __do_fault+0xa6/0x351
Mar  4 22:56:00 merkaba kernel: [183059.738900]  [<ffffffff810f0c68>] handle_pte_fault+0x28e/0x73f
Mar  4 22:56:00 merkaba kernel: [183059.738905]  [<ffffffff81069b27>] ? try_to_wake_up+0x1b7/0x1c9
Mar  4 22:56:00 merkaba kernel: [183059.738908]  [<ffffffff810edf86>] ? pmd_offset+0x10/0x3d
Mar  4 22:56:00 merkaba kernel: [183059.738911]  [<ffffffff810f148d>] handle_mm_fault+0x1d8/0x1f2
Mar  4 22:56:00 merkaba kernel: [183059.738915]  [<ffffffff8142650d>] __do_page_fault+0x37b/0x3c5
Mar  4 22:56:00 merkaba kernel: [183059.738920]  [<ffffffff8104599d>] ? timespec_add_safe+0x22/0x51
Mar  4 22:56:00 merkaba kernel: [183059.738924]  [<ffffffff81014de1>] ? paravirt_read_tsc+0x9/0xd
Mar  4 22:56:00 merkaba kernel: [183059.738928]  [<ffffffff81014e4d>] ? read_tsc+0x9/0x19
Mar  4 22:56:00 merkaba kernel: [183059.738931]  [<ffffffff8107e313>] ? timekeeping_get_ns.constprop.8+0x13/0x3a
Mar  4 22:56:00 merkaba kernel: [183059.738935]  [<ffffffff8107e80a>] ? ktime_get_ts+0x47/0x87
Mar  4 22:56:00 merkaba kernel: [183059.738939]  [<ffffffff81126ed4>] ? poll_select_set_timeout+0x53/0x6f
Mar  4 22:56:00 merkaba kernel: [183059.738942]  [<ffffffff81426560>] do_page_fault+0x9/0xb
Mar  4 22:56:00 merkaba kernel: [183059.738945]  [<ffffffff81423e08>] page_fault+0x28/0x30
Mar  4 22:56:00 merkaba kernel: [183059.738947] Mem-Info:
Mar  4 22:56:00 merkaba kernel: [183059.738949] Node 0 DMA per-cpu:
Mar  4 22:56:00 merkaba kernel: [183059.738952] CPU    0: hi:    0, btch:   1 usd:   0
Mar  4 22:56:00 merkaba kernel: [183059.738954] CPU    1: hi:    0, btch:   1 usd:   0
Mar  4 22:56:00 merkaba kernel: [183059.738956] CPU    2: hi:    0, btch:   1 usd:   0
Mar  4 22:56:00 merkaba kernel: [183059.738958] CPU    3: hi:    0, btch:   1 usd:   0
Mar  4 22:56:00 merkaba kernel: [183059.738960] Node 0 DMA32 per-cpu:
Mar  4 22:56:00 merkaba kernel: [183059.738962] CPU    0: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183059.738964] CPU    1: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183059.738966] CPU    2: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183059.738968] CPU    3: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183059.738969] Node 0 Normal per-cpu:
Mar  4 22:56:00 merkaba kernel: [183059.738972] CPU    0: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183059.738973] CPU    1: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183059.738975] CPU    2: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183059.738977] CPU    3: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183059.738982] active_anon:1482554 inactive_anon:356853 isolated_anon:352
Mar  4 22:56:00 merkaba kernel: [183059.738982]  active_file:706 inactive_file:1211 isolated_file:0
Mar  4 22:56:00 merkaba kernel: [183059.738982]  unevictable:9308 dirty:9 writeback:0 unstable:0
Mar  4 22:56:00 merkaba kernel: [183059.738982]  free:54036 slab_reclaimable:26439 slab_unreclaimable:16194
Mar  4 22:56:00 merkaba kernel: [183059.738982]  mapped:83064 shmem:478891 pagetables:15382 bounce:0
Mar  4 22:56:00 merkaba kernel: [183059.738982]  free_cma:0
Mar  4 22:56:00 merkaba kernel: [183059.738987] Node 0 DMA free:15344kB min:376kB low:468kB high:564kB active_anon:0kB inactive_anon:0kB active_file:0kB 
inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB managed:15360kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? 
yes
Mar  4 22:56:00 merkaba kernel: [183059.738994] lowmem_reserve[]: 0 3316 7827 7827
Mar  4 22:56:00 merkaba kernel: [183059.738998] Node 0 DMA32 free:102440kB min:84592kB low:105740kB high:126888kB active_anon:2595396kB inactive_anon:588040kB 
active_file:2744kB inactive_file:4600kB unevictable:2048kB isolated(anon):1408kB isolated(file):0kB present:3396580kB managed:3363528kB mlocked:2048kB dirty:36kB 
writeback:0kB mapped:122772kB shmem:838084kB slab_reclaimable:18164kB slab_unreclaimable:8708kB kernel_stack:328kB pagetables:7028kB unstable:0kB bounce:0kB 
free_cma:0kB writeback_tmp:0kB pages_scanned:4958634 all_unreclaimable? yes
Mar  4 22:56:00 merkaba kernel: [183059.739006] lowmem_reserve[]: 0 0 4510 4510
Mar  4 22:56:00 merkaba kernel: [183059.739010] Node 0 Normal free:98360kB min:115028kB low:143784kB high:172540kB active_anon:3334820kB inactive_anon:839372kB 
active_file:80kB inactive_file:244kB unevictable:35184kB isolated(anon):0kB isolated(file):0kB present:4618656kB managed:4561296kB mlocked:35184kB dirty:0kB 
writeback:0kB mapped:209484kB shmem:1077480kB slab_reclaimable:87592kB slab_unreclaimable:56052kB kernel_stack:3848kB pagetables:54500kB unstable:0kB bounce:0kB 
free_cma:0kB writeback_tmp:0kB pages_scanned:7229659 all_unreclaimable? yes
Mar  4 22:56:00 merkaba kernel: [183059.739017] lowmem_reserve[]: 0 0 0 0
Mar  4 22:56:00 merkaba kernel: [183059.739021] Node 0 DMA: 0*4kB 0*8kB 1*16kB (U) 1*32kB (U) 1*64kB (U) 1*128kB (U) 1*256kB (U) 1*512kB (U) 0*1024kB 1*2048kB (R) 
3*4096kB (M) = 15344kB
Mar  4 22:56:00 merkaba kernel: [183059.739037] Node 0 DMA32: 99*4kB (UEM) 672*8kB (UEM) 1272*16kB (UEM) 753*32kB (UEM) 326*64kB (UEM) 104*128kB (UEM) 21*256kB (UEM) 
7*512kB (UE) 7*1024kB (EM) 1*2048kB (E) 0*4096kB = 102572kB
Mar  4 22:56:00 merkaba kernel: [183059.739054] Node 0 Normal: 5490*4kB (UEM) 3550*8kB (UEM) 1674*16kB (UEM) 651*32kB (UEM) 4*64kB (EM) 1*128kB (E) 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 98360kB
Mar  4 22:56:00 merkaba kernel: [183059.739068] 498104 total pagecache pages
Mar  4 22:56:00 merkaba kernel: [183059.739070] 15592 pages in swap cache
Mar  4 22:56:00 merkaba kernel: [183059.739072] Swap cache stats: add 2806076, delete 2790484, find 1722817/1824265
Mar  4 22:56:00 merkaba kernel: [183059.739073] Free swap  = 10775272kB
Mar  4 22:56:00 merkaba kernel: [183059.739075] Total swap = 12582908kB
Mar  4 22:56:00 merkaba kernel: [183059.793481] 2057712 pages RAM
Mar  4 22:56:00 merkaba kernel: [183059.793485] 69338 pages reserved
Mar  4 22:56:00 merkaba kernel: [183059.793487] 1614141 pages shared
Mar  4 22:56:00 merkaba kernel: [183059.793489] 1438560 pages non-shared
Mar  4 22:56:00 merkaba kernel: [183059.793490] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
Mar  4 22:56:00 merkaba kernel: [183059.793501] [  375]     0   375    67356      327      49       39             0 systemd-journal
Mar  4 22:56:00 merkaba kernel: [183059.793505] [  380]     0   380     5440      303      17      165         -1000 udevd
Mar  4 22:56:00 merkaba kernel: [183059.793511] [ 1208]     0  1208     4168       42      11       34             0 atd
Mar  4 22:56:00 merkaba kernel: [183059.793515] [ 1268]     0  1268     2610      140      10       31             0 inetd
Mar  4 22:56:00 merkaba kernel: [183059.793518] [ 1270]     0  1270     3247       75      10       20             0 mdadm
Mar  4 22:56:00 merkaba kernel: [183059.793521] [ 1280]     0  1280    19053      510      40       97             0 cupsd
Mar  4 22:56:00 merkaba kernel: [183059.793524] [ 1309]   103  1309     8596      306      23       24             0 avahi-daemon
Mar  4 22:56:00 merkaba kernel: [183059.793527] [ 1324]   103  1324     8509       38      21       50             0 avahi-daemon
Mar  4 22:56:00 merkaba kernel: [183059.793530] [ 1355]     0  1355     1675      139       9       11             0 vnstatd
Mar  4 22:56:00 merkaba kernel: [183059.793534] [ 1391]   102  1391     8009      623      21       87          -900 dbus-daemon
Mar  4 22:56:00 merkaba kernel: [183059.793538] [ 1432]     0  1432     1194      362       9        4             0 acpid
Mar  4 22:56:00 merkaba kernel: [183059.793541] [ 1471]     0  1471    18529     7796      41        0             0 lightdm
Mar  4 22:56:00 merkaba kernel: [183059.793544] [ 1541]     0  1541    41647     1043      46       82             0 NetworkManager
Mar  4 22:56:00 merkaba kernel: [183059.793547] [ 1547]     0  1547     5086      226      15       33             0 cron
Mar  4 22:56:00 merkaba kernel: [183059.793550] [ 1553]     0  1553     7775      150      20      105             0 wpa_supplicant
Mar  4 22:56:00 merkaba kernel: [183059.793553] [ 1567]     0  1567     8623      293      23       24             0 systemd-logind
Mar  4 22:56:00 merkaba kernel: [183059.793556] [ 1572]     0  1572    50019    20557     111      451             0 Xorg
Mar  4 22:56:00 merkaba kernel: [183059.793559] [ 1573]     0  1573    65245      750      34      147             0 console-kit-dae
Mar  4 22:56:00 merkaba kernel: [183059.793562] [ 1575]   116  1575     9908      161      18       50             0 rtkit-daemon
Mar  4 22:56:00 merkaba kernel: [183059.793565] [ 1576]     0  1576    39565      764      43       74             0 upowerd
Mar  4 22:56:00 merkaba kernel: [183059.793568] [ 1656]     0  1656     3689      183      12       39             0 agetty
Mar  4 22:56:00 merkaba kernel: [183059.793571] [ 1714]   119  1714    40724      884      43      826             0 colord
Mar  4 22:56:00 merkaba kernel: [183059.793574] [ 1722]     0  1722    32621     1261      32       69             0 polkitd
Mar  4 22:56:00 merkaba kernel: [183059.793577] [ 1727]     0  1727    29650      298      23      140             0 rsyslogd
Mar  4 22:56:00 merkaba kernel: [183059.793580] [ 1827]     0  1827    19736      451      43       74          -900 modem-manager
Mar  4 22:56:00 merkaba kernel: [183059.793583] [ 2061]     0  2061     9448      269      24       84             0 master
Mar  4 22:56:00 merkaba kernel: [183059.793586] [ 2065]     0  2065      986        0       7       20             0 acpi_fakekeyd
Mar  4 22:56:00 merkaba kernel: [183059.793589] [ 2075]   122  2075     6048       75      15       70             0 dbus-launch
Mar  4 22:56:00 merkaba kernel: [183059.793592] [ 2076]   122  2076     7451       69      19       68             0 dbus-daemon
Mar  4 22:56:00 merkaba kernel: [183059.793596] [ 2287]     0  2287    47097      674      61      284             0 lightdm
Mar  4 22:56:00 merkaba kernel: [183059.793598] [ 2307]  1000  2307     1045      126       8       28             0 startkde
Mar  4 22:56:00 merkaba kernel: [183059.793601] [ 2334]  1000  2334     3097       16       9       71             0 ssh-agent
Mar  4 22:56:00 merkaba kernel: [183059.793604] [ 2335]  1000  2335     4877      122      14       19             0 gpg-agent
Mar  4 22:56:00 merkaba kernel: [183059.793607] [ 2338]  1000  2338     6048       76      17       71             0 dbus-launch
Mar  4 22:56:00 merkaba kernel: [183059.793610] [ 2339]  1000  2339     8224      666      22       63             0 dbus-daemon
Mar  4 22:56:00 merkaba kernel: [183059.793613] [ 2362]  1000  2362     4785       95      12       43             0 gpg-agent
Mar  4 22:56:00 merkaba kernel: [183059.793616] [ 2379]  1000  2379      986        8       7       13             0 start_kdeinit
Mar  4 22:56:00 merkaba kernel: [183059.793619] [ 2380]  1000  2380    86052      562     144     1225             0 kdeinit4
Mar  4 22:56:00 merkaba kernel: [183059.793622] [ 2383]  1000  2383   199905     3703     267     1680             0 kded4
Mar  4 22:56:00 merkaba kernel: [183059.793625] [ 2391]  1000  2391    71928     1481     131      480             0 kglobalaccel
Mar  4 22:56:00 merkaba kernel: [183059.793628] [ 2393]  1000  2393    73881     2045     129      463             0 kwalletd
Mar  4 22:56:00 merkaba kernel: [183059.793631] [ 2396]     0  2396    34092     1378      36       33             0 udisks-daemon
Mar  4 22:56:00 merkaba kernel: [183059.793633] [ 2398]     0  2398    11374      114      26       69             0 udisks-daemon
Mar  4 22:56:00 merkaba kernel: [183059.793636] [ 2401]  1000  2401    94122      811     138     1024             0 kactivitymanage
Mar  4 22:56:00 merkaba kernel: [183059.793639] [ 2402]  1000  2402     1020       58       8       22             0 kwrapper4
Mar  4 22:56:00 merkaba kernel: [183059.793642] [ 2403]  1000  2403   130710      800     185     1743             0 ksmserver
Mar  4 22:56:00 merkaba kernel: [183059.793645] [ 2412]  1000  2412   165479     5249     237     1936             0 knotify4
Mar  4 22:56:00 merkaba kernel: [183059.793647] [ 2416]  1000  2416   806336    62563     425     3494             0 plasma-desktop
Mar  4 22:56:00 merkaba kernel: [183059.793650] [ 2419]  1000  2419     2312      255       9       40             0 ksysguardd
Mar  4 22:56:00 merkaba kernel: [183059.793653] [ 2430]  1000  2430    70579      835     128      796             0 kuiserver
Mar  4 22:56:00 merkaba kernel: [183059.793656] [ 2434]  1000  2434    40629      463      38      132             0 akonadi_control
Mar  4 22:56:00 merkaba kernel: [183059.793659] [ 2436]  1000  2436   108085     1598      90     1249             0 akonadiserver
Mar  4 22:56:00 merkaba kernel: [183059.793662] [ 2443]  1000  2443    25608     1394      41      210             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793665] [ 2448]  1000  2448    25604      475      44      204             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793668] [ 2449]  1000  2449    25604      163      35      225             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793670] [ 2450]  1000  2450    25820      261      37      322             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793674] [ 2451]  1000  2451    17732      144      34      219             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793677] [ 2454]  1000  2454    26495     2825      47      467             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793680] [ 2460]  1000  2460    26262      209      40      481             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793683] [ 2461]  1000  2461    26262      141      40      481             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793686] [ 2462]  1000  2462    26262      143      40      481             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793689] [ 2466]  1000  2466    80073      758     145      973             0 akonadi_birthda
Mar  4 22:56:00 merkaba kernel: [183059.793693] [ 2467]  1000  2467    78288     1191     144      840             0 akonadi_contact
Mar  4 22:56:00 merkaba kernel: [183059.793696] [ 2468]  1000  2468   102762    18706     192     2342             0 akonadi_ical_re
Mar  4 22:56:00 merkaba kernel: [183059.793699] [ 2469]  1000  2469    83862     2262     154      413             0 akonadi_ical_re
Mar  4 22:56:00 merkaba kernel: [183059.793702] [ 2470]  1000  2470    78017      742     140      999             0 akonadi_maildir
Mar  4 22:56:00 merkaba kernel: [183059.793706] [ 2471]  1000  2471    77086      716     142     1019             0 akonadi_maildis
Mar  4 22:56:00 merkaba kernel: [183059.793709] [ 2472]  1000  2472    76391      736     139      965             0 akonadi_vcarddi
Mar  4 22:56:00 merkaba kernel: [183059.793712] [ 2475]  1000  2475    26262      143      40      481             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793715] [ 2476]  1000  2476    26486     1416      47      360             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793718] [ 2488]  1000  2488    26262      204      41      512             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793721] [ 2489]  1000  2489    26463      249      43      630             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793724] [ 2490]  1000  2490    26262      143      40      481             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793727] [ 2491]  1000  2491    26450      210      42      607             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793730] [ 2492]  1000  2492    26455      213      43      614             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793734] [ 2493]  1000  2493    26467      488      44      380             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793736] [ 2494]  1000  2494    26467      488      44      390             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793739] [ 2503]  1000  2503    40538      401      73      451             0 nepomukserver
Mar  4 22:56:00 merkaba kernel: [183059.793742] [ 2508]  1000  2508   185633     5978     200     3228             0 nepomukservices
Mar  4 22:56:00 merkaba kernel: [183059.793745] [ 2509]  1000  2509   278304    13822     334     2189             0 krunner
Mar  4 22:56:00 merkaba kernel: [183059.793748] [ 2516]  1000  2516   127285    56910     178     2980             0 virtuoso-t
Mar  4 22:56:00 merkaba kernel: [183059.793751] [ 2520]  1000  2520    26280      214      41      544             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793754] [ 2523]  1000  2523    73728      612     134      980             0 krandrtray
Mar  4 22:56:00 merkaba kernel: [183059.793757] [ 2525]  1000  2525    95562      927     143     1249             0 kgpg
Mar  4 22:56:00 merkaba kernel: [183059.793760] [ 2527]  1000  2527    98216     5885     175      936             0 konsole
Mar  4 22:56:00 merkaba kernel: [183059.793763] [ 2533]  1000  2533   103808     2432     184     6058             0 basket
Mar  4 22:56:00 merkaba kernel: [183059.793766] [ 2535]  1000  2535     9441      266      23      404             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793769] [ 2538]  1000  2538     9441      387      23      287             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793772] [ 2540]  1000  2540    73861      472     135     1076             0 nepomukcontroll
Mar  4 22:56:00 merkaba kernel: [183059.793775] [ 2541]  1000  2541    10014      343      23      397             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793778] [ 2544]  1000  2544    10014      332      24      405             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793781] [ 2546]  1000  2546    10049      344      23      403             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793784] [ 2552]  1000  2552    10002      317      25      403             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793788] [ 2554]  1000  2554     9441      238      23      414             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793791] [ 2610]  1000  2610   111101     3598     167     1362             0 konsole
Mar  4 22:56:00 merkaba kernel: [183059.793793] [ 2628]  1000  2628     9441      270      22      404             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793796] [ 2630]  1000  2630     9441      243      22      415             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793799] [ 2633]  1000  2633    10028      344      24      399             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793802] [ 2642]  1000  2642     9442      243      23      414             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793805] [ 2647]  1000  2647     9441      243      22      413             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793808] [ 2656]  1000  2656     9441      243      23      414             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793811] [ 2671]  1000  2671     9441      243      22      414             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793814] [ 2680]  1000  2680   283298    48000     505    80424             0 kontact
Mar  4 22:56:00 merkaba kernel: [183059.793817] [ 2707]  1000  2707   599603    68661     555    25769             0 akregator
Mar  4 22:56:00 merkaba kernel: [183059.793821] [ 2709]  1000  2709    75209      601     134     1012             0 akonaditray
Mar  4 22:56:00 merkaba kernel: [183059.793824] [ 2735]  1000  2735    73920      840     107      788             0 nepomukservices
Mar  4 22:56:00 merkaba kernel: [183059.793827] [ 2737]  1000  2737   107122     8956     133      578             0 nepomukservices
Mar  4 22:56:00 merkaba kernel: [183059.793830] [ 2738]  1000  2738    71247      846     132     1909             0 nepomukservices
Mar  4 22:56:00 merkaba kernel: [183059.793833] [ 2739]  1000  2739    77718     1232     110      509             0 nepomukservices
Mar  4 22:56:00 merkaba kernel: [183059.793836] [ 2758]  1000  2758   161603     3028     205     1767             0 kmix
Mar  4 22:56:00 merkaba kernel: [183059.793838] [ 2765]  1000  2765   199417    35685     350    41690             0 korgac
Mar  4 22:56:00 merkaba kernel: [183059.793841] [ 2766]  1000  2766    26484      726      44      193             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793844] [ 2786]  1000  2786   115097     6048     213        0             0 hp-systray
Mar  4 22:56:00 merkaba kernel: [183059.793847] [ 2792]  1000  2792    96145     1907     145        0             0 polkit-kde-auth
Mar  4 22:56:00 merkaba kernel: [183059.793850] [ 2800]  1000  2800    75217     1255     137      325             0 klipper
Mar  4 22:56:00 merkaba kernel: [183059.793853] [ 2801]  1000  2801    36460     3015      72        0             0 hp-systray
Mar  4 22:56:00 merkaba kernel: [183059.793856] [ 2802]  1000  2802    28532     2360      54        0             0 hp-systray
Mar  4 22:56:00 merkaba kernel: [183059.793860] [ 2899]  1000  2899    26491      738      44      184             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793863] [ 3262]  1000  3262    75022     3112     135        0             0 kwalletmanager
Mar  4 22:56:00 merkaba kernel: [183059.793866] [ 3680]  1000  3680    48072     1511      86        0             0 kio_http_cache_
Mar  4 22:56:00 merkaba kernel: [183059.793869] [ 3741]  1000  3741    21961      473      46        0             0 su
Mar  4 22:56:00 merkaba kernel: [183059.793872] [ 3750]     0  3750    10645      820      24        0             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793875] [18470]  1000 18470    13443      577      30        0             0 gconfd-2
Mar  4 22:56:00 merkaba kernel: [183059.793878] [18486]  1000 18486    35675      664      32        0             0 at-spi-bus-laun
Mar  4 22:56:00 merkaba kernel: [183059.793881] [18491]  1000 18491    15086      541      34        0             0 gvfsd
Mar  4 22:56:00 merkaba kernel: [183059.793884] [18554]  1000 18554    26280      572      41      188             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793888] [29609]  1000 29609   266690    87975     453        0             0 kmail
Mar  4 22:56:00 merkaba kernel: [183059.793891] [16603]  1000 16603    26262      494      40      191             0 postgres
Mar  4 22:56:00 merkaba kernel: [183059.793894] [21056]     0 21056    87618     1207     108        0             0 libvirtd
Mar  4 22:56:00 merkaba kernel: [183059.793897] [21212]   123 21212    71555     8086      81        0             0 ntop
Mar  4 22:56:00 merkaba kernel: [183059.793899] [14779]     0 14779     7809      301      19        0             0 ntpd
Mar  4 22:56:00 merkaba kernel: [183059.793903] [14780]   110 14780     6243      216      16        0             0 ntpd
Mar  4 22:56:00 merkaba kernel: [183059.793906] [20563]   120 20563     4297      170      13        0             0 dirmngr
Mar  4 22:56:00 merkaba kernel: [183059.793909] [20602]   115 20602    48717      727      29        0             0 privoxy
Mar  4 22:56:00 merkaba kernel: [183059.793912] [22394]  1000 22394    38008      787      72        0             0 kdeinit4
Mar  4 22:56:00 merkaba kernel: [183059.793916] [22396]  1000 22396    48429      997      86        0             0 klauncher
Mar  4 22:56:00 merkaba kernel: [183059.793919] [22741]  1000 22741     6548      388      16        0             0 tmux
Mar  4 22:56:00 merkaba kernel: [183059.793922] [22742]  1000 22742     9441      673      22        0             0 zsh
Mar  4 22:56:00 merkaba kernel: [183059.793925] [28171]  1000 28171    39894     1343      42        0             0 gvfs-gdu-volume
Mar  4 22:56:00 merkaba kernel: [183059.793929] [28173]  1000 28173    14634      525      34        0             0 gvfs-gphoto2-vo
Mar  4 22:56:00 merkaba kernel: [183059.793931] [28175]  1000 28175    19761      474      38        0             0 gvfs-afc-volume
Mar  4 22:56:00 merkaba kernel: [183059.793934] [28193]  1000 28193    13933      641      32        0             0 gvfsd-metadata
Mar  4 22:56:00 merkaba kernel: [183059.793936] [29811]  1000 29811   699624    10814     247        0             0 kwin
Mar  4 22:56:00 merkaba kernel: [183059.793939] [22771]     0 22771     5439      194      15      160         -1000 udevd
Mar  4 22:56:00 merkaba kernel: [183059.793943] [ 2990]     0  2990    28117     3450      58        0             0 Xorg
Mar  4 22:56:00 merkaba kernel: [183059.793946] [ 2999]     0  2999    44965      914      56        0             0 lightdm
Mar  4 22:56:00 merkaba kernel: [183059.793949] [ 3008]   122  3008   687447     8037     221        0             0 lightdm-kde-gre
Mar  4 22:56:00 merkaba kernel: [183059.793952] [ 3012]   122  3012     6048      109      17        0             0 dbus-launch
Mar  4 22:56:00 merkaba kernel: [183059.793955] [ 3013]   122  3013     7451      157      19        0             0 dbus-daemon
Mar  4 22:56:00 merkaba kernel: [183059.793959] [ 4576]     0  4576     5439      168      15      162         -1000 udevd
Mar  4 22:56:00 merkaba kernel: [183059.793962] [ 4665]     0  4665     6157     1985      18        0             0 atop
Mar  4 22:56:00 merkaba kernel: [183059.793966] [ 4870]     0  4870     2493      748       9        0             0 dhclient
Mar  4 22:56:00 merkaba kernel: [183059.793968] [ 5025]     0  5025    12463      246      26        0         -1000 sshd
Mar  4 22:56:00 merkaba kernel: [183059.793971] [ 5054]   111  5054     9978      306      23        0             0 qmgr
Mar  4 22:56:00 merkaba kernel: [183059.793975] [ 8938]  1000  8938    77932     7224     104        0             0 pslaunch.bin
Mar  4 22:56:00 merkaba kernel: [183059.793978] [ 8959]  1000  8959  1635145   921796    3072        0             0 psclient.bin
Mar  4 22:56:00 merkaba kernel: [183059.793982] [ 9089]  1000  9089   101613     6897     152        0             0 ksnapshot
Mar  4 22:56:00 merkaba kernel: [183059.793984] [ 9200]   111  9200     9965      318      22        0             0 pickup
Mar  4 22:56:00 merkaba kernel: [183059.793989] Out of memory: Kill process 8959 (psclient.bin) score 180 or sacrifice child
Mar  4 22:56:00 merkaba kernel: [183059.793993] Killed process 8959 (psclient.bin) total-vm:6540580kB, anon-rss:3440360kB, file-rss:246824kB
Mar  4 22:56:00 merkaba kernel: [183060.485926] psclient.bin: page allocation failure: order:0, mode:0x50
Mar  4 22:56:00 merkaba kernel: [183060.485932] Pid: 8959, comm: psclient.bin Tainted: G           O 3.8.0-tp520 #40
Mar  4 22:56:00 merkaba kernel: [183060.485934] Call Trace:
Mar  4 22:56:00 merkaba kernel: [183060.485943]  [<ffffffff810d4a57>] warn_alloc_failed+0x10a/0x11e
Mar  4 22:56:00 merkaba kernel: [183060.485948]  [<ffffffff810e8373>] ? wait_iff_congested+0xd5/0x124
Mar  4 22:56:00 merkaba kernel: [183060.485952]  [<ffffffff810d77cf>] __alloc_pages_nodemask+0x624/0x6c7
Mar  4 22:56:00 merkaba kernel: [183060.485957]  [<ffffffff811066a1>] alloc_pages_current+0xc0/0xdd
Mar  4 22:56:00 merkaba kernel: [183060.485961]  [<ffffffff810d077c>] __page_cache_alloc+0x87/0x93
Mar  4 22:56:00 merkaba kernel: [183060.485964]  [<ffffffff810d0d3b>] find_or_create_page+0x3f/0x86
Mar  4 22:56:00 merkaba kernel: [183060.486000]  [<ffffffffa01d9ffb>] alloc_extent_buffer+0xcc/0x2eb [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486017]  [<ffffffffa01bd2d1>] btrfs_find_create_tree_block+0x20/0x22 [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486031]  [<ffffffffa01bd42a>] read_tree_block+0x16/0x38 [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486043]  [<ffffffffa01a7666>] read_block_for_search.isra.47+0x286/0x2be [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486055]  [<ffffffffa01a8f16>] btrfs_search_slot+0x37d/0x52d [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486070]  [<ffffffffa01b8d40>] btrfs_lookup_file_extent+0x33/0x35 [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486086]  [<ffffffffa01c60a7>] btrfs_get_extent+0x175/0x7e7 [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486091]  [<ffffffff8142377e>] ? _raw_spin_lock_irq+0x20/0x24
Mar  4 22:56:00 merkaba kernel: [183060.486094]  [<ffffffff81423830>] ? _raw_spin_unlock_irq+0x2b/0x36
Mar  4 22:56:00 merkaba kernel: [183060.486111]  [<ffffffffa01d402c>] ? spin_unlock_irq+0x9/0xb [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486128]  [<ffffffffa01d8d2a>] __extent_read_full_page+0x26d/0x536 [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486131]  [<ffffffff810da215>] ? hpage_nr_pages+0x20/0x20
Mar  4 22:56:00 merkaba kernel: [183060.486147]  [<ffffffffa01c5f32>] ? can_nocow_odirect+0x1ec/0x1ec [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486162]  [<ffffffffa01c5f32>] ? can_nocow_odirect+0x1ec/0x1ec [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486179]  [<ffffffffa01d9c0b>] extent_readpages+0x107/0x1a7 [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486194]  [<ffffffffa01c4419>] btrfs_readpages+0x1a/0x1c [btrfs]
Mar  4 22:56:00 merkaba kernel: [183060.486197]  [<ffffffff810d990c>] __do_page_cache_readahead+0x13a/0x1da
Mar  4 22:56:00 merkaba kernel: [183060.486201]  [<ffffffff810d9c28>] ra_submit+0x1c/0x20
Mar  4 22:56:00 merkaba kernel: [183060.486204]  [<ffffffff810d201d>] filemap_fault+0x172/0x35f
Mar  4 22:56:00 merkaba kernel: [183060.486208]  [<ffffffff810ee5e0>] __do_fault+0xa6/0x351
Mar  4 22:56:00 merkaba kernel: [183060.486211]  [<ffffffff810f0c68>] handle_pte_fault+0x28e/0x73f
Mar  4 22:56:00 merkaba kernel: [183060.486215]  [<ffffffff810edf86>] ? pmd_offset+0x10/0x3d
Mar  4 22:56:00 merkaba kernel: [183060.486218]  [<ffffffff810f148d>] handle_mm_fault+0x1d8/0x1f2
Mar  4 22:56:00 merkaba kernel: [183060.486222]  [<ffffffff8142650d>] __do_page_fault+0x37b/0x3c5
Mar  4 22:56:00 merkaba kernel: [183060.486227]  [<ffffffff8100e038>] ? paravirt_write_msr+0xf/0x13
Mar  4 22:56:00 merkaba kernel: [183060.486231]  [<ffffffff8100e6c9>] ? __switch_to+0x1e7/0x443
Mar  4 22:56:00 merkaba kernel: [183060.486236]  [<ffffffff81064c91>] ? mmdrop+0x12/0x22
Mar  4 22:56:00 merkaba kernel: [183060.486239]  [<ffffffff810663a2>] ? finish_task_switch+0x82/0xad
Mar  4 22:56:00 merkaba kernel: [183060.486242]  [<ffffffff81422851>] ? __schedule+0x57f/0x5b2
Mar  4 22:56:00 merkaba kernel: [183060.486245]  [<ffffffff81426560>] do_page_fault+0x9/0xb
Mar  4 22:56:00 merkaba kernel: [183060.486248]  [<ffffffff81423e08>] page_fault+0x28/0x30
Mar  4 22:56:00 merkaba kernel: [183060.486250] Mem-Info:
Mar  4 22:56:00 merkaba kernel: [183060.486252] Node 0 DMA per-cpu:
Mar  4 22:56:00 merkaba kernel: [183060.486255] CPU    0: hi:    0, btch:   1 usd:   0
Mar  4 22:56:00 merkaba kernel: [183060.486257] CPU    1: hi:    0, btch:   1 usd:   0
Mar  4 22:56:00 merkaba kernel: [183060.486259] CPU    2: hi:    0, btch:   1 usd:   0
Mar  4 22:56:00 merkaba kernel: [183060.486261] CPU    3: hi:    0, btch:   1 usd:   0
Mar  4 22:56:00 merkaba kernel: [183060.486262] Node 0 DMA32 per-cpu:
Mar  4 22:56:00 merkaba kernel: [183060.486265] CPU    0: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183060.486267] CPU    1: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183060.486269] CPU    2: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183060.486271] CPU    3: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183060.486272] Node 0 Normal per-cpu:
Mar  4 22:56:00 merkaba kernel: [183060.486274] CPU    0: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183060.486276] CPU    1: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183060.486278] CPU    2: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183060.486280] CPU    3: hi:  186, btch:  31 usd:   0
Mar  4 22:56:00 merkaba kernel: [183060.486285] active_anon:1482554 inactive_anon:356806 isolated_anon:352
Mar  4 22:56:00 merkaba kernel: [183060.486285]  active_file:726 inactive_file:1255 isolated_file:0
Mar  4 22:56:00 merkaba kernel: [183060.486285]  unevictable:9308 dirty:9 writeback:0 unstable:0
Mar  4 22:56:00 merkaba kernel: [183060.486285]  free:54093 slab_reclaimable:26440 slab_unreclaimable:16194
Mar  4 22:56:00 merkaba kernel: [183060.486285]  mapped:83064 shmem:478891 pagetables:15382 bounce:0
Mar  4 22:56:00 merkaba kernel: [183060.486285]  free_cma:0
Mar  4 22:56:00 merkaba kernel: [183060.486290] Node 0 DMA free:15344kB min:376kB low:468kB high:564kB active_anon:0kB inactive_anon:0kB active_file:0kB 
inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15104kB managed:15360kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? 
yes
Mar  4 22:56:00 merkaba kernel: [183060.486298] lowmem_reserve[]: 0 3316 7827 7827
Mar  4 22:56:00 merkaba kernel: [183060.486302] Node 0 DMA32 free:102580kB min:84592kB low:105740kB high:126888kB active_anon:2595396kB inactive_anon:589044kB 
active_file:2748kB inactive_file:4940kB unevictable:2048kB isolated(anon):512kB isolated(file):0kB present:3396580kB managed:3363528kB mlocked:2048kB dirty:36kB 
writeback:0kB mapped:122772kB shmem:838084kB slab_reclaimable:18168kB slab_unreclaimable:8708kB kernel_stack:320kB pagetables:7028kB unstable:0kB bounce:0kB 
free_cma:0kB writeback_tmp:0kB pages_scanned:4060915 all_unreclaimable? no
Mar  4 22:56:00 merkaba kernel: [183060.486311] lowmem_reserve[]: 0 0 4510 4510
Mar  4 22:56:00 merkaba kernel: [183060.486315] Node 0 Normal free:98448kB min:115028kB low:143784kB high:172540kB active_anon:3334820kB inactive_anon:838180kB 
active_file:156kB inactive_file:80kB unevictable:35184kB isolated(anon):896kB isolated(file):0kB present:4618656kB managed:4561296kB mlocked:35184kB dirty:0kB 
writeback:0kB mapped:209484kB shmem:1077480kB slab_reclaimable:87592kB slab_unreclaimable:56052kB kernel_stack:3816kB pagetables:54500kB unstable:0kB bounce:0kB 
free_cma:0kB writeback_tmp:0kB pages_scanned:2963820 all_unreclaimable? no
Mar  4 22:56:00 merkaba kernel: [183060.486322] lowmem_reserve[]: 0 0 0 0
Mar  4 22:56:00 merkaba kernel: [183060.486326] Node 0 DMA: 0*4kB 0*8kB 1*16kB (U) 1*32kB (U) 1*64kB (U) 1*128kB (U) 1*256kB (U) 1*512kB (U) 0*1024kB 1*2048kB (R) 
3*4096kB (M) = 15344kB
Mar  4 22:56:00 merkaba kernel: [183060.486343] Node 0 DMA32: 99*4kB (UEM) 673*8kB (UEM) 1272*16kB (UEM) 753*32kB (UEM) 326*64kB (UEM) 104*128kB (UEM) 21*256kB (UEM) 
7*512kB (UE) 7*1024kB (EM) 1*2048kB (E) 0*4096kB = 102580kB
Mar  4 22:56:00 merkaba kernel: [183060.486360] Node 0 Normal: 5518*4kB (UEM) 3554*8kB (UEM) 1674*16kB (UEM) 650*32kB (UEM) 4*64kB (EM) 1*128kB (E) 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 98472kB
Mar  4 22:56:00 merkaba kernel: [183060.486375] 498187 total pagecache pages
Mar  4 22:56:00 merkaba kernel: [183060.486376] 15592 pages in swap cache
Mar  4 22:56:00 merkaba kernel: [183060.486378] Swap cache stats: add 2806076, delete 2790484, find 1722817/1824265
Mar  4 22:56:00 merkaba kernel: [183060.486380] Free swap  = 10775272kB
Mar  4 22:56:00 merkaba kernel: [183060.486381] Total swap = 12582908kB
Mar  4 22:56:00 merkaba kernel: [183061.128436] 2057712 pages RAM
Mar  4 22:56:00 merkaba kernel: [183061.128441] 69338 pages reserved
Mar  4 22:56:00 merkaba kernel: [183061.128442] 1614369 pages shared
Mar  4 22:56:00 merkaba kernel: [183061.128444] 1438479 pages non-shared
Mar  4 22:56:01 merkaba rtkit-daemon[1575]: Demoting known real-time threads.
Mar  4 22:56:01 merkaba rtkit-daemon[1575]: Demoted 0 threads.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
