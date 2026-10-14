Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9166C2D5408
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979466; cv=fail; b=QYiocQ0qjSeoN+p3ccPtuSc4yPfVqkWqPzj5t5eGixgenqZwUV19ZEWr5mRTp10jBNGlVVmOWj+/ZdH3AzqZdGXriqAPsQgmr3AgNv5uCLbX1jVIwZCOeVqc7FPZzJle4/m8U3+T0h+O89GE1C0DucPDM2oxnRMPZxpPfaqOyJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979466; c=relaxed/simple;
	bh=ZsU/V75nkB3rKJzeP6ClbfnPHAFzavH4SmBoDNn9i/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P6lPWxrzclDL0PdLaQkndsJwcBQD3BMsc2QcVCKCEoEEBkPW0QiT+otGMLmeUmFvOhE3KAHVSUeLOZwvJ4ide8fAJO55Uo52khgBOdBt9g6EZdLlR2FXCAuRuw0qP52kdCaEafm6vuDPfgBJodWBXNUfkgos1hVuXaUHtzLDC7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Bc1XiaVa; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ziXVdG+t; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Bc1XiaVa";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ziXVdG+t"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979464; x=1823515464;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ZsU/V75nkB3rKJzeP6ClbfnPHAFzavH4SmBoDNn9i/Q=;
  b=Bc1XiaVar/rQsxBW9HcJqZE2yv3bkBTimczJoHf7bcoZwoPInyjboBoT
   KSLzed5r9LoDkf9VCsHWZKlaXpyciwAwRUemtrB3g+g9XUX51TOoWjIg7
   NswHAL5YNyZSHpItT2qM6MTGXPny4Lx+QAHWCgJ1nOh6XFr8/r+04+PpV
   wPfN0N2UzX6CgRWf+ORkC1VxM1lwSMNJh4QveqaGLTCd+lyt7rjdJ5PIc
   ITLS/T+k5WrLLcab8zYyuvpBN1ce90dMkhjaaW7zaL0roHCQ4ed9oB8NI
   sF8H/VF0BoAw3geg6qP+vLyF05naDLkBZrhvhZpphoTbGPE4+g2T8412r
   g==;
X-CSE-ConnectionGUID: cspXqLafRR+p6bMSK2XDKg==
X-CSE-MsgGUID: uiijM8hATdikdavzte3qBQ==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077277"
Received: from mail-northcentralusazon11013003.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.3])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wk9Rcsd5uq60D7Qh4JBx9yO2wpVjEqCFqjECLAArpLXPJp9c7Iv7+DnZ7h6rCloq0+49H/oyf0G8yjBMiVyigucLnhsRF/79cCHGm/Wz7xAaULd/3pMY6FzCup4FzSVut2Aj7Kw/8tKC1LtbqPzVaaB1j06ogVzrtWRsQlwiOowPGO+3K9ShYnxj29x098el6pKhIFl5gMvD+TkFFLOdcsIdNSrvBxZDmXAVRQ/2cbFoGHVc93/rTZhoxlezHUjtla+7id9pRPOBr6Rcvf/SHFx/IhQckA6Gzjk3+2Y/XWiDDNdiYTtbXB4OejsF4QorQxip1xX3BFF16oI+epX4HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hoy/PSHuTx2FOSY03AUB4JGcTrxp8gKx4+XbBqLlwn8=;
 b=tt9En+6f6rrkd+HendSsgmJPgLPKrykrQauU9XxgmCxV6c/Mw2tGlMmMrgn3zK242tBCCgaG2UN+y7TzoHmZNjLKvE91yn2TiFfzVVbTXkn/t9ft1D2gl7PUOvyEvwN9uz0HRGqAZ44sbUxwCX2hTMIOBS0m0aOiv/6Jbc7eAuT7S/+CNdhjmckq+080B1nNyObBLCKRCiRQU8FFdPA9KAaeeV/4tfzZY2g01XEEbadjGjeBIOM+lvG+5svuDlwAOzCoSjhMwXF1WPsNz9p75zYed/Yyb7ke74/ETSdY2cTrADiqWeCHbnWtr+WskEqlr9AH4w5SaW0t/ydsuhC05g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hoy/PSHuTx2FOSY03AUB4JGcTrxp8gKx4+XbBqLlwn8=;
 b=ziXVdG+taVtK+VyzDhS/a1k3pqNjAZ3UCvJk0VP3gcgH9zH6whJ8mKMS1j1YbK/x/sewgeXolYa4UPiHcMCckPsFbawQCm3YRMzIYbzYjh/gd7U/HVShFs/geKVCog660LB79lQo7uCUHndkwDiAN6IhEAHF7FXwywn1SJSOpKM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:22 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 09/13] btrfs: zoned: reuse block groups emptied by reclaim as relocation target
