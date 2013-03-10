Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53790 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3CJBoj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2013 20:44:39 -0500
Date: Sun, 10 Mar 2013 01:44:34 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Message-ID: <20130310014434.GB30771@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <khgcsi$1k4$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
In-Reply-To: <khgcsi$1k4$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 09, 2013 at 02:25:25PM -0800, Roger Binns wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 09/03/13 12:31, Hugo Mills wrote:
> > Some time ago, and occasionally since, we've discussed altering the 
> > "RAID-n" terminology to change it to an "nCmSpP" format, where n is
> > the number of copies, m is the number of (data) devices in a stripe per
> > copy, and p is the number of parity devices in a stripe.
> 
> I despise both terminologies because they mix up administrator goals with
> how those goals are provided by the filesystem.
> 
> Using RAID0 as an example, what is actually desired is maximum performance
> and there is no need to survive the failure of even a single disk. I don't
> actually care if it uses striping, parity, hot data tracking, moving
> things to faster outside edges of spinning disks, hieroglyphics, rot13
> encoding, all of the above or anything else.
> 
> Maximum performance is always desired and "RAID" settings really track to
> "data must survive the failure of N disks" and/or "data must be accessible
> if at least N disks are present".  As an administrator that is what I
> would like to set and let the filesystem do whatever is necessary to meet
> those goals  (I'd love to be able to set this on a per directory/file
> basis too.)

   You've got at least three independent parameters to the system in
order to make that choice, though, and it's a fairly fuzzy decision
problem. You've got:

 - Device redundancy
 - Storage overhead
 - Performance

   So, for example, if you have 6 devices, and specify device
redundancy of 1 (i.e. you can lose at least one device without losing
any data), you have many options:

 - 2CmS    (50%)
 - 2C3S    (50%)
 - 2C2S    (50%)
 - 1C2S1P  (66%)
 - 1C3S1P  (75%)
 - 1C4S1P  (80%)
 - 1C5S1P  (83%)
 - 1CmS1P  (50%-83%)

where the figure in brackets is the storage-to-disk ratio, and the
list is in approximate decreasing order of mean performance(*). Using
these criteria for selecting a suitable operating mode isn't
impossible, but it's not a cut-and-dried thing, what with the
trade-off between storage ratio (which is easily-computed) and
performance (which isn't).

   I definitely want to report the results in nCmSpP form, which tells
you what it's actually done. The internal implementation, while not
expressing the full gamut of possibilities, maps directly from the
internal configuration to that form, and so it should at least be an
allowable input for configuration (e.g. mkfs.btrfs and the restriper).

   If you'd like to suggest a usable set of configuration axes [say,
(redundancy, overhead) ], and a set of rules for converting
those requirements to the internal representation, then there's no
reason we can't add them as well in a later set of patches.

   Note that for a given set of (redundancy, overhead) requirements,
the optimal operating point can change as the number of devices
changes. However, since the management of the number of devices is
pretty much entirely driven through userspace, we can handle all of
this in userspace. So if you want (1, 75%), and add a new disk, you'd
rebalance with (1, 75%) as the replication config parameter, and we
can convert that in userspace into the appropriate internal
representation to feed to the kernel.

   Hugo.

(*) Source: the inside of my head. Your mileage may vary. The value of
this prediction may go down as well as up. Contents may have settled
in transit. etc...

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- emacs: Eats Memory and Crashes. ---                 

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUTvlgr9z9OVl50rAAQIy+xAAj6pWwTOeOYIEfZjTa4AyXTsXjf3JmCuu
sH+4kGvtASloM4tnIFZRNpx3MIErLYpESreWNdSkgq/m4Ayxw348WJ2APBsNNRKD
9pNPoi6ijgZulrFmXRMX/znsPq0Wc7JFcoLJRpJjwE7MCD6vzOIdVhqvzmr7XnpJ
XCe0XyUB7AUMUcZeYO4bhjupGXdmiI8XSpjfhoNrurmhdT8xmlwSFXN8kiqHrRAL
qF+2g7L7ZUBh/lPlZ00vlxv4fMXTB4J4VMYLOUrEhtWnj4/8s6smzRSCuZF2GciD
AxuviVrshWt9osiRiUBxYYTTaZxO8Jl7Zj5bxJdEeH0Pi2KAXXmglDkuvArV4wyJ
DinzCOT6d3h1nJQRqiabu5Bas/6acpbvY4Lp6HnRfVa+7sQ6fn/ntLQw5aL97/WJ
dhq/KX754TTQvV6xLpGumNfA0zVfiYu0nslCZMj6ixW5ntiHUlcU3f9ZnRbt3RN4
okwAL02Ngfr8C50cBDIWCMY4NteoxvTU9wIlHmNSCaDiflhnbyKAqWwe326iDS9T
50NSB5ZeyrRSdj7+AXX4S8rnmoTRvBzqsUE5E/InmvwkwjL7B1cGWMBj3pf1/zbT
H3dzqxy/X6GBuRR3NwBbyr99D+ByawWgjwSlSu4Zjq6ocp/uQHbEOuSQBC81Du7j
NzPbc4n78fo=
=NV7e
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
