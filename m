Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:33908 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762047AbcHETOX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Aug 2016 15:14:23 -0400
Received: by mail-pf0-f176.google.com with SMTP id p64so99876110pfb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Aug 2016 12:14:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <657b7978-1d08-f052-8ebc-f061ecb542d0@fb.com>
References: <57A473B0.2040203@kyup.com> <657b7978-1d08-f052-8ebc-f061ecb542d0@fb.com>
From: Nikolay Borisov <n.borisov@siteground.com>
Date: Fri, 5 Aug 2016 22:14:21 +0300
Message-ID: <CAJFSNy5QpTJc4TSXVs02znD70zk+nYZzRqFLsQoUFeSqz6a2Tg@mail.gmail.com>
Subject: Re: Crash in btrfs_uuid_tree_iterate during mount
To: Chris Mason <clm@fb.com>
Cc: Nikolay Borisov <kernel@kyup.com>, linux-btrfs@vger.kernel.org,
        SiteGround Operations <operations@siteground.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 5, 2016 at 6:12 PM, Chris Mason <clm@fb.com> wrote:
>
> On 08/05/2016 07:08 AM, Nikolay Borisov wrote:
>> Hello,
>>
>> Any ideas how come btrfs_path can be all zero, the one in
>> the first slot comes from the increment in btrfs_next_old_item.
>
> Thanks for all the extra details.  It really must be this:
>
>                         if (ret > 0) {
>                                  btrfs_release_path(path);
>                                  ret = btrfs_uuid_iter_rem(root, uuid, key.type,
>                                                            subid_cpu);
>                                  if (ret == 0) {
>                                          /*
>                                           * this might look inefficient, but the
>                                           * justification is that it is an
>                                           * exception that check_func returns 1,
>                                           * and that in the regular case only one
>                                           * entry per UUID exists.
>                                           */
>                                          goto again_search_slot;
>                                  }
>                                  if (ret < 0 && ret != -ENOENT)
>                                          goto out;
>                          }
>                          item_size -= sizeof(subid_le);
>                          offset += sizeof(subid_le);
>
>
> We've released the path, which would explain why its full of NULL.  ret
> was ENOENT, so it kept on going, and we fell through to
> btrfs_next_item()
>
> Once the path is released, we should either be searching again or
> exiting.  A goto again_search_slot would probably fix it, but I'd want
> to also bump the key so we don't just process the same item over and
> over again.
>
> Can you reproduce this reliably?  I'd hate to patch it now and make more
> problems later just because we didn't fully understand the items we were
> tripping over.

Well there are 2 things I can do:
 a) Dig more in the crash dump to see whether ret has been saved to
the stack and extract the return value. If your theory is correct I
should see the value of ENOENT.
 b) Patch the code to print a warn when btrfs_uuid_iter_rem returns an
ENOENT, that way at least we will know that this is happening.

In either cases this would take me until at least next week, at which
time I should be able to  give more information.

>
> -chris
