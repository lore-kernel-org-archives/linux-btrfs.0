Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE50B199920
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 03:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786246556; cv=none; b=RzDHhlhdJ//ayZx/n30toiIupg/DhR8wkvQjefRstnOwqHvsi3hW1PFud2u5DeFqaQTkgDizMI8tBcrgVbNUf1zR791LoVHVP7cYe7linEZ9B/uaHNyWk6C5Lz87Jo8MSQMeqNi1hMzmBptZ/zHGu743SY9uWbnqK1HO5hyK2CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786246556; c=relaxed/simple;
	bh=ipuIls88XShGLY4ZeRTlXsGLS1jeoPD8ghMV/QwoOwg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=fOmf9O12njBAGNWlbEyOelLUwc+bi4JmO7A1l6/POnCh2VC5tVNmWb+QxN1HCy+jg0IT08P+uTiscy75Lr76Hd3P9YuSqjmubMLBnpXdsqAK+TB4QeMAA3twRA1a1RmNVUOgS+lILg7lrgwPFW6y2BstYieDAJ51ydiPUR8Xt6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sw3Lo3iJ; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sw3Lo3iJ"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47fe377a217so408270f8f.1
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 20:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786246553; x=1786851353; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ipuIls88XShGLY4ZeRTlXsGLS1jeoPD8ghMV/QwoOwg=;
        b=sw3Lo3iJ/QkfnBZNKlyL7bwEIaO5N1Bbux1MpC6+eEbyeXOUFlkxQLPBxzHqB7Ntpw
         zcgTalb8iC06QKdvhhN3Y0lagFw1cxvHXRhKWcPNwXYuBxuLr3rSpxlcA+0XkbuoN6S3
         ZLIHBzUZFCtDf54vAjvPEsngmu98GJeFWsiie5RScywj0XFNgBisSduNscdeZxLDoxB7
         d6QByB8Vyn8ZN3hvD5MnJ9ERmj8eDKJI4hFDnrMiVNKqXQDrdSYEETGpXNbqdit/kRSG
         jWNWMze3GV3qlYmXwhBoLU73b/d9EkaB8mm/A2mABcSXnUzkmCFv6QcIWMVmFD1XRpMG
         1U8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786246553; x=1786851353;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ipuIls88XShGLY4ZeRTlXsGLS1jeoPD8ghMV/QwoOwg=;
        b=CZ0gS98yvGEZhprjTAisJZjEklJdUTLTicToAxvdP14XK4LEV7bBDXtgYvednr+s7R
         t1Zad3vw30JwCb5VIcpNejtwWUivKeBEtSKktp9siEF0xHv05WnLPTOndJAMBUzJyMyj
         ur2jzCwlgwEJY2dbA8IcQZdxZNa2lQZ+yPeoUC25eMw9bmesjtxfZjIpa217SvYLgs1n
         28Hc7Bv9mxwI11KNpf0COAYoGDEmoq2ttHE//owdnQdfTHntGSg1a1l5KQqqhbgJhQ4b
         Dx5QWEslzuHXrRb//N+7il5d5ijz08tGE02U5wQzQ4HjHwqAADfGqIhc4bUofLVI5FL5
         1vFQ==
X-Forwarded-Encrypted: i=1; AHgh+RoidD7k1isrccyYOMdRY1rZ67YdsnDv/QieM2w9wUHZyPq/efqxM+qsHVsXGKuQtXb4DCVwdYCG6tc5GA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1j7/hX3AWU7js2Dqa8MnJVvGvtjHDn6RHiGI/4S0SYnmwVZuP
	DBq/CZ+XyCnHNfneafkZ0QpDrQUs6871v1RC126onz4xMw/kvQjqQHaf