Date: Wed, 14 Oct 2026 14:03:48 +0200
Message-ID: <20261014120353.757931-10-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 30074b02-9d10-4da8-c82c-08df29eb487e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|6133799003|18002099003|22082099003|10067099003|11063799006|261009223027099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	YEG7TDY82c2e/3XTUJycNsx5CLlXdfHd6MMGJC2GSiXBTKTb4QgLsQqCiUh/wIgheZwTaIyTT/1deGB2Ej4n4hbbqhBomuB1DvAos/Zi6Sceb3Xxc4KtnvwVMbELZuW+ja4xMJhcf7sXbmHBAWyoAD0RLWEL1NhS0lDq/BoSV+1f6EmszPqyK5vN2O/kSyJPtm7Xr503aDKfwfez7sDwUoTV8poA+vaFTpq278rDt4BEpoHH1NulQXUMXFGUtC+xJqJFHa2b/OTQkAi1+YFzi7CDesf7CTlONZtfEzlHD2x4tmF4fU4ZQ/8Q7GpOChVV6cipJOiqGKQ9iEzVuOiREUeSiITyA2KnIoTDC/WguZ3uQxuPhu4eTyNUSrpF347VAKXhb4Jv8KZDjYdI7vMqextkbTSqkuHGQRHtnSwXunLIctwQ35j2nhyKoyDN2tf32jrjmzpUDwJM7eN6K86c2LSVJp+8E/ec+IA0lrXIHTaV4rVThkNttDPWT71PPJkH2A6w+2BL95Pe8ipk7V4j26uR+aDDdnGf+5IJhIP+fZStbT/2GG/H1f2G04AulOlOb88YODLFHUn5DQHHEB3Vluc+JwUUceYXW5sO86E+yVZ9ROwMmLyHTuZM3R9g1hy0sEJyXShh1eXpYuSvQ6WcW2yOCF6MyJUZdxZ7jnf/YaI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(6133799003)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a3NX6FBwANDEwjkNWd/IaEWmK8czhJiIxg4s3VrnAfW6juo1JF7hXy5FSG1+?=
 =?us-ascii?Q?N3ltDD3NYiLhu9atRhAFUcAvDutPHNOhL3b+juEx/TQCkjRIZOVweaPtZI3R?=
 =?us-ascii?Q?G01CgXf/J4X+jLCtb8JoOvkKTREF+3YLo1+OPJEHE6KL09IAslhUxnGO14gR?=
 =?us-ascii?Q?nQnx1BKtPnAoa9PJ5sXdALfijM1kKl5AIfY4euNE42sFuxL8SXPBIJrlWunT?=
 =?us-ascii?Q?lZLmyEq3aEaFCVPaQ8xomA83fXSX+jRBo8CZ+wDzCeWbaDgBvDpvdsKch16j?=
 =?us-ascii?Q?9ukUgR8CssqAN20Z+9j+LAEqRRS/g6Jsnx1WIemwBuawMfqHkkyy9ZvuPghi?=
 =?us-ascii?Q?ygQGpQYNccj6LoqJJeIGiAfMrXCEXWE+yPlo9tYsy9KBVDOcxZxS7efYTyn0?=
 =?us-ascii?Q?6LE+dJYybIdhAryGHyV6WJI0iGF9OztSi9bXPqiT7M48OrABbpUiDJkPx0V1?=
 =?us-ascii?Q?+bEoeuIEGwlYMokuRnUxNmFbwYlFCDbaQjs4D9qLOrEyCi02jd9bqetEMd8m?=
 =?us-ascii?Q?5e5iLvSL04wQ25Ttmfp8JJTuOkzRDU008i07WoFO5DtV+RmWWbkbQM1/e3sc?=
 =?us-ascii?Q?rszvAWKB/hygfyeSkKorQ1EYOuVfx1aD9yjt5OGB44HFN9NZCGlQhJ/uj+GF?=
 =?us-ascii?Q?NW1C1ElCHeyT9ux8PpE+nEF2S7elhNZwUm1CU8xSJaTMEMcSAdxwJtherMa4?=
 =?us-ascii?Q?59SAAZVAAh3ZZzfn9sy+vIqNJ82bSCno6tUGX/+OknZrPctPu/23MFyFqt/Y?=
 =?us-ascii?Q?MQupN7gyI6k18mWWMITzZYp0erdV5zQnWoGKRoIqfmWAq0NxOjYTB9tnKZJz?=
 =?us-ascii?Q?5koU4WAz0ggArjmxfzjsfvWpJg1ISdqCHbc6260qeKET/uBM06gqaKhWndVQ?=
 =?us-ascii?Q?u2RXDuoFfvMf8L5Cmo46qa2x7Q/47flqut/pBQ20pjzg8XBWBYDVq5/BscPF?=
 =?us-ascii?Q?jJewpJdfG0A6zYc4oNtZfIjtcKpBt+PDnwkG3dIhEAAIXtaiygMC3bFTPOeH?=
 =?us-ascii?Q?uV6IerreZl2stk2uxTac88LEMiisS0L+PV7FfP+tUcHnLzkNwUhDSBQf11n5?=
 =?us-ascii?Q?DzY9damMehn8Z8Ex+G1g2Lp7x92PKvDjdQCyq5ib05plvNgVbW4dsCTB+QW/?=
 =?us-ascii?Q?aQUmaND9Wan0l/sowA1HxB08uqmqQeN3tF74timS2mxjRMVtVvYUyvHjhgIb?=
 =?us-ascii?Q?5LFBCIbPKIaP1dbxxXCNIw3D1WuhaC6w8rW3XaAAeAe8+qh1YezZCi5kRjxp?=
 =?us-ascii?Q?CFsqLOa8XdZXHMApVtP0Rye2ZnJ6fsrIUF/FVuuemLdpR7Lxz0RWrkyMewmg?=
 =?us-ascii?Q?BBpjvXKd7gYSmf5LbivStixJZ19ersLjo2A4lt5WMF4PfHRhv+k4kh2p+HCb?=
 =?us-ascii?Q?/Jb78cgCSYEvFZYE3Vz0xVEPyQaApfe7ZdiTh7ldiXPP8C/HRPyRA88cFx4W?=
 =?us-ascii?Q?NZCuBl+v/mi5jXDyDqA2N5pDfl5dCo0Wtr289FiISRB/xs59iZ9umKbRDODi?=
 =?us-ascii?Q?YAolN0brEVbDfjroaQjbYQ2s/UL/JxbLUP9kbfUO88gSw7Hze+IdaBtyFbRI?=
 =?us-ascii?Q?nYWBvHjAkOyb1sQfpWDlUBG+PiI4SBliZD1nBh7DBHmgTStc8EOWaEfYxjei?=
 =?us-ascii?Q?hM9aFebRPwemoQupb1vxaUFa+Fjd6oNBFMFxHEBkynCCM4ICKKQS4Zt8O6T3?=
 =?us-ascii?Q?T/tm7ilGAQlrNPii1cHgXEeHVyangekeuvDzfJcAVYGB3MBIopVG1c61tc4u?=
 =?us-ascii?Q?Hy/5QzRRq7kulxoeP7NN9MwyHCZavlWZt1oa8xGM2qx7osLZjAv671ijWwZV?=
