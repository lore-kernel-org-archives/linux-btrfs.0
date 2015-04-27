Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50374 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbbD0CLT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Apr 2015 22:11:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YmYVv-0006qB-Qe
	for linux-btrfs@vger.kernel.org; Mon, 27 Apr 2015 04:11:15 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 04:11:15 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 04:11:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to get the devid of a missing device
Date: Mon, 27 Apr 2015 02:11:05 +0000 (UTC)
Message-ID: <pan$7e6ba$6d122ecc$73869bfb$271bf54f@cox.net>
References: <1704142.6uN5bYeLWo@discus>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wolfgang Mader posted on Sun, 26 Apr 2015 20:39:34 +0200 as excerpted:

> Hello,
> 
> I have a raid10 with one device missing. I would like to use btrfs
> replace to replace it. However, I am unsure on how to obtain the devid
> of the missing device.

The devid is if the device is still active in the filesystem.  If it's 
missing...

btrfs device delete missing

That, along with a bunch of other likely helpful information, is covered 
on the wiki:

https://btrfs.wiki.kernel.org

Specifically for that (reassemble from the wrap, too lazy to fiddle with 
it on my end):

https://btrfs.wiki.kernel.org/index.php/
Using_Btrfs_with_Multiple_Devices#Replacing_failed_devices

But since it was a four-device raid10 and four devices is the minimum for 
that, I don't believe it'll let you delete until you device add, first.

Of course that means probably some hours for the add, then some more 
hours for the delete missing, during which you obviously hope not to lose 
another device.  Of course the sysadmin's backup rule of thumb applies -- 
if you don't have a backup, by definition, loss of the data isn't a big 
deal, or you'd have it backed up.  (And the corollary, it's not a backup 
until it's tested, applies as well.)  So you shouldn't have to worry 
about loss of a second device during that time, because it's either 
backed up or the data isn't worth the trouble to backup and thus loss of 
it with the loss of a second device isn't a big deal.

That page doesn't seem to cover direct replacement, probably because the 
replace command is new and it hasn't been updated.  But AFAIK replace 
doesn't work with a missing device anyway; it's the fast way to replace a 
still listed device, so you don't have to add and then delete, but the 
device has to still be there in ordered to use that shortcut.  (You could 
try using missing with the -r option tho, just in case it works now.  The 
wiki/manpage is a bit vague on that point.)

> Btw, the file system is too old for skinny metadata and extended inode
> refs. If I do a btrfs replace or a btrfs device add, must I myself
> ensure that the new features are not enables for the new device which is
> to be added?

I don't believe there's any way to set that manually even if you wanted 
to -- you don't use mkfs on it and the add/replace would overwrite 
existing if you did.  The new device should just take on the attributes 
of the filesystem you're adding it to.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

