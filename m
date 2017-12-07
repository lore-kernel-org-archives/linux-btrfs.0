Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51728 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754521AbdLGNpj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Dec 2017 08:45:39 -0500
Date: Thu, 7 Dec 2017 13:45:37 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Improve subvolume usability for a normal user
Message-ID: <20171207134537.GA31105@carfax.org.uk>
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
 <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
 <e5bf11ce-fef2-6786-752d-4711751d284d@gmail.com>
 <43b6e90c-6461-d722-fb8c-8ad5069841fd@jp.fujitsu.com>
 <e1a297d8-28fb-980e-fd62-c261186b3a6a@gmail.com>
 <pan$33b4a$60a76f26$86fed72c$a3e3152c@cox.net>
 <cf2e2d1b-a85a-cc02-5671-523f95c9db34@jp.fujitsu.com>
 <pan$5078c$e6344b9d$7ac11ecf$99edcd61@cox.net>
 <b581ea80-7c8e-9eda-59ef-550ef40206b2@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
In-Reply-To: <b581ea80-7c8e-9eda-59ef-550ef40206b2@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 07, 2017 at 07:21:46AM -0500, Austin S. Hemmelgarn wrote:
> On 2017-12-07 06:55, Duncan wrote:
> >Misono, Tomohiro posted on Thu, 07 Dec 2017 16:15:47 +0900 as excerpted:
> >
> >>On 2017/12/07 11:56, Duncan wrote:
> >>>Austin S. Hemmelgarn posted on Wed, 06 Dec 2017 07:39:56 -0500 as
> >>>excerpted:
> >>>
> >>>>Somewhat OT, but the only operation that's remotely 'instant' is
> >>>>creating an empty subvolume.  Snapshot creation has to walk the tree
> >>>>in the subvolume being snapshotted, which can take a long time (and as
> >>>>a result of it's implementation, also means BTRFS snapshots are _not_
> >>>>atomic). Subvolume deletion has to do a bunch of cleanup work in the
> >>>>background (though it may be fairly quick if it was a snapshot and the
> >>>>source subvolume hasn't changed much).
> >>>
> >>>Indeed, while btrfs in general has taken a strategy of making
> >>>/creating/ snapshots and subvolumes fast, snapshot deletion in
> >>>particular can take some time[1].
> >>>
> >>>And in that regard a question just occurred to me regarding this whole
> >>>very tough problem of a user being able to create but not delete
> >>>subvolumes and snapshots:
> >>>
> >>>Given that at least snapshot deletion (not so sure about non-snapshot
> >>>subvolume deletion, tho I strongly suspect it would depend on the
> >>>number of cross-subvolume reflinks) is already a task that can take
> >>>some time, why /not/ just bite the bullet and make the behavior much
> >>>more like the directory deletion, given that subvolumes already behave
> >>>much like directories.  Yes, for non-root, that /does/ mean tracing the
> >>>entire subtree and checking permissions, and yes, that's going to take
> >>>time and lower performance somewhat, but subvolume and in particular
> >>>snapshot deletion is already an operation that takes time, so this
> >>>wouldn't be unduly changing the situation, and it would eliminate the
> >>>entire class of security issues that come with either asymmetrically
> >>>restricting deletion (but not creation) to root on the one hand,
> >>
> >>>or possible data loss due to allowing a user to delete a subvolume they
> >>>couldn't delete were it an ordinary directory due to not owning stuff
> >>>further down the tree.
> >>
> >>But, this is also the very reason I'm for "sub del" instead of unlink().
> >>Since snapshot creation won't check the permissions of the containing
> >>files/dirs, it can copy a directory which cannot be deleted by the user.
> >>Therefore if we won't allow "sub del" for the user, he couldn't remove
> >>the snapshot.
> >
> >Maybe snapshot creation /should/ check all that, in ordered to allow
> >permissions to allow deletion.
> >
> >Tho that would unfortunately increase the creation time, and btrfs is
> >currently optimized for fast creation time.
> >
> >Hmm... What about creating a "temporary" snapshot if not root, then
> >walking the tree to check perms and deleting it without ever showing it
> >to userspace if the perms wouldn't let the user delete it.  That would
> >retain fast creation logic, tho it wouldn't show up until the perms walk
> >was completed.
> >
> I would argue that it makes more sense to keep snapshot creation as
> is, keep the subvolume deletion command as is (with some proper
> permissions checks of course), and just make unlink() work for
> subvolumes like it does for directories.

   Definitely this.

   Principle of least surprise.

   Hugo.

-- 
Hugo Mills             | ... one ping(1) to rule them all, and in the
hugo@... carfax.org.uk | darkness bind(2) them.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                Illiad

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaKUYBAAoJEFheFHXiqx3k4GYQAJnGkn1PRATSiYFfnVDvNgCT
AYMcNqYCPuBLSZ8BpyWk+Dx39JooilrFvs+cQGRZiuyWlhp25TLWWI/PkyDg1aop
pythS0HoZJl9o8uQ4HvhDI6PMRzD/SaYIVW/fks+rUWXo0tVt17z1FoOXza4MKw+
J4/VSM2iNOdrhK2g6nxL8EZhPG0rZxqvVQC+MF3NDzX47EDHwRM8A88iAHmdhUnr
/+UiJK1JHpL7T/zkqvfucsemHFDhaIVPGsIpNDVtDdTlhgueA7cnM25MdX75UMB1
w6SIHRi2pCvAlV9+CiCMdW/slJLJ11ShNi4wfiuU5XPSezYGksVHgmXh8DFOBm6j
VQnO1WoFJNDrfFdz/DbWPY+eXg1/SyeNg7esjY6sciMiHF9tyJiwNAnrlDXGCUoT
bI0tEKCociLBSC2JLkR7stUnQOkBK+UCDWqzSjsUqEt3IYOe41cEBsyGzY01YCX5
xmv6rvZ61+Nu0QTdHTqxIplW03VjU/n+DDzn6UMEnRSOuQojlI5GXt8tXDjG7ZTf
PQqwAVMDJB0xSa1TEEf9n0YnvSkzf7NLajRgySEm2dH5+lszqfcFNFguPcocaArZ
7O53hsuRPYs3PpJpfwUJelP993EvBMJF5aCcugEzSURz71KKsnNxJm7cvWYiUY/1
W+5igWtPceCNfUr5Dd2G
=+dGM
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
