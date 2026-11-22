Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795319325;
	b=q+N7mv5PdOgHQArQmL1pqo2f7BIsXdEH63MiRhWGzAhv9/a5pulNr2HRKz2OA6bVLW8A
	 QqQNWIpMX8axaI65e6PUpQH+BVwM4QnoPsFOaHhBGLsVmkiPDKBd/cZv/qe/pcjOXSup0
	 +FGp2GAOdBT6wKioHzxvsyeFG/xBz85Qzd4xyzDWf5SwxIiXVDswsD3VjW/esaXXggOnA
	 OYVkerHQLOzrG2ppLGsI6zXgRcLOZbgm67jHv+uzxHs9IjREYKCYlmtKOsffNMPqBmCVz
	 memufgm8JL1rhs3cCF3JwmmmF1mQC+o2EqglKxT9+YNWUKQtka+RUNw/obFTTlF3O3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795319325;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iXA97T2iUMxZHGG58gqlxBN6lMsTXSCZuiggW9DAKCk=;
	b=ZZZPr8chl17X1qUt6v15CiBaFdC8h/21MxF+mE37uR7tkqC2TPiyR/titxBtFzZdZzC6
	 BAQKZlmNoJ9U5H4PNOtclaGwccTDFzKbBjEcmxW+VdyEibD2didspt20HFlEIegkHR114
	 Vzydiyy5v46mESDemORLgHh/TZVPK7RcISvZ1hlLaBeDmo+qocWkNiFmbOU+qKZDYyG54
	 BIxRDvmTyqpLYOjhceqxZRgzEydB5ew2vFDt47TnsOurCmi7mjhWWQWBFna3WIrqckVIs
	 Usq9pBuw1R8shSGaKHfArxwebfiOtgoxz29sKHOXBnOF5A3puYzd45rkXq1GKga0xgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=KfhiWg78;
	arc=none smtp.remote-ip=185.70.43.172
Received: from mail-43172.protonmail.ch (mail-43172.protonmail.ch [185.70.43.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4373D606A33D
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 03:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4373D606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=KfhiWg78
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795319323; x=1795578523;
	bh=iXA97T2iUMxZHGG58gqlxBN6lMsTXSCZuiggW9DAKCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=KfhiWg782GpdOaOEogmZRsGHdZ6aoDuyXyMfSGN3iejluCK2hlFBRzDbpcJnUhKA6
	 O7LFgujuFjbwC8z1A2Swm7izfQoaVyqjlJ+T+z9895wxC8zlImxW4eIDntSlslVvEa
	 dLp6nkK8zpUGb833Eozms2wnosDLr9F7eDON32UGEkwXE9fnGmrPv9pNgK9wNxNLB3
	 UciW+Qpl+s4EfIJ2odiZVGuxj53rmG7YLZb3Rat+EcS9USiQ3IuvVw0CqOn4ioK4Ld
	 5ORf3224UufNICqop5HE86WX1zguBlGMAUTdJC8ehoNtfLNm0MGx8Mv1uR2DyrKAEk
	 +HLHXzdr6WRXA==
X-Pm-Submission-Id: 4jXFRX5T8sz1DDrZ
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] btrfs: zoned: use zone append for every copy of a mirrored write
Date: Sun, 22 Nov 2026 03:48:24 +0000
Message-ID: <20261122034826.2333981-2-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261122034826.2333981-1-mc@raidlab.org>
References: <20261122034826.2333981-1-mc@raidlab.org>
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

Since commit b39b26e017c7 ("btrfs: zoned: don't zone append to
conventional zone"), btrfs_submit_dev_bio() uses zone append only if
can_use_append is set in the btrfs_bio. For a mirrored write,
btrfs_submit_mirrored_bio() sends the original bio to the last stripe
and a clone to every other stripe. The clone is set up with
btrfs_bio_init(), which clears can_use_append. So on a zoned filesystem,
every copy of a mirrored data write but the last is a regular write at
the allocated address.

A regular write to a sequential zone has to arrive at the zone's write
pointer. Writes to one zone can arrive in a different order than they
were allocated, for example from two writers. The copy that arrives too
early then fails:

  extent A at offset 0, extent B at offset 64K of one zone
  last stripe (zone append):  B, then A: both written
  stripe 0 (regular write):   B fails, the write pointer is still at 0

A RAID1 write succeeds with one failed copy. A buffered write then
completes with one copy less. At write time, only the device's write
error counter and its "errs: wr" log line show it. The failed write also
leaves a gap in that zone. Every regular write allocated behind the gap
fails too.

Copy can_use_append to the clone, as commit c757edbef980 ("btrfs: fix
copying the flags of btrfs_bio after split") does for split bios.

Fixes: b39b26e017c7 ("btrfs: zoned: don't zone append to conventional zone")
CC: stable@vger.kernel.org # 7.0+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
During a device replace, writes to block groups that were already copied
are sent to the target through the same function. With this patch the
source copy is a zone append write again, as before 7.0. I did not test
a replace.

 fs/btrfs/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index efbce4d549ff..8aac4afa30ee 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -519,6 +519,7 @@ static void btrfs_submit_mirrored_bio(struct btrfs_io_context *bioc, int dev_nr)
 		bio_inc_remaining(orig_bio);
 		btrfs_bio_init(btrfs_bio(bio), orig_bbio->inode,
 			       orig_bbio->file_offset, NULL, NULL);
+		btrfs_bio(bio)->can_use_append = orig_bbio->can_use_append;
 		bio->bi_end_io = btrfs_clone_write_end_io;
 	}
 
-- 
2.53.0

