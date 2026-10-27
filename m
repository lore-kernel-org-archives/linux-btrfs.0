Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793092633;
	b=iLsZ0dHiInE9tMV3A5w9ORrh18MgeDAErr2eUvrBpPgWoZxbTUtlegBEinGtrJqdfxoO
	 kbs0GhvNZDJd21zPHL+6AxTYZbY8YipmFSyG+eVixG76v4IG25J37OOnjrfi5IKdNgHoN
	 g3RxjfGOMqSieoGrRM6xskjVEQG2ulyGHE4YWM9WND6lg3LFr0mM95JgC/OEwRvqZhClv
	 igKyfaAtOqvtqHGjeIbM10p0QObPnmVQUZhsOmiEMajFOpGI3awWeEWVMwcJsabkfm0Gh
	 mPPEX2GymsaFDgzHlIm7RLnPZKK75awDN6mgI0ka/7fuWSMvime917X5xYnH9nGypSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793092633;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=a8wWpQP1oajq22dVnPPqkp+31vo51yEFFkbppanBxzc=;
	b=j7QG98Mgz4xH7DqgpqIjAz8YxF4O7yTzvzgOg9tu2UHLbHZNZRU1xS/Qxic3sXvKVxoA
	 W+XnBh14SRtgVTDgXdYPrFDIQe6xe425gkxkXibTd2c2nQYxYy/+6z3pUW2xFJ+TDGp7c
	 dydxPlq+8LUQaKBFOKysadha7EaJVix+4MdYZTSmgH+oiWd4NMEdsAUeAQndwiT9/+vCl
	 gU+PdevO+tdcd0r84uyj032u9oqNN2nnqt5AATqwQgdCmfSVVlvec3K37c1xXrTTDlyiI
	 vOcsnGPfe4q9x4u8YI/9gjmnPIs1xEMnWn6wxybSiES93O9tR9xfSj6w78jNlLbsMEA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="VvbXV2/s";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B77606A31E
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 09:17:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32B77606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=VvbXV2/s
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so17942905e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 02:17:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793092631; cv=none;
        d=google.com; s=arc-20260327;
        b=mapFVeEL+3Y4U/aYkpF4e9wT0C6QTXed6h0kIA9Y/ceottlKkZK/ne4ff53tIuAOHl
         QsBJVkqEDGNUnrAvxpTf/Buef+jWdsIIPk8+/QTInvc1r+ZRwOBOav6+O7TDRp+S3Uy9
         ceDim7YLVyv1txhYZGt/qLq7q2sFJZp9kdrA/kGR5V3KrKzxPimSzP/i+VVO2VFoiFr1
         sbYOmrChePW5kttM3gW95L8yJySVff/rCryUuc7lXIy7qNZfRp5eDw8U8OeMSMu7tLZZ
         UMxVOpbtJzyf88+wuSCwTNZe28JynCIAGSQ7bdunYsbmbM0pH4ft2ZCuWEhHC8fX0Xss
         Cisg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=a8wWpQP1oajq22dVnPPqkp+31vo51yEFFkbppanBxzc=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=Mrv4NhssWSGjvM0EArzq+Z2C1zU/b4zcNZG4+aVnnycM0akqJ4RJ2HzBWXSXQYlA0L
         r0bXYyZvTbgz9MzC9OXKTTfq1J2+2P7xnjgiU1zhtXcQqZCeDyK6Ae/xbpukBmTToPt6
         JAaK32AJfwqTUBs4rbk28GyFL0qyStX8jZE3H8YMbxI/AFtFu+Djznfp98PHqbbCGo3M
         g9B3sAJ9DcFkR1/JeTcYUVBPNhbwRYdWVv8fb0oXG5QJsD0oqJTawIh51hcSz5RXof61
         tB8jaijYtLknhy/aA1agWzIsEgRHpoTiIUTnUi9M3CTSbFPgNFDDILRb8RpitKelpsqU
         9ojg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793092631; x=1793697431; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a8wWpQP1oajq22dVnPPqkp+31vo51yEFFkbppanBxzc=;
        b=VvbXV2/skPWdiwtu1ycSKx5QW59cD/H46tr0GfOOv7zWJm70jmKKRDH5t3yxedIkGN
         LAfogF/zd1MRcdkLxNyu1lMON0t/cqglU5iERMac9zk/EZivHXL2H8J4Xvq3h/3Y1z6a
         ddfstXfAo5Xxofl0nQN0IjNUIYDFRumWwimad/w5nA1wX84sQHrunDl6Oau4VX70gu8L
         3ZN3qfb59Uj9nZEtwVIpNAevVRq48C89AObW36vg5bwW9K2oXME17ZgreMkCSlTCR/e/
         6RSNQXKZJlWQrLTHv3F9T0CHuNkvpSpbKM1DjpSyjJrWwxX+8EMyCoT1jXca9MjarM9g
         /9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793092631; x=1793697431;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=a8wWpQP1oajq22dVnPPqkp+31vo51yEFFkbppanBxzc=;
        b=ntp6Be7oG6LE2D/iVwa8fe2kZ1AeW2BQk/bSkyDkCIcPQSdYM8HNOr++E2HPyA+zze
         PEraCrPeHLwyYHvKv+wpsvvwGYF4jO4D+TtMofSHD9ra3dhb9VsCin+3u2LNDMZyS2Bw
         bP/ImyhZrREPoRFgecdIQKZzN1jIVK1syLieiLG247i1nsf7gNP92u9ybY1yfFE7byDK
         AFdbV1ZX1WxmNcmrixPaX2oVulOzgvSWZwGEusj3FVcmI/ulSqRBJafdnINiuQobigby
         pvknI7t1nIERwlMXpMloiA9p4+HSd3Ad3UdKNJjkqsFQATK/JkvFZNh16NzffaFW5cNb
         wGUg==
