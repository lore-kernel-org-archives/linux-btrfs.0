Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793694226;
	b=Rcu0m7Pc/43VkH5TppIaEWjSeRn5s7gK/nneuJSaWLQd1likbeBL+cwX/cPZm5eizIzU
	 LN/Tt/WMBjtyIUEA1RGU1WmwP+n3cPGgOmi4xpkbz49AKHU0BOpmlXF9oZ5MpJm+q59gl
	 Y6RGjwsxDEPEckv1smFiG9SVJ+21ySU+8HmTWZVSK3Ib2bfUs1YtJFTp8WvuVjFJHpd1t
	 Zqo3hryAPkacK136cmPdTY1P7BiVROtI1SB6Dvz+6wFwDplP1/9Od07DUOHwlFFzYGoYh
	 d13Dz/oArNpcYKLvenLCSNlFSdaON8BjRoGIX/+KTO3Hi2n1/1G66NUG9JF7NNot8VA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694226;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=yA6hU2sQZ4Y+eZ/PDzKNfCId0VDZzgM+56tit9vJIV4=;
	b=fmNtPUr6/uoDOlaQcoP2/xAXia2FI8Cw4rNdmpJ6o03hiQqPjbQXQOgUwm1qe9gc3kZn
	 NURk4cQOLSWK5kTbvO6mim38v37kJ5VnTp34b4bOPCyDZEDdYa7mKsXOOENc0aaGrXeme
	 8N4fqHZhNI+OiQBO0NVXbgxS15tY4UXCoaKUVClCSaspam6w7RlrPqcreZN9MbiIwx2Ow
	 wu2eF2WigUy3YRDWt1Zng/+P9TIx6/Y1a6NhSNgeG85MNyUrO2DUyPFmiAHfFsQbpq/lP
	 mRSH1FhcSGMf2NjkJTfUcETbIuz+sH78+u/iX9VwO2aOsJ5kEhh46mRBQmywb8jqbiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lWHAZwCN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C03606A330
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 08:23:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0C03606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lWHAZwCN
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b486e1d02eso4975871a12.2
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 00:23:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793694224; cv=none;
        d=google.com; s=arc-20260327;
        b=MfirsqfAUK8ai7liomkIagOHBHCkNWWNpqCTdbYg7Rdym0Gpg4cZb5gjvxi8DhO1h2
         EdxjLD6xzVThlC0gUtJ6JBIU5yI2+SvRyxkn2U8X27SVIO4+BF1Dex58sZEK5JORUNj8
         OX9sZX07a1sSeGCW04hGyLcmRrj70CaOjn5pdQodaWWBCMwN94d/EfG7BvOto62TCRo3
         8ghUNR1WbaAC2DTjD8lTPJzDqwEGBBbi0es0xpv4IKylDI0PG+/1iHLGiLno5RfRmWHe
         YlUUdEis0DlKKPbfmq08ymfyEYHtZtZwlxOoRAXO//TM8FmLPF+txuczo4VJHDnB+YRL
         oRxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yA6hU2sQZ4Y+eZ/PDzKNfCId0VDZzgM+56tit9vJIV4=;
        fh=XzwgIZ9xFq/7aLFmM1aRNTHw+/n8UQeZHDV7dc3gUjw=;
        b=rRHmU3b4xUVWRcIqg/UelBYmtqLIAO3pqXTGK1itnCwNF5noEZE8s5g6dVzQl91m3n
         xApWLxlMVfHcDE8Jo/PtzDzH0RaKBl6nv/1cqdhbeas+5lC00XvndCmZpTHpMMe2NF7g
         z2Fk7u5AIXfmP41sRfh3Hty33p7xveLDAwazbb+JF1y1UjkAwzpUWPxnUPjuSdI3/o6w
         j3acX3xJ6Gt/6C3NsIdQLFrjPLoB2rm3Ch27TTSYFloxh9TNfAMN75ktjyOe31QrpxpN
         j6pPbv5+7StzneTd9vaNFxd7u8otS72j9Elxi/JTKSCivhCyMTu4CQPYk2AWSWEeTZSs
         TnXw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793694224; x=1794299024; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yA6hU2sQZ4Y+eZ/PDzKNfCId0VDZzgM+56tit9vJIV4=;
        b=lWHAZwCN2j9VCafVElf6Qh8D8vvaaSYVevJpNoedkabcWYrgtlD7jROuh9pdMa657g
         Xwz8WCf7a76sNE6xKEBpOy9WZeDSwsXpKDzZYYChXxoMN1QYTKiSzbtvw7Y28vIwco11
         Aod/Po0FNpmp7dSlEpzXgeLnjdeFkpQSm7xQ3jhYlLKpUtvusoOPXLabvcBg0UeZCaV+
         Pl39g5vhx0JYcy8RWVs111v6iSZyvxGivN+q4SFTdBcDGQetSnu5iMalJ+xPPQLNacBy
         XlKrIfacwa2wSQb4AaGKFpJg7bodQ+Tlmp/FYAxDSiGD/T7qhfFdvV3qqGdgCrExmgSN
         oh4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793694224; x=1794299024;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yA6hU2sQZ4Y+eZ/PDzKNfCId0VDZzgM+56tit9vJIV4=;
        b=y7Ue/uSSqBm7CB85COzQEZt0xcm93t1IttCI+RdVr+A0XthHLUZxshoh6FzpoosMro
         f99zSir1ygErdtez3VggO8OPlnTjN4y7cQJu84Ji+7FABO1xlwmJhd87U1SlTtzAoIiZ
         pEdCL9phpN4ptpC5yL8H4wyH+lNPsYJ5beR71OoUAKahmi6K+wNh2TjIHNEoaGy2ALBj
         V1Uov2mm5vmajbobvxkpPnoDUf/EEIF2cPBM8gVJTmJPTLio4u+qQcmbByILk2l4kBTa
         VxwbbTNqbEjdP5o5w/FIEEyU9ISqSU0rvy4OEZfa0tvwGTYBlqyKNGM6gWrm0IP8db1n
         cmrg==
