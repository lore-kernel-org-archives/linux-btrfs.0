Return-Path: <SRS0=eQkg=OK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E016C64EB4
	for <linux-btrfs@archiver.kernel.org>; Sat,  1 Dec 2018 03:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D210C20868
	for <linux-btrfs@archiver.kernel.org>; Sat,  1 Dec 2018 03:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="IQ8/CxYJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D210C20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbeLAONs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 1 Dec 2018 09:13:48 -0500
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:8496
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726139AbeLAONr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 1 Dec 2018 09:13:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUbuHCx9G9eRt9N2St008PXNQRuugcdU2iu6J0Anagw=;
 b=IQ8/CxYJwIkQTwTT0BotowI/fytPEsgcAgL+Ln226Cz8PtaCdzo0ngqX4amTWTQbs85MYXrepIE2cbsFOI3GC3VBrlFbLKdIZ5XsCB/Vkl5rZaqOlrwp+qKa7891GvnNjp0OH5ba7BDlzZHUTvz0bVQosIMBDIf5CDcjwkzFNDU=
Received: from DB7PR06MB4680.eurprd06.prod.outlook.com (20.177.122.217) by
 DB7PR06MB4476.eurprd06.prod.outlook.com (20.176.236.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.18; Sat, 1 Dec 2018 03:02:16 +0000
Received: from DB7PR06MB4680.eurprd06.prod.outlook.com
 ([fe80::188a:a5b1:632c:ecc]) by DB7PR06MB4680.eurprd06.prod.outlook.com
 ([fe80::188a:a5b1:632c:ecc%2]) with mapi id 15.20.1361.022; Sat, 1 Dec 2018
 03:02:16 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
CC:     Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/2] btrfs: catch cow on deleting snapshots
Thread-Topic: [PATCH 1/2] btrfs: catch cow on deleting snapshots
Thread-Index: AQHUiM0QrGfG+4HowkC4EivZvDuHsKVpBX8AgAAtY4A=
Date:   Sat, 1 Dec 2018 03:02:16 +0000
Message-ID: <d2bfbcb4-4ca2-9dad-19b3-7ae1c6329d84@mendix.com>
References: <20181130165214.17883-1-josef@toxicpanda.com>
 <20181130165214.17883-2-josef@toxicpanda.com>
 <4a9577f2-9c3b-eb9e-a6a5-b3878769cd2e@gmx.com>
