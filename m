Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795190156;
	b=wu9tmBfCD0KImUoLagdbPfAXG7uhuGEyxeGdWmTK5wToSzVOwnQ19hSUQL+W2/NVBJbl
	 vo/ctLySO9C+KaBQ/PMhTtDCC2xwigAPnYX5hwVjESGwi4j+bJr6RQEmZH1nI95Wol4xK
	 WP+vGaXi34MlrPfwgeDifRPO3JqFcNgvfygcWMuH/xOphWrAdsrb0pPFxBLg58eWYyc0k
	 GkGebSXrvPlX8e1ijgh3kbSfeZBiqyrwwv68C5dDEtOWUd2c1j6C60cY++h5/bSGEt1n3
	 kaJilCfZIIDQXYvmswXfGhCbrWTnvHLKbASXMBcHv8mxqEm+Gbfqq8mZ04IXxY2dwHg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190156;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=sKN0WqYQTyAXEuN5uWRqYydRHORdhfTbdGPGVmgWZ74=;
	b=aSdC2zO7R+hnQIYGxt1yRCb67I/4yeURUS4KFP1iKbwaYnRFaD92dm3LzXtAHsA0ipp6
	 Y1ZbQWFggQUusk9LFm9XLAcsmMrK+0zlC8KZJZqBLzfpAfhjgoz/nCrlkhwEVgwZfzWX5
	 RtQu4ZVEGY1SfUN4dXYCXYo+RUPGyXqjyFLAa9EyumFicIZCathTboJCGuexc8e2mcatb
	 HU8axEvSt5v6MCsh4LgrYuA0Iptn5GKEU3glFQDGGdS3Kjv1u9beSX2lh6xXfBMBauJnF
	 97qDmnrYiKRBCOky4fjzTNGvZs3UhmXTaisWaiT4UvLCDa4Gt6GkALz2Qcyw1sDoMtQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZNI+Voqp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE1F606C882
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 15:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FE1F606C882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZNI+Voqp
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so1852623a12.0
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 07:55:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795190155; cv=none;
        d=google.com; s=arc-20260327;
        b=gohOvJhU4ZfdUaHThasUqLUmaNc6Ve1//SnodjkywzvNAQjVExj1qM0O1/NwKYP1Z5
         Ua63qlZwgQ9O8Rl0anzSJvfIlKF/G87FArKUFoZ8nEWepUtytZoCy50A26dwGhsqBXGn
         SJ4LF5x0qy8Z1ERy3kkpGlR9hycjIQ3cSkAMj0p7dwAGCgbqaTRGyahNSLp2sYNy9YuP
         lBt1kOgfCwOiceubwRG3323SLhg3iP6O8vIdrMAbEX9dqMmAWyhJ5ECUgwEYndrdHviT
         dFJH8h0HwOBVjGAJYa6uHNi4O6lDJwvS17ETsKpNGCwVIwk8lsJD489HlcMCFSi3oV2B
         TgNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sKN0WqYQTyAXEuN5uWRqYydRHORdhfTbdGPGVmgWZ74=;
        fh=qUAwXe5R3LHDSOaJKQ9NKEwIY83ey6tNRxvWqHXz97k=;
        b=Zps/x3TsqsLV2ga2SgofQzCLFedk6StF0l5xp9bBMIcJXtFdvXdTeSgiRFffppFFIe
         pdvnuTQzbKhnaWdlXDXSmX88s76hKe1H2Dvc7dJOA2+EzrJq32Nxc4Dg8VCSnP5l2r/e
         dL0xsjcSHZytOmCY8e7HG27c+BcDAIsPsY38yoXpVZbvlqfxIpY//MpdOtCUhlg5xN/v
         X+FMJzA+bFfEzb/q94FtI+oXe8yWgW7E5sVak5Pp97eAn3c+vj6yxFlQuAm5rgPWV5m5
         2dTDwnF9gbBHYzcPfDtvfAEw+0hOKtR9nuDErmKOrPKu6IDDMOhILf24gPUsyGMK4eVh
         M7rg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795190155; x=1795794955; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sKN0WqYQTyAXEuN5uWRqYydRHORdhfTbdGPGVmgWZ74=;
        b=ZNI+Voqp8joIQNd2/S11wM6N7/ik5CmAYrFMVM+Yezub5AkrTn1W1ItJezV7UbbAF1
         5qTQfLyNRLQFmS0PqIsUOEfiN3mYBul5KsnIdNx5wI0SCbycars+m1azTZjYLu+DKlmo
         Hu6or5Lgq+6NY9K06NcSL4fiU0xWdN3OjQWZOJU028iCUeNevcp8LSNvbtsBZ7JPfHVj
         IkgHTK2wMJRpRfwaNuD0mIWFr2ZG2tjV2DUx6xxHn2cczUQNiFHkwb9qKdElOtzJkptp
         TGA+t+9OLus+S3udC+294Te6jQ0G8YMIu5iVcDCoz7Y4srkrRJ2MGUSTOds8OnFUqK11
         SOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795190155; x=1795794955;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sKN0WqYQTyAXEuN5uWRqYydRHORdhfTbdGPGVmgWZ74=;
        b=R+cneYL7izO66sSAl6Gcn8adAzR0i95rnO7qwG18rxoBlA4+jSAvpK6G61Zte083GR
         v9UeaV17WLZ/cjM3LOz7RcSSfcq5Otsy4F7S0TEdw1c4nWu76//udJhSO8CPca6lmXmD
         6k6NskZQ3igBHtjEpqNA8m3z5FXklCNVxyPyn0WG2O/2j81PIsIuKR3jSPWFYOIkj7Ey
         j/HFiAT9GTcNiDC/SwDtJy9GaR7M7bnoXsSoIPuRXAWqVAeGDrkDLsRW0K6oqRgFEzNO
         OTGEQCp5NVYJHkjNO2k7md3XoyoMNkABrR8uR69oa196H+/NipxAfHCG45ni7OXV5YWt
         bIQQ==
