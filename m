Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BC6C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 01:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2F632147C
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 01:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfCSBOS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 21:14:18 -0400
Received: from syrinx.knorrie.org ([82.94.188.77]:43000 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfCSBOR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 21:14:17 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 4347A3EEFB1C3;
        Tue, 19 Mar 2019 02:14:11 +0100 (CET)
Subject: Re: [PATCH 1/1] btrfs-progs: fi usage: implement raid56
To:     =?UTF-8?Q?St=c3=a9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
Cc:     linux-btrfs@vger.kernel.org
References: <20190317125150.26265-1-stephane_btrfs@lesimple.fr>
 <20190317125150.26265-2-stephane_btrfs@lesimple.fr>
 <d74a1afe-b218-25f9-97f1-43315e9590cf@knorrie.org>
 <9fb1f7ffe56acda248a64103c2a4bda8@lesimple.fr>
From:   Hans van Kranenburg <hans@knorrie.org>
Openpgp: preference=signencrypt
Autocrypt: addr=hans@knorrie.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <903cf670-29a7-fd6a-b6d0-bbf9556425fc@knorrie.org>
Date:   Tue, 19 Mar 2019 02:14:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <9fb1f7ffe56acda248a64103c2a4bda8@lesimple.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

Thanks for your explanations. Also, I want to explicitly say it's great
you're working on this. If I sounded like complaining, it seems it was
about the already existing code (the variable names).

So...

On 3/18/19 8:41 PM, Stéphane Lesimple wrote:
> Hi Hans,
> 
> Le 2019-03-18 00:23, Hans van Kranenburg a écrit :
>> Hi,
>>
>> On 3/17/19 1:51 PM, stephane_btrfs@lesimple.fr wrote:
>>> From: Stéphane Lesimple <stephane_btrfs@lesimple.fr>
>>>
>>> Implement RAID5 and RAID6 support in `filesystem usage'.

In the commit message, a high level "bullet point" overview of what
changed would be useful. Like, what were the flaws, and what algorithm
choice does deal with it better?

I'm currently trying to understand the original code, and then the new
code, and then trying to reverse engineer what they do different.

Something like:
* The old code presented X by looking at P and then multiplying it with
S. This is obviously wrong, because then we ignore T. Instead, divide it
by R, so that we never end up with W.
* By adding U, we are suddenly able to also calculate G, which is very
useful but was missing before. Yay!

>>>
>>> Before:
>>>> WARNING: RAID56 detected, not implemented
>>>> WARNING: RAID56 detected, not implemented
>>>> WARNING: RAID56 detected, not implemented
>>>>      Device allocated:     0.00B
>>>>      Device unallocated:   2.04GiB
>>>>      Used:                 0.00B
>>>>      Free (estimated):     0.00B      (min: 8.00EiB)
>>>>      Data ratio:           0.00
>>>>      Metadata ratio:       0.00
>>>
>>> After:
>>>>      Device allocated:     1.83GiB
>>>>      Device unallocated:   211.50MiB
>>>>      Used:                 1.83GiB
>>>>      Free (estimated):     128.44MiB  (min: 128.44MiB)
>>>>      Data ratio:           1.65
>>>>      Metadata ratio:       1.20
>>>
>>> Note that this might need some fine-tuning for mixed mode.
>>>
>>> We may also overestimate the free space incorrectly in
>>> some complex disk configurations, i.e. when some of the
>>> unallocated space is in fact unallocatable because the
>>> redundancy profile requisites can't be matched with how
>>> the remaining unallocated space is distributed over the
>>> devices. This is not specific to raid56 and also happens
>>> with other raid profiles, it'll need to be taken care of
>>> separately.
>>>
>>> Signed-off-by: Stéphane Lesimple <stephane_btrfs@lesimple.fr>
>>> ---
>>>  cmds-fi-usage.c | 96 ++++++++++++++++++++++++++++++-------------------
>>>  1 file changed, 60 insertions(+), 36 deletions(-)
>>>
>>> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
>>> index 9a23e176..baa1ff89 100644
>>> --- a/cmds-fi-usage.c
>>> +++ b/cmds-fi-usage.c
>>> @@ -280,28 +280,6 @@ static struct btrfs_ioctl_space_args
>>> *load_space_info(int fd, const char *path)
>>>      return sargs;
>>>  }
>>>
>>> -/*
>>> - * This function computes the space occupied by a *single*
>>> RAID5/RAID6 chunk.
>>> - * The computation is performed on the basis of the number of stripes
>>> - * which compose the chunk, which could be different from the number
>>> of devices
>>> - * if a disk is added later.
>>> - */
>>> -static void get_raid56_used(struct chunk_info *chunks, int chunkcount,
>>> -        u64 *raid5_used, u64 *raid6_used)
>>> -{
>>> -    struct chunk_info *info_ptr = chunks;
>>> -    *raid5_used = 0;
>>> -    *raid6_used = 0;
>>> -
>>> -    while (chunkcount-- > 0) {
>>> -        if (info_ptr->type & BTRFS_BLOCK_GROUP_RAID5)
>>> -            (*raid5_used) += info_ptr->size / (info_ptr->num_stripes
>>> - 1);
>>> -        if (info_ptr->type & BTRFS_BLOCK_GROUP_RAID6)
>>> -            (*raid6_used) += info_ptr->size / (info_ptr->num_stripes
>>> - 2);
>>> -        info_ptr++;
>>> -    }
>>> -}
>>> -
>>>  #define    MIN_UNALOCATED_THRESH    SZ_16M
>>>  static int print_filesystem_usage_overall(int fd, struct chunk_info
>>> *chunkinfo,
>>>          int chunkcount, struct device_info *devinfo, int devcount,
>>> @@ -331,13 +309,15 @@ static int print_filesystem_usage_overall(int
>>> fd, struct chunk_info *chunkinfo,
>>>      double data_ratio;
>>>      double metadata_ratio;
>>>      /* logical */
>>> -    u64 raid5_used = 0;
>>> -    u64 raid6_used = 0;
>>> +    u64 r_data_raid56_chunks = 0;
>>> +    u64 l_data_raid56_chunks = 0;
>>> +    u64 r_metadata_raid56_chunks = 0;
>>> +    u64 l_metadata_raid56_chunks = 0;
>>
>> Can you explain what r and l mean? I have been staring at the code and
>> reading back and forth for some time, but I still really have no idea.
> 
> I've tried to stick with the naming convention of the other variables
> used in this function. Some lines above this diff, you'll find the
> following
> comment in the original file, followed by some vars declarations:
> 
> /*
>  * r_* prefix is for raw data
>  * l_* is for logical
>  */
>  [...]
>  u64 r_data_used = 0;
>  u64 r_data_chunks = 0;
>  u64 l_data_chunks = 0;
>  u64 r_metadata_used = 0;
>  u64 r_metadata_chunks = 0;
>  u64 l_metadata_chunks = 0;
> 
> This is why I've also named my vars this way.
> If you take for example a chunk with a raid1 replication policy, its
> real (r_) used size will be 2G, and its logical (l_) size will be 1G.

Aha. So, for me using names like these make the code pretty hard to
follow, because, yes, data_chunks reads as "this counts the amount of
chunks", and then r_chunks and l_chunks seem like the amount of chunks
on the right disk and on the left disk. But, I should have read the
context first, before complaining, yes.

>>>      u64 l_global_reserve = 0;
>>>      u64 l_global_reserve_used = 0;
>>>      u64 free_estimated = 0;
>>>      u64 free_min = 0;
>>> -    int max_data_ratio = 1;
>>> +    double max_data_ratio = 1;
>>>      int mixed = 0;
>>>
>>>      sargs = load_space_info(fd, path);
>>> @@ -359,24 +339,29 @@ static int print_filesystem_usage_overall(int
>>> fd, struct chunk_info *chunkinfo,
>>>          ret = 1;
>>>          goto exit;
>>>      }
>>> -    get_raid56_used(chunkinfo, chunkcount, &raid5_used, &raid6_used);
>>>
>>>      for (i = 0; i < sargs->total_spaces; i++) {
>>>          int ratio;
>>>          u64 flags = sargs->spaces[i].flags;
>>>
>>> +        if ((flags & (BTRFS_BLOCK_GROUP_DATA |
>>> BTRFS_BLOCK_GROUP_METADATA))
>>> +            == (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA)) {
>>> +            mixed = 1;
>>> +        }
>>> +
>>>          /*
>>>           * The raid5/raid6 ratio depends by the stripes number
>>> -         * used by every chunk. It is computed separately
>>> +         * used by every chunk. It is computed separately,
>>> +         * after we're done with this loop, so skip those.
>>>           */
>>>          if (flags & BTRFS_BLOCK_GROUP_RAID0)
>>>              ratio = 1;
>>>          else if (flags & BTRFS_BLOCK_GROUP_RAID1)
>>>              ratio = 2;
>>>          else if (flags & BTRFS_BLOCK_GROUP_RAID5)
>>> -            ratio = 0;
>>> +            continue;
>>>          else if (flags & BTRFS_BLOCK_GROUP_RAID6)
>>> -            ratio = 0;
>>> +            continue;
>>>          else if (flags & BTRFS_BLOCK_GROUP_DUP)
>>>              ratio = 2;
>>>          else if (flags & BTRFS_BLOCK_GROUP_RAID10)
>>> @@ -384,9 +369,6 @@ static int print_filesystem_usage_overall(int fd,
>>> struct chunk_info *chunkinfo,
>>>          else
>>>              ratio = 1;
>>>
>>> -        if (!ratio)
>>> -            warning("RAID56 detected, not implemented");
>>> -
>>>          if (ratio > max_data_ratio)
>>>              max_data_ratio = ratio;
>>>
>>> @@ -394,10 +376,6 @@ static int print_filesystem_usage_overall(int
>>> fd, struct chunk_info *chunkinfo,
>>>              l_global_reserve = sargs->spaces[i].total_bytes;
>>>              l_global_reserve_used = sargs->spaces[i].used_bytes;
>>>          }
>>> -        if ((flags & (BTRFS_BLOCK_GROUP_DATA |
>>> BTRFS_BLOCK_GROUP_METADATA))
>>> -            == (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA)) {
>>> -            mixed = 1;
>>> -        }
>>>          if (flags & BTRFS_BLOCK_GROUP_DATA) {
>>>              r_data_used += sargs->spaces[i].used_bytes * ratio;
>>>              r_data_chunks += sargs->spaces[i].total_bytes * ratio;
>>> @@ -414,6 +392,52 @@ static int print_filesystem_usage_overall(int
>>> fd, struct chunk_info *chunkinfo,
>>>          }
>>>      }
>>>
>>> +    /*
>>> +     * Here we compute the space occupied by every RAID5/RAID6 chunks.
>>> +     * The computation is performed on the basis of the number of
>>> stripes
>>> +     * which compose each chunk, which could be different from the
>>> number of devices
>>> +     * if a disk is added later, or if the disks are of different
>>> sizes..
>>> +     */
>>> +    struct chunk_info *info_ptr;
>>> +    for (info_ptr = chunkinfo, i = chunkcount; i > 0; i--,
>>> info_ptr++) {
>>> +        int flags = info_ptr->type;
>>> +        int nparity;
>>> +
>>> +        if (flags & BTRFS_BLOCK_GROUP_RAID5) {
>>> +            nparity = 1;
>>> +        }
>>> +        else if (flags & BTRFS_BLOCK_GROUP_RAID6) {
>>> +            nparity = 2;
>>> +        }
>>> +        else {
>>> +            // We're only interested in raid56 here
>>> +            continue;
>>> +        }
>>
>> I interpret the else continue as "ok, so apparently we can hit these
>> lines of code for other stuff than RAID56", which is expected and fine,
>> and then we'll silently ignore it.
> 
> Yes, this for() loop will be entered in any case, because the replication
> policy (raid5 or raid1) is not a property of the filesystem as a whole,
> it's a property of a chunk. So you can have in the same filesystem, some
> chunks with raid1 replication policy, and some others in raid5.
> This can happen if, for example, you start a balance with -dconvert=raid5
> on a previously raid1-only filesystem, and stop it after a few chunks have
> been converted. This is perfectly valid from a btrfs standpoint.
> 
> So, this for() loop's job is to go trough each chunkinfo and process only
> the raid5/raid6 ones, because for the other replication profiles, this is
> already handled by the code above this for(), asfor every profile
> except raid5/raid6, one don't need to go through each chunk: for raid1 we
> know that the ratio is exactly 2, because that's the very definition of
> btrfs-raid1. For raid5/6 on the other hand, it depends on the number of
> slices the chunk has, and this can change over time (as disks are added,
> or if disks are not of the same size).
> 
>> But, in that case the value of nparity is not initialized and the lines
>> below seem like this part of the code is actually never executed for
>> anything that's not RAID56, so why the else up here? Or, maube print a
>> big error or crash the program, if the else never should happen?
> 
> Actually, the else is there to just go check the next chunk in case the
> one we're
> working on is not raid5 or raid6, because this for() loop only counts the
> number of bytes in raid5/raid6 chunks (to later be able to compute the
> ratio).
> We just want to skip all the others (they've already been handled by
> preexisting
> code).

Oh, right. I'm stupid. Continue skips the rest of the part of the for
loop, yes.

> Also, as nparity is only used if we're inspecting a raid5/6 chunk,
> there shouldn't be a case where it is referenced and not initialized
> AFAICT.
> 
>>
>>> +
>>> +        if (flags & BTRFS_BLOCK_GROUP_DATA) {
>>> +            r_data_raid56_chunks += info_ptr->size /
>>> (info_ptr->num_stripes - nparity);
>>
>> Ah, so this is the calculation of device extent size. Still wondering
>> what the r would mean.
> 
> here, we're counting the number of bytes used by raid5 or raid6 chunks,
> physically
> on the devices.

The calculation computes the device extent length (which is in btrfs
terminology the same as length of "a stripe"). So after you find out the
dev_extent length, it needs to be multiplied by the num_stripes of the
chunk to get the total amount of raw bytes that are allocated.

If you have 6 disks, and a 5GiB RAID5 chunk with 6x 1GiB dev_extent on 6
disks, then it looks like the above is just adding 1GiB instead of 6GiB?

And that way of calculating that is only valid for RAID56 instead,
because it ignores ncopies (about which more in a bit).

>>> +            l_data_raid56_chunks += info_ptr->size /
>>> info_ptr->num_stripes;
>>
>> I still don't understand what meaning this has. Chunk length divided by
>> num_stripes (with parity)...
>>
>> A variable named data_raid56_chunks tells me that you are counting the
>> amount of chunks that have type DATA and profile RAID5 or RAID6, but
>> this code is doing something really different, it's counting bytes. But
>> what sort of bytes...
> 
> It's a bit misleading indeed, actually a previous version of my patch had
> this variable named "r_data_raid56_size", but I noticed that in preexisting
> code, "r_data_chunks" is used to count the number of bytes (and not
> number of
> chunks) used by non-raid5/6 chunks, as you can see:

What I mean is, the number that you get when chunk size (length) is
divided by num_stripes doesn't really have a useful meaning because of
parity that's also there.

If l_data_raid56_chunks counts the logical/virtual bytes that are
available to be used, then that's just chunk size itself?

Or are these r/l_data_raid56_chunks counting things for only a single
disk? I don't get that idea from the code.

> r_data_chunks += sargs->spaces[i].total_bytes * ratio;

The ratio thing works if there's an easy translation between chunk size
and the total amount of raw allocated bytes for that chunk.

Ahh... I get a flash back now. Actually, I went through all of this a
few months ago when writing the usage report module in python-btrfs.

If you have nparity, then you can get rid of the whole ratio thing, and
make a more generic thing that works for everything.

The 'ratio' code is probably from the time before RAID56 was added, and
at that time everything was simple. When RAID56 was introduced it became
more complex and instead of fixing it properly the extra functions and
if statements were ducttaped on top.

> And a similar line for the "l_" variant:
> 
> l_data_chunks += sargs->spaces[i].total_bytes;
> 
> So I've renamed my variables to stick with this naming usage.
> 
>>> +        }
>>> +        if (flags & BTRFS_BLOCK_GROUP_METADATA) {
>>> +            r_metadata_raid56_chunks += info_ptr->size /
>>> (info_ptr->num_stripes - nparity);
>>> +            l_metadata_raid56_chunks += info_ptr->size /
>>> info_ptr->num_stripes;
>>> +        }
>>> +    }
>>> +
>>> +    if (l_data_raid56_chunks > 0) {
>>> +        double ratio = (double)r_data_raid56_chunks /
>>> l_data_raid56_chunks;
>>> +        r_data_used += r_data_raid56_chunks;
>>> +        r_data_chunks += r_data_raid56_chunks;
>>> +        l_data_chunks += l_data_raid56_chunks;
>>> +        if (ratio > max_data_ratio)
>>> +            max_data_ratio = ratio;
>>> +    }
>>> +    if (l_metadata_raid56_chunks > 0) {
>>> +        r_metadata_used += r_metadata_raid56_chunks;
>>> +        r_metadata_chunks += r_metadata_raid56_chunks;
>>> +        l_metadata_chunks += l_metadata_raid56_chunks;
>>> +    }
>>> +
>>>      r_total_chunks = r_data_chunks + r_system_chunks;
>>>      r_total_used = r_data_used + r_system_used;
>>>      if (!mixed) {
>>>
>>
>> I'm not a super-experienced C coder, but I can read C and write patches
>> while looking at the history of the code in some place, and following
>> patterns. What I'm throwing at you here is some feedback about
>> readability. I'd like to help reviewing this, but I can't really
>> understand it.
> 
> Thanks for your time reviewing this patch, and in any case I hope I've shed
> some light on what it does exactly! Please don't hesitate to comment back
> if anything is still not clear!

nparity is actually a thing. Having it makes it possible to add more
generic translation helper functions between chunk length and device
extent length (aka stripe size).

I wanted to add this in my code...

https://github.com/knorrie/python-btrfs/commit/4525d1e38c19ad8bce38bff7301934998764883c

...so I proposed to also add the same thing in the kernel code, which
immediately already caused getting rid of an ugly if block...

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b50836edf9fe531c66310071df59eac2d8dfc708

Now I see that progs has a copy of all of this, and I should have sent
patches for that also, and also for this one, which still has the old
incorrect values in progs:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=da612e31aee51bd13231c78a47c714b543bd3ad8

If ncopies and nparity have the correct values, then you can make a few
helper functions which replace the whole ratio thing and the raid56
exceptions and make all of the code simpler, like, translating chunk
length to dev extent length and back, which works identical for all
profiles.

Feel free to steal all of the above things in the python code and port
it to C.

Also notice that btrfs naming for things is wildly different and
confusing for whoever knows common RAID terminology. This makes it even
harder for people with related knowledge in the industry to read btrfs
code, because it continuously seems to be doing other things than you
expect.

"normal" RAID:
 * stripe: a horizontal collection of data + parity chunks
 * chunk: the part on 1 disk of a complete stripe

btrfs:
 * chunk: some amount of virtual address space. When translated to the
total amount of physical bytes, this would be similar to a "normal" stripe.
 * stripe: the part on 1 disk of the total physical space occupied by a
btrfs chunk, so similar to a "normal" chunk.

So, it's like, the exact opposite thing, but using the same names.

Hans