In-Reply-To: <4a9577f2-9c3b-eb9e-a6a5-b3878769cd2e@gmx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM6PR03CA0006.eurprd03.prod.outlook.com (2603:10a6:20b::19)
 To DB7PR06MB4680.eurprd06.prod.outlook.com (2603:10a6:10:53::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB7PR06MB4476;6:iWabtDQbeJ3pgDkkis6gcwRa7M0mxqZu05LgTfWXIbMJSuBatB88B+llnVjnvVRVt90FXgmWYS+V3OVIBxIIzpSKsXVkF9tEgFm+ZSPy4UlTr0hNyjwiTq8/0n3XTCHZPRtx2of7PfH8yhyxKRuS7MXDIdpds4IoE1Sm5zytcJqE7Hwxu4uSxYFc9gxxMZddDueWZbQ15noRvBopPBFRosiCwkcwZWrS4pucX/TCP+nSmrXBvd4MnVIRWL2WCrognNG3l4G8DrU/yKj2M9s8cY6vICiWvzSng0jKYpS4d18MkWMLCJ/emvS7Gqg7JtClWOPsD4Zv1Btr3mDZ1MgR20bHaEnf8YlbEHDyZPss309WOhE8jVdxQyzAEjmuv4pbFR12RO5/xyyjXPWUa6nIqDGsZe6R/Up9tK5M9b6889Ce+V4SZMPH88ZVCGrXffIFVqecRKAVPBdSqYupTtBV/g==;5:jtMsIZ9FJ7BE9zYLvbQR7ksaDjB54qQgcY5Eip6B6JQsk+t95srzIyRxe631NMQ+yVJsaB3u+5pK1MyoMX2h6M517EAX+GfBhgGhMlyGSsgKSzLmL44/OXi30AuNznYwrTBlzWvR6PY4IU04cmKtQ8zifVEW1XC6Qo4Ckou5iVA=;7:MUCkxIqUS5y4M2LGRLbPqMeSg6vaDHM2QoTAR51VA51AVuqk7fawAylmRsREISd6MqNEEb33uELeruRfZvCpm/zWy4YpT0gimv69Wb+yubUSw88ZuLy5i1sd6UyeIV6H0ovxSdt+r5enUbKeok4w5Q==
x-ms-office365-filtering-correlation-id: ac8cfed7-4b71-4fe4-c87c-08d65739665e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(49563074)(7193020);SRVR:DB7PR06MB4476;
x-ms-traffictypediagnostic: DB7PR06MB4476:
x-microsoft-antispam-prvs: <DB7PR06MB447602F204E4ED6A874D9920D4AC0@DB7PR06MB4476.eurprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(102415395)(6040522)(2401047)(8121501046)(5005006)(3002001)(3231454)(999002)(944501471)(4983020)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DB7PR06MB4476;BCL:0;PCL:0;RULEID:;SRVR:DB7PR06MB4476;
x-forefront-prvs: 087396016C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(46003)(71200400001)(72206003)(71190400001)(11346002)(446003)(36756003)(966005)(99936001)(68736007)(2906002)(551934003)(7736002)(6116002)(305945005)(478600001)(76176011)(8936002)(65826007)(5660300001)(6512007)(6306002)(53936002)(31686004)(99286004)(4326008)(8676002)(81156014)(81166006)(64126003)(52116002)(229853002)(102836004)(106356001)(65806001)(186003)(53546011)(6246003)(6506007)(386003)(65956001)(14454004)(6486002)(105586002)(2616005)(476003)(97736004)(110136005)(58126008)(25786009)(316002)(86362001)(575784001)(2201001)(2501003)(31696002)(14444005)(486006)(256004)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR06MB4476;H:DB7PR06MB4680.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: snS+k4snk5QdLjGKK9ZfHJXSN/q6iEJe0S4oNOFtDmZRfXSvLnbUXYlu03edtGGyVQvh/KEPVMur++UFT/4g9R+KcTiIMnfYhii1lDqUmki2FN5PSAwe4M70DGFaxcQUSQjYTIfus6vUFEE82U9db2qaeXbI0DVvsbm7S8pgZgcafXKYMP3jpgxSTjhEzcmx9m645URf4/5CA5gsI8+5y6+/MB9o4x3BFwwADBklxilsqK6l2tLis5mQGjIvKgchngDIt10NcEOksH8wJcKSDfF0kelG6hxchFjEVJ6PyHl3cyzmlpyEeXGGllXIuXobzkC17OI64y6IPCWbi6rAfTlNRY9+tfjFmPN2zzLVpXY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="9tJGjFePi3mnqG15ctXjaLRKm5jvRhJ9U"
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac8cfed7-4b71-4fe4-c87c-08d65739665e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2018 03:02:16.4244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR06MB4476
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--9tJGjFePi3mnqG15ctXjaLRKm5jvRhJ9U
Content-Type: multipart/mixed; boundary="mo9Uo7gZinJgK1tOqhXiksrEkuURcvb0d";
 protected-headers="v1"
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Josef Bacik <josef@toxicpanda.com>,
 linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Message-ID: <d2bfbcb4-4ca2-9dad-19b3-7ae1c6329d84@mendix.com>
Subject: Re: [PATCH 1/2] btrfs: catch cow on deleting snapshots
References: <20181130165214.17883-1-josef@toxicpanda.com>
 <20181130165214.17883-2-josef@toxicpanda.com>
 <4a9577f2-9c3b-eb9e-a6a5-b3878769cd2e@gmx.com>
In-Reply-To: <4a9577f2-9c3b-eb9e-a6a5-b3878769cd2e@gmx.com>

--mo9Uo7gZinJgK1tOqhXiksrEkuURcvb0d
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: quoted-printable

On 12/1/18 1:19 AM, Qu Wenruo wrote:
>=20
>=20
> On 2018/12/1 =E4=B8=8A=E5=8D=8812:52, Josef Bacik wrote:
>> From: Josef Bacik <jbacik@fb.com>
>>
>> When debugging some weird extent reference bug I suspected that we wer=
e
>> changing a snapshot while we were deleting it, which could explain my
>> bug.
>=20
> May I ask under which case we're going to modify an unlinked snapshot?
>=20
> Maybe metadata relocation?

I have some old logging from a filesystem that got corrupted when doing
a subvolume delete while doing metadata balance:

https://syrinx.knorrie.org/~knorrie/btrfs/domokun-balance-skinny-lockup.t=
xt

This is one of the very few moments when I really lost a btrfs
filesystem and had to mkfs again to move on.

I'm wondering if this one looks related. I never found an explanation
for it.

Hans

>=20
> Thanks,
> Qu
>=20
>> This was indeed what was happening, and this patch helped me
>> verify my theory.  It is never correct to modify the snapshot once it'=
s
>> being deleted, so mark the root when we are deleting it and make sure =
we
>> complain about it when it happens.
>>
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> ---
>>  fs/btrfs/ctree.c       | 3 +++
>>  fs/btrfs/ctree.h       | 1 +
>>  fs/btrfs/extent-tree.c | 9 +++++++++
>>  3 files changed, 13 insertions(+)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index 5912a97b07a6..5f82f86085e8 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -1440,6 +1440,9 @@ noinline int btrfs_cow_block(struct btrfs_trans_=
handle *trans,
>>  	u64 search_start;
>>  	int ret;
>> =20
>> +	if (test_bit(BTRFS_ROOT_DELETING, &root->state))
>> +		WARN(1, KERN_CRIT "cow'ing blocks on a fs root thats being dropped\=
n");
>> +
>>  	if (trans->transaction !=3D fs_info->running_transaction)
>>  		WARN(1, KERN_CRIT "trans %llu running %llu\n",
>>  		       trans->transid,
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index facde70c15ed..5a3a94ccb65c 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1199,6 +1199,7 @@ enum {
>>  	BTRFS_ROOT_FORCE_COW,
>>  	BTRFS_ROOT_MULTI_LOG_TASKS,
>>  	BTRFS_ROOT_DIRTY,
>> +	BTRFS_ROOT_DELETING,
>>  };
>> =20
>>  /*
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 581c2a0b2945..dcb699dd57f3 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -9333,6 +9333,15 @@ int btrfs_drop_snapshot(struct btrfs_root *root=
,
>>  	if (block_rsv)
>>  		trans->block_rsv =3D block_rsv;
>> =20
>> +	/*
>> +	 * This will help us catch people modifying the fs tree while we're
>> +	 * dropping it.  It is unsafe to mess with the fs tree while it's be=
ing
>> +	 * dropped as we unlock the root node and parent nodes as we walk do=
wn
>> +	 * the tree, assuming nothing will change.  If something does change=

>> +	 * then we'll have stale information and drop references to blocks w=
e've
>> +	 * already dropped.
>> +	 */
>> +	set_bit(BTRFS_ROOT_DELETING, &root->state);
>>  	if (btrfs_disk_key_objectid(&root_item->drop_progress) =3D=3D 0) {
>>  		level =3D btrfs_header_level(root->node);
>>  		path->nodes[level] =3D btrfs_lock_root_node(root);
>>
>=20


--=20
Hans van Kranenburg


--mo9Uo7gZinJgK1tOqhXiksrEkuURcvb0d--

--9tJGjFePi3mnqG15ctXjaLRKm5jvRhJ9U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEESWyddwNaG9637koYssHfcmNhX2wFAlwB+bYACgkQssHfcmNh
X2zZCBAAhMlpKYZWxkkdHHnV85kM/0LuEw7ATqCPba5sHR8K8MJmsifT8t7zSI0e
jdAXOtnlGWJAzDN75179A1Sqv0NxXfx39B1DCgl9Ggr8Ekjyf/wqXcNpR+y7cpf9
2FHUazPvPRk2j8fXiRt0d8gX+Pp58ww9hWN7iOkE1jUO/j0J8As2NI7CvHRCf+bF
dSMoIXzYka5ajHwICc7X5AEGBoJit7n+IJqambhif77dMvDH6qW9yTc+rvSTGqVy
fSnYY6gtJOuIzQEJjnmk3gpi+r9VspAqsSuOGwfJpck+1HmDx6MVos1yrrk63kz3
hyzYQvgGf+brHsxXnQqJKFU+gSaP01tWITKuJ3wOM9tNq47N77ZLMRZsLPQrruuq
uzpsLM4fE02WeWPHBBhWZyIfNTBltDf5xAgVkeKe2TYtFztsHos9CjkeAsW2O9kh
IBzeftc6Luo2eJPewNDsbG7Ev/Vw9275isOiF2eLF3nFHlVhjOmcovWT+A1akNgs
nvqAFZnIzKj95ubcwNLSyp9p7lCSCYJ3Mb7MQ4ibHP7xK2nb8BDffY6zz0xJAQs9
Zm0B3xWfDaoJTTp6WTVOi3yNOAlhsvN7CT6LkkcRmwPx82HwwA807TN+TlO1Zx8I
wwM6h3VGo+ACdwX5ZxG8tbF0CgeyIXH3C7zft9kFaiQim/gUjGo=
=N5jh
-----END PGP SIGNATURE-----

--9tJGjFePi3mnqG15ctXjaLRKm5jvRhJ9U--
