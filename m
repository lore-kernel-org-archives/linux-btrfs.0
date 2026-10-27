Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085791;
	b=dzs43P9Fyd6EWAwY1tmITiGbl0ETrLQgz433jd595usjuXWr2ZHHa+G2uNYlLnjegxJF
	 sXoRZUbXslSdTWpDVcAIFAZzPH41Wo8C02LhcxuiWWwU8NKrS7SqAmssFbzzI8ww+d6a6
	 RgUIyVaYccLDiSL+O5JqY80PV2J2BS30NoS9eXHhoO3GH+woKXUI5tudCiQ54hBK8tXc4
	 E1zKn2DQiLdhVtnGBnDLKK3GjKAUWbWfKYBadsjwtMTDfAeMAYruZK3+aG53Hkke6/B6v
	 MmfbtvLN0t4Ye6QYO7M6d73jFg2Bli+uQAXwtQoyIGAcsHPUpGHmqijgO6sxigrMqGg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085791;
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
	bh=VX5+qrZva7ypY+E5w874xkkn7i3yg3vdEm5qZT8QJCA=;
	b=PHcODyIudcg1AiGJrvy+Srbeyabmg3HR/LhuGhYMiHMc8O+ED+wpWkepFEIgyJcRD6i6
	 Hlt3jOsJudoz48oTEdW7n5blcKPTDSI89qMjEdm/MnCNst9Kbi5z1nwwPfcirYH07qqyr
	 wgu816XQNQaKEx5TKoSF5LC1b2f+0TWgZaLLkxdSB9rUHrhbA/qneyvb00vj94iybIxnq
	 BXI3cvUoT1XoXas1kSbvv99eO5xlil571VyHjDUM4sQ9+A1b6BQoIN84+TXt0QFFlNfmy
	 kUvhxwirFJfHkXNdTyjU/W+qdPeKL1Np58uW0meor42hdD63wQFGfG/5F2Jd8YpGHxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=jzSyBTTm;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CT7nmMck;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0606F606A31B
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0606F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=jzSyBTTm;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CT7nmMck
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085791; x=1824621791;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=B1asKZOGuL3KdOtbCOOnqoQhUTAO0+pH+9mZ5ci0jFQ=;
  b=jzSyBTTmV+LkMyvdslmUDXvFEacnbhKWdKJMYfe8pI6g8QQWCNk+DJ57
   vnBtNX9NjyKsT/gqED+SuhJPXBP26H180EC8y2NS1tIaIEpP2Tsu+d2jc
   5PheRU6AFwVOrM2FLFK8W+sGI2sQ2cemg3vihQTkBfUnpCvL5fJrJs0vE
   zEloTwHQMS+9flJgB1NYFKTktsU9aI3oC1mNk2JRx22labwA3SCTZaH8W
   +uFfog7YiyXiMzb1QeMtR5KwYTYb8dnEdqFTUU5gn8QCytZpUyiMiGULt
   vb32KQG3pXC2IobgC4xX7L2Zb2+F/o36b6UNeG1an4Oq12PnYYZYZw7KO
   A==;
X-CSE-ConnectionGUID: w86VIvPsQtOabNCG9WWciA==
X-CSE-MsgGUID: AnFZ4dCETOCi2bTGFttvtA==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="159092321"
Received: from mail-northcentralusazon11010015.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VeEBk3bdEWqf3ObexM/e/aX/msxXq+2r+OFmZC2VjZcKplrWHJ+NzwDrk+SYF8Aj+8QeNxDurUaPROK1DdFruQFjbGgOdpnoUX16HiKHC36gvMtHPi75QFqvmVlb8puU83LUxxqZ8R8woq4kEdqHL01VKTGrxZeUCOQqBZgyM8WXPdLw2ZQEFIcKDoJ/T7vZv5iaIPqry+XXrF5eV/0QdIic4a/LB9nwvWFBl6qUWyv8EK1GM3nZsWV3f46StJBL7AfiUKXzqyF584l15TbZu89p20e7RIy8RlPS6HbxhDSIMryqklR+BqxlLtnVZRuvMfdrVmzIm7G5vEVmEE65qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VX5+qrZva7ypY+E5w874xkkn7i3yg3vdEm5qZT8QJCA=;
 b=NZ7w1PMw4I4H/sPpJL0hRDwmPbK+ZyLlCKSESyZ+BoeaVwytzK17rwUZLzWmB0mkL8ZipO88yckyNqx8WQj2Qf9EnNI4RlGCF5VxtKDqXHeADgHUurBDjVWgzqqCtBHX7WYSjWPdx72Q5kIuI1hPzZiMhFyGzlrNFdf/UdWsAF2W9k9gdh29vl1r6H32usmadGgbu9tQjQBwtOzGJLLO/JI4GgzVPPEvKHD3hKNk8lyr3zX/PrOEFSvsMAEQzmWFpuFOTxw/8+JCzxbGx+1+9vCszHd2ouXF5bG4cfttZzHGQ0XvSxGRiq4d0PgjDTNcr0SdqmKXMTgPT88yC908ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VX5+qrZva7ypY+E5w874xkkn7i3yg3vdEm5qZT8QJCA=;
 b=CT7nmMckv/+UFyLXls04V2cxcGBcqwfhhU4oIPgLV4m8ACKIJAZJgSNXlPhAurjfzwmfUn6ysesd2GXUBw4VoTtWkxGcENfcuMQEADRQ6mttvvpS46uXMV3foeXjMNyYvtf834aFwlFtpQUhlyd4BsEGY3rOJdCazClVQOiPRu4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:08 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:08 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 19/25] btrfs: zoned: promote reset data block groups to the relocation target