X-MS-Exchange-AntiSpam-MessageData-1: Ftfrcpc78n2F/jwv77y4BZtOzyV0THi9FvU=
X-Exchange-RoutingPolicyChecked:
	Sj9vhwP2T6tPNSyOOFSu20LdEFRO8l7pZA+lmFglC1p+B3CRmF43SEEuYIXOVNO/aX6M2tHuUsThXHTTpm3z2d+knU+mmZcKbHuS9D6CWhUe5AkZubFVuYn2A5LAsgoC1/IcRyAesLdbmUvSzKqgO35xmREOj+fIwd5qrC4LvMHUXSi16clGLK4Ifu/dL1Oao1XzxkKTu7qPbV9eb7+linmcqZRbviuzN+J77SIyDhB4Cc0Fl2/cFb4F8Y+GL0z5NxaoAmIz6lwGcl24b3QbtHEJS9njNqizrWNgq/y+eJ5SnJliCJJ74OjfmU1fLhcmaXd6/iYnETqNUruJCPTiXw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IjxNzaG4rdoIa3WXFF2k83d4GTJMTY9rvVQLGhHbhOvNw+K24DJHVd/N/34P3IWRrLNO0D52Ud/Fg3YEhTvL3bM0CxAPR7MhCWsBZiIt+hKxfJNOfeMyDlr4lUZ4gXnJBUFsMtPZaQ9SwzFjoDtT9fror1U3zIVkQpoQBCajkQ8GV3G4lf1YPq1GicUdIoTXZX9deyL4kwJLF5V9+jdEjS8w0AgLRY89fP/y7HiVqWl5RBq21t2yayGQ67lw1jFzvQnH+TxHzD050Ractp/5G31S+0okBHX+uuOt49eizs9ir2tAJB7S5j1DCuKo7V8kjmXiuMWgD+k98HakU3trbqB/zhtgY+071Yb3gOVTsWldJa1GXXI7/wyjCm9ngD/D5TBxdRFUoiHBBeGZgEA+Umb5n8ozydWukdPLiN15RkSrJPeQu4VSO37A4jIqU90prPKgToNiXSn1gHjwMUn4MGtTnvQqkb6tsrEktT/zXqFgjhxJpGS999ig1LDw6pL4bs/DPVREPAmJciWJewdHJPxYRfTYLQRIoj0sqPpK4Pank9xKX/IGAvxCT8ERGnH6OKISqkpWWMKYBEgyULc8BzdpXoplQqehmGQVwPiyO7u2LLtZfqSBWDuXjltUIA1y
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30074b02-9d10-4da8-c82c-08df29eb487e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:22.1272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3Z+V4pttKros/Zp1SxVq/XRdKAa3GTLC2bpmx4G/qL4FNy3EM1og+zlITGCUoHWUJJ4+wcLf759y2Mzde6KLBNsa/2Xa6RMF9ES1q8Vd00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

