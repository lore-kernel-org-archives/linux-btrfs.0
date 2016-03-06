Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:50665 "EHLO
	mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbcCFXIg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Mar 2016 18:08:36 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 885E5AC0128
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Mar 2016 08:08:28 +0900 (JST)
Subject: Re: [PATCH] Show a warning message if one of highest objectid reaches
 its max value
To: fdmanana@gmail.com
References: <56D8F4CF.20604@jp.fujitsu.com>
 <CAL3q7H6UvnB1K3ys3YLK0YCBwuSRMhv+Y8artx7HJ7VawHqZGg@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56DCB861.6080301@jp.fujitsu.com>
Date: Mon, 7 Mar 2016 08:08:17 +0900
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6UvnB1K3ys3YLK0YCBwuSRMhv+Y8artx7HJ7VawHqZGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

On 2016/03/04 18:28, Filipe Manana wrote:
> On Fri, Mar 4, 2016 at 2:37 AM, Satoru Takeuchi
> <takeuchi_satoru@jp.fujitsu.com> wrote:
>> - It's better to show a warning message for the exceptional case
>>    that one of highest objectid (in most case, inode number)
>>    reaches its max value, BTRFS_LAST_FREE_OBJECTID. Show this
>>    message only once to avoid filling dmesg with it.
>> - EOVERFLOW is more proper return value for this case.
>>    ENOSPC is for "No space left on device" case and objectid isn't
>>    related to any device.
>>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>> ---
>> This patch can be applied to v4.5-rc6
>> ---
>>   fs/btrfs/inode-map.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
>> index e50316c..a4860fd 100644
>> --- a/fs/btrfs/inode-map.c
>> +++ b/fs/btrfs/inode-map.c
>> @@ -555,8 +555,10 @@ int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid)
>>          int ret;
>>          mutex_lock(&root->objectid_mutex);
>>
>> -       if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
>> -               ret = -ENOSPC;
>> +       if (WARN_ONCE(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID,
>> +                     "BTRFS: The highest objectid reaches its max value %llu.\n",
>> +                     BTRFS_LAST_FREE_OBJECTID)) {
>
> Please, use btrfs_warn() to print messages... It avoids hardcoding
> prefixes and having to copy the style of the
> btrfs_[info|warn|error|...) functions.
> Also include the id of the tree (root->root_key.objectid), it's much
> more useful than printing root->highes_objectid....
>
> Also add the prefix "Btrfs: " to the subject.

Thank you for your comment. I'll fix it.
>
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
>
>
>
