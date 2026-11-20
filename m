Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207915;
	b=m0xri26CCxLxGkGp6Y3bXt2uas73h836l8jQn6mE/hiV8shyqKV/pTZraBPC3qH2ul7i
	 JAFVmdWZKeig2CGt0GKwpYXYIy5G+RA4stc9+EZi0xDb6GHAbzZbcWA0C+IPO4ZfphiQm
	 dQF3ESwAPCAOGf7u5es2CV+VmE2NZPk8GThhPYffjK2EVIvQghVXOOfkB7+cLBd0/YRH/
	 U4gE3IFpCYwcERn1XJm9bUrwxqghYbxhYkekG+ly8MdUdvlyUEXPX90gbKEzwtKjXLazJ
	 jPiW8mc5BFCh6Xg6DORJxciUkqfHRpeXaA96v2LJdJOSi5wq1EVLw1AEjsV7QOt6NSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207915;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=eyUZ7G9iu0uZKAz8I4enYkWl7REhlZiOYtfQA4gLnsc=;
	b=I5GM7Cq5vVq6lx5L/gVCvyxowPVeVC0naq09DITg21DpVVon5wNlouqPUuqj06b9uAs8
	 YBRGXVV4QUEOHE6xIig77zEeMID7agkvFpanmfzwsZGj22IM3BRk9OJd/Z+vy4sBf9HOF
	 WmLl3Zn94rPo10NROFQ4tShYqDB2Vzx3Zq5yrX2RM9adNdG5s2LdApIxa9q1lnB11GN3B
	 cBqVHan9fqH0VVTdC5dFC3TbgnAT0ZBGlgYQe5r79By60amdHKxvvoM9mpI6fXMGfVVdR
	 DBpu8CXLYVoFsiYgNxWZ5By6hc78VdT9cqPKhlHwfys3hs5+aGAePyrWNoGwMhe9hdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Z+JPX2uq;
	arc=none smtp.remote-ip=209.85.160.175
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8675606A698
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 20:51:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8675606A698
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Z+JPX2uq
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5365f9a04c5so8452201cf.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 12:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795207908; x=1795812708; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eyUZ7G9iu0uZKAz8I4enYkWl7REhlZiOYtfQA4gLnsc=;
        b=Z+JPX2uqFgQUf2qBa5aPjGm8brVyUCVrt4Uvi45wDyt5e56O1uhY6dCBzRCKTJ67lj
         S61/2kSfShOdrcbRjiMN7jQb9H/uc0Asteuc4l/pNrQIGMJZcFeDty8MaUkX+vWHi6Qk
         a/fyDRAAHKzImSu8CTjVMSeaHezN254HfpvVzKICwA/6S0M8FcdEfTojNSRoQ+VdH1TY
         Hg0oEO+EfuKw+BmX2XRpFxTfUmkeTXJQILrLIOYb/XtbXSCZyUsNojew+0q+wTjTf+zD
         9mLtnNBfJUc6+7BM+NeMOjqS6Wuaadd0l2FBXYkUJah0GkSZjyBjy4vKnL3MCzky56cP
         iCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795207908; x=1795812708;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eyUZ7G9iu0uZKAz8I4enYkWl7REhlZiOYtfQA4gLnsc=;
        b=WJ8ioNMDr6azMELZSiWIGsSO7Nx+O1+0fNhEN3uWZpZyuXWBXMomO8lWwi+sAGkQUh
         aKdIdX1nQSq7+d/3JITeq8GGjRX2/zSXTTml93xrNgh6RxSVa+x4+Vk2wCf6XXQV0vq6
         zFUncKb4+sli6Ex1FDoIqMQupdm/YklBoqMtIQfHEGljynUX9fYby+O2VOVxCV0a1gii
         ywfo80RV0z1ybDoFG2J/QXo3NZyB1lSEmhAA/4/s8yb0xrL95D6BjWcQ/OdlRxI0bhhs
         BbW5Jyfz2m09MKbDXRqBuwO1ceSW2dzcc9nXooSZMGfIlz5yRbP0D050w8kJQGVtDhA/
         NFEg==
