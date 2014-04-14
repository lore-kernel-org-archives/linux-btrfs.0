Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57430 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaDNBpY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 21:45:24 -0400
Date: Sun, 13 Apr 2014 18:45:20 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: wiki vs man pages
Message-ID: <20140414014520.GA20550@merlins.org>
References: <1397184233-18535-1-git-send-email-quwenruo@cn.fujitsu.com> <20140411061048.GD7322@merlins.org> <20140411173628.GG29256@twin.jikos.cz> <20140411175226.GL7322@merlins.org> <534B36FC.3060300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534B36FC.3060300@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 14, 2014 at 09:16:44AM +0800, Qu Wenruo wrote:
> >Generally, would you agree to putting more links to the wiki in man pages
> >since man pages are not forever but sure take a long time to update on the
> >installed based and the wiki can be up to date for everyone right away?
> >(I'm not saying to remove info from the man pages, but more something like
> >"btrfs is changing quickly, more up to date information can be found on the
> >wiki page for
> >raid56: https://btrfs.wiki.kernel.org/index.php/RAID56
> >or
> >btrfsck: https://btrfs.wiki.kernel.org/index.php/Btrfsck
> >btrfs restore: https://btrfs.wiki.kernel.org/index.php/Restore
> >
> >Thanks,
> >Marc
> That's pretty nice and helpful.
> But one of my concern is that wiki changes are not shown as patches in 
> mail list and somewhat
> independent from btrfs-progs,
> so if some developers changed the behavior of RAID56/btrfsck/restore, he 
> or she may only modify the man page
> but not wiki page.
> 
> Any good idea to synchronise wiki pages and man pages?

You raise a good question.

I think the wiki should not be there to list all the options that are in the
man page. As a result, the wiki should not get out of sync with man pages.

The wiki can explain how to use the tools, like some of the pages I listed
above, or this page
http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair

A page like this explains what your options are, and what it recommended
including links to other resources.
Man pages are more "these are the options to use this specific program".
In turn the man page cannot be very long and explain all the scenario or
explain how this tools works with other tools, so it can point to the wiki
that has HOWTOs.

So to answer your question, I would say that the man pages should indeed be
updated as the programs/binaries get updated, whereas the wiki pages can get
updated as needed and refer to bugs in the kernel, or missing features, or
features that just got added/improved in kwere kernels.
And also like in the page above, generally give an overview of parts of
btrfs.

Does that make sense?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
