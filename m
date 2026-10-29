Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793255927;
	b=kvbhTfq55/5cWvBoAkyslyhB65cPcsH2MQU82wYIKiQLp/x6Nfl+kNjvN36mDjPzwePm
	 76kPwO8gCjdQTjzrf0cHK4Q0dVrLWFHm9T5uj6Sehn6rueuadCU7a9dyku6Psn0fG2q7X
	 4fka9gRLpYhvE+1fODmwAi5ZTIDIvgbXgbolxbibcRKBtAgPhyStu4ACybcQ9HHAcs38k
	 x+Se8ToJSiBRItGRPuAGASvIt5XPuacBVoI+GIxLL6h06Kgu9AImaeAqAZ40aWiT280uy
	 MYfpxnZ5TQ7S9Gx5dENVKsy8cGER70/iKObJiXodgrjVMQbhUHkZBZOwKj0ZnCqQukA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793255927;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=sbZjTR464B39zzXClIqqYCNFMk24bWCu/Wqa6GPsT3Y=;
	b=ftxg3cVOju7No/TNSy++JHMMRSgn0wSan452zpuNGjwEHGTmXRaVct74jTSIC7hGU4Qz
	 ZMLQt/y7g/A84K8Pcivr0OiqZv5noptIEPklGqbkILPv/nYbhLErEFjVleojILUpr8uLm
	 Sa9NHTkkFkg/rUPOFawIKvxs7TC5VgU8JkqGp83TlZf8eqH44svYo23cVmgvgzJVSZmqh
	 O5By3COjdhKEx25IqGvh+CdoccMsDUrztR3xIqFzXgzB63tYIG5mr9Yd+54LQjjPFKB2J
	 0yPB5Mx3/1oq0JIcn/ESgccJR80NNBZqYNc4kTP/cxxR8ydefB26fL/si+GkIggwoIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Xp9T8adN;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=HmsbNqFc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA798606A321
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 06:38:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA798606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Xp9T8adN;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=HmsbNqFc
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793255926; x=1824791926;
  h=content-transfer-encoding:subject:from:to:cc:in-reply-to:
   references:date:message-id:mime-version;
  bh=FxxERSIRKlhVJxZupu4fIuayQI4b2I02AW/HBVRUzN8=;
  b=Xp9T8adNKUxnhwqY8L4MXAZwCbbrobMfyIKeXmvJOxeghRKMOMluxVbU
   +owoT3lfmXZQqFssiKXsPPWthTANzA5MHwUw2kky+iZIU/0JdEiRlNRKF
   8HfQiiHKTsso+EVLz3pcQLOKteyIKwk5TFcmU1aaUmqJ4MUMX0vA3xQ2k
   3NpbXy3zV/cyxIvoQQy9ZhAPtBnWbB0rlSnbTjcf/IV6qzxrD/ahLdgkc
   V2N2e4vPz/zo8R09SFcZGtjcl/BU2AmvEu9ZFBO/d1KhEcR+3LB2p1UXN
   G/dRcroojrPs2/YoU235n22f1Ekcxhmc1YYf0fTpP46eji2AzaLAWzLKF
   g==;
X-CSE-ConnectionGUID: oQ2/4ZsGR/+c8WZJMcV8dg==
X-CSE-MsgGUID: VZXejGyUR6yDnWxWZfImCg==
X-IronPort-AV: E=Sophos;i="6.27,184,1786982400"; 
   d="scan'208";a="159182441"
