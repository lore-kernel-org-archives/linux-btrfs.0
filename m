Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64162609E3
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 14:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776523098; cv=none; b=ad61x/DFkjA7lLk4h2GH+cQz8GrOnWHD1SBCfcxGElzHsJTC1vUeoxfS47zCpcowbjRGbUO3boV0ZwHEaWRlpBMn5iIW8xOVlS+5uUiTOmdusyM7x9FfDNlvupmm38hJ6o3ryCpL+evPYqryXkcr2JX/O6Mhegit+NU+68WFZCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776523098; c=relaxed/simple;
	bh=p9DnI22GDRN4QccD87VqwOj8oRUrLgHHBOa/JAzk+98=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kyI/qKnRWhQt+TlfOVNRb7nxMZv016Qnn41v+7bipwwFD7h7G76hWQLn+4VrmwIWTxXvTpCPSr/zRjwrfKfcWp4j6b7YmpK6tdYpaO1pcGksbTErzHMtO38XuxnYbwJ7eaQp2tmhTCu9E/frPAVYZnvZZhvVyU4zEauROUp7Lbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SdoWX5bX; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SdoWX5bX"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso13876275e9.3
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 07:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776523095; x=1777127895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7nboMJM3Fb3YlBzMB4MoG6uu+OnAbiyWJjlxHC15pgk=;
        b=SdoWX5bXHDT4XwjnkPS0GGBwaCDDVya7LuC61Fq4OOyS3ltMbH0Se6wJq5uGsBI5uc
         1o93Pu0GA1lnknrp235P8bbHkaWqg+tecC1QjlwLAH1cXaQud64ZE81CUYe2/V5D8RbI
         CjdQV8uWfIEmlMHgsQq1CWi2dE3J7xzMJ3flpRTkFycMko395pv+rJJh9mTw99MmnCuk
         jKpP+MdaH3VupoqMONADo5BftpaSRX/mz7VqsCjdc9qGEG9hpjoAh2VLyatIrQ2BVg3e
         wlI0pBv0F4wQgChDf5/X7erdjY9TjxPeycV2BjXFIcm/r6KJP2i6B5Y8hf0Gdvlybmx5
         NZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776523095; x=1777127895;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7nboMJM3Fb3YlBzMB4MoG6uu+OnAbiyWJjlxHC15pgk=;
        b=SNyiUGIlwXfvWbKHOHSR66x7q0l6ByMpeFK8VSFi/epPhkvo6QMGV8w9KqafqpbcIU
         /ZLNuuIXM+wflhODrazP7SRVXcMTF5cFkVDYAqzT+pZe9IUUcFDMD0figFGfqXgnj0XV
         3wKfD8mOgk6LTJrnQjgHIuKgNq48BRIZwMPAbAaYytywUx/+nMEKPNlgb4uAnP1oAME+
         PMMAScUpWVnV9olf7BJUJlaH/TtQUEksCqKIWExo31iE3eJ3ro9YkQs6svJFT9K6CfTL
         bjpS+soWMJuO0isD76zv18dfvTmJ6ligfQRCmndOu7a7AsWiHbnfykz0TisfjUBfNG0X
         5dSQ==
X-Gm-Message-State: AOJu0YwCovtIRGWI22E3R93IyFEYFjmkbaf+rXHcLw3+56HB4TZOPurn
	aHnq+9I/0WoaQUDxpeaw5qENUyZQ7fxPvVQdgf1NpFoobibua5+AyR6CJQES+PK6
X-Gm-Gg: AeBDiesYeYy+ErIluKoci7bAJL1AUwPkS/ETC/MQv5zvsJPIQx/VIcsf7E4tSUFZasq
	MiVVqSPRGf/ugkwmoEGcAbN+kfkErfyRqODH7DJZJvnQveEidEXw2BFgceqcB6416pnmkv6bMxb
	IxC2EvkDFHastc+LetJ9BvfGMOs6YlWYaBvZxB3mrjnoDqA1+mB8KbtlDOvXMWC3JGPjUBlBEwW
	MFmW++69KOILa2rE22gr1ffIC6xNpRNls6nX1MlZyESCdztVFhQFpMMqqd/02KQUfeOfU4qaEAs
	dReTI+Uoxs3/LiWHtihuo5TqEmecYmXopHTr1JXgNdTZHlUXdKsf/AeXds8xYtpPASGt8aDyr5C
	Uw4MsENKiDllEB6sRc28hOdsWC2TITGpKZngFtAa9eG//pLFJodmOP1itG6W7EdU7PKF61rUlDj
	rHg5aNhm3KlU1300/fBJ289HN5ADbNHWqNXwSq0JsyEwNhddKgwjLM5ePONLRrtroVOXaxGm68h
	2bA09Z8PQ+lbKDj81QpUOGlPaZnJ/lWJoEUwZc=
X-Received: by 2002:a05:600c:890b:b0:488:a977:8d6 with SMTP id 5b1f17b1804b1-488fb775a35mr68237705e9.19.1776523094551;
        Sat, 18 Apr 2026 07:38:14 -0700 (PDT)
