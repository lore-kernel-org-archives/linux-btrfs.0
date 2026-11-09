Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794234915;
	b=NegHMb+t5e0nnSgkWI6DMU4SboMh/a2n2o531hkAO65AhRbG5IdelNCZWzZbAsJgrMpg
	 /+te337Wvu9OJi/5C3D8n1yFQMnjqhDbepja3y25JtCuT1LoMztNT3I0yZ52Ocm9SkKcV
	 yED2uSo3eGlhbz4Yh0qSPnOFbLtMwQcXZqb1bxPIXI0L+gudI/TsA5XtSrEUIWM1fUwLr
	 e50Bw3bd3TVKMM5QK4AdA6JomyPtfL7BUNQ+M9gQpPuT46THd2MpRpVqfKth0NqH3ZcNt
	 imZ54bge8SU9v1Vj9XKSvYA4MvRfWzBeSUz8+3HJknBuh8IO/deqBzt26Ontir0xxdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794234915;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0DP2yyIupbH6DsaD6N2BQPQTWSxBg8RNCtcYu23tXoo=;
	b=2TjsMZYWIy9Kbe7s9OTKUJwsn17Ze6B2yAqFIRqZ7Max6U95sz5r25uOYu1u4yM3upvp
	 4x2u1U0WdFhoxu1ifE5XATFffrZOQ6TXrgTEFnCpJZdExcyKeDEAkdKzFiunkai/iSpl9
	 wbz31kHC5lh8Vrc+OgVhsYwNz0BrXJo37NCyrNGGmdv6quHj/0wz23enuv7wxkiyW3eKC
	 p/MlgN3uwHs/PQsBzwa21Jx1WKXkKl21GHwHN3tlem8mGRERp/Rpvr8dLFltqyadh0Ouj
	 G5KF6Ry3qys0ga3FcdAEF7abNR12cXlMwW0xwMLkFaxYC9/AZ6A5dhKth9rHInVMXDA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FcRBLneC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0051F606A33F
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 14:35:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0051F606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FcRBLneC
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b56221d361so1204190a12.3
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 06:35:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794234913; cv=none;
        d=google.com; s=arc-20260327;
        b=XYGIvbdpR1bWulWsvYTtPn7FZRsNPtISwbqMDmQuW0vOjoZYHK9xLxzzA4BDDGAl7V
         sMm0bvKHGfB+QUnFbKBiS4wrnxs1dh1tCGrYlkRaMYbniry7Tn6BxoZj053imAuG4dqQ
         ftaZ2Y4ZI3WwolgIuyZ3Fxbl2z0a2K1ilhB/oJPSoH6KignrcwxqwsNvPGf4XxMEz4Jf
         lu+F2Tq1il4n5lZJpU6J+sbWTilcjmqebXD0LR22ChTwpXouxPXFGwfcvOyUE4Hbak2+
         oUoh0U8dHUaaA1YgXvdVzOIMLMlcu3G88d4btQly4SXq3BiPvR+/WKF+TdVEy1TDs+vI
         PGQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0DP2yyIupbH6DsaD6N2BQPQTWSxBg8RNCtcYu23tXoo=;
        fh=l35Gw27szC6TAA1Y0JSWVOvi/TXxwSWb5wHWxT1Eptw=;
        b=oBWVR5YbBm0kaYASYgln9MdOfh2qYmIt3KjqTWNPHeqosE5+JVIVtbNkQetFfJlr4D
         oBJtndIxUc+qzzj/x4ifgoz5LhDQRrgED1W6BacI8b/TonTY9lf4DQ7CjdLCMziCASMn
         HIfx3n0+O3yPCu0xqDAfqnjMxqQGUjSKFaSNsKabEOzb0JzzpKEj0IcNMV2zFul58AOp
         FeczMn+gFvAxpUXOvMBRtbCn6JFQW7jrgLftbJqWpdJZgPNe4Jey1U+OcjqT2gUoFTQa
         weMU1715JptQRrNm5O8jXgFhgnkZ5Ve/r1N+ils3bFYwi6FrnHJ4CSTmDtKPQNFa+ze/
         0HTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794234913; x=1794839713; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0DP2yyIupbH6DsaD6N2BQPQTWSxBg8RNCtcYu23tXoo=;
        b=FcRBLneChJ3iVAtYKXY2VEwYNzesOapHOFksvKPhX8sUFzqbpdbVJSRohKdAqKIJGx
         X7sRc/w9F2cJdZMa33dL+1NGs6t8XyM9vT5C4r6r0S6IBHFnTO6k3UMqLzLG/5hxkwh8
         WJzumXQT9LoGeh3I/lQ/bNC3vjjbNqzah27nTcEw9PPPblAH16VkFfAh3FoN/BVVEAzr
         h9u5SbcgtTUS+w9ZgDc242PytiA/SV9kkYzMVj5OcgOY17/pVJcFEGi31YCnIxd8paPF
         s0mXAS1ScJyM74V96vt/80mXa0+3SR4y/KhT3XqDxzYkpbJs7lYvT8D+GRO0NbPKUopk
         nhNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794234913; x=1794839713;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0DP2yyIupbH6DsaD6N2BQPQTWSxBg8RNCtcYu23tXoo=;
        b=dLSkbsDaeeUWKmAjU0OIpqjK8rApttrZ90ftnuZJMyvwtIQbucgL0VtXAlHE4joe8x
         Qes1RqhgsFjAnF4jrYaAe69RoKuhMxRvARFAO4+wpiFuSAHUoHXDWlhetNPXLoClNbAz
         YNsd6iuVDA/tr6NKKxu1WsN9lI2ZHXaSSzWiRCyf75DUxotZNg+CxvJ2q4/NZq49evQJ
         G+II8uSrsV+zwMF2rWbOss651rkRqBbpfQxu/1l4FYVkmCTHvK4ZpZwftfvWSk8L21Wh
         JGmDOKMLj9nOD6hXaRntB2Jb8LDbvdKZi5LK5ncKezm9vA8DrX+mLnR4kLYwW8QFg/uC
         TzNw==
