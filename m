From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: csum errors
Date: Tue, 10 Aug 2010 23:06:34 +0200
Message-ID: <AANLkTinNXRGC8whX5zkbjii+qDdihON8CW4j-=jVEofs@mail.gmail.com>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
	<201007152030.18431.johannes.hirte@fem.tu-ilmenau.de>
	<20100715190309.GI8623@think>
	<201007152132.13701.johannes.hirte@fem.tu-ilmenau.de>
	<20100715193551.GM8623@think>
	<4C4137D9.80003@xyzw.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Brian Rogers <brian@xyzw.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C4137D9.80003@xyzw.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 17 July 2010 06:55, Brian Rogers <brian@xyzw.org> wrote:
> On 07/15/2010 12:35 PM, Chris Mason wrote:
>>
>> On Thu, Jul 15, 2010 at 09:32:12PM +0200, Johannes Hirte wrote:
>>
>>>
>>> Am Donnerstag 15 Juli 2010, 21:03:09 schrieb Chris Mason:
>>>
>>>>
>>>> On Thu, Jul 15, 2010 at 08:30:17PM +0200, Johannes Hirte wrote:
>>>>
>>>>>
>>>>> Am Dienstag 13 Juli 2010, 14:23:58 schrieb Johannes Hirte:
>>>>>
>>>>>>
>>>>>> ino 1959333 off 898342912 csum 4271223884 private 4271223883
>>
>> Great. =C2=A0 The bad csums are all just one bit off, that can't be =
an
>> accident. =C2=A0When were they written (which kernel?). =C2=A0Did yo=
u boot a 32
>> bit kernel on there at any time?
>>
>
> I've seen this as well, with three files. In all instances, csum =3D=3D=
 *private
> + 1. Here are the unique lines from dmesg:
>
> [32700.980806] btrfs csum failed ino 320113 off 55889920 csum 2415136=
266
> private 2415136265
> [32735.751112] btrfs csum failed ino 1731630 off 24776704 csum 138528=
4137
> private 1385284136
> [32738.777624] btrfs csum failed ino 2495707 off 171790336 csum 13857=
81806
> private 1385781805
>
> All three files are from when I first transitioned to btrfs (or more
> accurately, they are clones of those files I made to hold onto a copy=
 of the
> corrupted version). Since the vast majority of my disk usage comes fr=
om the
> transition anyway, I can't be sure this is due to a problem only pres=
ent at
> that time. I believe I was running 2.6.34 when I copied my files over=
 to my
> new btrfs partition, but I'm going from memory here.
>
> My btrfs partition has never been touched by a 32-bit kernel.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

I am also getting this now:

btrfs csum failed ino 288 off 799268864 csum 4054934499 private 4054934=
498
btrfs csum failed ino 288 off 799268864 csum 4054934499 private 4054934=
498
btrfs csum failed ino 288 off 799268864 csum 4054934499 private 4054934=
498
btrfs csum failed ino 288 off 799268864 csum 4054934499 private 4054934=
498

A bit unrelated, but I was doing this while doing a rebalance across
my drives. RAID-0. I think it's a different issue though, but I'll go
ahead and post my dmesg output anyway:

------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:1980!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
CPU 1
Modules linked in: crc32c_intel ipv6 microcode cifs cpufreq_ondemand
hwmon_vid coretemp fuse ext2 mbcache raid1 md_mod usbhid hid
rndis_wlan cfg80211 rfkill rndis_host cdc_ether usbnet
snd_hda_codec_realtek snd_usb_audio snd_usbmidi_lib snd_hda_intel
snd_rawmidi snd_seq_dummy snd_seq_oss snd_hda_codec snd_seq_midi_event
snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nvidia(P) snd_hwdep
snd_pcm snd_timer snd uhci_hcd i2c_i801 acpi_cpufreq soundcore
freq_table ehci_hcd tpm_tis i2c_core tpm i7core_edac r8169
snd_page_alloc mperf iTCO_wdt mii iTCO_vendor_support wmi tpm_bios
usbcore edac_core processor fan thermal pcspkr button evdev rtc_cmos
rtc_core rtc_lib btrfs zlib_deflate crc32c libcrc32c sr_mod sg cdrom
sd_mod ata_piix pata_acpi ata_generic libata scsi_mod

Pid: 3480, comm: btrfs Tainted: P            2.6.35-ARCH #1 121-BL-E756=
/OEM
RIP: 0010:[<ffffffffa018158a>]  [<ffffffffa018158a>]
btrfs_balance+0x24a/0x260 [btrfs]
RSP: 0018:ffff8801d5675d48  EFLAGS: 00010282
RAX: 00000000fffffffb RBX: ffff8801d8b60ab0 RCX: ffffea00054814a8
RDX: 0000000000000004 RSI: ffffffff81530df0 RDI: 0000000000000282
RBP: ffff8801d5675dc8 R08: 0000000000000002 R09: 0000000000000002
R10: ffff88000001d240 R11: 0000000000000000 R12: ffff8801d9eec800
R13: 0000000000000000 R14: ffff8801d5675d78 R15: 00000659f9210000
=46S:  00007f7c3aef8740(0000) GS:ffff880001820000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007ff55a388000 CR3: 00000001d8d26000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs (pid: 3480, threadinfo ffff8801d5674000, task ffff8801d77=
ce120)
Stack:
 ffff8801d9eed000 0000000000000100 0000000000000100 000659f9210000e4
<0> 00007f7c3a84a200 0000000000000000 0000000000000100 00065a7920ffffe4
<0> ffff8801d5675e00 ffffffff810f8ea3 0000000000000000 ffff8801bebd6e40
Call Trace:
 [<ffffffff810f8ea3>] ? handle_mm_fault+0x1c3/0xab0
 [<ffffffffa0188520>] btrfs_ioctl+0x2c0/0x940 [btrfs]
 [<ffffffff811334ac>] vfs_ioctl+0x3c/0xd0
 [<ffffffff81133aac>] do_vfs_ioctl+0x7c/0x520
 [<ffffffff81133fd1>] sys_ioctl+0x81/0xa0
 [<ffffffff81009e82>] system_call_fastpath+0x16/0x1b
Code: 6d 62 fb ff 48 8b 45 80 48 8b b8 28 01 00 00 48 81 c7 80 1c 00
00 e8 a6 fd 1e e1 e9 fe fd ff ff 45 31 ed eb d7 0f 0b 85 c0 74 a7 <0f>
0b 0f 0b 0f 0b 0f 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00
RIP  [<ffffffffa018158a>] btrfs_balance+0x24a/0x260 [btrfs]
 RSP <ffff8801d5675d48>
---[ end trace 7501e28b9295d333 ]---

# btrfs-show
Label: none  uuid: 405f0d0b-ee4d-4426-9826-d2580d0c8d6c
	Total devices 2 FS bytes used 178.06GB
	devid    5 size 232.55GB used 91.63GB path /dev/sde3
	devid    7 size 189.82GB used 91.63GB path /dev/sda2

Btrfs Btrfs v0.19

Regards,
Sebastian J.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
