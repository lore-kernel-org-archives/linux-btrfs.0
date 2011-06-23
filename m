From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: btrfs: failed to load free space cache for block group on
 =?iso-8859-1?q?rsync=B4ing_to_space=5Fcache_BTRFS_with?= subvolume
Date: Thu, 23 Jun 2011 19:37:12 +0200
Message-ID: <201106231937.12848.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Short summary: I suspect that rsync=B4ing files to a newly created BTRF=
S=20
partition with a subvolume *and* enabled space_cache triggers the error=
=20
mentioned in the subject line of this mail. I reported this also as:

Bug 38112 -  btrfs: failed to load free space cache for block group on=20
rsync=B4ing to space_cache BTRFS with subvolume

https://bugzilla.kernel.org/show_bug.cgi?id=3D38112

I will add a reference to my post here to the bug report, so feel free =
to=20
use whatever suits you best to follow up.


This happened on a ThinkPad T520 with 3.0.0-rc3-amd64 Debian/GNU Linux=20
kernel. The issue happened on a 2.5 inch external eSATA/USB harddisk wh=
ich=20
I changed to BTRFS. On the repoot after the rsync process was stalled t=
he=20
unrelated non space cache using root filesystem did not mount anymore w=
ith=20
3.0.0-rc3-amd64 and 2.6.39-2-amd64 kernel. But thankfully it did mount=20
with a 2.6.38 grml 2011 amd64 kernel and now work again.


Thus I did

merkaba:~> mkfs.btrfs -L daten /dev/sdc2

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label daten on /dev/sdc2
        nodesize 4096 leafsize 4096 sectorsize 4096 size 447.13GB
Btrfs Btrfs v0.19

merkaba:~> mount -o space_cache,compress=3Dlzo /dev/sdc2 /mnt/amazon-da=
ten=20
merkaba:~> dmesg | tail -3
[137440.930038] device label daten devid 1 transid 7 /dev/sdc2
[137440.930507] btrfs: enabling disk space caching
[137440.930518] btrfs: use lzo compression


Then I unmounted, added a fstab entry without space_cache option since =
I=20
read that once BTRFS created a space_cache it would use it anyway it is=
=20
mounted with clear_cache to clear the cache again.

I created a sub volume for movies, cause I wanted to be able to not=20
snapshot the movie files:

merkaba:~> btrfs subvolume create /mnt/amazon-daten/Filme
Create subvolume '/mnt/amazon-daten/Filme'

I then did my rsync from the backup which BTW was a BTRFS with space_ca=
che=20
as well - created today:

merkaba:~> rsync -a -H --acls --xattrs --sparse /mnt/steigerwald-daten/=
=20
/mnt/amazon-daten

A short while after starting the rsync I got:

