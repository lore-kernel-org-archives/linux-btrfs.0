Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:36721 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752249AbcIHSZD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Sep 2016 14:25:03 -0400
Received: by mail-qk0-f176.google.com with SMTP id z190so42198074qkc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Sep 2016 11:25:02 -0700 (PDT)
Message-ID: <1473359094.7190.1.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Jeff Mahoney <jeffm@suse.com>,
        Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Thu, 08 Sep 2016 15:24:54 -0300
In-Reply-To: <356a9e31-047e-d4c9-00ba-d01b6e92b266@cn.fujitsu.com>
References: <1471023419.16857.9.camel@gmail.com>
         <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
         <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
         <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
         <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
         <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
         <1472734635.3137.4.camel@gmail.com>
         <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
         <1472747695.3137.7.camel@gmail.com>
         <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
         <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
         <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
         <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
         <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
         <1472827395.3713.6.camel@gmail.com>
         <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com>
         <1472829630.3713.8.camel@gmail.com>
         <506f2875-8cea-2d99-3664-52ee546adcfd@suse.com>
         <1472844353.3083.1.camel@gmail.com>
         <356a9e31-047e-d4c9-00ba-d01b6e92b266@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all!

Em Seg, 2016-09-05 às 16:49 +0800, Qu Wenruo escreveu:
> Just like what Wang has mentioned, would you please paste all the
> output 
> of the contents of /sys/fs/btrfs/<your fs uuid>/allocation?
> 
> It's recommended to use "grep . -IR <path>" to get all the data as
> it 
> will show the file name.

