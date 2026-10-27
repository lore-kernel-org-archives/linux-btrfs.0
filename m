Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085786;
	b=DtKOVrHYGq2411yvF/YszSSL4En4HvJ1kZXnSFraOMnJo2jSoK1pExhSMfteZCexDsHD
	 xJ35XYfswyJcaq9DRwJtvWXNhn7AnHqkcEhJK3kFIWtP2AbB9b3rJeqIzEcKebYY5ds25
	 eFNkRj1Z4obFN5dk6UxE3rbppk19apNe4v833O5lMWaCkXGpTwXH51P7CfrPochJ0iB1v
	 iLVYLxnoUXrQJ4yEL2tatESxC0Z7xNfm/I5fphYcvFAa04R0yMVZvBgwFJx+Q6uq+hr24
	 qhDAc8xqEysfnhs4zFsj2Q9UCVYRUB+ufBkLkaK4o/9Clr8f5+fGvO71tuW26Wjea5g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085786;
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
	b=y3mOx08WGqgEhBJjt7IgaY6p5g7fmI6NyiHAbY4FX8ppqcWDnNKsyeAfAE+SsX1RNJwR
	 XkbeI0ur6u5oYCBtKgVCmJeVbxxg+1eCgFhk6kwMRKT0kn/j4D0UQJuFd23YGf+I037Ei
	 c5nam1KGLjgtw73L38UR44CWqtZ1Hs2dFP/MAV/qyd9K5pDskX3hqO9JdmK58n9aGg5eZ
	 p6RH0O1ap/gQFy92gPRdUxhU0OUg4vCmOVzy7XW6Kgx4AOMsimKxo7J6xFf8UwIXlzQQ/
	 CkmTGYXiqSVQ8GWRnsJcHRvCOpZpG1U6wqjJMJEKEofBAfGacz2+hNvUoUzZAo3FEKg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rbMYLWqS;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=FylwbFYD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6089606A32D
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6089606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rbMYLWqS;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=FylwbFYD
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085785; x=1824621785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=0U56F+N1UZImtIuHHd6QA/rnLL5wwSizO3eAbA76BaI=;
  b=rbMYLWqSAMv78NBCTq7Pi5gGazXuYL0L5Yzi6vzRtkP+STn6FfNjLfeP
   QrvDmfWZQ6DvwH0iSfPsOgSFMgaSE1Bu3WiGTgRTfN0YGgWiaoHgXXdTk
   uU7a+AB1CEiVCvhgMDwWC/kPi8WZ5XwLNjIHfNjlgUz2NuB9lFfiWwD+w
   9ycpt6PsaCLgPcG63bEeI4D+qKMjuQdiQ+MTvj0zoFut+Vjrvs58cBM9u
   g2eDc41RDYllS+vDZIAqgOYVvAcHQGVj1oyAYF73obNra2hFYazbI2TeH
   YmJWJ5T/Y9vAzNMBEBU2bYH1czGHqVQ+aUwo8vaeu5mydumHVlNM7vKQN
   g==;
