Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795769326;
	b=XprrZUTLWqIFubjzFSSE5s9irpjnc4GDDti937kOWAqhT5YY2JO3ZWNhiDKrCRriO+HY
	 q2xTyRmGU1ezakviR1rreucEuWzA5Ere+TD5fdeZZx7ZW7a9IufCDrncSdtqXnzu5GXac
	 Ir62YSnSJtFx3OJC+a1QUjzvoYvjwzB9pYIKMTHWfoP87VpFr6HBnrtHJMrnnDsqmrBa6
	 FUugi3bxGfi554CJEApOMJa7vlrnx/db4gBQlSEYavf6iUKUOqwI7tgGy58jTfpn7gkHp
	 tllEaDZdgXSr1lqavJLOZM7kKP0Iy7EmTaZO0iVszCq4YO1NkTCiAKds8dIravnJ7mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795769326;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=IDez9NqT7Tj1QDvV6FYEN7zWNFn2T031QM3aseBOhj8=;
	b=5b8labWCupexsYFLCMWaOODDvXvhAUlQm4rlHmFR79hAgUFiZFgx20MralCnlx0SZDEt
	 W6m8+1bC0cgan88P9b5Xu4Jx5P6ZwXMSTWBSJ82uWeJvjTxzL2tbcXTMO/ZyKyNzGZ42h
	 eu08HXemVsifVCIO86vI9cvCCUHi9hFSa2bi7DbY/jTmLsTG+arH6+lc5eyUcpdC4UXvf
	 x+GqlKip12KHBc6o2ykkN/QCaXRJsEW2xRNV8XN2U8Qxsurid4rTbXsjKbkqhR5ijK0/g
	 /sueT0yJRI91dk0l6TyDVzrDS9VsL1jLuOR5RwIIXbae+GvRJjA5YBZWgX+zj2EseBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dbJOZn5M;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F674606A31E
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 08:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F674606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dbJOZn5M
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4b52fcb410dso3031948f8f.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 00:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795769324; x=1796374124; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IDez9NqT7Tj1QDvV6FYEN7zWNFn2T031QM3aseBOhj8=;
        b=dbJOZn5M3rCgRLPPOUJ++VnJKMJQm3Ohn3x6VlLjqOyC2bNT9/mOFF1yxLOyrzF1bl
         C+Kj5lfk/G5v+Ibl6kXxQpP75b5N2GOnPrygQfOpb+hL8pJdLWW2ruCSdOPWljpoOom9
         3k2U5q90CgtKcvQNVpmkgFpbHw4JRD8hnkpuKZMsHjBoE3LC1jnUEnzmSEuovDxk9r9t
         Wtqp53MEml1QkDIqwqCWvYw2/rzLoJc4/KbtnJ3GcoNMKSCSq01qjbob847q1eNmgWQu
         Cney17f61yibRSRiKAu1tIAGEODdNaIqbSZsxA3cV2i7XAT3GC/VSTY+hR3Urp47LrxJ
         8cOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795769324; x=1796374124;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IDez9NqT7Tj1QDvV6FYEN7zWNFn2T031QM3aseBOhj8=;
        b=XkHZFof4Edql488+S/KsGWboQlMJrOqmvvsPCp1mTqLIzjXIMzg7RLQB1+09yZgBCl
         ChAXoWUYF1PglTPK8lNi4ftQoBIi7vAovKsew84FXi6op0YFfomeekmiH/tk6Ui+WVTN
         pfg/Xbe/y4tDb5hm8SZlaejNRQLQe0jfM5uZLM9OvPvOQU17CdCH5wuYom+oyPrRw7Wr
         l8jrkvPlF8lNUu91bg6N8cXmeGk0oamOLd00xlHIbTPNLa8bgat3m+zs+YUO+Omka60j
         iDZ2TvB6ajRlcBf+ZMg8joPV41XoVnIvchb18c0+vT2vPSghpYA1P46YkOFazbRlm2hu
         txEg==
X-Forwarded-Encrypted: i=1; AL+hErGLeg1GZY+aEC13f5QHJv7Uv5jg2LGtd63txIfv8sR7pzV7ZVs2+pG3fkYkt23GJM3X8N6/eKU+WQ8ELg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/2MuZEUNSxI2KHGXTehsiLiptmVn3YaWZ4QyshIM3oqZ6GCHAn
	qTXXGO2Qh7pusKyitQjZMKq/dQM2to+piO7IP1X3WqNiu01jgrqtQU2N
