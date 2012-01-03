From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: NULL Pointer Dereference While Scrubbing
Date: Tue, 3 Jan 2012 11:35:12 -0600
Message-ID: <CAKcLGm8a+f04xFTWsWHHQsv3b+YzknaKB_Fv5jc0a8EnkUhfog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've recently run into a kernel "NULL pointer dereference" while
scrubbing a partition that had picked up error.

I'm running kernel 3.2.0-rc7.  I'd had a power outage, and noticed an
error in a partition when running btrfsck after reboot:

# ./btrfsck /dev/sdb5
root 5 inode 19772 errors 400
found 3123032064 bytes used err is 1
total csum bytes: 2476808
total tree bytes: 586649600
total fs tree bytes: 554622976
btree space waste bytes: 145500448
file data blocks allocated: 2536382464
 referenced 5143969792
Btrfs Btrfs v0.19-dirty

I ran scrub (even though this partition is formated with single data
and metadata) to attempt to clear the error.  My system froze for
about 30 seconds (no HD activity, no mouse or keyboard movement), then
the scrub proceeded to run, but with the following errors in dmesg:

[ 3683.056829] ------------[ cut here ]------------
[ 3683.056848] WARNING: at lib/kref.c:34 kref_get+0x20/0x30()
[ 3683.056851] Hardware name:
[ 3683.056853] Modules linked in: nvidia(P) nvidia_agp i2c_nforce2
[ 3683.056861] Pid: 4349, comm: btrfs-readahead Tainted: P           O
3.2.0-rc7-git-local+ #1
[ 3683.056865] Call Trace:
[ 3683.056873]  [<c102ca5d>] warn_slowpath_common+0x6d/0xa0
[ 3683.056878]  [<c13acbc0>] ? kref_get+0x20/0x30
[ 3683.056882]  [<c13acbc0>] ? kref_get+0x20/0x30
[ 3683.056886]  [<c102caad>] warn_slowpath_null+0x1d/0x20
[ 3683.056889]  [<c13acbc0>] kref_get+0x20/0x30
[ 3683.056898]  [<c135b89d>] reada_pick_zone+0x11d/0x160
[ 3683.056903]  [<c135c491>] reada_start_machine_worker+0x201/0x2f0
[ 3683.056910]  [<c133a4f9>] worker_loop+0x89/0x370
[ 3683.056914]  [<c133a470>] ? btrfs_queue_worker+0x250/0x250
[ 3683.056919]  [<c10468f4>] kthread+0x74/0x80
[ 3683.056922]  [<c1046880>] ? kthread_worker_fn+0x110/0x110
[ 3683.056929]  [<c1766036>] kernel_thread_helper+0x6/0xd
[ 3683.056932] ---[ end trace f9c0e14dc17013ed ]---
[ 3683.056941] BUG: unable to handle kernel NULL pointer dereference at 000000e4
[ 3683.056947] IP: [<c13aeeb4>] radix_tree_delete+0x14/0x250
[ 3683.056953] *pde = 00000000
[ 3683.056956] Oops: 0000 [#1]
[ 3683.056960] Modules linked in: nvidia(P) nvidia_agp i2c_nforce2
[ 3683.056965]
[ 3683.056968] Pid: 4349, comm: btrfs-readahead Tainted: P        W  O
3.2.0-rc7-git-local+ #1    /MS-6570
[ 3683.056973] EIP: 0060:[<c13aeeb4>] EFLAGS: 00010282 CPU: 0
[ 3683.056977] EIP is at radix_tree_delete+0x14/0x250
[ 3683.056980] EAX: 000000e4 EBX: f4cdf300 ECX: 0002c000 EDX: 000000e4
[ 3683.056983] ESI: c135b650 EDI: f4e0c400 EBP: f0851ec4 ESP: f0851e70
[ 3683.056986]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[ 3683.056990] Process btrfs-readahead (pid: 4349, ti=f0850000
task=f4f0a9a0 task.ti=f0850000)
[ 3683.056993] Stack:
[ 3683.056994]  00000022 0002c000 000000e4 c175dfe7 c18aaeb0 f0851e94
f0851e9c c102c9ea
[ 3683.057001]  c18aaeb0 c17013ed c18f8971 f0851ec4 c102ca6d c18a740e
c1aeb034 00000022
[ 3683.057007]  c13acbc0 c13acbc0 f4cdf300 c135b650 f4e0c400 f0851ed0
c135b66e f4cdf334
[ 3683.057008] Call Trace:
[ 3683.057008]  [<c175dfe7>] ? printk+0x18/0x1a
[ 3683.057008]  [<c102c9ea>] ? print_oops_end_marker+0x2a/0x30
[ 3683.057008]  [<c17013ed>] ? xdr_process_buf+0x1d/0x1e0
[ 3683.057008]  [<c102ca6d>] ? warn_slowpath_common+0x7d/0xa0
[ 3683.057008]  [<c13acbc0>] ? kref_get+0x20/0x30
[ 3683.057008]  [<c13acbc0>] ? kref_get+0x20/0x30
[ 3683.057008]  [<c135b650>] ? reada_peer_zones_set_lock+0x60/0x60
[ 3683.057008]  [<c135b66e>] reada_zone_release+0x1e/0x30
[ 3683.057008]  [<c13acb6c>] kref_put+0x2c/0x60
[ 3683.057008]  [<c135b7b3>] reada_pick_zone+0x33/0x160
[ 3683.057008]  [<c135c441>] reada_start_machine_worker+0x1b1/0x2f0
[ 3683.057008]  [<c133a4f9>] worker_loop+0x89/0x370
[ 3683.057008]  [<c133a470>] ? btrfs_queue_worker+0x250/0x250
[ 3683.057008]  [<c10468f4>] kthread+0x74/0x80
[ 3683.057008]  [<c1046880>] ? kthread_worker_fn+0x110/0x110
[ 3683.057008]  [<c1766036>] kernel_thread_helper+0x6/0xd
[ 3683.057008] Code: 45 e0 8b 5d d8 83 c0 01 89 03 8b 45 e4 8d 65 f4
5b 5e 5f 5d c3 66 90 55 89 e5 57 56 53 83 ec 48 89 55 b0 89 c2 8b 4d
b0 89 45 b4 <8b> 00 3b 0c 85 48 c1 9e c1 0f 87 9d 01 00 00 8b 5a 08 85
c0 89
[ 3683.057008] EIP: [<c13aeeb4>] radix_tree_delete+0x14/0x250 SS:ESP
0068:f0851e70
[ 3683.057008] CR2: 00000000000000e4
[ 3683.057149] ---[ end trace f9c0e14dc17013ee ]---
[ 3684.019436] checksum error at logical 24911872 on dev /dev/sdb5,
sector 48656: metadata leaf (level 0) in tree 5
[ 3684.019445] checksum error at logical 24911872 on dev /dev/sdb5,
sector 48656: metadata leaf (level 0) in tree 5
[ 3684.019451] btrfs: unable to fixup (regular) error at logical 24911872
[ 3684.675210] checksum error at logical 36139008 on dev /dev/sdb5,
sector 70584: metadata leaf (level 0) in tree 5
[ 3684.675219] checksum error at logical 36139008 on dev /dev/sdb5,
sector 70584: metadata leaf (level 0) in tree 5
[ 3684.675226] btrfs: unable to fixup (regular) error at logical 36139008
[ 3684.990958] checksum error at logical 43667456 on dev /dev/sdb5,
sector 85288: metadata leaf (level 0) in tree 5
[ 3684.990967] checksum error at logical 43667456 on dev /dev/sdb5,
sector 85288: metadata leaf (level 0) in tree 5
[ 3684.990973] btrfs: unable to fixup (regular) error at logical 43667456
[ 3685.206384] checksum error at logical 46813184 on dev /dev/sdb5,
sector 91432: metadata leaf (level 0) in tree 5
[ 3685.206393] checksum error at logical 46813184 on dev /dev/sdb5,
sector 91432: metadata leaf (level 0) in tree 5
[ 3685.206399] btrfs: unable to fixup (regular) error at logical 46813184
[ 3685.353048] checksum error at logical 49352704 on dev /dev/sdb5,
sector 96392: metadata leaf (level 0) in tree 5
[ 3685.353056] checksum error at logical 49352704 on dev /dev/sdb5,
sector 96392: metadata leaf (level 0) in tree 5
[ 3685.353062] btrfs: unable to fixup (regular) error at logical 49352704
[ 3685.892964] checksum error at logical 57888768 on dev /dev/sdb5,
sector 113064: metadata leaf (level 0) in tree 5
[ 3685.892973] checksum error at logical 57888768 on dev /dev/sdb5,
sector 113064: metadata leaf (level 0) in tree 5
[ 3685.892980] btrfs: unable to fixup (regular) error at logical 57888768
[ 3686.337182] checksum error at logical 65646592 on dev /dev/sdb5,
sector 128216: metadata leaf (level 0) in tree 5
[ 3686.337191] checksum error at logical 65646592 on dev /dev/sdb5,
sector 128216: metadata leaf (level 0) in tree 5
[ 3686.337197] btrfs: unable to fixup (regular) error at logical 65646592
[ 3686.700049] checksum error at logical 72007680 on dev /dev/sdb5,
sector 140640: metadata leaf (level 0) in tree 5
[ 3686.700058] checksum error at logical 72007680 on dev /dev/sdb5,
sector 140640: metadata leaf (level 0) in tree 5
[ 3686.700064] btrfs: unable to fixup (regular) error at logical 72007680
[ 3688.378882] checksum error at logical 103575552 on dev /dev/sdb5,
sector 202296: metadata leaf (level 0) in tree 5
[ 3688.378891] checksum error at logical 103575552 on dev /dev/sdb5,
sector 202296: metadata leaf (level 0) in tree 5
[ 3688.378898] btrfs: unable to fixup (regular) error at logical 103575552
[ 3690.011251] checksum error at logical 165928960 on dev /dev/sdb5,
sector 324080: metadata leaf (level 0) in tree 5
[ 3690.011260] checksum error at logical 165928960 on dev /dev/sdb5,
sector 324080: metadata leaf (level 0) in tree 5
[ 3690.011267] btrfs: unable to fixup (regular) error at logical 165928960
[ 3690.011529] checksum error at logical 165978112 on dev /dev/sdb5,
sector 324176: metadata leaf (level 0) in tree 5
[ 3690.011534] checksum error at logical 165978112 on dev /dev/sdb5,
sector 324176: metadata leaf (level 0) in tree 5
[ 3690.011540] btrfs: unable to fixup (regular) error at logical 165978112
[ 3690.011684] checksum error at logical 165998592 on dev /dev/sdb5,
sector 324216: metadata leaf (level 0) in tree 5
[ 3690.011689] checksum error at logical 165998592 on dev /dev/sdb5,
sector 324216: metadata leaf (level 0) in tree 5
[ 3690.011694] btrfs: unable to fixup (regular) error at logical 165998592
[ 3690.126322] checksum error at logical 169029632 on dev /dev/sdb5,
sector 330136: metadata leaf (level 0) in tree 5
[ 3690.126331] checksum error at logical 169029632 on dev /dev/sdb5,
sector 330136: metadata leaf (level 0) in tree 5
[ 3690.126338] btrfs: unable to fixup (regular) error at logical 169029632
[ 3690.126432] checksum error at logical 169033728 on dev /dev/sdb5,
sector 330144: metadata leaf (level 0) in tree 5
[ 3690.126438] checksum error at logical 169033728 on dev /dev/sdb5,
sector 330144: metadata leaf (level 0) in tree 5
[ 3690.126442] btrfs: unable to fixup (regular) error at logical 169033728
[ 3690.126502] checksum error at logical 169009152 on dev /dev/sdb5,
sector 330096: metadata leaf (level 0) in tree 5
[ 3690.126507] checksum error at logical 169009152 on dev /dev/sdb5,
sector 330096: metadata leaf (level 0) in tree 5
[ 3690.126512] btrfs: unable to fixup (regular) error at logical 169009152
[ 3690.126665] checksum error at logical 169058304 on dev /dev/sdb5,
sector 330192: metadata leaf (level 0) in tree 5
[ 3690.126670] checksum error at logical 169058304 on dev /dev/sdb5,
sector 330192: metadata leaf (level 0) in tree 5
[ 3690.126676] btrfs: unable to fixup (regular) error at logical 169058304
[ 3690.128027] checksum error at logical 169086976 on dev /dev/sdb5,
sector 330248: metadata leaf (level 0) in tree 5
[ 3690.128033] checksum error at logical 169086976 on dev /dev/sdb5,
sector 330248: metadata leaf (level 0) in tree 5
[ 3690.128038] btrfs: unable to fixup (regular) error at logical 169086976
[ 3690.128082] checksum error at logical 169095168 on dev /dev/sdb5,
sector 330264: metadata leaf (level 0) in tree 5
[ 3690.128087] checksum error at logical 169095168 on dev /dev/sdb5,
sector 330264: metadata leaf (level 0) in tree 5
[ 3690.128091] btrfs: unable to fixup (regular) error at logical 169095168
[ 3690.133167] checksum error at logical 169447424 on dev /dev/sdb5,
sector 330952: metadata leaf (level 0) in tree 5
[ 3690.133173] checksum error at logical 169447424 on dev /dev/sdb5,
sector 330952: metadata leaf (level 0) in tree 5
[ 3690.133179] btrfs: unable to fixup (regular) error at logical 169447424
[ 3746.413798] scrub_recheck_error: 30 callbacks suppressed
[ 3746.413816] checksum error at logical 2655461376 on dev /dev/sdb5,
sector 5186448: metadata leaf (level 0) in tree 5
[ 3746.413821] checksum error at logical 2655461376 on dev /dev/sdb5,
sector 5186448: metadata leaf (level 0) in tree 5
[ 3746.413827] scrub_fixup: 30 callbacks suppressed
[ 3746.413830] btrfs: unable to fixup (regular) error at logical 2655461376
[ 3746.414483] checksum error at logical 2655469568 on dev /dev/sdb5,
sector 5186464: metadata leaf (level 0) in tree 5
[ 3746.414488] checksum error at logical 2655469568 on dev /dev/sdb5,
sector 5186464: metadata leaf (level 0) in tree 5
[ 3746.414494] btrfs: unable to fixup (regular) error at logical 2655469568
[ 3751.381940] checksum error at logical 2752249856 on dev /dev/sdb5,
sector 5375488: metadata leaf (level 0) in tree 5
[ 3751.381949] checksum error at logical 2752249856 on dev /dev/sdb5,
sector 5375488: metadata leaf (level 0) in tree 5
[ 3751.381956] btrfs: unable to fixup (regular) error at logical 2752249856
[ 3751.412726] checksum error at logical 2752675840 on dev /dev/sdb5,
sector 5376320: metadata leaf (level 0) in tree 2
[ 3751.412732] checksum error at logical 2752675840 on dev /dev/sdb5,
sector 5376320: metadata leaf (level 0) in tree 2
[ 3751.412738] btrfs: unable to fixup (regular) error at logical 2752675840
[ 3751.443102] checksum error at logical 2753064960 on dev /dev/sdb5,
sector 5377080: metadata leaf (level 0) in tree 5
[ 3751.443108] checksum error at logical 2753064960 on dev /dev/sdb5,
sector 5377080: metadata leaf (level 0) in tree 5
[ 3751.443114] btrfs: unable to fixup (regular) error at logical 2753064960
[ 3751.456643] checksum error at logical 2753290240 on dev /dev/sdb5,
sector 5377520: metadata leaf (level 0) in tree 7
[ 3751.456649] checksum error at logical 2753290240 on dev /dev/sdb5,
sector 5377520: metadata leaf (level 0) in tree 7
[ 3751.456655] btrfs: unable to fixup (regular) error at logical 2753290240
[ 3751.554606] checksum error at logical 2754314240 on dev /dev/sdb5,
sector 5379520: metadata leaf (level 0) in tree 5
[ 3751.554614] checksum error at logical 2754314240 on dev /dev/sdb5,
sector 5379520: metadata leaf (level 0) in tree 5
[ 3751.554621] btrfs: unable to fixup (regular) error at logical 2754314240
[ 3751.557164] checksum error at logical 2754494464 on dev /dev/sdb5,
sector 5379872: metadata leaf (level 0) in tree 5
[ 3751.557170] checksum error at logical 2754494464 on dev /dev/sdb5,
sector 5379872: metadata leaf (level 0) in tree 5
[ 3751.557175] btrfs: unable to fixup (regular) error at logical 2754494464
[ 3751.557201] checksum error at logical 2754498560 on dev /dev/sdb5,
sector 5379880: metadata leaf (level 0) in tree 5
[ 3751.557206] checksum error at logical 2754498560 on dev /dev/sdb5,
sector 5379880: metadata leaf (level 0) in tree 5
[ 3751.557211] btrfs: unable to fixup (regular) error at logical 2754498560
[ 3751.557395] checksum error at logical 2754506752 on dev /dev/sdb5,
sector 5379896: metadata leaf (level 0) in tree 5
[ 3751.557401] checksum error at logical 2754506752 on dev /dev/sdb5,
sector 5379896: metadata leaf (level 0) in tree 5
[ 3751.557406] btrfs: unable to fixup (regular) error at logical 2754506752
[ 3751.557759] checksum error at logical 2754609152 on dev /dev/sdb5,
sector 5380096: metadata leaf (level 0) in tree 5
[ 3751.557764] checksum error at logical 2754609152 on dev /dev/sdb5,
sector 5380096: metadata leaf (level 0) in tree 5
[ 3751.557770] btrfs: unable to fixup (regular) error at logical 2754609152
[ 3751.618837] checksum error at logical 2755813376 on dev /dev/sdb5,
sector 5382448: metadata leaf (level 0) in tree 5
[ 3751.618845] checksum error at logical 2755813376 on dev /dev/sdb5,
sector 5382448: metadata leaf (level 0) in tree 5
[ 3751.618851] btrfs: unable to fixup (regular) error at logical 2755813376
[ 3751.647986] checksum error at logical 2756648960 on dev /dev/sdb5,
sector 5384080: metadata leaf (level 0) in tree 5
[ 3751.647993] checksum error at logical 2756648960 on dev /dev/sdb5,
sector 5384080: metadata leaf (level 0) in tree 5
[ 3751.647999] btrfs: unable to fixup (regular) error at logical 2756648960
[ 3751.835659] checksum error at logical 2761150464 on dev /dev/sdb5,
sector 5392872: metadata leaf (level 0) in tree 5
[ 3751.835668] checksum error at logical 2761150464 on dev /dev/sdb5,
sector 5392872: metadata leaf (level 0) in tree 5
[ 3751.835675] btrfs: unable to fixup (regular) error at logical 2761150464
[ 3765.083326] scrub_recheck_error: 33 callbacks suppressed
[ 3765.083344] checksum error at logical 3010654208 on dev /dev/sdb5,
sector 5880184: metadata leaf (level 0) in tree 5
[ 3765.083350] checksum error at logical 3010654208 on dev /dev/sdb5,
sector 5880184: metadata leaf (level 0) in tree 5
[ 3765.083356] scrub_fixup: 33 callbacks suppressed
[ 3765.083359] btrfs: unable to fixup (regular) error at logical 3010654208
[ 3768.289359] checksum error at logical 3055210496 on dev /dev/sdb5,
sector 5967208: metadata leaf (level 0) in tree 5
[ 3768.289368] checksum error at logical 3055210496 on dev /dev/sdb5,
sector 5967208: metadata leaf (level 0) in tree 5
[ 3768.289376] btrfs: unable to fixup (regular) error at logical 3055210496
[ 3768.301971] checksum error at logical 3055714304 on dev /dev/sdb5,
sector 5968192: metadata leaf (level 0) in tree 5
[ 3768.301978] checksum error at logical 3055714304 on dev /dev/sdb5,
sector 5968192: metadata leaf (level 0) in tree 5
[ 3768.301984] btrfs: unable to fixup (regular) error at logical 3055714304
[ 3769.060539] checksum error at logical 3069796352 on dev /dev/sdb5,
sector 5995696: metadata leaf (level 0) in tree 5
[ 3769.060548] checksum error at logical 3069796352 on dev /dev/sdb5,
sector 5995696: metadata leaf (level 0) in tree 5
[ 3769.060555] btrfs: unable to fixup (regular) error at logical 3069796352
[ 3770.123327] checksum error at logical 3082948608 on dev /dev/sdb5,
sector 6021384: metadata leaf (level 0) in tree 2
[ 3770.123336] checksum error at logical 3082948608 on dev /dev/sdb5,
sector 6021384: metadata leaf (level 0) in tree 2
[ 3770.123343] btrfs: unable to fixup (regular) error at logical 3082948608
[ 3771.175326] checksum error at logical 3095752704 on dev /dev/sdb5,
sector 6046392: metadata leaf (level 0) in tree 5
[ 3771.175335] checksum error at logical 3095752704 on dev /dev/sdb5,
sector 6046392: metadata leaf (level 0) in tree 5
[ 3771.175342] btrfs: unable to fixup (regular) error at logical 3095752704
[ 3771.188587] checksum error at logical 3096076288 on dev /dev/sdb5,
sector 6047024: metadata leaf (level 0) in tree 5
[ 3771.188595] checksum error at logical 3096076288 on dev /dev/sdb5,
sector 6047024: metadata leaf (level 0) in tree 5
[ 3771.188602] btrfs: unable to fixup (regular) error at logical 3096076288
[ 3771.189479] checksum error at logical 3096113152 on dev /dev/sdb5,
sector 6047096: metadata leaf (level 0) in tree 5
[ 3771.189485] checksum error at logical 3096113152 on dev /dev/sdb5,
sector 6047096: metadata leaf (level 0) in tree 5
[ 3771.189490] btrfs: unable to fixup (regular) error at logical 3096113152
[ 3771.189739] checksum error at logical 3096166400 on dev /dev/sdb5,
sector 6047200: metadata leaf (level 0) in tree 5
[ 3771.189745] checksum error at logical 3096166400 on dev /dev/sdb5,
sector 6047200: metadata leaf (level 0) in tree 5
[ 3771.189750] btrfs: unable to fixup (regular) error at logical 3096166400
[ 3771.190468] checksum error at logical 3096186880 on dev /dev/sdb5,
sector 6047240: metadata leaf (level 0) in tree 5
[ 3771.190473] checksum error at logical 3096186880 on dev /dev/sdb5,
sector 6047240: metadata leaf (level 0) in tree 5
[ 3771.190479] btrfs: unable to fixup (regular) error at logical 3096186880
[ 3793.715498] scrub_recheck_error: 17 callbacks suppressed
[ 3793.715515] checksum error at logical 4169457664 on dev /dev/sdb5,
sector 8143472: metadata leaf (level 0) in tree 5
[ 3793.715520] checksum error at logical 4169457664 on dev /dev/sdb5,
sector 8143472: metadata leaf (level 0) in tree 5
[ 3793.715526] scrub_fixup: 17 callbacks suppressed
[ 3793.715529] btrfs: unable to fixup (regular) error at logical 4169457664
[ 3793.715554] checksum error at logical 4169461760 on dev /dev/sdb5,
sector 8143480: metadata leaf (level 0) in tree 5
[ 3793.715559] checksum error at logical 4169461760 on dev /dev/sdb5,
sector 8143480: metadata leaf (level 0) in tree 5
[ 3793.715563] btrfs: unable to fixup (regular) error at logical 4169461760
[ 3793.805872] checksum error at logical 4171509760 on dev /dev/sdb5,
sector 8147480: metadata leaf (level 0) in tree 5
[ 3793.805880] checksum error at logical 4171509760 on dev /dev/sdb5,
sector 8147480: metadata leaf (level 0) in tree 5
[ 3793.805886] btrfs: unable to fixup (regular) error at logical 4171509760
[ 3793.805912] checksum error at logical 4171513856 on dev /dev/sdb5,
sector 8147488: metadata leaf (level 0) in tree 5
[ 3793.805917] checksum error at logical 4171513856 on dev /dev/sdb5,
sector 8147488: metadata leaf (level 0) in tree 5
[ 3793.806488] btrfs: unable to fixup (regular) error at logical 4171513856
[ 3793.809168] checksum error at logical 4171751424 on dev /dev/sdb5,
sector 8147952: metadata leaf (level 0) in tree 5
[ 3793.809173] checksum error at logical 4171751424 on dev /dev/sdb5,
sector 8147952: metadata leaf (level 0) in tree 5
[ 3793.809179] btrfs: unable to fixup (regular) error at logical 4171751424
[ 3793.810449] checksum error at logical 4171821056 on dev /dev/sdb5,
sector 8148088: metadata leaf (level 0) in tree 5
[ 3793.810455] checksum error at logical 4171821056 on dev /dev/sdb5,
sector 8148088: metadata leaf (level 0) in tree 5
[ 3793.810460] btrfs: unable to fixup (regular) error at logical 4171821056
[ 3793.845851] checksum error at logical 4172443648 on dev /dev/sdb5,
sector 8149304: metadata leaf (level 0) in tree 5
[ 3793.845858] checksum error at logical 4172443648 on dev /dev/sdb5,
sector 8149304: metadata leaf (level 0) in tree 5
[ 3793.845864] btrfs: unable to fixup (regular) error at logical 4172443648
[ 3793.846477] checksum error at logical 4172468224 on dev /dev/sdb5,
sector 8149352: metadata leaf (level 0) in tree 5
[ 3793.846482] checksum error at logical 4172468224 on dev /dev/sdb5,
sector 8149352: metadata leaf (level 0) in tree 5
[ 3793.846488] btrfs: unable to fixup (regular) error at logical 4172468224
[ 3793.846529] checksum error at logical 4172476416 on dev /dev/sdb5,
sector 8149368: metadata leaf (level 0) in tree 5
[ 3793.846534] checksum error at logical 4172476416 on dev /dev/sdb5,
sector 8149368: metadata leaf (level 0) in tree 5
[ 3793.846539] btrfs: unable to fixup (regular) error at logical 4172476416
[ 3793.858117] checksum error at logical 4172738560 on dev /dev/sdb5,
sector 8149880: metadata leaf (level 0) in tree 5
[ 3793.858123] checksum error at logical 4172738560 on dev /dev/sdb5,
sector 8149880: metadata leaf (level 0) in tree 5
[ 3793.858130] btrfs: unable to fixup (regular) error at logical 4172738560
[ 3798.869329] scrub_recheck_error: 39 callbacks suppressed
[ 3798.869348] checksum error at logical 4250955776 on dev /dev/sdb5,
sector 8302648: metadata leaf (level 0) in tree 5
[ 3798.869353] checksum error at logical 4250955776 on dev /dev/sdb5,
sector 8302648: metadata leaf (level 0) in tree 5
[ 3798.869359] scrub_fixup: 39 callbacks suppressed
[ 3798.869362] btrfs: unable to fixup (regular) error at logical 4250955776
[ 3809.626959] checksum error at logical 4611792896 on dev /dev/sdb5,
sector 9007408: metadata leaf (level 0) in tree 5
[ 3809.626968] checksum error at logical 4611792896 on dev /dev/sdb5,
sector 9007408: metadata leaf (level 0) in tree 5
[ 3809.626975] btrfs: unable to fixup (regular) error at logical 4611792896
[ 3812.056051] checksum error at logical 4688564224 on dev /dev/sdb5,
sector 9157352: metadata leaf (level 0) in tree 5
[ 3812.056060] checksum error at logical 4688564224 on dev /dev/sdb5,
sector 9157352: metadata leaf (level 0) in tree 5
[ 3812.056067] btrfs: unable to fixup (regular) error at logical 4688564224
[ 3812.082464] checksum error at logical 4689203200 on dev /dev/sdb5,
sector 9158600: metadata leaf (level 0) in tree 5
[ 3812.082470] checksum error at logical 4689203200 on dev /dev/sdb5,
sector 9158600: metadata leaf (level 0) in tree 5
[ 3812.082476] btrfs: unable to fixup (regular) error at logical 4689203200
[ 3861.356975] checksum error at logical 24911872 on dev /dev/sdb5,
sector 48656: metadata leaf (level 0) in tree 5
[ 3861.356984] checksum error at logical 24911872 on dev /dev/sdb5,
sector 48656: metadata leaf (level 0) in tree 5
[ 3861.356994] btrfs: unable to fixup (regular) error at logical 24911872
[ 3861.530708] checksum error at logical 36139008 on dev /dev/sdb5,
sector 70584: metadata leaf (level 0) in tree 5
[ 3861.530716] checksum error at logical 36139008 on dev /dev/sdb5,
sector 70584: metadata leaf (level 0) in tree 5
[ 3861.530726] btrfs: unable to fixup (regular) error at logical 36139008
[ 3861.646219] checksum error at logical 43667456 on dev /dev/sdb5,
sector 85288: metadata leaf (level 0) in tree 5
[ 3861.646228] checksum error at logical 43667456 on dev /dev/sdb5,
sector 85288: metadata leaf (level 0) in tree 5
[ 3861.646238] btrfs: unable to fixup (regular) error at logical 43667456
[ 3861.695751] checksum error at logical 46813184 on dev /dev/sdb5,
sector 91432: metadata leaf (level 0) in tree 5
[ 3861.695760] checksum error at logical 46813184 on dev /dev/sdb5,
sector 91432: metadata leaf (level 0) in tree 5
[ 3861.695770] btrfs: unable to fixup (regular) error at logical 46813184
[ 3861.733952] checksum error at logical 49352704 on dev /dev/sdb5,
sector 96392: metadata leaf (level 0) in tree 5
[ 3861.733961] checksum error at logical 49352704 on dev /dev/sdb5,
sector 96392: metadata leaf (level 0) in tree 5
[ 3861.733970] btrfs: unable to fixup (regular) error at logical 49352704
[ 3861.866820] checksum error at logical 57888768 on dev /dev/sdb5,
sector 113064: metadata leaf (level 0) in tree 5
[ 3861.866829] checksum error at logical 57888768 on dev /dev/sdb5,
sector 113064: metadata leaf (level 0) in tree 5
[ 3861.866838] btrfs: unable to fixup (regular) error at logical 57888768
[ 3862.003382] checksum error at logical 65646592 on dev /dev/sdb5,
sector 128216: metadata leaf (level 0) in tree 5
[ 3862.003391] checksum error at logical 65646592 on dev /dev/sdb5,
sector 128216: metadata leaf (level 0) in tree 5
[ 3862.003401] btrfs: unable to fixup (regular) error at logical 65646592
[ 3862.108576] checksum error at logical 72007680 on dev /dev/sdb5,
sector 140640: metadata leaf (level 0) in tree 5
[ 3862.108585] checksum error at logical 72007680 on dev /dev/sdb5,
sector 140640: metadata leaf (level 0) in tree 5
[ 3862.108595] btrfs: unable to fixup (regular) error at logical 72007680
[ 3862.614910] checksum error at logical 103575552 on dev /dev/sdb5,
sector 202296: metadata leaf (level 0) in tree 5
[ 3862.614919] checksum error at logical 103575552 on dev /dev/sdb5,
sector 202296: metadata leaf (level 0) in tree 5
[ 3862.614928] btrfs: unable to fixup (regular) error at logical 103575552
[ 3863.564788] checksum error at logical 165928960 on dev /dev/sdb5,
sector 324080: metadata leaf (level 0) in tree 5
[ 3863.564797] checksum error at logical 165928960 on dev /dev/sdb5,
sector 324080: metadata leaf (level 0) in tree 5
[ 3863.564807] btrfs: unable to fixup (regular) error at logical 165928960
[ 3894.931650] scrub_recheck_error: 39 callbacks suppressed
[ 3894.931668] checksum error at logical 2655461376 on dev /dev/sdb5,
sector 5186448: metadata leaf (level 0) in tree 5
[ 3894.931673] checksum error at logical 2655461376 on dev /dev/sdb5,
sector 5186448: metadata leaf (level 0) in tree 5
[ 3894.931683] scrub_fixup: 39 callbacks suppressed
[ 3894.931686] btrfs: unable to fixup (regular) error at logical 2655461376
[ 3894.931967] checksum error at logical 2655469568 on dev /dev/sdb5,
sector 5186464: metadata leaf (level 0) in tree 5
[ 3894.931972] checksum error at logical 2655469568 on dev /dev/sdb5,
sector 5186464: metadata leaf (level 0) in tree 5
[ 3894.931978] btrfs: unable to fixup (regular) error at logical 2655469568
[ 3896.415052] checksum error at logical 2752249856 on dev /dev/sdb5,
sector 5375488: metadata leaf (level 0) in tree 5
[ 3896.415061] checksum error at logical 2752249856 on dev /dev/sdb5,
sector 5375488: metadata leaf (level 0) in tree 5
[ 3896.415071] btrfs: unable to fixup (regular) error at logical 2752249856
[ 3896.421695] checksum error at logical 2752675840 on dev /dev/sdb5,
sector 5376320: metadata leaf (level 0) in tree 2
[ 3896.421701] checksum error at logical 2752675840 on dev /dev/sdb5,
sector 5376320: metadata leaf (level 0) in tree 2
[ 3896.421707] btrfs: unable to fixup (regular) error at logical 2752675840
[ 3896.427134] checksum error at logical 2753064960 on dev /dev/sdb5,
sector 5377080: metadata leaf (level 0) in tree 5
[ 3896.427140] checksum error at logical 2753064960 on dev /dev/sdb5,
sector 5377080: metadata leaf (level 0) in tree 5
[ 3896.427146] btrfs: unable to fixup (regular) error at logical 2753064960
[ 3896.431230] checksum error at logical 2753290240 on dev /dev/sdb5,
sector 5377520: metadata leaf (level 0) in tree 7
[ 3896.431236] checksum error at logical 2753290240 on dev /dev/sdb5,
sector 5377520: metadata leaf (level 0) in tree 7
[ 3896.431243] btrfs: unable to fixup (regular) error at logical 2753290240
[ 3896.447177] checksum error at logical 2754314240 on dev /dev/sdb5,
sector 5379520: metadata leaf (level 0) in tree 5
[ 3896.447185] checksum error at logical 2754314240 on dev /dev/sdb5,
sector 5379520: metadata leaf (level 0) in tree 5
[ 3896.447194] btrfs: unable to fixup (regular) error at logical 2754314240
[ 3896.449730] checksum error at logical 2754494464 on dev /dev/sdb5,
sector 5379872: metadata leaf (level 0) in tree 5
[ 3896.449736] checksum error at logical 2754494464 on dev /dev/sdb5,
sector 5379872: metadata leaf (level 0) in tree 5
[ 3896.449742] btrfs: unable to fixup (regular) error at logical 2754494464
[ 3896.449768] checksum error at logical 2754498560 on dev /dev/sdb5,
sector 5379880: metadata leaf (level 0) in tree 5
[ 3896.449773] checksum error at logical 2754498560 on dev /dev/sdb5,
sector 5379880: metadata leaf (level 0) in tree 5
[ 3896.449777] btrfs: unable to fixup (regular) error at logical 2754498560
[ 3896.449994] checksum error at logical 2754506752 on dev /dev/sdb5,
sector 5379896: metadata leaf (level 0) in tree 5
[ 3896.450000] checksum error at logical 2754506752 on dev /dev/sdb5,
sector 5379896: metadata leaf (level 0) in tree 5
[ 3896.450401] btrfs: unable to fixup (regular) error at logical 2754506752
[ 3900.116791] scrub_recheck_error: 37 callbacks suppressed
[ 3900.116809] checksum error at logical 3010654208 on dev /dev/sdb5,
sector 5880184: metadata leaf (level 0) in tree 5
[ 3900.116814] checksum error at logical 3010654208 on dev /dev/sdb5,
sector 5880184: metadata leaf (level 0) in tree 5
[ 3900.116893] scrub_fixup: 37 callbacks suppressed
[ 3900.116896] btrfs: unable to fixup (regular) error at logical 3010654208
[ 3900.806094] checksum error at logical 3055210496 on dev /dev/sdb5,
sector 5967208: metadata leaf (level 0) in tree 5
[ 3900.806103] checksum error at logical 3055210496 on dev /dev/sdb5,
sector 5967208: metadata leaf (level 0) in tree 5
[ 3900.806113] btrfs: unable to fixup (regular) error at logical 3055210496
[ 3900.813869] checksum error at logical 3055714304 on dev /dev/sdb5,
sector 5968192: metadata leaf (level 0) in tree 5
[ 3900.813875] checksum error at logical 3055714304 on dev /dev/sdb5,
sector 5968192: metadata leaf (level 0) in tree 5
[ 3900.813882] btrfs: unable to fixup (regular) error at logical 3055714304
[ 3901.031992] checksum error at logical 3069796352 on dev /dev/sdb5,
sector 5995696: metadata leaf (level 0) in tree 5
[ 3901.032001] checksum error at logical 3069796352 on dev /dev/sdb5,
sector 5995696: metadata leaf (level 0) in tree 5
[ 3901.032520] btrfs: unable to fixup (regular) error at logical 3069796352
[ 3901.238938] checksum error at logical 3082948608 on dev /dev/sdb5,
sector 6021384: metadata leaf (level 0) in tree 2
[ 3901.238947] checksum error at logical 3082948608 on dev /dev/sdb5,
sector 6021384: metadata leaf (level 0) in tree 2
[ 3901.238957] btrfs: unable to fixup (regular) error at logical 3082948608
[ 3901.434288] checksum error at logical 3095752704 on dev /dev/sdb5,
sector 6046392: metadata leaf (level 0) in tree 5
[ 3901.434297] checksum error at logical 3095752704 on dev /dev/sdb5,
sector 6046392: metadata leaf (level 0) in tree 5
[ 3901.434307] btrfs: unable to fixup (regular) error at logical 3095752704
[ 3901.438865] checksum error at logical 3096076288 on dev /dev/sdb5,
sector 6047024: metadata leaf (level 0) in tree 5
[ 3901.438870] checksum error at logical 3096076288 on dev /dev/sdb5,
sector 6047024: metadata leaf (level 0) in tree 5
[ 3901.438876] btrfs: unable to fixup (regular) error at logical 3096076288
[ 3901.439297] checksum error at logical 3096113152 on dev /dev/sdb5,
sector 6047096: metadata leaf (level 0) in tree 5
[ 3901.439303] checksum error at logical 3096113152 on dev /dev/sdb5,
sector 6047096: metadata leaf (level 0) in tree 5
[ 3901.439308] btrfs: unable to fixup (regular) error at logical 3096113152
[ 3901.440200] checksum error at logical 3096166400 on dev /dev/sdb5,
sector 6047200: metadata leaf (level 0) in tree 5
[ 3901.440275] checksum error at logical 3096166400 on dev /dev/sdb5,
sector 6047200: metadata leaf (level 0) in tree 5
[ 3901.440282] btrfs: unable to fixup (regular) error at logical 3096166400
[ 3901.440326] checksum error at logical 3096186880 on dev /dev/sdb5,
sector 6047240: metadata leaf (level 0) in tree 5
[ 3901.440331] checksum error at logical 3096186880 on dev /dev/sdb5,
sector 6047240: metadata leaf (level 0) in tree 5
[ 3901.440336] btrfs: unable to fixup (regular) error at logical 3096186880
[ 3913.771767] scrub_recheck_error: 17 callbacks suppressed
[ 3913.771784] checksum error at logical 4169457664 on dev /dev/sdb5,
sector 8143472: metadata leaf (level 0) in tree 5
[ 3913.771789] checksum error at logical 4169457664 on dev /dev/sdb5,
sector 8143472: metadata leaf (level 0) in tree 5
[ 3913.771796] scrub_fixup: 17 callbacks suppressed
[ 3913.771798] btrfs: unable to fixup (regular) error at logical 4169457664
[ 3913.771823] checksum error at logical 4169461760 on dev /dev/sdb5,
sector 8143480: metadata leaf (level 0) in tree 5
[ 3913.771828] checksum error at logical 4169461760 on dev /dev/sdb5,
sector 8143480: metadata leaf (level 0) in tree 5
[ 3913.771833] btrfs: unable to fixup (regular) error at logical 4169461760
[ 3913.803934] checksum error at logical 4171509760 on dev /dev/sdb5,
sector 8147480: metadata leaf (level 0) in tree 5
[ 3913.803941] checksum error at logical 4171509760 on dev /dev/sdb5,
sector 8147480: metadata leaf (level 0) in tree 5
[ 3913.803948] btrfs: unable to fixup (regular) error at logical 4171509760
[ 3913.803974] checksum error at logical 4171513856 on dev /dev/sdb5,
sector 8147488: metadata leaf (level 0) in tree 5
[ 3913.803979] checksum error at logical 4171513856 on dev /dev/sdb5,
sector 8147488: metadata leaf (level 0) in tree 5
[ 3913.803984] btrfs: unable to fixup (regular) error at logical 4171513856
[ 3913.807230] checksum error at logical 4171751424 on dev /dev/sdb5,
sector 8147952: metadata leaf (level 0) in tree 5
[ 3913.807236] checksum error at logical 4171751424 on dev /dev/sdb5,
sector 8147952: metadata leaf (level 0) in tree 5
[ 3913.807242] btrfs: unable to fixup (regular) error at logical 4171751424
[ 3913.808314] checksum error at logical 4171821056 on dev /dev/sdb5,
sector 8148088: metadata leaf (level 0) in tree 5
[ 3913.808390] checksum error at logical 4171821056 on dev /dev/sdb5,
sector 8148088: metadata leaf (level 0) in tree 5
[ 3913.808396] btrfs: unable to fixup (regular) error at logical 4171821056
[ 3913.817759] checksum error at logical 4172443648 on dev /dev/sdb5,
sector 8149304: metadata leaf (level 0) in tree 5
[ 3913.817765] checksum error at logical 4172443648 on dev /dev/sdb5,
sector 8149304: metadata leaf (level 0) in tree 5
[ 3913.817772] btrfs: unable to fixup (regular) error at logical 4172443648
[ 3913.818378] checksum error at logical 4172468224 on dev /dev/sdb5,
sector 8149352: metadata leaf (level 0) in tree 5
[ 3913.818384] checksum error at logical 4172468224 on dev /dev/sdb5,
sector 8149352: metadata leaf (level 0) in tree 5
[ 3913.818389] btrfs: unable to fixup (regular) error at logical 4172468224
[ 3913.818432] checksum error at logical 4172476416 on dev /dev/sdb5,
sector 8149368: metadata leaf (level 0) in tree 5
[ 3913.818438] checksum error at logical 4172476416 on dev /dev/sdb5,
sector 8149368: metadata leaf (level 0) in tree 5
[ 3913.818443] btrfs: unable to fixup (regular) error at logical 4172476416
[ 3913.822927] checksum error at logical 4172738560 on dev /dev/sdb5,
sector 8149880: metadata leaf (level 0) in tree 5
[ 3913.822933] checksum error at logical 4172738560 on dev /dev/sdb5,
sector 8149880: metadata leaf (level 0) in tree 5
[ 3913.822939] btrfs: unable to fixup (regular) error at logical 4172738560


The scrub output to the console was:# btrfs scrub start -B /mnt/gentoo/
scrub done for 75b9f12c-7f3a-4bb2-abe4-dc3da29558ed
	scrub started at Tue Jan  3 10:56:26 2012 and finished after 187 seconds
	total bytes scrubbed: 2.91GB with 352 errors
	error details: read=176 verify=176
	corrected errors: 0, uncorrectable errors: 176, unverified errors: 0
