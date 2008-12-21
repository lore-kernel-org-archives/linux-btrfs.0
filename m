From: devzero@web.de
Subject: Re: btrfs filesystem freeze
Date: Sun, 21 Dec 2008 15:09:38 +0100
Message-ID: <551034715@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

thank you.

i tried your patch and did another test run.

first, it looked better as i could do much more snapshots than before, =
but then it froze again.

i don`t really have a clue if your patch enhanced anything, as my test =
setup isn`t exactly  reproducable for now and i did not check for exact=
 "testing lab conditions".

after /btrfs froze again, i tried to unmount by forcibly unloading btrf=
s module.=20

after reloading the module and trying to mount again, it failed with th=
e following  kernel message:

Btrfs loaded
device fsid 5a4d439e2deac810-b51a36e8fff563aa devid 1 transid 2188 /dev=
/sdb1
btrfs: use compression
btrfs: unlinked 1 orphans
parent transid verify failed on 199385088 wanted 2189 found 2190
------------[ cut here ]------------
WARNING: at /tmp/btrfs-unstable-standalone/free-space-cache.c:337 __btr=
fs_remove_free_space+0x1cd/0x1d7 [btrfs]()
Modules linked in: btrfs(N) crc32c libcrc32c zlib_deflate ip6t_LOG xt_t=
cpudp xt_pkttype ipt_LOG xt_limit vmsync(N) vmmemctl(N) vmblock(N) binf=
mt_misc snd_pcm_oss snd_mixer_oss snd_seq_midi snd_seq_midi_event snd_s=
eq microcode af_packet ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NO=
TRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf=
_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack ip_tables ip6table=
_filter ip6_tables x_tables ipv6 fuse loop dm_mod ppdev rtc_cmos rtc_co=
re rtc_lib pcspkr snd_ens1371 gameport snd_rawmidi floppy snd_seq_devic=
e parport_pc parport snd_ac97_codec ac97_bus pcnet32 snd_pcm snd_timer =
vmxnet(N) snd soundcore snd_page_alloc mii i2c_piix4 container ac i2c_c=
ore button intel_agp sg isp1760(N) shpchp vmci(N) mptctl agpgart sr_mod=
 cdrom pci_hotplug ehci_hcd uhci_hcd usbcore sd_mod crc_t10dif edd ext3=
 mbcache jbd fan ide_pci_generic piix ide_core ata_generic mptspi mptsc=
sih mptbase scsi_transport_spi ata_piix libata scsi_mod dock thermal pr=
ocessor thermal_sys hwmon [last unloaded: speedstep_lib]
Supported: No
Pid: 4407, comm: mount Tainted: G          2.6.27.7-9-pae #1
 [<c0106570>] dump_trace+0x6b/0x249
 [<c01070a5>] show_trace+0x20/0x39
 [<c035175f>] dump_stack+0x71/0x76
 [<c012ddf8>] warn_on_slowpath+0x4d/0x70
 [<e11e7f74>] __btrfs_remove_free_space+0x1cd/0x1d7 [btrfs]
 [<e11e7fb4>] btrfs_remove_free_space+0x31/0x43 [btrfs]
 [<e11b0667>] btrfs_alloc_logged_extent+0x96/0x109 [btrfs]
 [<e11e43e2>] overwrite_item+0x41d/0x442 [btrfs]
 [<e11e4b94>] replay_one_extent+0x237/0x289 [btrfs]
 [<e11e52bb>] replay_one_buffer+0x272/0x2f2 [btrfs]
 [<e11e2b51>] walk_down_log_tree+0x19d/0x49a [btrfs]
 [<e11e2ed9>] walk_log_tree+0x8b/0x1df [btrfs]
 [<e11e3528>] btrfs_recover_log_trees+0x193/0x2a4 [btrfs]
 [<e11bb968>] open_ctree+0xd22/0xf02 [btrfs]
 [<e11a12b0>] btrfs_get_sb+0x20f/0x3b8 [btrfs]
 [<c019e1be>] vfs_kern_mount+0x89/0xfa
 [<c019e278>] do_kern_mount+0x35/0xbb
 [<c01b19df>] do_new_mount+0x54/0x88
 [<c01b25b2>] do_mount+0x1a1/0x1bd
 [<c01b2647>] sys_mount+0x79/0xb2
 [<c0104c9b>] sysenter_do_call+0x12/0x2f
 [<ffffe430>] 0xffffe430
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
---[ end trace 66ff2f1ee53d7b6b ]---
adding space in the middle of an existing free space area. existing: of=
fset=3D218546176, bytes=3D262144. new: offset=3D218599424, bytes=3D8192
------------[ cut here ]------------
kernel BUG at /tmp/btrfs-unstable-standalone/free-space-cache.c:220!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/net/lo/type
Modules linked in: btrfs(N) crc32c libcrc32c zlib_deflate ip6t_LOG xt_t=
cpudp xt_pkttype ipt_LOG xt_limit vmsync(N) vmmemctl(N) vmblock(N) binf=
mt_misc snd_pcm_oss snd_mixer_oss snd_seq_midi snd_seq_midi_event snd_s=
eq microcode af_packet ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NO=
TRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf=
_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack ip_tables ip6table=
_filter ip6_tables x_tables ipv6 fuse loop dm_mod ppdev rtc_cmos rtc_co=
re rtc_lib pcspkr snd_ens1371 gameport snd_rawmidi floppy snd_seq_devic=
e parport_pc parport snd_ac97_codec ac97_bus pcnet32 snd_pcm snd_timer =
vmxnet(N) snd soundcore snd_page_alloc mii i2c_piix4 container ac i2c_c=
ore button intel_agp sg isp1760(N) shpchp vmci(N) mptctl agpgart sr_mod=
 cdrom pci_hotplug ehci_hcd uhci_hcd usbcore sd_mod crc_t10dif edd ext3=
 mbcache jbd fan ide_pci_generic piix ide_core ata_generic mptspi mptsc=
