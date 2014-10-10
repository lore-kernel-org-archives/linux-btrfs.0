Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44080 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbaJJDUP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Oct 2014 23:20:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XcQkY-0003Ok-56
	for linux-btrfs@vger.kernel.org; Fri, 10 Oct 2014 05:20:14 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 05:20:14 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 05:20:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: What is the vision for btrfs fs repair?
Date: Fri, 10 Oct 2014 03:20:00 +0000 (UTC)
Message-ID: <pan$ecd19$37cfe586$a16f45b8$3f43b02@cox.net>
References: <54358C77.2070808@redhat.com>
	<9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 09 Oct 2014 21:58:53 -0400 as excerpted:

> I suspect it's unintended splintering, and is an artifact that will go
> away. I'd rather the convoluted, fractured nature of repair go away
> before the scary experimental warnings do.

Heh, agreed with everything[1], but too late for this, the experimental 
warnings are peeled off, the experimental or at least horribly immature
/behavior/ remains. =:^(

---
[1] ... and a much more logically cohesive and well structured reply than 
I could have managed as my own thoughts simply weren't that well 
organized.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

