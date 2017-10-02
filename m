Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42934 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdJBJBb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 05:01:31 -0400
Date: Mon, 2 Oct 2017 09:01:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: subvol: change subvol set-default to
 also accept subvol path
Message-ID: <20171002090129.GB3293@carfax.org.uk>
References: <5008967a-9da9-ad91-65e9-bcfbfb07feb0@jp.fujitsu.com>
 <CAA91j0WQ35e5KaZAEe_amwuDMazuAa6Mx1y3P18Y7EGvpxmAHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
In-Reply-To: <CAA91j0WQ35e5KaZAEe_amwuDMazuAa6Mx1y3P18Y7EGvpxmAHQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 02, 2017 at 11:39:05AM +0300, Andrei Borzenkov wrote:
> On Mon, Oct 2, 2017 at 11:19 AM, Misono, Tomohiro
> <misono.tomohiro@jp.fujitsu.com> wrote:
> > This patch changes "subvol set-default" to also accept the subvolume path
> > for convenience.
> >
> > This is the one of the issue on github:
> > https://github.com/kdave/btrfs-progs/issues/35
> >
> > If there are two args, they are assumed as subvol id and path to the fs
> > (the same as current behavior), and if there is only one arg, it is assumed
> > as the path to the subvolume. Therefore there is no ambiguity between subvol
> > id and subvol name, which is mentioned in the above issue page.
> >
> > Only the absolute path to the subvolume is allowed, for the safety when
> > multiple filesystems are used.
> >
> > subvol id is resolved by get_subvol_info() which is used by "subvol show".
> >
> > change to v2:
> > restrict the path to only allow absolute path.
> 
> This is absolutely arbitrary restriction. Why we can do "btrfs
> subvolume create ./relative/path" but cannot do "btrfs subvolume
> set-default ./relative/path"?

   Indeed. In fact, it's precisely the _opposite_ of the way that
every other command works -- you provide the path to the subvolume in
the *current namespace*.

   This approach would be just a major misfeature at this point.

   Hugo.

