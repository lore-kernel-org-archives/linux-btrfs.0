Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794302963;
	b=gUCMbXcC7P4Ca9bvPwOCIusiiOdsGTXcewjqglx08G+bufGIvhR7xq+Eu6XkXgLBKrJU
	 Gme/4sKG4R1a/X5leNpU2Sn6z6x0VqQRYV0xCN9pnlYejUHd9q4dHnNqaTGv4lW/OrL3W
	 P1WbqdxwAfiDWbuxs+Cu1S/BlRV8fWz99UMNGa+oqtcLvYI2g+0jwYBX9CHPMQCWH/tu6
	 AnsqnjcQwbqInL91fpi/LADL7gNijaywEmpFSl9WLpu3xrP9Ggw+sGJKOAy93zbFyAQHJ
	 O328qVENcNflL0LoRbVTQaHjRqBnvvxGT72XQ6qc0FgJFLsLqIM1/UY2MpwxumgNkGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794302963;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:X-Mailer:
	 References:In-Reply-To;
	bh=Ta7Rmu2fpHeZDp4qmckKp7R+s67LUiF51AacgPVr8kE=;
	b=VaIzkZDgkpOHBnrRwFxMVBetkBUYZopL2KlwN4S8JTtdvmjR85AyDob81lBAyMgVoS9z
	 tPCOSuBML6xKdi4zgho+jP2/GGky5jtdz0/3DgzewNpNkTI9Df+DYC3jXADaOwYwDh4qR
	 NT24GEabCKk3ghXSxWS/eC32fRpaWaT0OxRPxxRtO2A1zOv30cJa/LCVAIvhGU3RO7PGN
	 EIfTsowKYfGZywAMfiq1j8SA30Zc2+YroN0lZHmQsxaaR4zqLWf7p2wI3wFDHEWGpFVNx
	 XsiHunCEJgDIlrQXwCLIkyfToJaT+v8iIxdflmr81eokbrTN1uVE3mPVjtSNPvT6gvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FvkvzyHp;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28556606B147
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 09:29:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28556606B147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FvkvzyHp
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a5036bbac7so11540895e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 01:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794302961; x=1794907761; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ta7Rmu2fpHeZDp4qmckKp7R+s67LUiF51AacgPVr8kE=;
        b=FvkvzyHp+7w5iCyIxqp3Y1bwrMWS+d+A+/F/Bx98nfZGd/AQuCoWn7rBsmWmy8nhfJ
         kna6zUSwt1wD43MF7xeJbllogs4bhgjZVQ5wPcTdoq0M2cl3Xnvm+IOmTeE/8vIjSsL1
         R6iFbcS76Q51Ex7n513e8xWTc8Mro/V0UOk+GcJe8fc8n+pdmkahAe1bpsl/8CWWbRB7
         xtUwKXk3zO+SdqN5/1nSq+V6GK6Fv0erbWDHEV/B8nrsm+wTlpBFxm+mga4KvUo8NdPX
         rLsiV9YGNb58MEITqQgo5GTS50ppMZx37+muQDYrBc3DZs15NHQhAPCRJ5KIga52wEcY
         2BOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794302961; x=1794907761;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ta7Rmu2fpHeZDp4qmckKp7R+s67LUiF51AacgPVr8kE=;
        b=PtXzYe5KXyrZpmtkRp3CvCOtW9eJQT3hPHjkcrsNIvoBTxHL2ieDMOp64nUvyNg7bV
         Ng3dh6zOwy5rld96Ch9EFGt0/j6apbDzrWZ090HaLLhZMH2ds4qbPAczf32uTRJcs+dk
         VOFyEvsLckFe+lZijFCY7z0FwpV/yQhi7oj38NlS0v2TW4fH4q6DXUew1Qz7/atzXpKs
         XrvmpdGWnNLYNW9SMiFvvFlYCpxIUXRZDZg/K+nOmO5R6lppH4hcvUNnsCtMjjU2vWF5
         d9z9E787S7aVmGrxmwC02XaCRpVXk2htnmITvcadIOuL+/jW9r/WjTRYGEeScC0uc8mP
         u92Q==
