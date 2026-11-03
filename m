Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793677813;
	b=m3y0hMm2ISMhyig+BiSWGNkQGKGLbLdI94AzH2e7Lm1h7/AclGvKV3pOImMARWA29SJ6
	 dQI4jjC7VD4NQOQ84G5fnbJpeGT6gG1RwRr06MyMl5VRJL6WnNVVe0/jp9rHeHFFkiN/c
	 3cITWwpJu2QQ7W8TLezhq2xuZAyQARte2u4U2Cw50IEp8ScKpDscdA/i236W7ccERndsi
	 VzVPn2SZPHNoe9ExJ+T3n7LyAM/2zvljtxVDQHOTJR5Ps5fEtqq4Ya3brLjWTuhyx9jDi
	 8tM4nKeKlLbfoO2/ZJG3Qfu4xSmZmvICzs9vdus0IZBM76jIBH1YOn/OeV62Bv3hoHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793677813;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g4Vcjicoj9llbQa1EnB8KvUOzkwI4u/CoPXzHBvmXFM=;
	b=MaPMtckB9l+jm8PBRX2dgUQhnqdbEaJo9RZcmPI1Zc/VCQs37tLkGcw+CkPKmh+kQeD6
	 csmrK4GxZ1lcHt5AsagxlnG2tPJtwCc2cr2u9kdvoN4KcVLbrgdQq8fpaNQ2kCjoC4FyK
	 YtlgykfqHx+O6PrmPqEwQ8E4s9J0LBqPpkGt29U6YDRprotDvkwhqG1sE/CLu42DoelS4
	 gY3AhsiR/KuMD5LkwlrmGuvVv0EfdtNeJCzx9/QyjIPIzl5m4/8bqJHwxd9r6WBRhE3PM
	 Xi4fyFr9kWzLHD+pHrV2JztMpi0uyI/44XP0AXI0ZyzsdWaPRvzbMfcnK/GyYAZJSTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b="E6dh/zim";
	arc=none smtp.remote-ip=209.85.160.171
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5F4606A32C
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 03:50:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B5F4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=E6dh/zim
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5366ae57896so45062721cf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 19:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793677811; x=1794282611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g4Vcjicoj9llbQa1EnB8KvUOzkwI4u/CoPXzHBvmXFM=;
        b=E6dh/zimTsDId4M73mi/nlO6QNw3MEx+3Sc2p7asSf0BN1ilyr4WCVgZ4+7jZzFoBn
         np34MLcEGW1Fd7uWIKUD9jdzaGyWY1m4VYix3NJ+jzZu9s6CIma30mha583ul9tMn/ap
         5Hu8IFe8eOBpNeljGSFJuRadmlGg3HarPMdsRQDGHXpYby+XtwhdOtfWLx5HEchjIWGO
         rVjPOGccIn1Ug0UeMsAAtApcqurGxyovHbelJT/FZlQc3DyKqy/5jgB/A4DRt54naOh8
         Wae0AjN6DbSkkL5NLazZAxd1V0oZjgh9jfUd6u2ze2NBlPbk5tFMIABoP6K2OshNOG6N
         B2SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793677811; x=1794282611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=g4Vcjicoj9llbQa1EnB8KvUOzkwI4u/CoPXzHBvmXFM=;
        b=vfFNuFHKWUoPvnqPMhTr7wPmUde2DV8NvyLWjgYFYFC/MQxTOztaRk62HKZ3OQWm9m
         fsdCMwv3ZvKhTnhvlxeFqCab4sEQLngEj+R9MySkbzWnLv7AL1TphE94TwkHdeG5g+mv
         JXrMZCWEOpSWcWDYoWgWF2qMzGU0i4GckAv5JQFzFS8Mrd9u2EAkTDiVtKx9WrRqwVQo
         Yt/3kNSPS/sog8GtCvOUZtNE/daTTUjqGzoD/9ghWEUSb3bhzgcvWCN8laRarb1LS3qI
         LAQlaGJekgo/lNgrOwJKZPqYSCmuV4ECLP3+U3IRqJw8nR1Q1MeDCO6UgmX+Ry7br6eQ
         Jcxg==
