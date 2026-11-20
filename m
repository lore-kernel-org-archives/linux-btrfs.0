Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795191432;
	b=Ysgcpam62bsmD0elXDEA4/AWgSeUW0zf/YnXjqHl9zwzY1Fbp7mwGS/KOZ4GeftEwUMh
	 IDICmoDlYVk4sf3I6NLoptgRe66OkqSPRg0vxcqFKfNmYnPHRxxBcQON6XUvBMahkUaTi
	 TDNyohLXUn9f+mMJVMo69eNPSYr6Dpp38Wp53bsJzGyNbT+NYEUb/9Jbu1y9XNCtp/Gx3
	 u0blez72oUgEPHEGuSsN73VESldY5DI7F+oo5IqSvVldK+0p7u/EdbbxMaByJ/0VFowp/
	 fYTI4nH5FhrzeArDaGf8/SQgfS6p/gAQw+ck5l0P9cJu07QKPZMhaeidJd5IBHhmN5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191432;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6pDEC7mZctjuQyIVdZ8lILmTsCvmwBFO6EStJerdj9U=;
	b=2twNtqfNgdiIzzvHhW4bne2ezJZmmv1+sUnbvtV9yuDuICh7b3cWFcA/uzD4EDNU95td
	 +Rm20GLteGGD4OCN8Pg4rIA30NDUcE1WRxLW1w4/OUgcrIE9Q5fjGyyUd4vtaY5LMLiUv
	 2gFNRnPncCf/Qv/bZMugOStb9wZvhIM08txxebGd/8pjkzca3Ic90AnmysYeoL5orSfKI
	 DTjfzPG3N6bycKbvlnM1KObbex+6uSgrzZw4vVBvGljFlrI24Q7JtSy+aVIBzew81HVta
	 9D35uLwx2Q4yTGOH0XbjV/prqA5B3JbASxYX7gNYwNpvSk8RMTkuHDaUSJZwGaQFPjA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="h/fZwFYo";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACB0606A330
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 16:17:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ACB0606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h/fZwFYo
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b87a92c17eso1603427a12.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 08:17:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795191430; cv=none;
        d=google.com; s=arc-20260327;
        b=bLGqklnMas7/hL60UcXx3tk3UbUXDgF8CJc0yK9Hm1u8XqlaxHK4vBUdx2/tn/Z/iI
         Lm/p3lCjT7eWxZsBoYTxewSTcKmxy+MgjmlbglfxgZu/zStcbVGB1IkUguXWOTakwkzV
         RWGQk23gJYAR4TWo5NYqfXTUU9YFYrZQ5PrNaswvXriV7VS6zZcCBgbYHwCw1bQn3MOT
         XlsIEVlYg/Rr87oN4IyAwzpYM7MKsFyamf/wwO2jHj+NE1YmelifPZAED32ul4uz9a6H
         M/R5zFEiOpf4Dp9pM23su+ma8IK9+YTDzXC0CmQocPIHb51490c37NgoOE1kjJXeDQzq
         391A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6pDEC7mZctjuQyIVdZ8lILmTsCvmwBFO6EStJerdj9U=;
        fh=NvSSsl149+w6rlfMAq0RGltMIJGVfKQNTRfHkqAvebw=;
        b=NH7UvLls43qKwRZvlHlDS7n1PLMcdcg+E0TnOR2ycpz81YLcJFuTBqqmlt+TW6GzDB
         Xfn4EoNj2UqdSiE052/1Bqiz0qgXurc3B0eK11+JHCsf7tU1SQ810NECs9/2o46U+MUi
         In01OXeMRW2J5mX3E3fK2gCRatIvV+mBZGNWRywtm2Lh4IsvPKRBwJFg8Fa0CtPaA/xD
         ZtEZSZeqnCKyxcAvrPCHeRH8OlY6vpNauMSjR0BLg+w4n5jHrG6LNJ9dWl25sdgE2KaP
         xaOg+kf4EG06jhQclk0fw9wsIv0cutGgsuvtwxq0SPA4BeWKH4mzBPdOnK3Hty+IJ6n8
         E+6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795191430; x=1795796230; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6pDEC7mZctjuQyIVdZ8lILmTsCvmwBFO6EStJerdj9U=;
        b=h/fZwFYoiZ5YPRIJdDNPd6R2WQqQoX+h7cTcLwOfnPyAa1DPa1hxluLRyoO6Xm4sY9
         ovgYMuN1VmVG2b0g/LvfpIVhbQQX2N6IaALoOXq1GETPLvZs61MuhJ0UhI/bX7lZx9kE
         jrz+F1knWHvPKhUY4x5+Zcq6R49IPXPGuHiJXtvd9qU+hHWP0DeqyDjhSzKwzl2IvYdL
         y8KcOZpqPD5+clxjMHGD0gIx54eNMFAhPY1AXnyv17zAzyJbePexJvC3yP8mla0hT9fU
         J1CtyrcpOL584I1Qt0hbElWxdBJJ+Dsh5m8jAkiw92q7dDtejYpy9TmKaIr813bbhk4r
         grXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795191430; x=1795796230;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6pDEC7mZctjuQyIVdZ8lILmTsCvmwBFO6EStJerdj9U=;
        b=UGrdexypELUZiFc3CUIn6hbWSd6xDv4Pr/VvqcRuoLhrY4x2pS3YS7sII7TvvBChAv
         3cqXeb7oemIHdiGcl9hjHWv9vrlc8jA+h1niA44ixlY+b8V9UqNd2O+KQ3ojE8cQhbGR
         ARLEv3wpCCuPuFLzEq40GDJFJy+tM/k/FUR6+6L5jIdNBk+0bsd4z7HGWjTr+XQzjI0f
         FED5KpB7sP9u7xmzqHbm7oQWxUvq7uc1U11L/zoxI10pNU98kjh7NhBhG2zi5PnAUYKP
         AIfpM8sQqh+79VvB9uSN1rp2FCMIoAPMKiSfLKfF7568C1EEuA6pRLp7ZabDZPuwuEo/
         qH0g==
