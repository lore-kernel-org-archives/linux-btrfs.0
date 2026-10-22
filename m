Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792651060;
	b=UTYWV9UeSpTRx2ultEEkPFSskJvAMDv8to6CigiD/rqghKPwE5mOXIHqA9dllsjIvGZl
	 X2xB62P+14VWI4wXZykqJB2R5xKJeNv+3trRuS18oUTaewN7v/6W9Fq1yn6vh/4MKUvE0
	 /OvEAgQZpyN9WcGgHVvYb7idPeQNVV6m7lKbP0u9w06YdpEVl2K6Djo08jY2X0hYeAR+X
	 Fq58EaY8Pqa2uuetuE0f0tmEMWSqRP072HLHfolOcD+sureizNNCQTiTCEMaWer119N37
	 sJOZTa5qPJDyBpGuPNt54ejtNAIGTMWmkdMBZwB6Wbg7s/SXqyoYta3bt3u8p7FMRGg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792651060;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=xBVRMu56/mY43cDQhOkpF9YflX60F2p0J2gDh2R5nRs=;
	b=SBQ9mtfq7GnajTkHVlUFditYI1lM6igw7x83q26UA9HU3Hac2xFrOtlDOWSimdpcnCy4
	 i3Z1/jbqwDfUNTb7Kj3QWjxf1FGCLwcmq9VtvoDNyABQC1Lh6Tt+h20cL61TdGTkcC81Z
	 NUqS5SuLTKsq8P5yuR3rduHzqbB0cRvA6hK2dlWKj04hwxUsqizGrRTXskt//LV3XCb7s
	 4K1sY50wvLU1Y8qHmSbkAH1OeELdj5CdU0sp64o8jJHFzOHU3NVeoSwM0MYOFqw3emEdt
	 KKCu64NwFkRonaEHh7XEGgScdhAJpZQkGQ7zuIK7TFjchrF1k1dEE0zQWNa9c029KxA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="bVYahcQ/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.45
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA41606A319
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 06:37:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FA41606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bVYahcQ/
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-980c4f5c921so635507241.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 23:37:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792651059; cv=none;
        d=google.com; s=arc-20260327;
        b=f2jNz7v5wpLjPnoN0C6eS70RzzexiESsXFGtObdmV5+TdVjcVa/PDu/4BOGRx+s5Vz
         jJ2L4gvPGD/AfCKZKoW+20FtwwNELo8Pm/y19mLkoeRPg05drGgX7TxpMDVG3hSFsA3p
         pI3Wd1GxzrRetdj1Y7CZVysUCZaJyFZ7qOUp6mMj666Pme/aKO9Y13P+3efR90gpZ9gu
         vgRPTdD5hYkG1i/i4l0jnW9Fch/1k8GTQ6E11BHF5Wvb9E9JIyLXyg7YU0KFbYl+7F1w
         D4bl5eV9/Y2I4mXKuSi1Uef+49geKlcpnZFjx3sWcjgbkL/yTeOKCuM+355IWfWWO2Ye
         8aHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xBVRMu56/mY43cDQhOkpF9YflX60F2p0J2gDh2R5nRs=;
        fh=v5SypDb7dwdS4FGwcK5CeDhaQb47iUab0gtYlsnNpvI=;
        b=lIrsIlcu+15xwjLKNOPRqrLeHJ58sfs30R2mzlB4LjkApQYC7eL8HXrM3Z/T4kNVe9
         SqftWlyT/PtagU06cLldBAxmUsc4qgktaycL/e9qUuWqYMqST0CPG5snjvCjpe70CAfa
         7VqBG165YiK+gHo5pc8rC+GRLeX8aTk+zuGMasBDf/DqCETRnmN/uvX2s3kO5soZx1+N
         StbWecAJ68QifSZ0ysEme+YZIRYJmifI81uCSOFsqBv94NvMNBdMx8hyHiGIO42zH49a
         B2QVOi7yNx3zteIw9IsdEQEAtA9KhGSAZtrlNYA+6c1jcy7YpSnsd/FeUzG9GK0MYy8O
         rhkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792651059; x=1793255859; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xBVRMu56/mY43cDQhOkpF9YflX60F2p0J2gDh2R5nRs=;
        b=bVYahcQ//hhYgfXM+Y3xvnut0blzSJd8vqdBVUwemTzM2TZW4p/guvZqbL2L0qV0J1
         YJFoT2PnVBvu5g3V0jqcVUAITOg+Wsk5MO4EPoV+1Nj+SrKkB3YrlKkg0hKkfhINmMx3
         qypCW2/HlQrkXJnfI1bi2q9O4ysiM2M3TSMu56jRscqPQueoGKJ5OkIv32rc3oaNnons
         P33v7Lh4qRN8GtfqVfC2Iy/srLYx+K5sf6JW/ryrj3CWuY7kt9vaI7NrY38xCCb6JiPA
         YUsDCTufv7YoGPb7EmBYGF4lLUVKEZf2n8k7qEeucRUHrFMnzhNBU2Yfhhhc9zEwT0jp
         vgEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792651059; x=1793255859;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xBVRMu56/mY43cDQhOkpF9YflX60F2p0J2gDh2R5nRs=;
        b=Sc+AmxZ8+f0YHXYVf/Ay0lhkgoTOlcPiEYc3qSFnYLjdtRXypVpAs0Z+HU+dUOR3Dc
         gcFM8TkIwufj7Ft0+zO3hA8M5emb1FAzYHH+PtjEW/VEhcy8RoXsedoDyYIZyaJg2hUa
         GP4p01SKL9OrmanPJm8T+narFMWM5LO1DcC6j9bKW6COe5eUvThvZxlVZh0wod//4YWF
         m1IhSKlHzhZdmVu9JuUPN9Y4YCxB2k/8Q5vhooF3p4HSl4Ku5P8iUvzTx5TPwhACG84N
         DhyrnRNw0nefhpar8uny+aggjpFCgD3Aw0sFdlj95EJ3nZLYh+MNiagqwmsXkpl16QKF
         5fHQ==
