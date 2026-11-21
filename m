Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795268761;
	b=x5ItosvpNKmobh6rClPYDJr5jX41YuN6N1ATcH4LSkfvmzEHsHCPYpbbx3PrG4dSspbb
	 p99Az55cW4i6C14fBME8FnxhLLw400yrsig01opdtnRZXi/MGb5VlS6UrFAPCzeBZYIYY
	 PRBsoqP5A1tZyGO1OFtlaVSEhcdM1jrvKWvBrRkWpO9l6QKp/eP5ZOxauetcdfwHx3pBl
	 RukVFnG0PaIkWJMesZrAExsJahtBN6mjtZV50xc7s0UJBasyBt6mKY+lwBdMn8HTUzE/5
	 EH+XzGvVQ4QVmUXdrorMWDhh4aO0jxP6EzmOszk3YAPVv5hjVI1MZIePNMpYQfsArFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795268761;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=LmyZFdxowZH155razIxR4qvAydcS9K3H+kHlAZaGnBk=;
	b=0YkgTfixyrNL5KR5VEzzR9zioO1zHa8o2QRBuGct9hovaIM6ECvs6pAfAB9R/GGzCuAu
	 /U2XadJpe3w2xJxxm1SF+sxk73W8n7LGJM/Qs2qDrBl61Je6PP58iZMrdoCjvgp9Cgwcq
	 +DQFEFTJmAy7bEPs9HwdQeeAubf7b43YALh0RN2TJyi7alQhklheW/Pt9fdZdd05fsNrP
	 tfZeJ0qKxdqIzwul/oFs5/Fahf+L+UFmJHn7UHdEJ4Ck34k200RUpaJIuufHRJMYIdk7F
	 uoIEhgETNt7v3dBATZ8FYWsbV/mZs784+damG4ArXEU7bpa3d/mxywkQftjTa4wCJEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=NXnmCHLA;
	arc=none smtp.remote-ip=79.135.106.112
Received: from mail-106112.protonmail.ch (mail-106112.protonmail.ch [79.135.106.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFEF606A320
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2026 13:46:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FFEF606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=NXnmCHLA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795268757; x=1795527957;
	bh=LmyZFdxowZH155razIxR4qvAydcS9K3H+kHlAZaGnBk=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=NXnmCHLA87MR9Iqk9seTfK3O9YEj7PSWzOpZxT+uUCTgkChb3vjphhQScpYjplw3h
	 mB+2P+Rxk8mDSGPtM/OQj/L45g1AhX/AT9IEI1pyXr254tF0YEUAW5EwvpWhi/Hyo3
	 EPlLUaybiY+YZ6XJh7+GjKbXVhHAajefnlQZAOkR8bmJsOMhDGxbvjutk/t3b2TQ6f
	 z9J7GWM/NhmohnCtb2jOoS3LLAjjpy24FWNFxuSh3sLgM3ZXLTMlhLQ+TdU3Fksb73
	 IhBOm9zVh95/xugb1annwrRbFMMeeAGyw4tUuUqW35tdaS8u6TM00/fDAkZAO4szKz
	 kcaEmD+N+xwvg==
X-Pm-Submission-Id: 4jWtl80f73z1DDny
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] btrfs: zoned: RAID1 block groups with missing or stale stripes
Date: Sat, 21 Nov 2026 13:45:44 +0000
Message-ID: <20261121134550.216217-1-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
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

btrfs_load_block_group_raid1() compares the active state and the write
pointer of each present stripe with stripe 0's, and takes the zone
capacity from stripes 0 and 1. But stripe 0 can be missing, any stripe
can be behind the others on a degraded mount, and the full zones of a
block group can report different capacities.

- 1/5 compares the active state with the first present stripe. With
  stripe 0 missing, such block groups were left off the active list, and
  writes to them could hang.
- 2/5 takes the zone capacity from all present stripes. RAID1C3 and
  RAID1C4 block groups failed to load with stripes 0 and 1 missing, once
  they held data, and were written past a smaller third or fourth stripe.
- 3/5 takes a full zone with more capacity than the block group as
  written up to the block group's capacity, unless an extent ends past
  it. Before, a regular mount failed on such block groups.
- 4/5 allocates from the highest write pointer on degraded mounts.
  Stripe 0's can be behind, and new extents then went over committed
  ones. It also lets a regular mount load a block group whose stripe 0
  is on an offline or read-only zone.
- 5/5 adds self-test cases.

v2:
- 2/5: was 3/4, moved before 3/5, which needs the block group's
  capacity. It takes the capacity from all present stripes now
- 3/5: new. v1 failed a degraded mount with all devices present and full
  zones of different capacities, which loaded before when stripe 0 had
  the smallest one (found in an LLM review). Zones with an extent past
  the capacity are not capped
- 4/5 (was 2/4): mark a metadata block group with a mismatch active if
  any of its zones is. With an empty first zone, it stayed inactive and
  warned at its next write (reported by Sashiko)
- 5/5: add cases with an empty first zone, with different zone
  capacities and with a failed zone report, and a capacity per stripe.
  Renamed, as 6 of the 14 new cases are on a regular mount
- rebased on for-next 184fa2c40f5c

v1: https://lore.kernel.org/linux-btrfs/20261119213835.103131-1-mc@raidlab.org/

Miroslav Cimerman (5):
  btrfs: zoned: take the RAID1 active state from the first present
    stripe
  btrfs: zoned: take the RAID1 zone capacity from all present stripes
  btrfs: zoned: cap full RAID1 zones at the block group's capacity
  btrfs: zoned: use the highest RAID1 write pointer on degraded mounts
  btrfs: tests: zoned: add RAID1 cases with missing or stale stripes

 fs/btrfs/tests/zoned-tests.c | 203 ++++++++++++++++++++++++++++++++++-
 fs/btrfs/zoned.c             | 102 +++++++++++++++---
 2 files changed, 291 insertions(+), 14 deletions(-)


base-commit: 184fa2c40f5c50afb1d8bf900eafadf450db392e
-- 
2.53.0

