Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40944 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbcH3KfE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 06:35:04 -0400
Date: Tue, 30 Aug 2016 10:35:00 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: ojab // <ojab@ojab.ru>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: `btrfs dev del` fails with `No space left on device`
Message-ID: <20160830103500.GL20440@carfax.org.uk>
References: <CAKzrAgTcrjN_qLqzqQ_izpB_AvypaGV=TGNEeH=-18GmOVjAAg@mail.gmail.com>
 <CAJCQCtQhFHX2ba3gYUHw0XtbLousVz8s7ZxMnT1ThU46iOxNOA@mail.gmail.com>
 <CAKzrAgRQ6gkEgWZwG1emf0w5RURkj93L_A4--OK-PaPEf17XvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MFZs98Tklfu0WsCO"
In-Reply-To: <CAKzrAgRQ6gkEgWZwG1emf0w5RURkj93L_A4--OK-PaPEf17XvQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--MFZs98Tklfu0WsCO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 30, 2016 at 10:22:24AM +0000, ojab // wrote:
> On Mon, Aug 29, 2016 at 9:05 PM, Chris Murphy <lists@colorremedies.com> wrote:
> > On Mon, Aug 29, 2016 at 10:04 AM, ojab // <ojab@ojab.ru> wrote:
> > What do you get for 'btrfs fi us <mp>'
> 
> $ sudo btrfs fi us /mnt/xxx/
> Overall:
>     Device size:                  3.64TiB
>     Device allocated:             1.82TiB
>     Device unallocated:           1.82TiB
>     Device missing:                 0.00B
>     Used:                     1.81TiB
>     Free (estimated):             1.83TiB         (min: 943.55GiB)
>     Data ratio:                  1.00
>     Metadata ratio:                  2.00
>     Global reserve:             512.00MiB         (used: 0.00B)
> 
> Data,RAID0: Size:1.81TiB, Used:1.80TiB
>    /dev/sdb1        928.48GiB
>    /dev/sdc1        928.48GiB
> 
> Metadata,RAID1: Size:3.00GiB, Used:2.15GiB
>    /dev/sdb1          3.00GiB
>    /dev/sdc1          3.00GiB
> 
> System,RAID1: Size:32.00MiB, Used:176.00KiB
>    /dev/sdb1         32.00MiB
>    /dev/sdc1         32.00MiB
> 
> Unallocated:
>    /dev/sdb1          1.01MiB
>    /dev/sdc1          1.00MiB
>    /dev/sdd1          1.82TiB

   Basically, your FS is full. Note that replacing just one of the
devices in a RAID-0 array with a larger one is not going to help. What
you really need here is "single", not RAID-0. I would probably try
converting to single first (which should move quite a lot of it to the
new device anyway), and then the device delete:

 btrfs balance start -dconvert=single,soft /mountpoint
 btrfs dev delete /dev/sdc1 /mountpoint

   Hugo.

> > You can see what the state of block groups are with btrfs-debugfs
> > which is in kdave btrfs-progs git. Chances are you need a larger
> > value, -dusage=15 -musage=15 to free up space on devid 1 and 2. Then
> > maybe devid 3 can be removed.
> 
> btrfs-debugfs output:
> https://gist.github.com/ojab/a3c59983e8fb6679b8fdc0e88c0c9e60
> Before `delete` the was about 60Gb of free space, looks like it was
> filled during `delete` (I've seen similar behavior during `btrfs fi
> defrag`) and I should use `-dusage=69` and up.
> 
> I don't quite understand what exactly btrfs is trying to do: I assume
> that block groups should be relocated to the new/empty drive, but
> during the delete `btrfs fi us` shows
> Unallocated:
> /dev/sdc1         16.00EiB
> 
> so deleted partition is counted as maximum possible empty drive and
> blocks are relocated to it instead of new/empty drive? (kernel-4.7.2 &
> btrfs-progs-4.7.1 here)
> Is there any way to see where and why block groups are relocated
> during `delete`?
> 
> //wbr ojab

-- 
Hugo Mills             | Everything simple is false. Everything which is
hugo@... carfax.org.uk | complex is unusable
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--MFZs98Tklfu0WsCO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXxWFUAAoJEFheFHXiqx3kuiYP/03wWmB7R6R0MigrBCI8XWnj
LPhFkg+4Ipll0+2Ez7MAXf/2/ZRWiaXWa8S6M0gLeoVD4sKcWjp5zF5eLWULgbPn
Bgoiilj+OasieII7L/mVdxBJg74WiCRKGCinGa0jIC2wEr+5ib1GqXNLg1aJjYse
2g1cdrP/pQsQSPQsvfLT3gGNPwE4FrxF+PP+RQOe/xuxVMCiuId3v6rQ7s9VX9uB
HBqOaCpHzuzzlAHG16kenoEwKcVbwImmKcCRErGxGYeDejDyTyWb3j3ejtVN+Z3x
cGFtyrgG+IFiPm8KkGSvm3XJqnOX1LlmES7lZFPBFk4Ce4V49x0MxbrKo1IYrHzu
KJqdGJ7yFIkO8UqvgA3ucMwol0VBKErYDHCWQu9Q4vxQjRnBRRk65A/JTcK/XwhB
ZN7Pp5TWSqQ7XO1cpxMUxJG1yH4KugcuzF2U0uHWFPDP3u+jzv3WcpCyxMFrMwiO
zE0ul6DYn2rBUHEdpJzOVL18N6qqZg6fHlksT0vZjTQbbg6H5uvfOd6i/E05SObq
QH/RMYyYasLydJ7mnb4YA1LDzshov9gkJYtOetrWK/89iL/T3WcUUCSATzqGmwXk
A4oS3vRGowKOS0CRYG3Qt77Avgo+VpwaS9hMuGwUMGh8JlE4SZpxERhDmPSENqsH
2fL3SEoqxLqBo2u4OWzE
=6E2D
-----END PGP SIGNATURE-----

--MFZs98Tklfu0WsCO--
