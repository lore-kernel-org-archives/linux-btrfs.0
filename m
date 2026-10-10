Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D858457E7E
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634047; cv=fail; b=EhZpkX/vs3Y5nAExws2yTmIo3v1iR/Po0e8g8BL8EE7T7rMofgI92NddBJn4cls1UKfC4kt9A48+VqSB6qUW8gzNJEPi6O3PrpLVBD960zXX6gIiqyHQ9B5LYodvNghsp+hwKF+vMy5DtHiN7EHEBkOfgDzUGRmvLhELTIQeEDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634047; c=relaxed/simple;
	bh=DU9xcRMdrdz+60vLu12ePNNWBAy9fuxbSRvy/A7H1hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R6V82q97nOS8df+R3sVa8kXV38lz2AwQotL8CX7gLu4LAPbA8T/AayH+htOg/9uoqShHj09TzekiBfi7M/FrrZD3jF8ENcaFg2tDqkMczybZroS1SaI0fFZzUUQ5a2gu3gHeb4A7z/WIXTdr4GxLy9AaH+tPkQ3vt8VaWhTTIlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Q1VXgrfy; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ATusxYM1; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Q1VXgrfy";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ATusxYM1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634046; x=1823170046;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=DU9xcRMdrdz+60vLu12ePNNWBAy9fuxbSRvy/A7H1hw=;
  b=Q1VXgrfyi48vXqvSiEEEv+qpLlBmRRf+DxmPOJe8ricWvp4R0LI+J3To
   6zlDs7gviy/ajK/ok5rmvjEpeTBdcNmkr1ItRf264LmuK/2u6DIK3pOY8
   VaNF5+pxcp1Q4Q6+a7C1flFKrrPU3xv1K3MSu3T61cUNrjzQ2Bb4wLdIJ
   RV+vAsHEPXjwlG/TuOicbyXHGdc+DEP5P1Kf5pZd9mX9EXKWQbzcjWXBN
   zl1VSwHeBoD1jz64dJTec2hznDN/QeisXFnfRXw1MdU5kKLUTxEjf7Cy4
   7+Y+R3kRA8ens1qihakXWylAJeSgYbsiNCfU0dfIjaWBwzdh70Bp6jjkQ
   g==;
X-CSE-ConnectionGUID: lOzyI1BgSHKKaH782yoNPw==
X-CSE-MsgGUID: Tevh/3QHSnq9wJsDzEni8Q==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="153560337"
Received: from mail-northcentralusazon11012008.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.8])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ihC/p67O7TSLpEpLIDrRnWsO9EADY/o5JHXv/5aldEejaNX+WUhbPPE38iBwvc6i382wfUOof3nL6AvhQ728NKHkq87n/OJhMR7WbGwLmb7VP66CTukgFGhStT6Tnp3cbxZPLyKq/fptyaJpMOdZ80fQyNwwwuIGUN9vIN1BpvzqtS47eZJd3ilYMFULlscviRlkJTXXZhbXCY/tTJyqEpKUSIkehoGeZHZD8yXphvY2JnN7CICndXWv8j0ISaVjogpnGp4UGpfk0G2kwaJR56lesD5ns+4O6etVeGa8gsYP1Ec0htOuSKEtQjP2yQEMmM5P+BErcmR4MPrYJnMgZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Bt2B+Mg4VrCI5ontRWLlr552HeXN9EdH7X8typtB3I=;
 b=xxzgdfGrpFJE5jGWMfqr8mFC/c57KcufDxNF75jxZMKW3cZ+OoBm+u0kndQDPdypjgstVdhWfN04SBZp0Tckfi7uFMmNadDXFsxJV9ZUa+AOZlxEBuyd6WYKIiEyYipx61GU/c64LbPjxc1SWb090kKsMOx6B4PMXIutP8nak0NMc7CQSo+C9GBd6yUDPbhZj5cDffc5AgX6xYQ8Kmz1NPY4fGsgZkspSZyKn814qAZrdpA5E+ejnqplUGBTEkX2tryRq1JeTmj1ZcgywhY12xDecWZbB6eCTzhUsA7R147TmQ8nGfZA3W25k9DkfdPczbkv+4i3WhT7MHAcfWIB+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Bt2B+Mg4VrCI5ontRWLlr552HeXN9EdH7X8typtB3I=;
 b=ATusxYM1kcEM9Lmp8vgwYynmiZvSfknlKJaDSz1dsNyS+mEN9QBV6KD/uxOKvpIu6H5NqNW7Sg626qDJ/KOIkyb6QGBNViG1sT7ePv04XZMsOuLeMgvYX/A4fF8lUvCZHo/72m2lO2Vj/TcLGhNQChDc7+urPbd9QX0yHX/T5iU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:15 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:15 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 07/12] btrfs: zoned: allow restricting the dev extent search to a zone type
