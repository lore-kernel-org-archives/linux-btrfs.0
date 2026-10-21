Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590146;
	b=PVzAS7qLpYMyW98bBPsG66+m4+gt0VQqgIEAJOwYZUDG2Emi83V2WGHXaQnuoARkN3S/
	 fYkhHCIT3Xq4anepPNH604LXIk001lSjkX+Hl1jxknIgXyG0JrxMJHjW9uKm1R3PJleCR
	 he85uiDsAJ0L5XST0maicPIfBU3dEQFnQB4H64jWdklzbA5ab/SfEE7Jw7/dRwha8Tvfl
	 XrRP3SWfdeZwThh2gQhuR63fNDRsbxBOcRQQDf8eePlNXJ48TT42CQwt/U4a20/ihxXI6
	 5UmNX8e7TCz7+hjHEdJmus6w53d+T+fXLqgS58Qb0fwRlUR6kuM37Xcai/FquvVyXcg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590146;
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
	bh=5hYpSngH8G26QWPN11lVFqvVSngYHkcy6YuTvOxMvtI=;
	b=kLblAFl4nOVjmwjByPb+rFRsx2zGFXv9+0cVQRn3WWi0tD5YIs+zUmfLiznoUSFuS5W9
	 itX3/UKBP1I2Om6tMaq3a36GPS1N1x38t60rSeChSWaiUCpmwOnkbY3veSsxW3B1C5kME
	 7m5d8X2+cv/fHGtlcXmaWcybKPd3q36HAqnKNzK7eL7b9F2w6Mp7ZxTxHVYLAUAxXJeUD
	 2omB+whAJ5I6j0fwjCF4YPbpq54q0TEnKQr2oDmTSWWK/e5BXSi3/FEAID5ynjqMkFSNO
	 Xydbg2P0P2yA6bnR94YZGRAMmnAFP3kMzC2Or/l7Y/59/9GBVPLE/S1/TieRA6d1/CQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KdY+g7TO;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=sz522SaK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FB160A2607
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5FB160A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KdY+g7TO;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=sz522SaK
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590145; x=1824126145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=0djWJt9DaL7Oqy15Humc541rkNSgvlbzXJxh1s8eCwQ=;
  b=KdY+g7TOTKXHdljPEyLYRzm5AqL1egBEjWUkzKhDQ9MT839vkcCw3/fC
   BqA2fW8u3DELeC0ee1XTU4T9Olx9/jmWa9OvpxQaa0cABzmqSLWNt195r
   /ZIToeoffpNk+19zzuWr1khD3SGxambZRFEax8toflpUpOymUQrngSHiu
   pyoagKNEvgDmj1Tu++zkuzJB6RHyrsK2liJASUPCSdx6PF8cZNzmc/zCI
   ExhrjgwRfMtpzNUmic+ztEO5PVHLBTfT8Ill3w2pvq/fV/cVbg0tayEHk
   Qayy+VG8a3ckK/fzh2P8dRbSOHSeA7tGJV7g+cRQBVnZLAgVOxOnP0xv3
   g==;
