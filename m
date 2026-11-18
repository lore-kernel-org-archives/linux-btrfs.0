Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795019816;
	b=11UOLZ7V9kCt3ts0Ny9ZIg8HLBLu7mt2w++L9aktzLCE8Qeb/59mem1XH0priGmR9KI0
	 QC+RXY8GeW1WrouNlBvXSgFLpla7dl7ZtVtEpJkn2J5wOnarQI6DtXVqnkhCLdf8IXSph
	 0WdTZKduDZ9cSemDx8FtpJRYAjTLfiAJv2PRkZwOQ6SoCRp9rwJut2S27xdojwpgDmbOA
	 z39KeD7nkZOzk9KVen467NiwZZCsElLH4HSRarLrOOKtiRbH3sGEFvuG5leP1e8vXmb+M
	 mAuqd+XuT7MG8Jbqd96S99y/qvCovuCnWtSsZTgjwOiQdKaPbBC2tjDNrmaO9bkdr6Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019816;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ThJWWn15R7JIY3hayjLwOhu3LzqQd50Rds3OyAm+UpI=;
	b=X1SxQ3brTGQmolPpe9EeCdoSAiEAK2MX/OYLnOmRAfh0vpBse3zikhEmp9N3n87MMXkn
	 yfAW6oNXB3D0HY8Wl+FCj1w5GldoJ32mSCTCmuJvvTT9r9ICXkTQUOln8fAVKtMo23tSj
	 8kZq1CtiwppquoHfCEFaPn7mIA0tD1B8CL6m8eBS8ZuaG8j5g3lrCh2XvhkLGo13WaH4o
	 nVLJ6JHiRqdNT+l6KdBfuNvJ8GtpIixt67wiS6yIMOXRAwolhQpjZc3fPWXFZe05q8NyC
	 FzVNqucTLIU0EZtsiYAaUUteFLKFzjhIQoo29hWFHr+Fyif+d0gsEHsw4Z61YhnGlzw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q928FUfp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF9F606A336
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 16:36:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CF9F606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q928FUfp
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b8815693e2so1678045a12.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 08:36:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795019814; cv=none;
        d=google.com; s=arc-20260327;
        b=ibv9joN0fUo/aXcbcxs/4gHcmocQzBnVgNrcuj+yHPXbtPIiPrtkGn1kGWlM/PYnkG
         uG5OaGEInAR3bzzS5Nbpm4ZS7Bh7Avt9iW63vTvRA7pc2I+ZwkbkHJydz1ksGFEJ58Pq
         7RIyx89i/I8tyhe+4oFadVPSFnLxa8RICWJLGR/OjD2swTCjP4nPjLOOkDHI1sLGVsUf
         Y3amN+3JWX6m0qJLgyPEKzSlZYVTmbeV2x79OiFt2ig/V7nF47uQ5p/EOcncHsBXjx7i
         rj3DzxeuziWDKYsjcaJei5s2Tkdl+hJVF6pJqzZ4GKYoErdwhSNqP95wkzqwyiGg/YNS
         pQJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ThJWWn15R7JIY3hayjLwOhu3LzqQd50Rds3OyAm+UpI=;
        fh=1m7aGSacofdpNlJ5BVD3dxz3aLL8jBT9xXMpm9mWdY4=;
        b=RucN8c7Eds677l4zbKFs2LV4WfXLuSLylVEFZGTiVSGpuERRrVfCD83Yph1txwUamC
         Yui7oBjC5IM6OndaDCKy+kwewyPinXS4mTUBcmxBpliiSsoZEvEyIEPSat+/r1rw3Ugj
         AWBI2lmv0pCrVEUJZnEikCWuAZBQM4JFyRkRcgog1pRa24JfEKXBlmxaGYNQ0DY7J8m1
         zH8KjgpX7qMJfuCWs68HbcmCr4komTWDRj7NzMJ1VR1PzaRL9CA6QqyLJMPajXpSRH23
         m5vuiPI6GssNOapPoXhC+4q8NgTbSk8aC19gxbCOHw4BREetEQ7nkVtb/KMH0H3KH3UZ
         HeLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795019814; x=1795624614; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ThJWWn15R7JIY3hayjLwOhu3LzqQd50Rds3OyAm+UpI=;
        b=Q928FUfp2LnQkjGEnKMIMu+nIXWPV8Mw0HjVjFDQa7MZUVLuYPLFwnsc7iiHqC360u
         Kp8IRabh9aATlCbBIrXYC8LB4ujsA2WowQnPl0onFZOSJ5rVYhQ50HD2q0pTUJXyKimM
         OUL77cTMfVDMrYjz/NQW0TKyEQpYRFMt7Ju+HVxVGfRQjrSAY87Mpzq+C/2x9bC6NTow
         OtYFWyMzdvLEcoERGP5aXpJZMZOJljjkWPd07rML7zS6cDn/RnBxJCXaYM/7fpaXHvui
         3d3div9gMzI9ed77/rJrBt7B9+fw7rgFDQ4NESvylFpmE6QFtWC5GnB6Lj4Ro4sGb6Nt
         AJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795019814; x=1795624614;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ThJWWn15R7JIY3hayjLwOhu3LzqQd50Rds3OyAm+UpI=;
        b=HdXgzZ0r3NU0rihBlzyHUY3wEVLWzQSArjYAyeZgNV82E8mvcpmZBgdYrZWVpa/hEb
         qklB7om/ZSq2+TgW+yoVssbNihm8yRF1fquvZnkR/VCwDOmr+1MzdCAS+b0/HiQaPCc9
         TBCwJHH1sSLjyc6deA0tL9mVShQUQn+wYhC6nMucCviB0szysqiFrqSSJAHRZ10GGd6b
         8/59XO++Ujbfbbxp4oGGKgdTRVfQfWcfxogujZKYBmFkFP6t86a9w9JXA4AgIhAh4iX5
         i4e+bT0TdFI2/mLd/kYyas1MiJNdbFVKq4J/cqAV22E088hHCLkSrVmzl89DAGwLQzU8
         NzDg==
