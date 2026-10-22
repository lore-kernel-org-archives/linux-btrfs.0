Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792660032;
	b=Zm2+By2nX3L6hY50CCtrO5Z9QE2DMjaaLEwFZlNJu396wRYtVt6BfkLTPI9pGISTRKPC
	 vdOa/a7ipOGnvvNp7KRC8eA4kAMPsxEKXG8C39eony8CA7w3XjQ5zS8FoQJhxU23jn2if
	 CkYI87XtK+klJCbFtsZITcomMIPORpLxBdKmRcvekXKL0EVaa4fPUsptUqdgtMfVRsKDM
	 xOyGS7xsTi+tjdlEZAB5HIGALMTUxFa0ysaAdW/6IoGpVPOBnL7CzRZ3JSFkBFy0r4kSp
	 smP8BDZUOy3ifbZN3PTke/icSGkRBXNqL3Cqp7HudajgxOmE8irRxwoTEUTebTSPLiA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660032;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
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
	bh=+2fGHHDtCrLjlLZ84SOdz4rBYvB3jNXT6TeoXOObI4s=;
	b=mvDtCKbAnlnaVQxocS3fRRp2OgOpaRrPFk4/wAag9Bc9MaqzveAKaZR2uZfcyrFA7+Sa
	 hndKiMQyNJb8huFsBFT+QbJGLZBLMP8pSpc3d39D5QHB07JXD1T4jc2q1rpiwbUO3q3t/
	 ryBbv1F1AS+I1VpDGnoecEXgS5da422uEGfL765Ih+7OeitSKOQWlR9gOt9x7/PBUFxhX
	 QVCBjQgEQv/AbmTvxCgSEeSbIT+ttqCHnD9NJfubUHEAeH6t9DD6pxkvGmCaXheoTl9Wq
	 yJDbRU+XZ7ybUeHFmzDhryVcemx6MNmRREgfqJBqotGAGcix9U5rKjVNQdEQtqaTY/Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=qNK9lQFI;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=yFKGSrN2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307DB606A31A
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:07:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 307DB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=qNK9lQFI;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=yFKGSrN2
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792660032; x=1824196032;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=niXCTADrYkyogEJvmxMprqbbanRmUSdaCQ3VDIHyW1A=;
  b=qNK9lQFIMC2JxiUf4PnsSIETVlJSZFfQBUZg42zy6RzXGrOQpGwqxaF5
   HvA26YTGFjqpMzCUJ+dZcSXY7QiEDMvoFADAFpE1spiiKTZ6CWR2x2IIX
   NMBRPXX/Af2wDDKpm6nLGPze9cAI6LGH0uTrfl071HYzfGQsHhZqO/5qs
   SSU+tRBDDmAtkwox5LJSdvfhI6S/eMmkFwfG+bfE4+as4xQ+SpoOKhnis
   0Wo4KH+oTypwt20IKzC/+he5ThdKLHzXeGPnsGZnxjZcIVtzZho/oVDph
   DLjU+i4HJHlOHG9WtL4/GfBFq/nTQU1GdQPhZOlQgziIokhkzXJgSPRrQ
   A==;
X-CSE-ConnectionGUID: fUMSt3VVQyqfm99uITTJ6Q==
X-CSE-MsgGUID: vJ4v1EPNSbmehaZiP1kaNg==
X-IronPort-AV: E=Sophos;i="6.27,171,1786982400"; 
   d="scan'208";a="158618907"