> > documents are updated accordingly.
> >
> > Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> > ---
> >  Documentation/btrfs-subvolume.asciidoc | 11 +++----
> >  cmds-subvolume.c                       | 53 +++++++++++++++++++++++++++-------
> >  2 files changed, 48 insertions(+), 16 deletions(-)
> >
> > diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
> > index 5cfe885..7973567 100644
> > --- a/Documentation/btrfs-subvolume.asciidoc
> > +++ b/Documentation/btrfs-subvolume.asciidoc
> > @@ -142,12 +142,13 @@ you can add \'\+' or \'-' in front of each items, \'+' means ascending,
> >  for --sort you can combine some items together by \',', just like
> >  --sort=+ogen,-gen,path,rootid.
> >
> > -*set-default* <id> <path>::
> > -Set the subvolume of the filesystem <path> which is mounted as
> > -default.
> > +*set-default* [<path>|<id> <mountpoint>]::
> > +Set the subvolume of the filesystem which is mounted as default.
> >  +
> > -The subvolume is identified by <id>, which is returned by the *subvolume list*
> > -command.
> > +Only absolute path is allowed to specify the subvolume.
> > +Alterantively, the pair of <id> and <mountpoint> can be used. In that
> > +case, the subvolume is identified by <id>, which is returned by the
> > +*subvolume list* command. The filesystem is specified by <mountpoint>.
> >
> >  *show* <path>::
> >  Show information of a given subvolume in the <path>.
> > diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> > index 666f6e0..dda9e73 100644
> > --- a/cmds-subvolume.c
> > +++ b/cmds-subvolume.c
> > @@ -803,28 +803,59 @@ out:
> >  }
> >
> >  static const char * const cmd_subvol_set_default_usage[] = {
> > -       "btrfs subvolume set-default <subvolid> <path>",
> > -       "Set the default subvolume of a filesystem",
> > +       "btrfs subvolume set-default [<path>|<id> <mountpoint>]",
> > +       "Set the default subvolume of the filesystem mounted as default.",
> > +       "The subvolume can be specified by its absolute path,",
> > +       "or the pair of subvolume id and mount point to the filesystem.",
> >         NULL
> >  };
> >
> >  static int cmd_subvol_set_default(int argc, char **argv)
> >  {
> > -       int     ret=0, fd, e;
> > -       u64     objectid;
> > -       char    *path;
> > -       char    *subvolid;
> > -       DIR     *dirstream = NULL;
> > +       int ret = 0;
> > +       int fd, e;
> > +       u64 objectid;
> > +       char *path;
> > +       char *subvolid;
> > +       DIR *dirstream = NULL;
> >
> >         clean_args_no_options(argc, argv, cmd_subvol_set_default_usage);
> >
> > -       if (check_argc_exact(argc - optind, 2))
> > +       if (check_argc_min(argc - optind, 1) ||
> > +                       check_argc_max(argc - optind, 2))
> >                 usage(cmd_subvol_set_default_usage);
> >
> > -       subvolid = argv[optind];
> > -       path = argv[optind + 1];
> > +       if (argc - optind == 1) {
> > +               /* path to the subvolume is specified */
> > +               struct root_info ri;
> > +               char *fullpath;
> >
> > -       objectid = arg_strtou64(subvolid);
> > +               path = argv[optind];
> > +               if (path[0] != '/') {
> > +                       error("only absolute path is allowed");
> > +                       return 1;
> > +               }
> > +
> > +               fullpath = realpath(path, NULL);
> > +               if (!fullpath) {
> > +                       error("cannot find real path for '%s': %s",
> > +                               path, strerror(errno));
> > +                       return 1;
> > +               }
> > +
> > +               ret = get_subvol_info(fullpath, &ri);
> > +               free(fullpath);
> > +
> > +               if (ret)
> > +                       return 1;
> > +
> > +               objectid = ri.root_id;
> > +       } else {
> > +               /* subvol id and path to the filesystem are specified */
> > +               subvolid = argv[optind];
> > +               path = argv[optind + 1];
> > +               objectid = arg_strtou64(subvolid);
> > +       }
> >
> >         fd = btrfs_open_dir(path, &dirstream, 1);
> >         if (fd < 0)

-- 
Hugo Mills             | Great oxymorons of the world, no. 4:
hugo@... carfax.org.uk | Future Perfect
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZ0gBpAAoJEFheFHXiqx3kFzUP/i8l9vsHRCP481kTY0uZeHp3
0+75ITb17xq7auCVk8j8dOfD63MbdBzrPCzSCwWnoLuCdQ7mI9ksmtWQydejmkEf
RavhYjzjOdeXkwwNJfkzad2ONwo7/2GQ3UpRpJEdvywtJiUtP7bfiaY9JEYKa98R
odQV09ketJQb51IIQtSlIlPWUveBtDgbCZCanmT8XNNBkiRedUJKlANgLVlQYB+F
MYDdKrolz/XnmjIJ1vcS+8ZGaegM5URqjPvouz7lgSFhEIIU+VLzE9mh572tNTmO
/p2CDLhju+8yTYvfp50skRSZNsulgVJy4hc60wDTSdTQQfWX3SbMcd0Vdd4a2ubq
vWg23ew90d6nr63cAw9mxgGnn2/fqjOGTkkJ4eQMc88rk3GNi5zHohuHN2QQV/Z9
VrYvhmjcAFtX72rjeFW/xnNeQshvyDhpyGOWdSCm5nHZq8Gc2UmfxmZ0iWDB9ouz
pJy8K48iTyGL36bdJA8gpVp5tKri5q2wqQ9hg9b5aZwHs51PSVPDMHIdVz9JNcEk
EIHU6gf1sTiP72gRRNNXCs6yw5MhXIXGUbFmuAJtJj7HOqwXRUB4kjNBRUj1hk4C
P93J4xtohIjp6VjfEcTBN2gJcaqstpMj/gepg7rEC/pSWUFJt4/yJsAw/qgMjZm8
TeYCBc0umHBOEJnNvM+v
=OnRj
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