X-Forwarded-Encrypted: i=1; AL+hErFF0QK65UejgYp9h7UAqwdRyL6GNhLxc3wdaVAdhEFXHuVY2m1yd93WGl4MTh3zjwkLpRKwaWvswVEupg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9iJTFc6RqasD3rokqqs/Mc/MH7IQGacD1DVYMUomNwYGu1Awjg
	jybGuQRW6tKg9lMHQnYuUpYPICAEAUvmWWoeROdJmdzHgmfaBr0079KyX9S+5ON+bUPkhh6TpaB
	F+ggiPpY9jngRq0mNhiYowxaDo2eQmCI=
X-Gm-Gg: AYBFou2XabDhmRRL8JjdfOGAAJD4tyBz3j8/ndXJGtyLSN3zrdAS1YIgtBeuwj6s9p8
	+Ag6vHHJpNXl5QYeDkNnBOcDcslJw8QuIVz5HTeWSED5aYIRjZFeJ6aOM8XOVAQ8l9xVbqt1jSK
	QoS70sFJhHJGy73WgR/JFpGOAdM4fEZsW/cCscBSDlvKFV/xbv5y9D2iHi+HMWCkvfPX9b88voY
	thPM0Jchtwb+JwbHjzaAJRJYtd/azkpFalu/Jqaw9/KxymnXvA1lkI/TmF+TX/osYhym6k6HaqG
	U0m4X9XpeHz/UDnTQ5krBIte54ONZvTgb/kNLspVOoZ0Q0m6f+g1XqJzJbixcFj9fiPfT6hkaU0
	pUDM6tEsvxXcosO7ivu0T2en03MKG+lORYXCTTNJLNDRIYAEY5mlDA0cJ4E+gfbOSyX3NBA==
X-Received: by 2002:a05:6402:c711:20b0:6b7:b12e:1638 with SMTP id
 4fb4d7f45d1cf-6b887effc26mr1999145a12.37.1795019814317; Wed, 18 Nov 2026
 08:36:54 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-8-koray.fra@gmail.com>
 <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com> <CAOQ4uxhpMARO_ZMJDeoa044BwufLVnS0o4Fv0abBF=tjaZmtWQ@mail.gmail.com>
 <cd49ce48-58d7-4341-b4fc-34e63daf3c52@app.fastmail.com>
