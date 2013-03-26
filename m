Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34324 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab3CZOs7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 10:48:59 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A17969A067F
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 08:48:59 -0600 (MDT)
Date: Tue, 26 Mar 2013 10:48:55 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug on mismatching generation_v2 in inode.c:835
Message-ID: <20130326144855.GM1955@localhost.localdomain>
References: <CAAr69zZ7OpGpT7qcKdWA0k_0MR-wbhd-+EFGBQ+TQ5CycM8GDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAAr69zZ7OpGpT7qcKdWA0k_0MR-wbhd-+EFGBQ+TQ5CycM8GDg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 26, 2013 at 08:33:27AM -0600, Szőts Ákos wrote:
> Dear list members,
> 
> In my previous thread at
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg23333.html
> there was a space_cache kernel bug/panic on kernel 3.8. I could
> successfully "fix" that with rebuilding the cache. But some files were
> missing/corrupted. So I booted a rescue CD with kernel 3.7 and ran
> btrfsck --repair, which repaired quite a few things.
> 
> After a reboot I got the following message:
> [  469.457386] btrfs: disk space caching is enabled
> [  469.503612] btrfs: mismatching generation and generation_v2 found
> in root item. This root was probably mounted with an older kernel.
> Resetting all new fields.
> 
> As soon as anything had wanted to read a bit from the file system, the
> hard drive went crazy and was working for 5-10 minutes. After I got a
> kernel panic which said there's an error in fs/btrfs/inode.c:835.
> 
> In the moment I don't just mount, but want to read something from the
> mounted file system under the rescue system, the same procedure
> happens.
> 
> I made some pictures of it (since I cannot read anything from the
> logs, if there are any).
> You can find them here: www.morrohun.hu/temp/btrfs/v2/[123].jpg
> 
> I wanted to create an image with the aforementined btrfs-image tool,
> but yet to have any success .
> 
> Could you please give me an advice what can I do now? Living on a
> live-CD is not a life insurance :)
> 
> Best regards,
>

Ok I'd like to get btrfs-image working so I can run fsck on it here locally and
see what's wrong.  Can you apply this patch to my tree and rebuild and run
btrfs-image again, it should tell us why it's having trouble opening the device.
It also fixes that slight mkfs not compiling problem ;).  Thanks,

Josef

 
diff --git a/disk-io.c b/disk-io.c
index 72b33da..6d879c5 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1047,7 +1047,8 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 
 	fp = open(filename, flags, 0600);
 	if (fp < 0) {
-		fprintf (stderr, "Could not open %s\n", filename);
+		fprintf (stderr, "Could not open %s, %d (%s)\n", filename,
+			 errno, strerror(errno));
 		return NULL;
 	}
 	info = __open_ctree_fd(fp, filename, sb_bytenr, 0, writes, partial);
diff --git a/mkfs.c b/mkfs.c
index bc68350..003a8fa 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -296,7 +296,7 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 
 	if (!mixed) {
 		u64 total_bytes =
-			btrfs_super_total_bytes(root->fs_info->super_copy);
+			btrfs_super_total_bytes(&root->fs_info->super_copy);
 		u64 alloced_bytes = 0;
 		u64 alloc_flags = BTRFS_BLOCK_GROUP_ENOSPC |
 			(allowed & metadata_profile);
