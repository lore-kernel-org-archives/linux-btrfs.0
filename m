Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787817;
	b=gaEhb5Nz+BoT4k8VHs/xCEe5FTc8m3FmJ4+qkd7bAubCPKJqmhKfN7F3TIG7lntBL/lG
	 ZJiwooEpQ7AmJgljtnn4dSbisCzXd0NsmYmy7rNACGc/dZyM8kjlf28oyFgNPTBkeePQj
	 ST0X6GcmD3MZc2Dv9WrzoSeGgJCgnDD+llfGF3UDnmRyR33ycw8mXQfPIOMOah6jwJWm8
	 /EGJkHjCkXq5uLRqRH/BYC7NxNeUzAmcGkmK/m0d0pqftV6MUgutZT9KE6EFksrd9LeS9
	 2xK6U90oPncjElaueEA5TbYbxebJOPbBhWUXlV7k2wOvf8pguAF8BPdaCWv0c30O1rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787817;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KGOUq/ZqyVEMWkCsVi5v1gsLOVeCrKZIZ7AvOAwel7E=;
	b=4xzVB2ZjHwUIQ5ei+CHBCLkCmmu3CoSUpGXkqIdX8ZpyclgWk493JwjBWjzSnbZGuJJT
	 9273EqgT1592GtR3U26sLdS+XT88SSu0P3y97xy9vTJ70nfbo3vWDEKNnAdHSiRu0Gdjk
	 U9XbXjlZzHriWeIVN4HObuVU70+sxvAlstNJBh/qwcKVrP5Sm+KeMj13D15tScBYgy9g1
	 JlVDSFC1eNQoL6FND8dtYlZM5lUNCgh2bp40nPvlhvH3FKXs/VWQgEavhvB+/7K7NQls9
	 9KnUXsSzITCgRmevlgsftLgRs4/eYGqSwkrpCvwNKds6phJ6vGuq002kqjI96o3vOIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=m5AXFCk3;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3545606D821
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 10:23:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3545606D821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=m5AXFCk3
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-36a1947498bso1241109eec.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 02:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793787816; x=1794392616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KGOUq/ZqyVEMWkCsVi5v1gsLOVeCrKZIZ7AvOAwel7E=;
        b=m5AXFCk3PG/vbkuVuK7RU9XAygzIE9Aw/PfApniXxGhtnU7KcC2yjHpB4s6zWt3/vN
         02JdqtUvgyc59eeGA47UYMtHVaNn5WDcbPsB4VH6O39mFdE+NuNbeXYtkX5cHvJBniOQ
         vAzcyK7UtOnYU1Pcy7NazkbOc2n1wFiK7XKQUQwtN7IRRTAuePM12VllVNe7tG/H/rK3
         rItt2feSyFdfDAwaDN5Kqd6F/j3XejIAxSS0cs/yA0iFkN6OJkR96tYMVufiljPu7rFJ
         d/41txPOGV51+CfTjwnLO7mizRdtUAYX4WNr4NoOrVmtmVK/VPithjnSL5Anus7aMxZa
         r4QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793787816; x=1794392616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KGOUq/ZqyVEMWkCsVi5v1gsLOVeCrKZIZ7AvOAwel7E=;
        b=bhWitXpMDmNRDxL6RZGaxZaTItZsYChZeAdpXMXpqJpCUbWIf5dTrCn7Eewdwz+j4a
         0JHGgfWEOF5YVjsOviOl0y6/JgriXLX90nPSbzH5po0GGxlZH9Hv1Lw3DaidR+zjea1r
         upTCpwV2QaOzjK9zvIBr2+KTL7O0lnax99hORxQmm3svSKfi3pJLeY9+DussUgb8b5KE
         B0spC7p35VwZUgxCCaI3jxgBU0H2JRs03wk98ZtF2aoeFbCo33EBw7v978ua2uRXfuWw
         yV7NfxTQNRZiTq/14bDblPQOTXK09fdbBOctRPmPvdhu3LsSc084iTe696hwVuB1DGTK
         vw3Q==
X-Forwarded-Encrypted: i=1; AKwUvBxJjXX2NY0cePG0RAntGRJKYGrAm22TJ8kz10F2t4Ltcwaet7/n01djLfHEOFuMjDfQ2hk3adrqsziEwQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+ghJ3F+fEmJwY/FASlnlN+V3HUpBbLMagB2Tz3+JUb/aS2N4pj
	1DXMjckZ03eKzCKdy5c1YmxuNupIwspaVXk0/F0Q6OfbvW+rkonwuYdcUT2UL+SCbQ==
