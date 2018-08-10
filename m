Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:32789 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbeHJLmf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 07:42:35 -0400
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: Dan Merillat <dan.merillat@gmail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com>
 <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com>
Date: Fri, 10 Aug 2018 17:13:30 +0800
MIME-Version: 1.0
In-Reply-To: <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="m8Gs3bMl34kGKbqXtGramxjae3MqoDFqh"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--m8Gs3bMl34kGKbqXtGramxjae3MqoDFqh
Content-Type: multipart/mixed; boundary="ehaTMqNjlvqXfNjpVIqe8ltqDLYQLNnKj";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com>
 <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
In-Reply-To: <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>

--ehaTMqNjlvqXfNjpVIqe8ltqDLYQLNnKj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/10/18 4:47 PM, Dan Merillat wrote:
> Unfortunately that doesn't appear to be it, a forced restart and
> attempted to mount with skip_balance leads to the same thing.

That's strange.

Would you please provide the following output to determine whether we
have any balance running?

# btrfs inspect dump-super -fFa <device>

# btrfs inspect dump-tree -t root <device>

>=20
> 20 minutes in btrfs-transactio had a large burst of reads then started
> spinning the CPU with the disk idle.
>=20
> Is this recoverable? I could leave it for a day or so if it may make
> progress, but if not I'd like to start on other options.

When umounted, would you please also try "btrfs check --readonly
<device>" to see if there is anything wrong about the fs?

Thanks,
Qu

>=20
> On Fri, Aug 10, 2018 at 3:59 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 8/10/18 3:40 PM, Dan Merillat wrote:
>>> Kernel 4.17.9, 11tb BTRFS device (md-backed, not btrfs raid)
>>>
>>> I was testing something out and enabled quota groups and started gett=
ing
>>> 2-5 minute long pauses where a btrfs-transaction thread spun at 100%.=

>>
>> Looks pretty like a running balance and quota.
>>
>> Would you please try with balance disabled (temporarily) with
>> skip_balance mount option to see if it works.
>>
>> If it works, then either try resume balance, or just cancel the balanc=
e.
>>
>> Nowadays balance is not needed routinely, especially when you still ha=
ve
>> unallocated space and enabled quota.
>>
>> Thanks,
>> Qu
>>
>>>
>>> Post-reboot the mount process spinds at 100% CPU, occasinally yieldin=
g
>>> to a btrfs-transaction thread at 100% CPU.  The switchover is marked
>>> by a burst of disk activity in btrace.
>>>
>>> Btrace shows all disk activity is returning promptly - no hanging sub=
mits.
>>>
>>> Currently the mount is at 6+ hours.
>>>
>>> Suggestions on how to go about debugging this?
>>>
>>


--ehaTMqNjlvqXfNjpVIqe8ltqDLYQLNnKj--

--m8Gs3bMl34kGKbqXtGramxjae3MqoDFqh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlttVzoACgkQwj2R86El
/qg6uwf/TL0tBQ64DTxeYZnXuj51XXYlcKRpu5R242ohDKmKrPVKaH5uy9G1Nqwl
v2Jjoyb/wb5QcshLTaB/WxMTjBPjIh0Ccy/xTfZxsd6Phd6cz6GCrbSoIZUBTMMV
2EI2KfJzUEtQ9PLmveFniZzrAjoDdJIXOo0tG7PA2wIybnDufTZ77lUWUH3J1a3k
Kuie616n2X4xKwo3uXhG9lYcoa1veEhgdvs+RzWeKntZ10XZlIxa38TLfvtVHyo3
UoAruXx2WKgwN1gkxFQwMZEepVXtQKAmzvLp3uGiLFR6pOpZNlfFtU5g5IUgT+6Y
rZl8BCwUER4cCprzoIGAVjLLd7gXCQ==
=UPyN
-----END PGP SIGNATURE-----

--m8Gs3bMl34kGKbqXtGramxjae3MqoDFqh--
