Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:58638 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3CFBvS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Mar 2013 20:51:18 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 859F49A03DD
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Mar 2013 18:51:17 -0700 (MST)
Date: Tue, 5 Mar 2013 20:51:15 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Chris Mason <clmason@fusionio.com>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>,
        Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: improve the delayed inode throttling
Message-ID: <20130306015115.GD6904@shiny.masoncoding.com>
References: <20130305154017.GF30680@shiny.masoncoding.com>
 <20130306003733.GB3151@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130306003733.GB3151@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 05, 2013 at 05:37:34PM -0700, Liu Bo wrote:
> On Tue, Mar 05, 2013 at 10:40:17AM -0500, Chris Mason wrote:
> > diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> > index 0b278b1..460d1a8 100644
> > --- a/fs/btrfs/delayed-inode.c
> > +++ b/fs/btrfs/delayed-inode.c
> > +			if (!signal_pending(current))
> > +				schedule();
> 
> Do we need a 'break' here?
> 
> Like
> 
> if (!signal_pending(current))
> 	schedule();
> else
> 	break;

Seems like a good idea ;)

Thanks

-chris

