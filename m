Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602625;
	b=HnSZ/FeykLfoZk+eBblL9iVAp+38fedperuwFQpfaV6Q9hUCGycYCYhN7Uy01FXShD6l
	 N9Qwiq7kxAeR+74uLhlv7JypwgN3Az02hws1yL/NpPQhRAxy2rnFBunQ/zJRLlrB0BV8t
	 6YelZrm+ay9k1VSi/yhNQx6FO/3d89kvZpulzqgvzYadwKvTFAocItbnGdmK9HkK8XLRt
	 YC1F4UUu/lnZZaB7+tUfLUoksq0l7BXIWRNieXber5bNKAMjenGZMv5ouooyRLizUR+mi
	 st4rwCn3CcNn7u2iksoNFeGwSvKHmV6pcybjGcQYlnwS/bfakMiIhndXu8qA46lKTAg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602625;
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
	bh=Wo06sOL1ATbQojDYBW4dxtqLE6aqP9L/kwZRO0gDcIY=;
	b=EJDVFGQCcQ3RNS0f3hzogrTQitDKLw3WHciC5QlmPS7n4l0PjPnVfefipWJRzEXUwGpB
	 nwHgR9ZSRg0GkTRVzr0eUvQIeP85gCrwx8p6sPQkzHvUg3l7DLDAdVvqQ5yVxcRWUBcUY
	 V9wrd/tha3YmUg7rWjTmnNl+ungrgjTljzwt5U8WCnFIY2kM7gs+wL/UmNJxviu5HZ05j
	 v3pVS0NOndoqpC1h5OMlnrWjkTYrasVL6yMDgEVit8oHXZm+BZCBCXC0daj/RPfRT6aJE
	 om/rZ/6b4aPZgRbq3CYkZNYFWuSBQom6rari95nLiIqiw6mglJvTMdFli8WQWu3CFcw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Q+qPO5NV;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=C3DlxqjM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DF4606A326
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33DF4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Q+qPO5NV;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=C3DlxqjM
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602625; x=1827138625;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=uncwPT2CQroSjZGV7w+f3b5xcNVwTCYMwlq0lanlq0k=;
  b=Q+qPO5NVmD6KMjn4Fl9eeqzPyGZt6achx3g+sxqaO28BVXgS80IP3jvg
   W3O73BXrg4kggykBN4Z82VJg51L1Z9xTO+5F6avXDyw90QRLXHZdlUQQl
   izQk9nJ4t2d6fiYO4JzRmTJkzFYcFxAu0MpHTsMTfl6SMPH+xYvi30mXS
   2StptQcIYioqcxIEYP5nLhADf2wr05lDgAl7EyLo8UzS0oiiwR9QXwFID
   ExnZT3BbQqVZto/Ka1IaK/tRC/2Kyx86+0+x0sHu5oJGLLcQImiepiMX1
   kBUBpJgSrHYtS22Q27wwFQATgGPFWSE/pFI/IRJDPQ3oNpySfDhg/lVLN
   A==;
X-CSE-ConnectionGUID: 2ylYFKxrS52aLzBLVyB0SA==
X-CSE-MsgGUID: w6GjxXatT8Oy/NM2Fb/2wg==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662141"
Received: from mail-westus2azon11012017.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.17])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F8MY3Z/z6/68a7xmzviymSa9OMgSOl8JphZ0Nob0VQZho1vnwjcjrVFn45SsI98UOTL2Fp5r48/+L9VQLmfPsAT6Q5Um8g9OrSFvIk7X5gYDOiX4gPx42CQOCjT5sz/Y3l2HO1qbeCSprtYzPQ7ytwMdHnKVwd/bwoHXVPvAvnT0Tr+3xCt06QF9baA9ZIJRrk4G8VZf4eHVdmiBcIIwOfa3B0eatl9J+ShX8JDP9chKoqg+fFgJC2BLSq8tXwN0uTscLLkySBgpAXpzvQ3HG3x601jI52DPwbQHHOD9THtoljXRmGDhMv7p/7484kCjdQwAFE5S7ZJdeoPew3rV7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wo06sOL1ATbQojDYBW4dxtqLE6aqP9L/kwZRO0gDcIY=;
 b=ln+Kdh80KKG0H9U0VzMClTcWMcHEaB0DbduiAbd7L2YFJ28GdD9z6IVwsvg+EXBgEFt9duqJuYEInb4bdGPqaKu3WF0zq5Bn4GlasrHTvmdcBSwmF24DRLLlP/o/Zb/sZHXp4cQNhz8kIRTRW5nplmGUv3E8l2735+BiwiXk5fC365McaVHESTep3++Xqsvz2PIFXcGJ6fNbglDLvB8+Ix25RabPt0Wa/QiLTO8V2+rOHj28zmngo9jgVjrFnV9owX/u9ZXKKqB4XMOMlwbcMEgCaXD7neDacS3nOF6v8s7W+4IfFEnf3yNMVCSeoEQn8k8Q+Gz/R4KbV7WQ9kGaOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wo06sOL1ATbQojDYBW4dxtqLE6aqP9L/kwZRO0gDcIY=;
 b=C3DlxqjMMiCD12XBsZB33e7WPB3lfRIDwhI0ON1a5wz/P6+QvGwh7scNaeA5bJv0x5GLiS9dVySLAIkLm9iY8n1lP0s7ZyNYhKizoEo+W/Tj6g6+FgfLgD3TzSDKCFD1lyQbt6z94nhHw7witSdAeysHodpT0+QdOJGZTTCSN7M=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:22 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 04/27] btrfs: zoned: don't use active zones for conventional stripes
