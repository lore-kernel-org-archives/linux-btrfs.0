Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3232C39B49E
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876630; cv=fail; b=F1dPhv+92+XYj3Msdm3B5Tw5xSu7lAq4b0CiAFUrxHV101b4UEItwJvsFnarAxU6B0OYk4I/8AsDGndeT1XboX8JvMy7A/HpUHDrWZQJDZnM5FUVic36z2W05SQ1/8S11c4tKyqU7CT8aAXFRqUCQ5V5c7G6pMW815xFulKBhx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876630; c=relaxed/simple;
	bh=mb+iRkvBNQ4Rs48oUiV4d1NAI5VGTq6lT3IOBTlUbG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JBY6r5mIp2EQ5D6cxMM1zsUwS4vgH/vGkBjIAfIHIOmOQ45Yv9bsWpU7j7+kaW/mvhtzAgpgcO4HpvaWZ8MnVT7Y6PppoqPAyXorXRXxVEnj78ynRxxyOZvB69N+8Wu8lykaBalF+XIyrSbH1/G3Q+YmNJctn1g2NR9sgaK5xAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kY1JDkRR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vgYKNXz2; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kY1JDkRR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vgYKNXz2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876633; x=1823412633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=mb+iRkvBNQ4Rs48oUiV4d1NAI5VGTq6lT3IOBTlUbG4=;
  b=kY1JDkRR03vCxXnmApTASttSfuZ/P80h1wzWi49o6coMCtcDYNB4LcHh
   MMLhx2vVDFB02cFekLtDIjaU1H1sMz+bE2O0ZPRpef0oCrIRoO9LSbBzJ
   GtqXvl5bdXGkCnjtVLRGwLYc7tSpLapYii/BJrau1EexLYJLzyq2hmbJM
   63qkg8/lvxzVHsbSC6sQLjFRnCNraGU2XNthHDQMs/7SXibZmcoTUx+AP
   Vs00H7xoQRd8kQKrC7KFbxeMMsc1mqlp57CmHoYTthj7WleZgLrbQm3Sv
   s16NBJc1INFNDHNY3psZkYZfxLlWrFpb93RBmjnEqG8TGuLXZmQGSF7W9
   w==;
X-CSE-ConnectionGUID: LAza6IFZSU2XVWxlMpkKfw==
X-CSE-MsgGUID: DhMjtp3oTIqD6q6U34Ps4w==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="158917175"
Received: from mail-westcentralusazon11013009.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.9])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ObqRa76td6hecNQ/4CV2Ru4i1l4/bHaMkGT9aFo9vWF55uWwrE0P58pDYGXmFAk0DgkKjWSu8ZmC5Wp6hZNt17zewiDvN1dc2TzGhyyGIEY6+Ed5aCt7FX+LUok8tnWd0zZuMjAo4WSxs6xkUAaEaRm3NbDngVWqxrsDdvaVoXk1iIcYJy2gd/5RiriAKDh3h+Y0dP7jw7Ow/ehkCxZNjvRC40H1ybaEHLQQDoZCAE2byUBNyZnCEmPCa2wQCrlHCtTEMzgus2cXroYBtfEU70lMsq8tQM9j2bLGW5zCzoA61AvywTl9trBZJvB8HPmOk2KKaEYslvjDaPAv7Df4HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z9uDSeBVNbEj+yGYxI0kp1c8aO2EqCWXmr/Mv9kTH/c=;
 b=KRDLnuId47ZYME3DzLl7yOIgSaKmFmQcCBsb4AKw9UayCaVZmlc5KBEh5BET+nx9bNxN6T5KLVqixW5G7ciHscy6CydRq6s82KaJKnbm44mnEYqDWWkY9HkG2K7/RGbSWFCllysEwyZvPmlBRJLJ2rjPZzkrfaSIL2GebG3nV/c/AFNtbxC2+6GCsjOWNTL2Uqx30mLOQGHj9WHZebfu8Fvlk5VAGyltgtpyGGzhHHZyOixWaAy0kaNXnJeE0XCwWk1VObLkqAqKFtIbIc2aC0Kcew7TqMU6JPGnAUyc/p2uk3kUs5ByszKy2R50M0vPA+AuJjUIl+G7NylbgrQSSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9uDSeBVNbEj+yGYxI0kp1c8aO2EqCWXmr/Mv9kTH/c=;
 b=vgYKNXz265dPbynkaFtFkhrFRHuplKI6XDWpKWvLEb2m2QKBXwx/vY6H1ZEajRbj/hRvJelwLvtFI5es7V6mP5YkYNg5lRnNy4A3j9xFwiYb6LFjKkKoHoHdrBJRH+BVIQFH73OzIzzfXpqtWCv7jp+B0Ktniq5RQOLcsutMZZg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:21 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:21 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 05/12] btrfs: zoned: use the regular allocator for conventional metadata block groups
