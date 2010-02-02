From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: panic after remove of device during rebalance
Date: Tue, 2 Feb 2010 20:06:29 +0100
Message-ID: <201002022006.29513.kreijack@libero.it>
References: <20100202112058.193030@gmx.net> <20100202144714.193050@gmx.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100202144714.193050@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 02 February 2010, Norbert Scheibner wrote:
> This happened after reboot:
> 
> /btrfs-show
> Label: none  uuid: ca5e7037-a65c-45d8-b954-f64ab0799964
>         Total devices 2 FS bytes used 6.01GB
>         devid    5 size 623.25GB used 7.32GB path /dev/md15
>         devid    1 size 9.31GB used 7.32GB path /dev/md11
> 
> /btrfsck /dev/md11
> failed to open /dev/btrfs-control skipping device registration
> failed to open /dev/btrfs-control skipping device registration
> failed to open /dev/btrfs-control skipping device registration
> failed to open /dev/btrfs-control skipping device registration
> failed to open /dev/btrfs-control skipping device registration
> failed to open /dev/btrfs-control skipping device registration
> fs tree 256 refs 1 not found
>         unresolved ref root 257 dir 256 index 8 namelen 8 name subvol00 
error 600
> found 6449324032 bytes used err is 1
> total csum bytes: 6291456
> total tree bytes: 6873088
> total fs tree bytes: 36864
> btree space waste bytes: 159776
> file data blocks allocated: 10737418240
>  referenced 10737418240
> 
> mount -t btrfs /dev/md15 /home/samba/temp/btrfs-tests/
> mount: wrong fs type, bad option, bad superblock on /dev/md15,
>        missing codepage or helper program, or other error
>        Manchmal liefert das Syslog wertvolle Informationen  versuchen
>        Sie  dmesg | tail  oder so
>
It seems that you don't have called "btrfsctl -a". If you don't do that, btrfs 
was unable to mount a multi-volume filesystem.
Pay attention to invoke "btrfsctl -a" after the btrfs module is loaded.