sih mptbase scsi_transport_spi ata_piix libata scsi_mod dock thermal pr=
ocessor thermal_sys hwmon [last unloaded: speedstep_lib]
Supported: No

Pid: 4407, comm: mount Tainted: G        W (2.6.27.7-9-pae #1)
EIP: 0060:[<e11e7c5c>] EFLAGS: 00010292 CPU: 0
EIP is at __btrfs_add_free_space+0x11d/0x268 [btrfs]
EAX: 0000008a EBX: 00000000 ECX: da54dc1c EDX: e11ebcac
ESI: dc0e0d40 EDI: 0d07b000 EBP: 00000000 ESP: da54dc18
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process mount (pid: 4407, ti=3Dda54c000 task=3Dde1022b0 task.ti=3Dda54c=
000)
Stack: e11ebcac 0d06c000 00000000 00040000 00000000 0d079000 00000000 0=
0002000
       00000000 0d079000 00000000 dc87c780 dc0e0d40 dc094180 dc87c7fc 0=
d079000
       00000000 dc87c7b0 e11e8058 00002000 00000000 de12e050 00000000 0=
0002000
Call Trace:
 [<e11e8058>] btrfs_add_free_space+0x34/0x78 [btrfs]
 [<e11aea56>] btrfs_update_pinned_extents+0x1d8/0x215 [btrfs]
 [<e11b4a3a>] btrfs_finish_extent_commit+0x75/0xe0 [btrfs]
 [<e11bdd06>] btrfs_commit_transaction+0x4f0/0x642 [btrfs]
 [<e11e3628>] btrfs_recover_log_trees+0x293/0x2a4 [btrfs]
 [<e11bb968>] open_ctree+0xd22/0xf02 [btrfs]
 [<e11a12b0>] btrfs_get_sb+0x20f/0x3b8 [btrfs]
 [<c019e1be>] vfs_kern_mount+0x89/0xfa
 [<c019e278>] do_kern_mount+0x35/0xbb
 [<c01b19df>] do_new_mount+0x54/0x88
 [<c01b25b2>] do_mount+0x1a1/0x1bd
 [<c01b2647>] sys_mount+0x79/0xb2
 [<c0104c9b>] sysenter_do_call+0x12/0x2f
 [<ffffe430>] 0xffffe430
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: 28 89 44 24 14 89 54 24 18 8b 46 20 8b 56 24 89 4c 24 04 89 5c 24=
 08 89 44 24 0c 89 54 24 10 c7 04 24 ac bc 1e e1 e8 29 9c 16 df <0f> 0b=
 eb fe 31 ed 83 7c 24 30 00 0f 84 aa 00 00 00 8b 54 24 30
EIP: [<e11e7c5c>] __btrfs_add_free_space+0x11d/0x268 [btrfs] SS:ESP 006=
8:da54dc18
---[ end trace 66ff2f1ee53d7b6b ]---


i did a clean reboot and tried again, but it failed again.

Btrfs loaded
device fsid 5a4d439e2deac810-b51a36e8fff563aa devid 1 transid 2190 /dev=
/sdb1
btrfs: use compression
parent transid verify failed on 199385088 wanted 2190 found 2189
read extent buffer pages failed with ret 0 mirror no 0
parent transid verify failed on 199385088 wanted 2190 found 2189
read extent buffer pages failed with ret 0 mirror no 1
parent transid verify failed on 199385088 wanted 2190 found 2189
read extent buffer pages failed with ret 0 mirror no 2
btrfs: unable to add free space :-17
------------[ cut here ]------------
kernel BUG at /tmp/btrfs-unstable-standalone/free-space-cache.c:265!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/net/lo/type
Modules linked in: btrfs(N) zlib_deflate crc32c libcrc32c ip6t_LOG xt_t=
cpudp xt_pkttype ipt_LOG xt_li                       mit vmsync(N) vmme=
mctl(N) vmblock(N) microcode binfmt_misc snd_pcm_oss snd_mixer_oss snd_=
seq_midi snd                       _seq_midi_event snd_seq af_packet ip=
6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt      =
                 _state iptable_raw iptable_filter ip6table_mangle nf_c=
onntrack_netbios_ns nf_conntrack_ipv4 nf_conntr                       a=
ck ip_tables ip6table_filter ip6_tables x_tables ipv6 fuse loop dm_mod =
ppdev rtc_cmos rtc_core rtc_l                       ib pcspkr parport_p=
c parport floppy snd_ens1371 gameport snd_rawmidi snd_seq_device button=
 snd_ac97_c                       odec ac97_bus pcnet32 snd_pcm snd_tim=
er vmxnet(N) snd soundcore snd_page_alloc mii i2c_piix4 ac conta       =
                iner sg i2c_core shpchp sr_mod cdrom vmci(N) intel_agp =
pci_hotplug isp1760(N) mptctl agpgart ehci_hcd                        u=
hci_hcd usbcore sd_mod crc_t10dif edd ext3 mbcache jbd fan ide_pci_gene=
ric piix ide_core ata_generi                       c mptspi mptscsih mp=
tbase scsi_transport_spi ata_piix libata scsi_mod dock thermal processo=
r thermal_                       sys hwmon [last unloaded: speedstep_li=
b]
Supported: No

Pid: 4421, comm: ls Tainted: G          (2.6.27.7-9-pae #1)
EIP: 0060:[<e11efd89>] EFLAGS: 00010246 CPU: 0
EIP is at __btrfs_add_free_space+0x24a/0x268 [btrfs]
EAX: 00000028 EBX: ffffffef ECX: dd889a3c EDX: e11f3dd5
ESI: 00000000 EDI: 01c13000 EBP: 00000000 ESP: dd889a38
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process ls (pid: 4421, ti=3Ddd888000 task=3Ddb0f2630 task.ti=3Ddd888000=
)
Stack: e11f3dd5 ffffffef 00000001 e11c1039 00000000 00000000 0000088e 0=
0000000
       0000088e 01c05000 00000000 dad03480 00000000 00000000 dad034fc 0=
1c05000
       00000000 dad034b0 e11f0058 0000e000 00000000 e11dbff0 00000000 d=
c104050
Call Trace:
 [<e11f0058>] btrfs_add_free_space+0x34/0x78 [btrfs]
 [<e11b2563>] add_new_free_space+0xd7/0xf2 [btrfs]
 [<e11b5737>] cache_block_group+0x19a/0x2b6 [btrfs]
 [<e11b5c73>] find_free_extent+0x420/0x961 [btrfs]
 [<e11b6417>] __btrfs_reserve_extent+0x263/0x451 [btrfs]
 [<e11b844c>] btrfs_alloc_extent+0x9f/0x12a [btrfs]
 [<e11b85a3>] btrfs_alloc_free_block+0xcc/0xfa [btrfs]
 [<e11abe35>] __btrfs_cow_block+0x257/0x862 [btrfs]
 [<e11acc9f>] btrfs_cow_block+0x201/0x209 [btrfs]
 [<e11b005f>] btrfs_search_slot+0x30e/0x765 [btrfs]
 [<e11bfe33>] btrfs_lookup_inode+0x2f/0x91 [btrfs]
 [<e11c944f>] btrfs_update_inode+0x46/0xab [btrfs]
 [<e11cca0d>] btrfs_dirty_inode+0x3d/0x4a [btrfs]
 [<c01b7b22>] __mark_inode_dirty+0x24/0x162
 [<c01ad895>] touch_atime+0xb1/0xb6
 [<c01a758d>] vfs_readdir+0x75/0x8c
 [<c01a760a>] sys_getdents64+0x66/0xa6
 [<c0104c9b>] sysenter_do_call+0x12/0x2f
 [<ffffe430>] 0xffffe430
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: c0 89 c3 74 3a 8b 44 24 34 e8 a1 6f fa de c7 44 24 34 00 00 00 00=
 89 5c 24 04 c7 04 24 d5 3d 1f                        e1 e8 01 1b 16 df=
 83 fb ef 75 04 <0f> 0b eb fe 83 7c 24 34 00 74 09 8b 44 24 34 e8 70 6f=
 fa de 83
EIP: [<e11efd89>] __btrfs_add_free_space+0x24a/0x268 [btrfs] SS:ESP 006=
8:dd889a38
---[ end trace 85c3c24065792740 ]---


i did a btrfschk and it gave the following output:

linux-uqw0:/tmp/btrfs-progs-unstable # ./btrfsck /dev/sdb1
leaf parent key incorrect 199385088
bad block 199385088
Backref 0 parent 199540736 [5 2190 26076 1] not referenced
Incorrect local backref count on 0 parent 199540736 found 0 wanted 1
Backref 0 parent 200105984 [5 2190 25833 1] not referenced
Incorrect local backref count on 0 parent 200105984 found 0 wanted 1
Backref 0 parent 200118272 [5 2190 25942 1] not referenced
Incorrect local backref count on 0 parent 200118272 found 0 wanted 1
Backref 0 parent 200134656 [5 2190 25980 1] not referenced
Incorrect local backref count on 0 parent 200134656 found 0 wanted 1
Backref 0 parent 200138752 [5 2190 25985 1] not referenced
Incorrect local backref count on 0 parent 200138752 found 0 wanted 1
backpointer mismatch on [0 1]
Backref 40656896 parent 236986368 [5 2186 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 236986368 found 1 want=
ed 0
Backref 40656896 parent 146292736 [5 2139 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 146292736 found 1 want=
ed 0
Backref 40656896 parent 148328448 [5 2128 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 148328448 found 1 want=
ed 0
Backref 40656896 parent 151310336 [5 2134 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 151310336 found 1 want=
ed 0
Backref 40656896 parent 152326144 [5 2153 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 152326144 found 1 want=
ed 0
Backref 40656896 parent 152379392 [5 2142 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 152379392 found 1 want=
ed 0
Backref 40656896 parent 160460800 [5 2116 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 160460800 found 1 want=
ed 0
Backref 40656896 parent 160538624 [5 2126 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 160538624 found 1 want=
ed 0
Backref 40656896 parent 161521664 [5 2141 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 161521664 found 1 want=
ed 0
Backref 40656896 parent 161767424 [297 2157 0 0] not found in extent tr=
ee
Incorrect local backref count on 40656896 parent 161767424 found 1 want=
ed 0
Backref 40656896 parent 162516992 [5 2151 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 162516992 found 1 want=
ed 0
Backref 40656896 parent 164720640 [5 2143 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 164720640 found 1 want=
ed 0
Backref 40656896 parent 170131456 [5 2172 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 170131456 found 1 want=
ed 0
Backref 40656896 parent 171323392 [5 2159 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 171323392 found 1 want=
ed 0
Backref 40656896 parent 175534080 [5 2110 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 175534080 found 1 want=
ed 0
Backref 40656896 parent 179064832 [5 2175 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 179064832 found 1 want=
ed 0
Backref 40656896 parent 183066624 [5 2178 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 183066624 found 1 want=
ed 0
Backref 40656896 parent 187469824 [5 2177 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 187469824 found 1 want=
ed 0
Backref 40656896 parent 188297216 [5 2180 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 188297216 found 1 want=
ed 0
Backref 40656896 parent 189009920 [5 2190 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 189009920 found 1 want=
ed 0
Backref 40656896 parent 197922816 [5 2179 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 197922816 found 1 want=
ed 0
Backref 40656896 parent 206921728 [5 2181 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 206921728 found 1 want=
ed 0
Backref 40656896 parent 220114944 [5 2185 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 220114944 found 1 want=
ed 0
Backref 40656896 parent 223477760 [5 2187 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 223477760 found 1 want=
ed 0
Backref 40656896 parent 228864000 [5 2183 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 228864000 found 1 want=
ed 0
Backref 40656896 parent 232751104 [5 2188 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 232751104 found 1 want=
ed 0
backpointer mismatch on [40656896 4096]
ref mismatch on [40660992 4096] extent item 0, found 51
Backref 40660992 parent 30576640 [5 2120 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 30576640 found 1 wante=
d 0
Backref 40660992 parent 37814272 [5 2133 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 37814272 found 1 wante=
d 0
Backref 40660992 parent 42930176 [5 2140 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 42930176 found 1 wante=
d 0
Backref 40660992 parent 48713728 [5 2123 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 48713728 found 1 wante=
d 0
Backref 40660992 parent 51142656 [5 2149 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 51142656 found 1 wante=
d 0
Backref 40660992 parent 51474432 [5 2122 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 51474432 found 1 wante=
d 0
Backref 40660992 parent 52072448 [5 2162 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 52072448 found 1 wante=
d 0
Backref 40660992 parent 52543488 [5 2154 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 52543488 found 1 wante=
d 0
Backref 40660992 parent 56999936 [5 2163 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 56999936 found 1 wante=
d 0
Backref 40660992 parent 57012224 [5 2147 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 57012224 found 1 wante=
d 0
Backref 40660992 parent 57442304 [5 2150 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 57442304 found 1 wante=
d 0
Backref 40660992 parent 60194816 [5 2124 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 60194816 found 1 wante=
d 0
Backref 40660992 parent 61083648 [5 2131 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 61083648 found 1 wante=
d 0
Backref 40660992 parent 67694592 [5 2132 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 67694592 found 1 wante=
d 0
Backref 40660992 parent 71462912 [5 2164 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 71462912 found 1 wante=
d 0
Backref 40660992 parent 73502720 [5 2148 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 73502720 found 1 wante=
d 0
Backref 40660992 parent 76099584 [5 2125 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 76099584 found 1 wante=
d 0
Backref 40660992 parent 77303808 [5 2137 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 77303808 found 1 wante=
d 0
Backref 40660992 parent 77656064 [5 2138 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 77656064 found 1 wante=
d 0
Backref 40660992 parent 78086144 [5 2146 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 78086144 found 1 wante=
d 0
Backref 40660992 parent 79241216 [5 2166 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 79241216 found 1 wante=
d 0
backpointer mismatch on [40660992 4096]
ref mismatch on [695775232 4096] extent item 4, found 5
Backref 695775232 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 695775232 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [695775232 4096]
ref mismatch on [734654464 4096] extent item 6, found 7
Backref 734654464 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 734654464 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [734654464 4096]
ref mismatch on [780615680 4096] extent item 6, found 7
Backref 780615680 parent 199385088 [18446744073709551610 2189 25546 0] =
not found in extent tree
Incorrect local backref count on 780615680 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [780615680 4096]
ref mismatch on [782815232 4096] extent item 5, found 6
Backref 782815232 parent 199385088 [18446744073709551610 2189 25543 0] =
not found in extent tree
Incorrect local backref count on 782815232 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [782815232 4096]
ref mismatch on [782909440 4096] extent item 5, found 6
Backref 782909440 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 782909440 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [782909440 4096]
ref mismatch on [787476480 4096] extent item 5, found 6
Backref 787476480 parent 199385088 [18446744073709551610 2189 25546 0] =
not found in extent tree
Incorrect local backref count on 787476480 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [787476480 4096]
ref mismatch on [787628032 4096] extent item 5, found 6
Backref 787628032 parent 199385088 [18446744073709551610 2189 25543 0] =
not found in extent tree
Incorrect local backref count on 787628032 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [787628032 4096]
ref mismatch on [787636224 4096] extent item 4, found 5
Backref 787636224 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 787636224 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [787636224 4096]
ref mismatch on [788037632 4096] extent item 4, found 5
Backref 788037632 parent 199385088 [18446744073709551610 2189 25543 0] =
not found in extent tree
Incorrect local backref count on 788037632 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [788037632 4096]
ref mismatch on [788779008 4096] extent item 4, found 5
Backref 788779008 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 788779008 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [788779008 4096]
ref mismatch on [789692416 4096] extent item 4, found 5
Backref 789692416 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 789692416 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [789692416 4096]
ref mismatch on [790446080 20480] extent item 3, found 4
Backref 790446080 parent 199385088 [18446744073709551610 2189 25543 0] =
not found in extent tree
Incorrect local backref count on 790446080 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [790446080 20480]
ref mismatch on [807403520 114688] extent item 2, found 3
Backref 807403520 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 807403520 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [807403520 114688]
ref mismatch on [807804928 98304] extent item 2, found 3
Backref 807804928 parent 199385088 [18446744073709551610 2189 25543 0] =
not found in extent tree
Incorrect local backref count on 807804928 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [807804928 98304]
found 636325902 bytes used err is 1
total csum bytes: 0
total tree bytes: 64659456
btree space waste bytes: 15781636
file data blocks allocated: 954400768
 referenced 1564815360
Btrfs v0.16-29-g0d53b21


after that check, i found that /btrfs was actually mounted and i accide=
ntally fsck`ed a mounted fs.
i didn`t notice that it was mounted as i got those kernel messages and =
the mount gave an error (i didn`t write down, maybe segfault...) , so f=
or sure i would have umounted befor fsck. i`m curious why btrfsck didn`=
t tell that it was actually mounted.  maybe we need some more safety he=
re ?

after another reboot, i did another fsck which gave this:

leaf parent key incorrect 199385088
bad block 199385088
Backref 0 parent 199540736 [5 2190 26076 1] not referenced
Incorrect local backref count on 0 parent 199540736 found 0 wanted 1
Backref 0 parent 200105984 [5 2190 25833 1] not referenced
Incorrect local backref count on 0 parent 200105984 found 0 wanted 1
Backref 0 parent 200118272 [5 2190 25942 1] not referenced
Incorrect local backref count on 0 parent 200118272 found 0 wanted 1
Backref 0 parent 200134656 [5 2190 25980 1] not referenced
Incorrect local backref count on 0 parent 200134656 found 0 wanted 1
Backref 0 parent 200138752 [5 2190 25985 1] not referenced
Incorrect local backref count on 0 parent 200138752 found 0 wanted 1
backpointer mismatch on [0 1]
Backref 40656896 parent 236986368 [5 2186 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 236986368 found 1 want=
ed 0
Backref 40656896 parent 146292736 [5 2139 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 146292736 found 1 want=
ed 0
Backref 40656896 parent 148328448 [5 2128 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 148328448 found 1 want=
ed 0
Backref 40656896 parent 151310336 [5 2134 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 151310336 found 1 want=
ed 0
Backref 40656896 parent 152326144 [5 2153 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 152326144 found 1 want=
ed 0
Backref 40656896 parent 152379392 [5 2142 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 152379392 found 1 want=
ed 0
Backref 40656896 parent 160460800 [5 2116 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 160460800 found 1 want=
ed 0
Backref 40656896 parent 160538624 [5 2126 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 160538624 found 1 want=
ed 0
Backref 40656896 parent 161521664 [5 2141 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 161521664 found 1 want=
ed 0
Backref 40656896 parent 161767424 [297 2157 0 0] not found in extent tr=
ee
Incorrect local backref count on 40656896 parent 161767424 found 1 want=
ed 0
Backref 40656896 parent 162516992 [5 2151 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 162516992 found 1 want=
ed 0
Backref 40656896 parent 164720640 [5 2143 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 164720640 found 1 want=
ed 0
Backref 40656896 parent 170131456 [5 2172 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 170131456 found 1 want=
ed 0
Backref 40656896 parent 171323392 [5 2159 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 171323392 found 1 want=
ed 0
Backref 40656896 parent 175534080 [5 2110 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 175534080 found 1 want=
ed 0
Backref 40656896 parent 179064832 [5 2175 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 179064832 found 1 want=
ed 0
Backref 40656896 parent 183066624 [5 2178 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 183066624 found 1 want=
ed 0
Backref 40656896 parent 187469824 [5 2177 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 187469824 found 1 want=
ed 0
Backref 40656896 parent 188297216 [5 2180 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 188297216 found 1 want=
ed 0
Backref 40656896 parent 189009920 [5 2190 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 189009920 found 1 want=
ed 0
Backref 40656896 parent 197922816 [5 2179 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 197922816 found 1 want=
ed 0
Backref 40656896 parent 206921728 [5 2181 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 206921728 found 1 want=
ed 0
Backref 40656896 parent 220114944 [5 2185 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 220114944 found 1 want=
ed 0
Backref 40656896 parent 223477760 [5 2187 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 223477760 found 1 want=
ed 0
Backref 40656896 parent 228864000 [5 2183 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 228864000 found 1 want=
ed 0
Backref 40656896 parent 232751104 [5 2188 0 0] not found in extent tree
Incorrect local backref count on 40656896 parent 232751104 found 1 want=
ed 0
backpointer mismatch on [40656896 4096]
ref mismatch on [40660992 4096] extent item 0, found 51
Backref 40660992 parent 30576640 [5 2120 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 30576640 found 1 wante=
d 0
Backref 40660992 parent 37814272 [5 2133 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 37814272 found 1 wante=
d 0
Backref 40660992 parent 42930176 [5 2140 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 42930176 found 1 wante=
d 0
Backref 40660992 parent 48713728 [5 2123 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 48713728 found 1 wante=
d 0
Backref 40660992 parent 51142656 [5 2149 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 51142656 found 1 wante=
d 0
Backref 40660992 parent 51474432 [5 2122 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 51474432 found 1 wante=
d 0
Backref 40660992 parent 52072448 [5 2162 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 52072448 found 1 wante=
d 0
Backref 40660992 parent 52543488 [5 2154 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 52543488 found 1 wante=
d 0
Backref 40660992 parent 56999936 [5 2163 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 56999936 found 1 wante=
d 0
Backref 40660992 parent 57012224 [5 2147 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 57012224 found 1 wante=
d 0
Backref 40660992 parent 57442304 [5 2150 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 57442304 found 1 wante=
d 0
Backref 40660992 parent 60194816 [5 2124 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 60194816 found 1 wante=
d 0
Backref 40660992 parent 61083648 [5 2131 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 61083648 found 1 wante=
d 0
Backref 40660992 parent 67694592 [5 2132 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 67694592 found 1 wante=
d 0
Backref 40660992 parent 71462912 [5 2164 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 71462912 found 1 wante=
d 0
Backref 40660992 parent 73502720 [5 2148 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 73502720 found 1 wante=
d 0
Backref 40660992 parent 76099584 [5 2125 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 76099584 found 1 wante=
d 0
Backref 40660992 parent 77303808 [5 2137 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 77303808 found 1 wante=
d 0
Backref 40660992 parent 77656064 [5 2138 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 77656064 found 1 wante=
d 0
Backref 40660992 parent 78086144 [5 2146 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 78086144 found 1 wante=
d 0
Backref 40660992 parent 79241216 [5 2166 0 0] not found in extent tree
Incorrect local backref count on 40660992 parent 79241216 found 1 wante=
d 0
backpointer mismatch on [40660992 4096]
ref mismatch on [695775232 4096] extent item 4, found 5
Backref 695775232 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 695775232 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [695775232 4096]
ref mismatch on [734654464 4096] extent item 6, found 7
Backref 734654464 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 734654464 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [734654464 4096]
ref mismatch on [780615680 4096] extent item 6, found 7
Backref 780615680 parent 199385088 [18446744073709551610 2189 25546 0] =
not found in extent tree
Incorrect local backref count on 780615680 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [780615680 4096]
ref mismatch on [782815232 4096] extent item 5, found 6
Backref 782815232 parent 199385088 [18446744073709551610 2189 25543 0] =
not found in extent tree
Incorrect local backref count on 782815232 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [782815232 4096]
ref mismatch on [782909440 4096] extent item 5, found 6
Backref 782909440 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 782909440 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [782909440 4096]
ref mismatch on [787476480 4096] extent item 5, found 6
Backref 787476480 parent 199385088 [18446744073709551610 2189 25546 0] =
not found in extent tree
Incorrect local backref count on 787476480 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [787476480 4096]
ref mismatch on [787628032 4096] extent item 5, found 6
Backref 787628032 parent 199385088 [18446744073709551610 2189 25543 0] =
not found in extent tree
Incorrect local backref count on 787628032 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [787628032 4096]
ref mismatch on [787636224 4096] extent item 4, found 5
Backref 787636224 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 787636224 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [787636224 4096]
ref mismatch on [788037632 4096] extent item 4, found 5
Backref 788037632 parent 199385088 [18446744073709551610 2189 25543 0] =
not found in extent tree
Incorrect local backref count on 788037632 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [788037632 4096]
ref mismatch on [788779008 4096] extent item 4, found 5
Backref 788779008 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 788779008 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [788779008 4096]
ref mismatch on [789692416 4096] extent item 4, found 5
Backref 789692416 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 789692416 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [789692416 4096]
ref mismatch on [790446080 20480] extent item 3, found 4
Backref 790446080 parent 199385088 [18446744073709551610 2189 25543 0] =
not found in extent tree
Incorrect local backref count on 790446080 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [790446080 20480]
ref mismatch on [807403520 114688] extent item 2, found 3
Backref 807403520 parent 199385088 [18446744073709551610 2189 25487 0] =
not found in extent tree
Incorrect local backref count on 807403520 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [807403520 114688]
ref mismatch on [807804928 98304] extent item 2, found 3
Backref 807804928 parent 199385088 [18446744073709551610 2189 25543 0] =
not found in extent tree
Incorrect local backref count on 807804928 parent 199385088 found 1 wan=
ted 0
backpointer mismatch on [807804928 98304]
found 636325902 bytes used err is 1
total csum bytes: 0
total tree bytes: 64659456
btree space waste bytes: 15781636
file data blocks allocated: 954400768
 referenced 1564815360
Btrfs v0.16-29-g0d53b21

but it doens`t help.=20
btrfs mounts afterwards, but giving the same kernel messages and it isn=
`t accessible.

oh, btw - btrfsck has a little bug:

=2E/btrfsck --help
Segmentation fault

i will keep that hosed volume for a while and start with a new virtual =
disk from scratch.

hth
roland



> devzero@web.de wrote:
> > Hello,=20
> >=20
> > i was testing btrfs a little bit for stability and i think i have f=
ound an issue.
> >=20
> > during some heavy activity (multiple processes writing/reading to c=
ompressed /btrfs at the same time), i did some snapshots in a loop (eve=
ry 10 seconds).
> >=20
> > very soon, all filesystem activity stopped, i.e. i cannot read/writ=
e anyting from/to /btrfs anymore.
> > this happens with latest git-unstable with kernel 2.6.27
> > nothing in dmesg.=20
> >=20
> > besides that, the system seems ok.
> >=20
> > as the system is a vmware virtual machine, i did a snapshot of the =
system state, so we can always go back to this state.
> >=20
> > if somebody want`s to analyse this, please tell me what to do.
> >=20
>=20
> Thank you for reporting this. Please try the attached patch.
>=20
> Yan Zheng
>=20
> ---
> diff -urp 1/fs/btrfs/transaction.c 2/fs/btrfs/transaction.c
> --- 1/fs/btrfs/transaction.c	2008-12-13 12:35:29.487886730 +0800
> +++ 2/fs/btrfs/transaction.c	2008-12-21 19:09:09.000000000 +0800
> @@ -804,7 +804,7 @@ static noinline int finish_pending_snaps
> =20
>  	parent_inode =3D pending->dentry->d_parent->d_inode;
>  	parent_root =3D BTRFS_I(parent_inode)->root;
> -	trans =3D btrfs_start_transaction(parent_root, 1);
> +	trans =3D btrfs_join_transaction(parent_root, 1);
> =20
>  	/*
>  	 * insert the directory item
>=20


_______________________________________________________________________
T=E4glich 1.000.000 Euro gewinnen! Jetzt kostenlos WEB.DE MillionenKlic=
k=20
spielen! https://millionenklick.web.de/?mc=3Dmail@footer.mklick@home

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
