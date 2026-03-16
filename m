Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE6B8460
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 22:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773699176; cv=pass; b=M+iKid1sNhmJ0WM/RPAqyowUDyXIPdo3EEJTB4NZ6XQKHanm29RIukm8gLn7cKufhwWA1TlPXRqunfELHVGdp3rI6sAfJIsZ10tukWrC95nNxkZL0mBn7U1y3n7atOkH0IqLiBbvw1MB0U3BRiOaywb5H1fwPrvXR1ckRHxICw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773699176; c=relaxed/simple;
	bh=rsp7Ihi8TSAj7hc2vakkxGqqL2oEkNH6XMA5zjqI1qA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h4FKCw5VhEMHa6PUIOIJjNJwqlLxez80XceKfXDTAaEGp+8qSiE3Bth6c42JGAobfcjnCpSO50tqi/3yZ92pqW+tLjtVM5ucI+7pRuzQgKW3ENIFVi7XHhsoX9tEBclCnJJx0olZt9iV7SCrV/4Z8yOWAMN9OhMxTwZGeWOlGUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXFirVf+; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXFirVf+"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6652452d94aso3127832a12.3
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 15:12:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773699172; cv=none;
        d=google.com; s=arc-20240605;
        b=VoIi+5H7wo++oIltwzHKB6TNDyZv94fdEqVdYRpNwXuz19VTf3RaHC33JCedL/fPDT
         sdLbGRVsE/L8Rmwv67er05TlYUDuMRaawMB18lpolptEH3lFOLJeE4Mvq/P/JCBfdRSd
         oKMuw6JX2eQi1daJWc8TibwMl4EWwpOM1ASpnZ2VifcZK9jthdEJhltjVk6cV4dfaP+e
         wW0SxiK690c3FTS7zMTDm/81ZrLsdCyiB+9X6xpEDaoggAfWc+CXZ5CkgxGhEa00qV4T
         CnQ5LHOCskhpSkFldz+VKEQCBRIqK7Ix4ergEnvymzjhNAxD93O/kaqySbKaqocyjhDU
         7Qng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pAPcwDRyDaYRxv6m5ec0p6vencyIfyK+pU3obaup7wA=;
        fh=487Z1ZveJzZKx3NPtOrBZQVqAFHyYg+u9Y2UhlVj4lY=;
        b=ONJK2Jg1DL/ZpoS/PCKwb7JHo6xlrHdvBolBUmpIrVibg6QDpN2vdav7b51MxV4asA
         +ZjPI2erxNw44t57/3HJSfMeG/0/XKJ9ubMviEKrtZyo+8OrD2cU4C66eAV10YP6sPRC
         RLvjV5pC/3Cwb0qs/IkAjaVHlcYYf2JQKFJhTOd8Np1W4fTTDiRtZ9waRxd1h8/GE7Zv
         jUgk2Q5cVwpRIZ+JQjbz/Np+rOPRsgnJy6W/W9Pynj7+zkLP2c45dHqQRHSEMlqtfKAe
         tvX/tC1qGUOZ8uo219rrDf3akDXHneExNTiPe+dhICFrgZY3AmT/bij1dZBTHDfsH0dT
         FRrA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773699172; x=1774303972; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pAPcwDRyDaYRxv6m5ec0p6vencyIfyK+pU3obaup7wA=;
        b=nXFirVf+3TZ7nayCWf+YAe8f5IxUtczrfP1EXNbBIrmwKiqwYyLnNpAauLND8FQtug
         qyiFy+esPMVr68OOOX82lIQLtv4g9BlFNZaBwo4KsXwCVqnfA/cnHzxN3Su9BCI72YRq
         auyRj61mHF94yEemJmjWC/U+E7H+3VcjkmPSPrWbYeT/sNINXe1KOC5DtsQxJjPZdVBP
         hNMRzTNBiyInnITmm9ONHtYXDRin1mMnPr1z331IK2KJiXXPmzS1yp1rdXfeMlAWA2Ci
         qg4RD1I8Hp+NegL76P7aa4Y8Cgz6Ykhx1YR2At11/HUaYDUKWkEbjQlI4WP+iffGCmKo
         wGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773699172; x=1774303972;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pAPcwDRyDaYRxv6m5ec0p6vencyIfyK+pU3obaup7wA=;
        b=RSgB6eh2gR0vFFZ11ZryBDcOcpKnRtjaM6qaAqt76XxVvFtJf3TZFBu7CqCyzbNp9y
         JsBX7cbF9T6sa7vYE3W6pibyrUKAcKkl4Qcb2JUY6brdJ4MqmT+jejV0UpqLcWyi7ZX0
         zecd+olkHN2I3fyPauUJvuF97taE1SQFhvDUDGpJZ2e+pz8FrMuQhYFVhcsA1QoOWY0t
         1g4zzDZOqzoxfUyWulKVoejNRRTn4o3lXPpfLusBgwgeqo+wobJA0fQoCbVrFdcEI+A/
         8qigv1DQU2tZ6F8yKlbunKkMrQIJrFf0uQIjmMN/2rPHb/s/QFfBe3NnYgX+gyC7y+nt
         u9Gg==
