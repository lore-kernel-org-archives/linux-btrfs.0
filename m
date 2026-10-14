Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48133BBFCD
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979460; cv=fail; b=CMhwht7CtGOATw43gIYb9zVYQZ/rgaQG0XZavd3nxzEx7jQvjrNBphs7C1Z+E7hdiYVSe++RtvIgQJokHuO2pjkYBt7Bj4HNqXO4nD/kgFDDncVU9EIjNOLpTdCeYerwxpkXXZfPAd60JR50pnbMOaIo49rzJkfQ/XKoc1J7VHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979460; c=relaxed/simple;
	bh=ZXUa7A7Lk3/nEa0B6RBvoyRWu3lm5HZoc5sgLCCZkyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HEUrqMcY42nqyJZyC6BV3a7PDe34DdC+P4emMZ8h1t/Xw/LbkTAbXYlsp+ZvzXW1PqTBAv+dsFjZ0EujB8twAhhR5vzRxspPyyrrqjqBkPHAXi/n2ab0yIXjOSlFkI29Y/DAMDaYDgiFu+F2iKdkrXIyfmJCrmM8XpbXGQmBuEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kWXT/KB6; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=EATnNPYI; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kWXT/KB6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EATnNPYI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979459; x=1823515459;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ZXUa7A7Lk3/nEa0B6RBvoyRWu3lm5HZoc5sgLCCZkyU=;
  b=kWXT/KB6bcIRq8DXML6i0LlI1L/+hNgDgTMduuAq5kYhqrqRAUU3jXcB
   zbQyXfbSnjBCg9Hbyp9lij5RcVn9+pfhjO+PjHq2gt2kJzLqch6sPAejU
   hWyUjV/o+V8hQUPBwX+zyuyrEAiFp4PfEfmehV6E/ruffKrHNtamaDcRC
   Wd9fJ6LOHhuS600zQch6bAHuYhqZVuPj18qqSSVOO8VTGCPJLHcarYOyS
   BUgXFaqV2BrGt7ZgZYD7Baded1OjmnZJVvLMWCv+HnxAtxEGh59qrEypP
   usSNxjurkGSk7LLH4EeWH40SUY1YQgzMgFi4DAs/9b+KbP7qfEBDd0E4s
   w==;
X-CSE-ConnectionGUID: UPPglKPdQw2ZGvtIk6Y0XA==
X-CSE-MsgGUID: tX9syfZCRJaisL4/ixvPvQ==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077257"
Received: from mail-northcentralusazon11012034.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.34])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UAPotARXYewxWj6NgV4xyxo39kwpXa3ax7yGOXcINKGPO0hE5MV9mW8Q3mvAWVBVqvSYgLMztm6muo0+hvH6JF1j6IKN2fpDwlAmu9j920nqUoRl9V3/ussRJgLjXfkiVAvgMDMd9LVz1/2FrhqMOCVbbUzYrcZ58aLOkY3FpaUjk8GngcXf/C8+M08CvYnyAMh84pJx0STndc12pLJDF6JEsm5PRWr17rp8LyRMMXRQgZFTDcjgHiS/QnT0LfWOVLrNzvNZu/bwlRP3cWEYJxGMSrNgWW0WvzfaCii0k0irQZzdvPz3WzeIEdv+TsP9ZDM3cQgPKOAYv4KneSC6Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DawwfEaLHLIoLFNTZn9eVGiRzD7fA3l1U8Zs+s3l5dI=;
 b=erG2XXoCbW0dOwyhLQENQxadxIfz/zl/TYK9kGnDhpXhSXCfqlA4onmMH9570XggDK5gMmU4bqbLeK5hPRgIK29LFjUq5Q8cCDmZGxplPvDmYrbcs/X41RcYMEhcAGh7NlM7yX6FZkzu2dDdvxiB+eyAcSkTBy65njJasrEFJFPlvkLNnGT0RTLjsbg9Wbm9gQ1Tw8n0/22VmzVB8vO5lrFpuQ1UIvET2uqYi3hIv5vhXNNvG4m4liqsXDsJxkLpDDAoEK26y9t9OORMIhOJrkZdI4hJghhTXrIuPDrTVnAlGv3YNhFxo7j2mMU6LXZiFBG1GtZnUndbEJO3ApMW7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DawwfEaLHLIoLFNTZn9eVGiRzD7fA3l1U8Zs+s3l5dI=;
 b=EATnNPYIc6rZCP3xvB0kGRobtiEH5X36ikNmFy9WJaTM/wI+mf97VwTGduX+jbIjTGFKkl7/fHSi5sYx2XK3ovgr9KyoqLb+Bn+NoJpOVGbXgDCZk/sk+ZufWFHHKHAAwsTKXQtHSkyWu/1C9sJGRfcE8klBozDDDSnLNEWcw6c=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:16 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:16 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 05/13] btrfs: zoned: factor out resetting a block group in place
