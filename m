Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58219 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbcCMREC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 13:04:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1af9Qu-0005kX-1B
	for linux-btrfs@vger.kernel.org; Sun, 13 Mar 2016 18:04:00 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 18:04:00 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 18:04:00 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: parent transid verify failed on snapshot deletion
Date: Sun, 13 Mar 2016 17:03:54 +0000 (UTC)
Message-ID: <pan$a52ce$b1beae3d$57f5b99c$a796a0ec@cox.net>
References: <20160312204847.2092f3f3@natsu> <20160312221524.646e1a66@natsu>
	<20160313142428.377b51b8@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Sun, 13 Mar 2016 14:24:28 +0500 as excerpted:

> With "Errors found in extent allocation tree", I wonder if I should try
> --init-extent-tree next.

With backups I'd try it, if only for the personal experience value and to 
see what the result was.  But that's certainly more intensive "surgery" 
on the filesystem than --repair, and I'd only do it either for that 
experience value or if I was seriously desperate to recover files, as I'd 
not trust the filesystem's health after that intensive a surgery, and 
would blow the filesystem away after I recovered what I needed, even if 
it did appear to work successfully.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

