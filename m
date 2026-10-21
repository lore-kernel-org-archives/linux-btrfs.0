Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590143;
	b=prwCjAzl9M3VclKTBSmPgNwuz2jAep5n6nt8Kzhu+KFRaryTbhjoUcREUq4N5jgBq3Hv
	 gucQqGjQ1UTdytlsPt9IlFqvmVMWsR0ycftjT0WrWdIiSVi++QviGWp4O6oxjdZTZKb8p
	 N5YghsniBkGjgGvQB74hNw89hqCYhBQJcS3xLICAAZ8caQdoAuaXMGFKkELBy0P31ALFj
	 cXK4rN/3If9RqJ7WLLkce8Tbwe18s4pqEqX06X9vQyKqKbdOZQeH4Sovh4eeyfVyR56M+
	 8HeU8a4Kogd94C61+nQPvA88RvBOrOz8u9k9xTv8jZCfpWuQFqtXXZyzaBMJwmtcIjg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590143;
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
	bh=VgAaUSb4nrtn/L5e1dDTV6coTpZzspFVN6d5Js+vePU=;
	b=aXQ0noFOVJWbmSWnVTdUd9ZOv0cmjjZnQDuHNkrT9Qbs0HCD6bgiwWp3gQT5vnAeLeo7
	 NbvzcWZRf9T+U/gLXlJnwyYu2LRvSQfKVRsyrpscTBLObQoiPCnWAHCRHDSQmIBCuVkwH
	 RlcJGoojhTvUSynUOd+uUcn8A3OBIqBDtTc3crPiXghGlMMf0pjev5lvaMIeiY2qnDjSL
	 YFUktJ39pP91KU4thyrc77uMtZ9To68wd5iaacvDFn2YJv8j0ErAZwps5PJRqe9Gkolpa
	 Vw09E1MUaEt3y+rNKYOJnkEpIep/xoF+OdYQ16lkz+IL9e8xlhwdY0FbsMGCi9ZSLvQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=h3bMlz1I;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=BRTumWY3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C889E606A322
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C889E606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=h3bMlz1I;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=BRTumWY3
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590142; x=1824126142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=1oUynXWzJ+qxi1icaZV3oGhPg/1Hr4OTWLwP0afTxbU=;
  b=h3bMlz1IBOVxQUEMBnPncFb8DQpDFKKEXRIBby+KbV8P9azvvJKVbMW/
   7TS1kiZhu/rHTlUdlBbTIuZbiRDsL6oILMLqP10Am4j17aT+h2nZphsFN
   uPjpCh4sMzpAkXGt7xipAsDRNXtH729rzUv1hTYLMP2+OJz790opJXdvD
   6haZoR+6l5txogcwn4m6DYIT6Xh2fEqNcMzTWTNP5bF3rZJp+kTf2DxKS
   ES//dyT0AccILT4i90z4o8qlQFdin/0GHnEVCRjXrJ8nILYJtbXZ9J49O
   jLLNDZjbdtrvlxI4zhJgAwLU+40kJlTGkKVYGHYBA/mep2RP9jDlGHmmx
   g==;
