Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:49598 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755895Ab3AEV1Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Jan 2013 16:27:16 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: /boot as a btrfs subvolume
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50E8986A.2050002@czarc.net>
Date: Sat, 5 Jan 2013 14:27:14 -0700
Message-Id: <EEB5FCDE-687D-4EEF-9A85-68703266704C@colorremedies.com>
References: <50E8986A.2050002@czarc.net>
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 5, 2013, at 2:17 PM, Gene Czarcinski <gene@czarc.net> wrote:

> As of the latest updates to anaconda and grub2 for Fedora 18, it is now possible to install with /boot as a btrfs subvolume.  The way that grub2 is handling this is the "reach down" to the files it needs as if the subvolume was a directory.
> 
> Is this OK?

Mostly, but getting GRUB2 to handle subvolid I think would be better, because then subvols can be moved/renamed and things still would work.

Small problem currently is Fedora 18 still depends on grubby to make grub.cfg changes, and grubby is being kinda dumb about updating grub.cfg when /boot is on a boot subvol - ergo there's an error and it doesn't update the grub.cfg correctly.
https://bugzilla.redhat.com/show_bug.cgi?id=864198
Work around after any kernel update is to run grub2-mkconfig -o /boot/grub2/grub.cfg manually, and then the grub.cfg is correct.

> At this point I am not worried about snapshots or any other complexities.  If the subvolume name is known. should grub2 be able to reliably "reach down" as if that subvolume was a directory?  It needs some of its configuration files and, of course, the linux kernel.

It's two parts. GRUB's core.img code works as you describe. But grub-install and grub-mkconfig depend on /etc/fstab. If I use subvolid= in /etc/fstab and update either core.img or grub.cfg (with -install or -mkconfig), then the system is no longer bootable.

Chris Murphy