Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56023 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S934774AbcIFKWa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 06:22:30 -0400
Subject: Re: [PATCH] btrfs: introduce tickets_id to determine whether
 asynchronous metadata reclaim work makes progress
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
References: <20160902025846.4133-1-wangxg.fnst@cn.fujitsu.com>
 <67e302bc-583a-3d75-1ff7-c855db181d9b@fb.com>
CC: <dsterba@suse.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57CE97E4.6050809@cn.fujitsu.com>
Date: Tue, 6 Sep 2016 18:18:12 +0800
MIME-Version: 1.0
In-Reply-To: <67e302bc-583a-3d75-1ff7-c855db181d9b@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 09/02/2016 09:28 PM, Josef Bacik wrote:
> On 09/01/2016 10:58 PM, Wang Xiaoguang wrote:
>> In btrfs_async_reclaim_metadata_space(), we use ticket's address to
>> determine whether asynchronous metadata reclaim work is making progress.
>>
>>     ticket = list_first_entry(&space_info->tickets,
>>                   struct reserve_ticket, list);
>>     if (last_ticket == ticket) {
>>         flush_state++;
>>     } else {
>>         last_ticket = ticket;
>>         flush_state = FLUSH_DELAYED_ITEMS_NR;
>>         if (commit_cycles)
>>             commit_cycles--;
>>     }
>>
>> But indeed it's wrong, we should not rely on local variable's address to
>> do this check, because addresses may be same. In my test environment, I
>> dd one 168MB file in a 256MB fs, found that for this file, every time
>> wait_reserve_ticket() called, local variable ticket's address is same,
>>
>> For above codes, assume a previous ticket's address is addrA, 
>> last_ticket
>> is addrA. Btrfs_async_reclaim_metadata_space() finished this ticket and
>> wake up it, then another ticket is added, but with the same address 
>> addrA,
>> now last_ticket will be same to current ticket, then current ticket's 
>> flush
>> work will start from current flush_state, not initial 
>> FLUSH_DELAYED_ITEMS_NR,
>> which may result in some enospc issues(I have seen this in my test 
>> machine).
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>
> We want to track the progress of the individual tickets, not whether 
> or not we make progress on the space_info, so instead store the global 
> ticket id in space_info and store the individual ticket_id in the 
> ticket itself, and use that as the last_tickets_id.  Thanks,
Sorry for being late.

In btrfs_async_reclaim_metadata_space(), there is codes:
if (flush_state > COMMIT_TRANS) {
             commit_cycles++;
             if (commit_cycles > 2) {
                 wake_all_tickets(&space_info->tickets);
                 space_info->flush = 0;
             } else {
                 flush_state = FLUSH_DELAYED_ITEMS_NR;
             }
}
 From above codes, if it can not satisfy one current ticket, it'll 
discard all current
queued tickets. So I think your original codes is to track whether or not we
make progress on the space_info, and this patch can fix the issue which 
is described
in commit message.
Also I'm not sure whether I have understood your design completely. If 
I'm wrong, sorry.

Regards,
Xiaoguang Wang

>
> Josef
>
>



