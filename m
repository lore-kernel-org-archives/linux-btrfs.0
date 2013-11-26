Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56030 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399Ab3KZWhM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 17:37:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VlRFn-00019k-JJ
	for linux-btrfs@vger.kernel.org; Tue, 26 Nov 2013 23:37:11 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 23:37:11 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 23:37:11 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: missing /sbin/fsck.btrfs
Date: Tue, 26 Nov 2013 22:36:50 +0000 (UTC)
Message-ID: <pan$bbb5d$b7661b1a$f706f6ee$1a74681f@cox.net>
References: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com>
	<pan$8f316$eba9671d$d7cae9b2$d1c7e678@cox.net>
	<A1C7FA8D-A87E-40CD-A887-84C147CA5C08@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 26 Nov 2013 11:43:02 -0700 as excerpted:

> On Nov 26, 2013, at 12:18 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>> 
>> 
>> Just symlink/copy fsck.btrfs to (/bin/)true.
> 
> I'm not doing this every time I install an OS, most users won't
> either, and nor will most distributions. So in effect, this
> suggestion places the burden of implementation on the btrfs-progs
> package to create it at install time.

I think the "proper" solution is the one below.  This one is just a
workaround, to be done by the sysadmin if the distro or sysadmin
doesn't manage fstab properly.

>> https://btrfs.wiki.kernel.org/index.php/FAQ#What.27s_the_difference_between_btrfsck_and_fsck.btrfs
>> 
>> Or just do the /etc/fstab fs_passno = 0 thing, which is what I did
>> with reiserfs, so no change in that regard here when I switched to
>> btrfs for most partitions.
> 
> And that's fine, it places the burden on the distribution installer
> to create a correct /etc/fstab.

Distro installers should be creating a proper fstab anyway, and sysadmins
should catch it if they change things or if the installer doesn't get it,
because that's ultimately what sysadmins /do/, admin the system, including
setting up an appropriate fstab for their layout, and of course dealing
with distro bugs is a part of adminning a system as well.

And IMO, if an installer, human or automated distro install it doesn't
matter, sets up btrfs, setting anything but a zero/disabled fsck pass
number in fstab is almost certainly a mistake/bug, unless it's deliberately
set elsewise to cover some special case, in which case another step of
the same deliberate process should be symlinking fsck.btrfs to either
true or btrfsck as appropriate.  Because setting anything other that
a pass number of zero for btrfs by default should be exactly that,
a deliberate special-case, ideally documented as such in an fstab
comment and if automated as by an installer script, in that script
as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

