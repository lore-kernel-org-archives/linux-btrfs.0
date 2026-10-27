Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085781;
	b=XXMK5/4Ck/zjicLgz+wzIHILlDFeF3A47Gf5BP5AA2S9kmtM08j72LTIIGOMjrW6O3K+
	 Xu4y1/C9+B4ogiIrbV6JWrPKbqQ9RSMcNcV9otbI81s3Xtp1jiv5cw+gJIDU0ikWwcjed
	 h7jWhX7UpIbO5+5Ea5wePmFdKQ3WtwkToNzb8ZEgTAKXwAiWT+LRljBbLoWU2aSydtn2t
	 eVJ2CcwSZQUBcSKcF9fMMUvpgtphS3jHajn/Cb/igUwsvX5xUYevBu74YJm3oGzY722wq
	 NQ7I6OxihVWpxbFMefXaOhL1oGWk9YR9yGQBvko9Om9pwN8MHkGY5NqWE/dU5hvpW2g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085781;
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
	b=a24dHhs5Z8jebfR0lKB+UeAnkfzu9AQrlaHnzd3MowuJBNtWyXaUq6gKgDSe/XsECa2M
	 HL8EzxG9i7rIjyc8Q4Ih1OEd+Ek3di4ujTpGzJn9b70sb08Qf4Hl3R4Pwtut73hr3eD1b
	 JQibxejLk2f2uw1S4F63hLStHffkUizkfxLhoH5/mTfl2YOyO2kHpdPk4kH31Ijc97ZBh
	 Shf00FZpetm0gGC4sKiLv1NUde+1QAUyW4a6LH6/pr/BbNgj++N4Ut7671+TWx0+qhoQH
	 cCbQOXGOp3GaRWaLQQ/o4sAYIvAaY1WaHxfcU3OwUelTc4ZVf7zo399OjsMhvTUcfhw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=RoaFHAhv;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="wsHQ1gX/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F86B606A331
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F86B606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=RoaFHAhv;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wsHQ1gX/
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085781; x=1824621781;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=LkOlxFVHdjuFt0PO30HbLL7YaxB2wpwsnjRSclCD4Ug=;
  b=RoaFHAhv/diEuS9t9LriGE9/drYC615I798S+a7qcuQ1/Bu2AtTQWQw0
   MjyzvIPJu0kXqCsJZILIQrYeSOI3OVIdQX5kiJWxKK2W6fCWGegrIcJHU
   3g7j3F51myzrf3MWRwboUl8FmrohT3v60Cz21sYm0lDgVKV5m2dffBzaH
   7ncIdvGVmgwXpmqQlnde6WjA4bQ2lvEZNgJdbnPnCS0E0NXL6PbHuNO4q
   FJVNuMGVAeFwPcTtYI8wbhDhQvCD8sF9MYO+OcJmwFwcbwaN0/AorkyEb
   FcZSaZe69Knxh/TV9J81Ca2+3uTfbkiGQIXpiiGuAxpe34osOsL4j+IL4
   g==;
