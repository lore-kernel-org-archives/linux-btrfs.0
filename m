Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57D7479899
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 15:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784822089; cv=fail; b=GUdlZ4h2dcDvv9sAfgjIfsMmXS/3bl24MaTVhV/0Tx1C3ojlELbI1PXX02O5yxkfkDwJ3Wlf3xLC4pzhBAiKxVKUkAeSQLCOLHfLEqJcoa3QQ3KntO4orSgH1Bv8nAwtChylpQOfadtefpnHSYUmLyhSY3SiLbsNmcSn9q406fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784822089; c=relaxed/simple;
	bh=RazfdmGJsUPs4XHa4BtfDN69x248t1tTTMEr1ovxNp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j6aMPiNXNTyQLL/AUQx6HocKfHkAtoEtUaNxGXnse+AtuD5ysJKURczgtTxHFuaomE1n7gv4XycfB8Ia1f4N1m4RrePMqCbQH0FqpmPj9DEgKkbMDa5xJst0DxVMgHXpw0pcMoJ1CEZ87lu6uFGr9DgH7vQ6VaMRGtNxOFWRr24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=X/2XAa7G; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=U4di9opj; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="X/2XAa7G";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="U4di9opj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784822087; x=1816358087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=RazfdmGJsUPs4XHa4BtfDN69x248t1tTTMEr1ovxNp4=;
  b=X/2XAa7GvEa4rQcWNN12Cdqgn1av/v9vN5fw1pRihIlz88d5XZGnygk1
   ptDQR+PxXjxXIZ/Rh7v8z5zXSYu9MZXP2sl9XLcIegYCUM9myriE/TqAA
   BjE0WCzhF0H/wD9cHnK/ABA4WQ2WcGKwfgJrx7eYupnwpopwhWch/0JoJ
   IfqyTDbFlZ1WvrIGZ0v0BLeH76+5FMuCYc7RynPKDdI6o4AVr3zfc7Lsj
   8If8LpdF7391Op8/2PRmA7OZIX1XO1KomJGta6iIyuxI7iKdJ5LYomHd+
   6uotyDQcgOPmqxCoyUGRjDMH3PySvQ3OX1IKzireas5OAA7iUqWk8ennz
   g==;
X-CSE-ConnectionGUID: stp6HV1SSfObCF0MiteOMw==
X-CSE-MsgGUID: jgwJ6pFdQaC5q9/fDyaRgg==
X-IronPort-AV: E=Sophos;i="6.25,180,1779120000"; 
   d="scan'208";a="150693707"
Received: from mail-eastusazon11012068.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.68])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jul 2026 23:54:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZSJSQsYN+NGAoYTMCjjZSkZSpnLzH4HbJKizQ2g+5Au/jRkRkF2fMXVHkfhQR/kb0FY5VVKduE/EaLcfYdOLDa8z2HEIOcvbyQtRus7RsjgYhJzcFEOxP2+cefWFS3I9ShmCb4R8ZQYT2VJ+CPZvnfisgQuzHrpb0GNQhpMjOE6gsT+iwv6Fol3JWKsB+L8fsa0hpdP7IefDxOfAZmoH5K4RCbQaPExn9yttxKyeycrkhUok8EwU9aTX1cApTxChNaioZzvC8Q+mE/AkqxeujMFihjtvYqP4sHxYE64sj5t+7HQaso5ZWVg99VCRn8JEriz7TWv35YGrxjV57P9pqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3k6BML62m2nJUzNvIGpEgXzd90S+09YdqlGR4NEHfaA=;
 b=fYMrsqQaLhTuH/PejghvHo113vCipgYC/g9cshVX8IM/dcgrKKjsW0krHahqOEBTli+TKyTb0KxVILsQ79nZnexfPxlJBvKTtrHcrRGXjW5JUcJgrDRln6qtgkToahDVCnZBZ0QSRjjv9nZGmIrItnIkm5Gc1rL0HDZEp8YfUG0XrkT6N3Im3lH12rroHSWXENjObDk83Lym1JE5aI0NU0P+RC5fZircDN46ForZOTM0ms7zAeZae28pHtViz+NvvmcqINKPJQg55gnE06DHmgNKy/bBr4GHn2Fl8KhoZ8TmYhp1DHxgapZq+NlFWQWyVzRZDyjUR7dIYXfKixJXxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3k6BML62m2nJUzNvIGpEgXzd90S+09YdqlGR4NEHfaA=;
 b=U4di9opjIvEoOb95CKNISp7NGdPwcwPdXuG44HOBMJNm2noEK9uyx8iE7ah19cooAW9+Ks3RwT6krpnlfx2x6ICbso35wAz0FKf32aufNQeuZsihx3TOu7Cjtimouj5THfJ2v2kqzvoqHWeZ/ICm0DJP6dU1zJyLtApsFCYmnbA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV8PR04MB9295.namprd04.prod.outlook.com (2603:10b6:408:25b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 15:54:45 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 15:54:45 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 2/4] btrfs: zoned: drop stranded dirty metadata on transaction abort
