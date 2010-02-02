From: "Norbert Scheibner" <scno@gmx.net>
Subject: panic after remove of device during rebalance
Date: Tue, 02 Feb 2010 12:20:58 +0100
Message-ID: <20100202112058.193030@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
During some btrfs-tests for my own on a btrfs-volume started with 5 devices of different size, some snapshots and subvolumes and a few large files, I removed one device after another (always rebalancing after remove) til I ended up with 3.

I use the latest btrfs-tools snapshot and the 2.6.32 kernel with debian patches for sid.

btrfs-show then said:
Label: none  uuid: ca5e7037-a65c-45d8-b954-f64ab0799964
        Total devices 3 FS bytes used 6.01GB
        devid    5 size 623.25GB used 0.00 path /dev/md15
        devid    3 size 93.13GB used 9.01GB path /dev/md13
        devid    1 size 9.31GB used 9.01GB path /dev/md11

Then I removed number 3.

./btrfs-vol -r /dev/md13 /home/samba/temp/btrfs-tests/
ioctl returns 0
./btrfs-show
Label: none  uuid: ca5e7037-a65c-45d8-b954-f64ab0799964
        Total devices 3 FS bytes used 6.01GB
        devid    3 size 93.13GB used 9.01GB path /dev/sdc4
        devid    5 size 623.25GB used 8.31GB path /dev/md15
        devid    1 size 9.31GB used 8.31GB path /dev/md11

(/dev/sdc4 is the underlying device under /dev/md13, which I removed, I don't know why it still shows up as /dev/sdc4, but that happened before with the other devices I removed, so I didn't bother)

Now I startet to rebalance.

After 30 minutes or so ps ax still said:
17995 pts/3    S+     0:16 ./btrfs-vol -b /home/samba/temp/btrfs-tests/

After an hour ps ax said
17995 pts/3    R+    68:31 ./btrfs-vol -b /home/samba/temp/btrfs-tests/
and btrfs-vol consumes 100% of 1 CPU and can not be killed.

And thats what ./btrfsck /dev/md11 produced
fs tree 256 refs 1 not found
        unresolved ref root 257 dir 256 index 8 namelen 8 name subvol00 error 600
found 6449324032 bytes used err is 1
total csum bytes: 6291456
total tree bytes: 6873088
total fs tree bytes: 36864
btree space waste bytes: 159776
file data blocks allocated: 10737418240
 referenced 10737418240

subvol00 is a subvolume I created and deleted before. The error 600 was there before I started removing devices.

Thats what I found in the logs:

Feb  2 10:40:27 server kernel: [250931.124172] ------------[ cut here ]------------
Feb  2 10:40:27 server kernel: [250931.124239] kernel BUG at fs/btrfs/inode.c:788!
Feb  2 10:40:27 server kernel: [250931.124304] invalid opcode: 0000 [#1] SMP
Feb  2 10:40:27 server kernel: [250931.124371] last sysfs file: /sys/class/hwmon/hwmon0/temp1_input
Feb  2 10:40:27 server kernel: [250931.124440] Modules linked in: btrfs zlib_deflate crc32c libcrc32c autofs4 cpufreq_powersave cpufreq_ondemand cpufreq_stats ipt_REJECT ipt_MASQUERADE xt_TCPMSS xt_mac ipt_REDIRECT xt_DSCP xt_tcpudp xt_state xt_length ipt_LOG xt_limit iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_udplite nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nfnetlink nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp nf_conntrack ppp_async crc_ccitt ppp_generic slhc ipv6 nls_utf8 isofs loop powernow_k8 freq_table cpufreq_userspace video backlight ftdi_sio pl2303 asus_atk0110 output wmi usbserial snd_pcm snd_timer snd soundcore snd_page_alloc processor edac_
 core button i2c_nforce2 pcspkr i2c_core evdev ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid1 md_mod ata_generic pata_amd sd_mod amd74xx ahci libata forcedeth firewire_ohci firewire_core crc_itu_t ide_pci_generic ohci_hcd sky2 scsi_mod ehci_hcd ide_core thermal fan thermal_sys hwmon [last unloaded: scsi_wait_scan]
Feb  2 10:40:27 server kernel: [250931.125004]
Feb  2 10:40:27 server kernel: [250931.125004] Pid: 17936, comm: flush-btrfs-6 Not tainted (2.6.32 #1) System Product Name
Feb  2 10:40:27 server kernel: [250931.125004] EIP: 0060:[<f8a9c948>] EFLAGS: 00010286 CPU: 2
Feb  2 10:40:27 server kernel: [250931.125004] EIP is at cow_file_range+0x5f8/0x610 [btrfs]
Feb  2 10:40:27 server kernel: [250931.125004] EAX: ffffffe4 EBX: ffffffff ECX: 00008989 EDX: 00000001
Feb  2 10:40:27 server kernel: [250931.125004] ESI: 0000000e EDI: 00001000 EBP: 00000000 ESP: d3c0dc18
Feb  2 10:40:27 server kernel: [250931.125004]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Feb  2 10:40:27 server kernel: [250931.125004] Process flush-btrfs-6 (pid: 17936, ti=d3c0c000 task=c431e070 task.ti=d3c0c000)
Feb  2 10:40:27 server kernel: [250931.125004] Stack:
Feb  2 10:40:27 server kernel: [250931.125004]  02770000 00000000 00001000 00000000 00000000 00000000 85400000 0000000e
Feb  2 10:40:27 server kernel: [250931.125004] <0> ffffffff ffffffff d3c0dc8b 00000001 00000000 c8e6dab0 c243dea0 c8e6dbcc
Feb  2 10:40:27 server kernel: [250931.125004] <0> 00001000 c8e6dab4 ce603800 d8593db4 02770000 00000000 00001000 00000000
Feb  2 10:40:27 server kernel: [250931.125004] Call Trace:
Feb  2 10:40:27 server kernel: [250931.125004]  [<f8a9d696>] ? run_delalloc_range+0x3d6/0x440 [btrfs]
Feb  2 10:40:27 server kernel: [250931.125004]  [<f8abbcb8>] ? __extent_writepage+0x938/0xae0 [btrfs]
Feb  2 10:40:27 server kernel: [250931.125004]  [<f8ab89f0>] ? end_bio_extent_writepage+0x0/0x200 [btrfs]
Feb  2 10:40:27 server kernel: [250931.125004]  [<f8ab7ad0>] ? extent_write_cache_pages+0x170/0x270 [btrfs]
Feb  2 10:40:27 server kernel: [250931.125004]  [<f8ab7c28>] ? extent_writepages+0x58/0x80 [btrfs]
Feb  2 10:40:27 server kernel: [250931.125004]  [<f8abb380>] ? __extent_writepage+0x0/0xae0 [btrfs]
Feb  2 10:40:27 server kernel: [250931.125004]  [<f8ab5510>] ? flush_write_bio+0x0/0x10 [btrfs]
Feb  2 10:40:27 server kernel: [250931.125004]  [<f8a9aa00>] ? btrfs_get_extent+0x0/0xbc0 [btrfs]
Feb  2 10:40:27 server kernel: [250931.125004]  [<f8a9a88c>] ? btrfs_writepages+0x1c/0x30 [btrfs]
Feb  2 10:40:27 server kernel: [250931.125004]  [<f8a9a870>] ? btrfs_writepages+0x0/0x30 [btrfs]
Feb  2 10:40:27 server kernel: [250931.125004]  [<c109bdfa>] ? do_writepages+0x1a/0x40
Feb  2 10:40:27 server kernel: [250931.125004]  [<c10e20de>] ? writeback_single_inode+0xbe/0x310
Feb  2 10:40:27 server kernel: [250931.125004]  [<c10e2e40>] ? writeback_inodes_wb+0x380/0x530
Feb  2 10:40:27 server kernel: [250931.125004]  [<c10e30f8>] ? wb_writeback+0x108/0x1c0
Feb  2 10:40:27 server kernel: [250931.125004]  [<c10e330f>] ? wb_do_writeback+0x9f/0x180
Feb  2 10:40:27 server kernel: [250931.125004]  [<c10e343b>] ? bdi_writeback_task+0x4b/0x80
Feb  2 10:40:27 server kernel: [250931.125004]  [<c10aa877>] ? bdi_start_fn+0x67/0xc0
Feb  2 10:40:27 server kernel: [250931.125004]  [<c10aa810>] ? bdi_start_fn+0x0/0xc0
Feb  2 10:40:27 server kernel: [250931.125004]  [<c10504e4>] ? kthread+0x74/0x80
Feb  2 10:40:27 server kernel: [250931.125004]  [<c1050470>] ? kthread+0x0/0x80
Feb  2 10:40:27 server kernel: [250931.125004]  [<c100381f>] ? kernel_thread_helper+0x7/0x18
Feb  2 10:40:27 server kernel: [250931.125004] Code: 00 81 c3 00 10 00 00 83 d6 00 0f ac f3 0c 01 1a 8b 84 24 a8 00 00 00 c7 00 01 00 00 00 e9 46 fe ff ff 0f 0b eb fe 90 8d 74 26 00 <0f> 0b eb fe 8d 74 26 00 31 db 31 f6 e9 bd fb ff ff 0f 0b eb fe
Feb  2 10:40:27 server kernel: [250931.125004] EIP: [<f8a9c948>] cow_file_range+0x5f8/0x610 [btrfs] SS:ESP 0068:d3c0dc18
Feb  2 10:40:27 server kernel: [250931.133712] ---[ end trace 2f81334be95a397c ]---
