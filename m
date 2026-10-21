Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792593999;
	b=HWYf0wYJ4hdXfHkrjVkF8JW5X6pZ8Mcpem956llFtRunAHndG9doEtKZ/2ug8LRbqlJj
	 P0QCiVUNkAX8rbJr6/3LSCW8J6icR5W4KdXDTeai35HvQClNI16A/MX+MlysNasUb4pEU
	 UD/GfQTRttijFoM3umT+FZrnvH6hUevMAfLX8SH79pQPG+W+dJtgxiH/FAKDG5ri644lv
	 q630H0Vx7qx2TuKMiGOW/ih8aLQ8K34CWaSPR7jmXEpVH4MzyJvCI54wAZNy1FJ+99iKn
	 F7da3YUhmsZPgKbmXWKFIj0Ag4HBmkDSFZqh/4URleoKdUbosn7M6yLH9oC+52/MnPg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593999;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Importance:X-Priority:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=bXxcMCOClewY+JS4syQvbfsTfPnQ3P1sGVwMoZQ6c6M=;
	b=Rj3zZ7wigFEW8m1LVTk1ZxikHb2jv4ybS1Jb9IeevbKHfCpZ1tNfiYZkdHWeprYFKsKf
	 ha8WtaegrpgwODMHD5kM4SMkm6U/pReE59GJxput3+bYTMGm7Yfik+a2xLpS6iVk4dx77
	 Tab1EkZZTCgSDFQFT0Mwz7cnS8/AOud/bq4ARsPJKaVMyEhzIKlseFUZXOP8QABAL+xBR
	 lSxrkFu1eurz2VkWM/YiiCIneRihON6yYqszh9Q+yxVk4n0IJyvqMDEUzjZYCCAOqawIx
	 lYLS+6ZpQvlyj0fTpu105OjiBNakHcPBWVN9gk31vQmFFep5ibuXE9wQmUp9WszHqDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=eaton.com;
	spf=pass smtp.mailfrom=eaton.com;
	dkim=pass header.d=eaton.com header.i=@eaton.com header.a=rsa-sha256 header.s=selector2 header.b=4ZGdeIeC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.43
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012043.outbound.protection.outlook.com [40.93.195.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D59E606A31B;
	Wed, 21 Oct 2026 14:46:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D59E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=eaton.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eaton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=eaton.com header.i=@eaton.com header.a=rsa-sha256 header.s=selector2 header.b=4ZGdeIeC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zFHrQpmzD+VnTpy0yD6aVYUxtUSQlwjK79MTY+S20pvuiCX3JynJrR4mYtamAVsL0r+YTXoBflGOrvvZSIrKHIrglDknrpMpmf21CvT64AIOwGIky41UTnbMM1ZRtkGMhaT+PGIQR+av47lhqHH7uBoKS2BuzP+TBlJVdNWTY3TylTcjQmCL2ezYzhd/RSBURJcifxquacP0ZRRXsqSj7xXgkKk4V1NyEtE5kY6495IXBuoeMV2B3aI4oBjJlww49MAXBK8Mp0M+1XYfpyFcfjAO+qCGpGgkL0J2cBMEQprNxrsjRFqV1fjMD0vWn9i812Pv2vX+2hg4sy/lyxtteg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXxcMCOClewY+JS4syQvbfsTfPnQ3P1sGVwMoZQ6c6M=;
 b=Be/Flgf8254KdzV5r7YJym/RXUHIs3tOcNxUbcce03GfZpTmliDtOKwAjlCBivuPClGBXr5XhEUcv67TN20FE9ma2eoTGR1riO5ejdikrWMSTfioIkfSA3y9LoUPigCllJv+pCZlVZZgBhab2ONwt7+spe4GGAocmKf+QJehAddHdXo68n7SpqEt3wRjckyUSslG22tZHcLExjlOO/Ca0vJOy6Je61jcmHCP1qXjMsxJgF1CIYsX/VGGkrSk8aAhO0XUk2a+LWWwONh7pOl1CGhlJYaXnkv2Ecy05ewEH4/+USkY51sK6mFcySE/9fwMnX8yU9KpIl5egAHlBN+rBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXxcMCOClewY+JS4syQvbfsTfPnQ3P1sGVwMoZQ6c6M=;
 b=4ZGdeIeCDoOSka3/eIp9lS4mp5XPKBb6xovhH3YLXzzJEgN8bfxZvtBgUBQXWGQrWsgQQDM2al61PphCdw+8/Llth1uFG7jYuy4kKVw2iNnC1iiX9OBpOo83zdTh44o6KnGNK/y3xNB799tpIr59BrhnayMRULPq4F+PQH7Au3V+Z8H6tkX7pWSxBd03+N0AV3xN09YG6wBVHRkIl6pKCwVgLxUUo72YWJC38Cy4ECd3RzB02Rg41l++LGXAV6EWJrsjigWwkgk2HPla8N8u3jbzdEe7dJHc5x5Nz4qNMKukUmILs9nePN5QVu20VxbRxVtnURMlGCeDP5NA9F5F2Q==
Received: from PH0PR17MB4277.namprd17.prod.outlook.com (2603:10b6:510:a::15)
 by PH8PR17MB6809.namprd17.prod.outlook.com (2603:10b6:510:23a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 14:46:34 +0000
Received: from PH0PR17MB4277.namprd17.prod.outlook.com
 ([fe80::f000:695f:be77:9fd2]) by PH0PR17MB4277.namprd17.prod.outlook.com
 ([fe80::f000:695f:be77:9fd2%3]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 14:46:34 +0000
From: "Naulls, Peter" <PeterNaulls@eaton.com>
To: Daniel Vacek <neelx@suse.com>, Sebastian Andrzej Siewior
	<bigeasy@linutronix.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: Re: Btrfs PREEMPT_RT transaction-waiter livelock: experimental
 mitigation in kernel 6.6.78
Thread-Topic: Btrfs PREEMPT_RT transaction-waiter livelock: experimental
 mitigation in kernel 6.6.78
Thread-Index: AQHdYWr3jkur6fkoRkaLOYeeQ8eBzA==
Importance: low
X-Priority: 5
Date: Wed, 21 Oct 2026 14:46:34 +0000
Message-ID:
 <PH0PR17MB427723A82BCB2A6FCD37B329BB662@PH0PR17MB4277.namprd17.prod.outlook.com>
References:
 <PH0PR17MB4277167A37B20340B231443FBB922@PH0PR17MB4277.namprd17.prod.outlook.com>
 <SJ0PR17MB4288FC2E7FFB577F5D6C6D9EBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
 <SJ0PR17MB4288C46458DCE2C015839D0FBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
 <CAPjX3Ff-zn2hda=deMvCGM1UMM6Zghh-ywabBMTqFUbzC69YEA@mail.gmail.com>
In-Reply-To:
 <CAPjX3Ff-zn2hda=deMvCGM1UMM6Zghh-ywabBMTqFUbzC69YEA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_8afd4f73-fada-4b37-96db-6e01034f2850_Enabled=True;MSIP_Label_8afd4f73-fada-4b37-96db-6e01034f2850_SiteId=d6525c95-b906-431a-b926-e9b51ba43cc4;MSIP_Label_8afd4f73-fada-4b37-96db-6e01034f2850_SetDate=2026-10-21T14:46:33.659Z;MSIP_Label_8afd4f73-fada-4b37-96db-6e01034f2850_Name=Public
 (IP1);MSIP_Label_8afd4f73-fada-4b37-96db-6e01034f2850_ContentBits=1;MSIP_Label_8afd4f73-fada-4b37-96db-6e01034f2850_Method=Standard;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eaton.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR17MB4277:EE_|PH8PR17MB6809:EE_
x-ms-office365-filtering-correlation-id: ff7c45d8-cb0e-47d1-44e7-08df2f821a2f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|18002099003|22082099003|10067099003|3023799007|4143699003|11063799006|5023799004|261009223027099003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 XOlDDqgSaBBAKbjgbLvLV8AlqaIrAlrUJHtUtjoQiLTIJ5bVSHAmEZsj09m0pRDQ91zbJrZ/PnrUzAZJPwfEFMP6IC4jwqbQLUsReikpDcwxw9vJxkiHQ9fLfw7uXXTzjCXpeomra8grWt8GwIV+RLVFInruw2epcaUUJhh9VdB17ereCBVjfXD+7rLiMfLRbRBf7K7mHi5wAN7n6GcEj1bWc+tGGsF55TPTf7TfDCN4QGAFnF01HEor2QunL/rsK3fWbzTP0HtUsZtG1EKvBvcAEbSuCcGvAiQWXyTRTN31eiWBLZg/laPaZcUi+IKXrCnEL1jaZRkcrNgaJHI3sJbdLLviTDUAhvOfV1h2KoFRFNqcXfqGqpKf8pop0E3SRioBPC2wb/fTImkqdgridJGD8hVv0bAk8+H4A80/1689xjBiVESGGCE/lr9LU0RrHpscJVqUNpc+Hgw8Pn8atMkdqvdpsWF5dVDCv9YtOjD6yVV7s3W0iIf5hYJK5nwVnPdoVHXMduat+0YhNRjf+JM0eyAHKOmCCXMLo0uW3jrPjt64J8nbnDlYl94f/v6tMt6zVEkeDzdqWnqHwaYzNkQetgxHFDnouGgva3mz4J8iI1aij8m/7w2VDiRr8Ltd3BEmpctpG58KTLglZyemis1ySWC8VPMlfcMceJh+O5YffNLSRYwsasSS3HZZEZu5QlEiLgQKH/WQS+3b1vZHQVhXXJqhr0zq/v6xFCNkcmc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR17MB4277.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(18002099003)(22082099003)(10067099003)(3023799007)(4143699003)(11063799006)(5023799004)(261009223027099003)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?24UqhKXgQThS6yed7EEAvmh8BTxuIop8CvtLpAjJ5DLA1pylnpUqcIt4Nt?=
 =?iso-8859-1?Q?BWOOfbqCAMNTHMDoPzpcM7DH7Vf2p/jm6t2g2fKbvTLXdGcjHR7nParQWd?=
 =?iso-8859-1?Q?mSrESTManSLeeOzfcCXzAeobelSdDcc00BosUNiBs5YetjUJtsEPK/3/8j?=
 =?iso-8859-1?Q?nGCwJhDJeUMgNzWcJA3II0Fc8/nkCAwchVZOoklSSzLPn1gvIB6h0PNm4D?=
 =?iso-8859-1?Q?9f2V2OQfrwy0wHQ7jckk556jL6jXlhDazk8oC5jeolwWBHpHQxw8a1plNh?=
 =?iso-8859-1?Q?cWVTL4G2B9KCmNzeopcVPdUF8YehpqCLgKkBFarZoSaBVHpagYXVe6eH8J?=
 =?iso-8859-1?Q?iYmTaMs0RCy6lrMc7Z97JB7Fkqo9EMHiSOucONsjdn23DZJI6Kb6qZ7/C6?=
 =?iso-8859-1?Q?JNIyRffhVsFM4c3JUaFolAB+uClW5SMPRGErSRUzhzHvHZcluWop/+gHNi?=
 =?iso-8859-1?Q?O8AVoSJh3a0sK2RZRO/RJskFFIy49Fv5gsY/ujmti/C0QC7gFnhEcigtiz?=
 =?iso-8859-1?Q?wK7EO88SE0cxu3kSxiGb6uRrQHYPaokqfuDPH8AjZoC2QL//TXCA3Fdm+N?=
 =?iso-8859-1?Q?opAXmglr+ZlsCIZS9xW6h6MV1Qi/EbFrro9XanU6qPaXp2eSmNhmRdnTMh?=
 =?iso-8859-1?Q?0fL0lAqR1A2uPnT2e+UyvQGiz4eowt3EHXAX/fxTCz1ibwuurpzEUUTmub?=
 =?iso-8859-1?Q?3PQu3I8de+SQRxK77RKS9lqtRwaXFkpyT5xZoVBm0dOni39VmIbcoQorR1?=
 =?iso-8859-1?Q?lfe1LoP3xCUySVvDvE4T2m2YfcznSXJnJGCSI/N9Wl68bgMT6X3yx6rdxO?=
 =?iso-8859-1?Q?r3LwsWzVWxKukfArL1V7ZVo1QUktXw1GaLh3xrfnTnYODIO0AGpbe75mc1?=
 =?iso-8859-1?Q?5wiE3pgavjqQC/aI7ayOW8wjIq8l2ccVYcb62w18/9Hav/Ls5UH4zcfsjP?=
 =?iso-8859-1?Q?T/DvpxEDjbHWdGIWvFeqyLOzI86xoVJrqcq9jZokgQLY2wcs+GZti+3WKx?=
 =?iso-8859-1?Q?dM2jsIPE0r8sIvZ0RjA0VL/24dFpbkYy6+qokDKkw2f5iuaXSvB+UjDNYX?=
 =?iso-8859-1?Q?X3xbhrK5queRwXw7LS0dk8VjUD1mLjHdI7i1lmFaOb13yCESFvLuvdz9z0?=
 =?iso-8859-1?Q?0CbXB8++gU6kGkcEFDvRRQ0K3pep9OnyhxH4kjehWKKUbCoNrPvFcfRD+Y?=
 =?iso-8859-1?Q?Ru0S5Yt8j20yg9/ulbEvwdI44b4tc2zBO7jhJ5d6Z1QL/CgnY8wXD13mbv?=
 =?iso-8859-1?Q?cnDSj+DyWRmVbtpWyd4bQXxqIjBpW8XisM9Ng0zxMxe3CMK6fnmNbc5kkY?=
 =?iso-8859-1?Q?DL2vD2bTYvMeZ6sIDCqTqey1qqrAB4ANQheGBZ1dK9LBRc2oIEAohFfJ2O?=
 =?iso-8859-1?Q?b7oKImChnltQl+hFP8TfnO67ndPSlJGa08XBi/tas5cy3nCUfC21tvOEQG?=
 =?iso-8859-1?Q?k5Aek/KQSSqG+UrSZ1/u5sE4WiMXZ2z35bWmNUkMaOYv/YDaT+bE2yJejb?=
 =?iso-8859-1?Q?8bKCLPNmU8xgvH4+6fG9guefdxXk5wBMGAFawKo2bhrrKWgy2AvEkddhjF?=
 =?iso-8859-1?Q?saVYVaS5sEGCkLIwebp7QxVNeQggqX3cc+h1lklC0B+Ajj/qDWBRnNBYVo?=
 =?iso-8859-1?Q?agbACASVW48OoEwLI/rJbBtOKs1oKFyBL6Ujz72mthvb19VX4lv1RPRGw6?=
 =?iso-8859-1?Q?HApIht5/h45/cLnsTTy9aUKrPCHcTIgF34WAdXM4cBaIoyUHiMiKvmnwvt?=
 =?iso-8859-1?Q?cwk4ROPw4+PxIC3yY0tVYJDdMmO2NLA1kJwdkV6a8kuNgPFAuObx6w+dNO?=
 =?iso-8859-1?Q?ToQ34Qe+mA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: eaton.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR17MB4277.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff7c45d8-cb0e-47d1-44e7-08df2f821a2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2026 14:46:34.1230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CFl/tVMmJePn2FrF3XuHAwMggTjZvdWXiVtq2Mcx6EGEfVQ2In0QwELIWBHEUrsuj/DQX7+UPrfjHR3eV+/O1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR17MB6809

=0A=
Sorry for the delay, I had some other tasks and wanted to do some more rigo=
rous testing on a recent kernel and address pieces from both mailing lists.=
 I'm going to mix up replies here in Outlook, so bear with me. =0A=
=0A=
=0A=
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>=0A=
> Could you try if you can reproduce this with v7.3-rc7? This one does not =
require any additional patches.=0A=
=0A=
For the testing below, I'm now using 7.3 which was released just a few days=
 ago. I haven't gone back to the 6.6 kernel with the suggested patch. =0A=
=0A=
=0A=
> From: Daniel Vacek <neelx@suse.com=0A=
> Thinking about it again, I don't think this is a livelock situation. I=0A=
> think it's just a severe lock contention due to the number of=0A=
> threads/CPUs fighting in a tight loop (due to the=0A=
> btrfs_commit_transaction() and wait_for_commit() design) and as a=0A=
> result the overall progress and throughput goes south.=0A=
=0A=
Maybe. In the isolated testing I did, it certainly looks like that - the co=
ntention eventually clears, but in the meantime there's=0A=
very high CPU usage, apparently from the sync command, but traced to the sy=
nc() handling in brtfs.  Copilot believes that might not=0A=
be the full story, but I'll get to that in a moment. =0A=
=0A=
> Would you mind testing the below change? It passes my tests though I=0A=
> was not able to reproduce the exact situation. I still believe it's=0A=
> going to address it for you and restore the expected performance.=0A=
=0A=
In limited testing, this appears to resolve the problem under 7.3, where as=
 I was able to repeat it within a few seconds otherwise. =0A=
=0A=
[snip]=0A=
=0A=
So to clarify, this is on 7.3 release, on a btrfs loopback mount in /tmp, i=
t doesn't need actual flash backing:=0A=
=0A=
-----=0A=
#!/bin/sh=0A=
# Create and mount the RAM-backed (tmpfs /tmp) Btrfs loopback test filesyst=
em.=0A=
set -eu=0A=
=0A=
image=3D/tmp/btrfs-loop-test.img=0A=
target=3D/tmp/btrfs-loop-test=0A=
=0A=
[ "$(id -u)" -eq 0 ] || { echo "Must run as root" >&2; exit 1; }=0A=
for path in "$image" "$target"; do=0A=
    if [ -e "$path" ] || [ -L "$path" ]; then=0A=
        echo "$path already exists; reboot or remove it first" >&2=0A=
        exit 1=0A=
    fi=0A=
done=0A=
=0A=
( set -C; : > "$image" )=0A=
dd if=3D/dev/zero of=3D"$image" bs=3D1048576 count=3D256 2>/dev/null=0A=
mkfs.btrfs -q -n 16384 -s 4096 -d single -m dup -O ^block-group-tree "$imag=
e"=0A=
mkdir "$target"=0A=
mount -t btrfs -o loop,noatime,compress=3Dzstd:3,ssd,discard=3Dasync,noacl,=
space_cache=3Dv2 \=0A=
    "$image" "$target"=0A=
=0A=
resolved=3D$(readlink -f "$target")=0A=
awk -v t=3D"$resolved" '$2 =3D=3D t {print; found=3D1} END {if (!found) exi=
t 1}' /proc/mounts=0A=
df -h "$target"=0A=
----=0A=
=0A=
This is the minimal test case I came up with below. =0A=
=0A=
Typically run with (after creating the mount of course):=0A=
=0A=
/home/root/btrfs-minimal.sh /tmp/btrfs-loop-test 4 1000 4=0A=
=0A=
Failure is typically at iteration 130 with these parameters. It's possible =
to reproduce with "2 1000 2", although that particular case seems intermitt=
ent. =0A=
Observe "sync" in top using CPU. =0A=
=0A=
----=0A=
#!/bin/sh=0A=
set -eu=0A=
=0A=
target=3D${1:?Usage: btrfs-minimal.sh /mount/point [workers] [rounds] [rt_s=
ync_helpers]}=0A=
workers=3D${2:-4}=0A=
rounds=3D${3:-1000}=0A=
helpers=3D${4:-4}=0A=
for value in "$workers" "$rounds" "$helpers"; do=0A=
    case "$value" in=0A=
        ''|*[!0-9]*) echo "Counts must be positive integers" >&2; exit 1 ;;=
=0A=
    esac=0A=
    [ "$value" -gt 0 ] || exit 1=0A=
done=0A=
[ -d "$target" ] && [ "$(id -u)" -eq 0 ] || exit 1=0A=
chrt -p $$ >/dev/null=0A=
pgrep -V >/dev/null=0A=
chrt -r 25 /bin/true=0A=
[ -x /usr/bin/sync ] || exit 1=0A=
=0A=
testdir=3D$(mktemp -d "$target/btrfs-minimal.XXXXXX")=0A=
writer_pids=3D=0A=
helper_pids=3D=0A=
=0A=
cleanup()=0A=
{=0A=
    trap - EXIT INT TERM=0A=
    for pid in $helper_pids; do=0A=
        chrt -o -p 0 "$pid" >/dev/null 2>&1 || true=0A=
        for child in $(pgrep -P "$pid" 2>/dev/null || true); do=0A=
            chrt -o -p 0 "$child" >/dev/null 2>&1 || true=0A=
        done=0A=
    done=0A=
    for pid in $helper_pids $writer_pids; do=0A=
        for child in $(pgrep -P "$pid" 2>/dev/null || true); do=0A=
            kill "$child" 2>/dev/null || true=0A=
        done=0A=
        kill "$pid" 2>/dev/null || true=0A=
    done=0A=
    for pid in $helper_pids $writer_pids; do=0A=
        wait "$pid" 2>/dev/null || true=0A=
    done=0A=
    rm -rf "$testdir"=0A=
}=0A=
trap cleanup EXIT=0A=
trap 'exit 130' INT=0A=
trap 'exit 143' TERM=0A=
=0A=
printf 'WARNING: global sync can stall any mounted filesystem; recovery may=
 require a reboot.\n'=0A=
printf 'Directory: %s; normal writers: %s; rounds: %s; RR/25 sync helpers: =
%s\n' \=0A=
    "$testdir" "$workers" "$rounds" "$helpers"=0A=
=0A=
helper=3D1=0A=
while [ "$helper" -le "$helpers" ]; do=0A=
    chrt -r 25 /bin/sh -c 'set -e; while :; do /usr/bin/sync; done' &=0A=
    helper_pids=3D"$helper_pids $!"=0A=
    helper=3D$((helper + 1))=0A=
done=0A=
=0A=
worker=3D1=0A=
while [ "$worker" -le "$workers" ]; do=0A=
    chrt -o 0 /bin/sh -c '=0A=
        set -eu=0A=
        round=3D1=0A=
        while [ "$round" -le "$2" ]; do=0A=
            if ! dd if=3D/dev/urandom of=3D"$1" bs=3D262144 count=3D16 2>/d=
ev/null; then=0A=
                printf "Write failed: %s, round %s\n" "$1" "$round" >&2=0A=
                exit 1=0A=
            fi=0A=
            /usr/bin/sync=0A=
            if [ $((round % 10)) -eq 0 ]; then=0A=
                printf "%s: round %s/%s\n" "$1" "$round" "$2"=0A=
            fi=0A=
            round=3D$((round + 1))=0A=
        done=0A=
    ' writer "$testdir/worker-$worker" "$rounds" &=0A=
    writer_pids=3D"$writer_pids $!"=0A=
    worker=3D$((worker + 1))=0A=
done=0A=
=0A=
status=3D0=0A=
for pid in $writer_pids; do=0A=
    wait "$pid" || status=3D1=0A=
done=0A=
---=0A=
=0A=
So yes, your suggested patch appears to resolve it, I ran with 10000 runs a=
nd was not able to repeat. I will repeat this on our 6.6 kernel where I thi=
nk there are some RT differences. =0A=
=0A=
As to why this needed an RT kernel, from copilot (so handfuls of salt):=0A=
=0A=
"The RT kernel changes how trans_lock behaves. In btrfs it's an ordinary ke=
rnel spinlock, and PREEMPT_RT turns kernel spinlocks into priority-ordered =
sleeping locks. That change turns the loop into a starvation.=0A=
=0A=
Without PREEMPT_RT, trans_lock is a real spinlock:=0A=
=0A=
Tasks waiting for it are served in arrival order, regardless of priority. O=
nce the committer asks for the lock, it gets it after the tasks already ahe=
ad of it.=0A=
Taking the lock disables preemption, so the committer can't be preempted be=
tween getting the lock and removing the transaction from the list.=0A=
The SCHED_RR waiters still loop, re-finding the finished transaction, until=
 the committer removes it. But the committer gets through quickly, so the l=
oop is short. The worst case is the contention and lost throughput the main=
tainer describes.=0A=
=0A=
With PREEMPT_RT, spin_lock() uses an rtmutex. Three things change:=0A=
=0A=
Waiters queue by priority, not arrival. Each looping SCHED_RR/25 waiter goe=
s ahead of the SCHED_OTHER committer.=0A=
A higher-priority task can take the lock from a woken waiter. When the lock=
 is released and the committer is woken to take it, an RT waiter that asks =
before the committer runs can grab it first. The RT waiters ask constantly,=
 because their loop never sleeps: each finds the finished transaction still=
 listed, sees it's complete, and goes back for the lock.=0A=
Everything is preemptible. The committer, and anyone else holding the lock,=
 can be preempted by RT tasks at any point.=0A=
The RT waiters keep the lock in their own hands, while the one task that co=
uld end their loop waits behind them indefinitely. That's the livelock."=0A=
=0A=
=0A=
And as to why it thinks this might be an incomplete fix:=0A=
=0A=
"The error cleanup path has the same bug and isn't fixed. btrfs_cleanup_one=
_transaction sets COMPLETED and wakes waiters. btrfs_cleanup_transaction on=
ly removes the transaction from the list afterwards. RT waiters in wait_for=
_commit can loop there exactly as before. It only runs after a filesystem e=
rror, so it's rare, but it's the same livelock."=0A=
=0A=
I will now go and repeat this testing and patch on our 6.6 kernel. =0A=
=0A=
=0A=
Regards, and thank you. =0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
