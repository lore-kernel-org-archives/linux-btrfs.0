Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:62005 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaHWEN7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 00:13:59 -0400
Received: by mail-oi0-f53.google.com with SMTP id e131so8338936oig.40
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 21:13:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$fd73$abec75f5$f92eda58$95927b3e@cox.net>
References: <e464a0229fbd354aea0d15d8342330b1@admin.virtall.com>
	<CADw2B2MgvUt_bL11ZOAZjyk+R2pmM5JbLVjmgqoXBHSTEypMqw@mail.gmail.com>
	<40ee87d5d8b24230774bf28018ceb289@admin.virtall.com>
	<CADw2B2Ow+s+V03vT_WPMH5w9pWck-d0uaDi6KjLGOygKugAciA@mail.gmail.com>
	<pan$fd73$abec75f5$f92eda58$95927b3e@cox.net>
Date: Fri, 22 Aug 2014 21:13:58 -0700
Message-ID: <CADw2B2P8bPwzcQeO0r5VnLXSJFO+MG_D5egUQ9pJG5M60J0UuA@mail.gmail.com>
Subject: Re: btrfs and iostat - how do I measure the live performance of my
 btrsf filesystems?
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Um. Derp. Yeah, it's actually sd[defh].

Thanks for the continuing education.

On Fri, Aug 22, 2014 at 8:24 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> G. Richard Bellamy posted on Fri, 22 Aug 2014 14:36:22 -0700 as excerpted:
>
>> An interesting exercise saw me reading data from my RAID10 to a USB
>> device, which produced the following representative iostat:
>>
>> Linux 3.14.17-1-lts (eanna) 08/22/2014 _x86_64_ (24 CPU)
>>
>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>            3.53    0.00    0.50    2.83    0.00   93.14
>>
>> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
>> sda               1.89         0.01         0.01        839        998
>> sdc               0.00         0.00         0.00          1          0
>> sdb               1.23         0.02         0.01       1254        998
>
>> sdi             175.40         0.00        20.26         39    1454881
>
>> sdd               0.26         0.01         0.00        827         58
>> sde              28.86        12.29         0.00     882447         61
>> sdf               0.00         0.00         0.00          1          0
>> sdh              25.25        12.29         0.00     882448         57
>> sdg               0.25         0.01         0.00        826         60
>>
>> /dev/sdi is the USB drive, and /dev/sd[defg] are the four devices in the
>> raid10 volume. I'm reading a large (1.1T) file from the raid10 volume
>> and writing it to the USB drive.
>>
>> You can see that there are approximately two drives from the raid10
>> which are being read from - I assume this corresponds to the two spans
>> (the 'no lower than the (n/spans)x' speed I mentioned in my original
>> post - and that they aggregate to 24.58MB/s reads. This corresponds to
>> the 20.26MB/s writes to the USB drive.
>>
>> The raid10 volume is only being used for this file operation, nothing
>> else is touching it but the kernel and btrfs.
>>
>> I'm curious how others would read this?
>
> Something's not adding up.  You say sd[defg] are the btrfs raid10, but
> it's sde and sdh that are getting the read traffic.  Are you sure sdh
> isn't part of the raid10 and one of sd[dfg] (perhaps f, seeing d and g
> appear to balance out leaving f the odd one out?) is?
>
> Assuming sdh is indeed part of the raid10, it makes sense, and the fact
> that only two of the four devices are being active read matches what's
> known about btrfs raid1/10 at this point -- it has a relatively dumb read
> allocation algorithm that was good enough for a first implementation but
> obviously isn't optimal, reads are allocated based on the last bit of the
> PID (or TID IDR which), so even/odd.  Since this is a single transfer
> process, all the activity is on one or the other, so it's reading from
> the two device wide stripe, but always from the same one of the two
> mirrors supporting each strip.
>
> If you had a second read process going on and it was the same even/odd
> pid, you'd be doubling up on the same two devices.  Only with a
> relatively even mix of even/odd pid reads will you see things even out
> across all four.  See what I mean about a "relatively dumb" not well
> optimized first implementation?
>
> As they say btrfs is stabilizing now, presumably one of these kernel
> cycles we'll see something better in terms of read mirror allocation
> algorithm, perhaps as part of N-way-mirroring, when that gets implemented
> (roadmapped for after raid5/6 is completed, it's two-way-mirroring only
> now, regardless of the number of devices).
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
