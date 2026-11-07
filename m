Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071380;
	b=b5yiy8ResdP1+Lm8nWnJyMuyZVgGhYbX3DTiTtzRk2hA0H/kywz9H0LDVgE5/4EpbpYZ
	 DiTxkOjMqDSFG4fn7y/JUlaqmDlpPyjznL/kEOX7f6kDfwlp8Ga6JCTMcBJ1HlBEr3glO
	 F1+Jp6qY3dPmfFkhlLHfCkOxxum9a8zl0D1gROsBY496u63ygxppcvl/07obZ5/X9YrVc
	 dQ4CxSNBf7mliXphdbOg7qkoaEcDACVDYHKd6U0iGGAUWsUsbdTOZrWLoMdXpRPuTuO5x
	 1ZiuCj4GLV+JvpxEx/gLLeSg7+Uh+nJkwWTKiUdH7B096PgYyN7fnTi0OSBNoniuxpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071380;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:X-Mailer:
	 References:In-Reply-To;
	bh=Uo6XeYcnV/x5wbpR7pZuFSSSODwH8TPy4AbG/hgvRWs=;
	b=IW1h3fZ/lpRW+Tbz2bx2YqtuSVpL1Se9akabkwtnRNGIDYG/3FPn8E8D+s5xlFcKCU3r
	 48OxJDsuYLl2+MeVKIdYZX5CnriODay15vh2uFYKvAbzEVS6tfbaEwrKp6pkxkzXbdHpE
	 L8ErFehmDfW0wbfzlP7XRalmL+9Tcdwrp1m9LHrEuJXfgcTxzX+DzZhEQks97aSaBw/5X
	 w6KxMSwPOlNNmdNUDoj1MJYiMjiaJ8HkeMvRbtDA8klkeJf9eaUkFVeMybHABClZu6g36
	 9b2dCP91aaRV0WUId1l7ievh0bZoY1eI4AZUPQiD+U/4Cai1G4vB/LMIpSK2eoWSWfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FBLki2AJ;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBED1606A32C
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Nov 2026 17:09:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBED1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FBLki2AJ
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a215e64962so18366735e9.1
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2026 09:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794071378; x=1794676178; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Uo6XeYcnV/x5wbpR7pZuFSSSODwH8TPy4AbG/hgvRWs=;
        b=FBLki2AJGBeQ54jkvu0WK8OGjDWsQzv8Q+98dp9ZolzbeG2I1S7zLKim2dXIgiJq9N
         vNHmoKkQWpTwLHfUKcmlhSwxPHVBkgKgEeNzJZgCDvKeJGrdGBQ1wSNmB7ZFiw/1tR9p
         W+S9+okUE7B0Z7oL7B30Dle49C5AU+y7OnJ3sCUl3FiX8BMeJTj9RpFAeRDwYtV60pfw
         Z55WiM3bCmJd633OoJVcSqoEBl9H3DNTtm6S9jCOz1bQwkr4U5V25mNy9uD0Nfjj+Fgg
         ru9bMo958NpEI2RI+hojtJs3sdsEjpmVz6t95FtiDa2hNkD2JQnfUka+02t/AjDEIFHi
         rNvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794071378; x=1794676178;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Uo6XeYcnV/x5wbpR7pZuFSSSODwH8TPy4AbG/hgvRWs=;
        b=OCZJ3faihW3Y13YqAHeYwKw/8xA02bYa7GVMkqn4J5KApRcLYbw0lAfAoy90DnqbtJ
         p05QY2WAIlf9K/AFv1h73Xad+DK28cgKLZl0HmnWh4aW9+3Ys3wfuKobejtfCekmu92n
         1IhNhK/qXKMv3VIqzBAiwDz/AnY8UzVHgJrvgZBbT47NYXiDXkjDz7ETUy527KVFrF8Y
         8eOXl+jLhs+BYeB80iXAzJS0yRRMyU8plydsU6b7JXd1a5QWhHiVR4vlWEQEDaske4SI
         dcvSAXyHtE2QQnVkm+y3CsRURKdlbUIfxRpl7Ahfk78o/5hkTAkP8ODn7eSIAZGuf+rR
         R9Ag==
X-Forwarded-Encrypted: i=1; AKwUvBx4Lu9VxyYqQmyjLElMaih8VqMLB+FkukzO6ZsecVamluC3+frdLIMxqWUZ/3/meTEvYWqk+lje2ArZcg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9srGYx3e4N8/IW8C4ShXguXFsiMbHaF8qaeMwVhDNIottTq0R4
	Ey9ytOGuxun+yegx1Va4YtRgNvly/ocfMpsqf/bjAd3C/3kzVpONQ/4O