When the block group reclaim relocates a data block group, the emptied
block group is removed and its zones are reset. The next relocation then
needs a new data relocation block group, and if none can be allocated the
relocation run has to be aborted.

After a successful relocation there is a free data block group anyway.
Instead of removing it, reset its zones in place and use it as the new
data relocation block group, so the reclaim always has a zone to relocate
into.

Mark block groups that are relocated by the reclaim with
BLOCK_GROUP_FLAG_ZONED_RECLAIM, so only those are reused.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  4 +++
 fs/btrfs/block-group.h |  1 +
 fs/btrfs/volumes.c     | 22 +++++++++----
 fs/btrfs/zoned.c       | 73 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  6 ++++
 5 files changed, 99 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 65bfaff1420a..ede22d2eeaf7 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2091,7 +2091,11 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	spin_unlock(&bg->lock);
 
 	trace_btrfs_reclaim_block_group(bg);
+	if (btrfs_is_zoned(fs_info))
+		set_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags);
 	ret = btrfs_relocate_chunk(fs_info, bg->start, false);
+	if (btrfs_is_zoned(fs_info))
+		clear_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags);
 	if (btrfs_is_zoned(fs_info) && ret == -EAGAIN) {
 		btrfs_dec_block_group_ro(bg);
 		btrfs_debug(fs_info, "deferring reclaim of chunk %llu", bg->start);
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index b349f94cf929..48c584e29d29 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -95,6 +95,7 @@ enum btrfs_block_group_flags {
 	BLOCK_GROUP_FLAG_NEW,
 	BLOCK_GROUP_FLAG_FULLY_REMAPPED,
 	BLOCK_GROUP_FLAG_STRIPE_REMOVAL_PENDING,
+	BLOCK_GROUP_FLAG_ZONED_RECLAIM,
 };
 
 enum btrfs_caching_type {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2a0b5f8832a5..318f803addb0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3711,27 +3711,35 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
-	u64 length;
+	const u64 start = bg->start;
+	const u64 length = bg->length;
 	int ret;
 
 	btrfs_discard_cancel_work(&fs_info->discard_ctl, bg);
-	length = bg->length;
-	btrfs_put_block_group(bg);
 
 	/*
 	 * On a zoned file system, discard the whole block group, this will
 	 * trigger a REQ_OP_ZONE_RESET operation on the device zone. If
 	 * resetting the zone fails, don't treat it as a fatal problem from the
 	 * filesystem's point of view.
+	 *
+	 * A block group emptied by GC is reset in place and becomes the next
+	 * data relocation target instead of being removed, so GC always has a
+	 * zone to relocate into.
 	 */
 	if (btrfs_is_zoned(fs_info)) {
-		ret = btrfs_discard_extent(fs_info, bg->start, length, NULL, true);
+		if (btrfs_zoned_reuse_reclaimed_bg(bg)) {
+			btrfs_put_block_group(bg);
+			return 0;
+		}
+		ret = btrfs_discard_extent(fs_info, start, length, NULL, true);
 		if (ret)
 			btrfs_info(fs_info, "failed to reset zone %llu after relocation",
-				   bg->start);
+				   start);
 	}
+	btrfs_put_block_group(bg);
 
-	trans = btrfs_start_trans_remove_block_group(root->fs_info, bg->start);
+	trans = btrfs_start_trans_remove_block_group(root->fs_info, start);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		btrfs_handle_fs_error(root->fs_info, ret, NULL);
@@ -3739,7 +3747,7 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Step two, delete the device extents and the chunk tree entries. */
-	ret = btrfs_remove_chunk(trans, bg->start);
+	ret = btrfs_remove_chunk(trans, start);
 	btrfs_end_transaction(trans);
 
 	return ret;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ea4915db5349..181e96f9f0e9 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3059,6 +3059,79 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
 	return 0;
 }
 
