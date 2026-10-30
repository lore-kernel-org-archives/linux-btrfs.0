Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793371114;
	b=cefn456QylOPCJ26PTlOderyMnz8Q3GOM52kr3nqCFXrKQvkvZFDl3BXhUEFxjdSB7fk
	 K38rsEKdjsyy8Gdm8nARJRQc8QaqJ6cdq8SAGANoD3TEyDpvaz8vUMgPEWygaAnqWvfyw
	 QEq4igQCt3I6M14vf2QPH9Zd15Jpub6LpH9DIiWMc+ZWdOIfGnyauzGRDNn8SOKp2hzEN
	 oEXHvyhfEeEyZluhFGhpfD5enhk/siD+XNO/IApIyYNqkpBeZNKln5nju6LZhUFnwOTCb
	 O40bKwGxroCUT3LTvFYrFrDkj1JSs5+25g8H1aap/7XUyYtH6h8wrthgsfGrxA81QdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793371114;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=uijyyS7B6BlVTQtygDcyY+FtQHZLs86F0bsQdXQ/QrY=;
	b=Mhew96Vs3FZx+eAZgQ133L2YVweGzF1kKmqe4ZDGLzoYe18JqZEL83U20v7VorKEV3QY
	 egSrXu4R2JNj3O/iieoAf8hNOqN0k1rYZuNfdIoSRrFK9ZalTKouLkl98JAdkaV7oLJSc
	 WdnSO9/1I0qsDBKEtfKC73pYidwHAT/1iB71NcI07FY+WLZA2KMaRMnDPbwORwTxGtu8S
	 YCPnZCQAPBwEp8EuXE6y4K1Mw/o+phJl0j7xPRllsWIuwmXHflP53dHzw4m/kRkbo0tAs
	 VAmVEQDEJr9yWP5YWPEkeleVOGRop6BZCWRn2qU546DNL1O75SAnucWG5nUYGnlSZDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=DeS7qnFj;
	arc=none smtp.remote-ip=209.85.128.181
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C78A60A260A
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 14:38:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C78A60A260A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=DeS7qnFj
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8b0a28a720aso7481317b3.2
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 07:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371113; x=1793975913; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uijyyS7B6BlVTQtygDcyY+FtQHZLs86F0bsQdXQ/QrY=;
        b=DeS7qnFjvnuAjNSA3PzgtziXAEctOSqvbMwz+xCurjTOkaPC3sUGSZvQ/urqwhywqD
         2VhYdQKl3Quez7b46AavWxbRdSJW08KlfYJ5fL7s186wE6vVAc7KWlTbuMyN9x0+nZ8C
         ZeBPIJAdlXng05kaWagOULrfi9aBui10Nt9yvXAAKV1JwpD3F4TdvCL920cKXGtq4fL6
         No7NQ2Qm9hx/5auZbrAEgCvvIpYYhrjYlwVUcX6xngsCB8N39qBx7sVA1rTL+NydlLIF
         +xENz34FY0lUjczH8DtiAWJSO7kQFAV85MXjob/cHyeMCdHyCVlpPkfzLRfLzh+2cunO
         UCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371113; x=1793975913;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uijyyS7B6BlVTQtygDcyY+FtQHZLs86F0bsQdXQ/QrY=;
        b=BbyunR4XUozz8pLflcsxqygf5hv31u7fXbE+Mf1yAAvZPmwVEjFyDotAyd+hKOwugd
         YuWIU+vMnOAKd2kUiuUip8fdcrSS1mEgFQd5fZjzu2qeG0VWK7tfd0Be2E0PCZSKpKYA
         KvjlrJi/fi0zJ6SaAEHlyXmmjAFY8dGWXLMWRJw96s7p2EwUBns9ENVrODpPlcesoh3Y
         kK48d34osL9eUsCI1QRKfisbCY7ZCBIh3ZRR8P9SYEU+bOT0xUdH8iUuLy3xC4d5GWWo
         ON1UZ4Q/OlOMnLm1i8gh6aTOI+x9NLyJXqHbHakpejO3gzQ8FRoiqql4Dqw7jlo4ckPf
         pSAg==
X-Gm-Message-State: AFq9FYJ764FNvAXxjczZj1NgfAF/3a4+1mqX94h+wQD7Dfyh7g/KMFjK
	ZFiYE/TaMmBnaWd2Bnuz5pSQlF/4f1f+lbcdEhdW/RY/oUFZqtLhlKoGUcS+r61REbc=
X-Gm-Gg: AYBFou32Bgwj4X3epapGaGdPr+OXWpyJB+/0NPscPiiTnyqpbr9SgiCwERjZewC2zzB
	A0qFG/9uAeEd+g4/cmOfUqvIJKetzgsn9FHDFtmftkgW2It890wEyihPKudrSG/zRH+H1wJk330
	r/lgvy2z5TN2ZVSP+V9afqk1oAddvaqhDGLNui3+rsAjQ3VkeioktFt5cbUP04RyPbCvQHYMYMh
	t2GpRHg/O0ILIXEAGOzDcF9utwgzsUjmvQPFpi+3RwwSwOw8LTAhBICTgqc2DzJvlrarCZRCQxY
	TWpgyS4G56GpxofHUugkBA8nVHi1LsmNbATT+HP4gIEOvnuqRXSfBw5TZNtLcsWbRe3OSUKjYzG
	0+XRmfTb+pR1NoSQH8rqicnNNLgk9ib5Rfcxw+dS14i7+fGEAzVWkj3yc9HLyA6Cw14w5VcdNgk
	dOvE1Gt5UgNd5eW7rgtW6SbRwDgoC/4Wd/YcpmolzIQDvr1EdLnMd31WgE6bzq/QaFI5/8HUYCx
	NgOslIBpvTQCCX5laqJfGzkCVCCzkHGjKC9MvdjuJWnfBxuaY2mJu2OrFxAd6YfZTq+e+LBc1vM
	EwUQkUBzwNCoaKW36UIBsxFS/+jpmAwgrDt9kCeoSSgAcqjK7GA4h3IOxuqkPAES24Q=
X-Received: by 2002:a05:690c:6e84:b0:8b1:80a7:4e8e with SMTP id 00721157ae682-8b2b66d0310mr14625327b3.20.1793371112701;
        Fri, 30 Oct 2026 07:38:32 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b7164f26sm9267787b3.28.2026.10.30.07.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:38:31 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 30 Oct 2026 14:38:08 +0000
Subject: [PATCH 2/5] btrfs: clear dirty blocks after a delalloc failure
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
Message-Id: <20261030-b4-btrfs-data-integrity-v1-2-f4d4196731e6@toxicpanda.com>
References: <20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com>
In-Reply-To: <20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371105; l=1782;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=jGe3+Mz8n4IYsLPfk+8VaXdP8LPMIUyVQIGydHc/Anc=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJrag5Yibv5z+IVOs3PrUrV+Y0WHH6LUiP5R8fDYQSVRLsntJtXU8zRxF0cTFrsc2MqpWwTcZo5
 qrc2uDMKFjw8=
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
Assisted-by: LLM
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

