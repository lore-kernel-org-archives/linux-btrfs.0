Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795610590;
	b=C/vd6otaaiuiqwyWYs5KMKGbhlvRcTPKDcNBxaUFZPzrfXcsnGs5jFTv90PfYqsbq4/3
	 1q1ld+SGVV+oGenxPdd0gSDTYANOH2f2mJvJ1iVwj3+uw9ifZ+D4BbijXIJtYmXONL44U
	 FN+Q2XY8nrLYNdm60K2JJ0kJroeGSKT3VOw43x2qC+Tm/JwPAI8AkYA+XY8b1iQay4eL5
	 twCGA4eVeXb15wIkdG5ewI4Avt/7gQW7WbTx58zKfxM1Iix/HsswtJPa/Kr1e/XJuYJUe
	 4IAi3mcqwXcndd5gEXQplcRh3t4O75nLHODNMHOdJ6EZogsOl4h1FNUHdeW9X2PGdFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795610590;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=d6fCVOF7hMI1+IVsik436SzmOa7YOc3Bgu6cq9sqNMI=;
	b=g7NSIV16h7Q6jbfJqEEg3TXNWroJG4hnuIdXjqdVIzjMU4dyphk7Y2VctKdFnhgl7ceV
	 RACr0tSztl/ebJ6o12ecympiShUaPzC4As1KA2NM0UUEUyuN8L3TRpV07rPXFnr+cU6DB
	 OpkMCBPSW/UYroKPsWO9wBXuGB+PyWhzAoJe5Y9kL1uEnuGZChCOYlvXTGKC9JnS8mJyu
	 KgKhJXsjiHL7GGVrJbfr3DFCcDyTs4p3JYsIpA/0sUJj8Ps7sqUMpCVoGab5mdMvypjLc
	 zOfzBp+pLqSPNCUobOLwN+beQL8rhoUowrfvtRpnplnqg631E96EW14m9qEZVm0v+oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="RTVO/vx5";
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861FF606A333
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 12:43:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 861FF606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RTVO/vx5
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so45965055e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 04:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795610589; x=1796215389; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d6fCVOF7hMI1+IVsik436SzmOa7YOc3Bgu6cq9sqNMI=;
        b=RTVO/vx5sQm5btcznk03xiHkafP+dF2Ufdt5/4GmbuP46fFOmXUFCOKHf56WB0APJe
         fegtsKTyAlH3v6s7ErHZhQDjLs/plVFMXvrZFkmw4FI7hjRVo5p1CknKvn23RBP6qglU
         AoQOdLwMlj3AhjzH/9dCW4nc+xgOeRXUX5pN9/jEyejly9U4OCCnb6bV1/f0kbRt/zfB
         JUnwGT+MQRUhiSkHEn1sgxhdrmTheXInfXuux2x66LXTR4oupdYfhzxKENqI9+Ft+gZQ
         27bw8bGOw0b750OpXSLzzZCkt7F8SuSX/EuxpuXpGQTnFJXYeQAGQm4/lv8vZyUbvxWL
         tLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795610589; x=1796215389;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d6fCVOF7hMI1+IVsik436SzmOa7YOc3Bgu6cq9sqNMI=;
        b=yhYzrdpuBdArQvDspJVCEfaIZl9AM5CaA43TxFq6fxH9YINZa9oMH34F7wbBeMZZMI
         75RuboOH/fqUVYUHmFlbOFccKqnaCaQIg5YuTf1mz4lCutYWFvHc93x1UWTrbxSkbi9g
         tChy+ppRt/tq7UYPFaniUl21UfCkM+u2ej6nbl13VzCjkQeMFdpM8PFIR0lT42P+8mjE
         S16SM/LtO/1/oLqN/Ne4+vi3T/4wr1VI2Lak/SxP+ba0piBoS5qcQv+bhvrETfXtwNCy
         SpSdl/FPMVP+6IFcoG7pK05IHQrxjaM5v/x5uriuIqYxU47Dcb2CXxCeCTkacBLPVxRx
         iqjw==
X-Forwarded-Encrypted: i=1; AL+hErEYAzGkTGaaj1SmnJ/qvSbiP9tbqfeJJovEh55u2vVFETXlCGgrKwgyx5QF5j5c/5vu1xtlIG+qxI4Mng==@vger.kernel.org
X-Gm-Message-State: APuU4Z8vBfGi8V8IzKUCa/i28fCYllzhAjA6qkULkT4WJTU3vi/bo46s
	HPpKL7PXQ0aImMu7IUaXTM0BPFUuwZAsGnVYF4hGPlWBUdC2Tof/nYjx
