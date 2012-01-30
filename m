From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: Check for NULL page in extent_range_uptodate
Date: Mon, 30 Jan 2012 17:13:36 -0600
Message-ID: <CAKcLGm-o7Z-cfODSQjRx0v3yq=D5ZEWyqbhvpx+GBP-wLCXuAQ@mail.gmail.com>
References: <1327518224-4103-1-git-send-email-mitch.harder@sabayonlinux.org>
	<CAMpZLrg13VfO=3iX1+C90Oxrb5Ko9UCiQGk6AxX3oQ7Wz3Pbxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Vincent Vanackere <vincent.vanackere@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMpZLrg13VfO=3iX1+C90Oxrb5Ko9UCiQGk6AxX3oQ7Wz3Pbxg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 30, 2012 at 3:41 PM, Vincent Vanackere
<vincent.vanackere@gmail.com> wrote:
> On Wed, Jan 25, 2012 at 20:03, Mitch Harder
> <mitch.harder@sabayonlinux.org> wrote:
>> A user has encountered a NULL pointer kernel oops in btrfs when
>> encountering media errors. =A0The problem has been identified
>> as an unhandled NULL pointer returned from find_get_page().
>> This modification simply checks for a NULL page, and returns
>> with an error if found (the extent_range_uptodate() function
>> returns 1 on errors).
>>
>> After testing this patch, the user reported that the error with
>> the NULL pointer oops was solved. =A0However, there is still a
>> remaining problem with a thread becoming stuck in
>> wait_on_page_locked(page) in the read_extent_buffer_pages(...)
>> function in extent_io.c
>>
>> =A0 =A0 =A0 for (i =3D start_i; i < num_pages; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D extent_buffer_page(eb, i);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_on_page_locked(page);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!PageUptodate(page))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EIO;
>> =A0 =A0 =A0 }
>>
>> This patch leaves the issue with the locked page yet to be resolved.
>>
>> Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
>> ---
>> =A0fs/btrfs/extent_io.c | =A0 =A02 ++
>> =A01 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 9d09a4f..fcf77e1 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -3909,6 +3909,8 @@ int extent_range_uptodate(struct extent_io_tre=
e *tree,
>> =A0 =A0 =A0 =A0while (start <=3D end) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index =3D start >> PAGE_CACHE_SHIFT;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page =3D find_get_page(tree->mapping,=
 index);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!page)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0uptodate =3D PageUptodate(page);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page_cache_release(page);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!uptodate) {
>> --
>> 1.7.3.4
>>
>
>
> Hi,
>
> =A0If any btrfs developer could have a look at it while I can still
> reproduce the situation (it won't last long, I'll send the disk to RM=
A
> next week), I'm still interested in solving the remaining part of the
> btrfs bug. Here is the trace I get with the current linux kernel
> (6bc2b95ee602659c1be6fac0f6aadeb0c5c29a5d) :
>
> [ =A0330.530015] btrfs bad tree block start 959241011200 959241011200
> [ =A0480.288046] INFO: task cat:2627 blocked for more than 120 second=
s.
> [ =A0480.288050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ =A0480.288052] cat =A0 =A0 =A0 =A0 =A0 =A0 D ffffffff8180c600 =A0 =A0=
 0 =A02627 =A0 2468 0x00000004
> [ =A0480.288057] =A0ffff8801fe135618 0000000000000086 ffff8801fe1355d=
8
> ffff880222061650
> [ =A0480.288062] =A0ffff880215b5db80 ffff8801fe135fd8 ffff8801fe135fd=
8
> ffff8801fe135fd8
> [ =A0480.288067] =A0ffff8802241a16e0 ffff880215b5db80 ffff8801fe1355e=
8
> ffff88022fd93e88
> [ =A0480.288071] Call Trace:
> [ =A0480.288080] =A0[<ffffffff81114440>] ? __lock_page+0x70/0x70
> [ =A0480.288084] =A0[<ffffffff8162c0af>] schedule+0x3f/0x60
> [ =A0480.288087] =A0[<ffffffff8162c15f>] io_schedule+0x8f/0xd0
> [ =A0480.288091] =A0[<ffffffff8111444e>] sleep_on_page+0xe/0x20
> [ =A0480.288094] =A0[<ffffffff8162a96f>] __wait_on_bit+0x5f/0x90
> [ =A0480.288098] =A0[<ffffffff811145b8>] wait_on_page_bit+0x78/0x80
> [ =A0480.288102] =A0[<ffffffff81070c70>] ? autoremove_wake_function+0=
x40/0x40
> [ =A0480.288129] =A0[<ffffffffa005d161>]
> read_extent_buffer_pages+0x471/0x4d0 [btrfs]
> [ =A0480.288142] =A0[<ffffffffa00347b0>] ? verify_parent_transid+0x16=
0/0x160 [btrfs]
> [ =A0480.288155] =A0[<ffffffffa003513a>]
> btree_read_extent_buffer_pages.isra.99+0x8a/0xc0 [btrfs]
> [ =A0480.288169] =A0[<ffffffffa00371e1>] read_tree_block+0x41/0x60 [b=
trfs]
> [ =A0480.288179] =A0[<ffffffffa001d6a3>]
> read_block_for_search.isra.34+0xf3/0x3d0 [btrfs]
> [ =A0480.288190] =A0[<ffffffffa001f930>] btrfs_search_slot+0x300/0x8a=
0 [btrfs]
> [ =A0480.288203] =A0[<ffffffffa0031ab4>] btrfs_lookup_csum+0x74/0x170=
 [btrfs]
> [ =A0480.288216] =A0[<ffffffffa0031d5f>] __btrfs_lookup_bio_sums+0x1a=
f/0x3b0 [btrfs]
> [ =A0480.288228] =A0[<ffffffffa0031fb6>] btrfs_lookup_bio_sums+0x16/0=
x20 [btrfs]
> [ =A0480.288242] =A0[<ffffffffa003e650>] btrfs_submit_bio_hook+0x140/=
0x170 [btrfs]
> [ =A0480.288256] =A0[<ffffffffa00405d0>] ? btrfs_real_readdir+0x720/0=
x720 [btrfs]
> [ =A0480.288272] =A0[<ffffffffa00571aa>] submit_one_bio+0x6a/0xa0 [bt=
rfs]
> [ =A0480.288287] =A0[<ffffffffa005be64>] extent_readpages+0xe4/0x100 =
[btrfs]
> [ =A0480.288301] =A0[<ffffffffa00405d0>] ? btrfs_real_readdir+0x720/0=
x720 [btrfs]
> [ =A0480.288315] =A0[<ffffffffa003eebf>] btrfs_readpages+0x1f/0x30 [b=
trfs]
> [ =A0480.288319] =A0[<ffffffff81120bef>] __do_page_cache_readahead+0x=
1af/0x250
> [ =A0480.288323] =A0[<ffffffff81120ff1>] ra_submit+0x21/0x30
> [ =A0480.288326] =A0[<ffffffff81121115>] ondemand_readahead+0x115/0x2=
30
> [ =A0480.288330] =A0[<ffffffff81137eb9>] ? __do_fault+0x419/0x530
> [ =A0480.288333] =A0[<ffffffff81121311>] page_cache_sync_readahead+0x=
31/0x50
> [ =A0480.288337] =A0[<ffffffff811167d8>] generic_file_aio_read+0x438/=
0x780
> [ =A0480.288342] =A0[<ffffffff81173db2>] do_sync_read+0xd2/0x110
> [ =A0480.288346] =A0[<ffffffff81294113>] ? security_file_permission+0=
x93/0xb0
> [ =A0480.288349] =A0[<ffffffff81174231>] ? rw_verify_area+0x61/0xf0
> [ =A0480.288352] =A0[<ffffffff81174710>] vfs_read+0xb0/0x180
> [ =A0480.288355] =A0[<ffffffff8117482a>] sys_read+0x4a/0x90
> [ =A0480.288359] =A0[<ffffffff81635229>] system_call_fastpath+0x16/0x=
1b

Jeff Mahoney has been working on a large overhaul of error
handling/BUG_ONs.  It is difficult to say when it  will be ready, or
if it will even address this specific problem.

I'd go ahead and return the disk.  I doubt you'll be the last user to
have bad sectors, so there'll be more opportunities to see how this
issue is handled after the changes to error handling.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
