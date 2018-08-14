Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:39015 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730488AbeHNQJe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 12:09:34 -0400
Subject: Re: [RFC PATCH] btrfs: Remove 'objectid' member from struct
 btrfs_root
To: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1533531264.git.misono.tomohiro@jp.fujitsu.com>
 <432b7e99-dd88-4724-083f-a4b7ab5efe31@jp.fujitsu.com>
 <1188cc84-3116-e7e6-ae80-00b6bf4a424d@gmx.com>
 <20180813173715.GA24025@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2d574af1-c5eb-a65e-7006-86d5bb563026@gmx.com>
Date: Tue, 14 Aug 2018 21:22:10 +0800
MIME-Version: 1.0
In-Reply-To: <20180813173715.GA24025@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zVfCuciVs8XOtYxL18iFFDE8Z4N0YriSS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zVfCuciVs8XOtYxL18iFFDE8Z4N0YriSS
Content-Type: multipart/mixed; boundary="eQapjuft0JMG4qZzzTaoW5ROpbxHgjJ60";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <2d574af1-c5eb-a65e-7006-86d5bb563026@gmx.com>
Subject: Re: [RFC PATCH] btrfs: Remove 'objectid' member from struct
 btrfs_root
References: <cover.1533531264.git.misono.tomohiro@jp.fujitsu.com>
 <432b7e99-dd88-4724-083f-a4b7ab5efe31@jp.fujitsu.com>
 <1188cc84-3116-e7e6-ae80-00b6bf4a424d@gmx.com>
 <20180813173715.GA24025@twin.jikos.cz>
In-Reply-To: <20180813173715.GA24025@twin.jikos.cz>

--eQapjuft0JMG4qZzzTaoW5ROpbxHgjJ60
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/14 =E4=B8=8A=E5=8D=881:37, David Sterba wrote:
> On Mon, Aug 06, 2018 at 02:17:54PM +0800, Qu Wenruo wrote:
>>> -	u64 objectid;
>>
>> Off topic crazy idea here.
>>
>> I think it is a little crazy, but it should save a lot of objectid
>> related modification:
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 118346aceea9..e6d70f2309a3 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1166,7 +1166,10 @@ struct btrfs_root {
>>
>>         unsigned long state;
>>         struct btrfs_root_item root_item;
>> -       struct btrfs_key root_key;
>> +       union {
>> +               struct btrfs_key root_key;
>> +               u64 objectid;
>> +       };
>>         struct btrfs_fs_info *fs_info;
>>         struct extent_io_tree dirty_log_pages;
>>
>> @@ -1198,7 +1201,6 @@ struct btrfs_root {
>>         int last_log_commit;
>>         pid_t log_start_pid;
>>
>> -       u64 objectid;
>>         u64 last_trans;
>>
>>         u32 type;
>>
>> I'm not sure if this is a really crazy idea or a dirty hack to reduce
>> some modification.
>=20
> Be wary of such tricks. This might make you feel good for a moment how
> good your C knowlege is, and also might save a few keystrokes. And a fe=
w
> years later this costs somebody a week of debugging a mysterious memory=

> corrupption under circumstances not imagined right now.

Yep, that's why I'm calling this a "crazy idea" for the same reason.

Just wondering if there is any better way to do it without using a
trick, like anonymous structure inside btrfs_root?
(Purely to improve my C skill if possible)

Anyway, I'm completely OK with current patch.

Thanks,
Qu

>=20
> Try to write understandable code. If there is a reason to use tricks,
> like the struct page has to do for performance reasons, then it must be=

> documented and justified.
>=20


--eQapjuft0JMG4qZzzTaoW5ROpbxHgjJ60--

--zVfCuciVs8XOtYxL18iFFDE8Z4N0YriSS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlty14IACgkQwj2R86El
/qgIPQgApLkJOBz5MklXfQUG9WxwQ1bxfg1wMAFOH2Yz1xPxyboFKIbgpnVUCIdO
BLplIPlucJ/FmMYPCsncZGXn67zfIwqfeCGJwaWL6s8PWjUyXdbF9P5FSe3vkHRW
NqhkVwPKz5/pvMog5flNmq74tqJ107hcsGEOFBoc1skWlxhiWaXYfmQW4cGBj/af
v5DOMMb8ZcwK3DDnZr6e63gam01+6RRpMiCtfhcGC1LqE05AKiUKbLQaeOBi+1Ui
Zq1yweM0YscBDy9YGUp31YIKDYBLAPOb3cqN2WIwAtN3Dfuols8yMxoWHPsHn+V1
1BA4yyRGVbsmwm+Jb/Mqv4SCndch+A==
=JWzw
-----END PGP SIGNATURE-----

--zVfCuciVs8XOtYxL18iFFDE8Z4N0YriSS--
