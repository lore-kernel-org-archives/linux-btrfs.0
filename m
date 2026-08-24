Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA04E359A99
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 16:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787590094; cv=fail; b=hjzyYZCkYkrUO4mf7ZY9WoGgdkcxhGZNP/8RzrYH/cYgaBW0UtfpkbGJhD3gNjFvLv1udi4rVV2PqL4mqGMmNKFr+ZKGSFyNXfDLqXWtdBJG9HU3I2aizGdSjBlVXljZbcfyqEoCuvQ94sGNpa4iJGXdyaYo+Zr/3iM+glF5Cp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787590094; c=relaxed/simple;
	bh=5ogsX0hlJVZF1blFgzJq9RIcBoehYJETfOUguhic4S8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Hw01NxJC18S+TbE/Ec1dMXZmV+Dgv4HsBAVPJuIr18dQy8QFC3Xon+E7ILoiY0/LY7a+vrJbKpJVTYn53dgKNMXr0k543kaOEFJTdnJMtJ+NMGP/6r4v8mCTlEeQHQ4yKM7sye+tlxuPwP15aTIybB3W4xid44cOFbLhHScdctw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eAQAJc3f; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=QLjSMEa2; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eAQAJc3f";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QLjSMEa2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787590093; x=1819126093;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=5ogsX0hlJVZF1blFgzJq9RIcBoehYJETfOUguhic4S8=;
  b=eAQAJc3fmYW19mJ7Rr8t+eiBeX5+KlNCFReDZO4WHVLB2kAB0y8IZifi
   vxjEU98NWPKV9viXoB4V9tNTZy/qgIdOaFU/QyZl9FDpfY0se3/Dvg6+Z
   nzMDo531iHF7w1zKLBkydrvEc2WzliT8byvl7UKo7tBpNNew+D73hwSRK
   7SIanHteyn1FhtPaqBqwYCUaN+4bNQ33gjkwFGxfkup+0CgCoPNjkqIZI
   CfVhhHMQOgO8gsFzQ5moBbXvgt688D47HGYj7BsB7QdqTMqdl93P83g5F
   wkp+IBhaKpFcYlh8nXoKPBtbQMnOtVWKKEAzMzxkytRXSm38jbgOBmOV5
   g==;
X-CSE-ConnectionGUID: Id4ZQyGbTX+qu26LNnZtkg==
X-CSE-MsgGUID: f3cfyeSjR46kLCDCCnMQnQ==
X-IronPort-AV: E=Sophos;i="6.25,241,1779120000"; 
   d="scan'208";a="154166584"
Received: from mail-northcentralusazon11012068.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.68])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Aug 2026 00:48:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBE4qKtDox1wzovQK3zVTulKGtSrcAZ+AG0HoC27Wv6b8VZcm5AxiiCQu24ozz5ZydQV57d8rYCm7LqocnFG32ma05t2wzXfg9lmcXXAYU+FcOk54yywm6fPdz0yRmpwKlmaY6BgLeovUd8K0NM6flWfQhHsLXjVTnybR/lEXpuPsxzyFojwNlTrNmWsgS1LvszLT5KEgpYTdbQx9VoVqq08EMUTTmJxsaV+158yIbJgm+BGfU5J6WV/eWQxDAyLnrvv63A0YCRnuAvMxg1bmYHmHgn+4GaAQBgJCP/oSOC01aFfr/53G0D8cLBTwjO0NfMVjQ5V3zgHUmO8hblbQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOFuWIoVvG0tZ/sotxF3XmN47iu60AI7WNjmXuErunY=;
 b=nqBJrUQnMb6ij9QPg5dFbjgXKNKg6fWq0HctfE5791UZkXgm5m9neDi2T56ezrzR23YoXsg/eGtSjdyREry6UDHg8DtdxAJguYx5sPJ2foZZRVXgV4v5WxkkSuCRO97E5aGJFjIKPWLXpqyPAksa1VPqvxF8XKS0i4pXR6yEp42588DTKtcNgI8A0GD7oEL05Qyj/59w8QopDYGMYhOp/Ht6V4Sv6X3ubdUI9UDvrMs0rFQXTPKX4rZQ1rRpz03CfzXoscrKB4/TkHky6A8BwNjV4KIfRQC2ZPm859Vv/b+m9nojRS8pCWUQj19yzWnthKji8U5ZYHcs+Duy+KUN6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOFuWIoVvG0tZ/sotxF3XmN47iu60AI7WNjmXuErunY=;
 b=QLjSMEa2bUMdifDSbDywcDMB822booFPokErLiuZdFqP/XNeB/tuv7IFa0yBKUnMy1ehaNhQylzMjcbazUaR4yyJ4W8wzIR2gd6DO4y9CXl5KRHZbh62FjQvrlGDB3QOiSh57COjm40oiK2zGJ43SWjiQ8rcnh/VPJajfseM8h0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SN4PR04MB10211.namprd04.prod.outlook.com (2603:10b6:806:1ef::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 16:48:09 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 16:48:09 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: set space_info before adding new free space in btrfs_make_block_group()
Date: Mon, 24 Aug 2026 18:47:58 +0200
Message-ID: <20260824164758.2012077-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0016.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::26)
 To SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SN4PR04MB10211:EE_
