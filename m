Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211718;
	b=EPGXABRKQC+vFSOAEmB9g0ekUFSFXPB5HWg+u9fVGJnBXns+V/HP2WmCoLdWU9dafpxg
	 HS0LS7eJ/md1vXHXcOjJ/CgGimb3H/KaGa2PbGZjlHw1fE05b5zaAv/rmorEhpZUAL4dv
	 +2pGzvtEVoPMfkwBkdK4uNJ1EJf4aUAfm0Hl4/4YoV0rz9XZHah4VL45McWsMcB4Tt0TJ
	 wjDASD3BjTg41rkfgZdAkrcWPLJmy43nC0BTQoO4aNgVR0+D3NvEb1BxZBrAyBCXouK31
	 EVsuA6krn4OOccoh6Qz0W7ggUIvc7emNK5XIPpSAeQ2CBgNGB62+WCQ9wAm5ZpU/e1g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211718;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=0wsYxxhr36eGHTwEgsz1frEXu2TKnom+y4BTx9jhFVI=;
	b=2muhWbvcTFoGfA3Rn6wO7vu1VXPqj0eW2gZAMnqWCddvsGuoCi0BszvalN+k5iTepfPJ
	 QZx+2hNiA7KODKcEOrhlovI1BjY4VfEYLQoY3MDpqOAF7ujj0dpjgMtRmag4z0NyjNbn+
	 Y9qp4N3hmUOA5BRi1zjHSezQaJIHCi5A4535t+gKwQFyHfVhsLaDo3HaTd4PW3UJbXjxu
	 OlRbG0M0JgHC4Qxm+YLKxwelYI9dAJsq0wlb6pyb0caOuATpeLqPU6wKAZrG6S21GYXxT
	 rN/X4ptOjOn9B3FMv/ijn3F0g1HckT/Kh3fKqlzAFwD1HRmnCeDutxMlOeC1inyfb6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ezSp93BN;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=BjG6ZFuY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFED60A382B
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FFED60A382B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ezSp93BN;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=BjG6ZFuY
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211718; x=1824747718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=xvERhJJCNy782qsPzjoJCYGvUuHioE+ao60+mOlbh/4=;
  b=ezSp93BNN1iXEi81gGEmibwUs7Twb6Pgc6+QB4p7pmmQn6iCtCL8cb2+
   QIqU5VuQ11DykiM+gOaAmEgVPrYJ/PdiXIJyJNpA1MOkoqtkyAy8tYMtK
   l5PFbFWOQlFoEmffjUEGiSGcj3EJmUaRUvlvZAs0teaRUpVUyUcEJI2Ep
   qLTStwoudCCSpwAum4CfbLObPTbBCB1/PCjA5d37e7TaZabT2NqDsaAkj
   Hm++pdedOc8qFbqEX+h+b60zgMij/KyrWpb2r6adaUoegmPsEdpgbffMW
   rl6tjaxssGYk368/SVLSaOROL/VEJp3hWkE0v0N17+Cgy5gub9K0i9EpO
   Q==;
X-CSE-ConnectionGUID: AhMUB2QXQHyrdgMUof+Zew==
X-CSE-MsgGUID: iZurdzzcQN6rzVTiU953dA==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="159135294"
Received: from mail-eastus2azon11010002.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.2])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qgjMQlnXey/cQad6Z8W532D+XCF9qK2cfpW/Tv6/5kt+oM+KHBMJfQsv3GC/xZ5vhinHEerAPtzcyjBkn3DX9GHKH6aHqyAVyCtZOcZ/Re3PgCPMCEmpfMblgj/js5QZ6ZeI7RRGQxsstD6Rhqkg5CXAgozWBQBopdbvtoYbp0t3LvkiT/yh+I4nc7R5an+PxirDz7iMmSJArM+Z7n+4egrzVui7oytm7surXu/0Q4hGtaNNLaLpBuhsDpsj+WO/Rl5RBF7xkKDPPtftBimLrhBxkkrE4ca3BxJ5AZeBe1h7mPs9vTEvIiQdG79XquctXMDkhnlJsG22eXJMuJU2sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0wsYxxhr36eGHTwEgsz1frEXu2TKnom+y4BTx9jhFVI=;
 b=PtI9LsRFMRe9kcZujudyoAMVrQgeJ4q62c9keijD+rnQLaOT3xxvUgctNqzhu+FtOPWDwj5oFMeD34yjCePBNqrJmpD31l2sBB1qoxbJa3ZugmvzVY156HNR1NFgcAUirROUYZ8OoF97MFryc1xDAn72IIK8A9UiXlcyBlMSZdgIYi6aFwcTvURdIEGn+n+oFJyxTDq1MJs4TqIRrQYcDnF5WnL786Q+gRokspKFO26TLD/UOjdN1bmNu3ZWJtXa3NtXtBlY0NIBjLdCvpSO4eAXMHG0VgmFLeSusSdZKLRrCWZ4ItIg2h4/BXxilCOBP+of4wEV32hjveWy8TmvgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0wsYxxhr36eGHTwEgsz1frEXu2TKnom+y4BTx9jhFVI=;
 b=BjG6ZFuYDnVKI8fMePpl2vGB0562K45D59zfCbG7vn1s3UollA4F2tzBLWYTrqOLdYxqYq4ynuM8G7cIgy2h1jGCAJixfGW+ijI1E5J8bYnbLT5RoQ5gd5L6GyZ/jlE0AaD+fWw9eEIZ+516/SF7+JXoBFYo2626Qsna2aHkTsI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:55 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:55 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 23/25] btrfs: zoned: keep a zone free for relocation when allocating data chunks
