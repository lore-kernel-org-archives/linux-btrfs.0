Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37418 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaJNW4Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 18:56:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XeB0t-0005ve-A7
	for linux-btrfs@vger.kernel.org; Wed, 15 Oct 2014 00:56:19 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 00:56:19 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 00:56:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs random filesystem corruption in kernel 3.17
Date: Tue, 14 Oct 2014 22:55:53 +0000 (UTC)
Message-ID: <pan$d4cea$708739e$61c372fa$5e22780a@cox.net>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com> <543A61EE.7070200@prnet.org>
	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>
	<543C35C3.9070002@prnet.org>
	<CAGfcS_n5+ToT6kM5+J9TLjdwpriC3uu7hg2HVZXTmTSo-URO9Q@mail.gmail.com>
	<pan$e02d1$5d8cd0cc$87f3cfc$b14a0d51@cox.net>
	<c2103f1c229cdd887b8743d0946a8a8f@prnet.org>
	<pan$67a58$c42f6156$af002a14$c1094f5a@cox.net> <543D9DA9.50702@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Tue, 14 Oct 2014 15:03:21 -0700 as excerpted:

> What happens if "btrfs property set" is used to (attempt to) promote the
> snapshot from read-only to read-write? Can the damaged snapshot then be
> subjected to scrub of btrfsck?
> 
> e.g.
> 
> btrfs property set /path/to/snapshot ro false (maintenance here)

Very good question not yet answered. =:^)

But it's one I can't answer as my use-case doesn't call for such 
snapshots in the first place and I don't have any to be personally 
affected by this bug, so my interest is academic.

I simply saw the big hairy thread and tried to summarize what I could get 
out of it to that point, with a bit of my own speculation as to what the 
"reversed" transid complaints meant.

(Since transids are normally sequential, in most corruption cases, the 
filesystem has moved on and has a higher transid that's "wanted", but can 
only find an older/lower transid for something or other.  Or at least 
that's what I've seen here and what seems common in the other reports 
I've seen posted.  This bug reverses that, with an older/lower "wanted" 
transid, but finding a newer/higher one.  That's the strange point that 
leapt out to me and I'd guess it's a strong hint at the problem, thus my 
definitely admin-not-coder speculation on that point.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