X-MS-Office365-Filtering-Correlation-Id: f0e2870b-7474-4de7-9e91-08df01ff7aa2
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|10070799003|376014|23010399003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	XMKFCJP25evckR22ah06X3MxE7FraRuhCD4gGrVPOXpVPQarJ9vVOAR8CP/ne/dTAVwaretgRLV0AhfG0ZmkNxSlUvAWzU/exbXdWwMFdjhEazh2asy318kz8sqWfjYukrFJg/b2qkDJE5110pAXk5jLxwCU6T4ECN5j+mUCnzjdWTbwly1cnLMlr/8rCQ1T5/BLEk7mcya+w6VxUS/m2UxfjNYmqHepvtdZzsWIX/LnYW5A5uPtZ2Xo/RAH6ycnSO458Yc8Jc1np5BmfgmmOVbrS8kKUEMmEbUdWQqCJhHy4haEPyISX4CUf3ntpjJ6Zi7h6xAC9q592YKS/40ZG5AYvrwvFt55VlRytfnDa4xWWJEegnI2ndbWowDkXYAgSLhL/ZcDzDTtSIve7bw0LaISqUQY2fFMueISyKejr4/F0Bm8q3tQhvwBrB7kujxsl75mHIbZ30KOAGPO38hpl5MZLn8wL7VAXrmQD1u0RTLsrukRxs+/yY/YUyNL7yz9QGtuAlP9F8XMMklkcnK7cteUneNOcd8/sYwX9qyUXZdYySolW9m0mXSfebNaQcNQ8r/vr6jLDNT9MPlcv17VF1M0w4c8EFiJZMN3vq7aZJlHCm7y+yF2ZgmnyWb2nkUq7w3xijopUEqpJBHrhdxA4Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(10070799003)(376014)(23010399003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bXVulZk2c5N5f3ZIH8Pf/yxo83EIUA8KvXpHwYvAt0U5fpEBldk52zy3EXP5?=
 =?us-ascii?Q?uvnXCauv4aVFN1LNSLwPlRBRtJB6SnBo1XQ0MvGXiPFL2JCaAr/tkFxX1hRt?=
 =?us-ascii?Q?itx/ykOZVUqTzRnHE6oflYARczPAxmSJz4raTm7UoJQpwk9ZHiDbrQc4Vqd9?=
 =?us-ascii?Q?CRVWTX3U4ozrJh6dyDpe1fCtS4vqX9HzAVB33bf4+kT3osBJJxKSVC7/7CxB?=
 =?us-ascii?Q?MUPOOJT5+yDyDu7xRYmH0sExrrrXBn6Ot2YUlZ60cIcG2nBkBAd3IF3irVvO?=
 =?us-ascii?Q?5uVRv7X7cJLUl5m1R4KsbBV948U+nm3d64DqoXWXYqBMpaitTHwcrAzsThPr?=
 =?us-ascii?Q?P4Bu3whwTnNyj8pR0CJpCH7WV8IciqKtg56gf7YpOmY3trARTnwgPnCenhfa?=
 =?us-ascii?Q?YD+kvSYRV4FUiuykVQESbovF+qXXHaazqoy+x9QQjv6iDfdJ5idbzX+LkkAH?=
 =?us-ascii?Q?EUsWBJ2BQRCKgboFX+CmvEwOK38HTEkarDscm2dkwKxnIfYihux6JcUJe5iu?=
 =?us-ascii?Q?33hVkch3AGaZ+2HreM5ncce3EINyPwF3HnrG5kzDjRLleidx6rpLoFACw5aO?=
 =?us-ascii?Q?rvAYleqNnS8CaHoDSYGp1kFlqGE6LBnUoh+FmMX5aKHfgD2gTYgR6w83EOC0?=
 =?us-ascii?Q?vkK6uHVhGTuv1UvjILZ+iyKDiW3aM+l59I1vzBK4L0ZQDm4grh9Xw+oHOQb7?=
 =?us-ascii?Q?k546SdliwUtiPxgnPU5GTq6lvv6L3Tke6EKKPG23WbnFnXQpfunf9U/o4VrD?=
 =?us-ascii?Q?JkNugdqPmIDvbxO8QCGKGgmtkOVBTzixadsYLeV+jYw5rUD8xvx9z3Vj8Pq1?=
 =?us-ascii?Q?CZUqYcrBut1wB/1/6F0dmL34a9BRGSGH35jBBGyWcyJr35mrl+Amgo4ugGV+?=
 =?us-ascii?Q?INRB3oT0RHC3axK4vDdOfGsXPrWfgfDSbLWNNojJO9M13pDlUM/kZKTRBqcW?=
 =?us-ascii?Q?KW4QWAN9GjJBLW0MlxzLlghQd7XaTybpx++d8ALFNR1KWA4NfrOW4EFNbcwl?=
 =?us-ascii?Q?buL+De1WwZTmwdNAEiAbss2MFL6LxQrfbj9iQBU0IySMfBCOGpLkASDXH6r9?=
 =?us-ascii?Q?4XWMIsYole1ZgVd8Mq9Y+1knJxjlQaSviRaNTlweyeOZX1McchI3HU9kk8ea?=
 =?us-ascii?Q?AJ17VPFyak3zaXqX/ESMAxb+KsEVidCFTw1TeELZbHmjHoaYrGjajPCgxdvS?=
 =?us-ascii?Q?khv7EkuOT3JSBlibMeqCpf9j6ZZWk133wW1nkI6La7QvRS4LsJDtZJnFsJUx?=
 =?us-ascii?Q?NVIZlG2gKCCd3YCoVf3jTG142qoFXUK980KRwOeWa0R9N4eKeNnXzbNTS2sQ?=
 =?us-ascii?Q?p0Lpp47MRhzqmr4CKGAXSbG/EUiFCljDnnt01N2EMtSuN2HVUgCaVhyukshF?=
 =?us-ascii?Q?s5FH/T+O0ogmCXrVEESbW4vETJIUHdJ4G0p6ZJnEI8g/L0woexTeaeGjDWTH?=
 =?us-ascii?Q?a65yPMcGkKKOniIqbjkdtMgXJSCX/MQOD09TUIRurSW9HYsPde0IPNhEM63R?=
 =?us-ascii?Q?ZZIs9ZIwVEDgKcly7dbmpf1yHxY8sRybdT5A6IG6OndeJkz7xdny1/eVovd0?=
 =?us-ascii?Q?rY77b5I0ownwdbuOaid49QHmjSGFrh4I4rWoQ1BAmOzzG0t68lKybllDXELX?=
 =?us-ascii?Q?lUVzp+Amf46Ati8PKfN0EewquYaT4PsAg2If18KEsS7fieQqcqAF7bjYMDH9?=
 =?us-ascii?Q?9aLhpJbC4vgFGHIbkq+FdOoJWKD9jQtGYKSvveKeAkHNU3GvP+g2rWxO3qvI?=
 =?us-ascii?Q?I0YuBx0RXw71fJIAZtHB2XPn4ZypY2ZDwnLzkF5eOQMmORmpV2kP9e9H1M10?=
X-MS-Exchange-AntiSpam-MessageData-1: Et+PwBGpu37xmphJHNZ4rORSIq/A5CIwMGY=
X-Exchange-RoutingPolicyChecked:
	GpqiRS5nbpIEXiJkKX8T7nRXEXINiwfdGzEL9CwjIuWCrOjENhbnZfihJQxnQFpCWl3+THnGuvip891ZzQDzeFn5qWpWt2GL9kx+zfegqUGrGrCjt6GsJqu/FnC3yf5/58QwPy6KVjWJWEiXU/DCTsVpkJTUjqW3+GdTVd3ntk9yqTF0kYbyn0U2Dg0E+Rs+hQwsQ0fyAUePQCFp/eq8tbJUa177FUo6mi+ZMXZpYQ82KiivE2IUUY1RCrxUh7mAVvbWOzjNHSBs+UiCrlnJBUVNtpu+IQVVFa6G7rnEOh23xuzvosefMh2ZKtkvM1sdDF4cTVwFfNn+lI+Rjd7V7Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BMKiokHGvVewCwi2//LXt1sAoEPDYOgRPDF7xi572sU/4oIFUgCgDfmu4F5xbgaE/dwwOLrNIisTepE/kT3N/gxANCAcJMccUwcukGX42wjtxxgtwYo3dXrNlcCBuQkV4PGTQtDrXvdrS+P4C4h4mGMZB7JjRllDVGcA9p/ft82Gb/iRg1LFEDrI3I/RWrgZjTjOMIkFIqG/k7Yvk4peUV4NQUNeVrN/p4Zv06c8DNGndOJakt7ASDPm+R+ZXGMagfolS7JHfsUL8FHMwSoNqBBnGKK39UORkOw9rHIYp6kMNtChiBsZ92uesY28+/+3XC3TpStQo+G4+khOzDG79ocolflrz7YZDvQiuJ383kmvL4V/td6wVgBSfG+aV2wPKcZ8aq4vtFV6F67Uk5i/1Q7imjeMriMYmqJR2wP5yaSAtHB3hGZqwSxlLRonn8bks13JUY3kzhXYA+m83JHTlBvRZ2HAvdTlLtyPEDWUYIuMGjSvqOxuLVt2Vtl4cI4VC6uxsg81QZRzDb+yxqA61ASDVyJHdTo5JcGw8VnzD0PrdMMiCDk6yqF5HsFBy3g3re4VpbYhF9oWQ8depgdrjhWbKpiwO4fGeKG5+xeRkDFtPXMHw0u9RR/QFq9RQT5d
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0e2870b-7474-4de7-9e91-08df01ff7aa2
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 16:48:09.6664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gaWRWV7tQYR46BLHOCEi+p4Y5/xijM7uLbsJdnxkLE7NJeyGZ34UC/4yPo9bSNSEC1hnQOd8InSJ/PJfzW4d1BrxZqoDb3sglgZX/HxYLBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR04MB10211

btrfs_make_block_group() calls btrfs_add_new_free_space() before
assigning cache->space_info. On a zoned filesystem that ends up in
__btrfs_add_free_space_zoned(), which dereferences
block_group->space_info and thus hits a NULL pointer dereference when a
non-initial free space range is added (e.g. during relocation).

Assign cache->space_info before the btrfs_add_new_free_space() call.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 830460a40e86..ee182369254c 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3074,21 +3074,25 @@ struct btrfs_block_group *btrfs_make_block_group(struct btrfs_trans_handle *tran
 		return ERR_PTR(ret);
 	}
 
-	ret = btrfs_add_new_free_space(cache, chunk_offset, chunk_offset + size, NULL);
-	btrfs_free_excluded_extents(cache);
-	if (ret) {
-		btrfs_put_block_group(cache);
-		return ERR_PTR(ret);
-	}
-
 	/*
 	 * Ensure the corresponding space_info object is created and
 	 * assigned to our block group. We want our bg to be added to the rbtree
 	 * with its ->space_info set.
+	 *
+	 * On a zoned filesystem btrfs_add_new_free_space() ends up in
+	 * __btrfs_add_free_space_zoned(), which dereferences
+	 * block_group->space_info, so it has to be set beforehand.
 	 */
 	cache->space_info = space_info;
 	ASSERT(cache->space_info);
 
+	ret = btrfs_add_new_free_space(cache, chunk_offset, chunk_offset + size, NULL);
+	btrfs_free_excluded_extents(cache);
+	if (ret) {
+		btrfs_put_block_group(cache);
+		return ERR_PTR(ret);
+	}
+
 	ret = btrfs_add_block_group_cache(cache);
 	if (ret) {
 		btrfs_remove_free_space_cache(cache);
-- 
2.55.0