Date: Sat, 10 Oct 2026 14:06:17 +0200
Message-ID: <20261010120622.3781326-8-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
References: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: 357fe454-2c62-40e5-e065-08df26c70614
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	dYPKnJjzNL7zl8M5Y4HRnHZo/GdL0WqcncD+uTqJBnfwWw8EDH7ADFAkv5G0tx8WPynjvNJfLSKPzAsLqleGNSSJeUPvHaJg07beQD8QHKWj7L0JtE6q7tShzwcjK6lB1sIuyPw5fiY+rGIhzEQ1gDaZgNwBdHh+c2klx1x5BJn4Qc/I1+wxpmeqAHbSgNhjekqIl82l4UxogxbE7ArAnSiDT4F5AINQ/y6gxedLnef4NraKT7swZUd/ICCPtWtG6dquAdOotDEibODE6oRkYq/vU1Zw5WfByjuSGDM5Ajwklh+FMBE51qCNlPzW86gk2WCJlIGKH6VRI8ZELEuAXJpu/gBV17kk/CkAxvfqzFlX/RTSEcvuBP7jY049srae+TMBDDluTQ4TUYpklawJryFhQFQBhyS0NARa+Ngm2n2oOV15V+nD0LtO1N1wQfrOasacqiDyowaPHud/vxA5LqgD6SG5BRQYNkbQmMZj4NVQUztEgQQB7+PjTG93wjLp/oyVTqcDQjL9yY/Szc2UKn903iEYGAzpWUqAv+6MT6ClGfgtcY3gyN+3ygLd8WyqptrlwHfLaZXHUlBCvF1/mjubk42F3WS8Y5MaPm7ljCkEonSTtUT3hqfcSKf0G7aYuRb7hSCp8XnVHSuk8Rgh/vFd0fXsLcQbjuQPQBFF3MM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZifNdAUXFfA9DUoQBDHvl4tKcl4NIg9Qz6PyzkeTG5z18X1v9B0cqgpl1/E0?=
 =?us-ascii?Q?d1eaTGpILuoz3CDHLJgwcR+bTaHqkl71C3mJoaUlQhI5sfmHtnTqcftsHNOz?=
 =?us-ascii?Q?pAexGmzqjdeTMKUPkZ+Lo5e+IjvCj5HW8TPXbPPL7o6KrIMKQx+V9QZ/pVsn?=
 =?us-ascii?Q?TWcY96MEeEsvyrrOXTP+6I+4U+UXdCxOLjqU1as/vNyjj8zyPydIOXuwfZqL?=
 =?us-ascii?Q?/xxDf037zfcoTHXKb5prvGqsGpL1z8iYwXNQQ/qXehFB3Acujn5JzMbjEeLF?=
 =?us-ascii?Q?JQOCOdjtBdJ5foTGTGY6bGakLOD7yDlAHqmIhevcq5cKVUqmHtLCJbGawacC?=
 =?us-ascii?Q?eIgseHzAI3MgiS489QFbQcHLsZ2QcKYgFSSLqaYmiqHW8tummFovFTNcXDHu?=
 =?us-ascii?Q?v1p5PxTq/MC3XYyNDazZYeRbuBIQm8F0UiC9zYzUE9ijlGx9LSAa5WBMw015?=
 =?us-ascii?Q?xiPX47kxGjW1DKyCxaMSd0niXLpj0kucVj5aJTK/b9v1LZx4H3OsxZYxL8N/?=
 =?us-ascii?Q?Q2f2VIT9GcynCt2IqSxgisshoQ/26LUPfw+mGW5dKsjt6TKChC2yF1fprvl/?=
 =?us-ascii?Q?MtE300cRfuaZjlA75avtDtLdIOuEefnh/7Ut4L8PNa47BnppghwRQxUg3cze?=
 =?us-ascii?Q?xiS7PuQdOzIIFKiAW8gSkqXnIN5Dw1vPthftUBrQk2Xbyz1XMFakJttRu0pl?=
 =?us-ascii?Q?ke83GxJLt17KEHK7JzXVHp+Vkd0q6J1XQ2l9dXrq/Zd+BnIdIKtovGZD80k3?=
 =?us-ascii?Q?vnD7XxvKudRB9TTIhYt/iUAdbC0Pw18wsPOa0XOYkTFN8MXgljA8KEMNQfXq?=
 =?us-ascii?Q?bvX5irh6F0AVBaXt7HLvR8YvR+1FEvGbzdbznxYXXPzIMkJTz7Z/3hJV8950?=
 =?us-ascii?Q?i8A00BYH41qFE4TDsS9xmoupjYMWaMX7OXJqdtJ7q3zaFwcxMmBIWA71syau?=
 =?us-ascii?Q?DkWGU4LcDFsV4BiSUTqCcWxwnMqc7ZHyN/C6MiwCQN0dGGIjyj/3uYAcGzB+?=
 =?us-ascii?Q?5yVQrN7j8kWv3uwcCjTpSsDMpV2/BtoqcpcijtYAKtH+7+ilxXNEr4LOUzjd?=
 =?us-ascii?Q?xLPO+Ci3yIx7ioGc6C8ptuDCu+3UqhG22fGshakFOlTHSx/EMzDeg1awWQf0?=
 =?us-ascii?Q?gBg0z2P8EMsCTjrsN+D3KaLMfL9/wLnPqYOSqS93SQTF/AhPgPfd+/TMQXmP?=
 =?us-ascii?Q?ve76hoMmvK/5J+Ai5UFUcyOrDJabD3UchKYgT9pHdC1AAnT2AtqvnXDuQ6og?=
 =?us-ascii?Q?46abI9JJRpmfD1fusn9t/nfsmpaZ3BVqH9tFy4O73wKi6c1nnx+DetV6WcxD?=
 =?us-ascii?Q?/a3Vr17hIeMVp7CywcGwQ/5+w+A5mNNlCuWtVk/oA0FDaWQK2m+CVDpUTzp8?=
 =?us-ascii?Q?5ulSmnglv1okPrhMc5i0hfExbgLRc5SWZVP8T3lIUkdGbfTz49xVuY8HHOOr?=
 =?us-ascii?Q?LYGlJRBxDY0f/aU7VO6Sn4laGS1Oh4OGiW1SofBM3sJbo/QOsLXJ+iC3Tzqy?=
 =?us-ascii?Q?VrvCBz6hrIj2Iu0dl8+wcWrxpsbJw0fR7p4rjv9I4pOsyaEWalHSoDU2DunH?=
 =?us-ascii?Q?+VESvLbk+4ePgayFX3UOViezswQiM3v1aUxS26PMpFYnE0+nS0q6aqgDgkYi?=
 =?us-ascii?Q?e0kL/tD8xHjQF1SlXz+jv7tJyAoO5yj+SgbrDbKUJv+Kmhb4k2PmbxpObano?=
 =?us-ascii?Q?6lpmhwjR2bPX+7hF9dwhI9E3oT11ahmseXvL8bR7h02Rv48+h4XCBLwdT3SQ?=
 =?us-ascii?Q?a8S0+brII5S1aaToP0Yi8V0PCY8daiy29S7DcdFQPNUAbLCFA/Vo7sgPqV5v?=
