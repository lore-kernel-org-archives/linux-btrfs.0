Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37381 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752263AbbFYQwM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 12:52:12 -0400
Date: Thu, 25 Jun 2015 12:52:09 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: dsterba@suse.cz, Mark Fasheh <mfasheh@suse.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: add no_mtime flag to btrfs-extent-same
Message-ID: <20150625165209.GB14931@hungrycats.org>
References: <1435013262-23252-1-git-send-email-mfasheh@suse.de>
 <1435013262-23252-6-git-send-email-mfasheh@suse.de>
 <20150623151156.GI6761@twin.jikos.cz>
 <20150624201732.GA14931@hungrycats.org>
 <20150625125250.GF726@twin.jikos.cz>
 <558BFDC7.1090800@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
In-Reply-To: <558BFDC7.1090800@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2015 at 09:10:31AM -0400, Austin S Hemmelgarn wrote:
> On 2015-06-25 08:52, David Sterba wrote:
> >On Wed, Jun 24, 2015 at 04:17:32PM -0400, Zygo Blaxell wrote:
> >>Is there any sane use case where we would _want_ EXTENT_SAME to change
> >>the mtime?  We do a lot of work to make sure that none of the files
> >>involved have any sort of content change.  Why do we need the flag at a=
ll?
> >
> >Good point, I don't see the usecase for updating MTIME.
> Was the original intent possibly to make certain the CTIME got
> updated?  Because EXTENT_SAME _does_ update the metadata, and by
> logical extension that means that the CTIME should change.

It updates the _extent_ metadata.  CTIME does not cover that, only _inode_
metadata changes.

Put another way, if we updated CTIME for extent metadata changes, then
a balance would imply rewriting every inode on the filesystem, which is
insane.  Same for defragment:  when we defragment files, we already
leave the MTIME and CTIME fields alone, and we use locking to protect
defrag from race conditions that might cause it to modify data.

You can confirm the behavior of balance and defrag on v4.0.5:

	# Here's a file:
	root@testhost:~# fiemap /media/usb7/vmlinuz
	File: /media/usb7/vmlinuz
	Log 0x0..0x654000 Phy 0xc10000..0x1264000 Flags FIEMAP_EXTENT_LAST
	root@testhost:~# ls --full -lc /media/usb7/vmlinuz
	-rw------- 1 root root 6634160 2015-06-25 12:37:16.265688748 -0400 /media/=
usb7/vmlinuz

	# Balance:
	root@testhost:~# btrfs balance start /media/usb7
	Done, had to relocate 5 out of 5 chunks

	# Confirm the file is an a new physical location:
	root@testhost:~# fiemap /media/usb7/vmlinuz
	File: /media/usb7/vmlinuz
	Log 0x0..0x654000 Phy 0x2b3d0000..0x2ba24000 Flags FIEMAP_EXTENT_LAST

	# We did not change the CTIME.
	root@testhost:~# ls --full -lc /media/usb7/vmlinuz
	-rw------- 1 root root 6634160 2015-06-25 12:37:16.265688748 -0400 /media/=
usb7/vmlinuz

	# Now let's try defrag!
	root@testhost:~# btrfs fi defrag -c /media/usb7/vmlinuz

	# File has been moved again, and parts of it are even compressed now
	root@testhost:~# fiemap /media/usb7/vmlinuz
	File: /media/usb7/vmlinuz
	Log 0x0..0x20000 Phy 0x2b390000..0x2b3b0000 Flags FIEMAP_EXTENT_ENCODED
	Log 0x20000..0x80000 Phy 0x2ba64000..0x2bac4000 Flags 0
	Log 0x80000..0x100000 Phy 0x2bac4000..0x2bb44000 Flags 0
	Log 0x100000..0x180000 Phy 0x2bb44000..0x2bbc4000 Flags 0
	Log 0x180000..0x200000 Phy 0x2bbc4000..0x2bc44000 Flags 0
	Log 0x200000..0x280000 Phy 0x2bc44000..0x2bcc4000 Flags 0
	Log 0x280000..0x300000 Phy 0x2bcc4000..0x2bd44000 Flags 0
	Log 0x300000..0x380000 Phy 0x2bd44000..0x2bdc4000 Flags 0
	Log 0x380000..0x400000 Phy 0x2bdc4000..0x2be44000 Flags 0
	Log 0x400000..0x480000 Phy 0x2be44000..0x2bec4000 Flags 0
	Log 0x480000..0x500000 Phy 0x2bec4000..0x2bf44000 Flags 0
	Log 0x500000..0x580000 Phy 0x2bf44000..0x2bfc4000 Flags 0
	Log 0x580000..0x600000 Phy 0x2bfc4000..0x2c044000 Flags 0
	Log 0x600000..0x654000 Phy 0x2c044000..0x2c098000 Flags FIEMAP_EXTENT_LAST

	# CTIME not changed (no changes to file content).
	root@testhost:~# ls --full -lc /media/usb7/vmlinuz
	-rw------- 1 root root 6634160 2015-06-25 12:37:16.265688748 -0400 /media/=
usb7/vmlinuz


>=20
>=20



--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlWMMbkACgkQgfmLGlazG5w2QgCfVbyZMU54+WWE2vo9nO1vjlqM
UL4An28wgWDDwFvLTGOjHGSbJ6V8rScU
=585X
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