X-Gm-Gg: AYBFou0qEyfPOLVZhlr3nF/nCtsP85Af3eFnJpGETPd8XgrwShc4xEQygrcpmNg/rms
	pXQixqYhRXImkNXaHEkyXjXS4oO6x67EW695t1uWdM0SDScOMNAmDNSy+vwjttcaEzyHRn24Aoq
	iEKuclXmIT+1ZHyzXHynXDWLAFkYZ7OuloFO5AXv2TOFGg9fjwSKjB56JEhUA3jQ/pE311y5Ws0
	D7aKXiBaeG5mi6zh0jZjJrJg/0UzDa7d8wxGXaWwuA+HkfDxIL3pCzS/Z97SH/srkX5s8Zht1hn
	ZMgx25xL59CWss5e6ygQj0Wmvo/a/NDZQl39NlL9Lkf3AKBmrJ80vB8oRl2kvDO6hEs0g3ky8kh
	fyGg7A5Xv4OdI4moBBEzfC+8TwpXZJDWzbDzWUo/2US9aUKUnAHcUPVOwb7TE8DbggAKwTXISiU
	AYzYz7D1dFG0ew6KrcHFWncbSPsdUFvwt+rS1npgqmJzVP9EzSrl2UgffAljGbKG4/hgw37QGG6
	ysNh8LIvSWof/H3AOgUP+7f66tKnfZgQALWTv6XFSaDmdugMHa/S41aBzs1oSjLkKB0Th7X31/b
	er2D1LJK9pKyUxRiTB98LFyUgQ==
X-Received: by 2002:a05:600c:a013:b0:4a1:c6fd:4db0 with SMTP id 5b1f17b1804b1-4b6df5eabebmr104412535e9.19.1794071378114;
        Sat, 07 Nov 2026 09:09:38 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7e32ad610sm201380835e9.3.2026.11.07.09.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2026 09:09:37 -0800 (PST)
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
 boundary=90b72889c6b6179eb92b7fa762786d4ce0b6554dc9b311a78855b8ffacbe;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Sat, 07 Nov 2026 18:09:32 +0100
Message-Id: <DMP582BGB7DV.2U0SJLJL7A87K@gmail.com>
Subject: Re: [RFC PATCH v3 1/5] vfs: add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Sungjong Seo"
 <sj1557.seo@samsung.com>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Chris Mason"
 <mason@kernel.org>, "Jan Kara" <jack@suse.cz>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Chuck Lever" <cel@kernel.org>, "Darrick J . Wong"
 <djwong@kernel.org>, "Sean Smith" <defendthedisabled@gmail.com>, "Andrey
 Albershteyn" <aalbersh@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <exfat@lists.linux.dev>,
 <ntfs3@lists.linux.dev>, <linux-api@vger.kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261101015551.786044-1-koray.fra@gmail.com>
 <20261101015551.786044-2-koray.fra@gmail.com>
 <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com>
 <DMP3UBB0QVOT.20HIXK7ZL6K6U@gmail.com>
 <CAOQ4uxgSVc8n1LbL_dcU-DpNN5BB-ap_vGdXEu7+d0Td7PK5Tw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgSVc8n1LbL_dcU-DpNN5BB-ap_vGdXEu7+d0Td7PK5Tw@mail.gmail.com>

--90b72889c6b6179eb92b7fa762786d4ce0b6554dc9b311a78855b8ffacbe
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Sat Nov 7, 2026 at 5:48 PM CET, Amir Goldstein wrote:
> On Sat, Nov 7, 2026 at 5:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>>
>> On Mon Nov 2, 2026 at 3:00 PM CET, Amir Goldstein wrote:
>> > On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com=
> wrote:
>> >>
>> >> Add provenance time (ptime), indicating the time when a file or
>> >> directory was created. This is user-settable via file_setattr() and
>> >> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
>> >>
>> >> The semantics of when to preserve this new timestamp are the same as
>> >> mtime, the idea being that there is a correspondence like this:
>> >>
>> >> ctime <-> btime
>> >> mtime <-> ptime
>> >>
>> >> so every operation (copying, moving, ...) that currently preserves mt=
ime
>> >> should also preserve ptime.
>> >>
>> >> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
>> >> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
>> >> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr()=
 to
