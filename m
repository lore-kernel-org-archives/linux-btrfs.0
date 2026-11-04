Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787816;
	b=V0M6jaUdvTGa9nGEoj+lz7xzszpH68yMa6bk822AcNn7qVrwuV7Xida+ge3njk7goznf
	 zXysLuLJHVkrMWfLw2kjWR0UqQ2duJzQiBQf3SUR9n8xWHIil+pxMuenZtjjmM8j9d01l
	 CWtAgAYIjudbcmPLV+LayupasYU3uHMBr4nRyRQUt2QuFwg3kc/Uq2vzZhYGKjruQLOEt
	 P+SAysAJKWHPhZWM9/ttSsWX4afEiqZoXW9oozXe7NyDOD12bM9ZVx2qN1qoed6Y+oGej
	 pBlrQInmb36K1nf1GycMeWRrSBc2oE7N6Y36P5WRgNLHQ+VcOVGys7VBk7EMhGovFig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787816;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6V1X+zEwxVrSk2M8OWKn6u4m5FeW67/2ByAIN+CIG8E=;
	b=aPOkR+FVxGia4kE5tnttx6XSeOjnAuyd8lHigPa6pKN1qiMKP/+KMh1aVZ3SJ2WTmL0q
	 2aE+Tarq+DKuwKc1PnEeGAjHKrecV8iqYx6IB4JmKRD4NjDdJC9cC6nbrkmrWIeP3IFaJ
	 nStTUcMsnzGrbqlQQ6HSNWlztcB/khy8+XL2jgc8iWvfGx+R2WwgY07L/skMG++aEOAQD
	 5IPMB70BxW9n8kDV4DShKDqXQAUoYkkNE0X9cXODsm0aNXnu3qrVAPN/ENUAYxBYt4FmK
	 mZvCrqD1cZIGxQfl8v0OsAkIBuhjWKRNsgWeVk0Zt9OHiS7ueEtaMhD5HvlXBz5lG/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=ovQpCv1Y;
	arc=none smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888D1606D80F
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 10:23:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 888D1606D80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=ovQpCv1Y
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-14fc585291cso524223c88.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 02:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793787815; x=1794392615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6V1X+zEwxVrSk2M8OWKn6u4m5FeW67/2ByAIN+CIG8E=;
        b=ovQpCv1Yd3F3Ez7FT7UDGlpuRK0xtieYSxdVD96HrhGiS6qRLcyx2Bhta1ndcosQGc
         b2054tLon11X4O+mTtNkQ/PgBpVe7Sd9RZkLi1Zuru5W4dQLoTvY9jc21B7pRt01A+7/
         Yvu6UkwehbDi/t5dOQ2wNxbcj5KIkUltMhFVeFPFXEV+zkVnOH6JAr3cjDj3fUe/oPy3
         ClVs+lW5pMJr5NGAncfXd9eqVFcARYZO8TWGHv2XAAKl6yFhEAQ2pbb/9e2mIBxNjmpP
         xBzZLfGcSCYM8A04icbRYdIVxdDPWqlMrgCZu4jW+SMd01lnXtPFt9GuMRCORNNoANDL
         NX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793787815; x=1794392615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6V1X+zEwxVrSk2M8OWKn6u4m5FeW67/2ByAIN+CIG8E=;
        b=BBV78oTyvQqCl8ipfGDbu0fYy5MFVI3F8IpkBWm1YUYmlCGIVX7eU/EQJmne85zASp
         hwEVrznSjJEdyDOcHliFYxjsQbq/7dDKgNWjjZbP8mPsv5ELHBofo7viR8pL9Echk+B2
         mQKHomUZgxX/6E7Hi6AtceBOIJcogF9F9tt/b9syZh52HsHBCY4om+cDZdYVx5YA4s27
         IWyopnPIF0WRhLqFCpgt8yTzunlF9pNA3rk4Uhy8T185HEgTaG90GeEr4AyGB7MnhOx5
         4+4iYmWKe4Jpk57rXjL7UYG8lAV86vQmSN15N1747Mt2AKU1cxVNkCjezbEgz7QgI1xJ
         LtKw==
X-Forwarded-Encrypted: i=1; AKwUvByT9501I5nlsfCjoaLQmOHkQ3CJYCoJVo3Qziv7v4a/+9FmzILwlBtr/M7aReClVBEy65ia003ZE1Se4w==@vger.kernel.org
X-Gm-Message-State: APuU4Z9t2ZK8jRHIoeWwmjJtUgP6Uxpe97vQytbWzUty27RwG6FCIenG
	ZnUl2f9mw5O7pe9iMrYwWPX6iHBkLIAE0F3U9l4gB6GVCCFp7GFICCVhlgli4OZfvA==
