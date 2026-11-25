Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619131;
	b=h9PzaQdClDi44sWPIGYavg8o32XDC7xdmYkwtKDk6mdGY11RQWDGRV5+i6MMKRV64WBx
	 eFJUO2nVlF6u5wIbXGWLTr3fxV6oQk8/Qhyb9HLs+WZa0WDJkts4MXZMC97Kqkelmsa46
	 MBpwClM1srJxV8j5XBId4K5DH8Suv5TMyZ4gzmv0jgu951zGA53Nv5wN77QtA8kvOPwAa
	 zQ5zGNkHtv75F9N3mTPYltnqRqs7sWBe8VfChSTzl88C1PjOsrUfBd3aXHTLu4VJ0kVCt
	 onPZrOr8/gCBvCU4YDl5HzCEsnIlzyPUCMVuttbDaBw6SdyrCT6YJqEwUOI+aIUgisA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619131;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eXjxJfCRS/6Fxe2CbAbpXoc+vr3MZIsZ/LfkrwQYqiQ=;
	b=qB30zWW+oj0vS3kWOkXLsLjDx74jG4peYUgeWzSwnglebDQraoE9mW2z+rqZIKwvpEUh
	 Wxk8K9N6x23pQEb74hkRwbh2Xkfxew89Ki45jqKJs6uZ9YCzHdfgPrEcnHh9prHl4cNM3
	 tSLQn3/wJBy850RZ+QDVEcp7PhyVSnDviX0eBDmCy98Spdmsz6F3FtqYhwICA5awCtrRe
	 uyb5ThQ94KOzNLa5KbA2qbZQ1+bJtFsuOiwVdNiLsOGvTccCtjs3WF9VwGE4TxVxNQaBB
	 X5W5N+5NmUd8+kXV0AEgObzoBG6zhpdeXvY3E8iI8eZWhvDrtWEQ8SP7vVDYL461JnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vBiEx2cA;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B4C606A323
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 15:05:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70B4C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vBiEx2cA
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4a5024b3c28so4025633f8f.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 07:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795619130; x=1796223930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eXjxJfCRS/6Fxe2CbAbpXoc+vr3MZIsZ/LfkrwQYqiQ=;
        b=vBiEx2cAKOF79O7KjIwsxXPcd29+aizX/7SON4MlRCocDHx4OZeMKpwE8cavKTtaTk
         W5vdF7lPj5qtST8UU0cGMu7eAp43PieJ/smNcumjsO30pthUU861+ecpnPiaKl13FuHg
         +KVLwqmzST0qKku9Q5Md8XkJTgDrxwTHyKRe7ADoJvQh5z/sPuwOwf3GlW4/YSflD7hL
         8qzr9atN31Iq9UvRtpSZJJhuLV7tpB2m+83c9EyEAJtmfsqkqEX/IPt5iqpaLBJNk7tN
         4LKFLTsTxp2esdpsWtKhRNdnlsK4fTGM2TSN1PyHNAbukaF/1r9DXzAOudTCLPP2AiDK
         OGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795619130; x=1796223930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eXjxJfCRS/6Fxe2CbAbpXoc+vr3MZIsZ/LfkrwQYqiQ=;
        b=X328/3ECiYLZS+dIp1eSCBcx5k4n2wHdQSyLBfYJnFSE2xuSMefJhIdDa7t6cqNv0x
         KnHPxP2O+gRTSgjtyKskau+Fbk96+fSzyWDThJxHO7vnmpPqJtvrIgOftz5QBk0hOKX7
         sQ2rPGdUXw4S6OJfr2bBVJR/YKAVGcHFIJsxm/Q/KpdbiraRfyy2QTNhj4mIb/6mKNZE
         Y97Qvx+Lf9e5cxpwIfkn5xQ0N7wcGKwXX6qInBXqQX+KOP22KjPh+kjfI5kWuc0COX2o
         eLC4JLWTDkxTz/HBtBBAX1noa0zNrgpds98WPdzqROU3+uyrIFz1/T+5GWb83MydpFhM
         p6qg==
X-Gm-Message-State: APuU4Z8xr9miokrUmiTkSyw8HO7VyzRkkWMJS+jZR0PUjG71lzoiZnr+
	JxzT6/6oIGJxxfDbey5gOV/7nR/9EUiH4V4KsX0uc9oXxNmFXKBG56p+Sa5Dpme7
