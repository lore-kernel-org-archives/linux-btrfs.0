Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48321 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbbIRBhH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 21:37:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zckbo-0004Ew-VG
	for linux-btrfs@vger.kernel.org; Fri, 18 Sep 2015 03:37:04 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 03:37:04 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 03:37:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1 storage server won't boot with one disk missing
Date: Fri, 18 Sep 2015 01:36:50 +0000 (UTC)
Message-ID: <pan$5cdb2$42505f02$e2b552bf$4a4e51e@cox.net>
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
	<55FAD9CC.5060206@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain posted on Thu, 17 Sep 2015 23:18:36 +0800 as excerpted:

>> What I expected to happen:
>> I expected that the [btrfs raid1 data/metadata] system would either
>> start as if nothing were wrong, or would warn me that one half of the
>> mirror was missing and ask if I really wanted to start the system with
>> the root array in a degraded state.
> 
> as of now it would/should start normally only when there is an entry
> -o degraded
> 
> it looks like -o degraded is going to be a very obvious feature,
> I have plans of making it a default feature, and provide -o nodegraded
> feature instead. Thanks for comments if any.

As Chris Murphy, I have my doubts about this, and think it's likely to 
cause as many unhappy users as it prevents.

I'd definitely put -o nodegraded in my default options here, so it's not 
about me, but about all those others that would end up running a silently 
degraded system and have no idea until it's too late, as further devices 
have failed or the one single other available copy of something important 
(remember, still raid1 without N-mirrors option, unfortunately, so if a 
device drops out, that's now data/metadata with only a single valid copy 
regardless of the number of devices, and if it goes invalid...) fails 
checksum for whatever reason.

And since it only /allows/ degraded, not forcing it, if admins or distros 
want it as the default, -o degraded can be added now.  Nothing's stopping 
them except lack of knowledge of the option, the *same* lack of knowledge 
that would potentially cause so much harm if the default were switched.

Put it this way.  With the current default, if it fails and people have 
to ask about the unexpected failure here, no harm to existing data done, 
just add -o degraded and get on with things.  If -o degraded were made 
the default, failure mode would be *MUCH* worse, potential loss of the 
entire filesystem due to silent and thus uncorrected device loss and 
degraded mounting.

So despite the inconvenience of less knowledgeable people losing the 
availability of the filesystem until they can read the wiki or ask about 
it here, I don't believe changing the default to -o degraded is wise, at 
all.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

