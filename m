Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFF0361DBE;
	Wed, 19 Aug 2026 13:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787145434; cv=fail; b=hhh69FmE3g8McgqcBjtGDMLNc691Iqlz2gMy5Xrn4CbIPrdxPMAwHp4F8aC+jcz4KkIQrOFj1V06Vr1VSyNVe1m3oVNse5Rpau9XIhKhXbpqgA79u9QPIGSjpvs4hak67yQXmae3G2aAmVN2e0SirMxz32aWxN2jOi86lzq1TFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787145434; c=relaxed/simple;
	bh=lrdb2mhisB3QAVcf95Fa9ZIO7WVnxS2Z8/gk+foYbac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OMVeu0dTPYYSuljp1qy8ilxKKIeJKBrujVxIazbbVtPF5BzPs3psNKTPSLxQivL2SJiuenPIAiQfKD1ekvvb5qpBB9I0FljJm4KbCbrHk/LfMhgakx03pOQU1An5/5FT7WPfYNMV6Vb07+OZjn15RuZJOGzqEPsnqQ7IVQQl0Tg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VzVP0fxK; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Pc19jF/d; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VzVP0fxK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Pc19jF/d"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787145433; x=1818681433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lrdb2mhisB3QAVcf95Fa9ZIO7WVnxS2Z8/gk+foYbac=;
  b=VzVP0fxKFMi4yPPA29zG+P2e9NswrDkUKGJ0z6dy8tx0RZ6e7xa4BgOT
   5N5Ldn0/67RzyOyP//UJmKSTQaaVxu/JNVlMp/3r90be9kjQ9Di93Q9Zj
   RDHQuxNBUp5bwXtOL7j9ZhDL3gre8wU1Ykf7v0i4aov8c03C/eLgQS2lV
   63hfE1zA0dZJzg4Og8paBECuSxu+DtVYxxsh8tX/F2s6hS6itHLgITXCl
   8ac+utCZPc7h3tDyHTvmVLee3FA1lUjIoFBaVUyRBsfufFwa5v31s4mgE
   ehJYKQeSUj32mMq0eVWCKkIm9jiL6MRoQY/5gCW9fQGsADNOfx+iU3tIn
   w==;
X-CSE-ConnectionGUID: axLhlqXsQaC0EC7LSV5toQ==
X-CSE-MsgGUID: LdvOFNteTM2FjvT7CrsvwQ==
X-IronPort-AV: E=Sophos;i="6.25,231,1779120000"; 
   d="scan'208";a="154760878"
Received: from mail-southcentralusazon11012016.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Aug 2026 21:17:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lWBhsvTNVHSYbEWbpURwfMm9lWItzE4jE5W4fOqOYRPTQbCaWklr9QpclP7NadOsvcpvLqiUSg4cXaSh9t30ikB74/xIvu+gpOdmaAqQhwF7NnQ6E2DBUZXck7O+kTf8sHASvJZfFN+073mjldX+uMEP0K+qF4kd14USy6VNZFyPaGsv4/tYlXJU+FADvecP8ul5UhwwD8EnHPlhA4lt6WImwGIO+wJDn38gO9b9nKK4YL+KEX7vlv5ecIKhIOQbqIp4v8XDJYbEBZu4T2uceJZWNRdCwgNEPbZaFhlqX+jw4GzxKGJUFLb0kUx19A9ZFCq+kB+Ixc6crEKR9WBL4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Its89SNe7TJ7bhQL4OQXhqmdyPTrhXJeQlqG/9kJtUM=;
 b=njcltb24/XUu9smNI8XTFUBwp8RkJ9ENxDMl2y81flgsTbnMsKBJR9Nzm3ZQYnhTSpTI3I0dqDY8Nh539s3XVLwKzQ/Hyo0RX2SzAmyyHp+jdaHW1tuKD9htiIaUw0lq8iLYwKZWrEsX6Tz7y11Tv4RjRAIeIcyStROjg1NHHG6FBfH7CFtQA47x9hOOt8iPWxqhYfMZVvpfSTlP0ClYj6wlR9hRNOk0oOMG7/iv1Kru9FVLmI77Vitr4gvOeKl0y8E5ubs+YMNXfjwRVzKej/jNQ9IN6+PjDGgve12u2aEQGitV1CqNrr9tkhPgmyPvPbEv+Xa2v5DE3PC6cOc2EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Its89SNe7TJ7bhQL4OQXhqmdyPTrhXJeQlqG/9kJtUM=;
 b=Pc19jF/d/3V3KmPpUlpnnZrL0aRDudeNG8FfJEnrC84bmFoIh2oykK342eCe5qEl+BUkW5fEjrF1+o0p/JF9P9a4DrrZnG9hvcERAhGuFstE+1bJPSP0+J7sY44nbUHcAb2aFr19WRQPDBeTYMHi9yGZY4h1gDtvHaYf4y4+ZDc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA0PR04MB7385.namprd04.prod.outlook.com (2603:10b6:806:db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 13:17:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 13:17:11 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 3/5] generic/746: skip on zoned btrfs
