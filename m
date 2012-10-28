Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37330 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2J1NWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 09:22:38 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: kreijack@inwind.it
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Date: Sun, 28 Oct 2012 14:22:36 +0100
Cc: Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <50899151.1070503@inwind.it> <20121028111858.GC2381@yeono.kjorling.se> <508D2430.9020006@inwind.it> (sfid-20121028_141611_560384_7EFCC698)
In-Reply-To: <508D2430.9020006@inwind.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210281422.37024.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 28. Oktober 2012 schrieb Goffredo Baroncelli:
> On 2012-10-28 12:18, Michael Kjörling wrote:
> > On 28 Oct 2012 11:59 +0100, from kreijack@gmail.com (Goffredo 
Baroncelli):
> >> On 2012-10-28 11:38, Martin Steigerwald wrote:
> >>> But still if if can be arbitrarily long due to that per object
> >>> replication  config, a vertical output might and leaving graphical
> >>> representation to a Qt Quick application or so might be better.
> >> 
> >> Yes, this is my same feel: For console I prefer a text
> >> representation in rows, leaving to a graphical GUI to show the
> >> information in columns..
> >
> > 
> >
> > So a sysadmin who logs on to a server (which uses btrfs) over plain
> > SSH should need to install a good chunk of X11 plus a load of support
> > libraries on the server, plus have a X11 server on the machine they
> > are connecting from, simply to get a tabular view of the disk space?
> 
> As reported in another email, I like the tabular format. The point is
> that it is not usable because the combination of Chunk-type (Data,
> Metadata, System) and Profile (DUP, Single, RAID1, RAID10,
> RAID0...RAID5/6) doesn't fit in 80 columns width.
> Even tough the simple case (Only one profile, Data,Metadata,System
> chunk type) could fit, this solution doesn't scale when will be
> possible to select different profiles per subvolume basis.
> 
> [...]

The vertical output makes it quite difficult to spot unbalanced drives 
tough.

A simplified output might help:

Just show how much is used/unused on each drive. This helps the usecase to 
spot unbalanced drives, I think. And it can fit in tabular output.

I think its good to go from the use cases. What questions may the user 
have and how to answer them in a clear and concise way?

Then for details the vertical output might be a good option.

Anyway, I think first go for the summary thing… since I think that is 
clear.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