X-Forwarded-Encrypted: i=1; AL+hErFUNYSlUU/XQkwf+p/nDGtuAM7eHDP6KOORU/pg/Yih0VpAjswAOM5xwxehv2cfJIJYFc9k69mf/jaK+Q==@vger.kernel.org
X-Gm-Message-State: APuU4Z9xfaCqX+QHeA7noZ6kXH0FAT/npQcoFIhjCiYMQw9XrOj/sSvb
	Z9ppJp3ixezd8wthAPrOLsDpEIlftUgkyPK8Xb6vX8bblBcmVBkNSuvTKVxkpeNCMwg6thW1CQc
	Q3rAjhify6L9qH0aUId+BVLlXOSrj/mQ=
X-Gm-Gg: AZFdTZfpig70x2vkevzeItVC9eadUWhxBNAjQzuwXP9sLW9Ra1ureTbDZehwGbPjyya
	Gix9nmFPYPfi28d+8GU6cBoxcrw0dPyCZ3YoSLoIzXr6ar4J52hPkE7A1LH6sITAlV992S6dWKt
	YAezeQx5XBhqSDzqWf6N9AIY9u9x/M+4VvBos+Rge2GzdoR2pwgfrp+VCUQh1A85ZWs/pb9Gfk8
	IIrZ97s4/IaKNX18lYSxUuIcKgOON7kudhfuvqq3adpw4/fKRrFJhxVewCmpxLqXQNG1qmOiEGl
	Zyix210IlRCulrmPn6GzNoR+vc/uDh3pLzBEloYO7VfEZDcHj3G4rtvxwPW5YHtc+L3cVJzBD2T
	nTIezQovCQY0cpIRyUS232rcy6YVvFuRhH6J7LRKflr+fXtvoZ8RHGsqOkuxdFXIQGKnTrQ==
X-Received: by 2002:a05:6402:3223:b0:6b8:5f08:931b with SMTP id
 4fb4d7f45d1cf-6ba37ea44b2mr2736007a12.26.1795191430236; Fri, 20 Nov 2026
 08:17:10 -0800 (PST)
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
 <DN02S2XNGRZD.1KNOZJ0GGDJNG@gmail.com> <CAOQ4uxh+d-wNC0aWLEexPFz7zj=TZjLyu61kaEmwBx9_hKn2gg@mail.gmail.com>
 <DN0526U5C1RT.3AQRIHXPB86NS@gmail.com>
