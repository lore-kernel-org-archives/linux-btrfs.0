From: sniper <s3c24xx@gmail.com>
Subject: Re: [PATCH] btrfs: Simplify offset calculation method for ctree.h
Date: Fri, 18 Dec 2009 12:39:50 +0800
Message-ID: <9bd6b5360912172039y432361fu243d0f05bf75b7b7@mail.gmail.com>
References: <4B2ADB4C.7010900@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756398AbZLREjz@vger.kernel.org>
In-Reply-To: <4B2ADB4C.7010900@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

No, many pointers in btrfs function arguments are not pointing to an
absolute address, but relative to the start address of extent.

Take following function as example, argument inode_item is an offset
value to the beginning of leaf. So we can't reach its member with
&inode_item->xxx

> =C2=A0static inline struct btrfs_timespec *
> =C2=A0btrfs_inode_mtime(struct btrfs_inode_item *inode_item)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 unsigned long ptr =3D (unsigned long)inode_ite=
m;
> - =C2=A0 =C2=A0 =C2=A0 ptr +=3D offsetof(struct btrfs_inode_item, mti=
me);
> - =C2=A0 =C2=A0 =C2=A0 return (struct btrfs_timespec *)ptr;
> + =C2=A0 =C2=A0 =C2=A0 return &inode_item->mtime;
> =C2=A0}
