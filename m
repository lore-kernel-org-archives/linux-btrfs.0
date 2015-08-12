Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42565 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbbHLFPs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 01:15:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZPOOA-0001Na-UZ
	for linux-btrfs@vger.kernel.org; Wed, 12 Aug 2015 07:15:47 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 07:15:46 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 07:15:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Damaged filesystem, can read, can't repair, error says to
 contact devs
Date: Wed, 12 Aug 2015 05:15:39 +0000 (UTC)
Message-ID: <pan$71a3a$274a021f$854423bc$cf85b9de@cox.net>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAK7bmU9DVmXoEUBd2dmQPuVUb-iohacHqXvF73uOdaiL1GwtnA@mail.gmail.com>
	<CAJCQCtQLv83O2DD+J97Rw-i6FsLrANisSapjxydyx0kJT_vokA@mail.gmail.com>
	<201508121304.27963.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Wed, 12 Aug 2015 13:04:27 +1000 as excerpted:

> Linux Software RAID scrub will copy the data from one disk to the other
> to make them identical, the theory is that it's best to at least be
> consistent if you can't be sure you are right.
> 
> Will a BTRFS scrub do this on a non-CoW file?

While I honestly don't know, a reasonably educated guess is no, btrfs 
scrub assumes COW and checksumming, and doesn't do anything if there's no 
checksums to verify against.  (I know scrub skips verification of items 
without checksums in the normally checksummed case, so it's reasonable to 
assume it would skip all data, verifying only metadata, if no data has 
checksums.)

In a case like this where nodatacow has disabled checksumming, the best 
thing one can do is manually check at least some samples, and if there's 
no visible corruption, assume the existing data is correct and (after a 
scrub to verify at least metadata) do a btrfs check --init-csum-tree, to 
initialize the checksums to at least cover the existing situation, 
whatever it may be.  Scrub should be able to work after that, since it 
has csums to work with.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