Date: Thu, 23 Jul 2026 17:54:26 +0200
Message-ID: <20260723155428.94187-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
References: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV8PR04MB9295:EE_
X-MS-Office365-Filtering-Correlation-Id: abf46707-09f2-4292-0541-08dee8d2b76f
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|19092799006|376014|10070799003|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 CLEbKhko1pGxIljqFt9g4EK6vkqcU+/LiLgEwWQxEU992bLBZlNLTLhOPPN9AGiT8yEVISqiVLXzhTuuQS5pCrBpMGuzbvldZrZsipFUMb8ctwYFNeAfK83ZeSuq7D9vc4wcDTOErFXf3YpSV3PrcsK6S/2FimP4SFmk4cOvC7RqDESMENTiDdllhTA+kJzYOGXY9J2amIzB3BnhVu3MzErlum9LHpxhUp2jMzwu7FIL9dLYsdtc10+V5fN+z7RI28vH+wjYyyQQpt5e+nphhzPDnczgxGW2lkO6tkJI3z+OO5JCWTU19MWMOh+zX8Ck+F4KnXdUpx0QicvYt3FYRo/4q1PvkpHYnoIyV/fy3sUV3WW3G8TdDZiOfRDUtRkR4CehzrzUO3E+c+byHJUdxsbX/kgR+qTcCrUZQI/qhp3cXN6mJRqcl2Tb/PO98umjwcVqHrpRT9QsYO4AbBjusCcTO34sJ84XlAKfsJkbvbjzEcbdQUhpjRPbFkx4wgEEawemtfCg4WMjHQCKOO0Gyk/PAEE8Efsnr1I7Jh7k47a7cqEZ+hgQngsvnLrLvxDVxo2pAWCyj602e4kKCsAhjlXNBeEJJI5t68V31XO/+7n7168qNfW+eRZ9ykADkWFrqzkHvcf7xMV670lULQl9Rqi/tXxpcECVJq9pufJLRTU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(19092799006)(376014)(10070799003)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?D6j9S/OeNKJMJokSDOUexO3KHKsnN/bWk+NSdB6+y2P+JYBttxjTT+TIwQhA?=
 =?us-ascii?Q?A3vmsKhq4yn0x+Kz8gYb91wnZ1KDNbqxdKOfg5OQEw4fvFk+yGBkj8r8KiUI?=
 =?us-ascii?Q?MkJbPFP3Myca45LZIb8IJ2He4sLwah/0vGIjPVcBEUB2EhhPXpf3lHkT00fp?=
 =?us-ascii?Q?oPu5t/ENwoEhIMYAhA1Tv7OKklQFZRGR9MeHOhAOtRC7PAHdmVZPzlOLeztR?=
 =?us-ascii?Q?oQUMxSo6N05lP+wjjXiAt/Kj9zKk99UlNFUlPkOm0BAYrBuehaPvE7PqKBzU?=
 =?us-ascii?Q?XGZm03lTfoEQrvoXcicuLOS330HH5qKg4l3gzTnVXUGZyBASGFOh9/uKUPBp?=
 =?us-ascii?Q?1SHzwCN4zsE+RmPo+H2q5CEY5fPTTmom0Mcb1/rQlyHVnAhA3BOaWkt4wc3l?=
 =?us-ascii?Q?ZdBQVGj7MCgGLGXpAwmKn0ARHxqFTsj5uEvyr9WpmPePdoMz+eCCr/x63Owh?=
 =?us-ascii?Q?MLGkzCdxtyWkc4Bv9JZGnUZiwdVgdgz3qBE9gWqnArt4lEj3U/OqMhDOkA56?=
 =?us-ascii?Q?27nKep0bH3wPxz+pdJdiajxTUL20EezC5j5GkBhXmwckKr5YLp+EahbqAixX?=
 =?us-ascii?Q?aqOQLcCU4yuhY1xQdVEexak7I/2pTZ9+XP9jDmPTbpo3ZbCyB+R3aRvYNxj0?=
 =?us-ascii?Q?UU7+5N14dZZGI/Dvjq1sU2Ti08ivoGkpKltHnbAryTv/YHawU0k9/CCclWac?=
 =?us-ascii?Q?bDAFgOnh6ngjCYJzxrM7z8S8LZ3rghfEDoZl4BE825jlT0CKKrGmz1EBqedZ?=
 =?us-ascii?Q?4aT6L/dKvCYj2vF/WaVwVdmPr+DA1TtaLhMs4GhyJBqTIX1LTyNDs2wHDd2F?=
 =?us-ascii?Q?vKF7hCiFFiazZ/IDzw8DNfxB41ca5s9hGx9g1chYf5XYtYhUka5Frf3W+aTm?=
 =?us-ascii?Q?YvL+shChzue88HA7IEE5CdRA5uBpox5FcLVwtNaUrwt2SnjAFbWkvErtBfnZ?=
 =?us-ascii?Q?WyOElL2XQXiSDo2XkPtynhk70yrKXyvEp9cIbrT1SHQoeeOM+T50HjBp+O44?=
 =?us-ascii?Q?XbIQ5kKqlAwoimXECK9olpumtWgvCoViowSrGSoMzRtawtFD+7aRLNnsmXyH?=
 =?us-ascii?Q?XthTgqCtel2IMiCzuN/JshnAhlMY18LKcfX50q+hUc1+7nuh8nWlL7Kmox9y?=
 =?us-ascii?Q?7c6JFtmzGuCHPh8zJ9PNL1ut5+W16a5icdNamG6dc87WKkw9Eq5434CQsxhP?=
 =?us-ascii?Q?GaXzO9dyP2e/uYw1clx51c3Q3W6HrPzIJTWnzj8HIitpNCQhhORVOEz9More?=
 =?us-ascii?Q?k46H3DhArKHbTwC0kTVH/taS4mdIFnzPCMVF3Riy2j46dZO9j30R0Pkq2Hw5?=
 =?us-ascii?Q?KK4zcveLLL/KqvscKCEWmW9jyEFDcmOu5tlOXIGUtwVfDe+S0q/mBax2xD6b?=
 =?us-ascii?Q?fajju33jIMtPWnJifnZz8sMgdXDWUbFcCvwnwk5M7ozkBnvQTFW5YC0tt9cI?=
 =?us-ascii?Q?jNSiT3zFPqBgD9zFO7Ux1ngCDkUTQBzp3k7t8MMw6HZk4pYiG2yAXM/at/nb?=
 =?us-ascii?Q?Qod6dUTp3E5cXooJaHpJ9Q5HtGRvlw1y+L/TAe/hZ8Jibos0rHt8MbTKCdQM?=
 =?us-ascii?Q?wnPv/iu408nSXiZm5rncITArRDLNbxiu//x8DGo+1F6cVgdxizuk7LxShH6q?=
 =?us-ascii?Q?0vFM3FByr60Ufu2rzZiaySo7GU6shWXwlfIrUCTHPLNvbqc/COyE9Ef/npW4?=
 =?us-ascii?Q?erpHPt6iQV7gyi3oq0ue1Qsvd65Skh4izgMjRpdYkvWsdKBRC28weed1uEiw?=
 =?us-ascii?Q?IW9aS6JdbeT4L1hIJwqD6CXsqSDWyXE8s+Y17hnUcM5d19ePAaIrpg8f0a38?=
