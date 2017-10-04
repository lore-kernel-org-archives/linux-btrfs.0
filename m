Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48904 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdJDWTt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Oct 2017 18:19:49 -0400
Date: Wed, 4 Oct 2017 22:19:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Stephen Nesbitt <nesbittmeister@gmail.com>
Cc: Stephen Nesbitt <snesbitt@aussieswithtails.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Seeking Help on Corruption Issues
Message-ID: <20171004221947.GG3293@carfax.org.uk>
References: <c67167b4-190b-dfdc-33a8-8cb75a4744ef@gmail.com>
 <20171003201047.GE3293@carfax.org.uk>
 <CAPXGFsE4HzGWhjKtp=E-4LN_-vQnFtqJDDhTva9Wkg9Gtm9D_w@mail.gmail.com>
 <20171003211121.GF3293@carfax.org.uk>
 <e531fc75-8080-eb82-86bb-2f787bf0ea43@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yQbNiKLmgenwUfTN"
In-Reply-To: <e531fc75-8080-eb82-86bb-2f787bf0ea43@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yQbNiKLmgenwUfTN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 03, 2017 at 03:49:25PM -0700, Stephen Nesbitt wrote:
> 
> On 10/3/2017 2:11 PM, Hugo Mills wrote:
> >    Hi, Stephen,
> >
> >On Tue, Oct 03, 2017 at 08:52:04PM +0000, Stephen Nesbitt wrote:
> >>Here it i. There are a couple of out-of-order entries beginning at 117. And
> >>yes I did uncover a bad stick of RAM:
> >>
> >>btrfs-progs v4.9.1
> >>leaf 2589782867968 items 134 free space 6753 generation 3351574 owner 2
> >>fs uuid 24b768c3-2141-44bf-ae93-1c3833c8c8e3
> >>chunk uuid 19ce12f0-d271-46b8-a691-e0d26c1790c6
> >[snip]
> >>item 116 key (1623012749312 EXTENT_ITEM 45056) itemoff 10908 itemsize 53
> >>extent refs 1 gen 3346444 flags DATA
> >>extent data backref root 271 objectid 24999978 offset 0 count 1
> >>item 117 key (1621939052544 EXTENT_ITEM 8192) itemoff 10855 itemsize 53
> >>extent refs 1 gen 3346495 flags DATA
> >>extent data backref root 271 objectid 21751764 offset 6733824 count 1
> >>item 118 key (1623012450304 EXTENT_ITEM 8192) itemoff 10802 itemsize 53
> >>extent refs 1 gen 3351513 flags DATA
> >>extent data backref root 271 objectid 5724364 offset 680640512 count 1
> >>item 119 key (1623012802560 EXTENT_ITEM 12288) itemoff 10749 itemsize 53
> >>extent refs 1 gen 3346376 flags DATA
> >>extent data backref root 271 objectid 21751764 offset 6701056 count 1
> >>>>hex(1623012749312)
> >'0x179e3193000'
> >>>>hex(1621939052544)
> >'0x179a319e000'
> >>>>hex(1623012450304)
> >'0x179e314a000'
> >>>>hex(1623012802560)
> >'0x179e31a0000'
> >
> >    That's "e" -> "a" in the fourth hex digit, which is a single-bit
> >flip, and should be fixable by btrfs check (I think). However, even
> >fixing that, it's not ordered, because 118 is then before 117, which
> >could be another bitflip ("9" -> "4" in the 7th digit), but two bad
> >bits that close to each other seems unlikely to me.
> >
> >    Hugo.
> 
> Hope this is a duplicate reply - I might have fat fingered something.
> 
> The underlying file is disposable/replaceable. Any way to zero
> out/zap the bad BTRFS entry?

   Not really. Even trying to delete the related file(s), it's going
to fall over when reading the metadata in in the first place. (The key
order check is a metadata invariant, like the csum checks and transid
checks).

   At best, you'd have to get btrfs check to fix it. It should be able
to manage a single-bit error, but you've got two single-bit errors in
close proximity, and I'm not sure it'll be able to deal with it. Might
be worth trying it. The FS _might_ blow up as a result of an attempted
fix, but you say it's replacable, so that's kind of OK. The worst I'd
_expect_ to happen with btrfs check --repair is that it just won't be
able to deal with it and you're left where you started.

   Go for it.

   Hugo.

-- 
Hugo Mills             | You shouldn't anthropomorphise computers. They
hugo@... carfax.org.uk | really don't like that.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--yQbNiKLmgenwUfTN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZ1V6DAAoJEFheFHXiqx3kTn4P/R9kXt0Gjiq5bJ5nGthz2dvh
ioDcQeVNd7lgZHLgk2a1ux0VgYKBIJLDRNFZwTiZxT3Ma+d2TYrrleK4ZksebxWu
mkdSJE0IiP/XEIRXw75Lu4YNWA3XB38Trd9qgPLp5vaH/vEqGVvP0/V8sXVagUor
iGoorL+rg6jAlIP+ry5Ulf/YYv32fvbD5BPBdG8HKMZBE/1YaLX32G+zmpFYPTGd
tdcoBpiUrtQzmvaJ8f3oHu+Sa2w2etyAJ0pR3H/I9XeEo1LE0k1FuAUbZRtodO4C
uiXvubjgeLMkuuXe1dAmZqZUggvIDV8Xv8cvufafZH1iEVKlx4OFNzCglQLwjxoA
5C6YlGDxrM63RVl3VhXmLBBE9NcFnAmQgGmKkFZ++vMeRJttHE0shQPEY5s9tb6X
4YEhHHsfF0Jnpq7lB9zm2x7wObbhr4BoNtgOAmTh735q5o42saBtlKxaD3mnUQyF
5diC0y5FOMCfzr7+FF7BJozOQID6n9EPFoPmSScFAO883pdHybooh8cAYjvYOLwQ
R9y6BrsqFwiVLEB+OpZYs5SG+/JWsKbSEaU+Bq2OjzN4vK1/nWY4yqbG/k1clYEO
uhXIrd1Y2CDehaPrp1ZekvlpvKshs+Tk4+pyZh3IfnBzPzn7DArvwK0QwDZpg+vh
OKyRdpw5iqvKW9Yc0sUR
=jvhH
-----END PGP SIGNATURE-----

--yQbNiKLmgenwUfTN--
