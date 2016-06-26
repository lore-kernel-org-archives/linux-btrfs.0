Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbcFZNvD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 09:51:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 09413AC6C
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 13:51:01 +0000 (UTC)
Subject: Re: [PATCH 00/31] btrfs: simplify use of struct btrfs_root pointers
To: linux-btrfs@vger.kernel.org
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <fa30d667-b498-feb0-517e-72fa5ebf20e3@suse.com>
Date: Sun, 26 Jun 2016 09:50:50 -0400
MIME-Version: 1.0
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="vpoG2aPPtE376H48C25CcCO36r3qcHHvD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vpoG2aPPtE376H48C25CcCO36r3qcHHvD
Content-Type: multipart/mixed; boundary="Fu5fg4n0gj7HBSgoIUQh7TGWdO2c82CsS"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <fa30d667-b498-feb0-517e-72fa5ebf20e3@suse.com>
Subject: Re: [PATCH 00/31] btrfs: simplify use of struct btrfs_root pointers
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>

--Fu5fg4n0gj7HBSgoIUQh7TGWdO2c82CsS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/24/16 6:14 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> One of the common complaints I've heard from new and experienced
> developers alike about the btrfs code is the ubiquity of
> struct btrfs_root.  There is one for every tree on disk and it's not
> always obvious which root is needed in a particular call path.  It can
> be frustrating to spend time figuring out which root is required only
> to discover that it's not actually used for anything other than
> getting the fs-global struct btrfs_fs_info.
>=20
> The patchset contains several sections.
>=20
> 1) The fsid trace event patchset I posted earlier; I can rebase without=
 this
>    but I'd prefer not to.
>=20
> 2) Converting btrfs_test_opt and friends to use an fs_info.
>=20
> 3) Converting tests to use an fs_info pointer whenever a root is used.
>=20
> 4) Moving sectorsize and nodesize to fs_info and cleaning up the
>    macros used to access them.
>=20
> 5) General cleanups and small fixes to make the later patches easier to=

>    review.
>=20
> 6) Adding an "fs_info" convenience variable to every functiont that
>    references root->fs_info more than once.  As new references appear
>    in functions, more of these are added later.
>=20
> 7) Call functions that always overwrite their root parameter with
>    an fs_info instead.
>=20
> 8) Call functions that are always called using the same root with
>    an fs_info instead, retreiving the root internally.
>=20
> 9) Convert every function that accepts a root argument but only uses it=

>    to retreive an fs_info to accept an fs_info instead.  This is a
>    recursive process as the changes percolate up.
>=20
> 10) Separately convert btrfs_commit_transaction and btrfs_end_transacti=
on
>     to use trans->root instead of a root parameter.  Both are always ca=
lled
>     with the same root that was passed to btrfs_{start,join}_transactio=
n.
>=20
> This series of patches in email format is the "squashed" version of
> the full development series.  That series is available at:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/jeffm/linux-btrfs.git
>=20
> There are two branches of interest:
> - btrfs-testing/root-fsinfo-cleanup-squashed contains this series
> - btrfs-testing/root-fsinfo-cleanup contains the full series

Hrm.  It looks like vger didn't allow a few of the patches through,
presumably due to size.  Using the git repo is probably the only way to
go, then.

-Jeff

> The btrfs-testing/root-fsinfo-cleanup branch is easier to review if usi=
ng
> git as each change is discrete.  As a whole, the patchset is invasive b=
ut
> should change execution minimally.  It passes and fails the same xfstes=
ts
> that the unpatched kernel does across multiple runs.
>=20
> Thanks,
>=20
> -Jeff
>=20
> ---
>=20
> Jeff Mahoney (31):
>   btrfs: plumb fs_info into btrfs_work
>   btrfs: prefix fsid to all trace events
>   btrfs: btrfs_test_opt and friends should take a btrfs_fs_info
>   btrfs: tests, move initialization into tests/
>   btrfs: tests, require fs_info for root
>   btrfs: tests, use BTRFS_FS_STATE_DUMMY_FS_INFO instead of dummy root
>   btrfs: simpilify btrfs_subvol_inherit_props
>   btrfs: copy_to_sk drop unused root parameter
>   btrfs: cleanup, remove prototype for btrfs_find_root_ref
>   btrfs: introduce BTRFS_MAX_ITEM_SIZE
>   btrfs: convert nodesize macros to static inlines
>   btrfs: btrfs_relocate_chunk pass extent_root to btrfs_end_transaction=

