Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50400 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbbINXYT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 19:24:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zbd6e-00016W-Et
	for linux-btrfs@vger.kernel.org; Tue, 15 Sep 2015 01:24:16 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 01:24:16 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 01:24:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unable to mount multi disk volume with recovery mode
Date: Mon, 14 Sep 2015 23:24:10 +0000 (UTC)
Message-ID: <pan$47a1f$466b710d$165d40f8$ccb88307@cox.net>
References: <CAEyaVk+QnDb5sbfMtV_pGbkwA4BB9ODpVv-_hdMJWjuPbGG+Xg@mail.gmail.com>
	<55F66855.4010000@cn.fujitsu.com> <55F696F9.7090708@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain posted on Mon, 14 Sep 2015 17:44:25 +0800 as excerpted:

> Hi Qu,
> 
>> Unfortunately, single mode means no duplication.
>> And degrade mount only works for RAID level with
>> duplication(DUP,RAID1/5/6/10).
> 
> further to the below commit.
> 
>   commit 95669976bd7d30ae265db938ecb46a6b7f8cb893
>      Btrfs: don't consider the missing device when allocating new chunks
> 
> in case of 2-disk RAID1 mounted with only one good disk, we would create
> Single profile and actually the created single profiles are still
> workable with one disk failed. And so the proposed patch below will let
> single profile to be mount in this context..
>    [PATCH 23/23] Btrfs: allow -o rw,degraded for single group profile
> 
> to recover when missing disk is replaced balance convert can migrate
> single profiles back to RAID1 profile.
> 
> Also your explanation for degraded is correct, I am ok to use a new new
> mount option (like auto-reduced-profile ?) if needed / confusing.
> 
> Any comments / feedbacks are welcome.

I'm familiar with the issue, and for all I know it works exactly as 
described, but if so, shouldn't it be changed so that while 2-device 
raid1 mounted with only a single device create single-profile chunks only 
for data, metadata chunk-creation will default back to dup-profile?

If there's a good reason it doesn't, could someone explain it?  It seems 
to me that raid1 already indicates that two copies is wanted, so if it's 
operating degraded with only a single device, shouldn't it go dup, 
particularly for metadata?  (If possible, I'd say for data as well, but 
that's not possible except in mixed-bg-mode.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

