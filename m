From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Oops on a converted ext4 system
Date: Tue, 26 May 2009 08:27:28 +0200
Message-ID: <4A1B8BD0.6050203@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I converted an ext4 filesystem with btrfs-convert, mounted it, and wanted to do "lzop -d ...".

The result was an immediate Oops (btrfs is on LVM, on dm-crypt, on /dev/sdb which is USB-connected).


mini-904.img.lzo dentry_open failed
BUG: unable to handle kernel paging request at ffffffcd
IP: [<c01b5f36>] fput+0x6/0x30
*pde = 00575067 *pte = 00000000
Oops: 0002 [#1] SMP
last sysfs file: /sys/block/sda/removable
Modules linked in: kqemu sha256_generic aes_i586 aes_generic cbc usb_storage dm_crypt btrfs zlib_deflate crc32c libcrc32c tun radeon drm usblp af_packet ipv6 binfmt_misc loop dm_mirror dm_region_hash dm_log dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave p4_clockmod freq_table speedstep_lib snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device joydev snd_pcm_oss snd_pcm snd_timer usbhid hid snd_mixer_oss snd dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common dvb_usb soundcore rng_core dvb_core r8169 sg sr_mod iTCO_wdt snd_page_alloc mii intel_agp agpgart shpchp rtc_cmos processor pci_hotplug i2c_i801 thermal button ehci_hcd iTCO_vendor_support i2c_core uhci_hcd evdev usbcore ata_generic ide_pci_generic pata_acp
 i piix ide_gd_mod ide_core ahci ata_piix libata sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16

Pid: 11454, comm: lzop Not tainted (2.6.30-0.rc7.1mdv #1) MS-6728
EIP: 0060:[<c01b5f36>] EFLAGS: 00010282 CPU: 0
EIP is at fput+0x6/0x30
EAX: ffffffb5 EBX: ffffffb5 ECX: ffffffd9 EDX: ffffffcd
ESI: f5269964 EDI: 00000004 EBP: c4fd3e70 ESP: c4fd3e70
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process lzop (pid: 11454, ti=c4fd2000 task=c1cb9880 task.ti=c4fd2000)
Stack:
 c4fd3e98 c022eb15 c0486207 f5269964 00fd3e88 df884430 df884410 c4fd3f04
 c9f912a0 f5269908 c4fd3ebc c01bce4c c4fd3ebc c01bf48c 00008001 00000024
 00008001 c4fd3f04 00000024 c4fd3f70 c01c03db c4fd3f04 c17c9ae0 00000000
Call Trace:
 [<c022eb15>] ? ima_path_check+0x195/0x1d0
 [<c01bce4c>] ? may_open+0xbc/0x240
 [<c01bf48c>] ? do_path_lookup+0x6c/0x190
 [<c01c03db>] ? do_filp_open+0x16b/0x900
 [<c0185961>] ? unlock_page+0x41/0x50
 [<c019ae98>] ? __do_fault+0x318/0x400
 [<c019bdb7>] ? handle_mm_fault+0xf7/0x6a0
 [<c01b2915>] ? do_sys_open+0x55/0xf0
 [<c01b2a19>] ? sys_open+0x29/0x40
 [<c0103a3c>] ? sysenter_do_call+0x12/0x28
Code: ff ff ff 8b 70 44 85 f6 90 8d 74 26 00 0f 84 e5 fe ff ff 31 c9 89 da 83 c8 ff ff d6 e9 d0 fe ff ff 8d 74 26 00 55 89 e5 8d 50 18 <f0> ff 0a 0f 94 c1 84 c9 75 08 5d c3 8d b6 00 00 00 00 e8 13 fe
EIP: [<c01b5f36>] fput+0x6/0x30 SS:ESP 0068:c4fd3e70
CR2: 00000000ffffffcd
---[ end trace 86b77908c796fc8f ]---



-- 
Tomasz Chmielewski
http://wpkg.org