X-Forwarded-Encrypted: i=1; AL+hErFaB2mdmAQk5J25S+44GJDrJC5943IYNnz4oDVS6f3HbjefGwOieoqV/1aASOf9AORMpX6GA4ljhQI3HA==@vger.kernel.org
X-Gm-Message-State: APuU4Z9HpJ/xn9E0mtjGv5b5OZWSOeTdBaPjRjBuY1kGFqSmI83KKSYU
	Qup8Yjp77MUkeXYqH0OInV6bs138fir1qFOWo1dlAlb5f0ndiFnUfLArdDhBMICz8IUaYj89YBF
	OzL/jea8X0MvF7HcYwsYILK3sgmdW4YM=
X-Gm-Gg: AZFdTZdYzz7mokDaLH3gILagH/T/OL/7NRrYxAXDyiohsl7BPXdL9FwWp3hWHqXrmUc
	ls98gBQd4yuvdP+nkICV2yBsqSZqcccEY2aOrGvQSyiXIffEjbXpb2R0g9z4diaGBV7l+n0KXTA
	A1H1bdVRI8L3DyqZjX6a/EkNfA3jx4YIcvg5vGlC7xv2Naq+yZxrwUWM2BpOgHSU/EU0dQ12oGV
	++WrpTf5n5eJTF9dnanHetceo8w7X4i1oMjQ6oLQOAwi2glnoEWXRwgGSohcvcGiYxCtXbrMd8j
	sBLSGY/SGJTj+39cDvG4GFaXxJpI4pJyQP/NyBaPgGRCqK5DtoD+StdFFpwe+ByVawxohQ2Q+qJ
	LFj0ybGOfJbaZbfEO2glME+P7x4sI6KzFrGx6Pum7xTvd7XKYXL2la/fOvs1M/BLajYgjTA==
X-Received: by 2002:a05:6402:448e:b0:6b8:7769:ffea with SMTP id
 4fb4d7f45d1cf-6ba37ece3efmr2700126a12.45.1795190154705; Fri, 20 Nov 2026
 07:55:54 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-11-koray.fra@gmail.com>
 <CAOQ4uxg2gpC99ohuvKm-SgPzuffJy1fSvXorbuBnYZ=OFSxT3w@mail.gmail.com>
 <DMZIZ05H7MMB.1WYNR4X44BPGR@gmail.com> <CAOQ4uxg8aVcWyNiFDk8djdn-M3xJcu_7-kRxVq9jjFsbcGp1ew@mail.gmail.com>
 <DN03GJ80ZWNZ.9GM35HM4T48N@gmail.com>
