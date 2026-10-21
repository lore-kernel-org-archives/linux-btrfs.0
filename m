Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792601212;
	b=oniZCft6upTGmDmaINFglLhyhqEcFIp5/ewR29Kw9b6GoF6CxQBCiSx64/SuSoT47qM/
	 FPaHRZLtEPViyKR3EoGQWDQ16r6tdrvaa3IvjAZFD2ivFPrm624oUgaHu4v451gyQY8UH
	 9ruN8+wZF7qG6iUJqDaUrBxfeQ1cx3CGXV0ZG2Y0e7kgV++u32IXvNv3pItxnIWP+xMkK
	 UUgqb1LoM5+ZGAUBGxoMvyuaGMW9VBQtXuWicjWXsAo4Zh1FXGudE+t68H+9qahI+fQcb
	 BS5uelr9GcZ3RbBWHFsCS1k5UmnKjUe+MSPI0MuCeCIcmfnXqah5LMGG55+Zu06dXag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601212;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=zUysM6gFKuIbt1k5IPumbDT8tIkCIKz7oRShbpjueeo=;
	b=tKYek1pAXtQnFNgdeP8zKeJVRr8bmkCc1cwkoEM04zrbutkOmESwt2E7ua4e5RXfXNjZ
	 VUwfbQTW2kETUdN7cj8+REJsWIv3EFovamt7nGtpXDZ7mBYpWfskJlmy/u/Tua6cw3R2a
	 UaxrSwYBR83DEgipIRw3NdNS2Ulc5RmJvf6lt3FbEjw9OYSuqN59RTOjpbqa94LATzAnX
	 Zrn19gG3TQOHvczDso/6hiPjlv0y770XU6bkOJPvCTxKOjtxHtC6aIgdhv7fdjMMeSKsb
	 SBTB9jEPvyL61funWr0CAcyzmOQ/56/t7e+qxEDL1ilZlrJJL99OqKysb99iMoHCPnw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=No9ZPfEQ;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=MYug+Eyx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DB9606A31E;
	Wed, 21 Oct 2026 16:46:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80DB9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=No9ZPfEQ;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=MYug+Eyx
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792601211; x=1824137211;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=dL0AK3jThxaHBuDN8M6zZgJKg/8g9Kp6Xou5j9pbFfQ=;
  b=No9ZPfEQ5Nl8f+7OurSR3OdTmUQ+/5Mu+C97mf35CY8eKQ7ZDR/WQSUF
   OU7AMW7eSrgiSnSIQywrAGQIXIqAThha4M65hht1BKSHXUBWCPKDGlVLm
   4Kmx6eDhdWP81oNVmH9xwAJAAHImKw7J/yLpwdbrEvY+eWc1iHisqkbU2
   IWyRJBCKw6aiErHWDlsv5cfRFwrXoTGw0kjDbj+FrYjPvBXr8N6WCjIvi
   1c5UyP2SAp2DUuCh7b+y5mUfiPiH6QEqGfHauax2//50hrP1jvkpzq+Kc
   yyr6ACvrfvUlXOeL80MP4xF0Ho5hGSbozmUE+b7N8fiLu/hdbLmJayJUY
   w==;