X-CSE-ConnectionGUID: d5rG0K7nTAO9ZohidSMJDQ==
X-CSE-MsgGUID: 0v38yeDnSJ6CFK01tdYeqw==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="154422364"
Received: from mail-southcentralusazon11011015.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RI9VIiIqnW3cWwIA7R6WkUp71aN0uu9VXGcU31OVilt6OjZzxVy312iLfK8p6XJIwlw8sQg7T/bI6tCors+94RT64yLGWR7yMhV0P4fEdxgro7Xa+7NDtcJFlwMsPvKmu6j5S5VnafnAtWNWi3rMrNnvpeEF2EavydPr1J9ljt4x6+nBo2QaGFO1tiS0vk95C3J6WmDXnxmdrWfxcaU5CNiMgxPJIcdVgM5bDbLlgHQZseqsWf7gpun+O5lSJq6WorYwJOm7OOobGfKcJKdzIt9Hpnv4upZ83fY38JTzrS5STar7jBK50mjsWGW0OTP3UAB8b9N2piH0MoPfW/BaZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VgAaUSb4nrtn/L5e1dDTV6coTpZzspFVN6d5Js+vePU=;
 b=pkmBt2oxrBbimvHenpre+IaDIahdS+p01cWL3TF6rVV4IvoJsSA9EyGIHtxL+PdNPJW4y2bP3Xi4xysmAL48YncKNlN9U+PS7cVr/E/Qi3QiMofqa8gUcrNvhMj6gf+/zI+8lrprEgpPHNp1X3lDtwyKjPfcyneOiF/plcwGSmSVpkGY9VPH5wmfrh4UGaa4Ko8KlzEAyXbru0SXBloPNIhEwF5JmMqZfly+ecr36cGn7swoFCV36lNzw0w4pEOmwDhLhIMgpEAu8xh1SxznGqoiXhk7AtHG8KgWWI3oQY1VRUEs/cky9gx6bGQwVEDeJqJqsM+Mab/zkbCJNRj/Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VgAaUSb4nrtn/L5e1dDTV6coTpZzspFVN6d5Js+vePU=;
 b=BRTumWY33Bf7rtIH+EzZTMujVUXIrJBHyJjcWoLjM/mS73k8saxG5pdmBDJ/3Twf4xpov7yWh2JUH8J6s3clLVFV0JJ6wF/wrtzI4oey6uCB3OWB8OeY4dgDDmyxKQlZUhbJqIWsSGPVrsOkSjBjnQ38LKsR9MBCEjqVv0MG8zg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH8PR04MB993911.namprd04.prod.outlook.com (2603:10b6:610:2ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:18 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:17 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 16/25] btrfs: zoned: don't account superblock zones as available data space