X-MS-Exchange-AntiSpam-MessageData-1: q2aGDJlhFLN62k1A39DNHAQvkv8Nhj76dyU=
X-Exchange-RoutingPolicyChecked:
	ZM8Ebvsa1fpp8sJcGRcYWpHysYV2mYWEJyupy3ptADDbFwvGa/AuY31bZ8DLZLL5/46WqM8dTJASmqlEtKZI6jrPh/eTib/wF7bu1QrbFzSG4QDW/nH5Nl5w/0EW/5zVkiydKYtRCPcNPcwW8bzHkxVQ9cOyqSuYL064qzGybRaGHS8EmrZeW1cbmqM2fvtT2WszBVau/a03+DQhEoqJC7QuDkwHGMv0GaMvlvMUeExbF38JHV7NoNmaf1HzZA5EKYU9rEXTVKzfz+T9By+Th5I0XMr8MV/xD0js12U8VewtCLqFh9vge5Y/N3VdQ152kG+J1+HwZQ0yKDML7z/asA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QRCqCet+XiRn1xdxoXkNRK6sAOYXihMkAsbzwQuxr3TphpoUd8gBLirWWn09AjmAVqRN6tN5JT6nLBAc9WWOB/Ro7uiaIkvAy1NB9vA5wzI8XiVld+lAlwIUMNV3tBdsbwWhSQwHZzXuwhGUXBHYkEVeojKoINXzxlstcdDgz8yBLVcXsUIjbXuFyvbkVPXwqpeGGEd0Vhtq8UpRt0ltgiuhxnF6BNdMmpnbSD3AMQv+UJC2Zkw3nV2BxaBNJQ92DvzKQWe1MAdftL7LhjdDvK3ESVAvVQcAzUZvqTgIf+y1fUjRkiA5qlapMtBiCkN2ve6o0Ixv7y2cHh2VYUmxbUDQ27vj8EaBJ+1eaKSASMZriY4S5hUtkZ3eKtbQJ2pGFpJA778dMROzUA0DbJ/FrvVK8kRspxU//NkG4bcdzpTIsk19KCKEESUbmVkyyZWzX0iOx7w2DvbKqEFhrTw8DFfwhi5S9BzkdYT3VhKYzNx98VNT+ixNxOZAQcnRO4HwP3i8nnCyP3g/dns9TGVwoqdWsAwnJO5LbtktD1s1Nz1QaTOrHLThywW2PC50FrP6TjiOlEka0TVxc/uV6jZajEKLR1VVLQ/pP/y7wWvMAq5e39WDmuibZFTJK6qv2ZRI
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 357fe454-2c62-40e5-e065-08df26c70614
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:15.4163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GEFHsc5aK0gqawxvqgdyGj1IDO7TnxOQvrd+fIvxlLv8C9tM+PieO939A7dY53aWWMtLA472TIkvHDKA0YyPT2cKEWDGIKpfBerLSavVS4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

