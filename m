Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46381 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbdGVSQW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Jul 2017 14:16:22 -0400
Date: Sat, 22 Jul 2017 18:15:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: btrfs device ready purpose
Message-ID: <20170722181558.GI7140@carfax.org.uk>
References: <CAJCQCtR+dJr8H2co41LB0hEUZCFSnkixeyv46ccdureMiBVTWg@mail.gmail.com>
 <74c792e3-d8f6-fb09-c6ee-62dfdf59650c@gmail.com>
 <CAJCQCtTnfLiiURTzLre-ZYY5xQBjFf2Qrz02gqGvh6BbaF2=KQ@mail.gmail.com>
 <20170717155400.GN2866@twin.jikos.cz>
 <CAJCQCtTjKRZxN+MxyM0=DJmqF94WBrV3Uoz7kw5SGq_xQ1fzrg@mail.gmail.com>
 <9a16f6d5-90cd-bd04-a0ea-63e88cc3faf4@gmail.com>
 <CAJCQCtQBidjgsg4MadAAqoy6+dQHCkgz=8pxPX2CC=6Mwj38MQ@mail.gmail.com>
 <CAJCQCtQohx9MYbNFYyd6HidxSE6Cm7+ptwx76HmxBFdy9_7Zuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jk/5KjyVsvxWSMIA"
In-Reply-To: <CAJCQCtQohx9MYbNFYyd6HidxSE6Cm7+ptwx76HmxBFdy9_7Zuw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jk/5KjyVsvxWSMIA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 22, 2017 at 12:06:17PM -0600, Chris Murphy wrote:
> I just did an additional test that's pretty icky behavior.
> 
> 2x HDD device Btrfs volume. Add both devices and `btrfs devices ready`
> exits with 0 as expected. Physically remove both USB devices.
> Reconnect one device. `btrfs device ready` still exits 0. That's
> definitely not good. (If I leave that one device connected and reboot,
> `btrfs device ready` exits 1).

   In a slightly less-specific way, this has been a problem pretty
much since the inception of the FS. It's not possible to do the
reverse of the "scan" operation on a device -- that is, invalidate/
remove the device's record in the kernel. So, as you've discovered
here, if you have a device which is removed (overwritten, unplugged),
the kernel still thinks it's a part of the FS.

   It's something I recall being talked about a bit, some years ago. I
don't recall now why it was going to be useful, though. I think you
have a good use-case for such a new ioctl (or extension to the
SCAN_DEV ioctl) now, though.

   Hugo.

-- 
Hugo Mills             | UNIX: Italian pen maker
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--jk/5KjyVsvxWSMIA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZc5ZdAAoJEFheFHXiqx3ki+wP/At677vFa2hV0va7gCYR/cJ+
+wQN8idOneUyFFzD99uvh5QgUhcGGINo/ynoRETtvV4RBYq4cuL/PqYGgLE0dAq6
OOGSIE8af0Mvo0QOrlGcu1zbW73Gt6EnNRx3uuYh53ObRJ9WQcZ1F9+1x+yPSB9d
ItM8o9bf7iy1U8Z4dIviG7/cl+NJa51GjsN5hLs4lrlStb7SmC81TPxHtMKG17pL
1b9NOIWjAMqE8J0Gc6/aVr3m5hW9jKrNByOkkrrSUrzwhV8u2HorxG0u3uNHGYzE
ltyDpu7zCZJ34gwePjR3bRLlWui1hYlnv2vzDtzLHlOuLz/iC/GcfWQzBUXnkbxx
QlsYTgStMn35yHL4YS2h+yAYMcp3qETZCB4pZhvptKczNNrbIukLPWzy8Hln/lSu
t69ajuxtqoBMwL7+m6/uzEq180IoPvvq7iBxylRsidTU+h5WRMdrvHt3ggyCBdlr
bS+6VbLjwWGYxLU28Qd6dNayujyMHsHMwxZU/fIFfYXbarthzaWggDRN6L9nlnCD
sJqbHq85UPzNv8zx+wqu/K3BAt1aZe3PyaIPR+ZBqKNexEoO7cbHpPwiqcZWmh1z
OlKNfiTHjSHkuKdF0APEEZAF413d6xPNmCjjLMHxD3RQCfPOKh41C8JHhGs0+GMd
mLQ8vbAeuY/wZnOnqcvZ
=v0FY
-----END PGP SIGNATURE-----

--jk/5KjyVsvxWSMIA--