X-Gm-Message-State: AFq9FYLVjJDLanLfZFTAtn4aBSsqYC5mjLpZHhDKNDDA705oXrgHEpe7
	l1jjZ3UinrzSAzlWSY/M1eQekPFGh8VMUyRMk3LBBVgID/q912gywNMCD5qaEyb1jCz/ki2trGJ
	YVK7rsevwFTMHhWwMEdENw+fW8FGmbilx9IWbojT+ng==
X-Gm-Gg: AYBFou2MGZZhfQzl69ijfZPCMZjovpIGEGtf8Ua3sGnmjLNZC49aqRISvfis/vL14b2
	ALI0TE44dwcjTqlp/89z/H2M3WC+wNw4qfE2kZ9wgExNTMUx+becenZCnpv3qm9J286IQoWKMnW
	SSgD0nPHuPTYj8brVUMkQJSCIUb8qhx6Hf8fOQYDTI/q0f5um1X/wAqCwc7WrSFsrHRvGPI7CUN
	phLWGKD1hu+bdyHgnPVmfQkU6xC/j9kyfgoslFEDmY1LgmU/RF5XNWZ/GtSAUL6DuPTq37Dhu4D
	4UUGW0T+Vxt318domctdJ1GlkU1nxehAcwDAl/gFFWo40TC9qdJOvCbNloLaPMDIZw92lopBKa0
	MdpzEWPta/JNIMzmB2vi9rNHdJJNT8OgJW/JCifmDaOcrWFA6Bm5EJSSxXzGFoAS4vJhfRBX9X2
	P/EefsjJtvGTV88x87BH3wUwogQOPN7ld7Ww==
X-Received: by 2002:a05:600c:c09a:b0:4a4:3a2d:15da with SMTP id
 5b1f17b1804b1-4a43a2d1805mr121801895e9.15.1793092631146; Tue, 27 Oct 2026
 02:17:11 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1793090084.git.wqu@suse.com> <06c3ff42ede1381ad1fa5168b22dc1995abc78f6.1793090084.git.wqu@suse.com>
In-Reply-To: <06c3ff42ede1381ad1fa5168b22dc1995abc78f6.1793090084.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 27 Oct 2026 10:16:59 +0100
X-Gm-Features: AclHuK8dhsKUhhlbtCsnbBRHuUZvPtDdDODdauzLmPqWqkr_M73tmycccZAEncs
Message-ID: <CAPjX3FfVnjtKBO1LDiYXZpqHybDsE2R6r-8a++S5Z1-VR5Btww@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs-progs: gitignore: add GNUmakefile
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Oct 2026 at 09:36, Qu Wenruo <wqu@suse.com> wrote:
> I use GNUmakefile to add extra compiling flags without modifying the
> existing Makefile:
>
>  MAKEFLAGS += -j12
>  include Makefile
>
> So the GNUmakefile is more or less reflecting personal tastes, better to
> add it to gitignore.

So better to add it to gitignore I guess ;-)

--nX

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  GNUmakefile | 2 ++
>  1 file changed, 2 insertions(+)
>  create mode 100644 GNUmakefile
>
> diff --git a/GNUmakefile b/GNUmakefile
> new file mode 100644
> index 000000000000..e0eaca65651c
> --- /dev/null
> +++ b/GNUmakefile
> @@ -0,0 +1,2 @@
> +MAKEFLAGS += -j12
> +include Makefile
> --
> 2.56.0
>
>
