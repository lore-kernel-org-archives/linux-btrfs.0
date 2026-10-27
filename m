Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793101751;
	b=ozxo0+YDBaA2UDMBGVX82md4bhiujSUzDXPnZbHuhuKE34BrYjpzilmafiSJosD26SN+
	 mtFKPnHlsYO3d6uuFgCtHrZOk/nUc1z9PoPR+EMFaogKtF7O5uc1DawC2Td6QzQ3Mt3Ts
	 ibBrbftLypne5GiwurCXlBg8llHiWuv7efGCyOtj3aIUO5Q6mGoMAm/SMdQx0SnJN32yt
	 0mp++uiIAq3hm9/o3Tl8Mv6FWbmQFC2aphGQIE6UTvDGDMoxpSw0MNhQ3ZEgccaqL7NIL
	 f5EszidS9L2vzdVblWNC2a8l5BziWbO0v65eK7DNAXw1V5U9ViAr0nl/vMvB1ohlYOg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793101751;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=n2g9BVPgPIcnwD1/br3vEj5plzxjX60zzyQRO+kbF6w=;
	b=V82I706OX1HkCBlwKMBo90+Bre0lbLATEu1tgSVxTCnH68tzjnSsDcHUCheaxWWIe4Ah
	 kiYpRnqvDidBcGS5bMVFxQVTkGyHfklbyFGMGnRZGU7jFGnOstEWXKwvJCTDlHJKb0huI
	 DNk8dJ50+Pk8+di/rnitTqhneHCkiVVT6sxZmm/sST5idgIFXDbeJTEiAy99JzeM0iaYL
	 9LpUCtQNm9i2bR63WqQ+96jcFg4+YRYBf0/UrcUTBgAzAN1aLIEpGcDWx9Fqtq0fwztx1
	 IdNipYvj2jTu9GpZD+ys+MIVlXnR4BiAIRF0lNLMZ1KRDmdDqHoFkSo6cRUY0qYDTwg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=HdeTX17Q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F0E606A31B
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 11:49:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57F0E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=HdeTX17Q
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48df4f540ebso2001829f8f.3
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 04:49:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793101750; cv=none;
        d=google.com; s=arc-20260327;
        b=KMVUQ9AxD6JoptxgebkdoBWyH7r6u/+LqJ7ODiWEUEOSaWK+m47ZIqsX2enyLeUOdI
         iJDWy2g+5CaNgINE28NBeALw40pdTbYgbH7auSBwu5gwfDriyhsEKZG8+4M+z2QFRjj+
         JKSN9KjxEL0ZrLHBYDZ0vq7PLtr6yOEr41nM89OuI5niiEGsFGUpI02qKxhjlg5gcmiD
         oxOcR+HbmtryMJ+H9cptoVfvx2Ws74AsBcTtFMkcgjKnUb5iNIJh8MdMRYVmnoARLaBO
         FRClMPovA+OL2I7XKSh3nBUily1ggaDry7SN89TvhH1GoOO4pv8haGeMcA6Mpr1bHIsJ
         qulw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=n2g9BVPgPIcnwD1/br3vEj5plzxjX60zzyQRO+kbF6w=;
        fh=yPQ7Zhd+suofqrV0OBO0K9vRtweo+8znMbiFm1fC87k=;
        b=Cz1laJC/Uu3UbLFL+nUtPr4uzHaNX3jw7DesOW40Sv+NPrNaITz5J22yHEkZgUZpBv
         HHwW0XFEWekshc4DTSjrWdon/UH3fQo+5KvIzmt2yluidbyuHJ5ZnHvP7Svgu3nGgqOP
         +5cx2jJHhrBTtvCOZnKoBh+cuXJ5oE07017mm/9PpjyzNaShe5P5VwQiY8P7/7HGwLRM
         JiR2El2eqVOWw0TepUvCMu9Uh2/PYKXbvCKpWmsSZ1qx6Qc7zmKT1DC8U06CKcg5nl7r
         1w07exIcrLflRIm9BkJxUNMar1NsiHm4bM1mdlJm75Fph78EX3nsutu9lADwJsPJtFwg
         ydgw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793101750; x=1793706550; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n2g9BVPgPIcnwD1/br3vEj5plzxjX60zzyQRO+kbF6w=;
        b=HdeTX17Q2dYHH21YoUKfBxODfXZ93WNWS+0Gm1IiEY2jwKZ6NNJWIt/j9WKn41Y48A
         jIIoyF0Vkq5GC2JPg3oSf7PgaC25F523GW/cylESRM475j2+t43eDF2ysyIbnzts+j8J
         5VHlY9+RRj1/0x5dDSLabLwCtA895AEH31PPHdxKWIYNYbEEoYbwj6+Ijyw+zSQyquF2
         rHTiOOaveiPrzJZqeqMPp02TFVBcHg5HJIV3+leWDGAbxhCSaP5gitw4CHNmsb+Mjrqr
         cEhh9jwkuQocYqRV6VCv5K/sPUp7rmDVoRbMac8Z4N49mKdUjHOApzQ+NVa1tKy+wzuO
         u4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793101750; x=1793706550;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n2g9BVPgPIcnwD1/br3vEj5plzxjX60zzyQRO+kbF6w=;
        b=ZZbVDw+GzEpLkBH0+TH/RjXDjgUC4ffYnc7MgHIqk5t4OpfDLgewOHTRoKIUSow58X
         +Uv1fZKseIkupbx7xXNjTDHhFc+vfsmx4eE2DxSYUsIB4yDgqK5a5XG5eSejpAMMzbRo
         F/tPcBpnoWIYBTh6OZ/BI4ofnsn9o06XRh73YFtU0wgRjmUb70KVwtIUNPizmMZJqHuP
         SZh6Nt8VYhckRkWfYZhWHKuXIkCDm65Rd4lRTcV/HdlSXFynGrcw8bxrQhxhvE4MgBh4
         1dFoDDsFLLaFmfdnasNe2MfFPJSkNxDgVJUikp1J2tTohjwV8RVyM7vL1/wisIezvFG+
         3dZQ==