X-Gm-Gg: AZFdTZfNECsjRh7JnXzE7rBTI8MFhB9mKdvbb8SwWHi77cZVPjw1MhBvfTeU8XO/tb0
	R3L5TSVmfSxp025fXW7Z+3SNelD+k1zi159ZR5qtB1jq+DnL5cAYcS+7c/TvqzN7gFZ7GHkFyEF
	VfK5A/uD0JBL0dIUFaOmMKZHQSg0U8cHlqPh6HptjSLMo063oLAFvAb+k1/n2I3GdxXy/aGjvu+
	jOcXAVIBC898WT4/B70NSZmihvFXzeVJWpfCP9auHj1zGatqvpvmPyQ9GsNG9XDxk9raa3pAalx
	dNWyMdVndsgJxE8DAjeFqs7OGnc8vYkjlymQHvCB2KRNuSY3zX1YfD8Yo68WxEjjjbHzFEB9awS
	Y82DrCEnxhMme9scc6SamJlwY0F+1xTE00MdsrqQFB53Y591XwCGAQhIJbyTyP5dLpMVQ6GoA25
	7O1yDtj0rkMOOWxKJrAy+qQCkkx/7KONSSJqpb0+ssY4bxzsVK8rmpuQ5+2fW5bS5NqVf4F8Xrg
	Ts36Km8j07UMJVs1MUId/xUwgdy+x+zTWZ5cpur0R/V1m59W26Xf/XPQd7FhWSf5CNKGhYqnc/V
	dUaltu7cBKsUyavconezXIFg6KLuo/YO9duv05QyTC1YiaQRwissnniLRezofVAtUDU4qQsyNK3
	YSuC/7oozHiigMf/necXziMObY91fKuNYPu+tUx/fML/h+MUvdItf8GXiO0L3anSOJ8Hjncyo+X
	s6nLIu2pTpKdx4sIAfEZeEil4vIVFAizOIFSJK1qOKO5xvrbnkt64Rhw==
X-Received: by 2002:a05:600c:848d:b0:4a4:3a2d:15da with SMTP id 5b1f17b1804b1-4bb88812026mr337511905e9.15.1795610588798;
        Wed, 25 Nov 2026 04:43:08 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-7575-e1e3-dbaf-96fb.ipv6.o2.cz. [2a00:1028:8388:a84e:7575:e1e3:dbaf:96fb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88442995sm536486045e9.2.2026.11.25.04.43.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Nov 2026 04:43:08 -0800 (PST)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: u-boot@lists.u-boot-project.org
Cc: Tom Rini <trini@konsulko.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Bradley Morgan <bradley.morgan@linux.dev>,
	linux-btrfs@vger.kernel.org,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH 6/6] fs: btrfs: Avoid the remaining 64-bit divisions
Date: Wed, 25 Nov 2026 13:42:59 +0100
Message-ID: <20261125124259.95636-7-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
References: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 32-bit PowerPC, GCC turns the u64 divisions in btrfs_stripe_length()
and in the RAID5/6 code of __btrfs_map_block() into calls to
__udivdi3(), which U-Boot's private libgcc does not provide.
calc_stripe_length() has the same divisions.

U-Boot never runs these divisions. btrfs_stripe_length() and
calc_stripe_length() have no caller, and the RAID5/6 divisions sit in
the branch that fills a raid map, which needs a raid_map_ret. Both
callers of btrfs_map_block() set it to NULL. Builds of turris_1x_nor
and turris_1x_sdcard still link that branch, and with it __udivdi3().

Use div_u64(). Its divisors fit into 32 bits: num_stripes is a u32 or
an int and stripe_len is an int. full_stripe_len is the product of two
ints, so declare it as a u32.

linux/math64.h pulls in linux/log2.h, whose is_power_of_2() conflicts
with the copy in compat.h, which returns int instead of bool. Include
linux/log2.h in compat.h and drop the copy.

