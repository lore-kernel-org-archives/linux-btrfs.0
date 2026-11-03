Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793677814;
	b=dDxicIeXhfYBi10Sv4fEO+8Q1v/Q/XAx677NCZUOZ7QnwqSqWmVV92D5MHlLPAdK5ozv
	 1rKFF8foUWqpvfRyoDBEWDr472dOCLa3Icf7Vgl40Zf21fUdJMwE3cz7L38snZwF+UXSd
	 RmrjqEtAw6wQLj4Y9ZfWqkctxMPhXpnddszHaghcH/MuCAYd/JtnrkXF3FsC1OFZ1dcM2
	 3UopW+NOObnPEBhWqd3Fu3WW3IsHhkdRk8K5V+huSAGsRNwLzBwd7qnJQeQqN8udMVg0h
	 T60rqaRrkJLli9LdCr8N+l7wR4UKavaSDYRb6GBwF101ObtDaFrMkUoW98rioRuLkmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793677814;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1+blZSQgxNEahjdVa8AiR3LXNuVUk/+DfoiG+PYMEIc=;
	b=shP7pQbptMoIWTrvyW6MGw5Jhw7k85iypVMOx+nHhOO+uSpU0D5LbroaUjNMeosOivjD
	 rabSr9FDmFG9sqA9KkBwMH2IH68RbNPnKNG0ii072YTCAKbRc9q51/xxXfC+pxe0t6ag9
	 pj04KH+oQzP19H8DOF69DASiRMpNKUyUO9Lz4cgr724bfx9hn0ATmP6SLvN2P+CKpDrV2
	 vETG/J7s2s24QL8ZWaLtFQNBDudGDiGmteqfZTrFNOhyjS5e9MDQugGxJIQchO7DzPGhx
	 mGx64DoQKPkuHUh9Euo5V2C0j36QdG1ocPJGm3ZqEWECRqtmovTuPpkP6Cq/GDVy/tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=OxwDrfGQ;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C835606A339
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 03:50:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C835606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=OxwDrfGQ
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-53381e53b80so41783841cf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 19:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793677813; x=1794282613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1+blZSQgxNEahjdVa8AiR3LXNuVUk/+DfoiG+PYMEIc=;
        b=OxwDrfGQN31bGh6PS3DPbNc/mCVz5T+pPRw7AhOgLYipAC1uyglOFwIWTT2VxvTuth
         5Xm1KdTFIMYfOG5CFSY96Grs2I8YsPNJatY5gInNoOb1ZGkgqrHmehVS1FLgd32Pjz6h
         S2mW3NiwQtMWQeYM2EXMhzRUSr07GbSd+pDnUIi8WuE2jXkiz1lAMauLvoOsRY5UQ9lw
         dycZjA8WOh9YMNcLmy7igtwMmYtmnUQOhRIZccvOCw0e6J7UgS6IjevRTfAkdkVjFNNV
         +H/e4yweFcGDN70SZsoJ2x5y6AHWwYV7p7tXnRc8RJqb5mU7EdxgWWJI6ckPcDcbxl/d
         qhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793677813; x=1794282613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1+blZSQgxNEahjdVa8AiR3LXNuVUk/+DfoiG+PYMEIc=;
        b=ASCkgtaEy3Tc/lNqNG8lHYX1uYg/liB25v/IYmIrOO7zKACOyqeT+RVoC+R3teNoGF
         jmcLhIPsHjb09E2H+jYT51StFP9TfDsXMnlGJuqenwbejuA9HN7RiesKL2OZuq13EWnV
         WERU9cWoE6g0iP0pOzH7f6VZqk4tFPAz22aw4MsgEKHlvKlFWR9z3jPxOTbLWpvF7V6x
         3/Zi7jl3cKzF53IT7oXy4b9fDfAL9oNQSiXhHsHb9S7KxVehXWrAlfWx0o2/SU3WT4FF
         M3BZNOwu4hsQMXxJP5n5MsrqoFgG2lhseQ7yZ0MaEYST2nBrFGJEZM77VjLqxemu5H9b
         91Uw==
X-Forwarded-Encrypted: i=1; AKwUvByKQOy9nBm5IMn0NHd/91C9hlZNhsoiGRvT3H7Zm95Cv6EwXmUTT38yM+V0XdRH0T6kIRpbWVQO/agc/Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYKCVgMuhWWcRly20dcb5Wws5hl+spzgcoVfhDfrg9X+7mqtgMfN
	oUAiFcKA8KDdXUDn7suc/HvnUDm8SewphuJsFwQ1eCcCtyH1hVAbtpw8U77UxLzORA==
X-Gm-Gg: AYBFou1iGFMEfHbGyGYg/S2jQBFyb5dNRNBnBxZThgiQFnUWvA1TguEIvhRO3ym71Di
	wnYlOgDx7V/gfEE53zXt1JBChKMFH3yQw+wAQNswin2bH5CdNAxA4E9TZvHXcfafPQuHQ/JqdQ9
	xD1pRPFBVyHh64kGNamCLAzwgrk5tCaTxRZM7H0zt/YTkMOypbVkBIFIMp+YtlTjRk5BTfiBvUk
	FyvxXZ5Zuy1qNWtQZCeBGfY6ef7oR1RbL0XL4wB6JwG8zdCrb34ys5ou7HDB4yMIc6fvHMpkvWM
	CLhybYq2+vkuMfD9EQ/Njui6zrLN+AG3HatgR7JA102gqqTsM2XF+nAH/FZqQ4RXu3yZxm7DXbj
	fH0Lt1cc4CkbxxaRho6qdJ36bmiUe85s4HhAxLIlG1gMP4dFaNSlT4ZIpHpoj6OKmEYmSv/B9FD
	jzcjH+ZS0+dT3wmXjX4BqAOEdDteh2NQQ3e/gT74gshrZOs3R0L3n/q6XzWsqtQUatXBovdIo7y
	LzgH8G+HAt6WJdx2CGgMPtllZOFXf7jSHk4mj6FRX0X+GtY19Jf1WzF/dzGyN0ylSzxRX3GBAfD
	7oSbEmy7ZINZMjjKIPTcl+XzrawGbZPod8FX
