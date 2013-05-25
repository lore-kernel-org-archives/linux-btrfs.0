Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59883 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab3EYD6d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 May 2013 23:58:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ug5ci-0000Jl-9h
	for linux-btrfs@vger.kernel.org; Sat, 25 May 2013 05:58:28 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 05:58:28 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 05:58:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recommended settings for SSD
Date: Sat, 25 May 2013 03:58:12 +0000 (UTC)
Message-ID: <pan$1197$73f28aeb$cb95553f$36bb7307@cox.net>
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com>
	<CAE5mzvj=rAmw9DgVL5HUx+Ue1stArhjV9UBM+6fsHUZMZK25Rg@mail.gmail.com>
	<CAAeznTo1uiZMgedoWfE-E0v=2vTWVkV0_k-9_+vVZ6YMFfjdRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Leonidas Spyropoulos posted on Fri, 24 May 2013 23:38:17 +0100 as
excerpted:

> On 24 May 2013 21:07, "cwillu" <cwillu@cwillu.com> wrote:
>>
>> No need to specify ssd, it's automatically detected.
> I'm not so sure it did detected. When I manually set it I saw
> significant improvement.

Without going back to check the wiki, IIRC it was there that the /sys 
paths it checks for that detection are listed.  Those paths are then 
based on what the drive itself claims.  If it claims to be rotating 
storage...

It may also depend on the kernel version, etc, as I'm not sure when that 
auto-detection was added (tho for all I know it has been there awhile).

I do know my new SSDs (Corsair Neutrons, 256GB) are detected here, and 
the ssd mount option is thus not needed.  However, I'm running current 
v3.10-rcX-git kernels, tho I'm a few days behind ATM as I'm still working 
on switching over to the SSDs ATM and am having to do some reconfiguring 
to get there.

Btrfs still being marked for testing only and under heavy development, if 
people aren't at least running current Linus stable or better and don't 
have a specific bug as a reason not to, they're actually behind and are 
likely missing potentially critical patches.  That means most people 
trying to run btrfs on stock distro kernels will be behind...


Meanwhile, what about the discard option?  As I'm still setting up on the 
SSDs as well as btrfs here, I haven't had a chance to decide whether I 
want that, or would rather setup fstrim as a cron job, or what.  But 
that's the other big question for SSD.

Here, I'm actually partitioning for near 100% over-provisioning, (120-ish 
GiB of partitions on the 238GiB/256GB drives, so I suspect actually 
running with discard as a mount option won't be such a big deal and will 
likely only cut write performance as I head toward stable-state, since 
the drive should have plenty of trimmed space to work with in any case 
due to the over-provisioning.  But I suspect it could be of benefit to 
those much closer to 0% over-provisioning than to my near 100%.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

