Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:53928 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbcKRKgT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 05:36:19 -0500
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        James Pharaoh <james@wellbehavedsoftware.com>,
        Mark Fasheh <mfasheh@versity.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Announcing btrfs-dedupe
Date: Fri, 18 Nov 2016 11:36:11 +0100
MIME-Version: 1.0
Message-ID: <924b2e72-4e12-4911-a7ec-5f40994461cc@linuxsystems.it>
In-Reply-To: <20161117030150.GM21290@hungrycats.org>
References: <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
 <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
 <dfb1372d-8bff-93ff-1ba7-d636e6c7fe4d@gmail.com>
 <20161114195102.GI21290@hungrycats.org>
 <4389716b-8082-ef89-7efc-60c2ae6b7db6@gmail.com>
 <20161114211013.GJ21290@hungrycats.org>
 <0b8cd1f0-fca4-b7df-2f41-13c40aee493d@gmail.com>
 <20161115175201.GL21290@hungrycats.org>
 <138b6c00-fb34-492b-92ae-d13630e0bb04@linuxsystems.it>
 <20161117030150.GM21290@hungrycats.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On giovedì 17 novembre 2016 04:01:52 CET, Zygo Blaxell wrote:
> Duperemove does use a lot of memory, but the logs at that URL only show
> 2G of RAM in duperemove--not nearly enough to trigger OOM under normal
> conditions on an 8G machine.  There's another process with 6G of virtual
> address space (although much less than that resident) that looks more
> interesting (i.e. duperemove might just be the victim of some interaction
> between baloo_file and the OOM killer).

Thanks, I killed baloo_file before starting duperemove and it somehow 
improved (it reached 99.73% before getting killed by OOM killer once 
again):

