From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: fix warning in iput for bad-inode
Date: Tue, 30 Aug 2011 15:45:33 -0400
Message-ID: <4E5D3DDD.2090401@redhat.com>
References: <20110817185619.4660.78543.stgit@localhost6> <20110829063416.00f4652c@sf> <20110830195309.4882f478@sf> <4E5D25BD.3020901@redhat.com> <20110830223116.5fc21074@sf> <4E5D3CC1.2090505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E5D3CC1.2090505@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/30/2011 03:40 PM, Josef Bacik wrote:
> On 08/30/2011 03:31 PM, Sergei Trofimovich wrote:
>> On Tue, 30 Aug 2011 14:02:37 -0400 Josef Bacik <josef@redhat.com>
>> wrote:
>>
>>> On 08/30/2011 12:53 PM, Sergei Trofimovich wrote:
>>>>> Running 'sync' program after the load does not finish and
>>>>> eats 100%CPU busy-waiting for something in kernel.
>>>>>
>>>>> It's easy to reproduce hang with patch for me. I just run 
>>>>> liferea and sync after it. Without patch I haven't managed
>>>>> to hang btrfs up.
>>>>
>>>> And I think it's another btrfs bug. I've managed to reproduce
>>>> it _without_ your patch and _without_ autodefrag enabled by
>>>> manually running the following commands: $ btrfs fi defrag 
>>>> file-with-20_000-extents $ sync
>>>>
>>>> I think your patch just shuffles things a bit and forces 
>>>> autodefrag races to pop-up sooner (which is good! :])
>>>>
>>>
>>> Sergei, can you do sysrq+w when this is happening, and maybe turn
>>> on the softlockup detector so we can see where sync is getting
>>> stuck? Thanks,
>>
>> Sure. As I keep telling about 2 cases in IRC I will state both here
>> explicitely:
>>
>> ==The First Issue (aka "The Hung sync()" case) ==
>>
>> - it's an unpatched linus's v3.1-rc4-80-g0f43dd5 - /dev/root on /
>> type btrfs (rw,noatime,compress=lzo) - 50% full 30GB filesystem
>> (usual nonmixed mode)
>>
>> How I hung it: $ /usr/sbin/filefrag ~/.bogofilter/wordlist.db 
>> /home/st/.bogofilter/wordlist.db: 19070 extents found the file is
>> 138MB sqlite database for bayesian SPAM filter, it's being read and
>> written every 20 minutes or so. Maybe, it was writtent even in
>> defrag/sync time! $~/dev/git/btrfs-progs-unstable/btrfs fi defrag
>> ~/.bogofilter/wordlist.db $ sync ^C<hung in D-state>
>>
>> I didn't try to reproduce it yet. As for lockdep I'll try but I'm
>> afraid I will fail to reproduce, but I'll try tomorrow. I suspect
>> I'll need to seriously fragment some file first down to such
>> horrible state.
>>
>> With help of David I've some (hopefully relevant) info: #!/bin/sh
>> -x
>>
>> for i in $(ps aux|grep " D[+ ]\?"|awk '{print $2}'); do ps $i sudo
>> cat /proc/$i/stack done
>>
>> PID TTY      STAT   TIME COMMAND 1291 ?        D      0:00
>> [btrfs-endio-wri] [<ffffffff8130055d>]
>> btrfs_tree_read_lock+0x6d/0x120 [<ffffffff812b8e88>]
>> btrfs_search_slot+0x698/0x8b0 [<ffffffff812c9e18>]
>> btrfs_lookup_csum+0x68/0x190 [<ffffffff812ca10f>]
>> __btrfs_lookup_bio_sums+0x1cf/0x3e0 [<ffffffff812ca371>]
>> btrfs_lookup_bio_sums+0x11/0x20 [<ffffffff812d6a50>]
>> btrfs_submit_bio_hook+0x140/0x170 [<ffffffff812ed594>]
>> submit_one_bio+0x64/0xa0 [<ffffffff812f14f5>]
>> extent_readpages+0xe5/0x100 [<ffffffff812d7aaa>]
>> btrfs_readpages+0x1a/0x20 [<ffffffff810a6a02>]
>> __do_page_cache_readahead+0x1d2/0x280 [<ffffffff810a6d8c>]
>> ra_submit+0x1c/0x20 [<ffffffff810a6ebd>]
>> ondemand_readahead+0x12d/0x270 [<ffffffff810a70cc>]
>> page_cache_sync_readahead+0x2c/0x40 [<ffffffff81309987>]
>> __load_free_space_cache+0x1a7/0x5b0 [<ffffffff81309e61>]
>> load_free_space_cache+0xd1/0x190 [<ffffffff812be07b>]
>> cache_block_group+0xab/0x290 [<ffffffff812c3def>]
>> find_free_extent.clone.71+0x39f/0xab0 [<ffffffff812c5160>]
>> btrfs_reserve_extent+0xe0/0x170 [<ffffffff812c56df>]
>> btrfs_alloc_free_block+0xcf/0x330 [<ffffffff812b498d>]
>> __btrfs_cow_block+0x11d/0x4a0 [<ffffffff812b4df8>]
>> btrfs_cow_block+0xe8/0x1a0 [<ffffffff812b8965>]
>> btrfs_search_slot+0x175/0x8b0 [<ffffffff812c9e18>]
>> btrfs_lookup_csum+0x68/0x190 [<ffffffff812caf6e>]
>> btrfs_csum_file_blocks+0xbe/0x670 [<ffffffff812d7d91>]
>> add_pending_csums.clone.39+0x41/0x60 [<ffffffff812da528>]
>> btrfs_finish_ordered_io+0x218/0x310 [<ffffffff812da635>]
>> btrfs_writepage_end_io_hook+0x15/0x20 [<ffffffff8130c71a>]
>> end_compressed_bio_write+0x7a/0xe0 [<ffffffff811146f8>]
>> bio_endio+0x18/0x30 [<ffffffff812cd8fc>]
>> end_workqueue_fn+0xec/0x120 [<ffffffff812fb0ac>]
>> worker_loop+0xac/0x520 [<ffffffff8105d486>] kthread+0x96/0xa0 
>> [<ffffffff815f9214>] kernel_thread_helper+0x4/0x10 
>> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Ok this should have been fixed with
> 
> Btrfs: use the commit_root for reading free_space_inode crcs
> 
> which is commit # 2cf8572dac62cc2ff7e995173e95b6c694401b3f.  Does your
> kernel have this commit?  Because if it does then we did something
> wrong.  If not it should be in linus's latest tree, so update and it
> should go away (hopefully).  Thanks,
> 

Oops looks like that patch won't fix it completely, I just sent another
patch that will fix this problem totally, sorry about that

[PATCH] Btrfs: skip locking if searching the commit root in lookup_csums

Thanks,

Josef
