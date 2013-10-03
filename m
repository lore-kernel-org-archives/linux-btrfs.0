Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:56053 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab3JCD7E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Oct 2013 23:59:04 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so803724eae.10
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Oct 2013 20:59:02 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Oct 2013 20:59:01 -0700
Message-ID: <CAEm3SNA-S9Mz=WAK5kFXxU_w3=+gcSqOC8XYC3KFcpNuGxtsLQ@mail.gmail.com>
Subject: btrfs apparently causes hard lockup
From: Justin Husted <valentinej@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been having some trouble with one of my computers recently that
I'm currently blaming on btrfs.

At first, I thought the computer had a hardware fault, since it tended
to just mysteriously hard-lockup a few times per day.  Usually, it
would hard-lockup with the GUI, and I was unable to get anything out
of it.  Occasionally, sysrq would work, but usually not.  I was able
to get it to lock up on the console once, and it printed a few "cpu #
soft lockup" messages before it froze completely (no sysrq).

So, I assumed this was a hardware problem and upgraded the BIOS,
swapped the PSU, and ran memcheck86 for 24 hours.  Seemed perfectly
stable under memtest.  I also tried a rescue CD and synthesized some
heavy CPU/IO load -- also perfectly stable.

Then, I realized that usually it seemed to crash more while I tried to
run a backup from my btrfs volume.  So, I ran btrfs check on it, and
it found some errors.  In fact, I ran btrfs check on it hundreds of
times as a stability test (with btrfs never having been mounted).
Also stable!

I also get many warnings in the logs.  The output from btrfs check
seems to be mysterious hex bit masks and not human-readable, but when
I looked at the source it seemed like the warnings and the check
output both referred to backrefs.

Any idea what I should do here?  I could apply some patches if anyone
would like to debug this.  The hard lockup seems particularly
difficult to pin down, but so far btrfs seems like the culprit.

Misc boring information:

This was running Ubuntu 12.10 with an ubuntu kernel 3.5.0-41, but
during debugging I upgraded it to linux 3.11.1 and built my own
btrfs-progs.  Upgrading to 3.11.1 did not help stability or warnings.
The filesystem was originally created with 3.2 I believe.

This filesystem is running on two partitions.  Each partition is an
LVM volume residing in a dm-crypt encrypted container.  The underlying
disks are a WDC WD6400AACS-00G8B1 and a WDC WD10EADS-00L5B1.

btrfs check output:

checking extents
checking free space cache
checking fs roots
root 256 inode 479769 errors 1000
root 256 inode 479770 errors 1000
root 256 inode 479771 errors 1000
[... many more...]
root 256 inode 497535 errors 1000
root 1566 inode 265006 errors 400
root 3527 inode 479769 errors 1000
[...]
root 3573 inode 265006 errors 400
Checking filesystem on /dev/mapper/caper--sda-btrfs
UUID: eef3677d-7db2-4bd5-84ac-d2b81dad48bf
found 289666276901 bytes used err is 1
total csum bytes: 1176876020
total tree bytes: 2294751232
total fs tree bytes: 800370688
total extent tree bytes: 140996608
btree space waste bytes: 294587633
file data blocks allocated: 2453271158784
 referenced 1912600858624
Btrfs v0.20-rc1-358-g194aa4a


Note: The file data blocks allocated and referenced figures seem wildly high?

The warning:

