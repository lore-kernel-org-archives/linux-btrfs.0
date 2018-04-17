Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:38597 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750972AbeDQAOl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 20:14:41 -0400
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
To: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
 <8476c1ee-365a-bb0f-0d44-94cca28d09f3@gmx.com>
 <20180412131318.GI21272@twin.jikos.cz>
 <e697b170-fdc7-9f59-d224-095a39c4abef@jp.fujitsu.com>
 <20180416172752.GR21272@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b37ea1d8-a145-9a21-a330-9392804ec0b0@gmx.com>
Date: Tue, 17 Apr 2018 08:14:22 +0800
MIME-Version: 1.0
In-Reply-To: <20180416172752.GR21272@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yAq8STfjd7Kk4myb5NEkImpTH2Op4atXZ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yAq8STfjd7Kk4myb5NEkImpTH2Op4atXZ
Content-Type: multipart/mixed; boundary="HWxxqh7UtAFDJcJOM3UvhW0EadbavUewI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b37ea1d8-a145-9a21-a330-9392804ec0b0@gmx.com>
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
 <8476c1ee-365a-bb0f-0d44-94cca28d09f3@gmx.com>
 <20180412131318.GI21272@twin.jikos.cz>
 <e697b170-fdc7-9f59-d224-095a39c4abef@jp.fujitsu.com>
 <20180416172752.GR21272@twin.jikos.cz>
In-Reply-To: <20180416172752.GR21272@twin.jikos.cz>

--HWxxqh7UtAFDJcJOM3UvhW0EadbavUewI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8817=E6=97=A5 01:27, David Sterba wrote:
> On Mon, Apr 16, 2018 at 04:53:10PM +0900, Misono Tomohiro wrote:
>> On 2018/04/12 22:13, David Sterba wrote:
>>> On Tue, Apr 03, 2018 at 03:30:34PM +0800, Qu Wenruo wrote:
>>>> I didn't see this patch merged in your misc-next branch but only the=

>>>> remaining patches.
>>>>
>>>> However without this patch, btrfs qgroup reserved space will get
>>>> obviously increased as prealloc metadata reserved space is never fre=
ed
>>>> until inode reserved space is freed.
>>>>
>>>> This would cause a lot of qgroup related test cases to fail.
>>>>
>>>> Would you please merge this patch with all qgroup patchset?
>>>
>>> For the record: patch 9 and 10 are now in misc next and will go to 4.=
17.
>>> I need to let them through the for-next and other testing, so it will=
 be
>>> some of the post rc1 pull requests.
>>
>> I still saw qgroup related xfstests (btrfs/022 etc.) fails in current =
misc-next branch
>> which includes 9th and 10th patches.
>>
>> I noticed 5th patch in the tree (already in v4.17-rc1) is older versio=
n and this
>> seems the reason that the tests still fails.
>=20
> Qu, can you please have a look a send an incremental fixup? Handling of=

> this patchset was not very good from my side, I should have asked for a=

> fresh resend as I applied the changes from mailinglist and not from git=
=2E

No problem, and for next time, I'll double check misc-next branch for
such difference.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--HWxxqh7UtAFDJcJOM3UvhW0EadbavUewI--

--yAq8STfjd7Kk4myb5NEkImpTH2Op4atXZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrVPF4ACgkQwj2R86El
/qjvoQgAhv4iiZlaChK4ucs0LTTnMK1Apdbb4uNmS3VKXh3oDckoNspT0dX6SbKA
9uQsEwV676rXNGyGLcCqFyXXqWfIevvHz1GvI+6VN9SyM/eL5iyKxsKNuhi9/34j
r1eNSDykJEER9CekxcB8ioujFQrSlHpngd6QuX66K24URKYkG63bfI5TgNb3u20F
LsMmhYJNEOyySvi6yYmDnoajz984VKItijBC1x0vXCNGlvx9osEPZzZMBa/jnqdr
ZYQkp6MXPSDUI2Hp8rDA32+fByZ4IiVJz67Qw32XauyiBcrnp+GoJ4rg6fvNe8ZL
RjnbhFBaB3koL7FK4+r3p9grwHFBrQ==
=JJ1T
-----END PGP SIGNATURE-----

--yAq8STfjd7Kk4myb5NEkImpTH2Op4atXZ--