X-Forwarded-Encrypted: i=1; AL+hErHH5GVwcfem8TUqRvekSYqv124zw3lF58h7YLAyVhVcg/V44jw3PGgkWCjQg1OD+oiX+DbIJuJY8RB/yA==@vger.kernel.org
X-Gm-Message-State: APuU4Z8R7KmorISCxoeFDyX/jKR9LnllEEN0a07O6lQfN78yUoW88oJN
	QSwFc42q9xE5XFvKmP0C7bN2mfYhqckhtkMuzRGjFK48GDPyBLjObNJJ
X-Gm-Gg: AYBFou3Bu8O43ZjjFJr0kvdMz7bhzbV3Ai+p0sHpT+BmNJe0dwIC0bhIttwvv5oYCpW
	Nk8WNuQRqJny331S6b937eOHb5UCBJ3uN1s+G38n+hdqf3Wf1cbfFpQ/PszvaBkGOrhsAFhZtbz
	jzfacPMTWpjhiruTOiCn4DO7j8VOEJXaS3vOBt8UK/kf7VsJA2RhJ2awl7woQW2nzXFQrCZuFVt
	v2/sk7tv1ahICNi/fTdQn13jOboqiO0/016LWAkf+xFFnCDqN5Xb6Cuszo4zS5fXCOOpxhgQc/m
	8ZgY2+lucrXUs9j5aKbxUUyThE364hMWmTonpmMY7VVKz6faLlqgN5EZ43q3cxgxLfNzSeQS0NU
	2/otlMSlX4+z6xdKPtcOaOL2VjP5WNPlkjhaYZgoksoSZ/YpPKxPzN63WzssfQAh/fBxiMyMZJ2
	n2qlaD0yBkjxy39c1o1EuwwQ+ze1JGpdMrL+cwUlldsgbv8UUxArUqJK8WhRIjgprRpI11se0FK
	gOQhVWTkPHY3rOXa4d2m38xjbsewZ+2tKLJnctVnZRMSlD49zCzxqi02yxFg5lOBgzD52QvwHL0
	UHOLh7k2hRL3n9sqS2O5GkTKyZxTu5lcnfQJk1n3jnRMz4m1RoMgwOtpNZVmd6J8qBNOBM0=
X-Received: by 2002:a05:600c:4e08:b0:4a3:2f35:38aa with SMTP id 5b1f17b1804b1-4ba0234f05cmr28642815e9.29.1794302961104;
        Tue, 10 Nov 2026 01:29:21 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba023690f5sm38482335e9.3.2026.11.10.01.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 01:29:20 -0800 (PST)
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
 boundary=d0aff31089870834420541c7cbc50e6e7be7fe8f58ccaa249c6a287d39e0;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 10 Nov 2026 10:29:16 +0100
Message-Id: <DMRFBAXJM4OA.CV6LZNBPYR7J@gmail.com>
To: "Sterling Windmill" <sterling@ampx.net>, <linux-btrfs@vger.kernel.org>,
 "koraynilay" <koray.fra@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>
Subject: Re: [RFC] btrfs: forcing compression per inode via the compression
 property?
From: "koraynilay" <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <557fae4a-3c08-43cc-924c-89d1f0f3896d@app.fastmail.com>
 <DMQQG1D324U7.2945KG0ANDDJZ@gmail.com>
 <5225511a-c66f-40e5-b9d6-31ff572496da@app.fastmail.com>
 <DMQYN0GE281B.1PW8AIHGLUNDF@gmail.com>
 <bebe248b-8eb5-48f3-8dc7-ddaf8e4a09c4@app.fastmail.com>
In-Reply-To: <bebe248b-8eb5-48f3-8dc7-ddaf8e4a09c4@app.fastmail.com>

