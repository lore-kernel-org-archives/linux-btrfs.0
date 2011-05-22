From: Marco Neubauer <icetea1@gmx.net>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2271!
Date: Sun, 22 May 2011 13:13:05 +0200
Message-ID: <63FD432D-9173-40E4-9A82-711C8C625B0E@gmx.net>
References: <383ECFA9-9E51-4CCD-BE24-21FD30813217@gmx.net> <4DC0170C.8000906@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC0170C.8000906@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


Am 03.05.2011 um 16:54 schrieb Josef Bacik:

> On 04/27/2011 02:52 PM, Marco Neubauer wrote:
>> Hi,
>> 
>> this is happening mostly every night. I can't reproduce it right now.
>> vanilla kernel 2.6.38.4
>> 
> 
> Can you update to a newer kernel, this should be fixed there.  Thanks,

It's happening again.

------------[ cut here ]------------
WARNING: at fs/btrfs/inode.c:2394 btrfs_orphan_cleanup+0x1fe/0x3b0()
Hardware name: System Product Name
Modules linked in: w83627ehf hwmon_vid coretemp md4 cifs vboxnetadp vboxnetflt vboxdrv firewire_ohci firewire_core i915 asus_atk0110 hwmon drm_kms_helper video backlight
Pid: 12355, comm: updatedb Not tainted 2.6.39 #1
Call Trace:
[<ffffffff8103f16b>] ? warn_slowpath_common+0x7b/0xc0
[<ffffffff81250fee>] ? btrfs_orphan_cleanup+0x1fe/0x3b0
[<ffffffff812509a3>] ? btrfs_iget+0x53/0x4a0
[<ffffffff812515b8>] ? btrfs_lookup_dentry+0x418/0x490
[<ffffffff81251639>] ? btrfs_lookup+0x9/0x20
[<ffffffff810f7e3c>] ? d_alloc_and_lookup+0x3c/0x90
[<ffffffff81102a6e>] ? d_lookup+0x2e/0x60
[<ffffffff810f98db>] ? do_lookup+0xcb/0x2b0
[<ffffffff810f9c0b>] ? path_init+0x14b/0x3d0
[<ffffffff810fbf74>] ? path_lookupat+0x154/0x750
[<ffffffff810f99f0>] ? do_lookup+0x1e0/0x2b0
[<ffffffff810fc59c>] ? do_path_lookup+0x2c/0xd0
[<ffffffff810f8776>] ? getname_flags+0x126/0x260
[<ffffffff810fd31c>] ? user_path_at+0x5c/0xc0
[<ffffffff810fc59c>] ? do_path_lookup+0x2c/0xd0
[<ffffffff810f1f50>] ? cp_new_stat+0xe0/0x100
[<ffffffff810f2053>] ? vfs_fstatat+0x43/0x80
[<ffffffff810f211f>] ? sys_newlstat+0x1f/0x50
[<ffffffff8169e47b>] ? system_call_fastpath+0x16/0x1b
---[ end trace dfa7e3e0b20f3e13 ]---
------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:2285!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
CPU 0 
Modules linked in: w83627ehf hwmon_vid coretemp md4 cifs vboxnetadp vboxnetflt vboxdrv firewire_ohci firewire_core i915 asus_atk0110 hwmon drm_kms_helper video backlight

