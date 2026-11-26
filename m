Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795691899;
	b=O5oato8K4N6skt9S9CKIEb/AmEhHAbi9UZ8zgcBl9bowgL8lBUCQIEOZdoyGyPij3x1f
	 0gxE9vRJC73smZIPA3GaSnKhKmfnEHkP6ize/qFmhj9o45sFQGafKrJT+lT/8xCaN8Q9L
	 wF9CSpO6T1fvrmjRq3GXA/xGCefjHTHqyev58QJjP/B6TZqf83+EpoWonglFL/TboT4bM
	 bgS3F9mbRmbfeYXoEFJYn6Pf3GbWu9DYugX1EQG4pLp4At75Of5EciGO5Mx+pZT4bKDtb
	 vApWGvKplOyN0bYmyOdrKJE1iuGZ9IrLsGYcgoZxHKotDz6wda/Rn/USnw2YUcVa7Ug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795691899;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=X8WwWz6JnS6y65umA17S2axWzHpMAWvbUXb5Ah2q0Qs=;
	b=oZSgFfdhws+ikUV6zrvyqApz/DOejSj462oP8JHJ2vSq6RdunuxSfJSYmtehBo5sUpOC
	 R2UkYcFyFkMAwr7WnkckRSnVr3THdOwc6yU//ngA9Z3te9j/knReLhoXQINKNL1656ZYw
	 vVUru6+NZYiW4/WzvM67irT8GndLQfd7xGslzXewL73fsAGWnsID8Nt9K3Xmin7WU9Z0k
	 QK+J8L6MAOLFKa9WwNQIVyCpLGRJC0gwXYuhrZw7rivkXZNlKtTcU1z8cSmbcjyOeOPY4
	 q1mWvSzAV3flfuZXIddx8qt2YdloQ4bLqiKbK6wLgJjIigsmPtLS1+/+qPODEr1MvqQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TQa1M6mK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18760606A31E
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 11:18:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18760606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TQa1M6mK
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c506a231b88so927166366b.3
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 03:18:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795691897; cv=none;
        d=google.com; s=arc-20260327;
        b=Jik+fZz2Eu+B9fReSMZGgkWVEoiXLoyPTKwAdOb53pyBBI/25EsCi4wUN+thZT7NDB
         ua7MthoPuYqyq6yvzi17AZdwWf1nskzupdoVJ1mNlpW13o6ZIK+TRYSQAGqbPgRma5Ey
         cZh893wGw/oPvcwHqAhsvsKEYC//zG5oz7cgtbAR2Pho8Hor5Rp1sWv//Zq6S55YiArV
         utftRWU2oUKxxjmoGOJ4dH+yuJDJP30wQi3gq3BJ0b1X+8ckxhDPRh3Rz9v42g4L//+5
         LUgN1khr6pY+sMtA/X22RpEYVZyNttgAmoPs/P3l9OCcH25cncyROxKvk5JXbjd/dXoT
         OeHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X8WwWz6JnS6y65umA17S2axWzHpMAWvbUXb5Ah2q0Qs=;
        fh=8Q5Wbg9duNCpdAZor/T/aMWL2jKEFMKtGKwkxL2VgEo=;
        b=nKgV76NECtKoqjtlZUx8sQVXkxzptHxu59rRow35cQeJDlOsDl3TA+wmGPkUTbauRE
         3OfD4YTA/E7fGMlgL1NGzi/7aersYGhVRbQ2fbuyMUSmjXervNKmVW9cqNTIoVbaFQHg
         LfCQdkPbdlbm4yI3MBuVHIDUEsYgnuTt+Jd1vRtsiA9zAGliw/Dzc3zu4LITycEKrMmn
         RONQ6ACXeGe5r7+Dzgt+XvtocrwLjTtqj5sRNf6YECbm8vijWgrrOkgWFMvVQ6DDoei6
         0ofP3fOXpVFNlRcGyhJn3e02hjC+FkTeXl/cefq44/5/oDNGEIQSykU0v/I+ZuAi/8+i
         GwUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795691897; x=1796296697; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X8WwWz6JnS6y65umA17S2axWzHpMAWvbUXb5Ah2q0Qs=;
        b=TQa1M6mKPCJFjBUSMOQU0t3e7hUnaXCb9Uj9gtpyXJKSLALQ3+MPJncfJh/ct231pB
         uGCFDx/Ml3ajuFfausEbI+Uc1sLgJxzbWHT4ln0d1tCQuq1iapilG0D29JPVjKKnHwBg
         zjYaHfR0uROA3tOBZpo1ArWIFY3kyVEgDLRfCPP+tG2Cw/ZrtnpQc1kIK/DzXGUuBO31
         usA6Nc4yhic443m+UygHAlqBQ2x3JdnAOPlLlMCy2MnVCY4J6x2+mLrmzI+JksRxh/e4
         kAkH8aRnl/UBTnrrDZkrFmt485Ux/eLIFuRwqT25Uxkk+PwrSI9rxL825UoURyxYHhQy
         RQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795691897; x=1796296697;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X8WwWz6JnS6y65umA17S2axWzHpMAWvbUXb5Ah2q0Qs=;
        b=SJSCRh5lrSeE7YcLJB9cZ0KLzqb8qH2yElt1JxQcD+HvbuRu72SrnoIa9EBcIZzifm
         hs/TlYIpcpMlvGEu8VHhJF8pjbKOqot4AIRuC5K5teWVpi+ZPAZpmjxryB3bB07Lscpn
         SQpxe5ePoJCiDkMxPaynDPgfbfCsGfuuHLy+WjXRgO8ke9S/UWgqNU6PzjKCKzdtyM2E
         nVqIetlIS4fyQQDyCjtnWI6bdmvTNT831CRd0PtXJKzQJPkhU+Fd6vLNu0tE6jiZruZK
         pEBGiSF9C13/sG909hWU0UD7YWafT+qf4mca02DWFQmnGrTBLW1XwfmxJcGa6d/GuuIh
         Z99Q==