Suggested-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Cc: Marek Behún <kabel@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Tom Rini <trini@konsulko.com>
---
 fs/btrfs/compat.h  |  6 +-----
 fs/btrfs/volumes.c | 19 +++++++++++--------
 fs/btrfs/volumes.h |  9 +++++----
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/compat.h b/fs/btrfs/compat.h
index e6784884835..f973f3f1185 100644
--- a/fs/btrfs/compat.h
+++ b/fs/btrfs/compat.h
@@ -4,6 +4,7 @@
 #define __BTRFS_COMPAT_H__
 
 #include <linux/errno.h>
+#include <linux/log2.h>
 #include <fs_internal.h>
 #include <u-boot/uuid.h>
 
@@ -74,9 +75,4 @@ static inline void uuid_unparse(const u8 *uuid, char *out)
 	return uuid_bin_to_str((unsigned char *)uuid, out, 0);
 }
 
-static inline int is_power_of_2(unsigned long n)
-{
-	return (n != 0 && ((n & (n - 1)) == 0));
-}
-
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 71b0b55b9c6..fcb20a761f5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2,6 +2,7 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <fs_internal.h>
+#include <linux/math64.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "volumes.h"
@@ -825,17 +826,17 @@ u64 btrfs_stripe_length(struct btrfs_fs_info *fs_info,
 		stripe_len = chunk_len;
 		break;
 	case BTRFS_BLOCK_GROUP_RAID0:
-		stripe_len = chunk_len / num_stripes;
+		stripe_len = div_u64(chunk_len, num_stripes);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID5:
-		stripe_len = chunk_len / (num_stripes - 1);
+		stripe_len = div_u64(chunk_len, num_stripes - 1);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID6:
-		stripe_len = chunk_len / (num_stripes - 2);
+		stripe_len = div_u64(chunk_len, num_stripes - 2);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID10:
-		stripe_len = chunk_len / (num_stripes /
-				btrfs_chunk_sub_stripes(leaf, chunk));
+		stripe_len = div_u64(chunk_len, num_stripes /
+				     btrfs_chunk_sub_stripes(leaf, chunk));
 		break;
 	default:
 		/* Invalid chunk profile found */
@@ -1085,17 +1086,19 @@ again:
 			int rot;
 			u64 tmp;
 			u64 raid56_full_stripe_start;
-			u64 full_stripe_len = nr_data_stripes(map) * map->stripe_len;
+			u32 full_stripe_len = nr_data_stripes(map) * map->stripe_len;
 
 			/*
 			 * align the start of our data stripe in the logical
 			 * address space
 			 */
-			raid56_full_stripe_start = offset / full_stripe_len;
+			raid56_full_stripe_start = div_u64(offset,
+							   full_stripe_len);
 			raid56_full_stripe_start *= full_stripe_len;
 
 			/* get the data stripe number */
-			stripe_nr = raid56_full_stripe_start / map->stripe_len;
+			stripe_nr = div_u64(raid56_full_stripe_start,
+					    map->stripe_len);
 			stripe_nr = stripe_nr / nr_data_stripes(map);
 
 			/* Work out the disk rotation on this stripe-set */
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 9d1a07ae789..d66547c6c10 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -4,6 +4,7 @@
 #define __BTRFS_VOLUMES_H__
 
 #include <fs_internal.h>
+#include <linux/math64.h>
 #include "ctree.h"
 
 #define BTRFS_STRIPE_LEN	SZ_64K
@@ -138,16 +139,16 @@ static inline u64 calc_stripe_length(u64 type, u64 length, int num_stripes)
 
 	if (type & BTRFS_BLOCK_GROUP_RAID0) {
 		stripe_size = length;
-		stripe_size /= num_stripes;
+		stripe_size = div_u64(stripe_size, num_stripes);
 	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
 		stripe_size = length * 2;
-		stripe_size /= num_stripes;
+		stripe_size = div_u64(stripe_size, num_stripes);
 	} else if (type & BTRFS_BLOCK_GROUP_RAID5) {
 		stripe_size = length;
-		stripe_size /= (num_stripes - 1);
+		stripe_size = div_u64(stripe_size, num_stripes - 1);
 	} else if (type & BTRFS_BLOCK_GROUP_RAID6) {
 		stripe_size = length;
-		stripe_size /= (num_stripes - 2);
+		stripe_size = div_u64(stripe_size, num_stripes - 2);
 	} else {
 		stripe_size = length;
 	}
-- 
2.54.0 (Apple Git-157)

