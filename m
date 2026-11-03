Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793736202;
	b=lZKAMXUsFwwWrBp2MmSnlrDuuO/fxD0H9WdXeBTwq6xI+r+DyUxNU7afvCw+b6RG1DIk
	 P1IH0leyKO1Rau8tYcZWSDdm4fjbCJ7gEkTRL8VcQVpKEznKalM/I64N0LPVfi4ePPGX/
	 gCletmjnYX4KMyE4kuW1/TY1CMqsO+b8L7cyZapZeI++9YPKq//WbUU4NNiS5Q7Zd71pV
	 nzd+DAmkYlKrW5kgksPb1Kihc2xwGCJ3BGFZZIZ3P/cqc1SHmiJ8KCBRFnz+S3fter3S7
	 Q4xQK1mb7u8Pg3y73Pdri16AP0KEhmREnGi8tAo7JXEfaPCikVJFMPjF1eqkn0iwrUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793736202;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GIMs1YJrQR1ugDS+TrlJFUtffoilOTXQSJKU4AwMCqM=;
	b=eLXwEAjV9YxWMAHwggOOn3dcX6CnCisFcThh4IA4bJIhe/p26CzwCzXyWDvq3eKYeKlN
	 Z6KSIB50xETucjxW64J5LLCZtKOhF8fpuYa2W5pBXuNSoxMcJY/r7Ewd4WZ/uL/7kA9Ql
	 ZWIziQzRW5GbezKQEUPS/vsxCIppkRNx2WPt8+VMnJpYlEBxGkAfJf12yOI+kw47uYCUA
	 rYXaGIkjazEQ0b0rkk9c/yivWAe/B5hQcC33w7ydGZE405HnT7ogIpQdeBzH152nrNbOc
	 fAWqFu3CQh4+eepieiPNW2FjDx04CbUoYtt3GHCe8U2f9dMtCPrE9Inw+9YjYglJ92Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WUS9abmS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891D5606A31B;
	Tue,  3 Nov 2026 20:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WUS9abmS
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793736202;
	b=UefImCJBzoN+WQU+VYuHKZAy5AtI8ZJDIrVnjxERCFD1Os0oh3jyAZtO0tvx8pSgv1RX
	 S4K+o5DC1QEDL0Ts2Op067N0pQjBkq1WBCFILzmDn88X7/GCYiOeYc5Yzh40so3RNTs7u
	 lHUABKHEpMjsGaqPjdSc6eL8TGio8/oa1h+svxMh7in3tqLQQWL484pDYRpZ4e9/p+9U9
	 6PPgVPD0BcWAQRdtdWq6y9+Bh+wyVphGk5IgUOkLlIJdvEtSax6bdsk0h+blUZPjhIELG
	 0bQtefzb7AIDwHGmG9LoSzXr79ygZy7elqOdkoixSdobkSHnVteH4uNe+jmUTDyKcZQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793736202;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GIMs1YJrQR1ugDS+TrlJFUtffoilOTXQSJKU4AwMCqM=;
	b=mckztlEjhc62Zj9BxKd/SvurwqMGIzo3Oi07PxktWHrdJyKh9muFugKNzyPz6Ofz4gff
	 WHNx+z3ewNH6xyNRCX+gT8xJQeHZg1UXn+s7n8ZWms1SZqAhy9+XD8HNGhkPUATqSlfMw
	 PKufFIl0BPCS3bSTtpNl/t4xVB5iBEJf8fXl+WMx06orltuh4u/Dng98zNUyyU41m2n9r
	 G2KBFOg/g0+FiIB1s0FBMIMMvAR++JIkaq/oCXkHP9D+6UnieG7+igoN33OqUUtXcb5ST
	 GLkevxGAur484H8RD1LsXCeCdFpcAkj8QIDvGxVIeDuVACrGQaXrYdWQlnslJsVXEOQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D27F71F000C1;
	Tue,  3 Nov 2026 20:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793736202;
	bh=GIMs1YJrQR1ugDS+TrlJFUtffoilOTXQSJKU4AwMCqM=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=WUS9abmS/zkyjFkjfse8JT6//dm5rb3MhXWsN743vApIAqQQHbE6Iv/Ziv0uNmGXr
	 1Yi4qtzqL5V11Ri/GUUqNQrpGkH7ZDomscZc/l/6Dmj4HqohoV9iGw7vYKjHEg9qaZ
	 oGL43jmldfl+kcAz7Uwy8vn641usc7+Br6CDvYh1fkLMzqDhn4SsKfs37Bs1WsUXZy
	 94n86tT0y9w7OjoGBE9KDlf1H29rc/QOT8zBDBgeE1SCY5BpByY6jBqFiX/MTy/vg1
	 V7IhZOzBv3hlL0ap0J1RWIq4viJPjevU4/Px7A/eKj56LrYbi2K7eE8aU3A3FqJ79d
	 Gf552NWp3UuoA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6453E46ADB;
	Tue,  3 Nov 2026 20:03:21 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Tue, 03 Nov 2026 15:03:21 -0500