X-Forwarded-Encrypted: i=1; AKwUvBzupSnpJ1cIkX0E3+5/v/58E1Hs68+p4jOGLPO+e/n3SaLerlfRU/1mnla8J8P/PEKXjBQ+6JlDkg3MGw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+styGNPT2s2rm/7/jdUrXcczh0f9IHlTy1x0LFqjQILotbfw9+
	HWbeEGh7MKJ9m0T/iE9XToJptJXkGFyfVf54GYzMizm9KDT6C4AJVdNn7fakY4doZjF0CPodNYi
	notphN+T3D7y+aULXvXm0wO2nQlo2NCo=
X-Gm-Gg: AYBFou3dvyDGYsSY7j5NsAGMhq8+k9IrSUfnAZN72SNcz2Wtz4RvA6pJwGp4Ly9p1xx
	udW0IlmcWvesbaqEqUvqJAarZBWxkNO7/n1CBIqyHvmYxoRnLZwmlXlnh96Yk6LWjtbyPl/YWX6
	EOWOzZPCD6To6eE3R+P2WdBu1L+QUtwwjXeaL8bNmM1XxyLWWQNisMNSlupRCfzoSfqdqvPVw34
	sx+tI0IRGrStj2OnEmG74lw2TsOEArbVBxuhI1GyFrE/QwjJI40xL66Wg06EH6tfhEfiswomEnN
	PjVx9TgOZuO9oj5SY1p+vEKqRhA2x2LBD4JxI3thi6WlHbIzc0cUcyfb2+moCFIy8RM8k99+abw
	n33VDcxu0dgJgWcMmZ342IgubsM1W8NNop6sJlxKDaNWD4rRq1D2A4fXM771S+b2UB0XWYQ==
