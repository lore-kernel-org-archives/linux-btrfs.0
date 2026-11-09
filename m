Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794229859;
	b=3ZB6WmHpr9HoCxZ0KJgmm3rbC8eYBIGv3epKZ0uKFh0H1n+WJAVHjEXdelm5IzeaI0Vv
	 LmJBVCOEJPh/jFqKRLvN87ZjAdYAmv+O63gi9dp6MnHpS8mUYKboMp94vSFie4OWha2z0
	 ZQF1xDzZ47sCSDeE/cIoXYywUKREtLXmBI+CGdTIUA9Oi4rN0ezrqWgKqSDkhgBxFWhKh
	 nVFeB053RdlQQpwuykHsYt/KELMWi2S26jgdCMdhndNzxO5PQSz/t9xu49yjdJWmpufCe
	 x1L3niwMRx/YmiZAAjpiy5QyzXFv4XDQ6qZ0lS+319bGLW2uSOmkLZqByCCniKVSLAw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229859;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=NFCy9FxJ7mFJpsGN0jiCA3ltOHnNc4tpyrZwzrlJDG4=;
	b=qO9oCIZ0XYSKpzG4AahG1xt8JGb4BMxj/4pgQNKFgZJ0psbkiXHZ3SYUzZ0L4Zo/1897
	 60qfox1bv1vUGw1qVut8YW5vOYWaLyYcqw3g0X/UaUOKCEovZvu+u1SeOfO3DGn5161ne
	 C+YEGMReRV9jbJCLFN9JyMqdvRLRmm5MnhqrRuRf81idzTtDhe9HjwY9iNol2cY1iXA8H
	 oKmHfY6QrKNiTUUsR0nK8W3O9e6Mgu6dKg/cbw5g1y20fLD/6Fdtt56M5DmoP9Y+qzEtJ
	 d/LUIsHglc1HTo41+uaT5L9dqTZqCoJquOUy2slLbctFul1kXFXQWeLGJdynuazcIzw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZoQzZtqw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.173
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893E2606EEB7
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 13:10:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 893E2606EEB7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZoQzZtqw
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3accd1ff4c3so6416551fa.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 05:10:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794229858; cv=none;
        d=google.com; s=arc-20260327;
        b=GHIbkZzKDvkBNxfhxs7QR796qPV2JA1WxkwjpWfJPytsPMadG2A2lc78xtWXLqEuab
         MEHOrJ9IBKzfuG/hdaJyhP9kSj78Gzq4VtkGmYcgOyruE8g58ofFPta669BEChh4lpOD
         4OrzY+qTCerat9g9pDYNVPKnkQrhpIO87Nz1CZusTGMOrfIazvzYt0FQUEkwro6bwjwS
         7VNL5XXi8NQtQ1dnEFnqNhFkMpS5EcdB8XtrnaiCYksckGySt6DVuO2xscCAvLxFpExw
         S5Veb/Q++5IZVsUGqE2PGT03yFGAcG/9VOHgSLCBBfsXNuXKWQwrPtrvaMOrkWrQ6VLG
         Vw/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NFCy9FxJ7mFJpsGN0jiCA3ltOHnNc4tpyrZwzrlJDG4=;
        fh=NcoANQKuIvPI23WzPOKsxtQcGY8cxdll1fzkfzOM9Cg=;
        b=qchp1eMphvJdkef9zs1ziRWE0umybf0BVwpkO6oI9vvoVlT9X6OfmtHuWJugR7sCPP
         CPDLuel1QfNmvbZs/NwELahblELZEWL2WAtq9B5IFx0vnBp6iZv7lpMAGKD8yg6eTwvS
         UD6Q6MeTLcsbDHVtMvMYb8Mr72tm7XbwUPTsvSB3XXPSNuQproxAzVzR6JOdOuh2oQu3
         /WjWJi36lpCXPzr+Svc0uf56vf9sAflI1ZqoGJo+f6sX5tOWU+450njbgLmk1kiuG2os
         qxOUyZguljp1sJZbSM/Hgxzu2jPk4QHwLfTxNniN12lit2+KV5UObKr4dWra2y06JBMp
         XrHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794229858; x=1794834658; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NFCy9FxJ7mFJpsGN0jiCA3ltOHnNc4tpyrZwzrlJDG4=;
        b=ZoQzZtqw7ef0u2xX+4zh5hGSbFO1K5Ki2byVqb+5Zzt1aHSr14sbq+2Ga7GhDLDlLb
         RpE3jSI6H5fZutx8FBojFOk29NtT967dJ77B3GR86XyBHbJg0PvtzTAVIyjIsKsEXZ7V
         MIKwyy0ZB0rIuQYeoJfS3hieyrgjGeSnWvh/PY93H8vgiJAEAV28EL4JwnOWN+POGDyp
         T3CJHQ+NVDjodQ0fsXZoXbSik/ZyrVQgGyfhRfRupHYsDKG0rhFwYujM8eJ2DUWpM3tM
         xs8sDrMnR93jdqHwd75EUHCAwaG/QeyfNmt4kfm3FfGr4chpeTz7qw/T9f3gfvDP6HTp
         C53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794229858; x=1794834658;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NFCy9FxJ7mFJpsGN0jiCA3ltOHnNc4tpyrZwzrlJDG4=;
        b=a2SSYCAq0/RCQ+134mW9oHr/hgFImgAQ7w94xv+1TiJSA1rBoi9s10otwYhCAF07e3
         k/RqmX44fknf37ErkzRDq3mrLSSTYYQly0wHXVizQy0TBTunk8QxGoFM21PWcwIu6M5Q
         gTCk+cuw73dltb2XfEFwK9DiUDy7OKi99wQ9ZP4+55QD6vQ9ANX/oigr7PYuIhLgRAk1
         f2Qpt+9xO6NYl8acJZSeXG2Q/VDekr2jzzPIjJSICgnUTcxcaV2/wQJPMWWrAM7lN/ld
         xo7FJOS+lV6BwID69+d6QcrrGJNlB1jy3Po4KSyHMusAsEDn5J4yrLMe5R5Zx1dnjpCK
         s1bA==
