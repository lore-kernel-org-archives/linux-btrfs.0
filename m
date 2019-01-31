Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2D7C169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 15:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F21EE218AF
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 15:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732584AbfAaPfM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 10:35:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:49556 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726060AbfAaPfM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 10:35:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1EAF9AD5D
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 15:35:11 +0000 (UTC)
Subject: Re: [PATCH 01/15] btrfs: Honour FITRIM range constraints during free
 space trim
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org, jeffm@suse.com
References: <20190130145102.4708-1-nborisov@suse.com>
 <20190130145102.4708-2-nborisov@suse.com>
 <20190131152135.GG2900@twin.jikos.cz>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <ef5b4561-8337-a28a-4419-98e8f1e20e73@suse.com>
Date:   Thu, 31 Jan 2019 17:35:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190131152135.GG2900@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 31.01.19 г. 17:21 ч., David Sterba wrote:
> On Wed, Jan 30, 2019 at 04:50:48PM +0200, Nikolay Borisov wrote:
>> Up until know trimming the freespace was done irrespective of what the
>> arguments of the FITRIM ioctl were. For example fstrim's -o/-l arguments
>> will be entirely ignored. Fix it by correctly handling those paramter.
>> This requires breaking if the found freespace extent is after the end
>> of the passed range as well as completing trim after trimming
>> fstrim_range::len bytes.
> 
> How does this work with with multipe-device filesystems? The fstrim
> range would apply to all of them. Which does make some sense, though
> might be unexpected as this does not happen for other filesystems.

Well FITRIM doesn't have support for multiple device so it's to the
discretion of the fs how exactly this is implemented. And this is indeed
the way things work currently.

> 
> The FITRIM range is in the physical coordinates, so eg. the taking the
> maximum size of all devices and iterating over that by 1GiB steps would
> go though the whole filesystem. Something to put to the changelog and
> documentation.

I don't follow, trimming would just trim the physical range as passed by
fstrim -o/-l options. That 1gb value is not hardcoded anywhere. If
someone wants to trim all of the freespace (which is what the majority
of the user do) then they can run FITRIM with 0 for offset and -1 for
length.

> 
>> Fixes: 499f377f49f0 ("btrfs: iterate over unused chunk space in FITRIM")
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c | 25 +++++++++++++++++++------
>>  1 file changed, 19 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 1fdba38761f7..fc3f6acc3c9b 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -11190,9 +11190,9 @@ int btrfs_error_unpin_extent_range(struct btrfs_fs_info *fs_info,
>>   * held back allocations.
>>   */
>>  static int btrfs_trim_free_extents(struct btrfs_device *device,
>> -				   u64 minlen, u64 *trimmed)
>> +				   struct fstrim_range *range, u64 *trimmed)
>>  {
>> -	u64 start = 0, len = 0;
>> +	u64 start = range->start, len = 0;
>>  	int ret;
>>  
>>  	*trimmed = 0;
>> @@ -11235,8 +11235,8 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
>>  		if (!trans)
>>  			up_read(&fs_info->commit_root_sem);
>>  
>> -		ret = find_free_dev_extent_start(trans, device, minlen, start,
>> -						 &start, &len);
>> +		ret = find_free_dev_extent_start(trans, device, range->minlen,
>> +						 start, &start, &len);
>>  		if (trans) {
>>  			up_read(&fs_info->commit_root_sem);
>>  			btrfs_put_transaction(trans);
>> @@ -11249,6 +11249,16 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
>>  			break;
>>  		}
>>  
>> +		/* If we are out of the passed range break */
>> +		if (start > range->start + range->len - 1) {
>> +			mutex_unlock(&fs_info->chunk_mutex);
>> +			ret = 0;
>> +			break;
>> +		}
>> +
>> +		start = max(range->start, start);
>> +		len = min(range->len, len);
>> +
>>  		ret = btrfs_issue_discard(device->bdev, start, len, &bytes);
>>  		mutex_unlock(&fs_info->chunk_mutex);
>>  
>> @@ -11258,6 +11268,10 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
>>  		start += len;
>>  		*trimmed += bytes;
>>  
>> +		/* We've trimmed enough */
>> +		if (*trimmed >= range->len)
>> +			break;
>> +
>>  		if (fatal_signal_pending(current)) {
>>  			ret = -ERESTARTSYS;
>>  			break;
>> @@ -11341,8 +11355,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
>>  	mutex_lock(&fs_info->fs_devices->device_list_mutex);
>>  	devices = &fs_info->fs_devices->devices;
>>  	list_for_each_entry(device, devices, dev_list) {
>> -		ret = btrfs_trim_free_extents(device, range->minlen,
>> -					      &group_trimmed);
>> +		ret = btrfs_trim_free_extents(device, range, &group_trimmed);
>>  		if (ret) {
>>  			dev_failed++;
>>  			dev_ret = ret;
>> -- 
>> 2.17.1
