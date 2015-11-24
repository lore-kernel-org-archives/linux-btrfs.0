Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63852 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbbKXXxj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 18:53:39 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Laurent Bonnaud <L.Bonnaud@laposte.net>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <56519644.8060105@laposte.net> <56526543.4090301@cn.fujitsu.com>
 <565462F7.8040601@laposte.net>
Cc: Lukas Pirl <btrfs@lukas-pirl.de>, linux-btrfs@vger.kernel.org,
        calestyo@scientia.net
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5654F877.2050202@gmx.com>
Date: Wed, 25 Nov 2015 07:53:27 +0800
MIME-Version: 1.0
In-Reply-To: <565462F7.8040601@laposte.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/24/2015 09:15 PM, Laurent Bonnaud wrote:
> On 23/11/2015 02:00, Qu Wenruo wrote:
>
>> Considering the size, I'd like not to touch the dump, metadata is over 5G,
>
> It is only 2GB once compressed :>.
>
>> and I think it's not related to on-disk data, but runtime problem like I mentioned above.
>
> To test this hypothesis I did the following:
>
>   - reboot the machine with a 4.3.0 kernel from Debian experimental
>   - run "du" on the btrfs FS as a quick sanity check
>
> The kernel went read-only again with the following kernel errors:
>
> [ 5759.890934] BTRFS info (device sdb1): disk space caching is enabled
> [ 5773.278244] BTRFS warning (device sdb1): block group 314635714560 has wrong amount of free space
> [ 5773.278247] BTRFS warning (device sdb1): failed to load free space cache for block group 314635714560, rebuild it now
> [ 5773.947885] ------------[ cut here ]------------
> [ 5773.947908] WARNING: CPU: 0 PID: 2546 at /build/linux-7sjCdl/linux-4.3/fs/btrfs/extent-tree.c:2851 btrfs_run_delayed_refs+0x26b/0x2a0 [btrfs]()
> [ 5773.947909] BTRFS: Transaction aborted (error -17)
> [ 5773.947910] Modules linked in: xt_multiport cpufreq_conservative cpufreq_powersave cpufreq_userspace cpufreq_stats ip6table_filter ip6_tables iptable_filter ip_tables x_tables binfmt_misc snd_hda_codec_analog snd_hda_codec_generic dell_wmi iTCO_wdt iTCO_vendor_support sparse_keymap evdev coretemp kvm_intel dcdbas snd_hda_intel snd_hda_codec snd_hda_core kvm snd_hwdep i915 snd_pcm_oss snd_mixer_oss pcspkr sg snd_pcm psmouse lpc_ich mfd_core serio_raw i2c_i801 snd_timer snd shpchp tpm_tis video drm_kms_helper drm soundcore mei_me mei i2c_algo_bit wmi tpm 8250_fintek button acpi_cpufreq processor ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi drbd lru_cache libcrc32c parport_pc ppdev lp parport loop dm_crypt dm_mod autofs4 ext4 crc16 mbcache
> [ 5773.947951]  jbd2 crc32c_generic btrfs xor raid6_pq md_mod ses enclosure hid_generic usbhid hid sd_mod uas usb_storage ahci libahci ata_generic libata scsi_mod e1000e ptp pps_core ehci_pci uhci_hcd ehci_hcd usbcore usb_common
> [ 5773.947967] CPU: 0 PID: 2546 Comm: kworker/u16:2 Not tainted 4.3.0-trunk-amd64 #1 Debian 4.3-1~exp1
> [ 5773.947968] Hardware name: Dell Inc. OptiPlex 780                 /0C27VV, BIOS A08 01/21/2011
> [ 5773.947981] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
> [ 5773.947983]  ffffffffa02a8250 ffffffff812c53a9 ffff8800af283d30 ffffffff8106ebad
> [ 5773.947985]  ffff8800ace5eae0 ffff8800af283d80 ffff8800ac6ade70 ffff8800ac6add10
> [ 5773.947987]  0000000000000020 ffffffff8106ec2c ffffffffa02a8420 0000000000000020
> [ 5773.947989] Call Trace:
> [ 5773.947994]  [<ffffffff812c53a9>] ? dump_stack+0x40/0x57
> [ 5773.947997]  [<ffffffff8106ebad>] ? warn_slowpath_common+0x7d/0xb0
> [ 5773.947999]  [<ffffffff8106ec2c>] ? warn_slowpath_fmt+0x4c/0x50
> [ 5773.948019]  [<ffffffffa021908b>] ? btrfs_run_delayed_refs+0x26b/0x2a0 [btrfs]
> [ 5773.948027]  [<ffffffffa02190f2>] ? delayed_ref_async_start+0x32/0x80 [btrfs]
> [ 5773.948039]  [<ffffffffa025bd98>] ? btrfs_scrubparity_helper+0xc8/0x260 [btrfs]
> [ 5773.948041]  [<ffffffff810851df>] ? process_one_work+0x19f/0x3d0
> [ 5773.948043]  [<ffffffff8108545d>] ? worker_thread+0x4d/0x450
> [ 5773.948044]  [<ffffffff81085410>] ? process_one_work+0x3d0/0x3d0
> [ 5773.948046]  [<ffffffff8108af5d>] ? kthread+0xbd/0xe0
> [ 5773.948048]  [<ffffffff8108aea0>] ? kthread_create_on_node+0x170/0x170
> [ 5773.948051]  [<ffffffff81553c5f>] ? ret_from_fork+0x3f/0x70
> [ 5773.948053]  [<ffffffff8108aea0>] ? kthread_create_on_node+0x170/0x170
> [ 5773.948054] ---[ end trace 654b175f2543b4e4 ]---
> [ 5773.948057] BTRFS: error (device sdb1) in btrfs_run_delayed_refs:2851: errno=-17 Object already exists
> [ 5773.948092] BTRFS info (device sdb1): forced readonly
> [ 5936.235238] perf interrupt took too long (2502 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
> [ 6427.280125] BTRFS (device sdb1): parent transid verify failed on 353291255808 wanted 9058 found 9056
> [ 6427.288873] BTRFS (device sdb1): parent transid verify failed on 353291255808 wanted 9058 found 9056
> [ 6427.381126] BTRFS (device sdb1): parent transid verify failed on 353291255808 wanted 9058 found 9056
> [ 6427.381747] BTRFS (device sdb1): parent transid verify failed on 353291255808 wanted 9058 found 9056
> [...]
>
> Are you interested in the btrfs-image output now ?
>
BTW, did you encountered the same btrfsck error "chunk type dismatch" 
from Christoph?

If so that will provide great help for the btrfsck false alert debugging.

Thanks,
Qu
