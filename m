Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0266634CFCA;
	Sun, 30 Aug 2026 10:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.242.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788086328; cv=none; b=qnTl1zE/qKOXBPxcUYCo8yGzy0x65x2ACuL4EKtCn2vorz5v6AGQsGSDbGDN3XHySdcj/sb5DdqppCRd7Fu8KUTLeWWJpmtll8DfL9QJpceLLP/bRbH8gZjsYJGILh42qj8/FYf+FMmL1NMhSggL5RO/MzQ8K0frStnwRacudhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788086328; c=relaxed/simple;
	bh=3kY1dBWeCgwwn55xI3/xDSegyE80N73ZTxbg/1MQ3/o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VvpYNG/2NqI3xyjHquFk7Z3S/ZEtgrhrvI6tuT9bzkVl+lkUze8xZphpgvgkuwWDzypdKjJ52iFp6WqRDkE/lMXTUJZPZbP7tKJXyddSN4CzPWXgUJdm0MHidIprA3BJ9Ed3wWJoXZ9jXAjN3B7++XtWNrOO1SGzu2hzBxWiFrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net; spf=pass smtp.mailfrom=davidgow.net; arc=none smtp.client-ip=203.29.242.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id D2CFD1EAAE6; Sun, 30 Aug 2026 18:33:35 +0800 (AWST)
X-Spam-Level: 
Received: from sparky.lan (unknown [IPv6:2001:8003:8802:7000::9c4])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id ACBF81EAAE6;
	Sun, 30 Aug 2026 18:33:30 +0800 (AWST)
From: David Gow <david@davidgow.net>
To: Jim Cromie <jim.cromie@gmail.com>,
	"Maciej W . Rozycki" <macro@orcam.me.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Auld <matthew.auld@intel.com>,
	Arun Pravin <arunpravin.paneerselvam@amd.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Chris Mason <mason@kernel.org>,
	David Sterba <dsterba@suse.com>
Cc: David Gow <david@davidgow.net>,
	dri-devel@lists.freedesktop.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] linux/log2.h: Add 64-bit safe variants of power-of-two functions
Date: Sun, 30 Aug 2026 18:33:15 +0800
Message-ID: <20260830103321.2042968-1-david@davidgow.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing roundup_pow_of_two() and rounddown_pow_of_two() functions work
on values of type unsigned long, which is 32-bit on 32-bit systems.
Equally, is_power_of_2() operates on an unsigned long.

There are several instances where 64-bit safe versions of these (which
operate on a 64-bit value regardless of sizeof(long)) are required. Most
particularly, some hardware (especially GPUs) have 64-bit address spaces,
and some formats (such as filesystems) use 64-bit offsets. Some of these
(such as i915 and btrfs) have already implemented their own 64-bit
is_power_of_2() helpers.

Add a version of these which always operate on a 64-bit value. These have
the (unimaginative) names:
- is_power_of_2_u64()
- roundup_pow_of_two_u64(), and
- rounddown_pow_of_two_u64()
and otherwise work identically to their unsigned long counterparts.

To avoid conflicts, the i915 implementation is also removed here. The btrfs
one (which has a different name) is replaced in a separate patch.

Signed-off-by: David Gow <david@davidgow.net>
---

This patch adds u64 helpers, and the following two use them. And v2 also
has the i915 change to remove the conflicting implementation.

So I'm not sure who best wants to take these. Ultimately it's an include/linux
change, but it touches i915, patch 2 touches GPU/DRM, and patch 3 btrfs.
Personally, I'm keen to get patch 2 in, as it fixes a real issue, so if taking
1 and 2 via DRM makes more sense, that's fine by me.

Changes since v1:
https://lore.kernel.org/all/20260821091918.1902032-1-david@ingeniumdigital.com/
- Include is_power_of_2_u64() as well, and remove the i915 version
  (Thanks, Matthew)
