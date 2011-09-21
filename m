From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Subject: Re: [BUG] kernel BUG at fs/btrfs/relocation.c:2502!
Date: Wed, 21 Sep 2011 18:57:56 +0800
Message-ID: <CAAM7YAkPAzqgGqDE3tfDNVLqj=2gDdqZOKdM6ZOzKrD37uGoww@mail.gmail.com>
References: <4E79B712.50901@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E79B712.50901@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2011 at 6:06 PM, Liu Bo <liubo2009@cn.fujitsu.com> wrot=
e:
>
> Hi,
>
> While running my tool(attachment), I would encounter the BUG_ON, and =
I FAILED to find where went wrong :(
>
> The tool is with inode_cache option, and mainly do three things:
> a. run Chris's synctest in BACKGROUND
> b. create 100 snapshots
> c. after b, run "btrfs fi balance"
>
>
> You can follow these tips to reproduce the bug:
>
> 1) untar the attachment,
> 2) prepare 4 partitions, the mount point is default to /mnt,
> 3) $ ./2_while.sh /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdb4
> 4) then just wait several minutes and you will get the bug.
>
> NOTE:
> You MAY hit a warning and I've fixed it with this patch:
> http://marc.info/?l=3Dlinux-btrfs&m=3D131547325515336&w=3D2
>
> =3D=3D=3D
> kernel BUG at fs/btrfs/relocation.c:2502!
> [...]
> Call Trace:
> =A0[<ffffffffa03d7a6b>] ? block_rsv_add_bytes+0x2b/0x70 [btrfs]
> =A0[<ffffffffa043292f>] relocate_tree_blocks+0x60f/0x6d0 [btrfs]
> =A0[<ffffffffa0433498>] ? add_data_references+0x248/0x260 [btrfs]
> =A0[<ffffffffa0433722>] relocate_block_group+0x272/0x620 [btrfs]
> =A0[<ffffffffa0433c83>] btrfs_relocate_block_group+0x1b3/0x2d0 [btrfs=
]
> =A0[<ffffffffa0413163>] btrfs_relocate_chunk+0x93/0x6a0 [btrfs]
> =A0[<ffffffff8103bfb3>] ? __wake_up+0x53/0x70
> =A0[<ffffffffa041db42>] ? btrfs_tree_read_unlock_blocking+0x42/0x70 [=
btrfs]
> =A0[<ffffffffa04144d2>] btrfs_balance+0x212/0x2a0 [btrfs]
> =A0[<ffffffff81152459>] ? path_openat+0x109/0x3e0
> =A0[<ffffffffa041d398>] btrfs_ioctl+0x798/0xd20 [btrfs]
> =A0[<ffffffff81112ec3>] ? handle_mm_fault+0x143/0x260
> =A0[<ffffffff81474504>] ? do_page_fault+0x1d4/0x440
> =A0[<ffffffff8115562a>] do_vfs_ioctl+0x9a/0x540
> =A0[<ffffffff81155b71>] sys_ioctl+0xa1/0xb0
> =A0[<ffffffff8147896b>] system_call_fastpath+0x16/0x1b
> Code: 00 00 00 00 00 eb f6 0f 0b eb fe 0f 0b 0f 1f 84 00 00 00 00 00 =
eb f6 0f 0b eb fe 0f 0b 0f 1f 84 00 00 00 00 00 eb f6 0f 0b eb fe <0f> =
0b 0f 1f 84 00 00 00 00 00 eb f6 48 83 7a 68 00 0f 84 eb fa
> RIP =A0[<ffffffffa0430c26>] do_relocation+0x546/0x570 [btrfs]
> =A0RSP <ffff88003c0859a8>
> ---[ end trace 6a4328153ff7ff17 ]---
>
>
call btrfs_save_ino_cache in commit_fs_roots is completely wrong.
modification to fs trees is not allowed after create_pending_snapshots(=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
