Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794255923;
	b=ctf7GI8zw8GtSToBV0vw93q7xQBdtJBrtOz9PJxdMR+PhdJApL0f1idAXQspYoHURoSY
	 PwOX63SJChfzTw7RYRU3Mos7U15a68zQeOdMY4jltyPWL4zL/IrTWox6Qd7O+cPut2kR8
	 mpPAOkOI8JOX/Y3OijyAUg9aVsXX68c8rJQilzv7IUJpT12NIVS/nZamcvSAGG1nIuYW7
	 NvPdhTY/fZ+MbguMnpZdHy0a/xpaLBavJGX76saj26Tb43lKvSv/voaxRUgSAg1+tsw1q
	 J9q8GgHvougejXRGVtM/0yjTO//mIcTOYRoxKr5amA6IFM6eMTzh/i6gWhMMa2eZ6Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794255923;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=0oogFNp0FZqZ18/GhKCes9uvKE1yG2gWC4SBY4ii9p4=;
	b=JF9QBSFfv4S8fikS+bAAgWuLZ9cZ/qykcdsTeRjRu/UI3eB5iDOWKD0XeQiLQ6O8LCDq
	 g6oxfe7eMQpoy7XWIRRFbrtp0hF0hhXSLidTHH08awFEwE6oXpTMheLAiNZMx5guZBcou
	 avNCdcKeXNXIFhM8uu0VnHbdl6NLjju5wN0lxjNIHnu7WM/MvIoB0nmnlIBmLlmyEQf/O
	 czW1hUDY9s4zFRPmL5eDoDTCCZOkmb5cdC9y7XZN7AH1fBu9xEh6PLsZTYXVczwLDeyFa
	 n66b8P0n0qCoZd5x/GfafGU6HmUwfZkocSzNSJUp+KAoFb9D6oR5WRPUfz9mFD3zLuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n6a3cJp7;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673C9606A321
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 20:25:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 673C9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n6a3cJp7
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so2845625e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 12:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794255922; x=1794860722; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0oogFNp0FZqZ18/GhKCes9uvKE1yG2gWC4SBY4ii9p4=;
        b=n6a3cJp7tOAgdE4gYTf4Hjyv3cm5wHmTEi4sY7cg5ox3D9nd+bM/H2jIU6i+Kr5tcB
         qMxPRV2UZxB7SpGFs8ey7bs8EILauPglCJ9VEhwuq7c8z/ri8ATMic6jZfFkD+6yQqjg
         u5A6Mdr5tDm13kZajqozSt2p1TDc6pqVf2fipWN95OKsPKzu+cM5VbxboRu1OwEj2m1d
         JqaKFEAB9NLTXX697sz0JKV10gY26+J4QQb3FiCS5wZB5zAmCGRfWEPUYF8UhjBv4V5u
         qKjFd47rNMexMxL+wYhaeqGvHhN27+KLezy+kTNltQK0bM4h4g3hyRMYqMjxmPGw+LZb
         /NiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794255922; x=1794860722;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0oogFNp0FZqZ18/GhKCes9uvKE1yG2gWC4SBY4ii9p4=;
        b=CFJWOAsmV9Cl+tS5/fHtq7gh8RdxrqYJsxQNLyL80EK6+8Q7StcUzhXOgsx8VPTL3Z
         3xEBL2zURrObLnhiS+JgoQo9aVs2p910uJp+GkMXllZGg0ELzsPRT2ryuUGu0u084mmj
         f3tklRNs37e23OJCjaAj3NtE3vi7ektyz/td/Bvrorqq9TD2VxyEkI74V3luGvNxLa7J
         aHpu7XddfYoEl6QbEiA+q6Jcr99wmuZAoM2ukPmgF+n+7n9AI0a9tyrCnG/gtuEP6jsv
         y4/WWZRwGZ8gS8WSxpVzOZrboBjkByzIA/K3I/s90sGy1byF4i+WQ91yA3UkLBgOAChY
         lIZQ==
X-Forwarded-Encrypted: i=1; AL+hErG34Ztk6cUGFNmjLo5BlovnPpU8eR7b12wcbnfE6Ww1aZ5w3a/MnbYwDuvc3CkS3svkk0laxnpjeV/Yxg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+TUA2PKAeBuecMWa/rwgUisV10k2LUUCgmZ8/8rwpltgVZ/yrJ
	NQqtqZ7XqGG1uIDvTzW6ynjjBCXUIEaNeH0L2D/UVcxYiqsseY80TcUl