>   btrfs: add btrfs_trans_handle->fs_info pointer
>   btrfs: btrfs_abort_transaction, drop root parameter
>   btrfs: call functions that overwrite their root parameter with fs_inf=
o
>   btrfs: call functions that always use the same root with fs_info
>     instead
>   btrfs: btrfs_init_new_device should use fs_info->dev_root
>   btrfs: alloc_reserved_file_extent trace point should use extent_root
>   btrfs: struct btrfsic_state->root should be an fs_info
>   btrfs: struct reada_control.root -> reada_control.fs_info
>   btrfs: root->fs_info cleanup, use fs_info->dev_root everywhere
>   btrfs: root->fs_info cleanup, io_ctl_init
>   btrfs: pull node/sector/stripe sizes out of root and into fs_info
>   btrfs: root->fs_info cleanup, btrfs_calc_{trans,trunc}_metadata_size
>   btrfs: root->fs_info cleanup, lock/unlock_chunks
>   btrfs: root->fs_info cleanup, update_block_group{,flags}
>   btrfs: root->fs_info cleanup, add fs_info convenience variables
>   btrfs: root->fs_info cleanup, access fs_info->delayed_root directly
>   btrfs: take an fs_info parameter directly when the root is not used
>     otherwise
>   btrfs: root->fs_info cleanup, btrfs_commit_transaction already has
>     root
>   btrfs: root->fs_info cleanup, btrfs_end_transaction{,_throttle} use
>     trans->fs_info instead of parameter
>=20
>  fs/btrfs/async-thread.c                |   31 +-
>  fs/btrfs/async-thread.h                |    6 +-
>  fs/btrfs/backref.c                     |   12 +-
>  fs/btrfs/check-integrity.c             |   41 +-
>  fs/btrfs/check-integrity.h             |    5 +-
>  fs/btrfs/compression.c                 |   54 +-
>  fs/btrfs/ctree.c                       |  483 ++++++------
>  fs/btrfs/ctree.h                       |  281 +++----
>  fs/btrfs/delayed-inode.c               |  147 ++--
>  fs/btrfs/delayed-inode.h               |   19 +-
>  fs/btrfs/delayed-ref.c                 |    9 +-
>  fs/btrfs/dev-replace.c                 |   68 +-
>  fs/btrfs/dev-replace.h                 |    4 +-
>  fs/btrfs/dir-item.c                    |   44 +-
>  fs/btrfs/disk-io.c                     |  593 ++++++++-------
>  fs/btrfs/disk-io.h                     |   27 +-
>  fs/btrfs/export.c                      |   10 +-
>  fs/btrfs/extent-tree.c                 | 1297 ++++++++++++++++--------=
--------
>  fs/btrfs/extent_io.c                   |   41 +-
>  fs/btrfs/extent_io.h                   |    4 +-
>  fs/btrfs/file-item.c                   |  164 ++--
>  fs/btrfs/file.c                        |  220 +++---
>  fs/btrfs/free-space-cache.c            |  116 +--
>  fs/btrfs/free-space-cache.h            |    6 +-
>  fs/btrfs/free-space-tree.c             |   60 +-
>  fs/btrfs/inode-item.c                  |   11 +-
>  fs/btrfs/inode-map.c                   |   48 +-
>  fs/btrfs/inode.c                       |  834 ++++++++++----------
>  fs/btrfs/ioctl.c                       |  613 ++++++++-------
>  fs/btrfs/ordered-data.c                |   38 +-
>  fs/btrfs/ordered-data.h                |    4 +-
>  fs/btrfs/print-tree.c                  |   21 +-
>  fs/btrfs/print-tree.h                  |    4 +-
>  fs/btrfs/props.c                       |   11 +-
>  fs/btrfs/qgroup.c                      |   60 +-
>  fs/btrfs/qgroup.h                      |    9 +-
>  fs/btrfs/raid56.c                      |   60 +-
>  fs/btrfs/raid56.h                      |    8 +-
>  fs/btrfs/reada.c                       |   36 +-
>  fs/btrfs/relocation.c                  |  261 ++++---
>  fs/btrfs/root-tree.c                   |   36 +-
>  fs/btrfs/scrub.c                       |  177 +++--
>  fs/btrfs/send.c                        |   45 +-
>  fs/btrfs/super.c                       |  308 ++++----
>  fs/btrfs/tests/btrfs-tests.c           |   72 +-
>  fs/btrfs/tests/btrfs-tests.h           |   38 +-
>  fs/btrfs/tests/extent-buffer-tests.c   |   23 +-
>  fs/btrfs/tests/free-space-tests.c      |   14 +-
>  fs/btrfs/tests/free-space-tree-tests.c |   18 +-
>  fs/btrfs/tests/inode-tests.c           |   46 +-
>  fs/btrfs/tests/qgroup-tests.c          |   23 +-
>  fs/btrfs/transaction.c                 |  531 ++++++-------
>  fs/btrfs/transaction.h                 |   16 +-
>  fs/btrfs/tree-log.c                    |  193 ++---
>  fs/btrfs/uuid-tree.c                   |   20 +-
>  fs/btrfs/volumes.c                     |  813 ++++++++++----------
>  fs/btrfs/volumes.h                     |   42 +-
>  fs/btrfs/xattr.c                       |   21 +-
>  include/trace/events/btrfs.h           |  296 ++++----
>  59 files changed, 4383 insertions(+), 4109 deletions(-)
>=20


