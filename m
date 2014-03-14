Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53780 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbaCNLZW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 07:25:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WOQEo-00005m-RU
	for linux-btrfs@vger.kernel.org; Fri, 14 Mar 2014 12:25:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 12:25:18 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 12:25:18 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Incremental backup for a raid1
Date: Fri, 14 Mar 2014 11:24:53 +0000 (UTC)
Message-ID: <pan$4e795$762009e5$6f734697$16ccd0b0@cox.net>
References: <1564384.fRV1HUkfCq@fuchsia>
	<pan$60e7c$45de97e1$2fb9daeb$288befdc@cox.net>
	<1549230.7yEi5AM4H9@fuchsia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Schuerig posted on Fri, 14 Mar 2014 09:56:20 +0100 as excerpted:

[Duncan posted...]

>> 3) Disconnect the backup device(s).  (Don't btrfs device delete, this
>> would remove the copy.  Just disconnect.)

Hmm...  Looking back at what I wrote...

Presumably either have the filesystem unmounted for the disconnect (and 
ideally, the system off, tho with modern drives in theory that's not an 
issue, but still good if it can be done), or at least remounted read-only.

I had guessed that was implicit, but making it explicit is probably best 
all around, just in case.  At least I can rest better with it, having 
made that explicit.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

