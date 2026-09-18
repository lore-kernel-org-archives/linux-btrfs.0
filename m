Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1FC3E44ED
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 08:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721010; cv=none; b=PU2dfG+N95xGI/vVLCh4EDdvJl1bVee8wpuwmHyStCw+zBTGoi90DD2Z1o9OA9JikSplry4/8emItA3nVgmBM64eMZIFKsy4a0u5i08K9YWjDlr1FBmCSCvc9M/9usFvyKMSk0ue+GKzKkXjS4j80xRQt84hdCXbbXiTBtkSlQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721010; c=relaxed/simple;
	bh=B8enl7XajpNalonsPTNgKNafhkdgqqD/Md62FHaEKmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r44H/mqNmYPQDmv55ENgr2vR7j2ByaW+WxJwJzFFuguftMs9SsLP9jCmW0OVTkxhBHYc7n4FzAunz7jmA5VdLpxbI0kmmnpc0ojs37RTMhGHTDFPW3jY4GwmNdQnet2pQ/3TGgu3vI7EQ0OkBvj7vSc1XaSG1UF0fi2yU+Nly7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ScZxygwk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ScZxygwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B6A1F000FF;
	Fri, 18 Sep 2026 08:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789721006;
	bh=5j1ZVmoODEcnt056LhDW9rRHbMWXo37OrUcqNILKcwU=;
	h=From:To:Cc:Subject:Date;
	b=ScZxygwka8S4W21pTvCB0VD1eAZ77lzxKrkb//YhDSqv0vOEMQv3K6Rm3tT34v5XZ
	 WiilUdeWeUYgyLuiW8u5cMdgF4hQI8xBY2gFB2ujAjqc/tIiYOdyI13XLsQIgmCeP3
	 37JQpL43B/MbIl+BSHXLZ8T+8Q2dF58Ht2npyLfx0LWWjX9Gbi2vo2TVZkRssmFdbC
	 PamHb3RAOvezhUBqFN90PPyZHaKz0F40Opy3Cu9pnAqIJtQwxmx1lc4HtPdXtAqPFd
	 g7s7EDT/mL+vLzGs7jKkM2cxneILqj7/bhGPZu8TC0QLcADJCMj1ezVsTa8sWxHgVS
	 rogmOOuz4ZTVw==
From: Anand Jain <asj@kernel.org>
To: linux-btrfs@vger.kernel.org,
	dsterba@suse.cz
Cc: Your Name <you@example.com>
Subject: [PATCH] btrfs-progs: docs: document the temp_fsid feature in btrfs(5)
Date: Fri, 18 Sep 2026 16:42:43 +0800
Message-ID: <b49b0307f3622febb1ae5c87db10b5de032ec967.1789720953.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Your Name <you@example.com>

The temp_fsid feature (kernel 6.7) is missing from the FILESYSTEM
FEATURES list in btrfs(5). It's exposed in sysfs
(/sys/fs/btrfs/features/temp_fsid and /sys/fs/btrfs/<UUID>/temp_fsid)
like any other feature, but has no corresponding entry in the manual
page.

Add an entry describing what it does, when it applies (single-device
filesystems only) and its exclusivity with metadata_uuid, following
the existing entry format and alphabetical ordering.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 Documentation/btrfs-man5.rst | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/btrfs-man5.rst b/Documentation/btrfs-man5.rst
index ce4021ab84b5..2635f06a1394 100644
--- a/Documentation/btrfs-man5.rst
+++ b/Documentation/btrfs-man5.rst
@@ -199,6 +199,22 @@ supported_rescue_options
         list of values for the mount option *rescue* that are supported by the running
         kernel, see :doc:`btrfs-man5`
 
+temp_fsid
+	(since: 6.7)
+
+	indicates the filesystem is mounted using a randomly generated, in-memory only
+	substitute for the on-disk filesystem UUID, needed because another filesystem
+	exposing the same UUID (e.g. a block-level clone) is already mounted. The
+	on-disk UUID, as reported by :command:`blkid`, is unchanged; the statfs
+	filesystem ID *f_fsid* returned by :manref:`statfs(2)` for this mount reflects
+	the substitute, and is regenerated on every such mount.
+
+	Supported only for single-device filesystems, mutually exclusive with
+	*metadata_uuid*, and disables :command:`device add` for the mount. To make a
+	clone permanently independent instead of relying on temp_fsid on every mount,
+	change its on-disk UUID with :doc:`btrfstune` (*-u* or *-U*) while unmounted.
+	See also section :ref:`SYSFS INTERFACE<man-btrfs5-sysfs-interface>`.
+
 vefity
         (since: 5.15, CONFIG_FS_VERITY)
 
-- 
2.43.0

