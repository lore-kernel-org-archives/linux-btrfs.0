Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55356 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751911AbdIIW4n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Sep 2017 18:56:43 -0400
From: Josef Bacik <jbacik@fb.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Date: Sat, 9 Sep 2017 22:56:14 +0000
Message-ID: <63F04FB0-47AD-4732-ACD6-B493C51F9ED4@fb.com>
References: <20170902235344.sb55vzaloglmqaad@merlins.org>
 <73427BC6-B85B-422C-BCA0-778C7BA203A8@fb.com>
 <20170903010127.eafg2i7ry2tprro7@merlins.org>
 <5D0BC86A-D427-4529-A40E-492A98BA5D16@fb.com>
 <20170903143142.7thdjvkmkdekrzc5@merlins.org>
 <1E7DEC47-01A8-4F50-B266-FA4949090687@fb.com>
 <20170903144237.svgnaclwmcfdfikt@merlins.org>
 <AD68E364-AF7F-49AA-8376-49E0C7C92998@fb.com>
 <20170903202036.b7j6fcknfiisrnsl@merlins.org>
 <D509EEE0-1430-40C2-8AD4-117729CFADDD@fb.com>,<20170909183918.guot5vuphgabevxi@merlins.org>
In-Reply-To: <20170909183918.guot5vuphgabevxi@merlins.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well that's odd, a block allocated on disk is in the free space cache.  Can I see the full output of the fsck?  I want to make sure it's actually getting to the part where it checks the free space cache.  If it does then I'll have to think of how to catch this kind of bug, because you've got a weird one.  Thanks,

Josef

Sent from my iPhone

