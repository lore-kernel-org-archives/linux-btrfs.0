Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7860C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 20:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 648992087C
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 20:02:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjEapWOb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfBYUCj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 15:02:39 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51159 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfBYUCj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 15:02:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id x7so211860wmj.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 12:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:openpgp:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gLURVW1CZINppMVbkMwW4fxeuo0zv33+fEoyCpfith8=;
        b=SjEapWObbjV9tCDSnJXfGHn2hWn0QCLP062KzXUdZOLTnxJ4onTPZqvEvmKnAP+Goi
         OMQfonG1ISqOm8qrKUjUXJWgkLM2nf7wOSZiGziKhvgKCEkkr7KD1FJkUMEA8JDKiUwf
         uyGXUVKZLm40PFl4THGwGiG1Em7DWnLfOqV63taNOs7BkSYeokIu7+mdwpZ8cYSPhZXH
         JrW4zZFjrgN74YQo9rzpiMbViOHq2b6fWSQZ8QWH1EIAC59SPV4TAsXkfQBxGotUnXLT
         k8Sm1FXcNiVi6CZxXLt8Q1z6lv5wyAKDC9LK1INRy4Emqzt2/KX/FWfvsweviG3xum0D
         vdrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:openpgp:autocrypt:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=gLURVW1CZINppMVbkMwW4fxeuo0zv33+fEoyCpfith8=;
        b=rbwGV9PwoAg71GNnIjCP2l9x1csX90lkhg9WjhxOcdkf3whSb5VVrXCxIuApOG5svw
         zgRNjrY2oYZ1Lh8BUKMXOfeZ/zK+c7b/rnsz9eub5loUmy//nlDtMHb3daJoHG+dVE+G
         OR71svaTcccCqGgN6jHDdLrwPmjqjc7LFwTwvr+hy3h69gv2FQEdJAAdscDyUiw0bmn8
         I5G0dSVzw/fxTKCPd957kDj1KNeFqLCprUim6iMQkju+Kmi0hLwTjXIBzgAuxA3Fo9Bg
         90Rqr0njrt46+KmcVxb4D7a5ZoXE6EYFDtfiD4dHfixDAEDj8YGEbYyiKqUsBTYorv2A
         ZQ7A==
X-Gm-Message-State: AHQUAuatw3bwK2V4E4ugkwfsv/RYns61mM7ZXeiFgLZ6764XFLIFVTyJ
        /N4Yw3mxdwrWWQyfmozMMfC0xxTE
X-Google-Smtp-Source: AHgI3IYaSV+tisSKe42neBVGcLUA8mZIkx4W/5K/1RTiXXw98EEKF8idskkrwmxRxdUHIEMCqXwuog==
X-Received: by 2002:a1c:7ec4:: with SMTP id z187mr288254wmc.43.1551124955075;
        Mon, 25 Feb 2019 12:02:35 -0800 (PST)
Received: from home.thecybershadow.net ([89.28.117.31])
        by smtp.gmail.com with ESMTPSA id d15sm22227939wrw.36.2019.02.25.12.02.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 12:02:34 -0800 (PST)
To:     linux-btrfs@vger.kernel.org
From:   Vladimir Panteleev <thecybershadow@gmail.com>
Subject: 4.20: "btrfs_run_delayed_refs:2978: errno=-28 No space left" >100GB
 unallocated / >400G free?