X-CSE-ConnectionGUID: 7ldb34/uRGGU/qO7SX4yGg==
X-CSE-MsgGUID: PUzU7k6dSc+r6fZ2F0EAHg==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="154422369"
Received: from mail-northcentralusazon11010067.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CpaVugO24VoZREVe9ElfeWZLLJ0v5wiskXh9vXUUnULqZKeURJV6VSSIJOJjNUxdRP/7k+CewwaImFsgB8O2xyvmvSZpakZGn4AgQL8+vY+jdUI6TBw4xFbnixVkZ6V0jkpEHFkMPUs0Xv7RLSvAczqxFxbfk1fI54EsrBiiyXnmEQ6iOClp2gMpEL9BbNHRHb/A7NaQz243WHOToH189CCHke6LRQgDb6KS8ehHxe4YCTQATlibPNzUz9BAf2YBHZP0sMgq3OfCHRWN0dnfSYRTEwJ1d8zm9E8Wc29Xh4qSab8cTlwwOuimaOTPnGME53K2kX79Dms2j/RAETU8GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5hYpSngH8G26QWPN11lVFqvVSngYHkcy6YuTvOxMvtI=;
 b=gPeRozh55aPBfVfRTrZwRM2hCPMA2Rvt6ueMf1nPEriAOqSr64WwhKtDKUJoWGhjZ6x41fofNs8WNdXt2qyR29Ul+WFvJ+t2yOewV1sJnAaDlQXdvWgbuFg0lzkEmU5/UqGzlJRAtJcbGX94sDy1PGy5LG3NK9vhINayKv6f4k/I67U4ccteSPESX4IeakYqFuAFRB0d2DfwtPevqdQns9TBgUrfSbyisxDfNRTAHgNUx81n5zbzaXslIWVaZ+QvQ0603PmagmYSwCYSMe94RIVOrIN4B6ury/zgKhAIgPb4Q+4hL8U5cKdrn5qCwjJ/B37dP73Wx7oRoJyD3+G1Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5hYpSngH8G26QWPN11lVFqvVSngYHkcy6YuTvOxMvtI=;
 b=sz522SaK844NuWO/dcbeux2hnf5HiWce297H0wbuaJ+HRM+TACd4ehUCnTRtSKaGDuksnQOWyLq2lHauW5c2/jkfRTOpEDuBnHqTMY2/316C/WzMWRrNhZ93KOm6TlnmMmTirbGNgD3idpTdNiyWd530i2eGJzBDEYPZuf9wHtI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB10015.namprd04.prod.outlook.com (2603:10b6:510:3b7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:41:50 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:41:49 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 04/25] btrfs: zoned: never activate conventional metadata block groups
