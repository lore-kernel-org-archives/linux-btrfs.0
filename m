Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602631;
	b=mrcZXEPzwWjJIhEUVmquU/Gezqp3bzNX2rTMAPc0rg0pxIPYgIahiUNkLFI6xyNMomHK
	 Wbj0hJ138qhR4SQDZ3CLetSYhAhSNOy8hJaYZMlMGOpQFAwoFgu2Q/Z5bT+gH8BeAOHy7
	 du25ve/ePc9Xzrs9CoVnKRChB6BI/CGxrSq+WeYXiqTEWlLHaj1Iikwa5Pv0Fd6+n7x7K
	 xsgCp4/S2tHxrnXsd9gwm1vVWxhA/CYRGAZ/xC6p6k85Sng1JNVRxwAjcwQKypYbSra6G
	 cddEtI9gaLWvOaWH1YRyRFd6Ce5O/67h6BfZJhD2W5V8YCYBQjJyndLz6YaCEiTZ5TA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602631;
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
	bh=QgqyCSJ4rZ/0G0YllrNsXf1EvXosGIvNPxsUDuefaDY=;
	b=HmoYheqW6My+e1r/W+gKMj8EhCWaYNVQEAjt3SwFTiWQB137G1yzz7992T2/0FMulQri
	 5drg1kbrz9JWo2F/lgLTX3MHeqAFjJS/fZokxEFi80qSreE2i84j8v3ZBUYS/Hy1Y+U80
	 hUxmk04dVBOelVKuFv+WXBInjhnjpDsS1CfxsJIud5MgwmZUbMOSSge03zzYfYf9BQifY
	 naoO3m7GgCnuEKm4wwZpc0ebXHzB5t+o8XVQ/1F291h+beYaytYtSak/sj/h/I8DUmq/F
	 +npJJ7HLa90mZNCsSp7Wfzc4HjFUJlLEcABKn7BkegDbT6Ged/Dt0uj00LI0g65ub9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ejM3gFxM;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YfYikuVO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1DF606A323
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E1DF606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ejM3gFxM;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YfYikuVO
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602631; x=1827138631;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ejVbA+p3DIB/M7EttX+Trq4DDQZrdifqDkSdxZE5yuk=;
  b=ejM3gFxM9VcLJuSquIsCnhcOxeWuWG8i/bghTTSLb1W2Z1JFGJ5rhYsn
   yy+XNclVJaQAs7BNscBnXYiB+tBdhpMNaHzwVrk3DUQQGtUQt3BAdQEUs
   a7Cl+N4u5wscy/pwnRSLCEw9K1T+2MiA1XhAHKnlKKFP/zf5ywRRlt0ld
   +Qx8rO+wRMtd3kzbtfTl589wa3TiWYoAxWMbN19wkwJsBE06EgG2e7qrb
   Zdo4hY+B6PgEK9mMA6f4O9SVJQuoi8rsar5VI66qZUwOULDkheKN1hOxW
   FVNJ9eQ9Ijt45+4LwPstO8llueLo0LuefOExku6SUT31kiwS07jFqX+pG
   Q==;