X-CSE-ConnectionGUID: SU9Bq0iCRmGjokp8/+GQwg==
X-CSE-MsgGUID: Qut9VqZoRoqk489f8A9/gQ==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="159615069"
Received: from mail-westcentralusazon11010016.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Oct 2026 00:46:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c0KLW/17XVZ+WDBDAQYbBu21mxqkdo/mwOqdYr8E8PD2+0npG/bV0rnKgAhO1mQM6uMivZuIY+qd82dNVU4c63U/fLJk9EJy58EswnO0L8eZlxtsv8DZftMaDO1FwNdG9EDohziFqUnlunbIv7uJI8CJFSgYTZZkTseeSyK5K18sPtWk+Z41hQd+F4y/JbZRJk97vpshDvTZx3hD2BcEve24dl7zeQBiMwZAD/Cx9vF+e7Ioo42g8OKITA1IUfVMsM4BBr/nV3+yVy5Ypr7M1ymFfWrWwDbCj6DDA5TkD7Bs3qP2ChPCj9spUfPqbBgicJoFwTmeCxMv1fegZaB0KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUysM6gFKuIbt1k5IPumbDT8tIkCIKz7oRShbpjueeo=;
 b=BlzQGMhw+MLeFS0T6YVBMTf78GDgo7uRnnS3MiOxlkH9T7IapfLQWyi3B/77I72i3L1cYJ0z6FYDsDN5clNGiFnrLa4ReXNl2CnDgrYjFV8OUG7Bx5za9YSNlIdJ30wkfo0gRTPai8O6u5jfPBkEkNOAOuUcohmMKb0gk7mg3CPdFbVhG4au1GTLB21ZalZA0WQWShkDb/HF1CpsPICNmvJh5CZBKxxzUAxeCGfiQlQg1ZJwxeg0180dA9W31BXZQ1ASB4Q+tmQeKvSHNviXn1tEyTy07Vjszd3jMhJhHAMLp4LhTjCgqh75V7T3y5XVhBbjK7Z34xJe9I+XxOVYiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUysM6gFKuIbt1k5IPumbDT8tIkCIKz7oRShbpjueeo=;
 b=MYug+Eyx8b/i1WTo9JURGagrNniEReoYWFU+0GKs1w1IthSxge/fbZK1R/hLCRBXd7yzj1/m/PI7jZ1J/lAsdeQUUEo13EmkyBiwfzUYSLz0COVs4pPdotQM1NHsul/8ydx9v3cSDN0G9GoWB2ldUBe059WgilabwyKWtjSUcN0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB870614.namprd04.prod.outlook.com (2603:10b6:5:2f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 16:46:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 16:46:47 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Zorro Lang <zlang@redhat.com>,
	fstests@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: test that fsynced data on a RAID stripe tree survives a power failure
Date: Wed, 21 Oct 2026 18:46:37 +0200
Message-ID: <20261021164637.2439627-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::20) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM8PR04MB870614:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d21c3aa-4c12-46d1-2a85-08df2f92e5b2
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|10070799003|366016|1800799024|376014|6133799003|18002099003|10067099003|261021121427099002|3023799007|5023799004|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	BgD5NZKzJfK4x35mcGz7IR3AHPx6khwagaQyFPyXcCHOHxG2P5BuoRbUgXz3eu1HXtOuqj0x9cpARA3HswGEpmgO1+BSjvJL+ZLMjwq+1i8v8W9jJ3bUCuxmSjPt2tu4ZR6zy4cI6nF7yJQdrdlCsSFjtfVdcEVwyNSkDYLytFxlSsY3FYs9NITUA+tbCHO4bKqWj7buowye5EWMhuvzWyYTcq1Va1TvrQARn39aCHCfcNImPtFlMLLpucy7GAXTXFna287dwqlUsJ9lrzKF9WU4U8JL9/oHBjESR/cBM50tAnpCyx/+a2rrZSkjilgp7TwO4ohpS2IbBvi34oZJZWQvvwfvQOclvYj1+Kyy/g68QxtkqV0GVSDcQsr7zoTeYK4jF5PxFr6NWdY2aGu3mIKT06m9e2Qy/LjRMp3w151mwvK4xeOUqx40yAUVWhdbUF4kTdmAJsBYQ7qgccPmFtH9J7eOm3cTFdx9u43vGmM2KAQpyy2sIa/nMoGEIKhYHz+6tXMRLU6sjykrPtLsfrqexJ6rXZUpS4Uajwo15ZJoxDkIP0VzDC7ANLqacpyZl/nsGtrLzME+WugkjJ/3ar7owOzglr8bWPPxgMX0aL0Gb0Wtm82bE/w5YAH6AClWLm9s5doBBjquwE2hgXaQr9LZbd+/lMh6plv3fYH0O2g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(366016)(1800799024)(376014)(6133799003)(18002099003)(10067099003)(261021121427099002)(3023799007)(5023799004)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VAC0SgvYC8TbwcXQ6RSgi1gBeDSHp46CK5atZIjwywfZ86taLdnud4yRQ2WH?=
 =?us-ascii?Q?2clXeBWB9NYJ2IqNCxCqz1l381/w2sVoV0B+ehirg3ml695eM32H4dFpnJFT?=
 =?us-ascii?Q?loVKY/ofUH0CTq+0zI/LaRIkCiUHbfKpXKfARJFRP1BNB1FFJf+VZI8C4BiJ?=
 =?us-ascii?Q?eZ8JM0PDcyO7z0UAEM1lkjCTqNaIemq1FtUXrOteFhKQD2PHFVdh+niQggQV?=
 =?us-ascii?Q?0t+CmZJfwbBKXeSeNGJPpLRXyciJhQHRauVKeax6QK8ASsKiQgwCslWweVkE?=
 =?us-ascii?Q?YXCN5JJwNaRjbn/hplucDBJM+lgOYsV9uoF96dBbQ5JZj5LnWHgH6Nqi7a7M?=
 =?us-ascii?Q?zbyuUZKAR5uXHLN/8G0RwIg9YAQL5Erg9wsyyDYx3ibSAYisYGLsE3diJTXX?=
 =?us-ascii?Q?VYllFonl5lgmeIB7HZB7tF70x733bh8KKmI8bGhmqD5KMhGT4dsoq829eMb1?=
 =?us-ascii?Q?uOuXIpv0zQ8JLtIV061X4Hof1k08NGSvKmMbQnpbCyWwKSkvxc942xvAMFLc?=
 =?us-ascii?Q?4oVgk+3IDrcfO6WD26Yz5JNSRzG8dcgJzUvXWjMxEL1gCxtw39JkKQFJkEW0?=
 =?us-ascii?Q?XWlFYYUzUDXichG6HBL2lEe6p90xG5O2bVaSurHCuhlerETUX3fZ07Zb1yJm?=
 =?us-ascii?Q?h97PDY2KwHgXxHsR82SBr/Ukt4N5eZDvd4Z9Ix4jwFc4WnKXXTqZar+yBvOe?=
 =?us-ascii?Q?cAqun+tG41KdgcYfql7m1tyiqc6711UX+w2PZ94wG8T/ixh0JSpNd/GibR0Z?=
 =?us-ascii?Q?oyrxzgl4ezb1BWFIluE4xS7h86BR8F3x1/3it7dfroGKl/G5/RHrZdeF7XPA?=
 =?us-ascii?Q?4x4ZlUPpgaPozCFvLD3R+oQllVR4D9pNkEDi1WZV+wb8KYrEXyhSSyRlj/Me?=
 =?us-ascii?Q?0gIW9CzodXypPVbQRz1g9UW+LPSRS5PH0sKmIj4WglKE60/J7n1WfO98kJGc?=
 =?us-ascii?Q?0D49utCPaluYutvxxNl729tueVkPJWOcLt8q6AlD8ol8cZvvp1vUmHkk4lO3?=
 =?us-ascii?Q?7Eh8o1lA1kkHNU51nrHJcfjGpTT67EO/75vmbepIT+yhN5JEhCRcV7kHf6pS?=
 =?us-ascii?Q?4OT1DDallLuF95o3LZENTU4+QFpvJs1vjOxp0KkNLdmJ90b71eXW0kCz3mk1?=
 =?us-ascii?Q?daF6N/81BQAsQzpp/OGUvrUpSTrddhncDIgS070XK7Sp1kghAOBVwHiCpL2c?=
 =?us-ascii?Q?ilC1qd3OBTnqBojY1UlxC6qkETkaL/kijuGTqFFFclISlmgpxGRdQIFFNDA+?=
 =?us-ascii?Q?sNXKwRzgoOaSlq4G75c5GZC9oOpIKqobB09ZkSCs53rmHf/xe9aRit0e2nAk?=
 =?us-ascii?Q?cDGiiqK6YqN27oH6+6LEqyeoyWVRWR2PobuMi8nzPLe2vBtFA9mm3g53UKRT?=
 =?us-ascii?Q?3Xt2uJFaqIcZgMLyCAkjio82BsHukr1BNEmUdZcaJ7EeVlyqJXs0vHoKGqEb?=
 =?us-ascii?Q?SPVw2Bz44oeu/CntNLZsTw0u1lXYBg1Kq/YzKVOUMuw+QMv9hqdTi4aYOw79?=
 =?us-ascii?Q?dRlaO1qYmmSFK/oD/eAOJTK41P4I3edw8cFd112Np0jU74YzB8RCK9mDJuk1?=
 =?us-ascii?Q?hU258SCJN9uMvMsWiYKq61fm/jFnIoBNpOAE/xXDCzHkhyTPUuxA0LFEtbaJ?=
 =?us-ascii?Q?kcpF/gpaUSFDfyduF+c6Rg0bd6MlGFaqtd+F0+k+gwAtFktECq6KwfXx/520?=
 =?us-ascii?Q?JjEeGcXa45O8YLKuvUutbz6Lbvwt16lx7ORFb/CyPyB2xMDtXK3rAzpBuJ1z?=
 =?us-ascii?Q?tfBPyh3tCQhO0vgV5mjDNU1iIiZ5RaSFHhRdKHVDOLAH9YJs5XBCHeIoVZuP?=