Date: Wed, 25 Nov 2026 11:29:33 +0100
Message-ID: <20261125102956.266389-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
References: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0411.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f55ba68-5cb6-4277-28f9-08df4adf1c6d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|260925022911599003|260925021911599003|260925021311599003|261022105027099003|261022075727099003|261028144727099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/Z7v92MCr71wOXjgrJMsYeDEJQLSbv8ut91GukDBseCIu2Xm3Nkpx5zQ5Bgp/D9iQtAO/bDw4VqgaTTV4BavHhMEBk+aq6YDx9N+CHbm/amWa7pHAF97/XF78mcJd3n7zn/4eiJiC1BpukkWiGUehSEcj0RpNXMHPb0tNk/GysudEMXqj8lgVZqhB+wpA9W7EeDy7BywpxTk+RcSv0aUIknEkvmPn0TG78wulfDZlk6P4PsHk089xGDIyUcLFX4zOO82HRQzxvg15oaksLvTSvUxYJ9pAmCwmieURYWMYn8s6O4qlqUouBGlSWe5SlSxTUt1IV2LUwIEjV0MtHxGh0AX9P32UL+AX3AdXEkN3eUJKPDzNWEosYIcykf2oQ0MCH5b34EHAYhcNlVIAwejpaivdcPZLMciEeAAGG5xSDrMqlJKravdNpurlpstHWtWOF64z11/miLfbHbkdpW0/gYA/ncbwC1uMmw8UnJ8sBRYPzbLkD2nH54UknyFlSp3FkJdIWiDInd3WMgbqsav0MZZJm1fh2OfywbKViqgERr33QRwjqpAbP+a/kCTGinVDJOaXg8Rj8QCpDPLhRXoJ+R3thkv+LJXi7QY9sYx8e90Nx2oJFcrFyuC0+Eb10pbB+vvNgCax39CoM+DPhMc6IYtVKroj57x/4X1rt0GSvM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(260925022911599003)(260925021911599003)(260925021311599003)(261022105027099003)(261022075727099003)(261028144727099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pWD7Z085jyqadv0tfVD9UTNXfP2ZyHZGCPmaRBq68Ck6qcDUzg6rns7jef33?=
 =?us-ascii?Q?Jo0ZBe6IFeJ/qwq6l1VpHLiMlNDTv9+fmX6HJpxFiuIiSMO6s6U1RMk7VHo6?=
 =?us-ascii?Q?Or+RiN9MIGKakR2tCNWuf/Hd+Rj+3F5646uG64pqU0z8oBzJxFu3uvCqONoS?=
 =?us-ascii?Q?tjUu0JCpxVrDVclH5mUj6H9LTqT9cC8zKA+vvr0b9RMIFPLrSCIsl2uBoJth?=
 =?us-ascii?Q?89Zjy3Jrnb95uAQ9vWJWsSDdGuLdRUHc4oLov33L6t1FhavighfA4dreHasR?=
 =?us-ascii?Q?qZjhQgKuUUAdJwhP3fvJ+0ewZulXryA5NU2JxUyErrtWA17QAfhvXw7G1Xit?=
 =?us-ascii?Q?GyaJ4ft3PE+gOGeztwBpGY8XCymLDXe/5nqflPSnQeZvb+MATSvelAodP9nc?=
 =?us-ascii?Q?aPQHt5yT1exSJX9fe8W962hN3eXiewaDyOPZ/1bkgIytZBS4VqWZtJM0jZOi?=
 =?us-ascii?Q?U7JACk8IY8X6EPBiZXpaXasOQYssyzRyox/J3W79zaOPfAdyFWyc+Go3zvEJ?=
 =?us-ascii?Q?BcemO/ZmCm7H6O4A7ZzV0tcUGqPzNLlDClU7EI1jZaHVOUlQ4lCP6AWlubM7?=
 =?us-ascii?Q?6lHvwK/7RULJSLG6Ye7VlPBYWroVJGy8WElE2q596JxtEuyQvC7SD6S0e48u?=
 =?us-ascii?Q?xfzsmn2lWmKeaaGgaTZ6DeyY6S7it5hqevMhhOWggzYBHC+xdfvkSlZCSyyh?=
 =?us-ascii?Q?ZT5IZx1vlJsprbBgNdIpxAENaD1bMaQm2xwn7OR56bXAhQlxBaH6pgejg/A+?=
 =?us-ascii?Q?rmJC1n8q165rudYozv5ZUer3lD+wfvSyzhtys3juciWibVX/0VyL17oy9dR7?=
 =?us-ascii?Q?CVEV5KzHBunVxuY8UD3tvzEQ8p2Bz4IJCn7ScxJT22qk7dmxLk71iNKupa7g?=
 =?us-ascii?Q?ShqDKIVO7TtKWwv2mBLz23MNtYLUXRp3UK1NM3oeTpSLDx3cSnUQvlbXXsi3?=
 =?us-ascii?Q?6jm23VnTNBm35duGUPDLXnegZLRm19jc+eirlyiWPrQlMDR/IKTZVkb1DJ1x?=
 =?us-ascii?Q?1X468yU6jeXnRc8ZBX5h0E4Wbqw8PkVKYx60XqQIYQEFZ+LNqlKVLzQ6+TT5?=
 =?us-ascii?Q?nVAgFuluPqPmy+F+kdt0zv9IPUsuskHvwU+ijDhlyiLqyIFOyqHmliVmiCD6?=
 =?us-ascii?Q?vBKP+LkXGaqBXHjstfmQ/s0180TCDromPq+8T/H3tZz/4LQDlt+jSxpVPFlY?=
 =?us-ascii?Q?628Ozworuntdir/v/CHlFNYinJeXMvAj1gD54Fh0nfISo6xrmy8j8y2h1xqB?=
 =?us-ascii?Q?OdklBJtgLktHqkEI/4Qy6+KdXfQ62vzwJrTFS8g6Cz8ay5UsZpINfxyUBBLz?=
 =?us-ascii?Q?WXlrrw0MH8+5cXuM8tZ+PGvrg1C0HIY+VeiYHVLscfnudaz4uRs9hyzaufVB?=
 =?us-ascii?Q?+3NtjcpBSA1o/Qb18uBsNB/URVDmox5D9mmDNuYqAL9MIhJwTAOkms87CBv8?=
 =?us-ascii?Q?aHKkdj8e1eRLpmy8dbZk0hcg/wOdIbLn6sfmc20XHTdZlpsT7g9w6tMRIRXg?=
 =?us-ascii?Q?tHFb30yOxRCI5BVaIJWu5ZG/4xeHXMpTONE0C6R9ZcmRwjisT0U0X096kvnV?=
 =?us-ascii?Q?0fsUL1ZWy9rniXdd44X1Ig1FH17v0GeF8EkjuuCYvvggW6esZhrPQF2pX+n/?=
 =?us-ascii?Q?RhvlGdcim4FgFchD+3UfNYEb+uhfhOLuOcoA3bVUeEt30GjABdNtpRbBLEo7?=
 =?us-ascii?Q?E/g+lPs6AdyoIFJ+dnqb3qO4/m2nhnowq+dIzylyhc/hYltjUeO29lPtGxO6?=
 =?us-ascii?Q?5X1qWMHmAF7c0e48NNiA+vOEZn3hEept7ao/92pENQW4zR7mkoOh4gFZUi2a?=
X-MS-Exchange-AntiSpam-MessageData-1: cvjCFxplFtEWlzyWyR4S9QKLLi/VmABF8WQ=
X-Exchange-RoutingPolicyChecked:
	VLhEuwahH0KN/gw3mgbLwWenyFJ/vSeTU0A50fXxsmrFm5i5mJS+oEKqEf5H52LYUiZCBDu7devK1Jj5V1T/NCKzrLntY1hatUt6mWzCctFIGV+7u+stoNqKdUuInNRV6VxtIuJwFvBbBoYnjOLQPu6JbHSyMwsXIw3dN+/RMZU8+RCtNsVsj5QjtibTxO+naLxfCHcN918/Q04JbBqWFTTIGjR3tKUBU4O88PBZYbGcdekweye6XW/P1tE6Owvv7fJP19mO5qdjj1SVT64/Fsk/+wPpg4DsIIE0Lr0w7O5Cx6moXLi4Sjb5JzC3wa4zY0DZpEMrrU2PFffka7lplA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6BpNxvjdtKmQU/tgxp0x5QAtKmqj28MF/GnS3Mpej0SW5SGbAT6JU61cCdfbQi4hSor2n82SVTCSjuTIia17d0WO2j3MBTeIbzOCgfO/tLYPweuJJJ3SORtirQS3CqBdCBvlQNirGM5ca8iATaV/PTlniR/FrxNKzw51rQXgNOXEAdIyQySIdml3+iDKnFOHIr2GwKbFLlhQbTO1cojjK/ILJ3Jsg5a5ghtE5Y+JYprapJeovAvt8/vfWQ5QsWb/raNS7NzUAiuTnVZ2RmXAbnvcczF4kxZ2IdB597Jk+hqctkNyyTxNfw4xnBx2vgN1B0NTE1rDY74qA/a5Kxt8AX0ET035Od+rWJYj0Sr6d3SD9rNtvEwk4109F8NW0/TaGYOEKj4i2ZZC+eKFL/mmjOxFGMJSUndCswCjN/I08JSr1Rlfo1wwYRcfteuOhbbxyZPc2XP0WZnjEIAydNc1XSh55990FfYdMM5guB74ZtFH8gGMZAS7ShoyiF5P+u/yFskZdd/FpsYWZUfJ8J45kJpgMJwZHxpC1p1BBW8We80LVVbGo053aMxD4Y2C8oYaRpIxwnsNixUWG3VTcvzlEkEFFjpnZNLef1OwtdH9LGSvPoC9ExRGhfzzbcj13IUe
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f55ba68-5cb6-4277-28f9-08df4adf1c6d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:22.6923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QWzXaRC3YYCeGvJbiQPggOIYeZ5joYKDyQV3TFIyroUyv74EDZyhByLwG7n7GHzc12cfmx/4xah5UujwZn6d9+OTx7U1Yt8dV+iMZ1t4R5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

Conventional zones never consume an active zone resource, but
btrfs_zone_activate() and call_zone_finish() take and return one for
every stripe of a block-group. Also the DUP/RAID loaders activate a
block-group on an activeness mismatch between its stripes, which always
happens when a conventional stripe is paired with an active sequential
one.

Only take and return active zones for sequential stripes. When loading a
block-group that has both conventional and sequential stripes, the
conventional stripes take over the active state of the sequential ones,
so the block-group is marked active without activating anything for the
conventional stripes.

A fully conventional data block-group stays on zone_active_bgs but frees
no active zone when finished, so btrfs_zone_finish_one_bg() must not pick
it, otherwise the caller allocates a chunk that can't be activated.

Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/tests/zoned-tests.c |  16 +++++
 fs/btrfs/zoned.c             | 115 +++++++++++++++++++----------------
 2 files changed, 78 insertions(+), 53 deletions(-)

diff --git a/fs/btrfs/tests/zoned-tests.c b/fs/btrfs/tests/zoned-tests.c
index bb9969210444..df730ac3fe9a 100644
--- a/fs/btrfs/tests/zoned-tests.c
+++ b/fs/btrfs/tests/zoned-tests.c
@@ -44,6 +44,7 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 	struct btrfs_chunk_map *map __free(btrfs_free_chunk_map) = NULL;
 	struct zone_info AUTO_KFREE(zone_info);
 	unsigned long AUTO_KFREE(active);
+	unsigned int nr_active, nr_missing = 0;
 	int ret;
 
 	bg = btrfs_alloc_dummy_block_group(fs_info, test->bg_length);
@@ -80,7 +81,10 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 		zone_info[i].capacity = ZONE_SIZE;
 		if (zone_info[i].alloc_offset && zone_info[i].alloc_offset < ZONE_SIZE)
 			__set_bit(i, active);
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
+			nr_missing++;
 	}
