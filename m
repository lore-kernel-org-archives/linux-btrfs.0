From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: [3.3.1] multiple oopses during rsync backup
Date: Fri, 13 Apr 2012 14:21:55 +0200
Message-ID: <2cil59-784.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

This is what happened while rsyncing my system disk to my btrfs backup 
device after I enabled space caching for the latter (and first time using it 
after 3.3.1, last time I sync'ed it was with 3.2.x):

# mount options
# LABEL=usb-backup /mnt/usb-backup btrfs \
#   compress-force=zlib,subvolid=0,noauto,space_cache 0 0

[ 9934.372795] scsi10 : usb-storage 3-1:1.0
[ 9935.377551] scsi 10:0:0:0: Direct-Access     ST2000DL 003-9VT166       
CC32 PQ: 0 ANSI: 0
[ 9935.378241] sd 10:0:0:0: Attached scsi generic sg4 type 0
[ 9935.378303] sd 10:0:0:0: [sdf] 3907029164 512-byte logical blocks: (2.00 
TB/1.81 TiB)
[ 9935.378745] sd 10:0:0:0: [sdf] Write Protect is off
[ 9935.378747] sd 10:0:0:0: [sdf] Mode Sense: 03 00 00 00
[ 9935.379089] sd 10:0:0:0: [sdf] No Caching mode page present
[ 9935.379091] sd 10:0:0:0: [sdf] Assuming drive cache: write through
[ 9935.380244] sd 10:0:0:0: [sdf] No Caching mode page present
[ 9935.380246] sd 10:0:0:0: [sdf] Assuming drive cache: write through
[ 9935.424416]  sdf: sdf1
[ 9935.425602] sd 10:0:0:0: [sdf] No Caching mode page present
[ 9935.425604] sd 10:0:0:0: [sdf] Assuming drive cache: write through
[ 9935.425605] sd 10:0:0:0: [sdf] Attached SCSI disk
[ 9938.162272] btrfs no csum found for inode 13504 start 0
[ 9938.162294] btrfs no csum found for inode 13504 start 4096
[ 9938.162332] btrfs no csum found for inode 13504 start 8192
[ 9938.162363] btrfs no csum found for inode 13504 start 12288
[ 9938.162391] btrfs no csum found for inode 13504 start 16384
[ 9938.162424] btrfs no csum found for inode 13504 start 20480
[ 9938.162451] btrfs no csum found for inode 13504 start 24576
[ 9938.162477] btrfs no csum found for inode 13504 start 28672
[ 9938.162503] btrfs no csum found for inode 13504 start 32768
[ 9938.162528] btrfs no csum found for inode 13504 start 36864
[ 9938.162554] btrfs no csum found for inode 13504 start 40960
[ 9938.162580] btrfs no csum found for inode 13504 start 45056
[ 9938.162606] btrfs no csum found for inode 13504 start 49152
[ 9938.162631] btrfs no csum found for inode 13504 start 53248
[ 9938.162657] btrfs no csum found for inode 13504 start 57344
[ 9938.162685] btrfs no csum found for inode 13504 start 61440
[ 9938.162718] btrfs no csum found for inode 13504 start 65536
[ 9938.162745] btrfs no csum found for inode 13504 start 69632
[ 9938.162769] btrfs no csum found for inode 13504 start 73728
[ 9938.162793] btrfs no csum found for inode 13504 start 77824
[ 9938.162817] btrfs no csum found for inode 13504 start 81920
[ 9938.162841] btrfs no csum found for inode 13504 start 86016
[ 9938.162866] btrfs no csum found for inode 13504 start 90112
[ 9938.162890] btrfs no csum found for inode 13504 start 94208
[ 9938.162914] btrfs no csum found for inode 13504 start 98304
[ 9938.162938] btrfs no csum found for inode 13504 start 102400
[ 9938.162962] btrfs no csum found for inode 13504 start 106496
[ 9938.162986] btrfs no csum found for inode 13504 start 110592
[ 9938.163010] btrfs no csum found for inode 13504 start 114688
[ 9938.163034] btrfs no csum found for inode 13504 start 118784
[ 9938.163113] btrfs no csum found for inode 13504 start 122880
[ 9938.163137] btrfs no csum found for inode 13504 start 126976
[ 9938.163161] btrfs no csum found for inode 13504 start 131072
[ 9938.163185] btrfs no csum found for inode 13504 start 135168
[ 9938.163209] btrfs no csum found for inode 13504 start 139264
[ 9938.163234] btrfs no csum found for inode 13504 start 143360
[ 9938.163258] btrfs no csum found for inode 13504 start 147456
[ 9938.163282] btrfs no csum found for inode 13504 start 151552
[ 9938.163315] btrfs no csum found for inode 13504 start 155648
[ 9938.163339] btrfs no csum found for inode 13504 start 159744
[ 9938.163362] btrfs no csum found for inode 13504 start 163840
[ 9938.163385] btrfs no csum found for inode 13504 start 167936
[ 9938.163408] btrfs no csum found for inode 13504 start 172032
[ 9938.163432] btrfs no csum found for inode 13504 start 176128
[ 9938.163455] btrfs no csum found for inode 13504 start 180224
[ 9938.163479] btrfs no csum found for inode 13504 start 184320
[ 9938.163502] btrfs no csum found for inode 13504 start 188416
[ 9938.163535] btrfs no csum found for inode 13504 start 192512
[ 9938.163559] btrfs no csum found for inode 13504 start 196608
[ 9938.163583] btrfs no csum found for inode 13504 start 200704
[ 9938.163607] btrfs no csum found for inode 13504 start 204800
[ 9938.163641] btrfs no csum found for inode 13504 start 208896
[ 9938.163664] btrfs no csum found for inode 13504 start 212992
[ 9938.163687] btrfs no csum found for inode 13504 start 217088
[ 9938.163710] btrfs no csum found for inode 13504 start 221184
[ 9938.163734] btrfs no csum found for inode 13504 start 225280
[ 9938.163757] btrfs no csum found for inode 13504 start 229376
[ 9938.163781] btrfs no csum found for inode 13504 start 233472
[ 9938.163804] btrfs no csum found for inode 13504 start 237568
[ 9938.163827] btrfs no csum found for inode 13504 start 241664
[ 9938.163887] btrfs no csum found for inode 13504 start 245760
[ 9938.163911] btrfs no csum found for inode 13504 start 249856
[ 9938.163935] btrfs no csum found for inode 13504 start 253952
[ 9938.163960] btrfs no csum found for inode 13504 start 258048
[ 9938.163984] btrfs no csum found for inode 13504 start 262144
[ 9938.164008] btrfs no csum found for inode 13504 start 266240
[ 9938.164032] btrfs no csum found for inode 13504 start 270336
[ 9938.164057] btrfs no csum found for inode 13504 start 274432
[ 9938.164081] btrfs no csum found for inode 13504 start 278528
[ 9938.164105] btrfs no csum found for inode 13504 start 282624
[ 9938.164129] btrfs no csum found for inode 13504 start 286720
[ 9938.164153] btrfs no csum found for inode 13504 start 290816
[ 9938.164177] btrfs no csum found for inode 13504 start 294912
[ 9938.164201] btrfs no csum found for inode 13504 start 299008
[ 9938.164225] btrfs no csum found for inode 13504 start 303104
[ 9938.164250] btrfs no csum found for inode 13504 start 307200
[ 9938.164274] btrfs no csum found for inode 13504 start 311296
[ 9938.164298] btrfs no csum found for inode 13504 start 315392
[ 9938.164322] btrfs no csum found for inode 13504 start 319488
[ 9938.164347] btrfs no csum found for inode 13504 start 323584
[ 9938.164371] btrfs no csum found for inode 13504 start 327680
[ 9938.164395] btrfs no csum found for inode 13504 start 331776
[ 9938.164419] btrfs no csum found for inode 13504 start 335872
[ 9938.164444] btrfs no csum found for inode 13504 start 339968
[ 9938.164468] btrfs no csum found for inode 13504 start 344064
[ 9938.164492] btrfs no csum found for inode 13504 start 348160
[ 9938.164516] btrfs no csum found for inode 13504 start 352256
[ 9938.164540] btrfs no csum found for inode 13504 start 356352
[ 9938.164564] btrfs no csum found for inode 13504 start 360448
[ 9938.164588] btrfs no csum found for inode 13504 start 364544
[ 9938.164642] btrfs no csum found for inode 13504 start 368640
[ 9938.164666] btrfs no csum found for inode 13504 start 372736
[ 9938.164690] btrfs no csum found for inode 13504 start 376832
[ 9938.164714] btrfs no csum found for inode 13504 start 380928
[ 9938.164738] btrfs no csum found for inode 13504 start 385024
[ 9938.164762] btrfs no csum found for inode 13504 start 389120
[ 9938.164786] btrfs no csum found for inode 13504 start 393216
[ 9938.164810] btrfs no csum found for inode 13504 start 397312
[ 9938.164834] btrfs no csum found for inode 13504 start 401408
[ 9938.164858] btrfs no csum found for inode 13504 start 405504
[ 9938.164882] btrfs no csum found for inode 13504 start 409600
[ 9938.164906] btrfs no csum found for inode 13504 start 413696
[ 9938.164930] btrfs no csum found for inode 13504 start 417792
[ 9938.164954] btrfs no csum found for inode 13504 start 421888
[ 9938.164978] btrfs no csum found for inode 13504 start 425984
[ 9938.165002] btrfs no csum found for inode 13504 start 430080
[ 9938.165026] btrfs no csum found for inode 13504 start 434176
[ 9938.165050] btrfs no csum found for inode 13504 start 438272
[ 9938.165074] btrfs no csum found for inode 13504 start 442368
[ 9938.165098] btrfs no csum found for inode 13504 start 446464
[ 9938.165122] btrfs no csum found for inode 13504 start 450560
[ 9938.165146] btrfs no csum found for inode 13504 start 454656
[ 9938.165170] btrfs no csum found for inode 13504 start 458752
[ 9938.165194] btrfs no csum found for inode 13504 start 462848
[ 9938.165218] btrfs no csum found for inode 13504 start 466944
[ 9938.165242] btrfs no csum found for inode 13504 start 471040
[ 9938.165266] btrfs no csum found for inode 13504 start 475136
[ 9938.165290] btrfs no csum found for inode 13504 start 479232
[ 9938.165313] btrfs no csum found for inode 13504 start 483328
[ 9938.165337] btrfs no csum found for inode 13504 start 487424
[ 9938.165371] btrfs no csum found for inode 13504 start 491520
[ 9938.165395] btrfs no csum found for inode 13504 start 495616
[ 9938.165419] btrfs no csum found for inode 13504 start 499712
[ 9938.165443] btrfs no csum found for inode 13504 start 503808
[ 9938.165467] btrfs no csum found for inode 13504 start 507904
[ 9938.165491] btrfs no csum found for inode 13504 start 512000
[ 9938.165515] btrfs no csum found for inode 13504 start 516096
[ 9938.165539] btrfs no csum found for inode 13504 start 520192
[ 9938.165566] btrfs no csum found for inode 13504 start 524288
[ 9938.165601] btrfs no csum found for inode 13504 start 0
[ 9938.166420] btrfs no csum found for inode 13504 start 262144
[ 9942.072458] ------------[ cut here ]------------
[ 9942.072478] kernel BUG at fs/btrfs/extent-tree.c:2311!
[ 9942.072493] invalid opcode: 0000 [#1] SMP 
[ 9942.072508] CPU 1 
[ 9942.072515] Modules linked in: af_packet vmnet(O) vmblock(O) vsock(O) 
vmci(O) vmmon(O) fuse nls_iso8859_15 nls_cp437 vfat fat reiserfs zram(C) 
loop nfs lockd auth_rpcgss nfs_acl sunrpc snd_usb_audio snd_hwdep 
snd_usbmidi_lib snd_rawmidi snd_seq_device gspca_sonixj gspca_main sg 
videodev v4l2_compat_ioctl32 i2c_i801 evdev pcspkr sr_mod cdrom pata_cmd64x 
usbhid hid usb_storage uas unix [last unloaded: microcode]
[ 9942.072661] 
[ 9942.072666] Pid: 10991, comm: btrfs-endio-wri Tainted: G         C O 
3.3.1-gentoo #1 To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3
[ 9942.072702] RIP: 0010:[<ffffffff81152b02>]  [<ffffffff81152b02>] 
run_clustered_refs+0x6e8/0x74a
[ 9942.072732] RSP: 0018:ffff8802bbcc9b80  EFLAGS: 00010282
[ 9942.072747] RAX: 00000000fffffffb RBX: ffff88042b3f0300 RCX: 
00000000011c7e1e
[ 9942.072767] RDX: 00000000011c7e1d RSI: ffff880429542240 RDI: 
ffffea0010a55080
[ 9942.072786] RBP: ffff880428ddaa00 R08: 00000000000158c0 R09: 
ffffffff8114e4be
[ 9942.072805] R10: ffff88031fbc5c61 R11: 000000000000003b R12: 
0000000000000000
[ 9942.072824] R13: ffff880079ff7400 R14: ffff88042545f288 R15: 
0000000000000000
[ 9942.072844] FS:  0000000000000000(0000) GS:ffff88043fa80000(0000) 
knlGS:0000000000000000
[ 9942.072865] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 9942.072881] CR2: 00007faf074b4000 CR3: 00000003f366d000 CR4: 
00000000000406e0
[ 9942.072900] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 9942.072919] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 9942.072938] Process btrfs-endio-wri (pid: 10991, threadinfo 
ffff8802bbcc8000, task ffff88042902d2e0)
[ 9942.072962] Stack:
[ 9942.072969]  00000000001d8b92 0000000000280000 0000000000000001 
0000000000000000
[ 9942.072993]  0000000000001000 0000000000000000 ffff88039cd02000 
ffff8803f68e7aa0
[ 9942.073017]  ffff88029b1850a8 ffff8803f68e79e0 0000000300000064 
ffff88029b185120
[ 9942.073041] Call Trace:
[ 9942.073051]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[ 9942.073070]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[ 9942.073088]  [<ffffffff8119a941>] ? 
btrfs_delayed_update_inode+0x340/0x363
[ 9942.073107]  [<ffffffff81044f54>] ? __wake_up+0x35/0x46
[ 9942.073123]  [<ffffffff81160c40>] ? __btrfs_end_transaction+0x79/0x1e9
[ 9942.073142]  [<ffffffff81165953>] ? btrfs_finish_ordered_io+0x289/0x2ae
[ 9942.073161]  [<ffffffff81458f7b>] ? schedule_timeout+0xa8/0xd7
[ 9942.073179]  [<ffffffff81190a6f>] ? end_compressed_bio_write+0x60/0xbb
[ 9942.073197]  [<ffffffff811818f5>] ? worker_loop+0x17e/0x4c5
[ 9942.073213]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[ 9942.073230]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[ 9942.073247]  [<ffffffff8103ee71>] ? kthread+0x81/0x89
[ 9942.073262]  [<ffffffff8145c254>] ? kernel_thread_helper+0x4/0x10
[ 9942.073280]  [<ffffffff8103edf0>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[ 9942.073298]  [<ffffffff8145c250>] ? gs_change+0xb/0xb
[ 9942.073312] Code: c0 89 7c 24 10 48 8b 7b 58 48 89 7c 24 08 48 8b 7b 50 
48 89 3c 24 4c 89 ee 4c 89 f7 e8 ec ca ff ff eb 04 0f 0b 0f 0b 85 c0 74 02 
<0f> 0b 48 89 df e8 c3 94 ff ff 4c 89 e7 e8 15 2b f6 ff ff 44 24 
[ 9942.073442] RIP  [<ffffffff81152b02>] run_clustered_refs+0x6e8/0x74a
[ 9942.073462]  RSP <ffff8802bbcc9b80>
[ 9942.074552] btrfs bad mapping eb start 1434441699328 len 4096, wanted 
52430293 4
[ 9942.074575] ------------[ cut here ]------------
[ 9942.074591] WARNING: at fs/btrfs/extent_io.c:4138 
map_private_extent_buffer+0x89/0xde()
[ 9942.074612] Hardware name: To Be Filled By O.E.M.
[ 9942.074625] Modules linked in: af_packet vmnet(O) vmblock(O) vsock(O) 
vmci(O) vmmon(O) fuse nls_iso8859_15 nls_cp437 vfat fat reiserfs zram(C) 
loop nfs lockd auth_rpcgss nfs_acl sunrpc snd_usb_audio snd_hwdep 
snd_usbmidi_lib snd_rawmidi snd_seq_device gspca_sonixj gspca_main sg 
videodev v4l2_compat_ioctl32 i2c_i801 evdev pcspkr sr_mod cdrom pata_cmd64x 
usbhid hid usb_storage uas unix [last unloaded: microcode]
[ 9942.074767] Pid: 11071, comm: btrfs-endio-wri Tainted: G         C O 
3.3.1-gentoo #1
[ 9942.074787] Call Trace:
[ 9942.074798]  [<ffffffff8102940c>] ? warn_slowpath_common+0x78/0x8c
[ 9942.074815]  [<ffffffff8117a052>] ? map_private_extent_buffer+0x89/0xde
[ 9942.074835]  [<ffffffff811720b1>] ? btrfs_item_size+0x2c/0x62
[ 9942.074851]  [<ffffffff81171fe4>] ? btrfs_item_offset+0x2c/0x62
[ 9942.074868]  [<ffffffff8114585d>] ? btrfs_item_end_nr+0x28/0x30
[ 9942.074884]  [<ffffffff81145a81>] ? leaf_space_used+0x4e/0x70
[ 9942.074901]  [<ffffffff8114873b>] ? btrfs_leaf_free_space+0x31/0x6e
[ 9942.074918]  [<ffffffff81149100>] ? push_leaf_right+0xa4/0x150
[ 9942.074936]  [<ffffffff81091ec4>] ? __put_compound_page+0x13/0x13
[ 9942.074953]  [<ffffffff8117a066>] ? map_private_extent_buffer+0x9d/0xde
[ 9942.074971]  [<ffffffff811492d2>] ? split_leaf+0x78/0x52b
[ 9942.074986]  [<ffffffff81171fe4>] ? btrfs_item_offset+0x2c/0x62
[ 9942.075003]  [<ffffffff8114585d>] ? btrfs_item_end_nr+0x28/0x30
[ 9942.075019]  [<ffffffff81145a81>] ? leaf_space_used+0x4e/0x70
[ 9942.075036]  [<ffffffff811870bd>] ? btrfs_set_lock_blocking_rw+0x88/0xdf
[ 9942.076267]  [<ffffffff81149f48>] ? btrfs_search_slot+0x5b1/0x658
[ 9942.077493]  [<ffffffff8114d0da>] ? 
lookup_inline_extent_backref+0xb8/0x36e
[ 9942.078718]  [<ffffffff8115cefc>] ? btrfs_mark_buffer_dirty+0x86/0xc8
[ 9942.079950]  [<ffffffff8114d3f3>] ? 
insert_inline_extent_backref+0x63/0xea
[ 9942.081147]  [<ffffffff81459e41>] ? _cond_resched+0x9/0x20
[ 9942.082304]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[ 9942.083437]  [<ffffffff8114e3b8>] ? 
__btrfs_inc_extent_ref.clone.64+0xa9/0x1c9
[ 9942.084549]  [<ffffffff8114e7e0>] ? do_chunk_alloc.clone.57+0x9f/0x2a6
[ 9942.085645]  [<ffffffff81152ac2>] ? run_clustered_refs+0x6a8/0x74a
[ 9942.086743]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[ 9942.087824]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[ 9942.088910]  [<ffffffff8119a941>] ? 
btrfs_delayed_update_inode+0x340/0x363
[ 9942.089997]  [<ffffffff81044f54>] ? __wake_up+0x35/0x46
[ 9942.091080]  [<ffffffff81160c40>] ? __btrfs_end_transaction+0x79/0x1e9
[ 9942.092165]  [<ffffffff81165953>] ? btrfs_finish_ordered_io+0x289/0x2ae
[ 9942.093245]  [<ffffffff81458f7b>] ? schedule_timeout+0xa8/0xd7
[ 9942.094316]  [<ffffffff81190a6f>] ? end_compressed_bio_write+0x60/0xbb
[ 9942.095383]  [<ffffffff811818f5>] ? worker_loop+0x17e/0x4c5
[ 9942.096444]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[ 9942.097505]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[ 9942.098551]  [<ffffffff8103ee71>] ? kthread+0x81/0x89
[ 9942.099585]  [<ffffffff8145c254>] ? kernel_thread_helper+0x4/0x10
[ 9942.100615]  [<ffffffff8103edf0>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[ 9942.101646]  [<ffffffff8145c250>] ? gs_change+0xb/0xb
[ 9942.102669] ---[ end trace d5a225892d42c454 ]---
[ 9942.103688] ------------[ cut here ]------------
[ 9942.104700] WARNING: at fs/btrfs/extent_io.c:4091 
read_extent_buffer+0x46/0xe2()
[ 9942.105724] Hardware name: To Be Filled By O.E.M.
[ 9942.106749] Modules linked in: af_packet vmnet(O) vmblock(O) vsock(O) 
vmci(O) vmmon(O) fuse nls_iso8859_15 nls_cp437 vfat fat reiserfs zram(C) 
loop nfs lockd auth_rpcgss nfs_acl sunrpc snd_usb_audio snd_hwdep 
snd_usbmidi_lib snd_rawmidi snd_seq_device gspca_sonixj gspca_main sg 
videodev v4l2_compat_ioctl32 i2c_i801 evdev pcspkr sr_mod cdrom pata_cmd64x 
usbhid hid usb_storage uas unix [last unloaded: microcode]
[ 9942.109022] Pid: 11071, comm: btrfs-endio-wri Tainted: G        WC O 
3.3.1-gentoo #1
[ 9942.110157] Call Trace:
[ 9942.111287]  [<ffffffff8102940c>] ? warn_slowpath_common+0x78/0x8c
[ 9942.112426]  [<ffffffff81179bbb>] ? read_extent_buffer+0x46/0xe2
[ 9942.113570]  [<ffffffff81171ffd>] ? btrfs_item_offset+0x45/0x62
[ 9942.114706]  [<ffffffff8114585d>] ? btrfs_item_end_nr+0x28/0x30
[ 9942.115847]  [<ffffffff81145a81>] ? leaf_space_used+0x4e/0x70
[ 9942.116990]  [<ffffffff8114873b>] ? btrfs_leaf_free_space+0x31/0x6e
[ 9942.118134]  [<ffffffff81149100>] ? push_leaf_right+0xa4/0x150
[ 9942.119276]  [<ffffffff81091ec4>] ? __put_compound_page+0x13/0x13
[ 9942.120413]  [<ffffffff8117a066>] ? map_private_extent_buffer+0x9d/0xde
[ 9942.121499]  [<ffffffff811492d2>] ? split_leaf+0x78/0x52b
[ 9942.122537]  [<ffffffff81171fe4>] ? btrfs_item_offset+0x2c/0x62
[ 9942.123570]  [<ffffffff8114585d>] ? btrfs_item_end_nr+0x28/0x30
[ 9942.124590]  [<ffffffff81145a81>] ? leaf_space_used+0x4e/0x70
[ 9942.125607]  [<ffffffff811870bd>] ? btrfs_set_lock_blocking_rw+0x88/0xdf
[ 9942.126624]  [<ffffffff81149f48>] ? btrfs_search_slot+0x5b1/0x658
[ 9942.127629]  [<ffffffff8114d0da>] ? 
lookup_inline_extent_backref+0xb8/0x36e
[ 9942.128619]  [<ffffffff8115cefc>] ? btrfs_mark_buffer_dirty+0x86/0xc8
[ 9942.129563]  [<ffffffff8114d3f3>] ? 
insert_inline_extent_backref+0x63/0xea
[ 9942.130477]  [<ffffffff81459e41>] ? _cond_resched+0x9/0x20
[ 9942.131380]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[ 9942.132284]  [<ffffffff8114e3b8>] ? 
__btrfs_inc_extent_ref.clone.64+0xa9/0x1c9
[ 9942.133197]  [<ffffffff8114e7e0>] ? do_chunk_alloc.clone.57+0x9f/0x2a6
[ 9942.134109]  [<ffffffff81152ac2>] ? run_clustered_refs+0x6a8/0x74a
[ 9942.135019]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[ 9942.135935]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[ 9942.136853]  [<ffffffff8119a941>] ? 
btrfs_delayed_update_inode+0x340/0x363
[ 9942.137770]  [<ffffffff81044f54>] ? __wake_up+0x35/0x46
[ 9942.138685]  [<ffffffff81160c40>] ? __btrfs_end_transaction+0x79/0x1e9
[ 9942.139608]  [<ffffffff81165953>] ? btrfs_finish_ordered_io+0x289/0x2ae
[ 9942.140529]  [<ffffffff81458f7b>] ? schedule_timeout+0xa8/0xd7
[ 9942.141446]  [<ffffffff81190a6f>] ? end_compressed_bio_write+0x60/0xbb
[ 9942.142363]  [<ffffffff811818f5>] ? worker_loop+0x17e/0x4c5
[ 9942.143291]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[ 9942.144216]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[ 9942.145135]  [<ffffffff8103ee71>] ? kthread+0x81/0x89
[ 9942.146054]  [<ffffffff8145c254>] ? kernel_thread_helper+0x4/0x10
[ 9942.146975]  [<ffffffff8103edf0>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[ 9942.147892]  [<ffffffff8145c250>] ? gs_change+0xb/0xb
[ 9942.148799] ---[ end trace d5a225892d42c455 ]---
[ 9942.221114] ---[ end trace d5a225892d42c456 ]---
[ 9942.221141] general protection fault: 0000 [#2] SMP 
[ 9942.221143] CPU 3 
[ 9942.221144] Modules linked in: af_packet vmnet(O) vmblock(O) vsock(O) 
vmci(O) vmmon(O) fuse nls_iso8859_15 nls_cp437 vfat fat reiserfs zram(C) 
loop nfs lockd auth_rpcgss nfs_acl sunrpc snd_usb_audio snd_hwdep 
snd_usbmidi_lib snd_rawmidi snd_seq_device gspca_sonixj gspca_main sg 
videodev v4l2_compat_ioctl32 i2c_i801 evdev pcspkr sr_mod cdrom pata_cmd64x 
usbhid hid usb_storage uas unix [last unloaded: microcode]
[ 9942.221157] 
[ 9942.221159] Pid: 11071, comm: btrfs-endio-wri Tainted: G      D WC O 
3.3.1-gentoo #1 To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3
[ 9942.221161] RIP: 0010:[<ffffffff81179c3e>]  [<ffffffff81179c3e>] 
read_extent_buffer+0xc9/0xe2
[ 9942.221167] RSP: 0018:ffff88016cebb6f0  EFLAGS: 00010202
[ 9942.221168] RAX: 0000000000000000 RBX: ffff88029b1859d8 RCX: 
0000000000000004
[ 9942.221169] RDX: 0000000000000004 RSI: 00050800000005d5 RDI: 
ffff88016cebb75c
[ 9942.221171] RBP: 0000000000000000 R08: 0000000000000000 R09: 
ffff880403b1a6d0
[ 9942.221172] R10: 0000000000000000 R11: ffffffffffffffff R12: 
ffff88016cebb75c
[ 9942.221173] R13: 0000000000003201 R14: ffff880000000000 R15: 
0000160000000000
[ 9942.221175] FS:  0000000000000000(0000) GS:ffff88043fb80000(0000) 
knlGS:0000000000000000
[ 9942.221176] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 9942.221177] CR2: 00001e20ccf04000 CR3: 000000029f661000 CR4: 
00000000000406e0
[ 9942.221178] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 9942.221180] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 9942.221181] Process btrfs-endio-wri (pid: 11071, threadinfo 
ffff88016ceba000, task ffff8804250aa640)
[ 9942.221182] Stack:
[ 9942.221183]  00000000032005d5 00000000000005d5 ffff88016cebb750 
ffff88029b1859d8
[ 9942.221185]  00000000032005c4 00000000032005d5 0000000000200038 
0000000003b205e4
[ 9942.221186]  ffff88042545abd0 ffffffff81171ffd ffff88029b1859d8 
0000000003200000
[ 9942.221188] Call Trace:
[ 9942.221191]  [<ffffffff81171ffd>] ? btrfs_item_offset+0x45/0x62
[ 9942.221193]  [<ffffffff8114585d>] ? btrfs_item_end_nr+0x28/0x30
[ 9942.221194]  [<ffffffff81145a81>] ? leaf_space_used+0x4e/0x70
[ 9942.221196]  [<ffffffff8114873b>] ? btrfs_leaf_free_space+0x31/0x6e
[ 9942.221198]  [<ffffffff81149100>] ? push_leaf_right+0xa4/0x150
[ 9942.221201]  [<ffffffff81091ec4>] ? __put_compound_page+0x13/0x13
[ 9942.221202]  [<ffffffff8117a066>] ? map_private_extent_buffer+0x9d/0xde
[ 9942.221204]  [<ffffffff811492d2>] ? split_leaf+0x78/0x52b
[ 9942.221206]  [<ffffffff81171fe4>] ? btrfs_item_offset+0x2c/0x62
[ 9942.221207]  [<ffffffff8114585d>] ? btrfs_item_end_nr+0x28/0x30
[ 9942.221208]  [<ffffffff81145a81>] ? leaf_space_used+0x4e/0x70
[ 9942.221210]  [<ffffffff811870bd>] ? btrfs_set_lock_blocking_rw+0x88/0xdf
[ 9942.221212]  [<ffffffff81149f48>] ? btrfs_search_slot+0x5b1/0x658
[ 9942.221214]  [<ffffffff8114d0da>] ? 
lookup_inline_extent_backref+0xb8/0x36e
[ 9942.221217]  [<ffffffff8115cefc>] ? btrfs_mark_buffer_dirty+0x86/0xc8
[ 9942.221219]  [<ffffffff8114d3f3>] ? 
insert_inline_extent_backref+0x63/0xea
[ 9942.221221]  [<ffffffff81459e41>] ? _cond_resched+0x9/0x20
[ 9942.221224]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[ 9942.221226]  [<ffffffff8114e3b8>] ? 
__btrfs_inc_extent_ref.clone.64+0xa9/0x1c9
[ 9942.221227]  [<ffffffff8114e7e0>] ? do_chunk_alloc.clone.57+0x9f/0x2a6
[ 9942.221230]  [<ffffffff81152ac2>] ? run_clustered_refs+0x6a8/0x74a
[ 9942.221232]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[ 9942.221235]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[ 9942.221237]  [<ffffffff8119a941>] ? 
btrfs_delayed_update_inode+0x340/0x363
[ 9942.221238]  [<ffffffff81044f54>] ? __wake_up+0x35/0x46
[ 9942.221240]  [<ffffffff81160c40>] ? __btrfs_end_transaction+0x79/0x1e9
[ 9942.221242]  [<ffffffff81165953>] ? btrfs_finish_ordered_io+0x289/0x2ae
[ 9942.221244]  [<ffffffff81458f7b>] ? schedule_timeout+0xa8/0xd7
[ 9942.221246]  [<ffffffff81190a6f>] ? end_compressed_bio_write+0x60/0xbb
[ 9942.221248]  [<ffffffff811818f5>] ? worker_loop+0x17e/0x4c5
[ 9942.221249]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[ 9942.221250]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[ 9942.221253]  [<ffffffff8103ee71>] ? kthread+0x81/0x89
[ 9942.221255]  [<ffffffff8145c254>] ? kernel_thread_helper+0x4/0x10
[ 9942.221257]  [<ffffffff8103edf0>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[ 9942.221258]  [<ffffffff8145c250>] ? gs_change+0xb/0xb
[ 9942.221259] Code: e7 ba 00 10 00 00 4a 8d 34 38 48 29 ca 48 39 ea 48 0f 
47 d5 48 c1 fe 06 48 29 d5 48 c1 e6 0c 49 ff c5 4c 01 f6 48 01 ce 48 89 d1 
<f3> a4 49 89 fc 48 85 ed 75 b4 48 83 c4 18 5b 5d 41 5c 41 5d 41 
[ 9942.221270] RIP  [<ffffffff81179c3e>] read_extent_buffer+0xc9/0xe2
[ 9942.221272]  RSP <ffff88016cebb6f0>
[ 9942.221273] ---[ end trace d5a225892d42c457 ]---
[ 9942.221275] ------------[ cut here ]------------
[ 9942.221277] kernel BUG at fs/btrfs/extent-tree.c:2311!
[ 9942.221279] invalid opcode: 0000 [#3] SMP 
[ 9942.221280] CPU 0 
[ 9942.221280] Modules linked in: af_packet vmnet(O) vmblock(O) vsock(O) 
vmci(O) vmmon(O) fuse nls_iso8859_15 nls_cp437 vfat fat reiserfs zram(C) 
loop nfs lockd auth_rpcgss nfs_acl sunrpc snd_usb_audio snd_hwdep 
snd_usbmidi_lib snd_rawmidi snd_seq_device gspca_sonixj gspca_main sg 
videodev v4l2_compat_ioctl32 i2c_i801 evdev pcspkr sr_mod cdrom pata_cmd64x 
usbhid hid usb_storage uas unix [last unloaded: microcode]
[ 9942.221291] 
[ 9942.221293] Pid: 11070, comm: btrfs-endio-wri Tainted: G      D WC O 
3.3.1-gentoo #1 To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3
[ 9942.221295] RIP: 0010:[<ffffffff81152b02>]  [<ffffffff81152b02>] 
run_clustered_refs+0x6e8/0x74a
[ 9942.221299] RSP: 0018:ffff8801c50a7b80  EFLAGS: 00010282
[ 9942.221300] RAX: 00000000fffffffb RBX: ffff8804277592a0 RCX: 
0000000000d74a42
[ 9942.221301] RDX: 0000000000d74a41 RSI: ffff88042962d360 RDI: 
ffffea0010a58b40
[ 9942.221303] RBP: ffff88042c88f700 R08: 00000000000158c0 R09: 
ffffffff8114e4be
[ 9942.221304] R10: 0000000000010b00 R11: 0000000000001000 R12: 
0000000000000000
[ 9942.221305] R13: ffff880079ff7400 R14: ffff880425432ea0 R15: 
0000000025410200
[ 9942.221307] FS:  0000000000000000(0000) GS:ffff88043fa00000(0000) 
knlGS:0000000000000000
[ 9942.221308] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 9942.221309] CR2: ffffffffff600400 CR3: 00000003d0a41000 CR4: 
00000000000406f0
[ 9942.221310] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 9942.221312] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 9942.221314] Process btrfs-endio-wri (pid: 11070, threadinfo 
ffff8801c50a6000, task ffff8804250af920)
[ 9942.221315] Stack:
[ 9942.221315]  00000000001d8b92 00000000007a0000 0000000000000001 
0000000000000000
[ 9942.221317]  0000000000001000 0000000000000000 ffff88039cd02000 
ffff8803f68e7aa0
[ 9942.221319]  ffff88029b1850a8 ffff8803f68e79e0 0000000000000096 
ffffffff81191879
[ 9942.221320] Call Trace:
[ 9942.221323]  [<ffffffff81191879>] ? find_ref_head+0x8e/0xbb
[ 9942.221325]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[ 9942.221327]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[ 9942.221329]  [<ffffffff8119a941>] ? 
btrfs_delayed_update_inode+0x340/0x363
[ 9942.221331]  [<ffffffff81044f54>] ? __wake_up+0x35/0x46
[ 9942.221333]  [<ffffffff81160c40>] ? __btrfs_end_transaction+0x79/0x1e9
[ 9942.221334]  [<ffffffff81165953>] ? btrfs_finish_ordered_io+0x289/0x2ae
[ 9942.221337]  [<ffffffff81458f7b>] ? schedule_timeout+0xa8/0xd7
[ 9942.221340]  [<ffffffff81032dd5>] ? init_timer_deferrable_key+0xf/0xf
[ 9942.221342]  [<ffffffff81190a6f>] ? end_compressed_bio_write+0x60/0xbb
[ 9942.221343]  [<ffffffff811818f5>] ? worker_loop+0x17e/0x4c5
[ 9942.221345]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[ 9942.221346]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[ 9942.221348]  [<ffffffff8103ee71>] ? kthread+0x81/0x89
[ 9942.221349]  [<ffffffff8145c254>] ? kernel_thread_helper+0x4/0x10
[ 9942.221351]  [<ffffffff8103edf0>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[ 9942.221353]  [<ffffffff8145c250>] ? gs_change+0xb/0xb
[ 9942.221353] Code: c0 89 7c 24 10 48 8b 7b 58 48 89 7c 24 08 48 8b 7b 50 
48 89 3c 24 4c 89 ee 4c 89 f7 e8 ec ca ff ff eb 04 0f 0b 0f 0b 85 c0 74 02 
<0f> 0b 48 89 df e8 c3 94 ff ff 4c 89 e7 e8 15 2b f6 ff ff 44 24 
[ 9942.221364] RIP  [<ffffffff81152b02>] run_clustered_refs+0x6e8/0x74a
[ 9942.221366]  RSP <ffff8801c50a7b80>
[ 9942.221415] ---[ end trace d5a225892d42c458 ]---

I'm not very happy that everytime such problems occur...

1. ...my system freezes on shut down and needs a hard reboot
   (potentially breaking my system root btrfs)
2. ...I have to rsync from scratch because the FS becomes broken
   (which will take ages)

Is there a working btrfs repair utility meanwhile? If it screws the FS this 
will be no problem as I would have to restart from scratch then anyways. 
This is my backup drive, I'd like to get it back into shape as soon as 
possible. So if you need more info please say so before I purge it.

This device was disconnected from USB accidently before but worked fine 
afterwards (for multiple snapshots/rsync runs). Just now when I enabled 
space_cache and upgraded to 3.3.1 it broke. Not sure which of both changes 
introduced these issues now.

Regards,
Kai