Date: Wed, 21 Oct 2026 15:41:15 +0200
Message-ID: <20261021134124.2338902-17-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
References: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH8PR04MB993911:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ec89db9-4a52-4027-7ca8-08df2f791ab5
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|376014|10070799003|23010399003|1800799024|22082099003|18002099003|10067099003|260925021311599003|260925021911599003|260925022911599003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 eTw73kKCXFRsBK19cXGwNr6SJvMRBkRVwsDDmV4afotNOtgvHg52e5chAVuAEGBQU2cZXy82FUyq2IEJekuOeh9xEUOWStg1y+9BxwB0W9c0/o74SToNSH6IYiSBT4XFa8gohfPI1NDwJHI0rt6pQK/l8eDG2FrfRb+2iq+c5ZRYwnH65v38SEwoStPwSJaXPNJv8se6EvcQSKNxmy6Sd6k1pAQMwARNYDOohmJXQ7xNgFaH5XPmLJ9KhSpYSOXbWgcBWg1FIbhSbENcrSKTA8Xq+U+PavhAoKkcrpEuqs5SkLIJpfBV+IdURxc5+uqwYnH/zXgxci9bRo21mM9GIhbLH7t56iXzu6JDMN0ht2ZjI1HTI3i9y6ZjmJPjhH7b/Cb7XCqt9UREhh6F1nS1Ru9ktuGlGp2oj8f46Biy4RINc6Nr7ZsvoT9KEeHlvR0wxeFMNga01WJfX/pth2BbwrbL/Bo50CbjZuiPDBjCIx7T25dMdCIOBzGzdA0A8S6fL5epVWHMorh9YLPIbE1D2oRD8fCnIbIgDghfZihuV+xZzRQ/NYeI/ksolHu5ebjfOvUCNpT2yS1zmGKzw/2hyFZi9BzOIbP7oqYE3K8LXYGb5g4dj6pjLaHHvrDdJJGoYs0uNtoZU330BGsJcIvuj/aPO9hPEkVdEfgnZCB2OuA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(10070799003)(23010399003)(1800799024)(22082099003)(18002099003)(10067099003)(260925021311599003)(260925021911599003)(260925022911599003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?D6opAvrrTVuIMq1d5Zja+8isXoyUb4FLCkc4trMKSWYvu5pJ/lciriimevQX?=
 =?us-ascii?Q?EdMKbvrRfRSQscp4zlf5arVmkM47FbHaCTbCUGJAp6NNpG84xwtbV35TCbrl?=
 =?us-ascii?Q?r05zxa84t4xbpaYVkjr1phzgOncirp8YSEN3WrFAomGjae/wIAkCrmAjyXSC?=
 =?us-ascii?Q?oJ54BI5KxNRQGrkylCdoHbQEMMLXJaQw+kYFZpvOlXLntxahOI5iwsBfxjau?=
 =?us-ascii?Q?nfyN4lQsWTj6Hhqs2LZYAJRgfBNKCCd3KHW9NImsxSTGYyoS3yxzO13KVJnY?=
 =?us-ascii?Q?T5kyH0ExmuJCSv+f72xueZx099fRZtr4aK4X7zX8RXGh0CiaHy33TBFfU0vS?=
 =?us-ascii?Q?66wcRqxZapT+U/Rb4P/H4R5p0RWqhIW1zuBdi9ZMylrKIgZkaX4ywcdyPV7K?=
 =?us-ascii?Q?nI0mi+njPegnX+iYUUi6l6+mRsEND3V07NW6+Il/CjRA5hynWRoopUrKJRXv?=
 =?us-ascii?Q?EvKJ8ArQJGxo+q1dT0zUwmQgnosyAOs5BW+WfnWPlQvq5MePXBlJo8KIlsSP?=
 =?us-ascii?Q?0QZSq7MchAL+gowLeu6jmEc7KP13Yt1BwnMhxLRN8O2HUCsLgNJaK075RLlj?=
 =?us-ascii?Q?R2EerarkVn3fy4JYp9iIWLOR0stPCIUjy+jc1FZgxzb41a9miMrOWYGpp8e/?=
 =?us-ascii?Q?fAyIOPqhP2XVsgBGiAUHi5QM9ks6h6r8lcdR6npQruiXGReSJXGGrqupA8Mm?=
 =?us-ascii?Q?uGHt73cNqRwa2rA153HNP4biNuUAfJCyA8ZGeE9X9CcFvdq0cTGUoS2DAaM/?=
 =?us-ascii?Q?IM6ZR/foLoHJV0qgf54DbtFO3KUzqH1fSAevo5HuU/arbo6O9KbbDX/GMXBp?=
 =?us-ascii?Q?I/sWDPW39O/H8n80jPwOdAUoKs8NNs5+OO6ll6W0lAeum3Up6PNtAqz5GYjB?=
 =?us-ascii?Q?xnYKg3zV+kWeTj79fvMxIcNXUTyxbI3uKQoRGFXoryXCs/apQ6Mftu2iQkhr?=
 =?us-ascii?Q?dAuNGSg/uChD/7zrZiixFhyfALKoefnV1fuDEdVj3UnYJvOjzA4fcNW/ayzI?=
 =?us-ascii?Q?YJduTvsCRU+UzUxvNgclE1y4qxPEWSGBE9psF/cLyfmMFBhYCsSwBQMBJrry?=
 =?us-ascii?Q?hWdR26JaUSQ0lx6EPa1jK7c7HXDk62/YLBp1Ck95Fe9XSYvCHhUomYlufxzY?=
 =?us-ascii?Q?nvWBAK6DB+/6vHViQSA0aWTn54IpLMZliqg8g4Lkykd+TGkOJyZXGZPHoYuz?=
 =?us-ascii?Q?A4PSaMnGU3QNNm2xycWDiGQqjIgxww8BLt1hFmRDTsJE+LzhzFCt2WL03Yxj?=
 =?us-ascii?Q?JBx8Pr9YEwXpudJStt+qR0SnT+z+ujsqSKDJAlL6trx4z34bpnhdClAnPq6Y?=
 =?us-ascii?Q?CXM51Bua8pe7Fx+065hoRjpIcGJs/eMhRolY2zIoLJCD+8sBcEi7UMlVZKpu?=
 =?us-ascii?Q?U+j4SVzepyXO60o1A0+0BGuG2Gm/vZioEkKjTF7UM1xZWeMjitpkgVCe29a7?=
 =?us-ascii?Q?ZO7X1PJnUGySv9wXPpjJNTsP+uLEbwj2ieadxY+lmid1ypKjjx4FdK1KQc4j?=
 =?us-ascii?Q?unMO9dn+S/9YurNAhxx7UwP9LkLimtGcGfEt3nxB2A6cx8+OqwJWxgtrBibo?=
 =?us-ascii?Q?X6oiiGM4PyvYGIhJ672/Vd0Dw2dSk80eEWnc1LduNU4iqgbd99PrFx8USl1M?=
 =?us-ascii?Q?47iaZkoCqjeh3sNI1qMmJtxjv4exUb0Yy0lQEuwePp7HLU+dHf5lqTSe/8K+?=
 =?us-ascii?Q?yO1Wb/cGf6Pnwh2QPIA9CjqpKGIhoZ6LrpO9Yfv2L7/GzYDGGtpd8sywiItK?=
 =?us-ascii?Q?FbBlm88MkmovbmfZJ4cpd36cwW8GlrRtFJLevDkNAuxyMUFM33mjwAHGnlnf?=
X-MS-Exchange-AntiSpam-MessageData-1: gVLx2B+VPsDrlOAnSQNI9wOeMT3DhaABfLQ=
X-Exchange-RoutingPolicyChecked:
	LNkmvvxVgnLpRYEIUQahr0LRIOobGLZOHkTEwzGE3ExqWyB+DEzZoVlgfLKBqkTRGJUZGgEwehodahXUhkrS1hSeRB+5z0GYPWuavcGSSf7Zld2cETl1eaIC9AZnM6+8BwVlEYGDVnEPmghHyVBt5Eg8IO8QDqb6mU/tgkB5qCfcy6Turl2euwSCg2svvuvtCDAM/Dhcbq6UQKAwKFiWF7UqtuJZTf2CawiBLBI9F2+jQA42/fsxiMDYUSvFGlSpX42yZFt0HMP5GBocANn+zwJDcponeZYVNOnG0oxcjaRy5qEq00F9UahEOp31c7UbslMCjrPuZK1rgw0oop5SXQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0CteoJVN/xuCHpOiWTFH9udiunMa/L5O43BOO+nFICj3LVR2IOGdNNRZuRm1ew7ibQctj5oHc1QCspSq7gPpniRnBsRN3Wa6xu8J6I0Xe8DXP4c67PyVHz8o7/sv7xbLatav55WYIaxb+BPPR9IMhu9n+seSrGl9cSTNWkIz7JBKAjvJksTWowwzeXP8+I0hbvlRkYvBWEstYRjz1Q7tv0OmDVGOT1DYm+W3QCBI/s6GTNfHmdgwjlUSCqAXyDmRfu3ioqAzenev+yIrIS/qSYArdAtjw4NAkmtW0252IbPu4jKajS7lFy9JsluXa604wXxkIvqq7BPxv9RZo7TGgknRw2UChNh1nldm3yQgBH891ITGPy7Qx2PBuz1VmCut45zgzHbasaHp3EnKJeMaQR2KFjLolbPY3GTiUKjb40ZLUVoPE/P4Q73CrOGkmeVvqqv5wD/dxYyBnmHYy61xSzVVLDoYCK/toUqJXA/Q4xsbcHDmt48+GUxXKlO41hLh2XrMX3npbbrXv64c8G1uM6B8Fz9IOu7OO7ZMZSDU/d18bRNuEU/4cSzafAL/FGitrtOCtaavzpDmMuzPdH0Afe9J4x7zeqfZq1IgoTHYbD9UqiCP643TGAfZpQAFMRjO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec89db9-4a52-4027-7ca8-08df2f791ab5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:09.6343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMFaCaNZhKTaZRx1f2nKCFpQKgxS9Jh/I9UCx4jy9ZUtfFQSxFJXO8+zh+f0ahbQ50MB48z+z3hbitDpzThnXJc53/1IvGALsFPmcyAvQZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR04MB993911

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
index 728ad2df376c..ade2d0adfe25 100644
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

