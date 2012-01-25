From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [BUG - btrfs] kernel oops in extent_range_uptodate
Date: Tue, 24 Jan 2012 21:30:17 -0600
Message-ID: <CAKcLGm9S7XQRrRJfkptXnEm+df4pz8qws4SiBkUBC+2sbTGMVA@mail.gmail.com>
References: <4F182BED.3090009@gmail.com>
	<CAKcLGm9kVOw6D8kPECfhfohH4pAT=09qws7-jRsh1TZJTyh1_A@mail.gmail.com>
	<4F199AF9.4030909@gmail.com>
	<CAKcLGm9ppCT94y2ijuEEQjH+tP8wPK1E+U6x6RHH2CjtoHmJMg@mail.gmail.com>
	<4F1EDB32.3010903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Vincent Vanackere <vincent.vanackere@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F1EDB32.3010903@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2012 at 10:24 AM, Vincent Vanackere
<vincent.vanackere@gmail.com> wrote:
> On 01/20/2012 09:54 PM, Mitch Harder wrote:
>>
>> On Fri, Jan 20, 2012 at 10:48 AM, Vincent Vanackere
>> <vincent.vanackere@gmail.com> =A0wrote:
>>>
>>> On 01/19/2012 05:24 PM, Mitch Harder wrote:
>>>>
>>>> On Thu, Jan 19, 2012 at 8:42 AM, Vincent Vanackere
>>>> <vincent.vanackere@gmail.com> =A0 =A0wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> With the most current git kernel
>>>>> (90a4c0f51e8e44111a926be6f4c87af3938a79c3)
>>>>> I'm still getting the same reproducible kernel panic when trying =
to
>>>>> read
>>>>> a
>>>>> particular file stored on a btrfs filesystem (as seen in the log =
there
>>>>> are
>>>>> indeed disk media errors on this disk).
>>>>> I'd like the "software" part of this to be fixed - btrfs should
>>>>> definitely
>>>>> not oops even in case of media error - before sending the disk to=
 RMA.