X-CSE-ConnectionGUID: 2EjXZniPQ5queX9ujzmZjw==
X-CSE-MsgGUID: nvf6gPefSHGtfd5PRSdSmg==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662158"
Received: from mail-westus2azon11012039.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.39])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bknpu9eWrun+gBamAG+WVmwQWxwU+rSruNgfOZcFSn/f0/ZwKxxHD+W/2T/5kBNmgKmS2nIKU+6XhDk1w0wUBbOA0QyDbJs8xH3bVGYtKucvj2xa0B7vFe+0c2RFkTQdfBxR02wdHOF6cebRNdEZDiOEYsMeqTn/XpwUrlUAAPrUNUyLBMGnBmgceH/LgenLJY5h5B/5ZCdGOCAGQ+U6z3Q6ZJwZE7FJ899+QyA0VvNzjCOvD5nlhXRl5J6S7Dws3fJ2ULMdtFM7XwetJ83+0kdFp3DmYP94uPUb6bA/c/Zes2dfeGBcnFa9AJ/q6iBvI/k7fgXZVdnBnyjqBw/huQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QgqyCSJ4rZ/0G0YllrNsXf1EvXosGIvNPxsUDuefaDY=;
 b=JUtoUa1t25jvd7+ES4cKZ6fHg2K02OrTQPkxgyzZ9KOX6xbn223g4MbC28RB0teh9ITWPUVrYlVAnLuz70IKyrcOFcIlkkivPUdbuF5hhrnanI2AAwNlqbw/M5Liv2ANlBG8oBP0pek1NiuRCOp3cnIBkFfWaKR4A+9OL3UPVlSId227C5IKaRW4hd5OzyPKByfC7+A1L6TAFz1Mp9kqz9ik74Fr+Huy8GeSEv3apY2+oUYZI1qgxHX7dNCQjgnZYrwjY8161E1JaFxnCli06/vD2r/pzq9akhsrGoYJb3qFW6DF84Tsz7OIdkeL4DifAkDBxjz4rK1iXEMjkz/JxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgqyCSJ4rZ/0G0YllrNsXf1EvXosGIvNPxsUDuefaDY=;
 b=YfYikuVOuugkCAbSv+y7/G3vuPRlpJi058mAs0MMdjz7K6+EPlqhOZJ6OPAyZPBdFv+jaVfeiZdBwMX2RNHjZ5rImu4cazRmscLW/YZNz8f21lVKpfX70fLToADWyKTUeAIb05tmYLo8pqz2mlXkJtSJQeLXYOUSCzvb/3VtGmw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:29 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:29 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 07/27] btrfs: zoned: use the regular allocator for conventional metadata block groups