> /btrfsck /dev/md11
> fs tree 256 refs 1 not found
>         unresolved ref root 257 dir 256 index 8 namelen 8 name subvol00 
error 600
> found 6449324032 bytes used err is 1
> total csum bytes: 6291456
> total tree bytes: 6873088
> total fs tree bytes: 36864
> btree space waste bytes: 159776
> file data blocks allocated: 10737418240
>  referenced 10737418240
> 
> And the logs:
> Feb  2 14:10:11 server kernel: [ 4188.478576] Btrfs loaded
> Feb  2 14:10:11 server kernel: [ 4188.480370] device fsid 
d8455ca637705eca-649979b04af654b9 devid 5 transid 679 /dev/md15
> Feb  2 14:10:11 server kernel: [ 4188.481053] btrfs: failed to read the 
system array on md15
> Feb  2 14:10:11 server kernel: [ 4188.496590] btrfs: open_ctree failed
> Feb  2 14:10:17 server kernel: [ 4194.622045] device fsid 
d8455ca637705eca-649979b04af654b9 devid 1 transid 679 /dev/md11
> Feb  2 14:10:17 server kernel: [ 4194.667871] device fsid 
d8455ca637705eca-649979b04af654b9 devid 5 transid 679 /dev/md15
> Feb  2 14:10:17 server kernel: [ 4194.695295] device fsid 
d8455ca637705eca-649979b04af654b9 devid 1 transid 679 /dev/md/11
> Feb  2 14:10:17 server kernel: [ 4194.699507] device fsid 
d8455ca637705eca-649979b04af654b9 devid 5 transid 679 /dev/md/15
> Feb  2 14:10:20 server kernel: [ 4197.287320] device fsid 
d8455ca637705eca-649979b04af654b9 devid 1 transid 679 /dev/md11
> Feb  2 14:10:20 server kernel: [ 4197.290500] device fsid 
d8455ca637705eca-649979b04af654b9 devid 5 transid 679 /dev/md15
> Feb  2 14:10:20 server kernel: [ 4197.307757] device fsid 
d8455ca637705eca-649979b04af654b9 devid 1 transid 679 /dev/md/11
> Feb  2 14:10:20 server kernel: [ 4197.312969] device fsid 
d8455ca637705eca-649979b04af654b9 devid 5 transid 679 /dev/md/15
> Feb  2 14:10:31 server kernel: [ 4208.291488] device fsid 
d8455ca637705eca-649979b04af654b9 devid 5 transid 679 /dev/md15
> Feb  2 14:10:31 server kernel: [ 4208.309594] btrfs: unlinked 1 orphans
> Feb  2 14:15:25 server kernel: [ 4502.850336] btrfs: relocating block group 
73774923776 flags 17
> Feb  2 14:15:27 server kernel: [ 4504.572962] btrfs allocation failed flags 
17, wanted 4096
> Feb  2 14:15:27 server kernel: [ 4504.572966] space_info has 260046848 free, 
is full
> Feb  2 14:15:27 server kernel: [ 4504.572969] space_info total=6774456320, 
pinned=0, delalloc=81199104, may_use=0, used=6442450944, root=0, super=65536, 
reserved=71892992
> Feb  2 14:15:27 server kernel: [ 4504.572973] block group 61291364352 has 
1073741824 bytes, 1058013184 used 0 pinned 15663104 reserved
> Feb  2 14:15:27 server kernel: [ 4504.572975] block group has cluster?: no
> Feb  2 14:15:27 server kernel: [ 4504.572976] 0 blocks of free space at or 
bigger than bytes is
> Feb  2 14:15:27 server kernel: [ 4504.572979] block group 62365106176 has 
1073741824 bytes, 1069547520 used 0 pinned 4194304 reserved
> Feb  2 14:15:27 server kernel: [ 4504.572980] block group has cluster?: no
> Feb  2 14:15:27 server kernel: [ 4504.572982] 0 blocks of free space at or 
bigger than bytes is
> Feb  2 14:15:27 server kernel: [ 4504.572984] block group 69139562496 has 
1073741824 bytes, 1063256064 used 0 pinned 10485760 reserved
> Feb  2 14:15:27 server kernel: [ 4504.572986] block group has cluster?: no
> Feb  2 14:15:27 server kernel: [ 4504.572987] 0 blocks of free space at or 
bigger than bytes is
> Feb  2 14:15:27 server kernel: [ 4504.572989] block group 70213304320 has 
1073741824 bytes, 1062207488 used 0 pinned 11534336 reserved
> Feb  2 14:15:27 server kernel: [ 4504.572990] block group has cluster?: no
> Feb  2 14:15:27 server kernel: [ 4504.572992] 0 blocks of free space at or 
bigger than bytes is
> Feb  2 14:15:27 server kernel: [ 4504.572994] block group 71287046144 has 
332005376 bytes, 312475648 used 0 pinned 19529728 reserved
> Feb  2 14:15:27 server kernel: [ 4504.572995] block group has cluster?: no
> Feb  2 14:15:27 server kernel: [ 4504.572996] 0 blocks of free space at or 
bigger than bytes is
> Feb  2 14:15:27 server kernel: [ 4504.572999] block group 72701181952 has 
1073741824 bytes, 1063256064 used 0 pinned 10485760 reserved
> Feb  2 14:15:27 server kernel: [ 4504.573000] block group has cluster?: no
> Feb  2 14:15:27 server kernel: [ 4504.573001] 0 blocks of free space at or 
bigger than bytes is
> Feb  2 14:15:27 server kernel: [ 4504.573003] block group 73774923776 has 
1073741824 bytes, 813694976 used 0 pinned 0 reserved
> Feb  2 14:15:27 server kernel: [ 4504.573005] entry offset 74588618752, 
bytes 260046848, bitmap no
> Feb  2 14:15:27 server kernel: [ 4504.573007] block group has cluster?: no
> Feb  2 14:15:27 server kernel: [ 4504.573008] 1 blocks of free space at or 
bigger than bytes is
> Feb  2 14:15:27 server kernel: [ 4504.573033] ------------[ cut here 
]------------
> Feb  2 14:15:27 server kernel: [ 4504.573101] kernel BUG at 
fs/btrfs/inode.c:788!
> Feb  2 14:15:27 server kernel: [ 4504.573166] invalid opcode: 0000 [#1] SMP
> Feb  2 14:15:27 server kernel: [ 4504.573233] last sysfs file: 
/sys/class/hwmon/hwmon0/temp1_input
> Feb  2 14:15:27 server kernel: [ 4504.573300] Modules linked in: btrfs 
zlib_deflate crc32c libcrc32c autofs4 cpufreq_powersave cpufreq_ondemand 
cpufreq_stats ipt_REJECT ipt_MASQUERADE xt_TCPMSS xt_mac ipt_REDIRECT xt_DSCP 
xt_tcpudp xt_state xt_length ipt_LOG xt_limit iptable_nat nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables 
x_tables nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_udplite 
nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nfnetlink 
nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp nf_conntrack ppp_async 
crc_ccitt ppp_generic slhc ipv6 nls_utf8 isofs loop powernow_k8 freq_table 
cpufreq_userspace video pl2303 snd_pcm snd_timer backlight snd edac_core 
i2c_nforce2 wmi output button asus_atk0110 processor ftdi_sio usbserial 
i2c_core soundcore snd_page_alloc evdev pcspkr ext3 jbd mbcache dm_mirror 
dm_region_hash dm_log dm_snapshot dm_mod raid1 md_mod ata_generic pata_amd 
sd_mod amd74xx ahci libata ide_pci_generic firewire
> _ohci firewire_core crc_itu_t sky2 ide_core forcedeth scsi_mod ohci_hcd 
ehci_hcd thermal fan thermal_sys hwmon [last unloaded: scsi_wait_scan]
> Feb  2 14:15:27 server kernel: [ 4504.574363]
> Feb  2 14:15:27 server kernel: [ 4504.574425] Pid: 6114, comm: btrfs-vol Not 
tainted (2.6.32 #1) System Product Name
> Feb  2 14:15:27 server kernel: [ 4504.574550] EIP: 0060:[<fecf5948>] EFLAGS: 
00010286 CPU: 1
> Feb  2 14:15:27 server kernel: [ 4504.574626] EIP is at 
cow_file_range+0x5f8/0x610 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.574693] EAX: ffffffe4 EBX: ffffffff 
ECX: 0000fafa EDX: 00000001
> Feb  2 14:15:27 server kernel: [ 4504.574761] ESI: 0000000e EDI: 00001000 
EBP: 00000000 ESP: f41638e4
> Feb  2 14:15:27 server kernel: [ 4504.574829]  DS: 007b ES: 007b FS: 00d8 
GS: 0033 SS: 0068
> Feb  2 14:15:27 server kernel: [ 4504.574897] Process btrfs-vol (pid: 6114, 
ti=f4162000 task=ef17e540 task.ti=f4162000)
> Feb  2 14:15:27 server kernel: [ 4504.575022] Stack:
> Feb  2 14:15:27 server kernel: [ 4504.575082]  00970000 00000000 00001000 
00000000 00000000 00000000 58c10000 0000000e
> Feb  2 14:15:27 server kernel: [ 4504.575161] <0> ffffffff ffffffff f4163957 
00000001 00000000 f3ac2050 c24f7da0 f3ac216c
> Feb  2 14:15:27 server kernel: [ 4504.575297] <0> 00001000 f3ac2054 f4903800 
f3955724 00970000 00000000 00001000 00000000
> Feb  2 14:15:27 server kernel: [ 4504.575491] Call Trace:
> Feb  2 14:15:27 server kernel: [ 4504.575561]  [<fecf6696>] ? 
run_delalloc_range+0x3d6/0x440 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.575636]  [<fed14cb8>] ? 
__extent_writepage+0x938/0xae0 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.575707]  [<c115234f>] ? 
radix_tree_gang_lookup_tag_slot+0x9f/0xd0
> Feb  2 14:15:27 server kernel: [ 4504.575777]  [<c1094b3b>] ? 
find_get_pages_tag+0x3b/0x130
> Feb  2 14:15:27 server kernel: [ 4504.575850]  [<fed10ad0>] ? 
extent_write_cache_pages+0x170/0x270 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.575930]  [<fed10c28>] ? 
extent_writepages+0x58/0x80 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576003]  [<fed14380>] ? 
__extent_writepage+0x0/0xae0 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576080]  [<fed0e510>] ? 
flush_write_bio+0x0/0x10 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576153]  [<fecf3a00>] ? 
btrfs_get_extent+0x0/0xbc0 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576226]  [<fecf388c>] ? 
btrfs_writepages+0x1c/0x30 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576299]  [<fecf3870>] ? 
btrfs_writepages+0x0/0x30 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576367]  [<c109bdfa>] ? 
do_writepages+0x1a/0x40
> Feb  2 14:15:27 server kernel: [ 4504.576434]  [<c10e20de>] ? 
writeback_single_inode+0xbe/0x310
> Feb  2 14:15:27 server kernel: [ 4504.576502]  [<c10e2e40>] ? 
writeback_inodes_wb+0x380/0x530
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<c109c583>] ? 
balance_dirty_pages_ratelimited_nr+0x223/0x330
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<fed114b4>] ? 
clear_extent_bit+0xe4/0x520 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<fed31b80>] ? 
relocate_file_extent_cluster+0x480/0x540 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<fed32112>] ? 
relocate_block_group+0x3e2/0x4c0 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<fecef1ca>] ? 
btrfs_clean_old_snapshots+0x5a/0xe0 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<fed325ec>] ? 
btrfs_relocate_block_group+0x1cc/0x370 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<fed190b9>] ? 
btrfs_relocate_chunk+0x89/0x5f0 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<c10d7f8d>] ? 
__d_lookup+0x8d/0x110
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<fed0dbfb>] ? 
map_private_extent_buffer+0x8b/0x130 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<fed19e3d>] ? 
btrfs_balance+0x2ad/0x310 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<fed1f022>] ? 
btrfs_ioctl+0x392/0xa80 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<c1095824>] ? 
filemap_fault+0x74/0x390
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<c10ac541>] ? 
__do_fault+0x361/0x450
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<fed1ec90>] ? 
btrfs_ioctl+0x0/0xa80 [btrfs]
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<c10d36db>] ? 
vfs_ioctl+0x2b/0x90
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<c10d3beb>] ? 
do_vfs_ioctl+0x3cb/0x600
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<c101ee52>] ? 
do_page_fault+0x122/0x300
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<c10d3e86>] ? 
sys_ioctl+0x66/0x70
> Feb  2 14:15:27 server kernel: [ 4504.576503]  [<c1002db5>] ? 
syscall_call+0x7/0xb
> Feb  2 14:15:27 server kernel: [ 4504.576503] Code: 00 81 c3 00 10 00 00 83 
d6 00 0f ac f3 0c 01 1a 8b 84 24 a8 00 00 00 c7 00 01 00 00 00 e9 46 fe ff ff 
0f 0b eb fe 90 8d 74 26 00 <0f> 0b eb fe 8d 74 26 00 31 db 31 f6 e9 bd fb ff 
ff 0f 0b eb fe
> Feb  2 14:15:27 server kernel: [ 4504.576503] EIP: [<fecf5948>] 
cow_file_range+0x5f8/0x610 [btrfs] SS:ESP 0068:f41638e4
> Feb  2 14:15:27 server kernel: [ 4504.578542] ---[ end trace 
5bf61caa2660c1ba ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