X-Gm-Gg: AZFdTZeZJkum5GOxB7mDbq/2xV52TdJ9xm4zEhUCzc9629aILeOganHd8GGHO19pv+I
	8soS2BXz2nXk9lD0zFU8CXJeYx7RL0zraNyFnLG5vH9E1QLQQfh4ypGKYMqRsmGu/HKEKNKMikk
	NngJRgKdxpGNJaLQ8R3J/s4/iFHzl/kSayJu2h2H7WXaVN4EDQ/9G7fVkqr9sRBp0uwJW9FbORZ
	tPaQsmlkUbLH85sxeOWs200GI0dOWWtpkeiAPI63KsNNsrIJjSlHskHpcler8ZYMvV4DyvxJ0Wk
	EVPtvzxMH/QdTzIXG4VYOLkI+b/iECNjazk02tt4RzhCIR8aQE+pDfLwlwdGD5k8EZ8SF4CK8ie
	igEI8TT2G53N32wp/F3tjmI5FSNugJg4feZ9hDRjrWJhor37wqY/kJrRrwi2vvMWHQaL4jEoSok
	F/kaBErcv4ew3rPcj/N7YzpfbkUy+jWy+VQmcd443Dx2gs3WfSx/gS8SA3tzgXZdi845ENLO0d7
	BzOmmHbWgQTrtZp+k7Vx3yI+h5JJtvCBfj9+iLeBDKXr7P/D46OVcZrwG17rrD1cyy6o731klRg
	t16V6NKG9wFDMonTYOTj9bTKiEfW2JP9VAwGbloOytBoMiJaDi7F5mUcGz1dXsBpYsmc28/yf9B
	07FZK9DhEdtMWPqz6zlbfKHD33cIo7BkiTBYJ04dCPu4J0hmsOnq3po7uMXlAWpQLQOh8WEsv
X-Received: by 2002:a05:600d:600b:b0:4a2:18c4:61a5 with SMTP id 5b1f17b1804b1-4bb887fb6e7mr375962145e9.6.1795619129781;
        Wed, 25 Nov 2026 07:05:29 -0800 (PST)
Received: from archlinux ([39.39.175.207])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b216esm581728885e9.12.2026.11.25.07.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 07:05:29 -0800 (PST)
From: Abdullah Zulfiqar <abdullahzulfiqar580@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org,
	Abdullah Zulfiqar <abdullahzulfiqar580@gmail.com>
Subject: [PATCH 1/2] btrfs: tests: fix swapped nodesize and sectorsize in raid-stripe-tree tests
Date: Wed, 25 Nov 2026 20:05:17 +0500
Message-ID: <20261125150518.113966-2-abdullahzulfiqar580@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125150518.113966-1-abdullahzulfiqar580@gmail.com>
References: <20261125150518.113966-1-abdullahzulfiqar580@gmail.com>
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

btrfs_alloc_dummy_fs_info() takes (nodesize, sectorsize), but
run_test() in raid-stripe-tree-tests.c passes (sectorsize, nodesize).

When btrfs_run_sanity_tests() iterates over nodesize values larger than
sectorsize (8K..64K with 4K sectorsize), fs_info->nodesize is set to
4096 while fs_info->sectorsize is set to the larger nodesize value, and
root->node is always allocated with length 4096 instead of nodesize.

Swap the arguments to match btrfs_alloc_dummy_fs_info() and all other
Btrfs selftests.

Fixes: 506be4d56575 ("btrfs: tests: add selftests for raid-stripe-tree")
Signed-off-by: Abdullah Zulfiqar <abdullahzulfiqar580@gmail.com>
---
 fs/btrfs/tests/raid-stripe-tree-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/raid-stripe-tree-tests.c b/fs/btrfs/tests/raid-stripe-tree-tests.c
index a7bc58a5c..3ae103e32 100644
--- a/fs/btrfs/tests/raid-stripe-tree-tests.c
+++ b/fs/btrfs/tests/raid-stripe-tree-tests.c
@@ -1088,7 +1088,7 @@ static int run_test(test_func_t test, u32 sectorsize, u32 nodesize)
 	struct btrfs_root *root = NULL;
 	int ret;
 
-	fs_info = btrfs_alloc_dummy_fs_info(sectorsize, nodesize);
+	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
 		test_std_err(TEST_ALLOC_FS_INFO);
 		ret = -ENOMEM;
-- 
2.56.1

