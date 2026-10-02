Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B1B43F8DB
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 07:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926652; cv=fail; b=FgJK/CsnMxZwLZ+CqYDQJc1lOJ+oVRo1Gf6HTurY3xh2IWj5UyoeU67NLql2cY4n5ZaHmhyHWeFhYtnIm36QVn101Rki11HQCGZxx9l+0lohOPSP94pEutlwPI3+mL7par5tCIXdwIS5QA3U8EOtHIXzM9FK13M1vj19GOkGWrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926652; c=relaxed/simple;
	bh=Jz5fO+d0P+IV5XceCDYopzwhCiNQKSGEqtyUUYy+eHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q3Ti9gS9t6km9lC4t+yhGmNJQA0CiNej9mJRlxtV5Ba7LyRBRpNou8FzeXOvuOD+UKT0EPEuP94ILgraQ+5/Uiaua4gvcqO/GGqiF8go2h+noGREZkzI2Der1jwXmA4/XjuB+Ao9zGxZYx14YU2B8pnwcy3F9/bFuuQ63QVAiAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oKChLVQu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=C4q/epyD; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oKChLVQu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="C4q/epyD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790926650; x=1822462650;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Jz5fO+d0P+IV5XceCDYopzwhCiNQKSGEqtyUUYy+eHI=;
  b=oKChLVQup2YLLlWHIQxqutQb/SiXDrvqloQb6lfBEjzWmZb4gxCVTnKN
   /uKdFyYZ68+6cuXLpZVrrZG6Do+7drv2STy0HAYO3U2Bj0El6EYUZX24i
   c+EdhAgqMSnrlPHG8hVRGwpwgw7h3q/lhq/2lIq50NKqi1n7Fr4fqXYST
   JOrmJOxadKqUK2gwyPtHci4F8cUrOeOQGSgJcwm5AWKETmot/muYtftBb
   63L0SkL5oAJ7JcaP52sNY2FJDrytoMPhmRWtAJq+dEoJMo74QvJaL4foG
   cu9EDi39R9oe4kb8loDsTp8vzQtmfFXf+xPRigkLLsx0ROiOl/M5Owz4d
   A==;
X-CSE-ConnectionGUID: szaMz0zQQ8ab61M6j585Dw==
X-CSE-MsgGUID: p25z5+eZT16SsHoRhRp2bw==
X-IronPort-AV: E=Sophos;i="6.27,136,1786982400"; 
   d="scan'208";a="157114520"
Received: from mail-eastusazon11012020.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.20])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Oct 2026 15:37:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZSmwgQyliXkwK+OihjvaPhDa2Jh+wc0z5nBfxv9SLl1sSYCSJgYPfEgMa0m66YNdVcAXzvItbQO8M24wuFMGdV2Y2A1rRHVD8H3puM/rICxm99CyRTaui3s+Gtc3KMHyr9BTaDuqw0z+P4veqUJ3IkuGEuFO3p9yJeWuTpdX0nlGUFe9kuriC/RU5y7I559xTeGYC+hw+4sEp41RlQXJY880unTbR3vc9WHVUDvY755HAaF92NF+r1Hm9A51iObTvSw8fSdHp1weUYhOQeQGZP8gVILiTYFERRy5osJ1BLwmke5cJSqANOzw+nSWZJC4JOgx3S8GczdBQGEIaiLYsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3PCqcd3d5AD1fKKifh03JjJD50E8xRfzHIE3kqKePAk=;
 b=Sq63WzxE2bCTXMjdqtXETP9Ges8GnhHuIXndJxI8EJC7Ue5e10UQ3SU8Znhj4aacJ5EV5IgDyGElyTf9ozJGg0bVxE770Ud8fVz1aotUesb3TBVtl3GikWKF+WgANFG0xVWChtaS5iieBuAfC5Tkpsa3uCYtEdz+2/V8ACL+IWylUhc7vRVtQW+2pqPGY5IcI3I9v2d4MiBa+5wFMNsbIZ0m3Ki6fm145Ctw3tCn2UsaNSRLTfSgP2N9rZlGl49J6bE8z1oT+X/sBBjpRtlBj0gpQUCRHUdTjL2Xj0kWVz1i0+mo2C4SWCASRpWlXrSWZJTOJVzQKePZDpirXdFkiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PCqcd3d5AD1fKKifh03JjJD50E8xRfzHIE3kqKePAk=;
 b=C4q/epyDfTBO1EyTS+cePFUUeqppX0PncFrT43V1nLq/PjL4nE8H2rElxwUgfE1zpXmOnWNNeFlB/FKBELsxSv2K9wKQSf2XATxluho50xXfEnY+7Tv8X4voWdEucVBk5ZsMfwsD/GcLdeEFv9aCWkqk47CPOHU/0prwTdJgoVs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6283.namprd04.prod.outlook.com (2603:10b6:5:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 07:37:28 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 07:37:28 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 3/4] btrfs: zoned: requeue block group if zone reset bails out
