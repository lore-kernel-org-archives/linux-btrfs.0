Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC41332EBD
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 08:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775030998; cv=pass; b=gOBbv1hcJl4dJOv0O7jmV+Q9EsLdKKBTCPH7kQgzelHewOo6gpMFQfQJcM93aOIoolobDSQ4DrNJhDQhWlJtVQNIUCFNoMvSSfP3DYolTgg9Llq1SFf6QgRGJmjjdu8i39MR1MEYjgmexE2TB7FWsD/YWj/McCp/vz7CWdwE2kc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775030998; c=relaxed/simple;
	bh=jzUrClyX8cx2Dl1XB0LjoIRE3MInfsdiP6asEc2NveM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vEZ0kJGpf0/Y7PTAXEonne+p3LgQh1+CTeaOsSoFDwobL0cKlf4mzJHZLYizQFxntfUhaR81bjFDOgKyxpYSKEMx3t6b8827CCFNiW8Qn0R2Q2IWWp2fM5+8AeMaqQhVeRVLkVVNEctzupjj3St+zd7R1U04E5AwDfhJ/QHQ8oc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YWNBL9Sk; arc=pass smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YWNBL9Sk"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6501e465a8eso1094285d50.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 01:09:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775030996; cv=none;
        d=google.com; s=arc-20240605;
        b=J82YXO3n1lqIAnSPsvoreFsKG+xGX0lm1BentCcsJYTnCwzTOVihd8cyfCHzpvgjd/
         beohDqlbJaifty3kaTtzoxizR2fVpYF2PP8mGlK0u3uxxYmuP0fqnQulFTE2pgnRudMH
         ZXVZxJZOM7JBX37bLUsWF/z4eSwO0H27/vLTVQigt9K1VudcdHjRyODQewBVEs7ISP5e
         eGcO3Mm07PDq1QI/jMdIMPK2QaEiQrdGsGKPFRWRHN2ZW3A8iwxKXslyi1gdfMJp73++
         nhnAK8dCVIWhC56r7EAH5GAtshhcZnr8IrnGciU/OIzDbWQysGxGSMnCIxAwWS2GRa54
         2jhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QGJ43lTmGm7tqVbmRpoI+e40OCefs4+iqftR/DXmG04=;
        fh=UBMnu7uZ+2T2IOAOf5Bu+tWR3cwt8VwsDzQCEV7+duY=;
        b=B5+ASJbS4m50KicYs83ekEP3FQFRt4umzUH7nLV2TIJJpeJ9tZXFq9wiz7XOIMF2g5
         Cp0AC3wMOMQnfIDKSyKkYC/ypSvWVR4aMUjnOFOqgZtLGO3ZbQ2qLwnttR3cgYQkXDOs
         928MO7YNpfDUBq/POQqZqSXYNT3HO8n5FXndggwO3VfkiWTdyK5XrOX1eXM1eyQVPw1b
         8fnYkLbiVkPjp0Y+1XuCE9OWK7r58xcbGyvWa3+4OhNE4/jpBOrHzS492wn7XpTYTu3g
         ijLsn1HKrK+lyVMLFV4xWwKLl9Jg/+ScvLYqwsJnb2CG7fHB2eGz14JoiALzqO68Gqt2
         cChA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775030996; x=1775635796; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QGJ43lTmGm7tqVbmRpoI+e40OCefs4+iqftR/DXmG04=;
        b=YWNBL9SklJpd38K47jKt1TkJceOl669WXPs0ubICzKjcnaLtteexPYoFzOn4JJPQ8J
         r8bBzqB4Jpq6VHCaVw7NzdlQG9kfQnpHeO6xvL+cPPzKOx18p5EmyUmERmTl8lggMi45
         gq1U69ef36WBCf4Zr3qHlo8R378ZXYVYd4pkJ4yU5Zp4Ze/eguKx3L432jHCAmNcVwTS
         DWrnve0uvdOHz72DbiVsh8DIdTsL2HL51t2XnPgWXgvoaMfaRGwsfA4yfzoj87i+eRec
         rj7REBVGHw/6qZoswN8l0+BTmvFPRjHTIwhuVO79y45Dgej7lWbyAwSqr4VC+ie7MZUl
         koDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775030996; x=1775635796;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QGJ43lTmGm7tqVbmRpoI+e40OCefs4+iqftR/DXmG04=;
        b=pbAf6d6iIAN/GZUqi5B8Av7NzH0FRDfidSad7l3q00LDGBqd1mcaq2bF9NcRDDV42C
         hSOVGtVDRRgKG0gkikfmTEi4trjx+JrqS1x5ARhAAKu2NkGH0I7PG70IslcgBU3oSvz3
         zj7QUp+nW0hkv2D7fh9thrIyHKeFn+WviJHik4xc3K4Auuym8BsRhipvdGN20BgQNJaa
         qcZQauQP43ZTSgA3M5unexiblQPss8yaZcdaMJeg/6V9q7iLxoygDIw9mA1YADvlP84U
         JYW2WKW+DJsKYcxsnZ9zysQbysgnyRpP1OczI7+bjOgJmbTM1mhFdlDiM+GLmkp/yr6/
         Kdfw==
