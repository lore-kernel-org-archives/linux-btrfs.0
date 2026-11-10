Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794328459;
	b=YhRf5ew2LADMYyNFVPgOf+U9+QKBHjsfHPTqSamtoMcqSOE/YQ6QMAzs5KaWMR72UCA0
	 Z2JLX1K4uhsJEpl+RfcttfKLRvSu6HyXaTNs5YqHd/BuRDQIXR5fLJrvdKfGvd6+Iv+gH
	 w4TYM5BUw4axjHp1QbruIwXYJFaroLMLBmOnMRO4b3WdiGyf1ReXSvGFMjAo+GPfV3C+f
	 ry+eLVrIYZFv71h+HQJgytf1K5XwL3OswDypDXotNPwwSJKajU7jr6tXpKwN20p1nrP+C
	 iM4SqNtCsEaZ1DI7kmYxTin3ApqlAmadxVMoSPbobWHoI4NsFWIk9hIflDsoMEQbUKg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794328459;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FCqtSOwcpdw7XGftmO+xNjW4rRCfyh1m1PM9yVjmyCk=;
	b=gUn4ZRteqvY87/ryJ9z13BZEnv50Jx3qccMpfhBuTqN5GVLI34vBXs75cBU/Qq6c0KKV
	 cfaf4DD0ol3+OJWDcMQ6142opuuXHc/QFD5E2jVymZV1n2oAdFYztKyICJsh1zMoz1T0l
	 xNlffg+on2LQDTJqE7eq2F+UiIdDuRFAwGBwS5cGTe1cDOscdRJBncxQlV3u0EnR2Bg2a
	 eNm1daBprDJZt+nnVcaHd4tQEpc9RbD1b8NLIGlev6Ihwv1U3a1kJCgmBmJo9j5wJ8dM2
	 u+LHAgASoT59xyesevHLPeSvaN43rNM10O/abUZ65TA4hrjiw2si5Rodmz8f2LqKKJg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HENuZjV5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB42E606E806
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 16:34:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB42E606E806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HENuZjV5
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b6e7a05225so3003447a12.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 08:34:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794328457; cv=none;
        d=google.com; s=arc-20260327;
        b=HXvVfL8PPS0WYmzBG/bHixmbeQ+ZOLRwRYh3a1AdV3aCftbLYkMWy+mQie3XloO2Ct
         ErxZP8oPGPWgHfIo5nvSoO70xYS4BDLTdvHFsDeNfyXpmhbSux34Pv0XghSe8xy+dtPv
         Ul6iUul+sGcAOj6yxEjcwuMNxBVUsHTtPZA5BCx1domDwcJIyc/UOfBm5eD12HcN+Q9N
         otf7s00ASp0Zkls/VdNgdhQ8Jf6cwyudoa5Wel4lGElq8xETFbrLm6pyf7RidKqhp2Wo
         XE5Be8TOzA2k34qn1FKizjchV0snl4RnCiggdNVLHMQ2AcclunEcDc7zi0Pr+qnFzv9a
         ILYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FCqtSOwcpdw7XGftmO+xNjW4rRCfyh1m1PM9yVjmyCk=;
        fh=06J3Mql2yarHBDMq6vxOfT3VUpeZjNwFOIvgM95Amh8=;
        b=MGnCj3Y900/V42RFpGMqTzFp/0FBipqxLwdJyhlHzUnzYIQrUbvlHEgcuicMSe9EoW
         4BPN+lMnA3l8ddZCFeY7+gzXA6D4fH02VWftvtC7Hb+1aynUcDGFCg/zLwGnlXm6EGio
         VprdBLJ/0dY1IFiKMB4x8wFp0W+U/qAiwkUq9maAPAL3gPnpJ24tf10WvHG++Vvt1346
         Hmk2xPPz/4X/q7OkF5bf3ggskE7IWFoPMV0aHaNIQRQZUmVF2vzbX8K6EDhr7SgUgFJa
         TzIZk3nDGB8vfMYgAIDrtcsrzrIMHAQU0TdQVaUdHdG4rdHHXHZt/87VFXGLSyKMt+/p
         Ca5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794328457; x=1794933257; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FCqtSOwcpdw7XGftmO+xNjW4rRCfyh1m1PM9yVjmyCk=;
        b=HENuZjV5rYYXZstMPqNfOr/X7CsuMdpnIU4RVF5ddOZ9GH1YRVnsluNbXiXZJZTqW/
         X4R/n8mC0J9sa8adkM81EYNL176fgatokAH7XGexfoEI9+zHL4d8IjEf7HpjMxXeTuTC
         emLokdvJolq8nzFi0hmqOGQ1Ex1R7rGgaTyyjXInnHSpFfH1NEABiJniDq6yFEIpJ8+9
         eXpzLD43lkTAgWGvlnWNbl+4p29ZIWrzzOvpnurje76vGUd/gz30APzNfRvXchaW7gJp
         69o1yOV3I/+15wqjWcqlUIBrsMRjQ6JkuNM9N2LVFkcvDNaxHWfbkPdIdlTNo3SQWRcg
         LUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794328457; x=1794933257;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FCqtSOwcpdw7XGftmO+xNjW4rRCfyh1m1PM9yVjmyCk=;
        b=U/BEf/DbtA2CwMRvih3onUgvnSMA8WsnWMAt5STYgXly2uNSpfuGY+NOznPONuOQc5
         elwwjzkmzBV12gft+iOHBcXsGppuWbIBcSNRwLWuKoe5Ms4gK0pZCpw9goyFr5KdANuM
         HfTUm/2UW/FWMrZ96UoHFMVnBp1+d1LPQOBcTjAeIZS0BY5XjB/c0aKD6zSISATqyxKy
         JYdNB7w+GtjyhXrF0MKZzhYo9hF8DjXen3MxDda40R+Dp39BiYGivBwDyK23mg/fkOSs
         Q64J7zSXLOiVL8NUoQGe1rgTFxN8tksglSLbsMo+cQL92muBsnU/ep9pwz1D8fKed7AD
         WWxA==
