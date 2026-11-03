Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718345;
	b=dTC1lm/rUokV8/OoZSNEu9SwZW5fCBAsvBsYWrsRGzeZk9uSAsff0/tGJHv73Qv3FXyE
	 zGXRf5vNQF9T8a3YVz8voZkl5XaxBXWm6WHWDf7a3Hd9IerZ60kOSnBXRhKHlgLY24xUE
	 7ddds/dvn4Icqm5ZV16kX+HzZSXCSCQ2l4jqfWLOWa1PjSDtzEa6TKhlFMtpjqYqfckoF
	 a250dPvAf6vMQFpnjUGVWY3SrpnbhW7kM2BzXouzOFU3WzRpqLL7Ppa7iCb+q8uCtFQJl
	 QlNUrGjUMjQmZluugvcpD5fNJXnQUZhaCB7HkXBe7WTRRlDgtG8JROTfXkbWYaFprBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718345;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=67TybRkP8njggFQDhor39f7CtHtsMroxxr3yAFAiuuM=;
	b=zgmQbpQLn6gkIDb4oPuut+0pg05plWaJLdSCOl+8/qL26pexYO1CKccY+05nLqkvXRE1
	 aSqde221Rj/t3K2I70Zm7RZs5AEQmYpDKFKu/0WOXXrmvUltrCLhiTBKCj+BRf7nYpK6Z
	 hBBjgE3sNgbI0nf3O4hMDmK/l99aZLcszLPlDbtSb0Nmw8nCVQjKkUXlpU5MXQKYaNiAE
	 rHKpuNwp+GoU1ej4kgrTeI5ULVN84o2QDEMhg0Td3JLMJzZPr8SzMQdL2idDQJLlP+/6p
	 gxH+Tn/VSfVgqJH4M7Chk3Xc45Iq5dMwYMQlTTaqEKQw6jFskDqdAD2HjG2mdVvdIRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=bMonX4KE;
	arc=none smtp.remote-ip=209.85.222.47
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A48606A33A
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 15:05:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50A48606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=bMonX4KE
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-97ca72f2cd9so2270373241.2
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 07:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793718343; x=1794323143; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=67TybRkP8njggFQDhor39f7CtHtsMroxxr3yAFAiuuM=;
        b=bMonX4KEsTOZ4px5x4FS1daHqkRFFxhdMlwl1RsI1M6dJVaG0bGGg1Chz1BG7/AhcJ
         VxfKuWb6/OQQ9VhHPU4eqMyMBtEfakSZl24U1Sa9Zfm3tU0/1pYykvU7TxdFT9fgiQvG
         U+aEEtMxPEhcS0Uodxt1iYwFZOBfP3f+GBT9b5P8ghApqaie9bJHVnGCgoQzn4FSpI82
         X31IQ7cm3vdLOBXArvxnpGvHEApelwa2KRd2ku5AFdbb7k8Vfonr/Vd/kkVzJkzapCuy
         2GYQAPac6/pHaLVjVidNQRhFhCE5CuKlJiyUYWuyzuevCQMDzYkoO5+6MEymAGnpXnSU
         EGvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718343; x=1794323143;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=67TybRkP8njggFQDhor39f7CtHtsMroxxr3yAFAiuuM=;
        b=eGkassqZ/+AZjd7u9t+7WoKE9/mM7lUC0rYfCDsf3nD2my5gRnlY5ulh2LFpQB1Rzr
         tPMNNMw9qd2VKoXMOFIEyAuK6tDRWvyRWOocpMQ3XkGOPQRek2DcBRL6SWgsSuJGS8Cz
         fYNPlZBeIY86btjCs0UlUIoIMRpXetfeKoWLOsvhX3WdfJ4fo/VleLnK5GohvOTeukbj
         bUdjeo4ZjxYcLYUbLTb0wUsrEfuCv65q5VUencICpGfv4WWa9zGLwaTqrxQNyBeArcsb
         UrJ8I7XA5MqcLvrDwRug/bCIpjoy1L2o/bPw/v2UehYMLQJm8iVThzy5VDPUOyT99uSt
         7s4A==
X-Gm-Message-State: APuU4Z/HrDpEHNYAg5Eqnf+3VbreKVFZnEorpykGVfJke8aVE8eEp+Em
	WloSo8GZL1oxK8f+9ig5o/gRtNw0gaXYKgvD6g43RWSQ7EflPt19mPkR8iT0lkP6tZE=
