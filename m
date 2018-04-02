Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35917 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752900AbeDBRvN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Apr 2018 13:51:13 -0400
Received: by mail-io0-f193.google.com with SMTP id o4so18800783iod.3
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Apr 2018 10:51:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cc4fb2de-3bbf-1726-e8cf-5725d7cd674b@suse.com>
References: <1522447918-19147-3-git-send-email-bo.liu@linux.alibaba.com> <cc4fb2de-3bbf-1726-e8cf-5725d7cd674b@suse.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Mon, 2 Apr 2018 10:51:12 -0700
Message-ID: <CANQeFDD2BNPj3w6udAdvxfWsuTRc+_k=WxMRJDMiKhkfNSFcGQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix NULL pointer dereference in log_dir_items
To: Nikolay Borisov <nborisov@suse.com>
Cc: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 1, 2018 at 3:03 AM, Nikolay Borisov <nborisov@suse.com> wrote:
>
>
> On 31.03.2018 01:11, Liu Bo wrote:
>> 0, 1 and <0 can be returned by btrfs_next_leaf(), and when <0 is
>> returned, path->nodes[0] could be NULL, log_dir_items lacks such a
>> check for <0 and we may run into a null pointer dereference panic.
>>
>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>
> This bug has been present ever since 2.6.29 (e02119d5a7b4 ("Btrfs: Add a
> write ahead tree log to optimize synchronous operations"))
>  so this needs a stable tag.

OK, git describe e02119d5a7b4 doesn't show a tag though.

thanks,
liubo
>
>> ---
>>  fs/btrfs/tree-log.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index 4344577..4ee9431 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -3518,8 +3518,11 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
>>                * from this directory and from this transaction
>>                */
>>               ret = btrfs_next_leaf(root, path);
>> -             if (ret == 1) {
>> -                     last_offset = (u64)-1;
>> +             if (ret) {
>> +                     if (ret == 1)
>> +                             last_offset = (u64)-1;
>> +                     else
>> +                             err = ret;
>>                       goto done;
>>               }
>>               btrfs_item_key_to_cpu(path->nodes[0], &tmp, path->slots[0]);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
