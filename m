Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787825;
	b=AT3xPrY11KjKUhNfCuYCvgWVX6B5PLxHAmydO4nw3wRS/17neCzOr8HgVl07IScHdlZn
	 /b094VzQliIWluHU3x3q6j0sQOkGmnMkf+eYxaAPwdTaO8kf72UgYf3EzK2S7WdM8oAVr
	 m0M2DfkNUFlgbrJdHvADKgSecN61RCOrDBXiuG8QqUY8bMdGmv7hGG/2SoUmqFQjfXhAQ
	 6f7LxCd/u/sYt9sYDtfbXRCCaEvYCqwDP6xP0cuOr9gN3nFWVi2exzhblH0wtv9sFUYF2
	 muCfv+apZKDWikAAFBnkYotUdtMX5hW2ursUd3S/VI5+c7/XdFuMIxQnHxPiHj4t7+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787825;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uLK6MImajGiIdooVPMrO29/klV59rlibNvUSXvCXNpU=;
	b=VyLTzl4jkcw+ZpGtO6PWNK7vTyekVyP1YCZqJGj9P3uUH6jUVUJ1d1eT1uurC5+ff0dN
	 R6rkC/Z39nSrT0tDXqBmsSxZZMHsJMCMKh7IoKf6ZUCeEUz6WRwAnU5Njz0Eko3E5Ktoe
	 46KcZoXO94BRK8jOZLhSMVZew1eyOu+UuJMAT/q6TpILLRL3u0H5pyb1qmrvOuTtlxddC
	 B+LUE7O1HPduckGK6LwukBX1jh8kOhnfvvJWQ9/KHA6OEWMinThW+6wTL/DZ7zhhzCrSl
	 v94W2UU64/KzLVYAYd/M39kDhmMuYvHMXiU4f0nN3rRAxNErRcF6PvROEst9IwRPYsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=NrThgcDm;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC2E606A336
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 10:23:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EC2E606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=NrThgcDm
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-36a0f27c9f4so907973eec.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 02:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793787812; x=1794392612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uLK6MImajGiIdooVPMrO29/klV59rlibNvUSXvCXNpU=;
        b=NrThgcDmeQZgYynvlOumgkO72cQKo79T65Bwe/G2O+PAeyajpbMgFCcUoAphrH+21S
         MrqXliJPQU9ti92Z4XaP9aBQ1bU9wOZqyohd0vL7apIZRj3GA+Xs+tRKahKU03r/cd/N
         nEY+lzTRU4dNHp1vN6RL/iTqrfWpRVaxgFc5GMxdAgWnwS9wjujndGpOuCy+P/jz58cn
         ZT9svNzkxF4pS5okfBQ3+eU6qPsJSk3aW87UhrWpaCfuKAdoXY4k5dlgdpDSWi29MXHm
         nJrBsrEgKSog7s0trtWMeDO9e3Izv4snYoxIjTvvkwdtLsWgVSa7G12qGpAdfJn67CrC
         c07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793787812; x=1794392612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uLK6MImajGiIdooVPMrO29/klV59rlibNvUSXvCXNpU=;
        b=KTPObSQWwKfI68DiMxVmMNZE5xA4VChSjWMab5nrJiH8Mc2rksb7j2XLmU+oCiW2vm
         jX69dkR2eKx4Cb652VgFFATQ2XEjkC34ufw/kt79w7bs48QdHdXpgQC8TYc3rug98l6S
         S0XOOxXB21KMHz03pEjlmPsnFr0P1EXBgbfbhROOj8fPfYkt8sBBhSs7SMgj+1nrHmdp
         V+JU3ou1LJ2KHCeyZmoRvPCIYJ2ufYs03wzXb6lg8x4afNy16zc/YyY6vgtzTywZ6PVY
         tfHD1+dN/slj/g112zR9WHKr1FCK0PKzcnjD1PRZrOfT+p4DYDMHHajQgp3iR1DU7nNr
         c/Wg==
X-Forwarded-Encrypted: i=1; AKwUvBxUpBGhwR6g6eldsWyNxuePgsZTkif0IXSRTH5+eGvIueDYkHBJyAmpHnz/qRkPs1mTuTlszR5BXNh+/g==@vger.kernel.org
X-Gm-Message-State: APuU4Z8NVc5Us3hLgoTWTb9v9SfYNokF1kPiIZ3xw+wsud31KtHadbD6
	lL+GeGNGJ5DojG/QqQsMWceW+QP7gxOC4jRV+yc7yiwB0pm9AIyOA9BV0aML8xR8yw==
