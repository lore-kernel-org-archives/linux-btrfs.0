Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793986392;
	b=PKqToYqh4poaUh4fsY/H852a6iLrO2V15VUrqctrIhZa1W7YVGqBQZGIzZHFwj7ELgoh
	 OyO23pWyumuSuLynAzrNFAIToPsqGqziYIligIxpbhS0viRrnQePkM7B7iK+hEXIMq075
	 AC2WTvhe6GHbdZCysc8ufdeqSE/A0w747G+WNDTViBanSk6G5cCfKvGCX4ZQTSWQJn/pp
	 XkyK2B6nu6nOtiVs297Tl5BZii5NNiErmHVVZMz3gbdhT0k1fODWcVJTaNHDcCBue97F6
	 zqdT/jREPxe4dorPdvLVL92v5wEkfC6zikoS8XOWEgcZ/z1Rh1BWvYhHA40SpNpjHwA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793986392;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=xst4AjphZpgtG5TO8m/vOIyBJJZ4I0TWs7O5wFgSDjk=;
	b=QTFqBP1IowcuqzOvuxsWWYLMEetZsXJjZn3HN7WnQGq91ixL5sZzGXK5BPtjvz9R+Hb2
	 kMe+PDKskUunC/spAuQHcuPreU/aUzBrA1Pc41KCfuphwlL4RhogtC4KY8Cl7s8JXSLDh
	 v/rUh+e1yUahECUIbNC8+t8ekHEdX3SC7SNsApShqIv+PuxTItYTIX082DFvcLaB356D+
	 vXIScZ87hcLjI21avthqpUuC/EcfjyPbwm2YPPEab9IyxhRXJEp41m2Q+2rA4qvVbhPse
	 2j42BCRqeS40ZwPPDvGr40VbXasPTxH50p7G9xbww1JTf3gEnslK/EFPlNcdWG0a11Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UIoTRQ+j;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78185606A32D;
	Fri,  6 Nov 2026 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UIoTRQ+j
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793986391;
	b=Luy3+P+SMAopK4NRotLMUOssCTxAFt3oIuc1HW2y1hDG9wMR0Cs9kvzMh+iFvkGxmhJ+
	 KmxyYWKJBCazyCv7oK9AtDb3L2o1FmdfOVqTblxpk1M55x/KYkeHGaH8SXcbgntVV32Ni
	 oR1s6vsa1ECsLgwihL/yySPbene2m2zmCpl9gfVeI6na1oj12yw9vDNp6UN6d1VZSgNl3
	 7ut/HYY6cyPzPXJHwQZ+m57zlE1x5exAlZpW36bycMrZTwwjz3Ttk4h2rrnbJ/MoT/hC3
	 rByUTOm+PWZF/JoUbgIzJADBNSHk53hZ1xZ8tZHV5ZZ2xpyQVMQZOyk6DD0tZbXiXnw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793986391;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=xst4AjphZpgtG5TO8m/vOIyBJJZ4I0TWs7O5wFgSDjk=;
	b=W9xVVCVREHllsOSUwcLMHtGrCg5fiKdY+ZeBvBqsE2utkqvangzsdoGS4CQY32h2dpBL
	 U81NmvBIFKa9vMYv9jstzq1DmiAbxg4/fJ4tt+P3c7cpXr1Gjmb4zRX2vcNpDfzXSMeZ4
	 PaSSDBpQlhKMGa1CmbQr3aeAQ0kpL3MzggMrIMe9O/yEGwbBuvBP+Yw6kzwuq7MkLI38n
	 r3eN5zWszcGZ1Us31v7viM4N/NEKu9VS0hFUVcKT9v07tQjz6NHWWGTjZk6MmS1Me6DJT
	 MQFeJ7zjES/k2AnCs7Ii0OmAkSRqJcoE/mBPiWF0IL2JKdl3nxWD6UPVx4xcezFqUhA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 367041F0089F;
	Fri,  6 Nov 2026 17:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793986391;
	bh=xst4AjphZpgtG5TO8m/vOIyBJJZ4I0TWs7O5wFgSDjk=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=UIoTRQ+jrsLC/jBeoxeB+Zh/vL0ShLupCLOz9MsCmVorl5jQ/hCLCFX8WTsokn7pI
	 NtVyWXUeQ4v1cPBWZMZUaoJsotjBU9D5/vawbY7S22lmYc+vEI9RIV9B0bul6+8Ezt
	 98datMYj9R3vQ/vvx+en47yTWUotiml+3qp4qj8bHGaUjaLH/AYGnV/55VBXFmTwfx
	 htFhcXmMySYFvVQlAndXxVZdhW6qBn7JV/SDj9maIOaD/KWTg5UqKpm7J5SqcTSImO
	 WH/X/Sc6n+hhlFsjAsTL9Wq+T2jVjzoj0Y9IRw4bceQzJS5980R99AFreCUpUrzT4/
	 ORfwXySvLKsRA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8953145E15;
	Fri,  6 Nov 2026 17:33:09 +0000 (UTC)
From: Mark Korenberg via B4 Relay <devnull+socketpair.gmail.com@kernel.org>
Subject: [PATCH v2 0/2] btrfs: tag tree block repair and RAID5/6 metadata
 I/O with REQ_META
