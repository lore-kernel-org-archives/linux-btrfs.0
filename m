Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:51867 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847Ab3H2SlF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 14:41:05 -0400
Received: by mail-bk0-f52.google.com with SMTP id e11so327371bkh.11
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 11:41:04 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130829180816.GO26818@lenny.home.zabbo.net>
References: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
	<1377784766-7552-1-git-send-email-fdmanana@gmail.com>
	<20130829180816.GO26818@lenny.home.zabbo.net>
Date: Thu, 29 Aug 2013 19:41:03 +0100
Message-ID: <CAL3q7H612-zhP1tydL+5M1zdZKtbZYdVmhVKeyEYiH_+wjF7UA@mail.gmail.com>
Subject: Re: [PATCH v3] Btrfs: optimize key searches in btrfs_search_slot
From: Filipe David Manana <fdmanana@gmail.com>
To: Zach Brown <zab@redhat.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 29, 2013 at 7:08 PM, Zach Brown <zab@redhat.com> wrote:
> On Thu, Aug 29, 2013 at 02:59:26PM +0100, Filipe David Borba Manana wrote:
>> When the binary search returns 0 (exact match), the target key
>> will necessarily be at slot 0 of all nodes below the current one,
>> so in this case the binary search is not needed because it will
>> always return 0, and we waste time doing it, holding node locks
>> for longer than necessary, etc.
>>
>> Below follow histograms with the times spent on the current approach of
>> doing a binary search when the previous binary search returned 0, and
>> times for the new approach, which directly picks the first item/child
>> node in the leaf/node.
>>
>> Count: 5013
>> Range: 25.000 - 497.000; Mean: 82.767; Median: 64.000; Stddev: 49.972
>> Percentiles:  90th: 141.000; 95th: 182.000; 99th: 287.000
>
>> Count: 5013
>> Range: 10.000 - 8303.000; Mean: 28.505; Median: 18.000; Stddev: 119.147
>> Percentiles:  90th: 49.000; 95th: 74.000; 99th: 115.000
>
> Where'd the giant increase in the range max come from?  Just jittery
> measurement?  Maybe get a lot more data points to smooth that out?

Correct, just jittery.

>
>> +static int key_search(struct extent_buffer *b, struct btrfs_key *key,
>> +                   int level, int *prev_cmp, int *slot)
>> +{
>> +     char *kaddr = NULL;
>> +     unsigned long map_start = 0;
>> +     unsigned long map_len = 0;
>> +     unsigned long offset;
>> +     struct btrfs_disk_key *k = NULL;
>> +     struct btrfs_disk_key unaligned;
>> +     int err;
>> +
>> +     if (*prev_cmp != 0) {
>> +             *prev_cmp = bin_search(b, key, level, slot);
>> +             return *prev_cmp;
>> +     }
>
>
>> +     *slot = 0;
>> +
>> +     return 0;
>
> So this is the actual work done by the function.

Correct. That and the very first if statement in the function.

>
>> +
>> +     if (level == 0)
>> +             offset = offsetof(struct btrfs_leaf, items);
>> +     else
>> +             offset = offsetof(struct btrfs_node, ptrs);
>
> (+10 fragility points for assuming that the key starts each struct
> instead of using [0].key)

Ok. I just copied that from ctree.c:bin_search(). I guess that gives
another +10 fragility points.
Thanks for pointing out.

>
>> +
>> +     err = map_private_extent_buffer(b, offset, sizeof(struct btrfs_disk_key),
>> +                                     &kaddr, &map_start, &map_len);
>> +     if (!err) {
>> +             k = (struct btrfs_disk_key *)(kaddr + offset - map_start);
>> +     } else {
>> +             read_extent_buffer(b, &unaligned, offset, sizeof(unaligned));
>> +             k = &unaligned;
>> +     }
>> +
>> +     ASSERT(comp_keys(k, key) == 0);
>
> All of the rest of the function, including most of the local variables,
> is overhead for that assertion.  We don't actually care about the
> relative sorted key position of the two keys so we don't need smart
> field-aware comparisions.  We can use a dumb memcmp.
>
> We can replace all that stuff with two easy memcmp_extent_buffers()
> which vanish if ASSERT is a nop.
>
>         if (level)
>                 ASSERT(!memcmp_extent_buffer(b, key,
>                         offsetof(struct btrfs_node, ptrs[0].key),
>                         sizeof(*key)));
>         else
>                 ASSERT(!memcmp_extent_buffer(b, key,
>                         offsetof(struct btrfs_leaf, items[0].key),
>                         sizeof(*key)));
>
> Right?

No, and as Josef just pointed, like that we compare a btrfs_key with a
btrfs_disk_key, which is wrong due to endianess differences.

So I'll go for Josef's suggestion in the following mail about wrapping
stuff with a CONFIG_BTRFS_ASSERT #ifdef macro.

>
> - z



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