Sep 30 21:12:40 caper kernel: [  250.921566] ------------[ cut here
]------------
Sep 30 21:12:40 caper kernel: [  250.921641] WARNING: CPU: 2 PID: 3622
at /home/apw/COD/linux/fs/btrfs/inode.c:2206
record_one_backref+0x3a9/0x420 [btrfs]()
Sep 30 21:12:40 caper kernel: [  250.921646] Modules linked in:
nls_utf8 isofs nls_iso8859_1 zram(C) rfcomm bnep bluetooth parport_pc
ppdev nfsd nfs_acl auth_rpcgss nfs fscache lockd binfmt_misc sunrpc
snd_hda_codec_hdmi wacom uvcvideo joydev videobuf2_core videodev
hid_gaff snd_usb_audio videobuf2_vmalloc ff_memless
snd_hda_codec_realtek videobuf2_memops snd_usbmidi_lib sp5100_tco
snd_seq_midi snd_hda_intel dm_multipath snd_hda_codec snd_rawmidi
scsi_dh snd_hwdep snd_seq_midi_event snd_pcm snd_seq snd_seq_device
snd_timer serio_raw edac_core edac_mce_amd k10temp snd it87 hwmon_vid
i2c_piix4 wmi soundcore mac_hid ohci_pci snd_page_alloc lp parport xfs
btrfs raid6_pq zlib_deflate xor libcrc32c hid_generic usbhid hid
dm_crypt usb_storage firewire_ohci firewire_core crc_itu_t pata_acpi
pata_atiixp ahci libahci r8169 mii
Sep 30 21:12:40 caper kernel: [  250.921754] CPU: 2 PID: 3622 Comm:
btrfs-endio-wri Tainted: G         C   3.11.1-031101-generic
#201309141102
Sep 30 21:12:40 caper kernel: [  250.921760] Hardware name: Gigabyte
Technology Co., Ltd. GA-MA790GP-UD4H/GA-MA790GP-UD4H, BIOS F7c
07/08/2010
Sep 30 21:12:40 caper kernel: [  250.921765]  000000000000089e
ffff880134ccfa58 ffffffff81723114 0000000000000007
Sep 30 21:12:40 caper kernel: [  250.921773]  0000000000000000
ffff880134ccfa98 ffffffff8106534c ffff880134ccfa78
Sep 30 21:12:40 caper kernel: [  250.921780]  ffff880117c1ef30
0000000000000001 ffff880074323400 0000160000000000
Sep 30 21:12:40 caper kernel: [  250.921787] Call Trace:
Sep 30 21:12:40 caper kernel: [  250.921800]  [<ffffffff81723114>]
dump_stack+0x46/0x58
Sep 30 21:12:40 caper kernel: [  250.921810]  [<ffffffff8106534c>]
warn_slowpath_common+0x8c/0xc0
Sep 30 21:12:40 caper kernel: [  250.921817]  [<ffffffff8106539a>]
warn_slowpath_null+0x1a/0x20
Sep 30 21:12:40 caper kernel: [  250.921860]  [<ffffffffa01127c9>]
record_one_backref+0x3a9/0x420 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.921903]  [<ffffffffa0112420>] ?
btrfs_submit_direct+0x190/0x190 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.921948]  [<ffffffffa01653f2>]
iterate_leaf_refs+0x52/0xc0 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.921989]  [<ffffffffa0112420>] ?
btrfs_submit_direct+0x190/0x190 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.922032]  [<ffffffffa0167e58>]
iterate_extent_inodes+0x198/0x270 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.922075]  [<ffffffffa0167fc2>]
iterate_inodes_from_logical+0x92/0xb0 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.922116]  [<ffffffffa0112420>] ?
btrfs_submit_direct+0x190/0x190 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.922157]  [<ffffffffa010e88c>]
record_extent_backrefs+0x7c/0xf0 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.922199]  [<ffffffffa01191e4>]
relink_file_extents+0x44/0x180 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.922242]  [<ffffffffa0119455>]
btrfs_finish_ordered_io+0x135/0x4d0 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.922284]  [<ffffffffa0119805>]
finish_ordered_fn+0x15/0x20 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.922327]  [<ffffffffa013a1d0>]
worker_loop+0xa0/0x320 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.922370]  [<ffffffffa013a130>] ?
check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
Sep 30 21:12:40 caper kernel: [  250.922380]  [<ffffffff81088fe0>]
kthread+0xc0/0xd0
Sep 30 21:12:40 caper kernel: [  250.922388]  [<ffffffff81088f20>] ?
flush_kthread_worker+0xb0/0xb0
Sep 30 21:12:40 caper kernel: [  250.922396]  [<ffffffff81737b6c>]
ret_from_fork+0x7c/0xb0
Sep 30 21:12:40 caper kernel: [  250.922403]  [<ffffffff81088f20>] ?
flush_kthread_worker+0xb0/0xb0
Sep 30 21:12:40 caper kernel: [  250.922408] ---[ end trace
88b6f2dc5c83f578 ]---
Sep 30 21:12:45 caper kernel: [  255.896377] ------------[ cut here
]------------

Thanks for reading this far!
