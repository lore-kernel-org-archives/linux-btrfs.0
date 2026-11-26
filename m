Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795684556;
	b=2o1LCPuNZFPOXBB0rxGfY64NDLWZbVY+us8XWi4tfoLDyYBEVhevLhOfGhZdlcDWOUio
	 0IERMCK9hL8ODNlhaXIw2iHvN10p6m1EH/sn1JTj7PhJKFiPYDgU5mjiX7ysXvxbdGJyQ
	 1HfzmHS8Qs1AvlFPKmN+GmmZL6LvJxZ1SqDVvXxrhnwvL+HGhrQIjrAuiYVAVLDkhlpK5
	 h3pV4DoDTEuoHjpm0PrwgZX6Sa/jHExJwyCSmG2H9spywlltIVX2FTGK8k8dnSQJpJMOQ
	 FjEse3QXGIYylidfaYMb0yELTzMFdXP5S8t/vFCh9YPIxFc1HUaHZjBUn+Iy3vmQP+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795684556;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q71TTjDkXjBKcW5UABLA41XuDBliE+sW+QxRNbEOppk=;
	b=wcG60e1F76u8vjf+h32QbU1KdGk8jMva5oMPpMo45HET9Q8fAV3sNBS5c/KiIJyD8LBM
	 l/ZtqRlehQPm7NKaBTy2SYJWkvCUOvY+J1QeF+3UPI7Eu5MP+c/bqEyvVlPEUEAVqY9EJ
	 6ZgysTsNBYUMgyX2nOyz3jWZDqS0eXxW4RS53AWtYPb/QML7J89IBCr3HllDoS/vpGtB4
	 qacW0RVx8qGCQOoMHUM94JdFWmjkoTlNapazzrmjX7wsU3VH9dw88Kildtn8tg8DIiP6i
	 OtJaJUgIYgpbhlpSh9BRFFKrXvyX4ei6R1nKLtwy66BOwiqCZqhC+ufvmv72HQvu9bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iXRtEGBh;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E877D606A327
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 09:15:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E877D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iXRtEGBh
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb85e07aadso83158045e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 01:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795684554; x=1796289354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q71TTjDkXjBKcW5UABLA41XuDBliE+sW+QxRNbEOppk=;
        b=iXRtEGBh+RVzlAfLRHZVrhR0VCxlzyX7g1xB3gSVv/NoRVsZ+lXMHswhQ7l3LQq2U6
         RfpCd534uGrfaXbD+NBkHy1JWfqW00Vyyvm63p922wRZNBo+ImQLzZfje6MO1aFxa9YK
         H0S2vwNLYEzIXUbF+kVtl9yPdlGjFFRdpjnOpVYxC+YE1Am5+HFCiu9j8F5uYIORoFbJ
         An39+3fRIbvFnjY0AgGe5UC3PJWytwqGrI9oojnELC2umEwtFZ+TsewIbIJLulVXlxOu
         EtUvQKn+hpLMyEPdqyHWmutIknArqhgXRtKs2dJc2scHnMyRw426A4tk9PRtXHil42nb
         PmgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795684554; x=1796289354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q71TTjDkXjBKcW5UABLA41XuDBliE+sW+QxRNbEOppk=;
        b=eWUO6KhpJ+iVedVr3Qm9Ys+65xRvMH7D7QfV7JxdFWEY4rrOymMlvISYPL0dioGUQ7
         GtM5t46h7sfJlQv6m2R/+vqrMQg+Pu7WfcNnUlSmJactpBJS1Q4gx8SJuevfPghmC5Dl
         SJJ0QffIZw7elKEpJ4aow2IA5cz70VLqqwEEEjyzHSi3OfoCFgAzley3nSvlFLzW+7w2
         P+kYt101vubOMdPWRZJdr8g8Yop7JV690s41DFoYA4HVDWOAwi97LkyjXiaq/HCPyWmj
         LyecK9KaqsGnCVwoMOfC7NE459pf2+w3Rud7ue0DJw3Pys49+2LPZb2FBmoggxLzT2Ki
         imOw==
