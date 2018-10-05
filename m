Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F6CC00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 10:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9ED82064E
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 10:58:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="NkWFZZWE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9ED82064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbeJER4l (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:56:41 -0400
Received: from mail-ve1eur01on0070.outbound.protection.outlook.com ([104.47.1.70]:49024
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727714AbeJER4k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 13:56:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjB0uT0G5jGj7/ljtsG0Y6X7enyUv749enSAnU/VrI4=;
 b=NkWFZZWEdtCohD8FBhTz1oSjwglzorSU3YsYLmxTCRnOVATUUq8+RAUXiijKL3HSIkB15fhgg7DmWOaPTASBS28Pi7Gf+YqBGKiiITrDXCcOo3TK8wWeJcSB4h2mRKIYEFt4ZrGLLo8e3pxIyGxYYmuDljk6IzsiqM3gv8YFuvw=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB4593.eurprd06.prod.outlook.com (20.178.18.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.26; Fri, 5 Oct 2018 10:58:20 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1164.029; Fri, 5 Oct 2018
 10:58:20 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
Thread-Topic: [PATCH 0/6] Chunk allocator DUP fix and cleanups
Thread-Index: AQHUXCmOSBgrE/nJs0WTXuGELqo9PaUQSCoAgAA0H4A=
Date:   Fri, 5 Oct 2018 10:58:19 +0000
Message-ID: <a75d50c8-fb1a-8dc5-80c8-77acc7c4e4d0@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <10a9b7c4-861d-c6f6-b17b-56fa7a5ba5b8@gmx.com>
In-Reply-To: <10a9b7c4-861d-c6f6-b17b-56fa7a5ba5b8@gmx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: HE1P189CA0007.EURP189.PROD.OUTLOOK.COM (2603:10a6:7:53::20)
 To AM0PR06MB3921.eurprd06.prod.outlook.com (2603:10a6:208:b2::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB4593;6:cylKxlfaOU1AsEpDKl9eJ0o3DHg5BXkBUAvlrNASPnNMap1+C1oTCioERZYVlPv5L2ATeBphKpvkOW7DgsZEeoE7U5KBlhFX3R0hdDLu4IUjHyKnRwMW+cOYlZYNPhz5OVlVQdckIxCE63DbIEXcVo9hOq+n/2IZpchAmLWXpPJJijul/5VZBuapY88OXuJsHn5XImpdu112aofw+tx5jHhI21rrj7MNz0Nrt3WDw4z1XsC2nlZd4m2emCZuRt+ux3Xz0ttOBogXNsMEi0RfAvniiExpYS/isqhfb1DIIPCoynDqNUB5x+vM/qCLEP524KRytaSuARVH79LA0ziUR3vztr23+T6Df0B/WtBE/8Zy+tOJGMfW4cw/7NsjCz19xF339mavQxZ1/yS2xP27qMYPwGft+p6H4OOYdogrMhCFROeIQwnujVkWMA8jc2ppwHBb+3eLh4P5o+qpcgj45Q==;5:RM/4r39ZVl+AmCaKpqSJy+oN1neWDoXuOOa9KvN+wl5+asgP+aqRN46EA1Qh+E/bxf29WCjcE4/H51xPzoj3ypZd4AJEKf+AXrR2bPYFDWdczoWNNouX7q+hqEh74+skjUPD11FUSJWr5J4KW+23r5qejbE/HCkG6T8U439AJcM=;7:bnnPXdD+X3cJJhfqdM822fYixgPg9Dmuf9E1glZNUWNSSQBXotxmlTOfmJwEKzY4TEdgvtTXu640cdZbEeSuosTpD+zaQqQWCZp2Yl107woSCc4m985IO02AIdNOtq5uHbBsfpi0rF50whsqINbhCkMR+ctU/eG6t+f5XEyM0vH1cSVNz9N+6q2vFnf0iv8FsTYcOUXZ6pquaUR5g1YhfetaD3EO4J6Nj0SQYq0qeQyPNnOShaWyIZFzibSYwoQF
x-ms-office365-filtering-correlation-id: b4c93b9d-9889-497f-832e-08d62ab175e6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(49563074)(7193020);SRVR:AM0PR06MB4593;
x-ms-traffictypediagnostic: AM0PR06MB4593:
x-microsoft-antispam-prvs: <AM0PR06MB4593525C616D4FB3CB4C8074D4EB0@AM0PR06MB4593.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(271806183753584);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(102415395)(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(4983020)(52105095)(10201501046)(93006095)(93001095)(3002001)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123560045)(20161123564045)(20161123562045)(201708071742011)(7699051);SRVR:AM0PR06MB4593;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB4593;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(346002)(366004)(136003)(376002)(199004)(189003)(64126003)(6116002)(65826007)(110136005)(966005)(105586002)(316002)(2501003)(478600001)(5250100002)(58126008)(72206003)(2906002)(305945005)(7736002)(53546011)(386003)(52116002)(6506007)(99286004)(106356001)(6512007)(6306002)(31686004)(53936002)(76176011)(68736007)(2900100001)(14454004)(229853002)(5660300001)(8676002)(81156014)(81166006)(36756003)(8936002)(65956001)(65806001)(6436002)(6486002)(446003)(11346002)(46003)(31696002)(2616005)(256004)(476003)(14444005)(25786009)(6246003)(186003)(71190400001)(486006)(97736004)(99936001)(71200400001)(102836004)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB4593;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: pp68grD70lG0jofJjAkRQka3D4yJ28kqlkenlzcHNoMtCC5cRTRce8Vb/4UQZZNQF+JiR1ZgMaSi2kmXfbS/zspDnUrWlhHAvvBlLHpDpza8RF0ZeZGEc8qbpIdJrh+80jmvynLhyuq/siEa2SwMNZhlaUd8//G/ZUnSn769KdXn4MrvzeZ8jA1SgzezSaMxUNWnz15mIHWfjk5va3cAs5qHKoDk1J0YXwkqVbV8mfbwELEFgvFSssdxY9Q6gKmyho3/S2hdc17ndWf64rO5HOyuXITlRpB/inFo7FUbTfVeDa+NbCmjRv5MmDLKF0+SF8IRWOP/LdpKv8woymv8LgT6CzGIsijMLvkDVSm8Vcw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="eVLuhmhfNXwnrrrQmABvU9SRwoZYIcf2D"
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c93b9d-9889-497f-832e-08d62ab175e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:58:19.9810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4593
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--eVLuhmhfNXwnrrrQmABvU9SRwoZYIcf2D
Content-Type: multipart/mixed; boundary="faC2ZN3vridGElYaKHQ8OSClhZIKuJTRD";
 protected-headers="v1"
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <a75d50c8-fb1a-8dc5-80c8-77acc7c4e4d0@mendix.com>
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <10a9b7c4-861d-c6f6-b17b-56fa7a5ba5b8@gmx.com>
In-Reply-To: <10a9b7c4-861d-c6f6-b17b-56fa7a5ba5b8@gmx.com>

--faC2ZN3vridGElYaKHQ8OSClhZIKuJTRD
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: quoted-printable

On 10/05/2018 09:51 AM, Qu Wenruo wrote:
>=20
>=20
> On 2018/10/5 =E4=B8=8A=E5=8D=885:24, Hans van Kranenburg wrote:
>> This patch set contains an additional fix for a newly exposed bug afte=
r
>> the previous attempt to fix a chunk allocator bug for new DUP chunks:
>>
>> https://lore.kernel.org/linux-btrfs/782f6000-30c0-0085-abd2-74ec5827c9=
03@mendix.com/T/#m609ccb5d32998e8ba5cfa9901c1ab56a38a6f374
>=20
> For that bug, did you succeeded in reproducing the bug?

Yes, open the above link and scroll to "Steps to reproduce".

o/

> I'm adding dev extent overlap checking in btrfs_verify_dev_extents() an=
d
> btrfs-progs.
> I think it could help to detect such problem.
>=20
> Thanks,
> Qu
>=20
>>
>> The DUP fix is "fix more DUP stripe size handling". I did that one
>> before starting to change more things so it can be applied to earlier
>> LTS kernels.
>>
>> Besides that patch, which is fixing the bug in a way that is least
>> intrusive, I added a bunch of other patches to help getting the chunk
>> allocator code in a state that is a bit less error-prone and
>> bug-attracting.
>>
>> When running this and trying the reproduction scenario, I can now see
>> that the created DUP device extent is 827326464 bytes long, which is
>> good.
>>
>> I wrote and tested this on top of linus 4.19-rc5. I still need to crea=
te
>> a list of related use cases and test more things to at least walk
>> through a bunch of obvious use cases to see if there's nothing explodi=
ng
>> too quickly with these changes. However, I'm quite confident about it,=

>> so I'm sharing all of it already.
>>
>> Any feedback and review is appreciated. Be gentle and keep in mind tha=
t
>> I'm still very much in a learning stage regarding kernel development.
>>
>> The stable patches handling workflow is not 100% clear to me yet. I
>> guess I have to add a Fixes: in the DUP patch which points to the
>> previous commit 92e222df7b.
>>
>> Moo!,
>> Knorrie
>>
>> Hans van Kranenburg (6):
>>   btrfs: alloc_chunk: do not refurbish num_bytes
>>   btrfs: alloc_chunk: improve chunk size variable name
>>   btrfs: alloc_chunk: fix more DUP stripe size handling
>>   btrfs: fix ncopies raid_attr for RAID56
>>   btrfs: introduce nparity raid_attr
>>   btrfs: alloc_chunk: rework chunk/stripe calculations
>>
>>  fs/btrfs/volumes.c | 84 +++++++++++++++++++++++----------------------=
-
>>  fs/btrfs/volumes.h |  4 ++-
>>  2 files changed, 45 insertions(+), 43 deletions(-)
>>
>=20


--=20
Hans van Kranenburg


--faC2ZN3vridGElYaKHQ8OSClhZIKuJTRD--

--eVLuhmhfNXwnrrrQmABvU9SRwoZYIcf2D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEESWyddwNaG9637koYssHfcmNhX2wFAlu3Q8kACgkQssHfcmNh
X2zsHQ//STskNGA0pgFTOOx5vCa0SocP3ZjyllziaHSxCzhExzG+MxNoQ2RunB/o
6L0tQiegNMCtos9VleEq9oR7LuTzYio2fZA33f4CapHOPxtc9mNiXv9snDI1sSJS
s/SgcbIcEtNFmW43y+6auTEIKMejrolxl6W5CvntkhugxjZSncRtygaWOBZcyV3w
jR4ZEAJiKtADZB30zdIDcY8bdipCw3FsOJX3PM+dUYlw59PQhyo130K2mIsf6FPP
EQ2T+Irjzg+9ZvGGcyH3ikG0jxRGYdYXVogoi+k8jlwtu9++zk2VGg4f1C3l1Ccs
CbqLIhcoreMyLnLN3rPalrtc3S/QNEuPQfWhdG+uNPrTQ8FeTXOQqiDWypWqVp+s
XNaL9iRvu8N1rcvpxa8+hbyH/5F+8Z3cxvddCiUDqDbEToULpdDueJaWSsdWfFJz
bMXsGwQlHNM6sCG0gBNMq9HrGtouOX0nwdKY5dMaRrVgvq1e3gKTF9kQDmyxng1g
FF4c5Qz8GzJYvGmzTHznmZ5XJATRRNyX2tS5TIoiwsTc9W2hImKp3jrxc1yTUXVN
sGq8BN5lswZClqM8AzSNiba/brAqGNz7fohDL6MNzygpF0s9iUOFhUjGOnISqyn4
GIu+P+SQOwXQ/CwsUL9WDCX4iRq/72/e5SEoNGyp2QOZFnlq0Xo=
=XSuh
-----END PGP SIGNATURE-----

--eVLuhmhfNXwnrrrQmABvU9SRwoZYIcf2D--
