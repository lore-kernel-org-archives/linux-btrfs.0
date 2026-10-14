Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F39C3AAF56
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979466; cv=fail; b=qYoLuhoZ3lvuYyfF+gsmcAv4eLZKZ7KWJStrAescL43S3n9kEtRuoWDpquv8dHuXxlwjuvBPiWmxbIGX/ioWI0/bbMNSAmMQJgOcDFi1RGRBVyahByfQsgdOzfUV68L3539lBGO39122yCx4OEHljb3HKqfhNk41VfhvxeMCQlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979466; c=relaxed/simple;
	bh=7X/3zSdT8k5HiUoWXXdz6bWRTUbWVG7FIbnERAhMTcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IYAO7jhfwG+elcQ2jbDefs0G+4cIQP/RBX8SPyWRyDMC+KXVaCUE71sZ4GHJTOjEhhgAEf9C6EfMAFp1OfyURzG7qci5wQFUhMqta4PI3OyjsVZtJOty6ytea+ES5gIZp9aKYU9ZBu7qoiqwxRFlLVm/b+5jL2DavSK5cZ36yy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HF8MClvR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=EyhDM6Jx; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HF8MClvR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EyhDM6Jx"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979463; x=1823515463;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=7X/3zSdT8k5HiUoWXXdz6bWRTUbWVG7FIbnERAhMTcM=;
  b=HF8MClvRXN+f1eudzfTQQGXCmXq5CUcyYz/yBk1RG1c19NCrMEEtpRcr
   m2X67rjy3mn7xoV5TlkkaKlPdkF2csb7WIy6c7Kt19VYWFBQUP7+hEZ+v
   tl5QGbVA1lwHFQmYd3w+xIBvmwJJL7dKf0kj3ykZ8Zy1baenjSvfPBtN3
   k65So0iAsCTowlyesRR8OAQJ8snhq32dTWVviFzupTgWnd2I5RsQAEXQg
   u5dZUbsBRQJkGZxZsfbKx7Dq7YeDbs+eRde5ed9cUCDkKYGzgxNZ3GDQM
   jraWdQ+IcvarPBhXwLTRpfPcLg9+oy2umO6xktxlscfl1t65urqH0BXBY
   Q==;
X-CSE-ConnectionGUID: 6q1fCBXmQbqETno2nrUwcw==
X-CSE-MsgGUID: PWFCuFqeT3uzknIJncYhHA==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077272"
Received: from mail-northcentralusazon11013063.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.63])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k9ipcku3d7HAvvwktxqEFL7N9pmT4EbPMF60HAPxFtMSeqtvdjP0Cybf5/e8D4jwdKDorfkSVD88QJqcRPvHco4Ea/yBj2CUhGWvOnpw3behyuZIxD+XphEFX/yO1SYupVQGBcNEoF3R6elppIY5FMj7JorjSs0qT0O9/K1nAXpGxAx3+JoC7Mua+7FG6WyvqEUk8tFvvH8WimErIgMy678d3tLBUy7EO8a6/oU/UZYiTThCWIX7+r8naTaCVmOUvWs46NKWKrqYbP8XiqaAKuPk8gXO5ZN9xOQ2dJG0sI+lIR+svNnCspKWjQhcAKEJetCDba7mKwfdBiWOObu1Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xNZ19AjV4MMSrRFwYcka4JuRGgnnYsw4lIdNz7p2K44=;
 b=jOfKhX1oblV3CAWCuCstDJTfEETN7G7kc9fTkCqDYbEvo6PynvDoLvh6oS9VXy6JsT2767DFh5+wGm1y2QEIJTtSAJryZ07BSq6ouoBtpafFJskEbDg5SAlTyBPHtvDwcxhcO9BXac1NAjy1TD7IcIp+dWTnRFKeKR8rhjYilCmnZ2hbcjLIBYysO08sVFQfFehoNIZB5e5HWnvtYH4Nx/yOcfeUc0nSGR2+fB+YhS3b9Xxa0VKi6PNpyTlw3+QrSit/k3AsQGfot28YxEAMI6YpvhANNK2CFSSQQ0HOpxkzxJNtxTHW71heSahFG7X+36cw9yvUyOcB0HP/9G7Tgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xNZ19AjV4MMSrRFwYcka4JuRGgnnYsw4lIdNz7p2K44=;
 b=EyhDM6JxVw+kXdCQe54/rnraIQJL+m1VniO94VD8BFSih9Fhx41iGMIDLvG+urUQMo90DYgclWKEv5dp1M+yhiW4CKwXcLyrKCuFn1EYrYxbILGiYyxtslN3fg2wVysofj+NnRE7WfloAaQJ5xeeJ2VWMTzINvasDBjlhuj+gZQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:20 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:20 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 08/13] btrfs: zoned: return finished relocation block groups to the data space_info
