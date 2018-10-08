Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27D8C65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 13:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8AC020693
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 13:19:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="TwVFCYv+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8AC020693
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbeJHUat (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 16:30:49 -0400
Received: from mail-eopbgr20057.outbound.protection.outlook.com ([40.107.2.57]:58014
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726006AbeJHUat (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 16:30:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBnBbZSjg34lmI50iNWZjUDZssqs/GCmsmPgc0SmYSs=;
 b=TwVFCYv+6zKBdhhuq6jXJ3eAf3AB6A7xY7ktEroge+FiO6ggXAMs0yo7vPTdOFA+eRlnDmVqYXirtv+p2X22UmjsZgdPmi1Z9ejnXYGLREetIoBcqv5gODkM3XXp/9vAYwK9m+9KC+8bH1XXPJCCC5uh/5EDXPhS9pSBHIFKqN4=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB4020.eurprd06.prod.outlook.com (52.133.58.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.28; Mon, 8 Oct 2018 13:19:03 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1207.024; Mon, 8 Oct 2018
 13:19:03 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
Thread-Topic: [PATCH 0/6] Chunk allocator DUP fix and cleanups
Thread-Index: AQHUXCmOSBgrE/nJs0WTXuGELqo9PaUQSCoAgABVpoCABE5AgIAAbogA
Date:   Mon, 8 Oct 2018 13:19:03 +0000
Message-ID: <3f82acbe-5b66-1a00-880f-645883a581df@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <10a9b7c4-861d-c6f6-b17b-56fa7a5ba5b8@gmx.com>
 <a75d50c8-fb1a-8dc5-80c8-77acc7c4e4d0@mendix.com>
 <b6bb9348-1cb3-4870-4a6b-8758c1250290@gmx.com>
In-Reply-To: <b6bb9348-1cb3-4870-4a6b-8758c1250290@gmx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [85.146.242.35]
x-clientproxiedby: VI1PR0102CA0010.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::23) To AM0PR06MB3921.eurprd06.prod.outlook.com
 (2603:10a6:208:b2::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB4020;6:nEYePYZYLSgoVBYs2k7FYjqeZl8JbT7VAu2ArZql5f+vws452VijApw343ii9S9ymBTlZ7yG0kwkisiD8RIZxq0yiiZli06dLH+jNIA/ncc+sCNWeBSqFDdM/HX+N8pGjvx4EVIfQ0bYsPY2ze4vJFkGSEOco41tq+cUwhkq/EwyeAqAIy2Mg2ss4FzhHm/0mBKPT20cTMtQ867H5n2+ocH8ZT39V6s+IH1wlnUika3klb/k7ESwjavLlflXSluHaEL28ivhL1cZWaxIwNXFKVuUBmwpQs1ek6gwDxtezVvxPSIGz6+/KBnUi09nLnpHzJGUC+/bOOi8Gp5dO2ukbv3TXUs2uhXm1u0Jko3nMlJI3ML6bJUkeHVOWEKzqP3idGvUMDON4nFfAUj9OCPiJJlP1Vl7FBK0VgYc9lXak6AdNw+6Ap5581BHTxzfb0+3fOcXy4+6Jovkeb4yNsQZIA==;5:sfbTFG1ggx22JFHmJ/T1tHhQMuTaQ6arHSOqIyOqcQo4XNd1b8UUVSyIe8aYEPtu6L8XZM1ynam8wNJw38dmjdBsaUtaRT2Cnf9l1dHW59dI9uymrSGDl8cTN+tCjDM+QVgu49bgnOWZCK+EZMYFNohn2llDVJomcKsyHNokcj8=;7:OT84L8tvjB+1nLv5gGKx1qzftQBoAiz+G7Utsf9lukMhkVfbFXOm7ICarA/UUbgWgzIsFHfSczqRkMYUrg2NjgQqr3ipQGwKZ+RTWnIFReRXMCnMd6vcRHu3GPfR8qLai1Vp8vbawIawU3k4ueQjC2QKVR3DPvMmHh0cwrKYn/bCEWuI+LxCwW/ZU47FWSn1nwNdeSFAwMBo7bTRUcJUECzj4gxYnsRXyadsLbz7v57d/HsSwhyuwZ8vgd/wFKdA
x-ms-office365-filtering-correlation-id: 2b2c18be-57c2-41ed-79eb-08d62d209dd0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(49563074)(7193020);SRVR:AM0PR06MB4020;
x-ms-traffictypediagnostic: AM0PR06MB4020:
x-microsoft-antispam-prvs: <AM0PR06MB402044CEC8E8DE520B805CECD4E60@AM0PR06MB4020.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(102415395)(6040522)(2401047)(5005006)(8121501046)(10201501046)(93006095)(93001095)(3002001)(3231355)(944501410)(4983020)(52105095)(149066)(150057)(6041310)(20161123564045)(20161123558120)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:AM0PR06MB4020;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB4020;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(376002)(39850400004)(396003)(199004)(189003)(68736007)(99286004)(486006)(7736002)(52116002)(305945005)(229853002)(476003)(36756003)(316002)(93886005)(53546011)(386003)(6506007)(446003)(71200400001)(86362001)(2616005)(106356001)(97736004)(8676002)(2501003)(31686004)(53936002)(105586002)(5250100002)(71190400001)(31696002)(65956001)(102836004)(66066001)(65806001)(65826007)(186003)(72206003)(478600001)(64126003)(25786009)(3846002)(6512007)(2900100001)(6486002)(6116002)(6306002)(26005)(58126008)(110136005)(6436002)(99936001)(76176011)(2906002)(11346002)(14454004)(5660300001)(256004)(966005)(81166006)(6246003)(8936002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB4020;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 4AsMD6t2b7cCZlQjiZv5gMk5SbD70DA60k1YKmNFNf0w79extHHqm/QcBrWP9o2w21T9fEGrV2z98I0rv2o4fXl26Ango2VOYgsa16Ibpx042LGsKLHzJYGY0KaNrlceXiubTw7Eh/wyIQB0eV+qDFNus0cCHdLVjMuadkPPyFZlJYIv1Lr19b9dU8yMqLL7yIzSMfKfHtikGEGQOXygMtKACs8NPm5iAs1JaCnladDBH1GE+AyMlWt/pwB9sEcGvXsdtxPGzcpTAM9hOM+pKIdkQvKUnreWKCQ5bnMm6mspSIGiolk8x4Yw4vOpOCPuyOttA2bmX51t2rp4ezHq23vHClZT1RLubk15lK4mHzE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="IpVMzPg2vxI6Gz9GlKr7AThY4SZozRFZn"
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b2c18be-57c2-41ed-79eb-08d62d209dd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 13:19:03.4726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4020
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--IpVMzPg2vxI6Gz9GlKr7AThY4SZozRFZn
Content-Type: multipart/mixed; boundary="TFgRlfVXHazIX4Z3d1ddmU3arcmpzPqwE";
 protected-headers="v1"
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <3f82acbe-5b66-1a00-880f-645883a581df@mendix.com>
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <10a9b7c4-861d-c6f6-b17b-56fa7a5ba5b8@gmx.com>
 <a75d50c8-fb1a-8dc5-80c8-77acc7c4e4d0@mendix.com>
 <b6bb9348-1cb3-4870-4a6b-8758c1250290@gmx.com>
In-Reply-To: <b6bb9348-1cb3-4870-4a6b-8758c1250290@gmx.com>

--TFgRlfVXHazIX4Z3d1ddmU3arcmpzPqwE
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: quoted-printable

On 10/08/2018 08:43 AM, Qu Wenruo wrote:
>=20
>=20
> On 2018/10/5 =E4=B8=8B=E5=8D=886:58, Hans van Kranenburg wrote:
>> On 10/05/2018 09:51 AM, Qu Wenruo wrote:
>>>
>>>
>>> On 2018/10/5 =E4=B8=8A=E5=8D=885:24, Hans van Kranenburg wrote:
>>>> This patch set contains an additional fix for a newly exposed bug af=
ter
>>>> the previous attempt to fix a chunk allocator bug for new DUP chunks=
:
>>>>
>>>> https://lore.kernel.org/linux-btrfs/782f6000-30c0-0085-abd2-74ec5827=
c903@mendix.com/T/#m609ccb5d32998e8ba5cfa9901c1ab56a38a6f374
>>>
>>> For that bug, did you succeeded in reproducing the bug?
>>
>> Yes, open the above link and scroll to "Steps to reproduce".
>=20
> That's beyond device boundary one. Also reproduced here.
> And hand-crafted a super small image as test case for btrfs-progs.
>=20
> But I'm a little curious about the dev extent overlapping case.
> Have you got one?

Ah ok, I see. No, I didn't do that yet.

By using unmodified tooling, I think this can be done by a combination
of a few resizings and using very specific balance to cause a fs of
exactly 7880MiB again with a single 1578MiB gap inside...

I'll try later today to see if I can come up with a recipe for this.

--=20
Hans van Kranenburg


--TFgRlfVXHazIX4Z3d1ddmU3arcmpzPqwE--

--IpVMzPg2vxI6Gz9GlKr7AThY4SZozRFZn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEESWyddwNaG9637koYssHfcmNhX2wFAlu7WUUACgkQssHfcmNh
X2yQAA/+Jo/reutlEoqQN+y61Ny3XhhHSlHm6ekpHjbBrIeVQNmX0tygZWZ8M/1o
JyGk3WKN6Vd89cN/nEwRS5p+gEspICNhVIQSK9YfbVJxdhD7UH8decPNiRrK8s3l
6U5kvW0vQqEq1c+lTQbY9IPXOMkIa+rcAeAt08H9Wylt1l25P7uQZewX+Bb4YxkH
WAP10g7+xBgshjufMauoOEyz7T6xaOh06HeLQwqUrGm4CvsnaTsD+9RBw0g/zq3a
lxavtpAGxebBSzW+ZyZarC7nA7PJAUEtg1GDVXACIj+MgprtdEns1P4aJfGOa1UG
MqL+dnIjtBghnuLc6fVs0LNXvtomR91m8Ga92e97bpygS+/N+OkHduftlUlPc27D
f90nvML7zNnOZfI/7Fo0VXCm8iAha4dZMqJR9j7/OKPgXpFTGqaGYD1036Ly8r4E
LOGsZ4yzzozKURw9/AIdiaIBxdynL9oKJDUv3XsxtjYuIxfTZPs2rNImqFin3H6P
80JFPXpp0zGCcHgRD75gTbrvZFfxLH7jbOaEEjtUv3k7pNxLP7gooxTW3X6dBtTP
Jm87wPfVXbwUXPKDbScdiELWuLNn83X363nrsAfatRcwV+mGSxDmNmf4ywA/1NQ1
yTpsTFj+F6wTV2nLiTa6LmHt7l8Zx5xDxYOErV+ACDMiZ+PQP2Y=
=z2Hg
-----END PGP SIGNATURE-----

--IpVMzPg2vxI6Gz9GlKr7AThY4SZozRFZn--
