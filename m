Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211709;
	b=oXkgSXSivCwEhTCTgeYX/uLJ1T4QM/qSbV7Wzbd8+BYISJF2URZieL2BqBCY/hsjMlnz
	 ZxoqUcswdjGofdKDMNndukl6JHthM508y4DBVErmB1sFzm3/vTDugoYwmGOYDkE+Zlocl
	 E3J/vLPobtNUdeqlps3kahOy5kJqzPslczKCa8GZXTgDPI62Ryu+6xivSNFtZDK7WsNdI
	 nSOpg7GXexP7hg176gP4LP7cWVeCu1OCxIUNjjwl+du1N9FuZR2cjs3I/6e2Hwrfh/sMh
	 j7jIncUx1rqQPR+8+Yw3dBhDcH52GJGHFa2PZrw2LeyPm9Ia5fO6IBC0e9LmqpcFfGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211709;
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
	bh=XE06tZq2NI1oVEfIu1+/MnTJ1LJIf3sYhArsF98I94g=;
	b=LuUMVX2Xg45oZjUJOLc+b7w+pqftFjkW+LYNOFo2PJ5beSTgAC3yB8BtvuPQ4O7n6Wic
	 +/xqCAScbTJJN3xXPWrzeEldL7U8KPK+QT0MKoiGUlU0ILgWmt0D7J9aFxdVnyovk7GQ/
	 ZsyPmHDNE8PyUBAhtk9A/TDZBTrFOy8MoVQhz4bKcDzhbQZ7KAAB/OrIFdsYjKsP4mta/
	 7YUL3JM6RgPO0jdKUrYWsDFnvoYdNLxgp2tBAsXJ0GrHy3thXwCq/B4Y8ybFhQF+j4145
	 CxNsB6Vul1vu1S4iELdZid5XqfYsS0wHNFugyfRhlGtrZhLaxO5FUUD0uWU47cjsbTg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=cEsshRUV;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Tkgn6af+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BFB60A263C
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5BFB60A263C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=cEsshRUV;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Tkgn6af+
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211708; x=1824747708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=0U56F+N1UZImtIuHHd6QA/rnLL5wwSizO3eAbA76BaI=;
  b=cEsshRUVNbe/l4j0PWVqu6pWSIQQDvzpz8ji9Y4yX/20lBshU+vXsP6q
   wl0nxk0VzXBAClG/KrTbyDhHwwBIEkd16725SxcOUIISz3VaZscGLFtzj
   r9VuYQDL65xIsZ69Oe5sUJc2K9tNDtKI2+gg/qqFrb6rqwu06Du9ubbSY
   jm50BHYSltQIQQbGKwsVp2x+jiO68pnNsY5X+/IoC6n2rSbWyb462eT5G
   VG0gC2PXUVaj7iTfP9gcOEYvXLHd7E2eYZAV2NFkccpD7StgeULnRgkuw
   f9zeBqmAd9oMOAn4M5e2algI9kAm/01s/JRjalal2iZiZuGw0pBhFFX0L
   Q==;
