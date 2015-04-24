Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34705 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbbDXNnr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 09:43:47 -0400
Received: by iedfl3 with SMTP id fl3so94229306ied.1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 06:43:46 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <553A3E82.5020806@fb.com>
References: <1428954759-1304912-1-git-send-email-clm@fb.com>
	<mh8h3f$l3u$1@ger.gmane.org>
	<pan.2015.04.22.16.37.38@googlemail.com>
	<5537D27E.3080609@fb.com>
	<CAL3q7H4ccdcJYKZaH_fYW9EUPCSTa3gDz_fiUjP8TvCUvQtxTQ@mail.gmail.com>
	<5538EB05.7050200@fb.com>
	<CAL3q7H6wUMruqTvKwMqcTXcgJv2fFw1GFN9QxyfE5GKqR-GNew@mail.gmail.com>
	<20150423151704.GA25585@ret.masoncoding.com>
	<CAL3q7H7oOcTZyCkP0NVWzQ3cKdJD=GDnM6+wM83D9_szHCX95g@mail.gmail.com>
	<CAL3q7H6+x7y64rZfRniJVDP8OwbNWCLuAC7M9D9OWY2urTsnWg@mail.gmail.com>
	<55394CEE.5030205@fb.com>
	<CAL3q7H7sM9Z4AbyuJUy5A9PkhrfOB=eQq_2ZRu9nRgjOwkVA6w@mail.gmail.com>
	<553A3E82.5020806@fb.com>
Date: Fri, 24 Apr 2015 14:43:46 +0100
Message-ID: <CAL3q7H4pEOCoZH5=LVDVr_ENdZZkrgX=rynk7uonZVQzoezYBw@mail.gmail.com>
Subject: Re: [PATCH 0/4] btrfs: reduce block group cache writeout times during commit
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 24, 2015 at 2:00 PM, Chris Mason <clm@fb.com> wrote:
> On 04/24/2015 02:34 AM, Filipe David Manana wrote:
>> On Thu, Apr 23, 2015 at 8:50 PM, Chris Mason <clm@fb.com> wrote:
>>> On 04/23/2015 03:43 PM, Filipe David Manana wrote:
>>>> On Thu, Apr 23, 2015 at 4:48 PM, Filipe David Manana <fdmanana@gmail.com> wrote:
>>>>> On Thu, Apr 23, 2015 at 4:17 PM, Chris Mason <clm@fb.com> wrote:
>>>>>> On Thu, Apr 23, 2015 at 02:05:48PM +0100, Filipe David Manana wrote:
>>>>>>>>> Trying the current integration-4.1 branch, I ran into the following
>>>>>>>>> during xfstests/btrfs/049:
>>>>>>>>>
>>>>>>>>
>>>>>>>> Ugh, I must not be waiting correctly in one of the inode cache writeout
>>>>>>>> sections.  But I've run 049 a whole bunch of times without triggering,
>>>>>>>> can you get this to happen consistently?
>>>>>>>
>>>>>>> All the time so far.
>>>>>>
>>>>>> I'm testing with this now:
>>>>>>
>>>>>> commit 9f433238891b1b243c4f19d3f36eed913b270cbc
>>>>>> Author: Chris Mason <clm@fb.com>
>>>>>> Date:   Thu Apr 23 08:02:49 2015 -0700
>>>>>>
>>>>>>     Btrfs: fix inode cache writeout
>>>>>>
>>>>>>     The code to fix stalls during free spache cache IO wasn't using
>>>>>>     the correct root when waiting on the IO for inode caches.  This
>>>>>>     is only a problem when the inode cache is enabled with
>>>>>>
>>>>>>     mount -o inode_cache
>>>>>>
>>>>>>     This fixes the inode cache writeout to preserve any error values and
>>>>>>     makes sure not to override the root when inode cache writeout is done.
>>>>>>
>>>>>>     Reported-by: Filipe Manana <fdmanana@suse.com>
>>>>>>     Signed-off-by: Chris Mason <clm@fb.com>
>>>>>
>>>>> Thanks, btrfs/049 now passes with that patch applied.
>>>>> Running the whole xfstests suite now.
>>>>
>>>> btrfs/066 also failed once during final fsck with:
>>>>
>>>> _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
>>>> *** fsck.btrfs output ***
>>>> checking extents
>>>> checking free space cache
>>>> There is no free space entry for 21676032-21680128
>>>> There is no free space entry for 21676032-87031808
>>>> cache appears valid but isnt 20971520
>>>
>>> Josef has a btrfs-progs patch for this.  The kernel will toss the cache.
>>>  There's a somewhat fundamental race in cache writeout this patch makes
>>> a little bigger, but it has always been there.
>>>
>>> (compare what find_free_extent can do with no trans running vs the
>>> actual cache writeback)
>>
>> There's also one list corruption I didn't get before and happened
>> while running fsstress (btrfs/078), apparently due to some race:
>
> Can you please bang on this and get a more reliable reproduction? I'll
> take a look.

