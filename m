Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:36990 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaFYJA7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 05:00:59 -0400
Received: by mail-yk0-f180.google.com with SMTP id 131so909259ykp.39
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 02:00:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140625074713.GE31096@carfax.org.uk>
References: <CACQTm-go5jGan9kP-dVq7Oi4b+AGWuFkb0Nudc2i9V1SG-oc3Q@mail.gmail.com>
	<20140625074713.GE31096@carfax.org.uk>
Date: Wed, 25 Jun 2014 11:00:58 +0200
Message-ID: <CACQTm-jL6sraLwgGRay6JQ2xkXfcsgtQTF0YE80jxHUkM6fwcA@mail.gmail.com>
Subject: Re: btrfs data dup on single device?
From: Daniel Landstedt <daniel.landstedt@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        Daniel Landstedt <daniel.landstedt@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>    It'll be exactly 2 copies at the moment. Note that performance on
> an SSD will at least halve, and performance on a rotational device
> will probably suck quite badly. Neither will help you in the case of a
> full-device failure. You still need backups, kept on a separate machine.
>

Write performance, sure, but reads shouldn't be that much slower?
For DUP on same device I was thinking about family photos, source code
and such, not for compiles or databases with a lot of queries.
Of course you need backups, offsite backups.. I had a fire a couple of
years ago, and, well.. If the second machine also is in the vicinity..
We were lucky this time, but a couple of more minutes and all would
have been lost. Got me thinking a bit more.

>    The question is, why? If you have enough disk media errors to make
> it worth using multiple copies, then your storage device is basically
> broken and needs replacing, and it can't really be relied on for very
> much longer.

I was thinking that DUP on same device was mostly for protection
against bit rot and smaller errors, not device failure.
If the device starts to misbehave, it might be enough to rescue the
data to another device if you have DUPes. Ok, a backup will probably
help there too.

I'm putting together a new server at home, and want the checksums in
btrfs, and multiple copies of the important data. As I understand it
it's better than RAID6 that I used earlier, which has it's own set of
problems.
And multiple offsite backups.

I'll try and see if it's possible to use DUP for data on same device,
when I looked around it seemed as it wasn't possible.

>
>    Hugo.
>



Daniel
