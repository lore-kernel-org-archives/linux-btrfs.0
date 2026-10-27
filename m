Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793101585;
	b=eoox1UJz/1Mhu65Jvz9uHne7myGkkLPdzpo30O3q52tuGio91qHa740nfj2xDkHAZKTn
	 MaV0SPAKvNKn2aR0td2RdTbSQEvpMrQ5tbXKLFTzxWA+l9lEFGeAlg0cSfmxYUn5N2Ffv
	 bQm+91pduw7V6MokbJcqXfKBIoEmZca4RiE9jU30zTocJCjaz1WHnHZQeMZJEzyuU87Vf
	 EY3rSS+NPAF1uH9I42QXT993fRrl7qSOuaKG23/6fnTWMW1JK7NTM9iztdZe65JCT0Qgb
	 wlmOyRn20f8+YOGoxL5th1oXUr/Y/7/MspwfKiO3KQrHXJG7mS2y7a8B23UXMkYQPOg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793101585;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=uquc3keTWvct/whTSpSvOimDv/crOMpbNcTOz3mLlLM=;
	b=EltcdudHoav7t/xkI1AB4kODnF+Gw55Wc9K1R7KoWc++6D04fPbv0VxAVeDVb+MWC9jK
	 awm2ZG7whJE94Ih3nYK0oWl7Jka47XeyQDK0QjcvnKkZNLqqFPZCZs1U3vjccwancSubA
	 tq/KTsULveB3ORHiRkHeY7wRjFbfH5PHGC6/zBjStDP5uiZewze9DPHy02BOyFEG45vaw
	 1A34OSQAFWLmgNZalvqU5Xw/pT4e8mwNtTkZwglZJft+Ck4V0Q3YtUVlNrSlL5mqONlBc
	 KjBdqRB0XSy33qOdaT53riC/OHFBrw6lojNO0jNZXWEU/m2KURNFcCOLNfHqNx38img==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=en+zxM5N;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D909E606A339
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 11:46:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D909E606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=en+zxM5N
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e0d1da913so835389f8f.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 04:46:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793101583; cv=none;
        d=google.com; s=arc-20260327;
        b=WYbJuQV6ceVSwVzv1j/OKY8wUU77aZC2IsawgGNwxwDPIAlmWlVYjRpg1BcbN24tKy
         NPpolAgVelDhLi5uNAfg4mdrNbpwfdl0GvFZ39chN+t+LmS9YdNBjJfAJ6WBs4j5aM/G
         d13zLsYAr8wfscFnJ/2Nvm6bRAMuW5nXg7sa081d8isP5Mkc2h3nmxufPOliyjQ6JfWI
         30sbJboKyW+irO4vL+AP6nkZNr3Z7OwaBmkdzJuARZQYC68hkcBUwyZvVUL02SJldj34
         2r8KlugpsVkAteGSLAEcRqRgO5KEezWDuxql7OWE3YIH3q7FHDxEHUzmcbACbv2axNSi
         2RGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uquc3keTWvct/whTSpSvOimDv/crOMpbNcTOz3mLlLM=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=SP5P5+cVJ5G8TzqySxvcx6iWKJmMxmnJNRQhOlPNTXdBszeByIICCCo0VNYwdTLazw
         z/1vjo8+TGafNAhWUv6WPqDANqt9nZE4ppaXg4ZzaHiDMtLkGX7hd7z+c7qaDSOS0Hy9
         OOpeHWCJGtg089Hs2hXA6B7whcfiOFbY7o8yWa+Z1cu9bheuES7AJsKs5XwJRAi/VmTI
         UhEQwypP7qlkEK71x4j7/cbSvIMOWq9znPFj91E1rJR4+eZSz+vSD9vbZkyXpSs9u3P8
         3sfj6ZFe2nYXxvq/fN6/Lfd51uwXnTSL1p98bwmqL8MBYGqvoJ7/AQzLyWneE9gojtQR
         snfQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793101583; x=1793706383; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uquc3keTWvct/whTSpSvOimDv/crOMpbNcTOz3mLlLM=;
        b=en+zxM5N0hWloXosLd8aYYS4uVHcQLP5wXHh65xkznRFyXKcpvxCmY9JXfML4z9Rks
         SF7C60FlksLDblXZJw5xmV3gIkxfA1Au42FE+BNSfXszyM2m8c0DxF+BO4k2g3u6P5P6
         8SQePvmUI3ahKmM4lQeP1+BYKJ5bz99u7psH6CICIivPkzOqI70PpCy4QTgAeUQSN1+j
         C6Dvsed8VIupoZBjgUwRcZQCwk+lbNhqHPZn5D7HTcd8g0k3dX0sR6I1gcKa6cKfrxpD
         ASLEEYVQIDXOzZpmTZglnRBT1IYW2Xaw12dLGHSN3zZR4x/WQRnPiduJp9k7HlmxfFdG
         +ffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793101583; x=1793706383;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uquc3keTWvct/whTSpSvOimDv/crOMpbNcTOz3mLlLM=;
        b=2XNqHlDsFa2vxKvdRPa18JHp4lbIEOGItiGDBvBk7Za+Dp9eQBL9J+CVI0SXv3gtRh
         S1uyFKvXOGGmAg1WfBkmo0LZmaWz3tY/T/UuI+FnyeCppFrHJ7QUQjmEkzBFClVX02Do
         G2+H1twh95+Wi7l1Dtq7HBpF+OqpqwoOhSuCO1RuDmr7Y6nKv5wriAl2S8MO0hRkm3Xn
         nEn5VeKesuCryw6wMj19EfvnDiRtiPV85ig07bLPgANQhVrLxFxRqqCHv3HvJFZlyNF9
         sM4JqaklWAtbEfs/lJqt0HCOu7FvVXv1NZJAX5zknfdiVKVjUuIGU4Wg2MVR5CW73wLd
         0unA==
