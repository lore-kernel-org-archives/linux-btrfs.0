Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48450 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbbHAVpZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 1 Aug 2015 17:45:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZLeap-00070n-9m
	for linux-btrfs@vger.kernel.org; Sat, 01 Aug 2015 23:45:23 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2015 23:45:23 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2015 23:45:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Data single *and* raid?
Date: Sat, 1 Aug 2015 21:45:16 +0000 (UTC)
Message-ID: <pan$7fbcf$6323c57d$e51a436f$80a59676@cox.net>
References: <55BD277F.2040201@friedels.name>
	<20150801203258.GA14352@carfax.org.uk>
	<CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 01 Aug 2015 14:44:52 -0600 as excerpted:

> On Sat, Aug 1, 2015 at 2:32 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Sat, Aug 01, 2015 at 10:09:35PM +0200, Hendrik Friedel wrote:
>>> Hello,
>>>
>>> I converted an array to raid5 by
>>> btrfs device add /dev/sdd /mnt/new_storage
>>> btrfs device add /dev/sdc /mnt/new_storage btrfs
>>> balance start -dconvert=raid5 -mconvert=raid5 /mnt/new_storage/
>>>
>>> The Balance went through. But now:
>>> Label: none  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
>>>         Total devices 3 FS bytes used 5.28TiB
>>>	    devid    1 size 2.73TiB  used 2.57TiB path /dev/sde
>>> 	    devid    2 size 2.73TiB used  2.73TiB path /dev/sdc
>>>	    devid    3 size 2.73TiB used 2.73TiB  path /dev/sdd
>>> btrfs-progs v4.1.1
>>>
>>> Already the 2.57TiB is a bit surprising:
>>> root@homeserver:/mnt# btrfs fi df /mnt/new_storage/
>>> Data, single: total=2.55TiB, used=2.55TiB
>>> Data, RAID5: total=2.73TiB, used=2.72TiB
>>> System, RAID5: total=32.00MiB, used=736.00KiB
>>> Metadata, RAID1: total=6.00GiB, used=5.33GiB
>>> Metadata, RAID5: total=3.00GiB, used=2.99GiB
>>
>>    Looking at the btrfs fi show output, you've probably run out of
>> space during the conversion, probably due to an uneven distribution of
>> the original "single" chunks.
>>
>>    I think I would suggest balancing the single chunks, and trying the
>> conversion (of the unconverted parts) again:
>>
>> # btrfs balance start -dprofiles=single -mprofile=raid1
>> /mnt/new_storage/
>> # btrfs balance start -dconvert=raid5,soft -mconvert=raid5,soft
>> /mnt/new_storage/
>>
>>
> Yep I bet that's it also. btrfs fi usage might be better at exposing
> this case.

Does fi usage deal with raid5 yet?

Last I knew it didn't deal with raid56 (which I'm not using) or with 
mixed-bg (which I am using on one btrfs).  On the mixed-bg btrfs it still 
warns it doesn't handle that, reporting unallocated of 16 EiB on a 256 
MiB filesystem, so clearly the warning is valid.  16 EiB unallocated on a 
256 MiB btrfs, I wish!  progs v4.1.2, latest as of yesterday, I believe.


Meanwhile, three devices the same size.  He just added two of them and 
didn't do a rebalance after that until the raid5 conversion, so except 
for anything added since, all data/metadata should have started on a 
single device, with single data and dup metadata.  The conversion was 
specifically to raid5 for both data/metadata, so that's what he should 
have ended up with.

But, somewhere along the line he got 6 GiB of raid1 metadata.  Either he 
added/rewrote a *BUNCH* of files after adding at least one device before 
the conversion that he didn't tell us about, or the conversion screwed 
up, because that's a lot of raid1 metadata coming out of nowhere!


But I'm *strongly* suspecting a pre-full-raid56-support kernel, because 
btrfs-progs is certainly reasonably new (v4.1.1, as of yesterday 4.1.2 is 
the newest as I mention above), but the fi df doesn't report global 
reserve.  The only way I know of that it wouldn't report that with a new 
userspace is if the kernelspace is too old.  And AFAIK, the kernel was 
reporting global reserve (with fi df listing it as unknown if it was too 
old) _well_ before full raid56 support.  So it's gotta be an old kernel, 
with only partial raid56 support, which might explain the weird to-raid56 
conversion results.


Finally, that's btrfs-progs 4.1.1, the one that's blacklisted due to a 
buggy mkfs.btrfs.  If he created the filesystem with that mkfs.btrfs... 
maybe that explains the funky results, as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

