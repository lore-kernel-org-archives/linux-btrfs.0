Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44383 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbaEGXkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 19:40:04 -0400
Received: from p2237-ipad08yosemiya.okinawa.ocn.ne.jp ([124.97.214.237]:48073 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WiBRS-00018h-Ae by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 16:40:02 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WiBRP-0003GX-MK
	for linux-btrfs@vger.kernel.org; Wed, 07 May 2014 16:39:59 -0700
Date: Wed, 7 May 2014 16:39:59 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: URGENT: my laptop's boot ssd btrfs crashed, what do you need off it?
Message-ID: <20140507233959.GB11401@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In a moment of irony, my laptop's boot SSD's btrfs fileysstem crashed
last night with my btrfs talk slides still open on it. It went read only overnight
but did not crash.

Please tell me ASAP if you need anything off the filesystem before I recover it
since I'm travelling, and need to bring my laptop back up to a working state
ASAP (I'll save the irony of showing up at my talk with "Err, I can't
give my btrfs talk, btrfs crashed on my laptop).

I'm not interested in partial recovery, I have hourly backups on my
secondary drive on my laptop (thankfully) and was able to boot from that
drive (double thankfully). Good thing I plan ahead :)

If there is something you'd like me to try to recover the filesystem
or to get more data off it to diagnose the bug, please let me know ASAP.

Otherwise, I'll just wipe it and recover from my disk backup, but
obviously this is bad.


Details:
My system didn't crash, but the filesystem went read only, and of course
couldn't syslog the error.
Thankfully I was saved by remote syslog which did work:

kernel: [545039.443412] ------------[ cut here ]------------
kernel: [545039.443429] WARNING: CPU: 2 PID: 556 at fs/btrfs/inode.c:4927 btrfs_invalidate_inode

kernel: [545039.443432] Modules linked in: e1000e iwlmvm mac80211 iwlwifi cfg80211 xhci_hcd usb_storage rndis_host cdc_ether btusb uvcvideo usbnet ehci_pci ehci_hcd usbcore usb_common tun sg nls_utf8 nls_cp437 vfat fat rpcsec_gss_krb5 nfsv4 ctr ccm ipt_MASQUERADE ipt_REJECT xt_tcpudp xt_conntrack xt_LOG iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ppdev cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats rfcomm bnep autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc configs parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t ecryptfs videobuf2_vmalloc videobuf2_memops videobuf2_core videodev bluetooth 6lowpan_iphc media joydev arc4 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss thinkpad_acpi x86_pkg_temp_thermal s
kernel: nd_pcm intel_powerclamp nvram coretemp snd_seq_midi snd_seq_midi_event kvm_intel snd_rawmidi kvm crct10dif_pclmul snd_seq crc32_pclmul rtsx_pci_ms iTCO_wdt iTCO_vendor_support ghash_clmulni_intel snd_seq_device memstick rtsx_pci_sdmmc snd_timer lpc_ich pcspkr microcode psmouse i2c_i801 serio_raw snd rtsx_pci soundcore tpm_tis rfkill tpm ac battery intel_smartconnect wmi evdev processor sata_sil24 r8169 mii fuse fan raid456 multipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common ecb xts crc32c_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd ptp pps_core thermal [last unloaded: e1000e]
kernel: [545039.443693] CPU: 2 PID: 556 Comm: btrfs-transacti Tainted: G        W    3.14.0-amd64-i915-preempt-20140216 #2
kernel: [545039.443697] Hardware name: LENOVO 20BECT0/20BECT0, BIOS GMET28WW (1.08 ) 09/18/2013
kernel: [545039.443701]  0000000000000000 ffff8800cd9f3d80 ffffffff8160a06d 0000000000000000
kernel: [545039.443718]  ffff8800cd9f3db8 ffffffff81050025 ffffffff81234676 ffff88040665c000
kernel: [545039.443727]  ffff8800cd9f3e30 ffff880406f708b8 ffff880402181000 ffff8800cd9f3dc8
kernel: [545039.443735] Call Trace:
kernel: [545039.443746]  [<ffffffff8160a06d>] dump_stack+0x4e/0x7a
kernel: [545039.443754]  [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
kernel: [545039.443761]  [<ffffffff81234676>] ? btrfs_invalidate_inodes+0x2f/0x12e
kernel: [545039.443768]  [<ffffffff810500ec>] warn_slowpath_null+0x1a/0x1c
kernel: [545039.443775]  [<ffffffff81234676>] btrfs_invalidate_inodes+0x2f/0x12e
kernel: [545039.443784]  [<ffffffff81227ac3>] btrfs_cleanup_transaction+0x3b2/0x43f
kernel: [545039.443792]  [<ffffffff81227c92>] transaction_kthread+0x142/0x1ab
kernel: [545039.443799]  [<ffffffff81227b50>] ? btrfs_cleanup_transaction+0x43f/0x43f
kernel: [545039.443807]  [<ffffffff8106bc62>] kthread+0xae/0xb6
kernel: [545039.443815]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
kernel: [545039.443822]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
kernel: [545039.443829]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
kernel: [545039.443834] ---[ end trace 3c290eaa69000df6 ]---

Now, if I try to mount it, I get:
[   17.234587] BTRFS: device label btrfs_pool1 devid 1 transid 415424 /dev/mapper/cryptroot
[   17.236873] BTRFS info (device dm-0): disk space caching is enabled
[   17.243687] BTRFS: bad tree block start 10983188636980216968 828930883584
[   17.245986] BTRFS: bad tree block start 12509109177217855588 828930883584
[   17.248174] BTRFS: failed to read tree root on dm-0
[   17.325141] BTRFS: open_ctree failed

mount -o ro,recovery gives:
[  412.572216] BTRFS: device label btrfs_pool1 devid 1 transid 415424 /dev/mapper/cryptroot
[  412.578600] BTRFS info (device dm-0): enabling auto recovery
[  412.583909] BTRFS info (device dm-0): disk space caching is enabled
[  412.599632] BTRFS: bad tree block start 10983188636980216968 828930883584
[  412.605190] BTRFS: bad tree block start 12509109177217855588 828930883584
[  412.610445] BTRFS: failed to read tree root on dm-0
[  412.615896] BTRFS: bad tree block start 10983188636980216968 828930883584
[  412.621459] BTRFS: bad tree block start 12509109177217855588 828930883584
[  412.626794] BTRFS: failed to read tree root on dm-0
[  412.632355] BTRFS: bad tree block start 10465696880878932228 828882554880
[  412.637921] BTRFS: bad tree block start 8442014916494136414 828882554880
[  412.643252] BTRFS: failed to read tree root on dm-0
[  412.648738] BTRFS: bad tree block start 16892086149828987133 828897542144
[  412.654324] BTRFS: bad tree block start 17864066398688830563 828897542144
[  412.659695] BTRFS: failed to read tree root on dm-0
[  412.665244] BTRFS: bad tree block start 3969089671017586869 828894318592
[  412.670803] BTRFS: bad tree block start 1948266299093993947 828894318592
[  412.676135] BTRFS: failed to read tree root on dm-0
[  412.782052] BTRFS: open_ctree failed

btrfs-zero-log did not help.

Anything else I should do?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
