Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787811;
	b=R7BAUeTYGlP9bolCSVVSsR2jRxUbBW3yorTyf7zI2dX+LRHyY/UqpystNkk7BsOX1qr3
	 0pglw5xzdVGhs7pshS4xxhuaRqJDCVmRtsmppt8qjUoCpjOz5fQFBGOPQ3faroIdaTP6S
	 7Xu1NBEgw2Vp1Eio9xXbWCBAeOEHFPbT9NnPPbAtmoGOd7OMOvJj/bRZbgfJV+0+Mt9nq
	 6MBHmDffNl1HKPohp6ddVwRiSwMKekGjbcpUZEZW0FFgv6naNsY1krlVxnYdhcyaG7xuU
	 J7RspHgjUXkpiRW1B2IAp+46oe4hcQ+LiWcxMYMc3DVTWs+h14RqkDuHHMaI4+Rq4kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787811;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=acEy7VuYeDIhb7gSnuNa7TFwjfE7RVQLbBXoX6cSqcM=;
	b=KbjSLFosSGletf4ojKr2suAV+UkEj8dui95IMymPsq+j1x9zXHpnPQd4fdM+/mvKrybJ
	 tl7UUIo06PcbnN4n3pstkz2L1x+I2+WkPKW9rY8+fMUdO2xI52JpXe2U2U6Sfm6cH7h5t
	 9nZKQVZ4Fj8rXzybSl9RdsDhjNX7mxDBVhQWDV6/KJZzLFr6fQ10G1JLDH1zqoDqi/2r4
	 9moc+XlOK1tkz36sB4uYOW64YnIbmwRx/+85q0BI1mFdxYtov7IcKJKdy2W2OZYD2d4H3
	 R0zI9txhfGQbaCVGjLhAeSaSSNgdJhX1Y1e/9ihKng5ohf3HAEzx1BcGbB7CaAC4+Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=LdrZ6f43;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52246606A32C
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 10:23:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52246606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=LdrZ6f43
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-33fb4680717so877717eec.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 02:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793787809; x=1794392609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=acEy7VuYeDIhb7gSnuNa7TFwjfE7RVQLbBXoX6cSqcM=;
        b=LdrZ6f434Y7pAnuag7QVLGn1cgp6UhyBf7/WFkjhMLKZABuk4jyPgytBF+1kVmPDSC
         ImcfaUVx5tO9pjE3p299SNdicSSqujd+Z1GvZuEVKQ1PAsmGjl01RMaoKm8ExSsQPppq
         TnVbiDpMhbD3frbExfnOwbYYkcua4NBpKoLy73ScevVqSVLqzpYlZkVck52n0RYmACWU
         /Orgntc1CUTCo1gyizly70SgkBQ/Rc9S4B6RzOJBTlEVrsQIQOBLX53Pv02rHsIfJhq4
         JRumfJtwcdPxWFKcN5Br2oQI7ZECknnaoSEjtq8X44e3RSk2U/61DFvg0Dj7PxbGhB3+
         1q6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793787809; x=1794392609;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=acEy7VuYeDIhb7gSnuNa7TFwjfE7RVQLbBXoX6cSqcM=;
        b=BSgMmcp9N5psaWnZ7in/rF0sjOc0K4hpaYPfixYwQ93gl1zvHlznp79QUomALw/w6u
         GfaJd//6Y4pHRL4E95mxCVH1jEktZtetfKC9hvNFeGJfBmNFFSak1yWW+D9TTUoKLvH+
         Y64X0/CjSoZ7TS2j3oMdX6TwgT9WnUnJ2Dr02MBuA4jtXUtmvBcTIhudlBsgmevU2TCq
         IlSD+0AYU88BR1N3d6tQGqU6SLlGBOumTnThmiE0IchsCl88jRv1rUdtOclJQcMM8UrZ
         pMpQqOGvWEBSzIzLMmPEQhPoE42PJQaro3eJ4JiA3zcZ3CkQzPPi1qWLv2Bh6Qj9EH56
         fyxA==
X-Forwarded-Encrypted: i=1; AKwUvBzIMqvCVKSX9OkSiAP3YhntfSRtPTRJ5Kl/AFEjchO3q97d1/qI8NG9O7+uDvSBGRwNx+eWTFjj8O0RNQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z8OR3BT2n+zGMRv7ottVcz85ZeTLQ2o0kNczf55yLsT31YHSRzx
	fO4hVpW2DnyBzb17L2g10RwfNHg7rw8dwJOCRbB21pyKuAJwbKWCsiHcPLYxFVMUhQ==
