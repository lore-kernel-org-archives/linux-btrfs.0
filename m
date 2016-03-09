Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:51568 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbcCIF2a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 00:28:30 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 1936DAC0246
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Mar 2016 14:28:24 +0900 (JST)
Subject: Re: [PATCH v2] Btrfs: Show a warning message if one of objectid
 reaches its highest value
To: Naohiro Aota <naota@elisp.net>
References: <56DCF015.9060703@jp.fujitsu.com>
 <CAEe67=_Me0s=VFTY5VuR2tRVPVFy+SnoXy+=mxvwQbFy31LJAw@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56DFB471.5060307@jp.fujitsu.com>
Date: Wed, 9 Mar 2016 14:28:17 +0900
MIME-Version: 1.0
In-Reply-To: <CAEe67=_Me0s=VFTY5VuR2tRVPVFy+SnoXy+=mxvwQbFy31LJAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/03/09 11:32, Naohiro Aota wrote:
> 2016-03-07 12:05 GMT+09:00 Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>:
>> - It's better to show a warning message for the exceptional case
>>    that one of objectid (in most case, inode number) reaches its
>>    highest value. Show this message only once to avoid filling
>>    dmesg with it.
>> - EOVERFLOW is more proper return value for this case.
>>    ENOSPC is for "No space left on device" case and objectid isn't
>>    related to any device.
>
> I have concern about EOVERFLOW. The value returned here will
> go through to the user space via btrfs_find_free_ino() and btrfs_create().
> It means that "creat" and "mkdir" can now return EOVERFLOW when it
> failed to assign new inode number. Such behavior would disagree with
> other file systems, which result in user space programs to be
> confused.
>
> Also, I don't think EOVERFLOW described in "creat(2)" (or open(2))
> suits for this case. As far as I read the following man page from
> creat(2),
> giving ENOSPC is better option here.

I consider, as I read man, ENOSPC is also doesn't explain
this case. It's not related to pathname.

man 2 creat:
========================================
ENOSPC pathname was to be created but the device
containing pathname has no room for the new file.
========================================

However, I agree with the ENOSPC is better than EOVERFLOW
because existing code has worked with the former value
in such case.

Next patch will keep the error code as is.

Thank you for your comment, Naota.

Satoru

>
>> ENOSPC: pathname was to be created but the device containing pathname has  no  room  for  the  new file.
>> EOVERFLOW:
>>               pathname refers to a regular file that is too large to be opened.
>> (snip)
>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>> ---
>> This patch can be applied to 4.5-rc7
>> ---
>>   fs/btrfs/inode-map.c | 10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
>> index e50316c..f5e3228 100644
>> --- a/fs/btrfs/inode-map.c
>> +++ b/fs/btrfs/inode-map.c
>> @@ -556,7 +556,15 @@ int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid)
>>          mutex_lock(&root->objectid_mutex);
>>
>>          if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
>> -               ret = -ENOSPC;
>> +               static bool __warned = false;
>> +
>> +               if (unlikely(!__warned)) {
>> +                       btrfs_warn(root->fs_info,
>> +                                  "The objectid of root %llu reaches its highest value.\n",
>> +                                  root->root_key.objectid);
>> +                       __warned = true;
>> +               }
>> +               ret = -EOVERFLOW;
>>                  goto out;
>>          }
>>
>> --
>> 2.5.0
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