X-Forwarded-Encrypted: i=1; AL+hErEwy1HsgbWRbR7O2A+wQ8WxwmyTJIGFvyArWFgFeoDZyEFLtVqBBDdwEFJ19xuh42ugO+E2GWH/Xnv/iw==@vger.kernel.org
X-Gm-Message-State: APuU4Z88fe1m8/yPwhU8xtPUtw08+plXtZkK7t0TuYjSgJ/bOdGftlRL
	X2v5Sm7CJ3dtBGEZvrM0EJYpD2C4wg8AoOmwEmNnmMflY7F9WW8a3GKFVG55GdUJTDdQ4qrll2T
	xpv9BHpVlVGZ+y6AFBMGPRdfj+4Y5/F0=
X-Gm-Gg: AYBFou0+cqtTtCAVOmcg9KqLG+qRYFBx3GWDMiiSUMMoKWB5imMwjbiGRtKzcbzjtZw
	MqVGI/NRUNxlJhfu0QwZ4GxymDC/6KPFCJSKuDawQQWyOXykt+YowmWEu2e9unlUTK27+Ootj4n
	A7buAKvoFYM39SH0q0SKp4IJBtDNSW/9/4Fia9f8ccMyN/qmMnKiIkUcpkBa9P0EnPit0iA1iIr
	pEQGb6wFM3pZWxvLpBWOTt7MKy78O9afJSLiQYD0BV+MKWf7Wkrv+QDgQS8XlDYggoX3D3Mkrv8
	jDuiOluXz4aNI+eCTcNIotl2l7wBzXUZZok+hnFnYeDcm6GDMeta3GVqVTT5sOPap9gJOOMzg/L
	RKsvIA3o4E87ikAa5dQE0xwWI3l59poxnn6Tk12TN9N3n7/0KKFdXXbTRKT/pjcjc6305qzak4x
	BeqLk+BGBrGx1v59Y=
X-Received: by 2002:a05:6402:241d:b0:6b5:4f5c:cb2 with SMTP id
 4fb4d7f45d1cf-6b722464790mr2827746a12.34.1794234913074; Mon, 09 Nov 2026
 06:35:13 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com> <20261101015551.786044-2-koray.fra@gmail.com>
 <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com>
 <DMP3UBB0QVOT.20HIXK7ZL6K6U@gmail.com> <CAOQ4uxgSVc8n1LbL_dcU-DpNN5BB-ap_vGdXEu7+d0Td7PK5Tw@mail.gmail.com>
 <DMP582BGB7DV.2U0SJLJL7A87K@gmail.com>
In-Reply-To: <DMP582BGB7DV.2U0SJLJL7A87K@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 9 Nov 2026 15:35:01 +0100
X-Gm-Features: AclHuK-FL8zlFzv2gx7YoWgAsxkxAy656VIACQ9wLKYKc-RbZwxWRFIcIAczMqI
Message-ID: <CAOQ4uxj82K4z+2OiY5W1g7NyWAFOFjqqWnZSS3prytW36j1LgA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] vfs: add provenance time (ptime)
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Chris Mason <mason@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-api@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 6:09=E2=80=AFPM koraynilay <koray.fra@gmail.com> wro=
te:
>
> On Sat Nov 7, 2026 at 5:48 PM CET, Amir Goldstein wrote:
> > On Sat, Nov 7, 2026 at 5:04=E2=80=AFPM koraynilay <koray.fra@gmail.com>=
 wrote:
