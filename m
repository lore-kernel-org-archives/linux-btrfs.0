Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211710;
	b=aCdiAyizGeh1e0Wy9I3IJQrdkG21L9dtdQXx6hWGommIwrsELCxHZ2ncUzpIKiAG9vwG
	 yifjhCmyjorj/6P+t4s+Vl3s4CDcLbyzIjPPVrxRaFBIN4OUSgw3WEoFQu40gGyvo9tSK
	 qKz807OCRToDN/QYKH/s3j/z5XwAwhmrddV6VlXx8wEBOMlxWgsFxeR+f/WoH40Pc0yyI
	 qg9oEmNwrw9S9mva/PU0kA2AKdO+NOoRhi7zuaL4JE+GfRDa2DgGwWnfthESFl+wmaj8J
	 DOTi1Rq17Q9Llqn+3Pr+g2bBcHcasMEEEWGx0D4ZE5ONEkXxZESC1mgYOItqE4BU+pw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211710;
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
	bh=DiJvteHMBsacAokxdp2NLwhO/cSOn4E8CbBUv4En708=;
	b=wLPCablYbp6rO78QekpobFaNtvXlUZuz3FdMHRwn1dfIyfWctWaTPdPqxHNlRzUWIdpv
	 UsQ0Zanc0mMJh+Rv31YTvMNnhXnn+3ipQFje7Dw5U1JgjK3YLFffxNuhBi2R05MLIQqGe
	 mXHgiZY9ufE/ypoB/P1Ur+YNil4WLadkAJZ9aKUkUa243BDL0IuHn+6lknSa2I/r+WDN8
	 s1G7Y9/cSxuBlGNl0SM/Utr83slxcoC4HFe1wg/SWG9GSp3ol/J5aG+hIgHV+26+UvxOK
	 hc0wsV70Xgyp9yJ7IdxkO5fExtSe5bUAxg38SKAxZrlLrjZwBAQuGXpnpzXeBGDHFfg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=RvaTqwaO;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=AdmLUIdg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7848260A3816
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7848260A3816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=RvaTqwaO;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=AdmLUIdg
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211710; x=1824747710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=g658WshRjEzb1SvNXORY5Lrmg0jV8SgTiXqa60kydFU=;
  b=RvaTqwaObY1ax0tYb8fuPLFQPWm8jtz0kMnuqggEZ7oh2y7bez07YunB
   kx/jMt8Zias68USoBqV+RsPcoPQ0i2jvViEbOInU01qxznYCkvBh07JLg
   TVTfja52yCNpE68aOB5WNTv5XecyGhMZz88kjs2dC5cG3lxmkfRDOfQd/
   NSVKBvVKwPwO/wT6VrZRqUolBUiagIfeiV5T+H2HFbJUdNECOr9cC4eMG
   OH/C4T5Ie0swvzJroefIz+rHpXjw8nW3F3Z+VLUxelMa8oDNhVCpOiEyp
   A19H1fq27Gts0yhNn+aCPQfXBMJzKcLq6P55NbjynBt8x31MixgqjICmf
   Q==;
X-CSE-ConnectionGUID: 0+jW145xTFuV68ruuHl9zw==
X-CSE-MsgGUID: Cha7/gyWT9G7/REc7ZoI6w==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="160194180"
Received: from mail-eastus2azon11010023.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.23])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H2WOSICZ+aN/Cz9DmK6nGUJUwYrkY09jCN7rmdT3Ifj5s8KxkipQiitGL4TD6uzx+l4uE7EuHNFDYaygGQYmE+EyF885hg3nZXMiech7abP/Q42RIK+7oqIJGRYr8R2yjcpKvaWsmA/e5sKksuz9MG2aFptiTXymoZoebiYdBKeKaqU0ZONZpDlpzP7T8hf//Du763Ab0TOu6zOCfkg1gXCkrHJXpDi8ftJi9jps67GAL4R2vzQioKxqSNuXc8RSmMxxYhY7RQAWtEhl9V6h1fRyNT+Ze4GvyT8Wjnem8AuefFyeu0e8U5rePeNMmKuCWNfAHzPYGClYv8pcLgp0uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DiJvteHMBsacAokxdp2NLwhO/cSOn4E8CbBUv4En708=;
 b=ATZEbAUD6YYoRJtCRp37bSXbtEQu1KKlWdISQ4AvAAeZMnusd+dAl/lBIZoK3/p1SrAqTGtPhIoqHEGnrKeXnLTTQtkq6++X6cSBEEs5I0L6As0gk5B1XxlyN/whus8y3CcqRYk3BJUZRNR5MQf5nxwpRTO8El183t9hj+N6DHF/Z1eUvku3eiJW3cdlpIw7ZYM/lEprBWS2GpC7vQbe7a3l+f2LLvHotdGhzXZilmI0pGmM+pCMKxPqISuJK49QDXG3Tqc+OSf0V2m3KLb/CngCz5rc088rt4jSJvX+nhI85iaPGy0cnktptRdKvXAFqxwB6goIsm6uH9pvEhCm/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiJvteHMBsacAokxdp2NLwhO/cSOn4E8CbBUv4En708=;
 b=AdmLUIdgOZ0/p++/f1/sP7lJT2btYl6w0J3B7DwbHrc7Hc+PhCWgKyUUUruQ0JM+shFwRWR9sVYwgnVMtyzeVNmDckM8goHYyrRWHQicwnBItp3DCcXt3MTC+mRjlZ8KeVFnJsoaJgeEzJBY6/K8bdb5qtAwDR4gelZ0yW6rnZY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:47 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:47 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 16/25] btrfs: zoned: don't account superblock zones as available data space
