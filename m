Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58804 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab3EHA11 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 20:27:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZsE9-0002rc-CE
	for linux-btrfs@vger.kernel.org; Wed, 08 May 2013 02:27:25 +0200
Received: from dyndsl-178-142-088-157.ewe-ip-backbone.de ([178.142.88.157])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 02:27:25 +0200
Received: from hurikhan77+btrfs by dyndsl-178-142-088-157.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 02:27:25 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: hard freezes with 3.9.0 during io-intensive loads
Date: Wed, 08 May 2013 02:24:48 +0200
Message-ID: <7jio5a-b5g.ln1@hurikhan.ath.cx>
References: <6moh5a-knf.ln1@hurikhan.ath.cx> <2sci5a-n8p.ln1@hurikhan.ath.cx> <5187700F.20807@jan-o-sch.net> <3egl5a-al5.ln1@hurikhan.ath.cx> <51889A4D.8000201@jan-o-sch.net> <ch7o5a-g0b.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow <hurikhan77+btrfs@gmail.com> schrieb:

>>> I can reliably reproduce it from two different approaches. I'd like to
>>> only apply the commits fixing it. Can you name them here?
>> 
>> In git log order:
>> 
>> 6ced2666 Btrfs: separate sequence numbers for delayed ref tracking and
>> tree mod log ef9120b1 Btrfs: fix tree mod log regression on root split
>> operations 2ed098ca Btrfs: fix accessing the root pointer in tree mod log
>> functions 50723551 Btrfs: fix unlock after free on rewinded tree blocks
>> 
>> The commit ids are from josef's master branch
>> (git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git)
>> which is known not to be very stable regarding commit ids.
> 
> Thanks, applied almost cleanly to 3.9.0 vanilla with just one reject. And
> that was for some error message. I'm simply ignoring that and currently
> compiling it.
> 
> I will get back here with the result (fixed or not fixed for one or both
> situations).

Apparently, it's not fixed. The system does not freeze now but it threw 
multiple backtraces right in front of my Xorg session. The backtraces look a 
little bit different now. Here's what I got:

https://gist.github.com/kakra/8a340f006d01e146865d

Occurence while running "bedup dedup --defrag --size-cutoff $((1024*1024))" 
which was currently dedup'ing my backup volume with daily snapshots filled 
by "rsync --inplace" - so I suppose some file contents are pretty scattered.

