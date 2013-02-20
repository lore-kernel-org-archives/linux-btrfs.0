Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44086 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257Ab3BTOnR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 09:43:17 -0500
Date: Wed, 20 Feb 2013 22:42:02 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: LAST CALL FOR BTRFS-NEXT
Message-ID: <20130220144201.GD4941@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20130220142612.GA2062@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130220142612.GA2062@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 20, 2013 at 09:26:12AM -0500, Josef Bacik wrote:
> Hello,
> 
> If you have patches in btrfs-next, make sure they are the right ones so we don't
> have to rebase and repull and merge and all that crap for this merge window.  If
> I'm missing stuff that's fine, I can throw that on top, but you need to make
> sure I have the right versions of stuff already in the tree so I can rebase it
> _now_ rather than trying to figure out how to fix it later.  Thanks!

Hi Josef,

Thanks for your maintaining work.

Could you please pull this into btrfs-next?  I don't see new bug reports after
this version.

- Btrfs: snapshot-aware defrag
https://patchwork.kernel.org/patch/2058911/

thanks,
liubo

> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
