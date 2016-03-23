Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44686 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753362AbcCWC0F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 22:26:05 -0400
Subject: Re: [PATCH v8 00/27][For 4.7] Btrfs: Add inband (write time)
 de-duplication framework
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160322133812.GK8095@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56F1FEAF.2070806@cn.fujitsu.com>
Date: Wed, 23 Mar 2016 10:25:51 +0800
MIME-Version: 1.0
In-Reply-To: <20160322133812.GK8095@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for your interest in dedupe patchset first.

In fact I'm quite afraid if there is no one interest in the patchset, it 
may be delayed again to 4.8.

David Sterba wrote on 2016/03/22 14:38 +0100:
> On Tue, Mar 22, 2016 at 09:35:25AM +0800, Qu Wenruo wrote:
>> This updated version of inband de-duplication has the following features:
>> 1) ONE unified dedup framework.
>> 2) TWO different back-end with different trade-off
>
> The on-disk format is defined in code, would be good to give some
> overview here.

No problem at all.
(Although not sure if it's a good idea to explain it in mail. Maybe wiki 
is much better?)

There are 3 dedupe related on-disk items.

1) dedupe status
    Used by both dedupe backends. Mainly used to record the dedupe
    backend info, allowing btrfs to resume its dedupe setup after umount.

Key contents:
    Objectid             , Type                   , Offset
   (0                    , DEDUPE_STATUS_ITEM_KEY , 0      )

Structure contents:
   dedupe block size:     records dedupe block size
   limit_nr:              In-memory hash limit
   hash_type:             Only SHA256 is possible yet
   backend:               In-memory or on-disk

2) dedupe hash item
    The main item for on-disk dedupe backend.
    It's used for hash -> extent search.
    Duplicated hash won't be inserted into dedupe tree.

Key contents:
    Objectid            , Type                   , Offset
   (Last 64bit of hash  , DEDUPE_HASH_ITEM_KEY   , Bytenr of the extent)

Structure contents:
   len:                   The in-memory length of the extent
                          Should always match dedupe_bs.
   disk_len:              The on-disk length of extent, diffs with len
                          if the extent is compressed.
   compression:           Compression algorithm.
   hash:                  Complete hash(SHA256) of the extent, including
                          the last  64 bit

   The structure is a simplified file extent with hash, offset are
   removed.

3) dedupe bytenr item
    Helper structure, mainly used for extent -> hash lookup, used by
    extent freeing.
    1 on 1 mapping with dedupe hash item.

Key contents:
    Objectid       , Type                       , Offset
   (Extent bytenr  , DEDUPE_HASH_BYTENR_ITEM_KEY, Last 64 bit of hash)

Structure contents:
   Hash:                 Complete hash(SHA256) of the extent.

>
>> 3) Support compression with dedupe
>> 4) Ioctl interface with persist dedup status
>
> I'd like to see the ioctl specified in more detail. So far there's
> enable, disable and status. I'd expect some way to control the in-memory
> limits, let it "forget" current hash cache, specify the dedupe chunk
> size, maybe sync of the in-memory hash cache to disk.

So current and planned ioctl should be the following, with some details 
related to your in-memory limit control concerns.

1) Enable
    Enable dedupe if it's not enabled already. (disabled -> enabled)
    Or change current dedupe setting to another. (re-configure)

    For dedupe_bs/backend/hash algorithm(only SHA256 yet) change, it
    will disable dedupe(dropping all hash) and then enable with new
    setting.

    For in-memory backend, if only limit is different from previous
    setting, limit can be changed on the fly without dropping any hash.

2) Disable
    Disable will drop all hash and delete the dedupe tree if it exists.
    Imply a full sync_fs().

3) Status
    Output basic status of current dedupe.
    Including running status(disabled/enabled), dedupe block size, hash
    algorithm, and limit setting for in-memory backend.

4) (PLANNED) In-memory hash size querying
    Allowing userspace to query in-memory hash structure header size.
    Used for "btrfs dedupe enable" '-l' option to output warning if user
    specify memory size larger than 1/4 of the total memory.

5) (PLANNED) Dedeup rate statistics
    Should be handy for user to know the dedupe rate so they can further
    fine tuning their dedup setup.

So for your "in-memory limit control", just enable it with different limit.
For "dedupe block size change", just enable it with different dedupe_bs.
For "forget hash", just disable it.

And for "write in-memory hash onto disk", not planned and may never do 
it due to the complexity, sorry.

>
>> 5) Ability to disable dedup for given dirs/files
>
> This would be good to extend to subvolumes.

I'm sorry that I didn't quite understand the difference.
Doesn't dir includes subvolume?

Or xattr for subvolume is only restored in its parent subvolume, and 
won't be copied for its snapshot?

>
>> TODO:
>> 1) Add extent-by-extent comparison for faster but more conflicting algorithm
>>     Current SHA256 hash is quite slow, and for some old(5 years ago) CPU,
>>     CPU may even be a bottleneck other than IO.
>>     But for faster hash, it will definitely cause conflicts, so we need
>>     extent comparison before we introduce new dedup algorithm.
>
> If sha256 is slow, we can use a less secure hash that's faster but will
> do a full byte-to-byte comparison in case of hash collision, and
> recompute sha256 when the blocks are going to disk. I haven't thought
> this through, so there are possibly details that could make unfeasible.

Not exactly. If we are using unsafe hash, e.g MD5, we will use MD5 only 
for both in-memory and on-disk backend. No SHA256 again.

In that case, for MD5 hit case, we will do a full byte-to-byte 
comparison. It may be slow or fast, depending on the cache.

But at least for MD5 miss case, it should be faster than SHA256.

>
> The idea is to move expensive hashing to the slow IO operations and do
> fast but not 100% safe hashing on the read/write side where performance
> matters.

Yes, although on the read side, we don't perform hash, we only do hash 
at write side.
And in that case, if weak hash hit, we will need to do memory 
comparison, which may also be slow.
So the performance impact may still exist.

The biggest challenge is, we need to read (decompressed) extent 
contents, even without an inode.
(So, no address_space and all the working facilities)

Considering the complexity and uncertain performance improvement, the 
priority of introducing weak hash is quite low so far, not to mention a 
lot of detail design change for it.

A much easier and practical enhancement is, to use SHA512.
As it's faster than SHA256 on modern 64bit machine for larger size.
For example, for hashing 8K data, SHA512 is almost 40% faster than SHA256.

>
>> 2) Misc end-user related helpers
>>     Like handy and easy to implement dedup rate report.
>>     And method to query in-memory hash size for those "non-exist" users who
>>     want to use 'dedup enable -l' option but didn't ever know how much
>>     RAM they have.
>
> That's what we should try know and define in advance, that's part of the
> ioctl interface.
>
> I went through the patches, there are a lot of small things to fix, but
> first I want to be sure about the interfaces, ie. on-disk and ioctl.

I hope such small things can be pointed out, allowing me to fix them 
while rebasing.

>
> Then we can start to merge the patchset in smaller batches, the
> in-memory deduplication does not have implications on the on-disk
> format, so it's "just" the ioctl part.

Yes, that's my original plan, first merge simple in-memory backend into 
4.5/4.6 and then adding ondisk backend into 4.7.

But things turned out that, since we designed the two-backends API from 
the beginning, on-disk backend doesn't take much time to implement.

So this makes what you see now, a big patchset with both backend 
implemented.

>
> The patches at the end of the series fix bugs introduced within the same
> series, these should be folded to the patches that are buggy.

I'll fold them in next version.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