X-MS-Exchange-AntiSpam-MessageData-1: +/zHa+vdsMyuFg==
X-Exchange-RoutingPolicyChecked:
	SeJ5a4swIVP4c0UP68tACL+Hr2FcsWs1T03KbD8aZd1Kt/iyvxWTTVDIQMGSlED3UPHZ/f/eIabTW6i5LpU20MA0iJryWnC+QzOsqiGnsC53r6/R8uoKZQlA3hHXSvk2N7JJ8yjjeQef/8+9vrVmj4YCPz7K5l6kzKa8kSHrL1CsclBeRcb+jkRSKh86MaH3+HOXdMFJFvMEImTBbIkmIssTHE64uXEwH1FfNp/eqziDJ64RTW1RHfHo1nq8JmhA2kM92f4kJgLtYEiUuyEcOeY9IK1i1TTArenVubUtP5kMl2X4xq2pYLVIdAgLgvbiOK/qy9upey7prcvZvIs/ug==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C1QsSQA4AmbgJnuxHLLxnfGC037XC0h8SC7HmvHPka8g4EWywHTD0hblexI1zl76PPSM5QYe26Ar/H9zwdQcbL5vUylAsYtvNwwqEwBYBNWq119DhuZsjgKBr93Q475VQWKd+y+Zqfwt97xFU46pi1LfZ8Nc6Web7X+13ZAYoXt6Av9P9zy33zjARyRyyY5tPJ5kb1XjIlvZKzuHKK9GO5pcpKTrqVNuHlrKp0FhtGvdaCZx0OXRJGu6jfXb3D+yk1zIXclpWxZoTdQCWywkptbe/Hj8S9km0hojK+b3JkYz7MbjofAsHpEqH7jtSIg1f9xLIhWIPh+L8FJ3tF5IVhabm8IfECx4Miu/dJeytRWKCv1rLGzCaGdXz9yCmFNF3tHvPwACD/6sR8gEASzwzsBJ6DIuVWyk1FgMSRZCK8sHOCUBsTU5OQAGViJg0c5WgpGRYIG/eUpvhe0tTQSbm2loBR3nMI3BSkHk6/lKr3IWQFb1ed6/jLAKRrzyZaPxHk9pkRzc7zWs73UVre0+7297HtwDa6huXUyx4iaZx8pEHAKCumi4ZogRgBxWeKRrW74jDrW8eMWU1ccj3Gs+ypaTxqfujkAawyln0zb3q+qLrf5rRSS0FfAhkrECUcDX
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abf46707-09f2-4292-0541-08dee8d2b76f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 15:54:45.2509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Dasx9hw+lM+hF06OLiBfp3McDzvtNdaDukcsN4pGKJTc+AIf0e0O1UycyNaAUroBWEes557B1tVvIiLpMc01z2B4wq6C57rsejZOXviUr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB9295

