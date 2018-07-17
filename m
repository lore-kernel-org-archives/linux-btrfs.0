Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52005 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731523AbeGQOF0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 10:05:26 -0400
Subject: Re: [PATCH 5/5] btrfs: Verify every chunk has corresponding block
 group at mount time
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-6-wqu@suse.com> <20180705151804.GH3126@twin.jikos.cz>
 <fc9a063d-27d9-dbe7-db6f-b780cf59a6f6@suse.de>
 <20180716131622.GI3126@twin.jikos.cz>
 <153199b2-0e2b-cbe7-7c35-f42e470e9a4e@gmx.com>
 <20180717123329.GX3126@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1e42f435-c769-015f-8039-0d68a5d8e1af@gmx.com>
Date: Tue, 17 Jul 2018 21:32:27 +0800
MIME-Version: 1.0
In-Reply-To: <20180717123329.GX3126@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UtuxD5Gh95e0l73Lg14NZTLCaJ3JRkO1R"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UtuxD5Gh95e0l73Lg14NZTLCaJ3JRkO1R
Content-Type: multipart/mixed; boundary="rrQgolUCTUUFI7rUdLDXOm3hQ9SQq1zPQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <1e42f435-c769-015f-8039-0d68a5d8e1af@gmx.com>
Subject: Re: [PATCH 5/5] btrfs: Verify every chunk has corresponding block
 group at mount time
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-6-wqu@suse.com> <20180705151804.GH3126@twin.jikos.cz>
 <fc9a063d-27d9-dbe7-db6f-b780cf59a6f6@suse.de>
 <20180716131622.GI3126@twin.jikos.cz>
 <153199b2-0e2b-cbe7-7c35-f42e470e9a4e@gmx.com>
 <20180717123329.GX3126@twin.jikos.cz>
In-Reply-To: <20180717123329.GX3126@twin.jikos.cz>

--rrQgolUCTUUFI7rUdLDXOm3hQ9SQq1zPQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8817=E6=97=A5 20:33, David Sterba wrote:
> On Mon, Jul 16, 2018 at 09:57:43PM +0800, Qu Wenruo wrote:
>>>>> -EUCLEAN ?
>>>>
>>>> Either works for me.
>>>
>>> That's not just a cosmetic change, there's a semantic difference betw=
een
>>> the error codes, I maybe make that more explicit and not expect that =
this
>>> is obvious.
>>>
>>> ENOENT does not make much sense in this context, the caller (mount in=

>>> this case) cannot do anything about a code that says 'some internal
>>> structure not found'.
>>
>> The point here is, if every self-checker should only return -EUCLEAN, =
it
>> won't really indicate what's going wrong, except points to some
>> self-checker (and such self-checkers are growing larger than our
>> expectation already).
>>
>> My practice here is, put some human readable and meaningful error
>> message. No matter what we choose to return, the error message should
>> tell us what's going wrong.
>>
>> In this case, I don't really care the return value. If it's explicitly=

>> needed to return -EUCLEAN, I could make all existing checker (from
>> tree-checker to chunk/bg/dev-extent checker) to return -EUCLEAN if
>> anything is wrong (and save several "ret =3D -EUCLEAN" lines).
>> The return value doesn't really have much meaning nowadays, it's the
>> error message important now.
>=20
> Ok, I see what you mean. The message is important as it's otherwise
> almost impossible to find where exactly the mount fails.
>=20
> The error messages perhaps fall into several categories:
>=20
> 1) transient errors, some failure that happens before the filesystem st=
ate
>    is fully examined
>=20
> this is namely ENOMEM, or EINTR eg. returned by kthread_run

This standard is a little misleading, or did I misunderstand your categor=
y?

=46rom the example error number, I could only find ENOMEM so
straightforward for end user/developer that we don't need any error
message to explain them.
Or this category is just for error no need of error message? (or can be
handled by btrfs-progs without any need of user interruption/decision?)

>=20
> maybe also a failure on a multi-device filesystem when the devices
> haven't been scanned yet
>=20
> 2) clearly some corruption/consistency condtion, with enough informatio=
n
>    available to decide
>=20
> like a missing tree, most of the tree-checker would fall into this
> category

This is pretty clear.

>=20
> 3) same as the previous one, but there's some external condition preven=
ting
>    a full check
>=20
> that's eg. a real EIO after reading a tree block

That csum mismatch EIO with error message or really some error from
underlying layer like some ATA command failure?

>=20
>=20
> The error code are IMO important to see how severe the problems are and=

> what's the expected solution. 2 is for 'check', 3 may need degraded
> mount, 1 needs maybe more time to mount again.

Category 2 for check is sure.
For other 2 cases it's a little hard to say.
Normally if we really hit some error we don't expect, under most case
the filesystem is already corrupted (e.g. a lot of errors of resuming
balance/mount failure finally turns out to be fs corruption).

If category is determined by the expected solution, most will just fall
into category 2), including most of errors we have in btrfs module
currently.

>=20
> With the error messages in place, 2 can be completely covered by
> EUCLEAN. I briefly skimmed a few call paths and think that the 3
> categories should be enough, but I'm also expecting some exceptions tha=
t
> can be decided case by case.

For category 2), I think it's pretty clear and practically to use EUCLEAN=
=2E

For other categories I'm not really sure.

E.G what happens if we can't find certain backref when running delayed
refs? It's either a kernel bug or a corrupted fs.
Which category should it fit? Category 2? But we don't really know
what's going wrong.
For category 1/3? It won't really be fixed until we fix the bug or the fs=
=2E

More details examples would definitely help me understand the category.

>=20
> The error codes are now not consistent, lots of EUCLEAN are historicall=
y
> EIO, but before we start cleaning that up we should have at least some
> guidelines. Please let me know what you think.
>=20
At least for self-verification code it's pretty clear that we should
have error message for what's going wrong and what we expect, with
explicit EUCLEAN error number.

Thanks,
Qu


--rrQgolUCTUUFI7rUdLDXOm3hQ9SQq1zPQ--

--UtuxD5Gh95e0l73Lg14NZTLCaJ3JRkO1R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltN7+sACgkQwj2R86El
/qjqAgf/SBSFDK600payX1UNCAfy3qcBsjV/ZHKacEG1W1JzpXZvw+HaWUeD+B1R
4p0IMQ7NQq0+htiuYK6TbggEl8qRQY7nqVVjrDzR1GibW+3Au6jn3doILEm7/a9R
nJR/AuWApPXzJEtT9kg0XJ5+ckYxj6J4JmlWG3sTm/oIG2CKFX6366ddRoomKj8o
CdfNwXK+Zm2xHD6phh9k3DQTrjUqm/6BkFCIgr0EO5VSQkJuVuB+O8xVR4y3KysK
xq3JuR1zghod0uajxkQW7IoKPdEDvXGlx9Z0GxY3CRMr8kdEln0/yNWgk+M7YFEJ
9coA2bYXwlOonCmjWeYTyLNBKD6VYA==
=cH4d
-----END PGP SIGNATURE-----

--UtuxD5Gh95e0l73Lg14NZTLCaJ3JRkO1R--