Openpgp: preference=signencrypt
Autocrypt: addr=thecybershadow@gmail.com; prefer-encrypt=mutual; keydata=
 mQENBFar2yQBCADWo1C5Ir1smytf7+vWGCEoZgb/4XKkxrp+GUO7eJO8iYCWHTmCPZpi6p/z
 y6eh+NYcDQSRzKA99ffgdN+aT8/L6d63pYdsgtDmX/yrFWyLOVgW62LQpC/To4MTJAIgY/Rg
 /VjdifOJtYFvr+BKJwFCTfcviy4EQjsfHLnyJjvL9BiCXfSBXASc/Gn9WOTL5ZNpk4TStGXO
 +/2PIKeg228LtJ5vc/vemBo4hcjJv9ttX7dCebpSAbNo7GgOs8XNgJU2mEcra3IMT15dGk0/
 KpGMx7bMinTIlxx/BAGt5M5w8OnNi4p2AcKzvH18OTE7Lssn5ub8Ains32hbUFf18hJbABEB
 AAG0K1ZsYWRpbWlyIFBhbnRlbGVldiA8Z3BnQHRoZWN5YmVyc2hhZG93Lm5ldD6JAVEEEwEI
 ADsCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AWIQS77RsIjO1/lYkX++hQBPD60FFXbQUC
 WJ9eKQIZAQAKCRBQBPD60FFXbX0yB/9PEcY3H9mEZtU1UVqxLzPMVXUX5Khk6RD3Jt8/V7aA
 vu8VO4qwmnhadRPHXxVwnnVotao9d5U1zHw0gDhvJWelGRm52mKAPtyPwtBy4y3oXzymLfOM
 RIZxwxMY5RkbqdgWNEY7tCplABnWmaUMm5qDIjzkbEabpiqGySMy2gy6lQHUdRHcgFqO+ceZ
 R7IOPEh2fnVuQc5t1V56OHHRQZMQLgGupInST+svryv2sfr5+ZJqtwWL3nn8aFER6eIWzDDu
 m9y2RZnykbfwd56c81bpY6qqZtHkyt0hImkOwOiBj3UWtJvgZ95WnJ8NBPHPcttgL3vQTsXu
 BRYEjQZln81tuQENBFar2yQBCADFGh8NqHMtBT8F4m/UzQx0QAMDyPQN3CjKn67gW//8gd5v
 TmZCws2TwjaGlrJmwhGseUkZ368dth5vZLPu95MVSo2TBGf+XIVPsGzX6cuIRNtvQOT5YSUz
 uOghU0wh5gjw7evg7d0qfZRTZ2/JAuWmeTvPl66dasUoqKxVrq5o2MXdYkI6KoSxTsal3/36
 ii5cl2GfzE+bVAj3MB8B0ktdIZCHAJT8n+8h10/5TD5oEkWjhWdATeWMrC2bZwFykgSKjY/3
 jUvmfeyJp56sw5w3evZLQdQCo+NWoFGHdHBm0onyZbgbWS+2DEQI+ee0t6q6/iR1tf8VPX2U
 LY0jjiZ7ABEBAAGJAR8EGAEIAAkFAlar2yQCGwwACgkQUATw+tBRV200GQf8CaQxTy7OhWQ5
 O47G3+yKuBxDnYoP9h+T/sKcWsOUgy7i/vbqfkJvrqME8rRiO9YB/1/no1KqXm+gq0rSeZjy
 DA3mk9pNKvreHX9VO1md4r/vZF6jTwxNI7K97T34hZJGUQqsGzd8kMAvrgP199tXGG2+NOXv
 ih44I0of/VFFklNmO87y/Vn5F8OfNzwiHLNleBXZ1bMp/QBMd3HtahZVk7xRMNAKYqkyvI/C
 z0kgoHYP9wKpSmbPXJ5Qq0ndAJ7KIRcIwwDcbh3/F9Icj/N3v0SpxuJO7l0KlXQIWQ7TSpaO
 liYT2ARnGHHYcE2OhA0ixGV3Y3suUhk+GQaRQoiytw==
Message-ID: <981b2492-8dac-f008-523e-00cccdef5eb5@gmail.com>
Date:   Mon, 25 Feb 2019 20:02:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I am having this problem again with my RAID10 btrfs filesystem.

I have some nightly cronjobs which create and copy over snapshots.
Lately, they cause the filesystem to crash with "No space left", despite 
there being more than a hundred GB unallocated on all drives.

Following the advice in the previous thread [0], I enabled enospc_debug. 
Here is the dmegs output before the crash:

[55162.474274] BTRFS info (device sde1): space_info total=248034361344, 
used=246433710080, pinned=954941440, reserved=41959424, 
may_use=603439104, readonly=131072
[55162.484670] BTRFS info (device sde1): space_info 4 has 0 free, is not 
full
[55162.484673] BTRFS info (device sde1): space_info total=248034361344, 
used=246433710080, pinned=954941440, reserved=42254336, 
may_use=603324416, readonly=131072
[55162.613325] BTRFS info (device sde1): space_info 4 has 180224 free, 
is not full
[55162.613327] BTRFS info (device sde1): space_info total=248034361344, 
used=246433710080, pinned=954941440, reserved=45547520, 
may_use=599851008, readonly=131072
[55236.827153] ------------[ cut here ]------------
[55236.827155] BTRFS: block rsv returned -28
[55236.827221] WARNING: CPU: 11 PID: 22800 at 
fs/btrfs/extent-tree.c:8230 btrfs_alloc_tree_block+0x21b/0x5b0 [btrfs]
[55236.827222] Modules linked in: xt_REDIRECT tcp_diag inet_diag 
scsi_transport_iscsi fuse ccm xt_nat vhost_net vhost tap iptable_mangle 
xt_CHECKSUM xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp 
ebtable_filter ebtables devlink ip6table_filter ip6_tables 
iptable_filter sit tunnel4 ip_tunnel bnep uinput it87 hwmon_vid 8021q 
garp mrp ipt_MASQUERADE iptable_nat nls_iso8859_1 nf_nat_ipv4 nls_cp437 
nf_nat vfat nf_conntrack fat nf_defrag_ipv6 nf_defrag_ipv4 intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel amdgpu kvm 
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ath9k 
aesni_intel uvcvideo chash amd_iommu_v2 aes_x86_64 crypto_simd 
ath9k_common gpu_sched cryptd videobuf2_vmalloc ath9k_hw 
videobuf2_memops mxm_wmi iTCO_wdt glue_helper ath3k btusb 
snd_hda_codec_hdmi videobuf2_v4l2 iTCO_vendor_support i2c_algo_bit 
intel_cstate ath snd_hda_codec_realtek snd_hda_codec_generic mac80211 
ttm videobuf2_common btrtl intel_uncore btbcm btintel snd_usb_audio 
drm_kms_helper
[55236.827246]  snd_hda_intel videodev snd_usbmidi_lib bluetooth 
intel_rapl_perf snd_hda_codec snd_rawmidi i2c_i801 drm snd_seq_device 
snd_hda_core mousedev pl2303 snd_hwdep media rndis_host input_leds 
cdc_ether joydev usbnet r8169 snd_pcm cfg80211 ecdh_generic mii agpgart 
crc16 lpc_ich realtek snd_timer syscopyarea sysfillrect sysimgblt snd 
e1000e mei_me libphy mei fb_sys_fops soundcore rfkill wmi pcc_cpufreq 
bridge stp llc evdev tun mac_hid sg crypto_user ip_tables x_tables btrfs 
libcrc32c crc32c_generic xor raid6_pq sr_mod sd_mod cdrom hid_generic 
usbhid hid isci libsas ahci scsi_transport_sas libahci xhci_pci libata 
crc32c_intel firewire_ohci xhci_hcd firewire_core ehci_pci scsi_mod 
crc_itu_t ehci_hcd
[55236.827269] CPU: 11 PID: 22800 Comm: btrfs Not tainted 
4.20.11-arch2-1-ARCH #1
[55236.827270] Hardware name: Gigabyte Technology Co., Ltd. To be filled 
by O.E.M./X79S-UP5, BIOS F5f 03/19/2014
[55236.827280] RIP: 0010:btrfs_alloc_tree_block+0x21b/0x5b0 [btrfs]
[55236.827282] Code: 48 c7 c7 40 c5 72 c0 89 44 24 28 e8 7f f1 5e f3 8b 
54 24 28 85 c0 0f 84 36 ff ff ff 89 d6 48 c7 c7 78 16 6e c0 e8 af 14 e5 
f2 <0f> 0b e9 21 ff ff ff 49 8b 84 24 f0 01 00 00 48 8b 74 24 37 48 89
[55236.827282] RSP: 0018:ffffbe0ca27b76e0 EFLAGS: 00010282
[55236.827283] RAX: 0000000000000000 RBX: ffffa381f884c000 RCX: 
0000000000000000
[55236.827284] RDX: 0000000000000007 RSI: ffffffffb44a42fe RDI: 
00000000ffffffff
[55236.827285] RBP: 0000000000004000 R08: 0000000000000001 R09: 
0000000000003749
[55236.827285] R10: 0000000000000004 R11: 0000000000000000 R12: 
ffffa381e3c72000
[55236.827286] R13: ffffa381dfcbdf08 R14: ffffa381f884c130 R15: 
0000000000000001
[55236.827287] FS:  00007fc4f3b6c8c0(0000) GS:ffffa381ffac0000(0000) 
knlGS:0000000000000000
[55236.827288] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[55236.827288] CR2: 000001083ba8a398 CR3: 0000000d62dde004 CR4: 
00000000001626e0
[55236.827289] Call Trace:
[55236.827297]  ? __set_page_dirty_nobuffers+0x10e/0x150
[55236.827306]  alloc_tree_block_no_bg_flush+0x47/0x50 [btrfs]
[55236.827315]  __btrfs_cow_block+0x11b/0x500 [btrfs]
[55236.827324]  btrfs_cow_block+0xdc/0x1a0 [btrfs]
[55236.827332]  btrfs_search_slot+0x368/0x990 [btrfs]
[55236.827342]  lookup_inline_extent_backref+0x186/0x610 [btrfs]
[55236.827354]  ? set_extent_bit+0x19/0x20 [btrfs]
[55236.827364]  ? update_block_group.isra.24+0x10d/0x3a0 [btrfs]
[55236.827374]  __btrfs_free_extent.isra.25+0xed/0x940 [btrfs]
[55236.827377]  ? _raw_spin_lock+0x13/0x30
[55236.827378]  ? _raw_spin_unlock+0x16/0x30
[55236.827390]  ? btrfs_merge_delayed_refs+0x315/0x350 [btrfs]
[55236.827400]  __btrfs_run_delayed_refs+0x6f2/0x10e0 [btrfs]
[55236.827410]  btrfs_run_delayed_refs+0x64/0x180 [btrfs]
[55236.827421]  btrfs_commit_transaction+0x8a/0x870 [btrfs]
[55236.827432]  ? start_transaction+0x9c/0x3f0 [btrfs]
[55236.827444]  btrfs_mksubvol+0x49c/0x4e0 [btrfs]
[55236.827447]  ? kmem_cache_alloc_trace+0x176/0x1d0
[55236.827459]  btrfs_ioctl_snap_create_transid+0x170/0x180 [btrfs]
[55236.827471]  btrfs_ioctl_snap_create_v2+0x124/0x180 [btrfs]
[55236.827484]  btrfs_ioctl+0xc07/0x2cd0 [btrfs]
[55236.827486]  ? __lru_cache_add+0x75/0xa0
[55236.827487]  ? _raw_spin_unlock+0x16/0x30
[55236.827489]  ? __handle_mm_fault+0x973/0x1620
[55236.827492]  ? do_vfs_ioctl+0xa4/0x630
[55236.827493]  do_vfs_ioctl+0xa4/0x630
[55236.827495]  ? handle_mm_fault+0x10a/0x250
[55236.827497]  ? syscall_trace_enter+0x1d3/0x2d0
[55236.827499]  ksys_ioctl+0x60/0x90
[55236.827501]  __x64_sys_ioctl+0x16/0x20
[55236.827502]  do_syscall_64+0x5b/0x170
[55236.827504]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[55236.827506] RIP: 0033:0x7fc4f3c6180b
[55236.827507] Code: 0f 1e fa 48 8b 05 55 b6 0c 00 64 c7 00 26 00 00 00 
48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 25 b6 0c 00 f7 d8 64 89 01 48
[55236.827508] RSP: 002b:00007ffcfa9619d8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[55236.827509] RAX: ffffffffffffffda RBX: 00007ffcfa961a20 RCX: 
00007fc4f3c6180b
[55236.827509] RDX: 00007ffcfa961a20 RSI: 0000000050009417 RDI: 
0000000000000003
[55236.827510] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000003
[55236.827511] R10: 0000000000000016 R11: 0000000000000246 R12: 
000055a56451f260
[55236.827511] R13: 000055a56451f2a0 R14: 0000000000000004 R15: 
000055a56451f2a0
[55236.827513] ---[ end trace 5eaaa8d3e0cd90ec ]---
[55236.827516] BTRFS info (device sde1): space_info 4 has 0 free, is not 
full
[55236.827517] BTRFS info (device sde1): space_info total=248034361344, 
used=246349135872, pinned=1571045376, reserved=48234496, 
may_use=65814528, readonly=131072
[55236.827518] ------------[ cut here ]------------
[55236.827519] BTRFS: Transaction aborted (error -28)
[55236.827539] WARNING: CPU: 11 PID: 22800 at 
fs/btrfs/extent-tree.c:6831 __btrfs_free_extent.isra.25+0x22c/0x940 [btrfs]
[55236.827539] Modules linked in: xt_REDIRECT tcp_diag inet_diag 
scsi_transport_iscsi fuse ccm xt_nat vhost_net vhost tap iptable_mangle 
xt_CHECKSUM xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp 
ebtable_filter ebtables devlink ip6table_filter ip6_tables 
iptable_filter sit tunnel4 ip_tunnel bnep uinput it87 hwmon_vid 8021q 
garp mrp ipt_MASQUERADE iptable_nat nls_iso8859_1 nf_nat_ipv4 nls_cp437 
nf_nat vfat nf_conntrack fat nf_defrag_ipv6 nf_defrag_ipv4 intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp arc4 kvm_intel amdgpu kvm 
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ath9k 
aesni_intel uvcvideo chash amd_iommu_v2 aes_x86_64 crypto_simd 
ath9k_common gpu_sched cryptd videobuf2_vmalloc ath9k_hw 
videobuf2_memops mxm_wmi iTCO_wdt glue_helper ath3k btusb 
snd_hda_codec_hdmi videobuf2_v4l2 iTCO_vendor_support i2c_algo_bit 
intel_cstate ath snd_hda_codec_realtek snd_hda_codec_generic mac80211 
ttm videobuf2_common btrtl intel_uncore btbcm btintel snd_usb_audio 
drm_kms_helper
[55236.827555]  snd_hda_intel videodev snd_usbmidi_lib bluetooth 
intel_rapl_perf snd_hda_codec snd_rawmidi i2c_i801 drm snd_seq_device 
snd_hda_core mousedev pl2303 snd_hwdep media rndis_host input_leds 
cdc_ether joydev usbnet r8169 snd_pcm cfg80211 ecdh_generic mii agpgart 
crc16 lpc_ich realtek snd_timer syscopyarea sysfillrect sysimgblt snd 
e1000e mei_me libphy mei fb_sys_fops soundcore rfkill wmi pcc_cpufreq 
bridge stp llc evdev tun mac_hid sg crypto_user ip_tables x_tables btrfs 
libcrc32c crc32c_generic xor raid6_pq sr_mod sd_mod cdrom hid_generic 
usbhid hid isci libsas ahci scsi_transport_sas libahci xhci_pci libata 
crc32c_intel firewire_ohci xhci_hcd firewire_core ehci_pci scsi_mod 
crc_itu_t ehci_hcd
[55236.827570] CPU: 11 PID: 22800 Comm: btrfs Tainted: G        W 
   4.20.11-arch2-1-ARCH #1