On a zoned filesystem a freed tree block is not cleared but kept dirty
and flagged EXTENT_BUFFER_ZONED_ZEROOUT, so a later writeback zeroes it
out and advances the zone write pointer. A transaction abort turns the
filesystem read-only before that writeback runs, so these buffers stay
dirty and stranded ahead of the write pointer where btree_writepages()
can no longer write them. They survive to the final iput() of the btree
inode at unmount, which submits the write after the endio workqueues are
gone, hanging unmount in folio_wait_writeback().

Clear the dirty state of such buffers when cleaning up the aborted
transaction, where the buffer tree still references all of them.

Assisted-by: LLM (debugging, commit message)
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/disk-io.c   |  1 +
 fs/btrfs/extent_io.c | 74 ++++++++++++++++++++++++++++++++++----------
 fs/btrfs/extent_io.h |  1 +
 3 files changed, 60 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 67171e0d41b3..8d0afc2842cc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4997,6 +4997,7 @@ static int btrfs_cleanup_transaction(struct btrfs_fs_info *fs_info)
 	btrfs_assert_delayed_root_empty(fs_info);
 	btrfs_destroy_all_delalloc_inodes(fs_info);
 	btrfs_drop_all_logs(fs_info);
+	btrfs_zoned_release_dirty_metadata(fs_info);
 	btrfs_free_all_qgroup_pertrans(fs_info);
 	mutex_unlock(&fs_info->transaction_kthread_mutex);
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e3125ef701ce..fa473476b7db 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3911,6 +3911,32 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
 	release_extent_buffer(eb);
 }
 
