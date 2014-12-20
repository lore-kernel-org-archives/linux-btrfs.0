Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51764 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaLTG7R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 01:59:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y2E0R-00085A-Tc
	for linux-btrfs@vger.kernel.org; Sat, 20 Dec 2014 07:59:16 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 07:59:15 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 07:59:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs is using 25% more disk than it should
Date: Sat, 20 Dec 2014 06:59:04 +0000 (UTC)
Message-ID: <pan$56e18$b73ac93d$efecf399$5e01c563@cox.net>
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>
	<54949454.9020601@fb.com> <549495D4.9030800@fb.com>
	<20141220055242.GB436@hungrycats.org>
	<CAN6BF2LhUcrmRrfhJP1scrTLsCyZ2pWNp-_5MQ5spQViPfJc7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Daniele Testa posted on Sat, 20 Dec 2014 14:18:31 +0800 as excerpted:

> Anyways, would disabling CoW (by putting +C on the parent dir) prevent
> the performance issues and 2*filesize issue?

It should, provided you don't then start snapshotting the file (which I 
don't believe you intend to do but just in case...).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

