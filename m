Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793726431;
	b=CsmRMkil6ygYLv9g+O6nsSfskRkrihCKlqWz2kOUJk9q1U81UJRMssZhP2hJKsxzqqJK
	 vj8ybBtyYvTgEA3g53VoFs55O6+IuAb3WNBE7esVm4HqEe85RlwMwYRMwqprYmjd2QP1L
	 NH3eSdTAuCDPNZmUiyJ7G32KEYyfnydTxNeOIKueeiWVJWxe6b78YyJM5U1xsWFUIrtKF
	 KHoS97IKm/SVYb6dUUQ/h20PyuLXn9bBbOP41R01Zl6otyCdt4CSSd4F32UfNbPbagXRB
	 fjEyzXB4Fqze9wz5Yx/8B0Jiuc4F3CYr0hDmxllM/b3BT4Vydir32A/YBmHP/Ao5RxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726431;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=86Lc9MS6A3cdd6/bzEUeuQeIL/ZCvTqrYUHRRUuzLr8=;
	b=mBI5ytdeydKcoqfOdCL0UwjCGJ+UjD/4bzk6CbsPl2owASjtdOCHvAjBl+7XaF2hMmjt
	 ZURHAH8TmSMDMSMdJzYiQVo/gH2J5GwHBAGKR+rQx+r8lQx+tTIiGqGJICQYjmpyzHOaO
	 e1yMR38YUIufkif/j8yVbuOTYVP6Vap3l74mtQqzbAf6dBugvjgKYK0Zb9MASRtDGQCLO
	 OYtnjgvZEyz8rez9Oz77lQM4/k2BJ/sURSpIE66GbU7cUN+G7nx21ewrzkdsDPY5FqAVl
	 c3cxMJbHsPiw/JBehuScRorvXCt0KHYRH51hAXCgRGmQVbBtkp4190tEb8fJI8VHwMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CAT1c1KO;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248A4606A31B
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 17:20:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 248A4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CAT1c1KO
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so38021425e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 09:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793726429; x=1794331229; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=86Lc9MS6A3cdd6/bzEUeuQeIL/ZCvTqrYUHRRUuzLr8=;
        b=CAT1c1KOjKFNOSEcfF8Q4hxCVvr+OhjFm3LxCQWUksq0YiPg1isDDXLT5KU3t1wf2o
         mWudGRi+GX6QShYjPJImzL9yFsN80z8ISKCaVRo1xMFdk7kbYQ30frn0kKW3oXJ3scci
         4d8IiJ3xIrAgwOR/O2AKb1pZlCYHS/KWZ44494yMJJUflSnjBIMeupoULOah66dvhfTv
         2moQgb73bGv5rJnFVUxpIgeuFe24XYNdbOYVUjs+1wqy+Vj3ib7pUbttaGOe3S+hFdnq
         Ox9OuqLfR1UCwByH7zw7c29bF1K2eB0mkmwG1yqMZktNBVib7zELGpcAvhGV62GAFntq
         sYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793726429; x=1794331229;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=86Lc9MS6A3cdd6/bzEUeuQeIL/ZCvTqrYUHRRUuzLr8=;
        b=f08GKERRdLz8oP1bESYR0mnN6pNf83dwuKYgcr62JzVY3AApjPm9iaQBozNAiH7/oh
         qY+rSoeul0UPTunLYcxFgbJ1AEeD+UwaSUvFbz7g1SvPLnmSHvUXQzc3n2FMq+lKoQ1q
         GNWyVlwRG6vpOympEs8Th0YH2a3gLfd+a4K/hnjEFJUvZ4UnKx2jtmQ0TObpOQEzK6de
         HiQDe8eF4eaDHmPzj1Xx+KC6L3ACdxLK1N2psE6enA4dKqcizK+UE86NZwHfKn74f9no
         SejtMjdk7aH2gE6LQtAV1xMY2GsYgaZhdJiWXPVqIJmprJsUpTlQiPRka+RJR4zYBiRO
         a0ag==
X-Forwarded-Encrypted: i=1; AKwUvBz4K+XbKtXs/36CvoQ2GBnhCzt31hgW+7vvRkPzwHU5Ks0YcmYXd+AUrKjzqEJ7RvqeDOPgj+kgAScENg==@vger.kernel.org
X-Gm-Message-State: APuU4Z909nW8u6e3+JfCHP9JyF70zyPJe6IzZvDWuAAv6eXv5hLg4gBt
	aU3cnmfKhpzCLp3wxNILaDjfmyMHMZGrpBOgUTF7BEUdJllwJCDbOav1
