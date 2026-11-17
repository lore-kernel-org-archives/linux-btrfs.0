Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794916313;
	b=Uy7JXns0SAiQl1Xob2hrd0uF7QaYWPIwfCb9xLdS11F3irDMeiuv6W2hvbGqb8a1SQU8
	 gXMMFEiXKjCpkPVKpmVm3yKiFR463parjPl82ejEg5tcbxzExURH/c1ojhYQU52EEXodU
	 hyy/FZCcseQmM+srEUyyNwQhOPrvQvaUzYpq97qpHXGMSllRVcRPDWmD8g3+ClgREdsmg
	 OR4q1iGruW7CLTvGM+ECOeTV8DtStLyVK8bvuLiRkhUrCcM7NwV0ZMK+yabkW/6nlcB3W
	 wTnyJP+eRY2pH2uSzim4yLS4HRKNXGzLDG14ZaTkio2+o7PPE4A8A6eqvSmeKKlR/aA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916313;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
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
	bh=voAyIPcJGMcTuE0rXt2c/ggtW/4i1kbQZhWFm7WFL2w=;
	b=5hHd1C0jCPGyT/XxZsJF9XGnxjMIF8LRuP5BeOgZIaAona1g3F1Sl2OQOe9ramAg7XjB
	 sSSjtWxTEo8Cmj/H35gSr/q8iV/TZyJzs/kgC+Y5z6c60qIxLhWqkNhBnqUkW4hmBFtYZ
	 66HEYGw+XE9ij/6lZoX/tsbCxHBcXBX4biUvuUYhe5L2ox4jxxmEX64Rf8Dv1KmVOW2Ma
	 miT/5TNR3wJZ9XXal3n76eraKNL26CMcwyHYFB8gRHlf+o99IZh552367963Kbd5f91zI
	 /A1NAbYKkFJ+su6uGjmvuRYCPJdC1TAlb63+88daXllpq/dqu7PLHJbMpZ9INsUcjAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JA+yR4yI;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=RoRCNqH6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D1D606A31C;
	Tue, 17 Nov 2026 11:51:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22D1D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=JA+yR4yI;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=RoRCNqH6
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794916320; x=1826452320;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PddAIhKPXw9ZCssM0H9V6K55TXeYkouz45+fq9KZFHQ=;
  b=JA+yR4yIAZ4f2vHJhu1dEUxZHWrDJj+DYWuY1045jGO7vMJ9hR79qLyA
   zGxkbRPdzcGqOJITgC3PsrlYEC/aTU2Ui5Y/5NbMDmgKx5ibqd30sun0A
   ZoGZyjq0AZ82Lguw4HU3vdm11Rb+HTTAWljt+P/ebUq+TjM2MX48Yzhmz
   e96Fd5Sdush0UGgbk1iDqnzoViVZVh3oZKRUaiPip9oN4s+x5+ZTw2A2e
   SIsevcNjr/IhZ328XCTmGA6gC0WLQhdiPyT3gsaYHxvEqT0VjHP3IKk6f
   FWFUF08C40QLGgbVvwLREXnu+8OKhfftCo4ci/dRx62QgdFUMdmKTGhVg
   A==;
