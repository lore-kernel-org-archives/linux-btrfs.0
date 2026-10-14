Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7A84DF4CB
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979470; cv=fail; b=HeAf+iy56oinJewUujGyUiK9i+twZjHBQVr05n8U1p6Kz8QIIozjxC+gGQJ4oBHZBbjapN0wZAhSb8MfrSZMRbUrLC4FzdGOs/YNDG3368yK/PmoV+3WvCZQLGUHi6X+JdG3+zVgJODjo/Ir3GxwGi1fEyA8l4ihpoRw7GrdTwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979470; c=relaxed/simple;
	bh=dHA6NvfjKKTya0oZneMJ1ApLH/4rAvOFxIIzmCrXGQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TA7qfrPHfXUf/Lr4YYyz7sRXrkocoBdXGtdHKaclM1aC6thKjUhTWcZgo11hNpAjrnKkcYDmLSm0B7w59aZLzMgw2SQh+SxcY3YHD8Qw+PXMO2GU5W6sCDZcDxSfOuG1cqPN0ndM68NmZGgwVueUgWO0tS4DN+pXGtAUvC67eDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=V+17/PCF; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=GIHG0PLm; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="V+17/PCF";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="GIHG0PLm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979469; x=1823515469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=dHA6NvfjKKTya0oZneMJ1ApLH/4rAvOFxIIzmCrXGQ0=;
  b=V+17/PCFtyDvYkwfSBR67y1YGswOAXwNSHyhSKkxU+b2Geuq7ajMs5Mp
   /hQwTaVPUEKA+2EEgqMmlB0O0t8aAXVp0fhDywgpZvlwYnjIZ7qhU1VQz
   pexiVGotqHnbWWOfAbohUafMkCiKZ2GHjdkALmQNKcahu8QbayFgogJ7y
   kQTjTeM8Go2plho2Cl+w2YH8xHD6kk9Yk3LwDPLb2XUklqxWztEhCx26S
   AXjPuJoge6VEI3EDP28vEIO1/rHNy+NQyeqocZvwiTjqrF3iVlnd6JrKt
   Vk3BhqWcDCC2UtjvNmOBo4IAOY3IPxEETS1ZFMPWP00tV16aja3OPzTWg
   w==;
X-CSE-ConnectionGUID: mebAp/6LTRWAjcTBnRLgbQ==
X-CSE-MsgGUID: kyvS3VYwSjKf2pk1p3Y4vg==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077293"
Received: from mail-northcentralusazon11013054.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PlH3WRLp1za+79K9zlV2sgH34YE9Xxmlm9nRDpW5+wfek0oTFtlv+vDEy+xNYpSyx46WP6aU6o5o0FK9toRB/8dChGabMvzV5eUS4+m87eFKB8u72y8lbZP5FkiyI7tJ//x9AtuKs4GsCMrzF2FZlj9WrbwfCujG//ZyhRfkKi38pDsNoDVlg8/KeMBhTkNX3mo5D6EE1FdnuHqnucQs+Lvd4yys52IFpEDBOGBSLPUj3I++WZWTt2OSt3sbUgbNkDvMj8wI0Mx5za5OnvGrZsaRrv3w598xlKWuVofSaEUaTEJMWxU40EH0Buhq6BQ0ilisCt95IfzuXJQFGXOcCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PjIUu3fY1dbCNLq/TJeLLSweCfJpIGlUMKzPINeZgsg=;
 b=nG+lUu+a95qZXcL1we3gZO+nPz4PWfkAt3ya5Ia7Isym+WBqvxqbkOd3DpapI/G+fENbfeWR2P7o1MTeGaUQQJO4m1t9JBuqCWS+TW+vRb4EGwyeyxZ2br4L/hFECoISmAR4GUKxQ5UzMGy2APxmBLHy7rd9g4oh8zd2HpjrgPNwd4qVRj0Vb49dJtX09edw/KA8cS8W1eBLHJrE3A1DEyeLJTq13EniH+eIUXrRCwPBS9h/uBJ3w7vWXwopKb+MlorTaw2nEDcpJk2uD97UtXPuRR6Y65gu7xOB0S0U4U0UPjDFrax+Dv6/QEeG4fqQOwhuwGa8nNbZr604sePmVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PjIUu3fY1dbCNLq/TJeLLSweCfJpIGlUMKzPINeZgsg=;
 b=GIHG0PLm5td2PNUktkUnhv00nsc5tmpiymwlbFw/v3e1ZKl2KLVH9H8kM7hUHMv7NPG/PJIxfxy/YrofbGXhb1e//Z1CRL7crXw6xD+WAA5zr7daiAuqVTQ5GA30nfFa5ypbBXV5RW1whEIhFAyWUYhCWyq66zAl0LeeVJDWCx0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:26 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:26 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 12/13] btrfs: zoned: don't count the relocation zone reserve as available in statfs
