Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51225 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbaGVVNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 17:13:55 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: Cody P Schafer <dev@codyps.com>, Chris Samuel <chris@csamuel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: Blocked tasks on 3.15.1
Date: Tue, 22 Jul 2014 23:13:53 +0200
Message-ID: <5008370.djvLzDh1Vh@merkaba>
In-Reply-To: <53CE7ACF.7070109@fb.com>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com> <1745216.hDa4tC2HJJ@merkaba> <53CE7ACF.7070109@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 22. Juli 2014, 10:53:03 schrieb Chris Mason:
> On 07/19/2014 02:23 PM, Martin Steigerwald wrote:
> >> Running 3.15.6 with this patch applied on top:
> >>  - still causes a hang with `rsync -hPaHAXx --del /mnt/home/nyx/
> >>  /home/nyx/`
> >> 
> >> - no extra error messages printed (`dmesg | grep racing`) compared to
> >> without the patch
> > 
> > I got same results with 3.16-rc5 + this patch (see thread BTRFS hang with
> > 3.16-rc5). 3.16-rc4 still is fine with me. No hang whatsoever so far.
> > 
> >> To recap some details (so I can have it all in one place):
> >>  - /home/ is btrfs with compress=lzo
> > 
> > BTRFS RAID 1 with lzo.
> > 
> >>  - I have _not_ created any nodatacow files.
> > 
> > Me neither.
> > 
> >>  - Full stack is: sata <-> dmcrypt <-> lvm <-> btrfs (I noticed others
> >> 
> >> mentioning the use of dmcrypt)
> > 
> > Same, except no dmcrypt.
> 
> Thanks for the help in tracking this down everyone.  We'll get there!
> Are you all running multi-disk systems (from a btrfs POV, more than one
> device?)  I don't care how many physical drives this maps to, just does
> btrfs think there's more than one drive.

As I told before I am using BTRFS RAID 1. Two logival volumes on two distinct 
SSDs. RAID is directly in BTRFS, no SoftRAID here (which I wouldn´t want to 
use with SSDs anyway).

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
