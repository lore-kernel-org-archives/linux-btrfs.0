Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E527377575
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775721691; cv=pass; b=NHNWjY4yQrspixoMdBB61/FJ64dg/2YSsSK9o17GpCD75phaYhJlfPCOEViPnKK3lKnG9ptQ4S5Caqw9VKwgYNibToIcuXQqNyw8XzwpUvyVWfzavppiWaP+93mSOEJL0prv0lGxo77MRgguekHr4P0URtC47Od7MAfRuwGaTPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775721691; c=relaxed/simple;
	bh=9I5XxOuwn9ECzKCMU6ZiC4RaY9IIFkAheHNxEyhjb3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BGqVId/8UReze/IaNwakGWR5BIuXWkvBJKFSTemWnaxhy5XjUH0dG7zOJqQ62ujvYe5AaobAiUgdRMyMu6mUhEOcYJ4dzQzbvrsG3RDtBl0eGw5v0FvUWsSRVC1iD4nDHNb6eKlqvlFxnrjJD6XMIWvkYZezc/Wdw1c1VYTVqQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FQo/48GN; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FQo/48GN"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-66f727d6849so748681a12.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 01:01:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775721689; cv=none;
        d=google.com; s=arc-20240605;
        b=fSAgQ38MCqlxLzS9guXHbGMtSPMyUhb5B4JqGDxVYqouYNaGNL8FQzpLC++1xytOTl
         lBV1+11tAVgB9ZoE271ehDOzag7GhuBuLEmMZfqlJu7FRrImq7wm2ASKwtJViyEE3muk
         gMK4husM+P2BC/hAU0+xkRmcT5NBFkzDgMZH1CYtzlavaCJH2sHSJanP9+D/yLw7yNlA
         1MpRGLPRgjdmDIYSw8/pLApdWvji76Vf/jwXSF0jpuOn8j6yBDnIu+K6+W8jW/QxxaFb
         GJCGG7wNSZxFgAsL7htJ7egkB2J6a44oIRZgTXZiYvUifY5KUepg7kh8n+836mSl8O1c
         GJDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7RRgK1Vs+AT24AP1cRKsejMe6fZBGGT3wKp4RehfJOw=;
        fh=zxO5h8+B2IX8c0jxymfI9p6i9bu22qgNwpcrX4dqPDk=;
        b=f2v/uz+jzaounEW0vO9G3t2VbgSzUXCRxaGKP7Qc4tT51wMJ/2TjrNwn4IN3IM8mEK
         uG7EV4ZqbGeGfLDShWwib3E+22kJYxYdgiGSy5xKhSDOe5+pyG/5yJG51voRzAX//dsI
         3BdyrRTBHi2/sVe1qLXZHPfKLb/34+hf/kUCE5MsGRK4AEOD97EYVVj4c3CGb2OpfPRL
         F1Si1jQ553F/Pcw9lc43QF8JRMAoZwPk8fYlMcScT+MsCRRUdMj5t4K5dd14HtaC/sJj
         YJvzbX9g+2qGqdzXUfvTQ9SzCeW5iOG1B3eK7CzMrW8V71AvkoSobfZXtKD7epgJURNq
         dhAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775721689; x=1776326489; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RRgK1Vs+AT24AP1cRKsejMe6fZBGGT3wKp4RehfJOw=;
        b=FQo/48GNUMuwsWo9BP+hCXXvwBPvcNzfwIzffmgw5rluc21igyMNt1DAdseMMzfSg5
         X6fxMptHSpJopx9dE71OTDiXxsyVWP35K7LjzC5K1Fzgqr1YA9pIVsNbr2gFVTwNW8Ud
         u+JzktV6FSQ0QzRmL3Fes1bhNACNA/g85YmDBmj0Wb3T2+KXNDQwieDeS+O81sFPqpGy
         eSjTtgDXyc2z3NYVFRvX1HAB4qhwYS5ZJvVAr1vco6rKm6EWlJUjB181gLROJ0ZhcHlt
         /mbI2HFS3Qb8seidvivwH5OLmcr137bhQq0LkNjPhUhY5/JSCC9HI3goSlGn/ChRr5cj
         SeNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775721689; x=1776326489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7RRgK1Vs+AT24AP1cRKsejMe6fZBGGT3wKp4RehfJOw=;
        b=eM7RUbBViY5XNUKZ0ZDyaUF1/mbVT712KscKVtZj+5XtyOmO4Al50d5gj5ZYjlBByK
         7dftfm1sKGN5JgTpSQqBfdPF5PHAnSnFmXAyUYyriWtVdLqH3f/iqsdO8AO8a4y7Etvh
         GMqGLfE5MLu7nkApJtQVUq7fqGSlSmCc9+gGkslhePXpONZ+ip/Fc4R+Xz/YdjGYzvXn
         XRBHEXRX7joJTxjDN6XZG0zmO89J4ftdzaxRvsSiwMTA159MCsc/3aZizIEtKS8lTL2e
         tMpAmryZ2hNhRVEavgZeHqnI/UtzQQfzuzIiS82qfKFJNXXBv6ZDGMwrsot8LmAjpdPT
         SU1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWEmIzCEoros7CTJD2GiNiyqhs9FJK1kYXd8SVWax0eITOy+wDbu21wZQo0z+JoMWQ2CT/0escLFSn9+A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIaERL4MXwps0rVdPSVDZMW1iYeacRPwYWKFCXNzCNFU8lv6GV
	zvB5QvUzDxfcW1fqFXeVSwnyf5cuMJt8zlfnrkoH1zC+GWCLdTMitZZ3QcUMutrh2DXOak1cmut
	1W9Zfvtb0+/phWDSl4ybo6jthyQY0Cgk=