In-Reply-To: <DN0526U5C1RT.3AQRIHXPB86NS@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 17:16:57 +0100
X-Gm-Features: Aa3M54o4zCHXyRapvg8jSZ5VVJaxHz4N0ZrJOn4Hcu1m2DItc14K7Jop9PLrcPo
Message-ID: <CAOQ4uxjCN-ekd18R-soD8tkGFnXjK0S1VdSNhq9b3Ev6y8K9jQ@mail.gmail.com>
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

On Fri, Nov 20, 2026 at 4:21=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Fri Nov 20, 2026 at 3:55 PM CET, Amir Goldstein wrote:
> > On Fri, Nov 20, 2026 at 2:34=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> On Fri Nov 20, 2026 at 7:45 AM CET, Amir Goldstein wrote:
> >> > On Thu, Nov 19, 2026 at 11:10=E2=80=AFPM koraynilay <koray.fra@gmail=
.com> wrote:
> >
> >> >> >                    fa->fsx_xflags |=3D FS_XFLAG_CASENONPRESERVING=
;
> >> >> > +                 fa->fsx_xflags_mask |=3D FS_XFLAG_CASENONPRESER=
VING;
> >> >> > +                 fa->fsx_xflags_ro_mask |=3D FS_XFLAG_CASENONPRE=
SERVING;
> >> >> Uhm, why both in _mask and _ro_mask? If it's a RDONLY flag shouldn'=
t
> >> >> it *only* be in _ro_mask? (same for CASEFOLD)
> >> >>
> >> >
> >> > Good question. Maybe
> >> > I guess if you want to follow some percent
> >> > FS_FL_USER_MODIFIABLE is a subset of FS_FL_USER_VISIBLE
> >> > but I think that exporting ro_mask and _mask is going to be easier a=
nd
> >> > cleaner than rw_mask but not sure.
> >>
> >> Hmm I asked that also because you said in the xfs shared extent thread=
:
> >>
> >> > The advantage being that it makes the interface symmetric.
> >> > User can alway setattr() with the buffer they got from getattr()
> >> > and instead of randomly ignoring flags in set, the fsx_ro_mask
> >> > along with fsx_mask defines the behavior exactly.
> >>
> >> But by putting the ro flags in _mask too, a user would have to clean
> >> them out or vfs will reject the call with -EINVAL/something else, sinc=
e
> >> in that case the vfs would see the user say "I want to change this [ro=
]
> >> flag".
> >>
> >
> > That's just a matter of interpretation.
> >
> > You could say that if flag FS_XFLAG_CASENONPRESERVING
> > is in ro_mask then its value may not be modified and fs needs to
> > fail the set
>
> Yes, that's what I was thinking.
>
> > if the user given value is not a match to the current
> > kernel's value.
>
> Since this is a new API, I think it's fine to -EINVAL if it's in _mask
> anyway, even if the value is the same, no?
>

The question is only about when a flag is set in _ro_mask
and say that it is not in _rw_mask
what do you do with the value of this flag in _xflags?

You can simply ignore it, mask it out as  copy_fsxattr_to_user()
is doing today and this is probably the right choice.

But you could also take a more conservative approach
like ntfs_fileattr_set() in fs/ntfs/file.c:

        /* chattr passes the unchanged read-only flags back to us too. */
        if (NInoCompressed(ni) || NInoWofCompressed(ni))
                readonly |=3D FS_COMPR_FL;
        if (NInoEncrypted(ni))
                readonly |=3D FS_ENCRYPT_FL;
        if ((fa->flags ^ readonly) & (FS_COMPR_FL | FS_ENCRYPT_FL))
                return -EOPNOTSUPP;

This is stronger, because userspace can express:
set flag X while making sure the flag Y is not set

in this case xflags =3D X, xflags_rw_mask =3D X, xflags_ro_mask =3D Y

It does not have to mean that Y is a readonly attribute
the filesystem itself could set it in rw_mask, but when user
puts it in ro_mask its a verification_mask rather than an ignore_mask

In both interpretations (verify/ignore) the sequence:

    ret =3D get_fileattr(&fa)
    ret =3D set_fileattr(&fa)

should work fine most of the time, but if some rdonly flag
can flip between the two calls (e.g. FS_XFLAG_PREALLOC)
then the set call would fail and this is not the expectation
wrt the existing FS_XFLAG_RDONLY_MASK flags.

Thanks,
Amir.
