Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60555 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbbDVWFH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 18:05:07 -0400
Date: Wed, 22 Apr 2015 22:05:05 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Diego Remolina <dijuremo@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Help with btrfs filesystem problems
Message-ID: <20150422220505.GR18187@carfax.org.uk>
References: <CAKRyD=u8jbP7-QMuNPEF9v89hECKt0GGBpTY0TYLf-CA1v2M2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ByM1h5nouWwd3kz8"
In-Reply-To: <CAKRyD=u8jbP7-QMuNPEF9v89hECKt0GGBpTY0TYLf-CA1v2M2w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ByM1h5nouWwd3kz8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 22, 2015 at 05:47:17PM -0400, Diego Remolina wrote:
> In 2012, I setup a Centos 6.x machine with a btrfs file system on top
> of DRBD, we did some testing prior to going production and it seemed
> fine, and has worked fine for a long time. However, now we are
> encountering problems and was wondering if I could get any help.
> 
> [root@ysmha01 tmp]# btrfs fi show
> Label: none  uuid: 7a38f3ab-f3b0-4b3d-81c0-28b347b26da1
>         Total devices 1 FS bytes used 5.79TB
>         devid    1 size 18.19TB used 8.94TB path /dev/drbd0
> 
> Btrfs Btrfs v0.20-rc1

   This is old, but probably not related to your problem.

> While still running the official Centos
> kernel-2.6.32-504.12.2.el6.x86_64 the machine started crashing with a
> kernel oops. Since that happened, I tried a few different 2.6.32
> kernels with the same result. Yesterday I switched to the elrepo
> kernel-lt 3.10.75-1.el6.elrepo.x86_64 version

   These are very old (3.10) and utterly antique (2.6.32). Even with
backporting of patches, there's almost certainly some serious bugs in
those versions that have since been fixed.

> and was able to get the
> machine up and running and found some error messages which lead me to
> believe things were not too bad after all:

[snip]

> Apr 21 17:54:56 ysmha01 kernel: BTRFS warning (device drbd0): failed
> to load free space cache for block group 7255336419328, rebuild it now
> Apr 21 17:54:56 ysmha01 kernel: BTRFS warning (device drbd0): block
> group 7256410161152 has wrong amount of free space

   That on its own is, as you say, not a major problem. The fact that
it's repeating suggests that there's some other problem in there.

> Since then, the machine was left up and serving samba shares until it
> had another kernel oops this morning.
> 
[snip oops]
> ........snip......

   Someone may recognise that oops as a bug that's since been fixed --
but it's probably not likely, since with a kernel that old, the
information has likely fallen out of the head of anyone who might have
known about it.

> When the oops happens, then the mount point becomes unusable. What
> would be the best path to recovery from here?
> 
> What other information may I provide?

   I think the best thing for you to do is find a suitable 3.19 or 4.0
kernel and see how that behaves with this filesystem.

   Another thing to do would be to get hold of a recent (3.19) set of
userspace tools, and run btrfs check --readonly on the filesystem
(unmounted), and report back what that says.

   Hugo.

-- 
Hugo Mills             | People are too unreliable to be replaced by
hugo@... carfax.org.uk | machines.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                              Nathan Spring, Star Cops

--ByM1h5nouWwd3kz8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVOBsRAAoJEFheFHXiqx3kWdIQALaiv3fwrVRSwRBQzcordgo4
MVTTxe4SR/u7ugHrUi59QLPWgsq5oDp5gHAP2eOzGqEuNoZzvOAHfbKf61pqSZ+K
tQzttkZ9KXAQHnsRzW3VP449G750vvYCpuxtONI+TLQ+26kcC3T4+fiIxJoe8omU
k9+HvzwVw5NKF5CveSvFjwMlABUlhCBz6g3Z4oECFRknk/RUqLypVdBLzig3PlDp
Gs4m3GWrpfKXhzlcVZ4GaMSWJ++LU97aEyQbBfVTCiT4HwI/C79m2sh9BYdX1cGy
v++jXz26t8HV6JQ2I4OFWl+wWqTW+bcB4x0tSfA2a3jiTExa7M8nljCjKqEBqjbh
I578GuNt4npJ4KLglzG80hQBtiySfjy1oUeCZyAmfvcPoUTu5hJqqftvKRptnWVi
2PdZBkPR3Utp6/vU0VZOnUO4hD45em4FUER8IldkIWCGdJPZkU195GfcCD/upzKh
mx605m1NU93yRdhvj0izSBZI+j/Ryp6z7dZlPxmCg8ncqH68cwkMvFFL7VyyCXT8
MEHJxwK1pm/S5bJPkx/jBGiUEYh2/EvBLsvM3R/z4nG/9uNf9Id9LNZnCEuj2v7i
E0Px6IAqcb+krQj1kDEgUmPjU3eCRr1wNVJ7ick3bft/ppPQ7yxOQT2Zf5x0FqlK
35LEMibR6UD3GKWWvjSp
=NWTS
-----END PGP SIGNATURE-----

--ByM1h5nouWwd3kz8--
