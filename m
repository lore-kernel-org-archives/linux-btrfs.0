From: Neil Schemenauer <nas@arctrix.com>
Subject: warning in btrfs_free_block_groups
Date: Wed, 9 Feb 2011 11:39:03 -0600
Message-ID: <20110209173903.GA23239@python.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I suspect this might be related to previous btrfs errors I've had on
the same filesystem.  See:

    http://python.ca/nas/linux/btrfs_bug.txt

The most recent kernel message is:

    WARNING: at fs/btrfs/extent-tree.c:8239 btrfs_free_block_groups+0x218/0x275()
    Hardware name: MS-7388
    Modules linked in: udf crc_itu_t isofs loop nls_iso8859_1 vboxnetflt vboxdrv nls_utf8 nls_cp437 vfat fat kvm_amd kvm ipv6 fuse f71882fg snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore r8169 i2c_piix4 snd_page_alloc usblp
    Pid: 13197, comm: umount Tainted: G        W   2.6.37-rc8 #54
    Call Trace:
     [<ffffffff810398d3>] warn_slowpath_common+0x80/0x98
     [<ffffffff81039900>] warn_slowpath_null+0x15/0x17
     [<ffffffff81155aec>] btrfs_free_block_groups+0x218/0x275
     [<ffffffff81164597>] close_ctree+0x183/0x344
     [<ffffffff810bc2c5>] ? destroy_inode+0x38/0x4e
     [<ffffffff810bc385>] ? dispose_list+0xaa/0xc0
     [<ffffffff8114a040>] btrfs_put_super+0x18/0x27
     [<ffffffff810ac3a2>] generic_shutdown_super+0x66/0xe1
     [<ffffffff810ac468>] kill_anon_super+0x11/0x49
     [<ffffffff810ab6fa>] deactivate_locked_super+0x21/0x41
     [<ffffffff810abba6>] deactivate_super+0x40/0x44
     [<ffffffff810bfcfe>] mntput_no_expire+0xdd/0x10b
     [<ffffffff810c0276>] sys_umount+0x2d2/0x2fd
     [<ffffffff810028bb>] system_call_fastpath+0x16/0x1b
    ---[ end trace 3f9c8cf600895a9f ]---
    space_info has 1751910400 free, is not full
    space_info total=5377097728, used=3611955200, pinned=0, reserved=4843520, may_use=0, readonly=8388608

The code is:

    while(!list_empty(&info->space_info)) {
        space_info = list_entry(info->space_info.next,
                    struct btrfs_space_info,
                    list);
        if (space_info->bytes_pinned > 0 ||
            space_info->bytes_reserved > 0) {
            WARN_ON(1);
            dump_space_info(space_info, 0, 0);
        }
        list_del(&space_info->list);
        kfree(space_info);
    }
    return 0;

When I tried btrfsck, I get:

    btrfsck: btrfsck.c:584: splice_shared_node: Assertion `!(src == &src_node->root_cache)' failed.

I'm making heavy use of subvolume snapshots.  The partition is
being used for backups and I use 'rsync --inplace' along with the
CoW feature to preserve space.

Regards,

  Neil
