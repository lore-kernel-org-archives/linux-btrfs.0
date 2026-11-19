Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795125091;
	b=uU01PibaICASlKW0J9wrh3vNNz6yZhdMb1g9eDnl0VOjgyJQKvjYJ5KT8+1sHKvxxM5/
	 aOTgnNK45SVzHZR8DIwoJPCobLCK2WojCOYX49SA1/7CIgpd5FgXQhM/ynHNNylNFsOuh
	 uKT3uOh9ITgCuRvym1TQ5aRWa/RzMlMysFwPiwcHPpBaNeyBtUoR+G8IGfr+yxzkDjpq9
	 o26rcA3c0ShD+AthfJMt8bv8wOOSUWaYW46LTSdsIXl+HzVVEuNTyYK00V+vUwWlDTisY
	 O9HNbJ3aXqetQKhXXjpmRdJP96LVnz5PHc4GCJ8X6WjG0/5njwb026GQuroXlqxmosA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795125091;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=Ny3Sl9Bn6sHIvah8OWFokkLcjHbV6BwIAehQvpJWiOM=;
	b=qJOkhKzq1gHE+T5plmbW+4/5F1d64/OrWGy3lK8e2ikl9OrXcannDfDyobmafZzSHBG5
	 8LsqDx5dBKfZe/L0qw54v01BHlga3Ack3AKrj43qwEEeChmoQDaBu3j7dOW5F9ei0ZB5C
	 4tUcs/u0Uo29uhuPwRJFkBUlDAZrtB7c9M4BuRztoHmP1lpjNKTY74X9+qpdOmnnG0J5x
	 2pH7eueiYZC2bkyqeslJ2x2g1OMOdUAWY7MI4r+yu8t29tte0TQryeGtTcUdqVlk1ig72
	 AEx/p3whD7gsoPRbgJogZPsnyWlXuyphpRh0Y0OQ49Ut0yqXhy0vOlBk+Q4yLJKO/pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IlZfXAdV;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E852606A332
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 21:51:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E852606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IlZfXAdV
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so1605395e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 13:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795125089; x=1795729889; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ny3Sl9Bn6sHIvah8OWFokkLcjHbV6BwIAehQvpJWiOM=;
        b=IlZfXAdVqjbuXw7jCUzgBXdPvunc6N0Mgo0wFLsi18PRIXDg8h5ImWiXqqG9r5Z3nz
         mMCiHUUIjL1nanBAy+gmMMgf3P/DYPfNI/EhxL6VmuCltURwD+QgSpN5wH9Ap5okdiWa
         y1/JXPn/JLNw5xRoGTUzFUnMvRCF7c7CMfNmwx5ikxXdmn96ekaYhxXTtb8MRXhNYeaS
         5grEbe59oWK77G5W0OdmQ9pOUNCM7ixvwCJgXOuUiJiLHN4zyLRjXQj9XiUl5nqIEgCk
         mpXfVFfEyeVkldYSBLUdPMoMK3O4rNrOnb4CWeh8R4q5zrhhEuhtuEtenWRCvjHT14FL
         k9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795125089; x=1795729889;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ny3Sl9Bn6sHIvah8OWFokkLcjHbV6BwIAehQvpJWiOM=;
        b=SvD4+lFFqnq/4xKsAifPhJrJ4UHkU9qp0eKLLKXQvMI9kSh98RzryjpYPoWz/G0IlO
         4LwENqe5ownDdbdl8BDH4L1/tDUkpsj6WXZwx/EfmMzR/ty192ZbeuCMDYeeaM4Lvfig
         05gKcI6VuoziSa2zf15fVNuiSq6FILjiRLbXfcz3YAjiZOB+zkziP6hjMJnEZ1RIiNro
         ggy6Kh6Yc2hK+fCikVX1lHRrnDeFwZwfWcV9Sshkczpehm9E8Mms/tirbGcg2/LDeeqk
         6/AY+ajUxkNRw5Ib/pfNNXHjyPPS2muQALN/eN4jKlhsVtGY9Yu3GzJW9Xs+yAG424jE
         eZTA==
X-Forwarded-Encrypted: i=1; AL+hErFHbTSi5NXP0VZB7xiythOmWXy3MWFzoIV+6hOmKZtWxEwZgKzoVJ4TTpsO6pgUALsaP8fyPDPndDzEMw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+AWQYlu3xo506pj+3B1wl+Ifu3e4iKOVrqjn+zsx47lMQhv/7k
	bXmhb9I3aJKIns0hFQ7wP/MDCc/KggVoFdb5ycqTB2QYyIJX0/1D0SMf
