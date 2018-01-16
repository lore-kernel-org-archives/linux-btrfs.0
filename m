Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:61672 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751628AbeAPM3f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 07:29:35 -0500
Subject: Re: invalid files names, btrfs check can't repair it
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
References: <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
 <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
 <b926ecdb-94da-1067-ff74-7d5392a7fe46@gmx.com>
 <20180116101058.wtcdjnqldcb5q3a7@breakpoint.cc>
 <4b929845-beae-9e13-2df9-ddc3232ad39a@gmx.com>
 <20180116104949.7qtf67mrdvyxrvs4@breakpoint.cc>
 <acf4b795-0fb9-c9c8-63a9-5d888afa9419@gmx.com>
 <20180116121553.eldnuftys54zwcuy@breakpoint.cc>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <31d45254-646d-2332-d993-ca7a9d654553@gmx.com>
Date: Tue, 16 Jan 2018 20:28:41 +0800
MIME-Version: 1.0
In-Reply-To: <20180116121553.eldnuftys54zwcuy@breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RAOBMJSuHirfYAiDcC8NK1xaeU17lS6UL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RAOBMJSuHirfYAiDcC8NK1xaeU17lS6UL
Content-Type: multipart/mixed; boundary="lUpdWvagUDvX9aS4v8Ga0vREbM7eLKdBZ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Message-ID: <31d45254-646d-2332-d993-ca7a9d654553@gmx.com>
Subject: Re: invalid files names, btrfs check can't repair it
References: <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
 <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
 <b926ecdb-94da-1067-ff74-7d5392a7fe46@gmx.com>
 <20180116101058.wtcdjnqldcb5q3a7@breakpoint.cc>
 <4b929845-beae-9e13-2df9-ddc3232ad39a@gmx.com>
 <20180116104949.7qtf67mrdvyxrvs4@breakpoint.cc>
 <acf4b795-0fb9-c9c8-63a9-5d888afa9419@gmx.com>
 <20180116121553.eldnuftys54zwcuy@breakpoint.cc>
In-Reply-To: <20180116121553.eldnuftys54zwcuy@breakpoint.cc>

--lUpdWvagUDvX9aS4v8Ga0vREbM7eLKdBZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8816=E6=97=A5 20:15, Sebastian Andrzej Siewior w=
rote:
> On 2018-01-16 19:20:56 [+0800], Qu Wenruo wrote:
>> This is a very minor problem.
>>
>> btrfs check --repair should handle it without problem.
>=20
> awesome, thank you! After the --repair completed, the following didn't
> report the error anymore. And now I was able to remove the two files.
> Thank you.

And thanks for your report on this issue too, I'm working on the generic
repair function for such type mismatch and name len mismatch.

It would be soon to see such repair function in btrfs-progs, and no need
to bother using any hard coded fixer.

(Just a little spoiler, the repair functionality will land in lowmem
mode first, as lowmem mode already have such infrastructure to address
it, although if executed with mainline btrfs-progs, it will just worse
the problem)

Thanks,
Qu

>=20
>> Thanks,
>> Qu
>=20
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--lUpdWvagUDvX9aS4v8Ga0vREbM7eLKdBZ--

--RAOBMJSuHirfYAiDcC8NK1xaeU17lS6UL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpd7/kXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgOCQgAhIYl7hh5Y2DQfgdLIkSrSG7Z
Oz4a0g//QxqiYES7BpzGNUssTYzhATEGdE/0DUvw8upG5t5LiC3kmgMxv5M/JJsp
tPWPCkenls0GhRLa3ior3o4fYpZwOerjVuBGGu7j2S0ZaRTAveQTfEif+mBcVwjA
ak2EaSry66F1qK7sCT8a4VqQDL0TV+dYUAxJnN/WrcBBjRgmsBnHxz7FDH6nWHHH
fzmlM4aLGCB+pw1HyZ3k32oOwrEPRE285hZOy2Kzo574GTz6Ggjtg/kbYfB9JINe
Sq7rU0mS5Kuk8lnC7ELP32pJ6L1gmJBeqdXtdItZXw7osKleuYLjJLn4jj5AFA==
=7w0Y
-----END PGP SIGNATURE-----

--RAOBMJSuHirfYAiDcC8NK1xaeU17lS6UL--
