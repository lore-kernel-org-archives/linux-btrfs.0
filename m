Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33669 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752858AbcILUfY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 16:35:24 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Pasi =?ISO-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Cc: dsterba@suse.cz, Waxhead <waxhead@online.no>, linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke? (wiki updated)
Date: Mon, 12 Sep 2016 22:35:20 +0200
Message-ID: <2026673.ODgFlz56RI@merkaba>
In-Reply-To: <20160912202109.GL28465@reaktio.net>
References: <57D51BF9.2010907@online.no> <6762481.5JxuKd9axT@merkaba> <20160912202109.GL28465@reaktio.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 12. September 2016, 23:21:09 CEST schrieb Pasi Kärkkäinen:
> On Mon, Sep 12, 2016 at 09:57:17PM +0200, Martin Steigerwald wrote:
> > Am Montag, 12. September 2016, 18:27:47 CEST schrieb David Sterba:
> > > On Mon, Sep 12, 2016 at 04:27:14PM +0200, David Sterba wrote:
> > > > > I therefore would like to propose that some sort of feature /
> > > > > stability
> > > > > matrix for the latest kernel is added to the wiki preferably
> > > > > somewhere
> > > > > where it is easy to find. It would be nice to archive old matrix'es
> > > > > as
> > > > > well in case someone runs on a bit older kernel (we who use Debian
> > > > > tend
> > > > > to like older kernels). In my opinion it would make things bit
> > > > > easier
> > > > > and perhaps a bit less scary too. Remember if you get bitten badly
> > > > > once
> > > > > you tend to stay away from from it all just in case, if you on the
> > > > > other
> > > > > hand know what bites you can safely pet the fluffy end instead :)
> > > > 
> > > > Somebody has put that table on the wiki, so it's a good starting
> > > > point.
> > > > I'm not sure we can fit everything into one table, some combinations
> > > > do
> > > > not bring new information and we'd need n-dimensional matrix to get
> > > > the
> > > > whole picture.
> > > 
> > > https://btrfs.wiki.kernel.org/index.php/Status
> > 
> > Great.
> > 
> > I made to minor adaption. I added a link to the Status page to my warning
> > in before the kernel log by feature page. And I also mentioned that at
> > the time the page was last updated the latest kernel version was 4.7.
> > Yes, thats some extra work to update the kernel version, but I think its
> > beneficial to explicitely mention the kernel version the page talks
> > about. Everyone who updates the page can update the version within a
> > second.
> 
> Hmm.. that will still leave people wondering "but I'm running Linux 4.4, not
> 4.7, I wonder what the status of feature X is.."
> 
> Should we also add a column for kernel version, so we can add "feature X is
> known to be OK on Linux 3.18 and later"..  ? Or add those to "notes" field,
> where applicable?

That was my initial idea, and it may be better than a generic kernel version 
for all features. Even if we fill in 4.7 for any of the features that are 
known to work okay for the table.

For RAID 1 I am willing to say it works stable since kernel 3.14, as this was 
the kernel I used when I switched /home and / to Dual SSD RAID 1 on this 
ThinkPad T520.


-- 
Martin
