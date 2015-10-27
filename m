Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60938 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbbJ0FOW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 01:14:22 -0400
Date: Tue, 27 Oct 2015 01:14:03 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 06/21] btrfs: delayed_ref: Add new function to record
 reserved space into delayed ref
Message-ID: <20151027051403.GA23134@ret.thefacebook.com>
References: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1444702827-18169-7-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H7mvHDYESXYHVYxJC7Yr+yXbvmajaRkWO7nu6iZBOYmSQ@mail.gmail.com>
 <562EF9D7.50101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <562EF9D7.50101@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 27, 2015 at 12:13:11PM +0800, Qu Wenruo wrote:
> 
> 
> Filipe Manana wrote on 2015/10/25 14:39 +0000:
> >On Tue, Oct 13, 2015 at 3:20 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> >>Add new function btrfs_add_delayed_qgroup_reserve() function to record
> >>how much space is reserved for that extent.
> >>
> >>As btrfs only accounts qgroup at run_delayed_refs() time, so newly
> >>allocated extent should keep the reserved space until then.
> >>
> >>So add needed function with related members to do it.
> >>
> >>Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> >>---
> >>v2:
> >>   None
> >>v3:
> >>   None
> >>---
> >>  fs/btrfs/delayed-ref.c | 29 +++++++++++++++++++++++++++++
> >>  fs/btrfs/delayed-ref.h | 14 ++++++++++++++
> >>  2 files changed, 43 insertions(+)
> >>
> >>diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> >>index ac3e81d..bd9b63b 100644
> >>--- a/fs/btrfs/delayed-ref.c
> >>+++ b/fs/btrfs/delayed-ref.c
> >>@@ -476,6 +476,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
> >>         INIT_LIST_HEAD(&head_ref->ref_list);
> >>         head_ref->processing = 0;
> >>         head_ref->total_ref_mod = count_mod;
> >>+       head_ref->qgroup_reserved = 0;
> >>+       head_ref->qgroup_ref_root = 0;
> >>
> >>         /* Record qgroup extent info if provided */
> >>         if (qrecord) {
> >>@@ -746,6 +748,33 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
> >>         return 0;
> >>  }
> >>
> >>+int btrfs_add_delayed_qgroup_reserve(struct btrfs_fs_info *fs_info,
> >>+                                    struct btrfs_trans_handle *trans,
> >>+                                    u64 ref_root, u64 bytenr, u64 num_bytes)
> >>+{
> >>+       struct btrfs_delayed_ref_root *delayed_refs;
> >>+       struct btrfs_delayed_ref_head *ref_head;
> >>+       int ret = 0;
> >>+
> >>+       if (!fs_info->quota_enabled || !is_fstree(ref_root))
> >>+               return 0;
> >>+
> >>+       delayed_refs = &trans->transaction->delayed_refs;
> >>+
> >>+       spin_lock(&delayed_refs->lock);
> >>+       ref_head = find_ref_head(&delayed_refs->href_root, bytenr, 0);
> >>+       if (!ref_head) {
> >>+               ret = -ENOENT;
> >>+               goto out;
> >>+       }
> >
> >Hi Qu,
> >
> >So while running btrfs/063, with qgroups enabled (I modified the test
> >to enable qgroups), ran into this 2 times:
> >
> >[169125.246506] BTRFS info (device sdc): disk space caching is enabled
> >[169125.363164] ------------[ cut here ]------------
> >[169125.365236] WARNING: CPU: 10 PID: 2827 at fs/btrfs/inode.c:2929
> >btrfs_finish_ordered_io+0x347/0x4eb [btrfs]()
> >[169125.367702] BTRFS: Transaction aborted (error -2)
> >[169125.368830] Modules linked in: btrfs dm_flakey dm_mod
> >crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs
> >lockd grace fscache sunrpc loop fuse parport_pc parport i2c_piix4
> >psmouse acpi_cpufreq microcode pcspkr processor evdev i2c_core
> >serio_raw button ext4 crc16 jbd2 mbcache sd_mod sg sr_mod cdrom
> >ata_generic virtio_scsi ata_piix libata floppy virtio_pci virtio_ring
> >scsi_mod e1000 virtio [last unloaded: btrfs]
> >[169125.376755] CPU: 10 PID: 2827 Comm: kworker/u32:14 Tainted: G
> >   W       4.3.0-rc5-btrfs-next-17+ #1
> 
> Hi Filipe,
> 
> Although not related to the bug report, I'm a little interested in your
> testing kernel.
> 
> Are you testing integration-4.4 from Chris repo?
> Or 4.3-rc from mainline repo with my qgroup reserve patchset applied?
> 
> Although integration-4.4 already merged qgroup reserve patchset, but it's
> causing some strange bug like over decrease data sinfo->bytes_may_use,
> mainly in generic/127 testcase.
> 
> But if qgroup reserve patchset is rebased to integration-4.3 (I did all my
> old tests based on that), no generic/127 problem at all.

Did I mismerge things?

-chris
