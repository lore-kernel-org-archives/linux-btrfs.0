Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1871 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754208AbcAYBiF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 20:38:05 -0500
Subject: Re: BTRFS: bdev /dev/mapper/dshelf1 errs: wr 2970, rd 848, flush 0,
 corrupt 189, gen 0
To: Marc MERLIN <marc@merlins.org>, David Sterba <dsterba@suse.cz>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <20160123170354.GA10113@merlins.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56A57C59.1040203@cn.fujitsu.com>
Date: Mon, 25 Jan 2016 09:37:29 +0800
MIME-Version: 1.0
In-Reply-To: <20160123170354.GA10113@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Marc MERLIN wrote on 2016/01/23 09:03 -0800:
> +David, +Qu
> about
> 1) kernel crash on BUG_ON

 From your code mentioned, and your second kernel warning, it's out of 
memory.
Such case also happened when I was debugging in-band de-dup patches.

Things seems that by some method, btrfs used a lot of memory for dirty 
page caches. Maybe metadata pages.

Normally when such case happens, VFS should trigger a sync to free dirty 
pages, but btrfs seems to either delayed the sync due to running trans 
or the VFS sync is already too late.

But it's also possible that large leafsize is related to such problem.
The larger leafsize is, the harder to alloc continuous memory for kmalloc().

> 2) check --repair not giving good clue that
> "type mismatch with chunk" is unfixable, and whether it can be kind of
> ignored or whether your FS really needs to be recreated from scratch
> (many hours of work for me, and probably 2 days of clock time to rebuild
> and restore from backup)

For "type mismatch" problem, it's unfixable, but as far as what we know, 
it shouldn't cause big problem.

If you're using old version btrfsck, then it's possible such error is a 
false alert. Update btrfsck and try again is a good idea.

Even if it's not a false alert, mail list says it shouldn't cause huge 
problem, only known problems happens is related to scrub.
And there is already some user reporting balance can fix it, although 
you need to balance all chunks.

> 3) say more about "root 45948 inode 204452 errors 1000, some csum missing",
> that they aren't being fixed, and whether they're a big deal or not.

Personally speaking, I didn't consider it as a big problem itself.
If csum is missing/corrupted, btrfsck --init-csum-tree can rebuild it.

But the root problem is more important, maybe some extent/csum tree 
blocks are corrupted and failed to find the checksum, or kernel bugs 
causing csum missing.

Although, from your very first report, a lot of file extents are either 
corrupted or in bad shape.
Not sure how accurate the original/repaired data is.

>
> More generally I'm curious to know if check --repair will sometimes fix
> more things on a 2nd (or 3rd...) run than on the first one.

It is possible that further run to fix more problems, considering the 
already complicated fixing codes.
But I also consider the possibility not very high though.

I hope I could have your latest btrfsck result to further investigate 
what's wrong (at least what's wrong on disk).

Thanks,
Qu