Date: Wed, 14 Oct 2026 14:03:47 +0200
Message-ID: <20261014120353.757931-9-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: d7efc357-b056-45bd-4019-08df29eb47a8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	+3pz7E8AL/8Awdkq5MIRlfFJzvVZ9ry+e1KKq0JutknHGNfNloUywmrriDZdZ4fckobYeO9HuE/RQVprqJ+3U6zNug08QaiA1FEyYkmhBPEZ3EF3Zoqtn3yvzbSy85AxzT4r9yffxS/IX1zjbfEVW4E2/hhh9rW8nH6Mv57GFIaQgZeICEYIDaJcDC/jFspll4Yie7omUDYs2jnyXjO3oTPwqt7XNFWn54hW92mL0m5dLsXVhp2f4cyL7uBa+uqMbZwuUxXZnWYmQ6f+xP2wGVyQ3zAoY94FsaeXaYD4Ioo6SfVRS4TDL/zIVHp6UypS+ThVMyrhZhAf1n6hyIoZ3RiNReYEa/upovaBMir6/qZyVv+wqKuMrNRcYTz0WSAx5dk9RoaqhF/49ySZZM5KxuyNWVq5I0Wb+kfNq3ygqVuhm2DEXErXgr5bTLhrzSlMzEfOTaZTS+GHgcX2UV1wGMJJzkVGrYZciH4y8P1WnXVWkT3/7domuvUKpwMYKUeGieMbLua8KUDfgRJDUvvXbYF9Pt62YeGnn6JXS3CSLxpppMGEsv2IosONMDR1JZ4z2Y8HoTyywqT73sWnVe4h8g14xTExDxhItq4dr1o9dTv5EhVaSmE7fvYQYyTH3iAu70IKyub5MueXpfbFt5hgcraZNeHrRSrXni19bjIv5VQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pO5CNlocZbJev1JE0IrGUQctvvxvEUrt5brm2BqdkJbnRmttIPMDGlZX8OfW?=
 =?us-ascii?Q?ww8HiP8YrSR0twU8sZtxxkoC4gBrl1X85hIy5ZLLv9AOkjnoxdbSxQvcpVBE?=
 =?us-ascii?Q?INVkkTnn2rjtJR/94jfdCAmOgwUWte+nZLj4cAbIpryHUGwMBeTjzPpJ0/R9?=
 =?us-ascii?Q?nyVccJKbkCei5mwlwb0BM3DD0glL3mL+SUqo+PqsIbhUu5qVXbvU6eCYMQ+V?=
 =?us-ascii?Q?OlFqzT5/Wt4Yt5Gfnm716dKSehNd1X3ohZPzOK52s1bC1ObHSeSPBI9PO3v3?=
 =?us-ascii?Q?zC0+AuWJAfPHqWqmTnV/3J8ogtvu8fLLJbbft1xHMSJjxuy2e7Jli2uWAEy3?=
 =?us-ascii?Q?yjXcDCOKHr+yaAFiLi+7W52mPxpYtRWtU4D1ZobsYSTPdLQ2XPy/Zt592SWR?=
 =?us-ascii?Q?DOnF+Ce6Q0g/uI2nMzEw4SbXQmOTzYy6iLx54Iw063dvmVL+n15w5arTdUj+?=
 =?us-ascii?Q?d/Iw6fQTSZBlyhpQ+yQPpmMT7Ee3G/mFJVNfKeiQFqg4KoXxCDy/ADjXyEts?=
 =?us-ascii?Q?61LzV9S1M/vzsBGWmzPMzi3XK9LfPMcxrogm/E+d4wDOjbAiWxQE9gzKSoLF?=
 =?us-ascii?Q?blkNeZsgH9pNyG/qgKlC9sa3MYUXd6r5fo+VyYQPxtk+9WJc8c7GSRlot7LA?=
 =?us-ascii?Q?FqPyS7R4zRZFw5cCDyjH2e/Q7uxz94sMQmbz9IjHWztTU/LjoiCp/GCvTauj?=
 =?us-ascii?Q?55ZpG9k+FBe+KlYNmSAqAWkVP5G06o1RmgWt/sOPQWUj/qIrVeGifqGawhYQ?=
 =?us-ascii?Q?IazPex4Udzaz3kCriLRFz0A9GKlvK4FhxvLoAbQnPbio2NxTrRHMe8mZk6kW?=
 =?us-ascii?Q?BhBVkXX2PJ8jEyb5G5yPaIs8yKOPInX5gfOoqJaB7n5vUBP7yNCsuu9Ksel4?=
 =?us-ascii?Q?AJdZ53SjhA1irnDSF10iMIAE5TxEDZ4xOFYD2hT6PDTnJV3eKN5ef2XpnlzS?=
 =?us-ascii?Q?SaaGE2ljYJ3PkOQZlvPwXqpsroDFO6g8WDbnDC+Rqju2HrOEjm6o8LNvd2KB?=
 =?us-ascii?Q?4xxiWu4pf2zhnDgk5jBSOXW6R3nBRdFfVZvBsT19TdR2h8QYYjR0sYnKYj0Z?=
 =?us-ascii?Q?e+nVlQWidxkMkRH9XFvxeWy7+aJ1Wib9GVfhxz/usCDZqcX4adJjEqT+Sz9p?=
 =?us-ascii?Q?8Q5o9BdC+RuOcS8D4alIWmjdJOZTeF90XvBYkT3P6NSve7ZFKVSzWpTQlNJl?=
 =?us-ascii?Q?3KmepWDAcHHVr8LmYcIN6zaBAgTsHjpPa/HwfgyAkbFP3L0nD5ZrU3bjniM4?=
 =?us-ascii?Q?G/E8GPC7gYYkGL4G41Ys0iQaPD81iXLS7UWq8VkbICjRYTQPkoGE5CWRUSHc?=
 =?us-ascii?Q?dozRKSyVmk8qSj3oBlDVHM+yJKy2QkUNeYAfam0UKiALbHs+U4PkxxzzZ7Ko?=
 =?us-ascii?Q?cOk1FrPENAeipc/RZdNtOFoMlpsTX9Pt+vLlnga/Nbp4MyF0hI1PRxwa4biE?=
 =?us-ascii?Q?7MnQhNjUiuEFMQyy3jWDfj24Gj1ra0b7nziIwl/Pl3Url5rtd9ginCgwJRje?=
 =?us-ascii?Q?EQitCL9CR7Hltqg6FYNCReMS0aWo++zPMDMb1gp2DV4KPfeaAu63PBL0U2OA?=
 =?us-ascii?Q?pcftuva2OPt6+xvfo/RX0pzuFX/TGILyGOleZ/N0qxstc0MJ73fL1FR9XKP/?=
 =?us-ascii?Q?WmyzuZyHPkY5x/96g9XOrR8mxUV2njo4LkmhhcHnj2GHBk+EBXcajZuBaKLe?=
 =?us-ascii?Q?cgS4TqSYC6KWM4CA6+ZVIwvULBUQQDAdCXDFESNrNzQxpba0gRP0J1uyM48F?=
 =?us-ascii?Q?SOOIEIEuMRGpUwztDMicP3sTWJDFiUoOiIQdybJ4UbEOC3f9CCTSwtHoFlp3?=
