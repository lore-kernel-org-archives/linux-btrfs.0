Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602667;
	b=uGWa4w75fQvSnkTg7Di0QBJ+BtrJU67/7AHRBVbOPHRoknmJwWJe1O7OE01p1QgK029M
	 HIaaqU1CPkKcS5hbpShJX1seHG+WfXAUdHYqAmhVlgpeHtBTBmLbbITc31I4/ZGLL9Wbz
	 omKgZoouZAf1Vr+KMCT3uVS0I7i0nQLXJDCfPBmAiWZ/WLq8IeFC0udAE8UpbK3ON8FjR
	 ri3EUg44VWQ8upLbkA/k9+TvDJNZpzYRsc1bxYaTI0AQ+dE0thGC+yeVP5KqmsknO5bYF
	 ktjoi5YHiIPh0bVuVEOCg/QpPGHX047j23IWl2tDvzOnoc63RIMcJcaEgb3yHjgdkVw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602667;
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
	bh=14rei4mu673lzRY2El+QYETXH2UIuC9JnE1YQ3TpT0A=;
	b=P5bekhyApeQdQWFwxp7iEXghCHUtjnv1+fVOtXbi1BJcmYIfyDW/cYP2Q+oeOCz0Iyq8
	 X94yUX6sXVWkJUyr94iNCBFys1s/gZovodPGI3quSBnPikAHCKGxuzXiwsTg9CBEROji3
	 yZhR8JKZbiiUwB6qKUR/LiJ80axZ4YcbirRlaPlj6oUL3n4/CL5kV8xv+zGVqc8uqhfPM
	 zEgt0JKvopjwpPR7nPtOPxHVBhtfhlXzAfxA/q6ahYNDQPFTMtF3PJ6WnekMe1iS3MDz0
	 r/F/Fp/w2iF0P19/0DCsfvG6WX8nDbISs2TZxgRloiXibtCUImhkUkes4NNPTb4uL3g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=lpzGKF2P;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=AYud1RN6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0800A606A32C
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:31:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0800A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=lpzGKF2P;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=AYud1RN6
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602666; x=1827138666;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=CXXoU03zF0QgQPGPk2/3bEjdCFVRjcMDlfa9Heak3ak=;
  b=lpzGKF2PN3jftmz0Dp74GBxhXW5y0DfdYI3BPjkCqKqQGPiuGjN5OWE0
   gMIbtTA+f3MoHMBsnrdmCrQfJoWeQLbX+DxVYl9DTnp7miBEuz1nHfx7f
   T9nxRLT3FiO1a+YGOtic13QkhIATX7tWGf+gJoqrIm+f5azxXLj+HrAr5
   OiFNky7al4n/jN81jAdyXkRQyiQLCj+8UvoGbFoN0qv5Hq9U27jfc22pd
   84yCrp8tJu3tiGTSPfVmN+msXoV7xrIpEdAM9RwslaSsvgoWwTNbNqrm8
   /x75Qw9vqUMvuDwAHRna6SdE6YM1aCWbGTrfQVbbvyfwLaOwJD+bKAZjO
   Q==;
X-CSE-ConnectionGUID: fqYnvV2aQ5ODxAGohtg0BA==
X-CSE-MsgGUID: Qd/alIhHS5Ojohwqkl8Mlg==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="160762668"
Received: from mail-westus2azon11010047.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.47])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:31:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YvUovSYYuotvlywzXshuohpODegs1irOkkiYqSu37s6ifoCb0/4JA+pEp0IrbNyfLTvAHzLg+qacKtP0+rg53N1HiAXLpRcB9EMST1YpFwJb8LJPuteTsUXptfwVFj3WYv7xCMX0ncgNOkPh1BgFyMwHLCSvs7jVtgZotqg6y2cvhcP0aOMkTnvCwkLE6UvL3xYOArgtRoZNpip4AsWYsP6jDjpB81ij3S2Q6hUchKzK7WoV7MwZHFtYASsyvYz8emB4OaiwWLP3zliLKZnFBuq3d/qDbELcmeEc0roL9a/MSkfXY9l+sHbAZyyS5sHkY1FL5faPkwRofeCZ6Uroww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14rei4mu673lzRY2El+QYETXH2UIuC9JnE1YQ3TpT0A=;
 b=HzIuWdV8cIFit4qS3GmrT8HPOLzcegDtIf5U6OqT8UrEoZSI2mxP3zAQivMjS0L8zb/KIeRnSGhLnslEu0BITeD0a84AOZPeqa7hyQ56RzZNkJ6eqs27HlScx91OlM5AlY7K/6HTwtXZHHxqlhNgTI1G0GaAL59hgSueDsh9Ndz4i1TORfCyRy37fvbMJR2tzykCvMYnFf/NT64vMyvXawScUVLdzrnLOI/ec8yh8oP2GdMn0AvPid4LUl47d+MnWuoUaMbQnxLMz1xMrrlJhzcBx5IC0b2LWjiWTyKe+N/pCCT78Kzt25tvCibiDPRSQoXYfv/o0j0HA9funxTCmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14rei4mu673lzRY2El+QYETXH2UIuC9JnE1YQ3TpT0A=;
 b=AYud1RN619HwljLKbdrKXI4U8KmicAW/tM2+YsiD9zhtaOx6GYyMyU03S9+rkd65paC5Fn2WCqGR/S9Um9ah/WmEaatJGJWH8AXDhgzicSHBkHdQPMBVlTe30fClz9uiPcos2osVf79oXNgCeofnKD7aSuy4BaMyNn9QjscfC20=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS4PR04MB9868.namprd04.prod.outlook.com (2603:10b6:8:2fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 10:31:04 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:31:04 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 21/27] btrfs: zoned: promote reset data block groups to the relocation target