>> >> allow ptime to be used with the file_setattr()/file_getattr() syscall=
s.
>> >>
>> >> [ This is a re-implementation of the initial patch[1] by Sean Smith
>> >>   <defendthedisabled@gmail.com>, following the advice[2] from Darrick=
 J.
>> >>   Wong <djwong@kernel.org> of using file_setattr() instead of updatin=
g
>> >>   utimensat() ]
>> >>
>> >> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@=
gmail.com
>> >> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
>> >>
>> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
>> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> >> ---
>> >>  fs/file_attr.c            | 33 +++++++++++++++++++++++++++++++--
>> >>  fs/stat.c                 |  2 ++
>> >>  include/linux/fileattr.h  |  5 +++++
>> >>  include/linux/stat.h      |  1 +
>> >>  include/uapi/linux/fs.h   |  8 +++++++-
>> >>  include/uapi/linux/stat.h |  7 ++++++-
>> >>  6 files changed, 52 insertions(+), 4 deletions(-)
>> >>
>> >> diff --git a/fs/file_attr.c b/fs/file_attr.c
>> >> index 833e03810b24..c0645cb22bf3 100644
>> >> --- a/fs/file_attr.c
>> >> +++ b/fs/file_attr.c
>> >> @@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>> >>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>> >>                                   struct file_attr *fattr)
>> >>  {
>> >> -       __u32 mask =3D FS_XFLAGS_MASK;
>> >> +       __u32 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
>> >>
>> >>         memset(fattr, 0, sizeof(struct file_attr));
>> >>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
>> >> @@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct fi=
le_kattr *fa,
>> >>         fattr->fa_nextents =3D fa->fsx_nextents;
>> >>         fattr->fa_projid =3D fa->fsx_projid;
>> >>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
>> >> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
>> >> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
>> >>  }
>> >>
>> >>  /**
>> >> @@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
>> >>  static int file_attr_to_fileattr(const struct file_attr *fattr,
>> >>                                  struct file_kattr *fa)
>> >>  {
>> >> -       __u64 mask =3D FS_XFLAGS_MASK;
>> >> +       __u64 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
>> >
>> > That is not the correct way to extend this API.
>> > This fixed mask was added as a placeholder for
>> > "We intend to add support for more xflags to selective filesystems":
>> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-2-amir73i=
l@gmail.com/
>> >
>> > Please see this POC patch for filesystems to publish their supported
>> > xflags mask:
>> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-3-amir73i=
l@gmail.com/
>>
>> Quick quesiton, should _mask also be used for user-space -> VFS to adver=
tise
>> what it wants to change?
>> This would be useful for on/off flags, but for ptime both fa->xflags and
>> fa->xflags_mask would have the same meaning of "I want to change ptime,
>> look at fa->ptime".
>> Should we make _mask the only way to advertise what the user wants to
>> change, ignore xflags | PTIME in user-space -> VFS and use it only in FS
>> -> VFS -> user-space to say "this fs supports PTIME for this file"
>> (which will be always once support is added to an FS, so it would just
>> be "this FS supports PTIME")?
>>
>
> Sorry I was not able to parse your question.
>
> I think the mask should mean "this FS supports PTIME"
> regardless if the user asked to get/set it or not.

Yeah sorry, I'm just a bit confused because of all the similar names and
concepts.

(assuming btrfs supports ptime and ext4 doesn't)

* filesystem -> VFS -> user-space, while in fileattr_to_file_attr():

  for btrfs, for all files[1]:
        fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 1
        fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1

  for ext4, for all files:
        fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 0
        fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 0

* user-space -> VFS -> filesystem, while in file_attr_to_fileattr():

        fattr->fa_xflags & FS_XFLAG_PTIME =3D=3D ignored
        fattr->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1 if user wants to se=
t it, otherwise 0

Would this be correct?

Or would it be better to set FS_XFLAG_PTIME only in fa_xflags_mask, and
never touch fa_xflags with it, which would make the above become:


* filesystem -> VFS -> user-space, while in fileattr_to_file_attr():

  for btrfs, for all files[1]:
        fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1

  for ext4, for all files:
        fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 0

  (and always fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 0)

* user-space -> VFS -> filesystem, while in file_attr_to_fileattr():

        (fattr->fa_xflags & FS_XFLAG_PTIME =3D=3D ignored)
        fattr->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1 if user wants to se=
t it, otherwise 0

This would mean that fa_xflags_mask is used like stx_mask both by the fs
(to let the user know what it supports (a.k.a. what it's returning)) and
by the user (to let the fs know what it's trying to set), and fa_xflags
is used only for ON/OFF flags (like immutable).

Let me know if it's clearer.

Thanks,
koraynilay

[1]: as we don't have a "no ptime" value (since 0 is a valid epoch), all
files would have it if the fs supports it

> Thanks,
> Amir.



--90b72889c6b6179eb92b7fa762786d4ce0b6554dc9b311a78855b8ffacbe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCau9bTAAKCRDmj22qf5IG
XLOnAQCYgmkH9FcgSKhJkILhSIa5F/PVtSlv2NxQd9SmQy++kAD+O8Jm/L7wqEIX
9+esMnf9eYtazI3CTEE5wrzfACj7uQs=
=Jjnq
-----END PGP SIGNATURE-----

--90b72889c6b6179eb92b7fa762786d4ce0b6554dc9b311a78855b8ffacbe--