X-Gm-Message-State: APuU4Z+7XlZkx4xXAwYfmj3P1d25q85BjeeAjch9RP7LSg0u5TD92u5F
	sQmw8ou+BcjfP3dhag9e6AObsp9VIsaPW14lxI9svSDa2yfnTSOyuyxaeiQX+9q7SPg=
X-Gm-Gg: AYBFou12iRgK8cAE7MBq8lkxCCu4MBgiqA3IdnG7fR+oJkdEHJWB1VFc/A/RjiFQP/g
	Ddmf4GOKlehmjO4EzDMFDm0fSnAuPUeYfxbe4hnt5sIlrJGRwYSoYvaTGRZ6e2fV0wiKdMbnzgP
	U3lSmoLpn8dlEJDgsB74NPPAN4h9TzXxKsoEPMZsil6rRhvcamYYbsmwGCZZFKICzTwEraDSp/o
	9ecXfSgvo0zYod/gDbUKYkohSBAeornc7PRZuWyBGTn3KrpOXFhrGJc86+pQdXajpfRcaMws//G
	5MQNT11XgNnC6T6sm+++HfYM0Qh1RmVXhKOUV1X+zpu8u3J6lUronteXquGz0S8CUiK1xrb/UWr
	a+w8puCDgyv1epm59L5GLmZx3uR1YmWLaWShO6sB1q4tdw+QkNO6Pa2Q4okJegnG/wikK/Z9VoI
	Y3hLaeZ6Oc4q83hzi46zQc1Xwft2IBcPwrsj9XeXW0XkaywwiviscUh4ZmhyX1pxuF5+UYnuDiz
	uzUNrIklvnuooxY44lUIunxvHVfRZvFSMbZVT6LIwII1bMkwDpHw8riUZ2FdJ/oZaWk93awjvbU
	tMnBc69PDYXpPASWjEcSd0wm+GupDm0/QrmEphfRf+zrKZs=
X-Received: by 2002:a05:622a:684d:10b0:55d:7c14:85aa with SMTP id d75a77b69052e-55d7c148660mr42515981cf.51.1795207907754;
        Fri, 20 Nov 2026 12:51:47 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.243])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d784517casm32269551cf.3.2026.11.20.12.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 12:51:47 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 20 Nov 2026 20:51:30 +0000
Subject: [PATCH v3 2/6] btrfs: clear dirty blocks after a delalloc failure
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
Message-Id: <20261120-b4-btrfs-data-integrity-v3-2-4de4b91b826e@toxicpanda.com>
References: <20261120-b4-btrfs-data-integrity-v3-0-4de4b91b826e@toxicpanda.com>
In-Reply-To: <20261120-b4-btrfs-data-integrity-v3-0-4de4b91b826e@toxicpanda.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795207902; l=1729;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=lfsEFhyOfftP+0hFE5S+FeSjbmCQrO4zPPBNoXWEW6o=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QFtUlv0JwXDje5hCiQ4tr67g5MCERqnXG7hDBVQQQO/oSjgWiz+GtFA4bFxsNxd3z6def3tOsXI
 hhpioHWyGrQ4=
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
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent_io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b2739838c646..036d8c0f04ae 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1746,6 +1746,14 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 			u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
 			u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
 
+			/*
+			 * The blocks are not going to be submitted, so they
+			 * must not stay dirty. Otherwise they are written back
+			 * later without an ordered extent, or worse, with this
+			 * one if it is still around, and invalidating the folio
+			 * would account for them again.
+			 */
+			btrfs_folio_clamp_finish_io(fs_info, folio, start, len);
 			btrfs_mark_ordered_io_finished(inode, start, len, false);
 		}
 		return ret;

-- 
2.55.0

