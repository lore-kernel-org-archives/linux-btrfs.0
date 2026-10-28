Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793170646;
	b=ii+6r+nPxfPKVIrk0cM0ILwAAQwSWnmdowCCq+oqe0PwWqwdazXABxrIemU+0UGt/VL8
	 uMF6ylMZxGs8V5Y3klIJK/XgD2hfFYByJr4td4VcU+9hDyC77PcsCuZVKdsDuJBC84+vc
	 q9I9TPoH6IT6wJ2Wk6zje+3nCX8WAutfH1rzjtWflUQB//R4p4Ca1YoL8OMhuTvWPf3CI
	 I5iZTWAQ/xcwoVkGlAbF0xA1CVhPprbawXgX/kWGNdzFawP5gdEnawHnEqGJMYlLi1lTw
	 Pys50WrDqrQKK/l0aJxvkf40A3Yg7fE8wcQ4c9prLJgsr3bmWAsVm2SykWQnsS5JwlA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793170646;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=8SrW+3hmCu4MaSz+gsxVKVJ3CE3qAcb8qukbx8mEbsE=;
	b=if2+C7oArl3+89DksCmLn4pszSDNYKS1tDbBhhZ+8GFaM2/ahbtSxDH90LM7Gcx/bkuc
	 D9lx+uaPC5Sw2yL5xZ98TE73T08xfIicqUBrGNsV8mDYbg5vagQHJE5+95LrAJlqo4MO4
	 Ta1HCdPDz2nHuRk1heWepCA4mAhbL6kOPgP5oKWSsNxFJ9lPFXMrpVAxfHAuPpMxijo2X
	 ZG4f4Qbt2chrYKGqQKsI7MUOcQSHPA+LJEjXpQCNMOi7tw3IkZVHRnnxpMe/CwA8gosuw
	 Kuo/T3gTPNfmAaVSrPScwiJ9n80uR43SyyLPRuw+VR7ViFeEr/u9pzTE9Xz8dnoqmGg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oIqI/zDw";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CE0606A31A;
	Wed, 28 Oct 2026 06:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oIqI/zDw
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793170645;
	b=CMmMFOrxdVnr9mmVFzVrhpEB1yxbs8GB1EWPlQeaDL5684eik3lXw9hex6GKM6qBRAUQ
	 PkN9Tf3hYSzoTqPvD769+1Ej+rEf+tT0d8XirHZa/qgSRkyCCxQUlcGdDTwitk68t8p+7
	 +t71N67szBC5eUlVJQba2z2XowLxANDWLbGla4y/4NG26F9YN3mXQp4FXC1MrxaQdpI5e
	 PEMtzEPfR7YZQgcn7QnTrF2nOXyMzyOPeCWmKFL+kDDyFUzNmgpw9/QjW2/mCHehvhdr9
	 wvfsHFjMcF0svGOvGzO8/krbhHqWR6Bvseckd09cwcoIrnhLqPcn1lbsSHmESghkGuA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793170645;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=8SrW+3hmCu4MaSz+gsxVKVJ3CE3qAcb8qukbx8mEbsE=;
	b=qfRbUEYdcQ8LRdvC11eWlDVFx/hOvi8O8j8Ptf4ndwclEr3nhStojK5bqC2aRAuIvfBl
	 jXtAMplb//A+QdmrWAytnv0JJQr7ARfS04m9Q986io+yJiMr+nrGq3ft0XBklpZD5Dx5M
	 nb0lcecrMCiJuaWoED5cfuLQAi0gnTxkIs39/QBaW7QKEx6qhsdQWM+qum1Y1a2GNGANl
	 8wWxltZZ4BY4s1ECkNu+Ny/Su+J+ZPfUjkrRaRMgq5PGF4aC4+DSfAxygumsqeiHKInMy
	 pHMhjA3igTP/zdT8LhL6E1/yuuiEQ3bikLO6r3tfV9ZJkBYFs2lEdEjwI362eHNY/4g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DFA9B1F01829;
	Wed, 28 Oct 2026 06:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793170645;
	bh=8SrW+3hmCu4MaSz+gsxVKVJ3CE3qAcb8qukbx8mEbsE=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=oIqI/zDwa44BGK8ZRZ5iQ18ZA62Tpm9fLr7gtsDQrbCFehGb6mm0xV5vZAV1sos/l
	 ld65k8KeLXJ8mVoBCGpJ8zo8CpyX3z46+82bI1MdC42oTGGxbUZFslbOK3hjFUViy/
	 oftcNQw/If259Ht64wj/z2fLZzgQsml+BdZGhEPsflAhwYx+Yx3sDaGV70AMkRliaa
	 bNQZtSkfT47ZjvvqK26REzWFaZIDq3T6BhAyqveb41NsK4nahKyPoFwjLUG8xqHJwx
	 zxz3S3IPrVjWXqFM5QEVN5h1KCGSgCoOMOG9h+VbdrXvUWKDqTpJRPSZTFicc5vCYB
	 rG/Da+kMHYogg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 616BF4538A;
	Wed, 28 Oct 2026 06:57:24 +0000 (UTC)
From: Zhiwei Liang via B4 Relay <devnull+zhiwei.liang.zliang.me@kernel.org>
Date: Wed, 28 Oct 2026 02:57:22 -0400
Subject: [PATCH] btrfs: do not leak -ERESTARTSYS from FITRIM to userspace
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
Message-Id: <20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3Myw5AMBBG4VeRWZtESxCvIhbFX2bhkqmIEO+us
 fwW5zwUoIJATfKQ4pQg2xph0oSG2a0TWMZospktTWZr7g/1gb0cKgt7BW4oj8XQO1Oigskpprv
 Cy/Vv2+59Pw9B65ZmAAAA
