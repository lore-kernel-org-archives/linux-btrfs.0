Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46634 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753989AbbCCA10 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 19:27:26 -0500
Date: Mon, 2 Mar 2015 19:27:21 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Matt Robinson <git@nerdoftheherd.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Mark Fasheh <mfasheh@suse.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/1] btrfs: Align EOF length to block in extent_same
Message-ID: <20150303002720.GA26622@hungrycats.org>
References: <1422295551-25402-1-git-send-email-git@nerdoftheherd.com>
 <20150128125521.GD3641@twin.jikos.cz>
 <CABJ34CJR=AjAavwct4v9ud_62mSSzd3StivGHqfhNXBjGTuvjA@mail.gmail.com>
 <CABJ34CJO7rSOOOyxZy=gym7V2dzDtjnFaTXHN1Vcu_+rmaF64w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
In-Reply-To: <CABJ34CJO7rSOOOyxZy=gym7V2dzDtjnFaTXHN1Vcu_+rmaF64w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I second this.  I've seen the same behavior.

Clone seems to have evolved a little further than extent-same knows about.
e.g. there is code in the extent-same ioctl that tries to avoid doing
a clone from within one inode to elsewhere in the same inode; however,
the clone ioctl (which extent-same calls) has no such restriction.

As Matt mentioned, clone_range seems quite happy to accept a partial block
at EOF.  cp --reflink would be much harder to use if it did not.

On Mon, Mar 02, 2015 at 08:59:11PM +0000, Matt Robinson wrote:
> Hi David,
>=20
> Have you had a chance to look at this?  Am very happy to answer
> further questions, adjust my implementation, provide a different kind
> of test case, etc.
>=20
> Many Thanks,
>=20
> Matt
>=20
> On 28 January 2015 at 19:46, Matt Robinson <git@nerdoftheherd.com> wrote:
> > On 28 January 2015 at 12:55, David Sterba <dsterba@suse.cz> wrote:
> >> On Mon, Jan 26, 2015 at 06:05:51PM +0000, Matt Robinson wrote:
> >>> It is not currently possible to deduplicate the last block of files
> >>> whose size is not a multiple of the block size, as the btrfs_extent_s=
ame
> >>> ioctl returns -EINVAL if offset + size is greater than the file size =
or
> >>> is not aligned to the fs block size.
> >>
> >> Do you have a reproducer for that?
> >
> > I've been using the (quick and dirty) bash script at the end of this
> > mail which uses btrfs-extent-same from
> > https://github.com/markfasheh/duperemove/ to call the ioctl.  To
> > summarize: it creates a new filesystem, creates a file with a size
> > which is not a multiple of the block size, copies it, and then calls
> > the ioctl to ask firstly for all of the complete blocks (for
> > comparison) and then the entire files to be deduplicated.
> >
> > Running the script under a kernel compiled from
> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git gives
> > a status of -22 from the second btrfs-extent-same call and the final
> > btrfs filesystem df shows:
> > Data, single: total=3D8.00MiB, used=3D1.91MiB
> >
> > However, running under the same kernel plus my patch shows this final
> > data usage:
> > Data, single: total=3D8.00MiB, used=3D980.00KiB
> >
> >> The alignment is required to let btrfs_clone and the extent dropping
> >> functions to work. [...]
> >
> > Which is why it is currently not possible to deduplicate a final
> > incomplete block of a file:
> > * Passing len + offset =3D the actual end of the file: Rejected as it is
> > not aligned
> > * Passing len + offset =3D the end of the block: Rejected as it exceeds
> > the actual end of the file.
> >
> > Please let me know if you need any further information, if my
> > implementation should be different or there is a better way I could
> > demonstrate the issue?
> >
> > Many Thanks,
> >
> > Matt
> >
> > ---
> >
> > #!/bin/bash -e
> >
> > if [[ $EUID -ne 0 ]]; then
> >    echo "This script must be run as root"
> >    exit 1
> > fi
> >
> > loopback=3D$(losetup -f)
> >
> > echo "## Create new btrfs filesystem on a loopback device"
> > dd if=3D/dev/zero of=3Dtestfs bs=3D1048576 count=3D1500
> > losetup $loopback testfs
> > mkfs.btrfs $loopback
> > mkdir testfsmnt
> > mount $loopback testfsmnt
> >
> > echo -e "\n## Create 1000000 byte random file"
> > dd if=3D/dev/urandom of=3Dtestfsmnt/test1 bs=3D1000000 count=3D1
> > echo
> > btrfs filesystem sync testfsmnt
> > btrfs filesystem df testfsmnt
> >
> > echo -e "\n## Copy file"
> > cp testfsmnt/test1 testfsmnt/test2
> > echo
> > btrfs filesystem sync testfsmnt
> > btrfs filesystem df testfsmnt
> >
> > echo -e "\n## Dedupe to end of last full block"
> > btrfs-extent-same 999424 testfsmnt/test1 0 testfsmnt/test2 0
> > echo
> > btrfs filesystem sync testfsmnt
> > btrfs filesystem df testfsmnt
> >
> > echo -e "\n## Dedupe to end of file"
> > btrfs-extent-same 1000000 testfsmnt/test1 0 testfsmnt/test2 0
> > echo
> > btrfs filesystem sync testfsmnt
> > btrfs filesystem df testfsmnt
> >
> > echo -e "\nClean up"
> > umount testfsmnt
> > rmdir testfsmnt
> > losetup -d $loopback
> > rm testfs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlT0/+gACgkQgfmLGlazG5ycQgCgrHi+yNix2Uw3zcTjGXeaYioJ
TqcAn0gpLq1955KB+yDmlZN8TkamA/Af
=Wmrh
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
