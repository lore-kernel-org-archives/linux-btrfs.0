Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36061 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab2FRVy0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 17:54:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Sgjtw-0000IE-HF
	for linux-btrfs@vger.kernel.org; Mon, 18 Jun 2012 23:54:24 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2012 23:54:24 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2012 23:54:24 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: cannot remove files: "rm" gives "no space left on device",
 3.2.0-24, ubuntu
Date: Mon, 18 Jun 2012 21:54:14 +0000 (UTC)
Message-ID: <pan.2012.06.18.21.54.14@cox.net>
References: <CAJs9aZ9gsM-hcH-YJpgN6f_YEHrcdJfm808TuCLRKWd1qEGXwg@mail.gmail.com>
	<20120616145704.039809d2@sf.home>
	<CAJs9aZ-9EK2HUuvBDuiPSG2O5J16seO6Hp3=wJLYAJBi9KDL+Q@mail.gmail.com>
	<CAJs9aZ_C5CzyuudeUg585M4SifunchrmVDg5rXQoo7kDAsOMpw@mail.gmail.com>
	<1339910379.1538.4.camel@ierdnac-hp>
	<CAJs9aZ-bTEPyJBiLxQozu71-atP958wp95HhyfFgTb+2y2kLLA@mail.gmail.com>
	<CAKcLGm-uBVR4U+=LoMQjUbJEwZ-+FDOdLNmgc+P=gKQzC6G=jQ@mail.gmail.com>
	<CAJs9aZ94RcRR9MYC0bT81VfMuURDqA2-R2iiN3=Y_8sz7caHpw@mail.gmail.com>
	<4FDEC23F.3050704@libero.it>
	<CAJs9aZ-GHtO3JsvNqLip9CRXxg_J8RUDM=F7GLfdSqCt-zvB3w@mail.gmail.com>
	<4FDF5B99.1000000@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Mon, 18 Jun 2012 18:47:21 +0200 as
excerpted:

>>> How big was the original ext4 filesystem ?
>> 
>> 370 files with ~1GB, and 10000 small.
> 
> I am a bit confused: 370 files of about ~1GB is about a total of
> 300-400GB; instead you reported
> 
>>>> root@tv:~# btrfs filesystem df /media/388gb-data Data:
>>>> total=260.59GB,
>>>> used=251.51GB

You're probably correct on the COW from the ext4 conversion in this case, 
but just to note, in my copy (not in-place conversion) from reiserfs, I 
had ball-park-similar numbers, in my case because I was using compress on 
the btrfs side, such that the sum of dup-metadata and single data was 
still smaller than the used space on the reiserfs partition from which I 
was copying.  (I had allowed for the dup metadata and created the btrfs 
partitions somewhat larger accordingly, but compression worked enough 
better than expected that total usage was less, even with dup metadata, 
not more.   That was a nice surprise! =:^)

FWIW, that was the 3.4 kernel cycle.  I'm done testing for now, due to 
reiserfs being far better at recovery from the sata resets and graphics 
lockups plaguing me ATM.  (I need new hardware but no $$ for it ATM.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

