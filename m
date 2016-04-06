Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:34519 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbcDFRHJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 13:07:09 -0400
Subject: Re: [PATCH] btrfs:Change BUG_ON to new error path in
 __clear_extent_bit
To: fdmanana@gmail.com
References: <1459958196-31346-1-git-send-email-bastienphilbert@gmail.com>
 <CAL3q7H5GLadiLA9PWBXyfamRUb4o=8vHiPd16e9XYBAbWjSKiA@mail.gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Bastien Philbert <bastienphilbert@gmail.com>
Message-ID: <57054233.7080705@gmail.com>
Date: Wed, 6 Apr 2016 13:06:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5GLadiLA9PWBXyfamRUb4o=8vHiPd16e9XYBAbWjSKiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2016-04-06 12:10 PM, Filipe Manana wrote:
> On Wed, Apr 6, 2016 at 4:56 PM, Bastien Philbert
> <bastienphilbert@gmail.com> wrote:
>> This remove the unnessary BUG_ON if the allocation with
>> alloc_extent_state_atomic fails due to this function
>> failure not being unrecoverable. Instead we now change
>> this BUG_ON into a new error path that jumps to the goto
>> label, out from freeing previously allocated resources
>> before returning the error code -ENOMEM to signal callers
>> that the call to __clear_extent_bit failed due to a memory
>> allocation failure.
>>
>> Signed-off-by: Bastien Philbert <bastienphilbert@gmail.com>
>> ---
>>  fs/btrfs/extent_io.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index d247fc0..4c87b77 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -682,7 +682,10 @@ hit_next:
>>
>>         if (state->start < start) {
>>                 prealloc = alloc_extent_state_atomic(prealloc);
>> -               BUG_ON(!prealloc);
>> +               if (!prealloc) {
>> +                       err = -ENOMEM;
>> +                       goto out;
>> +               }
> 
> Why only in this particular place? We do this in other places in this function.
> 
> Second, setting err to -ENOMEM is not enough. Under the out label we
> always return 0, so you're not propagating the error to callers.
> 
> Now, most importantly, you didn't check if callers handle errors from
> this function (__clear_extent_bit()) at all. A failure in this
> function is critical.
> For example, it can cause a range in an inode's io tree to become
> locked forever, blocking any other tasks that want to operate on the
> range, and we won't ever know what happened.
> So it's far from trivial to handle errors from this function and
> that's why the BUG_ON is there.
> 
> If you really want to get rid of the BUG_ON() calls you need to make
> sure all callers don't ignore the errors and that they deal with them
> properly.
Sorry, I feel really stupid about missing those other callers. :(
Bastien
> 
> 
>>                 err = split_state(tree, state, prealloc, start);
>>                 if (err)
>>                         extent_io_tree_panic(tree, err);
>> --
>> 2.5.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
