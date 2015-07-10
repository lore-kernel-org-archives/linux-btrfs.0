Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:48501 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932290AbbGJTM7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 15:12:59 -0400
Received: from smtp26.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp26.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id BAF443802E5
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2015 15:12:58 -0400 (EDT)
Received: from smtp26.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp26.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id B419E3802DA
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2015 15:12:58 -0400 (EDT)
Received: by smtp26.relay.ord1c.emailsrvr.com (Authenticated sender: vincent-AT-up4.tv) with ESMTPSA id 16642380319
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2015 15:12:54 -0400 (EDT)
Content-Type: multipart/signed; boundary="Apple-Mail=_1C196C36-2EE4-4DC7-822B-77ED75449EEB"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Subject: Re: Send/Receive Use Case
From: Vincent Olivier <vincent@up4.com>
In-Reply-To: <20150710191109.GK10539@carfax.org.uk>
Date: Fri, 10 Jul 2015 15:12:45 -0400
Message-Id: <90AC7FF8-FF97-4E5B-AF4D-07BDBBA73746@up4.com>
References: <F2771637-3D78-4332-AB96-993069114030@up4.com> <20150627142132.GI16065@carfax.org.uk> <E737B6C9-CC16-490A-B14C-E2D364BA2805@up4.com> <5A05A6DE-A405-4C88-9F7D-C7510048E067@up4.com> <20150710191109.GK10539@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_1C196C36-2EE4-4DC7-822B-77ED75449EEB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

this is GOOD news . thanks !

> On Jul 10, 2015, at 3:11 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>=20
> On Fri, Jul 10, 2015 at 03:03:27PM -0400, Vincent Olivier wrote:
>> actually I have another question : is it posssible for a RAID0 fs to =
=E2=80=9Creceive=E2=80=9D from a =E2=80=9Csending=E2=80=9D RAID10 ?
>=20
>   Yes, definitely. I do my backups from RAID-1 to single. The send
> stream format is based on files, not on the underlying raw storage.
>=20
>   Hugo.
>=20
>> or do they need to be of the same replication scheme too ?
>>=20
>>=20
>>=20
>>> On Jun 27, 2015, at 10:34 AM, Vincent Olivier <vincent@up4.com> =
wrote:
>>>=20
>>> ok i=E2=80=99ll go home and rethink my life then ;)
>>>=20
>>>> On Jun 27, 2015, at 10:21 AM, Hugo Mills <hugo@carfax.org.uk> =
wrote:
>>>>=20
>>>> On Sat, Jun 27, 2015 at 10:04:28AM -0400, Vincent Olivier wrote:
>>>>> Hi,
>>>>>=20
>>>>> There are 4 things I=E2=80=99m not sure about re:send/receive.
>>>>>=20
>>>>> 1) Is it possible to first copy things on a file system using =
rsync and then use send-receive ? And to subsequently mix rsync and =
send-receive ? Provided that snapshots are made accordingly.
>>>>=20
>>>> Probably. It depends on exctly how you want to use them.
>>>>=20
>>>>> 2) Is possible to =E2=80=9Csend" a snapshot diff to disk and then =
=E2=80=9Creceive" it from the said disk into a remote filesystem ? I =
have two very large and physically distant btrfs filesystems. It would =
be more economical to juste dump snapshot diffs to disk for transport =
instead of the network.
>>>>=20
>>>> Yes, that's perfectly possible.
>>>>=20
>>>>> 3) How are =E2=80=9Cconflicts=E2=80=9D handled by send-receive if =
at all ?
>>>>=20
>>>> There are no conflicts possible, due to the requirement of all the
>>>> subvolumes involved in the send/receive process being read-only.
>>>> (Actually, that's not quite true -- you can make a subvolume
>>>> read/write, and then read-only again. In that case, the receive =
will
>>>> probably fail, leaving the received subvolume in a =
partially-created
>>>> state).
>>>>=20
>>>>> 4) If a file is created, modified and then deleted in-between two
>>>>> snapshots is it ignored by send/receive or does send/receive
>>>>> "re-enacts=E2=80=9D the journal exactly ?
>>>>=20
>>>> It'll be ignored. The FS doesn't keep track of how it reached a
>>>> particular state -- only what that state is.
>>>>=20
>>>> Hugo.
>>>>=20
>=20
> --
> Hugo Mills             | UNIX: Japanese brand of food containers
> hugo@... carfax.org.uk |
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |


--Apple-Mail=_1C196C36-2EE4-4DC7-822B-77ED75449EEB
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJVoBktAAoJEOggPckf4s14u30P/jvRh10IxmS0uDrTxOpi1oEQ
LLwjzx+Ry39j6z5OJEx84gD4pQHwhmsb7suq77Y/eANfT+3B7ZyP95pDlvTMBPXW
wXTWD598w22b3eGiOEMg+t9FwDQN352Nhq26orYwSreQXkW+gJ4epbWB/D6s/C/s
piZFwaBbbxByfYdatc1cd9JbFmGtqT1ajnPBFp140M5QIqiakYDv34aXkGtQbMBX
bYG/Nl7YulOMzumI+rr7JNKRE2DKay/SkGjY89WwRu8psU3vfwUWhnYH5V+Qxdd6
SeB5EKb1OPKNBBmqTuwvPYYQ7CG2oHAgzPmV/o/2llYwT3rt+azB7P01/6/JYUrF
8U5hamAU7qau1sGyXd9KQU2fVP+EWkj0mBmc8Ss4w88SC5lIMqv8mSqJ3ogbMHk+
r0cc4lWujXA0v8coS8ql0jxI7G14xPnf3Cby0HTPTuhZMDTbU68OXcGsdTUOIKE5
kaLU5xkUIqmE6mdWKhJ2mWn3dwnLHwXl5X6m44EB1SfU75xiTr0RdveLrtV8GECF
PjrSIVy20KZYmYUNtzXbz96v4JzlAj4JAAtV6oOfV30Is6Y5BKZ1bviJU18wRwS0
7TFxARY/MlKmNWDzHNJDaoWQ/16NE50emN417UljcLqvgkJ26c5f6xORC2XdOdeB
gGMv694fkV9zNE1FxHVw
=d5M6
-----END PGP SIGNATURE-----

--Apple-Mail=_1C196C36-2EE4-4DC7-822B-77ED75449EEB--
