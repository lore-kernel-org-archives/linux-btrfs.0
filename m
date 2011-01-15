From: cwillu <cwillu@cwillu.com>
Subject: Re: BUG in btrfs/inode.c:1528!
Date: Fri, 14 Jan 2011 23:15:34 -0600
Message-ID: <AANLkTiny2u5Cv9R1d7jMg_GAoTgcVHg=WhrBh8k3-OXv@mail.gmail.com>
References: <1295053074.15265.6.camel@mercury.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Niklas Schnelle <niklas@komani.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1295053074.15265.6.camel@mercury.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 14, 2011 at 6:57 PM, Niklas Schnelle <niklas@komani.de> wrote:
> I was running a "cp -ar /mnt/extern/foo/* /mnt/extern/bar/subvolume/" on
> my USB harddrive which was formatted yesterday (rsyncing about 90 GB
> worked yesterday without problems)
> when I was dropped to a console with the error snippet below, the cp
> kept on working
> as if nothing happened and has since finished. The filesystem seems to
> have keep working normaly with only unmounting not closing without a
> kill however btrfsck reported everything to be ok and using it now on
> another computer it seems to work perfectly.
> Also on the first try I did mv instead of cp but that said something
> about subvolume boundaries and failed. I've been using btrfs on multi
> device on an atom server for over a year now without major problems
> (only also the mv across subvolume boundaries once).
>
> Btw: Is anyone reading
> https://bugzilla.kernel.org/buglist.cgi?quicksearch=btrfs
>
> all bugs are still NEW..
>
> Here is my trace: (ignore the radeon ERRORs the radeon in this old iMac
> (first
> intel Gen. is really badly supported but works)

/var/log/kernel.log-Jan 14 17:20:58 mercury kernel: Btrfs loaded
/var/log/kernel.log-Jan 14 17:20:58 mercury kernel: device label
extern devid 1 transid 168 /dev/sdb1
/var/log/kernel.log-Jan 14 17:20:58 mercury kernel: btrfs: use compression
/var/log/kernel.log-Jan 14 17:20:58 mercury kernel: Adding 1048572k
swap on /swapfile.  Priority:-1 extents:46 across:65110016k
/var/log/kernel.log-Jan 14 17:21:00 mercury kernel: sky2 0000:02:00.0:
eth0: enabling interface
/var/log/kernel.log-Jan 14 17:21:02 mercury kernel: sky2 0000:02:00.0:
eth0: Link is up at 1000 Mbps, full duplex, flow control both
/var/log/kernel.log-Jan 14 17:21:10 mercury kernel: sshd (1970):
/proc/1970/oom_adj is deprecated, please use /proc/1970/oom_score_adj
instead.
/var/log/kernel.log-Jan 14 17:21:10 mercury kernel: NET: Registered
protocol family 10
/var/log/kernel.log-Jan 14 17:21:10 mercury kernel: lo: Disabled
Privacy Extensions
/var/log/kernel.log-Jan 14 17:21:20 mercury kernel: eth0: no IPv6
routers present
/var/log/kernel.log-Jan 14 17:45:45 mercury kernel: i2c i2c-0:
readbytes: ack/nak timeout
/var/log/kernel.log-Jan 14 17:45:45 mercury kernel:
[drm:radeon_dvi_detect] *ERROR* DVI-I-1: probed a monitor but
no|invalid EDID
/var/log/kernel.log-Jan 14 18:23:34 mercury kernel:
[drm:radeon_dvi_detect] *ERROR* DVI-I-1: probed a monitor but
no|invalid EDID
/var/log/kernel.log-Jan 14 18:29:17 mercury kernel:
[drm:radeon_dvi_detect] *ERROR* DVI-I-1: probed a monitor but
no|invalid EDID
/var/log/kernel.log-Jan 14 18:29:17 mercury kernel: i2c i2c-0:
sendbytes: NAK bailout.
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: ------------[ cut
here ]------------ /var/log/kernel.log:Jan 14 19:11:46 mercury kernel:
kernel BUG at fs/btrfs/inode.c:1528!
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: invalid opcode:
0000 [#1] PREEMPT SMP
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: last sysfs file:
/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card0/uevent
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: Modules linked in:
ipv6 btrfs zlib_deflate crc32c libcrc32c btusb bluetooth snd_seq_dummy
snd_seq_oss snd_seq_midi_event arc4 snd_seq usbhid snd_usb_audio ecb
isight_firmware snd_pcm_oss snd_usbmidi_lib snd_rawmidi snd_seq_device
snd_mixer_oss hid usb_storage b43 snd_hda_codec_idt mac80211 radeon
cfg80211 snd_hda_intel rfkill snd_hda_codec ssb snd_hwdep ttm mmc_core
pcmcia drm_kms_helper sg sky2 pcmcia_core drm snd_pcm iTCO_wdt
intel_agp iTCO_vendor_support snd_timer firewire_ohci i2c_i801
i2c_algo_bit agpgart snd soundcore snd_page_alloc video firewire_core
applesmc i2c_core led_class output input_polldev usblp crc_itu_t
vboxdrv fuse tpm_infineon evdev cpufreq_ondemand pcspkr thermal tpm
tpm_bios button acpi_cpufreq freq_table processor mperf ext4 mbcache
jbd2 crc16 sd_mod sr_mod cdrom ata_piix pata_acpi uhci_hcd libata
ehci_hcd scsi_mod usbcore
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel:
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: Pid: 1661, comm:
btrfs-fixup-0 Not tainted 2.6.36-ARCH #1 Mac-F42787C8/iMac4,1
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: EIP:
0060:[<f9ff1dd3>] EFLAGS: 00010246 CPU: 1
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: EIP is at
btrfs_writepage_fixup_worker+0x153/0x160 [btrfs]
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: EAX: 00000000 EBX:
032b2000 ECX: ef2d5f00 EDX: 00000000
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: ESI: 00000000 EDI:
c1be3ca0 EBP: ef2d5f50 ESP: ef2d5f18
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: DS: 007b ES: 007b
FS: 00d8 GS: 00e0 SS: 0068
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: Process
btrfs-fixup-0 (pid: 1661, ti=ef2d4000 task=f6ade280 task.ti=ef2d4000)
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: Stack:
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: 032b2fff 00000000
00000008 ef2d5f40 00000050 00000000 e65653a0 032b2fff
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: <0> 00000000
e656549c c82c4058 f71e0880 c2042598 f71e088c ef2d5fb8 fa01cc19
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: <0> 00000000
00000001 00000086 ef3c5cd4 ef2d5fa0 ef2d5f98 c2042584 c103e80b
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: Call Trace:
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: [<fa01cc19>] ?
worker_loop+0x79/0x4b0 [btrfs]
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: [<c103e80b>] ?
default_wake_function+0xb/0x10
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: [<c102fc40>] ?
__wake_up_common+0x40/0x70
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: [<fa01cba0>] ?
worker_loop+0x0/0x4b0 [btrfs]
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: [<c10609c4>] ?
kthread+0x74/0x80
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: [<c1060950>] ?
kthread+0x0/0x80
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: [<c1003d3e>] ?
kernel_thread_helper+0x6/0x18
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: Code: 89 54 24 08
8b 55 e8 c7 44 24 0c 50 00 00 00 89 04 24 8b 45 e0 89 54 24 04 89 da
e8 08 ec 01 00 eb bf 89 f8 e8 2f cd 0c c7 eb a6 <0f> 0b 8d 74 26 00 8d
bc 27 00 00 00 00 55 f6 40 d4 04 89 e5 75
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: EIP: [<f9ff1dd3>]
btrfs_writepage_fixup_worker+0x153/0x160 [btrfs] SS:ESP 0068:ef2d5f18
/var/log/kernel.log-Jan 14 19:11:46 mercury kernel: ---[ end trace
2d8fb9f60351d6d8 ]---
/var/log/kernel.log-Jan 14 19:13:09 mercury kernel:
[drm:radeon_dvi_detect] *ERROR* DVI-I-1: probed a monitor but
no|invalid EDID
