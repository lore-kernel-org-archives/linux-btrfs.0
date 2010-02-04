From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Btrfs Kernel Oops on Full Volume
Date: Thu, 4 Feb 2010 17:06:01 -0600
Message-ID: <26a1f7961002041506v75ce7610s356dd42ffca1c9b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I received a kernel Oops while un-tarring a backed up root file system
to a btrfs partition.

I'm running the btrfs-unstable.git version as of commit 035fe03a Thu,
28 Jan 2010 21:20:39 (Btrfs: check total number of devices when
removing missing) back-ported to a 2.6.32 kernel.

I was attempting to restore a backed up root partition to a freshly
formatted btrfs volume.  This partition was formatted with the
defaults.  The target btrfs files system was a relatively small 9.4GB
partition on a 250 GB WDC WD2500JB-55R EIDE drive.

I had intended to mount the partition compressed, but accidentally
mounted the partition without compression and over-filled the
partition.  Still, I was expecting the operation to fail without an
Oops.

I could see that the tar command was continuing to attempt to extract
files even after the volume had filled up.  I've seen a few patches
regarding changes in the error return code, and was wondering if one
of these patches was relevant.

I am attaching the dmesg output for two Oops events.  The first one
occurred during the tar extract operation which filled the disk.  The
second Oops occurred when trying to unmount the btrfs volume after the
first Oops.

