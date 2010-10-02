From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: Kernel crash during btrfs benchmark
Date: Sat, 2 Oct 2010 19:49:21 -0400
Message-ID: <7840148079487357724@unknownmsgid>
References: <4CA7957B.9000903@bartk.us>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Type: text/plain; charset=US-ASCII
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Bart Kus <me@bartk.us>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CA7957B.9000903@bartk.us>
List-ID: <linux-btrfs.vger.kernel.org>

You didn't include kernel debugging informations and probably didn't
include frame pointers in your Kernel making the report useless.

Sent from my mobile device.

On 2010-10-02, at 16:32, Bart Kus <me@bartk.us> wrote:

> Hello,
>
> On the following system:
>
> Linux jo.bartk.us 2.6.35-gentoo-r9 #1 SMP Sat Oct 2 11:29:36 PDT 2010 x86_64 Intel(R) Core(TM)2 Quad CPU @ 2.40GHz GenuineIntel GNU/Linux
>
> I was running the following command:
>
> dbench -c /usr/share/dbench/client.txt -t 60 64
>
> When everything froze up and console started reporting errors.  The client.txt file can be obtained here: http://www.bartk.us/dump/client.txt.gz .  dbench version 4.00 was being used.  The System.map can be obtained from http://www.bartk.us/dump/System.map-genkernel-x86_64-2.6.35-gentoo-r9 , if that's helpful.  The underlying device is an md RAID6 with 11 2TB HDs, connected via sata_sil24 module (SiI3124 chip), which has its 4 eSATA ports connected to 4 SiI3726 port multipliers.  I have pulled a btrfs-image off the device and it can be obtained here: http://www.bartk.us/dump/btrfs.image .  Here are the details of the md device:
>
> /dev/md5:
>        Version : 1.02
>  Creation Time : Thu Sep 30 10:35:17 2010
>     Raid Level : raid6
>     Array Size : 17581629888 (16767.15 GiB 18003.59 GB)
>  Used Dev Size : 1953514432 (1863.02 GiB 2000.40 GB)
>   Raid Devices : 11
>  Total Devices : 11
>    Persistence : Superblock is persistent
>
>    Update Time : Sat Oct  2 13:03:27 2010
>          State : active, resyncing
> Active Devices : 11
> Working Devices : 11
> Failed Devices : 0
>  Spare Devices : 0
>
>     Chunk Size : 64K
>
> Rebuild Status : 10% complete
>
>           Name : jo.bartk.us:5  (local to host jo.bartk.us)
>           UUID : 5122c697:58113607:3f5bb07e:a8069132
>         Events : 39
>
>    Number   Major   Minor   RaidDevice State
>       0       8       64        0      active sync   /dev/sde
>       1       8      144        1      active sync   /dev/sdj
>       2       8        0        2      active sync   /dev/sda
>       3       8       16        3      active sync   /dev/sdb
>       4       8       32        4      active sync   /dev/sdc
>       5       8       48        5      active sync   /dev/sdd
>       6       8       80        6      active sync   /dev/sdf
>       7       8       96        7      active sync   /dev/sdg
>       8       8      112        8      active sync   /dev/sdh
>       9       8      128        9      active sync   /dev/sdi
>      10       8      160       10      active sync   /dev/sdk
>
> It's resyncing right now due to the crash, but wasn't at time of failure.  There are no partitions involved, /dev/md5 was directly formatted with btrfs.
>
> Full text of kernel crash follows:
>
> Oct  2 12:07:52 jo kernel: device fsid a34c8b899171b6f6-fa7e695b5cf51590 devid 1 transid 25 /dev/md5
> Oct  2 12:16:55 jo kernel: INFO: rcu_sched_state detected stall on CPU 3 (t=1000 jiffies)
> Oct  2 12:16:55 jo kernel: sending NMI to all CPUs:
> Oct  2 12:16:55 jo kernel: NMI backtrace for cpu 3
> Oct  2 12:16:55 jo kernel: CPU 3
> Oct  2 12:16:55 jo kernel: Modules linked in: tun ipv6 8021q iptable_raw iptable_mangle iptable_filter ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables x_tables rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core pcspkr processor snd_hda_codec_via snd_hda_intel atl1e snd_hda_codec thermal thermal_sys snd_hwdep snd_pcm snd_timer snd snd_page_alloc intel_agp button libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd 
 usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia firmware_class pcmcia_core pata_ns87415 pat
 a_ns87410 pata_serverworks pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata [last unloaded: microcode]
> Oct  2 12:16:55 jo kernel:
> Oct  2 12:16:55 jo kernel: Pid: 22695, comm: btrfs-worker-4 Not tainted 2.6.35-gentoo-r9 #1 P5Q PRO TURBO/System Product Name
> Oct  2 12:16:55 jo kernel: RIP: 0010:[<ffffffff81303c06>]  [<ffffffff81303c06>] 0xffffffff81303c06
> Oct  2 12:16:55 jo kernel: RSP: 0018:ffff880001983de0  EFLAGS: 00000803
> Oct  2 12:16:55 jo kernel: RAX: 00000000c68de520 RBX: 0000000000000001 RCX: ffff880001980000
> Oct  2 12:16:55 jo kernel: RDX: 0000000000249f7d RSI: 0000000000000002 RDI: 0000000000249f7e
> Oct  2 12:16:55 jo kernel: RBP: ffff880001983de8 R08: 000000000000001c R09: 000000000000000a
> Oct  2 12:16:55 jo kernel: R10: 0000000000000003 R11: 0000000000000000 R12: ffff88000198e9b0
> Oct  2 12:16:55 jo kernel: R13: ffffffff815d3080 R14: ffff88000198e778 R15: ffff880001983f48
> Oct  2 12:16:55 jo kernel: FS:  0000000000000000(0000) GS:ffff880001980000(0000) knlGS:0000000000000000
> Oct  2 12:16:55 jo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct  2 12:16:55 jo kernel: CR2: 00007f18f0b2f000 CR3: 00000000015bf000 CR4: 00000000000006e0
> Oct  2 12:16:55 jo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  2 12:16:55 jo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  2 12:16:55 jo kernel: Process btrfs-worker-4 (pid: 22695, threadinfo ffff88004bc96000, task ffff88011fe04cb0)
> Oct  2 12:16:55 jo kernel: Stack:
> Oct  2 12:16:55 jo kernel: ffffffff81303b55 ffff880001983df8 ffffffff81303b91 ffff880001983e18
> Oct  2 12:16:55 jo kernel: <0> ffffffff81018645 ffff88000198e778 ffffffff815d3080 ffff880001983e68
> Oct  2 12:16:55 jo kernel: <0> ffffffff81073786 ffff880001983e78 ffffffff8106f0e2 000000003b9aca00
> Oct  2 12:16:55 jo kernel: Call Trace:
> Oct  2 12:16:55 jo kernel: <IRQ>
> Oct  2 12:16:55 jo kernel: [<ffffffff81303b55>] ? 0xffffffff81303b55
> Oct  2 12:16:55 jo kernel: [<ffffffff81303b91>] 0xffffffff81303b91
> Oct  2 12:16:55 jo kernel: [<ffffffff81018645>] 0xffffffff81018645
> Oct  2 12:16:55 jo kernel: [<ffffffff81073786>] 0xffffffff81073786
> Oct  2 12:16:55 jo kernel: [<ffffffff8106f0e2>] ? 0xffffffff8106f0e2
> Oct  2 12:16:55 jo kernel: [<ffffffff81073adc>] 0xffffffff81073adc
> Oct  2 12:16:55 jo kernel: [<ffffffff8103b064>] 0xffffffff8103b064
> Oct  2 12:16:55 jo kernel: [<ffffffff8104efb5>] 0xffffffff8104efb5
> Oct  2 12:16:55 jo kernel: [<ffffffff81046ba0>] 0xffffffff81046ba0
> Oct  2 12:16:55 jo kernel: [<ffffffff81046dea>] 0xffffffff81046dea
> Oct  2 12:16:55 jo kernel: [<ffffffff81018044>] 0xffffffff81018044
> Oct  2 12:16:55 jo kernel: [<ffffffff81003213>] 0xffffffff81003213
> Oct  2 12:16:55 jo kernel: <EOI>
> Oct  2 12:16:55 jo kernel: [<ffffffff812eb6a0>] ? 0xffffffff812eb6a0
> Oct  2 12:16:55 jo kernel: [<ffffffff812e5942>] 0xffffffff812e5942
> Oct  2 12:16:55 jo kernel: [<ffffffff81308097>] 0xffffffff81308097
> Oct  2 12:16:55 jo kernel: [<ffffffff812931d2>] ? 0xffffffff812931d2
> Oct  2 12:16:55 jo kernel: [<ffffffff81279494>] 0xffffffff81279494
> Oct  2 12:16:55 jo kernel: [<ffffffff8127640f>] 0xffffffff8127640f
> Oct  2 12:16:55 jo kernel: [<ffffffff8127f048>] 0xffffffff8127f048
> Oct  2 12:16:55 jo kernel: [<ffffffff812773b6>] 0xffffffff812773b6
> Oct  2 12:16:55 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:16:55 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:16:55 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:16:55 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:16:55 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:16:55 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:16:55 jo kernel: Code: 01 00 65 8b 0c 25 60 d3 00 00 48 63 c9 48 8b 0c cd 00 74 60 81 48 6b 94 0a 98 00 00 00 19 f7 e2 48 8d 7a 01 e8 47 ff ff ff c9 c3 <55> 48 89 e5 65 8b 34 25 60 d3 00 00 0f 1f 00 0f ae e8 0f 31 89
> Oct  2 12:16:55 jo kernel: Call Trace:
> Oct  2 12:16:55 jo kernel: <IRQ>  [<ffffffff81303b55>] ? 0xffffffff81303b55
> Oct  2 12:16:55 jo kernel: [<ffffffff81303b91>] 0xffffffff81303b91
> Oct  2 12:16:55 jo kernel: [<ffffffff81018645>] 0xffffffff81018645
> Oct  2 12:16:55 jo kernel: [<ffffffff81073786>] 0xffffffff81073786
> Oct  2 12:16:55 jo kernel: [<ffffffff8106f0e2>] ? 0xffffffff8106f0e2
> Oct  2 12:16:55 jo kernel: [<ffffffff81073adc>] 0xffffffff81073adc
> Oct  2 12:16:55 jo kernel: [<ffffffff8103b064>] 0xffffffff8103b064
> Oct  2 12:16:55 jo kernel: [<ffffffff8104efb5>] 0xffffffff8104efb5
> Oct  2 12:16:55 jo kernel: [<ffffffff81046ba0>] 0xffffffff81046ba0
> Oct  2 12:16:55 jo kernel: [<ffffffff81046dea>] 0xffffffff81046dea
> Oct  2 12:16:55 jo kernel: [<ffffffff81018044>] 0xffffffff81018044
> Oct  2 12:16:55 jo kernel: [<ffffffff81003213>] 0xffffffff81003213
> Oct  2 12:16:55 jo kernel: <EOI>  [<ffffffff812eb6a0>] ? 0xffffffff812eb6a0
> Oct  2 12:16:55 jo kernel: [<ffffffff812e5942>] 0xffffffff812e5942
> Oct  2 12:16:55 jo kernel: [<ffffffff81308097>] 0xffffffff81308097
> Oct  2 12:16:55 jo kernel: [<ffffffff812931d2>] ? 0xffffffff812931d2
> Oct  2 12:16:55 jo kernel: [<ffffffff81279494>] 0xffffffff81279494
> Oct  2 12:16:55 jo kernel: [<ffffffff8127640f>] 0xffffffff8127640f
> Oct  2 12:16:55 jo kernel: [<ffffffff8127f048>] 0xffffffff8127f048
> Oct  2 12:16:55 jo kernel: [<ffffffff812773b6>] 0xffffffff812773b6
> Oct  2 12:16:55 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:16:55 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:16:55 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:16:55 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:16:55 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:16:55 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:16:55 jo kernel: Pid: 22695, comm: btrfs-worker-4 Not tainted 2.6.35-gentoo-r9 #1
> Oct  2 12:16:55 jo kernel: Call Trace:
> Oct  2 12:16:55 jo kernel: <NMI>  [<ffffffff8100a31c>] ? 0xffffffff8100a31c
> Oct  2 12:16:55 jo kernel: [<ffffffff810187b7>] 0xffffffff810187b7
> Oct  2 12:16:55 jo kernel: [<ffffffff8100446e>] 0xffffffff8100446e
> Oct  2 12:16:55 jo kernel: [<ffffffff8147197a>] 0xffffffff8147197a
> Oct  2 12:16:55 jo kernel: [<ffffffff81303c06>] ? 0xffffffff81303c06
> Oct  2 12:16:55 jo kernel: <<EOE>> <IRQ>  [<ffffffff81303b55>] ? 0xffffffff81303b55
> Oct  2 12:16:55 jo kernel: [<ffffffff81303b91>] 0xffffffff81303b91
> Oct  2 12:16:55 jo kernel: [<ffffffff81018645>] 0xffffffff81018645
> Oct  2 12:16:55 jo kernel: [<ffffffff81073786>] 0xffffffff81073786
> Oct  2 12:16:55 jo kernel: [<ffffffff8106f0e2>] ? 0xffffffff8106f0e2
> Oct  2 12:16:55 jo kernel: [<ffffffff81073adc>] 0xffffffff81073adc
> Oct  2 12:16:55 jo kernel: [<ffffffff8103b064>] 0xffffffff8103b064
> Oct  2 12:16:55 jo kernel: [<ffffffff8104efb5>] 0xffffffff8104efb5
> Oct  2 12:16:55 jo kernel: [<ffffffff81046ba0>] 0xffffffff81046ba0
> Oct  2 12:16:55 jo kernel: [<ffffffff81046dea>] 0xffffffff81046dea
> Oct  2 12:16:55 jo kernel: [<ffffffff81018044>] 0xffffffff81018044
> Oct  2 12:16:55 jo kernel: [<ffffffff81003213>] 0xffffffff81003213
> Oct  2 12:16:55 jo kernel: <EOI>  [<ffffffff812eb6a0>] ? 0xffffffff812eb6a0
> Oct  2 12:16:55 jo kernel: [<ffffffff812e5942>] 0xffffffff812e5942
> Oct  2 12:16:55 jo kernel: [<ffffffff81308097>] 0xffffffff81308097
> Oct  2 12:16:55 jo kernel: [<ffffffff812931d2>] ? 0xffffffff812931d2
> Oct  2 12:16:55 jo kernel: [<ffffffff81279494>] 0xffffffff81279494
> Oct  2 12:16:55 jo kernel: [<ffffffff8127640f>] 0xffffffff8127640f
> Oct  2 12:16:55 jo kernel: [<ffffffff8127f048>] 0xffffffff8127f048
> Oct  2 12:16:55 jo kernel: [<ffffffff812773b6>] 0xffffffff812773b6
> Oct  2 12:16:55 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:16:55 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:16:55 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:16:55 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:16:55 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:16:55 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:16:55 jo kernel: NMI backtrace for cpu 2
> Oct  2 12:16:55 jo kernel: CPU 2
> Oct  2 12:16:55 jo kernel: Modules linked in: tun ipv6 8021q iptable_raw iptable_mangle iptable_filter ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables x_tables rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core pcspkr processor snd_hda_codec_via snd_hda_intel atl1e snd_hda_codec thermal thermal_sys snd_hwdep snd_pcm snd_timer snd snd_page_alloc intel_agp button libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd 
 usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia firmware_class pcmcia_core pata_ns87415 pat
 a_ns87410 pata_serverworks pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata [last unloaded: microcode]
