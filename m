From: Kyle Gates <kylegates@gmail.com>
Subject: =?UTF-8?Q?balance_crash_during_convert_3=2E4rc6=E2=80=8F?=
Date: Thu, 10 May 2012 10:22:22 -0500
Message-ID: <CA+M2Djn6_D90Wac3hXr9CqdwW3grkzxmxRG5kh4gtir-oMPXsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I was attempting to convert from RAID1 to single on a 3 disk array
using Ubuntu mainline kernel 3.4rc6
mount options iirc: space_cache,inode_cache,nodatacow,compress,autodefrag
command: btrfs fi bal start -dconvert=single,soft /mnt

The (hopefully) relevant log follows.
Thanks,
Kyle

[38530.122963] btrfs: block rsv returned -28
[38530.122969] ------------[ cut here ]------------
[38530.123047] WARNING: at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:6219
use_block_rsv+0x16d/0x180 [btrfs]()
[38530.123051] Hardware name: KT600-8237
[38530.123053] Modules linked in: rfcomm bnep bluetooth parport_pc
ppdev nfsd nfs lockd binfmt_misc fscache auth_rpcgss nfs_acl sunrpc
dm_crypt usblp snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm
snd_page_alloc snd_mpu401_uart snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
soundcore serio_raw lm63 shpchp mac_hid hwmon_vid lm90 i2c_viapro lp
parport btrfs zlib_deflate libcrc32c radeon ttm via_rhine
drm_kms_helper drm i2c_algo_bit pata_via sata_via
[38530.123094] Pid: 2197, comm: btrfs-endio-wri Not tainted
3.4.0-030400rc6-generic #201205061835
[38530.123097] Call Trace:
[38530.123112]  [<c1035832>] warn_slowpath_common+0x72/0xa0
[38530.123131]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38530.123150]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38530.123154]  [<c1035882>] warn_slowpath_null+0x22/0x30
[38530.123173]  [<f891ab9d>] use_block_rsv+0x16d/0x180 [btrfs]
[38530.123192]  [<f891feac>] btrfs_alloc_free_block+0x3c/0x2b0 [btrfs]
[38530.123210]  [<f890b388>] __btrfs_cow_block+0x148/0x560 [btrfs]
[38530.123228]  [<f890bead>] btrfs_cow_block+0xdd/0x220 [btrfs]
[38530.123246]  [<f890f929>] btrfs_search_slot+0x2c9/0x650 [btrfs]
[38530.123265]  [<f8922c35>] btrfs_lookup_file_extent+0x55/0x70 [btrfs]
[38530.123289]  [<f89402d7>] btrfs_drop_extents+0x117/0xb00 [btrfs]
[38530.123299]  [<c112aaf9>] ? kmem_cache_alloc+0x29/0x100
[38530.123322]  [<f8953dad>] ? alloc_extent_state+0x1d/0xb0 [btrfs]
[38530.123327]  [<c112ab74>] ? kmem_cache_alloc+0xa4/0x100
[38530.123349]  [<f8954ba3>] ? __set_extent_bit+0x323/0x670 [btrfs]
[38530.123367]  [<f890a0e7>] ? btrfs_alloc_path+0x17/0x20 [btrfs]
[38530.123388]  [<f893baa3>] T.1560+0x83/0x2b0 [btrfs]
[38530.123409]  [<f893c431>] btrfs_finish_ordered_io+0x3c1/0x480 [btrfs]
[38530.123431]  [<f893c534>] btrfs_writepage_end_io_hook+0x44/0xa0 [btrfs]
[38530.123437]  [<c157e5cf>] ? _raw_spin_lock_irqsave+0x2f/0x50
[38530.123445]  [<c10ef313>] ? mempool_free_slab+0x13/0x20
[38530.123468]  [<f8955dd9>] end_extent_writepage+0x69/0x120 [btrfs]
[38530.123489]  [<f893c4f0>] ? btrfs_finish_ordered_io+0x480/0x480 [btrfs]
[38530.123512]  [<f8955f43>] end_bio_extent_writepage+0xb3/0xe0 [btrfs]
[38530.123518]  [<c116897a>] bio_endio+0x1a/0x40
[38530.123537]  [<f8928277>] end_workqueue_fn+0x37/0x50 [btrfs]
[38530.123560]  [<f8963405>] worker_loop+0x105/0x400 [btrfs]
[38530.123582]  [<f8963300>] ? check_pending_worker_creates+0xc0/0xc0 [btrfs]
[38530.123590]  [<c105463c>] kthread+0x7c/0x90
[38530.123594]  [<c10545c0>] ? kthread_freezable_should_stop+0x60/0x60
[38530.123599]  [<c1585bbe>] kernel_thread_helper+0x6/0x10
[38530.123603] ---[ end trace 519c34cc6a22875e ]---
[38530.123644] btrfs: block rsv returned -28
[38530.123647] ------------[ cut here ]------------
[38530.123667] WARNING: at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:6219
use_block_rsv+0x16d/0x180 [btrfs]()
[38530.123670] Hardware name: KT600-8237
[38530.123672] Modules linked in: rfcomm bnep bluetooth parport_pc
ppdev nfsd nfs lockd binfmt_misc fscache auth_rpcgss nfs_acl sunrpc
dm_crypt usblp snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm
snd_page_alloc snd_mpu401_uart snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
soundcore serio_raw lm63 shpchp mac_hid hwmon_vid lm90 i2c_viapro lp
parport btrfs zlib_deflate libcrc32c radeon ttm via_rhine
drm_kms_helper drm i2c_algo_bit pata_via sata_via
[38530.123707] Pid: 2197, comm: btrfs-endio-wri Tainted: G        W
3.4.0-030400rc6-generic #201205061835
[38530.123710] Call Trace:
[38530.123716]  [<c1035832>] warn_slowpath_common+0x72/0xa0
[38530.123734]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38530.123752]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38530.123757]  [<c1035882>] warn_slowpath_null+0x22/0x30
[38530.123775]  [<f891ab9d>] use_block_rsv+0x16d/0x180 [btrfs]
[38530.123794]  [<f891feac>] btrfs_alloc_free_block+0x3c/0x2b0 [btrfs]
[38530.123813]  [<f89276d4>] ? btree_set_page_dirty+0x34/0x50 [btrfs]
[38530.123818]  [<c10f4ae7>] ? set_page_dirty+0x37/0x60
[38530.123840]  [<f89522f9>] ? set_extent_buffer_dirty+0x89/0xc0 [btrfs]
[38530.123863]  [<f8951a5b>] ? read_extent_buffer+0x9b/0xf0 [btrfs]
[38530.123880]  [<f890b388>] __btrfs_cow_block+0x148/0x560 [btrfs]
[38530.123897]  [<f890c82f>] ? balance_level+0xdf/0x740 [btrfs]
[38530.123915]  [<f890bead>] btrfs_cow_block+0xdd/0x220 [btrfs]
[38530.123932]  [<f890f929>] btrfs_search_slot+0x2c9/0x650 [btrfs]
[38530.123951]  [<f8922c35>] btrfs_lookup_file_extent+0x55/0x70 [btrfs]
[38530.123973]  [<f89402d7>] btrfs_drop_extents+0x117/0xb00 [btrfs]
[38530.123979]  [<c112aaf9>] ? kmem_cache_alloc+0x29/0x100
[38530.124001]  [<f8953dad>] ? alloc_extent_state+0x1d/0xb0 [btrfs]
[38530.124051]  [<c112ab74>] ? kmem_cache_alloc+0xa4/0x100
[38530.124075]  [<f8954ba3>] ? __set_extent_bit+0x323/0x670 [btrfs]
[38530.124092]  [<f890a0e7>] ? btrfs_alloc_path+0x17/0x20 [btrfs]
[38530.124113]  [<f893baa3>] T.1560+0x83/0x2b0 [btrfs]
[38530.124134]  [<f893c431>] btrfs_finish_ordered_io+0x3c1/0x480 [btrfs]
[38530.124156]  [<f893c534>] btrfs_writepage_end_io_hook+0x44/0xa0 [btrfs]
[38530.124160]  [<c157e5cf>] ? _raw_spin_lock_irqsave+0x2f/0x50
[38530.124165]  [<c10ef313>] ? mempool_free_slab+0x13/0x20
[38530.124187]  [<f8955dd9>] end_extent_writepage+0x69/0x120 [btrfs]
[38530.124208]  [<f893c4f0>] ? btrfs_finish_ordered_io+0x480/0x480 [btrfs]
[38530.124231]  [<f8955f43>] end_bio_extent_writepage+0xb3/0xe0 [btrfs]
[38530.124235]  [<c116897a>] bio_endio+0x1a/0x40
[38530.124254]  [<f8928277>] end_workqueue_fn+0x37/0x50 [btrfs]
[38530.124276]  [<f8963405>] worker_loop+0x105/0x400 [btrfs]
[38530.124298]  [<f8963300>] ? check_pending_worker_creates+0xc0/0xc0 [btrfs]
[38530.124303]  [<c105463c>] kthread+0x7c/0x90
[38530.124307]  [<c10545c0>] ? kthread_freezable_should_stop+0x60/0x60
[38530.124311]  [<c1585bbe>] kernel_thread_helper+0x6/0x10
[38530.124314] ---[ end trace 519c34cc6a22875f ]---
[38557.411929] btrfs: found 1237 extents
[38574.960680] btrfs: found 1237 extents
[38575.335032] btrfs: relocating block group 446773067776 flags 17
[38575.849600] use_block_rsv: 25 callbacks suppressed
[38575.849607] btrfs: block rsv returned -28
[38575.849609] ------------[ cut here ]------------
[38575.849691] WARNING: at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:6219
use_block_rsv+0x16d/0x180 [btrfs]()
[38575.849695] Hardware name: KT600-8237
[38575.849697] Modules linked in: rfcomm bnep bluetooth parport_pc
ppdev nfsd nfs lockd binfmt_misc fscache auth_rpcgss nfs_acl sunrpc
dm_crypt usblp snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm
snd_page_alloc snd_mpu401_uart snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
soundcore serio_raw lm63 shpchp mac_hid hwmon_vid lm90 i2c_viapro lp
parport btrfs zlib_deflate libcrc32c radeon ttm via_rhine
drm_kms_helper drm i2c_algo_bit pata_via sata_via
[38575.849737] Pid: 574, comm: btrfs-endio-wri Tainted: G        W
3.4.0-030400rc6-generic #201205061835
[38575.849741] Call Trace:
[38575.849756]  [<c1035832>] warn_slowpath_common+0x72/0xa0
[38575.849775]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38575.849793]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38575.849798]  [<c1035882>] warn_slowpath_null+0x22/0x30
[38575.849816]  [<f891ab9d>] use_block_rsv+0x16d/0x180 [btrfs]
[38575.849849]  [<f8978b9d>] ? btrfs_add_delayed_data_ref+0x7d/0x1d0 [btrfs]
[38575.849868]  [<f891feac>] btrfs_alloc_free_block+0x3c/0x2b0 [btrfs]
[38575.849878]  [<c12aa333>] ? rb_insert_color+0xd3/0x110
[38575.849901]  [<f8978272>] ? tree_insert+0x62/0x80 [btrfs]
[38575.849923]  [<f8951a5b>] ? read_extent_buffer+0x9b/0xf0 [btrfs]
[38575.849941]  [<f890b388>] __btrfs_cow_block+0x148/0x560 [btrfs]
[38575.849964]  [<f894422f>] ? btrfs_item_offset+0xf/0x20 [btrfs]
[38575.849981]  [<f890bead>] btrfs_cow_block+0xdd/0x220 [btrfs]
[38575.850000]  [<f890f929>] btrfs_search_slot+0x2c9/0x650 [btrfs]
[38575.850019]  [<f892339f>] btrfs_lookup_csum+0x6f/0x170 [btrfs]
[38575.850029]  [<c112ab74>] ? kmem_cache_alloc+0xa4/0x100
[38575.850051]  [<f8953ea7>] ? free_extent_state+0x47/0x90 [btrfs]
[38575.850068]  [<f890a0e7>] ? btrfs_alloc_path+0x17/0x20 [btrfs]
[38575.850088]  [<f8924286>] btrfs_csum_file_blocks+0xb6/0x670 [btrfs]
[38575.850110]  [<f8953ea7>] ? free_extent_state+0x47/0x90 [btrfs]
[38575.850133]  [<f8955884>] ? clear_extent_bit+0x124/0x500 [btrfs]
[38575.850156]  [<f89561d9>] ? unlock_extent_cached+0x49/0x60 [btrfs]
[38575.850176]  [<f8930a2d>] add_pending_csums+0x3d/0x60 [btrfs]
[38575.850198]  [<f893c344>] btrfs_finish_ordered_io+0x2d4/0x480 [btrfs]
[38575.850219]  [<f893c534>] btrfs_writepage_end_io_hook+0x44/0xa0 [btrfs]
[38575.850225]  [<c157e59d>] ? _raw_spin_lock+0xd/0x10
[38575.850248]  [<f8955dd9>] end_extent_writepage+0x69/0x120 [btrfs]
[38575.850269]  [<f893c4f0>] ? btrfs_finish_ordered_io+0x480/0x480 [btrfs]
[38575.850292]  [<f8955f43>] end_bio_extent_writepage+0xb3/0xe0 [btrfs]
[38575.850298]  [<c116897a>] bio_endio+0x1a/0x40
[38575.850317]  [<f8928277>] end_workqueue_fn+0x37/0x50 [btrfs]
[38575.850339]  [<f8963405>] worker_loop+0x105/0x400 [btrfs]
[38575.850362]  [<f8963300>] ? check_pending_worker_creates+0xc0/0xc0 [btrfs]
[38575.850369]  [<c105463c>] kthread+0x7c/0x90
[38575.850374]  [<c10545c0>] ? kthread_freezable_should_stop+0x60/0x60
[38575.850379]  [<c1585bbe>] kernel_thread_helper+0x6/0x10
[38575.850382] ---[ end trace 519c34cc6a228760 ]---
[38575.851598] btrfs: block rsv returned -28
[38575.851601] ------------[ cut here ]------------
[38575.851622] WARNING: at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:6219
use_block_rsv+0x16d/0x180 [btrfs]()
[38575.851625] Hardware name: KT600-8237
[38575.851627] Modules linked in: rfcomm bnep bluetooth parport_pc
ppdev nfsd nfs lockd binfmt_misc fscache auth_rpcgss nfs_acl sunrpc
dm_crypt usblp snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm
snd_page_alloc snd_mpu401_uart snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
soundcore serio_raw lm63 shpchp mac_hid hwmon_vid lm90 i2c_viapro lp
parport btrfs zlib_deflate libcrc32c radeon ttm via_rhine
drm_kms_helper drm i2c_algo_bit pata_via sata_via
[38575.851664] Pid: 574, comm: btrfs-endio-wri Tainted: G        W
3.4.0-030400rc6-generic #201205061835
[38575.851667] Call Trace:
[38575.851673]  [<c1035832>] warn_slowpath_common+0x72/0xa0
[38575.851781]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38575.851800]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38575.851805]  [<c1035882>] warn_slowpath_null+0x22/0x30
[38575.851823]  [<f891ab9d>] use_block_rsv+0x16d/0x180 [btrfs]
[38575.851842]  [<f891feac>] btrfs_alloc_free_block+0x3c/0x2b0 [btrfs]
[38575.851864]  [<f89441b6>] ? btrfs_token_item_offset+0x56/0xc0 [btrfs]
[38575.851887]  [<f8951a5b>] ? read_extent_buffer+0x9b/0xf0 [btrfs]
[38575.851911]  [<f890b388>] __btrfs_cow_block+0x148/0x560 [btrfs]
[38575.851929]  [<f890bead>] btrfs_cow_block+0xdd/0x220 [btrfs]
[38575.851947]  [<f890f929>] btrfs_search_slot+0x2c9/0x650 [btrfs]
[38575.851966]  [<f8922c35>] btrfs_lookup_file_extent+0x55/0x70 [btrfs]
[38575.851987]  [<f89402d7>] btrfs_drop_extents+0x117/0xb00 [btrfs]
[38575.851993]  [<c112aaf9>] ? kmem_cache_alloc+0x29/0x100
[38575.852039]  [<f8953dad>] ? alloc_extent_state+0x1d/0xb0 [btrfs]
[38575.852045]  [<c112ab74>] ? kmem_cache_alloc+0xa4/0x100
[38575.852067]  [<f8954ba3>] ? __set_extent_bit+0x323/0x670 [btrfs]
[38575.852084]  [<f890a0e7>] ? btrfs_alloc_path+0x17/0x20 [btrfs]
[38575.852105]  [<f893baa3>] T.1560+0x83/0x2b0 [btrfs]
[38575.852126]  [<f893c431>] btrfs_finish_ordered_io+0x3c1/0x480 [btrfs]
[38575.852148]  [<f893c534>] btrfs_writepage_end_io_hook+0x44/0xa0 [btrfs]
[38575.852152]  [<c157e59d>] ? _raw_spin_lock+0xd/0x10
[38575.852174]  [<f8955dd9>] end_extent_writepage+0x69/0x120 [btrfs]
[38575.852195]  [<f893c4f0>] ? btrfs_finish_ordered_io+0x480/0x480 [btrfs]
[38575.852218]  [<f8955f43>] end_bio_extent_writepage+0xb3/0xe0 [btrfs]
[38575.852222]  [<c116897a>] bio_endio+0x1a/0x40
[38575.852241]  [<f8928277>] end_workqueue_fn+0x37/0x50 [btrfs]
[38575.852263]  [<f8963405>] worker_loop+0x105/0x400 [btrfs]
[38575.852286]  [<f8963300>] ? check_pending_worker_creates+0xc0/0xc0 [btrfs]
[38575.852291]  [<c105463c>] kthread+0x7c/0x90
[38575.852295]  [<c10545c0>] ? kthread_freezable_should_stop+0x60/0x60
[38575.852299]  [<c1585bbe>] kernel_thread_helper+0x6/0x10
[38575.852302] ---[ end trace 519c34cc6a228761 ]---
[38612.107163] use_block_rsv: 8 callbacks suppressed
[38612.107169] btrfs: block rsv returned -28
[38612.107172] ------------[ cut here ]------------
[38612.107251] WARNING: at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:6219
use_block_rsv+0x16d/0x180 [btrfs]()
[38612.107255] Hardware name: KT600-8237
[38612.107257] Modules linked in: rfcomm bnep bluetooth parport_pc
ppdev nfsd nfs lockd binfmt_misc fscache auth_rpcgss nfs_acl sunrpc
dm_crypt usblp snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm
snd_page_alloc snd_mpu401_uart snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
soundcore serio_raw lm63 shpchp mac_hid hwmon_vid lm90 i2c_viapro lp
parport btrfs zlib_deflate libcrc32c radeon ttm via_rhine
drm_kms_helper drm i2c_algo_bit pata_via sata_via
[38612.107297] Pid: 2111, comm: btrfs-endio-wri Tainted: G        W
3.4.0-030400rc6-generic #201205061835
[38612.107300] Call Trace:
[38612.107316]  [<c1035832>] warn_slowpath_common+0x72/0xa0
[38612.107335]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38612.107353]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38612.107358]  [<c1035882>] warn_slowpath_null+0x22/0x30
[38612.107376]  [<f891ab9d>] use_block_rsv+0x16d/0x180 [btrfs]
[38612.107394]  [<f890d4a1>] ? btrfs_leaf_free_space+0x41/0x90 [btrfs]
[38612.107413]  [<f891feac>] btrfs_alloc_free_block+0x3c/0x2b0 [btrfs]
[38612.107431]  [<f890da62>] ? setup_items_for_insert+0x242/0x2d0 [btrfs]
[38612.107437]  [<c157e59d>] ? _raw_spin_lock+0xd/0x10
[38612.107454]  [<f8911724>] ? block_group_cache_tree_search+0x84/0x120 [btrfs]
[38612.107481]  [<f8951a5b>] ? read_extent_buffer+0x9b/0xf0 [btrfs]
[38612.107498]  [<f890b388>] __btrfs_cow_block+0x148/0x560 [btrfs]
[38612.107506]  [<c10f850b>] ? mark_page_accessed+0x3b/0x50
[38612.107524]  [<f890bead>] btrfs_cow_block+0xdd/0x220 [btrfs]
[38612.107542]  [<f890f929>] btrfs_search_slot+0x2c9/0x650 [btrfs]
[38612.107562]  [<f892339f>] btrfs_lookup_csum+0x6f/0x170 [btrfs]
[38612.107571]  [<c112ab74>] ? kmem_cache_alloc+0xa4/0x100
[38612.107593]  [<f8941688>] ? btrfs_mark_extent_written+0x828/0xaa0 [btrfs]
[38612.107681]  [<f890a0e7>] ? btrfs_alloc_path+0x17/0x20 [btrfs]
[38612.107702]  [<f8924286>] btrfs_csum_file_blocks+0xb6/0x670 [btrfs]
[38612.107725]  [<f8953ea7>] ? free_extent_state+0x47/0x90 [btrfs]
[38612.107748]  [<f8955884>] ? clear_extent_bit+0x124/0x500 [btrfs]
[38612.107770]  [<f89561d9>] ? unlock_extent_cached+0x49/0x60 [btrfs]
[38612.107791]  [<f8930a2d>] add_pending_csums+0x3d/0x60 [btrfs]
[38612.107812]  [<f893c344>] btrfs_finish_ordered_io+0x2d4/0x480 [btrfs]
[38612.107834]  [<f893c534>] btrfs_writepage_end_io_hook+0x44/0xa0 [btrfs]
[38612.107839]  [<c112a4b0>] ? kmem_cache_free+0xc0/0xd0
[38612.107847]  [<c10ef313>] ? mempool_free_slab+0x13/0x20
[38612.107851]  [<c10ef313>] ? mempool_free_slab+0x13/0x20
[38612.107874]  [<f8955dd9>] end_extent_writepage+0x69/0x120 [btrfs]
[38612.107895]  [<f893c4f0>] ? btrfs_finish_ordered_io+0x480/0x480 [btrfs]
[38612.107918]  [<f8955f43>] end_bio_extent_writepage+0xb3/0xe0 [btrfs]
[38612.107924]  [<c116897a>] bio_endio+0x1a/0x40
[38612.107943]  [<f8928277>] end_workqueue_fn+0x37/0x50 [btrfs]
[38612.107966]  [<f8963405>] worker_loop+0x105/0x400 [btrfs]
[38612.107989]  [<f8963300>] ? check_pending_worker_creates+0xc0/0xc0 [btrfs]
[38612.107996]  [<c105463c>] kthread+0x7c/0x90
[38612.108041]  [<c10545c0>] ? kthread_freezable_should_stop+0x60/0x60
[38612.108047]  [<c1585bbe>] kernel_thread_helper+0x6/0x10
[38612.108051] ---[ end trace 519c34cc6a228762 ]---
[38612.144494] btrfs: block rsv returned -28
[38612.144499] ------------[ cut here ]------------
[38612.144572] WARNING: at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:6219
use_block_rsv+0x16d/0x180 [btrfs]()
[38612.144576] Hardware name: KT600-8237
[38612.144578] Modules linked in: rfcomm bnep bluetooth parport_pc
ppdev nfsd nfs lockd binfmt_misc fscache auth_rpcgss nfs_acl sunrpc
dm_crypt usblp snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm
snd_page_alloc snd_mpu401_uart snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
soundcore serio_raw lm63 shpchp mac_hid hwmon_vid lm90 i2c_viapro lp
parport btrfs zlib_deflate libcrc32c radeon ttm via_rhine
drm_kms_helper drm i2c_algo_bit pata_via sata_via
[38612.144618] Pid: 2197, comm: btrfs-endio-wri Tainted: G        W
3.4.0-030400rc6-generic #201205061835
[38612.144621] Call Trace:
[38612.144636]  [<c1035832>] warn_slowpath_common+0x72/0xa0
[38612.144655]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38612.144673]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38612.144678]  [<c1035882>] warn_slowpath_null+0x22/0x30
[38612.144696]  [<f891ab9d>] use_block_rsv+0x16d/0x180 [btrfs]
[38612.144714]  [<f890d4a1>] ? btrfs_leaf_free_space+0x41/0x90 [btrfs]
[38612.144733]  [<f891feac>] btrfs_alloc_free_block+0x3c/0x2b0 [btrfs]
[38612.144751]  [<f890da62>] ? setup_items_for_insert+0x242/0x2d0 [btrfs]
[38612.144757]  [<c157e59d>] ? _raw_spin_lock+0xd/0x10
[38612.144774]  [<f890b388>] __btrfs_cow_block+0x148/0x560 [btrfs]
[38612.144792]  [<f890bead>] btrfs_cow_block+0xdd/0x220 [btrfs]
[38612.144810]  [<f890f929>] btrfs_search_slot+0x2c9/0x650 [btrfs]
[38612.144830]  [<f892339f>] btrfs_lookup_csum+0x6f/0x170 [btrfs]
[38612.144839]  [<c112ab74>] ? kmem_cache_alloc+0xa4/0x100
[38612.144863]  [<f8941688>] ? btrfs_mark_extent_written+0x828/0xaa0 [btrfs]
[38612.144880]  [<f890a0e7>] ? btrfs_alloc_path+0x17/0x20 [btrfs]
[38612.144900]  [<f8924286>] btrfs_csum_file_blocks+0xb6/0x670 [btrfs]
[38612.144923]  [<f8953ea7>] ? free_extent_state+0x47/0x90 [btrfs]
[38612.144945]  [<f8955884>] ? clear_extent_bit+0x124/0x500 [btrfs]
[38612.144968]  [<f89561d9>] ? unlock_extent_cached+0x49/0x60 [btrfs]
[38612.144989]  [<f8930a2d>] add_pending_csums+0x3d/0x60 [btrfs]
[38612.145010]  [<f893c344>] btrfs_finish_ordered_io+0x2d4/0x480 [btrfs]
[38612.145032]  [<f893c534>] btrfs_writepage_end_io_hook+0x44/0xa0 [btrfs]
[38612.145036]  [<c157e59d>] ? _raw_spin_lock+0xd/0x10
[38612.145058]  [<f8955dd9>] end_extent_writepage+0x69/0x120 [btrfs]
[38612.145080]  [<f893c4f0>] ? btrfs_finish_ordered_io+0x480/0x480 [btrfs]
[38612.145102]  [<f8955f43>] end_bio_extent_writepage+0xb3/0xe0 [btrfs]
[38612.145108]  [<c116897a>] bio_endio+0x1a/0x40
[38612.145128]  [<f8928277>] end_workqueue_fn+0x37/0x50 [btrfs]
[38612.145151]  [<f8963405>] worker_loop+0x105/0x400 [btrfs]
[38612.145174]  [<f8963300>] ? check_pending_worker_creates+0xc0/0xc0 [btrfs]
[38612.145181]  [<c105463c>] kthread+0x7c/0x90
[38612.145185]  [<c10545c0>] ? kthread_freezable_should_stop+0x60/0x60
[38612.145190]  [<c1585bbe>] kernel_thread_helper+0x6/0x10
[38612.145194] ---[ end trace 519c34cc6a228763 ]---
[38612.678492] btrfs: found 189 extents
[38619.633548] btrfs: found 189 extents
[38620.238583] btrfs: relocating block group 445699325952 flags 17
[38620.325525] use_block_rsv: 3 callbacks suppressed
[38620.325531] btrfs: block rsv returned -28
[38620.325534] ------------[ cut here ]------------
[38620.325607] WARNING: at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:6219
use_block_rsv+0x16d/0x180 [btrfs]()
[38620.325611] Hardware name: KT600-8237
[38620.325613] Modules linked in: rfcomm bnep bluetooth parport_pc
ppdev nfsd nfs lockd binfmt_misc fscache auth_rpcgss nfs_acl sunrpc
dm_crypt usblp snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm
snd_page_alloc snd_mpu401_uart snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
soundcore serio_raw lm63 shpchp mac_hid hwmon_vid lm90 i2c_viapro lp
parport btrfs zlib_deflate libcrc32c radeon ttm via_rhine
drm_kms_helper drm i2c_algo_bit pata_via sata_via
[38620.325653] Pid: 2111, comm: btrfs-endio-wri Tainted: G        W
3.4.0-030400rc6-generic #201205061835
[38620.325656] Call Trace:
[38620.325671]  [<c1035832>] warn_slowpath_common+0x72/0xa0
[38620.325690]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38620.325708]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38620.325713]  [<c1035882>] warn_slowpath_null+0x22/0x30
[38620.325732]  [<f891ab9d>] use_block_rsv+0x16d/0x180 [btrfs]
[38620.325751]  [<f891feac>] btrfs_alloc_free_block+0x3c/0x2b0 [btrfs]
[38620.325777]  [<f895154b>] ? map_private_extent_buffer+0x7b/0xe0 [btrfs]
[38620.325800]  [<f895154b>] ? map_private_extent_buffer+0x7b/0xe0 [btrfs]
[38620.325822]  [<f8951a5b>] ? read_extent_buffer+0x9b/0xf0 [btrfs]
[38620.325840]  [<f890b388>] __btrfs_cow_block+0x148/0x560 [btrfs]
[38620.325858]  [<f890bead>] btrfs_cow_block+0xdd/0x220 [btrfs]
[38620.325876]  [<f890f929>] btrfs_search_slot+0x2c9/0x650 [btrfs]
[38620.325896]  [<f892487b>] btrfs_lookup_inode+0x3b/0xb0 [btrfs]
[38620.325918]  [<f8933367>] btrfs_update_inode_item+0x57/0x100 [btrfs]
[38620.325939]  [<f89351b3>] btrfs_update_inode_fallback+0x43/0x50 [btrfs]
[38620.325960]  [<f893c375>] btrfs_finish_ordered_io+0x305/0x480 [btrfs]
[38620.325982]  [<f893c534>] btrfs_writepage_end_io_hook+0x44/0xa0 [btrfs]
[38620.325988]  [<c157e59d>] ? _raw_spin_lock+0xd/0x10
[38620.326011]  [<f8955dd9>] end_extent_writepage+0x69/0x120 [btrfs]
[38620.326032]  [<f893c4f0>] ? btrfs_finish_ordered_io+0x480/0x480 [btrfs]
[38620.326056]  [<f8955f43>] end_bio_extent_writepage+0xb3/0xe0 [btrfs]
[38620.326062]  [<c116897a>] bio_endio+0x1a/0x40
[38620.326081]  [<f8928277>] end_workqueue_fn+0x37/0x50 [btrfs]
[38620.326104]  [<f8963405>] worker_loop+0x105/0x400 [btrfs]
[38620.326127]  [<f8963300>] ? check_pending_worker_creates+0xc0/0xc0 [btrfs]
[38620.326135]  [<c105463c>] kthread+0x7c/0x90
[38620.326139]  [<c10545c0>] ? kthread_freezable_should_stop+0x60/0x60
[38620.326144]  [<c1585bbe>] kernel_thread_helper+0x6/0x10
[38620.326148] ---[ end trace 519c34cc6a228764 ]---
[38620.326557] btrfs: block rsv returned -28
[38620.326560] ------------[ cut here ]------------
[38620.326581] WARNING: at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:6219
use_block_rsv+0x16d/0x180 [btrfs]()
[38620.326585] Hardware name: KT600-8237
[38620.326586] Modules linked in: rfcomm bnep bluetooth parport_pc
ppdev nfsd nfs lockd binfmt_misc fscache auth_rpcgss nfs_acl sunrpc
dm_crypt usblp snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm
snd_page_alloc snd_mpu401_uart snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
soundcore serio_raw lm63 shpchp mac_hid hwmon_vid lm90 i2c_viapro lp
parport btrfs zlib_deflate libcrc32c radeon ttm via_rhine
drm_kms_helper drm i2c_algo_bit pata_via sata_via
[38620.326622] Pid: 2111, comm: btrfs-endio-wri Tainted: G        W
3.4.0-030400rc6-generic #201205061835
[38620.326625] Call Trace:
[38620.326631]  [<c1035832>] warn_slowpath_common+0x72/0xa0
[38620.326650]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38620.326668]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38620.326673]  [<c1035882>] warn_slowpath_null+0x22/0x30
[38620.326691]  [<f891ab9d>] use_block_rsv+0x16d/0x180 [btrfs]
[38620.326710]  [<f891feac>] btrfs_alloc_free_block+0x3c/0x2b0 [btrfs]
[38620.326734]  [<f89441b6>] ? btrfs_token_item_offset+0x56/0xc0 [btrfs]
[38620.326752]  [<f890b388>] __btrfs_cow_block+0x148/0x560 [btrfs]
[38620.326759]  [<c10f850b>] ? mark_page_accessed+0x3b/0x50
[38620.326776]  [<f890bead>] btrfs_cow_block+0xdd/0x220 [btrfs]
[38620.326794]  [<f890f929>] btrfs_search_slot+0x2c9/0x650 [btrfs]
[38620.326814]  [<f8922c35>] btrfs_lookup_file_extent+0x55/0x70 [btrfs]
[38620.326835]  [<f89402d7>] btrfs_drop_extents+0x117/0xb00 [btrfs]
[38620.326845]  [<c112aaf9>] ? kmem_cache_alloc+0x29/0x100
[38620.326867]  [<f8953dad>] ? alloc_extent_state+0x1d/0xb0 [btrfs]
[38620.326872]  [<c112ab74>] ? kmem_cache_alloc+0xa4/0x100
[38620.326895]  [<f8954ba3>] ? __set_extent_bit+0x323/0x670 [btrfs]
[38620.326912]  [<f890a0e7>] ? btrfs_alloc_path+0x17/0x20 [btrfs]
[38620.326933]  [<f893baa3>] T.1560+0x83/0x2b0 [btrfs]
[38620.326954]  [<f893c431>] btrfs_finish_ordered_io+0x3c1/0x480 [btrfs]
[38620.326976]  [<f893c534>] btrfs_writepage_end_io_hook+0x44/0xa0 [btrfs]
[38620.326980]  [<c157e59d>] ? _raw_spin_lock+0xd/0x10
[38620.327003]  [<f8955dd9>] end_extent_writepage+0x69/0x120 [btrfs]
[38620.327024]  [<f893c4f0>] ? btrfs_finish_ordered_io+0x480/0x480 [btrfs]
[38620.327047]  [<f8955f43>] end_bio_extent_writepage+0xb3/0xe0 [btrfs]
[38620.327051]  [<c116897a>] bio_endio+0x1a/0x40
[38620.327071]  [<f8928277>] end_workqueue_fn+0x37/0x50 [btrfs]
[38620.327092]  [<f8963405>] worker_loop+0x105/0x400 [btrfs]
[38620.327115]  [<f8963300>] ? check_pending_worker_creates+0xc0/0xc0 [btrfs]
[38620.327120]  [<c105463c>] kthread+0x7c/0x90
[38620.327124]  [<c10545c0>] ? kthread_freezable_should_stop+0x60/0x60
[38620.327129]  [<c1585bbe>] kernel_thread_helper+0x6/0x10
[38620.327131] ---[ end trace 519c34cc6a228765 ]---
[38643.277402] btrfs: found 266 extents
[38644.788650] use_block_rsv: 17 callbacks suppressed
[38644.788656] btrfs: block rsv returned -28
[38644.788658] ------------[ cut here ]------------
[38644.788731] WARNING: at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:6219
use_block_rsv+0x16d/0x180 [btrfs]()
[38644.788735] Hardware name: KT600-8237
[38644.788737] Modules linked in: rfcomm bnep bluetooth parport_pc
ppdev nfsd nfs lockd binfmt_misc fscache auth_rpcgss nfs_acl sunrpc
dm_crypt usblp snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm
snd_page_alloc snd_mpu401_uart snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
soundcore serio_raw lm63 shpchp mac_hid hwmon_vid lm90 i2c_viapro lp
parport btrfs zlib_deflate libcrc32c radeon ttm via_rhine
drm_kms_helper drm i2c_algo_bit pata_via sata_via
[38644.788776] Pid: 2197, comm: btrfs-endio-wri Tainted: G        W
3.4.0-030400rc6-generic #201205061835
[38644.788780] Call Trace:
[38644.788794]  [<c1035832>] warn_slowpath_common+0x72/0xa0
[38644.788813]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38644.788831]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38644.788836]  [<c1035882>] warn_slowpath_null+0x22/0x30
[38644.788854]  [<f891ab9d>] use_block_rsv+0x16d/0x180 [btrfs]
[38644.788874]  [<f891feac>] btrfs_alloc_free_block+0x3c/0x2b0 [btrfs]
[38644.788894]  [<f89276d4>] ? btree_set_page_dirty+0x34/0x50 [btrfs]
[38644.788900]  [<c10f4ae7>] ? set_page_dirty+0x37/0x60
[38644.788925]  [<f89522f9>] ? set_extent_buffer_dirty+0x89/0xc0 [btrfs]
[38644.788949]  [<f894a727>] ?
btrfs_set_token_extent_inline_ref_offset+0x57/0xe0 [btrfs]
[38644.788971]  [<f8951a5b>] ? read_extent_buffer+0x9b/0xf0 [btrfs]
[38644.788989]  [<f890b388>] __btrfs_cow_block+0x148/0x560 [btrfs]
[38644.789007]  [<f890bead>] btrfs_cow_block+0xdd/0x220 [btrfs]
[38644.789025]  [<f890f929>] btrfs_search_slot+0x2c9/0x650 [btrfs]
[38644.789045]  [<f8922c35>] btrfs_lookup_file_extent+0x55/0x70 [btrfs]
[38644.789066]  [<f89402d7>] btrfs_drop_extents+0x117/0xb00 [btrfs]
[38644.789076]  [<c112aaf9>] ? kmem_cache_alloc+0x29/0x100
[38644.789098]  [<f8953dad>] ? alloc_extent_state+0x1d/0xb0 [btrfs]
[38644.789103]  [<c112ab74>] ? kmem_cache_alloc+0xa4/0x100
[38644.789120]  [<f890a0e7>] ? btrfs_alloc_path+0x17/0x20 [btrfs]
[38644.789141]  [<f893baa3>] T.1560+0x83/0x2b0 [btrfs]
[38644.789163]  [<f893c431>] btrfs_finish_ordered_io+0x3c1/0x480 [btrfs]
[38644.789171]  [<c1054a90>] ? autoremove_wake_function+0x20/0x50
[38644.789192]  [<f893c534>] btrfs_writepage_end_io_hook+0x44/0xa0 [btrfs]
[38644.789200]  [<c105ced8>] ? __wake_up_common+0x48/0x70
[38644.789223]  [<f8955dd9>] end_extent_writepage+0x69/0x120 [btrfs]
[38644.789227]  [<c10549fe>] ? __wake_up_bit+0x2e/0x30
[38644.789248]  [<f893c4f0>] ? btrfs_finish_ordered_io+0x480/0x480 [btrfs]
[38644.789271]  [<f8955f43>] end_bio_extent_writepage+0xb3/0xe0 [btrfs]
[38644.789277]  [<c116897a>] bio_endio+0x1a/0x40
[38644.789296]  [<f8928277>] end_workqueue_fn+0x37/0x50 [btrfs]
[38644.789319]  [<f8963405>] worker_loop+0x105/0x400 [btrfs]
[38644.789342]  [<f8963300>] ? check_pending_worker_creates+0xc0/0xc0 [btrfs]
[38644.789346]  [<c105463c>] kthread+0x7c/0x90
[38644.789351]  [<c10545c0>] ? kthread_freezable_should_stop+0x60/0x60
[38644.789357]  [<c1585bbe>] kernel_thread_helper+0x6/0x10
[38644.789360] ---[ end trace 519c34cc6a228766 ]---
[38645.942943] btrfs: block rsv returned -28
[38645.942949] ------------[ cut here ]------------
[38645.943028] WARNING: at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:6219
use_block_rsv+0x16d/0x180 [btrfs]()
[38645.943032] Hardware name: KT600-8237
[38645.943034] Modules linked in: rfcomm bnep bluetooth parport_pc
ppdev nfsd nfs lockd binfmt_misc fscache auth_rpcgss nfs_acl sunrpc
dm_crypt usblp snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm
snd_page_alloc snd_mpu401_uart snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
soundcore serio_raw lm63 shpchp mac_hid hwmon_vid lm90 i2c_viapro lp
parport btrfs zlib_deflate libcrc32c radeon ttm via_rhine
drm_kms_helper drm i2c_algo_bit pata_via sata_via
[38645.943075] Pid: 2111, comm: btrfs-endio-wri Tainted: G        W
3.4.0-030400rc6-generic #201205061835
[38645.943078] Call Trace:
[38645.943093]  [<c1035832>] warn_slowpath_common+0x72/0xa0
[38645.943112]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38645.943130]  [<f891ab9d>] ? use_block_rsv+0x16d/0x180 [btrfs]
[38645.943135]  [<c1035882>] warn_slowpath_null+0x22/0x30
[38645.943154]  [<f891ab9d>] use_block_rsv+0x16d/0x180 [btrfs]
[38645.943174]  [<f891feac>] btrfs_alloc_free_block+0x3c/0x2b0 [btrfs]
[38645.943183]  [<c157db43>] ? io_schedule+0x93/0xc0
[38645.943188]  [<c157c2a2>] ? __wait_on_bit+0x62/0x70
[38645.943195]  [<c10ecea0>] ? __lock_page+0x90/0x90
[38645.943221]  [<f8951a5b>] ? read_extent_buffer+0x9b/0xf0 [btrfs]
[38645.943238]  [<f890b388>] __btrfs_cow_block+0x148/0x560 [btrfs]
[38645.943245]  [<c10f850b>] ? mark_page_accessed+0x3b/0x50
[38645.943263]  [<f890bead>] btrfs_cow_block+0xdd/0x220 [btrfs]
[38645.943281]  [<f890f929>] btrfs_search_slot+0x2c9/0x650 [btrfs]
[38645.943301]  [<f892339f>] btrfs_lookup_csum+0x6f/0x170 [btrfs]
[38645.943310]  [<c112ab74>] ? kmem_cache_alloc+0xa4/0x100
[38645.943327]  [<f890a0e7>] ? btrfs_alloc_path+0x17/0x20 [btrfs]
[38645.943347]  [<f8924286>] btrfs_csum_file_blocks+0xb6/0x670 [btrfs]
[38645.943370]  [<f8953ea7>] ? free_extent_state+0x47/0x90 [btrfs]
[38645.943393]  [<f8955884>] ? clear_extent_bit+0x124/0x500 [btrfs]
[38645.943416]  [<f89561d9>] ? unlock_extent_cached+0x49/0x60 [btrfs]
[38645.943436]  [<f8930a2d>] add_pending_csums+0x3d/0x60 [btrfs]
[38645.943458]  [<f893c344>] btrfs_finish_ordered_io+0x2d4/0x480 [btrfs]
[38645.943480]  [<f893c534>] btrfs_writepage_end_io_hook+0x44/0xa0 [btrfs]
[38645.943485]  [<c10ef313>] ? mempool_free_slab+0x13/0x20
[38645.943508]  [<f8955dd9>] end_extent_writepage+0x69/0x120 [btrfs]
[38645.943529]  [<f893c4f0>] ? btrfs_finish_ordered_io+0x480/0x480 [btrfs]
[38645.943552]  [<f8955f43>] end_bio_extent_writepage+0xb3/0xe0 [btrfs]
[38645.943558]  [<c116897a>] bio_endio+0x1a/0x40
[38645.943578]  [<f8928277>] end_workqueue_fn+0x37/0x50 [btrfs]
[38645.943600]  [<f8963405>] worker_loop+0x105/0x400 [btrfs]
[38645.943623]  [<f8963300>] ? check_pending_worker_creates+0xc0/0xc0 [btrfs]
[38645.943631]  [<c105463c>] kthread+0x7c/0x90
[38645.943635]  [<c10545c0>] ? kthread_freezable_should_stop+0x60/0x60
[38645.943640]  [<c1585bbe>] kernel_thread_helper+0x6/0x10
[38645.943644] ---[ end trace 519c34cc6a228767 ]---
[38655.940334] btrfs: found 266 extents
[38656.256212] btrfs: relocating block group 444625584128 flags 17
[38656.319608] ------------[ cut here ]------------
[38656.319689] WARNING: at /home/apw/COD/linux/fs/btrfs/super.c:219
__btrfs_abort_transaction+0x99/0xb0 [btrfs]()
[38656.319693] Hardware name: KT600-8237
[38656.319695] btrfs: Transaction aborted
[38656.319698] Modules linked in: rfcomm bnep bluetooth parport_pc
ppdev nfsd nfs lockd binfmt_misc fscache auth_rpcgss nfs_acl sunrpc
dm_crypt usblp snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm
snd_page_alloc snd_mpu401_uart snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
soundcore serio_raw lm63 shpchp mac_hid hwmon_vid lm90 i2c_viapro lp
parport btrfs zlib_deflate libcrc32c radeon ttm via_rhine
drm_kms_helper drm i2c_algo_bit pata_via sata_via
[38656.319738] Pid: 22814, comm: btrfs Tainted: G        W
3.4.0-030400rc6-generic #201205061835
[38656.319741] Call Trace:
[38656.319756]  [<c1035832>] warn_slowpath_common+0x72/0xa0
[38656.319773]  [<f89074f9>] ? __btrfs_abort_transaction+0x99/0xb0 [btrfs]
[38656.319790]  [<f89074f9>] ? __btrfs_abort_transaction+0x99/0xb0 [btrfs]
[38656.319796]  [<c1035903>] warn_slowpath_fmt+0x33/0x40
[38656.319813]  [<f89074f9>] __btrfs_abort_transaction+0x99/0xb0 [btrfs]
[38656.319841]  [<f8933d23>] cow_file_range_inline+0x2b3/0x2c0 [btrfs]
[38656.319862]  [<f89340ef>] cow_file_range+0x3bf/0x640 [btrfs]
[38656.319887]  [<f895325b>] ? free_extent_buffer+0x2b/0x60 [btrfs]
[38656.319909]  [<f8938b1f>] run_delalloc_nocow+0x24f/0x980 [btrfs]
[38656.319931]  [<f893931b>] run_delalloc_range+0xcb/0x120 [btrfs]
[38656.319953]  [<f895926f>] __extent_writepage+0x4bf/0x920 [btrfs]
[38656.319976]  [<f8955e90>] ? end_extent_writepage+0x120/0x120 [btrfs]
[38656.319984]  [<c10f7e4c>] ? release_pages+0x15c/0x1a0
[38656.319991]  [<c10ec9a9>] ? find_get_pages_tag+0xb9/0x150
[38656.320013]  [<f8959add>] T.1400+0x22d/0x2e0 [btrfs]
[38656.320082]  [<f895203f>] ? submit_one_bio+0x9f/0xc0 [btrfs]
[38656.320104]  [<f8930eb0>] ? btrfs_readpage_end_io_hook+0x2a0/0x2a0 [btrfs]
[38656.320126]  [<f8959bd7>] extent_writepages+0x47/0x60 [btrfs]
[38656.320147]  [<f8939920>] ? btrfs_real_readdir+0x5b0/0x5b0 [btrfs]
[38656.320168]  [<f8932495>] btrfs_writepages+0x25/0x30 [btrfs]
[38656.320173]  [<c10f5bec>] do_writepages+0x1c/0x40
[38656.320177]  [<c10ed6ad>] __filemap_fdatawrite_range+0x5d/0x70
[38656.320182]  [<c10ed99b>] filemap_flush+0x2b/0x30
[38656.320202]  [<f892fe99>] btrfs_start_delalloc_inodes+0xc9/0x1e0 [btrfs]
[38656.320230]  [<f89808d0>] btrfs_relocate_block_group+0x160/0x2c0 [btrfs]
[38656.320253]  [<f895cd31>] btrfs_relocate_chunk+0x71/0x3b0 [btrfs]
[38656.320276]  [<f895325b>] ? free_extent_buffer+0x2b/0x60 [btrfs]
[38656.320299]  [<f895de89>] __btrfs_balance+0x369/0x430 [btrfs]
[38656.320322]  [<f895ee95>] btrfs_balance+0x495/0x610 [btrfs]
[38656.320331]  [<c112b09f>] ? __kmalloc+0x12f/0x1c0
[38656.320353]  [<f8966ac1>] btrfs_ioctl_balance+0xe1/0x1e0 [btrfs]
[38656.320376]  [<f8969315>] btrfs_ioctl+0xa5/0x760 [btrfs]
[38656.320399]  [<f8969270>] ? btrfs_ioctl_balance_progress+0xd0/0xd0 [btrfs]
[38656.320405]  [<c114b5c6>] do_vfs_ioctl+0x86/0x2d0
[38656.320409]  [<c114b887>] sys_ioctl+0x77/0x80
[38656.320415]  [<c158561f>] sysenter_do_call+0x12/0x28
[38656.320419] ---[ end trace 519c34cc6a228768 ]---
[38656.320424] BTRFS error (device sda6) in cow_file_range_inline:261: error 28
[38656.320427] btrfs is forced readonly
[38656.322417] BTRFS error (device sda6) in cow_file_range:871: error 28
[38656.322432] BTRFS error (device sda6) in run_delalloc_nocow:1333: error 28