Date: Tue, 27 Oct 2026 08:22:25 +0100
Message-ID: <20261027072232.419318-20-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 99448376-d41e-4796-3352-08df33fb2691
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|22082099003|18002099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	/gkLVtvSoB5814tG/vhxww5EJQW2UHsUVcJ4JxxJo+z5u9KMbqiTQrIpTISCCzVVQExSmFroaJM+TKwClifoh8RdVvtb3Wj2jYsNUuZPiqiGl7lzW1GsdIhfYdgpkVEFU1SveuJf16un800dO4ttp04hMRq2y3JtM0iV3FSIpiuMZ53qZ9BpC8+xTrBSSaSrz/ST6pEEp29f5Hj8OjYivLswFZ3JLmO/YkxE4aD0Dpqx947H+uPMH/uWNE4Y4iYtWGqTZ6xm5tG57z3eV/wi71esGWbbEqlFHW+M9bmZ8HitMADBGwgT3418s78Wa22lr53S0hdfMLSKoKTGhqevwP+4JhctG9p7trQoYi1t0376NLOrbWyIMjTp86Sx6LDOArYpUzYBR17Izolj5ntW6mw+/E27/c8nLsEOuxWEnOo23ahcKvZPGD53SeESH+ziUpNkV4DtjRwDezlz1w3GxHudbczdeiLD7JoOoxLVE3b27WcBoNdkOP6tmhBYZMgCi/tnHjrofgDh2Dx7MvEvMnFWzTSzRIQPMnq5d9qljL458lp9ELrMSQfjqYUwJMNEAj4LqvqSoMIAslfv4xhxUS1AlFXD2sesF0Czt5oEVrVTmuD+ntiDjdrtBkn9OBv2ZC+Dd812PoBqprPNYx0q5MJ1f3he7CEzM9CFXeabXQU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rvQm5+ZZ/3GIBbnxIg/En2kZLqjK6RY0dWUalDUAkkuQ91+sfjCixPSG4yQv?=
 =?us-ascii?Q?c9xMxH6KOyvgILNt+fPFc6dC4eDrHs3FJvDiFTwKTyjMObg0wFtOrHj5txxt?=
 =?us-ascii?Q?oc83yam937abxVbHSKZlTIiCNs3UKBtR+2uRl9iIV3Aorkgtu5UjoqqmzjSk?=
 =?us-ascii?Q?Xayq+K4+jyhMd8bWHpehPqc445KO8VdWf0mAhQWAjNcxZFdXQ/XViMQAus4E?=
 =?us-ascii?Q?fuLK+joBlqdlw6Ut5qlEGDJAUZPvAHycsrXcHAgXAnzP7aJqXSxbAO2srCEQ?=
 =?us-ascii?Q?I4R0T+vb7ctPZuPVZkheA0OQp1ddw3qn1qHMAIkyhtWwNIzSf4DP3nc15hBa?=
 =?us-ascii?Q?5jCwWY+kzYrMc5Ih2yLqiFZap+dszAoazpnQdPkhuGlEWbFA6z59jZtDVMkY?=
 =?us-ascii?Q?/zke1H21kAuxq6W4Wub7OX6z5DjL4/fpTlZfaSS+wyF777dOkZjqff2XIGvF?=
 =?us-ascii?Q?8iQpkkAzHtETjP7dTqfHMVBLF/EsBHNz+cWZX2S2FSeH1e2v2/aii9zLCR8L?=
 =?us-ascii?Q?yA6aolCPQ1Yf6N3T8hYJzSjmdCbCoxjwZjMNSz6bV5Qk6PgxgyiMU3RoRyzE?=
 =?us-ascii?Q?dcR1WJdggBjtpqwEGIf14TCeUkY0p3GSTcNGzjwXumLgCjISelzy+fYQokIk?=
 =?us-ascii?Q?2NOTzpyxTZ5UbP12rsml4qC3/JAwYtuIvF9sFYjSdLWLkxkIeQMkZh/CUsJz?=
 =?us-ascii?Q?cXUT1RZPRRYNJXAnTz/yMTaxb5i9CJsLkrtW3bHSTFGRRm9EavTemAUOqwJt?=
 =?us-ascii?Q?PyV1iHp8QihYlGzkBLR1yJOy4xfyHTeDtXHTDJRCCAWfeQRA2JKtKxdjlpCM?=
 =?us-ascii?Q?8dAB0Qmx9iuQUH/LefORtihQREAPZFH0F8T9vpmryh+Uv9NZe7YuG0nfT8Xe?=
 =?us-ascii?Q?9a2WfvZpLYpL7mczfif4PMBQJwYInIntltDm8o8LZPdDi5htHG59p9GUKAso?=
 =?us-ascii?Q?iBNISz/FiUsy/tLJaDF+NTqOx3rcIvRSuKKAPLGJ9q2FczqjbxM+iGDtaMUV?=
 =?us-ascii?Q?aDBt0v/8g8QTLqIMieg5ClrKRsnR5OFp9LkaNcjOjREPdrGEV9zqwEdmBG3I?=
 =?us-ascii?Q?v+dcNOqcggbwIDpKNI2B8v/vKmySrleuH7C3M/zyYaqLoDnCiGh87nvRAB+7?=
 =?us-ascii?Q?Z/1UAsE68C8ucX5jZGvsDH5Z5BXtTQMme44KP/CTJlXjm+y/FYd9U9MkNRlf?=
 =?us-ascii?Q?NX9ZfMpmxAs0BFFyZELey7mWX/GozrWA2YK3tgcSG8x5aWHw2BHR/dzzQEFv?=
 =?us-ascii?Q?sOIKGnxFsycJBptgLjMt2MhkxjMQFizTq3B6GL3DmOGXAHuSBUdSpOPw4sKw?=
 =?us-ascii?Q?Yv3Lryd6vgLfJb2xpi1D9Geb+Pxx8837+z7xXSuLqkwOfZV18uyivX1RO1jo?=
 =?us-ascii?Q?j/4blCoxAgmVBH1g6zdc+OOVz1l0v6XMFy8ZlCYRErOxuPaUzUO1ZWgrz4lM?=
 =?us-ascii?Q?YEdAbx05tCFmkwq7PaAPeWwM+k5LfsMcUFREX1ICB51UILaXjOfRByPFAU3e?=
 =?us-ascii?Q?Dfyxx5ZO5pl4C78YefZdKDYISSg7bXJc/YUX2Pb7vAxDN4cbttnwBEy1dJSM?=
 =?us-ascii?Q?HhkVGolfkveaVN0LpnEih4JJZoWo26sCU7c5yxsKupdy/es5DvlDDmKQlnz3?=
 =?us-ascii?Q?zdOe4294v5WaBPWm3KiSKIm1ooXKX54seCWY0MHjB8b5IkmuJPpnewWntQbj?=
 =?us-ascii?Q?l1YLU59xNMGQ7TPVVmULc1ZTfiM1C+CXt0K1+hruEFId0NPtTGpIjeGz0Ai6?=
 =?us-ascii?Q?+1KOI9aoy5ddikfYqH+v0SrUhjN0rCXOSUyarM5B3ANC15NGXwUsCDlYA/Pt?=