X-Forwarded-Encrypted: i=1; AL+hErGaQpImu4/qngdNcB+Vne953R/HQb+EVze4tJFWpe6z5W5VArSJYh+JAdseB09LY1OxK9CAnDoIgHy8jw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9SVji079Vcl1L9ldcNgslNRMMMqvPUz0v74yrIwMc6L5j7jg7k
	qZYxGvgfe/LBfoUxhKmkC8Ttevb7LP/eAlnS5XOIUdubw8NUwOskZGX2qwYJjXE6Hhju6DoAbar
	l0aViObcdjY02G+2PCD4XC0mVeFrjoBQ=
X-Gm-Gg: AYBFou2CTQLc0LSNw/doFFjrvazykATI5+VQP2cOjhRlG3NIfLfzz8JXAONye11tnqv
	Qf+HF7WVijAWnWm6TfQND74G35xSjQW7mxwf8cgwE13JbWCjwyszRtP+XQN2mYztA1krqn7FEsv
	0KdN7vsflOrNolaUiuqt3QcJ5fz56uN3FzEd9gtTcufFiZwJuHQTIqB9e3fo76556tPMZsIzx2J
	YfDZJ13fZJEL+u95VIWz2lQgpRPdIAG0GJbSS7qvBlN3zu9/nAiEQIccFAcLC6UCarLWFaPiZ8K
	HU0onAch8rALJ2hekrbbk/8TzLLvAc0BiUmhOYX+VafSGJVUi/h04WPJW/T5k5vJxikE9KVmTxW
	A7axqyElDDPIWzkQxaS/Vjk0Fw0La9ZhqCOIOMc2JBYc3QHJA9Q80lgCF//3xzrsxyA7MaA==
X-Received: by 2002:a05:6402:2712:b0:6b4:d1ed:95b3 with SMTP id
 4fb4d7f45d1cf-6b756afb7e8mr2798959a12.41.1794328456887; Tue, 10 Nov 2026
 08:34:16 -0800 (PST)
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
 <DMP582BGB7DV.2U0SJLJL7A87K@gmail.com> <CAOQ4uxj82K4z+2OiY5W1g7NyWAFOFjqqWnZSS3prytW36j1LgA@mail.gmail.com>
 <DMR1E7XB3AT6.3UI3YHHBI8O9Z@gmail.com>
In-Reply-To: <DMR1E7XB3AT6.3UI3YHHBI8O9Z@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Nov 2026 17:34:05 +0100
X-Gm-Features: AclHuK-xyrva0BFNfHdHgo1AdOKFc2mT705XNAyB3cFbLIaGNogkhAlZUjgESj0
Message-ID: <CAOQ4uxjtuTDT63vJdYaq+RHQEQFLTksp66e46OMN99WhJz3SbA@mail.gmail.com>
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

On Mon, Nov 9, 2026 at 11:34=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
...
> >
> > Re-reading and answering your original questions:
> >
> >> >> Quick question, should _mask also be used for user-space -> VFS to =
advertise
> >> >> what it wants to change?
> >
> > Yes absolutely.
> >
> >> >> This would be useful for on/off flags,
> >
> > Exactly.
> >
> > All the Windows filesystems that want ptime, would most likely want the=
 support
> > on/off HIDDEN/SYSTEM/ARCHIVE flags as well.
>
> (But these should be deferred to other patches/to the FSs themselves
> right?)
>

Right.
For the design discussion of xflags_mask I had to give those as an example.

