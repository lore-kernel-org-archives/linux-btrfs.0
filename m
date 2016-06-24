Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57560 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbcFXE5A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 00:57:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bGJAm-0007i7-Da
	for linux-btrfs@vger.kernel.org; Fri, 24 Jun 2016 06:56:57 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 06:56:56 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 06:56:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Bad hard drive - checksum verify failure forces readonly mount
Date: Fri, 24 Jun 2016 04:56:50 +0000 (UTC)
Message-ID: <pan$4aafc$8178c223$638252a3$717a5f23@cox.net>
References: <loom.20160623T205347-371@post.gmane.org>
	<CAJCQCtRO+FYrsfHF_ARSnPfoS7uzvLR4hB1V-TJ_YN4NcA6srw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 23 Jun 2016 18:54:28 -0600 as excerpted:

> From the pasted kernel messages:
> 
>> Linux version 3.18.34-std473-amd64 (root@rl-sysrcd-p11) (gcc version
>> 4.8.5 (Gentoo 4.8.5 p1.3, pie-0.6.2) ) #2 SMP Tue May 24 20:34:19 UTC
>> 2016
> 
> 
> 3.18.34 is ancient. Find something newer and try to remount normally.
> And then also with recovery if necessary (don't use ro, see if it'll
> mount rw and fix itself). And if not, then try btrfs check with a newer
> version of btrfs-progs, I can't tell from the pasted output what version
> you're using but since the kernel is so old, decent chance the btrfsck
> is old also.

...  So I guess that means we're back to supporting only the latest two 
LTS kernel series, those being 4.1 and 4.4 at this time.  I had hoped 
that btrfs was stabilizing enough, and 3.18 was trouble-free enough btrfs-
wise, that we could expand that to three LTS series now, as the 
indications were we might when 4.4 was still new.  But it seems that 
while we did support it a bit longer, say 2.5 LTS series, that couldn't 
continue until the /next/ LTS came out.

Oh, well, it /was/ a bit of a stretch...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

