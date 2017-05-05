Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46911 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751556AbdEEBNi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 May 2017 21:13:38 -0400
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem by
 X hours?
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <fdmanana@suse.com>, <jbacik@fb.com>,
        <dsterba@suse.cz>
References: <20170501170641.GG3516@merlins.org>
 <20170501180856.GH3516@merlins.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <711c4159-073e-a8c8-2715-b9ff5faa88bd@cn.fujitsu.com>
Date: Fri, 5 May 2017 09:13:29 +0800
MIME-Version: 1.0
In-Reply-To: <20170501180856.GH3516@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/02/2017 02:08 AM, Marc MERLIN wrote:
> So, I forgot to mention that it's my main media and backup server that got
> corrupted. Yes, I do actually have a backup of a backup server, but it's
> going to take days to recover due to the amount of data to copy back, not
> counting lots of manual typing due to the number of subvolumes, btrfs
> send/receive relationships and so forth.
> 
> Really, I should be able to roll back all writes from the last 24H, run a
> check --repair/scrub on top just to be sure, and be back on track.
> 
> In the meantime, the good news is that the filesystem doesn't crash the
> kernel (the poasted crash below) now that I was able to cancel the btrfs balance,
> but it goes read only at the drop of a hat, even when I'm trying to delete
> recent snapshots and all data that was potentially written in the last 24H
> 
> On Mon, May 01, 2017 at 10:06:41AM -0700, Marc MERLIN wrote:
>> I have a filesystem that sadly got corrupted by a SAS card I just installed yesterday.
>>
>> I don't think in a case like this, there is there a way to roll back all
>> writes across all subvolumes in the last 24H, correct?

