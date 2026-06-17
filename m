Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AD63BB66B
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 07:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781679680; cv=none; b=hmLK71anSeA242mGLFYUnUptJXQpQDQ1bVurkGso8BxThl7sfXbGF2VlFgr5Stm7I3HFk8ggeoyy4zb2uX2Fit0okTDExxrWBKIpgWTl056N8hTkkvqXAGW7P1jtZbZbww829gmG4WvleIHItwBMZgQ4yoTCbGNhU5Y1HDxFd0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781679680; c=relaxed/simple;
	bh=9PPrRRaTTpFl1aNSXoyMDCPawXLkkfjZEVM+6ruVlTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1UbX/Hfa+zaBfVkQ5h/+a/geSJlrW3ooD39yB9QG8AnPhyICNDDmN8jmfbzw4KduSMeOKKLPO27LwvUXnFFxq0djkzAcq/K8bidD+eQ92Vo9R4CXuei41wItoTBeUzSneNAAIIBJSRFEX4bk3A03Eh2lOJxEnjxmfAM5SH29Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XxIJwZzE; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XxIJwZzE"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bef47b1ac01so804539766b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 00:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781679677; x=1782284477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eF8NfnAbwpsNmQwl1mMyAo+lzh3IxjkBDUMRfteieyo=;
        b=XxIJwZzEQ5pXcIya6D7mpF+m6DhckIGbe5Js3A8MSpwa9jat0Q/4Mk++0aliriSQJg
         udw6P2cmD2/gNwxf0U8F2qEP9G4brsJjfuyauCJsfaZ7ue4pq1vzBLlX4ILmvhPwMExi
         CuHEYXxgYgWZGavWYByy0+590jxstA8oR06QnWxp0l9HRY8kLEH+xQWG4ZDR1Ijzrzaz
         kSxnvjQ9pySFIqczeyetCgLXtw2EA8hxbWYswlBO8aJDS1Bpa3P+k3v5gcTMC6bTo0/v
         uXRDp6jFtVgzuEjdl+H9pJU/s+3rUdzA/MmliqFzMTQaCeVX6TkDAF3w7DqIMrOmDUY/
         dxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781679677; x=1782284477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eF8NfnAbwpsNmQwl1mMyAo+lzh3IxjkBDUMRfteieyo=;
        b=RVGU7gqBPS0jFZgyliiIa28T3QSJGgiYDnQg/27gO2HP9pnPVnhPYBFNeJIMOBq5W/
         GrEL4j3wiXd0vhYIk12ZABfrn/pLx3drGFRkgTPCxxwnaqIvls4MQsPmX3Be7daRiwap
         3rdVKdSc3pR7O9fIJKIV9VvyVBoSTLObHAF1Qn56LMsNvUfTo7lcUjtC3LJ07TxFDRty
         mUz3hlaBVMVqCLZcgJiHjH5E768TwYNSCzV0ZbULL0XCRSmSmUpVWPDwnOBuCLA6d+1C
         xsEwcBkSh5o+g5o6HKeHkt6t0yGmBkIUGgB5Lkm8SNZTGi8qhu75whFGCtlX5OF5/yg2
         PAXQ==
X-Gm-Message-State: AOJu0YwNzNRMsz6d7KXsi87L4XmZQHKYVhQSyFrgyd5iKeM7+VHkWAb+
	CQUnSaFE5Pu5vHCHy0syeDEdOX/6u6jpDVIEEHHYETvW7nXYsWcKzl7M
X-Gm-Gg: Acq92OGjTvjxZdGV4PtEeSdqBFLgkxxuP0psJdJ2LonQw6g2XVWMFlXZGQ/GbgkccXx
	aZ9MMz8HmWJuLFjFr8Cls0PyLlQrz1POwRMU9TQendGhOfgSmG9x7nX2NLBbeSzGsatpGUPtW34
	ukRXvUUS0qUtsB1juJIXnCeVdl2kbqNZZ2ozVfI2uQDNOu3AINl8ZF0iaZXmhBryk44cmPxNufw
	aZU1MBPjcHK+mlQZEL1JW7J4tSnohwNl++xVDJSYVqje0CwmqbkR7N06dZP0ExPWGI7Jbn9gxK9
	7NvC0yxxqyM0aStI3uIQQ2x7Wzp7jrwS3qFkwbZNZiGkEo2oSF/aCtr0lplZNeukEdtVBq30IhS
	Tv0s1pQedAjFsudxrMNILJLeE8rgbpQuaAyp2jU6k3EwYHzQmDNYMeBrCKS0b9eYA21AxBtB9q2
	Ecal8H955ysenFfMA936hzvWxJ01U0QJ6+ZPOspGfWfWXovMxsqubb51VgmnCA2ma9nsjg7pi8S
	4Zq1A0i37O/ySwgsHJphAj7aNcRf5xz0IPuUrx0ja4tPkLdUbgsp/vzCQ==
X-Received: by 2002:a17:907:720d:b0:bed:19af:f8a7 with SMTP id a640c23a62f3a-c05a61055a3mr177038666b.9.1781679677027;
        Wed, 17 Jun 2026 00:01:17 -0700 (PDT)
Received: from arch.lan (2a01-11df-420d-6500-21eb-4249-26e3-c57f.na.ipv6.supernova.orange.pl. [2a01:11df:420d:6500:21eb:4249:26e3:c57f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26392esm50697340f8f.3.2026.06.17.00.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 00:01:16 -0700 (PDT)
From: Mateusz Poliwczak <mpoliwczak34@gmail.com>
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mateusz Poliwczak <mpoliwczak34@gmail.com>
Subject: [PATCH v2] btrfs: emit BTRFS_SEND_C_FILEATTR during full send
Date: Wed, 17 Jun 2026 08:56:46 +0200
Message-ID: <20260617070112.1407453-1-mpoliwczak34@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <62a6fc38-f204-45fd-b924-6cca98c6a2c1@suse.com>
References: <62a6fc38-f204-45fd-b924-6cca98c6a2c1@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently BTRFS_SEND_C_FILEATTR is only emitted during incremental
send when fileattr change between snapshots. This change makes sure
we also emit BTRFS_SEND_C_FILEATTR when sending the full snapshot.

Without this there is no way to gain access to the fileattr of a file
e.g. the FS_NOCOW_FL flag without doing a separate FS_IOC_GETFLAGS
syscall, which might not be even possible if the stream is send over
network or such.

Signed-off-by: Mateusz Poliwczak <mpoliwczak34@gmail.com>
---
 fs/btrfs/send.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 3ae480c7474b..effbe7ac1a81 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6575,8 +6575,10 @@ static int finish_inode_if_needed(struct send_ctx *sctx, bool at_end)
 
 	if (!sctx->parent_root || sctx->cur_inode_new) {
 		need_chown = true;
-		if (!S_ISLNK(sctx->cur_inode_mode))
+		if (!S_ISLNK(sctx->cur_inode_mode)) {
 			need_chmod = true;
+			need_fileattr = true;
+		}
 		if (sctx->cur_inode_next_write_offset == sctx->cur_inode_size)
 			need_truncate = false;
 	} else {
-- 
2.54.0

