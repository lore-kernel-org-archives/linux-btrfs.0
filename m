Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57770 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbcEDPy2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 11:54:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1axz81-0005EW-Tz
	for linux-btrfs@vger.kernel.org; Wed, 04 May 2016 17:54:22 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 17:54:21 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 17:54:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: /etc/fstab rootfs options vs grub2 rootflags cmdline
Date: Wed, 4 May 2016 15:54:15 +0000 (UTC)
Message-ID: <pan$6ee8b$a34d8ed2$894ceb38$41a8085e@cox.net>
References: <79249c4d-eab0-43fa-a6ae-b670699891dc@linuxsystems.it>
	<pan$7b1b$2e968d2f$7ddc7045$1ba7386@cox.net>
	<f8233c24-e336-4d31-a4cb-f3b0f97d1305@linuxsystems.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Niccolò Belli posted on Wed, 04 May 2016 15:52:39 +0200 as excerpted:

> Thanks,
> Now my fstab option are
> rw,noatime,compress=lzo,discard,autodefrag,subvolid=257,subvol=/@
> I tried to add rootflags=noatime,compress=lzo,discard,autodefrag to
> GRUB_CMDLINE_LINUX in /etc/default/grub as you suggested but my system
> didn't manage to boot, probably because grub automatically adds
> rootflags=subvol=@ and only a single rootflags can be taken into
> account.
> Do you have any suggestion?

What about the subvol=/@?

I think if you specifically add your own rootflags, grub won't add its 
own, and you said

noatime,compress=lzo,discard,autodefrag

but left off the subvol=/@ (unless you simply forgot to put it in the 
posting), and without that, it would have mounted the btrfs default 
subvolume, which would be (the filesystem's) / (subvolid=5) if you 
haven't changed it, and would have failed to boot as a result.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