X-CSE-ConnectionGUID: N/punbMdTOC2F67po6TfCA==
X-CSE-MsgGUID: Rdozlo0ySBqwwGeRA+wIvQ==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863274"
Received: from mail-westus3azon11011022.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.22])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VvCRA3wufKauL4Ca4JlbzZOEO0h0E8JtgscdUttgzbSulxkDxpIcw5jqJzwjumqrhktwl5KymoufJuqzvUq6S+J5tbF1+aV15L7+/79Mt64ijfFjZ6MYSyG0P5lkqwhStG4zCz+b+dkEt3TFscpd2e1Zmbn9Zz4USC0hQt2Jf5MTYxhiwdtLGESJdsSexvblAMS9ElLo/EynasKXaoCQOrOwv61j4Ma8NdJGJahv/HKM4xuHf8Iw8C26vpotucyTya7X+MfJKw3F7N3DvusZRvnjdoSE0xXJABUbiyhXdSyhBfKRshs6TDVqe5KMHsEVJnh7FJC5a/ysShfmINlpXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XE06tZq2NI1oVEfIu1+/MnTJ1LJIf3sYhArsF98I94g=;
 b=bEtJiFabMeS1+LwATaFQ18tMXJpjEvEXoJkztvxec/WT8To7jqdZPR+31cojE9NfRWuc69eCWUMRseyGEgHagIkQWiV1B0AGzx/y8ZkjT1V+f0Q+iX8YO9oAvuqHiGA0cBXE++e1v0b7SgYJulLzZXFfxwun/cixqlAAn8X8hmCzRrVCvZ3GkwoOyHb+KcZq0hLkK2KSFkNY1tdjvr0DbXlWv0BNs5dy5VOQxfxqvjX2f5hW8OoMQeiZYIXPcIFcLH1BTRrgQG+/tNaYmlXSwxWO4+rhQYjAVR+0vnjnv3ivfC6T040/S4NxI3PhCgCzFPBHWV6BHx8b5ExAhIzh9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XE06tZq2NI1oVEfIu1+/MnTJ1LJIf3sYhArsF98I94g=;
 b=FylwbFYDecm8nNZUJeyWk2w/zLExoTMQsvPG6N59PZnF6cDKVnaLA5ruXMN5Ml3yqttCyyelroQ829IV/GJ6TC52LvZNPaHcgnXZzr41sbZmr2jOVZA0Lq6KqaN/SR9dECE1HVx6WwyIhVudi/K1+2QMxcvZPmg+Q5hsV7zuAWc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:04 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:04 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 15/25] btrfs: zoned: don't recheck the reclaim threshold of full zoned block-groups