Date: Wed, 14 Oct 2026 14:03:44 +0200
Message-ID: <20261014120353.757931-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
References: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12)
 To SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a44a937-c495-4f35-7f66-08df29eb452d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	0xf9rpvG10VObBeyFgh2p/qAp4Jp0yIbrXeVvX49aR7KFt7bCBcMAYwD7YK7ksIA1vzfrnKSS96av6MgPsQ7JRmEJ6EGirBD60fknbinuHidgGJc2VoPZ/f+8ikRSrEIrj8mJwNevTb+23/P1rlDnkSUdtS4HjqVdJHlttuaffgYNaqhGA4UvfCcg9tSml7lLLVA9OMh/dDvHPChSkOr3bN85hB/8x76YKBP/3EwlNueH6IhLUrQZpBUaC/0n9kuEg2vzPshqkZ22/wN4+PPjxxPxhkVImZ7E5GAvJZ8XuKA4+SJ/+E5oKBQMSjEOR2RsWTcxB6rgoHmj1Ug98O92RHJ8+EYazVOwuKUagG78YtKrvHgtvJN8xarCiVAfv1gimN2c/I1tkYcRRj6BW90O28np9iPUZp5PQM8czQDaz6xSF5O7J/HRniLE/HWzUWPDE8iwOX7Ofgjk+xjHtTMngq1P5d80nTZCsO9bbzR6obJrjNTIZ6OoPtdbOixM1jrA70+siFGGs97xrxe/XLBzk7J41YLJZgRhLTlHc3l+j7Q0G6/c9DlR0q8o1PuOwuO6mfNipDxdoUDFbM4/Ja1Dz1uye7KtrCdmQPP2q+mnkGWRnk4dWbSMNoV30R33qVLs9HEqD5sp+jkaltXdszT02gR/57/uVSNQsB/Buv9vWM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sJ5FdEMaLYoIRujsTWMcV8mPsN0jUJQJmlAdZpiBVyey1eeM0QqGWIkPUbde?=
 =?us-ascii?Q?w8tc41d8fR3DW6ZwuV7Cb4VJQHsB/RKnIgDGm+SHn2ySJZOzSKKyyMaz4Jgm?=
 =?us-ascii?Q?1x8sKfKLnzEvSj0u9nTqnjUf98C5nYJWWo3W4C7/PZuhSMfuZBfGbWzucQll?=
 =?us-ascii?Q?yDOMuudT1SQRrlEVGVtwWcArbSaR44S9KTq78ssKWjs0ba9TDY0+M3zZAJVS?=
 =?us-ascii?Q?QTstxdILvqq8IQ79mbMAM01/otsm69NEUF4d30I6MguOhhM4WX8IDah95qt8?=
 =?us-ascii?Q?+QM6V4IlLNHwcczTlucoJNDucm3JrTPDLRMkfj2kcXuODwGSlLaXRURckpQU?=
 =?us-ascii?Q?XtLRRNdmNN+J1cH9miUDNE2rZjTm20ECLCVYWV7qSdcY87McsIPrxD9mCrDJ?=
 =?us-ascii?Q?uo1rrrxLQ0m9O/9VQWNMvfnDW9igkhG3ZK45ZlEA0rNaayA09j4rldyX+5it?=
 =?us-ascii?Q?wOGsBv/re4Cik4KB3qG43tr2N3BmdZ/dGWFQNDwVCfKILXMe8Fwj9WPVHeS5?=
 =?us-ascii?Q?T4vQK4wR2K8vfonAiq+uc4nvqq2vtiW0SRfFcgzijpLtu30dJJjgz4qsfrl7?=
 =?us-ascii?Q?Q2RoM4jCqeptFYqq3GTqIXQ9b7dm5o9zlfov7ywWNpY7g0+zCQbSNe6Wt+V9?=
 =?us-ascii?Q?litAo5lQlO2juOf/ApSiYUOw4wjQyPOdL071dF4PQLQ7IfL75dnO3umWD6S1?=
 =?us-ascii?Q?wkbCPlHIY01/r7Dy7AkREG6Di+g+ZdBa5cknMPSJbDEh9W5itVdMqVFsDpSg?=
 =?us-ascii?Q?f/kpDau//VSAbmuTPcLX8aJvjuSGjBkvA5sIwj3B8ok1KP9MaLruEJtNl7eA?=
 =?us-ascii?Q?9Yks/1bdC7sAZ7F2lFakg78ic5G4DFhQAuu+CYfh7cmgwb0UNYsCZqtFA5+s?=
 =?us-ascii?Q?yokjHJMCZhZuEA29bV8FSGEApGkyv/RmfZOdP3Nq1F+aUnLd9AAifdMbWRYS?=
 =?us-ascii?Q?d7tZ4Zpbkv7yrZjilzBZ1s06Vqriqv/e2VC75QDZKygAYmQn84ZgPFoUvh38?=
 =?us-ascii?Q?EIuV8qzDEtZM9ipjszKbwkeq9+hQH9lkzqjlH+Na4kAIXADwUluh+OL0oDIf?=
 =?us-ascii?Q?EKvLWJjh6hrj9Pn7yYQVmCc/2oCtM6QD1zPRVEgRCOxo6gIlSTyP/TtQ/y0x?=
 =?us-ascii?Q?0J4Vskh3ROJ8bFwe7tuNVuDpD8m3IYYOaU5x8QC6P0PKY7qk94dEdxMCySM7?=
 =?us-ascii?Q?3OqOmCBi99ckJeVDW8/POJHw4dS61cIa4dOEiTYUS1n/M3zFWPksRaY1Sags?=
 =?us-ascii?Q?W97ITpBgCAFEBBD/FqTdlBg+CHfFuqy9YBkKw6czZ0aEebkEA9Kw/Henhk1s?=
 =?us-ascii?Q?2YSK6H5/ZbghSZwV5rtrBiqrgckLz/CqMhHAlLGiZ3wjZEpK7eFa7sTBJyF4?=
 =?us-ascii?Q?oeiLwqUsCvRX5zfN7lbdBKRgvxWValC67bPtL+1dOEd9OO45jmg92c/fsHPr?=
 =?us-ascii?Q?4io9dfCCjJKnmyVoz03Y1XGXhtPLxZ1UBm0QjAa4I0/ZEPTJobUD7VVIdO6t?=
 =?us-ascii?Q?NbyJBSxqUPsXlCqToL3aIbTPECWiUKXPSAvKdKrEQxI1YOQTxPW8ywWO4/GC?=
 =?us-ascii?Q?S4nmOEPnoMUcH+8rShaY9MudtZzIO9ZB2ZeMstORMA7PsqLpNLHBpj+NJd6u?=
 =?us-ascii?Q?V5Jx1Q6FWSOYTlG4Zp8yFfnvC/6UATo+BnGQpcc1eBFv4flPz26900Un1TC3?=
 =?us-ascii?Q?C1U15TUijkPft5HFfHRX7dbfgRJ7BlmBMExlOGsEIIT7cIB5rfv27jLMK8e4?=
 =?us-ascii?Q?5WT5z8MDHAI1kNegkqvLrtfJZNdDBBkRI5dxVhYcyX0TNgqVMzNa3Dxdo8tX?=