Add a zone type filter argument to btrfs_find_allocatable_zones() and
plumb it through the device extent hole search. When set, only regions
consisting purely of conventional or purely of sequential zones are
considered.

A caller expresses a preference for one zone type by first searching
with the corresponding filter and retrying with BTRFS_ZONE_FILTER_NONE
if that does not yield enough space.

No functional change, all callers pass BTRFS_ZONE_FILTER_NONE for now.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 24 ++++++++++++++++--------
 fs/btrfs/zoned.c   | 25 ++++++++++++++++++++++++-
 fs/btrfs/zoned.h   | 17 +++++++++++++++--
 3 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d3e6a9b429dd..f41a3e9c30f2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1704,7 +1704,8 @@ static u64 dev_extent_search_start(struct btrfs_device *device)
 
 static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
 					u64 *hole_start, u64 *hole_size,
-					u64 num_bytes)
+					u64 num_bytes,
+					enum btrfs_zone_filter filter)
 {
 	u64 zone_size = device->zone_info->zone_size;
 	u64 pos;
@@ -1717,7 +1718,7 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
 	while (*hole_size > 0) {
 		pos = btrfs_find_allocatable_zones(device, *hole_start,
 						   *hole_start + *hole_size,
-						   num_bytes);
+						   num_bytes, filter);
 		if (pos != *hole_start) {
 			*hole_size = *hole_start + *hole_size - pos;
 			*hole_start = pos;
@@ -1754,6 +1755,7 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
  * @hole_start:  input/output pointer for the hole start position
  * @hole_size:   input/output pointer for the hole size
  * @num_bytes:   minimum allocation size required
+ * @filter:      on a zoned filesystem, restrict to a given zone type
  *
  * Check if the specified hole is suitable for allocation and adjust it if
  * necessary. The hole may be modified to skip over pending chunk allocations
@@ -1772,7 +1774,8 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
  * and *hole_size is set to 0.
  */
 static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
-				  u64 *hole_size, u64 num_bytes)
+				  u64 *hole_size, u64 num_bytes,
+				  enum btrfs_zone_filter filter)
 {
 	bool found = false;
 	const u64 hole_end = *hole_start + *hole_size - 1;
@@ -1793,7 +1796,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
 	case BTRFS_CHUNK_ALLOC_REGULAR:
 		return found;
 	case BTRFS_CHUNK_ALLOC_ZONED:
-		if (dev_extent_hole_check_zoned(device, hole_start, hole_size, num_bytes))
+		if (dev_extent_hole_check_zoned(device, hole_start, hole_size,
+						num_bytes, filter))
 			goto again;
 		break;
 	}
@@ -1810,6 +1814,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
  * @start:	  store the start of the free space.
  * @len:	  the size of the free space. that we find, or the size
  *		  of the max free space if we don't find suitable free space
