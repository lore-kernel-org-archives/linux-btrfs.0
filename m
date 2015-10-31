Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:33020 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbbJaTSm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 15:18:42 -0400
Received: by wmeg8 with SMTP id g8so32589486wme.0
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2015 12:18:41 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Subject: Re: Crash during mount -o degraded, kernel BUG at
 fs/btrfs/extent_io.c:2044
To: Erik Berg <btrfs@slipsprogrammoer.no>, linux-btrfs@vger.kernel.org
References: <n0bqib$2om$1@ger.gmane.org>
Message-ID: <5635140F.7040206@googlemail.com>
Date: Sat, 31 Oct 2015 20:18:39 +0100
MIME-Version: 1.0
In-Reply-To: <n0bqib$2om$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/23/2015 01:13 AM, Erik Berg wrote:
> So I intentionally broke this small raid6 fs on a VM to learn recovery
> strategies for another much bigger raid6 I have running (which also
> suffered a drive failure).
>
> Basically I zeroed out one of the drives (vdd) from under the running
> vm. Then ran an md5sum on a file on the fs to trigger some detection of
> data inconsistency. I ran a scrub, which completed "ok". Then rebooted.
>
> Now trying to mount the filesystem in degraded mode leads to a kernel
> crash.

I've tried this on a system running kernel 4.2.5 and got slightly 
different results.

Created a raid6 array with 4 drives and put some stuff on it. Zeroed out 
the second drive (sdc) and checked the md5 sums of said stuff (all OK, 
good) which caused errors to be logged (dmesg) complaining about 
checksum errors on the 4th drive (sde):
BTRFS warning (device sde): csum failed ino 259 off 1071054848 csum 
2566472073 expected csum 3870060223

This is misleading, these error messages might make one think that the 
4th drive is bad and has to be replaced, which would reduce the 
redundancy to the minimum because it's the second drive that's actually bad.

I started a scrub and this time, the checksum errors mentioned the right 
drive:
BTRFS: bdev /dev/sdc errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
BTRFS: checksum error at logical 38469632 on dev /dev/sdc, sector 19072: 
metadata leaf (level 0) in tree 7
...

This error mentions a file which is still correct:
BTRFS: checksum error at logical 2396721152 on dev /dev/sdc, sector 
2322056, root 5, inode 257, offset 142282752, length 4096, links 1 
(path: test1)

However, the scrub found uncorrectable errors, which shouldn't happen in 
a raid6 array with only 1 bad drive:
         total bytes scrubbed: 3.00GiB with 199314 errors
         error details: read=1 super=2 csum=199311
         corrected errors: 199306, uncorrectable errors: 6, unverified 
errors: 0
ERROR: There are uncorrectable errors.

So wiping one drive in a btrfs raid6 array turned it into a bad state 
with uncorrectable errors, which should not happen. But at least it's 
still mountable without using the degraded option.

Removing all the files on this filesystem (which were not corrupted) 
fixed the aforementioned uncorrectable errors, another scrub found no 
more errors:
         scrub started at Sat Oct 31 19:12:25 2015 and finished after 
00:01:15
         total bytes scrubbed: 1.60GiB with 0 errors

But it looks like there are still some "invisible" errors on this (now 
empty) filesystem; after rebooting and mounting it, this one error is 
logged:
BTRFS: bdev /dev/sdc errs: wr 0, rd 0, flush 0, corrupt 199313, gen 0

Not sure if this might be because I wiped that drive from the very 
beginning, effectively overwriting everything including MBR and other 
meta data. But whatever happened, a single bad drive (returning 
corrupted data) should not lead to fatal errors in a raid6 array.

Next, I recreated this raid6 array (same drives) and filled it with one 
file (dd if=/dev/urandom of=test bs=4M). I wiped the 2nd *and* 3rd drive 
(sdc and sdd) this time. I unmounted it and tried mounting it, which 
failed (again, sde is fine):
BTRFS (device sde): bad tree block start 0 63651840
BTRFS (device sde): bad tree block start 65536 63651840
BTRFS (device sde): bad tree block start 2360238080 63651840
BTRFS: open_ctree failed

After rebooting, these errors mentioned sdb instead of sde, which is the 
other good drive.

Is it possible to recover from this type of 2-drive failure?

What is that "invisible error" in the first test (empty fs after reboot)?




Philip
