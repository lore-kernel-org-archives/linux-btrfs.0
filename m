Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085785;
	b=anBM2oK1hhJR02DCzPqx6nSO8Gb738Nz+J2h0oMZamZVvkrcqxTWd3yFtTlowVoINVdh
	 HaZKT4ZQ2/zrWRxyozunJaQ/uIMDjXHYHRqcjbVQl2kkyZOq0dHiIiXXO58OrcFbVyQM3
	 B4xYoXxJX6LIBMQyNIOB8V9SdHapsMY/McSVyO/7H0jaVZNsTzDoAv8Th+ZP62Ju8oaVu
	 y8WBPR4WN2i3ToPE2wo0bmXPi8ZQv/L3RnEvXTYgr69B9pShkmXakGci3TtRiqK/1lXDS
	 h26yv3Y8rfFZ2Kt3jwXorLvufJ644D0tDDP3eIe8eUfDQ3lHPYmYyFiAzP8JWgUBPng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085785;
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
	bh=r9KhbfSDFh1xsVfFSDenlVffNMUWjD7iD9W16V8n7Fs=;
	b=THO5iJnrfJu2npBUcShPwykjxZTCfonDQrVxExIwKrCvrbgxHBPjeHsctOy71cJgxyE0
	 rEgXbn0tYISECNRDbbzzS2AuPIN02pGrQW/s0FBOt7xnaPt12qlHYkx9op8k2oBpDFUh7
	 SSIXUQ2DbqTvrphre3BF2yKFq/vwod134a3X4MDdrtU0GXUWO0FBlsTABFtCMuL7Mu3Em
	 rHYv7La18AFRyK2dpF7xHiRjtde68jht5VWI4Akejaz9u/ltAr5U5rfhskr0CrUcKpfdJ
	 th2NLzo4Xw5+hQDctaAy7cQFaTr5ykXm9B/SkV56HiGEEStIcuYjJygHNceMPwbr7/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=b1perRw7;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uXJ10Rud;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8340A606A321
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8340A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=b1perRw7;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uXJ10Rud
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085784; x=1824621784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=sdV30EnUMZAr3aVKN/dXLREMkBoxXUp7g1yIiItDRrg=;
  b=b1perRw7bYliQ8Kz8b1BRcNCSaBscZty8PrgrsUrXqIZaf80CslYY2gH
   0luiBVuZjTRKECs0YbhIxKZOqgoOjV/0ZJTtM4VsVoH//x+y3UjRwA1mD
   7yKqEHk6X7RznC7jNZHcb7tg/LFrdgXyFiRkJKm1176+x4TidbF5IYNHi
   GxcjnZSUmKgzXuZkXLZbha8HFEllrdmFuwmZPAcXxM9HLv1HtbaFFH7/j
   18VVQaAcFbOi9gnSG+p9+IFra/8esa1S4dGW2BzvYItj+kC53aOZaORWC
   NJJLWPhU9SdEmha5OPCW3blHuyoJ0yVHOEz5xlY6HCKdV4N3G2gPNWPh6
   g==;
