Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093484A8A08
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979467; cv=fail; b=cT6FvzR3fQbClBPm/16GWEpP1kiqOYOAFUDowIk2izPxtk7KS0tJAnKlih7N10VNloPAN3ejnjmgnwK1q94xI0gHrItDr/yHgSOprABsp/szwfwc51aS/mDAJcJslNSfQhHLkNueLUnOdD8F2Me2JMRfoLE06t9df8g+WBGOJLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979467; c=relaxed/simple;
	bh=2N08xHR+g7HrFPeLyl/9jEzM//c2BzrrWzlUtvGlwDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h8lzdwzPkg3BuPg/PiiHuMmKEzDjqWuRiEizpRL5zlcewkQOcTKm/yzzAQolXifxfzG2/TMPDM2+tOoBeJ4tjlmscnryp0HvlQsB8BB0wymcrRToAdHdtLNVG8SOazV7suhIG54K+bWBmRofOKy1TofBw8vzmqbBT6P1e7dmQy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LBRrSsNn; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=xFy0jmZH; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LBRrSsNn";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xFy0jmZH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979466; x=1823515466;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=2N08xHR+g7HrFPeLyl/9jEzM//c2BzrrWzlUtvGlwDA=;
  b=LBRrSsNna8D46W97+Xh5WT0UlwYO5W1ILzi/VumNvULGMzJELq1X4tGk
   FL4COsVvat51fNk+GNfSZ0+6XIcGweEC8839dWE2tv4PIJEseG4kPseeg
   asz9MBUBE1de+r+Vh+RarBO3iE0mCdqZCpGd0FV5L7XdsjM2MmEeb8J0A
   etHtZirHmeo4MK9mGhE++rEZPudwGf9ui7M5/ikK0t9uC6FkVZ++ruUXq
   PIqs1vArfljAbLzRMcRZvVzwr1u2PkhWTs1/886oZFViG7oEjlkIP5HLy
   5o98Mja+l+Gcak3Bbaunkx70oI1h3bpM3VN6949HAT80x4xkojqJ6i+Xp
   A==;
X-CSE-ConnectionGUID: 6elqJSYXRfm7dsQf7nnBNg==
X-CSE-MsgGUID: zrt29WNVRxqm6j8ZtN2Sfg==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077281"
Received: from mail-northcentralusazon11013060.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.60])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rR5lutdtIMZvW9VJwPz5W5YspWzdbarmckpxQPtyC9mz7/YGa+Ezt6tCku9qvCsCOACTkX+JPU3nWW+iV+H+z385gPF4csrjTVuc57St0IvQVVIb085BFWguSj6j6SN+aF9sByX7FV6K+QlSH2FDa4+ev/1AAdm+Cvemp2JXcZirPn1SibU+gyQz9E89QSkAnX08aULeCirLfZwwi8MgnorCOeUCTp8KNAjA7EK2JwwNG6vpR6g43WSxlXpYsslfBheOaxfUMZeoYeWZXgwAVU+NudwxLVP2bQADuD+rExR1QIt80Tb9fMIY/TUBQVt6P02pVox5og1CD0jHLsSVxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XvhosmzICPSxqpfgmCNUEvafXXxzsSQfE1vTazPBKSA=;
 b=PPIpOhlt72fedTrUu000HoQW3C0w++sdPwIqbbdPdQelDSZQM2i0i63LnChof40xWjy7msYBmpO8QTo3L58JygxM2CEsBP2tBedJc71nOtBLFgekKbH/+E1QqQ9ZTEH3BZ57R/NqooKKHkw/97EQbqZ8fRKVcGFJUF5ChwS9oTVhD9fDzbM38ElPeBjYkoJd15iEdjFjIQv8+V13yC2cWmhSRZW+s/Rq2LaG1V6c1uhTbjFdHDP8XS4tN5YFaSyNKLwu0Q07KwUI7HAhbZ7wwtOrmB+kKaRu39Y6z1WklCfzV7sxrVTSrXolvQ8mGdaASzi18Ii2S14yJ/BJgS3bOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XvhosmzICPSxqpfgmCNUEvafXXxzsSQfE1vTazPBKSA=;
 b=xFy0jmZHzXyYeclrw3O8nVgtzLjjIUh+neCS6SGTU6vg7FN7XNlDRRnizJLTIXhQJXMp38K2jjUo1qsupHGa61L6rXHGtKa1IFad2TFER/0i8sKLyBm9mzZ5XeMUvXWCh2AG5AD28qkCRhhKFFLOhorap/biPTIDZpCNha6JLaI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:23 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:23 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 10/13] btrfs: add btrfs_bg_type_to_num_stripes
