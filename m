Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36439 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbbLTJA0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Dec 2015 04:00:26 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aAZqm-0005vW-Al
	for linux-btrfs@vger.kernel.org; Sun, 20 Dec 2015 10:00:20 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Dec 2015 10:00:20 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Dec 2015 10:00:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fwd: Re: Bug#808265: e2fsprogs: support btrfs compression in
 filefrag
Date: Sun, 20 Dec 2015 09:00:14 +0000 (UTC)
Message-ID: <pan$7ef4e$d027fedc$245dafe8$58265d51@cox.net>
References: <20151218232521.GB16904@thunk.org>
	<1450483255.6251.16.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sat, 19 Dec 2015 01:00:55 +0100 as
excerpted:

> How, exactly, do you propose that filefrag understand this?  It is
> getting the information from the fiemap ioctl:
> 
> https://www.kernel.org/doc/Documentation/filesystems/fiemap.txt
> 
> and the problem is that fiemap returns the logical length of the extent,
> but not the *physical* length of the extent.  So this is why the
> filefrag is show what appears to be overlapping extents:


Thanks.  The devs might have known that, but you definitely just expanded 
my own knowledge and understanding of the subject.  (I had tried to make 
sense of filefrag -v and couldn't, here.  After reading your relay of 
Ted's reply, the output makes /much/ better sense to me! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

