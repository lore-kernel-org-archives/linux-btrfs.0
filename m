Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:37327 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751832AbeCQBet (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 21:34:49 -0400
Date: Sat, 17 Mar 2018 01:34:38 +0000
From: higuita <higuita@GMX.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs errors
Message-ID: <20180317013438.73e5bc35@couracado.motaleite.net>
In-Reply-To: <CAJCQCtQg5_V0POgNbQs894Bq6JExpdb5b38F_T000kFanMQxag@mail.gmail.com>
References: <20180314020313.2f444787@couracado.motaleite.net>
        <CAJCQCtQg5_V0POgNbQs894Bq6JExpdb5b38F_T000kFanMQxag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/OVbNcXWRF+gJM8YqXhY0uYE"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/OVbNcXWRF+gJM8YqXhY0uYE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Thanks for the reply!

On Tue, 13 Mar 2018 22:24:43 -0600, Chris Murphy
<lists@colorremedies.com> wrote:
> If you search the list for 'corrupt leaf bad key ordering' the top two
> causes are bad RAM and flaky power supply. These can be hard to narrow
> down.

	I will try to get new power supply to test as the current one have
about almost 10 years, so probably it this one the source of the problem.

> a. Make sure backups are up to date. Hopefully you can mount the
> volume read only

yes, i have updated backups and i can mount the filesystem without any
problem. I can always reformat the partition and restore, but i would
like to use this to learn how to repair btrfs partitions and help=20
improving the btrfs if possible.

> b. Make sure you're using a recent btrfs-progs=20

	Check! i'm using btrfs-progs v4.15.1,

> c. (optional) take a btrfs image before you do the repair because if
> something blows up, at least that will help a dev figure out why btrfs
> check blew up your file system.

	done! i was expecting a image with at least my used space ( ~40GB),=20
but i got a 1GB file. Is that normal?


> But yes pretty good chance it can be fixed with 'btrfs check
> --repair'=20

	After booting with a livecd and running a --repair with
btrfs-progs v4.15.1, it didn't look it have done almost anything to the
errors, running a new check still show mostly the same errors:

# btrfs check --force /dev/vdisk/root=20
WARNING: filesystem mounted, continuing because of --force
Checking filesystem on /dev/vdisk/root
UUID: c6cbf25f-f020-4247-822d-d9a85ec3c09f
checking extents
parent transid verify failed on 4505600 wanted 12266 found 13304
parent transid verify failed on 4505600 wanted 12266 found 13304
Ignoring transid failure
leaf parent key incorrect 4505600
bad block 4505600
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
parent transid verify failed on 4505600 wanted 12266 found 13304
Ignoring transid failure
leaf parent key incorrect 4505600
parent transid verify failed on 4505600 wanted 12266 found 13304
Ignoring transid failure
leaf parent key incorrect 4505600
parent transid verify failed on 4505600 wanted 12266 found 13304
Ignoring transid failure
leaf parent key incorrect 4505600
parent transid verify failed on 4505600 wanted 12266 found 13304
Ignoring transid failure
leaf parent key incorrect 4505600
parent transid verify failed on 4505600 wanted 12266 found 13304
Ignoring transid failure
leaf parent key incorrect 4505600
parent transid verify failed on 4505600 wanted 12266 found 13304
Ignoring transid failure
leaf parent key incorrect 4505600
parent transid verify failed on 4505600 wanted 12266 found 13304
Ignoring transid failure
leaf parent key incorrect 4505600
parent transid verify failed on 4505600 wanted 12266 found 13304
Ignoring transid failure
leaf parent key incorrect 4505600
parent transid verify failed on 4505600 wanted 12266 found 13304
Ignoring transid failure
leaf parent key incorrect 4505600
parent transid verify failed on 4505600 wanted 12266 found 13304
Ignoring transid failure
leaf parent key incorrect 4505600
checking csums
parent transid verify failed on 4505600 wanted 12266 found 13304
Ignoring transid failure
checking root refs
ERROR: transid errors in file system
found 46024671232 bytes used, error(s) found
total csum bytes: 0
total tree bytes: 1035763712
total fs tree bytes: 980156416
total extent tree bytes: 55296000
btree space waste bytes: 194602932
file data blocks allocated: 44942737408
 referenced 59370504192

=20
So looks like btrfs check --repair do not really know how to fix this

Thanks for the help
higuita
--=20
Naturally the common people don't want war... but after all it is the
leaders of a country who determine the policy, and it is always a=20
simple matter to drag the people along, whether it is a democracy, or
a fascist dictatorship, or a parliament, or a communist dictatorship.
Voice or no voice, the people can always be brought to the bidding of
the leaders. That is easy. All you have to do is tell them they are=20
being attacked, and denounce the pacifists for lack of patriotism and
exposing the country to danger.  It works the same in every country.
           -- Hermann Goering, Nazi and war criminal, 1883-1946

--Sig_/OVbNcXWRF+gJM8YqXhY0uYE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQzYESp8QLV9Wpl3Vuu/WNrOwxyswUCWqxwrgAKCRCu/WNrOwxy
s85vAJ9eDACrVHyDfIsTlGoTemkBiik46wCeK+bwk/Xi2DTQwC4KQYHz7T2L4yY=
=DmVY
-----END PGP SIGNATURE-----

--Sig_/OVbNcXWRF+gJM8YqXhY0uYE--
