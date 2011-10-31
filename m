From: Christian Brunner <chb@muc.de>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Mon, 31 Oct 2011 14:29:44 +0100
Message-ID: <CAO47_-8Enj-mBCYJMAonn8Zc2KWtpfGaEkw6aLRye0VhObn9LQ@mail.gmail.com>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net>
	<CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>
	<Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
	<20111024195147.GB31264@dhcp231-156.rdu.redhat.com>
	<CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
	<20111027195209.GD2329@localhost.localdomain>
	<CAO47_-_bBd5W55P87DQKpjE7CnbjgXXUMR37SgkQQqNwNZxpog@mail.gmail.com>
	<CAO47_-_+Oqs1sHeYEBfxgwugSUYKftQLQ9jEyDgFPFu8fXe34w@mail.gmail.com>
	<CAO47_-8YGAxoYOBRKxLP2HULqEtV5bMugzzybq3srCVFZczgGA@mail.gmail.com>
	<CAO47_-98Sgpo124_F6w13Oi994wUt12PstWyB5N7+QdiYJECEQ@mail.gmail.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Josef Bacik <josef@redhat.com>, Sage Weil <sage@newdream.net>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO47_-98Sgpo124_F6w13Oi994wUt12PstWyB5N7+QdiYJECEQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/10/31 Christian Brunner <chb@muc.de>:
> 2011/10/31 Christian Brunner <chb@muc.de>:
>> 2011/10/31 Christian Brunner <chb@muc.de>:
>>>
>>> The patch didn't hurt, but I've to tell you that I'm still seeing t=
he
>>> same old problems. Load is going up again:
>>>
>>> =A0PID USER =A0 =A0 =A0PR =A0NI =A0VIRT =A0RES =A0SHR S %CPU %MEM =A0=
 =A0TIME+ =A0COMMAND
>>> =A05502 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S 52.5=
 0.0 106:29.97 btrfs-endio-wri
>>> =A01976 root =A0 =A0 =A020 =A0 0 =A0601m 211m 1464 S 28.3 0.9 115:1=
0.62 ceph-osd
>>>
>>> And I have hit our warning again:
>>>
>>> [223560.970713] ------------[ cut here ]------------
>>> [223560.976043] WARNING: at fs/btrfs/inode.c:2118
>>> btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
>>> [223560.985411] Hardware name: ProLiant DL180 G6
>>> [223560.990491] Modules linked in: btrfs zlib_deflate libcrc32c sun=
rpc
>>> bonding ipv6 sg serio_raw pcspkr ghes hed iTCO_wdt iTCO_vendor_supp=
ort
>>> i7core_edac edac_core ixgbe dca mdio iomemory_vsl(P) hpsa squashfs
>>> [last unloaded: scsi_wait_scan]
>>> [223561.014748] Pid: 2079, comm: ceph-osd Tainted: P
>>> 3.0.6-1.fits.9.el6.x86_64 #1
>>> [223561.023874] Call Trace:
>>> [223561.026738] =A0[<ffffffff8106344f>] warn_slowpath_common+0x7f/0=
xc0
>>> [223561.033564] =A0[<ffffffff810634aa>] warn_slowpath_null+0x1a/0x2=
0
>>> [223561.040272] =A0[<ffffffffa0282120>] btrfs_orphan_commit_root+0x=
b0/0xc0 [btrfs]
>>> [223561.048278] =A0[<ffffffffa027ce55>] commit_fs_roots+0xc5/0x1b0 =
[btrfs]
>>> [223561.055534] =A0[<ffffffff8154c231>] ? mutex_lock+0x31/0x60
>>> [223561.061666] =A0[<ffffffffa027ddbe>]
>>> btrfs_commit_transaction+0x3ce/0x820 [btrfs]
>>> [223561.069876] =A0[<ffffffffa027d1b8>] ? wait_current_trans+0x28/0=
x110 [btrfs]
>>> [223561.077582] =A0[<ffffffffa027e325>] ? join_transaction+0x25/0x2=
50 [btrfs]
>>> [223561.085065] =A0[<ffffffff81086410>] ? wake_up_bit+0x40/0x40
>>> [223561.091251] =A0[<ffffffffa025a329>] btrfs_sync_fs+0x59/0xd0 [bt=
rfs]
>>> [223561.098187] =A0[<ffffffffa02abc65>] btrfs_ioctl+0x495/0xd50 [bt=
rfs]
>>> [223561.105120] =A0[<ffffffff8125ed20>] ? inode_has_perm+0x30/0x40
>>> [223561.111575] =A0[<ffffffff81261a2c>] ? file_has_perm+0xdc/0xf0
>>> [223561.117924] =A0[<ffffffff8117086a>] do_vfs_ioctl+0x9a/0x5a0
>>> [223561.124072] =A0[<ffffffff81170e11>] sys_ioctl+0xa1/0xb0
>>> [223561.129842] =A0[<ffffffff81555702>] system_call_fastpath+0x16/0=
x1b
>>> [223561.136699] ---[ end trace 176e8be8996f25f6 ]---
>>
>> [ Not sending this to the lists, as the attachment is large ].
>>
>> I've spent a little time to do some tracing with ftrace. Its output
>> seems to be right (at least as far as I can tell). I hope that its
>> output can give you an insight on whats going on.
>>
>> The interesting PIDs in the trace are:
>>
>> =A05502 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S 33.6 =
0.0 118:28.37 btrfs-endio-wri
>> =A05518 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S 29.3 =
0.0 41:23.58 btrfs-endio-wri
>> =A08059 root =A0 =A0 =A020 =A0 0 =A0400m =A048m 2756 S =A08.0 =A00.2=
 =A0 8:31.56 ceph-osd
>> =A07993 root =A0 =A0 =A020 =A0 0 =A0401m =A041m 2808 S 13.6 =A00.2 =A0=
 7:58.38 ceph-osd
>>
>
> [ adding linux-btrfs again ]
>
> I've been digging into this a bit further:
>
> Attached is another ftrace report that I've filtered for "btrfs_*"
> calls and limited to CPU0 (this is where PID 5502 was running).
>
> From what I can see there is a lot of time consumed in
> btrfs_reserve_extent(). I this normal?

Sorry for spamming, but in the meantime I'm almost certain that the
problem is inside find_free_extent (called from btrfs_reserve_extent).

When I'm running ftrace for a sample period of 10s my system is
wasting a total of 4,2 seconds inside find_free_extent(). Each call to
find_free_extent() is taking an average of 4 milliseconds to complete.
On a recently rebooted system this is only 1-2 us!

I'm not sure if the problem is occurring suddenly or slowly over time.
(At the moment I suspect that its occurring suddenly, but I still have
to investigate this).

Thanks,
Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
