Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F156E3B3C01
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 22:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786401724; cv=none; b=EF/L9boU3P1fXzSgqY5dwVllmhHehRxzrDh8VuDdG2wRzH5PHa98duq4TY9JCwwgxKZ3zKnME4wGjV+NkjFGRb4jGXgqP47wjUiMSnkuXBwCUnPQIcFdIojMsTAc4q+b/E6H315DeWjj2gHucn/UoWx871YY88lOpyzCw+ZKnqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786401724; c=relaxed/simple;
	bh=KqmDB79RqIhjDhQgCW6/y6YkpsEM2RYbu8OiiZX9hJ0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=ZxTWTZjRNu4vyzjhbWDmDFdH2Zg55GPAsCfwcAobb2PetZYz8mhX5qWhAQUHUZzkRjvC9WF0Ri+qg1kaqPSOPLoZ6vuEIu8E3tWB/aYumNcCur69H9tqJJVtAIwZc8jH+3Ui/NjWA3Iid/PgeeGC9zf9naeRQ4K9boidB3q73cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eJDFm+SV; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJDFm+SV"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f7027ca11so1539886f8f.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 15:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786401721; x=1787006521; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=rJuWzVzy0REdnSU3LUqFXY2lFYzbe6m5a852wr3h8Rs=;
        b=eJDFm+SVAa5JQ73FR5mMJfnROa7USeqTuFNyAEVezD8dvNRUF66VRZqsgRuvJ9ECtm
         H8J1/TBZhi0h/KSKQRSWq5sbZ2DJxW7ySYfEPyYZnNyX3yJG8GgW95i7M3zgg2I1J9T6
         MaJxD4q6R29avBRAZP3i27C5bq7jAbZJu62IFxjNJlmjtsjy6/gV2UdX59TvCoy9So7C
         2wYs67s8r8v1jm5r4ByD3Pz0Um6+hdRk64NKg9C5Es5C5F29dexT4fbNt4reLF99E7V6
         UXoVxy7yah84KZShsUXKp/igGnHkD1CIK34VwCaD62BtzLzUMGbYXOXVu4u3UoLxb6y4
         jqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786401721; x=1787006521;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rJuWzVzy0REdnSU3LUqFXY2lFYzbe6m5a852wr3h8Rs=;
        b=eXNyQGwNBarwgFS6W5CQvbogMUI8JPFqlXqHI8gsVK0Lc3QP58m1AjV06dth/u3hrD
         gYNKnaiaerSG2cwYnLeSKShpuxSvTnR5kT88VkTngjTzINP5aT77ze9mLoyl8tSIiR5n
         ZU3ux5ye8fHj6dhFTMSvtMmh0KgN8KqNw7ErJv9KKVHtFryAL5k8XuouKOGNflh6cQfa
         D7jUjqWyQ6goI4GGXJBetjbq9NBtQaPIsRNoafOvhfFjduc6J4rOxPwsh2O4A42yQEHB
         1L+U7kDxeKPXpdaARgEpNQevRRlQVP7DUjPjEt2IvW+B5Xfv9VKjsItutrql5tSagszC
         7a3A==
X-Forwarded-Encrypted: i=1; AHgh+RrqjGjEzy2LswTu8FayTkPTN5zlqF2z83oyRjvb501z/dVB1iPXWgPH40JaLtB5CdanecFp0N9fYAG/mg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWvtAYPxbmwO++VFZBmKxa4EFLjD71Hltomsyat0ku4SLGjVDL
	y+PWSQ3UajiV37ElNRcgEy8euytUk+jWNWL8fiy9v0UPpmtZPeJl1uC4
X-Gm-Gg: AR+sD13IP+kuOnwPN+/BcDAdrJKCNax211hauyNdC2ASE1c7cA09iYlJ/mPTJsBQkeP
	sMS3PCB09aEauHDXRM56ufZEofhFoBQG7IUe6Tgytc0+UWe5L2DdxqXQ3EKzZjJ0K0LNPanJ0Dk
	2K4kdVxeorVFZ+BSxkuaAWVGSTuu7JiilsYowMntKlH/axblkFp8Yky5xPKbpY4W/oRMDz2NXZk
	zPPD/4gHVtk0uJAHydeJt6sf+jn9+rqkP+UPGmBVwUq8kz5x4DroYKxYW+H4ZdulhNCXq1ubciY
	1ATfkv503AE3PDH4Z7H19ggG/IyOjQx1X+vSeBnIFn2+pA9fv+EXecPXqViu1gTw56YEiltEM/Y
	YLXvLEfOX3pcnQxjyTsULDWoWfBN9dBAQSUm/MqDF5G5AjDoLseIcaDhjyDfahpUZhLh6zmMSJt
	wbMYwYiiMyN9gtRF/j4B69MhJXtsgYT024UZDFnNhJzE8d+XJYE3Yrdigr
