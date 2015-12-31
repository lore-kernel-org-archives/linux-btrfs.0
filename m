Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51990 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbLaUYW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 15:24:22 -0500
Date: Thu, 31 Dec 2015 20:24:19 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs fail behavior when a device vanishes
Message-ID: <20151231202419.GZ1586@carfax.org.uk>
References: <CAJCQCtQxFm5L-RtP9Ph8qaYtG0jVo3PfrHj6U35LJSStB5pyuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eP8xGX2lG1UwfyBj"
In-Reply-To: <CAJCQCtQxFm5L-RtP9Ph8qaYtG0jVo3PfrHj6U35LJSStB5pyuQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--eP8xGX2lG1UwfyBj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 31, 2015 at 01:11:25PM -0700, Chris Murphy wrote:
> This is a torture test, no data is at risk.
> 
> Two devices, btrfs raid1 with some stuff on them.
> Copy from that array, elsewhere.
> During copy, yank the active device.
> 
> dmesg shows many of these:
> 
> [ 7179.373245] BTRFS error (device sdc1): bdev /dev/sdc1 errs: wr
> 652123, rd 697237, flush 0, corrupt 0, gen 0
> 
> Why are the write errors nearly as high as the read errors, when there
> is only a copy from this device happening?

   I'm guessing completely here, but maybe it's trying to write
corrected data to sdc1, because the original read failed?

   Hugo.

> Is Btrfs trying to write the read error count (for dev stats) of sdc1
> onto sdc1, and that causes a write error?
> 
> Also, is there a command to make a block device go away? At least in
> gnome shell when I eject a USB stick, it isn't just umounted, it no
> longer appears with lsblk or blkid, so I'm wondering if there's a way
> to vanish a misbehaving device so that Btrfs isn't bogged down with a
> flood of retries.
> 
> In case anyone is curious, the entire dmesg from device insertion,
> formatting, mounting, copying to then from, and device yanking is here
> (should be permanent):
> http://pastebin.com/raw/Wfe1pY4N
> 
> And the copy did successfully complete anyway, and the resulting files
> have the same hashes as their originals. So, yay, despite the noisy
> messages.
> 
> 

-- 
Hugo Mills             | Well, sir, the floor is yours. But remember, the
hugo@... carfax.org.uk | roof is ours!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                             The Goons

--eP8xGX2lG1UwfyBj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWhY7zAAoJEFheFHXiqx3knk8QAJOM1pUeLAIKPJk0NWZLhzw+
NRwWGljwvacsgIgQ2t/nYNz0fTjmwFVbF18eAK0SlKwv+fNMV5qtOvzYBf0FmM37
3hd+WSxnSnoSnJP4OgPzP388ogo2tqUDjsa4PHSZeZ4TaHRGKtQ7nNEArk1GuEn9
KNZA5flgDeEvs434PEqsZtbfgIhsZj4sKo3RX/RKiQF4mb1Zen01OO0VyDbVDGxe
k/2ntYDBY8oEh5KGE3O29aGtuk1x6aE8iZwWkWmeDH/qH/j7hQUQbYr6q+i35awy
XSOvNeM8WymhQvya8emrXITPjSendIQn7Xk+xovxCnGQYUzj/0Vk3C2BWctrJL7P
A+S5snYJvxCwDF2dRuwhVpv5LfAzClnzA6L5YjEhL4/+8Ozxdkf6iBSsd2cn4RPK
H9eMVD+LKwGpdsXoybCPcUQEt+aLuNzHV2a1ihqC+oP+RRZ30oaC85kftJk2ybCK
BCBCJ9wCNVurUsVVCUa3Gfpotn/bE5VFa6xvzy2tEYPuxm2JQ7OUrfkg16qsGIst
II+7Wz8YkBIjm5FgylgV+Ii4LgJGI+z//AD9830xluyDiYf7M6jkK42c4asmitMh
uNqvWWX7x39cLmA1cA7rrGaOGoAKhyZQ/9QWBlpo8PAnT39cRFBbnTefbm7U26yE
AVTaeQx2voxgOoPk2a0U
=HfOD
-----END PGP SIGNATURE-----

--eP8xGX2lG1UwfyBj--
