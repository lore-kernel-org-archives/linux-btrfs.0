Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32785 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbaEFVIi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 17:08:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WhmUo-0004wA-EC
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 23:01:50 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 23:01:50 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 23:01:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs raid allocator
Date: Tue, 6 May 2014 20:59:51 +0000 (UTC)
Message-ID: <pan$d3cb7$e33f988e$d956e590$174f447d@cox.net>
References: <5368BC62.2020701@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hendrik Siedelmann posted on Tue, 06 May 2014 12:41:38 +0200 as excerpted:

> I would like to use btrfs (or anyting else actually) to maximize raid0
> performance. Basically I have a relatively constant stream of data that
> simply has to be written out to disk.

If flexible parallelization is all you're worried about, not data 
integrity or the other things btrfs does, I'd suggest looking at a more 
mature solution such as md- or dm-raid.  They're more mature and less 
complex than btrfs, and if you're not using the other features of btrfs 
anyway, they should simply work better for your use-case.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

