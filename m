Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18126 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3AWIU0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 03:20:26 -0500
Date: Wed, 23 Jan 2013 16:17:53 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH 1/5] Btrfs: fix repeated delalloc work allocation
Message-ID: <20130123081751.GF17162@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <50FE6E9C.2040803@cn.fujitsu.com>
 <20130122142414.GA15978@liubo>
 <50FF50EF.9010907@cn.fujitsu.com>
 <20130123035647.GB17162@liubo.jp.oracle.com>
 <50FF6AC1.6030602@cn.fujitsu.com>
 <20130123060618.GC17162@liubo.jp.oracle.com>
 <50FF8437.3010703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FF8437.3010703@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 23, 2013 at 02:33:27PM +0800, Miao Xie wrote:
> On wed, 23 Jan 2013 14:06:21 +0800, Liu Bo wrote:
> > On Wed, Jan 23, 2013 at 12:44:49PM +0800, Miao Xie wrote:
> >> No, we can't. The other tasks which flush the delalloc data may remove the inode
> >> from the delalloc list/splice list. If we release the lock, we will meet the race
> >> between list traversing and list_del().
> > 
> > OK, then please merge patch 1 and 4 so that we can backport 1 less patch
> > at least.
> 
> I don't think we should merge these two patch because they do two different things - one
> is bug fix, and the other is just a improvement, and this improvement changes the logic
> of the code and might be argumentative for some developers. So 2 patches is  better than one,
> I think.

Sorry, this is right only when patch 1 really fixes the problem Alex reported.

But the fact is

1)  patch 1 is not enough to fix the bug, it just fixes the OOM of
allocating 'struct btrfs_delalloc_work' while the original OOM of allocating
requests remains.  We can still get the same inode over and over again
and then stuck in btrfs_start_delalloc_inodes() because we 'goto again' to
make sure we flush all inodes listed in fs_info->delalloc_inodes.

2)  patch 4 fixes 1)'s problems by removing 'goto again'.

Am I missing something?

thanks,
liubo
