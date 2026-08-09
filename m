Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D9F14B950
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 01:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786239183; cv=none; b=MX2IsRxbFCGl2jJSuBLt17Z0WJaOM0tWf8GFN6BuKJ/aVNJ4doOxnt53ao73Fs2SOAvYFnBnK/JRXLQJVPzyCWQ0NrtssyKbBvTeRcygX0Echvu/4C3Nx5b1YOBq5HcxVc3nYs4MYpq0cyjSSanN1FXQrYtPour/QYFdPiRPqug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786239183; c=relaxed/simple;
	bh=LaO0gEmXZwOAUHoHk/ZRXOi1MTgfV9nCt580Xw2F7aY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=QrQQpgeVyPz5rCixMT2CCkSZCscAE6aRgl9n/nLFXbecZjViwSKsnEeJ3fbWKBmdCvgGM1PfN37PQAaDAIXfCGZtW2WE2xTkRBpEqDPf2IPEL0IIVIStbIQ+CbMJPv1Ch0ZPq2dwzKYVkSFizr27cKS/2WeXop8VMhTr3cIp1t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pvQXOCmD; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pvQXOCmD"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4953de5be0aso5393535e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 18:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786239180; x=1786843980; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LaO0gEmXZwOAUHoHk/ZRXOi1MTgfV9nCt580Xw2F7aY=;
        b=pvQXOCmDXzet0o0VwYZyntn1/grGEaj8EUX6yBuX/6CxRu/+G0tIMPXp3Kb285ib1w
         3I4uknSqZphMDe1gBFZHmmlJiANsWaGidMZKwbDfu8KGAZXNc98jvEH26AdbAoKnHrlc
         M5KswPdNP4Px0MJVjny+ZZuS2I77E0Edg02JQaHwGYNQE0ErucrGuau4Dze102QnO8RK
         zqnfBFg1MS71/aYONW4zhX1kmVCatP7LIMU/db/eO/V+VCuDtgqj8aymGnBgh6l5SF74
         8zFFCMBIecFyTSfSgNfyFMSuzdLEslKxJk1RJk6DUs3KayO0G/aiVe88bPU3Ephl1YCh
         roDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786239180; x=1786843980;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LaO0gEmXZwOAUHoHk/ZRXOi1MTgfV9nCt580Xw2F7aY=;
        b=YM+GItXY+vdaCjxL6RhzBvKEnnCsMUV/i4IbOoQb+p0VL6vY1Mn7vlgTS9Tg/9JpiP
         kfUSKKIlxIknFMCsrwCBIjQDX/EZZ8vcRVzaDbidnCa8r4+wJEZjXtGRJVNdUnG43ZvH
         mV+9O8G6iRV7m0+gMjCUb7TDB7k8cJeD8usDzNNo4+aXAI7DuwJjABskN8YAnUfpPRiN
         +QrAwCx4McS9U1Dxg/HKJZ1aUAE2b9Iek1Zmq68fu7vFuydrdSnwUdmkzCdfPHm52eFS
         0LtjwKI+3vMcOzqp2mTq4Naq0PKsAdHcpuJ6+IkxJtkajXL5iGWfLfpTrScX8/zz8xC8
         18jQ==
X-Gm-Message-State: AOJu0YwEKtUflncMtGrgHh9C4HcXeWr/KXiyMveEcj/tZyZj0VR8ORm0
	QuB5vtMJoAnm8LLrd1UWXVPP3FhHiCYmLl4bjBY5TzFSD6q5mFD01qBr
