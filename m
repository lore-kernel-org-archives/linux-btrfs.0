From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: flood of btrfs WARNINGs in dmesg
Date: Mon, 4 Oct 2010 15:37:08 +0200
Message-ID: <AANLkTiksQ32W_rReaLXwp+McOQX-+d287PM=OTCCewb-@mail.gmail.com>
References: <4CA9D46D.6060309@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CA9D46D.6060309@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 4 October 2010 15:19, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> With 2.6.35.x, I saw warnings like below in dmesg.
>
> With 2.6.36-rc6, I even had a flood of them. Is it something to worry=
 about? What causes it?
>
> You can see more of these under http://www.virtall.com/files/dmesg-bt=
rfs-flood.txt
>
>
> [74921.736528] ------------[ cut here ]------------
> [74921.736597] WARNING: at /home/kernel-ppa/COD/linux/fs/fs-writeback=
=2Ec:87 __mark_inode_dirty+0x217/0x250()
> [74921.736604] Hardware name: Bochs
> [74921.736606] Dirtiable inode bdi default !=3D sb bdi btrfs
> [74921.736611] Modules linked in: btrfs zlib_deflate crc32c libcrc32c=
 lp parport psmouse serio_raw i2c_piix4 virtio_net floppy virtio_blk vi=
rtio_pci virtio_ring virtio
> [74921.736635] Pid: 22522, comm: rsync Not tainted 2.6.36-020636rc6-g=
eneric #201009291126
> [74921.736638] Call Trace:
> [74921.736649] =C2=A0[<ffffffff8117aa77>] ? __mark_inode_dirty+0x217/=
0x250
> [74921.736678] =C2=A0[<ffffffff81062730>] warn_slowpath_common+0x90/0=
xc0
> [74921.736683] =C2=A0[<ffffffff8106285e>] warn_slowpath_fmt+0x6e/0x70
> [74921.736712] =C2=A0[<ffffffffa00c4128>] ? __btrfs_end_transaction+0=
x128/0x210 [btrfs]
> [74921.736727] =C2=A0[<ffffffffa00c4240>] ? btrfs_end_transaction+0x1=
0/0x20 [btrfs]
> [74921.736744] =C2=A0[<ffffffffa00c72fc>] ? btrfs_dirty_inode+0x7c/0x=
120 [btrfs]
> [74921.736781] =C2=A0[<ffffffff8158835e>] ? _raw_spin_lock+0xe/0x20
> [74921.736785] =C2=A0[<ffffffff8117aa77>] __mark_inode_dirty+0x217/0x=
250
> [74921.736804] =C2=A0[<ffffffffa00ced98>] btrfs_setattr+0x78/0xb0 [bt=
rfs]
> [74921.736814] =C2=A0[<ffffffff8116ee70>] notify_change+0x170/0x2d0
> [74921.736824] =C2=A0[<ffffffff8117e9bb>] utimes_common+0xdb/0x1a0
> [74921.736829] =C2=A0[<ffffffff8117eb2a>] do_utimes+0xaa/0x110
> [74921.736833] =C2=A0[<ffffffff8117ed16>] sys_futimesat+0x36/0xd0
> [74921.736837] =C2=A0[<ffffffff8117edc9>] sys_utimes+0x19/0x20
> [74921.736854] =C2=A0[<ffffffff8100b0f2>] system_call_fastpath+0x16/0=
x1b
> [74921.736870] ---[ end trace 7c45187572db04d2 ]---
>
>
>
> --
> Tomasz Chmielewski
> http://wpkg.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

I have also had a lot of these with .36. I don't know why. I'm running
on a laptop which has never been shut down with an improper umount as
far as I can remember. Mount options are
"noatime,noacl,compress-force,thread_pool=3D4,nobarrier"
Nothing on .35

Regards,
Sebastian J.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
