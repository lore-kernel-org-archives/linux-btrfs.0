Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793514349;
	b=qlBq7v6w3qU/F3OYMpgW5H2Bw6YhwWcybj1c8h9W8UYFI5HWO7X85xgQOmkZiGEaY+g6
	 6FJV+wrX/hsTk77jSkZDSiv54VtwAQPNQTnY7CmDKbWaYpnMACXtmROQGSrcQS0KHJXNF
	 OABJXA3CpQ/24m84ZO34MmnkjS+2PVlPtxnnx8hCCvH4yTGkpdG21j5rIHkrs+2sdQnrj
	 rDvQylniWU7Wnd87KGxYGyX9DE3rfDtwdT/SrwHvIH9iCD+g1leoEz+cwHihVNXHAHYY1
	 XowzOsCwJwFBIsgVdMUvqDWBcWQ7BXAEcu9fWvQ57AWhVF1+FfmYv8buz4qVb8CzFXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793514349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1KBDUNc4iTIsRLtb0D3MF9g5k9EN16h0slF6SZ+zPLw=;
	b=GDY2zks09TNdE6XznOpgq2rX/ejYu5S/pRJnNMXIfjtWfHJ/tDADs25yNS4DJkbc+gQ2
	 OJInXVZYcA297ls47RVHLKFmSyVe5C1yO5Bumvbdxrq8m8C4Dlrb44MrN9xLTLKbbCf16
	 qk5ySKfwVmMhVIQ4Li//L50Ge+ure7yQlwJgUjTrMIaYAWo8lOF1PP9sJDH4Mv2lbZ09S
	 Tc8ggvl9J3jt6riuBxj0whk752i3LA4cPT5z9jCDSmEUaEGgk/7SVT7rf3jhuvun7q4Ny
	 Ne6htWTJvJUlBhV4pJB2JIAM2gu+ISKnhMaUVLUUBYNq6cS4Q8qk4rz/uX2P/HSJirw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=txOigOOP;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC98606A324
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 06:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EC98606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=txOigOOP
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-35829219da8so3604795eec.0
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2026 23:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793514347; x=1794119147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1KBDUNc4iTIsRLtb0D3MF9g5k9EN16h0slF6SZ+zPLw=;
        b=txOigOOP2IN2jI9I7SmGd4eeQSjSj+yGDKCIP6k3JrI1HFRdjP3ynocefzG+ushIp4
         jZoHviabawNBaUWWo+ruDtKzl1HziTMaM5TOl+jSZSRJrPM4BK4c45DBiPNg10pdPXyj
         Sc8+2u38oHi+07QT8zUMhuPAE9B9sU7fFIiJZ4QUxItftHFBQvVnxHoH250sOs0efk9D
         n361AKHO4d79hOscsMCf1AvhkPQKIMIdlikeel3EiL+YmJ7n1u+OmNTm5qMF4OxzM6JU
         owoWIskQNYTYDRkekHG1cZQ5q55GXF5H1OVRsNgyU9rItLZnVCs35pFmdWlUiC4y/OCF
         J1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793514347; x=1794119147;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1KBDUNc4iTIsRLtb0D3MF9g5k9EN16h0slF6SZ+zPLw=;
        b=vgvroehZi5U8LqvS6E6yRnyV8PDF4XCTJf+1ulGTYYI3sT+omyZEpeiC7+ZgmmaN01
         KZ+aBd54NA7UM6IfKA4+MCkBQ2YjdSNZcsR2czWDl46tRYVkg5au6njabNdSBu0mm844
         LhG943jkaUHmrMbhSGIToA/VY6e+KTz87ksQevU5MqZSf2fRQWEzZArsdRXjDUeVl/yo
         AEdODrB6MH814qSPry8pMUQgxkEOkGjNAXTp4MKZJFIQuJwAwScgTkQSiTkyk8zAR3bn
         tsIuEZtwmd72tpOtl5J/hA7RldVS+DwCU2kyz86w75CVC8kVLNHVSif/x6/Hr5yTdpPp
         QqxQ==
X-Forwarded-Encrypted: i=1; AKwUvByGSLllOVqVv9NKJ5QH1J7KFxOYkxqRTLsV+nBu+/EGRyTcJUi+/81/eG8ofWrph/tnkj9jbm9onV8Hzw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9SPH1QZP7dnpz+vxuse9vJIgbup2al/ScntFzo+eC2/HzOJsGS
	/BRdpuvxWazFALBeCVwLPg40lDKrFlq88KOzIjHfbeNYKvvbTj3ZCi5o
X-Gm-Gg: AYBFou3+09VKu+WruqJe+fpGzECVaVLOnjbN8EsJeEbXvnDLOevrPYaI5bNuTHToPB2
	XlREKinkuqT+4hic1vaSL46Hnh4Ts98GyjhbgC/kFSUPlLJQ3xexs/S7UAIq2nE/AmYXwddXVbW
	vHhT/M8YGDKzFusTywc6ACk+2idKJ58X4gWQjk+QoGt/b3N007uicZi6kaVondUbA3AxeXl36EG
	Z5VJoAIxulyhTplnmUrxg1+JFjSC6yNR3/S8o+QTz2qFwuVr3PJ0oZiPTjWEBBiqk4NiAFwT/de
	uoS2FmLV7LTeRQGGT3N8KsDaByOK+Q5/g3tihcI6AngsLyBl42FqhNP/rFGHdlhxrUORpI8Ybj1
	yPOR1hb0Nt/9fCOzMoU4J5GZcx35NYk1niWxEKq5j3ZRRHJcDbxPkhJH4hvwxmYPv+1uZfNRC2c
	XDlzSOHFywHYVhYh51nacC4PW50LVm7+plAW8mbRoPqKNblneTBV1My5ugAqnnJysFgPCqE6say
	v7LIH80DTkwXd2eILjtiqegyFGPKg/3plmMlE0qzf2lm9b/Akg6QEADwCvrfuMTehl+zSsY4Qsc
	71veKsbeSpLm3nPfk6SKkoIAdS4AcxHgINrdwdssBTn7ZPSJWctmpNePViwhzLCYZEbJ
