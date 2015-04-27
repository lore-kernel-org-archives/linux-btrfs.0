Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38826 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964772AbbD0Ozu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 10:55:50 -0400
Date: Mon, 27 Apr 2015 14:55:49 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs freeze/thaw when using with LVM2
Message-ID: <20150427145549.GC18187@carfax.org.uk>
References: <loom.20150427T140306-446@post.gmane.org>
 <20150427121521.GB18187@carfax.org.uk>
 <loom.20150427T163556-13@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hu1ClgjWvfumRnAp"
In-Reply-To: <loom.20150427T163556-13@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hu1ClgjWvfumRnAp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 27, 2015 at 02:41:41PM +0000, sri wrote:
> Hugo Mills <hugo <at> carfax.org.uk> writes:
> 
> > 
> > On Mon, Apr 27, 2015 at 12:05:28PM +0000, sri wrote:
> > > Hi,
> > > 
> > > I would like to know if btrfs file system is created on LVM2 logical 
> > > volumes, does freeze and thaw operations takes place for btrfs to 
> make 
> > > file system consistent??
> > 
> >    No, because the filesystem is *always* consistent, because of the
> > way that the CoW update mechanism works.
> > 
> > > If not is there a way (ioctl etc..) to run btrfs freeze/thaw before 
> and 
> > > after creating LVM2 snapshot of a btrfs file system?
> > 
> >    As I said above, none is needed.
> > 
> >    HOWEVER, you shouldn't take LVM snapshots of a btrfs filesystem AT
> > ALL, if you have the original FS mounted on that system, or if you
> > plan on mounting the FS or its snapshots on that system. It's fine if
> > the only things mounting it are independent of the base system, and
> > don't see the snapshots (e.g. you're exporting LVs as block devices to
> > a VM host, and the snapshot is never seen by the VM; or you're
> > exporting LVs via NBD, and the remote system never sees the
> > snapshot).
> > 
> >    If, on the other hand, you're expecting to have /dev/mapper/foo
> > mounted, and then take a snapshot of it on the same system, you can
> > expect massive filesystem corruption, because the kernel can't
> > distinguish between the original block device and the snapshot, and
> > may try using the wrong one (or possibly both).
> > 
> >    Hugo.
> > 
> 
> :) Thank you for your input. Past couple of hours, i am unable to figure 
> it out what is happening with snapshot.
> 
> I am experiencing similar what you have explained.
> taken a lvm snapshot using lvcreate of /dev/mapper/foo name 
> /dev/mapper/foo-snap.
> 
> /dev/mapper/foo is mounted on /b1
> and I have mounted /dev/mapper/foo-snap on /b2
> 
> after running mount command, i have seen there is a change in the mount 
> entries. i.e. for both /b1 , /b2 mount point is changed to 
> /dev/mapper/foo-snap.
> 
> And any write to original or to snap shot are reflecting on both.

   Correct, this is the behaviour I was referring to above. You're
likely to see corrupt filesystems if you do this.

> This is strange considering that I wanted a consistent snapshot of 
> entire btrfs filesystem at volume level.
> 
> Is there a way to achive this? or btrfs just cannot provide?

   No, there's no way to manage it with the current btrfs code.

> I am looking for a way make entire btrfs (which includes subvolumes in 
> it) consistent so that I can take backup of the file system.

   You're probably looking for some variant on the recursive snapshots
idea. I know at least a couple of people have ideas on how to do this,
but I don't think any of the ideas are close to completion.

   Instead, I would suggest looking at which pieces of your system are
*required* to be consistent, and put those on their own subvolume(s).
For example, in a multi-user system, I would be very surprised if the
individual users' home subvolumes had to be snapshotted as a whole --
nobody will care if person A has their snapshot taken a few seconds
(or even half an hour) before person B. Work out what you can get away
with non-atomically for your needs, rather than simply requiring a
complete atomic snapshot of everything, because if you're using
multiple subvolumes, that's simply not going to happen right now.

   Hugo.

-- 
Hugo Mills             | Two things came out of Berkeley in the 1960s: LSD
hugo@... carfax.org.uk | and Unix. This is not a coincidence.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--hu1ClgjWvfumRnAp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVPk30AAoJEFheFHXiqx3kTxMP/iAL101fiSn98fslm6u57cA7
QegvNBmkD+gMC86/wJ/V0sN+wtfUL2/lj0PRB2ZfYw5ryj6oAVomR/zYY6vdBT/a
i9WTeexTnBDeEksDUc9lwIDtZAZRB+exaBMKyLnJvLiVpqz1+urzrkJtRC6bWx9t
upvO1bI1QFNYODreErtWmIowAfFsPomWH7MI/k2zsM8vDDRCut8+VIuHv8cu5CWx
RYPudHecAGrE2zXjzdLnla0Qfa6h5Kh88OGHvwiF6+SHjuYLvWwmKn2CGUBvBSLn
McyZ3SnqNp7caJ6DR3E6uMQM544YUK/N2qKrrRli79gdU6dFy6+5qLf5h9fGZ9TS
QA4kVct11hgJFfu9k/RWJaD1LjOBLpfoW4riLr8NW5Pg/fyDCW1gNI2KW5VzTJGD
OqsJqHI/LZJJIffdArweZOqsFxwI8Oj1T6CNvBX9P4V1shhXmrqCYsK00mqWbpih
jGzN82Nd1PCBJ2XTzXfzB0CbPpBZrlsseH4OG35JM7aklIH2e+t1/xM+VMAqGyhu
NykTxeAX/zDCEYR6eP+r8Dq7AZUc7iw0MwUla0IIlSNuvUwS1vgDpls/kyofzDsY
ETbEpskv/D5bPo8W9MEvwjbumVCgwISl5NYJ7eJXwO9GXPYl3wP+vMqVfjMqWLxp
WGkHIwDGBQsv8Py0YktM
=5kf1
-----END PGP SIGNATURE-----

--hu1ClgjWvfumRnAp--
