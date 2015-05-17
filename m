Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:34141 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbbEQE6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 May 2015 00:58:17 -0400
Received: by laat2 with SMTP id t2so175460889laa.1
        for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2015 21:58:15 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 17 May 2015 06:58:15 +0200
Message-ID: <CAHz1FYgcm1vSwW0uuoz7hikR83VMao-2ZNeZUSNDN_nVRgnfUw@mail.gmail.com>
Subject: Read ok, write extremely slow and doesn't finish
From: Ingo Ruhnke <grumbel@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have here a 2TB Verbatim USB2 HDD, partitioned with LVM and
containing a single logical volume with a BTRFS filesystem.

When I read from the filesystem everything is working fine, I can
access all the files. I can "btrfs scrub" the whole drive without any
errors and "btrfs check" can't find anything either.

However when I try to write anything beyond a few KB onto the drive or
try a "btrfs balance" or "btrfs fi resize", the write gets extremely
slow (<100KB/s) or things just freeze. dmesg is getting filled with
call traces from btrfs and a call to "sync" will take 5-10 minutes to
complete, if it completes at all.

I did a non-destrictive read/write scan of the drive with:

badblocks -nvs /dev/vg_verbatim2tb/btrfs

And that worked fine as well, so it seems like the btrfs on there
corrupted in some way that "btrfs check" can't detect.


$ sudo pvdisplay -C
  PV         VG             Fmt  Attr PSize   PFree
  /dev/sdc1  vg_verbatim2tb lvm2 a--  698.49g    0
  /dev/sdc5  vg_verbatim2tb lvm2 a--  698.49g    0
  /dev/sdc6  vg_verbatim2tb lvm2 a--  466.04g    0

$ sudo lvdisplay -C --units G
  LV    VG             Attr       LSize    Pool Origin Data%  Meta%
Move Log Cpy%Sync Convert
  btrfs vg_verbatim2tb -wi-ao---- 2000.39G

$ sudo btrfs fi show verbatim2tb
Label: 'verbatim2tb'  uuid: 08be16cd-91cd-432d-ace3-955557ba7a01
    Total devices 1 FS bytes used 1.01TiB
    devid    1 size 1.81TiB used 1.02TiB path /dev/mapper/vg_verbatim2tb-btrfs

Btrfs v3.17

$   uname -a
Linux pen 3.19.0-16-generic #16-Ubuntu SMP Thu Apr 30 16:13:00 UTC
2015 i686 i686 i686 GNU/Linux


 277.135042] BTRFS info (device dm-0): disk space caching is enabled
