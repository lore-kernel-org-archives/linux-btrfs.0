Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.unitix.de ([176.9.2.175]:34063 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab2EVQHW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 12:07:22 -0400
Message-ID: <4FBBB9B4.102@arndnet.de>
Date: Tue, 22 May 2012 18:07:16 +0200
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: martin@tuxadero.com
CC: linux-btrfs@vger.kernel.org, liubo2009@cn.fujitsu.com, dave@jikos.cz
Subject: Re: 3.4.0-rc6: WARNING: at fs/btrfs/super.c:219 __btrfs_abort_transaction+0xae/0xc0
 [btrfs]()
References: <4FB10636.2010003@arndnet.de> <20120514150509.GJ25501@twin.jikos.cz> <4FB4BFA4.2090402@tuxadero.com>
In-Reply-To: <4FB4BFA4.2090402@tuxadero.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I just got the same warning on a fresh 3.4.0 final while booting.
This time on /usr/share (different filesystem from last time):

arnd@kallisto:~$ ls -l /dev/mapper/vg0-usr_share
lrwxrwxrwx 1 root root 7 Mai 22 17:59 /dev/mapper/vg0-usr_share -> ../dm-4
arnd@kallisto:~$ grep usr_share /proc/mounts
/dev/mapper/vg0-usr_share /usr/share btrfs rw,relatime,compress=zlib,ssd,nospace_cache 0 0

[   12.326239] ------------[ cut here ]------------
[   12.326264] WARNING: at /home/arnd/Projekte/kernel/linux-2.6/fs/btrfs/super.c:219 __btrfs_abort_transaction+0xae/0xc0 [btrfs]()
[   12.326266] Hardware name: 4384GEG
[   12.326267] btrfs: Transaction aborted
[   12.326268] Modules linked in: joydev bridge stp llc kvm_intel kvm dm_crypt bnep rfcomm bluetooth binfmt_misc arc4 coretemp snd_hda_codec_hdmi snd_hda_codec_conexant thinkpad_acpi microcode snd_seq_midi psmouse snd_rawmidi serio_raw iwlwifi intel_ips qcserial usb_wwan usbserial mac80211 snd_hda_intel snd_seq_midi_event snd_hda_codec snd_seq snd_hwdep cfg80211 snd_seq_device snd_pcm snd_timer snd_page_alloc snd soundcore tpm_tis nvram mei(C) btrfs zlib_deflate libcrc32c mxm_wmi ghash_clmulni_intel aesni_intel cryptd aes_x86_64 i915 ahci libahci drm_kms_helper drm e1000e sdhci_pci sdhci firewire_ohci firewire_core i2c_algo_bit crc_itu_t video wmi
[   12.326297] Pid: 1471, comm: hybrid-detect Tainted: G         C   3.4.0aha+ #11
[   12.326298] Call Trace:
[   12.326305]  [<ffffffff8104e37f>] warn_slowpath_common+0x7f/0xc0
[   12.326307]  [<ffffffff8104e476>] warn_slowpath_fmt+0x46/0x50
[   12.326315]  [<ffffffffa01d37ec>] ? do_chunk_alloc.isra.71+0x31c/0x3f0 [btrfs]
[   12.326322]  [<ffffffffa01c3bde>] __btrfs_abort_transaction+0xae/0xc0 [btrfs]
[   12.326329]  [<ffffffffa01d44a5>] find_free_extent+0xbe5/0xc70 [btrfs]
[   12.326334]  [<ffffffff810125da>] ? __switch_to+0x17a/0x410
[   12.326341]  [<ffffffffa01d83fd>] btrfs_reserve_extent+0xed/0x250 [btrfs]
[   12.326350]  [<ffffffffa01d8a87>] btrfs_alloc_free_block+0x177/0x370 [btrfs]
[   12.326357]  [<ffffffffa01c6545>] __btrfs_cow_block+0x135/0x4d0 [btrfs]
[   12.326363]  [<ffffffffa01c69dc>] btrfs_cow_block+0xfc/0x220 [btrfs]
[   12.326370]  [<ffffffffa01ca9e4>] btrfs_search_slot+0x454/0x910 [btrfs]
[   12.326377]  [<ffffffffa01d4737>] ? reserve_metadata_bytes.isra.72+0x207/0x740 [btrfs]
[   12.326384]  [<ffffffffa01cc0bc>] btrfs_insert_empty_items+0x7c/0xe0 [btrfs]
[   12.326390]  [<ffffffffa01c586a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[   12.326401]  [<ffffffffa021fccf>] btrfs_insert_orphan_item+0x5f/0x90 [btrfs]
[   12.326429]  [<ffffffffa01ee155>] btrfs_orphan_add+0xc5/0x1c0 [btrfs]
[   12.326443]  [<ffffffffa01f22e6>] btrfs_truncate+0x146/0x650 [btrfs]
[   12.326449]  [<ffffffff812a21de>] ? security_inode_alloc+0x1e/0x20
[   12.326461]  [<ffffffffa01f4091>] btrfs_setattr+0xc1/0x1b0 [btrfs]
[   12.326464]  [<ffffffff8119074a>] notify_change+0x1aa/0x340
[   12.326467]  [<ffffffff811739fe>] do_truncate+0x5e/0xa0
[   12.326470]  [<ffffffff811833d1>] do_last+0x581/0x8f0
[   12.326472]  [<ffffffff81184ae2>] path_openat+0xd2/0x400
[   12.326474]  [<ffffffff81184f32>] do_filp_open+0x42/0xa0
[   12.326476]  [<ffffffff811918b1>] ? alloc_fd+0xd1/0x120
[   12.326478]  [<ffffffff811747a8>] do_sys_open+0xf8/0x1d0
[   12.326480]  [<ffffffff81173566>] ? filp_close+0x66/0x90
[   12.326482]  [<ffffffff811748a1>] sys_open+0x21/0x30
[   12.326485]  [<ffffffff81626f29>] system_call_fastpath+0x16/0x1b
[   12.326487] ---[ end trace 4479826ac6de5588 ]---
[   12.326489] BTRFS warning (device dm-4): Aborting unused transaction.

Best regards
Arnd