Date: Wed, 28 Oct 2026 19:21:09 +0100
Message-ID: <20261028182111.160492-24-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: 6136bc84-8c6f-47f3-2d30-08df352058b7
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4r9BCpGcoU0klV/CYA3ednULcWImEwajPgqQ14cCWN8UL+6g+AxArLF7OrT6fo+fTDs42lmz3q7vVMkWkF4V7nOSYHNNuiK27jj8gqJ9TGMUpa4V8dmdQvWaz+0YCK4hh0g2HpU0we8C5FWRXXef9K5dXWiAkH8WKObNUOh1O15+9m/8LSfRQ1D2FE/nO9k11GOLPjWlHCkoOLuaU0P0rgxjNFTS0+fiEfSGVht+k4pnCYee3vRh7c4R8ANLIonyt+eFFtlWRl+bbk2+m7PY0G/BTiPsMecHrubyNwKuL1U5YzYyDt7iCvZu73ITgdKj1p090UdzGUjbtOa7Iq3lKdKtuvhDkLPG4DUumo9345BjIQeYZKlKPg2r0jk64nXi48sIwzgizFzLLTP+2GSDtoQIq9BhVZgHGOKwGNXNV45m+AdsT+ugatsVoSw3uyDhqbLTNA4OrHn5ir2hZJ/lLGnOJwZ82OR/AZ7u6Npohz10teD3tnkr0t2H3k1s9RGWpHqZhMUdD6PBGnvp48Kth8nBHg78b+WgINKjinLNX/9CqViMpgU7a6HA/Sqnn5LoAaVgCBEKm/oTHtpBcFwzwQklWbEt4yixv61KDssxhPGbOGfwKoQ6oUhqBbeX5CHxtkBuOT8OZ2ev31nQUkdfx+qRxrRSF18lAsTI71Tp01o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ftj27bBAE+mwTYL2lQK++J+5mkjBfTEOM1QOBxwyYWtVonhgF7lhcbUg8cGj?=
 =?us-ascii?Q?sKuUBQlx6x0NogFnxRi0GDXD1whWOEZ6pfpEF48sJ8rX0DWKui6P+42y1L1m?=
 =?us-ascii?Q?DJiQEPP1FiXn/9iyyiOKdHengYlcszWtxlnwZCuyKf/2w/FexvP+ka2qZOp+?=
 =?us-ascii?Q?MIZsknFh4sFvbc9xwAYZKV037JH4AFckCFQos/c1s2EHg7wFOjkXQ1GGDdq6?=
 =?us-ascii?Q?8HljSlkyAMsiMFW1tdnijWj1WwhNA1Qk8Rnq5KWVHtztee7io9h3K8lTBlK5?=
 =?us-ascii?Q?upPRyws99JhHibMniv8Z5hW5QcEgshfWVO+tfYIlL2kUacXLyjyGIIuiM7mC?=
 =?us-ascii?Q?ICUwcNXd2ZrqsNgLy9FJKF6KMYlk4SQvI+UeikcrJd9brAaNkLriWgISb4R9?=
 =?us-ascii?Q?FCVPmkpYffdMZWoKFRtmY5d0p6ZLt99CsCoARDbciIlrfDUb8dcgAUNM+4/C?=
 =?us-ascii?Q?vVM9M7WSoeypre7RrQhn3U3qt3tfXuiDlhDeo+e5e5nfp4dWR3GRvdzBzYZZ?=
 =?us-ascii?Q?BN+GidSQutF7PBZptTkulLAlr+Avn2fXF4R6OFEtd+WjT0Y7EY9pAI7pl6dy?=
 =?us-ascii?Q?wWsDEmy09x3a1QF1cVqR1mDWwXVGVH8QwrzYBm+v2czEktFQ/jmsP1BWHdcp?=
 =?us-ascii?Q?K/5wUcFgddOV3bqzIU0XDwioIwoqkctlTwyE7xBPZ0pNogqu/9iYACYPR8iq?=
 =?us-ascii?Q?FZxDdkIQ0fs3giyoGJ2mDuqBNnp5VRJFhEryA7qCQjh7A0/Y/EStR21ogNDa?=
 =?us-ascii?Q?c94ITg9MMXs4CtWJNYWIGTWJIzIwObk6dBlp2an1CM2xXXm3dYZ2N87/IXyv?=
 =?us-ascii?Q?7mqwn67QYf1ZBe3OFG+MIcDroQRRpLiC6SpJiGVMJd+k4HPQrfH4LorK31fR?=
 =?us-ascii?Q?170CedkKO8LHKqnv2b8UBoZyYusbNUIK/2ZlcsyVh918ISjTAtvwc+qrK3I1?=
 =?us-ascii?Q?XHpqi/Eq36VedekOLQ55fDjr1bwGuJZ9ZHsoCF7gQfhxW1NG13H4Ow7qWjAy?=
 =?us-ascii?Q?Z96EEP455JURTjBeZncw8SWpkq3uFGGlgvvDYWWjeQsYE1iEink5Tq4tXgFl?=
 =?us-ascii?Q?8ZHGvAA2gp1hDyc7zN2bPKb9AejOsaIMsrNRzVxk0QxBw0xdtD9XPprrE7Aw?=
 =?us-ascii?Q?4R5fOhT3duXi3I9JezjWAK4C+UrAhtKbw1LV4rp18A0tD6+aZswQfCgN3zNI?=
 =?us-ascii?Q?B8MeBIYL38dcqTFLQWQIyPr62WWhb1cj9kzsywY8O0DGI0NdbRc43HVSYW2n?=
 =?us-ascii?Q?XnBKwZcgT3JQyyh1W1euRE9uzKarUZiShP7Iju5BnqLN4NJOhJ2MfHtyQFEU?=
 =?us-ascii?Q?qQQf87V2hOrXNEDo01FHTYC4qPtRsEOzJqrj/aLQS6iIGCpsdL35wA7Zi727?=
 =?us-ascii?Q?y4RjWbn3dImNN03koKfJVqZvWSTUb60N42s9fHETIwtC0cszO2q9u4Vhc0UF?=
 =?us-ascii?Q?de3WEBsIkn7/19M+gHzJ9ccqPO17Aps30o1QXP8X9dMxbERCsqhVgXPvhULm?=
 =?us-ascii?Q?KhF7FpDwlOaB0KIzFhNmX38xsTJ4EC5gJsBzSiQbL4xvErzW/U3d1Y/Nxzol?=
 =?us-ascii?Q?WBenWcoCz1qEPnqCB7kDoaC1FboHSPJrQW15JSQhHZarD9Ranb3Xe9+L7QB/?=
 =?us-ascii?Q?l+6inoeirc+zl++Sfv7woAqrk89IoZPnLAKyDLiwh0aEteDdK08ppG4Jmk/M?=
 =?us-ascii?Q?VL9qM+54d6P9uNqIM1TSW7ns9Eywh7o/BmSnggapNe2DtT+Gy3XeZt/7lTMO?=
 =?us-ascii?Q?2U5mXy73tEWMaihDMpnCbalYS2rr4LfMOWIqHum4r1HUgtP8SvA/pYor8R3R?=
