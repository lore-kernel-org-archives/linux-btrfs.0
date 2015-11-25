Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59831 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbbKYSJC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 13:09:02 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E1EE620877
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2015 18:09:00 +0000 (UTC)
Received: from mail-io0-f169.google.com (mail-io0-f169.google.com [209.85.223.169])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id DD2822085D
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2015 18:08:58 +0000 (UTC)
Received: by ioc74 with SMTP id 74so61491050ioc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2015 10:08:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151125175831.GB21642@localhost.localdomain>
References: <1448385918-5536-1-git-send-email-fdmanana@kernel.org>
	<20151125175831.GB21642@localhost.localdomain>
Date: Wed, 25 Nov 2015 18:08:58 +0000
Message-ID: <CAL3q7H6sxnCBEzU_ObB+Fn9H137LbtKjKTB9M0fDf+_7bi=3mQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix error path when failing to submit bio for
 direct IO write
From: Filipe Manana <fdmanana@kernel.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 25, 2015 at 5:58 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Tue, Nov 24, 2015 at 05:25:18PM +0000, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> Commit 61de718fceb6 ("Btrfs: fix memory corruption on failure to submit
>> bio for direct IO") fixed problems with the error handling code after we
>> fail to submit a bio for direct IO. However there were 2 problems that it
>> did not address when the failure is due to memory allocation failures for
>> direct IO writes:
>>
>> 1) We considered that there could be only one ordered extent for the whole
>>    IO range, which is not always true, as we can have multiple;
>>
>> 2) It did not set the bit BTRFS_ORDERED_IO_DONE in the ordered extent,
>>    which can make other tasks running btrfs_wait_logged_extents() hang
>>    forever, since they wait for that bit to be set. The general assumption
>>    is that regardless of an error, the BTRFS_ORDERED_IO_DONE is always set
>>    and it precedes setting the bit BTRFS_ORDERED_COMPLETE.
>>
>> Fix these issues by moving part of the btrfs_endio_direct_write() handler
>> into a new helper function and having that new helper function called when
>> we fail to allocate memory to submit the bio (and its private object) for
>> a direct IO write.
>>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>  fs/btrfs/inode.c | 54 +++++++++++++++++++++++++++---------------------------
>>  1 file changed, 27 insertions(+), 27 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index f82d1f4..4f8560c 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -7995,22 +7995,22 @@ static void btrfs_endio_direct_read(struct bio *bio)
>>       bio_put(bio);
>>  }
>>
>> -static void btrfs_endio_direct_write(struct bio *bio)
>> +static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
>> +                                                 const u64 offset,
>> +                                                 const u64 bytes,
>> +                                                 const int uptodate)
>>  {
>> -     struct btrfs_dio_private *dip = bio->bi_private;
>> -     struct inode *inode = dip->inode;
>>       struct btrfs_root *root = BTRFS_I(inode)->root;
>>       struct btrfs_ordered_extent *ordered = NULL;
>> -     u64 ordered_offset = dip->logical_offset;
>> -     u64 ordered_bytes = dip->bytes;
>> -     struct bio *dio_bio;
>> +     u64 ordered_offset = offset;
>> +     u64 ordered_bytes = bytes;
>>       int ret;
>>
>>  again:
>>       ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
>>                                                  &ordered_offset,
>>                                                  ordered_bytes,
>> -                                                !bio->bi_error);
>> +                                                uptodate);
>>       if (!ret)
>>               goto out_test;
>>
>> @@ -8023,13 +8023,22 @@ out_test:
>>        * our bio might span multiple ordered extents.  If we haven't
>>        * completed the accounting for the whole dio, go back and try again
>>        */
>> -     if (ordered_offset < dip->logical_offset + dip->bytes) {
>> -             ordered_bytes = dip->logical_offset + dip->bytes -
>> -                     ordered_offset;
>> +     if (ordered_offset < offset + bytes) {
>> +             ordered_bytes = offset + bytes - ordered_offset;
>>               ordered = NULL;
>>               goto again;
>>       }
>> -     dio_bio = dip->dio_bio;
>> +}
>> +
>> +static void btrfs_endio_direct_write(struct bio *bio)
>> +{
>> +     struct btrfs_dio_private *dip = bio->bi_private;
>> +     struct bio *dio_bio = dip->dio_bio;
>> +
>> +     btrfs_endio_direct_write_update_ordered(dip->inode,
>> +                                             dip->logical_offset,
>> +                                             dip->bytes,
>> +                                             !bio->bi_error);
>>
>>       kfree(dip);
>>
>> @@ -8365,24 +8374,15 @@ free_ordered:
>>               dip = NULL;
>>               io_bio = NULL;
>>       } else {
>> -             if (write) {
>> -                     struct btrfs_ordered_extent *ordered;
>> -
>> -                     ordered = btrfs_lookup_ordered_extent(inode,
>> -                                                           file_offset);
>> -                     set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
>> -                     /*
>> -                      * Decrements our ref on the ordered extent and removes
>> -                      * the ordered extent from the inode's ordered tree,
>> -                      * doing all the proper resource cleanup such as for the
>> -                      * reserved space and waking up any waiters for this
>> -                      * ordered extent (through btrfs_remove_ordered_extent).
>> -                      */
>> -                     btrfs_finish_ordered_io(ordered);
>> -             } else {
>> +             if (write)
>> +                     btrfs_endio_direct_write_update_ordered(inode,
>> +                                             file_offset,
>> +                                             dio_bio->bi_iter.bi_size,
>> +                                             1);
>
> uptodate=1 won't set IOERR for ordered extent, is that expected?

Indeed, wrong value due to inverted logic from a local earlier version I had.
Thanks.

>
> Thanks,
>
> -liubo
>> +             else
>>                       unlock_extent(&BTRFS_I(inode)->io_tree, file_offset,
>>                             file_offset + dio_bio->bi_iter.bi_size - 1);
>> -             }
>> +
>>               dio_bio->bi_error = -EIO;
>>               /*
>>                * Releases and cleans up our dio_bio, no need to bio_put()
>> --
>> 2.1.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
