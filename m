Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795699728;
	b=Gtuz7YWUKhxfgrxWtXWAVM4j8ydYegiYLfNK7uMMJfY9cPRISAvr8vOyHAJ8Ixi2Yhc5
	 aou+1iF1ramjp9EIOxwGqVFOY2NStWfcb9SUjXUjFwjOkckI6nluL7RrTxY/soT53gphr
	 snnB78848ZXBbkFq7G+CLdwHliz/jp6ZxLCJOXoy7vqIx0Q6V+08uvjCLFi3WvdrYtZ/G
	 eo6DAbODOJlZpQ0IwiTkYRvLVH5QkXaymsOgXLXkXrGGw1kfohfG3stN/3pnK9zxwausu
	 lv+IxsTGeYYmagINuHxLUwL8HDgLlxTh5pHa0AODEXJp3MBP3yGbeqjPVmzFeh2CQLw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795699728;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
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
	bh=wDDGX/pwpvIYlzVx+MSF8ktel68xTPa67dtpJsdVyYQ=;
	b=DJEHJ6jVFreDzaReP3Rd5BosDPr2nXF2SSBTpKLLTz3GelxiYSkEY39j4Co/emWer3d1
	 3cr5Ld3e14a8UpFHZOUObG4tzagNqqHfjJJVQjkTukPV0JMUXOnXw9fCY6bCccengbWsS
	 RQ+CdDPAc7J/E+uw5UJ0sOtudFWAyFpw9vseHMczwxAa9lv8qK0uRNKjjaBfA0urSp4nU
	 gUgy7z8IUkM4CUKFJrPaIGplTbBU6Qe6zhvFIUnP0+mth/8HcvPOpPa/K4E/lloCGdNvs
	 TfpiwfvtjQoTgMJlwNBjmqrD4tAjMUhyGg41Y5BgbsfhnuHywST7MiSNT8I8LiAybeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=cxR7djRR;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=fGbdPUAI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF51606A32C
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 13:28:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EF51606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=cxR7djRR;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=fGbdPUAI
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795699728; x=1827235728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=HX36EuF5GZ1ifYjcvwzcwDyWTFer8NWwcllCfog/5Vw=;
  b=cxR7djRRADFLXTbrhRIgvv9sD3jOhJjJ+v/68jk94SkMXvTo8d6vD0M8
   6WZymMxOTunesYfnyeyBwlhYaV80L0QIL4VrlhXAbTFE7NUBol3sUkeb+
   aBPgbwcyAb3POdKQqZtkRaBgdfXk0Tke3YU7SmISwTSL7RgQkEIyESykT
   Uo7cVfbkCnbrs5fK+kJ8XOomCc5rcYPkwt9NHgJAZAyyK8/gvGl0u4dIY
   L1/CELianquEyBTSglVN/0db5wp/buZnr5V1LonEOZthr3WDJx4O3Mn5b
   v/NZEFSzmtrTBM6Sj3r3Me1AUQ+UrtpDARL3jVYuAAECTpJ2x+XN9wlkn
   A==;
X-CSE-ConnectionGUID: byOJewZzS3aL4zsFvdBVyA==
X-CSE-MsgGUID: 7LTchQUvRwG+vYEUHMArIg==
X-IronPort-AV: E=Sophos;i="6.27,234,1786982400"; 
   d="scan'208";a="162817779"
