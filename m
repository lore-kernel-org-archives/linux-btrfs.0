Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57391 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaKXSzc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 13:55:32 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XsynK-0005o6-FW
	for linux-btrfs@vger.kernel.org; Mon, 24 Nov 2014 19:55:30 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 19:55:30 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 19:55:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 24 Nov 2014 18:55:17 +0000 (UTC)
Message-ID: <pan$e596a$cfc2cde2$6957e9d8$10a112b8@cox.net>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<pan.2014.11.24.08.23.25@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstätte posted on Mon, 24 Nov 2014 08:23:25 +0000 as excerpted:

>> Users can choose sha256 from mkfs.btrfs via
>> 
>> $ mkfs.btrfs -C 256 /device
> 
> Not sure how others feel about this, but it's probably easier for
> sysadmins to specify the algorithm by name from the set of supported
> ones, similar to how ssh does it ("ssh -C arcfour256").


Yes.  Simply 256 is waaay too generic for me to be comfortable with.  
256 /what/?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