X-Forwarded-Encrypted: i=1; AKwUvBwo5liobBnJdKgkDYPAV+5f4BXS1I6/gLU4q7AvKcVHsAB9YpftimGhJKisJuAbbXq5IJMOfzOIrlMyEw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIjumNTmykNkl8UMFodnmY+sTBAAyY8/X+jpBFSSAED1kAThP4/
	oa8V5W8QfF0F4UW12TqfcXCaIqhodAz/GCV8LLdS34/FT8e9su/dHvjIgPjZDzT1ug==
X-Gm-Gg: AYBFou1T+Eqxohquc6mZpQ+Pxf4sSj5/K+g7Fra/K2eV45g4KzRufM1EsseW+LDOxpW
	a0kn6/kcF9vzEyJpqFFYd8J5457jCdmsjS8Pf97D4JMb3n8FQE6ELEPWiGkIb4DAvxnkBaUKVu9
	UMj5OVFDTkuveo8RiKtHk4raAkWI9bratxnbjSZQYZHmVwciBEvCj8AWfEnK37FFGYpH5cat6rB
	5UFHjx5bwGyBpMXSqEu/iDKIJClNT8mjQBxzoqqVtdLdXY6IIPEYqb+sP/rDOPoDxG0y+DJ64SN
	uNlYAmHJMbch8OdtpOIQXUSF17rYsDhWIUEjoQ9lezA/WWzWYffFV7IqC7YZLUkmrwUmTuF6PiB
	a5+GjPP752PJ+uzX0Lqw8py2Z1tylhi1IwvlTa95wUb6FmelolvyYQaIC5uebo6e9DhmJKEaETn
	M9Cr4btit6rMXHrMLx4T9bAO68UgPvc3sjpY61Q89ZVXAX8hURMvoJsT7f+w+7mWg1UBTqzoY/N
	Y8S5nD5gsgzS0V4tojC12qVar5sgJm5H2N/vvDPdEqCQogmDpt3MUGQWJyGmc/t5Urhmj8ig5ip
	Q5o1KEbnPktwRhTt4ky9orTY7xsHyp37LYmXRg==
X-Received: by 2002:a05:620a:2a03:b0:93f:16d4:3bf0 with SMTP id af79cd13be357-94421744f20mr1931854685a.42.1793677811514;
        Mon, 02 Nov 2026 19:50:11 -0800 (PST)
Received: from localhost.localdomain ([206.206.222.26])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca7e2342asm105461276d6.5.2026.11.02.19.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 19:50:11 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Mishra <smish149@asu.edu>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] btrfs: tree-checker: validate qgroup status item
Date: Mon,  2 Nov 2026 20:49:31 -0700
Message-ID: <20261103034932.1790235-2-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261103034932.1790235-1-smish149@asu.edu>
References: <20261103034932.1790235-1-smish149@asu.edu>
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
An image can have a status item with SIMPLE_MODE and a super block
without the SIMPLE_QUOTA bit.  On a kernel with CONFIG_BTRFS_ASSERT=y,
the mount of this image causes a BUG :

  assertion failed: btrfs_fs_incompat(fs_info, SIMPLE_QUOTA),
  in fs/btrfs/qgroup.c:411
  kernel BUG at fs/btrfs/qgroup.c:411!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:btrfs_read_qgroup_config.cold (fs/btrfs/qgroup.c:411)
  Call Trace:
   open_ctree (fs/btrfs/disk-io.c:3789)
   btrfs_get_tree.cold (fs/btrfs/super.c:2133)
   vfs_get_tree (fs/super.c:1943)
   fc_mount (fs/namespace.c:1282)
   path_mount (fs/namespace.c:4337)
   __x64_sys_mount (fs/namespace.c:4542)

Without CONFIG_BTRFS_ASSERT, the mount is successful in simple quota
mode.  The first data write then adds an owner ref.  The write-time
tree-checker sees the owner ref without the SIMPLE_QUOTA bit and gives
a WARN_ON() (tree-checker.c:1782).

