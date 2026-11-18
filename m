Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795023780;
	b=A8Z1Bo7FKA2nXBussxGBYmGddaSqTqL6mg//rg917CZV8aVnKqu+UlqHFmazdigd/qON
	 X+UsRHgQWmBBxW2YMIFhg90n5YqrS/1OeqBFE5u6GA8XZ8DchpEfw9gstrs3GeDMtwigw
	 yBbsrBRsMU9jTJ5Tg9bmAZfPfqURjC8ZeujcsLOgYWsNzb8qba8MPj55x5oQCmb+SmKCc
	 sWsAytElS5Wftof6rvR2oLDJyZDlDanm1JrNXKSotJJjkKQrt7slD1uVJKx+M8nNnbfrD
	 hC3KzcPZ3xDcQlZ+wuF4qIpLLxnTJsnvdJcWOwChEMavP/Uh12n0lfUKlv/dHCw/jXw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023780;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ciuN1q7GJk6psMO8HqaJ4EweNO3dgrafMeDSntT6n7I=;
	b=umIntQfm+cL6DsouECy5PJ+p5O5dY1G9OrDkiNojBw/0qIyM9YH0S/K4cpzgDFsrqyJZ
	 kNUcdiw+IAW1aRnrj8SuUBn1Dl7RSOSf2Nx6/Y0A7NF+nXqr4wvCfeO42rrAKMaEutche
	 A9J7vou/CMFpNbb6EnXG575k4XA+sK6191WylJ+Gr1VagdmLae5/NHmTaFw0RWjTGSNpx
	 +63z4P7zsSbE+sCXv1Fx9PyYvZ6bV7F6jK5LB4kr8ZNyrSL+anIT3LDY0kfINt5lvSJYz
	 frcteQ9FwxJZ90rUaIOUjLgZzjttlXhZAGlohqLINZXRwncACirEW1JdBiidUlKLyiw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ntRkyPbH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822B8606A325
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 17:43:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 822B8606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ntRkyPbH
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b87a1a2babso145498a12.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 09:43:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795023779; cv=none;
        d=google.com; s=arc-20260327;
        b=mpQzu6F7GUhF23tfbyu1V2P4+wjA08vtRuKPXtsrmh+ziSuh+x4O4gPDLSbTlMO+EV
         G/0Qkn2IBeEXUCc47TefE04yyFzSL8gCf0duHvWMFxBYPR0MXVgQUS2UTHozTkVjuH/J
         iqrEdSpvDRuBf9BiSyOLq5UjPljTJrRKFd00/xo0PvW3QR8pDsTrZz2MGs/Nfd0G5UXq
         WiWYR9ZJDZtGSXp1XyGZVdYBIdh8aBt2nuFqPcLICESubgZf8dzGRpAFl2bCG0QObNPJ
         rMns8so6vy1muNZKrXpuGtncftZ0HqWM9jjaIAxO7JetSqlzIPWm9hXr0XNnOtSZqrGL
         NHfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ciuN1q7GJk6psMO8HqaJ4EweNO3dgrafMeDSntT6n7I=;
        fh=ryyN1qdXNIFbqImr34Wql8C/344QkmvQ2A97DZAyhgg=;
        b=pV1VscSB3ne7mpPNArXUOg29lMcStH6bTS0Ai4gZdoeuogV36BYRQp2uonLNeUQ9qp
         f10zRaicOY2rdoh8SqdAlmkyDPX9cXx7Qsf2ylhRcmhzmt5gQjNfxEdnZO1/nrt6bRF9
         I1tmiJ8MLgMgr6WMT04lx2RIrCgbFD6sZq0fdcjAwXMJfG5Ej+kpfJ3YtlVWEbVG8Y8f
         176HAdh3Kkw3xkLQQqCnLJ37wC3aXAODx+pG28KHTG/YYVEJKuZ49K1N90siBBdI3RXk
         FJFGx5+ACLZl11886PAElc038DIXznWh6xDlLHs9X4JidWZf+F1A1YukLDRZuVQLtf9+
         cbbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795023779; x=1795628579; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ciuN1q7GJk6psMO8HqaJ4EweNO3dgrafMeDSntT6n7I=;
        b=ntRkyPbH0sYjrGxbsOGUMGapMwa1Ew8BC3KxQf/iyM1aDPSlhjn0B7wO7Eg0MQnCiJ
         D0hyH5hpSWTxAh3O5zAp8o6klUYs95/pv3XYR3HonGc7ZODF5h7znk0vF5koQA9eJjcv
         A/wwsh144v6Aic9y2lIUf23EIeDNRzV8Y8oHNhFKBeOSPRHtD7qplu37vone59H+oKF4
         3jyhqe487oQtXgrud96W2cRO68ugz7TuvNBmwciDPUNM52RpTaAyUc/w3O7d8UOWWzQK
         XV5u7Ub2PM0CzqPeRSqAAHIxtSwFvo+5bIH8XaTuJLebB7/eeHz/r3H8P7s2hjLFBe8q
         o+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795023779; x=1795628579;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ciuN1q7GJk6psMO8HqaJ4EweNO3dgrafMeDSntT6n7I=;
        b=TJqgOFE5K25BPKIEwYBdWpIWLVTciqk53iuLeGlZHyCnqAiDZoxRALcyjiYwpkpYog
         kDSNt1pf7wBom6bjPTxhOlak7PA0f5UtU2uSFUAnZ3NEyg7scDc1B1rx29iizstdd3Rv
         /b1M6NvYQkCiXdv8xvn2LmfkWs8DRbP2jN5Y9Ilpx6Ny9/5oqOKjykgovsjLeutHz4Xw
         ekNWPaPhGwuJIvwpdAbl0hgXlxnglwXLEW/jIjiIAzX4GpRKrGxKCQ/bZIKvqaMlERcO
         eiy3f7cFjh0ERan07m853yu7ao+WI4iKz78vPzffp+39GPkO3rTzQcWghfatnmL909cy
         mGjA==