X-Change-ID: 20261028-btrfs-fitrim-freezer-d4cba16e7e13
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Luca Stefani <luca.stefani.ge1@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>, 
 Robbie Ko <robbieko@synology.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Zhiwei Liang <zhiwei.liang@zliang.me>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793170644; l=3889;
 i=zhiwei.liang@zliang.me; s=20261028; h=from:subject:message-id;
 bh=Ad5ltHNBqZJjriNkGAbAzE09HDU828bU7XQWfgn5xEc=;
 b=l5aVf854cSCkVputMgv0JYK/81X4hxuZ5sdDmE3fJg7kTXs4wErv/xbLQ17SVBAyjy7nPwgFt
 R72ccD/s9QUA/elO70Yn0HB115xNrFGSHBo6jACTPusKs/MY7vSrXc8
X-Developer-Key: i=zhiwei.liang@zliang.me; a=ed25519;
 pk=+Dr+pFt7zVWal4wTkqPegKXbLTdm/ko6GA/XhKr6NO8=
X-Endpoint-Received: by B4 Relay for zhiwei.liang@zliang.me/20261028 with
 auth_id=1339
X-Original-From: Zhiwei Liang <zhiwei.liang@zliang.me>
Reply-To: zhiwei.liang@zliang.me
Content-Transfer-Encoding: 7bit

From: Zhiwei Liang <zhiwei.liang@zliang.me>

When a suspend starts during FITRIM, fstrim can fail with:

  fstrim: /: FITRIM ioctl failed: Unknown error 512

On a Fedora 44 laptop with kernel 7.2.7, 3 of the last 21 weekly
fstrim.service runs were in progress when an automatic suspend started.
All three failed this way and left the filesystem untrimmed.

Since commit 69313850dce3 ("btrfs: add cancellation points to trim
loops"), the trim loops return -ERESTARTSYS when
btrfs_trim_interrupted() sees freezing(current), and FITRIM returns it
to userspace. Since commit bfb670b9183b ("btrfs: handle user interrupt
properly in btrfs_trim_fs()"), btrfs_trim_fs() returns it right away.

-ERESTARTSYS is only valid while a signal is pending, because only the
signal handling on syscall exit turns it into a restart. But
freeze_processes() first sets pm_freezing, which makes freezing() true
for every user task. Then it walks the task list and sends each task a
fake signal. The trim loops check btrfs_trim_interrupted() after every
extent. If a check falls in this window, the loop returns -ERESTARTSYS
with no signal pending. Nothing restarts the syscall. On that laptop,
with a few thousand threads, freezing user space took 2 to 5 ms in each
of the three suspends above, and all three runs hit this window.

Make btrfs_trim_interrupted() treat a freeze as an interruption only
once the fake signal has arrived, i.e. when
freezing(current) && signal_pending(current). freeze_processes() sends
that signal in the same call. The trim loop stops at the next check
after it, so suspend is not delayed.

The restarted syscall re-reads struct fstrim_range from user memory.
When the device phase is interrupted, btrfs_trim_fs() has already stored
the trimmed byte count in range->len, and btrfs_ioctl_fitrim() copies
the struct back unconditionally. The restart is then asked to trim
[start, start + trimmed) instead of the requested range, or fails with
-EINVAL when nothing was counted yet. Skip the copy_to_user() for
-ERESTARTSYS. In all other cases the partial count is still copied back.

Tested in a VM with pm_test=freezer. Without the patch, 18 of 20 freezes
during a trim leaked errno 512, and 10 of 10 restarts after a
device-phase interruption failed with -EINVAL. With the patch, all 30
runs restarted and trimmed the full amount.

Fixes: 69313850dce3 ("btrfs: add cancellation points to trim loops")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Zhiwei Liang <zhiwei.liang@zliang.me>
---
 fs/btrfs/free-space-cache.h | 3 ++-
 fs/btrfs/ioctl.c            | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index e22443598b..cba2f5fd6b 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -58,7 +58,8 @@ static inline bool btrfs_free_space_trimming_bitmap(
 
 static inline bool btrfs_trim_interrupted(void)
 {
-	return fatal_signal_pending(current) || freezing(current);
+	return fatal_signal_pending(current) ||
+	       (freezing(current) && signal_pending(current));
 }
 
 /*
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ac070c745b..b02c59cbb0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -529,6 +529,13 @@ static noinline int btrfs_ioctl_fitrim(struct btrfs_fs_info *fs_info,
 	range.minlen = max(range.minlen, minlen);
 	ret = btrfs_trim_fs(fs_info, &range);
 
+	/*
+	 * A restart re-reads the range from user space, so do not clobber it
+	 * with the partial len the rerun would otherwise take as its input.
+	 */
+	if (ret == -ERESTARTSYS)
+		return ret;
+
 	if (copy_to_user(arg, &range, sizeof(range)))
 		return -EFAULT;
 

---
base-commit: e17e64baf63f7c85bec209ed73f14c1b2a7e39fb
change-id: 20261028-btrfs-fitrim-freezer-d4cba16e7e13

Best regards,
-- 
Zhiwei Liang <zhiwei.liang@zliang.me>


