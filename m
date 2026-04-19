Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA9E24B28
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 18:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776624015; cv=pass; b=q7MgvCMMfS2Ve79HqrAsT4JuDH7pW3THmFiqdFHHRpip92N2LdO7b10UJ02DyKFIbWCkr5EfhnYwGJHy8SMgBn2bydi8a/gfH3jxeA3K0j8ypZHlRKhIIQx/v5NWeo2x+KdBGeXiuJkrFLf5onbUz4+mDCQ87umE24hkz55224A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776624015; c=relaxed/simple;
	bh=sg0GK+WLKzf6//ET9ne3dXbHn1FY0m9iEAsCIrJVVR0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mp3avXNKNEQn5pbPhoyRko6jahqQzBhMxkt8Edy+MeDxbezZlsL46758k0gRt6brnC3KB8WoKenA+NdoDv+HX2Chm0LqHaQ6CBmd3w2f/IJd/1ORU5CR9ib5KgBv5V9g8CwUxu32/V2835sOaGHTQPZZl2/3UfqMWMkyud3BQ9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KyxFaUWP; arc=pass smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KyxFaUWP"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-12c726ef332so2593532c88.1
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 11:40:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776624013; cv=none;
        d=google.com; s=arc-20240605;
        b=HrAzauvRKvza/yP3JWfATP+1IoH+SFkhdPMkyvz5HU1MJ3zDuEG8frCC/+cWc/02r5
         hXfT9Rjz/BDLVxjp/808JvNv84nxFSamcyXoiCQ9dcVXs0qtfblElLLWlT1Al8svooz2
         r+9T3XGKJq0ckrA5yQu+Nskw0jPd8I1PZ6pAvNgDtLC9/9tWp36s66zjfwBkdTXB/MgE
         WBN26k9ZleR5Y8wVbIk5wExIKs3hMynWYiVJOnP7ESR28I+roQmk0eDmxxNS4714Dw7Q
         MLmZ7CiEDd1EJGseUIrK5UAWmMnfcUZDw58aaERqSzFQi6c3wRZyGtOINHxh1vKZcQ4e
         Ec8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ytXUBOarkVXuR2yiipppt77NNst1i7oZ6litYLo/0fw=;
        fh=9lEVqXf0xtFztV29e2PYWQC150xkteAQi4Te3dbrdZA=;
        b=VDd1nQQ5H0RRAZG1i1RszOoSs8lJOM6DURvm41m8+dOZVcSZ07VYbIYc4w1Kef9T/E
         0q4Rv+VeIJGAtGljN9FjDAygZBabWvD+R31YJJMYyZiNUxyb15b/XR3JH+jm4rcd9nle
         UFqRQ3Tmpn+BDsUMPcfQdUf75Ymdt0Y7rstf5Nr+XCydMy/pJMLGpk9UbVTD3/me3Cfa
         llxukairm8463eOVIqIaxx4CYJBeY6vBINIC8HdrhdA4FOs5C0GSUV2M19b+nI++RjWx
         km9eB7kYbwear8tmZpmJNGaiUuFxwpbtCV08HBThM8qYFbqxA5Q8dmBxaYWoYQ3KUSTa
         9prQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776624013; x=1777228813; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ytXUBOarkVXuR2yiipppt77NNst1i7oZ6litYLo/0fw=;
        b=KyxFaUWPKIgsJ08FirjYl3Q7jRTvAdif3ftA4+9IEp2nqQ+kq8eymSfm+E5BEXZ67Q
         h0q1kwqRgR99RbGeuqNPYzJohSpqbPClt23lcbsNbfPGWvvxmRueCvkAxEcLNJeGrHme
         V7beW7mEgvDmhSqenqkExZMD4jo5/fSsKvWfmkayXc9lKAR2XjxUkeSalW57gGrta6un
         /hx2JV20vcuwE6mqBKf6E4K2G5QvYZdPilo9HKiQynYqZknOjNkuOdnfh5XKJf6UYlMJ
         e/bUT62EO/JoRbPOVpcKjlzrYWejgbsR4jNz3zVaZ+Mmey6lsKQo5Xf4guHY49XafHk1
         iVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776624013; x=1777228813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ytXUBOarkVXuR2yiipppt77NNst1i7oZ6litYLo/0fw=;
        b=apC3kMaQTgUGVJZ3fUdvsEeSricrZVZN3S5uaJjV/WXDE//vvrabrJeG9jwXtG+tcC
         UVeoOeGiq6ClBvv/iMAwgYaS8Ahf+oGEXREznw84zGYDyX4xAhRoNZ94efQc/riBJQ8a
         +y57HvNcnwE/X3GV100cl8HlA3r5mC0V05/u6BWyU9nOQNsvTpAgqo7v93Zb2WJdyL7/
         p62BIHVjWOTwftfBJaBaoM2FRKYFhuvl6ycNbBft28hg4FIoCsarOk1Zu03WbzDGLmyT
         yn0sGUPpZAgs2PsGVvq2dmdYYIEdn60LXeiJR6LRQNxpbqD+5P5m0gm6Q5uXVnokXITI
         UVLw==
