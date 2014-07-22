Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.54]:58647 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaGVPPT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 11:15:19 -0400
Message-ID: <53CE7FF3.3040501@skagestad.org>
Date: Tue, 22 Jul 2014 17:14:59 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Blocked tasks on 3.15.1
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com> <53C7CD0F.7070603@fb.com> <CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com> <1745216.hDa4tC2HJJ@merkaba> <53CE7ACF.7070109@fb.com>
In-Reply-To: <53CE7ACF.7070109@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/22/2014 04:53 PM, Chris Mason wrote:
>
> On 07/19/2014 02:23 PM, Martin Steigerwald wrote:
>
>>> Running 3.15.6 with this patch applied on top:
>>>   - still causes a hang with `rsync -hPaHAXx --del /mnt/home/nyx/ /home/nyx/`
>>> - no extra error messages printed (`dmesg | grep racing`) compared to
>>> without the patch
>> I got same results with 3.16-rc5 + this patch (see thread BTRFS hang with
>> 3.16-rc5). 3.16-rc4 still is fine with me. No hang whatsoever so far.
>>
>>> To recap some details (so I can have it all in one place):
>>>   - /home/ is btrfs with compress=lzo
>> BTRFS RAID 1 with lzo.
>>
>>>   - I have _not_ created any nodatacow files.
>> Me neither.
>>
>>>   - Full stack is: sata <-> dmcrypt <-> lvm <-> btrfs (I noticed others
>>> mentioning the use of dmcrypt)
>> Same, except no dmcrypt.
>>
> Thanks for the help in tracking this down everyone.  We'll get there!
> Are you all running multi-disk systems (from a btrfs POV, more than one
> device?)  I don't care how many physical drives this maps to, just does
> btrfs think there's more than one drive.
>
> -chris
Hi,

In case it's interesting:
 From an earlier email thread with subject: 3.15-rc6 - 
btrfs-transacti:4157 blocked for more than 120

TLDR: yes, btrfs sees multiple devices.

sata <-> dmcrypt <-> btrfs raid10
btrfs raid10 consist of multiple dmcrypt devices from multiple sata devices.

Mount: /dev/mapper/sdu on /mnt/storage type btrfs 
(rw,noatime,space_cache,compress=lzo,inode_cache,subvol=storage)
(yes I know inode_cache is not recommended for general use)

I have a nocow directory in a separate subvolume containing vm-images 
used by kvm.
The same kvm-vms are reading/writing data from that array over nfs.

I'm still holding that system on 3.14. Anything above causes blocks.

--
Torbjørn
