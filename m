Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46083 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab3KZHSm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 02:18:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VlCuu-00064b-W4
	for linux-btrfs@vger.kernel.org; Tue, 26 Nov 2013 08:18:40 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 08:18:40 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 08:18:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: missing /sbin/fsck.btrfs
Date: Tue, 26 Nov 2013 07:18:20 +0000 (UTC)
Message-ID: <pan$8f316$eba9671d$d7cae9b2$d1c7e678@cox.net>
References: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 25 Nov 2013 23:40:49 -0700 as excerpted:

> Is there supposed to be an /sbin/fsck.btrfs? I'm seeing a handful of
> threads indicating some idea of having it just do a no-op like fsck.xfs
> does, but then also the idea that /etc/fstab should correctly set
> fs_passno to 0 instead of such trickery.
> 
> I ask due to systemd-fstab-generator seemingly getting the idea from
> Fedora 20's default /etc/fstab that btrfs should have its file system
> checked, and during offline  updates, systemd tries to do this, doesn't
> find /sbin/fsck.btrfs, and then has several dozen fits.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1034563
> https://bugzilla.redhat.com/show_bug.cgi?id=862871
> 
> So the question, is there supposed to be (one day) a faux
> /sbin/fsck.btrfs? Or should things always check /etc/fstab fs_passno and
> honor the fact there is really no such thing?

Just symlink/copy fsck.btrfs to (/bin/)true.

https://btrfs.wiki.kernel.org/index.php/FAQ#What.27s_the_difference_between_btrfsck_and_fsck.btrfs

Or just do the /etc/fstab fs_passno = 0 thing, which is what I did with
reiserfs, so no change in that regard here when I switched to btrfs
for most partitions.

But I'm on gentoo and haven't opted to drink the systemd koolaid yet,
so what it thinks about that I wouldn't know.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

