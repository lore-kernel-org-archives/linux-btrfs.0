Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55327 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543AbaGUQqM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 12:46:12 -0400
Received: by mail-pd0-f176.google.com with SMTP id y10so9372614pdj.35
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jul 2014 09:46:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$7b757$4788e010$b65976c7$4d1c0bad@cox.net>
References: <loom.20140720T102642-239@post.gmane.org>
	<53CC1553.1020908@shiftmail.org>
	<20140721013609.6d99c399@natsu>
	<37e3a8cf8b7439d5cd2745b5efb9d37f.squirrel@webmail.wanet.net>
	<pan$7b757$4788e010$b65976c7$4d1c0bad@cox.net>
Date: Mon, 21 Jul 2014 09:46:07 -0700
Message-ID: <CAN05THTSG9czwpM7AYEPWg5hpZuJ=vjJrjz8yn5V0rXe5oguxA@mail.gmail.com>
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 20, 2014 at 7:48 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> ashford posted on Sun, 20 Jul 2014 12:59:21 -0700 as excerpted:
>
>> If you assume a 12ms average seek time (normal for 7200RPM SATA drives),
>> an 8.3ms rotational latency (half a rotation), an average 64kb write and
>> a 100MB/S streaming write speed, each write comes in at ~21ms, which
>> gives us ~47 IOPS.  With the 64KB write size, this comes out to ~3MB/S,
>> DISK LIMITED.
>
>> The 5MB/S that TM is seeing is fine, considering the small files he says
>> he has.
>
> Thanks for the additional numbers supporting my point. =:^)
>
> I had run some of the numbers but not to the extent you just did, so I
> didn't know where 5 MiB/s fit in, only that it wasn't entirely out of the
> range of expectation for spinning rust, given the current state of
> optimization... or more accurately the lack thereof, due to the focus
> still being on features.
>

That is actually nonsense.
Raid rebuild operates on the block/stripe layer and not on the filesystem layer.
It does not matter at all what the average file size is.

Raid rebuild is really only limited by disk i/o speed when performing
a linear read of the whole spindle using huge i/o sizes,
or, if you have multiple spindles on the same bus, the bus saturation speed.

Thus is is perfectly reasonabe to expect ~50MByte/second, per spindle,
when doing a raid rebuild.
That is for the naive rebuild that rebuilds every single stripe. A
smarter rebuild that knows which stripes are unused can skip the
unused stripes and thus become even faster than that.


Now, that the rebuild is off by an order of magnitude is by design but
should be fixed at some stage, but with the current state of btrfs it
is probably better to focus on other more urgent areas first.
