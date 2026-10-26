Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031011;
	b=J6rf7tUwbDOfbVs/C/C10Z+oOn9MFBL0GZTkoXBsvf+vzs4fnTm21skueznR4BA3e7bv
	 e7Zhk9PvcpNNhsPAbiuap3NmKXyLOJkePMrX4s4sHuz48mq96oojbyJpZf/iNX01jY8SY
	 aSkm+jcwkgnYksQvDXi0Z8r0tTuCjExPI0WBVTMmRvR16VJmbbS7RE4FxHGgXixYrLks1
	 9KJjVHWBS0rlU/gp0E3zOizmn5h8FzmZzZROKYaxIApKMtDKfp/7AUxGYj6xLFyfZxzfm
	 UBfD2Zz2Z9TvnJqw8EFAYJ6qNS7DTuixSA+SZO97xwgKjCyInFtwY6w/Anx8G4hnVsA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031011;
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
	bh=XjbvYZXz3lrSqAMEf32gm65pTn1/sv/xGqqdmVGHCJI=;
	b=wV/dEEPn+cZMkbbDTkyHvCk8vXzHb6DwTCMavuCGQuHmV4lIxxWnCFgYBv3BlN0GNB0U
	 e1x+dqvhmd4KtjGYlEdJTo1BOaCEQWcUpaORHGEzaNO0Nv3SrYbr+JV8XmIHYVAFlNnOD
	 uSL5ePUXqfxPlnc3ajc5qpEwErSPJE8mcaYX3iZ5m+G9+uLhZQd6MqFTBOG9yEKySCH9Y
	 9p0N1J4CecV72O27C9IE/RqjitEHdLPxyIfQVgTlkdOiTm7z7cf1PedfnFJKRCcthLFQT
	 3pSlJubRbAiKmYmypzsbENJioaye/f98Rps/c+tkkmLJ1x0dkXzBJcGooXH6JUnIHjw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=cFlBCbLr;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=MAtKSNXI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D51606A337
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98D51606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=cFlBCbLr;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=MAtKSNXI
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031006; x=1824567006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Mq5mojbmr/u6x6LsWMQJZubteYP3RdliMmf2HqSAzv0=;
  b=cFlBCbLrFjLivecxgVMtqJoJMTKlkTUUPt+IhJQnS7n694tA8p/42YBu
   QAf292RHtiwtEUUWnlIqkH8sO9tSeNU/oQSpkNGmFpcQiAniUFR01IdEe
   EvOPk12ufKfbYgPvJEY89Cg1yAS2pzYLasmeSerm0Xc4aLL63yxBONx4j
   wup1s3lg5PFW0MvNY49Iwn7yKCbzj6dWwhN1gauFYmcDLOWe3wzlCzdOb
   enMJci7XmIRjsHc8EZEKE/L9Vs9hHeV8L3vkJJLvVpBC/5ncYbRuSU6Hv
   SyV2pWPrdPyhVYt+p1uqvWsKL7lifpIuXQ8gEJWxoF+Wyb6m/2vvhVIlh
   w==;
