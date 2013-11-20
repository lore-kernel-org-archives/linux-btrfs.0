Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58949 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab3KTQoS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 11:44:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VjAsz-0003ZT-FU
	for linux-btrfs@vger.kernel.org; Wed, 20 Nov 2013 17:44:17 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 17:44:17 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 17:44:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10
 </dev/sdX> ...
Date: Wed, 20 Nov 2013 16:43:57 +0000 (UTC)
Message-ID: <pan$448fc$ee29c6cf$df5ffdae$4f88c4b5@cox.net>
References: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com>
	<20131119090602.GV4315@carfax.org.uk>
	<pan$cd41e$ced598aa$e5d2ed3a$3c71af6f@cox.net>
	<20131120080958.GA28883@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Wed, 20 Nov 2013 08:09:58 +0000 as excerpted:

> RAID-0:  min 2 devices
> RAID-10: min 4 devices
> RAID-5:  min 2 devices (I think)
> RAID-6:  min 3 devices (I think)

RAID-5 should be 3-device minimum (each stripe consisting of two data 
segments and one parity segment, each on a different device).

And RAID-6 similarly four devices (two data and two parity).

Perhaps it's time I get that wiki account and edit some of this stuff 
myself...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