Date: Tue, 13 Oct 2026 09:29:34 +0200
Message-ID: <20261013072941.424029-6-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 946a9599-1cf5-498e-6753-08df28fbd6cd
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|11063799006|261009223027099003|18002099003|22082099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 72Cx9kyjdvLvQv6xKtDU6xfAxXpV9qEdb8Q761E1PBPwvzDdY3ZcBEs5FMRVmEJQtw3e9lwJgJwEHT62/pMp72U9dBos7VYjowbpq5B4CcWRQHzQBtYB7GV77z6lP5sNZKPJ8pQbzvtS93Eg7rRvdNLZDmQSuRT2DamPgwszpj7LsRerV/3L3AI72/zhvyn9R9ltdWdgKVlK/kQ36rfmShx3WCpiEumTcyvNCS14EJjKeNGjiLudTo12kyQrN1dF6nTnEfCWkDJyv6J56sP3UFUvYPgoAH3qi2vYorwcWSJF5U9jE726hBkEQjj0GvMQHZeYIZrTsFYtTAIMmOMAIqWZ7dWMLUYCzkKsf+dbBE6le4fWRXfdY1DRfzPW/5/b682jZz87F/jrj0LoYDguRpP+dVEKbCMPbblW9a5Kcrm0BrWPT4vfZrP4cRg3uOwV8XTTnnN7LD65YPgJTHtZ9AQIzFCqZDjlue9Pq6qx7307b92chrEH9Io2Rgjmv1HOsjiDQRbLTrpbSM2fmxCEw1SI4JBGEIMPN8SDM0GvCMGqdwAnWRDxeSetZ/HszpRQCTqir0r3ZH0ooPmW7chafxu/AsKmVOgvJJ+oqpwoHuWpdiKRg6GKehw8c1kkD3iNDVMrY+GT8uypDRtEWYCLiUX6cVPwi20M2Hp1eCFB8Vw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?pNYuZgb7NbfI4aB1A+VImbTjIZpY6eMhyEV6ugvb2CA4fsHrux1JdCIKhMyL?=
 =?us-ascii?Q?jRRyD2DVuGxdR/+TwROYoGLeVW5kmCGjf/fZV2EFO9v5TcBM4Cyi4i4He2M8?=
 =?us-ascii?Q?MQvdJWlalcstR0p9NGShNjWz3XraPJP+wvUiCo8dj9kZ6eWg1V4VsQ9c8fL7?=
 =?us-ascii?Q?o46f4XQyB13rPG1iLQB9/y7T5kQYiScNLzN9lOq1aeZqrR3QUNNvOi34x+fy?=
 =?us-ascii?Q?f85Xjg2ksv6U1e+9TY9KgfhI0eS5kPg4zzmI744ilSpK4b7lAqZlw3RXHUp2?=
 =?us-ascii?Q?FQbCOPOJ4m28XCvl58RAPc9jYe8tKkGMB2mCLqPKSlIMGBh7kp9MVFjEpPY9?=
 =?us-ascii?Q?UI7VKukyrRPJfXTCFAYxfytAFtFU8INwX9nIoj0kTvwWTZ1Pou5nyHIfn4uR?=
 =?us-ascii?Q?iFjvAkYJgGLmCqGmiDWnfS/PAtybPh2yeg0Zr5FvihOu05cgXbYQMY3Df3K4?=
 =?us-ascii?Q?zG9PztXcW2a+YAod/jL4xAwTuJ1JA1GRTxPj4pKH6oR4qbUJD7nOe4UOX2H8?=
 =?us-ascii?Q?D34XYcOYQCeu1Lxn0TBGrNs/qlNs0JroSllcqDTM9ZueXWDlTv6HbqeDs/+o?=
 =?us-ascii?Q?Zy3eZ31ht7jvW765X99qYviOxzul4ogMN+HHcT+R0tBBjFrIm3d+Eo2kbt0N?=
 =?us-ascii?Q?2pIkICwbCCd/3H5rZHsqJdoY4iOV6simWDuMaL7dexvlroUqTrhzXpkKf69J?=
 =?us-ascii?Q?cW3w0AIGwUEoQ4X0ef8o/tC+6ByqMTk3DAPgFG8V3wk+thJ+uNtaDmCtVCAI?=
 =?us-ascii?Q?luEs/mmh10W/XXGvIqpG7U3EJUh9Q4zLoN4H1qbAv7Yioi2mtcMTbTb7p893?=
 =?us-ascii?Q?xvLYH38rkS+NcoIwRzlN/EMoJ4CI6QstCDgPHG/sCL4mPB7uFkQz+3MVW58p?=
 =?us-ascii?Q?qlDkaSaFqEixq8+8R1PWsGmWMCyERvgOOPJKHnxzai++S//8YZZWHiQ1J5/e?=
 =?us-ascii?Q?FZuZATkBJWYAYISX3UjYROqepjaTmQPgli5/t6TI2fduv3qVYMsmDsFcnuFz?=
 =?us-ascii?Q?YQRlQbCTcpmuSrbCVmfnoV/nFP57e76dooxaLo9+7l4AA21S2brcMKtkWhw+?=
 =?us-ascii?Q?F99bfwgOJmJsUKQGPx7oeguOyNjHU8ideRATlZUCbqT9i1aO8k5YN2XqsEoQ?=
 =?us-ascii?Q?xFyhhFzzgITDJXtXuabaqIqpiwRMZ0fI2Spj7agiWjvS/eOdme6nBBRs48mg?=
 =?us-ascii?Q?krrimxDnJyjo34tZ7lns2g7yUIj1g8mba/f528fnz4qdPnAIdKopSxH5onPU?=
 =?us-ascii?Q?S9sEkS+eFbqDhDkyhLiepEm4MQ5wnSMUUA1rN5DIA9zrYJFqybdc5Vb58UPF?=
 =?us-ascii?Q?FpwaeHmCRvEbD5iPZV7NckxGZew1onyKyfiV3eS/S74XSHjbLuWJYi7jTNuz?=
 =?us-ascii?Q?zGmTd4XSh/42mydFvmzU3wubKxXUZWXV7fjbK8R+30sHVDBCevpAeHsKb9Lv?=
 =?us-ascii?Q?dRUW24IjFdRC49HTBs6HLYuICZgLPX9kwhafY9WzYSRbu9FVyyF8O3lWQTTP?=
 =?us-ascii?Q?wjeuHOJA43WcJFiErHdKkl8buT029mFxdnUIm+/VLct0ykScESO+MRvYSFcX?=
 =?us-ascii?Q?FE+qskoymbkebEr9Ak+4WwJHNrljIivXDCQM2/ep5YsMEDc9ctS14UuiW1HV?=
 =?us-ascii?Q?+lXNKgy5p0itm1FIXC28UGztN7UQN4mD/2kFsZTuhUurzJkF4NG1FiuJ42jO?=
 =?us-ascii?Q?krx0ngUjgg3qquQ32qMK07b2itl2p/US28nKuk0ZnQl+D0xe4htK6Z88mVIa?=
 =?us-ascii?Q?juXlAhWZnyXUmYCIEUxHKQlP4PUQpTGlGic3Gk9/NqZVnRPO2iorhxEDJF0E?=
