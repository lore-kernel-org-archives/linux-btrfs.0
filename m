Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57519 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdBJXtb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 18:49:31 -0500
Date: Fri, 10 Feb 2017 23:49:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: John Hendy <jw.hendy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: proper syslinux settings for ext4 boot, dm-crypt + btrfs subvol
 root?
Message-ID: <20170210234927.GK4249@carfax.org.uk>
References: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cQXOx3fnlpmgJsTP"
In-Reply-To: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cQXOx3fnlpmgJsTP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2017 at 11:40:41AM -0600, John Hendy wrote:
> Greetings,
> 
> 
> I'm trying to utilize btrfs subvols to allow me to boot separate
> distros without having to create so many partitions. I'm on Arch Linux
> and not finding the wiki super helpful with specifics on dm-crypt/luks
> and btrfs.
> 
> Requested info:
> 
> $ uname -a
> Linux arch_zbook 4.9.8-1-ARCH #1 SMP PREEMPT Mon Feb 6 12:59:40 CET
> 2017 x86_64 GNU/Linux
> 
> $ btrfs --version
> btrfs-progs v4.9
> 
> $ sudo btrfs fi show
> Label: 'bigD'  uuid: e1284231-c264-4944-807d-5fcb1832ce47
> Total devices 1 FS bytes used 1.27GiB
> devid    1 size 232.38GiB used 3.02GiB path /dev/mapper/btr
[snip] 
> My functioning syslinux.cfg:
[snip]
> Current behavior is I successfully get a syslinux boot menu (at least
> after I disabled the 64bit default option), but selecting the above
> entry just refreshes the menu and I'm stuck there with an automatic
> countdown from 5sec and then back to 5sec when it hits 0. It's like it
> just keeps pointing at the /dev/sdb MBR or can't find something and
> thus tries again?

   Just as an aside -- it doesn't affect you here, but you might want
to be aware -- syslinux doesn't support multi-device btrfs. I've been
bitten by that before, and it's a consideration for you should you
wish to add another device to this FS. Also, I haven't tried it, but I
suspect that it may not support compression in btrfs either.

   Hugo.

-- 
Hugo Mills             | All mushrooms are edible, but some are only edible
hugo@... carfax.org.uk | once.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--cQXOx3fnlpmgJsTP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYnlGHAAoJEFheFHXiqx3kBDoP/RiByNTabZGewkbngc6uSZ71
jPAkY16UPpYgRT2Zb4T/MMaToCyPYeXRCC+6roKCSoN07GnSfaCWR/WuUTjFeSW0
LOEhosrMPnN8LfrKwE3eEV5LCE6QhMSlhXZotKwi0odKV9ZZYUr4RQWowhtqcDoh
wY9PiCIK4D0Rioq+Ur8YnW7PMEZKjDcj5kgHQFLsff4gbDzVQw8DelssLvXRRUT5
iT8hHmL/OHkWl71ka1HTDn8/mhhkeKYamKwlwbwwrYdfEJAWJN0MZVhsxZWoJ40a
guPxMtbpeF1qf1Ti4XptrEFttCnp6RvCHJqna8ryxNDwdqhkDkUf4Y2YHhCuwg2w
aoLF6oWyiRQe658K8Pl9jiVUhrZR2i3xbWjW7wUGbm9AePmT5C7D5yi8GZVEPNEq
0qy2SBqUx7wuILQbHg7sv4lmLzvuVy+GRcfOLkuDWGS7Jo38ASaZbGY5owJQGpk+
x2lLTYhxD4t5hFWMAYUWj+IQYsEehGL7d32w57P1txphuOP67QIAKQtsmfpVzogb
DBR/HksEupq9e+iESXWxzPPP4PwaoOEEvYHpYaSta1s4zrgAwGypFW8lYjQj7fx7
DUBa866EoXwPXi5jIK2RrwNuHXgzKc5LjGfNZj8OYVKSU6zkjlKWlXsS7/6LLgcc
89RO8caOpGmjXvg8ONTX
=lHXr
-----END PGP SIGNATURE-----

--cQXOx3fnlpmgJsTP--
