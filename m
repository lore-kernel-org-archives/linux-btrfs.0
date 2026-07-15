Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D10942046E
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 13:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784121125; cv=none; b=GPScjdm+TCMesquV+teo84UTYPTE4XhQy68ud+fuGZfyVvXBGPCf3YP2cBy6c/Kf46VF9QBN6ZKtXTP+quInhl4pyQRL3hWsOCjz+aXF2qmmlDE2JYobn1PcfPeErR0vb7csk0AtlgJs12IX2h4a501R4rgSH6E9aWKZ6QDbY4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784121125; c=relaxed/simple;
	bh=9mYhiuKdThu+xbQ2NfwnMl6eddWerZFMJDSKBQdWp3o=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=im+nt+xd49GIcSaHhXqjrQgKPpqVzmI8ZC+HrwnBjLvN9PXqcyQ57HlkxIkqKvULD8UFKu7ovh926Xp7S1u2CkvU/BudMNBhuWEuMrL2Z4ohyS0cRQL3jBtXe2j/yduv+XKaw4Prwik6++Ua5z2+Gzs4gkaJ2amVOKjDNo9tLbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=suIdy3R4; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="suIdy3R4"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84867f07d63so6135030b3a.2
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 06:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784121123; x=1784725923; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9mYhiuKdThu+xbQ2NfwnMl6eddWerZFMJDSKBQdWp3o=;
        b=suIdy3R4Z6ow4KY8QWMjJ2m8Xe6WlLSic9z/NWmQt/ykWsWJqFkYgGjLJlIN/Vm38j
         I1fNRl1gOaLc5wwA3n4CJwSGCVJUvR/WF13knK9wLkuOyU2Qd0io6ceStuMLKE2pX8GY
         /XEJix406HaKtbDDASBAP9IoWirmODkmN3UL9REntM0/KjFfXcs6qiACfUaxFND+9Mpd
         RHxhdoKBuKkFCQcv/JLMowXWZCmkwviNBMAP4wLI6VWHxvVEi+cWBNvgGnOYJCA8d7JO
         zA63rOeyzbS4oJoh0rfDYtOcgv93nUDOjZuFAAB0zh2cu62pL8F/ubi2gHxpO/aAfn9/
         OVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784121123; x=1784725923;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9mYhiuKdThu+xbQ2NfwnMl6eddWerZFMJDSKBQdWp3o=;
        b=HSZ7BAFeC8IEueK7fv8QsxWvRZ7JMvIuUHvQQuJIYFgRIn5GLXmb+VdT+qtj5Xl1Et
         5lGxUjcnxcaL4l7nO+r+JbwK+VZ7oe03a3hSOnURqYgBzhhyqOdfy+i1KCiB/YoyQxKc
         Kwoa+lbRzoHBvY9a8Hmbhsow3syKVhzNQ181ysyjDwmIe84yG3jYTaKeyCdxwj3tmgs6
         73z4Uht3Gp/VYYShKvSCpLcO2GGl4fjWrBY5dnF064HMtagLZnjN78FSn5UO8wWFo3iP
         rFUNy34Uj7bDNkFQBklk7Qonb4RdH47SpEKWEcfdXvNsZDzxYZqI4rhmV5RkY4KPgZ1/
         b8Xg==
X-Forwarded-Encrypted: i=1; AHgh+RpWKnIjfdLwdt6yA3RCt+ijNToJQHZ15m86CubXvl9WwNtLXwHQhzPYhXl4a9Raf5AwrsknItpkRtgW3w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWQAjyQzvbSnrT7yY4Sw2aNJGfK+nWb4USuFpW9De/w6fcDZcO
	0peHil//5NJzW4WT/CqG3zYR/W4kqUgmcLpDrCOugEM9VJnIs9MpQtD+
