Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D574299A82
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 01:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786327030; cv=none; b=oKa5ChszhWxs2grp7i0vitQqwKb+wxPeo5a4kIWtT/zkyQI68snHii+jSH82uznOAF3CS9R2pcohi0wlNTLSMUXDMupBTHs+LRyOoMbWmixAHiPYAxZKtQj9yY2TInO96DEnHh11VbzHQT34Jza0Vi5xRO079JOu/WK22V9JZLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786327030; c=relaxed/simple;
	bh=vlD5JBpzzQF4Q2sbYXOfhcXQHTgj1kpMdYOW4GH8dOU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=OTNyjFGe5uHvpGxbc5cZbyx3Zg7/wnHlO9Ekcu0lKAMqT7eoiOYU4RP8SR4RbKSK9kbHxkJykLi4llhVVKQA05ia5zL2VzmaHtlOG3BscYoPMfV3L/vkqfv7akCwUPmclsDNyI6rnw1SekCdRIi6GY3DOm+8Q3E42M3UPNiM69o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hqou/IDF; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hqou/IDF"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47f84023916so1156986f8f.3
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 18:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786327027; x=1786931827; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8diix5QXrvOwm5MBP+Z4Jgj1ZfqhCkM9jeK9xdklCCE=;
        b=hqou/IDF1EgfJQ2WsZUeQz1aI0SlDQUOB6UN4k5bIdVTXqDkOfF6a3JJxWIKE0nOuC
         5xQxZw6riHPZ9SXfRI4CqIJwvN98COwYbQah4AkALFqeBTe47OSGCpLqYRIrRF28KOnu
         5M0Vdm7L0jh0NQtAQ0i0IjX2vQtvPtfiRtBmQqbcCY9b7fiJrYdhqjDanUkwPEP4cwu1
         bDUQ5mbl9K8ZlVP2kqMEd+5A6zURklKpj8qYsHrZfJ7QjLEibq21A1bOk2B3NY+SglUt
         5hhwH02lT3RU2LNhXiAeKBb43ISmE+ZfKXWewaS+WiTCBd2J3zwCrlrSHx2S4xs4fQno
         zaXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786327027; x=1786931827;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8diix5QXrvOwm5MBP+Z4Jgj1ZfqhCkM9jeK9xdklCCE=;
        b=rSdT1OWWKncuSRmHqL0cSEVdzUf6vxm/8ykkcNEa54+PrDBAiUi2hZfvs4nZeglqfw
         jyti+NEm4ffU1dq5BlGtJKknl7K4YOdOs61URV9ESkpBLgD2iywpmRxmShhueqy6mi8P
         9wjK5lKDUJOV9JOLEg1GmpEny3vszZCokFSzvp/aYWuN2p2pmoXCY23h3sjUbpqIkmbJ
         jLExXQh3w+0h1giOIVIxHmiM5GZmXQaCHtnS5cTVSKCnG85gNUKF5tpu+8Mo1hbRNd2p
         YPvwgwnBY7bVSiI0liJvDNlzKq+lxXhmh1PDdtALKqqDORUjJnU7IJFz9v8cJELVzNzE
         jwRw==
X-Forwarded-Encrypted: i=1; AHgh+RqbdS+Cq9ul2/aRVQ4jROTnq/Dci5IzqIPXIT26Pa7UVpuxpigOhIsfocrgxRuuk/40dvNzwVf0/eYFaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwstvTi88V2+0oL5uLvHkZ+FBayohU8kRHK9KHFrdF/QekjfrQY
	/RIpR7Gq0baxPEetJFJriAAqpaWE9yDu9OTFp0k99kXadWRWNQMBIWud
X-Gm-Gg: AR+sD10ma2+NZvjlitP7n7YQX9q1ox+7T9qXlLzbG2vVAa4zg1yC+vDM22oYY+MERtp
	H8PbSMOV/2a1VP/l6mWGAaBJbWAeQLCtvzkjSqFoaN84OpQ3Ed8w1e9H5iAHSmW4gDnHH2uMUJK
	Ry/v5FqjnlGTeoE/Rc6u30BlqsK/BjDq1OAqbTbQcBYe/W0wWwHh+doEMecQfJzEL/vE2/O2YdA
	VERKQl+q433jWB1e3DNUI3FXxS7Fv5kyrNYX/JfAc2TYsRuQNf44Qu0GJxzjk1uIPNS8l2GTN4l
	RB5E9An19xfzJcHi/7K70zpPoegDSvfcFgcp9xeLn24364tvyWt+9b2+t4iZZYP55S9k6ciKQti
	l48MZyHwh8t58JWx93IIGKXzDqGM6eA4CCcOk0g5hfjPGQEcMSHP08YxEnuq/gLKzphuPslIpz2
	lqgbKBxRYn1gSyoCEQCR2UxZ5VRyMrBupMJd5U8DojxE7dHamSKFbu+MbC
