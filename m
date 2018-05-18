Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:39860 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751695AbeERCJU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 22:09:20 -0400
Received: by mail-io0-f196.google.com with SMTP id r9-v6so4406084iod.6
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 19:09:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cd21247d-06b9-6154-c151-be37e0d9a1da@suse.com>
References: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526406728-109055-3-git-send-email-bo.liu@linux.alibaba.com> <cd21247d-06b9-6154-c151-be37e0d9a1da@suse.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Fri, 18 May 2018 10:09:19 +0800
Message-ID: <CANQeFDDKMzFkTC2_NxibzHsMMmcz6UoZ4D3Dq2MmdqRpdQeipg@mail.gmail.com>
Subject: Re: [PATCH 2/6] Btrfs: use more straightforward extent_buffer_uptodate
To: Nikolay Borisov <nborisov@suse.com>
Cc: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 2:43 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>
>
> On 15.05.2018 20:52, Liu Bo wrote:
>> In read_block_for_search(), it's straightforward to use
>> extent_buffer_uptodate() instead since 0 is passed as parent transid to
>
> "instead of the more heavyweight btrfs_buffer_update"
>

I don't think it's about heavyweight, they're actually equivalent in this case.

I just want to reduce the burden of reading these code as
verify_parent_transid() really has some corner cases to think about.

>> btrfs_buffer_uptodate(), which means the check for parent transid is not
>> needed.
>>
>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>
> Codewise LGTM:
>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Thanks for taking a look at this.

thanks,
liubo

>> ---
>>  fs/btrfs/ctree.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index 9fa3d77c98d4..a96d308c51b8 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -2445,7 +2445,7 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
>>                * and give up so that our caller doesn't loop forever
>>                * on our EAGAINs.
>>                */
>> -             if (!btrfs_buffer_uptodate(tmp, 0, 0))
>> +             if (!extent_buffer_uptodate(tmp))
>>                       ret = -EIO;
>>               free_extent_buffer(tmp);
>>       } else {
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
