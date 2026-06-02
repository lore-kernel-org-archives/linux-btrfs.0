Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A07B38D3FB
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 04:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780373113; cv=none; b=BTOcT2a2Iu7K0NK7gClwgTObsg6U/oIKwV7vbLNdwycX3eCFbPhKug2wssFhu3F24yLAEnVXY56tu9JebBJTRRDRV7ks7xtGzjyBNjpZB8tyresCGbKZiIkrGm1pVY2n7XHh9qaXieIYACyDMfNUCP1ZB5iSGdKfA25O8+NjCR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780373113; c=relaxed/simple;
	bh=S1jpinAVQUrO41zNsuv5T3sh9Sks4ksg0J2htDzh/iA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ofts8adQhYdW4b3gnWJCb0iOr+tznx3fm6KwOxfZFkRR9AL8c0qqW/p/3vEVxCGl++fAdRSpt8UyT+tZaso26+nLW5L4eupxJZFgIc12MkT5m812vrqHCzlteye5ssImiRgAtHycQxnT4qYecEVbNUJsPWoOf9+8XbterlxDvIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IvFawDyT; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IvFawDyT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IvFawDyT";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IvFawDyT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A48AF688BA;
	Tue,  2 Jun 2026 04:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780373109; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=x+q3lxIRNr8hC/oZIP22Gmc96sl5oqq+J5lMxHp2hP0=;
	b=IvFawDyTdGb1OjLWBrEoxNlD09oCa6FGWpihXsgrRqIKD7aDlNtgpzgWbo1DxzC4NHEigM
	GpPiG6za7KAsdv0cQDkLuDh1eFvatf5KDE0rraXGEQEsAjnV0YBSs3UliUqaiEyvkjuw7t
	x/zlwqT9eNZB5fHgXd7cEMPRD0k5Z8E=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=IvFawDyT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780373109; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=x+q3lxIRNr8hC/oZIP22Gmc96sl5oqq+J5lMxHp2hP0=;
	b=IvFawDyTdGb1OjLWBrEoxNlD09oCa6FGWpihXsgrRqIKD7aDlNtgpzgWbo1DxzC4NHEigM
	GpPiG6za7KAsdv0cQDkLuDh1eFvatf5KDE0rraXGEQEsAjnV0YBSs3UliUqaiEyvkjuw7t
	x/zlwqT9eNZB5fHgXd7cEMPRD0k5Z8E=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C348779A7;
	Tue,  2 Jun 2026 04:05:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e50GDHRWHmpPEwAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 02 Jun 2026 04:05:08 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Su Yue <glass.su@suse.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: do not trim a device which is not writeable
Date: Tue,  2 Jun 2026 13:34:46 +0930
Message-ID: <0d25653c3bc93726e259dbb9d01559c4cfdf47ac.1780373081.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A48AF688BA
X-Spam-Score: -3.01