X-Gm-Gg: AYBFou1dVpBGS2OyYAQsY63NlYfuwnVUfERaZogyIrYeLsbIIvW9dzo25jN87i2gbo+
	z2rAS6uBl61MHrPp+WUZDoFm3Z5oboLXQ3uH8XfWg4r1vRUeCpoDDoaHlEHGfmZoUBsMkKINUSc
	L4gcDNp8VtKy2Sx9wgM7LPqEUsfx51BeYBNIVJ12iGyBCbzzLavdGwIq3YkdICq/NZ5ha3KEmzM
	PWyVsODE2wjWYmG93KN9ho4/9f9ss1dYeWSkqbNPzw6EDD9cta6RlrYqQBAMZ/RsxmcZyoRLj3z
	2hENym8MMjol1miIddFaD/ywMttcAnoYVwEhaSGCpT9cvdjO5UrKnNrOyQ7FxNXdJ2JSDUr2SS+
	evK09eKRyQT5CkcmS4shr5ATeZO1kTcl0r/0OmwBWatMQaqGYjQxVJBaT4bbRnMir84kOdssUfT
	+B6RxjncBJOvx2wGDu/36Tvg/jQDxtfVt2M9OpoTV6sHPfWX3cwd/MpncNWBuU/rNzzoo1djYow
	TKC8C20TIEcuvNSbo45Kte/5d+bsIyr/HdRCbo3qWzWoCh3M1Vus1Ox8zSOIdYXt0E/rWISVAmX
	9OrMd+A+FwuJzPnSFSdzhXpr7f/4MvkL+aQ/QgPTXSqKRf4=
X-Received: by 2002:a05:600c:4f48:b0:4a6:44b:2593 with SMTP id 5b1f17b1804b1-4bb8893ab9cmr20069015e9.29.1795125089289;
        Thu, 19 Nov 2026 13:51:29 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884a3a3dsm24821245e9.10.2026.11.19.13.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 13:51:28 -0800 (PST)
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
 boundary=305c4db69b4b7682b4927e5c7245ccd497c3eba9918a22ec95937c8c862e;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Thu, 19 Nov 2026 22:51:26 +0100
Message-Id: <DMZIQG4U1NTH.2IN0S2YIWEYTG@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J . Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v4 09/10] ksmbd: add provenance time (ptime) and map
 it to CreationTime
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261115180343.576773-10-koray.fra@gmail.com>
 <CAOQ4uxhjxp5sxYphWoB=8sgX3XHOv9zLVYf+8ZjYbS_gQDxO3w@mail.gmail.com>
In-Reply-To: <CAOQ4uxhjxp5sxYphWoB=8sgX3XHOv9zLVYf+8ZjYbS_gQDxO3w@mail.gmail.com>

--305c4db69b4b7682b4927e5c7245ccd497c3eba9918a22ec95937c8c862e
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 19, 2026 at 6:34 PM CET, Amir Goldstein wrote:
> On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Implement provenance time (ptime) in ksmbd, as introduced in a
>> previous commit ("vfs: add provenance time (ptime)").
>>
>> Map it to SMB's CreationTime, making it settable by SMB clients. When
>> reporting CreationTime to clients, prioritize ptime over da.create_time
>> memorized in the user.DOSATTRIB xattr.
>
> That doesn't sound like the right thing to do.
>
> If the server stored a CreationTime that client had set, you cannot
> override this.

Ah, yes, but how would we handle older files which get a custom
CreationTime both before (in the xattr) and after (in ptime) a kernel
upgrade?

> When the client sets CreationTime, the server can decide if it can and wa=
nts
> (may be a policy decision) to store CreationTime in PTIME and not store
> it in user.DOSATTRIB.

To fix the above problem we should probably keep storing it in both
ptime and the xattr though.

> Fun fact: the user.DOSATTRIB format also has a mask so storing the
> creation time inside it is also optional.

With my current patch series applied, when CreationTime gets set by a
client, ksmbd writes it to ptime and fixes/heals the xattr (=3D removing
the CREATE_TIME flag created by older kernels, see the other fun fact
below).

And another fun fact: until [1] ksmbd ignored the flags and just
read/wrote the attribs every time :) so that can only be honored for
files that have been written to/updated with newer kernels.
(That's why there is the ((flags & CREATE_TIME) || da.create_time > 0)
in my patch, and not just the flag check)

Thanks,
koraynilay

[1]: https://lore.kernel.org/linux-cifs/20261115155308.415734-1-koray.fra@g=
mail.com/

> Thanks,
> Amir.



--305c4db69b4b7682b4927e5c7245ccd497c3eba9918a22ec95937c8c862e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCav9vXgAKCRDmj22qf5IG
XM7AAPsG6qghsrCfCEnMzpWg6QyG3mDtqVzO2LuI2Jbx+5MdmwEAqDTU6SUvXvP1
4H1OcrcMro3Ek7i+OVcH9ZQ2xF4lngw=
=LZNw
-----END PGP SIGNATURE-----

--305c4db69b4b7682b4927e5c7245ccd497c3eba9918a22ec95937c8c862e--
