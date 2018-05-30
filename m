Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56178 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936083AbeE3HBI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 03:01:08 -0400
Subject: Re: [PATCH 2/2] btrfs-progs: ins: dump-tree: Print tree name for tree
 block backref
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1527655420.git.misono.tomohiro@jp.fujitsu.com>
 <f6cac4991b513c3c4b00781414d422b3f4c87f6e.1527655420.git.misono.tomohiro@jp.fujitsu.com>
 <ee3f5cfe-0b7c-d38e-e602-d5671d80713f@suse.com>
 <d56cfca8-c6f9-971c-315f-cdde23a71baf@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b0d357ec-3374-6b4a-4861-d681cdb48528@suse.com>
Date: Wed, 30 May 2018 10:01:06 +0300
MIME-Version: 1.0
In-Reply-To: <d56cfca8-c6f9-971c-315f-cdde23a71baf@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.05.2018 09:55, Misono Tomohiro wrote:
> On 2018/05/30 15:28, Nikolay Borisov wrote:
>>
>>
>> On 30.05.2018 07:55, Misono Tomohiro wrote:
>>> Print tree name instead of number to make output more readable.
>>>
>>> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>>> ---
>>>  print-tree.c | 5 +++--
>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/print-tree.c b/print-tree.c
>>> index 90173c2b..8d551d09 100644
>>> --- a/print-tree.c
>>> +++ b/print-tree.c
>>> @@ -470,8 +470,9 @@ void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
>>>  		offset = btrfs_extent_inline_ref_offset(eb, iref);
>>>  		switch (type) {
>>>  		case BTRFS_TREE_BLOCK_REF_KEY:
>>> -			printf("\t\ttree block backref root %llu\n",
>>> -			       (unsigned long long)offset);
>>> +			printf("\t\ttree block backref root ");
>>> +			print_objectid(stdout, offset, 0);
>>> +			printf("\n");
>>
>> So this is a good change, yet one thing I'd like to know is if I'm
>> inspecting the extent tree with say "btrfs inspect-internal dump-tree -t
>> 2" and I see a record :
>>
>>         item 14 key (14540800 EXTENT_ITEM 4096) itemoff 15488 itemsize 53
>>                 refs 1 gen 12 flags DATA
>>                 extent data backref root 5 objectid 479 offset 0 count 1
>>
>> it will in fact be "root FS_TREE" or some such.
> 
> I overlooked it. So I will update the patch.
> 
> So the question is will
>> I bee able to use the printed string as an argument to -t ? Because on
>> one hand I as a user would like to make sense of the output I'm seeing
>> (hence the string is welcomed) at the same time I'd like to know that i
>> can reference the tree with -t option without having to go and figure
>> out what's the numeric id?
> 
> I looked the code and just now realized that we can already use tree name
> for -t like "btrfs ins dump-tree -t EXTNET $DEV".
> Please see treeid_from_string() in inspect-dump-tree.c.

I know we can use tree names what I wanted to know is that the strings
printed from print_objectid aer going to be compatible with that. I will
take your reply as a "yes" in that case.

> 
>>
>>>  			break;
>>>  		case BTRFS_SHARED_BLOCK_REF_KEY:
>>>  			printf("\t\tshared block backref parent %llu\n",
>>>
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