X-MS-Exchange-AntiSpam-MessageData-1: L2keB3Qk7gioziJEifMe+2zCzeuk2sqxcPc=
X-Exchange-RoutingPolicyChecked:
	sh6xTP3VtS3wc9eCoQFtjzEOOYKIy48Y4iek/ACs8HHsCV+MKO8077gYB9RVWcDuAPFqHpGk3c8B7yblsmUOxCuOaHsLrbNoqezS9Dz0eAbCZYasFcuH3utj5/aOdGKISHZfOiu75MfdAmFh3FQ7m3ITr89qci00nWT38a6hTle2kdXuHpaM24c4Iwp43x+TuDuowYijPjXVhPx9A5fIRCWzG7FGlWOJgsfOdf/plXjTtcN29dXmclrRXHCWrzYr9lZatom5iJ/eRdbwzfJT+r2TrWwZpESVMgD7hKM7FnOCJTZCycZRFFgk2h1zTRey6CHOP9JvZhGOr27l9/etnw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lpFDi9TzTkyzi2hh0znWQOYbEJmgqpP83NqXaigxh0JcPuiqW001Xep+DhUJVn1oUxT8nLCabkS/EVYoA1rtxf3Bm31lLCdAvFwXTKA9cEptb8rFiMsUfLMaieAtirUBV1Sl5VK8yDy4iaWMZ7Mx1Cpj/Uzv+rHoxdqKllYsL1dHrglmGm/qXOG3kAY6AKVIhtEzUpZzHKeNM57x3S3EHWMyx175W1crpLEdtbwe6RA2ul+u4nvueJUrPHZlJTbTSMdy0fQ+AQFcRAWDldQ1HGxRCuoLpgwBxQejBzREXPvsMpANevxTx5u8xIolbVgnAqk2+Oy0z2TI5LKLyMMmZOsCkZE7SDnj27DvXO5IIfMrTeLVMZEwQHbwg/1SKxsua52AQnmJHkX5570inqAadCzDAVR2uP7gaJ2LUNj5j5xfDigHLXK12cGTB+4My2TGIHvvH0lZlYP5ugJGcNGEkhKyzVoS5Caws0Fd4kTythWyWvl4zN5F3FuN1rpYuYJSTGJHcBxiG4ko3LhnJ5iZyOzz+3png+Wv4cv5AhgMYdQSPIBaKYEIt1P3bOIZS4V4YmcZehM7xrYChEdc6CbXDsn28VrGRpqfCCoAIk6ppG3Ui/9CItIngHOv8cMAihiz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7efc357-b056-45bd-4019-08df29eb47a8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:20.7196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhuZUf4AjozXKxMCHuR9nrJ18DREf+DR81sv+FM4AeFF+jMvGR5tlVWbv7AEOPt5HR5s2z3kf038gFxVl9b4m7eaOegGCr3L4eLuazTonU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

