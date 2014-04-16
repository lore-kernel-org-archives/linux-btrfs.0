Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42364 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750982AbaDPCJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 22:09:00 -0400
Message-ID: <534DE66E.8060203@cn.fujitsu.com>
Date: Wed, 16 Apr 2014 10:09:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Force 'btrfs dev scan' not using old libblkid
 cache
References: <1397115021-30426-1-git-send-email-quwenruo@cn.fujitsu.com> <20140414162919.GO29256@twin.jikos.cz> <534DDBDF.4050408@cn.fujitsu.com>
In-Reply-To: <534DDBDF.4050408@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs-progs: Force 'btrfs dev scan' not using old 
libblkid cache
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Date: 2014年04月16日 09:24
>
> -------- Original Message --------
> Subject: Re: [PATCH] btrfs-progs: Force 'btrfs dev scan' not using old 
> libblkid cache
> From: David Sterba <dsterba@suse.cz>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2014年04月15日 00:29
>> On Thu, Apr 10, 2014 at 03:30:21PM +0800, Qu Wenruo wrote:
>>> 'btrfs scan' uses libblkid to scan devices by default, and libblkid 
>>> uses
>>> cache to reduce the probe.
>>>
>>> But if operations below is done in less than 2 
>>> seconds(BLKID_PROBE_MIN),
>>> 'btrfs scan' will still use the uncorrect cache and scan on the 
>>> deleted device.
>>> 0. /dev/sda[1-4] mounted on /mnt using single data/metadata
>>> 1. btrfs dev scan
>>> 2. btrfs dev del /dev/sda3 /mnt
>>> 3. btrfs dev scan
>>>
>>> Since the cache made by step 1 is still validated, step 3 will use the
>>> cache and consider /dev/sda3 as a btrfs filesystem and try to scan it.
>>> But the superblock(at least the first one) is wiped and failed to scan,
>>> a error message, which can be avoided and is unneeded, is output.
>>>
>>> This patch will force scan_for_btrfs() not to use cache to avoid the
>>> problem.
>>> --- a/utils.c
>>> +++ b/utils.c
>>> @@ -2057,7 +2057,8 @@ int btrfs_scan_lblkid(int update_kernel)
>>>       blkid_cache cache = NULL;
>>>       char path[PATH_MAX];
>>>   -    if (blkid_get_cache(&cache, 0) < 0) {
>>> +    /* No to use libblkid cache to avoid old data */
>>> +    if (blkid_get_cache(&cache, "/dev/null") < 0) {
>> This effectively avoid the blkid cache for all devices but the point of
>> blkid was to use it so repeated probes are not done.
>>
>> I think it's not right to skip the whole cache because one entry may be
>> stale, more that we know which one and when.
>>
>> We should rather explicitly invalidate the removed device after delete,
>> I don't what's the right way to do that. Maybe blkid_do_probe() or
>> blkid_gc_cache()
> Please ignore this patch, since after consulting with libblkid mail 
> list, the real problem is that btrfs ioctl for remove device
> does not update the mtime/ctime for the device.
I'm sorry that kernel updates the mtime/ctime, but it seems there is 
some small latency, which caused libblkd fail to detect the
modification and use old cache.

Will go on investigation.
Thanks,
Qu
>
> Libblkid will only use cache when the device's mtime/ctime stay 
> unchanged, if mtime/ctime changed libblkid will do the lowprobe.
>
> I'll try to fix it in kernel space.
>
> Thanks,
> Qu
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

