Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:37327 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754975AbeCHBCy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 20:02:54 -0500
Subject: Re: [PATCH] btrfs: qgroups, properly handle no reservations
To: dsterba@suse.cz, Jeff Mahoney <jeffm@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180221201921.17944-1-jeffm@suse.com>
 <2030c88e-328a-8021-3dfd-0631e7429eac@gmx.com>
 <f0c73e34-dc33-d2eb-56d6-2b936f1f967b@suse.com>
 <ac3ffb4b-c60a-fd1e-be50-db99376a6e1e@gmx.com>
 <20180307160248.GG23693@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6efc6500-c8ce-6f4c-51d6-1bb6804a1fbc@gmx.com>
Date: Thu, 8 Mar 2018 09:02:35 +0800
MIME-Version: 1.0
In-Reply-To: <20180307160248.GG23693@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9CBDXDTleKsPcAZPmnkigkG6ieMc2mkWF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9CBDXDTleKsPcAZPmnkigkG6ieMc2mkWF
Content-Type: multipart/mixed; boundary="WN0vRdPK5NCSC6H0Gy8iXDc9nfSXt5TvA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Jeff Mahoney <jeffm@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <6efc6500-c8ce-6f4c-51d6-1bb6804a1fbc@gmx.com>
Subject: Re: [PATCH] btrfs: qgroups, properly handle no reservations
References: <20180221201921.17944-1-jeffm@suse.com>
 <2030c88e-328a-8021-3dfd-0631e7429eac@gmx.com>
 <f0c73e34-dc33-d2eb-56d6-2b936f1f967b@suse.com>
 <ac3ffb4b-c60a-fd1e-be50-db99376a6e1e@gmx.com>
 <20180307160248.GG23693@twin.jikos.cz>
In-Reply-To: <20180307160248.GG23693@twin.jikos.cz>

--WN0vRdPK5NCSC6H0Gy8iXDc9nfSXt5TvA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8808=E6=97=A5 00:02, David Sterba wrote:
> On Thu, Feb 22, 2018 at 10:05:36AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B402=E6=9C=8822=E6=97=A5 09:50, Jeff Mahoney wrote:
>>> On 2/21/18 8:36 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2018=E5=B9=B402=E6=9C=8822=E6=97=A5 04:19, jeffm@suse.com wrote:
>>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>>>
>>>>> There are several places where we call btrfs_qgroup_reserve_meta an=
d
>>>>> assume that a return value of 0 means that the reservation was succ=
essful.
>>>>>
>>>>> Later, we use the original bytes value passed to that call to free
>>>>> bytes during error handling or to pass the number of bytes reserved=
 to
>>>>> the caller.
>>>>>
>>>>> This patch returns -ENODATA when we don't perform a reservation so =
that
>>>>> callers can make the distinction.  This also lets call sites not
>>>>> necessarily care whether qgroups are enabled.
>>>>
>>>> IMHO if we don't need to reserve, returning 0 seems good enough.
>>>> Caller doesn't really need to care if it has reserved some bytes.
>>>>
>>>> Or is there any special case where we need to distinguish such case?=

>>>
>>> Anywhere where the reservation takes place prior to the transaction
>>> starting, which is pretty much everywhere.  We wait until transaction=

>>> commit to flip the bit to turn on quotas, which means that if a
>>> transaction commits that enables quotas lands in between the reservat=
ion
>>> being take and any error handling that involves freeing the reservati=
on,
>>> we'll end up with an underflow.
>>
>> So the same case as btrfs_qgroup_reserve_data().
>>
>> In that case we could use ret > 0 to indicates the real bytes we
>> reserved, instead of -ENODATA which normally means error.
>>
>>>
>>> This is the first patch of a series I'm working on, but it can stand
>>> alone.  The rest is the patch set I mentioned when we talked a few
>>> months ago where the lifetimes of reservations are incorrect.  We can=
't
>>> just drop all the reservations at the end of the transaction because =
1)
>>> the lifetime of some reservations can cross transactions and 2) becau=
se
>>> especially in the start_transaction case, we do the reservation prior=
 to
>>> waiting to join the transaction.  So if the transaction we're waiting=
 on
>>> commits, our reservation goes away with it but we continue on as if w=
e
>>> still have it.
>>
>> Right, the same problem I also addressed in patchset "[PATCH v2 00/10]=

>> Use split qgroup rsv type".
>>
>> In 6th patch, "[PATCH v2 06/10] btrfs: qgroup: Use
>> root->qgroup_meta_rsv_* to record qgroup meta reserved space" qgroup
>> meta reserve will only be increased if we succeeded in reserving
>> metadata, so later free won't underflow that number.
>=20
> What should we do now when there are 2 different fixes? Applying Jeff's=

> patch on top of your qgroup-types patches causes some conflicts that do=

> not seem to be difficult, but the end result might not work as expected=
=2E

Jeff's patch is a more pinpoint solution to handle metadata reservation
error, while mine is a generic one which adds another layer to catch
possible underflow.

I think both could co-exist.

The only thing I'm not a fan is the return value of -ENODATA.
Despite that it should be fine.

Thanks,
Qu

>=20
> The changes do not seem to be fundamentally conflicting, would it make
> sense to merge both?
> The patchset has been in for-next for a while but I
> don't run qgroup specific tests besides what's in fstests. Also the
> patchset fixes more problems so I think we need to merge it at some
> point and now it's a good time about deciding whether it'd go to 4.17.
>=20
> I did a pass through the patches, there are some minor things to fix bu=
t
> a review from somebody with qgroup knowledge would be still desirable.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--WN0vRdPK5NCSC6H0Gy8iXDc9nfSXt5TvA--

--9CBDXDTleKsPcAZPmnkigkG6ieMc2mkWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqgi6wXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjO3wf/VmVf8HerNSBrtW6RJQWlRYSD
RvATZM3Z2s5RA4KJlzPylu0qGlQXPQnzt3OwzAZqdzbMA9XArIk3lboRqrKtMpYg
JgbCOsOLJWPf2OQbW2eLg9KG5ZXZN94ZCzvn2yga9BiBaHxNKRixVl4ulyRtP6Sf
puEEz/YTc+w5jX6lLyRw26duIXPQgYj8iU+uLM321DzWOWqKk/1XoK13/A7reaFg
g1dRt2zKeQSiEWR+5nwqpuvQnAvX7hKWeSjGgvlU5kji0zLWVVhTRjVfZdr5QI8K
/LFfGW/nAYY0s/MreK5Sk3ZFOwyCO6lzkO+M7sCW+K6XhoSAu5l+hbACi7D/bA==
=ztvz
-----END PGP SIGNATURE-----

--9CBDXDTleKsPcAZPmnkigkG6ieMc2mkWF--