X-CSE-ConnectionGUID: Qv1Bn8/FSD2jLy3DeA6Abg==
X-CSE-MsgGUID: 72hM5bu7TcKKnyKJaBKONw==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="160194179"
Received: from mail-eastus2azon11010059.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TjWaRZSIU1D0ZbuypMaqHOQFCPfFqkzHr/ETDGyjvvteMYBKjvdHVAP9hCed6iXHKlk/VUlx+uQWLOVTp5YkV/OeGCKTCm6JG3NgdTbQYQckQFl6V0AY0HsyyjCR3iE4YkmiEsPdSL4sL/r86nUeYrjGuNV0A7WOOwvriRpI0JesRNDiI7RHWXvU3vA5ZK+bLXuNxhA59u3GObBKLP3aUnLIwXc8LUKeDkMNNw9lSrd7aNiLTvQDpHt5DuqvZHUfOOk9tbv3Z8kK8ZhB3DTqtFszmbpV1HZd6HxlO0rCTEHy0HRgvSd1mS1FVMhePAWg7HBA3zpVNnv+Yc2Ap9N5Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XE06tZq2NI1oVEfIu1+/MnTJ1LJIf3sYhArsF98I94g=;
 b=yTEPBLTJ2V4MkcLZf9Q5fxzpaqf9BCTGeKaLz8rj0HHcbJznASxcAblCuwwnGO54OtXP2qgps+3ZEG+UWu4X0nd01Q6HFNS/u5ROIfoaafwhoMM9wd6IAKkAwo6XoxZ0cUva4a3BbjLcmSC4O7hGe3zORlgep8QPRXGjvEngwXrBAzhSQDc0VHqttwcu83t+8aBfaAkcoBeh5jPMnpeU3T2lkey/MVe6DrCbBMKHkZLeB8syYePXfV0NCd58Yp8RT+jTMUOaitzUJ8pKXGHQuU2B5hXx097QPMYfIXJ6bb1YlHwf4+60CKhwLUBq7rJ8tMEK6U0pWqO6W0k2NLUOtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XE06tZq2NI1oVEfIu1+/MnTJ1LJIf3sYhArsF98I94g=;
 b=Tkgn6af+hCk1OiM0+MqUW7U+2IHyRlIQNp394dLmunWRll0ayccwlGODJH+0lldXlU57CYfzlZsmOhOfk5h7mVcxYRVolU6+jNEpZ+bWVEKE5Pw6T9DW4af5pG0OBNz1SOE/4KdMnlT/iX18myKPVQj0PoifHSgGLzkHBzrs60Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:46 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:46 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 15/25] btrfs: zoned: don't recheck the reclaim threshold of full zoned block-groups