+ * @filter:	  on a zoned filesystem, restrict the search to a given
+ *		  zone type
  *
  * This does a pretty simple search, the expectation is that it is called very
  * infrequently and that a given device has a small number of extents.
@@ -1829,7 +1835,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
  * is not reported as available.
  */
 static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
-				u64 *start, u64 *len)
+				u64 *start, u64 *len,
+				enum btrfs_zone_filter filter)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_root *root = fs_info->dev_root;
@@ -1905,7 +1912,7 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 			dev_extent_hole_check(device, &search_start, &hole_size,
-					      num_bytes);
+					      num_bytes, filter);
 
 			if (hole_size > max_hole_size) {
 				max_hole_start = search_start;
@@ -1944,7 +1951,8 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 	 */
 	if (search_end > search_start) {
 		hole_size = search_end - search_start;
-		dev_extent_hole_check(device, &search_start, &hole_size, num_bytes);
+		dev_extent_hole_check(device, &search_start, &hole_size, num_bytes,
+				      filter);
 
 		if (hole_size > max_hole_size) {
 			max_hole_start = search_start;
@@ -5922,7 +5930,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail);
+					   &max_avail, BTRFS_ZONE_FILTER_NONE);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index e0e7171fde3d..f85b549e5a77 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1054,6 +1054,22 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 	return ret;
 }
 
+static bool zone_filter_match(const struct btrfs_zoned_device_info *zinfo,
+			      unsigned long begin, unsigned long nzones,
+			      enum btrfs_zone_filter filter)
+{
+	switch (filter) {
+	case BTRFS_ZONE_FILTER_CONV:
+		return bitmap_test_range_all_zero(zinfo->seq_zones, begin, nzones);
+	case BTRFS_ZONE_FILTER_SEQ:
+		return bitmap_test_range_all_set(zinfo->seq_zones, begin, nzones);
+	case BTRFS_ZONE_FILTER_NONE:
+		return true;
+	}
+
+	return true;
+}
+
 /*
  * Find allocatable zones within a given region.
  *
@@ -1061,12 +1077,14 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
  * @hole_start: the position of the hole to allocate the region
  * @num_bytes:	size of wanted region
  * @hole_end:	the end of the hole
+ * @filter:	restrict the search to a given zone type
  * @return:	position of allocatable zones
  *
  * Allocatable region should not contain any superblock locations.
  */
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
-				 u64 hole_end, u64 num_bytes)
+				 u64 hole_end, u64 num_bytes,
+				 enum btrfs_zone_filter filter)
 {
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
 	const u8 shift = zinfo->zone_size_shift;
@@ -1088,6 +1106,11 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 		if (end > zinfo->nr_zones)
 			return hole_end;
 
+		if (!zone_filter_match(zinfo, begin, nzones, filter)) {
+			pos += zinfo->zone_size;
+			continue;
+		}
+
 		/* Check if zones in the region are all empty */
 		if (btrfs_dev_is_sequential(device, pos) &&
 		    !bitmap_test_range_all_set(zinfo->empty_zones, begin, nzones)) {
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index ae7f04699765..a298b244da06 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -28,6 +28,17 @@ struct btrfs_fs_devices;
 
 #define BTRFS_DEFAULT_RECLAIM_THRESH           			(75)
 
+/*
+ * Zone type restriction for the device extent search. A caller expresses a
+ * preference by first searching with a restriction and retrying with
+ * BTRFS_ZONE_FILTER_NONE if that does not yield enough space.
+ */
+enum btrfs_zone_filter {
+	BTRFS_ZONE_FILTER_NONE,
+	BTRFS_ZONE_FILTER_CONV,
+	BTRFS_ZONE_FILTER_SEQ,
+};
+
 struct btrfs_zoned_device_info {
 	/*
 	 * Number of zones, zone size and types of zones if bdev is a
@@ -67,7 +78,8 @@ int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror);
 int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
-				 u64 hole_end, u64 num_bytes);
+				 u64 hole_end, u64 num_bytes,
+				 enum btrfs_zone_filter filter);
 int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
 			    u64 length, u64 *bytes);
 int btrfs_ensure_empty_zones(struct btrfs_device *device, u64 start, u64 size);
@@ -177,7 +189,8 @@ static inline int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror
 
 static inline u64 btrfs_find_allocatable_zones(struct btrfs_device *device,
 					       u64 hole_start, u64 hole_end,
-					       u64 num_bytes)
+					       u64 num_bytes,
+					       enum btrfs_zone_filter filter)
 {
 	return hole_start;
 }
-- 
2.55.0

