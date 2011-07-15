From: mck <mick@wever.org>
Subject: corruption.  notreelog has no effect? anything else to try?
Date: Fri, 15 Jul 2011 20:51:41 +0000
Message-ID: <1310763102.3972.31.camel@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

My laptop btrfs partition has become corrupt after a power+battery
outage.

# btrfs-show 
Label: none  uuid: e7b37e5d-c704-4ca8-ae7e-f22dd063e165
	Total devices 1 FS bytes used 116.33GB
	devid    1 size 226.66GB used 226.66GB path /dev/sda4

I typically mount w/
	-o subvol=xyz,compress,noatime,nodiratime
 and take snapshots of (some) subvolumes at every boot.
 (not that these snapshots seem to be of much use now).

Now:
btrfsck gives loads of "root x inode y errors 400" and finishes w/
    found 124906840074 bytes used err is 1
    total csum bytes: 117696892
    total tree bytes: 4385128448
    total fs tree bytes: 3926626304
    btree space waste bytes: 1078295916
    file data blocks allocated: 3619739602944
     referenced 162976624640
    Btrfs Btrfs v0.19


mounting always results in the crash 

[ 6977.513528] Call Trace:
[ 6977.513542]  [<ffffffffa057ac18>] replay_one_dir_item+0x88/0xb0 [btrfs]
[ 6977.513557]  [<ffffffffa057d5b3>] replay_one_buffer+0x223/0x330 [btrfs]
[ 6977.513573]  [<ffffffffa056a8ba>] ? alloc_extent_buffer+0x7a/0x420 [btrfs]
[ 6977.513584]  [<ffffffffa057c139>] walk_down_log_tree+0x339/0x480 [btrfs]
[ 6977.513595]  [<ffffffffa057c375>] walk_log_tree+0xf5/0x230 [btrfs]
[ 6977.513606]  [<ffffffffa057f1c1>] btrfs_recover_log_trees+0x221/0x310 [btrfs]
[ 6977.513618]  [<ffffffffa057d390>] ? replay_one_buffer+0x0/0x330 [btrfs]
[ 6977.513629]  [<ffffffffa0541353>] ? btree_read_extent_buffer_pages.clone.63+0x73/0xb0 [btrfs]
[ 6977.513642]  [<ffffffffa0544f8e>] open_ctree+0x125e/0x15c0 [btrfs]
[ 6977.513651]  [<ffffffff812e5404>] ? snprintf+0x34/0x40
[ 6977.513659]  [<ffffffffa0523e18>] btrfs_fill_super.clone.9+0x78/0x130 [btrfs]
[ 6977.513666]  [<ffffffff811cc2f4>] ? disk_name+0x64/0xc0
[ 6977.514286]  [<ffffffff812e1fe7>] ? strlcpy+0x47/0x60
[ 6977.514880]  [<ffffffffa0524223>] btrfs_mount+0x353/0x400 [btrfs]
[ 6977.515479]  [<ffffffff81149f45>] ? alloc_pages_current+0xa5/0x110
[ 6977.516077]  [<ffffffff8116745d>] vfs_kern_mount+0x8d/0x280
[ 6977.516684]  [<ffffffff811676c4>] do_kern_mount+0x54/0x110
[ 6977.517281]  [<ffffffff81184c8a>] do_mount+0x1ea/0x230
[ 6977.517885]  [<ffffffff811850b0>] sys_mount+0x90/0xe0
[ 6977.518489]  [<ffffffff8100c002>] system_call_fastpath+0x16/0x1b
[ 6977.519090] Code: ff ff 48 8b 0b 4d 89 f8 48 8b bd 78 ff ff ff 4c 89 ea 4c 89 e6 c7 04 24 01 00 00 00 e8 2a 2e fc ff 49 89 c6 e9 a1 fe ff ff 0f 0b <0f> 0b 0f 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 
[ 6977.519767] RIP  [<ffffffffa057a8e0>] replay_one_name+0x2a0/0x2b0 [btrfs]


Looking at the dump i'd thought/hoped that either "-o ro" or "-o
notreelog" might get me around the problem, but no. Neither does it
matter which subvolume i try to mount. If this is a tree log problem is
there any other way of getting around this?

At this point i've pretty much given up and am ready to restore from
backups. But thought i should take the time to report the situation...
and it there's any extra advice/recipes to savage data on offer i'm keen
to try.

I do have a btrfs-image i can upload if it's of any help...

~mck


