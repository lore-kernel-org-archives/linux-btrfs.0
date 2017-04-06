Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35909 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754710AbdDFQHd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Apr 2017 12:07:33 -0400
Received: by mail-it0-f65.google.com with SMTP id a140so4801159ita.3
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Apr 2017 09:07:33 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <9c106d93-9dd8-5377-dba3-d0b41c6b144e@cn.fujitsu.com>
References: <1488943097-20914-1-git-send-email-zblaxell@waya.furryterror.org>
 <CAL3q7H4T29nKOBR5DJC47C-hx-Bcgas1sHeLc4aC8GVDK005MQ@mail.gmail.com>
 <20170309020509.GA31830@hungrycats.org> <9c106d93-9dd8-5377-dba3-d0b41c6b144e@cn.fujitsu.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 6 Apr 2017 17:07:31 +0100
Message-ID: <CAL3q7H6BRA2rKERSLRKcNgrysmufhPj_7hCPGWn36i+yNNgdwg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: add missing memset while reading compressed inline extents
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 22, 2017 at 2:37 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 03/09/2017 10:05 AM, Zygo Blaxell wrote:
>>
>> On Wed, Mar 08, 2017 at 10:27:33AM +0000, Filipe Manana wrote:
>>>
>>> On Wed, Mar 8, 2017 at 3:18 AM, Zygo Blaxell
>>> <zblaxell@waya.furryterror.org> wrote:
>>>>
>>>> From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
>>>>
>>>> This is a story about 4 distinct (and very old) btrfs bugs.
>>>>
>>>> Commit c8b978188c ("Btrfs: Add zlib compression support") added
>>>> three data corruption bugs for inline extents (bugs #1-3).
>>>>
>>>> Commit 93c82d5750 ("Btrfs: zero page past end of inline file items")
>>>> fixed bug #1:  uncompressed inline extents followed by a hole and more
>>>> extents could get non-zero data in the hole as they were read.  The fix
>>>> was to add a memset in btrfs_get_extent to zero out the hole.
>>>>
>>>> Commit 166ae5a418 ("btrfs: fix inline compressed read err corruption")
>>>> fixed bug #2:  compressed inline extents which contained non-zero bytes
>>>> might be replaced with zero bytes in some cases.  This patch removed an
>>>> unhelpful memset from uncompress_inline, but the case where memset is
>>>> required was missed.
>>>>
>>>> There is also a memset in the decompression code, but this only covers
>>>> decompressed data that is shorter than the ram_bytes from the extent
>>>> ref record.  This memset doesn't cover the region between the end of the
>>>> decompressed data and the end of the page.  It has also moved around a
>>>> few times over the years, so there's no single patch to refer to.
>>>>
>>>> This patch fixes bug #3:  compressed inline extents followed by a hole
>>>> and more extents could get non-zero data in the hole as they were read
>>>> (i.e. bug #3 is the same as bug #1, but s/uncompressed/compressed/).
>>>> The fix is the same:  zero out the hole in the compressed case too,
>>>> by putting a memset back in uncompress_inline, but this time with
>>>> correct parameters.
>>>>
>>>> The last and oldest bug, bug #0, is the cause of the offending inline
>>>> extent/hole/extent pattern.  Bug #0 is a subtle and mostly-harmless
>>>> quirk
>>>> of behavior somewhere in the btrfs write code.  In a few special cases,
>>>> an inline extent and hole are allowed to persist where they normally
>>>> would be combined with later extents in the file.
>>>>
>>>> A fast reproducer for bug #0 is presented below.  A few offending
>>>> extents
>>>> are also created in the wild during large rsync transfers with the -S
>>>> flag.  A Linux kernel build (git checkout; make allyesconfig; make -j8)
>>>> will produce a handful of offending files as well.  Once an offending
>>>> file is created, it can present different content to userspace each
>>>> time it is read.
>>>>
>>>> Bug #0 is at least 4 and possibly 8 years old.  I verified every vX.Y
>>>> kernel back to v3.5 has this behavior.  There are fossil records of this
>>>> bug's effects in commits all the way back to v2.6.32.  I have no reason
>>>> to believe bug #0 wasn't present at the beginning of btrfs compression
>>>> support in v2.6.29, but I can't easily test kernels that old to be sure.
>>>>
>>>> It is not clear whether bug #0 is worth fixing.  A fix would likely
>>>> require injecting extra reads into currently write-only paths, and most
>>>> of the exceptional cases caused by bug #0 are already handled now.
>>>>
>>>> Whether we like them or not, bug #0's inline extents followed by holes
>>>> are part of the btrfs de-facto disk format now, and we need to be able
>>>> to read them without data corruption or an infoleak.  So enough about
>>>> bug #0, let's get back to bug #3 (this patch).
>>>>
>>>> An example of on-disk structure leading to data corruption:
>>>>
>>>>         item 61 key (606890 INODE_ITEM 0) itemoff 9662 itemsize 160
>>>>                 inode generation 50 transid 50 size 47424 nbytes 49141
>>>>                 block group 0 mode 100644 links 1 uid 0 gid 0
>>>>                 rdev 0 flags 0x0(none)
>>>>         item 62 key (606890 INODE_REF 603050) itemoff 9642 itemsize 20
>>>>                 inode ref index 3 namelen 10 name: DB_File.so
>>>>         item 63 key (606890 EXTENT_DATA 0) itemoff 8280 itemsize 1362
>>>>                 inline extent data size 1341 ram 4085 compress(zlib)
>>>>         item 64 key (606890 EXTENT_DATA 4096) itemoff 8227 itemsize 53
>>>>                 extent data disk byte 5367308288 nr 20480
>>>>                 extent data offset 0 nr 45056 ram 45056
>>>>                 extent compression(zlib)
>>>
>>>
>>> So this case is actually different from the reproducer below, because
>>> once a file has prealloc extents, future writes will never be
>>> compressed. That is, the extent at offset 4096 can not have compressed
>>> content using steps like the reproducer below. I can only imagine that
>>> after an falloc to create the extent at 4K, we cloned some compressed
>>> extent from some other file into that offset.
>>
>>
>> The above comes from one of my captures of the bug appearing in the wild,
>> not the reproducer from Liu Bo.  I'll make that clearer.
>
>
> In fact, I found that btrfs/137 with compress=lzo seems to trigger such
> "inline-then-regular" case in a very high possibility.
>
> If abort the test just after populating the fs, I found the possibility to
> have inline-then-regular extent layout is over 70%.

100%, as explained in your fstests patch thread.

>
> Although in btrfs/137 case, it's "inline-then-hole", not completely
> "inline-then-regular".

A hole is a regular extent with a disk byte number of 0.

>
> Hopes such reproducer can help to trace down the root cause.

Completely different case because the compressed inline extent
represents 4096 bytes of data. The issue from this thread requires the
uncompressed data size to be less than 4096 bytes.

thanks

>
> Thanks,
> Qu
>
>
>>
>> The "in-the-wild" cases come from an assortment of programs that do
>> write(<4K), seek(>4K), write.  99.999% (5 nines) of the time, that results
>> in a single non-inline extent, but the rest of the time the inline extent
>> persists.
>>
>> None of that changes what happens _after_ the inline extent and hole
>> are created and persisted on disk.  That's all I want to fix here.
>>
>>>> Different data appears in userspace during each read of the 11 bytes
>>>> between 4085 and 4096.  The extent in item 63 is not long enough to
>>>> fill the first page of the file, so a memset is required to fill the
>>>> space between item 63 (ending at 4085) and item 64 (beginning at 4096)
>>>> with zero.
>>>>
>>>> Here is a reproducer from Liu Bo:
>>>>
>>>> Using 'page_poison=on' kernel command line (or enable
>>>> CONFIG_PAGE_POISONING) run the following:
>>>>
>>>>         # touch foo
>>>>         # chattr +c foo
>>>>         # xfs_io -f -c "pwrite -W 0 1000" foo
>>>>         # xfs_io -f -c "falloc 4 8188" foo
>>>>         # od -x foo
>>>>         # echo 3 >/proc/sys/vm/drop_caches
>>>>         # od -x foo
>>>>
>>>> This produce the following on my box:
>>>>
>>>> 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
>>>> *
>>>> 0001740 cdcd cdcd cdcd cdcd 0000 0000 0000 0000
>>>> 0001760 0000 0000 0000 0000 0000 0000 0000 0000
>>>> *
>>>> 0020000
>>>
>>>
>>> For the sake of organization and making it easier to understand, it
>>> would help mention that the above hex dump is the expected (correct)
>>> output of od, while the one below is the incorrect one due the bug.
>>>
>>>>
>>>> 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
>>>> *
>>>> 0001740 cdcd cdcd cdcd cdcd 6c63 7400 635f 006d
>>>> 0001760 5f74 6f43 7400 435f 0053 5f74 7363 7400
>>>> 0002000 435f 0056 5f74 6164 7400 645f 0062 5f74
>>>> (...)
>>>>
>>>> v2: I'm not able to contrive a test case where pg_offset != 0, but we
>>>> might as well handle it anyway.
>>>
>>>
>>> Versioning information should go after the --- below, so that it
>>> doesn't appear in the changelog after the patch is picked (it's
>>> irrelevant information).
>>
>>
>> Will do.
>>
>>> Also, if the above example reproduces the problem, why not make a
>>> fstests test case with it?
>>
>>
>> ...beeeecause I'd have to finally have to stop putting off cloning
>> xfstests and figuring out how it works?  ;)
>>
>>>> Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
>>>> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
>>>> ---
>>>>  fs/btrfs/inode.c | 6 ++++++
>>>>  1 file changed, 6 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>> index 25ac2cf..4d41a31 100644
>>>> --- a/fs/btrfs/inode.c
>>>> +++ b/fs/btrfs/inode.c
>>>> @@ -6805,6 +6805,12 @@ static noinline int uncompress_inline(struct
>>>> btrfs_path *path,
>>>>         max_size = min_t(unsigned long, PAGE_SIZE, max_size);
>>>>         ret = btrfs_decompress(compress_type, tmp, page,
>>>>                                extent_offset, inline_size, max_size);
>>>> +       WARN_ON(max_size + pg_offset > PAGE_SIZE);
>>>> +       if (max_size + pg_offset < PAGE_SIZE) {
>>>> +               char *map = kmap(page);
>>>> +               memset(map + pg_offset + max_size, 0, PAGE_SIZE -
>>>> max_size - pg_offset);
>>>> +               kunmap(page);
>>>> +       }
>>>>         kfree(tmp);
>>>>         return ret;
>>>>  }
>>>> --
>>>> 2.1.4
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>>
>>> --
>>> Filipe David Manana,
>>>
>>> "People will forget what you said,
>>>  people will forget what you did,
>>>  but people will never forget how you made them feel."
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