Received: from mail-northcentralusazon11013016.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 21:28:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QVRsQ/ibg3KoRwJpD+OKMU2KCvkMii7NM0f2VPV88eYbzfmufWx++psu/e3cqF82GBWEszewfbQstyyIaJuRnWDSH+8+Pi1xznzgM2nx+yaz4PcEtZ++e27y6+1dCUTytx90Ax5Own+imaoXq47mDqQFQJPPWIqBq+bkuu7wRiSPa5Y23N0EgoEAmH5Ki1MNqyokRifi3kHsGY7RHxEgtQ8mFvAPoo5Xw2IEQ0tNUlNWsWRf6eDEPLhEijuPGM1vBPrlAVoaB1HDkN6fMo6ERF1koegCZIOo2dgHQlDbL+gjZ5kc5i+YDgWmsnDXjnFhD2fHjM7rXbi0McO+i+VEJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDDGX/pwpvIYlzVx+MSF8ktel68xTPa67dtpJsdVyYQ=;
 b=QZK53DuvhwmGKWo3D0gG95xUJQk8IiPi4pCMU3NAiL3OoVlxQNMYqhTpq4yVkzn2xaEnNm97jpbxNbZZTMLo5qCH/2hu8zKgOBTNBJh+gdYhFOCmy93Cyd3y3lh/k1S78TwUWWgOY30pBPTnm3C68HJAb1BjBOjl0G6oO8gsqjoREn7UaazOnU0wxEfD2f6kmzobnrDn1hNGwm2QsQFGSDDwtLGyGAPGU9qCPXoQtcVbi/51yu4Y9WY2nedUM1IaGa9KjbIyi6oUMqeaPPk/4EpY666acAW0wLsgTsLFh1xtz0JoxqXxVuC8jsV6zz81LOYr0NwG3C9Xw+vsp+myCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDDGX/pwpvIYlzVx+MSF8ktel68xTPa67dtpJsdVyYQ=;
 b=fGbdPUAI16Yhy0xTKpsXVLqKdG+zHIlarSQiQ3SSOyRFiA9L4gVTyj3DiJd9BBouWRBRp9lNl+L6X9LtuSANCQ6/Gn9hS1NOhPfBYMrQnJld3gdBEvtvmFkSf1acQr/b/U3Gwp6NR2ZXxVd44PyY6HQ/oEvJExGR33rei1T6VJE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9155.namprd04.prod.outlook.com (2603:10b6:610:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 13:28:40 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 13:28:40 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Wilfred Mallawa <wilfred.opensource@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/5] btrfs: zoned: search for hinted block-group in prepare_allocation_zoned