X-CSE-ConnectionGUID: gXFwOv2ESKymWGfTrQHmCg==
X-CSE-MsgGUID: BtHdSKCyRROKawz8V3JH4w==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="162068282"
Received: from mail-northcentralusazon11012013.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.13])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 19:51:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FEbzIz1QrAuf9nY3leA7UMehxrbDjnotUQE5ORmA3PnnV7FaG3Al7ZPppYFDE+eQvTfYKiPXnB+1BhwX8bUadrbHuDfOlGir5zECJDi3quLdzfpTvguV+Uk5rsWH9FcxZfZ+XJq6CeZ7d8bKAncsVhImsC1FwzlWrOG436kN5O9vAj14dTQohrG5E7lw8BIsXhlEHFTLn23BPP3/VO/GrIUS6PbZsBFP+jeFPG3v0t7Ui8bAuXS7AYAwRi6uh17v41jnjP39fglShyprYgSXKqLA3GCLsinQy4dRyK1LJ07zWfS+rSSgiSSRdc4LpB9+5Hs7yqE3qqwiXM16KOraxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=voAyIPcJGMcTuE0rXt2c/ggtW/4i1kbQZhWFm7WFL2w=;
 b=uagLp89K58Wgy1Ck/hvhX6iW1TvW3EQ1iX+qIlSdaio8vjVA1dYUnLzKnN/HcTiUWMQ1Et4DeanJkbj6qJtphO6JCuOK8HqgrJopxv92h3k8GyX9zK64DeCBEVYHKau57yXD2qe2clFubAtSG7wbxbR3mFvxm46tNcj7gNKVQce2D/m6Un6eEQ4tmLkRzSUt6yH89xmudUtqoOzL6UBrIbFlPLdTkP28g67x7Cbwp/qhIFuXIjnaBDQAeFAnR7mCyCM+cWH8km51rIWs5zGYuLgO1s03/8Bni9NrVhNzNzPTQiFLAD4AvKd8Cqk5BkDa5rB9YlqsgMB5MZgLbG5bFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voAyIPcJGMcTuE0rXt2c/ggtW/4i1kbQZhWFm7WFL2w=;
 b=RoRCNqH6KzYbhtCEB8cod5nCeI+gNukt0XOLKvbSbomC8YLozUIovh02N+bSmb/1uOcKCKo8yJOT56wTf4Z9jHcZOjtf5mRDRYhtK6hfF1BigJOx2eNO5VewZzs9zjtFB0kOHyWKOwM9Tp95mhlPPPJHLpHTP9JOiAf//vYKpWs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH8PR04MB684086.namprd04.prod.outlook.com (2603:10b6:610:32f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 11:46:46 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 11:46:46 +0000