Date: Wed, 25 Nov 2026 11:29:36 +0100
Message-ID: <20261125102956.266389-8-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 92a4a4f3-eb6e-4c49-7e78-08df4adf2041
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261022105027099003|261022075727099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	LM6m+xtJr1DrXRu/0hOFj4za8uDWceqfu9d7SzSWFxNiBmHd8q5zkOROzltUNZmOPWQGeQwuSmev2fx/QLKxvRVIFXwoPdonNuBLoqMuL8ETweCp5WRVuzoWmkHPD56oWKTOb8MPO62LCl/SXsCPATQe3bxXbL+zPB6C5myGlOUCPc/1E6ZmiiTe97iSAdyFsWQLOHZ6XbPdog5RFCwT81FNOjvnK/275WkwSIABt4tOsROdItba0tgMVTDkGCAtOAXd8Z/lM6rXp1gUgv5p2h42fRRk18oTncEzP21WKqA64pA0+Yp3Y3SoLtK/JSrUDuiRio/RloNpQPfMAVTHHDW9OBOJv5YJHq0H9eSO1t+BGhuREGrv3guIoUBQPKSXGmf3P4xn6m1/GzgFk6cGK99O+ZvHwsoWhDRR/4q0H1DOe0rcSytXYrQFUjrUMzq6rirElb55LuWiNgdZsSdNV2LIRM4/K4RUqEr+CiNKTGBZCqQTfHobUkOwVBwHkNppQ6kFo0svdM2Aam0HDxYGFwyoVIwl2bXK/zeMhaVcoBCe2nOaehKxATwObM0865J9bfnwwiUOc5l4I1Ix0QcZC/48Ocup5CUWwA6Ud1liKLc86d8L4DW5RaroE+Ax9BpyB/xtk9E8Re2+k2LrJWJApaVdNmgouU1kVLDb7bX69ho=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261022105027099003)(261022075727099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3YNtSRkG6eGXyNolwdpPWSDNKmAyB/cD34sb7P5N/7Hi0/MIKPBXrl2eoGP4?=
 =?us-ascii?Q?jL03Wcnt2sOdtt/N86NHzJBH72TfCH0KqHs1tjSb2EeLHM9gDFRjJ9hsT6Od?=
 =?us-ascii?Q?ET8j+br08aXP5wjN/3ikGnH3a/Q7BQsr+OT4PN987ceqErUKVJDUTG+S4jmX?=
 =?us-ascii?Q?99ETW7s1XrBKudlVpPKzs6/aOz9SmX9PCzNIqE3c6q54l36b0lEFxvlMt9qu?=
 =?us-ascii?Q?nbbX+H/umbpT6LPofKBat69qzCYYLeB7XRKEVirA5+sKYi+QnTEArwdmi+p1?=
 =?us-ascii?Q?eU8jU68Gtxo3oRsvIePwjqTQD8/oLOZlRzcfTgCE2gFyWx2sO2PNJx5DVpGY?=
 =?us-ascii?Q?D47ffnb1teuvpcHznSMbfAe/AJdwkkaezvInjyInBwa8nI7B9xHkjxcF0rRl?=
 =?us-ascii?Q?rWFGrDfPHk7KmOyngkOUFukInegBz5pQFjyq/PcOUZuBjSSU223OxxsUB+YZ?=
 =?us-ascii?Q?ZsbbhxiO8o5/QOxqZHX90+9EGkhSJU6CnKLdc3q06zQ8J41g0mr1oM0EXxcA?=
 =?us-ascii?Q?Mn6wJICaXemv6WKuHeCsW4wMUk9Mm7G0XsE35p8pL/N8JsU7k20LrHlK0tmu?=
 =?us-ascii?Q?tqJ7la2YOwq/g7vO/5ZlAq8u50Y4TQ/grYpNBMArNuyCUzR/IxiTfViuPSzf?=
 =?us-ascii?Q?dEsIf3oBK3by8D65KmsIUkj7XACtDihJT/oUBF6swpIFItdOjf3496EsV2rI?=
 =?us-ascii?Q?5HcI/C+9AkLLdbzbSP4Iqqvg4rz0zSm2qtiqqNtojyHBHOuPVQKBSx/7OvVL?=
 =?us-ascii?Q?hpWj1naaC4dZYeQlK6nlKpbrZmsIx4qHy0cN20Kp6sYaF/N7Yfxi2Nrue6q8?=
 =?us-ascii?Q?39fhAvIEMdRX+GRxhkUw6sFBTGmaotHUlwyMTocZc8GTe2hfJjDc+29LcBs3?=
 =?us-ascii?Q?Rl5K5NV7I6wRT0mlGo4QdyJekmkCuVrL5z6+qSTADZb22NTdWGV6WB1v+qfs?=
 =?us-ascii?Q?NgkP1yynNRkehuU9yLBFmlCKw5rPP1BIWl10Dq92gFcjeiKoCzmgGd1y0PxQ?=
 =?us-ascii?Q?umrE1dAVmuujRaZxZKNvZBXDU0iGnCHzbYLJx5I225Bvx3h86BYngWiz7l05?=
 =?us-ascii?Q?VLnDNq1HauJER6bkLjIQhk0vKUy1WxMETUzbVV4QfITuy7t4TBA9BuLb26wH?=
 =?us-ascii?Q?OkZOQ4yaQCgn8HM8+W85FLJckIZviiuCxn9yY01idBZ9jPdCEQWQ4S2czPb8?=
 =?us-ascii?Q?2mTBmQUjt1ulLEXDCgu0vAFVXW+9q/1ZMcg2Hllt4r3pIHxpiaaYE9mSb/cV?=
 =?us-ascii?Q?qjBYr8GYOhfuRen7CNDOpMiq2PeyI0onF821jUqgtUY90pA6y2dkcfmNSfzI?=
 =?us-ascii?Q?0fTzRpR1XiNPc8Z7pnP5HpMzTtc4+osbylpemntc9iVdTIEm75aetrgCB3ng?=
 =?us-ascii?Q?qZ2uDkRkRsizDRWdFrT3eVRAGwPn8gUj6NT/97MXoQR8Yrj1AnMkRJ9rjjiy?=
 =?us-ascii?Q?DRhcc2N2JLzo4rH7Ee36C7Q0UJZQBCJ+BDdxoVYViEtJlpUV2IPxwK/6z8Fj?=
 =?us-ascii?Q?bIDqQZ+krmQK4Kgi45sH2NgENPHwDTsJI5aY5OhBYn8X6T5GEwY+B7I1ngUz?=
 =?us-ascii?Q?LU7984AQb4nxXZNkOUraTMUthqo0tG7q99cL4CZiOi4qRtfPWRR++70fEfg/?=
 =?us-ascii?Q?BkoFeCFK66L8UuprYBhW0X4D80P8fx4l0QTUXdu1H7rI/9FIevBZ0Xnnz2QA?=
 =?us-ascii?Q?SguSwd+2reCLlFSZSoJuAb8knldYUsT6o2N6AWdo+hwqNeSTG+1JaYxyyGpO?=
 =?us-ascii?Q?jBkAMReGBeCwPyxrvnG2Jf57nUOczzKR8AT+GAuHfgw3DQ1XTD46/0dSJI5i?=
X-MS-Exchange-AntiSpam-MessageData-1: vogIz6oaEhPDHbIsM01a20vwiXR+r7n37Jo=
X-Exchange-RoutingPolicyChecked:
	AVYgHL6U5sj3iyrNkx2tgX8WgqHDzSSpT36viNn6tir8aS9FYt8MySZWgc/MTggikaztkblIbxn+JmpnzniznVDG21VJkAmJOVqfxrliJjW1n9dvW5QGbz04onUecY1YDVKJ4IQ7NWEx+Z5r+/LJCWKHtPOQUnZwrWW95avIhflsFUB+49k5Q7+tGeCwD0smJHPi0vin0ZiF9kve6cpSm/Wx41EislpyoY92vqpSbLFyp0Mae/YopWi1dLcFNMa3xfaeLXEQEg4LzKfRBeq40oaskUCi1aGOqwmMypyJ1eZ4sfeI1m5itucf03cH5NNSm+meu90h4tC7vqbeg37GoA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qD9X4vbG/to26Crsq4N5FnkFiXA/FrpS015jwLKbjyfUmdnoEcFa4grSYiK2tbiLwq7jXiSJH28UoxX/BZS2uYsmcSiPOE9uFOKGN2Cx6QEUjw/mz+ZC5/1hgVvbiRJqvR4Rjnow1zvhqVtnVxHCGxLUZdbOMqpz93hH8p3sBQX95ja1Msg1hFKpxSekJKG/QahwfSKR0SWARGT/rKTkEuiKVg28EkLB/Unld+83+yOHY28COfcqdOe6d4Slk9YVwuVcfdNByJ61Q0gL9ChO7/YYbmQ0X983wp9nZJSfbx5+ukrl888qm7wmHF1p98LZFKI2tOEnMhP0HqBezEbc8TgpU8b2xQv09mGSSGLmC8GPpItbWFodWEJ1UVcocU5J6Ad3ngWTV/PIpmYa92swbtr7/nz1gxujO+DGNNAL5mg0Wv+3pvAqRX2VlVaH9zAExZDgC3lB7fmDbgRJd0q3g88lqVplr6NNm8PFzDz/CRbidrX3QGJohojOqYybmouCopvEz+381aJQUDMFJgnGR2CzGhdRWeWqYNgq+3ZQbtVjBVjbiQsTq6hrZE+DM9ymmDtVXFJyUb2KH74WUVkIRsGnz+fYf3hM31ZSGcerG/SZYEJ2PClqc5WBECIUXQpV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a4a4f3-eb6e-4c49-7e78-08df4adf2041
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:29.1367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hQ1ftjajW/+2FS5aHxzEUuyrjqhcIQwNs5bqrd3UQOuazEgvm3uBTEfUgaIwnntRGbmrzLenH93WeiH9HdFmCIA73hx8Sf0fptjmpkU9e7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

The zoned allocator hands out space strictly sequentially from
block_group::alloc_offset and accounts everything freed below it as
zone_unusable, so freed tree blocks can only be reclaimed by relocating
the whole block group.

A metadata or system block group backed by conventional zones only can
be overwritten in place, so it can use the regular free space cache and
the free space cache based (unclustered) allocator instead, and freed
tree blocks become immediately reusable.

Pick the allocation scheme per block group rather than per filesystem,
replace the filesystem wide zoned tests in the free space tracking, the
space accounting and the extent allocator with a check if the
block-group is append only.

Such block groups no longer need an allocation pointer either, so skip
calculate_alloc_pointer() for them when loading the zone info. As a
consequence they are no longer marked active and put on
fs_info::zone_active_bgs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c      | 16 ++++++++--------
 fs/btrfs/extent-tree.c      | 33 ++++++++++++++++++++++++++-------
 fs/btrfs/free-space-cache.c | 23 ++++++++++++-----------
 fs/btrfs/zoned.c            |  6 ++++++
 4 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 77bc4176cb3e..622b9abbb2d8 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -956,8 +956,8 @@ int btrfs_cache_block_group(struct btrfs_block_group *cache, bool wait)
 	struct btrfs_caching_control *caching_ctl = NULL;
 	int ret = 0;
 
-	/* Allocator for zoned filesystems does not use the cache at all */
-	if (btrfs_is_zoned(fs_info))
+	/* The append only allocator does not use the cache at all */
+	if (btrfs_zoned_bg_is_append_only(cache))
 		return 0;
 
 	/*
@@ -1458,7 +1458,7 @@ static int inc_block_group_ro(struct btrfs_block_group *cache, bool force)
 
 	if (!ret) {
 		sinfo->bytes_readonly += num_bytes;
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes to readonly */
 			sinfo->bytes_readonly += cache->zone_unusable;
 			btrfs_space_info_update_bytes_zone_unusable(sinfo, -cache->zone_unusable);
@@ -2559,8 +2559,8 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	}
 
 	/*
-	 * For zoned filesystem, space after the allocation offset is the only
-	 * free space for a block group. So, we don't need any caching work.
+	 * For an append only block group, space after the allocation offset is
+	 * the only free space. So, we don't need any caching work.
 	 * btrfs_calc_zone_unusable() will set the amount of free space and
 	 * zone_unusable space.
 	 *
@@ -2570,7 +2570,7 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	 * in and be done with it.  This saves us _a_lot_ of time, particularly
 	 * in the full case.
 	 */
