Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793188675;
	b=0zvJfAO6atXSbp0441I1j+p2woQhXJZhVSsCiZcKO2XRkYfkhuZ1gM+VvwUs5f7iLM9/
	 f9euN6qkiQ3l1CsdnY0j6Y2eW8cL+IsfvexkfNNYLXjyyP5gBoVVWRRmZ9sRYY3jSW+R1
	 VNCoPU6tNFGohTY4sXdxiCxY7H4NxsLLMFxmPwKaoP4EduW1cML004kZ3aMck49FqDQGe
	 o3d0DvBPCrsw17LCahOTjlTBDd2WEbdlEGOhrpOzrBbKg62tuE/aa+Ug54OHjkBvWw7G2
	 yU7xsalSESUJRDenu7xEfReKzeb5wGsXEQarePMckGujCMNSuMlT44THne4TsQFJeaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793188675;
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
	bh=y7SALT9HN1Mvp6UsxQy4NlLkvyXRRogCio7qL3bwWhI=;
	b=g1hQGSrKT9vEuNeuEKk0zRXsWBCmxFba6zbb3s0iH+/RWozVD71HOffArRv4Xtusf7Zy
	 iKJOnAV0RNtCDS6g3oER3OpFMOcWg2UmbjjZM/tiPHiJjSO6OYUXnqkxuovzct+OMqfaL
	 +MiPC/2FUbuPrZf9cVK4EOYWyyMAlvOVXw4FP76fWNB69S0HIRr9O03ILSLIVeZPD9xxB
	 NmZ9qvv33VTXmgxXy0LzCY9775wMkme2ZvxTy6yz0w5KeTDcnokBr09dOEMHwrYfY49Ux
	 y3JK8l2ASIcFIVom2dcuj68WUQd5C9MKt+YdKZS1fsowpEJSqDXWZKTsL8jXmaG5V8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=H0VjAdB9;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="tx/hWVaA";
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61C8606A320
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 11:57:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A61C8606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=H0VjAdB9;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=tx/hWVaA
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793188681; x=1824724681;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=RAurLZRMZ2UQEnXFH1hmBkKUntRWOr851JJTG0zLLZ8=;
  b=H0VjAdB96BGr08RKJ5CaUX3xd+HGkS8br6eTwm5Rdgel7S538bWoxxb0
   wYL/PRABgi+TRNqjblm+AutjoR0D+TpuYvqe/lGzGJ4mUzXz6xSXD42pZ
   WWscnOgMee8oj87T80NJ+Ikt1sIMRJiRnQKOYNIF+RspB+C8f/AHlthwz
   6OcABySp71E8q17GMI+TYT7udzul4sxtuwDaGiVuea/o/oAt4IFuNHpOJ
   rXXw8978UL1u84T2C0SjdT5BEnD/4wLF7czyKOng7JnOVIN4nzj6jLyeD
   fcHaxJkn8KMXWul5w54ch+Lpc/s0bS3zcdyFOwJfS1afxzjlGxsBXaoRs
   A==;
X-CSE-ConnectionGUID: wKvLwS+WQ8G6kzmMlgse6w==
X-CSE-MsgGUID: vxid43QBSmG49iquyXlM8w==
X-IronPort-AV: E=Sophos;i="6.27,182,1786982400"; 
   d="scan'208";a="160166483"