137927.147255] btrfs: failed to load free space cache for block group=20
147131990016
[138110.390962] ------------[ cut here ]------------
[138110.392736] kernel BUG at=20
/media/data/mattems/src/linux-2.6-3.0.0~rc3/debian/build/source_amd64_n=
one/fs/btrfs/free-
space-cache.c:1186!
[138110.394536] invalid opcode: 0000 [#1] SMP=20
[138110.396322] CPU 0=20
[138110.396331] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat=
=20
msdos fat jfs xfs reiserfs ext3 jbd ext2 ums_cypress usb_storage uas tu=
n=20
cpufreq_conservative cpufreq_stats parport_pc ppdev cpufreq_powersave=20
cpufreq_userspace lp parport bnep acpi_cpufreq mperf rfcomm bluetooth=20
uinput fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 mbca=
che=20
jbd2 crc16 acpiphp pci_hotplug loop firewire_sbp2 snd_hda_codec_hdmi=20
snd_hda_codec_conexant joydev arc4 snd_hda_intel snd_hda_codec snd_hwde=
p=20
ac snd_pcm snd_seq snd_timer snd_seq_device thinkpad_acpi tpm_tis snd=20
nvram psmouse tpm battery evdev serio_raw i2c_i801 pcspkr tpm_bios=20
power_supply i915 wmi drm_kms_helper soundcore snd_page_alloc rfkill dr=
m=20
i2c_algo_bit i2c_core video button processor dm_mod raid10 raid456=20
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx=
=20
raid1 raid0 multipath linear md_mod btrfs zlib_deflate crc32c libcrc32c=
 sg=20
sr_mod sd_mod cdrom crc_t10dif usbhid sdhci_pci firewire_ohci sdhci hid=
=20
mmc_core ahci sata_sil24 libahci libata firewire_core crc_itu_t scsi_mo=
d=20
ehci_hcd thermal thermal_sys usbcore e1000e [last unloaded: cfg80211]
[138110.407957]=20
[138110.409950] Pid: 26438, comm: btrfs-transacti Tainted: G        W  =
 =20
3.0.0-rc3-amd64 #1 LENOVO 42433WG/42433WG
[138110.411984] RIP: 0010:[<ffffffffa01b845b>]  [<ffffffffa01b845b>]=20
recalculate_thresholds+0x21/0x6c [btrfs]
[138110.414051] RSP: 0018:ffff880182b2fcd8  EFLAGS: 00010202
[138110.416107] RAX: 0000000000000001 RBX: ffff880212442440 RCX:=20
0000000008000000
[138110.418179] RDX: 0000000007ffffff RSI: 0000000000000002 RDI:=20
ffff880212442440
[138110.420244] RBP: 0000000000000000 R08: 0000000008000000 R09:=20
ffff88019a155720
[138110.422297] R10: ffff880105f6e3b8 R11: ffff880100000001 R12:=20
ffff88020f220ba0
[138110.424356] R13: 0000002241fdd000 R14: ffff880105f6e3b8 R15:=20
0000000000001000
[138110.426410] FS:  0000000000000000(0000) GS:ffff88021e200000(0000)=20
knlGS:0000000000000000
[138110.428467] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[138110.430522] CR2: 00007f0529281034 CR3: 0000000146086000 CR4:=20
00000000000406f0
[138110.432576] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[138110.434620] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
[138110.436656] Process btrfs-transacti (pid: 26438, threadinfo=20
ffff880182b2e000, task ffff880212054140)
[138110.438704] Stack:
[138110.440740]  ffffffffa01baa5e ffff880105f6e390 ffff8802092f7c80=20
0000000005f6c0b8
[138110.442788]  ffff8802092f7d58 0000000000000001 ffff8802092f7c80=20
0000000000001000
[138110.444814]  0000002241fdd000 0000002241fddfff 0000002241fde000=20
ffff880105f6c000
[138110.446836] Call Trace:
[138110.448914]  [<ffffffffa01baa5e>] ? __btrfs_add_free_space+0x1fc/0x=
2f4=20
[btrfs]
[138110.450923]  [<ffffffffa01781e7>] ? unpin_extent_range+0x95/0x131 [=
btrfs]
[138110.452917]  [<ffffffffa0179c57>] ? btrfs_finish_extent_commit+0xab=
/0x19f=20
[btrfs]
[138110.454902]  [<ffffffffa018afb6>] ? btrfs_commit_transaction+0x566/=
0x67e=20
[btrfs]
[138110.456874]  [<ffffffff8105ff19>] ? wake_up_bit+0x20/0x20
[138110.458838]  [<ffffffffa018b507>] ? start_transaction+0x1f5/0x242 [=
btrfs]
[138110.460786]  [<ffffffffa0185fd3>] ? transaction_kthread+0x173/0x22d=
=20
[btrfs]
[138110.462733]  [<ffffffffa0185e60>] ? find_and_setup_root+0xcb/0xcb [=
btrfs]
[138110.464658]  [<ffffffffa0185e60>] ? find_and_setup_root+0xcb/0xcb [=
btrfs]
[138110.466541]  [<ffffffff8105fadd>] ? kthread+0x7a/0x82
[138110.468411]  [<ffffffff8133dd24>] ? kernel_thread_helper+0x4/0x10
[138110.470274]  [<ffffffff8105fa63>] ? kthread_worker_fn+0x147/0x147
[138110.472111]  [<ffffffff8133dd20>] ? gs_change+0x13/0x13
[138110.473928] Code: 30 48 c7 47 20 00 00 00 00 c3 48 8b 47 38 31 d2 8=
b=20
77 20 4c 8b 40 70 48 8b 48 09 49 c1 e0 0f 49 8d 44 08 ff 49 f7 f0 39 c6=
 7e=20
04 <0f> 0b eb fe 48 81 f9 ff ff ff 3f b8 00 80 00 00 76 0b 48 89 c8=20
[138110.475922] RIP  [<ffffffffa01b845b>] recalculate_thresholds+0x21/0=
x6c=20
[btrfs]
[138110.477847]  RSP <ffff880182b2fcd8>
[138110.549460] ---[ end trace 131766a12388cd20 ]---
[138138.490877] BUG: soft lockup - CPU#2 stuck for 22s! [btrfs-delayed-
m:26480]
[138138.490885] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat=
=20
msdos fat jfs xfs reiserfs ext3 jbd ext2 ums_cypress usb_storage uas tu=
n=20
cpufreq_conservative cpufreq_stats parport_pc ppdev cpufreq_powersave=20
cpufreq_userspace lp parport bnep acpi_cpufreq mperf rfcomm bluetooth=20
uinput fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 mbca=
che=20
jbd2 crc16 acpiphp pci_hotplug loop firewire_sbp2 snd_hda_codec_hdmi=20
snd_hda_codec_conexant joydev arc4 snd_hda_intel snd_hda_codec snd_hwde=
p=20
ac snd_pcm snd_seq snd_timer snd_seq_device thinkpad_acpi tpm_tis snd=20
nvram psmouse tpm battery evdev serio_raw i2c_i801 pcspkr tpm_bios=20
power_supply i915 wmi drm_kms_helper soundcore snd_page_alloc rfkill dr=
m=20
i2c_algo_bit i2c_core video button processor dm_mod raid10 raid456=20
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx=
=20
raid1 raid0 multipath linear md_mod btrfs zlib_deflate crc32c libcrc32c=
 sg=20