Date: Thu, 26 Nov 2026 14:28:16 +0100
Message-ID: <20261126132820.570379-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
References: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH4PR04MB9155:EE_
X-MS-Office365-Filtering-Correlation-Id: 81091f66-6d41-4298-1316-08df4bc12f4b
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|10070799003|376014|366016|23010399003|1800799024|261009223027099003|22082099003|18002099003|10067099003|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261021123027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
 5hbB6TYU6e+LXm/psbzuO0IoevVu3r+q8lcQG0fHkeWKxIjWzIJMrB6veT9jJTzwupCBRTp3ejzQGApftzvpYYPQ9tt0QVyhiVmg/li2xtOu20V5gSauuIVvisLRe/ctulgQuVBLGrb+Mi2ezyBukkrxK1oN7mWCb4PRn3IrMvju6pNEvFvEVNNOpLYazCWuIK/4z0MbO+Ge8lMagvlxGiBEdvYZlaF7DdQp55FX2swiGctX01djunoGS1YRIdGse27rCylI4JSpSkbKAHENtVU1g1EMgvS/7sYYj4vjF0SO0JgYEqE5TjCuOKT/j4c52IxJacYdiJ8LINmQDxJFuqqd6Y46dkskGX4DSjh8Q7R4DBCMMJQSLuw4ZtyWaPFb2tqToI+0OivMeUd73wSvW0Ico3ETS0AMg4N+Z8JmsiwBdi0KSRRsVkDems0zXVo9l3Hrhk55w6qHXuybM8YM5tqzoslKvqHL1LAVP3R/q2QKlJOsqX/haygupDWQpYnsdaMXDloHOiQsy7YwaLJqzMxeQp9X8+xLmtRkh9udvefAZXgIZNYUBBa/7hFVg5Gbof4YcdIM9HzuSyO8sTSZl9HTTwadi5GtStEWT8n2floijNtKf4o1O4AfGbrc+Zle/2a/Sq4fequ64oWKO+dZOIlbAXhcw4DhIRjNW44HI2Y=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(376014)(366016)(23010399003)(1800799024)(261009223027099003)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261021123027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?yDUNr45NFNtBQm1DLfd6B9zVpv2UtwYUclbAHc5q4Ti1daBeLEu6BsOa9TPG?=
 =?us-ascii?Q?gPAV52LswE+zvlY5EDE2y6mTQ0H0MwlhzEVW3AAlOsk434x8UnmLSu2kYtLE?=
 =?us-ascii?Q?WnG+xmdmAoNOW7CJ1gjbp/w+L63oP3J3AGw+ZHIKQbaBLjeolxWPgK4qunhk?=
 =?us-ascii?Q?Rv8TVog4R2FFefsxp0sTlPgAaUNpdFGifyBgAB5SBgPVQRPpb4h68NwTaveg?=
 =?us-ascii?Q?Rm3+A5Y7fooPpyR52Xh3ADcp7q+x79si1A7V/z3QEoMHTdU2lrR2BGLHLutI?=
 =?us-ascii?Q?1m6diz+cOA+1kj0YHj9QjAawlrvybFFxzmAtozvI6nTLenkUlES0dVLM+f8f?=
 =?us-ascii?Q?7f91ruZXVlTVncuqhgtNpS/FZwiwwbFmSo2g0WQmA7Q5yl6VsejDnaS4P20X?=
 =?us-ascii?Q?fUSyikvIGvBAD2cictY11sWbSF2fV3c9cLlhXOGBfX+yc8pgBKyaiT9l3ySs?=
 =?us-ascii?Q?xBNpRyvRpiJpyHxfdsxTCIedhk7PK5G477RDlhVcSQBfQwtucZpdwLv8+qW2?=
 =?us-ascii?Q?ZjFRNGpAeXRiUgC4zjL9GM7N4O0bwskrlnDB7kXiWiz4fLWmfclBOiSnzBs0?=
 =?us-ascii?Q?kau8xJbSiUNtTb1MXkmZFPT5X6/9EF+lazvza+ISwYd6wzUjfr69QteZMaoY?=
 =?us-ascii?Q?6LPhVNGB+XhWKv9c59jyYTsw0uJLqbXj/fkuCVgZWTR4qzPpkpNGxrWrZ8qq?=
 =?us-ascii?Q?/yc8Xr29mQ0qeiFl+xZmX6fPMq0jVDk1WXvM5o8tREE1VnG3mXiTRW/xPUGb?=
 =?us-ascii?Q?WDwT+ypSqJNEZYTjWCc54PQ5vSy8FYBwzjwRFzLAKXxSr66MEdqhDh4nNqdu?=
 =?us-ascii?Q?veQexYIpXZHZhZzrWDuFsjNUOxpbQJ+1KYZdjsro5z1eIVyN4T8ckOvxHaxg?=
 =?us-ascii?Q?ihpMMa+agyc5FQxatjP/LeuQpKGIkCcNJKz31fSwAtAHNHbWAPVEglHWz6G+?=
 =?us-ascii?Q?GUtmgPmUK2feLZ3ZZkMfx5zNfJbSoCXqJj9fjFgj1aGrL0cztA6VIXPqLvWT?=
 =?us-ascii?Q?nvAJCCoBa4MjciVdZ98DZcQTnbSuHPAaCNuHFP+f1mIfBoFWw6cK9NqSSpKB?=
 =?us-ascii?Q?5KgNaHH/B6aAa4b5FjVB54gotiJUDriO3MUoexGbs8TRRFuyITAsxsjRH4xC?=
 =?us-ascii?Q?yeJL1Rv/dOksXCkniG+yxrR4SkNxuSUoO+ECcGKyLEoqegOLJrhhZXefS0N9?=
 =?us-ascii?Q?V2iZGxxIdhyGNQjpTeRG16y9dx+BQWHRLUqfmLIbIm8tElqgm7vLPMXrxjy3?=
 =?us-ascii?Q?w7dsdobtUngYc5Jo07VY0tNUw3lv4Y9YLdNWF1XxNcNS81z6ERjYVZZwbrZx?=
 =?us-ascii?Q?ImDECnSeAPE+omxOl0cIhieCgDKLiREPvrgf8mwr0TPUL4b2wZWcmwxsbniz?=
 =?us-ascii?Q?QSuhBUJOlGTzAa/oqLF4BpvWYVOsdss/u0lgRTadVhLy1Vo6tV3oD1f5wXlJ?=
 =?us-ascii?Q?5GBx3LYDqCN5H2aXnbxyaANjVI6JopwQiA/z+Nq4G2q5ZwWnFMBaF3+0B3Kd?=
 =?us-ascii?Q?Wo+hJmcVp1QSxGnEb12e3kqTfnnk3Q/HYBuqW2poZfGEhS7pCX4XAy9CCmYE?=
 =?us-ascii?Q?pKtMbXHN1L6IkvCaJ2kKBxStfKoC/GHFkFhvhG+k8psdTeM/9aOaj5Fbee2w?=
 =?us-ascii?Q?SXB1XBDjr861jcr1SR/+zxRsfmsDzZFs3yK8pYzIFCU9Su9qzsUqQbpDh9/C?=
 =?us-ascii?Q?mCjKJ+8FHadS44+EWKAAm2NCKfmCdVoREQFJ99WNrqnjYaWMWgoUlmn77K62?=
 =?us-ascii?Q?FH4WJvNhXI9MiyuLOnN+dF0FrjUNop1gtxgzh92bj+WDoHpfx2Cd5T697EwX?=
