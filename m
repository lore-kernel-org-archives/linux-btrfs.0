Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6888F3491D3
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2026 12:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769516434; cv=none; b=P3TLjKQl4P9oAY57ps8k05Sglh69ttPty0J2yVkAKWhkvbS3esMS+JmCVLeqY5QtUlgfqYZSlxXXY/I8c0zYq6uNTpFwyoeVq3+LHjy0U4Yv99r505LTADtyOjP8w/irsoxDrQqheudo4Dcl3dohywivg22whBdwXNrcV7BJlWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769516434; c=relaxed/simple;
	bh=pBuy0DbxmFYQB7Cm3bXorVduDHUrAirY31vQg53v3rw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DyGsSIRUTvZq010qmmi1fPsB7EVe9bVqxuu6KJjnYx1IrXpR4FAbzsdXBtGQ9tz/Zm6jz9AJQHKbr4JvDaPtesxULA+V46G7N5rhSqi1P6k/zb3ij9at1rFwQ1TKE4SevuSc/2ouAKLipm77kKKrIs3gdhtY4uZtX0bIH6R6ebw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t0vSp9pj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t0vSp9pj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15969C2BC86
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2026 12:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769516434;
	bh=pBuy0DbxmFYQB7Cm3bXorVduDHUrAirY31vQg53v3rw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=t0vSp9pjIu3XPaOhQl5LMOZ7kU1WOeCudRntyuiK6U/RfR2gAk5vuUzUcPlmWwLN4
	 IBcCrqLJCU31OCmQKPVbVDKUHuOLIpJZ8cANfbq/6+7cInj30HgNO7e/RYLHReLEIt
	 MrzbDKImHvMknzTp0RL2+Wg7A4Xp0NAotZlUJuxuL9GoWc+RhlAUSs/MldzEPG9AZK
	 iSlhyR9g40yFryVAjxR67TjuWz3glNBRHilySnNRW2t4wxkKctJAypz9RzmnI7n8qs
	 k9oxuHHRhR+18yIRDA2Ylu9aRXTwavIZNhvXy3jB8FWQwdAhhz53PyiIp7ZSYDGNex
	 oa8Xj/pQyYmug==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b885e8c6700so705452066b.0
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2026 04:20:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXOfpIh2+Aek8J771n6l3/gUvNMb4nYdEAG4Hvhycfeh6NIgvfSaQ2jkXRLhrpR6sTLJeoxvIbSrvWpAw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw67R/cnOha0Xg6PFapVmamcNgfItPuYhk3w5XNnC5HFOSm9F0K
	n6cOhDGImxX6DIvKQe92ah0y9lMT6fRK9sbgHhsz1YofuDl5bvoTcfWJJ1sTRDikGNVa6yEvykY
	urlj+/Ur7fTk0l7yQtG53/bXaRlr0M80=
X-Received: by 2002:a17:907:9806:b0:b88:783e:64f9 with SMTP id
 a640c23a62f3a-b8dab33172fmr130561466b.25.1769516432614; Tue, 27 Jan 2026
 04:20:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAL3q7H4=9vH3UP6=i1zTe7MVKf6aWAqEqb7i+Fmxoc3q4qDyKA@mail.gmail.com>
 <20260127074055.781388-1-jinbaohong@synology.com> <CAL3q7H62qyB_nWL2HHr8ua39K+oZC9TjHhF9BQn7bWJ60t8zQA@mail.gmail.com>
