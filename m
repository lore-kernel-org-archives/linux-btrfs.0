From: Chris Mason <chris.mason@oracle.com>
Subject: Re: processes stuck in llseek
Date: Thu, 18 Aug 2011 12:00:27 -0400
Message-ID: <1313683211-sup-3134@shiny>
References: <CAPL5yKdvMtCo8qqqJGM-FXk7CmhkY98QeDa8uH=ZDFLjus7Wng@mail.gmail.com> <1313499055-sup-2296@shiny> <CAPL5yKc7wztLatbk-4sVDnTLeiSeeXaXZd45r_rxDhdtR3mtPg@mail.gmail.com> <4E4B181E.8000508@cn.fujitsu.com> <CAKcLGm-c8zEi+=j2M_QjvS3GGJezvN_DTbUwb-tZtjPj9ZhNrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	Dan Merillat <dan.merillat@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	BTRFS Mailing list <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <CAKcLGm-c8zEi+=j2M_QjvS3GGJezvN_DTbUwb-tZtjPj9ZhNrQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mitch Harder's message of 2011-08-18 11:40:17 -0400:
> On Tue, Aug 16, 2011 at 8:23 PM, Li Zefan <lizf@cn.fujitsu.com> wrote=
:
> > Dan Merillat wrote:
> >> On Tue, Aug 16, 2011 at 8:51 AM, Chris Mason <chris.mason@oracle.c=
om> wrote:
> >>> Excerpts from Dan Merillat's message of 2011-08-15 23:59:50 -0400=
:
> >>
> >>> Dan Carpenter sent a patch for this, I'll get it queued up for rc=
3.
> >>
> >> Can you send it? =C2=A0I'd like to test it to see if it fixes my s=
ystem.
> >
> > Here it is.
> >
> > http://marc.info/?l=3Dlinux-btrfs&m=3D131176036219732&w=3D2
> >
>=20
> Doesn't this patch rely on Josef's SEEK_HOLE/SEEK_DATA patch set whic=
h
> isn't in the kernel yet?
>=20
> http://marc.info/?l=3Dlinux-btrfs&m=3D130927580606177&w=3D2

It does, but the hang was reported on 3.1-rc1, which does have Josef's
code.

-chris
