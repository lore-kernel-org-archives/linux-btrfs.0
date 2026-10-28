Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211707;
	b=hEYe3gt1E4bK3BsMkK05lGEt2kXuMLHznMLow3GwEMhzpp8U2Q4C2QkAXfkqGxnKgenM
	 Nj/qqZ+PXotC20pS9UyGrUezSFUGIHixRN2VPgQVGz2vxcqMslUs6cHt1i59dYiu8mXGt
	 8yWMm1X+NuNLiJbwKL9LGTaCqGsWKDsIY0JPo9HyLCpr89YEBSV1dXlMpvbAqIFW8QUVO
	 vTiDbyWsy6c2aCmiWEBZ4b7mtAl8baA/wHcY2u+PsAqTKMtgTH4vmBu2HsQYY8hD92tzn
	 eB97lgEBXmHAtXThesvTV9MVhSKJEj/ugSJnO2bjvTeWE0SVD1vBajuAaUt5/rTzXNg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211707;
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
	bh=rxAm+N4PrdoaMXJF3zAEunna7x4XxfKAaA95Hj0EBYw=;
	b=UBfqFM9H9vbP24W5XRiGkEOY6uEtKKHzwPccsoL4P5dfa5p+JSdYHN0OQWDC5bSuT9Pj
	 SWmeQhhpLRdgx2yMVdZjiXn1XXP7nSgzfQtUU6wX6ncggNCTwPAm+PgQH+SLXHo0ThZ1o
	 uFuuzSq4C/oGOvH6Lh5xJjpJYxItE07CXWAkT7V0cbqyIM+emsSOk1ffuw2EkdOKCP9a9
	 QcYUjcaeu437D1xBBtDyvw3IdUMGwwy53i2kwgLREPiU6A7lQptwmyyrX+rhdA1b8Dn7/
	 KKu+Lo1I24wEnjho0nokd10iML3iu4gzF6HtLv5X/IUxqitwrYQVWdFraQyZYTdD0kw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=F8KH06HB;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CKOl2DNI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDB9606A33B
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FDB9606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=F8KH06HB;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CKOl2DNI
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211707; x=1824747707;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=LkOlxFVHdjuFt0PO30HbLL7YaxB2wpwsnjRSclCD4Ug=;
  b=F8KH06HBiMcKKfP2roGUj5kyeuOeZbrk31WHYAhNwW1GNKsQ41oWD2cR
   R4jrGDAtNLLDuw54CFjU8I8HkxP781wV1M2hAQu1veBMVEQoBfqc1zsxy
   Jgizq4OlluXx8ivBx5TCYah4hdC6a9+uZT7419WHYSREAVKarNTCGnbIU
   QTp3ZvpUV1tfqDbVwoJCTK2r5KOswGzFE0WWF6V6Zf4sMePbYtJExf84l
   +D59OTrmk5w6qWtSlN9D9HXfDcP2tcwOCYMAdOVqFqNPrwwzvckQ5aIop
   IjXs3lIeM1oXAHAQzJx541nK9eCYNAT5Snu9FgLXEgzTsujKocbJ87FaO
   w==;