X-Gm-Gg: AYBFou0pipcCAZK1VofLvafx27VEOcBqGXKHv3VTVgnkW9ZkYJJs8RYD/2poODl3sGW
	Pub+evqe/jZCExJAWIm/nPd1LR1G13qyRsPxGaH77Fj8KtsUs2t/k9tgDFXUygQUO526CrPkC8o
	JNeDtnhAPICvhns0YYjd8VLXSuWS1cTKj6+LMbjSIfU23x4xwtrWieX9eVO+phfwSWQgpXOJGWx
	cY/h32AmlCjsHFYd16gSkCEyohB3DcgjTQspMShTyFVWEMQ67eRn2S0GC3uK2LAgUO9dTEQ9wpd
	UF3acg7v/6Sjvjuh7GyM4LWr87SVrgaFdB0oiPngoHgWT65u9G5dVSbICsbntEvDoGLft0G0MjI
	4c29EJHa8d3bjIAz5w+9WVoJ98YhUTn9fqQbi1AesS4Fh+1NdIzoDR1b9y6iUNb1zuAiRefyQKJ
	utabS53E5x6Pbw360nFGJxH8pwqUT2cHswv4ZYuiIcDpEDl+Kd4WKHsDtGIaLT9u57ANQNOEu/f
	8cYwJb9Nb1PsTCVHhlg3vJllaSnBcF/JE41NWffWx0X2HVj22+VY5k7bje6oTxdLKwoZvrowT9y
	lTA//HJtVRuM7VLhNTwIRl7DDAZKQkfdN+PWJiLC4g==
X-Received: by 2002:a05:7301:f8b:b0:36a:2383:eb51 with SMTP id 5a478bee46e88-36a423c4070mr21425188eec.26.1793787812061;
        Wed, 04 Nov 2026 02:23:32 -0800 (PST)
Received: from localhost.localdomain ([2600:8800:1e00:25f0:ff01:97fc:f9e5:d7e1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a6160sm5749086eec.9.2026.11.04.02.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 02:23:31 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: dsterba@suse.com
Cc: wqu@suse.com,
	boris@bur.io,
	josef@toxicpanda.com,
	fdmanana@suse.com,
	mason@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Mishra <smish149@asu.edu>
Subject: [PATCH 2/5] btrfs: tree-checker: reject inline refs not matching the extent type
Date: Wed,  4 Nov 2026 03:23:20 -0700
Message-ID: <20261104102323.4090290-3-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104102323.4090290-1-smish149@asu.edu>
References: <20261104102323.4090290-1-smish149@asu.edu>
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

[BACKGROUND]
An extent item is either for a tree block or for data, and each kind
only gets its own inline ref types:

  TREE_BLOCK: TREE_BLOCK_REF, SHARED_BLOCK_REF
  DATA:       EXTENT_OWNER_REF, EXTENT_DATA_REF, SHARED_DATA_REF

Readers rely on this.  btrfs_get_extent_owner_root() only looks for an
owner ref on data extents, and btrfs_get_extent_inline_ref_type() warns
when a caller that expects a tree block ref or a data ref gets the
other kind.

[CAUSE]
check_extent_item() verifies each inline ref on its own, but never
checks that its type matches the TREE_BLOCK or DATA flag of the extent
item.  So a data ref or an owner ref on a tree block, or a tree block
ref on a data extent, passes the tree-checker.  For example this tree
block has an owner ref instead of its tree block ref:

	item 9 key (30478336 METADATA_ITEM 0) itemoff 3636 itemsize 33
		refs 1 gen 13 flags TREE_BLOCK
		tree block skinny level 0
		(172 0x5) extent owner root 5
		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The leaf is accepted.  When the tree block is freed later,
lookup_inline_extent_backref() skips the owner ref, finds no tree block
ref, and the transaction aborts:

  WARNING: fs/btrfs/extent-tree.c:3418 at __btrfs_free_extent
  BTRFS error (device vda state A): Transaction 14 aborted (-EUCLEAN)
  BTRFS info (device vda state EA): forced readonly

[ENHANCEMENT]
Reject an inline ref whose type does not match the extent flags with
-EUCLEAN, so the leaf is refused when it is read:

  BTRFS critical (device vda): corrupt leaf: block=30441472 slot=9
  extent bytenr=30478336 len=4096 inline ref type 172 does not match
  extent flags 0x2

Signed-off-by: Siddharth Mishra <smish149@asu.edu>
---
 fs/btrfs/tree-checker.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index f021ac14b..db446c8af 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1790,6 +1790,14 @@ static int check_extent_item(struct extent_buffer *leaf,
 				   inline_type);
 			return -EUCLEAN;
 		}
+		if (unlikely(is_tree_block !=
+			     (inline_type == BTRFS_TREE_BLOCK_REF_KEY ||
+			      inline_type == BTRFS_SHARED_BLOCK_REF_KEY))) {
+			extent_err(leaf, slot,
+			"inline ref type %u does not match extent flags 0x%llx",
+				   inline_type, flags);
+			return -EUCLEAN;
+		}
 		if (unlikely(inline_type < last_type)) {
 			extent_err(leaf, slot,
 				   "inline ref out-of-order: has type %u, prev type %u",
-- 
2.54.0

