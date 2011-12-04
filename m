From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Blocked for more than 120 seconds
Date: Sun, 04 Dec 2011 14:11:24 +0200
Message-ID: <4EDB636C.4010604@gmail.com>
References: <4ED34359.6010305@robotech.de> <1322472549.1962.2.camel@Nokia-N900> <4ED5FAEF.8070400@robotech.de> <20111130141006.GY24338@shiny> <4ED738E5.3080200@robotech.de> <20111201184158.GB10535@shiny> <4ED8D6C8.4020609@robotech.de> <20111202140112.GN10535@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
To: Chris Mason <chris.mason@oracle.com>, Tobias <tracer@robotech.de>,
	linux-btrfs@vger.kernel.org, miaox <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111202140112.GN10535@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

even more kernel messages from btrfs crashing when rsyncing large=20
amounts of data on 3.2rc4


Dec  3 15:12:14 mail kernel: [15481.100564] loop0           D=20
000000010044b6c5     0  1729      2 0x00000000
Dec  3 15:12:14 mail kernel: [15481.101550]  ffff8801f9b31b30=20
0000000000000046 0000000000000000 0000000000000000
Dec  3 15:12:14 mail kernel: [15481.102548]  ffff880200950e40=20
ffff8801f9b31fd8 ffff8801f9b31fd8 ffff8801f9b31fd8
Dec  3 15:12:14 mail kernel: [15481.103539]  ffff880202cb7200=20
ffff880200950e40 0000000000000002 ffff8801f9b31b78
Dec  3 15:12:14 mail kernel: [15481.104533] Call Trace:
Dec  3 15:12:14 mail kernel: [15481.105531]  [<ffffffff81101a55>] ?=20
find_get_pages_tag+0x125/0x150
Dec  3 15:12:14 mail kernel: [15481.106541]  [<ffffffff8110e205>] ?=20
pagevec_lookup_tag+0x25/0x40
Dec  3 15:12:14 mail kernel: [15481.107552]  [<ffffffff8101d639>] ?=20
read_tsc+0x9/0x20
Dec  3 15:12:14 mail kernel: [15481.108576]  [<ffffffff8108f14d>] ?=20
ktime_get_ts+0xad/0xe0
Dec  3 15:12:14 mail kernel: [15481.109592]  [<ffffffff81101d60>] ?=20
__lock_page+0x70/0x70
Dec  3 15:12:14 mail kernel: [15481.110607]  [<ffffffff814140bf>]=20
schedule+0x3f/0x60
Dec  3 15:12:14 mail kernel: [15481.111619]  [<ffffffff8141416f>]=20
io_schedule+0x8f/0xd0
Dec  3 15:12:14 mail kernel: [15481.112641]  [<ffffffff81101d6e>]=20
sleep_on_page+0xe/0x20
Dec  3 15:12:14 mail kernel: [15481.113639]  [<ffffffff8141491f>]=20
__wait_on_bit+0x5f/0x90
Dec  3 15:12:14 mail kernel: [15481.114629]  [<ffffffff81101f58>]=20
wait_on_page_bit+0x78/0x80
Dec  3 15:12:14 mail kernel: [15481.115628]  [<ffffffff81085790>] ?=20
autoremove_wake_function+0x40/0x40
Dec  3 15:12:14 mail kernel: [15481.116614]  [<ffffffff811020cc>]=20
filemap_fdatawait_range+0x10c/0x1a0
Dec  3 15:12:14 mail kernel: [15481.117613]  [<ffffffff811030c8>]=20
filemap_write_and_wait_range+0x68/0x80
Dec  3 15:12:14 mail kernel: [15481.118630]  [<ffffffffa03a7234>]=20
xfs_file_fsync+0x54/0x340 [xfs]
Dec  3 15:12:14 mail kernel: [15481.119629]  [<ffffffff8119148b>]=20
vfs_fsync+0x2b/0x40
Dec  3 15:12:14 mail kernel: [15481.120627]  [<ffffffffa04dacf2>]=20
do_bio_filebacked+0x1b2/0x320 [loop]
Dec  3 15:12:14 mail kernel: [15481.121645]  [<ffffffffa050efac>] ?=20
end_workqueue_bio+0x9c/0xa0 [btrfs]
Dec  3 15:12:14 mail kernel: [15481.122668]  [<ffffffffa04daf1b>]=20
loop_thread+0xbb/0x260 [loop]
Dec  3 15:12:14 mail kernel: [15481.123674]  [<ffffffff81085750>] ?=20
abort_exclusive_wait+0xb0/0xb0
Dec  3 15:12:14 mail kernel: [15481.124676]  [<ffffffffa04dae60>] ?=20
do_bio_filebacked+0x320/0x320 [loop]
Dec  3 15:12:14 mail kernel: [15481.125698]  [<ffffffff81084e0c>]=20
kthread+0x8c/0xa0
Dec  3 15:12:14 mail kernel: [15481.126710]  [<ffffffff81419a34>]=20
kernel_thread_helper+0x4/0x10
Dec  3 15:12:14 mail kernel: [15481.127721]  [<ffffffff81084d80>] ?=20
kthread_worker_fn+0x190/0x190
Dec  3 15:12:14 mail kernel: [15481.128742]  [<ffffffff81419a30>] ?=20
gs_change+0x13/0x13
Dec  3 15:12:14 mail kernel: [15481.131702] btrfs-transacti D=20
ffff8801f9ab7200     0  1756      2 0x00000000
Dec  3 15:12:14 mail kernel: [15481.132723]  ffff8801e7533bc0=20
0000000000000046 ffff88020fc93400 0000000000000002
Dec  3 15:12:14 mail kernel: [15481.133744]  ffff8801f9ab7200=20
ffff8801e7533fd8 ffff8801e7533fd8 ffff8801e7533fd8
Dec  3 15:12:14 mail kernel: [15481.134771]  ffff880200950e40=20
ffff8801f9ab7200 ffff8801e7533b10 0000000081051ae2
Dec  3 15:12:14 mail kernel: [15481.135813] Call Trace:
Dec  3 15:12:14 mail kernel: [15481.136828]  [<ffffffff8105ad36>] ?=20
ttwu_do_activate.constprop.172+0x66/0x70
Dec  3 15:12:14 mail kernel: [15481.137863]  [<ffffffff8105bd6e>] ?=20
try_to_wake_up+0x1de/0x290
Dec  3 15:12:14 mail kernel: [15481.138914]  [<ffffffff814140bf>]=20
schedule+0x3f/0x60
Dec  3 15:12:14 mail kernel: [15481.139956]  [<ffffffff814147d5>]=20
schedule_timeout+0x305/0x390
Dec  3 15:12:14 mail kernel: [15481.141007]  [<ffffffff8104d003>] ?=20
__wake_up+0x53/0x70
Dec  3 15:12:14 mail kernel: [15481.142074]  [<ffffffff81413348>]=20
wait_for_common+0xc8/0x160
Dec  3 15:12:14 mail kernel: [15481.143124]  [<ffffffff8105be20>] ?=20
try_to_wake_up+0x290/0x290
Dec  3 15:12:14 mail kernel: [15481.144170]  [<ffffffff814133fd>]=20
wait_for_completion+0x1d/0x20
Dec  3 15:12:14 mail kernel: [15481.145229]  [<ffffffffa050f0bb>]=20
write_dev_flush+0x4b/0x140 [btrfs]
Dec  3 15:12:14 mail kernel: [15481.146275]  [<ffffffffa0511086>]=20
write_all_supers+0x6f6/0x800 [btrfs]
Dec  3 15:12:14 mail kernel: [15481.147317]  [<ffffffffa05111a3>]=20
write_ctree_super+0x13/0x20 [btrfs]
Dec  3 15:12:14 mail kernel: [15481.148354]  [<ffffffffa05164dd>]=20
btrfs_commit_transaction+0x63d/0x880 [btrfs]
Dec  3 15:12:14 mail kernel: [15481.149397]  [<ffffffff81085750>] ?=20
abort_exclusive_wait+0xb0/0xb0
Dec  3 15:12:14 mail kernel: [15481.150416]  [<ffffffffa0516b74>] ?=20
start_transaction+0x94/0x2b0 [btrfs]
Dec  3 15:12:14 mail kernel: [15481.151444]  [<ffffffffa050ed4d>]=20
transaction_kthread+0x26d/0x290 [btrfs]
Dec  3 15:12:14 mail kernel: [15481.152492]  [<ffffffffa050eae0>] ?=20
btrfs_congested_fn+0xd0/0xd0 [btrfs]
Dec  3 15:12:14 mail kernel: [15481.153519]  [<ffffffff81084e0c>]=20
kthread+0x8c/0xa0
Dec  3 15:12:14 mail kernel: [15481.154542]  [<ffffffff81419a34>]=20
kernel_thread_helper+0x4/0x10
Dec  3 15:12:14 mail kernel: [15481.155553]  [<ffffffff81084d80>] ?=20
kthread_worker_fn+0x190/0x190
Dec  3 15:12:14 mail kernel: [15481.156522]  [<ffffffff81419a30>] ?=20
gs_change+0x13/0x13
Dec  3 15:12:14 mail kernel: [15481.159519] smbd            D=20
000000010044b8d7     0  2058    823 0x00000004
Dec  3 15:12:14 mail kernel: [15481.160544]  ffff88005cf37a08=20
0000000000000082 ffff88005cf37938 ffffffff81371188
Dec  3 15:12:14 mail kernel: [15481.161588]  ffff8802012e63c0=20
ffff88005cf37fd8 ffff88005cf37fd8 ffff88005cf37fd8
Dec  3 15:12:14 mail kernel: [15481.162658]  ffff880202d21c80=20
ffff8802012e63c0 ffff8802012769c0 0000000000000246
Dec  3 15:12:14 mail kernel: [15481.163708] Call Trace:
Dec  3 15:12:14 mail kernel: [15481.164736]  [<ffffffff81371188>] ?=20
sch_direct_xmit+0x68/0x1d0
Dec  3 15:12:14 mail kernel: [15481.165781]  [<ffffffff81355a00>] ?=20
dev_queue_xmit+0x200/0x680
Dec  3 15:12:14 mail kernel: [15481.166805]  [<ffffffff81389200>] ?=20
ip_forward_options+0x1c0/0x1c0
Dec  3 15:12:14 mail kernel: [15481.167822]  [<ffffffff8138adbe>] ?=20
ip_finish_output+0x18e/0x310
Dec  3 15:12:14 mail kernel: [15481.168850]  [<ffffffff8101d639>] ?=20
read_tsc+0x9/0x20
Dec  3 15:12:14 mail kernel: [15481.169853]  [<ffffffff8108f14d>] ?=20
ktime_get_ts+0xad/0xe0
Dec  3 15:12:14 mail kernel: [15481.170849]  [<ffffffff81101d60>] ?=20
__lock_page+0x70/0x70
Dec  3 15:12:14 mail kernel: [15481.171858]  [<ffffffff814140bf>]=20
schedule+0x3f/0x60
Dec  3 15:12:14 mail kernel: [15481.172851]  [<ffffffff8141416f>]=20
io_schedule+0x8f/0xd0
Dec  3 15:12:14 mail kernel: [15481.173844]  [<ffffffff81101d6e>]=20
sleep_on_page+0xe/0x20
Dec  3 15:12:14 mail kernel: [15481.174836]  [<ffffffff8141491f>]=20
__wait_on_bit+0x5f/0x90
Dec  3 15:12:14 mail kernel: [15481.175845]  [<ffffffff81101f58>]=20
wait_on_page_bit+0x78/0x80
Dec  3 15:12:14 mail kernel: [15481.176842]  [<ffffffff81085790>] ?=20
autoremove_wake_function+0x40/0x40
Dec  3 15:12:14 mail kernel: [15481.177845]  [<ffffffff81102845>]=20
grab_cache_page_write_begin+0x95/0xe0
Dec  3 15:12:14 mail kernel: [15481.178872]  [<ffffffffa03a1150>] ?=20
xfs_get_blocks_direct+0x20/0x20 [xfs]
Dec  3 15:12:14 mail kernel: [15481.179888]  [<ffffffff811967b8>]=20
block_write_begin+0x38/0xa0
Dec  3 15:12:14 mail kernel: [15481.180904]  [<ffffffffa03a1213>]=20
xfs_vm_write_begin+0x43/0x70 [xfs]
Dec  3 15:12:14 mail kernel: [15481.181928]  [<ffffffff8110233c>]=20
generic_file_buffered_write+0x10c/0x270
Dec  3 15:12:14 mail kernel: [15481.182955]  [<ffffffffa03aad66>] ?=20
xfs_iunlock+0x116/0x180 [xfs]
Dec  3 15:12:14 mail kernel: [15481.183979]  [<ffffffffa03a7fef>]=20
xfs_file_buffered_aio_write+0x10f/0x200 [xfs]
Dec  3 15:12:14 mail kernel: [15481.185011]  [<ffffffffa03a8252>]=20
xfs_file_aio_write+0x172/0x2a0 [xfs]
Dec  3 15:12:14 mail kernel: [15481.186052]  [<ffffffff81162d62>]=20
do_sync_write+0xd2/0x110
Dec  3 15:12:14 mail kernel: [15481.187073]  [<ffffffff811f0fcc>] ?=20
security_file_permission+0x2c/0xb0
Dec  3 15:12:14 mail kernel: [15481.188096]  [<ffffffff81163311>] ?=20
rw_verify_area+0x61/0xf0
Dec  3 15:12:14 mail kernel: [15481.189127]  [<ffffffff8116366f>]=20
vfs_write+0xaf/0x180
Dec  3 15:12:14 mail kernel: [15481.190141]  [<ffffffff81163b12>]=20
sys_pwrite64+0x82/0xb0
Dec  3 15:12:14 mail kernel: [15481.191149]  [<ffffffff814178c2>]=20
system_call_fastpath+0x16/0x1b
Dec  3 15:12:14 mail kernel: [15481.194224] kworker/2:3     D=20
0000000000000000     0  3713      2 0x00000000
Dec  3 15:12:14 mail kernel: [15481.195273]  ffff880005d49cc0=20
0000000000000046 0000000246417c40 0000000800000000
Dec  3 15:12:14 mail kernel: [15481.196304]  ffff8802013eaac0=20
ffff880005d49fd8 ffff880005d49fd8 ffff880005d49fd8
Dec  3 15:12:14 mail kernel: [15481.197329]  ffff8802013eeae0=20
ffff8802013eaac0 ffff880005d49c20 ffffffffa03a3fcb
Dec  3 15:12:14 mail kernel: [15481.198345] Call Trace:
Dec  3 15:12:14 mail kernel: [15481.199365]  [<ffffffffa03a3fcb>] ?=20
xfs_buf_iorequest+0x6b/0x100 [xfs]
Dec  3 15:12:14 mail kernel: [15481.200393]  [<ffffffffa03fa603>] ?=20
xlog_bdstrat+0x23/0x60 [xfs]
Dec  3 15:12:14 mail kernel: [15481.201408]  [<ffffffffa03fb287>] ?=20
xlog_sync+0x1d7/0x3c0 [xfs]
Dec  3 15:12:14 mail kernel: [15481.202419]  [<ffffffff814140bf>]=20
schedule+0x3f/0x60
Dec  3 15:12:14 mail kernel: [15481.203418]  [<ffffffffa03fe62b>]=20
_xfs_log_force_lsn+0x29b/0x2d0 [xfs]
Dec  3 15:12:14 mail kernel: [15481.204420]  [<ffffffff8105be20>] ?=20
try_to_wake_up+0x290/0x290
Dec  3 15:12:14 mail kernel: [15481.205438]  [<ffffffffa03fa23b>]=20
xfs_trans_commit+0x29b/0x2b0 [xfs]
Dec  3 15:12:14 mail kernel: [15481.206450]  [<ffffffffa03b4c60>] ?=20
xfs_sync_inode_attr+0xf0/0xf0 [xfs]
Dec  3 15:12:14 mail kernel: [15481.207466]  [<ffffffffa03aa162>]=20
xfs_fs_log_dummy+0x62/0x90 [xfs]
Dec  3 15:12:14 mail kernel: [15481.208486]  [<ffffffff8111ff90>] ?=20
refresh_cpu_vm_stats+0x1a0/0x1a0
Dec  3 15:12:14 mail kernel: [15481.209504]  [<ffffffffa03b4ce4>]=20
xfs_sync_worker+0x84/0x90 [xfs]
Dec  3 15:12:14 mail kernel: [15481.210518]  [<ffffffff8107f446>]=20
process_one_work+0x116/0x4d0
Dec  3 15:12:14 mail kernel: [15481.211531]  [<ffffffff8107fdde>]=20
worker_thread+0x15e/0x350
Dec  3 15:12:14 mail kernel: [15481.212559]  [<ffffffff8107fc80>] ?=20
manage_workers.isra.29+0x230/0x230
Dec  3 15:12:14 mail kernel: [15481.213573]  [<ffffffff81084e0c>]=20
kthread+0x8c/0xa0
Dec  3 15:12:14 mail kernel: [15481.214577]  [<ffffffff81419a34>]=20
kernel_thread_helper+0x4/0x10
Dec  3 15:12:14 mail kernel: [15481.215596]  [<ffffffff81084d80>] ?=20
kthread_worker_fn+0x190/0x190
Dec  3 15:12:14 mail kernel: [15481.216600]  [<ffffffff81419a30>] ?=20
gs_change+0x13/0x13
Dec  3 15:14:14 mail kernel: [15601.217226] xfsbufd/md127   D=20
00000001004562e8     0   527      2 0x00000000
Dec  3 15:14:14 mail kernel: [15601.218264]  ffff8801f912fab0=20
0000000000000046 0000000100000000 0000000300000001
Dec  3 15:14:14 mail kernel: [15601.219326]  ffff8802009dc740=20
ffff8801f912ffd8 ffff8801f912ffd8 ffff8801f912ffd8
Dec  3 15:14:14 mail kernel: [15601.220375]  ffffffff8180d020=20
ffff8802009dc740 ffff8801f912fa10 ffffffff8104d003
Dec  3 15:14:14 mail kernel: [15601.221411] Call Trace:
Dec  3 15:14:14 mail kernel: [15601.222441]  [<ffffffff8104d003>] ?=20
__wake_up+0x53/0x70
Dec  3 15:14:14 mail kernel: [15601.223461]  [<ffffffff8114d48b>] ?=20
kfree+0x3b/0x170
Dec  3 15:14:14 mail kernel: [15601.224479]  [<ffffffffa01c732b>] ?=20
plugger_unplug+0x3b/0x50 [md_mod]
Dec  3 15:14:14 mail kernel: [15601.225507]  [<ffffffff8121b457>] ?=20
blk_flush_plug_list+0xa7/0x250
Dec  3 15:14:14 mail kernel: [15601.226516]  [<ffffffff814140bf>]=20
schedule+0x3f/0x60
Dec  3 15:14:14 mail kernel: [15601.227516]  [<ffffffffa0378209>]=20
get_active_stripe+0x2e9/0x600 [raid456]
Dec  3 15:14:14 mail kernel: [15601.228540]  [<ffffffff8105be20>] ?=20
try_to_wake_up+0x290/0x290
Dec  3 15:14:14 mail kernel: [15601.229552]  [<ffffffffa037be22>]=20
make_request+0x192/0x430 [raid456]
Dec  3 15:14:14 mail kernel: [15601.230569]  [<ffffffff81085750>] ?=20
abort_exclusive_wait+0xb0/0xb0
Dec  3 15:14:14 mail kernel: [15601.231588]  [<ffffffffa01c964a>]=20
md_make_request+0xfa/0x240 [md_mod]
Dec  3 15:14:14 mail kernel: [15601.232628]  [<ffffffff811047a5>] ?=20
mempool_alloc_slab+0x15/0x20
Dec  3 15:14:14 mail kernel: [15601.233654]  [<ffffffff81219917>]=20
generic_make_request+0xc7/0x100
Dec  3 15:14:14 mail kernel: [15601.234682]  [<ffffffff812199d7>]=20
submit_bio+0x87/0x110
Dec  3 15:14:14 mail kernel: [15601.235731]  [<ffffffffa03a3e6c>]=20
_xfs_buf_ioapply+0x15c/0x1c0 [xfs]
Dec  3 15:14:14 mail kernel: [15601.236772]  [<ffffffffa03a4d75>] ?=20
xfs_bdstrat_cb+0x65/0x120 [xfs]
Dec  3 15:14:14 mail kernel: [15601.237815]  [<ffffffffa03a3fb9>]=20
xfs_buf_iorequest+0x59/0x100 [xfs]
Dec  3 15:14:14 mail kernel: [15601.238874]  [<ffffffffa03a4d75>]=20
xfs_bdstrat_cb+0x65/0x120 [xfs]
Dec  3 15:14:14 mail kernel: [15601.239916]  [<ffffffffa03a4f3e>]=20
xfsbufd+0x10e/0x170 [xfs]
Dec  3 15:14:14 mail kernel: [15601.240949]  [<ffffffff8105be32>] ?=20
default_wake_function+0x12/0x20
Dec  3 15:14:14 mail kernel: [15601.241995]  [<ffffffffa03a4e30>] ?=20
xfs_bdstrat_cb+0x120/0x120 [xfs]
Dec  3 15:14:14 mail kernel: [15601.243026]  [<ffffffff81084e0c>]=20
kthread+0x8c/0xa0
Dec  3 15:14:14 mail kernel: [15601.244051]  [<ffffffff81419a34>]=20
kernel_thread_helper+0x4/0x10
Dec  3 15:14:14 mail kernel: [15601.245076]  [<ffffffff81084d80>] ?=20
kthread_worker_fn+0x190/0x190
Dec  3 15:14:14 mail kernel: [15601.246114]  [<ffffffff81419a30>] ?=20
gs_change+0x13/0x13
Dec  3 15:14:14 mail kernel: [15601.249209] md127_resync    D=20
00000001004562fa     0   529      2 0x00000000
Dec  3 15:14:14 mail kernel: [15601.250259]  ffff8801f9073b80=20
0000000000000046 0000000100000000 ffffffff81233ce7
Dec  3 15:14:14 mail kernel: [15601.251316]  ffff8802013e8720=20
ffff8801f9073fd8 ffff8801f9073fd8 ffff8801f9073fd8
Dec  3 15:14:14 mail kernel: [15601.252392]  ffff880202cb4e60=20
ffff8802013e8720 ffff880200b70138 ffff880004bff300
Dec  3 15:14:14 mail kernel: [15601.253459] Call Trace:
Dec  3 15:14:14 mail kernel: [15601.254516]  [<ffffffff81233ce7>] ?=20
kobject_put+0x27/0x60
Dec  3 15:14:14 mail kernel: [15601.255590]  [<ffffffff8121b913>] ?=20
blk_queue_bio+0x2c3/0x410
Dec  3 15:14:14 mail kernel: [15601.256642]  [<ffffffff814171a6>] ?=20
retint_kernel+0x26/0x30
Dec  3 15:14:14 mail kernel: [15601.257679]  [<ffffffff814140bf>]=20
schedule+0x3f/0x60
Dec  3 15:14:14 mail kernel: [15601.258721]  [<ffffffffa0378209>]=20
get_active_stripe+0x2e9/0x600 [raid456]
Dec  3 15:14:14 mail kernel: [15601.259756]  [<ffffffff8105be20>] ?=20
try_to_wake_up+0x290/0x290
Dec  3 15:14:14 mail kernel: [15601.260792]  [<ffffffffa037559a>]=20
sync_request+0x35a/0x370 [raid456]
Dec  3 15:14:14 mail kernel: [15601.261838]  [<ffffffffa01c9a08>] ?=20
is_mddev_idle+0x128/0x140 [md_mod]
Dec  3 15:14:14 mail kernel: [15601.262867]  [<ffffffffa01cd2bf>]=20
md_do_sync+0x7ff/0xc70 [md_mod]
Dec  3 15:14:14 mail kernel: [15601.263895]  [<ffffffff81085750>] ?=20
abort_exclusive_wait+0xb0/0xb0
Dec  3 15:14:14 mail kernel: [15601.264926]  [<ffffffff810748cb>] ?=20
recalc_sigpending+0x1b/0x50
Dec  3 15:14:14 mail kernel: [15601.265972]  [<ffffffffa01c9dce>]=20
md_thread+0x10e/0x140 [md_mod]
Dec  3 15:14:14 mail kernel: [15601.267002]  [<ffffffffa01c9cc0>] ?=20
md_register_thread+0x110/0x110 [md_mod]
Dec  3 15:14:14 mail kernel: [15601.268033]  [<ffffffff81084e0c>]=20
kthread+0x8c/0xa0
Dec  3 15:14:14 mail kernel: [15601.269074]  [<ffffffff81419a34>]=20
kernel_thread_helper+0x4/0x10
Dec  3 15:14:14 mail kernel: [15601.270103]  [<ffffffff81084d80>] ?=20
kthread_worker_fn+0x190/0x190
Dec  3 15:14:14 mail kernel: [15601.271132]  [<ffffffff81419a30>] ?=20
gs_change+0x13/0x13
Dec  3 15:14:14 mail kernel: [15601.274249] loop0           D=20
000000010044b6c5     0  1729      2 0x00000000
Dec  3 15:14:14 mail kernel: [15601.275320]  ffff8801f9b31b30=20
0000000000000046 0000000000000000 0000000000000000
Dec  3 15:14:14 mail kernel: [15601.276385]  ffff880200950e40=20
ffff8801f9b31fd8 ffff8801f9b31fd8 ffff8801f9b31fd8
Dec  3 15:14:14 mail kernel: [15601.277454]  ffff880202cb7200=20
ffff880200950e40 0000000000000002 ffff8801f9b31b78
Dec  3 15:14:14 mail kernel: [15601.278536] Call Trace:
Dec  3 15:14:14 mail kernel: [15601.279594]  [<ffffffff81101a55>] ?=20
find_get_pages_tag+0x125/0x150
Dec  3 15:14:14 mail kernel: [15601.280671]  [<ffffffff8110e205>] ?=20
pagevec_lookup_tag+0x25/0x40
Dec  3 15:14:14 mail kernel: [15601.281736]  [<ffffffff8101d639>] ?=20
read_tsc+0x9/0x20
Dec  3 15:14:14 mail kernel: [15601.282801]  [<ffffffff8108f14d>] ?=20
ktime_get_ts+0xad/0xe0
Dec  3 15:14:14 mail kernel: [15601.283840]  [<ffffffff81101d60>] ?=20
__lock_page+0x70/0x70
Dec  3 15:14:14 mail kernel: [15601.284870]  [<ffffffff814140bf>]=20
schedule+0x3f/0x60
Dec  3 15:14:14 mail kernel: [15601.285902]  [<ffffffff8141416f>]=20
io_schedule+0x8f/0xd0
Dec  3 15:14:14 mail kernel: [15601.286919]  [<ffffffff81101d6e>]=20
sleep_on_page+0xe/0x20
Dec  3 15:14:14 mail kernel: [15601.287924]  [<ffffffff8141491f>]=20
__wait_on_bit+0x5f/0x90
Dec  3 15:14:14 mail kernel: [15601.288938]  [<ffffffff81101f58>]=20
wait_on_page_bit+0x78/0x80
Dec  3 15:14:14 mail kernel: [15601.289944]  [<ffffffff81085790>] ?=20
autoremove_wake_function+0x40/0x40
Dec  3 15:14:14 mail kernel: [15601.290953]  [<ffffffff811020cc>]=20
filemap_fdatawait_range+0x10c/0x1a0
Dec  3 15:14:14 mail kernel: [15601.291972]  [<ffffffff811030c8>]=20
filemap_write_and_wait_range+0x68/0x80
Dec  3 15:14:14 mail kernel: [15601.292985]  [<ffffffffa03a7234>]=20
xfs_file_fsync+0x54/0x340 [xfs]
Dec  3 15:14:14 mail kernel: [15601.293993]  [<ffffffff8119148b>]=20
vfs_fsync+0x2b/0x40
Dec  3 15:14:14 mail kernel: [15601.294993]  [<ffffffffa04dacf2>]=20
do_bio_filebacked+0x1b2/0x320 [loop]
Dec  3 15:14:14 mail kernel: [15601.296022]  [<ffffffffa050efac>] ?=20
end_workqueue_bio+0x9c/0xa0 [btrfs]
Dec  3 15:14:14 mail kernel: [15601.297029]  [<ffffffffa04daf1b>]=20
loop_thread+0xbb/0x260 [loop]
Dec  3 15:14:14 mail kernel: [15601.298032]  [<ffffffff81085750>] ?=20
abort_exclusive_wait+0xb0/0xb0
Dec  3 15:14:14 mail kernel: [15601.299049]  [<ffffffffa04dae60>] ?=20
do_bio_filebacked+0x320/0x320 [loop]
Dec  3 15:14:14 mail kernel: [15601.300057]  [<ffffffff81084e0c>]=20
kthread+0x8c/0xa0
Dec  3 15:14:14 mail kernel: [15601.301063]  [<ffffffff81419a34>]=20
kernel_thread_helper+0x4/0x10
Dec  3 15:14:14 mail kernel: [15601.302084]  [<ffffffff81084d80>] ?=20
kthread_worker_fn+0x190/0x190
Dec  3 15:14:14 mail kernel: [15601.303093]  [<ffffffff81419a30>] ?=20
gs_change+0x13/0x13
Dec  3 15:14:14 mail kernel: [15601.306162] btrfs-transacti D=20
ffff8801f9ab7200     0  1756      2 0x00000000
Dec  3 15:14:14 mail kernel: [15601.307205]  ffff8801e7533bc0=20
0000000000000046 ffff88020fc93400 0000000000000002
Dec  3 15:14:14 mail kernel: [15601.308257]  ffff8801f9ab7200=20
ffff8801e7533fd8 ffff8801e7533fd8 ffff8801e7533fd8
Dec  3 15:14:14 mail kernel: [15601.309327]  ffff880200950e40=20
ffff8801f9ab7200 ffff8801e7533b10 0000000081051ae2
Dec  3 15:14:14 mail kernel: [15601.310384] Call Trace:
Dec  3 15:14:14 mail kernel: [15601.311427]  [<ffffffff8105ad36>] ?=20
ttwu_do_activate.constprop.172+0x66/0x70
Dec  3 15:14:14 mail kernel: [15601.312509]  [<ffffffff8105bd6e>] ?=20
try_to_wake_up+0x1de/0x290
Dec  3 15:14:14 mail kernel: [15601.313568]  [<ffffffff814140bf>]=20
schedule+0x3f/0x60
Dec  3 15:14:14 mail kernel: [15601.314612]  [<ffffffff814147d5>]=20
schedule_timeout+0x305/0x390
Dec  3 15:14:14 mail kernel: [15601.315658]  [<ffffffff8104d003>] ?=20
__wake_up+0x53/0x70
Dec  3 15:14:14 mail kernel: [15601.316680]  [<ffffffff81413348>]=20
wait_for_common+0xc8/0x160
Dec  3 15:14:14 mail kernel: [15601.317699]  [<ffffffff8105be20>] ?=20
try_to_wake_up+0x290/0x290
Dec  3 15:14:14 mail kernel: [15601.318730]  [<ffffffff814133fd>]=20
wait_for_completion+0x1d/0x20
Dec  3 15:14:14 mail kernel: [15601.319745]  [<ffffffffa050f0bb>]=20
write_dev_flush+0x4b/0x140 [btrfs]
Dec  3 15:14:14 mail kernel: [15601.320760]  [<ffffffffa0511086>]=20
write_all_supers+0x6f6/0x800 [btrfs]
Dec  3 15:14:14 mail kernel: [15601.321791]  [<ffffffffa05111a3>]=20
write_ctree_super+0x13/0x20 [btrfs]
Dec  3 15:14:14 mail kernel: [15601.322809]  [<ffffffffa05164dd>]=20
btrfs_commit_transaction+0x63d/0x880 [btrfs]
Dec  3 15:14:14 mail kernel: [15601.323831]  [<ffffffff81085750>] ?=20
abort_exclusive_wait+0xb0/0xb0
Dec  3 15:14:14 mail kernel: [15601.324855]  [<ffffffffa0516b74>] ?=20
start_transaction+0x94/0x2b0 [btrfs]
Dec  3 15:14:14 mail kernel: [15601.325894]  [<ffffffffa050ed4d>]=20
transaction_kthread+0x26d/0x290 [btrfs]
Dec  3 15:14:14 mail kernel: [15601.326918]  [<ffffffffa050eae0>] ?=20
btrfs_congested_fn+0xd0/0xd0 [btrfs]
Dec  3 15:14:14 mail kernel: [15601.327937]  [<ffffffff81084e0c>]=20
kthread+0x8c/0xa0
Dec  3 15:14:14 mail kernel: [15601.328963]  [<ffffffff81419a34>]=20
kernel_thread_helper+0x4/0x10
Dec  3 15:14:14 mail kernel: [15601.329979]  [<ffffffff81084d80>] ?=20
kthread_worker_fn+0x190/0x190
Dec  3 15:14:14 mail kernel: [15601.330995]  [<ffffffff81419a30>] ?=20
gs_change+0x13/0x13
Dec  3 15:14:14 mail kernel: [15601.334083] flush-9:127     D=20
00000000a01fc200     0  1891      2 0x00000000
Dec  3 15:14:14 mail kernel: [15601.335141]  ffff880171771540=20
0000000000000046 0000000100000000 0000000300000001
Dec  3 15:14:14 mail kernel: [15601.336194]  ffff8802009d9c80=20
ffff880171771fd8 ffff880171771fd8 ffff880171771fd8
Dec  3 15:14:14 mail kernel: [15601.337252]  ffff8802009dc740=20
ffff8802009d9c80 ffff8801717714a0 ffffffff8104d003
Dec  3 15:14:14 mail kernel: [15601.338304] Call Trace:
Dec  3 15:14:14 mail kernel: [15601.339347]  [<ffffffff8104d003>] ?=20
__wake_up+0x53/0x70
Dec  3 15:14:14 mail kernel: [15601.340376]  [<ffffffff8114d48b>] ?=20
kfree+0x3b/0x170
Dec  3 15:14:14 mail kernel: [15601.341398]  [<ffffffffa01c732b>] ?=20
plugger_unplug+0x3b/0x50 [md_mod]
Dec  3 15:14:14 mail kernel: [15601.342432]  [<ffffffff8121b457>] ?=20
blk_flush_plug_list+0xa7/0x250
Dec  3 15:14:14 mail kernel: [15601.343453]  [<ffffffff814140bf>]=20
schedule+0x3f/0x60
Dec  3 15:14:14 mail kernel: [15601.344460]  [<ffffffffa0378209>]=20
get_active_stripe+0x2e9/0x600 [raid456]
Dec  3 15:14:14 mail kernel: [15601.345487]  [<ffffffffa01c6400>] ?=20
md_wakeup_thread+0x10/0x30 [md_mod]
Dec  3 15:14:14 mail kernel: [15601.346503]  [<ffffffff8105be20>] ?=20
try_to_wake_up+0x290/0x290
Dec  3 15:14:14 mail kernel: [15601.347519]  [<ffffffffa037be22>]=20
make_request+0x192/0x430 [raid456]
Dec  3 15:14:14 mail kernel: [15601.348555]  [<ffffffff81085750>] ?=20
abort_exclusive_wait+0xb0/0xb0
Dec  3 15:14:14 mail kernel: [15601.348559]  [<ffffffffa01c964a>]=20
md_make_request+0xfa/0x240 [md_mod]
Dec  3 15:14:14 mail kernel: [15601.348561]  [<ffffffff81219917>]=20
generic_make_request+0xc7/0x100
Dec  3 15:14:14 mail kernel: [15601.348563]  [<ffffffff812199d7>]=20
submit_bio+0x87/0x110
Dec  3 15:14:14 mail kernel: [15601.348565]  [<ffffffff8118b300>] ?=20
__mark_inode_dirty+0x40/0x230
Dec  3 15:14:14 mail kernel: [15601.348571]  [<ffffffffa03a16f7>]=20
xfs_submit_ioend_bio.isra.11+0x57/0x80 [xfs]
Dec  3 15:14:14 mail kernel: [15601.348578]  [<ffffffffa03a180e>]=20
xfs_submit_ioend+0xee/0x110 [xfs]
Dec  3 15:14:14 mail kernel: [15601.348585]  [<ffffffffa03a1a65>]=20
xfs_vm_writepage+0x235/0x530 [xfs]
Dec  3 15:14:14 mail kernel: [15601.348588]  [<ffffffff8110b75a>]=20
__writepage+0x1a/0x50
Dec  3 15:14:14 mail kernel: [15601.348591]  [<ffffffff8110bc21>]=20
write_cache_pages+0x1e1/0x4e0
Dec  3 15:14:14 mail kernel: [15601.348599]  [<ffffffffa03bab27>] ?=20
kmem_alloc+0x67/0xe0 [xfs]
Dec  3 15:14:14 mail kernel: [15601.348602]  [<ffffffff8110b740>] ?=20
bdi_set_max_ratio+0x90/0x90
Dec  3 15:14:14 mail kernel: [15601.348606]  [<ffffffff8110bf6d>]=20
generic_writepages+0x4d/0x70
Dec  3 15:14:14 mail kernel: [15601.348612]  [<ffffffffa03a06ad>]=20
xfs_vm_writepages+0x4d/0x60 [xfs]
Dec  3 15:14:14 mail kernel: [15601.348615]  [<ffffffff8110d6a4>]=20
do_writepages+0x24/0x40
Dec  3 15:14:14 mail kernel: [15601.348618]  [<ffffffff8118b76f>]=20
writeback_single_inode+0x10f/0x3f0
Dec  3 15:14:14 mail kernel: [15601.348621]  [<ffffffff8118be4a>]=20
writeback_sb_inodes+0x1aa/0x270
Dec  3 15:14:14 mail kernel: [15601.348624]  [<ffffffff8118bfae>]=20
__writeback_inodes_wb+0x9e/0xd0
Dec  3 15:14:14 mail kernel: [15601.348627]  [<ffffffff8118c5cb>]=20
wb_writeback+0x37b/0x3b0
Dec  3 15:14:14 mail kernel: [15601.348631]  [<ffffffff8117d562>] ?=20
get_nr_inodes+0x52/0x70
Dec  3 15:14:14 mail kernel: [15601.348634]  [<ffffffff8117e262>] ?=20
get_nr_dirty_inodes+0x52/0x80
Dec  3 15:14:14 mail kernel: [15601.348636]  [<ffffffff8118c69f>]=20
wb_check_old_data_flush+0x9f/0xb0
Dec  3 15:14:14 mail kernel: [15601.348639]  [<ffffffff8118db7c>]=20
wb_do_writeback+0x19c/0x230
Dec  3 15:14:14 mail kernel: [15601.348642]  [<ffffffff81414643>] ?=20
schedule_timeout+0x173/0x390
Dec  3 15:14:14 mail kernel: [15601.348645]  [<ffffffff81071b10>] ?=20
init_timer_deferrable_key+0x30/0x30
Dec  3 15:14:14 mail kernel: [15601.348648]  [<ffffffff8118dc9c>]=20
bdi_writeback_thread+0x8c/0x340
Dec  3 15:14:14 mail kernel: [15601.348651]  [<ffffffff8118dc10>] ?=20
wb_do_writeback+0x230/0x230
Dec  3 15:14:14 mail kernel: [15601.348654]  [<ffffffff81084e0c>]=20
kthread+0x8c/0xa0
Dec  3 15:14:14 mail kernel: [15601.348657]  [<ffffffff81419a34>]=20
kernel_thread_helper+0x4/0x10
Dec  3 15:14:14 mail kernel: [15601.348660]  [<ffffffff81084d80>] ?=20
kthread_worker_fn+0x190/0x190
Dec  3 15:14:14 mail kernel: [15601.348663]  [<ffffffff81419a30>] ?=20
gs_change+0x13/0x13
Dec  3 15:14:14 mail kernel: [15601.348669] smbd            D=20
000000010044b8d7     0  2058    823 0x00000004
Dec  3 15:14:14 mail kernel: [15601.348672]  ffff88005cf37a08=20
0000000000000082 ffff88005cf37938 ffffffff81371188
Dec  3 15:14:14 mail kernel: [15601.348676]  ffff8802012e63c0=20
ffff88005cf37fd8 ffff88005cf37fd8 ffff88005cf37fd8
Dec  3 15:14:14 mail kernel: [15601.348680]  ffff880202d21c80=20
ffff8802012e63c0 ffff8802012769c0 0000000000000246
Dec  3 15:14:14 mail kernel: [15601.348684] Call Trace:
Dec  3 15:14:14 mail kernel: [15601.348687]  [<ffffffff81371188>] ?=20
sch_direct_xmit+0x68/0x1d0
Dec  3 15:14:14 mail kernel: [15601.348691]  [<ffffffff81355a00>] ?=20
dev_queue_xmit+0x200/0x680
Dec  3 15:14:14 mail kernel: [15601.348694]  [<ffffffff81389200>] ?=20
ip_forward_options+0x1c0/0x1c0
Dec  3 15:14:14 mail kernel: [15601.348697]  [<ffffffff8138adbe>] ?=20
ip_finish_output+0x18e/0x310
Dec  3 15:14:14 mail kernel: [15601.348700]  [<ffffffff8101d639>] ?=20
read_tsc+0x9/0x20
Dec  3 15:14:14 mail kernel: [15601.348703]  [<ffffffff8108f14d>] ?=20
ktime_get_ts+0xad/0xe0
Dec  3 15:14:14 mail kernel: [15601.348705]  [<ffffffff81101d60>] ?=20
__lock_page+0x70/0x70
Dec  3 15:14:14 mail kernel: [15601.348708]  [<ffffffff814140bf>]=20
schedule+0x3f/0x60
Dec  3 15:14:14 mail kernel: [15601.348711]  [<ffffffff8141416f>]=20
io_schedule+0x8f/0xd0
Dec  3 15:14:14 mail kernel: [15601.348714]  [<ffffffff81101d6e>]=20
sleep_on_page+0xe/0x20
Dec  3 15:14:14 mail kernel: [15601.348716]  [<ffffffff8141491f>]=20
__wait_on_bit+0x5f/0x90
Dec  3 15:14:14 mail kernel: [15601.348719]  [<ffffffff81101f58>]=20
wait_on_page_bit+0x78/0x80
Dec  3 15:14:14 mail kernel: [15601.348722]  [<ffffffff81085790>] ?=20
autoremove_wake_function+0x40/0x40
Dec  3 15:14:14 mail kernel: [15601.348725]  [<ffffffff81102845>]=20
grab_cache_page_write_begin+0x95/0xe0
Dec  3 15:14:14 mail kernel: [15601.348732]  [<ffffffffa03a1150>] ?=20
xfs_get_blocks_direct+0x20/0x20 [xfs]
Dec  3 15:14:14 mail kernel: [15601.348736]  [<ffffffff811967b8>]=20
block_write_begin+0x38/0xa0
Dec  3 15:14:14 mail kernel: [15601.348743]  [<ffffffffa03a1213>]=20
xfs_vm_write_begin+0x43/0x70 [xfs]
Dec  3 15:14:14 mail kernel: [15601.348746]  [<ffffffff8110233c>]=20
generic_file_buffered_write+0x10c/0x270
Dec  3 15:14:14 mail kernel: [15601.348754]  [<ffffffffa03aad66>] ?=20
xfs_iunlock+0x116/0x180 [xfs]
Dec  3 15:14:14 mail kernel: [15601.348761]  [<ffffffffa03a7fef>]=20
xfs_file_buffered_aio_write+0x10f/0x200 [xfs]
Dec  3 15:14:14 mail kernel: [15601.348768]  [<ffffffffa03a8252>]=20
xfs_file_aio_write+0x172/0x2a0 [xfs]
Dec  3 15:14:14 mail kernel: [15601.348772]  [<ffffffff81162d62>]=20
do_sync_write+0xd2/0x110
Dec  3 15:14:14 mail kernel: [15601.348775]  [<ffffffff811f0fcc>] ?=20
security_file_permission+0x2c/0xb0
Dec  3 15:14:14 mail kernel: [15601.348778]  [<ffffffff81163311>] ?=20
rw_verify_area+0x61/0xf0
Dec  3 15:14:14 mail kernel: [15601.348781]  [<ffffffff8116366f>]=20
vfs_write+0xaf/0x180
Dec  3 15:14:14 mail kernel: [15601.348784]  [<ffffffff81163b12>]=20
sys_pwrite64+0x82/0xb0
Dec  3 15:14:14 mail kernel: [15601.348787]  [<ffffffff814178c2>]=20
system_call_fastpath+0x16/0x1b


On 2/12/2011 4:01 =CE=BC=CE=BC, Chris Mason wrote:
> On Fri, Dec 02, 2011 at 02:46:48PM +0100, Tobias wrote:
>> Hi Chris!
>>
>> Am 01.12.2011 19:41, schrieb Chris Mason:
>>> So, the transaction close is in btrfs_evict_inode, which sounds lik=
e a
>>> deadlock recently fixed by this commit:
>>>
>>> http://git.kernel.org/?p=3Dlinux/kernel/git/mason/linux-btrfs.git;a=
=3Dcommit;h=3Daa38a711a893accf5b5192f3d705a120deaa81e0
>>>
>>> If you pull the for-linus branch from today, hopefully the problem =
will
>>> be gone.
>>>
>> This looks very good. With this Kernel i still have some hangs, but
>> only in rsync, only under high load and they don't lock up the
>> system - so i guess it's ok now.
>>
>> Thank You very much for Your help!
> Glad to hear this is working.  All the credit to Miao, who found the
> deadlock.
>
>> When will this patches go into the main Kernel?
> Linus pulled them in yesterday.
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
