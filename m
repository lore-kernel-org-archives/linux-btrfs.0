Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217628;
	b=PojPzrvW/JkrkTdHKaZ458jazayRE4NU8K9SN77OZUxxy+GljKD+hCwdRSGWO6nRULVG
	 LOZQXtT42CFBKgY5hwoO8JkQbCmPTSYUV7i89AN2gFZMGTNEFFp189GeaDbWGq7nsogt0
	 JmpVUIE++U/ZPzLoIzf+NbhbJeRrxNgSEt9cNkFGlFOXQ+Xlzd3aX05g35OnDqXl3GmOv
	 avWEEKUiAwsFRFgFY4ltcJxSq2OoSdlvieEyvLWLF8o0cCohS31W9W7ossx+ZNpEDkyj/
	 YPeS5IPAf+8TniEi1mmAiF4KJHaX3lUva2YKUyYB6e5qKRulthA7aQlp89RTqPCdlnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217628;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type;
	bh=Vl+Lm6A5OBmUxuFoOG0hVJSmmgKKml1CKHflX/2QUqE=;
	b=GWc9IGGVHHnYLut9qvfTheBUPj22JzZ88JHYhmEHy/FOhrtvP4P4zJagOqAj6Ejs09jE
	 ZQsV6Pq9c8Dd0eptFo5PSzC2bevnabQ/k6+BCwq8+QnAujh9DO2E+N8HdjOMAlKd9qibM
	 3q9aJG8IDicVabZIdVKxy2J6ElgoWrdvrYZ2yZnAtGtlT92Aw8eHYDnUpPTJuu9OJ4VKA
	 pJNSnMzfss09Xfbeop4U63IEigjMkIBBAJJ/9Y1zDzpfUWbicxrNQyeUHA3+xblFYXbS+
	 fhb6n+9pSzhW0iY1oF4O3pAkbXNTuuoSQVdDmTVAcCGxjb6mzM+ND04miNvFHk2aaTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zliang.me;
	spf=pass smtp.mailfrom=zliang.me;
	dkim=pass header.d=zliang.me header.i=@zliang.me header.a=rsa-sha256 header.s=protonmail2 header.b=sHcsF95J;
	arc=none smtp.remote-ip=185.70.43.20
Received: from mail-4320.protonmail.ch (mail-4320.protonmail.ch [185.70.43.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5701D606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 20:00:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5701D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=zliang.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zliang.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zliang.me header.i=@zliang.me header.a=rsa-sha256 header.s=protonmail2 header.b=sHcsF95J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zliang.me;
	s=protonmail2; t=1793217624; x=1793476824;
	bh=Vl+Lm6A5OBmUxuFoOG0hVJSmmgKKml1CKHflX/2QUqE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=sHcsF95Jdcg0tSif8ZpiaB/3gTFdZSU/5shQswrccR1ORDpsoVXCUP1EZdrdzVWNg
	 vMmPl2ReAJrEpj5kuooNMMDu8gemyU2334VzPVY7VJvTAGztr8Cz5TYbQEUyJG9esB
	 m2NCtHKSdDU5x/D4JGGScMLIBNIF7HU0jgi8DgbinNrzfmq5+Nb3HLucu0k+kccEoh
	 J2JT3RaLuiaN1i/Zx6Ql4HWciCYCEZ41kOVBhAH/EIglnfjEFaBcRQ8iA7nGZf/oaP
	 rRR6xNvTfeb8GFxNngYx7mwHGrUJUONQSM4248mGVX6c2H95YVySv+eRJd19svXnWE
	 Eum5Vz/BkmjFA==
Date: Wed, 28 Oct 2026 20:00:21 +0000
To: Qu Wenruo <wqu@suse.com>
From: zhiwei.liang@zliang.me
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Luca Stefani <luca.stefani.ge1@gmail.com>, Filipe Manana <fdmanana@suse.com>, Robbie Ko <robbieko@synology.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: do not leak -ERESTARTSYS from FITRIM to userspace
Message-ID: <xPj9VE8ZwceqC28agNKSckSap6LPE95NGz89QlUQVY-aATkM5xliRlhFVhmdY2qXkeaf9xnXhYzyKLZBZK8IVGS01-cf76hJmrtyb5UMjY0=@zliang.me>
In-Reply-To: <8ac505b5-cb6c-46ae-8791-c39de5babe66@suse.com>
References: <20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me> <8ac505b5-cb6c-46ae-8791-c39de5babe66@suse.com>
Feedback-ID: 165418692:user:proton
X-Pm-Message-ID: 6d017a8f386244364e59b954b1e97d0c6bc46874
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha512; boundary="------a192569dad992d0f41e380b678d643f4eaf01275efa9dc9e000c24da95f417f0"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------a192569dad992d0f41e380b678d643f4eaf01275efa9dc9e000c24da95f417f0
Content-Type: multipart/mixed;boundary=---------------------83b284203e2b649a80229e74d3fe2344

-----------------------83b284203e2b649a80229e74d3fe2344
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;charset=utf-8

> >   static inline bool btrfs_trim_interrupted(void)
> >   {
> > -	return fatal_signal_pending(current) || freezing(current);
> > +	return fatal_signal_pending(current) ||
> > +	       (freezing(current) && signal_pending(current));
> =


> What if pm freeze has began but a real signal is also pending before the
> fake pm signal?

I think when a real signal is already pending as the freeze begins, both
freezing(current) and signal_pending(current) are true, so the loop stops
with -ERESTARTSYS, same as for any interrupted syscall. On the way back
to user mode the task is parked for the suspend first, and the real
signal is handled after thaw.

That said, I agree the ext4/xfs approach is the better fix. Luca's series
doing that supersedes this patch.

One correction to my tags: 69313850dce3 was never backported to 5.15 or
6.1, only 6.6.y and later have it, so the stable range should have been
6.6+ rather than 5.15+.
-----------------------83b284203e2b649a80229e74d3fe2344--

--------a192569dad992d0f41e380b678d643f4eaf01275efa9dc9e000c24da95f417f0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wrsEARYKAG0FgmriVEYJEDHcSF0sTuj3RRQAAAAAABwAIHNhbHRAbm90YXRp
b25zLm9wZW5wZ3Bqcy5vcmf0tSa/rilhrbv/ujQks5/n9JLihx8YNk9LTosZ
Rl1yehYhBB7SH24V93YjvuO90THcSF0sTuj3AAATEwEA1oqPmyFvAs1yVU93
In3VAvuTtoiRgsyCMpjJyG01oJIBAIynUtjwGt3q0X6H4+eexydfBkq0Gr0D
8o7vm+0pIfUF
=foQe
-----END PGP SIGNATURE-----


--------a192569dad992d0f41e380b678d643f4eaf01275efa9dc9e000c24da95f417f0--

