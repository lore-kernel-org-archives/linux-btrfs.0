Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36E73E5EE5
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 18:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777053798; cv=none; b=Vyk8EabFe6uCa0f4lMkaSmHogGIyzI8P2zN9jKwAo5XFoqWt690qT0y0UVvat5ltLcEznP/RAsVnaNm+3y7mNejEZ3i6+ZZnYKm6Fihj6mNEDmaK1XwSWMkfisNz4Hcaqs6rs8FG13YaBMprQjZvmUqlPZnS/1eJIOWQXRqmxIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777053798; c=relaxed/simple;
	bh=6Ki6oLcA3cwHpZLerrABlG4niyVUERaVgMA/pslD2KE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oR05CmEBigGDAdma4DkKpLaYYJFiu5JZ049uLWN57wC3eZOveJMsq+8xNA5FIfNwBFHZQ5GbE53VBDEN4nYyfE85uHN3ETfCBWRT3j55i5mvs4LjixIwoGJqpoXbhFBxzSlwrpfMXaEilqlaNDY3gJ8ceMn0MEbdQkDyFEAep7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-685017d0fbcso4546851eaf.3
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 11:03:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777053795; x=1777658595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4g/78nYGug/5gzfnhMisE7IWIcFFtfaLBekZub49tZ0=;
        b=FXpxtLMEHcTUUmgCKYCSxS1Lt9v0h/SQJuoAgXu+8PH1FHoPDOX+A1rrSrSyttR7/e
         cctJvN9SDv2ZByXJsaQV3rdUnm/fbw1mzi0Ybo8E1l8PUIlgy8qO64YFlNQPJTQqzeHv
         kSuKzm1cN80rq9FTsfrsec9IJoZ7B7u09ut31mId0YuMc2vEsyhNDGwOm4YBPxwUMfpG
         7eSFqcb5oKNu8qAQvK4qwoZazKcMxwZ3TEuadUvnxh4cdKT1t0iuc8MHDJMc6IPS5RMz
         H9UyGJze3Ihgc3e123qYkWbb2oTg648Y2tDLJbmsQGB2aJ+NlIBIBoOIJoVdIhlijWFN
         c0qA==
X-Gm-Message-State: AOJu0YyEuAGqU4CV1/pORwobBrUQZh2j4K+OEVtI/EzX7MB6/XL26amL
	IG4Dk/moKfmOsXZdUZlY/FG8jGbkgGkqgHnRTOOLIvhUXPl+xXMnjEg1yKjEkQ==
X-Gm-Gg: AeBDiesUVfADs06MUv33xv5dgzM18aR0RNl/I1QlKTvk7NlZB3PK2KPq4jz8y9nbnfB
	AaeQuYbRERuojw3qF3jiBfx+hTvG2AAb8X22vNj/tgapgUPH1Cb4RKo02vuyAHjc1z0qlSw5WSi
	fDajHNE6rgiT06kslY4mtvEmIzOv3cHyI0cW/SaM4Uzg9hZWbn5HHx7hjI5RzjvyPorzFCwNTJL
	+CMcvbNoBTuCje5+LWXzwVa+nBIPQk2y8Zly41HV3VpxZzCCm1Qof2hrx9g8Ttwpf5rUSuXwmJC
	sy05topkx9RZsL0nwY+lX1fCQi6n23JqICu3lRC8dHowU1Y9QITk0zPoeWkGAGCIJz1bGeqMBp9
	zLcM1v0ciuM3nEO8HXitOTmHIlcQJR2+bQ7BLPV/ZZewNvxy1HRaruTWo7EI0EFXFhrciCVJvcA
	h78OHt5fPD9I/u2HzpeGXIoHF726kzdBEfBXUFJ/o4A/6/RppSsOjTXZhXmmXuZ3YyNRK4MP95c
	KO+m05FJ+v3Bi83wQPLPc5hAZCYz47l9ibXLq2EU/rWooSaDyHkbfNgu20B84W2SLMkZG+ZefLN
	yT1hrcAm
X-Received: by 2002:a05:6820:2188:b0:696:27e2:83ee with SMTP id 006d021491bc7-69627e287ecmr1968950eaf.3.1777053795433;
        Fri, 24 Apr 2026 11:03:15 -0700 (PDT)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com. [209.85.210.53])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6962b40d504sm756952eaf.10.2026.04.24.11.03.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 11:03:15 -0700 (PDT)
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7de44ed7a11so2560993a34.1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 11:03:14 -0700 (PDT)
X-Received: by 2002:a05:6830:6581:b0:7d7:c985:3a30 with SMTP id
 46e09a7af769-7dc950ebc54mr21802341a34.11.1777053794641; Fri, 24 Apr 2026
 11:03:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1cd9bec514234044fa75a5e1e73575f854331508.1776991780.git.wqu@suse.com>
In-Reply-To: <1cd9bec514234044fa75a5e1e73575f854331508.1776991780.git.wqu@suse.com>
From: Neal Gompa <neal@gompa.dev>
Date: Fri, 24 Apr 2026 14:02:36 -0400
X-Gmail-Original-Message-ID: <CAEg-Je9vvWLf55Ly7Dy-U=e6a8thm=qE7rG5_euLOUVZPe71Cg@mail.gmail.com>
X-Gm-Features: AQROBzC96MnjSfRNNbCTrBFaN8S9PeeDVSU2YOARvmW-bY6xRB0XEwlEPh2kzw0
Message-ID: <CAEg-Je9vvWLf55Ly7Dy-U=e6a8thm=qE7rG5_euLOUVZPe71Cg@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: move larger data folios out of experimental features
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 23, 2026 at 8:56=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> This feature was introduced in v6.17 under experimental, and we had
> several small bugs related to or exposed by that feature:
>
>  e9e3b22ddfa7 ("btrfs: fix beyond-EOF write handling")
>  18de34daa7c6 ("btrfs: truncate ordered extent when skipping writeback pa=
st i_size")
>
> Otherwise, the feature has been frequently tested by btrfs developers.
>
> The latest fix only arrived in v6.19. After three releases, I think it's =
time
> to move this feature out of experimental.
>
> And since we're here, also remove the comment about the bitmap size
> limit, which is no longer relevant in the context, and will soon be
> outdated for the incoming huge folio support.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Fix the defrag failure
>   As the defrag support for large folios is also under experimental,
>   we need to update that part too.
> ---

LGTM.

Reviewed-by: Neal Gompa <neal@gompa.dev>


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
