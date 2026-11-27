Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795791982;
	b=CzCbMK25omVmWY9pI2ns+wTbPBifCWcdt77MhpoObPu4S06esvNep78tI1lLze8WnWW7
	 M5zZCeXTKVVSL/TFyd5dxWGqvL7b/tFQuus5sC7NbRIlUwsbfqmEhZGtp8ki8iVnAnWIg
	 r8an9bSTiFM2yJiJmWcN1yj5/WNjFfSNraZINGI/3OHIv5CoGJ0aKbbGrIgDUaNef5VWc
	 HAQkXGQZFMtTByV6+iQMkRWL/8SqdFR85MScrMv7f3SjhE4xlUhDjmUrwzzCemaAsxoPQ
	 c/DysZh8l3YyyxkwQf+4aqnQ4r30iaKxJSq2trxy5QK14EfkuXgyBUjqmLqPWnBJutg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791982;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=syRyv38yeIqwa/BLJJzL2Cl1z+kOWIEK90onpIpJalM=;
	b=usrGjGFYuk7ofgafIGBbzP8QOuIpMUi0nUvIB1wF4alLckuEnkJTn0yCWG8nmpd7yqZq
	 Po4yieM0RxQdtIGGOPkVuttuthq0wGDZCH+XkJXyItRzQKWbnbBsvW+Td4JIQiHNrvKA+
	 xfORmVCLhLQrYsAMTjv2wzG+fQeZHmKcNE2e80+a0QSb/Z6bmmDDBZ0vFShcDdrHDr3eE
	 voB1BnxtBUeY5aDIGAPmmHj/FNX2tbMMsisusu5NMo6fHZnx1wvqoihM61BMka7H/0Mwg
	 148DMmojdbTNYDC8WVz7VfMjuX05yO64Lh3k/ZEHXAkZ3B0VXBBg6363wDU9vmbdR6w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JghohC9p;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=sPYLS9zq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB76606A329
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 15:06:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DB76606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JghohC9p;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=sPYLS9zq
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795791982; x=1827327982;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=dGrfR2yosAcLYLNYgmBfbJnsKmva/sCebjuFYETiVc8=;
  b=JghohC9pLKEbtrNjRzPSZBz5Fb4Ue+olXlICyux/vlm35C/vwyu49RWL
   p4awMNwun3rOm80cJWfCTpynikqRK2Aww+cFkvCevpJmN86gyN06M3yew
   pLAXSPxMn8li1D1oWhp96cKeObQ63vsMQMWP/14vj5yNSVcsr/dBuR+zE
   SZO0wJ7VGZGG1x0THhDlITiMW2oxXzaq2NJ1TUYwCiVvw9LkAhU/M39uu
   Z5fLgCLjqCkglqTceWPpYu2pEUQBJAQkBh5vSsJVxEPKlD0uwr2ABDqfv
   nC3/vZUBtXf987ydYXgHlyVqDxyDEWq/+VNF+ibKSIVmKHh9Wspw1Pj/6
   Q==;
X-CSE-ConnectionGUID: OCX0lFOFTvSvFOgwbD/5rQ==
X-CSE-MsgGUID: Uz7VHlQhTBCVsKJ/ypWv9Q==
X-IronPort-AV: E=Sophos;i="6.27,237,1786982400"; 
   d="scan'208";a="160943169"