Received: from mail-northcentralusazon11013070.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.70])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 14:38:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nz/Vwr2wa+neWuQkc8mS1dHPu8gCaykpjp/WMVG6JZxyCqAfEbtt/RglJVFpw6iv/poHo6qEFKicLovbf4Zb3FgYxnNOp5p/zZic0nBDO7/xS/FNMeyGNkmE7Qw5l/1wX89KXlAtbnfwldWgqMVZZ5HkCVG5llB34KCOX+QVkDJui5SRwnwsyyMpefOJtYyFUvZ3YqkUqmd05z1YclrwYiLjyhBSjmzRK3xCXv6CqgkUifNPUCocjvlCjez+kVFSswOiZIPkbWAij6/ozGc0Ti+Dj/guHfYxdRIkhGIlhwXP3cF9KD9eFDrRK4dVmQ605wkk9Q5hhpaJCAzdknQzpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sbZjTR464B39zzXClIqqYCNFMk24bWCu/Wqa6GPsT3Y=;
 b=SdT+ktmSXJ+7ctjY3PHl6dum1qndpOoRvyZX4khlE1Vnj91SjQSRs8yruYb0HQ8sUr5wgoeJhjzBscizJtpx4eyvHSGRpOa8gATnHVNPLXQ19uSOUE7Jkb1j4blCtAVHZ1IBdo/R16yCRvYbOyS8/4G81A9izaBCijQkd4bJ4gFRvbdgH3JNRJNL4pxLmurmOoQr9NjlffAgz3DnQTnw6SCKpG2FdNfQXGAtskPhd7GtRqo2Uh2T6apCdf7xNkPok9BLOF4cgcmAFiR8b63lbXe5AtBc7AzZ/yxXDazwdavMqMNPKd3wQ4XfG5r2CrtytUZe3CXoNugH4T5Wsce3Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbZjTR464B39zzXClIqqYCNFMk24bWCu/Wqa6GPsT3Y=;
 b=HmsbNqFcbrkqzXy8Ecya35zHzSthmFi66Jh/eG+Dc4xSlB6g4n5uoz1ArX0cddIrzu/IUWqRO0x0B0MDeRstCAX8mDV8vMJzgrEVJ1UK6XJOA++yGKQ2DOnaG2W4YZEWvrGDCzqwmFFH7phmICQ+xBKlty+2EjOdz3uhyvt2n8A=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH8PR04MB994144.namprd04.prod.outlook.com (2603:10b6:610:332::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Thu, 29 Oct
 2026 06:38:37 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Thu, 29 Oct 2026
 06:38:37 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] btrfs: validate but do not set bdev blocksize
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, 
 syzbot+5c01398781fb51df783a@syzkaller.appspotmail.com
In-Reply-To: <3d98566e8aa2cd99a23ce89665f79281c614f05e.1792885061.git.wqu@suse.com>
References: <3d98566e8aa2cd99a23ce89665f79281c614f05e.1792885061.git.wqu@suse.com>
Date: Thu, 29 Oct 2026 07:38:31 +0100
Message-Id: <179325591144.119664.14554525600895412370.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=737;
 i=johannes.thumshirn@wdc.com; h=from:subject:message-id;
 bh=FxxERSIRKlhVJxZupu4fIuayQI4b2I02AW/HBVRUzN8=;
 b=owGbwMvMwCV2ad4npfVdsu8YT6slMWQ9evnGpHnn5PwDU5a8usUucixcUL4/+2nbm0Qp/ebIx
 WK6Snz7O0pZGMS4GGTFFFmOh9rulzA9wj7l0GszmDmsTCBDGLg4BWAiOXMZ/tmfcGgwea34wKXk
 pWWH7l4L5uii49f0j772ei/lbXJFpYyRYUf4Gt1K+ZpH32Oyl82btC5g64SJ4sKTXFft+JPBapz
 0gxEA
X-Developer-Key: i=johannes.thumshirn@wdc.com; a=openpgp;
 fpr=EC389CABC2C4F25D8600D0D00393969D2D760850
