Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD0842E004;
	Tue, 16 Jun 2026 11:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781610120; cv=none; b=izEpU3o6oqOdwqvuMGow9L2YQjGkTNwa1zXwh7C/dXdQlBAt6sCGxeB5JJmbv75g8KozHzvXej0HqSWqUuJcKSARwfgDzT0Gn2lZSqwAgFKK//2/07uDws2n0VlmcaXX/sPQuQYDOVFdMz3MmxZPdZsSLIn2Ipg9JxJA8g2gNdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781610120; c=relaxed/simple;
	bh=Q2H8Q5oZoCKwXJzLTaolymrMNeCDNy+1NXp7olYM2t8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OtONYNU45rhUqVF66IWYOa9Msrw4RqT9MwNmAEIkxRBgZB+2RjW0E4ujWtHwm/dqHYmaPj9R0K4NxUKwo/0m493n7WlO9IFBlA4B2n+tyv9iNxEETbo96voVX+hjLsBYez97TlwFKBKAvluyQgxL6IIaDT5bn3aQFzOTUrSanMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awne7RLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awne7RLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F121F00A3D;
	Tue, 16 Jun 2026 11:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781610118;
	bh=L/7K/apxV0sRO/3BBLIPR4xFcZPnDkB3ZGwISoTDSQw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=awne7RLfP8C7GrmYymXUWPdqcY5cqGWYtFcqiUeDlesUd2doshc/u6WH+GC6AVXdd
	 Gfi6MroTvcSh9HIafDXUZmt15qYbRLXpcYS7ruaMpRov5M5daJK+vsVDwhqin5tK/1
	 u+ztkTGaXn56Xware4Cs0G3Xrq2G+RduJPB1qCapgm/QITuhictkiofLRJ080WwXaA
	 BkzkF0EQKzn0p40qup0AA1yR2rHKHNyWTjCsWjNJJ44kvYLqULKNoEteasJOz21N4w
	 APYeLbp90gLvzxvM+fqN6LjN/KnlS//q/OqoezuIpw+AE89d3R3xAr325tRNDYRgal
	 OBQTFURDaWURQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 13:41:16 +0200
Subject: [PATCH 7/7] btrfs: keep the exclusive op held while a dev-replace
 is suspended in-mount
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-btrfs-preexisting-fixes-v1-7-c4abe2f6d4f0@kernel.org>
References: <20260616-work-btrfs-preexisting-fixes-v1-0-c4abe2f6d4f0@kernel.org>
In-Reply-To: <20260616-work-btrfs-preexisting-fixes-v1-0-c4abe2f6d4f0@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naota@elisp.net>, 
 linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>, 
 Stefan Behrens <sbehrens@giantdisaster.de>, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=11570; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Q2H8Q5oZoCKwXJzLTaolymrMNeCDNy+1NXp7olYM2t8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZmmWXvfRosNFonf+P98ZB5Ve9dlPtpp7zKvbsuGIsm
 fOWS/tDRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESSghj+p0y+EndEs2hTwrLj
 h89Y/LvCdOrQ+6lty+Q417Qctv/mL8bI8JrllrjI1JUP5aOXHdq28JPeXcdoL0OH7IzXtyZ3ywS
 nMAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

btrfs serialises balance and device add/remove/replace/resize through the
single fs_info->exclusive_operation token; a balance can only start when the
token is BTRFS_EXCLOP_NONE.

When btrfs_dev_replace_finishing() fails on one of its early legs --
btrfs_start_delalloc_roots() or btrfs_start_transaction() returning an error
such as -ENOMEM -- the replace is left pending in-mount: the source and target
devices stay in place and writes are still mirrored to the target
(btrfs_dev_replace_is_ongoing() stays true).  The callers, however, release the
exclusive op unconditionally -- both btrfs_dev_replace_kthread() and the
BTRFS_IOCTL_DEV_REPLACE_CMD_START ioctl call btrfs_exclop_finish() regardless of
the outcome.  With the token back to NONE a balance can claim it and run against
the still-pending replace, which the token exists to prevent: balance relocates
extents that are mirrored to the target during the window, while a later resume
drives the copy from the source commit root starting at committed_cursor_left,
so the two can disagree and leave stale data on the target after the devices are
swapped.

This is the exclusive-op lifetime tightening deferred by the SUSPENDED demotion
in "btrfs: don't leave dev-replace STARTED after an early finishing failure".
Mirror how a paused balance keeps owning the token (BTRFS_EXCLOP_BALANCE_PAUSED):
a replace suspended while the filesystem stays mounted keeps
BTRFS_EXCLOP_DEV_REPLACE, so every other exclusive operation is rejected exactly
as during an active replace.

