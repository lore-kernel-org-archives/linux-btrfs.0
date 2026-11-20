Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795185362;
	b=wXs9SFaGE+sPum4oXClv1dnifEyyfPbBM76pfUjYkL5vakrnKlp5jFQeWkYxqgvrBVon
	 +vDggDeySqKeJbURHjBXhN/7+18cYiN/tpVkYQiZUKUkNIVmBIV8V+/TRA8MeWx+ab0uZ
	 Y/wka0vVQomllkHvYG+1bOBKVR0UzvFFa3QYTaTDxaXKNAQsCz/F0575VbBoesLZInzVC
	 dmsHgmGzrYEAFdrTiX2LUtblYNEwvN9c7sLFddfTkvrpod9WIg/qUx4Gn46CH8rMEZWaD
	 JET7dwbzARN8aFqvjAwfGI+1MCW3ywjOcBzbrxzm+n7c2MjH2OOKEzgHWmECCzkX8Ug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795185362;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
	b=5PY7cTtisSlnG/c8kewVOdisLwehFoc2Th7UP0OXT7Vv5bWI3US5vvjriIq09dcwBxTs
	 YymGstvAtrlM8wcnvtWX/DA1BecxO/GbPRj+ADkiAQ/xwlnLb3gC46Wli19liM7lu5dKU
	 UaUrKZNRYspTP2FYEtIFAzhcXf/dQaF/PBFY0fEo7QUt837LWXiFStrmyiMrLMO41L3OB
	 ZQhVfhmCYkDy4rhxj4GEWtbNQMYD/JeR4gmNWjzY4J1x8YgYxhWAg3JMtWczPURZNpkZk
	 GMcqEcU9mlzNJQVle+aKcAS3rhFQnnlQrX2ov1/WMY8qH6X37x9/w5uTPot2ay4nRcw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZmlktTxO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BB4606A32A
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 14:36:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8BB4606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZmlktTxO
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b47c1a3c74so1230251a12.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 06:36:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795185360; cv=none;
        d=google.com; s=arc-20260327;
        b=nxn4PXYqRrXr4AaVzMJfw+iVxTzeP8v9UujGwT7QSxBV5b2YHVo1SVLntOqInTGfnf
         +ZMUHke3c9NbenYYpnhj1/Ia96HPdB1x3kY9lppDd0+0WtmoYb21+Yu02LhcvfZzaTN0
         sAqGTfDPF6rg64X2WyPVP6Ar1NeVMZL0TlQpqd//9ZHRnD4JvngyJC4JdZnbJ8mthWkP
         LlxMyNu6zu3Brex7NDG8mtkQPqa2XkmKEt2vHAjaq1FnmUL25Md4DKvErwuWWHPEbPzb
         4FVIdDmSqUFVlvY3wtSF1ol5OcH+gGz7fm5vp3gZP+R57WHchHAE5COh7u6CqQ6YTuRa
         u5nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        fh=pMgWsgWzf28vvA2ElvUn8jVApLMyJ4r/NGEi1VIxbSY=;
        b=ja3bWTvQw7neMFPp4Koilvb6L7Ha4S+mBT12tYwwojj1HFY+eDyQ1KA7l55g9UKPET
         mpXVJlEKThu5UzBgSdAgHxyXMZuE5fuJ18usIbjeVkrD9jzFA6RdO0h+0j5vhLtVodAy
         8FC5sDaEsQzb2OhwAiQRw0Wb8qi0+zEKMbP3ZRMVtm3vzsE6CAjq4PVkTNQYEoJzDpfN
         whQR+1J7YM2nGSW5MaTPNy99XHraJpGIUrdNLEKHrJqHYWdTiChKmPDKIe7VGuv1CAy3
         rcPgP0iQ95jiye1o0arb2LKjWHW9ahQcvBu1k0qs59PlbmndJlwJC+UWwBYO/tX9wHeD
         Eqiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795185360; x=1795790160; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        b=ZmlktTxOJqc0gUgZkQM8tVXb/Y0XP5vIjBlg31tczPuc6Q95f4xzDo/jLK66eDcTRR
         yQXNy421kiJhT7oH9vLVwxVroKGeg4J9z03nrEStYvsVMA3xboXgWcwA2+JIMTGITaZ1
         038E81NLDLzYcW4o0qQ4SonrTGr0vzYZ8MzGW8HkM5d16we7L+/rT4b4KMUSsfEHVibx
         uS8nmmaGxZ1wTgmldg9y07wcPtmMKFly5bIu+HgpUAR6RPvU1IG7Ma4/oDa4cuosYPJr
         k7UPz9VVFyx4nQjmDqMOy5HZQrVCpdYWfBCELvWA6ZL08iBITG0L9mhiTPT1o4IF12kK
         cWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185360; x=1795790160;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        b=JkvYgG70DLaoGrCLOz70mR74BTFdgMUuqrTrDWLEr+skpOcb6kF8YpwlVjN/0+3NC4
         zyZXSlai66MR2WeRMeq768dUJKRPk3Iti91Pv0XfojqvYFOrfnX3CPc5j9NXq53gWosX
         9eD8OOHDyLDGT+/Cv6bdJ5b1B1dLojXDUCqZAipDSOYfZRi1bqomCew+wJyrv+1/gv4W
         dDbmcY/8lsMqhysOLxRWb+OD8b5yKXkQdkggNfxY6aCnUykpRtj6vja4s5LdGqD3aGxj
         b2StVUbv3Bu1y42h5eRvawLtR8p03OVjOwTraSWX7qCxREM+xSCf8Jl5RGFCA98rdfw+
         gJtA==
