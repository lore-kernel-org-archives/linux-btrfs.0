Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:59977 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754673AbdIHILH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 04:11:07 -0400
Subject: Re: [PATCH 1/2] btrfs: clear ordered flag on cleaning up ordered
 extents
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, fdmanana@suse.com, clm@fb.com,
        dsterba@suse.com, jbacik@fb.com
References: <150425632766.4737.133868215044509089.stgit@naota.dhcp.fujisawa.hgst.com>
 <8faafb31-e88d-d7d4-ea8d-94b87630bd6a@gmx.com>
 <20170907182530.GE31874@twin.jikos.cz>
From: Naohiro Aota <naohiro.aota@wdc.com>
Message-ID: <b6a5589e-b3c4-b429-d2d8-c06c10a16abe@wdc.com>
Date: Fri, 8 Sep 2017 17:10:04 +0900
MIME-Version: 1.0
In-Reply-To: <20170907182530.GE31874@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017年09月08日 03:25, David Sterba wrote:
> On Fri, Sep 01, 2017 at 06:59:49PM +0800, Qu Wenruo wrote:
>> On 2017年09月01日 16:58, Naohiro Aota wrote:
>>> commit 524272607e88 ("btrfs: Handle delalloc error correctly to avoid
>>> ordered extent hang") introduced btrfs_cleanup_ordered_extents() to cleanup
>>> submitted ordered extents. However, it does not clear the ordered bit
>>> (Private2) of coresponding pages. Thus, the following BUG occurs from
>>> free_pages_check_bad() (on btrfs/125 with nospace_cache).
>>>
>>> BUG: Bad page state in process btrfs  pfn:3fa787
>>> page:ffffdf2acfe9e1c0 count:0 mapcount:0 mapping:          (null) index:0xd
>>> flags: 0x8000000000002008(uptodate|private_2)
>>> raw: 8000000000002008 0000000000000000 000000000000000d 00000000ffffffff
>>> raw: ffffdf2acf5c1b20 ffffb443802238b0 0000000000000000 0000000000000000
>>> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
>>> bad because of flags: 0x2000(private_2)
>>>
>>> This patch clear the flag as same as other places calling
>>> btrfs_dec_test_ordered_pending() for every page in the specified range.
>>>
>>> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
>>> Fixes: 524272607e88 ("btrfs: Handle delalloc error correctly to avoid ordered extent hang")
>>> Cc: <stable@vger.kernel.org> # 4.12
>>> ---
>>>   fs/btrfs/inode.c |   12 ++++++++++++
>>>   1 file changed, 12 insertions(+)
>>>
>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> index 24bcd5cd9cf2..ae4c0a1bef38 100644
>>> --- a/fs/btrfs/inode.c
>>> +++ b/fs/btrfs/inode.c
>>> @@ -135,6 +135,18 @@ static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
>>>   						 const u64 offset,
>>>   						 const u64 bytes)
>>>   {
>>> +	unsigned long index = offset >> PAGE_SHIFT;
>>> +	unsigned long end_index = (offset + bytes - 1) >> PAGE_SHIFT;
>>> +	struct page *page;
>>> +
>>> +	while (index <= end_index) {
>>> +		page = find_get_page(inode->i_mapping, index);
>>> +		index++;
>>> +		if (!page)
>>> +			continue;
>>> +		ClearPagePrivate2(page);
>>> +		put_page(page);
>>> +	}
>>
>> At first glance, explicitly clearing Private2 flag here seems a little 
>> strange to me.
>> However btrfs_invalidatepage() is also doing the same thing, I think 
>> it's fine.
>>
>> Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
>>
>> BTW, Private2 flag is set by extent_clear_unlock_delalloc() with 
>> page_ops |= PAGE_SET_PRIVATE2, but we're clearing the page flag without 
>> any encapsulation, it may be better to use similar function to clear 
>> Private2 flag.
> 
> I agree, the Private2 flag is given another meaning in btrfs, ie. the
> writeback status, so this would be better wrapped in helpers that
> reflect what is the private2 flag used for. The helpers might be
> trivial, but their name will be a better documentation than the random
> comments that we can be found next to its use.
> 

Thanks for the reviews. I'll send a new patch to add the wrapping
function. (or should I squash the patch with this change?)

Regards,
Naohiro
