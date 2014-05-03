Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64594 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaECTkN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 May 2014 15:40:13 -0400
Received: by mail-wi0-f171.google.com with SMTP id hm4so3842690wib.10
        for <linux-btrfs@vger.kernel.org>; Sat, 03 May 2014 12:40:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140317125506.GD29256@twin.jikos.cz>
References: <1394829413-1620-1-git-send-email-jbacik@fb.com>
	<20140317125506.GD29256@twin.jikos.cz>
Date: Sat, 3 May 2014 22:40:11 +0300
Message-ID: <CAOcd+r3eKn2wpLG0_EbN+qOreWctFyPTztBK93RipbD7yH9mwQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: abort the transaction when we don't find our
 extent ref
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
how about aborting the transaction also in place that you print:
"umm, got %d back from search, was looking for %llu"
You abort in case ret<0, otherwise the code just proceeds with
extent_slot = path->slots[0];
which can't be right in that case.

Thanks,
Alex.

On Mon, Mar 17, 2014 at 3:55 PM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Mar 14, 2014 at 04:36:53PM -0400, Josef Bacik wrote:
>> I'm not sure why we weren't aborting here in the first place, it is obviously a
>> bad time from the fact that we print the leaf and yell loudly about it.  Fix
>> this up, otherwise we panic because our path could be pointing into oblivion.
>> Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>>  fs/btrfs/extent-tree.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 696f0b6..0015b02 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -5744,6 +5744,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
>
> Adding context:
>
> 5748         } else if (WARN_ON(ret == -ENOENT)) {
> 5749                 btrfs_print_leaf(extent_root, path->nodes[0]);
> 5750                 btrfs_err(info,
>
>>                       "unable to find ref byte nr %llu parent %llu root %llu  owner %llu offset %llu",
>>                       bytenr, parent, root_objectid, owner_objectid,
>>                       owner_offset);
>> +             btrfs_abort_transaction(trans, extent_root, ret);
>
> Abort prints stacktrace on it's own and with the WARN_ON above it would
> be noisy and without any extra benefit, so I suggest to remove it.
>
>> +             goto out;
>>       } else {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