X-Gm-Gg: AYBFou1cxH1YwVQBdOXsR/30LZpqiszyPkPXfqDHxz4JyfGJFmSgCXecMpTHoeMswxR
	lhXOoiUduYz5jR8wieavudKdQyEZHgdsCfTIj69Ujkn9V0LecCbPTLWb7+SaRAoA0YPRwcz5oBr
	dFcbuF9M4AlhlHw/Fb41zqTo6I8Rq64HY+awtt42+rJke2VjUjFLnZwFk0pqWZAltiYNhp9V8uZ
	7Tyw8DxhOR8cQC/JHigBJxeswYOaXxtEgrICqXOIuqYaL/NamGJZOc7dEXKuInnPYtKeWz4OrFh
	/Ots+KdVgR4IIKCLs4ax77TfNfigUYSIwenki/ChceT5/Muku67xboUXTvAIqrsR4DX/UmDoxVp
	t6q2Njz85Pr6I6J6XwqSeq1SPkOG22ced1SV09ui6TTZecFEdgS5N/L6OwdCxMqDhChxicU1GXl
	qIG6styPsUGNlxvQirMC5k8ooV6iUR6P0QJs340RfNgioprMA3h6nWXVzhUGSJGOAVdP72/z0yq
	Zp546FWNCvjhj7sf5KVBkyBxg/x00KEiQYcauPKvNUrGzxtZErSJToGeXr9VJos4BHE1htgxEYk
	+lkHq7rWoA==
X-Received: by 2002:a05:600c:a00d:b0:4a1:83f0:7c91 with SMTP id 5b1f17b1804b1-4ac185bc336mr300886515e9.18.1793726428991;
        Tue, 03 Nov 2026 09:20:28 -0800 (PST)
Received: from localhost ([151.60.201.12])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac09ad5ff8sm248286885e9.4.2026.11.03.09.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 09:20:28 -0800 (PST)
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
 boundary=7322ed34b3f46c6e40e13ac3baf85176194b4d41a8b31fd93ebc1a7abbc2;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 03 Nov 2026 18:20:24 +0100
Message-Id: <DMLQY7IRCAX1.1B2J5G5VNEVAS@gmail.com>
Cc: "Andreas Dilger" <adilger@dilger.ca>, "koraynilay"
 <koray.fra@gmail.com>, "David Sterba" <dsterba@suse.com>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Sungjong Seo"
 <sj1557.seo@samsung.com>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Chris Mason"
 <mason@kernel.org>, "Jan Kara" <jack@suse.cz>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Chuck Lever" <cel@kernel.org>, "Darrick J . Wong"
 <djwong@kernel.org>, "Sean Smith" <defendthedisabled@gmail.com>, "Andrey
 Albershteyn" <aalbersh@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>,
 <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <exfat@lists.linux.dev>,
 <ntfs3@lists.linux.dev>, <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v3 3/5] ntfs3: make crtime user-settable using ptime
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261101015551.786044-1-koray.fra@gmail.com>
 <20261101015551.786044-4-koray.fra@gmail.com>
 <20261102142452.d6jkitgdeuquy23i@pali>
 <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
 <20261102153845.d67wlorqcbe3c2w7@pali>
 <DD1A08F1-8F47-4612-A807-AEA39461AF9B@dilger.ca>
 <CAOQ4uxh8EDX5HzFFKWv10-mHYVcSC1zXN+BS2qCm5cTMq=GOCA@mail.gmail.com>
 <20261103094906.n55n5dhrpct5ykmw@pali>
 <CAOQ4uxizEdR-MauSMOTfVcdxnuSMkrEuPth3nm3MsZuhcN5vjA@mail.gmail.com>
In-Reply-To: <CAOQ4uxizEdR-MauSMOTfVcdxnuSMkrEuPth3nm3MsZuhcN5vjA@mail.gmail.com>

--7322ed34b3f46c6e40e13ac3baf85176194b4d41a8b31fd93ebc1a7abbc2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Nov 3, 2026 at 4:10 PM CET, Amir Goldstein wrote:
> On Tue, Nov 3, 2026 at 10:49=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org>=
 wrote:
>>
>> On Tuesday 03 November 2026 09:23:32 Amir Goldstein wrote:
>> > On Tue, Nov 3, 2026 at 2:19=E2=80=AFAM Andreas Dilger <adilger@dilger.=
ca> wrote:
>> > >
>> > > On Nov 2, 2026, at 09:38, Pali Roh=C3=A1r <pali@kernel.org> wrote:
>> > > >
>> > > > On Monday 02 November 2026 16:09:41 Amir Goldstein wrote:
>> > > >> On Mon, Nov 2, 2026 at 3:24=E2=80=AFPM Pali Roh=C3=A1r <pali@kern=
el.org> wrote:
>> > > >>>
>> > > >>> On Sunday 01 November 2026 02:55:49 koraynilay wrote:
>> > > >>>> @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_idm=
ap *idmap, struct dentry *dentry,
>> > > >>>>      if (flags & FS_APPEND_FL)
>> > > >>>>              new_fl |=3D S_APPEND;
>> > > >>>>
>> > > >>>> +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
>> > > >>>> +             ni->i_crtime.tv_sec =3D fa->fsx_ptime.tv_sec;
>> > > >>>> +             ni->i_crtime.tv_nsec =3D fa->fsx_ptime.tv_nsec;
>> > > >>>> +     }
>> > > >>>> +
>> > > >>>>      inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
>> > > >>>>
>> > > >>>>      /* Save nodump flag to return in ntfs_getattr. */
>> > > >>>> @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *id=
map, const struct path *path,
>> > > >>>>      if (unlikely(is_bad_ni(ni)))
>> > > >>>>              return -EINVAL;
>> > > >>>>
>> > > >>>> -     stat->result_mask |=3D STATX_BTIME;
>> > > >>>> +     stat->result_mask |=3D (STATX_BTIME | STATX_PTIME);
>> > > >>>>      stat->btime =3D ni->i_crtime;
>> > > >>>> +     stat->ptime =3D ni->i_crtime;
>> > > >>>
>> > > >>> For me this patch looks dangerous. Somehow I would expect that t=
he
>> > > >>> "btime" will never change for existing inode.
>> > > >>>
>> > > >>> But because the ptime is mapped to i_crtime and ptime is settabl=
e from
>> > > >>> userspace, with this patch it is directly possible to change bti=
me.
>> > > >>>
>> > > >>>
>> > > >>>
>> > > >>> I was thinking more about it... Is not this just misunderstandin=
g of how
>> > > >>> the security model around the times is working on different syst=
ems?
>> > > >>> Because on NTFS there is stored just one field which says when t=
he file
>> > > >>> was created. There are not two fields like "time set by user and=
 time
>> > > >>> set by system".
>> > > >>>
>> > > >>> Windows security model allows anybody with WRITE_ATTRIBUTES acce=
ss to
>> > > >>> change that create time. Linux security model does not allow to =
change it.
>> > > >>>
>> > > >>> NTFS in this view is just a filesystem like any other (ext4, btr=
fs, ...).
>> > > >>> In my opinion if the ext4 or btrfs filesystem is correctly imple=
mented
>> > > >>> on Windows systems, then Windows security model should handle it=
 in the
>> > > >>> same way like for NTFS or exFAT. So if something grants WRITE_AT=
TRIBUTES
>> > > >>> access, then Windows should allow to change also btime on ext4 o=
r btrfs.
>> > > >>>
>> > > >>>
>> > > >>>
>> > > >>> On the other hand, I understand the use case to have two creatio=
n times.
>> > > >>> One time which would never be changed and could be used for any =
kind of
>> > > >>> atomic / synchronization by userspace application logic (this bt=
ime).
>> > > >>> And another time for human which can be changed at any time to a=
ny value
>> > > >>> which user wants (this ptime).
>> > > >>>
>> > > >>> In any case, I would suggest that filesystem driver would not re=
port to
>> > > >>> userspace unsupported values and would not try to invent other v=
alues
>> > > >>> and lying about them.
>> > > >>
>> > > >> But all those fs with mutable creation time already report it wit=
h STATX_BTIME
>> > > >> so what can we do about this?
>> > > >
>> > > > Well, what I wanted above to point out is that the "mutability" of
>> > > > creation time is not feature of filesystem, but in my opinion rath=
er
>> > > > property of the security model on the running operating system.
>> > > >
>> > > > Maybe better question is: how ext4 btimes differs from the ntfs bt=
ime?
>> > > > In my opinion there is no much difference, both of them has meanin=
g
>> > > > "time when was the file created".
>> > > >
>> > > >> If userspace requests both STATX_BTIME|STATX_PTIME in mask arg,
>> > > >> those fs could technically return only STATX_PTIME and it should =
not regress
>> > > >> existing programs.
>> > > >>
>> > > >> But this is still a bit surprising behavior is it not?
>> > > >>
>> > > >> Thanks,
>> > > >> Amir.
>> > > >
>> > > > I'm not sure what to do with it.
>> > > >
>> > > > If we allow to change btime of ntfs then for consistency we should=
 also