X-MS-Exchange-AntiSpam-MessageData-1: zrRVYRkjwLKHs3cnyjzPfJWKzlVkl/BYeG8=
X-Exchange-RoutingPolicyChecked:
	drlB23KNmnk2CSIyRitiZpVZvhGP4yFI9u+zSO5ouySegqAfLQ5O+sXNHQbfzbO2dzYHyo/K40o9zpZSfZxYpzrzTfXmTtbzMk9GoMFHgjJlcus6K1d6Y4kSC5xmulJdR4eT6ejY18OcFNInt0pJKsD9NX63RjP2OV8CEkQgF3FQaJtZ815O60AYIf+3ablSVb2BnbLevhQDm6S1I0XP5IZPRFwDQKSCwsQBrhMsst52MWlHAsk3AfM49ShZnFDwtAscszMGuwzTWZanvgyEWcnHMhjG/15jVquhFeh3bgy/lkXcGPec8mT+VpRWQG4AU7nLNAKkUpvN86ZnXnKC7Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t0CKktxI9SXJHLeEGb6uMZeikgqKRYI9NKMMC/suUgaJvvyQ55oEcAUiIe1+lCYpEiFCi/FpFNM9VptWUroPICS1ouKJqXNiAnaF8M7/XhJiZvA8i/PK5diKn5wgyYWD0nS0aGyHqGwzWyGSjKi83ds+g9DajxKY7R90r+c0H2cfs5Fo9XJlYA+Tz5+0aFTatV2DDOIn0WcAa1RnnF12tK2qywf8KPbnS9D3UPw5e3OKTEj2U2FZbEb7ZTZrVNR+GWX25dGsME2N4GE0CsXox7AsxcCPoZgK5ObHHDKlkK1DR6eG9dzgkuWXvq3hflM/lzATWyAKy4itzk7IUAURGK4wmH0xP8aRLJ27JZ9Q+QL7Kvh2s4jfC+Lceg3zkhmDbxCevqUPYMqRPuK4nwDqe3BBeYjKEHeh8adH0OnVOSfYRE+bq++Yqfi3y3nPLaxwG6XEUh4YR7gWH7seW9Nr1Y2gXKZ3oES/Yt5M/YiwuesVgGJCeEqO9LsvRUjIAmZqw19XB1o7jAGZKmrlWSP+rR0REMZlCklS8P/2LhQCxarpOUf5W5adHmV+CRBFA2GwpkUNlgvvXf3g/8tsl1r27KG1MZ7NYWkEa+93VNENmQ/YPUk25wF5TeqbLy262x58
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81091f66-6d41-4298-1316-08df4bc12f4b
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 13:28:40.5326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WvwaCYh7JuqkUF4wXpO2XtzvbTmsZKblk+q98TY1bL95EOpBLIAq68YkpUW6Gztt7AkOe7c/7QzRmG/D27TXHYnFNeXEYNSYMEgqpN4FfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9155

