Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58414 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdLITxM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Dec 2017 14:53:12 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1eNlBP-0007Mu-Bo
        for linux-btrfs@vger.kernel.org; Sat, 09 Dec 2017 19:53:11 +0000
Date: Sat, 9 Dec 2017 19:53:11 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Odd behaviour of replace -- unknown resulting state
Message-ID: <20171209195311.GB26606@carfax.org.uk>
References: <20171209174348.GA26606@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
In-Reply-To: <20171209174348.GA26606@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 09, 2017 at 05:43:48PM +0000, Hugo Mills wrote:
>    This is on 4.10, so there may have been fixes made to this since
> then. If so, apologies for the noise.
> 
>    I had a filesystem on 6 devices with a badly failing drive in it
> (/dev/sdi). I replaced the drive with a new one:
> 
> # btrfs replace start /dev/sdi /dev/sdj /media/video

Sorry, that should, of course, read:

# btrfs replace start /dev/sdi2 /dev/sdj2 /media/video

   Hugo.

>    Once it had finished(*), I resized the device from 6 TB to 8 TB:
> 
> # btrfs fi resize 2:max /media/video
> 
>    I also removed another, smaller, device:
> 
> # btrfs dev del 7 /media/video
> 
>    Following this, btrfs fi show was reporting the correct device
> size, but still the same device node in the filesystem:
> 
> Label: 'amelia'  uuid: f7409f7d-bea2-4818-b937-9e45d754b5f1
>        Total devices 5 FS bytes used 9.15TiB
>        devid    2 size 7.28TiB used 6.44TiB path /dev/sdi2
>        devid    3 size 3.63TiB used 3.46TiB path /dev/sde2
>        devid    4 size 3.63TiB used 3.45TiB path /dev/sdd2
>        devid    5 size 1.81TiB used 1.65TiB path /dev/sdh2
>        devid    6 size 3.63TiB used 3.43TiB path /dev/sdc2
> 
>    Note that device 2 definitely isn't /dev/sdi2, because /dev/sdi2
> was on a 6 TB device, not an 8 TB device.
> 
>    Finally, I physically removed the two deleted devices from the
> machine. The second device came out fine, but the first (/dev/sdi) has
> now resulted in this from btrfs fi show:
> 
> Label: 'amelia'  uuid: f7409f7d-bea2-4818-b937-9e45d754b5f1
>        Total devices 5 FS bytes used 9.15TiB
>        devid    3 size 3.63TiB used 3.46TiB path /dev/sde2
>        devid    4 size 3.63TiB used 3.45TiB path /dev/sdd2
>        devid    5 size 1.81TiB used 1.65TiB path /dev/sdh2
>        devid    6 size 3.63TiB used 3.43TiB path /dev/sdc2
>        *** Some devices missing
> 
>    So, what's the *actual* current state of this filesystem? It's not
> throwing write errors in the kernel logs from having a missing device,
> so it seems like it's probably OK. However, the FS's idea of which
> devices it's got seems to be confused.
> 
>    I suspect that if I reboot, it'll all be fine, but I'd be happier
> if it hadn't got into this state in the first place.
> 
>    Is this bug fixed in later versions of the kernel? Can anyone think
> of any issues I might have if I leave it in this state for a while?
> Likewise, any issues I might have from a reboot? (Probably into 4.14)
> 
>    Hugo.
> 
> (*) as an aside, it was reporting over 300% complete when it finally
>     completed. Not sure if that's been fixed since 4.10, either.
>  

-- 
Hugo Mills             | I'm on a 30-day diet. So far I've lost 18 days.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaLD8nAAoJEFheFHXiqx3kj/YP/3YbM/cy/H57OJLCusn/SOfb
P9F23pQfYjhHClYM0FOsRr8atofG+6BflrxVgbFK7qyd8ANcy15zmT+DIxEOee41
XDGma9cQzVW897Vg756MKBcIswL68wJrlEINZHNWXTsIMRLXtPCBM4PtHjO1kARL
DVXAwPPJylDr73u1Mob6oX8QpO73GLefAe2oe7Tq6hIBaSqXhjwGbAiT+WVq4dCV
Ejm4qSB+eeHB/6dSoQc/26eDzygzrBTzaaYBnKaJek5OfPN/Ta5QiUAcqViCESed
/2Sm3trcVbfC7krOaIEFipS0tw2Glgz/3HwWMxgJ4piy5/mVF0lghr8k9FZCeoA3
cPdRKuQp7nrXgexpn3G0vEEBRLy+KMuwDRhLJEncMkJBdLEdRR/djDNsZ1FKV3eN
4QCi6wBVMLtMvt7Zb3mcTOMwr/ae3Qa+npUwlNNKvUUkF5IKALdic25ywQqcZcPo
8KK4YC3JYKE2SyOfi0tMwbVpGjh8b1lzL2r2F/yxDviMQ2nUW70fTeOzB56Us4HH
2yt/33HNav0EFzpf/Ew5Ky91jiYEgAFhtc2U15tYSdTORzgcKaWzr/bxzliV00lc
bIdKwdL2JoGlT0omV972D1eqLff0twLQPKgwq8NxpvjhtxIsl5283enWgtj5xl97
eSjzG4Rhp3fAkNvZmE/Z
=3Ht2
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