X-Received: by 2002:a05:622a:2610:b0:536:725f:588 with SMTP id d75a77b69052e-542b85e3f8cmr200524281cf.76.1793677812711;
        Mon, 02 Nov 2026 19:50:12 -0800 (PST)
Received: from localhost.localdomain ([206.206.222.26])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca7e2342asm105461276d6.5.2026.11.02.19.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 19:50:12 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Mishra <smish149@asu.edu>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] btrfs: tree-checker: reject extent owner ref without simple quota
Date: Mon,  2 Nov 2026 20:49:32 -0700
Message-ID: <20261103034932.1790235-3-smish149@asu.edu>
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
An extent item can contain an owner ref.  The owner ref is correct only
when the super block has the SIMPLE_QUOTA bit.  If the bit is not set,
check_extent_item() gives a WARN_ON() and then accepts the leaf :

	case BTRFS_EXTENT_OWNER_REF_KEY:
		WARN_ON(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA));
		break;

For all other incorrect inline refs, check_extent_item() returns
-EUCLEAN.  After the tree-checker accepts the leaf, a free of the extent
calls btrfs_get_extent_inline_ref_type().  This function ASSERT()s the
SIMPLE_QUOTA bit.

I made a crafted image : an owner ref, no SIMPLE_QUOTA bit, and no quota
tree.  On a kernel with CONFIG_BTRFS_ASSERT=y, I removed the file of the
extent.  At the next commit, btrfs frees the extent and gives :

  WARNING: fs/btrfs/tree-checker.c:1782 at __btrfs_check_leaf
  assertion failed: btrfs_fs_incompat(fs_info, SIMPLE_QUOTA),
  in fs/btrfs/extent-tree.c:354
  kernel BUG at fs/btrfs/extent-tree.c:354!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:btrfs_get_extent_inline_ref_type.cold
  (fs/btrfs/extent-tree.c:354)
  Call Trace:
   lookup_inline_extent_backref (fs/btrfs/extent-tree.c:919)
   lookup_extent_backref (fs/btrfs/extent-tree.c:1100)
   __btrfs_free_extent.isra.0 (fs/btrfs/extent-tree.c:3319)
   __btrfs_run_delayed_refs (fs/btrfs/extent-tree.c:2134)
   btrfs_run_delayed_refs (fs/btrfs/extent-tree.c:2246)
   btrfs_commit_transaction (fs/btrfs/transaction.c:2278)
   ksys_sync (fs/sync.c:104)

Without CONFIG_BTRFS_ASSERT, the kernel gives only the WARN_ON().  Then
btrfs continues to use the owner ref.

[CAUSE]
For an owner ref without the SIMPLE_QUOTA bit, the tree-checker gives a
WARN_ON() and keeps the leaf.  For all other inline ref types, it
rejects the leaf.  Two sources can put owner refs without the
SIMPLE_QUOTA bit on a disk : a damaged or crafted image, and a kernel
without commit f2363e6fcc79 ("btrfs: fix transaction atomicity bug when
enabling simple quotas").

[FIX]
Reject the leaf with -EUCLEAN, as for all other incorrect inline refs.
Then btrfs finds the problem when it reads the leaf, and the ASSERT() is
not reached.

syzbot reported the WARN_ON() and the ASSERT() in 2024 without a
reproducer.  Both reports were closed for inactivity.  At that time, the
WARN_ON() was noted as something that "should be handled in a better
way".  I found the cause during the analysis of a fuzzing report.  An AI
tool helped.  I tested with a crafted image on btrfs for-next
(d6f76ca0a70d).  Without the patch, the kernel gives the WARN_ON(), and
the BUG above with CONFIG_BTRFS_ASSERT=y.  With the patch, the
tree-checker rejects the leaf ("extent owner ref without simple quota")
and the mount fails with -EIO.  There is no WARN_ON() and no BUG.  A
clean simple quota filesystem still writes data, frees extents and
mounts again without errors.  The fstests group qgroup has no new
failure (34 passed, 3 not run here).  The crafted image and the commands
are available on request.

Link: https://syzkaller.appspot.com/bug?extid=d7d1fc7e21835ca19219
Link: https://syzkaller.appspot.com/bug?extid=4983e68a6d77180bfe33
Fixes: d9a620f77e33 ("btrfs: new inline ref storing owning subvol of data extents")
Cc: stable@vger.kernel.org # 6.7+
Signed-off-by: Siddharth Mishra <smish149@asu.edu>
---
 fs/btrfs/tree-checker.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 0d75cb537..5c44bed99 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1779,7 +1779,11 @@ static int check_extent_item(struct extent_buffer *leaf,
 			inline_refs += btrfs_shared_data_ref_count(leaf, sref);
 			break;
 		case BTRFS_EXTENT_OWNER_REF_KEY:
-			WARN_ON(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA));
+			if (unlikely(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA))) {
+				extent_err(leaf, slot,
+					   "extent owner ref without simple quota");
+				return -EUCLEAN;
+			}
 			break;
 		default:
 			extent_err(leaf, slot, "unknown inline ref type: %u",
-- 
2.54.0

