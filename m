Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47946 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbdHGWYb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 18:24:31 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1deqRj-00062x-EM
        for linux-btrfs@vger.kernel.org; Tue, 08 Aug 2017 00:24:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: kernel BUG at
 =?us-ascii?Q?=2Fbuild=2Flinux-H5UzH8=2Flinux-4=2E10=2E0=2Ffs=2Fbtr?=
 =?us-ascii?Q?fs=2Fextent=5Fio=2Ec=3A2318?=
Date: Mon, 7 Aug 2017 22:24:11 +0000 (UTC)
Message-ID: <pan$b52c9$ae2c3bc9$d4d1cbcf$e8f8d076@cox.net>
References: <b6624a14-d63f-4372-b6b8-662a61973547@siedziba.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Piotr Pawłow posted on Mon, 07 Aug 2017 15:26:16 +0200 as excerpted:

> # uname -a
> Linux pps 4.10.0-30-generic #34-Ubuntu SMP
> Mon Jul 31 19:38:17 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

This is a general principles reply and chances are wouldn't help with 
your issue since the spread isn't /too/ large yet and I've no knowledge 
of a specific fix for your issue in newer kernels, but FWIW...

This being the btrfs development list and btrfs, while stabilizing (but 
not yet to be considered fully stable) still being under rather intense 
development, with significant changes every kernel cycle, list focus 
tends to be quite forward looking, with most interest and the best chance 
of fixes on relatively current kernels.

What we try to support, in addition to development kernels, is the latest 
two release kernel series in two tracks, (mainline/Linus) current and LTS.

On the current track, 4.12 is the newest release so 4.12 and 4.11 are 
best supported, tho the 4.11 series is already listed as EOL on 
kernel.org.  On the LTS track, 4.9 and 4.4 are the latest LTS releases, 
with 4.1 the previous one but already well out of btrfs focus range.

That puts 4.10 out of the list's best-supported focus range, with 4.11 
still in focus but EOL.  Beyond that we still try, but you're not as 
likely to get interest from the developers themselves, and for the other 
btrfs-user-regulars here, as the spread gets wider, the support gets more 
difficult as it's harder to remember where things were back then.

So the recommendation would be to either upgrade to 4.12 current if you 
want to stay on current track, or downgrade to the latest 4.9 release if 
you prefer stable track.

Other alternatives would include getting support from your distro if 
you're running a distro kernel (as seems to be your case), since they 
know what they've backported and what they haven't, and are thus in a 
better position to support it, and of course, simply sticking with what 
you have and accepting that you won't get quite the support or interest 
on your list posts since you're out of primary focus range.

Of course you can also keep a current kernel available and boot to it to 
try to duplicate any issues before reporting, while otherwise sticking to 
your older kernel, but unless you have a specific reason to do that, it 
would seem more trouble than simply running the current kernel by default.

So 4.10 isn't /too/ far out of range yet, but I'd strongly consider 
upgrading (or downgrading to 4.9 LTS) as soon as it's reasonably 
convenient, before 4.13 in any case.  Unless you prefer to go the distro 
support route, of course.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