X-Gm-Message-State: AFq9FYIJttAh0nEmRL1YtI1ld4Zq0/fJJk5grvWmRxXiCjwZh+0sblQs
	x4q45WJ+N+KayEgx++gjZYKt4LQLGTEFxdy5W9RplbKyAqOnFyqyjWN8jrMzDVMVsuT1PwEOn1K
	e3ssFIO5obc2E1KuIWT3zci/VBnl5U1hmj1CgDCjX4A==
X-Gm-Gg: AYBFou1c1rTG/tg0rFksCgV7sPy5iD7Q6CnfGDfFLuZvpff/xAsm2iA9xrVZub5oS/N
	8eKZkCE89Nx5FdDPn3gBXBS031ntMgsqAcPE6o5lfej8Vx8Yl3triBXpFkJwOcCGzbBXcywiiDH
	OGiDVR1oAtks92oKvG8z0osQg7vNJP4yt1+YAb94sMBUNgsbbgVduimnrfBNN6brOCVWKby8/zo
	eKo1YA9MPrCngBsUFS/VAJ7KXFd14HI3zCuheTzipq2oORslgacFfXJL5eh8mupv+Dkac46VCZ+
	xkxCvkPwb6LJSHOzyhuRgUDHHriNwdfTTDPvuUwPn7CbNufX5gh8zH7+PATkxFq0BQA8kWHSlzm
	SCdPAe0vQSgoCuXpL1cPLhW0e6nFpyq4oVgZDd57JRYkRM+6M1L3mOukYbxvPs1ewZGFwc7WcKa
	t7j7PP2XbHFy963U9uA+q/xb3ZzEXtW72ZTcI=
X-Received: by 2002:a05:6000:24c5:b0:48c:69bd:e971 with SMTP id
 ffacd0b85a97d-48e3eb859dcmr17962003f8f.16.1793101749776; Tue, 27 Oct 2026
 04:49:09 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <1b0822425d9c76cbf7dc4e5fe9eedf62ac153b56.1793095807.git.wqu@suse.com>
In-Reply-To: <1b0822425d9c76cbf7dc4e5fe9eedf62ac153b56.1793095807.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 27 Oct 2026 12:48:59 +0100
X-Gm-Features: AclHuK9xjjyPxUFOC8E53XVJHVXp005yxnBPTO3OG5ctbKV28EPtiGeGiwnD5TQ
Message-ID: <CAPjX3Fe5+7PTmqx5HNmbQLgsv-DtGhJxgF=u14mZQnTMFN-nCw@mail.gmail.com>
Subject: Re: [PATCH v2] .gitignore: ignore GNUmakefile
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Oct 2026 at 11:15, Qu Wenruo <wqu@suse.com> wrote:
> I use GNUmakefile to shorten the command of "make".
>
> E.g. for my arm64 worktree, I have a GNUmakefile with:
>
>  export ARCH := arm64
>  export LLVM := 1
>  export PACMAN_PKGBASE := linux-arm64-custom
>  export PACMAN_EXTRAPACKAGES :=
>  export PKGEXT := .pkg.tar
>  MAKEFLAGS += -j12
>  include Makefile
>
> And for my x86_64 worktree, it looks a little simpler:
>
>  export LLVM := 1
>  export PACMAN_PKGBASE := linux-custom
>  export PACMAN_EXTRAPACKAGES :=
>  export PKGEXT := pkg.tar
>  MAKEFLAGS += -j12
>  include Makefile
>
> So at least in my case, GNUmakefile is really a shortcut to specify
> extra environment variables and build flags.
> Thus it should be added to gitignore.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

LGTM.

Reviewed-by: Daniel Vacek <neelx@suse.com>

Thanks

> ---
> Changelog:
> v2:
> - Limit the GNUmakefile to the top-level directory
> ---
>  .gitignore | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/.gitignore b/.gitignore
> index 9875120ea7bd..6f018294a119 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -194,3 +194,6 @@ sphinx_*/
>
>  # bc language scripts (not LLVM bitcode)
>  !kernel/time/timeconst.bc
> +
> +# GNUmakefile, mostly to export extra env variables or build flags
> +/GNUmakefile
> --
> 2.56.0
>
>