X-Received: by 2002:a05:693c:6393:20b0:359:3991:ce1a with SMTP id 5a478bee46e88-36a30051a55mr14423643eec.16.1793514347104;
        Sat, 31 Oct 2026 23:25:47 -0700 (PDT)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af91bsm23556242eec.8.2026.10.31.23.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 23:25:46 -0700 (PDT)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Cheng Yongkang <teel4res@gmail.com>
Subject: [PATCH v2] btrfs: reject refs=0 subvolume without DEAD in SUBVOL_SYNC_WAIT
Date: Sat, 31 Oct 2026 23:25:39 -0700
Message-Id: <20261101062539.1744605-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_ioctl_subvol_sync() assumes that a cached root with zero
references has BTRFS_ROOT_SUBVOL_DEAD set, and asserts that before
waiting for the cleaner. Two states break the assumption:

- A corrupt ROOT_ITEM with zero references and a matching orphan item,
  on a writable filesystem.
- A failed subvolume deletion. btrfs_delete_subvolume() zeroes the
  root references, aborts the transaction, which forces the filesystem
  read-only, and then clears DEAD again. No on-disk metadata is
  corrupted in this case.

With CONFIG_BTRFS_ASSERT=y, both reach a BUG().

Before waiting for a deleted subvolume, return -EROFS if the
filesystem is read-only, since the cleaner does not drop dead roots
then. The check runs on every iteration, so it also stops a waiter
when the filesystem becomes read-only during the wait. Subvolume
deletion holds subvol_sem for writing across the abort and the DEAD
rollback, and each iteration takes it for reading before inspecting
the root, so the read-only state and the cleared flag are seen
together. On a writable filesystem, report a zero-reference root
without DEAD and return -EUCLEAN instead of asserting.

Subvolumes that were not deleted or do not exist still return -EEXIST
and -ENOENT, also on a read-only filesystem.

Tested on btrfs for-next with CONFIG_BTRFS_ASSERT=y. A deletion made
to fail by fault injection after the references are cleared hits the
assertion in SUBVOL_SYNC_WAIT without this change and gets -EROFS with
it. A waiter on a deleted subvolume now returns -EROFS when the
filesystem is remounted read-only, instead of waiting until it is
signalled.

Fixes: 6c83d153ed86 ("btrfs: add new ioctl to wait for cleaned subvolumes")
Cc: stable@vger.kernel.org
Suggested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Link: https://lore.kernel.org/linux-btrfs/dd97efe9-91ec-495b-b698-acff1447421c@gmx.com/
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
---
Changes in v2:
- Return -EROFS on a read-only filesystem before waiting for a deleted
  subvolume (Qu).
- Use unlikely() for the inconsistent-root check (Qu).
- Describe the failed-delete case separately from corrupt metadata.
- Add the Fixes tag and Cc stable.

v1: https://lore.kernel.org/linux-btrfs/20261025180258.349175-1-teel4res@gmail.com/

Testing notes (btrfs for-next d1dca33127ef, KASAN):
- The fault-injection case reached the cleared-references state in 2
  of 4 attempts on each kernel. The other attempts aborted earlier, and
  both kernels returned -EEXIST.
- FOR_ONE, FOR_QUEUED, COUNT and PEEK return the same results with and
  without this change for live, missing and deleted subvolumes, on
  writable and read-only mounts.
- The -EUCLEAN branch was not exercised. A crafted image with a
  zero-reference root and no DEAD flag hits the assertion without this
  change, but remounting that image read-write stalls in a transaction
  commit with or without this change, before the filesystem becomes
  writable.

 fs/btrfs/ioctl.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9857d6a9d456..5a1f2edfd831 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5166,8 +5166,14 @@ static int btrfs_ioctl_subvol_sync(struct btrfs_fs_info *fs_info, void __user *a
 			return -ENOENT;
 
 		wait_for_deletion = true;
-		ASSERT(root_flags & BTRFS_ROOT_SUBVOL_DEAD, "root_flags=0x%llx",
-		       root_flags);
+		if (unlikely(test_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state)))
+			return -EROFS;
+		if (unlikely(!(root_flags & BTRFS_ROOT_SUBVOL_DEAD))) {
+			btrfs_err(fs_info,
+				  "subvol %llu has refs 0 without DEAD flag",
+				  args.subvolid);
+			return -EUCLEAN;
+		}
 		sched_ret = schedule_timeout_interruptible(HZ);
 		/* Early wake up or error. */
 		if (sched_ret != 0)

base-commit: d1dca33127efacd86ac550aa86352f8ea9f29a5a
-- 
2.34.1
