Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46842 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbcE1B7Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 21:59:24 -0400
Date: Fri, 27 May 2016 21:59:22 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Adam Borowski <kilobyte@angband.pl>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs,vfs: allow FILE_EXTENT_SAME on a file opened ro
Message-ID: <20160528015922.GI15597@hungrycats.org>
References: <1463715912-8005-1-git-send-email-kilobyte@angband.pl>
 <20160527000401.GW7633@wotan.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kadn00tgSopKmJ1H"
In-Reply-To: <20160527000401.GW7633@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--kadn00tgSopKmJ1H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 26, 2016 at 05:04:01PM -0700, Mark Fasheh wrote:
> On Fri, May 20, 2016 at 05:45:12AM +0200, Adam Borowski wrote:
> > (Only btrfs currently implements dedupe_file_range.)
> >=20
> > Instead of checking the mode of the file descriptor, let's check whether
> > it could have been opened rw.  This allows fixing failures when deduping
> > a live system: anyone trying to exec a file currently being deduped gets
> > ETXTBSY.

Isn't there another copy of this check in fs/btrfs/ioctl.c?

> > Issuing this ioctl on a ro file was already allowed for root/cap.
> >=20
> > Signed-off-by: Adam Borowski <kilobyte@angband.pl>
>=20
> Hi Adam, this patch seems reasonable to me but I have to admit to being
> worried about 'unintended consequences'. I poked around the code in fs/ f=
or
> a bit and saw mostly checks against file open mode. It might be that dedu=
pe
> is a special case due to the potential for longer running operations,=20

The length of the operation is irrelevant.

If dedup is run over frequently executed files (e.g. /bin/sh), opening
the files in write mode will randomly disrupt some normal execution no
matter how quickly the dedup agent opens and closes the files.

The interference works both ways, too:  if a file is already being
executed, it can't be opened with write access.   Executables often
run for extended periods of time, effectively preventing them from ever
being deduped by non-root users.

Executables are often really good candidates for dedup, so we don't want
to avoid them.  Executable files on build servers are often duplicated
several times over in various .o and .a files and install/packaging trees.

> theoretically you'd see the same problem if trying to exec against a file
> being cloned too, correct? If that's the case then I wonder how this issue
> gets solved for other ioctls.

Clone could be used to change the content of the destination file, so
it is right to insist on having the file opened for writing in that case.

Dedupe is an unusual case because it will never change the content of
the destination file even if it is opened *with* write access.  The
defrag ioctl is similar in this respect.

Opening either dedup or defrag to non-root O_RDONLY access does have
some concerns.  It could be used to create a lot of extra I/O load,
particularly write load, that might otherwise be denied to an unprivileged
user...but then, so can repeatedly calling sync(), so maybe this isn't
a real problem.

There is a potential risk of exposing bugs in other parts of the system
(e.g. the various recently fixed dedup races) but whatever those bugs are,
we had them already without changing the permission checks.

I wonder if there is a risk of damaging files like this:

	open A O_RDWR

	open B O_RDONLY

	copy B to A

	do _not_ call fsync() here

	dedup(A, B)

	do _not_ call fsync() here either

	some time passes

	power fail

If A's extent isn't flushed to disk, what happens to B?  Does dedup imply
fsync or data ordering such that A is written to disk before the extent
ref in B is updated, or can the content of B change?  If root is running
dedup, we can assume that whoever authorized root code execution also made
sure that this case never arises (e.g. by ensuring the dedup agent always
calls fsync, or otherwise ensuring that the extent at A is stable on disk
before calling dedup).  If we allow non-root to do this then we have no
such assurance--but on the other hand maybe the assurance is weak and
bad things can happen here already even if we require root privilege.

I also wonder what happens if an executable that has called
mlockall(MCL_FUTURE) gets its pages replaced by a deduped extent while
it's running...do the replaced pages become un-mlockall-ed?  Is the VFS
smart enough to swap in the new pages?  Am I just silly and insane for
expecting shared mmap() to have meaningful real-time properties on btrfs?


--kadn00tgSopKmJ1H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldI+3oACgkQgfmLGlazG5yzPACgpVjM8zymqvuhv+CLVOgMcRsS
IQMAn13PmR7BoNKY0Ebc4tdiPfMUfS3e
=gCiK
-----END PGP SIGNATURE-----

--kadn00tgSopKmJ1H--