Date: Wed, 28 Oct 2026 19:21:02 +0100
Message-ID: <20261028182111.160492-17-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0a3785e0-be6b-481a-c474-08df352053ef
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|260925021311599003|260925021911599003|260925022911599003|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3CGZu+FVjWdASbiSC8LsITtSGi0pPHiZ1G+BF8gXiPAZxzanY1bXaZUx2OmN1pWp34rHJdiGK1YNObnUKZ9xGij9D4NBfE62fwugag9t5qBOuGtl4JRTegAMFIL40b2jNhUYANxxRL5WQA8JUxivzQi1kLyqHmA9Qslfh2EVd87Izh0pdkLQgVlsn4yCIRatzo9pJfbACWu6mw2Sv/5iPT+m0lHiTXg/H31rGTyukzXHBEIDme+3m1G40sNc75AsTm+IPxEEAB+ASexaTwf23wkZDYfn42u+Fo4fxFRU/xkoQtfYazN3YvpJMY2BHDopM67P7/U9jMvmKXjO5L/LBdjNBtdv5wWEUpcFJyKAYlBZA6NbvMtf7iHK52dOmizCWYuGEk4eW6g4AUdCjL3VMIWK0/YYGpLmkRIEtlryn6zW7Yt41eIa/BiuzKFdR9rqgtmHCf7yWQ8bLDwJuM+x5BHoadxfGhq5HGCwOfR5pnKyDGc+l0jg22gXdEnyWdFrYYdyma2xraBXmLOceaTYFp5kY9wi21LV/mD1kLZwJ4TG1G3p1OOCufBdkK6scmTtZdcomuAraQw8F7HRTFtjTAps0boHxz2YV3/HUlVhJDbSpr4IvHj5jgvLGqTR5KvVeoP6QZjJ/PxsYsNERdT3qWpBE8q2y12yUlenyxG39ns=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(260925021311599003)(260925021911599003)(260925022911599003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0xQBgepo7yFBfXBLhCGSSmxJ6MxlK3GAgZ6jhQvyy8lxO+JQaN//TBFjxGAu?=
 =?us-ascii?Q?R3k081uf4r+Q43ALzZoZLxVe8CO8x+f92L6zcP6hsJZ0G9IqM+mFnqHyly4C?=
 =?us-ascii?Q?EBW5Fngls5vhvJ/xq6iUxOi1bAKG5mTsWmzoaItgKw+vzUmOxXOZM6xy14Pn?=
 =?us-ascii?Q?AOGBsCg7ephty+FOPXAifu/0GH7/J1+9C+l06MvIHEBAXCBerutm9PiKE8WH?=
 =?us-ascii?Q?55p4gctOG+rGgmJFjfckD5mCtEi9rDoX+5NvTxvvMAuxmlajbZwcMXK7bJWL?=
 =?us-ascii?Q?CIkHX/lSqTJqfCDqYxkFHzELRYSurcmlexaKKJ0bD5axp1WL/TS0v+C92UTb?=
 =?us-ascii?Q?tEg7v1crMyT5dRB/+wV1RDA2PC+bgZ9m0ntzXTPA2WqsnFz+qN1CKYb+xuC0?=
 =?us-ascii?Q?u/jWunZMPxNcG+rGeNY4xNgO6hLT86gLMOdttD2Nc6XfBSxMSwYW9DO8Imfu?=
 =?us-ascii?Q?I5IqPWMpbzRAaBpk6IzE9Y5tr/RznKa78gUHEIWyriGrnRpvQse1zNE9DmKM?=
 =?us-ascii?Q?Sx5qRwqPGoahtc4UT96Mh+Ew9wrQtUsQFOr2YTpv1driHUswyq2pbwtBdcJ9?=
 =?us-ascii?Q?HaSkOpirZxmcyA4oU8UT4c3b/erwAtzuRdhT5SHzT/k9eECn4oH5U2ZE8et+?=
 =?us-ascii?Q?ifeZYbyj3vMadiDdjhkXCxI8dLTBQk/gy1mN/mEPwTKiSJdZ0HLt421BnqlS?=
 =?us-ascii?Q?mGtGCMtVPSABehwxCAlymYiZVCBIe+SviIEjYqU1VojJj4g7fROI+CwNPIh3?=
 =?us-ascii?Q?ACXr74XCLNzFzCJ8VtdaQlo934F5t/0dkVdclE8TJk9jpinv9q44T4Z5EPb7?=
 =?us-ascii?Q?tfBVMwwAa1VluzhTw9slUr99CObky9kE8BVZq+ddeEdm0ROgt2bifPXibATT?=
 =?us-ascii?Q?SS1JjAmmS0df1Uh9W4OaBYu+lPS8o0mMnzYw3EJ1pCdVuwHB0rz/WfQPmlRL?=
 =?us-ascii?Q?xmkEgxiWv28+gmWywoLH4rWi9TZpbpSdQiqN6VonhK3tJR4b+aM1aDKYO7Bg?=
 =?us-ascii?Q?CKLmlGGdClnKg7mLrytg9NEsL/M/uOMPoEF90jar1TexkPTW15mb9YwWT307?=
 =?us-ascii?Q?A8CTgYS7eK11k+1DnjgEmUwkR7GBwScdIGehqDLrFOTTrNq50yb+z5VdFi0H?=
 =?us-ascii?Q?THyUiXAQpphLHhkIod49ZF6WZKOT6JR6IiaM1xnm/G+9IPCWClG8tafrLyd1?=
 =?us-ascii?Q?P/G3CY2tSZCHNofl+TBQlR8xjubNnAOioo9UebiX+eveWm2ABsOygoH0GN25?=
 =?us-ascii?Q?T/mjuttO90+Hlv9PmKNrc6pKWNFrBRkDa2Uh79vrtEd0RbCO7UGHnrct6+Db?=
 =?us-ascii?Q?9vvfp14gh35SfpDrGNYheVkdj1ULSPJxy5nukGgZCMI2DfQU9QkDjmo94xjt?=
 =?us-ascii?Q?eQP0gYYewlCG3FnCnSgZDOx+K1VwBzHVg+1FbeSFDvOMKg3DfnuaUAwKBoSq?=
 =?us-ascii?Q?WnceYKjtZa0EtRde+NJvS3sNy4M+e8eLQ6wKDaesrtUTfwmPhH4DTiuuA1oP?=
 =?us-ascii?Q?ITrXSi0w1xQBsnrO7V1vwr6byeRi2yPBt8msM1A9GpG9tuPetUpp6Y6r4yw7?=
 =?us-ascii?Q?E8F0m8NeW9l6M6R266l4BKnRFhmxcUU3KlU59rwi94kqloiFDmV+rvizFLIS?=
 =?us-ascii?Q?nJxozUPiFfTD6IVq9TtncfI9FXzQwNKrP0GZ46KUnmS3b8A8wDc6wDcOJaQn?=
 =?us-ascii?Q?VzCwxh+lmjEr5X/XVjuFtG/pVSxMT0r7V/aApKNE5nJzDnT/B8yH340GnbdI?=
 =?us-ascii?Q?zLGcrw65lFQAg5BUJbI/iOfdi9J75/ixh2bL99m7nS42EB45MoPKRvdQ2VId?=
X-MS-Exchange-AntiSpam-MessageData-1: zT1zOxYKiB4Pv0TKM5suQrYhjjNVvB7s68k=
X-Exchange-RoutingPolicyChecked:
	SKu/OC2xwIkju+sbs30URjCDn5J7wi159V5ywyiPEitPglIXk0/TumWeE/xwvFThmyLnCU/jUuVfK9o/XOf+7nkYW1F1CohARMvoSeY1gX+F4kA16dK3DaSlaXuKlEXEbQtkxmIz4tWy5SxdOPPToOKsBTIcfZdmFk0E0A1Q74i+e7ajMTwOoCV1Fapm3SRPUK/LpCKxKAC2xfzSOhvpH7W/U90xkzZni3GPdEppW/P+ZuIO5CTmf3wAxqKlUbuzqf+k3y01N5AvwUDv69Pcjnc/VMVD5pRui1rRbffEnvRtBlGC4AB5eVJIepPsvKmHQWZVw3plPJBSaK7ilX8H1g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K/79CgKYnBmif7jPsLdfX0PneC8UreXj2zGLZ6NlKQR3/e3T120ZfiWE3ezCsIJMjm+wMCaLW2KFU8eQ6IxB7qY3hc6ipYPwctf7el7YnpyIkUwkEruKqvuGo5w8Jn2IofAtO4I42qAl+JQOMpHtcOC2QKSNZ9sHsUD4TT2ALKcf+tUt/igypnlPfBbGW6wGeXWh9ujx0vT+vI32owmgiB2jzwxzzLu5qG/1qUXYLMkfLxXBp1u+/nUp3vMuUK7xhs4lSyUpjltpSpmfv9c5Uy5lO2Yjk43xBE9DVuXRDT4cSXQdIwnBN+btJCaSmDziqCkvNOInK4Qt/WUSM2ZVTdBiWPrJ/CXoWTOCwK2Cc6HOENm/nloycWUQPmUyHpjQV67SX/dCkYw4vjKMTDhExNXXtqm0F1VFxEzOMJYh+4lWgRZSrqUETlNz+B96nb5UW9OVmrANkAGhvciGxxLiVzMYbrpG1c87mvrf+3fC+6kZRXPncI5405ktuTJFTPWo2BrJCVJ4VyzE9vJ0AxrMyIPmuYc/0aMpeJKxXVPm+Twl6jnMrenPGPyfySAcF2b6LfjLcNEE77yflgFEXE+h8y0WRuIFFbuijvRUZzQ7rT3y9vZaX8HOfdIZ4KCRHqN3
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a3785e0-be6b-481a-c474-08df352053ef
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:47.4431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aX5bgAhqvSFRDJAFX/zrUTLfs4myffLACGvQ9DKx53nAjLK9/VsKPEX/z6zCpu2FcYLEMnxuiE8tJOEWLkEh0PvwS6UiBHLJ6abpeXouFME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

On a zoned filesystem, the zones used for the log structured superblock
are not usable for the allocator, so don't account them as available
data space.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c |  6 +++++-
 fs/btrfs/zoned.c | 22 ++++++++++++++++++++++
 fs/btrfs/zoned.h |  6 ++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9bf211916870..0c8b8e392c84 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1646,6 +1646,9 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 
 		avail_space = device->total_bytes - device->bytes_used;
 
+		if (btrfs_is_zoned(fs_info))
+			avail_space = btrfs_zoned_dev_avail_bytes(device, avail_space);
+
 		/* align with stripe_len */
 		avail_space = rounddown(avail_space, BTRFS_STRIPE_LEN);
 
@@ -1656,7 +1659,8 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 		if (avail_space <= BTRFS_DEVICE_RANGE_RESERVED + min_stripe_size)
 			continue;
 
-		avail_space -= BTRFS_DEVICE_RANGE_RESERVED;
+		if (!btrfs_is_zoned(fs_info))
+			avail_space -= BTRFS_DEVICE_RANGE_RESERVED;
 
 		devices_info[i].dev = device;
 		devices_info[i].max_avail = avail_space;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index b17e3c624672..ffb5b6663914 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -963,6 +963,28 @@ static inline bool is_sb_log_zone(struct btrfs_zoned_device_info *zinfo,
 	return true;
 }
 
+u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail)
+{
+	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	const u64 total = btrfs_device_get_total_bytes(device);
+	u64 sb_bytes = 0;
+
+	for (int i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		const u32 sb_zone = sb_zone_number(zinfo->zone_size_shift, i);
+
+		for (int j = 0; j < BTRFS_NR_SB_LOG_ZONES; j++) {
+			if (zone_start_physical(sb_zone + j, zinfo) < total)
+				sb_bytes += zinfo->zone_size;
+		}
+	}
+
+	if (avail <= sb_bytes)
+		return 0;
+
+	avail -= sb_bytes;
+	return round_down(avail, zinfo->zone_size);
+}
+
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror)
 {
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 0e4657347928..20180934aff6 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -76,6 +76,7 @@ int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
 int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 			  u64 *bytenr_ret);
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror);
+u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail);
 int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 				 u64 hole_end, u64 num_bytes,
@@ -182,6 +183,11 @@ static inline int btrfs_advance_sb_log(struct btrfs_device *device, int mirror)
 	return 0;
 }
 
+static inline u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail)
+{
+	return avail;
+}
+
 static inline int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 {
 	return 0;
-- 
2.56.0

