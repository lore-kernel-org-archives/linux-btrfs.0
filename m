Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41671 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754283AbcIBOsZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 10:48:25 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
 <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
 <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
 <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
 <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
 <1472827395.3713.6.camel@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com>
Date: Fri, 2 Sep 2016 10:48:17 -0400
MIME-Version: 1.0
In-Reply-To: <1472827395.3713.6.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="CatmxvNjmomLgOncLgvnnjWn0I8mUToqR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CatmxvNjmomLgOncLgvnnjWn0I8mUToqR
Content-Type: multipart/mixed; boundary="NAssB08FWcId3vs93wVwOI9qI4ndv04Vq";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
 Chris Murphy <lists@colorremedies.com>,
 "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
 Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
References: <1471023419.16857.9.camel@gmail.com>
 <1472485953.3290.0.camel@gmail.com> <57C4EB85.7030000@cn.fujitsu.com>
 <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
 <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
 <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
 <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
 <1472827395.3713.6.camel@gmail.com>
In-Reply-To: <1472827395.3713.6.camel@gmail.com>

--NAssB08FWcId3vs93wVwOI9qI4ndv04Vq
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/2/16 10:43 AM, Ronan Arraes Jardim Chagas wrote:
> Hi Jeff,
>=20
> Em Sex, 2016-09-02 =C3=A0s 10:26 -0400, Jeff Mahoney escreveu:
>> I explained what I think Ronan's issue is in another part of the
>> thread
>> just now.  I don't think that's a severe issue at
>> all.  Annoying?  Sure,
>> but I'm more concerned with the underlying ENOSPC issue.  Without
>> more
>> info, I don't know what the cause of it is and when it was
>> introduced.
>=20
> Sorry, but I really need to humbly disagree with you. Look to what has
> already happened to me when the problem occurred (which is almost every=

> day):
>=20
> 1) Firefox crash;
> 2) Libreoffice crash (auto-save stop working);
> 3) Can't save my work in any text editor (vim, neovim, gedit, etc.);
> 4) Sometimes I can't even log as root (in TTY or by `su`);
> 5) Sometimes only a hard-reset solves the problem;
> 6) I was left with a broken operational system when the problem
> occurred during a `zypper dup`.
>=20
> I just can't tell you how much work I lost during those situations. So,=

> I think we cannot call this issue just annoying. I think it is very
> severe.

Sorry, I miscommunicated there.  The WARN_ON is annoying.  It's the
underlying issue that's causing you to lose work that is the one that
concerns me.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--NAssB08FWcId3vs93wVwOI9qI4ndv04Vq--

--CatmxvNjmomLgOncLgvnnjWn0I8mUToqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXyZExAAoJEB57S2MheeWy0PMQALJkBYM6+LSUTQaABqs0o2mt
F2k0slJdq1y63z2BX0Cyg2qhzt65WUKz9yYLgSae4KACfCs1LBXGkrk75ABn2hNs
qX33FpxDqGb9uDhvNhm9dwRnQqEgtGLzAGQmP409C9aOXj5HJUXBWag5wZpR4pPq
eGBYf4Bqs3Ww9ixobug3AmNJJDtTwsg+O6jTsSDuXycqOb7wnx8VK9qIEEv8Sdm+
aZl6TDLCRMTz0u+1dh1fvj8xrsY6061ll0oKOr94DVqbvahgdTNSsbCeK2Fa5cHy
GGA80dkEZLGgFIOVMryehMlmOzj4dUI8xSCx8rDpzRgg+u5rxtWAzKJZXUfPuhsH
k/5duuu2bjjXNgAUnY2vpTiymqiNgQgWoE4ItX6TBbijnX8Nen8HDboMgNrqoWpi
MOVG71jtee5yuerfXLcj5Ac6G7ZluyIbMsCBsclDimGUQu5sBaBSdX8XtraQsb3i
2IrloCn2l7gPuIEayqy9bFmVl/2RhMrRk60FVKjyGmXLyfLWg3hZFHIdCNW3nERw
I7akvDM3Qr7BU7rSfK/v8lTUpQxi9QeOcK+ZoQoDM7BKwC9tdlblh33Vi6c0Vmku
Dvg9hFNbvIYNrBEVbE4JjaCVZPMSlTIZNddRnCxOgESkiZAHQa0SY5WtrJV0vLBo
ElsZj/FSMGCCFA+2ONPo
=AGqM
-----END PGP SIGNATURE-----

--CatmxvNjmomLgOncLgvnnjWn0I8mUToqR--
