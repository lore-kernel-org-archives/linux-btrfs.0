Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49845 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753069AbdCWKJx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2017 06:09:53 -0400
Date: Thu, 23 Mar 2017 10:09:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Sean Greenslade <sean@seangreenslade.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Cross-subvolume rename behavior
Message-ID: <20170323100950.GI11714@carfax.org.uk>
References: <20170323053723.GA32087@coach>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jQIvE3yXcK9X9HBh"
In-Reply-To: <20170323053723.GA32087@coach>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jQIvE3yXcK9X9HBh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 22, 2017 at 10:37:23PM -0700, Sean Greenslade wrote:
> Hello, all. I'm currently tracking down the source of some strange
> behavior in my setup. I recognize that this isn't strictly a btrfs
> issue, but I figured I'd start at the bottom of the stack and work my
> way up.
> 
> I have a server with a btrfs filesystem on it that I remotely access on
> several systems via an sshfs mount. For the most part this works
> perfectly, but I just discovered that moving files between subvolumes on
> that mount fails with a confusing "Operation not permitted" error.
> 
> After doing some digging, it turns out it's not actually a permissions
> error. If I do the same operation locally on the server, it succeeds,
> but an strace of the mv reveals that the rename() syscall returns EXDEV.
> The mv util takes this as a sign to fall back on the copy-and-delete
> routine, so the move succeeds. Unfortunately, it seems that somewhere in
> sshfs, sftp, or fuse, the EXDEV is getting turned into a generic
> failure, which mv apparently interprets as "permission denied".
> 
> So my question for the btrfs devs: is rename()-ing across subvolumes
> not feasible, or is this simply a case of no one has implemented that
> yet? 

   Direct rename (using rename(2)) isn't possible across subvols,
which is what the EXDEV result indicates. The solution is exactly what
mv does, which is reflink-and-delete (which is cheaper than
copy-and-delete, because no data is moved). In theory, you probably
could implement rename across subvolumes in the FS, but it would just
be moving the exact same operations from userspace to kernel space.

   I think that the solution here is for the sshfs stack to be fixed
so that it passes the EXDEV up to the mv command properly, and passes
the subsequent server-side copy (reflink) back down correctly.

   Hugo.

-- 
Hugo Mills             | I'm on a 30-day diet. So far I've lost 18 days.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--jQIvE3yXcK9X9HBh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJY057uAAoJEFheFHXiqx3klJwP/RKXeT0MFYvkis/M740WLlR0
8R1eiVptILdHfjdUtWtMw45z89wDOIO4+K0QlIvGg9HpaUvYOIQ428HtYunhf235
z3l2YnBcIZGX7lvcloyuPkoZwf+1Ht0HYiAEdsM11gLV2wVeKcAk2tDlYYdSD8mf
8snbS3rg+qs/slBfIdKAqr9D51lMtV+Vxe48tdxUknsj0kdZPm2JMo0juV1KOl7C
3mFKFaoA9mZlQ4H7ApENfYUoSQ6Mm8peOilamS7IsCSnelMiwiW1jfj0HTv4wgt5
0OwSVD1QU6TqmSm+PeuJuApXTzSiNlxmAGSujShbrrJm7YdJAvYKMrSmqTjw8iL9
vwhTzBAps3qbV5qIC9Ae0DPEVcI8+eYD8vciyFKd4DIuMNEy8u5QVeGtILrZrmky
0pVJiwCdfYwoTfeYnMTyV1I4pJOvAp9gyVsr32j0uoRM0xcBSQ3poPzELrWorMh4
9wgqQCHdXzod+oPUJXoHLk9kLiAs2ugH6YtRdM7ZrVIDJfRd/dCks0bFcJHGpqcu
tOuK2BN1dJHc/pIjvPb2XCVUB9ONSn8h73LBHXkfzagqMlt5VDrjaFXcZSIwepkm
/kdWw75Wogi4aK8zNUknpb71Xhqu8sI9xSrKq0419N/ru7W9d9Gc8tvcTpTSXzQN
VUc6xYgKVKKqEe9HMVsX
=lITK
-----END PGP SIGNATURE-----

--jQIvE3yXcK9X9HBh--
