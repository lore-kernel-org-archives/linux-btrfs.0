Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44496 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933764Ab2LIKNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 05:13:47 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
Date: Sun, 9 Dec 2012 11:13:45 +0100
Cc: Jan Engelhardt <jengelh@inai.de>,
        =?iso-8859-1?q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
References: <50714AC8.4010100@petaramesh.org> <201210071648.54027.Martin@lichtvoll.de> <alpine.LNX.2.01.1212090614400.31120@nerf07.vanv.qr> (sfid-20121209_110802_169559_532F2DD4)
In-Reply-To: <alpine.LNX.2.01.1212090614400.31120@nerf07.vanv.qr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201212091113.45283.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 9. Dezember 2012 schrieb Jan Engelhardt:
> On Sunday 2012-10-07 16:48, Martin Steigerwald wrote:
> >> 
> >> # btrfs su li /
> >> ID 256 top level 5 path UBUNTU
> >> ID 259 top level 5 path UBUNTU/@
> >> ID 261 top level 5 path UBUNTU/@tmp
> >> ID 262 top level 5 path UBUNTU/@home
> >>[...]
> >
> >This could be 100 or more subvolumes / snapshots.
> >Maybe slowness could be related to this one.
> 
> Absolutely. COW snapshots cause severe fragmentation (it's
> in their nature). "Easily" reproducible by snapshotting an fs
> every day. Been there, had that.

So such a workload is only possible with pleasing speed with SSD?

I have about 5-10 snapshots on my backup 2TB eSATA disk which I currently
rsync to. This seems to work quite well still. But I have no idea how that
would turn out with 100 snapshots or more. And about 1 TB is free, so at
least I´d expect no serious freespace fragmentation like on the BTRFS in
my SSD (extra post for that one).

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