X-MS-Exchange-AntiSpam-MessageData-1: /Bxp+7VIUY7HaV7hqIQV2VwFSIJBj0Yeqfc=
X-Exchange-RoutingPolicyChecked:
	ZYMhev6/vEyNq3k+1px5NWMyCFYxhSnmH/d3Mw4xLpyxAqrgqOZ4UWbTCegQn44Uj7C8Yqdm+YtYYQplvPbKsnWIneJbv1OsKEHdyzIQw8paruqjtvHcpYAwgpVS9Zz4/20nFoEWVDeLXmA/awIYXQJpr1aqYsgXdjF/tGlbRIpZhuiQ+SWnZb1aeOreX2ovD/L8EBCWTpDW0EtYFf55IzF3oIEq40UhYlInS6j/z+eEQI7LFellthR8+eRop1Wwog/0yB6FmpgsacoViLfbzN+VnyPpABk92KWr2+Nx1kn1WtyX+sbX7ixmCJRJBCEY6ufbaw8uN28xqPm/jVnFWw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qDp5i4GOeuxVsua+5kByHeXDoao+y0cBt2TwC5Q1WEusRsc/qNFZDrjnFuIT/muaVth1iC5/2UbDuXGlMwsHrx2gwEus3yrhc9iP67oqh9MLFDv+JQZHEjgMS995QJ//ZQL/XQ8V/fu5IyUUAfLLokOcA+xucjy+83LmJHr2mTJUYy5ymZMBjQ1/6bVfdlP3nAfwN8ofFBDfjjgh3/bD3Ntn3J6gm3Hqw3n9klP+M36smUmVnl5cImM2m/WLycn1j8GGGhzFgBKcQjXcbgkcD/1KkeeSAVi38H69nAsentQoSCRrMj1e/krpkPG72qGNXKB18PvVki0Hr+eMzlc5FGUEYMZWfy5C69uDCUyL+ecUO1G2RTBPW2DeycL5C7YV2ds870+nACR9MePrc5VIVBne1Lfsac6Qck84WRtb2wzqU3ZUMItGHefCiZfySjETUoddBG0utP0BCRdmlvDXSbnJWlTOGJVgO553xqwkSGeuCb29ymRfsiQKBOCzpxD1k7yECw8oq668tSQ0LMYhvrLrLp3cdGkQPZOuJmleRYUCLrF4EGLdXjIDk14NbWlJmWLYiPdE2Awri6wIqI61l3PFcEHLcB+Nqk721HcrmTK/8OZXYe8L7hkOy7P7JdU4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99448376-d41e-4796-3352-08df33fb2691
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:08.7468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aIFkqHRTOFSql+U1qM4xmbPLT/jdsCJibduFW05/G44fNDsgXOjgWUpHBHxgwdBehxU+i7dnP6xM+yHx88/+ZrdQ/rVp6rvWWmnRSZkHohM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

