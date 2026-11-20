Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795186533;
	b=L03EJbDmd6RITmucRuJjFa+1JdJhBKXRf2PDgq+t4FnOCdeF2oTJwYiABf3Gr5lYckme
	 3WUSg6LXnZtfRfYqbEQJ19vMR/FqJaDww3h2zKOr8vMoTD41u3p2VmqVmY6/uwrBaqp8s
	 nOggKOUlM0VJZV2UyCkGThATihVpTO+mVu5UipC02aVUEZpATp2y38wQ/VaeauRsTqsgb
	 tD/t9klTkIGXZTNc3Lo+FZHp6qN5m/YwxliZXxj/wpSf5cvBV+4s5yw9ts/6TCsXOXtGP
	 wFPi+ZFsoSzUfM3mEEzjb2Lsegk3d6AWh/rCnp4fU1LC5AGRv0K/kQ9BKPQU+8NN9rA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186533;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zpoWzG1+g8sYeNmdw7RPLfc/0HSn9Ajkmbs7oAG/5Qs=;
	b=DVeGhwEle6/al01E3wTWu9wSx8qEUujZBopk8Cf5gE0z3pHp7lKwokWFkqofusPVD7Ai
	 nU5esIbdjVcAGf+pKLewjnRrONEJZ1pAAajE+Bf1ld+IuOKyfOmrY575vy+dQoaoOTWZC
	 I6K+rvL1rPOkYMvL3eDD53CSJCzDVNU9o509dkKeCbiYJh2gXi4prTDJCBw22pPEFkbZy
	 X8+LmvkZTdP4WzxJWmBKFP1U/cVbYvK3wpkbv18wO75LOU4TvWJsNAWQ/ePR8X7y5ebdY
	 TSTs44PqnhxroIjsokLIxbwwDvCqp5pF5I86jO5DstYcEgjcrp+5wGJHODoM/kxE8KA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="XT71/E4r";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957AF606A33C
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 14:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 957AF606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XT71/E4r
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b88bc47e23so1231319a12.2
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 06:55:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795186532; cv=none;
        d=google.com; s=arc-20260327;
        b=LUM/VnQ9CEthSmxkm9G6yk6iYj6T11vRW9O9EMUctRjguyT9l4w8E5H9R7LXNGSre7
         HO/tyQC72vsu+CIj5f7j5tqtPk7QSdAwHGJsP3ijpdpIvshTbDLzGuhejqzA/ww4dS0Q
         PMLRCmRgZEYPFqaIaIabvwz24Fb86Y6zfQlPhZCaNLByxG27ly9tUsTv4wWL6i966p+U
         87T41pWQgvkUx+lSPrAJTJnUCUdPMAxT3p18fyUwFSBKqCUOSsjIGd4h+XkDK2E/kxnc
         bpywMOTvPwvo/bkS852BkKgmUbr3P9wNhUvYwq598bed1CnSSD3mWT6Jv0+ctmQZsO2H
         JVag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zpoWzG1+g8sYeNmdw7RPLfc/0HSn9Ajkmbs7oAG/5Qs=;
        fh=iOvhrgjH6ZB9xMnTKebU4vIcXgG6Z0Kza/se17GjE4g=;
        b=c0jx/PjzGbndRY3zkzVETUNG7qEf2P+2rb3LA3sIy90hUIrt94k60/5WpIOqHBtBtI
         1AODwU9AC074rPIhfw26egZqd2JQDfRpDTswdk5D11KPc54EBR+ofQ1uvnOu3VbbMIUm
         0Icx06z9bJ3ZzcuK5lTEeahx6OhchLT7LoweQjJw8XzqczsclpCQhEB5cgM604aUDG8H
         p+cHVV/5Lw9CfJtUhAUoUABqxQ5YMXI5UzXsYQ3Z3njyqfZPRGNOA65dUZGBueKtSYFy
         V6QTLG4yj4xvSZooaDDu4DYg5Pq8mBa7JxJasq+Ef+xpcpT9gKukbg39Vz5E2ML9w4Iu
         Pxww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795186532; x=1795791332; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zpoWzG1+g8sYeNmdw7RPLfc/0HSn9Ajkmbs7oAG/5Qs=;
        b=XT71/E4radr+V0uXgPEtpy0gTEoHCeyDzLAY8K94G59n90O+uv++nCc8LBTX/toK/0
         oCtVL35qsDqsHFCvztHPd6HhjbqSJ8Vwc8ZJfStI7YYUhYzRNmLNpBIQMkc69ILk7c36
         ZDgsLeuC7kJXyHt7GV7DGWfHYIq4655Im+cirBeI+iUHoUj7bKjfKZyUnrONaVl4D44J
         ww0U5x8tM0ESZ2EwqzQw4R3/0gUwPfGJym0p5b3otFIF//GO/UwhtCfcmLJW/40OkP+W
         CdiJIaGOl4B0ABFgWYbTFah8knh1vRGWghRZ7vMT9mim8VxC0/RTV9tBJ5cW6vANuiQ4
         lwrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186532; x=1795791332;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zpoWzG1+g8sYeNmdw7RPLfc/0HSn9Ajkmbs7oAG/5Qs=;
        b=NHq57XivlBWCG8XvLbeaF/Hbe1Ii369NHf8YR+sOjUaYQlKGX31reXob+eYrWjdaNZ
         /yDeoPIP4EcRmzYubZYT5HfQTtrTL5+lfwUUZz1lInfeqvNIE4dYNjlR2g5lVb5CX7XV
         P/SuDVTsXDAayYwVaMgjjaagy9Gm+PWRoUisL+9DrbEILzoc6DLX62RmAj6z/exRu7pl
         4qzJdrgxgU1OU8lKqu75lz3aO58vOGs6TdzQVkopwyjcKpaFdQ81v5qb7Ulv4hhxOclo
         S/qbGXtATf2VjAwNOFY3ZUpKuKeX2LQGoeMtiy+P8IYnftHHSWglNDZDg8x9PqhY8JKG
         dOxQ==