X-Forwarded-Encrypted: i=1; AL+hErEdVPxXJXr14jNW3fn27BBwakNPUn5kEchPHqUiBi2IYpiH0ASa88CwZH8NMdpymWqLkp1prA5XUI3kAA==@vger.kernel.org
X-Gm-Message-State: APuU4Z9kOYZ1PNO3C1Jq3C+e03HrLaTWchQT5k0NlAMggm8B9K7Qo7Aw
	GLjUykgkuAzDWN827dOb6k47iE1Ts4pLMSuN9Li5lLp8G+bU+XsIrOAmc1zLv7HDoSnmY4uRM9f
	0KH3UFk29T7jnXMjBqGJ29bryUwKgkeNsbZDm88U=
X-Gm-Gg: AYBFou2N3KQHKQDtJbbnrSZGLgh0wA72pC3bKhDMslT6efZVl7DTYOC/ldfaym/tXRJ
	rIp/W6FWLcMVR3m9Oflj0aIRAHtq1KaFyePsz67aHYR5oD0My1/PkoPSU0DRrIhSE9pz3uWq+Gj
	fQxC2oxPXA7wQV2NuupNWM0h2JFOZ9boRJQsb5zrlcQRndK07ZeYpDGv3Sb/RuQIJLpxrCYRd5O
	fXGBytgxqreGNA+cimgD3NzApDk2HQSIPoPgYueDKRpMk8VkAUdOOfHkv2cE+fzl5VVeevVr7Bw
	Ogp1pZm6NgfZf4zqz3GLSHtk49uMtIbPr02nPrej40tavGkFBjqmy9R6vI5YLpLs1gM86ppesLE
	S4grUwX7c/GWivJCGQDsyAJv4IQFtTVUGAxKEgSdD0HMRXJ4JRz9mT9Ovpbs+ibVmLvhHBhOH24
	8PANp8lYxBWF8Sxc8SIX7Wr12GprEmRG0LWSX5eC3RIT7VDGQi9OA6+LOZfwXloH8e8FbspXS84
	QEXi5xzva4eUDKZYh8=
X-Received: by 2002:a05:651c:4212:b0:3ac:d178:4fab with SMTP id
 38308e7fff4ca-3adfa425e4emr7514991fa.15.1794229857375; Mon, 09 Nov 2026
 05:10:57 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com> <CAD=K2o9LbeJUcb0xefwVx-rC5udLNLwqouO8pqFB0R+rWQvHng@mail.gmail.com>
 <CAD=K2o_MwSF_XS=iRu8GMPhH2Sn6t3bsKLm5BLOjZ34tV4aRvg@mail.gmail.com>
 <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com>
 <8d2e8334-8a6a-4bb9-9c78-a126be7d94d1@wdc.com> <CAD=K2o8CTZOPQ1iMTi2+zirKtQdY3bS5Dz9KMAamyid6Lf9QbQ@mail.gmail.com>
 <1f4f5514-b20c-40d7-a87c-911276a5e661@wdc.com> <CAD=K2o_A4HE7SwjTGJWr4cKFmu-OtJcLXQ2w=XFJDYGnOSbD-Q@mail.gmail.com>
 <5e929ec6-4641-4990-b910-489e34550ba7@fygo.io> <CAD=K2o8EAtV0p1dXBBXvrjw99zOb_XJUZ=Zz+1BjwVmhsScMDA@mail.gmail.com>
 <avGNQ29RVwByM4HC@mayhem.fritz.box> <CAD=K2o9Q2XHozQEY087HUa6AV1obAGQXFsan+B8Aomm0xyXcxw@mail.gmail.com>
 <9eb0c082-c9f8-42a3-9099-3c3807307ec5@wdc.com>
In-Reply-To: <9eb0c082-c9f8-42a3-9099-3c3807307ec5@wdc.com>
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Mon, 9 Nov 2026 14:10:45 +0100
X-Gm-Features: AclHuK-OVsCp144o6NPHOaWq8ljDZtx-LCH12lA1B308-Bjpm9aOucn5q_unY6Q
Message-ID: <CAD=K2o890R_=3sm3EhAP0G=Mwv991FoSbaZYYGBRa4OfddzQow@mail.gmail.com>
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Dongjiang Zhu <zhudongjiang@fygo.io>, linux-btrfs@vger.kernel.org, 
	Naohiro Aota <Naohiro.Aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"

Hi Johannes,

yes please, a branch would be great - that's the easiest way for
me. I'll test as soon as my test machine is ready and report back.

Thanks,
Jochen

Am Mo., 9. Nov. 2026 um 13:51 Uhr schrieb Johannes Thumshirn
<johannes.thumshirn@wdc.com>:
>
> On 11/9/26 11:01 AM, Jochen Philipp wrote:
> > Hi Johannes,
> >
> > great news that you could reproduce it - thanks a lot!
> >
> > My test machine needs a couple of days to get ready (new SSD and
> > thermal paste on the way), so no rush on my side. When it's
> > ready, which tree should I apply your fix to - Dongjiang's
> > for-next base, or plain 7.3? Or will you post it as a proper
> > patch / push it to a branch I could use?
> I think it should apply to all but I can push a branch for you if you
> want. I'll send a proper patch and testcase for it ASAP as well.
