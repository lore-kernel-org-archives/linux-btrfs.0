Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110892C11E6
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 22:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425578; cv=none; b=BUyA0EgCL7796A4HQ3Gh41UzNhVU293hLXvQh51cvjJN1TrVzWlnOib5fwnddUqU+s9GoBSUdhdc5LqoAmOJez2HVkcDLQnxiyyefmR1ExO+19cJ5wCZHu5Whyz5hDD17HhPXjiogZPnSHdREdZEsXUqbuySsMe88/p7Q3iIUN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425578; c=relaxed/simple;
	bh=Vt1fuX/BbScQfvr2UtDs6tyr5aexENx6W2t7EG2vwxk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bncmNomhd2krTz2J++ZKqo1sUK/UfhWdQEJ2Culjd7DhAX3Uauj9VoN/m624d3QLtbwDidvPLI3qB3/G2bl+FYgjNX9uZwvXVFSLDNNKtVrJraaNDI8vhYHt6icj2C41Y/d7VzbivHop1/+nlcZorsPZiqDyiSvPIZ8aOJlDKvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=C8FiTpEP; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nFOqWxzC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="C8FiTpEP";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nFOqWxzC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DE3AE1FF6B
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 22:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789425571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gazOV7giYyMUrQsMZB/vhverpEGwKCtnRAHI/x2e7OI=;
	b=C8FiTpEPbMVB+H2Kpv5pJbKWzg/LpaThmWHy+rAYSSbzbK0BedxVSZwUhVwxkcMuYkD0lA
	kTCV2GuF1nJV3g3ke3dZmkj9B/RBLaCCD003mzGnTe6AqfHT9mVmWQEw7F/+If7a47cvI7
	dfeQW1AbWD7aK31ppA6Uz6bU5EqKIRA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789425566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gazOV7giYyMUrQsMZB/vhverpEGwKCtnRAHI/x2e7OI=;
	b=nFOqWxzCKKATejWHhldyut47v6Z16aq7nJqBnnUU/2a59CXMKxkClZFsAutj3CfnEBmu7D
	K55qd32wQvExJXSx8pGOWfs6DAWmAHhZUkGzsjo9YWXXD7h79rkeRwpCcuPGRe6DrAbxJX
	VuldwmuD07hp4EDIWbnbnKqngiUbeCw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C248613515
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 22:39:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GtklHJ13qGqsKQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 22:39:25 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: docs: add a dedicated multi-device support chapter
Date: Tue, 15 Sep 2026 08:09:07 +0930
Message-ID: <cb437e93978784246fab57cbbf04892b1d985a3d.1789425495.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

Btrfs, like all other multi-device storage solutions, requires proper
device scan and registration to handle multi-device arrays.

However btrfs has some extra requirements and quirks related to
multi-device support.

Record those extra into into a new "MULTI-DEVICE SUPPORT" chapter in man
5 btrfs. For now it includes:

- Requirement for device scan registration

- Requirement for initramfs if the rootfs has multiple devices

- Quirk related to device path shown in mount point

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-man5.rst | 44 ++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/Documentation/btrfs-man5.rst b/Documentation/btrfs-man5.rst
index ce4021ab84b5..11f6c9327b45 100644
--- a/Documentation/btrfs-man5.rst
+++ b/Documentation/btrfs-man5.rst
@@ -34,6 +34,50 @@ MOUNT OPTIONS
 
 .. _man-btrfs5-filesystem-features:
 
+MULTI-DEVICE SUPPORT
+--------------------
+
+Btrfs has built-in multi-device support, and supports several profiles that require
+multiple devices, including RAID0, RAID1, RAID1C3, RAID1C4, RAID10, RAID5 and RAID6.
+
+However the multi-device support has some extra requirements/quirks:
+
+- Requires proper device scanning and registration
+  Like all multi-device storage solutions, btrfs has to scan and register all involved
+  devices to mount the filesystem.
+
+  Normally it's done by udev, but for systems without udev, the end users are responsible
+  for proper block file creation and scanning.
+
+- Initramfs required if the rootfs has multiple devices
+  Without an initramfs, the kernel boot sequence doesn't create "/dev/" with every
+  block file, thus it's impossible to register all devices to fulfill the mount, even
+  with the *device=* mount option.
+
+  It's strongly recommended to use an initramfs if btrfs is the rootfs. It's very
+  easy and fast to add a new device to an existing btrfs, without an initramfs the next
+  mount will fail to mount the rootfs.
+
+- Device path shown in the mount output
+  Btrfs maintains an internal device path for each device. The device path is recorded
+  during the initial device scan, and normally doesn't change during the lifespan of that
+  device.
+
+  This can lead to inconvenience if the user space tool doesn't do proper parsing.
+
+  For example, creat a block file at "/tmp/block_file", forget all devices, scan and
+  mount that newly created block file, and then delete "/tmp/block_file".
+
+  This will make btrfs register the device path using "/tmp/block_file", even if that
+  file is later deleted.
+
+  Tools like *lsblk* can still handle such cases by using device numbers, but a lot of
+  other tools won't parse the mount point properly, as the device path no longer exists.
+
+  Normally this should not be a big deal, as udev is the first program to create those
+  block files and scan them.
+
+
 FILESYSTEM FEATURES
 -------------------
 
-- 
2.55.0