X-Gm-Gg: AYBFou24SSTqvFD15bvZaSGTnd3+nBRCZ409evcFlglQmwEdukegrsJCSnhBfpcx06I
	obWmwc7HmHaLJiEH++A13nw/4xRIVT950i0YlKzZrEi1mpkm87iNMnulIwZ/KthTnrFfyetr/ik
	Pie8RjYTq0QGAOymeBNEGgx/gFhxYvNYbPkaUIwuyc+EhYYr2+Ynz6q5qt4PIbjuu8l77cY/jAw
	sAOzLK9Hwyjr3amoLLqXZV3kzMIjYzYJVEQFaxW+uCZefhAeWQRopMwmlCqMTT4dY/WjbAz24i4
	8hvl3zFhZJ6NhW8pLX0DLlyyUkmq/2+B6KXsTxczxiC7OemSpQ2eaVoX9uO7aEHNzhH93VtMZHq
	rmaXCaFXnr3TJNn4jfQUCW6fllEL3diKyyuYG2rWDhr4MgOX4eeuCFa5k7Y0TJiJ9IK/kqaU3Po
	FH6h4ilw9dM99CCsP+khlhtlvWiPcNXz3HPyz0RdxYwZhItjLzIbgqVD9CaQaANzja8f91+FiMS
	8ZLRD5yEWNoYFEh1odwZvsHrnrzKGOrT8AIbNNDxmwLZlmyQato0eiSs3V9GoRqf6zYW8BnCB33
	CFmUN5PD3FLwnARCgjQgVSWNbq9H
X-Received: by 2002:a05:600c:811b:b0:4a1:fba8:b13d with SMTP id 5b1f17b1804b1-4ba023415b5mr5082565e9.9.1794255921491;
        Mon, 09 Nov 2026 12:25:21 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:de3b:51f3:e461:c0df])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba02387ad9sm9427205e9.5.2026.11.09.12.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 12:25:20 -0800 (PST)
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
 boundary=ee0311f25ca7798161673acdca7e0d0d9fa7781d9bfc4595b55e18d0a363;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 09 Nov 2026 21:25:15 +0100
Message-Id: <DMQYN0GE281B.1PW8AIHGLUNDF@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>
Subject: Re: [RFC] btrfs: forcing compression per inode via the compression
 property?
From: "koraynilay" <koray.fra@gmail.com>
To: "Sterling Windmill" <sterling@ampx.net>, "koraynilay"
 <koray.fra@gmail.com>, <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <557fae4a-3c08-43cc-924c-89d1f0f3896d@app.fastmail.com>
 <DMQQG1D324U7.2945KG0ANDDJZ@gmail.com>
 <5225511a-c66f-40e5-b9d6-31ff572496da@app.fastmail.com>
In-Reply-To: <5225511a-c66f-40e5-b9d6-31ff572496da@app.fastmail.com>

--ee0311f25ca7798161673acdca7e0d0d9fa7781d9bfc4595b55e18d0a363
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 9, 2026 at 3:14 PM CET, Sterling Windmill wrote:
>> Hello, there is a github issue tracking this and a patch[2] (by me)
>> currently pending final review.
>>
>> Can you see if [2] has the same behaviour you expect?
>>
>> [1]: https://github.com/kdave/btrfs-progs/issues/329
>> [2]: https://lore.kernel.org/linux-btrfs/20261103194734.598182-1-koray.f=
ra@gmail.com/T/#t
>
> Hi koraynilay,
>
> Thanks for pointing me at it. From reading the series (I haven't built
> or run it), it looks like it solves a related but different problem.
>
> It lets the property carry a level, which is useful, but the only
> inode.c changes are to how the level is chosen. inode_need_compress()
> is untouched, so a file with btrfs.compression=3Dzstd:3 would still go
> through btrfs_compress_heuristic(), because FORCE_COMPRESS still only
> comes from the mount option. I would expect to keep getting the 31G
> result from my table, unless I've missed something.
>
> What I'm after is a way for the property to skip the heuristic the
> way compress-force does, so that one subvolume can behave like
> compress-force on a filesystem mounted with plain compress.
>
> Since your series defines the "algo:level" syntax, would something
> like "zstd:3:force" fit as a follow-up on top of it? The alternative

I read the code a bit (and bounced some ideas with gemini) and I think a
"force:algo:level" would work well.

This, compared to "algo:level:force", would also allow a "force" value
(handled like "none" is already handled), that lets the user set *only*
the compress-force, without having to specify algo:level, so inheriting
from -o compress=3D, and the parsing would be as simple as if ("force")
str +=3D 6, where str is the xattr string that gets then parsed by the
rest of the code (in compression_apply()).

> I can see is a separate property, which would only need a small
> change to inode_need_compress() and wouldn't depend on your series,
> at the cost of having two properties for one setting. I'd be glad to
> hear which you or others on the list would prefer.

A separate property would probably be more work/less easy to handle, as
it also needs to get checked for conflicts like btrfs.compression=3Dnone
and btrfs.compression_force=3Dyes.


It should probably be a separate patch, but it'd depend on my patch
series, so not sure if I should just make a v7 with that or not.

Best,
koraynilay

>
> Thanks,
> Sterling



--ee0311f25ca7798161673acdca7e0d0d9fa7781d9bfc4595b55e18d0a363
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCavIsKwAKCRA0bnTtJTDo
OP47AP46EuiDZZw3r672q8pp5F8kpKBFx1TuNgnSqzPzikb4SQD/RiQs5AefKc04
IAeN28N/jFZKvZA2J+21X2jh8uZfNQo=
=NPqE
-----END PGP SIGNATURE-----

--ee0311f25ca7798161673acdca7e0d0d9fa7781d9bfc4595b55e18d0a363--
