Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23873C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 17:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8B0D2083E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 17:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfBTRRL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 12:17:11 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46124 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfBTRRK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 12:17:10 -0500
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id D46CE22B27E; Wed, 20 Feb 2019 12:17:08 -0500 (EST)
Date:   Wed, 20 Feb 2019 12:17:08 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] Btrfs: check if destination root is read-only for
 deduplication
Message-ID: <20190220171708.GG9995@hungrycats.org>
References: <20181212180559.15249-1-fdmanana@kernel.org>
 <20181212180559.15249-4-fdmanana@kernel.org>
 <20181213160740.GE23615@twin.jikos.cz>
 <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
 <20190220164140.GF9995@hungrycats.org>
 <CAL3q7H455MCpj_-5U=zUzD3Of7aLtG6R_tHdGhZ4Kj-393sWAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ILuaRSyQpoVaJ1HG"
Content-Disposition: inline
In-Reply-To: <CAL3q7H455MCpj_-5U=zUzD3Of7aLtG6R_tHdGhZ4Kj-393sWAg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--ILuaRSyQpoVaJ1HG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 20, 2019 at 04:54:09PM +0000, Filipe Manana wrote:
> On Wed, Feb 20, 2019 at 4:42 PM Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> >
> > On Thu, Jan 31, 2019 at 04:39:22PM +0000, Filipe Manana wrote:
> > > On Thu, Dec 13, 2018 at 4:08 PM David Sterba <dsterba@suse.cz> wrote:
> > > >
> > > > On Wed, Dec 12, 2018 at 06:05:58PM +0000, fdmanana@kernel.org wrote:
> > > > > From: Filipe Manana <fdmanana@suse.com>
> > > > >
> > > > > Checking if the destination root is read-only was being performed=
 only for
> > > > > clone operations. Make deduplication check it as well, as it does=
 not make
> > > > > sense to not do it, even if it is an operation that does not chan=
ge the
> > > > > file contents (such as defrag for example, which checks first if =
the root
> > > > > is read-only).
> > > >
> > > > And this is also change in user-visible behaviour of dedupe, so this
> > > > needs to be verified if it's not breaking existing tools.
> > >
> > > Have you had the chance to do such verification?
> > >
> > > This actually conflicts with send. Send does not expect a root/tree to
> > > change, and with dedupe on read-only roots happening
> > > in parallel with send is going to cause all sorts of unexpected and
> > > undesired problems...
> >
> > This is a problem bees ran into.  There is a workaround in bees (called
> > --workaround-btrfs-send) that avoids RO subvols as dedupe targets.
> > As the name of the option implies, it works around problems in btrfs se=
nd.
> >
> > This kernel change makes the workaround mandatory now, as the default
> > case (without workaround) will fail on every RO subvol even if that
> > behavior is desired by the user.  That breaks an important use case on
> > the receiving side of sends--to dedupe the received subvols together
> > while also protecting them against modification on the target system
> > with the RO flag--and preserving that use case is why the send workarou=
nd
> > was optional (and not default) in bees.
> >
> > bees also won't handle the RO/RW/RO transition correctly, as it didn't
> > seem like a sane thing to support at the time.  That is arguably someth=
ing
> > to be fixed in bees.
> >
> > > This is a problem introduced by dedupe ioctl when it landed, since
> > > send existed for a longer time (when nothing else was
> > > allowed to change read-only roots, including defrag).
> >
> > Is there a reason why incremental send can't simply be fixed?
>=20
> This is a problem that affects both incremental and non-incremental (full=
) send.
>=20
> > As far
> > as I can tell, send is failing because of a runtime check that seems to
> > be too strict; however, I haven't tried removing that check to see if
> > it fixes the problem in send, or just hides the next problem.
>=20
> The problem is send was designed with the idea that read-only roots
> don't ever change.

=2E..except when they're snapshotted, balanced, or deduped (to list places
where that assumption hasn't held so far).

> The failures that can happen are many and unpredictable, from
> occasionally failing with some error, to invalid memory accesses, use
> after free problems, etc.
> Essentially all caused by races when the nodes/leafs from the
> read-only tree change while send is running.

Maybe you can explain this further?  As far as I can tell, all of those
are send bugs that should just be (and over the years have been) fixed.