X-CSE-ConnectionGUID: 1zGCmq4JSjKQB5gJcpGUoQ==
X-CSE-MsgGUID: iqA5B0KPRO+TJl/8/KxUrw==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="160194171"
Received: from mail-eastus2azon11010059.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z5/Sf+j64vU4Y+WP986uulgH2jRAuZs8+37QUlPP0CcO0FsUzpjGDjx4F4TC8kKp+huc8SE93nVz4cVJzdRDJr85zqQGa9vq91+I/PvnpkKyvaoK2rdbGOth+wzvrgXFpeIlu8R++y161SmCMUkRivAtCAC/z5yuWFVuqz6w86NZB1Eq9gvHKfBy3/iJZNEwN7B4bLbVVIAmFlxZ63NZXtPApZBg/U12s8w3wRZu9R/ClHGfT/SEKa0SoScjx5vr1WVMYZIJC9u0KDIwYcrc+RWIaNKJiUilf47IgpQOM++rBla9CTz3mYOhDi5yi3U7ABsKFt9gfvzo2H+k0tuzxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxAm+N4PrdoaMXJF3zAEunna7x4XxfKAaA95Hj0EBYw=;
 b=CkPw2+3CdvpWKdodD5/BMMSHQQC2TRwGke7Xpfxz4Tza0JhhWD7pWR7iJrG+D4mJgwrTOV5Lis3yUMRP2F2ieHGvQeqf59WwO/dE7BG7SvS0C3DF89ZxGLN6wgDRFMMZgOCaui8lfkUEZR8PnmdMjx56dZfhkSN7C8p8Ione8VVWC/6gZyv44kkUQh0WwCCtVTX+1fbWBMD/Ucx68TYHqtjZMQWKLUXvF1/ppjHMhMpqJUr5+N4jGtmIx2w3425IKdrlM/HbIm9MNFz5Tx9eajnkR+gPSQBGQDh12eGNkvlDR285830UUINxZosh9TofYh2vq2RFCdBYwDpMVefAFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxAm+N4PrdoaMXJF3zAEunna7x4XxfKAaA95Hj0EBYw=;
 b=CKOl2DNIs8qtcMPme6W7T9S+moWZpWV1yWmnuUasuP2DRVhsJVnxbOBXqc5nfoY898V+uZujQQ0dm0dJW2umaK8cx3SaR52kYs9eg8cpN/+adFuNxe6RS1Z+00PSR1ytPc5v1erKA2QCF58mebKCEz1WDOhf9PQ+xnnPBTjCaxM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:43 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:43 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 11/25] btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