Date: Wed, 25 Nov 2026 11:29:50 +0100
Message-ID: <20261125102956.266389-22-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS4PR04MB9868:EE_
X-MS-Office365-Filtering-Correlation-Id: b3203cdd-0d9f-4d61-8f17-08df4adf3545
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|23010399003|19092799006|10067099003|261021123027099003|56012099006|11063799006|261009223027099003|261026140227099003|261102123227099003|261021121427099003|261022105027099003|261028144727099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vv2cHk491583ljqd5tSPFwDCTSs/1L9fn6u5gu/xkhw6BZbMZPY/0NpQJ93lgvvYz1YktbTXidgkF/Ci9PLzvCyyhv+P9XVI48CWB5DnyBb7ZXogx8dQgbt2uxrUlE7VivDZy6ow7u/+CEjTFOBcNLEndlsXIHKz+7CTjzcYbHtj7Owl7hjnc8p0+qzJBxgbXXF6WSbnT8w2h1+cWg6f22g7XAoH/vA3CtF2qpAmGIiZmCacWnWUZ5sMruGMI9MW0IfQbhc5W+slzxy/FhQ+8lfQD23n/HHvY+BxlLBBgbURWcD1N3p91KlpvaOWK34mzP+zakW3wu/afYMymjRurEFua558pEW2V24K5BRcjcuuf1hx04eUO/oCEVwIVs9HEouowLCX04WpN+kKVycDUYnUUFfkslzSJHMu0EzzBa8bHxk3mAFAfrsjtHIbbl02Hd6kJhKQPys9MUElCB3bS4Dhk2+NNHNlBqKXnTmOSstOLaN3hYbtWQyBPIRvzC52hsb86T1NyZDl19PZPyc6VdNqrDW28pN/iQGnsr4yj+u/CnqXCOPGGZYNPnPeZbwNisgp10KmGaUybXHQV97UTcoyWlNn3W2OE4GPVnrlE2d1eSukrher0sE8DHxUTsAqhNlqrpxD/5zoIKhnxIaMgaa1lWyH9pJtO4GF7FbFuPY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(23010399003)(19092799006)(10067099003)(261021123027099003)(56012099006)(11063799006)(261009223027099003)(261026140227099003)(261102123227099003)(261021121427099003)(261022105027099003)(261028144727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pQo4J2srhupW6QD1lXEXIpPlsFtf14tr3V3Zg0nm2GcXDNUXDQUEYDnCGEi+?=
 =?us-ascii?Q?kCsEcT2GdMr/LddT46dp/BZkakTtokWvPKeGkHzrrgpqhFRz+/rXUKzcutAq?=
 =?us-ascii?Q?7+ozPVgmj9wwEROsG6UR6hOGSGI0a3DFRmD2EVr1bN2BpRZ7/IxO0fzQohox?=
 =?us-ascii?Q?D3sAbEwlYzn+h2ykZjAT/ueeJ8wkWVPEuFQ39+HRXTJ2u5tJJC/Up+ppgj4d?=
 =?us-ascii?Q?iMgERHkIuuyJmwELyCYmuU6OV/pqsm/y7VKoQ1IUg0mPC1vspB9tzxDh5tR3?=
 =?us-ascii?Q?JpVxZLrMFT3RYKqbpjwUkC0OqwaOsFZaeFdKSdMRGwlCBupabAnynYuDCm5d?=
 =?us-ascii?Q?izKW4TZmT5OgB0KQIv+Vd22DP9z1HDvPG7pkqzYiNjNO4UCO+I/99vHRau0w?=
 =?us-ascii?Q?1fWZls+n/qmWmkICjuuPsY/LANi6zfGw3GMKMMeiqrtzthSzpIi4HKkmP0SG?=
 =?us-ascii?Q?R998IuD7NrMo7NmePWoW/TA8lHKLi0n0NKYRLHNvJbICV5TgubpzZTjEaieQ?=
 =?us-ascii?Q?0JFilvVNug22/AbVYITcxaST+VrEz5fM4iL45Kf0Qb+IpXRBy7aQeKLDz2mk?=
 =?us-ascii?Q?+vdgCTdWoQ+UcMw9Gg8t/m5juSpt+xQS1ihCHMIRgxz7C6GVjdO4PozI1UJP?=
 =?us-ascii?Q?q+CqaC0ph8vGXe8NT33or2vVbSHiMRjgKRDTp72fzcF2bSTseLGZwSdg4zo/?=
 =?us-ascii?Q?BGiPf+LhDMcK4qfv4dtqP9Ahbb5W2MnZpzW0KXHh73/qDv6Dqh6wCYf1JfEW?=
 =?us-ascii?Q?ZwtGgkcjyx0eliRuiyGZd60pDAohVuCd7e2UODtjRmX7pIQA81dTscjJsQ0G?=
 =?us-ascii?Q?tjdH7j8SxXMxpOvFeSYYUqVPTuZtt75G6KI36ZKcg1qHMxxMAjQlKXkrD6+U?=
 =?us-ascii?Q?bGHin6r78RHZ1i++VvI2TLQtDDqYB8qOOGJVgsGFm2chZlNqIvTwwYZoRr0c?=
 =?us-ascii?Q?FpnHRi8luovInL/sykj2OKI/+sA7/CdHLFnX2x25SVr3T0ki0PU8pbXYdSc4?=
 =?us-ascii?Q?FoZDDCQHBnoQGjla/CFN5kdG9KQCmCwcTdg/u1zqsZgBT2MVFLfpKSW1CFoi?=
 =?us-ascii?Q?HmAnBxSbWvmEj5MACkLpcz1jg3soakVCByswgCdJleYnNxhJZ7YQdG3iDLeI?=
 =?us-ascii?Q?hXgDs0QpWyknA5TrOlrlqfb/scG7weUtLTE2GiWXC1VZsD3VBzaPrj5cpd+T?=
 =?us-ascii?Q?B/zCV6VJHXlsKFOp4/t4j902cGbQ6yds6Mv+p9KpV16k5ptTIfEY+Oz9+D3I?=
 =?us-ascii?Q?47WmZHRrLt7gl+mq8Swr+JSIot+onwP0okBfEthJ5ndkvnvMiAlj2HU6RN/1?=
 =?us-ascii?Q?l384CusuGMjXVcx9Ski6RDDgSUMk7WObxvy8Su0O5JDxhbgk1gxdeAh34ozI?=
 =?us-ascii?Q?wi9JgFhjYsxP7FqQk0b7wLMiGtXd/rzXh2f/588zDQKl3/k/4S0+VuyWrEby?=
 =?us-ascii?Q?l8bMpKLZq0fwdCqfeTQfuV3GLtXBvXoMjN8/LE6LUZTPehp6faLOygl02hec?=
 =?us-ascii?Q?6TOt3j0YPBIwudeV8UvSO3nRnWngAYUHO5s2VdExxMFZt1AeZuEEtJCDbR8N?=
 =?us-ascii?Q?sk6KyWP32Lythahrlc1wcRYgAJ58pOsVrWRFke0x0KyqzMmXtLmVSSD0jjk+?=
 =?us-ascii?Q?0Gph8b2Mr759gewqtb+K/SBx5nIbUHhxYh14j6ri7fZT/ehj+WJJSyY0ICW6?=
 =?us-ascii?Q?9jg3K1R6KkAYTfBT0H90DXnm/zTSiRJONAxQ3brVUCqawowFwtxBb05iLw6E?=
 =?us-ascii?Q?chmj77cyDDsTTvJfNK6/v0iEVkd8uCgHUuv9WIymM3/AQWT3q2DfGUzEKfkK?=
X-MS-Exchange-AntiSpam-MessageData-1: IME5QKuHQiwRe1hpE5zWi3hXLoCusKq1S/Y=
X-Exchange-RoutingPolicyChecked:
	PEu8uUlv/fBovNUe/cCy4KoSUt2U+81Kd0sNIwv84AmZnSJw6o/WQ/3IoghfaJRQu3ikdbSthZam1qBJOyLdOqzjXBm6/wCtHusDwjs96vg1mw5Aw3ZjKb2TQ3iesLTuuMFQ1qs0psrBI8zHmd/mVON1ky7kspwLXZk4TSPFNCWDlAKq8CiZ4V+FkMwYn5h+iOvFob3t2GIZCM/fSRH/dovDBcpVObedcbKQcl7sTKDfPMQ2FdZJuou4zIdaHahjhbWcdeKybPGftYiSGHdRfnjsJ1l2P++UR2Q/LTO7+LCdtMH/rK8RJJFI+v1QuckUat0k28s0Pz3Lb8IEwl82Ww==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0f1yUjEHzT2DQ25rw5VMxSkcVo0ATAV3/9ZirmkMei1MCyhrEN0bFWCxNQkxJwhDmasJdpWzp1Mgn4nthYB6mJk0a0bvY49CX+Wsc5wRmPr3300owaI9dHFHvI7QHmuWglhBQovvOBYRzVNfTpw9iirZi2e6T43GcTfYK05oi9GEblZ+Aud9nBSyZkIEWPudpM6KgWEmtyRmMSycNJJ+xhBael+gIWb/mhsoFv5SOB2UJUYOCfjDo7MvBcpLxA8CBl8pIdC79xpDvZ2OaCWnLfTbTC8IEO4P5YWwSWRBxYP8J86MFMWJwYl5pUaSUxTxK3KdcocVnefQuEgw6DqP+1xisRnmYRajwdyNy8yV7Aidr3qSH1nvCbY6mOOrg66ILJ9f4Z4QmToSDFohttyinxjpWPeK0w3aeNh1Lmfzzuw8xIcZMxWRHhWDuvbSTmdOqhdMDbhMU2VuE2z0TA1wIZhVBlLvV37I0G0DvZl0OFR/ttduuJlkb52swKlCuZsUzDUzLhHiPhmdjOKF616lfyiFILM7sqbLHtyG81dyQIbetdEvKwfjkd9S402hQ3aBwQebmVWPrNFhSkmYlBbYVdQHVtDjM8vjVvf7P7f9cj1+1YIknRaypTvhwM8Cpl7s
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3203cdd-0d9f-4d61-8f17-08df4adf3545
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:31:04.3783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQfxOv9Sw5sYHiV90tAyiIUoFOjNrw5nbUY7pBxUSTNv/AOcthltPnBOsFdLlAfw2SVdmDFBpF3lVcVgJyheTYQUVrPZBc2szw1BkW3Tj1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR04MB9868

When btrfs_reset_unused_block_groups() resets a data block group in place
and there is currently no data relocation block group, use the reset
block group as the new data relocation block group, instead of returning
its space to the data space_info.

Returning the space first would let a waiting data write take it, only
to have the block group moved into the data relocation sub space_info
afterwards.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ddf4ab530168..6c99c28bbb45 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3121,7 +3121,8 @@ static bool btrfs_set_data_reloc_bg(struct btrfs_fs_info *fs_info,
 	return true;
 }
 
-static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
+				   u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 	struct btrfs_space_info *space_info = bg->space_info;
@@ -3181,9 +3182,43 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
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
 
+	if (promote) {
+		struct btrfs_space_info *sinfo = bg->space_info;
+
+		if (btrfs_set_data_reloc_bg(fs_info, bg)) {
+			spin_lock(&sinfo->lock);
+			btrfs_try_granting_tickets(sinfo);
+			spin_unlock(&sinfo->lock);
+		} else {
+			spin_lock(&sinfo->lock);
+			btrfs_return_free_space(sinfo, *reclaimed);
+			spin_unlock(&sinfo->lock);
+		}
+	} else if (space_info->flags & BTRFS_BLOCK_GROUP_DATA) {
+		struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+		struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
+
+		if (space_info == reloc_sinfo &&
+		    !btrfs_inc_block_group_ro_notrans(bg)) {
+			zoned_move_bg_to_space_info(fs_info, bg, reloc_sinfo, data_sinfo);
+			zoned_dec_bg_ro(bg);
+		}
+	}
+
 	return 0;
 }
 
@@ -3582,7 +3617,8 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		list_del_init(&bg->bg_list);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		ret = zoned_reset_bg_in_place(bg, data_race(!fs_info->data_reloc_bg),
+				&reclaimed);
 		if (ret || !reclaimed)
 			goto requeue;
 
-- 
2.56.1

