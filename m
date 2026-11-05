Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793915265;
	b=3CtF7H6SmmOU3lQykTLLBNeZHFfqRFPjy7rPE32ucJr3vwkafxVkGZWSLYs2GWZZF1r7
	 46fqDJs/FZ9kTn8Sp6XgHtl54GpM7NDE7Jb+ToD4p6CttxRLGyGn1GD1R+dVfYInC3AW6
	 V1zK3+bZEaxHHuQ0fo4zZJPtQSbmUWa2uGehsWeOtAAuu2zYkWtHY1h2sP9Dc69GH5fWP
	 DE3c6pfQ7UCwwjOTeYoDdeAoGqiO9Dmeo7Z4f75JFjDpGRvXhqgKaGYrS2zjAmR/+gdaD
	 AuktrS2ZuK5M8ddIqfS7hV5wtSJ+feAHqmb2P6m4BQgJ4KZjyOjHJGYDCAAAYX8B1Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793915265;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QAegit7Xk65ptYMjRAVs5VrIlC0wdX8x8wtsFGzMb+A=;
	b=Erfx78S+jQ1sAEs0ZCyrMDgdAsqLtzlS4aFxenlQj6pjvUUKWtT7u+37B1aF60RIwI8u
	 wWtX9qClrTN95PxzmFLFMiMmLd+BulO0o6J+JY7CbF37YvnAwn+83xY6JrJooMFP8vJ6Y
	 Zos+rnWZ/Twe7R5VvOBM2cYDJ7Ijr14WjP/EwsHBksMCMfAo2sHPxjyPtndJl349BcPFg
	 204DlLuAn6oKxkAS6jmw0GiKMCD06b7hXgZYzU8KD7/HOENgz5o7tG9GfmZrFulNl6EON
	 rTXBQ6yqfu2EBgX2/cbPgt6QgdHqva3i9pFU73PjARCnC6lRd8i7Pb/G+V479cdeWKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=Wtyrs6oa;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57251606A338
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 21:47:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57251606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=Wtyrs6oa
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso3865668eec.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 13:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793915264; x=1794520064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QAegit7Xk65ptYMjRAVs5VrIlC0wdX8x8wtsFGzMb+A=;
        b=Wtyrs6oa9KxpzrnAvJFQxxCgnQE5epmYkEJZt9JiU4N57iFdRHEIlytQ3BB6+y9LHq
         6xkSSUCX1NAsXpYdLmmMf2P3GTcHqdH7nprT5WzXOrm9t15XeAisUcLiMby91SbzCVe4
         7o+GoSKYVnDbqGXKnk27iL8DJKhx2DerA6HfIwiJ/iFLxie/J79ykaKRvPk7FgJU6js9
         GPU1TRyuLhywJxU/7cNv9QPfbZjg3uQzyb0N2SUJ6qjm/OYJn6tv49BXhQeUfAO2Kave
         GiF5q9oqMeinhiOaPjRvdQMBiRQ0hr0gir0BS2VUZ4W8Y2bbQtuH3iKQNCLhL0ZhZgVa
         npSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793915264; x=1794520064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QAegit7Xk65ptYMjRAVs5VrIlC0wdX8x8wtsFGzMb+A=;
        b=obIObU7/7R/Nqgget0Je3FCo+9tzyK6bWdUksAP5XXfgSFSEOJ+CFxdz8vSjCU56zG
         wakDlfnEHKB+7/QIJGkm8FKZKwbH2buisADt4agi6I8WMPmhi/fxLy1NLtxTaFnnz+31
         wbqeRUNKm0fiEHbRDpS45lezjsePixZZ+fvPRYQD4yqgTcUZxddaAdpsK/Kg8cN5Awiw
         eeRsNlkam8/AdmJyoaFHraaNvv3+QBrMImFWW16h7XMz/xXYMO3abEeLstoqajGA7gUn
         dkco1UQGYtXbD6RDH8Ke/t+KKvSlHqcgWluChL4jg171Mzx61JusMFn3V+k0vWiLpRZQ
         4yAg==
X-Forwarded-Encrypted: i=1; AKwUvBzwcc+L/+avag2SaYpkicGxLDd5YT/otd+XWgv3dFecBExxNhaeWtjzNabf3WEcQdj7a7PhNiV3boMdSQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/+Xu/XySHeO6A4BbFSmkBWhb3SC80E9X692R9Ln6MZJ4734Fqm
	QjbqKawax1GooSCkVwPw7t3gkKhH9jNcrzM1rlOAl/gZGcBFn0BSPbuXYMI8+ZHw0Q==
X-Gm-Gg: AYBFou0PeJwVt/qRFoDFzNTJtXd2QnYvjaGElTtXTKmB+zCvSp15CWWZvj+eVRjazfn
	6tVdQZJje2ZzyLRDKiSQHJXnbOM6GUFt7Ar2N1YvJdCBO5sO2nO+eEUTsKX1ZHaI1anJ/W26Ds2
	bHcUATkcOlvD50qsSbI9KX9cxDEtgHYEurp4UbsQ/jZla+frjvSXMg4nijJmgfn9n/3wrvPYATY
	CpF2sxkjwAR4rdh9zX3yAzC7zeYVhkpbSage1sJZZLxtNBKXAr6AqSFb1/0v6qQ3IKuzBj7VQQi
	znzWL5SJkTinpCPH45501OjCBOMmrEpwgSKIdHR6VdOKP66QuF6mSDimcwEA4Oo3d+XDqhwGukn
	lYH6FXnOzONXxPStAzR9WhhizJGfK5hno/sVfnnE/AKLNDAdDmeBquWfZkNvlRJCZsTlysZXXxE
	/bKNx5/VCZ78ArVEkxK+8pxabeVtiPuEDmqchIknkc4FYRCB3hj32k5Lvl3rDcJu+lBQdeo5FV0
	by+5OuFQU17OQQeA9Ui/mzu3fO/dIoMnDfsGVbBMlYtgszlv81i0JD//T0DIDB5rkw6h354hA96
	iwFtim0F3vtVFSCHQjp/36Wjs+ldT3RiHceG
