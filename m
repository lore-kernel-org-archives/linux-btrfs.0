Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BA0470106
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 11:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784719848; cv=fail; b=gOrqhFDtLPY5LXEQD5rvjZazxtb19ekyFN/l5GudKqtvNbwpE6G4WMIek3OaqvqT38RprDgXmeUWAt5XeNMmjSMZ5+5MgQY0P9B8+Fr3lLQp9HB4We43e793dBujHE+KfttojsT3bUrzGYzo50Aqn4R0MHeQ6XeC4ZADS2FBY5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784719848; c=relaxed/simple;
	bh=mZdByP9OCEmMwQwA1fbTsHeuINrw8y32JJ3QZNJ+BtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ilc86f1Q5QumM7eBiAQ5BoES/k5Yngr46SygisqtPEIOeKoUkujTpoyxwPW65uYClKO+1UqJ70PvpOaWS+mzTpB89BaZDU50d5hc/Br70P3PC3m6RMgz3MsHd+f1ePLAhBnVnaCzFJ3NnDHJ0VBoXRIY+SVgygoCI2pVG/DogZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=a8HQkuKm; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=oTQHunLx; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="a8HQkuKm";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oTQHunLx"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784719844; x=1816255844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=mZdByP9OCEmMwQwA1fbTsHeuINrw8y32JJ3QZNJ+BtI=;
  b=a8HQkuKmAJS/dNlpiKVMsU2jrUULKFZyZI9JMXRUHxgrijWpuIdg+7Rz
   yMcVcZN0Y/78cI4OboZz8Wkbr9FdHyf9PTeuPnpvptfaVEhtF0ig20vyo
   OZ8zR9rf4hgdh+wNx5Qe7hww+oIct1fvmV0SDppHhRDzAGI8tQQLtvxrH
   XGW9o8pu1Iq+Z5/BvIe2aMW/PsRuvTwi4Oe7lqIjDAlfm6SPLSfHMuaZw
   PS2JAL/DA0yEiMC2D3J8NQnTadECkImlzM2LguxYJrcTemFZwFJbwEyYN
   T0DdwKY32qI/SqoSCT0FCi596aPmVMAyAk439CFbI1KasvjMzqHwOpPxp
   A==;
X-CSE-ConnectionGUID: M9Gk4GozTCa+E0h/TtqWYw==
X-CSE-MsgGUID: O48rz8nZQJ2hXlwBbVFqVw==
X-IronPort-AV: E=Sophos;i="6.25,178,1779120000"; 
   d="scan'208";a="151556162"
Received: from mail-westus3azon11012047.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.47])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 19:30:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AXxtBI94MojMdCwZBH0y1948ojQC0dS1HTbp+pk8Ib27NUw4wWlALxlrtjiUWbjjAoV+Bi10UE8iKPeDhP5KHiOrebx0QzSObopypAuzc0eVCE5ENKel70B5EiYdkdjlJH2B4X2uLmUhCLt6hRoQCt4X8xecn3mE1WmDG7BSqENhyKiUyOJH24ZJvanr/IfaCLF1BHtGQTyI3enwr75gcJoHWT4x9Jbxr4lWYFswwCs1e28hVahtTxlNQa7XaD6g+kntoiheOzTG83Zoo0LoR0wqNYHVcIshFB5umjEipYlGxaBONQxlHaHySZIwAc0yM3Z9Wvf1uw+o4nys6ArBEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YKZSjBYgZ5/MOow2soU40evrQeHJ7OqsE0iZ/9qJCM0=;
 b=g488wepnL2J3WukpCroi5ZzlxUGuVBnAm57Td/34srbDX1xOR+oQm9+9WiWfWQSvzYC/xL5bSSmyc/g2ndFVYwaimgNSBAgN5stUPIgufVk2N69QQVaehcI+b6qBb+Pu1JjatSld/GsRQduXncV/gogs993jTZ/ecJEqXnqZkreQo/Z67Caw+3+RDqJ8/Aq2liiioUAqk8zdz074g2FetME+XPNmPgVp6YHv54Srqvv2p4aFP1Rt0CZ8pcpUmwh38PKzoNfz8nbyN19kWVTFWZC8BlGg8sh9y7AOTKStw4bhEO2mLLtY5cjT6E0smQ/fqjJSmv15lsiL44pQKWmjzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKZSjBYgZ5/MOow2soU40evrQeHJ7OqsE0iZ/9qJCM0=;
 b=oTQHunLxtFK6CVkWZNLDHuAGg9H/ESEKlR99EQ9IlPgIv+jA8KUalZjFpLlmPDH/wkJDVC7xmELqni22Y0rBs3xVlEyfoO38hVrjVxQsVj08Dp/dVVDWAw1ZpiwB5BvHJv304DP5yWUdOw+9pzSyqTeSHQaYWrzqjaI5P3ZkhyU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6810.namprd04.prod.outlook.com (2603:10b6:5:245::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 11:30:33 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 11:30:33 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/4] btrfs: zoned: flush active metadata block group at btree_writepages() start