> I don't know what runtime check you are mentioning that is too strict.

It's this one, in send.c:

                        /*
                         * We may have found an extent item that has changed
                         * only its disk_bytenr field and the corresponding
                         * inode item was not updated. This case happens du=
e to
                         * very specific timings during relocation when a l=
eaf
                         * that contains file extent items is COWed while
                         * relocation is ongoing and its in the stage where=
 it
                         * updates data pointers. So when this happens we c=
an
                         * safely ignore it since we know it's the same ext=
ent,
                         * but just at different logical and physical locat=
ions
                         * (when an extent is fully replaced with a new one=
, we
                         * know the generation number must have changed too,
                         * since snapshot creation implies committing the c=
urrent
                         * transaction, and the inode item must have been u=
pdated
                         * as well).
                         * This replacement of the disk_bytenr happens at
                         * relocation.c:replace_file_extents() through
                         * relocation.c:btrfs_reloc_cow_block().
                         */
                        if (btrfs_file_extent_generation(leaf_l, ei_l) =3D=
=3D
                            btrfs_file_extent_generation(leaf_r, ei_r) &&
                            btrfs_file_extent_ram_bytes(leaf_l, ei_l) =3D=3D
                            btrfs_file_extent_ram_bytes(leaf_r, ei_r) &&
                            btrfs_file_extent_compression(leaf_l, ei_l) =3D=
=3D
                            btrfs_file_extent_compression(leaf_r, ei_r) &&
                            btrfs_file_extent_encryption(leaf_l, ei_l) =3D=
=3D
                            btrfs_file_extent_encryption(leaf_r, ei_r) &&
                            btrfs_file_extent_other_encoding(leaf_l, ei_l) =
=3D=3D
                            btrfs_file_extent_other_encoding(leaf_r, ei_r) =
&&
                            btrfs_file_extent_type(leaf_l, ei_l) =3D=3D
                            btrfs_file_extent_type(leaf_r, ei_r) &&
                            btrfs_file_extent_disk_bytenr(leaf_l, ei_l) !=3D
                            btrfs_file_extent_disk_bytenr(leaf_r, ei_r) &&
                            btrfs_file_extent_disk_num_bytes(leaf_l, ei_l) =
=3D=3D
                            btrfs_file_extent_disk_num_bytes(leaf_r, ei_r) =
&&
                            btrfs_file_extent_offset(leaf_l, ei_l) =3D=3D
                            btrfs_file_extent_offset(leaf_r, ei_r) &&
                            btrfs_file_extent_num_bytes(leaf_l, ei_l) =3D=3D
                            btrfs_file_extent_num_bytes(leaf_r, ei_r))
                                return 0;
                }

                inconsistent_snapshot_error(sctx, result, "extent");
                return -EIO;

This is the point where bees users report send failures.

I don't really understand what that code is trying to achieve, though.
If we are diffing two subvol trees then we should just send anything
that's different--even if we occasionally send a few redundant extents
because we happen to be sending during a balance, because that's better
than bombing out completely.

Or is the problem more like we lose our ei pointer in one of the subvols
when the extent tree changes under it?  That would be harder to solve,
it would have to keep releasing and reacquiring everything.

> You can definitely do dedupe on a read-only root and after it finishes
> do a send (either full or incremental), and it will work.

If there's a way to make a subvol RW temporarily _without breaking
incremental send from that subvol_ (i.e. without clearing the parent
UUIDs, maybe also allowing only dedupe) then I have no objection.

> > More details at:
> >
> >         https://github.com/Zygo/bees/issues/79#issuecomment-429039036
> >
> > > I understand it can break some applications, but adding other solution
> > > such as preventing send and dedupe from running in parallel
> > > (erroring out or block and wait for each other, etc) is going to be
> > > really ugly. There's always the workaround for apps to set the
> > > subvolume
> > > to RW mode, do the dedupe, then switch it back to RO mode.
> > >
> > > Thanks.

--ILuaRSyQpoVaJ1HG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXG2LkQAKCRCB+YsaVrMb
nEv0AKDdFL4lxLvnJlNve2+fHlTm7EfYbACeNN82WyToQePNbqQRFZXx3FPes/0=
=Iif1
-----END PGP SIGNATURE-----

--ILuaRSyQpoVaJ1HG--
