From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs hang (deadlock?) when trying to create a ext4 filesystem in KVM guest
Date: Wed, 15 Dec 2010 13:58:36 -0500
Message-ID: <1292439477-sup-45@think>
References: <4CC82942.1020101@wpkg.org> <20101027225541.GT27796@think> <4CC91847.6020205@wpkg.org> <AANLkTi=akhom2yq63Gm6WOvWKAciOOCYPAp-Rr0tcgU9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTi=akhom2yq63Gm6WOvWKAciOOCYPAp-Rr0tcgU9@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from C Anthony Risinger's message of 2010-12-15 11:46:11 -0500=
:
> On Thu, Oct 28, 2010 at 1:29 AM, Tomasz Chmielewski <mangoo@wpkg.org>=
 wrote:
> > On 28.10.2010 00:55, Chris Mason wrote:
> >> On Wed, Oct 27, 2010 at 03:29:38PM +0200, Tomasz Chmielewski wrote=
:
> >>> There are a couple of problems when running KVM guests with image=
s stored on btrfs filesystem.
> >>>
> >>> One of them is inability to create a filesystem (i.e. ext4) in th=
e guest:
> >>>
> >>> - btrfs filesystem on the host was mounted with noatime,compress-=
force
> >>> - guest was using a 50 GB sparse file,
> >>> - attempt to create a ext4 filesystem within the guest does not s=
ucceed (hangs); host prints below messages in dmesg - some deadlock in =
btrfs?
> >>>
> >>> kernel: 2.6.36
> >>> qemu-kvm: 0.13.0
> >>
> >> Is this the full dmesg output? =C2=A0I think there are other messa=
ges hiding
> >> in there.
> >
> > There were indeed "bad ordered accounting left" (see below), I thin=
k they are coming from btrfs?
> >
> >
> >> Is this a single disk btrfs?
> >
> > Yes.
> >
> >
> >
> > [ 8072.773053] device fsid 1142843480ad2d13-4bdc742fd9b1f7b0 devid =
1 transid 1508 /dev/sdb4
> > [ 8072.773674] btrfs: forcing compression
> > [ 8122.052221] device tap0 entered promiscuous mode
> > [ 8122.052245] br0: port 2(tap0) entering learning state
> > [ 8122.052248] br0: port 2(tap0) entering learning state
> > [ 8122.451587] br0: port 2(tap0) entering learning state
> > [ 8122.543477] br0: port 2(tap0) entering disabled state
> > [ 8122.609645] device tap0 left promiscuous mode
> > [ 8122.609650] br0: port 2(tap0) entering disabled state
> > [ 8131.325647] EXT4-fs (md4): recovery complete
> > [ 8131.325809] EXT4-fs (md4): mounted filesystem with ordered data =
mode. Opts: (null)
> > [ 8133.392100] device tap0 entered promiscuous mode
> > [ 8133.392127] br0: port 2(tap0) entering learning state
> > [ 8133.392131] br0: port 2(tap0) entering learning state
> > [ 8134.106594] kvm: 5004: cpu0 unhandled wrmsr: 0x198 data 0
> > [ 8134.106618] kvm: 5004: cpu1 unhandled wrmsr: 0x198 data 0
> > [ 8143.460927] tap0: no IPv6 routers present
> > [ 8148.359485] br0: port 2(tap0) entering forwarding state
> > [ 8309.103502] bad ordered accounting left 65536 size 385024
> > [ 8309.106206] bad ordered accounting left 65536 size 385024
> > [ 8309.108915] bad ordered accounting left 65536 size 385024
> > [ 8309.111630] bad ordered accounting left 36864 size 385024
> > [ 8501.965625] INFO: task qemu-system-x86:5148 blocked for more tha=
n 120 seconds.
> > [ 8501.965629] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
> > [ 8501.965632] qemu-system-x D ffff880001e14cc0 =C2=A0 =C2=A0 0 =C2=
=A05148 =C2=A0 4924 0x00000000
> > [ 8501.965638] =C2=A0ffff880223bc3b38 0000000000000086 ffff880223bc=
3fd8 0000000000014cc0
> > [ 8501.965642] =C2=A00000000000014cc0 ffff880223bc3fd8 000000000001=
4cc0 ffff880223bc3fd8
> > [ 8501.965647] =C2=A00000000000014cc0 ffff880221965f18 ffff88022196=
5f20 ffff880221965b80
> > [ 8501.965651] Call Trace:
> > [ 8501.965678] =C2=A0[<ffffffffa024c52c>] btrfs_start_ordered_exten=
t+0x6c/0xb0 [btrfs]
> > [ 8501.965685] =C2=A0[<ffffffff81083200>] ? autoremove_wake_functio=
n+0x0/0x40
> > [ 8501.965701] =C2=A0[<ffffffffa024d1c2>] btrfs_wait_ordered_range+=
0xd2/0x160 [btrfs]
> > [ 8501.965716] =C2=A0[<ffffffffa0240059>] btrfs_file_aio_write+0x26=
9/0x990 [btrfs]
> > [ 8501.965721] =C2=A0[<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3=
f0
> > [ 8501.965726] =C2=A0[<ffffffff81168119>] ? __pollwake+0x49/0x50
> > [ 8501.965730] =C2=A0[<ffffffff8105cd90>] ? default_wake_function+0=
x0/0x20
> > [ 8501.965733] =C2=A0[<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3=
f0
> > [ 8501.965737] =C2=A0[<ffffffff8116813b>] ? pollwake+0x1b/0x20
> > [ 8501.965752] =C2=A0[<ffffffffa023fdf0>] ? btrfs_file_aio_write+0x=
0/0x990 [btrfs]
> > [ 8501.965761] =C2=A0[<ffffffff8115664b>] do_sync_readv_writev+0xcb=
/0x110
> > [ 8501.965769] =C2=A0[<ffffffff81294d98>] ? apparmor_file_permissio=
n+0x18/0x20
> > [ 8501.965776] =C2=A0[<ffffffff8126356e>] ? security_file_permissio=
n+0x1e/0x80
> > [ 8501.965781] =C2=A0[<ffffffff811576e0>] do_readv_writev+0xd0/0x1d=
0
> > [ 8501.965787] =C2=A0[<ffffffff81076d72>] ? kill_something_info+0x4=
2/0x130
> > [ 8501.965793] =C2=A0[<ffffffff81076ee0>] ? sys_kill+0x80/0x90
> > [ 8501.965798] =C2=A0[<ffffffff8115781e>] vfs_writev+0x3e/0x60
> > [ 8501.965802] =C2=A0[<ffffffff811578e7>] sys_pwritev+0xa7/0xc0
> > [ 8501.965806] =C2=A0[<ffffffff8100b0f2>] system_call_fastpath+0x16=
/0x1b
> > [ 8501.965810] INFO: task qemu-system-x86:5150 blocked for more tha=
n 120 seconds.
> > [ 8501.965812] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
> > [ 8501.965814] qemu-system-x D ffff880001e94cc0 =C2=A0 =C2=A0 0 =C2=
=A05150 =C2=A0 4924 0x00000000
> > [ 8501.965819] =C2=A0ffff8801aba4bb38 0000000000000086 ffff8801aba4=
bfd8 0000000000014cc0
> > [ 8501.965823] =C2=A00000000000014cc0 ffff8801aba4bfd8 000000000001=
4cc0 ffff8801aba4bfd8
> > [ 8501.965827] =C2=A00000000000014cc0 ffff880226d14838 ffff880226d1=
4840 ffff880226d144a0
> > [ 8501.965832] Call Trace:
> > [ 8501.965847] =C2=A0[<ffffffffa024c52c>] btrfs_start_ordered_exten=
t+0x6c/0xb0 [btrfs]
> > [ 8501.965852] =C2=A0[<ffffffff81083200>] ? autoremove_wake_functio=
n+0x0/0x40
> > [ 8501.965867] =C2=A0[<ffffffffa024d1c2>] btrfs_wait_ordered_range+=
0xd2/0x160 [btrfs]
> > [ 8501.965883] =C2=A0[<ffffffffa0240059>] btrfs_file_aio_write+0x26=
9/0x990 [btrfs]
> > [ 8501.965887] =C2=A0[<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3=
f0
> > [ 8501.965891] =C2=A0[<ffffffff81168119>] ? __pollwake+0x49/0x50
> > [ 8501.965894] =C2=A0[<ffffffff8105cd90>] ? default_wake_function+0=
x0/0x20
> > [ 8501.965897] =C2=A0[<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3=
f0
> > [ 8501.965901] =C2=A0[<ffffffff8116813b>] ? pollwake+0x1b/0x20
> > [ 8501.965916] =C2=A0[<ffffffffa023fdf0>] ? btrfs_file_aio_write+0x=
0/0x990 [btrfs]
> > [ 8501.965920] =C2=A0[<ffffffff8115664b>] do_sync_readv_writev+0xcb=
/0x110
> > [ 8501.965924] =C2=A0[<ffffffff81076736>] ? send_signal+0x56/0xa0
> > [ 8501.965928] =C2=A0[<ffffffff81294d98>] ? apparmor_file_permissio=
n+0x18/0x20
> > [ 8501.965932] =C2=A0[<ffffffff8126356e>] ? security_file_permissio=
n+0x1e/0x80
> > [ 8501.965936] =C2=A0[<ffffffff811576e0>] do_readv_writev+0xd0/0x1d=
0
> > [ 8501.965940] =C2=A0[<ffffffff8115781e>] vfs_writev+0x3e/0x60
> > [ 8501.965943] =C2=A0[<ffffffff811578e7>] sys_pwritev+0xa7/0xc0
> > [ 8501.965946] =C2=A0[<ffffffff8100b0f2>] system_call_fastpath+0x16=
/0x1b
> > [ 8501.965950] INFO: task qemu-system-x86:5151 blocked for more tha=
n 120 seconds.
> > [ 8501.965952] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
> > [ 8501.965954] qemu-system-x D ffff880001e94cc0 =C2=A0 =C2=A0 0 =C2=
=A05151 =C2=A0 4924 0x00000000
> > [ 8501.965958] =C2=A0ffff88021923fb38 0000000000000086 ffff88021923=
ffd8 0000000000014cc0
> > [ 8501.965963] =C2=A00000000000014cc0 ffff88021923ffd8 000000000001=
4cc0 ffff88021923ffd8
> > [ 8501.965967] =C2=A00000000000014cc0 ffff880226d13158 ffff880226d1=
3160 ffff880226d12dc0
> > [ 8501.965971] Call Trace:
> > [ 8501.965986] =C2=A0[<ffffffffa024c52c>] btrfs_start_ordered_exten=
t+0x6c/0xb0 [btrfs]
> > [ 8501.965990] =C2=A0[<ffffffff81083200>] ? autoremove_wake_functio=
n+0x0/0x40
> > [ 8501.966005] =C2=A0[<ffffffffa024d1c2>] btrfs_wait_ordered_range+=
0xd2/0x160 [btrfs]
> > [ 8501.966021] =C2=A0[<ffffffffa0240059>] btrfs_file_aio_write+0x26=
9/0x990 [btrfs]
> > [ 8501.966025] =C2=A0[<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3=
f0
> > [ 8501.966029] =C2=A0[<ffffffff81168119>] ? __pollwake+0x49/0x50
> > [ 8501.966032] =C2=A0[<ffffffff8105cd90>] ? default_wake_function+0=
x0/0x20
> > [ 8501.966036] =C2=A0[<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3=
f0
> > [ 8501.966039] =C2=A0[<ffffffff8116813b>] ? pollwake+0x1b/0x20
> > [ 8501.966054] =C2=A0[<ffffffffa023fdf0>] ? btrfs_file_aio_write+0x=
0/0x990 [btrfs]
> > [ 8501.966058] =C2=A0[<ffffffff8115664b>] do_sync_readv_writev+0xcb=
/0x110
> > [ 8501.966062] =C2=A0[<ffffffff81076736>] ? send_signal+0x56/0xa0
> > [ 8501.966066] =C2=A0[<ffffffff81294d98>] ? apparmor_file_permissio=
n+0x18/0x20
> > [ 8501.966070] =C2=A0[<ffffffff8126356e>] ? security_file_permissio=
n+0x1e/0x80
> > [ 8501.966074] =C2=A0[<ffffffff811576e0>] do_readv_writev+0xd0/0x1d=
0
> > [ 8501.966078] =C2=A0[<ffffffff8115781e>] vfs_writev+0x3e/0x60
> > [ 8501.966081] =C2=A0[<ffffffff811578e7>] sys_pwritev+0xa7/0xc0
> > [ 8501.966084] =C2=A0[<ffffffff8100b0f2>] system_call_fastpath+0x16=
/0x1b
>=20
> i decided to revive this thread because i'm getting the identical
> problem on a near identical setup, but im NOT using compression, only
> nodatacow/noatime.
>=20
> ) 2.6.36.2 kernel
> ) qemu-kvm 0.13.0
> ) kvm-amd
> ) 8.0GB raw image file:
>=20
> # uname -a
> Linux extofme-w0 2.6.36-ARCH #1 SMP PREEMPT Fri Dec 10 20:32:37 CET
> 2010 x86_64 AMD Athlon(tm) II X3 435 Processor AuthenticAMD GNU/Linux
>=20
> # mount -t btrfs
> ...
> /dev/sda3 on /var/lib/libvirt/images type btrfs (rw,noatime,nodatacow=
)
> ...
>=20
> # pacman -Qi qemu-kvm
> Name           : qemu-kvm
> Version        : 0.13.0-1
> ...
>=20
> (qemu command generated by libvirt [winXPPro])
> /usr/bin/qemu-kvm -S -M pc-0.13 -enable-kvm -m 1024 -smp
> 3,sockets=3D3,cores=3D1,threads=3D1 -name XPPro -uuid
> ed78cc76-006f-b408-b8f6-f1f30be43589 -nodefconfig -nodefaults -charde=
v
> socket,id=3Dmonitor,path=3D/var/lib/libvirt/qemu/XPPro.monitor,server=
,nowait
> -mon chardev=3Dmonitor,mode=3Dcontrol -rtc base=3Dlocaltime -no-reboo=
t -boot
> c -drive file=3D/var/lib/libvirt/images/XPPro.img,if=3Dnone,id=3Ddriv=
e-ide0-0-0,format=3Draw,cache=3Dnone
> -device ide-drive,bus=3Dide.0,unit=3D0,drive=3Ddrive-ide0-0-0,id=3Did=
e0-0-0
> -drive file=3D/mnt/Backups/Disk Images/Windows XP
> Professional.iso,if=3Dnone,media=3Dcdrom,id=3Ddrive-ide0-1-0,readonly=
=3Don,format=3Draw
> -device ide-drive,bus=3Dide.1,unit=3D0,drive=3Ddrive-ide0-1-0,id=3Did=
e0-1-0
> -netdev tap,fd=3D41,id=3Dhostnet0 -device
> rtl8139,netdev=3Dhostnet0,id=3Dnet0,mac=3D52:54:00:8e:e4:14,bus=3Dpci=
=2E0,addr=3D0x3
> -chardev pty,id=3Dserial0 -device isa-serial,chardev=3Dserial0 -usb
> -device usb-tablet,id=3Dinput0 -vnc 127.0.0.1:0 -vga cirrus -device
> AC97,id=3Dsound0,bus=3Dpci.0,addr=3D0x4 -device
> virtio-balloon-pci,id=3Dballoon0,bus=3Dpci.0,addr=3D0x5
>=20
> ----------------------[dmesg]-------------------------
> bad ordered accounting left 4096 size 57344
> INFO: task qemu-kvm:6451 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this mess=
age.
> qemu-kvm      D 00000001000850d5     0  6451      1 0x00000000
>  ffff880008d7bb38 0000000000000086 ffff880008d7baa8 ffff880008d7bfd8
>  ffff880008d7a000 ffff8800089df5f0 ffff880008d7bfd8 ffff880008d7bfd8
>  ffff8800089df8b0 ffff880008d7bfd8 ffff880008d7a000 0000000000014400
> Call Trace:
>  [<ffffffff81075ddb>] ? prepare_to_wait+0x5b/0x90
>  [<ffffffffa023a225>] btrfs_start_ordered_extent+0x75/0xc0 [btrfs]
>  [<ffffffff81075b40>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffffa023a819>] btrfs_wait_ordered_range+0xb9/0x150 [btrfs]
>  [<ffffffffa022b650>] ? btrfs_file_aio_write+0x0/0x9a0 [btrfs]
>  [<ffffffffa022bb82>] btrfs_file_aio_write+0x532/0x9a0 [btrfs]
>  [<ffffffff81079b6a>] ? hrtimer_cancel+0x1a/0x30
>  [<ffffffff810877c2>] ? futex_wait+0x222/0x380
>  [<ffffffffa022b650>] ? btrfs_file_aio_write+0x0/0x9a0 [btrfs]
>  [<ffffffff8112e3fb>] do_sync_readv_writev+0xcb/0x110
>  [<ffffffff8106882b>] ? do_send_sig_info+0x6b/0x90
>  [<ffffffff811b0844>] ? security_file_permission+0x24/0xa0
>  [<ffffffff8112e6af>] do_readv_writev+0xcf/0x1e0
>  [<ffffffff81068bfa>] ? kill_pid_info+0x4a/0xa0
>  [<ffffffff81069f84>] ? sys_kill+0xa4/0x1f0
>  [<ffffffff8112e800>] vfs_writev+0x40/0x50
>  [<ffffffff8112eb0a>] sys_pwritev+0x9a/0xb0
>  [<ffffffff81155ca0>] ? do_fsync+0x40/0x60
>  [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
> (... repeated every 120s ...)
> ----------------------[dmesg]-------------------------
>=20
> any idea what's happening here, or anything i can try/test?  seems to
> happen consistently within about 2-4min of starting the window xp
> installation.

I think these are fixed up in the current btrfs git tree.  2.6.37-rcX
has the fixes, and you can pull from the git tree for 2.6.36.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