>
> Thanks,
> Marc
>
> On Mon, Jan 18, 2016 at 03:39:43PM -0800, Marc MERLIN wrote:
>> On Mon, Jan 18, 2016 at 03:21:53AM +0000, Duncan wrote:
>>> No.  Those are monotonically increasing counts that are never
>>> automatically reset over the life of the filesystem.  Use ...
>>>
>>> btrfs dev stats
>>>
>>> ... to display them on the commandline (vs. the kernel log at filesystem
>>> mount), with the -z option to reset them after display, if desired.
>>
>> It's a bit counter intuitive that check --repair doesn't reset error counts if it fixed
>> underlying errors, but maybe there is a good reason :)
>>
>> btrfs dev stats -z /dev/mapper/dshelf1
>> put everything back to 0 as you hinted, I can now watch what's going on
>> from here on, thanks.
>>
>> On Mon, Jan 18, 2016 at 12:45:33PM +0000, Hugo Mills wrote:
>>>> bad extent [8697338122240, 8697338126336), type mismatch with chunk
>>>> bad extent [8697338126336, 8697338130432), type mismatch with chunk
>>>> bad extent [8697338130432, 8697338134528), type mismatch with chunk
>>>
>>>     This is, I think, a symptom of an FS created with a broken
>>> mkfs.btrfs, and it needs to be re-created. Take a look for that error
>>> message in the mailing list archives -- there's been a few posts about
>>> it in the last couple of months.
>>
>> Thanks for that other hint.
>> It was created quite a while ago (1y+), and ran ok until I had an
>> unexpected crash.
>> If I have to rebuild it, I will, but that will take 2 days+ due to the
>> size and getting the backup back (well also, I'm not home for a week, so
>> restoring backups remotely isn't going to be fun).
>>
>> But sure enough, while it ran perfectly fine for a long time, after check --repair,
>> my machine is now crashing every hour or so, with the crash below.
>>
>> I had to have an older kernel due to a separate problem where PMP (sata
>> port multiplier) support was broken in more recent kernels.
>> I've just put 4.3.3 on it to see if crashes still, but either way, I thought
>> btrfs had gotten rid of its last BUG_ON(xxx). System should never crash
>> due to unexpected filesystem state on a non system partition.
>>
>> Mmmh, scratch this, here's the BUG_ON, it's a memory problem :(
>> fs/btrfs/ctree.c:5200
>> 		/* save our key for returning back */
>> 		btrfs_node_key_to_cpu(cur, &found_key, slot);
>> 		path->slots[level] = slot;
>> 		if (level == path->lowest_level) {
>> 			ret = 0;
>> 			goto out;
>> 		}
>> 		btrfs_set_path_blocking(path);
>> 		cur = read_node_slot(root, cur, slot);
>> 		BUG_ON(!cur); /* -ENOMEM */
>>
>> Did check --repair potentially change my FS in a way that is now making the
>> kernel take a lot of RAM and crash?
>>
>>
>> ------------[ cut here ]------------
>> kernel BUG at fs/btrfs/ctree.c:5200!
>> invalid opcode: 0000 [#1] SMP
>> CPU: 3 PID: 29041 Comm: btrfs Tainted: G        W       4.2.5-amd64-i915-volpreempt-20150421 #4
>> Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
>> task: ffff88002f8482c0 ti: ffff8800c9058000 task.ti: ffff8800c9058000
>> RIP: 0010:[<ffffffff81234001>]  [<ffffffff81234001>] btrfs_search_forward+0x1a6/0x24b
>> RSP: 0018:ffff8800c905bbc8  EFLAGS: 00010246
>> RAX: 0000000000000000 RBX: ffff8801494409b0 RCX: 000000000003c6c8
>> RDX: 0000000000000000 RSI: 000000000aa60000 RDI: fffffffffffffffb
>> RBP: ffff8800c905bc38 R08: 0000000001c00000 R09: 0000000000000000
>> R10: 0000000000aaaaaa R11: ffffffff818799e0 R12: 0000000000000000
>> R13: 0000000000000001 R14: 0000000000000000 R15: ffff8801494409b4
>> FS:  00007fa9d46848c0(0000) GS:ffff88021e2c0000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00000000f77cd000 CR3: 0000000143780000 CR4: 00000000001406e0
>> Stack:
>>   ffff8800c9bb6050 0001880149440a18 ffff8800c905bc87 ffff8800c939a800
>>   0000000000000003 1a0000000000002e 84000000000000b3 000000000003c59e
>>   000000000000002c ffff8801494409b0 0000000000000000 ffff8800c905bce0
>> Call Trace:
>>   [<ffffffff81278ca5>] search_ioctl+0xfc/0x167
>>   [<ffffffff81278d6b>] btrfs_ioctl_tree_search+0x5b/0x8e
>>   [<ffffffff8127c6af>] btrfs_ioctl+0x396/0x232f
>>   [<ffffffff81123a2d>] ? get_page+0xe/0x28
>>   [<ffffffff81123e68>] ? __lru_cache_add+0x23/0x44
>>   [<ffffffff81124139>] ? lru_cache_add_active_or_unevictable+0x2d/0x6b
>>   [<ffffffff8113a2df>] ? set_pte_at+0x9/0xd
>>   [<ffffffff8113e21d>] ? handle_mm_fault+0x90e/0xe9b
>>   [<ffffffff8100d02b>] ? paravirt_write_msr+0xf/0x13
>>   [<ffffffff811814af>] do_vfs_ioctl+0x39b/0x412
>>   [<ffffffff810ace61>] ? current_kernel_time+0xe/0x32
>>   [<ffffffff810d4d5c>] ? __audit_syscall_entry+0xbe/0xe0
>>   [<ffffffff81181580>] SyS_ioctl+0x5a/0x7f
>>   [<ffffffff816b0032>] entry_SYSCALL_64_fastpath+0x16/0x75
>> Code: 89 47 40 44 3b ab 84 00 00 00 74 69 48 89 df e8 f7 a3 ff ff 8b 55 b8 48 8b 7d a8 4c 89 e6 e8 d8 86 ff ff 48 85 c0
>> <0f> 0b 48 89 c7 e8 23 a7 04 00 41 8d 45 ff 41 c7 47 5c 02 00 00
>> RIP  [<ffffffff81234001>] btrfs_search_forward+0x1a6/0x24b
>>   RSP <ffff8800c905bbc8>
>> ---[ end trace e3c37adcaa703f63 ]---
>> Kernel panic - not syncing: Fatal exception
>> Kernel Offset: disabled
>> drm_kms_helper: panic occurred, switching back to text console
>>
>>
>>
>>
>> --
>> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>> Microsoft is to operating systems ....
>>                                        .... what McDonalds is to gourmet cooking
>> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> On Wed, Jan 20, 2016 at 08:52:39PM -0800, Marc MERLIN wrote:
>> On Mon, Jan 18, 2016 at 03:39:43PM -0800, Marc MERLIN wrote:
>>> Thanks for that other hint.
>>> It was created quite a while ago (1y+), and ran ok until I had an
>>> unexpected crash.
>>> If I have to rebuild it, I will, but that will take 2 days+ due to the
>>> size and getting the backup back (well also, I'm not home for a week, so
>>> restoring backups remotely isn't going to be fun).
>>>
>>> But sure enough, while it ran perfectly fine for a long time, after check --repair,
>>> my machine is now crashing every hour or so, with the crash below.
>>
>> I ran check --repair a few more times on it but it does not seem to converge.
>> The bad extent stuff, I understand cannot be fixed (although it's not obvious from check
>> --repair that they are not getting fixed).
>>
>> But how about
>> root 45940 inode 204450 errors 1000, some csum missing
>> Are those getting fixed by check --repair or are they unfixable too?
>>
>> (...)
>> bad extent [8697338126336, 8697338130432), type mismatch with chunk
>> bad extent [8697338130432, 8697338134528), type mismatch with chunk
>> repaired damaged extent references
>>
>> Fixed 0 roots.
>> cache and super generation don't match, space cache will be invalidated
>> rootk262 inodeo204450 errors 1000, some csum missing
>> root 262 inode 204452 errors 1000, some csum missing
>> (...)
>> root 45940 inode 204450 errors 1000, some csum missing
>> root 45940 inode 204452 errors 1000, some csum missing
>> root 45944 inode 204450 errors 1000, some csum missing
>> root 45944 inode 204452 errors 1000, some csum missing
>> root 45948 inode 204450 errors 1000, some csum missing
>> root 45948 inode 204452 errors 1000, some csum missing
>> checking fs roots [o]
>> checking csums
>> checking root refs
>> found 9826295305149 bytes used err is 0
>> total csum bytes: 9584154948
>> total tree bytes: 12201304064
>> total fs tree bytes: 330776576
>> total extent tree bytes: 498921472
>> btree space waste bytes: 1373183541
>> file data blocks allocated: 9953275256832
>>   referenced 9964596801536
>> btrfs-progs v4.3
>>
>>
>> Thanks,
>> Marc
>> --
>> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>> Microsoft is to operating systems ....
>>                                        .... what McDonalds is to gourmet cooking
>> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>


