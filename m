Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30132 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbbI2WLQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 18:11:16 -0400
Message-ID: <560B0C6D.4050100@oracle.com>
Date: Wed, 30 Sep 2015 06:10:53 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/23] btrfs device related patch set
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com> <20150929143406.GD11442@twin.jikos.cz>
In-Reply-To: <20150929143406.GD11442@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/29/2015 10:34 PM, David Sterba wrote:
> On Fri, Aug 14, 2015 at 06:32:45PM +0800, Anand Jain wrote:
>> Anand Jain (22):
>>    Btrfs: rename btrfs_sysfs_add_one to btrfs_sysfs_add_mounted
>>    Btrfs: rename btrfs_sysfs_remove_one to btrfs_sysfs_remove_mounted
>>    Btrfs: rename btrfs_kobj_add_device to btrfs_sysfs_add_device_link
>>    Btrfs: rename btrfs_kobj_rm_device to btrfs_sysfs_rm_device_link
>>    Btrfs: rename super_kobj to fsid_kobj
>>    Btrfs: SB read failure should return EIO for __bread failure
>>    Btrfs: __btrfs_std_error() logic should be consistent w/out
>>      CONFIG_PRINTK defined
>
> FYI, I'm picking the above for 4.4 as they're quite straightforward,
 > the other patches touch interfaces and I have some comments.

Thanks David.
Except for
   [PATCH 08/23] Btrfs: device delete by devid
   [PATCH 23/23] Btrfs: allow -o rw,degraded for single group profile

rest are straightforward as well. If there is any comment will take it.
In fact 08/23 and 23/23 are stable at me end. however for 23/23 I am 
testing Qu approach to count missing per Chunk. So far I couldn't break 
both 23/23 or the Qu approach the patch below..
   [PATCH 0/5] Btrfs: Per-chunk degradable check

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
