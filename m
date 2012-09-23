Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34113 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2IWQQf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Sep 2012 12:16:35 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1TForC-0000L6-Pn
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Sep 2012 09:16:34 -0700
Date: Sun, 23 Sep 2012 09:16:34 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: crash in read_extent_buffer+0xb7/0xfb
Message-ID: <20120923161634.GA23057@merlins.org>
References: <20120920171747.GG26105@merlins.org> <20120921034652.GA871@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120921034652.GA871@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2012 at 08:46:52PM -0700, Marc MERLIN wrote:
> On Thu, Sep 20, 2012 at 10:17:47AM -0700, Marc MERLIN wrote:
> > I had a btrfs built on top of 5 drives (dmcrypt devices).
> > 
> > The drive then died while I was writing to the filesystem and my system
> > crashed and rebooted:
> > 
> > [384555.534020] sd 10:0:0:0: rejecting I/O to offline device                    
> > [384555.535057] sd 10:0:0:0: rejecting I/O to offline device                    
> > [384556.666885] ------------[ cut here ]------------                            
> > [384556.667909] sd 10:0:0:0: [sdj] Synchronizing SCSI cache                     
> > [384556.677509] kernel BUG at fs/btrfs/ctree.c:3451!                            
> > [384556.682551] invalid opcode: 0000 [#1] PREEMPT SMP                           
> > [384556.687878] CPU 2                                                           
> > 
>  
> Oh my, now I'm trying again with a new drive, and a big cp from an
> existing array to a new one dies with:
> [32042.079411] ------------[ cut here ]------------                             
> [32042.085799] kernel BUG at fs/btrfs/extent_io.c:1884!                         
> [32042.092528] invalid opcode: 0000 [#1] PREEMPT SMP                            
> [32042.099227] CPU 1                                                            
> [32042.101095] Modules linked in:[32042.105950]  raid456 async_raid6_recov async
> _pq raid6_pq async_xor xor async_memcpy async_tx ppdev lp tun autofs4 kl5kusb105
>  ftdi_sio keyspan nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc rc_ati_x10 s
> nd_timer i915 usbserial snd drm_kms_helper eeepc_wmi drm ati_remote asus_wmi rc_
> core sparse_keymap    

I had a different crash while copying to a btrfs 5 disk array. Not sure if this is
also fixed too, but pasting just in case.
 
[207025.055956] btrfs: bdev /dev/mapper/crypt_sdo1 errs: wr 46779, rd 0, flush 7 6, corrupt 0, gen 0
[207055.067267] btrfs bad mapping eb start 8653217792 len 4096, wanted 184467440 50581869634 4
[207055.078099] general protection fault: 0000 [#1] PREEMPT SMP
[207055.085213] CPU 3
[207055.087173] Modules linked in:[207055.091512]  raid456 async_raid6_recov asy
nc_pq raid6_pq async_xor xor async_memcpy async_tx ppdev lp tun autofs4 kl5kusb1
05 ftdi_sio keyspan nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipt_REJECT
 xt_state xt_tcpudp xt_LOG iptable_mangle iptable_filter deflate ctr twofish_gen
eric twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia
_x86_64 serpent_sse2_x86_64 lrw serpent_generic xts gf128mul blowfish_generic bl
owfish_x86_64 blowfish_common cast5 des_generic xcbc rmd160 sha512_generic crypt
o_null af_key xfrm_algo dm_crypt dm_mirror dm_region_hash dm_log aes_x86_64 fuse
 lm85 hwmon_vid dm_snapshot dm_mod iptable_nat ip_tables nf_conntrack_ftp ipt_MA
SQUERADE nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 x_tables nf_conntrack sg st snd
_pcm_oss snd_mixer_oss snd_hda_codec_hdmi snd_hda_codec_realtek snd_cmipci gamep
ort rc_ati_x10 snd_opl3_lib snd_mpu401_uart pl2303 ati_remote rc_core snd_seq_mi
di snd_seq_midi_event snd_seq usbserial snd_rawmidi kvm_intel kvm snd_seq_device
 snd_hda_intel[207055.193933]  i915 snd_hda_codec drm_kms_helper snd_hwdep snd_p
cm drm snd_timer eeepc_wmi asus_wmi sparse_keymap rfkill snd i2c_i801 parport_pc
 acpi_cpufreq i2c_algo_bit microcode crc32c_intel ehci_hcd xhci_hcd ghash_clmuln
i_intel pci_hotplug wmi cryptd r8169 snd_page_alloc soundcore pcspkr tpm_tis mpe
rf tpm evdev tpm_bios usbcore i2c_core parport mii lpc_ich mei sata_sil24 corete
mp sata_mv fan thermal processor button video thermal_sys usb_common [last unloa
ded: kl5kusb105]

[207055.244330] Pid: 6456, comm: btrfs-transacti Tainted: G        W    3.5.3-amd64-preempt-noide-20120903 #1 System manufacturer System Product Name/P8H67-M PRO
[207055.261478] RIP: 0010:[<ffffffff811fc9ae>]  [<ffffffff811fc9ae>] read_extent_buffer+0xb7/0xfb
[207055.271621] RSP: 0018:ffff880105ff3880  EFLAGS: 00010202
[207055.278516] RAX: 0000000000000bbe RBX: ffff8800405ba1f8 RCX: ffff8800405ba2c8
[207055.287257] RDX: ffff880105ff38ec RSI: 0000000000000086 RDI: ffff880105ff38ec
[207055.295967] RBP: ffff880105ff38c0 R08: 007ffffffd4ebdc8 R09: 0000160000000000
[207055.304674] R10: 0000000000001000 R11: 6db6db6db6db6db7 R12: 0000000000000004
[207055.313356] R13: ffff880000000000 R14: fffffffa9d7b9446 R15: 000000000000044 2
[207055.322032] FS:  0000000000000000(0000) GS:ffff88011f380000(0000) knlGS:0000000000000000
[207055.331692] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[207055.339014] CR2: 00000000f7021000 CR3: 0000000001a0c000 CR4: 00000000000407e0
[207055.347715] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[207055.356403] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[207055.365092] Process btrfs-transacti (pid: 6456, threadinfo ffff880105ff2000,task ffff880105e7e600)
[207055.376219] Stack:
[207055.380369]  fffffffa9d7b9442 000fffffffa9d7b9 ffff880105ff38a0 0000000000000000
[207055.389447]  ffff8800405ba1f8 fffffffa9d7b9431 fffffffa9d7b9442 00000000798be017
[207055.398481]  ffff880105ff3910 ffffffff811f2855 ffff8800405ba1f8 fffffffa9d7b9000
[207055.407543] Call Trace:
[207055.411582]  [<ffffffff811f2855>] btrfs_token_item_offset+0x86/0xb8
[207055.419436]  [<ffffffff811f295f>] btrfs_item_offset+0xb/0xd
[207055.426585]  [<ffffffff811c04bf>] btrfs_item_offset_nr+0x14/0x16
[207055.434143]  [<ffffffff811c08f9>] leaf_space_used+0x58/0x81
[207055.441269]  [<ffffffff811c42ea>] btrfs_leaf_free_space+0x33/0x72
[207055.448924]  [<ffffffff811c4d45>] push_leaf_right+0xa1/0x142
[207055.456092]  [<ffffffff814aa936>] ? _raw_spin_lock+0x1b/0x1f
[207055.463329]  [<ffffffff811c4f13>] split_leaf+0x79/0x52f
[207055.470222]  [<ffffffff811f295f>] ? btrfs_item_offset+0xb/0xd
[207055.477483]  [<ffffffff811c08f9>] ? leaf_space_used+0x58/0x81
[207055.484744]  [<ffffffff814aac0e>] ? _raw_write_unlock+0x28/0x33
[207055.492203]  [<ffffffff8120a523>] ? btrfs_set_lock_blocking_rw+0x9b/0xec
[207055.500770]  [<ffffffff811c5b5c>] btrfs_search_slot+0x583/0x62e
[207055.508199]  [<ffffffff811c6e32>] btrfs_insert_empty_items+0x62/0xb4
[207055.516029]  [<ffffffff811cef40>] run_clustered_refs+0x3e2/0x741
[207055.523655]  [<ffffffff811cf503>] btrfs_run_delayed_refs+0x264/0x373
[207055.531450]  [<ffffffff81085cf8>] ? arch_local_irq_save+0x15/0x1b
[207055.538950]  [<ffffffff814aa936>] ? _raw_spin_lock+0x1b/0x1f
[207055.545965]  [<ffffffff814aaab9>] ? _raw_spin_unlock+0x27/0x32
[207055.553168]  [<ffffffff811f6c51>] ? btrfs_run_ordered_operations+0x19f/0x1ae
[207055.561517]  [<ffffffff811dd30f>] btrfs_commit_transaction+0xa9/0x8dc
[207055.569231]  [<ffffffff8105957a>] ? add_wait_queue+0x44/0x44
[207055.576235]  [<ffffffff81049f32>] ? init_timer_deferrable_key+0x17/0x17
[207055.584056]  [<ffffffff811d7e58>] transaction_kthread+0x174/0x230
[207055.591332]  [<ffffffff811d7ce4>] ? try_to_freeze+0x33/0x33
[207055.598153]  [<ffffffff81058e3c>] kthread+0x86/0x8e
[207055.604162]  [<ffffffff814b08a4>] kernel_thread_helper+0x4/0x10
[207055.611168]  [<ffffffff81058db6>] ? kthread_freezable_should_stop+0x3e/0x3e
[207055.619358]  [<ffffffff814b08a0>] ? gs_change+0x13/0x13
[207055.625624] Code: b7 6d db b6 6d db b6 6d 49 bd 00 00 00 00 00 88 ff ff 49 c1 e0 03 eb 43 48 8b 8b 50 01 00 00 4c 89 d0 48 89 d7 4c 29 f8 4c 39 e0 <4a> 8b 0c 01 49 0f 47 c4 49 83 c0 08 49 29 c4 4c 01 c9 48 c1 f9
[207055.647970] RIP  [<ffffffff811fc9ae>] read_extent_buffer+0xb7/0xfb
[207055.655271]  RSP <ffff880105ff3880>
[207055.665029] ---[ end trace 06a6f0aa8102336a ]---
[207055.671223] Kernel panic - not syncing: Fatal exception



-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