Date: Tue, 27 Oct 2026 08:22:21 +0100
Message-ID: <20261027072232.419318-16-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: e1dbf4c0-1bad-4172-f678-08df33fb23b8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|22082099003|18002099003|261026121527099003|5023799004|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	tzJq6qwc9kdFsOcuFVtrTqCfEGOyi41buieIgGRm/L6RY6/wxGNPtzyaNjEUPrdXhoqWG1O4lTbxIFs2C+pfhWjQJRIseqomHXgkg5fbbIxuga62w/fEaOrby03GEiACdrzC2zhVR/p2GfLUwDpjZ9ii9AsiL4w9281Jwpze7lWwS67jv3XbxT723hMbkPma8AZCDKTenF13pwGtmEx1jpfkdqGdyIYdBu96hmQIHJ9Pkth7K60DDvtramE6eQtk00CxNvZvYw0nyat2r4KNkPEfNS90CSF+h51v7eeXwRw0PiaybD8hhB5btf2rMI43kvma++lywoxtzVnk66pE2rNMv9zHr1TmBPL2v/8eDs8DTARS3lJfvDknNPIqmG2fjAEoTEAF0XJELi9QPSYa6Rhfanm20ayal4Yx7t72e7SsuiMSdr4yM0RQ/dufWKjVx8oSIvEuzkT0+fRFAs+eaCszLATl6za9fjCQf/dPkxgHpRillwsrlJoxhlRBTCN4frLqh9FRanspyciFqQajVx+6OQs0WSXKjmFndH7mAmYClpIuUqu1ZX/ti+6u+NWfeaj5mSwzjtLJeT0LKJwkjteZu7nrF0oPg0r/vOGtMv/ApDGeugR002vWhl9YLl6XYWC0kS0br2G3vVRvtj/tK+n69cUbs6rNSrPLA/094E8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(261026121527099003)(5023799004)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eNk+BNWP7p6yn3m+E4RQtDKLbLHjLoeASBhL/5AE7c32/pzUneGnBOgrVRUN?=
 =?us-ascii?Q?eewQZHXYWLBDtExl0S24nHqdSsWxAamkK4p//HZ3CCfRm8DqhZ04/fDMqNcb?=
 =?us-ascii?Q?MGJlyEj7O85D7oWoA+9xAfvm07bNehf4Yy2fvbV6MlBzB56PlxZrhvsm3OgV?=
 =?us-ascii?Q?o8xg+Y+OHcXoecdsAobOZKiUDA92mYQIkqP8Aes8y/RyLJUbp9OpwX0UxbAB?=
 =?us-ascii?Q?YUbCdm+y6Q/peG/XS+Zcf2mstD22owhJvQThFwUZMjZ8S2vCF/P2tS+lK9XZ?=
 =?us-ascii?Q?dJyg1mIK5VuzKbav39l4RsuuiRmRilysg8addXISmKdyjZSuGH1hpigC7q/+?=
 =?us-ascii?Q?pZZwzppvoM6aqosKMm3Tj/EaodvfT7ckmbwlYzsJOjH+oYPrHG6Lq2iTBv5O?=
 =?us-ascii?Q?xWhlIPPWmQF2LV251P3HCbbvX9Ui1mDbPmXx+1iyiewvIo9/MB8qJnK4/PVu?=
 =?us-ascii?Q?ehsfbch+r2rMrIQncLU7pMcatJZU7qCk5/vUcbehw81npXYAF60qweXf4zko?=
 =?us-ascii?Q?8ZyYZgjJCGj7R2A2nendpYuvKlKt5oAB4Aq25sbu7R8Itgfd504rMYj4uZOD?=
 =?us-ascii?Q?NZRECY+HbqZpviH7NsJpCx9kCzmtAY7Go0PpBJPNB853qLaNs6uo7Ia2aX0C?=
 =?us-ascii?Q?+OMRll9+ktBAhYyZNJ9KcDH4RQu0ripk7DncPbYXxnEtmetU6M1k5tDrV6Bt?=
 =?us-ascii?Q?JSS3PfnqDiHWhmcPJnt8yBf1d7SOmSvKFpTevIHjZnQ/8SeIjZjK0nXXDGeb?=
 =?us-ascii?Q?UbUoT24ft7onfH7RzGT9yJrbedNFD0u6W41qsN9NZmttf7Qap61hCKew3qsi?=
 =?us-ascii?Q?/szLFhs/nBNZxZFqWO2ihhNZKc1DRYB0LEQCQ9NHPt/Xfox1lrvwHj3Nppbt?=
 =?us-ascii?Q?S8f2Em9Tl9WXNjPIEzksxxc9e+4EB5dqLJWTrsGmCf7kFIt11itcQ+KDGP2c?=
 =?us-ascii?Q?cW+pIhsvbatHkJ5TR4tPX1YCtx4rdAspBz7VZjIuNtPGsKxDWxAvOoe3jzrb?=
 =?us-ascii?Q?Z49fdZp62PVxCZQcOfFWicMoN+cVKQId6N9hmAcT4/JEOTldG5QZFUC34s09?=
 =?us-ascii?Q?xv6Jbcb6KGSdV3c4Vb6aizQids5/UAMuYJ1syRrQlOiRu0LEZ7kbJTMRdXpl?=
 =?us-ascii?Q?ZNOsw8K0lZWj0bpF4ZQFcvs7pCXSfbpk1OjFh13SOJFfsNT+Z5hVcyAbBbXo?=
 =?us-ascii?Q?oTRjv/nadU+VK56hE7MahmHy8oR9sFgXU1QBMKsi2Xjw/14cNtkV9hWko4od?=
 =?us-ascii?Q?e8+XXABPF61YyxBUZet9isX8G72hfpF+WKtSB42cI+JK+PbCe6NHmCWXFxzt?=
 =?us-ascii?Q?57Qcy7ZSGAMxbRQBM/5lf0zfrUqUvg/4eOtf0jLVlYd7LLxpoTYSVaGfeOBi?=
 =?us-ascii?Q?AUWCScuw+VbOZQFVRwTE7qg/H0mzddxCeZwNK6VCAuhtotmmRgqEa4GSwI21?=
 =?us-ascii?Q?Wite5ABQIpg4z184ufR8vbsTJWyozDJxH/i5c0Q0i0lc/hz3cggJs8D5oJEO?=
 =?us-ascii?Q?heOk96Hk2q6zTIqHkkflpkXlWS8hsQ8zxT/g61Qm5b8yWwxzruBuADIWeq0P?=
 =?us-ascii?Q?+1lZxs7t0VE42pjhuBH86vTzJOJt74Y02vcIWXJ/6BRjVqHFMYpQ6IZWrDRz?=
 =?us-ascii?Q?TzU+vncE5kw2JahKhCINbArz4Tm9yXBGjzeSlIQyRmjZS3ACsSPT/j6iYvmu?=
 =?us-ascii?Q?HY09V4MMjq6pIEH7VGlZVjQUFNnm1PJ5tmx1QKgEiFIn+cRyN5f/NyEmNO+v?=
 =?us-ascii?Q?SwanVdkeLQaNndMqrphE56Qt/LPX+Xsp2LlFhY/Mr1KFc7XpqFxxb66OGiyR?=