Date: Wed, 14 Oct 2026 14:03:51 +0200
Message-ID: <20261014120353.757931-13-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: dced6cf1-2274-4797-e339-08df29eb4aec
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	xx1dU+oeM/IAxzDOrbbTJ7i4opGbhGNaQjSfqm5FlEJXantlv/KW7AZWGWIarhV1sAYJXVkDvAwxL5XattB7KERKOzxKbtSytyvaHZyezGlTIT+R4qTXNpZgEoPEk8MEJ4Irg6VVlupWpByYnIEQn/kZLo06IuhdJRutFfU2RRh6tuzLD2r5XScxhR6Q9oFgH6iW7If34ye+/NzL9cmjH0CDhEgi57yDODhGmHrH82PUgETJ4nsyyNceKBGGb25F8rdeBIPMoXh7ktNb/Hyxx89x6qxTcZf0b70DDPtET3oYipyxllBf1fB+2LCxXDFhNyMgKplUyyoG3TvVdSGR5Wr/Bi6qEPqXfr2IsWl/eA++714Cka4ujV2ING3W+FLgG8F3x42bCYksrEa55nK4cnW43PrfJkWB2jhmhjvHDYZHe5+wc3qmyvfGnLo4mskd8WLpNxHWhKUfD/LkFXFfDB8AF2/uZl+QL2WL9qORO6DzFC7f1apWz5twc3hj9guwAdBGb/bMM3NYkXywGKyBh5QlnJE4gqBFXKRcaV89s1VuLz32uk38pu56E95vglNbpfx4M7csbMKOTFzFiY2r+5pIpEGdhqAXunHimBneUSZrjahthXjebYtuPnuPZ5LGUPqC+PSwb40lFeCWrumXftZLfS+K50NppmGmhLKJc1E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ucJV07nQ7rPFvqcmVZ3DffMKN/gmvE9mq92EmD9jNKnhS5oUPxPxG9pVyUPU?=
 =?us-ascii?Q?c6p2mQBNuehUSyN8uzcztYx1JNNvJcee13N6i2ynkWj47ukLPVsF4GRjOz8r?=
 =?us-ascii?Q?RzyfHJSVKencs7jULxmoz1py/G+wjdw2k4ppOZJ+2en4birBCUsyFOneg2tU?=
 =?us-ascii?Q?El5lUwHUGvD3VE5iV9kgRoaM2+EvAPgk1t3H4coi96m8m49X6UsU24nA0Qzp?=
 =?us-ascii?Q?OHJl0XHbikvyc4xFSCtmmdbCNl7somWkt5Sq+S+yxCwvxhcZqYgOKarfw2iD?=
 =?us-ascii?Q?EZ+1tIJRFj9UMfL4ukBcsbFjV1IztWSI8zOJEuPu+zVrR0XONsDUGtQy1sZN?=
 =?us-ascii?Q?efWTda+oALt4dq8WQ63kSuf0diTS4euZVCPQNRju3K7OlVCm6qs9ykfQvySa?=
 =?us-ascii?Q?iENVFc51pN6Kri4tPX8LX1VWmH2aZLsU3IRa8u/z3uFbHPGXOymTUuXJjyv6?=
 =?us-ascii?Q?MBsJhNhQYpwy7m3ZBPxMWnaTk0wcbj3cLjNksFzARUaZflCGOp/9rhFMx1+S?=
 =?us-ascii?Q?Z/ZuFQ4LrlK+NPYsI8LRQ4taC03RPKvdtNQgNju9jROMDYWXFVrmq18y+fTe?=
 =?us-ascii?Q?vcxWE9viK2XSa69fs0CBnXO9h/Sxy0D13lPzwVEV922ILSkYQAYWFP9WcTFR?=
 =?us-ascii?Q?jLPVseX1Yju+lQ7c/b2Nlzn5QBYlVgzJbCFgF4Si5JfRFDYCrKZdGiPvLOyG?=
 =?us-ascii?Q?JKK86p9WPB9Kp4CRA+bDeYtHxuLIgxGerv68yIb+QPCaX2j95TZu21vmTUnW?=
 =?us-ascii?Q?9bTXikZ4iTYH4rHfUdbDuPHhxkH9At21Jw76PwGisniLMw+yoO66qPO0Fbcb?=
 =?us-ascii?Q?SNcVH9YcB5/3D+GRVQBqzZoGQITC9qMgHGaHGfEArfp7rT9Bf/SzSlB47fHR?=
 =?us-ascii?Q?v2gmYdYFa+pj3iubyBZaUvB4AwLj2IVs0Rw5N3Qwo0Js2X2fDm0TGW5wLJsj?=
 =?us-ascii?Q?aDOtGD9YmCwiMNifc4M+H3AYHjN3FBCv972gHi8nyX8v7iRFY428Opbggd2/?=
 =?us-ascii?Q?/uQnJZGW7tHdtlQw+twqzw7mlZ40RfCIBCx4YInR5uhMSr1svMJgZtMixmvI?=
 =?us-ascii?Q?DqAwX4qkr4Yf/yVaJYW1PqtZYMvyqFYXVg0+bUZcycqnfHwshdIj7zIXDDqU?=
 =?us-ascii?Q?rhIsBmCoq+lY8fpfACzrYy4/O60OSfiZ8aYzJ55AfD/3YN1h9qmbL4s63bQB?=
 =?us-ascii?Q?fe8yzOVDCe19w00GYQ+J+V78teoEvRH4OaA5p2Jo8fVivebC+gP+keoGfXpt?=
 =?us-ascii?Q?mR2zXdeL89w3ynKZtqQgkRMeyMwLW8AY5EyR5QgnsII+oQnQKzT2qnSTuBsZ?=
 =?us-ascii?Q?BciDdQ0eA36UaFvRghwsODUd1UneB2IIIDWfqFp4xNlV2N6p+dFfk9xriXdx?=
 =?us-ascii?Q?ErAdjwoJxt4VJowiEbTA5WRAh9v961jScn1zdDk6yOwvmwoUmx/crt5CzHwQ?=
 =?us-ascii?Q?/wfTC2CDVmLfJnCJKDi3D2Ep5tCBUFMr2dEZ/iRYEvgtymQFFqqNUmr62VZQ?=
 =?us-ascii?Q?wI+DuZMZ+ozuNB8uR4v+v6XFQDHhU6mbzRaz5n3KF8JeEAc1DzuWMBlZt7ja?=
 =?us-ascii?Q?nKG/8wgGh0qjVOEViRWkAzh+bKbo67ImxgixYpqwQsR5Q068yzsjX2MAOh75?=
 =?us-ascii?Q?qGlN9E10iYMKH/L+Ogj6k2+Vxf4McJ2gZ9i7n0B3FazsogdD6YNTGihLC/RK?=
 =?us-ascii?Q?NfjCSJhdkoijue+wg6c2J2q5srlDxZMwKrxADnsRcKCM8i5I9cBC3Y46azJd?=
 =?us-ascii?Q?jiHYydP1/LkptcIetKatLvCBsvEOxWqOKW7dXt0f0kd5K5sAbMQHgLOVb1YO?=
