Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:42097 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaEUKrd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 06:47:33 -0400
Received: from eastrmimpo306 ([68.230.241.238]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20140521104732.DMGM30009.eastrmfepo101.cox.net@eastrmimpo306>
          for <linux-btrfs@vger.kernel.org>;
          Wed, 21 May 2014 06:47:32 -0400
Date: Wed, 21 May 2014 03:47:31 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check, btrfsck, fsck.btrfs
Message-ID: <20140521034731.3f7b7764@ws>
In-Reply-To: <4QT21o01E1EMSLa01QT4fM>
References: <9B5A4230-5A2F-4C00-AC4F-D9CA36A91620@colorremedies.com>
 <pan$bfe22$348a9807$13d86fd5$5784dae1@cox.net>
 <4QT21o01E1EMSLa01QT4fM>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 20 May 2014 18:26:59 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> That ought to be true, but at least on a systemd 212-4 system, it
> assumes the system root needs to be fsck'd before mounting it. Since
> the fs isn't mounted, fstab isn't available. And the fstab.empty file
> I found in the initramfs is in fact empty. So even with fs_passno set
> to 0, systemd is trying to run fsck.btrfs, which it fails to find,
> warns about, then moves on.
> 
> I filed that bug here:
> https://bugzilla.redhat.com/show_bug.cgi?id=1098799

[@ Chris M, I sent this to you only first.  So this one's to the list
only, but it'll have a different message-id, so you'll probably get it
as two different messages, one to the list, one direct to you.]

Hmm... it isn't doing so here.  dracut-037, systemd-212-r4 (the -r4
indicating four gentoo package level revision bumps since the initial
in-tree release of the upstream 037 version).

But I have an install-customized dracut config (tho I no longer use
host-only as explained in my last post, to the degraded boot and
systemd thread), all kernel modules built-in, etc.  If you're running a
generic everything-including-the-kitchen-sink dracut, that might
explain it, since I guess on most filesystems (not reiserfs/xfs/btrfs,
however) it would need to be run.

-- 
Duncan - No HTML messages please, as they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