X-Forwarded-Encrypted: i=1; AL+hErHzZPyC3z97/60ROXwIvEfOJJUc3nfFAlbKebwkSnHfa+AMn4AVmegFrnMSiEbGOjvSp02hw04bpUpqfA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/bDQcbnaxmctA2U+6SrYe0P/glDY23so3SFstU72LEfxOmLD7K
	1DaNu63IgcYOmZbiThjVmJBUN53zak39lhg48bc7UmkTqahTkeNjDhVKnwXqL8yp/o+bVoBvL5D
	7e+YDljKZ4UCP67vsNj5npO5PK53jbIA=
X-Gm-Gg: AYBFou22k2xeeDYKeuGJtllPB0Ra7b53SpDMoaNdKUiIXtMGxPDpsorPmQgDKmbxva5
	sm+henrh0UIb3P2CIzdsAmfs+nBSPUTtcnLADGnJmpP3DreloamHgW4d9hkAJvG/0GBPiITyQjo
	WqITu+5LDcGwid2aCBy7Xr0YmmtdqOmXNxDiZEGw+sH8ij/EP5sWWFImiRsgNDpsJAiH99Ww6ou
	+p2YNbtpgrepjJYgtnWHOpMRbJnHqZnm764NbXTr5JHZ59wqrWM+7TtUsZ9S7outBFg3vEUXg+X
	ZFZBwgJwqatG0svKxlUmTOnUhJ/CZtBlud7D4zBuydDao2zyxkoYoD6Ylze4+UKu+puS2/hsT3j
	cDGrp4Al5A8rfvHHXCEl/0JGHsJrYj7QM2EB25a4f63U0wl3OjqGdlVpByUqkC6QNbOyOAg==
X-Received: by 2002:aa7:c259:0:b0:6b3:e4e8:74ba with SMTP id
 4fb4d7f45d1cf-6b9b29685d7mr115387a12.13.1795023778657; Wed, 18 Nov 2026
 09:42:58 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261118142613.be3r3s6kobkkxnz4@pali>
 <DMYFBDIV4Y08.35ZKR5G86U1H7@gmail.com> <20261118151605.lqtn5fz423kuswk5@pali>
 <DMYHPLWKPSH3.MUM1IIZZIWNR@gmail.com> <CAOQ4uxiwpdC-fKkqS5kiZ515q9MenC0jX4USV1idN7h2njx45Q@mail.gmail.com>
 <20261118173708.ax4t7zzklr5jvf2t@pali>
