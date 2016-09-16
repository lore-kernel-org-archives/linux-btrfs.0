Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:37430 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759475AbcIPLpG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 07:45:06 -0400
Received: by mail-it0-f44.google.com with SMTP id 186so14240288itf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Sep 2016 04:45:06 -0700 (PDT)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id z130sm3583322iod.17.2016.09.16.04.45.04
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Sep 2016 04:45:04 -0700 (PDT)
Subject: Re: Thoughts on btrfs RAID-1 for cold storage/archive?
To: linux-btrfs@vger.kernel.org
References: <CAJtFHUQOW4RBZcOu0FWe7dVoxTJWD9bMjvaXYLkXy_Pw7meC-g@mail.gmail.com>
 <pan$2e9b3$e0d80028$f8a083d5$b81c2a7b@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <65ec0d34-9c50-299f-83bd-bd671a52970f@gmail.com>
Date: Fri, 16 Sep 2016 07:45:03 -0400
MIME-Version: 1.0
In-Reply-To: <pan$2e9b3$e0d80028$f8a083d5$b81c2a7b@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-15 22:58, Duncan wrote:
> E V posted on Thu, 15 Sep 2016 11:48:13 -0400 as excerpted:
>
>> I'm investigating using btrfs for archiving old data and offsite
>> storage, essentially put 2 drives in btrfs RAID-1, copy the data to the
>> filesystem and then unmount, remove a drive and take it to an offsite
>> location. Remount the other drive -o ro,degraded until my systems slots
>> fill up, then remove the local drive and put it on a shelf. I'd verify
>> the file md5sums after data is written to the drive for piece of mind,
>> but maybe a btrfs scrub would give the same assurances. Seem
>> straightforward? Anything to look out for? Long term format stability
>> seems good, right? Also, I like the idea of being able to pull the
>> offsite drive back and scrub if the local drive ever has problems, a
>> nice extra piece of mind we wouldn't get with ext4. Currently using the
>> 4.1.32 kernel since the driver for the r750 card in our 45 drives system
>> only supports up to 4.3 ATM.
>
> As described I believe it should work fine.
>
> Btrfs raid1 isn't like normal raid1 in some ways and in particular isn't
> designed to be mounted degraded, writable, long term, only temporarily,
> in ordered to replace a bad device.  As that's what I thought you were
> going to propose when I read the subject line, I was all ready to tell
> you no, don't try it and expect it to work, but of course you had
> something different in mind, only read-only mounting of the degraded
> raid1 (unless needed for scrub, etc), not mounting it writable, and as
> long as you are careful to do just that, only mount it read-only, you
> should be fine.
>
While I generally agree with Duncan that this should work if you're 
careful, I will say that as things stand right now, you almost certainly 
_SHOULD NOT_ be using BTRFS for archival storage, be it in the way 
you're talking about, or even just as a back-end filesystem for some 
other setup.  While I consider it stable enough for regular usage, the 
number of issues is still too significant IMO to trust long term 
archival data storage to it.

There are lots of other options for high density archival storage, and 
most of them are probably better than BTRFS at the moment.  For 
reference, here's what I would do if I needed archival storage beyond a 
few months:
1. Use SquashFS to create a mountable filesystem image containing the 
data to be archived.
2. Compute and store checksums for the resultant FS image (probably SHA256)
3. Using veritysetup, dm-verity, and the new forward error correction it 
provides, generate block-level authenticated checksums for the whole 
image, including enough data to repair reasonable data corruption.
4. Compute and store checksums for the resultant dm-verity data.
5. Compress the data from dm-verity (using the same compression 
algorithm as used in the SquashFS image).
6. Create a tar archive containing the SquashFS image, the compressed 
dm-verity data, and a file with the checksums.
7. Store that tar archive in at least two different places.

When restoring data:
1. Collect copies of the tar archive from at least two different places.
2. For both copies:
	1. Extract the tar archive and decompress the dm-verity data.
	2. Verify the checksum of the dm-verity data.
	3. If the dm-verity data's checksum is correct, set up a dm-verity 
target using that and the SquashFS image.
	4. If the dm-verity data's checksum is incorrect, verify the checksum 
of the SquashFS archive.
	5. If the SquashFS archive's checksum is correct, use it directly, 
otherwise discard this copy.
3. Create a read-only dm-raid RAID1 array containing all of the 
dm-verity backed devices and SquashFS images with in-core sync-logging.
4. Mount the resultant device, and copy any data out.

That will overall give a better level of protection than BTRFS, or ZFS, 
or almost anything else available on Linux right now can offer, and 
actually provides better data safety than many commercial solutions. 
The only down side is that you need recent device-mapper userspace and a 
recent kernel to create and extract things.
