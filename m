Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:56290 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab2INMmD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 08:42:03 -0400
Date: Fri, 14 Sep 2012 08:41:59 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] Btrfs: fix trans block rsv regression
Message-ID: <20120914124159.GI12994@localhost.localdomain>
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
 <1347613087-3489-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1347613087-3489-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 02:58:04AM -0600, Liu Bo wrote:
> In some workloads we have nested joining transaction operations,
> eg.
>   run_delalloc_nocow
>       btrfs_join_transaction
>       cow_file_range
>          btrfs_join_transaction
> 
> it can be a serious bug since each trans handler has only two
> block_rsv, orig_rsv and block_rsv, which means we may lose our
> first block_rsv after two joining transaction operations:
> 
> 1) btrfs_start_transaction
>       trans->block_rsv = A
> 
> 2) btrfs_join_transaction
>       trans->orig_rsv = trans->block_rsv; ---> orig_rsv is now A
>       trans->block_rsv = B
> 
> 3) btrfs_join_transaction
>       trans->orig_rsv = trans->block_rsv; ---> orig_rsv is now B
>       trans->block_rsv = C
>    ...
> 

I'd like to see the actual stack trace where this happens, because I don't think
it can happen.  And if it is we need to look at that specific case and adjust it
as necessary and not add a bunch of kmallocs just to track the block_rsv,
because frankly it's not that big of a deal, it was just put into place in case
somebody wasn't expecting a call they made to start another transaction and
reset the block_rsv, which I don't actually think happens anywhere.  So NAK on
this patch, give me more information so I can figure out the right way to deal
with this.  Thanks,

Josef
