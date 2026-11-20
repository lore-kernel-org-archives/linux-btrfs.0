Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207916;
	b=p1wfTyAQWSiBuQgkdmtBSFtymYxYpQKxgx5BIW8gA8W5i0fdLRCPjdPbVGmJQH1O80qd
	 s68pC79PpHScspgN6GcCaT7X6F9rLVVeWVqAoTYjo17WGKXVM6EKENg8pNa2/KF6WQ7PD
	 +sOalRHh9geY9w68qa7tL8PGqntsKPvOgmd/hDBtLdUCzJgT9JanLYr1Ol9E1A1UEWWKT
	 TTeLe2sH5hgrpj2fhOAjfFqcI+p7Bn8qFlglPKDytv9WBNGfWtDcGvkHvWkvIDF9BvpD5
	 dEEgUg7MlXXmUAZCrh0dTibD9BI0zybCeW9lIeVjTisU+gq1JrAXiwBi/RxCnr+XSRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207916;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=jc4B/ZAyaInl7xXWrF7rGyBRRKoCLa1nL9SU5Vv5qNU=;
	b=Tcyl9sXTHAm+xdzlMwDSiMXVQS7UgCwGwpINMUzOTzjAWsKFBDRzfjtZ9kFifl7jpJ1Z
	 F2ksy7xnshN3eOUUAcAsJWJt8PCzPv8YZSMS4CTR+piJqqAkCsEWpKXp/sLn5Ju8Csonp
	 JOvOegWXDhW0Ty36GfHKqj/V+HCEJYYSuxXRKQtsBJ3y8/cYOpXYbm8ZleDaY6JbWV0Si
	 AU4hHwXRaKhmHNtYjeftlKrRbcYGBvIB/FMto2nNy09fZfETBWKX7cbCSOHeGOIricLI0
	 8XwyJEWQ6TkUOvxYAUPTJxOu3fLRoM01yOZXQvQkMtu0ChHMK8elZLCdhcJDyGO0pZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=COicZSln;
	arc=none smtp.remote-ip=209.85.222.172
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2A1606A332
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 20:51:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F2A1606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=COicZSln
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9496400270fso120224785a.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 12:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795207912; x=1795812712; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jc4B/ZAyaInl7xXWrF7rGyBRRKoCLa1nL9SU5Vv5qNU=;
        b=COicZSlnI2LoFQnjVuFe2SjVSDVuGwUiDRZq9+ijLwX7Nt2qrhWQjd+4EuK0Z+frFj
         QwWJej/Yb8+BmjtAxZvQgz7DJSoeg7IgbYuik/qw7NC5aLjf6RInpE/Fpa4//Zlu61Is
         21+lOGCQTAcUk7feZZbojkaXI+euoGfqCHkQWB/SXEWNxiNnm50uXMR2by1Alu8/ABo7
         e1PmHNz6OjUtX22L8VYtsv8fe7Ebgtiq6lBGyN2xq7GRE7p7NlDYtc7Ib2zAIiPo62ba
         FuFJdcAHNOBKvjlgpqnImzNQkLWBoDt6tOBum9XAxRdp6SiJjSWh1t/XVNe2se9mk00+
         Dzig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795207912; x=1795812712;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jc4B/ZAyaInl7xXWrF7rGyBRRKoCLa1nL9SU5Vv5qNU=;
        b=vNyJ0jGZ98Lz/3x3Pi3RzfJosk2uyalA2MyV3rZ0rI/GlTQliD9idj0KK8m4JYLHbW
         zVd4Bg+gyr72YsRfdybWQ0D2MHh4hFfkanxL6ADKsH9VRqV+Ul8xnJ8Mf3sJmrznyLF+
         pErvfd0RALW4Avx2jWa7hrW7w/rEjIUGZI0MZIWJmJkxos7UIsyxYrCxoz2JSsCSSm02
         oJZknGJDxa9p/6jt4ihrgSQlyAjcmealHGyP4/UyMw/4+/6Bzc1v90KQ2h4BLc9qe9DE
         vxNKkFd3/kvsrAjhv4mG/DSC/eAodDptDMO654+Hm8YmjMDpVVg8tN3b6eToi5z/oJh+
         Lzfw==
X-Gm-Message-State: APuU4Z8uAMOWpoUZutZuSf09J7Y3pWm0ZAkylnyU33aE3YcJo7bVL8dU
	JvXmJk3KSU4wkaI+IFEROvqmVTJEbSDSwq+mVowaEvn2ekI+/QYmW5Jwy6F+Y01JLBE=