X-CSE-ConnectionGUID: GhJtmcIRSrSX0xLbjY5aPQ==
X-CSE-MsgGUID: Jr0Nxv7IRWaarwzKM6UmAw==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863262"
Received: from mail-westus3azon11011019.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.19])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v7CUwOyJemXsGmGABLZJwcRhUuTgLsWgPDHKX94yjrWwU2aRAUSIgDZeVO5W7H2sWj2Gxx25AtS8/iSlGuWPya8k1ZV3uFMy/GFpw/qZGwUUknG3ZC7U1VoIw5UAhJqdQesxGIOwdnV46H1ApFZm0A0z9syES1hpOjFRrZ4xDPcbX5cKF21BW3orufRngobU9jx5edVCeSL6spx4YQinE4jYgwzb3MFPrL7V4N5OONjlpg9OukqnH0E9Em/c0GJmPn4hytdMTXb/oGJAVEy2MQ0chhTyBncVJfqb5OtBZiPv6BIzSbji/u8kSs8vpRLyEReZ8k+I+5ND4Qj7SBcchg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxAm+N4PrdoaMXJF3zAEunna7x4XxfKAaA95Hj0EBYw=;
 b=bzQdnpZE8aT24PoKmYasNKYGzU9+7nTowewlI9L2FoAXdphYneSMBXnQF+1HJw5pJ9Lk3E8stpRB+DofvqbUV9BgwSfIUW6KPM8McN58N0DXh9nU1pxb5TugAem5OSXAglheQm2N5hXYlfxTabp6Z3oVh+7fuybTbzef9UL32Ju/W/7x3sxor2rfJusY43EXNfD8VbVj2dHal+qtxbyygUPgx0aaUuB7tZW/v8Tge6RJPjZUhTYh9rHkc+2Rn82QimVilTGkobY6GYu12CAF4u+J8Xz+4cb0nCBKdjjv6zSg4OfjQ54rw3bV8rs+3r7c0+Zeyrux5R50aN882NClYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxAm+N4PrdoaMXJF3zAEunna7x4XxfKAaA95Hj0EBYw=;
 b=wsHQ1gX/2FOweS66cJcT9Na60VYqCP2nQP8cQtK9kTzd5O6a12Xf5mHa0Tlx4UqA7NgcKpE8orhf15QkhaMWYtHe4OxgEGf3nTEMct76qiViwVDbwqmQtyJBC5Ph7buaslH0hmi9t1y/sAdKiookNyc0nm30pcAtuzVhAlFxMHQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:22:59 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:22:59 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 11/25] btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
