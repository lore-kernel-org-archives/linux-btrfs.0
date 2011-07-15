From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: corruption. notreelog has no effect? anything else to try?
Date: Sat, 16 Jul 2011 05:19:49 +0700
Message-ID: <CAG1y0sc-D1-5zkgsovtZG6emOc78GoZ64gQ1Lhufm=6Z3huEAg@mail.gmail.com>
References: <1310763102.3972.31.camel@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310763102.3972.31.camel@ubuntu>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 16, 2011 at 3:51 AM, mck <mick@wever.org> wrote:
> My laptop btrfs partition has become corrupt after a power+battery
> outage.
>
> # btrfs-show
> Label: none =A0uuid: e7b37e5d-c704-4ca8-ae7e-f22dd063e165
> =A0 =A0 =A0 =A0Total devices 1 FS bytes used 116.33GB
> =A0 =A0 =A0 =A0devid =A0 =A01 size 226.66GB used 226.66GB path /dev/s=
da4
>
> I typically mount w/
> =A0 =A0 =A0 =A0-o subvol=3Dxyz,compress,noatime,nodiratime
> =A0and take snapshots of (some) subvolumes at every boot.
> =A0(not that these snapshots seem to be of much use now).
>
> Now:
> btrfsck gives loads of "root x inode y errors 400" and finishes w/
> =A0 =A0found 124906840074 bytes used err is 1
> =A0 =A0total csum bytes: 117696892
> =A0 =A0total tree bytes: 4385128448
> =A0 =A0total fs tree bytes: 3926626304
> =A0 =A0btree space waste bytes: 1078295916
> =A0 =A0file data blocks allocated: 3619739602944
> =A0 =A0 referenced 162976624640
> =A0 =A0Btrfs Btrfs v0.19
>

does btrfsck -s1 complete without error? If yes, you can try btrfs-sele=
ct-super.

>
> mounting always results in the crash
>
> [ 6977.513528] Call Trace:
> [ 6977.513542] =A0[<ffffffffa057ac18>] replay_one_dir_item+0x88/0xb0 =
[btrfs]
> [ 6977.513557] =A0[<ffffffffa057d5b3>] replay_one_buffer+0x223/0x330 =
[btrfs]
> [ 6977.513573] =A0[<ffffffffa056a8ba>] ? alloc_extent_buffer+0x7a/0x4=
20 [btrfs]
> [ 6977.513584] =A0[<ffffffffa057c139>] walk_down_log_tree+0x339/0x480=
 [btrfs]
> [ 6977.513595] =A0[<ffffffffa057c375>] walk_log_tree+0xf5/0x230 [btrf=
s]
> [ 6977.513606] =A0[<ffffffffa057f1c1>] btrfs_recover_log_trees+0x221/=
0x310 [btrfs]

if there's something mentioning "log", I'd try btrfs-zero-log first.
It's not built by default, so you should run "make btrfs-zero-log" on
btrfs-tools source directory.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
