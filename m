From: Vincent Vanackere <vincent.vanackere@gmail.com>
Subject: Re: [PATCH] Btrfs: Check for NULL page in extent_range_uptodate
Date: Mon, 30 Jan 2012 22:41:09 +0100
Message-ID: <CAMpZLrg13VfO=3iX1+C90Oxrb5Ko9UCiQGk6AxX3oQ7Wz3Pbxg@mail.gmail.com>
References: <1327518224-4103-1-git-send-email-mitch.harder@sabayonlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1327518224-4103-1-git-send-email-mitch.harder@sabayonlinux.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2012 at 20:03, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> A user has encountered a NULL pointer kernel oops in btrfs when
> encountering media errors. =C2=A0The problem has been identified
> as an unhandled NULL pointer returned from find_get_page().
> This modification simply checks for a NULL page, and returns
> with an error if found (the extent_range_uptodate() function
> returns 1 on errors).
>
> After testing this patch, the user reported that the error with
> the NULL pointer oops was solved. =C2=A0However, there is still a
> remaining problem with a thread becoming stuck in
> wait_on_page_locked(page) in the read_extent_buffer_pages(...)
> function in extent_io.c
>
> =C2=A0 =C2=A0 =C2=A0 for (i =3D start_i; i < num_pages; i++) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 page =3D extent_buff=
er_page(eb, i);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wait_on_page_locked(=
page);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!PageUptodate(pa=
ge))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ret =3D -EIO;
> =C2=A0 =C2=A0 =C2=A0 }
>
> This patch leaves the issue with the locked page yet to be resolved.
>
> Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
> ---
> =C2=A0fs/btrfs/extent_io.c | =C2=A0 =C2=A02 ++
> =C2=A01 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 9d09a4f..fcf77e1 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3909,6 +3909,8 @@ int extent_range_uptodate(struct extent_io_tree=
 *tree,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0while (start <=3D end) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0index =3D star=
t >> PAGE_CACHE_SHIFT;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0page =3D find_=
get_page(tree->mapping, index);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!page)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uptodate =3D P=
ageUptodate(page);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0page_cache_rel=
ease(page);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!uptodate)=
 {
> --
> 1.7.3.4
>


Hi,

 If any btrfs developer could have a look at it while I can still
reproduce the situation (it won't last long, I'll send the disk to RMA
next week), I'm still interested in solving the remaining part of the
btrfs bug. Here is the trace I get with the current linux kernel
(6bc2b95ee602659c1be6fac0f6aadeb0c5c29a5d) :

[  330.530015] btrfs bad tree block start 959241011200 959241011200
[  480.288046] INFO: task cat:2627 blocked for more than 120 seconds.
[  480.288050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.288052] cat             D ffffffff8180c600     0  2627   2468 0x=
00000004
[  480.288057]  ffff8801fe135618 0000000000000086 ffff8801fe1355d8
ffff880222061650
[  480.288062]  ffff880215b5db80 ffff8801fe135fd8 ffff8801fe135fd8
ffff8801fe135fd8
[  480.288067]  ffff8802241a16e0 ffff880215b5db80 ffff8801fe1355e8
ffff88022fd93e88
[  480.288071] Call Trace:
[  480.288080]  [<ffffffff81114440>] ? __lock_page+0x70/0x70
[  480.288084]  [<ffffffff8162c0af>] schedule+0x3f/0x60
[  480.288087]  [<ffffffff8162c15f>] io_schedule+0x8f/0xd0
[  480.288091]  [<ffffffff8111444e>] sleep_on_page+0xe/0x20
[  480.288094]  [<ffffffff8162a96f>] __wait_on_bit+0x5f/0x90
[  480.288098]  [<ffffffff811145b8>] wait_on_page_bit+0x78/0x80
[  480.288102]  [<ffffffff81070c70>] ? autoremove_wake_function+0x40/0x=
40
[  480.288129]  [<ffffffffa005d161>]
read_extent_buffer_pages+0x471/0x4d0 [btrfs]
[  480.288142]  [<ffffffffa00347b0>] ? verify_parent_transid+0x160/0x16=
0 [btrfs]
[  480.288155]  [<ffffffffa003513a>]
btree_read_extent_buffer_pages.isra.99+0x8a/0xc0 [btrfs]
[  480.288169]  [<ffffffffa00371e1>] read_tree_block+0x41/0x60 [btrfs]
[  480.288179]  [<ffffffffa001d6a3>]
read_block_for_search.isra.34+0xf3/0x3d0 [btrfs]
[  480.288190]  [<ffffffffa001f930>] btrfs_search_slot+0x300/0x8a0 [btr=
fs]
[  480.288203]  [<ffffffffa0031ab4>] btrfs_lookup_csum+0x74/0x170 [btrf=
s]
[  480.288216]  [<ffffffffa0031d5f>] __btrfs_lookup_bio_sums+0x1af/0x3b=
0 [btrfs]
[  480.288228]  [<ffffffffa0031fb6>] btrfs_lookup_bio_sums+0x16/0x20 [b=
trfs]
[  480.288242]  [<ffffffffa003e650>] btrfs_submit_bio_hook+0x140/0x170 =
[btrfs]
[  480.288256]  [<ffffffffa00405d0>] ? btrfs_real_readdir+0x720/0x720 [=
btrfs]
[  480.288272]  [<ffffffffa00571aa>] submit_one_bio+0x6a/0xa0 [btrfs]
[  480.288287]  [<ffffffffa005be64>] extent_readpages+0xe4/0x100 [btrfs=
]
[  480.288301]  [<ffffffffa00405d0>] ? btrfs_real_readdir+0x720/0x720 [=
btrfs]
[  480.288315]  [<ffffffffa003eebf>] btrfs_readpages+0x1f/0x30 [btrfs]
[  480.288319]  [<ffffffff81120bef>] __do_page_cache_readahead+0x1af/0x=
250
[  480.288323]  [<ffffffff81120ff1>] ra_submit+0x21/0x30
[  480.288326]  [<ffffffff81121115>] ondemand_readahead+0x115/0x230
[  480.288330]  [<ffffffff81137eb9>] ? __do_fault+0x419/0x530
[  480.288333]  [<ffffffff81121311>] page_cache_sync_readahead+0x31/0x5=
0
[  480.288337]  [<ffffffff811167d8>] generic_file_aio_read+0x438/0x780
[  480.288342]  [<ffffffff81173db2>] do_sync_read+0xd2/0x110
[  480.288346]  [<ffffffff81294113>] ? security_file_permission+0x93/0x=
b0
[  480.288349]  [<ffffffff81174231>] ? rw_verify_area+0x61/0xf0
[  480.288352]  [<ffffffff81174710>] vfs_read+0xb0/0x180
[  480.288355]  [<ffffffff8117482a>] sys_read+0x4a/0x90
[  480.288359]  [<ffffffff81635229>] system_call_fastpath+0x16/0x1b
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
