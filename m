Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38503 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbdLLOwD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 09:52:03 -0500
Date: Tue, 12 Dec 2017 14:52:01 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Neal Becker <ndbecker2@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: broken btrfs filesystem
Message-ID: <20171212145201.GA18793@carfax.org.uk>
References: <CAG3t+pHLcrMLH8XxWSc+P6v-gtMZds+RNKBz6RKzAWdWr8ObhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
In-Reply-To: <CAG3t+pHLcrMLH8XxWSc+P6v-gtMZds+RNKBz6RKzAWdWr8ObhQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 12, 2017 at 09:02:56AM -0500, Neal Becker wrote:
> sudo ls -la ~/
> [sudo] password for nbecker:
> ls: cannot access '/home/nbecker/.bash_history': No such file or directory
> ls: cannot access '/home/nbecker/.bash_history': No such file or directory
> ls: cannot access '/home/nbecker/.bash_history': No such file or directory
> ls: cannot access '/home/nbecker/.bash_history': No such file or directory
> ls: cannot access '/home/nbecker/.bash_history': No such file or directory
> ls: cannot access '/home/nbecker/.bash_history': No such file or directory
> total 11652
> drwxr-xr-x. 1 nbecker nbecker     5826 Dec 12 08:48  .
> drwxr-xr-x. 1 root    root          48 Aug  2 19:32  ..
> [...]
> -rwxrwxr-x. 1 nbecker nbecker      207 Dec  3  2015  BACKUP.sh
> -?????????? ? ?       ?              ?            ?  .bash_history
> -?????????? ? ?       ?              ?            ?  .bash_history
> -?????????? ? ?       ?              ?            ?  .bash_history
> -?????????? ? ?       ?              ?            ?  .bash_history
> -?????????? ? ?       ?              ?            ?  .bash_history
> -?????????? ? ?       ?              ?            ?  .bash_history
> -rw-r--r--. 1 nbecker nbecker       18 Oct  8  2014  .bash_logout
> [...]

   Could you show the result of btrfs check --readonly on this FS? The
rest, below, doesn't show up anything unusual to me.

   Hugo.

> uname -a
> Linux nbecker2 4.14.3-300.fc27.x86_64 #1 SMP Mon Dec 4 17:18:27 UTC
> 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
>  btrfs --version
> btrfs-progs v4.11.1
> 
> sudo btrfs fi show
> Label: 'fedora'  uuid: 93c586fa-6d86-4148-a528-e61e644db0c8
> Total devices 1 FS bytes used 80.96GiB
> devid    1 size 230.00GiB used 230.00GiB path /dev/sda3
> 
> sudo btrfs fi df /home
> Data, single: total=226.99GiB, used=78.89GiB
> System, single: total=4.00MiB, used=48.00KiB
> Metadata, single: total=3.01GiB, used=2.07GiB
> GlobalReserve, single: total=222.36MiB, used=0.00B
> 
> dmesg.log is here:
> https://nbecker.fedorapeople.org/dmesg.txt
> 
> mount | grep btrfs
> /dev/sda3 on / type btrfs
> (rw,relatime,seclabel,ssd,space_cache,subvolid=257,subvol=/root)
> /dev/sda3 on /home type btrfs
> (rw,relatime,seclabel,ssd,space_cache,subvolid=318,subvol=/home)
> 

-- 
Hugo Mills             | Hey, Virtual Memory! Now I can have a *really big*
hugo@... carfax.org.uk | ramdisk!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaL+0RAAoJEFheFHXiqx3kkioQALUSmcZKRNhQmSgDnhBVVAqp
GWhmud/HN+IKRBagK3aF9LzdaZqfvfbtK0qd1RqKPRGTuNypFTLen5PERbL7NgO9
VqiWrScTVN19Lx7dnQR8GpJEZNJ/dziJWyIE615c4j79TYFGyHIJfJ7hurxWyOnw
0td/IND9tA0Y0O9J2Ogyp5B2hhTZmTB5XR9N/PC5tNfAeGPHOixny6LufNkwOnky
/JCrfm0QPlcqnGqNiz4o1nCgV2Xcx7GJhgtcCeQq6Btl5XIekbbigbORlEMl8XaQ
BvOAaqs98k9e0f6KIFAd9Uy2uWZkOc2ju+gVeNnWKLnLcNdQsbyGrpr7PkMMVir6
T89vNodcF6/LogRxRSnzOjFbOZQNqX/iH8jQP37ueYVeG0bDBL1ngVx6qN9vapB4
nEcb5Ml5moBZGmR3Euh1iYlbhszrvxRjbq5UPjgBYIHJEd+m/sB050vbKQfhktpP
oeNCTe5pHrzSGtR9lluLEhPpexbDjSPOK+f1hRFIc+BLb3jv2ClCBJ6cmrNpvxW3
Ujpw4WjDaqzQbUnfBs/AaEyeHdVPKLlGMn5Quuqr6IaZnG5OlRCo5F4OtIPzvvan
VgGN8lexJjetcV8iElnEOEGD6gspADY3w1XFEYFoIWKd54D616EPzxCCgI6lq4c3
hAW8f1Oz9pbaXjo8jZvX
=tY4o
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