+	nr_active = bitmap_weight(active, test->num_stripes);
 	if (test->degraded)
 		btrfs_set_opt(fs_info->mount_opt, DEGRADED);
 	else
@@ -101,6 +105,18 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
 		return -EINVAL;
 	}
 
+	if ((ret || nr_active + nr_missing != test->num_stripes) &&
+	    test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags)) {
+		test_err("block group marked active before all stripes were checked");
+		return -EINVAL;
+	}
+
+	if (!ret && nr_active && nr_active + nr_missing == test->num_stripes &&
+	    !test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags)) {
+		test_err("block group with all present stripes active not marked active");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 4623ebe5dbd3..0b29d15b9fab 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1433,8 +1433,7 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
 }
 
 static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
-					 struct zone_info *info,
-					 unsigned long *active)
+					 struct zone_info *info)
 {
 	if (unlikely(info->alloc_offset == WP_MISSING_DEV)) {
 		btrfs_err(bg->fs_info,
@@ -1445,15 +1444,12 @@ static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
 
 	bg->alloc_offset = info->alloc_offset;
 	bg->zone_capacity = info->capacity;
-	if (test_bit(0, active))
-		set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
 	return 0;
 }
 
 static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 				      struct btrfs_chunk_map *map,
 				      struct zone_info *zone_info,
-				      unsigned long *active,
 				      u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1504,13 +1500,6 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 		return -EIO;
 	}
 
-	if (test_bit(0, active) != test_bit(1, active)) {
-		if (unlikely(!btrfs_zone_activate(bg)))
-			return -EIO;
-	} else if (test_bit(0, active)) {
-		set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
-	}
-
 	bg->alloc_offset = zone_info[0].alloc_offset;
 	return 0;
 }
