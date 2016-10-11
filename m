Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25790 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753112AbcJKCTG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 22:19:06 -0400
Subject: Re: [PATCH 2/4] btrfs-progs: Make btrfs-debug-tree print all readable
 strings for inode flags
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        <lakshmipathi.g@gmail.com>
References: <20161010031121.5017-1-quwenruo@cn.fujitsu.com>
 <20161010031121.5017-3-quwenruo@cn.fujitsu.com>
 <20161010155026.GL11398@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <9f4cc38e-4c95-7938-fd74-6cf39411901e@cn.fujitsu.com>
Date: Tue, 11 Oct 2016 10:18:51 +0800
MIME-Version: 1.0
In-Reply-To: <20161010155026.GL11398@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/10/2016 11:50 PM, David Sterba wrote:
> On Mon, Oct 10, 2016 at 11:11:19AM +0800, Qu Wenruo wrote:
>> Before this patch, only 3 inode flags have readable string: NODATACOW,
>> NODATASUM, READONLY.
>>
>> This patch will output all readable strings for remaining inode flags,
>> making debug-tree tool more handy.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  print-tree.c | 46 ++++++++++++++++++++++++++--------------------
>>  1 file changed, 26 insertions(+), 20 deletions(-)
>>
>> diff --git a/print-tree.c b/print-tree.c
>> index 4444a14..f015646 100644
>> --- a/print-tree.c
>> +++ b/print-tree.c
>> @@ -851,29 +851,35 @@ static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
>>  	}
>>  }
>>
>> -/* Caller should ensure sizeof(*ret) >= 29 "NODATASUM|NODATACOW|READONLY" */
>> +#define copy_one_inode_flag(flags, name, empty, dst) ({			\
>> +	if (flags & BTRFS_INODE_##name) {				\
>> +		if (!empty)						\
>> +			strcat(dst, "|");				\
>> +		strcat(dst, #name);					\
>> +		empty = 0;						\
>> +	}								\
>> +})
>
> Can you please avoid using the macro? Or at least make it uppercase so
> it's visible. Similar in the next patch.
>
>
OK, I'll change it to upper case.

The only reason I'm using macro is, inline function can't do 
stringification, or I missed something?

Thanks,
Qu


