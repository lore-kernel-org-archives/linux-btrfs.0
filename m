Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57171 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbaK0J1q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Nov 2014 04:27:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XtvMW-0003rC-UX
	for linux-btrfs@vger.kernel.org; Thu, 27 Nov 2014 10:27:44 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Nov 2014 10:27:44 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Nov 2014 10:27:44 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Can't cp --reflink files on a Ext4-converted FS w/o checksums
Date: Thu, 27 Nov 2014 09:27:33 +0000 (UTC)
Message-ID: <pan$38a8e$6ec3447a$892ad9ec$128580b7@cox.net>
References: <20141127005527.42a7fe59@natsu> <54765FC2.2050309@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Wed, 26 Nov 2014 15:18:26 -0800 as excerpted:

> I also don't see anything in the code that says "this ioctl will create
> the checksums for the selected file" so you may have to do the copy you
> tried to avoid.


Note that btrfs check has an --init-csum-tree switch.  In a new enough 
btrfs-progs, I think it even works as one might expect!  (In older 
versions it would init the tree... by zeroing it for everything!)

FWIW I'm running btrfs-progs v3.17.1 here, but I've not updated in a few 
days and think I might have seen someone mention v3.17.2.

But I've not tested it.  The normal btrfs check caution applies:  Before 
using btrfs check in anything other than read-only mode (without any of 
the repair/init options), have a backup if you care about anything on the 
filesystem, as there's a chance it might eat it instead of fixing it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

