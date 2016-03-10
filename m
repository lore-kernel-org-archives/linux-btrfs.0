Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:33759 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895AbcCJLOk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 06:14:40 -0500
Received: by mail-yk0-f179.google.com with SMTP id z7so33628321yka.0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 03:14:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5RjjgsBpLrWpSAYGdw=TYf6Z=fOtBC39nxJZEi+-GhPw@mail.gmail.com>
References: <286C424321A6496789A866288933406A@alyakaslap>
	<CAL3q7H7f3wWtWQYy1mSjcMcYopKCtU0mxeeP3J_r74js9U26Yg@mail.gmail.com>
	<CAOcd+r21WT063Z15Sf1uhcdYDFupX3vgwL+C-3D7Q_Nqs1jE4Q@mail.gmail.com>
	<CAL3q7H5RjjgsBpLrWpSAYGdw=TYf6Z=fOtBC39nxJZEi+-GhPw@mail.gmail.com>
Date: Thu, 10 Mar 2016 13:14:39 +0200
Message-ID: <CAOcd+r2-4bmy40xewOvbicoMW_1gV2CZShEhQsYb7edQpsuxig@mail.gmail.com>
Subject: Re: [RFC - PATCH] btrfs: do not write corrupted metadata blocks to disk
From: Alex Lyakas <alex@zadarastorage.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Filipe,

I have sent two patches addressing this issue.

When testing, I discovered that log tree blocks can sometimes carry
chunk tree UUID which is all zeros! Does this make sense? You can take
a look at a small debug-tree output demonstrating such phenomenon at
https://drive.google.com/file/d/0B9rmyUifdvMLbHBuSWU5dlVKNWc. Due to
this I did not include the chunk tree UUID check. Hoping very much
that fs UUID should always be valid for all tree blocks))

Thanks,
Alex.



