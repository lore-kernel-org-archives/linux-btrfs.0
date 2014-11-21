Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:40751 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaKURpW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 12:45:22 -0500
Received: by mail-yh0-f42.google.com with SMTP id v1so2604708yhn.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 09:45:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141121125548.4ed20963@spike.private.network>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
	<546AF572.2020101@swiftspirit.co.za>
	<20141121045801.GS17395@hungrycats.org>
	<546EE43C.7020900@swiftspirit.co.za>
	<20141121125548.4ed20963@spike.private.network>
Date: Fri, 21 Nov 2014 10:45:21 -0700
Message-ID: <CAJCQCtRFdhBVmW37xfyJraKZ7be3ba1Kuw-70W=FyZm3NLLJ1g@mail.gmail.com>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
From: Chris Murphy <lists@colorremedies.com>
To: Ian Armstrong <btrfs@iarmst.co.uk>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 21, 2014 at 5:55 AM, Ian Armstrong <btrfs@iarmst.co.uk> wrote:

> In my situation what I've found is that if I scrub & let it fix the
> errors then a second pass immediately after will show no errors. If I
> then leave it a few days & try again there will be errors, even in
> old files which have not been accessed for months.

What are the devices? And if they're SSDs are they powered off for
these few days? I take it the scrub error type is corruption?

You can use badblocks to write a known pattern to the drive. Then
power off and leave it for a few days. Then read the drive, matching
against the pattern, and see if there are any discrepancies. Doing
this outside the code path of Btrfs would fairly conclusively indicate
whether it's hardware or software induced.

Assuming you have another copy of all of these files :-) you could
just sha256sum the two copies to see if they have in fact changed. If
they have, well then you've got some silent data corruption somewhere
somehow. But if they always match, then that suggests a bug. I don't
see how you can get bogus corruption messages, and for it to not be a
bug. When you do these scrubs that come up clean, and then later come
up with corruptions, have you done any software updates?


> My next step is to disable autodefrag & see if the problem persists.
> (I'm not suggesting a problem with autodefrag, I just want to remove it
> from the equation & ensure that outside of normal file access, data
> isn't being rewritten between scrubs)

I wouldn't expect autodefrag to touch old files not accessed for
months. Doesn't it only affect actively used files?


-- 
Chris Murphy
