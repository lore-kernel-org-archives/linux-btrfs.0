From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: Having parent transid verify failed
Date: Thu, 2 Jun 2011 18:36:43 +0200
Message-ID: <201106021836.45130.johannes.hirte@fem.tu-ilmenau.de>
References: <4DC287D8.3040705@gmail.com> <4DC3084A.7030100@gmail.com> <1304627478-sup-2626@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: Konstantinos Skarlatos <k.skarlatos@gmail.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304627478-sup-2626@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 05 May 2011 22:32:42 Chris Mason wrote:
> Excerpts from Konstantinos Skarlatos's message of 2011-05-05 16:27:54 -0400:
> > I think i made some progress. When i tried to remove the directory that
> > i suspect contains the problematic file, i got this on the console
> > 
> > rm -rf serverloft/
> 
> Ok, our one bad block is in the extent allocation tree.  This is going
> to be the very hardest thing to fix.
> 
> Until I finish off the code to rebuild parts of the extent allocation
> tree, I think your best bet is to copy the files off.
> 
> The big question is, what happened to make this error?  Can you describe
> your setup in more detail?
> 
> -chris

It seems that I run into the same problem:

parent transid verify failed on 32940560384 wanted 210334 found 210342
BUG: scheduling while atomic: chrome/17058/0x00000002
Modules linked in: snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
snd_pcm_oss snd_mixer_oss fuse dm_crypt dm_mod usbhid snd_intel8x0 
snd_ac97_codec sr_mod cdrom ac97_bus snd_pcm sg snd_timer snd e1000 fschmd 
uhci_hcd snd_page_alloc i2c_i801 [last unloaded: microcode]
Pid: 17058, comm: chrome Tainted: G        W   2.6.39 #29
Call Trace:
 [<c13cf70c>] ? schedule+0x78/0x6ef
 [<c11acabb>] ? generic_make_request+0x1d5/0x22f
 [<c11acbad>] ? submit_bio+0x98/0x9f
 [<c118026a>] ? btrfs_map_bio+0x1ab/0x1b5
 [<c13cfdc2>] ? io_schedule+0x3f/0x50
 [<c105723d>] ? sleep_on_page+0x5/0x8
 [<c13d0292>] ? __wait_on_bit+0x31/0x58
 [<c1057238>] ? __lock_page+0x52/0x52
 [<c1057388>] ? wait_on_page_bit+0x5a/0x62
 [<c1037f92>] ? autoremove_wake_function+0x29/0x29
 [<c117ab39>] ? read_extent_buffer_pages+0x33a/0x3b5
 [<c115891f>] ? btree_read_extent_buffer_pages.clone.51+0x44/0x9e
 [<c11578b0>] ? verify_parent_transid+0x147/0x147
 [<c11593aa>] ? read_tree_block+0x2d/0x3e
 [<c1144f90>] ? read_block_for_search.clone.36+0xc3/0x35d
 [<c11863bf>] ? btrfs_tree_unlock+0x19/0x3a
 [<c11420bb>] ? unlock_up+0x88/0x9f
 [<c1146f7e>] ? btrfs_search_slot+0x39d/0x4fe
 [<c1149fa1>] ? lookup_inline_extent_backref+0x116/0x49b
 [<c11773b0>] ? set_extent_dirty+0x19/0x1d
 [<c114cbd0>] ? __btrfs_free_extent+0xe2/0x6c6
 [<c114fa28>] ? run_clustered_refs+0x6ad/0x720
 [<c1191330>] ? btrfs_find_ref_cluster+0x53/0x11f
 [<c114fb53>] ? btrfs_run_delayed_refs+0xb8/0x18d
 [<c115d395>] ? __btrfs_end_transaction+0x5a/0x17f
 [<c115d4dc>] ? btrfs_end_transaction+0x9/0xb
 [<c1165e19>] ? btrfs_evict_inode+0x190/0x1a7
 [<c1092c45>] ? evict+0x56/0xeb
 [<c108baa8>] ? do_unlinkat+0xc3/0x103
 [<c13d1c90>] ? sysenter_do_call+0x12/0x26
 [<c13d0000>] ? console_conditional_schedule+0x8/0xf
