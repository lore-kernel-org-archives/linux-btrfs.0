Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43016 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaIWGp4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 02:45:56 -0400
Date: Tue, 23 Sep 2014 14:45:44 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: nick <yocto6@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Sparse Warnings about locks in extent-tree.c
Message-ID: <20140923064543.GA3337@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <5420D38F.9060903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5420D38F.9060903@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 22, 2014 at 09:57:35PM -0400, nick wrote:
> Hello Btfs Developers,
> I am new so am unsure of how to fix this but we are hitting some sparse warnings about unlock/lock is having 
> a wrong count when exiting certain functions in extent-tree.c. I will paste the warnings below for you guys.
> Hope this is of help.
> Cheers,
> Nick  
> fs/btrfs/extent-tree.c:6386:39: warning: context imbalance in 'btrfs_lock_cluster' - wrong count at exit
> fs/btrfs/extent-tree.c:6663:44: warning: context imbalance in 'find_free_extent' - unexpected unlock
> fs/btrfs/extent-tree.c:8810:9: warning: context imbalance in 'btrfs_put_block_group_cache' - wrong count at exit

Hi Nick,

What program is producing these warning?  It looks like a static code analysis
tool or something.

thanks,
-liubo