X-Gm-Gg: AR+sD11VfvUJZIiNLrB/Wg0Ha4YPIAxCXANC1MeT2grk0o68pouxbpG8FZeQd9oz6EH
	+dWj/yqAKXQlTRShI5ZPQfzctRZXsrKwgvMp44aVihclOydVbLTWoyGAmTAVmttyi3ajdiFhFkO
	PRmz6k2vtSVFucPmuqh6Cfzd+Dqe38SqTNTAcrX/HxW05AIanEQIfW3Uvaq9ly7MzlkttV35Fy1
	vC/IAXFm3pmWv3N/fg6AC2625z7I+W2PHXYLbrvQSSXW9akH225MvQrMajatcRKupzqS59uQ+Eh
	C5YQ54h/m+wImPHpIJDirQRYqRWb70OiVb5y9slDK2c2H0QaouZroRb1HzRvvoRw9GxDU+5L2Er
	7nd2eWquyUEJ1BjFMGjHRxM95IH16cdJfhCN8UshGuDvn4ok/W/A4LSLj/082dSuKLeIpTMGznK
	S1QIQKbqaBAg2nazGn10SD7a/uQTvf57QQPQaD0Hh6w1zmusblXMJXM7blX5nFVAjYHWg=
X-Received: by 2002:a05:600c:4fcb:b0:495:5890:8f6c with SMTP id 5b1f17b1804b1-4995e084875mr150718765e9.7.1786239179568;
        Sat, 08 Aug 2026 18:32:59 -0700 (PDT)
Received: from localhost ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995c7a3d1dsm122998345e9.3.2026.08.08.18.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 18:32:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=e3cf0ac81d41aee6e6968be3a2d7f36031d8da89ec8b4bcc38da77337c05;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Sun, 09 Aug 2026 03:32:54 +0200
Message-Id: <DKK0XWCI89MM.2G6KD41GSR46J@gmail.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
From: "koraynilay" <koray.fra@gmail.com>
To: "Qu Wenruo" <wqu@suse.com>, "koraynilay" <koray.fra@gmail.com>, "Qu
 Wenruo" <quwenruo.btrfs@gmx.com>, <clm@fb.com>, <dsterba@suse.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260808023459.1494928-1-koray.fra@gmail.com>
 <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>
 <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
 <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>
In-Reply-To: <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>

--e3cf0ac81d41aee6e6968be3a2d7f36031d8da89ec8b4bcc38da77337c05
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

> Mind to explain more about the "chattr +c" problem?
>
> IIRC "chattr +c" just set the btrfs.compression XATTR to the default=20
> zlib if no mount option is specified.

Hmm, I thought it as "I want to explicitely say to btrfs to compress
this file using whatever optins I set for the fs", e.g. in a situation
where a file was created without compress=3D, then compress=3D is used...bu=
t
that would be the exact same, as new data would be compressed all the
same because of compress=3D.
Another (very edge) use case I thought about was "file gets marked as
NOCOMPRESS, then gets truncated and compressible data gets written to it
so I want it to compress again" (since +c resets NOCOPRESS)...but I
hadn't tested it. Now that I did, I realized in that case it probably
wouldn't get past the compression heuristics so it wouldn't be marked as
NOCOMPRESS anyway.

> The only extra concern is, if we have a new level field in XATTR, can=20
> older kernels handle it?
>
> And thankfully the existing prop apply handler is checking only the=20
> first several bytes for different algos, thus the existing code should=20
> handle the extra appended ":<level>" correctly by just ignoring the level=
.

It should be fine, as the current code also accepts "zlibabcd",
"zlib:invalid" and so on; it gets applied successfully with btrfs prop
set and gets rightly compressed using "zlib" (well, using the level from
the mount point because of the "bug", but yeah).

> So either option 2 or 3 would be fine to me. Although I personally=20
> prefer option 3 a little more, just because it's much cleaner code wise.

I'll change it back to the simple assignment and send v2 of the patch
series then.

Thanks again.

Best,
koraynilay

--e3cf0ac81d41aee6e6968be3a2d7f36031d8da89ec8b4bcc38da77337c05
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCanfYyAAKCRDmj22qf5IG
XI0GAPoD9f/D/v6toGAiBIm7t9yYlKty9R+hQg2LlCgzRUkQ3QD+LZyyYrib8TQf
vZ1Fv/oZesR3fcnQpMlGgNScxqgyQAU=
=9/pm
-----END PGP SIGNATURE-----

--e3cf0ac81d41aee6e6968be3a2d7f36031d8da89ec8b4bcc38da77337c05--