X-MS-Exchange-AntiSpam-MessageData-1: t1f0LwSJWo29xm6Ow3HQmtm5LvEpTbiili4=
X-Exchange-RoutingPolicyChecked:
	jO6kb0T+5tcCAKYgOFHk3SuwAb+3ehVr6FfNscWrC1bx3F8QhSw6i5XyO2JNFp13wp8Vyns22pZWnIjQN/jyV8M+4ZSwxYYBAlSQWSZVElVSHfLyiitxKwWWzFK3TajL8DpQiYvBOyGTnYxvvcPrO1IJiDgcJWYMo/oeZwRwVFf9fBlif+W0wzI+q+y0eXBkDkO77PxJha4BLrF83o3S/kgpMe8/tPuPdooQZNVAGEl4Nfp5JUUuhV8x9X3G4eQDBFQUdb6Ou5V0Zet05OxPW/0uvQvu6Vc8LMx8jNPdzEj/htxwLPV+X0W+RIDkhYJiGt9VU6ynZYwU6/H3hGpV3g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sZUlWAljBIBWa3u3bmtLQ+YLfwvGCEI4zL9/HHaJqy9Sd2vq2JRFda8zN1di7uJAEe0h8tlKYBPENYUruOvA6ULogP2qGSjVeh245Ws+qrTrT+UzCvHF6D15CORDtI6R/7loewYT5J1EfogDDkPpPIuY6vpFGAP+3mmcXi+FDZOGAohZBxxA4JfOQIQCaLwtyme3ihSDB/u9eIPmtOesrFHGR3HUEctLcG35+mC5nC+VHfUbGs767okNz5Ln+mKqWdmhvv4zYSuC+otccEcqSCMp+x0MssQzHP65KFMT2COoqz9uvPTEAI3Msbm7eP5Dg6knB0YKRABBC+CEImqTslhBUX/grsCLlyCp1Ia7U6kkutIDMBlL17GzwztT6aZPfCTbQlW8+2ealRMdq9zFi/usZ9GiidYTkTr7hxMNiF73aHPNDnsQgg0Lvd+q7DEBVJdHJ7ZmNxpui04jMHfW++bUd6hLAEZ/23ex21YQgiO2OpxXJmGWC6B9c43N7O2O0OsnKm6EptmNbV0XBaw2y9zlG090NFmIVwzWzk7Au84wltMt8FGvNDBLM3SZHnBaAw8L3GZEaixlehdUSupVq3fK4gmWTdaf9rMyo+QypGeyK85TiZ4rmSxo7CjfPAKI
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dced6cf1-2274-4797-e339-08df29eb4aec
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:26.3208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EnP0IRHvylye3cZNc1aOjPk/YbJEPMPjU/5Xrj1GrtoyjC//OSuCitfhut5oE6KbMJ2wVRHJ1d+3QVNlXyl29vord+PzUVebc4s9zsY9XhY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

Don't account the space reserved as a relocation target as user
available space in btrfs_statfs().

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 98e103d4d7bc..0890079a929a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1769,6 +1769,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u32 bits = fs_info->sectorsize_bits;
 	__be32 *fsid;
 	unsigned factor = 1;
+	u64 data_alloc_profile = btrfs_data_alloc_profile(fs_info);
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 	u64 thresh = 0;
@@ -1828,6 +1829,11 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	ret = btrfs_calc_avail_data_space(fs_info, &total_free_data);
 	if (ret)
 		return ret;
+
+	if (btrfs_is_zoned(fs_info))
+		total_free_data -= min(total_free_data, fs_info->zone_size *
+				btrfs_bg_type_to_num_stripes(fs_info, data_alloc_profile));
+
 	buf->f_bavail += div_u64(total_free_data, factor);
 	buf->f_bavail = buf->f_bavail >> bits;
 
-- 
2.55.0