X-ClientProxiedBy: FR4P281CA0061.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ce::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH8PR04MB994144:EE_
X-MS-Office365-Filtering-Correlation-Id: fc66083b-c539-48e9-7f4a-08df35874303
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|19092799006|23010399003|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 zBH+XfNdgIoAlYX106u3L7YYpE2TOfdZKVvuFZLHEGp3mAR4yzU5tyiIK+4glcL6lwPD09U2QasCitsPpHoEN+kZcdwoZ6lsb3cD6yBS46UszPW11GTDNEzGEH3Bw4NM0KarrjS1ld0vQCP3v8DLHNfqb5bN2lRwCWIgNOdfkeDYHgZ1uadZdo5o4OJVzDo6xxpGIvcposw4IzcG0AL+RtJCLdnXLKWyLnC+smRxIrVlpfEatc0LZmVuGSMOKq6CUfzoq71GxB32krhg0d9p9Qnld8QK9r1ReL8bMQtxFS+xpQPkmga9TSduQ7UVhn2DTo8KXp0slun3c3ybiOsEZRDawxpXOjuOFuvsek0K1//4ZPtwlqzIIGHrM7HNZGgjqeIiC0KBnk6sWOpO1f3/OUn2xIqP11R8/xQmAXmJAMwfZeWi/S2exNbOcxvuGJYLwVZa5vIzJKz2XNRkzfFwfS+xq6PQC66gQHrE2jK2QVUHJ+1oy4B+ptMkZWmROhsf68Birlmb5aMo48EFPF3KuHO8+8Cub5qbG5ygEtRTtbEyZxDA9keuwWu+RTvi7n7Ehs0AyhMSy4elN7UYFqRtteETJMV7iB5JdQ2hR1LpeOGLAOFa8ZUMLy6X6zFhdQeMkIzaRde1EWYfXYtg4wSChedF8z7nKxjGJRrHKc0BW0o=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(19092799006)(23010399003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?QU9Kc20yZ3JwanI1c0p4Mi9ScW1jbzlSUTRIK1RuOEZiS0RpZFJrVDFsdkoy?=
 =?utf-8?B?c08xWHkxSzJQTVZYd3RvUDdwc2xzeVdKZnloS2p3cFZ4Mys2S0ZoTE9Xc053?=
 =?utf-8?B?UWdOMURHN0ZEVW4wWlE1UjhlRU9tYlczeXdJc1REdk1LcVZBTGVsdXlFRGFH?=
 =?utf-8?B?aU14T0o1a1B2NVU0M3AzbitDNXZlRHRZZWNZVlQxbmlQWHA0UTZYMk4rMko3?=
 =?utf-8?B?UHdBdG9YZ0g0TVl5bVZjQWRPdnhWYklLTmYrV0xHWSs1OXpqRVZVUEoxcUtJ?=
 =?utf-8?B?KzJLWVNsQXNTODc4RmxEei93YXF5TDVsZUNFclJDb1JoQUJXbVQ1Z2hmSW1R?=
 =?utf-8?B?a00rL3JGSmEzZHNBQXVibnRBaE5sSE02alRUYU12S3E3SVZsM2NCZDBzN0sv?=
 =?utf-8?B?WDBlQVh3TXFsSFJ2aVo2YXgzd0xTQTg5Yyt6YmZEa2VoSHhaUzI5azNRWm1K?=
 =?utf-8?B?TWZJaUZIWmxNeWFucEE4d1BMSFNpZjRBVTd6MW1hNzJBcXRndkNXaUo4TkY3?=
 =?utf-8?B?dkEycmVrYjVDcnB0dDcyOUFFMFAwSmJnNFdsdHdiOHJ5aU9DSzd4U2Y2US9V?=
 =?utf-8?B?bk1Zd3BmVC9ZRU1EOENrdEY1K2dncis1V2dpRmdFVmtQbjh2N0lCYTlRZFNk?=
 =?utf-8?B?UWpBZ1Evdmp4RkVESjJqYzZ2S3Q1NUdubFN0VlNvclBET0dYMGJ4TmtnV1VV?=
 =?utf-8?B?L1dmaHZYSDgwOXVGSldGd1E4NkpiRWZaVDMzcnZpa2c5TW1WNThTZnAxVGts?=
 =?utf-8?B?RFRYS1I2dXdEZTNFZmJvSytvcS9IS2VwSndOOHlqczNHVDBZY2dmdndNUkRx?=
 =?utf-8?B?enpFN0NTMU9BUXkxWFo5NDk4Rmd5OUxWbWtuQWRzTE92ZWJJUnZqdXRKcTZo?=
 =?utf-8?B?M2xHWU83VWIvNmlQb1JvNTdXdzhDby8vWGtMTzhlcjdFbTBCblhoVnFCWnNx?=
 =?utf-8?B?bHVLWWc4RTVtdFBVS1hNTFhqb1U1ZURSNDBNekhlZVdpMHk1OEc4YzFTSTVL?=
 =?utf-8?B?dkNDbEdwRU5BUms3V0YwQ2twUVgzN1hGdm02dWNzZWtIZlJLVGhBdWk0dGhz?=
 =?utf-8?B?M3U2UklzL0VIQUJuRkJ2a2poTEYzSm1uUG9JUHF6ZW0vU25JcjhsUUpmWmZR?=
 =?utf-8?B?YVpjVncvWUJZb3dIMGNhSjFQeHdXUjE5NjRMZU91amRST0pMOG4xR0FkbUYx?=
 =?utf-8?B?Z2FWUUcyaVJTaVA3K2FpMklHRGlyWGR2bmpPYVhhOTFua1h2U2hxQk9NTHEz?=
 =?utf-8?B?M1RFSzMzbzcwRHUyWjN4dUlWSEVwOWx2VithSitlVGJ5Vks3bWdKU25aODR4?=
 =?utf-8?B?Vlp6M3NzcjE2ZEt4T0NOejRXczBYSkxKdnhmSzRsdytvYVYyWXpFU3Q1aEtw?=
 =?utf-8?B?SysvZS84NHRqbG0wcjBCOFNxSXlsd0VVTndHRXg1SjBnQjhrMkwwa05jTVBo?=
 =?utf-8?B?MmJDZjROSXd6bk5jMjZSc3VESDRVL2hvdEFYdW95VXQrejNVVk9lajVEWU9w?=
 =?utf-8?B?dXJ1djk5NmVJd0lBTTBoa0dEQXJzVjRWN1hzeXV6aUFHam5VeTZVSnQyRTFI?=
 =?utf-8?B?VlJXQzQ2M3gwMHJQdG43NXd5bFU1L0o4UGc1bUR4YURJZEw2Zk5yUXNaaEdW?=
 =?utf-8?B?Q1lic253QTVPb0RKMU5VUlE1Rk5taHNzMWttZXBmT0ZIU2tqYnVpZ1I0T2RI?=
 =?utf-8?B?bHFSZisxTlNyMDF3dmJHQ2JmUXlzZlVoa1VlaytZY05aWjJ3Qlp6MHVzRCtx?=
 =?utf-8?B?dCtoeWRTR2pMUk1FUWxXWHRsOFpVVnBWaXQ4Vmg5SzAydlEzdTd6ZDkvQ3Ur?=
 =?utf-8?B?VVY3RENEK1Awd3JGMTJqMzhPQmVlRTVPSmlzb2dSKzhZK2RyeXlFdEREdDIy?=
 =?utf-8?B?bERBYkRJaU81WjBwL3VJakxtMUNPTUd5MjFIemFEUHc3UE5jVjBWUmtGTXdi?=
 =?utf-8?B?cnRmWmJwNDB2R0laTEVwV2xsMjlGMGlkcHVsZFRRVCtldTNnaWkzVG4xZWJ0?=
 =?utf-8?B?SVFreWhSYUFVOWdUYTRlUnVuY29kMFdBVUdvcDNtZ2JjQ2tnVjVZeFI4UFNQ?=
 =?utf-8?B?VmNjVCsyakNuaHdtMTFlR0swdWN1RnhEYVl1ZFY0cmgzUDZrQ2g0MlROV001?=
 =?utf-8?B?Zkl3QVBLRjczbjdsS2F4S3N2UFJ4V0E5VUhMN0haUEhkeWJHYkJlbjUrSXNL?=
 =?utf-8?B?M3lWMG9Cc21YVEhRS2oyVTFHeWdZMXpJdXhVb0tSQnhFOUlndHpPWjVBbGdP?=
 =?utf-8?B?aWZObzZDOTNMZU93WUIrdE5Ca3FFY0tJbzQxVHpNTDhHK1ZUL2lXL0FDR2lx?=
 =?utf-8?B?cDJTUExjOEx6a0VxclE2bTYySE0vQTZLeUlRTnR4dFZyeUh3Q1VKVndpVGpG?=
 =?utf-8?Q?IMVhMSsxZDbpEwe/pRbNYXaJnoeI4F93Cu+6pW3z4W0gX?=
