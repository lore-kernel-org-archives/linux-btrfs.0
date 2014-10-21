Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45916 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191AbaJUMZP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 08:25:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XgYUz-0006G7-Uu
	for linux-btrfs@vger.kernel.org; Tue, 21 Oct 2014 14:25:13 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 14:25:13 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 14:25:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: strange 3.16.3 problem
Date: Tue, 21 Oct 2014 12:25:02 +0000 (UTC)
Message-ID: <pan$9526d$5656f77d$70922c1d$bcb849ce@cox.net>
References: <201410181454.19375.russell@coker.com.au>
	<pan$9907e$9b197fe7$2a806862$700ddfa7@cox.net>
	<20141020130243.GB29401@hungrycats.org>
	<201410212113.30887.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Tue, 21 Oct 2014 21:13:29 +1100 as excerpted:

>  I don't know what
> space_cache is about, is that something the kernel adds automatically?

Yes, space_cache is the default.

Apparently early in space_cache history you had to mount with space_cache 
once, and the kernel would then detect the existence of the space-cache-
tree and always use the option after that.

But for quite some time now, over a year since I've not ever added that 
to my mount options since I got the ssds and began using btrfs on them, 
the kernel seems to enable it automatically from the first mount, unless 
you specifically tell it not to.

Similarly for the ssd option, if the kernel detects that you are running 
an ssd (I believe it checks the ata/scsi rotational media property, which 
it should detect properly on raw hardware, but which can get lost if 
btrfs is layered over top of lvm/mdraid/dmcrypt/etc), it'll automatically 
enable the ssd mount option, which is exactly what it does here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

