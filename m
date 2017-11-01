Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52125 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdKAHSu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 03:18:50 -0400
Subject: Re: [PATCH 0/8] mkfs: Quota support
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171027072936.4697-1-wqu@suse.com>
 <20171027173709.GO3521@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b05858ae-082f-3ef4-79dd-91b73715779f@gmx.com>
Date: Wed, 1 Nov 2017 15:18:34 +0800
MIME-Version: 1.0
In-Reply-To: <20171027173709.GO3521@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cvF92MAqcEeLdwPBT6NJ9ihtNbNJ548rP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cvF92MAqcEeLdwPBT6NJ9ihtNbNJ548rP
Content-Type: multipart/mixed; boundary="GuvUhxLkJO87TdeOSjh4N0KW9i2wsA7M6";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b05858ae-082f-3ef4-79dd-91b73715779f@gmx.com>
Subject: Re: [PATCH 0/8] mkfs: Quota support
References: <20171027072936.4697-1-wqu@suse.com>
 <20171027173709.GO3521@twin.jikos.cz>
In-Reply-To: <20171027173709.GO3521@twin.jikos.cz>

--GuvUhxLkJO87TdeOSjh4N0KW9i2wsA7M6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8828=E6=97=A5 01:37, David Sterba wrote:
> On Fri, Oct 27, 2017 at 03:29:28PM +0800, Qu Wenruo wrote:
>> This patchset adds quota support, which means the result fs will have
>> quota enabled by default, and its accounting is already consistent, no=

>> manually rescan or quota enable is needed.
>=20
> Great, thanks for working on that. I'm going to merge the preparatory
> patches next. I'm not sure about the command line option, we might want=

> to design it in a similar way as -O/--features. As this is a runtime
> feature (unlike the on-disk format features), a new option will be
> needed, backed by some research what other mkfs.* tools use.

Well, checked xfs and ext4, they mostly co-operate with mount options
and mkfs options to handle optional feature like their quota.


But considering they have multiple options for journal/extra setting, it
won't be reasonable for mkfs.btrfs to have something like
"--runtime-features|-R"

If you're OK with that option name, I can use it to implement "-R quota".=


>=20
> The uuid_tree would at least use the btrfs_create_tree, but I don't
> think we'd need to create it only on request, so quotas will be the onl=
y
> option.
>=20
>> 2) Fill quota root with basic skeleton
>>    Only 3 items are really needed
>>    a) global quota status item
>>    b) quota info for 0/5 qgroup
>>    c) quota limit for 0/5 qgroup
>>
>>    The content doesn't matter at all.
>=20
> How would --rootdir and quotas behave in that case? A related question
> is what will be the semantics of rootdir+quotas+subvolume created at
> mkfs time.
>=20
> We can certainly start with only quotas on the empty filesystem, but I'=
m
> sure somebody will ask for the wild combination at some point.

I'll add test case for quota with --rootdir in next update.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--GuvUhxLkJO87TdeOSjh4N0KW9i2wsA7M6--

--cvF92MAqcEeLdwPBT6NJ9ihtNbNJ548rP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln5dUoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjppAf/bh/HcQQ/c2ESCr1W/e0u7Zuu
CGl7CDPQ2oyuhTdE7rAKrdIVp+oNL0P2ttnfXyZChRyXmXMCtjayM9YedsCh/kZC
q7lDSRYMreadB9lzXvG0qUE5VYA07aNZrz2RMEWcjQkAqJZGPRFEXZf+iyKKBXDA
1f5U88inIB+6FIFKHxHfwooe/n1Df4IA2qfRyyuNmWFFNnUKnoZUM0szsseJvV/W
Nt6MuA9g/LctsH2WhpoUr5ZdS9NgHRZ+dVsAejHa9WhIZSJK+G6XMrXFA0CwJtTQ
GTmwq62SwRVzpMYUZ/NZNyenxY/0Z+HQBPNUyCnhztQtLbifu/9DXO+rOS3rTg==
=Jjmr
-----END PGP SIGNATURE-----

--cvF92MAqcEeLdwPBT6NJ9ihtNbNJ548rP--
