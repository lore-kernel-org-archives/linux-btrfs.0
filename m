Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44809 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbbLXBaD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 20:30:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBujB-0007aJ-1V
	for linux-btrfs@vger.kernel.org; Thu, 24 Dec 2015 02:30:01 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 02:30:01 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 02:30:01 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Loss of connection to Half of the drives
Date: Thu, 24 Dec 2015 01:29:54 +0000 (UTC)
Message-ID: <pan$57e0b$5f36b078$12676679$cb97e908@cox.net>
References: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
	<CAJCQCtStfVppb-NU0EjeAVf6cs08cdcWCEDYLx4zMoOzbG0W+A@mail.gmail.com>
	<CAC=t97Ac07=ZFZ1nShfWc0ik50D90hBJM3bSEiLmHbKK36G9Xw@mail.gmail.com>
	<pan$9b1ad$a377a340$8346d054$a731dd54@cox.net>
	<CAC=t97BW6vYgi7edM=PknJDep9nJxDbOYpgPKi6L2u-J3hMwqQ@mail.gmail.com>
	<567AE5F0.6060005@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Wed, 23 Dec 2015 19:20:32 +0100 as
excerpted:

> Ducan talked about a N-way mirroring, where each disks contains a copy
> of the same data. Nobody talked about N-way mirroring where N is less
> than the number of the available disks.

Well, to be fair, I did /try/ to talk about raid10 in the context of N-
way-mirroring, as *one*future*option*, which would let you do say 3-way-
mirroring, 2-way-striping, using six devices, giving you that choice in 
addition to the current 3-way-striping, 2-way-mirroring, that's the only 
current choice for btrfs raid10 with six devices, since it's limited to 
two-way-mirroring.

But obviously I was more confusing than clear, since you apparently 
didn't see that bit at all, and he saw it, but apparently ended up more 
confused than helped by it, possibly due to trying to apply that 
discussion to a larger scope than the limited one-future-option scope 
that I had originally intended.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

