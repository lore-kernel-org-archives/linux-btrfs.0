Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64542 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751025AbdJ0X5q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 19:57:46 -0400
Subject: Re: [PATCH 0/8] mkfs: Quota support
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171027072936.4697-1-wqu@suse.com>
 <20171027173709.GO3521@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a358fe47-920d-25e8-3d4d-7c1fb7b7c8c3@gmx.com>
Date: Sat, 28 Oct 2017 07:57:31 +0800
MIME-Version: 1.0
In-Reply-To: <20171027173709.GO3521@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8C5WQD8Spt84ipTdttPVglw0Jexw6QQrQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8C5WQD8Spt84ipTdttPVglw0Jexw6QQrQ
Content-Type: multipart/mixed; boundary="OK8C0dIMK48LlOLQHpgX7Xd21IC0O3iAe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <a358fe47-920d-25e8-3d4d-7c1fb7b7c8c3@gmx.com>
Subject: Re: [PATCH 0/8] mkfs: Quota support
References: <20171027072936.4697-1-wqu@suse.com>
 <20171027173709.GO3521@twin.jikos.cz>
In-Reply-To: <20171027173709.GO3521@twin.jikos.cz>

--OK8C0dIMK48LlOLQHpgX7Xd21IC0O3iAe
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

OK, I'll reconsider the command line interface.

Although I'm not pretty sure if other fs will has such design.

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

Already considered! (Although not in test case)

For current behavior, rootdir works fine, as we only use one subvolume
(fs tree) and rescan is placed just after we filled fs tree.

So, as you could try your self, it's completely fine.

And the infrastructure I used in the helpers can easily handle the case
where extra subvolume qgroups are used.
Just pass insert_qgroup_items() with new qgroupid, then rescan will
handle them all.

Thanks,
Qu

>=20
> We can certainly start with only quotas on the empty filesystem, but I'=
m
> sure somebody will ask for the wild combination at some point.> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--OK8C0dIMK48LlOLQHpgX7Xd21IC0O3iAe--

--8C5WQD8Spt84ipTdttPVglw0Jexw6QQrQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnzx+sXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjn3Qf+KmdDjlWnAOT7aN69bL4KVQJr
YWA1GgTxLxIinhxQ3rLMnFheeJRXrRI749nqCBJ/cya/Ra+f3eQAybDrJadNTS6n
2tNRFg5FJPpUUT7Szo8/jXoPPhInNvbWdUuPwQdrbb2Et6gHLG1AwEgb463ViLOZ
TNB6e4bsFJ4JycMHxOoh2+Bd9Q6uaElDwJ6ziqQGwovBdGmw9XccVb2kQ8cjX46/
G4CFud1DnanQ8U2p6J4yKF1BfT7noYUYfd4D1a3nJ5OpgLfCfauo4tQkN8dAcwtK
+N+XatE2EjFeOs3rIYFvbNd6xyrji3CFZv5Xe3GIvaSzmhaNSJxKNyypDg2PMQ==
=lXGJ
-----END PGP SIGNATURE-----

--8C5WQD8Spt84ipTdttPVglw0Jexw6QQrQ--
