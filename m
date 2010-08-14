From: Brian Rogers <brian@xyzw.org>
Subject: Re: csum errors
Date: Sat, 14 Aug 2010 00:05:37 -0700
Message-ID: <4C664041.80808@xyzw.org>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>	<201007152030.18431.johannes.hirte@fem.tu-ilmenau.de>	<20100715190309.GI8623@think>	<201007152132.13701.johannes.hirte@fem.tu-ilmenau.de>	<20100715193551.GM8623@think>	<4C4137D9.80003@xyzw.org> <AANLkTinNXRGC8whX5zkbjii+qDdihON8CW4j-=jVEofs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Sebastian 'gonX' Jensen <gonx@overclocked.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinNXRGC8whX5zkbjii+qDdihON8CW4j-=jVEofs@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  On 08/10/2010 02:06 PM, Sebastian 'gonX' Jensen wrote:
> On 17 July 2010 06:55, Brian Rogers<brian@xyzw.org>  wrote:
>> On 07/15/2010 12:35 PM, Chris Mason wrote:
>>> On Thu, Jul 15, 2010 at 09:32:12PM +0200, Johannes Hirte wrote:
>>>
>>>> Am Donnerstag 15 Juli 2010, 21:03:09 schrieb Chris Mason:
>>>>
>>>>> On Thu, Jul 15, 2010 at 08:30:17PM +0200, Johannes Hirte wrote:
>>>>>
>>>>>> Am Dienstag 13 Juli 2010, 14:23:58 schrieb Johannes Hirte:
>>>>>>
>>>>>>> ino 1959333 off 898342912 csum 4271223884 private 4271223883
>>> Great.   The bad csums are all just one bit off, that can't be an
>>> accident.  When were they written (which kernel?).  Did you boot a 32
>>> bit kernel on there at any time?
>>>
>> I've seen this as well, with three files. In all instances, csum == *private
>> + 1. Here are the unique lines from dmesg:
>>
>> [32700.980806] btrfs csum failed ino 320113 off 55889920 csum 2415136266
>> private 2415136265
>> [32735.751112] btrfs csum failed ino 1731630 off 24776704 csum 1385284137
>> private 1385284136
>> [32738.777624] btrfs csum failed ino 2495707 off 171790336 csum 1385781806
>> private 1385781805
>>
>> All three files are from when I first transitioned to btrfs (or more
>> accurately, they are clones of those files I made to hold onto a copy of the
>> corrupted version). Since the vast majority of my disk usage comes from the
>> transition anyway, I can't be sure this is due to a problem only present at
>> that time. I believe I was running 2.6.34 when I copied my files over to my
>> new btrfs partition, but I'm going from memory here.
>>
>> My btrfs partition has never been touched by a 32-bit kernel.
> I am also getting this now:
>
> btrfs csum failed ino 288 off 799268864 csum 4054934499 private 4054934498
> btrfs csum failed ino 288 off 799268864 csum 4054934499 private 4054934498
> btrfs csum failed ino 288 off 799268864 csum 4054934499 private 4054934498
> btrfs csum failed ino 288 off 799268864 csum 4054934499 private 4054934498
>
> A bit unrelated, but I was doing this while doing a rebalance across
> my drives. RAID-0.

I get this as well on single-drive btrfs. I cleaned out all the files 
that produce a csum error when read normally, but I still get the error 
during a rebalance. I can read all the files on any subvolume with the 
matching inode number just fine. If I delete the mentioned files or 
replace them with new copies and do a rebalance again, I'll get the same 
error again on a different inode number.

I did two rebalance runs in a row (with a reboot between each) without 
deleting the problem inode to see if it would fail in the same place 
each time. The inode number varied, but the block group, offset, and 
checksums were the same:

Run 1:
[63978.519791] btrfs: relocating block group 511130468352 flags 1
[63980.401249] btrfs csum failed ino 418 off 9949184 csum 1385781806 
private 1385781805
[63980.499024] btrfs csum failed ino 418 off 9949184 csum 1385781806 
private 1385781805
[63980.535384] btrfs csum failed ino 418 off 9949184 csum 1385781806 
private 1385781805
[63980.570196] btrfs csum failed ino 418 off 9949184 csum 1385781806 
private 1385781805

Run 2:
[51317.967011] btrfs: relocating block group 511130468352 flags 1
[51321.298448] btrfs csum failed ino 415 off 9949184 csum 1385781806 
private 1385781805
[51321.807357] btrfs csum failed ino 415 off 9949184 csum 1385781806 
private 1385781805
[51322.707362] btrfs csum failed ino 415 off 9949184 csum 1385781806 
private 1385781805
[51323.318478] btrfs csum failed ino 415 off 9949184 csum 1385781806 
private 1385781805

These files should have different contents (unfortunately I already 
deleted them by now), so I don't know what they're doing at the same 
offset, sharing the same checksum... Could these files both be inlined 
in the same chunk of metadata, or does this mean something else?

Also, I wonder if the miscalculated checksum is something that happens 
non-deterministically, or if it's just that the inodes were processed in 
a different order the second time...