X-MS-Exchange-AntiSpam-MessageData-1: XTXPs6EAE7OmuuNfrI/EYLOL0RuYlUvIFGI=
X-Exchange-RoutingPolicyChecked:
	Lym5wxe3pk9NpeqQyYFS+XhfYxpPIGeZ9PBkQQmmAEwXv7cxg1D/2yZX99dBGd2KeXfmkOZUZ8lhTOK0dYOmmZi/dTUGLV7pXdH9mEUd1tVCJ+h5d2Smb3TTaEdby8e0vkVypw8nYLDN1HwPv0NohYFwk5Ypwq1qp1sou3b5JJCLGub0N54qCtWQZTQx8yZcw2/L8JTYyMuAIeQJ/mmhbHtNH1oJmRixZBofSHlR0DcJLkY4kBGmdI69d/xWdj4KQLekhDFQZW8OHgckF+l5woTzjBeF8VKj6MaSAf03fi0Qtx72s+1Y01CMpUF+l4pC4qnDRiEP+PiZmPhyCXWtDQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NzvHaXgmxTt7Al5hKjSTrYyjI59tG398A8OI3af4tmFx2BmQllreQrvZZxvv5TnwLmGR25sL1GRVHaNosRtTLGYpOryK+p+jNG+Mjkzwo6I/ZHpCW3sEfUedpeXGgKQYHnZ3QFe3ox2neBmOG0wPv/wiNnga1roq+h8goFE4uOfiWNmBnB7+Wv7EjSLZbTHSySjaJMDL8+9OuzXQX4IPPRA86w9PQSKuiHVxsfDdqY9GK3dj7FUvCAlmhfernfZwJX8SyuWA8tZUHCmMIi3yRmP4vyYRXbeaEMtXKsHRpEv1WLK3CmGxRjM84FR4CMnTeBERUIaGU0GRMUEKgbyoMAidJspC2NFlMsmowj1rqoJLdqbluKh+rUFLL+QT/RBuiq0t+8EkpHDWJaTZWh18M+4+lbNlnJXnTPy8yQIRilsKXQXdtSs64mZkSyLR1VbQCN41QWKrgVkM3FOqUZMcqg4fqT7RdguUvjHjmi81JFDNMXynYc7fUOQgDrbxLhHVmkQaElP/ZyGOs/ZmySWl+tS7S4m14kMLKoMOo49f5fIX3Pn6Jmhq3Hkale40eT1TeCXITeO7kLmfBsMlQPhoQ6e1u/EqVdtWthJgpv95xPcB66fhFeprBIUmzikm1U+g
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d21c3aa-4c12-46d1-2a85-08df2f92e5b2
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 16:46:47.6455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: peyMdojcNlEHrFp4ApGlevHNiYc4xhJUHVAhzuqXJcPR21t9tN18JHxkpL+mU5TdKDbA+km9FH1Kf6mwiGf4rXwgNeMrarX1pITvs3rwzt0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB870614