X-Received: by 2002:a05:6402:c4c9:10b0:6b1:e4cb:a23e with SMTP id
 4fb4d7f45d1cf-6b4d4a7cb01mr6242658a12.14.1793694224038; Tue, 03 Nov 2026
 00:23:44 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com> <20261101015551.786044-4-koray.fra@gmail.com>
 <20261102142452.d6jkitgdeuquy23i@pali> <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
 <20261102153845.d67wlorqcbe3c2w7@pali> <DD1A08F1-8F47-4612-A807-AEA39461AF9B@dilger.ca>
In-Reply-To: <DD1A08F1-8F47-4612-A807-AEA39461AF9B@dilger.ca>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 3 Nov 2026 09:23:32 +0100
X-Gm-Features: AclHuK9_FOBguds5nMupp459e9fws0wpL7yhjWaQXRG76sxS7QLY8j7j6Ep0tiM
Message-ID: <CAOQ4uxh8EDX5HzFFKWv10-mHYVcSC1zXN+BS2qCm5cTMq=GOCA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/5] ntfs3: make crtime user-settable using ptime
To: Andreas Dilger <adilger@dilger.ca>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Chris Mason <mason@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	exfat@lists.linux.dev, ntfs3@lists.linux.dev, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 2:19=E2=80=AFAM Andreas Dilger <adilger@dilger.ca> w=
rote:
>
> On Nov 2, 2026, at 09:38, Pali Roh=C3=A1r <pali@kernel.org> wrote:
> >
> > On Monday 02 November 2026 16:09:41 Amir Goldstein wrote:
> >> On Mon, Nov 2, 2026 at 3:24=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.or=
g> wrote:
> >>>
> >>> On Sunday 01 November 2026 02:55:49 koraynilay wrote:
> >>>> @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_idmap *i=
dmap, struct dentry *dentry,
> >>>>      if (flags & FS_APPEND_FL)
> >>>>              new_fl |=3D S_APPEND;
> >>>>
> >>>> +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
> >>>> +             ni->i_crtime.tv_sec =3D fa->fsx_ptime.tv_sec;
> >>>> +             ni->i_crtime.tv_nsec =3D fa->fsx_ptime.tv_nsec;
> >>>> +     }
> >>>> +
> >>>>      inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
> >>>>
> >>>>      /* Save nodump flag to return in ntfs_getattr. */
> >>>> @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *idmap, =
const struct path *path,
> >>>>      if (unlikely(is_bad_ni(ni)))
> >>>>              return -EINVAL;
> >>>>
> >>>> -     stat->result_mask |=3D STATX_BTIME;
> >>>> +     stat->result_mask |=3D (STATX_BTIME | STATX_PTIME);
> >>>>      stat->btime =3D ni->i_crtime;
> >>>> +     stat->ptime =3D ni->i_crtime;
> >>>
> >>> For me this patch looks dangerous. Somehow I would expect that the
> >>> "btime" will never change for existing inode.
> >>>
> >>> But because the ptime is mapped to i_crtime and ptime is settable fro=
m
> >>> userspace, with this patch it is directly possible to change btime.
> >>>
> >>>
> >>>
> >>> I was thinking more about it... Is not this just misunderstanding of =
how
> >>> the security model around the times is working on different systems?
> >>> Because on NTFS there is stored just one field which says when the fi=
le
> >>> was created. There are not two fields like "time set by user and time
> >>> set by system".
> >>>
> >>> Windows security model allows anybody with WRITE_ATTRIBUTES access to
> >>> change that create time. Linux security model does not allow to chang=
e it.
> >>>
> >>> NTFS in this view is just a filesystem like any other (ext4, btrfs, .=
..).
> >>> In my opinion if the ext4 or btrfs filesystem is correctly implemente=
d
> >>> on Windows systems, then Windows security model should handle it in t=
he
> >>> same way like for NTFS or exFAT. So if something grants WRITE_ATTRIBU=
TES
> >>> access, then Windows should allow to change also btime on ext4 or btr=
fs.
> >>>
> >>>
> >>>
> >>> On the other hand, I understand the use case to have two creation tim=
es.
> >>> One time which would never be changed and could be used for any kind =
of
> >>> atomic / synchronization by userspace application logic (this btime).
> >>> And another time for human which can be changed at any time to any va=
lue
> >>> which user wants (this ptime).
> >>>
> >>> In any case, I would suggest that filesystem driver would not report =
to
> >>> userspace unsupported values and would not try to invent other values
> >>> and lying about them.
> >>
> >> But all those fs with mutable creation time already report it with STA=
TX_BTIME
> >> so what can we do about this?
> >
> > Well, what I wanted above to point out is that the "mutability" of
> > creation time is not feature of filesystem, but in my opinion rather
> > property of the security model on the running operating system.
> >
> > Maybe better question is: how ext4 btimes differs from the ntfs btime?
> > In my opinion there is no much difference, both of them has meaning
> > "time when was the file created".
> >
> >> If userspace requests both STATX_BTIME|STATX_PTIME in mask arg,
> >> those fs could technically return only STATX_PTIME and it should not r=
egress
> >> existing programs.
> >>
> >> But this is still a bit surprising behavior is it not?
> >>
> >> Thanks,
> >> Amir.
> >
> > I'm not sure what to do with it.
> >
> > If we allow to change btime of ntfs then for consistency we should also
> > allow to change btime of ext4.
> >
> > Maybe another idea... define new capability which would allow to change
> > btime (on any filesystem)? This would at least make the consistency.