X-Gm-Message-State: AOJu0YxjzMVrqd9uX/RQE9WtE21GMekppyZT0TfXQLD8K2Be7H5sX8PT
	TXm+81NgacMTiIORNOsq46sqyt0i2L7H18bkjDVrOc4RaxLpDg9xda01DW2MkrWtHyh5IWfA+Wv
	KPiZoZr5nd5xCC2yy4o84ihOoASZgJ2Q=
X-Gm-Gg: AeBDiesAqjTrnhMywXumaNjnhVevAyY+hTr5zocf2VkrsSmjm+tSefCxLuPt5zr3qJl
	hHEA61LFdKE9As3wdg1yg/uzwNrzDRf/zIS5QGDI1T2faFcm0qPI50kbNoy8j/oP3E+k5nnAEL6
	S0O0D7DT6jMi9yVbUxiJnXBAsWrOGRvkkjVLyiEIlW1fTssZ6HigwSoJrZgE98Wz791egboz4fM
	RoL7aLoj1UsScZdiDwsJ6dB2ZfWaGFVw9gGFF6dddr2GSOVHQ+FSoR3EXblp8/Jd8F3mHnfOAGw
	/R09het6WH9oRRX7TXlOXZ1e3+kP
X-Received: by 2002:a05:7022:60f:b0:122:3a5:fc42 with SMTP id
 a92af1059eb24-12c73f99eeemr4800897c88.20.1776624012361; Sun, 19 Apr 2026
 11:40:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260418143808.199603-1-paul.richards@gmail.com>
 <92c96052-6619-4c25-8add-a85a4b76c060@gmx.com> <412d6926-8613-4377-8f33-3cf0194f685b@gmx.com>
In-Reply-To: <412d6926-8613-4377-8f33-3cf0194f685b@gmx.com>
From: Paul Richards <paul.richards@gmail.com>
Date: Sun, 19 Apr 2026 19:40:00 +0100
X-Gm-Features: AQROBzCP--R7zBpmk2r7Y50FajK8B81uK0FJ_9khcjQgsPRM1tbQBRZrGsBX2mw
Message-ID: <CAMoswehjDpHm7_jmTPV_vKkqJSNKu5pCEDxmwGzAghhEwTGHSA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] btrfs: implement FALLOC_FL_COLLAPSE_RANGE and FALLOC_FL_INSERT_RANGE
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Qu for your feedback! I wasn't expecting such a thorough review of
this early RFC. I will reply to a few of your comments below.

For the comments I don't reply to, please know that I have read them and
agree with them. If I follow up with another revision then I will address t=
hem
there.


On Sun, 19 Apr 2026 at 06:09, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> =E5=9C=A8 2026/4/19 09:55, Qu Wenruo =E5=86=99=E9=81=93:
> >
> >
> > =E5=9C=A8 2026/4/19 00:08, Paul Richards =E5=86=99=E9=81=93:
> >> This series adds support for FALLOC_FL_COLLAPSE_RANGE and
> >> FALLOC_FL_INSERT_RANGE to btrfs_fallocate(). Both operations are
> >> already supported by ext4 and xfs. The userspace contract is
> >> documented in fallocate(2).
> >>
> >> Patch 1 refactors btrfs_fallocate() to dispatch via a switch statement=
,
> >> moving punch_hole into its own function and decoupling locking from th=
e
> >> per-operation helpers. This is similar to the implementaitons for ext4
> >> and xfs. The allocate-range and zero-range paths remain coupled since
> >> they share some setup logic.
> >>
> >> Patches 2 and 3 add COLLAPSE_RANGE and INSERT_RANGE respectively.
> >>
> >> =3D=3D Implementation approach =3D=3D
> >>
> >> For COLLAPSE_RANGE:
> >>   - The removed region [offset, offset+len) is punched out via
> >>     btrfs_replace_file_extents(), which handles boundary splitting.
> >>   - All EXTENT_DATA keys with key.offset >=3D offset+len are shifted
> >>     leftward by len in forward order.
> >>
> >> For INSERT_RANGE:
> >>   - All EXTENT_DATA keys with key.offset >=3D offset are shifted right=
ward
> >>     by len in reverse order (required to avoid key collisions).
> >>   - No pre-splitting of straddling extents is needed: the left portion
> >>     of a straddling extent stays in place, the right portion is shifte=
d;
> >>     both reference the same physical extent via their existing
> >>     extent_offset fields.
> >>
> >> For each shifted key, the corresponding back-reference in the extent
> >> tree is updated via a shared helper btrfs_shift_extent_backref().
>
> After looking into each patch, I do not think the low level direct file
> item change is a good idea, especially with your current implement:
>
> - Can lock the inode for a very long time
>    E.g. inserting a hole into the beginning of a very large file.
>    We will lock the inode until all file items are iterated, which kills
>    concurrency.
>
> - Possible problems with metadata reservation
>
> - Problems with ^no-holes collapse
>    Will cause duplicated file offsets with hole file items.
>
> On the other hand, with reflink the insert/collapse can even be
> implemented in user space, with a proper step setting, we can still
> allow concurrent read/write out of the reflink ranges.
>
> This makes me wonder, is these features really that necessary?
>
> If you know some programs actively utilize these features for real world
> benefits, but can not be done through reflink, please provide them.
>

