Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793986391;
	b=XwQfQpA6zUqV5MVApJAF0hB+fxOmG25Mb10RzUxacb7gipaLpXOALrAzw8CNSt5T7YoD
	 s4E9MAQknEmg6gK/IgAWBl9+qo+PvqdTgYM8HVpa9ZibS8HS2u2XvJzGf2WGrr/atMj92
	 /qmzaFScxwGiV7FFQH3N5duNHWCI1mLfaizJsdO1WtzV5a7XH+bEMobipo7dire36IXCo
	 VZRrDAJMHho2b5Bfv0td/z3ogpyd9EAQAy0HEappT8OSjYQZyseBybDuGPTpnxreoKlbT
	 T1B4E2mGAim9X6h4lNV9nIQEGRmwlh7FrmIiIv7RBIY/yKiTLXgmQl3T9hTq1P4KbEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793986391;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=f6/e8VRVGwq2IlIPmlekJ8IIyNAHIg5L1MoTIGgVYmw=;
	b=ta0wfzdJvmKBBl66qBvsC0jiV5ySLv9BZIRLj7SiW1dKFvHzK6jFE3XLtvQw3DKdx240
	 2lURihrnQqSaF3imD3c68GiTooGbvLOv77D2zwqRBskhEZ69YYYm44vH5tukH/OKGlP4n
	 86BSAyCwd2ZXJac+yLgbEwKAV1ed7AJ8gIE4nK9YioY8E1vrJdHvBGB9RG6ck/109/y53
	 ljgovVeKIw44Yk7c4C1Y2hdBA2fPvrVzS3tDVdmNXo9UXTV6gSr++vSglZR0NOO5pIfNB
	 IMhuhORj7WNSiMmvrnkKB/TdUMapa6l0NroG5OrrhDilzL/WTFVAgMFquBWBm26qFcQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="RCSx/Fr5";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781B2606A32E;
	Fri,  6 Nov 2026 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RCSx/Fr5
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793986391;
	b=wYHe/ovvC32HFpTiP2RUq6RBoWnDfwP8qqYgp+bUcydN0S44OMD6Uc6aZMkF13dyfmuH
	 /04fXjwtwFLGLRCag7GMYw+L8x+J5GKtfrFIp9oRT2CnfOfs6nSTiDWIt1FlonYv/DyJL
	 nxSbrAJmWlrBbeSwh4supdFfTQh1AhJqGKbnJbKbQvnXvIrKb5p+mNhGBy/XD6wQWYDiT
	 PTq8p6exWHUph+4cP8ja1vcYvzJwhRaSARlECJMSURdm2XDnqVafBPd5KOYUcswh36a6s
	 Tyv7R3G0/8a6Q9jLilOCLi6O31MaN4HNudMRt4IAhxTVLlBhw/WQn+NFCKFFa5WLK4w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793986391;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=f6/e8VRVGwq2IlIPmlekJ8IIyNAHIg5L1MoTIGgVYmw=;
	b=O5XSSzRnxErQfqk0TYFhNyWo9De1FRUFkPkj0XIlXrDwlT4fCFQMfJDNY6q4Ivi8/7bO
	 TFXYNPkpugvZtYhkqc6FzaXMFn09PEmT8zVmybUfSyRZZHndOEWvpaGNYbwA1ljYEOKVM
	 vwRRphR0uEfIC6gb5pIwInBXoclAw/rhfIVxy32KQEeZQPIx6Xarc3TCMVJk2d1GhZ4k/
	 /AILrt5WmpAxhX0ihTRiasWICX1Eo7cvzFupR9eUV8p2NPIT+f/4RE/hu/HpSqnTeiKFo
	 2RV+vQ/wXy2Nqv93utp0AMu0cAHbLGi/Qkh3cSpGXUrNoIbON54V76VG0Ig60Rci8IQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 369441F008A1;
	Fri,  6 Nov 2026 17:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793986391;
	bh=f6/e8VRVGwq2IlIPmlekJ8IIyNAHIg5L1MoTIGgVYmw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=RCSx/Fr5BD6F7NLM1hkBF2XtIsIj1VBm8exW0vWlgJ/5eIfLHjXui2jrmD/a1GBzL
	 r7BipHizmQVS33Vm/5zU2g1GsqezpUaZmQvr6XPZUAlw6eriBt7Qr8sSYq2ZsPqsXU
	 rLU0Yeg2cPiqxE/ybWqgPOJ/gG8W5Q4Xg7NBahrPfUGGrXI1u1cjLNA5Uq4EIeNUKC
	 VwoMiJZlhxk+PjSqXXdgAPNhBVmyEmwwX8M1SIHBJQPb9WJZ8JxL51RXx6Bc4vsw5a
	 HgMsj2CKQWkhWuxVH071bWIgymOpbefHClQsMgWI6aDpwvQVxd+E8ZkwI+ZmAJ4TyX
	 IyelIFo2POkxQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id AE10145E19;
	Fri,  6 Nov 2026 17:33:09 +0000 (UTC)
