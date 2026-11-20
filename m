Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207909;
	b=3MX1H4Sc+UJ0ZSzGoQqPHk6lM4Ibt2E7cY5dqffVlmgjVAacEzEtTFbU51bqrNgn6/Dk
	 r8mhUw3qr6yGSTGVUWCFSf+oyCoWTdUIcOZDKlIIuvkD5xzwtWzsrA91HfmH2CT8PRr8S
	 ofIuBMnvE557sFLv+dydTaH+rWq7JhPrvbpApVDz0EnLJN+z0YRjTnCYaBDusYPHZ5gXI
	 DnQrpaU5QaMWbzJ4EuNqkj0ANGH5rAYf/Uz6IuS/buT43q22cVYgoEuJbW05/n5ZKyqSG
	 5XkACcl/dKjEnRgOx8jZHvIF3sQ594SkTupTvxlc37thOd8WuWetuckvFRT39rR++hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207909;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=bmDo8lYrQ46wjdEUEvmF2H1dGPZ2XCHvbWiiAWZjHPk=;
	b=GC8KPRcAMbG8jJZifFg3IBEtoIUb+ylbjRMeQvsmblaabxPyJDCRABkfS/ruEb3SqGo/
	 wv9ePzXVaxmi/jSrvs5sY+reQNwaeE9udnKewEFTNlxjH3lHrKt9kWPFXGKEs2rz/l3RY
	 /dH7MuX8rUWt6R0VxAaX4N9bJpxIuR+7IgL1kyAI9quANlyCxzMHyGpAp6sW3aLT9mR/N
	 bQvo/7xOvTj5GKa/pKf9eUUesZ2ohLDUA0/7/bV2M3p1U6N3mkOm/6Np6Vxd025gKj/zh
	 B67gmnBr6e+tW0ooXjQMsuICM0w9ssRCSiF/hEUuZEGhIIML7q2mh0y+MGrpQHwf+OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=POHpYIdc;
	arc=none smtp.remote-ip=209.85.222.182
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA222606A6A6
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 20:51:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA222606A6A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=POHpYIdc
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-949680e6d82so174318885a.2
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 12:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795207906; x=1795812706; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bmDo8lYrQ46wjdEUEvmF2H1dGPZ2XCHvbWiiAWZjHPk=;
        b=POHpYIdcSc9DudTRYsVphM9SmFJ2AhWB+OGRTCgbyZK3KOOAYRSoWV8Bre4w8j23J4
         YNlRw/DY1CNbk7SYeQOXt/WH0sifG7W+nMVYiEmzOmxfY306OF2lX0qajVz5AmUDMEyI
         BDtKCPMdzZ+QMalHwV248Wjs6LlZ6oi9i/Lvatw+hw27aCKlwMLR47aQIMR+Mrax0oUy
         tNxbc+ldsG9zGAwxKGQeVEUfl30sawtpuFGMsVA6HqVWb3VSAtKxIDUowTW7n8d4epG1
         Bg1KnuQWFqqAUXPLKEnDN22DRj3qvSQZfb9hFv9FUH+aJKIRDJOTpzyHUr4/+ak67n17
         QmRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795207906; x=1795812706;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bmDo8lYrQ46wjdEUEvmF2H1dGPZ2XCHvbWiiAWZjHPk=;
        b=THjCzRhB+iLh9AymX47FfHLG0oybQ1QRmkLEYjFinCrVefyv+By5+R9e+cdqbOUIRo
         kuiqx1cr2nTC2rIa+NPG8/PxNHRy586Dy2NOLKr6X/fL5mlQ5FMa82wTJyGBPVYffjV9
         s/uqxgviExPfrZQ2Vy+0rDgWkPoDxru8YSndlr9bZ8NxU/lsU0rg4MAse/R8uQW+MlpK
         ZKcjCgex+0Iq/pPgtfO4/iQp2aJso9b7CiTthLhQGZk+YConEmovAECs0kViiuPqpEpB
         MznwrwkZbdh6cVliZ/td1iFzMX46r/91m8+h1VQqUrX17dNsEg0R9yvxEMBMqZ6q/qCn
         u15Q==
X-Gm-Message-State: APuU4Z+kJOi6eDO4QuFkPXGFyfhcaQB1vWz7icft0AoaHSVKYfbePAmw
	sSYrcr94Evnjb+qxgWhHJMLBDlFFkUfYq7+14RdcDLBehjWB02MAzJCApeCTZwa9W6g=
