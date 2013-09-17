Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56039 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3IQGGg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 02:06:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VLoQl-0003mT-Ju
	for linux-btrfs@vger.kernel.org; Tue, 17 Sep 2013 08:06:35 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 08:06:35 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 08:06:35 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [RFC] btrfs-progs: Add recursive defrag using -r option
Date: Tue, 17 Sep 2013 06:06:16 +0000 (UTC)
Message-ID: <pan$3fd6b$e557a488$ab986a01$72842fce@cox.net>
References: <073ec67162396b2ebda9c4ef51c6851993132b68.1379383433.git.fholton@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Frank Holton posted on Mon, 16 Sep 2013 22:21:24 -0400 as excerpted:

> I'm working on a patch to add the recursive option to the btrfs
> filesystem defrag command. I'd like some feedback on how the patch looks
> as written. I've added two helper functions, which might need to be
> renamed, one to call the ioctl and one to actually handle the recursion
> into the directory.
> 
> Let me know what you think.

Not being a dev I won't comment on that angle, but this will sure help 
decomplicate general defragging from a sysadmin angle.  Thanks. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