[CAUSE]
The tree-checker does not examine the status item.
btrfs_read_qgroup_config() reads the flags of the status item.  For
SIMPLE_MODE, it calls qgroup_read_enable_gen().  This function ASSERT()s
that the SIMPLE_QUOTA bit is set and that the item contains enable_gen.
Since commit f2363e6fcc79, the kernel does not write SIMPLE_MODE without
the SIMPLE_QUOTA bit.  Thus only a damaged or crafted image has this
state.

[FIX]
Add a tree-checker rule for the status item :
- The item must contain the four members of all versions : version,
  generation, flags and rescan.
- With SIMPLE_MODE, the super block must have the SIMPLE_QUOTA bit, and
  the item must also contain enable_gen.
If a rule fails, the tree-checker rejects the leaf with -EUCLEAN.  Then
btrfs_read_roots() cannot read the quota root.  It ignores the error, as
before, and btrfs mounts the filesystem without quotas.

Fuzzing found this bug. An AI tool helped to analyse the cause and to
write the fix. I tested on btrfs for-next (d6f76ca0a70d), with and
without KASAN and CONFIG_BTRFS_ASSERT=y. Without the patch, the kernel
gives the BUG above, or the WARN_ON() at the first write. With the
patch, the tree-checker rejects the leaf ("qgroup status item has
SIMPLE_MODE but SIMPLE_QUOTA incompat bit unset"). The mount is
successful without quotas. There is no BUG and no WARN_ON(). A clean
simple quota filesystem still mounts, writes data, frees extents and
mounts again. Its status item passes the check at each commit. The
fstests group qgroup has no new failure (34 passed, 3 not run here). A
crafted image and a C reproducer are available on request.

Fixes: 182940f4f4db ("btrfs: qgroup: add new quota mode for simple quotas")
Cc: stable@vger.kernel.org # 6.7+
Signed-off-by: Siddharth Mishra <smish149@asu.edu>
---
 fs/btrfs/tree-checker.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 61ea8f42c..0d75cb537 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2083,6 +2083,38 @@ static int check_raid_stripe_extent(const struct extent_buffer *leaf,
 	return 0;
 }
 
+static int check_qgroup_status_item(const struct extent_buffer *leaf, int slot)
+{
+	const u32 item_size = btrfs_item_size(leaf, slot);
+	const u32 min_size = offsetof(struct btrfs_qgroup_status_item, enable_gen);
+	struct btrfs_qgroup_status_item *ptr;
+
+	/* version, generation, flags and rescan are always present. */
+	if (unlikely(item_size < min_size)) {
+		generic_err(leaf, slot,
+		"invalid qgroup status item size, have %u expect at least %u",
+			    item_size, min_size);
+		return -EUCLEAN;
+	}
+	ptr = btrfs_item_ptr(leaf, slot, struct btrfs_qgroup_status_item);
+	if (!(btrfs_qgroup_status_flags(leaf, ptr) & BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE))
+		return 0;
+
+	/* Simple quotas need the incompat bit and the enable_gen member. */
+	if (unlikely(!btrfs_fs_incompat(leaf->fs_info, SIMPLE_QUOTA))) {
+		generic_err(leaf, slot,
+	"qgroup status item has SIMPLE_MODE but SIMPLE_QUOTA incompat bit unset");
+		return -EUCLEAN;
+	}
+	if (unlikely(item_size < sizeof(*ptr))) {
+		generic_err(leaf, slot,
+	"invalid qgroup status item size for simple quota, have %u expect at least %zu",
+			    item_size, sizeof(*ptr));
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 static int check_remap_key(const struct extent_buffer *leaf,
 			   const struct btrfs_key *key, int slot)
 {
@@ -2475,6 +2507,9 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_FREE_SPACE_BITMAP_KEY:
 		ret = check_free_space_bitmap(leaf, key, slot, prev_key);
 		break;
+	case BTRFS_QGROUP_STATUS_KEY:
+		ret = check_qgroup_status_item(leaf, slot);
+		break;
 	case BTRFS_IDENTITY_REMAP_KEY:
 	case BTRFS_REMAP_KEY:
 	case BTRFS_REMAP_BACKREF_KEY:
-- 
2.54.0