On Mon, Feb 22, 2016 at 12:28 PM, Filipe Manana <fdmanana@kernel.org> wrote:
> On Mon, Feb 22, 2016 at 9:46 AM, Alex Lyakas <alex@zadarastorage.com> wrote:
>> Thank you, Filipe, for your review.
>>
>> On Mon, Feb 22, 2016 at 3:05 AM, Filipe Manana <fdmanana@kernel.org> wrote:
>>> On Sun, Feb 21, 2016 at 3:36 PM, Alex Lyakas <alex@zadarastorage.com> wrote:
>>>> csum_dirty_buffer was issuing a warning in case the extent buffer
>>>> did not look alright, but was still returning success.
>>>> Let's return error in this case, and also add two additional sanity
>>>> checks on the extent buffer header.
>>>>
>>>> We had btrfs metadata corruption, and after looking at the logs we saw
>>>> that WARN_ON(found_start != start) has been triggered. We are still
>>>> investigating
>>>
>>> There's a warning for WARN_ON(found_start != start || !PageUptodate(page))
>>>
>>> Are you sure it triggered only because of found_start != start and not
>>> because of !PageUptodate(page) (or both)?
>> The problem initially happened on kernel 3.8.13.  In this kernel, the
>> code looks like this:
>>          found_start = btrfs_header_bytenr(eb);
>>          if (found_start != start) {
>>                  WARN_ON(1);
>>                  return 0;
>>          }
>>          if (!PageUptodate(page)) {
>>                  WARN_ON(1);
>>                  return 0;
>>          }
>> (You can see it on
>> http://lxr.free-electrons.com/source/fs/btrfs/disk-io.c?v=3.8#L420)
>> The WARN_ON that we hit was on the found_start comparison.
>
> Ok, I see now that one of those useless cleanup patches merged both
> conditions into a single if some time ago.
>
>>
>>>
>>>> which component trashed the cache page which belonged to btrfs. But btrfs
>>>> only issued a warning, and as a result, the corrupted metadata block went to
>>>> disk.
>>>>
>>>> I think we should return an error in such case that the extent buffer
>>>> doesn't look alright.
>>>
>>> I think so too.
>>>
>>>> The caller up the chain may BUG_ON on this, for example flush_epd_write_bio
>>>> will,
>>>> but it is better than to have a silent metadata corruption on disk.
>>>>
>>>> Note: this patch has been properly tested on 3.18 kernel only.
>>>>
>>>> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
>>>> ---
>>>> fs/btrfs/disk-io.c | 14 ++++++++++++--
>>>> 1 file changed, 12 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index 4545e2e..701e706 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -508,22 +508,32 @@ static int csum_dirty_buffer(struct btrfs_fs_info
>>>> *fs_info, struct page *page)
>>>> {
>>>>     u64 start = page_offset(page);
>>>>     u64 found_start;
>>>>     struct extent_buffer *eb;
>>>>
>>>>     eb = (struct extent_buffer *)page->private;
>>>>     if (page != eb->pages[0])
>>>>         return 0;
>>>>     found_start = btrfs_header_bytenr(eb);
>>>>     if (WARN_ON(found_start != start || !PageUptodate(page)))
>>>> -        return 0;
>>>> -    csum_tree_block(fs_info, eb, 0);
>>>> +        return -EUCLEAN;
>>>> +#ifdef CONFIG_BTRFS_ASSERT
>>>
>>> A bit odd to surround these with CONFIG_BTRFS_ASSERT if we don't do assertions.
>>> I would remove this #ifdef ... #endif or do the memcmp calls inside ASSERT().
>> Agreed.
>>
>>>
>>>> +    if (WARN_ON(memcmp_extent_buffer(eb, fs_info->fsid,
>>>> +                    (unsigned long)btrfs_header_fsid(), BTRFS_FSID_SIZE)))
>>>> +        return -EUCLEAN;
>>>> +    if (WARN_ON(memcmp_extent_buffer(eb, fs_info->fsid,
>>>> +                    (unsigned long)btrfs_header_chunk_tree_uuid(eb),
>>>> +                    BTRFS_FSID_SIZE)))
>>>
>>> This second comparison doesn't seem correct. Second argument to
>>> memcmp_extent_buffer should be fs_info->chunk_tree_uuid, which
>>> shouldn't be the same as the fsid (take a look at utils.c:make_btrfs()
>>> in the tools, both uuids are generated by different calls to
>>> uuid_generate()) - did you make your tests only before adding this
>>> comparison?. Also you should use BTRFS_UUID_SIZE instead of
>>> BTRFS_FSID_SIZE (even if both have the same value).
>> Obviously, you are right. In the 3.18-based code that I fixed locally
>> here, the fix looks like this:
>>
>>     if (found_start != start) {
>>         ZBTRFS_WARN(1, "FS[%s]: header_bytenr(eb)(%llu) !=
>> page->index<<PAGE_CACHE_SHIFT(%llu)", root->fs_info->sb->s_id,
>> found_start, start);
>>         return -EUCLEAN;
>>     }
>>     if (!PageUptodate(page)) {
>>         ZBTRFS_WARN(1, "FS[%s]: eb bytenr=%llu page->index(%llu)
>> !PageUptodate", root->fs_info->sb->s_id, start, (u64)page->index);
>>         return -EUCLEAN;
>>     }
>>     if (memcmp_extent_buffer(eb, root->fs_info->fsid, (unsigned
>> long)btrfs_header_fsid(), BTRFS_FSID_SIZE)) {
>>         u8 hdr_fsid[BTRFS_FSID_SIZE] = {0};
>>
>>         read_extent_buffer(eb, hdr_fsid, (unsigned
>> long)btrfs_header_fsid(), BTRFS_FSID_SIZE);
>>         ZBTRFS_WARN(1, "FS[%s]: eb bytenr=%llu header->fsid["PRIX128"]
>> != fs_info->fsid["PRIX128"]", root->fs_info->sb->s_id, start,
>>                     PRI_UUID(hdr_fsid), PRI_UUID(root->fs_info->fsid));
>>         return -EUCLEAN;
>>     }
>>     if (memcmp_extent_buffer(eb, root->fs_info->chunk_tree_uuid,
>> (unsigned long)btrfs_header_chunk_tree_uuid(eb), BTRFS_UUID_SIZE)) {
>>         u8 hdr_ch_uuid[BTRFS_UUID_SIZE] = {0};
>>
>>         read_extent_buffer(eb, hdr_ch_uuid, (unsigned
>> long)btrfs_header_chunk_tree_uuid(eb), BTRFS_UUID_SIZE);
>>         ZBTRFS_WARN(1, "FS[%s]: eb bytenr=%llu
>> header->chunk_tree_uuid["PRIX128"] !=
>> fs_info->chunk_tree_uuid["PRIX128"]", root->fs_info->sb->s_id, start,
>>                     PRI_UUID(hdr_ch_uuid),
>> PRI_UUID(root->fs_info->chunk_tree_uuid));
>>         return -EUCLEAN;
>>     }
>>     if (csum_tree_block(root, eb, 0) != 0) {
>>         ZBTRFS_WARN(1, "FS[%s]: eb bytenr=%llu csum_tree_block()
>> failure", root->fs_info->sb->s_id, start);
>>         return -EUCLEAN;
>>     }
>>
>> ZBTRFS_WARN, PRIX128/PRI_UUID are some custom macros that I added to
>> properly test the fix:
>> #define ZBTRFS_WARN(condition, format, ...) WARN(condition, format,
>> ##__VA_ARGS__)
>> #define PRIX128
>> "%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X"
>> #define PRI_UUID(uuid)    ((u8*)(uuid))[0],  ((u8*)(uuid))[1],
>> ((u8*)(uuid))[2],  ((u8*)(uuid))[3],    \
>>                         ((u8*)(uuid))[4],  ((u8*)(uuid))[5],
>> ((u8*)(uuid))[6],  ((u8*)(uuid))[7],    \
>>                         ((u8*)(uuid))[8],  ((u8*)(uuid))[9],
>> ((u8*)(uuid))[10], ((u8*)(uuid))[11],    \
>>                         ((u8*)(uuid))[12], ((u8*)(uuid))[13],
>> ((u8*)(uuid))[14], ((u8*)(uuid))[15]
>>
>>
>> Then I just pulled the latest Linux tree and fixed it there, and
>> obviously did not check it properly.
>>
>>>
>>>> +        return -EUCLEAN;
>>>> +#endif
>>>> +    if (csum_tree_block(fs_info, eb, 0))
>>>> +        return -EUCLEAN;
>>>
>>> I would just return the real error from csum_tree_block() - currently
>>> it returns 1 for all possible failures instead of its real possible
>>> failures: -ENOMEM or -EINVAL.
>> Returning a positive errno is a bit risky, no? Somebody might only
>> check ret<0, for example, and will miss the error (like
>> flush_epd_write_bio).
>> That's why I preferred to return a negative error, because I saw that
>> csum_tree_block returns 1.
>
> Right, what I meant before but didn't phrase it properly, was to make
> csum_tree_block() returns a negative errno instead of 1 on failure.
> And then just make csum_dirty_buffer() return whatever
> csum_tree_block() returns as an error.
>
> thanks
>
>>
>> Thanks,
>> Alex.
>>
>>
>>>
>>> Thanks.
>>>
>>>>     return 0;
>>>> }
>>>>
>>>> static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
>>>>                  struct extent_buffer *eb)
>>>> {
>>>>     struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>>>>     u8 fsid[BTRFS_UUID_SIZE];
>>>>     int ret = 1;
>>>>
>>>> --
>>>> 1.9.1
>>>>
