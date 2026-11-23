Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795456606;
	b=Mz02OwF9EHMZzTtwMtoBMQ7LvayGwzhXsUdIwklnkeTNx2YpnFqEnIEKhMUVuOi2Tb87
	 9KNSUQX9OMEdRZTnLGq5cBbPKHxfp++9xi/9G+mI+4vUM/lE2lSMzyfbnWn3Y9qSWY4Gt
	 4Fh8XPm0gGN86hP+gO1PP6gIVaa/F0ZtbWAv0KN2jhBY1sE9BVDtAKOY9zP2W6TySZ382
	 l8djPMuitxlBikDL6zJPB1VyMFGHtrvO8gOxjqYl32UjnEDfyqjjx7UsSNyVYEOd+n7As
	 z2Lz5bimyVWe9ecmlP69immMaf4+D8gozNeAmoBeHL9eOk1eW7tGvCJUmDVCQCtcvnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795456606;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=S/oF5gMwqu+gCtm39uYtCKIb1hFZjkhIUf8Z1pZYHSE=;
	b=v2hYWzFedOqf9zS7LF+wraRQxmlNFOR3Bi1+dAUhgDk5/UKffbDZ1w50cBxlDDSzWkVQ
	 ibd3YbyqxZeShPI9WZEx171TR4qDWHa1od/4lcpBDCRwREptiZQ6YY7vmbPkzaF5Jwq/E
	 jqoN7PQImn+kG05OzIVlqKKogZIYAtlo73eVi2f+1YHsQmjGdAbdqcZ9hZwV6zr1TvPkS
	 3Ep96mfXC+b9q2dkcaOKccbMmsf8jHGV6mC0JdZZ9rRVaqxzQAKZGvxxeKQVr11eE+GsF
	 EziIOBywlyRpjfJ5T1qjScjc/qf2KfiXvVty4i7v4P+HMbk1UHlbt5m2o5VOg0/cfdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b="hmDr/QwX";
	arc=none smtp.remote-ip=185.70.43.172
