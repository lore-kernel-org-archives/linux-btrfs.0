From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: fix problem of wrong jump after the error
 occured
Date: Thu, 11 Feb 2010 09:03:15 -0500
Message-ID: <20100211140315.GA4188@think>
References: <4B73BAA2.1050106@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B73BAA2.1050106@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 11, 2010 at 04:06:58PM +0800, Miao Xie wrote:
> btrfs_mkdir() must jump to the place of ending transaction after
> btrfs_find_free_objectid() failed. Or this transaction can't end.
> 
> This patch fixes this problem.

Thanks, this patch is correct.

-chris
