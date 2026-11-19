Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795124425;
	b=rM1seA72jT0gScjh1sMjLwYoHR1mkqrfO70yK/1U2FlIO++803y26IPHcp/zTOhUj1OX
	 4VkxygdzBRxl+x7fc4c85NOVyrTqfkVyZ/CymCF0Ar5Sp8txIQCLOS2/R6flgF1eau4vO
	 rKmNJ4pWWOHz5K8NZqOYvKaK/qJ9T29UlDbRFagYiS9I2kweM4/dDV4dSCxAjMlw/LSsP
	 3JXCdF0iUwBraamgJGa/1rBsehBTewd6WDnN7t/x/a8LNF2QrOjeaUgCrQxiqG1PLiznF
	 EC5oiEHouTPBdOZ8jPEcRDJCa7ltKgoFMnHr+CLLK5D1iteU6uwTFChIYoWfsgikVeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124425;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=dMjBC1xbXo1FCDcAgRb4+j+iJgtyMUxznsdpgD9opw8=;
	b=qLuGAh9lDgVsa9J4lzlNWGg+abgAjURsq8AzxAUBtR9Y+GjTlXwhvGMCWHc/uvDi4ayR
	 IToiXaNj3IYVi1T8XJWRrDQQs/+95+l4eEHaifaxV28ufgOfF6e9rf+4svHfSlBerRZ3j
	 VHh8I17uXOxbu3iIB75egP6eXza41zocgu1Bn3jGyhkbZYIGDegzI5Q8OvkGshSl49Lf7
	 XNF2U7iuDgkI2KTdGysfmNdj9GSCvaAZ6H/NBTwi6ukRFFDKpkGQ1KxbRKAySyY0uZDSN
	 PW5qCuzVmyigMyeUGnNv0+JgQyOfItDCSB05yMQ4U8DKN3e9me8OwxxTFa7ZZ4EcQXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b="X4/tNZZJ";
	arc=none smtp.remote-ip=109.224.244.108
Received: from mail-244108.protonmail.ch (mail-244108.protonmail.ch [109.224.244.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D5A606A334
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 21:40:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71D5A606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=X4/tNZZJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795124422; x=1795383622;
	bh=dMjBC1xbXo1FCDcAgRb4+j+iJgtyMUxznsdpgD9opw8=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=X4/tNZZJyOUVaoJj1LXQ4e1hv/WNjKwhLOoJppruC738cDZpr3PEimR80UwcvLjaI
	 NVy6eDqgVZQXjUokUoGe+z8D4MbvKQOwNvKxxUKNLHH2W3VsIQrIyZ30b4ue5uf2og
	 GST1vGK+h1q19gNY0UtHvv32pi+2APiPXDbLZd3vgsdcWpMQ/dZYwyCs0rCjMES3u5
	 kTkG4DJM1JovS4TQNKhxgTYgYF3jTIJQdgiPVS0VPwQlRGcM3eB5pC5B+WYe7N9LAd
	 oIoNp56phI4aQXRp5YAR4qHN1t7tFIC/xyM9mafHO99WnGf3kDzLerj5oc3Yqg2yT6
	 urBvcSBbCr03g==
X-Pm-Submission-Id: 4jVsMR5zl8z1DDXR
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] btrfs: zoned: RAID1 block groups with missing or stale stripes
Date: Thu, 19 Nov 2026 21:38:31 +0000
Message-ID: <20261119213835.103131-1-mc@raidlab.org>
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
capacity from stripes 0 and 1. But stripe 0 can be missing, and on a
degraded mount any stripe can be behind the others.

1/4 compares the active state with the first present stripe, as with
stripe 0 missing such block groups were left off the active list and
could hang writes. 2/4 allocates from the highest write pointer on
degraded mounts, as stripe 0's can be behind and new extents then went
over committed ones, and lets a regular mount load a block group whose
stripe 0 is on an offline or read-only zone. 3/4 takes the zone capacity
from the other stripes when stripes 0 and 1 are missing, as RAID1C3 and
RAID1C4 block groups failed to load then. 4/4 adds self-test cases.

Miroslav Cimerman (4):
  btrfs: zoned: take the RAID1 active state from the first present
    stripe
  btrfs: zoned: use the highest RAID1 write pointer on degraded mounts
  btrfs: zoned: take the RAID1 zone capacity from a present stripe
  btrfs: tests: zoned: add degraded RAID1 cases

 fs/btrfs/tests/zoned-tests.c | 82 +++++++++++++++++++++++++++++++++++-
 fs/btrfs/zoned.c             | 50 +++++++++++++++++-----
 2 files changed, 120 insertions(+), 12 deletions(-)


base-commit: 04c9eb073c7c02bf041948ca35b3d8b3ef582974
-- 
2.53.0