X-Gm-Gg: AYBFou0UXTOr3qEu60qTznVVrbK+Z11rvRXp79NaRFu8a/sA5AISaj/nGJUtEp7VPU6
	vH2QwTirdjGEYFb582FZ/C1qOq2vmNF/QJWnMux4SrCBT08T2ozpSvZmWhxx3T08Isc7K41Vpoc
	DM6QQcQgzZMoTDu5BeqWYIn/bI/z36egPiUWCsM5VdxbWNIjJOTZA4tr/M0AYT/CbO8UBmBTj6z
	2ZLzfMu3AELkikWem5fVLuHZE24P60tdWW92UpLYvZDa9r06JZsen73Zqk6knkV8f+OBCHljugg
	NBhxeRGX7bg9ltfO7I0ifs+cmU+uV8eSpaCZ7v5lfwYsw5VnpM9HwY3yRCDchj0cvHOSe2I8urC
	rjf9hSycxqk4HosvtFCOZ/Iow/CWnRsXI7JTxCWD1dYhj2J9IHg8zvBhd7tNSgQLIHjxEEj5TLQ
	txqsShiUDOoaIedKDNugilIRbVS7we9kf35yEKW3FkSx8EbdPL9m5p8hvm0qOthEoIDo6z9vWiU
	iC44fPzrXCcQ1ZFhQfDWZ8T5uScoHpXSByVU6UdPTIYlyT4McZZG8JUQUOlwEX5VD1PyrPwUGME
	IedecZFik1QHbr7NUZquhzheF0KTbGXuJGyfWahnLIU=
X-Received: by 2002:a05:701b:424a:20b0:148:302e:1bed with SMTP id a92af1059eb24-1ac5e8df484mr21795931c88.38.1793787814624;
        Wed, 04 Nov 2026 02:23:34 -0800 (PST)
Received: from localhost.localdomain ([2600:8800:1e00:25f0:ff01:97fc:f9e5:d7e1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a6160sm5749086eec.9.2026.11.04.02.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 02:23:34 -0800 (PST)
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
Subject: [PATCH 4/5] btrfs-progs: check: count non-skinny tree blocks in simple quotas
Date: Wed,  4 Nov 2026 03:23:22 -0700
Message-ID: <20261104102323.4090290-5-smish149@asu.edu>
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
On a filesystem without skinny-metadata, mkfs with simple quotas writes
a qgroup that does not count the tree block of the fs tree:

  $ mkfs.btrfs -O squota,^skinny-metadata $dev
  $ btrfs inspect-internal dump-tree -t quota $dev
	item 1 key (0 QGROUP_INFO 0/5) itemoff 16203 itemsize 40
		generation 11
		referenced 0 referenced_compressed 0
		^^^^^^^^^^^^
		exclusive 0 exclusive_compressed 0

The kernel then warns about a squota underflow when the block is freed,
and "btrfs check" reports no error, because it uses the same code.

[CAUSE]
simple_quota_account_extent() treats an extent as a tree block only if
its key is METADATA_ITEM. Without skinny-metadata a tree block is an
EXTENT_ITEM with the TREE_BLOCK flag, so it is handled like data: its
first inline ref is a TREE_BLOCK_REF, not an owner ref, and the block is
not counted. mkfs fills the qgroups with the same code.

[FIX]
Also treat an extent item with the TREE_BLOCK flag as a tree block, and
take its owner from the tree block header.

Fixes: 5bd97022f384 ("btrfs-progs: check: add support for squota")
Signed-off-by: Siddharth Mishra <smish149@asu.edu>
---
 check/qgroup-verify.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/check/qgroup-verify.c b/check/qgroup-verify.c
index b58ef366..d6681653 100644
--- a/check/qgroup-verify.c
+++ b/check/qgroup-verify.c
@@ -1046,8 +1046,9 @@ static int simple_quota_account_extent(struct btrfs_fs_info *info,
 	if (generation < counts.enable_gen)
 		return 0;
 
-	type = btrfs_extent_inline_ref_type(leaf, iref);
-	if (!meta_item) {
+	if (!meta_item &&
+	    !(btrfs_extent_flags(leaf, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK)) {
+		type = btrfs_extent_inline_ref_type(leaf, iref);
 		if (type == BTRFS_EXTENT_OWNER_REF_KEY) {
 			struct btrfs_extent_owner_ref *oref;
 
-- 
2.54.0