>> > > > allow to change btime of ext4.
>> > > >
>> > > > Maybe another idea... define new capability which would allow to c=
hange
>> > > > btime (on any filesystem)? This would at least make the consistenc=
y.
>> >
>> > Pali, I think this is a very bad idea.
>>
>> Ok, if the point is that ext4 btime must stay immutable then it is a bad=
 idea.
>>
>> > This has nothing to do with capabilities.
>> > The Windows and MacOS filesystems have allowed setting their
>> > "creation time" forever
>>
>> FreeBSD for some fs allow it too (see below).
>>
>> > and for all the other Linux filesystems that had
>> > "birth time" it was immutable, so let's not mix filesystem features
>> > with capabilities.
>>
>> I think that it is important to first define behavior and invariants of
>> these "btime" and "ptime" kernel properties.
>>
>> If we want to be consistent then there are two possible options:
>>
>> 1. If we choose that the STATX_BTIME is immutable then no kernel fs
>>    driver should allow to change.
>>
>> 2. If we choose that the "NTFS create time" is reported via STATX_BTIME
>>    then STATX_BTIME is not immutable at all.
>>
>> These two options cannot be chosen together because option 1 would
>> implie that the modifiable "NTFS create time" cannot be reported over
>> STATX_BTIME.
>>
>> We are have currently STATX_BTIME immutable and "NTFS create time"
>> reported via STATX_BTIME.
>>
>> If we want to stay _consistent_ across fs drivers then adding API for
>> changing "NTFS create time" would break one of those two things.
>>
>> In my opinion we should stay consistent across filesystem drivers and
>> provide unified behavior of APIs independently of used filesystem.
>> Otherwise userspace applications would have to write fs specific code
>> for doing their use cases (and we can stay with fs-specific xattrs, no
>> need to create unified APIs).
>>
>> Does it make sense? Or it is still a bad idea to think about it in this =
way?
>>
>
> My "bad idea" comment was only referring to capability.
>
> w.r.t the STATX_BTIME ambiguity there is another option we may want to
> consider: Don't publish STATX_PTIME via statx() at all.
>
> One of the reasons that developers have pointed to fileattr as the right =
API
> to host the creation time as well as the DOS attributes is that it has a =
history
> of carrying filesystem specific attributes.
>
> Not every attribute available in lsattr is also available in statx().
> If projid is not available in statx() then the settable creation time
> doesn't need to be in statx() either.
>
> The file_[sg]etattr() syscalls provides a symmetric API to set/get it.

btime currently is also a fliesystem specific implementation tho, and
there was already a transition from stat to statx when btime was added,
so I think ptime should be included in statx, especially since it should
be treated as one of the standard timestamps from now on (or at least,
that's what I hope to achieve eventually).
The only difference to the currently standard timestamps would be that
a/mtime are managed by utimensat, ctime/btime by the filesystems
themselves (as they're more "internal" and less "user-facing") and ptime
would be managed by file_[gs]etattr() (since changing utimensat wouldn't
make sense as said in the april thread).

Thanks,
koraynilay

> The same could be true to HIDDEN/ARCHIVE/SYSTEM flags if those
> are added to fileattr.
>
> Do we need to stop publishing NTFS creation time in STATX_BTIME?
> I think it's too late for that and nobody is going to gain anything
> from doing that.
>
> Thanks,
> Amir.



--7322ed34b3f46c6e40e13ac3baf85176194b4d41a8b31fd93ebc1a7abbc2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCauoX2AAKCRA0bnTtJTDo
OBUSAP9ECbJC4GPtv0ZQbwyzoVdtFgfZJagdg7ZyNpQl5fRgcQEAvPZvHjsU7R8/
+XA8kEU4XKDu3lY9lWJcdvBvG0V6oQ0=
=xg0s
-----END PGP SIGNATURE-----

--7322ed34b3f46c6e40e13ac3baf85176194b4d41a8b31fd93ebc1a7abbc2--