In-Reply-To: <20261118173708.ax4t7zzklr5jvf2t@pali>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 18:42:47 +0100
X-Gm-Features: AclHuK8TtEMT4ky5dtrBYdddz3l6RdahxalryFAKqWHd6v7Nf1ie2l606ulnXFE
Message-ID: <CAOQ4uxi+GvBRD8T4kFSqqZ-bxYfN3L8A61jtS2SeoGM6rN-3=A@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/10] add provenance time (ptime)
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	exfat@lists.linux.dev, ntfs3@lists.linux.dev, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 6:37=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> On Wednesday 18 November 2026 18:28:04 Amir Goldstein wrote:
> > On Wed, Nov 18, 2026 at 5:50=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
> > >
> > > On Wed Nov 18, 2026 at 4:16 PM CET, Pali Roh=C3=A1r wrote:
> > > > On Wednesday 18 November 2026 15:58:02 koraynilay wrote:
> > > >> On Wed Nov 18, 2026 at 3:26 PM CET, Pali Roh=C3=A1r wrote:
> > > >> > Hello,
> > > >> >
> > > >> > I have just one issue with the userspace API. It does not allow =
me to
> > > >> > figure out what is the source of statx btime field. If it is fs =
ptime or
> > > >> > fs btime because this RFC implementation is mixing both fs ptime=
 and
> > > >> > fs btime into the statx btime field.
> > > >> >
> > > >> > I have feeling that this is quite a mess in API and I would like=
 to see
> > > >> > a clear distinguish between btime and ptime in the API, like the=
re is a
> > > >> > difference in the fs storage.
> > > >> >
> > > >> > If the btime is used for forensic analysis then somehow I would =
expect
> > > >> > that the statx would not report / not fill changeable ptime valu=
e into
> > > >> > the statx btime.
> > > >>
> > > >> Hi, for native linux filesystems it will report ptime as PTIME and=
 btime
> > > >> as BTIME (also semnatically).
> > > >
> > > > That is fine.
> > > >
> > > >> for the windows-like ones that only have
> > > >> ptime (semantically) I think it's reasonable to not expect btime t=
o be
> > > >> immutable, since they are meant to be used with other OSs who lack=
 btime
> > > >> semantics.
> > > >
> > > > The problem is here that the RFC statx API does not provide this
> > > > information that the fs lacks btime semantics and instead it fills
> > > > non-immutable ptime value there.
> > > >
> > > > I'm pointing only about this inconsistency.
> > > >
> > > >> > It would be really helpful if the statx API on inode can differ =
between:
> > > >> >
> > > >> > 1. btime is present and its value is ..., ptime is not supported
> > > >> > 2. btime is not supported, ptime is set to value ...
> > > >> > 3. btime is present and its value is ..., ptime is set to value =
...
> > > >> > 4. both btime and ptime are not supported
> > > >> >
> > > >> > This should cover all cases of different filesystems and also al=
lows
> > > >> > userspace to do proper backup of both ptime and btime fields (if=
 it want
> > > >> > to do forensic analysis or anything else).
> > > >>
> > > >> These should already all be covered by STATX_BTIME/PTIME and their
> > > >> fields in struct statx, the only problems are windows-like filesys=
tems,
> > > >> which IMO shuold be handled as mentioned above.
> > > >
> > > > Exactly, I pointed out about these problems. I somehow expect that =
the
> > > > new API would be generic and uniform across filesystem. IMHO it doe=
s not
> > > > matter if the filesystem is windows-like or not (there are also Fre=
eBSD
> > > > fs and also others which allows to modify that time). So better
> > > > description is fs belongs to category 2. from my above description.
> > >
> > > Ah yes, I used windows-like to mean "only have ptime semantics", so s=
ame
> > > as your category 2.
> > >
> > > >> Of course, as in the other discussion, I'm open to changing ptime
> > > >> NTFS/exFAT/... support to remove btime altogether and only use pti=
me for
> > > >> their own crtime if that's what wanted (I'm fairly impartial on th=
is
> > > >> specific issue).
> > > >
> > > > I'm giving some ideas how to possible handle this situation:
> > > >
> > > > 1. do not fill btime it at all when it is not available (remove bti=
me
> > > >    altogether - the case like you wrote above)
> > >
> > > This would be the most semantically correct option, but would break a=
t
> > > least 1 script/program/use case.
> > >
> > > > 2. when userspace ask both ptime and btime, then do not fill btime
> > > >    (remove btime altogether - but only for that new case)
> > >
> > > This probably is the best compromise.
> > >
> > > > 3. fill btime with ptime value, but add a new output flag indicatin=
g that
> > > >    the btime is not present at all and instead kernel filled ptime =
value
> > > >    into the statx btime field
> > >
> > > I don't really like this, it adds complexity and uses memory/1 flag b=
ig
> > > for a single specific field, IMO it's not worth it.
> > >
> > > > 4. let statx btime as currently is, and add two new statx fields:
> > > >    immutable_btime and ptime. immutable_btime would be filled only =
if the
> > > >    fs supports real btime (so not for ntfs/extfat crtime) and ptime=
 would
