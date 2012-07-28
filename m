Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:60652 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab2G1MJA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jul 2012 08:09:00 -0400
Date: Sat, 28 Jul 2012 15:08:47 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120728120846.GA8733@sli.dy.fi>
References: <20120705234739.GA9736@sli.dy.fi>
 <4FF6C12A.10305@jan-o-sch.net>
 <20120706143350.GA10427@sli.dy.fi>
 <4FF6FF8C.4010007@jan-o-sch.net>
 <20120706234405.GB8933@sli.dy.fi>
 <4FFA9EEB.7060008@gmx.net>
 <20120710041625.GA8909@sli.dy.fi>
 <4FFBD24E.2050902@gmx.net>
 <5003CECC.2040908@gmx.net>
 <20120716212932.GB8653@sli.dy.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
In-Reply-To: <20120716212932.GB8653@sli.dy.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 17, 2012 at 12:29:33AM +0300, Sami Liedes wrote:
> So, currently my idea is to boot the machine with a live USB stick,
> install kvm and make qemu qcow images backed by the real (2*1.1T)
> devices, but writing changes to the qcow images (I dare not mess with
> the actual devices, and don't happen to have quite 2.2T extra space
> outside of them...), and try to run scrub there. If that succeeds and
> the bug happens there too, debugging *should* be easier, and it
> *should* be possible to run it under KMEMCHECK too. If the bug doesn't
> happen inside a virtual machine, that would be interesting information
> too.

I have now been able to reproduce the bug in KVM with the setup
described above.

I think it's safe to say now that the bug depends on some kind of
interaction between btrfs and dm-crypt. With the following setup, the
bug does NOT happen:

* kvm, single cpu

* sees 3 disks, /dev/vda=root, /dev/vdb=btrfs-dev1, /dev/vdc=btrfs-dev2

* The btrfs devices are essentially snapshots of the real btrfs
  devices in raid-1 configuration (2*1.1T). As the real devices are
  encrypted, the decryption is done outside the KVM, i.e. the KVM
  snapshots are backed by the decrypted devices.

With the following setup, the bug DOES happen:

* kvm, single cpu

* sees 3 disks, /dev/vda=root, /dev/vdb=part1, /dev/vdc=part2, where
  part[12] is are LUKS containers containing the individual btrfs
  devices

* inside kvm, they are opened using

    cryptsetup luksOpen /dev/vdb root1
    cryptsetup luksOpen /dev/vdc root2

* after this, the filesystem is mounted with

    mount /dev/mapper/root1 /media -o device=/dev/mapper/root1,device=/dev/mapper/root2

* The devices are snapshots of the actual physical encrypted
  partitions containing the btrfs devices.

I have not yet figured out if this can be reproduced using a pristine,
smaller btrfs filesystem in raid-1 configuration inside KVM or if
there's something about my specific filesystem that causes this. I can
investigate that too; it's easier to do for me than the above testing,
as I don't need to have continuous physical access to the computer to
do that.

Here's the .config of the kernel I used inside KVM to reproduce this:

  http://www.niksula.hut.fi/~sliedes/btrfs/config.3.4.4

I also ran the same tests with KMEMCHECK. Both with and without
crypto, there were quite a number of (of course possibly false)
warnings from btrfs code. I doubt any of them are related to this bug
- there were no KMEMCHECK warnings during the scrub operation. Here
are the logs, anyway:

  http://www.niksula.hut.fi/~sliedes/btrfs/screenlog.nocrypto.gz
  http://www.niksula.hut.fi/~sliedes/btrfs/screenlog.crypto.gz

	Sami

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJQE9ZOAAoJEKLT589SE0a0jrIP/1eKkY7plKY73TFnwaYxRbvX
oS182KCQQ0GUdT5rqu6vQPteitr8y4CpL1a8/QAfrdyB6V5p8DZi8iHOt0/g7h8G
MrmXHkpX3vj49rnF01lbR7Y8JhUx9CUZx1n2lGPmwuPPwHp3aleV3XuBHC/+eMc0
Gz9Hq2xBs15Rn+A+E5+12c9g66XtBfIVqD3VB0K/R+EnyT06MH2mIUb/7pmEVIzC
wFmRJSbo3SFkrXMFHMFE/Urj8u6ktPLQ7yNZm3MWvjkud28sA+WsxQvPzkE5noRY
wJ5Dh6NjTXf3d4KrGLtNiUBZLD1YhrfhnC7HtKLJd09vAqi6Z6drz1pcTYGr3GcE
kRf7C2q5bXBi4wjVBep+/zSrJuabHxQXFvO4YAxLtKyRSOVUc1tW6G1lvT3akT/L
IhvqoOVk9mzs6fvoRdPcxtm1AHg8+W2Dx47d9+2K32Fd8kC6fFNaVzUkqqtVPskl
J65vtib6a+gURNVoR+yMLrSo+QURuzBfdlSDKSbrRADOZATa4re1WFe4S/yD91xX
k6EBw5NgJYQ+jzvK4YsXCT7tXBRTp26bSoNtQ+7QKMR3zoELg8bJgA5lXfCV1ZTu
cnCQrV/2YVTOmbs/udvA7ZMGaP22UKgjGEOsDJAfmLGTDD5UF/q3tzPWTVyJ12tb
LaYkQ03qv6qlj+Vu7bhC
=6lFC
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
