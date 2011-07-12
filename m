From: Chris Mason <chris.mason@oracle.com>
Subject: Re: last_index variable in btrfs_buffered_write function
Date: Tue, 12 Jul 2011 10:11:20 -0400
Message-ID: <1310479850-sup-3754@shiny>
References: <28FB38ED-FC82-4EAD-BED8-330C8FA9AF83@gmail.com> <CAKcLGm_wag+9zEwt-=6uNpG203EP+vHcOA9NG0t=xJACiiOGuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: =?utf-8?q?Jo=C3=A3o_Eduardo_Lu=C3=ADs?= <jecluis@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <CAKcLGm_wag+9zEwt-=6uNpG203EP+vHcOA9NG0t=xJACiiOGuQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mitch Harder's message of 2011-07-11 15:38:45 -0400:
> 2011/7/11 Jo=C3=A3o Eduardo Lu=C3=ADs <jecluis@gmail.com>:
> > Hello.
> >
> > Am I reading the code the wrong way, or is the 'last_index' variabl=
e in '__btrfs_buffered_write()' (and previously used in 'btrfs_file_aio=
_write()') irrelevant?
> >
> > It appears to just be used in 'prepare_pages()', passed as an argum=
ent, but never actually used by this function.
> >
> > Furthermore, I'm not sure what is intended with this variable, but =
if the idea is to assign it with the =C2=A0last page in the range, then=
 I would say that instead of
> >
> >> last_index =3D (pos + iov_iter_count(i)) >> PAGE_CACHE_SHIFT;
> >
> > it should be
> >
> >> =C2=A0last_index =3D (pos + iov_iter_count(i) - 1) >> PAGE_CACHE_S=
HIFT;
> >
> > Then again, I may be missing something.
> >
> > Cheers.
> >
>=20
> I came to the same conclusion a few months ago when looking at a bug
> in the same area of code.
>=20
> The calculation appears to be wrong, but since it's not used anywhere=
,
> you can't say for certain.  :)
>=20
> I just haven't gotten around to testing a patch to confirm the hypoth=
esis.

I'd say it is a victim of a cleanup that didn't completely clean it up.
It is unused ;)

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