[ 2612.573501] ------------[ cut here ]------------
[ 2612.573509] WARNING: at fs/btrfs/inode.c:2157 
record_one_backref+0x310/0x328()
[ 2612.573510] Hardware name: To Be Filled By O.E.M.
[ 2612.573511] Modules linked in: rfcomm bnep af_packet vsock(O) vmmon(O) 
vmnet(O) vmci(O) vmblock(O) reiserfs snd_usb_audio snd_usbmidi_lib 
snd_rawmidi snd_seq_device gspca_sonixj gspca_main videodev gpio_ich 
coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel btusb microcode 
bluetooth pcspkr lpc_ich i2c_i801 8250 mfd_core serial_core evdev 
usb_storage zram(C) unix
[ 2612.573528] Pid: 13112, comm: btrfs-endio-wri Tainted: G         C O 
3.9.0-gentoo #3
[ 2612.573529] Call Trace:
[ 2612.573534]  [<ffffffff8102f11d>] ? warn_slowpath_common+0x78/0x8e
[ 2612.573536]  [<ffffffff81183aed>] ? record_one_backref+0x310/0x328
[ 2612.573540]  [<ffffffff811c5eb0>] ? iterate_extent_inodes+0x177/0x23c
[ 2612.573542]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 2612.573543]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 2612.573545]  [<ffffffff811c5ffe>] ? iterate_inodes_from_logical+0x89/0x96
[ 2612.573547]  [<ffffffff81182320>] ? record_extent_backrefs+0x4d/0x8e
[ 2612.573549]  [<ffffffff8118a8d3>] ? btrfs_finish_ordered_io+0x671/0x798
[ 2612.573552]  [<ffffffff811a33f3>] ? worker_loop+0x176/0x493
[ 2612.573553]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 2612.573554]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 2612.573557]  [<ffffffff810496d2>] ? kthread+0x81/0x89
[ 2612.573560]  [<ffffffff81050000>] ? free_sched_groups+0x32/0x50
[ 2612.573561]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 2612.573564]  [<ffffffff8151c6ac>] ? ret_from_fork+0x7c/0xb0
[ 2612.573566]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 2612.573567] ---[ end trace 4c42d11ebaf277b6 ]---
[ 2612.574001] ------------[ cut here ]------------
[ 2612.574004] WARNING: at fs/btrfs/inode.c:2157 
record_one_backref+0x310/0x328()
[ 2612.574004] Hardware name: To Be Filled By O.E.M.
[ 2612.574005] Modules linked in: rfcomm bnep af_packet vsock(O) vmmon(O) 
vmnet(O) vmci(O) vmblock(O) reiserfs snd_usb_audio snd_usbmidi_lib 
snd_rawmidi snd_seq_device gspca_sonixj gspca_main videodev gpio_ich 
coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel btusb microcode 
bluetooth pcspkr lpc_ich i2c_i801 8250 mfd_core serial_core evdev 
usb_storage zram(C) unix
[ 2612.574017] Pid: 13110, comm: btrfs-endio-wri Tainted: G        WC O 
3.9.0-gentoo #3
[ 2612.574018] Call Trace:
[ 2612.574020]  [<ffffffff8102f11d>] ? warn_slowpath_common+0x78/0x8e
[ 2612.574021]  [<ffffffff81183aed>] ? record_one_backref+0x310/0x328
[ 2612.574023]  [<ffffffff811c5eb0>] ? iterate_extent_inodes+0x177/0x23c
[ 2612.574025]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 2612.574027]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 2612.574029]  [<ffffffff811c5ffe>] ? iterate_inodes_from_logical+0x89/0x96
[ 2612.574030]  [<ffffffff81182320>] ? record_extent_backrefs+0x4d/0x8e
[ 2612.574032]  [<ffffffff8118a8d3>] ? btrfs_finish_ordered_io+0x671/0x798
[ 2612.574034]  [<ffffffff811a33f3>] ? worker_loop+0x176/0x493
[ 2612.574035]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 2612.574036]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 2612.574038]  [<ffffffff810496d2>] ? kthread+0x81/0x89
[ 2612.574040]  [<ffffffff81050000>] ? free_sched_groups+0x32/0x50
[ 2612.574041]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 2612.574043]  [<ffffffff8151c6ac>] ? ret_from_fork+0x7c/0xb0
[ 2612.574045]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 2612.574046] ---[ end trace 4c42d11ebaf277b7 ]---
[ 2612.576338] ------------[ cut here ]------------
[ 2612.576347] WARNING: at fs/btrfs/inode.c:2157 
record_one_backref+0x310/0x328()
[ 2612.576348] Hardware name: To Be Filled By O.E.M.
[ 2612.576349] Modules linked in: rfcomm bnep af_packet vsock(O) vmmon(O) 
vmnet(O) vmci(O) vmblock(O) reiserfs snd_usb_audio snd_usbmidi_lib 
snd_rawmidi snd_seq_device gspca_sonixj gspca_main videodev gpio_ich 
coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel btusb microcode 
bluetooth pcspkr lpc_ich i2c_i801 8250 mfd_core serial_core evdev 
usb_storage zram(C) unix
[ 2612.576366] Pid: 13110, comm: btrfs-endio-wri Tainted: G        WC O 
3.9.0-gentoo #3
[ 2612.576367] Call Trace:
[ 2612.576373]  [<ffffffff8102f11d>] ? warn_slowpath_common+0x78/0x8e
[ 2612.576375]  [<ffffffff81183aed>] ? record_one_backref+0x310/0x328
[ 2612.576379]  [<ffffffff811c5eb0>] ? iterate_extent_inodes+0x177/0x23c
[ 2612.576381]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 2612.576383]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 2612.576385]  [<ffffffff811c5ffe>] ? iterate_inodes_from_logical+0x89/0x96
[ 2612.576387]  [<ffffffff81182320>] ? record_extent_backrefs+0x4d/0x8e
[ 2612.576389]  [<ffffffff8118a8d3>] ? btrfs_finish_ordered_io+0x671/0x798
[ 2612.576391]  [<ffffffff811a33f3>] ? worker_loop+0x176/0x493
[ 2612.576392]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 2612.576394]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 2612.576397]  [<ffffffff810496d2>] ? kthread+0x81/0x89
[ 2612.576400]  [<ffffffff81050000>] ? free_sched_groups+0x32/0x50
[ 2612.576402]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 2612.576405]  [<ffffffff8151c6ac>] ? ret_from_fork+0x7c/0xb0
[ 2612.576406]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 2612.576408] ---[ end trace 4c42d11ebaf277b8 ]---
[ 3376.517211] ------------[ cut here ]------------
[ 3376.517220] WARNING: at fs/btrfs/inode.c:2157 
record_one_backref+0x310/0x328()
[ 3376.517222] Hardware name: To Be Filled By O.E.M.
[ 3376.517223] Modules linked in: rfcomm bnep af_packet vsock(O) vmmon(O) 
vmnet(O) vmci(O) vmblock(O) reiserfs snd_usb_audio snd_usbmidi_lib 
snd_rawmidi snd_seq_device gspca_sonixj gspca_main videodev gpio_ich 
coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel btusb microcode 
bluetooth pcspkr lpc_ich i2c_i801 8250 mfd_core serial_core evdev 
usb_storage zram(C) unix
[ 3376.517248] Pid: 13107, comm: btrfs-endio-wri Tainted: G        WC O 
3.9.0-gentoo #3
[ 3376.517249] Call Trace:
[ 3376.517255]  [<ffffffff8102f11d>] ? warn_slowpath_common+0x78/0x8e
[ 3376.517258]  [<ffffffff81183aed>] ? record_one_backref+0x310/0x328
[ 3376.517263]  [<ffffffff811c5eb0>] ? iterate_extent_inodes+0x177/0x23c
[ 3376.517266]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 3376.517268]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 3376.517271]  [<ffffffff811c5ffe>] ? iterate_inodes_from_logical+0x89/0x96
[ 3376.517274]  [<ffffffff81182320>] ? record_extent_backrefs+0x4d/0x8e
[ 3376.517278]  [<ffffffff8118a8d3>] ? btrfs_finish_ordered_io+0x671/0x798
[ 3376.517281]  [<ffffffff811a33f3>] ? worker_loop+0x176/0x493
[ 3376.517283]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 3376.517285]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 3376.517289]  [<ffffffff810496d2>] ? kthread+0x81/0x89
[ 3376.517293]  [<ffffffff81050000>] ? free_sched_groups+0x32/0x50
[ 3376.517296]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 3376.517300]  [<ffffffff8151c6ac>] ? ret_from_fork+0x7c/0xb0
[ 3376.517303]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 3376.517305] ---[ end trace 4c42d11ebaf277b9 ]---
[ 3383.342985] ------------[ cut here ]------------
[ 3383.342994] WARNING: at fs/btrfs/inode.c:2157 
record_one_backref+0x310/0x328()
[ 3383.342997] Hardware name: To Be Filled By O.E.M.
[ 3383.342998] Modules linked in: rfcomm bnep af_packet vsock(O) vmmon(O) 
vmnet(O) vmci(O) vmblock(O) reiserfs snd_usb_audio snd_usbmidi_lib 
snd_rawmidi snd_seq_device gspca_sonixj gspca_main videodev gpio_ich 
coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel btusb microcode 
bluetooth pcspkr lpc_ich i2c_i801 8250 mfd_core serial_core evdev 
usb_storage zram(C) unix
[ 3383.343023] Pid: 13107, comm: btrfs-endio-wri Tainted: G        WC O 
3.9.0-gentoo #3
[ 3383.343024] Call Trace:
[ 3383.343030]  [<ffffffff8102f11d>] ? warn_slowpath_common+0x78/0x8e
[ 3383.343032]  [<ffffffff81183aed>] ? record_one_backref+0x310/0x328
[ 3383.343037]  [<ffffffff811c5eb0>] ? iterate_extent_inodes+0x177/0x23c
[ 3383.343040]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 3383.343043]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 3383.343046]  [<ffffffff811c5ffe>] ? iterate_inodes_from_logical+0x89/0x96
[ 3383.343049]  [<ffffffff81182320>] ? record_extent_backrefs+0x4d/0x8e
[ 3383.343052]  [<ffffffff8118a8d3>] ? btrfs_finish_ordered_io+0x671/0x798
[ 3383.343055]  [<ffffffff811a33f3>] ? worker_loop+0x176/0x493
[ 3383.343058]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 3383.343060]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 3383.343064]  [<ffffffff810496d2>] ? kthread+0x81/0x89
[ 3383.343067]  [<ffffffff81050000>] ? free_sched_groups+0x32/0x50
[ 3383.343070]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 3383.343074]  [<ffffffff8151c6ac>] ? ret_from_fork+0x7c/0xb0
[ 3383.343077]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 3383.343079] ---[ end trace 4c42d11ebaf277ba ]---
[ 3383.821210] ------------[ cut here ]------------
[ 3383.821220] WARNING: at fs/btrfs/inode.c:2157 
record_one_backref+0x310/0x328()
[ 3383.821221] Hardware name: To Be Filled By O.E.M.
[ 3383.821223] Modules linked in: rfcomm bnep af_packet vsock(O) vmmon(O) 
vmnet(O) vmci(O) vmblock(O) reiserfs snd_usb_audio snd_usbmidi_lib 
snd_rawmidi snd_seq_device gspca_sonixj gspca_main videodev gpio_ich 
coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel btusb microcode 
bluetooth pcspkr lpc_ich i2c_i801 8250 mfd_core serial_core evdev 
usb_storage zram(C) unix
[ 3383.821247] Pid: 16710, comm: btrfs-endio-wri Tainted: G        WC O 
3.9.0-gentoo #3
[ 3383.821249] Call Trace:
[ 3383.821254]  [<ffffffff8102f11d>] ? warn_slowpath_common+0x78/0x8e
[ 3383.821257]  [<ffffffff81183aed>] ? record_one_backref+0x310/0x328
[ 3383.821262]  [<ffffffff811c5eb0>] ? iterate_extent_inodes+0x177/0x23c
[ 3383.821265]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 3383.821267]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 3383.821270]  [<ffffffff811c5ffe>] ? iterate_inodes_from_logical+0x89/0x96
[ 3383.821273]  [<ffffffff81182320>] ? record_extent_backrefs+0x4d/0x8e
[ 3383.821277]  [<ffffffff8118a8d3>] ? btrfs_finish_ordered_io+0x671/0x798
[ 3383.821279]  [<ffffffff811a33f3>] ? worker_loop+0x176/0x493
[ 3383.821282]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 3383.821284]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 3383.821288]  [<ffffffff810496d2>] ? kthread+0x81/0x89
[ 3383.821291]  [<ffffffff81050000>] ? free_sched_groups+0x32/0x50
[ 3383.821294]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 3383.821298]  [<ffffffff8151c6ac>] ? ret_from_fork+0x7c/0xb0
[ 3383.821301]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 3383.821302] ---[ end trace 4c42d11ebaf277bb ]---
[ 3387.753658] ------------[ cut here ]------------
[ 3387.753667] WARNING: at fs/btrfs/inode.c:2157 
record_one_backref+0x310/0x328()
[ 3387.753669] Hardware name: To Be Filled By O.E.M.
[ 3387.753670] Modules linked in: rfcomm bnep af_packet vsock(O) vmmon(O) 
vmnet(O) vmci(O) vmblock(O) reiserfs snd_usb_audio snd_usbmidi_lib 
snd_rawmidi snd_seq_device gspca_sonixj gspca_main videodev gpio_ich 
coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel btusb microcode 
bluetooth pcspkr lpc_ich i2c_i801 8250 mfd_core serial_core evdev 
usb_storage zram(C) unix
[ 3387.753693] Pid: 13107, comm: btrfs-endio-wri Tainted: G        WC O 
3.9.0-gentoo #3
[ 3387.753694] Call Trace:
[ 3387.753699]  [<ffffffff8102f11d>] ? warn_slowpath_common+0x78/0x8e
[ 3387.753702]  [<ffffffff81183aed>] ? record_one_backref+0x310/0x328
[ 3387.753707]  [<ffffffff811c5eb0>] ? iterate_extent_inodes+0x177/0x23c
[ 3387.753709]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 3387.753711]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 3387.753714]  [<ffffffff811c5ffe>] ? iterate_inodes_from_logical+0x89/0x96
[ 3387.753717]  [<ffffffff81182320>] ? record_extent_backrefs+0x4d/0x8e
[ 3387.753720]  [<ffffffff8118a8d3>] ? btrfs_finish_ordered_io+0x671/0x798
[ 3387.753723]  [<ffffffff811a33f3>] ? worker_loop+0x176/0x493
[ 3387.753725]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 3387.753727]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 3387.753730]  [<ffffffff810496d2>] ? kthread+0x81/0x89
[ 3387.753733]  [<ffffffff81050000>] ? free_sched_groups+0x32/0x50
[ 3387.753736]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 3387.753739]  [<ffffffff8151c6ac>] ? ret_from_fork+0x7c/0xb0
[ 3387.753742]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 3387.753743] ---[ end trace 4c42d11ebaf277bc ]---
[ 3678.135594] ------------[ cut here ]------------
[ 3678.135601] WARNING: at fs/btrfs/inode.c:2157 
record_one_backref+0x310/0x328()
[ 3678.135602] Hardware name: To Be Filled By O.E.M.
[ 3678.135603] Modules linked in: rfcomm bnep af_packet vsock(O) vmmon(O) 
vmnet(O) vmci(O) vmblock(O) reiserfs snd_usb_audio snd_usbmidi_lib 
snd_rawmidi snd_seq_device gspca_sonixj gspca_main videodev gpio_ich 
coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel btusb microcode 
bluetooth pcspkr lpc_ich i2c_i801 8250 mfd_core serial_core evdev 
usb_storage zram(C) unix
[ 3678.135620] Pid: 16709, comm: btrfs-endio-wri Tainted: G        WC O 
3.9.0-gentoo #3
[ 3678.135621] Call Trace:
[ 3678.135626]  [<ffffffff8102f11d>] ? warn_slowpath_common+0x78/0x8e
[ 3678.135627]  [<ffffffff81183aed>] ? record_one_backref+0x310/0x328
[ 3678.135631]  [<ffffffff811c5eb0>] ? iterate_extent_inodes+0x177/0x23c
[ 3678.135633]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 3678.135634]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 3678.135636]  [<ffffffff811c5ffe>] ? iterate_inodes_from_logical+0x89/0x96
[ 3678.135638]  [<ffffffff81182320>] ? record_extent_backrefs+0x4d/0x8e
[ 3678.135640]  [<ffffffff8118a8d3>] ? btrfs_finish_ordered_io+0x671/0x798
[ 3678.135642]  [<ffffffff811a33f3>] ? worker_loop+0x176/0x493
[ 3678.135644]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 3678.135645]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 3678.135648]  [<ffffffff810496d2>] ? kthread+0x81/0x89
[ 3678.135650]  [<ffffffff8110b553>] ? fget_light+0x2e/0x7b
[ 3678.135653]  [<ffffffff81050000>] ? free_sched_groups+0x32/0x50
[ 3678.135654]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 3678.135657]  [<ffffffff8151c6ac>] ? ret_from_fork+0x7c/0xb0
[ 3678.135659]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 3678.135660] ---[ end trace 4c42d11ebaf277bd ]---
[ 5233.415133] ------------[ cut here ]------------
[ 5233.415140] WARNING: at fs/btrfs/inode.c:2157 
record_one_backref+0x310/0x328()
[ 5233.415142] Hardware name: To Be Filled By O.E.M.
[ 5233.415142] Modules linked in: rfcomm bnep af_packet vsock(O) vmmon(O) 
vmnet(O) vmci(O) vmblock(O) reiserfs snd_usb_audio snd_usbmidi_lib 
snd_rawmidi snd_seq_device gspca_sonixj gspca_main videodev gpio_ich 
coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel btusb microcode 
bluetooth pcspkr lpc_ich i2c_i801 8250 mfd_core serial_core evdev 
usb_storage zram(C) unix
[ 5233.415162] Pid: 16709, comm: btrfs-endio-wri Tainted: G        WC O 
3.9.0-gentoo #3
[ 5233.415163] Call Trace:
[ 5233.415168]  [<ffffffff8102f11d>] ? warn_slowpath_common+0x78/0x8e
[ 5233.415170]  [<ffffffff81183aed>] ? record_one_backref+0x310/0x328
[ 5233.415174]  [<ffffffff811c5eb0>] ? iterate_extent_inodes+0x177/0x23c
[ 5233.415176]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 5233.415178]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 5233.415180]  [<ffffffff811c5ffe>] ? iterate_inodes_from_logical+0x89/0x96
[ 5233.415182]  [<ffffffff81182320>] ? record_extent_backrefs+0x4d/0x8e
[ 5233.415185]  [<ffffffff8118a8d3>] ? btrfs_finish_ordered_io+0x671/0x798
[ 5233.415187]  [<ffffffff811a33f3>] ? worker_loop+0x176/0x493
[ 5233.415189]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 5233.415190]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 5233.415193]  [<ffffffff810496d2>] ? kthread+0x81/0x89
[ 5233.415196]  [<ffffffff8110b553>] ? fget_light+0x2e/0x7b
[ 5233.415199]  [<ffffffff81050000>] ? free_sched_groups+0x32/0x50
[ 5233.415201]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 5233.415204]  [<ffffffff8151c6ac>] ? ret_from_fork+0x7c/0xb0
[ 5233.415206]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 5233.415208] ---[ end trace 4c42d11ebaf277be ]---
[ 5871.674593] ------------[ cut here ]------------
[ 5871.674626] kernel BUG at fs/btrfs/ctree.c:1185!
[ 5871.674652] invalid opcode: 0000 [#1] SMP 
[ 5871.674679] Modules linked in: rfcomm bnep af_packet vsock(O) vmmon(O) 
vmnet(O) vmci(O) vmblock(O) reiserfs snd_usb_audio snd_usbmidi_lib 
snd_rawmidi snd_seq_device gspca_sonixj gspca_main videodev gpio_ich 
coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel btusb microcode 
bluetooth pcspkr lpc_ich i2c_i801 8250 mfd_core serial_core evdev 
usb_storage zram(C) unix
[ 5871.674903] CPU 3 
[ 5871.674917] Pid: 1411, comm: btrfs-endio-wri Tainted: G        WC O 
3.9.0-gentoo #3 To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3
[ 5871.674980] RIP: 0010:[<ffffffff81161cff>]  [<ffffffff81161cff>] 
__tree_mod_log_rewind+0x4c/0x121
[ 5871.675032] RSP: 0018:ffff8802e24fb8f8  EFLAGS: 00010297
[ 5871.675060] RAX: 0000000000000003 RBX: ffff8801b2f67e30 RCX: 
ffff8802e24fb898
[ 5871.675098] RDX: 0000000014f3c8c2 RSI: 0000000000000753 RDI: 
ffff88040874b000
[ 5871.675134] RBP: 0000000000000036 R08: 0000000000001000 R09: 
ffff8802e24fb8a8
[ 5871.675171] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffff8803fed94c00
[ 5871.675208] R13: 0000004400000000 R14: ffff8803734dbd80 R15: 
0000000000000001
[ 5871.675245] FS:  0000000000000000(0000) GS:ffff88041f380000(0000) 
knlGS:0000000000000000
[ 5871.675286] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5871.675316] CR2: 0000003b16affc80 CR3: 0000000001a0b000 CR4: 
00000000000407e0
[ 5871.675353] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 5871.675390] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 5871.675426] Process btrfs-endio-wri (pid: 1411, threadinfo 
ffff8802e24fa000, task ffff880406188000)
[ 5871.675471] Stack:
[ 5871.675483]  ffff880060b40ea0 ffff88014a49a3f0 ffff8802e264f000 
0000004400000000
[ 5871.675528]  ffff8802efd16000 ffffffff81167648 0000000000000001 
ffff8801b2f67e30
[ 5871.675572]  ffff8803fed94c00 ffff88002401adf8 0000000000002cff 
00000001011630df
[ 5871.675616] Call Trace:
[ 5871.675633]  [<ffffffff81167648>] ? btrfs_search_old_slot+0x564/0x620
[ 5871.675669]  [<ffffffff811c46bb>] ? __resolve_indirect_refs+0x125/0x408
[ 5871.675706]  [<ffffffff811c535f>] ? find_parent_nodes+0x9c1/0xcec
[ 5871.675739]  [<ffffffff811c5703>] ? btrfs_find_all_roots+0x79/0xd4
[ 5871.675773]  [<ffffffff811c5e74>] ? iterate_extent_inodes+0x13b/0x23c
[ 5871.675808]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 5871.675841]  [<ffffffff811837dd>] ? btrfs_real_readdir+0x482/0x482
[ 5871.675875]  [<ffffffff811c5ffe>] ? iterate_inodes_from_logical+0x89/0x96
[ 5871.675910]  [<ffffffff81182320>] ? record_extent_backrefs+0x4d/0x8e
[ 5871.675944]  [<ffffffff8118a8d3>] ? btrfs_finish_ordered_io+0x671/0x798
[ 5871.675979]  [<ffffffff811a33f3>] ? worker_loop+0x176/0x493
[ 5871.676010]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 5871.676042]  [<ffffffff811a327d>] ? btrfs_queue_worker+0x272/0x272
[ 5871.676076]  [<ffffffff810496d2>] ? kthread+0x81/0x89
[ 5871.676104]  [<ffffffff81050000>] ? free_sched_groups+0x32/0x50
[ 5871.676136]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 5871.676174]  [<ffffffff8151c6ac>] ? ret_from_fork+0x7c/0xb0
[ 5871.676204]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 5871.676240] Code: 85 e4 89 c5 0f 85 d6 00 00 00 e9 db 00 00 00 41 83 7e 
28 05 0f 87 ab 00 00 00 41 8b 46 28 ff 24 c5 20 78 62 81 41 39 6e 2c 73 02 
<0f> 0b 41 8b 56 2c 49 8d 76 38 48 89 df ff c5 e8 7d fb ff ff 49 
[ 5871.676433] RIP  [<ffffffff81161cff>] __tree_mod_log_rewind+0x4c/0x121
[ 5871.676469]  RSP <ffff8802e24fb8f8>
[ 5871.865382] ---[ end trace 4c42d11ebaf277bf ]---