X-Forwarded-Encrypted: i=1; AL+hErHxvS025OIDwMm8/A2EQ/GZzXvrzH25q/XDw8ImA8cJ01tIMhm8pUctsiq903PoD5pMVDc5HxFczBx7kg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9X5PH+lx646jyy5x8Q8Lh3UXb52tBg/H9q9NlKfKUySQRKXL0u
	KyFHSZJzmcTBHYSwc/J+Myk2LfQNSVwqUZiW4/tk3hkFzv2HILUso8sWdrp+0YrTp/7vhXsG0Y8
	khBYTutGT+BCuV3sk/WMZpZ+70fLYi2A=
X-Gm-Gg: AZFdTZduvrHO9K/WdEVimGJz8tf9hhxGG3PdyjHNud/csxi31XykSZp9CQL2XTqiTZT
	nOu9/otFQ4VhTTfU1WMSnRva24bLTgVzYfMfOxwX3z22DEfsnlal1zJPZnB+3Vo02OGOhQ4oUBD
	njBmCNHBiCa/Gjq42YtMLbfFv5XOcDxoljqGOmxHLH7jYXCdPcev2ElXdLC28puVuW6uWRLbbv0
	4idzbgivFKoGD9eGVZCpHHeYmvaGzsxC0IZDz03cfO3WYOsaaSdT8YefI7RJXPu3Mf+L9dOhMTI
	7WMyD+mWV9u3jYnKOxhmNGFiik/zYcdWZWmraq3w0iupUZeS3Sj1qyiGfhtOfOfo1shAyNhy97X
	pH8lltNYafukaeZz1tDcSrUnplEP3SaP5ADs=