X-MS-Exchange-AntiSpam-MessageData-1: GSnofiv5AQx6WXbxVrN7PEOEQIdNBHjmiv8=
X-Exchange-RoutingPolicyChecked:
	A1VJFpZMajXdZvFpaICkVpLQVLI4jpS83L36TBNyg2Edj7wC9AmafQoSbiuT4T24urHA26FFafYgPbK0OKIb+XrEtCKYFPrPcwbYFgNktU9Y5Nf3Byz0wNg2Avc3nOd6N3pSr2RehboV0jZuq+CDOt0BdWMVr3jLr+bSoCYiHAuVJCVS5tCgPFteX7MRQpRhb2ua5vyv9oy0D+wqq0Uu16JVJH/dIzCF9cBkHPgbD7hGNNJYre5o2LLg3iQHcf298kmJiTQQkdRQ8drON/PHa6gHx4qRB5/tYw57PtmsbDgrclKjCOK+hS+TpBdiheXDcjVZuCWrputFocJLdUrN7Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YNBf0HitMNsnc1LhmMSC1LkOsO1jvk9K1hDIM1wOcwW0g2d6PPkC9dnkP6bGWaURxahzbaNkdI5XNBnDPjEGbUB57+5HR00wt5s7ZtHvCkFSY6kLsp+4M+20o7SEzHLetgWIolR7p0jsoGUKJ+nr2GUTvZEwnL4IfaNYRBB7lGYpUgO5QlUk1+KSCOFU0hC8vYdIls0moCo7VncHWgcltd9zjzn2vGJR2tgA0kqoWJGFBUPInhcqaDS/ItrnJ9cYzziwzX2qDxh+gsmoon81GylMCqSFk7AYRYBxSgloS1TpqQRwAZxUgOz5ijBiIZ88HC0GqVhTFGwwY3KdCrQkG6Z+JjTl7xuOo+W0va3WqFJGs7dzBzowm2WGDr0ckjV3zag80hPgesus8ra65v5Q2UNgad8+197jFnqTcbTB4TL29rBJDHDK4fsR5sor0WdmPg6koNt8d82qGP7PrxW5fq74UHIwR6e+gEtlykyow3AKlAwiVP4mYzpFnSbDPP8bKz/7AYIjHqSZvdgASyl9XMt8qI37oBA4Rjiv66B4oSwl81g5sBdYHg29LxUB1lF+sKvnRP7to+eMPiu4ASdgW8M3mKWC3M8YoGDye1b7am//dbOumjTDf8ovqP2i7BN4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a44a937-c495-4f35-7f66-08df29eb452d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:16.5529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Ufw8beUJJt/Qu48vCy4R1jvHDKumCHDUF7JjG7pLw5h3+haQzG6o+PMD+grWyJ3bEZG4Da/5+keAnveJtU+DhmemcsWsQRhoG80GobbDAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