>>>>> Is
>>>>> there anything I can do to make progress on this ?
>>>>>
>>>> Is this kernel compiled with "Compile the kernel with debug info" =
(in
>>>> the "Kernel hacking =A0--->" configuration section)?
>>>>
>>>> It would be nice to have the specific line of code passing the NUL=
L
>>>> pointer.
>>>
>>>
>>> The kernel was compiled with debug information but modern linux
>>> distribution
>>> make it really hard to keep your debug information it seems :-(
>>
>> I see where the find_get_page(...) function called in
>> extent_range_uptodate has the potential to return a NULL value.
>>
>> Could you try the following patch, and if it solves your oops and
>> shows the included warning in your dmesg log, I'll simplify the patc=
h
>> to drop the printk and submit it to the list.
>>
>> I only included the printk since your current error log is ambiguous
>> regarding the specific point where we're getting the NULL pointer
>> dereference, but I'll pull it out if it works.
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 9d09a4f..35c3a2a 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -3909,6 +3909,13 @@ int extent_range_uptodate(struct extent_io_tr=
ee
>> *tree,
>> =A0 =A0 =A0 =A0while (start<=3D end) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index =3D start>> =A0PAGE_CACHE_SHIFT=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page =3D find_get_page(tree->mapping,=
 index);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(!page)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (printk_ratelimit()=
)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk=
(KERN_WARNING
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0"btrfs: NULL page in "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0"extent_range_uptodate()\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0uptodate =3D PageUptodate(page);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page_cache_release(page);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!uptodate) {
>
>
> Indeed your patch helps. No kernel panic any more... but it looks lik=
e the
> task doesn't finish and there's another problem to solve now :
>
>
> sd 5:0:0:0: [sdd] Unhandled sense code
> sd 5:0:0:0: [sdd] =A0Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SE=
NSE
> sd 5:0:0:0: [sdd] =A0Sense Key : Medium Error [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
> =A0 =A0 =A0 =A072 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> =A0 =A0 =A0 =A070 2f dc 61
> sd 5:0:0:0: [sdd] =A0Add. Sense: Unrecovered read error - auto reallo=
cate
> failed
> sd 5:0:0:0: [sdd] CDB: Read(10): 28 00 70 2f dc 5f 00 00 08 00
> end_request: I/O error, dev sdd, sector 1882184801
> ata6: EH complete
> btrfs: NULL page in extent_range_uptodate()
> btrfs: NULL page in extent_range_uptodate()
> btrfs bad tree block start 959241011200 959241011200
> INFO: task cat:3099 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this mess=
age.
> cat =A0 =A0 =A0 =A0 =A0 =A0 D ffffffff8180c600 =A0 =A0 0 =A03099 =A0 =
3002 0x00000000
> =A0ffff8801f2b0f618 0000000000000086 ffff8801f2b0f5d8 ffff88022101877=
0
> =A0ffff880222c65b80 ffff8801f2b0ffd8 ffff8801f2b0ffd8 ffff8801f2b0ffd=
8
> =A0ffff8802241816e0 ffff880222c65b80 ffff8801f2b0f5e8 ffff88022fd13e8=
8
> Call Trace:
> =A0[<ffffffff81114260>] ? __lock_page+0x70/0x70
> =A0[<ffffffff8162c93f>] schedule+0x3f/0x60
> =A0[<ffffffff8162c9ef>] io_schedule+0x8f/0xd0
> =A0[<ffffffff8111426e>] sleep_on_page+0xe/0x20
> =A0[<ffffffff8162b1ff>] __wait_on_bit+0x5f/0x90
> =A0[<ffffffff811143d8>] wait_on_page_bit+0x78/0x80
> =A0[<ffffffff81070c40>] ? autoremove_wake_function+0x40/0x40
> =A0[<ffffffffa0192161>] read_extent_buffer_pages+0x471/0x4d0 [btrfs]
> =A0[<ffffffffa01697b0>] ? verify_parent_transid+0x160/0x160 [btrfs]
> =A0[<ffffffffa016a13a>] btree_read_extent_buffer_pages.isra.99+0x8a/0=
xc0
> [btrfs]
> =A0[<ffffffffa016c1e1>] read_tree_block+0x41/0x60 [btrfs]
> =A0[<ffffffffa01526a3>] read_block_for_search.isra.34+0xf3/0x3d0 [btr=
fs]
> =A0[<ffffffffa0154930>] btrfs_search_slot+0x300/0x8a0 [btrfs]
> =A0[<ffffffffa0166ab4>] btrfs_lookup_csum+0x74/0x170 [btrfs]
> =A0[<ffffffffa0166d5f>] __btrfs_lookup_bio_sums+0x1af/0x3b0 [btrfs]
> =A0[<ffffffffa0166fb6>] btrfs_lookup_bio_sums+0x16/0x20 [btrfs]
> =A0[<ffffffffa0173650>] btrfs_submit_bio_hook+0x140/0x170 [btrfs]
> =A0[<ffffffffa01755d0>] ? btrfs_real_readdir+0x720/0x720 [btrfs]
> =A0[<ffffffffa018c17a>] submit_one_bio+0x6a/0xa0 [btrfs]
> =A0[<ffffffffa0190e34>] extent_readpages+0xe4/0x100 [btrfs]
> =A0[<ffffffffa01755d0>] ? btrfs_real_readdir+0x720/0x720 [btrfs]
> =A0[<ffffffffa0173ebf>] btrfs_readpages+0x1f/0x30 [btrfs]
> =A0[<ffffffff81120a0f>] __do_page_cache_readahead+0x1af/0x250
> =A0[<ffffffff81120e11>] ra_submit+0x21/0x30
> =A0[<ffffffff81120f35>] ondemand_readahead+0x115/0x230
> =A0[<ffffffff81137cd9>] ? __do_fault+0x419/0x530
> =A0[<ffffffff81121131>] page_cache_sync_readahead+0x31/0x50
> =A0[<ffffffff811165f8>] generic_file_aio_read+0x438/0x780
> =A0[<ffffffff81173bb2>] do_sync_read+0xd2/0x110
> =A0[<ffffffff81293e73>] ? security_file_permission+0x93/0xb0
> =A0[<ffffffff81174031>] ? rw_verify_area+0x61/0xf0
> =A0[<ffffffff81174510>] vfs_read+0xb0/0x180
> =A0[<ffffffff8117462a>] sys_read+0x4a/0x90
> =A0[<ffffffff81635ae9>] system_call_fastpath+0x16/0x1b
>

Good, looks like we're making progress.

We appear to be stuck now at wait_on_page_locked(page) in the
read_extent_buffer_pages(...) function in extent_io.c

	for (i =3D start_i; i < num_pages; i++) {
		page =3D extent_buffer_page(eb, i);
		wait_on_page_locked(page);
		if (!PageUptodate(page))
			ret =3D -EIO;
	}

I tried looking around the kernel for how others have handled error
checking when using wait_on_page_locked(...), but I could not find
many examples.

http://lxr.free-electrons.com/ident?i=3Dwait_on_page_locked

I believe I'll have to ask for help from the others on the list at
this point for how to handle this issue.

Do you still have data you are trying to recover from this disk?
