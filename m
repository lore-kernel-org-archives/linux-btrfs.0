Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45819 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759593AbbKTLHD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 06:07:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZzjWB-0005ks-IV
	for linux-btrfs@vger.kernel.org; Fri, 20 Nov 2015 12:06:15 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 12:06:15 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 12:06:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: [Bug] btrfs-progs v4.3.1, mkfs.btrfs manpage, profiles table
 missing raid1
Date: Fri, 20 Nov 2015 11:05:44 +0000 (UTC)
Message-ID: <pan$130bd$2fb4e52a$aef597d4$e021ef73@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As in the title...

The btrfs-progs v4.3.1 mkfs.btrfs manpage has a quite nice profiles table 
listing the various profiles, single/dup/raid0/raid10/raid5/raid6.

It's missing raid1. =:^(

Also, it calls raid5/6 "copies" rather than "parity".  Perhaps add 
another column for parity, change the redundancy column to copies, and 
adjust accordingly?  Alternatively, keep the single redundancy column and 
just change raid5 to 1 parity and raid6 to 2 parity.

Other than that, I really like the nice profiles table layout.
Kudos to whoever set that up. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