X-MS-Exchange-AntiSpam-MessageData-1: 7uG/F9RCE/L6Jr4EFA/rvEmI1V5skMbt1CI=
X-Exchange-RoutingPolicyChecked:
	d6xJlQFqhiCnE8TLUlsGvfIpgG1gzXPSAjgAnx6Dm5V7hPfuEkz7AYSWvfXN+1QUK075PDkPpqb+XdUUz2cwbT5Vt57ElBdIym//6sBKwCCkZrNflK3+5BUQ2grTlsXDlBBBVZCplREmSeIJpHRV4UNTjR++rfZsGyRwuWcfZQ3DJLTdw+9MeM1ZhyGL355NRYVpZ13sUVh+osy7hihg0RrJEZJTysTS5b5VIHTlYweDM4jxoj4LJzS+ODaMK0GoJVSlUfhoHk4oGSIH9WstMlxrYiYY5cjc7MI3sp63DsExEnIIighQ8ptq/F8BR9v+v9IvBHC0HaBz/ResZLdbPg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y2ojJ2f78mCadqWAcBq9J46HBzZpEVReuvjQd9RRGMDJD9fpzg+6czi30Avc2sjR4n5xPjJ5WeJWCI+QsHv4y2YV3p/832SECDxYOfTdvgl8SW1cUDA2VdfJomRpQwO5T4tQRnOsyFuuEFULzmGLKrU4zOm0mJ1vO+p7V7ZjXQcUP8oEu0IxVey2q+fbkfska1GmfWn1OUzjZqrdpYYvI5070tuqU/91DGOEbrKfFJmMJPHoxbNHb0HTuOfPP7BMpkR4yNVZTtNNiZW55H1V5UxP4PDX4ek6/wrE8dmWXMTIXqoNvPFx6B5luAm21WRUGIkMyehXLudfwHnO9QdOvRcRh6FOewu+P3VmVtQlD98sIpv6LhT3ZHepdV1ulSNYiZCEWghW77bW4zaKorB1P54v1l2bKiGktuIVU10UXD1BSZ2roI8g3IwoDzxgoElknqFs0gNdJoYrw1idD/uPREq4q3lswXejBiqwu5FsJjluERQ5Ltbmwq8rKsgKJCK6dCHS/P9MHYHVV/5uYSJoSdv1Kc9281/QQ1gd+intzL6G6Wm/Mo3d04sGA/3f1WjWB/1Do6QFIoJnjhHAVkNKOUXOBdr+nPVYXSMPmMeZk8k/yAt68Ck0H1MnkGRvywPb
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc66083b-c539-48e9-7f4a-08df35874303
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 06:38:37.2222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ags8gki8vbTq1gWTrMwQkM/vhKnpkKxByh2ff7Yvr5m9IF//x0ai4TfCs74lE7Fe27IrH4rjFVWDE06T77pUlSKYamXw7JjiOzFZRLg03o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR04MB994144

On Sun, 25 Oct 2026 10:09:50 +1030, Qu Wenruo <wqu@suse.com> wrote:
> [BACKGROUND]
> In the very early days, commit 325cd4bafeb6 ("Btrfs: properly set
> blocksize when adding new device.") set the bdev blocksize as at that
> time btrfs is using __bread() for super block IO, which went through
> buffer heads thus requires the strict block size limit.
> 
> Then btrfs super block IO moved away from buffered heads, by commit
> 8f32380d3f29 ("btrfs: use the page cache for super block reading") and
> commit 314b6dd0eebf ("btrfs: use bios instead of buffer_heads from super
> block writeout").
> 
> [...]

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

-- 
Johannes Thumshirn <johannes.thumshirn@wdc.com>
