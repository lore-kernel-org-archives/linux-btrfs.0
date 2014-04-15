Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65463 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751335AbaDOBQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 21:16:18 -0400
Message-ID: <534C888D.1080509@cn.fujitsu.com>
Date: Tue, 15 Apr 2014 09:17:01 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Force 'btrfs dev scan' not using old libblkid
 cache
References: <1397115021-30426-1-git-send-email-quwenruo@cn.fujitsu.com> <20140414162919.GO29256@twin.jikos.cz>
In-Reply-To: <20140414162919.GO29256@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs-progs: Force 'btrfs dev scan' not using old 
libblkid cache
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年04月15日 00:29
> On Thu, Apr 10, 2014 at 03:30:21PM +0800, Qu Wenruo wrote:
>> 'btrfs scan' uses libblkid to scan devices by default, and libblkid uses
>> cache to reduce the probe.
>>
>> But if operations below is done in less than 2 seconds(BLKID_PROBE_MIN),
>> 'btrfs scan' will still use the uncorrect cache and scan on the deleted device.
>> 0. /dev/sda[1-4] mounted on /mnt using single data/metadata
>> 1. btrfs dev scan
>> 2. btrfs dev del /dev/sda3 /mnt
>> 3. btrfs dev scan
>>
>> Since the cache made by step 1 is still validated, step 3 will use the
>> cache and consider /dev/sda3 as a btrfs filesystem and try to scan it.
>> But the superblock(at least the first one) is wiped and failed to scan,
>> a error message, which can be avoided and is unneeded, is output.
>>
>> This patch will force scan_for_btrfs() not to use cache to avoid the
>> problem.
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -2057,7 +2057,8 @@ int btrfs_scan_lblkid(int update_kernel)
>>   	blkid_cache cache = NULL;
>>   	char path[PATH_MAX];
>>   
>> -	if (blkid_get_cache(&cache, 0) < 0) {
>> +	/* No to use libblkid cache to avoid old data */
>> +	if (blkid_get_cache(&cache, "/dev/null") < 0) {
> This effectively avoid the blkid cache for all devices but the point of
> blkid was to use it so repeated probes are not done.
>
> I think it's not right to skip the whole cache because one entry may be
> stale, more that we know which one and when.
I totally agree with that.
>
> We should rather explicitly invalidate the removed device after delete,
> I don't what's the right way to do that. Maybe blkid_do_probe() or
> blkid_gc_cache()
But the problem is, libblkid does not provide such API to invalidate one 
entry of cache.
blkid_gc_cache() will only remove non-exsist device cache, and 
blkid_do_probe() seems not using/update the cache,
so I used "/dev/null" as cache to avoid the cache completly.

I'll try to dig the libblkid codes deeper to find a method to invalidate 
an entry.

Thanks,
Qu.