Date: Fri,  2 Oct 2026 09:37:14 +0200
Message-ID: <20261002073715.2191177-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6283:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a57fe8c-0c52-4eb1-f529-08df2058026d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|366016|23010399003|1800799024|19092799006|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jaCJU9kFYWq41N2ig6WCyEdZFMsvi/I839l5U3yK4905VsQ6dPSXxD4yIhv6evWOS8uRI/wEMik/qrQmBhG24PpkY47ST56B8LJGKCKqQEMAV2lvVCrFmLzl8ByK/XES/qcUuOZDPNfggvxB5+C8Shicx/Uk0x2q5cw5y3iPjdu4dmKopgZbmvAFYKR4TUofVun0kOAft7LE5JfM04QUR+R5fqbHWUsMXBUA9/wVYPBBoiLcFPjUTFKorjs0tl7myZ6+eTyDMys51XnDXqsmnGLj5mOzcPWl1+ivT+hfcrYjKQdS36t6w4/T1Ok6JQHdqGmzr8/b8RjJ2IGwcAURWQzdJSbqHfgsk8R1GoBZrh7OgHrOkRmZg36yOq6lNXYQ/cnFt50bLU+2X+6NLafrSS1GhS5F7ddGbETw5Ur0/Tlt7qAbHJiX6q3Qv3arsAz/QhWeGDfGXGRrhqtIKJ5P+1KRzDDC5T3/KtQE0e+dxJBcH5p7V5TVAJRTTr74PW48fdcEsL+qhStphzvC2jcUsOS0Cagr24T0Z06lyiHzyis4klhmyMFQrIoEzSxk3YH/cGCXGpwwvEXCcutktwpwhAN2qIZmytvEkpls4rkqNX644XVyXAinLnLf55rJI8aW4XEnGwMs0cJ9G5LPzrS7E5jZGztQb2rGrJnu1h115LM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(23010399003)(1800799024)(19092799006)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Gv2GfcxIpng1MyLqQq+d5vN5OqWTqGnmycPtHGl3vtwyGJxzYX0E/aaVz+JQ?=
 =?us-ascii?Q?4jAueLJRnTHl/7Qp/Xstw9DCu71upDuJrKNW6BJR5rjmssjHjtoXtHXm9n+b?=
 =?us-ascii?Q?O6SdMVaLasBJN7/rf5MwBjYkizjqLuMnvUqhMzkOm9DyV9eb5K3UpLBU/sH/?=
 =?us-ascii?Q?dAgTWHCjwGj4jAYMwg4C6UeyKem6XdMp4VtJkbB77gaj5ocTKxQc7u+8sKSs?=
 =?us-ascii?Q?dI12JUOOLc9lRw+Hmo87xwn0f+LXuCNUo9+hsAaE0/w/YhNQI5/sMWqHaFGF?=
 =?us-ascii?Q?lDWrtF/iS3otogAswTox8NrCLoEm8f6vh/LDm5gZ30F5p40WeaY30PfDRopD?=
 =?us-ascii?Q?rkJmNZdvUbT31SyBD+RNETUjY7ZPxUwVvKKorJt7o7n23h/FWHf8kACvRkoA?=
 =?us-ascii?Q?O7xPGEYZ4hqHDQKHRKb3M1BwDwtAITjme8IHfg37MQJzmoL3hwNu7pIMsl0G?=
 =?us-ascii?Q?FepZ26KY4rBpDoEaWJji5knkmIzSkM/eU2gDMCAzQPuXtYNgngQ5tdYX/lru?=
 =?us-ascii?Q?RX0nW1vtJDmQyJZZBNR5qVDPe3sa6PaEQJk9xBxLWg6i9mgE7kIsD42yy0Qr?=
 =?us-ascii?Q?UVCKYwHIcvHmBLSjlBUaM02DS1X/Wg4TGhiBh7eAKmKtStglA8TKaX+izz3s?=
 =?us-ascii?Q?9VnH0cF1MSTKaHe+39mJ2YwdLOZoZi0Hhg9GD0UaUJRJUmtRl56d0Lalx8Yb?=
 =?us-ascii?Q?7AGSpnfko1YytVb+vg/H8uEqNiFcl//d+rbrCVntMpErb4UqcDV/16RlPfcb?=
 =?us-ascii?Q?xmE0OHXyfeYTWHDbNliJetP8IOZMuFZqrTqVxQfivuuiylGijNp65B3AEPyW?=
 =?us-ascii?Q?SImWo1qSdljE1+dK1+UHJAgOjoqEX7NAALOQN6fpoKqIlc41PsK1ON4NydGm?=
 =?us-ascii?Q?LZEA9iKbKpiW58OAC74YwL5xNCdvyMMFxTtaSNPncmuALleEwNu88Bamdl3e?=
 =?us-ascii?Q?J52Ba5kwcv4FSo7hxdR0CsDhZ/1yfehKqtuoUGHPCrb3r1ryVHnURHl5i6Kg?=
 =?us-ascii?Q?6nvR722r2Qdz+FySnRaPVkIzAfkPZvYPj6rdGj+j6eoTYq2cXJR7zwGqqhyV?=
 =?us-ascii?Q?znnLdO5Mc/Uia/Lq5rQe4nKn8IBnaVFEDJ6Sv4S8M6ytl1qS5QR4xd1bF+wj?=
 =?us-ascii?Q?He2JvZ7hucQOEFGQy+RBlABAeQWirlp0x7AiTmxlQ2sKDxvz9Way2osKQNKs?=
 =?us-ascii?Q?MLf+54sT7HM1drcpUhxX8To2t9TMMEcb5/GT2Wfse6Gd9WiJOyPpLexd2CYe?=
 =?us-ascii?Q?FIqSWBGnllTn+JpZP41JqIcAceszXQ35UxTyUipZbkWLQwLO/xTnMU320+01?=
 =?us-ascii?Q?oQ6VEZKf5dR6JeOpMckGu93Nm0K749j9olxnhrQrt7WNIop7a+uBEWgmgIsQ?=
 =?us-ascii?Q?PJ2Lipnaaaln8gtXrfdkVUzKllVZHSHpAMUIxiM2uJgNK4F4x5VpgmCAxQYO?=
 =?us-ascii?Q?ulWf7qkfxzSx4MRqZajpfH8Vo8W2IUhc/uLnYY1o+L3U1QRBnmyvAwZOq1wR?=
 =?us-ascii?Q?Vn17PBSU2sPV62eTiwVCe3Hj6cOH+c2yeWiZC25JvNsSwxU0gyoaPgcawR1V?=
 =?us-ascii?Q?XyygUN4KXD6PP1vc+xn3hRbt9A4GNA2DD7Sx71+2GSc29vheA+rL19sv+LRB?=
 =?us-ascii?Q?w4yKpgs+9SEys3kbcyQpYx0f4do5kOLRLfxvOYP3/Kbh6tWjovcjF3ue0nd1?=
 =?us-ascii?Q?hvrQ+c1K9tIe4+SvxI+jEle4xdAtpptHveSqnGTiq8BGCm5nTjs28vMekUw7?=
 =?us-ascii?Q?VF2IL+OvzCVkhXlZoBtKBReAghtNfRGlfifvTczhd1cJ4Qp/fLjtF29oraBL?=
