Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44680 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaFFUAL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jun 2014 16:00:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wt0J7-0005Iz-O6
	for linux-btrfs@vger.kernel.org; Fri, 06 Jun 2014 22:00:09 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 22:00:09 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 22:00:09 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Very slow filesystem
Date: Fri, 6 Jun 2014 19:59:55 +0000 (UTC)
Message-ID: <pan$8b124$462edb2f$89da01c1$20a210a8@cox.net>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
	<pan$765af$b28af9a8$903ce16b$940baf34@cox.net>
	<CAEezp7sxyEP2Bmp9vWB843pb7VQvWyHmG+1uPU_Dk--hhu2LAw@mail.gmail.com>
	<CAGqmi77dGTaZOT8u=XDMnYnDxhNoWhrhjZtHpD35OB28VvY8YQ@mail.gmail.com>
	<pan$95296$7c52a8f8$5f80de1d$977b2dd9@cox.net>
	<CAKcLGm8fFX-Hqz0iEgk2qtsUXrSNW=XsKMHiVWZvV4AoJCBGVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mitch Harder posted on Fri, 06 Jun 2014 14:06:53 -0500 as excerpted:

> Every time you update your database, btrfs is going to update whichever
> 128 KiB blocks need to be modified.
> 
> Even for a tiny modification, the new compressed block may be slightly
> more or slightly less than 128 KiB.

FWIW, I believe that's 128 KiB pre-compression.  And at least without 
compress-force, btrfs will try the compression and if the compressed size 
is larger than the uncompressed size, it simply won't compress that 
block.  So 128 KiB is the largest amount of space that 128 KiB of data 
could take with compression on, but it can be half that or less if the 
compression happens to be good for that 128 KiB block.

> If you have a 1-2 GB database that is being updated with any frequency,
> you can see how you will quickly end up with lots of metadata
> fragmentation as well as inefficient data block utilization.
> I think this will be the case even if you switch to NOCOW due to the
> compression.

That is one reason that, as I said, NOCOW turns off compression.  
Compression simply doesn't work well with in-place updates, because as 
you point out, the update may compress more or less well than the 
original, and that won't work in-place.  So NOCOW turns off compression 
to avoid the problem.  

If its COW (that is, not NOCOW), then the COW-based out-of-place-updates 
avoid the problem of fitting more data in the same space, because the new 
write can take more space in the new location if it has to.

But you are correct that compression and large, frequently updated 
databases don't play well together either.  Which is why turning off 
compression when turning off COW isn't the big problem it would first 
appear to be -- as it happens, the very same files where COW doesn't work 
well, are also the ones where compression doesn't work well.

Similarly for checksumming.  When there are enough updates, in addition 
to taking more time to calculate and write, checksumming simply invites 
race conditions between the last then-valid checksum and the next update 
invalidating it.  In addition, in many, perhaps most cases, the sorts of 
apps that do constant internal updates, have already evolved their own 
data integrity verification methods in ordered to cope with issues on the 
after all way more common unverified filesystems, creating even more 
possible race conditions and timing issues and making all that extra work 
that btrfs normally does for verification unnecessary.  Trying to do all 
that in-place due to NOCOW is a recipe for failure or insanity if not both

So when turning off COW, just turning off checksumming/verification and 
compression along with it makes the most sense, and that's what btrfs 
does.  To do otherwise is just asking for trouble, which is why you very 
rarely see in-place-update-by-default filesystems offering either 
transparent compression or data verification as features.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