[55236.827571] Hardware name: Gigabyte Technology Co., Ltd. To be filled 
by O.E.M./X79S-UP5, BIOS F5f 03/19/2014
[55236.827581] RIP: 0010:__btrfs_free_extent.isra.25+0x22c/0x940 [btrfs]
[55236.827581] Code: 24 48 8b 40 50 f0 48 0f ba a8 90 12 00 00 02 72 1b 
41 83 fd fb 0f 84 ee 15 09 00 44 89 ee 48 c7 c7 80 12 6e c0 e8 2e f3 e4 
f2 <0f> 0b 48 8b 3c 24 44 89 e9 ba af 1a 00 00 48 c7 c6 a0 6c 6d c0 e8
[55236.827582] RSP: 0018:ffffbe0ca27b79d0 EFLAGS: 00010286
[55236.827583] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
0000000000000000
[55236.827584] RDX: 0000000000000007 RSI: ffffffffb44a42fe RDI: 
00000000ffffffff
[55236.827584] RBP: 0000055aa404c000 R08: 0000000000000001 R09: 
0000000000003787
[55236.827585] R10: 0000000000000004 R11: 0000000000000000 R12: 
ffffa3796903ccb0
[55236.827585] R13: 00000000ffffffe4 R14: 0000000000000000 R15: 
0000000000000002
[55236.827586] FS:  00007fc4f3b6c8c0(0000) GS:ffffa381ffac0000(0000) 
knlGS:0000000000000000
[55236.827587] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[55236.827588] CR2: 000001083ba8a398 CR3: 0000000d62dde004 CR4: 
00000000001626e0
[55236.827588] Call Trace:
[55236.827591]  ? _raw_spin_lock+0x13/0x30
[55236.827592]  ? _raw_spin_unlock+0x16/0x30
[55236.827604]  ? btrfs_merge_delayed_refs+0x315/0x350 [btrfs]
[55236.827613]  __btrfs_run_delayed_refs+0x6f2/0x10e0 [btrfs]
[55236.827624]  btrfs_run_delayed_refs+0x64/0x180 [btrfs]
[55236.827634]  btrfs_commit_transaction+0x8a/0x870 [btrfs]
[55236.827645]  ? start_transaction+0x9c/0x3f0 [btrfs]
[55236.827656]  btrfs_mksubvol+0x49c/0x4e0 [btrfs]
[55236.827658]  ? kmem_cache_alloc_trace+0x176/0x1d0
[55236.827670]  btrfs_ioctl_snap_create_transid+0x170/0x180 [btrfs]
[55236.827683]  btrfs_ioctl_snap_create_v2+0x124/0x180 [btrfs]
[55236.827699]  btrfs_ioctl+0xc07/0x2cd0 [btrfs]
[55236.827701]  ? __lru_cache_add+0x75/0xa0
[55236.827703]  ? _raw_spin_unlock+0x16/0x30
[55236.827704]  ? __handle_mm_fault+0x973/0x1620
[55236.827706]  ? do_vfs_ioctl+0xa4/0x630
[55236.827708]  do_vfs_ioctl+0xa4/0x630
[55236.827709]  ? handle_mm_fault+0x10a/0x250
[55236.827711]  ? syscall_trace_enter+0x1d3/0x2d0
[55236.827712]  ksys_ioctl+0x60/0x90
[55236.827714]  __x64_sys_ioctl+0x16/0x20
[55236.827715]  do_syscall_64+0x5b/0x170
[55236.827717]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[55236.827718] RIP: 0033:0x7fc4f3c6180b
[55236.827719] Code: 0f 1e fa 48 8b 05 55 b6 0c 00 64 c7 00 26 00 00 00 
48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 25 b6 0c 00 f7 d8 64 89 01 48
[55236.827719] RSP: 002b:00007ffcfa9619d8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[55236.827720] RAX: ffffffffffffffda RBX: 00007ffcfa961a20 RCX: 
00007fc4f3c6180b
[55236.827721] RDX: 00007ffcfa961a20 RSI: 0000000050009417 RDI: 
0000000000000003
[55236.827722] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000003
[55236.827722] R10: 0000000000000016 R11: 0000000000000246 R12: 
000055a56451f260
[55236.827723] R13: 000055a56451f2a0 R14: 0000000000000004 R15: 
000055a56451f2a0
[55236.827724] ---[ end trace 5eaaa8d3e0cd90ed ]---
[55236.827726] BTRFS: error (device sde1) in __btrfs_free_extent:6831: 
errno=-28 No space left
[55236.827729] BTRFS info (device sde1): forced readonly
[55236.827731] BTRFS: error (device sde1) in 
btrfs_run_delayed_refs:2978: errno=-28 No space left
[55249.261261] BTRFS info (device sde1): space_info 4 has 0 free, is not 
full
[55249.261264] BTRFS info (device sde1): space_info total=248034361344, 
used=246349135872, pinned=1570668544, reserved=48234496, 
may_use=66191360, readonly=131072
[55249.261291] BTRFS info (device sde1): space_info 4 has 0 free, is not 
full
[55249.261292] BTRFS info (device sde1): space_info total=248034361344, 
used=246349135872, pinned=1570652160, reserved=48250880, 
may_use=66191360, readonly=131072
[55296.123993] INFO: task kworker/u24:21:26558 blocked for more than 120 
seconds.
[55296.123997]       Tainted: G        W         4.20.11-arch2-1-ARCH #1
[55296.123998] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[55296.124000] kworker/u24:21  D    0 26558      2 0x80000080
[55296.124026] Workqueue: events_unbound 
btrfs_async_reclaim_metadata_space [btrfs]
[55296.124027] Call Trace:
[55296.124033]  ? __schedule+0x29b/0x8b0
[55296.124036]  ? preempt_count_add+0x79/0xb0
[55296.124038]  schedule+0x32/0x90
[55296.124041]  wb_wait_for_completion+0x59/0x90
[55296.124045]  ? wait_woken+0x80/0x80
[55296.124046]  __writeback_inodes_sb_nr+0xaa/0xd0
[55296.124056]  flush_space+0x39c/0x5a0 [btrfs]
[55296.124059]  ? __switch_to_asm+0x34/0x70
[55296.124069]  btrfs_async_reclaim_metadata_space+0xc1/0x480 [btrfs]
[55296.124072]  process_one_work+0x1eb/0x410
[55296.124074]  worker_thread+0x2d/0x3d0
[55296.124075]  ? process_one_work+0x410/0x410
[55296.124077]  kthread+0x112/0x130
[55296.124078]  ? kthread_park+0x80/0x80
[55296.124079]  ret_from_fork+0x35/0x40

