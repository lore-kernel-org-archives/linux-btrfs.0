Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443332;
	b=00camBHjSWZD/ZJVSJ4iX3lb9dOy4H2keyxMRZY6t8ApFeq5fBT1X/gqFN1sc3E3MhyY
	 njnw445IOcDOOyhc6UcZJV6bjc4gsZ7QZv5o9yK7ybL3QF56b+ZNrb9sx+Uw3OZs1uzSg
	 kcLdNI1kl8CU1xbnWpUwAbgMvxNPovvup96rm6N6YdvpyUwprEpCUIQEh9DQGMRPzuNn+
	 SK9S1DGzn4u4RRaSxOKxVDOrbKfEDwh9Tp5Mi2FCV8CxaoBSZvdYmI0VYiQD1haKx7wpd
	 bvrTMeqRHrAStp3qPr7PxKKk5VfIMaN6XmiyXKu9j0mCpiLGgPuzT/qQxd9DOHKxP8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443332;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=SVkCiAZ9hVspPzZuKZbqXCYeKQk4BcDbwlCFk9p1ut0=;
	b=jF0CqOcdmIHsFgwcnHyVgE1sU3pbVtWwLCwRuVHQ+TjvsJK1qITS5B802+Dlnvj93fla
	 FfIpqVf4y4BxNxl/ZmtYQULrDPUuZBayivb3JdQTyDCuNkqrUmtxMARJo/4SkKK+6wPh4
	 UNrVqf3l9y8br/9JtoSwsvhqXMBo1cT+2ASMAINLNZJc/+hnIh29Pb625LwURbANJZftn
	 n9VCLub1HjDKlcjErdLeQH2HhVyeIVGIRopndiDp3HM5xYNPM2LugG+daE1nu/1gk8Cwd
	 W8I1wbM2bmHkzoQpQLfu67b3t634x9ND//ov0d208/Mf1DgzYDi71fZEnG/BdRivfFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LhurUaLd;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD12606A33C
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 14:15:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FD12606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LhurUaLd
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-49412eb1474so2121069f8f.3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 06:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443328; x=1796048128; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SVkCiAZ9hVspPzZuKZbqXCYeKQk4BcDbwlCFk9p1ut0=;
        b=LhurUaLdrrD6el1BtOOCJ70R+8KqK05u0u89mfuXWG8+J9Bw3rVb386658OMP5zMq0
         decyq5yItprIln2niTvSLmNubbRMdoF++9VmjkmrA05HZdXvZxDurdMDYBuXSM2/ru83
         DL0zGzc4TqwjCvYZ5gt34/pSFJf4/mCtDoKXgpXPt+Sv7g1Y86AFw3XQ6uM+o5M48dZA
         fsqr7/KfuhPw2PRwDKKUwpkICKW7wj5qvnFdYfxcb8shaROlLIM069A9F1sNO6bSCk2N
         auXzk8QjTdj3SnDJjqubihTVZqQWZzgbhHEkWSyJVafh+Xk4iboolLWwWkG1XoRweIGi
         qdfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443328; x=1796048128;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SVkCiAZ9hVspPzZuKZbqXCYeKQk4BcDbwlCFk9p1ut0=;
        b=f2q1iq5PSsYJuXSwPxygXlStvoLn6Zz1F8j4/RX53qHlYjBBuF4Cyo6aG3hBYt6i7R
         gJ6Zt3sygj/sasOvG8PB/fU9H7LKaoC49Rd2ARjaYFdNKK7k9LbjdZf1XPwCrkCeAbcH
         2MtahpmVVdeG3vR9dqT26Cd5alqbP2U0Khx1gaGyfUQu06vVjkVy4/JPhQsSAMyILkLv
         x6zpMvi2t0JnfFXziUU3Sgd4vnRmNsFjuLjP9B4QndBXrjHo4GfPJd2xt/gueLQgVYDE
         1h2SUa/IKN+DD87tj6W0TB525lzAW+PwLnkEqIifqAx6S/h2+OWQRGvYq9SeuMyW2HI1
         TJ6w==