X-MS-Exchange-AntiSpam-MessageData-1: Jil0wrOeWO/qt7n1nphzHcuxR9PVA2owXcY=
X-Exchange-RoutingPolicyChecked:
	jYutZFoHCec4jrm2FDE5svk+Oj6/U1H79oMcvcNWCc0lPDmmVNMmHM1MvP32DYGsSd5880vSD9wwlGJbzj2+N4aS+na0vxIahHRNBtiERSJpUVUfB6E1r+BSYNeVkOuYO1h5nXjKWdb1mCLPZaVWXlIqAvZQ3MTPrqeVY9rNqx3BGdNh5TY4qshUWBz8xeNv7obLJoThuMSmXWUAj2k0H5h48+6XZXlRWOQvilZjakeYxLnpLvHtHa00e3KI6YheAtscRd/BPtmIwg7uw8j3oPG4bo+ENI0sidPVEcyYP+9tT7dKXhT8SH5R+yEYXCiDEeCuaIWmQF8xw/R9DAmdrg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XeKQawfuRhQdQ46sKoONBDXL1xVvUfrVMMBcHt3obvlWA09Rn+IP+nqcMH/Rcy2YdqRUHvnDBAs8+D5OIfS15roeAulUKRpXoz0JnFjHAyJn/UC70fdkkho5QG6EI5LKZr6jDRoBXGku+qsT9uSSV4axgfjw14qcIlB6zF4RX/PGOVFKz538TahDh0DF9cnsel35uDXSIFi9GXQMtT0UXjWotXtMAcAYkzk6rjcYSDMuUKVrNll/3KHEqQnIyhI4q3l66ey78fuixyGzPAMnxAvIoZOA9VQehZ8dZzITKgAsY/9/izVYfLWBInVebRcBCLD6M1WC5dA5j4Np/tTR+S0to23JBmtgbiPHgBkrQrX3xT7KgtwJu0V35InJ9MZjcDLpXXTl4rXVp0OA+pw16uqfscVLz928T+V2eegFW4jojOX3nUkTF35jHcZJSwGctXLjc1+K528WVPUVIP07cV8TbgP4lGMQVjczDDc2/jL4FmIiNQPdOYYffIYUB2UwBO8jsr1P8L+IHY+YqvLPnQHEIAYOXrlzJQZ/9O9Drp3aj6MjmEglBxXFmn2YvhAYS+vwOhUr+GB3qXuDd0+S11gQ8II3/3Dc66XDx50YFZpa8+emlpl9pmftyNZ+jSAZ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6136bc84-8c6f-47f3-2d30-08df352058b7
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:55.5417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hQQIPin5L2HANO9vsaIjdjxWAlu9PgSI7pRYGarOiNkDUVUa8dM8J/MaOvWLGSIkxGqktZ66waWyep6gD40sveO+HN5hJQe7sabAvIrH+VI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