X-Forwarded-Encrypted: i=1; AL+hErET1/jcbNapvFHfcJJJTTcRs2OwSyIvueXWj4r75VNM9UIdBF3ysVh4ryqxUkpZ2j9FUHpNKcy2y1vVhA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+PXOSLSUPsWhsLEsJhBxBkPiKm2xPgbtPk0md+1uIoQgKpKlFT
	thMFDkg171uMWwgaTGgiXn2AJABA6gsU+nm96RH3sRyXss1goRJd4xxrRDLKymJhkiRTsv4DJgP
	Dkv08s7ui+HVUE2Yj/YEJGlfTCRErPGY=
X-Gm-Gg: AZFdTZca92u7EukKXtdklAWCoi90CCqL4tvbF3PtDH0AzCkv7HWCCgdIMC40HDqgpdB
	+2twshcZo8nAihA4r7Ct6+t+T9KyKhqbBnzrcNzEYERJ4H+/u6DRevLUa1fbpFlhfvJB42hMIJL
	iaJjv8tJH2miRe6CJWu2X61MK4M18AV3luxA6aNnSasj15VvtTjEbcWrkn9IH9u3KEsAoGHHDLu
	Q3QO9MfWwJ3GcdKsnwbMuNXBrs1gAyizXmzoUKipT5V5YfFdJNy89H8T7X+B3DZSzPaZ3mmRVd7
	SmMZ5UBdoTaqFsYSq0gpdzT2IG+4417UmbRtZmGc1DCA8VcX/x6bpdzCw6+IXQeehplS+Zea4qS
	bMYfPwQoNBVgRwXqwQzUDTmaUwf7UCXwK2UxEkTElu9VyzTrbGMmeCGSGBpTPxggtfJn7GA==
X-Received: by 2002:a05:6402:3223:b0:6b8:5f08:931b with SMTP id
 4fb4d7f45d1cf-6ba37ea44b2mr2503989a12.26.1795186531571; Fri, 20 Nov 2026
 06:55:31 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-9-koray.fra@gmail.com>
 <CAOQ4uxgoNsOH82FyrCxc+qSoid_CFmbmpL0qgWFw-e8E689fFA@mail.gmail.com>
 <DMZJ4PL1JVA4.2YEB7EPYJR5Q7@gmail.com> <CAOQ4uxi6h9BBP7pf4sR+gc2+4XtkEgbxXZha45iZzdB_wGFVgQ@mail.gmail.com>
 <DN02S2XNGRZD.1KNOZJ0GGDJNG@gmail.com>
In-Reply-To: <DN02S2XNGRZD.1KNOZJ0GGDJNG@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 15:55:19 +0100
X-Gm-Features: Aa3M54om4CtJTUNd2Te8u7pI-ZPclkwXdtuzgdSJLpiBpdV9ZiFnAJvfZll4Px8
Message-ID: <CAOQ4uxh+d-wNC0aWLEexPFz7zj=TZjLyu61kaEmwBx9_hKn2gg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 08/10] nfs: add provenance time (ptime) via FATTR4_TIME_CREATE
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 2:34=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Fri Nov 20, 2026 at 7:45 AM CET, Amir Goldstein wrote:
> > On Thu, Nov 19, 2026 at 11:10=E2=80=AFPM koraynilay <koray.fra@gmail.co=
m> wrote:

> >> >                    fa->fsx_xflags |=3D FS_XFLAG_CASENONPRESERVING;
> >> > +                 fa->fsx_xflags_mask |=3D FS_XFLAG_CASENONPRESERVIN=
G;
> >> > +                 fa->fsx_xflags_ro_mask |=3D FS_XFLAG_CASENONPRESER=
VING;
> >> Uhm, why both in _mask and _ro_mask? If it's a RDONLY flag shouldn't
> >> it *only* be in _ro_mask? (same for CASEFOLD)
> >>
> >
> > Good question. Maybe
> > I guess if you want to follow some percent
> > FS_FL_USER_MODIFIABLE is a subset of FS_FL_USER_VISIBLE
> > but I think that exporting ro_mask and _mask is going to be easier and
> > cleaner than rw_mask but not sure.
>
> Hmm I asked that also because you said in the xfs shared extent thread:
>
> > The advantage being that it makes the interface symmetric.
> > User can alway setattr() with the buffer they got from getattr()
> > and instead of randomly ignoring flags in set, the fsx_ro_mask
> > along with fsx_mask defines the behavior exactly.
>
> But by putting the ro flags in _mask too, a user would have to clean
> them out or vfs will reject the call with -EINVAL/something else, since
> in that case the vfs would see the user say "I want to change this [ro]
> flag".
>

That's just a matter of interpretation.

You could say that if flag FS_XFLAG_CASENONPRESERVING
is in ro_mask then its value may not be modified and fs needs to
fail the set if the user given value is not a match to the current
kernel's value.

Could be used for an "atomic flag set" operation, but I think
this is taking this too far.

I am fine with xflags_ro_mask and xflags_rw_mask I guess this
is the less ambiguous option.

Thanks,
Amir.