A data extent in a block-group that uses the RAID stripe tree has its logical
to physical mapping stored in that tree, which only becomes durable when the
stripe tree is written out at transaction commit. The log tree cannot carry
that mapping, so a fast fsync logged a file-extent item whose logical range
could not be resolved afterwards. Log replay restored the file with the
correct size, but reading it failed with EIO.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/btrfs/363     | 56 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/363.out |  8 +++++++
 2 files changed, 64 insertions(+)
 create mode 100755 tests/btrfs/363
 create mode 100644 tests/btrfs/363.out

diff --git a/tests/btrfs/363 b/tests/btrfs/363
new file mode 100755
index 00000000..68723f28
--- /dev/null
+++ b/tests/btrfs/363
@@ -0,0 +1,56 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
+#
+# FS QA Test 363
+#
+# Test that data fsynced on a RAID stripe tree file system is still readable
+# after a power failure.
+#
+. ./common/preamble
+_begin_fstest auto quick log volume raid-stripe-tree
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"btrfs: force a transaction commit when fsyncing stripe tree extents"
+
+_cleanup()
+{
+	_cleanup_flakey
+	rm -fr $tmp
+}
+
+. ./common/filter
+. ./common/dmflakey
+
+_require_btrfs_mkfs_feature "raid-stripe-tree"
+_require_btrfs_fs_feature "raid_stripe_tree"
+_require_scratch
+_require_dm_target flakey
+_require_btrfs_no_compress
+
+# DUP is one of the profiles that keeps its mapping in the stripe tree, so a
+# single device is enough and dm-flakey can be layered on top of it.
+_scratch_mkfs -d dup -m dup -O raid-stripe-tree >> $seqres.full 2>&1 || \
+	_fail "mkfs failed"
+
+_init_flakey
+_scratch_mount
+
+# Get the file committed first, so that the overwrite below takes the fast
+# fsync path through the log tree rather than committing the transaction.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 128K" -c fsync $SCRATCH_MNT/foo | \
+	_filter_xfs_io
+_scratch_sync
+
+# Overwrite it and fsync only. Nothing will commit the stripe tree after this.
+$XFS_IO_PROG -c "pwrite -S 0xbb 0 128K" -c fsync $SCRATCH_MNT/foo | \
+	_filter_xfs_io
+
+_flakey_drop_and_remount
+_hexdump $SCRATCH_MNT/foo
+
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/363.out b/tests/btrfs/363.out
new file mode 100644
index 00000000..02adaec5
--- /dev/null
+++ b/tests/btrfs/363.out
@@ -0,0 +1,8 @@
+QA output created by 363
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+000000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  >................<
+*
+020000
-- 
2.56.0

