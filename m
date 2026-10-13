Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFC839DBF5
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876625; cv=fail; b=uu+GIYOksC80WrUD/aDDCZNV+JPFr2RAoX0p5rYsiQV5Vlj28SZMS0Wp0bORQH9V8hwJvjjV52jrAdgRSQ9eJg+6yxCJhPqlpaYFB+8s9RQDlh64oETQcHabX8AwcCi9KFNtKYdKv6QuBw21WBcgCDaT6hXvOFy+xkYUfhQ8xPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876625; c=relaxed/simple;
	bh=tzEYiTnMScyl5yTpcXDvamkaDtYJSGq2Otn33f2dRyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TFMfEtWU2hTwXEJoK8BoJmMSJji317sByW2EXI44+SqbByfNwUc89hOF/pQP5TYqJsZVfkdalovwzK2Jw3r0AZfYmkn/spskbAS2t4ePB3mhxDQI34MGcBOogFiA1R3xc9e2fDR2TqTB+mpFzL803RiEc0c9ZNkqPArrpnc2FLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Qc1UW3Fk; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ik01zrrF; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Qc1UW3Fk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ik01zrrF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876630; x=1823412630;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=tzEYiTnMScyl5yTpcXDvamkaDtYJSGq2Otn33f2dRyE=;
  b=Qc1UW3FkURK3zagD/uyhd5CseFZVjpk62uqMPtQ3Jz/wGZE7k27Ethyw
   uARcWdiHrXd3jtT2UshdouK/E6EglQ/0iDwFQz6O9jgv2yTxI7NcGXPsT
   e9ih3A6jNPwdLbVBGCFM+ru4XNoGvtn9UhyPyUDl/ad9ET9TfHqPLoUJR
   0K2lB5TZibq/mrDMKJcf2D/Y7A2o9HJ0CjKlQZeSo96VnrfaHuVQ9aOtE
   FIJ4ITALdeIxNIBu/dA1/eApwYtHrfGA5EmeeDRMt3JGvtLB+dlZLGehx
   NAqjYJt3YK96J+WgWBy+t7GJMsLzsY6zgeQR1lUXEsfw/tszPBfzXBmTj
   g==;
X-CSE-ConnectionGUID: wKqUK8d7SYS5LU1T0cLtmA==
X-CSE-MsgGUID: f2AmFYPXQJ+AmMPp4WWNjg==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="158917160"
Received: from mail-westcentralusazon11013065.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.65])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jYcE141SrrQaEk3BfED9n+DqcCuIbpsW72jzxkMDZ66SPo+UaKWnm3Bw+MKjdMnsOR9Jabk+ao6+IWAr6vLh8o7aEbCqBZmq305avfSFDVra9+E8pNRPIrp1eLNy0H5yfjC3NnPwhgevF2PglkUONbQi5rKVZRJZkQfB7TtWbQET4KNvkMJ4P2+PqIZaGKRucJ+8YJPYNJa9zVDiK55qIZuz+WzHso2vgk0dVXU24RZCSynGzw2uufepI3Y8AQOENgiEJ+dsZB5JpEcwhaZh7JGrsktgx8dAUcRXg/PfsmWUT70pmrvRaVTXFKeWn9bne+3NzP5j3pqVfCmFwN02gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7iJalUj2IBHJhFjTFOQ1YmLLFs7Q4ffDb6QgQbeWaGs=;
 b=ZiKRNeX9ut91lZDVbvJFmodg8IsLVIkt0ahn3BbYtNTjdGdIX8RT4fnk4X7VQ5PQ1XhXrFz+mgEAM1QGovNoD9W5olddP8MujQTjMMY2xEymkgTz0Z+GsMIxJ5cbYjHdHPJpCYkKy5Bv580GH/VLX6AiOA7OZTj02g96Au+OjgizmxIQH4vg0vYixneBeeNgwqeAFSxEMq+2Kkeq/gvnSBkdMXI/AuCwGH/kaSCSbaMu+p0uUu3+tJ/6jmU8laGs2YeawZQ8x1fLq7Nc1jE/lqO+duD42DGCZU76w4NL7OFy1I42VfV1sAxU9g5kVwVdC7QOOWxTXwvnKP8lwM63kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iJalUj2IBHJhFjTFOQ1YmLLFs7Q4ffDb6QgQbeWaGs=;
 b=ik01zrrFJVBBnz7D5fcS7d53OOjaDKth5G9k5lr8A7dvXVyXr6qEzNjiqVOdev5uzXXiuom23nxhdKY5GuP0jnNQtOglAFvjPB5mhC/56uK9zSZgAm8khyvBXQhNGn/mx8FZW5MxSNrdrfrhUbMi75+koBup2NxskM84VAPQY0k=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:16 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:16 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 01/12] btrfs: zoned: fix possible race for reserved_active_zones