Received: from mail-westus2azon11010021.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.21])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2026 23:06:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OF2nZKXlaDDt+thV7n91me05kU7OVuKC9EzVVYTjm51n07lJbbN0MWWUJPzoL4N1JEwf/xUrgak7onR8OfNESBx3c3vSuSDYIWws+s0B17ICASaKpuHUopjzYD/TT14CON2rmof8uJULNNVSu0REC4k7X3qeOHYkKGNu7sCXjmvl/ExAAPWF9c5hVBSNAzwHUtXzjEAV3WpukxrdcdVwN4/Ma5nStXAh2l6R9Lupi0DmWcfnyrRxBfNZmzbJ9JEaiJpdr5cqsv3nuh36li6dRHjZ4z+dMbDIF/jFEkSS7X/gHTYCss1yW+ord+ze0f4GbdgrdvVzLFKn7JS4baV6dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=syRyv38yeIqwa/BLJJzL2Cl1z+kOWIEK90onpIpJalM=;
 b=zQWbrBGnV4hnmn44XbU0WZJCgNRbHmpKUmYmPf14P8F+st6VJGlHWLqOhPGUGSYNTS+3xfVJ/omuX6dkGwfqMmB8nCHdPhHEurvVHRUovb40jeUANvtWV69gOAFL84US7fxpDFsE52cjtaDuePP9g6O/e34tD/5lCYt6tkkZts7RtzTNz9tbc/9c4//Az1EBt1aXi3B1DRxwhZKoQgGg7Ev6wtPeIRuaWNQWBYycLUsgf0PP94qdMqMGEf8BZ+589+da/T/3vzmQg9rCDYCA29D37PtKSxE+NqBNVsJXGDFUlTljg4z9HYP7B+ri8e5e0ebGCdbRvyk3kqlWtrmbCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syRyv38yeIqwa/BLJJzL2Cl1z+kOWIEK90onpIpJalM=;
 b=sPYLS9zq9QTEGhGc13u+U/9dfomF5ylXE8dNiIHz5a8Sr1tZqrrWbU347h3hhXAGYhQiDIZYCeoP6wbN28lyZ0HFwDLi+jQpcMmifC2GmQllUSFC5NQY2QroXN3Wk2oOpWU1CF65JfgO1MJ4siHBjpwu5CouxEtML2cW2SHkfuM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB7960.namprd04.prod.outlook.com (2603:10b6:8:6::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.10; Fri, 27 Nov 2026 15:06:16 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 15:06:16 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Wilfred Mallawa <wilfred.opensource@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 0/5] btrfs: rework data placement on zoned devices
