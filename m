Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:60515 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaHVVnj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 17:43:39 -0400
Received: by mail-oi0-f47.google.com with SMTP id x69so8139716oia.6
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 14:43:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40ee87d5d8b24230774bf28018ceb289@admin.virtall.com>
References: <e464a0229fbd354aea0d15d8342330b1@admin.virtall.com>
	<CADw2B2MgvUt_bL11ZOAZjyk+R2pmM5JbLVjmgqoXBHSTEypMqw@mail.gmail.com>
	<40ee87d5d8b24230774bf28018ceb289@admin.virtall.com>
Date: Fri, 22 Aug 2014 14:36:22 -0700
Message-ID: <CADw2B2Ow+s+V03vT_WPMH5w9pWck-d0uaDi6KjLGOygKugAciA@mail.gmail.com>
Subject: Re: btrfs and iostat - how do I measure the live performance of my
 btrsf filesystems?
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An interesting exercise saw me reading data from my RAID10 to a USB
device, which produced the following representative iostat:

Linux 3.14.17-1-lts (eanna) 08/22/2014 _x86_64_ (24 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           3.53    0.00    0.50    2.83    0.00   93.14

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda               1.89         0.01         0.01        839        998
sdc               0.00         0.00         0.00          1          0
sdb               1.23         0.02         0.01       1254        998
sdi             175.40         0.00        20.26         39    1454881
sdd               0.26         0.01         0.00        827         58
sde              28.86        12.29         0.00     882447         61
sdf               0.00         0.00         0.00          1          0
sdh              25.25        12.29         0.00     882448         57
sdg               0.25         0.01         0.00        826         60

/dev/sdi is the USB drive, and /dev/sd[defg] are the four devices in
the raid10 volume. I'm reading a large (1.1T) file from the raid10
volume and writing it to the USB drive.

You can see that there are approximately two drives from the raid10
which are being read from - I assume this corresponds to the two spans
(the 'no lower than the (n/spans)x' speed I mentioned in my original
post - and that they aggregate to 24.58MB/s reads. This corresponds to
the 20.26MB/s writes to the USB drive.

The raid10 volume is only being used for this file operation, nothing
else is touching it but the kernel and btrfs.

I'm curious how others would read this?

On Tue, Aug 5, 2014 at 4:39 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> On 2014-08-06 00:06, G. Richard Bellamy wrote:
>>
>> On Tue, Aug 5, 2014 at 7:14 AM, Tomasz Chmielewski <mangoo@wpkg.org>
>> wrote:
>>>
>>> Simple iostat won't give you meaningful live performance stats.
>>>
>>> You can combine it i.e. like below:
>>>
>>> iostat -x 1
>>> iostat -mx 1
>>> iostat -m 1
>>
>>
>> Thanks for the pointer about viewing the extended stats, and showing
>> them in MB rather than kB.
>>
>> Maybe I'm missing something here. I'm failing to see how adding those
>> additional stats helps me get meaningful throughput information for a
>> multi-device btrfs volume.
>
>
> Well you won't see an aggregate, but you will see individual device
> statistics with "1" at the end of iostat arguments (meaning, dump the stats
> every second).
>
>
>
> --
> Tomasz Chmielewski
> http://www.sslrack.com
>