X-CSE-ConnectionGUID: 1RXhYX3lRfmLkE+mxBWVYA==
X-CSE-MsgGUID: OROhWd08S0SY+oYRY5xqvA==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863267"
Received: from mail-westus3azon11011049.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H3b2BIv8gRphEyg3J4Kvi6roi+DiWcPWuzGZVNosqnUgAdVxL2I5OBHdo8pdBVt99uTSiLjWQHi9kOA0ga86H6IimKPZ19ukhGU30W7eV18aP3EOXFL2aWypf9gKje6vQ9kcWOKtkWa2oFhwHR8zzsG8jajPt6rZsuRHVPomLuCnbT8nh5gi5hDJrz/QozAUgpJHdURc9mX1cAc3POBgiiKsHPw4qXBcJK6fzbP+awciDkmWNV1EsnBjA2Axp39/rY1iyx8DCjo4TSeQbZ7AGrZtFk8iKITqZud7rfxJt2GpWNEh5pCZHU1fbly5F74OMDsKRIuSOBGcFbB4/hOeeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9KhbfSDFh1xsVfFSDenlVffNMUWjD7iD9W16V8n7Fs=;
 b=wG/gUZDRZcl/HVB84v8hKiUSCIp/eUJWsyhhS2iTMk3ipaEEFRe20DFCd0wr4XYjUe72dEYA25WMJVBCahjYWBLvN0GGuASHSyN1DuQez3dszVfI6l2FoaxGkP6ufbPHGU9B9SB74OLGnyNw1BRzVRLVhp2UcAfFn97vGFJriBufJDjsp/uTF64y2e3bLjUIgn0lh3OpL6lNI1hOSs/TXSKmZcJhcN3Y+7WjREuM3Id9FH8AJ3HfefEFaMICtwzD2mneKPOcRCQKFajLW7tcejLQ00YvKzZ22EaxdwqCmSiR7ve4trqiTTZDRTaZ81A4fxaukg98184pUWDI6esjHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r9KhbfSDFh1xsVfFSDenlVffNMUWjD7iD9W16V8n7Fs=;
 b=uXJ10Rud6819mmNZudUEHHECvDic3AOVXZTTUis/AwhtWZwnVqpSvkzbn0ofINzc6w4HY5A/S7N28Xpp6sG5X5sZh1+no8iGS9tHnHJUupJUAXiqEFQsTzkmB62dWoPp0zKus/ljNkOn1TxFKm8deuApdtPJtBQt8fipCYj23DM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:02 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:02 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 14/25] btrfs: zoned: don't count in-flight data as available in statfs
