Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793264229;
	b=Ap2Oy4z5sEvOzGjUrRTe3SZIuq/mmVfE0QVITR+uvSFeIiEuM37KC4Ln7Lw6nlra9oPN
	 4XimQFo/b9yqdVk5uf1QKsz6/UM/BeNDdPb6fOii3MltlNAIqTaCzl4AE/VALYgBD1hev
	 pLtsYA7iONY3bUFgvaqVwr3O7fYXiV/BpdrRtOy1MvsgYBTEnGZc0U3LcZQ+4h55MdNiK
	 UQhSL+0QjnSCnD40dFkwd/RkNC048vqW6VdAsS4YHQOF7tsOPrV5rtRE/8Zoyoi+uaDb+
	 uti1HSYWw/Ak6iBISd2Bg4d+eylPhSP3uPC+3oXvltAiyMXgwH4irFz12DnP64JDOxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793264229;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=YEYkGOiLXKcBsMHHVyvIodqXJbKVYymQHbB/udibFPE=;
	b=G/JzT2+MqohQCxhjFFfEM6WTInQaJdUMqspzvrLhdMurhQOhAD0QBGy2yOLuZzzCOzT5
	 TV0vJai3NWkSd+al++AS4mHgN3q9Fy8HABVK31nnlJxjT5gZXVPArsu6v0u4r4xJmljb9
	 oLyMHjnSt/TX2EGquZo49LMYxj32UofoSLeGxCjI4nlLHaCOTRIr+Ed3p+MRL7A6pxvf8
	 EeFLJdWxiOejPiCXyWm0n3FflSLyrbY9GFEwLfJ4+TTtQsGYHRHExtxGVU71v1tBnhkeP
	 tqvelDdNrbT/1RiVz1ujhvDj4eRc77vPAEsAUdCbcWFx0ks7OWHCjKT/fAgaxeeaJ9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zxeEC98O;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.50
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB963606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 08:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB963606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zxeEC98O
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-67b9bd530b7so50197d50.0
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 01:57:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793264228; cv=none;
        d=google.com; s=arc-20260327;
        b=iOXyXxxRYXzO/FC75ik6ntLSLEVsrRy0y5DIYeh04nq2pEPu9ZpuV4g5saakmi3cPw
         rJPM8GL7bzV6EXuWx6b3fw379/e5gAcG1bLl3XgPzp6qUxKCXPBSnPCRkM+bGZvleXfN
         9BpTESmNvNfh9AD/nus/A+cnEA4RdmMkLO2VGQPRyKTZ7ma5pU4xW9D6XABigLUetu26
         /y3LsPhqGbGAA0Q3+g8mJbxp05mt1PCWmAcj0nSi+fIFQnknyWm1Go7yq0vTHWj0aBFC
         GLdrOFWVi5EWLs/miz+Hk8fJBYvUCUEienvVi8MF1CiN4bAdyqNJX8p69Ehx2gVLvCHi
         o1oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YEYkGOiLXKcBsMHHVyvIodqXJbKVYymQHbB/udibFPE=;
        fh=oYvkEfRaxezu/e5wA44mlD08X6PT8fTh57772MQxWsQ=;
        b=mp7owbmlQQQr7xV+/qDp4/YAats1d6uADEbPJkXQacp2L30nTtTH0iYqR9ReOeeFXv
         GrQ+fxbfPeKr78jwiVwTEPLlx2I1efSUmcdibTBmo8IiC1VqWQlq9ZbO7HyjILkpHanT
         oprcB3lpzRUi7BXbAXQ2UEbKPSCrxqG62vST2Qe6TFa+4WRIGeJ0bRSIxjrBsz3dK2Z8
         IGx1JLrx1UMXhnsHnFmoaF+Pi8Kzh3YssnrDAEdYM6dymqAHos+tkbZSwmv+2CiuDXbt
         lHcYlagpqR1vMSKp9oAWFKmP3x37VBzh3SNazowh0dhyxMV+wwW0aXJLqhMBHIIVXa2W
         dVLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793264228; x=1793869028; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YEYkGOiLXKcBsMHHVyvIodqXJbKVYymQHbB/udibFPE=;
        b=zxeEC98Oj4WpoX7QGt/z5YsgJg6CbDNf4qMkQ9/rF0REgVGR53j2mhJHHM97pKWpAB
         AaaK6XcbbkFMAQc6XYT0Kt4wH8R5DY1npn2aceWlpQsraeczif1nCT3RPKgxdvprcwHe
         Cyo6mMzXxO+9Y5cDKy2e66+cfYqXUlW+F7vFUY6WAduaoXwWurO1BTc2kBUU4Bv1j62W
         WzahFWBT7JRIUIoCs+VZO5HIJeznNKqkQigdHtaxGpvTCy8UcjhNUMoA3g8bJPs+l2JY
         iMGsBETftAKuShuwSnJSDAtRk/7ynrcHMb4VHwGjTSNL8iJHkvRHTsNygOMISZNMz+pr
         7XMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793264228; x=1793869028;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YEYkGOiLXKcBsMHHVyvIodqXJbKVYymQHbB/udibFPE=;
        b=zr+D/hB49VeK7DE3pBt8McxRbKTT+VelDWu0OaEVT5lzfZtqn0GqPaMyNcERZnekLd
         dSkC78D1PFAAXkEkPp44+xbOhv5n9ggMo0O+QFT7/yDqgNfpksi5Ho2tJkEPCv4rggsE
         oW+NqNjkcI7g7pKVsMjAuNsIS6GVmWXuFByDnIxKjt6kthRN8NqdV+9c02AH4lcoiu/U
         J58mTJYlA/os3Vz+WPeHUFxQKErBRUNAWxD15DS46DptLuXrqya2GZ5WnE7krQ7SvCq6
         p7bs0PO2ujTJLMBuj7Qhc4zIiKfsxUCXtgsBl8hMxZC+ox65chXA1vsYwrEw1WcKyOw/
         ZI2g==
