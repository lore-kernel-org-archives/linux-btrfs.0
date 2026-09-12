Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C2B42C51C
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Sep 2026 08:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202563; cv=none; b=R3A/oQusvoIChVbXJBUkL221P5g4iZRouCjQCG3ifZPYaYnZ2h9OylhKu+spym0N7CbUGa0C4sZLT+KxuYR8tiQaXI+UqrkVpEt8kuj/arWz5RAF5yc1tHhW+2UFYQBaxyMi/Xr8v0N7ljQklhbwSlEqozRFB/DBGiuzaW3ozQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202563; c=relaxed/simple;
	bh=Q1+hAaCxmfWB56tOyH5QYjTVH2oswsq2YsU5RHsa6Tc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=KeU+hgOIrgN6sGuj6FGlpqfMCEs9BWZzMPEUUufSPtE0LLDurHPGAppkfcGWTNEJp1zmmECQ0fJiskEScx1V8nPUoJWcNrGSB1WZF/V3XHqWkZ0q2CDvqihcBZinv2rBYPc1lzpHUmTfhck1bE6qXbWePVwUct0XtQfDJ5mbjwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IUrJQOhA; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VkVdmoH0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IUrJQOhA";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VkVdmoH0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 058F01FF0F
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Sep 2026 08:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789202550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zcdbMMa5OhKSx22FbrIXK33RF3UnjrP65aRHAjMg4lI=;
	b=IUrJQOhA2Dej7xlEVxSOWSuu32PHvg62BbdXrw6PEyHWvbmCRHQeoR3A1yfZi4dB/wSyO/
	EgTXB8a1kxgfMcMlcj7AZIIqqzWTG99VoUFl6wRx6q6QPrWg4yN5uXam0/0bBODhtGm7eA
	H8oC0QlKgS+vWGYviaB6h6LpLeE/tDc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789202546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zcdbMMa5OhKSx22FbrIXK33RF3UnjrP65aRHAjMg4lI=;
	b=VkVdmoH0M1KOMKto2BzldlDgYZO9RES140AeI9cUvZqTpd/00LL9iTYO8DaMlJ17BdJin7
	YYA9sjuIo+mCrzBdxLJc5bQiC2IZoVKGUBPpqFKq2wAdhuvxJPXnAggrl8G31oRfdGiym7
	hVXh0LLzsMaC9RGZbxmzjPgAmBJ5rws=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD66013687
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Sep 2026 08:42:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fUXUInAQpWp0LQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Sep 2026 08:42:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add "/dev/root" exception for device path update
Date: Sat, 12 Sep 2026 18:12:06 +0930
Message-ID: <3e3164206d23ef991b9bd76dab6706238592cfb0.1789202516.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_NONE(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid]

[BEHAVIOR CHANGE]
Since commit 108cc8733989 ("btrfs: fix a lockdep caused by path
resolution during device scan"), users with btrfs rootfs but without an
initramfs are complaining that grub2 can no longer detect the rootfs
device:

 /usr/sbin/grub-probe: error: cannot find a device for / (is /dev mounted?).

[CAUSE]
Although using btrfs without an initramfs is not recommended (if a new
device is added to the rootfs, the system can no longer boot, as there
is no way to register all devices), there is still a minority of users
doing this.

If there is no initramfs but the rootfs is on a block-device-based
filesystem, the kernel boot sequence initializes a minimal ramfs/tmpfs,
creates "/dev/root" with the proper device number for the rootfs, and
then invokes mount using "/dev/root".

That's why the end user will get the mount output:

 /dev/root on / rw

To be honest, this is a user space problem: no one should trust the
device path shown in mount, only the device number.

E.g. one can even use "/proc/self/fd/*" to mount an fs, and that proc
path will be registered, and no one else can mount that fs using that
path.

Before commit 108cc8733989 ("btrfs: fix a lockdep caused by path
resolution during device scan"), btrfs had an internal path lookup
workaround to address such weird paths, it works by checking if the
existing device path can still resolve to the device number.

But that path resolution is deadlock prone, thus it's replaced by a
simple devt check.

This works fine in most cases, as a btrfs device is registered by udev at
boot time, thus all paths are sane.

However this will not work for systems without an initramfs, causing the
unreachable "/dev/root" path to exist forever without a way to rename
it.

[WORKAROUND]
Despite updating the docs to discourage root btrfs without an initramfs,
add an exception to the device path rename requirement.

If the device has the name "/dev/root", we know it's booted without
an initramfs, and only for that case we allow device path update.

And if someone intentionally created "/dev/root" after boot, the
existing devt checks will reject that weird name as usual.

This should satisfy the minority of users, and still keep most of the
existing guards preventing unexpected/unnecessary device path updates.

But still, I prefer grub2 to implement a more robust device
number based probing, and no one should use btrfs as rootfs without an
initramfs.

Fixes: 108cc8733989 ("btrfs: fix a lockdep caused by path resolution during device scan")
Link: https://lore.kernel.org/linux-btrfs/CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com/
Link: https://lore.kernel.org/linux-btrfs/dfbe1e27-dab8-4d55-8cf3-0b28eeac5df4@gmail.com/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4ddabadc9188..b61c68871c0b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -749,6 +749,36 @@ const u8 *btrfs_sb_fsid_ptr(const struct btrfs_super_block *sb)
 	return has_metadata_uuid ? sb->metadata_uuid : sb->fsid;
 }
 
+static bool should_rename_device(const struct btrfs_device *dev)
+{
+	bool ret;
+	const char *old_name;
+
+	rcu_read_lock();
+	old_name = rcu_dereference(dev->name);
+	/*
+	 * For systems booted without an initramfs, the rootfs has the device
+	 * name "/dev/root".
+	 *
+	 * Although using btrfs without an initramfs is not recommended (if a
+	 * new device is added to the rootfs, the system can no longer boot, as
+	 * there is no way to register all devices), there is still a minority
+	 * of users doing this.
+	 *
+	 * And after the system is up, a later device scan on the real block
+	 * device file will never get this device's name updated, as the
+	 * device->devt is still the same.
+	 *
+	 * Here we add one and only one exception for "/dev/root", to allow
+	 * the device name to be updated even if the new path points to the
+	 * same block device.
+	 */
+	ret = !strcmp(old_name, "/dev/root");
+	rcu_read_unlock();
+
+	return ret;
+}
+
 /*
  * Add new device to list of registered devices
  *
@@ -869,7 +899,8 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 				MAJOR(path_devt), MINOR(path_devt),
 				current->comm, task_pid_nr(current));
 
-	} else if (!device->name || device->devt != path_devt) {
+	} else if (!device->name || device->devt != path_devt ||
+		   should_rename_device(device)) {
 		const char *old_name;
 
 		/*
-- 
2.55.0