Date: Wed, 21 Oct 2026 15:41:03 +0200
Message-ID: <20261021134124.2338902-5-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB10015:EE_
X-MS-Office365-Filtering-Correlation-Id: ac1792d4-71b6-4eb0-d873-08df2f790ea4
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|1800799024|10070799003|376014|366016|18002099003|22082099003|10067099003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 5BShDRhlIQRx1Ad8yo6wroK4IkKnbdOxxVCX4s2mBoaPLOp36H5iljsrUSKyJ4iQwhudQW5TKsjizr89utnR3Gi1g7NdMeVCN298+uHZnYRs/IBzebOKYtsVfJEuWlz43tc7wCXU0VF649sj7RsNy65G51qNFI2LpBAokFyF3wng9t7uqZIFbD3szpk+MGuShTEUt9jNf6noKUnfR6zoBe8kp5/jPgc5mvQ7oPG1s3ux7VNh3krYoe11AAvO2zgUS1+yNxvJXDGvWpftHWZHVQjwoXcKs8cfMTBEQ/jljCvGPWZX41JEgIivt65fI6yoNwpra/agSo3QjIz3jWwy26fNwfaBggtBRgWCzFF8L02hh5oBY9E9jt13Kgdv0d/Hl9P5Wyf3mvVTK0b55tOfYJQq+b+1qOjcftsh5XUrl2pEbRpR5lJsiJLLf+NM5G786EI3iWoADb2UTmlXfsTG/L7CeC6G7hX8uT6i5YFEtLG7HiyoTq6BPsnPTb/t+D9+LAmcp4K773XK+p8N8F+W3T1xfxbNuehGN5s8HXx/7to3q9HQtDapIvb85MQkb2CurBULr+FiEqYmttQ79FzJ55FFwSS62Of+D8d2VfUjnIHEUEoRkb12iFy8Z81JWXihXUt15y331vt032dlriQWquHSGSoVljtsfG8ezfsPIxQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(1800799024)(10070799003)(376014)(366016)(18002099003)(22082099003)(10067099003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?07S3Wme0Lph/BfiBOJpf92fEH1ocF+uoHBZANxW3EttTftjbPKDhq2beS6oB?=
 =?us-ascii?Q?U+od7IZldChM9wSLzhic+svqiIBuDg9rV+LFh3BDpz7GVdhl9nBjpJpAr06w?=
 =?us-ascii?Q?Day4Xb5BFGmjM+WX0kj9aD3niqemtj7xgZLkB7/kvhSOz9inMuQBnA6qRW2i?=
 =?us-ascii?Q?tiaadxwd6O5ZKTuPizO8E77Sq56v48JCjSykedHoptF2C99MQ1mXSStlrEa9?=
 =?us-ascii?Q?T6yMTiLZjBq4VWUAsnbOOLMdTJ9cgt2HPCJ4lfS7sDAKiheGcz1STmLrUQwg?=
 =?us-ascii?Q?Jld0dJ619H3UBnJCQuQzK8MhbZp+GKOftwO3PReDeW8770Lyzx8HHnRRdj70?=
 =?us-ascii?Q?mVmgDdyli0Jj1PbkbvrIk9OnZW8tZv1LT0rFw1DAAnxcTGDzS+c3lZY/ukbm?=
 =?us-ascii?Q?GjBcfwyNhCkrHwFy//pSsBU2+0sp1QpBKH7JRJSVLlFGIWI+JhfFb0m+k+QU?=
 =?us-ascii?Q?uFsmRCnbTtM1eHzVuo0F8IFd18mOSqwR7xKJkXbtngnxWVq8QGMJuzHFRzn4?=
 =?us-ascii?Q?FrQjcTY9xuyXUMbZVFD+1tpwWFw6YxU/UydmNpF5uwqtwRaB9FxyzScfT/G+?=
 =?us-ascii?Q?jBg+2R3WSq3BgMRJObfViojGQs2yAnfx99IzxTTAf2xFdXBXRdWQf01Dw3Wb?=
 =?us-ascii?Q?TRmfwcYErIg/N30Oqg05r6dmWK9PhKT4YMiNQDy0qUWIXnEV3c6hMcypCCHU?=
 =?us-ascii?Q?3m09eiKRexnl6m9W2S3a2ISfxsgCOEeu+qZW46zku4qQKY0Gb6uK+qjhNERy?=
 =?us-ascii?Q?nhL9VaL0wA0EQqDhtZtQp5ZlSZm9aGsEH0u04L4SC0BT0QtBdy/h6/l+s3ES?=
 =?us-ascii?Q?4iYHGzSQ3IIFMC4l93c06lDPWZDRWFt/ddyvhsCuzppJA8r1M3K10BqiZroh?=
 =?us-ascii?Q?FuDyFd2prMzelFjgiGDRV5NtT2umKv+QUD92HuI/6LtvVnpmhUXOyt/UjTD5?=
 =?us-ascii?Q?jxe1/7Te5gm646u8C4bowhhdz5+lRbs7W/kDdBdD5xyXmrKLW1p95QetrH/e?=
 =?us-ascii?Q?GDM7pti3xI7Cg342f+I+jwUxBSd8BLDzoMvyXcJ1bSDH0OiX8WFnXnlvcXjm?=
 =?us-ascii?Q?TBs7z2Om5rH1Z9Cq6r2pKRjj7WX/gz5qIZPyc8/v3T5AXUlmoHd6jaDIvXva?=
 =?us-ascii?Q?bR/SiSHo5RP32UD8r5KjfjoYifzJhqLocXYMN8xQ16bNBkLgws5MTW+htIDx?=
 =?us-ascii?Q?tMQtMSdV+5Cq+oi2utNzhuC1xCriN2WsRuAMtBQUNUZPeVveRDkfDSbtea2n?=
 =?us-ascii?Q?bgw1d0UR4+hOyf3767aOaz68rtQMDwy8XAPSgOrhKBBxE7vJdkXzZ8CGfcZG?=
 =?us-ascii?Q?PcpZGczfXYlW3aZCrThCBWDuiBBS5kWwOu0uZShXVwmqemeh/NHSLr8X7hrG?=
 =?us-ascii?Q?inVejtK9QgKUaC2YAXGliEjygCzWLQxWviUFC1Onbhj2owHSxPUF8VQvVBQO?=
 =?us-ascii?Q?ai1uLcaFYQ7Tt0l6aVsDtPtJjYr/A55ftNTV0SaYS7QuE6CC20Zzbby98Rak?=
 =?us-ascii?Q?tmqktPEri7Koo4ThAweBplWr9SQ/pOehGKkusBt5MLzo1WYBDf0DNOcUUtoa?=
 =?us-ascii?Q?RyT8g6SAow+mroaUdAs26kayQBAapW/XHN4GHEi3XWEGGxqiJ7gR97YHVwN4?=
 =?us-ascii?Q?ya21nUxz0g5S4nc4ZINn/mhEeXW7fl+5JEPvH4tX00N5Meo6nd9Rz6up2FIF?=
 =?us-ascii?Q?PL77/1kTidHZXCe9yVdXZjkUjCiuNpXE4s3p5XNAvOOuZn3XzXZdEbZHmHtF?=
 =?us-ascii?Q?Ovcla9civa6/mvbkrn4rtf84DTR5+1o3Aftjt+azCJdos1bq+ghD7qjIHDsd?=
X-MS-Exchange-AntiSpam-MessageData-1: cnIL82dZDwRivjNqzxil4JKWqalpMQJTzCQ=
X-Exchange-RoutingPolicyChecked:
	n38E76RJ+rcB8FsvS4t3GCbQakj1zupHSW3WSYOvZcLQIAfuim2/i2QYfK1xt61TT5ScmEWSZdl0UhbeKCvbAqLEUMB7TmI5ewPZtgF/furXLPfz9ZeuWmbZbiD5YYaRXGvuvQgbIrFxf3xvMcEcCLNoTL+6p+xvT/5m43x++qKbjyAgRYkO+a8sRttupis5i1vK/7ROE7KbhmoDG7+3YPmCnDSd9PAG0ibd6uGtim2ZpU8FenT/VULk/wyz2B8jaNL3HW1++Ai8WpOxT6SkBF3ih5WElKLQy3tmtKswbRI5TL13q4oGrx03fHh68B5DaAD+rdc5Ul8mIkwE5GWrzg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jY3zbY62foSlP2hCWfHXKdxVpz5rB8WlVURDYx759VLtjxEzWc1ZE1RYnHkRaItX+d/ELbJYzwlxRItyMB6bRQA9rjfNRQSsRsSN4TOZnP6xeJiiSNDIhkTu7UXLfk2cViYKix6SformOeuo6w6uEPLDIfyDw1N9hFbJ7FNzQU465GZeHQlfoP/tUdUDXfKT4I1XAwEBK23Sdp6vZKoPXtCFrJ6pN93HVRY54mQlEGNZpY9wG366gHmDc/br1AZApn6knaVJZji1f1Kmlo1SOKOQX6LBngGpw7jdmXe9GkSS6d543CADEIgWw7Ef7BlkoHzQepsKIBOc7TeAz0RzFJvDnLGltN1rvbZum78M//+pAw00teI7JqyVLbqXUWfwPoccoNhyGYBmjlkHmo+x/yqn/6YexLUqprmgbS4QQqaKsM5R/WC6ZeRCRuch6NVBx1ZeUed1mFrgjAObUpoRexQlRS+dzSyMQi9Wyu8WRzw5jXt7zeCsmyxyPHf1jgCXB2wuEiJ//5QEsypLw/KObI72sIgJxJLItmhvqSzDzETciXVVG5/wyFXpjQGpsqqjzOQya6RpMTeblA/lu8Jvy9ZBQHcgb7eM3/ZxwYkZqp32EhZfEoN77boOE7kuYCLF
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac1792d4-71b6-4eb0-d873-08df2f790ea4
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:41:49.4059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f97UDKoVS/t6Nllh31jI3V1BJu7ssKJpo5Gm1Yrm4S3PMt/Ph/m8qZ2TZwkqD9TzbSus46ZqTA8xOHXRCTv4BIGxeOYqVRHQBFhdJ9mNE2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB10015

Metadata and system block groups backed by conventional zones only are
written in place, so they do not need a zone to be active and they do
not consume any active zone resource on the device.

Make btrfs_zone_activate() a no-op for them and skip them in
btrfs_zoned_activate_one_bg(), which would otherwise report progress
without having activated anything.

Such block groups are still marked active when they are loaded. That is
dropped once they stop using the append only allocator.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index c65f1b4f6dbe..81e211316971 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2463,6 +2463,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	if (unlikely(btrfs_is_testing(fs_info)))
 		return true;
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return true;
+
 	map = block_group->physical_map;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -3076,6 +3079,8 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 		for (index = 0; index < BTRFS_NR_RAID_TYPES; index++) {
 			list_for_each_entry(bg, &space_info->block_groups[index],
 					    list) {
+				if (!btrfs_zoned_bg_is_append_only(bg))
+					continue;
 				if (!spin_trylock(&bg->lock))
 					continue;
 				if (btrfs_zoned_bg_is_full(bg) ||
-- 
2.56.0

