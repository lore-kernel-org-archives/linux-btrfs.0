Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1FE38B7A6
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 22:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425661; cv=none; b=i9FzpFgWzbU4vAZUKSsla6vRYj4WW4Za2YsNKjXX6Fv8tymFj8kenY+XW8yQNSM7EBCZrlqCtvWSvT07QmEemivwt/d2fyV9XhapPj8O9sa+U3PwCrr9YoIfzuXiK2r2NyNyuU0zlZ+xKqsqDJSIbXXb0vJY2lu90wvteDm2VEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425661; c=relaxed/simple;
	bh=xUP5gY1dquCu53AEVEcOX0ayP1E/NwgtMR1NS3H4duo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=iMO/76Xc8ZLYS69Bl/Vwq9gZJJbYSInJJ/rNprCOOVpaJpTXYwwyqxaOL4Ed6JSaypNxwgbjCJeovxRvexAB7WNad+r7LOyBybK7AEdxRCS/3GyFOOUsf/sPGHpIGAH+Gq7ANawqXBo3vM06JERH+B98J8xKt2li1xrD8sAf4xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eSkD3VuI; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=cf/MQIeS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eSkD3VuI";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="cf/MQIeS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6A0AF1FF75
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 22:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789425653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0zTFIU5F9V2z7ofb/lPWjQWG3cDNYDXcXadZrACaaJM=;
	b=eSkD3VuIQXJ2+yCykk3K8d47n5zz1TwrW/SLxp6sl5cNERWuXIcm7x290z8izOnsFdK/4g
	P8Ot3l49LrXADiqsh6mPvOf9IQqqwSfMw9CPKhifxyT73r+gXYlq+AFh90CnkywrnVXp5i
	QDIxpgGq0qtOX8CR3KVV2TgribVAGCI=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789425649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0zTFIU5F9V2z7ofb/lPWjQWG3cDNYDXcXadZrACaaJM=;
	b=cf/MQIeSG6PjuRDTw89fv7qiud+wVSnfCXexEewcDO14oPxxkR+P0iLdaGaktC91Xu2eMY
	zTUTAueSbqeO6StD9ncVv8zDozEptS2Cr08XvhB5Q7A2kavOYCROhGt5pV0hqw9CZMkjrK
	s0yniS+pR02y3Jj4+jofn864XRh6+Gg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F43B13515
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 22:40:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GewbAPB3qGquKwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 22:40:48 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: docs: add a dedicated multi-device support chapter
Date: Tue, 15 Sep 2026 08:10:29 +0930
Message-ID: <2a9e68aecdccd4c9641ad1f1b56ca594b7987115.1789425622.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
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
Changelog:
v2:
- Fix the prefix of the subject
  It's btrfs-progs, not btrfs.
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