[ 6342.147251] Purging GPU memory, 0 pages freed, 18268 pages still pinned.
[ 6342.147253] 48 and 0 pages still available in the bound and unbound GPU 
page lists.
[ 6342.147340] Xorg invoked oom-killer: 
gfp_mask=0x240c0d0(GFP_TEMPORARY|__GFP_COMP|__GFP_ZERO), order=3, 
oom_score_adj=0
[ 6342.147341] Xorg cpuset=/ mems_allowed=0
[ 6342.147346] CPU: 3 PID: 650 Comm: Xorg Not tainted 4.8.8-2-ARCH #1
[ 6342.147347] Hardware name: Dell Inc. XPS 13 9343/0F5KF3, BIOS A09 
08/29/2016
[ 6342.147348]  0000000000000286 000000009b89a9c8 ffff88020752f598 
ffffffff812fde10
[ 6342.147351]  ffff88020752f758 ffff8801edc62ac0 ffff88020752f608 
ffffffff81205fa2
[ 6342.147353]  000188020752f5a0 000000009b89a9c8 00000000ffffffff 
0000000000000000
[ 6342.147356] Call Trace:
[ 6342.147361]  [<ffffffff812fde10>] dump_stack+0x63/0x83
[ 6342.147364]  [<ffffffff81205fa2>] dump_header+0x5c/0x1ea
[ 6342.147366]  [<ffffffff8117ca35>] oom_kill_process+0x265/0x410
[ 6342.147368]  [<ffffffff810864c7>] ? has_capability_noaudit+0x17/0x20
[ 6342.147369]  [<ffffffff8117cfb0>] out_of_memory+0x380/0x420
[ 6342.147373]  [<ffffffff81312c48>] ? find_next_bit+0x18/0x20
[ 6342.147374]  [<ffffffff81182610>] __alloc_pages_nodemask+0xda0/0xde0
[ 6342.147377]  [<ffffffff811d6605>] alloc_pages_current+0x95/0x140
[ 6342.147380]  [<ffffffff811a3e6e>] kmalloc_order_trace+0x2e/0xf0
[ 6342.147382]  [<ffffffff811e1f4a>] __kmalloc+0x1ea/0x200
[ 6342.147397]  [<ffffffffa05f825e>] ? alloc_gen8_temp_bitmaps+0x2e/0x80 
[i915]
[ 6342.147407]  [<ffffffffa05f8277>] alloc_gen8_temp_bitmaps+0x47/0x80 
[i915]
[ 6342.147417]  [<ffffffffa05fb648>] gen8_alloc_va_range_3lvl+0x98/0x9c0 
[i915]
[ 6342.147419]  [<ffffffff81197f3d>] ? shmem_getpage_gfp+0xed/0xc30
[ 6342.147421]  [<ffffffff8130e3ba>] ? sg_init_table+0x1a/0x40
[ 6342.147423]  [<ffffffff813292e3>] ? swiotlb_map_sg_attrs+0x53/0x130
[ 6342.147432]  [<ffffffffa05fc1c6>] gen8_alloc_va_range+0x256/0x490 [i915]
[ 6342.147442]  [<ffffffffa05fea7b>] i915_vma_bind+0x9b/0x190 [i915]
[ 6342.147453]  [<ffffffffa060522b>] i915_gem_object_do_pin+0x86b/0xa90 
[i915]
[ 6342.147463]  [<ffffffffa060547d>] i915_gem_object_pin+0x2d/0x30 [i915]
[ 6342.147472]  [<ffffffffa05f316f>] 
i915_gem_execbuffer_reserve_vma.isra.7+0x9f/0x180 [i915]
[ 6342.147482]  [<ffffffffa05f35e6>] 
i915_gem_execbuffer_reserve.isra.8+0x396/0x3c0 [i915]
[ 6342.147491]  [<ffffffffa05f457b>] 
i915_gem_do_execbuffer.isra.14+0x68b/0x1270 [i915]
[ 6342.147493]  [<ffffffff8158ad31>] ? unix_stream_read_generic+0x281/0x8a0
[ 6342.147503]  [<ffffffffa05f5dc4>] i915_gem_execbuffer2+0x104/0x270 
[i915]
[ 6342.147509]  [<ffffffffa046cd40>] drm_ioctl+0x200/0x4f0 [drm]
[ 6342.147518]  [<ffffffffa05f5cc0>] ? i915_gem_execbuffer+0x330/0x330 
[i915]
[ 6342.147520]  [<ffffffff810ecc1d>] ? enqueue_hrtimer+0x3d/0xa0
[ 6342.147522]  [<ffffffff813061f4>] ? timerqueue_del+0x24/0x70
[ 6342.147523]  [<ffffffff810ececc>] ? __remove_hrtimer+0x3c/0x90
[ 6342.147525]  [<ffffffff8121c383>] do_vfs_ioctl+0xa3/0x5f0
[ 6342.147527]  [<ffffffff810ee65b>] ? do_setitimer+0x12b/0x230
[ 6342.147529]  [<ffffffff812275f7>] ? __fget+0x77/0xb0
[ 6342.147531]  [<ffffffff8121c949>] SyS_ioctl+0x79/0x90
[ 6342.147533]  [<ffffffff815f7e72>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[ 6342.147535] Mem-Info:
[ 6342.147538] active_anon:76311 inactive_anon:76782 isolated_anon:0
                active_file:347581 inactive_file:1415592 isolated_file:64
                unevictable:8 dirty:482 writeback:0 unstable:0
                slab_reclaimable:27219 slab_unreclaimable:14772
                mapped:20714 shmem:30458 pagetables:10557 bounce:0
                free:25642 free_pcp:327 free_cma:0
[ 6342.147541] Node 0 active_anon:305244kB inactive_anon:307128kB 
active_file:1390324kB inactive_file:5662368kB unevictable:32kB 
isolated(anon):0kB isolated(file):256kB mapped:82856kB dirty:1928kB 
writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 81920kB anon_thp: 
121832kB writeback_tmp:0kB unstable:0kB pages_scanned:32 all_unreclaimable? 
no
[ 6342.147542] Node 0 DMA free:15688kB min:132kB low:164kB high:196kB 
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB 
unevictable:0kB writepending:0kB present:15984kB managed:15896kB 
mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:208kB kernel_stack:0kB 
pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6342.147545] lowmem_reserve[]: 0 3395 7850 7850 7850
[ 6342.147548] Node 0 DMA32 free:48772kB min:29172kB low:36464kB 
high:43756kB active_anon:84724kB inactive_anon:87164kB active_file:555728kB 
inactive_file:2639796kB unevictable:0kB writepending:696kB 
present:3564504kB managed:3488752kB mlocked:0kB slab_reclaimable:47196kB 
slab_unreclaimable:11472kB kernel_stack:192kB pagetables:200kB bounce:0kB 
free_pcp:1284kB local_pcp:0kB free_cma:0kB
[ 6342.147553] lowmem_reserve[]: 0 0 4454 4454 4454
[ 6342.147555] Node 0 Normal free:38108kB min:38276kB low:47844kB 
high:57412kB active_anon:220520kB inactive_anon:219964kB 
active_file:834596kB inactive_file:3022312kB unevictable:32kB 
writepending:1232kB present:4694016kB managed:4561616kB mlocked:32kB 
slab_reclaimable:61680kB slab_unreclaimable:47408kB kernel_stack:7776kB 
pagetables:42028kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 6342.147558] lowmem_reserve[]: 0 0 0 0 0
[ 6342.147561] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 1*64kB (U) 2*128kB 
(U) 0*256kB 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15688kB
[ 6342.147570] Node 0 DMA32: 12108*4kB (UE) 29*8kB (UE) 0*16kB 0*32kB 
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 48664kB
[ 6342.147578] Node 0 Normal: 9514*4kB (UMH) 47*8kB (H) 0*16kB 0*32kB 
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 38432kB
[ 6342.147586] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 
hugepages_size=1048576kB
[ 6342.147588] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 
hugepages_size=2048kB
[ 6342.147589] 1796570 total pagecache pages
[ 6342.147591] 2853 pages in swap cache
[ 6342.147592] Swap cache stats: add 378584, delete 375731, find 
101539/126272
[ 6342.147592] Free swap  = 7743900kB
[ 6342.147593] Total swap = 8387904kB
[ 6342.147594] 2068626 pages RAM
[ 6342.147594] 0 pages HighMem/MovableOnly
[ 6342.147595] 52060 pages reserved
[ 6342.147595] 0 pages hwpoisoned
[ 6342.147596] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds 
swapents oom_score_adj name
[ 6342.147600] [  244]     0   244    21377     2220      37       4       
87             0 systemd-journal
[ 6342.147603] [  278]     0   278     9122       33      20       3      
334         -1000 systemd-udevd
[ 6342.147605] [  597]   192   597    35700       41      39       3      
146             0 systemd-timesyn
[ 6342.147607] [  601]    84   601    10328      158      24       3       
74             0 avahi-daemon
[ 6342.147609] [  603]     0   603     1841        3       9       3       
21             0 gpm
[ 6342.147610] [  604]     0   604     9294       32      21       3      
140             0 bluetoothd
[ 6342.147612] [  606]    84   606    10295        0      23       3       
78             0 avahi-daemon
[ 6342.147614] [  607]    81   607     8584      716      21       3       
95          -900 dbus-daemon
[ 6342.147615] [  609]     0   609     9635      373      23       3      
114             0 systemd-logind
[ 6342.147617] [  610]     0   610    90299     1407      74       3     
1048             0 NetworkManager
[ 6342.147619] [  629]     0   629    22126      369      46       3      
462             0 cupsd
[ 6342.147621] [  630]     0   630    10100        0      24       3      
143         -1000 sshd
[ 6342.147622] [  631]     0   631   186671       75     145       4     
1675             0 libvirtd
[ 6342.147624] [  633]     0   633    47157      132      44       3      
345             0 sddm
[ 6342.147626] [  650]     0   650    80478    10316     161       3     
2042             0 Xorg
[ 6342.147628] [  651]   124   651    78876       73      53       3     
2031             0 colord
[ 6342.147630] [  663]     0   663    79429      432     150       4      
621             0 smbd
[ 6342.147631] [  665]     0   665    78446        9     144       4      
643             0 smbd-notifyd
[ 6342.147634] [  666]     0   666    78444       10     142       4      
642             0 cleanupd
[ 6342.147635] [  669]     0   669    79429      664     145       4      
598             0 lpqd
[ 6342.147637] [  681]     0   681    10855        0      25       3      
114             0 wpa_supplicant
[ 6342.147639] [  689]   102   689   131227      585      53       3     
2366             0 polkitd
[ 6342.147640] [  777]    99   777    11640        0      26       3      
134             0 dnsmasq
[ 6342.147642] [  778]     0   778    11640        0      25       3      
132             0 dnsmasq
[ 6342.147644] [  838]    99   838    11640      108      24       3      
130             0 dnsmasq
[ 6342.147645] [  839]     0   839    11607        0      24       3       
90             0 dnsmasq
[ 6342.147647] [  844]     0   844    93062      666      46       3      
248             0 udisksd
[ 6342.147648] [  850]     0   850    75056      510      46       3      
285             0 upowerd
[ 6342.147650] [  883]     0   883    40487      226      69       3      
397             0 sddm-helper
[ 6342.147651] [  884]  1000   884    13702      505      31       3      
206             0 systemd
[ 6342.147653] [  885]  1000   885    24689       15      49       3      
428             0 (sd-pam)
[ 6342.147655] [  894]  1000   894     3425       51      11       3      
114             0 startkde
[ 6342.147656] [  901]  1000   901     8539       69      21       3      
419             0 dbus-daemon
[ 6342.147658] [  935]  1000   935     1526        0       8       3       
21             0 start_kdeinit
[ 6342.147659] [  936]  1000   936    75329      236     126       4      
762             0 kdeinit5
[ 6342.147661] [  937]  1000   937   129068       50     169       3      
942             0 klauncher
[ 6342.147662] [  940]  1000   940   367750     2255     318       5     
2577             0 kded5
[ 6342.147664] [  948]  1000   948   132228      123     168       4     
1562             0 kaccess
[ 6342.147666] [  962]  1000   962   136114      850      63       4      
439             0 mission-control
[ 6342.147667] [  967]  1000   967   129490      142     162       4     
1190             0 kglobalaccel5
[ 6342.147669] [  973]  1000   973    46251       73      26       3      
135             0 dconf-service
[ 6342.147670] [  980]  1000   980    21602       62      32       4      
145             0 kwrapper5
[ 6342.147672] [  981]  1000   981   159329      271     188       3     
1237             0 ksmserver
[ 6342.147673] [  991]  1000   991    89508      221      99       3      
502             0 kscreen_backend
[ 6342.147675] [  993]  1000   993   780636      196     268       5     
6207             0 kwin_x11
[ 6342.147677] [  996]  1000   996   164381      573     203       4     
1179             0 kdeconnectd
[ 6342.147678] [  997]  1000   997   190138      156     242       4     
4271             0 krunner
[ 6342.147680] [  999]  1000   999   928816    13708     461       5    
17112             0 plasmashell
[ 6342.147682] [ 1000]  1000  1000   172107      144     179       4     
1034             0 polkit-kde-auth
[ 6342.147683] [ 1001]  1000  1001   129793       58     167       3      
934             0 xembedsniproxy
[ 6342.147685] [ 1006]  1000  1006   127736      476     167       3      
860             0 org_kde_powerde
[ 6342.147686] [ 1007]  1000  1007   267637      360     284       4     
4630             0 korgac
[ 6342.147688] [ 1077]  1000  1077   125471       67      93       4     
1316             0 pulseaudio
[ 6342.147689] [ 1079]   133  1079    44462        0      22       3       
71             0 rtkit-daemon
[ 6342.147691] [ 1093]  1000  1093   199345       71      65       4     
5741             0 xiccd
[ 6342.147692] [ 1116]  1000  1116    21171        0      43       3      
175             0 gconf-helper
[ 6342.147694] [ 1118]  1000  1118    16483       25      34       3      
198             0 gconfd-2
[ 6342.147695] [ 1123]  1000  1123    70044        0      38       3      
225             0 gvfsd
[ 6342.147697] [ 1125]  1000  1125   226815      111     183       4     
1213             0 kactivitymanage
[ 6342.147701] [ 1130]  1000  1130    86949       69      35       3      
744             0 gvfsd-fuse
[ 6342.147702] [ 1146]  1000  1146   129379      146     164       3      
948             0 kactivitymanage
[ 6342.147704] [ 1150]  1000  1150   129380      130     158       4      
956             0 kactivitymanage
[ 6342.147705] [ 1195]  1000  1195    10293       44      24       3      
149             0 obexd
[ 6342.147707] [ 1197]  1000  1197   128967      247     166       3      
944             0 akonadi_control
[ 6342.147709] [ 1206]  1000  1206   682254        0     210       6     
3962             0 akonadiserver
[ 6342.147710] [ 1211]  1000  1211   146367     5703     109       3    
19313             0 mysqld
[ 6342.147712] [ 1261]  1000  1261   172241        0     178       4     
1600             0 akonadi_akonote
[ 6342.147714] [ 1262]  1000  1262   328923        0     321       4     
4533             0 akonadi_archive
[ 6342.147715] [ 1263]  1000  1263   193336        0     187       3     
1156             0 akonadi_birthda
[ 6342.147717] [ 1264]  1000  1264   169386        6     177       4     
1586             0 akonadi_contact
[ 6342.147718] [ 1265]  1000  1265   196042      380     192       4     
1077             0 akonadi_followu
[ 6342.147719] [ 1266]  1000  1266   195484      884     195       4     
1081             0 akonadi_ical_re
[ 6342.147721] [ 1269]  1000  1269   148974      114     207       4     
2098             0 kwalletd5
[ 6342.147723] [ 1271]  1000  1271   178961        0     187       4     
1328             0 akonadi_indexin
[ 6342.147724] [ 1272]  1000  1272   172239        0     179       4     
1608             0 akonadi_maildir
[ 6342.147726] [ 1275]  1000  1275   229896      260     192       4     
1551             0 akonadi_maildis
[ 6342.147727] [ 1278]  1000  1278   356078        0     344       5     
5204             0 akonadi_mailfil
[ 6342.147729] [ 1279]  1000  1279   169395        9     179       4     
1077             0 akonadi_migrati
[ 6342.147730] [ 1281]  1000  1281   237225        0     271       4     
3373             0 akonadi_newmail
[ 6342.147731] [ 1283]  1000  1283   296254     1054     280       4     
3818             0 akonadi_notes_a
[ 6342.147733] [ 1284]  1000  1284   292138      501     312       4     
3846             0 akonadi_sendlat
[ 6342.147736] [ 1486]  1000  1486   129345       71     170       3      
977             0 kuiserver5
[ 6342.147738] [ 1575]  1000  1575   157148    10329     220       4     
2473             0 konsole
[ 6342.147739] [ 1579]  1000  1579     4021       56      13       3      
164             0 bash
[ 6342.147741] [ 1582]     0  1582    17563       23      38       3      
248             0 sudo
[ 6342.147742] [ 1583]     0  1583     3425       53      11       3      
118             0 duperemove.sh
[ 6342.147744] [ 4060]     0  4060   168501    92579     203       3       
24             0 duperemove
[ 6342.147746] Out of memory: Kill process 4060 (duperemove) score 21 or 
sacrifice child
[ 6342.147754] Killed process 4060 (duperemove) total-vm:674004kB, 
anon-rss:367672kB, file-rss:2644kB, shmem-rss:0kB



Any idea? The process with the highest total_vm is plasmashell, but it has 
only 900MB of vm.

Niccolò Belli