Date: Wed, 28 Oct 2026 19:20:57 +0100
Message-ID: <20261028182111.160492-12-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: 39bfa641-0bf0-42bb-e271-08df3520505a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|260925021311599003|260925021911599003|260925022911599003|11063799006|56012099006|261009223027099003|261021121427099003|10067099003|261021123027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	xR9/zV58dCcSe1psZoILXYAVjUACy4hc67+huOyaFyiZTmhMF0xHjRQd9rDGmPDsiA0VDrEG+pK2rtvfUIEPDxpwT2yYBShMSoqMm0RzAnYBn7vwCG8AEJOao36GaoQToG+vTsp8+yTTJM4Niathgbh8CUhoE6dggH2KrxjzN+BV+VoD7s+mI2RuWWlmQsjY4CmkwdVURHfGZDaQa8dfOWAgbdZONimIuDUXcp3MNb6VC+cBJJeNZnWT+ysdIA2giKB8KUmPU9urZkE4lZHXY9+9Jv/2f6IW6RdOHweqKadJJWxbc6R9vWkrKc3K4/BwVFSxdr7tIZQnfY0hJC6YTHy5InZmOZuSXdtc5X4Yc+1a3N0mqWHAdbr8e6VUgNIqRTHe7JiQQ31szvS79r1mKjK9eTMec82/sFUXDECtCuHv7Cg/3au+cfyqy+IRPNn/VorqKAG4nI6CdJDLNj+CwVv6E4Si+4TgqtG6ExEZXmgjqdTABIY71OXWPcEKF1nIuHC/WMcN18eFqD3vL5BBM4io9Pz87zvfruWrGcMaKmxoasC6vAJB3yCne3PE5ey/3hHI5z//IAznc7Bb7Yg398iI7wsrngxG5rQLebnBP2aDuxPsOiX6E6624YrHg3mhGxYZohPh06yo70cPaEIfrpokoOZqfwgMuMNR/0L+s/o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(260925021311599003)(260925021911599003)(260925022911599003)(11063799006)(56012099006)(261009223027099003)(261021121427099003)(10067099003)(261021123027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mTH0eIEzh3kvazTdEbtrPOCyQHT7c6NURq8uh6KROPwxr00NLM5h0jkujGE1?=
 =?us-ascii?Q?HSDdn60lsU97wBICGGyKCAG2yCCJqFbabJUyt6cBYhut1y6veEgGTyBCmaKQ?=
 =?us-ascii?Q?8Fg5rfmExQ0DRnDMTTkDYH19HZtva+FAlVZ2+nTCgQQQtnFHkU/3KATXCKEB?=
 =?us-ascii?Q?ZQJz9V+gmeEQQIdbtbTVN6AnzV5PYRnNwsOZ43gGuqvkfFwyU04k20hLg/Pb?=
 =?us-ascii?Q?ElGG1n69Z0taZvH4n3bRQ/yXMNZ5gvk7cpEIrxBgAvU4rUGDL5peixW2yeJs?=
 =?us-ascii?Q?kPx6ECRpxEADcUMbCx52nQmwjkIKx3HvybvqX4+m2C6A2ZrAKaY7FJwIG59C?=
 =?us-ascii?Q?Ma89y+0Py+CuURKQ+/TLlF5uJvXXpzrzMrHD81SKllgJtyUUvxIok/vZm9Mw?=
 =?us-ascii?Q?YKcXz+mhwyadpaBuQs7Q0cp4M4EUQ5WH2oODDse3M3kH/UcT/iA6LrAAIs/n?=
 =?us-ascii?Q?GEH5z3kpNuBxcu7q5+hZ70ToG7KeotrBIIBsCQsX0aek11b/YGTMQwsFW/nB?=
 =?us-ascii?Q?pLZxhkVd8fnE+kP/2YMYpNuBSJACLdp4sj3kfIXFjQBmQPbXzBwVjQAJuDdZ?=
 =?us-ascii?Q?KjjCjqNzlK6+1mrfoUS6kUiuXKX6iwUsbHm2a8ln2/7o6WOu3D6MQUoJ6lSB?=
 =?us-ascii?Q?YvxYsH1eInqw577jI9EeFiky6kfvC0hTv3Z4GOEZUM3XN950JFnhC0YGH63q?=
 =?us-ascii?Q?cMd8Qcl0bcFDxGGykvVfm62XtB7Q2erTv9RhT7ngldc87M3D2jCd3OSa11Se?=
 =?us-ascii?Q?g9MhLlzWd7MwWYV0yJBqwzXFufXq1g6+tkqt04cU7tvJ+XkVkvIQ/0iG24VU?=
 =?us-ascii?Q?nMABKfHini43jE0eRMs7Bm+r27nnS5I8IkM8f+PIMbPwbGsl1PuWJXaXDvaF?=
 =?us-ascii?Q?JuvGmedO+J4BIiNU4itkPGtu5WUgtQJ2lbcGGQP1GELNq9NFisrjD6tCDEvt?=
 =?us-ascii?Q?aXcpBfPzeeCkS+mFpZfhRDn4vjCwcPCCQglyTlyocjrczjtyW0HCDX4v4Kvi?=
 =?us-ascii?Q?TnAiQjMXdr88l2AOMSk7NC0bCvd8qBkXCeP1m/SjnPeBwgrv595PPstPhkl+?=
 =?us-ascii?Q?pZahu4EVi+KoEz9yYnc/YJDSYuvMpaP78mogCUi7wLMZT22+zr5yHDFB2PYo?=
 =?us-ascii?Q?Zr1kEyJ5YV/L4LCHC8ORbkalqUoFxm8vM6+7E4uG0vEQNkCM4L5kU0osEVLp?=
 =?us-ascii?Q?8Y1b1y5y6/W8cU8zCjSFH2m4lVBgjgzKFWfOS+A2P2JWO0jG22uDmofI4LK0?=
 =?us-ascii?Q?inw4NiH3UvPG5X5SAMdnypQAKrWMLNtnsgdYrU11scq5SRiY9i1cVdSLrrxK?=
 =?us-ascii?Q?ghLdwh+zxBpigpqXIYYbSLJzQAwGxbvKSKjtw+IVNvMF6pacee9q/nQ++T08?=
 =?us-ascii?Q?eYfmaeTQ44uKdYNmpv/ZliGSpyyn07K5Eu1PT2KH/rbLvtVJs3B3Gdo/NjPO?=
 =?us-ascii?Q?1HkyBBtmxmNbb6Srv3iUTBYsZIQkiHPLLoNbFP7eODTX9gkPO7h5PzR7vMVC?=
 =?us-ascii?Q?NA2pAU6PurOiyepFLeY/MoKKeZl2h1KByf920cKLA9Y3BscwpOPFmBogauo4?=
 =?us-ascii?Q?PHYjvrzWN/yluQnV6FMeYIHFNKpuixlZAafaoU3Kug6bFKw5rnrU5iaoiSz3?=
 =?us-ascii?Q?KgA2JNwAi/FSHnrvIEtgD91Kh1njzl0lbRX7C0bEREy8LAK03/kQTDjYpJQB?=
 =?us-ascii?Q?hG19yk5attxj8imdAXdf5YfMcGYtIDrvReQlfjelFXx7gwqd/ra1voRxWxVy?=
 =?us-ascii?Q?0pYjLGFI/Ec+C8GKAEaSTKa+7tsWaGwTF5fQs/N34+eeT9sgVIKTJb3i6l3g?=