--d0aff31089870834420541c7cbc50e6e7be7fe8f58ccaa249c6a287d39e0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Nov 10, 2026 at 3:50 AM CET, Sterling Windmill wrote:
>> I read the code a bit (and bounced some ideas with gemini) and I think a
>> "force:algo:level" would work well.
>>
>> This, compared to "algo:level:force", would also allow a "force" value
>> (handled like "none" is already handled), that lets the user set *only*
>> the compress-force, without having to specify algo:level, so inheriting
>> from -o compress=3D, and the parsing would be as simple as if ("force")
>> str +=3D 6, where str is the xattr string that gets then parsed by the
>> rest of the code (in compression_apply()).
>
> Thanks, a bare "force" value is a nice thing to have, and I agree the
> separate property isn't worth it.
>
> From reading the code only, a few things stand out for the bare
> "force" case, where prop_compress would stay 0:
>
> - compress_file_range() starts from fs_info->compress_type, so on a
> filesystem mounted without compress=3D there is no algorithm to use.
> It needs a defined behaviour, such as falling back to zlib as the
> chattr +c path does, or having no effect.
>
> - The check at mark_incompressible only looks at FORCE_COMPRESS and
> prop_compress, so a failed attempt would set NOCOMPRESS and leave
> it behind after force is removed.
>
> - btrfs_compress_typelevel2str() returns NULL when prop_compress is
> 0, so children wouldn't inherit it and btrfs_fileattr_set() would
> fall back to the mount algorithm. That helper would also need to
> emit "force" in whichever form we choose.

Ah yes, these would all need to be changed (but only small changes
AFAICT) for a "force" patch to work.

> One thing I should have mentioned: Qu pointed out on v1 that older
> kernels ignore an appended ":<level>" because apply only compares the
> leading bytes. "zstd:3:force" would keep that property, with older
> kernels treating it as plain zstd, while "force:zstd:3" and a bare
> "force" would get -EINVAL from both validate and apply. Is bare
> "force" worth that trade-off, or would the suffix be better?

I think it's a worth trade-off, and my patch series already will break
some setups where users had "zstd:random_text" (which would be
semantically invalid anyway).

> If we go with the prefix, the match probably needs to be exactly
> "force:", in both validate and apply, and "force:none" should be
> rejected.

Yes, my current thinking is handling "force" exactly like "none"/"no" is
handled right now, with an additional else if for "force:" which moves
the string pointer to +6, which gets then passed to the rest of the
checks as they are in my patch series.

>> It should probably be a separate patch, but it'd depend on my patch
>> series, so not sure if I should just make a v7 with that or not.
>
> I'd lean towards a separate patch on top rather than a v7, since this
> is a new feature that may need its own discussion, and it shouldn't
> hold up your series.

I think adding a force patch to my series wouldn't be a problem, as my
series has been finalized since september, so I doubt it will change
much in merging time.

> David, do you have a preference? And if the series isn't likely to
> land soon, would you rather see force as a small standalone patch?
>
> I'm happy to write the force patch on top, or to test yours on the
> images from my table, whichever you prefer.

Yes, please test mine and also write a patch on top of my series, I'll
be happy to test that on my end as well.
After that we can decide if it's better to include it in a v7 or send it
as a standalone patch with references to my v6.

Thanks,
koraynilay

> Thanks,
> Sterling



--d0aff31089870834420541c7cbc50e6e7be7fe8f58ccaa249c6a287d39e0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCavLj7QAKCRA0bnTtJTDo
OD92AP9zLKee3SkHlJxIannr1eSEcrVCRwc5KDDwu1cEavlubAEApIrHLhaPg0a2
IplfzxAIN+3eHaUZjvPrxRjJuOELvAs=
=JgyW
-----END PGP SIGNATURE-----

--d0aff31089870834420541c7cbc50e6e7be7fe8f58ccaa249c6a287d39e0--