X-Gm-Gg: AYBFou0OO/2/P1ELzUdxIC+m0S0wDBr+w/pE8quBwczABjCGMZgNaaAsd2HhKNfx5IO
	ze0RsbqwNTy1bHg45U38CpefID3qe36q6g2u4nTwyhPj2/ccXZiW9HOCfPLATIfXbjgTDNihbJf
	z2r5v6OrWDlCb0ichO1pCL1Cgo36dbbEagrraIRauqIqqEJ0RQkbcIK+/spFB9bBtII+AWyxwr1
	qgPz9orKwBQt/gEbY9J/PxyHj5pMuAcFMbo8/wwV6dEaTNSTdmnYxXruAKNBORp6c70L3kKS2V4
	TT9DOufjULTG8Y5Ka/0OSLKdGiy21catmSDP63k64VzknTpXuDi6ALarES38zo9lQhfj08qujWT
	ZTNfdZ6qks0JtrVIdl04B5Gb+ObzWN/wD1ul/EYX70Ox28dAxPkxeghSseU9BkjDKPxXpTo1VKh
	NrzJmnhrPNw+RcIOMhJ9Lx6NL8ZpSws8s0v6Km+/xmJ8SPTvKl2WOqdhKjQRHPuOIzu5n1pwOA8
	NoeO1xr+VViPrDhNHacNRbijol4gIk1682mo6KYTcjGip7ZmHmBcmEmVZz4dS6IMjhaPe/TS7zP
	zW7HFlb4oqzM+cO0owFMOfPKMcz+C8mQIQgzJGSjw0rr
X-Received: by 2002:a05:6122:420e:b0:5ea:c874:6c4 with SMTP id 71dfb90a1353d-5ec689a714dmr5635533e0c.16.1793718343201;
        Tue, 03 Nov 2026 07:05:43 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec69bbf5easm12733681e0c.3.2026.11.03.07.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:05:40 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 03 Nov 2026 15:05:17 +0000
Subject: [PATCH v2 2/5] btrfs: clear dirty blocks after a delalloc failure
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
Message-Id: <20261103-b4-btrfs-data-integrity-v2-2-577dc2690061@toxicpanda.com>
References: <20261103-b4-btrfs-data-integrity-v2-0-577dc2690061@toxicpanda.com>
In-Reply-To: <20261103-b4-btrfs-data-integrity-v2-0-577dc2690061@toxicpanda.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793718330; l=1851;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=jNWS89+wbKg8G8W46m/SRpIJP0/cRE8yhKoG8CaTcKU=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QAA1w+5lm7c9UOO/a8yqwjLT/d0i6ZFcBjFmBUzjfBpenpmo+Wg+hATTZzY7y8DYkemX56lgUD1
 0fpwmDfJoBgU=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

If writepage_delalloc() runs the first delalloc ranges of a folio and
then btrfs_run_delalloc_range() fails, the blocks that already got an
ordered extent are finished with an error through
btrfs_mark_ordered_io_finished(), but their dirty bits are left set. The
next writeback then submits blocks whose ordered extent is gone, or is
about to be completed a second time.

Fix by clearing the dirty bits and cycling the writeback state for those
blocks, as submit_write_sector() does for a block it fails to submit.

Fixes: 72dad8e377af ("btrfs: fix double accounting race when btrfs_run_delalloc_range() failed")
CC: stable@vger.kernel.org # 6.14+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent_io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5ff630630490..3283835ccb5e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1746,6 +1746,16 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 			u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
 			u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
 
+			/*
+			 * The blocks are not going to be submitted, so they
+			 * must not stay dirty. Otherwise they are written back
+			 * later without an ordered extent, or worse, with this
+			 * one if it is still around, and invalidating the folio
+			 * would account for them again.
+			 */
+			btrfs_folio_clear_dirty(fs_info, folio, start, len);
+			btrfs_folio_set_writeback(fs_info, folio, start, len);
+			btrfs_folio_clear_writeback(fs_info, folio, start, len);
 			btrfs_mark_ordered_io_finished(inode, start, len, false);
 		}
 		return ret;

-- 
2.55.0