I don't understand how this can happen when there is plenty of space 
available:

$ df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/sde1        15T   15T  340G  98% /mnt/archive2016

$ btrfs filesystem show .
Label: none  uuid: 6cd405b7-4f6e-47de-926e-f7c280eacbb0
	Total devices 4 FS bytes used 14.12TiB
	devid    1 size 7.28TiB used 7.16TiB path /dev/sde1
	devid    2 size 7.28TiB used 7.16TiB path /dev/sdh1
	devid    3 size 7.28TiB used 7.06TiB path /dev/sdc1
	devid    4 size 7.28TiB used 7.06TiB path /dev/sdd1


$ btrfs filesystem df .
Data, RAID10: total=13.99TiB, used=13.89TiB
System, RAID1: total=8.00MiB, used=1.47MiB
Metadata, RAID1: total=230.00GiB, used=229.03GiB
GlobalReserve, single: total=512.00MiB, used=471.50MiB

$ btrfs filesystem usage .
Overall:
     Device size:		  29.11TiB
     Device allocated:		  28.43TiB
     Device unallocated:		 696.12GiB
     Device missing:		     0.00B
     Used:			  28.24TiB
     Free (estimated):		 445.56GiB	(min: 445.56GiB)
     Data ratio:			      2.00
     Metadata ratio:		      2.00
     Global reserve:		 512.00MiB	(used: 471.50MiB)

