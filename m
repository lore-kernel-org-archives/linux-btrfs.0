Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787815;
	b=f4HjVet0ppnVPWAC/catquUS79S4GfZNrNO2g5vSbltmykdTHxVC2wfN+PVWe/R8OACa
	 uqXZxF+WrmDNSk/QCUonHnennz34fvoEeSqhrkQXe/MniQ4ZxB2Jc1jiECKRvJYPd70Eq
	 p0u2KLvwy0MdrwvaxY7PxCI+sqg+ugqwL9jAXM/ZatsgQCCVEQqGy3elWWAVlpcseYsUi
	 yCQZbBYbh/fSvdGYfmLhqk75D4lehirqUpo5p7ocjAhSGm3i3T5xqStJe6v4yxCS7/zal
	 wIEORYf892q9nsfpLle2ieeGWccjzcyGZaeUP87s1CqsNKAs2Ugs/OhQjErGyWmC2vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787815;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q8KxU0uuRXEMj10OvowCsJ3G/7CIJN/JiInD+fnU/PE=;
	b=UgmyGD011uTYbTxw9CKu3vwxTn9ClyWVDEtGNoLSlPhqIgLnxbL3AYUpzw5QbGpx9x82
	 9PJa9yRVVpLQbZ/EKNqJ0UQcNO0kEy9ci8ZXBzMh5mpDFdXdjIEHcANv4KTUtyY4/4agI
	 eFYShu9RoGNBDfUSDk+lcg40oAYUSJhuW4jG6nmnvRxiO8Mh79JUv2Isa4c+BpQcY4r/K
	 kbFrqbvlG3zS+cPv+Fsa3z66v4bM/9Sa4Z4ri4F1S1hQErDEaExpoK+jVZMnZ+C0/FTiN
	 IiubB0aeoXlt7zCgNgLotFEe1WPo4TR1Uml6Vh2NynMc9fyvUxKOTFcBjlGcXFAOD1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b="aKBOaK/s";
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E080606A335
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 10:23:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E080606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=aKBOaK/s
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-36d6765756fso148942eec.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 02:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793787814; x=1794392614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q8KxU0uuRXEMj10OvowCsJ3G/7CIJN/JiInD+fnU/PE=;
        b=aKBOaK/skv4djSks3YDf30eyBp7oaEcOqCB2jyH8DeG+mSJNNtsddO6QgCh3qU8Lcc
         pc/3FnZRUvPwjflI6EXYjIJtVhMwGJ9yrZBALLrIzrKZCfWmTTX6A9Kx5D0LiSag/1Sr
         iymVFIxL4WNKN5NaiPyWQ7bllBdjDNpiPJ5C0E8LRvq3xHr6GuqeGb0VzIHzmOz/d5M2
         2vd+USiwGdato4GlAyMp/VOK7y4R+1rEVpWR/vK6LzW2D+oHSfnI6hU+2puxVN2oWK5A
         qK4UgVl0VFa5DDXyw9w898DcPIfcIs1R+ADxXNGZcIaiK0CPZYW4XL7y78Kjem1PwKYv
         EsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793787814; x=1794392614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q8KxU0uuRXEMj10OvowCsJ3G/7CIJN/JiInD+fnU/PE=;
        b=NkGnKAq+coevO0Dn5msTT+3XWzHSliy1zHwet1UkjdJBIclg9sOrkxsji3RENhYTLr
         sXRw92Tdt3SRc7mgrJPHwJVOy4Eeu2IJNoOtz7jT6cveNxgtk5Bgw44xun4BWoOQ+BQs
         NAURlgbSMqOEmGVUV5fU7xJJOpe/V9TFaY6v4LXhpb9wC8sSnVrwlcIJq520/0ikAjkX
         QQhwqiRQoNJB2c9FDtGdq4tluSakdZ0xmNx20OoifkgqR5VpUkNr2qOkv5RZjMbdD3E5
         WmS3BNdWvhUcCuaEkoivdEqy7+9SCkt5vuXWOKzkxelFi6oBbjjwtkwM5Lnj+75D3owa
         /Bsw==
