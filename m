From: "Ryan Hope" <rmh3093@gmail.com>
Subject: Re: btrfs_put_inode
Date: Wed, 21 May 2008 14:23:37 -0400
Message-ID: <48f7fe350805211123j1657382ew5e5e15eb6957cf79@mail.gmail.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
	 <Pine.LNX.4.64.0805022255370.15314@cobra.newdream.net>
	 <3d0408630805030025s2c9006c1qad3c29011caf3013@mail.gmail.com>
	 <200805050627.46919.chris.mason@oracle.com>
	 <Pine.LNX.4.64.0805050855250.15314@cobra.newdream.net>
	 <1211390340.5571.19.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Chris Mason" <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1211390340.5571.19.camel@BVR-FS.beaverton.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

try this patch out,
http://zen-sources.org/files/btrfs-stable-for-2.6.26-rc3.patch

it should apply to 2.6.26-rc*... probably even 2.6.25

im btrfs with 2.6.26-rc3 with no issues

On Wed, May 21, 2008 at 1:19 PM, Mingming <cmm@us.ibm.com> wrote:
> Hi Chris,
>
> btrfs failed to compile on 2.6.26-rc2 since the put_inode callback
> function is removed from super_operations.
>
> I noticed btrfs_put_inode() seems being actively used, to drop the inode
> from the tree for ordered mode transaction. Any idea where to relocate
> this function? Do we need to call btrfs_del_ordered_inode() for every
> iput()?
>
> Thanks,
> Mingming
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
