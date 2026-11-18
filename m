Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794987856;
	b=VdWKjm2YYh5caRxELDApK20P5tD0ShUeS2CHKaguhYXvJtpJZLwoEbR57D42y/MqZY67
	 FfAxRugMbtcFNnNrebKLF7NmiPtm00++PFWGmjSbUAGHM3vli8TrxnuxGZKulKMVa+LsP
	 7IbkB1JGt6FosSJJXXY1tu2XlEWRey8OFcEs1jmP6+ntlCqj/QH6ps2mbFiTXNSxP4TMY
	 dD5fOYleQBCJq6ob1f8FmpifBVIRmlOfXh74+9EtJ2BxgFkkcafg0sQAguZUzL/2bojJ4
	 q72JYPQq6U7Chvutt1T8UEZ2yKh5IlrrJYa03pzIh/KbeJ5VH2He+zZPqM/Zm0LfxVw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794987856;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=n4AlrOV2bTkxElEMddERWhd2tmhmmQ/VeiiLUiTK5Jw=;
	b=Qsl+4FFKtsTv0Q/oP47gd+cBEMXaymir3wB5mEx0LvYSo08kOtRxXdYowMID4/eh/XCb
	 g9VWNaRVnsf5EbclTfMdognUvMZc2EtY/o6iMMPkChqvrsll8lSav62teGJufAP7g+Rvj
	 VSXNdEP1HiMhFZ1yDEJ4UZPUHKST/hPz7dVczMEWP7eIRen26sxbonex6ipQ9s44TYiAu
	 KfAedRaYdpVi9TKUtKQAkP+qTr7FjoK9XQMAlB0Hq520ISsSzjFLEuOz4fyxRenIOo6G0
	 Y2uqWfPharmPv0bk9Xdh1jOJxoJa7zWZ5UrFh7XKjh7POOS7kc+gFDZitWC2TAyySpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a90oyekV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8492606A33A
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 07:44:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8492606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a90oyekV
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c50cc8e0f84so84847366b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 23:44:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794987854; cv=none;
        d=google.com; s=arc-20260327;
        b=e7ZLny7Q2J/hgr5wVG112xFtzoDw81Qjm3tfYG7E1AZmjkxdOdyvNBCL37I71tJ5P3
         n9xKdPj41ZsO3GjE3hCtT0sS6hm/HsQ/A0RysT/f2Er2w4q8AUK4bU844pyuTe/SNFxW
         bsSei4g2v1KRpDWyxub870fWLbHL1VNeVa3gRo8loPuAKUCBR5ufnDSlVwPkAy/BoewD
         sh4+t0RwwH7Tr22kO08B7oVrBRZ1KoReraZqep8jCID2Nub16janu6vwfpElPR+QMxHC
         SeRvjm+dutX2U1GR4Pl5vNJihJ36G2exGXbrwwwGnHVgaM8K/RmS4RdgJrVAplzhrDir
         4oEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n4AlrOV2bTkxElEMddERWhd2tmhmmQ/VeiiLUiTK5Jw=;
        fh=5OR+jRCudyOEeT+JkPtfSg0WR6kyHWXiD6iZoRwIbK8=;
        b=EtDbx0by+bhVixm25PjshJ6wC/2x0LVbW4j4CBXAPejyM+nUaNFgvhLrTcEkvwe+Au
         PPKAAvhRiFhsxIgmRI1UX3OmRXWxY75QRGecGDpemgDmrzZBhkv9USb0JjEwWYghowNQ
         1aMkebehVvxgHfZO8FYEwiH8HKPhhH1e4ua2sySakSilHtlRiBsiAiRfrCLnJd1qz/70
         2PmyiGFEpxuYIu80NiCK9utr6f31PC8n2MCWcACbhzRbknUsgky4OjWdJ0ZdSWvb5v1Q
         AUuOqbxNvyz2uD/Rp0mNDf3Nz76tXtcfWIVn+OQWN0m4OyEhJ49YbqoK2ezNcHCNKLQM
         uw9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794987854; x=1795592654; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n4AlrOV2bTkxElEMddERWhd2tmhmmQ/VeiiLUiTK5Jw=;
        b=a90oyekVEtWSbiQRFscTKUuOugQqsd/uPA+FKR2IB/q1W1t8taa8KZshmfMtrhj1sD
         LqlTnKmsQhen50SBtfcKu6ft+wmIP8g2pM86rjRDF5dOKhx6HkBJjAXW7T1Tl+HJbYGM
         9Z/N8X+v0TSuGqaim2wrUn/cNQfHBvaUNsmrozwAN8tX044VAK/I37vtJhmtoyIAOWLA
         XYHsu5zGuiaBInhEXWSkPT9Ljesxk0waBX2hq58DlHTNOBoHWFxCJ3W007gohZobfiCi
         lUKynaBj5mnjW9OxWobgOEENOt4UOL2ebqhsSIkfnMawpK0ePLqbjCd09xHI9SQgG63a
         TzFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794987854; x=1795592654;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4AlrOV2bTkxElEMddERWhd2tmhmmQ/VeiiLUiTK5Jw=;
        b=xew+yTv6Qo/Fr3BUHpVii3sj/EV/h0TzCfK0ig710w2KIulCkLdHF9jd8iNlDbmZio
         umMbInX3Uzg7c/ioexyj+RlWzUzo6HV5/m880QjtJ+Mm8m8M2snw5zrnL5tuWZ52EZDv
         B7P2nm6HF5DBMh3fa6KNhjpHfJ5v92uVot/cWhk113qXiSO3IF4Rt0eLTeWagblLI5oR
         yiwlWwAenI+8UiBcPvtdxCwVkGUZ1CYYhrh3o83mA4KMHg8eULBVfz/6e60cadaTllyX
         IIEqxIbFI23B2Vh8PEqMS4LF3vLxBkMcV+CRQH1+yUAUF1WvRJOM2oKDpd7+B79k6mTT
         LIiQ==