Date: Wed, 14 Oct 2026 14:03:49 +0200
Message-ID: <20261014120353.757931-11-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
References: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12)
 To SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: bc19dc5d-8183-4381-9287-08df29eb4950
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	+Ru/ZQyQCgSVlYuuOv/OgOWylHte64GI9OLnSV3IwN7IbrDNhykFFbJvSxRbJ6B+VFtsTxzvEFFcNCtfB/WzAW6xjZ7wPSgHFm0Beq8233WhPM2sXbAySjzI30ZKefAKK+fBVfiEFJZzpCxi0Eao7g0ZSimS8/Ql6+Gim/Nrp8K0I8e+zLyWV6Q4gQoMojydrGETk28uXnsMv8ucQySNYuffUGXQ+nNFrcXDwvcLqUjiv1K7bbf7tOOfEnfx9EuGUWn9sYP0Y8dMhB2PGVr+wOKXgZm/ZEZXXmGKcdRLHqAWwu+lYdJVX9sfx/s4IUtvvOUtw9X+EbQbaXiKbRmWyiAI/cnHUwx74TbzzF7ZdvCAlI9A/AEyjgBmrn7aRZEoWI1FejjJtlzTxjy9ZsZgj0nTktrpOseU/T5s4cu0PVx2emiPlh2ZUIDoY1m251el+bpm4XCOc9vH53b2Plilf+eSQOiH6frup+O5Y4vYd9PqLEn9scstn7/kEJKOIiNS74QW9YwEZ2y8B9VcqUbXUIK71hKGayDBPh3MhcGdN/K5Ivt36IalviiHC4VJapPvdGjXqOiQEQAX5N+33ohOxXrUQjm+lKMVZqbUXagNLaZmVuXS/chCPBqVh+Lmc/3RllKQSpH1lG74MD5W4oRyvamWYlw8pTaykWI48EszArg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7VYOCzBtZjMehdPQIyaQsQf2g+ahzmbm3PtaMrm8bVqr8wwYO+FsnHY/Jkm9?=
 =?us-ascii?Q?0WMLicNWM07upr9LFvzTgBvhv0lB3PcVVA20jDa7DH7aDhKRn1a9ujDzh2gv?=
 =?us-ascii?Q?511OXoSsilPKRaLSTIMwgkGHMXTKTiTqjsgNDsRBG2Ft92AuhT2acTuM26XO?=
 =?us-ascii?Q?HXDtH20ernblxXO5/kzquTzDVaYKjqK7ZITDS834z5cMj3Z2Ogf7R+8eKutl?=
 =?us-ascii?Q?dg/mg6t1WrePEx4t8RsE6wSE2kVhyOnkJfV7dccdcwTf6ARskGgNTUYu1tTt?=
 =?us-ascii?Q?xAWwN0A98mYXjD5RdJqshJpJItwaRSj1fFhH2TUf3/VMprdfE0LSdtJbOWOF?=
 =?us-ascii?Q?ZHNg3nZeiOabvOshstFJfUwE/wugwAwvUbzNFTgmWB5dRdq2gZjNw0Pt9LdS?=
 =?us-ascii?Q?u2J3bWtHSYO4HJwhp/PlOZnjYvXQcPFHtxBw2plzBxQ4CVZ8PCgTee1LmTSB?=
 =?us-ascii?Q?PApRKYOAeJlPnm6tg65KnQNfGpQwA2jNSIwChAOP1QRqY8cziPCiU6CXoUaV?=
 =?us-ascii?Q?rcytG9fNBhoKTF6I3UxFXBkFwCAy+pDJsXw4dwkmv7UnRIrvpdxQnPoCPfBK?=
 =?us-ascii?Q?FiHpfXwSRVqUmTWU2xKqqwOvIVcPRT7UkMMgFANPUthcok3DdJ5evRqkAgm8?=
 =?us-ascii?Q?MGMYndeyrMwNx7RqZmeetta4LT/nJIhNlwRlxGHYPehirSaZ1A6XDfxMSAep?=
 =?us-ascii?Q?vnfWTuNPBtFJj9e4lHAF6LvoZPRoxjZ+euhOF1eFSoRnT5umqWUsUHy1sELb?=
 =?us-ascii?Q?Y3J/FLrEyDjombxDUSrxorJtT0wDYUk4snZY+C99qWL3rJtw5VopwPypg7yT?=
 =?us-ascii?Q?46z3chW2z8uEdjBSMqYhoBSH59srSE27OksGS8JLSudov8CQFL1qeBkGt80U?=
 =?us-ascii?Q?Y3pjq8tZToHQ/otoGKRM2jIhdNM5GLPIlA21q402eDT9E0ZLkzWJ8BQx76SL?=
 =?us-ascii?Q?syPiYcL9oV8bs5duEo3ZCc/kJDW87MGqtuUHG23gVfshZKv1WZiO0I8ql151?=
 =?us-ascii?Q?M0LwYCkHx1QDyhEgK1tkjFVRv/C16eHl3SOBXjYB5VPWEKmxAXARsLsN4uTT?=
 =?us-ascii?Q?4yycDPhgCPttnkIaXRZogx9ghZpSOTRwdLLkTSuLY4yKYNSEy9MAguvGOHa5?=
 =?us-ascii?Q?mbPBNcJOKjtMFd44rkg2XoIa7GlEZLjrnz+kgckrK6PtOKSgkIsGJDf7DN4X?=
 =?us-ascii?Q?z7Ss66XJ8M6uZvbNKmqDymPOdame6xc65/g5k2Y6lknh/d4kw3HkgwLDh6Z2?=
 =?us-ascii?Q?PPZErgq13d3adpzgwa8JAKhLpWEhe0Gw4qmaBYagRjE+GNRfCN2TYrGjxsbR?=
 =?us-ascii?Q?kWs6HJf/2Sj3mTKSA1rDN7QzkGS2ve8V+cXK0GsiHsPE4xjuzIEM6L/tMigI?=
 =?us-ascii?Q?6eQjUtwkmDYhmgRn0bQlEpY5a1rh46fxAsq7jSCUdWxOro5+vYwKXhl2db6H?=
 =?us-ascii?Q?9RUmvV/lPke9XXgQLJyRlAh+xoSCyTbwmEfEYVR/U56w2TnmhPa96CyTiPMM?=
 =?us-ascii?Q?LpCIVDibEkO1lX1ltccPvhCCcmstQB4OAFeA4IlIHp7W+nbhrQ+TToL6aH2L?=
 =?us-ascii?Q?HYB+f5RRQUOj/a533896jly+/uTOZ7cIvEqSsOKvLAYFA5jKD1lSclOhzSzV?=
 =?us-ascii?Q?ekMy1IpLKjnx3eAXqz7z0kDhecVDhXQC+4UkYGD1FYVihcm8K7o4X1D6IsS3?=
 =?us-ascii?Q?manUUFRH1z/spzNQBYd02ATRsYDEazc7ZR+2BMJBt6F0lCIE4NYxwuwPXxHT?=
 =?us-ascii?Q?V8CJLfOmknn/kQYvfcsjpx2YmuyRy5cVyRqIABYXwPfU2BviXeN8fr3ERhKF?=
