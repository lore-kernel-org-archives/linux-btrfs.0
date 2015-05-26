Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44220 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbbEZO0J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 10:26:09 -0400
Date: Tue, 26 May 2015 14:26:07 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs on disk stability
Message-ID: <20150526142607.GE16826@carfax.org.uk>
References: <loom.20150526T103943-385@post.gmane.org>
 <20150526085246.GC16826@carfax.org.uk>
 <loom.20150526T112326-642@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jKBxcB1XkHIR0Eqt"
In-Reply-To: <loom.20150526T112326-642@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jKBxcB1XkHIR0Eqt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 26, 2015 at 09:29:25AM +0000, sri wrote:
> Hugo Mills <hugo <at> carfax.org.uk> writes:
> 
> > 
> > On Tue, May 26, 2015 at 08:45:06AM +0000, sri wrote:
> > > Hi,
> > > 
> > > According to btrfs wiki page, under "Stability status" it is written 
> that
> > > 
> > > "The filesystem disk format is no longer unstable".
> > > 
> > > Does this mean if there are more I/Os are going on a btrfs file 
> system, 
> > > copy of entire disk (all disk blocks) gives a stable disk?
> > 
> >    No, it means that the format isn't changing in incompatible ways
> > any more. You're guaranteed that if you upgrade your kernel, the FS
> > will still be readable on the new kernel. (And, if you don't enable
> > any extra features with btrfstune, that the kernel will still be
> > readable if you downgrade to the earlier kernel you were using).
> > 
> > > Just to elaborate more, if btrfs file system is created on 2 disks 
> > > /dev/sda and /dev/sdb and if I start copying blocks of sda and sdb 
> to sdc 
> > > and sdc respectively by just opening file handlers of sda and sdb 
> and 
> > > mounting the new copy via /dev/sdc and /dev/sdd will give consistent 
> file 
> > > system??
> > 
> >    That's always the case, with the very large caveat that you remove
> > /dev/sdc and /dev/sdd from the system before you try mounting anything
> > related to that FS. Making block level copies of btrfs filesystems and
> > leaving them visible to the same kernel as the originals is a very bad
> > idea, and can cause massive FS corruption.
> > 
> >    It's OK to make the copy, but not to try mounting the FS with both
> > copies present, as the kernel will see both copies as the same
> > filesystem (because they have the same UUID), and it will get very
> > confused about which device(s) it's meant to be writing to.
> > 
> 
>   Thank you Hugo,
>   copies of disk will not be there once block level copy is done. Assume 
> that sdc and sdd (which are used for copy sda and sdb) are ISCSI disks 
> from different machine and as soon as disk copy sda->sdc and sdb->sdd is 
> done, I will remove both disks and use it on other machine.
> 
> In this case 
> 1) After copy at disk level whether the btrfs on sdc and sdd will be in 
> consistent state? even though there are any IOs on original disks sda 
> and sdb?
>   My guess is no but I am not sure

   If you're trying to copy a filesystem that's in use, then no, you
can't expect the copies to be consistent.

   Imagine: At the point where you've copied half the disk, and the FS
makes two updates which depend on each other -- one in the piece
you've already copied, and one in the piece you haven't copied
yet. Also, by this point, you've got the situation I warned against
above: multiple copies of a filesystem that's mounted, so your FS is
probably already damaged beyond repair. Doing it with a read-only
mount of the FS might be possible.

   Basically, you can only do this reliably if the filesystem is not
mounted.

> 2) new disks sdc and sdd can be mounted on another machine where btrfs 
> fs is supported ?  

   Yes.

   Hugo.

-- 
Hugo Mills             | Do not meddle in the affairs of wizards, for they
hugo@... carfax.org.uk | are subtle, and quick to anger.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                        J.R.R. Tolkein

--jKBxcB1XkHIR0Eqt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVZIJ/AAoJEFheFHXiqx3kDrIP/0IJvudjGJ726GcfSa4w5mNH
mVzfZ71JsprpBBXWRYfOWf9mjaXXbos71yrfiHhJjxy5Fj8i1f0u7cprkrSJ82Us
fgChdK5NddGhuG52PBFYrr1o203dxbWwcoPH8vQQblWheJjE3TPKe2Gj+BH+uCrb
LcIdhyckD7Eg9eInzARTsEs4qLKxLCeHN/eqTU0vIROw4Z2uo7CfIRvfzrLTvfgZ
2REk9aBS4jD/5pzFDwxt3+5M4oY3oKyoybzOHh1aT5eY00tsWVlB/Qqc4hP8/jVX
WhXTWtE2AWQzVwP6Blbnfl+8CVZtARHI9yHrsomzzTu1usaQoWF7dxs9BavLM4k/
i3xRMySv43IardEn664XPgQumLIfZLN4nciYSLvcLf5hOyCmSXOnalQ7KW9tN/lP
fRCSiTyLYJwUfaxIFSE9W5M8PnFEzvFMz9ebt2pr5ZbX5RBB8ixfOpkxUk/QJxux
DRdGqyoP0/URnSlqv52e0zxBBvyEGR66uGNlFtW0fukPDEQ7O8FS//EGB2MkH6cN
9dm5ookN3qI6HEEaZH9y2YLRxcRNh4n9ssdSb62TARIiV0MEbX0goQKJKC9lhCXu
zL2t34pIqZzURTbvG3KFmNla0uExpAzqucjFPcfULTRY3HEAFeDJTdGHga5mtuOQ
vKwy/GGzGWgU/v5NWPIf
=nMW7
-----END PGP SIGNATURE-----

--jKBxcB1XkHIR0Eqt--