sr_mod sd_mod cdrom crc_t10dif usbhid sdhci_pci firewire_ohci sdhci hid=
=20
mmc_core ahci sata_sil24 libahci libata firewire_core crc_itu_t scsi_mo=
d=20
ehci_hcd thermal thermal_sys usbcore e1000e [last unloaded: cfg80211]
[138138.491076] CPU 2=20
[138138.491079] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat=
=20
msdos fat jfs xfs reiserfs ext3 jbd ext2 ums_cypress usb_storage uas tu=
n=20
cpufreq_conservative cpufreq_stats parport_pc ppdev cpufreq_powersave=20
cpufreq_userspace lp parport bnep acpi_cpufreq mperf rfcomm bluetooth=20
uinput fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 mbca=
che=20
jbd2 crc16 acpiphp pci_hotplug loop firewire_sbp2 snd_hda_codec_hdmi=20
snd_hda_codec_conexant joydev arc4 snd_hda_intel snd_hda_codec snd_hwde=
p=20
ac snd_pcm snd_seq snd_timer snd_seq_device thinkpad_acpi tpm_tis snd=20
nvram psmouse tpm battery evdev serio_raw i2c_i801 pcspkr tpm_bios=20
power_supply i915 wmi drm_kms_helper soundcore snd_page_alloc rfkill dr=
m=20
i2c_algo_bit i2c_core video button processor dm_mod raid10 raid456=20
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx=
=20
raid1 raid0 multipath linear md_mod btrfs zlib_deflate crc32c libcrc32c=
 sg=20
sr_mod sd_mod cdrom crc_t10dif usbhid sdhci_pci firewire_ohci sdhci hid=
=20
mmc_core ahci sata_sil24 libahci libata firewire_core crc_itu_t scsi_mo=
d=20
ehci_hcd thermal thermal_sys usbcore e1000e [last unloaded: cfg80211]
[138138.491241]=20
[138138.491248] Pid: 26480, comm: btrfs-delayed-m Tainted: G      D W  =
 =20