Received: from mail-westus3azon11010055.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.55])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2026 19:57:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qlg5H0blkhCB7NPCoTbUWnQMBVtbrckh5VVglJ/s/uZcZb2ud4rXoKW5AhUdqm8jj7gZ6v9pKEWqr/HBKC6qyjzO3fN3/3bAYsjSwTbmpVJEwLsIf9h7qhwrTp6G4pJNGplKWeSPX560tZN8YU1sZnguRMDJDpVfVye3ciSVhSoRSU3/KzeN3l+VKIhq3cACiGIF9zlJhZFBoy/DdC4aQF/901zzfKHzYX84gCsXoMHtlfxudAnh/g6RiuzvY1sZVpu0a3Nc7jXBgpyk9512fCZh91fLLbhCpovq27n17PFkueQ4AbIWrFKq5zme/+p2QY3ENX3UxRGVfg6K2Bcagw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7SALT9HN1Mvp6UsxQy4NlLkvyXRRogCio7qL3bwWhI=;
 b=CgRW/+ltES3P2zCCpi7w6tPXS63nu+0yc07nLccVO54E7mSKnOi/ozPkFbb4LHqdKtLY4iPv37QdRduOpYHlN/kLfdp/RG68yzkH2qHOG099iMo/RhwXMBVXZ7NqLUnJL6F5iBIrRxQdg2O4qEjm6J3f4qTZptKEmBIwQ5ApmryNaOwbS5dD2a3+K0viBqDqQ1KbQA0fMe5NflNN/XnHxMLuKwi0sdWFVBhAmOIaCTZYCz7xRWX9SPE4vZaRe0ouMXPqGDSCdFyluP2x/y4fxjnDuGg1KdUVmkalqI4nJoYRcBFtR9jghkcdhbIShvyxTTaOqYPxudPHA/Bx1O6Uhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7SALT9HN1Mvp6UsxQy4NlLkvyXRRogCio7qL3bwWhI=;
 b=tx/hWVaA3/D0nvSvIZeR0ng73VMjastPCW9m9ifBdkWjdDj99U8kb6SAQgg5zWEdrzNRSD3NyroKP+JRmFiUVxa36UxBuItBrqTTShFjv2CkLq1T3bAf7NIEV5UOkSByO8nvuSwQNXme2JOiyAkiysdMqAY8CYyYhjBAQvnQ7+4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS1PR04MB9655.namprd04.prod.outlook.com (2603:10b6:8:21f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 11:57:46 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 11:57:46 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: zoned: fix lockdep splat on mount
Date: Wed, 28 Oct 2026 12:57:27 +0100
Message-ID: <20261028115727.72333-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0012.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::22) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS1PR04MB9655:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e2e57c6-4b6c-459d-81c2-08df34eaae85
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|10070799003|376014|1800799024|23010399003|261026140227099003|11063799006|56012099006|261021123027099003|261026121527099003|261009223027099003|261022075727099003|261021121427099003|10067099003|261022105027099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	47G0BXWMiJzUJ2H9tfnU5G2K/eXyB+EidHBpR/XXpuh6K8Wsa1/CjUqcq0iza3qFMfLaoQ9Pp7vMz4e4Pps3SGPhmJeqB3sqL9UMWqOz4zkYiAU63affNlVgUbaCtkuLdLx1FyCgVJfRESXwtI5hEtIWNgeMS2jqYg0M5h4uWoETQjcBNo33Z5zjvbRMUxn80x6NhoNDcHLUghyiUgfxnrdrtSQLjRpibo8+xWR3OVrDTovLrNfT+/bE+aUEqSxvGafi0ZJFmHcJpsGgU1igqQrtLfSjulUkg5fZa9whFnVwmW5Tf7qM3fmix/iUca2dgruUu+dvx5EfFTEg2CFYOpEjrZYibskGCHL0ASxXgndOHsBtBqB8pqNunkm348FtaEKzcw3fudAfZm5vjX44gmz0u+D/MYQiCoKIX4HuU1T/yuGJAXExWs8VR26osi6M1u/lqgDD/O5155/x1WdMO6+HD5VvxqpzESdzNNiW21Snkm3IBNno23haI7j4/1RW4n0ZyZceIf9+rkWftKN9lF2UFKjegmPtj5nFXAiVVMYwED7RX0sw4wpw/y/iPLMa4Z4GurDSLZSJk5LGzErRijNxIHW4vzl0Sb6pVPopubTmpuOYeKbGZ2NZP02qaMguLW0xslXvj29QeA7km9uagpjIxNHzfcYNhYpNz/s480w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(10070799003)(376014)(1800799024)(23010399003)(261026140227099003)(11063799006)(56012099006)(261021123027099003)(261026121527099003)(261009223027099003)(261022075727099003)(261021121427099003)(10067099003)(261022105027099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I5F+0jFtxPBNzsyIINk452AqBTZD70wbgG5Qob8DYKdLoyKhukiDnrEiq+pk?=
 =?us-ascii?Q?aEnQeUBfpRMgiVG20Ksk1Zc03PWLvjjr0nNmWc6Jhw2pmn3sNhVC8ZIJt/6Z?=
 =?us-ascii?Q?lN6eBA/5mIg+Dqe8WP55LpoR3ggIDhBXP89l4WV2y1PARRmcMOl3wIKtR8J8?=
 =?us-ascii?Q?qE4hIJv3XYq7QFbYzspdaRCHtwPj9c954CdFjsYcUFmVZ46nMiqUYamQkFCn?=
 =?us-ascii?Q?z+pqIld7GI+W2asf+I9HgNU+BZ/4mu2A06VRHvJpTzr/O3kIjZjyqrcyEofH?=
 =?us-ascii?Q?sl6AK3qxm6c0qhK741xY8ob8PS1HjifkyKNxxPAIwdb4gSn+bKSM5kZozgdX?=
 =?us-ascii?Q?Vy0oAR60rzweFpveVoGnuo0RGl2X4fcFRSwbLHXifxHfWPmwd0mmE2VaccNx?=
 =?us-ascii?Q?ybW4TwY34eO11M4gEstX1HojLwbRxWRyJaJ5w0FsEHERHO76Eg9ZcEbeKW9h?=
 =?us-ascii?Q?C0WG3lXQ64FzushsUkCdc4Sg46EhbVUAuRPDvWqRRs/UMN0AQxHqX0DmCMEs?=
 =?us-ascii?Q?ft0iRvutAzKX/IoBVYn9qxSYl077/7xoeDg/ODWkoDeO13FVNeeGkyydO8AR?=
 =?us-ascii?Q?Vdq7Vk7YK6ve2XGXcpKrRwR9TmCqBZ8pA2nrMODgbYbtPKUtKYJb2g8hr4SZ?=
 =?us-ascii?Q?/IegXyC+8CLVC3KySITI/r2Llt5SGoZLVvp0Q2PLfs+l1RYJ/hMlwZMjKOiQ?=
 =?us-ascii?Q?L0g/TAoINN/yfG7Y2jENpHv4kQBJkyRNJmeE56yEe8gfgkkzLS7Ubx603gIk?=
 =?us-ascii?Q?qdI7GvGTp6OE+3uhdfCfszTKJ34ydh/QHtJYL4ahq9QLxUUxv2i63C+tfKJJ?=
 =?us-ascii?Q?TSJGgvtb1mRCp1RwjeoaX9UE3yYY2V2Sgv/jid4q8KVBVZE3Y9AaqLWdosmY?=
 =?us-ascii?Q?5ghu47d5fU59WtDKXOruwP8Z3z9/+rtMNxWDq0BIhRVqat9x+4/E83oZ1c7M?=
 =?us-ascii?Q?RGWTkzvs3KY3Nj2PLcqu08qGZNmokyHQC8bCJA8KSIBcrnAmj9HMxEDuamkc?=
 =?us-ascii?Q?+/8d9+iIPbSRO5MwZ4II9o+c0KPIfPwvqlUfW9lXKWcYc5ePfVLYGHfNRXoK?=
 =?us-ascii?Q?HB5YLeBw9e2IAfoECW4Emm/lmZcmlEWvo5Jw3DfJPzcoUAZaBmLMkCYwleem?=
 =?us-ascii?Q?W+qcC02x6FRVUomS7qKL2RjWu18XVwB3NyQcyi2QpG1P3pYUy9jgmHdCcNx8?=
 =?us-ascii?Q?jeCaqFHGh/htNJVgKr2RQdiKSfuKnIzp96j+EiRiFGMlIMwKWvt5srmSfVRz?=
 =?us-ascii?Q?IR03ihEuQP8dTuPldw6UyYP4A636Wbu+NgYekBnWYVXU7OsZERIE2WJyZ8oC?=
 =?us-ascii?Q?HoJ11NxONwxnOQU1W8YaUuC+HptlNJXBoVzpesA9ZYCenwkHOGhywO8YC2La?=
 =?us-ascii?Q?YKiaB7pxOdtBpSWWqBUTFYxL0mWUTOb7mHXiJ9tbwNp9RjJvUrrRv29p89Hi?=
 =?us-ascii?Q?uoLhRj3EyU4WinvNjtUd3wM2WIHoC5lnNCkbLUCk5V8uHyD+VvN34Fin2yRg?=
 =?us-ascii?Q?xHhl0A7X0+OzJ4bZiqryBhdNCfJX2Yt789OthOa0Q+U5Wlg6SrRNkryNZ7Zx?=
 =?us-ascii?Q?Hd1ALbttuxiHDzSRrLN1wajeeAxhlTs4iT8B/TdHhfHhMUssWamKYpcn3GE8?=
 =?us-ascii?Q?0YdVfRxBY033eLzViIRvU6NHd++TtbsnaerVuI5ZpTBdvbS7helw+hYAXUfW?=
 =?us-ascii?Q?NjijUpnxfhwx8uCC+mT3Jc85kKdaucutxXVgkOl/5ny5YdPb0y+gRQQJlkLL?=
 =?us-ascii?Q?rQYqCSNODAwJabCa7jpzDyCxj8xHEykzAGiZ3DxUn35yQ0yiFzHe23+1RfBj?=
X-MS-Exchange-AntiSpam-MessageData-1: yA5jfQiC5oIEAGb+/JPH07OoGmYa19BmVO0=
X-Exchange-RoutingPolicyChecked:
	e1spcsNAaFvpaGVTfj2EB8CCaAob0WlP6iWM13tkeWtwEMKQ8bJZG6T+p3a/TzmdETxDdLKkWIO9gVaz6C23UImfrFBrlzNLf8rh0KeWBwUZzxqIYT1SEmULZtx0Xwl0eG+EH/6ot0MKQOFDw1w3FblTfeSxVRZC/2UWoNn4T/fmuKsPYKrKx6dlr9XVwKMgasNvkhxpjz3YNd+R+A2ZXHEy1oL33e+J1xbbpZr1wKkM8KdBqhx3O5aDxo/ExuotXqe5zmuosYSkVVuis9s1YWFowNhciQcmWDHRy7fkwgN9tCtO/4jmaPfu+TmnD9ZvzpFsbGPsDltQ8iJmmWHdrQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NvnMBjZnJRcw/SgqtbZrjcjjm6levdHD1mN/BuoKCGVt2PD/ntOzkqBikeaXZuRChUuUmQ7VDO5uYSaDdbhOLLDJYoF8yEa2acoxwWlfEyYZM0upyFNZrC75afvZDPkgeSYmIU0r1JMXhnaDnOiMH1pXk7+3OJXwTeaTYouPbrkjZp2Wi8sxQGOeXOB2hWctKh/36jFNClWtM2cdAj6lydC6S8rzGMGDTz3ln/ls21SugmP/O0CquRb3nBYbi0AskWQBvKab1mh73Bmn/L0bwenXMWmbdkmf4H9Rn4RorktqucqCGkG3t08sbIS2H+wpl6/AyteIpLo9iX9ye9am3P86Lg8Qy9ig2i3lGmsnyRuygZmZVmkUiFbKcPm3y5twQ4liSyLB/W3W2y/+OIjPbwCCjHVkNVJ/YZBRJ4XZv3jfw4F+d12WR6BrgG+lXY47eyF+hwfTINEBZB4iG2a+dumrfdCKqTr+/XgpOUbl0SNbc4pMFVL1JN3C+dgzx2Xpc0Wtb1ILAyhSL/sLZ4FQrsS5R7Q7NMBqTHsLTqp6FrZkHj0XXkYWsC/TlNvTLlHd1oIvQ//bxjK9pZiLymlTt+LcSFW8qEb2WW4Rlah4sJDNGdg2RZ0aSiKhs81PxrmY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2e57c6-4b6c-459d-81c2-08df34eaae85
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 11:57:46.7494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGpjLJC4+iIYzkn8Dik0JRDmwoDQW8EcjdDNyzEHCfrYJv24zqnkWZC4dV06R1D2piFUG9clZlMH70QBH2A1u5CWj7+v8JcA7MzkM4cma+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9655

When mounting a filesystem on a zoned drive passed into a VM via a
virtio-blk disk lockdep sporadically complains about a possible deadlock
between BTRFS' dev_replace::rwsem and virtio-blk's vdev_mutex:

 ======================================================
 WARNING: possible circular locking dependency detected
 7.3.0-rc6+ #317 Not tainted
 ------------------------------------------------------
 mount/7418 is trying to acquire lock:
 ffff888102c07860 (&vblk->vdev_mutex){+.+.}-{4:4}, at: virtblk_report_zones+0xda/0x440

 but task is already holding lock:
 ffff8881fd725ea8 (&fs_info->dev_replace.rwsem){++++}-{4:4}, at: btrfs_load_block_group_zone_info+0x186/0xe50

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #4 (&fs_info->dev_replace.rwsem){++++}-{4:4}:
        down_read+0x42/0x170
        btrfs_map_block+0x1a6/0xe70
        btrfs_submit_bbio+0x1a3/0x910
        submit_one_bio+0x93/0xd0
        btrfs_readahead+0x1c4/0x200
        read_pages+0x56/0x200
        page_cache_ra_order+0x27c/0x410
        filemap_get_pages+0x12f/0x4a0
        filemap_read+0xed/0x400
        vfs_read+0x240/0x340
        ksys_read+0x61/0xd0
        do_syscall_64+0xa3/0x4f0
        entry_SYSCALL_64_after_hwframe+0x76/0x7e

 -> #3 (mapping.invalidate_lock#3){++++}-{4:4}:
        down_read+0x42/0x170
        filemap_fault+0xb0/0x1a40
        __do_fault+0x34/0xc0
        __handle_mm_fault+0x919/0x1db0
        handle_mm_fault+0x97/0x240
        do_user_addr_fault+0x21d/0x690
        exc_page_fault+0x8e/0x230
        asm_exc_page_fault+0x26/0x30

 -> #2 (vm_lock){++++}-{0:0}:
        __vma_start_exclude_readers+0x91/0x1b0
        __vma_start_write+0x47/0xd0
        vma_expand+0x4c/0x2a0
        relocate_vma_down+0x126/0x200
        setup_arg_pages+0x240/0x3e0
        load_elf_binary+0x1be/0x1860
        bprm_execve+0x2d2/0x7b0
        kernel_execve+0x107/0x130
        kernel_init+0xc2/0x130
        ret_from_fork+0x1ff/0x2f0
        ret_from_fork_asm+0x1a/0x30

 -> #1 (&mm->mmap_lock){++++}-{4:4}:
        __might_fault+0x68/0xa0
        _copy_to_user+0x22/0x70
        blkdev_copy_zone_to_user+0x22/0x40
        virtblk_report_zones+0x297/0x440
        blkdev_report_zones_ioctl+0xfd/0x130
        blkdev_ioctl+0x20f/0x2c0
        __x64_sys_ioctl+0x86/0xd0
        do_syscall_64+0xa3/0x4f0
        entry_SYSCALL_64_after_hwframe+0x76/0x7e

 -> #0 (&vblk->vdev_mutex){+.+.}-{4:4}:
        __lock_acquire+0x15a8/0x2850
        lock_acquire+0xea/0x2f0
        __mutex_lock+0xa7/0x10d0
        virtblk_report_zones+0xda/0x440
        blkdev_report_zones_cached+0x162/0x190
        btrfs_get_dev_zones+0xdc/0x2c0
        btrfs_load_block_group_zone_info+0x2b6/0xe50
        btrfs_read_block_groups+0x338/0xc80
        open_ctree+0x1aca/0x24b3
        btrfs_get_tree.cold+0x105/0x26c
        vfs_get_tree+0x28/0xb0
        __do_sys_fsconfig+0x324/0x690
        do_syscall_64+0xa3/0x4f0
        entry_SYSCALL_64_after_hwframe+0x76/0x7e

 other info that might help us debug this:

 Chain exists of:
   &vblk->vdev_mutex --> mapping.invalidate_lock#3 --> &fs_info->dev_replace.rwsem

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   rlock(&fs_info->dev_replace.rwsem);
                                lock(mapping.invalidate_lock#3);
                                lock(&fs_info->dev_replace.rwsem);
   lock(&vblk->vdev_mutex);

  *** DEADLOCK ***

 locks held by mount/7418: 3, last CPU#0:
  #0: ffff888110aa6868 (&fc->uapi_mutex){+.+.}-{4:4}, at: __do_sys_fsconfig+0x2ae/0x690
  #1: ffff888112ba20e8 (&type->s_umount_key#31/1){+.+.}-{4:4}, at: sget_fc+0x148/0x8d0
  #2: ffff8881fd725ea8 (&fs_info->dev_replace.rwsem){++++}-{4:4}, at: btrfs_load_block_group_zone_info+0x186/0xe50

Holding the rwsem was widened in 0090d6e1b210 ("btrfs: zoned: fix
use-after-free due to race with dev replace"), but it now also covers
calling into blkdev_report_zones_cached(). The device replace ioctl()
only works on a mounted filesystem and the only caller with setting
'new' to false is read_one_block_group() which is only called during
mount, so it is safe to drop the rwsem before calling into
blkdev_report_zones_cached().

Fixes: 0090d6e1b210 ("btrfs: zoned: fix use-after-free due to race with dev replace")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index eb320ab1e398..0868cc1755ec 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1425,11 +1425,13 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
 		return 0;
 	}
 
+	ASSERT(!test_bit(BTRFS_FS_OPEN, &fs_info->flags));
+	up_read(&dev_replace->rwsem);
+
 	nofs_flag = memalloc_nofs_save();
 	ret = btrfs_get_dev_zone(device, info->physical, &zone);
 	memalloc_nofs_restore(nofs_flag);
 	if (ret) {
-		up_read(&dev_replace->rwsem);
 		if (ret != -EIO && ret != -EOPNOTSUPP)
 			return ret;
 		info->alloc_offset = WP_MISSING_DEV;
@@ -1441,7 +1443,6 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
 		"zoned: unexpected conventional zone %llu on device %s (devid %llu)",
 			zone.start << SECTOR_SHIFT, rcu_dereference(device->name),
 			device->devid);
-		up_read(&dev_replace->rwsem);
 		return -EIO;
 	}
 
@@ -1469,8 +1470,6 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
 		break;
 	}
 
-	up_read(&dev_replace->rwsem);
-
 	return 0;
 }
 
-- 
2.56.0

