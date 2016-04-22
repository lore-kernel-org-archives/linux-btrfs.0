Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36882 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbcDVWOB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 18:14:01 -0400
Received: by mail-wm0-f52.google.com with SMTP id n3so46067515wmn.0
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Apr 2016 15:14:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57049D24.80300@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20160322133812.GK8095@twin.jikos.cz>
	<56F1FEAF.2070806@cn.fujitsu.com>
	<20160324134217.GP29764@twin.jikos.cz>
	<56F496AA.9000102@cn.fujitsu.com>
	<20160404165517.GD3412@twin.jikos.cz>
	<CAD=QJKjvKVZTdqVVZJGtve+9teRXgGpv4chY_NV7P5BuFwB1Gw@mail.gmail.com>
	<57049D24.80300@cn.fujitsu.com>
Date: Fri, 22 Apr 2016 18:14:00 -0400
Message-ID: <CAD=QJKgJ9JAgZAOSivJTL-bcLbdkP6UqGb0i6g=fS9j6XKtcLA@mail.gmail.com>
Subject: Re: [PATCH v8 00/27][For 4.7] Btrfs: Add inband (write time)
 de-duplication framework
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

On 6 April 2016 at 01:22, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Nicholas D Steeves wrote on 2016/04/05 23:47 -0400:
>>
>> It is unlikely that I will use dedupe, but I imagine your work will
>> apply tot he following wishlist:
>>
>> 1. Allow disabling of memory-backend hash via a kernel argument,
>> sysctl, or mount option for those of us have ECC RAM.
>>      * page_cache never gets pushed to swap, so this should be safe, no?
>
> And why it's related to ECC RAM? To avoid memory corruption which will
> finally lead to file corruption?
> If so, it makes sense.

Yes, my assumption is that a system with ECC will either correct the
error, or that an uncorrectable event will trigger the same error
handling procedure as if the software checksum failed.

> Also I didn't get the point when you mention page_cache.
> For hash pool, we didn't use page cache. We just use kmalloc, which won't be
> swapped out.
> For file page cache, it's not affected at all.

My apologies, I'm still very new to this, and my "point" only
demonstrates my lack of understanding.  Thank you for directing me to
the kmalloc-related sections.

>> 2. Implementing an intelligent cache so that it's possible to offset
>> the cost of hashing the most actively read data.  I'm guessing there's
>> already some sort of weighed cache eviction algorithm in place, but I
>> don't yet know how to look into it, let alone enough to leverage it...
>
>
> I not quite a fan of such intelligent but complicated cache design.
> The main problem is we are putting police into kernel space.
>
> Currently, either use last-recent-use in-memory backend, or use all-in
> ondisk backend.
> For user want more precious control on which file/dir shouldn't go through
> dedupe, they have the btrfs prop to set per-file flag to avoid dedupe.

I'm looking into a project for some (hopefully) safe,
low-hanging-fruit read optimisations, and read that

Qu Wenruo wrote on 2016/04/05 11:08 +0800:
> In-memory backend is much like an experimental field for new ideas,
> as it won't affect on-disk format at all."

Do you think that last-recent-use in-memory backend could be used in
this way?  Specifically, I'm wondering the even|odd PID method of
choosing which disk to read from could be replaced with the following
method for rotational disks:

The last-recent-use in-memory backend stores the value of last
allocation group (and/or transaction ID, or something else), with an
attached value of which disk did the IO.  I imagine it's possible to
minimize seeks by choosing the disk by getting the absolute value
difference between requested_location and last-recent-use_location of
each disk with a simple a static_cast.

Would the addition of that value pair (recent-use_location, disk) keep
things simple and maybe prove to be useful, or is last-recent-use
in-memory the wrong place for it?

Thank you for taking the time to reply,
Nicholas