Date: Tue, 17 Nov 2026 12:46:39 +0100
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: socketpair@gmail.com
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: zoned: reset leaked zones on read-write mount
Message-ID: <avw98epZjlOLcu8g@mayhem.fritz.box>
References: <20261102-b4-btrfs-zoned-reset-leaked-zones-v3-1-7979bda654ff@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-b4-btrfs-zoned-reset-leaked-zones-v3-1-7979bda654ff@gmail.com>
X-ClientProxiedBy: FR3P281CA0179.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::16) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH8PR04MB684086:EE_
X-MS-Office365-Filtering-Correlation-Id: c5e3898b-2ce9-41cc-4584-08df44a07537
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|19092799006|23010399003|10070799003|261009223027099003|18002099003|22082099003|3023799007|261026140227099003|261026121527099003|261022075727099003|261021123027099003|261021121427099003|261022113327099003|261102123227099003|261102130727099003|261028144727099003|261022105027099003|56012099006|10067099003|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	PewkQYYPfpzL8oDqIDe1Lx+mxTp3ablpnFZbmlnxq/0iiXdAgoGtNR5GJLmEyCvEAJH9XNa+6uHAjF4g4v1ynG5ckpne1vPt8toGR/00pu2THNZH3OKX2Zo971ZQY6nG174J0mBlqOXD+NSiaGTd3W5TZGbk+ZPer5MqfYo/lW/U5dwwxHhN3PDtDj8iUTVHkuk735m9hng4mzzsqI5GoHEjdEN+rOmaVMEqktcHDIMn8H6o8CtNreCUs8wfd40fVafg4CPJFSRi73ilJjIXKtrkMkHEyRoY+pzW3Wj1FuKmZoywfdjYbJ5aDGSgVDGguZFQSO30/Oj7WQn64m5uBhr4Z3zSHf4FbPbZLMubrrzK+m8/Vuie9CXH02S/i/oaVB/3/R5JyamUzOJ5it33NopP64ek1PB2XS9prbt1y0SgdCavaDPQTBaFiKn4on6wjrX09yHPwKJwckuXnUYEhT65UBZ52Rcz/R2pteAHBM6Rc12VAVCt6wCJbg68KeLiVKRVUQN/5GnjqoDQ1CJrXjiNspG1ZXw0Ri/GMxXZk4BrCvWdSTtWs3CP+4mXfUUKevZmNQODhzRZl6YAluIPj6D47sbUfEQzf3xfARbMX2C+XNHav7SOmBtCXN7FP0VplTzFJh3DqQiXzWO797/k8q1kLVZGeKPFqN5lRuikPT0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006)(23010399003)(10070799003)(261009223027099003)(18002099003)(22082099003)(3023799007)(261026140227099003)(261026121527099003)(261022075727099003)(261021123027099003)(261021121427099003)(261022113327099003)(261102123227099003)(261102130727099003)(261028144727099003)(261022105027099003)(56012099006)(10067099003)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QLVbPnSFCWzsYpG6nWBSdJpE7kzlC79Raui81qO1X7rqr0pxEksRxvyI1+uv?=
 =?us-ascii?Q?/p/vxd/U+tnpawRDyTBPzobDYAFceR/tbkul556FSRp39RLq0uL5f09VWl30?=
 =?us-ascii?Q?DF8HklGYV3HExAUafxfq2r4MC7lCCzrr3cUPNx8irhrJjzZA7J+mSr96cX6Z?=
 =?us-ascii?Q?J5yEnr6VyoJnDthYaCjJxuQ3aOFiW99VtvIrB8YTaB+QkTfjPQpbjWAJ7YQ6?=
 =?us-ascii?Q?/gg5g1boonvL746xlQxR9Uc1MSxRA3gOVBfTwqN4G6QXIEq9veapYxsnWQQZ?=
 =?us-ascii?Q?ZkV5OR3QrHhuHv10FN7dC1FXylONe75EOfrMD1dZLRCFjIEC2+CApHz9vXxp?=
 =?us-ascii?Q?7+a6ErjOHOkDEFZBofd5c9xkrCNein9ZLVYDdily1i7+kitPgQSkxqgEfLYe?=
 =?us-ascii?Q?nfvqLu9FiYCwTvUfzUT1J3YsrlriWTMHyiMa8r9Yk61clt+1D4hW+15SC1uf?=
 =?us-ascii?Q?cDU5VFTS69lvm3qchPidybTy01kOKJ6fGGc9qEhkhXvSCjc7wstdvIWdALKg?=
 =?us-ascii?Q?8Mk4wvQYFtpWBDNPKLfdm2Mt+46bbK0WuKBm+EVZY+3DXGmDlBp5vPng51Vn?=
 =?us-ascii?Q?VFQZ/20DpwBTgywIWjz3IZBSKWSZ7bwVYT0RJuu9jrJIfkPe43Aaiyh98YhM?=
 =?us-ascii?Q?KeTw3r8dIDq0CzD1Ahsav7IzlyQfgvkBX9lsE6/Bfh2znwjJBr4zZXK7hPZL?=
 =?us-ascii?Q?GBydL9X8fxCn3WhER6/t6T+jFNDxAlxU9Yl9FnRuZYxi8pDz/PtRWaeFHCTa?=
 =?us-ascii?Q?0qv7raNNOtLbDSrP03w9Kb1HCpPLK8cyRqxbB2tcJ1gyGiO1JN79nWWMSnIC?=
 =?us-ascii?Q?GWDOacnOfptXXCuFW7OMXbXFJ9KyE8lfzoMKnTjuOihlBYTCtdZDp578RvgU?=
 =?us-ascii?Q?biMnx1SDC5cHPdp9DAy//Dkot+MEphv+UD9G9i9rUzWC6ciKISOYtxJVL4Gw?=
 =?us-ascii?Q?WcA6Pt6HQWVrIR8d9m+sVpt2gsNDihfczc7nAYVmLgEKzImVZPwHWUVEM4dB?=
 =?us-ascii?Q?9bzCzoJRdkU1e2v+cBZfzx5pgb2ZryGD2twe9dOYDi6kUCvxA+7fHr2Q3CfZ?=
 =?us-ascii?Q?tRCliYhFQkEOhqz8cAxgmDIVUtjoPvkYiXII94nPz2Wp1ink5D/MVqL/jG29?=
 =?us-ascii?Q?QjSke6875UnzcnpStZLPcqSEASU8p53hf+2utNgW/0onrd8QvS8+yosD8a+A?=
 =?us-ascii?Q?Ii+VBtpm+6PSO28IOtpBf2dXlWTp2TQIOHbJMSsvFbNwQXhvfCaixNBrc4Mm?=
 =?us-ascii?Q?/B2er2tZIGxvGqJW5YhE5DEz/DlTzlSfO9zx+zcTadg3ZPYems/CAxM2+50P?=
 =?us-ascii?Q?nWgXY8xyJnDWG7AsS2vG41f2TOdMNrxHWcPl9AEOwrKctOiUyEbSJ0qo//QF?=
 =?us-ascii?Q?WIikPx5271BKk5PnHoTHzoBRl/AmmDT0SCBFH8LoIPxETw6V32sJIBuCFukE?=
 =?us-ascii?Q?ZAq9aHw5Px/ffjSgEWA6ktpgzSaf/GL7qb7MyZGTikiF4COvwSWwidnYWOZ3?=
 =?us-ascii?Q?GoE0b+qWRRjY8zDRjtjrsfmHKOAkIs7EjUhmHMllxksD7zqAJaAXDBinSD1+?=
 =?us-ascii?Q?rHbKLXxSjLATafxcSEvBk0QH/idz8xAZ6sr1qAKh71m9MlLgzSNAGaLs4nMO?=
 =?us-ascii?Q?WbTtFbz0o5kKRMM/sxpVXj+xpzFZJlpTOxOzj0nqOZ5Z2067xabmSb2qHjNn?=
 =?us-ascii?Q?mHSZ+17+DH3255esWkeb2ju0in3fYU9Xns4S2oiHLYhFI3OZVr7yEGTUclsv?=
 =?us-ascii?Q?gYSoRg6kiq+4NqbkLcPunalBGSAlCjrmQOkGFBk2ZO649xDjxzz9xteOOFIA?=
