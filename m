Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazon11021108.outbound.protection.outlook.com [40.107.39.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77921385534;
	Mon, 16 Mar 2026 09:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.39.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773655041; cv=fail; b=ZAfMni1iNT6KLFeHlhAOjZ/kUViqiv1wpv1in/GINEGnzt+hFLK6lX2hjfQgvZI1fLDBbEtOCXrmbZ6gLDMRlZk1TfvHLVA5riixswVSn7ldrOrFEowZRFf7nOphRYi5Xwzr6arbfuzIH7xXP2EdmWBKOCcM8z2R4xXHhvkpwH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773655041; c=relaxed/simple;
	bh=W6GDU4aMorvjTxo7+z/+0/SVxfIDtYhPkcJ52zPos7w=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=EJFalGRw2WxHHqH2vvDB1zpjJ66/NVXSjZI156qnci7OrEU1+h76Hpc+YB65S2KQm5NQgiQvpmiZw55FgvrMDQyMUgEwkLKXMLHTfPYLFE/RUMYMnxmT689JILpFIaJdnoU1URsysrP5wei2xWQgSQXz3JP37PDypbv9h183jNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verivus.com; spf=pass smtp.mailfrom=verivus.com; dkim=pass (2048-bit key) header.d=verivus.com header.i=@verivus.com header.b=nP3Z9s1j; arc=fail smtp.client-ip=40.107.39.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verivus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=verivus.com header.i=@verivus.com header.b="nP3Z9s1j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ej1rZe8kMhcpnt8tifvNxml6RBQwKzp/BRqrub8wJXyw2jCUN8HucM8TMsyYpFYlQC4rmcNQ5q75Mnhgip/pGM8VU0eOTaV2Zokf+6Ektqe5KxzP4nx3gCRWrDLWOPEbId8B+TL5F81XgNYquBGZtJoUG01ki4KbzdPUKzaqlymiaRfRugupPkcpRfhE/a4BWe36R2/VL0P7LzCFXiId8DSpNrwgJxaeq0p1HwuOfhsXaESoqgijoutvNIs/f7D1NFXWrlPhKGLSPI29eDGcoo1CmiPzpuCRIiTlwTzmbIJ08TKqSXoGC1vX73Y/mKNYzwvLG01DDmCJuIzrpIvbng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOIKP/cfnQlg3TGQgOash5WvH911pNXdvUgwRdRApPc=;
 b=ck2cPH2rx5yyCZy7lAhfHsENs6yYj9jAw3+4V0XtzyysxereqoUV4Qb9PsoKLcWrVPD2hDdBWSPo2Mu7FE53936/EvXl/ZgegB9UbPsJIwUSpBY0+Luy1jpdp3n30Hsl5cOq1UR1DVtqgOjC9t+MkUa1PILdHwc13PokY712aWatGw/yNx9CEgKgPQ5aLN+nK93png3nvNbj2LdfjkRZWEnbqNPNjxCLXbuKlQBI3xBMht1257IlIAhqXSx+io04oRtI75EDGKtALwEQSlBOHoJu7XC3pNrATTr+f1xYnm8Sj8Ny2DRypxPHqWFnHqDl/kxBi9t9l95HcmWmxzzqdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.com; dmarc=pass action=none header.from=verivus.com;
 dkim=pass header.d=verivus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOIKP/cfnQlg3TGQgOash5WvH911pNXdvUgwRdRApPc=;
 b=nP3Z9s1jbL2X7tHK7lIEI12jIw3DPX+pEHwlzMIAfsQMSqj6T6+6GG0S+U7z2Uk64SDbN+fSgxtcsNehKR+DLGy4erLAT4MjOvqS5Hejx3yPg0v9p3xpJDotAmsOsCFjEq+PG7vkqeXoHcT1beXrakjvRWMcUH3g9R7nCjdgD+J3kanUipqSK2QXLjgJLZEHlllfX0pdwkctsKXdHqHvXGAFDc+i88yS7uRJHKsJWQr3wScQ6tXlviRUHawrYkWcFDnO37azbK7gHzoRXFc1sv6YR4kFwvHGXPHZ3Q1g1TZG/yl3txjTyjSbO0kCQfXOD1SE1uZREelwHuSYPqB4vQ==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by SY8P300MB0393.AUSP300.PROD.OUTLOOK.COM (2603:10c6:10:295::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.16; Mon, 16 Mar
 2026 09:57:12 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Mon, 16 Mar 2026
 09:57:12 +0000
From: Werner Kasselman <werner@verivus.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: "wqu@suse.com" <wqu@suse.com>, "dsterba@suse.com" <dsterba@suse.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs: fix subpage locked bitmap leak in cow_fixup writeback
 path
Thread-Topic: [PATCH] btrfs: fix subpage locked bitmap leak in cow_fixup
 writeback path
Thread-Index: Ady1KpTaQ/XSYGKTQ6ihF96ouDGa+w==
Date: Mon, 16 Mar 2026 09:57:12 +0000
Message-ID:
 <ME0P300MB0853F6FA6D7872D77E98338CBD40A@ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|SY8P300MB0393:EE_
x-ms-office365-filtering-correlation-id: 0d4e8673-3bda-4826-fc81-08de8342652a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|6049299003|376014|38070700021|4053099003|8096899003|56012099003|18002099003;
x-microsoft-antispam-message-info:
 OzjGN3FzsI0RRuqh/lTT1ykPBPDRFllEKEdosV99YBOO5LiQU63SeKD2fbaTPb/+TtSGaDuQN7G/lxR8oMYYYH7LHmrGQchI3pe7Lv3la7726/r8VkYRMpppR4xLH8Z0EyxwUff2/DoioT1Gf6KDlp5do696O89vn1mFazSdiFstVB5CD41GmWzf1VqXj0sdpUkNvJ+j5Jxy2VjuOK3FcGj8FhpJ7Opn17OVxUbBv4FDlcT74bijtU6dS3jkzKE3ANPv3EAG+5+yqpoubtQOWrGuklf/NvBZB9Ccixqi2D5pKSh7/dTy/Hu+97zod4xLBs9iXT8DZG/9d306viy4LoJvVAE5sx+5Hv1ZpNv2ibgHw8y6iXFKltdaErpWtWwDHZ//h35wG1Xo2nOstvTSp0/KslIlXOZ+apUeUQLjNOFJUuXJyvC4IKBfyVO5CaEActgAkt89/kvj2PxuRUoRECy4nFJRarjDTX4a7My+qLXHfr/oh4BQxlk9mskjpFnMY+32R5Kf7YXxSSpIu74xD5tDmX5ECbcmsP4QsuboX+NnCOIAJFH5K03SREaUPvXfX4AFJG1gkCe43ZKMoWX1x82T+SbpO3G99eNgqQ8nzozXKD0Ri8Vzer0gL+ro46k30HNbq9zHjU3Fkk2j77UfJ1OsZyWRC8ffmjm5jLwPaC5vriggkM42vuf6j8yS02goHIb9Vozxkgi7YpvH22UGzX/zdmakQUG6/lw3xZCk/z4G2qFWfSKu/BBXyb9WaGANCqFJAwB89MGjO0SEGtqLyQTF2UVc9LSwNRG4ORDyWqw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(6049299003)(376014)(38070700021)(4053099003)(8096899003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?L+LbaDc2Qw09w2JyC159hJ+Vy0VrtjFWOYJGOznhGcJgRu16kFG7eKm7Yir0?=
 =?us-ascii?Q?o8xrHgDS7iIYOQCFHaT3ZFGjpV0QpDeBgA4HsOjSjmLE7Sy0Bf5Badc6HKED?=
 =?us-ascii?Q?H7I4Wx3r8wQPU4bnRnlv59OZOFb7mDyekfE8Fx/taZD3RGpdRkdoJv6n/Ej5?=
 =?us-ascii?Q?HStM/G8bY9IYWt6YoklIT8gISjn/itvMTw3Uw+0TG3iOutCObMFQ9PNbHF59?=
 =?us-ascii?Q?zD0REoSD9cPvQ2zCiOmFwSYkwc5OdAxN5CLpfzDx4mswEgralR/yMQ6MDwZn?=
 =?us-ascii?Q?vym3pxZ5jx1u9Twi5tSKoPrr8QCRvI6HUik8UX5aRF571iDMT/cKzJwtHb+E?=
 =?us-ascii?Q?ofGtsWP5RLIg50GF5pFmFTqvQZbugo6984EjxpmGGak9MJKaPE2jk1MUAjUg?=
 =?us-ascii?Q?hciILbbfdngzzyqPssYXhso0q3b/FNfAYIXfVaqLJSsVxShexKyt+8rj9QCm?=
 =?us-ascii?Q?i8lzS/YTBsJAsLs5ElocdKrdMLFJVz6sk1Sr7yg78LZA+YoIDioXHA0GvqUg?=
 =?us-ascii?Q?6CLarNzzJXFPYLVBhxmPJPKhMQEMW82C+P3yuPY6n8lEmlby7qXnS2xlbpHj?=
 =?us-ascii?Q?wjD1u6ye9kGOgbI8DCV498rVlV3yayjxHfNcJG5OBt3WFvL2hSxEbCQV8qmB?=
 =?us-ascii?Q?Uibb/1MKf/k9lr/2MFTnEvAd7d4IRbqBFKs7Me7/HAxwivquqxE2XMQ43dQr?=
 =?us-ascii?Q?ObU5+SUmt9+4eWgsORTkaegasTQ1/LWJ/H15a12rnM8WnuMy9LL9UBE1KGSa?=
 =?us-ascii?Q?qbwd0qBtetvo8OgvuN5tqJ3zudiv3OulbEy17L+PcNiNY1Ko0anaKJceo28F?=
 =?us-ascii?Q?vIC88hPu2QmD6MZlZybt2keT7KYcWjK4lt0TrABdLQw+XlZY0g1Z21iwxSOJ?=
 =?us-ascii?Q?Cci9ujjgAR6bYXIWPtto6KqlGzKB4Q/zQxKRaDzZTtlaJbXbELKIfdtmUi/1?=
 =?us-ascii?Q?YGDuyhJcLTIdPscA+bDgaR0/gnLF9Rc7A2dO+yrKT/RIGyHbk+3gFo9K+uHG?=
 =?us-ascii?Q?WkiG9f6jEL0/3fcvwECVKHGDSS+tuF9iGpGrVaxKJ82OZlXBUVCB6nXUQE6+?=
 =?us-ascii?Q?+54pkYYImOSytEtW87zftef8MX4mACR45x550BLVkkBT4IDHO7Jpu8hWVz4L?=
 =?us-ascii?Q?JMlk102M8j6zHr8S8fbckgxVmqUp7nR3GkayGG8DF4fnqk/eUGg77cFRAbSP?=
 =?us-ascii?Q?L9z8+5L4EYLL9dtTzLrjV7HG+/tWRTsVtL6G6RqSIIi04oeYPH5XnBu1nds+?=
 =?us-ascii?Q?DX152LYafkr08dA8CkaM5R6tN4fCumJHmgtf+jq8wwVhl13Fx/Ri8A6lf8jE?=
 =?us-ascii?Q?4CjHEgj1SGMOVrsaWmLDeZHeJ+0Zw9EhEHPTD0nkYwkHuoy+h9RwCdvfxKgj?=
 =?us-ascii?Q?iaD+2EaqEs6MiA0YDo4QzUCeIgF1w6eerxQ+SqqpcBR8zKlXWthVWdULLb9K?=
 =?us-ascii?Q?/SHzSAVTRUl7duh11uCAz+dl/paW16YMogXSv3Rt+1a75tEbOUhA/14kL7mt?=
 =?us-ascii?Q?BkGc3AAdoubp+hbnI7RjI96yZyzR54RPvkcC9vQ21OZWrUjWCoPhHEZzzvIP?=
 =?us-ascii?Q?GwMBSyr2yxZIJgkQo40dyHuWAD624vWjjtmMhprwufQGRmFhvMjFP9jnY+jA?=
 =?us-ascii?Q?5kqfOprXaqVFDvFrREdQytdL9yml52i5pONkQ3S1gddA8oBTpEhVlQxOuebO?=
 =?us-ascii?Q?UUF9CVacoTF9HMZRariYZHEesPPH//lqBE2U65UkNueHBVKz?=
Content-Type: multipart/mixed;
	boundary="_005_ME0P300MB0853F6FA6D7872D77E98338CBD40AME0P300MB0853AUSP_"
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: verivus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d4e8673-3bda-4826-fc81-08de8342652a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2026 09:57:12.0990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +FxjjX1KT1n0sUIEjraNYL8mw1rd1Ack0YGDwHqCNYxOTc2q8bWboz++G/6j41aOJxi5BgMqYVn45ZD+46uSjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY8P300MB0393

--_005_ME0P300MB0853F6FA6D7872D77E98338CBD40AME0P300MB0853AUSP_
Content-Type: multipart/alternative;
	boundary="_000_ME0P300MB0853F6FA6D7872D77E98338CBD40AME0P300MB0853AUSP_"

--_000_ME0P300MB0853F6FA6D7872D77E98338CBD40AME0P300MB0853AUSP_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

While auditing the btrfs subpage writeback path in 7.0-rc4, I found a locke=
d bitmap leak in extent_writepage_io() when btrfs_writepage_cow_fixup() ret=
urns -EAGAIN.

Since commit c96d0e392141 ("btrfs: mark all dirty sectors as locked inside =
writepage_delalloc()"), writepage_delalloc() calls btrfs_folio_set_lock() f=
or all dirty sectors, setting bits in the subpage locked bitmap and increme=
nting nr_locked.  These are normally cleaned up by btrfs_folio_end_lock_bit=
map() at the end of extent_writepage().

However, when cow_fixup returns -EAGAIN, extent_writepage_io() calls plain =
folio_unlock() and returns 1.  This causes extent_writepage() to skip btrfs=
_folio_end_lock_bitmap() entirely.  The locked bitmap bits and nr_locked co=
unter are leaked.

When writeback retries the folio, btrfs_folio_set_lock() tries to set the s=
ame bits again and hits the ASSERT at subpage.c:746.

The fix replaces folio_unlock() with btrfs_folio_end_lock_bitmap(), which c=
lears the locked bitmap bits before unlocking.  For non-subpage configurati=
ons, btrfs_folio_end_lock_bitmap() falls through to plain folio_unlock(), s=
o behavior is unchanged.

This affects subpage configurations (sectorsize < PAGE_SIZE, e.g. 4K sector=
 on 64K-page ARM64) when the cow_fixup path triggers, which happens when a =
page is dirtied via GUP/pin_user_pages without going through the filesystem=
.

I also wrote a standalone bitmap state machine simulation that reproduces t=
he invariant violation and verifies the fix:

  tools/testing/btrfs/test-subpage-cow-fixup.c

  $ cc -o test tools/testing/btrfs/test-subpage-cow-fixup.c && ./test
  TEST 1: Buggy path (folio_unlock)                ... PASS (bug reproduced=
)
  TEST 2: Fixed path (end_lock_bitmap)             ... PASS
  TEST 3: Non-subpage path (both behave)           ... PASS
  TEST 4: Partial async + cow_fixup (buggy)        ... PASS (bug reproduced=
)
  TEST 5: Partial async + cow_fixup (fixed)        ... PASS

Please review.

Thanks,
Werner

--_000_ME0P300MB0853F6FA6D7872D77E98338CBD40AME0P300MB0853AUSP_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Aptos;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	font-size:12.0pt;
	font-family:"Aptos",sans-serif;
	mso-ligatures:standardcontextual;
	mso-fareast-language:EN-US;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Aptos",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	mso-fareast-language:EN-US;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-AU" link=3D"#467886" vlink=3D"#96607D" style=3D"word-wrap:=
break-word">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">While auditing the btrfs subpage writeback path in 7=
.0-rc4, I found a locked bitmap leak in extent_writepage_io() when btrfs_wr=
itepage_cow_fixup() returns -EAGAIN.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Since commit c96d0e392141 (&quot;btrfs: mark all dir=
ty sectors as locked inside writepage_delalloc()&quot;), writepage_delalloc=
() calls btrfs_folio_set_lock() for all dirty sectors, setting bits in the =
subpage locked bitmap and incrementing nr_locked.&nbsp;
 These are normally cleaned up by btrfs_folio_end_lock_bitmap() at the end =
of extent_writepage().<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">However, when cow_fixup returns -EAGAIN, extent_writ=
epage_io() calls plain folio_unlock() and returns 1.&nbsp; This causes exte=
nt_writepage() to skip btrfs_folio_end_lock_bitmap() entirely.&nbsp; The lo=
cked bitmap bits and nr_locked counter are leaked.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">When writeback retries the folio, btrfs_folio_set_lo=
ck() tries to set the same bits again and hits the ASSERT at subpage.c:746.=
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">The fix replaces folio_unlock() with btrfs_folio_end=
_lock_bitmap(), which clears the locked bitmap bits before unlocking.&nbsp;=
 For non-subpage configurations, btrfs_folio_end_lock_bitmap() falls throug=
h to plain folio_unlock(), so behavior
 is unchanged.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">This affects subpage configurations (sectorsize &lt;=
 PAGE_SIZE, e.g. 4K sector on 64K-page ARM64) when the cow_fixup path trigg=
ers, which happens when a page is dirtied via GUP/pin_user_pages without go=
ing through the filesystem.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I also wrote a standalone bitmap state machine simul=
ation that reproduces the invariant violation and verifies the fix:<o:p></o=
:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">&nbsp; tools/testing/btrfs/test-subpage-cow-fixup.c<=
o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">&nbsp; $ cc -o test tools/testing/btrfs/test-subpage=
-cow-fixup.c &amp;&amp; ./test<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp; TEST 1: Buggy path (folio_unlock)&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; ... PASS (bug reproduced)<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp; TEST 2: Fixed path (end_lock_bitmap)&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ... PASS<o:=
p></o:p></p>
<p class=3D"MsoNormal">&nbsp; TEST 3: Non-subpage path (both behave)&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ... PASS<o:p></o:p></=
p>
<p class=3D"MsoNormal">&nbsp; TEST 4: Partial async + cow_fixup (buggy)&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ... PASS (bug reproduced)<o:p></o:p>=
</p>
<p class=3D"MsoNormal">&nbsp; TEST 5: Partial async + cow_fixup (fixed)&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ... PASS<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Please review.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks,<o:p></o:p></p>
<p class=3D"MsoNormal">Werner<o:p></o:p></p>
</div>
</body>
</html>

--_000_ME0P300MB0853F6FA6D7872D77E98338CBD40AME0P300MB0853AUSP_--

--_005_ME0P300MB0853F6FA6D7872D77E98338CBD40AME0P300MB0853AUSP_
Content-Type: application/octet-stream;
	name="0001-btrfs-fix-subpage-locked-bitmap-leak-in-cow_fixup-wr.patch"
Content-Description:
 0001-btrfs-fix-subpage-locked-bitmap-leak-in-cow_fixup-wr.patch
Content-Disposition: attachment;
	filename="0001-btrfs-fix-subpage-locked-bitmap-leak-in-cow_fixup-wr.patch";
	size=2605; creation-date="Mon, 16 Mar 2026 09:55:39 GMT";
	modification-date="Mon, 16 Mar 2026 09:57:11 GMT"
Content-Transfer-Encoding: base64

RnJvbSA0MDQwMjg1ZTM1OWM1MzI5MDRlNDI5Y2I1NDc0ZTEwMDAzMWJjNzBkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXZXJuZXIgS2Fzc2VsbWFuIDx3ZXJuZXJAdmVyaXZ1cy5jb20+
CkRhdGU6IE1vbiwgMTYgTWFyIDIwMjYgMDk6NDI6NTMgKzAwMDAKU3ViamVjdDogW1BBVENIXSBi
dHJmczogZml4IHN1YnBhZ2UgbG9ja2VkIGJpdG1hcCBsZWFrIGluIGNvd19maXh1cCB3cml0ZWJh
Y2sKIHBhdGgKCndyaXRlcGFnZV9kZWxhbGxvYygpIG1hcmtzIGFsbCBkaXJ0eSBzZWN0b3JzIGFz
IGxvY2tlZCB2aWEKYnRyZnNfZm9saW9fc2V0X2xvY2soKSwgc2V0dGluZyBiaXRzIGluIHRoZSBz
dWJwYWdlIGxvY2tlZCBiaXRtYXAgYW5kCmluY3JlbWVudGluZyBucl9sb2NrZWQuICBUaGVzZSBh
cmUgY2xlYW5lZCB1cCBieQpidHJmc19mb2xpb19lbmRfbG9ja19iaXRtYXAoKSBhdCB0aGUgZW5k
IG9mIGV4dGVudF93cml0ZXBhZ2UoKS4KCkhvd2V2ZXIsIHdoZW4gYnRyZnNfd3JpdGVwYWdlX2Nv
d19maXh1cCgpIHJldHVybnMgLUVBR0FJTiBpbnNpZGUKZXh0ZW50X3dyaXRlcGFnZV9pbygpLCB0
aGUgY29kZSBjYWxscyBmb2xpb191bmxvY2soKSBkaXJlY3RseSBhbmQKcmV0dXJucyAxLCBjYXVz
aW5nIGV4dGVudF93cml0ZXBhZ2UoKSB0byBza2lwIHRoZSBiaXRtYXAgY2xlYW51cDoKCiAgICBy
ZXQgPSBidHJmc193cml0ZXBhZ2VfY293X2ZpeHVwKGZvbGlvKTsKICAgIGlmIChyZXQgPT0gLUVB
R0FJTikgewogICAgICAgIGZvbGlvX3JlZGlydHlfZm9yX3dyaXRlcGFnZShiaW9fY3RybC0+d2Jj
LCBmb2xpbyk7CiAgICAgICAgZm9saW9fdW5sb2NrKGZvbGlvKTsgICAgIC8vIGRvZXNuJ3QgY2xl
YXIgbG9ja2VkIGJpdG1hcAogICAgICAgIHJldHVybiAxOyAgICAgICAgICAgICAgICAvLyBjYWxs
ZXIgc2tpcHMgZW5kX2xvY2tfYml0bWFwKCkKICAgIH0KClRoaXMgbGVhdmVzIHRoZSBzdWJwYWdl
IGxvY2tlZCBiaXRtYXAgYml0cyBhbmQgbnJfbG9ja2VkIGNvdW50ZXIKZWxldmF0ZWQuICBXaGVu
IHdyaXRlYmFjayByZXRyaWVzIHRoZSBmb2xpbywgd3JpdGVwYWdlX2RlbGFsbG9jKCkgY2FsbHMK
YnRyZnNfZm9saW9fc2V0X2xvY2soKSBmb3IgdGhlIHNhbWUgc2VjdG9ycywgd2hpY2ggaGl0cyB0
aGUgQVNTRVJUIGF0CnN1YnBhZ2UuYzo3NDYgYmVjYXVzZSB0aGUgYml0cyBhcmUgc3RpbGwgc2V0
IGZyb20gdGhlIHByZXZpb3VzIGF0dGVtcHQuCgpGaXggdGhpcyBieSByZXBsYWNpbmcgZm9saW9f
dW5sb2NrKCkgd2l0aCBidHJmc19mb2xpb19lbmRfbG9ja19iaXRtYXAoKSwKd2hpY2ggcHJvcGVy
bHkgY2xlYXJzIHRoZSBsb2NrZWQgYml0bWFwIGJpdHMgYmVmb3JlIHVubG9ja2luZy4gIEZvcgpu
b24tc3VicGFnZSBvciB3aGVuIG5yX2xvY2tlZCBpcyAwIChlLmcuIGNhbGxlZCBmcm9tCmV4dGVu
dF93cml0ZV9sb2NrZWRfcmFuZ2UoKSksIGJ0cmZzX2ZvbGlvX2VuZF9sb2NrX2JpdG1hcCgpIGZh
bGxzCnRocm91Z2ggdG8gcGxhaW4gZm9saW9fdW5sb2NrKCksIHNvIGV4aXN0aW5nIGJlaGF2aW9y
IGlzIHByZXNlcnZlZC4KCkZpeGVzOiBjOTZkMGUzOTIxNDEgKCJidHJmczogbWFyayBhbGwgZGly
dHkgc2VjdG9ycyBhcyBsb2NrZWQgaW5zaWRlIHdyaXRlcGFnZV9kZWxhbGxvYygpIikKQ0M6IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogV2VybmVyIEthc3NlbG1hbiA8d2Vy
bmVyQHZlcml2dXMuY29tPgoKQ28tQXV0aG9yZWQtQnk6IENsYXVkZSBPcHVzIDQuNiAoMU0gY29u
dGV4dCkgPG5vcmVwbHlAYW50aHJvcGljLmNvbT4KLS0tCiBmcy9idHJmcy9leHRlbnRfaW8uYyB8
IDggKysrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkKCmRpZmYgLS1naXQgYS9mcy9idHJmcy9leHRlbnRfaW8uYyBiL2ZzL2J0cmZzL2V4dGVudF9p
by5jCmluZGV4IDVmOTdhM2QyYThkNy4uYzdiMjVlNDE1NDk4IDEwMDY0NAotLS0gYS9mcy9idHJm
cy9leHRlbnRfaW8uYworKysgYi9mcy9idHJmcy9leHRlbnRfaW8uYwpAQCAtMTc0Niw3ICsxNzQ2
LDEzIEBAIHN0YXRpYyBub2lubGluZV9mb3Jfc3RhY2sgaW50IGV4dGVudF93cml0ZXBhZ2VfaW8o
c3RydWN0IGJ0cmZzX2lub2RlICppbm9kZSwKIAlpZiAocmV0ID09IC1FQUdBSU4pIHsKIAkJLyog
Rml4dXAgd29ya2VyIHdpbGwgcmVxdWV1ZSAqLwogCQlmb2xpb19yZWRpcnR5X2Zvcl93cml0ZXBh
Z2UoYmlvX2N0cmwtPndiYywgZm9saW8pOwotCQlmb2xpb191bmxvY2soZm9saW8pOworCQkvKgor
CQkgKiBGb3Igc3VicGFnZSBjYXNlLCB3cml0ZXBhZ2VfZGVsYWxsb2MoKSBtYXkgaGF2ZSBzZXQg
bG9ja2VkCisJCSAqIGJpdG1hcCBiaXRzIGZvciB0aGlzIGZvbGlvLiAgV2UgbmVlZCB0byBjbGVh
ciB0aGVtIG9yCisJCSAqIGJ0cmZzX2ZvbGlvX3NldF9sb2NrKCkgd2lsbCBBU1NFUlQgd2hlbiB3
cml0ZWJhY2sgcmV0cmllcy4KKwkJICovCisJCWJ0cmZzX2ZvbGlvX2VuZF9sb2NrX2JpdG1hcChm
c19pbmZvLCBmb2xpbywKKwkJCQkJICAgIGJpb19jdHJsLT5zdWJtaXRfYml0bWFwKTsKIAkJcmV0
dXJuIDE7CiAJfQogCWlmIChyZXQgPCAwKSB7Ci0tIAoyLjQzLjAKCg==

--_005_ME0P300MB0853F6FA6D7872D77E98338CBD40AME0P300MB0853AUSP_
Content-Type: text/plain; name="test-subpage-cow-fixup.c"
Content-Description: test-subpage-cow-fixup.c
Content-Disposition: attachment; filename="test-subpage-cow-fixup.c";
	size=9314; creation-date="Mon, 16 Mar 2026 09:55:43 GMT";
	modification-date="Mon, 16 Mar 2026 09:57:11 GMT"
Content-Transfer-Encoding: base64

Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKLyoKICogU3RhbmRhbG9uZSB0ZXN0
IGZvciBidHJmcyBzdWJwYWdlIGxvY2tlZCBiaXRtYXAgbGVhayBpbiBjb3dfZml4dXAgcGF0aC4K
ICoKICogU2ltdWxhdGVzIHRoZSBiaXRtYXAgc3RhdGUgbWFjaGluZSBmcm9tIGZzL2J0cmZzL3N1
YnBhZ2UuYyBhbmQgdGhlCiAqIHdyaXRlYmFjayBzZXF1ZW5jZSBmcm9tIGZzL2J0cmZzL2V4dGVu
dF9pby5jIHRvIGRlbW9uc3RyYXRlIHRoYXQKICogZm9saW9fdW5sb2NrKCkgaW4gZXh0ZW50X3dy
aXRlcGFnZV9pbygpJ3MgLUVBR0FJTiBwYXRoIGxlYWtzIGxvY2tlZAogKiBiaXRtYXAgYml0cywg
Y2F1c2luZyBhbiBBU1NFUlQgaW4gYnRyZnNfZm9saW9fc2V0X2xvY2soKSBvbiByZXRyeS4KICoK
ICogVXNhZ2U6CiAqICAgY2MgLW8gdGVzdC1zdWJwYWdlLWNvdy1maXh1cCB0ZXN0LXN1YnBhZ2Ut
Y293LWZpeHVwLmMgJiYgLi90ZXN0LXN1YnBhZ2UtY293LWZpeHVwCiAqCiAqIEV4cGVjdGVkIG91
dHB1dDoKICogICBURVNUIDE6IEJ1Z2d5IHBhdGggKGZvbGlvX3VubG9jaykgICAgICAgIC4uLiBG
QUlMIChsZWFrZWQgYml0bWFwIHN0YXRlKQogKiAgIFRFU1QgMjogRml4ZWQgcGF0aCAoZW5kX2xv
Y2tfYml0bWFwKSAgICAgIC4uLiBQQVNTCiAqICAgVEVTVCAzOiBOb24tc3VicGFnZSBwYXRoIChi
b3RoIGJlaGF2ZSkgICAgLi4uIFBBU1MKICogICBURVNUIDQ6IFBhcnRpYWwgYXN5bmMgKyBjb3df
Zml4dXAgKGJ1Z2d5KSAuLi4gRkFJTCAobGVha2VkIGJpdG1hcCBzdGF0ZSkKICogICBURVNUIDU6
IFBhcnRpYWwgYXN5bmMgKyBjb3dfZml4dXAgKGZpeGVkKSAuLi4gUEFTUwogKi8KCiNpbmNsdWRl
IDxzdGRpby5oPgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1
ZGUgPHN0ZGJvb2wuaD4KI2luY2x1ZGUgPGFzc2VydC5oPgoKLyoKICogTWluaW1hbCBzaW11bGF0
aW9uIG9mIHN0cnVjdCBidHJmc19mb2xpb19zdGF0ZSBmcm9tIGZzL2J0cmZzL3N1YnBhZ2UuaC4K
ICoKICogSW4gdGhlIGtlcm5lbCwgYml0bWFwc1tdIGhvbGRzIGludGVybGVhdmVkIHBlci10eXBl
IGJpdG1hcHMgKHVwdG9kYXRlLAogKiBkaXJ0eSwgd3JpdGViYWNrLCBvcmRlcmVkLCBjaGVja2Vk
LCBsb2NrZWQpLiAgV2Ugb25seSBtb2RlbCB0aGUgbG9ja2VkCiAqIGJpdG1hcCBzaW5jZSB0aGF0
J3Mgd2hhdCB0aGUgYnVnIGFmZmVjdHMuCiAqLwojZGVmaW5lIFNFQ1RPUlNfUEVSX1BBR0UJMTYJ
LyogNjRLIHBhZ2UgLyA0SyBzZWN0b3IgKi8KI2RlZmluZSBCSVRNQVBfTlJfTE9DS0VECTUJLyog
YnRyZnNfYml0bWFwX25yX2xvY2tlZCAqLwoKc3RydWN0IHNpbV9mb2xpb19zdGF0ZSB7CglpbnQg
bnJfbG9ja2VkOwoJdW5zaWduZWQgbG9uZyBiaXRtYXBzWzFdOwkvKiBzaW1wbGlmaWVkOiBvbmUg
dW5zaWduZWQgbG9uZyBpcyBlbm91Z2ggKi8KCWJvb2wgZm9saW9fbG9ja2VkOwp9OwoKLyogQml0
IG9mZnNldCBmb3IgdGhlIGxvY2tlZCBiaXRtYXAgc2VnbWVudC4gKi8Kc3RhdGljIGlubGluZSBp
bnQgbG9ja2VkX3N0YXJ0X2JpdCh2b2lkKQp7CglyZXR1cm4gU0VDVE9SU19QRVJfUEFHRSAqIEJJ
VE1BUF9OUl9MT0NLRUQ7Cn0KCi8qCiAqIFNpbXVsYXRlcyBidHJmc19mb2xpb19zZXRfbG9jaygp
IGZyb20gc3VicGFnZS5jOjcyNi03NTEuCiAqIFNldHMgbG9ja2VkIGJpdG1hcCBiaXRzIGFuZCBp
bmNyZW1lbnRzIG5yX2xvY2tlZC4KICogUmV0dXJucyBmYWxzZSBpZiBBU1NFUlQgd291bGQgZmly
ZSAoYml0cyBhbHJlYWR5IHNldCkuCiAqLwpzdGF0aWMgYm9vbCBzaW1fZm9saW9fc2V0X2xvY2so
c3RydWN0IHNpbV9mb2xpb19zdGF0ZSAqYmZzLAoJCQkgICAgICAgdW5zaWduZWQgbG9uZyBzdWJt
aXRfYml0bWFwKQp7CglpbnQgc3RhcnQgPSBsb2NrZWRfc3RhcnRfYml0KCk7CgoJZm9yIChpbnQg
Yml0ID0gMDsgYml0IDwgU0VDVE9SU19QRVJfUEFHRTsgYml0KyspIHsKCQlpZiAoIShzdWJtaXRf
Yml0bWFwICYgKDFVTCA8PCBiaXQpKSkKCQkJY29udGludWU7CgkJLyogVGhpcyBpcyB0aGUgQVNT
RVJUIGF0IHN1YnBhZ2UuYzo3NDQtNzQ2LiAqLwoJCWlmIChiZnMtPmJpdG1hcHNbMF0gJiAoMVVM
IDw8IChiaXQgKyBzdGFydCkpKSB7CgkJCS8qIEFTU0VSVCBmaXJlczogYml0IGFscmVhZHkgc2V0
IGZyb20gcHJldmlvdXMgYXR0ZW1wdCAqLwoJCQlyZXR1cm4gZmFsc2U7CgkJfQoJCWJmcy0+Yml0
bWFwc1swXSB8PSAoMVVMIDw8IChiaXQgKyBzdGFydCkpOwoJCWJmcy0+bnJfbG9ja2VkKys7Cgl9
CglyZXR1cm4gdHJ1ZTsKfQoKLyoKICogU2ltdWxhdGVzIGJ0cmZzX2ZvbGlvX2VuZF9sb2NrX2Jp
dG1hcCgpIGZyb20gc3VicGFnZS5jOjMwNy0zNDEuCiAqIENsZWFycyBsb2NrZWQgYml0bWFwIGJp
dHMgYW5kIGRlY3JlbWVudHMgbnJfbG9ja2VkLgogKiBVbmxvY2tzIGZvbGlvIGlmIG5yX2xvY2tl
ZCByZWFjaGVzIDAuCiAqLwpzdGF0aWMgdm9pZCBzaW1fZm9saW9fZW5kX2xvY2tfYml0bWFwKHN0
cnVjdCBzaW1fZm9saW9fc3RhdGUgKmJmcywKCQkJCSAgICAgIHVuc2lnbmVkIGxvbmcgYml0bWFw
LCBib29sIGlzX3N1YnBhZ2UpCnsKCWludCBzdGFydCA9IGxvY2tlZF9zdGFydF9iaXQoKTsKCWlu
dCBjbGVhcmVkID0gMDsKCgkvKiBOb24tc3VicGFnZToganVzdCB1bmxvY2suIChzdWJwYWdlLmM6
MzE4LTMyMCkgKi8KCWlmICghaXNfc3VicGFnZSkgewoJCWJmcy0+Zm9saW9fbG9ja2VkID0gZmFs
c2U7CgkJcmV0dXJuOwoJfQoKCS8qIG5yX2xvY2tlZCA9PSAwOiBwbGFpbiBsb2NrX3BhZ2UoKSBj
YXNlLiAoc3VicGFnZS5jOjMyMy0zMjYpICovCglpZiAoYmZzLT5ucl9sb2NrZWQgPT0gMCkgewoJ
CWJmcy0+Zm9saW9fbG9ja2VkID0gZmFsc2U7CgkJcmV0dXJuOwoJfQoKCS8qIENsZWFyIGJpdHMg
YW5kIGNvdW50LiAoc3VicGFnZS5jOjMyOS0zMzcpICovCglmb3IgKGludCBiaXQgPSAwOyBiaXQg
PCBTRUNUT1JTX1BFUl9QQUdFOyBiaXQrKykgewoJCWlmICghKGJpdG1hcCAmICgxVUwgPDwgYml0
KSkpCgkJCWNvbnRpbnVlOwoJCWlmIChiZnMtPmJpdG1hcHNbMF0gJiAoMVVMIDw8IChiaXQgKyBz
dGFydCkpKSB7CgkJCWJmcy0+Yml0bWFwc1swXSAmPSB+KDFVTCA8PCAoYml0ICsgc3RhcnQpKTsK
CQkJY2xlYXJlZCsrOwoJCX0KCX0KCglhc3NlcnQoYmZzLT5ucl9sb2NrZWQgPj0gY2xlYXJlZCk7
CgliZnMtPm5yX2xvY2tlZCAtPSBjbGVhcmVkOwoJaWYgKGJmcy0+bnJfbG9ja2VkID09IDApCgkJ
YmZzLT5mb2xpb19sb2NrZWQgPSBmYWxzZTsKfQoKLyogU2ltdWxhdGVzIHBsYWluIGZvbGlvX3Vu
bG9jaygpIC0tIGRvZXMgTk9UIHRvdWNoIGJpdG1hcCBzdGF0ZS4gKi8Kc3RhdGljIHZvaWQgc2lt
X2ZvbGlvX3VubG9jayhzdHJ1Y3Qgc2ltX2ZvbGlvX3N0YXRlICpiZnMpCnsKCWJmcy0+Zm9saW9f
bG9ja2VkID0gZmFsc2U7Cn0KCnN0YXRpYyB2b2lkIGluaXRfZm9saW8oc3RydWN0IHNpbV9mb2xp
b19zdGF0ZSAqYmZzKQp7CgltZW1zZXQoYmZzLCAwLCBzaXplb2YoKmJmcykpOwoJYmZzLT5mb2xp
b19sb2NrZWQgPSB0cnVlOwp9CgpzdGF0aWMgYm9vbCBiaXRtYXBfaXNfY2xlYW4oc3RydWN0IHNp
bV9mb2xpb19zdGF0ZSAqYmZzKQp7CglyZXR1cm4gYmZzLT5ucl9sb2NrZWQgPT0gMCAmJiBiZnMt
PmJpdG1hcHNbMF0gPT0gMDsKfQoKLyoKICogVEVTVCAxOiBCdWdneSBwYXRoIC0tIGZvbGlvX3Vu
bG9jaygpIGluIGNvd19maXh1cCAtRUFHQUlOLgogKgogKiBTZXF1ZW5jZToKICogICB3cml0ZXBh
Z2VfZGVsYWxsb2M6MTQ2OCAgYnRyZnNfZm9saW9fc2V0X2xvY2soc3VibWl0X2JpdG1hcCkKICog
ICBleHRlbnRfd3JpdGVwYWdlX2lvOjE3NDUgYnRyZnNfd3JpdGVwYWdlX2Nvd19maXh1cCgpIHJl
dHVybnMgLUVBR0FJTgogKiAgIGV4dGVudF93cml0ZXBhZ2VfaW86MTc0OSBmb2xpb191bmxvY2so
KSAgICAgICAgICAgPC0tIEJVRzogc2tpcHMgYml0bWFwCiAqICAgZXh0ZW50X3dyaXRlcGFnZTox
OTAyICAgIHJldHVybiAwICAgICAgICAgICAgICAgICAgPC0tIHNraXBzIGNsZWFudXAKICogICAu
Li4gZml4dXAgd29ya2VyIGNvbXBsZXRlcywgd3JpdGViYWNrIHJldHJpZXMgLi4uCiAqICAgd3Jp
dGVwYWdlX2RlbGFsbG9jOjE0NjggIGJ0cmZzX2ZvbGlvX3NldF9sb2NrKCkgICA8LS0gQVNTRVJU
IGZpcmVzCiAqLwpzdGF0aWMgaW50IHRlc3RfYnVnZ3lfY293X2ZpeHVwKHZvaWQpCnsKCXN0cnVj
dCBzaW1fZm9saW9fc3RhdGUgYmZzOwoJdW5zaWduZWQgbG9uZyBzdWJtaXRfYml0bWFwID0gMHgw
MDBmOwkvKiA0IGRpcnR5IHNlY3RvcnMgKi8KCgkvKiBGaXJzdCB3cml0ZWJhY2sgYXR0ZW1wdC4g
Ki8KCWluaXRfZm9saW8oJmJmcyk7CglzaW1fZm9saW9fc2V0X2xvY2soJmJmcywgc3VibWl0X2Jp
dG1hcCk7CgoJLyogY293X2ZpeHVwIHJldHVybnMgLUVBR0FJTiwgYnVnZ3kgcGF0aCB1c2VzIGZv
bGlvX3VubG9jaygpLiAqLwoJc2ltX2ZvbGlvX3VubG9jaygmYmZzKTsKCgkvKiBGb2xpbyBpcyB1
bmxvY2tlZCBidXQgYml0bWFwIHN0YXRlIGxlYWtlZC4gKi8KCWlmIChiZnMubnJfbG9ja2VkICE9
IDAgfHwgYmZzLmJpdG1hcHNbMF0gIT0gMCkgewoJCS8qIFdyaXRlYmFjayByZXRyaWVzOiBidHJm
c19mb2xpb19zZXRfbG9jaygpIG9uIHNhbWUgYml0cy4gKi8KCQliZnMuZm9saW9fbG9ja2VkID0g
dHJ1ZTsKCQlpZiAoIXNpbV9mb2xpb19zZXRfbG9jaygmYmZzLCBzdWJtaXRfYml0bWFwKSkgewoJ
CQkvKiBBU1NFUlQgZmlyZWQgLS0gYnVnIHJlcHJvZHVjZWQuICovCgkJCXJldHVybiAxOwoJCX0K
CX0KCXJldHVybiAwOwp9CgovKgogKiBURVNUIDI6IEZpeGVkIHBhdGggLS0gYnRyZnNfZm9saW9f
ZW5kX2xvY2tfYml0bWFwKCkgaW4gY293X2ZpeHVwIC1FQUdBSU4uCiAqCiAqIFNhbWUgc2VxdWVu
Y2UgYnV0IHdpdGggdGhlIHBhdGNoZWQgY29kZS4KICovCnN0YXRpYyBpbnQgdGVzdF9maXhlZF9j
b3dfZml4dXAodm9pZCkKewoJc3RydWN0IHNpbV9mb2xpb19zdGF0ZSBiZnM7Cgl1bnNpZ25lZCBs
b25nIHN1Ym1pdF9iaXRtYXAgPSAweDAwMGY7CgoJaW5pdF9mb2xpbygmYmZzKTsKCXNpbV9mb2xp
b19zZXRfbG9jaygmYmZzLCBzdWJtaXRfYml0bWFwKTsKCgkvKiBjb3dfZml4dXAgcmV0dXJucyAt
RUFHQUlOLCBmaXhlZCBwYXRoIHVzZXMgZW5kX2xvY2tfYml0bWFwKCkuICovCglzaW1fZm9saW9f
ZW5kX2xvY2tfYml0bWFwKCZiZnMsIHN1Ym1pdF9iaXRtYXAsIHRydWUpOwoKCS8qIEJpdG1hcCBz
dGF0ZSBzaG91bGQgYmUgY2xlYW4uICovCglpZiAoIWJpdG1hcF9pc19jbGVhbigmYmZzKSkKCQly
ZXR1cm4gMDsJLyogZmFpbDogc3RhdGUgbm90IGNsZWFuICovCgoJLyogV3JpdGViYWNrIHJldHJp
ZXM6IGJ0cmZzX2ZvbGlvX3NldF9sb2NrKCkgc2hvdWxkIHN1Y2NlZWQuICovCgliZnMuZm9saW9f
bG9ja2VkID0gdHJ1ZTsKCWlmICghc2ltX2ZvbGlvX3NldF9sb2NrKCZiZnMsIHN1Ym1pdF9iaXRt
YXApKQoJCXJldHVybiAwOwkvKiBmYWlsOiBBU1NFUlQgd291bGQgZmlyZSAqLwoKCS8qIENsZWFu
IHVwIGFuZCB2ZXJpZnkuICovCglzaW1fZm9saW9fZW5kX2xvY2tfYml0bWFwKCZiZnMsIHN1Ym1p
dF9iaXRtYXAsIHRydWUpOwoJcmV0dXJuIGJpdG1hcF9pc19jbGVhbigmYmZzKSA/IDEgOiAwOwp9
CgovKgogKiBURVNUIDM6IE5vbi1zdWJwYWdlIC0tIGJvdGggcGF0aHMgYmVoYXZlIGlkZW50aWNh
bGx5LgogKgogKiBGb3Igbm9uLXN1YnBhZ2UsIGJ0cmZzX2ZvbGlvX3NldF9sb2NrKCkgaXMgbmV2
ZXIgY2FsbGVkLCBzbyBucl9sb2NrZWQgPT0gMC4KICogQm90aCBmb2xpb191bmxvY2soKSBhbmQg
YnRyZnNfZm9saW9fZW5kX2xvY2tfYml0bWFwKCkganVzdCB1bmxvY2suCiAqLwpzdGF0aWMgaW50
IHRlc3Rfbm9uX3N1YnBhZ2Uodm9pZCkKewoJc3RydWN0IHNpbV9mb2xpb19zdGF0ZSBiZnM7Cgl1
bnNpZ25lZCBsb25nIHN1Ym1pdF9iaXRtYXAgPSAweDAwMDE7CS8qIHNpbmdsZSBwYWdlID0gMSBi
aXQgKi8KCgkvKiBOb24tc3VicGFnZTogbm8gYnRyZnNfZm9saW9fc2V0X2xvY2soKSBjYWxsLiAq
LwoJaW5pdF9mb2xpbygmYmZzKTsKCgkvKiBCb3RoIHBhdGhzIHNob3VsZCBqdXN0IHVubG9jay4g
Ki8KCXNpbV9mb2xpb19lbmRfbG9ja19iaXRtYXAoJmJmcywgc3VibWl0X2JpdG1hcCwgZmFsc2Up
OwoJaWYgKGJmcy5mb2xpb19sb2NrZWQpCgkJcmV0dXJuIDA7CgoJaW5pdF9mb2xpbygmYmZzKTsK
CXNpbV9mb2xpb191bmxvY2soJmJmcyk7CglpZiAoYmZzLmZvbGlvX2xvY2tlZCkKCQlyZXR1cm4g
MDsKCglyZXR1cm4gMTsKfQoKLyoKICogVEVTVCA0OiBQYXJ0aWFsIGFzeW5jICsgY293X2ZpeHVw
IChidWdneSkuCiAqCiAqIHdyaXRlcGFnZV9kZWxhbGxvYygpIGhhbmRsZXMgc2VjdG9ycyAwLTMg
dmlhIGNvbXByZXNzaW9uIChhc3luYywgcmV0ID4gMCksCiAqIGNsZWFycyB0aG9zZSBmcm9tIHN1
Ym1pdF9iaXRtYXAuICBTZWN0b3JzIDQtNyByZW1haW4gaW4gc3VibWl0X2JpdG1hcC4KICogVGhl
biBjb3dfZml4dXAgZmlyZXMgYW5kIHRoZSBidWdneSBwYXRoIGxlYWtzIHNlY3RvcnMgNC03J3Mg
bG9ja2VkIGJpdHMuCiAqLwpzdGF0aWMgaW50IHRlc3RfcGFydGlhbF9hc3luY19idWdneSh2b2lk
KQp7CglzdHJ1Y3Qgc2ltX2ZvbGlvX3N0YXRlIGJmczsKCXVuc2lnbmVkIGxvbmcgc3VibWl0X2Jp
dG1hcCA9IDB4MDBmZjsJLyogOCBkaXJ0eSBzZWN0b3JzICovCgl1bnNpZ25lZCBsb25nIGFzeW5j
X2JpdHMgICAgPSAweDAwMGY7CS8qIHNlY3RvcnMgMC0zIGFzeW5jICovCgoJaW5pdF9mb2xpbygm
YmZzKTsKCXNpbV9mb2xpb19zZXRfbG9jaygmYmZzLCBzdWJtaXRfYml0bWFwKTsKCgkvKiBBc3lu
YyBwYXRoIGNsZWFycyBpdHMgYml0cyBmcm9tIHN1Ym1pdF9iaXRtYXAuICovCglzdWJtaXRfYml0
bWFwICY9IH5hc3luY19iaXRzOwoKCS8qIEFzeW5jIGNvbXBsZXRpb24gY2xlYXJzIGl0cyBsb2Nr
ZWQgYml0cy4gKi8KCXNpbV9mb2xpb19lbmRfbG9ja19iaXRtYXAoJmJmcywgYXN5bmNfYml0cywg
dHJ1ZSk7CgkvKiBGb2xpbyBzdGlsbCBsb2NrZWQgLS0gc2VjdG9ycyA0LTcgcmVtYWluLiAqLwoJ
YXNzZXJ0KGJmcy5mb2xpb19sb2NrZWQpOwoJYXNzZXJ0KGJmcy5ucl9sb2NrZWQgPT0gNCk7CgoJ
LyogY293X2ZpeHVwIC1FQUdBSU4sIGJ1Z2d5IHBhdGguICovCglzaW1fZm9saW9fdW5sb2NrKCZi
ZnMpOwoKCS8qIDQgbG9ja2VkIGJpdHMgbGVha2VkLiAqLwoJaWYgKGJmcy5ucl9sb2NrZWQgIT0g
NCkKCQlyZXR1cm4gMDsKCgkvKiBSZXRyeSBoaXRzIEFTU0VSVC4gKi8KCWJmcy5mb2xpb19sb2Nr
ZWQgPSB0cnVlOwoJaWYgKCFzaW1fZm9saW9fc2V0X2xvY2soJmJmcywgMHgwMGZmKSkKCQlyZXR1
cm4gMTsJLyogQVNTRVJUIGZpcmVkIC0tIGJ1ZyByZXByb2R1Y2VkICovCgoJcmV0dXJuIDA7Cn0K
Ci8qCiAqIFRFU1QgNTogUGFydGlhbCBhc3luYyArIGNvd19maXh1cCAoZml4ZWQpLgogKgogKiBT
YW1lIGFzIHRlc3QgNCBidXQgd2l0aCB0aGUgZml4ZWQgY29kZSBwYXRoLgogKi8Kc3RhdGljIGlu
dCB0ZXN0X3BhcnRpYWxfYXN5bmNfZml4ZWQodm9pZCkKewoJc3RydWN0IHNpbV9mb2xpb19zdGF0
ZSBiZnM7Cgl1bnNpZ25lZCBsb25nIHN1Ym1pdF9iaXRtYXAgPSAweDAwZmY7Cgl1bnNpZ25lZCBs
b25nIGFzeW5jX2JpdHMgICAgPSAweDAwMGY7CgoJaW5pdF9mb2xpbygmYmZzKTsKCXNpbV9mb2xp
b19zZXRfbG9jaygmYmZzLCBzdWJtaXRfYml0bWFwKTsKCglzdWJtaXRfYml0bWFwICY9IH5hc3lu
Y19iaXRzOwoKCS8qIEFzeW5jIGNvbXBsZXRpb24uICovCglzaW1fZm9saW9fZW5kX2xvY2tfYml0
bWFwKCZiZnMsIGFzeW5jX2JpdHMsIHRydWUpOwoJYXNzZXJ0KGJmcy5mb2xpb19sb2NrZWQpOwoJ
YXNzZXJ0KGJmcy5ucl9sb2NrZWQgPT0gNCk7CgoJLyogY293X2ZpeHVwIC1FQUdBSU4sIGZpeGVk
IHBhdGggY2xlYXJzIHJlbWFpbmluZyBiaXRzLiAqLwoJc2ltX2ZvbGlvX2VuZF9sb2NrX2JpdG1h
cCgmYmZzLCBzdWJtaXRfYml0bWFwLCB0cnVlKTsKCglpZiAoIWJpdG1hcF9pc19jbGVhbigmYmZz
KSkKCQlyZXR1cm4gMDsKCWlmIChiZnMuZm9saW9fbG9ja2VkKQoJCXJldHVybiAwOwoKCS8qIFJl
dHJ5IHN1Y2NlZWRzLiAqLwoJYmZzLmZvbGlvX2xvY2tlZCA9IHRydWU7CglpZiAoIXNpbV9mb2xp
b19zZXRfbG9jaygmYmZzLCAweDAwZmYpKQoJCXJldHVybiAwOwoKCXNpbV9mb2xpb19lbmRfbG9j
a19iaXRtYXAoJmJmcywgMHgwMGZmLCB0cnVlKTsKCXJldHVybiBiaXRtYXBfaXNfY2xlYW4oJmJm
cykgPyAxIDogMDsKfQoKc3RydWN0IHRlc3RfY2FzZSB7Cgljb25zdCBjaGFyICpuYW1lOwoJaW50
ICgqZm4pKHZvaWQpOwoJYm9vbCBleHBlY3RfcGFzczsJLyogdHJ1ZSA9IGZuIHJldHVybnMgMSwg
ZmFsc2UgPSBmbiByZXR1cm5zIDEgKGJ1ZyByZXBybykgKi8KfTsKCmludCBtYWluKHZvaWQpCnsK
CXN0cnVjdCB0ZXN0X2Nhc2UgdGVzdHNbXSA9IHsKCQl7ICJCdWdneSBwYXRoIChmb2xpb191bmxv
Y2spIiwJCXRlc3RfYnVnZ3lfY293X2ZpeHVwLAkgICBmYWxzZSB9LAoJCXsgIkZpeGVkIHBhdGgg
KGVuZF9sb2NrX2JpdG1hcCkiLAl0ZXN0X2ZpeGVkX2Nvd19maXh1cCwJICAgdHJ1ZSAgfSwKCQl7
ICJOb24tc3VicGFnZSBwYXRoIChib3RoIGJlaGF2ZSkiLAl0ZXN0X25vbl9zdWJwYWdlLAkgICB0
cnVlICB9LAoJCXsgIlBhcnRpYWwgYXN5bmMgKyBjb3dfZml4dXAgKGJ1Z2d5KSIsCXRlc3RfcGFy
dGlhbF9hc3luY19idWdneSwgIGZhbHNlIH0sCgkJeyAiUGFydGlhbCBhc3luYyArIGNvd19maXh1
cCAoZml4ZWQpIiwJdGVzdF9wYXJ0aWFsX2FzeW5jX2ZpeGVkLCAgdHJ1ZSAgfSwKCX07CglpbnQg
biA9IHNpemVvZih0ZXN0cykgLyBzaXplb2YodGVzdHNbMF0pOwoJaW50IHBhc3NlZCA9IDA7Cglp
bnQgZmFpbGVkID0gMDsKCglmb3IgKGludCBpID0gMDsgaSA8IG47IGkrKykgewoJCWludCByZXQg
PSB0ZXN0c1tpXS5mbigpOwoJCWJvb2wgb2s7CgoJCWlmICh0ZXN0c1tpXS5leHBlY3RfcGFzcykK
CQkJb2sgPSAocmV0ID09IDEpOwoJCWVsc2UKCQkJb2sgPSAocmV0ID09IDEpOwkvKiBidWctcmVw
cm8gdGVzdHMgcmV0dXJuIDEgb24gc3VjY2Vzc2Z1bCByZXBybyAqLwoKCQlwcmludGYoIlRFU1Qg
JWQ6ICUtNDBzIC4uLiAlc1xuIiwgaSArIDEsIHRlc3RzW2ldLm5hbWUsCgkJICAgICAgIG9rID8g
IlBBU1MiIDogIkZBSUwiKTsKCQlpZiAob2spCgkJCXBhc3NlZCsrOwoJCWVsc2UKCQkJZmFpbGVk
Kys7Cgl9CgoJcHJpbnRmKCJcbiVkLyVkIHRlc3RzIHBhc3NlZFxuIiwgcGFzc2VkLCBuKTsKCXJl
dHVybiBmYWlsZWQgPyAxIDogMDsKfQo=

--_005_ME0P300MB0853F6FA6D7872D77E98338CBD40AME0P300MB0853AUSP_--