Date: Wed, 19 Aug 2026 15:16:03 +0200
Message-ID: <20260819131606.1478488-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0396.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA0PR04MB7385:EE_
X-MS-Office365-Filtering-Correlation-Id: 277b7565-f0c4-4b3e-eb0d-08defdf42d4e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|23010399003|19092799006|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8WUuK7W3h53JB1KJ5vtZza1X9biQLq7g+MjH1JMqTb+eCqRA08nOGgC4xAx6qA4defZFKipRKt4cIyKPoKOI0r0RJkaUG/jpHuoq66pBnhjiLSNCw7+SfRB0Xyt7DEJ+Xp4JjbODNhZedKAH5eA5xObR1INjmCJjZCVfF1V4Utu1/dNF01T1NUgN+IRlS6SgmEC0TYUMt4wtCboqR3hA6TqQMP4hMnaU3MMhIWYftlEFwso6CCgeZrgDXvhTY2ehWKlp9R5i6j2IbKBTvT8whhBTp96Gpto7VNJAgp+HWi1gjd11uqUJXInvqzt6QbpD+pnYFuy45X+m7jPdqVzDREFLOTSGhfSaEjQDrQe+tWAOLjvbm0WhW9wC4lluOa1nXsl1WKzdzor7hcM+OWcSNwcRcrhZbz5mrKSZLHpziKkn5Ofe88XNa+ZJ2mc/9S9unCq1EJCJRX5ArLpKibPJvMOT8/2jK8elQBijGY2ZBLaNiA0onL/gVQhyFpwEka+VKm7dJeHKH06gtKTqalno3FNCwutHCfxgjyH54ml5e0h7hCy+97M3cXdWsb1HAFIvH9May8XWRW6TqI1U03XauJpCAL9kkNQYL63uc+iy8Jbplsc4W0LS5OT9QVLME/MeOr+kjJ1syOjHG41thmKUs+TYldJb81xsrPL9Yy4KWTg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(23010399003)(19092799006)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RvAwVvwyci6PBWW41g3WaY2nYLIOjYL3HWSrTGeGrWIKU6E0dDVBuz7TcEpt?=
 =?us-ascii?Q?qYeJgn3tGeKsQp1QqNLeJgUECsYnV6bJPm6sJpGFp4LUGDVV7SbEnrDAki9K?=
 =?us-ascii?Q?poFkDgYChjV6wHK5dqFBIs4HjqjBW1HJ4cs3KIdS7MfluX0nBAKwZL6RTUxa?=
 =?us-ascii?Q?jVV2JpkAX2sEHKBWyo/81ZsKvZwPj8qWGu+SbVYa3nIRkNavNItOr/HThL6S?=
 =?us-ascii?Q?YsLQHkC/VSWPtSpfueMx11uhqz61khkk9x1kUJ4+q2bbSqDgcJsglFF+koeH?=
 =?us-ascii?Q?J9bJoM5dgzzb7Ie4rSjYIvkmZR6YRUd/J83Rcfl+vEeIyc8JaWLJ/AYBz6MA?=
 =?us-ascii?Q?BvglptMOr4n9O2Y30kHzG23fH0ee5DSvkC1W9iRgVN9ofe5pziiogozn6DsH?=
 =?us-ascii?Q?0XAJofaMyuNHptF0HKw1jkVw++pbbavlyjv5pVky0MS2tEtITHhLsMalvtXc?=
 =?us-ascii?Q?Hd/9bkjz8jSZhXPmVhy95/xZBMktg7DVfAqyGMLXTMdKIzWbfUC/wnL0pz3X?=
 =?us-ascii?Q?KIkUVL0/5VbWhOqQ9BZeYTnW1ahbvoDfQ5GZBBfR2LLQp5tE0PLI2HLDwZbW?=
 =?us-ascii?Q?YuJWxazopVWtdcMm72g71PsPnS7aSV1NtGYOnHoWS7Am7GzuLf54DQmzSHua?=
 =?us-ascii?Q?5YmAtVEvcXxauxgoiE+Nvjig7FPgri3isKhha1x0qeSvpNmlnBEHR1qrdsAl?=
 =?us-ascii?Q?LFUPdNTWR3ZZzKMf/DCvy32gT44KtcA51rKSSamyVVq3TMU80uGhc3cA5Bnn?=
 =?us-ascii?Q?k03R2iNUo+MzDTOrR+nrjIzOqMb7/kBz0f2mAwAVhDUJpgalb6f55T+10VpZ?=
 =?us-ascii?Q?FBcu00Tx9uq0Nj7Dn00VTOFi2CKkL7T35RYQutI6nSs+J0tE5gh+wc+VOIEY?=
 =?us-ascii?Q?/21W3zgkeOGKXIjhHtRB1Fi5cNoRmjzoJrVMcv+1ozZXkCetIPMOid5vnwMW?=
 =?us-ascii?Q?64COef9bWwirqvH3iejBYIli34DfQO/VmBWD0CF8LgF0Fka1FDDoQ41keqs8?=
 =?us-ascii?Q?yB8X+kubufvvMnzDz5TLGFgLI5BMjNcoMkuUbv65N9bVSD32D3D3hEbtu9Pa?=
 =?us-ascii?Q?rYbphGadWf7zGecoLITFqlxYMsPhoovRZw116/A+a8aT19evV640Kd08OrXP?=
 =?us-ascii?Q?YBS6JlBR3900gjasX7KzTW2ETJzxMhKToaMTrzS8JigMeoNZwam7SQteLjKy?=
 =?us-ascii?Q?0RLp00SaSW+rctObpjUb16Yg2RlgUHpjDau9jo7a2KkGBNTkl/MrbH2teahO?=
 =?us-ascii?Q?lLwW4z0FUTqcI7EUj+I8ckSjy1W0GiOKeQa9Mbk0YCKaGsNuaX71GMzsRyQ6?=
 =?us-ascii?Q?OGleomnaIHOpoP9jUDxF8YQBGCjDAl8RcX1XshrdmbnzUehXWDtrhgLeIE6J?=
 =?us-ascii?Q?A8VZdo11zSSzTNg3sjetePWKVpUO+q3pbwTZ21uYduQXlpWMpUboonYV6a5P?=
 =?us-ascii?Q?hTZr8p4Y4qCthknB9zWFVtdXlitz1JZRcF65+0y44XpYKD3sk35OQEnae7Nv?=
 =?us-ascii?Q?wIFmsAxnV41GM7MOzdGjwiLvTDlwmsD9UyGNpok/r5xp0voC1OXnXoE8w0Sh?=
 =?us-ascii?Q?sK5Ee7ZD/2muBgEAydfOff2kRFKVhxWYMfxl9drQ+sBIeXTZaG2SDgLcUXpy?=
 =?us-ascii?Q?cN1oBAUV/6k1o3eZIeUrxklvl/xxHx2bjHPF64ZLuDn0tO4WvrgChyaye7B0?=
 =?us-ascii?Q?YPHue6NujGU7zA5vHTeKJCUtPUPe5Ia1r8kVqIEzwkRfg5ZDSH6pT1jGSVw4?=
 =?us-ascii?Q?dZBdRhQ51d9LgCBdhcPUpte+fbIcorjPEAoz9sHX6Db6x2Nj3uX9aVOJC2NK?=