X-MS-Exchange-AntiSpam-MessageData-1: g6WaEECKAHiauKMP7GB01VhO54KWN8hGwhY=
X-Exchange-RoutingPolicyChecked:
	hlzsEyZRFwQh4cpqVnKl24DaJg+lhTKCSxl29EmklbKnCPyBP6YXxZ0Cu27DdleYGl+nfyo05gQelQYbxvEJ/uKE2c1qqsetQgNlwaUkcWIWXJwA91PEq/sJucmIaTbW417KV1SuhbBDC9j7FAMww0+UvxE/CiSiWn3plv0vwfum7Rji5j2KHWV/ZJbU5nbGL/BXYQ2bWHoSbJ4AtiQV6Jbvz307eTJRvyFrzQJIs0dPkcsDFTDGH0JEGQ4+LvwIVK9JqqsvTzzMpCbOYI1udFYjAKy+RktjGcaV7OUbuPN5tWT8UXnF7DDHluVowDSVxl8/8jHidRwclT1wSk91lw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AhHiTuMuRrub7MyFh3e93p9Ujc/U46invwtmgQjhnCAZ16fEXj+YsaYXcGLihhnUdzFYttmaoLz61+2FGQYrAA/lna7nreG/yXRjAa3/vqyjRrN8NWz3wfdhxLwnI/oWiSO9I88b2iYZ1tM7KTjjQdvZsOdKmh+ujoEVoeTnNT4mI68P7ZhpRJiezE3iVoboPLUgtRqCiMQa30XwEM7bZ/LSlVKS1iiK1k3OqV3MCTEBhW3pvdo9ci6RWPnKhrX/FtvLeP1R4C7k70zIe0PJuQpToqTGfpy7xS18kxbgh73NeVCuNEOObiYaf6+PCWaJrYRgtfrYE/T4YIspBVVgZXy2y+csvMIcfzKg0vz4wpwnvg7aTbf+voCGZpna+M65BSnyy+CXnAnuqWcqCQ+R2yNdsWIOyo7b54AuJPfn61k2OUSm2pOapEiL4zKscFasEAz0eJWadRxwkipn3nMC4HJ2b99Vh+5MIDvO418ob04ZLpy2sTHj67wHHMEU7QxZSZfHh3tlzJqC2Z97OEAw4nFyKN/K67fstwSovpzg7DmnUfH4aabCtjbP1u1cyqD2ku5MqkjSZiviAWjZ12phLLny6vTy3gkYpBlfmRu/ugxWOr2IK+3uDeAg5nFE/LHe
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e3898b-2ce9-41cc-4584-08df44a07537
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 11:46:46.4380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y5B4WRax7U2RxBTrpv9XOM6c/R1RQqZ06KgZEgtR1aYgkM554agsXR/9COy0GII2VX6iSxxfhO5kEIpDL24DCPRQaGEGOVAy0Ykcccd0D88=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR04MB684086