X-Forwarded-Encrypted: i=1; AL+hErEPBm/X2nR7m4/9UKY8lVmxcnIjF6TQUJmKLpb7Zlefv62+fapV+8mrrXubG+aUx2URHFbYhGIZcLj25g==@vger.kernel.org
X-Gm-Message-State: APuU4Z/UrGKB+QdwHwYKW0sdiJubdoIramTLzcMMIRQwLMcDcEBGLXev
	2u7TLGou/f/87+6/Vgu8DPOuCcYfT9Qd4x4LSg8hu2PYc9+nvfuzC8/JIjPysNcuICRFEnAkz+r
	FN3BNVUpOVZp6p7t45AoAQt2hXY6lrxg=
X-Gm-Gg: AYBFou3I6/O2JivcWSXDr0RCCbfT5l+lusnkB8AmMOQnn9kpN3QPN0XmGBkZL6Ajld8
	7jkMwqxUKQyjATwlQnFZivUGhfRRapqyO5XdTZcLgu77hFIu/lx5y75GQdkkG7ejGO847k/U1Pc
	fgnXIBPew8hP77yagR4P6l/fEi//s32x0HHmlB5sLlSIlUILZLLZvgUI/if6EDVe9FO5WKSFM4n
	OVNuO4FCGL1+9SQDMwXfSekM0LaCD11HB1Y/NiJ/6bbTAlENbnMTaQgQG6yMVluHlPfPQhCqBsf
	9J+SgnvsK8Iot42dDEBYWjJtYIi60TL0NaahreOL8boeZjmFuGCH/69gSSMnpyt1ikfgOC2STRR
	nJyKpFzlSXlfyaBfSwmWjm08JikGKHqDf5kQbHwgxOh9WZZdDw5FzZO9Yx8uAxK4Sx7wlUw==
X-Received: by 2002:a17:906:99c5:b0:c2a:ad55:b3fa with SMTP id
 a640c23a62f3a-c510debbf56mr128472166b.7.1794987854109; Tue, 17 Nov 2026
 23:44:14 -0800 (PST)
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
 <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com>
In-Reply-To: <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 08:44:02 +0100
X-Gm-Features: AclHuK95FDUZyIgGYH5oXAgwPF3l-5HxSmk1nBdJ9DPBoS5wbYWUIu9nYKyQ4rA
Message-ID: <CAOQ4uxhpMARO_ZMJDeoa044BwufLVnS0o4Fv0abBF=tjaZmtWQ@mail.gmail.com>
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

On Tue, Nov 17, 2026 at 11:02=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote=
:
>
>
>
> On Sun, Nov 15, 2026, at 1:03 PM, koraynilay wrote:
> > Implement provenance time (ptime) in NFSD, as introduced in a
> > previous commit ("vfs: add provenance time (ptime)").
> >
> > Map ptime to FATTR4_TIME_CREATE, allowing clients to set it across
> > CREATE, OPEN and SETATTR compounds.
> >
> > If the underlying filesystem supports it, use __vfs_fileattr_set_locked=
()
> > to set it, returning -EOPNOTSUPP in case it's not supported (i.e. when
> > __vfs_fileattr_set_locked() returns -ENOIOCTLCMD).
> >
> > When querying FATTR4_TIME_CREATE, request both STATX_PTIME and
> > STATX_BTIME, preferring ptime over btime if available, and advertise
> > FATTR4_TIME_CREATE support if either ptime or btime is available.
> >
> > Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
> > Signed-off-by: koraynilay <koray.fra@gmail.com>
>
> > @@ -3646,7 +3649,14 @@ static __be32
> > nfsd4_encode_fattr4_time_access(struct xdr_stream *xdr,
> >  static __be32 nfsd4_encode_fattr4_time_create(struct xdr_stream *xdr,
> >                                             const struct nfsd4_fattr_ar=
gs *args)
> >  {
> > -     return nfsd4_encode_nfstime4(xdr, &args->stat.btime);
> > +     const struct timespec64 *ts;
> > +
> > +     if (args->stat.result_mask & STATX_PTIME)
> > +             ts =3D &args->stat.ptime;
> > +     else
> > +             ts =3D &args->stat.btime;
> > +
> > +     return nfsd4_encode_nfstime4(xdr, ts);
> >  }
>
> I have trouble with this approach.
>
> We've already established that, for the Linux in-kernel NFS server
> implementation, FATTR4_TIME_CREATE reports a file's birth time and
> does not permit NFS clients to modify that.
>
> After this patch is applied, the server reports the ptime instead
> of the btime on some filesystems but not others.

In other words, for some server filesystems FATTR4_TIME_CREATE is
settable and for others it is not.

Isn't the NFSv4 protocol equipt to deal with this complexity?

>
> Essentially this changes the semantics of existing files that have
> a btime set -- technically that's a regression.

I fail to see in what situation this is a regression. Please explain.

The only oddity I can see is that a kernel downgrade could result
in an NFS client's view of FATTR4_TIME_CREATE going backward
in time to birth time, but I don't think this qualifies as a regression.

Thanks,
Amir.