Date: Tue, 27 Oct 2026 08:22:20 +0100
Message-ID: <20261027072232.419318-15-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: 18d48051-f865-4a98-8ba3-08df33fb2312
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|22082099003|18002099003|261026121527099003|56012099006|11063799006|261021121427099003|10067099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	yVJy5GZOE3XvyzoRlp5uYomtVaSvcwhVhQb6L9we0i8R9q84yELtapwBCWLsehwYNdcz5ratuxue3Vu9wWjWLEAguPDL19yXPByJv/omMk5LpURHkn6NK0t3i7h6pFMNPresuuQMmmnIZPuO541gtRYji9LHI4fLFXvkjhEX/m26uy9+TS3isB5i7ajZeFsf2SUKV2alsdWciul2rV1SMLCFB+O6XrR9HE1pOvk5smKUG1cQWBqhxTZVyDzU4B0QM66SpKaOox6HJQ5o1Z6FoCqyl342BmOVvf87weeynQyhn8HiUWsyEuydGzNkWKVjdeeSd27VXYZDCFzUkEK8m7USZIKN2fUDBG8akBBTmBfbzDMI13tRM27uBEZZQizuEZUKi1HnRhxd1Mm3rqZ9M1NmnZsm3taoVBS7UkS8Yqtbbv3+CRNVm39Bvp48Xs1lho/3mSz5GDwYkArp3ah0VI4dePlkMQp7PZGlo52afTsQq7mUq1u+VK/JDEBnX+Gbb1dae8S2+TjZyxpdVUgyRQ3nD37zjcL5OsUKeR+EzvnUHdxYoiSxMJ03r6NuPKB9FlzFRLSkPHzHsrP9LPxDsxl65kjjIuY9tpBydFObeh84cs0NWkMUI3+61yowI7OeFgq34XKT16HN1IZsDW2eGKL6sF4sikesDH07bXZnz+U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(261026121527099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mRf9r1mUzNlaTYaRrE1PTCLtGj8lVCFkwdD/PWIcuwt9+ouOgMhFOneVCvNQ?=
 =?us-ascii?Q?5e4ZS4cVnElhxwDEbBw90Oxwmm1DRvfu7mySWmilfrFi+IJXjk8J8tBYmgzG?=
 =?us-ascii?Q?0owj3oNiufVS1sitdxwnQo9VR9EgR6Pkhcw+42B3MCEvXuUZZXiXd5uoD7S1?=
 =?us-ascii?Q?TPmh10GqQVW4Ci+x0CsLRWSjKYplGi0l65YgKRo16AjyX92J1Q685cais8I6?=
 =?us-ascii?Q?Wie8EU8SAOaQqPmlfelvvDKbgK/4sBhoNfRA/kcnR81wl6850cB1dvdbPN0M?=
 =?us-ascii?Q?4kEShRnMThicJQJHw1wEth8asmvfKBgqAUtiYMWKmpTMTs2Hzu00oS9VD0dc?=
 =?us-ascii?Q?5To9UT2j0034zfxho8ckQT/ne/NnVYaOzS3hY5P6RGHxIjSRO5nsQPzh7aM6?=
 =?us-ascii?Q?cK3zul41TRynks6Tm6o1MSlD2OJfmDf/jVpEXaz/3s6YK/jU3yLEuIsJOalf?=
 =?us-ascii?Q?D4FzDut+oWxBMa+NsW4BZfjyW1vntUe8t/6CYwmAyElav5yqMzJODv2GG8JI?=
 =?us-ascii?Q?rYb5Exy5XrwDvgNnUlcz0B2NqLJMcrbIUdI6FhdFlj2VTF3jMErwnR9Ya1cN?=
 =?us-ascii?Q?G059bc/9QGEkwM3Rl4tbywTKTyRlkbHg6M0dZoE9/QzJUbMqli0xHd2XvymZ?=
 =?us-ascii?Q?rTGSViMoxsb0Ec3gnU9QASSe9IAs4PeFXEY75ZfVBoLFZlaNw3/uQTOzmrym?=
 =?us-ascii?Q?St+ciUU+PGuKQu0FIv9S/hGMz0bi7mLIYy7cJj00Y0uUm9UbvUfQUft8Qu3l?=
 =?us-ascii?Q?LuZlSQKnAqFGLeM9eViZuLwgCRTRVmex23rARvkmRfxK2/qbIeBIBozQNPll?=
 =?us-ascii?Q?GDPxo89SZD4FKPH6+bMfRoF7KrgaFrja/saL61UbZ2XCh9Q5BVlVCxV4qFuR?=
 =?us-ascii?Q?rz1gKYv5Eeg3Pq4eN2r5ivD6JGXOFmCXn6N98dqjaG/OM5JwW0znTrxWBS/r?=
 =?us-ascii?Q?lG7LStXnLtKa2gGd+laacWnclIG3HCZpDtXYpPvEqXOgVP46K6F2Zsmoewdw?=
 =?us-ascii?Q?G/BJZCE+bBga7hZ3GoCshbAz+3BggGnGoW8sLlGdxzXLcV5hKnezZQkcJ7VX?=
 =?us-ascii?Q?iIPNhleBeYv5BfzzOiLtazsywQfcHkbLw5ZNvfhGD9eYQ5xqCKh5FgePyhGi?=
 =?us-ascii?Q?KMJ701t1jawSEe8YpOlnfiiPzo3W6B96nxTIpxxe6tG/XO+pdTSup8kMxnsp?=
 =?us-ascii?Q?I9N+/OLHgEMz7gWBlAq5NBB8sXBZihweI/GH0ZGhYxVnxgpauMd6E1D7VcmK?=
 =?us-ascii?Q?DshDnMCnvoKCM6DOnY0v4gJbCnsiS8invSl/Vqcie5RnePn0guqjNAqazmXA?=
 =?us-ascii?Q?NlBKxXD6FpWugGakG2SyaDf1krJn4YPU53QrmVaXZR/K5u7Arjiq0DyrXfIt?=
 =?us-ascii?Q?n2wmcUGRIMJ3FUKDjiEvHzgaTu4/xDUykBnPnmD3o1NNjsUzD94nUEZIvphl?=
 =?us-ascii?Q?2HhV5CgTMKr0VM0imPIktSHLZuwtrAC7FSb4RMAC8TDaK91Q6qucq4PIyTOE?=
 =?us-ascii?Q?DPy1eU2L/nTX6aMlZjMZazGt6qAaAqKSZC2msyEUs+tlJSp5p/9sh3ExncA5?=
 =?us-ascii?Q?+yKrLRM9/X3edakn0bZtDOcAIpVt8kGyqgC1H5fxgGP3IAM16O7T2Z/tFW5m?=
 =?us-ascii?Q?eyZmMvjiKWFtPL+WNiTz3yq1wS380aVCFM5IYw8oYuHOMN0JJQthMlShFKSt?=
 =?us-ascii?Q?IL35rG/c4++/Mowk5Av4C3hKk1v2h4fK9SK6lgqrM3Ezv2p6JrsT5speBqMV?=
 =?us-ascii?Q?JuRNnqaks9ynyfpcaIMOgo3Qa+Iz5HGuAm6j8Iwsf8ij6hNYTSssXkRhOGeG?=
X-MS-Exchange-AntiSpam-MessageData-1: A6BQdHXxO90OY3u+2gZTkEg7ctMOjysP5DY=
X-Exchange-RoutingPolicyChecked:
	TpLwoISEZP3t092zUDQOgD0Sk0L43+0Zb/TZ3HIZbMmlm6lkmRr0m1OtNVjbrkxpTSx/Arvxj8+kFlUUiS3Np+iA8kQ7dYKNf1neth2Nwgw0jfLfTsRfH7I+v5fN5IgKRxeVwEuc4FlLtPjo8gPOZnhNULpVn2vfgKXx1WRlsHQFMBshP+iuaSSZwfbUnZVHszfcud2xKUNq8EQP/6e2rbYD+ZvV6YTEt9ZN9PC6hwmnIrJTefXBXB8r/XhzEGHIKn9aJUR8+52o7pz5mO87ap4gVPJt2soluRs1oxt93b8uqbyJiEP31maK+vZFBTDcWNImnFOlmT8oataVy7KWPg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wcfcH0rGaIT87Lk3JRPmxepdRQQ8JJv9K1gmeH7pfeYYrVNWzMvVgjekHtrMADUOwpNfWm2M9bQHB/8mjDmklFMx2RA6oATE5ILV4wCv1VgL6SwuF992Vm3f4fqYj0Px1gj/yiP6/N64bk7yJlOEpWFmifao0nv+ipJHQczjEVMzXB8WVkkB/RxkobW1HTMrshNAGgPKbRWI1pIxOvnVagux+5S+5FMoZdvF7R54z4C3o8ejcxSvd5P3vuQ6dWg74b2FCm8rrgMDAX4vyMIYcWevTffTMFZSrLd+2GvdJ4Ajt364MnkLbBQiceBpGXm/YTZnJ3kSJ7CX9g8d7u9OMrrk9gJHn1vyFimi8cBgGSoo/rQKHvo40GIVrmJDzjcHRWNUnJ2cwJAY79V51TSvtnYRbzycVd6P9WmOjR6pv74RfiAuO+i/sTTvFFFQXj3+WbfFE8jvsbM3UeRMhloubh4z8rmIC56/ROYK5CQ9uIyDQaO56pL36R0NQ2x++YEzsd1olwNR6RdSQN6XcSkvCjkVsxuaJtRaYZupiCDnIRq4jbawkI5DCOCf/Tj1CAfnIKOmqlnYzraDjrwzyfg3gHKDBPOwhV7IxCppCtWU5QhqSYCJRE/v4eVy7l7KbvX/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d48051-f865-4a98-8ba3-08df33fb2312
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:02.8938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: exD6/+agJ5p67rc9AK1pj28z6hp5gV+Oy24cnLxbogjpGq2FppLtkgi1w14EjAlufX41J2BvHWwUNtsHO5BvMCSUz9g7/Pdvn8z1LZYArNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

On a zoned filesystem, space of a data block group below the allocation
pointer is used even before the extents written there are accounted as
used, and freed space only becomes usable again after GC reclaimed the
whole zone.

Don't report reserved, but not yet used data extents as available in
statfs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4..9bf211916870 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1691,6 +1691,18 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static u64 btrfs_zoned_calc_inflight(struct btrfs_space_info *space_info)
+{
+	u64 profile = btrfs_data_alloc_profile(space_info->fs_info);
+	u64 reserved;
+
+	spin_lock(&space_info->lock);
+	reserved = space_info->bytes_reserved;
+	spin_unlock(&space_info->lock);
+
+	return reserved * btrfs_bg_type_to_factor(profile);
+}
+
 /*
  * Calculate numbers for 'df', pessimistic in case of mixed raid profiles.
  *
@@ -1730,6 +1742,12 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 			total_free_data -=
 				btrfs_account_ro_block_groups_free_space(found);
 
+			if (btrfs_is_zoned(fs_info)) {
+				u64 inflight = btrfs_zoned_calc_inflight(found);
+
+				total_free_data -= min(total_free_data, inflight);
+			}
+
 			for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
 				if (!list_empty(&found->block_groups[i]))
 					factor = btrfs_bg_type_to_factor(
-- 
2.56.0

