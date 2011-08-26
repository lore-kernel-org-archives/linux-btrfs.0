From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: WARNING in -rc3-00023-g14c62e7
Date: Fri, 26 Aug 2011 15:59:54 -0500
Message-ID: <CAKcLGm8BDyUP7XeNVFusuVOW0fG9LcH6dV1a3jBmpN9U1FHkCA@mail.gmail.com>
References: <201108252117.04108.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: diegocg@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201108252117.04108.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 25, 2011 at 2:17 PM, Diego Calleja <diegocg@gmail.com> wrot=
e:
> This is what I got in my dmesg...I have lots of these warnings, didn'=
t
> notice it until now.
>
> [ =A0235.705766] ------------[ cut here ]------------
> [ =A0235.705772] WARNING: at fs/inode.c:1309 iput+0x1ed/0x210()
> [ =A0235.705773] Hardware name:
> [ =A0235.705774] Modules linked in: ipt_REJECT xt_tcpudp nf_conntrack=
_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_t=
ables snd_hda_codec_hdmi snd_hda_codec_realtek wacom snd_hda_intel snd_=
hda_codec snd_pcm snd_timer snd soundcore e1000e i2c_i801 snd_page_allo=
c virtio_net virtio virtio_ring kvm_intel kvm [last unloaded: scsi_wait=
_scan]
> [ =A0235.705788] Pid: 3203, comm: btrfs-cleaner Not tainted 3.1.0-rc3=
-00023-g14c62e7 #4
> [ =A0235.705789] Call Trace:
> [ =A0235.705794] =A0[<ffffffff8104bbcf>] warn_slowpath_common+0x7f/0x=
c0
> [ =A0235.705796] =A0[<ffffffff8104bc2a>] warn_slowpath_null+0x1a/0x20
> [ =A0235.705797] =A0[<ffffffff8116922d>] iput+0x1ed/0x210
> [ =A0235.705800] =A0[<ffffffff8123b3ac>] btrfs_iget+0x1cc/0x460
> [ =A0235.705804] =A0[<ffffffff815dbc56>] ? _raw_spin_unlock+0x16/0x40
> [ =A0235.705807] =A0[<ffffffff8123f8ce>] btrfs_run_defrag_inodes+0x12=
e/0x210
> [ =A0235.705809] =A0[<ffffffff8122a09b>] cleaner_kthread+0x18b/0x1a0
> [ =A0235.705811] =A0[<ffffffff815dbe0a>] ? _raw_spin_unlock_irqrestor=
e+0x2a/0x60
> [ =A0235.705813] =A0[<ffffffff81229f10>] ? transaction_kthread+0x290/=
0x290
> [ =A0235.705815] =A0[<ffffffff8106e42c>] kthread+0x8c/0xa0
> [ =A0235.705818] =A0[<ffffffff815e51f4>] kernel_thread_helper+0x4/0x1=
0
> [ =A0235.705820] =A0[<ffffffff81037cde>] ? finish_task_switch+0x4e/0x=
e0
> [ =A0235.705822] =A0[<ffffffff815dbc9c>] ? _raw_spin_unlock_irq+0x1c/=
0x40
> [ =A0235.705824] =A0[<ffffffff815dc64e>] ? retint_restore_args+0xe/0x=
e
> [ =A0235.705826] =A0[<ffffffff8106e3a0>] ? kthread_worker_fn+0x190/0x=
190
> [ =A0235.705828] =A0[<ffffffff815e51f0>] ? gs_change+0xb/0xb
> [ =A0235.705829] ---[ end trace 522a9ae26c065662 ]---

Do you have autodefrag enabled?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