X-CSE-ConnectionGUID: vWI8om0iTIWIJhjyvyM2mA==
X-CSE-MsgGUID: wg02vcGmSIKOo1zRdpzhtg==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033897"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KMpas7XkjpChyn8TNiVBGYD+AavHlMJ+EdbPJAbO32f5JuXgXgj8ERCUrcxvg1J6BIOtr4q5yA6Ag3jKbvryMBqB/6QO2X7DZ/DuUjqikZBSZ4EFa1ODuiLitB6PiAL2BAB/A8hCwp8OuSepBDqps1rrHLZNM41XccCKQcXyCWOpuXV38MI9ApR10VnpBy8VWaxrkgo7ThDVpdrR6/BvyREcqeP6PLQs/gZd2eDiCvuC2K6XehluumiYhAdBpflvzrG7E9C6FtHWLh4UDCpZ59/zhvGKMS0Ci63s8aVVrjea/9nhB7tmtoGd/IaiJjX6XM+vRkmxClBpzs94ufhptQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjbvYZXz3lrSqAMEf32gm65pTn1/sv/xGqqdmVGHCJI=;
 b=jld/88/mvpmV5lIqdaMulEKoYwcSWAQa/dg01a/U8o5TcCcLjqw74qGiA3KY8Q4X7DZnONhcnIU5dLnujq8oP1ydQxTBcOAMDoMs0lFJkCV25/mrEmk1g0wc2gPZkaAofZlwpUUD4L5OEg8RAq01Z2Ncu70mmtKdiB7Lw5ISiR0kZo3dI1rkUCRi706w+JUsPb+sK63RCQtzvV1T2IDe0FPtVJMkefU0zXPN6++MbV5lcBQ2fTDaN7j92PF9rwd+u/ajUrPlvrnB60NQ92AMOcmam3aLMyki1xGzxNzOtyXO+Jgowr+0qkuAxYts16XjXryPfDJGezy9P25kCZPFKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjbvYZXz3lrSqAMEf32gm65pTn1/sv/xGqqdmVGHCJI=;
 b=MAtKSNXIc6Dfuz5AbE1fz9kQr+0BJKTKLnmvRkg9qdCPFNrtkD1nJUJBjS+4rrUO5MngjqS1f8fVbRBcReQjVcKMwZam3KRTY4rneKeutQEOG+7sux8FnASCyKK1k8LqBRsDVnEifar4wxM9lLyOVdpfw4ma4jLt/DSMeWW+XTw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:41 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:41 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 09/25] btrfs: zoned: use plain mutex lock in check_bg_is_active
