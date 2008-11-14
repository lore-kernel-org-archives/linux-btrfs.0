From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: Kernel oops when running bonnie++ on btrfs
Date: Fri, 14 Nov 2008 11:31:38 -0500
Message-ID: <20081114163138.GA1265@tux64-03>
References: <20081113184907.GA16224@tux64-02> <20081113192005.GA17006@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081113192005.GA17006@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

I updated today and ran the test again, it seems like its still
there but on a different line. Here is an updated log

Nov 14 16:23:42 Intrepid-btrfsc kernel: [ 1295.947414] space info full 1

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.123999] allocation failed
flags 1, wanted 4096

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.124047] space_info has
2789093376 free, is full

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134507] block group
12582912 has 8388608 bytes, 8388608 used 0 pinned 0 reserved

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134552] 0 blocks of free
space at or bigger than bytes is

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134579] block group
424542208 has 790429696 bytes, 790429696 used 0 pinned 0 reserved

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134602] 1 blocks of free
space at or bigger than bytes is

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134604] block group
1214971904 has 790429696 bytes, 0 used 0 pinned 0 reserved

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134607] 0 blocks of free
space at or bigger than bytes is

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134610] block group
2005401600 has 790429696 bytes, 0 used 0 pinned 0 reserved

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134612] 0 blocks of free
space at or bigger than bytes is

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134615] block group
2795831296 has 790429696 bytes, 0 used 0 pinned 0 reserved

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134617] 0 blocks of free
space at or bigger than bytes is

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134619] block group
3586260992 has 790429696 bytes, 372625408 used 0 pinned 0 reserved

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134622] 0 blocks of free
space at or bigger than bytes is

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134663] block group
4376690688 has 790429696 bytes, 790429696 used 0 pinned 0 reserved

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134666] 0 blocks of free
space at or bigger than bytes is

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134668] block group
5167120384 has 790429696 bytes, 790429696 used 0 pinned 0 reserved

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134671] 0 blocks of free
space at or bigger than bytes is

Nov 14 16:23:45 Intrepid-btrfsc kernel: [ 1299.134674] block group
5957550080 has 790429696 bytes, 783273984 used 0 pinned 7155712 reserved

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.134676] 0 blocks of free
space at or bigger than bytes is

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.134679] block group
6747979776 has 752943104 bytes, 751333376 used 0 pinned 1609728 reserved

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.134682] 0 blocks of free
space at or bigger than bytes is

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.135276] ------------[ cut
here ]------------

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.135759] kernel BUG at
/home/ltrager/btrfs/btrfs-unstable-standalone/extent-tree.c:3077!

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.135997] invalid opcode:
0000 [#1] SMP 

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203] Modules linked
in: af_packet bridge stp bnep rfcomm sco l2cap bluetooth ppdev
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand
freq_table cpufreq_conservative wmi video output sbs sbshc pci_slot
battery iptable_filter ip_tables x_tables lp evdev psmouse serio_raw
pcspkr parport_pc parport snd_ens1371 gameport snd_ac97_codec ac97_bus
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd
soundcore snd_page_alloc container i2c_piix4 ac button intel_agp
i2c_core agpgart shpchp pci_hotplug ext2 mbcache sr_mod cdrom sd_mod
crc_t10dif pata_acpi ata_piix sg uhci_hcd ata_generic ehci_hcd pcnet32
mii mptspi mptscsih usbcore mptbase scsi_transport_spi libata scsi_mod
dock thermal processor fan fbcon tileblit font bitblit softcursor fuse
btrfs libcrc32c zlib_deflate

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203] 

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203] Pid: 5305, comm:
btrfs-delalloc- Not tainted (2.6.27-7-generic #1)

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203] EIP:
0060:[<e08cd712>] EFLAGS: 00010257 CPU: 0

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203] EIP is at
__btrfs_reserve_extent+0x3c2/0x480 [btrfs]

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203] EAX: df7a2c44
EBX: d81936c0 ECX: ffffffff EDX: 00000001

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203] ESI: d81936ec
EDI: df7a2c38 EBP: d82dbde8 ESP: d82dbd74

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]  DS: 007b ES:
007b FS: 00d8 GS: 0000 SS: 0068

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203] Process
btrfs-delalloc- (pid: 5305, ti=d82da000 task=d81e1920 task.ti=d82da000)

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203] Stack: e090ab84
92360000 00000001 2ce10000 00000000 2cc87000 00000000 00000000 

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]        00000000
00189000 00000000 00000000 00000000 00000000 00000000 00000001 

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]        00000000
00000000 00000000 00000000 00001000 00000000 dee44190 df6aa000 

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203] Call Trace:

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]  [<e08cda57>] ?
btrfs_reserve_extent+0x77/0xb0 [btrfs]

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]  [<e08dae37>] ?
cow_file_range+0x227/0x4d0 [btrfs]

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]  [<e08db538>] ?
submit_compressed_extents+0x458/0x4d0 [btrfs]

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]  [<c01284cb>] ?
finish_task_switch+0x2b/0xe0

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]  [<e08db63b>] ?
async_cow_submit+0x8b/0xa0 [btrfs]

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]  [<e08fcd04>] ?
run_ordered_completions+0x74/0xd0 [btrfs]

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]  [<e08fcdf8>] ?
worker_loop+0x98/0x180 [btrfs]

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]  [<e08fcd60>] ?
worker_loop+0x0/0x180 [btrfs]

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]  [<c0147141>] ?
kthread+0x41/0x80

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]  [<c0147100>] ?
kthread+0x0/0x80

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]  [<c0105297>] ?
kernel_thread_helper+0x7/0x10

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203]
=======================

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203] Code: ec aa df 8d
4b 44 89 c8 89 4d f0 e8 39 02 ab df 8b 7b 38 8b 07 0f 18 00 90 83 c3 38
39 fb 89 5d ec 75 33 8b 45 f0 e8 fe e2 87 df <0f> 0b eb fe 66 90 8b 90
90 18 00 00 8b 88 78 18 00 00 8b b0 8c 

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.136203] EIP: [<e08cd712>]
__btrfs_reserve_extent+0x3c2/0x480 [btrfs] SS:ESP 0068:d82dbd74

Nov 14 16:23:46 Intrepid-btrfsc kernel: [ 1299.159252] ---[ end trace
ae4786bfdd8753ad ]---?
On Thu, Nov 13, 2008 at 02:20:05PM -0500, Josef Bacik wrote:
> On Thu, Nov 13, 2008 at 01:49:07PM -0500, Lee Trager wrote:
> > I wanted to see how btrfs compares to other filesystems so I have been
> > running bonnie++ on it. While the results are good(much faster then
> > ext2) every once in awhile I get a kernel oops. I am testing on xubuntu
> > 8.10 with the 2.6.27-7-686 kernel using the latest git sources. Most of the
> > time the oops happens within 20min of running bonnie++ but sometimes it
> > takes a few hours. This happens with and without compression.
> > 
> > To reproduce this bug you can run
> > 
> > while true; do bonnie++ -s 5120 -n 4:524288:0:512; done
> >
> 
> Thanks, still tracking down random places where we ENOSPC too soon.  Have you
> updated today?  There was a fix that went in earlier today that may help you.  I
> wll run with your command and see if I can replicate here and fix it.
> 
> Josef
>  
