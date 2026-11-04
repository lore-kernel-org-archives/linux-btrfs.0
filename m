Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793792253;
	b=3RAqgwG+kNt6xV28+0ndr+H1w6Drr8FjHowrFSXHdS5ka9L3HNlRuSgxFtUTIMKenEtO
	 gKUUcNbbDa+UOrw0d+Ny8y5n2IQaLdwzg6L2V5UTIaR+izEDWeQLSpRW29B4Sf/lnjAVs
	 nzQZfMBa78cNxagBhgLebdNuLrAcWCEZ+64W7f4/i9tjB+eGjxmG1Mt0MF5AozoOjwWcP
	 dgwEMMdGW9PH7Fs7KD9amTlkIAG3sQPlDl6e5nwT+Khg2ZCrTurxdqh8LGcrQM4AD/C8O
	 6w6zyP7TSXmphOZHHz4tkG2nKK0UTMQB5EPww1+1lNueuYtmMaglmP7zrOwC0a1AVSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793792253;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=m1N2CPL6JIQI1DoRI2I/9sbG/YpOMPe6UrD3Lt2CabI=;
	b=uP5fVsMlWIijaA66Evv9cBAZSA4aQLIF6XF+OC8BTBkpi5Q7EMRi9G0308uiF5GiaEtC
	 fpiHFJpHbjWw0jCG2FhSKlZNldS4KduIJSkMzAWlKHjxb/IQSzxwHZVKg1JDZRLxd7HMK
	 t5Ho1IkEIk1sIT3gju1bLp2qc+6xYDBvD+TFGZo19afoOlNnGrRL+VOBdtd3oVGh8/yWt
	 1Sy/bwyI+262gqvGRFnlRHObh6+Dbvpj4QdbwFB+EU2v9+UVD9nssD+RbZBexHOZK6VAq
	 Em19AKVXAIOiFt0HptMQfrRFIR5Ypogj3yS9/uGe2uNOIja85cRxtz/5A93wPbjYUYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xcw7KGuS;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE730606D80C
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 11:37:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE730606D80C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xcw7KGuS
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so4758725e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 03:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793792251; x=1794397051; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=m1N2CPL6JIQI1DoRI2I/9sbG/YpOMPe6UrD3Lt2CabI=;
        b=Xcw7KGuSrQbG5Tb3P8/nfqRZmZgLRlBjOTNH+WvaQdBXji6cpW64IgeIjQL9XkRN5N
         KIuqrnkvCeZ/qHlLc9gcjGNmjJyZFj7y4yqbJkzF3XkSSuAj0jXe94VXz/qZvwK7oUKa
         SYVwGk0HKx36TB63oIZd927U/3+x4Ww9XmLRShldoZiZULsqohiqmuKn7MoV4IRu0a72
         cXrldU1rib80Nj3/ZpkMBtTjxKEI9xNlWpE48PJM3KnZNXH0FfUPDfckSru6SJJHB4MZ
         JcvNeQe+fGJrI+83S+u+Qjs/4b7EUSxjQKwmrmPqph1h3xota5ZdJKD87XMz/meO5L8K
         pdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793792251; x=1794397051;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m1N2CPL6JIQI1DoRI2I/9sbG/YpOMPe6UrD3Lt2CabI=;
        b=qIYMJC9WsOV9zhYgHM2GBZCmGsWUE7X/pmwU8jSmULGutnNpKQilW9VSeSfByekFug
         K0vliLZ0GEB9XwnzYd1tKsvP4fpmg73v7b3heq1Qxoz74msk+oAOF84SP8NQStfSWE5N
         wb78FQJCUNxJyTMUYwHkWxrNgwnsaLIAqwcyPcu4vB88NpTSOsDEMS7WkDuOXgsdxXt4
         HDpuTM8T5v6pDJqm/CjvRwhn5hLCK2td+7Lc+k+CO282BqC3sEXrO8wcT4CnOQoc/Xfr
         5HprVLLDtd3mVF90nrItlvcaiyq5jQkXCebqawOYHblyOAR4VKYga+LQf16vHnzICWEe
         oh/w==
X-Forwarded-Encrypted: i=1; AKwUvByWDcoKOr1SiZHaOA8RU/MUDuaecSvAJ+kDwthZW8K2023X2rbSSCo5tRrqmHdyoMVVRtzPCAob43fyFA==@vger.kernel.org
X-Gm-Message-State: APuU4Z98NeTOccFUBHPQp0niI7jPF+DpJLrRzYr8UsEQF1+NFH4TeOd1
	4F1ZRr4KVYGdcQijGwkWvy5xYeTy1xHFJhF5qy9DYF8nR961rrPaiTye
