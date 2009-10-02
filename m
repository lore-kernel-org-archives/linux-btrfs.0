From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: crash with linux-2.6.31.1
Date: Fri, 2 Oct 2009 15:02:23 +0200
Message-ID: <200910021502.23530.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I got the following crash today:

Oct  2 10:30:04 datengrab kernel: ------------[ cut here ]------------
Oct  2 10:30:04 datengrab kernel: WARNING: at fs/btrfs/free-space-cache.c:90 
tree_insert_offset+0x74/0xbb [btrfs]()
Oct  2 10:30:04 datengrab kernel: Hardware name: To Be Filled By O.E.M.
Oct  2 10:30:04 datengrab kernel: Modules linked in: snd_seq_midi 
snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_seq_oss 
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss btrfs zlib_deflate crc32c 
libcrc32c aes_x86_64 aes_generic xts gf128mul dm_crypt snd_emu10k1 snd_rawmidi 
snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc 
snd_util_mem snd_hwdep snd sg sr_mod ohci_hcd ehci_hcd uhci_hcd fglrx(P)
Oct  2 10:30:04 datengrab kernel: Pid: 258, comm: pdflush Tainted: P           
2.6.31.1 #1
Oct  2 10:30:04 datengrab kernel: Call Trace:
Oct  2 10:30:04 datengrab kernel: [<ffffffff8102b511>] ? 
warn_slowpath_common+0x76/0x8c
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0369c42>] ? 
tree_insert_offset+0x74/0xbb [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa036a0c2>] ? link_free_space+0x3b/0x51 
[btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa036a3c4>] ? 
btrfs_find_space_for_alloc+0x142/0x157 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0335692>] ? 
find_free_extent+0x48a/0x705 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffff81183071>] ? 
radix_tree_gang_lookup_slot+0x6b/0x8f
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0335d27>] ? 
__btrfs_reserve_extent+0x114/0x283 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0335ec3>] ? 
btrfs_reserve_extent+0x2d/0x54 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0346b99>] ? cow_file_range+0x1a7/0x302 
[btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0347359>] ? 
run_delalloc_range+0x9e/0x2ed [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa035c0b9>] ? 
find_lock_delalloc_range+0x123/0x178 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa035c756>] ? 
__extent_writepage+0x1d8/0x716 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa035ae38>] ? 
end_bio_extent_writepage+0x0/0x1a2 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffff8118320d>] ? 
radix_tree_gang_lookup_tag_slot+0x7a/0x9f
Oct  2 10:30:04 datengrab kernel: [<ffffffff810525cd>] ? 
find_get_pages_tag+0x36/0xbe
Oct  2 10:30:04 datengrab kernel: [<ffffffffa035cff4>] ? T.607+0x13f/0x287 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa034523d>] ? 
btrfs_submit_bio_hook+0xd2/0x103 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0345285>] ? 
__btrfs_submit_bio_start+0x0/0x24 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa034526e>] ? 
__btrfs_submit_bio_done+0x0/0x17 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa035d237>] ? 
extent_writepages+0x41/0x5a [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0345cfd>] ? 
btrfs_get_extent+0x0/0x70b [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffff81057ecc>] ? do_writepages+0x20/0x2d
Oct  2 10:30:04 datengrab kernel: [<ffffffff8108e61f>] ? 
writeback_single_inode+0x14c/0x325
Oct  2 10:30:04 datengrab kernel: [<ffffffff8108ebde>] ? 
generic_sync_sb_inodes+0x286/0x3e7
Oct  2 10:30:04 datengrab kernel: [<ffffffff81026d49>] ? update_curr+0x4e/0xc2
Oct  2 10:30:04 datengrab kernel: [<ffffffff8108ee26>] ? 
writeback_inodes+0x6d/0xa5
Oct  2 10:30:04 datengrab kernel: [<ffffffff8105897b>] ? pdflush+0x0/0x1c5
Oct  2 10:30:04 datengrab kernel: [<ffffffff81058001>] ? wb_kupdate+0x94/0x108
Oct  2 10:30:04 datengrab kernel: [<ffffffff8105897b>] ? pdflush+0x0/0x1c5
Oct  2 10:30:04 datengrab kernel: [<ffffffff81058a89>] ? pdflush+0x10e/0x1c5
Oct  2 10:30:04 datengrab kernel: [<ffffffff81057f6d>] ? wb_kupdate+0x0/0x108
Oct  2 10:30:04 datengrab kernel: [<ffffffff8103a7e9>] ? kthread+0x81/0x89
Oct  2 10:30:04 datengrab kernel: [<ffffffff8100ba0a>] ? child_rip+0xa/0x20
Oct  2 10:30:04 datengrab kernel: [<ffffffff8105897b>] ? pdflush+0x0/0x1c5
Oct  2 10:30:04 datengrab kernel: [<ffffffff8103a768>] ? kthread+0x0/0x89
Oct  2 10:30:04 datengrab kernel: [<ffffffff8100ba00>] ? child_rip+0x0/0x20
Oct  2 10:30:04 datengrab kernel: ---[ end trace ef71307e17570618 ]---
Oct  2 10:30:04 datengrab kernel: ------------[ cut here ]------------
Oct  2 10:30:04 datengrab kernel: WARNING: at fs/btrfs/free-space-cache.c:90 
tree_insert_offset+0x74/0xbb [btrfs]()
Oct  2 10:30:04 datengrab kernel: Hardware name: To Be Filled By O.E.M.
Oct  2 10:30:04 datengrab kernel: Modules linked in: snd_seq_midi 
snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_seq_oss 
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss btrfs zlib_deflate crc32c 
libcrc32c aes_x86_64 aes_generic xts gf128mul dm_crypt snd_emu10k1 snd_rawmidi 
snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc 
snd_util_mem snd_hwdep snd sg sr_mod ohci_hcd ehci_hcd uhci_hcd fglrx(P)
Oct  2 10:30:04 datengrab kernel: Pid: 258, comm: pdflush Tainted: P        W  
2.6.31.1 #1
Oct  2 10:30:04 datengrab kernel: Call Trace:
Oct  2 10:30:04 datengrab kernel: [<ffffffff8102b511>] ? 
warn_slowpath_common+0x76/0x8c
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0369c42>] ? 
tree_insert_offset+0x74/0xbb [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa036a0c2>] ? link_free_space+0x3b/0x51 
[btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa036a3c4>] ? 
btrfs_find_space_for_alloc+0x142/0x157 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0335692>] ? 
find_free_extent+0x48a/0x705 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffff81183071>] ? 
radix_tree_gang_lookup_slot+0x6b/0x8f
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0335d27>] ? 
__btrfs_reserve_extent+0x114/0x283 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0335ec3>] ? 
btrfs_reserve_extent+0x2d/0x54 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0346b99>] ? cow_file_range+0x1a7/0x302 
[btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0347359>] ? 
run_delalloc_range+0x9e/0x2ed [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa035c0b9>] ? 
find_lock_delalloc_range+0x123/0x178 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa035c756>] ? 
__extent_writepage+0x1d8/0x716 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa035ae38>] ? 
end_bio_extent_writepage+0x0/0x1a2 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffff8118320d>] ? 
radix_tree_gang_lookup_tag_slot+0x7a/0x9f
Oct  2 10:30:04 datengrab kernel: [<ffffffff810525cd>] ? 
find_get_pages_tag+0x36/0xbe
Oct  2 10:30:04 datengrab kernel: [<ffffffffa035cff4>] ? T.607+0x13f/0x287 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0345285>] ? 
__btrfs_submit_bio_start+0x0/0x24 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa034526e>] ? 
__btrfs_submit_bio_done+0x0/0x17 [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa035d237>] ? 
extent_writepages+0x41/0x5a [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffffa0345cfd>] ? 
btrfs_get_extent+0x0/0x70b [btrfs]
Oct  2 10:30:04 datengrab kernel: [<ffffffff81057ecc>] ? do_writepages+0x20/0x2d
Oct  2 10:30:04 datengrab kernel: [<ffffffff8108e61f>] ? 
writeback_single_inode+0x14c/0x325
Oct  2 10:30:04 datengrab kernel: [<ffffffff8108ebde>] ? 
generic_sync_sb_inodes+0x286/0x3e7
Oct  2 10:30:04 datengrab kernel: [<ffffffff81026d49>] ? update_curr+0x4e/0xc2
Oct  2 10:30:04 datengrab kernel: [<ffffffff8108ee26>] ? 
writeback_inodes+0x6d/0xa5
Oct  2 10:30:04 datengrab kernel: [<ffffffff8105897b>] ? pdflush+0x0/0x1c5
Oct  2 10:30:04 datengrab kernel: [<ffffffff81058001>] ? wb_kupdate+0x94/0x108
Oct  2 10:30:04 datengrab kernel: [<ffffffff8105897b>] ? pdflush+0x0/0x1c5
Oct  2 10:30:04 datengrab kernel: [<ffffffff81058a89>] ? pdflush+0x10e/0x1c5
Oct  2 10:30:04 datengrab kernel: [<ffffffff81057f6d>] ? wb_kupdate+0x0/0x108
Oct  2 10:30:04 datengrab kernel: [<ffffffff8103a7e9>] ? kthread+0x81/0x89
Oct  2 10:30:04 datengrab kernel: [<ffffffff8100ba0a>] ? child_rip+0xa/0x20
Oct  2 10:30:04 datengrab kernel: [<ffffffff8105897b>] ? pdflush+0x0/0x1c5
Oct  2 10:30:04 datengrab kernel: [<ffffffff8103a768>] ? kthread+0x0/0x89
Oct  2 10:30:04 datengrab kernel: [<ffffffff8100ba00>] ? child_rip+0x0/0x20
Oct  2 10:30:04 datengrab kernel: ---[ end trace ef71307e17570619 ]---


I've had to reboot with magic SysRq key. After that all went fine again. 