Date: Fri, 27 Nov 2026 16:05:56 +0100
Message-ID: <20261127150601.803290-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0040.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM8PR04MB7960:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e20dab6-987e-404b-c68f-08df4c97fc10
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|23010399003|19092799006|10067099003|56012099006|261026140227099003|261026121527099003|261022075727099003|261022105027099003|261021123027099003|261021121427099003|261028144727099003|261102123227099003|261009223027099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
 JkId0DdM2XHNzVKCjT9OOBrSyrQZbvpPbTr7kOcgah8Bw4TrwKHbscp7c3PfwrwPjMPuVxmYcMhZsUM5fwpH0tJl5+WLmTe7MS+tc5UIInQZkWz+Ik55PZAm2wo8z1F1wKXjvQV1B7rr7AjWnsOauqKqQsizVx2RdMJboJ1DpfcjoFj5sQ16dDg2BFp3W/8QGdUeATl5yy6Dw0UossB1CK9ea5uKIv08ThNz719iwONqvrpEQMMqlTEWdfvIrUU5c1Xxvp2khfROvuPqwgrLvbhORXMNo/esvbEEFa+5vnbI2Xd8ULRB5Hu4D+pGPljOXuRNJ9quOcXA4a+tV3jQHFqinLD6mhNFa2qowvjR4B7AlJkiUfZf3iAiUv2jDyxyQpV2SMQCmZNB3GoZEMBpthEV5ggf5l+65MKNsKv4hIh2+aZq9tAWZvXhho8r4dEZV636EG1V6FCHbsimcgb2A87SInyfM/9SYzP/5hBA93rJO9nGSO0m5nVl3zRbUiyij/5jFIpu2dg7vpI7XJ+EoPy1UA7em/9agwsDOXmc6D4MRznKm3DIstWW1+FUtTfg2B3TyZps5TdfzNs3OcMVJQ5jgnQ23oEL7JpKHSPoxx9hPR9/NiojjCa96o6ZE96Y
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(23010399003)(19092799006)(10067099003)(56012099006)(261026140227099003)(261026121527099003)(261022075727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Ewj5tmBCpJ/9X8PdSk+Tb4H9UIOH31DnY/j7VqIoSp3zEuqpiIm2pLIzrbyn?=
 =?us-ascii?Q?al2cEwgrBxwZFPh1e/f2GonFVunQPTZ+f78UhwRYpiqJofz0uRds7P32pyk3?=
 =?us-ascii?Q?SiDV+CS65x+hf1obxgGzTjSNPMyESamY46FpxkVX9WkLK6YF/wQMjcaWwanG?=
 =?us-ascii?Q?8IKoeK1UM3zH/plhoEQD/fLWomeIli40Arv/1Mj06Dxwba4OLPSv6JvOtaXz?=
 =?us-ascii?Q?HrjwwGqAqe8GLh1UtnW8q86lz78j/cOrmieyQ+TnLAENxi3OKwXLnOXLU1PP?=
 =?us-ascii?Q?BFBWs6eSe/bbFVOH8dQnIGuneeiiMdHGTte5kbAspz7AzbffDXecdxLT8M+a?=
 =?us-ascii?Q?Myklj6l3Ok7A3G73iZ4F8XL0DA2br3sbLq1oH0bTtwc2go6LUQXTPPYuPQr5?=
 =?us-ascii?Q?7yqfCp8ovnNM7B/NTr+yVJ58r0jioXNDCOs7KA49KJEDFuSHPB7YyGnVMn9O?=
 =?us-ascii?Q?ip57a1ou3hWER/eLgs8J+HSw9oHzA3LccKDpjAhp+yQQG6mTiko0Gn3whaAt?=
 =?us-ascii?Q?GCMy9jK89pY09UmvWR3jLF4FtpZQltyHoizVaVA3bFqImfIUOG8bE++gvFde?=
 =?us-ascii?Q?3RVjw1x8e/fSmn1HIv+XaEpg8Jyzuu55rRVXFWWHcLegjl5mwrGm+uUp0p1X?=
 =?us-ascii?Q?gF6WCFwgs0X31En/qJbzZ1czFMfl/yGtF6e1tox6FGTH16XdoPTb9MUDDBtb?=
 =?us-ascii?Q?p9QHBQ5DEpf0jLOsGftAwNdBumxmSSLszjCKCTSc947I1S+uXRsHRGg4lMcL?=
 =?us-ascii?Q?7GekhZhHcehKEw2IoNwF14V3z9biz318k3+Z7odR2/fEH7RmnRbie+fHYm95?=
 =?us-ascii?Q?Le9B8rQ5EIL2eZA7K6tj/R63sk6/05bTzfrMHzdOaSfePOsetkc69B089ZnG?=
 =?us-ascii?Q?ogxw5yLrx3tX/I9WShCmi6PR3Kgpz83G+BAVbARAoUT1eAB5w24CR/V2AYym?=
 =?us-ascii?Q?QjZqvsGAbPhlU2V4SQsifh5MmjniTca3HuQbQ2jfErxQAP8rn9Ijja9Obxd0?=
 =?us-ascii?Q?d1/AsXZhk89LmgMLDSun85OgCdz6T7oWJKzlqNOsqt9GW8+r+QHFQaZR57p8?=
 =?us-ascii?Q?L450Y661w8JQhE0I9Qt26g+dpBdsnVRmk2bR6S9xMfUAIHEsoDDT6OrYgCY/?=
 =?us-ascii?Q?JASU77RuHSL8ke2AWEA2Ov90ocqQavyl/4m5fS6QUWqqR9aqhZJxVHNJvnnd?=
 =?us-ascii?Q?My/tKrk6Mj/90WDXNm7vf+Th+k+8iFyJUFXDYlbEj8IyQrueOaE05RfOhBA4?=
 =?us-ascii?Q?AahmTrnqGDyLzQD8GXz1MGRiBiLwxn6fqIzxGf4V4NW+x2VU79r+t/IG6JGg?=
 =?us-ascii?Q?iOMmYML+BO9R61VvbBIftzMFaqRSVNVRRUHQCx0b6ySCDq2wTnflJoi/luD5?=
 =?us-ascii?Q?1zZ4K7MuzXByv/+U3Q2D8P3SBzk04UC1u1x1jpZAesRbG9lHNK/RAZACbtRY?=
 =?us-ascii?Q?ptpqfkR8gumBsNfiq02k9wrN+bNfAJdvSN7yB6bgYrU+Vi95yyOWDDSVZuuN?=
 =?us-ascii?Q?YpT/BPQp8PtEg0NWoLzbsdhKWE1JD0gjelGjH5G1gs2VXCWzjIhlsUJCAMBd?=
 =?us-ascii?Q?oMVvGvRdGWOqu2iIbhKnQMPC75/aqEHlBdmsRrHZ/Msgdb6b4+zd42hIDBTS?=
 =?us-ascii?Q?WI/2RCowVksxmYV5aWtSAV8vosWN3MrmxFVJ4ju/L0ey4GDb/8SVtSRO53ND?=
 =?us-ascii?Q?ErbAjmGBiTlOl1yxXKGdrqrQBe2RNFkdVTDhg9wkRap57G5LuhmNAChpB0xv?=
 =?us-ascii?Q?hAkFLecvZ77hBTQIFzxf9QeFNkGm+cEusy4hPspKgOYAnK30dC4YkPsFy7Im?=
X-MS-Exchange-AntiSpam-MessageData-1: BfZdRbbODqYBlnjN4CI6AYXEnmHSNExv4MI=
X-Exchange-RoutingPolicyChecked:
	mN/9C2WC/Z2Kmat7uSYEhQw1LsK7R9A27AC8Xj9b1DFh3zsBzXVFmnh4ljXAjtd5JGkI5hFs9cL/6vjizRiUDPfc1f2pWovr/YOdikGhCdZaXx3S79h039VZW/XbqrCMr0aypZWnuldkfVJkUoW++bLEDa151wowz4Qu+JGmo6vui2Cv3VT6lzDgHmK76KTNbLXtd//TYpir+VvzSzlN+7Rtvx08K5y26MuBoKnRJoZtplak5k0j/CpFkxkmqFERzRoNl19IsTduZwv8mmcSncF+niNj4Oaaegw73G8omyhHFkJr66DskciCQtyS/Ulem4UM6VQZuXON4ca0Woq11A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i8myKbCxx2PGQfwe7k2aNG+4xK3mSk3T2FoHCLmj6xcioYWbXivKg8j5McS/K5gCGfYZNw+PWcBTk+llVGYxtrCvh6W1qn6qPAq7BmuvovxJPdwpUINOfTgz6+Cch3XHgUOEnPeJdy5ckNjB1z6nurMAMIEHh4lqyDtsgtdiwKcFTdqA1z5y+o9RdDthwmb1ywLTVd5NKDvdo6EOmOXbcq71SzANkijxBhGWxtgV9Iw/2R3cn00Y7dj7yEwWg+OHTXzDQLJcwKZZ+QITztibJL8u3Kp8q7g5JzRyp3k0AzlXpXLAt6xOB0jactQ2ZF4nfLH9kBCPPB1F5idZ0ZqHxDBKVK3BeNQUKhwUww0YiIMtT9nkTpXlxC+kcc0N3XjBgKG6n/n2HTHEecbjdKVS4nc598ERzjy8DXPUFlJMkDQ0MjaVApeHvPnIDSbfqxUE6kRphqRkS3U2Th0TXzHPdIP14Jyfl4oewjpEmF2SZZr62IIG17yAHUGv49zGrDtojZlfIk6SGF6RB7YrWgQYOiWq5EOshKaP3CSSr3UnHKz8AcyukfjBqy+gZQlzr9xXghISjn6Fxx5jNQhyUznuSEv4mR6n62a0sChWX5hFycwD22G/U0kDX0yFgvxlkLnY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e20dab6-987e-404b-c68f-08df4c97fc10
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 15:06:16.3789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rsHa9porj1h1AOUanF1M/IUb1Y506u7Se/PQjijhlW5epOpPVRLbw2LC8r+yDQZTNL2+pMsaZtBwDqLpdngc7gIdBJQCT5W6+MLyQnckMgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7960

Rework data placement on zoned devices. Currently zoned BTRFS ignores
the write hint passed to the extent allocator and always picks the first
block-group in the active_bgs list as extent allocation target.

This causes high fragmentation, which then in turn causes high demands
for garbage collection due to the append only nature of zoned block
devices. As the fragmentation is high garbage collection cannot reset
a full zone when one hughe file is overwritten, but has to evacuate data
that is still referenced by other files first, before performing a zone
reset.

Mimic what XFS on zoned realtime devices does for this setup: As long as
we can still allocate new zones from the underlying devices, allocate a
new block-group and place, the new file there. For extent-allocations of
already existing files, remember the last allocation of this inode and
use it as a hint for the extent allocator. If two allocations race for
the same block-group, retry to see if another block-group can be chosen.

Test setup
----------

QEMU VM (virtme-ng), 8 vCPUs, 8 GiB RAM, base btrfs for-next 98768e7ccd0f
with and without the series. Each test runs 3 times per kernel on a
freshly created filesystem (mkfs.btrfs -d single -m single) on a memory
backed zoned null_blk device:

  memory_backed=1 blocksize=4096 size=4096 (MiB) zoned=1 zone_size=64 (MiB)
  zone_nr_conv=0 zone_max_active=12

btrfs uses 10 of the 12 active zones for data. Writes are done with
xfs_io pwrite in 1 MiB blocks, buffered writes are followed by fsync.

Workloads:

- Interleaved appends: 4 files are appended round-robin in 1 MiB steps,
  each step followed by fsync, until every file is 192 MiB (3 zones).
- Parallel writers: 5 writers start at the same time and each write a
  new 128 MiB file (2 zones).
- More writers than active zones: 20 writers start at the same time and
  each write a new 64 MiB file (1 zone).
- Fill to ENOSPC: 8 O_DIRECT writers write until the filesystem is full.
- GC churn: 5 writers create 6 files each (16-96 MiB, 1.5 GiB total).
  Then, in 8 rounds, every writer picks 2 of its files and either deletes
  and re-creates it with a new size, overwrites it completely, or
  overwrites 25% of it in random 1 MiB pieces. The sequence of operations
  is generated from a fixed seed, so both kernels run the same sequence
  (about 5 GiB of writes in total). There is one sync per round instead
  of fsync per write. GC is the regular zoned reclaim with default
  thresholds; the counters are read after reclaim has settled.

Metrics:

- files/zone: number of files with data in a data block-group, averaged
  over all data block-groups used (1.0 = no sharing).
- extents/file: extents per file as reported by FIEMAP.
- GC copied: bytes relocated by zoned reclaim
  (/sys/fs/btrfs/<uuid>/allocation/data/reclaim_bytes).
- zones freed without copying: data block-groups removed without being
  relocated first.

Results (mean of 3 runs)
------------------------

Workload                              files/zone      extents/file
                                      base -> series  base -> series
------------------------------------  --------------  ----------------
Interleaved appends
  buffered                             4.00 -> 1.00     192 -> 3
  O_DIRECT                             4.00 -> 1.00     192 -> 3
5 parallel writers
  buffered                             4.42 -> 1.48      41 -> 6
  O_DIRECT                             5.00 -> 1.00     964 -> 2
20 parallel writers (2x active zones)
  buffered                            16.98 -> 4.47      53 -> 44
  O_DIRECT                            19.60 -> 5.25     503 -> 244
Fill to ENOSPC, O_DIRECT               8.00 -> 2.35    3920 -> 1261

                                      GC copied        zones freed
                                      base -> series   w/o copying
------------------------------------  ---------------  --------------
GC churn, buffered                    261 -> 4 MiB     17 -> 36
GC churn, O_DIRECT                     70 -> 0 MiB     16 -> 35

Further numbers:

- 5 parallel O_DIRECT writers: every file has its own zones in all runs
  (at most 1 file per zone, base: 5).
- 20 parallel writers: above the active zone limit allocations are spread
  round-robin over the active block-groups; at most 6-10 files per zone
  instead of 20.
- Fill to ENOSPC: the filesystem fills to 92% of the device size with and
  without the series.
- GC churn per run: base copies 45-677 MiB (buffered) and 49-100 MiB
  (O_DIRECT), the series 0-12 MiB and 0 MiB. GC write amplification
  ((written + copied) / written) goes from 1.008-1.129 to 1.000-1.002.
- The series doesn't use more data block-groups for the streaming
  workloads; with more writers than active zones it uses 1-4 more
  (24-25 instead of 21-25).

Performance changes (all numbers in MB/s):

Workload                  write                parallel read          single reader
------------------------  -------------------  ---------------------  --------------------
 5 writers, O_DIRECT      1660 -> 1981 (+19%)  10335 -> 11996 (+16%)  4077 -> 5691 (+40%)
20 writers, O_DIRECT      2346 -> 2928 (+25%)  12584 -> 12920  (+3%)  4561 -> 5283 (+16%)
 5 writers, buffered       643 ->  628  (-2%)  13165 -> 13091  (-1%)  5353 -> 5168  (-3%)
20 writers, buffered       842 ->  831  (-1%)  14507 -> 14620  (+1%)  6240 -> 6370  (+2%)

Changes to v1:
- Add Damien's R-b
- Reworded 'fresh' to 'new'
- Drop list_entry_is_head() use

Link to v1:
https://lore.kernel.org/linux-btrfs/20261126132820.570379-1-johannes.thumshirn@wdc.com/

Johannes Thumshirn (5):
  btrfs: zoned: search for hinted block-group in
    prepare_allocation_zoned
  btrfs: zoned: save last allocation as placement hint
  btrfs: zoned: allocate a new block-group per file
  btrfs: zoned: try to fill hinted block-groups
  btrfs: zoned: break concurrent chunk allocation race

 fs/btrfs/btrfs_inode.h       |  2 +
 fs/btrfs/extent-tree.c       | 88 ++++++++++++++++++++++++++++++++----
 fs/btrfs/extent-tree.h       |  8 ++++
 fs/btrfs/inode.c             |  5 ++
 fs/btrfs/ordered-data.c      |  7 ++-
 fs/btrfs/zoned.c             | 31 +++++++++++++
 fs/btrfs/zoned.h             |  7 +++
 include/trace/events/btrfs.h | 33 ++++++++++++++
 8 files changed, 171 insertions(+), 10 deletions(-)

-- 
2.56.1

