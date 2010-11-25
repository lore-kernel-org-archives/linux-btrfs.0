From: Wenyi Liu <qingshenlwy@gmail.com>
Subject: Re: [RFC PATCH 0/4] Add readonly support to replace BUG_ON phrase
Date: Thu, 25 Nov 2010 18:57:05 +0800
Message-ID: <AANLkTindPNpp3qWjiBu7qG=YR3oM93SV17RUfeOFwDXC@mail.gmail.com>
References: <4CEE31EF.1020102@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CEE31EF.1020102@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/11/25, Miao Xie <miaox@cn.fujitsu.com>:
> Btrfs has a number of BUG_ON()s, which may lead btrfs to unpleasant panic.
> Meanwhile, they are very ugly and should be handled more propriately.
>
> There are mainly two ways to deal with these BUG_ON()s.
Yes, I agree.
>
> 1. For those errors which can be handled well by callers, we just return
> their
> error number to callers.
It's a good idea.
>
> 2. For others, We can force the filesystem readonly when it hits errors,
> which
>  is what this patchset has done. Replaced BUG_ON() with the interface
> provided
>  in this patchset, we will get error infomation via dmesg. Since btrfs is
> now
> readonly, we can save our data safely and umount it, then a btrfsck is
> recommended.
>
> By these ways, we can protect our filesystem from panic caused by those
> BUG_ONs.
>
> ---
>  fs/btrfs/ctree.h       |   21 ++++++++++
>  fs/btrfs/disk-io.c     |   23 +++++++++++
>  fs/btrfs/super.c       |  100
> ++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/transaction.c |    7 +++
>  4 files changed, 148 insertions(+), 3 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
