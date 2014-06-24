Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49020 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaFXFcL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 01:32:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WzJKz-0006nE-Mq
	for linux-btrfs@vger.kernel.org; Tue, 24 Jun 2014 07:32:09 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 07:32:09 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 07:32:09 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Removing file = quota exceded
Date: Tue, 24 Jun 2014 05:31:58 +0000 (UTC)
Message-ID: <pan$ce26c$9607f21a$b0e5b759$ed8f68f3@cox.net>
References: <53A62E89.6040900@gmail.com> <53A7069E.5010003@fb.com>
	<53A718CE.9030701@gmail.com>
	<pan$d6c28$7dab67c8$466f1e49$ff456a63@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Mon, 23 Jun 2014 01:53:45 +0000 as excerpted:

> However, because btrfs stores very small files (generally something
> under 16 MiB, the precise size depends on filesystem parameters)
> entirely within metadata

Hmm.  Should be under 16 KiB I believe, not 16 MiB.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

