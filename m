Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:9750 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750955AbeAVDfC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 22:35:02 -0500
Date: Mon, 22 Jan 2018 11:34:52 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, <enadolski@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: remove spurious WARN_ON(ref->count) in
 find_parent_nodes
Message-ID: <20180122033452.GA532@fnst.localdomain>
References: <20180121190848.7wmps6q5ng6b42ki@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180121190848.7wmps6q5ng6b42ki@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 21, 2018 at 02:08:58PM -0500, Zygo Blaxell wrote:
>This warning appears during execution of the LOGICAL_INO ioctl and
>appears to be spurious:
>
>	------------[ cut here ]------------
>	WARNING: CPU: 3 PID: 18172 at fs/btrfs/backref.c:1391 find_parent_nodes+0xc41/0x14e0
>	Modules linked in: ib_iser rdma_cm iw_cm ib_cm ib_core configfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi overlay r8169 ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs cpuid rpcsec_gss_krb5 nfsv4 nfsv3 nfs fscache algif_skcipher af_alg softdog nfsd auth_rpcgss nfs_acl lockd grace sunrpc bnep cpufreq_userspace cpufreq_powersave cpufreq_conservative nfnetlink_queue nfnetlink_log nfnetlink bluetooth rfkill snd_seq_dummy snd_hrtimer snd_seq_midi snd_seq_oss snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device binfmt_misc fuse nbd xt_REDIRECT nf_nat_redirect ipt_REJECT nf_reject_ipv4 xt_nat xt_conntrack xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
>	 ip6table_mangle iptable_mangle ip6table_filter ip6_tables iptable_filter ip_tables x_tables tcp_cubic dummy lp dm_crypt edac_mce_amd edac_core snd_hda_codec_hdmi ppdev kvm_amd kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_codec_via pcbc amdkfd snd_hda_codec_generic amd_iommu_v2 aesni_intel snd_hda_intel radeon snd_hda_codec aes_x86_64 snd_hda_core snd_hwdep crypto_simd glue_helper sg snd_pcm_oss cryptd input_leds joydev pcspkr serio_raw snd_mixer_oss rtc_cmos snd_pcm parport_pc parport shpchp wmi acpi_cpufreq evdev snd_timer asus_atk0110 k10temp fam15h_power snd soundcore sp5100_tco hid_generic ipv6 af_packet crc_ccitt raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx libcrc32c raid0 multipath linear dm_mod raid1 md_mod ohci_pci ide_pci_generic
>	 sr_mod cdrom pdc202xx_new ohci_hcd crc32c_intel atiixp ehci_pci psmouse ide_core i2c_piix4 ehci_hcd xhci_pci mii xhci_hcd [last unloaded: r8169]
>	CPU: 3 PID: 18172 Comm: bees Tainted: G      D W    L  4.11.9-zb64+ #1
>	Hardware name: System manufacturer System Product Name/M5A78L-M/USB3, BIOS 2101    12/02/2014
>	Call Trace:
>	 dump_stack+0x85/0xc2
>	 __warn+0xd1/0xf0
>	 warn_slowpath_null+0x1d/0x20
>	 find_parent_nodes+0xc41/0x14e0
>	 __btrfs_find_all_roots+0xad/0x120
>	 ? extent_same_check_offsets+0x70/0x70
>	 iterate_extent_inodes+0x168/0x300
>	 iterate_inodes_from_logical+0x87/0xb0
>	 ? iterate_inodes_from_logical+0x87/0xb0
>	 ? extent_same_check_offsets+0x70/0x70
>	 btrfs_ioctl+0x8ac/0x2820
>	 ? lock_acquire+0xc2/0x200
>	 do_vfs_ioctl+0x91/0x700
>	 ? __fget+0x112/0x200
>	 SyS_ioctl+0x79/0x90
>	 entry_SYSCALL_64_fastpath+0x23/0xc6
>	RIP: 0033:0x7f727b20be07
>	RSP: 002b:00007f7279f1e018 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>	RAX: ffffffffffffffda RBX: ffffffff9c0f4d7f RCX: 00007f727b20be07
>	RDX: 00007f7279f1e118 RSI: 00000000c0389424 RDI: 0000000000000003
>	RBP: 0000000000000035 R08: 00007f72581bf340 R09: 0000000000000000
>	R10: 0000000000000020 R11: 0000000000000246 R12: 0000000000000040
>	R13: 00007f725818d230 R14: 00007f7279f1b640 R15: 00007f7258000020
>	 ? trace_hardirqs_off_caller+0x1f/0x140
>	---[ end trace 5de243350f6762c6 ]---
>	------------[ cut here ]------------
>
>ref->count can be below zero under normal conditions (for delayed refs),
>so there is no need to spam dmesg when it happens.
>

Added Edmund.

Hi,

I've also encountered the same problem when running the test case
xfstests/btrfs/004. However, I'm not sure whether the negative ref->count
is reasonable.

IMO, these functions (such as add_delayed_refs, add_delayed_refs,
add_delayed_refs, add_missing_keys and resolve_indirect_refs) have been
executed at this point in time. Hence, these references not only include
these refs in the memory (delayed) but also include those refs in the disk
(inline/keyed). I would appreciate it if you could explain to me why the
reference count can be reduced to less than zero.

>On kernel v4.14 this warning occurs 100-1000 times more frequently than
>on kernels v4.2..v4.12.  In the worst case, one test machine had 59020
>warnings in 24 hours on v4.14.14 compared to 55 on v4.12.14.

According to my bisect result, The frequency of the warning occurrence
increased to the detectable degree after this patch
86d5f9944252 ("btrfs: convert prelimary reference tracking to use rbtrees")
is committed. I understand that this does not mean that this patch caused
the problem, but maybe Edmund can give us some help, so I added him to the
recipient.

-- 
Thanks,
Lu

>
>Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
>---
> fs/btrfs/backref.c | 1 -
> 1 file changed, 1 deletion(-)
>
>diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>index 7d0dc100a09a..57e8d2562ed5 100644
>--- a/fs/btrfs/backref.c
>+++ b/fs/btrfs/backref.c
>@@ -1263,7 +1263,6 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
> 	while (node) {
> 		ref = rb_entry(node, struct prelim_ref, rbnode);
> 		node = rb_next(&ref->rbnode);
>-		WARN_ON(ref->count < 0);
> 		if (roots && ref->count && ref->root_id && ref->parent == 0) {
> 			if (sc && sc->root_objectid &&
> 			    ref->root_id != sc->root_objectid) {
>-- 
>2.11.0
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