Received: from len.tail8322.ts.net (sgyl-44-b2-v4wan-166595-cust701.vm6.cable.virginm.net. [77.97.226.190])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a397sm14509303f8f.23.2026.04.18.07.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 07:38:13 -0700 (PDT)
From: Paul Richards <paul.richards@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	Paul Richards <paul.richards@gmail.com>
Subject: [RFC PATCH 0/3] btrfs: implement FALLOC_FL_COLLAPSE_RANGE and FALLOC_FL_INSERT_RANGE
Date: Sat, 18 Apr 2026 15:38:05 +0100
Message-ID: <20260418143808.199603-1-paul.richards@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for FALLOC_FL_COLLAPSE_RANGE and
FALLOC_FL_INSERT_RANGE to btrfs_fallocate(). Both operations are
already supported by ext4 and xfs. The userspace contract is
documented in fallocate(2).

Patch 1 refactors btrfs_fallocate() to dispatch via a switch statement,
moving punch_hole into its own function and decoupling locking from the
per-operation helpers. This is similar to the implementaitons for ext4
and xfs. The allocate-range and zero-range paths remain coupled since
they share some setup logic.

Patches 2 and 3 add COLLAPSE_RANGE and INSERT_RANGE respectively.

== Implementation approach ==

For COLLAPSE_RANGE:
 - The removed region [offset, offset+len) is punched out via
   btrfs_replace_file_extents(), which handles boundary splitting.
 - All EXTENT_DATA keys with key.offset >= offset+len are shifted
   leftward by len in forward order.

For INSERT_RANGE:
 - All EXTENT_DATA keys with key.offset >= offset are shifted rightward
   by len in reverse order (required to avoid key collisions).
 - No pre-splitting of straddling extents is needed: the left portion
   of a straddling extent stays in place, the right portion is shifted;
   both reference the same physical extent via their existing
   extent_offset fields.

For each shifted key, the corresponding back-reference in the extent
tree is updated via a shared helper btrfs_shift_extent_backref().

After the key-shift loop, btrfs_drop_extent_map_range() is called to
invalidate the in-memory extent map cache. This is important for reads
after the fallocate operation to ensure they obtain data for the new
offsets.

The page cache is flushed and invalidated upfront (before any extent
manipulation) following the ext4/xfs pattern. The inode lock
(BTRFS_ILOCK_MMAP) is held throughout, preventing new dirty pages from
appearing during the operation.

Transaction cycling: the key-shift loop cycles transactions every
BTRFS_INSERT_COLLAPSE_TRANSACTION_CYCLE_INTERVAL (32) items to avoid
holding a single transaction open across a large number of extents.

Both operations are gated on CONFIG_BTRFS_EXPERIMENTAL.

== Known limitations ==

INSERT_RANGE returns -EOPNOTSUPP for inlined files. Supporting inline
files will require promoting the existing inline extent to a regular
one, since inline extends are supported only at the very start of a
file.

In the opposite direction, COLLAPSE_RANGE will not create inline files
like it should if the remaining data is small enough.

I intend to address both of these limitations.

== Testing ==

Tested with a Rust-based functional test suite covering:
 - Collapse and insert at the start, middle of a file
 - Multiple sequential operations on the same file
 - Files with multiple extents (fsync between writes to force separate
   extent items)
 - Files with holes (explicit punch_hole and implicit sparse writes)
 - Compressed extents (mount -o compress=zstd)
 - Transaction cycling (interval reduced to 4 during testing, verified
   in dmesg logs)
 - Inline files, verified that -EOPNOTSUPP is returned.

The same tests pass on both btrfs and xfs (modulo the inline files).

I have not run fstests which I know contains tests for INSERT_RANGE
and COLLAPSE_RANGE. I will do so.

== Questions for reviewers ==

1. Transaction cycling interval: we use 32 items per cycle. Is this
   the right threshold, or is there an established convention in btrfs
   for this kind of loop?

2. Extent lock scope for collapse: we hold the extent lock only on
   [offset, offset+len) during the hole punch, not on the full
   [offset, i_size) range that the key-shift loop operates on. Is
   this safe, or should we lock the full affected range?

3. CONFIG_BTRFS_EXPERIMENTAL gate: is this the right gate for these
   operations, or should they be unconditionally available?

== Notes ==

This is my first kernel contribution. Development was significantly
assisted by an LLM (Amazon Q Developer). The implementation, testing,
and final review decisions are my own.

Various btrfs_info() print statements, assertions, and comments that
were useful during development and testing have been left in place,
but will be removed or streamlined in the next revision.

Paul Richards (3):
  btrfs: refactor btrfs_fallocate() ahead of supporting more modes
  btrfs: support for FALLOC_FL_COLLAPSE_RANGE in btrfs_fallocate()
  btrfs: support for FALLOC_FL_INSERT_RANGE in btrfs_fallocate()

 fs/btrfs/file.c | 601 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 578 insertions(+), 23 deletions(-)

-- 
2.53.0

