Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38056 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751816AbeAaKxl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 05:53:41 -0500
Subject: Re: [RESEND PATCH] btrfs: Handle btrfs_set_extent_delalloc failure in
 relocate_file_extent_cluster
To: fdmanana@gmail.com
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <1516979117-15117-1-git-send-email-nborisov@suse.com>
 <1517322767-3044-1-git-send-email-nborisov@suse.com>
 <CAL3q7H7Zr=cOqw9ACLdT-YbAVkkoRCOkiQ1PQAoP5oxpKERnLA@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f8066334-e24c-1dd8-0ca9-ff3e4958ed0f@suse.com>
Date: Wed, 31 Jan 2018 12:53:38 +0200
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7Zr=cOqw9ACLdT-YbAVkkoRCOkiQ1PQAoP5oxpKERnLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 31.01.2018 12:49, Filipe Manana wrote:
> On Tue, Jan 30, 2018 at 2:32 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>> Essentially duplicate the error handling from the above block which
>> handles the !PageUptodate(page) case and additionally clear
>> EXTENT_BOUNDARY.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> Reviewed-by: Josef Bacik <jbacik@fb.com>
>> ---
>>
>> Put description of the intended changes.
>>
>>  fs/btrfs/relocation.c | 21 +++++++++++++++++----
>>  1 file changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index f0c3f00e97cb..8b2a31cef5cf 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -3268,12 +3268,25 @@ static int relocate_file_extent_cluster(struct inode *inode,
>>                         nr++;
>>                 }
>>
>> -               btrfs_set_extent_delalloc(inode, page_start, page_end, 0, NULL,
>> -                                         0);
>> +               ret = btrfs_set_extent_delalloc(inode, page_start, page_end, 0,
>> +                                               NULL, 0);
>> +               if (ret) {
>> +                       unlock_page(page);
>> +                       put_page(page);
>> +                       btrfs_delalloc_release_metadata(BTRFS_I(inode),
>> +                                                        PAGE_SIZE);
>> +                       btrfs_delalloc_release_extents(BTRFS_I(inode),
>> +                                                      PAGE_SIZE);
>> +
>> +                       clear_extent_bits(&BTRFS_I(inode)->io_tree,
>> +                                         page_start, page_end,
>> +                                         EXTENT_LOCKED | EXTENT_BOUNDARY);
>> +                       goto out;
>> +
>> +               }
>>                 set_page_dirty(page);
>>
>> -               unlock_extent(&BTRFS_I(inode)->io_tree,
>> -                             page_start, page_end);
>> +               unlock_extent(&BTRFS_I(inode)->io_tree, page_start, page_end);
> 
> This is an unrelated change. Please don't mix pure white
> space/indentation changes with functional changes.

David seems rather adamant in not accepting pure whitespace/indention
changes on their own so I don't see a way to actually improve the code
base in that regard unless i slip them up when modifying nearby code.
There are a couple of space with trailing whitespace which I constantly
select out from my commits.

Given that you have now also expressed objection to such cleanups, how
should they eventually be fixed?

> 
>>                 unlock_page(page);
>>                 put_page(page);
>>
>> --
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