X-Gm-Gg: AeBDiesE0CKts+SJTMW8ccDQhcqgs0g9Hjyel4gTsiZcmXAKYLXHnKFk6jbnbJGPdCA
	qg+Z7XnEtsrESPCHrkl4YYjlR9nDIHCwA5FhaSooouvXljTg2bY87ldLIouLLhrHth7pQvMGPoo
	QikkCWzissAhABFwqlqLMrLWNnnuy0Dq+imD1r2qHZ8Yu8Wv4Hchjui44tBPU5biRqjZSo7VNkX
	38uqgTpFcsQYjC0nIYM2VG+GNPAuKnPtzsvK5YLsHxkUn6Olu8GX7uTgViGHPRZ7RSUC7FuGAj8
	VjJ0PF7gT8XLS0sS5ndYyIE/yCiqRQ5WxRpkfQ47Gbc8RTYh2rfMwLk=
X-Received: by 2002:a05:6402:158e:b0:66e:56a6:fed3 with SMTP id
 4fb4d7f45d1cf-670040e8328mr1238451a12.9.1775721688411; Thu, 09 Apr 2026
 01:01:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260409071255.3358044-1-gality369@gmail.com> <fdc220ea-8f1f-45e4-9851-5eaaf8051153@suse.com>
In-Reply-To: <fdc220ea-8f1f-45e4-9851-5eaaf8051153@suse.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Thu, 9 Apr 2026 16:01:01 +0800
X-Gm-Features: AQROBzB1v_i0GceXyCNVcJ07slsKZeas4ZXolCTTzYZp5MbDVI6hNKln4rIFPyA
Message-ID: <CAOmEq9UeQcS9UVWOrPV6RX2H-3gneCfQJyYJT32ke5gLjOFbcg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: treat empty left leaf as corruption in push_leaf_left()
To: Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.com, clm@fb.com, zheng.yan@oracle.com, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 9, 2026 at 3:51=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
> I think the timing is too late, and if there is an non-root empty leaf
> but we never modified it, kernel will not detect it.
>
> I'd recommend to reject such empty leaves at
> btrfs_validate_extent_buffer(), if we have check->has_first_key, then
> the leaf should not be empty.
>
> Thanks,
> Qu
> >
> >       free_space =3D btrfs_leaf_free_space(left);
> >       if (free_space < data_size) {

Thanks for your suggestion. That makes sense.

I will send a v2 patch incorporating this change.

Thanks,
ZhengYuan Huang
