Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-afa65.mailout.artfiles.de ([212.72.176.65]:60657 "EHLO
	mailout-afa65.mailout.artfiles.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483AbbGIWNq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jul 2015 18:13:46 -0400
Received: from [47.69.40.123] (helo=discus.localnet)
	auth=Wolfgang_Mader@brain-frog.de
	by mailout.artfiles.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80.1)
	id 1ZDK4d-0002Op-VF
	for linux-btrfs@vger.kernel.org; Fri, 10 Jul 2015 00:13:44 +0200
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Concurrent write access
Date: Fri, 10 Jul 2015 00:13:42 +0200
Message-ID: <1598536.6uUjd689JJ@discus>
In-Reply-To: <20150709220609.GI10539@carfax.org.uk>
References: <2035607.hrq9oNetle@discus> <20150709220609.GI10539@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8305800.J865CZurMW"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart8305800.J865CZurMW
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday 09 July 2015 22:06:09 Hugo Mills wrote:
> On Thu, Jul 09, 2015 at 11:34:40PM +0200, Wolfgang Mader wrote:
> > Hi,
> > 
> > I have a btrfs raid10 which is connected to a server hosting
> > multiple virtual machine. Does btrfs support connecting the same
> > subvolumes of the same raid to multiple virtual machines for
> > concurrent read and write? The situation would be the same as, say,
> > mounting user homes from the same nfs share on different machines.
> 
>    It'll depend on the protocol you use to make the subvolumes visible
> within the VMs.
> 
>    btrfs subvolumes aren't block devices, so that rules out most of
> the usual approaches. However, there are two methods I've used which I
> can confirm will work well: NFS and 9p.
> 
>    NFS will work as a root filesystem, and will work with any
> host/guest, as long as there's a network connection between the two.
> 9p is, at least in theory, faster (particularly with virtio), but
> won't let you boot with the 9p device as your root FS. You'll need
> virtualiser support if you want to run a virtio 9p -- I know qemu/kvm
> supports this; I don't know if anything else supports it.


Thanks for the overview. It it qmeu/kvm in fact, to this is an option. Right 
now, however, I connect the discs as virtual discs and not the file system, 
but only to one virtual machine.

Best,
Wolfgang

> 
>    You can probably use Samba/CIFS as well. It'll be slower than the
> virtualised 9p, and not be able to host a root filesystem. I haven't
> tried this one, because Samba and I get on like a house on fire(*).
> 
>    Hugo.
> 
> (*) Screaming, shouting, people running away, emergency services.

--nextPart8305800.J865CZurMW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVnvIWAAoJEGZtonfLCdqh/CgQAIqseqUsbwDCd6hv0d53OWoq
/9SiKT0uv/ySgyQ0GBLp1Hr/D6xP4mPBQOPTsZ1iMoRN4xAg4AsjJiAqCJPfLkn5
f67cz3+UnUHdGLdMHMOkiAj+5xhVwBgi6g3y2aKAeLkJAJ4vBjsgCIVPiYGXOWLb
6m780rKEHdVWzkHgpaU5QMysDXmV77FA7NPmx8TSGP/esyg9UAiL+eMAAxNFZ5pi
nf8Hdbqxu01sD9Vu73xKKICfI94FW1fiCIoMkWRhTIZfaqHLwohu4Zz0FT3M0zOz
ZcczuFmJbBJcrKu8/YdMjcTblycOkUHUJo1SMl/j/UTBfwE/oxgzcWk3vB94Za3Z
27EVCQN8rU38c4V1oQufswJsNhXHU2ND5XW8H/Qer77lSfHS/UDNASizhVFb/6xX
jY6Xwkmv74cGpocHPp8TEYW3UFMo0xf/iymTIkPsAojpIfS6kdes0h4tUI4Pua8e
GIgxhzB227Q0HQIHMjkhSde5B1TwctTMxYsNYOiNEs+RTVVqd5zWP4jBSXUj/1e2
Ox+einDNAvidONOhOQWAkwx3BUVcUbSiJliEafHhkOLlJgq3b1WFFpWaCJD7jkY5
en3RJHsT5tD+EoxZH+1XFvDbPVh9xkrZGsAQUqBs69dzISNv2Mi4rbLtTucrJCqm
BFGI7ZFpf/OC781gGNZ1
=AXZ/
-----END PGP SIGNATURE-----

--nextPart8305800.J865CZurMW--