X-Forwarded-Encrypted: i=1; AKwUvBz4rUhXNnTGttCjcpHj5D8cs6s/TeBujCfSBC4REZd0dU3BjBw4oDvjppZG0fu36qY9BOwbdvE2hSqx1A==@vger.kernel.org
X-Gm-Message-State: AFq9FYIaeK1pBtlz2ifYJ9rxqNH59GxzH6mikmnWgU9Mk8nTGf8/62Xn
	To5LbThjnfRvevpsmBExXeBv9vhpVV65QyzXHgOIjUBFqN0CvHpvMy7j6F2vnZZtWDLpKukj1mg
	2S2S6lPxMxnV4VbEJuQ7mX1YaOTVTsbQ=
X-Gm-Gg: AYBFou2nX7NlvkcuBNHiMUvXHfI5rBuaxYVxe1eo3t6keujcV3qT/2b0cq412a9fOIF
	ZUTy14ECJ/hCU1F4Q7CV77/f2yY+cYoQPPtNGFZG4VChwAHhHglo/ffDHs3uUNn90xS2JabgwuC
	PIqZ9VaLB5TM/4OcJFweSzIpjwwm77bjykkiI7Qo5T5EsWxw6VXyXXiIB8sCzjXpv1JFfgUqx7l
	PYTvN1cxbi82tw8qDprVrxgUalQjTacFVhBTjWrNm9AkAIneIZMEol1L3zHmUJzJ8+44AHJsmZy
	enqx5a5059ZjShc0aSsbaTsrmzZTj9m6hng2vecQINbqkE5LSZmcg4JDubaOxD4FnOffsS4yPrL
	thTWMk0BdGCMtSkbGImGAqG5A78TFEl0QeSus
X-Received: by 2002:a05:690e:1a66:b0:679:a79c:95a4 with SMTP id
 956f58d0204a3-67a7bd15ffamr3128571d50.103.1793264227822; Thu, 29 Oct 2026
 01:57:07 -0700 (PDT)
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
 <20261028-b4-btrfs-fitrim-interruption-v1-2-bf5c53738b3a@gmail.com> <b00f8fc5-89f1-4483-8986-947392837a6b@gmx.com>
In-Reply-To: <b00f8fc5-89f1-4483-8986-947392837a6b@gmx.com>
From: Luca Stefani <luca.stefani.ge1@gmail.com>
Date: Thu, 29 Oct 2026 09:56:55 +0100
X-Gm-Features: AclHuK-Johsu-yxO4ADp4C3k1kpagtbBq9W5ex9Eh00g4fIknrHdSnalBZsHWbc
Message-ID: <CAO0HQ0VfHczGkTb0OOxXf38Cnu3sOufi24652UR0AJ5a7wzoSw@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: don't report failure when trim is interrupted
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Robbie Ko <robbieko@synology.com>, Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhiwei Liang <zhiwei.liang@zliang.me>, 
	Qu Wenruo <wqu@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Oct 2026 at 22:07, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> =E5=9C=A8 2026/10/29 04:25, Luca Stefani via B4 Relay =E5=86=99=E9=81=93:
> > From: Luca Stefani <luca.stefani.ge1@gmail.com>
> >
> > Treat cancellation as a successful partial trim as ext4 and XFS do.
> >
> > Reported-by: Zhiwei Liang <zhiwei.liang@zliang.me>
> > Closes: https://lore.kernel.org/20261028-btrfs-fitrim-freezer-v1-1-0ad1=
d58aa94d@zliang.me/
>
> In fact you should use Link tag here, for the original patch as a
> report. Not Closes tag.
I think that was my original intention, but I mixed up the patches.
>
> Otherwise looks good to me.
>
> I can change the tags at merge time, so you don't need to resend the
> series, unless there are other reviews that requires code changes.
Thanks! Will fix them up in case.
>
> Thanks,
> Qu
>
> > Suggested-by: Qu Wenruo <wqu@suse.com>
> > Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
> > ---
> >   fs/btrfs/extent-tree.c | 5 ++---
> >   1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 242db255cf1c..90e581c29609 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -6926,7 +6926,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, =
struct fstrim_range *range)
> >                       bg_failed, ERR_PTR(bg_ret));
> >
> >       if (ret =3D=3D -ERESTARTSYS || ret =3D=3D -EINTR)
> > -             return ret;
> > +             goto out;
> >
> >       ret =3D btrfs_trim_free_extents(fs_info, &group_trimmed, &dev_fai=
led, &dev_ret);
> >       trimmed +=3D group_trimmed;
> > @@ -6935,9 +6935,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, =
struct fstrim_range *range)
> >               btrfs_warn(fs_info,
> >                       "failed to trim %llu device(s), first error %pe",
> >                       dev_failed, ERR_PTR(dev_ret));
> > +out:
> >       range->len =3D trimmed;
> > -     if (ret =3D=3D -ERESTARTSYS || ret =3D=3D -EINTR)
> > -             return ret;
> >       if (bg_ret)
> >               return bg_ret;
> >       return dev_ret;
> >
>