btrfs_dev_replace_finishing() now reports whether it suspended the replace
through an output parameter, captured from its own outcome rather than re-read
from the shared state (which a racing cancel could change underneath us).  The
two callers keep the token when the replace was suspended and release it
otherwise.  The release goes through a new btrfs_exclop_finish_if() that only
drops the token when it is still BTRFS_EXCLOP_DEV_REPLACE: a replace suspended
across a mount that could not be resumed does not own the token -- a recovered
paused balance may -- and must not have it cleared from under it.
btrfs_dev_replace_cancel() releases the retained token the same way once the
suspended replace has been torn down.  Its own btrfs_start_transaction()
failure leg now falls through to that teardown and token release rather than
returning early, since the replace is already marked canceled at that point.

The across-mount degraded-resume cases (missing target, or the exclusive op
already taken at resume) and the rw->ro remount path leave the replace suspended
without owning the token; closing those needs a balance-side back-off and is
left as a separate change.

Fixes: e93c89c1aaaa ("Btrfs: add new sources for device replace code")
Fixes: 5ac00addc7ac ("Btrfs: disallow mutually exclusive admin operations from user mode")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/dev-replace.c | 36 ++++++++++++++++++++++++------------
 fs/btrfs/dev-replace.h |  3 ++-
 fs/btrfs/fs.c          | 17 +++++++++++++++++
 fs/btrfs/fs.h          |  2 ++
 fs/btrfs/ioctl.c       |  9 +++++++--
 5 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 6420f235ccd7..2f2b775478df 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -64,7 +64,7 @@
  */
 
 static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
-				       int scrub_ret);
+				       int scrub_ret, bool *suspended);
 static int btrfs_dev_replace_kthread(void *data);
 static void btrfs_rm_dev_replace_blocked(struct btrfs_fs_info *fs_info);
 static void btrfs_rm_dev_replace_unblocked(struct btrfs_fs_info *fs_info);
@@ -587,7 +587,7 @@ bool btrfs_finish_block_group_to_copy(struct btrfs_device *srcdev,
 
 static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 		const char *tgtdev_name, u64 srcdevid, const char *srcdev_name,
-		int read_src)
+		int read_src, bool *suspended)
 {
 	struct btrfs_root *root = fs_info->dev_root;
 	struct btrfs_trans_handle *trans;
@@ -707,7 +707,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 			      btrfs_device_get_total_bytes(src_device),
 			      &dev_replace->scrub_progress, false, true);
 
-	ret = btrfs_dev_replace_finishing(fs_info, ret);
+	ret = btrfs_dev_replace_finishing(fs_info, ret, suspended);
 	if (ret == -EINPROGRESS)
 		ret = BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS;
 
