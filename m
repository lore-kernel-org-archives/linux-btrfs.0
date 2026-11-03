Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793737799;
	b=RLwhPv8o7w/KH7EwWF7zjBhUr/+mWPNSyi55dR8dOg7SoIrMkHhhxYlIxV2gg2ky8Tsl
	 Qpc+w2PiU5GMhmcfl0KeQfuD9mA1H2sDZlMUXYhJKseC3E2x7Oz0Rm+CBQnnliiZg2/fr
	 DQOKh8/pQH/30N5OAOYi95Tq8cKi5JTDPcQBmrBynMvmO/dJtJTotM1XVTvN7O+H0NIzj
	 LsKL3SMr/H/Xlt1h9+u/CSMm4XxCsvMhyCQqs1qJjLNSZVvCiTMuEWDsSREz5eikXonaY
	 0L+mpZkFKJEuG6bF7Em9900RNZqMgMd3ykRStxTEvAwH0Uf5whqzktOXI2fc81YfjtA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793737799;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=KzAzJwf4FOBHlJwjUBwevYc6S6EZCFURslleh0SnJ+E=;
	b=hBtCEACBKQ9+8QN2seKz90nt/cUICSCMPKVouTrXF6atahvvvsjBjuMYBqzongtfnh0N
	 cQ+n2uxwQFJCbNrj9v9MMoudExll86xhIKXtGgGG3v+w0nUvjIPsyCr1Jj7NJCAyyMC9g
	 jWGsjEirdu54E7ytNp10TWTUry5npU0z8giCtfrHKb9QUsfavG0Bit7Ba+4wxzZhN1ovt
	 2gxKRn5Heyq1oHlGbKaLyEe6ErBmvdGbG3BpAtNZfHlyVKqKFx+ZHM6GE+1AhNSwmi+A0
	 INwz3ACSaPvubd+QswT9CT4tonATqgYqG4go6uhNs1uv+Ed7gua4Z1uwrGjCTpddEtA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IFlsyWJM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546B4606A31B;
	Tue,  3 Nov 2026 20:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IFlsyWJM
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793737798;
	b=CpIe3XHt4EV8zfF+uGSxXIDW1nEF94IDagL6MGvFdHqOaaqEVMRcfVdbTpI+icqQFQaG
	 +KdRIZcZeefBHNmKrwA1/drb1ii87kEs5otUMhAAK5c66XaL8USIyQFHJqskNRB30rwea
	 WwhVAacjDrvRpebVlTNM6FsrJTLRdp39UWfAI+QknV1RVvT2917PpIO0sU6NMDj/n7rRv
	 lHBrzUFpoiTqi6FdsWWQeBX6rCFnndJRKtBkswbMYbVdYVX1d/JL5dBJv2z1t+zujVpDx
	 y/ziyA9OWwt5Od8Aw93Um0c3CbNwBjGGA360oB8vb9fhOBLTlf4z3FXOTKIrzynGglQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793737798;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=KzAzJwf4FOBHlJwjUBwevYc6S6EZCFURslleh0SnJ+E=;
	b=dqirJe2hTYE3cv2GZ7ad4jjw3F6BoK4ePfr0bieH6Bh4raaX/4FwW4jdai5MNW4qxRnN
	 PhWhcpJLfTpQ5zkbMHM7CqZGDuHJC28mH/U4YP5yedletrvfNFXe9tsMoScrUWLnrpkJd
	 PPvZUMAOJdNz3dK67jXeWHCA0MUW7bdE+dS732b9DA3v4EYaiHW0DiTSoEryPUUbAKeeN
	 fkClWObsXYoIqUCyUdOptHmdm+CigHrWW1MPCX8BB1upNfzR5Bg6Q3Ufasijn7R5xw2gO
	 DJj69nGva732VXWy4VpBVvIwxutjPZGQbTopZ+gURvPzWhCEG3asDwPytBT4rvoGpyg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5D67F1F000C1;
	Tue,  3 Nov 2026 20:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793737798;
	bh=KzAzJwf4FOBHlJwjUBwevYc6S6EZCFURslleh0SnJ+E=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=IFlsyWJMyUFbzxLJ5neXheCx1IFNvnS+gGAi8/Ny6htCngUnPr3Ry/6AC+pxPpiYR
	 lqA0wEJBLulog7hZRVknbQpFlNKMx+6QBQ3awbqUqXamu5kpUGGX7ZzfQcUBADaoFq
	 Ew33/M4wEK/XSRmVm4jano9D07p1iOFHHFYDDleBBgOBnHbnGFHLLA8EqoEcQsAze5
	 F9PhBR5g/07quePaTpR6+jsf/v/sIrBeu72jGZsSqKKBCdXeBf6ulYCLagIV6cbVft
	 1pLk3Isv9cndac1I8pDT6tf86YeHXPQrqEoPEq1/5CQCkULnxqZ95S7/OVXd+APV3R
	 Nj5zcGSPZ5Qzw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E1EBD46B01;
	Tue,  3 Nov 2026 20:29:57 +0000 (UTC)
From: Peter Lamberg via B4 Relay <devnull+kernel.pelam.fi@kernel.org>
Date: Tue, 03 Nov 2026 22:29:43 +0200
Subject: [PATCH] btrfs: keep drop_progress when resuming snapshot deletion
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261103-drop-progress-v1-1-16e345565109@pelam.fi>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ5AMBBA0avIrDVpSxBXEQtlMBbazCAScXfF8
 i3+v0CQCQXq5ALGg4T8GmHSBPq5WydUNESD1bYwRmdqYB9UYD8xiqhurFxpcquz0kFsAuNI5/d
 r2t+yuwX77Z3AfT8ePSggcQAAAA==
