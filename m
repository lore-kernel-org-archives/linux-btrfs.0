Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60987 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750833AbaDLQP0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Apr 2014 12:15:26 -0400
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: Re: SELinux on btrfs
Date: Sat, 12 Apr 2014 10:15:25 -0600
Message-Id: <4DB89922-7B01-405A-9E63-0CCBBB6481B3@colorremedies.com>
Cc: Michael Schuerig <michael.lists@schuerig.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>  I'm already aware that SELinux's automatic labelling of files is not aware of subvolumes[*]. 
> [*] https://wiki.debian.org/SELinux/Setup#btrfs

I'm not sure exactly what it means since there is always a subvolume (ID 5), and I don't understand why autorelabel behavior would differ from manually running fixfiles or restorecon. 

In any case, I just obliterated the labeling in /boot which is a Btrfs subvolume mounted at /boot. I then ran "restorecon -Rv /" and this finds the problems in /boot and fixes them. So I obliterated the labels in /boot again, and then did "touch /.autorelabel; reboot" and again /boot is fixed up.

*shrug* Maybe the issue is labeling unmounted subvolumes, as if they're not treated as folders? Nope, if I snapshot /boot as /boot/.bootsnap, and then only mess up the labels in .bootsnap, and then run a restorecon -Rv on /boot, it goes into .bootsnap and fixes its labels. So that's not it either.

> I already have quite a few read-only snapshots that I don't want to forfeit, however, I'm not at all sure how SELinux would interact with them.


If the default policy mismatches with the file context, the relabel or restorecon will want to change the context to the default, but won't be able to because it's a read-only subvolume. I merely get a non-fatal:

restorecon set context /boot/.bootsnap/grub2->system_u:object_r:boot_t:s0 failed:'Read-only file system'

And it proceeds to the next file.

This is not Btrfs specific, but is about autorelabeling, and better ways to go about it.
http://danwalsh.livejournal.com/38157.html



Chris Murphy