It certainly seems significant that the inode number is always low. The 
balance always runs for quite a while before hitting a problem, and 
since it appears to start from the end of the disk, it seems that only 
the earliest and lowest-numbered inodes at the beginning of the disk can 
cause this problem.

Complete crash from dmesg:

[51317.967011] btrfs: relocating block group 511130468352 flags 1
[51321.298448] btrfs csum failed ino 415 off 9949184 csum 1385781806 
private 1385781805
[51321.807357] btrfs csum failed ino 415 off 9949184 csum 1385781806 
private 1385781805
[51322.707362] btrfs csum failed ino 415 off 9949184 csum 1385781806 
private 1385781805
[51323.318478] btrfs csum failed ino 415 off 9949184 csum 1385781806 
private 1385781805
[51327.954315] ------------[ cut here ]------------
[51327.954322] kernel BUG at 
/build/buildd/linux-2.6.35/fs/btrfs/volumes.c:1980!
[51327.954326] invalid opcode: 0000 [#1] SMP
[51327.954330] last sysfs file: 
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/PNP0C0A:00/power_supply/BAT1/charge_full
[51327.954334] CPU 0
[51327.954336] Modules linked in: ip6table_filter ip6_tables hidp hid 
binfmt_misc rfcomm parport_pc ppdev sco bnep l2cap ipt_MASQUERADE 
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state 
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables 
bridge stp microcode joydev i915 snd_hda_codec_si3054 
snd_hda_codec_realtek drm_kms_helper drm i2c_algo_bit snd_hda_intel 
snd_hda_codec arc4 snd_hwdep uinput snd_pcm iwl3945 video snd_seq_midi 
snd_rawmidi snd_seq_midi_event iwlcore snd_seq snd_timer snd_seq_device 
lp snd mac80211 soundcore output psmouse btusb intel_agp serio_raw 
cfg80211 bluetooth snd_page_alloc parport btrfs zlib_deflate 
firewire_ohci firewire_core ahci crc_itu_t sdhci_pci sdhci led_class tg3 
crc32c libahci libcrc32c
[51327.954396]
[51327.954400] Pid: 15426, comm: btrfs Not tainted 2.6.35-15-generic 
#21-Ubuntu IFT01         /N/A
[51327.954404] RIP: 0010:[<ffffffffa00cc25f>]  [<ffffffffa00cc25f>] 
btrfs_balance+0x24f/0x260 [btrfs]
[51327.954425] RSP: 0018:ffff88012eb95dc8  EFLAGS: 00010282
[51327.954428] RAX: 00000000fffffffb RBX: ffff880037c78480 RCX: 
0200000000004081
[51327.954431] RDX: 0000000000000003 RSI: ffffea0003ea1640 RDI: 
0000000000000282
[51327.954434] RBP: ffff88012eb95e48 R08: 0000000000000000 R09: 
0000000000000000
[51327.954437] R10: 0000000000000069 R11: 0000000000000001 R12: 
ffff880138da6800
[51327.954439] R13: 0000000000000000 R14: 0000007701c00000 R15: 
ffff88012eb95df8
[51327.954443] FS:  00007fbea8710740(0000) GS:ffff880001e00000(0000) 
knlGS:0000000000000000
[51327.954446] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[51327.954449] CR2: 00007f99c0088cc1 CR3: 0000000114bee000 CR4: 
00000000000006f0
[51327.954452] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[51327.954455] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[51327.954458] Process btrfs (pid: 15426, threadinfo ffff88012eb94000, 
task ffff88003fb6adc0)
[51327.954460] Stack:
[51327.954462]  ffff880138da7000 0000000000000100 0000000000000100 
00007701c00000e4
[51327.954467] <0> ffff880100001c00 ffff88013fc31400 0000000000000100 
0000e15b3fffffe4
[51327.954473] <0> ffff88012eb95e00 ffffffff811280f5 ffff8801315f5038 
ffff880115d35600
[51327.954478] Call Trace:
[51327.954486]  [<ffffffff811280f5>] ? page_add_new_anon_rmap+0x95/0xa0
[51327.954500]  [<ffffffffa00d44b0>] btrfs_ioctl+0x2c0/0x4c0 [btrfs]
[51327.954505]  [<ffffffff811615ad>] vfs_ioctl+0x3d/0xd0
[51327.954509]  [<ffffffff81161e81>] do_vfs_ioctl+0x81/0x340
[51327.954514]  [<ffffffff8158c8ae>] ? do_page_fault+0x15e/0x350
[51327.954517]  [<ffffffff811621c1>] sys_ioctl+0x81/0xa0
[51327.954523]  [<ffffffff8100a0f2>] system_call_fastpath+0x16/0x1b
[51327.954525] Code: fb ff 48 8b 45 80 48 8b b8 28 01 00 00 48 81 c7 20 
1c 00 00 e8 e3 b0 4b e1 e9 00 fe ff ff 45 31 ed eb d7 0f 0b eb fe 85 c0 
74 a5 <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 90 55 48 89 e5
[51327.954567] RIP  [<ffffffffa00cc25f>] btrfs_balance+0x24f/0x260 [btrfs]
[51327.954580]  RSP <ffff88012eb95dc8>
[51327.954583] ---[ end trace 0bf81e832fde7349 ]---