Pali, I think this is a very bad idea.
This has nothing to do with capabilities.
The Windows and MacOS filesystems have allowed setting their
"creation time" forever and for all the other Linux filesystems that had
"birth time" it was immutable, so let's not mix filesystem features
with capabilities.

>
> I think the ext4 and xfs maintainers have repeatedly said that btime/crti=
me
> attribute should not be modified by users.  There was a long discussion o=
n
> this from Ted as well, and the reality is that "creation" time is not wor=
th
> the bits that it is written on,

This is an opinion of individual people, who did not lay out technical
arguments.
I have concrete technical arguments in favor of first class creation time f=
or
ext4/xfs from my experience with production systems that need it and use xa=
ttr
to store it (by smbd), but I am not going to list them here because
this is not a
thread about implementing mutable creation time for ext4/xfs.

> since it is not preserved by any tools, has

Facts check:

# NEWS for rsync 3.2.3 (6 Aug 2020)

## Changes in this version:
...
 - Added [`--crtimes`](rsync.1#opt) (`-N`) option for preserving the file's
   create time (I believe that this is macOS only at the moment).

Incidentally, I have an implementation for --crtimes for cifs [1], but this
is not extendable to support all the filsystems which support settable crti=
me.

> a "vague" meaning (is it when the *file* was created, when the *content* =
was
> created, do edits update it, is it preserved across filesystems, archives=
,
> etc.) and adding it into the filesystem is misplaced effort.

Sorry now you are talking nonsense. Meaning has nothing to do with it.
This is a property of filesystems (plural) which have documented APIs
and documented network protocols - it is what it is.

If you are looking for a meaning, it is the first publication date, whether
it means something to you is irrelevant - what's relevant is that customers
use it and want to preserve it in backups, whatever its meaning is.

>
> Storing it as an xattr has some reasonable chance of being preserved acro=
ss
> tar/cp/filesystems, and doesn't introduce a herculean effort of changing
> all of the system calls and on-disk formats for every filesystem.
>

As I said I can provide data for why the xattr approach taken by smbd is
limited and inferior, but this is not the place to get into it (there are h=
ints
in the rsync commit message below).

Thanks,
Amir.

[1] https://github.com/amir73il/rsync/commits/cifs-crtimes/