> Oct  2 12:16:55 jo kernel:
> Oct  2 12:16:55 jo kernel: Pid: 14616, comm: md5_raid6 Not tainted 2.6.35-gentoo-r9 #1 P5Q PRO TURBO/System Product Name
> Oct  2 12:16:55 jo kernel: RIP: 0010:[<ffffffff812f7e19>]  [<ffffffff812f7e19>] 0xffffffff812f7e19
> Oct  2 12:16:55 jo kernel: RSP: 0018:ffff88011f46bbd0  EFLAGS: 00000082
> Oct  2 12:16:55 jo kernel: RAX: 0000000000000000 RBX: ffff88011e6ad000 RCX: ffff88011e2f03d0
> Oct  2 12:16:55 jo kernel: RDX: 0000000000000001 RSI: ffff88011d350418 RDI: ffff88011e6ad000
> Oct  2 12:16:55 jo kernel: RBP: ffff88011f46bbd0 R08: ffff88011fe1ca58 R09: 0000000000000001
> Oct  2 12:16:55 jo kernel: R10: ffff88011e083938 R11: ffff88011f46bc90 R12: ffff88011d350418
> Oct  2 12:16:55 jo kernel: R13: ffff88011d350418 R14: ffff88011e6ad848 R15: ffff88011ecf21a0
> Oct  2 12:16:55 jo kernel: FS:  0000000000000000(0000) GS:ffff880001900000(0000) knlGS:0000000000000000
> Oct  2 12:16:55 jo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct  2 12:16:55 jo kernel: CR2: 00007f18f0b2f000 CR3: 000000011e50e000 CR4: 00000000000006e0
> Oct  2 12:16:55 jo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  2 12:16:55 jo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  2 12:16:55 jo kernel: Process md5_raid6 (pid: 14616, threadinfo ffff88011f46a000, task ffff88011d94acf0)
> Oct  2 12:16:55 jo kernel: Stack:
> Oct  2 12:16:55 jo kernel: ffff88011f46bc40 ffffffff812fab19 ffff88011f46bc40 ffff8800c8be85c0
> Oct  2 12:16:55 jo kernel: <0> ffff88011e7d0800 ffff88011e238000 ffff88011e083800 ffff8800d735cd30
> Oct  2 12:16:55 jo kernel: <0> ffff88011f46bc50 ffff88011e6ad800 ffff88011e2f1450 ffff88011f46bc58
> Oct  2 12:16:55 jo kernel: Call Trace:
> Oct  2 12:16:55 jo kernel: [<ffffffff812fab19>] 0xffffffff812fab19
> Oct  2 12:16:55 jo kernel: [<ffffffff812ee214>] 0xffffffff812ee214
> Oct  2 12:16:55 jo kernel: [<ffffffff812fdda7>] ? 0xffffffff812fdda7
> Oct  2 12:16:55 jo kernel: [<ffffffff813a5a01>] 0xffffffff813a5a01
> Oct  2 12:16:55 jo kernel: [<ffffffff8103af84>] ? 0xffffffff8103af84
> Oct  2 12:16:55 jo kernel: [<ffffffff812eeb94>] 0xffffffff812eeb94
> Oct  2 12:16:55 jo kernel: [<ffffffff812eebc2>] 0xffffffff812eebc2
> Oct  2 12:16:55 jo kernel: [<ffffffff812ece41>] 0xffffffff812ece41
> Oct  2 12:16:55 jo kernel: [<ffffffffa04468b0>] 0xffffffffa04468b0
> Oct  2 12:16:55 jo kernel: [<ffffffffa0448bd0>] 0xffffffffa0448bd0
> Oct  2 12:16:55 jo kernel: [<ffffffff8146f884>] ? 0xffffffff8146f884
> Oct  2 12:16:55 jo kernel: [<ffffffff813cd2c3>] 0xffffffff813cd2c3
> Oct  2 12:16:55 jo kernel: [<ffffffff810443b5>] ? 0xffffffff810443b5
> Oct  2 12:16:55 jo kernel: [<ffffffff813cd1d2>] ? 0xffffffff813cd1d2
> Oct  2 12:16:55 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:16:55 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:16:55 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:16:55 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:16:55 jo kernel: Code: 00 48 89 e5 b8 02 00 00 00 66 83 fa 03 74 09 31 c0 66 83 fa 01 0f 94 c0 48 8b 96 c8 00 00 00 48 85 d2 75 04 0f 0b eb fe 8b 52 10 <85> d2 75 04 0f 0b eb fe 83 f8 02 74 28 8b 46 04 a8 20 74 15 48
> Oct  2 12:16:55 jo kernel: Call Trace:
> Oct  2 12:16:55 jo kernel: [<ffffffff812fab19>] 0xffffffff812fab19
> Oct  2 12:16:55 jo kernel: [<ffffffff812ee214>] 0xffffffff812ee214
> Oct  2 12:16:55 jo kernel: [<ffffffff812fdda7>] ? 0xffffffff812fdda7
> Oct  2 12:16:55 jo kernel: [<ffffffff813a5a01>] 0xffffffff813a5a01
> Oct  2 12:16:55 jo kernel: [<ffffffff8103af84>] ? 0xffffffff8103af84
> Oct  2 12:16:55 jo kernel: [<ffffffff812eeb94>] 0xffffffff812eeb94
> Oct  2 12:16:55 jo kernel: [<ffffffff812eebc2>] 0xffffffff812eebc2
> Oct  2 12:16:55 jo kernel: [<ffffffff812ece41>] 0xffffffff812ece41
> Oct  2 12:16:55 jo kernel: [<ffffffffa04468b0>] 0xffffffffa04468b0
> Oct  2 12:16:55 jo kernel: [<ffffffffa0448bd0>] 0xffffffffa0448bd0
> Oct  2 12:16:55 jo kernel: [<ffffffff8146f884>] ? 0xffffffff8146f884
> Oct  2 12:16:55 jo kernel: [<ffffffff813cd2c3>] 0xffffffff813cd2c3
> Oct  2 12:16:55 jo kernel: [<ffffffff810443b5>] ? 0xffffffff810443b5
> Oct  2 12:16:55 jo kernel: [<ffffffff813cd1d2>] ? 0xffffffff813cd1d2
> Oct  2 12:16:55 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:16:55 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:16:55 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:16:55 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:16:55 jo kernel: Pid: 14616, comm: md5_raid6 Not tainted 2.6.35-gentoo-r9 #1
> Oct  2 12:16:55 jo kernel: Call Trace:
> Oct  2 12:16:55 jo kernel: <NMI>  [<ffffffff8100a31c>] ? 0xffffffff8100a31c
> Oct  2 12:16:55 jo kernel: [<ffffffff810187b7>] 0xffffffff810187b7
> Oct  2 12:16:55 jo kernel: [<ffffffff8100446e>] 0xffffffff8100446e
> Oct  2 12:16:55 jo kernel: [<ffffffff8147197a>] 0xffffffff8147197a
> Oct  2 12:16:55 jo kernel: [<ffffffff812f7e19>] ? 0xffffffff812f7e19
> Oct  2 12:16:55 jo kernel: <<EOE>>  [<ffffffff812fab19>] 0xffffffff812fab19
> Oct  2 12:16:55 jo kernel: [<ffffffff812ee214>] 0xffffffff812ee214
> Oct  2 12:16:55 jo kernel: [<ffffffff812fdda7>] ? 0xffffffff812fdda7
> Oct  2 12:16:55 jo kernel: [<ffffffff813a5a01>] 0xffffffff813a5a01
> Oct  2 12:16:55 jo kernel: [<ffffffff8103af84>] ? 0xffffffff8103af84
> Oct  2 12:16:55 jo kernel: [<ffffffff812eeb94>] 0xffffffff812eeb94
> Oct  2 12:16:55 jo kernel: [<ffffffff812eebc2>] 0xffffffff812eebc2
> Oct  2 12:16:55 jo kernel: [<ffffffff812ece41>] 0xffffffff812ece41
> Oct  2 12:16:55 jo kernel: [<ffffffffa04468b0>] 0xffffffffa04468b0
> Oct  2 12:16:55 jo kernel: [<ffffffffa0448bd0>] 0xffffffffa0448bd0
> Oct  2 12:16:55 jo kernel: [<ffffffff8146f884>] ? 0xffffffff8146f884
> Oct  2 12:16:55 jo kernel: [<ffffffff813cd2c3>] 0xffffffff813cd2c3
> Oct  2 12:16:55 jo kernel: [<ffffffff810443b5>] ? 0xffffffff810443b5
> Oct  2 12:16:55 jo kernel: [<ffffffff813cd1d2>] ? 0xffffffff813cd1d2
> Oct  2 12:16:55 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:16:55 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:16:55 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:16:55 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:16:55 jo kernel: NMI backtrace for cpu 0
> Oct  2 12:16:55 jo kernel: CPU 0
> Oct  2 12:16:55 jo kernel: Modules linked in: tun ipv6 8021q iptable_raw iptable_mangle iptable_filter ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables x_tables rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core pcspkr processor snd_hda_codec_via snd_hda_intel atl1e snd_hda_codec thermal thermal_sys snd_hwdep snd_pcm snd_timer snd snd_page_alloc intel_agp button libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd 
 usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia firmware_class pcmcia_core pata_ns87415 pat
 a_ns87410 pata_serverworks pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata [last unloaded: microcode]
