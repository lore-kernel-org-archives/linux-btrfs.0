From: Josef Bacik <josef@redhat.com>
Subject: Delayed inode operations not doing the right thing with enospc
Date: Fri, 03 Jun 2011 14:46:10 -0400
Message-ID: <4DE92BF2.1060905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: miaox@cn.fujitsu.com
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I got a lot of these when running stress.sh on my test box

[ 9792.654889] ------------[ cut here ]------------
[ 9792.654898] WARNING: at fs/btrfs/extent-tree.c:5681
btrfs_alloc_free_block+0xca/0x27c [btrfs]()
[ 9792.654899] Hardware name: To Be Filled By O.E.M.
[ 9792.654900] Modules linked in: btrfs zlib_deflate libcrc32c
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables
arc4 rt61pci rt2x00pci rt2x00lib snd_hda_codec_hdmi mac80211
snd_hda_codec_realtek cfg80211 snd_hda_intel edac_core snd_seq rfkill
pcspkr serio_raw snd_hda_codec eeprom_93cx6 edac_mce_amd sp5100_tco
i2c_piix4 k10temp snd_hwdep snd_seq_device snd_pcm floppy r8169 xhci_hcd
mii snd_timer snd soundcore snd_page_alloc ipv6 firewire_ohci pata_acpi
ata_generic firewire_core pata_via crc_itu_t radeon ttm drm_kms_helper
drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
[ 9792.654919] Pid: 2762, comm: rm Tainted: G        W   2.6.39+ #1
[ 9792.654920] Call Trace:
[ 9792.654922]  [<ffffffff81053c4a>] warn_slowpath_common+0x83/0x9b
[ 9792.654925]  [<ffffffff81053c7c>] warn_slowpath_null+0x1a/0x1c
[ 9792.654933]  [<ffffffffa038e747>] btrfs_alloc_free_block+0xca/0x27c
[btrfs]
[ 9792.654945]  [<ffffffffa03b8562>] ? map_extent_buffer+0x6e/0xa8 [btrfs]
[ 9792.654953]  [<ffffffffa038189b>] __btrfs_cow_block+0xfc/0x30c [btrfs]
[ 9792.654963]  [<ffffffffa0396aa6>] ? btrfs_buffer_uptodate+0x47/0x58
[btrfs]
[ 9792.654970]  [<ffffffffa0382e48>] ? read_block_for_search+0x94/0x368
[btrfs]
[ 9792.654978]  [<ffffffffa0381ba9>] btrfs_cow_block+0xfe/0x146 [btrfs]
[ 9792.654986]  [<ffffffffa03848b0>] btrfs_search_slot+0x14d/0x4b6 [btrfs]
[ 9792.654997]  [<ffffffffa03b8562>] ? map_extent_buffer+0x6e/0xa8 [btrfs]
[ 9792.655022]  [<ffffffffa03938e8>] btrfs_lookup_inode+0x2f/0x8f [btrfs]
[ 9792.655025]  [<ffffffff8147afac>] ? _cond_resched+0xe/0x22
[ 9792.655027]  [<ffffffff8147b892>] ? mutex_lock+0x29/0x50
[ 9792.655039]  [<ffffffffa03d41b1>]
btrfs_update_delayed_inode+0x72/0x137 [btrfs]
[ 9792.655051]  [<ffffffffa03d4ea2>] btrfs_run_delayed_items+0x90/0xdb
[btrfs]
[ 9792.655062]  [<ffffffffa039a69b>]
btrfs_commit_transaction+0x228/0x654 [btrfs]
[ 9792.655064]  [<ffffffff8106e8da>] ? remove_wait_queue+0x3a/0x3a
[ 9792.655075]  [<ffffffffa03a2fa5>] btrfs_evict_inode+0x14d/0x202 [btrfs]
[ 9792.655077]  [<ffffffff81132bd6>] evict+0x71/0x111
[ 9792.655079]  [<ffffffff81132de0>] iput+0x12a/0x132
[ 9792.655081]  [<ffffffff8112aa3a>] do_unlinkat+0x106/0x155
[ 9792.655083]  [<ffffffff81127b83>] ? path_put+0x1f/0x23
[ 9792.655085]  [<ffffffff8109c53c>] ? audit_syscall_entry+0x145/0x171
[ 9792.655087]  [<ffffffff81128410>] ? putname+0x34/0x36
[ 9792.655090]  [<ffffffff8112b441>] sys_unlinkat+0x29/0x2b
[ 9792.655092]  [<ffffffff81482c42>] system_call_fastpath+0x16/0x1b
[ 9792.655093] ---[ end trace 02b696eb02b3f768 ]---


This is because use_block_rsv() is having to do a
reserve_metadata_bytes(), which shouldn't happen as we should have
reserved enough space for those operations to complete.  This is
happening because use_block_rsv() will call get_block_rsv(), which if
root->ref_cows is set (which is the case on all fs roots) we will use
trans->block_rsv, which will only have what the current transaction
starter had reserved.

What needs to be done instead is we need to have a block reserve that
any reservation that is done at create time for these inodes is migrated
to this special reserve, and then when you run the delayed inode items
stuff you set trans->block_rsv to the special block reserve so the
accounting is all done properly.

This is just off the top of my head, there may be a better way to do it,
I've not actually looked that the delayed inode code at all.

I would do this myself but I have a ever increasing list of shit to do
so will somebody pick this up and fix it please?  Thanks,

Josef
