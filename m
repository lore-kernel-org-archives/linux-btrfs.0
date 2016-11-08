Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47493 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932234AbcKHXA7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 18:00:59 -0500
Date: Tue, 8 Nov 2016 23:00:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ian Kelling <ian@iankelling.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Could receive allow updating an existing subvolume?
Message-ID: <20161108230057.GQ16645@carfax.org.uk>
References: <1478645336.2739242.781712345.6ADE1927@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HrsILUyxNtiOryfc"
In-Reply-To: <1478645336.2739242.781712345.6ADE1927@webmail.messagingengine.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HrsILUyxNtiOryfc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 08, 2016 at 02:48:56PM -0800, Ian Kelling wrote:
> It seems to be an artificially imposed limitation which hurts which
> hurts its usefulness. Let me know if this makes sense. If so, perhaps it
> can be implemented eventually. It seems a bit obvious but I couldn't
> find any existing discussion of it.

   It's not artificial -- it's ensuring safety of operation.

   If the sender sends an incremental stream, that assumes an *exact*
subvol state on the receiving side. If the subvol on the receiving
side is modified, then the receive can fail.

   So, the assumption is that the reference subvol on the receiving
side (equivalent to the -p subvol on the sending side) hasn't been
changed since it was received. The same assumption applies to the -p
subvol on the sending side.

   Now, receive is a fully userspace tool, so it would have to set the
subvol to RW, then update it, then set it to RO. The subvol risks
being modified by other processes during that window -- *particularly*
if it's actively being read by those other processes.

   Note that this is still an issue with the current situation, but
the expectation is that nothing's going to be actively reading that
location at the time the receive is running. But, if something does go
wrong with the receive, it's possible to abort and restart the
process. If you're modifying an existing subvol, there's no
recoverability if something goes wrong halfway through.

   Hugo.

> Say you have this situation:
> a/1, a/2 (parent is a/1)
> b/1 (received from a/1)
> Currently, you can (abbreviated) "send -p a/1 a/2 | receive" to create
> b/2 (received from a/2, parent is b/1).
> 
> b/2 must start out as a rw snapshot from b/1, so we start out with 2
> identical subvolumes except for some metadata and rw status, why not
> have an option to update the existing subvol instead of the new one?
> For example, when receive starts, rename b/1 to b/2, take an ro snapshot
> of b/2 named b/1, set b/2 to rw, update b/2's metadata, then update b/2
> with the new incremental data just as before.
> 
> The current situation severely limits the use case of having a host
> which has read-only data which is incrementally updated, which is
> read/served by standard programs, not just backup restore tools, because
> to have any persistent paths, you need to remount using the new
> subvolume (generally means killing programs reading from it), or using
> paths that begin like /dir/b{1,2} and then renaming subvolumes, and then
> requesting that all reading programs reopen their files because they
> will still have references in the old subvolume (again, often means
> killing programs).

-- 
Hugo Mills             | I believe that it's closely correlated with the
hugo@... carfax.org.uk | aeroswine coefficient
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       Adrian Bridgett

--HrsILUyxNtiOryfc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYIlkoAAoJEFheFHXiqx3knJYP/0zP7GkouTcSDRN1cbn7uP/J
s6tuWQpR2BfL2QN5QGPiquM3tIMrVj4ruQ0iCQNXJEC56ck88/3WAcb8IDD8YhRG
rlq/7gOG4Ivi+xDNQEOQ9os88/QznQM1e56r6tB0/VeNyo0f0gvsAAKP42af4gP0
YsYI1FoRCL4p613PO59m8msr7dgIWi74zUeOpSIYg9rnQFA8Qe2dsGfCaOzcLypP
8svZGshqDP4DCrxnph/uceCrsXloddowlOB17Wx6MtzAELGBkZg5ayZk6UAjCXEt
nSm+6LbwwxQYCK7oZhPaQUo4eqC2Ci4X2cNwWfvMfeXfXOwcZ1UHKFCuDCmUA34j
SPXw0jnjB7fECad7wRXgreFj5/EQ+MSCi0KF7gmw42I2PlGTjIUYGY68Bg8UiCoV
jogBtmOcxMgnPCGSpjAhto7Xf+p7BjEgRMJ6Vm9BdJu1pmOzcUg9/vxUAu3mE2pI
z7fs1GmDbTxJKxgzzYhvxOGNQMFgUD4z7Efc89I5uEdxvLqukzETPQBPdazoFls3
MnEVX/Q8GCc4ISKusA8uP8gjFCV/Fl+oZkVzwlDoEByDPt2TUqPL3A0OCVA2XMaY
zrjHMPIanw4YS2+aV5D6K7XWnTjaxZjXpTQcPA5wrUXnUaYV5vOVrZFXW4TEMyKY
qWDjn6X7BrakmSAbs1mk
=k+3q
-----END PGP SIGNATURE-----

--HrsILUyxNtiOryfc--
