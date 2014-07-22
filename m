Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52436 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaGVQr1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 12:47:27 -0400
Date: Tue, 22 Jul 2014 09:46:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, Cody P Schafer <dev@codyps.com>,
        Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
Subject: Re: Blocked tasks on 3.15.1
Message-ID: <20140722164646.GB27916@merlins.org>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
 <53C7CD0F.7070603@fb.com>
 <CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com>
 <1745216.hDa4tC2HJJ@merkaba>
 <53CE7ACF.7070109@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53CE7ACF.7070109@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 22, 2014 at 10:53:03AM -0400, Chris Mason wrote:
> Thanks for the help in tracking this down everyone.  We'll get there!
> Are you all running multi-disk systems (from a btrfs POV, more than one
> device?)  I don't care how many physical drives this maps to, just does
> btrfs think there's more than one drive.

In the bugs I sent you, it was a mix of arrays that were
mdraid / dmcrypt / btrfs

I have also one array with:
disk1 / dmcrypt \
                 - btrfs (2 drives visible by btrfs)
disk2 / dmcrypt /

The multidrive setup seemed a bit worse, I just destroyed it and went
back to putting all the drives together with mdadm and showing a single
dmcrypted device to btrfs.

But that is still super unstable on my server with 3.15, while being
somewhat usable with my laptop (it still hangs, but more rarely)
The one difference is that my laptop actually does
disk > dmcrypt > btrfs
while my server does 
disks > mdadm > dmcrypt > btrfs

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