X-MS-Exchange-AntiSpam-MessageData-1: i7ASdv43YtAu43HXRSje4O4MWohzhGxFH9o=
X-Exchange-RoutingPolicyChecked:
	HPzM8C/4qT8NrzEdlNM1IEx40a2on0pl/YThLPmoXioCPY+k0YGjqWCrjsWkBzl9ppyIDqpedLpGBOJadK3PAEy3C5aF4q/G636YjUifxT+9stP7tSUPseCKmzsd/ZBZLGg5dtanQR0RH8ZoKBTeP/yuTDmIekIhz/pKwOb9eR7RQ+we65eUARPO+y7kv6fvGy/Ziw/VL4qyhqoUxZLNyYv4MtH0sr1+kmVlrdQyUDiqjSgOCb0bXcMCoJL0KIXJP4yQYsSsipyA6nTp+PXHY4bPcsWq3jstejsjM7ulKoWkfrr3Yf7HJ6nWu3Eqj8kUlYUSfi9m3qZEob6qGjhU8w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+8rJIsmPJbCZ0X57Kl1YbACCF4O0uiQrtNXWk/QVW7pXdYLk0roceJaZoB5Cr6slZbq6KvWzBOpLoNytJhRkGqtgOK9RHYmW2pBn4U9mEdu2LHv0cdTmKt/rNsrKv9SAellgb93ljD4msIGrZIU9E495Y3wcfd46kvvUdZiojRybSsVUniaRDDV7c88TObhh15zC8O7JZv0XzNNASKdWTXmNbgCoedJuYk3IVlENnVlw3ydL3IppS1W8rxLkKub/K6XooiD6FzlYUvdlRWJAUsYSe4Rb7vbGxiAGdXCk6XCYymdsVYVv9Qr1IIo5HDvRF9lAxrHt++4wGGngUSaDE+8UMMv/1U9zfwGa2PZUP2b+CvC0jZXf/1WhGV18/o5C6SOfNgXthIL7BnR2Rx+cNtJsYLmAHTwpSdIHUrTuNFDMGKmEC9Yq4Vyx8mM47g5V4a0ZTP4fNJsK5+Y4qAzIyetbkiES4S5QmrVPqTemN/aqOXPBHsTRJeVV90l2/Z6eTFf9cyO8Loc+yE40ljTdr9n2VSrtxTomYzptYgd3Uin021Y6tBn5Q/zPy9Sv6bMAD23U0MlG/LXz5qdfoGnyvBgGTBMUjcaNItpYlDtUanChVzbFzn1CNGxqiJo7BXS7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 277b7565-f0c4-4b3e-eb0d-08defdf42d4e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 13:17:10.9490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5mR8PvF2kiCqJxEaCeHbxTfNwM2/5wMXKpQoY9+kcqufFkTaV+N0QxiDXi9drCQYZBG3D6Lsiv+nRTpojTmQhQsMLNJ9MtVQO2uOQAJef9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7385

The test relies on loop device discards punching holes in the backing
image file (holes are then detected via fiemap on the backing file).
Zoned btrfs does not support fallocate/punch hole, so fstrim on the
loop device cannot free space in the backing file and the test cannot
work.

Skip the test on filesystems that do not support "fpunch"

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/generic/746 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/generic/746 b/tests/generic/746
index 4eb4252b..be6da079 100755
--- a/tests/generic/746
+++ b/tests/generic/746
@@ -13,6 +13,7 @@ _require_test
 _require_loop
 _require_fstrim
 _require_xfs_io_command "fiemap"
+_require_xfs_io_command "fpunch"
 
 _require_fs_space $TEST_DIR 307200
 fssize=$(_small_fs_size_mb 300)           # 200m phys/virt size
-- 
2.55.0

