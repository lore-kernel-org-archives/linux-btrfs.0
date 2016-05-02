Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36586 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbcEBEMg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 00:12:36 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 0/2] [RFC] btrfs: create degraded-RAID1 chunks
To: dsterba@suse.cz
References: <1461812780-538-1-git-send-email-anand.jain@oracle.com>
 <20160429163727.GD29353@suse.cz>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Message-ID: <5726D3AF.5010103@oracle.com>
Date: Mon, 2 May 2016 12:12:31 +0800
MIME-Version: 1.0
In-Reply-To: <20160429163727.GD29353@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/30/2016 12:37 AM, David Sterba wrote:
> On Thu, Apr 28, 2016 at 11:06:18AM +0800, Anand Jain wrote:
>>  From the comments that commit[1] deleted
>>
>> - /*
>> - * we add in the count of missing devices because we want
>> - * to make sure that any RAID levels on a degraded FS
>> - * continue to be honored.
>> - *
>>
>> appear to me that automatic reduced-chunk-allocation
>> when RAID1 is degraded wasn't in the original design.
>>
>> which also introduced unpleasant things like automatically
>> allocating single chunks when RAID1 is mounted in degraded
>> mode, which will hinder further RAID1 mount in degraded
>> mode.
>
> Agreed. As the automatic conversion cannot be turned off, it causes some
> surprises. We've opposed against such things in the past, so I'm for
> not doing the 'single' allocations. Independly, I got a feedback from a
> user who liked the proposed change..

yes.


>> And now to fix the original issue that is - chunk allocation
>> fails when RAID1 is degraded, The reason for the problem
>> seems to be that we had the devs_min attribute for RAID1
>> set wrongly. Correcting this also means that its time to
>> fix the RAID1 fixmes in the functions __btrfs_alloc_chunk()
>> patch [2] does that, and is for review.
>
> This means we'd allow full writes to a degraded raid1 filesystem. This
> can bring surprises as well. The question is what to do if the device
> pops out, some writes happen, and then is added.

> One option is to set some bit in the degraded filesystem that degraded
> writes happened.

> After that, mounting the whole filesystem would
> recommend running scrub before dropping the bit.

Right some flag should tell to fix the degraded chunks. Any
suggestion on naming? (as of now calling it degraded-chunk-write-flag).

Also as of now I think its ok to fail the mount when its found
that both of the RAID1 devices has degraded-chunk-write-flag set
(a split brain situation) so that user can mount one of the device
and freshly btrfs-device-add the other.


> Forcing a read-only
> mount here would be similar to read-only degraded mount, so I guess we'd
> have to somehow deal with the missing writes.

> I haven't thought about all details, the raid1 auto-repair can handle
> corrupted data, I think missing metadata should be handled as well and
> repaired.


I found raid5 scrub nicely handles the missing writes. However
RAID1 (and guess raid10 as well) needs balance. (I would like to
keep it as it is as of now). IMO RAID1 should do what RAID5 is doing.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