X-Change-ID: 20261103-drop-progress-af8b7142037b
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, josef@toxicpanda.com, dsterba@suse.com, 
 fdmanana@suse.com, mason@kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793737797; l=3991;
 i=kernel@pelam.fi; s=20261103; h=from:subject:message-id;
 bh=+0hMPVJNrK3nqWmVIXPLZTc0fOhJ6F352/cjiqMYRHc=;
 b=vFBm9fFlMCurRCtUXizufaul/ytO7E0YikFCAQNrIGucv93R4TOKbJryHovwmYukTt2LeuomY
 Y9MaFlBnphwBEsdsV3o1mTkHerUmzCTlrppVB+Xtq3BlYl0moU0CLHr
X-Developer-Key: i=kernel@pelam.fi; a=ed25519;
 pk=qpD/xh/xwDGEMdfQk/5prChHF0mXHXDTrs35FxiJgrk=
X-Endpoint-Received: by B4 Relay for kernel@pelam.fi/20261103 with
 auth_id=1398
X-Original-From: Peter Lamberg <kernel@pelam.fi>
Reply-To: kernel@pelam.fi
Content-Transfer-Encoding: 7bit

From: Peter Lamberg <kernel@pelam.fi>

When btrfs_drop_snapshot() resumes a partially dropped subvolume, it
copies the saved resume key from the root item into wc->update_progress
only. wc is kzalloc'ed, so wc->drop_progress and wc->drop_level stay
zero. The main loop writes both back into the root item on every
iteration, and wc->drop_progress is only updated once this run drops a
reference itself (DROP_REFERENCE stage).

If the child at the resume slot is shared and the walk is still in
UPDATE_BACKREF when a checkpoint happens (an unmount or commit before
the first drop), the root item gets drop_progress (0 0 0) and
drop_level 0 while the root item still exists. The next mount then
restarts the drop from the left edge of the tree. Children that the
earlier run already finished now have refs == 1, held by the surviving
snapshot only, so the restarted walk treats them as exclusively owned
and tries to free the dropped tree's reference again:

  unable to find ref byte nr ... parent 0 root N owner L offset 0
  BTRFS: error ... in __btrfs_free_extent: errno=-117 Filesystem corrupted

and the transaction aborts.

Before the commit below, the root item's drop_progress was left alone
while in UPDATE_BACKREF. Restore that behaviour by seeding
wc->drop_progress and wc->drop_level from the root item on resume, so a
checkpoint before the first drop rewrites the same resume point instead
of zeroing it.

Fixes: aea6f028d01d ("btrfs: save drop_progress if we drop refs at all")
Cc: stable@vger.kernel.org # 5.1+
Assisted-by: LLM
Signed-off-by: Peter Lamberg <kernel@pelam.fi>
---
Test notes (not for the commit log):

Reproducer: subvolume S1 with a level-3 tree, read-only snapshot S2,
delete S1, unmount after the first root child is dropped, mount and
unmount right away, then let the drop finish. fstests test sent
separately (btrfs/355).

Reproducers and logs: https://pelam.fi/btrfs-drop-progress/

Tested on Ubuntu 26.10, kernel 7.3.0-9-generic (v7.3-rc6 based), with
btrfs.ko rebuilt from the matching Ubuntu source, 3 runs per module of
the same sequence on a loop image with dm-delay plus btrfs check
--readonly:

  module              drop key zeroed  abort  btrfs check  snapshot S2
  stock               3/3              3/3    errors 3/3   EIO 3/3
  built, unpatched    3/3              3/3    errors 3/3   EIO 3/3
  built, patched      0/3              0/3    clean 3/3    intact 3/3

Unpatched and patched were built from the same tree with the same
toolchain. With the patch the drop key kept the resume point over 20
mount/unmount cycles and the following mount finished the drop.

fstests -g quick (btrfs): 765 of 766 pass with and without the patch;
generic/574 (fs-verity, 1K block size) fails in both runs, unrelated
to this change.

btrfs/355 (no dm-delay, checks the drop key after each resume): fails
3/3 on stock and 3/3 unpatched, passes 3/3 with the patch, ~15 s per
run; same result with the devices on tmpfs.

The patch applies to v7.0.14 through v7.4-rc1; v7.4-rc1 still has the
unpatched resume code. Upstream tags were built (v7.3.1, W=1 clean on
extent-tree.o) but not run.
---

---
 fs/btrfs/extent-tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b0a5c6b96f3..41a8b25c6e0f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6333,9 +6333,12 @@ int btrfs_drop_snapshot(struct btrfs_root *root, bool update_ref, bool for_reloc
 		btrfs_disk_key_to_cpu(&key, &root_item->drop_progress);
 		memcpy(&wc->update_progress, &key,
 		       sizeof(wc->update_progress));
+		/* keep the resume point until this run drops something itself */
+		memcpy(&wc->drop_progress, &key, sizeof(wc->drop_progress));
 
 		level = btrfs_root_drop_level(root_item);
 		BUG_ON(level == 0);
+		wc->drop_level = level;
 		path->lowest_level = level;
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		path->lowest_level = 0;