So, one more time, I see the problem. This time I was just using
Firefox and I cannot recover using `btrfs balance`. I think that, one
more time, I will need to reboot this machine. This problem is really
causing me a lot of troubles :(

I have disabled the quotas and the first error message after the
problem was:

[ 2444.592255] ------------[ cut here ]------------
[ 2444.592314] WARNING: CPU: 4 PID: 289 at ../fs/btrfs/extent-
tree.c:4303 btrfs_free_reserved_data_space_noquota+0xfe/0x110 [btrfs]
[ 2444.592317] Modules linked in: fuse nf_log_ipv6 xt_pkttype
nf_log_ipv4 nf_log_common xt_LOG xt_limit af_packet iscsi_ibft
iscsi_boot_sysfs msr ip6t_REJECT nf_reject_ipv6 xt_tcpudp
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw nvidia_drm(PO) ipt_REJECT
nf_reject_ipv4 snd_hda_codec_hdmi nvidia_modeset(PO) intel_rapl sb_edac
edac_core x86_pkg_temp_thermal intel_powerclamp nvidia(PO) coretemp
snd_hda_codec_realtek iTCO_wdt snd_hda_codec_generic iptable_raw
drm_kms_helper snd_hda_intel drm xt_CT snd_hda_codec snd_hda_core
snd_hwdep kvm_intel snd_pcm snd_timer joydev mei_wdt fb_sys_fops
iTCO_vendor_support i2c_i801 lpc_ich kvm syscopyarea snd sysfillrect
irqbypass mei_me hp_wmi sysimgblt iptable_filter crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul
glue_helper ablk_helper
[ 2444.592386]  cryptd soundcore mei sparse_keymap rfkill e1000e shpchp
pcspkr ioatdma mfd_core tpm_infineon tpm_tis dca tpm fjes ptp pps_core
ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack
ip6table_filter ip6_tables x_tables btrfs xor raid6_pq hid_generic
usbhid crc32c_intel serio_raw xhci_pci ehci_pci xhci_hcd ehci_hcd
firewire_ohci sr_mod firewire_core cdrom crc_itu_t usbcore isci
usb_common libsas ata_generic mpt3sas raid_class scsi_transport_sas wmi
button sg
[ 2444.592447] CPU: 4 PID: 289 Comm: kworker/u65:7 Tainted:
P        W  O    4.7.1-1-default #1
[ 2444.592450] Hardware name: Hewlett-Packard HP Z820 Workstation/158B,
BIOS J63 v03.65 12/19/2013
[ 2444.592458] Workqueue: writeback wb_workfn (flush-btrfs-1)
[ 2444.592462]  0000000000000000 ffffffff81393104 0000000000000000
0000000000000000
[ 2444.592468]  ffffffff8107ca1e ffff88080de6d800 0000000000009000
ffff88080c437a00
[ 2444.592472]  ffff880634b379ac 0000000000009000 ffff88080dcfb73c
ffffffffa02af98e
[ 2444.592477] Call Trace:
[ 2444.592499]  [<ffffffff8102ed5e>] dump_trace+0x5e/0x320
[ 2444.592507]  [<ffffffff8102f12c>] show_stack_log_lvl+0x10c/0x180
[ 2444.592514]  [<ffffffff8102fe41>] show_stack+0x21/0x40
[ 2444.592523]  [<ffffffff81393104>] dump_stack+0x5c/0x78
[ 2444.592531]  [<ffffffff8107ca1e>] __warn+0xbe/0xe0
[ 2444.592561]  [<ffffffffa02af98e>]
btrfs_free_reserved_data_space_noquota+0xfe/0x110 [btrfs]
[ 2444.592602]  [<ffffffffa02cc036>] btrfs_clear_bit_hook+0x296/0x380
[btrfs]
[ 2444.592642]  [<ffffffffa02e9755>] clear_state_bit+0x55/0x1d0 [btrfs]
[ 2444.592676]  [<ffffffffa02e9a0d>] __clear_extent_bit+0x13d/0x3f0
[btrfs]
[ 2444.592707]  [<ffffffffa02ea8d2>]
extent_clear_unlock_delalloc+0x62/0x280 [btrfs]
[ 2444.592739]  [<ffffffffa02d1c19>] cow_file_range+0x299/0x440 [btrfs]
[ 2444.592768]  [<ffffffffa02d2cf2>] run_delalloc_range+0x392/0x3b0
[btrfs]
[ 2444.592801]  [<ffffffffa02eb090>]
writepage_delalloc.isra.40+0x100/0x170 [btrfs]
[ 2444.592834]  [<ffffffffa02ed9d3>] __extent_writepage+0xc3/0x340
[btrfs]
[ 2444.592864]  [<ffffffffa02ede8b>]
extent_write_cache_pages.isra.36.constprop.53+0x23b/0x350 [btrfs]
[ 2444.592894]  [<ffffffffa02ee4fe>] extent_writepages+0x4e/0x60
[btrfs]
[ 2444.592900]  [<ffffffff8123c64d>]
__writeback_single_inode+0x3d/0x3b0
[ 2444.592907]  [<ffffffff8123ce8a>] writeback_sb_inodes+0x20a/0x440
[ 2444.592914]  [<ffffffff8123d147>] __writeback_inodes_wb+0x87/0xb0
[ 2444.592921]  [<ffffffff8123d49d>] wb_writeback+0x28d/0x330
[ 2444.592927]  [<ffffffff8123dbe2>] wb_workfn+0x222/0x3f0
[ 2444.592934]  [<ffffffff810950ed>] process_one_work+0x1ed/0x4e0
[ 2444.592942]  [<ffffffff81095427>] worker_thread+0x47/0x4c0
[ 2444.592947]  [<ffffffff8109affd>] kthread+0xbd/0xe0
[ 2444.592954]  [<ffffffff816bb71f>] ret_from_fork+0x1f/0x40
[ 2444.596679] DWARF2 unwinder stuck at ret_from_fork+0x1f/0x40

[ 2444.596683] Leftover inexact backtrace:

[ 2444.596689]  [<ffffffff8109af40>] ? kthread_worker_fn+0x170/0x170

I will also provide the information requested by Qu:

grep . -IR /sys/fs/btrfs/e9efaa0c-d477-4249-830f-
ee5956768b29/allocation
allocation/data/flags:1
allocation/data/bytes_pinned:0
allocation/data/bytes_may_use:0
allocation/data/total_bytes_pinned:202973265920
allocation/data/bytes_reserved:0
allocation/data/bytes_used:45623730176
allocation/data/single/used_bytes:45623730176
allocation/data/single/total_bytes:46179287040
allocation/data/total_bytes:46179287040
allocation/data/disk_total:46179287040
allocation/data/disk_used:45623730176
allocation/metadata/dup/used_bytes:1120698368
allocation/metadata/dup/total_bytes:6979321856
allocation/metadata/flags:4
allocation/metadata/bytes_pinned:0
allocation/metadata/bytes_may_use:88521768960
allocation/metadata/total_bytes_pinned:-44285952
allocation/metadata/bytes_reserved:0
allocation/metadata/bytes_used:1120698368
allocation/metadata/total_bytes:6979321856
allocation/metadata/disk_total:13958643712
allocation/metadata/disk_used:2241396736
allocation/global_rsv_size:385875968
allocation/global_rsv_reserved:385875968
allocation/system/dup/used_bytes:16384
allocation/system/dup/total_bytes:33554432
allocation/system/flags:2
allocation/system/bytes_pinned:0
allocation/system/bytes_may_use:0
allocation/system/total_bytes_pinned:0
allocation/system/bytes_reserved:0
allocation/system/bytes_used:16384
allocation/system/total_bytes:33554432
allocation/system/disk_total:67108864
allocation/system/disk_used:32768

Additional information:

btrfs fi usage /
Overall:
    Device size:		   1.26TiB
    Device allocated:		  56.07GiB
    Device unallocated:		   1.20TiB
    Device missing:		     0.00B
    Used:			  44.58GiB
    Free (estimated):		   1.20TiB	(min: 616.41GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 368.00MiB	(used: 0.00B)

Data,single: Size:43.01GiB, Used:42.49GiB
   /dev/sda6	  43.01GiB

Metadata,DUP: Size:6.50GiB, Used:1.04GiB
   /dev/sda6	  13.00GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
   /dev/sda6	  64.00MiB

Unallocated:
   /dev/sda6	   1.20TiB

Can anyone help me?

Best regards,
Ronan Arraes
