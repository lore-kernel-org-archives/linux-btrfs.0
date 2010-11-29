From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC PATCH 0/4] Add readonly support to replace BUG_ON phrase
Date: Mon, 29 Nov 2010 15:10:18 -0500
Message-ID: <20101129201017.GB2618@localhost.localdomain>
References: <4CEE31EF.1020102@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CEE31EF.1020102@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 25, 2010 at 05:52:47PM +0800, Miao Xie wrote:
> Btrfs has a number of BUG_ON()s, which may lead btrfs to unpleasant panic.
> Meanwhile, they are very ugly and should be handled more propriately.
> 
> There are mainly two ways to deal with these BUG_ON()s.
> 
> 1. For those errors which can be handled well by callers, we just return their
> error number to callers.
> 
> 2. For others, We can force the filesystem readonly when it hits errors, which
>  is what this patchset has done. Replaced BUG_ON() with the interface provided
>  in this patchset, we will get error infomation via dmesg. Since btrfs is now 
> readonly, we can save our data safely and umount it, then a btrfsck is 
> recommended.
> 
> By these ways, we can protect our filesystem from panic caused by those 
> BUG_ONs.
> 
> ---
>  fs/btrfs/ctree.h       |   21 ++++++++++
>  fs/btrfs/disk-io.c     |   23 +++++++++++
>  fs/btrfs/super.c       |  100 ++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/transaction.c |    7 +++
>  4 files changed, 148 insertions(+), 3 deletions(-)
> 

Overall seems sane, but what about kernels that don't make these checks?  I'm ok
with "well sucks for them" as an answer, just want to make sure we've at least
though about it.

Also I'm not sure marking the fs as broken is the right move here.  Ext3/4 don't
do this, they just mount read-only, as long as you can still unmount the
filesystem everything comes out ok.  Think of the case where we just get a
spurious EIO, the fs should be fine the next time around, there's reason to
force the user to run fsck in this case.

Thanks,

Josef
