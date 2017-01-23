Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.somenet.org ([213.143.98.34]:37582 "EHLO mail.somenet.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750704AbdAWAZw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Jan 2017 19:25:52 -0500
Subject: Re: RAID56 status?
To: Hugo Mills <hugo@carfax.org.uk>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <d69f5a19-baa8-ff56-609e-4ee01be8a103@jvales.net>
 <1485124549.6187.36.camel@scientia.net>
 <20170122223906.GA24076@carfax.org.uk>
From: Jan Vales <jan@jvales.net>
Message-ID: <3e9fe326-7638-bc78-4fe8-f6f6851769d7@jvales.net>
Date: Mon, 23 Jan 2017 01:25:45 +0100
MIME-Version: 1.0
In-Reply-To: <20170122223906.GA24076@carfax.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="b9fJbGeagpsLVwx0LSgomNAkVfPV2G63d"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--b9fJbGeagpsLVwx0LSgomNAkVfPV2G63d
Content-Type: multipart/mixed; boundary="EMOWxRrbghOhslpSPnWuGm1daxrbLSrvj";
 protected-headers="v1"
From: Jan Vales <jan@jvales.net>
To: Hugo Mills <hugo@carfax.org.uk>,
 Christoph Anton Mitterer <calestyo@scientia.net>, linux-btrfs@vger.kernel.org
Message-ID: <3e9fe326-7638-bc78-4fe8-f6f6851769d7@jvales.net>
Subject: Re: RAID56 status?
References: <d69f5a19-baa8-ff56-609e-4ee01be8a103@jvales.net>
 <1485124549.6187.36.camel@scientia.net>
 <20170122223906.GA24076@carfax.org.uk>
In-Reply-To: <20170122223906.GA24076@carfax.org.uk>

--EMOWxRrbghOhslpSPnWuGm1daxrbLSrvj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/22/2017 11:39 PM, Hugo Mills wrote:
> On Sun, Jan 22, 2017 at 11:35:49PM +0100, Christoph Anton Mitterer wrot=
e:
>> On Sun, 2017-01-22 at 22:22 +0100, Jan Vales wrote:
>>> Therefore my question: whats the status of raid5/6 is in btrfs?
>>> Is it somehow "production"-ready by now?
>> AFAIK, what's on the - apparently already no longer updated -
>> https://btrfs.wiki.kernel.org/index.php/Status still applies, and
>> RAID56 is not yet usable for anything near production.
>=20
>    It's still all valid. Nothing's changed.
>=20
>    How would you like it to be updated? "Nope, still broken"?
>=20
>    Hugo.
>=20
>=20

As the changelog stops at 4.7 the wiki seemed a little dead - "still
broken as of $(date)" or something like that would be nice ^.^

Also some more exact documentation/definition of btrfs' raid-levels
would be cool, as they seem to mismatch traditional raid-levels - or at
least I as an ignorant user fail to understand them...

Correct me, if im wrong...
* It seems, raid1(btrfs) is actually raid10, as there are no more than 2
copies of data, regardless of the count of devices.
** Is there a way to duplicate data n-times?
** If there are only 3 devices and the wrong device dies... is it dead?
* Whats the diffrence of raid1(btrfs) and raid10(btrfs)?
** After reading like 5 diffrent wiki pages, I understood, that there
are diffrences ... but not what they are and how they affect me :/
* Whats the diffrence of raid0(btrfs) and "normal" multi-device
operation which seems like a traditional raid0 to me?

Maybe rename/alias raid-levels that do not match traditional
raid-levels, so one cannot expect some behavior that is not there.
The extreme example is imho raid1(btrfs) vs raid1.
I would expect that if i have 5 btrfs-raid1-devices, 4 may die and btrfs
should be able to fully recover, which, if i understand correctly, by
far does not hold.
If you named that raid-level say "george" ... I would need to consult
the docs and I obviously would not expect any behavior. :)

regards,
Jan Vales
--
I only read plaintext emails.


--EMOWxRrbghOhslpSPnWuGm1daxrbLSrvj--

--b9fJbGeagpsLVwx0LSgomNAkVfPV2G63d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJYhU2MAAoJEERD22thjA7q1O0P/0VNQtk4EAaCVA2fOpPXASm2
ScW663Kg8ghXp8Sqnz8PsWZJahY/OnLqLCrD5NNCKLpbgYqu2fGEFHnJzKsWHO84
1YkygqrGjdSPZuygzj06o7EOLHhMBDoGfdGHvSOhcL8JrpP/ia9S8okyi5+BQeH/
PGTJ87yN4bg5jjSbhVamBAcTLWLRONyQZC+fnNXcd6kSrdlzylEBFT36YqVsdQhU
q0NghnyojTVhAaHlPuNuUDu+ZDetLKox3a2a1EmTOc9qDtMVsCCXtrU14o36cMjh
l234Y7harMyKx6UtPGYpudXb+3ep+xVyBlusGmwL+5VbBZz/5yzAibVKxKOOIsSQ
GBcjz3+Sxs2lVF3LRokY+UQAplzaPakUyo1D8JwynDoCAY0QzyWIyoSeuyfJN7do
QqlV7lNqFMDRl6Aes3w5Kf/xne39Q6NDeDH/FgWekYMZZkOmlqbOlcPdo6FoqCYb
Go1bx2VQZ86F0L05HYjmiKh9VVqt38DwD4enqGQDBUkHOE1RDJX4hsR15FJsoUWv
FpZ/SoID83F8dXge0Hl9QsPzExAXkyb1Zn9/fe6XBoc7rdB02wfchdVIsJTreJnp
gfvVCZPj7KMhvLIUPSPOUwPw1tZlbNukq4ZK8TYfQOWsk5e70+x2LXioz5XfiFtg
PbkhfFZ82pPNslP/gYZ9
=dXoY
-----END PGP SIGNATURE-----

--b9fJbGeagpsLVwx0LSgomNAkVfPV2G63d--
