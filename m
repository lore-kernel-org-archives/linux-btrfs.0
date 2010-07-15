From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG] btrfs hangup when we run the "sync" command
Date: Thu, 15 Jul 2010 12:12:13 -0400
Message-ID: <20100715161213.GG8623@think>
References: <4C3E7E1B.5000002@cn.fujitsu.com>
 <AANLkTinkuiT9tBiALkCIDMs9d9J9FT9sl9GEyRogq09S@mail.gmail.com>
 <4C3ECFBB.40006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Yan, Zheng" <zheng.yan@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C3ECFBB.40006@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 15, 2010 at 05:07:07PM +0800, Miao Xie wrote:
> On Thu Jul 15 2010 16:14:31 GMT+0800 (CST), Yan, Zheng wrote:
> >2010/7/15 Miao Xie<miaox@cn.fujitsu.com>:
> >>Hi, everyone
> >>
> >>I found btrfs will hangup when we run the sync command on my
> >>x86_64 box.
> >>
> >>The reproduce steps is following:
> >># mkfs.btrfs -s 8192 -l 8192 -n 8192 /dev/sda1
> >># mount /dev/sda1 /mnt
> >># echo 1234567>  /mnt/aaa
> >># sync
> >>(btrfs hangs up)
> >>
> >>It seems that the btrfs doesn't support the sectorsize which is
> >>greater than the page size just like ext2/3/4, though we can use
> >>mkfs.btrfs to make a filesystem with a big sectorsize. Am I right?
> >>
> >>If yes, we must do more check in the mkfs.btrfs.
> >>
> >
> >yes, btrfs doesn't support the sectorsize>  PAGE_size.
> >
> 
> So we must do more check in the mkfs.btrfs to avoid misuse, and I'll
> add some check of the sectorsize into the mkfs.btrfs.

Yes, but this is fixed up with the raid code, we'll allow different page
sizes.

> 
> BTW, I sent some patches to the btrfs community recently, but I haven't received
> any reply. Could you review them for me? though I have tested them and everything
> works well.
> 
> [PATCH 1/2] btrfs: restructure try_release_extent_buffer()
> [PATCH 2/2] btrfs: fix oops when leafsize is greator than nodesize
> [PATCH] btrfs-progs: fix wrong extent buffer size when reading tree block

Thanks, I'll go through these.

-chris