-	if (btrfs_is_zoned(info)) {
+	if (btrfs_zoned_bg_is_append_only(cache)) {
 		btrfs_calc_zone_unusable(cache);
 		/* Should not have any excluded extents. Just in case, though. */
 		btrfs_free_excluded_extents(cache);
@@ -3252,7 +3252,7 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group *cache)
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
 	if (!--cache->ro) {
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes back */
 			cache->zone_unusable =
 				(cache->alloc_offset - cache->used - cache->pinned -
@@ -3734,7 +3734,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 
 	if (bg_ro)
 		space_info->bytes_readonly += num_bytes;
-	else if (btrfs_is_zoned(cache->fs_info))
+	else if (btrfs_zoned_bg_is_append_only(cache))
 		btrfs_space_info_update_bytes_zone_unusable(space_info, num_bytes);
 
 	space_info->bytes_reserved -= num_bytes;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 14d3cbd00f24..213331042d08 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2896,7 +2896,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 
 		if (readonly) {
 			space_info->bytes_readonly += len;
-		} else if (btrfs_is_zoned(fs_info)) {
+		} else if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Need reset before reusing in a zoned block group */
 			btrfs_space_info_update_bytes_zone_unusable(space_info, len);
 		} else if (return_free_space) {
@@ -3685,8 +3685,8 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	 * contend with.
 	 */
 
-	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags)
-		     || btrfs_is_zoned(fs_info)) {
+	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags) ||
+	    btrfs_zoned_bg_is_append_only(bg)) {
 		pin_down_extent(trans, bg, buf->start, buf->len, true);
 		btrfs_put_block_group(bg);
 		return 0;
@@ -4037,7 +4037,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	int ret = 0;
 	bool skip = false;
 
-	ASSERT(btrfs_is_zoned(block_group->fs_info));
+	ASSERT(btrfs_zoned_bg_is_append_only(block_group));
 
 	/*
 	 * Do not allow non-tree-log blocks in the dedicated tree-log block
@@ -4191,11 +4191,28 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	return ret;
 }
 
+/*
+ * On a zoned filesystem ffe_ctl->policy is BTRFS_EXTENT_ALLOC_ZONED, but block
+ * groups that are not append only are allocated from with the regular free
+ * space cache. As prepare_allocation_zoned() does not set up a cluster, this
+ * always ends up in find_free_extent_unclustered().
+ */
+static enum btrfs_extent_allocation_policy
+bg_alloc_policy(const struct find_free_extent_ctl *ffe_ctl,
+		const struct btrfs_block_group *block_group)
+{
+	if (ffe_ctl->policy == BTRFS_EXTENT_ALLOC_ZONED &&
+	    !btrfs_zoned_bg_is_append_only(block_group))
+		return BTRFS_EXTENT_ALLOC_CLUSTERED;
+
+	return ffe_ctl->policy;
+}
+
 static int do_allocation(struct btrfs_block_group *block_group,
 			 struct find_free_extent_ctl *ffe_ctl,
 			 struct btrfs_block_group **bg_ret)
 {
-	switch (ffe_ctl->policy) {
+	switch (bg_alloc_policy(ffe_ctl, block_group)) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		return do_allocation_clustered(block_group, ffe_ctl, bg_ret);
 	case BTRFS_EXTENT_ALLOC_ZONED:
@@ -4209,7 +4226,7 @@ static void release_block_group(struct btrfs_block_group *block_group,
 				struct find_free_extent_ctl *ffe_ctl,
 				bool delalloc)
 {
-	switch (ffe_ctl->policy) {
+	switch (bg_alloc_policy(ffe_ctl, block_group)) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		ffe_ctl->retry_uncached = false;
 		break;
@@ -4401,7 +4418,9 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 	}
 
 	if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE) {
-		if (ffe_ctl->policy != BTRFS_EXTENT_ALLOC_CLUSTERED)
+		if (ffe_ctl->policy == BTRFS_EXTENT_ALLOC_ZONED &&
+		    ((space_info->flags & BTRFS_BLOCK_GROUP_DATA) ||
+		     !atomic_read(&fs_info->zoned_conv_meta_bgs)))
 			return -ENOSPC;
 
 		/*
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d6bdc421f578..2fb475c24142 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -26,6 +26,7 @@
 #include "accessors.h"
 #include "file-item.h"
 #include "file.h"
+#include "zoned.h"
 #include "super.h"
 #include "relocation.h"
 
@@ -1384,7 +1385,7 @@ static int __btrfs_add_free_space(struct btrfs_block_group *block_group,
 	int ret = 0;
 	u64 filter_bytes = bytes;
 
-	ASSERT(!btrfs_is_zoned(fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	info = kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
 	if (!info)
@@ -1513,7 +1514,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
 	if (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)
 		return 0;
 
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    true);
 
@@ -1526,7 +1527,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
 int btrfs_add_free_space_unused(struct btrfs_block_group *block_group,
 				u64 bytenr, u64 size)
 {
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    false);
 
@@ -1543,7 +1544,7 @@ int btrfs_add_free_space_async_trimmed(struct btrfs_block_group *block_group,
 {
 	enum btrfs_trim_state trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    true);
 
@@ -1562,7 +1563,7 @@ int btrfs_remove_free_space(struct btrfs_block_group *block_group,
 	int ret;
 	bool re_search = false;
 
-	if (btrfs_is_zoned(block_group->fs_info)) {
+	if (btrfs_zoned_bg_is_append_only(block_group)) {
 		/*
 		 * This can happen with conventional zones when replaying log.
 		 * Since the allocation info of tree-log nodes are not recorded
@@ -1677,10 +1678,10 @@ void btrfs_dump_free_space(struct btrfs_block_group *block_group,
 	int count = 0;
 
 	/*
-	 * Zoned btrfs does not use free space tree and cluster. Just print
-	 * out the free space after the allocation offset.
+	 * Append only block groups do not use free space tree and cluster.
+	 * Just print out the free space after the allocation offset.
 	 */
-	if (btrfs_is_zoned(fs_info)) {
+	if (btrfs_zoned_bg_is_append_only(block_group)) {
 		btrfs_info(fs_info, "free space %llu active %d",
 			   block_group->zone_capacity - block_group->alloc_offset,
 			   test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
@@ -1852,7 +1853,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group *block_group,
 	enum btrfs_trim_state align_gap_trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 	bool use_bytes_index = (offset == block_group->start);
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	spin_lock(&ctl->tree_lock);
 	entry = find_free_space(ctl, &offset, &bytes_search,
@@ -1985,7 +1986,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 	struct rb_node *node;
 	u64 ret = 0;
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	spin_lock(&cluster->lock);
 	if (bytes > cluster->max_size)
@@ -2803,7 +2804,7 @@ int btrfs_trim_block_group(struct btrfs_block_group *block_group,
 	int ret;
 	u64 rem = 0;
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	*trimmed = 0;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ee315443efee..554c383adde1 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1969,6 +1969,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	}
 
 	if (num_conventional > 0) {
+		if (map->num_stripes == num_conventional &&
+		    !btrfs_zoned_bg_is_append_only(cache)) {
+			cache->zone_capacity = cache->length;
+			goto out;
+		}
+
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
 			btrfs_err(fs_info,
-- 
2.56.1

