Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:60794 "EHLO
        resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750911AbdILGNW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 02:13:22 -0400
Subject: Re: btrfs_remove_chunk call trace?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAG+QAKXZwsTmrNFYNk9RmbL1DZGZ-oAe1GykVRdBOFxkLTwH9g@mail.gmail.com>
 <CAG+QAKXNhA3YCjLAp5yOam05-egoHgY4YszR3XJFF=vUC-+Cdg@mail.gmail.com>
 <pan$189d9$b081e2b5$d8e128c5$16f4d94f@cox.net>
From: Rich Rauenzahn <rich@shroop.net>
Message-ID: <3e8913a5-1a13-20d7-3268-3a09b733c5f6@shroop.net>
Date: Mon, 11 Sep 2017 23:05:02 -0700
MIME-Version: 1.0
In-Reply-To: <pan$189d9$b081e2b5$d8e128c5$16f4d94f@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 9/11/2017 1:35 PM, Duncan wrote:
> Rich Rauenzahn posted on Sun, 10 Sep 2017 22:45:50 -0700 as excerpted:
>
>> ...and can it be related to the Samsung 840 SSD's not supporting NCQ
>> Trim?  (Although I can't tell which device this trace is from -- it
>> could be a mechanical Western Digital.)
>>
>> On Sun, Sep 10, 2017 at 10:16 PM, Rich Rauenzahn <rrauenza@gmail.com>
>> wrote:
>>> Is this something to be concerned about?
>>>
>>> I'm running the latest mainline kernel on CentOS 7.
>>>
>>> [ 1338.891412] CPU: 2 PID: 790 Comm: btrfs-cleaner
>>> Tainted: G        W     4.13.1-1.el7.elrepo.x86_64 #1
> As a Samsung ssd (tho 850) owner myself, who looked into mounting with
> the discard mount option on my new ssds here...
>
> Samsung ssds lack of queued-trim shouldn't be a problem on anything close
> to a current kernel, obviously including the 4.13.1 you're running above,
> because the kernel block layer has blacklisted queued-trim on all Samsung
> SSDs for at least several kernel cycles (not sure when it went in, but
> there was a time in the 3.x kernel era when queued-trim on samsung ssds
> was causing problems, thus the blacklisting).

Looking at the source in git.kernel.org, yes, it looks like it was 
disabled quite some time ago for "Samsung SSD 8*".  And I'm not mounting 
with discard ... and I've added a weekly fstrim --all.  (I didn't see 
one in CentOS7.)

So what is causing these traces?  ....they look ... troubling.

Sep 11 13:03:01 tendo kernel: ------------[ cut here ]------------
Sep 11 13:03:01 tendo kernel: WARNING: CPU: 0 PID: 519 at 
fs/btrfs/ctree.h:1559 btrfs_update_device+0x1c5/0x1d0 [btrfs]
Sep 11 13:03:01 tendo kernel: Modules linked in: xt_nat ipt_MASQUERADE 
nf_nat_masquerade_ipv4 nf_conntrack_ftp xt_conntrack iptable_filter 
xt_REDIRECT nf_nat_redirect iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip_tables veth binfmt_misc xt_addrtype 
overlay loop nf_log_ipv4 nf_log_common xt_LOG xt_limit xt_comment 
xt_recent xt_multiport nct6775 hwmon_vid jc42 vfat fat dm_mirror 
dm_region_hash dm_log dm_mod dax xfs libcrc32c x86_pkg_temp_thermal 
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel pcbc aesni_intel crypto_simd 
glue_helper cryptd iTCO_wdt iTCO_vendor_support mei_wdt intel_cstate 
snd_hda_codec_hdmi input_leds intel_rapl_perf sg cdc_acm shpchp 
intel_pch_thermal snd_hda_codec_realtek i2c_i801
  ie31200_edac snd_hda_codec_genericSep 11 13:03:01 tendo kernel: 