X-Gm-Gg: AYBFou0xR20BGJySDpL5lElnNgxu/YFmJeRSV7x3k2memeN9uFf0TNTxJTUk72YIY6C
	eLsXhrYsM/8HybxsLFCk+PqofAAsyjhIbEfZhkLwsRoU1MjLwgpDe2eZ0LaE4zKJDrqpImJ/2Ks
	WiZlNFOpD7g7knrs9Bvo/gw8iscGEDb1qdw1TN5FEOAY1lcyVJlolQI16dCtv+Ug/oc4JxdivDn
	lWF1hQl5bso9/4RnXAMMoWJV3MtQE8Jm1hZiCO+vB5difhER44B+PqsjnomabEvyQHRerXLfRQ9
	zmMveexs9c/WMBmszlE7/piPId4BhVAg98wjtVWJOEOWTRR+cvIshCNr/KHu9wqIEHLQIzOxyTT
	huE57fdhZbqx2EIZIdUqWz4lhaShz2PV5FhJkW8DUP9cfTTx19t71vjKtcZQ5+PF3tP1hVK+pcm
	FBSP+Bmq4TtC4YNm0e4vQDIB8GnLs7gLkFk38hf7ZS29/0240D9KzdM85PivNT2/uvMOJGeU4YE
	zQpTqx0ijm2kh6kR1WT7SRoq0m+YUxVxZzqBb3/IfPEH2CJrviDzMeuU8n6tfvU4T075SIrf7+U
	0J1SQKwO1ZlrrLFyjWkxJqzDRJqmwyDVvz4LKySZo7LefzB8gOPjjNEQaBIn
X-Received: by 2002:a05:600c:83c5:b0:4a2:148b:c88c with SMTP id 5b1f17b1804b1-4ac17191017mr340673885e9.8.1793792250984;
        Wed, 04 Nov 2026 03:37:30 -0800 (PST)
Received: from localhost (mob-176-246-9-149.net.vodafone.it. [176.246.9.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2aa481a45sm122452345e9.7.2026.11.04.03.37.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 03:37:30 -0800 (PST)
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
 boundary=48cc1ad8402764d92e1376cc3050a9a9645276db561dde693e9f605d6644;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 04 Nov 2026 12:37:22 +0100
Message-Id: <DMMEA3RCJIIR.3M3VFS656X8B7@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Chris
 Mason" <mason@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, "Sean
 Smith" <defendthedisabled@gmail.com>, "Andrey Albershteyn"
 <aalbersh@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
To: "Jan Kara" <jack@suse.cz>, "koraynilay" <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261027220532.736352-1-koray.fra@gmail.com>
 <upe7qvhod63zd724s7uiql6kanqyrcwplodoavcvqjt35vd4ee@s3iglizxejlr>
 <DMLN8XHASPL4.1R3MI7CMA5KCD@gmail.com>
 <unzslqbr7karhkgfxrcmjwgtps3byokmsqecyouqlc7aa6cszv@pgup6q2nxwt6>
In-Reply-To: <unzslqbr7karhkgfxrcmjwgtps3byokmsqecyouqlc7aa6cszv@pgup6q2nxwt6>

--48cc1ad8402764d92e1376cc3050a9a9645276db561dde693e9f605d6644
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Wed Nov 4, 2026 at 12:33 PM CET, Jan Kara wrote:
> On Tue 03-11-26 15:26:20, koraynilay wrote:
>> On Tue Nov 3, 2026 at 2:25 PM CET, Jan Kara wrote:
>> > On Tue 27-10-26 23:05:30, koraynilay wrote:
>> >> This is an initial implementation of a new timestamp to indicate the
>> >> time when a file/directory was initially created.
>> >>=20
>> >> This patch series takes inspiration from the one by Sean Smith
>> >> <defendthedisabled@gmail.com> [1], but using
>> >> file_setattr()/file_getattr() as suggested by Darrick J. Wong
>> >> <djwong@kernel.org> in [2].
>> >>=20
>> >> The semantics of this new timestamp should be at least these:
>> >> - it should be the same as btime on a newly created file
>> >> - it's user-settable, so it can be preserved for backups, filesystem
>> >>   conversions, archives and any similar operation
>> >> - it should be preserved every time mtime gets preserved
>> >>=20
>> >> and the correspondence with the other timestamps is as follows:
>> >>=20
>> >> ctime <-> btime
>> >> mtime <-> ptime
>> >
>> > One thing I miss in this series is an explanation what this new timest=
amp is
>> > good for. Because frankly, I don't miss such timestamp as a Linux user=
 :).
>> >
>> > 								Honza
>>=20
>> Hello, my concrete use-cases are backups and filesystem conversions.
>>=20
>> For backups, my setup is btrfs and using btrbk (so btrfs send to my nas
>> with ssh) and the only missing thing from the backup is the timestamp of
>> file creation (which I'm currently working around using xattrs).
>>=20
>> The situation that prompted me to finally start working on this RFC
>> PATCH was when I wanted to merge 2 btrfs FSs and the only way of doing
>> that (AFAIK at least) is using cp/rsync, which can't set the creation
>> time since btime is immutable. The workaround I used was the same as
>> with backups, so with xattrs, but noticed that some files (symlinks)
>> wouldn't accept xattrs, so I looked into it and found out xattrs are
>> only for regular files/dirs.
>>=20
>> (also see https://lore.kernel.org/DMGS4KQLY24Q.14MUTR6U93GIC@gmail.com/)
>
> Ah, OK, I think I finally understand why do you want this. Thanks for
> explanation!
>
> 								Honza

Nice, thank you!

Best,
koraynilay

--48cc1ad8402764d92e1376cc3050a9a9645276db561dde693e9f605d6644
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCausY8gAKCRA0bnTtJTDo
ODftAQC9g00TbhJ4fqkc0NSdA1KvBdO2hUflWG1D9U7QPJVKNwD/e1sMPB8EEpEs
oOjAe8fi91WQcNkFmUDPnwGV8y9PRQ0=
=eltA
-----END PGP SIGNATURE-----

--48cc1ad8402764d92e1376cc3050a9a9645276db561dde693e9f605d6644--
