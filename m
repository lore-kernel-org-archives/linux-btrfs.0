Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:10939 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754592Ab3HVW6H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 18:58:07 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es>
Date: Thu, 22 Aug 2013 16:58:00 -0600
Message-Id: <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com>
References: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es> <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com> <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es> <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Nicholas Lee <email@nickle.es>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Non-expert on btrfs errors, so hopefully someone else will still reply with recovery advice. I have some foundational questions on the setup that may relate, if you don't already know what precipitated this failure:


1.
You said it's md raid5, but I see /dev/mapper/main--storage--vg-root and dm-1 or dm-2, so I wonder if this is md raid with LVM on top; or if this is LVM raid5 (which directly implements raid5 at LV level, without mdadm, but does use md code underneath)?

2.
In one dmesg I see /dev/dm-2 referenced with errors, and in another /dev/dm-1. Is it actually the same btrfs volume, and if so I wonder why it's sometimes being mapped to a difference dm device?

3.
If it's an md device, when was the last time a scrub check was run?
echo check > /sys/block/mdX/md/sync_action
then after that completes:
cat /sys/block/mdX/mismatch_cnt

Or if LVM raid5, I think this is only recently added:
http://www.redhat.com/archives/lvm-devel/2013-April/msg00042.html

4.
smartctl -x for each drive; are there any indications of reallocated sectors, pending sectors, bad block, ECC error, CRC or UDMA error? Also included in the above command should return the SCT Error Recovery Control value for each drive, what's that value?

5.
What is returned for any one of the drives:

cat /sys/block/sdX/device/timeout

Thanks,

Chris Murphy


On Aug 22, 2013, at 1:38 PM, Nicholas Lee <email@nickle.es> wrote:

> Full pastebin here: http://cwillu.com:8080/96.245.194.45#6
> 
> [   9.213212] Btrfs loaded
> [    9.245673] device fsid 2ffb2450-f74f-4cfb-a3be-bb5e3c6d32ec devid 1 transid 23568 /dev/dm-1
> [  102.886834] device fsid 2ffb2450-f74f-4cfb-a3be-bb5e3c6d32ec devid 1 transid 23568 /dev/mapper/main--storage--vg-root
> [  102.888348] btrfs: enabling auto recovery
> [  102.888354] btrfs: disabling disk space caching
> [  102.888357] btrfs: disabling disk space caching
> [  102.911068] BTRFS critical (device dm-1): unable to find logical 1781900460032 len 4096
> [  102.911103] BTRFS emergency (device dm-1): No mapping for 1781900460032-1781900464128
> 
> [  102.911108] btrfs: failed to read tree root on dm-1
> [  102.911186] BTRFS critical (device dm-1): unable to find logical 1781900460032 len 4096
> [  102.911217] BTRFS emergency (device dm-1): No mapping for 1781900460032-1781900464128
> 
> [  102.911222] btrfs: failed to read tree root on dm-1
> [  102.911235] BTRFS critical (device dm-1): unable to find logical 1198824710144 len 4096
> [  102.911240] BTRFS emergency (device dm-1): No mapping for 1198824710144-1198824714240
> 
> [  102.911243] btrfs: failed to read tree root on dm-1
> [  102.911255] BTRFS critical (device dm-1): unable to find logical 1198518919168 len 4096
> [  102.911286] BTRFS emergency (device dm-1): No mapping for 1198518919168-1198518923264
> 
> [  102.911290] btrfs: failed to read tree root on dm-1
> [  102.911302] BTRFS critical (device dm-1): unable to find logical 582755782656 len 4096
> [  102.911308] BTRFS emergency (device dm-1): No mapping for 582755782656-582755786752
> 
> [  102.911311] btrfs: failed to read tree root on dm-1
> [  102.986797] btrfs: open_ctree failed
> 
> 
> On 22.08.2013, at 15:23, Nicholas Lee <email@nickle.es> wrote:
> 
>> After updating the kernel and using btrfs-progs-git from the AUR, I'm now getting this output. Does this yield any new insight?
>> 
>> [  473.305408] btrfs: failed to read tree root on dm-2
>> [  473.305555] BTRFS critical (device dm-2): unable to find logical 1781900460032 len 4096
>> [  473.305591] BTRFS emergency (device dm-2): No mapping for 1781900460032-1781900464128
>> 
>> 
>> On 22.08.2013, at 10:09, Mitch Harder <mitch.harder@sabayonlinux.org> wrote:
>> 
>>> On Thu, Aug 22, 2013 at 1:47 AM, Nicholas Lee <email@nickle.es> wrote:
>>> 
>>>> [   45.914275] ------------[ cut here ]------------
>>>> [   45.914406] kernel BUG at fs/btrfs/volumes.c:4417!
>>>> [   45.914489] invalid opcode: 0000 [#1] PREEMPT SMP
>>> 
>>> I can't say if this will fix your problem or not, but the 3.10.x
>>> kernel has a patch to pass this error back instead of halting with a
>>> BUG() at this point.
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Chris Murphy

