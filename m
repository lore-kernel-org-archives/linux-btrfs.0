Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:51092 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab2KMU0C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Nov 2012 15:26:02 -0500
Message-ID: <50A2ACD5.5040500@brockmann-consult.de>
Date: Tue, 13 Nov 2012 21:25:57 +0100
From: Peter Maloney <peter.maloney@brockmann-consult.de>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: btrfs slow for virtual disks - warn_slowpath_common - stack trace
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have the same issue as described in this bug tracker, and I have a
stack trace:
https://bugzilla.redhat.com/show_bug.cgi?id=689127

I would love to post my stack trace on the tracker, but it won't send me
a confirmation email for creating an account.

Windows 8 64 bit preview has been installing for about 1 hour and 20
minutes, and then around the time the install was done and the machine
booted, I found this in my syslog:

[ 7776.947491] ------------[ cut here ]------------
[ 7776.947546] WARNING: at fs/btrfs/tree-log.c:3716
btrfs_log_inode_parent+0x2af/0x2c0 [btrfs]()
[ 7776.947574] Hardware name: GA-990FXA-UD5
[ 7776.947579] Modules linked in: vhost_net macvtap macvlan tun
ebtable_nat ebtables raid10 fuse xt_tcpudp xt_pkttype xt_physdev xt_LOG
xt_limit bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_raw ipt_REJECT it87 hwmon_vid iptable_raw iptable_filter
ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack
ip6table_filter ip6_tables x_tables cpufreq_conservative
cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode
binfmt_misc dm_mod snd_hda_codec_hdmi crc32c_intel snd_hda_codec_realtek
ghash_clmulni_intel snd_hda_intel snd_hda_codec aesni_intel raid1
ablk_helper firewire_ohci edd cryptd snd_hwdep firewire_core lrw joydev
sp5100_tco aes_x86_64 sr_mod snd_pcm k10temp i2c_piix4 snd_timer button
hid_generic mxm_wmi cdrom snd xts crc_itu_t fam15h_power gf128mul wmi sg
soundcore edac_core xhci_hcd r8169 snd_page_alloc edac_mce_amd pcspkr
serio_raw autofs4 btrfs zlib_deflate libcrc32c usbhid ohci_hcd radeon
ehci_hcd usbcore usb_common ttm drm_kms_helper drm i2c_algo_bit
processor thermal_sys [last unloaded: microcode]
[ 7776.947719] Pid: 9562, comm: qemu-kvm Not tainted 3.7.0-rc4-1-default #7
[ 7776.947721] Call Trace:
[ 7776.947739]  [<ffffffff810a010a>] warn_slowpath_common+0x7a/0xb0
[ 7776.947744]  [<ffffffff810a0155>] warn_slowpath_null+0x15/0x20
[ 7776.947779]  [<ffffffffa018635f>] btrfs_log_inode_parent+0x2af/0x2c0
[btrfs]
[ 7776.947814]  [<ffffffffa01863b1>] btrfs_log_dentry_safe+0x41/0x70 [btrfs]
[ 7776.947849]  [<ffffffffa015ee84>] btrfs_sync_file+0x164/0x200 [btrfs]
[ 7776.947856]  [<ffffffff811e8980>] generic_write_sync+0x50/0x70
[ 7776.947913]  [<ffffffffa01603a6>] btrfs_file_aio_write+0x2b6/0x310
[btrfs]
[ 7776.947921]  [<ffffffff811bb493>] do_sync_write+0xa3/0xe0
[ 7776.947943]  [<ffffffff811bbb0e>] vfs_write+0xae/0x180
[ 7776.947949]  [<ffffffff811bbfaa>] sys_pwrite64+0x9a/0xa0
[ 7776.947971]  [<ffffffff81606029>] system_call_fastpath+0x16/0x1b
[ 7776.947974] ---[ end trace 37a41a586d58e58e ]---