> > > >    be what is currently in RFC
> > >
> > > I think this is also too complex.
> > >
> > > > Ideas 2. 3. and 4. should be fully backward compatible as it would
> > > > affect statx output only when called with new flags.
> > >
> > > Then 2. is probably the best way to go forward (maybe I'll include it=
 in
> > > some way in v5), but I think we should let each filesystem maintainer
> > > decide if they think their users want to have statx report their own
> > > crtime as btime, ptime or both (native linux ones would of course
> > > report btime as btime and ptime as ptime).
> > >
> >
> > Guys,
> >
> > Let's take a step back.
> >
> > If this discussion is proving anything is that the btime/ptime
> > duality is a big headache and it's going to be a source of confusion to=
 users
> > even if we come up with some smart pants consistent semantics.
> >
> > As Jeff writes, I think we should consider making btime mutable
> > be a per-fs choice and not an API limitation.
> >
> > A filesystem can even decide to store both the forensics btime
> > alongside the user settable crtime.
> >
> > There are some precedents in xfs with settable UUID which is
> > a different field then the origin UUID from mkfs.
> >
> > Fs that have immutable btime have a few choices:
> > 1. Keep it immutable
> > 2. Start making it muttbale (like the Win fs)
> > 3. Start making the user visible btime (STATX_BTIME) mutable
> >     but keep the forensics btime on-disk for, well, forensics
> >
> > If btime becomes settable via options 2 or 3, this could require
> > admin opt-in (e.g. tune2fs -O crtime).
> >
> > With option 3 the crtime feature would be ROCOMPAT
> > With option 2, it could probably be COMPAT. Maybe.
> >
> > If we accept this story and the major fs maintainers are
> > in agreement with this plan, then I think the missing piece
> > is making the "settable mask" visible to users via the new API.
> >
> > IOW, we need to somehow export FS_XFLAG_RDONLY_MASK
> > to userspace instead of only exporting the supported mask.
> > And then with the addition of xflags_mask, we could also
> > -EINVAL on users trying to set readonly flags/values.
> >
> > Perhaps a single xflags_settable_mask is enough.
> >
> > For file_setattr(), xflags_mask is anyway a set-those mask.
> > For file_getattr(), does it matter if we get an answer
> > Filesystem does not support casefold on this file
> > OR
> > Filesystem does not have casefold on this file and
> > you cannot set casefold on this file
> >
> > It's kind of the same, isn't it?
> >
> > What do you say?
> >
> > Shall we drop PTIME in favor of "is BTIME settable?" API?
> > Leaving STATX_BTIME exactly as is.
> >
> > Thanks,
> > Amir.
>
> From the beginning I had a feeling that this is not an option at all and
> that is why all that ptime-way was chosen.
>
> So thanks for brining this up. I like this your idea. It address the
> original problem with backup/restore of "create time".
>
> But I would like to point out about another thing in this your idea. It
> would be nice to have an API to retrieve that "forensics on-diks btime"
> in case there would be filesystems which choose option 3.

Anticipated this question ;)

As I said there is already a precedent with xfs settable uuid
(I think other fs have it as well?). All the metadata is available
to admin via xfs specific ioctls, but not via the generic vfs APIs
not even to vfs via vfs APIs.

I don't know if this is good enough, that's why I urged to get an
ACK on the API design from major fs maintainers.

Thanks,
Amir.