When btrfs_reset_unused_block_groups() resets a data block group in place
and there is currently no data relocation block group, use the reset
block group as the new data relocation block group, instead of returning
its space to the data space_info.

Returning the space first would let a waiting data write take it, only
to have the block group moved into the data relocation sub space_info
afterwards.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0857b24a3169..40d1cf799d64 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2974,7 +2974,8 @@ static bool btrfs_set_data_reloc_bg(struct btrfs_fs_info *fs_info,
 	return true;
 }
 
-static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
+				   u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 	struct btrfs_space_info *space_info = bg->space_info;
@@ -3034,9 +3035,26 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 	bg->free_space_ctl->free_space += *reclaimed;
 	btrfs_space_info_update_bytes_zone_unusable(space_info, -*reclaimed);
 	spin_unlock(&bg->lock);
-	btrfs_return_free_space(space_info, *reclaimed);
+
+	/*
+	 * If we need a data relocation target, promote this just
+	 * evacuated and reset zone to be it directly, instead of
+	 * returning its free space to the data space_info. Otherwise the
+	 * returned space could be handed out to a waiting data write and
+	 * then yanked away by the migration into the relocation
+	 * space_info.
+	 */
+	promote = promote && (space_info->flags & BTRFS_BLOCK_GROUP_DATA);
+	if (!promote)
+		btrfs_return_free_space(space_info, *reclaimed);
 	spin_unlock(&space_info->lock);
 
+	if (promote && !btrfs_set_data_reloc_bg(fs_info, bg)) {
+		spin_lock(&space_info->lock);
+		btrfs_return_free_space(space_info, *reclaimed);
+		spin_unlock(&space_info->lock);
+	}
+
 	return 0;
 }
 
@@ -3414,7 +3432,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		list_del_init(&bg->bg_list);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		ret = zoned_reset_bg_in_place(bg, !fs_info->data_reloc_bg, &reclaimed);
 		if (ret || !reclaimed)
 			goto requeue;
 
-- 
2.56.0