X-Gm-Gg: AR+sD11pFwTv76DxUAA6WLZixZ4BTXcb8zOMG2lkkK6J9uLMb3peVq+LJyrkdjB5tsH
	PuvJ8oC4iznD10p2J5PFzf4BfHz1oUntCyrReZ1IiGw7VrKfIddAlqVwU2yd9BdvJzu/mGdreCG
	amWRenUntxHcddxAOHT1eJB5rynHalClyhBfMCFAw5scFe6V4HaZ8YAoaI2rQRvt8vaNWQTDB78
	4eclPz9f39fVGc+udXz/W6IGFdsurTRhvWQMcn/dGKuQ29f0ALiZ6DverIZC8YDUkhgLtRo25Tx
	ab3VYQL9MzZvZuLqCyhrg8bWVy6OkBqiakAR4G/fdxHzwRe9eOj6UQWSVLC3mt6vt3Uw1dBRqaT
	0Sf/ugB212X199dju5hMTJ3pKoCmgPQ+DElDgv74rQvly7NCj6fwMmhUfDVHBp56oi+kQFZJxv7
	kUYeYCsNB/J17saiYpWLXMdp6hdSivBDqEiCUV16bl+2ssEb3bUVBWv1iG
X-Received: by 2002:a05:6000:982:b0:481:98d:b24 with SMTP id ffacd0b85a97d-481098d0e88mr17301832f8f.19.1786246552935;
        Sat, 08 Aug 2026 20:35:52 -0700 (PDT)
Received: from localhost ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021509a5sm18343509f8f.16.2026.08.08.20.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 20:35:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=7fdf43b8a212d5efed5bc6118458e09d373dfd39e36dd55adde5e9552486;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Sun, 09 Aug 2026 05:35:46 +0200
Message-Id: <DKK3JZ4VEBDZ.3TZKOIV87R4ZG@gmail.com>
Subject: Re: [PATCH v2 2/4] btrfs: also validate compression levels in
 btrfs_compress_is_valid_type()
From: "koraynilay" <koray.fra@gmail.com>
To: "Qu Wenruo" <wqu@suse.com>, "koraynilay" <koray.fra@gmail.com>, "Chris
 Mason" <clm@fb.com>, "David Sterba" <dsterba@suse.com>
Cc: "Zygo Blaxell" <ce3g8jdj@umail.furryterror.org>,
 <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260809015054.779137-1-koray.fra@gmail.com>
 <20260809015054.779137-3-koray.fra@gmail.com>
 <f190abba-cbe0-4ffa-a815-00286b5f0c88@suse.com>
In-Reply-To: <f190abba-cbe0-4ffa-a815-00286b5f0c88@suse.com>

--7fdf43b8a212d5efed5bc6118458e09d373dfd39e36dd55adde5e9552486
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Sun Aug 9, 2026 at 4:53 AM CEST, Qu Wenruo wrote:
> Please make sure every commit compiles, this will easily break bisection.
>
> You're changing a function prototype and implementation without=20
> modifying any callers, this fails compiling.

Right, I'm sorry, I didn't notice I changed the caller in 3/4 as that
call point also had other changes.

> Furthermore, I do not think it's a good idea to just rely on the strlen()=
.
>
> E.g. if a crafted image removing the last terminating NUL, relying=20
> strlen() can easily go beyond the expected string.
>
> I think the change to remove @len is going to reduce the robustness of=20
> the original code.

That was what I feared too, the problem is that
btrfs_compress_str2level() uses kstrtoint(), which requires the string
to be null-terminated[1], so the len paramenter would only be used by
if (len < comp_len) and that reduces the robustness even more IMO, since
a developer could think it's safe because of len, while it actually
isn't because of kstrtoint().
The only fix I can think of would be to use
_parse_integer_limit(..., len) directly or write a wrapper.
Or just document that it needs a null-terminated string.

Thanks.

Best,
koraynilay

[1]:=20
from lib/kstrtox.c:251:
 * kstrtoint - convert a string to an int
 * @s: The start of the string. The string must be null-terminated [...]

--7fdf43b8a212d5efed5bc6118458e09d373dfd39e36dd55adde5e9552486
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCanf1lAAKCRDmj22qf5IG
XKo7AQDn6jOuQPBzJU33d9krYB4nZp8Mrru+arp/66lCE5o59AEAyxUHSQ3pGTkS
Tzan7avav5nqvb6luvYd9rXUX/5HdQ0=
=a4fP
-----END PGP SIGNATURE-----

--7fdf43b8a212d5efed5bc6118458e09d373dfd39e36dd55adde5e9552486--