X-Received: by 2002:a05:6000:46d4:b0:47f:9254:d453 with SMTP id ffacd0b85a97d-47fec4ea601mr41732493f8f.8.1786327026649;
        Sun, 09 Aug 2026 18:57:06 -0700 (PDT)
Received: from localhost ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4800214557esm27586850f8f.2.2026.08.09.18.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2026 18:57:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=f84d69c40bc6e46994914e3949642ce563f01c9c39ec86ba69fbe6501890;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 10 Aug 2026 03:57:00 +0200
Message-Id: <DKKW2W8COGXT.3GZPRA6TKLCFV@gmail.com>
Cc: <clm@fb.com>, <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
From: "koraynilay" <koray.fra@gmail.com>
To: "Qu Wenruo" <quwenruo.btrfs@gmx.com>, "koraynilay"
 <koray.fra@gmail.com>, "Qu Wenruo" <wqu@suse.com>, "Zygo Blaxell"
 <ce3g8jdj@umail.furryterror.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260808023459.1494928-1-koray.fra@gmail.com>
 <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>
 <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
 <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>
 <ankKjqr72aD8Ka8w@hungrycats.org>
 <95bab93b-f0c6-447d-8bfb-c81b3d48f7a7@suse.com>
 <ankbNtvLr3ZnFjEk@hungrycats.org>
 <9995da33-3f10-43b6-aec1-0e90eae03c7a@suse.com>
 <DKKUZT0LUJOI.RE9GG62MU6K3@gmail.com>
 <f4a10cb9-0237-4326-9356-3704939072a7@gmx.com>
In-Reply-To: <f4a10cb9-0237-4326-9356-3704939072a7@gmx.com>

--f84d69c40bc6e46994914e3949642ce563f01c9c39ec86ba69fbe6501890
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Aug 10, 2026 at 3:54 AM CEST, Qu Wenruo wrote:
>
>
> =E5=9C=A8 2026/8/10 10:35, koraynilay =E5=86=99=E9=81=93:
>> On Mon Aug 10, 2026 at 2:51 AM CEST, Qu Wenruo wrote:
>>>>>>> So either option 2 or 3 would be fine to me. Although I personally =
prefer
>>>>>>> option 3 a little more, just because it's much cleaner code wise.
>>>>>>
>>>>>> Option 2 preserves legacy behavior that is 12 years old now, and it
>>>>>> costs a single comparison in two 'if' statements.
>>>>>>
>>>>>> Option 3 makes an already confusing situation worse--it makes the
>>>>>> underspecified behavior change depending on kernel version.
>>>>>
>>>>> One should never rely on something not documented in the first place.
>>>>
>>>> Option 3 prevents existing mount-option compression level specificatio=
ns
>>>> from working when the attribute agress with the mount option; otherwis=
e,
>>>> they would be blocked by a btrfs.compression string that doesn't speci=
fy
>>>> a level.  That's a _regression_.
>>>
>>> Let me be this clear, the current one nor option 2 is not working eithe=
r.
>>>
>>> If the current algo is different from the XATTR algo, it will be
>>> whatever random number clamped to the XATTR algo for the current code.
>>>
>>> This applies to the option 2 solution. When mount option changed, the
>>> level will suddenly change from whatever previous mount option to the
>>> default.
>>=20
>> TBF, I can see how it could be useful (or rather, how it could be good
>> to have it as an option) to have some files with btrfs.compression=3D"zs=
td"
>> and then use -o compress=3D to decide on the fly how much compressed the
>> new data added to them should be.
>> Both are (read: will be, after the per-inode patch) 1 command away, but
>> there *might* be use-cases where mount is more suitable.
>
> To be honest, with the proper XATTR compression level specification, I=20
> think we should even deprecate compress=3D mount option, and make the=20
> XATTR one the only recommended way to specific compression.

Ah, and in that case, to set compression on the whole fs use btrfs prop to
set it on the root?

> There are already too many corner cases with mount option.
>
> IMHO, a good design should allow and only allow the best way to do a thin=
g.
>
> And option 3 matches perfect for the XATTR only compression future. It=20
> still allows old XATTR to work, have a very sane default level, very=20
> explicit and clear independent from whatever stupid mount option there=20
> could be.

--f84d69c40bc6e46994914e3949642ce563f01c9c39ec86ba69fbe6501890
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCankv7QAKCRDmj22qf5IG
XNcRAQCoyBMZOsknjfAI3XnqWyrL73ZjtmmWCH+un/8/ZJq/zgD/SfGYjeP/0923
T00pfqBlgZ0CfMdVt4XWhZ1p3FdYEAk=
=vU3X
-----END PGP SIGNATURE-----

--f84d69c40bc6e46994914e3949642ce563f01c9c39ec86ba69fbe6501890--