X-Gm-Gg: AZFdTZe7GAzyTisMAlVRybNClSCKOzSXdSlqwnYHtDlrDo63PtbZswe53QCFLLy21Zk
	KQqQrjr08mzx2jWg9q5CjDkR+L9Vmy/fvdyTTxcYCga5hOtqs1gYDIuD4Q7URq0ZJxe8a55/tpA
	4QlbSy8xRCCQGhxzAnbrswqXhDLquQiqr/UoCHdWmlHGZM8p1QVKnKnR+ZeGelaVnnKg7L2H3tI
	AL+UPhw3EpVrhVhjkldP3Hkkia+FfSMhUFLRz0D6MNh5zyFjec1/LfqAsUKXh8QnTfi0VUjpnaW
	Io9qluPCC4TKsvRcAf7QPSBLlsNNR0F4Rm3YYWQx2iGhXVLeBp9sGioC1XO104YpmfyaMb1TYmN
	ZY3VXrifm61eW/1uOkUvvyLP4S/N4eE+vCqyogfFM7b/eaIwuMePgOCZMnODP4baxaeeATUr1DN
	8w5ZS1g5WE+hTYi6TRErTiywwNhWsGuaqFFWXHsYYua7YvqFQz7jg5V4Fdg48RAo3YgQvkr1mQv
	c1DWjNFPZEoWu2vlSrbxdQeSK9To2U1Y+1lDRUf60PPjrIrE06DP+4+ihqyVNgY0FeqV7D3W1X3
	muUHMukJu+a+6adihumfK8BFOS3u5kfBk5tMLix/nN8JgSZ4iDIvX/dhS8Z4us7d0OICnA==
X-Received: by 2002:a05:600c:4f81:b0:4bb:5e8c:13bc with SMTP id 5b1f17b1804b1-4bb88805902mr454676765e9.7.1795769323802;
        Fri, 27 Nov 2026 00:48:43 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906635c7sm426511305e9.2.2026.11.27.00.48.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 00:48:43 -0800 (PST)
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
 boundary=c6f8ca06bd0087fb130def184d18448cb7c766d554c063c5f32d1cf88680;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 27 Nov 2026 09:48:36 +0100
Message-Id: <DN5V3F9BWZNC.ZIJY7Q6XMDOM@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Eric Biggers" <ebiggers@kernel.org>, "Theodore Y .
 Ts'o" <tytso@mit.edu>, "Jaegeuk Kim" <jaegeuk@kernel.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan Kara"
 <jack@suse.cz>, "Alexander Aring" <alex.aring@gmail.com>, "Darrick J .
 Wong" <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, "Lauri Gates" <lauri.gates@gmail.com>, "Christoph
 Hellwig" <hch@infradead.org>, "Dave Chinner" <dgc@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <ntfs@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] vfs: use goto out on error in vfs_fileattr_set()
From: "koraynilay" <koray.fra@gmail.com>
To: "Greg KH" <gregkh@linuxfoundation.org>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
 <20261126163114.403846-2-koray.fra@gmail.com>
 <2026112647-earful-frosted-6ef3@gregkh>
In-Reply-To: <2026112647-earful-frosted-6ef3@gregkh>

--c6f8ca06bd0087fb130def184d18448cb7c766d554c063c5f32d1cf88680
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 26, 2026 at 8:05 PM CET, Greg KH wrote:
> On Thu, Nov 26, 2026 at 05:31:11PM +0100, koraynilay wrote:
>> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
>> in the main body of vfs_fileattr_set().
>>=20
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>
> Real name please.

Hello, this is the handle I use for everything online, thus my "known
identity", and even Linus himself in Commit d4563201f33a
("Documentation: simplify and clarify DCO contribution example
language") said
> And despite the language, we've always accepted nicknames and
> that language was never meant to be any kind of exclusionary wording.

Also, I already have a few accepted commits (here[1] and elsewhere[2])
with this DCO, so it shuold stay like this.

Thanks,
koraynilay

[1]: https://lore.kernel.org/linux-cifs/?q=3Dkoraynilay+%22Applied+it%22+f%=
3Ajeon
[2]: https://sourceware.org/git/?p=3Dglibc.git;a=3Dcommit;h=3D29803ed3ce

--c6f8ca06bd0087fb130def184d18448cb7c766d554c063c5f32d1cf88680
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawlD5AAKCRA0bnTtJTDo
OA8rAQDeEx1D2WxXRvyGunXEuOW+Cj+dElpy7MJchlEm/WMNBwD+JvucXkEupO3z
6yiHSY99QVuCP3aqlN/orccezZlLGQ4=
=mM8H
-----END PGP SIGNATURE-----

--c6f8ca06bd0087fb130def184d18448cb7c766d554c063c5f32d1cf88680--
