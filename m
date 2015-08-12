Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55958 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbbHLOsM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 10:48:12 -0400
Date: Wed, 12 Aug 2015 07:47:49 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
Message-ID: <20150812144749.GY24824@merlins.org>
References: <20150706212156.GY17274@merlins.org> <20150710134348.GB15535@suse.cz> <20150712010229.GA5284@merlins.org> <20150723115558.GQ6306@suse.cz> <20150724162446.GH30815@merlins.org> <20150803035130.GL24824@merlins.org> <20150811050758.GF29259@merlins.org> <55CA177D.1050004@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55CA177D.1050004@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 11:40:45AM -0400, Josef Bacik wrote:
> From a48cf7a9ae44a17d927df5542c8b0be287aee9ed Mon Sep 17 00:00:00 2001
> From: Josef Bacik <jbacik@fb.com>
> Date: Tue, 11 Aug 2015 11:39:37 -0400
> Subject: [PATCH] Btrfs: kill BUG_ON() in btrfs_lookup_extent_info()
> 
> Replace it with an ASSERT(0) for the developers and an error for not the
> developers.
 
Thanks. We knocked one down and now another BUG has been triggered :)

	if (unlikely(wc->refs[level - 1] == 0)) {
		btrfs_err(root->fs_info, "Missing references.");
		BUG();
	}

> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 5411f0a..f7fb120 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -818,7 +818,11 @@ search_again:
>  			BUG();
>  #endif
>  		}
> -		BUG_ON(num_refs == 0);
> +		if (num_refs == 0) {
> +			ASSERT(0);
> +			ret = -EIO;
> +			goto out_free;
> +		}
>  	} else {
>  		num_refs = 0;
>  		extent_flags = 0;
> @@ -859,7 +863,6 @@ search_again:
>  	}
>  	spin_unlock(&delayed_refs->lock);
>  out:
> -	WARN_ON(num_refs == 0);
>  	if (refs)
>  		*refs = num_refs;
>  	if (flags)
> -- 
> 

[  408.641308] BTRFS info (device dm-0): disk space caching is enabled
[  448.528218] BTRFS error (device dm-0): Missing references.
[  448.528247] ------------[ cut here ]------------
[  448.529994] kernel BUG at fs/btrfs/extent-tree.c:8116!
[  448.531747] invalid opcode: 0000 [#1] PREEMPT SMP 
[  448.532002] Modules linked in: xts gf128mul configs rc_hauppauge ir_kbd_i2c cpufreq_userspace cpufreq_powersave cpufreq_conservative cpufreq_stats autofs4 tuner_simple tuner_types tda9887 tda8290 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic tuner firewire_sbp2 snd_hda_intel snd_hda_controller msp3400 hwmon_vid joydev snd_hda_codec dm_crypt snd_hda_core snd_hwdep snd_pcm_oss snd_mixer_oss saa7127 snd_pcm dm_mod snd_seq_midi snd_seq_midi_event hid_generic snd_rawmidi saa7115 bttv ivtv tea575x snd_seq tveeprom snd_seq_device videobuf_dma_sg cx2341x videobuf_core v4l2_common snd_timer snd videodev soundcore coretemp gpio_ich rc_imon_mce usbhid imon rc_core kvm_intel hid media lpc_ich ehci_pci ehci_hcd psmouse evdev asus_atk0110 acpi_cpufreq kvm sr_mod serio_raw cdrom microcode processor sg lp parport raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx multipath floppy firewire_ohci firewire_core crc_itu_t uhci_hcd atl1 mii usbcore usb_common
[  448.532002] CPU: 1 PID: 3756 Comm: btrfs-cleaner Not tainted 4.1.3-ia32-i915-volpreempt-20150421jb1 #3
[  448.532002] Hardware name: System manufacturer P5E-VM HDMI/P5E-VM HDMI, BIOS 0604    07/16/2008
[  448.532002] task: f499f1e0 ti: e1d44000 task.ti: e1d44000
[  448.532002] EIP: 0060:[<c11aea88>] EFLAGS: 00010282 CPU: 1
[  448.532002] EIP is at do_walk_down+0x142/0x65f
[  448.532002] EAX: 0000002e EBX: f2d62a00 ECX: f5987310 EDX: 80000000
[  448.532002] ESI: f44c5030 EDI: e3c5c000 EBP: e1d45ebc ESP: e1d45e40
[  448.532002]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  448.532002] CR0: 8005003b CR2: b0057e4c CR3: 31216000 CR4: 000006d0
[  448.532002] Stack:
[  448.532002]  f1bef000 c174d1ac f4a2e7c0 00000001 00000000 00004000 f44c5028 00000001
[  448.532002]  00000286 f2d62a08 00000000 36598000 00000086 f44c5098 00000002 00008f48
[  448.532002]  00000000 00000001 e7f80178 00000000 e7f80228 e1d45e9c c11a7a2b e1d45ebc
[  448.532002] Call Trace:
[  448.532002]  [<c11a7a2b>] ? btrfs_tree_unlock_rw+0x10/0x2e
[  448.532002]  [<c11ac904>] ? walk_down_proc+0x110/0x1cb
[  448.532002]  [<c11af017>] walk_down_tree+0x72/0x93
[  448.532002]  [<c11b1901>] btrfs_drop_snapshot+0x278/0x591
[  448.532002]  [<c11bfbe9>] btrfs_clean_one_deleted_snapshot+0x79/0x87
[  448.532002]  [<c11b997c>] cleaner_kthread+0x74/0xdd
[  448.532002]  [<c11b9908>] ? btrfs_need_cleaner_sleep.isra.20+0x2a/0x2a
[  448.532002]  [<c104bccd>] kthread+0x88/0x8d
[  448.532002]  [<c105013e>] ? mmdrop+0xe/0x1c
[  448.532002]  [<c1050000>] ? check_same_owner+0x2c/0x43
[  448.532002]  [<c1549841>] ret_from_kernel_thread+0x21/0x30
[  448.532002]  [<c104bc45>] ? __kthread_parkme+0x50/0x50
[  448.532002] Code: 45 cc e8 10 ff 03 00 8b 55 c8 89 d0 e9 2f 05 00 00 8b 4d a8 8b 41 04 0b 01 75 12 68 ac d1 74 c1 ff b7 dc 01 00 00 e8 0b f3 fe ff <0f> 0b 8b 45 0c c7 00 00 00 00 00 83 bb 94 00 00 00 01 0f 85 a5
[  448.532002] EIP: [<c11aea88>] do_walk_down+0x142/0x65f SS:ESP 0068:e1d45e40
[  448.640313] ---[ end trace 9ddb31ca62f7248d ]---
[  448.640319] Kernel panic - not syncing: Fatal exception
[  448.642259] Kernel Offset: disabled

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
