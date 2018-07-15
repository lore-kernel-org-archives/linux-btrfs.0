Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54400 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbeGOPJy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Jul 2018 11:09:54 -0400
Date: Sun, 15 Jul 2018 14:46:40 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
Message-ID: <20180715144640.GA21293@carfax.org.uk>
References: <cover.1531503452.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
In-Reply-To: <cover.1531503452.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 13, 2018 at 08:46:28PM +0200, David Sterba wrote:
[snip]
> An interesting question is the naming of the extended profiles. I picked
> something that can be easily understood but it's not a final proposal.
> Years ago, Hugo proposed a naming scheme that described the
> non-standard raid varieties of the btrfs flavor:
> 
> https://marc.info/?l=linux-btrfs&m=136286324417767
> 
> Switching to this naming would be a good addition to the extended raid.

   I'd suggest using lower-case letter for the c, s, p, rather than
upper, as it makes it much easier to read. The upper-case version
tends to make the letters and numbers merge into each other. With
lower-case c, s, p, the taller digits (or M) stand out:

  1c
  1cMs2p
  2c3s8p (OK, just kidding about this one)

   Hugo.

-- 
Hugo Mills             | The English language has the mot juste for every
hugo@... carfax.org.uk | occasion.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJbS15PAAoJEFheFHXiqx3k7OIP/395vvP2ts+UI3rNc11HL9sm
otuyrQnheQFr0s5w2eMPzuEOH1S1meZq9+eNjk03Pm8wh97TRJQibwEMvLY9ejV8
HGa0ZUfqbuQZxa2DP7O82mN9u9oStAR37ENusknr9fM/fJlditysKWZKy8G6Cbzo
4qfsQV9/laibOU3gn1f1jvaSk2Nx5zTkvRV6iAcdh28+w/ipdvlkJKWgTy7GyDyb
fIeIq9hiNWgiGI767qW0VTxMKw3JcncZt6/z4L0ZAY2B7zQEtLHJeRENOYrT1bpg
/uUlgdXxSc3NgEdSl+ldgY+7yK3K5ie6RSrgTu/ZwvJjKsHuF+qfOZR99c3oFhwm
LNwhKcrLXeeWYpRL7IrO6vAaImEJoeMSLAdQM/ajvN7rTWMVqfAa1eErdTVeOYP+
VTYswIFkZANmPfZ2Fz4WHArJmrK3tFD/dQCqkQN7GpVKisJ+QaI5/Kyx+LDR3wCY
I+MFudz7AkKPlRSB35zHw84QOorMyuVh8LrgSIgBTgdG7207k0rbjPZJlJfmOmsC
W5w6dzV5Fg4zDGxd4WBQJIX2rh0RsCK6hj5I7+yF7oQ6ts6NOkYf4EuJVmLVAKx/
szR85qTWdM1syznY3Q6DAUr5dHW81tSt/3U+ClJUdhoLMObhjiDyHuoAYnCs/uPa
pZMXM7pdys1SLVnsqh4r
=XxML
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