Date: Fri, 06 Nov 2026 22:33:08 +0500
Message-Id: <20261106-btrfs-sb-read-req-meta-v2-0-71c1afaf5c67@gmail.com>
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
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNQQqDMBREryJ/3V8SUdN01XsUF4n56oeqbRJCi
 +TuTb1AZzHwBmZmh0CeKcC12sFT4sDbWqA+VTDMZp0I2RWGWtSdlKJBG/0YMFj0ZFyxFy4UDSp
 LrVamqJVQyk9PI7+P4XtfeOYQN/85fpL8pX8nk0SJJDrbONHqi1a3aTH8OA/bAn3O+QurhqA+v
 AAAAA==
X-Change-ID: 20261104-btrfs-sb-read-req-meta-7be597aaaa51
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Korenberg <socketpair@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793986388; l=3228;
 i=socketpair@gmail.com; s=20260603; h=from:subject:message-id;
 bh=uBfa/e6IVMCRQRcbDLHJW71sGV+QFJ4/tF2ZMfAJ+3U=;
 b=Wvz2sjsut2f/096cp7dJR3YN6ju8KnNGm7KaiqihHvS8+rxhKMw8TNh9H436cde/U8tb5Ysjq
 j4eCiJ+aQ4/CgLC3ZtWUgOQXTQTe1NonWyhhxjUfDpRJ6SuXkGi+S7g
X-Developer-Key: i=socketpair@gmail.com; a=ed25519;
 pk=2iAMjWhs7kA9X8ccetT2YVX8dvniXua2okQogw3Don8=
X-Endpoint-Received: by B4 Relay for socketpair@gmail.com/20260603 with
 auth_id=806
X-Original-From: Mark Korenberg <socketpair@gmail.com>
Reply-To: socketpair@gmail.com

Tree block reads and writes carry REQ_META, so the layers below see
them as metadata I/O: blk-cgroup issues them as root to avoid priority
inversion, wbt does not throttle them, blktrace shows them as such, and
ublk passes the flag to its server as UBLK_IO_F_META.  Two paths of
normal operation lose the flag:

- Patch 1: when a tree block read finds a bad copy, the rewrite from a
  good copy goes out as a plain write.
- Patch 2: on RAID5/6 the rbio builds new per-device bios and drops the
  flag, so all tree block writes, and tree block reads rebuilt from the
  other stripes (for example with a missing device), go out as data
  I/O.  On the other profiles the per-device bios are clones and keep
  it.  Now the flag follows the bios the rbio serves, P/Q included, so
  mixed block groups need no special case.

Thanks to Qu for the review of v1.  I agree that background work
should not get the priority of metadata I/O, so v2 drops the scrub,
dev-replace and relocation parts: they stay untagged even when they
handle metadata, and so do the rebuilds and parity checks that scrub
does on RAID5/6.

RAID5/6 stays, as its own patch, because what it tags is regular
operation, not background work.  The writes are the normal tree block
writeback, which carries REQ_META on every other profile.  A rebuild
read serves a tree block read, the same read that carries REQ_META when
no rebuild is needed.

Zoned devices see no change: they support neither RAID5/6 nor in-place
repair, btrfs_repair_one_zone() relocates the block group instead.

Testing: virtme-ng VM, memory backed null_blk, tracefs
block:block_bio_queue, every bio classified by the chunk type of its
dev extent:
- RAID5 metadata and data, copy /usr/include: all metadata bios, P/Q
  and RMW reads included, carry REQ_META (before: none).  Scrub and the
  copy of a dev-replace carry none.
- RAID5 with one device missing, mounted degraded, all files read: all
  696 metadata bios carry REQ_META (before: the 344 rebuild reads did
  not).
- DUP metadata with one copy of a leaf corrupted, read back: the repair
  write carries REQ_META.
No bio to a data chunk carries the flag, no new warnings, W=1 build
clean.

Changes in v2:
- Leave scrub, dev-replace and remap relocation untagged, including the
  super block reads of scrub: background work (Qu).
- RAID5/6: take REQ_META from the bios the rbio serves instead of the
  chunk type, which also covers rebuild reads and mixed block groups,
  and move it to its own patch (Qu).
- Link to v1: https://lore.kernel.org/r/20261104-btrfs-sb-read-req-meta-v1-1-e06b4d059897@gmail.com

The audit, the patches and the tests were drafted with the help of an
AI assistant (Claude Opus 5.5).

---
Mark Korenberg (2):
      btrfs: tag tree block repair writes with REQ_META
      btrfs: raid56: pass REQ_META to per-device bios

 fs/btrfs/bio.c    |  3 ++-
 fs/btrfs/raid56.c | 14 +++++++++++---
 fs/btrfs/raid56.h |  7 +++++++
 3 files changed, 20 insertions(+), 4 deletions(-)
---
base-commit: df5b88a7914e18488908ddf13e14e31ab39f954c
change-id: 20261104-btrfs-sb-read-req-meta-7be597aaaa51

Best regards,
-- 
Mark Korenberg <socketpair@gmail.com>