+static void clear_extent_buffer_dirty(struct extent_buffer *eb)
+{
+	struct btrfs_fs_info *fs_info = eb->fs_info;
+
+	if (!test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
+		return;
+
+	buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
+	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb->len,
+				 fs_info->dirty_metadata_batch);
+
+	for (int i = 0; i < num_extent_folios(eb); i++) {
+		struct folio *folio = eb->folios[i];
+		bool last;
+
+		if (!folio_test_dirty(folio))
+			continue;
+		folio_lock(folio);
+		last = btrfs_meta_folio_clear_and_test_dirty(folio, eb);
+		if (last)
+			btrfs_clear_folio_dirty_tag(folio);
+		folio_unlock(folio);
+	}
+	WARN_ON(refcount_read(&eb->refs) == 0);
+}
+
 void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *eb)
 {
@@ -3935,26 +3961,42 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 		return;
 	}
 
-	if (!test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
-		return;
+	clear_extent_buffer_dirty(eb);
+}
 
-	buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
-	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb->len,
-				 fs_info->dirty_metadata_batch);
+/*
+ * On a zoned filesystem a freed tree block is kept dirty and flagged as
+ * EXTENT_BUFFER_ZONED_ZEROOUT so a later writeback zeroes it out and advances
+ * the zone write pointer. Such buffers still dirty when the filesystem is torn
+ * down can no longer be written back and are stale; if left dirty they hang the
+ * final iput() of the btree inode. Drop their dirty state, and the deferred
+ * zero-out along with it.
+ */
+void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
+{
+	struct eb_batch batch;
+	unsigned long index = 0;
 
-	for (int i = 0; i < num_extent_folios(eb); i++) {
-		struct folio *folio = eb->folios[i];
-		bool last;
+	if (!btrfs_is_zoned(fs_info))
+		return;
 
-		if (!folio_test_dirty(folio))
-			continue;
-		folio_lock(folio);
-		last = btrfs_meta_folio_clear_and_test_dirty(folio, eb);
-		if (last)
-			btrfs_clear_folio_dirty_tag(folio);
-		folio_unlock(folio);
+	btrfs_zoned_meta_io_lock(fs_info);
+	eb_batch_init(&batch);
+	while (buffer_tree_get_ebs_tag(fs_info, &index, ULONG_MAX,
+				       PAGECACHE_TAG_DIRTY, &batch)) {
+		struct extent_buffer *eb;
+
+		while ((eb = eb_batch_next(&batch)) != NULL) {
+			btrfs_tree_lock(eb);
+			if (test_and_clear_bit(EXTENT_BUFFER_ZONED_ZEROOUT,
+					       &eb->bflags))
+				clear_extent_buffer_dirty(eb);
+			btrfs_tree_unlock(eb);
+		}
+		eb_batch_release(&batch);
+		cond_resched();
 	}
-	WARN_ON(refcount_read(&eb->refs) == 0);
+	btrfs_zoned_meta_io_unlock(fs_info);
 }
 
 void set_extent_buffer_dirty(struct extent_buffer *eb)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 869925337699..ad4ffce32702 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -393,6 +393,7 @@ void extent_clear_unlock_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 				  u32 bits_to_clear, unsigned long page_ops);
 void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *buf);
+void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info);
 
 static inline void btrfs_clear_folio_dirty_tag(struct folio *folio)
 {
-- 
2.55.0

