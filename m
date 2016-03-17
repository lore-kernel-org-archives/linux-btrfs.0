Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42276 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966AbcCQI7N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 04:59:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1agTlo-0001YS-CL
	for linux-btrfs@vger.kernel.org; Thu, 17 Mar 2016 09:59:04 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 09:59:04 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 09:59:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs-progs: add stat check in open_ctree_fs_info
Date: Thu, 17 Mar 2016 08:58:58 +0000 (UTC)
Message-ID: <pan$5827c$2850555c$6b75a991$da57cc2e@cox.net>
References: <1458141971-56355-1-git-send-email-ahferroin7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 16 Mar 2016 11:26:11 -0400 as
excerpted:

> Currently, open_ctree_fs_info will open whatever path you pass it and
> try to interpret it as a BTRFS filesystem.  While this is not
> nessecarily dangerous (except possibly if done on a character device),
> it does result in some rather cryptic and non-sensical error messages
> when trying to run certain commands in ways they weren't intended to be
> run.  Add a check using stat(2) to verify that the path we've been
> passed is in fact a regular file or a block device.
> 
> This causes the following commands to provide a helpful error message
> when run on a FIFO, directory, character device, or socket:

Umm... what about a symlink?  A symlink isn't a block device or regular 
file, but obviously with udev, symlinks to block devices /better/ work.  
Do you dereference symlinks before doing this check?


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