Received: from mail-43172.protonmail.ch (mail-43172.protonmail.ch [185.70.43.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF49606A31E;
	Mon, 23 Nov 2026 17:56:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEF49606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=hmDr/QwX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795456603; x=1795715803;
	bh=S/oF5gMwqu+gCtm39uYtCKIb1hFZjkhIUf8Z1pZYHSE=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=hmDr/QwXykCQWj/vDasKlunJvgyNdrJogWF6K/UkAtViAGzehjAwF2WrgypqoUIH4
	 7k5dz1Zd/fO1C5HN2t2n+9c+WQhoAizFcUHG29S2o+FWuYz6wcYyainP6Zd8aLxtx/
	 aVUZwc+m1wfmS4IT6nqWvr16jjGD3TCg9oZ9fF1p0jFEA4q3mmucQBhwc1w/+7qW6h
	 4g1nbz8N75Zlg0rta3efNCY/67mit8vNoAu2hPFA08qKGXuAoMBKSjN3jAanJfhvfZ
	 tJpEY3AXRmsfcziIX3Ch1WMQQeOdvOZRtSAGGep/SFfaghEqD70PyFhRG2hVCr5e3R
	 Cx/vxKm3SlEsg==
X-Pm-Submission-Id: 4jYDCY49Dmz2ScQG
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: fix NULL end_io call when submitting a repair read fails
Date: Mon, 23 Nov 2026 17:56:33 +0000
Message-ID: <20261123175633.2058431-1-mc@raidlab.org>
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

repair_one_sector() sets up the repair bio without an end_io callback.
Its completion does not need one. btrfs_check_read_bio() recognizes a
repair bio by its bio_set and hands it to btrfs_end_repair_bio().

btrfs_submit_chunk() can fail before the bio reaches a device, when
btrfs_map_block() or btrfs_lookup_bio_sums() returns an error. It then
ends the bio with btrfs_bio_end_io(), which calls bbio->end_io. For a
repair bio, that is a NULL pointer:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  Workqueue: btrfs-endio simple_end_io_work
  RIP: 0010:0x0
  Call Trace:
   btrfs_submit_bbio+0xf1a/0x20f0
   btrfs_check_read_bio+0x758/0x12e0
   process_one_work+0x68d/0xf30

btrfs_bio_end_io(), btrfs_submit_chunk() and repair_one_sector() have
no frame of their own in the trace.

This can happen on the first submission in repair_one_sector() and on
the submission to the next mirror in btrfs_end_repair_bio(). On the raid
stripe tree, the mapping can fail for one mirror only.
btrfs_get_raid_extent_offset() returns -ENODATA when the stripe extent
does not list the device of that mirror.

Complete a repair bio that fails in btrfs_submit_chunk() like a failed
read of its mirror, from the end I/O workqueue. A read to a missing
device completes the same way. The repair code then tries the next
mirror, or fails the read when no mirror is left.
btrfs_end_repair_bio() needs the mirror number and the saved iterator.
A submission that fails in btrfs_map_block() sets neither, so set both.
Each retry runs as a new work item, so the retries do not nest.

A mirror whose submission failed counts as a bad mirror. When a later
mirror returns good data, btrfs_repair_bbio_failure() runs for that
mirror too. On a zoned file system, it starts a relocation of the block
group. Otherwise, it writes the good data to that mirror. This write
does not use the raid stripe tree, so it does not add a missing stripe.
After a transient error like -ENOMEM, it rewrites a good mirror.

Fixes: 7609afac6775 ("btrfs: handle checksum validation and repair at the storage layer")
CC: stable@vger.kernel.org # 6.6+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
Found with FuzzyRAID, a fault-injection tester for RAID that is not
public at the moment: a repair read whose mapping failed, on zoned
RAID1.

The tests use a test-only injection that fails the mapping of repair
reads in btrfs_submit_chunk(). The file systems had bad blocks on the
data of one device, and reads went to that device. Without this patch,
the first failed repair read crashed the kernel in 5 of 5 runs: 3 on
RAID1C3, 1 on RAID10 and 1 on RAID6.

With this patch and the mapping failing for the first mirror each repair
read tries, RAID1C3 and RAID6 read all data from another mirror, in
2 of 2 runs each. RAID1 has no third copy, and its reads returned -EIO
(1 run). With the mapping failing for every mirror, RAID1C3 and RAID6
returned -EIO too (1 run each). None of the 13 runs with this patch and
the injection switched on crashed or hung. 4 of them also had Josef's
patch below. Without the injection, both kernels read all data from
another copy. The btrfs_lookup_bio_sums() failure path is not tested.

RAID10 needs "btrfs: don't drop the error of the last split bio" from
Josef's data integrity series for the -EIO. Without it, a read that
spans both mirror pairs can return wrong data without an error. In
the 2 RAID10 runs with this patch alone, sha1sum read 7 of 8 files
without an error and got wrong data. That also happens without this
patch when both copies are bad: in 2 of 2 runs, 522241 and 522210 of the
1048576 bytes of a file came back wrong. With both patches, the RAID10
reads returned -EIO in both runs, one with the first mirror failing and
one with every mirror failing.
https://lore.kernel.org/linux-btrfs/20261120-b4-btrfs-data-integrity-v3-1-4de4b91b826e@toxicpanda.com/

Kernels before 6.19 need a backport: simple_end_io_work() is
btrfs_end_bio_work() there, and 6.6 and 6.12 have no end_bbio label.
Backports can follow if needed.

The analysis, the fix and the tests were done with the help of an LLM. I
reviewed everything.

 fs/btrfs/bio.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index efbce4d549ff..46df424e9667 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -840,6 +840,19 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 		btrfs_bio_end_io(remaining, status);
 	}
 end_bbio:
+	/*
+	 * A repair bio has no end_io callback. Complete it like a failed read
+	 * of its mirror, from the end I/O workqueue. The repair code then tries
+	 * the next mirror. A direct call would nest once per mirror.
+	 */
+	if (bbio->bio.bi_pool == &btrfs_repair_bioset) {
+		bbio->mirror_num = mirror_num;
+		bbio->saved_iter = bbio->bio.bi_iter;
+		bbio->bio.bi_status = status;
+		INIT_WORK(&bbio->end_io_work, simple_end_io_work);
+		queue_work(btrfs_end_io_wq(fs_info, bio), &bbio->end_io_work);
+		return true;
+	}
 	btrfs_bio_end_io(bbio, status);
 	/* Do not submit another chunk */
 	return true;

base-commit: 65101fe10b3008186b813b628ee3a611b0e70ce6
-- 
2.53.0