3.0.0-rc3-amd64 #1 LENOVO 42433WG/42433WG
[138138.491258] RIP: 0010:[<ffffffff81337607>]  [<ffffffff81337607>]=20
_raw_spin_lock+0x13/0x1b
[138138.491276] RSP: 0018:ffff8801011ff958  EFLAGS: 00000297
[138138.491282] RAX: 000000000000143d RBX: ffff88019576cc28 RCX:=20
0000000000001000
[138138.491288] RDX: 000000000000143c RSI: ffff8802092f7c80 RDI:=20
ffff880212442440
[138138.491294] RBP: ffff880105f6e390 R08: 0000002241c8c000 R09: ffffff=
ffffffffff
[138138.491299] R10: dead000000200200 R11: 0000000000000000 R12:=20
ffffffff8133d5ce
[138138.491305] R13: 0000000000000000 R14: 0000000000000af7 R15:=20
ffffffffa01a4f88
[138138.491312] FS:  0000000000000000(0000) GS:ffff88021e280000(0000)=20
knlGS:0000000000000000
[138138.491318] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[138138.491324] CR2: 00007f9be3bed000 CR3: 0000000001603000 CR4:=20
00000000000406e0
[138138.491329] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[138138.491335] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
[138138.491342] Process btrfs-delayed-m (pid: 26480, threadinfo=20
ffff8801011fe000, task ffff8801c2b3d120)
[138138.491347] Stack:
[138138.491351]  ffffffffa017fbcc ffff880189996b40 ffff880100000021=20
0000000000000000
[138138.491361]  0000000000001000 0000000003856f00 ffffffffa01a4300=20
ffff880105f6e394
[138138.491371]  0000000000000000 0000002241c8c000 00010000a01a4300=20
ffff880138b41800
[138138.491382] Call Trace:
[138138.491419]  [<ffffffffa017fbcc>] ? find_free_extent+0x542/0xa4b [b=
trfs]
[138138.491456]  [<ffffffffa01a4300>] ? map_private_extent_buffer+0xa3/=
0xc4=20
[btrfs]
[138138.491489]  [<ffffffffa0180191>] ? btrfs_reserve_extent+0xbc/0x1cd=
=20
[btrfs]
[138138.491518]  [<ffffffffa0178ffd>] ? reserve_metadata_bytes+0x54/0x1=
a6=20
[btrfs]
[138138.491548]  [<ffffffffa0180403>] ? btrfs_alloc_free_block+0x161/0x=
292=20
[btrfs]
[138138.491575]  [<ffffffffa0173091>] ? __btrfs_cow_block+0x109/0x34b [=
btrfs]
[138138.491586]  [<ffffffff810415ab>] ? check_preempt_wakeup+0x11f/0x19=
f
[138138.491612]  [<ffffffffa0173862>] ? btrfs_cow_block+0xf7/0x143 [btr=
fs]
[138138.491639]  [<ffffffffa0175135>] ? btrfs_search_slot+0x140/0x4c6 [=
btrfs]
[138138.491647]  [<ffffffff81008596>] ? __switch_to+0xc5/0x288
[138138.491654]  [<ffffffff8103b918>] ? pick_next_task_fair+0xf9/0x10b
[138138.491664]  [<ffffffff81336c31>] ? mutex_lock+0xd/0x2c
[138138.491695]  [<ffffffffa01839ad>] ? btrfs_lookup_inode+0x25/0x84 [b=
trfs]
[138138.491704]  [<ffffffff81336c31>] ? mutex_lock+0xd/0x2c
[138138.491733]  [<ffffffffa01c59ae>] ? btrfs_update_delayed_inode+0x6b=
/0x126=20
[btrfs]
[138138.491767]  [<ffffffffa018b507>] ? start_transaction+0x1f5/0x242 [=
btrfs]
[138138.491795]  [<ffffffffa01c640f>] ?=20
btrfs_async_run_delayed_node_done+0x8a/0x138 [btrfs]
[138138.491828]  [<ffffffffa01ae872>] ? worker_loop+0x186/0x4a1 [btrfs]
[138138.491837]  [<ffffffff813361ea>] ? schedule+0x5ed/0x61a
[138138.491866]  [<ffffffffa01ae6ec>] ? btrfs_queue_worker+0x24a/0x24a =
[btrfs]
[138138.491894]  [<ffffffffa01ae6ec>] ? btrfs_queue_worker+0x24a/0x24a =
[btrfs]
[138138.491904]  [<ffffffff8105fadd>] ? kthread+0x7a/0x82
[138138.491914]  [<ffffffff8133dd24>] ? kernel_thread_helper+0x4/0x10
[138138.491923]  [<ffffffff8105fa63>] ? kthread_worker_fn+0x147/0x147
[138138.491932]  [<ffffffff8133dd20>] ? gs_change+0x13/0x13
[138138.491936] Code: 00 01 00 75 04 f0 0f b1 17 0f 94 c2 0f b6 c2 85 c=
0=20
0f 95 c0 0f b6 c0 c3 b8 00 00 01 00 f0 0f c1 07 0f b7 d0 c1 e8 10 39 c2=
 74=20
