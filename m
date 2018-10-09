Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6A8C6787A
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 00:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95AE92145D
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 00:16:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="f8lfp5mv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95AE92145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbeJIHbF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 03:31:05 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:25952
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725749AbeJIHbE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 03:31:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CD0gu1Oz52GV8F24wDfLr5cbcaq0guTIhFHw5pZuxBg=;
 b=f8lfp5mv9JLFpGHnPVoBEy8t4CODergl7G9pisKnY578sKruM4OBiRk3YvAGHVOK10YsHWju6rGO9bxzJFbvYYHs1qRBWjgVB6YFnaWndfPBx6Y3/5YqqiHX11d3oyLFghz3MmNyWMr9X1hJqybQ5s1yau3VYKqUc5CkoLvQmX0=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB5105.eurprd06.prod.outlook.com (20.178.19.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.28; Tue, 9 Oct 2018 00:16:45 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1207.024; Tue, 9 Oct 2018
 00:16:44 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Nicholas D Steeves <nsteeves@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Pierre Couderc <pierre@couderc.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: merge status of per-chunk degradable check [was Re: Which device
 is missing ?]
Thread-Topic: merge status of per-chunk degradable check [was Re: Which device
 is missing ?]
Thread-Index: AQHUX2QqmLCRd+ZW8US/HJCDO53dJKUWC+6A
Date:   Tue, 9 Oct 2018 00:16:44 +0000
Message-ID: <1fa4c752-95e8-967c-7f3a-b7888b74c083@mendix.com>
References: <700c973f-7ac7-5416-6e15-9e5e4faf9f67@couderc.eu>
 <20181008161055.GB25913@carfax.org.uk>
 <20181009000801.lvyx4uv25wg66a3m@DigitalMercury.dynalias.net>
In-Reply-To: <20181009000801.lvyx4uv25wg66a3m@DigitalMercury.dynalias.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM3PR04CA0139.eurprd04.prod.outlook.com (2603:10a6:207::23)
 To AM0PR06MB3921.eurprd06.prod.outlook.com (2603:10a6:208:b2::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB5105;6:zvY2Vq6rc/4mevcFJcaPLA3w+CjXITWOKXFn16wgc0hsFeJ2oQh7dVK8FPSR9bYUFlAkf1R4SxV7YxpWWfyM/qEDrgF3GaN9pVyvdyBevV/q9+4hID2xc+VWnBFlAZzl8ge51MuBQr5zotzqW1Tb7PF15zShZDqvS3lk4Lc3hPlp5T/BsriwlPRCUGsMcwchB8upjqCiE7C+4KzGLIGWjRu7O7UdlKjAdE6glaeQa2XnXgVl35h/eSkA9h7dFPoqWQ85ZqU2ZK35R+LJtjFumet0QJ4465n9qe3ttGxHlJvUpjgRiCYx4ue9ZC3S1QiyG2t+kQ7dAfm+pRp7ZztCq13G9lAEBamMNx3S6YJV8zV0SzE4alKtT0ehy8yK3KZouhygJRItTHudo9YIkLWZ765XiQfOv384JLMTJI14GJTZ4eqrQmoDeZ2/kLufcyvlLgyFzkA5YQ0+69DuHeyPiQ==;5:9REEDX6RSPBLk+Jef1uR/lZwjssFIJ7vwfH/hj7Ewfe7K/+kHqoK/qKSZLf1cBIFiKoIezH5D8sULt8UrV2kQ29GYEW7lYm0s/1liUjbURp6IPsWvybBfFhyFaZzBYSvTHdmZgJl442rOkGXnSufl4tvTMPCacLxqcrWwcAVXZs=;7:gD5A9t3aDNLRzPctd17EIpqulmuxqWhis7v8o9VTHsFdw9hgnu6e3pfnO+X7QtiBZUzTS9oFc7C8COO+s0zthLJq310XIhYd900v/xw3jnEsB0bnc+LKuxXDSOK4AUTQlsRZJj/WwpWgtQw1QeR7g12MFGdDwIhcOfJuAXZTAcfPpqeb0qZu31KYZTvZ669OEWUi5b0t5HownUwRWL4sNx+vM3fMysiMqhWv2i+1Tdsphvl51p4F9v1MP3oJ5r/j
x-ms-office365-filtering-correlation-id: 400a8a7e-623c-44c0-486d-08d62d7c7ec1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(49563074)(7193020);SRVR:AM0PR06MB5105;
x-ms-traffictypediagnostic: AM0PR06MB5105:
x-microsoft-antispam-prvs: <AM0PR06MB5105D2DAC83B358ECAA837C7D4E70@AM0PR06MB5105.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(102415395)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(4983020)(52105095)(149066)(150057)(6041310)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123560045)(201708071742011)(7699051)(76991055);SRVR:AM0PR06MB5105;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB5105;
x-forefront-prvs: 08200063E9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(39850400004)(376002)(366004)(189003)(199004)(71200400001)(25786009)(71190400001)(2900100001)(72206003)(99936001)(966005)(478600001)(6116002)(14454004)(6246003)(97736004)(5250100002)(229853002)(53936002)(6306002)(316002)(6486002)(6436002)(6512007)(110136005)(58126008)(8676002)(68736007)(11346002)(64126003)(46003)(53546011)(6506007)(386003)(36756003)(186003)(102836004)(105586002)(81156014)(52116002)(99286004)(81166006)(305945005)(8936002)(7736002)(76176011)(14444005)(106356001)(256004)(486006)(2906002)(39060400002)(476003)(5660300001)(2616005)(446003)(65826007)(31696002)(65806001)(65956001)(31686004)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB5105;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: gimveqvKrDLsj5cXNA1gGV3a+pzj7x8+DfShjEMdseouBowxl4wVfZ+34mjh3eCjAJcspppzppPDo6myrprF05R0wruEcVy0UkY+z6t/HWAyY8ZWiTqC2npX4OkzGV1B6K5pfthTOUQiRklJFyVMuSW6GxES/07CFpOEEJZRc4CmZ77R7ZLxFeV3DHpo3eaPaBRB04kX8xm9m3uY7wY/iFy4Urjicawt2EEYnT+TvKiGWNozvf5QcuFf8zJvdsdvVErxqQjZ6WS/PGx5x6Igk+JCaUwndDde51urQaaJz+Hc0K8F5sGEXhd9qANKAD8DdiPQpSUz+P9cc6jC/RWWd7I4e/X4KQfZ+fOTSnb3IZM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="trhI5r1bciuQHZYPax2g8zjI0dRUzuI3t"
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 400a8a7e-623c-44c0-486d-08d62d7c7ec1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2018 00:16:44.8657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB5105
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--trhI5r1bciuQHZYPax2g8zjI0dRUzuI3t
Content-Type: multipart/mixed; boundary="Kff5LbgbniQKVPFHVT04cdbQ2nYNQYCL6";
 protected-headers="v1"
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: Nicholas D Steeves <nsteeves@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
 Pierre Couderc <pierre@couderc.eu>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <1fa4c752-95e8-967c-7f3a-b7888b74c083@mendix.com>
Subject: Re: merge status of per-chunk degradable check [was Re: Which device
 is missing ?]
References: <700c973f-7ac7-5416-6e15-9e5e4faf9f67@couderc.eu>
 <20181008161055.GB25913@carfax.org.uk>
 <20181009000801.lvyx4uv25wg66a3m@DigitalMercury.dynalias.net>
In-Reply-To: <20181009000801.lvyx4uv25wg66a3m@DigitalMercury.dynalias.net>

--Kff5LbgbniQKVPFHVT04cdbQ2nYNQYCL6
Content-Type: text/plain; charset=windows-1252
Content-Language: en_US
Content-Transfer-Encoding: quoted-printable

On 10/09/2018 02:08 AM, Nicholas D Steeves wrote:
> On Mon, Oct 08, 2018 at 04:10:55PM +0000, Hugo Mills wrote:
>> On Mon, Oct 08, 2018 at 03:49:53PM +0200, Pierre Couderc wrote:
>>> I ma trying to make a "RAID1" with /dev/sda2 ans /dev/sdb (or similar=
).
>>>
>>> But I have stranges status or errors=A0 about "missing devices" and I=

>>> do not understand the current situation :
> [...]
>>    Note that, since the main FS is missing a device, it will probably
>> need to be mounted in degraded mode (-o degraded), and that on kernels=

>> earlier than (IIRC) 4.14, this can only be done *once* without the FS
>> becoming more or less permanently read-only. On recent kernels, it
>> _should_ be OK.
>>
>> *WARNING ENDS*
>=20
> I think this was the patch that addressed this?:
>   https://www.spinics.net/lists/linux-btrfs/msg47283.html
>   https://patchwork.kernel.org/patch/7226931/
>=20
> In my notes it wasn't present in <=3D 4.14.15, but my notes might be
> wrong.  Does this patch resolve the one-shot -o degraded, reboot,
> forever read-only behaviour, or is something else required?  When was
> it merged?  Has it been or will it be backported to 4.14.x?  I'm
> guessing 4.9.x is too far back, but it would be really nice to see it
> there too :-)
>=20
> Also, will this issue be resolved for linux-4.19?  If so I'd like to
> update the Debian btrfs wiki with this good news :-)

