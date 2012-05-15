From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: 3.4.0-rc6: WARNING: at fs/btrfs/super.c:219 __btrfs_abort_transaction+0xae/0xc0
 [btrfs]()
Date: Tue, 15 May 2012 09:39:39 +0800
Message-ID: <4FB1B3DB.3050808@cn.fujitsu.com>
References: <4FB10636.2010003@arndnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Hannemann <arnd@arndnet.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FB10636.2010003@arndnet.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/14/2012 09:18 PM, Arnd Hannemann wrote:

> Hi,
> 
> I just got the following warning on a compressed btrfs filesystem, while writing on it
> until no remaining space was available.
> Looks like a bit verbose "disk full" message, is it expected behavior?
> 


Hi Arnd,

Can you add another mount option "enospc_debug", like mount xx xxx -o compress,enospc_debug?

Plz show us what you get, there might be a space leak.

thanks,
liubo


> [22403.015529] ------------[ cut here ]------------
> [22403.015572] WARNING: at /home/arnd/Projekte/kernel/linux-2.6/fs/btrfs/super.c:219 __btrfs_abort_transaction+0xae/0xc0 [btrfs]()
> [22403.015577] Hardware name: 4384GEG
> [22403.015579] btrfs: Transaction aborted
> [22403.015581] Modules linked in: dm_crypt ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables joydev bridge stp llc kvm_intel kvm bnep rfcomm bluetooth binfmt_misc arc4 snd_hda_codec_hdmi snd_hda_codec_conexant coretemp snd_hda_intel thinkpad_acpi microcode snd_hda_codec snd_hwdep snd_pcm qcserial usb_wwan psmouse usbserial snd_seq_midi serio_raw snd_rawmidi iwlwifi snd_seq_midi_event snd_seq intel_ips mac80211 snd_timer snd_seq_device cfg80211 snd snd_page_alloc mei(C) soundcore tpm_tis nvram btrfs zlib_deflate libcrc32c mxm_wmi ghash_clmulni_intel aesni_intel cryptd aes_x86_64 i915 drm_kms_helper sdhci_pci sdhci drm fire
 wire_ohci i2c_algo_bit firewire_core crc_itu_t ahci libahci wmi video e1000e
> [22403.015668] Pid: 24802, comm: btrfs-delalloc- Tainted: G         C   3.4.0-rc6aha+ #8
> [22403.015671] Call Trace:
> [22403.015683]  [<ffffffff8104e35f>] warn_slowpath_common+0x7f/0xc0
> [22403.015689]  [<ffffffff8104e456>] warn_slowpath_fmt+0x46/0x50
> [22403.015711]  [<ffffffffa01c63fd>] ? btrfs_reserve_extent+0xed/0x250 [btrfs]
> [22403.015728]  [<ffffffffa01b1bde>] __btrfs_abort_transaction+0xae/0xc0 [btrfs]
> [22403.015754]  [<ffffffffa01dea12>] submit_compressed_extents+0x212/0x480 [btrfs]
> [22403.015781]  [<ffffffffa01ded04>] async_cow_submit+0x84/0x90 [btrfs]
> [22403.015807]  [<ffffffffa0206988>] run_ordered_completions+0x78/0xf0 [btrfs]
> [22403.015833]  [<ffffffffa0207395>] worker_loop+0x185/0x5d0 [btrfs]
> [22403.015840]  [<ffffffff810792c8>] ? __wake_up_common+0x58/0x90
> [22403.015867]  [<ffffffffa0207210>] ? btrfs_queue_worker+0x310/0x310 [btrfs]
> [22403.015873]  [<ffffffff81070b83>] kthread+0x93/0xa0
> [22403.015880]  [<ffffffff81628224>] kernel_thread_helper+0x4/0x10
> [22403.015886]  [<ffffffff81070af0>] ? kthread_freezable_should_stop+0x70/0x70
> [22403.015891]  [<ffffffff81628220>] ? gs_change+0x13/0x13
> [22403.015895] ---[ end trace 768f569fb0306239 ]---
> [22403.015898] BTRFS warning (device dm-6): Aborting unused transaction.
> [22403.064892] BTRFS warning (device dm-6): Aborting unused transaction.
> [22403.094675] BTRFS warning (device dm-6): Aborting unused transaction.
> [22403.512902] BTRFS warning (device dm-6): Aborting unused transaction.
> [22403.703871] BTRFS warning (device dm-6): Aborting unused transaction.
> [22403.709637] BTRFS warning (device dm-6): Aborting unused transaction.
> [22403.721362] BTRFS warning (device dm-6): Aborting unused transaction.
> [22403.736999] BTRFS warning (device dm-6): Aborting unused transaction.
> [22403.794067] BTRFS warning (device dm-6): Aborting unused transaction.
> [22403.799009] BTRFS warning (device dm-6): Aborting unused transaction.
> [22404.035483] BTRFS warning (device dm-6): Aborting unused transaction.
> [22404.108751] BTRFS warning (device dm-6): Aborting unused transaction.
> 
> Best regards
> Arnd
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
