Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC11D48595F
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 08:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721180; cv=none; b=WM+0mkn6Pgykq19PPplOgfwM0B8Q5QGBehrjr6g5RnEmXxUynT3kezkWi4yGVYzOYCkabojG27lrVU22b0dTKjIA1UolCphIVvaI8svurHuOk0AUz08uQIeKQU21Ec9j3OcQSHTTRIKF4UHNYsy8BqGbJe/SmN5ZGJ7W/uxADSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721180; c=relaxed/simple;
	bh=SnilOYhHPWLorvYiSKn18mmkmOJS7rbS2CLd8duTDyk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qCUarARM2BdkKEBFM2sNUoaI5ch2/J0K+FrloXtILSBTyPT6cYfnBxsrKP/jci6mcHB52oAnmCLVBk28rQnTCTUrLDJH/8fa19yly3DhVeixQb/X9DzfwpuXGWaFjNWb3MRHT1+vCePrgVwCG/WgWBFZ5pp/Czkuw0fTH8J4ALo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mN3FPhM2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mN3FPhM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B201F0089A;
	Fri, 18 Sep 2026 08:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789721178;
	bh=MbESS7J92GOVmxFo8OSOvdF59v7n2rIrOBipNWC3NYo=;
	h=From:To:Subject:Date;
	b=mN3FPhM2uVSIlIqm6dUTzrANn/6CUXZK210HO00IAdE9PrRZ59Zzy+e0Xh4Udw9dY
	 sTxjhX83P+5rnrSclOtVtndl8Q0dhPeZiUl2qxaLJTsHq1FZs8rVOUSeGcs1qqNA9L
	 uA4rT/VYXpOUPUv/QRhlej98c//PcFfLgYYssvOeJMR7GawKfKpQDLe86/CiK7hx4G
	 Pz7asbBdBGZjpTiB4toqYTOuK+DfaEAEox8h3vzezG4BTDZJupGbk89/338plvN/t/
	 U79ZUNhCv423dEivvKAFsPMoWTfDf0Erfa1u1HzoVXU39M/uU0qADIKtTfduo3F/lv
	 wnRY0lKimAb8A==
From: Anand Jain <asj@kernel.org>
To: linux-btrfs@vger.kernel.org,
	dsterba@suse.cz
Subject: [PATCH] btrfs-progs: docs: document the temp_fsid feature in btrfs(5)
Date: Fri, 18 Sep 2026 16:46:12 +0800
Message-ID: <b49b0307f3622febb1ae5c87db10b5de032ec967.1789720953.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20260918084612.ZxGVtNO9DAJfevT0EwV5BlMy-4qgIyRKK6TAZ5oNLtU@z>

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