On a zoned filesystem, the dedicated data relocation block group lives
in the data relocation sub space_info. Once it is no longer the
relocation target, it stays there, so filled relocation block groups
accumulate and their space is never available to regular data again.

After each block group reclaim run, move the relocation block groups
that are no longer the target and are quiescent back to the primary data
space_info, and reserve a new data relocation block group if needed.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  4 ++++
 fs/btrfs/zoned.c       | 48 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  3 +++
 3 files changed, 55 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index bad55ab4cbb2..65bfaff1420a 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2190,6 +2190,10 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 	spin_lock(&fs_info->unused_bgs_lock);
 	list_splice_tail(&retry_list, &fs_info->reclaim_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
+
+	btrfs_zoned_return_data_reloc_bgs(fs_info);
+	btrfs_zoned_reserve_data_reloc_bg(fs_info);
+
 	btrfs_exclop_finish(fs_info);
 }
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index d5e1668652ca..ea4915db5349 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3140,6 +3140,54 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	}
 }
 
+void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *reloc_sinfo;
+
+	if (!btrfs_is_zoned(fs_info) || !data_sinfo)
+		return;
+
+	reloc_sinfo = data_sinfo->sub_group[0];
+	if (!reloc_sinfo || reloc_sinfo->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC)
+		return;
+
+again:
+	for (int raid = 0; raid < BTRFS_NR_RAID_TYPES; raid++) {
+		struct btrfs_block_group *bg;
+		struct btrfs_block_group *found = NULL;
+
+		down_write(&reloc_sinfo->groups_sem);
+		list_for_each_entry(bg, &reloc_sinfo->block_groups[raid], list) {
+			spin_lock(&bg->lock);
+			/*
+			 * Only return block groups that are no longer the active
+			 * relocation destination and are quiescent (no in-flight
+			 * reservations or pinned extents), so the accounting
+			 * transfer is exact.
+			 */
+			if (!bg->ro && !bg->reserved && !bg->pinned &&
+			    bg->start != READ_ONCE(fs_info->data_reloc_bg)) {
+				found = bg;
+				btrfs_get_block_group(bg);
+				list_del_init(&bg->list);
+				clear_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
+					  &bg->runtime_flags);
+				spin_unlock(&bg->lock);
+				break;
+			}
+			spin_unlock(&bg->lock);
+		}
+		up_write(&reloc_sinfo->groups_sem);
+
+		if (found) {
+			zoned_move_bg_to_space_info(fs_info, found, data_sinfo);
+			btrfs_put_block_group(found);
+			goto again;
+		}
+	}
+}
+
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 1959abf448a3..f792a0516d62 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -105,6 +105,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
+void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -291,6 +292,8 @@ static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
 static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info) { }
 
+static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.55.0

