Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44513 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197AbbIVPjd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 11:39:33 -0400
Date: Tue, 22 Sep 2015 15:39:30 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: dsterba@suse.cz,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
Message-ID: <20150922153930.GK5918@carfax.org.uk>
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com>
 <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk>
 <20150922142333.GH12815@twin.jikos.cz>
 <20150922143602.GI5918@carfax.org.uk>
 <56016BB5.6060101@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDymnuGqqhW10CwH"
In-Reply-To: <56016BB5.6060101@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qDymnuGqqhW10CwH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2015 at 10:54:45AM -0400, Austin S Hemmelgarn wrote:
> On 2015-09-22 10:36, Hugo Mills wrote:
> >On Tue, Sep 22, 2015 at 04:23:33PM +0200, David Sterba wrote:
> >>On Tue, Sep 22, 2015 at 01:41:31PM +0000, Hugo Mills wrote:
> >>>On Tue, Sep 22, 2015 at 03:36:43PM +0200, Holger Hoffst=E4tte wrote:
> >>>>On 09/22/15 14:59, Jeff Mahoney wrote:
> >>>>(snip)
> >>>>>So if they way we want to prevent the loss of raid type info is by
> >>>>>maintaining the last block group allocated with that raid type, fine,
> >>>>>but that's a separate discussion.  Personally, I think keeping 1GB
> >>>>
> >>>>At this point I'm much more surprised to learn that the RAID type can
> >>>>apparently get "lost" in the first place, and is not persisted
> >>>>separately. I mean..wat?
> >>>
> >>>    It's always been like that, unfortunately.
> >>>
> >>>    The code tries to use the RAID type that's already present to work
> >>>out what the next allocation should be. If there aren't any chunks in
> >>>the FS, the configuration is lost, because it's not stored anywhere
> >>>else. It's one of the things that tripped me up badly when I was
> >>>failing to rewrite the chunk allocator last year.
> >>
> >>Yeah, right now there's no persistent default for the allocator. I'm
> >>still hoping that the object properties will magically solve that.
> >
> >    There's no obvious place that filesystem-wide properties can be
> >stored, though. There's a userspace tool to manipulate the few current
> >FS-wide properties, but that's all special-cased to use the
> >"historical" ioctls for those properties, with no generalisation of a
> >property store, or even (IIRC) any external API for them.
> >
> >    We're nominally using xattrs in the btrfs: namespace on directories
> >and files, and presumably on the top directory of a subvolume for
> >subvol-wide properties, but it's not clear where the FS-wide values
> >should go: in the top directory of subvolid=3D5 would be confusing,
> >because then you couldn't separate the properties for *that subvol*
> >from the ones for the whole FS (say, the default replication policy,
> >where you might want the top subvol to have different properties from
> >everything else).
> Possibly do special names for the defaults and store them there?  In
> general, I personally see little value in having some special
> 'default' properties however.

   That would work.

> The way I would expect things to work is that a new subvolume
> inherits it's properties from it's parent (if it's a snapshot),

   Definitely this.

> or
> from the next higher subvolume it's nested in.

   I don't think I like this. I'm not quite sure why, though, at the
moment.

   It definitely makes the process at the start of allocating a new
block group much more complex: you have to walk back up through an
arbitrary depth of nested subvols to find the one that's actually got
a replication policy record in it. (Because after this feature is
brought in, there will be lots of filesystems without per-subvol
replication policies in them, and we have to have some way of dealing
with those as well).

   With an FS default policy, you only need check the current subvol,
and then fall back to the FS default if that's not found.

   These things are, I think, likely to be lightly used: I would be
reasonably surprised to find more than two or possibly three storage
policies in use on any given system with a sane sysadmin.

   I'm actually not sure what the interactions of multiple storage
policies are going to be like. It's entirely possible, particularly
with some of the more exotic (but useful) suggestions I've thought of,
that the behaviour of the FS is dependent on the order in which the
block groups are allocated. (i.e. "20 GiB to subvol-A, then 20 GiB to
subvol-B" results in different behaviour than "1 GiB to subvol-A then
1 GiB to subvol-B and repeat"). I tried some simple Monte-Carlo
simulations, but I didn't get any concrete results out of it before
the end of the train journey. :)

>  This would obviate
> the need for some special 'default' properties, and would be
> relatively intuitive behavior for a significant majority of people.

   Of course, you shouldn't be nesting subvolumes anyway. It makes
it much harder to manage them.

   Hugo.

--=20
Hugo Mills             | What's a Nazg=FBl like you doing in a place like t=
his?
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                Ill=
iad

--qDymnuGqqhW10CwH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWAXYyAAoJEFheFHXiqx3k60kP/iOHag6g05kC/zQ8tUawDMFq
RXqk7RjlDG882T5ccinQJqbtWjq25MxY4CZZGg3Nw2njkKGG/GAIuADpkuSD6JR6
LGdfb8vIte0LeXFee+mQXzdf05wHaVjsLzHAJ1ODDTWdRz/wfRjehSJh0kU+wGXz
qEYXitbj9ctNCStuWzxn8xaFFlSSVyoUrSJPBWPn/uJsM7yHuM+ZPgz8kWgD/SNF
BdqAzAjQdCyZXbAgN9e98oLnrr20EaOlqislqDhijWzyboxC6zRMSk2F1tzcsvg6
MyEnu/SK1fSE30D2rdjCVBN+RxGHvWPa4ZahXF8BIr2CCdadlXE1DG1QYEDQqivk
1ve7m8Lg1kXm22Avpiy4shpi10t7JfRPJaYfwFRBV2Y8CcJyXnPJ7M4q3d18f/rE
ZJ85v5ZYPTKmVrRZ/qO2poQSvFgOrVSdYoJECJL41Tzyx+gkJukwJ+Km8FBj2Ymj
+oIhNBE5JxqXOpLSoXSBA0EObhRbqwlj82VG57o5AiLBr3ubVbTP5ZKoJr8UA9qU
1VZFhLTY2OGIHGcKp7jl1/xGR5wQeb31QOTaJ5qQ9VS74Xx7dIykFPhpougU+ldm
luFLBt0e9anAMte8vqVv+8eI2gl4/fP36eAMcqljJNh61go4Erw9VyH62D/0yBHX
bmizClLVaXs42CWYPXmc
=41Gk
-----END PGP SIGNATURE-----

--qDymnuGqqhW10CwH--