When allocating new data chunks, make sure there is one zone free as a
relocation target.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  7 ++++++-
 fs/btrfs/zoned.c       | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  7 +++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 435af7abb340..95d29716c040 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4129,7 +4129,12 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
 			force_metadata_allocation(fs_info);
 	}
 
-	ret_bg = do_chunk_alloc(trans, space_info, flags);
+	if (!btrfs_is_zoned(fs_info) ||
+	    btrfs_zoned_data_chunk_allowed(space_info, flags))
+		ret_bg = do_chunk_alloc(trans, space_info, flags);
+	else
+		ret_bg = ERR_PTR(-ENOSPC);
+
 	trans->allocating_chunk = false;
 
 	if (IS_ERR(ret_bg)) {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a495ef1178d5..4bc5e5c3f395 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3714,3 +3714,35 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
+
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags)
+{
+	struct btrfs_fs_info *fs_info = space_info->fs_info;
+	const u64 chunk_bytes = fs_info->zone_size *
+				btrfs_bg_type_to_num_stripes(fs_info, flags);
+	struct btrfs_device *device;
+	u64 avail = 0;
+
+	ASSERT(btrfs_is_zoned(fs_info));
+
+	if (space_info != fs_info->data_sinfo)
+		return true;
+
+	lockdep_assert_held(&fs_info->chunk_mutex);
+
+	list_for_each_entry(device, &fs_info->fs_devices->alloc_list, dev_alloc_list) {
+		u64 total;
+		u64 used;
+
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) ||
+		    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
+			continue;
+
+		total = btrfs_device_get_total_bytes(device);
+		used = btrfs_device_get_bytes_used(device);
+		if (total > used)
+			avail += btrfs_zoned_dev_avail_bytes(device, total - used);
+	}
+
+	return avail >= 2 * chunk_bytes;
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 74c9a4c70d26..ef5292ec771d 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -116,6 +116,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct zone_info;
@@ -335,6 +336,12 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info,
+						  u64 flags)
+{
+	return true;
+}
+
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
-- 
2.56.0

