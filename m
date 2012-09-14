Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44226 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2INRJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 13:09:13 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1TCZOC-0003ls-Ff
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 10:09:12 -0700
Date: Fri, 14 Sep 2012 10:09:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Root dentry has weird name <>
Message-ID: <20120914170912.GH19051@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I only have btrfs on my laptop and just started getting this.

I'm not too clear about whether it's in memory or on my filesystem somewhere.

Can you recommend what I should do: reboot? fsck somehow? other?

kernel 3.5.2-amd64

[1533698.654742] ------------[ cut here ]------------
[1533698.654745] WARNING: at fs/dcache.c:2620 prepend_path+0x150/0x196()
[1533698.654746] Hardware name: 2429A78
[1533698.654747] Root dentry has weird name <>
[1533698.654748] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext3 jbd ext2 iwlwifi mac80211 cfg80211 pl2303 ipt_MASQUERADE ipt_REJECT xt_tcpudp xt_state xt_LOG iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables rndis_host cdc_ether usbnet mii msr ftdi_sio usbserial usb_storage uas nls_utf8 nls_cp437 vfat fat mmc_block tun cpufreq_userspace cpufreq_conservative ppdev cpufreq_powersave cpufreq_stats rfcomm bnep autofs4 pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc uinput fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 mbcache jbd2 configs parport_pc lp parport loop firewire_sbp2 firewire_core crc_itu_t snd_hda_codec_realtek uvcvideo videobuf2_core videodev media videobuf2_vmalloc videobuf2_memops btusb bluetooth crc16 arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi acpi_cpufreq snd_seq_midi_event snd_seq snd_timer snd_seq_device coretemp kvm_intel kvm tpm_tis thinkpad_acpi crc32c_intel tpm ac nvram snd tpm_bios battery ghash_clmulni_intel i915 wmi rfkill mei drm_kms_helper soundcore i2c_i801 drm snd_page_alloc pcspkr ehci_hcd i2c_algo_bit psmouse sdhci_pci sdhci serio_raw evdev lpc_ich mmc_core microcode xhci_hcd mperf button usbcore i2c_core e1000e video processor usb_common raid10 raid456 raid1 raid0 multipath linear btrfs zlib_deflate md_mod dm_snapshot dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq raid6_pq async_xor async_memcpy async_tx xor libcrc32c crc32c blowfish_x86_64 blowfish_common ecb xts gf128mul sd_mod crc_t10dif aesni_intel cryptd ahci libahci aes_x86_64 libata scsi_mod thermal thermal_sys [last unloaded: cfg80211]
[1533698.654849] Pid: 8520, comm: chrome-sandbox Tainted: G        W  O 3.5.2-amd64-preempt-noide-20120731 #1
[1533698.654850] Call Trace:
[1533698.654852]  [<ffffffff8103d664>] warn_slowpath_common+0x7e/0x96
[1533698.654855]  [<ffffffff8103d710>] warn_slowpath_fmt+0x41/0x43
[1533698.654858]  [<ffffffff811246a5>] prepend_path+0x150/0x196
[1533698.654861]  [<ffffffff81124756>] path_with_deleted+0x6b/0x74
[1533698.654864]  [<ffffffff81125975>] d_path+0x90/0xb7
[1533698.654866]  [<ffffffff8115fdc4>] proc_pid_readlink+0x6e/0xc4
[1533698.654870]  [<ffffffff8111832c>] sys_readlinkat+0x7b/0x97
[1533698.654872]  [<ffffffff8109e2b7>] ? __audit_syscall_entry+0x11a/0x146
[1533698.654875]  [<ffffffff8111835e>] sys_readlink+0x16/0x18
[1533698.654878]  [<ffffffff8139f63d>] system_call_fastpath+0x1a/0x1f
[1533698.654879] ---[ end trace 6c44f2d3dc16e6f1 ]---

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
