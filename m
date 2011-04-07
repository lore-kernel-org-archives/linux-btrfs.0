From: Jeff Wu <cpwu@tnsoft.com.cn>
Subject: 2.6.39-rc1: btrfs "WARNING: at fs/btrfs/inode.c:2177"
Date: Thu, 7 Apr 2011 17:41:26 +0800
Message-ID: <1302169286.1922.19.camel@cephhost>
Reply-To: <cpwu@tnsoft.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: <linux-btrfs@vger.kernel.org>
To: ceph-devel <ceph-devel@vger.kernel.org>
Return-path: <ceph-devel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Hi , 
I run iozone stress test on a ceph client for x86_64, ceph 0.26 +
linux-2.6.39-rc1 server,
printk "WARNING: at fs/btrfs/inode.c:2177"

1.log1 :

...........................................................
[ 1663.370008] CE: hpet2 increased min_delta_ns to 7500 nsec
[ 1663.375399] CE: hpet2 increased min_delta_ns to 11250 nsec
[ 4945.270388] ------------[ cut here ]------------
[ 4945.275011] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[ 4945.283326] Hardware name: OptiPlex 780                 
[ 4945.288629] Modules linked in: i915 fbcon tileblit font
snd_hda_codec_analog bitblit btrfs softcursor drm_kms_helper drm
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd zlib_deflate
psmouse crc32c i2c_algo_bit soundcore snd_page_alloc libcrc32c ppdev
intel_agp parport_pc lp intel_gtt dell_wmi video parport serio_raw
sparse_keymap dcdbas r8169 mii
[ 4945.320862] Pid: 581, comm: btrfs-transacti Not tainted 2.6.39-rc1 #1
[ 4945.327282] Call Trace:
[ 4945.329722]  [<ffffffff8105f13f>] warn_slowpath_common+0x7f/0xc0
[ 4945.335755]  [<ffffffff8105f19a>] warn_slowpath_null+0x1a/0x20
[ 4945.341602]  [<ffffffffa01b2ae0>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[ 4945.348636]  [<ffffffffa01adfd1>] commit_fs_roots+0xa1/0x140 [btrfs]
[ 4945.355017]  [<ffffffffa01aeef9>] btrfs_commit_transaction
+0x349/0x750 [btrfs]
[ 4945.362259]  [<ffffffff81081810>] ? wake_up_bit+0x40/0x40
[ 4945.367649]  [<ffffffffa01a8593>] transaction_kthread+0x283/0x290
[btrfs]
[ 4945.374460]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 4945.381269]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 4945.388080]  [<ffffffff810812d6>] kthread+0x96/0xa0
[ 4945.392989]  [<ffffffff815a6364>] kernel_thread_helper+0x4/0x10
[ 4945.398895]  [<ffffffff81081240>] ? __init_kthread_worker+0x40/0x40
[ 4945.405183]  [<ffffffff815a6360>] ? gs_change+0x13/0x13
[ 4945.410409] ---[ end trace 87e42fb6fdfeba78 ]---
[ 5159.980447] ------------[ cut here ]------------
[ 5159.985072] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[ 5159.993353] Hardware name: OptiPlex 780                 
[ 5159.998648] Modules linked in: i915 fbcon tileblit font
snd_hda_codec_analog bitblit btrfs softcursor drm_kms_helper drm
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd zlib_deflate
psmouse crc32c i2c_algo_bit soundcore snd_page_alloc libcrc32c ppdev
intel_agp parport_pc lp intel_gtt dell_wmi video parport serio_raw
sparse_keymap dcdbas r8169 mii
[ 5160.033593] Pid: 581, comm: btrfs-transacti Tainted: G        W
2.6.39-rc1 #1
[ 5160.041904] Call Trace:
[ 5160.045326]  [<ffffffff8105f13f>] warn_slowpath_common+0x7f/0xc0
[ 5160.052312]  [<ffffffff8105f19a>] warn_slowpath_null+0x1a/0x20
[ 5160.059102]  [<ffffffffa01b2ae0>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[ 5160.067143]  [<ffffffffa01adfd1>] commit_fs_roots+0xa1/0x140 [btrfs]
[ 5160.074485]  [<ffffffffa01aeef9>] btrfs_commit_transaction
+0x349/0x750 [btrfs]
[ 5160.082687]  [<ffffffff81081810>] ? wake_up_bit+0x40/0x40
[ 5160.089034]  [<ffffffffa01a8593>] transaction_kthread+0x283/0x290
[btrfs]
[ 5160.096811]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5160.104568]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5160.112294]  [<ffffffff810812d6>] kthread+0x96/0xa0
[ 5160.118093]  [<ffffffff815a6364>] kernel_thread_helper+0x4/0x10
[ 5160.124964]  [<ffffffff81081240>] ? __init_kthread_worker+0x40/0x40
[ 5160.132166]  [<ffffffff815a6360>] ? gs_change+0x13/0x13
[ 5160.138292] ---[ end trace 87e42fb6fdfeba79 ]---
[ 5434.340486] ------------[ cut here ]------------
[ 5434.346091] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[ 5434.355303] Hardware name: OptiPlex 780                 
[ 5434.361640] Modules linked in: i915 fbcon tileblit font
snd_hda_codec_analog bitblit btrfs softcursor drm_kms_helper drm
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd zlib_deflate
psmouse crc32c i2c_algo_bit soundcore snd_page_alloc libcrc32c ppdev
intel_agp parport_pc lp intel_gtt dell_wmi video parport serio_raw
sparse_keymap dcdbas r8169 mii
[ 5434.396772] Pid: 581, comm: btrfs-transacti Tainted: G        W
2.6.39-rc1 #1
[ 5434.405087] Call Trace:
[ 5434.408546]  [<ffffffff8105f13f>] warn_slowpath_common+0x7f/0xc0
[ 5434.415523]  [<ffffffff8105f19a>] warn_slowpath_null+0x1a/0x20
[ 5434.422300]  [<ffffffffa01b2ae0>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[ 5434.430290]  [<ffffffffa01adfd1>] commit_fs_roots+0xa1/0x140 [btrfs]
[ 5434.437562]  [<ffffffffa01aeef9>] btrfs_commit_transaction
+0x349/0x750 [btrfs]
[ 5434.445738]  [<ffffffff81081810>] ? wake_up_bit+0x40/0x40
[ 5434.452087]  [<ffffffffa01a8593>] transaction_kthread+0x283/0x290
[btrfs]
[ 5434.459792]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5434.467542]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5434.475291]  [<ffffffff810812d6>] kthread+0x96/0xa0
[ 5434.481082]  [<ffffffff815a6364>] kernel_thread_helper+0x4/0x10
[ 5434.487949]  [<ffffffff81081240>] ? __init_kthread_worker+0x40/0x40
[ 5434.495160]  [<ffffffff815a6360>] ? gs_change+0x13/0x13
[ 5434.501314] ---[ end trace 87e42fb6fdfeba7a ]---
[ 5525.450514] ------------[ cut here ]------------
[ 5525.456066] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[ 5525.465286] Hardware name: OptiPlex 780                 
[ 5525.471543] Modules linked in: i915 fbcon tileblit font
snd_hda_codec_analog bitblit btrfs softcursor drm_kms_helper drm
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd zlib_deflate
psmouse crc32c i2c_algo_bit soundcore snd_page_alloc libcrc32c ppdev
intel_agp parport_pc lp intel_gtt dell_wmi video parport serio_raw
sparse_keymap dcdbas r8169 mii
[ 5525.506568] Pid: 581, comm: btrfs-transacti Tainted: G        W
2.6.39-rc1 #1
[ 5525.514879] Call Trace:
[ 5525.518281]  [<ffffffff8105f13f>] warn_slowpath_common+0x7f/0xc0
[ 5525.525251]  [<ffffffff8105f19a>] warn_slowpath_null+0x1a/0x20
[ 5525.532037]  [<ffffffffa01b2ae0>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[ 5525.540022]  [<ffffffffa01adfd1>] commit_fs_roots+0xa1/0x140 [btrfs]
[ 5525.547277]  [<ffffffffa01aeef9>] btrfs_commit_transaction
+0x349/0x750 [btrfs]
[ 5525.555448]  [<ffffffff81081810>] ? wake_up_bit+0x40/0x40
[ 5525.561794]  [<ffffffffa01a8593>] transaction_kthread+0x283/0x290
[btrfs]
[ 5525.569502]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5525.577240]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5525.584937]  [<ffffffff810812d6>] kthread+0x96/0xa0
[ 5525.590737]  [<ffffffff815a6364>] kernel_thread_helper+0x4/0x10
[ 5525.597541]  [<ffffffff81081240>] ? __init_kthread_worker+0x40/0x40
[ 5525.604742]  [<ffffffff815a6360>] ? gs_change+0x13/0x13
[ 5525.610890] ---[ end trace 87e42fb6fdfeba7b ]---
[ 5525.616529] ------------[ cut here ]------------
[ 5525.622090] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[ 5525.631338] Hardware name: OptiPlex 780                 
[ 5525.637564] Modules linked in: i915 fbcon tileblit font
snd_hda_codec_analog bitblit btrfs softcursor drm_kms_helper drm
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd zlib_deflate
psmouse crc32c i2c_algo_bit soundcore snd_page_alloc libcrc32c ppdev
intel_agp parport_pc lp intel_gtt dell_wmi video parport serio_raw
sparse_keymap dcdbas r8169 mii
[ 5525.672639] Pid: 581, comm: btrfs-transacti Tainted: G        W
2.6.39-rc1 #1
[ 5525.680962] Call Trace:
[ 5525.684372]  [<ffffffff8105f13f>] warn_slowpath_common+0x7f/0xc0
[ 5525.691350]  [<ffffffff8105f19a>] warn_slowpath_null+0x1a/0x20
[ 5525.698109]  [<ffffffffa01b2ae0>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[ 5525.706118]  [<ffffffffa01adfd1>] commit_fs_roots+0xa1/0x140 [btrfs]
[ 5525.713891]  [<ffffffffa01aeef9>] btrfs_commit_transaction
+0x349/0x750 [btrfs]
[ 5525.722184]  [<ffffffff81081810>] ? wake_up_bit+0x40/0x40
[ 5525.728576]  [<ffffffffa01a8593>] transaction_kthread+0x283/0x290
[btrfs]
[ 5525.736388]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5525.744113]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5525.751814]  [<ffffffff810812d6>] kthread+0x96/0xa0
[ 5525.757584]  [<ffffffff815a6364>] kernel_thread_helper+0x4/0x10
[ 5525.764431]  [<ffffffff81081240>] ? __init_kthread_worker+0x40/0x40
[ 5525.771625]  [<ffffffff815a6360>] ? gs_change+0x13/0x13
[ 5525.777748] ---[ end trace 87e42fb6fdfeba7c ]---
[ 5586.710386] ------------[ cut here ]------------
[ 5586.715937] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[ 5586.725153] Hardware name: OptiPlex 780                 
[ 5586.731407] Modules linked in: i915 fbcon tileblit font
snd_hda_codec_analog bitblit btrfs softcursor drm_kms_helper drm
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd zlib_deflate
psmouse crc32c i2c_algo_bit soundcore snd_page_alloc libcrc32c ppdev
intel_agp parport_pc lp intel_gtt dell_wmi video parport serio_raw
sparse_keymap dcdbas r8169 mii
[ 5586.766448] Pid: 581, comm: btrfs-transacti Tainted: G        W
2.6.39-rc1 #1
[ 5586.774812] Call Trace:
[ 5586.778228]  [<ffffffff8105f13f>] warn_slowpath_common+0x7f/0xc0
[ 5586.785203]  [<ffffffff8105f19a>] warn_slowpath_null+0x1a/0x20
[ 5586.791974]  [<ffffffffa01b2ae0>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[ 5586.799921]  [<ffffffffa01adfd1>] commit_fs_roots+0xa1/0x140 [btrfs]
[ 5586.807285]  [<ffffffffa01aeef9>] btrfs_commit_transaction
+0x349/0x750 [btrfs]
[ 5586.815511]  [<ffffffff81081810>] ? wake_up_bit+0x40/0x40
[ 5586.821875]  [<ffffffffa01a8593>] transaction_kthread+0x283/0x290
[btrfs]
[ 5586.829578]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5586.837318]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5586.845025]  [<ffffffff810812d6>] kthread+0x96/0xa0
[ 5586.850839]  [<ffffffff815a6364>] kernel_thread_helper+0x4/0x10
[ 5586.857641]  [<ffffffff81081240>] ? __init_kthread_worker+0x40/0x40
[ 5586.864856]  [<ffffffff815a6360>] ? gs_change+0x13/0x13
[ 5586.871013] ---[ end trace 87e42fb6fdfeba7d ]---
[ 5617.300421] ------------[ cut here ]------------
[ 5617.306012] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[ 5617.315227] Hardware name: OptiPlex 780                 
[ 5617.321585] Modules linked in: i915 fbcon tileblit font
snd_hda_codec_analog bitblit btrfs softcursor drm_kms_helper drm
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd zlib_deflate
psmouse crc32c i2c_algo_bit soundcore snd_page_alloc libcrc32c ppdev
intel_agp parport_pc lp intel_gtt dell_wmi video parport serio_raw
sparse_keymap dcdbas r8169 mii
[ 5617.356848] Pid: 581, comm: btrfs-transacti Tainted: G        W
2.6.39-rc1 #1
[ 5617.365158] Call Trace:
[ 5617.368567]  [<ffffffff8105f13f>] warn_slowpath_common+0x7f/0xc0
[ 5617.375756]  [<ffffffff8105f19a>] warn_slowpath_null+0x1a/0x20
[ 5617.382535]  [<ffffffffa01b2ae0>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[ 5617.390519]  [<ffffffffa01adfd1>] commit_fs_roots+0xa1/0x140 [btrfs]
[ 5617.397774]  [<ffffffffa01aeef9>] btrfs_commit_transaction
+0x349/0x750 [btrfs]
[ 5617.405957]  [<ffffffff81081810>] ? wake_up_bit+0x40/0x40
[ 5617.412291]  [<ffffffffa01a8593>] transaction_kthread+0x283/0x290
[btrfs]
[ 5617.420156]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5617.427930]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5617.435720]  [<ffffffff810812d6>] kthread+0x96/0xa0
[ 5617.441578]  [<ffffffff815a6364>] kernel_thread_helper+0x4/0x10
[ 5617.448432]  [<ffffffff81081240>] ? __init_kthread_worker+0x40/0x40
[ 5617.455691]  [<ffffffff815a6360>] ? gs_change+0x13/0x13
[ 5617.461847] ---[ end trace 87e42fb6fdfeba7e ]---
[ 5678.310579] ------------[ cut here ]------------
[ 5678.316119] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[ 5678.325325] Hardware name: OptiPlex 780                 
[ 5678.331580] Modules linked in: i915 fbcon tileblit font
snd_hda_codec_analog bitblit btrfs softcursor drm_kms_helper drm
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd zlib_deflate
psmouse crc32c i2c_algo_bit soundcore snd_page_alloc libcrc32c ppdev
intel_agp parport_pc lp intel_gtt dell_wmi video parport serio_raw
sparse_keymap dcdbas r8169 mii
[ 5678.366629] Pid: 581, comm: btrfs-transacti Tainted: G        W
2.6.39-rc1 #1
[ 5678.374945] Call Trace:
[ 5678.378350]  [<ffffffff8105f13f>] warn_slowpath_common+0x7f/0xc0
[ 5678.385319]  [<ffffffff8105f19a>] warn_slowpath_null+0x1a/0x20
[ 5678.392107]  [<ffffffffa01b2ae0>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[ 5678.400095]  [<ffffffffa01adfd1>] commit_fs_roots+0xa1/0x140 [btrfs]
[ 5678.407357]  [<ffffffffa01aeef9>] btrfs_commit_transaction
+0x349/0x750 [btrfs]
[ 5678.415611]  [<ffffffff81081810>] ? wake_up_bit+0x40/0x40
[ 5678.422001]  [<ffffffffa01a8593>] transaction_kthread+0x283/0x290
[btrfs]
[ 5678.429753]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5678.437559]  [<ffffffffa01a8310>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 5678.445286]  [<ffffffff810812d6>] kthread+0x96/0xa0
[ 5678.451078]  [<ffffffff815a6364>] kernel_thread_helper+0x4/0x10
[ 5678.457889]  [<ffffffff81081240>] ? __init_kthread_worker+0x40/0x40
[ 5678.465112]  [<ffffffff815a6360>] ? gs_change+0x13/0x13
[ 5678.471264] ---[ end trace 87e42fb6fdfeba

2 log2 

..........................................................
[   60.920012] CE: hpet5 increased min_delta_ns to 11250 nsec
[   60.920016] hrtimer: interrupt took 4156 ns
[  883.170006] CE: hpet4 increased min_delta_ns to 7500 nsec
[  883.170013] CE: hpet4 increased min_delta_ns to 11250 nsec
[ 2118.980008] CE: hpet3 increased min_delta_ns to 7500 nsec
[ 2118.980016] CE: hpet3 increased min_delta_ns to 11250 nsec
[ 6794.650771] 
[ 6794.650774] =============================================
[ 6794.657667] [ INFO: possible recursive locking detected ]
[ 6794.660144] 2.6.39-rc1 #1
[ 6794.660144] ---------------------------------------------
[ 6794.660144] cosd/2100 is trying to acquire lock:
[ 6794.660144]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa029f5c9>]
btrfs_try_spin_lock+0x59/0x100 [btrfs]
[ 6794.660144] 
[ 6794.660144] but task is already holding lock:
[ 6794.660144]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa029f692>]
btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
[ 6794.660144] 
[ 6794.660144] other info that might help us debug this:
[ 6794.660144] 2 locks held by cosd/2100:
[ 6794.660144]  #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at:
[<ffffffffa027af82>] btrfs_file_aio_write+0xe2/0x4e0 [btrfs]
[ 6794.660144]  #1:  (&(&eb->lock)->rlock){+.+...}, at:
[<ffffffffa029f692>] btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
[ 6794.660144] 
[ 6794.660144] stack backtrace:
[ 6794.660144] Pid: 2100, comm: cosd Not tainted 2.6.39-rc1 #1
[ 6794.660144] Call Trace:
[ 6794.660144]  [<ffffffff8109b224>] __lock_acquire+0x1154/0x14b0
[ 6794.660144]  [<ffffffff8109b620>] lock_acquire+0xa0/0x150
[ 6794.660144]  [<ffffffffa029f5c9>] ? btrfs_try_spin_lock+0x59/0x100
[btrfs]
[ 6794.660144]  [<ffffffff815ac341>] _raw_spin_lock+0x31/0x40
[ 6794.660144]  [<ffffffffa029f5c9>] ? btrfs_try_spin_lock+0x59/0x100
[btrfs]
[ 6794.660144]  [<ffffffffa029f692>] ? btrfs_clear_lock_blocking
+0x22/0x30 [btrfs]
[ 6794.660144]  [<ffffffffa029f5c9>] btrfs_try_spin_lock+0x59/0x100
[btrfs]
[ 6794.660144]  [<ffffffffa0250e72>] btrfs_search_slot+0x7d2/0x850
[btrfs]
[ 6794.660144]  [<ffffffffa02618bf>] btrfs_lookup_xattr+0x8f/0x120
[btrfs]
[ 6794.660144]  [<ffffffff8114e525>] ? kmem_cache_alloc+0xe5/0x140
[ 6794.660144]  [<ffffffffa0288d23>] __btrfs_getxattr+0x73/0x130 [btrfs]
[ 6794.660144]  [<ffffffffa0288e5d>] btrfs_getxattr+0x7d/0x80 [btrfs]
[ 6794.660144]  [<ffffffff812769ed>] cap_inode_need_killpriv+0x2d/0x40
[ 6794.660144]  [<ffffffff81277e26>] security_inode_need_killpriv
+0x16/0x20
[ 6794.660144]  [<ffffffff81103a2c>] file_remove_suid+0x2c/0x90
[ 6794.660144]  [<ffffffff815ab1b3>] ? mutex_lock_nested+0x43/0x50
[ 6794.660144]  [<ffffffffa027b038>] btrfs_file_aio_write+0x198/0x4e0
[btrfs]
[ 6794.660144]  [<ffffffffa027aea0>] ? __btrfs_buffered_write
+0x310/0x310 [btrfs]
[ 6794.660144]  [<ffffffff8115bc93>] do_sync_readv_writev+0xd3/0x110
[ 6794.660144]  [<ffffffff812ad9d8>] ? apparmor_file_permission
+0x18/0x20
[ 6794.660144]  [<ffffffff81279473>] ? security_file_permission
+0x23/0x90
[ 6794.660144]  [<ffffffff8115cb04>] do_readv_writev+0xd4/0x1e0
[ 6794.660144]  [<ffffffff8115d230>] ? fget_light+0x40/0x130
[ 6794.660144]  [<ffffffff81099dfd>] ? trace_hardirqs_on+0xd/0x10
[ 6794.660144]  [<ffffffff8115cc58>] vfs_writev+0x48/0x60
[ 6794.660144]  [<ffffffff8115cd91>] sys_writev+0x51/0xc0
[ 6794.660144]  [<ffffffff815b4d02>] system_call_fastpath+0x16/0x1b
[ 6823.410755] ------------[ cut here ]------------
[ 6823.416129] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[ 6823.425136] Hardware name: OptiPlex 780                 
[ 6823.431205] Modules linked in: btrfs i915 snd_hda_codec_analog fbcon
zlib_deflate tileblit crc32c font bitblit libcrc32c softcursor
drm_kms_helper drm snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_timer snd psmouse intel_agp i2c_algo_bit lp ppdev soundcore
parport_pc snd_page_alloc intel_gtt dell_wmi parport video serio_raw
sparse_keymap r8169 ata_piix mii
[ 6823.465884] Pid: 580, comm: btrfs-transacti Not tainted 2.6.39-rc1 #1
[ 6823.473170] Call Trace:
[ 6823.476439]  [<ffffffff8105fe9f>] warn_slowpath_common+0x7f/0xc0
[ 6823.483268]  [<ffffffff8105fefa>] warn_slowpath_null+0x1a/0x20
[ 6823.489917]  [<ffffffffa026fc20>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[ 6823.497790]  [<ffffffffa026b0b9>] commit_fs_roots+0xa9/0x150 [btrfs]
[ 6823.504951]  [<ffffffffa026c00b>] btrfs_commit_transaction
+0x34b/0x750 [btrfs]
[ 6823.512976]  [<ffffffff810837e0>] ? wake_up_bit+0x40/0x40
[ 6823.519176]  [<ffffffffa02655c3>] transaction_kthread+0x283/0x290
[btrfs]
[ 6823.526763]  [<ffffffffa0265340>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 6823.534354]  [<ffffffff81083276>] kthread+0xb6/0xc0
[ 6823.539996]  [<ffffffff81099dad>] ? trace_hardirqs_on_caller
+0x13d/0x180
[ 6823.547482]  [<ffffffff815b5ea4>] kernel_thread_helper+0x4/0x10
[ 6823.554183]  [<ffffffff815acf14>] ? retint_restore_args+0x13/0x13
[ 6823.561046]  [<ffffffff810831c0>] ? __init_kthread_worker+0x70/0x70
[ 6823.568085]  [<ffffffff815b5ea0>] ? gs_change+0x13/0x13
[ 6823.574077] ---[ end trace 98f2cdf99cfce110 ]---
[16334.260703] ------------[ cut here ]------------
[16334.266098] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[16334.275143] Hardware name: OptiPlex 780                 
[16334.281245] Modules linked in: btrfs i915 snd_hda_codec_analog fbcon
zlib_deflate tileblit crc32c font bitblit libcrc32c softcursor
drm_kms_helper drm snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_timer snd psmouse intel_agp i2c_algo_bit lp ppdev soundcore
parport_pc snd_page_alloc intel_gtt dell_wmi parport video serio_raw
sparse_keymap r8169 ata_piix mii
[16334.316186] Pid: 580, comm: btrfs-transacti Tainted: G        W
2.6.39-rc1 #1
[16334.324378] Call Trace:
[16334.327715]  [<ffffffff8105fe9f>] warn_slowpath_common+0x7f/0xc0
[16334.334668]  [<ffffffff8105fefa>] warn_slowpath_null+0x1a/0x20
[16334.341452]  [<ffffffffa026fc20>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[16334.349448]  [<ffffffffa026b0b9>] commit_fs_roots+0xa9/0x150 [btrfs]
[16334.356754]  [<ffffffffa026c00b>] btrfs_commit_transaction
+0x34b/0x750 [btrfs]
[16334.364934]  [<ffffffff810837e0>] ? wake_up_bit+0x40/0x40
[16334.371300]  [<ffffffffa02655c3>] transaction_kthread+0x283/0x290
[btrfs]
[16334.379046]  [<ffffffffa0265340>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[16334.386796]  [<ffffffff81083276>] kthread+0xb6/0xc0
[16334.392625]  [<ffffffff81099dad>] ? trace_hardirqs_on_caller
+0x13d/0x180
[16334.400305]  [<ffffffff815b5ea4>] kernel_thread_helper+0x4/0x10
[16334.407185]  [<ffffffff815acf14>] ? retint_restore_args+0x13/0x13
[16334.414251]  [<ffffffff810831c0>] ? __init_kthread_worker+0x70/0x70
[16334.421486]  [<ffffffff815b5ea0>] ? gs_change+0x13/0x13
[16334.427681] ---[ end trace 98f2cdf99cfce111 ]---
[16895.139537] btrfs: unlinked 27 orphans
[20373.435695] btrfs: unlinked 1 orphans
[23764.970722] ------------[ cut here ]------------
[23764.976339] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[23764.985578] Hardware name: OptiPlex 780                 
[23764.991863] Modules linked in: btrfs i915 snd_hda_codec_analog fbcon
zlib_deflate tileblit crc32c font bitblit libcrc32c softcursor
drm_kms_helper drm snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_timer snd psmouse intel_agp i2c_algo_bit lp ppdev soundcore
parport_pc snd_page_alloc intel_gtt dell_wmi parport video serio_raw
sparse_keymap r8169 ata_piix mii
[23765.027372] Pid: 580, comm: btrfs-transacti Tainted: G        W
2.6.39-rc1 #1
[23765.035693] Call Trace:
[23765.039130]  [<ffffffff8105fe9f>] warn_slowpath_common+0x7f/0xc0
[23765.046197]  [<ffffffff8105fefa>] warn_slowpath_null+0x1a/0x20
[23765.053063]  [<ffffffffa026fc20>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[23765.061110]  [<ffffffffa026b0b9>] commit_fs_roots+0xa9/0x150 [btrfs]
[23765.068443]  [<ffffffffa026c00b>] btrfs_commit_transaction
+0x34b/0x750 [btrfs]
[23765.076646]  [<ffffffff810837e0>] ? wake_up_bit+0x40/0x40
[23765.083031]  [<ffffffffa02655c3>] transaction_kthread+0x283/0x290
[btrfs]
[23765.090826]  [<ffffffffa0265340>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[23765.098603]  [<ffffffff81083276>] kthread+0xb6/0xc0
[23765.104474]  [<ffffffff81099dad>] ? trace_hardirqs_on_caller
+0x13d/0x180
[23765.112148]  [<ffffffff815b5ea4>] kernel_thread_helper+0x4/0x10
[23765.118995]  [<ffffffff815acf14>] ? retint_restore_args+0x13/0x13
[23765.126012]  [<ffffffff810831c0>] ? __init_kthread_worker+0x70/0x70
[23765.133209]  [<ffffffff815b5ea0>] ? gs_change+0x13/0x13
[23765.139359] ---[ end trace 98f2cdf99cfce112 ]---

Jeff ,Wu


