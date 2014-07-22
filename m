Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30536 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932101AbaGVVPf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 17:15:35 -0400
Message-ID: <53CED469.5040700@fb.com>
Date: Tue, 22 Jul 2014 17:15:21 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Cody P Schafer <dev@codyps.com>, Chris Samuel <chris@csamuel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: Blocked tasks on 3.15.1
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com> <1745216.hDa4tC2HJJ@merkaba> <53CE7ACF.7070109@fb.com> <5008370.djvLzDh1Vh@merkaba>
In-Reply-To: <5008370.djvLzDh1Vh@merkaba>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/22/2014 05:13 PM, Martin Steigerwald wrote:
> Am Dienstag, 22. Juli 2014, 10:53:03 schrieb Chris Mason:
>> On 07/19/2014 02:23 PM, Martin Steigerwald wrote:
>>>> Running 3.15.6 with this patch applied on top:
>>>>  - still causes a hang with `rsync -hPaHAXx --del /mnt/home/nyx/
>>>>  /home/nyx/`
>>>>
>>>> - no extra error messages printed (`dmesg | grep racing`) compared to
>>>> without the patch
>>>
>>> I got same results with 3.16-rc5 + this patch (see thread BTRFS hang with
>>> 3.16-rc5). 3.16-rc4 still is fine with me. No hang whatsoever so far.
>>>
>>>> To recap some details (so I can have it all in one place):
>>>>  - /home/ is btrfs with compress=lzo
>>>
>>> BTRFS RAID 1 with lzo.
>>>
>>>>  - I have _not_ created any nodatacow files.
>>>
>>> Me neither.
>>>
>>>>  - Full stack is: sata <-> dmcrypt <-> lvm <-> btrfs (I noticed others
>>>>
>>>> mentioning the use of dmcrypt)
>>>
>>> Same, except no dmcrypt.
>>
>> Thanks for the help in tracking this down everyone.  We'll get there!
>> Are you all running multi-disk systems (from a btrfs POV, more than one
>> device?)  I don't care how many physical drives this maps to, just does
>> btrfs think there's more than one drive.
> 
> As I told before I am using BTRFS RAID 1. Two logival volumes on two distinct 
> SSDs. RAID is directly in BTRFS, no SoftRAID here (which I wouldn´t want to 
> use with SSDs anyway).
> 

When you say logical volumes, you mean LVM right?  Just making sure I
know all the pieces involved.

-chris