X-Received: by 2002:a05:7300:8807:b0:36a:4a68:84e5 with SMTP id 5a478bee46e88-36f7525245emr694954eec.8.1793915264020;
        Thu, 05 Nov 2026 13:47:44 -0800 (PST)
Received: from localhost.localdomain ([206.206.222.26])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f71a25c1asm2036943eec.27.2026.11.05.13.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 13:47:43 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: dsterba@suse.com
Cc: mason@kernel.org,
	josef@toxicpanda.com,
	wqu@suse.com,
	fdmanana@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Mishra <smish149@asu.edu>
Subject: [PATCH 2/2] btrfs: tree-checker: add balance item size check
Date: Thu,  5 Nov 2026 14:47:38 -0700
Message-ID: <20261105214738.111967-3-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261105214738.111967-1-smish149@asu.edu>
References: <20261105214738.111967-1-smish149@asu.edu>
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
A paused or interrupted balance leaves a balance item in the root tree,
with the key (BALANCE_OBJECTID TEMPORARY_ITEM 0) and a struct
btrfs_balance_item of 448 bytes.  At mount btrfs_recover_balance()
reads the flags and the data, meta and sys args from this item, and
the balance is resumed with them.

[CAUSE]
The tree-checker has no check for TEMPORARY_ITEM keys, and
btrfs_recover_balance() reads the item without checking its size.
With a balance item that is too short, the reads go past the end of
the item into the data of the previous item in the leaf, and the
balance is resumed with whatever those bytes hold.  Nothing is
reported.  For example this balance item is 48 bytes short:

  item 11 key (DATA_RELOC_TREE ROOT_ITEM 0) itemoff 12545 itemsize 439
  item 12 key (BALANCE TEMPORARY_ITEM 0) itemoff 12145 itemsize 400
                                                       ^^^^^^^^^^^^

The mount succeeds and the balance is resumed:

  BTRFS info (device vda): balance: resume
  BTRFS info (device vda): balance: ended with status: 0

[ENHANCEMENT]
Add check_balance_item() to reject a balance item whose size is not
the size of struct btrfs_balance_item, so the leaf is refused when it
is read:

  BTRFS critical (device vda): corrupt leaf: root=1 block=30654464
  slot=12, invalid balance item size, have 400 expect 448
  BTRFS error (device vda): read time tree block corruption detected
  on logical 30654464 mirror 1
  BTRFS warning (device vda): couldn't read tree root
  BTRFS error (device vda): open_ctree failed: -EIO

Signed-off-by: Siddharth Mishra <smish149@asu.edu>
---
An alternative is to check the size only where the item is read, in
btrfs_recover_balance(), before bctl is allocated.  That refuses only
the balance item and fails the mount with -EUCLEAN, instead of refusing
the whole root tree leaf:

  BTRFS error (device vda): invalid balance item size, have 400 expect 448
  BTRFS error (device vda): failed to recover balance: -EUCLEAN
  BTRFS error (device vda): open_ctree failed: -EUCLEAN

It was tested the same way as this patch.  The tested diff, indented so
that it is not applied with this patch, in case it is preferred:

  diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
  index 3d4ef6725..97154f59f 100644
  --- a/fs/btrfs/volumes.c
  +++ b/fs/btrfs/volumes.c
  @@ -5230,11 +5230,17 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
   		return 0;
   	}
   
  +	leaf = path->nodes[0];
  +	if (unlikely(btrfs_item_size(leaf, path->slots[0]) != sizeof(*item))) {
  +		btrfs_err(fs_info, "invalid balance item size, have %u expect %zu",
  +			  btrfs_item_size(leaf, path->slots[0]), sizeof(*item));
  +		return -EUCLEAN;
  +	}
  +
   	bctl = kzalloc_obj(*bctl, GFP_NOFS);
   	if (!bctl)
   		return -ENOMEM;
   
  -	leaf = path->nodes[0];
   	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_balance_item);
   
   	bctl->flags = btrfs_balance_flags(leaf, item);

 fs/btrfs/tree-checker.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index f021ac14b..5698845be 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2117,6 +2117,19 @@ static int check_qgroup_status_item(const struct extent_buffer *leaf, int slot)
 	return 0;
 }
 
+static int check_balance_item(const struct extent_buffer *leaf, int slot)
+{
+	const u32 item_size = btrfs_item_size(leaf, slot);
+
+	if (unlikely(item_size != sizeof(struct btrfs_balance_item))) {
+		generic_err(leaf, slot,
+			    "invalid balance item size, have %u expect %zu",
+			    item_size, sizeof(struct btrfs_balance_item));
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 static int check_remap_key(const struct extent_buffer *leaf,
 			   const struct btrfs_key *key, int slot)
 {
@@ -2512,6 +2525,10 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_QGROUP_STATUS_KEY:
 		ret = check_qgroup_status_item(leaf, slot);
 		break;
+	case BTRFS_TEMPORARY_ITEM_KEY:
+		if (key->objectid == BTRFS_BALANCE_OBJECTID)
+			ret = check_balance_item(leaf, slot);
+		break;
 	case BTRFS_IDENTITY_REMAP_KEY:
 	case BTRFS_REMAP_KEY:
 	case BTRFS_REMAP_BACKREF_KEY:
-- 
2.54.0