X-MS-Exchange-AntiSpam-MessageData-1: DMi70kTXCrsulEodQZMfqvIW0Oq3o/blooQ=
X-Exchange-RoutingPolicyChecked:
	YCcLRh1e/6CdhEnfxlyNHq9bTXYHLn348V+H7ZpIWWhlAjceF0tgek8KBAN9H9iadI00j81Gfr6NFAYr24gj18Cvbl0qLZRvl9sPLwB+3E0l43d58spJH8ftVAdzz32egPEOXGzsFABte4EkUUpMALySTbrl/+czcnc4U/aAESSRkFxWJ9e7//VAMKXlOc7dT/eflGGni5brjuxdtZIBIVIolnXkE1vxnIWqDz0a//IjKIZSEOEmuVahnvs8H3iuYJcQ0nNa7JzQI237D8fYDevYqJYC7bQjZ/ec4z9bu15EPpGDIJpa9PR7ugQ7EViRd6c0cLc5Damfo78ipL1kPA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H3T+v7ehoYRXlKu1a54/5/zyUoJ9SjQG62TlM/Hk2p+j+xJoVdH3EcCjBQv8fIM+oz4/AQ6ASRE2f3/FeKhFXx33R2/jF8Xts4mw34LlbWQSmkTQl4nJBPZ/cS62pQtTGWf638CF+3m6yRzIGEi1fBQNkYlsKJASf51KVT6QKvUDPujhxv3lVSnb6mKJYCEp2ZMhB+BBTnbLQVFgz/vYJ7/GHPBkTm4+/j57oAB7YcMLBGN5msjIW4Y/UHNa/4iwzsdHe2yHUiNJZqFy9S5n2Y4cQPxsGsuqqje8hYErYt7acCNfwsih34P115Jh7Oia7RCAQA53/xSBwLuFsiecBNKGmCYpMzt9Y6OEyO56U7EF761lB3Qdnfd6I+HTiA/OwEPm5WdefHajZwtVQ5n40GIY7l5CZNUPZqB4r5Hgrf+tsNJBua+t7UpMIbeG4psU+4ufSK84kD7UG82tePQCX+j6KTeB96d44bailvq3USOhdFjxHJs8WBqLthE352jKGvqMqzBqp+M8En56H2Fafcm4R+jkYnu7xruobnL9VbxiWUwG/o+lwaNZN/90p74p6DkRgi64T7pMZlcoJn3bS6EyNWm1C74CAcbDWA1JKDpouUHIOehkO5X8f6C7ugnP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 946a9599-1cf5-498e-6753-08df28fbd6cd
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:21.7584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zL0TNBWyEzoioXhMmaYIjf/p3CZuXWywgsFgmU0XDUhVKEJNy5WLGFccKb9/ryzQDDKhENVesBVqagxmJXOKZ7oyERSn1/QnZgbSIU9IQ+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

