Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795791983;
	b=BlSmIjy7qERE0nkYCejq5kI2oLbRpMCYyODeIF4tLkgGqFqOecMZh/0qcY5rcQRXYkkV
	 HWiwsM3qzfIKDtsAHc+AhpAU5l4eO3+cxGTelgJ84mwjTaLyRRs8+FXjTEwVlnxLSDsrn
	 TKhLNqmcSCN86tZVdUPga027G/WvCPuDZlqKPWeg8md4CVKNiRV3WExQOLO41SxooRbJ8
	 UFdS2uzn806EvSHcZJRpsVXZo/R/WG4iU2HLR8bPPuWq4M3pXLQ8JOXgPJPtOJK5Inz+b
	 CrBbRp/A05FunMXzX7kIYD76cCZxjgQRiz/kUqz6G7DJorCh0QsOzNyoud6nv6CT2lA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791983;
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
	bh=WPk62yPfBDxoalgjMOCgWVU2Ji27F73J702UQRfX8tk=;
	b=XBQEhfRw/z2fJiN4ABkO6gnVO8vyPRpUtXQOYuQ8KG8OXgkENVrKH2il6M6yKXBMFoiN
	 BSRYzjjyxBwS6IlRgeQCPC8xpgfJq4aNsH5wlftLDZ0xmFfvnPNH3TstTn1aVHNeg9+4F
	 ldnRQXAQh2kWMrnf2EQTVQdlyGPPtnGiEl6ewhEAyKWpZhhB2Jj7tfnr957nVUe6KkUAi
	 DU9Rn5N9PmJVhrMMaDkiFCGK6P8K5Gwt9Bn8D1mZvJgQ8riGxq/Q/nyQ4V1Va1ZyqOpMi
	 w9WLIcRbSRrT8R6IMbpKyCToBM9PbzKTotEsP+wMk3wuPH+FjhJ7IXurKwJIZvbuQfw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=DoU7omIX;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=G+gBmMph;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01446606A331
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 15:06:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01446606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=DoU7omIX;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=G+gBmMph
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795791983; x=1827327983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=2WIzGp6h7R28kKzeN4qJnLUBoTTT09Sd5146kgolTho=;
  b=DoU7omIXvpcn+PZKn06hZmb84g66PbxwGAjcgE7ISg5P+5OaXsa7CY0R
   IeUUW+r2d7c8C2XFxVMxOKt/DJDlDjBGzgN7et8Aeg7+UoiHSLb8jRYsW
   naL9f/c5/JPMh5LC3rxTbbS18Eehhrty6ZqqrzgbCvCACJi4GsPBrhPzv
   BEGaCCcR7D4TI4VGxoWf6kSEXCbjUybzkZgQtU7obzJc6RQKyi//B6wF0
   vO0zgISgGbSjI+Vi/lFzmrY8XB/h3QHYBDa3AcRXLhwNbVcjM4zCHemjW
   niZEej6Y1kT+YSFEk+81HZaLxRk7Gu0SWWTpzpWhqWhbhcPEYXbaKAbJO
   w==;
X-CSE-ConnectionGUID: 1i4jLzKOQQiffd83krb4ug==
X-CSE-MsgGUID: SCCHWd2USPOlO9temQ9pWg==
X-IronPort-AV: E=Sophos;i="6.27,237,1786982400"; 
   d="scan'208";a="160943172"
