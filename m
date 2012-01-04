From: Christoph Hellwig <hch@infradead.org>
Subject: Re: use btrfsck to check btrfs filesystems
Date: Wed, 4 Jan 2012 13:42:24 -0500
Message-ID: <20120104184224.GB8131@infradead.org>
References: <4EE851B8.8010505@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE851B8.8010505@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 14, 2011 at 03:35:20PM +0800, Miao Xie wrote:
> We failed to get fsck program to check the btrfs file system, it is
> because btrfs uses its independent check tool which is named btrfsck
> to check the file system, so the common checker -- fsck -- could not
> find it, and reported there is no checker.
> 
> This patch fix it by using btrfsck directly. 
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Thanks, applied.