X-Gm-Gg: AfdE7cmMZ/UxDSiXS0xzkGTeluhl51gfK2HKUKYfrY7j7ooF3mEg9OMM/vau1f70837
	ra9dWizw/DdI2wqvou8ZXdVtTZWGCmPXXSaOAQc4bcKoL200Iu40z26IymG6hPQAXvqZOxUpWjA
	Ptwu+auvilojzRJcftMFi8TRJtWalZPgk92t3uXqOa7kjPGviMUmlPzWSPRCLi2uge6KzDgcT7n
	vvIjTnDmWP8ZTCOPmCIbt8f5vL+5x4JdO8mgZacjP0VLQcEmLoPKmyY76PY9wL2iiYtE8o0IHh8
	ZnIrNjrmC9yGwzJPQycisZIINlzRRKaA6evheS2CZKlK1XNLq2EDKSte52KWWZg6vJzbcc3HNCZ
	IIbmHAyZ+r6ZMpMfbnR22YrnZzdWKgeTRWy1dWEDtpA06lniOQ6e86W1jRPzUvS367cq1pjY=
X-Received: by 2002:a05:6a20:c98b:b0:3bf:6c08:fb87 with SMTP id adf61e73a8af0-3c36c3e74edmr3304676637.55.1784121123299;
        Wed, 15 Jul 2026 06:12:03 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258ff8d80sm190458a12.26.2026.07.15.06.11.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jul 2026 06:12:01 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [BUG] two raid consistency bugs
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <4674023f-1b70-4be4-ae0c-c65669901feb@gmx.com>
Date: Wed, 15 Jul 2026 21:11:41 +0800
Cc: Zhang Boyang <zhangboyang.id@gmail.com>,
 Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.com>,
 Filipe Manana <fdmanana@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <48B84595-8BBD-42B5-AFDF-754EE2D24B1C@gmail.com>
References: <20260714161044.7330-1-zhangboyang.id@gmail.com>
 <67cff567-1070-4908-a253-a8907d237734@gmx.com>
 <4289be1b-285c-4641-a7b6-6b8e66f458c6@gmail.com>
 <5eaba968-b8b9-4705-9027-9169942e105f@suse.com>
 <8e02253e-2bd2-4ca1-8def-f91afaac4cd6@gmail.com>
 <8248f43d-d6ab-47e4-9ed9-65bb5c281f4b@suse.com>
 <65a774c8-9019-438f-ab8d-81b458f4f53f@gmail.com>
 <59657910-edd1-4427-8141-ed57d7ffdbe1@gmx.com>
 <ebf9c527-2181-4afe-b88a-4d24fda6d8d9@gmail.com>
 <4674023f-1b70-4be4-ae0c-c65669901feb@gmx.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)

On Jul 15, 2026, at 18:11, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>=20
>=20
>=20
> =E5=9C=A8 2026/7/15 19:37, Zhang Boyang =E5=86=99=E9=81=93:
>> Hi,
>> On 2026/7/15 17:44, Qu Wenruo wrote:
>>>> Personally I like the idea of turning metadata trees into merkle =
trees (so I wrote it first). But since you are the maintainer, I will =
let you decide which way is appropriate=E2=80=8C.
>>>=20
>>> I'm not the maintainer, I just default to not trust ideas/features =
from unproven contributors, especially when the idea/feature is not =
simple.
>>>=20
>>> Especially considering the increased patches generated by LLMs.
>>>=20
>> I understand your concern.
>>>=20
>>> So my suggestion is, if you really want to do long-term =
contributions, stop coming up with fancy ideas, start from basics like =
doing proper fstests runs with various combinations, report real bugs =
and fix simple ones by yourself.
>>>=20
>>> Earn your name first then consider fancy ideas.
>>>=20
>> That's exactly what I'm doing. I'm not requesting devs to fix this =
bug immediately or implement my fancy idea. I wrote two test cases and =
hope it will be helpful to btrfs development. It would be better if =
these two test cases can be merged to test suite.
>=20
> No, we will not push for test cases without a fix.
>=20
> There is already a known failure, generic/747, and at least I'm not =
the only one regretting pushing that.

Then why not delete it ?

>=20
>> I even wrote a draft patch to fix the second bug. However, the first =
bug is not easily solvable. So I had to discuss possible solutions. If =
possible, I would have written=E2=80=8C a draft patch for the first bug, =
too.
>=20
> This is already what I call fancy ideas.
>=20
> Anyway, this will mostly just get yourself ignored if you really =
choose to start from fancy projects.
> Those long existing problems are still there for a reason.
>=20
> If you believe you're smarter than everyone else, then go ahead, no =
one is going to make you change your mind.
>=20
>> Zhang Boyang


