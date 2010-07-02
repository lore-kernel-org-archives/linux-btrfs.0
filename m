From: Roger Leigh <rleigh@debian.org>
Subject: Bug#587253: Atomic replacement of subvolumes is not possible
Date: Fri, 2 Jul 2010 22:39:21 +0100
Message-ID: <20100702213921.GG7799@codelibre.net>
References: <4C263826.1060702@debian.org> <AANLkTinQmObagOuslcRzuuLZe3ViamIs8e-Jgt-bjRvD@mail.gmail.com> <20100630133142.GU1993@think>
Reply-To: Roger Leigh <rleigh@debian.org>, 587253@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UKNXkkdQCYZ6W5l3"
To: Chris Mason <chris.mason@oracle.com>,
	C Anthony Risinger <anthony@extof.me>, daniel@debian.org,
	linux-btrfs@vger.kernel.org, Roger Leigh <rleigh@debian.org>,
	587253@bugs.debian.org
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
In-Reply-To: <20100630133142.GU1993@think>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-ID: <linux-btrfs.vger.kernel.org>


--UKNXkkdQCYZ6W5l3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 30, 2010 at 09:31:42AM -0400, Chris Mason wrote:
> On Sun, Jun 27, 2010 at 07:44:12PM -0500, C Anthony Risinger wrote:
> > On Sat, Jun 26, 2010 at 12:25 PM, Daniel Baumann <daniel@debian.org> wr=
ote:
> > > Hi,
> > >
> > > this is basically a forward from
> > > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D587253
> > >
> > > "rename(2) allows for the atomic replacement of files. =A0Being able =
to
> > > atomically replace subvolume snapshots would be equally invaluable,
> > > since it would permit lock-free replacement of subvolumes.
> > >
> > > =A0% btrfs subvolume snapshot <src> <dest>
> > >
> > > creates dest as a snapshot of src. However, if I want to do the
> > > converse,
> > >
> > > =A0% btrfs subvolume snapshot <dest> <src>
> > >
> > > then <dest> is snapshotted as <src>/<dest>, i.e. not replacing the
> > > original subvolume, but going inside the original subvolume.
> > >
> > > Use case 1:
> > > =A0I have a subvolume of data under active use, which I want to
> > > =A0periodically update. =A0I'd like to do this by atomically
> > > =A0replacing its contents. =A0I can replace the content right now
> > > =A0by deleting the old subvolume and then snapshotting the new
> > > =A0on in its place, but it's racy. =A0It really needs to be
> > > =A0replaced in a single operation, or else there's a small window
> > > =A0where there is no data, and I'd need to resort to some external
> > > =A0locking to protect myself.
>=20
> I'm not sure I understand use case #1.  The problem is that you'll have
> files open in the subvolume and you can't just pull the rug out from
> under them.  Could you tell me a little more about what you're trying to
> do?

This case was slightly contrived, but one example would be that I have
programs using generated/downloaded datasets.  I periodically update
these datasets.  The programs using these datasets should use the old
data or the replacement new data, but not a mixture of the two during
the replacement, hence the need to atomically update.

A real-world example: I download entire genome databases from the
internet which are regularly updated.  Programs querying/analysing
the databases might take a while to run and I might many to run
concurrently.  But, I do need to update them without interrupting
running programs.

> > > Use case 2:
> > > =A0In schroot, we create btrfs subvolume snapshots to get copy-on-
> > > =A0write chroots. =A0This works just fine. =A0We also provide direct
> > > =A0access to the "source" subvolume, but since it could be
> > > =A0snapshotted in an inconsistent state while being updated, we
> > > =A0want to do the following:
> > >
> > > =A0=B7 snapshot source subvolume
> > > =A0=B7 update snapshot
> > > =A0=B7 replace source volume with updated snapshot"
> > >
> > > Please keep roger in the cc for any replies, thanks.
> >=20
> > i am also looking for functionality similar to this, except i would
> > like to be able to replace the DEFAULT subvolume, with an empty or
> > existing subvolume, and put the original default subvolume INSIDE the
> > new root (or drop it completely), outlined by this post and the thread
> > it's in:
> >=20
> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg05278.html
> >=20
> > is there any feedback on these actions?  no one seems to even respond :=
-(
> >=20
> > it would seem we need ways to swap subvolumes around, _including_ the
> > default, providing the on-disk format supports such operations.
>=20
> Moving 'default' generally involves a reboot for the same reasons.  We
> have to worry about open files and their view of the filesystem.  mv on
> a directory won't affect file handles that are open, and renaming
> subvolumes needs to follow a similar model.

Thinking more about the problem, there's some possibilities I'd
like to suggest.  I'm currently unfamiliar with the btrfs internals,
so please forgive me if this is not feasible.

Firstly, would it be possible to swap subvolumes?  Sort of like
pivot_root but to atomically replace one subvolume with another.

  % btrfs subvolume swap /path/to/fs/subvol1 /path/to/fs/subvol2

would exchange /path/to/fs/subvol1 and /path/to/fs/subvol2 so that
the subvol at /path/to/fs/subvol2 would be visible at
/path/to/fs/subvol1 (and vice versa, of course).  Because both
subvolumes remain intact, this shouldn't affect programs with open
files or directories since nothing is deleted.  I guess this is
semantically equivalant to rename(2) of in use directories.  At
least for use case 2, above, this would be sufficient to work around
the lack of atomic replace, since we can then delete the unwanted
subvol.

There's the requirement that programs using the old subvolume still
have access to open files.  I see that since each subvolume is a
separate device, so I assume that deleting a subvolume means any
open filehandles are no longer valid?  A suggestion here: akin to
an unlink(2)ed file remaining open until the last user close()s the
last file descriptor referencing it, would it be possible for the
btrfs subvolume to only be deleted when the last user finishes
referencing it.  i.e. the subvolume deletion is "lazy" so it's no
longer visible/accessible but remains intact until the last file/
directory fd is closed (including processes with this as their cwd).
Or, at least behaving similarly to being in a directory which has
been "rm -rf"ed since this is effectively what we did.

This would allow direct atomic replacement of subvolumes without
impacting on running processes except as would be expected if running
on a traditional filesystem were the directory has been removed.

Lastly, regarding the comments about the default subvolume, ".".
When I first started using btrfs some months ago, I read the
documentation as mkfs.btrfs creating a default subvolume named
"default" similar to the __root__ suggestion and was quite
confused by the actual behaviour.  IMHO, having an initial
default subvolume named "default", "__root__" or whatever
makes a lot of sense compared with by default allowing normal
files to go into ".".  Users who never use subvolumes will never
need to be aware of this, but it will make use of subvolumes
much more straightforward for the rest of us!


Kind regards,
Roger

--=20
  .''`.  Roger Leigh
 : :' :  Debian GNU/Linux             http://people.debian.org/~rleigh/
 `. `'   Printing on GNU/Linux?       http://gutenprint.sourceforge.net/
   `-    GPG Public Key: 0x25BFB848   Please GPG sign your mail.

--UKNXkkdQCYZ6W5l3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwuXIkACgkQVcFcaSW/uEiyogCgrMgqP278xZ67Oyux3qJ6xTsu
H4sAoKI6PS3pwUSH9AzaFfQqmRDLV2Tf
=pKnD
-----END PGP SIGNATURE-----

--UKNXkkdQCYZ6W5l3--
