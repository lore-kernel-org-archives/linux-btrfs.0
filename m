Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33864 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbdAMGMj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jan 2017 01:12:39 -0500
Received: by mail-pf0-f194.google.com with SMTP id y143so6845296pfb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 22:12:39 -0800 (PST)
Subject: Re: [PATCH] Btrfs: add another missing end_page_writeback on
 submit_extent_page failure
To: bo.li.liu@oracle.com
References: <1481870510-44290-1-git-send-email-takafumi.kubota1012@sslab.ics.keio.ac.jp>
 <20161222062044.GC11373@localhost.localdomain>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        linux-kernel@vger.kernel.org, fdmanana@suse.com, naota@elisp.net
From: takafumi-sslab <takafumi.kubota1012@sslab.ics.keio.ac.jp>
Message-ID: <a90bf4a2-ca72-26c2-10f3-d38a3106dc6a@sslab.ics.keio.ac.jp>
Date: Fri, 13 Jan 2017 15:12:31 +0900
MIME-Version: 1.0
In-Reply-To: <20161222062044.GC11373@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your replying.

I understand this bug is more complicated than I expected.
I classify error cases under submit_extent_page() below

A: ENOMEM error at btrfs_bio_alloc() in submit_extent_page()
I first assumed this case and sent the mail.
When bio_ret is NULL, submit_extent_page() calls btrfs_bio_alloc().
Then, btrfs_bio_alloc() may fail and submit_extent_page() returns -ENOMEM.
In this case, bio_endio() is not called and the page's writeback bit 
remains.
So, there is a need to call end_page_writeback() in the error handling.

B: errors under submit_one_bio() of submit_extent_page()
Errors that occur under submit_one_bio() handles at bio_endio(), and 
bio_endio() would call end_page_writeback().

Therefore, as you mentioned in the last mail, simply adding 
end_page_writeback() like my last email and commit 55e3bd2e0c2e1 can 
conflict in the case of B.
To avoid such conflict, one easy solution is adding PageWriteback() 
check too.

How do you think of this solution?

Sincerely,

On 2016/12/22 15:20, Liu Bo wrote:
> On Fri, Dec 16, 2016 at 03:41:50PM +0900, Takafumi Kubota wrote:
>> This is actually inspired by Filipe's patch(55e3bd2e0c2e1).
>>
>> When submit_extent_page() in __extent_writepage_io() fails,
>> Btrfs misses clearing a writeback bit of the failed page.
>> This causes the false under-writeback page.
>> Then, another sync task hangs in filemap_fdatawait_range(),
>> because it waits the false under-writeback page.
>>
>> CPU0                            CPU1
>>
>> __extent_writepage_io()
>>    ret = submit_extent_page() // fail
>>
>>    if (ret)
>>      SetPageError(page)
>>      // miss clearing the writeback bit
>>
>>                                  sync()
>>                                    ...
>>                                    filemap_fdatawait_range()
>>                                      wait_on_page_writeback(page);
>>                                      // wait the false under-writeback page
>>
>> Signed-off-by: Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>
>> ---
>>   fs/btrfs/extent_io.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 1e67723..ef9793b 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -3443,8 +3443,10 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
>>   					 bdev, &epd->bio, max_nr,
>>   					 end_bio_extent_writepage,
>>   					 0, 0, 0, false);
>> -		if (ret)
>> +		if (ret) {
>>   			SetPageError(page);
>> +			end_page_writeback(page);
>> +		}
> OK...this could be complex as we don't know which part in
> submit_extent_page gets the error, if the page has been added into bio
> and bio_end would call end_page_writepage(page) as well, so whichever
> comes later, the BUG() in end_page_writeback() would complain.
>
> Looks like commit 55e3bd2e0c2e1 also has the same problem although I
> gave it my reviewed-by.
>
> Thanks,
>
> -liubo
>
>>   
>>   		cur = cur + iosize;
>>   		pg_offset += iosize;
>> -- 
>> 1.9.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Keio University
System Software Laboratory
Takafumi Kubota
takafumi.kubota1012@sslab.ics.keio.jp