@@ -1518,7 +1507,6 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 					struct btrfs_chunk_map *map,
 					struct zone_info *zone_info,
-					unsigned long *active,
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1562,15 +1550,6 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 				  btrfs_bg_type_to_raid_name(map->type));
 			return -EIO;
 		}
-		if (test_bit(0, active) != test_bit(i, active)) {
-			if (unlikely(!btrfs_test_opt(fs_info, DEGRADED) &&
-				     !btrfs_zone_activate(bg))) {
-				return -EIO;
-			}
-		} else {
-			if (test_bit(0, active))
-				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
-		}
 	}
 
 	if (zone_info[0].alloc_offset != WP_MISSING_DEV)
@@ -1584,7 +1563,6 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 					struct btrfs_chunk_map *map,
 					struct zone_info *zone_info,
-					unsigned long *active,
 					u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1676,13 +1654,6 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 		if (!IS_ALIGNED(zone_info[i].alloc_offset, stripe_len))
 			has_partial = true;
 
-		if (test_bit(0, active) != test_bit(i, active)) {
-			if (unlikely(!btrfs_zone_activate(bg)))
-				return -EIO;
-		} else {
-			if (test_bit(0, active))
-				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
-		}
 		bg->zone_capacity += zone_info[i].capacity;
 		bg->alloc_offset += zone_info[i].alloc_offset;
 	}
