Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39713 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbcILT5V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 15:57:21 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: dsterba@suse.cz, Waxhead <waxhead@online.no>, linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke? (wiki updated)
Date: Mon, 12 Sep 2016 21:57:17 +0200
Message-ID: <6762481.5JxuKd9axT@merkaba>
In-Reply-To: <20160912162747.GF16983@twin.jikos.cz>
References: <57D51BF9.2010907@online.no> <20160912142714.GE16983@twin.jikos.cz> <20160912162747.GF16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 12. September 2016, 18:27:47 CEST schrieb David Sterba:
> On Mon, Sep 12, 2016 at 04:27:14PM +0200, David Sterba wrote:
> > > I therefore would like to propose that some sort of feature / stability
> > > matrix for the latest kernel is added to the wiki preferably somewhere
> > > where it is easy to find. It would be nice to archive old matrix'es as
> > > well in case someone runs on a bit older kernel (we who use Debian tend
> > > to like older kernels). In my opinion it would make things bit easier
> > > and perhaps a bit less scary too. Remember if you get bitten badly once
> > > you tend to stay away from from it all just in case, if you on the other
> > > hand know what bites you can safely pet the fluffy end instead :)
> > 
> > Somebody has put that table on the wiki, so it's a good starting point.
> > I'm not sure we can fit everything into one table, some combinations do
> > not bring new information and we'd need n-dimensional matrix to get the
> > whole picture.
> 
> https://btrfs.wiki.kernel.org/index.php/Status

Great.

I made to minor adaption. I added a link to the Status page to my warning in 
before the kernel log by feature page. And I also mentioned that at the time 
the page was last updated the latest kernel version was 4.7. Yes, thats some 
extra work to update the kernel version, but I think its beneficial to 
explicitely mention the kernel version the page talks about. Everyone who 
updates the page can update the version within a second.

-- 
Martin