[BUG]
There is a bug report that btrfs/242 can randomly fail with the
following NULL pointer dereference:

 run fstests btrfs/242 at 2026-06-01 10:25:08
 BTRFS: device fsid d4d7f234-487c-4787-88e4-47a8b68c9874 devid 1 transid 9 /dev/sdc (8:32) scanned by mount (122609)
 BTRFS info (device sdc): first mount of filesystem d4d7f234-487c-4787-88e4-47a8b68c9874
 BTRFS info (device sdc): using crc32c checksum algorithm
 BTRFS warning (device sdc): devid 2 uuid fbe72d72-3272-482d-80fb-ab88ed398192 is missing
 BTRFS warning (device sdc): devid 2 uuid fbe72d72-3272-482d-80fb-ab88ed398192 is missing
 BTRFS info (device sdc): allowing degraded mounts
 BTRFS info (device sdc): turning on async discard
 BTRFS info (device sdc): enabling free space tree
 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000018
 user pgtable: 4k pages, 48-bit VAs, pgdp=000000013fd6b000
 CPU: 4 UID: 0 PID: 122625 Comm: fstrim Not tainted 7.0.10-2-default #1 PREEMPT(full) openSUSE Tumbleweed e9a5f6b24978fba3bf015a992f865837fdfff3dd
 Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20250812-19.fc42 08/12/2025
 pstate: 01400005 (nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
 pc : btrfs_trim_fs+0x34c/0xa00 [btrfs]
 lr : btrfs_trim_fs+0x1f0/0xa00 [btrfs]
 Call trace:
  btrfs_trim_fs+0x34c/0xa00 [btrfs f02c1d570ceea621c69d302ba75dd61868083840] (P)
  btrfs_ioctl_fitrim+0xe8/0x178 [btrfs f02c1d570ceea621c69d302ba75dd61868083840]
  btrfs_ioctl+0xdd4/0x2bd8 [btrfs f02c1d570ceea621c69d302ba75dd61868083840]
  __arm64_sys_ioctl+0xac/0x108
  invoke_syscall.constprop.0+0x5c/0xd0
  el0_svc_common.constprop.0+0x40/0xf0
  do_el0_svc+0x24/0x40
  el0_svc+0x40/0x1d0
  el0t_64_sync_handler+0xa0/0xe8
  el0t_64_sync+0x1b0/0x1b8
 Code: 17ffff83 f94017e0 f9002be0 f9402ea0 (f9400c00)
 ---[ end trace 0000000000000000  ]---

Also the reporter is very kind to test the following ASSERT() added to
btrfs_trim_free_extents_throttle():

	ASSERT(device->bdev,
	       "devid=%llu path=%s dev_state=0x%lx\n",
	       device->devid, btrfs_dev_name(device), device->dev_state);

And it shows the following output:

 assertion failed: device->bdev, in extent-tree.c:6630 (devid=2 path=/dev/sdd dev_state=0x82)

Which means the device->bdev is NULL, and the dev_state is
BTRFS_DEV_STATE_IN_FS_METADATA | BTRFS_DEV_STATE_ITEM_FOUND, without
BTRFS_DEV_STATE_WRITEABLE flag set.

[CAUSE]
The pc points to the following call chain:

 btrfs_trim_fs()
 |- btrfs_trim_free_extents()
    |- btrfs_trim_free_extents_throttle()
       |- bdev_max_discard_sectors(device->bdev)

So the NULL pointer dereference is caused by device->bdev being NULL.

This looks impossible by a quick glance, as just before calling
btrfs_trim_free_extents_throttle(), we have skipped any device that has
BTRFS_DEV_STATE_MISSING flag set.

However in this particular case, there is a window where the missing
device is later re-scanned, causing btrfs to remove the
BTRFS_DEV_STATE_MISSING flag:

 btrfs_control_ioctl()
 |- btrfs_scan_one_device()
    |- device_list_add()
       |- rcu_assign_pointer(device->name, name);
       |  This updates the missing device's path to the new good path.
       |
       |- clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)
          This removes the BTRFS_DEV_STATE_MISSING flag.

This allows the missing device to re-appear and clear the
BTRFS_DEV_STATE_MISSING flag.
However the device still does not have the BTRFS_DEV_STATE_WRITEABLE
flag set, nor is its bdev pointer updated.

The bdev pointer remains NULL, triggering the crash later.

[FIX]
This is a big de-synchronization between BTRFS_DEV_STATE_MISSING and
device->bdev pointer, and shows a gap in btrfs's re-appearing-device
handling.

The proper handling of re-appearing device will need quite some extra
work, which is out of the context of this small fix.

Thankfully the regular bbio submission path has already handled it well
by checking if the device->bdev is NULL before submitting.

So here we just fix the crash by checking if the device is writeable and
has a bdev pointer before calling bdev_max_discard_sectors().

Reported-by: Su Yue <glass.su@suse.com>
Link: https://lore.kernel.org/linux-btrfs/wlwir19t.fsf@damenly.org/
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6030cdbdb742..f3c3eb508f86 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6624,12 +6624,17 @@ static int btrfs_trim_free_extents_throttle(struct btrfs_device *device,
 
 	*trimmed = 0;
 
-	/* Discard not supported = nothing to do. */
-	if (!bdev_max_discard_sectors(device->bdev))
+	/*
+	 * The caller only filters out MISSING devices, but a device that was
+	 * missing at mount and later rescanned has MISSING cleared while
+	 * bdev is still NULL and WRITEABLE is still unset. Skip those here.
+	 */
+	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) ||
+	    !device->bdev)
 		return 0;
 
-	/* Not writable = nothing to do. */
-	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
+	/* Discard not supported = nothing to do. */
+	if (!bdev_max_discard_sectors(device->bdev))
 		return 0;
 
 	/* No free space = nothing to do. */
-- 
2.54.0