X-MS-Exchange-AntiSpam-MessageData-1: fJ0DxAunLGFjD4uQ1F55/WyiSB1nn/p4Ci8=
X-Exchange-RoutingPolicyChecked:
	jrvDc9VkI4LcwsifTtWWk4V9HBze//JuCGVDyihR6rTZGAIK29tikgsLjp1S2Fq9ut5Nmmysh5ln/q6//O8RcVxMEtuqh4GVpn6e11Du1jg+02GZ1l//vrZL707aDsuPtTotFomZihsIkTnpzwNx35RmJLXb+U6vw671pmUOAccQN/l0f1a6wkiTrrShlsRX1q9ky82vKjBjcabyyBF4lY5oRjODjAP2Jt4x1a8yNaC2DLHbRNyWbaeol+zme3lFs51YvN+1YDtDBcqCqlXwgOCe+quli4ys7RDsQK3hS9gNfGknY9AOSb1BSo5bpfbMRkx8CMv6ddwFZnQHC7YGvQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Srb2Q9uS/eDve+A7BwftzwqSbEBOVL597edPlqglHXf4NyDMUsc2D9NMNEdvJQh/u1FtH2AF0XSIMoXNQUyMXOkxHwnGdAKtJTfcjuY8KR+SDVsL1dmytqKO4+CDvRzapoHDsATl89JDFaive7acA8RFRgglefYXoEitY3SLveuOQaF3Yr3mGeLWCeQla9Pdm9J6ieKb42qEnZcNhUPhj7AecA5tA3HYiPl5ItRKVSW53ispFGPGe6fTLs4LaYmELfu+WUppHcFdLwXJwl9AUY24Lhfv56Q5mpM6ieogFTN6eeXxiS5oZJEsSJsmmB83HiAM122f5o3hB95U6GOEzdRpQlFLMj+ofM707LevEVA24aUE/PUDVv19wZvTePgudydkk9Bby8WKzDaDJvSFI7BNUbPvfT1q5nEah27++NbDpgBvxq7g+kc4gMz9rBWRjpZIexL0qFfED3DbUM9x0N539hJIfG57mIbpjW1ZF9TSNmiNZRCz4d3WrGJ2QyTv4b2BxRUEJ/TOTmNHjtmSwtEJh6T/uAhy7zJta8H7RWLNbD7awcVwIyx2VOzQ46OkIVx202GT9EYsMBN9Sp/ZpIy1C5f/ExtnWRWXxpN4qfIm2tR7PBc72u8Hq3yBZ0Kb
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a57fe8c-0c52-4eb1-f529-08df2058026d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 07:37:28.0645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fj5yTPdaTxH45/Ri33hvO3DCguVEyH+FaVaCoZ1GbnkWZW6RrLXQ8svESVUlHamYOLZMlTIxzgt5X7WEHkLG+QT3BVfONyt7vEh11w2Kxn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6283