X-Forwarded-Encrypted: i=1; AKwUvBwlaR7Jke6mJqMY7hy15MGMbxiHyhIvaiyAYOvqoeUypmjaeSWWnwyjpx1689tCz+wxsgD6pROYrvAZTg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/X7FpK9bLvXKcEUTWpI6nePgqKMlS0hoDeil9ewbVnGbeRlo9Q
	DBzOuFC77dWjxfDeqjI8oIofw5pzxz2XE6K/QDGzaNvfFs3YUcoJLYdoSYYn4NQkiA==
X-Gm-Gg: AYBFou0hxlSggmZGThC5ZMsLWLNMQspGudjKsy042UsQGctyrzrF1pdgIdVqwjqUG5j
	82J+f7wg+zo23aHS/v7+hlQDlo9NNO/4e20S+in7ss7DIAslnU0QndKfFTNiIJd3pCTRHTTgrw4
	f0fzOV9vE9O63cGgKlhYqFMTwjgQbgDpXGoKINSs5YjMWyoPQhhO9WBVZxp6RlCRA6lEjgbZw/G
	ciWv2pYSLK20coMdOmv3wGtgtJf6DcI9vUJxp6BeOWqbDAnqLH/KYknjjkc6XNoqF95dGi7uHbu
	3KRmv0XlLFRdeocHgsubMhQQ0v7c1EEu5FOCOSFaf0nHj3JPcCjevjn8TdBNY8uU5z1rUXAL2w4
	I1LBfVRNmi6D6v3OUD2ISkHbVASBr3AH1/vimwuD7ccsG37h5EmIl18CSAaJjPnPHaaReQAMuro
	R/HfEOYsMcxEhy5KSdGXFwGjaQWCZqocniLX5znU+nuw2nakYwlFVBCWZuTH+Dt+7T7M8/e7Z7s
	fuicYiKRn8ogw1uQfGkgZ2StPpdedEtT7x+SMklpYC4OVAuRRuoikV+4VJKDgNVNeEEilAPLUQt
	ueoYDfds8a6hketerwqc+5WN6SJnMWrd5Tbt5RupDA==
X-Received: by 2002:a05:693c:6090:b0:36a:4a68:84e5 with SMTP id 5a478bee46e88-36a4a68851cmr24932443eec.8.1793787813580;
        Wed, 04 Nov 2026 02:23:33 -0800 (PST)
