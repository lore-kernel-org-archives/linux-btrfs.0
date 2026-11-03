Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718341;
	b=Iy0eDJX63pSrJaL0/s3yfmhMcp73InBOFfueqmf9rtDsm07d18a1gvfrS3t0piEoMh9I
	 5HswYKt+M2j9iFdRB1upUGOE9vylUrtlu2E/liUXz7MSSNKrtJVcEKIYvPVl+3gxh6SfS
	 svd7+eWQ8YTVd6WIFWRicA+/5ov5iEI3uumc4kQxVViWBjV2GOMtaNBHqRsqQ80jJy8YW
	 xQXCQiQp4N9vOLd63jmbj5QVQQF3+ahEXhUceJcINdpXjDa/Xi4K+RCmUudtSR3s1y4wI
	 MqJL+7LZo9s1YnK1lL3MawnQpsaCFzYbXEaUs1/Xj2N/mJhhDfULXDQ+5xlBe0JzPzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718341;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=56Q+l7rKVDW+iqwTLYFdG7hz631zPQcM8ZSeFLv+MKY=;
	b=JBXlrrMlvF7mYIxDmvh9IkI3V4aQvkSUxWQgiYRPZFoB+k0Y1GTuAU45UHqxJAe/q6B6
	 boRTxnhhiALCc9cBABUiBiz4GTuvXlab3YauOoHPChAwUXthLCM7vMpp7lId9I51LOpE5
	 BIYn6JD3yM0Sai27AZV5IexccdHNP5GzlXKPfgZAq+QfjQPGC7XMnqwZcd3xoHfdLAzsD
	 d9s5bup/3gq8qk4OYjdEf1i83s2ZoAozvUiJi2uAfJRNaBYgOdcNBt50wtzV/ET6EJRo8
	 ljaXKv6xcuPQIJTmDax8eI4SinXD+OX+qOyssYQCaTOCA6PZLH1DeNX6ALisVcIQfFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=rtQ3aUHF;
	arc=none smtp.remote-ip=209.85.221.179
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7C5606D2D0
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 15:05:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C7C5606D2D0
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=rtQ3aUHF
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5eae1276409so1283504e0c.3
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 07:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793718339; x=1794323139; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=56Q+l7rKVDW+iqwTLYFdG7hz631zPQcM8ZSeFLv+MKY=;
        b=rtQ3aUHF/AYyXV7ouh4KpqaLF8J1ges/8mSh0ligYXi/TVsWJs6hAlUuMCipZZGOX9
         f6kGkNQqjNh6ifNgG6vw1Rioz++0M7nnPYb4eCRzlpMt5L8r+KrJGheVm5CmFFDlOStF
         KVTfrOeh84LN6jLLzR7xxd3lyoADM3V9phQIJNoSJPdLvDO0XErZDTw95rdpwX8hYZjo
         K3M50+6QtVjnz2sD0ulqcmcs8Vz7oWg220AWzni/2PcfuVd7lzB1MMzbbCroJ+n7gYqU
         N2C1nz+bgFpACwzTl3fW51rN06qnCygJWdr77e5DppoEe3bW8I0a/ZnebVpJiQ15PsmL
         M01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718339; x=1794323139;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=56Q+l7rKVDW+iqwTLYFdG7hz631zPQcM8ZSeFLv+MKY=;
        b=tb0e4MGAJR73F33tusVxHv0/F9mFvUBqjp8W1Wy0E/OR/RJrHA/EA8ztkYBc9qI70P
         xUVftww57sE/BFYMW3nY+j34KicPbg4NSQj7XT4kya569QiAS6SSVQgrHpNtXiq/5FGL
         CI+VIPyD8KSRNTkb3yz0XlKbUexGrxXvNSvT1uOx8Cl000mxppt6leWFCoQtEnII2ABl
         tYMDwBPtg/7BGhxPmK82IiJu+NpsT6rQfR7e0TFxa3weGbWl5Bcl6O2j531Akyzv+fAR
         m2act2LFetf2JaavYKdVJlxZyQ4tL/NRtz1rdxekweCrifKWhXVcb/aB2f5q2i0Adoyz
         Nb9A==
X-Gm-Message-State: APuU4Z+DGklGl6U58ixdTEGLnvDMqh4uiszlV/TqwA4IO/vJoch/hE7+
	dO1c8WHGFNvowcJ4/4R+sxlEDFzHU8drdqBYVxdxuAKcj0bHLsKDC2GtszRjWFB4IKE=
X-Gm-Gg: AYBFou36RVQCQoSxiUJMSj+Y4aUGWAiKhIE0lbQ+JC7HgRG8+u6tGv8uNH70yyhicVL
	gogHQE/93SVm1rjQN1CIJE7k8c6jzZsADhEXUfPgxIef6ctaD2kS7BPgDcNztMjoEH0CiEDCb/E
	RFwEiUdZCrhFF4zr+PRcaQRetKZJ6ClVJdPr7/CC+60/HBrwwh4YOiaFdol5BC08fJkfT+kCvhu
	DeJ9bZWIRGsDfcPp6/7OZKKqU+n2m8oW1QCb+9MOyZ0DFRFfgqTnBUEZMVoAZP5G83mXnGL7Pqw
	Zvj5gVLuWxsYOS0Bj2dEGrXCPQj1vS1V8bHrVXKKI8F7pXyearNnFzrM573ebQ+bOJL6l7SIUhO
	tKymbToEVQhg+SlbyvDq3/XuFm0PqCTjcUA6A7nStxtOqFG7jrQvRs4TCdDQwRR4QoP8VzXVtIG
	kpmYhR0OW9R3seackZc2bX8H2i1oEgQRqgFXb8lZTI+xMKzX8QBCCJ4UpMtl2UndpI118t1nrQn
	p3rEAi7fl1OOIEawNWsy2QptQjx0XBmltbsDEQkZr7lxeOPzbOC7fPmnyPHsyZicHSLFMh0BDRY
	xIeY2ZsspkboN3wFh7kPy0npbGHlWrEoBUpaBuKOG35K
X-Received: by 2002:a05:6122:2490:b0:5ec:3e18:b06a with SMTP id 71dfb90a1353d-5ec682939d2mr5956153e0c.0.1793718338923;
        Tue, 03 Nov 2026 07:05:38 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.245])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec69bf54casm12957026e0c.9.2026.11.03.07.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:05:36 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 03 Nov 2026 15:05:16 +0000
Subject: [PATCH v2 1/5] btrfs: don't drop the error of the last split bio
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
Message-Id: <20261103-b4-btrfs-data-integrity-v2-1-577dc2690061@toxicpanda.com>
References: <20261103-b4-btrfs-data-integrity-v2-0-577dc2690061@toxicpanda.com>
In-Reply-To: <20261103-b4-btrfs-data-integrity-v2-0-577dc2690061@toxicpanda.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793718330; l=3217;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=txHGnvFegj4zHhwRsHMG/dc5XM4UNpDxUo+mK9fvLho=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QKVqmzPA5qHF9bEJOPc08VvWwEFqOdHRL+Yh7PzBtItxruAR3U5xc9JdRPE61l9QoANzjHXOCXq
 mEOm5C6wzlgk=
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
there was none, so always use it.

Fixes: d48e1dea3931 ("btrfs: fix error propagation of split bios")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Tested-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/bio.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2c6234f6182f..fc0b021cdefb 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -127,9 +127,12 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
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