- Use _u64 as a suffix for the 64-bit versions, not just 64
  (This is a much nicer name, and matches what everone else was doing)
- Fix some comment typos.
- Add a third patch which removes a similar is_power_of_two_u64() helper
  from btrfs.

---
 drivers/gpu/drm/i915/i915_utils.h |  5 ---
 include/linux/log2.h              | 73 +++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
index ecc20e0528f4..1cec51984d8c 100644
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -75,11 +75,6 @@ struct drm_i915_private;
 	__idx;								\
 })
 
-static inline bool is_power_of_2_u64(u64 n)
-{
-	return (n != 0 && ((n & (n - 1)) == 0));
-}
-
 void add_taint_for_CI(struct drm_i915_private *i915, unsigned int taint);
 static inline void __add_taint_for_CI(unsigned int taint)
 {
diff --git a/include/linux/log2.h b/include/linux/log2.h
index e17ceb32e0c9..fc44e59f5732 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -47,6 +47,22 @@ bool is_power_of_2(unsigned long n)
 	return n - 1 < (n ^ (n - 1));
 }
 
+/**
+ * is_power_of_2_u64() - check if a 64-bit value is a power of two
+ * @n: the value to check
+ *
+ * Determine whether some value is a power of two, where zero is
+ * *not* considered a power of two. Unlike is_power_of_2, this version
+ * always operates on 64-bit values, even on 32-bit architectures where
+ * long is 32-bit.
+ * Return: true if @n is a power of 2, otherwise false.
+ */
+static __always_inline __attribute_const__
+bool is_power_of_2_u64(u64 n)
+{
+	return n - 1 < (n ^ (n - 1));
+}
+
 /**
  * __roundup_pow_of_two() - round up to nearest power of two
  * @n: value to round up
@@ -195,6 +211,63 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
 	__rounddown_pow_of_two(n)		\
  )
 
+/**
+ * __rounddown_pow_of_two_64() - round a 64-bit value down to nearest power of two
+ * @n: value to round down
+ */
+static inline __attribute_const__
+u64 __rounddown_pow_of_two_u64(u64 n)
+{
+	return 1ULL << ilog2(n);
+}
+
+/**
+ * rounddown_pow_of_two_u64 - round a 64-bit value down to nearest power of two
+ * @n: parameter
+ *
+ * round the given value down to the nearest power of two
+ * - this always operates on 64-bit values, even on 32-bit systems
+ * - the result is undefined when n == 0
+ * - this can be used to initialise global variables from constant data
+ */
+#define rounddown_pow_of_two_u64(n)		\
+(						\
+	__builtin_constant_p(n) ? (		\
+		((n) == 1) ? 1ULL :		\
+		(1ULL << ilog2((n)))		\
+				   ) :		\
+	__rounddown_pow_of_two_u64(n)		\
+)
+
+
+/**
+ * __roundup_pow_of_two_u64() - round a 64-bit value up to nearest power of two
+ * @n: value to round up
+ */
+static inline __attribute_const__
+u64 __roundup_pow_of_two_u64(u64 n)
+{
+	return 1ULL << (ilog2(n - 1) + 1);
+}
+
+/**
+ * roundup_pow_of_two_u64 - round a 64-bit value up to nearest power of two
+ * @n: parameter
+ *
+ * round the given value up to the nearest power of two
+ * - this always operates on 64-bit values, even on 32-bit systems
+ * - the result is undefined when n == 0
+ * - this can be used to initialise global variables from constant data
+ */
+#define roundup_pow_of_two_u64(n)		\
+(						\
+	__builtin_constant_p(n) ? (		\
+		((n) == 1) ? 1ULL :		\
+		(1ULL << (ilog2((n) - 1) + 1))	\
+				   ) :		\
+	__roundup_pow_of_two_u64(n)		\
+)
+
 static inline __attribute_const__
 int __order_base_2(unsigned long n)
 {
-- 
2.55.0

