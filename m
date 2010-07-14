From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
Date: Wed, 14 Jul 2010 17:25:23 +0200
Message-ID: <201007141725.24507.johannes.hirte@fem.tu-ilmenau.de>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de> <20100708143109.GR15984@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	zheng.yan@oracle.com, Jens Axboe <axboe@kernel.dk>,
	linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100708143109.GR15984@think>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag 08 Juli 2010, 16:31:09 schrieb Chris Mason:
> Neither Yan nor I have been able to reproduce this locally, but a few
> people have now hit it.  Johannes, are you available to try out a
> debugging kernel to try and track this down?
> 
> -chris
> 
> On Thu, Jul 08, 2010 at 04:27:23PM +0200, Johannes Hirte wrote:
> > When doing a 'rm -r /var/tmp/portage/sys-devel' I get the following Oops:
> > 
> > ------------[ cut here ]------------
> > kernel BUG at fs/btrfs/extent-tree.c:1353!
> > invalid opcode: 0000 [#1] PREEMPT SMP
> > last sysfs file:
> > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/power_supply/BAT0/charge_
> > full Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event
> > snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nfs lockd nfs_acl
> > auth_rpcgss sunrpc sco rfcomm bnep l2cap crc16 xts gf128mul usb_storage
> > dm_crypt dm_mod coretemp hwmon acpi_cpufreq mperf snd_hda_codec_realtek
> > uvcvideo iwl3945 snd_hda_intel snd_hda_codec iwlcore videodev r8169
> > snd_hwdep btusb snd_pcm v4l1_compat mac80211 snd_timer bluetooth snd mii
> > cfg80211 soundcore sg rfkill ac i2c_i801 snd_page_alloc uhci_hcd battery
> > [last unloaded: microcode]
> > 
> > Pid: 2358, comm: rm Not tainted 2.6.35-rc4 #32 M912/M912
> > EIP: 0060:[<c10c383b>] EFLAGS: 00010202 CPU: 1
> > EIP is at lookup_inline_extent_backref+0xf2/0x406
> > EAX: 00000001 EBX: 00000007 ECX: 00000000 EDX: 00000000
> > ESI: 00000004 EDI: f7268150 EBP: 00000004 ESP: f5aa5d08
> > 
> >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > 
> > Process rm (pid: 2358, ti=f5aa4000 task=f6f0fa70 task.ti=f5aa4000)
> > 
> > Stack:
> >  f702f8c0 f744e080 f665f380 000000b0 00000000 00000000 ffffffff f6c80f00
> > 
> > <0> f744e080 c10ec226 e98acfff f6c98000 00001001 0e987000 00000004
> > 00000000 <0> 00000850 040e9870 a8000000 00001000 00000000 00000007
> > 00000000 0e987000
> > 
> > Call Trace:
> >  [<c10ec226>] ? set_extent_dirty+0x19/0x1d
> >  [<c10c5081>] ? __btrfs_free_extent+0xda/0x675
> >  [<c10c88bf>] ? run_clustered_refs+0x699/0x6d7
> >  [<c10d239f>] ? btrfs_mark_buffer_dirty+0xa3/0xef
> >  [<c1101454>] ? btrfs_find_ref_cluster+0xf9/0x13a
> >  [<c10c89bc>] ? btrfs_run_delayed_refs+0xbf/0x155
> >  [<c10d3a73>] ? __btrfs_end_transaction+0x53/0x16c
> >  [<c10db480>] ? btrfs_delete_inode+0x166/0x17e
> >  [<c102280d>] ? get_parent_ip+0x8/0x19
> >  [<c108fe5c>] ? generic_delete_inode+0x6f/0xbd
> >  [<c108f5b3>] ? iput+0x46/0x48
> >  [<c10893a8>] ? do_unlinkat+0xc7/0x109
> >  [<c102280d>] ? get_parent_ip+0x8/0x19
> >  [<c10822e3>] ? fput+0x12/0x15c
> >  [<c10a2f30>] ? dnotify_flush+0x41/0xc2
> >  [<c107fe85>] ? filp_close+0x4c/0x52
> >  [<c107feed>] ? sys_close+0x62/0x9b
> >  [<c1002550>] ? sysenter_do_call+0x12/0x26
> > 
> > Code: 80 4e 68 02 8d 4c 24 43 89 f8 6a 01 ff 74 24 1c ff 74 24 08 8b 54
> > 24 38 e8 01 c2 ff ff 83 c4 0c 83 f8 00 0f 8c e1 02 00 00 74 02 <0f> 0b
> > 8b 04 24 8b 34 24 8b 00 8b 56 20 89 44 24 08 e8 2e fa ff
> > EIP: [<c10c383b>] lookup_inline_extent_backref+0xf2/0x406 SS:ESP
> > 0068:f5aa5d08 ---[ end trace d97601f0b455ca72 ]---
> > note: rm[2358] exited with preempt_count 2
> > BUG: scheduling while atomic: rm/2358/0x10000003
> > Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
> > snd_seq_device snd_pcm_oss snd_mixer_oss nfs lockd nfs_acl auth_rpcgss
> > sunrpc sco rfcomm bnep l2cap crc16 xts gf128mul usb_storage dm_crypt
> > dm_mod coretemp hwmon acpi_cpufreq mperf snd_hda_codec_realtek uvcvideo
> > iwl3945 snd_hda_intel snd_hda_codec iwlcore videodev r8169 snd_hwdep
> > btusb snd_pcm v4l1_compat mac80211 snd_timer bluetooth snd mii cfg80211
> > soundcore sg rfkill ac i2c_i801 snd_page_alloc uhci_hcd battery [last
> > unloaded: microcode]
> > Pid: 2358, comm: rm Tainted: G      D     2.6.35-rc4 #32
> > 
> > Call Trace:
> >  [<c12de6b3>] ? schedule+0x88/0x332
> >  [<c10237c1>] ? __cond_resched+0xf/0x19
> >  [<c12de9e2>] ? _cond_resched+0x12/0x18
> >  [<c106ceec>] ? unmap_vmas+0x4e7/0x534
> >  [<c1070c8f>] ? exit_mmap+0x64/0xa4
> >  [<c1026089>] ? mmput+0x21/0x96
> >  [<c102938e>] ? exit_mm+0xe7/0xf0
> >  [<c12dfa28>] ? _raw_spin_unlock_irqrestore+0x1a/0x24
> >  [<c103aaa1>] ? hrtimer_try_to_cancel+0x31/0x3a
> >  [<c102a42e>] ? do_exit+0x17b/0x57d
> >  [<c1028e78>] ? kmsg_dump+0x81/0xf9
> >  [<c1002d06>] ? do_invalid_op+0x0/0x76
> >  [<c1004fa0>] ? oops_end+0x72/0x75
> >  [<c1002d6f>] ? do_invalid_op+0x69/0x76
> >  [<c10c383b>] ? lookup_inline_extent_backref+0xf2/0x406
> >  [<c10bdc9a>] ? generic_bin_search.clone.0+0x145/0x150
> >  [<c10bcf30>] ? btrfs_cow_block+0x106/0x112
> >  [<c10bdcdc>] ? bin_search+0x37/0x3d
> >  [<c10bfe33>] ? btrfs_search_slot+0x405/0x477
> >  [<c12e031a>] ? error_code+0x66/0x6c
> >  [<c1002d06>] ? do_invalid_op+0x0/0x76
> >  [<c10c383b>] ? lookup_inline_extent_backref+0xf2/0x406
> >  [<c10ec226>] ? set_extent_dirty+0x19/0x1d
> >  [<c10c5081>] ? __btrfs_free_extent+0xda/0x675
> >  [<c10c88bf>] ? run_clustered_refs+0x699/0x6d7
> >  [<c10d239f>] ? btrfs_mark_buffer_dirty+0xa3/0xef
> >  [<c1101454>] ? btrfs_find_ref_cluster+0xf9/0x13a
> >  [<c10c89bc>] ? btrfs_run_delayed_refs+0xbf/0x155
> >  [<c10d3a73>] ? __btrfs_end_transaction+0x53/0x16c
> >  [<c10db480>] ? btrfs_delete_inode+0x166/0x17e
> >  [<c102280d>] ? get_parent_ip+0x8/0x19
> >  [<c108fe5c>] ? generic_delete_inode+0x6f/0xbd
> >  [<c108f5b3>] ? iput+0x46/0x48
> >  [<c10893a8>] ? do_unlinkat+0xc7/0x109
> >  [<c102280d>] ? get_parent_ip+0x8/0x19
> >  [<c10822e3>] ? fput+0x12/0x15c
> >  [<c10a2f30>] ? dnotify_flush+0x41/0xc2
> >  [<c107fe85>] ? filp_close+0x4c/0x52
> >  [<c107feed>] ? sys_close+0x62/0x9b
> >  [<c1002550>] ? sysenter_do_call+0x12/0x26

I'm not sure if btrfs is to blame for this error. After the errors I switched 
to XFS on this system and got now this error:

ls -l .kde4/share/apps/akregator/data/
ls: cannot access .kde4/share/apps/akregator/data/feeds.opml: Structure needs 
cleaning
total 4
?????????? ? ?    ?        ?            ? feeds.opml

xfs_check is showing this:

xfs_check /dev/sda3
link count mismatch for inode 219998792 (name ?), nlink 0, counted 1
disconnected inode 220064328, nlink 1

So this is the second FS I've got suddenly errors, so I think the problem lies 
deeper. Adding some CCs for this.


regards,
  Johannes
