Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218422;
	b=TA3JuJ1jKAN9TNpaFEiy4rR8hdtyQ/hAoeW/E3KmILuXuoAVsBqhnS2iJLbB+6260Nz8
	 V1n0b9wNFUfNJ6/j8IEDLyeiQSAenjX1q7Wy9lBS3+YjmpK87aT8m94Xzbyvillg8QeP6
	 ivRtk6/TcZKHh1F8DPcFbtrrLcQ7ufm3CBd9wSBNQ7KOF2ATS9GtRmqGTjhaRb8IGS5uf
	 UDo+jzGxrewCaV5f+RUtCs5QpZew4Fbzb0wPYW7N9FKJQy+WSLT/gSsrenneZq5lHKA2M
	 We1q41KPo5IXfwk9C9nQj5Q7fiKYs9rA62ty55U2uWvGDCthCm5537CmRnDkzgeQxSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218422;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type;
	bh=OMK++d/FLsGADB143FIELLc0iCFGZByNdKn1x6Cr6OI=;
	b=PGtEvHuMDNPDQa5zigPiXaxeFyKScRveHlxbLyTPtR5YGSMe5qwobubn20gVIV77aLIY
	 sh7jRWxWwtvCZ1HTlQEpI1GP5OfcCupFbLikIk1IJVJqfY+uNPs0UBgmOEPU6imgIhliy
	 PNym+J0uljkil+HEMy/pJo4hgtihltaJfEuf4+Nw38cWt5ip9jhZed1W9J3QvO1VG6mxg
	 RDMRnqXm5jWalbnElAdfvpIqWNX10/CYjJh1eZGv8zbQD869dupDwaocqyPGTbE9Wn+px
	 a+aU/r9CnGDxC2yf+6KjXIld09qYLVL1JrLg0jwCOVKRWpSZzK9iUluec69mGG/K5NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zliang.me;
	spf=pass smtp.mailfrom=zliang.me;
	dkim=pass header.d=zliang.me header.i=@zliang.me header.a=rsa-sha256 header.s=protonmail2 header.b=pqwSE8lk;
	arc=none smtp.remote-ip=109.224.244.20
Received: from mail-24420.protonmail.ch (mail-24420.protonmail.ch [109.224.244.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EF7606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 20:13:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00EF7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=zliang.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zliang.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zliang.me header.i=@zliang.me header.a=rsa-sha256 header.s=protonmail2 header.b=pqwSE8lk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zliang.me;
	s=protonmail2; t=1793218420; x=1793477620;
	bh=OMK++d/FLsGADB143FIELLc0iCFGZByNdKn1x6Cr6OI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=pqwSE8lkbqu2ZpAnsExOqZkWXRZ0Faqz77m8cnNY1R2KTBN4F2kthCID6iKZMc/bZ
	 MT7vuqtxWID+ARqjVMhnFpCjNR2KphVOUO4vsKxBl9KSLA2GGGR0mc3lXl+u+J3zog
	 hl6iVdAfdyT7vNZeBXoG5m2T9k1Kpv7YCJ/kTbY/ZkA/WKnJ/XR264PAm7mZYYAXey
	 RTwlbgdk7GiSUWwMWik2N1Mane8TeVPDQNiNyFJwVPqeGj3t4FKgjiIt56UekGhn1T
	 9PPV8YzlVlEtYLPRtp7VcZaH4lRMPHXEBugqUIYPTVD8SSna7PW9uutartw0GZUh8l
	 D7BpvZSX8SEzQ==
Date: Wed, 28 Oct 2026 20:13:36 +0000
To: luca.stefani.ge1@gmail.com
From: zhiwei.liang@zliang.me
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Robbie Ko <robbieko@synology.com>, Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH 0/2] btrfs: don't expose ERESTARTSYS to userspace
Message-ID: <GVPY1g44XSPvMOBj-XoNvfOoc11_Rs6iaF8UWUeCLNPb1KRz6Yh4Ff1F8I_ElHRyyioSE4SOgPP_Dqs2f3AvGMXcijcqtPL2BeipvYeLkeM=@zliang.me>
In-Reply-To: <20261028-b4-btrfs-fitrim-interruption-v1-0-bf5c53738b3a@gmail.com>
References: <20261028-b4-btrfs-fitrim-interruption-v1-0-bf5c53738b3a@gmail.com>
Feedback-ID: 165418692:user:proton
X-Pm-Message-ID: de0bc53b9276dad72f544a688701fc6ae69247da
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha512; boundary="------bc954cd9b26f5b17fecc0cdf04f4dc2ec2c5841cceed8eccf673641f4a3c5400"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------bc954cd9b26f5b17fecc0cdf04f4dc2ec2c5841cceed8eccf673641f4a3c5400
Content-Type: multipart/mixed;boundary=---------------------5c57f3042c1d397c32e50393fc41d44c

-----------------------5c57f3042c1d397c32e50393fc41d44c
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;charset=utf-8

> trim can expose -ERESTARTSYS when the trim loops gets interrupted by
> a freezer request.

Tested on top of misc-next with the pm_test=3Dfreezer reproducer from my
patch, 30 freezes during a trim: no -ERESTARTSYS reached userspace,
fstrim returned 0 with the partial count every time, and freezing stayed
under 30 ms.

Tested-by: Zhiwei Liang <zhiwei.liang@zliang.me>

For 2/2, I think it wants Fixes: 69313850dce3 and
CC: stable@vger.kernel.org # 6.6+, and the changelog could mention the
"Unknown error 512" symptom for people searching the log.
-----------------------5c57f3042c1d397c32e50393fc41d44c--

--------bc954cd9b26f5b17fecc0cdf04f4dc2ec2c5841cceed8eccf673641f4a3c5400
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wrsEARYKAG0FgmriV2EJEDHcSF0sTuj3RRQAAAAAABwAIHNhbHRAbm90YXRp
b25zLm9wZW5wZ3Bqcy5vcmeEd6Wc9GVaJ2UtEEYDzt+f6Jh6+h6ZgiqoUy9k
DJOQERYhBB7SH24V93YjvuO90THcSF0sTuj3AAC+IQD8D/8FEBFrLNmrgGmQ
dWXRGsrC+6mlizZE/FbGyZXDjrQA/3EC+CtRT/P4f+/DDqCJOZa3yq2PHH6V
1MKvh6yUb7MG
=71vU
-----END PGP SIGNATURE-----


--------bc954cd9b26f5b17fecc0cdf04f4dc2ec2c5841cceed8eccf673641f4a3c5400--

