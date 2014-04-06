Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47474 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaDFFAC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Apr 2014 01:00:02 -0400
Message-ID: <5340DF3E.2070601@oracle.com>
Date: Sun, 06 Apr 2014 12:59:42 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: zab@redhat.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] btrfs: btrfs_rm_device() should zero mirror SB
 as well
References: <1396275237-8306-1-git-send-email-Anand.Jain@oracle.com> <20140404123925.GS29256@twin.jikos.cz>
In-Reply-To: <20140404123925.GS29256@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2014 20:39, David Sterba wrote:
> On Mon, Mar 31, 2014 at 10:13:56PM +0800, Anand Jain wrote:
>> From: Anand Jain <anand.jain@oracle.com>
>>
>> This fix will ensure all SB copies on the disk is zeroed
>> when the disk is intentionally removed. This helps to
>> better manage disks in the user land.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>
>> btrfs: don't double brelse on device rm
>>
>> Device removal currently causes bdev removal to try to double free a bh
>> in the bdev:
>>
>> [   55.714833] WARNING: at fs/buffer.c:1160 __brelse+0x36/0x40()
>> [   55.714833] VFS: brelse: Trying to free free buffer
>>
>> Commit 7e3d9ebb1 added a double release of the bh for a device being
>> removed when all the supers don't fit in the device.  In that case it
>> releases the bh assuming that it's going to read a new one, finds that
>> it won't read, and goes to a label that releases the bh again.
>>
>> All it needed to do was only brelse() right before overwriting the
>> current bh with __bread().
>>
>> Signed-off-by: Zach Brown <zab@redhat.com>
>
> This is a bit confusing, two changelogs, one patch, the referenced
> commit id does not in fact exist. To keep all due credits, 2 patches
> would make sense but ... up to you.

  Sorry to know it was confusing. I have sent out V3 hope that's better.

-Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
