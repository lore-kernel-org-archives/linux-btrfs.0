From: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Subject: Re: Snapshot reconciliation
Date: Fri, 1 Jul 2011 15:52:24 +0100
Message-ID: <F02368DC-096F-49B5-A577-2955DE12D6EB@gmail.com>
References: <9577A2A8-5786-4491-A676-2CBD10DBAC1B@gmail.com> <BANLkTikgueaxBXMhK1T4dKwMhLTsGn8Mag@mail.gmail.com> <C1956DA1-A928-40BC-B01F-5798E4C55E96@gmail.com> <20110628190632.GB24675@carfax.org.uk>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-3-512262500"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110628190632.GB24675@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-3-512262500
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=iso-8859-1


On Jun 28, 2011, at 8:06 PM, Hugo Mills wrote:

> On Tue, Jun 28, 2011 at 06:55:41PM +0100, Jo=E3o Eduardo Lu=EDs wrote:
>> On Jun 28, 2011, at 4:07 PM, C Anthony Risinger wrote:
>>=20
>>> 2011/6/28 Jo=E3o Eduardo Lu=EDs <jecluis@gmail.com>:
>>>> Hello.
>>>>=20
>>>> Can anyone think of a simple way to copy a set of pages from a =
given file (which may or may not be scattered throughout multiple =
extents) from a snapshot to correct pages within another file on another =
snapshot?
>>>>=20
>>>> This might sound silly, but the whole purpose is to create some =
sort of reconciliation method between divergent snapshots taken from the =
same original subvolume.
>>>=20
>>> generic deduplication?
>>>=20
>>=20
>> I'm not sure if deduplication is what I'm looking for.
>>=20
>> What I actually want to achieve is to reconstruct a file's data from
>> two diverging files. I.e., two snapshots are taken from the same
>> subvolume and, in each snapshot, a given file A is written
>> to. Assuming different blocks were written on, and no expected
>> semantics are violated, what I aim to achieve is the correct
>> reconciliation of file A in one of the snapshots.
>>=20
>> Maybe this could be achieved by using deduplication. I'll look into
>> those patches. Even if they are not completely useful, they very
>> well contain some neat concept that may be used to solve this little
>> puzzle of mine. :-)
>=20
>   You would need to enumerate the extents on each representation of
> the file, picking the ones with the latest transid in each case. You
> would then need to work out what the extents on the reconstructed file
> would look like, and glue them all together into a new file.
>=20

In my case, I don't need to search the latest transid, since I keep an =
in-memory log of changes made within each snapshot. As these snapshots =
are ephemeral and created/destroyed on-demand by a user-level =
application, the associated cost of keeping such per-snapshot log =
doesn't seem to cause much impact on the performance.

However, I log operations performed on a per-page basis. Glueing =
modified extents on each snapshot doesn't seem viable without =
deduplicating them first, or I may end up losing updates I did not =
intended to lose.

On the other hand, I'm afraid the deduplication will lead to severe disk =
fragmentation when performed on a page-basis (e.g., if changes are made =
on several non-contiguous pages within several extents, in the same file =
on different snapshots, I would end up with several smaller extents =
scattered throughout disk).

This is pretty much why I expected to be able to, literally, copy the =
changed pages from one snapshot to another, without deduplicating the =
extents. However, after spending the last couple of days looking for a =
simple way to do it, I now believe achieving this is far more =
complicated and prone to error (unless I missed something) than =
deduplicating the extents based on my logged information.


Any thoughts would be helpful.

---
Jo=E3o Eduardo Lu=EDs
gpg key: 477C26E5 from pool.keyserver.eu=20






--Apple-Mail-3-512262500
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.16 (Darwin)

iQEcBAEBAgAGBQJODd8tAAoJEJ9vvxhHfCblveQH/3U6jDV36OqYQYN3ZmfaaTqn
BA6E6WqsOOaKM8Cx9f4UEljck7S+O82Pr/iKok1c3GWQXmLMbMImw6l+xz0lYRg4
22r+5Es8GfaaFPbtAocA1xAi/9UcjbodpA/7Nt4cDww7H+ItmL+eVUWIcxc+l0OK
4zogd/WOLISC6jLbsGH0P55XNEBJfE+jbseUGHOfjDVgTgFvQs2CN/VZDKtK9Ovo
jvhyM2st5yVGjP7+KqiBMIEZqzE1Maz3K0GMYsqLzLIxNTAcYyxKl8/s/h4Doe10
o/OAM9ik8NFe9MAfTQKu/s6jI0DQjDFGARVwjBswxoIXvOs41v8HA9D0cvmghKI=
=CMh9
-----END PGP SIGNATURE-----

--Apple-Mail-3-512262500--
