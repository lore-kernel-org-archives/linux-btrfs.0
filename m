Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:25788 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab2JQPd1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Oct 2012 11:33:27 -0400
Message-ID: <507ECFB9.4070900@oracle.com>
Date: Wed, 17 Oct 2012 23:33:13 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] __tree_mod_log_rewind  makes extent buffers larger than
 leafsize
References: <507ECE60.7090309@oracle.com>
In-Reply-To: <507ECE60.7090309@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/17/2012 11:27 PM, Liu Bo wrote:
> [  103.354284] kernel BUG at fs/btrfs/ctree.c:1582!
> [  103.354305] invalid opcode: 0000 [#1] SMP 
> [  103.354326] Modules linked in: btrfs(O) tcp_lp zlib_deflate libcrc32c fuse lockd rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack i915 arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant btusb bluetooth snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iwlwifi snd_timer cfg80211 thinkpad_acpi snd soundcore wmi e1000e iTCO_wdt iTCO_vendor_support lpc_ich mfd_core uinput snd_page_alloc rfkill pcspkr coretemp crc32c_intel ghash_clmulni_intel drm_kms_helper drm joydev i2c_i801 microcode tpm_tis tpm tpm_bios i2c_algo_bit i2c_core video sunrpc sdhci_pci sdhci mmc_core [last unloaded: btrfs]
> [  103.354703] CPU 1 
> [  103.354715] Pid: 1866, comm: btrfs-endio-wri Tainted: G           O 3.6.0+ #4 LENOVO 4291HA6/4291HA6
> [  103.354753] RIP: 0010:[<ffffffffa05d3721>]  [<ffffffffa05d3721>] generic_bin_search.constprop.9+0x1f1/0x200 [btrfs]

This BUG_ON is from me, otherwise it'll go deeper and throw out general protection errors.

thanks,
liubo