X-Forwarded-Encrypted: i=1; AL+hErFvbre45uMQqeGKaCiQHZMV4TF2NcOxWnbWaugarZKxeP+XcLc0ymA/1wTZy/Y5/pLaLw7jZ1lNhyLuEg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+vtuqcfMJrVcYry1RWbKP6CNn6oVEUrxrIbSLHeN2LnzK+bfiQ
	stMLW3MihGIVS1T5NA4Rll1YOYFJzlYBIYkVIAElLyYnPrucmiifx+0h
X-Gm-Gg: AZFdTZfAH4SJbi0radjggtfc2beMAXXYK9vp2dEIy6LZz/a5lOnhl+G/XxbhenXix4i
	8tXN85dQzl3LvQOIoFKZs7h81bG5rsgFKfnd8jSqLKqEdMCbkzyJ+503IxhsgEtfDwPlycURDqa
	pOOZ2/Scun3gDb8wZfBg373WJAXZCjmqZ2cO0uHhC68cnF+L4J6lkUMQOrj2tY3YgHr73uvGAUq
	rJ52yU5gpve9qiGI8x/oh5FLH5heiOkjASGgdoTb6fdKSjBBxFO/5UF6l666KBys5ugwrCsAqvh
	5sxG8GSL8LKhxOpcT1hYsoBT2OLFlS+7yzwRHyFI6Pv1jhIUVydZ4lxUQLsoT83aP4qZhsAvxZO
	HZczsU1wVPJ2IHyodLCG5ac56piN9vmi5gnS9c3sd2wbJprvuKirGQHCUJDFYSDEQ3xoKw1XmsR
	pleufCMfiQ1mNFwWUbuxh57Gudx0IfDw2MUfaa4gef1/WDq1OaFYuSdW8ahfMqSHjzroWbpPOBJ
	d9ES7ExulofxmLwKBdGIXfGZZtRVUHY1MuWv1pa/cR5begtIKVJ1/uPpbKBAXaZhuWvA+08UIpv
	77ttHVXCUv1ZCMnbsaps7sWIS/c=
X-Received: by 2002:a05:6000:4b0f:b0:48e:d7c:4bc8 with SMTP id ffacd0b85a97d-4abad6a1782mr21438558f8f.7.1795443327853;
        Mon, 23 Nov 2026 06:15:27 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ad6403fdbbsm15815535f8f.15.2026.11.23.06.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 06:15:27 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=d4d0d8ea600ad9a6a0e804d6ccca97eae7564ecdc87e5749b6027a98fdf4;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 15:15:25 +0100
Message-Id: <DN2NJH234CC4.2LSWRSOO4TX5I@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>, "Darrick J . Wong"
 <djwong@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH 1/3] vfs: use goto out on error in vfs_fileattr_set()
From: "koraynilay" <koray.fra@gmail.com>
To: "Andrey Albershteyn" <aalbersh@kernel.org>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-2-koray.fra@gmail.com>
 <awP8S5KF9v-nqWVY@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
In-Reply-To: <awP8S5KF9v-nqWVY@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

--d4d0d8ea600ad9a6a0e804d6ccca97eae7564ecdc87e5749b6027a98fdf4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 9:42 AM CET, Andrey Albershteyn wrote:
> On 2026-11-22 01:08:54, koraynilay wrote:
>> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
>> in the main body of vfs_fileattr_set().
>>=20
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>
> Looks good to me
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

Thank you, can I add this tag to the v2 version of this patch (since it
won't be changed, and link to this thread in the comment section of the
patch)?

Thanks,
koraynilay

--d4d0d8ea600ad9a6a0e804d6ccca97eae7564ecdc87e5749b6027a98fdf4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawRKfQAKCRDmj22qf5IG
XGk/AP9j2YLEmAts6UKmrX6qw0EDoHRjv0eLrfHDRJfhkjSDdQEAixfLgqqT3tMt
wDbEqGGddyloPl2sCvNgcE83htldvgM=
=8yb/
-----END PGP SIGNATURE-----

--d4d0d8ea600ad9a6a0e804d6ccca97eae7564ecdc87e5749b6027a98fdf4--