Received: from mail-westus2azon11010021.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.21])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Nov 2026 23:06:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hjpcMvrZ3aPR0n+gp9TMg9B6mCywQPfEOgl7cKBVeJuiPx6EGNoYA+yp68RQkSTGeMqtu8b1tZcc7YFOp3W1pLSEjdsogA7G1RDFS4aWfWV30WDAS7CeELxWt/n/aPPQeJMM8DBYiFvAVcVKehNUFbcLfHGF/vTKLlji5PKMLqHY7tMjf3O+kzUG8tRZAJFtyn88edcP0K3ExXELkV8ggJ+5DAAzZwHoEWzXfFW6t2A4J9RjlDGNpNH3F3KR+sBrbVTAm4VlqZFxEFgJ2IjLTxdrTPXuOWKRcqdcu3shwmxShPB3zICNrN90xkXTKmdOa7MGNJ7jcL5ZlUUDR3VHZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WPk62yPfBDxoalgjMOCgWVU2Ji27F73J702UQRfX8tk=;
 b=d3HRaS7PSYLLWb3qVmItnhVIYefLE20ZM/I/0X+yESopNXJx+JTk/xk8lMyVszWDAQK7C6bL9TuQRqMzuwAFOz299fWJC5GG8HZz3tgCY+OvyTZNTBaS2ETf4x7CrRQBWCEey+QxQxUfud0EnQYN/7Bk5OPBSYn+ElpZtc/ZkezKem+vjv01rFluz1edJlrWc4Q+8EB/uZhGkRHj+b1dfbU1l4ptWnL2/ShyvKcG3J408kWl7VTWcTbGGFu934e4rpvf9CSS7r9UIfWRv/51tEm/wbQLxTU2zqfYO8W3E5KMeUxdVxAHgf68j3uW7ORvdGnV/0cneZUQ3S2/hg5L6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPk62yPfBDxoalgjMOCgWVU2Ji27F73J702UQRfX8tk=;
 b=G+gBmMph9XlZhuBJ2HzX5OFK9OHIS6hQOV+oz/WliUiJNz2XxHI5fnOaBfNjwk5zx7BULUEhgOCO8q+UtOPtdtPYK1iaGBx7K5LdkUyKPwh+Dj8uXr1qEYHh9K1YNkrtqPJGbwIChJV5z/r6i5EI39nfrK1+Ekq5ca5nqStBVWk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB7960.namprd04.prod.outlook.com (2603:10b6:8:6::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.10; Fri, 27 Nov 2026 15:06:18 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 15:06:18 +0000
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
Subject: [PATCH v2 1/5] btrfs: zoned: search for hinted block-group in prepare_allocation_zoned
Date: Fri, 27 Nov 2026 16:05:57 +0100
Message-ID: <20261127150601.803290-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127150601.803290-1-johannes.thumshirn@wdc.com>
References: <20261127150601.803290-1-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: ecab0711-a35f-4672-b9d0-08df4c97fd68
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|23010399003|19092799006|10067099003|56012099006|261026140227099003|261026121527099003|261022105027099003|261021123027099003|261021135927099003|261021121427099003|261028144727099003|261102123227099003|261009223027099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
 AZHpuqWfkNGLErh783MKZ1te1AdzL22q6fdRBP9oscatEoVobQIvOFecUx9zQI9csvKN+50G188FW6Fp8Jqzum+tyHEYi6xmNF93ARABu1vNKOQDHdVYAVIDriVIJUy1NN515bvd0gEfqa3rmHoH3P9UiOMino2ycTOVzKIgc1sP8wJwIEtrBWlG+YPbsWzesOqEwEHUiyI1wP3Zs2hdAn/UKq9/O8ZwIgJoBH54g6HOl2RzVgfzc1w+7b038xnVaJ0yZyiRUS+NVJM0qOVyN1RjNzSSaMNBnduj3BDB9RpNwB3Z5l6azWbMEFGkwdrBejllNV3vhafwe2rq3rd+T9oA+wO6K1gbzaWtKXTF64WGoBsxwr53Vj05szVvEVTo/FLRyhf3ceo11u/fTPFjWMMDpnTBlXZrNasPLfwMbHQ+2POBLAri1PpFSjzu5dxtb3wHHbTZ2uDBW3PKKtaPCaTH0+GqB6vfqzeK7++KXguG0HxgqgKwQCFno468QIt7X3gKRLk4aVXCLUzEvQGRGAmbfaZBtVA7WTSAdp2MdoQehEot3nLZfcvTPItIc81YnJxnPGfsiyCL+LpOFJDtwS4xZ0ceooUXEdjmtzKoTpat3OIWu9rBcxpuwcvvqkefZaEJKEnhWKuLpsS5cEZnDyR8NShi04UYvxCRDDRf4uI=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(23010399003)(19092799006)(10067099003)(56012099006)(261026140227099003)(261026121527099003)(261022105027099003)(261021123027099003)(261021135927099003)(261021121427099003)(261028144727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?l8i0FstWLK0tyUdtVoQm7ZiJz7hYtiLHv6LzXph2b/CKWeQBsGthGNJVJPtd?=
 =?us-ascii?Q?rIk19wBKxC5y1riFkj8KHNUS4A9PUDu9oOt/YOoggzgHKXZqBEgKEEqrfueJ?=
 =?us-ascii?Q?HRxCaQj5H2Irr3jsVNxP42TOLBBX4Jm9DWsgW6EfC3bFi7vjWvXhSJ0/9/MD?=
 =?us-ascii?Q?SIPuI3ayXYTi/alS77IkzSxwO9lhcJGRJsjC0q7VXxFJZOHDEsp+K52p1Jeo?=
 =?us-ascii?Q?ClKQUxtSkP3JaLyweAplwhbOHq5th37gCbTdjEDjO+YYz5tAPZ5Pj6RNNoFH?=
 =?us-ascii?Q?xw8ijw0+mq8j5IytDV3DLS8noLd6ud8w2WJBYCw2Y5gJgfcqD+QY7xwAalN+?=
 =?us-ascii?Q?Y1mqdWSG4bMSKsrh0eDgljb9dgldqY90ylzxQcFBsAvVyriwSpejrymMxXLr?=
 =?us-ascii?Q?STSeaR/C4BVhTzlnfeWRBAP/tXqQzVzbbiT3YzjZSqr5M/cxJD3WSVm6KkD3?=
 =?us-ascii?Q?0dM0jx2nmfUUAFQyFiJ45SEjJSx8fSKzbW73T30LWMZtxPMxms61n1MA+fyP?=
 =?us-ascii?Q?5hDYj8uGITK54DszPb9v9AV+dGETToreKF/+nQpGDdu6QaVcBuKDs+Ik2/eA?=
 =?us-ascii?Q?Hn939OTVef7+BMKISGqwyZ01JM8JlZfy8OVdhILdR2GPsvngH1OWQ7jwGViz?=
 =?us-ascii?Q?PLRCn+Itb6BmzYSakO7SCmr8sDskB7GKNT2u5MFl/mkrpS7qRWw1Jd2BsbQy?=
 =?us-ascii?Q?6mMQUWaW3KzafSRRl1wRZ5AmQl4iBJWqu+5SBbQY0bt+TqOna+Xh7rotb+wT?=
 =?us-ascii?Q?/wDnSgooSyF9du9OUqOIBWjg1+htC4VoqNuv3WK1/BEY8+AfP0ScdspZ5686?=
 =?us-ascii?Q?xaAmMbvMhQD8agrHHWAzK8VVjtwSVUWS/UaWkd6rz2PQruboAZZVa6wBb/Wz?=
 =?us-ascii?Q?VHtwrLqGXi8bjtvRdvpyMiSmFzPw7gbAiiQUbKpilKomhSYCkk5Aq/DC/pyp?=
 =?us-ascii?Q?kcqcThNPrciPBc2okC7WIrKJqvSIQ6Sm2tBZOPnOC9Oh4LzSCmkc/2MSteLH?=
 =?us-ascii?Q?8big4UQqPPnYFx+GFCEqUAsktUtHOBRAwvLFkhty25diKJms8/shbo3mEO2i?=
 =?us-ascii?Q?kUrAM0EVruUldxQzlJ69XtxoRi4wKmEnuati3n4CclWUcQbPgQJntC7sSRJG?=
 =?us-ascii?Q?Efh9x4KQOTkjWa1pH8tT6nEpg35MGNVK5cicjG1Xhk5cd+SFSQN4fVSQyPWE?=
 =?us-ascii?Q?WbPR7Vpt8757oBpHpKQKoyNOTQnsbi64VTqEVmR83RICr2FfYEPoxPPIIHJo?=
 =?us-ascii?Q?WFnq/qHIzE70/QTn5dMwCqGMX63ZiJqYj/hdO3ATB9jbYOlTRg2087EXXu+g?=
 =?us-ascii?Q?k9yAnDXxFKRzgPzUwpKZUy+R/ysn7+bAGT0LQP6Tluvo5u6MGsSVDmMYlA2u?=
 =?us-ascii?Q?MGZGShgMs8A3fwazPDUbxEzZe8MHCkQA08g6pRKbe2kao1PPUWKsHHnhcyli?=
 =?us-ascii?Q?TxxOK2sbn3LZzKmMF94fRKqVuDdsywmb6YF1RSMQ74jUXOqdKArxncBICNl2?=
 =?us-ascii?Q?dkP/wo+r23wO/BNFJGPFDEHc0I12kngckd/zHcqZb058KJGJNFC200cn2BfG?=
 =?us-ascii?Q?bCQs4Ck/6rbvYFKEWW/6Piz2CStfHg3p6HCtPKvmkp2HaKwTljTTN9Cu4Vrx?=
 =?us-ascii?Q?83o5csgsx7+pzyQvfRNUbzHKoaqu1Ae9D+OFGdPDrMgf2Ai1ruth+TMLBrtU?=
 =?us-ascii?Q?+7F+m4y89gZMJHlP4z5tY0cxhMIsWdf3VzesHX6/1Cu5DBTo8dy6wA61lmDL?=
 =?us-ascii?Q?Ud535YgeZ2Ms9pnOtL3ZrsSLap4t888ajKYk0bFt1xQxi3BDQY6QkojJ6m+5?=
X-MS-Exchange-AntiSpam-MessageData-1: WtcHzF4lUGFZ0gkEGIeMvKYDRqXThVifYT4=
X-Exchange-RoutingPolicyChecked:
	YGQ885z3EO1jyY8Tp0k8ojAkaPAzgljKEWvaaFYICMKYIayy131/ZdgSOdigB1KC38GmVkAAmPBRgFa6jGVdjjwsXXWlFIgU+02iOP1rbJz7UZZiekmhLi7pU9QrQ4kBh8X/+Yh+mfDzs7mqSpuwpfvE8LZFQ9SeMRtI9LMQI6bpH971hACqi7BdsLdHvhcl3AQO83QVX40Mw1cn5ZJrOYaKAFFQnsHClw36GIwdKboR4d7vw7Bnl8bGKA8Q3dgNHFTKcH9ku0HhWLq8QjjdZsegYvCEa/4xgZmnJYb6YFWiooSCI6t19z4V2z8VSkL5RFWgYWwlX6a2/Q+B5AxYww==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XV5gvybS9X7l0xUawklJNfpRJiHgDxUOBWVMv3TFsnODfeqJSYmYApGhMYzJyqtr2NsG3uayk7uPR4Mbda2S9hx66e2H0Sdt+k/TGqWP3WrXvHEtBsskdn0y0Ghv4kfLTyjYsAFES5B9dTjFyCZhrtSjcaeMOqYIHPSZym6gLAIdEEwrQXq1uYUUaFpboFb4NNkJVlgP47M2BciTtNv/BWh2JjKUt1lq5xE+gmU17c/SrYw7zWN+gFfbfrVloXY8pR8b61TYh5m85IsaE/uLIz7VuRalQg+F7Opa8t2lDh9vVE+1alMPMofdGj+bZRanZqDOngc4z3fX1OrYt8DjZQ0/QCM7NIzjfC2pudZ9/Hq78tXbqLvheNmiATeoP0Bc+IIXKeNaLRdwDX76queP5r25jwI5v0HhuPQNxOXLjqRxh3UijIPj1mZ/fgSqBWSJqMyHW0GH/MCobVMzkzHjw4MLpOWS2cp4LUbvNfrMXxISkaHv+kjD+0pZ/FvOXKeK7W0nXciZaLm3hh2a1p9RRi26A0JNP46axluJEDKh1MhaJ3/3N6KJzI3OvB4o34g0uJ8pKR8PRbryLd6bdswGAXYh1cw5Y7R/PKrABgQblsLSzYT6NHF6j+X9ocEezT6f
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecab0711-a35f-4672-b9d0-08df4c97fd68
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 15:06:18.6113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MyZCYi1JSoNef/74D0pK1bY4cQxPh8VZQU85DJxzsSiGRahyjWbAE8mOSvNKKaBG0BszZyGarbUrjnAdNZzV6Nid7WIL/uV09WHJ5jgX0j8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7960

When searching for a block-group to place to allocate data extents from,
honor the hint passed in if the hint falls within the range of an
already active block-group.

If the hint doesn't fall into an active block-group or the hinted
block-group does not have enough available space left, fall back to an
avtive block-group that has enough space left for the allocation.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent-tree.c       | 43 ++++++++++++++++++++++++++++++------
 include/trace/events/btrfs.h | 29 ++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d81b0f8e42a0..ecec52b94065 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4472,7 +4472,8 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
 				    struct find_free_extent_ctl *ffe_ctl,
 				    struct btrfs_space_info *space_info)
 {
-	struct btrfs_block_group *block_group;
+	struct btrfs_block_group *block_group = NULL, *fallback = NULL, *bg;
+	u64 hint = ffe_ctl->hint_byte;
 
 	if (ffe_ctl->for_treelog) {
 		spin_lock(&fs_info->treelog_bg_lock);
@@ -4494,20 +4495,48 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
 		return 0;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
-	list_for_each_entry(block_group, &fs_info->zone_active_bgs, active_bg_list) {
+	list_for_each_entry(bg, &fs_info->zone_active_bgs, active_bg_list) {
 		/*
 		 * No lock is OK here because avail is monotonically
 		 * decreasing, and this is just a hint.
 		 */
-		u64 avail = block_group->zone_capacity - block_group->alloc_offset;
+		u64 avail = bg->zone_capacity - bg->alloc_offset;
 
-		if (block_group_bits(block_group, ffe_ctl->flags) &&
-		    block_group->space_info == space_info &&
-		    avail >= ffe_ctl->num_bytes) {
-			ffe_ctl->hint_byte = block_group->start;
+		if (!block_group_bits(bg, ffe_ctl->flags))
+			continue;
+
+		if (bg->space_info != space_info)
+			continue;
+
+		if (test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
+			     &bg->runtime_flags))
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
+			fallback = bg;
+
+		if (in_range(ffe_ctl->hint_byte, bg->start, bg->length)) {
+			block_group = bg;
 			break;
 		}
 	}
+
+	if (!block_group)
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

