Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.unitix.de ([176.9.2.175]:53142 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756996Ab2FYQMX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 12:12:23 -0400
Message-ID: <4FE88DDD.6050702@arndnet.de>
Date: Mon, 25 Jun 2012 18:12:13 +0200
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: martin@tuxadero.com
CC: linux-btrfs@vger.kernel.org, liubo2009@cn.fujitsu.com, dave@jikos.cz
Subject: 3.5.0-rc4: WARNING: at fs/btrfs/super.c:221 __btrfs_abort_transaction+0xae/0xc0
  (was: Re: 3.4.0-rc6:...)
References: <4FB10636.2010003@arndnet.de> <20120514150509.GJ25501@twin.jikos.cz> <4FB4BFA4.2090402@tuxadero.com>
In-Reply-To: <4FB4BFA4.2090402@tuxadero.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

still seeing this warning (well the line number changed) on 3.5.0 (rc4):

[   11.909589] ------------[ cut here ]------------
[   11.909616] WARNING: at /home/arnd/Projekte/kernel/linux-2.6/fs/btrfs/super.c:221 __btrfs_abort_transaction+0xae/0xc0 [btrfs]()
[   11.909617] Hardware name: 4384GEG
[   11.909619] btrfs: Transaction aborted
[   11.909648] Modules linked in: joydev deflate ctr bridge stp llc twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia_x86_64 serpent_sse2_x86_64 lrw serpent_generic xts gf128mul blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo dm_crypt bnep rfcomm bluetooth binfmt_misc arc4 snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm coretemp kvm_intel kvm snd_seq_midi snd_rawmidi thinkpad_acpi microcode snd_seq_midi_event qcserial usb_wwan usbserial snd_seq snd_timer psmouse snd_seq_device serio_raw intel_ips snd iwlwifi tpm_tis nvram lpc_ich soundcore mac80211 snd_page_alloc cfg80211 mei btrfs zlib_deflate libcrc32c mxm_wmi ghash_clmulni_intel aesni_intel cryptd aes_x86_64 i915 e1000e ahci libahci drm_kms_helper drm firewire_ohci i2c_algo_bit video firewire_core crc_itu_t wmi sdhci_pci sdhci
[   11.909651] Pid: 1509, comm: hybrid-detect Not tainted 3.5.0-rc4aha+ #6
[   11.909652] Call Trace:
[   11.909659]  [<ffffffff8105061f>] warn_slowpath_common+0x7f/0xc0
[   11.909661]  [<ffffffff81050716>] warn_slowpath_fmt+0x46/0x50
[   11.909669]  [<ffffffffa01c83e1>] ? do_chunk_alloc.isra.71+0x311/0x3f0 [btrfs]
[   11.909676]  [<ffffffffa01b6dde>] __btrfs_abort_transaction+0xae/0xc0 [btrfs]
[   11.909683]  [<ffffffffa01c90a5>] find_free_extent+0xbe5/0xc70 [btrfs]
[   11.909688]  [<ffffffff811239ed>] ? __free_pages+0x2d/0x40
[   11.909696]  [<ffffffffa01ccffd>] btrfs_reserve_extent+0xed/0x250 [btrfs]
[   11.909705]  [<ffffffffa01cd687>] btrfs_alloc_free_block+0x177/0x380 [btrfs]
[   11.909712]  [<ffffffffa01ba6c4>] __btrfs_cow_block+0x124/0x500 [btrfs]
[   11.909719]  [<ffffffffa01bab9c>] btrfs_cow_block+0xfc/0x220 [btrfs]
[   11.909726]  [<ffffffffa01bee04>] btrfs_search_slot+0x454/0x910 [btrfs]
[   11.909733]  [<ffffffffa01c9337>] ? reserve_metadata_bytes.isra.72+0x207/0x740 [btrfs]
[   11.909741]  [<ffffffffa01c0c5c>] btrfs_insert_empty_items+0x7c/0xe0 [btrfs]
[   11.909747]  [<ffffffffa01b979a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[   11.909758]  [<ffffffffa02155ef>] btrfs_insert_orphan_item+0x5f/0x90 [btrfs]
[   11.909768]  [<ffffffffa01e30eb>] btrfs_orphan_add+0xbb/0x180 [btrfs]
[   11.909778]  [<ffffffffa01e6fe0>] btrfs_truncate+0x140/0x650 [btrfs]
[   11.909782]  [<ffffffff8162abed>] ? mutex_lock+0x1d/0x50
[   11.909793]  [<ffffffffa01e8d3b>] btrfs_setattr+0xbb/0x1d0 [btrfs]
[   11.909797]  [<ffffffff81195b63>] notify_change+0x1c3/0x350
[   11.909801]  [<ffffffff81178cde>] do_truncate+0x5e/0xa0
[   11.909805]  [<ffffffff8118730d>] do_last+0x4cd/0x9e0
[   11.909808]  [<ffffffff81189b96>] path_openat+0xd6/0x440
[   11.909811]  [<ffffffff8118a022>] do_filp_open+0x42/0xa0
[   11.909814]  [<ffffffff81196cd1>] ? alloc_fd+0xd1/0x120
[   11.909816]  [<ffffffff81179ce8>] do_sys_open+0xf8/0x1d0
[   11.909819]  [<ffffffff811788d6>] ? filp_close+0x66/0x90
[   11.909820]  [<ffffffff81179de1>] sys_open+0x21/0x30
[   11.909824]  [<ffffffff816353e9>] system_call_fastpath+0x16/0x1b
[   11.909825] ---[ end trace 247ff970a7eff763 ]---
[   11.909827] BTRFS warning (device dm-4): Aborting unused transaction.

Best regards
Arnd
