Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795645152;
	b=OBAguJbnK0IKgSox5LSOHQAW0wLzE5dIh/4UH7HU51tWdVHiKbH1w30hNUo3v6MGW920
	 WVjimcc4q6ajynD9OmZBnXKiE9Gdia6MLfQvVOQya0Y09BRcO9xoUo7swBCOSkwb/7U4C
	 y3ZEGcC5CRzWC+cU2rm3ZsB+MzPCevkSsXVhwvkCRF+lzs+EXBZ1TfJA14IPSz+tSGDv3
	 IVNwdN+WhkEhtx+uUqdQLqYaNtz+sVPU0vvzmS4jphsKa67PWigg4488skU65xqUGuoi7
	 /g4x02OetXkxrM4uzKGm87G/XovR+TcVf5lMS8vsNSAmj7Qr8eU/Xu9Rh90BSTy+ASw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795645152;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=HRwAz9BoxRqxj0ai++/VXeXT7drQEfcQGrxsvupjxW0=;
	b=ZepMcmZH1rQgqOnV78InBmYmiC05UXZ/5VwGeNjaIMVOujkk9D845pJJo0YNTpuIb8HM
	 wvkz3NfKj7DdfBdZYce66eeFDBPgpi0vqM11lItWduybZYcLm1vUyaQyBx8Z0pCsf17Vu
	 TNtGlHsSp+QvLmERg0QjGil567ZALeD4ub/+HsYacsT60Cln93vMsS5/UYrtmioVKkc3J
	 NXQded0U956cmupQNALtqjqVmnfXYPzqmmRHqpIOT/azCUDHpd6T6Bg+41xj2YhCFaFSC
	 xgycgAik9rySrkSuIq916sGrS6cztSD2RtcyRN6QnPgGS4RrilDXVuNDlff7r32146Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--elkin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QkctyuLg;
	arc=none smtp.remote-ip=74.125.82.197
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A757606A323
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 22:19:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A757606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elkin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QkctyuLg
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-386177b0516so15900603eec.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 14:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795645151; x=1796249951; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HRwAz9BoxRqxj0ai++/VXeXT7drQEfcQGrxsvupjxW0=;
        b=QkctyuLgA/2GA1yUMcmHN6bL8bcZjgDzca4mPa0RyvyOTEsqxtpjfbQIPnwxG+Uoc5
         8TBLC7lqnrNOV6X6+LaaObv2eP4bznBq++klBfO+dHAcyTLTPKDULbCVPLZhL5MvJXM/
         OUu81pQLQyM1szV0+EHngPCcp0qPultxJtWYnEZ8RHAASSX23tgpKsAmIWame9yNNfew
         14iOWXy6piPeLHrX3nfFOCh92lEa5V4+nP1Ex4yKUxVk/GcMloP/HFWDsPFrw0SZ2vRl
         axTwQJI1goaAoAuvltzivAtO/M5KunaE36LDmaRPEbc5J/daY+UGFdO+52rmycnuXGF4
         eOtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795645152; x=1796249952;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HRwAz9BoxRqxj0ai++/VXeXT7drQEfcQGrxsvupjxW0=;
        b=s84ggRJ5lDprGDZDm4jeAsAi+Gm41tcOY2nYUPjE4WkcxxqlDvNzrnHxSvGxluTOHg
         WJcIe6iC8SJdTxyOsQKRkM66infJOi2evOXG1hCxDd041YNHRAhhsMYv9po+7SgYNZMW
         ojvitazcW6j2y329N47AErQzg1Vl9inoAsBiZ3KcFq6/wrKMOH7FBfaQ3XLiEItL9k7u
         tNpoiHJUZjo3WI0xv3Aa7ecCC8U/05R8dtJu/i2qI9OD3IxTK8jRw1jzpnFy2+q2re32
         TquAzAEW4UMzWNlCtgSQrdL9IkPCSpYHH95BiytQx8+3u1I8Zb/uE2Z7u+whoXalYyeC
         AkKQ==
X-Forwarded-Encrypted: i=1; AL+hErHpLCjsFeop6KIQAo3O6hGVqRwNrTkTLOXsf9OByepKZz+sfUjFCkxt5F0P/M4clfJlL1/sWoyIn0iWeg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+rHqF7lYNqY59qRft9OsdBUuETwKVVRKKACyU9XqDMDg6RTaxr
	0WEam1iU5FBDlkH6H5RX8W99qW3Z6nhclgTcRX16S4LnkQ9dKG63dKm1klr5rE5Uruk0H0osjqP
	V2A==
X-Received: from dybeb10.prod.google.com ([2002:a05:7300:a2ca:b0:385:2e0b:4776])
 (user=elkin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:dd94:b0:36c:9afe:fcd8
 with SMTP id 5a478bee46e88-3856f559cfemr18733738eec.30.1795645151282; Wed, 25
 Nov 2026 14:19:11 -0800 (PST)
Date: Wed, 25 Nov 2026 22:18:49 +0000
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261125221849.1424464-1-elkin@google.com>
Subject: [PATCH] btrfs: tree-checker: verify tree_block_info bounds in check_extent_item()
From: Elkin Cruz <elkin@google.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, irogers@google.com, 
	Elkin Cruz <elkin@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

check_extent_item() only verifies item_size >= sizeof(*ei) before
reading struct btrfs_tree_block_info on non-skinny tree block extent
items (BTRFS_EXTENT_ITEM_KEY with BTRFS_EXTENT_FLAG_TREE_BLOCK). A
crafted filesystem image with 24 <= item_size < 42 causes
btrfs_tree_block_level() to read past the item and potentially past the
extent buffer's populated folios.

Verify item_size >= sizeof(*ei) + sizeof(*info) before accessing
btrfs_tree_block_info.

Fixes: f82d1c7ca8ae ("btrfs: tree-checker: Add EXTENT_ITEM and METADATA_ITEM check")
Cc: stable@vger.kernel.org
Signed-off-by: Elkin Cruz <elkin@google.com>
---

I am trying out new Clang static analysis checks for kernel bug
classes, and they flagged this code as possibly buggy. The findings
were triaged/fixed and commit descriptions were drafted with help of AI,
then checked against linux-next (not runtime-tested on hardware).

Thanks,
Elkin

 fs/btrfs/tree-checker.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index d2bf21c7b848..a38eeef7b859 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1665,6 +1665,13 @@ static int check_extent_item(struct extent_buffer *leaf,
 	if (is_tree_block && key->type != BTRFS_METADATA_ITEM_KEY) {
 		struct btrfs_tree_block_info *info;
 
+		if (unlikely(item_size < sizeof(*ei) + sizeof(*info))) {
+			extent_err(leaf, slot,
+				   "invalid item size, have %u expect [%zu, %u)",
+				   item_size, sizeof(*ei) + sizeof(*info),
+				   BTRFS_LEAF_DATA_SIZE(fs_info));
+			return -EUCLEAN;
+		}
 		info = (struct btrfs_tree_block_info *)ptr;
 		if (unlikely(btrfs_tree_block_level(leaf, info) >= BTRFS_MAX_LEVEL)) {
 			extent_err(leaf, slot,
-- 
2.56.1.839.g22a8290db9-goog

