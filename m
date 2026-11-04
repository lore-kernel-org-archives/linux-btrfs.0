Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793778682;
	b=Y82uc1cYveGfm1UlCkv6VtN52j3n4e41KdnFCUgOqT3BGU3DJW+aHrHuNp55cvNF3p4b
	 k8sxJlV+zNjyPc13rm1liZeyL8843T9H8DlIqPjwBAU1Cw3SFH46XgBDWd1EpfMP4aakS
	 IgGYs0aRzCAaCHrl1gse3toGkyae3n0kwV2EcMcb0dovn+nbz7Ke5unBC/LLPXF3uQdOO
	 Dg7fw/whQQmv7eSZ+oL1Px2Bl1IR7GECBIbPJ6rZUSV8GW1mbjwHcUBul5AgaPjL+SDX5
	 LqaxGqk0EiqoeeMLdwUCKiNF9UswKEacHkisUyKtesnNxqYwddtGwoDFR1Fj7AV1NIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793778682;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=3teH1NkPDJEceFI53ssz8olhW9I/A7pSyBmfb0k3AWQ=;
	b=SfHYQasEUnOtFN3v76Kj4MZNfASb7CRxdoWIyDq8KMBMT7IOv60FV0ixxmgfSCO0TSWJ
	 P+EGDgg4FkK3eWrXjJD1gufofZLcvbLeeQDTY1U9T22Aci+LIh3s5mo6BZkwLbZ8tyJ7w
	 FDJAIe2FFIVgs5HTZle430uWvPBHOwFJguTqtfaprns/kpQT76OrRBoD+P5uUtC59PpkB
	 D1a91p89Ripbmxg8G0MC18qt2LIWGdZJzPuWEDukzXg1HEY32m3Je7EdQ6u4j1AGnWbId
	 8waFuICsyzY/rDG6NZywionZUlErh+2Gvv9tAnNnr6QdU8yHRZu+TvJ4KPowEM+hHRw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bW3ss21I;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1325B606A32E
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 07:51:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1325B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bW3ss21I
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48afbd2c386so186774f8f.3
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 23:51:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793778680; cv=none;
        d=google.com; s=arc-20260327;
        b=Bx9VcjdqELTNwd5rrbe0MiPHWBmmmpgFBzElftLPoy9eZH4HDwzLtj5n7NykreMPTc
         Vw3tDbyyM3c2LDVawpFNvP4UTEbOH+a6GhlKtvPFRg4LnsI7Hli/bgiadME/C8koAPJp
         Evb6JIqWnRSKKMPb0/J/jOOgSnEH3de2GJq1hkJxRi17JAWOzRlfubKUcaov3GWyhUv6
         r4716nxdTWjdIz0fTZLtOu7Y2l1vS/DknOimpl8eFopBFW6zRtgwnxpjbtccvjKaahzC
         xijtPW80SQE73s0afy487lQ0JOMXHafFWVzqMIy6wTtemYZXVv1G+8P6u1XOS5P8W6uY
         R7Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3teH1NkPDJEceFI53ssz8olhW9I/A7pSyBmfb0k3AWQ=;
        fh=SoS0IIWU5eAVPargbNRbmBVtjU+4WCUxKhs2ITyWzNk=;
        b=AbAUP5h9Q+m/+X03AozzxVL2kHN5JQ19jWPKN7Xnu0elsg7V0Xj4W6MhBgHrDets0r
         zN17c42x1j8XCdGf0+xmdUPcUsxbc1sTIEHCR62pbGRev14a8/X6kqUsIdRUSNGIF7Uo
         ARL5hFhVaEGgzCiBddrYwkaCiRJVLDIU5bbMOiJ0e0UkspqErZS+UH2WnOZl5NYCxoVS
         cmNTHB4LazIyvKIQQYrzC8bsdiZyLTQ3TjAbMgH5Xl83ba1COuhtZMRHThN/bMFCmv3m
         5LhJwZq6pLtWYv+rO8QTzXnfNdEK+E4NT8tKMMFZ3KJCR9lSPbC/7T4dvULNL7gLSTjD
         fE1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793778680; x=1794383480; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3teH1NkPDJEceFI53ssz8olhW9I/A7pSyBmfb0k3AWQ=;
        b=bW3ss21Iw/r8WPniO+hSndS9iAb59AhKj4dMwxAW/3p7AeTMIDtNJzgr55Nvb8+Lol
         b/y2tEc2eD5L3t5nhuozwd7vvwMoD253QnSCo4jzNAd7gibTnmIEMtx9Ua0SYApbI3Hq
         dd3vLBE4OpiBlDaywXFY2H3vSC7HuDMFjhcYyOGFRUP2x3mizi7w+ccv9hkldAPWN2an
         AOf5XXs44tvXyYLQM5g1f94VdNEEYKF6Y3CiQDZ0xS/6QeotMDTLalguXr5DNXEirLla
         fD+9d+8weJZyOIo4Jk4sO1vGbypBh4NDM1L4EuX9oBxjXQCkwXiDWWlzm9xRlGp1qFr0
         8xcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793778680; x=1794383480;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3teH1NkPDJEceFI53ssz8olhW9I/A7pSyBmfb0k3AWQ=;
        b=hATNHl8160Nth1P+EPaEHLUPwLigUATsIOieLNMmnv3dP8XjYwzo/Mk6HxIWnrmMkk
         ClCn3+PYiBfPq4D+Q/TnPAoo3+9EHwINYkZs7R5mwThTR1bgyiBK67rjW/qPMUR+6A4O
         Iwl73QGPrFYZjCR6YaAVlbetNx3YfJhpFi6lrZ1aRNbLC/u4etRLR3E0tukC0eqb4UtP
         lDSIRKGXLb51VlcsYwON234szxACHLB6ynPBC2fKyPfoPQs2ODav9+z9OZ8qkHzI+KOi
         pZnY6qP7PMeKZjf81/6KH5gOBQ59rZBrpfTXqmtqD3IDwOZO+H0f6G93UDbmwtBGvEaZ
         +G3A==
