Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35817 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751802AbeDES6R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Apr 2018 14:58:17 -0400
Received: by mail-io0-f193.google.com with SMTP id x77so25572892ioi.2
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Apr 2018 11:58:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180405164831.GI2635@twin.jikos.cz>
References: <1522447918-19147-1-git-send-email-bo.liu@linux.alibaba.com> <20180405164831.GI2635@twin.jikos.cz>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Thu, 5 Apr 2018 11:58:16 -0700
Message-ID: <CANQeFDBSAX=+-S7umzWAXgVzUe7vXYM=qL6FJSUTw9jmPj=nnw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: do not abort transaction when failing to insert
 hole extent
To: David Sterba <dsterba@suse.cz>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 5, 2018 at 9:48 AM, David Sterba <dsterba@suse.cz> wrote:
> On Sat, Mar 31, 2018 at 06:11:55AM +0800, Liu Bo wrote:
>> This is running in a typical write path, not inside a critical path
>> where we have to abort the running transaction, so it's OK to return
>> errors to callers and eventually to userspace.
>
> I'm not sure this is entierly correct, several other places do not abort
> after btrfs_drop_extents as there's nothing that would leave the
> structres in some half-state.
>
>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>> ---
>>  fs/btrfs/inode.c | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index c7b75dd..b9310f8 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -4939,16 +4939,13 @@ static int maybe_insert_hole(struct btrfs_root *root, struct inode *inode,
>>
>>       ret = btrfs_drop_extents(trans, root, inode, offset, offset + len, 1);
>>       if (ret) {
>> -             btrfs_abort_transaction(trans, ret);
>>               btrfs_end_transaction(trans);
>>               return ret;
>>       }
>>
>>       ret = btrfs_insert_file_extent(trans, root, btrfs_ino(BTRFS_I(inode)),
>>                       offset, 0, 0, len, 0, len, 0, 0, 0);
>
> But here the extents have been already dropped and missing to insert the
> items does not seem to lead to a consistent state.
>
> It's possible that I'm missing something. In a call path that can be
> safely rolled back even with a started transaction, we don't need to
> abort in all cases. But if the rollback requires some non-trivial
> modifications, I don't see options how to avoid the abort.
>
> __btrfs_drop_extents does a lot of state changes and can itself fail
> in the middle of dropping the range, aborting looks like the safest
> option.
>

As maybe_insert_hole is only called by btrfs_cont_expand here, which
means it's a really hole, I don't expect drop_extents would drop
anything, we can remove this drop_extents and put an assert after
btrfs_insert_file_extent for checking EEXIST.

It's different from punch hole where we need to explicitly drop an
actual extent and replace it with a hole range.

thanks,
liubo

>> -     if (ret)
>> -             btrfs_abort_transaction(trans, ret);
>> -     else
>> +     if (!ret)
>>               btrfs_update_inode(trans, root, inode);
>>       btrfs_end_transaction(trans);
>>       return ret;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
