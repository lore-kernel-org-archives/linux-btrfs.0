From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Kernel BUG unable to handle kernel NULL pointer dereference
Date: Sat, 22 Oct 2011 21:23:09 +0100
Message-ID: <CAAeznTqh1W0W743WxTO+iUfajgsMw-A6abwr1fAZ6hWOJOnw2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, I got a kernel bug error, my guess from BTRFS.

Here is the report,
Oct 22 20:44:43 localhost kernel: [25554.947970] BUG: unable to handle
kernel NULL pointer dereference at 0000000000000030
Oct 22 20:44:43 localhost kernel: [25554.948002] IP:
[<ffffffffa01ab027>] btrfs_print_leaf+0x37/0x880 [btrfs]
Oct 22 20:44:43 localhost kernel: [25554.948037] PGD bfa44067 PUD
bfa43067 PMD 0
Oct 22 20:44:43 localhost kernel: [25554.948052] Oops: 0000 [#1] PREEMPT SMP
Oct 22 20:44:43 localhost kernel: [25554.948066] CPU 1
Oct 22 20:44:43 localhost kernel: [25554.948072] Modules linked in:
nls_cp437 vfat fat ipv6 loop fuse hid_apple usbhid hid uvcvideo
videodev media v4l2_compat_ioctl32 adt7475 hwmon_vid evdev nouveau
snd_emu10k1 snd_rawmidi snd_intel8x0 ttm drm_kms_helper sg
snd_ac97_codec snd_seq_device firewire_ohci drm snd_util_mem ac97_bus
snd_pcm snd_hwdep edac_core k8temp psmouse firewire_core emu10k1_gp
snd_timer edac_mce_amd pcspkr snd i2c_algo_bit gameport mxm_wmi wmi
crc_itu_t serio_raw soundcore video snd_page_alloc fan i2c_nforce2
thermal i2c_core floppy processor button uas usb_storage forcedeth
btrfs zlib_deflate crc32c libcrc32c ext4 jbd2 crc16 ext3 jbd mbcache
ohci_hcd ehci_hcd usbcore sr_mod sd_mod cdrom sata_nv pata_amd libata
scsi_mod
Oct 22 20:44:43 localhost kernel: [25554.948321]
Oct 22 20:44:43 localhost kernel: [25554.948327] Pid: 4834, comm:
firefox Not tainted 3.0-ARCH #1    /LP UT NF4 Expert
Oct 22 20:44:43 localhost kernel: [25554.948522] RIP:
0010:[<ffffffffa01ab027>]  [<ffffffffa01ab027>]
btrfs_print_leaf+0x37/0x880 [btrfs]
Oct 22 20:44:43 localhost kernel: [25554.948547] RSP:
0018:ffff8800b341fb38  EFLAGS: 00010282
Oct 22 20:44:43 localhost kernel: [25554.948557] RAX: 00000000ffffffe4
RBX: 0000000000000000 RCX: ffff8800b341ffd8
Oct 22 20:44:43 localhost kernel: [25554.948570] RDX: ffff8800b341e000
RSI: 0000000000000000 RDI: ffff880135075000
Oct 22 20:44:43 localhost kernel: [25554.948582] RBP: ffff8800b341fbc8
R08: ffffffffffffffff R09: 0000000000000000
Oct 22 20:44:43 localhost kernel: [25554.948595] R10: 00000000ffffffe4
R11: 0000000000000000 R12: 0000000000000005
Oct 22 20:44:43 localhost kernel: [25554.948607] R13: 0000000005114000
R14: 00000000ffffffe4 R15: 0000000000001000
Oct 22 20:44:43 localhost kernel: [25554.948621] FS:
00007f1c5a2f4720(0000) GS:ffff88013fd00000(0000)
knlGS:00000000f68227f0
Oct 22 20:44:43 localhost kernel: [25554.948634] CS:  0010 DS: 0000
ES: 0000 CR0: 0000000080050033
Oct 22 20:44:43 localhost kernel: [25554.948645] CR2: 0000000000000030
CR3: 00000000bfa41000 CR4: 00000000000006e0
Oct 22 20:44:43 localhost kernel: [25554.948658] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Oct 22 20:44:43 localhost kernel: [25554.948670] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct 22 20:44:43 localhost kernel: [25554.948683] Process firefox (pid:
4834, threadinfo ffff8800b341e000, task ffff88012d817300)
Oct 22 20:44:43 localhost kernel: [25554.948701] Stack:
Oct 22 20:44:43 localhost kernel: [25554.948708]  0000000000002000
0000000000001000 ffff8800b341fc70 0000000005114000
Oct 22 20:44:43 localhost kernel: [25554.948730]  0000000000000282
ffffffff81142c03 ffff880135075000 0000000000000090
Oct 22 20:44:43 localhost kernel: [25554.948755]  0000000000000090
0000805037106510 a800000000051140 0000000000001000
Oct 22 20:44:43 localhost kernel: [25554.948777] Call Trace:
Oct 22 20:44:43 localhost kernel: [25554.948787]  [<ffffffff81142c03>]
? kmem_cache_alloc+0x133/0x160
Oct 22 20:44:43 localhost kernel: [25554.948807]  [<ffffffffa01a32df>]
__btrfs_free_extent+0x61f/0x6d0 [btrfs]
Oct 22 20:44:43 localhost kernel: [25554.948827]  [<ffffffffa01a5b6d>]
? run_clustered_refs+0x11d/0x830 [btrfs]
Oct 22 20:44:43 localhost kernel: [25554.948847]  [<ffffffffa01a5dd9>]
run_clustered_refs+0x389/0x830 [btrfs]
Oct 22 20:44:43 localhost kernel: [25554.948867]  [<ffffffffa01a6348>]
btrfs_run_delayed_refs+0xc8/0x220 [btrfs]
Oct 22 20:44:43 localhost kernel: [25554.948881]  [<ffffffff813f29ce>]
? mutex_unlock+0xe/0x10
Oct 22 20:44:43 localhost kernel: [25554.948900]  [<ffffffffa01b8381>]
btrfs_commit_transaction+0x81/0x8a0 [btrfs]
Oct 22 20:44:43 localhost kernel: [25554.948915]  [<ffffffff8107f790>]
? abort_exclusive_wait+0xb0/0xb0
Oct 22 20:44:43 localhost kernel: [25554.948928]  [<ffffffff8116e6be>]
? dput+0x10e/0x1a0
Oct 22 20:44:43 localhost kernel: [25554.948948]  [<ffffffffa01c6ac4>]
btrfs_sync_file+0x194/0x1e0 [btrfs]
Oct 22 20:44:43 localhost kernel: [25554.948961]  [<ffffffff8118321f>]
vfs_fsync_range+0x5f/0xa0
Oct 22 20:44:43 localhost kernel: [25554.948973]  [<ffffffff811832cc>]
vfs_fsync+0x1c/0x20
Oct 22 20:44:43 localhost kernel: [25554.948984]  [<ffffffff811835e3>]
sys_fsync+0x33/0x50
Oct 22 20:44:43 localhost kernel: [25554.948995]  [<ffffffff813f4c42>]
system_call_fastpath+0x16/0x1b
Oct 22 20:44:43 localhost kernel: [25554.949008] Code: 89 5d d8 4c 89
65 e0 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 66 66 66 66 90 65 48 8b 0c
25 48 cd 00 00 48 8d 91 28 e0 ff ff 48 89 f3
Oct 22 20:44:43 localhost kernel: [25554.949269] RIP
[<ffffffffa01ab027>] btrfs_print_leaf+0x37/0x880 [btrfs]
Oct 22 20:44:43 localhost kernel: [25554.949292]  RSP <ffff8800b341fb38>
Oct 22 20:44:43 localhost kernel: [25554.949300] CR2: 0000000000000030
Oct 22 20:44:43 localhost kernel: [25554.957960] ---[ end trace
e3b54094ec35959e ]---

Anyone stumble upon it?

After this a couple of BUG dumps followed, check this pastebin
http://paste.pocoo.org/show/496620/


I am a on a Arch system with BTRFS root filesystem
$ pacman -Si linux
Repository     : core
Name           : linux
Version        : 3.0.7-1
URL            : http://www.kernel.org/
Licenses       : GPL2
Groups         : base
Provides       : kernel26
Depends On     : coreutils  linux-firmware  module-init-tools>=3.16
mkinitcpio>=0.7
Optional Deps  : crda: to set the correct wireless channels of your country
Conflicts With : kernel26
Replaces       : kernel26
Download Size  : 38639.75 K
Installed Size : 57060.00 K
Packager       : Tobias Powalowski <tpowa@archlinux.org>
Architecture   : x86_64
Build Date     : Wed 19 Oct 2011 09:31:33 AM BST
MD5 Sum        : 1fa49419794d5b4c04fdd0b275f6649b
Description    : The Linux Kernel and modules

btrfs-tools : Btrfs v0.19-85-gd4bb086
I am on an SSD drive.

My mounts are like:
/dev/sda2 on / type btrfs (rw,noatime,ssd)
/dev/sda3 on /home type btrfs (rw,noatime,ssd)


Regards
Leonidas

-- 
Caution: breathing may be hazardous to your health.
