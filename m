Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13377 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030357AbbDWTuQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 15:50:16 -0400
Message-ID: <55394CEE.5030205@fb.com>
Date: Thu, 23 Apr 2015 15:50:06 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] btrfs: reduce block group cache writeout times during
 commit
References: <1428954759-1304912-1-git-send-email-clm@fb.com>	<mh8h3f$l3u$1@ger.gmane.org>	<pan.2015.04.22.16.37.38@googlemail.com>	<5537D27E.3080609@fb.com>	<CAL3q7H4ccdcJYKZaH_fYW9EUPCSTa3gDz_fiUjP8TvCUvQtxTQ@mail.gmail.com>	<5538EB05.7050200@fb.com>	<CAL3q7H6wUMruqTvKwMqcTXcgJv2fFw1GFN9QxyfE5GKqR-GNew@mail.gmail.com>	<20150423151704.GA25585@ret.masoncoding.com>	<CAL3q7H7oOcTZyCkP0NVWzQ3cKdJD=GDnM6+wM83D9_szHCX95g@mail.gmail.com> <CAL3q7H6+x7y64rZfRniJVDP8OwbNWCLuAC7M9D9OWY2urTsnWg@mail.gmail.com>
In-Reply-To: <CAL3q7H6+x7y64rZfRniJVDP8OwbNWCLuAC7M9D9OWY2urTsnWg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/23/2015 03:43 PM, Filipe David Manana wrote:
> On Thu, Apr 23, 2015 at 4:48 PM, Filipe David Manana <fdmanana@gmail.com> wrote:
>> On Thu, Apr 23, 2015 at 4:17 PM, Chris Mason <clm@fb.com> wrote:
>>> On Thu, Apr 23, 2015 at 02:05:48PM +0100, Filipe David Manana wrote:
>>>>>> Trying the current integration-4.1 branch, I ran into the following
>>>>>> during xfstests/btrfs/049:
>>>>>>
>>>>>
>>>>> Ugh, I must not be waiting correctly in one of the inode cache writeout
>>>>> sections.  But I've run 049 a whole bunch of times without triggering,
>>>>> can you get this to happen consistently?
>>>>
>>>> All the time so far.
>>>
>>> I'm testing with this now:
>>>
>>> commit 9f433238891b1b243c4f19d3f36eed913b270cbc
>>> Author: Chris Mason <clm@fb.com>
>>> Date:   Thu Apr 23 08:02:49 2015 -0700
>>>
>>>     Btrfs: fix inode cache writeout
>>>
>>>     The code to fix stalls during free spache cache IO wasn't using
>>>     the correct root when waiting on the IO for inode caches.  This
>>>     is only a problem when the inode cache is enabled with
>>>
>>>     mount -o inode_cache
>>>
>>>     This fixes the inode cache writeout to preserve any error values and
>>>     makes sure not to override the root when inode cache writeout is done.
>>>
>>>     Reported-by: Filipe Manana <fdmanana@suse.com>
>>>     Signed-off-by: Chris Mason <clm@fb.com>
>>
>> Thanks, btrfs/049 now passes with that patch applied.
>> Running the whole xfstests suite now.
> 
> btrfs/066 also failed once during final fsck with:
> 
> _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
> *** fsck.btrfs output ***
> checking extents
> checking free space cache
> There is no free space entry for 21676032-21680128
> There is no free space entry for 21676032-87031808
> cache appears valid but isnt 20971520

Josef has a btrfs-progs patch for this.  The kernel will toss the cache.
 There's a somewhat fundamental race in cache writeout this patch makes
a little bigger, but it has always been there.

(compare what find_free_extent can do with no trans running vs the
actual cache writeback)

-chris

> Checking filesystem on /dev/sdc
> UUID: f7785aa7-d5ba-479d-a211-7c31039dc9b1
> found 11911316 bytes used err is -22
> total csum bytes: 7656
> total tree bytes: 454656
> total fs tree bytes: 376832
> total extent tree bytes: 36864
> btree space waste bytes: 122959
> file data blocks allocated: 42893312
>  referenced 31158272
> 
> (it failed like that 1 out of 4 runs)
> 
> 
>>
>>>
>>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>>> index 5a4f5d1..8cd797f 100644
>>> --- a/fs/btrfs/free-space-cache.c
>>> +++ b/fs/btrfs/free-space-cache.c
>>> @@ -1149,7 +1149,8 @@ int btrfs_wait_cache_io(struct btrfs_root *root,
>>>         if (!inode)
>>>                 return 0;
>>>
>>> -       root = root->fs_info->tree_root;
>>> +       if (block_group)
>>> +               root = root->fs_info->tree_root;
>>>
>>>         /* Flush the dirty pages in the cache file. */
>>>         ret = flush_dirty_cache(inode);
>>> @@ -3465,9 +3466,12 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
>>>         if (!btrfs_test_opt(root, INODE_MAP_CACHE))
>>>                 return 0;
>>>
>>> +       memset(&io_ctl, 0, sizeof(io_ctl));
>>>         ret = __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl,
>>> -                                     trans, path, 0) ||
>>> -               btrfs_wait_cache_io(root, trans, NULL, &io_ctl, path, 0);
>>> +                                     trans, path, 0);
>>> +       if (!ret)
>>> +               ret = btrfs_wait_cache_io(root, trans, NULL, &io_ctl, path, 0);
>>> +
>>>         if (ret) {
>>>                 btrfs_delalloc_release_metadata(inode, inode->i_size);
>>>  #ifdef DEBUG
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
> 