parent transid verify failed on 32940560384 wanted 210334 found 210342
BUG: scheduling while atomic: chrome/17058/0x00000002
Modules linked in: snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
snd_pcm_oss snd_mixer_oss fuse dm_crypt dm_mod usbhid snd_intel8x0 
snd_ac97_codec sr_mod cdrom ac97_bus snd_pcm sg snd_timer snd e1000 fschmd 
uhci_hcd snd_page_alloc i2c_i801 [last unloaded: microcode]
Pid: 17058, comm: chrome Tainted: G        W   2.6.39 #29
Call Trace:
 [<c13cf70c>] ? schedule+0x78/0x6ef
 [<c11acabb>] ? generic_make_request+0x1d5/0x22f
 [<c11acbad>] ? submit_bio+0x98/0x9f
 [<c118026a>] ? btrfs_map_bio+0x1ab/0x1b5
 [<c13cfdc2>] ? io_schedule+0x3f/0x50
 [<c105723d>] ? sleep_on_page+0x5/0x8
 [<c13d0292>] ? __wait_on_bit+0x31/0x58
 [<c1057238>] ? __lock_page+0x52/0x52
 [<c1057388>] ? wait_on_page_bit+0x5a/0x62
 [<c1037f92>] ? autoremove_wake_function+0x29/0x29
 [<c117ab39>] ? read_extent_buffer_pages+0x33a/0x3b5
 [<c116bd50>] ? lookup_extent_mapping+0x5a/0x148
 [<c115891f>] ? btree_read_extent_buffer_pages.clone.51+0x44/0x9e
 [<c11578b0>] ? verify_parent_transid+0x147/0x147
 [<c11593aa>] ? read_tree_block+0x2d/0x3e
 [<c1144f90>] ? read_block_for_search.clone.36+0xc3/0x35d
 [<c11863bf>] ? btrfs_tree_unlock+0x19/0x3a
 [<c11420bb>] ? unlock_up+0x88/0x9f
 [<c1146f7e>] ? btrfs_search_slot+0x39d/0x4fe
 [<c1149fa1>] ? lookup_inline_extent_backref+0x116/0x49b
 [<c11773b0>] ? set_extent_dirty+0x19/0x1d
 [<c114cbd0>] ? __btrfs_free_extent+0xe2/0x6c6
 [<c114fa28>] ? run_clustered_refs+0x6ad/0x720
 [<c1191330>] ? btrfs_find_ref_cluster+0x53/0x11f
 [<c114fb53>] ? btrfs_run_delayed_refs+0xb8/0x18d
 [<c115d395>] ? __btrfs_end_transaction+0x5a/0x17f
 [<c115d4dc>] ? btrfs_end_transaction+0x9/0xb
 [<c1165e19>] ? btrfs_evict_inode+0x190/0x1a7
 [<c1092c45>] ? evict+0x56/0xeb
 [<c108baa8>] ? do_unlinkat+0xc3/0x103
 [<c13d1c90>] ? sysenter_do_call+0x12/0x26
 [<c13d0000>] ? console_conditional_schedule+0x8/0xf
parent transid verify failed on 32940560384 wanted 210334 found 210342
BUG: scheduling while atomic: chrome/17058/0x00000002
Modules linked in: snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
snd_pcm_oss snd_mixer_oss fuse dm_crypt dm_mod usbhid snd_intel8x0 
snd_ac97_codec sr_mod cdrom ac97_bus snd_pcm sg snd_timer snd e1000 fschmd 
uhci_hcd snd_page_alloc i2c_i801 [last unloaded: microcode]
Pid: 17058, comm: chrome Tainted: G        W   2.6.39 #29
Call Trace:
 [<c13cf70c>] ? schedule+0x78/0x6ef
 [<c11acabb>] ? generic_make_request+0x1d5/0x22f
 [<c11acbad>] ? submit_bio+0x98/0x9f
 [<c118026a>] ? btrfs_map_bio+0x1ab/0x1b5
 [<c13cfdc2>] ? io_schedule+0x3f/0x50
 [<c105723d>] ? sleep_on_page+0x5/0x8
 [<c13d0292>] ? __wait_on_bit+0x31/0x58
 [<c1057238>] ? __lock_page+0x52/0x52
 [<c1057388>] ? wait_on_page_bit+0x5a/0x62
 [<c1037f92>] ? autoremove_wake_function+0x29/0x29
 [<c117ab39>] ? read_extent_buffer_pages+0x33a/0x3b5
 [<c116bd50>] ? lookup_extent_mapping+0x5a/0x148
 [<c115891f>] ? btree_read_extent_buffer_pages.clone.51+0x44/0x9e
 [<c11578b0>] ? verify_parent_transid+0x147/0x147
 [<c11593aa>] ? read_tree_block+0x2d/0x3e
 [<c1144f90>] ? read_block_for_search.clone.36+0xc3/0x35d
 [<c11863bf>] ? btrfs_tree_unlock+0x19/0x3a
 [<c11420bb>] ? unlock_up+0x88/0x9f
 [<c1146f7e>] ? btrfs_search_slot+0x39d/0x4fe
 [<c1149fa1>] ? lookup_inline_extent_backref+0x116/0x49b
 [<c11773b0>] ? set_extent_dirty+0x19/0x1d
 [<c114cbd0>] ? __btrfs_free_extent+0xe2/0x6c6
 [<c114fa28>] ? run_clustered_refs+0x6ad/0x720
 [<c1191330>] ? btrfs_find_ref_cluster+0x53/0x11f
 [<c114fb53>] ? btrfs_run_delayed_refs+0xb8/0x18d
 [<c115d395>] ? __btrfs_end_transaction+0x5a/0x17f
 [<c115d4dc>] ? btrfs_end_transaction+0x9/0xb
 [<c1165e19>] ? btrfs_evict_inode+0x190/0x1a7
 [<c1092c45>] ? evict+0x56/0xeb
 [<c108baa8>] ? do_unlinkat+0xc3/0x103
 [<c13d1c90>] ? sysenter_do_call+0x12/0x26
 [<c13d0000>] ? console_conditional_schedule+0x8/0xf
