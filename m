Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34788 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbbBJHnu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 02:43:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YL5U4-0004jE-NC
	for linux-btrfs@vger.kernel.org; Tue, 10 Feb 2015 08:43:48 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 08:43:48 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 08:43:48 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Repair broken btrfs raid6?
Date: Tue, 10 Feb 2015 08:17:43 +0100
Message-ID: <ntnoqb-jvq.ln1@hurikhan77.spdns.de>
References: <CAGwxe4gXPEOTPfNc2=0E0HAfDfTRKRcqqPjVJimbWJr5riz4DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tobias Holst <tobby@tobby.eu> schrieb:

> and "btrfs scrub status /[device]" gives me the following output:
>> "scrub status for [UUID]
>>scrub started at Mon Feb  9 18:16:38 2015 and was aborted after 2008
>>seconds total bytes scrubbed: 113.04GiB with 0 errors"

Does not look very correct to me:

Why should a scrub in a six-drivers btrfs array which is probably multi-
terabytes big (as you state a restore from backup would take days) take only 
~2000 seconds? And scrub only ~120 GB worth of data. Either your 6 devices 
are really small (then why RAID-6), or your data is very sparse (then way 
does it take so long), or scrub prematurely aborts and never checks the 
complete devices (I guess this is it).

And that's what it actually says: "aborted after 2008" seconds. I'd expect 
"finished after XXXX seconds" if I remember my scrub runs correctly (which I 
currently don't do regularly because it takes long and IO performance sucks 
during running it).

-- 
Replies to list only preferred.

