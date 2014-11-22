Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mdfmta010.mxout.tch.inty.net ([91.221.169.51]:34212 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750727AbaKVHSo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 02:18:44 -0500
Received: from mdfmta010.tch.inty.net (unknown [127.0.0.1])
	by mdfmta010.tch.inty.net (Postfix) with ESMTP id 047F5401CD2
	for <linux-btrfs@vger.kernel.org>; Sat, 22 Nov 2014 07:18:53 +0000 (GMT)
Received: from mdfmta010.tch.inty.net (unknown [127.0.0.1])
	by mdfmta010.tch.inty.net (Postfix) with ESMTP id CE358401CC8
	for <linux-btrfs@vger.kernel.org>; Sat, 22 Nov 2014 07:18:52 +0000 (GMT)
Received: from iarmst.demon.co.uk (unknown [62.49.16.35])
	by mdfmta010.tch.inty.net (Postfix) with SMTP
	for <linux-btrfs@vger.kernel.org>; Sat, 22 Nov 2014 07:18:52 +0000 (GMT)
Date: Sat, 22 Nov 2014 07:18:39 +0000
From: Ian Armstrong <btrfs@iarmst.co.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
Message-ID: <20141122071839.3761fb78@spike.private.network>
In-Reply-To: <CAJCQCtRFdhBVmW37xfyJraKZ7be3ba1Kuw-70W=FyZm3NLLJ1g@mail.gmail.com>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
 <546AF572.2020101@swiftspirit.co.za>
 <20141121045801.GS17395@hungrycats.org>
 <546EE43C.7020900@swiftspirit.co.za>
 <20141121125548.4ed20963@spike.private.network>
 <CAJCQCtRFdhBVmW37xfyJraKZ7be3ba1Kuw-70W=FyZm3NLLJ1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 21 Nov 2014 10:45:21 -0700 Chris Murphy wrote:

> On Fri, Nov 21, 2014 at 5:55 AM, Ian Armstrong <btrfs@iarmst.co.uk>
> wrote:
> 
> > In my situation what I've found is that if I scrub & let it fix the
> > errors then a second pass immediately after will show no errors. If
> > I then leave it a few days & try again there will be errors, even in
> > old files which have not been accessed for months.
> 
> What are the devices? And if they're SSDs are they powered off for
> these few days? I take it the scrub error type is corruption?

It's spinning rust and the checksum error is always on the one drive
(a SAMSUNG HD204UI). The firmware has been updated, since some were
shipped with a bad version which could result in data corruption.

> You can use badblocks to write a known pattern to the drive. Then
> power off and leave it for a few days. Then read the drive, matching
> against the pattern, and see if there are any discrepancies. Doing
> this outside the code path of Btrfs would fairly conclusively indicate
> whether it's hardware or software induced.

Unfortunately I'm reluctant to go the badblock route for the entire
drive since it's the second drive in a 2 drive raid1 and I don't
currently have a spare. There is a small 6G partition that I can use,
but given that the drive is large and the errors are few, it could take
a while for anything to show.

I also have a second 2 drive btrfs raid1 in the same machine that
doesn't have this problem. All the drives are running off the same
controller.

> Assuming you have another copy of all of these files :-) you could
> just sha256sum the two copies to see if they have in fact changed. If
> they have, well then you've got some silent data corruption somewhere
> somehow. But if they always match, then that suggests a bug.

Some of the files already have an md5 linked to them, while others have
parity files to give some level of recovery from corruption or damage.
Checking against these show no problems, so I assume that btrfs is
doing its job & only serving an intact file.

> I don't
> see how you can get bogus corruption messages, and for it to not be a
> bug. When you do these scrubs that come up clean, and then later come
> up with corruptions, have you done any software updates?

No software updates between clean & corrupt. I don't have to power down
or reboot either for checksum errors to appear.

I don't think the corruption messages are bogus, but are indicating a
genuine problem. What I would like to be able to do is compare the
corrupt block with the one used to repair it and see what the difference
is. As I've already stated, the system logs are clean & the smart logs
aren't showing any issues. (Well, until today when a self-test failed
with a read error, but it must be an unused sector since the scrub
doesn't hit it & there are no re-allocated sectors yet)

> > My next step is to disable autodefrag & see if the problem persists.
> > (I'm not suggesting a problem with autodefrag, I just want to
> > remove it from the equation & ensure that outside of normal file
> > access, data isn't being rewritten between scrubs)
> 
> I wouldn't expect autodefrag to touch old files not accessed for
> months. Doesn't it only affect actively used files?

The drive is mainly used to hold old archive files, though there are
daily rotating files on it as well. The corruption affects both new and
old files.

-- 
Ian