Data,RAID10: Size:13.99TiB, Used:13.89TiB
    /dev/sdc1	   7.00TiB
    /dev/sdd1	   7.00TiB
    /dev/sde1	   7.00TiB
    /dev/sdh1	   7.00TiB

Metadata,RAID1: Size:230.00GiB, Used:229.03GiB
    /dev/sdc1	  62.00GiB
    /dev/sdd1	  62.00GiB
    /dev/sde1	 168.00GiB
    /dev/sdh1	 168.00GiB

System,RAID1: Size:8.00MiB, Used:1.47MiB
    /dev/sde1	   8.00MiB
    /dev/sdh1	   8.00MiB

Unallocated:
    /dev/sdc1	 227.04GiB
    /dev/sdd1	 227.04GiB
    /dev/sde1	 121.03GiB
    /dev/sdh1	 121.03GiB

$ btrfs device usage .
/dev/sdc1, ID: 3
    Device size:             7.28TiB
    Device slack:              0.00B
    Data,RAID10:             7.00TiB
    Metadata,RAID1:         62.00GiB
    Unallocated:           227.04GiB

/dev/sdd1, ID: 4
    Device size:             7.28TiB
    Device slack:            3.50KiB
    Data,RAID10:             7.00TiB
    Metadata,RAID1:         62.00GiB
    Unallocated:           227.04GiB

/dev/sde1, ID: 1
    Device size:             7.28TiB
    Device slack:              0.00B
    Data,RAID10:             7.00TiB
    Metadata,RAID1:        168.00GiB
    System,RAID1:            8.00MiB
    Unallocated:           121.03GiB

/dev/sdh1, ID: 2
    Device size:             7.28TiB
    Device slack:              0.00B
    Data,RAID10:             7.00TiB
    Metadata,RAID1:        168.00GiB
    System,RAID1:            8.00MiB
    Unallocated:           121.03GiB

Any advice would be appreciated.

[0]: https://www.spinics.net/lists/linux-btrfs/msg70316.html

-- 
Best regards,
  Vladimir
