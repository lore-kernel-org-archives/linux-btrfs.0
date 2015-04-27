Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-afa67.mailout.artfiles.de ([212.72.176.67]:50273 "EHLO
	mailout-afa67.mailout.artfiles.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbbD0IAN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 04:00:13 -0400
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to get the devid of a missing device
Date: Mon, 27 Apr 2015 10:00:07 +0200
Message-ID: <1714496.4Yoe3Ejg52@discus>
In-Reply-To: <pan$7e6ba$6d122ecc$73869bfb$271bf54f@cox.net>
References: <1704142.6uN5bYeLWo@discus> <pan$7e6ba$6d122ecc$73869bfb$271bf54f@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, April 27, 2015 02:11:05 AM Duncan wrote:
> Wolfgang Mader posted on Sun, 26 Apr 2015 20:39:34 +0200 as excerpted:
> > Hello,
> > 
> > I have a raid10 with one device missing. I would like to use btrfs
> > replace to replace it. However, I am unsure on how to obtain the devid
> > of the missing device.
> 
> The devid is if the device is still active in the filesystem.  If it's
> missing...
> 
> btrfs device delete missing
> 
> That, along with a bunch of other likely helpful information, is covered
> on the wiki:
> 
> https://btrfs.wiki.kernel.org
> 
> Specifically for that (reassemble from the wrap, too lazy to fiddle with
> it on my end):
> 
> https://btrfs.wiki.kernel.org/index.php/
> Using_Btrfs_with_Multiple_Devices#Replacing_failed_devices
> 
> But since it was a four-device raid10 and four devices is the minimum for
> that, I don't believe it'll let you delete until you device add, first.

Thanks for your answer. I know the stuff of that page, but since it is 
possible to use btrfs replace on a missing device I wanted to try that 
approach.

> 
> Of course that means probably some hours for the add, then some more
> hours for the delete missing, during which you obviously hope not to lose
> another device.  Of course the sysadmin's backup rule of thumb applies --
> if you don't have a backup, by definition, loss of the data isn't a big
> deal, or you'd have it backed up.  (And the corollary, it's not a backup
> until it's tested, applies as well.)  So you shouldn't have to worry
> about loss of a second device during that time, because it's either
> backed up or the data isn't worth the trouble to backup and thus loss of
> it with the loss of a second device isn't a big deal.

Well, of course, there is a backup on a different machine. Its in the same 
room, but who has the luxury for off-site backups in a home-use setting! :)

> 
> That page doesn't seem to cover direct replacement, probably because the
> replace command is new and it hasn't been updated.  But AFAIK replace
> doesn't work with a missing device anyway; it's the fast way to replace a
> still listed device, so you don't have to add and then delete, but the
> device has to still be there in ordered to use that shortcut.  (You could
> try using missing with the -r option tho, just in case it works now.  The
> wiki/manpage is a bit vague on that point.)
> 
> > Btw, the file system is too old for skinny metadata and extended inode
> > refs. If I do a btrfs replace or a btrfs device add, must I myself
> > ensure that the new features are not enables for the new device which is
> > to be added?
> 
> I don't believe there's any way to set that manually even if you wanted
> to -- you don't use mkfs on it and the add/replace would overwrite
> existing if you did.  The new device should just take on the attributes
> of the filesystem you're adding it to.

 Good to know.

Thanks