Received: from localhost.localdomain ([2600:8800:1e00:25f0:ff01:97fc:f9e5:d7e1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a6160sm5749086eec.9.2026.11.04.02.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 02:23:32 -0800 (PST)
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
Subject: [PATCH 3/5] btrfs: tree-checker: reject keyed refs not matching the extent type
Date: Wed,  4 Nov 2026 03:23:21 -0700
Message-ID: <20261104102323.4090290-4-smish149@asu.edu>
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
When the refs of an extent do not fit into its extent item, the others
are stored as keyed ref items with the same objectid, right after the
extent item:

  TREE_BLOCK:  TREE_BLOCK_REF and SHARED_BLOCK_REF items
  DATA:        EXTENT_DATA_REF and SHARED_DATA_REF items

[CAUSE]
check_simple_keyed_refs() and check_extent_data_ref() only verify the
keyed ref itself.  Nothing checks that its type matches the extent it
belongs to, so a tree block ref for a data extent, or a data ref for a
tree block, passes the tree-checker.  For example this data extent is
followed by a keyed tree block ref:

	item 0 key (13631488 EXTENT_ITEM 32768) itemoff 3797 itemsize 198
		refs 41 gen 9 flags DATA
		(178 0xdea30debbf5f519) extent data backref root 256
		objectid 258 offset 0 count 1
		...
	item 1 key (13631488 TREE_BLOCK_REF 5) itemoff 3797 itemsize 0
	           ^^^^^^^^^^^^^^^^^^^^^^^^^^^
		tree block backref

The leaf is accepted.  When the extent is freed later, the refs do not
add up and the transaction aborts:

  WARNING: fs/btrfs/extent-tree.c:3418 at __btrfs_free_extent
  BTRFS error (device vda state A): Transaction 35 aborted (-EUCLEAN)
  BTRFS info (device vda state EA): forced readonly

[ENHANCEMENT]
Check each keyed ref against the item right before it.  Keyed refs sort
right after their extent item, so that item is either the extent item
or another keyed ref of the same extent, and both must be of the same
kind.  Reject a mismatch with -EUCLEAN, so the leaf is refused when it
is read:

  BTRFS critical (device vda): corrupt leaf: block=31678464 slot=1
  extent bytenr=13631488 len=4096 keyed ref type 176 does not match the
  extent type

This is the keyed counterpart of the inline ref check.

If the item before a keyed ref belongs to another extent, its extent
item is in another leaf and the keyed ref cannot be checked by the
tree-checker.

Signed-off-by: Siddharth Mishra <smish149@asu.edu>
---
 fs/btrfs/tree-checker.c | 48 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index db446c8af..d966243c9 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1854,6 +1854,50 @@ static int check_extent_item(struct extent_buffer *leaf,
 	return 0;
 }
 
+static int check_keyed_ref_extent_type(const struct extent_buffer *leaf,
+				       const struct btrfs_key *key, int slot)
+{
+	const bool is_tree_block_ref = (key->type == BTRFS_TREE_BLOCK_REF_KEY ||
+					key->type == BTRFS_SHARED_BLOCK_REF_KEY);
+	struct btrfs_key prev_key;
+	bool prev_is_tree_block;
+
+	if (slot == 0)
+		return 0;
+	btrfs_item_key_to_cpu(leaf, &prev_key, slot - 1);
+	if (prev_key.objectid != key->objectid)
+		return 0;
+
+	switch (prev_key.type) {
+	case BTRFS_EXTENT_ITEM_KEY:
+	case BTRFS_METADATA_ITEM_KEY: {
+		struct btrfs_extent_item *ei;
+
+		ei = btrfs_item_ptr(leaf, slot - 1, struct btrfs_extent_item);
+		prev_is_tree_block = (btrfs_extent_flags(leaf, ei) &
+				      BTRFS_EXTENT_FLAG_TREE_BLOCK);
+		break;
+	}
+	case BTRFS_TREE_BLOCK_REF_KEY:
+	case BTRFS_SHARED_BLOCK_REF_KEY:
+		prev_is_tree_block = true;
+		break;
+	case BTRFS_EXTENT_DATA_REF_KEY:
+	case BTRFS_SHARED_DATA_REF_KEY:
+		prev_is_tree_block = false;
+		break;
+	default:
+		return 0;
+	}
+	if (unlikely(prev_is_tree_block != is_tree_block_ref)) {
+		extent_err(leaf, slot,
+			   "keyed ref type %u does not match the extent type",
+			   key->type);
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 static int check_simple_keyed_refs(struct extent_buffer *leaf,
 				   struct btrfs_key *key, int slot)
 {
@@ -1892,7 +1936,7 @@ static int check_simple_keyed_refs(struct extent_buffer *leaf,
 			   key->offset, leaf->fs_info->sectorsize);
 		return -EUCLEAN;
 	}
-	return 0;
+	return check_keyed_ref_extent_type(leaf, key, slot);
 }
 
 static int check_extent_data_ref(struct extent_buffer *leaf,
@@ -1953,7 +1997,7 @@ static int check_extent_data_ref(struct extent_buffer *leaf,
 			return -EUCLEAN;
 		}
 	}
-	return 0;
+	return check_keyed_ref_extent_type(leaf, key, slot);
 }
 
 #define inode_ref_err(eb, slot, fmt, args...)			\
-- 
2.54.0