When searching for a block-group to place to allocate data extents from,
honor the hint passed in if the hint falls within the range of an
already active block-group.

If the hint doesn't fall into an active block-group or the hinted
block-group does not have enough available space left, fall back to an
avtive block-group that has enough space left for the allocation.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent-tree.c       | 41 ++++++++++++++++++++++++++++++------
 include/trace/events/btrfs.h | 29 +++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d59289ce3294..0541b38129e5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4472,7 +4472,8 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
 				    struct find_free_extent_ctl *ffe_ctl,
 				    struct btrfs_space_info *space_info)
 {
-	struct btrfs_block_group *block_group;
+	struct btrfs_block_group *block_group, *fallback = NULL;
+	u64 hint = ffe_ctl->hint_byte;
 
 	if (ffe_ctl->for_treelog) {
 		spin_lock(&fs_info->treelog_bg_lock);
@@ -4501,13 +4502,41 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
 		 */
 		u64 avail = block_group->zone_capacity - block_group->alloc_offset;
 
-		if (block_group_bits(block_group, ffe_ctl->flags) &&
-		    block_group->space_info == space_info &&
-		    avail >= ffe_ctl->num_bytes) {
-			ffe_ctl->hint_byte = block_group->start;
+		if (!block_group_bits(block_group, ffe_ctl->flags))
+			continue;
+
+		if (block_group->space_info != space_info)
+			continue;
+
+		if (test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
+					&block_group->runtime_flags))
+			continue;
+
+		if (avail < ffe_ctl->num_bytes)
+			continue;
+
+		/*
+		 * Remember the first block-group that fits the allocation. Then
+		 * check if the hint in ffe_ctl::hint_byte is in the active_bgs
+		 * list and has enough space available. If yes pick it. If not,
+		 * use the fallback block-group.
+		 */
+		if (!fallback)
+			fallback = block_group;
+
+		if (in_range(ffe_ctl->hint_byte, block_group->start,
+			     block_group->length))
 			break;
-		}
 	}
+
+	if (list_entry_is_head(block_group, &fs_info->zone_active_bgs,
+				active_bg_list))
+		block_group = fallback;
+
+	if (block_group)
+		ffe_ctl->hint_byte = block_group->start;
+
+	trace_prepare_allocation_zoned(fs_info, hint, block_group);
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 
 	return 0;
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index dd862d1f2a2c..1378e697a46f 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -2241,6 +2241,35 @@ TRACE_EVENT(btrfs_find_free_extent_have_block_group,
 				 BTRFS_GROUP_FLAGS))
 );
 
+TRACE_EVENT(prepare_allocation_zoned,
+
+	TP_PROTO(const struct btrfs_fs_info *fs_info,
+		 u64 hint_byte, const struct btrfs_block_group *block_group),
+
+	TP_ARGS(fs_info, hint_byte, block_group),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	hint_byte		)
+		__field(	u64,	bg_start		)
+		__field(	u64,	bg_flags		)
+		__field(	bool,	hit			)
+	),
+
+	TP_fast_assign_btrfs(fs_info,
+		__entry->hint_byte	= hint_byte;
+		__entry->bg_start	= block_group ? block_group->start : 0;
+		__entry->bg_flags	= block_group ? block_group->flags : 0;
+		__entry->hit		= block_group && in_range(hint_byte,
+						block_group->start,
+						block_group->length);
+	),
+
+	TP_printk_btrfs("hint=%llu block_group=%llu bg_flags=%llu(%s) hit=%d",
+			__entry->hint_byte, __entry->bg_start, __entry->bg_flags,
+			__print_flags((unsigned long)__entry->bg_flags, "|",
+				BTRFS_GROUP_FLAGS), __entry->hit)
+);
+
 DECLARE_EVENT_CLASS(btrfs__reserve_extent,
 
 	TP_PROTO(const struct btrfs_block_group *block_group,
-- 
2.56.1

