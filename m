From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: kernel BUG at fs/btrfs/tree-log.c:1669!
Date: Thu, 28 Jul 2011 09:21:35 +0800
Message-ID: <4E30B99F.9000609@cn.fujitsu.com>
References: <4E304221.5050004@yahoo.com> <20110727171339.GA23320@carfax.org.uk> <4E305C09.1020204@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: Franck Martyn <franckmartyn@yahoo.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E305C09.1020204@yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/28/2011 02:42 AM, Franck Martyn wrote:
>>>
> I've try it without succes
> Here are the log
> 
> btrfsck /dev/sdb1
> couldn't open because of unsupported option features (8).
> btrfsck: disk-io.c:682: open_ctree_fd: Assertion `!(1)' failed.
> Abandon
> 
> btrfs-zero-log /dev/sdb1
> couldn't open because of unsupported option features (8).
> btrfs-zero-log: disk-io.c:682: open_ctree_fd: Assertion `!(1)' failed.
> Abandon

This is because btrfs-progs does not update BTRFS_FEATURE_INCOMPAT_SUPP for
both lzo and mixed groups, you may go to btrfs-unstable source's ctree.h to
get real BTRFS_FEATURE_INCOMPAT_SUPP and update btrfs-progs side, then work
it out. :)

thanks,
liubo
