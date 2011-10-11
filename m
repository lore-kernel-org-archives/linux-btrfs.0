From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: allow us to overcommit our enospc reservations
 TEST THIS PLEASE!!!
Date: Tue, 11 Oct 2011 15:00:50 -0400
Message-ID: <20111011190049.GG2293@localhost.localdomain>
References: <1317072155-26792-1-git-send-email-josef@redhat.com>
 <CAKcLGm_oFQOCCeFs69ohGfskkCj1FSbdxL18653ANoTX75n4SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm_oFQOCCeFs69ohGfskkCj1FSbdxL18653ANoTX75n4SQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2011 at 12:33:48PM -0500, Mitch Harder wrote:
> On Mon, Sep 26, 2011 at 4:22 PM, Josef Bacik <josef@redhat.com> wrote=
:
> >
> > go from taking around 45 minutes to 10 seconds on my freshly format=
ted 3 TiB
> > file system. =A0This doesn't seem to break my other enospc tests, b=
ut could really
> > use some more testing as this is a super scary change. =A0Thanks,
> >
>=20
> I've been testing Josef's git.kernel.org testing tree, and I've
> bisected an error down to this commit.
>=20
> I'm triggering the error using a removedirs benchmark in filebench
> with the following profile:
> load removedirs
> set $dir=3D/mnt/benchmark/filebench
> set $ndirs=3D400000
> run
>=20

Ok try this one, it will write out more and harder, see if that helps. =
 Thanks,

Josef


diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fc0de68..c81ca44 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3334,7 +3334,7 @@ out:
  * shrink metadata reservation for delalloc
  */
 static int shrink_delalloc(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, u64 to_reclaim, int sync)
+			   struct btrfs_root *root, u64 to_reclaim, int retries)
 {
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_space_info *space_info;
@@ -3365,12 +3365,10 @@ static int shrink_delalloc(struct btrfs_trans_h=
andle *trans,
 	}
=20
 	max_reclaim =3D min(reserved, to_reclaim);
+	if (max_reclaim > (2 * 1024 * 1024))
+		nr_pages =3D max_reclaim >> PAGE_CACHE_SHIFT;
=20
 	while (loops < 1024) {
-		/* have the flusher threads jump in and do some IO */
-		smp_mb();
-		nr_pages =3D min_t(unsigned long, nr_pages,
-		       root->fs_info->delalloc_bytes >> PAGE_CACHE_SHIFT);
 		writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages);
=20
 		spin_lock(&space_info->lock);
@@ -3384,14 +3382,22 @@ static int shrink_delalloc(struct btrfs_trans_h=
andle *trans,
 		if (reserved =3D=3D 0 || reclaimed >=3D max_reclaim)
 			break;
=20
-		if (trans && trans->transaction->blocked)
+		if (trans)
 			return -EAGAIN;
=20
-		time_left =3D schedule_timeout_interruptible(1);
+		if (!retries) {
+			time_left =3D schedule_timeout_interruptible(1);
=20
-		/* We were interrupted, exit */
-		if (time_left)
-			break;
+			/* We were interrupted, exit */
+			if (time_left)
+				break;
+		} else {
+			/*
+			 * We've already done this song and dance once, let's
+			 * really wait for some work to get done.
+			 */
+			btrfs_wait_ordered_extents(root, 0, 0);
+		}
=20
 		/* we've kicked the IO a few times, if anything has been freed,
 		 * exit.  There is no sense in looping here for a long time
@@ -3399,15 +3405,13 @@ static int shrink_delalloc(struct btrfs_trans_h=
andle *trans,
 		 * just too many writers without enough free space
 		 */
=20
-		if (loops > 3) {
+		if (!retries && loops > 3) {
 			smp_mb();
 			if (progress !=3D space_info->reservation_progress)
 				break;
 		}
=20
 	}
-	if (reclaimed < to_reclaim && !trans)
-		btrfs_wait_ordered_extents(root, 0, 0);
 	return reclaimed >=3D to_reclaim;
 }
=20
@@ -3552,7 +3556,7 @@ again:
 	 * We do synchronous shrinking since we don't actually unreserve
 	 * metadata until after the IO is completed.
 	 */
-	ret =3D shrink_delalloc(trans, root, num_bytes, 1);
+	ret =3D shrink_delalloc(trans, root, num_bytes, retries);
 	if (ret < 0)
 		goto out;
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