X-Forwarded-Encrypted: i=1; AJvYcCX09VLMsAmY4oqpHfyu0DNP4HX2TRBtqEcmrXxZ3jGFJjjK3Ra8Q93yJtutsSYfqstmBDPpYHc5Kt+HoA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6CRcRQgIKJswEolKBZSL6wfFeX10ij1nWuZENlsftMajizbM+
	p+n7tfCvcTeYoCWV4aEUBIZoGApNZSYSA2ofbZ3py/7LhU2/N7JPtHCvCsXuZexnbDL0WPqICvY
	jih+sAxFy0l+hsO+KnSIQFETHTuSIrAs=
X-Gm-Gg: ATEYQzyi4xxyRgTjOFsGCJouyJLtVV3mSBz9XNohVX1rHmEWEA87uOJ66HZ1ShfhUyF
	B6DpHK+Z1vHQ+ewOAR8yDX6D9Yans59g/hZahFb07ZPG5E7ILMF90/WrtHY1h9PxstqTPbz8cOa
	/VcCIGQXEga82jGEQ4l51fLxYTGaP9TG84CkcsvlEMFjBvL+Tuqd3UaLkZWMdVtOzkH6R/Jvc1u
	bZuq8mvRKT6sza/z6GVrFDfIna0PWAkuiHQwCj9Eyns1gB/1Km6Wy/pH+KFKfhJbgCutne4pCAH
	KlZvGEgxK53NrjWKVbDoM86nBVoUk6n7XnHOVGDx
X-Received: by 2002:a17:907:1c0b:b0:b97:b515:31e with SMTP id
 a640c23a62f3a-b97b51509acmr346111966b.50.1773699172087; Mon, 16 Mar 2026
 15:12:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311070416.972667-1-hch@lst.de> <20260311070416.972667-11-hch@lst.de>
In-Reply-To: <20260311070416.972667-11-hch@lst.de>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Mon, 16 Mar 2026 23:12:39 +0100
X-Gm-Features: AaiRm53MOL-S4iIRiZrnVZNNZCm-cfe6kMQGe2L4WL9TC_xpq_akeJ994p2lXMA
Message-ID: <CA+=Fv5QkJm8+ysx8W=ypr84oSR=rrikfk-iMMU6_xrtS1PsWvg@mail.gmail.com>
Subject: Re: [PATCH 10/27] alpha: move the XOR code to lib/raid/
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Dan Williams <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Arnd Bergmann <arnd@arndb.de>, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
	Li Nan <linan122@huawei.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 8:06=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Move the optimized XOR code out of line into lib/raid.
>
> Note that the giant inline assembly block might be better off as a
> separate assembly source file now, but I'll leave that to the alpha
> maintainers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/alpha/include/asm/xor.h | 853 +----------------------------------
>  lib/raid/xor/Makefile        |   2 +
>  lib/raid/xor/alpha/xor.c     | 849 ++++++++++++++++++++++++++++++++++
>  3 files changed, 855 insertions(+), 849 deletions(-)
>  create mode 100644 lib/raid/xor/alpha/xor.c
>

Hi,

I applied this patch and ran it on my UP2000+

The kernel builds and boots, and I verified the new lib/raid/xor/alpha
implementation using the XOR KUnit test, the test passed, see below:

[   25.705064]     KTAP version 1
[   25.705064]     # Subtest: xor
[   25.705064]     # module: xor_kunit
[   25.705064]     1..1
[   28.957992]     # xor_test: Test should be marked slow (runtime:
3.253413330s)
[   28.958969]     ok 1 xor_test

Acked-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