Date: Wed, 22 Jul 2026 13:30:13 +0200
Message-ID: <20260722113016.1896990-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
References: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: f99bf546-b7e4-4b75-631a-08dee7e4a461
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|19092799006|376014|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 T2+lOnVodXFUSgd6IJW2O3kCDjRSg2AdCPLs1YzYHOWe/1cBZeS7BOk3oxCxcru5guXu6XVcWpg42loya/1c/HDaf7CWpVfOSArNZIslkeApeipzPQ+G9tywUqadyhrBtXRJS1TxC9Lwplb8M9sVcPJN4TLGlEfTRnS+g2n8uUemgnRMwJg5yDCJPsP6D9RdHFVCSFf+96YOcea8xhjPWq2dL1MY00Z+QKp/Aq13M0/RUPdf5BKcVaI5XJNAclpy9jr9hFSNlKetQmVKHUXHdesC0RNj812LKnwbz5tZQDUry5Fal8Xp3sMN/nxxvJhnTL1nw27tpEDUaiE21PyohK0I0qMkPkXzAswupTynez3e7apypRHpwC9K3a5eEzYcE78KpCO4+WzZ4Bi6UzLULEe5Nhj4kNycNptkGItRtlG8J6luT0nzvk5nIPdrSrMa5btXcRyjV73ffYP1sx83hPrjVD/OdIDiaaYfqDANKjWFte+y28X/szwtvlBR4LpCtcd3s+nAvGvUcnb0cMUUyoQuPj3lOhOjKhy/pATqB6jRz/6ZllBqyFcNjEwZc5JA04p2mtF5r4NUlTe8xGfL6b04RVJOWTRWGHtrvMzyuim9ovqc37+SXpwINTsfNRrJo4vBzdlu/p7IVm3BsEGsUbinrEHxnq4fEqMC5d70iOc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(19092799006)(376014)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?8JLymFoi7SdCpd3q87Q2+VLs6YdF54t62j21oHxikrLDM8ZpPQ8H38Af0iVE?=
 =?us-ascii?Q?KtZyHga29WDnWab3fhGsknoPLHcQnbiUK8b8NiJGnyi/NhPRCImh8t6zihDS?=
 =?us-ascii?Q?kzjc/pMHv7kRpLBP9hSq1mlbC2lnDnBQLzCVA24yTtPHb2L4zQIpbcqX/CvX?=
 =?us-ascii?Q?nUk1WZfe7+83G6r62JzqBs1KJcmefhavZaWcblyE8Okjf8n+qmHuQafJmLtx?=
 =?us-ascii?Q?am9Jg/OvxTHH4tHRFy+LVExKU1OlF6DiSnhZ7Tf35xnA3xuB6Fk34kHuc9h9?=
 =?us-ascii?Q?oIZ6u3/6oPViMNhqfyIPtgLjnkxCVkaWBkkg3uHPd3LJzJ7FlcGlXvT9ByQE?=
 =?us-ascii?Q?5Snqq4v5LGG5IGmCSTEE1yjp4Ut2nds52yOG28kwYB/UGCf08aBja9pnSSCG?=
 =?us-ascii?Q?I3ifwG59dwsvye3y182lBdJOn2zFegRmDlzcCaCVcUYIlzim7dzSzjwHfsgg?=
 =?us-ascii?Q?JDyPNPpGIHS2xIBDdW2oIsA2QCagH8vtwOZgczdLL/ndGJGiRL8uo+5+5QWQ?=
 =?us-ascii?Q?Zl6yq/EpRp1pUj+2o8JlLBawbxDWwgrk4aVNiaULSAPvJB56PKxxJlrGzGzs?=
 =?us-ascii?Q?zk5SGt1gQDg4F2z8qM2zRCLOtjcOedlorhS7XIvP0j+xekkpYMbQNw6X5s4i?=
 =?us-ascii?Q?MZGmCu8id7MRFWGik1TVALZGr/Y26tz0Rt6ocOMbRQtw8RjPm3LeB0w837/h?=
 =?us-ascii?Q?er+PxCI3Dnkwob09eWv2ANmcONn4hME8QZgJKiFGelFhsnH3UdKqKw4u1gKj?=
 =?us-ascii?Q?m2UlsmdZu76w7CpLcEKnoqHXN3UdB9PyLddhCYNaret/rFt67VVaWF81Kfdb?=
 =?us-ascii?Q?I4Dk8L70Z2T7drgfodwQucMqJ0X/RpWCBWfyHw7rUwMV6KndTTK9qkqr3QrA?=
 =?us-ascii?Q?qtNRaVXw6Wy572KYUnlKPn1V8b8IVaEG9rN2XChwsFFKH0RA87/i88sh5ya6?=
 =?us-ascii?Q?JDlj8duMMM37YUUHIzCjlGaCHyQbqpOdqUA9RLAp8IFsXAy1WVmDAVLhcBRS?=
 =?us-ascii?Q?F6p+x/F++JgTob+Tmp/eBKit5sLESev7saMoX6ZxBzAzmO+E84Oefrt+ao8q?=
 =?us-ascii?Q?dQZ9nDoLWUPkVXBs+5JZZGW2O3OKvmCJww5akj7DaOYczW4taPmBgmhI+uBo?=
 =?us-ascii?Q?rswC2yNjH7Vm+oCN6mfuK8yKWJsmhv+nvNAoDLXpDN7Fwj3mTD71yIIh7YF2?=
 =?us-ascii?Q?cXYZE/Gtf2vgMlHl91y6vWBGzMmO+qPEgsKrKqLdXc6azxCkaS5/LPX3Q4QU?=
 =?us-ascii?Q?9LRYA5pPDx16KMk98RNUDFKCSAKAicshY96Oi/mfkpxzhf8U5FH1tZpfV4eO?=
 =?us-ascii?Q?d1GYdNsSG/zZ8cvYNvzrum+av928LoRqG9UcqNVfW0dCaLgE+BwdADho/73E?=
 =?us-ascii?Q?HBOfZ9qQdVyHmu0B5Xzx6QDBbcOSkgardSGrTUiYyllM2440+43l9T7crGX3?=
 =?us-ascii?Q?JDhPlLAnXOwLHKO9zKmrWa/GGykfTSLeUaAc5FD5OPHu8DqTQ6TUfNixBvIw?=
 =?us-ascii?Q?W1iFEf/yZuevruoHbq8m1UYEqrmhCDiUOki4NkHHJAgRh7pb3B+akKXuxR2l?=
 =?us-ascii?Q?mwSA75jbIRDn/0I9NX4RTdiJWheckbMaNJ9EW1iCLO2hoAG3HjRoJQz1/PdN?=
 =?us-ascii?Q?iL3egFmTxftDrrV1/m+9vuQjvlw8vZEI3DFkMbq+bgPG/nihys5dAt6xNPd5?=
 =?us-ascii?Q?7GP+3ev2QMSyZGR36Cd7XIAPohrFwQ0m+IBUZPUZo/HakWFPyotZxpc2poxl?=
 =?us-ascii?Q?a+Pm20EaWHxWKofwhe+IbOQBgxzry8kkREuznp/Zt852xPnGBgccUf0t5gQD?=