@@ -1706,7 +1677,6 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
 static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 					 struct btrfs_chunk_map *map,
 					 struct zone_info *zone_info,
-					 unsigned long *active,
 					 u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -1828,13 +1798,6 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
 		    zone_info[i].alloc_offset == WP_CONVENTIONAL)
 			zone_info[i].alloc_offset = raid0_allocs[idx];
 
-		if (test_bit(0, active) != test_bit(i, active)) {
-			if (unlikely(!btrfs_zone_activate(bg)))
-				return -EIO;
-		} else if (test_bit(0, active)) {
-			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
-		}
-
 		if ((i % map->sub_stripes) == 0) {
 			bg->zone_capacity += zone_info[i].capacity;
 			bg->alloc_offset += zone_info[i].alloc_offset;
@@ -1865,27 +1828,35 @@ int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
 					unsigned long *active, u64 last_alloc)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
+	const unsigned int nr_active = bitmap_weight(active, map->num_stripes);
+	unsigned int nr_missing = 0;
 	u64 profile;
 	int ret;
 
+	/* Missing stripes are never active, ignore them when activating. */
+	for (int i = 0; i < map->num_stripes; i++) {
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
+			nr_missing++;
+	}
+
 	profile = map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
 	switch (profile) {
 	case 0: /* single */
-		ret = btrfs_load_block_group_single(bg, &zone_info[0], active);
+		ret = btrfs_load_block_group_single(bg, &zone_info[0]);
 		break;
 	case BTRFS_BLOCK_GROUP_DUP:
-		ret = btrfs_load_block_group_dup(bg, map, zone_info, active, last_alloc);
+		ret = btrfs_load_block_group_dup(bg, map, zone_info, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID1:
 	case BTRFS_BLOCK_GROUP_RAID1C3:
 	case BTRFS_BLOCK_GROUP_RAID1C4:
-		ret = btrfs_load_block_group_raid1(bg, map, zone_info, active, last_alloc);
+		ret = btrfs_load_block_group_raid1(bg, map, zone_info, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID0:
-		ret = btrfs_load_block_group_raid0(bg, map, zone_info, active, last_alloc);
+		ret = btrfs_load_block_group_raid0(bg, map, zone_info, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID10:
-		ret = btrfs_load_block_group_raid10(bg, map, zone_info, active, last_alloc);
+		ret = btrfs_load_block_group_raid10(bg, map, zone_info, last_alloc);
 		break;
 	case BTRFS_BLOCK_GROUP_RAID5:
 	case BTRFS_BLOCK_GROUP_RAID6:
@@ -1895,6 +1866,16 @@ int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
 		return -EINVAL;
 	}
 
+	if (!ret && nr_active) {
+		if (nr_active + nr_missing == map->num_stripes) {
+			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
+		} else if (bg->alloc_offset < bg->zone_capacity) {
+			bg->meta_write_pointer = bg->start;
+			if (!btrfs_zone_activate(bg))
+				ret = -EIO;
+		}
+	}
+
 	if (ret == -EIO && profile != 0 && profile != BTRFS_BLOCK_GROUP_RAID0 &&
 	    profile != BTRFS_BLOCK_GROUP_RAID10) {
 		/*
@@ -1970,6 +1951,23 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	if (num_sequential > 0)
 		set_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
 
+	if (num_conventional > 0 && num_sequential > 0) {
+		bool any_active = false;
+
+		for (i = 0; i < map->num_stripes; i++) {
+			if (zone_info[i].alloc_offset != WP_CONVENTIONAL &&
+			    test_bit(i, active)) {
+				any_active = true;
+				break;
+			}
+		}
+
+		for (i = 0; i < map->num_stripes; i++) {
+			if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
+				assign_bit(i, active, any_active);
+		}
+	}
+
 	if (num_conventional > 0) {
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
@@ -2013,6 +2011,13 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 		ret = -EIO;
 	}
 
+	if (!ret && num_conventional && num_sequential &&
+	    cache->alloc_offset > 0 && cache->alloc_offset < cache->zone_capacity) {
+		cache->meta_write_pointer = cache->start;
+		if (!btrfs_zone_activate(cache))
+			ret = -EIO;
+	}
+
 	if (!ret) {
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
@@ -2462,6 +2467,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 		if (!device->bdev)
 			continue;
 
+		if (!btrfs_dev_is_sequential(device, physical))
+			continue;
+
 		if (zinfo->max_active_zones == 0)
 			continue;
 
@@ -2539,6 +2547,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
 	bool cleared;
+	unsigned int nofs_flags;
 	int ret;
 
 	if (!device->bdev)
@@ -2547,18 +2556,17 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	if (zinfo->max_active_zones == 0)
 		return 0;
 
-	if (btrfs_dev_is_sequential(device, physical)) {
-		unsigned int nofs_flags;
+	if (!btrfs_dev_is_sequential(device, physical))
+		return 0;
 
-		nofs_flags = memalloc_nofs_save();
-		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
-				       physical >> SECTOR_SHIFT,
-				       zinfo->zone_size >> SECTOR_SHIFT);
-		memalloc_nofs_restore(nofs_flags);
+	nofs_flags = memalloc_nofs_save();
+	ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
+			       physical >> SECTOR_SHIFT,
+			       zinfo->zone_size >> SECTOR_SHIFT);
+	memalloc_nofs_restore(nofs_flags);
 
-		if (ret)
-			return ret;
-	}
+	if (ret)
+		return ret;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
 	cleared = btrfs_dev_clear_active_zone(device, physical);
@@ -3048,6 +3056,7 @@ int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
 		spin_lock(&block_group->lock);
 		if (block_group->reserved || block_group->alloc_offset == 0 ||
 		    !(block_group->flags & BTRFS_BLOCK_GROUP_DATA) ||
+		    !test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_flags) ||
 		    test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags)) {
 			spin_unlock(&block_group->lock);
 			continue;
-- 
2.56.1