[  600.112047] INFO: task kworker/u8:8:148 blocked for more than 120 seconds.
[  600.112056]       Tainted: P           OE  3.19.0-16-generic #16-Ubuntu
[  600.112059] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  600.112063] kworker/u8:8    D f88018fd     0   148      2 0x00000000
[  600.112116] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  600.112120]  f597fddc 00000046 f8802a01 f88018fd 00000038 c1b70380
d1fc0a20 00000001
[  600.112129]  c1b70380 e3f64600 00000066 e3f64600 00000066 f67ad380
f5971260 00000000
[  600.112138]  df6f2b60 00000000 f597fdfc f88034a7 0000020a 00000000
2865cfff 000001cc
[  600.112147] Call Trace:
[  600.112180]  [<f8802a01>] ? free_extent_state+0x41/0x90 [btrfs]
[  600.112207]  [<f88018fd>] ? alloc_extent_state+0x1d/0xb0 [btrfs]
[  600.112236]  [<f88034a7>] ? __set_extent_bit+0x4d7/0x800 [btrfs]
[  600.112245]  [<c109a77b>] ? prepare_to_wait_event+0x6b/0xe0
[  600.112251]  [<c16eb6c3>] schedule+0x23/0x60
[  600.112275]  [<f87e20af>] wait_current_trans.isra.19+0x8f/0xf0 [btrfs]
[  600.112281]  [<c109a620>] ? wait_woken+0x80/0x80
[  600.112305]  [<f87e3ae0>] start_transaction+0x390/0x5a0 [btrfs]
[  600.112331]  [<f87e3d73>] btrfs_join_transaction+0x23/0x30 [btrfs]
[  600.112357]  [<f87ed895>] btrfs_finish_ordered_io+0x595/0x750 [btrfs]
[  600.112363]  [<c100fddc>] ? __switch_to+0x11c/0x490
[  600.112368]  [<c16eb199>] ? __schedule+0x389/0x890
[  600.112375]  [<c130ea00>] ? bio_dirty_fn+0x40/0x90
[  600.112400]  [<f87edd42>] finish_ordered_fn+0x12/0x20 [btrfs]
[  600.112428]  [<f8818c1f>] normal_work_helper+0xbf/0x240 [btrfs]
[  600.112456]  [<f8818f30>] btrfs_endio_write_helper+0x10/0x20 [btrfs]
[  600.112462]  [<c1077ae2>] process_one_work+0x122/0x3a0
[  600.112466]  [<c1078489>] worker_thread+0x39/0x4d0
[  600.112471]  [<c109a0ff>] ? __wake_up_locked+0x1f/0x30
[  600.112476]  [<c1078450>] ? rescuer_thread+0x320/0x320
[  600.112480]  [<c107c62b>] kthread+0x9b/0xb0
[  600.112486]  [<c16ef501>] ret_from_kernel_thread+0x21/0x30
[  600.112491]  [<c107c590>] ? kthread_create_on_node+0x150/0x150
[  600.112596] INFO: task kworker/u8:9:3965 blocked for more than 120 seconds.
[  600.112600]       Tainted: P           OE  3.19.0-16-generic #16-Ubuntu
[  600.112602] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  600.112604] kworker/u8:9    D f88018fd     0  3965      2 0x00000000
[  600.112638] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  600.112641]  e4b25ddc 00000046 00000000 f88018fd 00000038 c1b70380
df6f2b70 df6f2b78
[  600.112649]  c1b70380 00000000 00000066 f1597000 00000066 f67ad380
c65d55c0 00000000
[  600.112657]  df6f2b60 00000000 e4b25dfc f88034a7 0000020a 00000000
e8ccd100 4d13d952
[  600.112666] Call Trace:
[  600.112694]  [<f88018fd>] ? alloc_extent_state+0x1d/0xb0 [btrfs]
[  600.112722]  [<f88034a7>] ? __set_extent_bit+0x4d7/0x800 [btrfs]
[  600.112728]  [<c109a77b>] ? prepare_to_wait_event+0x6b/0xe0
[  600.112733]  [<c16eb6c3>] schedule+0x23/0x60
[  600.112757]  [<f87e20af>] wait_current_trans.isra.19+0x8f/0xf0 [btrfs]
[  600.112762]  [<c109a620>] ? wait_woken+0x80/0x80
[  600.112787]  [<f87e3ae0>] start_transaction+0x390/0x5a0 [btrfs]
[  600.112812]  [<f87e3d73>] btrfs_join_transaction+0x23/0x30 [btrfs]
[  600.112838]  [<f87ed895>] btrfs_finish_ordered_io+0x595/0x750 [btrfs]
[  600.112843]  [<c100fddc>] ? __switch_to+0x11c/0x490
[  600.112848]  [<c16eb199>] ? __schedule+0x389/0x890
[  600.112874]  [<f87edd42>] finish_ordered_fn+0x12/0x20 [btrfs]
[  600.112901]  [<f8818c1f>] normal_work_helper+0xbf/0x240 [btrfs]
[  600.112929]  [<f8818f30>] btrfs_endio_write_helper+0x10/0x20 [btrfs]
[  600.112934]  [<c1077ae2>] process_one_work+0x122/0x3a0
[  600.112939]  [<c1078489>] worker_thread+0x39/0x4d0
[  600.112943]  [<c1078450>] ? rescuer_thread+0x320/0x320
[  600.112947]  [<c107c62b>] kthread+0x9b/0xb0
[  600.112953]  [<c16ef501>] ret_from_kernel_thread+0x21/0x30
[  600.112957]  [<c107c590>] ? kthread_create_on_node+0x150/0x150
[  600.112961] INFO: task kworker/u8:10:3966 blocked for more than 120 seconds.
[  600.112964]       Tainted: P           OE  3.19.0-16-generic #16-Ubuntu
[  600.112966] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  600.112969] kworker/u8:10   D f88018fd     0  3966      2 0x00000000
[  600.112997] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  600.112999]  e4b35ddc 00000046 f8802a01 f88018fd 00000038 c1b70380
ebfff000 00000000
[  600.113008]  c1b70380 e3f64600 00000058 f5f4e800 00000058 f679c380
c65d5be0 00000000
[  600.113016]  df6f2b60 00000000 e4b35dfc f88034a7 0000020a 00000000
b88f9fff 000001da
[  600.113024] Call Trace:
[  600.113052]  [<f8802a01>] ? free_extent_state+0x41/0x90 [btrfs]
[  600.113079]  [<f88018fd>] ? alloc_extent_state+0x1d/0xb0 [btrfs]
[  600.113107]  [<f88034a7>] ? __set_extent_bit+0x4d7/0x800 [btrfs]
[  600.113113]  [<c109a77b>] ? prepare_to_wait_event+0x6b/0xe0
[  600.113118]  [<c16eb6c3>] schedule+0x23/0x60
[  600.113142]  [<f87e20af>] wait_current_trans.isra.19+0x8f/0xf0 [btrfs]
[  600.113147]  [<c109a620>] ? wait_woken+0x80/0x80
[  600.113171]  [<f87e3ae0>] start_transaction+0x390/0x5a0 [btrfs]
[  600.113196]  [<f87e3d73>] btrfs_join_transaction+0x23/0x30 [btrfs]
[  600.113222]  [<f87ed895>] btrfs_finish_ordered_io+0x595/0x750 [btrfs]
[  600.113227]  [<c100fddc>] ? __switch_to+0x11c/0x490
[  600.113232]  [<c16eb199>] ? __schedule+0x389/0x890
[  600.113237]  [<c130ea00>] ? bio_dirty_fn+0x40/0x90
[  600.113262]  [<f87edd42>] finish_ordered_fn+0x12/0x20 [btrfs]
[  600.113290]  [<f8818c1f>] normal_work_helper+0xbf/0x240 [btrfs]
[  600.113317]  [<f8818f30>] btrfs_endio_write_helper+0x10/0x20 [btrfs]
[  600.113322]  [<c1077ae2>] process_one_work+0x122/0x3a0
[  600.113326]  [<c1078489>] worker_thread+0x39/0x4d0
[  600.113331]  [<c109a0ff>] ? __wake_up_locked+0x1f/0x30
[  600.113335]  [<c1078450>] ? rescuer_thread+0x320/0x320
[  600.113339]  [<c107c62b>] kthread+0x9b/0xb0
[  600.113345]  [<c16ef501>] ret_from_kernel_thread+0x21/0x30
[  600.113349]  [<c107c590>] ? kthread_create_on_node+0x150/0x150
[  600.113353] INFO: task kworker/u8:11:3979 blocked for more than 120 seconds.
[  600.113356]       Tainted: P           OE  3.19.0-16-generic #16-Ubuntu
[  600.113358] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  600.113361] kworker/u8:11   D f88018fd     0  3979      2 0x00000000
[  600.113389] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  600.113392]  f54d3ddc 00000046 f54d3d7c f88018fd 00000038 c1b70380
df7d0278 00000000
[  600.113400]  c1b70380 e3f64600 00000057 e3f64600 00000057 f679c380
c65d7460 00000000
[  600.113408]  df6f2b60 00000000 f54d3dfc f88034a7 0000020a 00000000
e8ccd400 4d13d952
[  600.113417] Call Trace:
[  600.113444]  [<f88018fd>] ? alloc_extent_state+0x1d/0xb0 [btrfs]
[  600.113472]  [<f88034a7>] ? __set_extent_bit+0x4d7/0x800 [btrfs]
[  600.113478]  [<c109a77b>] ? prepare_to_wait_event+0x6b/0xe0
[  600.113483]  [<c16eb6c3>] schedule+0x23/0x60
[  600.113507]  [<f87e20af>] wait_current_trans.isra.19+0x8f/0xf0 [btrfs]
[  600.113512]  [<c109a620>] ? wait_woken+0x80/0x80
[  600.113536]  [<f87e3ae0>] start_transaction+0x390/0x5a0 [btrfs]
[  600.113562]  [<f87e3d73>] btrfs_join_transaction+0x23/0x30 [btrfs]
[  600.113587]  [<f87ed895>] btrfs_finish_ordered_io+0x595/0x750 [btrfs]
[  600.113593]  [<c100fddc>] ? __switch_to+0x11c/0x490
[  600.113598]  [<c16eb199>] ? __schedule+0x389/0x890
[  600.113602]  [<c130ea00>] ? bio_dirty_fn+0x40/0x90
[  600.113628]  [<f87edd42>] finish_ordered_fn+0x12/0x20 [btrfs]
[  600.113656]  [<f8818c1f>] normal_work_helper+0xbf/0x240 [btrfs]
[  600.113684]  [<f8818f30>] btrfs_endio_write_helper+0x10/0x20 [btrfs]
[  600.113689]  [<c1077ae2>] process_one_work+0x122/0x3a0
[  600.113694]  [<c1078489>] worker_thread+0x39/0x4d0
[  600.113698]  [<c1078450>] ? rescuer_thread+0x320/0x320
[  600.113702]  [<c107c62b>] kthread+0x9b/0xb0
[  600.113707]  [<c16ef501>] ret_from_kernel_thread+0x21/0x30
[  600.113712]  [<c107c590>] ? kthread_create_on_node+0x150/0x150
[  720.112035] INFO: task kworker/u8:8:148 blocked for more than 120 seconds.
[  720.112044]       Tainted: P           OE  3.19.0-16-generic #16-Ubuntu
[  720.112047] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  720.112051] kworker/u8:8    D f88018fd     0   148      2 0x00000000
[  720.112102] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  720.112111]  f597fddc 00000046 f8802a01 f88018fd 00000038 c1b70380
d1fc0a20 00000001
[  720.112120]  c1b70380 e3f64600 00000066 e3f64600 00000066 f67ad380
f5971260 00000000
[  720.112128]  df6f2b60 00000000 f597fdfc f88034a7 0000020a 00000000
2865cfff 000001cc
[  720.112137] Call Trace:
[  720.112169]  [<f8802a01>] ? free_extent_state+0x41/0x90 [btrfs]
[  720.112197]  [<f88018fd>] ? alloc_extent_state+0x1d/0xb0 [btrfs]
[  720.112227]  [<f88034a7>] ? __set_extent_bit+0x4d7/0x800 [btrfs]
[  720.112235]  [<c109a77b>] ? prepare_to_wait_event+0x6b/0xe0
[  720.112242]  [<c16eb6c3>] schedule+0x23/0x60
[  720.112266]  [<f87e20af>] wait_current_trans.isra.19+0x8f/0xf0 [btrfs]
[  720.112271]  [<c109a620>] ? wait_woken+0x80/0x80
[  720.112296]  [<f87e3ae0>] start_transaction+0x390/0x5a0 [btrfs]
[  720.112321]  [<f87e3d73>] btrfs_join_transaction+0x23/0x30 [btrfs]
[  720.112347]  [<f87ed895>] btrfs_finish_ordered_io+0x595/0x750 [btrfs]
[  720.112353]  [<c100fddc>] ? __switch_to+0x11c/0x490
[  720.112358]  [<c16eb199>] ? __schedule+0x389/0x890
[  720.112364]  [<c130ea00>] ? bio_dirty_fn+0x40/0x90
[  720.112390]  [<f87edd42>] finish_ordered_fn+0x12/0x20 [btrfs]
[  720.112418]  [<f8818c1f>] normal_work_helper+0xbf/0x240 [btrfs]
[  720.112445]  [<f8818f30>] btrfs_endio_write_helper+0x10/0x20 [btrfs]
[  720.112451]  [<c1077ae2>] process_one_work+0x122/0x3a0
[  720.112457]  [<c1078489>] worker_thread+0x39/0x4d0
[  720.112463]  [<c109a0ff>] ? __wake_up_locked+0x1f/0x30
[  720.112467]  [<c1078450>] ? rescuer_thread+0x320/0x320
[  720.112471]  [<c107c62b>] kthread+0x9b/0xb0
[  720.112477]  [<c16ef501>] ret_from_kernel_thread+0x21/0x30
[  720.112482]  [<c107c590>] ? kthread_create_on_node+0x150/0x150
[  720.112525] INFO: task ntpd:2213 blocked for more than 120 seconds.
[  720.112529]       Tainted: P           OE  3.19.0-16-generic #16-Ubuntu
[  720.112531] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  720.112533] ntpd            D f155fd00     0  2213      1 0x00000004
[  720.112539]  e369de60 00200086 c11c73e7 f155fd00 00000004 c1b70380
00000004 e369ddfc
[  720.112547]  c1b70380 00000000 00000087 e3f63200 00000000 f67ad380
e360aae0 e369de24
[  720.112556]  c134d6c5 bf861850 00000002 00000002 00000000 c101b6f1
ffff037f ffff0220
[  720.112564] Call Trace:
[  720.112570]  [<c11c73e7>] ? __fd_install+0x47/0x60
[  720.112576]  [<c134d6c5>] ? __copy_to_user_ll+0x55/0x60
[  720.112582]  [<c101b6f1>] ? save_fsave_header+0x31/0xb0
[  720.112587]  [<c16ebad3>] schedule_preempt_disabled+0x23/0x60
[  720.112591]  [<c16ed512>] __mutex_lock_slowpath+0x72/0xd0
[  720.112596]  [<c16ecd2c>] mutex_lock+0x1c/0x30
[  720.112601]  [<c160bda2>] rtnl_lock+0x12/0x20
[  720.112606]  [<c16138bd>] dev_ioctl+0x2fd/0x540
[  720.112611]  [<c106fc64>] ? signal_setup_done+0x64/0xa0
[  720.112616]  [<c101aa65>] ? fpu_finit+0x55/0x70
[  720.112621]  [<c165c190>] ? first_packet_length+0x1c0/0x1c0
[  720.112626]  [<c15e52b5>] sock_ioctl+0x135/0x250
[  720.112630]  [<c15e5180>] ? sock_fasync+0x80/0x80
[  720.112636]  [<c11bdfa2>] do_vfs_ioctl+0x322/0x550
[  720.112641]  [<c11be230>] SyS_ioctl+0x60/0x90
[  720.112646]  [<c16ef5df>] sysenter_do_call+0x12/0x12
[  720.112668] INFO: task panel-37-netloa:2435 blocked for more than
120 seconds.
[  720.112671]       Tainted: P           OE  3.19.0-16-generic #16-Ubuntu
[  720.112673] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  720.112675] panel-37-netloa D df20c600     0  2435   2256 0x00000000
[  720.112680]  df0dfe4c 00200086 00000000 df20c600 00000006 c1b70380
df0dfdf0 c11c73e7
[  720.112688]  c1b70380 00000000 00000088 e346a200 df0dfdfc f679c380
df016200 df0dffa4
[  720.112697]  c15e85eb 00000000 df0dff78 00000000 df0dfe2c df0dfe24
f6d43870 00000002
[  720.112705] Call Trace:
[  720.112710]  [<c11c73e7>] ? __fd_install+0x47/0x60
[  720.112715]  [<c15e85eb>] ? SYSC_socketcall+0x1bb/0x9c0
[  720.112720]  [<c16ebad3>] schedule_preempt_disabled+0x23/0x60
[  720.112725]  [<c16ed512>] __mutex_lock_slowpath+0x72/0xd0
[  720.112729]  [<c16ecd2c>] mutex_lock+0x1c/0x30
[  720.112733]  [<c160bda2>] rtnl_lock+0x12/0x20
[  720.112738]  [<c1666a84>] devinet_ioctl+0xb4/0x690
[  720.112742]  [<c1667f7d>] inet_ioctl+0x6d/0xa0
[  720.112746]  [<c15e529c>] sock_ioctl+0x11c/0x250
[  720.112750]  [<c15e5180>] ? sock_fasync+0x80/0x80
[  720.112755]  [<c11bdfa2>] do_vfs_ioctl+0x322/0x550
[  720.112760]  [<c1177f1a>] ? remove_vma+0x4a/0x50
[  720.112764]  [<c117a26e>] ? do_munmap+0x1de/0x350
[  720.112769]  [<c11be230>] SyS_ioctl+0x60/0x90
[  720.112774]  [<c16ef5df>] sysenter_do_call+0x12/0x12
[  720.112786] INFO: task panel-37-netloa:2622 blocked for more than
120 seconds.
[  720.112789]       Tainted: P           OE  3.19.0-16-generic #16-Ubuntu
[  720.112791] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  720.112793] panel-37-netloa D ddde2700     0  2622   2410 0x00000000
[  720.112798]  dc7d5e4c 00200086 00000000 ddde2700 00000006 c1b70380
dc7d5df0 c11c73e7
[  720.112806]  c1b70380 00000000 00000087 ddfad400 dc7d5dfc f67ad380
e1d03720 dc7d5fa4
[  720.112814]  c15e85eb 00000000 dc7d5f78 00000000 dc7d5e2c dc7d5e24
f75f4f78 00000002
[  720.112823] Call Trace:
[  720.112828]  [<c11c73e7>] ? __fd_install+0x47/0x60
[  720.112833]  [<c15e85eb>] ? SYSC_socketcall+0x1bb/0x9c0
[  720.112838]  [<c16ebad3>] schedule_preempt_disabled+0x23/0x60
[  720.112842]  [<c16ed512>] __mutex_lock_slowpath+0x72/0xd0
[  720.112846]  [<c16ecd2c>] mutex_lock+0x1c/0x30
[  720.112850]  [<c160bda2>] rtnl_lock+0x12/0x20
[  720.112855]  [<c1666a84>] devinet_ioctl+0xb4/0x690
[  720.112859]  [<c1667f7d>] inet_ioctl+0x6d/0xa0
[  720.112863]  [<c15e529c>] sock_ioctl+0x11c/0x250
[  720.112868]  [<c15e5180>] ? sock_fasync+0x80/0x80
[  720.112872]  [<c11bdfa2>] do_vfs_ioctl+0x322/0x550
[  720.112876]  [<c1177f1a>] ? remove_vma+0x4a/0x50
[  720.112880]  [<c117a26e>] ? do_munmap+0x1de/0x350
[  720.112885]  [<c11be230>] SyS_ioctl+0x60/0x90
[  720.112890]  [<c16ef5df>] sysenter_do_call+0x12/0x12
[  720.112900] INFO: task evolution-calen:2842 blocked for more than
120 seconds.
[  720.112902]       Tainted: P           OE  3.19.0-16-generic #16-Ubuntu
[  720.112905] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  720.112907] evolution-calen D 00000000     0  2842   1652 0x00000000
[  720.112911]  d6c55bc0 00000086 00000296 00000000 000f423f c1b70380
d4ce0000 00000000
[  720.112920]  c1b70380 d6fdfc00 0000008b d97e6e00 0000008b f679c380
d95a4360 d6c55b70
[  720.112928]  00000000 00000000 40a9a48e 0000008b 409a624f 0000008b
c10c0c60 f67977b4
[  720.112937] Call Trace:
[  720.112943]  [<c10c0c60>] ? hrtimer_get_res+0x40/0x40
[  720.112948]  [<c16ef24e>] ? _raw_spin_unlock_bh+0x1e/0x40
[  720.112952]  [<c16ebad3>] schedule_preempt_disabled+0x23/0x60
[  720.112957]  [<c16ed512>] __mutex_lock_slowpath+0x72/0xd0
[  720.112961]  [<c16ecd2c>] mutex_lock+0x1c/0x30
[  720.112965]  [<c160cab5>] rtnetlink_rcv+0x15/0x30
[  720.112970]  [<c162852e>] netlink_unicast+0xee/0x190
[  720.112975]  [<c162881d>] netlink_sendmsg+0x24d/0x620
[  720.112980]  [<c12f186b>] ? aa_sock_msg_perm+0x4b/0x180
[  720.112985]  [<c15e6e3d>] do_sock_sendmsg+0xbd/0xe0
[  720.112990]  [<c15e6ac0>] ? sock_poll+0x100/0x100
[  720.112994]  [<c11c6df2>] ? __fget_light+0x22/0x60
[  720.112998]  [<c11c6e42>] ? __fdget+0x12/0x20
[  720.113002]  [<c15e56f4>] ? sockfd_lookup_light+0x14/0x70
[  720.113007]  [<c15e7248>] SYSC_sendto+0x128/0x180
[  720.113012]  [<c11beb30>] ? poll_select_copy_remaining+0x110/0x110
[  720.113016]  [<c11c6df2>] ? __fget_light+0x22/0x60
[  720.113020]  [<c11c6e42>] ? __fdget+0x12/0x20
[  720.113024]  [<c15e81c7>] ? __sys_recvmsg+0x57/0x70
[  720.113029]  [<c15e8904>] SYSC_socketcall+0x4d4/0x9c0
[  720.113033]  [<c108f0b0>] ? update_curr+0x90/0x1d0
[  720.113039]  [<c108c2ed>] ? __enqueue_entity+0x6d/0x80
[  720.113043]  [<c10911a9>] ? put_prev_entity+0xc9/0x530
[  720.113047]  [<c1085bd8>] ? check_preempt_curr+0x78/0x80
[  720.113051]  [<c108dc09>] ? set_next_entity+0xb9/0xe0
[  720.113056]  [<c1088725>] ? try_to_wake_up+0x1a5/0x2c0
[  720.113060]  [<c12e7c0f>] ? common_file_perm+0x3f/0xe0
[  720.113066]  [<c11ee016>] ? eventfd_ctx_read+0x46/0x200
[  720.113070]  [<c10888a0>] ? wake_up_state+0x20/0x20
[  720.113074]  [<c11ee1fd>] ? eventfd_read+0x2d/0x60
[  720.113078]  [<c11ee1d0>] ? eventfd_ctx_read+0x200/0x200
[  720.113083]  [<c11ac41d>] ? vfs_read+0x6d/0x120
[  720.113087]  [<c11c6df2>] ? __fget_light+0x22/0x60
[  720.113092]  [<c15e8eb3>] SyS_socketcall+0x13/0x20
[  720.113097]  [<c16ef5df>] sysenter_do_call+0x12/0x12
[  720.113105] INFO: task evolution-calen:3032 blocked for more than
120 seconds.
[  720.113107]       Tainted: P           OE  3.19.0-16-generic #16-Ubuntu
[  720.113110] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  720.113112] evolution-calen D 00000000     0  3032      1 0x00000000
[  720.113116]  d6fc1bc0 00000086 00000296 00000000 000f423f c1b70380
d6fc1bc4 c16ee702
[  720.113125]  c1b70380 00000000 0000008b d6fab600 00000000 f67ad380
ddc65be0 d6fc1b70
[  720.113133]  f67a8a40 00000000 40a9a4f4 0000008b 409a62b5 0000008b
c10c0c60 f67a87b4
[  720.113141] Call Trace:
[  720.113147]  [<c16ee702>] ? schedule_hrtimeout_range_clock+0xe2/0x180
[  720.113152]  [<c10c0c60>] ? hrtimer_get_res+0x40/0x40
[  720.113156]  [<c16ef24e>] ? _raw_spin_unlock_bh+0x1e/0x40
[  720.113161]  [<c16ebad3>] schedule_preempt_disabled+0x23/0x60
[  720.113165]  [<c16ed512>] __mutex_lock_slowpath+0x72/0xd0
[  720.113169]  [<c16ecd2c>] mutex_lock+0x1c/0x30
[  720.113173]  [<c160cab5>] rtnetlink_rcv+0x15/0x30
[  720.113178]  [<c162852e>] netlink_unicast+0xee/0x190
[  720.113182]  [<c162881d>] netlink_sendmsg+0x24d/0x620
[  720.113187]  [<c12f186b>] ? aa_sock_msg_perm+0x4b/0x180
[  720.113192]  [<c15e6e3d>] do_sock_sendmsg+0xbd/0xe0
[  720.113196]  [<c15e6ac0>] ? sock_poll+0x100/0x100
[  720.113201]  [<c11c6df2>] ? __fget_light+0x22/0x60
[  720.113205]  [<c11c6e42>] ? __fdget+0x12/0x20
[  720.113209]  [<c15e56f4>] ? sockfd_lookup_light+0x14/0x70
[  720.113213]  [<c15e7248>] SYSC_sendto+0x128/0x180
[  720.113218]  [<c11beb30>] ? poll_select_copy_remaining+0x110/0x110
[  720.113222]  [<c11c6df2>] ? __fget_light+0x22/0x60
[  720.113226]  [<c11c6e42>] ? __fdget+0x12/0x20
[  720.113231]  [<c15e81c7>] ? __sys_recvmsg+0x57/0x70
[  720.113235]  [<c15e8904>] SYSC_socketcall+0x4d4/0x9c0
[  720.113240]  [<c108f0b0>] ? update_curr+0x90/0x1d0
[  720.113244]  [<c108c2ed>] ? __enqueue_entity+0x6d/0x80
[  720.113248]  [<c10911a9>] ? put_prev_entity+0xc9/0x530
[  720.113253]  [<c108aa3f>] ? __update_cpu_load+0xbf/0x120
[  720.113257]  [<c108dc09>] ? set_next_entity+0xb9/0xe0
[  720.113261]  [<c10c6fd1>] ? ktime_get+0x41/0x100
[  720.113266]  [<c12e7c0f>] ? common_file_perm+0x3f/0xe0
[  720.113270]  [<c11ee016>] ? eventfd_ctx_read+0x46/0x200
[  720.113274]  [<c10888a0>] ? wake_up_state+0x20/0x20
[  720.113279]  [<c11ee1fd>] ? eventfd_read+0x2d/0x60
[  720.113283]  [<c11ee1d0>] ? eventfd_ctx_read+0x200/0x200
[  720.113287]  [<c11ac41d>] ? vfs_read+0x6d/0x120
[  720.113291]  [<c11c6df2>] ? __fget_light+0x22/0x60
[  720.113296]  [<c15e8eb3>] SyS_socketcall+0x13/0x20
[  720.113301]  [<c16ef5df>] sysenter_do_call+0x12/0x12
[  910.761736] systemd[1]: Starting Cleanup of Temporary Directories...
[  915.445464] systemd[1]: Started Cleanup of Temporary Directories.


-- 
Blog:     http://grumbel.blogspot.com/
JabberID: xmpp:grumbel@jabber.org
ICQ:      59461927