Date: Tue, 13 Oct 2026 09:29:30 +0200
Message-ID: <20261013072941.424029-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
References: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::27) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CYYPR04MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: 11ea7840-6f13-4ffd-472c-08df28fbd37e
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|11063799006|261009223027099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
 E7hTKn7DfijhAkvvGh8U9aZjzr0XXKICeGC4/Ubhu08imD3Kq6Z7sq2XKtOMU7CnMezFv8Nbp7Cq6q9G7qMxcjWJ0ZfK8Bv7TB7r2MzfWHleeaQBnCyCb0TFefG3pSZykk1b2AqyyPPSLwMNubSMxrDjevSt76p9iP7gHtW66W8gtVonL0Erg9sUYBN2MiLrjYyZmxFI/7PbvUrLIGHfUYL1kaWULx7MOVsd+LAdeI8jrOlF7MAVD3qUyET6fxN/Has3MTNygNeZwpdjsEmYYJhDJ6sIcNCTVM+lCExSAGfYJ5eTaDn0r+p7JLjQO6fdHrkdZYgsadRVICtIAeO2GH+eoMsULuVDWEUbcR9Oi+kEJShkrF+sSE3LTjDPjtmNqeQV/5C9I3RzAoTlHV5+1dpnIygMTKdBHD5T7O7JSsEWV6DUOYZnTdKf7M5iA2aXEJdbuNOzndwSgYxrfQk7syu+FpP7XcSvupb5fNju0cdMR+Vk6xYDPtp97fYmUFfLLTI82uhZQ96kFseKdGDuVAx3FeUfHeRicsYiOtwsCHQ9ISBbvJsE/MxAydWcMXc1VIs3QXkg1FGh6cMlcyRiCW4jrWP65th5rUno3B342kUCfVosRr4esVz66XkLi/Vmi1IDLK/WFe2J1uAGXJWVmEWSQG6ohAGBDuuuYdrOSZ0=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?82EKwzMYELR4yWsxPvzOnMgZrbN6IJesm8f7XoSsgEBWmjN+YPPolkpJ9FQK?=
 =?us-ascii?Q?u/MQ+8rDq39eLEQ8r0gbGqI9AGrvr0+s7QTMSWe60m59TDDpdzihqaZ9pyp7?=
 =?us-ascii?Q?Tr1xh+H/ASb7mmWcNymEeJD2QmalguqP/CZFCk7/qtbn03HgUWCoO/YiNWi4?=
 =?us-ascii?Q?PHnnRZeZU4t6n/qdLpzK72UGODv0FlR008vlua/Wqe7Jx6C1sBNN4cW4Fd7c?=
 =?us-ascii?Q?p9meJ1jkttmZkqyJmyCd/IekY8XEDPmgO1SW+TkBtzTfUxAnGtRRqLOBIbXn?=
 =?us-ascii?Q?bsFEH/OcZ448OfKwpWKUGNvBv0o8+8ti0jGChvx8QmyZ9ZEcfds+SMXM7ncU?=
 =?us-ascii?Q?okiJFCC5hLDUXZLc7NNkCOSA4foiabGYMZVnog/iJ/ao+PQGRUpuwkHpXa+H?=
 =?us-ascii?Q?AUsdy+EwXn/TUulxPR0dLSDGdmeq9ZxbkdH+foepodPwBo+6cf9c3FzYeOI0?=
 =?us-ascii?Q?NtIV6QEzzUYucMuQybYFbDM0RYo8W4livI/GMLEp7w6so5p7PhS/cFsfyKNM?=
 =?us-ascii?Q?uGQvWdJoYH9CeJxghIz0o88iyxCTicBDhKuUS2JjwrEk2Zmn9sGsI/gL0VBJ?=
 =?us-ascii?Q?EkR5Huy4mkzr3BU3yWAsqBzzuggPQ01pKu5L2cOD/r8SGLlVWnIMptOz86rM?=
 =?us-ascii?Q?Tw0Zupq0ctPB2Mu4FCmj9Y58iVDbHfWMvQsd3GjGlsLIK9GNHSVKcPRw9xtZ?=
 =?us-ascii?Q?7tX2EMwNiMZv1anl6SLSZd8qh55YEeLgQyNGXJjL9pHLzpzVL/ulY7vBgWbm?=
 =?us-ascii?Q?XeiLtLmDnpyEPiBkRaTb/aUPak/SmufNuANU1y9JSsandM62um9rw5zgUoxE?=
 =?us-ascii?Q?ykm9P6deDdhd2SuAseD3v7eMDgwz7zvZOgoKe7dx0xSRRnQz6KUwke/AryTU?=
 =?us-ascii?Q?wBBOY5h2KIocKt2waNHOIaEW99VnhZ199qJo3qPGXT0n9a+zlJJkKoqhYSQY?=
 =?us-ascii?Q?F45yoiS0JSq09JJqGT3rkSOWpWFT88GlEbabv3fC1XhdO57ulLoH8vcW+PEY?=
 =?us-ascii?Q?sgZN190koB/aNCX6psgkVRDKhKwBB9xHRHd1870x6Nws2fN2ID2bDwp8MUVN?=
 =?us-ascii?Q?5vHDuiLifgRgWaXBstmdMq4bBicwbHaVtckQqhAKlacs2U/6DUchtXrF0KHj?=
 =?us-ascii?Q?AHgEc3CA3YSUMeCiOMiuNKAHyOMqIFGBgLEbPiRJPC6IGF5JHDEfvJz8FmcJ?=
 =?us-ascii?Q?xGWaJQG09I/wbK/EJUcSlrskw5nTPDYCQUBa41pWcOUKpuCa+39G9yY5kCBi?=
 =?us-ascii?Q?3BD3NWEu9xOIVyYw5sbNPO31J0GMN37wrz+wNW7d9r9142KF4YRlhojLCNMO?=
 =?us-ascii?Q?5Ue9eHKLbIntnFJKOjMPQVrE3OaapYpbfyrH4hIf8lgZVrjDpJvrQ+k3pEsN?=
 =?us-ascii?Q?9X0htMjepk8Mfk/nXvMfErnIAVJc/jeEcJhPwJLpm64RM1j35R07uOixWWh9?=
 =?us-ascii?Q?DClflyrHWM0S7VKRLGL9pT6A8wngcS3knFtFWu9NGlHcZBXs+9DpcfjMlgyP?=
 =?us-ascii?Q?asI44MZs/UdNNbB0yDKid/cOAUlA0T10vpDe+bUmm3qWenE9+935jGok0Gta?=
 =?us-ascii?Q?UTPx4a7yEoVlMyCvufvYHYdAqM5gx279w2piqXBxJIKbE9bP1RET8qP7tnPZ?=
 =?us-ascii?Q?emJT38BqtD+wZblSxF0OseamJFIfpjbpPqzLGfgttzj0lRgYHopQZXUFXN1N?=
 =?us-ascii?Q?znR7tzsJjjRi13KWHJ01KFCgW/89sZxjgtXC4s/+MsuJeWm9Ti9g9tJCT7W6?=
 =?us-ascii?Q?1FxSEwYy3b1oC/XKYJEH89xG9Q6QGMoIBLfwUEymgZaOit4PyZHg4M0KIZJB?=