> Oct  2 12:16:55 jo kernel:
> Oct  2 12:16:55 jo kernel: Pid: 23272, comm: btrfs-endio-wri Not tainted 2.6.35-gentoo-r9 #1 P5Q PRO TURBO/System Product Name
> Oct  2 12:16:55 jo kernel: RIP: 0010:[<ffffffff812948b0>]  [<ffffffff812948b0>] 0xffffffff812948b0
> Oct  2 12:16:55 jo kernel: RSP: 0018:ffff8800df86ba10  EFLAGS: 00010286
> Oct  2 12:16:55 jo kernel: RAX: ffffea00038a90d8 RBX: ffff8800981032e0 RCX: 000000000000044c
> Oct  2 12:16:55 jo kernel: RDX: ffff8800df86a000 RSI: ffff88010304dbb4 RDI: ffff88010304dbb0
> Oct  2 12:16:55 jo kernel: RBP: ffff8800df86ba80 R08: 00000000000003c8 R09: 0000000000000000
> Oct  2 12:16:55 jo kernel: R10: ffff88010304d3c8 R11: 6db6db6db6db6db7 R12: 00000000000003cc
> Oct  2 12:16:55 jo kernel: R13: 0000000000000c34 R14: ffff8800df86a000 R15: ffffea00038a90d8
> Oct  2 12:16:55 jo kernel: FS:  0000000000000000(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
> Oct  2 12:16:55 jo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct  2 12:16:55 jo kernel: CR2: 0000000000749f44 CR3: 000000011acee000 CR4: 00000000000006f0
> Oct  2 12:16:55 jo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  2 12:16:55 jo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  2 12:16:55 jo kernel: Process btrfs-endio-wri (pid: 23272, threadinfo ffff8800df86a000, task ffff88011e0a4090)
> Oct  2 12:16:55 jo kernel: Stack:
> Oct  2 12:16:55 jo kernel: ffff8800df86bac8 ffff8800df86bac0 ffff8800df86bad0 0000000000000000
> Oct  2 12:16:55 jo kernel: <0> ffff8800df86ba90 00000000000003c8 00000000000003cc 0000000000000c34
> Oct  2 12:16:55 jo kernel: <0> ffff8800981032e0 0000000000000c34 ffff8800981032e0 0000000000000001
> Oct  2 12:16:55 jo kernel: Call Trace:
> Oct  2 12:16:55 jo kernel: [<ffffffff8129499b>] 0xffffffff8129499b
> Oct  2 12:16:55 jo kernel: [<ffffffff81294e48>] ? 0xffffffff81294e48
> Oct  2 12:16:55 jo kernel: [<ffffffff81263a3c>] 0xffffffff81263a3c
> Oct  2 12:16:55 jo kernel: [<ffffffff81275acd>] 0xffffffff81275acd
> Oct  2 12:16:55 jo kernel: [<ffffffff8147150e>] ? 0xffffffff8147150e
> Oct  2 12:16:55 jo kernel: [<ffffffff8127e9ef>] 0xffffffff8127e9ef
> Oct  2 12:16:55 jo kernel: [<ffffffff81286a49>] 0xffffffff81286a49
> Oct  2 12:16:55 jo kernel: [<ffffffff81083406>] ? 0xffffffff81083406
> Oct  2 12:16:55 jo kernel: [<ffffffff81286ac5>] 0xffffffff81286ac5
> Oct  2 12:16:55 jo kernel: [<ffffffff812976c4>] 0xffffffff812976c4
> Oct  2 12:16:55 jo kernel: [<ffffffff810c836a>] 0xffffffff810c836a
> Oct  2 12:16:55 jo kernel: [<ffffffff81279478>] 0xffffffff81279478
> Oct  2 12:16:55 jo kernel: [<ffffffff8103af90>] ? 0xffffffff8103af90
> Oct  2 12:16:55 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:16:55 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:16:55 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:16:55 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:16:55 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:16:55 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:16:55 jo kernel: Code: db b6 6d 48 c1 fe 03 48 0f af f1 48 b9 00 00 00 00 00 88 ff ff 48 c1 e6 0c 48 01 ce 4c 03 55 b8 48 03 75 c0 48 8b 4d c8 4c 89 d7 <f3> a4 ff 4a 1c 4c 39 f8 74 03 ff 4a 1c 4c 03 65 c8 4c 03 45 c8
> Oct  2 12:16:55 jo kernel: Call Trace:
> Oct  2 12:16:55 jo kernel: [<ffffffff8129499b>] 0xffffffff8129499b
> Oct  2 12:16:55 jo kernel: [<ffffffff81294e48>] ? 0xffffffff81294e48
> Oct  2 12:16:55 jo kernel: [<ffffffff81263a3c>] 0xffffffff81263a3c
> Oct  2 12:16:55 jo kernel: [<ffffffff81275acd>] 0xffffffff81275acd
> Oct  2 12:16:55 jo kernel: [<ffffffff8147150e>] ? 0xffffffff8147150e
> Oct  2 12:16:55 jo kernel: [<ffffffff8127e9ef>] 0xffffffff8127e9ef
> Oct  2 12:16:55 jo kernel: [<ffffffff81286a49>] 0xffffffff81286a49
> Oct  2 12:16:55 jo kernel: [<ffffffff81083406>] ? 0xffffffff81083406
> Oct  2 12:16:55 jo kernel: [<ffffffff81286ac5>] 0xffffffff81286ac5
> Oct  2 12:16:55 jo kernel: [<ffffffff812976c4>] 0xffffffff812976c4
> Oct  2 12:16:55 jo kernel: [<ffffffff810c836a>] 0xffffffff810c836a
> Oct  2 12:16:55 jo kernel: [<ffffffff81279478>] 0xffffffff81279478
> Oct  2 12:16:55 jo kernel: [<ffffffff8103af90>] ? 0xffffffff8103af90
> Oct  2 12:16:55 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:16:55 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:16:55 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:16:55 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:16:55 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:16:55 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:16:55 jo kernel: Pid: 23272, comm: btrfs-endio-wri Not tainted 2.6.35-gentoo-r9 #1
> Oct  2 12:16:55 jo kernel: Call Trace:
> Oct  2 12:16:55 jo kernel: <NMI>  [<ffffffff8100a31c>] ? 0xffffffff8100a31c
> Oct  2 12:16:55 jo kernel: [<ffffffff810187b7>] 0xffffffff810187b7
> Oct  2 12:16:55 jo kernel: [<ffffffff8100446e>] 0xffffffff8100446e
> Oct  2 12:16:55 jo kernel: [<ffffffff8147197a>] 0xffffffff8147197a
> Oct  2 12:16:55 jo kernel: [<ffffffff812948b0>] ? 0xffffffff812948b0
> Oct  2 12:16:55 jo kernel: <<EOE>>  [<ffffffff8129499b>] 0xffffffff8129499b
> Oct  2 12:16:55 jo kernel: [<ffffffff81294e48>] ? 0xffffffff81294e48
> Oct  2 12:16:55 jo kernel: [<ffffffff81263a3c>] 0xffffffff81263a3c
> Oct  2 12:16:55 jo kernel: [<ffffffff81275acd>] 0xffffffff81275acd
> Oct  2 12:16:55 jo kernel: [<ffffffff8147150e>] ? 0xffffffff8147150e
> Oct  2 12:16:55 jo kernel: [<ffffffff8127e9ef>] 0xffffffff8127e9ef
> Oct  2 12:16:55 jo kernel: [<ffffffff81286a49>] 0xffffffff81286a49
> Oct  2 12:16:55 jo kernel: [<ffffffff81083406>] ? 0xffffffff81083406
> Oct  2 12:16:55 jo kernel: [<ffffffff81286ac5>] 0xffffffff81286ac5
> Oct  2 12:16:55 jo kernel: [<ffffffff812976c4>] 0xffffffff812976c4
> Oct  2 12:16:55 jo kernel: [<ffffffff810c836a>] 0xffffffff810c836a
> Oct  2 12:16:55 jo kernel: [<ffffffff81279478>] 0xffffffff81279478
> Oct  2 12:16:55 jo kernel: [<ffffffff8103af90>] ? 0xffffffff8103af90
> Oct  2 12:16:55 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:16:55 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:16:55 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:16:55 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:16:55 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:16:55 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:16:55 jo kernel: NMI backtrace for cpu 1
> Oct  2 12:16:55 jo kernel: CPU 1
> Oct  2 12:16:55 jo kernel: Modules linked in: tun ipv6 8021q iptable_raw iptable_mangle iptable_filter ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables x_tables rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core pcspkr processor snd_hda_codec_via snd_hda_intel atl1e snd_hda_codec thermal thermal_sys snd_hwdep snd_pcm snd_timer snd snd_page_alloc intel_agp button libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd 
 usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia firmware_class pcmcia_core pata_ns87415 pat
 a_ns87410 pata_serverworks pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata [last unloaded: microcode]
> Oct  2 12:16:55 jo kernel:
> Oct  2 12:16:55 jo kernel: Pid: 0, comm: swapper Not tainted 2.6.35-gentoo-r9 #1 P5Q PRO TURBO/System Product Name
> Oct  2 12:16:55 jo kernel: RIP: 0010:[<ffffffff81009d68>]  [<ffffffff81009d68>] 0xffffffff81009d68
> Oct  2 12:16:55 jo kernel: RSP: 0018:ffff88011fcbbf08  EFLAGS: 00000246
> Oct  2 12:16:55 jo kernel: RAX: 0000000000000000 RBX: ffffffff81607680 RCX: 0000000000000000
> Oct  2 12:16:55 jo kernel: RDX: 0000000000000000 RSI: ffff88011fcbbfd8 RDI: ffffffff81683308
> Oct  2 12:16:55 jo kernel: RBP: ffff88011fcbbf08 R08: 0000000000000000 R09: 0000000000000078
> Oct  2 12:16:55 jo kernel: R10: ffff88011fe56cf0 R11: 0000000000000003 R12: ffff88011fcbbfd8
> Oct  2 12:16:55 jo kernel: R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> Oct  2 12:16:55 jo kernel: FS:  0000000000000000(0000) GS:ffff880001880000(0000) knlGS:0000000000000000
> Oct  2 12:16:55 jo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct  2 12:16:55 jo kernel: CR2: 00000000007fd2d0 CR3: 00000001072d0000 CR4: 00000000000006e0
> Oct  2 12:16:55 jo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  2 12:16:55 jo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  2 12:16:55 jo kernel: Process swapper (pid: 0, threadinfo ffff88011fcba000, task ffff88011fcac6a0)
> Oct  2 12:16:55 jo kernel: Stack:
> Oct  2 12:16:55 jo kernel: ffff88011fcbbf28 ffffffff81001bcf 0000000000000001 0000000000000000
> Oct  2 12:16:55 jo kernel: <0> ffff88011fcbbf48 ffffffff8146c288 563dcf676bf8ea76 0000000000000000
> Oct  2 12:16:55 jo kernel: <0> 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> Oct  2 12:16:55 jo kernel: Call Trace:
> Oct  2 12:16:55 jo kernel: [<ffffffff81001bcf>] 0xffffffff81001bcf
> Oct  2 12:16:55 jo kernel: [<ffffffff8146c288>] 0xffffffff8146c288
> Oct  2 12:16:55 jo kernel: Code: 48 8b 34 25 48 b5 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 31 c0 fb 0f 01 c9 <eb> 01 fb c9 c3 55 48 89 e5 65 48 8b 14 25 48 b5 00 00 48 8b 82
> Oct  2 12:16:55 jo kernel: Call Trace:
> Oct  2 12:16:55 jo kernel: [<ffffffff81001bcf>] 0xffffffff81001bcf
> Oct  2 12:16:55 jo kernel: [<ffffffff8146c288>] 0xffffffff8146c288
> Oct  2 12:16:55 jo kernel: Pid: 0, comm: swapper Not tainted 2.6.35-gentoo-r9 #1
> Oct  2 12:16:55 jo kernel: Call Trace:
> Oct  2 12:16:55 jo kernel: <NMI>  [<ffffffff8100a31c>] ? 0xffffffff8100a31c
> Oct  2 12:16:55 jo kernel: [<ffffffff810187b7>] 0xffffffff810187b7
> Oct  2 12:16:55 jo kernel: [<ffffffff8100446e>] 0xffffffff8100446e
> Oct  2 12:16:55 jo kernel: [<ffffffff8147197a>] 0xffffffff8147197a
> Oct  2 12:16:55 jo kernel: [<ffffffff81009d68>] ? 0xffffffff81009d68
> Oct  2 12:16:55 jo kernel: <<EOE>>  [<ffffffff81001bcf>] 0xffffffff81001bcf
> Oct  2 12:16:55 jo kernel: [<ffffffff8146c288>] 0xffffffff8146c288
> Oct  2 12:19:15 jo kernel: INFO: rcu_sched_state detected stall on CPU 3 (t=1000 jiffies)
> Oct  2 12:19:15 jo kernel: sending NMI to all CPUs:
> Oct  2 12:19:15 jo kernel: NMI backtrace for cpu 2
> Oct  2 12:19:15 jo kernel: CPU 2
> Oct  2 12:19:15 jo kernel: Modules linked in: tun ipv6 8021q iptable_raw iptable_mangle iptable_filter ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables x_tables rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core pcspkr processor snd_hda_codec_via snd_hda_intel atl1e snd_hda_codec thermal thermal_sys snd_hwdep snd_pcm snd_timer snd snd_page_alloc intel_agp button libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd 
 usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia firmware_class pcmcia_core pata_ns87415 pat
 a_ns87410 pata_serverworks pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata [last unloaded: microcode]
> Oct  2 12:19:15 jo kernel:
> Oct  2 12:19:15 jo kernel: Pid: 0, comm: swapper Not tainted 2.6.35-gentoo-r9 #1 P5Q PRO TURBO/System Product Name
> Oct  2 12:19:15 jo kernel: RIP: 0010:[<ffffffff81009d68>]  [<ffffffff81009d68>] 0xffffffff81009d68
> Oct  2 12:19:15 jo kernel: RSP: 0018:ffff88011fccbf08  EFLAGS: 00000246
> Oct  2 12:19:15 jo kernel: RAX: 0000000000000000 RBX: ffffffff81607680 RCX: 0000000000000000
> Oct  2 12:19:28 jo kernel: RDX: 0000000000000000 RSI: ffff88011fccbfd8 RDI: ffffffff81683308
> Oct  2 12:19:28 jo kernel: RBP: ffff88011fccbf08 R08: 0000000000000000 R09: 0000000000000001
> Oct  2 12:19:28 jo kernel: R10: ffff88011f46bd20 R11: ffff88011e2e3800 R12: ffff88011fccbfd8
> Oct  2 12:19:28 jo kernel: R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> Oct  2 12:19:28 jo kernel: FS:  0000000000000000(0000) GS:ffff880001900000(0000) knlGS:0000000000000000
> Oct  2 12:19:28 jo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct  2 12:19:28 jo kernel: CR2: 00007f18f0b2f000 CR3: 000000011e50e000 CR4: 00000000000006e0
> Oct  2 12:19:28 jo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  2 12:19:28 jo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  2 12:19:28 jo kernel: Process swapper (pid: 0, threadinfo ffff88011fcca000, task ffff88011fcbecf0)
> Oct  2 12:19:28 jo kernel: Stack:
> Oct  2 12:19:28 jo kernel: ffff88011fccbf28 ffffffff81001bcf 0000000000000002 0000000000000000
> Oct  2 12:19:28 jo kernel: <0> ffff88011fccbf48 ffffffff8146c288 3081aa158d48f824 0000000000000000
> Oct  2 12:19:28 jo kernel: <0> 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> Oct  2 12:19:28 jo kernel: Call Trace:
> Oct  2 12:19:28 jo kernel: [<ffffffff81001bcf>] 0xffffffff81001bcf
> Oct  2 12:19:28 jo kernel: [<ffffffff8146c288>] 0xffffffff8146c288
> Oct  2 12:19:28 jo kernel: Code: 48 8b 34 25 48 b5 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 31 c0 fb 0f 01 c9 <eb> 01 fb c9 c3 55 48 89 e5 65 48 8b 14 25 48 b5 00 00 48 8b 82
> Oct  2 12:19:28 jo kernel: Call Trace:
> Oct  2 12:19:28 jo kernel: [<ffffffff81001bcf>] 0xffffffff81001bcf
> Oct  2 12:19:28 jo kernel: [<ffffffff8146c288>] 0xffffffff8146c288
> Oct  2 12:19:28 jo kernel: Pid: 0, comm: swapper Not tainted 2.6.35-gentoo-r9 #1
> Oct  2 12:19:28 jo kernel: Call Trace:
> Oct  2 12:19:28 jo kernel: <NMI>  [<ffffffff8100a31c>] ? 0xffffffff8100a31c
> Oct  2 12:19:28 jo kernel: [<ffffffff810187b7>] 0xffffffff810187b7
> Oct  2 12:19:28 jo kernel: [<ffffffff8100446e>] 0xffffffff8100446e
> Oct  2 12:19:28 jo kernel: [<ffffffff8147197a>] 0xffffffff8147197a
> Oct  2 12:19:28 jo kernel: [<ffffffff81009d68>] ? 0xffffffff81009d68
> Oct  2 12:19:28 jo kernel: <<EOE>>  [<ffffffff81001bcf>] 0xffffffff81001bcf
> Oct  2 12:19:28 jo kernel: [<ffffffff8146c288>] 0xffffffff8146c288
> Oct  2 12:19:28 jo kernel: NMI backtrace for cpu 3
> Oct  2 12:19:28 jo kernel: CPU 3
> Oct  2 12:19:28 jo kernel: Modules linked in: tun ipv6 8021q iptable_raw iptable_mangle iptable_filter ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables x_tables rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core pcspkr processor snd_hda_codec_via snd_hda_intel atl1e snd_hda_codec thermal thermal_sys snd_hwdep snd_pcm snd_timer snd snd_page_alloc intel_agp button libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd 
 usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia firmware_class pcmcia_core pata_ns87415 pat
 a_ns87410 pata_serverworks pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata [last unloaded: microcode]
> Oct  2 12:19:28 jo kernel:
> Oct  2 12:19:28 jo kernel: Pid: 22695, comm: btrfs-worker-4 Not tainted 2.6.35-gentoo-r9 #1 P5Q PRO TURBO/System Product Name
> Oct  2 12:19:28 jo kernel: RIP: 0010:[<ffffffff81303c24>]  [<ffffffff81303c24>] 0xffffffff81303c24
> Oct  2 12:19:28 jo kernel: RSP: 0018:ffff880001983dd8  EFLAGS: 00000046
> Oct  2 12:19:28 jo kernel: RAX: 00000000dc35449f RBX: 0000000000000001 RCX: 00000000dc3543a3
> Oct  2 12:19:28 jo kernel: RDX: 0000000000000562 RSI: 0000000000000003 RDI: 0000000000249f7e
> Oct  2 12:19:28 jo kernel: RBP: ffff880001983dd8 R08: 0000000000000003 R09: 000000000000000a
> Oct  2 12:19:28 jo kernel: R10: 0000000000000003 R11: 0000000000000000 R12: ffff88000198e9b0
> Oct  2 12:19:28 jo kernel: R13: ffffffff815d3080 R14: ffff88000198e778 R15: ffff880001983f48
> Oct  2 12:19:28 jo kernel: FS:  0000000000000000(0000) GS:ffff880001980000(0000) knlGS:0000000000000000
> Oct  2 12:19:28 jo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct  2 12:19:28 jo kernel: CR2: 00007f18f0b2f000 CR3: 00000000015bf000 CR4: 00000000000006e0
> Oct  2 12:19:28 jo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  2 12:19:28 jo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  2 12:19:28 jo kernel: Process btrfs-worker-4 (pid: 22695, threadinfo ffff88004bc96000, task ffff88011fe04cb0)
> Oct  2 12:19:28 jo kernel: Stack:
> Oct  2 12:19:28 jo kernel: ffff880001983de8 ffffffff81303b55 ffff880001983df8 ffffffff81303b91
> Oct  2 12:19:28 jo kernel: <0> ffff880001983e18 ffffffff81018645 ffff88000198e778 ffffffff815d3080
> Oct  2 12:19:28 jo kernel: <0> ffff880001983e68 ffffffff81073786 ffff880001983e78 ffffffff8106f0e2
> Oct  2 12:19:28 jo kernel: Call Trace:
> Oct  2 12:19:28 jo kernel: <IRQ>
> Oct  2 12:19:28 jo kernel: [<ffffffff81303b55>] 0xffffffff81303b55
> Oct  2 12:19:28 jo kernel: [<ffffffff81303b91>] 0xffffffff81303b91
> Oct  2 12:19:28 jo kernel: [<ffffffff81018645>] 0xffffffff81018645
> Oct  2 12:19:28 jo kernel: [<ffffffff81073786>] 0xffffffff81073786
> Oct  2 12:19:28 jo kernel: [<ffffffff8106f0e2>] ? 0xffffffff8106f0e2
> Oct  2 12:19:28 jo kernel: [<ffffffff81073adc>] 0xffffffff81073adc
> Oct  2 12:19:28 jo kernel: [<ffffffff8103b064>] 0xffffffff8103b064
> Oct  2 12:19:28 jo kernel: [<ffffffff8104efb5>] 0xffffffff8104efb5
> Oct  2 12:19:28 jo kernel: [<ffffffff81046ba0>] 0xffffffff81046ba0
> Oct  2 12:19:28 jo kernel: [<ffffffff81046dea>] 0xffffffff81046dea
> Oct  2 12:19:28 jo kernel: [<ffffffff81018044>] 0xffffffff81018044
> Oct  2 12:19:28 jo kernel: [<ffffffff81003213>] 0xffffffff81003213
> Oct  2 12:19:28 jo kernel: <EOI>
> Oct  2 12:19:28 jo kernel: [<ffffffff812eb6a0>] ? 0xffffffff812eb6a0
> Oct  2 12:19:28 jo kernel: [<ffffffff812e5942>] 0xffffffff812e5942
> Oct  2 12:19:28 jo kernel: [<ffffffff81308097>] 0xffffffff81308097
> Oct  2 12:19:28 jo kernel: [<ffffffff812931d2>] ? 0xffffffff812931d2
> Oct  2 12:19:28 jo kernel: [<ffffffff81279494>] 0xffffffff81279494
> Oct  2 12:19:28 jo kernel: [<ffffffff8127640f>] 0xffffffff8127640f
> Oct  2 12:19:28 jo kernel: [<ffffffff8127f048>] 0xffffffff8127f048
> Oct  2 12:19:28 jo kernel: [<ffffffff812773b6>] 0xffffffff812773b6
> Oct  2 12:19:28 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:19:28 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:19:28 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:19:28 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:19:28 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:19:28 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:19:28 jo kernel: Code: f7 e2 48 8d 7a 01 e8 47 ff ff ff c9 c3 55 48 89 e5 65 8b 34 25 60 d3 00 00 0f 1f 00 0f ae e8 0f 31 89 c1 0f 1f 00 0f ae e8 0f 31 <89> c0 48 89 c2 48 29 ca 48 39 fa 73 25 f3 90 65 44 8b 04 25 60
> Oct  2 12:19:28 jo kernel: Call Trace:
> Oct  2 12:19:28 jo kernel: <IRQ>  [<ffffffff81303b55>] 0xffffffff81303b55
> Oct  2 12:19:28 jo kernel: [<ffffffff81303b91>] 0xffffffff81303b91
> Oct  2 12:19:28 jo kernel: [<ffffffff81018645>] 0xffffffff81018645
> Oct  2 12:19:28 jo kernel: [<ffffffff81073786>] 0xffffffff81073786
> Oct  2 12:19:28 jo kernel: [<ffffffff8106f0e2>] ? 0xffffffff8106f0e2
> Oct  2 12:19:28 jo kernel: [<ffffffff81073adc>] 0xffffffff81073adc
> Oct  2 12:19:28 jo kernel: [<ffffffff8103b064>] 0xffffffff8103b064
> Oct  2 12:19:28 jo kernel: [<ffffffff8104efb5>] 0xffffffff8104efb5
> Oct  2 12:19:28 jo kernel: [<ffffffff81046ba0>] 0xffffffff81046ba0
> Oct  2 12:19:28 jo kernel: [<ffffffff81046dea>] 0xffffffff81046dea
> Oct  2 12:19:28 jo kernel: [<ffffffff81018044>] 0xffffffff81018044
> Oct  2 12:19:28 jo kernel: [<ffffffff81003213>] 0xffffffff81003213
> Oct  2 12:19:28 jo kernel: <EOI>  [<ffffffff812eb6a0>] ? 0xffffffff812eb6a0
> Oct  2 12:19:28 jo kernel: [<ffffffff812e5942>] 0xffffffff812e5942
> Oct  2 12:19:28 jo kernel: [<ffffffff81308097>] 0xffffffff81308097
> Oct  2 12:19:28 jo kernel: [<ffffffff812931d2>] ? 0xffffffff812931d2
> Oct  2 12:19:28 jo kernel: [<ffffffff81279494>] 0xffffffff81279494
> Oct  2 12:19:28 jo kernel: [<ffffffff8127640f>] 0xffffffff8127640f
> Oct  2 12:19:28 jo kernel: [<ffffffff8127f048>] 0xffffffff8127f048
> Oct  2 12:19:28 jo kernel: [<ffffffff812773b6>] 0xffffffff812773b6
> Oct  2 12:19:28 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:19:28 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:19:28 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:19:28 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:19:28 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:19:28 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:19:28 jo kernel: Pid: 22695, comm: btrfs-worker-4 Not tainted 2.6.35-gentoo-r9 #1
> Oct  2 12:19:28 jo kernel: Call Trace:
> Oct  2 12:19:28 jo kernel: <NMI>  [<ffffffff8100a31c>] ? 0xffffffff8100a31c
> Oct  2 12:19:28 jo kernel: [<ffffffff810187b7>] 0xffffffff810187b7
> Oct  2 12:19:28 jo kernel: [<ffffffff8100446e>] 0xffffffff8100446e
> Oct  2 12:19:28 jo kernel: [<ffffffff8147197a>] 0xffffffff8147197a
> Oct  2 12:19:28 jo kernel: [<ffffffff81303c24>] ? 0xffffffff81303c24
> Oct  2 12:19:28 jo kernel: <<EOE>> <IRQ>  [<ffffffff81303b55>] 0xffffffff81303b55
> Oct  2 12:19:28 jo kernel: [<ffffffff81303b91>] 0xffffffff81303b91
> Oct  2 12:19:28 jo kernel: [<ffffffff81018645>] 0xffffffff81018645
> Oct  2 12:19:28 jo kernel: [<ffffffff81073786>] 0xffffffff81073786
> Oct  2 12:19:28 jo kernel: [<ffffffff8106f0e2>] ? 0xffffffff8106f0e2
> Oct  2 12:19:28 jo kernel: [<ffffffff81073adc>] 0xffffffff81073adc
> Oct  2 12:19:28 jo kernel: [<ffffffff8103b064>] 0xffffffff8103b064
> Oct  2 12:19:28 jo kernel: [<ffffffff8104efb5>] 0xffffffff8104efb5
> Oct  2 12:19:28 jo kernel: [<ffffffff81046ba0>] 0xffffffff81046ba0
> Oct  2 12:19:28 jo kernel: [<ffffffff81046dea>] 0xffffffff81046dea
> Oct  2 12:19:28 jo kernel: [<ffffffff81018044>] 0xffffffff81018044
> Oct  2 12:19:28 jo kernel: [<ffffffff81003213>] 0xffffffff81003213
> Oct  2 12:19:28 jo kernel: <EOI>  [<ffffffff812eb6a0>] ? 0xffffffff812eb6a0
> Oct  2 12:19:28 jo kernel: [<ffffffff812e5942>] 0xffffffff812e5942
> Oct  2 12:19:28 jo kernel: [<ffffffff81308097>] 0xffffffff81308097
> Oct  2 12:19:28 jo kernel: [<ffffffff812931d2>] ? 0xffffffff812931d2
> Oct  2 12:19:28 jo kernel: [<ffffffff81279494>] 0xffffffff81279494
> Oct  2 12:19:28 jo kernel: [<ffffffff8127640f>] 0xffffffff8127640f
> Oct  2 12:19:28 jo kernel: [<ffffffff8127f048>] 0xffffffff8127f048
> Oct  2 12:19:28 jo kernel: [<ffffffff812773b6>] 0xffffffff812773b6
> Oct  2 12:19:28 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:19:28 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:19:28 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:19:28 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:19:28 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:19:28 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:19:28 jo kernel: NMI backtrace for cpu 1
> Oct  2 12:19:28 jo kernel: CPU 1
> Oct  2 12:19:28 jo kernel: Modules linked in: tun ipv6 8021q iptable_raw iptable_mangle iptable_filter ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables x_tables rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core pcspkr processor snd_hda_codec_via snd_hda_intel atl1e snd_hda_codec thermal thermal_sys snd_hwdep snd_pcm snd_timer snd snd_page_alloc intel_agp button libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd 
 usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia firmware_class pcmcia_core pata_ns87415 pat
 a_ns87410 pata_serverworks pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata [last unloaded: microcode]
> Oct  2 12:19:28 jo kernel:
> Oct  2 12:19:28 jo kernel: Pid: 23272, comm: btrfs-endio-wri Not tainted 2.6.35-gentoo-r9 #1 P5Q PRO TURBO/System Product Name
> Oct  2 12:19:28 jo kernel: RIP: 0010:[<ffffffff81295eb7>]  [<ffffffff81295eb7>] 0xffffffff81295eb7
> Oct  2 12:19:28 jo kernel: RSP: 0018:ffff8800df86b980  EFLAGS: 00000206
> Oct  2 12:19:28 jo kernel: RAX: ffff88007f62adb8 RBX: ffff8800bfea4c18 RCX: ffff88007f62adb8
> Oct  2 12:19:28 jo kernel: RDX: ffff88007f62ada8 RSI: 0000000001ff4000 RDI: ffff88007f62ae38
> Oct  2 12:19:28 jo kernel: RBP: ffff8800df86b9c0 R08: 0000000000000001 R09: 0000000000000000
> Oct  2 12:19:28 jo kernel: R10: ffff8800df86b9e0 R11: 6db6db6db6db6db7 R12: 0000000001ff4000
> Oct  2 12:19:28 jo kernel: R13: 0000000001ff4fff R14: 0000000000000004 R15: 0000000000000001
> Oct  2 12:19:28 jo kernel: FS:  0000000000000000(0000) GS:ffff880001880000(0000) knlGS:0000000000000000
> Oct  2 12:19:28 jo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct  2 12:19:28 jo kernel: CR2: 00007f18f0b2f000 CR3: 00000001072d0000 CR4: 00000000000006e0
> Oct  2 12:19:28 jo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  2 12:19:28 jo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  2 12:19:28 jo kernel: Process btrfs-endio-wri (pid: 23272, threadinfo ffff8800df86a000, task ffff88011e0a4090)
> Oct  2 12:19:28 jo kernel: Stack:
> Oct  2 12:19:28 jo kernel: 0000000000000000 0000000000000000 0000000000000dee ffff8800454cfd00
> Oct  2 12:19:28 jo kernel: <0> ffff8800bfea4c18 0000000000000028 0000000000000dee ffff8800690747f0
> Oct  2 12:19:28 jo kernel: <0> ffff8800df86b9f0 ffffffff81295fff ffff8800454cfd00 ffff8800bfea4c18
> Oct  2 12:19:28 jo kernel: Call Trace:
> Oct  2 12:19:28 jo kernel: [<ffffffff81295fff>] 0xffffffff81295fff
> Oct  2 12:19:28 jo kernel: [<ffffffff81277803>] 0xffffffff81277803
> Oct  2 12:19:28 jo kernel: [<ffffffff812610c0>] 0xffffffff812610c0
> Oct  2 12:19:28 jo kernel: [<ffffffff81268296>] 0xffffffff81268296
> Oct  2 12:19:28 jo kernel: [<ffffffff81275988>] 0xffffffff81275988
> Oct  2 12:19:28 jo kernel: [<ffffffff8127e9ef>] 0xffffffff8127e9ef
> Oct  2 12:19:28 jo kernel: [<ffffffff81286a49>] 0xffffffff81286a49
> Oct  2 12:19:28 jo kernel: [<ffffffff81083406>] ? 0xffffffff81083406
> Oct  2 12:19:28 jo kernel: [<ffffffff81286ac5>] 0xffffffff81286ac5
> Oct  2 12:19:28 jo kernel: [<ffffffff812976c4>] 0xffffffff812976c4
> Oct  2 12:19:28 jo kernel: [<ffffffff810c836a>] 0xffffffff810c836a
> Oct  2 12:19:28 jo kernel: [<ffffffff81279478>] 0xffffffff81279478
> Oct  2 12:19:28 jo kernel: [<ffffffff8103af90>] ? 0xffffffff8103af90
> Oct  2 12:19:28 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:19:28 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:19:28 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:19:28 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:19:28 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:19:28 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:19:28 jo kernel: Code: c9 74 17 49 83 79 28 00 74 10 49 8b 11 49 8d 41 10 4c 39 e2 0f 84 b9 00 00 00 48 8b 03 31 d2 31 ff eb 24 48 8d 50 f0 4c 3b 60 f0 <73> 06 48 8b 48 10 eb 0e 4c 3b 60 f8 0f 86 93 00 00 00 48 8b 48
> Oct  2 12:19:28 jo kernel: Call Trace:
> Oct  2 12:19:28 jo kernel: [<ffffffff81295fff>] 0xffffffff81295fff
> Oct  2 12:19:28 jo kernel: [<ffffffff81277803>] 0xffffffff81277803
> Oct  2 12:19:28 jo kernel: [<ffffffff812610c0>] 0xffffffff812610c0
> Oct  2 12:19:28 jo kernel: [<ffffffff81268296>] 0xffffffff81268296
> Oct  2 12:19:28 jo kernel: [<ffffffff81275988>] 0xffffffff81275988
> Oct  2 12:19:28 jo kernel: [<ffffffff8127e9ef>] 0xffffffff8127e9ef
> Oct  2 12:19:28 jo kernel: [<ffffffff81286a49>] 0xffffffff81286a49
> Oct  2 12:19:28 jo kernel: [<ffffffff81083406>] ? 0xffffffff81083406
> Oct  2 12:19:28 jo kernel: [<ffffffff81286ac5>] 0xffffffff81286ac5
> Oct  2 12:19:28 jo kernel: [<ffffffff812976c4>] 0xffffffff812976c4
> Oct  2 12:19:28 jo kernel: [<ffffffff810c836a>] 0xffffffff810c836a
> Oct  2 12:19:28 jo kernel: [<ffffffff81279478>] 0xffffffff81279478
> Oct  2 12:19:28 jo kernel: [<ffffffff8103af90>] ? 0xffffffff8103af90
> Oct  2 12:19:28 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:19:28 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:19:28 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:19:28 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:19:28 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:19:28 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:19:28 jo kernel: Pid: 23272, comm: btrfs-endio-wri Not tainted 2.6.35-gentoo-r9 #1
> Oct  2 12:19:28 jo kernel: Call Trace:
> Oct  2 12:19:28 jo kernel: <NMI>  [<ffffffff8100a31c>] ? 0xffffffff8100a31c
> Oct  2 12:19:28 jo kernel: [<ffffffff810187b7>] 0xffffffff810187b7
> Oct  2 12:19:28 jo kernel: [<ffffffff8100446e>] 0xffffffff8100446e
> Oct  2 12:19:28 jo kernel: [<ffffffff8147197a>] 0xffffffff8147197a
> Oct  2 12:19:28 jo kernel: [<ffffffff81295eb7>] ? 0xffffffff81295eb7
> Oct  2 12:19:28 jo kernel: <<EOE>>  [<ffffffff81295fff>] 0xffffffff81295fff
> Oct  2 12:19:28 jo kernel: [<ffffffff81277803>] 0xffffffff81277803
> Oct  2 12:19:28 jo kernel: [<ffffffff812610c0>] 0xffffffff812610c0
> Oct  2 12:19:28 jo kernel: [<ffffffff81268296>] 0xffffffff81268296
> Oct  2 12:19:28 jo kernel: [<ffffffff81275988>] 0xffffffff81275988
> Oct  2 12:19:28 jo kernel: [<ffffffff8127e9ef>] 0xffffffff8127e9ef
> Oct  2 12:19:28 jo kernel: [<ffffffff81286a49>] 0xffffffff81286a49
> Oct  2 12:19:28 jo kernel: [<ffffffff81083406>] ? 0xffffffff81083406
> Oct  2 12:19:28 jo kernel: [<ffffffff81286ac5>] 0xffffffff81286ac5
> Oct  2 12:19:28 jo kernel: [<ffffffff812976c4>] 0xffffffff812976c4
> Oct  2 12:19:28 jo kernel: [<ffffffff810c836a>] 0xffffffff810c836a
> Oct  2 12:19:28 jo kernel: [<ffffffff81279478>] 0xffffffff81279478
> Oct  2 12:19:28 jo kernel: [<ffffffff8103af90>] ? 0xffffffff8103af90
> Oct  2 12:19:28 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:19:28 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:19:28 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:19:28 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:19:28 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:19:28 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:19:28 jo kernel: NMI backtrace for cpu 0
> Oct  2 12:19:28 jo kernel: CPU 0
> Oct  2 12:19:28 jo kernel: Modules linked in: tun ipv6 8021q iptable_raw iptable_mangle iptable_filter ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables x_tables rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core pcspkr processor snd_hda_codec_via snd_hda_intel atl1e snd_hda_codec thermal thermal_sys snd_hwdep snd_pcm snd_timer snd snd_page_alloc intel_agp button libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd 
 usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia firmware_class pcmcia_core pata_ns87415 pat
 a_ns87410 pata_serverworks pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata [last unloaded: microcode]
> Oct  2 12:19:28 jo kernel:
> Oct  2 12:19:28 jo kernel: Pid: 0, comm: swapper Not tainted 2.6.35-gentoo-r9 #1 P5Q PRO TURBO/System Product Name
> Oct  2 12:19:28 jo kernel: RIP: 0010:[<ffffffff81009d68>]  [<ffffffff81009d68>] 0xffffffff81009d68
> Oct  2 12:19:28 jo kernel: RSP: 0018:ffffffff81581f28  EFLAGS: 00000246
> Oct  2 12:19:28 jo kernel: RAX: 0000000000000000 RBX: ffffffff81607680 RCX: 0000000000000000
> Oct  2 12:19:28 jo kernel: RDX: 0000000000000000 RSI: ffffffff81581fd8 RDI: ffffffff81683308
> Oct  2 12:19:28 jo kernel: RBP: ffffffff81581f28 R08: 0000000000000000 R09: 0000000000000078
> Oct  2 12:19:28 jo kernel: R10: ffff88011fe56cf0 R11: 0000000000000003 R12: ffffffff81581fd8
> Oct  2 12:19:28 jo kernel: R13: 0000000000000000 R14: ffffffffffffffff R15: 0000000000000000
> Oct  2 12:19:28 jo kernel: FS:  0000000000000000(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
> Oct  2 12:19:28 jo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct  2 12:19:28 jo kernel: CR2: 00007f971b171000 CR3: 00000001072d0000 CR4: 00000000000006f0
> Oct  2 12:19:28 jo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  2 12:19:28 jo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  2 12:19:28 jo kernel: Process swapper (pid: 0, threadinfo ffffffff81580000, task ffffffff815c7020)
> Oct  2 12:19:28 jo kernel: Stack:
> Oct  2 12:19:28 jo kernel: ffffffff81581f48 ffffffff81001bcf 0000000000000000 6db6db6db6db6db7
> Oct  2 12:19:28 jo kernel: <0> ffffffff81581f58 ffffffff8145e61c ffffffff81581f98 ffffffff8161eccb
> Oct  2 12:19:28 jo kernel: <0> ffffffff81581f98 ffffffff81654060 0000000001749dc4 0000000000000000
> Oct  2 12:19:28 jo kernel: Call Trace:
> Oct  2 12:19:28 jo kernel: [<ffffffff81001bcf>] 0xffffffff81001bcf
> Oct  2 12:19:28 jo kernel: [<ffffffff8145e61c>] 0xffffffff8145e61c
> Oct  2 12:19:28 jo kernel: [<ffffffff8161eccb>] 0xffffffff8161eccb
> Oct  2 12:19:28 jo kernel: [<ffffffff8161e293>] 0xffffffff8161e293
> Oct  2 12:19:28 jo kernel: [<ffffffff8161e37b>] 0xffffffff8161e37b
> Oct  2 12:19:28 jo kernel: Code: 48 8b 34 25 48 b5 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 31 c0 fb 0f 01 c9 <eb> 01 fb c9 c3 55 48 89 e5 65 48 8b 14 25 48 b5 00 00 48 8b 82
> Oct  2 12:19:28 jo kernel: Call Trace:
> Oct  2 12:19:28 jo kernel: [<ffffffff81001bcf>] 0xffffffff81001bcf
> Oct  2 12:19:28 jo kernel: [<ffffffff8145e61c>] 0xffffffff8145e61c
> Oct  2 12:19:28 jo kernel: [<ffffffff8161eccb>] 0xffffffff8161eccb
> Oct  2 12:19:28 jo kernel: [<ffffffff8161e293>] 0xffffffff8161e293
> Oct  2 12:19:28 jo kernel: [<ffffffff8161e37b>] 0xffffffff8161e37b
> Oct  2 12:19:28 jo kernel: Pid: 0, comm: swapper Not tainted 2.6.35-gentoo-r9 #1
> Oct  2 12:19:28 jo kernel: Call Trace:
> Oct  2 12:19:28 jo kernel: <NMI>  [<ffffffff8100a31c>] ? 0xffffffff8100a31c
> Oct  2 12:19:28 jo kernel: [<ffffffff810187b7>] 0xffffffff810187b7
> Oct  2 12:19:28 jo kernel: [<ffffffff8100446e>] 0xffffffff8100446e
> Oct  2 12:19:28 jo kernel: [<ffffffff8147197a>] 0xffffffff8147197a
> Oct  2 12:19:28 jo kernel: [<ffffffff81009d68>] ? 0xffffffff81009d68
> Oct  2 12:19:28 jo kernel: <<EOE>>  [<ffffffff81001bcf>] 0xffffffff81001bcf
> Oct  2 12:19:28 jo kernel: [<ffffffff8145e61c>] 0xffffffff8145e61c
> Oct  2 12:19:28 jo kernel: [<ffffffff8161eccb>] 0xffffffff8161eccb
> Oct  2 12:19:28 jo kernel: [<ffffffff8161e293>] 0xffffffff8161e293
> Oct  2 12:19:28 jo kernel: [<ffffffff8161e37b>] 0xffffffff8161e37b
> Oct  2 12:21:32 jo kernel: INFO: rcu_sched_state detected stall on CPU 3 (t=1000 jiffies)
> Oct  2 12:21:32 jo kernel: sending NMI to all CPUs:
> Oct  2 12:21:32 jo kernel: NMI backtrace for cpu 1
> Oct  2 12:21:32 jo kernel: CPU 1
> Oct  2 12:21:32 jo kernel: Modules linked in: tun ipv6 8021q iptable_raw iptable_mangle iptable_filter ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables x_tables rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core pcspkr processor snd_hda_codec_via snd_hda_intel atl1e snd_hda_codec thermal thermal_sys snd_hwdep snd_pcm snd_timer snd snd_page_alloc intel_agp button libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd 
 usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia firmware_class pcmcia_core pata_ns87415 pat
 a_ns87410 pata_serverworks pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata [last unloaded: microcode]
> Oct  2 12:21:32 jo kernel:
> Oct  2 12:21:32 jo kernel: Pid: 14616, comm: md5_raid6 Not tainted 2.6.35-gentoo-r9 #1 P5Q PRO TURBO/System Product Name
> Oct  2 12:21:32 jo kernel: RIP: 0010:[<ffffffffa0445184>]  [<ffffffffa0445184>] 0xffffffffa0445184
> Oct  2 12:21:32 jo kernel: RSP: 0018:ffff880001883ca0  EFLAGS: 00000286
> Oct  2 12:21:32 jo kernel: RAX: ffffffffa0445168 RBX: 0000000000000000 RCX: 0000000000001000
> Oct  2 12:21:32 jo kernel: RDX: 0000000000000009 RSI: 0000000000000000 RDI: ffff88006f2e1d40
> Oct  2 12:21:32 jo kernel: RBP: ffff880001883cc0 R08: ffff88011e04e4e8 R09: 0000000000000bb8
> Oct  2 12:21:32 jo kernel: R10: 0000000000000001 R11: ffffffff81380635 R12: ffff88006f2e1800
> Oct  2 12:21:32 jo kernel: R13: ffff88011edbce00 R14: 0000000000000000 R15: 0000000000000000
> Oct  2 12:21:32 jo kernel: FS:  0000000000000000(0000) GS:ffff880001880000(0000) knlGS:0000000000000000
> Oct  2 12:21:32 jo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct  2 12:21:32 jo kernel: CR2: 000000000074d900 CR3: 0000000100c91000 CR4: 00000000000006e0
> Oct  2 12:21:32 jo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  2 12:21:32 jo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  2 12:21:32 jo kernel: Process md5_raid6 (pid: 14616, threadinfo ffff88011f46a000, task ffff88011d94acf0)
> Oct  2 12:21:32 jo kernel: Stack:
> Oct  2 12:21:32 jo kernel: ffff88011e2f0ba8 ffff88006f2e1d40 0000000000000000 ffff8800bbc8baa0
> Oct  2 12:21:32 jo kernel: <0> ffff880001883cd0 ffffffff810c836a ffff880001883d00 ffffffff812ed48a
> Oct  2 12:21:32 jo kernel: <0> ffff880001883d00 ffff8800bbc8baa0 ffff88006f2e1d40 0000000000010000
> Oct  2 12:21:32 jo kernel: Call Trace:
> Oct  2 12:21:32 jo kernel: <IRQ>
> Oct  2 12:21:32 jo kernel: [<ffffffff810c836a>] 0xffffffff810c836a
> Oct  2 12:21:32 jo kernel: [<ffffffff812ed48a>] 0xffffffff812ed48a
> Oct  2 12:21:32 jo kernel: [<ffffffff812ed5ff>] 0xffffffff812ed5ff
> Oct  2 12:21:32 jo kernel: [<ffffffff812ed822>] 0xffffffff812ed822
> Oct  2 12:21:32 jo kernel: [<ffffffff812ee302>] 0xffffffff812ee302
> Oct  2 12:21:32 jo kernel: [<ffffffff812ee372>] 0xffffffff812ee372
> Oct  2 12:21:32 jo kernel: [<ffffffff813a67b8>] 0xffffffff813a67b8
> Oct  2 12:21:32 jo kernel: [<ffffffff813a0cf0>] 0xffffffff813a0cf0
> Oct  2 12:21:32 jo kernel: [<ffffffff813a6b99>] 0xffffffff813a6b99
> Oct  2 12:21:32 jo kernel: [<ffffffff812f2adb>] 0xffffffff812f2adb
> Oct  2 12:21:32 jo kernel: [<ffffffff81035ecd>] 0xffffffff81035ecd
> Oct  2 12:21:32 jo kernel: [<ffffffff81019852>] ? 0xffffffff81019852
> Oct  2 12:21:32 jo kernel: [<ffffffff8100374c>] 0xffffffff8100374c
> Oct  2 12:21:32 jo kernel: [<ffffffff810052df>] 0xffffffff810052df
> Oct  2 12:21:32 jo kernel: [<ffffffff81035bf9>] 0xffffffff81035bf9
> Oct  2 12:21:32 jo kernel: [<ffffffff810049c3>] 0xffffffff810049c3
> Oct  2 12:21:32 jo kernel: [<ffffffff81471513>] 0xffffffff81471513
> Oct  2 12:21:32 jo kernel: <EOI>
> Oct  2 12:21:32 jo kernel: [<ffffffffa0446075>] ? 0xffffffffa0446075
> Oct  2 12:21:32 jo kernel: [<ffffffffa04440c5>] ? 0xffffffffa04440c5
> Oct  2 12:21:32 jo kernel: [<ffffffffa0448795>] 0xffffffffa0448795
> Oct  2 12:21:32 jo kernel: [<ffffffffa0448ba4>] 0xffffffffa0448ba4
> Oct  2 12:21:32 jo kernel: [<ffffffff8146f884>] ? 0xffffffff8146f884
> Oct  2 12:21:32 jo kernel: [<ffffffff813cd2c3>] 0xffffffff813cd2c3
> Oct  2 12:21:32 jo kernel: [<ffffffff810443b5>] ? 0xffffffff810443b5
> Oct  2 12:21:32 jo kernel: [<ffffffff813cd1d2>] ? 0xffffffff813cd1d2
> Oct  2 12:21:32 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:21:32 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:21:32 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:21:32 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:21:32 jo kernel: Code: ff 48 8d 34 37 48 39 30 72 b6 e9 d7 fe ff ff 55 48 89 e5 41 55 41 54 53 31 db 48 83 ec 08 4c 8b 67 58 48 8b 57 18 4d 8b 6c 24 20 <41> 8b 44 24 54 eb 16 48 63 cb 48 69 c9 b0 00 00 00 49 8d 4c 0c
> Oct  2 12:21:32 jo kernel: Call Trace:
> Oct  2 12:21:32 jo kernel: <IRQ>  [<ffffffff810c836a>] 0xffffffff810c836a
> Oct  2 12:21:32 jo kernel: [<ffffffff812ed48a>] 0xffffffff812ed48a
> Oct  2 12:21:32 jo kernel: [<ffffffff812ed5ff>] 0xffffffff812ed5ff
> Oct  2 12:21:32 jo kernel: [<ffffffff812ed822>] 0xffffffff812ed822
> Oct  2 12:21:32 jo kernel: [<ffffffff812ee302>] 0xffffffff812ee302
> Oct  2 12:21:32 jo kernel: [<ffffffff812ee372>] 0xffffffff812ee372
> Oct  2 12:21:32 jo kernel: [<ffffffff813a67b8>] 0xffffffff813a67b8
> Oct  2 12:21:32 jo kernel: [<ffffffff813a0cf0>] 0xffffffff813a0cf0
> Oct  2 12:21:32 jo kernel: [<ffffffff813a6b99>] 0xffffffff813a6b99
> Oct  2 12:21:32 jo kernel: [<ffffffff812f2adb>] 0xffffffff812f2adb
> Oct  2 12:21:32 jo kernel: [<ffffffff81035ecd>] 0xffffffff81035ecd
> Oct  2 12:21:32 jo kernel: [<ffffffff81019852>] ? 0xffffffff81019852
> Oct  2 12:21:32 jo kernel: [<ffffffff8100374c>] 0xffffffff8100374c
> Oct  2 12:21:32 jo kernel: [<ffffffff810052df>] 0xffffffff810052df
> Oct  2 12:21:32 jo kernel: [<ffffffff81035bf9>] 0xffffffff81035bf9
> Oct  2 12:21:32 jo kernel: [<ffffffff810049c3>] 0xffffffff810049c3
> Oct  2 12:21:32 jo kernel: [<ffffffff81471513>] 0xffffffff81471513
> Oct  2 12:21:32 jo kernel: <EOI>  [<ffffffffa0446075>] ? 0xffffffffa0446075
> Oct  2 12:21:32 jo kernel: [<ffffffffa04440c5>] ? 0xffffffffa04440c5
> Oct  2 12:21:32 jo kernel: [<ffffffffa0448795>] 0xffffffffa0448795
> Oct  2 12:21:32 jo kernel: [<ffffffffa0448ba4>] 0xffffffffa0448ba4
> Oct  2 12:21:32 jo kernel: [<ffffffff8146f884>] ? 0xffffffff8146f884
> Oct  2 12:21:32 jo kernel: [<ffffffff813cd2c3>] 0xffffffff813cd2c3
> Oct  2 12:21:32 jo kernel: [<ffffffff810443b5>] ? 0xffffffff810443b5
> Oct  2 12:21:32 jo kernel: [<ffffffff813cd1d2>] ? 0xffffffff813cd1d2
> Oct  2 12:21:32 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:21:32 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:21:32 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:21:32 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:21:32 jo kernel: Pid: 14616, comm: md5_raid6 Not tainted 2.6.35-gentoo-r9 #1
> Oct  2 12:21:32 jo kernel: Call Trace:
> Oct  2 12:21:32 jo kernel: <NMI>  [<ffffffff8100a31c>] ? 0xffffffff8100a31c
> Oct  2 12:21:32 jo kernel: [<ffffffff810187b7>] 0xffffffff810187b7
> Oct  2 12:21:32 jo kernel: [<ffffffff8100446e>] 0xffffffff8100446e
> Oct  2 12:21:32 jo kernel: [<ffffffff8147197a>] 0xffffffff8147197a
> Oct  2 12:21:32 jo kernel: [<ffffffff81380635>] ? 0xffffffff81380635
> Oct  2 12:21:32 jo kernel: [<ffffffffa0445168>] ? 0xffffffffa0445168
> Oct  2 12:21:32 jo kernel: [<ffffffffa0445184>] ? 0xffffffffa0445184
> Oct  2 12:21:32 jo kernel: <<EOE>> <IRQ>  [<ffffffff810c836a>] 0xffffffff810c836a
> Oct  2 12:21:32 jo kernel: [<ffffffff812ed48a>] 0xffffffff812ed48a
> Oct  2 12:21:32 jo kernel: [<ffffffff812ed5ff>] 0xffffffff812ed5ff
> Oct  2 12:21:32 jo kernel: [<ffffffff812ed822>] 0xffffffff812ed822
> Oct  2 12:21:32 jo kernel: [<ffffffff812ee302>] 0xffffffff812ee302
> Oct  2 12:21:32 jo kernel: [<ffffffff812ee372>] 0xffffffff812ee372
> Oct  2 12:21:32 jo kernel: [<ffffffff813a67b8>] 0xffffffff813a67b8
> Oct  2 12:21:32 jo kernel: [<ffffffff813a0cf0>] 0xffffffff813a0cf0
> Oct  2 12:21:32 jo kernel: [<ffffffff813a6b99>] 0xffffffff813a6b99
> Oct  2 12:21:32 jo kernel: [<ffffffff812f2adb>] 0xffffffff812f2adb
> Oct  2 12:21:32 jo kernel: [<ffffffff81035ecd>] 0xffffffff81035ecd
> Oct  2 12:21:32 jo kernel: [<ffffffff81019852>] ? 0xffffffff81019852
> Oct  2 12:21:32 jo kernel: [<ffffffff8100374c>] 0xffffffff8100374c
> Oct  2 12:21:32 jo kernel: [<ffffffff810052df>] 0xffffffff810052df
> Oct  2 12:21:32 jo kernel: [<ffffffff81035bf9>] 0xffffffff81035bf9
> Oct  2 12:21:32 jo kernel: [<ffffffff810049c3>] 0xffffffff810049c3
> Oct  2 12:21:32 jo kernel: [<ffffffff81471513>] 0xffffffff81471513
> Oct  2 12:21:32 jo kernel: <EOI>  [<ffffffffa0446075>] ? 0xffffffffa0446075
> Oct  2 12:21:32 jo kernel: [<ffffffffa04440c5>] ? 0xffffffffa04440c5
> Oct  2 12:21:32 jo kernel: [<ffffffffa0448795>] 0xffffffffa0448795
> Oct  2 12:21:32 jo kernel: [<ffffffffa0448ba4>] 0xffffffffa0448ba4
> Oct  2 12:21:32 jo kernel: [<ffffffff8146f884>] ? 0xffffffff8146f884
> Oct  2 12:21:32 jo kernel: [<ffffffff813cd2c3>] 0xffffffff813cd2c3
> Oct  2 12:21:32 jo kernel: [<ffffffff810443b5>] ? 0xffffffff810443b5
> Oct  2 12:21:32 jo kernel: [<ffffffff813cd1d2>] ? 0xffffffff813cd1d2
> Oct  2 12:21:32 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:21:32 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:21:32 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:21:32 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:21:32 jo kernel: NMI backtrace for cpu 2
> Oct  2 12:21:32 jo kernel: CPU 2
> Oct  2 12:21:32 jo kernel: Modules linked in: tun ipv6 8021q iptable_raw iptable_mangle iptable_filter ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables x_tables rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core pcspkr processor snd_hda_codec_via snd_hda_intel atl1e snd_hda_codec thermal thermal_sys snd_hwdep snd_pcm snd_timer snd snd_page_alloc intel_agp button libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd 
 usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia firmware_class pcmcia_core pata_ns87415 pat
 a_ns87410 pata_serverworks pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata [last unloaded: microcode]
> Oct  2 12:21:32 jo kernel:
> Oct  2 12:21:32 jo kernel: Pid: 0, comm: swapper Not tainted 2.6.35-gentoo-r9 #1 P5Q PRO TURBO/System Product Name
> Oct  2 12:21:32 jo kernel: RIP: 0010:[<ffffffff81009d68>]  [<ffffffff81009d68>] 0xffffffff81009d68
> Oct  2 12:21:32 jo kernel: RSP: 0018:ffff88011fccbf08  EFLAGS: 00000246
> Oct  2 12:21:32 jo kernel: RAX: 0000000000000000 RBX: ffffffff81607680 RCX: 0000000000000000
> Oct  2 12:21:32 jo kernel: RDX: 0000000000000000 RSI: ffff88011fccbfd8 RDI: ffffffff81683308
> Oct  2 12:21:32 jo kernel: RBP: ffff88011fccbf08 R08: 0000000000000000 R09: 0000000000000000
> Oct  2 12:21:32 jo kernel: R10: 0000000000000000 R11: 00000000ffffffff R12: ffff88011fccbfd8
> Oct  2 12:21:32 jo kernel: R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> Oct  2 12:21:32 jo kernel: FS:  0000000000000000(0000) GS:ffff880001900000(0000) knlGS:0000000000000000
> Oct  2 12:21:32 jo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct  2 12:21:32 jo kernel: CR2: 0000000000408a40 CR3: 0000000100f82000 CR4: 00000000000006e0
> Oct  2 12:21:32 jo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  2 12:21:32 jo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  2 12:21:32 jo kernel: Process swapper (pid: 0, threadinfo ffff88011fcca000, task ffff88011fcbecf0)
> Oct  2 12:21:32 jo kernel: Stack:
> Oct  2 12:21:32 jo kernel: ffff88011fccbf28 ffffffff81001bcf 0000000000000002 0000000000000000
> Oct  2 12:21:32 jo kernel: <0> ffff88011fccbf48 ffffffff8146c288 3081aa158d48f824 0000000000000000
> Oct  2 12:21:32 jo kernel: <0> 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> Oct  2 12:21:32 jo kernel: Call Trace:
> Oct  2 12:21:32 jo kernel: [<ffffffff81001bcf>] 0xffffffff81001bcf
> Oct  2 12:21:32 jo kernel: [<ffffffff8146c288>] 0xffffffff8146c288
> Oct  2 12:21:32 jo kernel: Code: 48 8b 34 25 48 b5 00 00 31 d2 48 8d 86 38 e0 ff ff 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 31 c0 fb 0f 01 c9 <eb> 01 fb c9 c3 55 48 89 e5 65 48 8b 14 25 48 b5 00 00 48 8b 82
> Oct  2 12:21:32 jo kernel: Call Trace:
> Oct  2 12:21:32 jo kernel: [<ffffffff81001bcf>] 0xffffffff81001bcf
> Oct  2 12:21:32 jo kernel: [<ffffffff8146c288>] 0xffffffff8146c288
> Oct  2 12:21:32 jo kernel: Pid: 0, comm: swapper Not tainted 2.6.35-gentoo-r9 #1
> Oct  2 12:21:32 jo kernel: Call Trace:
> Oct  2 12:21:32 jo kernel: <NMI>  [<ffffffff8100a31c>] ? 0xffffffff8100a31c
> Oct  2 12:21:32 jo kernel: [<ffffffff810187b7>] 0xffffffff810187b7
> Oct  2 12:21:32 jo kernel: [<ffffffff8100446e>] 0xffffffff8100446e
> Oct  2 12:21:32 jo kernel: [<ffffffff8147197a>] 0xffffffff8147197a
> Oct  2 12:21:32 jo kernel: [<ffffffff81009d68>] ? 0xffffffff81009d68
> Oct  2 12:21:32 jo kernel: <<EOE>>  [<ffffffff81001bcf>] 0xffffffff81001bcf
> Oct  2 12:21:32 jo kernel: [<ffffffff8146c288>] 0xffffffff8146c288
> Oct  2 12:21:32 jo kernel: NMI backtrace for cpu 3
> Oct  2 12:21:32 jo kernel: CPU 3
> Oct  2 12:21:32 jo kernel: Modules linked in: tun ipv6 8021q iptable_raw iptable_mangle iptable_filter ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables x_tables rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core pcspkr processor snd_hda_codec_via snd_hda_intel atl1e snd_hda_codec thermal thermal_sys snd_hwdep snd_pcm snd_timer snd snd_page_alloc intel_agp button libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd 
 usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia firmware_class pcmcia_core pata_ns87415 pat
 a_ns87410 pata_serverworks pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata [last unloaded: microcode]
> Oct  2 12:21:32 jo kernel:
> Oct  2 12:21:32 jo kernel: Pid: 22695, comm: btrfs-worker-4 Not tainted 2.6.35-gentoo-r9 #1 P5Q PRO TURBO/System Product Name
> Oct  2 12:21:32 jo kernel: RIP: 0010:[<ffffffff81303c06>]  [<ffffffff81303c06>] 0xffffffff81303c06
> Oct  2 12:21:32 jo kernel: RSP: 0018:ffff880001983de0  EFLAGS: 00000803
> Oct  2 12:21:32 jo kernel: RAX: 00000000c68de520 RBX: 0000000000000001 RCX: ffff880001980000
> Oct  2 12:21:32 jo kernel: RDX: 0000000000249f7d RSI: 0000000000000002 RDI: 0000000000249f7e
> Oct  2 12:21:32 jo kernel: RBP: ffff880001983de8 R08: 000000000000001c R09: 000000000000000a
> Oct  2 12:21:32 jo kernel: R10: 0000000000000003 R11: 0000000000000000 R12: ffff88000198e9b0
> Oct  2 12:21:32 jo kernel: R13: ffffffff815d3080 R14: ffff88000198e778 R15: ffff880001983f48
> Oct  2 12:21:32 jo kernel: FS:  0000000000000000(0000) GS:ffff880001980000(0000) knlGS:0000000000000000
> Oct  2 12:21:32 jo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct  2 12:21:32 jo kernel: CR2: 000000000060f000 CR3: 00000000015bf000 CR4: 00000000000006e0
> Oct  2 12:21:32 jo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  2 12:21:32 jo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  2 12:21:32 jo kernel: Process btrfs-worker-4 (pid: 22695, threadinfo ffff88004bc96000, task ffff88011fe04cb0)
> Oct  2 12:21:32 jo kernel: Stack:
> Oct  2 12:21:32 jo kernel: ffffffff81303b55 ffff880001983df8 ffffffff81303b91 ffff880001983e18
> Oct  2 12:21:32 jo kernel: <0> ffffffff81018645 ffff88000198e778 ffffffff815d3080 ffff880001983e68
> Oct  2 12:21:32 jo kernel: <0> ffffffff81073786 ffff880001983e78 ffffffff8106f0e2 000000003b9aca00
> Oct  2 12:21:32 jo kernel: Call Trace:
> Oct  2 12:21:32 jo kernel: <IRQ>
> Oct  2 12:21:32 jo kernel: [<ffffffff81303b55>] ? 0xffffffff81303b55
> Oct  2 12:21:32 jo kernel: [<ffffffff81303b91>] 0xffffffff81303b91
> Oct  2 12:21:32 jo kernel: [<ffffffff81018645>] 0xffffffff81018645
> Oct  2 12:21:32 jo kernel: [<ffffffff81073786>] 0xffffffff81073786
> Oct  2 12:21:32 jo kernel: [<ffffffff8106f0e2>] ? 0xffffffff8106f0e2
> Oct  2 12:21:32 jo kernel: [<ffffffff81073adc>] 0xffffffff81073adc
> Oct  2 12:21:32 jo kernel: [<ffffffff8103b064>] 0xffffffff8103b064
> Oct  2 12:21:32 jo kernel: [<ffffffff8104efb5>] 0xffffffff8104efb5
> Oct  2 12:21:32 jo kernel: [<ffffffff81046ba0>] 0xffffffff81046ba0
> Oct  2 12:21:32 jo kernel: [<ffffffff81046dea>] 0xffffffff81046dea
> Oct  2 12:21:32 jo kernel: [<ffffffff81018044>] 0xffffffff81018044
> Oct  2 12:21:32 jo kernel: [<ffffffff81003213>] 0xffffffff81003213
> Oct  2 12:21:32 jo kernel: <EOI>
> Oct  2 12:21:32 jo kernel: [<ffffffff812eb6a0>] ? 0xffffffff812eb6a0
> Oct  2 12:21:32 jo kernel: [<ffffffff812e5942>] 0xffffffff812e5942
> Oct  2 12:21:32 jo kernel: [<ffffffff81308097>] 0xffffffff81308097
> Oct  2 12:21:32 jo kernel: [<ffffffff812931d2>] ? 0xffffffff812931d2
> Oct  2 12:21:32 jo kernel: [<ffffffff81279494>] 0xffffffff81279494
> Oct  2 12:21:32 jo kernel: [<ffffffff8127640f>] 0xffffffff8127640f
> Oct  2 12:21:32 jo kernel: [<ffffffff8127f048>] 0xffffffff8127f048
> Oct  2 12:21:32 jo kernel: [<ffffffff812773b6>] 0xffffffff812773b6
> Oct  2 12:21:32 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:21:32 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:21:32 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:21:32 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:21:32 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:21:32 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:21:32 jo kernel: Code: 01 00 65 8b 0c 25 60 d3 00 00 48 63 c9 48 8b 0c cd 00 74 60 81 48 6b 94 0a 98 00 00 00 19 f7 e2 48 8d 7a 01 e8 47 ff ff ff c9 c3 <55> 48 89 e5 65 8b 34 25 60 d3 00 00 0f 1f 00 0f ae e8 0f 31 89
> Oct  2 12:21:32 jo kernel: Call Trace:
> Oct  2 12:21:32 jo kernel: <IRQ>  [<ffffffff81303b55>] ? 0xffffffff81303b55
> Oct  2 12:21:32 jo kernel: [<ffffffff81303b91>] 0xffffffff81303b91
> Oct  2 12:21:32 jo kernel: [<ffffffff81018645>] 0xffffffff81018645
> Oct  2 12:21:32 jo kernel: [<ffffffff81073786>] 0xffffffff81073786
> Oct  2 12:21:32 jo kernel: [<ffffffff8106f0e2>] ? 0xffffffff8106f0e2
> Oct  2 12:21:32 jo kernel: [<ffffffff81073adc>] 0xffffffff81073adc
> Oct  2 12:21:32 jo kernel: [<ffffffff8103b064>] 0xffffffff8103b064
> Oct  2 12:21:32 jo kernel: [<ffffffff8104efb5>] 0xffffffff8104efb5
> Oct  2 12:21:32 jo kernel: [<ffffffff81046ba0>] 0xffffffff81046ba0
> Oct  2 12:21:32 jo kernel: [<ffffffff81046dea>] 0xffffffff81046dea
> Oct  2 12:21:32 jo kernel: [<ffffffff81018044>] 0xffffffff81018044
> Oct  2 12:21:32 jo kernel: [<ffffffff81003213>] 0xffffffff81003213
> Oct  2 12:21:32 jo kernel: <EOI>  [<ffffffff812eb6a0>] ? 0xffffffff812eb6a0
> Oct  2 12:21:32 jo kernel: [<ffffffff812e5942>] 0xffffffff812e5942
> Oct  2 12:21:32 jo kernel: [<ffffffff81308097>] 0xffffffff81308097
> Oct  2 12:21:32 jo kernel: [<ffffffff812931d2>] ? 0xffffffff812931d2
> Oct  2 12:21:32 jo kernel: [<ffffffff81279494>] 0xffffffff81279494
> Oct  2 12:21:32 jo kernel: [<ffffffff8127640f>] 0xffffffff8127640f
> Oct  2 12:21:32 jo kernel: [<ffffffff8127f048>] 0xffffffff8127f048
> Oct  2 12:21:32 jo kernel: [<ffffffff812773b6>] 0xffffffff812773b6
> Oct  2 12:21:32 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:21:32 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:21:32 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:21:32 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:21:32 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:21:32 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:21:32 jo kernel: Pid: 22695, comm: btrfs-worker-4 Not tainted 2.6.35-gentoo-r9 #1
> Oct  2 12:21:32 jo kernel: Call Trace:
> Oct  2 12:21:32 jo kernel: <NMI>  [<ffffffff8100a31c>] ? 0xffffffff8100a31c
> Oct  2 12:21:32 jo kernel: [<ffffffff810187b7>] 0xffffffff810187b7
> Oct  2 12:21:32 jo kernel: [<ffffffff8100446e>] 0xffffffff8100446e
> Oct  2 12:21:32 jo kernel: [<ffffffff8147197a>] 0xffffffff8147197a
> Oct  2 12:21:32 jo kernel: [<ffffffff81303c06>] ? 0xffffffff81303c06
> Oct  2 12:21:32 jo kernel: <<EOE>> <IRQ>  [<ffffffff81303b55>] ? 0xffffffff81303b55
> Oct  2 12:21:32 jo kernel: [<ffffffff81303b91>] 0xffffffff81303b91
> Oct  2 12:21:32 jo kernel: [<ffffffff81018645>] 0xffffffff81018645
> Oct  2 12:21:32 jo kernel: [<ffffffff81073786>] 0xffffffff81073786
> Oct  2 12:21:32 jo kernel: [<ffffffff8106f0e2>] ? 0xffffffff8106f0e2
> Oct  2 12:21:32 jo kernel: [<ffffffff81073adc>] 0xffffffff81073adc
> Oct  2 12:21:32 jo kernel: [<ffffffff8103b064>] 0xffffffff8103b064
> Oct  2 12:21:32 jo kernel: [<ffffffff8104efb5>] 0xffffffff8104efb5
> Oct  2 12:21:32 jo kernel: [<ffffffff81046ba0>] 0xffffffff81046ba0
> Oct  2 12:21:32 jo kernel: [<ffffffff81046dea>] 0xffffffff81046dea
> Oct  2 12:21:32 jo kernel: [<ffffffff81018044>] 0xffffffff81018044
> Oct  2 12:21:32 jo kernel: [<ffffffff81003213>] 0xffffffff81003213
> Oct  2 12:21:32 jo kernel: <EOI>  [<ffffffff812eb6a0>] ? 0xffffffff812eb6a0
> Oct  2 12:21:32 jo kernel: [<ffffffff812e5942>] 0xffffffff812e5942
> Oct  2 12:21:32 jo kernel: [<ffffffff81308097>] 0xffffffff81308097
> Oct  2 12:21:32 jo kernel: [<ffffffff812931d2>] ? 0xffffffff812931d2
> Oct  2 12:21:32 jo kernel: [<ffffffff81279494>] 0xffffffff81279494
> Oct  2 12:21:32 jo kernel: [<ffffffff8127640f>] 0xffffffff8127640f
> Oct  2 12:21:32 jo kernel: [<ffffffff8127f048>] 0xffffffff8127f048
> Oct  2 12:21:32 jo kernel: [<ffffffff812773b6>] 0xffffffff812773b6
> Oct  2 12:21:32 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:21:32 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:21:32 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:21:32 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:21:32 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:21:32 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:21:32 jo kernel: NMI backtrace for cpu 0
> Oct  2 12:21:32 jo kernel: CPU 0
> Oct  2 12:21:32 jo kernel: Modules linked in: tun ipv6 8021q iptable_raw iptable_mangle iptable_filter ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ipt_addrtype xt_dscp xt_string xt_multiport xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables x_tables rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core pcspkr processor snd_hda_codec_via snd_hda_intel atl1e snd_hda_codec thermal thermal_sys snd_hwdep snd_pcm snd_timer snd snd_page_alloc intel_agp button libiscsi scsi_transport_iscsi tg3 libphy e1000 fuse nfs lockd sunrpc jfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd 
 usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia firmware_class pcmcia_core pata_ns87415 pat
 a_ns87410 pata_serverworks pata_platform pata_artop pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata [last unloaded: microcode]
> Oct  2 12:21:32 jo kernel:
> Oct  2 12:21:32 jo kernel: Pid: 23272, comm: btrfs-endio-wri Not tainted 2.6.35-gentoo-r9 #1 P5Q PRO TURBO/System Product Name
> Oct  2 12:21:32 jo kernel: RIP: 0010:[<ffffffff8129587a>]  [<ffffffff8129587a>] 0xffffffff8129587a
> Oct  2 12:21:32 jo kernel: RSP: 0018:ffff8800df86b970  EFLAGS: 00000286
> Oct  2 12:21:32 jo kernel: RAX: ffff88006d6554e8 RBX: ffff8800bfea4c18 RCX: 0000000000000050
> Oct  2 12:21:32 jo kernel: RDX: 0000000000001000 RSI: 0000000003b43000 RDI: ffff8800bfea4c3c
> Oct  2 12:21:32 jo kernel: RBP: ffff8800df86b990 R08: ffff8800df86b970 R09: ffff8800df86b968
> Oct  2 12:21:32 jo kernel: R10: ffff8800df86b960 R11: 6db6db6db6db6db7 R12: ffff8800bd9d81c0
> Oct  2 12:21:32 jo kernel: R13: 0000000003b43000 R14: 00000000000008a5 R15: ffff88007b744f40
> Oct  2 12:21:32 jo kernel: FS:  0000000000000000(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
> Oct  2 12:21:32 jo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Oct  2 12:21:32 jo kernel: CR2: 00007f18f0b2f000 CR3: 0000000100886000 CR4: 00000000000006f0
> Oct  2 12:21:32 jo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Oct  2 12:21:32 jo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct  2 12:21:32 jo kernel: Process btrfs-endio-wri (pid: 23272, threadinfo ffff8800df86a000, task ffff88011e0a4090)
> Oct  2 12:21:32 jo kernel: Stack:
> Oct  2 12:21:32 jo kernel: ffff880054b0c000 ffff8800c0744000 ffff8800df86bad0 0000000000000001
> Oct  2 12:21:32 jo kernel: <0> ffff8800df86b9a0 ffffffff812773dd ffff8800df86ba50 ffffffff812610a5
> Oct  2 12:21:32 jo kernel: <0> 00000021df86ba28 ffff8801120b9d90 ffff8800df86badc 00000040df86ba28
> Oct  2 12:21:32 jo kernel: Call Trace:
> Oct  2 12:21:32 jo kernel: [<ffffffff812773dd>] 0xffffffff812773dd
> Oct  2 12:21:32 jo kernel: [<ffffffff812610a5>] 0xffffffff812610a5
> Oct  2 12:21:32 jo kernel: [<ffffffff81268296>] 0xffffffff81268296
> Oct  2 12:21:32 jo kernel: [<ffffffff81275697>] 0xffffffff81275697
> Oct  2 12:21:32 jo kernel: [<ffffffff812956f6>] ? 0xffffffff812956f6
> Oct  2 12:21:32 jo kernel: [<ffffffff81275822>] 0xffffffff81275822
> Oct  2 12:21:32 jo kernel: [<ffffffff8127e9ef>] 0xffffffff8127e9ef
> Oct  2 12:21:32 jo kernel: [<ffffffff81286a49>] 0xffffffff81286a49
> Oct  2 12:21:32 jo kernel: [<ffffffff81083406>] ? 0xffffffff81083406
> Oct  2 12:21:32 jo kernel: [<ffffffff81286ac5>] 0xffffffff81286ac5
> Oct  2 12:21:32 jo kernel: [<ffffffff812976c4>] 0xffffffff812976c4
> Oct  2 12:21:32 jo kernel: [<ffffffff810c836a>] 0xffffffff810c836a
> Oct  2 12:21:32 jo kernel: [<ffffffff81279478>] 0xffffffff81279478
> Oct  2 12:21:32 jo kernel: [<ffffffff8103af90>] ? 0xffffffff8103af90
> Oct  2 12:21:32 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:21:32 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:21:32 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:21:32 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:21:32 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:21:32 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:21:32 jo kernel: Code: c0 41 5c 41 5d 41 5e c9 c3 55 48 89 e5 41 55 49 89 f5 41 54 53 48 89 fb 48 83 ec 08 48 8d 7f 24 e8 12 b9 1d 00 48 8b 43 08 eb 16 <4c> 8d 60 a8 4c 3b 68 a8 73 06 48 8b 40 10 eb 06 76 0e 48 8b 40
> Oct  2 12:21:32 jo kernel: Call Trace:
> Oct  2 12:21:32 jo kernel: [<ffffffff812773dd>] 0xffffffff812773dd
> Oct  2 12:21:32 jo kernel: [<ffffffff812610a5>] 0xffffffff812610a5
> Oct  2 12:21:32 jo kernel: [<ffffffff81268296>] 0xffffffff81268296
> Oct  2 12:21:32 jo kernel: [<ffffffff81275697>] 0xffffffff81275697
> Oct  2 12:21:32 jo kernel: [<ffffffff812956f6>] ? 0xffffffff812956f6
> Oct  2 12:21:32 jo kernel: [<ffffffff81275822>] 0xffffffff81275822
> Oct  2 12:21:32 jo kernel: [<ffffffff8127e9ef>] 0xffffffff8127e9ef
> Oct  2 12:21:32 jo kernel: [<ffffffff81286a49>] 0xffffffff81286a49
> Oct  2 12:21:32 jo kernel: [<ffffffff81083406>] ? 0xffffffff81083406
> Oct  2 12:21:32 jo kernel: [<ffffffff81286ac5>] 0xffffffff81286ac5
> Oct  2 12:21:32 jo kernel: [<ffffffff812976c4>] 0xffffffff812976c4
> Oct  2 12:21:32 jo kernel: [<ffffffff810c836a>] 0xffffffff810c836a
> Oct  2 12:21:32 jo kernel: [<ffffffff81279478>] 0xffffffff81279478
> Oct  2 12:21:32 jo kernel: [<ffffffff8103af90>] ? 0xffffffff8103af90
> Oct  2 12:21:32 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:21:32 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:21:32 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:21:32 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:21:32 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:21:32 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
> Oct  2 12:21:32 jo kernel: Pid: 23272, comm: btrfs-endio-wri Not tainted 2.6.35-gentoo-r9 #1
> Oct  2 12:21:32 jo kernel: Call Trace:
> Oct  2 12:21:32 jo kernel: <NMI>  [<ffffffff8100a31c>] ? 0xffffffff8100a31c
> Oct  2 12:21:32 jo kernel: [<ffffffff810187b7>] 0xffffffff810187b7
> Oct  2 12:21:32 jo kernel: [<ffffffff8100446e>] 0xffffffff8100446e
> Oct  2 12:21:32 jo kernel: [<ffffffff8147197a>] 0xffffffff8147197a
> Oct  2 12:21:32 jo kernel: [<ffffffff8129587a>] ? 0xffffffff8129587a
> Oct  2 12:21:32 jo kernel: <<EOE>>  [<ffffffff812773dd>] 0xffffffff812773dd
> Oct  2 12:21:32 jo kernel: [<ffffffff812610a5>] 0xffffffff812610a5
> Oct  2 12:21:32 jo kernel: [<ffffffff81268296>] 0xffffffff81268296
> Oct  2 12:21:32 jo kernel: [<ffffffff81275697>] 0xffffffff81275697
> Oct  2 12:21:32 jo kernel: [<ffffffff812956f6>] ? 0xffffffff812956f6
> Oct  2 12:21:32 jo kernel: [<ffffffff81275822>] 0xffffffff81275822
> Oct  2 12:21:32 jo kernel: [<ffffffff8127e9ef>] 0xffffffff8127e9ef
> Oct  2 12:21:32 jo kernel: [<ffffffff81286a49>] 0xffffffff81286a49
> Oct  2 12:21:32 jo kernel: [<ffffffff81083406>] ? 0xffffffff81083406
> Oct  2 12:21:32 jo kernel: [<ffffffff81286ac5>] 0xffffffff81286ac5
> Oct  2 12:21:32 jo kernel: [<ffffffff812976c4>] 0xffffffff812976c4
> Oct  2 12:21:32 jo kernel: [<ffffffff810c836a>] 0xffffffff810c836a
> Oct  2 12:21:32 jo kernel: [<ffffffff81279478>] 0xffffffff81279478
> Oct  2 12:21:32 jo kernel: [<ffffffff8103af90>] ? 0xffffffff8103af90
> Oct  2 12:21:32 jo kernel: [<ffffffff8129f757>] 0xffffffff8129f757
> Oct  2 12:21:32 jo kernel: [<ffffffff8129f5d1>] ? 0xffffffff8129f5d1
> Oct  2 12:21:32 jo kernel: [<ffffffff81043fc3>] 0xffffffff81043fc3
> Oct  2 12:21:32 jo kernel: [<ffffffff81003654>] 0xffffffff81003654
> Oct  2 12:21:32 jo kernel: [<ffffffff81043f49>] ? 0xffffffff81043f49
> Oct  2 12:21:32 jo kernel: [<ffffffff81003650>] ? 0xffffffff81003650
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
