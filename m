Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35061 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab3JJLjn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Oct 2013 07:39:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VUEaj-00067z-5J
	for linux-btrfs@vger.kernel.org; Thu, 10 Oct 2013 13:39:41 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Oct 2013 13:39:41 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Oct 2013 13:39:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BUG relating to fstrim on btrfs partitions
Date: Thu, 10 Oct 2013 11:39:16 +0000 (UTC)
Message-ID: <pan$d3f39$3d6ac9b9$db7362c7$80c1ae2b@cox.net>
References: <20131010102043.74230@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mike Audia posted on Thu, 10 Oct 2013 06:20:42 -0400 as excerpted:

> I think I found a bug affecting btrfs filesystems and users invoking
> fstrim to discard unused blocks: if I execute a `fstrim -v /` twice, the
> amount trimmed does not change on the 2nd invocation AND it takes just
> as long as the first.  Why do I think this is a bug?  When I do the same
> on an ext4 partition I get different behavior: the output shows 0 B
> trimmed and it does is instantaneously when I run it a 2nd time.  After
> contacting the fstrim developer, he stated that the userspace part
> (fstrim) does only one thing and it is invoke an ioctl (FITRIM); it is
> the job of the filesystem to properly implement this.

This behavior is documented in the fstrim manpage under -v/--verbose:

>>> When [--verbose is] specified fstrim will output the number of bytes
>>> passed from the filesystem down the block stack to the device for
>>> potential discard. This number is a maximum discard amount from the
>>> storage device's perspective, because FITRIM ioctl called repeated
>>> will keep sending the same sectors for discard repeatedly.
>>>
>>> fstrim will report the same potential discard bytes each time, but
>>> only sectors which had been written to between the discards would
>>> actually be discarded by the storage device.

Why ext4 behavior doesn't conform to that fstrim documentation I can't 
say (except by stating the obvious that the ext4 filesystem 
implementation of that ioctl obviously does it differently, but why... 
you'd have to either ask the ext4 folks or read its docs/sources), but 
given that fstrim documentation, the btrfs behavior is certainly NOTABUG 
as it's simply conforming to the documentation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

