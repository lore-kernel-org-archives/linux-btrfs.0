Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52125 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbbL1Bsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 20:48:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDMvS-0007cd-A6
	for linux-btrfs@vger.kernel.org; Mon, 28 Dec 2015 02:48:42 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 02:48:42 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 02:48:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
Date: Mon, 28 Dec 2015 01:48:37 +0000 (UTC)
Message-ID: <pan$c7935$46be3379$4afc60bd$677c85c5@cox.net>
References: <567FEEB6.3080701@online.no>
	<CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
	<56806F06.50309@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Waxhead posted on Mon, 28 Dec 2015 00:06:46 +0100 as excerpted:

> btrfs scrub status /mnt scrub status for
> 2832346e-0720-499f-8239-355534e5721b
>          scrub started at Sun Mar 29 23:21:04 2015 and finished after
> 00:01:04
>          total bytes scrubbed: 1.97GiB with 14549 errors error details:
>          super=2 csum=14547 corrected errors: 0, uncorrectable errors:
>          14547, unverified
> errors: 0
> 
> Now here is the first worrying part... it says that scrub started at Sun
> Mar 29. That is NOT true, the first scrub I did on this filesystem was a
> few days ago and it claims it is a lot of uncorrectable errors. Why?
> This is after all a raid6 filesystem correct?!

Hmm...  The status is stored in readable plain-text files in /var/lib/
btrfs/scrub.status.*, where the * is the UUID.  If you check there, the 
start time (t_start) seems to be in POSIX time.

Is it possible you were or are running the scrub from, for instance, a 
rescue image that might not set the system time correctly and that falls 
back to, say, the date the rescue image was created, if it can't get 
network connectivity or some such?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