Move the code that resets the zones of an unused block group and returns
its space to the space_info out of btrfs_reset_unused_block_groups() into
a helper, so it can be reused.

No functional change.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 132 +++++++++++++++++++++++++----------------------
 1 file changed, 71 insertions(+), 61 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index d0140893d4da..5a431dc929b0 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2906,6 +2906,72 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_space_info *space_info = bg->space_info;
+	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
+	struct btrfs_chunk_map *map;
+
+	*reclaimed = 0;
+
+	down_read(&fs_info->dev_replace.rwsem);
+	map = bg->physical_map;
+	for (int i = 0; i < map->num_stripes; i++) {
+		struct btrfs_io_stripe *stripe = &map->stripes[i];
+		unsigned int nofs_flags;
+		int ret;
+
+		nofs_flags = memalloc_nofs_save();
+		ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
+				       stripe->physical >> SECTOR_SHIFT,
+				       zone_size_sectors);
+		memalloc_nofs_restore(nofs_flags);
+
+		if (ret) {
+			up_read(&fs_info->dev_replace.rwsem);
+			return ret;
+		}
+	}
+	up_read(&fs_info->dev_replace.rwsem);
+
+	spin_lock(&space_info->lock);
+	spin_lock(&bg->lock);
+	ASSERT(!btrfs_is_block_group_used(bg));
+	if (bg->ro) {
+		spin_unlock(&bg->lock);
+		spin_unlock(&space_info->lock);
+		return 0;
+	}
+	*reclaimed = bg->alloc_offset;
+	bg->zone_unusable = bg->length - bg->zone_capacity;
+	bg->alloc_offset = 0;
+	/*
+	 * The zone was just reset to empty, so alloc_offset went back to
+	 * the start of the zone. For metadata/system block groups the
+	 * write pointer must follow it back to the start of the zone;
+	 * otherwise it stays stale at the previous (finished) zone end,
+	 * and metadata written into the reused zone would sit behind the
+	 * write pointer, could never be written out in sequential order,
+	 * and would be stranded (pinning its folio) until unmount.
+	 */
+	if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
+		bg->meta_write_pointer = bg->start;
+	/*
+	 * This holds because we currently reset fully used then freed
+	 * block group.
+	 */
+	ASSERT(*reclaimed == bg->zone_capacity,
+	       "reclaimed=%llu bg->zone_capacity=%llu", *reclaimed, bg->zone_capacity);
+	bg->free_space_ctl->free_space += *reclaimed;
+	space_info->bytes_zone_unusable -= *reclaimed;
+	spin_unlock(&bg->lock);
+	btrfs_return_free_space(space_info, *reclaimed);
+	spin_unlock(&space_info->lock);
+
+	return 0;
+}
+
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
@@ -3241,16 +3307,15 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
-	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
 
 	if (!btrfs_is_zoned(fs_info))
 		return 0;
 
 	while (num_bytes > 0) {
-		struct btrfs_chunk_map *map;
 		struct btrfs_block_group *bg = NULL;
 		bool found = false;
 		u64 reclaimed = 0;
+		int ret;
 
 		/*
 		 * Here, we choose a fully zone_unusable block group. It's
@@ -3290,66 +3355,11 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		btrfs_put_block_group(bg);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		/*
-		 * Since the block group is fully zone_unusable and we cannot
-		 * allocate from this block group anymore, we don't need to set
-		 * this block group read-only.
-		 */
-
-		down_read(&fs_info->dev_replace.rwsem);
-		map = bg->physical_map;
-		for (int i = 0; i < map->num_stripes; i++) {
-			struct btrfs_io_stripe *stripe = &map->stripes[i];
-			unsigned int nofs_flags;
-			int ret;
-
-			nofs_flags = memalloc_nofs_save();
-			ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
-					       stripe->physical >> SECTOR_SHIFT,
-					       zone_size_sectors);
-			memalloc_nofs_restore(nofs_flags);
-
-			if (ret) {
-				up_read(&fs_info->dev_replace.rwsem);
-				return ret;
-			}
-		}
-		up_read(&fs_info->dev_replace.rwsem);
-
-		spin_lock(&space_info->lock);
-		spin_lock(&bg->lock);
-		ASSERT(!btrfs_is_block_group_used(bg));
-		if (bg->ro) {
-			spin_unlock(&bg->lock);
-			spin_unlock(&space_info->lock);
+		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		if (ret)
+			return ret;
+		if (!reclaimed)
 			continue;
-		}
-
-		reclaimed = bg->alloc_offset;
-		bg->zone_unusable = bg->length - bg->zone_capacity;
-		bg->alloc_offset = 0;
-		/*
-		 * The zone was just reset to empty, so alloc_offset went back to
-		 * the start of the zone. For metadata/system block groups the
-		 * write pointer must follow it back to the start of the zone;
-		 * otherwise it stays stale at the previous (finished) zone end,
-		 * and metadata written into the reused zone would sit behind the
-		 * write pointer, could never be written out in sequential order,
-		 * and would be stranded (pinning its folio) until unmount.
-		 */
-		if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
-			bg->meta_write_pointer = bg->start;
-		/*
-		 * This holds because we currently reset fully used then freed
-		 * block group.
-		 */
-		ASSERT(reclaimed == bg->zone_capacity,
-		       "reclaimed=%llu bg->zone_capacity=%llu", reclaimed, bg->zone_capacity);
-		bg->free_space_ctl->free_space += reclaimed;
-		space_info->bytes_zone_unusable -= reclaimed;
-		spin_unlock(&bg->lock);
-		btrfs_return_free_space(space_info, reclaimed);
-		spin_unlock(&space_info->lock);
 
 		if (num_bytes <= reclaimed)
 			break;
-- 
2.55.0

