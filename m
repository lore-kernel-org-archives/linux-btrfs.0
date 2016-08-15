Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:35833 "EHLO
	mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbcHOMpD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 08:45:03 -0400
Received: by mail-it0-f51.google.com with SMTP id u186so36448065ita.0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 05:45:03 -0700 (PDT)
Subject: Re: How to stress test raid6 on 122 disk array
To: Martin <rc6encrypted@gmail.com>
References: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
 <274e0a56-086f-23c4-7ae9-2b6cb68ec6c8@gmail.com>
 <CAJCQCtQAPXn714YL2R1V7q2fhn7QCsYHHceTimyFQ1TsMf-BQg@mail.gmail.com>
 <CAGQ70Yf3R4mfPJRZWvyBXivN9qy_9WOsrZhdpx--a_27Wy3sYQ@mail.gmail.com>
 <CAJCQCtTKsYxYH26E1a66--HiDRF3JXSdOSjLa1ira_1Ti6N+pw@mail.gmail.com>
 <a119738d-942b-4dca-265e-5f9db15e2893@gmail.com>
 <CAGQ70YdW+t_-vqj+uvyKMxoPLN__bxZ=b+S1oe7ujw3Ek0Cggg@mail.gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <71a331cf-b8cf-73f0-74a2-db09a21e5d04@gmail.com>
Date: Mon, 15 Aug 2016 08:44:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAGQ70YdW+t_-vqj+uvyKMxoPLN__bxZ=b+S1oe7ujw3Ek0Cggg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-15 08:19, Martin wrote:
>>> I'm not sure what Arch does any differently to their kernels from
>>> kernel.org kernels. But bugzilla.kernel.org offers a Mainline and
>>> Fedora drop down for identifying the kernel source tree.
>>
>> IIRC, they're pretty close to mainline kernels.  I don't think they have any
>> patches in the filesystem or block layer code at least, but I may be wrong,
>> it's been a long time since I looked at an Arch kernel.
>
> Perhaps I should use Arch then, as Fedora rawhide kernel wouldn't boot
> on my hw, so I am running the stock Fedora 24 kernel right now for the
> tests...
>
>>>> If I want to compile a mainline kernel. Are there anything I need to
>>>> tune?
>>>
>>>
>>> Fedora kernels do not have these options set.
>>>
>>> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
>>> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
>>> # CONFIG_BTRFS_DEBUG is not set
>>> # CONFIG_BTRFS_ASSERT is not set
>>>
>>> The sanity and integrity tests are both compile time and mount time
>>> options, i.e. it has to be compiled enabled for the mount option to do
>>> anything. I can't recall any thread where a developer asked a user to
>>> set any of these options for testing though.
>
>> FWIW, I actually have the integrity checking code built in on most kernels I
>> build.  I don't often use it, but it has near zero overhead when not
>> enabled, and it's helped me track down lower-level storage configuration
>> issues on occasion.
>
> I'll give that a shot tomorrow.
>
>>>> When I do the tests, how do I log the info you would like to see, if I
>>>> find a bug?
>>>
>>>
>>> bugzilla.kernel.org for tracking, and then reference the URL for the
>>> bug with a summary in an email to list is how I usually do it. The
>>> main thing is going to be the exact reproduce steps. It's also better,
>>> I think, to have complete dmesg (or journalctl -k) attached to the bug
>>> report because not all problems are directly related to Btrfs, they
>>> can have contributing factors elsewhere. And various MTAs, or more
>>> commonly MUAs, have a tendancy to wrap such wide text as found in
>>> kernel or journald messages.
>>
>> Aside from kernel messages, the other general stuff you want to have is:
>> 1. Kernel version and userspace tools version (`uname -a` and `btrfs
>> --version`)
>> 2. Any underlying storage configuration if it's not just plain a SSD/HDD or
>> partitions (for example, usage of dm-crypt, LVM, mdadm, and similar things).
>> 3. Output from `btrfs filesystem show` (this can be trimmed to the
>> filesystem that's having the issue).
>> 4. If you can still mount the filesystem, `btrfs filesystem df` output can
>> be helpful.
>> 5. If you can't mount the filesystem, output from `btrfs check` run without
>> any options will usually be asked for.
>
> I have now had the first crash, can you take a look if I have provided
> the needed info?
>
> https://bugzilla.kernel.org/show_bug.cgi?id=153141
>
> How long should I keep the host untouched? Or is all interesting idea provided?
>
Looking at the kernel log itself, you've got a ton of write errors on 
/dev/sdap.  I would suggest checking that particular disk with smartctl, 
and possibly checking the other hardware involved (the storage 
controller and cabling).

I would kind of expect BTRFS to crash with that many write errors 
regardless of what profile is being used, but we really should get 
better about reporting errors to user space in a sane way (making people 
dig through kernel logs to figure out their having issues like this is 
not particularly user friendly).