X-Gm-Gg: AYBFou2CWZ9Jv0lffHAIwaU/37CdyAHsp+ijBr71/iWrTN2dlTDdxtGMG/7BnF6yAp1
	jK5D7iI+DBRq5gAMKAy5ALYojsgBE252668ZeO8ZBsxr6tH1Ll54ozcuyUynrqHym9kYY+kycug
	s0FMWoqopotLK6K2B+X6diJY2P6VbElpfZdCGCNqdVLKfk7AyodaOMaE1S7LsgRmkCsnZMe52nP
	if1v3pdBaSQtjEJFOUQklmwDD1bcmyRA1WJhgdzYYQxz+M73/cgdN3wYxH8ZHeg7CQpQpR/rvrF
	EyFVPSjc3hui8U5afRzCGYn6L8i80TyAn71PNwe6bNBeOWKuFrRrcmNh+m6m+5C20x9m1+TXafG
	pe7I72ZSGuvk1nMFnEJ6QJmaMI5NOUMu1WYWOl4nVtdQH+spK9tQ3z7YDF55L3RVW8qh6iOeVhS
	je0oHe/c722djvFaj+V4mFYDGdw3+rzQYVwn+/tqFKUHcbUPRAQRy7MovX2gfk2SxjOZmbMqmh3
	4N43WBM5mecIqfnDZdDRZOlQyttPo6XCBHVAUhCo/HTAcvHMYV3E1JrBcLjwXnFcB86i+g5d/Qi
	If03ylOZRdaYODEzUseZwcliKVq6ShjGtu6jdPS4dg==
X-Received: by 2002:a05:7300:c00f:10b0:36a:5207:e58b with SMTP id 5a478bee46e88-36a5207e70fmr22554018eec.27.1793787815847;
        Wed, 04 Nov 2026 02:23:35 -0800 (PST)
Received: from localhost.localdomain ([2600:8800:1e00:25f0:ff01:97fc:f9e5:d7e1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a6160sm5749086eec.9.2026.11.04.02.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 02:23:35 -0800 (PST)
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
Subject: [PATCH 5/5] btrfs-progs: tune: do not remove owner refs from tree blocks
Date: Wed,  4 Nov 2026 03:23:23 -0700
Message-ID: <20261104102323.4090290-6-smish149@asu.edu>
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

[BUG]
On a filesystem without skinny-metadata, "btrfstune --remove-simple-quota"
can corrupt the extent items of tree blocks:

  before:
	item 31 key (30756864 EXTENT_ITEM 4096) itemoff 2363 itemsize 51
		refs 1 gen 6 flags TREE_BLOCK
		tree block key (940 INODE_ITEM 0) level 0
		(176 0x5) tree block backref root FS_TREE
  after:
	item 31 key (30756864 EXTENT_ITEM 4096) itemoff 2372 itemsize 42
		refs 1 gen 6 flags TREE_BLOCK
		tree block key (0 UNKNOWN.0 1456) level 0
		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

and "btrfs check" then reports "backpointer mismatch" for each of them.

[CAUSE]
remove_owner_refs() takes the first inline ref right after the
btrfs_extent_item of every EXTENT_ITEM. For a tree block without
skinny-metadata that is the btrfs_tree_block_info. If the lowest byte of
its first key objectid is BTRFS_EXTENT_OWNER_REF_KEY (172, here inode
940 = 0x3ac), the tree block info is taken as an owner ref and 9 bytes of
it are removed.

The check for an extent item without inline refs is also off by one: it
reads the type byte when ptr == item_end.

[FIX]
Owner refs are only added to data extents, so skip extent items with the
TREE_BLOCK flag, and skip the item when ptr >= item_end.

Fixes: 2336a7b921ff ("btrfs-progs: btrfstune: add ability to remove squotas")
Signed-off-by: Siddharth Mishra <smish149@asu.edu>
---
 tune/quota.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tune/quota.c b/tune/quota.c
index a5f7fb40..187ba4f6 100644
--- a/tune/quota.c
+++ b/tune/quota.c
@@ -132,10 +132,12 @@ search_slot:
 		if (found_key.type != BTRFS_EXTENT_ITEM_KEY)
 			goto next;
 		ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
+		if (btrfs_extent_flags(leaf, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK)
+			goto next;
 		ptr = (unsigned long)(ei + 1);
 		item_end = (unsigned long)ei + btrfs_item_size(leaf, slot);
 		/* No inline extent references; accessing type is invalid. */
-		if (ptr > item_end)
+		if (ptr >= item_end)
 			goto next;
 		iref = (struct btrfs_extent_inline_ref *)ptr;
 		type = btrfs_extent_inline_ref_type(leaf, iref);
-- 
2.54.0

