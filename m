Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40648 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbbJ1Mg2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 08:36:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZrPxp-0003aA-N0
	for linux-btrfs@vger.kernel.org; Wed, 28 Oct 2015 13:36:25 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 13:36:25 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 13:36:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Questions about FIEMAP
Date: Wed, 28 Oct 2015 12:36:11 +0000 (UTC)
Message-ID: <pan$d8e7d$1b0b27e5$1154191$b17f2ea@cox.net>
References: <CY1PR10MB04283CC6BA7D9AE8F3F0B984E4310@CY1PR10MB0428.namprd10.prod.outlook.com>
	<561BB531.6070706@redhat.com>
	<CY1PR10MB0428CCC32D899CB0405B29ACE4210@CY1PR10MB0428.namprd10.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang, Zhiye posted on Wed, 28 Oct 2015 09:57:29 +0000 as excerpted:

> Thank you all for your comments.
> 
> A further question is: if I mount a btrfs file system in "readonly"
> mode, will any operation cause the blocks of a file get changed?

Note that both bind-mounts and btrfs subvolume mounts can be used to make 
parts of a filesystem appear in multiple locations in the filesystem 
tree.  Because these different mounts can be separately mounted read-only 
or writable, there's no guarantee that just because a filesystem or part 
of it is read-only mounted in one location, it's read-only mounted 
everywhere it can be accessed, and thus no guarantee that files even on a 
read-only mounted filesystem or subvolume won't actually change out from 
under you.

However, bind-mounts in particular aren't btrfs specific, so just because 
btrfs subvolumes add another case in which the above can be true, doesn't 
mean bind-mounts can't be used on other filesystems to effect the same 
sort of otherwise read-only file instabilities.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

