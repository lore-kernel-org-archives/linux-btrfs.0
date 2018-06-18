Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:34971 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753962AbeFRNGI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 09:06:08 -0400
Subject: Re: About more loose parameter sequence requirement
To: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
 <20180618120200.GK24375@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <48a89b08-3859-e635-1da2-ce7c9e842d8a@gmx.com>
Date: Mon, 18 Jun 2018 21:05:59 +0800
MIME-Version: 1.0
In-Reply-To: <20180618120200.GK24375@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9EHGN8Y2odSd0UASN4z8ZZ8ov4KCpY9MQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9EHGN8Y2odSd0UASN4z8ZZ8ov4KCpY9MQ
Content-Type: multipart/mixed; boundary="QgvLTPVeR8VE25w2b1pTGetoOfPhIJrpV";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, "linux-btrfs@vger.kernel.org"
 <linux-btrfs@vger.kernel.org>
Message-ID: <48a89b08-3859-e635-1da2-ce7c9e842d8a@gmx.com>
Subject: Re: About more loose parameter sequence requirement
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
 <20180618120200.GK24375@twin.jikos.cz>
In-Reply-To: <20180618120200.GK24375@twin.jikos.cz>

--QgvLTPVeR8VE25w2b1pTGetoOfPhIJrpV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8818=E6=97=A5 20:02, David Sterba wrote:
> On Mon, Jun 18, 2018 at 07:40:44PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B406=E6=9C=8818=E6=97=A5 19:34, David Sterba wrote:
>>> On Thu, Jun 14, 2018 at 03:17:45PM +0800, Qu Wenruo wrote:
>>>> I understand that btrfs-progs introduced restrict parameter/option o=
rder
>>>> to distinguish global and sub-command parameter/option.
>>>>
>>>> However it's really annoying if one just want to append some new opt=
ions
>>>> to previous command:
>>>>
>>>> E.g.
>>>> # btrfs check /dev/data/btrfs
>>>> # !! --check-data-csum
>>>>
>>>> The last command will fail as current btrfs-progs doesn't allow any
>>>> option after parameter.
>>>>
>>>>
>>>> Despite the requirement to distinguish global and subcommand
>>>> option/parameter, is there any other requirement for such restrict
>>>> option-first-parameter-last policy?
>>>
>>> I'd say that it's a common and recommended pattern. Getopt is able to=

>>> reorder the parameters so mixed options and non-options are accepted,=

>>> unless POSIXLY_CORRECT (see man getopt(3)) is not set. With the more
>>> strict requirement, 'btrfs' option parser works the same regardless o=
f
>>> that.
>>
>> But currently it doesn't work.
>> Just as the example, btrfs check /dev/data/btrfs --check-data-sum won'=
t
>> work.
>> It's different from a lot of other common programs.
>=20
> With POSIXLY_CORRECT set, it expectedly won't work. With POSIXLY_CORREC=
T
> unset, it would work in general, but not for 'btrfs'.
>=20
> As this is per-application decision I find it ok, besides that I also
> find the 'options anywhere' pattern bad. Does it really save you that
> much time while typing the commands with new arguments?

Personally speaking, yes.

> There are
> movement shortcuts to jump by words, you get the previous command by
> up-arrow. About the same number of keystrokes.

Not really, normally just "!! <new options>", where I don't even need to
move my fingers to arrow keys.
(I'm all ears about extra bash shortcuts on this)

>=20
> New code needs to be tested, documented and maintained, that's the cost=

> I find too high for something that's convenience for people who are use=
d
> to some shell builtins.

The biggest problem is, the behavior isn't even consistent across
btrfs-progs.
mkfs.btrfs accept such out-of-order parameters while btrfs not.

And most common tools, like commands provided by coretutil, they don't
care about the order.
The only daily exception is 'scp', which I found it pretty unhandy.

And just as Paul and Hugo, I think there are quite some users preferring
out-of-order parameter/options.


I also understand the maintenance burden, but at least let's try if
there are better solution for this.

Thanks,
Qu


--QgvLTPVeR8VE25w2b1pTGetoOfPhIJrpV--

--9EHGN8Y2odSd0UASN4z8ZZ8ov4KCpY9MQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsnrjcACgkQwj2R86El
/qgm5ggAh04Wzrp37EuBvnp5tqHr+WO7dIa3urF87ABzlcJiZC012DNCd217zPDy
l2J5u4mcBVQpYTWTQ6Wzw2bBLFxy1gGL+InsL0gwe5s3To9dAX7TZ8hJdgm1SWal
cNjjezNfae4iCuTlqH+JH1HZRcCNKZ3mfeO0zb0u/svlv/UXWg4+sqk1B6CDmX/T
amO2HocBx2c5Qxn3Yj8TvL8edAOz2w/6lz6dR9z6jhq2Ni35HkhAReKZIdV0F6WK
olHt7wOnCpn4SdeWG2+RHB5ssO4sLiiHe8bEr+EIvpg2lxFMV5Rj8ny9i240/DaR
DiarjMFMoq1BhOtBNR9Tnk+POz7A4Q==
=dHdD
-----END PGP SIGNATURE-----

--9EHGN8Y2odSd0UASN4z8ZZ8ov4KCpY9MQ--