In-Reply-To: <cd49ce48-58d7-4341-b4fc-34e63daf3c52@app.fastmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 17:36:41 +0100
X-Gm-Features: AclHuK_Wot5qcfi8_9CAebWCtd31KyKZ5gW_T2w6JAANm_7TsCfaaSyfxQBsTLM
Message-ID: <CAOQ4uxjme9sJ5LGNDnP6rEKZLTJzX_ZdcMohgu2iLULK96GPOA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 07/10] nfsd: add provenance time (ptime) via FATTR4_TIME_CREATE
To: Chuck Lever <cel@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 5:09=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
>
>
> On Wed, Nov 18, 2026, at 2:44 AM, Amir Goldstein wrote:
> > On Tue, Nov 17, 2026 at 11:02=E2=80=AFPM Chuck Lever <cel@kernel.org> w=
rote:
> >>
> >>
> >>
> >> On Sun, Nov 15, 2026, at 1:03 PM, koraynilay wrote:
> >> > Implement provenance time (ptime) in NFSD, as introduced in a
> >> > previous commit ("vfs: add provenance time (ptime)").
> >> >
> >> > Map ptime to FATTR4_TIME_CREATE, allowing clients to set it across
> >> > CREATE, OPEN and SETATTR compounds.
> >> >
> >> > If the underlying filesystem supports it, use __vfs_fileattr_set_loc=
ked()
> >> > to set it, returning -EOPNOTSUPP in case it's not supported (i.e. wh=
en
> >> > __vfs_fileattr_set_locked() returns -ENOIOCTLCMD).
> >> >
> >> > When querying FATTR4_TIME_CREATE, request both STATX_PTIME and
> >> > STATX_BTIME, preferring ptime over btime if available, and advertise
> >> > FATTR4_TIME_CREATE support if either ptime or btime is available.
> >> >
> >> > Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
> >> > Signed-off-by: koraynilay <koray.fra@gmail.com>
> >>
> >> > @@ -3646,7 +3649,14 @@ static __be32
> >> > nfsd4_encode_fattr4_time_access(struct xdr_stream *xdr,
> >> >  static __be32 nfsd4_encode_fattr4_time_create(struct xdr_stream *xd=
r,
> >> >                                             const struct nfsd4_fattr=
_args *args)
> >> >  {
> >> > -     return nfsd4_encode_nfstime4(xdr, &args->stat.btime);
> >> > +     const struct timespec64 *ts;
> >> > +
> >> > +     if (args->stat.result_mask & STATX_PTIME)
> >> > +             ts =3D &args->stat.ptime;
> >> > +     else
> >> > +             ts =3D &args->stat.btime;
> >> > +
> >> > +     return nfsd4_encode_nfstime4(xdr, ts);
> >> >  }
> >>
> >> I have trouble with this approach.
> >>
> >> We've already established that, for the Linux in-kernel NFS server
> >> implementation, FATTR4_TIME_CREATE reports a file's birth time and
> >> does not permit NFS clients to modify that.
> >>
> >> After this patch is applied, the server reports the ptime instead
> >> of the btime on some filesystems but not others.
> >
> > In other words, for some server filesystems FATTR4_TIME_CREATE is
> > settable and for others it is not.
> >
> > Isn't the NFSv4 protocol equipt to deal with this complexity?
>
> Not a question of whether NFSv4 _can_ do it. It's whether it _should_
> and whether opaquely choosing a settable vs. an immutable timestamp
> on the server is the right design.
>
>
> >> Essentially this changes the semantics of existing files that have
> >> a btime set -- technically that's a regression.
> >
> > I fail to see in what situation this is a regression. Please explain.
>
> Any consumer that depends on btime being read-only is now screwed.
>

Who is the consumer in this context?
An NFS client?

Can't an NFS client be connected to another NFS server
implementation which does allow this?

I can't wrap my head around the problem.

Thanks,
Amir.
