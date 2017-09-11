Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:45238 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdIKFpw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 01:45:52 -0400
Received: by mail-it0-f53.google.com with SMTP id v19so11609102ite.0
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Sep 2017 22:45:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG+QAKXZwsTmrNFYNk9RmbL1DZGZ-oAe1GykVRdBOFxkLTwH9g@mail.gmail.com>
References: <CAG+QAKXZwsTmrNFYNk9RmbL1DZGZ-oAe1GykVRdBOFxkLTwH9g@mail.gmail.com>
From: Rich Rauenzahn <rrauenza@gmail.com>
Date: Sun, 10 Sep 2017 22:45:50 -0700
Message-ID: <CAG+QAKXNhA3YCjLAp5yOam05-egoHgY4YszR3XJFF=vUC-+Cdg@mail.gmail.com>
Subject: Re: btrfs_remove_chunk call trace?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

...and can it be related to the Samsung 840 SSD's not supporting NCQ
Trim?  (Although I can't tell which device this trace is from -- it
could be a mechanical Western Digital.)

On Sun, Sep 10, 2017 at 10:16 PM, Rich Rauenzahn <rrauenza@gmail.com> wrote:
> Is this something to be concerned about?
>
> I'm running the latest mainline kernel on CentOS 7.
>
> [ 1338.882288] ------------[ cut here ]------------
> [ 1338.883058] WARNING: CPU: 2 PID: 790 at fs/btrfs/ctree.h:1559
> btrfs_update_device+0x1c5/0x1d0 [btrfs]
> [ 1338.883809] Modules linked in: xt_nat veth ipt_MASQUERADE
> nf_nat_masquerade_ipv4 xt_addrtype overlay loop nf_conntrack_ftp
> nf_log_ipv4 nf_log_common xt_LOG xt_limit xt_comment xt_recent
> xt_multiport xt_conntrack iptable_filter xt_REDIRECT nf_nat_redirect
> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nct6775
> nf_nat nf_conntrack hwmon_vid jc42 vfat fat dm_mirror dm_region_hash
> dm_log dm_mod dax xfs libcrc32c x86_pkg_temp_thermal intel_powerclamp
> coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_hdmi
> snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul
> snd_hda_intel ghash_clmulni_intel pcbc snd_hda_codec aesni_intel
> snd_hda_core iTCO_wdt snd_hwdep crypto_simd glue_helper cryptd
> iTCO_vendor_support snd_seq mei_wdt snd_seq_device intel_cstate
> cdc_acm snd_pcm intel_rapl_perf
> [ 1338.888639]  input_leds snd_timer lpc_ich i2c_i801 pcspkr
> intel_pch_thermal snd mfd_core sg mei_me soundcore mei acpi_pad shpchp
> ie31200_edac nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables
> btrfs xor raid6_pq sd_mod crc32c_intel ahci e1000e libahci
> firewire_ohci igb i915 dca firewire_core ptp i2c_algo_bit crc_itu_t
> libata pps_core drm_kms_helper syscopyarea sysfillrect sysimgblt
> fb_sys_fops drm video
> [ 1338.891412] CPU: 2 PID: 790 Comm: btrfs-cleaner Tainted: G        W
>       4.13.1-1.el7.elrepo.x86_64 #1
> [ 1338.892171] Hardware name: Supermicro X10SAE/X10SAE, BIOS 2.0a 05/09/2014
> [ 1338.892884] task: ffff880407cec5c0 task.stack: ffffc90002624000
> [ 1338.893613] RIP: 0010:btrfs_update_device+0x1c5/0x1d0 [btrfs]
> [ 1338.894299] RSP: 0018:ffffc90002627d00 EFLAGS: 00010206
> [ 1338.894956] RAX: 0000000000000fff RBX: ffff880407cd9930 RCX: 000001d1c1011e00
> [ 1338.895647] RDX: ffff880000000000 RSI: ffff880336e80f9e RDI: ffff88028395bd88
> [ 1338.896304] RBP: ffffc90002627d48 R08: 0000000000003fc2 R09: ffffc90002627cb8
> [ 1338.896934] R10: 0000000000001000 R11: 0000000000000003 R12: ffff880405f68c00
> [ 1338.897618] R13: 0000000000000000 R14: ffff88028395bd88 R15: 0000000000003f9e
> [ 1338.898251] FS:  0000000000000000(0000) GS:ffff88041fa80000(0000)
> knlGS:0000000000000000
> [ 1338.898867] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1338.899522] CR2: 00007ff82f2cb000 CR3: 0000000001c09000 CR4: 00000000001406e0
> [ 1338.900157] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1338.900772] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1338.901402] Call Trace:
> [ 1338.902017]  btrfs_remove_chunk+0x2fb/0x8b0 [btrfs]
> [ 1338.902673]  btrfs_delete_unused_bgs+0x363/0x440 [btrfs]
> [ 1338.903304]  cleaner_kthread+0x150/0x180 [btrfs]
> [ 1338.903908]  kthread+0x109/0x140
> [ 1338.904593]  ? btree_invalidatepage+0xa0/0xa0 [btrfs]
> [ 1338.905207]  ? kthread_park+0x60/0x60
> [ 1338.905803]  ret_from_fork+0x25/0x30
> [ 1338.906416] Code: 10 00 00 00 4c 89 fe e8 8a 30 ff ff 4c 89 f7 e8
> 32 f6 fc ff e9 d3 fe ff ff b8 f4 ff ff ff e9 d4 fe ff ff 0f 1f 00 e8
> cb 3e be e0 <0f> ff eb af 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 31 d2
> be 02