X-Gm-Gg: AYBFou37DyhedJTMDeLNyHuJOCB5tXYDiJSroDEbdfEWurh4y8BYqh6E6aF8qa6vb/4
	Sf65a7Ed2pIh7xbmmEoXVB2aDJze42EqOD8/t3uViLHVz1jYm3aLp5MxedD6SSxLiYxQLe27XMo
	Xbc4bZzef9mP9fwTSyQVKJKayzUuplIT+M8gMOAcd2t5W2NAMGJ7SbcytXY7VQ1XTS0FHgxESan
	m9zID7NNp6TfNMR9m44XVB3XFGEda8U6b5m8d8cgURVUMYdbvkz2JD2AvdKbH4ijVx49CH4wAly
	SiNn44Jqnp4iW1wxQth+eHL0zZuSY3zhPBZ0lLr9dLb1e9EJZY7HdPE1F4/uo28cSTvEkIlc5e3
	OLd4fYdxQJKaEmvd5I1lV9xbtJV9QmC50KNdk2wUg0nCRTem8h9EV4dQZGr4XWnlLau2IrbSLUx
	tNKYxr3AFo7Jwi3MyL+cwQSNlWHHurPVTlJqTzIUXsxn7jJSVEwjjpWc1m6Jw8K7xti5a4U8uuM
	Ci4Z/hdhrlxFJhikNNtoh8l41uFzzn9n9J9ERW93ln/m/kBfo6+i4YPUd1UynjX6/92qkMD2uKv
	MACybSyTe/+4/GMqPO6e96mYUuR615eU0DpboETp99wqfg==
X-Received: by 2002:a05:620a:bd3:b0:93c:6417:f9c8 with SMTP id af79cd13be357-949ba9b3e00mr741851985a.29.1795207912095;
        Fri, 20 Nov 2026 12:51:52 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb3f2de5sm272377285a.29.2026.11.20.12.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 12:51:51 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 20 Nov 2026 20:51:34 +0000
Subject: [PATCH v3 6/6] btrfs: don't trim the target of a device replace
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-b4-btrfs-data-integrity-v3-6-4de4b91b826e@toxicpanda.com>
References: <20261120-b4-btrfs-data-integrity-v3-0-4de4b91b826e@toxicpanda.com>
In-Reply-To: <20261120-b4-btrfs-data-integrity-v3-0-4de4b91b826e@toxicpanda.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795207902; l=3117;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=6BSEnwYPwNZRs2G7kiQGSKi44oKpPrCpybE/T7MwIc4=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QE9YRkkcwKTg/hUTfjKeHveiN7lDSuBlgfza409+XlcP1bYi3qHDlVEECSGH0vz3T3UpdCVtQu5
 w3MHA7ojxjQg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

FITRIM also discards the space of every device that is not allocated to a
chunk. btrfs_trim_free_extents() goes over fs_devices->devices and, for
each device that is writeable, discards the ranges that have neither
CHUNK_ALLOCATED nor CHUNK_TRIMMED set in device->alloc_state.

The target device of a running replace operation is on that list and it is
writeable. But its alloc_state is empty. The allocated ranges of the
source device are only copied to it by btrfs_set_target_alloc_state(),
when the replace finishes. Until then the whole device looks unallocated,
so an fstrim discards everything that was copied to it so far, and what is
being written to it in parallel to the source device.

The replace finishes without any error and the source device is dropped.
With a single device filesystem, 700M of data and fstrim called in a loop
while the replace runs:

  BTRFS info: dev_replace from /dev/vdb (devid 1) to /dev/vdc finished
  BTRFS error: bad tree block start, mirror 1 want 30638080 have 0
  BTRFS error: bad tree block start, mirror 2 want 30638080 have 0
  BTRFS info: scrub: not finished on devid 1 with status: -5

Skip the target device, and don't count it in btrfs_ioctl_fitrim()
either. The flag is cleared with the device list mutex held, after the
alloc_state was set up, and the trimming code holds that mutex while it
works on a device.

Fixes: 929be17a9b49 ("btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 8 ++++++++
 fs/btrfs/ioctl.c       | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b0a5c6b96f3..22155507f905 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6641,6 +6641,14 @@ static int btrfs_trim_free_extents_throttle(struct btrfs_device *device,
 	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) || !device->bdev)
 		return 0;
 
+	/*
+	 * The target of a running device replace has nothing in its alloc_state
+	 * until the replace finishes, all of it would look unallocated and we
+	 * would discard what was already copied to it.
+	 */
+	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
+		return 0;
+
 	/* Discard not supported = nothing to do. */
 	if (!bdev_max_discard_sectors(device->bdev))
 		return 0;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 651a780dd7b1..3d1ed1a5911c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -507,6 +507,9 @@ static noinline int btrfs_ioctl_fitrim(struct btrfs_fs_info *fs_info,
 				dev_list) {
 		if (!device->bdev || !bdev_max_discard_sectors(device->bdev))
 			continue;
+		/* Trimming skips the target of a device replace. */
+		if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
+			continue;
 		num_devices++;
 		minlen = min_t(u64, bdev_discard_granularity(device->bdev),
 				    minlen);

-- 
2.55.0