# echo w >/proc/sysrq-trigger

[ 7122.620390] SysRq : Show Blocked State
[ 7122.620398]   task                        PC stack   pid father
[ 7122.620461] BrowserBlocking D ffff88041f392840     0  8323   5292 
0x00000000
[ 7122.620466]  ffff8804089a5400 0000000000000082 ffff88040979db00 
ffff880407765138
[ 7122.620470]  0000000000012840 ffff88035411dfd8 ffff88035411dfd8 
ffff8804089a5400
[ 7122.620474]  0000000000000000 7fffffffffffffff ffffffff8151a227 
7fffffffffffffff
[ 7122.620478] Call Trace:
[ 7122.620488]  [<ffffffff8151a227>] ? console_conditional_schedule+0xf/0xf
[ 7122.620493]  [<ffffffff8151a253>] ? schedule_timeout+0x2c/0xdd
[ 7122.620498]  [<ffffffff811f385c>] ? generic_make_request+0x93/0xd2
[ 7122.620501]  [<ffffffff8151b2db>] ? __wait_for_common+0x9e/0x115
[ 7122.620506]  [<ffffffff81054fb9>] ? try_to_wake_up+0x19e/0x19e
[ 7122.620511]  [<ffffffff8117a3ed>] ? write_dev_flush+0x37/0x126
[ 7122.620515]  [<ffffffff8117bb41>] ? write_all_supers+0x362/0x5b5
[ 7122.620520]  [<ffffffff811aea94>] ? btrfs_sync_log+0x4ba/0x58c
[ 7122.620525]  [<ffffffff8118de74>] ? btrfs_sync_file+0x1c5/0x23e
[ 7122.620531]  [<ffffffff8104f6b4>] ? should_resched+0x5/0x23
[ 7122.620537]  [<ffffffff8111a36c>] ? do_fsync+0x31/0x4e
[ 7122.620541]  [<ffffffff8111a630>] ? sys_fdatasync+0xb/0xf
[ 7122.620546]  [<ffffffff8151c752>] ? system_call_fastpath+0x16/0x1b
[ 7122.620562] konsole         D ffff88041f312840     0  8203      1 
0x00000000
[ 7122.620565]  ffff880408b3a300 0000000000000082 ffff88040979d400 
ffff88041f5eb818
[ 7122.620569]  0000000000012840 ffff88035418ffd8 ffff88035418ffd8 
ffff880408b3a300
[ 7122.620572]  0000000100000002 7fffffffffffffff ffffffff8151a227 
7fffffffffffffff
[ 7122.620576] Call Trace:
[ 7122.620580]  [<ffffffff8151a227>] ? console_conditional_schedule+0xf/0xf
[ 7122.620584]  [<ffffffff8151a253>] ? schedule_timeout+0x2c/0xdd
[ 7122.620588]  [<ffffffff81001631>] ? __switch_to+0x1cd/0x3a6
[ 7122.620591]  [<ffffffff8151b2db>] ? __wait_for_common+0x9e/0x115
[ 7122.620594]  [<ffffffff81054fb9>] ? try_to_wake_up+0x19e/0x19e
[ 7122.620599]  [<ffffffff81045103>] ? flush_work+0xf4/0x10d
[ 7122.620603]  [<ffffffff81043cdb>] ? wq_clamp_max_active+0x74/0x74
[ 7122.620608]  [<ffffffff81240101>] ? proc_clear_tty+0x48/0x55
[ 7122.620612]  [<ffffffff81241a8b>] ? input_available_p+0x15/0x51
[ 7122.620616]  [<ffffffff81241b29>] ? n_tty_poll+0x62/0x125
[ 7122.620620]  [<ffffffff8123f5da>] ? tty_poll+0x54/0x6b
[ 7122.620624]  [<ffffffff81105a23>] ? do_sys_poll+0x1db/0x359
[ 7122.620628]  [<ffffffff81104d89>] ? set_restore_sigmask+0x2d/0x2d
[ 7122.620632]  [<ffffffff81104d89>] ? set_restore_sigmask+0x2d/0x2d
[ 7122.620635]  [<ffffffff81104d89>] ? set_restore_sigmask+0x2d/0x2d
[ 7122.620639]  [<ffffffff81104d89>] ? set_restore_sigmask+0x2d/0x2d
[ 7122.620642]  [<ffffffff81104d89>] ? set_restore_sigmask+0x2d/0x2d
[ 7122.620646]  [<ffffffff81104d89>] ? set_restore_sigmask+0x2d/0x2d
[ 7122.620649]  [<ffffffff81104d89>] ? set_restore_sigmask+0x2d/0x2d
[ 7122.620652]  [<ffffffff81104d89>] ? set_restore_sigmask+0x2d/0x2d
[ 7122.620656]  [<ffffffff81104d89>] ? set_restore_sigmask+0x2d/0x2d
[ 7122.620659]  [<ffffffff81054fb9>] ? try_to_wake_up+0x19e/0x19e
[ 7122.620666]  [<ffffffff81034dc3>] ? timespec_add_safe+0x32/0x63
[ 7122.620670]  [<ffffffff810651b8>] ? ktime_get_ts+0x3d/0x7b
[ 7122.620673]  [<ffffffff81105c2a>] ? sys_poll+0x41/0xa8
[ 7122.620677]  [<ffffffff8151c752>] ? system_call_fastpath+0x16/0x1b
[ 7122.620708] btrfs-transacti D ffff88041f312840     0  2056      2 
0x00000000
[ 7122.620712]  ffff8804089d6200 0000000000000046 ffff88040979d400 
ffffffff8151b229
[ 7122.620715]  0000000000012840 ffff88015fcf3fd8 ffff88015fcf3fd8 
ffff8804089d6200
[ 7122.620718]  ffffffff8104f6b4 7fffffffffffffff ffff88040416cf00 
0000000000000000
[ 7122.620722] Call Trace:
[ 7122.620725]  [<ffffffff8151b229>] ? _cond_resched+0x6/0x1a
[ 7122.620729]  [<ffffffff8104f6b4>] ? should_resched+0x5/0x23
[ 7122.620733]  [<ffffffff8151a253>] ? schedule_timeout+0x2c/0xdd
[ 7122.620737]  [<ffffffff81049d1f>] ? prepare_to_wait+0x19/0x74
[ 7122.620740]  [<ffffffff811805a6>] ? btrfs_commit_transaction+0x293/0x845
[ 7122.620744]  [<ffffffff81049e3a>] ? add_wait_queue+0x3c/0x3c
[ 7122.620747]  [<ffffffff81181370>] ? start_transaction+0x33c/0x445
[ 7122.620751]  [<ffffffff8103af7a>] ? usleep_range+0x3e/0x3e
[ 7122.620755]  [<ffffffff8104f6b4>] ? should_resched+0x5/0x23
[ 7122.620759]  [<ffffffff8117a65b>] ? transaction_kthread+0xd1/0x176
[ 7122.620763]  [<ffffffff8117a58a>] ? try_to_freeze+0x31/0x31
[ 7122.620767]  [<ffffffff8117a58a>] ? try_to_freeze+0x31/0x31
[ 7122.620770]  [<ffffffff810496d2>] ? kthread+0x81/0x89
[ 7122.620774]  [<ffffffff81050000>] ? free_sched_groups+0x32/0x50
[ 7122.620778]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 7122.620782]  [<ffffffff8151c6ac>] ? ret_from_fork+0x7c/0xb0
[ 7122.620785]  [<ffffffff81049651>] ? 
kthread_freezable_should_stop+0x36/0x36
[ 7122.620788] bedup           D ffff88041f292840     0  2510   2509 
0x00000000
[ 7122.620791]  ffff8801a907d400 0000000000000086 ffff88040979cd00 
0000000000030000
[ 7122.620794]  0000000000012840 ffff88015968dfd8 ffff88015968dfd8 
ffff8801a907d400
[ 7122.620798]  0000000000000246 ffff8802ae1f0f08 ffff8802d5e749e8 
ffff88015968dd50
[ 7122.620801] Call Trace:
[ 7122.620805]  [<ffffffff8117fe1c>] ? wait_current_trans.isra.32+0xae/0xdd
[ 7122.620808]  [<ffffffff81049e3a>] ? add_wait_queue+0x3c/0x3c
[ 7122.620811]  [<ffffffff81181445>] ? start_transaction+0x411/0x445
[ 7122.620815]  [<ffffffff8104f6b4>] ? should_resched+0x5/0x23
[ 7122.620818]  [<ffffffff811a789a>] ? btrfs_ioctl+0x50a/0x1808
[ 7122.620823]  [<ffffffff810d3684>] ? do_mmap_pgoff+0x29a/0x321
[ 7122.620827]  [<ffffffff8104f6b4>] ? should_resched+0x5/0x23
[ 7122.620830]  [<ffffffff8151b229>] ? _cond_resched+0x6/0x1a
[ 7122.620834]  [<ffffffff810fb04d>] ? cp_new_stat+0x113/0x126
[ 7122.620838]  [<ffffffff81104398>] ? do_vfs_ioctl+0x41e/0x48f
[ 7122.620842]  [<ffffffff810fb3d5>] ? sys_newfstat+0x23/0x2b
[ 7122.620845]  [<ffffffff8110444b>] ? sys_ioctl+0x42/0x63
[ 7122.620848]  [<ffffffff8151c752>] ? system_call_fastpath+0x16/0x1b


