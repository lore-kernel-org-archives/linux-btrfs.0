Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F87C43C04B
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 16:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772122895; cv=none; b=CZDwPelreo0v/OK8CA7h4qvx7O/LhIDctgK0AiUeK+pabdncgi3CQrJ6FRZLbAu3X8vvDwfCttG4YVHjmKgJiCLwBtpGW1IQeDZwv3ZbIC1+539mP6hxzeT2DtBa5k3pRQdi3wlrWwlm00MtoL7IPEA72Pa6GKwyI00vH1wk6lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772122895; c=relaxed/simple;
	bh=pOav+RWUo+tIL4K3WyminI+GAIz3DxvGhLgbVk6hNqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mc+rsGblSXx5GgdQTe4NW6SXEu6WrHDCltmKtacWVPqarAarPiXFF7kYVAXnNHXJGebxhMDVU9r2lzIIICqQkCydjcB50JMsaYA//GZDVP9AWuRudjj3A0AS073/FLDx4emnijfj4BuUj1KRWNj9irezlfUv5HstD9gDOh3H7MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dmniOUpY; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dmniOUpY"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3870d178a9aso8007091fa.0
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 08:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772122891; x=1772727691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9i6OR9L/2JEII0FDOqkHjM/vIFngVooiK7atGXQPLJ0=;
        b=dmniOUpYx+QG/fobn+vWrZcCNwyYex5AKcZV8leRniz7ef6f5ie9chuPuSMWg/1q8Y
         Zg58JvW22zSwnbvnCPQj7YHpwPS9wPKyjo2zmFWs59P7BhEWLzrJDRxgAfIhmQDNacUo
         hyi9kyagSlxkccCerwLf30Uh88gfSCN1+K4N+tyWFj/4Ef13tNAhSj8Gyp8Enj2jnoZF
         J4Zsi/HEu0Y76niW3yNgjwZFROYpargXPHYyfTtj86o2sVTViqyzERJvf7LZMLjHwQMy
         9e/vqYhi5pD7mFJUmL70QOzCY3AcOkv2PJrbTquBhtBxyLbjXoLeEGeSisgyjowCmgwu
         8vYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772122891; x=1772727691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9i6OR9L/2JEII0FDOqkHjM/vIFngVooiK7atGXQPLJ0=;
        b=u1W521lgpKsvzeJR2KymW5gHNrVkwSozqh2z6AL/UCpI20zvhGoYcfpb4MzaOOgQsS
         GpqMJSwsO+EhjPhQhIN0GqMo5NxXhrIjdu94LJtzbr2kmoY4oPTvIwKxwI4bwjdVQaGg
         DMA7y665cEx3EcVfa40Vd9I8/UQV2IO84Y3W2H9wo3XlViB29EL4EvjPTv0SLQoytUS6
         D6bo4wIkM/nww25ueiosFoOAz8Tqk3FGttxT8u+Y3NO3h7eNU3YrsTHesEInWbGBJBui
         ZqVgppjWZd0TbVgGD9zRw9bpHIaWuBdCT6RbO3/LVKiv9dTl2QHCvCoBhGmuBHBe4yue
         TfQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVP2kHjMPJcN80oWFRn8HLVlaMm1j1ArD1upbM3v/hmEmup15Kv/5AqoZsJxIoVVf5C8GbS3Z9gojAhCg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+j8DguaFeYcNPL4pEyeWHXkwP3T8hgNCsNx33pDDx8Vk/iSU1
	93+fXDSQFvaibars00DTos5T8dX81kcTr4noSDRwG3eEF79TYKfh6LQO
X-Gm-Gg: ATEYQzy/+cbagNRtW2BwFv8zyZcaMtWk7usCo0MOu+Ji9wzkJhdtOh2TrPqCRWm3bL2
	u6brib6kGikQRawd/cXEOL2X5/CSpGKEqrN1q2vkeU9J7/RktIu3x+MnfjVLTR/6ZmtRzXMv/zO
	6rJEGK8RsTqel29f/8QB+JU7QXZorM7qie0YICKBVh1ulUDnWarGm5oDPBiBSMvyXRzJWlUvQGg
	7pTMgYOaVbpDgBgfXNOMAHprEihvF6/cy3Muhs35J9jlGNVuLot+N0NuiVlxr2tsiSXNJCGVCb3
	zxZ2SDVoBVf3aM4H20FEu0s6N8iUSLj5fsJ9yzsQOgihUjk68D9nFLZvjfzc53/y2s2mxh7iY9n
	deVpeszkw4/7/uuuQ7QDUNxT3cnAEZeR5Q7O5vRbeTHZHJwzA4tQ725eDqaA2IDnjwI22CG6DKt
	yU9Xzpyf3rHkm2qCfos1VFd+xw5sEsw/70bQ==
X-Received: by 2002:a05:651c:4210:b0:388:3d86:473 with SMTP id 38308e7fff4ca-389f2f55ee1mr7937691fa.9.1772122890871;
        Thu, 26 Feb 2026 08:21:30 -0800 (PST)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-389f2f4b356sm7855121fa.2.2026.02.26.08.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 08:21:26 -0800 (PST)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: harry.yoo@oracle.com
Cc: chris.bainbridge@gmail.com,
	vbabka@suse.cz,
	surenb@google.com,
	dsterba@suse.cz,
	hao.li@linux.dev,
	leitao@debian.org,
	Liam.Howlett@oracle.com,
	zhao1.liu@intel.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-btrfs@vger.kernel.org,
	regressions@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: Re: [REGRESSION] kswapd0: page allocation failure (bisected to "slab: add sheaves to most caches")
Date: Thu, 26 Feb 2026 21:20:52 +0500
Message-ID: <20260226162052.36121-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aZ5aAlDDpUoZxx_g@hyeyoo>
References: <aZ5aAlDDpUoZxx_g@hyeyoo>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Feb 25, 2026, Harry Yoo <harry.yoo@oracle.com> wrote:
> Slab fix is submitted here, please feel free to test:
>
> https://lore.kernel.org/linux-mm/20260223133322.16705-1-harry.yoo@oracle.com

No page allocation failures after 33 hours of uptime under normal
desktop workload with memory pressure (64GB RAM, btrfs + zram swap,
Chrome with many tabs, AMD GPU).

Previously without this patch, I was seeing failures from both
kswapd0/btrfs and chrome/amdgpu callers within 10 hours.

  Kernel: 7.0.0-rc1 (commit 7dff99b35460 + this patch)
  Hardware: ASUS ROG STRIX B650E-I, AMD Ryzen, 64GB RAM

Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
