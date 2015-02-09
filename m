Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59747 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880AbbBIIjp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 03:39:45 -0500
Date: Mon, 9 Feb 2015 08:39:41 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.net>
Cc: "Devon B." <devon.b@virtualcomplete.com>, linux-btrfs@vger.kernel.org
Subject: Re: Accepting discard to free space from disk images
Message-ID: <20150209083941.GI28427@carfax.org.uk>
References: <54D842FD.1010806@virtualcomplete.com>
 <20150209114023.137402bf@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wIc/V6YLA2QdyfT4"
In-Reply-To: <20150209114023.137402bf@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wIc/V6YLA2QdyfT4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 09, 2015 at 11:40:23AM +0500, Roman Mamedov wrote:
> On Mon, 09 Feb 2015 00:17:49 -0500
> "Devon B." <devon.b@virtualcomplete.com> wrote:
> 
> > Looking to use btrfs with disk images that contain ext4, xfs, and other
> > possible filesystems.  One of my main concerns is reclaiming disk space
> > when files are deleted on the disk image's filesystem.  Using fstrim on
> > the mount point of the disk image or mounting the disk image (loop) with
> > discard doesn't appear to pass the freed blocks to btrfs.
> > 
> > The image file on the btrfs filesystem just keeps growing in size.  When
> > hosting images on ext4, using fstrim or discard frees up the space on
> > the host filesystem (ext4).
> > 
> > I see discard is pretty well supported for btrfs to the underlying block
> > devices but is there any way to properly free space on the btrfs host
> > filesystem from overlying filesystems while they are online?
> 
> I use KVM (QEMU) with discard pass-through from the VM guest ("discard=unmap"
> option), with the VM images stored on Btrfs. It works just fine, the disk
> space used for the image file does shrink when the guest OS issues discards on
> its FS. Maybe there is a difference in how KVM and the 'loop' module submit
> discards to Btrfs?

   This is interesting, because I've tried exactly that setup (KVM,
discard=unmap) and it's not worked for me.

   Hugo.

-- 
Hugo Mills             | If you see something, say nothing and drink to
hugo@... carfax.org.uk | forget
http://carfax.org.uk/  |
PGP: 65E74AC0          |                                 Welcome to Night Vale

--wIc/V6YLA2QdyfT4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJU2HJNAAoJEFheFHXiqx3k+FoQALxF58SJUj+QA9tCoVWZLuWL
x/kIMDtT01HIvA9sQM9an84lrE2fRSxE5l9L5tlO0T0GPyQ1e2OFyGMonoJqLBe5
tQFwUM4G1oPSnmdFgofhKVVv40YTYHj6j1QBv6FjB8rMyMt5JpgVtpUuviXDzX63
OfrIImt9gDzu+EMxVrI2Lgtz1qbJhzFGxiWIBvKYJ/J93/A3sfwizy5XSyrxrqJD
2Qo8xnbZvKBppi4dR3b21x/DKDC/Sp+d+kN4faLnmtc8g46aNw4oaXn1/La4JUHS
Bt5XqfiDTnTxTWBHYo/PZz1UAzk9PFgah/562EbIWcNYpu+i/9mFi45HM8KOM/Qw
cQLFLwnwR+Uw8x80fpboX0EyqgTa2B4Mt+34dHnrEAjb5HFSzW+fhutfjNYYwH5q
REVRK1mRFUprIPmBX6Skm330Bn48JiS1Oog8SAnZtO4Tz0EqlweYKL9QqN4DyDd5
2ZfJOC4JXpw6BbTTS+GlAt9iGzJaG4yWRBJrZ21BhFNmofAvjuKFsFSoADY/FfTp
UaWzUTfegbf6FIOUrmTGAPUfzFrra497O0JAUahk1A0dIX7dUGi+xaoFuZ7VS4IF
CSIMvfabwAsWsY4M3IMCEhFyBV6tciMQGnOSXl6qqksOopp4eB39stjbkQYLt1CU
PtLFI4Yfhd+7SmT2PjUR
=Unl/
-----END PGP SIGNATURE-----

--wIc/V6YLA2QdyfT4--