Date: Wed, 28 Oct 2026 19:21:01 +0100
Message-ID: <20261028182111.160492-16-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: d4871344-e1e5-40ac-4674-08df35205338
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|5023799004|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GgwQ3zFYfp/8gAlh3NA+Y7yQ/yChBz7EzfCmA20suvNbGrVitC8GnRNAZRglLmcUjxfiK5eql5pDoI7j+rJ4oDzTR/FrlfZDebDbjDfo421Hjew3ooC32fSUezKsmYdM/wOMHZuXr/DDLVilI90EckQkOChjfBHnv/Kify+fl1NeeL1DH7HJ8p/W7rXDlvNKXOEKlinChMk3fgy6/wmUiFjHx4t6RtStr84kg2DtVEmF5moswBDaX6AGjKDeAPHWuFAWGIxafORi9F2rX95ZUXFxsNSkp2zZfvReJgXGB/NlWCFe1pS6MtvPPpTyDwwdB+fZruUrDwN2MvcA/3n2Z+/QgtI15l82L8CKIu5PqWrsY9NGtA0JZBGfyHWWUK6ROr0hr52yG0YdECUWjV4CZz7NieXbEQvJrdla2ME/qchYd+nLDh9oaOhURdvGzJIQSojWPBvFVir8Xlld4tzgqKK+iAecIKgs8Dsc0qVN7DlHJFJmIKVZO+jFUcVaIRN0DNWBAF4g1VEqclt/TuItvyV6dfnIKVOv1MXRlqaxr1LFkCTolpN6ypYZEqurOTh2PYGXdu3fhmAPPU1SLg5k2zScr0hxHwJkm/9mphUIq5m6CzB9y1/c1LkOy0/tqg+IgMN3cYiNEWInKs6TGqMxbnibohuBaHjnAl5SCK4MMd0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(5023799004)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YeU/AkvFyrVzKBERYpVZ5gjHeZmGyEICNfViPLDw7hMYO/4BWORjotb+6sEQ?=
 =?us-ascii?Q?pfvEF551NkEfD4AHg6uPiZ2V/NSb9AI1bIkTBoG336j/7ecgyM2qXifVlYlF?=
 =?us-ascii?Q?ugIchJ8fUX2mV/GlYdU7YWWkuyVN67FaTLsHn7g1pkzFfnBy8we7LzuDoo0u?=
 =?us-ascii?Q?Uv9DqBTPEG7OdTFFWb1wvQ8rZypD7TNY2MtIz742q3O0662+sGOH3FNBrJ2g?=
 =?us-ascii?Q?U/ts1jw5RM3wX0TRtqkwH6uRL4Y1YpQsGPGIgaPIv0uKlISAV4mAmAH+u8I9?=
 =?us-ascii?Q?gkSRBMD0CJx3UJG+pHh48ArOpOhXApRu+iru0uS5z5NR58uQWlj84R1K+KZt?=
 =?us-ascii?Q?SjBCf2F84oQ1o6vkqKoFLaRtlmEjcwIrZ2SyKt9vhVuZuyZxI6VvesEG17Gu?=
 =?us-ascii?Q?Y83o1Y3j78iMbs1hsUdPua4n3uTV0C9a7T39DWYFTDCckBLOfAH9papiWPMi?=
 =?us-ascii?Q?Ff22YaGH8Lg60ejQJadj4ecyR4Q3WwXgcEjBcrayVWEnzz+ulq7uz966mma5?=
 =?us-ascii?Q?sBWGUsz+oMkjbA11aDgrQZOljw+TNl8zD7ZNZlPr5AecB8tOslRwvzVgnduE?=
 =?us-ascii?Q?11NXN08wGBeOHZGcq4Ku3k5IU21COsVbpid8qjZHoC1eA99k6SFKh4SFdGqP?=
 =?us-ascii?Q?coRIP9Cp2uecCSt7poO4ozJcqVIy5whGw8sT+/LcvU3ve60cPvukgsnL0+WT?=
 =?us-ascii?Q?r8RRkalenVD5scwYZ2szaPBL5GxNmIIzNt05q41vDzO0Yj1AEq7YC5fdj3mz?=
 =?us-ascii?Q?v6OdlBA47105c7BXrhOqorpfgrZ+Zgy+kYmntMjy56N6yA+3TTAawB8kOacC?=
 =?us-ascii?Q?vhpF3kKIris52Xfb+aSE3NCZXCOmsNFpMqZw2opf6JMyg4143nppe/nyG+n+?=
 =?us-ascii?Q?TETTe/tLabyDIoAzg3uMOY5m8c2QPm0EdwgwYiRLLLEuvjSKTWEw308nget0?=
 =?us-ascii?Q?b4G7AgqZiBrkRI9+KfxMqobOwEmMpC+Zo2fh8IAP2XNqa2AQlUH5wsm6xu9L?=
 =?us-ascii?Q?quHo35g207ChclTfmoB4Sr+vFFzpTexQbjpaAaMpdjQMzvJ4jBlRlqHw/FlB?=
 =?us-ascii?Q?FNLCz/IqQ46Hx2UF0rKQtJvM7pikGzhqbyZDHqbD7mKZmLJtfyr+vmc80b6+?=
 =?us-ascii?Q?QAof7BTDDmXAMjNlPh++uOdK5oduidAi5azQXht+m9MQNbNxa9Bp7Jj0YSPn?=
 =?us-ascii?Q?FTioFPveHz195iNeZJ/CMUeBl+sO164wASK75JLehE1Z/3TKMRA7Dily0az0?=
 =?us-ascii?Q?F3C71tUlKtpfu2Wt0TlUf8ysPmQtc6oFurxnZQXlfo7Lfl6ef++dQmF6Tllw?=
 =?us-ascii?Q?6L0AUpXzAdMZPEW63P+YifVj4krI2hQtlUPmwXU82f+4GI2zkgxhbOPmpwBo?=
 =?us-ascii?Q?6lYYHY/xfiewOxIsSYAIKgbdUmnFPVlHAHgvmji8SSUJONJULGWIohWdRkVj?=
 =?us-ascii?Q?RYt6oV/r2r0iJZsO4MxAvuwgrfidTTUdNaoYZTshwcVYgLYdV2ZGvM0/L2db?=
 =?us-ascii?Q?eHvqKK0cf++EXJgwUqwza6aFiYvrl4j6aINEhCBiXbjx99nKUPJUCoGBA0jS?=
 =?us-ascii?Q?GFIxyWIh0ayf8dE4ncwKoEDQELFwffEBD+f49MSujzOJzEafe3fkaLRrOo/G?=
 =?us-ascii?Q?0GDaCCzb/gSIBxxGiPo/vavqH/J1IThQXtnAJ6kF4bzff243zhorTsXdc/fN?=
 =?us-ascii?Q?/kGEYIIr8rnvJ1wrYeyB2/ixWZPeCwL4tT6eG0gt60AMSJuKD29dYQ4VVWda?=
 =?us-ascii?Q?YzHthLJzYocD0JLCiWYUf28zkGyvmIRgVIkgTQ05xS6ZpVIVGEqLb9EvHRWP?=
