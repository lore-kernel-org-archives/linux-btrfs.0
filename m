From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: [3.3.1] multiple oopses during rsync backup
Date: Fri, 13 Apr 2012 18:05:22 +0200
Message-ID: <afvl59-cg9.ln1@hurikhan.ath.cx>
References: <2cil59-784.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Just in case it is interesting, here's the blocked state (take note I 
currently have other fs actions running on my btrfs root fs copying a lot of 
files from a remote server):

Kai Krakow <hurikhan77+btrfs@gmail.com> schrieb:

> This is what happened while rsyncing my system disk to my btrfs backup
> device after I enabled space caching for the latter (and first time using
> it after 3.3.1, last time I sync'ed it was with 3.2.x):
> 
> [... dmesg output ...]

[24701.417821] SysRq : Show Blocked State
[24701.417826]   task                        PC stack   pid father
[24701.417896] btrfs-delayed-m D ffff8802ddebd2e0     0 10993      2 
0x00000000
[24701.417900]  ffff8802ddebd2e0 0000000000000046 00000002bb866b00 
ffff88042dc6d940
[24701.417903]  ffff880300000002 ffff8803f68e7a98 0000000000010b00 
ffff8802bbccdfd8
[24701.417906]  ffff8802bbccdfd8 0000000000010b00 ffff8802ddebd2e0 
0000000000010b00
[24701.417909] Call Trace:
[24701.417914]  [<ffffffff81186b11>] ? btrfs_tree_read_lock+0xc5/0x110
[24701.417918]  [<ffffffff8103f234>] ? wake_up_bit+0x23/0x23
[24701.417921]  [<ffffffff811468ee>] ? btrfs_read_lock_root_node+0x1d/0x3f
[24701.417924]  [<ffffffff81149adc>] ? btrfs_search_slot+0x145/0x658
[24701.417927]  [<ffffffff8114d0da>] ? 
lookup_inline_extent_backref+0xb8/0x36e
[24701.417930]  [<ffffffff81191a3f>] ? tree_insert+0x143/0x15f
[24701.417933]  [<ffffffff811d27a9>] ? radix_tree_tag_set+0x62/0xc4
[24701.417935]  [<ffffffff8114d3f3>] ? 
insert_inline_extent_backref+0x63/0xea
[24701.417939]  [<ffffffff81459e41>] ? _cond_resched+0x9/0x20
[24701.417943]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[24701.417945]  [<ffffffff8114e3b8>] ? 
__btrfs_inc_extent_ref.clone.64+0xa9/0x1c9
[24701.417948]  [<ffffffff8117a066>] ? map_private_extent_buffer+0x9d/0xde
[24701.417951]  [<ffffffff81152ac2>] ? run_clustered_refs+0x6a8/0x74a
[24701.417953]  [<ffffffff81147dc4>] ? comp_keys+0x23/0x28
[24701.417955]  [<ffffffff81147eb5>] ? 
generic_bin_search.clone.43+0xec/0x130
[24701.417958]  [<ffffffff81187026>] ? btrfs_tree_read_unlock+0x7b/0x8a
[24701.417960]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[24701.417963]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.417965]  [<ffffffff81186ef2>] ? btrfs_tree_unlock+0x87/0x90
[24701.417968]  [<ffffffff8114db18>] ? 
block_rsv_release_bytes.clone.46+0xad/0xc8
[24701.417970]  [<ffffffff81160c40>] ? __btrfs_end_transaction+0x79/0x1e9
[24701.417973]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.417975]  [<ffffffff81199aa6>] ? 
btrfs_async_run_delayed_node_done+0x16d/0x1cb
[24701.417978]  [<ffffffff811818f5>] ? worker_loop+0x17e/0x4c5
[24701.417980]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[24701.417981]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[24701.417984]  [<ffffffff8103ee71>] ? kthread+0x81/0x89
[24701.417986]  [<ffffffff8145c254>] ? kernel_thread_helper+0x4/0x10
[24701.417988]  [<ffffffff8103edf0>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[24701.417990]  [<ffffffff8145c250>] ? gs_change+0xb/0xb
[24701.417993] btrfs-transacti D ffff8802ce3cd2e0     0 11002      2 
0x00000000
[24701.417996]  ffff8802ce3cd2e0 0000000000000046 0000000000000002 
ffff88042dc6f2c0
[24701.417998]  ffffffff00000000 0000000000000000 0000000000010b00 
ffff8801f9401fd8
[24701.418001]  ffff8801f9401fd8 0000000000010b00 ffff8802ce3cd2e0 
0000000000010b00
[24701.418004] Call Trace:
[24701.418006]  [<ffffffff81186b11>] ? btrfs_tree_read_lock+0xc5/0x110
[24701.418008]  [<ffffffff8103f234>] ? wake_up_bit+0x23/0x23
[24701.418010]  [<ffffffff811468ee>] ? btrfs_read_lock_root_node+0x1d/0x3f
[24701.418012]  [<ffffffff81149adc>] ? btrfs_search_slot+0x145/0x658
[24701.418014]  [<ffffffff8114d0da>] ? 
lookup_inline_extent_backref+0xb8/0x36e
[24701.418017]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[24701.418020]  [<ffffffff8114f6af>] ? __btrfs_free_extent+0xcb/0x5c7
[24701.418022]  [<ffffffff81152af8>] ? run_clustered_refs+0x6de/0x74a
[24701.418025]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[24701.418028]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418030]  [<ffffffff81459e41>] ? _cond_resched+0x9/0x20
[24701.418032]  [<ffffffff814592ab>] ? mutex_lock+0xd/0x2d
[24701.418035]  [<ffffffff8145a93c>] ? _raw_spin_lock_irqsave+0x9/0x22
[24701.418037]  [<ffffffff8116056a>] ? btrfs_commit_transaction+0x8f/0x6d1
[24701.418039]  [<ffffffff8104508d>] ? need_resched+0x1a/0x23
[24701.418042]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418044]  [<ffffffff81459e41>] ? _cond_resched+0x9/0x20
[24701.418046]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[24701.418048]  [<ffffffff810b5e42>] ? kmem_cache_alloc+0x1c/0x95
[24701.418050]  [<ffffffff8103f234>] ? wake_up_bit+0x23/0x23
[24701.418053]  [<ffffffff81160fde>] ? start_transaction+0x1db/0x215
[24701.418055]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418057]  [<ffffffff8115a9c6>] ? transaction_kthread+0x171/0x21b
[24701.418059]  [<ffffffff8115a855>] ? try_to_freeze+0x37/0x37
[24701.418061]  [<ffffffff8115a855>] ? try_to_freeze+0x37/0x37
[24701.418063]  [<ffffffff8103ee71>] ? kthread+0x81/0x89
[24701.418065]  [<ffffffff8145c254>] ? kernel_thread_helper+0x4/0x10
[24701.418067]  [<ffffffff8103edf0>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[24701.418069]  [<ffffffff8145c250>] ? gs_change+0xb/0xb
[24701.418071] rsync           D ffff88029a5c3fc0     0 11012      1 
0x00000004
[24701.418074]  ffff88029a5c3fc0 0000000000000082 0000000000000003 
ffff88042dc6d940
[24701.418076]  0000000000000050 0000000000000000 0000000000010b00 
ffff8801b7671fd8
[24701.418079]  ffff8801b7671fd8 0000000000010b00 ffff88029a5c3fc0 
0000000000010b00
[24701.418082] Call Trace:
[24701.418084]  [<ffffffff81186b11>] ? btrfs_tree_read_lock+0xc5/0x110
[24701.418086]  [<ffffffff8103f234>] ? wake_up_bit+0x23/0x23
[24701.418088]  [<ffffffff811468ee>] ? btrfs_read_lock_root_node+0x1d/0x3f
[24701.418090]  [<ffffffff81149adc>] ? btrfs_search_slot+0x145/0x658
[24701.418092]  [<ffffffff8114d0da>] ? 
lookup_inline_extent_backref+0xb8/0x36e
[24701.418095]  [<ffffffff8117a066>] ? map_private_extent_buffer+0x9d/0xde
[24701.418097]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[24701.418100]  [<ffffffff8114f6af>] ? __btrfs_free_extent+0xcb/0x5c7
[24701.418102]  [<ffffffff8114873b>] ? btrfs_leaf_free_space+0x31/0x6e
[24701.418104]  [<ffffffff81152af8>] ? run_clustered_refs+0x6de/0x74a
[24701.418107]  [<ffffffff814592ab>] ? mutex_lock+0xd/0x2d
[24701.418109]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[24701.418112]  [<ffffffff8116a0aa>] ? btrfs_add_link+0x176/0x1fb
[24701.418114]  [<ffffffff81160c40>] ? __btrfs_end_transaction+0x79/0x1e9
[24701.418116]  [<ffffffff8116ad8a>] ? btrfs_create+0x173/0x1b4
[24701.418119]  [<ffffffff81031028>] ? ns_capable+0x38/0x4b
[24701.418121]  [<ffffffff810c744d>] ? vfs_create+0x4f/0x6f
[24701.418123]  [<ffffffff810c7be4>] ? do_last+0x22b/0x57f
[24701.418126]  [<ffffffff810c8512>] ? path_openat+0xcf/0x32d
[24701.418128]  [<ffffffff810bcae2>] ? do_sync_write+0xb1/0xea
[24701.418130]  [<ffffffff810c8844>] ? do_filp_open+0x2c/0x72
[24701.418132]  [<ffffffff8104508d>] ? need_resched+0x1a/0x23
[24701.418135]  [<ffffffff81459e41>] ? _cond_resched+0x9/0x20
[24701.418137]  [<ffffffff811d74b1>] ? __strncpy_from_user+0x19/0x4a
[24701.418140]  [<ffffffff810d194f>] ? alloc_fd+0x69/0x110
[24701.418142]  [<ffffffff810bc777>] ? do_sys_open+0x60/0xe7
[24701.418145]  [<ffffffff8145b162>] ? system_call_fastpath+0x16/0x1b
[24701.418146] btrfs-delayed-m D ffff8802ddebb300     0 11016      2 
0x00000000
[24701.418149]  ffff8802ddebb300 0000000000000046 0000000000000001 
ffff88042dc6bfc0
[24701.418151]  ffff88001e496e08 0000000019c00000 0000000000010b00 
ffff88010e3adfd8
[24701.418154]  ffff88010e3adfd8 0000000000010b00 ffff8802ddebb300 
0000000000010b00
[24701.418157] Call Trace:
[24701.418159]  [<ffffffff81186b11>] ? btrfs_tree_read_lock+0xc5/0x110
[24701.418161]  [<ffffffff8103f234>] ? wake_up_bit+0x23/0x23
[24701.418163]  [<ffffffff811d2f6b>] ? rb_insert_color+0xb1/0xd9
[24701.418165]  [<ffffffff811468ee>] ? btrfs_read_lock_root_node+0x1d/0x3f
[24701.418167]  [<ffffffff81149adc>] ? btrfs_search_slot+0x145/0x658
[24701.418170]  [<ffffffff81191e7d>] ? 
add_delayed_tree_ref.clone.10+0xb7/0xee
[24701.418172]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[24701.418175]  [<ffffffff811507f5>] ? btrfs_lookup_extent_info+0x75/0x262
[24701.418177]  [<ffffffff81179c0c>] ? read_extent_buffer+0x97/0xe2
[24701.418179]  [<ffffffff81146b87>] ? update_ref_for_cow+0x44/0x216
[24701.418181]  [<ffffffff81146f00>] ? __btrfs_cow_block+0x1a7/0x312
[24701.418183]  [<ffffffff8114715f>] ? btrfs_cow_block+0xf4/0x103
[24701.418185]  [<ffffffff81149bbd>] ? btrfs_search_slot+0x226/0x658
[24701.418188]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418190]  [<ffffffff81159146>] ? btrfs_lookup_inode+0x25/0x87
[24701.418192]  [<ffffffff8104508d>] ? need_resched+0x1a/0x23
[24701.418194]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418196]  [<ffffffff81459e41>] ? _cond_resched+0x9/0x20
[24701.418198]  [<ffffffff814592ab>] ? mutex_lock+0xd/0x2d
[24701.418200]  [<ffffffff81198e2f>] ? btrfs_update_delayed_inode+0x6b/0x126
[24701.418203]  [<ffffffff81160fde>] ? start_transaction+0x1db/0x215
[24701.418205]  [<ffffffff811999d8>] ? 
btrfs_async_run_delayed_node_done+0x9f/0x1cb
[24701.418207]  [<ffffffff811818f5>] ? worker_loop+0x17e/0x4c5
[24701.418209]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[24701.418211]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[24701.418213]  [<ffffffff8103ee71>] ? kthread+0x81/0x89
[24701.418215]  [<ffffffff8145c254>] ? kernel_thread_helper+0x4/0x10
[24701.418218]  [<ffffffff8103edf0>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[24701.418220]  [<ffffffff8145c250>] ? gs_change+0xb/0xb
[24701.418221] btrfs-endio-wri D ffff880079c28660     0 11038      2 
0x00000000
[24701.418223]  ffff880079c28660 0000000000000046 0000000000000050 
ffff88042dc6f2c0
[24701.418226]  0000000000000002 0000000000000050 0000000000010b00 
ffff88012389dfd8
[24701.418229]  ffff88012389dfd8 0000000000010b00 ffff880079c28660 
0000000000010b00
[24701.418231] Call Trace:
[24701.418233]  [<ffffffff81186b11>] ? btrfs_tree_read_lock+0xc5/0x110
[24701.418235]  [<ffffffff8103f234>] ? wake_up_bit+0x23/0x23
[24701.418237]  [<ffffffff811468ee>] ? btrfs_read_lock_root_node+0x1d/0x3f
[24701.418239]  [<ffffffff81149adc>] ? btrfs_search_slot+0x145/0x658
[24701.418242]  [<ffffffff8108fed8>] ? __set_page_dirty_nobuffers+0x16/0xd2
[24701.418245]  [<ffffffff8114d0da>] ? 
lookup_inline_extent_backref+0xb8/0x36e
[24701.418247]  [<ffffffff81044f54>] ? __wake_up+0x35/0x46
[24701.418249]  [<ffffffff81149048>] ? __push_leaf_right+0x37b/0x38f
[24701.418252]  [<ffffffff8114d3f3>] ? 
insert_inline_extent_backref+0x63/0xea
[24701.418254]  [<ffffffff81459e41>] ? _cond_resched+0x9/0x20
[24701.418256]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[24701.418259]  [<ffffffff8114e3b8>] ? 
__btrfs_inc_extent_ref.clone.64+0xa9/0x1c9
[24701.418261]  [<ffffffff8115afc4>] ? verify_parent_transid+0x31/0xf9
[24701.418263]  [<ffffffff81152ac2>] ? run_clustered_refs+0x6a8/0x74a
[24701.418266]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[24701.418269]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418271]  [<ffffffff8119a941>] ? 
btrfs_delayed_update_inode+0x340/0x363
[24701.418273]  [<ffffffff81044f54>] ? __wake_up+0x35/0x46
[24701.418276]  [<ffffffff81160c40>] ? __btrfs_end_transaction+0x79/0x1e9
[24701.418278]  [<ffffffff81165953>] ? btrfs_finish_ordered_io+0x289/0x2ae
[24701.418280]  [<ffffffff81458f7b>] ? schedule_timeout+0xa8/0xd7
[24701.418283]  [<ffffffff81190a6f>] ? end_compressed_bio_write+0x60/0xbb
[24701.418284]  [<ffffffff811818f5>] ? worker_loop+0x17e/0x4c5
[24701.418286]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[24701.418288]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[24701.418290]  [<ffffffff8103ee71>] ? kthread+0x81/0x89
[24701.418292]  [<ffffffff8145c254>] ? kernel_thread_helper+0x4/0x10
[24701.418295]  [<ffffffff8103edf0>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[24701.418297]  [<ffffffff8145c250>] ? gs_change+0xb/0xb
[24701.418298] btrfs-delayed-m D ffff88020b5e9fe0     0 11041      2 
0x00000000
[24701.418300]  ffff88020b5e9fe0 0000000000000046 000000000000047f 
ffff88042dc6f2c0
[24701.418303]  ffff880200000001 0000000000000000 0000000000010b00 
ffff8801ccbedfd8
[24701.418306]  ffff8801ccbedfd8 0000000000010b00 ffff88020b5e9fe0 
0000000000010b00
[24701.418308] Call Trace:
[24701.418310]  [<ffffffff81186b11>] ? btrfs_tree_read_lock+0xc5/0x110
[24701.418312]  [<ffffffff8103f234>] ? wake_up_bit+0x23/0x23
[24701.418315]  [<ffffffff8115043b>] ? find_free_extent.clone.71+0x7cb/0x950
[24701.418317]  [<ffffffff811468ee>] ? btrfs_read_lock_root_node+0x1d/0x3f
[24701.418319]  [<ffffffff81149adc>] ? btrfs_search_slot+0x145/0x658
[24701.418321]  [<ffffffff811d2f6b>] ? rb_insert_color+0xb1/0xd9
[24701.418323]  [<ffffffff81191a3f>] ? tree_insert+0x143/0x15f
[24701.418326]  [<ffffffff8114d0da>] ? 
lookup_inline_extent_backref+0xb8/0x36e
[24701.418328]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[24701.418330]  [<ffffffff8114f6af>] ? __btrfs_free_extent+0xcb/0x5c7
[24701.418333]  [<ffffffff81152af8>] ? run_clustered_refs+0x6de/0x74a
[24701.418335]  [<ffffffff81147dc4>] ? comp_keys+0x23/0x28
[24701.418337]  [<ffffffff81187026>] ? btrfs_tree_read_unlock+0x7b/0x8a
[24701.418340]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[24701.418342]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418344]  [<ffffffff81186ef2>] ? btrfs_tree_unlock+0x87/0x90
[24701.418347]  [<ffffffff8114db18>] ? 
block_rsv_release_bytes.clone.46+0xad/0xc8
[24701.418349]  [<ffffffff81160c40>] ? __btrfs_end_transaction+0x79/0x1e9
[24701.418351]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418354]  [<ffffffff81199aa6>] ? 
btrfs_async_run_delayed_node_done+0x16d/0x1cb
[24701.418356]  [<ffffffff811818f5>] ? worker_loop+0x17e/0x4c5
[24701.418357]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[24701.418359]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[24701.418361]  [<ffffffff8103ee71>] ? kthread+0x81/0x89
[24701.418363]  [<ffffffff8145c254>] ? kernel_thread_helper+0x4/0x10
[24701.418366]  [<ffffffff8103edf0>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[24701.418368]  [<ffffffff8145c250>] ? gs_change+0xb/0xb
[24701.418369] btrfs-endio-wri D ffff880079c2b960     0 11043      2 
0x00000000
[24701.418371]  ffff880079c2b960 0000000000000046 ffff880425432ca8 
ffffffff8180d020
[24701.418374]  ffff880411c38200 ffffffff8117a066 0000000000010b00 
ffff88010acc5fd8
[24701.418377]  ffff88010acc5fd8 0000000000010b00 ffff880079c2b960 
0000000000010b00
[24701.418379] Call Trace:
[24701.418381]  [<ffffffff8117a066>] ? map_private_extent_buffer+0x9d/0xde
[24701.418384]  [<ffffffff81186d0b>] ? btrfs_tree_lock+0xf5/0x24b
[24701.418386]  [<ffffffff8103f234>] ? wake_up_bit+0x23/0x23
[24701.418388]  [<ffffffff811870bd>] ? btrfs_set_lock_blocking_rw+0x88/0xdf
[24701.418390]  [<ffffffff81149e7f>] ? btrfs_search_slot+0x4e8/0x658
[24701.418392]  [<ffffffff8114d0da>] ? 
lookup_inline_extent_backref+0xb8/0x36e
[24701.418395]  [<ffffffff81044f54>] ? __wake_up+0x35/0x46
[24701.418397]  [<ffffffff8114901c>] ? __push_leaf_right+0x34f/0x38f
[24701.418399]  [<ffffffff8114d3f3>] ? 
insert_inline_extent_backref+0x63/0xea
[24701.418401]  [<ffffffff81459e41>] ? _cond_resched+0x9/0x20
[24701.418404]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[24701.418416]  [<ffffffff8114e3b8>] ? 
__btrfs_inc_extent_ref.clone.64+0xa9/0x1c9
[24701.418418]  [<ffffffff8115afc4>] ? verify_parent_transid+0x31/0xf9
[24701.418420]  [<ffffffff81152ac2>] ? run_clustered_refs+0x6a8/0x74a
[24701.418422]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[24701.418424]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418426]  [<ffffffff8119a941>] ? 
btrfs_delayed_update_inode+0x340/0x363
[24701.418428]  [<ffffffff81044f54>] ? __wake_up+0x35/0x46
[24701.418430]  [<ffffffff81160c40>] ? __btrfs_end_transaction+0x79/0x1e9
[24701.418432]  [<ffffffff81165953>] ? btrfs_finish_ordered_io+0x289/0x2ae
[24701.418434]  [<ffffffff81458f7b>] ? schedule_timeout+0xa8/0xd7
[24701.418436]  [<ffffffff81190a6f>] ? end_compressed_bio_write+0x60/0xbb
[24701.418437]  [<ffffffff811818f5>] ? worker_loop+0x17e/0x4c5
[24701.418439]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[24701.418441]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[24701.418442]  [<ffffffff8103ee71>] ? kthread+0x81/0x89
[24701.418444]  [<ffffffff8145c254>] ? kernel_thread_helper+0x4/0x10
[24701.418446]  [<ffffffff8103edf0>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[24701.418448]  [<ffffffff8145c250>] ? gs_change+0xb/0xb
[24701.418449] btrfs-endio-wri D ffff8804250a8660     0 11069      2 
0x00000000
[24701.418451]  ffff8804250a8660 0000000000000046 ffff8801cfe0c7c0 
ffff88029a5c5fa0
[24701.418453]  0000000000000001 ffffffff8117a066 0000000000010b00 
ffff8801c5225fd8
[24701.418455]  ffff8801c5225fd8 0000000000010b00 ffff8804250a8660 
0000000000010b00
[24701.418458] Call Trace:
[24701.418459]  [<ffffffff8117a066>] ? map_private_extent_buffer+0x9d/0xde
[24701.418461]  [<ffffffff81186d0b>] ? btrfs_tree_lock+0xf5/0x24b
[24701.418463]  [<ffffffff8103f234>] ? wake_up_bit+0x23/0x23
[24701.418465]  [<ffffffff811870bd>] ? btrfs_set_lock_blocking_rw+0x88/0xdf
[24701.418467]  [<ffffffff81149e7f>] ? btrfs_search_slot+0x4e8/0x658
[24701.418469]  [<ffffffff8114d0da>] ? 
lookup_inline_extent_backref+0xb8/0x36e
[24701.418471]  [<ffffffff81179510>] ? free_extent_buffer+0x12/0x30
[24701.418472]  [<ffffffff8114901c>] ? __push_leaf_right+0x34f/0x38f
[24701.418474]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[24701.418476]  [<ffffffff8114f6af>] ? __btrfs_free_extent+0xcb/0x5c7
[24701.418478]  [<ffffffff8115afc4>] ? verify_parent_transid+0x31/0xf9
[24701.418480]  [<ffffffff8117a066>] ? map_private_extent_buffer+0x9d/0xde
[24701.418482]  [<ffffffff81152af8>] ? run_clustered_refs+0x6de/0x74a
[24701.418484]  [<ffffffff81191879>] ? find_ref_head+0x8e/0xbb
[24701.418487]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[24701.418489]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418491]  [<ffffffff8119a941>] ? 
btrfs_delayed_update_inode+0x340/0x363
[24701.418493]  [<ffffffff81044f54>] ? __wake_up+0x35/0x46
[24701.418495]  [<ffffffff81160c40>] ? __btrfs_end_transaction+0x79/0x1e9
[24701.418496]  [<ffffffff81165953>] ? btrfs_finish_ordered_io+0x289/0x2ae
[24701.418498]  [<ffffffff81458f7b>] ? schedule_timeout+0xa8/0xd7
[24701.418500]  [<ffffffff81190a6f>] ? end_compressed_bio_write+0x60/0xbb
[24701.418502]  [<ffffffff811818f5>] ? worker_loop+0x17e/0x4c5
[24701.418503]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[24701.418505]  [<ffffffff81181777>] ? btrfs_queue_worker+0x273/0x273
[24701.418507]  [<ffffffff8103ee71>] ? kthread+0x81/0x89
[24701.418508]  [<ffffffff8145c254>] ? kernel_thread_helper+0x4/0x10
[24701.418510]  [<ffffffff8103edf0>] ? 
kthread_freezable_should_stop+0x3c/0x3c
[24701.418512]  [<ffffffff8145c250>] ? gs_change+0xb/0xb
[24701.418516] btrfs           D ffff88018a4aaca0     0  7238  11004 
0x00000004
[24701.418518]  ffff88018a4aaca0 0000000000000086 ffff88032da29400 
ffff8803dddef2c0
[24701.418521]  ffff88043fb10b78 ffffffff8104b926 0000000000010b00 
ffff88029775bfd8
[24701.418523]  ffff88029775bfd8 0000000000010b00 ffff88018a4aaca0 
0000000000010b00
[24701.418525] Call Trace:
[24701.418527]  [<ffffffff8104b926>] ? update_shares+0x5f/0xf9
[24701.418529]  [<ffffffff81186b11>] ? btrfs_tree_read_lock+0xc5/0x110
[24701.418531]  [<ffffffff8103f234>] ? wake_up_bit+0x23/0x23
[24701.418533]  [<ffffffff811468ee>] ? btrfs_read_lock_root_node+0x1d/0x3f
[24701.418534]  [<ffffffff81149adc>] ? btrfs_search_slot+0x145/0x658
[24701.418537]  [<ffffffff8114d0da>] ? 
lookup_inline_extent_backref+0xb8/0x36e
[24701.418539]  [<ffffffff81045000>] ? set_rq_online+0x47/0x57
[24701.418540]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[24701.418542]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418544]  [<ffffffff8114f6af>] ? __btrfs_free_extent+0xcb/0x5c7
[24701.418546]  [<ffffffff8117a066>] ? map_private_extent_buffer+0x9d/0xde
[24701.418548]  [<ffffffff810d055f>] ? find_inode+0x59/0x9a
[24701.418550]  [<ffffffff81045000>] ? set_rq_online+0x47/0x57
[24701.418552]  [<ffffffff81152af8>] ? run_clustered_refs+0x6de/0x74a
[24701.418554]  [<ffffffff81179510>] ? free_extent_buffer+0x12/0x30
[24701.418557]  [<ffffffff81152d84>] ? btrfs_run_delayed_refs+0x220/0x2ed
[24701.418559]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418561]  [<ffffffff81459e41>] ? _cond_resched+0x9/0x20
[24701.418562]  [<ffffffff814592ab>] ? mutex_lock+0xd/0x2d
[24701.418564]  [<ffffffff8116056a>] ? btrfs_commit_transaction+0x8f/0x6d1
[24701.418577]  [<ffffffff8104508d>] ? need_resched+0x1a/0x23
[24701.418579]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418581]  [<ffffffff8115fd42>] ? wait_current_trans.clone.28+0x1a/0xd6
[24701.418583]  [<ffffffff810b4bbd>] ? 
slab_pre_alloc_hook.clone.49+0x15/0x1c
[24701.418585]  [<ffffffff810b5e42>] ? kmem_cache_alloc+0x1c/0x95
[24701.418588]  [<ffffffff8103f234>] ? wake_up_bit+0x23/0x23
[24701.418590]  [<ffffffff811836ad>] ? btrfs_mksubvol+0x20c/0x2f8
[24701.418592]  [<ffffffff811838cc>] ? 
btrfs_ioctl_snap_create_transid+0x133/0x162
[24701.418594]  [<ffffffff8104509b>] ? should_resched+0x5/0x24
[24701.418596]  [<ffffffff81183941>] ? btrfs_ioctl_snap_create+0x46/0x5f
[24701.418599]  [<ffffffff811fd9f4>] ? do_output_char+0x96/0x1ae
[24701.418601]  [<ffffffff81185e35>] ? btrfs_ioctl+0x525/0x1034
[24701.418603]  [<ffffffff811fee18>] ? n_tty_write+0x31f/0x352
[24701.418605]  [<ffffffff810e70dd>] ? fsnotify+0x235/0x25b
[24701.418608]  [<ffffffff81044f54>] ? __wake_up+0x35/0x46
[24701.418610]  [<ffffffff810ca559>] ? do_vfs_ioctl+0x458/0x499
[24701.418612]  [<ffffffff810bd1db>] ? vfs_write+0xcb/0xf9
[24701.418614]  [<ffffffff810ca5d6>] ? sys_ioctl+0x3c/0x5e
[24701.418617]  [<ffffffff8145b162>] ? system_call_fastpath+0x16/0x1b