Sorry for the late reply.
I thought the case is already finished as I see little chance to recover. :(

No, no way to roll back unless you're completely sure there is only 1 
transaction commit happened in last 24H.
(Well, not really possible in real world)

Btrfs is only capable to rollback to *previous* commit.
That's ensure by forced metadata CoW.

But beyond previous commit, only god knows.

If all metadata CoW write is done in some place never used by any 
previous metadata, then there is the chance to recover.

But mostly the possibility is very low, some mount option like ssd will 
change the extent allocator behavior to improve the possibility, but 
still need a lot of luck.

More detailed comment will be replied to btrfs check mail.

Thanks,
Qu

>>
>> Is the best thing to go in each subvolume, delete the recent snapshots and
>> rename the one from 24H as the current one?
>   
> Well, just like I expected, it's a pain in the rear and this can't even help
> fix the top level mountpoint which doesn't have snapshots, so I can't roll
> it back.
> btrfs should really have an easy way to roll back X hours, or days to
> recover from garbage written after a good known point, given that it is COW
> afterall.
> 
> Is there a way do this with check --repair maybe?
> 
> In the meantime, I got stuck while trying to delete snapshots:
> 
> Let's say I have this:
> ID 428 gen 294021 top level 5 path backup
> ID 2023 gen 294021 top level 5 path Soft
> ID 3021 gen 294051 top level 428 path backup/debian32
> ID 4400 gen 294018 top level 428 path backup/debian64
> ID 4930 gen 294019 top level 428 path backup/ubuntu
> 
> I can easily
> Delete subvolume (no-commit): '/mnt/btrfs_pool2/Soft'
> and then:
> gargamel:/mnt/btrfs_pool2# mv Soft_rw.20170430_01:50:22 Soft
> 
> But I can't delete backup, which actually is mostly only a directory
> containing other things (in hindsight I shouldn't have made that a
> subvolume)
> Delete subvolume (no-commit): '/mnt/btrfs_pool2/backup'
> ERROR: cannot delete '/mnt/btrfs_pool2/backup': Directory not empty
> 
> This is because backup has a lot of subvolumes due to btrfs send/receive
> relationships.
> 
> Is it possible to recover there? Can you reparent subvolumes to a different
> subvolume without doing a full copy via btrfs send/receive?
> 
> Thanks,
> Marc
> 
>> BTRFS warning (device dm-5): failed to load free space cache for block group 6746013696000, rebuilding it now
>> BTRFS warning (device dm-5): block group 6754603630592 has wrong amount of free space
>> BTRFS warning (device dm-5): failed to load free space cache for block group 6754603630592, rebuilding it now
>> BTRFS warning (device dm-5): block group 7125178777600 has wrong amount of free space
>> BTRFS warning (device dm-5): failed to load free space cache for block group 7125178777600, rebuilding it now
>> BTRFS error (device dm-5): bad tree block start 3981076597540270796 2899180224512
>> BTRFS error (device dm-5): bad tree block start 942082474969670243 2899180224512
>> BTRFS: error (device dm-5) in __btrfs_free_extent:6944: errno=-5 IO failure
>> BTRFS info (device dm-5): forced readonly
>> BTRFS: error (device dm-5) in btrfs_run_delayed_refs:2961: errno=-5 IO failure
>> BUG: unable to handle kernel NULL pointer dereference at           (null)
>> IP: __del_reloc_root+0x3f/0xa6
>> PGD 189a0e067
>> PUD 189a0f067
>> PMD 0
>>
>> Oops: 0000 [#1] PREEMPT SMP
>> Modules linked in: veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_hda_codec_realtek snd_cmipci snd_hda_codec_generic snd_hda_intel snd_mpu401_uart snd_hda_codec snd_opl3_lib snd_rawmidi snd_hda_core snd_seq_device snd_hwdep eeepc_wmi snd_pcm asus_wmi rc_ati_x10
>>   asix snd_timer ati_remote sparse_keymap usbnet rfkill snd hwmon soundcore rc_core evdev libphy tpm_infineon pcspkr i915 parport_pc i2c_i801 input_leds mei_me lpc_ich parport tpm_tis battery usbserial tpm_tis_core tpm wmi e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core lrw ablk_helper dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd xhci_pci ehci_pci sata_sil24 xhci_hcd mvsas ehci_hcd r8169 usbcore mii libsas scsi_transport_sas thermal fan [last unloaded: ftdi_sio]
>> CPU: 0 PID: 9056 Comm: btrfs Tainted: G     U          4.11.0-amd64-preempt-sysrq-20170406 #2
>> Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
>> task: ffff88374d2a60c0 task.stack: ffffa6f226424000
>> RIP: 0010:__del_reloc_root+0x3f/0xa6
>> RSP: 0018:ffffa6f226427a40 EFLAGS: 00210246
>> RAX: 0000000000000000 RBX: ffff8838ee256000 RCX: 00000000ffffffe2
>> RDX: 0000000000000001 RSI: ffffffff9f83b410 RDI: ffff8837992da568
>> RBP: ffffa6f226427a68 R08: 0000000000000000 R09: ffffffff9fd69480
>> R10: 0000000000000000 R11: 0000000000000000 R12: ffffa6f226427ab0
>> R13: ffff883768938000 R14: ffff8837992da568 R15: ffff8837992da570
>> FS:  00007facd18d28c0(0000) GS:ffff883a5e200000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000000 CR3: 0000000189a10000 CR4: 00000000001406f0
>> Call Trace:
>>   free_reloc_roots+0x4f/0x5d
>>   merge_reloc_roots+0x159/0x1ba
>>   relocate_block_group+0x410/0x492
>>   btrfs_relocate_block_group+0x12d/0x253
>>   btrfs_relocate_chunk+0x3e/0xb1
>>   btrfs_balance+0xd16/0xf36
>>   btrfs_ioctl_balance+0x24f/0x2cd
>>   ? __alloc_pages_nodemask+0x134/0x1e0
>>   btrfs_ioctl+0x1447/0x1e22
>>   ? mem_cgroup_charge_statistics+0x1e/0x88
>>   ? get_page+0x9/0x26
>>   ? __lru_cache_add+0x2a/0x6c
>>   ? set_pte_at+0x9/0xd
>>   ? __handle_mm_fault+0x61d/0xa6f
>>   vfs_ioctl+0x21/0x38
>>   ? vfs_ioctl+0x21/0x38
>>   do_vfs_ioctl+0x4ef/0x537
>>   ? current_kernel_time64+0x10/0x36
>>   ? __audit_syscall_entry+0xc2/0xe6
>>   ? syscall_trace_enter+0x1ac/0x20e
>>   SyS_ioctl+0x57/0x7b
>>   do_syscall_64+0x6b/0x7d
>>   entry_SYSCALL64_slow_path+0x25/0x25
>> RIP: 0033:0x7facd097ecc7
>> RSP: 002b:00007ffefd3c3128 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
>> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007facd097ecc7
>> RDX: 00007ffefd3c31b8 RSI: 00000000c4009420 RDI: 0000000000000003
>> RBP: 00007ffefd3c31b8 R08: 0000000000000003 R09: 0000000000008040
>> R10: 0000000000000541 R11: 0000000000000206 R12: 0000000000000003
>> R13: 00007ffefd3c4cc9 R14: 0000000000000001 R15: 0000000000000001
>> Code: af f0 01 00 00 48 89 fb 4d 8b b5 10 0b 00 00 4d 8d be 70 05 00 00 49 81 c6 68 05 00 00 4c 89 ff e8 0f 44 43 00 48 8b 03 4c 89 f7 <48> 8b 30 e8 0e fc ff ff 48 85 c0 49 89 c4 74 0b 4c 89 f6 48 89
>> RIP: __del_reloc_root+0x3f/0xa6 RSP: ffffa6f226427a40
>> CR2: 0000000000000000
>> ---[ end trace 64c3fa4dc953d295 ]---
>> Kernel panic - not syncing: Fatal exception
>> Kernel Offset: 0x1e000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>> Rebooting in 20 seconds..
>> ACPI MEMORY or I/O RESET_REG.
>>
>> -- 
>> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>> Microsoft is to operating systems ....
>>                                        .... what McDonalds is to gourmet cooking
>> Home page: http://marc.merlins.org/
> 