@@ -736,7 +736,8 @@ static int btrfs_check_replace_dev_names(struct btrfs_ioctl_dev_replace_args *ar
 }
 
 int btrfs_dev_replace_by_ioctl(struct btrfs_fs_info *fs_info,
-			    struct btrfs_ioctl_dev_replace_args *args)
+			    struct btrfs_ioctl_dev_replace_args *args,
+			    bool *suspended)
 {
 	int ret;
 
@@ -754,7 +755,8 @@ int btrfs_dev_replace_by_ioctl(struct btrfs_fs_info *fs_info,
 	ret = btrfs_dev_replace_start(fs_info, args->start.tgtdev_name,
 					args->start.srcdevid,
 					args->start.srcdev_name,
-					args->start.cont_reading_from_srcdev_mode);
+					args->start.cont_reading_from_srcdev_mode,
+					suspended);
 	args->result = ret;
 	/* don't warn if EINPROGRESS, someone else might be running scrub */
 	if (ret == BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS ||
@@ -877,7 +879,7 @@ static void btrfs_dev_replace_set_suspended(struct btrfs_fs_info *fs_info)
 }
 
 static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
-				       int scrub_ret)
+				       int scrub_ret, bool *suspended)
 {
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
@@ -888,6 +890,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	struct btrfs_trans_handle *trans;
 	int ret = 0;
 
+	*suspended = false;
+
 	/* don't allow cancel or unmount to disturb the finishing procedure */
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
 
@@ -911,6 +915,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
 	if (ret) {
 		btrfs_dev_replace_set_suspended(fs_info);
+		*suspended = true;
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return ret;
 	}
@@ -925,6 +930,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {
 			btrfs_dev_replace_set_suspended(fs_info);
+			*suspended = true;
 			mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 			return PTR_ERR(trans);
 		}
@@ -1167,11 +1173,11 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {
-			mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
-			return PTR_ERR(trans);
+			result = PTR_ERR(trans);
+		} else {
+			ret = btrfs_commit_transaction(trans);
+			WARN_ON(ret);
 		}
-		ret = btrfs_commit_transaction(trans);
-		WARN_ON(ret);
 
 		btrfs_info(fs_info,
 		"suspended dev_replace from %s (devid %llu) to %s canceled",
@@ -1183,6 +1189,9 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		if (tgt_device)
 			btrfs_destroy_dev_replace_tgtdev(tgt_device);
 		btrfs_rm_dev_replace_unblocked(fs_info);
+
+		/* Release the exclusive op if this replace still holds it. */
+		btrfs_exclop_finish_if(fs_info, BTRFS_EXCLOP_DEV_REPLACE);
 		break;
 	default:
 		up_write(&dev_replace->rwsem);
@@ -1276,6 +1285,7 @@ static int btrfs_dev_replace_kthread(void *data)
 	struct btrfs_fs_info *fs_info = data;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	u64 progress;
+	bool suspended = false;
 	int ret;
 
 	progress = btrfs_dev_replace_progress(fs_info);
@@ -1291,10 +1301,12 @@ static int btrfs_dev_replace_kthread(void *data)
 			      dev_replace->committed_cursor_left,
 			      btrfs_device_get_total_bytes(dev_replace->srcdev),
 			      &dev_replace->scrub_progress, false, true);
-	ret = btrfs_dev_replace_finishing(fs_info, ret);
+	ret = btrfs_dev_replace_finishing(fs_info, ret, &suspended);
 	WARN_ON(ret && ret != -ECANCELED);
 
-	btrfs_exclop_finish(fs_info);
+	/* A suspended replace keeps the exclusive op; see the finishing path. */
+	if (!suspended)
+		btrfs_exclop_finish_if(fs_info, BTRFS_EXCLOP_DEV_REPLACE);
 	return 0;
 }
 
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index b35cecf388f2..7fe6b57d4465 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -19,7 +19,8 @@ struct btrfs_device;
 int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info);
 int btrfs_run_dev_replace(struct btrfs_trans_handle *trans);
 int btrfs_dev_replace_by_ioctl(struct btrfs_fs_info *fs_info,
-			    struct btrfs_ioctl_dev_replace_args *args);
+			    struct btrfs_ioctl_dev_replace_args *args,
+			    bool *suspended);
 void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 			      struct btrfs_ioctl_dev_replace_args *args);
 int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/fs.c b/fs/btrfs/fs.c
index 14d83565cdee..173875e341f2 100644
--- a/fs/btrfs/fs.c
+++ b/fs/btrfs/fs.c
@@ -229,6 +229,23 @@ void btrfs_exclop_finish(struct btrfs_fs_info *fs_info)
 	sysfs_notify(&fs_info->fs_devices->fsid_kobj, NULL, "exclusive_operation");
 }
 
+/* Like btrfs_exclop_finish(), but only if @type is the one currently held. */
+void btrfs_exclop_finish_if(struct btrfs_fs_info *fs_info,
+			    enum btrfs_exclusive_operation type)
+{
+	bool notify = false;
+
+	spin_lock(&fs_info->super_lock);
+	if (fs_info->exclusive_operation == type) {
+		WRITE_ONCE(fs_info->exclusive_operation, BTRFS_EXCLOP_NONE);
+		notify = true;
+	}
+	spin_unlock(&fs_info->super_lock);
+	if (notify)
+		sysfs_notify(&fs_info->fs_devices->fsid_kobj, NULL,
+			     "exclusive_operation");
+}
+
 void btrfs_exclop_balance(struct btrfs_fs_info *fs_info,
 			  enum btrfs_exclusive_operation op)
 {
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 5f0cfb0b5466..473b47df1989 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1091,6 +1091,8 @@ bool btrfs_exclop_start_try_lock(struct btrfs_fs_info *fs_info,
 				 enum btrfs_exclusive_operation type);
 void btrfs_exclop_start_unlock(struct btrfs_fs_info *fs_info);
 void btrfs_exclop_finish(struct btrfs_fs_info *fs_info);
+void btrfs_exclop_finish_if(struct btrfs_fs_info *fs_info,
+			    enum btrfs_exclusive_operation type);
 void btrfs_exclop_balance(struct btrfs_fs_info *fs_info,
 			  enum btrfs_exclusive_operation op);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d47d16394fc..562d4df32dd8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3176,8 +3176,13 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
 		if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_DEV_REPLACE)) {
 			ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 		} else {
-			ret = btrfs_dev_replace_by_ioctl(fs_info, p);
-			btrfs_exclop_finish(fs_info);
+			bool suspended = false;
+
+			ret = btrfs_dev_replace_by_ioctl(fs_info, p, &suspended);
+			/* A suspended replace keeps the exclusive op held. */
+			if (!suspended)
+				btrfs_exclop_finish_if(fs_info,
+						       BTRFS_EXCLOP_DEV_REPLACE);
 		}
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_CMD_STATUS:

-- 
2.47.3