In-Reply-To: <DN03GJ80ZWNZ.9GM35HM4T48N@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 16:55:42 +0100
X-Gm-Features: Aa3M54qwBZfUZmZq7N4IJA8RoZGlQgYi2IqZuG6tNGKYRI28yA1oVD8H7wW_Hfk
Message-ID: <CAOQ4uxiEX1wO3vRM2UMNrACR8AfxDbrP=oB9w6L-B-twmD3D4g@mail.gmail.com>
Subject: Re: [RFC PATCH v4 10/10] cifs: add provenance time (ptime) and map it
 to SMB's CreationTime
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
	linux-api@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 3:05=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> > To reduce the scope of your patch set this may be better.
> >
> >> >>
> >> >> -       /*
> >> >> -        * chattr writes back all flags returned by fileattr_get().=
 Accept
> >> >> -        * FS_CASEFOLD_FL only when it reflects the share's casefol=
d state.
> >> >> -        */
> >> >> -       if (fa->flags & FS_CASEFOLD_FL) {
> >> >> -               rc =3D cifs_fileattr_get(dentry, &current_fa);
> >> >> -               if (rc)
> >> >> -                       return rc;
> >> >> -               if (current_fa.flags & FS_CASEFOLD_FL)
> >> >> -                       allowed |=3D FS_CASEFOLD_FL;
> >> >> -       }
> >> >> -       if (fa->flags & ~allowed)
> >> >> +       if (fa->fsx_xflags_mask & ~CIFS_SUPPORTED_XFLAGS)
> >> >>                 return -EOPNOTSUPP;
> >> >>
> >> >> -       enable_compression =3D fa->flags & FS_COMPR_FL;
> >> >> -       compression_state =3D enable_compression ? COMPRESSION_FORM=
AT_DEFAULT :
> >> >> -                                                COMPRESSION_FORMAT=
_NONE;
> >> >> +       if (fa->flags_valid) {
> >> >> +               /*
> >> >> +                * chattr writes back all flags returned by fileatt=
r_get(). Accept
> >> >> +                * FS_CASEFOLD_FL only when it reflects the share's=
 casefold state.
> >> >> +                */
> >> >> +               if (fa->flags & FS_CASEFOLD_FL) {
> >> >> +                       rc =3D cifs_fileattr_get(dentry, &current_f=
a);
> >> >> +                       if (rc)
> >> >> +                               return rc;
> >> >> +                       if (current_fa.flags & FS_CASEFOLD_FL)
> >> >> +                               allowed |=3D FS_CASEFOLD_FL;
> >> >> +               }
> >> >> +               if (fa->flags & ~allowed)
> >> >> +                       return -EOPNOTSUPP;
> >> >
> >> > This whole mess could be sorted out by switching the cifs
> >> > implementation to the new API
> >>
> >> ("new API" you mean _mask right?)
> >>
> >
> > Yes and ro_mask, but it probably also means converting all the
> > read-only CASEFOLD fs to new api, so that FS_XFLAG_CASEFOLD
> > could be taken out of FS_XFLAG_RDONLY_MASK
>
> Can all flags currently in FS_XFLAG_RDONLY_MASK be rw for some
> filesystems or only some?

No. CASEFOLD is the only one which is MODIFIABLE/SETTABLE
in the old setflags ioctl.

Its twin xflag FS_XFLAG_CASEFOLD was recently added along with
FS_XFLAG_CASENONPRESERVING for a bunch of fs (e.g. nfs) which
advertise it as rdonly attribute.

> Should they all be removed from FS_XFLAG_RDONLY_MASK and left to each
> filesystem to define them as ro (to put in _ro_mask)?
>

No need to do this.

One flag at a time per demand.

You *need* to get FS_XFLAG_CASEFOLD out when some
fs will want to set it via xflags API.

You *may* get a flag out of FS_XFLAG_RDONLY_MASK
only after *all* of the fs which support it have been converted
to the new xflags_*_mask api.

> >> > and implementing a generic vfs
> >> > helper which does something like the above code to handle the
> >> > old ioctls.
> >> > FS_XFLAG_CASEFOLD would then be removed from
> >> > FS_XFLAG_RDONLY_MASK and set explicitly in xflags_ro_mask
> >> > by fs which don't allow to set if (e.g. nfs) and added to
> >> > FS_COMMON_FL/FS_XFLAG_COMMON
> >> >
> >> > cifs would advertise FS_XFLAG_CASEFOLD in its ro_mask
> >> > and then the generic helper would mask it and the new syscall
> >> > will not allow it.
> >> >
> >> >> +       }
> >> >> [...]
> >> >> +               cifs_dbg(FYI, "set compress flag rc %d\n", rc);
> >> >
> >> > I think that the roadmap should be to slowly define all the old FS_*=
_FL
> >> > flags as FS_XFLAGS_* and let the generic helpers deal with the conve=
rsion.
> >>
> >> > But it is not so hard to convert one filesystem at a time in a way t=
hat
> >> > fa->fsx_valid will have to be true, because, for example, here
> >> > all the relevant flags would be supported by the new xflags API.
> >>
> >> So, something like what fileattr_fill_{x,}flags() do now, but for
> >> file_attr_to_fileattr()?
> >>
> >
> > Yes, something like this (maybe)
> >
> >  void fileattr_fill_flags(struct file_kattr *fa, u32 flags)
> >  {
> >         fa->flags_valid =3D true;
> > +       fa->fsx_valid =3D !(flags & ~FS_COMMON_FL);
> > +       fa->fsx_xflags_mask =3D FS_XFLAG_COMMON;
> >         fa->flags =3D flags;
>
> So, for the filesystems that switch to the new API, these new/changed
> helpers should handle giving userspace the legacy FS_*_FL flags (if
> userspace uses FS_IOC_GETFLAGS) by converting them from the FS_XFLAG_*
> reported by the filesystem?
>

I did not look at the implementation details but when you make the
vfs API rich enough with the masks, the should be no problem to
describe in the API what the old ioctls do
"get a subset of attributes"
"set a subset of attributes"

Where "subset" differs depending on the ioctl.

> But did you write this
> > +       fa->fsx_valid =3D !(flags & ~FS_COMMON_FL);
> > +       fa->fsx_xflags_mask =3D FS_XFLAG_COMMON;
> while thinking about FS_IOC_SETFLAGS, so from userspace to filesystem,
> and this would be needed because that filesystem wouldn't know what
> FS_*_FL are, so it will use the _mask and the converted xflags?
>
> But why the opposite of (flags & ~FS_COMMON_FL) as fsx_valid?
>
> Why fsx_valid =3D 0 if the passed flags also contain non-FS_COMMON_FL
> flags and fsx_valid =3D 1 if the passed flags contain only FS_COMMON_FL
> flags?
> (if I understood correctly)
>

My interpretation of fsx_valid (for the set side) is:
fs may completely ignore ->flags and get all the information from fsx_*
similarly for flags_valid fs does not need to look at fsx_*

In the case that all requested flags are common, both
fsx_valid and flags_valid can be true.

But what I wrote is nonsense, because the old ioctls have no request_mask
so unset flag does not mean it is not being set.

I think what is needed is something like this helper to be called from
filesystems:

bool fileattr_prepare_xflags(struct file_kattr *fa, u32 xflags, u32 support=
ed)
{
        if (fa->flags_valid) {
                fa->fsx_valid =3D !(fa->flags & supported & ~FS_COMMON_FL);
                fa->fsx_xflags_mask =3D supported & FS_XFLAG_COMMON;
        }
        return fa->fsx_valid;
}

Then cifs_fileattr_set() starts with:

        if (!fileattr_prepare_xflags(fa, CIFS_SUPPORTED_XFLAGS))
                return -EOPNOTSUPP;

And from here on, talk only xflags and xflags_*mask

For cifs that means to add vfs support for FS_XFLAG_COMPR
<-> FS_COMR_FL conversion in helpers.

FS_COMR_FL is also rdonly flag in some fs and rw in others.

> > But in this model FS_XFLAG_COMMON are only the ones that
> > are mutable from the old ioctl.
> >
> > We would need to define FS_READONLY_FL to deal with the
> > group of read-only legacy flags, if some fs needs them and wants
> > to use the new API.
>
> So the those filesystems can put it in _ro_mask on GET you mean?
>

Actually, I meant that the old setflags ioctls could be translates to the
new xflags_mask dialect, for example:

bool fileattr_prepare_xflags(struct file_kattr *fa, u32 xflags, u32 support=
ed)
{
        if (fa->flags_valid) {
                fa->fsx_valid =3D !(fa->flags & supported & ~FS_COMMON_FL);
                fa->fsx_xflags_rw_mask =3D supported & FS_XFLAG_COMMON &
                                                          ~FS_XFLAG_RDONLY_=
MASK;
                fa->fsx_xflags_ro_mask =3D supported & FS_XFLAG_COMMON &
                                                          FS_XFLAG_RDONLY_M=
ASK;
        }
        return fa->fsx_valid;
}

so it will work correctly for example with fs/ntfs which supports
readonly ENCRYPT|COMPR

Thanks,
Amir.
