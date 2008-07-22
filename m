From: David Woodhouse <dwmw2@infradead.org>
Subject: kernel BUG at extent_map.c:275!
Date: Mon, 21 Jul 2008 23:36:41 -0400
Message-ID: <1216697801.18980.40.camel@shinybook.infradead.org>
References: <1216697528.18980.34.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216697528.18980.34.camel@shinybook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-07-21 at 23:32 -0400, David Woodhouse wrote:
> Untested but ObviouslyCorrect=E2=84=A2. Now that I can load the modul=
e, I hit a
> BUG() immediately -- but I don't think it's caused by this patch. qv.

Current progs-unstable and kernel-unstable. I created a 512MiB file and
ran mkfs.btrfs on it, on the current Fedora kernel:

shinybook /shiny/git/btrfs-progs-unstable $ dd if=3D/dev/zero of=3D/hom=
e/dwmw2/btrfs.test bs=3D$((1024*1024)) count=3D512
512+0 records in
512+0 records out
536870912 bytes (537 MB) copied, 37.6313 s, 14.3 MB/s
shinybook /shiny/git/btrfs-progs-unstable $ ./mkfs.btrfs /home/dwmw2/bt=
rfs.test fs created label (null) on /home/dwmw2/btrfs.test
	nodesize 4096 leafsize 4096 sectorsize 4096 size 512.00MB
shinybook /shiny/git/btrfs-progs-unstable $ sudo mount -tbtrfs -oloop /=
home/dwmw2/btrfs.test /mnt/spare
shinybook /shiny/git/btrfs-progs-unstable $ dmesg | tail -61=20
loop: module loaded
device fsid 1119bbc059164661-acafbb6be44e5929 devid 1 transid 12 /dev/l=
oop0
------------[ cut here ]------------
kernel BUG at /shiny/git/btrfs-kernel-unstable/extent_map.c:275!
Oops: Exception in kernel mode, sig: 5 [#1]
PowerMac
Modules linked in: loop btrfs libcrc32c b43legacy mac80211 rndis_wlan r=
ndis_host cdc_ether usbnet mii cdc_acm airport bridge bnep orinoco_cs o=
rinoco hermes hidp udf radeon drm rfkill_input hci_usb rfcomm l2cap blu=
etooth autofs4 sunrpc ipv6 dm_mirror dm_mod therm_adt746x arc4 ecb cryp=
to_blkcipher snd_aoa_i2sbus rfkill cfg80211 input_polldev snd_powermac =
snd_seq_dummy pmac_zilog snd_seq_oss snd_seq_midi_event snd_seq ide_cd_=
mod cdrom snd_seq_device sungem snd_pcm_oss snd_mixer_oss sungem_phy sn=
d_pcm firewire_ohci firewire_core crc_itu_t snd_timer snd_page_alloc sn=
d soundcore snd_aoa_soundbus ssb ext3 jbd mbcache uhci_hcd ohci_hcd ehc=
i_hcd [last unloaded: b43legacy]
NIP: f29b6b2c LR: f29cc9f8 CTR: c0090778
REGS: c671dbf0 TRAP: 0700   Tainted: P          (2.6.25.10-86.fc9.ppc)
MSR: 00029032 <EE,ME,IR,DR>  CR: 24044448  XER: 00000000
TASK =3D c65736e0[25115] 'mount' THREAD: c671c000
GPR00: 00000001 c671dca0 c65736e0 e7b9e108 00400000 00000000 00000000 0=
0000000=20
GPR08: 00000001 00000000 00004000 00004000 00000000 20029a70 00000000 b=
fcac591=20
GPR16: 20024880 20024870 bfcac56d e7b9e108 ec94b3c0 ec908400 e7b9f588 e=
d473200=20
GPR24: 00000000 e7b9e108 e1109ab8 00000000 00000000 00000001 00000000 0=
0000000=20
NIP [f29b6b2c] lookup_extent_mapping+0x48/0x350 [btrfs]
LR [f29cc9f8] read_one_chunk+0xa0/0x2f0 [btrfs]
Call Trace:
[c671dca0] [00001000] 0x1000 (unreliable)
[c671dcd0] [f29cc9f8] read_one_chunk+0xa0/0x2f0 [btrfs]
[c671dd20] [f29cd180] btrfs_read_sys_array+0x180/0x200 [btrfs]
[c671dd70] [f29a7b40] open_ctree+0x620/0x928 [btrfs]
[c671ddb0] [f2982334] btrfs_get_sb+0x224/0x3dc [btrfs]
[c671de20] [c00b035c] vfs_kern_mount+0xa0/0x138
[c671de50] [c00b0444] do_kern_mount+0x40/0xf4
[c671de70] [c00c7f38] do_new_mount+0x6c/0xb8
[c671de90] [c00c8f1c] do_mount+0x1c8/0x1f4
[c671df10] [c00c8fd8] sys_mount+0x90/0xd8
[c671df40] [c00139dc] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0x1fea3c54
    LR =3D 0x20004fa8
Instruction dump:
7f87f114 90010034 7c791b78 7f85e040 419d0014 7f85e000 40be0014 7f86e840=
=20
409d000c 3b80ffff 3ba0ffff 38000001 <0f000000> 80790004 2f830000 419e00=
6c=20
---[ end trace 83a08bddd47794a5 ]---
BUG: sleeping function called from invalid context at kernel/rwsem.c:21
in_atomic():0, irqs_disabled():1
Call Trace:
[c671da10] [c0008ddc] show_stack+0x4c/0x180 (unreliable)
[c671da60] [c00346d4] __might_sleep+0xc8/0xd8
[c671da70] [c02ecc48] down_read+0x24/0x5c
[c671da80] [c0069934] acct_collect+0x38/0x15c
[c671daa0] [c003c9a4] do_exit+0x1c4/0x5a4
[c671dad0] [c0011e88] kernel_bad_stack+0x0/0x4c
[c671daf0] [c0012040] _exception+0x58/0x154
[c671dbe0] [c001403c] ret_from_except_full+0x0/0x4c
--- Exception: 700 at lookup_extent_mapping+0x48/0x350 [btrfs]
    LR =3D read_one_chunk+0xa0/0x2f0 [btrfs]
[c671dca0] [00001000] 0x1000 (unreliable)
[c671dcd0] [f29cc9f8] read_one_chunk+0xa0/0x2f0 [btrfs]
[c671dd20] [f29cd180] btrfs_read_sys_array+0x180/0x200 [btrfs]
[c671dd70] [f29a7b40] open_ctree+0x620/0x928 [btrfs]
[c671ddb0] [f2982334] btrfs_get_sb+0x224/0x3dc [btrfs]
[c671de20] [c00b035c] vfs_kern_mount+0xa0/0x138
[c671de50] [c00b0444] do_kern_mount+0x40/0xf4
[c671de70] [c00c7f38] do_new_mount+0x6c/0xb8
[c671de90] [c00c8f1c] do_mount+0x1c8/0x1f4
[c671df10] [c00c8fd8] sys_mount+0x90/0xd8
[c671df40] [c00139dc] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0x1fea3c54
    LR =3D 0x20004fa8
shinybook /shiny/git/btrfs-kernel-unstable #=20


--=20
David Woodhouse                            Open Source Technology Centr=
e
David.Woodhouse@intel.com                              Intel Corporatio=
n


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
