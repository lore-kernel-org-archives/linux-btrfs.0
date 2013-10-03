Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46199 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab3JCR2x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Oct 2013 13:28:53 -0400
Received: by mail-lb0-f177.google.com with SMTP id w7so2312294lbi.36
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Oct 2013 10:28:52 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 3 Oct 2013 18:28:51 +0100
Message-ID: <CAEqknOOCsRPe30M0AdJcSNNz4vnaq=0sc+V9zksorLOJUBiukg@mail.gmail.com>
Subject: Should I worry about this kernel opps ?
From: Jerome Haynes-Smith <jerrycan321@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: JEROME SMITH <Jerrycan321@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks

I am using btrfs in openSUSE 12.3 and I have seen several of these recently:

2013-10-03 10:04:27]  ------------[ cut here ]------------
[2013-10-03 10:04:27]  WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.10/linux-3.7/fs/btrfs/extent_map.c:258
unpin_extent_cache+0x65/0x140 [btrfs]()
[2013-10-03 10:04:27]  Hardware name: GA-78LMT-USB3
[2013-10-03 10:04:27]  Modules linked in: usb_storage vboxpci(O)
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nf_conntrack_ipv6
nf_defrag_ipv6 xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack bnep bluetooth fuse rfkill ebtable_nat ebtables af_packet
bridge stp llc ip6table_filter ip6_tables iptable_filter ip_tables
x_tables it87 hwmon_vid tun mos7720 uvcvideo videobuf2_core videodev
usbserial videobuf2_vmalloc videobuf2_memops acpi_cpufreq mperf
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
kvm_amd ghash_clmulni_intel aesni_intel ablk_helper cryptd kvm lrw
snd_seq aes_x86_64 xts snd_timer snd_seq_device serio_raw gf128mul snd
sp5100_tco edac_core edac_mce_amd pcspkr ppdev fam15h_power soundcore
k10temp microcode snd_page_alloc r8169 i2c_piix4 sr_mod cdrom sg
shpchp pci_hotplug parport_pc parport autofs4 btrfs zlib_deflate
libcrc32c dm_mod linear raid456 async_raid6_recov async_pq raid6_pq
async_xor xor async_memcpy async_tx raid10 raid0 raid1 nouveau ttm
drm_kms_helper drm i2c_algo_bit mxm_wmi video crc32c_intel xhci_hcd
wmi button processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic pata_atiixp sata_sil24
[last unloaded: vboxdrv]
[2013-10-03 10:04:27]  Pid: 22467, comm: btrfs-endio-wri Tainted: G
    W  O 3.7.10-1.16-desktop #1
[2013-10-03 10:04:27]  Call Trace:
[2013-10-03 10:04:27]   [<ffffffff81004818>] dump_trace+0x88/0x300
[2013-10-03 10:04:27]   [<ffffffff8158af33>] dump_stack+0x69/0x6f
[2013-10-03 10:04:27]   [<ffffffff81045249>] warn_slowpath_common+0x79/0xc0
[2013-10-03 10:04:27]   [<ffffffffa02d9b05>]
unpin_extent_cache+0x65/0x140 [btrfs]
[2013-10-03 10:04:27]   [<ffffffffa02cecc5>]
btrfs_finish_ordered_io+0x265/0x450 [btrfs]
[2013-10-03 10:04:27]   [<ffffffffa02ee3b3>] worker_loop+0x153/0x560 [btrfs]
[2013-10-03 10:04:27]   [<ffffffff810681c3>] kthread+0xb3/0xc0
[2013-10-03 10:04:27]   [<ffffffff8159e9fc>] ret_from_fork+0x7c/0xb0
[2013-10-03 10:04:27]  ---[ end trace 15c2365f00718aa8 ]---

I see no symptoms of a problem at this time. (Disks seem a bit busy,
but I think that's the snapperd)
I don't seem to find many matches for 'unpin_extent_cache+0x65/0x140
[btrfs]' which I believe is the actual point that the system decided
to do the 'opps'.. but I may be wrong.

Is this something I need to do something about ?
I can send a siga output if it will help. (I tried to attach it as a
compressed text file, but the email bounced previously)

Regards
Jerome