From: Mark Korenberg via B4 Relay <devnull+socketpair.gmail.com@kernel.org>
Date: Fri, 06 Nov 2026 22:33:10 +0500
Subject: [PATCH v2 2/2] btrfs: raid56: pass REQ_META to per-device bios
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
Message-Id: <20261106-btrfs-sb-read-req-meta-v2-2-71c1afaf5c67@gmail.com>
References: <20261106-btrfs-sb-read-req-meta-v2-0-71c1afaf5c67@gmail.com>
In-Reply-To: <20261106-btrfs-sb-read-req-meta-v2-0-71c1afaf5c67@gmail.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Korenberg <socketpair@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793986388; l=2479;
 i=socketpair@gmail.com; s=20260603; h=from:subject:message-id;
 bh=03ZVHtjUEaKbOwy9y4lTSzoDh3nzlMUykXCapQogZXk=;
 b=lmkNKMF54ONzD8K3N1HX3MJFukSl6LQyyWTdJUAgRTxEkpZZkvKHFAymIAOODq1p9zMpYKpWB
 faiV3VpR9eHCr+P2H3pNfdOuqPsTYy4f1RgYMZR5ucHFxZPmrLP+JVP
X-Developer-Key: i=socketpair@gmail.com; a=ed25519;
 pk=2iAMjWhs7kA9X8ccetT2YVX8dvniXua2okQogw3Don8=
X-Endpoint-Received: by B4 Relay for socketpair@gmail.com/20260603 with
 auth_id=806
X-Original-From: Mark Korenberg <socketpair@gmail.com>
Reply-To: socketpair@gmail.com
Content-Transfer-Encoding: 7bit

From: Mark Korenberg <socketpair@gmail.com>

RAID5/6 writes, and reads that need a rebuild, go through an rbio,
which builds new per-device bios from a bare REQ_OP_READ or
REQ_OP_WRITE.  So all tree block writes on RAID5/6 lose REQ_META, while
on the other profiles the per-device bios are clones and keep it.  The
same goes for a tree block read rebuilt from the other stripes, for
example with a missing device.

Pass REQ_META on to all per-device bios of an rbio, data and P/Q alike,
if any bio it serves has it.  Scrub and relocation do not set REQ_META,
so their rbios stay untagged, as do rbios that only serve file data.

Signed-off-by: Mark Korenberg <socketpair@gmail.com>
---
 fs/btrfs/raid56.c | 14 +++++++++++---
 fs/btrfs/raid56.h |  7 +++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index a8a8004bb14c..63b5acbf107e 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1202,10 +1202,15 @@ static int rbio_add_io_paddrs(struct btrfs_raid_bio *rbio, struct bio_list *bio_
 		}
 	}
 
-	/* put a new bio on the list */
+	/*
+	 * Put a new bio on the list.  Every per-device bio, data and P/Q
+	 * alike, serves the bios in rbio->bio_list, so it is metadata I/O if
+	 * any of them is: a tree block write, or a tree block read rebuilt
+	 * from the other stripes.
+	 */
 	bio = bio_alloc(stripe->dev->bdev,
 			max(rbio->bioc->stripe_len >> PAGE_SHIFT, 1),
-			op, GFP_NOFS);
+			op | rbio->req_meta, GFP_NOFS);
 	bio->bi_iter.bi_sector = disk_start >> SECTOR_SHIFT;
 	bio->bi_private = rbio;
 
@@ -1246,8 +1251,11 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
 	struct bio *bio;
 
 	spin_lock(&rbio->bio_list_lock);
-	bio_list_for_each(bio, &rbio->bio_list)
+	rbio->req_meta = 0;
+	bio_list_for_each(bio, &rbio->bio_list) {
 		index_one_bio(rbio, bio);
+		rbio->req_meta |= bio->bi_opf & REQ_META;
+	}
 
 	spin_unlock(&rbio->bio_list_lock);
 }
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 8700910b8dc9..a5a0ff8e4a03 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -139,6 +139,13 @@ struct btrfs_raid_bio {
 	 */
 	enum btrfs_rbio_ops operation;
 
+	/*
+	 * REQ_META if any bio in bio_list has it.  Set under bio_list_lock by
+	 * index_rbio_pages(), which runs before every assembly of per-device
+	 * bios.
+	 */
+	blk_opf_t req_meta;
+
 	/* How many pages there are for the full stripe including P/Q */
 	u16 nr_pages;
 

-- 
2.56.0


