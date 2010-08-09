From: "Smets, Jan (Jan)" <jan.smets@alcatel-lucent.com>
Subject: unable to handle kernel NULL pointer dereference
Date: Mon, 9 Aug 2010 13:44:07 +0200
Message-ID: <14C7F4F06DB5814AB0DE29716C4F6D670C4C7C14@FRMRSSXCHMBSB1.dc-m.alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi list

Today I was running bonnie++ on a network ceph volume. The storage backend used is btrfs.

You can find a full dmesg output on http://jan.sin.khk.be/dmesg

If any other action is required from my side, please let me know. I hope this report is of any use.

Thanks.
 - Jan



[ 2400.226987] Call Trace:
[ 2400.226987]  [<ffffffffa04579d4>] ? btrfs_file_aio_write+0x686/0x7da [btrfs]
[ 2400.226987]  [<ffffffff810f926b>] ? __d_lookup+0xc1/0x107
[ 2400.226987]  [<ffffffffa045734e>] ? btrfs_file_aio_write+0x0/0x7da [btrfs]
[ 2400.226987]  [<ffffffff810e8ce0>] ? do_sync_readv_writev+0x9a/0xd5
[ 2400.226987]  [<ffffffff810f4163>] ? do_filp_open+0x510/0x58e
[ 2400.226987]  [<ffffffff810e8a91>] ? copy_from_user+0x18/0x30
[ 2400.226987]  [<ffffffff810e97ff>] ? rw_copy_check_uvector+0x6a/0xe1
[ 2400.226987]  [<ffffffff810e991a>] ? do_readv_writev+0xa4/0x118
[ 2400.226987]  [<ffffffff8103d696>] ? finish_task_switch+0x34/0xb4
[ 2400.226987]  [<ffffffff812ffd81>] ? mutex_lock+0xd/0x33
[ 2400.226987]  [<ffffffff810e9ab3>] ? sys_writev+0x45/0x90
[ 2400.226987]  [<ffffffff810089c2>] ? system_call_fastpath+0x16/0x1b


[ 2400.966380] Call Trace:
[ 2400.966380]  [<ffffffffa04576b8>] ? btrfs_file_aio_write+0x36a/0x7da [btrfs]
[ 2400.966380]  [<ffffffffa04576b8>] ? btrfs_file_aio_write+0x36a/0x7da [btrfs]
[ 2400.966380]  [<ffffffffa04638ab>] ? set_extent_buffer_dirty+0x4d/0x5e [btrfs]
[ 2401.148493]  [<ffffffffa044ccd4>] ? btrfs_run_delayed_iputs+0x35/0x104 [btrfs]
[ 2401.148493]  [<ffffffffa044bb6c>] ? __btrfs_end_transaction+0x19a/0x1a8 [btrfs]
[ 2401.148493]  [<ffffffff810f926b>] ? __d_lookup+0xc1/0x107
[ 2401.148493]  [<ffffffffa045734e>] ? btrfs_file_aio_write+0x0/0x7da [btrfs]
[ 2401.148493]  [<ffffffff810e8ce0>] ? do_sync_readv_writev+0x9a/0xd5
[ 2401.148493]  [<ffffffff810f4163>] ? do_filp_open+0x510/0x58e
[ 2401.148493]  [<ffffffff810e8a91>] ? copy_from_user+0x18/0x30
[ 2401.148493]  [<ffffffff810e97ff>] ? rw_copy_check_uvector+0x6a/0xe1
[ 2401.148493]  [<ffffffff810e991a>] ? do_readv_writev+0xa4/0x118
[ 2401.148493]  [<ffffffff812ffd81>] ? mutex_lock+0xd/0x33
[ 2401.148493]  [<ffffffff810e9ab3>] ? sys_writev+0x45/0x90
[ 2401.148493]  [<ffffffff810089c2>] ? system_call_fastpath+0x16/0x1b

 2404.104503] Call Trace:
[ 2404.104503]  [<ffffffff810bf71c>] ? kstrdup+0x2a/0x40
[ 2404.104503]  [<ffffffff810f19c4>] ? vfs_rename+0xa9/0x3e4
[ 2404.104503]  [<ffffffff810f0d29>] ? __lookup_hash+0xc2/0xe9
[ 2404.104503]  [<ffffffff810f3348>] ? sys_renameat+0x1aa/0x22b
[ 2404.104503]  [<ffffffff8108ef4f>] ? rcu_start_gp+0x1f7/0x218
[ 2404.104503]  [<ffffffff810ea13a>] ? fput+0x18f/0x1c4
[ 2404.104503]  [<ffffffff810fd9ea>] ? mntput_no_expire+0x23/0xde
[ 2404.104503]  [<ffffffff810e7829>] ? filp_close+0x5f/0x6a
[ 2404.104503]  [<ffffffff810089c2>] ? system_call_fastpath+0x16/0x1b
[ 2404.104503] Code: 44 00 00 48 89 44 24 08 fa 66 0f 1f 44 00 00 65 4c 8b 04 25 80 ea 00 00 48 8b 45 00 49 01 c0 49 8b 18 48 85 db 74 0d 48 63 45 18 <48> 8b 04 03 49 89 00 eb 14 4c 89 f9 83 ca ff 44 89 f6 48 89 ef 
[ 2404.104503] RIP  [<ffffffff810e2fef>] __kmalloc_track_caller+0xc7/0x12d

