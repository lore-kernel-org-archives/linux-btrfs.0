Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:43196 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729073AbeHOPWF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 11:22:05 -0400
Date: Wed, 15 Aug 2018 08:30:05 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: Deadlock between dedup and rename
Message-ID: <20180815123005.GD13528@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zbGR4y+acU1DwHSi"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--zbGR4y+acU1DwHSi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Every month or two I hit a btrfs deadlock like this:

dedup and rsync are both operating on the same file when the filesystem
locked up.  The deadlock happens at the moment when rsync renames its
temporary file (the dedup dst file) to replace the old version of the
file (the dedup src file).

Dedup ended up stuck with this stack trace:

	[<ffffffff92c111d3>] call_rwsem_down_write_failed+0x13/0x20
	[<ffffffff920ea907>] down_write_nested+0x87/0xb0
	[<ffffffff9246e29c>] btrfs_dedupe_file_range+0xdc/0x5f0
	[<ffffffff922a2f50>] vfs_dedupe_file_range+0x210/0x240
	[<ffffffff922b9ba6>] do_vfs_ioctl+0x236/0x6b0
	[<ffffffff922ba096>] SyS_ioctl+0x76/0x90
	[<ffffffff92003ba0>] do_syscall_64+0x70/0x190
	[<ffffffff92e00086>] entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[<ffffffffffffffff>] 0xffffffffffffffff

and rsync ended up stuck with this stack trace:

	[<ffffffff92c111d3>] call_rwsem_down_write_failed+0x13/0x20
	[<ffffffff920ea907>] down_write_nested+0x87/0xb0
	[<ffffffff922b1e6e>] vfs_rename+0x18e/0x8c0
	[<ffffffff922b78ee>] SyS_renameat2+0x4ce/0x520
	[<ffffffff92003ba0>] do_syscall_64+0x70/0x190
	[<ffffffff92e00086>] entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[<ffffffffffffffff>] 0xffffffffffffffff

The file in question was somewhat large (>4GB) so there was probably some
dirty page flushing going on in the background, which may or may not
matter for reproducing the bug.

This is a fairly common occurrence when rsyncing large files while
bees is running, as the rsync temporary file is often a copy of its own
previous version, and bees will start deduplication at the head of the
temporary file before rsync finishes writing at the tail end.

--zbGR4y+acU1DwHSi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW3QcygAKCRCB+YsaVrMb
nC+DAJ9DFNYte3SZezlJ10uqOue+dKA/YACfVyzvT90tWDz5zuW1s301sjPTO3A=
=xEF7
-----END PGP SIGNATURE-----

--zbGR4y+acU1DwHSi--