X-Forwarded-Encrypted: i=1; AL+hErGfYrd7Tb8JQ9iJGFVWh3GjDgtdm+YEtE/87yo6FZaLTJVRSiKw7MWbA8d9PpXhL1QpC0ag3Htv3DHpzw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/RYs8HSrDZKp/8wYS5N6XiDTBUM2yzUylqGWocwVUbwPfVI3U3
	srsGIgZk0SINi3XXS3QVTOCbjVkAXYQWGy5vHBwBdJwPaeCIoA7dk+VF
X-Gm-Gg: AZFdTZdmE75SyN8y882V3HaV7cDvCcMY5RvHCwdsMjhKf2y7YNybRBjKGAL+97TyZWI
	sh+ldBz3Boep4yF9OVqVZupGgNMpPC3VoJhB6NuG14q0V6rwE8ZKOCCm2yrCmCgYDnKcUmWgJwe
	/AIXVskDhiGo1ZrNGIPoC+aMidyTl06Bmg8UY+PTlfm420wsBgswvlj5exzboN8KWeh4qIADCbL
	hXFlavUFbxGSoXm5vo+1PrcL/R368vKLUmGf8zCy+aNHYcC/2+H1IgqpbZtTNwqEgIn7fLy+gpi
	9vKtuTUnxNzMKBQWHVkU8R0VkQZ643gv7+d97pEcR/ukvn4aRXs3BwBHgWqYQP1h3Y3IyTKQ3Ut
	WvGZABlmx/ZjQ5SKqx00syUTFNoWUx9Z9n6oY0Y0ARd0MlzIdXAMmcrJvqP6OLfawzXFnkwBsua
	81gRUkRKS0B/NRMcMP90UdWeILhC2Uggy10UXt5gfeFOtUy9k1brqdO+17wcKSSqWzaefyoFmHT
	vHvDPxAricH5u89Uzl4LeAk9tLEbL+j4Xqsov+OKfG1n1HkFIxeBwZ67sT9V7r2SAKPyqMT0bZB
	0rWjKk6fkKq5yFf7nJ9RrAwR09T0gtM7GurySQ7rPJuNLo2OGJylGLWnXVDOn+S834lza8Gq+52
	rWi/gOD7P/ksvLb4UriML0LNZlfsAK5k8TzZUtevmDaq7ihXeQzNNv+mMM2ck2vMYaV5WjUEh/m
	+MGwwIpJin/5bZN5ZTx/vDpyXO/l6I7ZQa5bakUpd1Dk9yzxigBl+B7Q==
X-Received: by 2002:a05:600c:4f50:b0:4a2:1612:637a with SMTP id 5b1f17b1804b1-4bb888063f3mr512074995e9.16.1795684554127;
        Thu, 26 Nov 2026 01:15:54 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-7575-e1e3-dbaf-96fb.ipv6.o2.cz. [2a00:1028:8388:a84e:7575:e1e3:dbaf:96fb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884ab091sm834296635e9.11.2026.11.26.01.15.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 01:15:53 -0800 (PST)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Qu Wenruo <wqu@suse.com>
Cc: u-boot@lists.u-boot-project.org,
	Tom Rini <trini@konsulko.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Bradley Morgan <bradley.morgan@linux.dev>,
	linux-btrfs@vger.kernel.org,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: Re: [PATCH 5/6] fs: btrfs: Remove the unused dev.c
Date: Thu, 26 Nov 2026 10:15:52 +0100
Message-ID: <20261126091552.76922-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <56a63ebc-1d33-425d-a11f-6d7c73e820be@suse.com>
References: <20261125124259.95636-1-pepe.schlehofer@gmail.com> <20261125124259.95636-6-pepe.schlehofer@gmail.com> <56a63ebc-1d33-425d-a11f-6d7c73e820be@suse.com>
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

Hi Qu,

On 25. 11. 26 21:14, Qu Wenruo wrote:
> The removal looks fine to me, however since there are only
> __btrfs_devread() callers, it would make more sense to rename
> __btrfs_devread() to btrfs_devread().

Whoa, good catch, I'm not sure at the moment. Happy to leave it as is
for now and do a follow-up once it's merged, or I can send a v2.
Whichever you and Tom prefer.

Josef
