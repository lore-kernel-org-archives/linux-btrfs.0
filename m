Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.63
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792604909;
	b=Oq1+VUzIpo2nI4vfPc7Nbyu2sXk2k2BmcOJ2r1zXC+6z5EnZh9rS9KXWnZrlPrSTxpE1
	 7j6oEf1P4+9EvkCF3EETjSetB0PjYTNwLxjhK2gdeTkFggypISSu1/5uHI7Rm6v6Us94K
	 YyQPS/Xnai3bmCAm37nuALQcqfWYk3DnU7TwnPSDE9WUxsKREXZpcch67aH3qsglPciRS
	 3IjqhnCmL2gXoYT4dSmoVx8Li/MAjozAEZcJfC3tAntGHAvtcGq5xk3XtcjqO+Yr9Cfjs
	 3vUHiOE0vEyGTPwlGbxPy2PSCq0R2G/82Aco60Jt6wFKAR72YLU8MezPKxNAYblsh5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604909;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 msip_labels:x-ms-publictraffictype:x-ms-traffictypediagnostic:
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
	bh=Pp/AyLTmSJDwFwK/LwbUjNHCo7mGmkYFV3HhPfVmhqQ=;
	b=SEC+kAl4z2pqvJ/aHHnWaSDSewox+fK15+8K1rHif7mtV8eLtLfjEpNgkm3x28cYUyCW
	 ShgfEYych6tZuW5maFoClgT5kH4aTKaZILa6Sq3EV0KMkWRGsmzvrTIYMEXFMXqrKE/dE
	 5D2yYxMYN/crKtUeq11Lh/ctpcXIfoTjUfWrLpYmHGNeP4pHS8FHIQJPo6DAqKEJ1z94C
	 ck/VlJZgHJOSHh31Ks9BiJGePmIc7qwVpoUCeqXz8PZcZ1oL2I0d74MSKWDA5LiZmGUsh
	 ncqEkDeXleLvVAJB86ZN5ZsKrBs1SWtAtfnHhPhN34HaaPjp+HsoE52IyXuCOWATgVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=eaton.com;
	spf=pass smtp.mailfrom=eaton.com;
	dkim=pass header.d=eaton.com header.i=@eaton.com header.a=rsa-sha256 header.s=selector2 header.b=AUKtpk3d;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.63
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010063.outbound.protection.outlook.com [52.101.61.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53268606A319;
	Wed, 21 Oct 2026 17:48:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53268606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=eaton.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eaton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=eaton.com header.i=@eaton.com header.a=rsa-sha256 header.s=selector2 header.b=AUKtpk3d
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KrH6ievvj/Pchi7SBQUsekiVvK4YAlP4Kxz4S6nq00XGyNsUuaCNuSNB5uC9HQfYDk1IH4uBQ24zwiphqiGtBSDWswjECSu1ComBAXZspBX5HjALyK3bvx+HlpWy9XNvW08uLQ3OW3RMu2X7BMFf589XvGV+nX4IAFRyziy688HW1eH+7QwDoSJGq45H/hpyS0qw9LCXUCA0psntbxupVHgfV6dUchFUpXLM4wB4iN3mvjkLeLSOpTcrjxWiSUOlP+GLlkXdtKoy5VV34CAomRu/kAwa21LKxfGHEYQ+nBRwUuxDXCSeLl5tXrMKEw/E4T8iymj7rZjjjdWa1Ze/xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pp/AyLTmSJDwFwK/LwbUjNHCo7mGmkYFV3HhPfVmhqQ=;
 b=i4c/ML7PozDyNREnGeuOpdraK42bmkqb8Wd5MvPOCHSjC2Zs2bdIxwiTP3kvrLs8tc0HzQofMdFwDEggvq4wc7a5bWlWef3gocdGoisii8r57Spav4/Wq8hCt/v1+jnGrJAIRT5am7cFAaP6iMU+jdeUfX+u2vr6KvW3Xz96e+Mn4DEgCma7o1xmHTjlLYDR08BDqEflbiGkDqTSu55WE3ysWN368+zUwDm9WP/aJJPf+wyUHZSYp4mvXxbkabZ/QQnl5qzN4Ktjnl705yJ/XsJZeOcrkbDwz7jEv0BR9y3I7F1ZU/9jbv/zsjukMrq0lGFIExIOYVMReQecKDerNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pp/AyLTmSJDwFwK/LwbUjNHCo7mGmkYFV3HhPfVmhqQ=;
 b=AUKtpk3dHEHb/lex5TRd+rb5W97jz/s+oHuGb6TFNnXMAVFzm/RJPF7CDEBAdogHa6OI1j3ZolgvTX2EPsOQ+ksooQOs44nSfxc8+tzO+eat4ZWUXIRAorltE2YhMH9sYgrXYfX82RCeJEIcA+e981hShxZMhKoNiRHAExsXCZ8zmtLgbS6yDV1lZrap61AliWOrygf+Vmca4fQbUfLkWiX7KLwhQZlIzUh/LewtP7xBvEiayqz7mEu4rL2uTxHxJMURxzvO3lTsOOQJZwehSIohYwb7x5CkOjXtKn4+LvEYGPWLFJbVrniaSDAhPuxJLM5ho9Ycb+/NdFRfKCb9PQ==
Received: from PH0PR17MB4277.namprd17.prod.outlook.com (2603:10b6:510:a::15)
 by BLAPR17MB4194.namprd17.prod.outlook.com (2603:10b6:208:27f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 17:48:02 +0000
Received: from PH0PR17MB4277.namprd17.prod.outlook.com
 ([fe80::f000:695f:be77:9fd2]) by PH0PR17MB4277.namprd17.prod.outlook.com
 ([fe80::f000:695f:be77:9fd2%3]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 17:48:02 +0000
From: "Naulls, Peter" <PeterNaulls@eaton.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Daniel Vacek <neelx@suse.com>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>, "linux-rt-users@vger.kernel.org"
	<linux-rt-users@vger.kernel.org>
Subject: Re: Btrfs PREEMPT_RT transaction-waiter livelock: experimental
 mitigation in kernel 6.6.78
Thread-Topic: Btrfs PREEMPT_RT transaction-waiter livelock: experimental
 mitigation in kernel 6.6.78
Thread-Index: AQHdYYRRwkb7guCIbE6B58KYO5NqMw==
Date: Wed, 21 Oct 2026 17:48:02 +0000
Message-ID:
 <PH0PR17MB4277D532F68355EEF5E4F8EDBB662@PH0PR17MB4277.namprd17.prod.outlook.com>
References:
 <PH0PR17MB4277167A37B20340B231443FBB922@PH0PR17MB4277.namprd17.prod.outlook.com>
 <SJ0PR17MB4288FC2E7FFB577F5D6C6D9EBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
 <SJ0PR17MB4288C46458DCE2C015839D0FBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
 <CAPjX3Ff-zn2hda=deMvCGM1UMM6Zghh-ywabBMTqFUbzC69YEA@mail.gmail.com>
 <PH0PR17MB427723A82BCB2A6FCD37B329BB662@PH0PR17MB4277.namprd17.prod.outlook.com>
 <20261021155016.1isOptPI@linutronix.de>
In-Reply-To: <20261021155016.1isOptPI@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_8afd4f73-fada-4b37-96db-6e01034f2850_Enabled=True;MSIP_Label_8afd4f73-fada-4b37-96db-6e01034f2850_SiteId=d6525c95-b906-431a-b926-e9b51ba43cc4;MSIP_Label_8afd4f73-fada-4b37-96db-6e01034f2850_SetDate=2026-10-21T17:48:01.860Z;MSIP_Label_8afd4f73-fada-4b37-96db-6e01034f2850_Name=Public
 (IP1);MSIP_Label_8afd4f73-fada-4b37-96db-6e01034f2850_ContentBits=1;MSIP_Label_8afd4f73-fada-4b37-96db-6e01034f2850_Method=Standard;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eaton.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR17MB4277:EE_|BLAPR17MB4194:EE_
x-ms-office365-filtering-correlation-id: a69e2259-4750-4b2f-06d7-08df2f9b7417
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|38070700021|56012099006|4143699003|11063799006|261009223027099003|10067099003|18002099003|22082099003|261021121427099003;
x-microsoft-antispam-message-info:
 en4B8N/ip5R/JkSM+9puzVpCmU1tMNiUWTp7K+CJhxcbGLoyS+LvHN+UgUHbmBSCi6is+zBQSAMhG0Gppks0gAYR8VqcurrxVPDzwXk3yehOrfQndJaApXLfoxH6IIHCilLx3el6z/FaQP85nHATKY/M0hegwYBGD3GbLUixEJyNH9TAlryAkQf/m2V3/9cmPpgzFSmX+1JFF/of4oG0kdeI56XpxqCCGuzpnh9HFkChWieuIpj2OXdRBxxsPG6JgOFz9qHsXfcjJ1cPjKz4GNuDLDxbN5U6tKp0H1Hh3f4M30JJ78dKHoOdL1vEVkZZ/1qt6tUeS39GYY3Kh9DOM04ifdcmaErkPQ0mpi2dU1i0D6qjiYW//ASfwFmukP+A2k2nfz1ITnGMPg5ns19GlD3OFUOUPY3248RyLUe42su4CGxmrkMm/xKYgsn+/dNSpztfhHUG7jd+60mj467NcOnU4PuRF7K2wweOKI9TXk0StQ7T6gfKDLwepodgMPaUyFoumY72zNYqcVJHprKQIKNPFQM+AHAgeeQ3dpXd93eqU2kXU+/vHt73FDzc1fBEfjJmJ3KfpsBUKs02fIGXmlAtR90gjfEb1rRwfqwy1TQmlfyrnoKGOPI3a23P+NNto0GVGBb24bZSa/2MBnD2clND3psrdiYrAov/7f/kqL5AyDGM7M7b6u39wwCSJYMouai4PJiBoqVmTru0fmBEwPoRShL4FMUlmxNZKgPT67k=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR17MB4277.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(38070700021)(56012099006)(4143699003)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(261021121427099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?X9rAqkqyE3BnZF7IM8ldim4A1W0fuPvQBhUmHSdVVvtsGk8rI5rhABsdML?=
 =?iso-8859-1?Q?e/GOnIaPr2mlx/1MAVt8Me9yfrhUhQWQwxQg1IAwk6i3+HF3VfyQcH/zzG?=
 =?iso-8859-1?Q?QTtyqnIyNAGTIKQd084d9aK/wLxRVOfq6GfAKtxTsSwvoBpsKAA4xTlWLw?=
 =?iso-8859-1?Q?lP3eE2Gv/jmTvWFAuVfErftwezzXtQoaN7rFFpkK1hAfVf1Es6tHVMaCj6?=
 =?iso-8859-1?Q?6Qm33eF4r2k45LvzZoISUvOjPCXhA17FwkaGYu4bNat1wzBDXxcgGjXpyk?=
 =?iso-8859-1?Q?klVve+ov6KgXgMxw8rvMuppAwYznoL4DtiwVOhLsuT6sniOlY9L5OjGqgX?=
 =?iso-8859-1?Q?iH/kCRw42TPaHKfTcabvpiH1sfHwPEVuTx1ZTau/g5OKUMvjhTktIz9dKk?=
 =?iso-8859-1?Q?t3iKZhJ5+LaoGMJ/4FmENawN24gyAu8cHyZ3Cz2w+PoWFT03RDBuRW5HLD?=
 =?iso-8859-1?Q?k9AJS/rFLpEf81jWHqD2TBZ0tnNp9Gh5od7SBwjEo7N+h77j0sJcS4xB4P?=
 =?iso-8859-1?Q?9OIjd9zCWrwpW4XBgzIQouALGFFOngjKO/AddHcrn/ciwV/7eewkwchbxV?=
 =?iso-8859-1?Q?eoz/KewzN8O38yrNoPF0s7DWeI8SnA+DonKUQeZqndeIcYshl+G31tWHao?=
 =?iso-8859-1?Q?Ws59UhCjwLDqSzA/1ZdJUEgGjbDOWXI9fOfBAbuvrRJBOd8QDsH+aZZr17?=
 =?iso-8859-1?Q?VniKH1E1dURfhDpEwKcxaS9dM/NAnrMaD3fraIYMVfY+SmnDHJZJbdielw?=
 =?iso-8859-1?Q?4V6iVRTkDa3UZEU2cII/1HwAHwYBinLkViLkinNiXBYBK9c1umT8Jdvnrl?=
 =?iso-8859-1?Q?jE1eZDhLqaBZMYvCQ3g4TWS2deQHRkSFePzRhb7mmPA8TEfGp+OQRZ2aWe?=
 =?iso-8859-1?Q?zzkPZet0/WFktyuuN1qJ4ePmleNnstdbHbJP2r0RElIqx9+gHL5cnDFuKF?=
 =?iso-8859-1?Q?qz7X8VTgCXGNmvI0xCqo9a2Kk4QYXhcf0ohOOLBBRkR72jux5eSo8YtXkQ?=
 =?iso-8859-1?Q?NIv/FWzKlX1B/pClZ5H0Au1TgdQENIIw5yFWjGQPsk2xfbQ6BMryVJkIKx?=
 =?iso-8859-1?Q?rQsHFk3hZe0OYoZ/OVyUp8jCw4FoAkU8HcyfUlGNbAjgW5Yw+uPvgUqKq3?=
 =?iso-8859-1?Q?Y5WeRaiytiNhIp8XOf0YGdPt+Ph5nnoJ6LNAX1uYBTPJS0uPPm2DG+OCuY?=
 =?iso-8859-1?Q?ZQ1xW/Q68MkbWz0WjIvKB0ewUIYz9mORzZ+RXotu7r+7g9KkK3foyTODWC?=
 =?iso-8859-1?Q?wJgkfBY0+PImwTYQO5NmZMi82xMCN2xRnzRSzrQma2SQvAzs6P/mFiUB36?=
 =?iso-8859-1?Q?S8HR86qxNkc1ouAnZsp2PlmWugTtz5KlfOpDCxI9suep9h8YffAxawx188?=
 =?iso-8859-1?Q?C+1uLfwgvDUgXqxYlAIuCj98gMg4R9UkHPk+laxN8UuMMA9yP27xYNm4KU?=
 =?iso-8859-1?Q?eV6+TRuWifYKjj7aW3aLsPM1ocSIgSOBTQm8SijuBend9Co9+4d+6QZdYG?=
 =?iso-8859-1?Q?woaKXMT2m/gKLXcfn+ofxqr+8/6vjk2wrSddTfdLii6KV67XW8FfP4cMfK?=
 =?iso-8859-1?Q?kn5WAMaFT3PYczTYSjysOUBCyg1mlH7fXFf9a2fCQiNbEYkFDR1beKU3q+?=
 =?iso-8859-1?Q?KQgXyB2fltXgtsgLEGkJjAfD/CV9k+tSi0/41miNgzmRKrTWZtkdzizw3/?=
 =?iso-8859-1?Q?1WTz4Jyei4//E35RZCel5apd/DZVNbQtz5NY1H0M4P60fIbp05BiduyVLW?=
 =?iso-8859-1?Q?dqEBpuyj0Hadd0QCCsKkbEYKiKfND7HkkJaYbKBPuf1S7s?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a69e2259-4750-4b2f-06d7-08df2f9b7417
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2026 17:48:02.3860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fUtzSV6/cwqYp15Vi0DYDKk0ngLcAnHLsU2Ixcki5VOOb5uWtYmIyTHBqZ1U92EZbxAjlezbVQl69WC5mg/LoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR17MB4194

=0A=
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>=0A=
=0A=
> That sounds plausible. I did ask if RT tasks are involved and I think=0A=
> the answer as no. With just SCHED_OTHER tasks it behaves as spinlock_t=0A=
> on !PREEMPT_RT (except for the preemption which should have no impact).=
=0A=
=0A=
Yes, we are not doing anything special RT wise apart from the kernel enable=
ment. =0A=
=0A=
I put Daniel's patch into 6.6 and ran it 100000 times against a ramfs btrfs=
 image=0A=
and then thousands more times against a flash backed btrfs mount and no pro=
blems. =0A=
=0A=
I'll await the final word from him on this before committing to it for our =
work. =0A=
=0A=
As some background, it appears the bug was introduced in early 2022:=0A=
=0A=
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D5fd76bf31ccfecc06e2e6b29f8c809e934085b99=0A=
=0A=
And is present in all kernels from 5.15 on. =0A=
=0A=
=0A=
