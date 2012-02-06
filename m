From: cwillu <cwillu@cwillu.com>
Subject: Re: Btrfs out of inodes becomes corrupt
Date: Mon, 6 Feb 2012 05:33:51 -0600
Message-ID: <CAE5mzvhwSLqBEMEOZo8Xxx63LciYLAxYWzVrQP+7qk_tgyRvwA@mail.gmail.com>
References: <b0ee762c11692ea16e81a34469311c14@localhost>
	<20120205195742.GC19330@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>,
	Tommy Faasen <tommy@zwanebloem.nl>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120205195742.GC19330@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

>> [11138.535482] device fsid 808bddf9-a2c5-4121-814f-ebbf4ec7d50c devi=
d 1
>> transid 11368 /dev/vda1
>> [11276.469967] ------------[ cut here ]------------
>> [11276.469980] WARNING: at
>> /build/buildd/linux-3.0.0/fs/btrfs/extent-tree.c:5693
>> use_block_rsv+0xc0/0x170 [btrfs]()
>> [11276.469982] Hardware name: Bochs
>> [11276.469983] Modules linked in: btrfs zlib_deflate libcrc32c nls_u=
tf8
>> isofs rfcomm bnep bluetooth parport_pc ppdev dm_crypt joydev binfmt_=
misc
>> psmouse serio_raw i2c_piix4 lp parport usbhid hid virtio_net virtio_=
blk
>> floppy virtio_pci virtio_ring virtio
>> [11276.469999] Pid: 2160, comm: mount Not tainted 3.0.0-13-generic
>> #22-Ubuntu
>> [11276.470001] Call Trace:
>> [11276.470016] =C2=A0[<ffffffff8105e8af>] warn_slowpath_common+0x7f/=
0xc0
>> [11276.470019] =C2=A0[<ffffffff8105e90a>] warn_slowpath_null+0x1a/0x=
20
>> [11276.470025] =C2=A0[<ffffffffa014bc40>] use_block_rsv+0xc0/0x170 [=
btrfs]
>> [11276.470031] =C2=A0[<ffffffffa0154e7d>] btrfs_alloc_free_block+0x3=
d/0x200
>> [btrfs]
>> [11276.470040] =C2=A0[<ffffffffa017ca55>] ? btrfs_key_blockptr+0xe5/=
0xf0
>> [btrfs]
>> [11276.470045] =C2=A0[<ffffffffa014277c>] __btrfs_cow_block+0x14c/0x=
5b0 [btrfs]
>> [11276.470050] =C2=A0[<ffffffffa0142cf3>] btrfs_cow_block+0x113/0x26=
0 [btrfs]
>> [11276.470053] =C2=A0[<ffffffff815ea3de>] ? _raw_spin_lock+0xe/0x20
>> [11276.470058] =C2=A0[<ffffffffa0147751>] btrfs_search_slot+0x2b1/0x=
550 [btrfs]
>> [11276.470064] =C2=A0[<ffffffffa014d829>]
>> lookup_inline_extent_backref+0x89/0x450 [btrfs]
>> [11276.470069] =C2=A0[<ffffffffa014e1b0>] lookup_extent_backref+0x60=
/0xf0
>> [btrfs]
>> [11276.470074] =C2=A0[<ffffffffa014f62f>] __btrfs_free_extent+0xbf/0=
x650
>> [btrfs]
>> [11276.470079] =C2=A0[<ffffffffa014fcd4>] run_delayed_tree_ref+0x114=
/0x1a0
>> [btrfs]
>> [11276.470085] =C2=A0[<ffffffffa015281e>] run_one_delayed_ref+0xae/0=
xf0 [btrfs]
>> [11276.470091] =C2=A0[<ffffffffa0152934>] run_clustered_refs+0xd4/0x=
240 [btrfs]
>> [11276.470096] =C2=A0[<ffffffffa0152b6a>] btrfs_run_delayed_refs+0xc=
a/0x220
>> [btrfs]
>> [11276.470103] =C2=A0[<ffffffffa0164105>] __btrfs_end_transaction+0x=
85/0x320
>> [btrfs]
>> [11276.470111] =C2=A0[<ffffffffa0164415>] btrfs_end_transaction+0x15=
/0x20
>> [btrfs]
>> [11276.470121] =C2=A0[<ffffffffa016e960>] btrfs_evict_inode+0x1e0/0x=
270 [btrfs]
>> [11276.470134] =C2=A0[<ffffffff81181e81>] evict+0x91/0x170
>> [11276.470137] =C2=A0[<ffffffff81182082>] iput_final+0xd2/0x1a0
>> [11276.470139] =C2=A0[<ffffffff81182188>] iput+0x38/0x50
>> [11276.470145] =C2=A0[<ffffffffa016ee6c>] btrfs_orphan_cleanup+0x1ec=
/0x360
>> [btrfs]
>> [11276.470151] =C2=A0[<ffffffffa0161d29>] open_ctree+0x1469/0x1760 [=
btrfs]
>> [11276.470156] =C2=A0[<ffffffffa013e438>] btrfs_fill_super.isra.38+0=
x78/0x150
>> [btrfs]
>> [11276.470167] =C2=A0[<ffffffff811cf501>] ? disk_name+0x61/0xc0
>> [11276.470174] =C2=A0[<ffffffff812efbd7>] ? strlcpy+0x47/0x60
>> [11276.470179] =C2=A0[<ffffffffa013f806>] btrfs_mount+0x3c6/0x470 [b=
trfs]
>> [11276.470182] =C2=A0[<ffffffff8116ae13>] mount_fs+0x43/0x1b0
>> [11276.470186] =C2=A0[<ffffffff8118565a>] vfs_kern_mount+0x6a/0xc0
>> [11276.470188] =C2=A0[<ffffffff81186a54>] do_kern_mount+0x54/0x110
>> [11276.470190] =C2=A0[<ffffffff811884f4>] do_mount+0x1a4/0x260
>> [11276.470192] =C2=A0[<ffffffff81188990>] sys_mount+0x90/0xe0
>> [11276.470196] =C2=A0[<ffffffff815f27c2>] system_call_fastpath+0x16/=
0x1b
>> [11276.470197] ---[ end trace eeca3fbe2d1be463 ]---
>
> =C2=A0 It's not obvious (without me digging into the 2.6.32 code, whi=
ch
> I'm not going to do) which tree this is failing in, but if -o recover=
y
> doesn't work, you could try using btrfs-zero-log on the FS. That _may=
_
> help.

Simply mounting with 3.1 or later should take care of that bit; the
bug here was actually in the replay, and is fixed in 3.1 and newer.

>> I tried to mount the partition under linux mint which has kernel 3.0=
=2Ex.
>
>  3.0 is two revisions old -- something on the order of 6
> months. There's been a lot of development since then, too. You really
> should be running 3.2 or 3.2-rc2 (i.e. the latest released or latest
> development version of the kernel).

I think you meant 3.2 or 3.3-rc2.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