Subject: [PATCH v2] btrfs: fix bio counter and bioc leak when async
 checksumming fails
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
Message-Id: <20261103-btrfs-async-csum-leak-v2-1-30872bec9613@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNyw6CMBBFf4XM2jGdEiG68j8Mi1KmUuVhOpRIC
 P8uj7XLk9x7zgzCwbPALZkh8OjF990K+pSArU33ZPTVyqCVzkilCsshOEEjU2fRSmyxYfNGynN
 duYtTNtWwfj+Bnf/u3kdxsMTyxXbYZNui9jL0YdrDI227o0GK/jRGQkLHxnFuOCO+3m3fxLb05
 sxVhGJZlh+5AekZzwAAAA==
X-Change-ID: 20261030-btrfs-async-csum-leak-1772df5f0c32
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, Christoph Hellwig <hch@lst.de>, 
 Josef Bacik <josef@toxicpanda.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
 John Garry <john.garry@linux.dev>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793736201; l=3251;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=sZ15wckZNBlDyiOLVC9bEfAohvO3ectUWRrLDyA5+Jo=;
 b=SvIUTYUzswOF461t+ia+Mvr4QdkS5dDCzWFzYtYqa6vm3Ju6Yv/w1en7R2C3eCAZtWSAW9u2L
 ifiK38ND2fWA1pfSmFN8mySC2RaANi85jqbizdLWXKaJspdrg/xVBZx
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit

From: Mani Tofigh <mt4022@columbia.edu>

A single failed checksum allocation can make a later device replace
hang forever.  btrfs_submit_chunk() takes a dev-replace bio counter
reference and a bioc before it hands a write to the checksum worker.
If the checksum fails there (e.g., its allocation fails),
run_one_async_done() ends the bio but drops neither.  The counter then
never gets back to zero and the next replace waits for it:

  [    8.369171] BTRFS info (device ram0): dev_replace from /dev/ram0 (devid 1) to /dev/ram1 finished
  [   41.534247] INFO: task btrfscsum:80 blocked for more than 20 seconds.
  [   41.534391]  btrfs_rm_dev_replace_blocked+0x135/0x180
  [   41.534463]  btrfs_dev_replace_finishing+0xefe/0x13b0

The worker is only used when CONFIG_BTRFS_EXPERIMENTAL is off and the
checksum isn't a fast one, e.g., sha256.  We hit it on a sha256
filesystem.

We put the bioc and drop the counter in that error branch.  We also
put the bioc on the synchronous error path and on the btrfs_split_bio()
error path, which both only drop the counter.  With the fix, the
replace doesn't hang anymore.

This bug was identified and confirmed with the help of fault-injection
testing on a deterministic hypervisor currently under development.  The
C reproducer below however hits it within about 35s.

Fixes: f8a53bb58ec7 ("btrfs: handle checksum generation in the storage layer")
Fixes: c7c97ceff98c ("btrfs: handle bio_split() errors")
Cc: stable@vger.kernel.org # 6.6+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Changes in v2:
- Also put the bioc on the btrfs_split_bio() error path (Qu)
- Mention the sha256 / non-EXPERIMENTAL setup in the commit message (Qu)
- Add Reviewed-by from Qu
- Link to v1: https://patch.msgid.link/20261101-btrfs-async-csum-leak-v1-1-feafe7ae61e9@columbia.edu

Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/btrfscsum.c
---
 fs/btrfs/bio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2c6234f6182f..2e12a6d7e16f 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -624,6 +624,8 @@ static void run_one_async_done(struct btrfs_work *work, bool do_free)
 
 	/* If an error occurred we just want to clean up the bio and move on. */
 	if (bio->bi_status) {
+		btrfs_put_bioc(async->bioc);
+		btrfs_bio_counter_dec(async->bbio->inode->root->fs_info);
 		btrfs_bio_end_io(async->bbio, bio->bi_status);
 		return;
 	}
@@ -762,6 +764,7 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 		split = btrfs_split_bio(fs_info, bbio, map_length);
 		if (IS_ERR(split)) {
 			status = errno_to_blk_status(PTR_ERR(split));
+			btrfs_put_bioc(bioc);
 			btrfs_bio_counter_dec(fs_info);
 			goto end_bbio;
 		}
@@ -822,6 +825,7 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	return map_length == length;
 
 fail:
+	btrfs_put_bioc(bioc);
 	btrfs_bio_counter_dec(fs_info);
 	/*
 	 * We have split the original bbio, now we have to end both the current

---
base-commit: 6255426d70f2755968bb5436ae7b43dae742ac38
change-id: 20261030-btrfs-async-csum-leak-1772df5f0c32

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>


