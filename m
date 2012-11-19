Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39243 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab2KSH70 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Nov 2012 02:59:26 -0500
Date: Mon, 19 Nov 2012 15:58:55 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dave@jikos.cz
Cc: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix a deadlock in aborting transaction due to
 ENOSPC
Message-ID: <20121119075853.GA31552@gmail.com>
Reply-To: Liu Bo <bo.li.liu@oracle.com>
References: <1352119329-18716-1-git-send-email-bo.li.liu@oracle.com>
 <20121116141948.GA3102@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121116141948.GA3102@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 16, 2012 at 03:19:49PM +0100, David Sterba wrote:
> On Mon, Nov 05, 2012 at 08:42:08PM +0800, Liu Bo wrote:
> > When committing a transaction, we may bail out of running delayed refs
> > due to ENOSPC, and then abort the current transaction to flip into readonly.
> > 
> > But we'll hit a deadlock on ref head's lock since we forget to release
> > its lock and other cleanup stuff.
> 
> Miao sent a patch for this on Tue, 08 May 2012
> 
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16361.html
> 
> and it does more things than just the unlock, I can't tell which one of
> the patches is the right one, only letting you know.
> 

Thanks for pointing that, David.  Yes, that patch will work.

Miao, can you send it here again?
[PATCH] Btrfs: fix deadlock when the process of delayed refs fails

thanks,
liubo


> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