> >> >> but for ptime both fa->xflags and
> >> >> fa->xflags_mask would have the same meaning of "I want to change pt=
ime,
> >> >> look at fa->ptime".
> >
> > There needs to be no FS_XLAG_PTIME in fa->xflags,
> > just as there is no FS_XFLAG_PROJID in fa->xflags today.
> >
> > However, since btrfs does not support setting projid, when we introduce
> > fa->xflags_mask, it would be elegant IMO to introduce the (new) flag
> > FS_XFLAG_PROJID which would be valid in fa->xflags_mask.
> >
> > To be clear, currently upstream chattr (e2fsprogs) can set projid via
> > FS_IOC_FSSETXATTR ioctl (no xflags_mask) and upstream
> > xfs_io -c chattr (xfsprogs) can set projid via  file_setattr() syscall
> > (no xflags_mask).
> >
> > But if either utils were to be modified to support setting ptime, then =
it
> > would need to use file_setattr() syscall and set both FS_XLAG_PTIME
> > and FS_XFLAG_PROJID in  xflags_mask when it wants to set a non-zero
> > value to those fields.
> >
> > Specifically, the invocation of chattr -p <projid>, will no longer need=
 to do
> > FS_IOC_FSGETXATTR to read all the unrelated flags for setting the proji=
d.
>
> Ah yes, this would be a good change I think.
>
> >> >> Should we make _mask the only way to advertise what the user wants =
to
> >> >> change,
> >
> > Yes, unless _mask is zero, which then means set all the legacy values
> > which are frozen in the constant FS_XFLAGS_MASK.
> >
> >> >> ignore xflags | PTIME in user-space -> VFS and use it only in FS
> >> >> -> VFS -> user-space to say "this fs supports PTIME for this file"
> >
> > Close, but not exactly.
> >
> > For GET, semantics are clear and follow statx precedents:
> > xflags_mask always means "supported" (like stx_attributes_mask).
> >
> > For boolean flags, xflags is the value
> > For integer fields, an xflags bit means "value provided" (like stx_mask=
).
> >
> > For SET, when xflags_mask!=3D0, a flag of 1 means "I want to set this v=
alue".
> >
> > For boolean flags, if the flag's bit in xflags_mask is 0, the flag is
> > left untouched
> > (e.g. a chattr -p that only sets the project ID doesn't touch IMMUTABLE=
).
> >
> > For integer fields, the meaning of xflags_mask 1 and xflags 0 would be
> > "I want to unset the value" which is not the same as "I want to set the=
 value
> > to 0", because as you wrote, 0 is a valid value for ptime.
> >
> > The question of whether a specific field can be unset or not is up for =
the
> > filesystem to decide, not the VFS.
> >
> > For example, XFS already unset the value of cowextsize when flag
> > FS_XFLAG_COWEXTSIZE is 0, although the same could be done
> > with a 0 value to fa_cowextsize.
> >
> > VFS does enforce that xflags & ~xflags_mask is EINVAL.
> >
> >> >> (which will be always once support is added to an FS, so it would j=
ust
> >> >> be "this FS supports PTIME")?
> >
> > It does not have to be an FS-wide property. some fs could have ptime
> > (or another attribute) support only on some files types.
>
> Right.
>
> >> >>
> >> >
> >> > Sorry I was not able to parse your question.
> >> >
> >> > I think the mask should mean "this FS supports PTIME"
> >> > regardless if the user asked to get/set it or not.
> >>
> >> Yeah sorry, I'm just a bit confused because of all the similar names a=
nd
> >> concepts.
> >
> > Me too... I needed to re-read all the threads from Feb 2025...
>
> I also had to go back to those threads, since at least those have more
> parsable function names ahah.
>
> >>
> >> (assuming btrfs supports ptime and ext4 doesn't)
> >>
> >> * filesystem -> VFS -> user-space, while in fileattr_to_file_attr():
> >>
> >>   for btrfs, for all files[1]:
> >>         fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 1
> >>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1
> >
> > Yes.
> >
> >>
> >>   for ext4, for all files:
> >>         fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 0
> >>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 0
> >
> > Yes.
> >
> >>
> >> * user-space -> VFS -> filesystem, while in file_attr_to_fileattr():
> >>
> >>         fattr->fa_xflags & FS_XFLAG_PTIME =3D=3D ignored
> >
> > This is debatable. IMO it should be 1 for value, 0 to unset existing va=
lue,
> > similar to removexattr() if you want to look at it this way.
>
> So in the case of ptime, fattr->fa_xflags & FS_XFLAG_PTIME should be
> ignored, while for fattr->fa_xflags & FS_XFLAG_SOME_NEW_THING it will
> need to be handled as
>
> =3D=3D 1: set it taking the value from ->some_new_thing
> =3D=3D 0: unset the value
>

The API generally allows this interpretation for some_new_thing.

It is either up to individual fs to say if they support the unset
combination, or
if you decide that it could never make sense to unset PTIME for
any filesystem, you could enforce this in the vfs helpers.

But I don't think it is wise to ignore fattr->fa_xflags & FS_XFLAG_PTIME
and I think there is no particular reason to allow the combination
!(fattr->fa_xflags & FS_XFLAG_PTIME) && attr->fa_ptime !=3D 0
so I think that vfs should enforce at least that.

> >>         fattr->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1 if user wants =
to set it, otherwise 0
> >
> > Yes. but now the user has to set any legacy field it wants to set in
> > fa_xflags_mask as well, because fa_xflags_mask is no longer zero.
> > so we need to introduce flag constants for legacy fields that do not
> > have xflags. I think that is only FS_XFLAG_PROJID.
>
> Should this be a patch in this series, or a separate patch sent after?
>

IMO it should.
You can take my POC patch for xflags_mask and include the
FS_XFLAG_PROJID there and the reasoning is conforming to
the other fields that are always set with some xflag.

vfs already does this:

        /* Extent size hints of zero turn off the flags. */
        if (fa->fsx_extsize =3D=3D 0)
                fa->fsx_xflags &=3D ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHE=
RIT);
        if (fa->fsx_cowextsize =3D=3D 0)
                fa->fsx_xflags &=3D ~FS_XFLAG_COWEXTSIZE;

