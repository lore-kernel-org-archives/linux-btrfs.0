Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38052 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402AbaDXPzP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 11:55:15 -0400
Date: Thu, 24 Apr 2014 16:55:10 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send receive, clone
Message-ID: <20140424155510.GG2391@carfax.org.uk>
References: <35B44B63-D139-4E0E-AD6F-2320B79D19B1@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3607uds81ZQvwCD0"
In-Reply-To: <35B44B63-D139-4E0E-AD6F-2320B79D19B1@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3607uds81ZQvwCD0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 24, 2014 at 09:23:28AM -0600, Chris Murphy wrote:
> 
> 
> I don't understand the btrfs send -c <clone-src> man page text, or really even the use case. In part this is what it says:
> 
> > You must not specify clone sources unless you
> >  guarantee that these snapshots are exactly in the same state on both
> >  sides, the sender and the receiver.
> 
> If the snapshots are the same on both sides, then why would I be using clone in the first place?

   To copy over another snapshot which shares data with them.

> > -c <clone-src> Use this snapshot as a clone source for an 
> > incremental send (multiple allowed)
> 
> Incremental send implies the sender and receiver are not in the same state now, but will be after the command is executed. Is one, or both, snapshots rw for -c?
> 
> Anyway, I'm lost on the specifics, but clearly I'm even lost when it comes to the basic difference between -p and -c.

(Note: I've not actually tried the second case in what follows, but
it's what I think is going on. This may be subject to corrections.)

   OK, call the sending system "S" and the receiving system "R". Let's
say we've got three subvolumes on S:

S:A2, the current /home (say)
S:A1, a snapshot of an earlier version of S:A2
S:B, a separate subvolume that's had some CoW copies of files in both
     S:A1 and S:A2 made into it.

   If we send S:A1 to R, then we'll have to send the whole thing,
because R doesn't have any subvolumes yet.

   If we now want to send S:A2 to R, then we can use -p S:A1, and it
will send just the differences between those two. This means that the
send stream can potentially ignore a load of the metadata as well as
the data. It's effectively saying, "you can clone R:A1, then do these
things to it to get R:A2".

   If we now want to send S:B to R, then we can use -c S:A1 -c S:A2.
Note that S:B doesn't have any metadata in common with either of the
As, only data. This will send all of the metadata ("start with an
empty subvolume and do these things to it to get R:B"), but because
it's known to share data with some subvols on S, and those subvols
also exist on R, we can avoid sending that data again by simply
specifying where the data can be found and reflinked from on R.

   So, if you have a load of snapshots, you can do one of two things
to duplicate all of them:

btrfs sub send <snap 0>
for n=1 to N
   btrfs sub send -p <snap n-1> <snap n>

   Or, in any order,

btrfs sub send <snap s1>
for n=1 to N
   btrfs sub send -c <snap s1> -c <snap s2> -c <snap s3> ... <snap sn>

where each subvolume that's been sent before gets added as a -c to the
next send command. This second approach means that all possible
reflinks between subvolumes can be captured, but it will send all of
the metadata across each time. The first approach may lose some manual
reflink efficiency, but is better at sending only the necessary
changed metadata. You should be able to combine the two methods, I
think.

   I'm trying to think of a case where -c is useful that doesn't
involve someone having done cp --reflink=always between subvolumes,
but I can't. So, I think the summary is:

 * Use -p to deal with parent-child reflinks through snapshots
 * Use -c to specify other subvolumes (present on both sides) that
   might contain reflinked data

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Well, you don't get to be a kernel hacker simply by looking ---   
                    good in Speedos. -- Rusty Russell                    

--3607uds81ZQvwCD0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU1kz3lheFHXiqx3kAQIHZw/8C4iM/CrbuSMjVDLvZ4ifcNZbDNWZL9WN
QHim9kH32rzWb9sLSDTE4mxAye2nqIcSBGInYD2ntTf8MFmZGlHsa5SikDlfrZOb
OPdpPw1bD3erKc3BvMRCF8GBbSbDtHUFWR7oHVNw2nxkaTVTGPyOobewK+FioOji
PHNsAZ9Rj0lKq2c9Tn6PPO58IFVIwdQcAVop954F+SmJqSCzl1FJm5KBxz5mN4eP
rYJ6+qTcQFzUlDz68/Avs+kIWjEINXOQglYYM2V0knl6mnO5ZcalfDEENtSDnrgL
lLZjGXihZNdkfXu05iR070PQzeXeVA28ZqN8uBfJoLsIzq/K1uRBeahGkPYmgVMH
GPA+J3+EZ+dSi/uWJwI/TGaIvLE5oq1uy7clXru7PQb8PjDCmuQCi7KqolzEOmQc
PLcamgDphAZ+7NJucO3TT/WDZhRMvd0Wc07FasVNH1Bil+2IFPG9zJEhYQxoZOcn
0LAGPUsBXjQ/CGhaD8mcu8++qO1UDgqFoxS8lT+ZjkgZ5d1xWIodBXUJbdaJu6JQ
uXpfubJK0kXHtsTrYpUaiiM4E1LuXZBQxz1lZhjTJ/9+vnVXpTdJNStom52SkJKr
+gHCPMTuE9K3x4e33TW2DohcTW/z2yu/7UHrh8dNHE4pXITT8bRx+v0kq9O3lJ8j
OBzlH8D0IMs=
=HOqO
-----END PGP SIGNATURE-----

--3607uds81ZQvwCD0--