X-MS-Exchange-AntiSpam-MessageData-1: 9Vq0qpjykhYByqxOxQRo+lJ2CdpsfPjrP8U=
X-Exchange-RoutingPolicyChecked:
	3LndFi6rrO3lW5LKRj58ELVHGOUIEiBcetRDmJrQegnDbNVhFgwe1XaYAiwEzhB9MS9vAwPyUAkp2zrecwOhkbTM2Hlt7DWwb473t8jjeQnoZN7JY8XE6gwFL0OhrPFLwxFaFXw04LEgFPHMdP4tHx1/rmycni8qlRdWiHuAyGouwNlMN5jtwsqwLl1oDj9tHTPUdbBq2j3v4IsjlvsNLDN+b4LufjEwo5XIxwNqZbUKL2rrzhgLKYYMSr4H8eNq5Yvc1yj6/W5Al1GNIHhCp1WzCiAXe6uy8tAMAi1q8RfFznbVaaxQp2UhMR6JXRyeU3MHY45sVX6LY2CrEAlOfA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K93IvGABqTp1+TABNyG2L+j2qBBRErMm8Ss6lX+K+MJB8+6X4Jpa95g+4CDJohRDKzeMqrMxw4oksKSwFesN3XmA/V7t7PjC46O5pS1seOAYyUd96j5qUzHriWtF+46PdRxkslxZlO+NOc1a4A6hlWt2dO/oQX7UFCXccDFqGutT/xa6x0udCPnH+Udma7YBNr7PtfFmLSwO24okHeejFf5Zdeeh816PHH01hoyHiaFlbTU6qyd9h4IPXa32bFcqmHu6pkM9NveJFZbfbC8RYWMNcWMt4j5SOMx/JgtUUkFovAHGDPMECoiAa65WfNKuePXfivI/Oc+wDRWtf8TJa2QCaRL9hdwFNDXly3DOaIogeeqSgWsBB6/CKWtv3iuTjPNJod2BcZjnQC6L1kul9WcbGZn9Lb7hKD5X1thoiJVHDc2rZE7CIj/pL1kSzBbwwOnml0qMXbOGwSJ59tdX/J1LZCxhwlcbDNanh4g5vodPpLC6vfXVIpNDZQmC6BTvML8sIkbqlb7FXPxobm5vgwXmAWROvWcOEJEBEuBIHAVXBZUbAu9sy0rcN5BYgYlh3nFJADerhQzJX9wMqkiW5vwvJoQHAoTR/P9g/IElnPWE8zaDuY9MHqnpv/kjdA7V
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc19dc5d-8183-4381-9287-08df29eb4950
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:23.4711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KRDyWv5Pp+m7jd7vnbcBjAOkDLwLRSHF211ipQvUWNJorJxsN+mTKx9s/7c96wKmN8Rx1+atMBBrKWjyQpGxMJvGg3VG9CpQi1e+7WveiAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