X-MS-Exchange-AntiSpam-MessageData-1: p6ISIcIxs4dbB9rTmp9hR4Uq93tueV2YCoQ=
X-Exchange-RoutingPolicyChecked:
	hm1k9Lr4qNJOQtEs8sAXIMyBIYxLf7is3oJ80tt7MDGUkzbKK3JJyZGzNjwx3YyDrHXYESZiC/1w+QI4nhlpnlVglcbToUTWBoOy7fEh+g00F+chAXhF4xi0UTqcHibW2PVkzNQa7ET6BZTudvWHH3mWn8qpvYSOyxhkYxkcWtHU7NGmoXYRmFaDxgt6Yyzc1Hm9eQ9rMbNQqXi/NjVw4mmS2YGlO3U5M74drtzdFNB3rhJGQhuI6G43pwPzEyX6ymoLxCb/T/NPHRWYgqxAyP7DcyUhsDh1kq8Sv9cLmTEK1rfxfO6qi/m4m9VnhnNejVJQHpISR8c3ff+dSGsbzA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VhZ0Pn5Q1oWqtrLDVYIkeH2ZtDPd/gZOq9zC2UMy8v5DdyV3jZETkXJGIh3fHsIbybjoaKd6PYwUt874OZqGR8SAJLRwsGB9WWkIBGf/uHrKxQWQT2+X+T0GgHrZmJPe3VuiKxkopnRyT1exLpCsufGiEYaQZzGJP/TgXudL0IQ1WahICrQdJWcDrXftjRIZ/QuqTKdOn/jKF9lpBXLlTmio4Z0g7GWGjFbS/07TOipbjXffMQ6kR83/wNUttKxL+Qz4kpxhwDwT13Ut5pjXhnum3F+WSByJ2HJj5iafLbRVpSNkhPCRgfavpsey8exIgv/iiM3LsYdfj/sYTrlw9WRPYVZPCFkycgJ3mzzZcW7truBuVSXjoxxYFHO3mVGzl4JETn26LwJCGoflUeRSX6QHNHhTKNxGANarwfyV8s8n6Uclbdji4B3HnwV00K83N6336bEWeghdlPaO8v0bddxbIs/1DyMgM922utLlRRNpFw0jBLffybyy1Dq9/QD8uklrvj5FwW43p4pGXEUWDCD0rq/I/RZiSdGQqzlHRaZY+jRV8EjVYpUSUp/4MPvOH5WEImSufzyFWWdr9sNsnkmIJwlY/D3mr+DuORx3KMiaPV3Dm64m06iZOVgASpsv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1dbf4c0-1bad-4172-f678-08df33fb23b8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:04.1286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2v7zL+DsBRS73H2WstbTD36ViHD0Z1UqcbJ69sRPfFIsUpzyVH+PRvzwS8chGMZBH2QyLhth8JAMOb8/MTKsifZMe1S2zzOg1FCXIRYPlZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

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

