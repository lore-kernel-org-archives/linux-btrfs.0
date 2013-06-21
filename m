Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33279 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422651Ab3FUBrH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 21:47:07 -0400
Received: by mail-ob0-f180.google.com with SMTP id eh20so7766975obb.25
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 18:47:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130621011137.4477.1347@localhost.localdomain>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
 <20130618163706.GC19183@localhost.localdomain> <loom.20130618T190955-784@post.gmane.org>
 <20130621011137.4477.1347@localhost.localdomain>
From: Jon Nelson <jnelson@jamponi.net>
Date: Thu, 20 Jun 2013 20:46:46 -0500
Message-ID: <CAKuK5J3TBDNgHJ_YUWupB4rO_ixG0LnZFE=K5Uo5Wbo=76rT+A@mail.gmail.com>
Subject: Re: hang on 3.9, 3.10-rc5
To: Chris Mason <chris.mason@fusionio.com>
Cc: Jon Nelson <jnelson+btrfs@jamponi.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is this what you are looking for?
After this, the CPU gets "stuck" and I have to reboot.


[360491.932226] ------------[ cut here ]------------
[360491.932261] kernel BUG at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.9.6/linux-3.9/fs/btrfs/ctree.c:1144!
[360491.932312] invalid opcode: 0000 [#1] PREEMPT SMP
[360491.932344] Modules linked in: xfs nilfs2 jfs usb_storage
nls_iso8859_1 nls_cp437 vfat fat mmc_block nfsv4 auth_rpcgss nfs
fscache lockd sunrpc tun snd_usb_audio snd_usbmidi_lib snd_rawmidi
snd_seq_device fuse xt_tcpudp xt_pkttype xt_LOG xt_limit af_packet
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
iptable_raw xt_CT iptable_filter ip6table_mangle
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
ip6_tables x_tables arc4 iwldvm mac80211 snd_hda_codec_hdmi
snd_hda_codec_conexant iTCO_wdt iTCO_vendor_support mperf coretemp
kvm_intel kvm snd_hda_intel snd_hda_codec microcode snd_hwdep snd_pcm
thinkpad_acpi snd_timer joydev pcspkr sr_mod snd tpm_tis iwlwifi cdrom
e1000e wmi tpm battery ac tpm_bios cfg80211 sdhci_pci soundcore ptp
sdhci snd_page_alloc i2c_i801 rfkill pps_core mmc_core lpc_ich
mfd_core tcp_westwood sg autofs4 btrfs raid6_pq zlib_deflate xor
libcrc32c sha256_generic dm_crypt dm_mod crc32_pclmul
ghash_clmulni_intel crc32c_intel aesni_intel ablk_helper cryptd lrw
aes_x86_64 xts gf128mul thermal i915 drm_kms_helper drm i2c_algo_bit
video button processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw
scsi_dh_emc scsi_dh_alua scsi_dh ata_generic ata_piix
[360491.933095] CPU 3
[360491.933110] Pid: 22166, comm: btrfs-endio-wri Not tainted
3.9.6-1.g8ead728-desktop #1 LENOVO 4239CTO/4239CTO
[360491.933161] RIP: 0010:[<ffffffffa022075b>]  [<ffffffffa022075b>]
__tree_mod_log_rewind+0x23b/0x240 [btrfs]
[360491.933225] RSP: 0018:ffff88014cad7888  EFLAGS: 00010297
[360491.933253] RAX: 0000000000000000 RBX: ffff880065705b40 RCX:
ffff88014cad7828
[360491.933289] RDX: 000000000247cc54 RSI: ffff88014949e821 RDI:
ffff8801bf916640
[360491.933326] RBP: ffff880073048490 R08: 0000000000001000 R09:
ffff88014cad7838
[360491.933362] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff8801c0556640
[360491.933398] R13: 000000000001731e R14: 000000000000003d R15:
ffff880158b76340
[360491.933435] FS:  0000000000000000(0000) GS:ffff88021e2c0000(0000)
knlGS:0000000000000000
[360491.933476] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[360491.933506] CR2: 00007f0a360017f8 CR3: 000000015be03000 CR4:
00000000000407e0
[360491.933543] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[360491.933579] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[360491.933617] Process btrfs-endio-wri (pid: 22166, threadinfo
ffff88014cad6000, task ffff8801a5f8a6c0)
[360491.933662] Stack:
[360491.933674]  ffff88011b573800 ffff88010126e7f0 0000000000000001
0000160000000000
[360491.933719]  ffff880073048490 ffffffffa0228d45 6db6db6db6db6db7
ffff8801c0556640
[360491.933763]  ffff88020e764000 ffff880000000000 000000000001731e
ffff880197cb8158
[360491.933807] Call Trace:
[360491.933848]  [<ffffffffa0228d45>] btrfs_search_old_slot+0x635/0x950 [btrfs]
[360491.933909]  [<ffffffffa02a1ec6>]
__resolve_indirect_refs+0x156/0x640 [btrfs]
[360491.934044]  [<ffffffffa02a2e0c>] find_parent_nodes+0x95c/0x1050 [btrfs]
[360491.934176]  [<ffffffffa02a3592>] btrfs_find_all_roots+0x92/0x100 [btrfs]
[360491.934307]  [<ffffffffa02a401e>] iterate_extent_inodes+0x16e/0x370 [btrfs]
[360491.934440]  [<ffffffffa02a42b8>]
iterate_inodes_from_logical+0x98/0xc0 [btrfs]
[360491.934572]  [<ffffffffa024c1c8>] record_extent_backrefs+0x68/0xe0 [btrfs]
[360491.934652]  [<ffffffffa0256d80>]
btrfs_finish_ordered_io+0x150/0x990 [btrfs]
[360491.934739]  [<ffffffffa0276ef3>] worker_loop+0x153/0x560 [btrfs]
[360491.934833]  [<ffffffff810697c3>] kthread+0xb3/0xc0
[360491.934864]  [<ffffffff815dc6bc>] ret_from_fork+0x7c/0xb0
[360491.934896] DWARF2 unwinder stuck at ret_from_fork+0x7c/0xb0
[360491.934925]
[360491.934934] Leftover inexact backtrace:
[360491.934934]
[360491.934965]  [<ffffffff81069710>] ? kthread_create_on_node+0x120/0x120
[360491.934999] Code: c1 48 63 43 58 48 89 c2 48 c1 e2 05 48 8d 54 10
65 48 63 43 2c 48 89 c6 48 c1 e6 05 48 8d 74 30 65 e8 3a af 04 00 e9
b3 fe ff ff <0f> 0b 0f 0b 90 41 57 41 56 41 55 41 54 55 48 89 fd 53 48
83 ec
[360491.935188] RIP  [<ffffffffa022075b>]
__tree_mod_log_rewind+0x23b/0x240 [btrfs]
[360491.935233]  RSP <ffff88014cad7888>
[360491.946047] ---[ end trace 1475a0830dcadf9c ]---
[360491.946051] note: btrfs-endio-wri[22166] exited with preempt_count 1

On Thu, Jun 20, 2013 at 8:11 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> Quoting Jon Nelson (2013-06-18 13:19:04)
>> Josef Bacik <jbacik <at> fusionio.com> writes:
>>
>> >
>> > On Tue, Jun 11, 2013 at 11:43:30AM -0400, Sage Weil wrote:
>> > > I'm also seeing this hang regularly with both 3.9 and 3.10-rc5.  Is this
>> > > is a known problem?  In this case there is no powercycling; just a regular
>> > > ceph-osd workload.
>>
>> ..
>>
>>
>> I'm able to cause a complete kernel hang by defrag'ing even one
>> file on 3.9.X (3.9.0 through 3.9.4, so far).
>
> I'm not able to reproduce this here.  Could you please capture the
> output from sysrq-w during the hang?  (It will all go to your dmesg)
>
> -chris
>



-- 
Jon
Software Blacksmith