Add btrfs_bg_type_to_num_stripes() a helper to get the number of device
stripes a new chunk with a given allocation profile takes. Profiles
without a device limit span all writebale devices.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 13 +++++++++++++
 fs/btrfs/volumes.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 318f803addb0..d95ba7d93a08 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -195,6 +195,19 @@ const char *btrfs_bg_type_to_raid_name(u64 flags)
 	return btrfs_raid_array[index].raid_name;
 }
 
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags)
+{
+	const int index = btrfs_bg_flags_to_raid_index(flags);
+	int ndevs;
+
+	if (btrfs_raid_array[index].devs_max)
+		ndevs = btrfs_raid_array[index].devs_max;
+	else
+		ndevs = fs_info->fs_devices->rw_devices;
+
+	return btrfs_raid_array[index].dev_stripes * ndevs;
+}
+
 int btrfs_nr_parity_stripes(u64 type)
 {
 	enum btrfs_raid_types index = btrfs_bg_flags_to_raid_index(type);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6eddda239221..2847bf9c9342 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -910,6 +910,7 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info, struct btrfs_devic
 enum btrfs_raid_types __attribute_const__ btrfs_bg_flags_to_raid_index(u64 flags);
 int btrfs_bg_type_to_factor(u64 flags);
 const char *btrfs_bg_type_to_raid_name(u64 flags);
+int btrfs_bg_type_to_num_stripes(struct btrfs_fs_info *fs_info, u64 flags);
 int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
 bool btrfs_verify_dev_items(const struct btrfs_fs_info *fs_info);
 void btrfs_update_per_profile_avail(struct btrfs_fs_info *fs_info);
-- 
2.55.0

