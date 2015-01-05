Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:43327 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbbAEHly (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 02:41:54 -0500
Received: by mail-yk0-f179.google.com with SMTP id 19so10138881ykq.38
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 23:41:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54AA10B3.3010900@ubuntu.com>
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
	<CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>
	<20141223211605.GC436@hungrycats.org>
	<CAJCQCtTK2OinQZakArtX4BD=JAz6UJr=dhc2xUbcqJJL1v6Kkw@mail.gmail.com>
	<549F7539.4050801@ubuntu.com>
	<CAJCQCtQOxfoeE9xRLpqohHK8WXW63x1gsOgJQEc8TtbRp67RoA@mail.gmail.com>
	<54A30F19.5050801@ubuntu.com>
	<CAJCQCtSyu7dvp9SoF4u6QV9hF3jAQLtpYv8-6MOHSoP_NQyQ7A@mail.gmail.com>
	<54A36A7C.1000005@ubuntu.com>
	<CAJCQCtR5qZmD2RgfQMSUe9BLtUtimTyf-itBM1Y+9hiRftfwgg@mail.gmail.com>
	<54AA10B3.3010900@ubuntu.com>
Date: Mon, 5 Jan 2015 00:41:53 -0700
Message-ID: <CAJCQCtRdnu_n3u2Tr5Ofo=+UPTyEFBYeWmpat6ioD+vtpFAYCw@mail.gmail.com>
Subject: Re: Uncorrectable errors on RAID-1?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 4, 2015 at 9:18 PM, Phillip Susi <psusi@ubuntu.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
> On 01/03/2015 12:31 AM, Chris Murphy wrote:

>> This is architecture astronaut territory.
>>
>> The system only has a terrible response for two reasons: 1. The
>> user spec'd the wrong hardware for the use case; 2. The distro
>> isn't automatically leveraging existing ways to mitigate that user
>> mistake by changing either SCT ERC on the drives, or the SCSI
>> command timer for each block device.
>
> No, it has terrible response because the kernel either waits an
> unreasonable time or fails the drive and kicks it out of the array
> instead of trying to repair it.

It's a default that works for more use cases than not. The kernel
isn't dynamically self-configuring, and it isn't even the kernel's job
to take the first step which is to enable and correctly set SCT ERC on
each drive.

I think assuming a large pile of causes for a drive freezing on a
command be treated as read errors (after the link reset) is a bad
idea. But since it's your idea, and I'm not a kernel developer, you
should propose it on linux-raid@ instead of arguing with me.


> Blaming the user for not buying
> better hardware is not an appropriate response for the kernel failing
> so badly to handle commonly available hardware that doesn't behave in
> the most ideal way.

"Hi, I'm a good and knowledgeable sysadmin. I buy hardware that's
explicitly stated in the company's marketing data sheet as being
incompatible with my use case. This is someone else's fault."

Sounds like buck passing.

>> Now, even though that solution *might* mean long recoveries on
>> occasion, it's still better than link reset behavior which is what
>> we have today because it causes the underlying problem to be fixed
>> by md/dm/Btrfs once the read error is reported. But no distro has
>> implemented this $500 man hour solution. Instead you're suggesting
>> a $500,000 fix that will take hundreds of man hours and end user
>> testing to find all the edge cases. It's like, seriously, WTF?
>
> Seriously?  Treating a timeout the same way you treat an unrecoverable
> media error is no herculean task.

So you keep saying.

But best practices is already known and tested, and can be done with a
startup script. Yet no distro does this for the user, even though its
much much simpler than what you're proposing, and actually fixes both
sources of the problem.

That it is in your opinion an imperfect fix is not relevant. It's
still better behavior than what we have today, and yet still no distro
does this, thereby tacitly preferring status quo. And if the current
behavior is simply good enough no one has taken action to implement
automatically the known best practice work around of the day, why
should kernel developers gives two shits about this idea? Sounds like
more buck passing.



>> http://www.seagate.com/files/www-content/support-content/documentation/product-manuals/en-us/Enterprise/Savvio/Savvio%2015K.3/100629381e.pdf
>>
>>  That's a high end SAS drive. It's default is to retry up to 20
>> times, which takes ~1.4 seconds, per sector. But also note how it
>> says
>
> 20 retries on a 15,000 rpm drive only takes 80 milliseconds, not 1.4
> seconds.  15,000 rpm / 60 seconds per minute = 250 rotations/retries
> per second.

The PDF contains a table saying 20 retries takes 1.4 seconds. I didn't
compute this number myself, it's in the bloody manufacturer's own
documentation. Obviously the ECC is doing things that take more than
one revolution of the spindle.

>
>> Maybe you'd prefer seeing these big, cheap, "green" drives have
>> shorter ERC times, with a commensurate reality check with their
>> unrecoverable error rate, which right now is already two orders
>> magnitude higher than enterprise SAS drives. So what if this means
>> that rate is 3 or 4 orders magnitude higher?
>
> 20 retries vs. 200 retries does not reduce the URE rate by orders of
> magnitude; more like 1% *maybe*.  200 vs 2000 makes no measurable
> difference at all.

I see, well I guess you prefer believing in fraud and conspiracy
theories, by multiple companies, to screw users over, while they admit
the incompatibility of the intended use case on their data sheets.


-- 
Chris Murphy
