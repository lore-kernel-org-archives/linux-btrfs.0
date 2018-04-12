Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48596 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbeDLGlx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Apr 2018 02:41:53 -0400
Subject: Re: [PATCH v4 0/7] Superblock read and verify cleanups
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180330000924.11148-1-anand.jain@oracle.com>
 <20180410144836.GD2817@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c4bf0305-4b54-7e69-ecff-0ebd782d78d8@oracle.com>
Date: Thu, 12 Apr 2018 14:43:56 +0800
MIME-Version: 1.0
In-Reply-To: <20180410144836.GD2817@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/10/2018 10:48 PM, David Sterba wrote:
> On Fri, Mar 30, 2018 at 08:09:16AM +0800, Anand Jain wrote:
>> v3->v4:
>>   Update changelog and signoff.
>>   Reintroduce explicit check for '-EUCLEAN'
>>    at Patch 2/8 and 5/8.
>>
>> v2->v3:
>>   Squash
>>    4/8 btrfs: make btrfs_check_super_csum() non static
>>   to
>>    6/8 btrfs: verify superblock checksum during scan
>>   As in the individual patch mentioned
>>   
>> v1->v2:
>>   Various changes suggested by Nicokay. Thanks. For specific changes
>>   pls ref to the patch.
>>
>> Patch 1-4/8 are preparatory patches adds cleanups and nonstatic requisites.
>>
>> Patch 5/8 makes sure that all copies of the superblock have the same fsid
>> when we scan the device.
> 
> This is IMO too strict and the need of workaround puts the burden on the
> user while it's not necessary and scan or mount can continue as long as
> the first superblock is valid.

  IMO there is indirect loss for not being too strict here. Offline
  disk-corruptions will be reported as btrfs corruption at a later stage,
  by that time we would have overwritten the superblocks on all the
  disks. Its just about doing the right thing and IMO is pays well to
  itself in the long term. I am ok to drop this if any disagreements.

>> Patch 6/8 verifies superblock csum when we read it in the scan context.
> 
> This was the main intention, as I read the discussion in the thread
> under the RFC patch.
>
> The semantics of scanning is not exactly defined, in the current code
> it's "pick any device that has the right magic and sb offset", so adding
> the csum check would add some validation but otherwise it's fine. All
> the work is left to mount and all reported errors can be examined
> immediatelly.
> 
> Wiping the magic either manually or by wipefs will not touch the csum,
> so we don't change the behaviour.

  Will fix progs patch. Just noticed that wipefs wipes the magic only,
  I could do that in the progs patch here.

> Reporting errors on each scan is a usability no-go.

  Ok.

> Patches 1-4 look ok,
> I'll have to think more about 5.

  Sure.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