> >>
> >> On Mon Nov 2, 2026 at 3:00 PM CET, Amir Goldstein wrote:
> >> > On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.c=
om> wrote:
> >> >>
> >> >> Add provenance time (ptime), indicating the time when a file or
> >> >> directory was created. This is user-settable via file_setattr() and
> >> >> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
> >> >>
> >> >> The semantics of when to preserve this new timestamp are the same a=
s
> >> >> mtime, the idea being that there is a correspondence like this:
> >> >>
> >> >> ctime <-> btime
> >> >> mtime <-> ptime
> >> >>
> >> >> so every operation (copying, moving, ...) that currently preserves =
mtime
> >> >> should also preserve ptime.
> >> >>
> >> >> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepti=
ng
> >> >> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> >> >> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr=
() to
> >> >> allow ptime to be used with the file_setattr()/file_getattr() sysca=
lls.
> >> >>
> >> >> [ This is a re-implementation of the initial patch[1] by Sean Smith
> >> >>   <defendthedisabled@gmail.com>, following the advice[2] from Darri=
ck J.
> >> >>   Wong <djwong@kernel.org> of using file_setattr() instead of updat=
ing
> >> >>   utimensat() ]
> >> >>
> >> >> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisable=
d@gmail.com
> >> >> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
> >> >>
> >> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> >> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> >> ---
> >> >>  fs/file_attr.c            | 33 +++++++++++++++++++++++++++++++--
> >> >>  fs/stat.c                 |  2 ++
> >> >>  include/linux/fileattr.h  |  5 +++++
> >> >>  include/linux/stat.h      |  1 +
> >> >>  include/uapi/linux/fs.h   |  8 +++++++-
> >> >>  include/uapi/linux/stat.h |  7 ++++++-
> >> >>  6 files changed, 52 insertions(+), 4 deletions(-)
> >> >>
> >> >> diff --git a/fs/file_attr.c b/fs/file_attr.c
> >> >> index 833e03810b24..c0645cb22bf3 100644
> >> >> --- a/fs/file_attr.c
> >> >> +++ b/fs/file_attr.c
> >> >> @@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
> >> >>  static void fileattr_to_file_attr(const struct file_kattr *fa,
> >> >>                                   struct file_attr *fattr)
> >> >>  {
> >> >> -       __u32 mask =3D FS_XFLAGS_MASK;
> >> >> +       __u32 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
> >> >>
> >> >>         memset(fattr, 0, sizeof(struct file_attr));
> >> >>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
> >> >> @@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct =
file_kattr *fa,
> >> >>         fattr->fa_nextents =3D fa->fsx_nextents;
> >> >>         fattr->fa_projid =3D fa->fsx_projid;
> >> >>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
> >> >> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
> >> >> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
> >> >>  }
> >> >>
> >> >>  /**
> >> >> @@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
> >> >>  static int file_attr_to_fileattr(const struct file_attr *fattr,
> >> >>                                  struct file_kattr *fa)
> >> >>  {
> >> >> -       __u64 mask =3D FS_XFLAGS_MASK;
> >> >> +       __u64 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
> >> >
> >> > That is not the correct way to extend this API.
> >> > This fixed mask was added as a placeholder for
> >> > "We intend to add support for more xflags to selective filesystems":
> >> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-2-amir7=
3il@gmail.com/
> >> >
> >> > Please see this POC patch for filesystems to publish their supported
> >> > xflags mask:
> >> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-3-amir7=
3il@gmail.com/
> >>

Re-reading and answering your original questions:

> >> Quick question, should _mask also be used for user-space -> VFS to adv=
ertise
> >> what it wants to change?

Yes absolutely.

> >> This would be useful for on/off flags,

Exactly.

All the Windows filesystems that want ptime, would most likely want the sup=
port
on/off HIDDEN/SYSTEM/ARCHIVE flags as well.

> >> but for ptime both fa->xflags and
> >> fa->xflags_mask would have the same meaning of "I want to change ptime=
,
> >> look at fa->ptime".

There needs to be no FS_XLAG_PTIME in fa->xflags,
just as there is no FS_XFLAG_PROJID in fa->xflags today.

However, since btrfs does not support setting projid, when we introduce
fa->xflags_mask, it would be elegant IMO to introduce the (new) flag
FS_XFLAG_PROJID which would be valid in fa->xflags_mask.

To be clear, currently upstream chattr (e2fsprogs) can set projid via
FS_IOC_FSSETXATTR ioctl (no xflags_mask) and upstream
xfs_io -c chattr (xfsprogs) can set projid via  file_setattr() syscall
(no xflags_mask).

But if either utils were to be modified to support setting ptime, then it
would need to use file_setattr() syscall and set both FS_XLAG_PTIME
and FS_XFLAG_PROJID in  xflags_mask when it wants to set a non-zero
value to those fields.

Specifically, the invocation of chattr -p <projid>, will no longer need to =
do
FS_IOC_FSGETXATTR to read all the unrelated flags for setting the projid.

> >> Should we make _mask the only way to advertise what the user wants to
> >> change,

Yes, unless _mask is zero, which then means set all the legacy values
which are frozen in the constant FS_XFLAGS_MASK.

> >> ignore xflags | PTIME in user-space -> VFS and use it only in FS
> >> -> VFS -> user-space to say "this fs supports PTIME for this file"

Close, but not exactly.

For GET, semantics are clear and follow statx precedents:
xflags_mask always means "supported" (like stx_attributes_mask).

For boolean flags, xflags is the value
For integer fields, an xflags bit means "value provided" (like stx_mask).

For SET, when xflags_mask!=3D0, a flag of 1 means "I want to set this value=
".

For boolean flags, if the flag's bit in xflags_mask is 0, the flag is
left untouched
(e.g. a chattr -p that only sets the project ID doesn't touch IMMUTABLE).

For integer fields, the meaning of xflags_mask 1 and xflags 0 would be
"I want to unset the value" which is not the same as "I want to set the val=
ue
to 0", because as you wrote, 0 is a valid value for ptime.

The question of whether a specific field can be unset or not is up for the
filesystem to decide, not the VFS.

For example, XFS already unset the value of cowextsize when flag
FS_XFLAG_COWEXTSIZE is 0, although the same could be done
with a 0 value to fa_cowextsize.

VFS does enforce that xflags & ~xflags_mask is EINVAL.

> >> (which will be always once support is added to an FS, so it would just
> >> be "this FS supports PTIME")?

It does not have to be an FS-wide property. some fs could have ptime
(or another attribute) support only on some files types.

> >>
> >
> > Sorry I was not able to parse your question.
> >
> > I think the mask should mean "this FS supports PTIME"
> > regardless if the user asked to get/set it or not.
>
> Yeah sorry, I'm just a bit confused because of all the similar names and
> concepts.

Me too... I needed to re-read all the threads from Feb 2025...

>
> (assuming btrfs supports ptime and ext4 doesn't)
>
> * filesystem -> VFS -> user-space, while in fileattr_to_file_attr():
>
>   for btrfs, for all files[1]:
>         fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 1
>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1

Yes.

>
>   for ext4, for all files:
>         fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 0
>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 0

Yes.

>
> * user-space -> VFS -> filesystem, while in file_attr_to_fileattr():
>
>         fattr->fa_xflags & FS_XFLAG_PTIME =3D=3D ignored

This is debatable. IMO it should be 1 for value, 0 to unset existing value,
similar to removexattr() if you want to look at it this way.

>         fattr->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1 if user wants to =
set it, otherwise 0

Yes. but now the user has to set any legacy field it wants to set in
fa_xflags_mask as well, because fa_xflags_mask is no longer zero.
so we need to introduce flag constants for legacy fields that do not
have xflags. I think that is only FS_XFLAG_PROJID.

>
> Would this be correct?
>
> Or would it be better to set FS_XFLAG_PTIME only in fa_xflags_mask, and
> never touch fa_xflags with it, which would make the above become:
>
>
> * filesystem -> VFS -> user-space, while in fileattr_to_file_attr():
>
>   for btrfs, for all files[1]:
>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1
>
>   for ext4, for all files:
>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 0
>
>   (and always fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 0)
>
> * user-space -> VFS -> filesystem, while in file_attr_to_fileattr():
>
>         (fattr->fa_xflags & FS_XFLAG_PTIME =3D=3D ignored)
>         fattr->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1 if user wants to =
set it, otherwise 0
>

I prefer the former.

> This would mean that fa_xflags_mask is used like stx_mask both by the fs
> (to let the user know what it supports (a.k.a. what it's returning)) and
> by the user (to let the fs know what it's trying to set),

This is actually like stx_attributes_mask not stx_mask.

> and fa_xflags
> is used only for ON/OFF flags (like immutable).

Yes, on/off for flag values (like stx_attributes), but "value exists"
for field values (like stx_mask).

>
> Let me know if it's clearer.
>

Same.

Thanks,
Amir.