The zoned allocator hands out space strictly sequentially from
block_group::alloc_offset and accounts everything freed below it as
zone_unusable, so freed tree blocks can only be reclaimed by relocating
the whole block group.

A metadata or system block group backed by conventional zones only can
be overwritten in place, so it can use the regular free space cache and
the free space cache based (unclustered) allocator instead, and freed
tree blocks become immediately reusable.

Pick the allocation scheme per block group rather than per filesystem:
replace the filesystem wide btrfs_is_zoned() tests in the free space
tracking, the space accounting and the extent allocator with
btrfs_zoned_bg_is_append_only().

Such block groups no longer need an allocation pointer either, so skip
calculate_alloc_pointer() for them when loading the zone info. As a
consequence they are no longer marked active and put on
fs_info::zone_active_bgs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c      | 16 ++++++++--------
 fs/btrfs/extent-tree.c      | 29 +++++++++++++++++++++++------
 fs/btrfs/free-space-cache.c | 23 ++++++++++++-----------
 fs/btrfs/zoned.c            |  6 ++++++
 4 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index bd17880039d3..34ce3bac45a3 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -969,8 +969,8 @@ int btrfs_cache_block_group(struct btrfs_block_group *cache, bool wait)
 	struct btrfs_caching_control *caching_ctl = NULL;
 	int ret = 0;
 
