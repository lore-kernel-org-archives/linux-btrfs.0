Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42471 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbbBZJzL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Feb 2015 04:55:11 -0500
Received: by lbiw7 with SMTP id w7so9655696lbi.9
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2015 01:55:10 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <007f01d05099$01bc2430$05346c90$@cn.fujitsu.com>
References: <1424792249-26672-1-git-send-email-zhaolei@cn.fujitsu.com>
	<CAL3q7H63LBgPvVcggR+fZ3KrfLWH8D7ZJDjUo_orqbrmTVmeNw@mail.gmail.com>
	<007f01d05099$01bc2430$05346c90$@cn.fujitsu.com>
Date: Thu, 26 Feb 2015 09:55:10 +0000
Message-ID: <CAL3q7H7E5dtfaj_W+rETOUkGYxYLaCqXKxuC0aP9X-OfOLwkuw@mail.gmail.com>
Subject: Re: [PATCH 3/3] btrfs: Remove BUG_ON() when failed searching
 block_group_cache in unpin_extent_range()
From: Filipe David Manana <fdmanana@gmail.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 25, 2015 at 1:18 AM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
> Hi, Filipe
>
>> From: Filipe David Manana [mailto:fdmanana@gmail.com]
>>
>> On Tue, Feb 24, 2015 at 3:37 PM, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
>> > From: Zhao Lei <zhaolei@cn.fujitsu.com>
>> >
>> > Above BUG_ON() was triggered only one time in my test, but hadn't
>> > happened again in same env.
>> >
>> > The reason maybe:
>> > A block group which include pinned space was removed before
>> > unpin_extent_range(), and no other block_group_cache after "start"
>> > pos, so the code entered into above BUG_ON().
>> >
>> > To support auto-remove-bgs, we can remove above BUG_ON(), and bypass
>> > removed bgs.
>>
>> I don't think it's a good idea to remove this BUG_ON().
>> You're just hiding (potentially dangerous) logical bugs doing that - we need to
>> understand exactly why that happens and fix it.
>>
>> I fixed a scenario where this happens recently, and the fix is in 4.0-rc1:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d4b4
>> 50cd4b33ce7c572e7fdccf33b59c4cdf361c
>>
>> Were you testing with or without this fix?
>>
> Thanks for notice, it is better way of fix.
> I'll drop this patch.

Sorry I also missed to mention 2 things before:

1) Your patch can lead to space leaks too. The range we're passing to
unpin_extent_range() can cover more than 1 block group - for example
the whole block group that is about to be deleted plus part of an
adjacent block group that isn't empty. In this case you would be
leaking space forever, and that space corresponds to the part of the
block group that isn't empty;

2) There's another race my fix deals with which I haven't mentioned in
the commit message. If you look at the time sequence diagram from the
commit message, it's possible that after CPU 2 deletes the block group
and before CPU 1 calls unpin_extent_range(), a new block group using
the same logical address (but different physical address of course) is
created and space allocated from it. In this (hopefully very unlikely)
scenario, CPU 1 would just mark that allocated space as freed when it
isn't, as it has no way to know there's a new block group with the
same logical address - this would be terrible.

thanks

>
> Thanks
> Zhaolei
>
>> Thanks
>>
>> >
>> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> > ---
>> >  fs/btrfs/extent-tree.c | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c index
>> > 8b51eb5..ef0b40d 100644
>> > --- a/fs/btrfs/extent-tree.c
>> > +++ b/fs/btrfs/extent-tree.c
>> > @@ -5751,7 +5751,8 @@ static int unpin_extent_range(struct btrfs_root
>> *root, u64 start, u64 end,
>> >                         if (cache)
>> >                                 btrfs_put_block_group(cache);
>> >                         cache = btrfs_lookup_block_group(fs_info,
>> start);
>> > -                       BUG_ON(!cache); /* Logic error */
>> > +                       if (!cache)
>> > +                               break;
>> >                 }
>> >
>> >                 len = cache->key.objectid + cache->key.offset - start;
>> > --
>> > 1.8.5.1
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>> > in the body of a message to majordomo@vger.kernel.org More majordomo
>> > info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>  Unreasonable men adapt the world to themselves.
>>  That's why all progress depends on unreasonable men."
>
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
