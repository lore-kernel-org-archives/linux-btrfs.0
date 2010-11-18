From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Interesting problem with write data.
Date: Thu, 18 Nov 2010 13:03:31 +0100
Message-ID: <4CE51613.8060609@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>   Recently, I made a btrfs to use. And I met slowness problem. Trying
> to diag it. I found this:
> 1. dd if=3D/dev/zero of=3Dtest count=3D1024 bs=3D1MB
> This is fast, at about 25MB/s, and reasonable iowait.
> 2. dd if=3D/dev/zero of=3Dtest count=3D1 bs=3D1GB
> This is pretty slow, at about 1.5MB/s, and 90%+ iowait, constantly.
>   May I know why it works like this? Thanks.

Reproducible here to some extent with 2.6.37-rc2.

Interesting is, it only happens for me when I mount the filesystem, dd =
a smaller file, then a bigger one, in that order.

Any subsequent dd / sync / rm usage doesn't seem to trigger it anymore =
(have to umount / mount again to trigger this).


# mount -o noatime /dev/sdb4 /mnt/btrfs/

That's a system with 24 GB RAM, so everything was cached this time:

# dd if=3D/dev/zero of=3D/mnt/btrfs/bigfile bs=3D1M count=3D1024
1024+0 Datens=C3=A4tze ein
1024+0 Datens=C3=A4tze aus
1073741824 Bytes (1,1 GB) kopiert, 0,367902 s, 2,9 GB/s


Let's try again with 2 GB being written to the same file as previously:

# dd if=3D/dev/zero of=3D/mnt/btrfs/bigfile bs=3D1M count=3D2048


iostat shows nothing is being written, file size is the same (reproduci=
bly gets stuck at around 1828716544, 1827667968 or similar bytes) and d=
oesn't grow for a few minutes.
Although no data is written (as shown by iostat), wa is around 25%.
Later on, it finishes:

2048+0 Datens=C3=A4tze ein
2048+0 Datens=C3=A4tze aus
2147483648 Bytes (2,1 GB) kopiert, 188,062 s, 11,4 MB/s


If we remove the file, umount the filesystem, mount again, write a 1 GB=
 file with dd, then want to overwrite it with a 10 GB file, it also get=
s stuck at about 1.8 GB.
It waits there for a few minutes; later, it seem to write the remaining=
 data with full disk speed.



dmesg shows this:

[ 1201.423991] INFO: task btrfs-transacti:2931 blocked for more than 12=
0 seconds.
[ 1201.423993] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
[ 1201.423995] btrfs-transac D ffff880596610398     0  2931      2 0x00=
000000
[ 1201.423997]  ffff88059660bac0 0000000000000046 9a5a9a5a10651065 ffff=
88059660bfd8
[ 1201.424000]  00000000000139c0 00000000000139c0 ffff88059660bfd8 ffff=
88059660bfd8
[ 1201.424002]  00000000000139c0 ffff880596610398 ffff8805966103a0 ffff=
880596610000
[ 1201.424004] Call Trace:
[ 1201.424010]  [<ffffffff8159fc4e>] io_schedule+0x5e/0xa0
[ 1201.424013]  [<ffffffff81109f15>] sync_page+0x45/0x60
[ 1201.424016]  [<ffffffff815a03da>] __wait_on_bit_lock+0x5a/0xb0
[ 1201.424017]  [<ffffffff81109ed0>] ? sync_page+0x0/0x60
[ 1201.424019]  [<ffffffff81109e9a>] __lock_page+0x6a/0x80
[ 1201.424022]  [<ffffffff81085e40>] ? wake_bit_function+0x0/0x40
[ 1201.424025]  [<ffffffff81115277>] ? pagevec_lookup_tag+0x27/0x40
[ 1201.424042]  [<ffffffffa023e8c3>] extent_write_cache_pages+0x1a3/0x2=
d0 [btrfs]
[ 1201.424051]  [<ffffffffa023e370>] ? flush_write_bio+0x0/0x10 [btrfs]
[ 1201.424058]  [<ffffffffa02425a0>] ? __extent_writepage+0x0/0x610 [bt=
rfs]
[ 1201.424067]  [<ffffffffa023ea44>] extent_writepages+0x54/0x70 [btrfs=
]
[ 1201.424074]  [<ffffffffa022c210>] ? btrfs_get_extent+0x0/0x830 [btrf=
s]
[ 1201.424082]  [<ffffffffa0223a88>] btrfs_writepages+0x28/0x30 [btrfs]
[ 1201.424084]  [<ffffffff81114261>] do_writepages+0x21/0x40
[ 1201.424086]  [<ffffffff8110a4de>] __filemap_fdatawrite_range+0x5e/0x=
70
[ 1201.424088]  [<ffffffff8110aa2c>] filemap_flush+0x1c/0x20
[ 1201.424096]  [<ffffffffa023dd52>] btrfs_run_ordered_operations+0x192=
/0x200 [btrfs]
[ 1201.424104]  [<ffffffffa02220e5>] ? start_transaction+0xe5/0x210 [bt=
rfs]
[ 1201.424111]  [<ffffffffa0221791>] btrfs_commit_transaction+0x71/0x62=
0 [btrfs]
[ 1201.424114]  [<ffffffff815a067e>] ? mutex_lock+0x1e/0x50
[ 1201.424116]  [<ffffffff81085e00>] ? autoremove_wake_function+0x0/0x4=
0
[ 1201.424123]  [<ffffffffa021c4f2>] transaction_kthread+0x242/0x250 [b=
trfs]
[ 1201.424130]  [<ffffffffa021c2b0>] ? transaction_kthread+0x0/0x250 [b=
trfs]
[ 1201.424132]  [<ffffffff81085727>] kthread+0x97/0xa0
[ 1201.424135]  [<ffffffff8100cf24>] kernel_thread_helper+0x4/0x10
[ 1201.424137]  [<ffffffff81085690>] ? kthread+0x0/0xa0
[ 1201.424139]  [<ffffffff8100cf20>] ? kernel_thread_helper+0x0/0x10





--=20
Tomasz Chmielewski
http://wpkg.org

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
