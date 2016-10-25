Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50782 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754065AbcJYTKP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 15:10:15 -0400
Subject: Re: [PATCH 2/5] writeback: convert WB_WRITTEN/WB_DIRITED counters to
 bytes
To: Tejun Heo <htejun@fb.com>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-3-git-send-email-jbacik@fb.com>
 <20161025190317.GB13857@htj.duckdns.org>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>, <david@fromorbit.com>,
        <jack@suse.cz>, <linux-fsdevel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <hch@infradead.org>, <jweiner@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <9eb320ce-a1fa-bb4f-a21b-ee3557bb6083@fb.com>
Date: Tue, 25 Oct 2016 15:09:42 -0400
MIME-Version: 1.0
In-Reply-To: <20161025190317.GB13857@htj.duckdns.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/25/2016 03:03 PM, Tejun Heo wrote:
> Hello, Josef.
>
> On Tue, Oct 25, 2016 at 02:41:41PM -0400, Josef Bacik wrote:
>> These are counters that constantly go up in order to do bandwidth calculations.
>> It isn't important what the units are in, as long as they are consistent between
>> the two of them, so convert them to count bytes written/dirtied, and allow the
>> metadata accounting stuff to change the counters as well.
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> A small nit below.
>
>> @@ -2547,12 +2547,16 @@ void account_page_redirty(struct page *page)
>>  	if (mapping && mapping_cap_account_dirty(mapping)) {
>>  		struct inode *inode = mapping->host;
>>  		struct bdi_writeback *wb;
>> +		unsigned long flags;
>>  		bool locked;
>>
>>  		wb = unlocked_inode_to_wb_begin(inode, &locked);
>>  		current->nr_dirtied--;
>> -		dec_node_page_state(page, NR_DIRTIED);
>> -		dec_wb_stat(wb, WB_DIRTIED);
>> +
>> +		local_irq_save(flags);
>> +		__dec_node_page_state(page, NR_DIRTIED);
>> +		__add_wb_stat(wb, WB_DIRTIED_BYTES, -(long)PAGE_SIZE);
>> +		local_irq_restore(flags);
>
> Hmmm... so, the explicit irq clustering is neutral or win as the code
> currently stands but AFAICS that's just because add_wb_stat() doesn't
> use the right percpu ops.  If we convert add_wb_stat() to use the
> matching percpu ops, the above change would be more expensive at least
> on x86.  Maybe just skip this part?
>

Yeah I can convert it over and then just not do the irq dance.  I'll fix that up 
for the next go around.  Thanks,

Josef