--=20
Jeff Mahoney
SUSE Labs


--Fu5fg4n0gj7HBSgoIUQh7TGWdO2c82CsS--

--vpoG2aPPtE376H48C25CcCO36r3qcHHvD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXb93BAAoJEB57S2MheeWyKn8QALQdYVSNFi3bNqbG4q01uD8f
rXpeyJ1RNBhhQUzcCQzXIVwznTE7/RMczC6u5h9TREF1TpR6PsuO7g2R65R5Rwez
xZnjg3zokbIWCl0sDLoWcoUwaw7ZwHjqqC1G9HZbukMw0Yle4uTKvvMYEDOrl8kN
7ebdHTTfUmla3un38do6T3QiWLXgJoZ4MBkbDunTU5W1zh0r4WGWnQQTRyExB0dg
di0klYqPS1QKtYjyy3/hw5e3cPfyePfHH8LC6fuSrinWPdMvbGCKw6jhfBku20Oi
If1dixG4g2qbrS5mEVWFUbZZ/13KBZp445WuvUb3em51ukpENvNkRbg8ObDOFuhc
qlOqLGLWoedE2l5YCdRl3OKRb8qnojXo0FNZQTxa9k8qreIFDWOigGsJETbFAZXz
4hkvml+2uLCsKQBHmxaEeEW6ybt9qnkhmQ0wUQgS2zmzOzizjXVKsNh7XzyEras2
lKgDjGDeA0mqYCJMMl0Mmc6pWUuU2oKDCkeBxerivROIj65JCRAwqy/cajsJuK2i
0dOAK6YHpXlSd8l1r0bf53MYTWO1L6VZSv6+L/RmdW5LIvJLhYKteIqHzTvLtAFB
w/HmtLP5ZjgNVFlR248h8gzMEPzCEDxfZyDMzMJJFysYKLC3B7cZCPruGvbJYzcR
BtP/V3oST34jQB6/6FPK
=JpQd
-----END PGP SIGNATURE-----

--vpoG2aPPtE376H48C25CcCO36r3qcHHvD--
