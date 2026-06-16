Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5675F3DB304;
	Tue, 16 Jun 2026 11:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781610114; cv=none; b=SIKokFgpKicCFzBLH7KQTVcXKs1PtxFuK/IltiZ0ekr6+fWUpaKKX+55CXlbFjSVPNuEAGNcnP28iOQqyPDAQSLcfj3g/OM0tloWM0vQaVu909pnYq/jmwkuhxD5OQE14NyN3/nRYAHqXoNjDIarJ7HSDmCXHLnCUKVrDzxMNbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781610114; c=relaxed/simple;
	bh=1KKCoCE2EgXQf7cXviwJgYVNdqj8FqW+oyQF+kRv77w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DeP8VYVBhJmOb1he8WbFNUC4h+65o4YtWMYoygNE1L10tU7mBh9uENV2Fx+5XuuveLot0LbOKpsu6PwpDpImJJjnDsZs/y478AlFInNWAUDG52U37nwYjVj39QSGlSgx0bu9lgiwZxVBTChYXQ0KtDbTwTDnaD6ZzA+y0sR+mqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+yu2QXC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+yu2QXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8028C1F000E9;
	Tue, 16 Jun 2026 11:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781610113;
	bh=I/mYV4YmcLAH02nnAf7KSjFnk4Qwm9BkGka5tJ10L8A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=X+yu2QXCEB5jUVoNHghBScAWVh3KO23nVguEbQaRpq4Ig+pVMCEkPPQXWwRCSqrNx
	 TDzGsYLaNqNmg5exBv50iOAh9J3B63+9I0EPdkxw7DuuEIBdEm4yilmU9c+xzNF2Uj
	 xgBxF0CCtTxS7fGe4VmqbqjGCQ1shsi8I5dHVPqJkfojlxH62b4a9UfJKp2ZRgUQ5d
	 k5Mk0l9K6OE3MJLAurIY5Qe+D7RkCDkCw0H4D31xXj0D6yUijJIL69ah6VdHvc1ZhI
	 +Mq/l6ZVgIueBj3tHNVfSug+8DwUVliohFVIjEM3bS2JxHfcM2V16BarEHRq3+7+Nu
	 dZ8/EsXxgckZQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 13:41:14 +0200
Subject: [PATCH 5/7] btrfs: don't leave dev-replace STARTED after an early
 finishing failure
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-btrfs-preexisting-fixes-v1-5-c4abe2f6d4f0@kernel.org>
References: <20260616-work-btrfs-preexisting-fixes-v1-0-c4abe2f6d4f0@kernel.org>
In-Reply-To: <20260616-work-btrfs-preexisting-fixes-v1-0-c4abe2f6d4f0@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naota@elisp.net>, 
 linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>, 
 Stefan Behrens <sbehrens@giantdisaster.de>, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3803; i=brauner@kernel.org;
 h=from:subject:message-id; bh=1KKCoCE2EgXQf7cXviwJgYVNdqj8FqW+oyQF+kRv77w=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZmmXzNP9/Gc+8Suvldaua4uibuWuPLdrs2znLckv0K
 t5WvV0+HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABdxYfhnzHG688TvXiaf5gBH
 mXN/psfZ3lb2eR8Uq/DllnJm+FtbRoZNHmJefbGzNue+KUjMWMlqM/edrk1NonWEbkdhvmaKLjs A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

btrfs_dev_replace_finishing() can return early, before the source and
target devices are swapped, if btrfs_start_delalloc_roots() or
btrfs_start_transaction() fails (e.g. with -ENOMEM):

	ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
	if (ret) {
		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
		return ret;
	}
	...
	trans = btrfs_start_transaction(root, 0);
	if (IS_ERR(trans)) {
		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
		return PTR_ERR(trans);
	}

These legs leave dev_replace->replace_state as STARTED.  The scrub that
drives the replace has already exited (btrfs_scrub_dev() has returned),
and the caller releases the exclusive operation unconditionally: both
btrfs_dev_replace_kthread() and the BTRFS_IOCTL_DEV_REPLACE_CMD_START
ioctl call btrfs_exclop_finish() regardless of the return value.

The result is a replace stuck in STARTED with no running scrub, which
cannot be canceled.  btrfs_dev_replace_cancel() takes its STARTED case
and calls btrfs_scrub_cancel(), which returns -ENOTCONN because no scrub
is running; cancel then reports
BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED and tears nothing down.  The
replace stays STARTED -- writes keep being duplicated to the target --
until the filesystem is unmounted; only then does
btrfs_dev_replace_suspend_for_unmount() move it to SUSPENDED so the next
mount can resume it.

Demote the replace from STARTED to SUSPENDED on these early-return legs.
SUSPENDED is exactly the state the rest of the code expects for "no
scrub running, resumable": btrfs_dev_replace_cancel()'s SUSPENDED case
cleanly tears the target down, and a resume on the next mount restarts
the copy.

This does not change that the exclusive operation is released while the
replace is only suspended; tightening the exclop lifetime so a balance
cannot start against an in-mount suspended replace is a separate change.

Fixes: e93c89c1aaaa ("Btrfs: add new sources for device replace code")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/dev-replace.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e5090fb7fc11..13badbdee06b 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -861,6 +861,21 @@ static void btrfs_dev_replace_update_device_in_mapping_tree(
 	write_unlock(&fs_info->mapping_tree_lock);
 }
 
+/* Demote a STARTED replace to SUSPENDED on an early finishing failure. */
+static void btrfs_dev_replace_set_suspended(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
+
+	down_write(&dev_replace->rwsem);
+	if (dev_replace->replace_state == BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED) {
+		dev_replace->replace_state =
+			BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
+		dev_replace->time_stopped = ktime_get_real_seconds();
+		dev_replace->item_needs_writeback = 1;
+	}
+	up_write(&dev_replace->rwsem);
+}
+
 static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 				       int scrub_ret)
 {
@@ -895,6 +910,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 */
 	ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
 	if (ret) {
+		btrfs_dev_replace_set_suspended(fs_info);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return ret;
 	}
@@ -908,6 +924,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	while (1) {
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {
+			btrfs_dev_replace_set_suspended(fs_info);
 			mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 			return PTR_ERR(trans);
 		}

-- 
2.47.3