X-MS-Exchange-AntiSpam-MessageData-1: l/QjejwMlyfkDQ==
X-Exchange-RoutingPolicyChecked:
	X9HFUbRkDyxsXjW1JWoIDfo7sIjTvjRwH7Y2kKzu1rQMRHUR2LJDgBpZRUOnO4+oK+ciVxzDaXldyppq0pT/KlV+PZWejv/c3eGrEddMN0ug56MOyr5FlYxZZj6RRQNHgyzF43Ztwd2vkpFEm5/Du+Ya44wJ32BJbK3J5Xyr0jsj3dSA/Biuixu1PkrP9jQ3REoa3BmwFSGTIgRw+hA+Z6KRp28W9OYwVQJFP+jlWokgQJSeaPvgTmHZEyRjptVn8PTY8H/zBCZ4KCSyVFABvsh5DZKBxzDer+cHCHHemiUIv1VUVhVjNPLIFWeJuJItEukL1k56eM9jEFnwk/EsHA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y72sgTHdtWN68V6kx65QAPpTeQR/gsRwrdmDSp7myEZ1eyzzgid7dDSRi48V7pWSb/7m65RK0tE3wGSPjC1ZmZY3KwnXW1Je+2PBM/fMViWznMTyBhNrcd1MYH9RQAuBwAwrhyE7fEO82Pr1luwrVvUMSq9VojF9QoqiYpG6xWJNYyKD/4w4xV8tWsMa1W9AT6CJzOuwopUJv4pcOCeBkw1V+9atkGYHA4tZdhUOQgO1Tsoc2rs1ufXhFJU4GN+Xu0fRLm/LAZzuZPnNW6p93sp/EkGZubwnWN2yHSol+hkBj6UoixYBngNVAo0NiOq1KdDiHHoop0B/gqYr9935KTahBagnEjqEd7RVCyAPg7ayO1GxFlAux8xluSDZphe+UjypDwgj1N/EGpqcyp57wm8sjlXz5+HQwwb6OA0p4i2jBxqZRnvFDYPoSmJeOghDe0vMRA29Rra28+5N+Rue9sU7pCMLZ0zT0Ifa2fz/MhHupm+1U1YHJEkteKDeLq9cwCuet3CjKQTP70+cUPjGULCBC5E+o2I6E2ypgMdndXOnrV6jqRGppfQ3AWVkJuhuzW+2vXLSiF2bg0Z8okMr84sZ38NL3W9idCa0F++e3U2fiIfNkM5NP+56LZSY+3mK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f99bf546-b7e4-4b75-631a-08dee7e4a461
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 11:30:33.1289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mFhjHgEABnhkolztReqb8Ao4wrtJpBh8rJPBNFSCbzAyvz/Bgi0WLoX1IrEVfppMpjvoYzO6hq5NjA8n29DWQRlAcggvD0ufjx8cQXWQtW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6810

