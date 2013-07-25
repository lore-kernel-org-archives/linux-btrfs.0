Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.placs.net ([71.244.57.52]:45375 "EHLO mail.placs.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab3GYQcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 12:32:50 -0400
Date: Thu, 25 Jul 2013 11:32:44 -0500 (CDT)
From: BJ Quinn <bj@placs.net>
To: linux-btrfs@vger.kernel.org, list.btrfs@jan-o-sch.net
Cc: psusi@cfl.rr.com, Freddie Cash <fjwcash@gmail.com>
Message-ID: <24149367.8309.1374769963900.JavaMail.root@mail.placs.net>
In-Reply-To: <9213759.7842.1374769206286.JavaMail.root@mail.placs.net>
Subject: Fwd: Cloning a Btrfs partition
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Apologies for the double post -- forgot to send as plain text the first time around, so the list rejected it.)

I see that there's now a btrfs send / receive and I've tried using it, but I'm getting the oops I've pasted below, after which the FS becomes unresponsive (no I/O to the drive, no CPU usage, but all attempts to access the FS results in a hang). I have an internal drive (single drive) that contains 82GB of compressed data with a couple hundred snapshots. I tried taking the first snapshot and making a read only copy (btrfs subvolume snapshot -r) and then I connected an external USB drive and ran btrfs send / receive to that external drive. It starts working and gets a couple of GB in (I'd expect the first snapshot to be about 20GB) and then gets the following error. I had to use the latest copy of btrfs-progs from git, because the package installed on my system (btrfs-progs-0.20-0.2.git91d9eec) simply returned "invalid argument" when trying to run btrfs send / receive. Thanks in advance for any info you may have. 

Jul 24 18:46:48 foxserver8 kernel: general protection fault: 0000 [#1] SMP 
Jul 24 18:46:48 foxserver8 kernel: Modules linked in: des_generic ecb md4 sha256_ssse3 sha256_generic nls_utf8 cifs fscache dns_resolver fuse drbd lru_cache autofs4 sunrpc bonding ipv6 btrfs raid6_pq xor libcrc32c uinput iTCO_wdt iTCO_vendor_support gpio_ich dcdbas coretemp freq_table mperf intel_powerclamp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr joydev sg sb_edac edac_core lpc_ich shpchp acpi_power_meter tg3 hwmon ptp pps_core ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ahci libahci wmi usb_storage mgag200 ttm drm_kms_helper dm_mirror dm_region_hash dm_log dm_mod 
Jul 24 18:46:48 foxserver8 kernel: CPU: 7 PID: 10170 Comm: btrfs Not tainted 3.10.2-1.el6.elrepo.x86_64 #1 
Jul 24 18:46:48 foxserver8 kernel: Hardware name: Dell Inc. PowerEdge R420/0CN7CM, BIOS 1.4.6 10/26/2012 
Jul 24 18:46:48 foxserver8 kernel: task: ffff880c0f1c9540 ti: ffff880beebae000 task.ti: ffff880beebae000 
Jul 24 18:46:48 foxserver8 kernel: RIP: 0010:[<ffffffffa03be4cd>] [<ffffffffa03be4cd>] ulist_add_merge+0x2d/0x190 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: RSP: 0018:ffff880beebaf958 EFLAGS: 00010202 
Jul 24 18:46:48 foxserver8 kernel: RAX: 4c415a4e5a4c4c45 RBX: 00000007c461c000 RCX: ffff880beebafa48 
Jul 24 18:46:48 foxserver8 kernel: RDX: 0000000000000000 RSI: ffff8802b232ed70 RDI: ffff880b0ba63400 
Jul 24 18:46:48 foxserver8 kernel: RBP: ffff880beebaf988 R08: 0000000000000050 R09: 0000000000000000 
Jul 24 18:46:48 foxserver8 kernel: R10: 0000000000000000 R11: dead000000200200 R12: ffff880b0ba63400 
Jul 24 18:46:48 foxserver8 kernel: R13: 0000000000000000 R14: ffff880beebafa28 R15: ffff880c0f6d8000 
Jul 24 18:46:48 foxserver8 kernel: FS: 00007fd121589740(0000) GS:ffff880c2fc60000(0000) knlGS:0000000000000000 
Jul 24 18:46:48 foxserver8 kernel: CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
Jul 24 18:46:48 foxserver8 kernel: CR2: ffffffffff600400 CR3: 000000060ca2c000 CR4: 00000000000407e0 
Jul 24 18:46:48 foxserver8 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
Jul 24 18:46:48 foxserver8 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
Jul 24 18:46:48 foxserver8 kernel: Stack: 
Jul 24 18:46:48 foxserver8 kernel: 0000000000000000 0000000000000000 ffff880bd449d8c0 ffff880bcc39fbe0 
Jul 24 18:46:48 foxserver8 kernel: ffff880beebafa28 ffff880c0f6d8000 ffff880beebafa88 ffffffffa03bdae6 
Jul 24 18:46:48 foxserver8 kernel: 0000000000008046 ffff880beebafa38 ffff880beebafab8 ffff880c00b95800 
Jul 24 18:46:48 foxserver8 kernel: Call Trace: 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03bdae6>] find_parent_nodes+0x4f6/0x630 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03bdd99>] btrfs_find_all_roots+0x99/0x100 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03c4810>] ? did_overwrite_ref+0x100/0x100 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03bdf0a>] iterate_extent_inodes+0x10a/0x1f0 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa037dd01>] ? free_extent_buffer+0x61/0xc0 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03c431b>] find_extent_clone+0x26b/0x330 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03c6b41>] process_extent+0x71/0xd0 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03c8360>] changed_cb+0xd0/0x130 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03c851e>] full_send_tree+0x15e/0x2c0 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03c87b8>] send_subvol+0x138/0x150 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03c8600>] ? full_send_tree+0x240/0x2c0 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03c87b8>] send_subvol+0x138/0x150 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03c8600>] ? full_send_tree+0x240/0x2c0 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa03c8b22>] btrfs_ioctl_send+0x352/0x560 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffffa0396e3b>] btrfs_ioctl+0x65b/0x8c0 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffff8108bbb5>] ? check_preempt_curr+0x75/0xa0 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffff810936bb>] ? wake_up_new_task+0xfb/0x160 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffff811a95b9>] do_vfs_ioctl+0x89/0x350 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffff811a9921>] SyS_ioctl+0xa1/0xb0 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffff8105ab86>] ? SyS_clone+0x16/0x20 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffff815fce79>] ? stub_clone+0x69/0x90 
Jul 24 18:46:48 foxserver8 kernel: [<ffffffff815fcb19>] system_call_fastpath+0x16/0x1b 
Jul 24 18:46:48 foxserver8 kernel: Code: 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 66 66 66 66 90 48 8b 47 18 49 89 fc 48 89 f3 49 89 d5 0f 1f 44 00 00 48 85 c0 74 13 <48> 3b 58 f0 48 8d 70 f0 76 79 48 8b 40 08 48 85 c0 75 ed 49 8b 
Jul 24 18:46:48 foxserver8 kernel: RIP [<ffffffffa03be4cd>] ulist_add_merge+0x2d/0x190 [btrfs] 
Jul 24 18:46:48 foxserver8 kernel: RSP <ffff880beebaf958> 
Jul 24 18:46:48 foxserver8 kernel: ---[ end trace a30ba65210ac4804 ]--- 

-BJ 

----- Forwarded Message -----

From: "Jan Schmidt" <list.btrfs@jan-o-sch.net> 
To: "BJ Quinn" <bj@placs.net> 
Cc: "Phillip Susi" <psusi@cfl.rr.com>, "Freddie Cash" <fjwcash@gmail.com>, linux-btrfs@vger.kernel.org 
Sent: Thursday, December 8, 2011 10:41:38 AM 
Subject: Re: Cloning a Btrfs partition 

On 08.12.2011 17:28, BJ Quinn wrote: 
>>> At any rate, was someone saying that some work had already started on something like btrfs send? 
> 
>> That's right. 
> 
> Google tells me that someone is you. :) 
> 
> What Google wouldn't tell me though was whether you have something I could test? 

Well, it's telling you the right thing :-) 

Currently I'm distracted by reliable backref walking, which turned out 
to be a prerequisite of btrfs send. Once I have that thing done, direct 
work on the send/receive functionality will continue. 

As soon as there's something that can be tested, you'll find it on this 
list. 

-Jan 