Received: from mail-westusazon11010026.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.26])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Oct 2026 17:07:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rVWfKgKVqK8+1lm2aC5tl8vj/2fcN0KSILzW783N8yUTnY62XT7uocZN96F+Yd5UYvQOwCz2qLY5JE9QBYLr4e+5roqtPQ60/oSZv+mcr3jGd0NYvpUQnhsTeksz7HmeFImfM4+zEpstcP4XmXd4T08gj0gId22Y9xqSvRcEsgAw5xQ+toUcCj1+cfoMURPWBDJxUEgjl6M6zvpgQiqgtUhxurMp+TNPyfuWH2LGnlhwYS5JhT/4Mt2Hn6Sbl/VCRRRb63z6idIH3aloBn2v3SVoFgs00/D9uBcawaBuhMKzqpROnq8WFB3Bx8i/7QUOe3+oGQvAAaMTKkRAwB1llg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+2fGHHDtCrLjlLZ84SOdz4rBYvB3jNXT6TeoXOObI4s=;
 b=wSnmrJgVSWiTAYnEF0Sg52vwuzP/e/lNd+2ycYHjL+eCkmfgfMu+UokV9izLlvbjPaxcJsZpbeOYwNpCQreeN5tfVLVxFRZaAKZOdwgbJ7PyspdfJbN3xWjyqfw047dPPUgLN+4rE9OIXYbGcTX++XQ9vv16FqU7XjiJKUOmOVUXPxnYpsfKvFD3cv0JmTjBA+k8QsSy2LU/0XgXNvlmc5SwmQPk26+Wvd7lJ8jQaWZ7Asq34/fnWbqXB9KcPaVHpVQ5m05iqJ20+RLF55nuqZwx3sIbhOEg2oLHysgZ3juol8o6vDg3N4/SoxTwhmTYwmzujoDIrNNkP8Xr+U/riw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2fGHHDtCrLjlLZ84SOdz4rBYvB3jNXT6TeoXOObI4s=;
 b=yFKGSrN2+4fzXAUHYzc/xVNgwi6r0JPtQnkU0jviGwYjaAHIS9ex6vxOSeTeTXPhXWUXUFf8mO+b37cmOcBMYvahUH5XvNjbVl3/QhlDCPGQo5IOh+rL18DRyFX0YCZylQZtItdOhUF3d3qpMKGK7saeC67O+ZEbohprvYmHRxI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH8PR04MB993982.namprd04.prod.outlook.com (2603:10b6:610:2ec::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Thu, 22 Oct
 2026 09:07:09 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Thu, 22 Oct 2026
 09:07:09 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] btrfs: force a transaction commit when fsyncing stripe-tree extents