With non-zero xflags_mask it could also reject non-zero field value
with unset xflag, because filesystems are not expected to return
this in file_getattr() and so there is no reason for chattr tools to
do that.

> >>
> >> Would this be correct?
> >>
> >> Or would it be better to set FS_XFLAG_PTIME only in fa_xflags_mask, an=
d
> >> never touch fa_xflags with it, which would make the above become:
> >>
> >>
> >> * filesystem -> VFS -> user-space, while in fileattr_to_file_attr():
> >>
> >>   for btrfs, for all files[1]:
> >>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1
> >>
> >>   for ext4, for all files:
> >>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 0
> >>
> >>   (and always fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 0)
> >>
> >> * user-space -> VFS -> filesystem, while in file_attr_to_fileattr():
> >>
> >>         (fattr->fa_xflags & FS_XFLAG_PTIME =3D=3D ignored)
> >>         fattr->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1 if user wants =
to set it, otherwise 0
> >>
> >
> > I prefer the former.
> >
> >> This would mean that fa_xflags_mask is used like stx_mask both by the =
fs
> >> (to let the user know what it supports (a.k.a. what it's returning)) a=
nd
> >> by the user (to let the fs know what it's trying to set),
> >
> > This is actually like stx_attributes_mask not stx_mask.
>
> Ah ok.
>
> >> and fa_xflags
> >> is used only for ON/OFF flags (like immutable).
> >
> > Yes, on/off for flag values (like stx_attributes), but "value exists"
> > for field values (like stx_mask).
> >
> >>
> >> Let me know if it's clearer.
> >>
> >
> > Same.
>
> Yes, I think I get it know.
>
> So, just to recap:
>
> fa->xflags_mask =3D=3D 0 -> legacy behaviour before this series
>

Yes.

>
> fa->xflags_mask & FS_XFLAG_ABCD =3D=3D 1 -> "user wants to set/change abc=
d"

Yes.

> fa->xflags & FS_XFLAG_ABCD =3D=3D 1 -> "user wants kernel to take the val=
ue from fa->abcd"

Yes.

> fa->xflags & FS_XFLAG_ABCD =3D=3D 0 -> "user wants kernel to unset abcd"

Yes.

>
> fa->xflags_mask & FS_XFLAG_ABCD =3D=3D 0 -> "don't touch abcd"

Yes.

And reject in vfs combinations that do not make sense.

>
>
> and in the case of ptime this means:
>
>
> fa->xflags_mask & FS_XFLAG_PTIME =3D=3D 1 -> "user wants to set/change pt=
ime"
> fa->xflags & FS_XFLAG_PTIME =3D=3D 0/1 -> "user wants kernel to take the =
value from fa->ptime" [1]

I say require 1 because why not.

>
> fa->xflags_mask & FS_XFLAG_PTIME =3D=3D 0 -> "don't touch ptime"
>
>
> Correct?

Yes. as far as I can tell and with disclaimer that this is my own
view of how the API should look like.

>
> Thanks,
> koraynilay
>
> [1]: so basically ignored, it doesn't matter if the user sets xflags | PT=
IME
> or not, but still recommended in documentation. Tho thinking more about
> it, maybe it would be better to enforce it at the fs level with
> -EOPNOTSUPP.

Exactly, either per-fs or vfs level.
And -EINVAL is more appropriate for this IMO,
but that is a never ending debate between those two errors.

Thanks,
Amir.
