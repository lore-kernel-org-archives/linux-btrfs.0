Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42896 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbaHXNAF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 09:00:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XLXOt-00071I-7e
	for linux-btrfs@vger.kernel.org; Sun, 24 Aug 2014 15:00:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 15:00:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 15:00:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: superblock checksum mismatch after crash, cannot mount
Date: Sun, 24 Aug 2014 12:59:12 +0000 (UTC)
Message-ID: <pan$1b430$d5f1ad97$f41dda4a$53aaae5a@cox.net>
References: <53F7BD8E.10308@floga.de>
	<pan$a4556$243aa48a$bd2898a8$c2006893@cox.net> <53F85317.8060900@floga.de>
	<pan$16219$d960b649$52ed1e6$33540704@cox.net>
	<20140823163803.GA9149@hungrycats.org>
	<pan$101a9$d6ff1fb7$ae6d9b70$9c335a80@cox.net>
	<20140824110853.GB22693@apia.perrit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Leen Besselink posted on Sun, 24 Aug 2014 13:08:53 +0200 as excerpted:

> tip for basically any Linux filesystem, especially on Flash-based
> storage and also btrfs:
> - use noatime (if you aren't doing that already, don't know if that is
> the default in btrfs)

It's not the default for btrfs, but I have a patch that makes it the 
default on my system. =:^)



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