X-Forwarded-Encrypted: i=1; AL+hErHXpVRMGys81qmyABYTQn6uCG8tYGxcu1dBjQZeWHQdfFnCIaNVnqQ8r2QAv+odo+tRAb4L4HScMPw0Ng==@vger.kernel.org
X-Gm-Message-State: APuU4Z/6+kwHL+eyVylX5lOUOfG1/w/352X/XadW6hK+i5x+WrXYUQWe
	zMpwdH+Ioj7lL/Lrh1Za9rmpWOmEf0S1Eq6UIqqgcTZBO9YRkzX0lN6nD4wC4tCDY8eABIX2IyO
	Z/O+p5sWf3Mjrn8X3U02UUryE28O9tMs=
X-Gm-Gg: AZFdTZfsWbO9X6FmuFoU1YmkGnklrT2zITS3HpRil9MMD95/DP6MLssqWncmlEwV8ud
	LpwyPfqvu0TH/uYmDihV4FZkc3XYp3PjqJ1UuKcNd5Qt+ZO1T9m8fZs+OImgggmn/ElOKCNd45u
	1ZUAHBypSCo4JJqr6/PGea/IBAHhH4UkMlfbt2biez3jGfNNfmSewAgZXyOTaV4Mmoo8PZqHXUj
	26S/jYyix6wncqah8StTxpes8BmXBF7nErhLYep03W2x6f9v//XpotWykJSjcdIooh+sei30gM7
	jI9Z1XXFsuWDjT3CfTsPb7QOXVLk+/UuOI4KppR1XrNRhaGjRIWYigbLA5iotlFLS5ABTisxo8V
	gi2Fl50t0Xi8csyckKANsDSH8m7K+rt1PoWbgC/AQxcUgmltH/D2IDF97bP7+HtSB7I9vGQ==
X-Received: by 2002:a05:6402:448e:b0:6b8:7769:ffea with SMTP id
 4fb4d7f45d1cf-6ba37ece3efmr2475801a12.45.1795185359456; Fri, 20 Nov 2026
 06:35:59 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <av4Hn9u80fs8iHZ6@dread> <20261119095943.85048-1-lauri.gates@gmail.com>
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com> <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
 <DMZJDGMJ1RVF.32ES391JKNFGP@gmail.com> <CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com>
 <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
In-Reply-To: <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 15:35:47 +0100
X-Gm-Features: Aa3M54oxXjJW5NIYEP5VP8q0nzSYgFKLfJAws7Wa7snJYDGBmmJmUUUXbQQ7PSo
Message-ID: <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: koraynilay <koray.fra@gmail.com>
Cc: Lauri Gates <lauri.gates@gmail.com>, Dave Chinner <dgc@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, Christian Brauner <christian@brauner.io>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 3:12=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
> > With non-zero xflags_mask, internal contact masks
> > can be used for -EINVAL not for silent ignoring.
>
> What do you mean by "internal contact masks"?
>

I mean that users do file_setattr() with a bunch of flags
some of them are just ignored randomly without any any way
for user to know about it, because this logic is some internal kernel const=
ant,
which cannot and should not be documented in the API.

Thanks,
Amir.
