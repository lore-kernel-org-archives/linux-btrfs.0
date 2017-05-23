Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56545 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032180AbdEWVwv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 17:52:51 -0400
Date: Tue, 23 May 2017 21:51:49 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
Message-ID: <20170523215149.GA2633@carfax.org.uk>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <CAJCQCtRXCWuCbchRxOBZA7Dfzt4vhED77d1boErTdOGAzAi4vw@mail.gmail.com>
 <pan$d0afb$8cb8ad66$8322610b$459f2144@cox.net>
 <20170523170025.sweg3oyzs5f2jxca@merlins.org>
 <CAJCQCtT1QKpPWmoKhM-LTN3bweW-Yq=fGMjJU+b4wW+h98ydJg@mail.gmail.com>
 <20170523214943.GN29894@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
In-Reply-To: <20170523214943.GN29894@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 23, 2017 at 02:49:43PM -0700, Marc MERLIN wrote:
> On Tue, May 23, 2017 at 03:38:01PM -0600, Chris Murphy wrote:
> > > I've tried an ext4 to btrfs conversion 3 times in the last 3 years, it
> > > never worked properly any of those times, sadly.
> > 
> > Since the 4.6 total rewrite? There are also recent bug fixes related
> > to convert in the changelog, it should be working now and if there are
> > problems Qu is probably interested in getting them fixed.
> 
> It was a 4.9 kernel from debian.

   It's the userspace tools that make the difference here (and what
Chris was referring to). Conversion has nothing to do with the kernel.

   Hugo.

> The conversion looked like it worked, I rebooted ok, and then it got
> corrupted quickly after I deleted the subvolumes that had the old ext4 data.
> I've since wiped that disk and done a fresh btrfs install on it, because I
> had to get some work done :)
> 
> Marc

-- 
Hugo Mills             | Essex: a branch of philothophy.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZJK71AAoJEFheFHXiqx3kvCMQAJgQEpB5j9n26Jl8HBen/JWr
5dhusLHEegArbkUDoCVvlUdUx/J4Ycer/QuMW3b4IlOzZgspycmUPt21TxqUUlKM
SyRiXaQGd//f+MUM2m/Vt1XHxXXv5nN/oIkoQe0g/AwOjJ+QFDQI304Rom3eeBEi
uVlmO8EWCayyNIiWsFtqVWkeudHe1vfsuQl3tC/zAFJqa6YvtfCCGR/SbLfvCdEQ
E3z7ILLk0/Yh42pHMsrPqNlQLo6kpld1DVeq+tgO9+nfkmDUPAp4nrwu0fPUBMkh
baG+8eZjfUlPyDGRr3T6iEmmXB3BvS9mj76dfm3hGxIgPc5pSuGv/x6hUOPrEm1e
HNaFKQro04ryXEUbbfp/MudiC+FSSRc8Ah3GXkA2Iysdw8cPuPtQNjJ6SvK3HIJz
eVKK4y22sIcNtlYrFTFW5QC8Fd9dsw81zFn4WmgU4IvLy6AFeePvIrXexefxjpiI
FxvPYwPtHwa9tLB88cjmUPKKxkeWKPboG8qjlKJR5a69gJD56x+kiUVprwqTmzsN
ru/uFkB72ox1y6jOqfBYGqzzCGLbr+QqB5unFXwIbwHyezQOEMbIpeAuz3oe8SR5
oWM0DlWrVgEXoEv8CRQ5AvQ9N4+p4FPFsD4usQ1vY21k1/TtLrqWr7NkwkHSSvo5
grAlvvybT3Ub8fQY0r9b
=0QP3
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
