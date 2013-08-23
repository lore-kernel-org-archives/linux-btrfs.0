Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f47.google.com ([209.85.128.47]:38360 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab3HWA7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 20:59:38 -0400
Received: by mail-qe0-f47.google.com with SMTP id b4so1286qen.20
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 17:59:37 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Nicholas Lee <email@nickle.es>
In-Reply-To: <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com>
Date: Thu, 22 Aug 2013 20:59:30 -0400
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <5F161E82-F226-43FB-860F-53AF859E4EFA@nickle.es>
References: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es> <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com> <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es> <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es> <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1. It's md-raid, with an lvm on top, and this is running in a virtual machine with lvm also enabled. 
2. Originally, I was working from the Arch LiveCD, but I later created another disk to install ArchBang to.
3. I'm waiting for the check to complete.
4. SMART comes up clean

smartctl -x /dev/sdg | grep SCT
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]
SCT Status Version:                  3
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
SCT Temperature History Version:     2
SCT Error Recovery Control:

5. It returns a value of 30.

I'm running chunk-recover, but I'm going to let it write anything. I figure it'll take a while for it to scan, given the large size of the drive. 


On 22.08.2013, at 18:58, Chris Murphy <lists@colorremedies.com> wrote:

> Non-expert on btrfs errors, so hopefully someone else will still reply with recovery advice. I have some foundational questions on the setup that may relate, if you don't already know what precipitated this failure:
> 
> 
> 1.
> You said it's md raid5, but I see /dev/mapper/main--storage--vg-root and dm-1 or dm-2, so I wonder if this is md raid with LVM on top; or if this is LVM raid5 (which directly implements raid5 at LV level, without mdadm, but does use md code underneath)?
> 
> 2.
> In one dmesg I see /dev/dm-2 referenced with errors, and in another /dev/dm-1. Is it actually the same btrfs volume, and if so I wonder why it's sometimes being mapped to a difference dm device?
> 
> 3.
> If it's an md device, when was the last time a scrub check was run?
> echo check > /sys/block/mdX/md/sync_action
> then after that completes:
> cat /sys/block/mdX/mismatch_cnt
> 
> Or if LVM raid5, I think this is only recently added:
> http://www.redhat.com/archives/lvm-devel/2013-April/msg00042.html
> 
> 4.
> smartctl -x for each drive; are there any indications of reallocated sectors, pending sectors, bad block, ECC error, CRC or UDMA error? Also included in the above command should return the SCT Error Recovery Control value for each drive, what's that value?
> 
> 5.
> What is returned for any one of the drives:
> 
> cat /sys/block/sdX/device/timeout
> 
> Thanks,
> 
> Chris Murphy
> 
> 
> On Aug 22, 2013, at 1:38 PM, Nicholas Lee <email@nickle.es> wrote:
> 
>> Full pastebin here: http://cwillu.com:8080/96.245.194.45#6
>> 
>> [   9.213212] Btrfs loaded
>> [    9.245673] device fsid 2ffb2450-f74f-4cfb-a3be-bb5e3c6d32ec devid 1 transid 23568 /dev/dm-1
>> [  102.886834] device fsid 2ffb2450-f74f-4cfb-a3be-bb5e3c6d32ec devid 1 transid 23568 /dev/mapper/main--storage--vg-root
>> [  102.888348] btrfs: enabling auto recovery
>> [  102.888354] btrfs: disabling disk space caching
>> [  102.888357] btrfs: disabling disk space caching
>> [  102.911068] BTRFS critical (device dm-1): unable to find logical 1781900460032 len 4096
>> [  102.911103] BTRFS emergency (device dm-1): No mapping for 1781900460032-1781900464128
>> 
>> [  102.911108] btrfs: failed to read tree root on dm-1
>> [  102.911186] BTRFS critical (device dm-1): unable to find logical 1781900460032 len 4096
>> [  102.911217] BTRFS emergency (device dm-1): No mapping for 1781900460032-1781900464128
>> 
>> [  102.911222] btrfs: failed to read tree root on dm-1
>> [  102.911235] BTRFS critical (device dm-1): unable to find logical 1198824710144 len 4096
>> [  102.911240] BTRFS emergency (device dm-1): No mapping for 1198824710144-1198824714240
>> 
>> [  102.911243] btrfs: failed to read tree root on dm-1
>> [  102.911255] BTRFS critical (device dm-1): unable to find logical 1198518919168 len 4096
>> [  102.911286] BTRFS emergency (device dm-1): No mapping for 1198518919168-1198518923264
>> 
>> [  102.911290] btrfs: failed to read tree root on dm-1
>> [  102.911302] BTRFS critical (device dm-1): unable to find logical 582755782656 len 4096
>> [  102.911308] BTRFS emergency (device dm-1): No mapping for 582755782656-582755786752
>> 
>> [  102.911311] btrfs: failed to read tree root on dm-1
>> [  102.986797] btrfs: open_ctree failed
>> 
>> 
>> On 22.08.2013, at 15:23, Nicholas Lee <email@nickle.es> wrote:
>> 
>>> After updating the kernel and using btrfs-progs-git from the AUR, I'm now getting this output. Does this yield any new insight?
>>> 
>>> [  473.305408] btrfs: failed to read tree root on dm-2
>>> [  473.305555] BTRFS critical (device dm-2): unable to find logical 1781900460032 len 4096
>>> [  473.305591] BTRFS emergency (device dm-2): No mapping for 1781900460032-1781900464128
>>> 
>>> 
>>> On 22.08.2013, at 10:09, Mitch Harder <mitch.harder@sabayonlinux.org> wrote:
>>> 
>>>> On Thu, Aug 22, 2013 at 1:47 AM, Nicholas Lee <email@nickle.es> wrote:
>>>> 
>>>>> [   45.914275] ------------[ cut here ]------------
>>>>> [   45.914406] kernel BUG at fs/btrfs/volumes.c:4417!
>>>>> [   45.914489] invalid opcode: 0000 [#1] PREEMPT SMP
>>>> 
>>>> I can't say if this will fix your problem or not, but the 3.10.x
>>>> kernel has a patch to pass this error back instead of halting with a
>>>> BUG() at this point.
>>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Chris Murphy
> 

