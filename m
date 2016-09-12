Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19605 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753421AbcILHGf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 03:06:35 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: check: remove unused found_key variable
 in walk_down_tree()
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20160825052101.25864-1-wangxg.fnst@cn.fujitsu.com>
 <20160829162217.GW16983@twin.jikos.cz>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57D652DB.6060507@cn.fujitsu.com>
Date: Mon, 12 Sep 2016 15:01:47 +0800
MIME-Version: 1.0
In-Reply-To: <20160829162217.GW16983@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 08/30/2016 12:22 AM, David Sterba wrote:
> On Thu, Aug 25, 2016 at 01:20:59PM +0800, Wang Xiaoguang wrote:
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>   cmds-check.c | 5 -----
>>   1 file changed, 5 deletions(-)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index 0ddfd24..1cd0421 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -3737,7 +3737,6 @@ static int check_fs_root(struct btrfs_root *root,
>>   		path.slots[level] = 0;
>>   	} else {
>>   		struct btrfs_key key;
>> -		struct btrfs_disk_key found_key;
>>   
>>   		btrfs_disk_key_to_cpu(&key, &root_item->drop_progress);
>>   		level = root_item->drop_level;
>> @@ -3745,10 +3744,6 @@ static int check_fs_root(struct btrfs_root *root,
>>   		wret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
>>   		if (wret < 0)
>>   			goto skip_walking;
>> -		btrfs_node_key(path.nodes[level], &found_key,
>> -				path.slots[level]);
>> -		WARN_ON(memcmp(&found_key, &root_item->drop_progress,
>> -					sizeof(found_key)));
> It's not unused, the WARN_ON is an if in disguise, ane memcmp does the
> check, am I missing something here?
No, you're right.
I mistakenly took the memcmp() as memcpy(), sorry.

Regards,
Xiaoguang Wang
>