parent transid verify failed on 32940560384 wanted 210334 found 210342
parent transid verify failed on 32940560384 wanted 210334 found 210342
BUG: unable to handle kernel NULL pointer dereference at 0000001c
IP: [<c1153acd>] btrfs_print_leaf+0xd/0x76e
*pdpt = 00000000220ee001 *pde = 0000000000000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
Modules linked in: snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
snd_pcm_oss snd_mixer_oss fuse dm_crypt dm_mod usbhid snd_intel8x0 
snd_ac97_codec sr_mod cdrom ac97_bus snd_pcm sg snd_timer snd e1000 fschmd 
uhci_hcd snd_page_alloc i2c_i801 [last unloaded: microcode]

Pid: 17058, comm: chrome Tainted: G        W   2.6.39 #29 FUJITSU SIEMENS 
SCENIC P / SCENICO P/D1561
EIP: 0060:[<c1153acd>] EFLAGS: 00010296 CPU: 1
EIP is at btrfs_print_leaf+0xd/0x76e
EAX: f6414800 EBX: f6414800 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: f602b1c0 EBP: fffffffb ESP: d63ddd44
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process chrome (pid: 17058, ti=d63dc000 task=e2375b00 task.ti=d63dc000)
Stack:
 00000000 00000000 00000000 f602b1c0 00000000 c114cbd0 d63ddde4 d5d86000
 00000022 00001000 00000000 00000000 00000000 0000014e 00000000 0000014e
 00000000 f602b1c0 fffffffb c114ce06 00000000 00000000 00000026 f6414800
Call Trace:
 [<c114cbd0>] ? __btrfs_free_extent+0xe2/0x6c6
 [<c114ce06>] ? __btrfs_free_extent+0x318/0x6c6
 [<c114fa28>] ? run_clustered_refs+0x6ad/0x720
 [<c1191330>] ? btrfs_find_ref_cluster+0x53/0x11f
 [<c114fb53>] ? btrfs_run_delayed_refs+0xb8/0x18d
 [<c115d395>] ? __btrfs_end_transaction+0x5a/0x17f
 [<c115d4dc>] ? btrfs_end_transaction+0x9/0xb
 [<c1165e19>] ? btrfs_evict_inode+0x190/0x1a7
 [<c1092c45>] ? evict+0x56/0xeb
 [<c108baa8>] ? do_unlinkat+0xc3/0x103
 [<c13d1c90>] ? sysenter_do_call+0x12/0x26
 [<c13d0000>] ? console_conditional_schedule+0x8/0xf
Code: 01 00 8b 0c 24 51 56 53 55 57 52 50 68 bd b0 4b c1 e8 87 b9 27 00 83 c4 
2c 5b 5e 5f 5d c3 55 57 56 53 83 ec 3c 89 c3 89 54 24 04 <8b> 42 1c e8 68 8e 
ec ff 8b 50 60 89 54 24 24 e8 f4 8c ec ff 8b 
EIP: [<c1153acd>] btrfs_print_leaf+0xd/0x76e SS:ESP 0068:d63ddd44
CR2: 000000000000001c
---[ end trace 8a0695cc90b08578 ]---

The setup is a single disk installation with one filesystem and three 
subvolumes (default one, one for / and one for /home). When it first time 
happened, the kernel was 2.6.39-rc6 and only the home-subvolume was affected. 
Now I get a panic when booting the system.
If you need more infos, please tell me.

regards,
  Johannes