X-MS-Exchange-AntiSpam-MessageData-1: YeMVIVVCBaRkjpu1LHqZGKfJckBWpUF2gdo=
X-Exchange-RoutingPolicyChecked:
	5XdRM/1P9caFq+2ZVCPWYvMXElzUX+9WFF88CxCJmS9sGPXYXkc3SuKDANquKRB0rE/X7Nq2jvtS9LuoEtca6iME/Dfu1Y8UD6vKSepVhZ15WgdXx5Dod83b7pH1EtKJivLASkUSwvlKkAXlpf05Tk4jEScLIqs8ES6Hg+oXuuKs3djBDvs21M0FwXq/hMqWQXwZwvMgzcg3GaoFa+N0tiUZeJs6vjeppP7EZ0ekKmvnC0BYNPSwTJYl57EXWOiQnMyJD5dVdIHTDdJY7VYxQkH6WkNj62fA7Y6r0s1K3e6DanVRZow/tF6DFLb0AwRlr+Cp7SOkmaZ8n9B2l5OqGg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B1U1RRB0AWGG1MZhgxpVlDol0kz6NqdEpPxGFAKSctt8eo6QKwMXj+QjsWIdwm1Tu46wqbpQnxuMTrue7MVYwS3xMYDq6NkQQRJpv0I59cNP1h4KfldaNq3jj4ziCQNWB/4t0EedyKzHP7Lu5FZMURR26kQ2FRHNZr/FGxXMQy/OynSaQRxUqKPUDfw8hVFD2zoz72xlwCjRoDKe66TADde5oyv75lQwx5LLqWR7LSCtiWfgbCGNxapmQRkR4FkEzUOfkPz52mWzgxqw/bzvdjolW8K9wZyyhPeHL1wTejod2EB8k0UExT9dMBLsePssWzlSlbBQxWi4FtmMW8LDiMiPQuvbJHbv/gx6gv/C/DwpmMkWVYq/tDdk6DpLeK3ysCKTEHPQy+DMaqUGC2vMsmAmD00Q1SLHREiXQCI8WWd90ZGy0HTZHRgor9NfQg7PkI94nJgu71lzVMqGnjPvv3z79ZvWZIErcDcmHwB0/2oM9lPl0N6kjNK1dUYD2y0iriDcpjgxcrGiwxqBhuHGxizDxHgIydXHWPLLUcRuB6IZwk5W6bsW6k7ceoBjOHBgYgbXc4HUZpiZyVhCbW043ApZZxkttmSXLZpLs/kPZ0KD2JZDuswIOB5QyXoOfHdC
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39bfa641-0bf0-42bb-e271-08df3520505a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:41.5930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZVqFKTU4yZE+WuWZTS4Uc69c76jQa2C/8hRQ+DsGfB59MWM01SNY+gLriPIkqhl4gNVgsymvKCugkpG5SCmctot4DJph008Y+QQ6bdHUvNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

Now that all users of btrfs_zoned_meta_io_lock() and
btrfs_zoned_meta_io_unlock() are gone, also remove the functions.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index e99786b29587..0e4657347928 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -431,20 +431,6 @@ static inline bool btrfs_can_zone_reset(struct btrfs_device *device,
 	return true;
 }
 
-static inline void btrfs_zoned_meta_io_lock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_lock(&fs_info->zoned_meta_io_lock);
-}
-
-static inline void btrfs_zoned_meta_io_unlock(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_is_zoned(fs_info))
-		return;
-	mutex_unlock(&fs_info->zoned_meta_io_lock);
-}
-
 static inline void btrfs_clear_treelog_bg(struct btrfs_block_group *bg)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
-- 
2.56.0