Date: Mon, 26 Oct 2026 17:08:57 +0100
Message-ID: <20261026160913.207909-10-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
References: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV3PR04MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f64d10c-4993-4c62-56a4-08df337b8a99
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	R+0oNOCMtZpZtn3cwDiVUdUNTUnEgdxiiNlfaX7fstYb+cfocPMDzTr6WU+s92+TVy8moeVJ3xgEiqmbZXBbOr2nDqwgg8fxxEbIBqupLJrE4N46caL0lZaV83nuvkojzXaqacJFK1JYCUVNAWScGtayZka7es4Y14gydH4t7x8RbWHC8WmjsnJsCbpJ+6zlfoHbjRyYjxtN3k8bpAaNw2wHiChyHKEx4dbTh+HI9zOEhhGmndGk77er60aZoceuG92aEc/F1Bm1XK+vrceDWrysFpVP4ddgzlLZ3PGnv2FRiKAAsQCWM9kLbMRcVdry+eVDA9qMnDhrK9FurUzRyLRzvzWppuiWG/Wz4QVKJVVNoyQFHvpmEtW/Tr2A+sGSYML5Q4MvgUBFZe20dsCr5O87geip322sdWSMwdSxK7xzXFxbJyxA5+Lhi0KuLkFuud4L1JUEeG5PWNxkl8gYSzIPB7+VH/Dk5XwTfBizg/dpGSw66oosWQAVhfWQqRL8YmL15BfYSHyfGAMZ5Cx71XIuNCynLqC+wUxbZ43Mw4kioyA13rGGM4C8ZOcvN7zBoYQhR8mGrAmLCeHvtgr9WzVEjEjMPM7cM21rAIfIjxyr8y3NO49oEr0NAVBfrPjup8CPlmZ2D/2fIc8FcE73ojDiO0CvkRcse6iHCJjIggU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dzWoA0soyaKJJk1qxG27To6aKBHeWzkufj+L5JIf1EJx6/l1sExdvmZNVo+T?=
 =?us-ascii?Q?EgQ+zuSn5j+CcxnXkkq50kZ1PL8T5V25NhxGGNtUN3RULA+gZnQJLnr1CgQN?=
 =?us-ascii?Q?KVBo2fJeuBL5bUqEO1psUOVHuI8bWpBO/nq6qFvMe2TWFgbNk5jLyOhDRy7k?=
 =?us-ascii?Q?gqPaFwbIU/Nk4VHqT1McDtrGSy0vuDDAdu4WDR8u2mbRLO9cnnFCSHHMlhjx?=
 =?us-ascii?Q?cGKpEqZ8by6kCzUNsITgSz0m6a7FJkfqJyV19+9JAmkiLhHLXjqHkH9W00jH?=
 =?us-ascii?Q?5mwaLLSAzG8S7pmU7AHSrMPhLaawLLm3mYUXFqqw5FCZvani6pJ/zpf5xBM1?=
 =?us-ascii?Q?w48U4vadLdmS+UL8vSRe2gGjH6eYrIUnn8HCyIU4ZiqL7HMVGKpazQsDWVmV?=
 =?us-ascii?Q?iYUlEsBwSdVnXfyGnkOi0MrGLVa7USN6nHn5iN1bP+r44ZTRmdvBlWuxZpji?=
 =?us-ascii?Q?bUfIZhDe7ZqQxK4CP0hREKoBTEOkQSLc0SNnxIP1CCC+DZtSVE0gIGsxO+MI?=
 =?us-ascii?Q?dyjMZOZH8BoKjGG9bHqVqc/Ic6oHagxh4DNsm49B4bsVdBxwO/qeW07Dkan5?=
 =?us-ascii?Q?RCpdpY3PIoq1OltAxW0kjB5CRQeS3y+3rTWg7rl6TYvs2M791LqKED9fKByo?=
 =?us-ascii?Q?WIucweX2mVceBowGXygc/Aw661oxr7bzickmXyL1FUsSP/TmfClymTwP1DxL?=
 =?us-ascii?Q?LE+uzQFNU16wJ1iXva9okpUKJ+sL59nNiy4+rs3bzf48agnz2wnIhLlCWCpO?=
 =?us-ascii?Q?+7Z46uFCVveK+F90GtdFaflayeMJa9i20B2oEwBAuOB3XAPEOmCffVP8UBvk?=
 =?us-ascii?Q?iuxNj/Su60958VrsoATWBNvGV87FLAK3stPloQ/O6a2kqH8doTgqF9hhxzcw?=
 =?us-ascii?Q?kMWxTqIlmMJDO7NIAdSiMYllrRS5B1bgmoHAiUbC6CodTU/c6s6ChX7zYDvg?=
 =?us-ascii?Q?I3RwwUNR4tvsQPAdn7CS7wgwVmU3moiWZVoPsNWqlG3oKmuNIIZ2eVuHqHUt?=
 =?us-ascii?Q?wp1RQqhjPVlVV7dKRnyRdxLATbrtWFsSq4id3Fb0EOrJkt/lyg9/RT8OLfiL?=
 =?us-ascii?Q?h/qEmF9wySV5Xh/Ch18qXAUVd02kK8NVCa8Bbxq1J79HYc417pvFeIF0huBZ?=
 =?us-ascii?Q?2u/NaM4/kru8+ub4UQ3nNDDAS+Hpv3+TMkSgz9OI92+AZG0LhU5fhPXaF1Qm?=
 =?us-ascii?Q?n6q+g/kGWWjCvjLZtq86QrjM863TFOqhc62UnNoN91QBRZ/B+FY909hC+wd4?=
 =?us-ascii?Q?jf2ULLuoec72j8eRmkXaZaarRm1ltZsC4K+YL5ZfaSIxEpR88SLymU9xLetM?=
 =?us-ascii?Q?FL2mIsDElwfIO03YSVMZBVx3aZnDP8aFYEv56UBQ0RgGkTxy8B2Nb42bAHb8?=
 =?us-ascii?Q?3NMIxYaYxhzbGJH2413wAbsN2eRs92R5nZ8ntDjOBeYQaSRu+XiwXGzZj1uE?=
 =?us-ascii?Q?HgytGcMRbQCeiVMNLYHMRmwHN66HltUx5hxgkniFbXljpb/l/uDM5DgDJ4K5?=
 =?us-ascii?Q?aViKU1y2DMnnMltxP8uXTNT98Xa4uKewyUQbL9w+uk9pNFCXO9Wm9pffw5rf?=
 =?us-ascii?Q?ca8mgRBSbv0+sqF3IfmFPF86fS0pn8WlN9AAJzRfrewOiZd2Oza72ivYnmhM?=
 =?us-ascii?Q?K4t053moYJgZ/Vyp+CK6b+gzv/Mmjh7bZ9j6LfnpgV3ZSLkSf4R20Tgx7IHF?=
 =?us-ascii?Q?bc5r9sqQEHk6oswT/JTE0upw3XeBbDG6e750AwameyZfZmSF8n+PxUGgyTwB?=
 =?us-ascii?Q?IRzaNlPa0TaxX7mCoEKAbBQ56KgtKT2tvHnw51mJJlbvqNY5VTEMlVdHuaL4?=
