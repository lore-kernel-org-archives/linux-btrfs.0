Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38801 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbcCVRfR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 13:35:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aiQCz-0005xH-Pr
	for linux-btrfs@vger.kernel.org; Tue, 22 Mar 2016 18:35:09 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 18:35:09 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 18:35:09 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: overlay file to test btrfs repairs
Date: Tue, 22 Mar 2016 17:34:58 +0000 (UTC)
Message-ID: <pan$9cb9a$185b2e9b$7b5df63f$77a1558e@cox.net>
References: <CAJCQCtRbOa14an+UooFJYBK5JNQppYfXKHqpOfKVXHBYPAQ_Kg@mail.gmail.com>
	<pan$2fe7d$1410eb30$c926ea8c$aa8d1cf9@cox.net>
	<56EFD981.7020606@gmail.com>
	<CAJCQCtTsMYmvqVNX_Nfy2aSdfLtV2gUUESp82gk=W0ifQc0r0Q@mail.gmail.com>
	<56F15505.1090807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 22 Mar 2016 10:21:57 -0400 as
excerpted:

> OTOH, if we could add some way to tell the code (both userspace and
> in-kernel) to explicitly ignore specific devices when trying to assemble
> filesystems, that would allow us to use DM snapshots (or something
> similar) to do this, and would also allow people to work around the UUID
> issues when dealing with LVM snapshots (or similar situations).

That's a good idea, but minor detail, it'd need to resolve to specific 
block-device major:minor comparison; it couldn't be a simple device-path 
blacklist, because device paths are routinely symlinked.

I guess that's obvious from a kernel dev perspective, but perhaps not so 
much from an admin-user perspective, where the device-path /is/ often 
considered the device.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