X-Forwarded-Encrypted: i=1; AJvYcCVgHx56BMVFmVrM20zfKT5uuzVUOHPuAqZjPWGqorNv1hFW820cCoEnR8xAXRdB/wrBmxnrpPDAHQfsiw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJBdkW6UmxMUdABwMbI41ak2Du4VtSbbQ1cycHrLxjjTa3Rfsb
	YEudxixtLZg90pUERXHsJ8mA+lMqRyFr1NjHBXUcMhA1j7A2IrSJgWfJNOxtCSBFGHo4nlUu9Ei
	aNNd47PMrbcp533wE+CjVHZ6wIqt/B00=
X-Gm-Gg: ATEYQzxV5xqRLFQmBdpixXKYsvD5oCR85rdpUzN3He25VxKblGva1sdMh4nXv8iBW+t
	hjV6PhEgdyRa9aKxaflK53LSiTPHO7MOOhx6WTZWXRpvOHB73N7HJyzeFmOvGrfQuDq/kdJUfjW
	9vkWdIQNSB2JwZIQeHMugb0+41plrd6l9+z4BEhrefKFDRu5sSBe2CRtDyXWlSW29ID0IwBRGWh
	2vf63eqnfXaRnwoGDkk6RXFgJzr6Sr0S6rJp7bcWL24IVT0yX2TBUkIfljR1brsR9s+eBxjPANm
	psTUj4hotg==
X-Received: by 2002:a53:acd7:0:20b0:650:2257:e052 with SMTP id
 956f58d0204a3-650265fda6cmr5036099d50.17.1775030995799; Wed, 01 Apr 2026
 01:09:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260401031339.1418417-1-lgs201920130244@gmail.com> <aa8c074d-fdce-460f-a9b7-8644880eebb5@suse.com>
In-Reply-To: <aa8c074d-fdce-460f-a9b7-8644880eebb5@suse.com>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Wed, 1 Apr 2026 16:09:45 +0800
X-Gm-Features: AQROBzD9iqdOf-hjodNWRwd7n_vljJpSJ53rYJAa0xgydMeLcbvf8YxBXgvWfQg
Message-ID: <CANUHTR_ZgLHj8COyE8S_J+nqUUunxMTH9TcOMsDuN=Y1hPXPEg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix double free in create_space_info() error path
To: Qu Wenruo <wqu@suse.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Jiasheng Jiang <jiashengjiangcool@gmail.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Qu,

Thanks for looking at this.

I checked this on my tree at:

`v6.19-rc8-214-ge7aa57247700`

My understanding of the failure path is as follows.

In `create_space_info()`:

```c
ret =3D btrfs_sysfs_add_space_info_type(space_info);
if (ret)
goto out_free;
...
out_free:
kfree(space_info);
return ret;
```

And in `btrfs_sysfs_add_space_info_type()`:

```c
ret =3D kobject_init_and_add(&space_info->kobj, &space_info_ktype,
   space_info->fs_info->space_info_kobj, "%s",
   alloc_name(space_info));
if (ret) {
kobject_put(&space_info->kobj);
return ret;
}
```

The `kobj_type` has:

```c
.release =3D space_info_release,
```

and:

```c
static void space_info_release(struct kobject *kobj)
{
struct btrfs_space_info *sinfo =3D to_space_info(kobj);
kfree(sinfo);
}
```

So the call chain I had in mind is:

`create_space_info()`
-> `btrfs_sysfs_add_space_info_type()`
-> `kobject_init_and_add()`
-> failure
-> `kobject_put(&space_info->kobj)`
-> `space_info_release()`
-> `kfree(space_info)`

and then control returns to `create_space_info()`:

`btrfs_sysfs_add_space_info_type()` returns error
-> `goto out_free`
-> `kfree(space_info)`

So my concern was that after `kobject_init_and_add()` has been called,
the cleanup is already handed to `kobject_put()` /
`space_info_release()`, and the later `kfree(space_info)` in
`create_space_info()` becomes a second free.

If my understanding of the `kobject_init_and_add()` failure path here
is incorrect, please let me know. I may be missing something.

Thanks,
Guangshuo

Qu Wenruo <wqu@suse.com> =E4=BA=8E2026=E5=B9=B44=E6=9C=881=E6=97=A5=E5=91=
=A8=E4=B8=89 12:34=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> =E5=9C=A8 2026/4/1 13:43, Guangshuo Li =E5=86=99=E9=81=93:
> > When kobject_init_and_add() fails, btrfs_sysfs_add_space_info_type()
> > calls kobject_put(&space_info->kobj).
> >
> > The kobject release callback space_info_release() frees space_info,
> > but the current error path in create_space_info() then calls
> > kfree(space_info) again, causing a double free.
>
> Can you give an example call chain of where such space_info_release() is
> triggered?
>
> >
> > Keep the direct kfree(space_info) for the earlier failure path, but
> > after btrfs_sysfs_add_space_info_type() has called kobject_put(), let
> > the kobject release callback handle the cleanup.
> >
> > Fixes: a11224a016d6d ("btrfs: fix memory leaks in create_space_info() e=
rror paths")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> >   fs/btrfs/space-info.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> > index 3f08e450f796..d7176eb2fcbf 100644
> > --- a/fs/btrfs/space-info.c
> > +++ b/fs/btrfs/space-info.c
> > @@ -311,7 +311,7 @@ static int create_space_info(struct btrfs_fs_info *=
info, u64 flags)
> >
> >       ret =3D btrfs_sysfs_add_space_info_type(space_info);
> >       if (ret)
> > -             goto out_free;
> > +             return ret;
> >
> >       list_add(&space_info->list, &info->space_info);
> >       if (flags & BTRFS_BLOCK_GROUP_DATA)
>