Date: Tue, 27 Oct 2026 08:22:17 +0100
Message-ID: <20261027072232.419318-12-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cb0dc76-bf90-462f-ff38-08df33fb20ed
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|6133799003|22082099003|18002099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261009223027099003|260925021311599003|260925021911599003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	CVrqkYYSnXB6IFNG2HQlVzmbz6P0D2IwLVTZ4YgZa8TCDl+6PI1Zzo1yvCqtK4c8goJHHKaYEjivyzipgXxyh/48JdxaY7gqcWY0VRwo0u53FCnSq5ce3rEhSTQdXYuv/RUuqktKI2lzXwQY94EndAn+kHH1PFoHxE0+jgyB+cIgyQVRuHnsWdolDrSYBxXONSkENRkhXnZMMdgFZ9qxU0gBFeIHaBUH8tIoFFVY5TsTmw5jxQsGxiksx7q8FkfA9SbBY4l0XlF5F8VqbP5UK14o4HR/+uG3bl7OC3oeyFVWsrkhQpSDAz/lzj+fuVfaGIJH6P4OKaxYL5C44yyrgxRJwU60YwB9bttb3PGLQtyMtayu1AQpwVQxWhgdJNuf8fbDFUzI+VBFeTTveGrW0eaLccxCBddxkpX90yQDZIf/DUVDVFg0Ww8sRaTpC8eJtWUKP42kYQm4rQefoOq1J4rNXmhrcsKZNdC+ES9A9heI5V1qH/MNJwrLTGu7Q6ArlVdVr/zL3zq4Lnisr50T7ACdV227Cy9lRauvxO+bcFmNqLyKDhtaQyXdtcSqC3uN3Wwi0+P+NooFcmCJbjInJFzTxU4tbhb8zkjvk2xxj3JNPNhM7Z9yT2OkhE4dQKm3F71j+1822KwF4/ck5yy4Jj+3IOK1ePFR4wu3gN9pSjY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261009223027099003)(260925021311599003)(260925021911599003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tl2+kBaAEFnIAB6jaSmpa4xfcHlXPhYU7nzXhwrmaqMOXQ1gWoFeskp5ZY+j?=
 =?us-ascii?Q?VmRSkbp1dsrjKmvnfU2pE557C3x/k0GuOLWCBdva5hnQlgPDpSgKKBR9QASo?=
 =?us-ascii?Q?lpcMA5jFD39Ya67n7dkLkGY/LmwiJl96x3hXPRqMjpGfvIbYMhnjeo4HJQNX?=
 =?us-ascii?Q?a2Far8gJnMn+baR16o3zGYDaCLjis8TVxe/Z/htFR+zdLlIBjPGKKN3vyv1u?=
 =?us-ascii?Q?/tva3jXcaBjXrSZJsD/ALc7Uz5P9+YcN+WiTuF0ZejCQ85jnYFRFBil16RXc?=
 =?us-ascii?Q?RnQcmDosfYqA4XE+jsGjjBPBA4N+f4tVu3/L6uxP1+glbD9ezarNfA8KA+cH?=
 =?us-ascii?Q?Pi//ddzeYALxYBuw/kmQHVwd++GKrbFZfDf6xWo+SeIpu9DswMtgFKncb2lh?=
 =?us-ascii?Q?mZwZNNfru0vI0ZxzeX8fDqjsQuQPQuDSaRaSJrtQ2zzA39HUt4MdJ/UsARjt?=
 =?us-ascii?Q?6LEa8AM0uWfo5U7OPMDB6tZrvakhk0+2iIQQL6SncD23hlMsQoNrCvkdtMfp?=
 =?us-ascii?Q?M/mMrKypCZ2CL5gOVTaMMM9GeTekyVN5d8DyBuAFPxZxx5+pBcGSu9jrukQT?=
 =?us-ascii?Q?rcuJAKqAV5fGtOXKsuj/FBPYGYsfvrTyqyzTl3ur2Uy6+Ozczvrsn0dZDeEW?=
 =?us-ascii?Q?brSZ6J7jx1pF9NB7Kh/QoADi25RD5LiyYg+yNWJZOJvG5xcRbEboivGA75rP?=
 =?us-ascii?Q?giRztHIwYoUBtc8ZUEUpXWpg7Qz2O+7qy1oWuHMvMyryJLXVLNWFcJS9BW+J?=
 =?us-ascii?Q?kLgFISZIyXvlIgzil1ZOlPateEiRlN+KnkD1ZMzQ0DmyO3Di0lvH/Xd/fpSm?=
 =?us-ascii?Q?PGKuE1bVoo5/bcAl8g52LBkZvTqr7UYEoWyNXVY5iUjYNFH/QTwrzYSZnMZI?=
 =?us-ascii?Q?eM2KJ0Jabf5gnZnmBRwzPPtfu/dW1PVseK3+AIn3WfyInPb2wwUc5OJSMDiA?=
 =?us-ascii?Q?Xq5gZzTPlL7Amj0rDbfdtE22inThmktd32DLcjeru8uEIpeGUwe33VPS6ZYt?=
 =?us-ascii?Q?TLBk2Mj/uT4EerXO30rZUmSmVnu6DbV22xEkSvoVoJ/aA0BrDbrmKm6UV8Pf?=
 =?us-ascii?Q?WutbPajyO8U9rjVzM77usZBD/Epui/MbpYhWab4cQEvdYfKhcRM3UeNXrXJG?=
 =?us-ascii?Q?b4geAjDC4dUifJP+3+drKTJo+iA/HE+hU8RbSHd+uT5RJ7yKCHr8IN0lbOO6?=
 =?us-ascii?Q?UvsxiSs5MXxO7jotMADAXFPTfY+GJEQPXHX3y0+tS0wbiF4b8t3swvweLRcW?=
 =?us-ascii?Q?1s7N+LbYv/68JvfhqI4RsXtekaYxCZtlTAuvgVR/0r1vpYWC37Y/RJkUwOhB?=
 =?us-ascii?Q?YebbVqdv7lx4jifjkIYBygmtIfaNvY5OyK+0+XkwaQjjbwOq4WUe/XaxIetq?=
 =?us-ascii?Q?pS88O+UH/aR8z9JzttKgKgcgvRMrvpaQGxwIozK6ETIsUygRNXIRRTEh8rk5?=
 =?us-ascii?Q?mawkiE01+lxAum9svS+aSiDhpM14U4IxBilKnUvu89yyBRZMZX3rri9fK5SB?=
 =?us-ascii?Q?H4kQgqGgxhUtcwd/xNuunkvmkzY1J76W/BSklP9OuAMBNG6oTQPQcqsuGtuN?=
 =?us-ascii?Q?/PASzgYQmm7dGjeHA5vQIzTX47WErDgC+TGNdpC44Wno6RTbIidAlMqSNoej?=
 =?us-ascii?Q?DcaBobPQeBxKvPX7/uj1RVc5gUQ9MZnCv9wR5sAS32XnR8BcJ/SpR4yzzjjq?=
 =?us-ascii?Q?AYjPI7DAtDlCFosROgGGbSdX82t9l/asL6XDy7ZmZnSs84+hPjRdla265z89?=
 =?us-ascii?Q?Xo5nKis7Zx+zfucI4SCV8pLR1pbJN88ilrBiBU9Ievm66r7YxI5RUZwmM9M5?=
X-MS-Exchange-AntiSpam-MessageData-1: bm2kQizj8/4d15+d9AMV0fa1MYx7RkNlbTw=
X-Exchange-RoutingPolicyChecked:
	OUaMEdggEMwNlLcDIpACV7jZt5l6TeGK0/JbNgiLnK7vrRfDxnln1D10AH5K4AyG8Xk14N+P7K5bLTL54ml1jy5QP8hvmLr/hbtwJfEOfg8HHbU/MIOWsVUGidavOvFDhPWDgwxRWehs1iXA1stUUXfLYKAFiOOmWSrj1Yxt43CXuteqG7wBBmNkfE2sQR1+FBqNUA7mxGps3IbVk1DQCkm1DZ3qwrDUW77sFawBY5xqczUYkYvu2h80gAGcZXPjL1O6Akrn8b33xDBn4zqRznjjirK8Col46vlOZl6SN/xs2M/7UrcnaUG2uXIwJ6sD+D7tOT5lauyjuK/cWX0QXQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vDh85YOgi+spM9zhG/0lvmaqCHeewxT+5O4ueDVOzv+MbgK9Z1brxCXDEn/QhfeQTgXJaoL5DP5V5A26WpkMP3DjdpX0RRe33ZsDbSdxQgPlu264fs+787702+4n2AT0Ri8TzJEI6B2hcTpsHpI7co+5e6xsne3f2Xq0BMrQcTbhlTE0rLvGnGfD/CxTNamRZswPc1uzQt7g6fWjlTttsAQWJhrrjdWVJrsBrO60Cjx/La5bRWM/CTBQ1gjceqrcHOqOblbbj8exZACD7wnd2cDgMMJy/3g/RTUgAdJVoAGO4MlXWQJhip3kkHqIB8TPLbLC2zcRJk2cTCO+OayyMGZdJgD/g3LxldORS6hfMmLnikW6WANTyIfuLc9n6WeTJzLbq4ZFOy1z0J+IVy/UDGuQX6mQnUDJ/rasJCOV5YNRNhlyYO/HaUoaLjSBfYYHHFxclGJCJM7Ih5cQDyQHF15yW29p0PqavV2CqmgVzk9Y3jdeeFn9bBlsCPivF33cSWqrpBXswtD5DpVJbzGyFUMeQ6uNcOzfH40NapUIH4zTi8WuL0uZZ/B7reveikDAS9t7rCy3MLK3wqvrMMMPGBwoWb1QK+McFsMdtkocU0UfpQItWsDRngAFFbtZknpM
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cb0dc76-bf90-462f-ff38-08df33fb20ed
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:22:59.4271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WlQMSQICxssl0uy3JgdIT0hqwOO190mhuJl5fyFGjSZphsVeJFYcV6INTB17YUEu/7PH0k3v4ruuHsgEFffIl4nMrcFmBjKDCIotISLJgs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

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