X-Gm-Message-State: AFq9FYKWc3ULJnTb5P5ldHZXv/oh+XaGuefXr489mUNHz6xtx87eygAl
	CY3R/Ex5dkylaPdGAmyrQDN4XCGpfiCIviGHzqTlR7NLICQYbpxGW31pp5nwk0ZZIATvtJPjpvP
	M3fOCCdhrIMKKlesMdQXYX563uzMPqUKpkcGsvyuLYTRvrVyZ+vq52T4=
X-Gm-Gg: AYBFou2QGj4M2GH6SRTYilrjSV0+RQ8+x01EYA+muxrCC2sXILa9+9PtHW8KKc6iTgx
	AaGrlI3hImdfM2VpCPSJ6os7C/ToLpcuDwnhvOgIni+yGhh/QmuZaw9hkwiRpbL8dU9N46r/MWb
	/3pAdTM2PBIwSPIbK9k41AigC5Mj/avbyehGMJdFoTd84gDk8uaoN87i/tBKL4YqzUjroyx2p4g
	QGUytDh80BaR/oC3EnWdj0ALs+/2iGbplQMr14GwozLRUNsr9W0NfwS5h9FtJCP84b65779h5Pq
	OPU7//fKYLS5ybBJnDIOp7CRRto4rPn3UV8gmsLDukLhgvk8RiPgIHJ6BlN/ApQHMoF3lV5wh+g
	YnDpWI5HGjqm9FZL3bAm8TQ7H2JT4aBBe9gGRVa9Fax6OoTjYbjGhElvObtWaKdpzgmJD+JZBIv
	rVnUTp0Xk2wA6wxIlMPXVbEPprRj3U9dv1FQ==
X-Received: by 2002:a5d:5f44:0:b0:48e:55bd:9ce2 with SMTP id
 ffacd0b85a97d-48e55bd9d56mr5307925f8f.20.1793101583194; Tue, 27 Oct 2026
 04:46:23 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1793093611.git.wqu@suse.com>
In-Reply-To: <cover.1793093611.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 27 Oct 2026 12:46:11 +0100
X-Gm-Features: AclHuK8Y1PPMcukWcCh6wkD6u4wAVdl6MgUspOkFTyfjq5jmsZ3-ljT-LK8ziW0
Message-ID: <CAPjX3FeK70U+co5j34oKOD2=KC62kBhOCw6OAC-qeW=kP7AD2A@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] btrfs-progs: simple cleanup related to LLVM (not LLM)
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Oct 2026 at 10:39, Qu Wenruo <wqu@suse.com> wrote:
> [CHANGELOG]
> v2:
> - Fix the second patch
>   Which added the GNUmakefile, not adding the file into .gitginore.
>   Facepalm.
>
> When using LLVM to compile btrfs-progs, two unused global variables are exposed.
> Fix them.
>
> Secondly recently I move to use `GNUmakefile` to customize the make behavior,
> e.g. add "-j12" make flags, without modifying the existing Makefile.
>
> Also add GNUmakefile to gitignore.
>
> Qu Wenruo (2):
>   btrfs-progs: remove set but unused variables
>   btrfs-progs: gitignore: add GNUmakefile
>
>  .gitignore                      | 1 +
>  cmds/inspect-tree-stats.c       | 3 ---
>  cmds/rescue-fix-data-checksum.c | 2 --
>  3 files changed, 1 insertion(+), 5 deletions(-)

For the series:

Reviewed-by: Daniel Vacek <neelx@suse.com>

Thanks

> --
> 2.56.0
>
>