X-MS-Exchange-AntiSpam-MessageData-1: JM39ND/nawPSRQ==
X-Exchange-RoutingPolicyChecked:
	O3rtby1lIyvUDiqMAzD/VdBTnsEVlaAMZF83TeWH9cnGWcaBON511ad3RUxfp15rgaXyNowplxPW2qc9fO9ijomx67WwAREMAbt1JlHrXaMRS5COu1PXFzKba9Jg/LZ2guwtonupceMNV9JENTEWIjK6T/d8P2f7aPyUzCRGc1vwd6+dE9mpjCYWL1oSkeSc2cPgDMEO81pzPncW6ZRnnoQfsSzWyrwdRl4v1HXqXMq5WOf7XJCAXW8oA3Orchq+3sC6pC6Tr++yy/MNv/xJfS31qsh1EVSAG4ag/asThwq9jT00puaEqZRy1fhJ+9jaejfy0XxmJRRxZtzPlCrjKw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ApptdZdsoQ4e4Bo3176rRnXaVHEwqiHmCYqebrnCitbZlw+W5JGqBj1JdoMD2Ijru5VbJFOrmM9ah/1bhG8jAjh9+rJqZDFnuovUDkPn3JDqCTsANEjlIuH5hHb9Z9gIIHNr5cidGHIcZInERPcpOQn1Stkkql1x46OjznV6RMYJRGw/omKnu5yM4pbJOO0V1k/mgA4OQvaHux3wsvAMkB/ekwpAlJT1bNSGkwA6wFcCjRoAyCAaFlo57Mt1tb6zV/qZH2jT5v3qVpSRas33W/gXkYmpL7rOpJSGOwpU+Q4MGeGPMTIfzMPy9TKItyH4aYzc7+H22f5cT4aGgZ5ycQcceTz+Ttidx919YJhRD5gjHg3Q4u0YDhc8+K4yjzn8xM0cySAMxMqsmK72FZWsFpLaQWBGITfLok1Ue1rUpzzYEn5+MC7VUZPcOBn79rkIHV9g3VAzZ0LD4YIPbISQIRgxLecwmaxgF54vLzlzE4IKMtmoHX9rlETrjo/hs2K7SQKjPgkL9UmiaK/93msBWfclAii7ErP7e7strObg+iPLNcBE7Qi9Kcf69oUx6VQ2DHsfcYw9MZybcHcFAHlqWylKTqUEglRpCtaNdUBUzSuIEJFT0M5xvnspU7jCr6rY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f64d10c-4993-4c62-56a4-08df337b8a99
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:41.2266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EKaPiifS2bPGcmMLaHeQ/H/xVBgsGcMiUOBIdi+rLjVA/UKVghXtAFZXXCUWguY26KDIvufwcsTWCm8hz/PaqkmbbwHoe7n+yiVg96Ek63Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

check_bg_is_active() is only called for zoned filesystems, so there is
no need in using the wrapper for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index e60578abcba0..ed00060986c8 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2238,9 +2238,9 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 		if (!btrfs_zone_activate(block_group)) {
 			int ret_fin;
 
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			ret_fin = btrfs_zone_finish_one_bg(fs_info);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 
 			if (ret_fin != 1 || !btrfs_zone_activate(block_group))
 				return false;
@@ -2263,10 +2263,10 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 			}
 
 			/* Pivot active metadata/system block group. */
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			wait_eb_writebacks(tgt);
 			do_zone_finish(tgt, true);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 			if (*active_bg == tgt) {
 				btrfs_put_block_group(tgt);
 				*active_bg = NULL;
-- 
2.56.0

