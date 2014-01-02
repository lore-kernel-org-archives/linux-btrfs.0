Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42451 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaABIuW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 03:50:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vydyu-0001Yq-1C
	for linux-btrfs@vger.kernel.org; Thu, 02 Jan 2014 09:50:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jan 2014 09:50:20 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jan 2014 09:50:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Migrate to bcache: A few questions
Date: Thu, 2 Jan 2014 08:49:58 +0000 (UTC)
Message-ID: <pan$ce6d2$f8c0c73e$1b8dc4d$cbbdd6eb@cox.net>
References: <kof6pa-akd.ln1@hurikhan77.spdns.de>
	<52C1990D.9060704@gmail.com> <52C476B8.2040601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Wed, 01 Jan 2014 15:12:40 -0500 as
excerpted:

> On 12/30/2013 11:02 AM, Austin S Hemmelgarn wrote:
>> 
>> As an alternative to using bcache, you might try something simmilar to
>> the following:
>>     64G SSD with /boot, /, and /usr Other HDD with /var, /usr/portage,
>>     /usr/src, and /home tmpfs or ramdisk for /tmp and /var/tmp
>> This is essentially what I use now, and I have found that it
>> significantly improves system performance.
>> 
> On this specific note, I would actually suggest against putting the
> portage tree on btrfs, it makes syncing go ridiculously slow,
> and it also seems to slow down emerge as well.

Interesting observation.

I had not see it here (with the gentoo tree and overlays on btrfs), but 
that's very likely because all my btrfs are on SSD, as I upgraded to both 
at the same time, because my previous default filesystem choice, 
reiserfs, isn't well suited to SSD due to excessive writing due to the 
journaling.

I do know slow syncs and portage dep-calculations were one of the reasons 
I switched to SSD (and thus btrfs), however.  That was getting pretty 
painful on spinning rust, at least with reiserfs.  And I imagine btrfs on 
single-device spinning rust would if anything be worse at least for 
syncs, due to the default dup metadata, meaning at least three writes 
(and three seeks) for each file, once for the data, twice for the 
metadata.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