-	/* Allocator for zoned filesystems does not use the cache at all */
-	if (btrfs_is_zoned(fs_info))
+	/* The append only allocator does not use the cache at all */
+	if (btrfs_zoned_bg_is_append_only(cache))
 		return 0;
 
 	/*
@@ -1484,7 +1484,7 @@ static int inc_block_group_ro(struct btrfs_block_group *cache, bool force)
 
 	if (!ret) {
 		sinfo->bytes_readonly += num_bytes;
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes to readonly */
 			sinfo->bytes_readonly += cache->zone_unusable;
 			btrfs_space_info_update_bytes_zone_unusable(sinfo, -cache->zone_unusable);
@@ -2597,8 +2597,8 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	}
 
 	/*
-	 * For zoned filesystem, space after the allocation offset is the only
-	 * free space for a block group. So, we don't need any caching work.
+	 * For an append only block group, space after the allocation offset is
+	 * the only free space. So, we don't need any caching work.
 	 * btrfs_calc_zone_unusable() will set the amount of free space and
 	 * zone_unusable space.
 	 *
@@ -2608,7 +2608,7 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	 * in and be done with it.  This saves us _a_lot_ of time, particularly
 	 * in the full case.
 	 */
-	if (btrfs_is_zoned(info)) {
+	if (btrfs_zoned_bg_is_append_only(cache)) {
 		btrfs_calc_zone_unusable(cache);
 		/* Should not have any excluded extents. Just in case, though. */
 		btrfs_free_excluded_extents(cache);
@@ -3299,7 +3299,7 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group *cache)
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
 	if (!--cache->ro) {
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes back */
 			cache->zone_unusable =
 				(cache->alloc_offset - cache->used - cache->pinned -
@@ -4113,7 +4113,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 
 	if (bg_ro)
 		space_info->bytes_readonly += num_bytes;
-	else if (btrfs_is_zoned(cache->fs_info))
+	else if (btrfs_zoned_bg_is_append_only(cache))
 		space_info->bytes_zone_unusable += num_bytes;
 
 	space_info->bytes_reserved -= num_bytes;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a0d5ab03aae2..035977e4df92 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2896,7 +2896,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 
 		if (readonly) {
 			space_info->bytes_readonly += len;
-		} else if (btrfs_is_zoned(fs_info)) {
+		} else if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Need reset before reusing in a zoned block group */
 			btrfs_space_info_update_bytes_zone_unusable(space_info, len);
 		} else if (return_free_space) {
@@ -3689,8 +3689,8 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	 * contend with.
 	 */
 
-	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags)
-		     || btrfs_is_zoned(fs_info)) {
+	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags) ||
+	    btrfs_zoned_bg_is_append_only(bg)) {
 		pin_down_extent(trans, bg, buf->start, buf->len, true);
 		btrfs_put_block_group(bg);
 		return 0;
@@ -4041,7 +4041,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	int ret = 0;
 	bool skip = false;
 
-	ASSERT(btrfs_is_zoned(block_group->fs_info));
+	ASSERT(btrfs_zoned_bg_is_append_only(block_group));
 
 	/*
 	 * Do not allow non-tree-log blocks in the dedicated tree-log block
@@ -4195,11 +4195,28 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	return ret;
 }
 
+/*
+ * On a zoned filesystem ffe_ctl->policy is BTRFS_EXTENT_ALLOC_ZONED, but block
+ * groups that are not append only are allocated from with the regular free
+ * space cache. As prepare_allocation_zoned() does not set up a cluster, this
+ * always ends up in find_free_extent_unclustered().
+ */
+static enum btrfs_extent_allocation_policy
+bg_alloc_policy(const struct find_free_extent_ctl *ffe_ctl,
+		const struct btrfs_block_group *block_group)
+{
+	if (ffe_ctl->policy == BTRFS_EXTENT_ALLOC_ZONED &&
+	    !btrfs_zoned_bg_is_append_only(block_group))
+		return BTRFS_EXTENT_ALLOC_CLUSTERED;
+
+	return ffe_ctl->policy;
+}
+
 static int do_allocation(struct btrfs_block_group *block_group,
 			 struct find_free_extent_ctl *ffe_ctl,
 			 struct btrfs_block_group **bg_ret)
 {
-	switch (ffe_ctl->policy) {
+	switch (bg_alloc_policy(ffe_ctl, block_group)) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		return do_allocation_clustered(block_group, ffe_ctl, bg_ret);
 	case BTRFS_EXTENT_ALLOC_ZONED:
@@ -4213,7 +4230,7 @@ static void release_block_group(struct btrfs_block_group *block_group,
 				struct find_free_extent_ctl *ffe_ctl,
 				bool delalloc)
 {
-	switch (ffe_ctl->policy) {
+	switch (bg_alloc_policy(ffe_ctl, block_group)) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		ffe_ctl->retry_uncached = false;
 		break;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e2af75a205ea..cae4f4f38ae4 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -28,6 +28,7 @@
 #include "accessors.h"
 #include "file-item.h"
 #include "file.h"
+#include "zoned.h"
 #include "super.h"
 #include "relocation.h"
 
@@ -2627,7 +2628,7 @@ static int __btrfs_add_free_space(struct btrfs_block_group *block_group,
 	int ret = 0;
 	u64 filter_bytes = bytes;
 
-	ASSERT(!btrfs_is_zoned(fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	info = kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
 	if (!info)
@@ -2756,7 +2757,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
 	if (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)
 		return 0;
 
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    true);
 
@@ -2769,7 +2770,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
 int btrfs_add_free_space_unused(struct btrfs_block_group *block_group,
 				u64 bytenr, u64 size)
 {
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    false);
 
@@ -2786,7 +2787,7 @@ int btrfs_add_free_space_async_trimmed(struct btrfs_block_group *block_group,
 {
 	enum btrfs_trim_state trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    true);
 
@@ -2805,7 +2806,7 @@ int btrfs_remove_free_space(struct btrfs_block_group *block_group,
 	int ret;
 	bool re_search = false;
 
-	if (btrfs_is_zoned(block_group->fs_info)) {
+	if (btrfs_zoned_bg_is_append_only(block_group)) {
 		/*
 		 * This can happen with conventional zones when replaying log.
 		 * Since the allocation info of tree-log nodes are not recorded
@@ -2920,10 +2921,10 @@ void btrfs_dump_free_space(struct btrfs_block_group *block_group,
 	int count = 0;
 
 	/*
-	 * Zoned btrfs does not use free space tree and cluster. Just print
-	 * out the free space after the allocation offset.
+	 * Append only block groups do not use free space tree and cluster.
+	 * Just print out the free space after the allocation offset.
 	 */
-	if (btrfs_is_zoned(fs_info)) {
+	if (btrfs_zoned_bg_is_append_only(block_group)) {
 		btrfs_info(fs_info, "free space %llu active %d",
 			   block_group->zone_capacity - block_group->alloc_offset,
 			   test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
@@ -3097,7 +3098,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group *block_group,
 	enum btrfs_trim_state align_gap_trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 	bool use_bytes_index = (offset == block_group->start);
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	spin_lock(&ctl->tree_lock);
 	entry = find_free_space(ctl, &offset, &bytes_search,
@@ -3230,7 +3231,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 	struct rb_node *node;
 	u64 ret = 0;
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	spin_lock(&cluster->lock);
 	if (bytes > cluster->max_size)
@@ -4075,7 +4076,7 @@ int btrfs_trim_block_group(struct btrfs_block_group *block_group,
 	int ret;
 	u64 rem = 0;
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	*trimmed = 0;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 76633d88cb48..da6d97d96c2d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1977,6 +1977,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	}
 
 	if (num_conventional > 0) {
+		if (map->num_stripes == num_conventional &&
+		    !btrfs_zoned_bg_is_append_only(cache)) {
+			cache->zone_capacity = cache->length;
+			goto out;
+		}
+
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
 			btrfs_err(fs_info,
-- 
2.55.0