In-Reply-To: <CAL3q7H62qyB_nWL2HHr8ua39K+oZC9TjHhF9BQn7bWJ60t8zQA@mail.gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 27 Jan 2026 12:19:54 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4zKsA3bW5WDsOEsu4sJ6vLF+-muCsh42oW4Y3hJcHRCg@mail.gmail.com>
X-Gm-Features: AZwV_QiPj_NypxmmvjAdoZwxpo95yRsN4vpK6yopTWjm-ZJdNRZJ6pNt1dmWOAI
Message-ID: <CAL3q7H4zKsA3bW5WDsOEsu4sJ6vLF+-muCsh42oW4Y3hJcHRCg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] btrfs: continue trimming remaining devices on failure
To: jinbaohong <jinbaohong@synology.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org, robbieko@synology.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2026 at 11:38=E2=80=AFAM Filipe Manana <fdmanana@kernel.org=
> wrote:
>
> On Tue, Jan 27, 2026 at 7:41=E2=80=AFAM jinbaohong <jinbaohong@synology.c=
om> wrote:
> >
> > Hi Filipe,
> >
> > > > @@ -6648,7 +6780,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_in=
fo, struct fstrim_range *range)
> > > >                 }
> > > >
> > > >                 start =3D max(range->start, cache->start);
> > > > -               end =3D min(range_end, btrfs_block_group_end(cache)=
);
> > > > +               end =3D min(range_end, cache->start + cache->length=
);
> > >
> > > Please don't do that. We should use the helper btrfs_block_group_end(=
).
> > > Why did you do this change? This seems completely unrelated.
> > >
> > > Otherwise it looks fine, thanks.
> >
> > First, sorry about the unrelated change from btrfs_block_group_end() to
> > cache->start + cache->length in v3. That was an accidental leftover fro=
m
> > debugging - I'll make sure it's removed in v4.
> >
> > Before sending v4, I'd like to discuss some behavior details about trim
> > error handling.
> >
> > =3D=3D=3D 1. Block Group Loop Interrupt Handling =3D=3D=3D
> >
> > Currently, block_group loop has the same problem:
> >
> >   ret =3D btrfs_trim_block_group(...);
> >   if (ret) {
> >       bg_failed++;
> >       bg_ret =3D ret;
> >       continue;  // Doesn't break on user interrupt
> >   }
> >
> > I think we should also break the block group loop on user interrupt,
> > similar to the device loop.
>
> Yes.
>
>
> >
> > =3D=3D=3D 2. First Error vs Last Error =3D=3D=3D
> >
> > Currently, both block_group and device loops store the last error.
> > I'm considering changing this to preserve the first error.
> > This would show the root cause rather than the most recent failure.
> > What do you think?
>
> That's fine.
>
> >
> > =3D=3D=3D 3. ERESTARTSYS/EINTR and Error Code Precedence =3D=3D=3D
> >
> > After reconsideration, I think user interrupt (-ERESTARTSYS or -EINTR)
> > should NOT overwrite a previous device error (if any). For example, if
> > device A fails with -EIO, then user interrupts during device B, the
> > final dev_ret should be -EIO rather than -ERESTARTSYS/-EINTR.
>
> That's fine too.
>
> >
> > =3D=3D=3D 4. Scope of ERESTARTSYS to EINTR Conversion =3D=3D=3D
> >
> > > > @@ -6685,10 +6687,14 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_=
info, struct fstrim_range *range)
> > > >                 ret =3D btrfs_trim_free_extents(device, &group_trim=
med);
> > > >
> > > >                 trimmed +=3D group_trimmed;
> > > > +               if (ret =3D=3D -ERESTARTSYS) {
> > > > +                       dev_ret =3D -ERESTARTSYS;
> > >
> > > And either replace it with -EINTR.
> > >
> > > Otherwise it looks fine, thanks.
> > >
> > > > +                       break;
> > > > +               }
> > > >                 if (ret) {
> > > >                         dev_failed++;
> > > >                         dev_ret =3D ret;
> > > > -                       break;
> > > > +                       continue;
> > > >                 }
> > > >         }
> > > >         mutex_unlock(&fs_devices->device_list_mutex);
> >
> > You mentioned the issue of -ERESTARTSYS. Could you clarify the intended
> > scope?
> >
> > Option A: Convert all btrfs_trim_interrupted() paths to return -EINTR
> >           (changes in extent-tree.c and free-space-cache.c)
> >
> > Option B: Only convert at btrfs_trim_fs() level before returning to
> >           user space, keeping -ERESTARTSYS internally.
> >
> > Which approach do you prefer?
>
> ERESTARTSYS is not meant to be returned to user space, it's a kernel
> internal thing.
> We should make sure that we return EINTR to user space instead.
>
> Yes, there are other places using and returning ERESTARTSYS which gets
> propagated up the call stack and then into user space.
> I think we can just replace all ERESTARTSYS with EINTR, it's simpler
> than leaving ERESTARTSYS and then converting to EINTR before returning
> to userpace.

Ok, so taking a closer look at this, we don't need to convert
ERESTARTSYS to EINTR.
There's an automatic conversion in the kernel and checks if the
syscall/ioctl caller has the SA_RESTART flag.
That happens, for example for x86, at:

arch/x86/kernel/signal.c:handle_signal()


>
> But please address each of those issues in separate patches, which
> with its own changelog describing the change.
>
> Thanks!
>
> >
> > Thanks,
> > jinbaohong
> >
> > Disclaimer: The contents of this e-mail message and any attachments are=
 confidential and are intended solely for addressee. The information may al=
so be legally privileged. This transmission is sent in trust, for the sole =
purpose of delivery to the intended recipient. If you have received this tr=
ansmission in error, any use, reproduction or dissemination of this transmi=
ssion is strictly prohibited. If you are not the intended recipient, please=
 immediately notify the sender by reply e-mail or phone and delete this mes=
sage and its attachments, if any.
