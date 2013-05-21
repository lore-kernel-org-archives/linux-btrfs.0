Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46200 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab3EUBJM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 May 2013 21:09:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ueb4g-0006Rf-OC
	for linux-btrfs@vger.kernel.org; Tue, 21 May 2013 03:09:10 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 03:09:10 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 03:09:10 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Virtual Device Support
Date: Tue, 21 May 2013 01:08:55 +0000 (UTC)
Message-ID: <pan$d75cf$ec7daeb9$c2cc055b$98b478d0@cox.net>
References: <518CFE3A.3080900@chinilu.com> <20130519171510.54897415@natsu>
	<262CC063-0DB4-45BD-A776-9FD1E8650E7C@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 19 May 2013 12:18:19 -0600 as excerpted:


> On May 19, 2013, at 5:15 AM, Roman Mamedov <rm@romanrm.ru> wrote:
> 
>> From a user perspective btrfs subvolumes have a lot in common with just
>> regular directories aka folders, and nothing in common with
>> (block)devices.
>> "Describing them with virtual devices" does not seem to make a whole
>> lot of sense.
> 
> It's not possible to mount regular directories with other file systems.

Actually, it /is/ possible, using bind-mounts, etc.  These even work at 
the individual file level, and I use a few that way here, for mounting 
usable device files over an otherwise nodev mounted filesystem (used for 
a named/bind chroot, bind-mounted and then remounted nodev,noexec, etc.).

But yes, bind-mounts are an exception to the general rule.  However, 
they're an exception that does make your above claim questionable, at 
least.  btrfs subvolumes are another such exception.

> In some ways the btrfs subvolume behaves like a folder. In other ways it
> acts like a device. If you stat the mount point for btrfs subvolumes,
> you get a unique device ID for each.

Agreed.

> It seems inconsistent that mount and unmount allows a /dev/ designation,
> but only mount honors label and UUID.

Yes.  I had tested btrfs a year ago and decided to wait so haven't been 
active here for 8 months or so, but am now getting back into btrfs as my 
requirements are different now, and as I'm reading the list, I've seen 
this frustrating inconsistency complained about more than once.  I'm 
about to setup a new btrfs system here once again, so don't yet know if 
it'll affect me personally, but given that I routinely use labels in 
fstab, it certainly could, depending on how the umounts are handled.  But 
at least I have a heads-up on the issue and can thus work around it 
should I need to.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

