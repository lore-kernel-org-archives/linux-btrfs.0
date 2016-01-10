Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36736 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbcAJFeL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jan 2016 00:34:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aI8dl-0006QD-2h
	for linux-btrfs@vger.kernel.org; Sun, 10 Jan 2016 06:34:09 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Jan 2016 06:34:09 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Jan 2016 06:34:09 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: evidence of persistent state, despite device disconnects
Date: Sun, 10 Jan 2016 05:34:03 +0000 (UTC)
Message-ID: <pan$74d94$5bf70ec7$7f891d62$b32aa42b@cox.net>
References: <CAJCQCtS59TFek+g9x_aoqGzepySMrRn6DcOQkuwi=VQYR9M4tw@mail.gmail.com>
	<pan$671e2$87d221b4$c1b40d79$6f794584@cox.net>
	<CAJCQCtSCvzoOdqFx9dB9sbT-dR0XsQVzWwVcK3zBnwC17+ZV_Q@mail.gmail.com>
	<pan$4b55a$cfffcc6c$c8faaa76$1740646a@cox.net>
	<CAJCQCtRkDrUhiCsgO5Wm=1OhpbtxaR58SLLg5JxZvYQE_nSTUQ@mail.gmail.com>
	<pan$84a33$9b12297$c9fad6dd$fe3dbd43@cox.net>
	<CAJCQCtRw9_YAneGeBW-CjwzuqGgOtKR4sNNd1RveUD3LQBXUVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 09 Jan 2016 15:29:31 -0700 as excerpted:

> On Sat, Jan 9, 2016 at 3:55 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>> If you're mounting degraded,rw, and you're down to a single device on a
>> raid1, then once the existing chunks fill up, it /has/ to create single
>> chunks, because it can't create them raid1 as there's not enough
>> devices (a minimum of two devices are required to create raid1 chunks,
>> since two copies are required and they can't be on the same device).
>>
>> And by mounting degraded,rw you've given it permission to create those
>> single mode chunks if it has to, so it's not "silent", as you've
>> explicitly mounted it degraded,rw, and single is what raid1 degrades to
>> when there's only one device.
> 
> This is esoteric for mortal users (let alone without documentation) that
> degraded,rw means single chunks will be made, and now new data is no
> longer replicated once the bad device is replaced and volume scrubbed.
> 
> There's an incongruency between the promise of "fault tolerance, repair,
> and easy administration" and the esoteric reality. This is not easy,
> this is a gotcha. I'll bet almost no users have any idea this is how
> rw,degraded behaves and the risk it entails.

Certainly, documentation is an issue.  But while the degraded option 
doesn't force degraded, only allows it if there are missing devices, it's 
not recommended, and this is one reason why.  Using the degraded option 
really /does/ give the filesystem permission to break the rules that 
would apply in normal operation, and adding to your mount options 
shouldn't be done lightly or routinely.  Ideally, it's /only/ added after 
a device fails, in ordered to be able to mount the filesystem and replace 
the failing/failed device with a new one or reshape the filesystem to one 
less device if a new one isn't to be added.

OTOH, if there are three devices in the raid1, and all three have 
unallocated space, then loss of a device shouldn't result in single-mode 
chunks even when mounting degraded, because it's still possible in that 
case to create raid1 chunks as there's still two devices with free space 
available.  Again, creation of single chunks in that case would be a bug.

But I think we're past the effective argument point and pretty much just 
restating our position at this point.  Given that I'm definitely not a 
btrfs coder and to my knowledge, while you may well read the code and do 
occasional trivial patches, you're not really a btrfs coder either, 
alleviating that documentation issue, which we both agree is there, is 
the best either of us can really do.  The rest remains with the real 
btrfs coders, and arguing further about it as non-btrfs-devs isn't going 
to help.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

