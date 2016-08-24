Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37492 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754990AbcHXAyD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 20:54:03 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
References: <1471023419.16857.9.camel@gmail.com>
 <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
 <1471028417.16857.12.camel@gmail.com>
 <CAJCQCtTrEqR=UNpHp7ApbdBkwRRT6U5tiSHcs2y4N-P_G5u=Fw@mail.gmail.com>
 <CAJCQCtS51syrzxvpZXGzS=Ge=rW1iEfZDj6VrVmON39ww-Hmdg@mail.gmail.com>
 <CAKdnfRJeOXHmrumDkfxLTf-nU=KwZ0f7ybET-3o7kwwJDOZ2aw@mail.gmail.com>
 <CAJCQCtTrGTjOMaNNV7JKBybgbyn=_pYP=KvE1zc4AuPs=mo2=A@mail.gmail.com>
 <1471898393.23345.0.camel@gmail.com>
 <CAJCQCtS7A+eWhg+agC3PJQn0g9Bgchb6C6LPt=NH1OF97xuhaw@mail.gmail.com>
 <1471899855.14025.2.camel@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <57BCED09.9070709@suse.com>
Date: Tue, 23 Aug 2016 20:40:41 -0400
MIME-Version: 1.0
In-Reply-To: <1471899855.14025.2.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JSBWkthcGiLkjRFniRkUqJiNt6vdukPL2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JSBWkthcGiLkjRFniRkUqJiNt6vdukPL2
Content-Type: multipart/mixed; boundary="5dOq7W6IQVVFprh3C6BhNknx8o4ixFVRw"
From: Jeff Mahoney <jeffm@suse.com>
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
 Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <57BCED09.9070709@suse.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
References: <1471023419.16857.9.camel@gmail.com>
 <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
 <1471028417.16857.12.camel@gmail.com>
 <CAJCQCtTrEqR=UNpHp7ApbdBkwRRT6U5tiSHcs2y4N-P_G5u=Fw@mail.gmail.com>
 <CAJCQCtS51syrzxvpZXGzS=Ge=rW1iEfZDj6VrVmON39ww-Hmdg@mail.gmail.com>
 <CAKdnfRJeOXHmrumDkfxLTf-nU=KwZ0f7ybET-3o7kwwJDOZ2aw@mail.gmail.com>
 <CAJCQCtTrGTjOMaNNV7JKBybgbyn=_pYP=KvE1zc4AuPs=mo2=A@mail.gmail.com>
 <1471898393.23345.0.camel@gmail.com>
 <CAJCQCtS7A+eWhg+agC3PJQn0g9Bgchb6C6LPt=NH1OF97xuhaw@mail.gmail.com>
 <1471899855.14025.2.camel@gmail.com>
In-Reply-To: <1471899855.14025.2.camel@gmail.com>

--5dOq7W6IQVVFprh3C6BhNknx8o4ixFVRw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/22/16 5:04 PM, Ronan Arraes Jardim Chagas wrote:
> Em Seg, 2016-08-22 =C3=A0s 14:49 -0600, Chris Murphy escreveu:
>> This is really weird. I'm running 4.7.0 (Fedora) and I'm not
>> experiencing problems, let alone this. What is this kernel's
>> provenance? Is it a plain mainline 4.7.0 that you built? I'm not
>> really sure what to recommend except maybe going back to 4.5.7 or
>> 4.6.7 as it's a production machine. Heck even 4.4.19 is OK for me in
>> this regard.
>>
>=20
> Well, I'm using the default openSUSE kernel here. And I have been seen
> this errors for sometimes. When I reported it, I was using v4.6.1.
> Hence, I think the version of btrfs-progs is not the problem.

The openSUSE Tumbleweed kernel is effectively vanilla for btrfs.  The
4.6-based kernel had two btrfs patches, the crc32c implementation
publishing patch that landed in 4.7, and the super_operation callback
that lets us publish the per-root anon dev via stat().  The problem
you're encountering isn't due to our patches.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--5dOq7W6IQVVFprh3C6BhNknx8o4ixFVRw--

--JSBWkthcGiLkjRFniRkUqJiNt6vdukPL2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJXvO0NAAoJEB57S2MheeWy/9AP/R694/DhZiozTvkx8cVgSD7H
AgyxFHvDvdw+Q9R3dbVkoilkr4+SrDCgy86bzgdOvdZE0cTEaRYJtPHgZPGG2JkS
YKp91oTqg9+mC0iF35zynoZD50rZt6wYp0klPAZHMj+lnU6ylBioqHZZb5A4ymIa
LRtZ+KQ1WkNRczSlH7wu7Ft/kzY8OZS+psZlwsLi3fWaQqQNmcRE7DPrxweNyJCH
PJJiTINt5N9WwfVDCH2twkZ3djgFrjlaokstJ5+JlV+w5XFKKR0URY6l5ByT4Tzn
euY+dWhFZNDLF3XLY1datfVCCnbcfj8kaiyU/Qe9FpavDk4AgU809gHSfuolQQkJ
p5EzURFnYTyi3vG5s9pu6l7xx2D7/dchy6c4H2egvpGwOCJlJhaLCQbwNKsVFR03
FSSOePpdwGStFaNE4exQNG+x6rueB1MZ9WHSmBUieL1yppqn6vTn4/Ue+l1CeW08
k2ufgvJIEe3DMu5K8HbyrNAIbRl/5zgomlJDa197VdUnCTJmZANy1msNvJ1sVSca
wh23xTI1rBI1PGxDuR5uehDdlj2ClALcy875i6saSlk1yHNqlwLIskl341hW88iG
bgpfU4AP6AHU9x/tdNtj+/bgjtv1f1XrHnIVAgFATv//Lz2IpXZq4WF8bUnUaYqe
0HyDSykH0wI1W+bmlPu2
=Q841
-----END PGP SIGNATURE-----

--JSBWkthcGiLkjRFniRkUqJiNt6vdukPL2--
