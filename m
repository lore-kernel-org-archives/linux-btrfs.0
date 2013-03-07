Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:40955 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3CGDGw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2013 22:06:52 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 761F89A0368
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Mar 2013 20:06:52 -0700 (MST)
Date: Wed, 6 Mar 2013 22:06:50 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Chris Mason <clmason@fusionio.com>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: improve the delayed inode throttling
Message-ID: <20130307030650.GB13323@shiny.masoncoding.com>
References: <20130305154017.GF30680@shiny.masoncoding.com>
 <5136ADCE.9090405@cn.fujitsu.com>
 <20130306145328.GE6904@shiny.masoncoding.com>
 <5137EFD2.5060704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5137EFD2.5060704@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 06, 2013 at 06:39:30PM -0700, Miao Xie wrote:
> On wed, 6 Mar 2013 09:53:28 -0500, Chris Mason wrote:
> [SNIP]
> > +	async_work->delayed_root = delayed_root;
> > +	async_work->work.func = btrfs_async_run_delayed_root;
> > +	async_work->work.flags = 0;
> > +	if (nr)
> > +		async_work->nr = 0;
> > +	else
> > +		async_work->nr = nr;
> 
> the code here is wrong.
> the argument nr is the number we want to deal with, if it is 0, we will deal with all.

Whoops, thanks.  I missed that when I was cleaning things up.

> >  
> > -	btrfs_wq_run_delayed_node(delayed_root, root, 0);
> > +	btrfs_wq_run_delayed_node(delayed_root, root, BTRFS_DELAYED_BATCH);
> >  }
> 
> There is a problem that we may introduce lots of btrfs_works, we need avoid
> it.

It is possible, but we won't make more than we used to.  The real
solution is to limit the workers per root, but the code isn't currently
structured for that.  Right now the workers will exit out if the number
of pending items is below the delayed limit, which isn't perfect but I
think it's the best I can do right now.

Do you see better ways to improve it?
