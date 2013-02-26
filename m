Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33879 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab3BZHDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 02:03:33 -0500
Date: Tue, 26 Feb 2013 15:02:01 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: at fs/btrfs/inode.c:2165
 btrfs_orphan_commit_root+0xcb/0xdf()
Message-ID: <20130226070200.GA3949@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20130225025546.GC14143@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130225025546.GC14143@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 24, 2013 at 06:55:46PM -0800, Marc MERLIN wrote:
> Is this useful to anyone?
> 

Hi Marc,

Thanks for the report, of course they're useful.

Could you please also show us your workloads and it'd be better to know how to
reproduce this?

thanks,
liubo

> Got this after a crash/reboot:
> 
> 	if (block_rsv) {
> 		WARN_ON(block_rsv->size > 0);  <<<<<<<<<<<<<<<<<<<<<<
> 		btrfs_free_block_rsv(root, block_rsv);
> 	}
> 
> ------------[ cut here ]------------
> WARNING: at fs/btrfs/inode.c:2165 btrfs_orphan_commit_root+0xcb/0xdf()
> Hardware name: 2429A78
> Modules linked in: tun ppdev cpufreq_userspace cpufreq_stats cpufreq_conservative cpufreq_powersave rfcomm bnep autofs4 pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc fuse configs parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t ecryptfs snd_hda_codec_realtek uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media btusb bluetooth hid_generic usbhid hid arc4 coretemp kvm_intel kvm iwldvm ghash_clmulni_intel mac80211 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss iTCO_wdt snd_pcm iTCO_vendor_support snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq battery thinkpad_acpi tpm_tis nvram ac tpm snd_seq_device tpm_bios snd_timer snd evdev iwlwifi wmi cfg80211 sdhci_pci i915 rfkill sdhci microcode mmc_core video pcspkr psmouse lpc_ich e1000e soundcore serio_raw button mei drm_kms_helper drm xhci_hcd ehci_hcd i2c_i801 i2c_a!
>  lgo_bit acpi_cpufreq mperf i2c_core usbcore usb_common processor raid456 multipath dm_snapshot dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor raid6_pq async_memcpy async_tx xor blowfish_x86_64 blowfish_common ecb crc32c_intel aesni_intel xts aes_x86_64 lrw gf128mul ablk_helper cryptd thermal thermal_sys
> Pid: 500, comm: btrfs-transacti Tainted: G           O 3.7.8-amd64-preempt-20130222 #1
> Call Trace:
>  [<ffffffff81040ed4>] warn_slowpath_common+0x7e/0x96
>  [<ffffffff811f75c5>] ? alloc_extent_state+0x59/0xa4
>  [<ffffffff81040f01>] warn_slowpath_null+0x15/0x17
>  [<ffffffff811e972f>] btrfs_orphan_commit_root+0xcb/0xdf
>  [<ffffffff811e3954>] commit_fs_roots.isra.24+0x99/0x153
>  [<ffffffff814c1ed6>] ? _raw_spin_lock+0x1b/0x1f
>  [<ffffffff814c2059>] ? _raw_spin_unlock+0x27/0x32
>  [<ffffffff811e47e8>] btrfs_commit_transaction+0x45a/0x954
>  [<ffffffff8105d4be>] ? add_wait_queue+0x44/0x44
>  [<ffffffff811de8a6>] transaction_kthread+0xe7/0x18a
>  [<ffffffff811de7bf>] ? try_to_freeze+0x33/0x33
>  [<ffffffff8105cc31>] kthread+0x88/0x90
>  [<ffffffff8105cba9>] ? kthread_freezable_should_stop+0x39/0x39
>  [<ffffffff814c6b3c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8105cba9>] ? kthread_freezable_should_stop+0x39/0x39
> ---[ end trace ee93ff454aca9d81 ]---
> 
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