[...]

> P.S. Please let me know if you'd prefer for me to shift this
> documentation effort to btrfs.wiki.kernel.org.

Yes, absolutely. This is not specific to how we do things for Debian.
Upstream documentation can help all distros.

--=20
Hans van Kranenburg


--Kff5LbgbniQKVPFHVT04cdbQ2nYNQYCL6--

--trhI5r1bciuQHZYPax2g8zjI0dRUzuI3t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEESWyddwNaG9637koYssHfcmNhX2wFAlu782sACgkQssHfcmNh
X2w3rRAAklis43Ct50LcXs3OqNxRwvCgPEmx5r/Py3mNt30JmalbhSfClNCgxrAx
UL17Jd8+jhPireF0dsLtEu+M85sP3Cc4m11y9MjcgA6zw2Naxzzj0MpKVx4ztlA/
LRj78NONFxcinmDGQA5BPUXNAhGVYpg/JRhpRjVwfz3xPudytKf35OvvJErQ9/lC
cAF0na92MHO0/6kOqzHP19BMEX1UE3nZ019gdPkRX5gK1qeEuDrzf+Y3FiRNqQjh
QgKDJdxOkyWqUMtcXgtFXAzLQKmBihcBwvn4Wq3D+UwAi76gxEZt0o4Y1bU8+dwM
NNwmcYfCG622IEUWMu56A7ioWQsfSvcuxfandZp/sXxIfTgeQc9BRtCo0ZI0Y7Ag
cbQjwuWpGywoIKIJht0tvtXc+wVfte3CbcbMNCoWAtmrkvw6Wzh5fUkeWOF0jmrt
UiUaMAoWePQcmUtx6Wk+1mAohzz6a9FnWfl0v22rj8FLhBo9iJvWw5dG0oJt72VG
x/DZg9/dr7fNCX/9a4sjBVD8xqeQAD8lHV0jS6vN5H160M9PY9jAM0UKRAQPsAsB
EDwZj9yQJjnyLcAcdpttwSSX7cYJM+kXG5GFi4YNUlbKGGxLnfGFfcKUjYEHUyGb
pH+dmFxjO2VbqPekveMt1AlExtFN9bjYsPD4FSMaF7QAZdf8lhY=
=9GoI
-----END PGP SIGNATURE-----

--trhI5r1bciuQHZYPax2g8zjI0dRUzuI3t--