Not really that easy to get a more reliable reproducer - just run
fsstress with multiple processes - it already happened twice again
after I sent the previous mail.
>From the quick look I had at this, this seems to be the change causing
the problem:

http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=for-linus-4.1&id=1bbc621ef28462456131c035eaeb5567a1a2a2fe

Early in btrfs_commit_transaction(), btrfs_start_dirty_block_groups()
is called which ends up calling __btrfs_write_out_cache() for each
dirty block group, which collects all the bitmap entries from the bg's
space cache into a local list while holding the cache's ctl->tree_lock
(to serialize with concurrent allocation requests).

Then we unlock ctl->tree_lock, do other stuff and later acquire
ctl->tree_lock again and call write_bitmap_entries() to write the
bitmap entries we previously collected. However, while we were doing
the other stuff without holding that lock, allocation requests might
have happened right? - since when we call
btrfs_start_dirty_block_groups() in btrfs_commit_transaction() the
transaction state wasn't yet changed, allowing other tasks to join the
current transaction. If such other task allocates all the remaining
space from a bitmap entry we collected before (because it's still in
the space cache's rbtree), it ends up deleting it and freeing its
->bitmap member, which results in an invalid memory access (and the
warning on the list corruption) when we later call
write_bitmap_entries() in __btrfs_write_out_cache() - which is what
the second part of the trace I sent says:


[25590.890573] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
(...)
[25590.892522] CPU: 3 PID: 7280 Comm: fsstress Tainted: G        W
  4.0.0-rc5-btrfs-next-9+ #1
[25590.892522] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[25590.892522] task: ffff88040f485bd0 ti: ffff8803f0318000 task.ti:
ffff8803f0318000
[25590.892522] RIP: 0010:[<ffffffffa04cff2c>]  [<ffffffffa04cff2c>]
write_bitmap_entries+0x66/0xbd [btrfs]
(...)
[25590.892522] Stack:
[25590.892522]  ffffffffa04d0858 ffff880041710df0 ffff880041710c00
ffff88033ba59c90
[25590.892522]  0000000000000000 ffff8803efb6ff70 ffff8803f031bd78
ffffffffa04d0864
[25590.892522]  ffff88037cae7f40 ffff88033ba599d0 ffff880226cd4000
ffff8803efb6ff00
[25590.892522] Call Trace:
[25590.892522]  [<ffffffffa04d0858>] ?
__btrfs_write_out_cache.isra.21+0x20b/0x3a1 [btrfs]
[25590.892522]  [<ffffffffa04d0864>]
__btrfs_write_out_cache.isra.21+0x217/0x3a1 [btrfs]
[25590.892522]  [<ffffffffa04d1269>] ? btrfs_write_out_cache+0x41/0xdc [btrfs]
[25590.892522]  [<ffffffffa04d12bb>] btrfs_write_out_cache+0x93/0xdc [btrfs]
[25590.892522]  [<ffffffffa04888e7>] ?
btrfs_start_dirty_block_groups+0x156/0x29b [btrfs]
[25590.892522]  [<ffffffffa0488977>]
btrfs_start_dirty_block_groups+0x1e6/0x29b [btrfs]
[25590.892522]  [<ffffffffa04970f2>]
btrfs_commit_transaction+0x130/0x9c9 [btrfs]

And write_bitmap_entries+0x66 corresponds to:

static int io_ctl_add_bitmap(struct btrfs_io_ctl *io_ctl, void *bitmap)
{
(...)
memcpy(io_ctl->cur, bitmap, PAGE_CACHE_SIZE);
(...)
}

I.e. the ->bitmap field from an entry we pass from write_bitmap_entries().
So releasing the tree_lock after collecting the bitmaps and before
writing them out seems to me what leads to the race and invalid memory
access. But I might be wrong, I haven't spent more than 5 minutes
analyzing it.


>
> -chris
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
