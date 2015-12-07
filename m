Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55253 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbbLGDs6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Dec 2015 22:48:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a5mnH-0002XW-9z
	for linux-btrfs@vger.kernel.org; Mon, 07 Dec 2015 04:48:55 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 04:48:55 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 04:48:55 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrub on btrfs single device only to detect errors, not correct
 them?
Date: Mon, 7 Dec 2015 03:48:48 +0000 (UTC)
Message-ID: <pan$519f9$af10e2cb$f1ea2d14$435d0b5a@cox.net>
References: <CA+pSGYcxAHUppSgODwk16i+5rLdojzjYxp8=SWWkLXmXOAo9kg@mail.gmail.com>
	<CAJCQCtQX5Ov6YKZ=SdxaGSPaGa0sEFF6gz89WsDm9qegmykGkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 06 Dec 2015 13:42:57 -0700 as excerpted:

> On Sun, Dec 6, 2015 at 12:15 PM, Jon Panozzo <jonp@lime-technology.com>
> wrote:
>> Just to confirm, is the sole purpose of supporting scrub on single
>> btrfs devices to detect errors, but not to correct them?
> 
> If that single device metadata profile is DUP, then it will correct
> those. If there is only one copy of anything, then it just reports.
> Scrub works on all data, but a passive scrub happens anytime something
> is read.

... And more to the point, expanding on that, on a single device btrfs, 
data is single mode by default, so scrub for it (as opposed to metadata) 
is error-detect-only as mentioned.

However, while the default mode separates data and metadata, and in that 
mode, historically (there's a patch to change this, adding the missing 
option) data was single-only, mixed-bg mode (the mkfs.btrfs --mixed 
option) puts data and metadata both in the same shared block-group type, 
which can then be either dup or single mode.

Obviously duplicating data as well as metadata means you can only store 
half as much data, since it's all stored twice, but that will let scrub 
correct errors in cases where only one of the two copies doesn't verify 
checksum, but the other one does.

And as mentioned above, there's a patch in process now, that will remove 
the single-device restriction of data (as opposed to metadata) to single 
mode, allowing the choice of dup mode for data as well as metadata.


Also, in addition to the mixed-mode workaround to get dup data, it's 
possible, altho rather inefficient in performance terms, to partition a 
physical device such that two equal sized partitions are made available 
as logical devices, and then mkfs.btrf -d raid1 -m raid1 the two logical 
devices into a single btrfs, raid1 for both data and metadata, so btrfs 
creates two copies that way, again letting scrub correct errors when only 
one of the two fails to verify against checksum.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