On Mon, Nov 02, 2026 at 08:35:04PM +0500, Mark Korenberg wrote:
> If a transaction commit is aborted after the zones of a new block group
> were written but before the superblock was, the chunk item and the dev
> extent are never persisted and the zones leak. The chunk allocator skips
> non-empty zones, so they are never reused, open ones keep counting
> against the active zone limit, and btrfs check reports them as
> unreferenced.

Sorry for the delay and thanks for picking this up.

Please mention that this needs btrfs-progs v7.3 or later, older versions
don't check for leaked zones.

[...]

> Testing: virtme-ng VM, zoned null_blk with 64 MiB zones,
> CONFIG_PROVE_LOCKING, this patch plus debug logging of every decision:
> - not zoned filesystem: nothing done
> - fresh filesystem: the first mount resets zone 3, which mkfs.btrfs
>   (btrfs-progs 7.1) leaves written outside any chunk; nothing to do on
>   the next mount, btrfs check clean

That one is fixed in btrfs-progs v7.3 by commit dcc41ad6 ("btrfs-progs:
zoned: refresh stale cached zone state in btrfs_reset_dev_zone()").
mkfs didn't reset the zone of a removed temporary chunk because the
cached zone state was stale.

[...]

> +	/*
> +	 * Chunks are only removed under reclaim_bgs_lock, and their zones must
> +	 * not be reset before the removal is committed. A relocating repair,
> +	 * started by a read error during mount, may already have removed one in
> +	 * the running transaction, so commit it before looking for leaked zones.
> +	 */
> +	mutex_lock(&fs_info->reclaim_bgs_lock);
> +	ret = btrfs_commit_current_transaction(fs_info->tree_root);

On a filesystem without free active zones, this commit can be the one
that aborts with -EAGAIN, before the reset could free anything. In my
tests there was never a running transaction at this point, so it didn't
matter. Can you skip the commit when nothing is running, or add a
sentence to the changelog why it is safe here?

With that
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Btw, I tested v3 on top of for-next (146946479b45) and told Claude to write an
fstests [1] case for it (zloop with dm-flakey on top, power failure after direct
I/O to new zones). It fails on for-next and passes with your patch, I'll send
it to fstests once you've send a v4.


Thanks,
	Johannes


[1]

diff --git a/tests/generic/815 b/tests/generic/815
new file mode 100755
index 00000000..f5969e1a
--- /dev/null
+++ b/tests/generic/815
@@ -0,0 +1,78 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
+#
+# FS QA Test 815
+#
+# Simulate a power failure on a zoned device after data has been written to
+# newly allocated zones, but before the allocation itself was committed. The
+# zones written that way are not referenced by the filesystem. Check that the
+# filesystem is consistent after the next read-write mount, i.e. that it
+# doesn't leave these zones written and active.
+#
+. ./common/preamble
+_begin_fstest auto quick zone log
+
+_cleanup()
+{
+	cd /
+	[ -n "$mnt" ] && _unmount $mnt 2>/dev/null
+	[ -n "$flakey" ] && _cleanup_flakey_dev $flakey
+	_destroy_zloop $zloop
+	rm -r -f $tmp.*
+}
+
+. ./common/zoned
+. ./common/dmflakey
+
+_fixed_by_fs_commit btrfs XXXXXXXXXXXX \
+	"btrfs: zoned: reset leaked zones on read-write mount"
+
+_require_scratch_size $((4 * 1024 * 1024)) # kB
+_require_block_device $SCRATCH_DEV
+_require_zloop
+_require_dm_target flakey
+_require_command "$BLKZONE_PROG" blkzone
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+mnt=$SCRATCH_MNT/mnt
+mkdir -p $mnt
+zloop=$(_create_zloop $SCRATCH_MNT/zloop 64 4)
+
+flakey=zflakey-test.$seq
+_init_flakey_dev $flakey $zloop
+dev=/dev/mapper/$flakey
+
+_try_mkfs_dev $dev >> $seqres.full 2>&1 || \
+	_notrun "cannot mkfs zoned filesystem"
+_mount $dev $mnt
+sync
+
+# Direct I/O puts the data on the device right away, but the allocation of
+# the zones it went to is only persisted with the next commit.
+for i in $(seq 4); do
+	$XFS_IO_PROG -f -d -c "pwrite -q -b 1m 0 96m" $mnt/file$i >> $seqres.full 2>&1
+done
+
+echo "zones before power failure:" >> $seqres.full
+$BLKZONE_PROG report $zloop | grep -cvE "\((em|nw)\)" >> $seqres.full
+
+_load_flakey_dev $flakey $zloop $FLAKEY_DROP_WRITES
+_unmount $mnt
+_load_flakey_dev $flakey $zloop $FLAKEY_ALLOW_WRITES
+
+# The read-write mount is expected to clean up after the power failure.
+_mount $dev $mnt
+_unmount $mnt
+
+echo "zones after recovery:" >> $seqres.full
+$BLKZONE_PROG report $zloop | grep -cvE "\((em|nw)\)" >> $seqres.full
+
+_check_dev_fs $dev
+
+echo "Silence is golden"
+
+# success, all done
+_exit 0
diff --git a/tests/generic/815.out b/tests/generic/815.out
new file mode 100644
index 00000000..6ea462f3
--- /dev/null
+++ b/tests/generic/815.out
@@ -0,0 +1,2 @@
+QA output created by 815
+Silence is golden
diff --git a/common/dmflakey b/common/dmflakey
index 6ac666f5..9bba8958 100644
--- a/common/dmflakey
+++ b/common/dmflakey
@@ -12,6 +12,47 @@ export FLAKEY_NAME="flakey-test.$seq"
 export FLAKEY_RTNAME="flakey-rttest.$seq"
 export FLAKEY_LOGNAME="flakey-logtest.$seq"
 
+_flakey_table()
+{
+	local size=`blockdev --getsz $1`
+
+	case "$2" in
+	"$FLAKEY_DROP_WRITES")
+		echo "0 $size flakey $1 0 0 180 1 drop_writes"
+		;;
+	"$FLAKEY_ERROR_WRITES")
+		echo "0 $size flakey $1 0 0 180 1 error_writes"
+		;;
+	*)
+		echo "0 $size flakey $1 0 180 0"
+		;;
+	esac
+}
+
+_init_flakey_dev()
+{
+	_dmsetup_create $1 --table "`_flakey_table $2`" || \
+		_fatal "failed to create flakey device $1"
+}
+
+_load_flakey_dev()
+{
+	local suspend_opt="--nolockfs"
+
+	[ $# -gt 3 ] && [ $4 -eq 1 ] && suspend_opt=""
+
+	$DMSETUP_PROG suspend $suspend_opt $1 || _fatal "failed to suspend $1"
+	_flakey_table $2 $3 | $DMSETUP_PROG load $1 || \
+		_fatal "failed to load table into $1"
+	$DMSETUP_PROG resume $1 || _fatal "failed to resume $1"
+}
+
+_cleanup_flakey_dev()
+{
+	$DMSETUP_PROG resume $1 &> /dev/null
+	_dmsetup_remove $1
+}
+
 _init_flakey()
 {
 	# Scratch device
@@ -24,12 +65,10 @@ _init_flakey()
 		# Already set up; recreate tables
 		local backing_dev="$NON_FLAKEY_DEV"
 	fi
-	local BLK_DEV_SIZE=`blockdev --getsz $backing_dev`
-	FLAKEY_TABLE="0 $BLK_DEV_SIZE flakey $backing_dev 0 180 0"
-	FLAKEY_TABLE_DROP="0 $BLK_DEV_SIZE flakey $backing_dev 0 0 180 1 drop_writes"
-	FLAKEY_TABLE_ERROR="0 $BLK_DEV_SIZE flakey $backing_dev 0 0 180 1 error_writes"
-	_dmsetup_create $FLAKEY_NAME --table "$FLAKEY_TABLE" || \
-		_fatal "failed to create flakey device"
+	FLAKEY_TABLE=`_flakey_table $backing_dev`
+	FLAKEY_TABLE_DROP=`_flakey_table $backing_dev $FLAKEY_DROP_WRITES`
+	FLAKEY_TABLE_ERROR=`_flakey_table $backing_dev $FLAKEY_ERROR_WRITES`
+	_init_flakey_dev $FLAKEY_NAME $backing_dev
 
 	# Realtime device
 	if [ -n "$SCRATCH_RTDEV" ]; then
@@ -42,12 +81,10 @@ _init_flakey()
 			# Already set up; recreate tables
 			local backing_dev="$NON_FLAKEY_RTDEV"
 		fi
-		local BLK_DEV_SIZE=`blockdev --getsz $backing_dev`
-		FLAKEY_RTTABLE="0 $BLK_DEV_SIZE flakey $backing_dev 0 180 0"
-		FLAKEY_RTTABLE_DROP="0 $BLK_DEV_SIZE flakey $backing_dev 0 0 180 1 drop_writes"
-		FLAKEY_RTTABLE_ERROR="0 $BLK_DEV_SIZE flakey $backing_dev 0 0 180 1 error_writes"
-		_dmsetup_create $FLAKEY_RTNAME --table "$FLAKEY_RTTABLE" || \
-			_fatal "failed to create flakey rt device"
+		FLAKEY_RTTABLE=`_flakey_table $backing_dev`
+		FLAKEY_RTTABLE_DROP=`_flakey_table $backing_dev $FLAKEY_DROP_WRITES`
+		FLAKEY_RTTABLE_ERROR=`_flakey_table $backing_dev $FLAKEY_ERROR_WRITES`
+		_init_flakey_dev $FLAKEY_RTNAME $backing_dev
 	fi
 
 	# External log device
@@ -61,12 +98,10 @@ _init_flakey()
 			# Already set up; recreate tables
 			local backing_dev="$NON_FLAKEY_LOGDEV"
 		fi
-		local BLK_DEV_SIZE=`blockdev --getsz $backing_dev`
-		FLAKEY_LOGTABLE="0 $BLK_DEV_SIZE flakey $backing_dev 0 180 0"
-		FLAKEY_LOGTABLE_DROP="0 $BLK_DEV_SIZE flakey $backing_dev 0 0 180 1 drop_writes"
-		FLAKEY_LOGTABLE_ERROR="0 $BLK_DEV_SIZE flakey $backing_dev 0 0 180 1 error_writes"
-		_dmsetup_create $FLAKEY_LOGNAME --table "$FLAKEY_LOGTABLE" || \
-			_fatal "failed to create flakey log device"
+		FLAKEY_LOGTABLE=`_flakey_table $backing_dev`
+		FLAKEY_LOGTABLE_DROP=`_flakey_table $backing_dev $FLAKEY_DROP_WRITES`
+		FLAKEY_LOGTABLE_ERROR=`_flakey_table $backing_dev $FLAKEY_ERROR_WRITES`
+		_init_flakey_dev $FLAKEY_LOGNAME $backing_dev
 	fi
 }
 
@@ -80,9 +115,9 @@ _cleanup_flakey()
 
 	_unmount $SCRATCH_MNT > /dev/null 2>&1
 
-	test -n "$NON_FLAKEY_DEV" && _dmsetup_remove $FLAKEY_NAME
-	test -n "$NON_FLAKEY_LOGDEV" && _dmsetup_remove $FLAKEY_LOGNAME
-	test -n "$NON_FLAKEY_RTDEV" && _dmsetup_remove $FLAKEY_RTNAME
+	test -n "$NON_FLAKEY_DEV" && _cleanup_flakey_dev $FLAKEY_NAME
+	test -n "$NON_FLAKEY_LOGDEV" && _cleanup_flakey_dev $FLAKEY_LOGNAME
+	test -n "$NON_FLAKEY_RTDEV" && _cleanup_flakey_dev $FLAKEY_RTNAME
 
 	SCRATCH_DEV="$NON_FLAKEY_DEV"
 	unset NON_FLAKEY_DEV