X-Gm-Gg: AYBFou14ae+vf5fwApidSpIvBb3PJuzVpcRHVQffLDL9ZYiSpUR4kR09DR2RkkkSiGA
	QfLXOKOMYMz96VtjQY3FvmLkefftbOTuh1lTNFelojRpc/dQvqavmiQJj8quSkzwySvjBdv1aM5
	j4tGQQkMvX8VPs1YcvZzOBqPqXbn16OpapTlxMnP6AS4gdd823tJl3xDj554FgqHc21joIteRoa
	ucf7MfEcHuIX9dyDAQpSyksesn5OwQKtguZkQywljGlze3a/txqwoUXaEoUZKIR4sSjC/Q3LGg8
	sN5h/tRPki0ifW0mgirCukJiIzIW1sywVGf6bJKq7viUTincU3qCwmmugg59vAqassx/HWdNBLL
	KS98S4HXMbrleivAeb3k5c1++GEKzcGTbLGuQOMsOrkBbMi4WbcMc37GDBMZjh1jdrZH+Rf4g34
	wA6FVdy2J9mHQauBcteVXsC47E1YNSGjdKm+7aXPWxmXlXbtl3LWKfa9miya/FbNgKUTbobAb5t
	2oJQtbt3MaYz1wkq1ynYuq5eP7BRwewqE0XjsOT6Q9dX4ZHLeomvUDPiKwEfrJyETzMlcRqeoVC
	RmWQSvMGgwAtSZm99RZ9wh6c0sdpRG6L+rK6s7L4duOpBA==
X-Received: by 2002:a05:620a:130d:b0:939:4a44:5f99 with SMTP id af79cd13be357-949ba80f3f4mr678163285a.10.1795207906490;
        Fri, 20 Nov 2026 12:51:46 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb41c105sm281433285a.39.2026.11.20.12.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 12:51:46 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 20 Nov 2026 20:51:29 +0000
Subject: [PATCH v3 1/6] btrfs: don't drop the error of the last split bio
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
Message-Id: <20261120-b4-btrfs-data-integrity-v3-1-4de4b91b826e@toxicpanda.com>
References: <20261120-b4-btrfs-data-integrity-v3-0-4de4b91b826e@toxicpanda.com>
In-Reply-To: <20261120-b4-btrfs-data-integrity-v3-0-4de4b91b826e@toxicpanda.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795207902; l=3609;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=UJ6i1DiWG74DgAdXg0wQaXbop9J6hAkPy0yoRBeCcrQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDn6dlvcfHiixWoRDL7RXBvKllSexlsLosj7VMqSPTGTXsEJgmyqN/0/5/ok4dnXYCWgbBTckAo
 ZnKNvyHgvQAE=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

When a btrfs_bio had to be split, btrfs_bio_end_io() saves the first error
of any of its parts in the status field of the original btrfs_bio. The
part that completes last is supposed to load it into bi_status of the
original bio before calling the end_io handler, but that is only done if
that last part was successful:

	if (atomic_dec_and_test(&bbio->pending_ios)) {
		/* Load split bio's error which might be set above. */
		if (status == BLK_STS_OK)
			bbio->bio.bi_status = READ_ONCE(bbio->status);

If the last part failed, the assumption is that bi_status was set at the
top of the function. That is true if the last part is what is left of the
original bio. If it is a split bio, the assignment was done to the split
bio, which was freed right after. If the original bio has completed before
without an error, its bi_status is BLK_STS_OK and stays like that:

  original bio (tail)                 split bio (head)

  btrfs_bio_end_io(orig, OK)
    orig->bio.bi_status = OK
    pending_ios 2 -> 1
                                      btrfs_bio_end_io(split, IOERR)
                                        split->bio.bi_status = IOERR
                                        bio_put(split)
                                        cmpxchg(&orig->status, OK, IOERR)
                                        pending_ios 1 -> 0
                                        orig->end_io(), bi_status is OK

The end_io handler covers the whole range, so for a buffered read all the
folios are marked uptodate, including the ones that were never filled, and
read(2) returns their content instead of -EIO. For a write the ordered
extent is completed as if all the data had reached the device.

This can be reproduced with raid0 data on two devices, one of them slower
than the other and with a bad block, by reading a file whose last stripe
is on the fast device.

The saved status has the first error of all the parts, or BLK_STS_OK if
there was none, so always use it, and drop the store into bi_status at
the top of the function, which nothing reads anymore.

Fixes: d48e1dea3931 ("btrfs: fix error propagation of split bios")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Tested-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/bio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2e12a6d7e16f..b24cba595107 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -107,7 +107,6 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 	/* Make sure we're already in task context. */
 	ASSERT(in_task());
 
-	bbio->bio.bi_status = status;
 	if (bbio->bio.bi_pool == &btrfs_clone_bioset) {
 		struct btrfs_bio *orig_bbio = bbio->private;
 
@@ -127,9 +126,12 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 		cmpxchg(&bbio->status, BLK_STS_OK, status);
 
 	if (atomic_dec_and_test(&bbio->pending_ios)) {
-		/* Load split bio's error which might be set above. */
-		if (status == BLK_STS_OK)
-			bbio->bio.bi_status = READ_ONCE(bbio->status);
+		/*
+		 * Load the first error, if any. It may come from a split bio,
+		 * including the one we were called for, in which case nothing
+		 * stored it in the original bio yet.
+		 */
+		bbio->bio.bi_status = READ_ONCE(bbio->status);
 
 		if (bbio_has_ordered_extent(bbio)) {
 			struct btrfs_ordered_extent *ordered = bbio->ordered;

-- 
2.55.0