> On Sep 9, 2017, at 2:39 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
>> On Tue, Sep 05, 2017 at 06:19:25PM +0000, Josef Bacik wrote:
>> Alright I just reworked the build tree ref stuff and tested it to make sure it wasnâ€™t going to give false positives again.  Apparently I had only ever used this with very basic existing fsâ€™es and nothing super complicated, so it was just broken for anything complex.  Iâ€™ve pushed it to my tree, you can just pull and build and try again.  This time the stack traces will even work!  Thanks,
> 
> Ok, so I found out that I just need to copy a bunch of data to the
> filesystem to trigger the bug.
> 
> There you go:
> [318400.507972] re-allocated a block that still has references to it!
> [318400.527517] Dumping block entry [13282417065984 16384], num_refs 2, metadata 1, from disk 1
> [318400.553751]   Ref root 2, parent 0, owner 0, offset 0, num_refs 1
> [318400.573208]   Root entry 2, num_refs 1
> [318400.585614]   Root entry 7, num_refs 0
> [318400.598028]   Ref action 3, root 7, ref_root 7, parent 0, owner 1, offset 0, num_refs 1
> [318400.623774]    btrfs_alloc_tree_block+0x33e/0x3e1
> [318400.639083]    __btrfs_cow_block+0xf3/0x420
> [318400.652817]    btrfs_cow_block+0xcf/0x145
> [318400.666024]    btrfs_search_slot+0x269/0x6de
> [318400.680041]    btrfs_del_csums+0xac/0x2f9
> [318400.693245]    __btrfs_free_extent+0x88b/0xa0b
> [318400.707718]    __btrfs_run_delayed_refs+0xb4e/0xd20
> [318400.723491]    btrfs_run_delayed_refs+0x77/0x1a1
> [318400.738993]    btrfs_write_dirty_block_groups+0xf5/0x2c1
> [318400.755994]    commit_cowonly_roots+0x1da/0x273
> [318400.770673]    btrfs_commit_transaction+0x3dd/0x761
> [318400.786397]    transaction_kthread+0xe2/0x178
> [318400.800515]    kthread+0xfb/0x100
> [318400.811487]    ret_from_fork+0x25/0x30
> [318400.823748]    0xffffffffffffffff
> [318400.957574] ------------[ cut here ]------------
> [318400.972498] WARNING: CPU: 2 PID: 3242 at fs/btrfs/extent-tree.c:3015 btrfs_run_delayed_refs+0xa2/0x1a1
> [318401.001382] Modules linked in: veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic snd_cmipci snd_hda_intel snd_mpu401_uart snd_hda_codec snd_opl3_lib eeepc_wmi snd_hda_core tpm_infineon snd_rawmidi asix asus_wmi rc_ati_x10 tpm_tis
> [318401.218357]  snd_seq_device sparse_keymap snd_hwdep tpm_tis_core ati_remote usbnet parport_pc snd_pcm rfkill pcspkr i915 hwmon tpm parport rc_core libphy mei_me snd_timer lpc_ich wmi_bmof battery usbserial evdev wmi input_leds i2c_i801 snd soundcore e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core lrw ablk_helper dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd xhci_pci ehci_pci xhci_hcd ehci_hcd mvsas libsas r8169 sata_sil24 usbcore mii scsi_transport_sas thermal fan [last unloaded: ftdi_sio]
> [318401.392440] CPU: 2 PID: 3242 Comm: btrfs-transacti Tainted: G     U          4.13.0-rc5-amd64-stkreg-sysrq-20170902d+ #6
> [318401.426262] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
> [318401.454894] task: ffff948ef791e200 task.stack: ffffb18a091ec000
> [318401.473918] RIP: 0010:btrfs_run_delayed_refs+0xa2/0x1a1
> [318401.490849] RSP: 0018:ffffb18a091efd08 EFLAGS: 00010296
> [318401.507751] RAX: 0000000000000026 RBX: ffff9488208be618 RCX: 0000000000000000
> [318401.530384] RDX: ffff948f1e295e01 RSI: ffff948f1e28dd58 RDI: ffff948f1e28dd58
> [318401.553548] RBP: ffffb18a091efd50 R08: 0003dc12ea8bcc57 R09: ffff948f1f50b868
> [318401.576127] R10: ffff948b1f1cc460 R11: ffffffffaef37285 R12: 00000000ffffffef
> [318401.598717] R13: ffffffffffffffff R14: ffff948edb7efd48 R15: ffff948cdbdeb000
> [318401.621327] FS:  0000000000000000(0000) GS:ffff948f1e280000(0000) knlGS:0000000000000000
> [318401.646737] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [318401.665149] CR2: 00000000f7f05001 CR3: 000000061f587000 CR4: 00000000001406e0
> [318401.687684] Call Trace:
> [318401.696148]  btrfs_write_dirty_block_groups+0xf5/0x2c1
> [318401.712745]  ? btrfs_run_delayed_refs+0x127/0x1a1
> [318401.727981]  commit_cowonly_roots+0x1da/0x273
> [318401.742183]  btrfs_commit_transaction+0x3dd/0x761
> [318401.757447]  transaction_kthread+0xe2/0x178
> [318401.771158]  ? btrfs_cleanup_transaction+0x3c2/0x3c2
> [318401.787169]  kthread+0xfb/0x100
> [318401.797769]  ? init_completion+0x24/0x24
> [318401.810718]  ret_from_fork+0x25/0x30
> [318401.822588] Code: 85 c0 41 89 c4 79 60 48 8b 43 60 f0 0f ba a8 d8 16 00 00 02 72 35 41 83 fc fb 74 13 44 89 e6 48 c7 c7 27 3f af ae e8 81 5d e1 ff <0f> ff eb 1c f6 05 2a da ab 00 04 74 13 48 8b 7b 60 44 89 e2 48 
> [318401.881182] ---[ end trace 47464f1fcc4796c5 ]---
> [318401.896818] BTRFS: error (device dm-2) in btrfs_run_delayed_refs:3015: errno=-17 Object already exists
> [318401.925978] BTRFS info (device dm-2): forced readonly
> [318401.950682] BTRFS warning (device dm-2): Skipping commit of aborted transaction.
> [318401.974102] BTRFS: error (device dm-2) in cleanup_transaction:1873: errno=-17 Object already exists
> 
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                      .... what McDonalds is to gourmet cooking
> Home page: https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.merlins.org_&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=sDzg6MvHymKOUgI8SFIm4Q&m=o759mdnkjma3m2oMqEzj1KVVewpEmzlydubih83mtq0&s=IRkCyJIqdUxvKz2hxZ2G_kAV0pyiM5qARhoNzbUuoh0&e=                          | PGP 1024R/763BE901
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
