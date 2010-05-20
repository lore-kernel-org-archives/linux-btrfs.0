From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/10] btrfs: fix wrong ctime when adding link
Date: Thu, 20 May 2010 04:33:00 -0400
Message-ID: <20100520083300.GB11920@infradead.org>
References: <4BF4E336.40603@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BF4E336.40603@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 20, 2010 at 03:22:30PM +0800, Miao Xie wrote:
> the ctime of file has not been updated when I create a link for it.
> 
> Steps to reproduce:
>  # touch file1
>  # stat -c %Z file1
>  1273592239
>  # link flink1 file1
>  # stat -c %Z file1
>  1273592239             <-- have not been updated
> 
> This patch fix this problem.

Care to add a test to xfstests to check for this regression?