$ dmesg
d/0x10
[ 1214.296909]  [<c1267f55>] free_extent_buffer+0x20/0x22
[ 1214.296914]  [<c123b03d>] btrfs_release_path+0x34/0x45
[ 1214.296918]  [<c1240733>] btrfs_search_slot+0x525/0x591
[ 1214.296923]  [<c124d5a8>] btrfs_lookup_inode+0x28/0x84
[ 1214.296926]  [<c12556b5>] btrfs_update_inode+0x43/0xd4
[ 1214.296930]  [<c125808e>] btrfs_dirty_inode+0x44/0x54
[ 1214.296935]  [<c10a3872>] __mark_inode_dirty+0x23/0xf3
[ 1214.296939]  [<c109da97>] inode_setattr+0xf2/0xf9
[ 1214.296943]  [<c125a10b>] btrfs_setattr+0x22e/0x258
[ 1214.296947]  [<c109dbfb>] notify_change+0x15d/0x295
[ 1214.296951]  [<c10a6bcb>] utimes_common+0x107/0x121
[ 1214.296954]  [<c10a6c80>] do_utimes+0x9b/0xb5
[ 1214.296958]  [<c10a6d6a>] sys_utimensat+0x49/0x4c
[ 1214.296962]  [<c1002790>] sysenter_do_call+0x12/0x22
[ 1214.296964] ---[ end trace f3fb889159315018 ]---
[ 1214.296980] btrfs allocation failed flags 36, wanted 4096
[ 1214.296983] space_info has 0 free, is full
[ 1214.296987] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1214.296991] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1214.296994] entry offset 432013312, bytes 0, bitmap yes
[ 1214.296996] block group has cluster?: no
[ 1214.296998] 0 blocks of free space at or bigger than bytes is
[ 1214.297001] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1214.297004] block group has cluster?: no
[ 1214.297005] 0 blocks of free space at or bigger than bytes is
[ 1214.297009] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1214.297011] block group has cluster?: no
[ 1214.297013] 0 blocks of free space at or bigger than bytes is
[ 1214.297016] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1214.297020] entry offset 7984185344, bytes 0, bitmap yes
[ 1214.297022] block group has cluster?: no
[ 1214.297024] 0 blocks of free space at or bigger than bytes is
[ 1214.297025] ------------[ cut here ]------------
[ 1214.297029] WARNING: at fs/btrfs/extent_io.c:3210
free_extent_buffer+0x20/0x22()
[ 1214.297032] Hardware name:
[ 1214.297033] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_intel8x0 snd_ac97_codec usblp ac97_bus ppdev nvidia(P) snd_pcm
parport_pc snd_timer parport forcedeth pcspkr i2c_nforce2 snd
snd_page_alloc i2c_core nvidia_agp sl811_hcd ohci_hcd uhci_hcd
ehci_hcd
[ 1214.297050] Pid: 5080, comm: tar Tainted: P        W  2.6.32-sabayon-r1 #1
[ 1214.297052] Call Trace:
[ 1214.297056]  [<c101f057>] warn_slowpath_common+0x65/0x7c
[ 1214.297060]  [<c1267f55>] ? free_extent_buffer+0x20/0x22
[ 1214.297065]  [<c101f07b>] warn_slowpath_null+0xd/0x10
[ 1214.297068]  [<c1267f55>] free_extent_buffer+0x20/0x22
[ 1214.297073]  [<c124039c>] btrfs_search_slot+0x18e/0x591
[ 1214.297077]  [<c124d5a8>] btrfs_lookup_inode+0x28/0x84
[ 1214.297081]  [<c12556b5>] btrfs_update_inode+0x43/0xd4
[ 1214.297085]  [<c125808e>] btrfs_dirty_inode+0x44/0x54
[ 1214.297089]  [<c10a3872>] __mark_inode_dirty+0x23/0xf3
[ 1214.297093]  [<c109da97>] inode_setattr+0xf2/0xf9
[ 1214.297097]  [<c125a10b>] btrfs_setattr+0x22e/0x258
[ 1214.297101]  [<c109dbfb>] notify_change+0x15d/0x295
[ 1214.297105]  [<c108d344>] chown_common+0x5a/0x6c
[ 1214.297109]  [<c1094712>] ? path_put+0x20/0x23
[ 1214.297112]  [<c108d585>] sys_chown+0x40/0x59
[ 1214.297116]  [<c1002790>] sysenter_do_call+0x12/0x22
[ 1214.297119] ---[ end trace f3fb889159315019 ]---
[ 1214.297134] btrfs allocation failed flags 36, wanted 4096
[ 1214.297136] space_info has 0 free, is full
[ 1214.297140] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1214.297144] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1214.297147] entry offset 432013312, bytes 0, bitmap yes
[ 1214.297149] block group has cluster?: no
[ 1214.297151] 0 blocks of free space at or bigger than bytes is
[ 1214.297155] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1214.297157] block group has cluster?: no
[ 1214.297159] 0 blocks of free space at or bigger than bytes is
[ 1214.297162] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1214.297165] block group has cluster?: no
[ 1214.297167] 0 blocks of free space at or bigger than bytes is
[ 1214.297170] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1214.297173] entry offset 7984185344, bytes 0, bitmap yes
[ 1214.297175] block group has cluster?: no
[ 1214.297177] 0 blocks of free space at or bigger than bytes is
[ 1214.297197] btrfs allocation failed flags 36, wanted 4096
[ 1214.297199] space_info has 0 free, is full
[ 1214.297203] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1214.297207] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1214.297210] entry offset 432013312, bytes 0, bitmap yes
[ 1214.297212] block group has cluster?: no
[ 1214.297214] 0 blocks of free space at or bigger than bytes is
[ 1214.297217] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1214.297220] block group has cluster?: no
[ 1214.297222] 0 blocks of free space at or bigger than bytes is
[ 1214.297225] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1214.297227] block group has cluster?: no
[ 1214.297229] 0 blocks of free space at or bigger than bytes is
[ 1214.297233] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1214.297236] entry offset 7984185344, bytes 0, bitmap yes
[ 1214.297238] block group has cluster?: no
[ 1214.297239] 0 blocks of free space at or bigger than bytes is
[ 1214.297241] ------------[ cut here ]------------
[ 1214.297245] WARNING: at fs/btrfs/extent_io.c:3210
free_extent_buffer+0x20/0x22()
[ 1214.297248] Hardware name:
[ 1214.297249] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_intel8x0 snd_ac97_codec usblp ac97_bus ppdev nvidia(P) snd_pcm
parport_pc snd_timer parport forcedeth pcspkr i2c_nforce2 snd
snd_page_alloc i2c_core nvidia_agp sl811_hcd ohci_hcd uhci_hcd
ehci_hcd
[ 1214.297266] Pid: 5080, comm: tar Tainted: P        W  2.6.32-sabayon-r1 #1
[ 1214.297268] Call Trace:
[ 1214.297273]  [<c101f057>] warn_slowpath_common+0x65/0x7c
[ 1214.297276]  [<c1267f55>] ? free_extent_buffer+0x20/0x22
[ 1214.297281]  [<c101f07b>] warn_slowpath_null+0xd/0x10
[ 1214.297284]  [<c1267f55>] free_extent_buffer+0x20/0x22
[ 1214.297289]  [<c123b03d>] btrfs_release_path+0x34/0x45
[ 1214.297293]  [<c1240733>] btrfs_search_slot+0x525/0x591
[ 1214.297298]  [<c124d5a8>] btrfs_lookup_inode+0x28/0x84
[ 1214.297301]  [<c12556b5>] btrfs_update_inode+0x43/0xd4
[ 1214.297305]  [<c125808e>] btrfs_dirty_inode+0x44/0x54
[ 1214.297310]  [<c10a3872>] __mark_inode_dirty+0x23/0xf3
[ 1214.297314]  [<c109da97>] inode_setattr+0xf2/0xf9
[ 1214.297318]  [<c125a10b>] btrfs_setattr+0x22e/0x258
[ 1214.297322]  [<c109dbfb>] notify_change+0x15d/0x295
[ 1214.297326]  [<c10a6bcb>] utimes_common+0x107/0x121
[ 1214.297330]  [<c10a6c80>] do_utimes+0x9b/0xb5
[ 1214.297333]  [<c10a6d6a>] sys_utimensat+0x49/0x4c
[ 1214.297337]  [<c1002790>] sysenter_do_call+0x12/0x22
[ 1214.297339] ---[ end trace f3fb88915931501a ]---
[ 1214.297355] btrfs allocation failed flags 36, wanted 4096
[ 1214.297357] space_info has 0 free, is full
[ 1214.297361] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1214.297366] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1214.297369] entry offset 432013312, bytes 0, bitmap yes
[ 1214.297371] block group has cluster?: no
[ 1214.297372] 0 blocks of free space at or bigger than bytes is
[ 1214.297376] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1214.297378] block group has cluster?: no
[ 1214.297380] 0 blocks of free space at or bigger than bytes is
[ 1214.297383] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1214.297386] block group has cluster?: no
[ 1214.297387] 0 blocks of free space at or bigger than bytes is
[ 1214.297391] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1214.297394] entry offset 7984185344, bytes 0, bitmap yes
[ 1214.297396] block group has cluster?: no
[ 1214.297397] 0 blocks of free space at or bigger than bytes is
[ 1214.297399] ------------[ cut here ]------------
[ 1214.297403] WARNING: at fs/btrfs/extent_io.c:3210
free_extent_buffer+0x20/0x22()
[ 1214.297405] Hardware name:
[ 1214.297407] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_intel8x0 snd_ac97_codec usblp ac97_bus ppdev nvidia(P) snd_pcm
parport_pc snd_timer parport forcedeth pcspkr i2c_nforce2 snd
snd_page_alloc i2c_core nvidia_agp sl811_hcd ohci_hcd uhci_hcd
ehci_hcd
[ 1214.297424] Pid: 5080, comm: tar Tainted: P        W  2.6.32-sabayon-r1 #1
[ 1214.297426] Call Trace:
[ 1214.297430]  [<c101f057>] warn_slowpath_common+0x65/0x7c
[ 1214.297434]  [<c1267f55>] ? free_extent_buffer+0x20/0x22
[ 1214.297438]  [<c101f07b>] warn_slowpath_null+0xd/0x10
[ 1214.297442]  [<c1267f55>] free_extent_buffer+0x20/0x22
[ 1214.297446]  [<c124039c>] btrfs_search_slot+0x18e/0x591
[ 1214.297451]  [<c124d5a8>] btrfs_lookup_inode+0x28/0x84
[ 1214.297455]  [<c12556b5>] btrfs_update_inode+0x43/0xd4
[ 1214.297459]  [<c125808e>] btrfs_dirty_inode+0x44/0x54
[ 1214.297463]  [<c10a3872>] __mark_inode_dirty+0x23/0xf3
[ 1214.297467]  [<c109da97>] inode_setattr+0xf2/0xf9
[ 1214.297471]  [<c125a10b>] btrfs_setattr+0x22e/0x258
[ 1214.297475]  [<c109dbfb>] notify_change+0x15d/0x295
[ 1214.297479]  [<c108d344>] chown_common+0x5a/0x6c
[ 1214.297483]  [<c1094712>] ? path_put+0x20/0x23
[ 1214.297487]  [<c108d585>] sys_chown+0x40/0x59
[ 1214.297490]  [<c1002790>] sysenter_do_call+0x12/0x22
[ 1214.297493] ---[ end trace f3fb88915931501b ]---
[ 1214.297508] btrfs allocation failed flags 36, wanted 4096
[ 1214.297510] space_info has 0 free, is full
[ 1214.297514] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1214.297518] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1214.297521] entry offset 432013312, bytes 0, bitmap yes
[ 1214.297523] block group has cluster?: no
[ 1214.297525] 0 blocks of free space at or bigger than bytes is
[ 1214.297529] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1214.297531] block group has cluster?: no
[ 1214.297533] 0 blocks of free space at or bigger than bytes is
[ 1214.297536] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1214.297539] block group has cluster?: no
[ 1214.297540] 0 blocks of free space at or bigger than bytes is
[ 1214.297544] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1214.297547] entry offset 7984185344, bytes 0, bitmap yes
[ 1214.297549] block group has cluster?: no
[ 1214.297550] 0 blocks of free space at or bigger than bytes is
[ 1214.297667] btrfs allocation failed flags 36, wanted 4096
[ 1214.297669] space_info has 0 free, is full
[ 1214.297673] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1214.297678] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1214.297681] entry offset 432013312, bytes 0, bitmap yes
[ 1214.297683] block group has cluster?: no
[ 1214.297685] 0 blocks of free space at or bigger than bytes is
[ 1214.297688] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1214.297691] block group has cluster?: no
[ 1214.297692] 0 blocks of free space at or bigger than bytes is
[ 1214.297696] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1214.297698] block group has cluster?: no
[ 1214.297700] 0 blocks of free space at or bigger than bytes is
[ 1214.297703] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1214.297707] entry offset 7984185344, bytes 0, bitmap yes
[ 1214.297709] block group has cluster?: no
[ 1214.297710] 0 blocks of free space at or bigger than bytes is
[ 1214.297712] ------------[ cut here ]------------
[ 1214.297716] WARNING: at fs/btrfs/extent_io.c:3210
free_extent_buffer+0x20/0x22()
[ 1214.297719] Hardware name:
[ 1214.297720] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_intel8x0 snd_ac97_codec usblp ac97_bus ppdev nvidia(P) snd_pcm
parport_pc snd_timer parport forcedeth pcspkr i2c_nforce2 snd
snd_page_alloc i2c_core nvidia_agp sl811_hcd ohci_hcd uhci_hcd
ehci_hcd
[ 1214.297738] Pid: 5080, comm: tar Tainted: P        W  2.6.32-sabayon-r1 #1
[ 1214.297740] Call Trace:
[ 1214.297744]  [<c101f057>] warn_slowpath_common+0x65/0x7c
[ 1214.297748]  [<c1267f55>] ? free_extent_buffer+0x20/0x22
[ 1214.297752]  [<c101f07b>] warn_slowpath_null+0xd/0x10
[ 1214.297756]  [<c1267f55>] free_extent_buffer+0x20/0x22
[ 1214.297760]  [<c123b03d>] btrfs_release_path+0x34/0x45
[ 1214.297764]  [<c1240733>] btrfs_search_slot+0x525/0x591
[ 1214.297769]  [<c124d5a8>] btrfs_lookup_inode+0x28/0x84
[ 1214.297773]  [<c12556b5>] btrfs_update_inode+0x43/0xd4
[ 1214.297777]  [<c125808e>] btrfs_dirty_inode+0x44/0x54
[ 1214.297781]  [<c10a3872>] __mark_inode_dirty+0x23/0xf3
[ 1214.297785]  [<c109da97>] inode_setattr+0xf2/0xf9
[ 1214.297789]  [<c125a10b>] btrfs_setattr+0x22e/0x258
[ 1214.297793]  [<c109dbfb>] notify_change+0x15d/0x295
[ 1214.297797]  [<c10a6bcb>] utimes_common+0x107/0x121
[ 1214.297801]  [<c10a6c80>] do_utimes+0x9b/0xb5
[ 1214.297804]  [<c10a6d6a>] sys_utimensat+0x49/0x4c
[ 1214.297808]  [<c1002790>] sysenter_do_call+0x12/0x22
[ 1214.297810] ---[ end trace f3fb88915931501c ]---
[ 1214.297829] btrfs allocation failed flags 36, wanted 4096
[ 1214.297831] space_info has 0 free, is full
[ 1214.297835] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1214.297839] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1214.297842] entry offset 432013312, bytes 0, bitmap yes
[ 1214.297844] block group has cluster?: no
[ 1214.297846] 0 blocks of free space at or bigger than bytes is
[ 1214.297849] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1214.297852] block group has cluster?: no
[ 1214.297854] 0 blocks of free space at or bigger than bytes is
[ 1214.297857] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1214.297859] block group has cluster?: no
[ 1214.297861] 0 blocks of free space at or bigger than bytes is
[ 1214.297865] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1214.297868] entry offset 7984185344, bytes 0, bitmap yes
[ 1214.297870] block group has cluster?: no
[ 1214.297871] 0 blocks of free space at or bigger than bytes is
[ 1214.297873] ------------[ cut here ]------------
[ 1214.297877] WARNING: at fs/btrfs/extent_io.c:3210
free_extent_buffer+0x20/0x22()
[ 1214.297880] Hardware name:
[ 1214.297881] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_intel8x0 snd_ac97_codec usblp ac97_bus ppdev nvidia(P) snd_pcm
parport_pc snd_timer parport forcedeth pcspkr i2c_nforce2 snd
snd_page_alloc i2c_core nvidia_agp sl811_hcd ohci_hcd uhci_hcd
ehci_hcd
[ 1214.297898] Pid: 5080, comm: tar Tainted: P        W  2.6.32-sabayon-r1 #1
[ 1214.297900] Call Trace:
[ 1214.297904]  [<c101f057>] warn_slowpath_common+0x65/0x7c
[ 1214.297908]  [<c1267f55>] ? free_extent_buffer+0x20/0x22
[ 1214.297912]  [<c101f07b>] warn_slowpath_null+0xd/0x10
[ 1214.297916]  [<c1267f55>] free_extent_buffer+0x20/0x22
[ 1214.297920]  [<c124039c>] btrfs_search_slot+0x18e/0x591
[ 1214.297925]  [<c124d5a8>] btrfs_lookup_inode+0x28/0x84
[ 1214.297929]  [<c12556b5>] btrfs_update_inode+0x43/0xd4
[ 1214.297932]  [<c125808e>] btrfs_dirty_inode+0x44/0x54
[ 1214.297937]  [<c10a3872>] __mark_inode_dirty+0x23/0xf3
[ 1214.297941]  [<c109da97>] inode_setattr+0xf2/0xf9
[ 1214.297945]  [<c125a10b>] btrfs_setattr+0x22e/0x258
[ 1214.297949]  [<c109dbfb>] notify_change+0x15d/0x295
[ 1214.297953]  [<c108d344>] chown_common+0x5a/0x6c
[ 1214.297956]  [<c1094712>] ? path_put+0x20/0x23
[ 1214.297960]  [<c108d585>] sys_chown+0x40/0x59
[ 1214.297964]  [<c1002790>] sysenter_do_call+0x12/0x22
[ 1214.297967] ---[ end trace f3fb88915931501d ]---
[ 1214.297983] btrfs allocation failed flags 36, wanted 4096
[ 1214.297986] space_info has 0 free, is full
[ 1214.297990] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1214.297994] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1214.297997] entry offset 432013312, bytes 0, bitmap yes
[ 1214.297999] block group has cluster?: no
[ 1214.298001] 0 blocks of free space at or bigger than bytes is
[ 1214.298004] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1214.298007] block group has cluster?: no
[ 1214.298008] 0 blocks of free space at or bigger than bytes is
[ 1214.298012] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1214.298014] block group has cluster?: no
[ 1214.298016] 0 blocks of free space at or bigger than bytes is
[ 1214.298019] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1214.298022] entry offset 7984185344, bytes 0, bitmap yes
[ 1214.298024] block group has cluster?: no
[ 1214.298026] 0 blocks of free space at or bigger than bytes is
[ 1214.298047] btrfs allocation failed flags 36, wanted 4096
[ 1214.298049] space_info has 0 free, is full
[ 1214.298053] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1214.298058] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1214.298061] entry offset 432013312, bytes 0, bitmap yes
[ 1214.298062] block group has cluster?: no
[ 1214.298064] 0 blocks of free space at or bigger than bytes is
[ 1214.298068] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1214.298070] block group has cluster?: no
[ 1214.298072] 0 blocks of free space at or bigger than bytes is
[ 1214.298075] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1214.298078] block group has cluster?: no
[ 1214.298079] 0 blocks of free space at or bigger than bytes is
[ 1214.298083] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1214.298086] entry offset 7984185344, bytes 0, bitmap yes
[ 1214.298088] block group has cluster?: no
[ 1214.298090] 0 blocks of free space at or bigger than bytes is
[ 1214.298091] ------------[ cut here ]------------
[ 1214.298095] WARNING: at fs/btrfs/extent_io.c:3210
free_extent_buffer+0x20/0x22()
[ 1214.298098] Hardware name:
[ 1214.298099] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_intel8x0 snd_ac97_codec usblp ac97_bus ppdev nvidia(P) snd_pcm
parport_pc snd_timer parport forcedeth pcspkr i2c_nforce2 snd
snd_page_alloc i2c_core nvidia_agp sl811_hcd ohci_hcd uhci_hcd
ehci_hcd
[ 1214.298116] Pid: 5080, comm: tar Tainted: P        W  2.6.32-sabayon-r1 #1
[ 1214.298118] Call Trace:
[ 1214.298122]  [<c101f057>] warn_slowpath_common+0x65/0x7c
[ 1214.298126]  [<c1267f55>] ? free_extent_buffer+0x20/0x22
[ 1214.298131]  [<c101f07b>] warn_slowpath_null+0xd/0x10
[ 1214.298134]  [<c1267f55>] free_extent_buffer+0x20/0x22
[ 1214.298138]  [<c123b03d>] btrfs_release_path+0x34/0x45
[ 1214.298143]  [<c1240733>] btrfs_search_slot+0x525/0x591
[ 1214.298147]  [<c124d5a8>] btrfs_lookup_inode+0x28/0x84
[ 1214.298151]  [<c12556b5>] btrfs_update_inode+0x43/0xd4
[ 1214.298155]  [<c125808e>] btrfs_dirty_inode+0x44/0x54
[ 1214.298159]  [<c10a3872>] __mark_inode_dirty+0x23/0xf3
[ 1214.298164]  [<c109da97>] inode_setattr+0xf2/0xf9
[ 1214.298167]  [<c125a10b>] btrfs_setattr+0x22e/0x258
[ 1214.298172]  [<c109dbfb>] notify_change+0x15d/0x295
[ 1214.298175]  [<c10a6bcb>] utimes_common+0x107/0x121
[ 1214.298179]  [<c10a6c80>] do_utimes+0x9b/0xb5
[ 1214.298183]  [<c10a6d6a>] sys_utimensat+0x49/0x4c
[ 1214.298186]  [<c1002790>] sysenter_do_call+0x12/0x22
[ 1214.298189] ---[ end trace f3fb88915931501e ]---
[ 1214.298207] btrfs allocation failed flags 36, wanted 4096
[ 1214.298209] space_info has 0 free, is full
[ 1214.298213] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1214.298217] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1214.298220] entry offset 432013312, bytes 0, bitmap yes
[ 1214.298222] block group has cluster?: no
[ 1214.298224] 0 blocks of free space at or bigger than bytes is
[ 1214.298227] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1214.298230] block group has cluster?: no
[ 1214.298231] 0 blocks of free space at or bigger than bytes is
[ 1214.298235] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1214.298237] block group has cluster?: no
[ 1214.298239] 0 blocks of free space at or bigger than bytes is
[ 1214.298242] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1214.298245] entry offset 7984185344, bytes 0, bitmap yes
[ 1214.298247] block group has cluster?: no
[ 1214.298249] 0 blocks of free space at or bigger than bytes is
[ 1214.298251] ------------[ cut here ]------------
[ 1214.298255] WARNING: at fs/btrfs/extent_io.c:3210
free_extent_buffer+0x20/0x22()
[ 1214.298257] Hardware name:
[ 1214.298258] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_intel8x0 snd_ac97_codec usblp ac97_bus ppdev nvidia(P) snd_pcm
parport_pc snd_timer parport forcedeth pcspkr i2c_nforce2 snd
snd_page_alloc i2c_core nvidia_agp sl811_hcd ohci_hcd uhci_hcd
ehci_hcd
[ 1214.298275] Pid: 5080, comm: tar Tainted: P        W  2.6.32-sabayon-r1 #1
[ 1214.298277] Call Trace:
[ 1214.298281]  [<c101f057>] warn_slowpath_common+0x65/0x7c
[ 1214.298285]  [<c1267f55>] ? free_extent_buffer+0x20/0x22
[ 1214.298289]  [<c101f07b>] warn_slowpath_null+0xd/0x10
[ 1214.298293]  [<c1267f55>] free_extent_buffer+0x20/0x22
[ 1214.298297]  [<c124039c>] btrfs_search_slot+0x18e/0x591
[ 1214.298302]  [<c124d5a8>] btrfs_lookup_inode+0x28/0x84
[ 1214.298306]  [<c12556b5>] btrfs_update_inode+0x43/0xd4
[ 1214.298310]  [<c125808e>] btrfs_dirty_inode+0x44/0x54
[ 1214.298314]  [<c10a3872>] __mark_inode_dirty+0x23/0xf3
[ 1214.298318]  [<c109da97>] inode_setattr+0xf2/0xf9
[ 1214.298322]  [<c125a10b>] btrfs_setattr+0x22e/0x258
[ 1214.298326]  [<c109dbfb>] notify_change+0x15d/0x295
[ 1214.298330]  [<c108d344>] chown_common+0x5a/0x6c
[ 1214.298334]  [<c1094712>] ? path_put+0x20/0x23
[ 1214.298338]  [<c108d585>] sys_chown+0x40/0x59
[ 1214.298341]  [<c1002790>] sysenter_do_call+0x12/0x22
[ 1214.298344] ---[ end trace f3fb88915931501f ]---
[ 1214.298361] btrfs allocation failed flags 36, wanted 4096
[ 1214.298363] space_info has 0 free, is full
[ 1214.298367] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1214.298371] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1214.298374] entry offset 432013312, bytes 0, bitmap yes
[ 1214.298376] block group has cluster?: no
[ 1214.298378] 0 blocks of free space at or bigger than bytes is
[ 1214.298381] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1214.298384] block group has cluster?: no
[ 1214.298386] 0 blocks of free space at or bigger than bytes is
[ 1214.298389] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1214.298391] block group has cluster?: no
[ 1214.298393] 0 blocks of free space at or bigger than bytes is
[ 1214.298397] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1214.298400] entry offset 7984185344, bytes 0, bitmap yes
[ 1214.298402] block group has cluster?: no
[ 1214.298403] 0 blocks of free space at or bigger than bytes is
[ 1240.559957] btrfs allocation failed flags 36, wanted 4096
[ 1240.559962] space_info has 0 free, is full
[ 1240.559967] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1240.559972] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1240.559976] entry offset 432013312, bytes 0, bitmap yes
[ 1240.559978] block group has cluster?: no
[ 1240.559980] 0 blocks of free space at or bigger than bytes is
[ 1240.559984] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1240.559987] block group has cluster?: no
[ 1240.559989] 0 blocks of free space at or bigger than bytes is
[ 1240.559993] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1240.559996] block group has cluster?: no
[ 1240.559998] 0 blocks of free space at or bigger than bytes is
[ 1240.560002] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1240.560005] entry offset 7984185344, bytes 0, bitmap yes
[ 1240.560007] block group has cluster?: no
[ 1240.560009] 0 blocks of free space at or bigger than bytes is
[ 1240.560012] ------------[ cut here ]------------
[ 1240.560022] WARNING: at fs/btrfs/extent_io.c:3210
free_extent_buffer+0x20/0x22()
[ 1240.560025] Hardware name:
[ 1240.560027] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_intel8x0 snd_ac97_codec usblp ac97_bus ppdev nvidia(P) snd_pcm
parport_pc snd_timer parport forcedeth pcspkr i2c_nforce2 snd
snd_page_alloc i2c_core nvidia_agp sl811_hcd ohci_hcd uhci_hcd
ehci_hcd
[ 1240.560054] Pid: 5077, comm: btrfs-transacti Tainted: P        W
2.6.32-sabayon-r1 #1
[ 1240.560057] Call Trace:
[ 1240.560066]  [<c101f057>] warn_slowpath_common+0x65/0x7c
[ 1240.560070]  [<c1267f55>] ? free_extent_buffer+0x20/0x22
[ 1240.560075]  [<c101f07b>] warn_slowpath_null+0xd/0x10
[ 1240.560079]  [<c1267f55>] free_extent_buffer+0x20/0x22
[ 1240.560086]  [<c123b03d>] btrfs_release_path+0x34/0x45
[ 1240.560091]  [<c1240733>] btrfs_search_slot+0x525/0x591
[ 1240.560097]  [<c124615f>] lookup_inline_extent_backref+0xdd/0x3ec
[ 1240.560102]  [<c101983c>] ? enqueue_task_fair+0x55/0x59
[ 1240.560106]  [<c124715f>] __btrfs_free_extent+0xa9/0x61d
[ 1240.560112]  [<c102f8ef>] ? hrtimer_interrupt+0x11d/0x12d
[ 1240.560118]  [<c1004309>] ? timer_interrupt+0x15/0x1c
[ 1240.560124]  [<c105bb49>] ? handle_IRQ_event+0x24/0x97
[ 1240.560129]  [<c105cd4a>] ? handle_level_irq+0x9a/0x9e
[ 1240.560133]  [<c1247b73>] run_one_delayed_ref+0x4a0/0x4b5
[ 1240.560139]  [<c1249adc>] run_clustered_refs+0x1e6/0x24b
[ 1240.560143]  [<c1249bd7>] btrfs_run_delayed_refs+0x96/0x145
[ 1240.560150]  [<c1252610>] btrfs_commit_transaction+0x65/0x56d
[ 1240.560157]  [<c102d50b>] ? autoremove_wake_function+0x0/0x2f
[ 1240.560162]  [<c124eb03>] transaction_kthread+0x176/0x1e9
[ 1240.560169]  [<c1017380>] ? complete+0x1f/0x28
[ 1240.560174]  [<c124e98d>] ? transaction_kthread+0x0/0x1e9
[ 1240.560178]  [<c102d27c>] kthread+0x5e/0x63
[ 1240.560182]  [<c102d21e>] ? kthread+0x0/0x63
[ 1240.560186]  [<c1002f87>] kernel_thread_helper+0x7/0x10
[ 1240.560190] ---[ end trace f3fb889159315020 ]---
[ 1240.560199] BUG: unable to handle kernel NULL pointer dereference at 0000001c
[ 1240.560202] IP: [<c124a475>] btrfs_print_leaf+0xe/0x6e3
[ 1240.560207] *pde = 00000000
[ 1240.560210] Oops: 0000 [#1]
[ 1240.560213] last sysfs file:
/sys/devices/pci0000:00/0000:00:09.0/host0/target0:0:1/0:0:1:0/block/sdb/uevent
[ 1240.560217] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_intel8x0 snd_ac97_codec usblp ac97_bus ppdev nvidia(P) snd_pcm
parport_pc snd_timer parport forcedeth pcspkr i2c_nforce2 snd
snd_page_alloc i2c_core nvidia_agp sl811_hcd ohci_hcd uhci_hcd
ehci_hcd
[ 1240.560236]
[ 1240.560239] Pid: 5077, comm: btrfs-transacti Tainted: P        W
(2.6.32-sabayon-r1 #1)
[ 1240.560243] EIP: 0060:[<c124a475>] EFLAGS: 00010286 CPU: 0
[ 1240.560247] EIP is at btrfs_print_leaf+0xe/0x6e3
[ 1240.560250] EAX: e9b97400 EBX: e9b97400 ECX: ffffffff EDX: 00000000
[ 1240.560253] ESI: 00000000 EDI: f64b9000 EBP: e9be1db8 ESP: e9be1d6c
[ 1240.560256]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[ 1240.560260] Process btrfs-transacti (pid: 5077, ti=e9be0000
task=f5ac9900 task.ti=e9be0000)
[ 1240.560263] Stack:
[ 1240.560264]  00001000 00000000 00000002 00000000 f64b9000 e9be1e28
c124715f e9be1e18
[ 1240.560270] <0> e33af000 00000001 00000000 00000000 00000000
00000000 00000002 00000000
[ 1240.560276] <0> 00000002 00000000 f64b9000 e9be1e28 c1247334
e9be1dec c102f8ef f63ba000
[ 1240.560282] Call Trace:
[ 1240.560286]  [<c124715f>] ? __btrfs_free_extent+0xa9/0x61d
[ 1240.560291]  [<c1247334>] ? __btrfs_free_extent+0x27e/0x61d
[ 1240.560295]  [<c102f8ef>] ? hrtimer_interrupt+0x11d/0x12d
[ 1240.560300]  [<c1004309>] ? timer_interrupt+0x15/0x1c
[ 1240.560304]  [<c105bb49>] ? handle_IRQ_event+0x24/0x97
[ 1240.560309]  [<c105cd4a>] ? handle_level_irq+0x9a/0x9e
[ 1240.560313]  [<c1247b73>] ? run_one_delayed_ref+0x4a0/0x4b5
[ 1240.560318]  [<c1249adc>] ? run_clustered_refs+0x1e6/0x24b
[ 1240.560323]  [<c1249bd7>] ? btrfs_run_delayed_refs+0x96/0x145
[ 1240.560328]  [<c1252610>] ? btrfs_commit_transaction+0x65/0x56d
[ 1240.560333]  [<c102d50b>] ? autoremove_wake_function+0x0/0x2f
[ 1240.560338]  [<c124eb03>] ? transaction_kthread+0x176/0x1e9
[ 1240.560343]  [<c1017380>] ? complete+0x1f/0x28
[ 1240.560347]  [<c124e98d>] ? transaction_kthread+0x0/0x1e9
[ 1240.560351]  [<c102d27c>] ? kthread+0x5e/0x63
[ 1240.560355]  [<c102d21e>] ? kthread+0x0/0x63
[ 1240.560360]  [<c1002f87>] ? kernel_thread_helper+0x7/0x10
[ 1240.560362] Code: ff 75 ec ff 75 e8 52 50 68 6b b3 69 c1 e8 e2 1f
27 00 83 c4 20 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 53 89 c3 83 ec
40 89 55 dc <8b> 42 1c ba 03 00 00 00 e8 86 c1 dc ff 8b 50 60 89 55 b8
ba 03
[ 1240.560389] EIP: [<c124a475>] btrfs_print_leaf+0xe/0x6e3 SS:ESP 0068:e9be1d6c
[ 1240.560395] CR2: 000000000000001c
[ 1240.560399] ---[ end trace f3fb889159315021 ]---

Here is the second Oops that occured while trying to unmount the btrfs
volume after the initial Oops.

[ 1462.413673] btrfs allocation failed flags 36, wanted 4096
[ 1462.413678] space_info has 0 free, is full
[ 1462.413683] space_info total=915079168, pinned=8388608, delalloc=0,
may_use=0, used=906170368, root=2875392, super=65536, reserved=454656
[ 1462.413688] block group 29360128 has 512425984 bytes, 508727296
used 3276800 pinned 356352 reserved
[ 1462.413692] entry offset 432013312, bytes 0, bitmap yes
[ 1462.413694] block group has cluster?: no
[ 1462.413696] 0 blocks of free space at or bigger than bytes is
[ 1462.413700] block group 2591490048 has 134217728 bytes, 132014080
used 2203648 pinned 0 reserved
[ 1462.413703] block group has cluster?: no
[ 1462.413705] 0 blocks of free space at or bigger than bytes is
[ 1462.413709] block group 5800263680 has 134217728 bytes, 132362240
used 1855488 pinned 0 reserved
[ 1462.413711] block group has cluster?: no
[ 1462.413713] 0 blocks of free space at or bigger than bytes is
[ 1462.413717] block group 7984185344 has 134217728 bytes, 133066752
used 1052672 pinned 98304 reserved
[ 1462.413721] entry offset 7984185344, bytes 0, bitmap yes
[ 1462.413723] block group has cluster?: no
[ 1462.413725] 0 blocks of free space at or bigger than bytes is
[ 1462.413728] ------------[ cut here ]------------
[ 1462.413738] WARNING: at fs/btrfs/extent_io.c:3210
free_extent_buffer+0x20/0x22()
[ 1462.413741] Hardware name:
[ 1462.413743] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_intel8x0 snd_ac97_codec usblp ac97_bus ppdev nvidia(P) snd_pcm
parport_pc snd_timer parport forcedeth pcspkr i2c_nforce2 snd
snd_page_alloc i2c_core nvidia_agp sl811_hcd ohci_hcd uhci_hcd
ehci_hcd
[ 1462.413770] Pid: 5204, comm: umount Tainted: P      D W  2.6.32-sabayon-r1 #1
[ 1462.413773] Call Trace:
[ 1462.413782]  [<c101f057>] warn_slowpath_common+0x65/0x7c
[ 1462.413786]  [<c1267f55>] ? free_extent_buffer+0x20/0x22
[ 1462.413791]  [<c101f07b>] warn_slowpath_null+0xd/0x10
[ 1462.413795]  [<c1267f55>] free_extent_buffer+0x20/0x22
[ 1462.413802]  [<c123b03d>] btrfs_release_path+0x34/0x45
[ 1462.413808]  [<c1240733>] btrfs_search_slot+0x525/0x591
[ 1462.413813]  [<c1240c69>] btrfs_insert_empty_items+0x3d/0x7c
[ 1462.413819]  [<c12478ae>] run_one_delayed_ref+0x1db/0x4b5
[ 1462.413824]  [<c102f3f0>] ? hrtimer_forward+0x10f/0x123
[ 1462.413831]  [<c10062dc>] ? pit_next_event+0x1d/0x21
[ 1462.413836]  [<c1249adc>] run_clustered_refs+0x1e6/0x24b
[ 1462.413840]  [<c1249bd7>] btrfs_run_delayed_refs+0x96/0x145
[ 1462.413847]  [<c1252610>] btrfs_commit_transaction+0x65/0x56d
[ 1462.413854]  [<c102d50b>] ? autoremove_wake_function+0x0/0x2f
[ 1462.413858]  [<c123a951>] btrfs_sync_fs+0x50/0x53
[ 1462.413865]  [<c10c074b>] sync_quota_sb+0x3f/0xce
[ 1462.413870]  [<c10a6962>] __sync_filesystem+0x3c/0x64
[ 1462.413874]  [<c10a6abe>] sync_filesystem+0x3c/0x42
[ 1462.413880]  [<c10900b2>] generic_shutdown_super+0x1c/0xac
[ 1462.413885]  [<c10be560>] ? vfs_quota_off+0x0/0x12
[ 1462.413889]  [<c109017f>] kill_anon_super+0xc/0x2f
[ 1462.413893]  [<c10906c7>] deactivate_super+0x47/0x5c
[ 1462.413898]  [<c109f7cc>] mntput_no_expire+0x52/0x73
[ 1462.413902]  [<c109fc14>] sys_umount+0x258/0x278
[ 1462.413907]  [<c109fc41>] sys_oldumount+0xd/0xf
[ 1462.413911]  [<c1002790>] sysenter_do_call+0x12/0x22
[ 1462.413914] ---[ end trace f3fb889159315022 ]---
[ 1462.413949] ------------[ cut here ]------------
[ 1462.413952] kernel BUG at fs/btrfs/extent-tree.c:4752!
[ 1462.413955] invalid opcode: 0000 [#2]
[ 1462.413958] last sysfs file:
/sys/devices/pci0000:00/0000:00:09.0/host0/target0:0:1/0:0:1:0/block/sdb/uevent
[ 1462.413961] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_intel8x0 snd_ac97_codec usblp ac97_bus ppdev nvidia(P) snd_pcm
parport_pc snd_timer parport forcedeth pcspkr i2c_nforce2 snd
snd_page_alloc i2c_core nvidia_agp sl811_hcd ohci_hcd uhci_hcd
ehci_hcd
[ 1462.413980]
[ 1462.413983] Pid: 5204, comm: umount Tainted: P      D W
(2.6.32-sabayon-r1 #1)
[ 1462.413986] EIP: 0060:[<c12478b5>] EFLAGS: 00010286 CPU: 0
[ 1462.413990] EIP is at run_one_delayed_ref+0x1e2/0x4b5
[ 1462.413993] EAX: ffffffe4 EBX: f64b9070 ECX: ffffffff EDX: eae5ad00
[ 1462.413997] ESI: c82b60c0 EDI: f63ba000 EBP: f60abe14 ESP: f60abdbc
[ 1462.414000]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 1462.414004] Process umount (pid: 5204, ti=f60aa000 task=f5acd780
task.ti=f60aa000)
[ 1462.414006] Stack:
[ 1462.414008]  f60abdf8 c102f3f0 00000000 00000000 00000000 f60abddc
c10062dc 00000002
[ 1462.414013] <0> 00000000 eac6a000 00000000 00000000 e9b97c00
00738ae8 0001c030 a8000000
[ 1462.414019] <0> 00001000 00000000 00000033 c71b9dc0 d981d6c0
c82b60c0 f60abe64 c1249adc
[ 1462.414025] Call Trace:
[ 1462.414030]  [<c102f3f0>] ? hrtimer_forward+0x10f/0x123
[ 1462.414035]  [<c10062dc>] ? pit_next_event+0x1d/0x21
[ 1462.414039]  [<c1249adc>] ? run_clustered_refs+0x1e6/0x24b
[ 1462.414044]  [<c1249bd7>] ? btrfs_run_delayed_refs+0x96/0x145
[ 1462.414049]  [<c1252610>] ? btrfs_commit_transaction+0x65/0x56d
[ 1462.414054]  [<c102d50b>] ? autoremove_wake_function+0x0/0x2f
[ 1462.414059]  [<c123a951>] ? btrfs_sync_fs+0x50/0x53
[ 1462.414063]  [<c10c074b>] ? sync_quota_sb+0x3f/0xce
[ 1462.414067]  [<c10a6962>] ? __sync_filesystem+0x3c/0x64
[ 1462.414071]  [<c10a6abe>] ? sync_filesystem+0x3c/0x42
[ 1462.414076]  [<c10900b2>] ? generic_shutdown_super+0x1c/0xac
[ 1462.414080]  [<c10be560>] ? vfs_quota_off+0x0/0x12
[ 1462.414084]  [<c109017f>] ? kill_anon_super+0xc/0x2f
[ 1462.414088]  [<c10906c7>] ? deactivate_super+0x47/0x5c
[ 1462.414093]  [<c109f7cc>] ? mntput_no_expire+0x52/0x73
[ 1462.414097]  [<c109fc14>] ? sys_umount+0x258/0x278
[ 1462.414101]  [<c109fc41>] ? sys_oldumount+0xd/0xf
[ 1462.414105]  [<c1002790>] ? sysenter_do_call+0x12/0x22
[ 1462.414108] Code: eb fe 80 48 68 08 89 d9 8b 57 20 8d 45 f0 6a 01
50 8d 45 df 50 8b 45 cc c7 45 f0 33 00 00 00 e8 7e 93 ff ff 83 c4 0c
85 c0 74 04 <0f> 0b eb fe 8b 3b 6b 53 20 19 89 f8 83 c2 65 e8 58 7b 01
00 89
[ 1462.414135] EIP: [<c12478b5>] run_one_delayed_ref+0x1e2/0x4b5
SS:ESP 0068:f60abdbc
[ 1462.414142] ---[ end trace f3fb889159315023 ]---
