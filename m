Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793036389;
	b=b5VaNaEOCdQSfIgFaWOyEwZcBn1y2LP1IZkc8YVLFMliqumbm677O9Ft7bujJ5gI0q6i
	 uv5MxCEJ1+3JevcbM2enyGKIheUChXc67banzUuqbaGbiav+tPtGotgAvJP7NM/hYgOk7
	 g10QEkG3RNp8UDX+EqkyZROoPwOR+Y3aWW4lmTCvpxEgBQch7v20BGwL4fnMcsUV2Q3Ie
	 SMSf+cfx71BSvbPtqNJQK044T/Gw0HIVdTdklK1S5Vu8JbR6evMUMo0hJaFZD9S/e0uqc
	 +cQF5UMHI7Y3wnAdBP7ds7Y5dgTXb0AIqs1OfdXcX7BK+Q/cC/9/ST5wBoNPEShoaBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793036389;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fRTAWqEjvVz8KUXTimD9RCBVzGEPfYLKR25PrlPQShE=;
	b=DaNEsDap+6Ounx0Tm7a64FgmVYzqEZo226v8sTxJVTkQ0PkrkbMifmcfKSSFNIHY0WKb
	 NtBGXuYMwdb4PTk0wMcajjrwjG1zL397gGzbr4KA3KYbr0Gw0AD120TTjTGseLKXUPAt8
	 aEmuxnNRj3m/4Fj2BlnLMliaAFj6DmidZMxxeeIIhteQRm9LSyqq8lH32GehOeOOEENNp
	 HhRGI/EYZHchmRuZt4hrHkDIahf6RlkVQnp460vcBewESQlVgQsTBCFk3o2Gd7qPR9cQ3
	 sZHx/wXxuiHsUxVvgD6QWJrID4IyNmGmpVdXzOK2cLWqHQC45fSy+7ZpgY+MjdnZmyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZTkYaidy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FACA606A31A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZTkYaidy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F84B1F01825
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793036389;
	bh=fRTAWqEjvVz8KUXTimD9RCBVzGEPfYLKR25PrlPQShE=;
	h=From:To:Subject:Date;
	b=ZTkYaidy4RoJnFQsz15/cQJXiiMj8BWWZzJGgkse09OQEUDwPSO2sl4VCVopZhO6T
	 vu+8aRAVfLrVHpAlcbXzdRKJpdCUx+lpL/tSTzwtqHFt36HWvE+ip6XUwan0e8HxjX
	 6USUrZ1xjw8IAmPR4sUyC28i3W+XeAftitP94G1/SWTSlD9RJSddMUHttrg4HwUfEP
	 h0ucvYBtPHOOy6YmVcaPYW20kSFJeWIrDrq+y6W1d+AZ2R0PlY0ASiChamBUIzlt2w
	 1s4hSY5YxyClivaIjWxDuly/JEzjSw4wIUPHu/Mi+TxBwk9zMOSQOwVPW6qDubYdot
	 8dZWSdBukxKGQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: zlib: use memcpy_from_folio() in copy_data_into_buffer()
Date: Mon, 26 Oct 2026 17:39:45 +0000
Message-ID: <546ae2935e37e248c86616aa0cb6a00d4a1547cd.1793036271.git.fdmanana@suse.com>
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

From: Filipe Manana <fdmanana@suse.com>

We are manually mapping the folio, copying from it with memcpy() and then
unmapping, but this can all simply be done with memcpy_from_folio() that
is provided by the MM layer. So use memcpy_from_folio() instead.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/zlib.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index e995d0b1452b..1f2a91f966a2 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -122,7 +122,6 @@ static int copy_data_into_buffer(struct address_space *mapping,
 
 	while (cur < filepos + length) {
 		struct folio *folio;
-		void *data_in;
 		unsigned int offset;
 		unsigned long copy_length;
 		int ret;
@@ -135,9 +134,8 @@ static int copy_data_into_buffer(struct address_space *mapping,
 		copy_length = min(folio_size(folio) - offset,
 				  filepos + length - cur);
 
-		data_in = kmap_local_folio(folio, offset);
-		memcpy(workspace->buf + cur - filepos, data_in, copy_length);
-		kunmap_local(data_in);
+		memcpy_from_folio(workspace->buf + cur - filepos, folio, offset,
+				  copy_length);
 		folio_put(folio);
 		cur += copy_length;
 	}
-- 
2.53.0