07 <f3> 90 0f b7 17 eb f5 c3 9c 58 66 66 90 66 90 48 89 c2 fa 66 66=20
[138138.492000] Call Trace:
[138138.492029]  [<ffffffffa017fbcc>] ? find_free_extent+0x542/0xa4b [b=
trfs]
[138138.492062]  [<ffffffffa01a4300>] ? map_private_extent_buffer+0xa3/=
0xc4=20
[btrfs]
[138138.492092]  [<ffffffffa0180191>] ? btrfs_reserve_extent+0xbc/0x1cd=
=20
[btrfs]
[138138.492121]  [<ffffffffa0178ffd>] ? reserve_metadata_bytes+0x54/0x1=
a6=20
[btrfs]
[138138.492150]  [<ffffffffa0180403>] ? btrfs_alloc_free_block+0x161/0x=
292=20
[btrfs]
[138138.492176]  [<ffffffffa0173091>] ? __btrfs_cow_block+0x109/0x34b [=
btrfs]
[138138.492185]  [<ffffffff810415ab>] ? check_preempt_wakeup+0x11f/0x19=
f
[138138.492211]  [<ffffffffa0173862>] ? btrfs_cow_block+0xf7/0x143 [btr=
fs]
[138138.492238]  [<ffffffffa0175135>] ? btrfs_search_slot+0x140/0x4c6 [=
btrfs]
[138138.492245]  [<ffffffff81008596>] ? __switch_to+0xc5/0x288
[138138.492251]  [<ffffffff8103b918>] ? pick_next_task_fair+0xf9/0x10b
[138138.492260]  [<ffffffff81336c31>] ? mutex_lock+0xd/0x2c
[138138.492289]  [<ffffffffa01839ad>] ? btrfs_lookup_inode+0x25/0x84 [b=
trfs]
[138138.492298]  [<ffffffff81336c31>] ? mutex_lock+0xd/0x2c
[138138.492326]  [<ffffffffa01c59ae>] ? btrfs_update_delayed_inode+0x6b=
/0x126=20
[btrfs]
[138138.492359]  [<ffffffffa018b507>] ? start_transaction+0x1f5/0x242 [=
btrfs]
[138138.492387]  [<ffffffffa01c640f>] ?=20
btrfs_async_run_delayed_node_done+0x8a/0x138 [btrfs]
[138138.492417]  [<ffffffffa01ae872>] ? worker_loop+0x186/0x4a1 [btrfs]
[138138.492426]  [<ffffffff813361ea>] ? schedule+0x5ed/0x61a
[138138.492453]  [<ffffffffa01ae6ec>] ? btrfs_queue_worker+0x24a/0x24a =
[btrfs]
[138138.492480]  [<ffffffffa01ae6ec>] ? btrfs_queue_worker+0x24a/0x24a =
[btrfs]
[138138.492489]  [<ffffffff8105fadd>] ? kthread+0x7a/0x82
[138138.492498]  [<ffffffff8133dd24>] ? kernel_thread_helper+0x4/0x10
[138138.492507]  [<ffffffff8105fa63>] ? kthread_worker_fn+0x147/0x147
[138138.492516]  [<ffffffff8133dd20>] ? gs_change+0x13/0x13
merkaba:~>=20
Message from syslogd@merkaba at Jun 23 18:30:41 ...
 kernel:[138166.427817] Stack:

Message from syslogd@merkaba at Jun 23 18:30:41 ...
 kernel:[138166.427851] Call Trace:

Message from syslogd@merkaba at Jun 23 18:30:41 ...
 kernel:[138166.428406] Code: 00 01 00 75 04 f0 0f b1 17 0f 94 c2 0f b6=
 c2=20
85 c0 0f 95 c0 0f b6 c0 c3 b8 00 00 01 00 f0 0f c1 07 0f b7 d0 c1 e8 10=
 39=20
c2 74 07 <f3> 90 0f b7 17 eb f5 c3 9c 58 66 66 90 66 90 48 89 c2 fa 66 =
66=20

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.396102] Stack:

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.396150] Call Trace:

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.396227] Code: e0 ff ff a8 08 75 0e e8 7e ba da e0 66 90=
 fa=20
66 66 90 66 66 90 65 48 8b 04 25 08 cd 00 00 83 88 3c e0 ff ff 04 eb 0c=
 8b=20
57 04 ec=20

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.396667] Stack:

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.396700] Call Trace:

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.396703]  <IRQ>=20

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.396840]  <EOI>=20

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.397396] Code: 41 ff c0 4c 89 0c 07 48 83 c0 08 41 39 c8=
 7c=20
e8 c3 48 63 c9 45 31 c0 45 31 c9 48 83 c1 3f 45 31 d2 48 c1 e9 06 eb 19=
 4a=20
8b 04 02=20

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.398412] Stack:

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.398447] Call Trace:

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.398451]  <IRQ>=20

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.398485]  <EOI>=20

Message from syslogd@merkaba at Jun 23 18:30:46 ...
 kernel:[138171.398574] Code: 44 e0 ff ff 00 00 01 00 48 63 80 44 e0 ff=
 ff a9=20
00 ff ff 07 75 37 65 8b 04 25 80 26 01 00 85 c0 74 2b 80 3d 2d a2 63 00=
 00=20
75 07 <e8> 4e f4 fb ff eb 1b 65 48 8b 3c 25 70 e6 00 00 48 85 ff 74 0d=20


Since the backup process was stalled, rsync was D+ and umount -lf did=20
hang, too. I decided that it would be better to reboot my machine.

Then I was scared away that neither 3.0.0-rc3-amd64 and 2.6.39-2-amd64=20
debian kernel were able to mount a completely unrelated BTRFS filesyste=
m.=20
Namely my BTRFS root filesystem located on an Intel SSD 320 with 300 GB=
=2E I=20
got a backtrace I unfortunately did not photograph, cause I thought I w=
ill=20
see it on recovery with GRML anyway, and got dumped to initramfs shell.

On an other ThinkPad, a T42, I grabbed grml 2011.05 64-Bit and dd=B4d i=
t a=20
an USB stick. And thanks God there, with a 2.6.38 grml kernel, my BTRFS=
=20
root filesystem did mount well. Just for sure I run a mount -o clear_ca=
che=20
on the root filesystem although I never activated space_cache there.

Then I rebooted into my Debian Unstable and all was well again.

The only hints in syslog I found were:

1741 Jun 23 18:15:34 merkaba kernel: [137261.752879] ata6: SATA link up=
=20
3.0 Gbps (SStatus 123 SControl 300)
1742 Jun 23 18:15:34 merkaba kernel: [137261.753946] ata6.00: ACPI cmd=20
ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
1743 Jun 23 18:15:34 merkaba kernel: [137261.753956] ata6.00: ACPI cmd=20
f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
1744 Jun 23 18:15:34 merkaba kernel: [137261.756041] ata6.00: ACPI cmd=20
ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
1745 Jun 23 18:15:34 merkaba kernel: [137261.756055] ata6.00: ACPI cmd=20
f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
1746 Jun 23 18:15:34 merkaba kernel: [137261.757703] ata6.00: configure=
d=20
for UDMA/133
1747 Jun 23 18:15:34 merkaba kernel: [137261.772834] ata6: EH complete
1748 Jun 23 18:17:01 merkaba /USR/SBIN/CRON[25888]: (root) CMD (   cd /=
 &&=20
run-parts --report /etc/cron.hourly)
1749 Jun 23 18:18:34 merkaba kernel: [137440.930038] device label daten=
=20
devid 1 transid 7 /dev/sdc2
1750 Jun 23 18:18:34 merkaba kernel: [137440.930507] btrfs: enabling di=
sk=20
space caching
1751 Jun 23 18:18:34 merkaba kernel: [137440.930518] btrfs: use lzo=20
compression
1752 Jun 23 18:22:00 merkaba kernel: [137646.534245] device label daten=
=20
devid 1 transid 10 /dev/sdc2
1753 Jun 23 18:22:00 merkaba kernel: [137646.534556] btrfs: use lzo=20
compression
1754 Jun 23 18:22:00 merkaba kernel: [137646.549740] btrfs: disk space=20
caching is enabled
1755 Jun 23 18:24:48 merkaba kernel: [137813.653916] device label daten=
-
backup devid 1 transid 162 /dev/mapper/steigerwald-daten
1756 Jun 23 18:24:48 merkaba kernel: [137813.654566] btrfs: use lzo=20
compression
1757 Jun 23 18:24:48 merkaba kernel: [137813.691677] btrfs: disk space=20
caching is enabled
1758 Jun 23 18:26:41 merkaba kernel: [137927.147252] block group=20
147131990016 has an wrong amount of free space
1759 Jun 23 18:26:41 merkaba kernel: [137927.147255] btrfs: failed to l=
oad=20
free space cache for block group 147131990016

Then there is a long gap where apparently nothing got written onto the=20
root filesystem anymore. Partly due to me using GRML trying to restore=20
things.

1760 Jun 23 19:00:01 merkaba kernel: imklog 5.8.2, log source =3D /proc=
/kmsg=20
started.
1761 Jun 23 19:00:01 merkaba rsyslogd: [origin software=3D"rsyslogd"=20
swVersion=3D"5.8.2" x-pid=3D"1342" x-info=3D"http://www.rsyslog.com"] s=
tart
1762 Jun 23 19:00:01 merkaba kernel: [    0.000000] Initializing cgroup=
=20
subsys cpuset
1763 Jun 23 19:00:01 merkaba kernel: [    0.000000] Initializing cgroup=
=20
subsys cpu
1764 Jun 23 19:00:01 merkaba kernel: [    0.000000] Linux version 3.0.0=
-
rc3-amd64 (Debian 3.0.0~rc3-1~experimental.1) (maks@debian.org) (     g=
cc=20
version 4.4.6 (Debian 4.4.6-6) ) #1 SMP Thu Jun 16 13:23:22 UTC 2011



Since rsyncing files and movies to two different BTRFS partitions that=20
actually used space_cache I suspect that the failure is related to havi=
ng=20
the subvolume on the BTRFS filesystem that failed so miserably.

As for reproducability: I am now restoring the backup for my external=20
drive to a BTRFS *without* space cache to have my data redundant again.=
=20
But I did create the subvolume again to see whether the only difference=
=20
really is the space cache. Lets see how it turns out.

Thus I do not like to use this drive for another experiment. But I shou=
ld=20
have another 60/80 GB 2.5 inch drives here where I could test it.=20
Suspected steps to reproduce:

- create BTRFS
- mount with compress=3Dlzo,space_cache enabled
- umount
- mount again only with compress=3Dlzo
- create subvolume
- rsync stuff to it
- issue should appear after some MB of data transferred

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
