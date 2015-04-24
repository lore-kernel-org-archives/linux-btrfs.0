Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56597 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474AbbDXNdh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 09:33:37 -0400
Date: Fri, 24 Apr 2015 09:33:30 -0400
From: Chris Mason <clm@fb.com>
To: Filipe David Manana <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] btrfs: reduce block group cache writeout times
 during commit
Message-ID: <20150424133330.GA2412@ret.masoncoding.com>
References: <pan.2015.04.22.16.37.38@googlemail.com>
 <5537D27E.3080609@fb.com>
 <CAL3q7H4ccdcJYKZaH_fYW9EUPCSTa3gDz_fiUjP8TvCUvQtxTQ@mail.gmail.com>
 <5538EB05.7050200@fb.com>
 <CAL3q7H6wUMruqTvKwMqcTXcgJv2fFw1GFN9QxyfE5GKqR-GNew@mail.gmail.com>
 <20150423151704.GA25585@ret.masoncoding.com>
 <CAL3q7H7oOcTZyCkP0NVWzQ3cKdJD=GDnM6+wM83D9_szHCX95g@mail.gmail.com>
 <CAL3q7H6+x7y64rZfRniJVDP8OwbNWCLuAC7M9D9OWY2urTsnWg@mail.gmail.com>
 <55394CEE.5030205@fb.com>
 <CAL3q7H7sM9Z4AbyuJUy5A9PkhrfOB=eQq_2ZRu9nRgjOwkVA6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAL3q7H7sM9Z4AbyuJUy5A9PkhrfOB=eQq_2ZRu9nRgjOwkVA6w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 24, 2015 at 07:34:43AM +0100, Filipe David Manana wrote:
> There's also one list corruption I didn't get before and happened
> while running fsstress (btrfs/078), apparently due to some race:
> 
> [25590.799058] ------------[ cut here ]------------
> [25590.800204] WARNING: CPU: 3 PID: 7280 at lib/list_debug.c:62
> __list_del_entry+0x5a/0x98()
> [25590.802101] list_del corruption. next->prev should be
> ffff8801a0f74d50, but was a56b6b6b6b6b6b6b
> [25590.804236] Modules linked in: btrfs dm_flakey dm_mod
> crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs
> lockd grace fscache sunrpc loop fuse i2c_piix4 i2c_core psmouse
> serio_raw evdev parport_pc parport acpi_cpufreq processor button
> pcspkr thermal_sys microcode ext4 crc16 jbd2 mbcache sd_mod sg sr_mod
> cdrom virtio_scsi ata_generic virtio_pci virtio_ring ata_piix e1000
> virtio libata floppy scsi_mod [last unloaded: btrfs]
> [25590.818580] CPU: 3 PID: 7280 Comm: fsstress Tainted: G        W
>   4.0.0-rc5-btrfs-next-9+ #1
> [25590.820597] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
> 04/01/2014
> [25590.823458]  0000000000000009 ffff8803f031bc08 ffffffff8142fa46
> ffffffff8108b6a2
> [25590.825081]  ffff8803f031bc58 ffff8803f031bc48 ffffffff81045ea5
> 0000000000000011
> [25590.826568]  ffffffff81245af7 ffff8801a0f74d50 ffff8801a0f74460
> ffff880041710df0
> [25590.828106] Call Trace:
> [25590.828630]  [<ffffffff8142fa46>] dump_stack+0x4f/0x7b
> [25590.829706]  [<ffffffff8108b6a2>] ? console_unlock+0x361/0x3ad
> [25590.830785]  [<ffffffff81045ea5>] warn_slowpath_common+0xa1/0xbb
> [25590.831957]  [<ffffffff81245af7>] ? __list_del_entry+0x5a/0x98
> [25590.867473]  [<ffffffff81045f05>] warn_slowpath_fmt+0x46/0x48
> [25590.868631]  [<ffffffffa04907e2>] ? btrfs_csum_data+0x16/0x18 [btrfs]
> [25590.869524]  [<ffffffff81245af7>] __list_del_entry+0x5a/0x98
> [25590.870918]  [<ffffffffa04cff5f>] write_bitmap_entries+0x99/0xbd [btrfs]

Can you please see which line write_bitmap_entries+0x99 is?

I'm hoping this will fix it:

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d773f22..5c7746f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1119,18 +1119,21 @@ static int flush_dirty_cache(struct inode *inode)
 }
 
 static void noinline_for_stack
-cleanup_write_cache_enospc(struct inode *inode,
+cleanup_write_cache_enospc(struct btrfs_free_space_ctl *ctl,
+			   struct inode *inode,
 			   struct btrfs_io_ctl *io_ctl,
 			   struct extent_state **cached_state,
 			   struct list_head *bitmap_list)
 {
 	struct list_head *pos, *n;
 
+	spin_lock(&ctl->tree_lock);
 	list_for_each_safe(pos, n, bitmap_list) {
 		struct btrfs_free_space *entry =
 			list_entry(pos, struct btrfs_free_space, list);
 		list_del_init(&entry->list);
 	}
+	spin_unlock(&ctl->tree_lock);
 	io_ctl_drop_pages(io_ctl);
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
 			     i_size_read(inode) - 1, cached_state,
@@ -1345,7 +1348,8 @@ out:
 	return ret;
 
 out_nospc:
-	cleanup_write_cache_enospc(inode, io_ctl, &cached_state, &bitmap_list);
+	cleanup_write_cache_enospc(ctl, inode, io_ctl,
+				   &cached_state, &bitmap_list);
 
 	if (block_group && (block_group->flags & BTRFS_BLOCK_GROUP_DATA))
 		up_write(&block_group->data_rwsem);