Pid: 12355, comm: updatedb Tainted: G        W   2.6.39 #1 System manufacturer System Product Name/V-P5G45
RIP: 0010:[<ffffffff8124b8e6>]  [<ffffffff8124b8e6>] btrfs_orphan_del+0xe6/0xf0
RSP: 0018:ffff880186b81ab8  EFLAGS: 00010282
RAX: 00000000fffffffe RBX: ffff88007e72ed40 RCX: 0000000000d14404
RDX: 0000000000d14400 RSI: 00000000000199b0 RDI: ffffea0007a2c310
RBP: 0000000000000000 R08: ffffffff8127b4b8 R09: 000000000000021f
R10: 0000000000000047 R11: 0000000000000000 R12: ffff8801eae47640
R13: ffff88022dee5800 R14: ffff88022dee5b30 R15: 0000000000000001
FS:  00007feb837fe700(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000310b011 CR3: 0000000183fb6000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process updatedb (pid: 12355, threadinfo ffff880186b80000, task ffff88021537c060)
Stack:
ffff880100da2158 ffff88022dee5800 ffff88022e80e900 ffff88022dee5b30
ffff88022dee5b38 ffff880186b81b58 ffff880186b81b18 ffffffff8125104b
ffff880186b80010 ffff88007e72ed40 ffff8801eae47640 00000000159e523f
Call Trace:
[<ffffffff8125104b>] ? btrfs_orphan_cleanup+0x25b/0x3b0
[<ffffffff812509a3>] ? btrfs_iget+0x53/0x4a0
[<ffffffff812515b8>] ? btrfs_lookup_dentry+0x418/0x490
[<ffffffff81251639>] ? btrfs_lookup+0x9/0x20
[<ffffffff810f7e3c>] ? d_alloc_and_lookup+0x3c/0x90
[<ffffffff81102a6e>] ? d_lookup+0x2e/0x60
[<ffffffff810f98db>] ? do_lookup+0xcb/0x2b0
[<ffffffff810f9c0b>] ? path_init+0x14b/0x3d0
[<ffffffff810fbf74>] ? path_lookupat+0x154/0x750
[<ffffffff810f99f0>] ? do_lookup+0x1e0/0x2b0
[<ffffffff810fc59c>] ? do_path_lookup+0x2c/0xd0
[<ffffffff810f8776>] ? getname_flags+0x126/0x260
[<ffffffff810fd31c>] ? user_path_at+0x5c/0xc0
[<ffffffff810fc59c>] ? do_path_lookup+0x2c/0xd0
[<ffffffff810f1f50>] ? cp_new_stat+0xe0/0x100
[<ffffffff810f2053>] ? vfs_fstatat+0x43/0x80
[<ffffffff810f211f>] ? sys_newlstat+0x1f/0x50
[<ffffffff8169e47b>] ? system_call_fastpath+0x16/0x1b
Code: 4c 8b 6c 24 20 4c 8b 74 24 28 4c 8b 7c 24 30 48 83 c4 38 c3 90 48 8b 93 a8 00 00 00 4c 89 ee 4c 89 e7 e8 5e fb 02 00 85 c0 74 b8 <0f> 0b eb fe 66 0f 1f 44 00 00 53 48 8d 86 38 03 00 00 48 89 f3 
RIP  [<ffffffff8124b8e6>] btrfs_orphan_del+0xe6/0xf0
RSP <ffff880186b81ab8>
---[ end trace dfa7e3e0b20f3e14 ]---

# btrfs fi show
Label: 'ROOT'  uuid: 0292b87e-84b3-457f-abae-c2eb03e9d08e
	Total devices 1 FS bytes used 15.73GB
	devid    1 size 111.67GB used 49.79GB path /dev/sdc2

Label: 'DATA'  uuid: 07f62881-5cc4-4f8f-b304-7e7a3aae4adc
	Total devices 1 FS bytes used 572.87GB
	devid    1 size 592.25GB used 592.25GB path /dev/md1

Btrfs Btrfs v0.19


# btrfs sub list /
ID 267 top level 5 path subvol/home

# btrfs sub list /var/
ID 643 top level 5 path subvol/tmp
ID 644 top level 5 path subvol/var
ID 730 top level 5 path subvol/homedata

# mount
/dev/root on / type btrfs (rw,relatime,compress=zlib,ssd,discard,space_cache)
/dev/sdc2 on /home type btrfs (rw,subvolid=267,compress,space_cache,ssd,discard)
/dev/md1 on /homedata type btrfs (rw,subvolid=730,compress,space_cache)
/dev/md1 on /tmp type btrfs (rw,subvolid=643,compress,space_cache)
/dev/md1 on /var type btrfs (rw,subvolid=644,compress,space_cache)



-marco