X-Received: by 2002:a17:906:3e1b:b0:c50:93b6:52ed with SMTP id
 a640c23a62f3a-c513aab27ccmr1230543066b.40.1795691897317; Thu, 26 Nov 2026
 03:18:17 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028-b4-btrfs-fitrim-interruption-v1-0-bf5c53738b3a@gmail.com>
 <20261028-b4-btrfs-fitrim-interruption-v1-2-bf5c53738b3a@gmail.com>
 <b00f8fc5-89f1-4483-8986-947392837a6b@gmx.com> <CAO0HQ0VfHczGkTb0OOxXf38Cnu3sOufi24652UR0AJ5a7wzoSw@mail.gmail.com>
In-Reply-To: <CAO0HQ0VfHczGkTb0OOxXf38Cnu3sOufi24652UR0AJ5a7wzoSw@mail.gmail.com>
From: Luca Stefani <luca.stefani.ge1@gmail.com>
Date: Thu, 26 Nov 2026 12:18:05 +0100
X-Gm-Features: Aa3M54ojdEGLiceptP1aQHnxZ7c12hdMS3RYK5bPYgGle6EicdE7SBNpHTVl4kE
Message-ID: <CAO0HQ0WMy0zAgSTJMVMLexv00YqJQp1K4e3tu47cSb=et4WkUw@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: don't report failure when trim is interrupted
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Robbie Ko <robbieko@synology.com>, Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhiwei Liang <zhiwei.liang@zliang.me>, 
	Qu Wenruo <wqu@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry to ping, is this getting tracked somewhere?
It's not an important fix, but one nonetheless :)

On Thu, 29 Oct 2026 at 09:56, Luca Stefani <luca.stefani.ge1@gmail.com> wro=
te:
>
> On Wed, 28 Oct 2026 at 22:07, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> >
> >
> >
> > =E5=9C=A8 2026/10/29 04:25, Luca Stefani via B4 Relay =E5=86=99=E9=81=
=93:
> > > From: Luca Stefani <luca.stefani.ge1@gmail.com>
> > >
> > > Treat cancellation as a successful partial trim as ext4 and XFS do.
> > >
> > > Reported-by: Zhiwei Liang <zhiwei.liang@zliang.me>
> > > Closes: https://lore.kernel.org/20261028-btrfs-fitrim-freezer-v1-1-0a=
d1d58aa94d@zliang.me/
> >
> > In fact you should use Link tag here, for the original patch as a
> > report. Not Closes tag.
> I think that was my original intention, but I mixed up the patches.
> >
> > Otherwise looks good to me.
> >
> > I can change the tags at merge time, so you don't need to resend the
> > series, unless there are other reviews that requires code changes.
> Thanks! Will fix them up in case.
> >
> > Thanks,
> > Qu
> >
> > > Suggested-by: Qu Wenruo <wqu@suse.com>
> > > Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
> > > ---
> > >   fs/btrfs/extent-tree.c | 5 ++---
> > >   1 file changed, 2 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > > index 242db255cf1c..90e581c29609 100644
> > > --- a/fs/btrfs/extent-tree.c
> > > +++ b/fs/btrfs/extent-tree.c
> > > @@ -6926,7 +6926,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info=
, struct fstrim_range *range)
> > >                       bg_failed, ERR_PTR(bg_ret));
> > >
> > >       if (ret =3D=3D -ERESTARTSYS || ret =3D=3D -EINTR)
> > > -             return ret;
> > > +             goto out;
> > >
> > >       ret =3D btrfs_trim_free_extents(fs_info, &group_trimmed, &dev_f=
ailed, &dev_ret);
> > >       trimmed +=3D group_trimmed;
> > > @@ -6935,9 +6935,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info=
, struct fstrim_range *range)
> > >               btrfs_warn(fs_info,
> > >                       "failed to trim %llu device(s), first error %pe=
",
> > >                       dev_failed, ERR_PTR(dev_ret));
> > > +out:
> > >       range->len =3D trimmed;
> > > -     if (ret =3D=3D -ERESTARTSYS || ret =3D=3D -EINTR)
> > > -             return ret;
> > >       if (bg_ret)
> > >               return bg_ret;
> > >       return dev_ret;
> > >
> >
