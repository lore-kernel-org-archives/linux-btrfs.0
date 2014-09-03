Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49334 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbaICIm2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 04:42:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XP68v-0003Ht-Gf
	for linux-btrfs@vger.kernel.org; Wed, 03 Sep 2014 10:42:17 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Sep 2014 10:42:17 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Sep 2014 10:42:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs-progs-3.16: fs metadata is both single and dup?
Date: Wed, 3 Sep 2014 08:41:58 +0000 (UTC)
Message-ID: <pan$e1912$7304dafe$ca27510c$e0fa8da1@cox.net>
References: <pan.2014.09.02.12.05.33@googlemail.com>
	<20140902121349.GF18897@carfax.org.uk>
	<pan$5f385$eac97af1$e9cf0e10$15446dc8@cox.net>
	<20140903073305.GH18897@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Wed, 03 Sep 2014 08:33:05 +0100 as excerpted:

> On Wed, Sep 03, 2014 at 04:53:39AM +0000, Duncan wrote:
>> Hugo Mills posted on Tue, 02 Sep 2014 13:13:49 +0100 as excerpted:
>> 
>> 
>> [A] btrfs fi df on a new filesystem always seems to have those extra
>> unused single profile lines.
>> 
>> I got so the first thing I'd do on first mount was a balance -- before
>> there was anything actually on the filesystem so it was real fast -- to
>> get rid of those null entries.
> 
>    Interesting. Last time I tried that (balance without any contents),
> the balance removed *all* the chunks, and then the FS forgot about what
> configuration it should have and reverted to RAID-1/single. I usually
> recommend writing at least one 4k+ file to the FS first, if it's
> bothering someone so much that they can't let it go.

Interesting indeed.  From memory, even before I've put anything on the 
filesystem it always seems to have a bit of the first chunk of both data 
and metadata used -- not much but enough that it's obvious in the df 
which mode chunks are the null-chunks, and apparently obvious to the 
balance as well, as it has always left me with at least a first chunk of 
each.

I wonder what the difference might be.  Perhaps it's just the versions of 
kernel and/or userspace I've happened to do all my mkfs.btrfs with?  Or 
maybe it's one of the features (like thin-metadata or noholes) I enable 
by default, or the fact that I use labels for partition ID and tracking, 
so I always fill that in.  Whatever it is, it seems to put a bit of 
something in the filesystem, possibly at first mount, so the actually 
used chunks, one each of data and metadata, aren't entirely empty.

Or maybe I'm remembering wrong and I've just been lucky. <shrug>

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