+static bool btrfs_zoned_can_reuse_bg(struct btrfs_block_group *bg)
+{
+	if (!btrfs_zoned_bg_is_append_only(bg))
+		return false;
+	/*
+	 * Only the read-only references taken by btrfs_reclaim_block_group()
+	 * and btrfs_relocate_block_group(), nobody else (scrub, balance).
+	 */
+	if (bg->ro != 2)
+		return false;
+	if (bg->used)
+		return false;
+	if (bg->pinned)
+		return false;
+	if (bg->reserved)
+		return false;
+	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags))
+		return false;
+	/* Once read-write again, nothing must be allocatable before the reset. */
+	if (!btrfs_zoned_bg_is_full(bg))
+		return false;
+	return true;
+}
+
+bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_space_info *space_info = bg->space_info;
+	u64 reclaimed;
+	bool reuse;
+	int ret;
+
+	if (!test_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags))
+		return false;
+
+	if (space_info != fs_info->data_sinfo)
+		return false;
+
+	if ((bg->flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) !=
+		(btrfs_data_alloc_profile(fs_info) & BTRFS_BLOCK_GROUP_PROFILE_MASK))
+		return false;
+
+	spin_lock(&space_info->lock);
+	spin_lock(&bg->lock);
+	reuse = btrfs_zoned_can_reuse_bg(bg);
+	spin_unlock(&bg->lock);
+	spin_unlock(&space_info->lock);
+	if (!reuse)
+		return false;
+
+	spin_lock(&fs_info->unused_bgs_lock);
+	if (!list_empty(&bg->bg_list)) {
+		list_del_init(&bg->bg_list);
+		btrfs_put_block_group(bg);
+	}
+	spin_unlock(&fs_info->unused_bgs_lock);
+
+	/*
+	 * Drop the read-only references taken by reclaim and relocation. The
+	 * block-group is full and empty, so this leaves it entirely
+	 * zone_unusable, just like the block groups that
+	 * btrfs_reset_unused_block_groups() resets in place.
+	 */
+	btrfs_dec_block_group_ro(bg);
+	btrfs_dec_block_group_ro(bg);
+
+	ret = zoned_reset_bg_in_place(bg, !fs_info->data_reloc_bg, &reclaimed);
+	if (ret || !reclaimed)
+		btrfs_mark_bg_unused(bg);
+
+	return true;
+}
+
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index f792a0516d62..fb87f0ad32e4 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -106,6 +106,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
 void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
+bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -294,6 +295,11 @@ static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_in
 
 static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
 
+static inline bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg)
+{
+	return false;
+}
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.55.0