X-Forwarded-Encrypted: i=1; AKwUvBzxHFmydPkY6EU8Ng83+u6GbIAtsctp+dfYihpI2Yju6f6T/cJkfF41qrEn4/MpIx+xl0VUAEr3pPAG3Q==@vger.kernel.org
X-Gm-Message-State: APuU4Z8H+ejewLup9ntnO/ZelpvFUf44LSlXgyjlQ6fw/DAJVeQFjmkC
	VkcNwHTtqvw/p+fMWE+LM7sQLGEcYZG1gRcXZFT0vdMC9vkoLZNyCy3DvRZWGaRKF5YiCHusQq6
	PTKshE7YrtA1Qyy8Cp+UsMkR6uceQYG9X3DOB27jkbQ==
X-Gm-Gg: AYBFou2gBk1ztklqQxh3EcKCwCpoA6Fd7znhodXAkdPNa4PJQj/2gotKsCFWnX7ZRJT
	pmcv3Hx3kVOFD6mJsX56eSx2aG8j+PH3HtJ04uj6CDrHuijkdOu5I871JAbW5GAPeGjN3p971yd
	pM7Co2jLulmiMrby5gdlq2vsXXwl0M9JnSEr7BxD/ija7Rjh0q8IsisQi2TgoW9DU0rSmMipWA5
	Dj3OL1GJlR2NBTN6Vii7OceCbaznfcxKOKyCHwxBj5jW/2lc1L4J+VDXQTd1FV3GXxF6YwZROmX
	eisypLR/RKM2kjiGItG1ksl9BoNfZTAlkT3a7p95y0E2px90kTdUI471rZeMnnDVzgD0B2i6F/q
	0fJJSUmcvXmv6X4bsdXYMuncQlVtcwdJEV0g40UX6Zz2NE6HRwXNglfm7fwvSJorAN0Y+fBfM/p
	H9X1jxm1fQg4s93SjO17hs+PHbHiSnhS2Zfw==
X-Received: by 2002:a05:6000:2203:b0:48f:bba5:732e with SMTP id
 ffacd0b85a97d-48fbba57504mr6959373f8f.57.1793778680437; Tue, 03 Nov 2026
 23:51:20 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <fa0ffb25-3c1d-46ce-8cc6-bdc1e2d86c2c@app.fastmail.com> <5843fbc8-95e6-4703-92db-5cd1df13ae9d@suse.com>
In-Reply-To: <5843fbc8-95e6-4703-92db-5cd1df13ae9d@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 4 Nov 2026 08:51:09 +0100
X-Gm-Features: AclHuK8ucaXtt6yj-K9tQS7d5jLn2FO203dSpQrE7OyJFHESh1QiPPsGCCoP65A
Message-ID: <CAPjX3FesndAq7zHfkz8O3_tTkh_ttx_g1SOhhKa9sZ4gOsXZ8Q@mail.gmail.com>
Subject: Re: bitflip in extent tree questions
To: Qu Wenruo <wqu@suse.com>
Cc: Chris Murphy <lists@colorremedies.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Nov 2026 at 21:42, Qu Wenruo <wqu@suse.com> wrote:
>
>
> =E5=9C=A8 2026/11/4 03:38, Chris Murphy =E5=86=99=E9=81=93:
> > User reports transient Btrfs corruption.
> [...]
> >
> > The questions:
> >
> > 1. In 3/8 checking extents, do the 1st and 3rd lines tell us that the m=
etadata profile is DUP?
>
> Nope, it's just how the extent item cross-check works.
>  From the backref item in the extent tree, and from the file extent in
> the fs tree.
>
> > 2. Why does the kernel not report a checksum mismatch? What does this t=
ell us about the nature of the bitflip?
>
> Bitflip happened in the RAM hardware. Btrfs calculate the csum when
> committing, so it has no way to know if the RAM is reliable or not.
>
> > 3. Is this almost certainly logic board memory induced or is it possibl=
e it's a drive cache induced? Seems the lack of a checksum error tells us t=
he checksum was computed after the bitflip? Therefore not drive DRAM?
>
> I believe it's the system DRAM.

I've also seen system crashes where a bitflip happened in CPU
registers. DRAM may still be reliable but CPU failing.

--nX

> A memtest is always recommended for DDR4.
> DDR5 has some extra checks, although not as good as full ECC, it should
> still reduce the chance.
>
>  > 4. Is it safe to run --repair?
>
> Yes. I believe so.
>
> >
> > What else?
> >
> > Thanks!
> >
> > --
> > Chris Murphy
>
>