X-Gm-Gg: AYBFou1aQ31bS5dAVB5kRcLfW0jurCVniwlVH3IZHvZ1dGY7yZBka5ejWvpzgFNMXE2
	ucY0aDcOVYTyjGA+mr58fIBf0Z3bDWvrXIgQgZ9rGVo0rWUR+MtU9yy1Pp4Pf/+B+xwRTBKBIz3
	bJwLs7BCj8/xrzMmSNmzCm/MYOVtUGnXVxZkyZcU+OQyq7MZ6tugaro7h0rsorQNgKuFq8huprA
	aPzkoq86OVys17CPxiPNtgS8wrYnA4MTF/tkgg7PRMX4CTgA69RIWHKWV+lTqTdfyuN1yfOhndd
	8/u4Sd4Ac5jhjOTHeAZCpPPSUrACKRanSZURiv8og5dPo7ZktBGz31Bmey50Sh25/Gby7xf/Vkb
	kdfrdgVgsg+jBctX4gF5gM6iJuUxdCyPmSUzrlxc4hDGSZgleKcMjuHxWxZwpjWwKW/k4cQTH0c
	OieY5eoe4pg0dNUh63suCxuuInQd+wr92AVBcpE88Fu+vScIZD8W65wQSss4ZIzue0attiNNQeV
	dJQuhWMyNSVgpjmkRdc0vuo2XSXaqke3ZqhHmUvC0+VlItMOTbLD9m0B0dF6Q8iZOdZZ4pEctH+
	1u3q8+0NMkucwtF2uAbKtvvrIVn7Boxy3YMz58w+SQ==
X-Received: by 2002:a05:693c:41c6:20b0:368:c6b9:d3c0 with SMTP id 5a478bee46e88-36a423cfcd3mr24401465eec.28.1793787809167;
        Wed, 04 Nov 2026 02:23:29 -0800 (PST)
Received: from localhost.localdomain ([2600:8800:1e00:25f0:ff01:97fc:f9e5:d7e1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a6160sm5749086eec.9.2026.11.04.02.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 02:23:28 -0800 (PST)
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
Subject: [PATCH 0/5] btrfs: owner refs and tree blocks
Date: Wed,  4 Nov 2026 03:23:18 -0700
Message-ID: <20261104102323.4090290-1-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
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

Simple quotas store the owner of a data extent in an inline owner ref.
Tree blocks never get one: their owner is in the tree block header.

Patch 1 fixes btrfs_get_extent_owner_root(), which also looks for an
owner ref on tree blocks. On a filesystem without skinny-metadata it
reads the btrfs_tree_block_info as an inline ref and warns on subvolume
deletion, snapshot writes and balance. The filesystem is valid.

Patches 2 and 3 are hardening. The tree-checker rejects refs whose type
does not match the extent type: inline refs in patch 2 (for example an
owner ref on a tree block), and keyed refs in the same leaf as their
extent item in patch 3.

Patches 4 and 5 are for btrfs-progs (devel 3737c260) and have the same
cause: a tree block without skinny-metadata is taken for data. mkfs and
btrfs check do not count such tree blocks in simple quotas, and
btrfstune --remove-simple-quota can corrupt their extent items.

Found by fuzzing. An AI tool helped with the analysis and the patches.

Tested on btrfs for-next df5b88a7914e, KASAN and non-debug kernels:
- Patch 1: no warning on subvolume deletion, snapshot writes and
  metadata balance without skinny-metadata; same qgroup numbers.
- Patches 2 and 3: crafted images with an owner ref on a tree block,
  and with a keyed tree block ref on a data extent, are refused at
  read time instead of aborting a transaction later. No valid
  filesystem was rejected: skinny and non-skinny, 4K nodes, mixed block
  groups, no quota, qgroups and simple quotas, with reflinks, snapshots,
  balance and scrub, and filesystems from btrfs-convert, mkfs --rootdir
  and btrfstune -x.
- fstests btrfs/quick, and the qgroup, balance, snapshot and subvol
  groups with -O ^skinny-metadata: no new failure.
- Patches 4 and 5: mkfs -O squota,^skinny-metadata writes the right
  qgroup counts; btrfstune --remove-simple-quota leaves the tree blocks
  intact and btrfs check is clean (before: "backpointer mismatch").

The crafted images are available on request.

Siddharth Mishra (5):
  btrfs: skip tree blocks in btrfs_get_extent_owner_root()
  btrfs: tree-checker: reject inline refs not matching the extent type
  btrfs: tree-checker: reject keyed refs not matching the extent type
  btrfs-progs: check: count non-skinny tree blocks in simple quotas
  btrfs-progs: tune: do not remove owner refs from tree blocks

 fs/btrfs/extent-tree.c  |  3 +++
 fs/btrfs/tree-checker.c | 56 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 57 insertions(+), 2 deletions(-)

 check/qgroup-verify.c | 5 +++--
 tune/quota.c          | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)


base-commit: df5b88a7914e18488908ddf13e14e31ab39f954c
-- 
2.54.0