X-Gm-Message-State: AFq9FYK+95tzhu0ZRtwMoojxqj7GEGMf/s2LMbqb1FlLqYDqk+2/2XNt
	S4T1CWfggZpqocYWdWn819Jbutb2SYKGYLF1NONRc84ueJvbHK2gucdacoQBXfKfbsF9FIOHXuX
	aMxxJBPWr+0AWdI5biViowbzQeVB9JzOlVWXBbeV+9w==
X-Gm-Gg: AYBFou3OcSwpX6PsmV2jWauxfxaAqSLBGUC5hOEGunIvpjrH0mPgRyXhKXBjgICgr4j
	1D/+KBYpzTwu3T/+Q9Vr3UhuIoqVcQIkj8AqzhEdWHYHcJmCZ3bihPerVOPizJiB2Iv+K0iGiaY
	aphTP2JesqRDrVqGN/gMl9h548J+GJjWlRGF95Sj1/f50T/bmjarIjEKagEHPNsIiptXasRDr37
	kcwzQUcbUi/zOzVOYZ8ScCJTVwggE/ZwogPvdlSzY0wfXICk5AHd33yHeaVmvmF/3BLt9bmiBor
	sMn1Zm038Z+71tDjehJGQ4HpJ73VU9uf//vdG8PYTCs5eQZ48ndPZ0bT+K4vLSX32ooq67MNrLq
	9527ss6QPzbreHbd7fKXBfasweAcAY4zTfxogwi2NHWDXXdW7TlGVXVZU9Laif3pfjWXAyEQ84O
	kL4xpyfKltYQADjkM=
X-Received: by 2002:a05:6102:3588:b0:7a1:f980:e93b with SMTP id
 ada2fe7eead31-7cc926b0bc6mr1352061137.23.1792651059133; Wed, 21 Oct 2026
 23:37:39 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAFoLKK+aErV4p6ZJPnVeH5SHQ5++0f=8ZgxPWe-E-CkeKBs8PA@mail.gmail.com>
 <CAL3q7H4JL0pWbGN-sQG7XCXeX60=fmxhSM-c-1xDka0eUbigKg@mail.gmail.com>
 <CAFoLKK+msAgM5tFx3w1n_i6TqHEWoSqULhidsNQA4qncK9weGw@mail.gmail.com> <CAL3q7H538OKkxD93rMZYgiwiZ+4VWwaEw4Nf+o1XDT5OYUeEeA@mail.gmail.com>
In-Reply-To: <CAL3q7H538OKkxD93rMZYgiwiZ+4VWwaEw4Nf+o1XDT5OYUeEeA@mail.gmail.com>
From: Tristan Elvers <tristanelvers@gmail.com>
Date: Thu, 22 Oct 2026 08:37:28 +0200
X-Gm-Features: AclHuK9yKMkfB6acgXkXwDN0tJK3te-fGXMw-vcLtX6HL8FAqIEA-FxqTOljL0k
Message-ID: <CAFoLKK+9bit8qe-qt7axwvR9Wc1r231DxaXsdH5bVe94wMvFOw@mail.gmail.com>
Subject: Re: [BUG] incremental send omits hole after trimming the tail of a
 leaf-last file extent item (receiver keeps stale data)
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Filipe,

thank you so much for your fast work :)

I tested "[PATCH] btrfs: send: fix missing hole punching during
incremental send" on current master (4403278e4) in a virtme-ng VM,
with CONFIG_BTRFS_ASSERT=y:

- my reproducer (trimmed tail of a leaf-last extent, next leaf shared):
7 of 7 extents differed without the patch, 0 of 7 with it, received
file identical - with both --proto 1 and --proto 2
- a variant that punches the whole leaf-last extent was received
correctly before and after the patch
- no warnings or assertions in dmesg

Tested-by: Tristan Elvers <tristanelvers@gmail.com>
I hope this helps. And again, thank you :)
