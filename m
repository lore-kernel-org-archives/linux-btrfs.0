Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47000 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751976AbcJLMcX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 08:32:23 -0400
Date: Wed, 12 Oct 2016 08:22:52 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Filipe Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix silent data corruption while reading
 compressed inline extents
Message-ID: <20161012122252.GC26140@hungrycats.org>
References: <1476239328-24649-1-git-send-email-ce3g8jdj@umail.furryterror.org>
 <CAL3q7H7ADJy9ERaVsvgp4vrVdQ4ObHRikmE7SBELSNC5g3an2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
In-Reply-To: <CAL3q7H7ADJy9ERaVsvgp4vrVdQ4ObHRikmE7SBELSNC5g3an2Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 12, 2016 at 09:59:03AM +0100, Filipe Manana wrote:
> On Wed, Oct 12, 2016 at 3:28 AM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> > rsync -S causes a large number of small writes separated by small seeks
> > to form sparse holes in files that contain runs of zero bytes.  Rarely,
> > this can lead btrfs to write a file with a compressed inline extent
> > followed by other data, like this:
> >
> > Filesystem type is: 9123683e
> > File size of /try/./30/share/locale/nl/LC_MESSAGES/tar.mo is 61906 (16 =
blocks of 4096 bytes)
> >  ext:     logical_offset:        physical_offset: length:   expected: f=
lags:
> >    0:        0..    4095:          0..      4095:   4096:             e=
ncoded,not_aligned,inline
> >    1:        1..      15:     331372..    331386:     15:          1: l=
ast,encoded,eof
> > /try/./30/share/locale/nl/LC_MESSAGES/tar.mo: 2 extents found
>=20
> So that's the problem. We should never have non-inlined extents after
> an inline extent (this causes problems in many places) - the only
> exception is for pre-allocated extents created with fallocate using
> its flag FALLOC_FL_KEEP_SIZE (so that the inode size doesn't change).
>=20
> btrfs_cont_expand() is responsible for inserting holes, and for the
> first page, which is where the inline extent belongs to, it pads it
> with zeroes (done through btrfs_truncate_block()). So the bug here is
> some corner case where we don't do this hole expansion thing and end
> up with an inline extent followed by some non-inlined one and with an
> isize (file size) greater than the uncompressed size of the inline
> extent.
>=20
> Given how hard the bug is to trigger with your reproducer below, and
> that you didn't find a way to trigger it using deterministic steps
> like for example:
>=20
> for ((i =3D 1; i <=3D 1000; i++)); do
> umount /dev/sdd &> /dev/null
> mkfs.btrfs -f /dev/sdd > /dev/null
> mount -o compress=3Dlzo /dev/sdd /mnt/sdd
> xfs_io -f -c "pwrite -S 0xaa 0 1500" /mnt/sdd/foobar > /dev/null
> sync
> xfs_io -c "pwrite -S 0xbb 1M 4K" /mnt/sdd/foobar > /dev/null
> DIGEST1=3D$(md5sum /mnt/sdd/foobar | cut -d ' ' -f 1)
> echo 3 > /proc/sys/vm/drop_caches
> DIGEST2=3D$(md5sum /mnt/sdd/foobar | cut -d ' ' -f 1)
> echo -e "\n\nIteration $i\n"
> echo "Digest1 =3D $DIGEST1"
> echo "Digest2 =3D $DIGEST2"
> echo
> if [ "$DIGEST1" !=3D "$DIGEST2" ]; then
> exit 1
> fi
> done
>=20
> It's more than evidence that your fix is only hidding away the real probl=
em.

There are two problems here:  one is that something is creating these bad
extents, and the other is that existing filesystems are full of them.
e.g. my Linux kernel build machines generate hundreds of these per month.

This patch only solves the second part of the problem--getting the data
back from existing bad extents.

Also note that we "hide" the problem already for uncompressed extents
by doing a similar memset.

> Once it's figured out why this happens, we should ideally have a
> deterministic or easy to trigger reproducer for xfstests.
>=20
> thanks
>=20
> >
> > The inline extent size is less than the page size, so the ram_bytes fie=
ld
> > in the extent is smaller than 4096.  The difference between ram_bytes a=
nd
> > the end of the first page of the file forms a small hole.  Like any oth=
er
> > hole, the correct value of each byte within the hole is zero.
> >
> > When the inline extent is not compressed, btrfs_get_extent copies the
> > inline extent data and then memsets the remainder of the page to zero.
> > There is no corruption in this case.
> >
> > When the inline extent is compressed, uncompress_inline uses the
> > ram_bytes field from the extent ref as the size of the uncompressed dat=
a.
> > ram_bytes is smaller than the page size, so the remainder of the page
> > (i.e. the bytes in the small hole) is uninitialized memory.  Each time =
the
> > extent is read into the page cache, userspace may see different content=
s.
> >
> > Fix this by zeroing out the difference between the size of the
> > uncompressed inline extent and PAGE_CACHE_SIZE in uncompress_inline.
> >
> > Only bytes within the hole are affected, so affected files can be read
> > correctly with a fixed kernel.  The corruption happens after IO and
> > checksum validation, so the corruption is never reported in dmesg or
> > counted in dev stats.
> >
> > The bug is at least as old as 3.5.7 (the oldest kernel I can convenient=
ly
> > test), and possibly much older.
> >
> > The code may not be correct if the extent is larger than a page, so add
> > a WARN_ON for that case.
> >
> > To reproduce the bug, run this on a 3072M kvm VM:
> >
> >         #!/bin/sh
> >         # Use your favorite block device here
> >         blk=3D/dev/vdc
> >
> >         # Create test filesystem and mount point
> >         mkdir -p /try
> >         mkfs.btrfs -dsingle -mdup -O ^extref,^skinny-metadata,^no-holes=
 -f "$blk" || exit 1
> >         mount -ocompress-force,flushoncommit,max_inline=3D8192,noatime =
"$blk" /try || exit 1
> >
> >         # Create a few inline extents in larger files.
> >         # Multiple processes seem to be necessary.
> >         y=3D/usr; for x in $(seq 10 19); do rsync -axHSWI "$y/." "$x"; =
y=3D"$x"; done &
> >         y=3D/usr; for x in $(seq 20 29); do rsync -axHSWI "$y/." "$x"; =
y=3D"$x"; done &
> >         y=3D/usr; for x in $(seq 30 39); do rsync -axHSWI "$y/." "$x"; =
y=3D"$x"; done &
> >         y=3D/usr; for x in $(seq 40 49); do rsync -axHSWI "$y/." "$x"; =
y=3D"$x"; done &
> >         wait
> >
> >         # Make a list of the files with inline extents
> >         touch /try/list
> >         find -type f -size +4097c -exec sh -c 'for x; do if filefrag -v=
 "$x" | sed -n "4p" | grep -q "inline"; then echo "$x" >> list; fi; done' -=
- {} +
> >
> >         # Check the inline extents to see if they change as they are re=
ad multiple times
> >         while read -r x; do
> >                 sum=3D"$(sha1sum "$x")"
> >                 for y in $(seq 0 99); do
> >                         sysctl vm.drop_caches=3D1
> >                         sum2=3D"$(sha1sum "$x")"
> >                         if [ "$sum" !=3D "$sum2" ]; then
> >                                 echo "Inconsistent reads from '$x'"
> >                                 exit 1
> >                         fi
> >                 done
> >         done < list
> >
> > The reproducer may need to run up to 20 times before it finds a
> > corruption.
> >
> > Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> > ---
> >  fs/btrfs/inode.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index e6811c4..34f9c80 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -6791,6 +6791,12 @@ static noinline int uncompress_inline(struct btr=
fs_path *path,
> >         max_size =3D min_t(unsigned long, PAGE_SIZE, max_size);
> >         ret =3D btrfs_decompress(compress_type, tmp, page,
> >                                extent_offset, inline_size, max_size);
> > +       WARN_ON(max_size > PAGE_SIZE);
> > +       if (max_size < PAGE_SIZE) {
> > +               char *map =3D kmap(page);
> > +               memset(map + max_size, 0, PAGE_SIZE - max_size);
> > +               kunmap(page);
> > +       }
> >         kfree(tmp);
> >         return ret;
> >  }
> > --
> > 2.1.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20
> --=20
> Filipe David Manana,
>=20
> "People will forget what you said,
>  people will forget what you did,
>  but people will never forget how you made them feel."
>=20

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlf+KxwACgkQgfmLGlazG5zwVQCfbdGVa1vnQbBv9xr9TWsNGi5L
dzUAniZTzGqo0jK1ZHF+otFfRtR8QSg6
=IhfF
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--
