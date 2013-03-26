Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54436 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933808Ab3CZNa5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 09:30:57 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9B1527C0402
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 07:30:56 -0600 (MDT)
Date: Tue, 26 Mar 2013 09:30:53 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
Message-ID: <20130326133053.GK1955@localhost.localdomain>
References: <20130322135322.GB1955@localhost.localdomain>
 <514C6319.7030400@profihost.ag>
 <20130322155453.GD1955@localhost.localdomain>
 <514CAC8D.7010409@profihost.ag>
 <20130322204932.GE1955@localhost.localdomain>
 <514CC52B.1000201@profihost.ag>
 <20130325201426.GG1955@localhost.localdomain>
 <51515226.9010509@profihost.ag>
 <20130326125319.GH1955@localhost.localdomain>
 <51519ABB.4030207@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51519ABB.4030207@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 26, 2013 at 06:55:23AM -0600, Stefan Priebe - Profihost AG wrote:
> Hi Josef,
> 
> Am 26.03.2013 13:53, schrieb Josef Bacik:
> > On Tue, Mar 26, 2013 at 01:45:42AM -0600, Stefan Priebe wrote:
> >> Hi,
> >>
> >> output here:
> >> [  590.546162] returning enospc, space_info 3, size 0 reserved 0, flush 
> >> 2, flush_state 7  dumping space info
> >> [  590.548280] space_info 4 has 6439292928 free, is full
> >> [  590.548283] space_info total=25748307968, used=19308916736, pinned=0, 
> >> reserved=32768, may_use=6438354944, readonly=65536
> >> [  590.550147] returning enospc, space_info 3, size 0 reserved 0, flush 
> >> 2, flush_state 7  dumping space info
> >> [  590.552264] space_info 4 has 6439284736 free, is full
> >> [  590.552267] space_info total=25748307968, used=19308916736, pinned=0, 
> >> reserved=40960, may_use=6438354944, readonly=65536
> >> [  590.554141] returning enospc, space_info 3, size 0 reserved 0, flush 
> >> 2, flush_state 7  dumping space info
> >> [  590.556258] space_info 4 has 6439284736 free, is full
> >> [  590.556261] space_info total=25748307968, used=19308916736, pinned=0, 
> >> reserved=40960, may_use=6438354944, readonly=65536
> >> [  591.145255] returning enospc, space_info 3, size 0 reserved 0, flush 
> >> 2, flush_state 7  dumping space info
> >> [  591.147373] space_info 4 has 6439235584 free, is full
> >> [  591.147375] space_info total=25748307968, used=19308916736, pinned=0, 
> >> reserved=90112, may_use=6438354944, readonly=65536
> >> [  595.560257] returning enospc, space_info 3, size 0 reserved 0, flush 
> >> 2, flush_state 7  dumping space info
> >> [  595.562390] space_info 4 has 6439120896 free, is full
> >> [  595.562393] space_info total=25748307968, used=19309047808, pinned=0, 
> >> reserved=73728, may_use=6438297600, readonly=65536
> >>
> > 
> > Weird, we have all the flushing stuff set and yet there is still a whole lot of
> > outstanding reservations.  Do you have compression enabled?  Thanks,
> 
> no - it's just mounted with mount -o noatime
> 
> :~# cat /proc/mounts | grep btrfs
> /dev/mapper/raid54tb1 /mnt btrfs rw,noatime,space_cache 0 0
>

Ok I think I see what's going on.  Can you try this patch and see if it fixes
it?  Thanks,

Josef

 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bf6433f..84e8909 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3803,6 +3803,19 @@ static int can_overcommit(struct btrfs_root *root,
 	return 0;
 }
 
+static int btrfs_try_writeback(struct super_block *sb, unsigned long nr_pages,
+			       enum wb_reason reason)
+{
+	if (!writeback_in_progress(sb->s_bdi) &&
+	    down_read_trylock(&sb->s_umount)) {
+		writeback_inodes_sb_nr(sb, nr_pages, reason);
+		up_read(&sb->s_umount);
+		return 1;
+	}
+
+	return 0;
+}
+
 void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
 				  unsigned long nr_pages)
 {
@@ -3810,8 +3823,7 @@ void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
 	int started;
 
 	/* If we can not start writeback, just sync all the delalloc file. */
-	started = try_to_writeback_inodes_sb_nr(sb, nr_pages,
-						      WB_REASON_FS_FREE_SPACE);
+	started = btrfs_try_writeback(sb, nr_pages, WB_REASON_FS_FREE_SPACE);
 	if (!started) {
 		/*
 		 * We needn't worry the filesystem going from r/w to r/o though
-- 
1.7.7.6

