Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:48929 "EHLO
	mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbcCIDWI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Mar 2016 22:22:08 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B5F6EAC00A0
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Mar 2016 12:21:59 +0900 (JST)
Subject: Re: [PATCH v2] Btrfs: Show a warning message if one of objectid
 reaches its highest value
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
References: <56DCF015.9060703@jp.fujitsu.com> <56DF26F4.2010508@inwind.it>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56DF96CF.9020700@jp.fujitsu.com>
Date: Wed, 9 Mar 2016 12:21:51 +0900
MIME-Version: 1.0
In-Reply-To: <56DF26F4.2010508@inwind.it>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/03/09 4:24, Goffredo Baroncelli wrote:
> On 2016-03-07 04:05, Satoru Takeuchi wrote:
>> - It's better to show a warning message for the exceptional case
>>     that one of objectid (in most case, inode number) reaches its
>>     highest value. Show this message only once to avoid filling
>>     dmesg with it.
>> - EOVERFLOW is more proper return value for this case.
>>     ENOSPC is for "No space left on device" case and objectid isn't
>>     related to any device.
>>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>> ---
>> This patch can be applied to 4.5-rc7
>> ---
>>    fs/btrfs/inode-map.c | 10 +++++++++-
>>    1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
>> index e50316c..f5e3228 100644
>> --- a/fs/btrfs/inode-map.c
>> +++ b/fs/btrfs/inode-map.c
>> @@ -556,7 +556,15 @@ int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid)
>>    	mutex_lock(&root->objectid_mutex);
>>
>>    	if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
>> -		ret = -ENOSPC;
>> +		static bool __warned = false;
> 
> 
> Please, don't use a static GLOBAL variable. I suggest to move to a "per filesystem" variables for two main reasons:
> 
> 1) if in the (very unlikely) case where two different filesystems reach BTRFS_LAST_FREE_OBJECTID, the first error will hide the second one.
> 
> 2) if you umount and remount the filesystem the error is not shown anymore. A module unload/load or a reboot is required.
> If something strange happens, one of the first thing that the user does, is to umount/remount the filesystem. But the error is not show anymore. This could complicate the diagnosis of the problem.

OK, I see.

I rethink what should this patch be since it's
overkill to prepare per-filesystem variable just
for this warning message.

I'll resend patch which shows this message
every time when hitting this condition instead of
does it just once.

Thanks,
Satoru

> 
> 
> 
> 
>> +
>> +		if (unlikely(!__warned)) {
>> +			btrfs_warn(root->fs_info,
>> +				   "The objectid of root %llu reaches its highest value.\n",
>> +				   root->root_key.objectid);
>> +			__warned = true;
>> +		}
>> +		ret = -EOVERFLOW;
>>    		goto out;
>>    	}
>>
> 
> 