snd_hda_intel snd_hda_codec mei_me snd_hda_core snd_seq lpc_ich pcspkr 
snd_seq_device mfd_core mei snd_hwdep snd_pcm snd_timer acpi_pad snd 
soundcore nfsd auth_rpcgss nfs_acl lockd grace sunrpc btrfs xor raid6_pq 
sd_mod crc32c_intel i915 firewire_ohci ahci e1000e libahci igb 
firewire_core crc_itu_t dca drm_kms_helper i2c_algo_bit syscopyarea ptp 
libata sysfillrect sysimgblt pps_core fb_sys_fops drm video [last 
unloaded: nf_conntrack]
Sep 11 13:03:01 tendo kernel: CPU: 0 PID: 519 Comm: systemd-journal 
Tainted: G        W       4.13.1-1.el7.elrepo.x86_64 #1
Sep 11 13:03:01 tendo kernel: Hardware name: Supermicro X10SAE/X10SAE, 
BIOS 2.0a 05/09/2014
Sep 11 13:03:01 tendo kernel: task: ffff880407f95d00 task.stack: 
ffffc900022b8000
Sep 11 13:03:01 tendo kernel: RIP: 0010:btrfs_update_device+0x1c5/0x1d0 
[btrfs]
Sep 11 13:03:01 tendo kernel: RSP: 0018:ffffc900022bbb00 EFLAGS: 00010206
Sep 11 13:03:01 tendo kernel: RAX: 0000000000000fff RBX: 
ffff880404c392a0 RCX: 0000001bc6c71e00
Sep 11 13:03:01 tendo kernel: RDX: ffff880000000000 RSI: 
ffff880244ed0f3c RDI: ffff880236623068
Sep 11 13:03:01 tendo kernel: RBP: ffffc900022bbb48 R08: 
0000000000003f60 R09: ffffc900022bbab8
Sep 11 13:03:01 tendo kernel: R10: 0000000000001000 R11: 
0000000000000003 R12: ffff880405fc7800
Sep 11 13:03:01 tendo kernel: R13: 0000000000000000 R14: 
ffff880236623068 R15: 0000000000003f3c
Sep 11 13:03:01 tendo kernel: FS:  00007fafb608e880(0000) 
GS:ffff88041fa00000(0000) knlGS:0000000000000000
Sep 11 13:03:01 tendo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Sep 11 13:03:01 tendo kernel: CR2: 00007fafb60ad000 CR3: 
000000040493b000 CR4: 00000000001406f0
Sep 11 13:03:01 tendo kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Sep 11 13:03:01 tendo kernel: DR3: 0000000000000000 DR6: 
00000000fffe0ff0 DR7: 0000000000000400
Sep 11 13:03:01 tendo kernel: Call Trace:
Sep 11 13:03:01 tendo kernel: btrfs_finish_chunk_alloc+0x126/0x4e0 [btrfs]
Sep 11 13:03:01 tendo kernel: ? btrfs_insert_item+0x80/0xf0 [btrfs]
Sep 11 13:03:01 tendo kernel: 
btrfs_create_pending_block_groups+0x13f/0x260 [btrfs]
Sep 11 13:03:01 tendo kernel: __btrfs_end_transaction+0x93/0x2f0 [btrfs]
Sep 11 13:03:01 tendo kernel: btrfs_end_transaction+0x10/0x20 [btrfs]
Sep 11 13:03:01 tendo kernel: __btrfs_prealloc_file_range+0x378/0x4a0 
[btrfs]
Sep 11 13:03:01 tendo kernel: btrfs_prealloc_file_range+0x23/0x30 [btrfs]
Sep 11 13:03:01 tendo kernel: btrfs_fallocate+0x554/0x7a0 [btrfs]
Sep 11 13:03:01 tendo kernel: vfs_fallocate+0x15b/0x290
Sep 11 13:03:01 tendo kernel: SyS_fallocate+0x44/0x70
Sep 11 13:03:01 tendo kernel: entry_SYSCALL_64_fastpath+0x1a/0xa5
Sep 11 13:03:01 tendo kernel: RIP: 0033:0x7fafb4cab119
Sep 11 13:03:01 tendo kernel: RSP: 002b:00007ffcb99c5d00 EFLAGS: 
00000246 ORIG_RAX: 000000000000011d
Sep 11 13:03:01 tendo kernel: RAX: ffffffffffffffda RBX: 
0000558751d9f3d0 RCX: 00007fafb4cab119
Sep 11 13:03:01 tendo kernel: RDX: 0000000005000000 RSI: 
0000000000000000 RDI: 0000000000000013
Sep 11 13:03:01 tendo kernel: RBP: 0000000000000000 R08: 
0000000000000013 R09: 0000000005000000
Sep 11 13:03:01 tendo kernel: R10: 0000000000800000 R11: 
0000000000000246 R12: 0000000000000000
Sep 11 13:03:01 tendo kernel: R13: 00007ffcb99c58a0 R14: 
00007ffcb99c58ae R15: 00007ffcb99c58a2
Sep 11 13:03:01 tendo kernel: Code: 10 00 00 00 4c 89 fe e8 8a 30 ff ff 
4c 89 f7 e8 32 f6 fc ff e9 d3 fe ff ff b8 f4 ff ff ff e9 d4 fe ff ff 0f 
1f 00 e8 cb 5e be e0 <0f> ff eb af 0f 1f 80 00 00 00 00 0f 1f 44 00 00 
55 31 d2 be 02
Sep 11 13:03:01 tendo kernel: ---[ end trace 96a2d96b3058d885 ]---
Sep 11 13:03:02 tendo sh: abrt-dump-oops: Found oopses: 1
Sep 11 13:03:02 tendo sh: abrt-dump-oops: Creating problem directories
Sep 11 13:03:02 tendo sh: abrt-dump-oops: Not going to make dump 
directories world readable because PrivateReports is on
Sep 11 13:03:02 tendo abrt-server: Looking for kernel package