On a zoned filesystem btree_writepages() writes metadata in ascending
logical address order and keeps a single active metadata/system block group,
pivoting it via btrfs_check_meta_write_pointer() -> check_bg_is_active() as
writeback moves between block groups.

If the active block group is at a higher address than another block group
that also has dirty metadata, the walk reaches the lower one first and the
pivot must finish the active block group. It cannot finish one that still has
unsent IO, and refuses to wait for it during WB_SYNC_ALL commit writeback, so
btrfs_check_meta_write_pointer() returns -EAGAIN and the transaction is
aborted, forcing the filesystem read-only. This happens intermittently under
metadata-heavy relocation (e.g. fstests btrfs/187).

Flush the active metadata and system block groups at the start of
btree_writepages(), under the fs_info->zoned_meta_io_lock it already holds, so
they have no unsent IO and the later pivot can finish them.

Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
Assisted-by: LLM (debugging, commit message)
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 62 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 97bd18d515af..bac3edabe7c9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2383,6 +2383,52 @@ void btrfs_btree_wait_writeback_range(struct btrfs_fs_info *fs_info, u64 start,
 	}
 }
 
+/* Write out the dirty metadata extent buffers of a single block group. */
+static void flush_active_meta_bg(struct address_space *mapping,
+				 struct writeback_control *wbc,
+				 struct btrfs_eb_write_context *ctx,
+				 struct btrfs_block_group *bg)
+{
+	struct btrfs_fs_info *fs_info = inode_to_fs_info(mapping->host);
+	unsigned long index = bg->start >> fs_info->nodesize_bits;
+	unsigned long end = (btrfs_block_group_end(bg) - 1) >> fs_info->nodesize_bits;
+	struct eb_batch batch;
+	unsigned int nr_ebs;
+
+	ASSERT(btrfs_is_zoned(fs_info));
+	lockdep_assert_held(&fs_info->zoned_meta_io_lock);
+
+	eb_batch_init(&batch);
+	while (index <= end &&
+	       (nr_ebs = buffer_tree_get_ebs_tag(fs_info, &index, end,
+						 PAGECACHE_TAG_DIRTY, &batch))) {
+		struct extent_buffer *eb;
+
+		while ((eb = eb_batch_next(&batch)) != NULL) {
+			ctx->eb = eb;
+
+			/*
+			 * Best effort: if the eb is not writable at the write
+			 * pointer (e.g. a hole), stop flushing this bg and let
+			 * the main walk deal with it.
+			 */
+			if (btrfs_check_meta_write_pointer(eb->fs_info, ctx)) {
+				eb_batch_release(&batch);
+				return;
+			}
+
+			if (!lock_extent_buffer_for_io(eb, wbc))
+				continue;
+
+			if (ctx->zoned_bg)
+				ctx->zoned_bg->meta_write_pointer += eb->len;
+			write_one_eb(eb, wbc);
+		}
+		eb_batch_release(&batch);
+		cond_resched();
+	}
+}
+
 int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	struct btrfs_eb_write_context ctx = { .wbc = wbc };
@@ -2418,6 +2464,22 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 	else
 		tag = PAGECACHE_TAG_DIRTY;
 	btrfs_zoned_meta_io_lock(fs_info);
+
+	/*
+	 * On a zoned filesystem, flush the currently active metadata/system
+	 * block group(s) first, under this same lock, so the ascending-address
+	 * walk below can pivot the active block group instead of aborting the
+	 * commit with -EAGAIN.
+	 */
+	if (btrfs_is_zoned(fs_info) && wbc->sync_mode == WB_SYNC_ALL &&
+	    !wbc->for_sync) {
+		if (fs_info->active_meta_bg)
+			flush_active_meta_bg(mapping, wbc, &ctx,
+					     fs_info->active_meta_bg);
+		if (fs_info->active_system_bg)
+			flush_active_meta_bg(mapping, wbc, &ctx,
+					     fs_info->active_system_bg);
+	}
 retry:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		buffer_tree_tag_for_writeback(fs_info, index, end);
-- 
2.54.0

