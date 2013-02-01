Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60582 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3BAUs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Feb 2013 15:48:28 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: /home on BTRFS on SSD, now highly fragmenting virtuoso database - use autodefrag?
Date: Fri, 1 Feb 2013 21:48:20 +0100
Cc: Hugo Mills <hugo@carfax.org.uk>
References: <201301311444.12314.Martin@lichtvoll.de> <20130131215810.GO16285@carfax.org.uk> (sfid-20130201_000531_601694_2DCE9020)
In-Reply-To: <20130131215810.GO16285@carfax.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201302012148.20899.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 31. Januar 2013 schrieb Hugo Mills:
> On Thu, Jan 31, 2013 at 02:44:12PM +0100, Martin Steigerwald wrote:
> > Hi!
> > 
> > Today I converted my /home from Ext4 to BTRFS by reformatting and copying
> > all over again.
> > 
> > I created the filesystem with -l 16384 -n 16384 -d single -m single on an
> > logical volume Intel SSD 320 and mount with compress=lzo,spacecache. Current state:
> 
>    The way that compression is implemented in btrfs, compressed files
> always look fragmented, even if they're not. Basically, each
> compression block shows up as a single fragment. If the blocks are
> next to each other, the file's not actually fragmented, but still
> looks like it to fiemap.

Ah, thanks. Thats interesting to know.

> [snip]
> > Except for a highly fragmenting file:
> > 
> > martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> ls -lh
> > insgesamt 1,2G
> > -rw------- 1 martin martin 1,3G Jan 31 14:07 soprano-virtuoso.db
> > -rw-r--r-- 1 martin martin   14 Jan 31 14:06 soprano-virtuoso.lck
> > -rw------- 1 martin martin    0 Jan 27 17:52 soprano-virtuoso.lock
> > -rw-r--r-- 1 martin martin  13K Jan 31 10:22 soprano-virtuoso.log
> > -rw-r--r-- 1 martin martin    0 Jan 27 17:52 soprano-virtuoso.pxa
> > -rw-r--r-- 1 martin martin 8,0M Jan 31 14:07 soprano-virtuoso-temp.db
> > -rw-r--r-- 1 martin martin  14K Jan 31 14:07 soprano-virtuoso.trx
> > 
> > 
> > martin@merkaba:~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> sudo filefrag soprano-virtuoso.db
> > [sudo] password for martin: 
> > soprano-virtuoso.db: 481 extents found
> > […]
> 
> > Now I do not perceive any bottle neck so far and this is an SSD.
> > 
> > What would be your recommendation: Add autodefrag to mount options or not?
> 
>    For an SSD, probably not worth it.

Thanks. I then will use what I advice attendees to my Linux Performance
Analysis & Performance trainings and what XFS guys are also advicing:

Use the defaults

(unless you know otherwise).

Especially since I think the Intel SSD 320 is one of the better ones and
desktop search is really snappy up to know.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