X-Received: by 2002:a05:600d:644f:20b0:499:7410:545 with SMTP id 5b1f17b1804b1-49974100707mr22818365e9.12.1786401720899;
        Mon, 10 Aug 2026 15:42:00 -0700 (PDT)
Received: from localhost ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499740e13e3sm19641975e9.10.2026.08.10.15.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 15:41:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=719d64e108f06de6ea86f652b8c169fcb1570fe81a25485a55257270b4a7;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 11 Aug 2026 00:41:55 +0200
Message-Id: <DKLMK2MR5D7W.25SJ3IBJJ5QID@gmail.com>
Cc: "Qu Wenruo" <quwenruo.btrfs@gmx.com>, <clm@fb.com>, <dsterba@suse.com>,
 <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
From: "koraynilay" <koray.fra@gmail.com>
To: "koraynilay" <koray.fra@gmail.com>, "Qu Wenruo" <wqu@suse.com>, "Zygo
 Blaxell" <ce3g8jdj@umail.furryterror.org>
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
In-Reply-To: <DKKUZT0LUJOI.RE9GG62MU6K3@gmail.com>

--719d64e108f06de6ea86f652b8c169fcb1570fe81a25485a55257270b4a7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Aug 10, 2026 at 3:05 AM CEST, koraynilay wrote:
> On Mon Aug 10, 2026 at 2:51 AM CEST, Qu Wenruo wrote:
>>>>>> So either option 2 or 3 would be fine to me. Although I personally p=
refer
>>>>>> option 3 a little more, just because it's much cleaner code wise.
>>>>>
>>>>> Option 2 preserves legacy behavior that is 12 years old now, and it
>>>>> costs a single comparison in two 'if' statements.
>>>>>
>>>>> Option 3 makes an already confusing situation worse--it makes the
>>>>> underspecified behavior change depending on kernel version.
>>>>
>>>> One should never rely on something not documented in the first place.
>>>=20
>>> Option 3 prevents existing mount-option compression level specification=
s
>>> from working when the attribute agress with the mount option; otherwise=
,
>>> they would be blocked by a btrfs.compression string that doesn't specif=
y
>>> a level.  That's a _regression_.
>>
>> Let me be this clear, the current one nor option 2 is not working either=
.
>>
>> If the current algo is different from the XATTR algo, it will be=20
>> whatever random number clamped to the XATTR algo for the current code.
>>
>> This applies to the option 2 solution. When mount option changed, the=20
>> level will suddenly change from whatever previous mount option to the=20
>> default.
>
> TBF, I can see how it could be useful (or rather, how it could be good
> to have it as an option) to have some files with btrfs.compression=3D"zst=
d"
> and then use -o compress=3D to decide on the fly how much compressed the
> new data added to them should be.
> Both are (read: will be, after the per-inode patch) 1 command away, but
> there *might* be use-cases where mount is more suitable.
>
>

Hi,

after a little bit of discussion on #btrfs on IRC, kepstin and I drafted
a doc change[1] on a variant of option 2, a bit more clear and expanding
also on the per-inode level change.

Thanks


Best,
koraynilay

[1]: https://github.com/kdave/btrfs-progs/pull/1152

--719d64e108f06de6ea86f652b8c169fcb1570fe81a25485a55257270b4a7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCanpTtAAKCRDmj22qf5IG
XKJOAP9HwlylEvV8U7AvTMvqskWdsSkTtXYZ9GBaaSeThNRXeQEA6XA5ywJIzKTp
DmrGFdnpMBnwbXn/+z/lb1k94M6xYwk=
=OIJl
-----END PGP SIGNATURE-----

--719d64e108f06de6ea86f652b8c169fcb1570fe81a25485a55257270b4a7--
