Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58369 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630AbaDJUen (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 16:34:43 -0400
Date: Thu, 10 Apr 2014 21:34:40 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chip Turner <cturner@pattern.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Filesystem unable to recover from ENOSPC
Message-ID: <20140410203439.GB20307@carfax.org.uk>
References: <CAH3EO-o-S7WveO7V++zB1+Zd3kfrxk4YyMZ6P+GrcNWfALgrfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
In-Reply-To: <CAH3EO-o-S7WveO7V++zB1+Zd3kfrxk4YyMZ6P+GrcNWfALgrfA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 10, 2014 at 01:00:35PM -0700, Chip Turner wrote:
> I have a filesystem that I can't seem to resolve ENOSPC issues.  No
> write operation can succeed; I've tried the wiki's suggestions
> (balancing, which fails because of ENOSPC, mounting with nodatacow,
> clear_cache, nospace_cache, enospc_debug, truncating files, deleting
> files, briefly microwaving the drive, etc).
> 
> btrfs show:
> Label: none  uuid: 04283a32-b388-480b-9949-686675fad7df
> Total devices 1 FS bytes used 135.58GiB
> devid    1 size 238.22GiB used 238.22GiB path /dev/sdb2
> 
> btrfs fi df:
> Data, single: total=234.21GiB, used=131.82GiB
> System, single: total=4.00MiB, used=48.00KiB
> Metadata, single: total=4.01GiB, used=3.76GiB

   I'm surprised it's managed to use that much of the metadata
allocation. The FS usually hits this problem with a much smaller
used-to-total ratio.

> So, the filesystem is pretty much unusable, and I can find no way to
> resuscitate it.  I ended up in this state by creating a snapshot of
> the root of the fs into a read/write subvolume, which I wanted to
> become my new root, then began deleting entries in the filesystem
> itself outside of the new snapshot.  So nothing particularly weird or
> crazy.  The only oddness is the file count -- I have a *lot* of
> hardlinked files (this is an rsnapshot volume, so it has a large
> number of files and many of them are hard linked).
> 
> It seems like the normal solution is btrfs balance, but that fails.
> defragment also fails.  Kernel is 3.13.
> 
> Is there anything else I can or should do, or just wipe it and
> recreate with perhaps better initial defaults?  If this kind of thing
> is unavoidable, how might I have anticipated it and prevented it?
> Fortunately this was a migration effort and so my original data is
> safe inside of ext4 (ew).

   One thing you could do is btrfs dev add a small new device to the
filesystem (say, a USB stick, or a 4 GiB loopback file mounted over
NBD or something). Then run the filtered balance. Then btrfs dev del
the spare device.

   The fact that this FS has ended up in this state should be
considered a bug. It used to be quite common, then josef fixed a load
of problems, and it's been rare for about a year. Only recently we've
been seeing more of this kind of problem, and I think there's been a
bit of a regression somewhere.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- "Can I offer you anything? Tea? Seedcake? ---            
                         Glass of Amontillado?"                          

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU0cAX1heFHXiqx3kAQKw0Q/+LdIxz5FProNIIiZKEHQ5QPbu+KqpDZp7
TL2FLnOcoiPPzOU/rrtp4ShxlbUpqz1KDBmRfJuJbXUwccE71dWJpK+yjudt4HLT
0DxOTcpppSVcYTiMlclEeW2aPJMwssx/BytaIcafHOEtWf9WR9JiuN6BBFy3RSLU
KSEQCN4srW/qBvvxEe4JkjOQZInAGm87if1TGPmwV+JZ5Bd2u2fu4XsR1USFaZjJ
GIr3kH0x3xQSVKquWhOvpTlSGTRlk2GxVBR13nVVDV1FfMEL5JX/I/c/eQg3M8Il
Ie6B58hoJS1Dky6CmZk0AktL/E/x69XX6fxjUrrIaCAVU2gbRjL5jzVR07hTNhQJ
aiZ5cYvvdp6FgAH+GAZkxPow6oeTEWXUVog4nH1/VQDVxn28tqLJ1v8U03fUevbj
8XaCxFrFX4fvt6zlSRVioODJthyZn+pYSfsDKgASymJeRne3VWWQ2dLFCsFSbcTH
x/AorocNWCqZDzqquVIag63biDrr0v6diG8lbqSyTE2T3Ui3+NRgIBofupYMD1e0
xaO0CwdOc16LbyIGwTQ3iYnUPLqH1qE6fs2OblGD6zcW1t5JPPvxV0AiquXGtStE
lmF4PRE2E59+QtO3ubr5mHJuFwXqwMt2DmOJLb2o81M8Qp9aAvOtbulsMBuAsLeJ
BsmSMo4Il2A=
=p42V
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