There is a proprietary tool at my $dayjob which uses insert and collapse ra=
nge.
This works great on ext4 and xfs, and I am personally interested in having =
it
work on btrfs.

Emulating in userspace is entirely possible using FICLONERANGE ioclt.. but
since ext4 doesn't support that operation this leaves userspace needing to
use one solution for ext4 (fallocate insert/collapse) and another for btrfs
(FICLONERANGE). By filling the gap of btrfs fallocate modes I was hoping
to simplify userspace and reduce friction in supporting btrfs.

However, on balance I agree with your opinion that emulating in userspace
is the best approach here. So for now I will pause my work on this patch se=
ries.

> >>
> >> =3D=3D Testing =3D=3D
> >>
> >> Tested with a Rust-based functional test suite covering:
> >>   - Collapse and insert at the start, middle of a file
> >>   - Multiple sequential operations on the same file
> >>   - Files with multiple extents (fsync between writes to force separat=
e
> >>     extent items)
> >>   - Files with holes (explicit punch_hole and implicit sparse writes)
> >>   - Compressed extents (mount -o compress=3Dzstd)
> >>   - Transaction cycling (interval reduced to 4 during testing, verifie=
d
> >>     in dmesg logs)
> >>   - Inline files, verified that -EOPNOTSUPP is returned.
> >
> > I guess that tool has never verify the contents, nor multi-thread stres=
s
> > tests, e.g. fsstress?
> >

My tests did read back and verify file contents. It was not multi threaded =
or
particularly stressy.

> >>
> >> The same tests pass on both btrfs and xfs (modulo the inline files).
> >>
> >> I have not run fstests which I know contains tests for INSERT_RANGE
> >> and COLLAPSE_RANGE. I will do so.
> >
> > Thus I'd prefer a fstest run before whatever your local tool.
> >

100% agree that fstests would be better. I started with my own tests
only to keep
things very simple while the code got off the ground. If I carry this work =
on I
will use fstests.

> >> =3D=3D Notes =3D=3D
> >>
> >> This is my first kernel contribution. Development was significantly
> >> assisted by an LLM (Amazon Q Developer). The implementation, testing,
> >> and final review decisions are my own.
> >
> > I'm very interested in how the LLM is involved.
> >
> > You mentioned "implementation, testing, review" are on your own, this
> > looks like everything is on your own.
> >
> > I don't think you're only using LLM to help understanding the code, thu=
s
> > it looks like implementation is contributed by the LLM.
> >
> > Please remember, you're the one explaining/defending the code.
> > But as long as you can explain/defend the code, I'm fine with that.
> >

My workflow with the LLM was this:

I provided a high level design, reference to the fallocate man page,
pointers to the implementation of clone range in btrfs, and the existing
fallocate implementations (for btrfs, ext4, and xfs). This was a couple
of paragraphs and a handful of links.

I prompted the LLM to produce a detailed design document for how
I could go about implementing insert and collapse for btrfs. The
document it produced is English text of around 2000 words. It
contains references to internal btrfs functions I needed and a
description of the logic I needed to implement. It has no code.

I reviewed that doc, asked clarifications, and the doc was revised.

I then crafted the code. I relied heavily on the design doc that the
LLM had written but did not follow it to the letter. During this
implementation work I asked the LLM to clarify a few points, and
the design doc was revised by the LLM.

During debugging most of the bugs I diagnosed myself. There was one
bug which stumped me however, so I asked the LLM to provide
hypotheses which I then worked through to solve the bug. I crafted
the code for the fix. ( The specific bug was stale/incorrect data being
read after the operation returned. The code was already invalidating
the page cache, but I was not aware of the extent map cache that
needed to be invalidated too. )

I wrote the test code myself.

Once the tests were passing the LLM was used to update the design
doc to align with the code I actually wrote. I also asked the LLM to
review my code prior to submitting it to the mailing list. I addressed
some of that feedback. As an example piece of feedback it
recommended I make use of unlikely() in "if" statements testing for
errors.


> > Still a newcomer with not a small code change will always attract more
> > scrutiny, so please don't expect rapid review/merge/etc.
> >

I am not in a rush. This has been a low-priority side quest going back
to 2023: https://lore.kernel.org/linux-btrfs/CAMosweitbAN5EPOgJCtrbkRAj1QSb=
sYt4uDGVMZ378YY7wjnRw@mail.gmail.com/


--=20
Paul Richards
