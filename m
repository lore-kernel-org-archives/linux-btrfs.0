Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40201 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbcCYOmJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 10:42:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ajSw8-0008CN-Ux
	for linux-btrfs@vger.kernel.org; Fri, 25 Mar 2016 15:42:05 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 15:42:04 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 15:42:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Possible Raid Bug
Date: Fri, 25 Mar 2016 14:41:54 +0000 (UTC)
Message-ID: <pan$1e121$45b4e51$993cb797$da237c0@cox.net>
References: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
	<CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patrik Lundquist posted on Fri, 25 Mar 2016 13:48:08 +0100 as excerpted:

> On 25 March 2016 at 12:49, Stephen Williams <stephenw@veryfast.biz>
> wrote:
>>
>> So catch 22, you need all the drives otherwise it won't let you mount,
>> But what happens if a drive dies and the OS doesn't detect it? BTRFS
>> wont allow you to mount the raid volume to remove the bad disk!
> 
> Version of Linux and btrfs-progs?

Yes, please.  This can be very critical information as a lot of bugs will 
be fixed in new versions that are known to exist in older versions, and 
occasionally new ones are introduced as well, where older versions won't 
be affected.

> You can't have a raid10 with less than 4 devices so you need to add a
> new device before deleting the missing. That is of course still a
> problem with a read-only fs.
> 
> btrfs replace is also the recommended way to replace a failed device
> nowadays. The wiki is outdated.

In theory, what it's supposed to do in a missing device situation that 
takes it below the minimum (four devices for a raid10) for a given raid 
mode, is allow writable mounting, unless the number of missing devices is 
too high (more than one missing on raid10) to allow functional degraded 
operation.

What it will often end up doing in that case, since it can't write the 
full raid10, is once current raid10 chunks get filled up and it needs to 
create more, since it doesn't have enough devices to create them in 
raid10, it will degrade to creating them in raid1 mode.

The problem, however, is that on subsequent mounts, btrfs will see that 
single chunk in addition to the raid10 chunks, and will see the missing 
device, and knowing single mode is broken with /any/ missing devices, 
will at that point only mount read-only.

That's a currently known bug, which effectively means you may well get 
only one read-write mount to fix the problem, before btrfs will see that 
new single chunk created in the first degraded writable mount, and will 
refuse to mount writable again.

There are patches available that will fix this known bug by changing this 
detection to per-chunk, instead of per-filesystem.  The degraded-writable 
mount will still degrade to writing single chunks, but btrfs will see 
that all single chunks are accounted for, and all raid10 chunks only have 
one device missing and thus can still be used, and the filesystem will 
thus continue to be write mountable, unless of course another device 
fails.

But AFAIK, those patches were part of a patch set (the hot-spare patches) 
that as a whole wasn't picked for 4.5, tho by rights the per-chunk 
checking patches should have been cherry-picked as ready and fixing an 
existing bug, but weren't.  So as of 4.5, AFAIK, they still have to be 
applied separately before build.  Hopefully they'll be in 4.6.

However, while lack of the per-chunk checking patch would mean an 
expected situation of allowing only one degraded-writable mount before no 
more would be allowed, unless you got it to work once and didn't mention 
it, and unless that btrfs fi usage was from before that writable mount as 
it doesn't show the single-mode chunk that would then prevent further 
writable mounts, it looks like you may have a possibly related, but 
definitely more severe bug, as it appears you aren't even being allowed 
what would otherwise be expected to be that one-shot degraded-writable 
mount.

And without that, as mentioned, you have a problem, since you have to 
have a writable mount to repair the filesystem, and it's not allowing you 
even that one-shot writable mount that should be possible even with that 
known bug.

Assuming you're using a current kernel and post that information, it's 
quite likely the dev working on the other bug will be interested, and 
will have you build a kernel with those patches to see if that alone 
fixes it, before possibly having you try various debugging patches to 
hone in on the problem, if it doesn't, so he can hopefully duplicate the 
problem himself, and ultimately come up with a fix.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