Date: Thu, 22 Oct 2026 11:06:53 +0200
Message-ID: <20261022090653.2584545-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0037.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::6) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH8PR04MB993982:EE_
X-MS-Office365-Filtering-Correlation-Id: aff420df-8aef-4927-bf61-08df301bda4a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|1800799024|10070799003|23010399003|376014|10067099003|18002099003|261021123027099003|5023799004|261009223027099003|11063799006|261021121427099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	8aXUhaK2NuoslrmXE+LipB11dVNDPiLc4JOO5ljFjgl0j82U6v5Mb+v81KWA+fwMu6aUwNv1p4MnyRX/zVDb/V6ajqjycnxPtp7ic8+1tVE07281GibM/Gwh7CpAbrXg8tmqaR7UfqvlJBPQ1RFScRVTN6Gq/vWi7jAeYjuNV0ep0rafSgoXDkobkLcYhCkB+CqIg7KVoNvETJlOP4ZlcTlyt1eoHTVOEYLzuLjWmROMggd+Eh3mKm3v7nthCvGdw9axoXe34IfeFgqdZhRPhRbqfw6EV9DmI7Bnr62UqP0nLyuieZYP2CJ4F3xUsAtZ5ZlnGYNOoFJorFjPPj90pTM2oV3H15bMY3O2BJdW/cBetNW+1q7IUrx4YLj/kgsalWzE37Mrutd8YPYNzfH2Ktk9y4H229moKekNysAABxf84ZcBaulzqzb1mVfbFciow0Xw0BrYay6EGZ1zq0rwkV4dbRmKAkBrSo/H2bo28wlkpQlZqBVaXabGXAfBG8z8INvTnsUxeXFuvhJdGRMDU+UDir2mjJ6SQkOCtsBPeq7oqH5Cz2FEbv76ox70sGHxbWG4q/7PoWPewFXQoaLi9CSHyTtZicj5sHzKAvPb6ocejDT+HEABZQtVYRfgTdAaAxB49R/KwbIxtLwMFpYr72Z+h5wxdgqQM3b7r0Rfgaw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(10070799003)(23010399003)(376014)(10067099003)(18002099003)(261021123027099003)(5023799004)(261009223027099003)(11063799006)(261021121427099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BIbF3Q/1rPekk/W4rBGKfn4zQ4xn0NXZtX8Rq1akFCobZI4EDF3Ku7l30dLg?=
 =?us-ascii?Q?1z2ytRQ3QINQpyls6c+yj/sWBHn/oLMv1KjHsUI27mNXA1xUfNgSFpj0znwa?=
 =?us-ascii?Q?df0PnrkDgypf1KoozREmLO3gYcrPkqMlgL5YSsE/tps/1tjxxxGQuF+eQvso?=
 =?us-ascii?Q?mejXmkDMuxUTxn5OURsl341C3TJgzy6qfPmmgv8VKkuLXRAs1Clnf30rxi5D?=
 =?us-ascii?Q?96CjGmeIMtlfm1rmOTISzGWMZTaRY0CuF9yuJUCf/YQk5csJkghGjGbGhhPo?=
 =?us-ascii?Q?DlJN+D7rfl/Sry96Aub+T5uYEy9PjrHU8G2vRZR58TL2swAROO1KwTrFFl8R?=
 =?us-ascii?Q?t+buKtG0Xp3DTrcwAVLNn/Dg5HP75Jpda7Khx0ya70+8eeMKaWj4JJUhJht9?=
 =?us-ascii?Q?euOm7iHgGTCzMyx19IUrHV0WW6d5REAYzymlspryHwzucJ3aOPMIkzi1vX5a?=
 =?us-ascii?Q?oT79yZmgmqRQ6go0Y53t6S5VPxMk3ppKXLcQ0zB1MIn4UEGwFNwGenY/6D+r?=
 =?us-ascii?Q?sKpCzUS82uE8ordv3nQEWQaWA1uPgJrRp5s0A/QrNpAxc/PFXHEK2T2Gisah?=
 =?us-ascii?Q?jj5CXljDzWsS3sAzcXmoy+OxyduaNzYytJ1/UGnqy0kozPfai0IoOZ9ji5l0?=
 =?us-ascii?Q?suFHzrkwgOjDW9HIWZ+5uoDztyBoSijiiOpsDhMKJY6aNf553vIygHHBIJRY?=
 =?us-ascii?Q?VZAoEGfXFX3jNUAR+gRpanWDdms1LK77rWCV1cncFXgfpGfjWBbly9NIQU6Y?=
 =?us-ascii?Q?813UubfXFl0z87/KneIPnS8n8bG3yk6+NDc4xvE2xFd0WkkcAWmlP53lZ7zc?=
 =?us-ascii?Q?4p1sCNglzyvMY+AUAilypddcHBbqU63CHyDAnyx1aAQanxVJJaqPLjQO376Z?=
 =?us-ascii?Q?ynHs2dflQm5Vaml6MeeMKVY2/nkWgs6uYyqnfO3QTaaVHIYp6EDG3wQUXWDh?=
 =?us-ascii?Q?Fv/uG03AoXxFjGpiqUBpzzNPdLJVslZIm/8N8bWycwenKzuRqj4BD803CulX?=
 =?us-ascii?Q?laW4cMHSALMhrLr4aDDFzGc+lJ1Lwj/CipTKKxWGrfrzDD9njLHPHWbKeAoF?=
 =?us-ascii?Q?NZm3UOn0+HWoAC5fLZ7Rx/owrGMr3GE5E0QeBaODLVI1QdbxzJ0yCSdmQl+o?=
 =?us-ascii?Q?lb3bmVzdyuKVGCu6vastcTLesY8pa6FaUpZUhhKfz4nE4TuK5GOrwllzA/bk?=
 =?us-ascii?Q?Z4l/bCayse/WCHorvmUCF/UZcCUexS+x1ajS1e4zqIqYN5QrZY/3X3c4G4qv?=
 =?us-ascii?Q?yDN8Ml6pWyP5ECsF/wN3gI23UFF58L3R/T6DNAzLlYzV91d/uM7gyXFYZjEY?=
 =?us-ascii?Q?M3viE6uUkNNlW772AKrqkHoNzsVLFm9kHk2acU/pjfTGrSCj62G5ddrIM84i?=
 =?us-ascii?Q?cCAHhzZQgewdJRJFsLzgXjKOZKU29t3G8mmVsu8K8fM/LdIU/eQGU3r2H4Q9?=
 =?us-ascii?Q?31Em9B6eBwhUFl8+aIabh9f+dvUrGrHXPFpGZl1oDaEB+mDi0QMsu6Mx0cC4?=
 =?us-ascii?Q?4zbsqY1kD2ydhWrJ4/tgfHHIrFVqpUdq+/uVEXv6QQ7TMj2tDqt9NgoQ8zkW?=
 =?us-ascii?Q?9ppTGGDkGWBiS9GWOILqgaeEFY5b9Nxwgf6s/WAq6UqPdOmBGdVT3u4tPFw8?=
 =?us-ascii?Q?nJ/gbDXRC5GijnWpDmvPgZS3UmsQL0F6/tx0m80Upq2Tn/ceP2P1f6DVeaZ1?=
 =?us-ascii?Q?/qjM08SE6e4Szfb9dBIx6GWMJO0TK+sUsQscIyj8EV3gmmkhdQZBwfT/nLv1?=
 =?us-ascii?Q?JYEhNorf/17dK3unWF8Yxld2SA4kEJ5s0Jb88/smXNrGC2axe8TKT8RlaEpf?=
X-MS-Exchange-AntiSpam-MessageData-1: NO107I4sLp9nP0xDYs8UBC7Tk57MJ/ExJ1U=
X-Exchange-RoutingPolicyChecked:
	ug9djsHx25sFo4e/R3hCiDVsU/HvhosEE3/tGqi/jJfgC4p+GdgXwrdTtJYfjBQxyhg7oHwFoGirsmASEranRrAEh84dDGDLozrIgiZBrD3PSpQasoqNPumarl8A3y/qS1vo/w1I554p00cJcMZ1krxisN3wjpt7X+vn3cMXq1k0SYdTjwLArCYSOa6GMDakyODsmwaeYlUvjkY/2wOlV2Lg/Dsp+Lv3fGPdhFM2wsBnwZ01ufLASn1RpP6bUt75PG1APp4pFK3Zb8tJbIcGJfl+b9abFnNqdnNmgBlLU8JnYK95DBZ6UdDAQgHmfdMXCEbe58O10tMRlX/d+Q9gng==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AfRiCmZL2uYQFBPDS4CFTqwRVxzBwuLDD/7wHS9fYDHddEz1EZQSXDDnDDlvis0Erb+g940b1WCoFm5+esHFHzUhoqz6PdDWs22gbrT0kPdziQ+3gp9QNdKC0FXl3XK3evbUE9KVeI7z4LPmyFijqkd/JZToXjJjyZgizzaira9YSn2FpPz8pY6ZFziLTn7Yb7IPExaQxo8/6RmyvWCSSQrg3JANXLNQYOCt5h63hJet0WEtu+XHbsBbGqg7+bJ5h84O9AUu+WMpB5aOVWrtFpnaIgck0iN2CTbg78Jb0wuqkAHHr0wlW4OXREs5bmJ1/n4xnH61VLA28mDdBMdA6xhzJv3BtKGw6/fo5rCrpCwwulwFiTCh1UTyIUpip0PISM3YgwYWv2r71IdghnyD5QkSFOfK6Qc1JJaGgEH9l5Xnd8SQl0LCln9GeaBIB4zN7uI8UCLgErifowzroekCYIiMVs4Menq13cgqRSXVFyl841+esGDzzuBM6H4p4SZKwctbgwz/cxuKm5ej79tFALj39PSggRnJAoDHoXUeOIFeNHDRRHzdO68qhu+fEwBZEEDNgjZ8in/DVGiKT2LEO8HU+48iYSAhLMIYr5GQm6aV38PxJpEqhN/tQ/s77v0c
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aff420df-8aef-4927-bf61-08df301bda4a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 09:07:09.6773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XD0D3caJSwq0qEArUj1b6LtgSzzJK/SXnsT44RlW0NRF6moHOD+RmbQ6Kvt2+KFTsl2OeXSkk7Gkp8Jo7bK4wF2m1gCdpb4brFHJZ2O2yS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR04MB993982

An extent in a block-group that uses the RAID stripe-tree has its logical
to physical mapping stored in that tree, which only becomes persistent
when the stripe-tree is written out at transaction commit. But the RAID
stripe-tree is not logged in the log tree.

A fsync therefore logs a file-extent item whose logical range cannot be
resolved after a crash. Replay restores the file-extent item and the
file has the correct size, but reading it fails with EIO and nothing is
reported.

Force a full commit when logging such an extent. Extents reach the log
both from log_one_extent() and from copy_items(), so check in both.
copy_items() skips extents from a past transaction, their mapping is
already committed, the same reason their checksums are not logged.

Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe extents")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---

Changes to v1:
- Don't just fix the fast fsync

 fs/btrfs/tree-log.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1d9dfb63fc5a..e50f924bca59 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -30,6 +30,8 @@
 #include "print-tree.h"
 #include "tree-checker.h"
 #include "delayed-inode.h"
+#include "volumes.h"
+#include "raid-stripe-tree.h"
 
 #define MAX_CONFLICT_INODES 10
 
@@ -4741,6 +4743,24 @@ static int log_csums(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static bool log_extent_needs_stripe_tree(struct btrfs_fs_info *fs_info,
+					 u64 disk_bytenr)
+{
+	struct btrfs_chunk_map *map __free(btrfs_free_chunk_map) = NULL;
+
+	if (!btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE))
+		return false;
+
+	if (disk_bytenr == 0 || disk_bytenr >= EXTENT_MAP_LAST_BYTE)
+		return false;
+
+	map = btrfs_find_chunk_map(fs_info, disk_bytenr, 1);
+	if (!map)
+		return false;
+
+	return btrfs_need_stripe_tree_update(fs_info, map->type);
+}
+
 static noinline int copy_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_inode *inode,
 			       struct btrfs_path *dst_path,
@@ -4847,6 +4867,14 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		    inode->last_reflink_trans < trans->transid)
 			continue;
 
+		if (!is_old_extent &&
+		    btrfs_file_extent_type(src, extent) != BTRFS_FILE_EXTENT_INLINE) {
+			u64 bytenr = btrfs_file_extent_disk_bytenr(src, extent);
+
+			if (log_extent_needs_stripe_tree(trans->fs_info, bytenr))
+				return BTRFS_LOG_FORCE_COMMIT;
+		}
+
 		if (skip_csum)
 			goto add_to_batch;
 
@@ -5124,6 +5152,9 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	u64 block_len;
 	int ret;
 
+	if (log_extent_needs_stripe_tree(inode->root->fs_info, em->disk_bytenr))
+		return BTRFS_LOG_FORCE_COMMIT;
+
 	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
 	if (em->flags & EXTENT_FLAG_PREALLOC)
 		btrfs_set_stack_file_extent_type(&fi, BTRFS_FILE_EXTENT_PREALLOC);
-- 
2.56.0

