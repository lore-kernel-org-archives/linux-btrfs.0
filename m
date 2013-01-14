Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44255 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3ANHLG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 02:11:06 -0500
Received: by mail-pa0-f44.google.com with SMTP id hz11so2063383pad.31
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Jan 2013 23:11:05 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 14 Jan 2013 04:11:05 -0300
Message-ID: <CAPVzhpw6rc9VuSwhaPx8xhP02u-vAXoQW_1-odaTiyfcsQx0jw@mail.gmail.com>
Subject: kernel call trace when deleting a huge file (which used all the
 space) with btrfs
From: Reartes Guillermo <rtguille@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, i recently subscribed to this mailing list.

Recently i have found some issues with BTRFS, i am using F18.

I installed F18 in a kvm guest.

What i found is:

* Intermittent ENOSPC when writing after erasing a file which lead to a
true ENOSPC (reported https://bugzilla.redhat.com/show_bug.cgi?id=894837)
I reproduced this only in the disk i used to install F18 (/ and /boot subvols).

* Kernel Call Traces when deleting a file that was written previously
and used all
the space. (So there was a true ENOSPC). I reproduce these on an
additional disk i
added to the guest (41gb). I am not getting transient ENOSPC on that disk.

Jan 13 22:17:21 localhost kernel: [18160.215176] ------------[ cut
here ]------------
Jan 13 22:17:21 localhost kernel: [18160.215223] WARNING: at
fs/btrfs/extent-tree.c:6323 btrfs_alloc_free_block+0x376/0x380
[btrfs]()
Jan 13 22:17:21 localhost kernel: [18160.215226] Hardware name: Bochs
Jan 13 22:17:21 localhost kernel: [18160.215228] Modules linked in:
fuse ebtable_nat xt_CHECKSUM bridge stp llc nf_conntrack_netbios_ns
nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat iptable_mangle
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
ebtable_filter bnep bluetooth ebtables rfkill ip6table_filter
ip6_tables be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4
cxgb3i cxgb3 mdio libcxgbi ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa
ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm
8139too snd_page_alloc snd_timer snd 8139cp soundcore i2c_piix4
i2c_core mii virtio_balloon vhost_net tun macvtap macvlan kvm_amd kvm
uinput btrfs libcrc32c zlib_deflate
Jan 13 22:17:21 localhost kernel: [18160.215293] Pid: 28225, comm: rm
Tainted: G        W    3.6.10-4.fc18.x86_64 #1
Jan 13 22:17:21 localhost kernel: [18160.215296] Call Trace:
Jan 13 22:17:21 localhost kernel: [18160.215307]  [<ffffffff8105c8df>]
warn_slowpath_common+0x7f/0xc0
Jan 13 22:17:21 localhost kernel: [18160.215313]  [<ffffffff8105c93a>]
warn_slowpath_null+0x1a/0x20
Jan 13 22:17:21 localhost kernel: [18160.215340]  [<ffffffffa0031a06>]
btrfs_alloc_free_block+0x376/0x380 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215375]  [<ffffffffa005dc23>]
? read_extent_buffer+0xc3/0x120 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215401]  [<ffffffffa001da9a>]
__btrfs_cow_block+0x12a/0x510 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215427]  [<ffffffffa001df77>]
btrfs_cow_block+0xf7/0x200 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215453]  [<ffffffffa00221a7>]
btrfs_search_slot+0x3e7/0x8f0 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215459]  [<ffffffff810f1107>]
? call_rcu_sched+0x17/0x20
Jan 13 22:17:21 localhost kernel: [18160.215488]  [<ffffffffa003737f>]
btrfs_del_csums+0x12f/0x310 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215516]  [<ffffffffa002b059>]
__btrfs_free_extent+0x679/0x800 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215561]  [<ffffffffa002f526>]
run_clustered_refs+0x316/0xb50 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215594]  [<ffffffffa007c3a3>]
? find_ref_head+0x83/0xf0 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215622]  [<ffffffffa002fe48>]
btrfs_run_delayed_refs+0xe8/0x2e0 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215654]  [<ffffffffa00420f1>]
__btrfs_end_transaction+0xf1/0x3a0 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215685]  [<ffffffffa0042415>]
btrfs_end_transaction+0x15/0x20 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215717]  [<ffffffffa004c440>]
btrfs_evict_inode+0x200/0x310 [btrfs]
Jan 13 22:17:21 localhost kernel: [18160.215730]  [<ffffffff811aa6b2>]
evict+0xa2/0x1a0
Jan 13 22:17:21 localhost kernel: [18160.215735]  [<ffffffff811aae73>]
iput+0x103/0x190
Jan 13 22:17:21 localhost kernel: [18160.215742]  [<ffffffff8119e51f>]
do_unlinkat+0x15f/0x1a0
Jan 13 22:17:21 localhost kernel: [18160.215749]  [<ffffffff810d8d5c>]
? __audit_syscall_entry+0xcc/0x300
Jan 13 22:17:21 localhost kernel: [18160.215756]  [<ffffffff81627045>]
? do_async_page_fault+0x35/0x90
Jan 13 22:17:21 localhost kernel: [18160.215762]  [<ffffffff811a0dab>]
sys_unlinkat+0x1b/0x50
Jan 13 22:17:21 localhost kernel: [18160.215767]  [<ffffffff8162bae9>]
system_call_fastpath+0x16/0x1b
Jan 13 22:17:21 localhost kernel: [18160.215771] ---[ end trace
54a02fbdc3904cff ]---
Jan 13 22:17:21 localhost kernel: [18160.218829] ------------[ cut
here ]------------

I get many of those on sdb1, and the transient ENOSPC on sda2

Thanks in advance.
