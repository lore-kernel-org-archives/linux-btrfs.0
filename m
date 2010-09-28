From: Francis Galiegue <fgaliegue@gmail.com>
Subject: Re: Francis Galiegue would like your help testing a survey
Date: Tue, 28 Sep 2010 20:47:14 +0200
Message-ID: <AANLkTikoYwSkVyTqX1LLLzCDp_nELVxm7WqJa1ffqkZb@mail.gmail.com>
References: <201009281427.o8SERvXj025316@84872-app3.sgizmo.com>
	<4CA2092A.8020207@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CA2092A.8020207@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

[cc: list]

On Tue, Sep 28, 2010 at 17:26, K. Richard Pixley <rich@noir.com> wrote:
> =C2=A0#2 needs an answer dealing with "stability". =C2=A0Unstable doe=
sn't necessarily
> mean polluted file systems. =C2=A0It can also mean pathological behav=
ior, kernel
> crashes, etc.
>

Yes, indeed. Fixed.

> #4 needs an answer that involves performance - btrfs is, (arguably), =
the
> fastest file system currently available for linux in many situations.=
 =C2=A0That
> answer alone is a serious selling point.
>
> Another selling point for #4 is file system hardening. =C2=A0ext2 is =
still fast,
> but it can't generally survive power failures. =C2=A0If you're specif=
ically
> looking for a fast file system, then the fact that btrfs competes wel=
l in
> speed and is also hardened becomes a selling point.
>

Well, performance is not touted as a key feature on the btrfs wiki. I
have added "good overall performance" in the list of choices, though.

As to file system hardening, what do you mean apart from checksums?
=46undamental filesystem design?

> #15 presupposes it's own answer. =C2=A0While I've had no filesystems =
fail, every
> machine I use with btrfs file systems has failed numerous times -
> pathological behavior, kernel crashes, etc. =C2=A0In the absence of a=
 btrfsck I
> can't be sure that the file system has actually failed although rebui=
lding
> the file system seems to alleviate the symptoms temporarily.
>

I don't really see your point here. Can you elaborate? And yes, I _do_
mean filesystem failures, not machine failure. I made that explicit.

> #16 presupposes a failure mode.=C2=A0Again, my issues have more to do=
 with
> stability than with clear cases of file system pollution.
>

Point taken, but again, this is on purpose, I talk here about hosed
filesystems indeed.

Thanks for the feedback!
--=20
=46rancis Galiegue, fgaliegue@gmail.com
"It seems obvious [...] that at least some 'business intelligence'
tools invest so much intelligence on the business side that they have
nothing left for generating SQL queries" (St=C3=A9phane Faroult, in "Th=
e
Art of SQL", ISBN 0-596-00894-5)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