btrfs_reset_unused_block_groups() drops the block-group from
fs_info->unused_bgs before performing the work that can actually fail,
the actual submission of a REQ_OP_ZONE_RESET.

Every failed operation after this leaves the block-group dangling,
physically reset, but the in-memory structures aren't and it is not
requeued to be reset on fs_info->unused_bgs.

Instead of bailing out, re-add this block-group to fs_info->unused_bgs
list.

Fixes: 453a73c3069a ("btrfs: zoned: reclaim unused zone by zone resetting")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 261e7991c1d1..96d3957db87f 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3137,6 +3137,8 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
 	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
+	LIST_HEAD(retry_list);
+	int ret = 0;
 
 	if (!btrfs_is_zoned(fs_info))
 		return 0;
@@ -3178,11 +3180,10 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		}
 		if (!found) {
 			spin_unlock(&fs_info->unused_bgs_lock);
-			return 0;
+			goto out;
 		}
 
 		list_del_init(&bg->bg_list);
-		btrfs_put_block_group(bg);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
 		/*
@@ -3196,7 +3197,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		for (int i = 0; i < map->num_stripes; i++) {
 			struct btrfs_io_stripe *stripe = &map->stripes[i];
 			unsigned int nofs_flags;
-			int ret;
 
 			nofs_flags = memalloc_nofs_save();
 			ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
@@ -3206,7 +3206,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 
 			if (ret) {
 				up_read(&fs_info->dev_replace.rwsem);
-				return ret;
+				goto requeue;
 			}
 		}
 		up_read(&fs_info->dev_replace.rwsem);
@@ -3217,7 +3217,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		if (bg->ro) {
 			spin_unlock(&bg->lock);
 			spin_unlock(&space_info->lock);
-			continue;
+			goto requeue;
 		}
 
 		reclaimed = bg->alloc_offset;
@@ -3246,12 +3246,30 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		btrfs_return_free_space(space_info, reclaimed);
 		spin_unlock(&space_info->lock);
 
+		btrfs_put_block_group(bg);
+
 		if (num_bytes <= reclaimed)
 			break;
 		num_bytes -= reclaimed;
+		continue;
+
+requeue:
+		spin_lock(&fs_info->unused_bgs_lock);
+		list_add_tail(&bg->bg_list, &retry_list);
+		spin_unlock(&fs_info->unused_bgs_lock);
+
+		if (ret)
+			goto out;
 	}
 
-	return 0;
+out:
+	if (!list_empty(&retry_list)) {
+		spin_lock(&fs_info->unused_bgs_lock);
+		list_splice_tail(&retry_list, &fs_info->unused_bgs);
+		spin_unlock(&fs_info->unused_bgs_lock);
+	}
+
+	return ret;
 }
 
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
-- 
2.55.0