X-MS-Exchange-AntiSpam-MessageData-1: IZ+vm/xBTldITnjcqJL0b9HP8Tzyj/HgVGE=
X-Exchange-RoutingPolicyChecked:
	w1g0QWUoDIoV70Q3Z2S9Mw63ogd4ALtd6HxFUSfxz+ZxlN5dGbyEaRzHzkadMxZjjFkU29Ov7j1wGMKJ0cr7DsvK7+i7Fh5eIP5FmDlnZAqF1U/KFPX+4YX6d879MkdzlMxpvPRQ5CUCS4lH71oaH4wDPkfbF6bnBadYwlX4Gs0vbpN7v6DvYWTJBfFZjjQc9LVDkT4wnTe1xP0SuG2JFccD+FteR2oPyxHWfNzxUZ4kJvEBxmDu1BDozK4C2QYZ4Mi2/+qtUjA/q1k4MpagXC3cBC3DZ+zzxeAPJfyhOgLnLTPzOUMk4SoZFhgi5W39uI10Usl0K/fwUb9M3YubEg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MnO5nPTi9mWB5Bl2crQJ+hhU3u0YavkfTVKy6b9ahzngvtl9h6/stYUNVQOENBrw0jP1D4OQuNrIZWwg3pAgDkZtTyZEwXFESBGy8OJtgfvdC8SYKl0KkGBRpeXOAwZF0cX2ptH0pnGfAt+Ib2i97fbSRP8Eh+7MR5T00TwYHqMQeDnSdtPD5KsGcSRqJiNJCLnm9jEy4amvJlkxsebE9icsA4vnp6np0EQQXR/XoIzpgHj2+9JhIX3RJRthqPrvpAPCBmFW7vghC8pbjNGSF3F0hrCQPgAOOLFJ162vykTS0eE5Qt+89KpLy88gSai9ASWCJtrqPWhGJpQfcaZp/zRWOBywAXQrct9XEBi1JAQv6mAmOCNyfjYDMtDSvJoPsg1z2EBGhWT0D1EgQ3pN4MiTMiHikjr2Ns3hciCOe+MbzOVpoDRGKuHv/MrL2U339771f/NUwqeW7JtDWDsLxI+EYzyKPqDDtaRwU1jtOViOAGN6/p9xe9+ybKmI1Q4xTledQISJbAqSn2c/P6+dMiQjDD3d0TRj6aorDnEJDhIj+aDpnl31FOJhd3+3y76cE77yx/zzr1nICroKM9I1yNCyrLf3Eo1gFmKpAWu4Ute0FOXAAzJFXKNYRraYUQbN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4871344-e1e5-40ac-4674-08df35205338
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:46.3906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L9fYP2VY9jCsNFmceQ8bCYMlLZyzyVvwsUGV3t3V8mSkC//Cnody1FGYI35dOa37PUIOyJVBq8wcypvhn20bwONSrkWH9hvVA7t57GRQjGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

On a zoned filesystem, nothing can be allocated from a full append only
block group anymore, so its usage can only go down. There is no need to
re-check if such a block group still qualifies for being reclaimed, once
it is on the list it needs to be reclaimed.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 772b6cfecaa5..25b44932d0c6 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2004,8 +2004,13 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	 * being freed, pass in a fake giant value to skip that extra
 	 * check, which is more meaningful when adding to the list in
 	 * the first place.
+	 *
+	 * On zoned, the usage of a full append only block group can only go
+	 * down, so it still qualifies.
 	 */
-	if (!should_reclaim_block_group(bg, bg->length)) {
+	if (!(btrfs_zoned_bg_is_append_only(bg) &&
+	      btrfs_zoned_bg_is_full(bg)) &&
+	    !should_reclaim_block_group(bg, bg->length)) {
 		spin_unlock(&bg->lock);
 		spin_unlock(&space_info->lock);
 		up_write(&space_info->groups_sem);
-- 
2.56.0

