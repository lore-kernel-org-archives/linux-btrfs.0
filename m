From: Evert Vorster <evorster@gmail.com>
Subject: unmountable filesystem...
Date: Sat, 27 Nov 2010 04:24:08 -0700
Message-ID: <AANLkTinGMadq=78jf35WSkSsG8BzAwtYaz_Hb1iuvV4H@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there...

This is something weird that happened.

I was having problems with having a btrfs root, so I copied the root
filesystem to an external USB hard drive. Then I rebooted the computer
from a CD-ROM, and re-created my root partition with ext4.

Then I mounted the USB hard drive ( also btrfs ) to a different
directory, and proceeded in copying my root back. This went well, and
then I chrooted to the new root, and ran lilo to update my bootblock.

Then I exited the chroot, and wanted to unmount the usb disk. This
hung up my tty solid. I was only reading from the USB device, so I
figured that since I was not writing to the usb device, I could unplug
it.

This gave me a kernel oops.

So, I hard-rebooted, and booted into my newly created root.

Now the usb drive does not want to mount anymore, with the following
message in dmesg:

usb 7-5.3: new high speed USB device using ehci_hcd and address 7
usb 7-5.3: New USB device found, idVendor=0bc2, idProduct=5021
usb 7-5.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 7-5.3: Product: FreeAgent GoFlex
usb 7-5.3: Manufacturer: Seagate
usb 7-5.3: SerialNumber: NA050N36
scsi9 : usb-storage 7-5.3:1.0
scsi 9:0:0:0: Direct-Access     Seagate  FreeAgent GoFlex 0148 PQ: 0 ANSI: 4
sd 9:0:0:0: Attached scsi generic sg9 type 0
sd 9:0:0:0: [sdi] 1953525167 512-byte logical blocks: (1.00 TB/931 GiB)
sd 9:0:0:0: [sdi] Write Protect is off
sd 9:0:0:0: [sdi] Mode Sense: 1c 00 00 00
sd 9:0:0:0: [sdi] Assuming drive cache: write through
sd 9:0:0:0: [sdi] Assuming drive cache: write through
 sdi: sdi1
sd 9:0:0:0: [sdi] Assuming drive cache: write through
sd 9:0:0:0: [sdi] Attached SCSI disk
device label TeraByte1 devid 1 transid 6339 /dev/sdi1
verify_parent_transid: 28 callbacks suppressed
parent transid verify failed on 611018129408 wanted 6339 found 6619
parent transid verify failed on 611018129408 wanted 6339 found 6619
parent transid verify failed on 611018129408 wanted 6339 found 6619
BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
IP: [<ffffffff81031925>] __ticket_spin_lock+0x5/0x20
PGD 224526067 PUD 224525067 PMD 0
Oops: 0002 [#1] SMP
last sysfs file: /sys/devices/virtual/bdi/btrfs-3/uevent
CPU 0
Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq ipv6 snd_pcm_oss snd_mixer_oss binfmt_misc ext2 btrfs
zlib_deflate crc32c libcrc32c ext4 mbcache jbd2 crc32 crc16 af_packet
scsi_wait_scan fuse dm_mod joydev usbhid hid nvidia(P) usb_storage
usb_libusual sg sr_mod sd_mod cdrom crc_t10dif ata_generic pata_acpi
pata_jmicron 8250_pnp ohci1394 ieee1394 snd_cmipci gameport
snd_opl3_lib snd_pcm snd_hwdep ahci libahci snd_timer libata rtc_cmos
evdev firewire_ohci snd_mpu401_uart ehci_hcd 8250 uhci_hcd rtc_core
snd_rawmidi firewire_core snd_seq_device snd i2c_i801 iTCO_wdt rtc_lib
usbcore crc_itu_t serial_core i2c_core floppy iTCO_vendor_support
button processor soundcore snd_page_alloc pcspkr shpchp psmouse
serio_raw e1000e scsi_mod nls_base thermal pci_hotplug intel_agp
configfs [last unloaded: cfbfillrect]

Pid: 1174, comm: mount Tainted: P            2.6.36.1 #1 DG35EC/
RIP: 0010:[<ffffffff81031925>]  [<ffffffff81031925>] __ticket_spin_lock+0x5/0x20
RSP: 0018:ffff88022454bb58  EFLAGS: 00010246
RAX: 0000000000000100 RBX: ffff880224556210 RCX: ffff880224554000
RDX: ffff880224554168 RSI: ffff880224554140 RDI: 00000000000000a8
RBP: ffff880224554000 R08: 0000160000000000 R09: 0000000000000000
R10: 0000000000000010 R11: 0000000000000008 R12: 0000000000000000
R13: 00000000000000a8 R14: 0000000000000000 R15: 0000000000000004
FS:  00007f9907dbf740(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000a8 CR3: 0000000224523000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 1174, threadinfo ffff88022454a000, task ffff8802054c4000)
Stack:
 ffffffff81313335 ffffffffa0df7f3f 0000000000000001 ffff8802245561c8
<0> ffff880222252090 ffff880224556210 ffff880221436800 ffff880221433800
<0> ffff880221437800 ffffffffa0df9618 0000008e68017000 00000000221c03fc
Call Trace:
 [<ffffffff81313335>] ? _raw_spin_lock+0x5/0x10
 [<ffffffffa0df7f3f>] ? btrfs_delalloc_release_space+0x59f/0x720 [btrfs]
 [<ffffffffa0df9618>] ? btrfs_read_block_groups+0x608/0x890 [btrfs]
 [<ffffffffa0e0abd2>] ? open_ctree+0xfd2/0x1b40 [btrfs]
 [<ffffffffa0debbde>] ? 0xffffffffa0debbde
 [<ffffffff81103eb3>] ? vfs_kern_mount+0x83/0x200
 [<ffffffff811040a3>] ? do_kern_mount+0x53/0x130
 [<ffffffff8111d648>] ? do_mount+0x2f8/0x8a0
 [<ffffffff810c840f>] ? memdup_user+0x3f/0x80
 [<ffffffff8111dc8a>] ? sys_mount+0x9a/0xf0
 [<ffffffff8100aec2>] ? system_call_fastpath+0x16/0x1b
Code: ff 0f 1f 44 00 00 48 c7 c2 2e 17 03 81 48 c7 c1 31 17 03 81 e9
dd fe ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 b8 00 01 00 00 <f0>
66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c3 66 66 2e 0f 1f
RIP  [<ffffffff81031925>] __ticket_spin_lock+0x5/0x20
 RSP <ffff88022454bb58>
CR2: 00000000000000a8
---[ end trace 136e10b80e427347 ]---



btrfsck also does not repair the drive.

Is there any way of getting any of the information off of this disk?

-Evert Vorster-
This is on kernel 2.6.36.1, by the way.

-- 
http://magnatune.com - Music shared the way it should be.