X-MS-Exchange-AntiSpam-MessageData-1: uNQ0qwPnpKq/D67asQAaUb2KBoQbQSjtphw=
X-Exchange-RoutingPolicyChecked:
	ovLnWa75CZHr/iXlVsmo8GSDaB9PbQslYvyIxQR4S6WGElFnHDnC+IlREKyRVS96nWP6nAD6/r08ZYR5knkmIN4FgKnikjtIbYeWBBpra+q2Thd4kltRMesRL1/x7okjXNQdt7yNa3qNVy+CduRlTJLOAtnVWkYTgNfwv6NekybmQ8OzjLBJrROCZfoMGIxQtQkMnaREOY1m1p6m4sq9bg3H4er0YmZ8F7lzDULrcq0EEO7Y1FhfwQNq8qoN5Pc4471DrUT39vP9DZnXiNyRfDBGjI8oXuVb2xQEzvNeOxHbe1CDB8zY7jIvid90brX47RgIqzSXAkL/Equ4yUPcQg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g2+Joh8rIIPvpj2hhQHBpxn+g5Tmuj5JMYkXWKvWm078KyHEJnjXpvaACR3pNQbqAqTAonoyb7WIcoVmmewnTnWvzr7Dvcp1QCbb1cx5tyedmlkohA5D2JQFHHVdKYk1VFkNLAKvGg1K9rXrJZci8W48xILVoUXh8eIo05Bfd8R++r41Kem+jBK/tKz+HR2hdsdI0YO3pZzcVh18WfSpXhmVklT+z7LXT0XJ6AqiB45oU5VZj4U4hRs+FkhPISlyo3EZsLg1FPc7l8Ngjruc4BsRBvemPEPO6FnJa6UQARVJ4Sz5mOlwalyJmLsXqTOX3yT+jsld4UzXBV546iCS2Ehg+3Lanl4o4U+EaH1FF7g7dmXoP2HueZB9Unim8/NErNuLgbikgLWICxtyvScph3u0+tKoc+xX24D3LnNw4j3I+Q/aJ+zxYXlpBLOWSKugmcEDjFcLtqNNw0g/XrLj1sqErOEsfo6QfhkQU/LFJ7TBrZFd1g10Hzki7S+4Vooet2UsFJ5Meodrv7IqqOeaov0xh40XMtaSX29xJqqDAzlkVxirE/rw0G8svWz5dhABFmIKV6VYmU5EPsyfKs+w0Rt6FPeXgMsozhmXOpUY6+CeoIAbaUS1Xd16a4nUmLwG
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ea7840-6f13-4ffd-472c-08df28fbd37e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:16.2261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xiCzM6DC5upB7RPlYMHDXl53cbk6uQf3IjmAanqmmLmnCJw4j/zAAZ+kCFQ5RrvpqVD3MlNB1VkzwqAC801VeKTpSodV+beruWzhxOng8Q4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

In call_zone_finish() the counter for reserved active zones is
incremented without holding the per filesystem zone_active_bgs_lock
potentially leading to a race for the active zone count.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 9f562cc34e38..51699136405d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2537,8 +2537,13 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 			return ret;
 	}
 
-	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA))
+	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA)) {
+		struct btrfs_fs_info *fs_info = block_group->fs_info;
+
+		spin_lock(&fs_info->zone_active_bgs_lock);
 		zinfo->reserved_active_zones++;
+		spin_unlock(&fs_info->zone_active_bgs_lock);
+	}
 	btrfs_dev_clear_active_zone(device, physical);
 
 	return 0;
-- 
2.55.0

