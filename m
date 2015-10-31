Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33869 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbbJaXgp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 19:36:45 -0400
Received: by wikq8 with SMTP id q8so31201927wik.1
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2015 16:36:44 -0700 (PDT)
Received: from [10.0.2.15] (p50887EF2.dip0.t-ipconnect.de. [80.136.126.242])
        by smtp.googlemail.com with ESMTPSA id m143sm10104746wmb.1.2015.10.31.16.36.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 31 Oct 2015 16:36:43 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Subject: Re: Crash during mount -o degraded, kernel BUG at
 fs/btrfs/extent_io.c:2044
To: linux-btrfs@vger.kernel.org
References: <n0bqib$2om$1@ger.gmane.org> <5635140F.7040206@googlemail.com>
Message-ID: <5635508A.4080401@googlemail.com>
Date: Sun, 1 Nov 2015 00:36:42 +0100
MIME-Version: 1.0
In-Reply-To: <5635140F.7040206@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2015 08:18 PM, Philip Seeger wrote:
> On 10/23/2015 01:13 AM, Erik Berg wrote:
>> So I intentionally broke this small raid6 fs on a VM to learn recovery
>> strategies for another much bigger raid6 I have running (which also
>> suffered a drive failure).
>>
>> Basically I zeroed out one of the drives (vdd) from under the running
>> vm. Then ran an md5sum on a file on the fs to trigger some detection of
>> data inconsistency. I ran a scrub, which completed "ok". Then rebooted.
>>
>> Now trying to mount the filesystem in degraded mode leads to a kernel
>> crash.
>
> I've tried this on a system running kernel 4.2.5 and got slightly
> different results.

And I've now tried it with kernel 4.3-rc7 and got similar results.

> Created a raid6 array with 4 drives and put some stuff on it. Zeroed out
> the second drive (sdc) and checked the md5 sums of said stuff (all OK,
> good) which caused errors to be logged (dmesg) complaining about
> checksum errors on the 4th drive (sde):
> BTRFS warning (device sde): csum failed ino 259 off 1071054848 csum
> 2566472073 expected csum 3870060223

Same issue, this time sdd. The error message appears to chose a random 
device.

> This error mentions a file which is still correct:

Same issue.

> However, the scrub found uncorrectable errors, which shouldn't happen in
> a raid6 array with only 1 bad drive:

This did not happen, the scrub fixed errors and found no uncorrectable 
errors.

> But it looks like there are still some "invisible" errors on this (now
> empty) filesystem; after rebooting and mounting it, this one error is
> logged:
> BTRFS: bdev /dev/sdc errs: wr 0, rd 0, flush 0, corrupt 199313, gen 0

However, this "invisible" error shows up even with this kernel version.

So I'm still wondering why this error is happening even after a 
successful scrub.



Philip
