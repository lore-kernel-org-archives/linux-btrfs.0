Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794905414;
	b=TPbUT66v70mU0P3NuSdhJh1LEQwz/qdukwnzffYW8CqwqV+V/kxruwFQXlFOWulSGCbC
	 XpsAa8i0iZaLMOmgxcm4XU72G3sM0vvUfluvk3n8n25NambvGwZMTinjEAcLXicKv3Ihh
	 jgfcP34G1rfC5Ppy0/z9goJucgT7biu2XfqlJD+9v5VhKGjaxm4Hvbvhq+151GhqCfGfu
	 CiDsMdNUuUA07KPYuPfeiMW2fb5iIETmaE1oPOJKtbW83wrqvwqrNIX8Yjb9sWZEY0JeE
	 2LD+45D+TnAW/XHghJ3ojZaQ6U3V0S+AWqX2KMerrcPWtOAPf4MBuTCwwg7mRzryiSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794905414;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
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
	bh=NDFrmqOhqrMSzFGas47EvrSPu67BMYkIoe/gkQZ7lJQ=;
	b=YaUaVnYIQJhtBztW9uSR7UK116zeksagPjgATQpcMzDp4bf9kPc3t9NYNHIV5lqhHY+r
	 o2vgZ6SxU1xf63zdZrfJ6NmeOiVH+GA1kb81sZ4gMRAFJD33V9L8QUEsJ0O4Tm0GLrvip
	 zSfIpgkzwoiutKG/cqU3n6HUF9uNtGOSEs1TueNvOs76n5uKcfEvGwkQCdU2yDijl3UDt
	 u3pOtfTWX/4XahrsjkmC9amyyF3Ugt4cRvPjJ6HaftOzefidDHoQAku9yWWED5e2378S6
	 YKUhlxQKPp+aQsPPp+P5vzRzpNlaG+9a89C/SsSEnPC1KdKUs47A05MOJ3d7jFvaIbA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="W1S/44Ox";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rpSRwH7a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CDB606A33F
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 08:50:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6CDB606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=W1S/44Ox;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rpSRwH7a
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794905413; x=1826441413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=aSv/hmjRjWatRsXm/Cx69/z09k51Fu4OcB9jhmTP1Kc=;
  b=W1S/44OxULuksu3/n1V3uO+HD6w/BKoRm/8IGdh3Q5J8u0tSoLdgiX2f
   PjEXauZutXmBXAH1MiqJ/uPgX+DCI7d3tTGKhUgUiWtrMrNHFMbg2jos3
   PrVMPAHaMF/WguCrf7MeEIDZjB4+h48wJhqk2Uf5hO1qCVoLViHik+us2
   nR9u8eDFLUuV2c+anDbQryjVu2EADByo5rwk/+hTlJFI9LmIBXUZOZQhA
   BGOmh5hHkaAM5Aqi6WZ4PoMvbiR31KMLRLr18Tknl0yYk2r9GBEJlWFSY
   T06qyelLnG3Am5F5Rhuli0IeYJ+7lZz9vCW/zSWMCj+eCr806BpqVK8fM
   A==;
X-CSE-ConnectionGUID: X/VnL3ivQhijECehjV7GaQ==
X-CSE-MsgGUID: dDhx9i4bRTOO9e3X1aT2yQ==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="161007151"
Received: from mail-eastus2azon11010015.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.15])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 16:50:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wDICCegZ+uGaKncILQapYv3td6MeD2CefFqK5bfAukF+DHY9oxdu07x6z+DxRRYBnWrQOm2k+YA0XoojOEvFPsoILuxvKnkNsR7z85r2+b8Qqre+agVJWAf+ehMClNOZ3EABqeKncYIxOFg2u9w9h0jfv098dTnjZ0EDKD/A/o/LYl10Mqu8jhPVxKWaU037IONLqoSMqme/nuG3k/naKKNmbpfvXsXqaZ3aCAoK5mN9cZowq/xHN7yZo0/MEakL5kisq4B1tFC360ME+C3iVuypkR/j5gGWzfgm4FOZy3XLRz7iDZWUKxeNw3ZbGhFJeiw9GS5EVmye6Z5k7AIoLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDFrmqOhqrMSzFGas47EvrSPu67BMYkIoe/gkQZ7lJQ=;
 b=rGEWbHCzVqtLOyzKR9LJk5ZAhwwcPNXCQZ5o9aX59+waC4Xc2yq5Ui5b/QQOdmXX5TIh0CB1EhE3wv0NE1vTbHdfqMpx0Iai/E0f9dDWi7iybMu9n2M3vqEgFJBdgEpiIi2ZjaJZ2HMQGsSXYYXfK/Zk/8PVOz5Vgaxhg6kJramxBLoWrXOtja2szDLprl/Oq6evFXGmoHRBuO3j+L+ePQfhhEtUa2Du1y7+LGk0jxzBMpBfkEUGgkT6wMPC51sPrc4ACKdkF8f3ksIIdkuHTE12rok32pqzEHI+munFuPJfD9jBk/l9r9qOMYXTsGiAZkel2GfsFBh9aNVaPh2VKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDFrmqOhqrMSzFGas47EvrSPu67BMYkIoe/gkQZ7lJQ=;
 b=rpSRwH7aOUqcgmoKqP/ZbUAee2UVkWoy/fln4AGJ6D124/2S99AbJDuJlYjrUbq/seqTMuc8BxVwY7Z1RZCQxjCv/nMYAI71Ct6BS7+pKU8W06LihDbELkUTxk6ycfLiWyhsloM1bsJyncOFNOM8yVD8JdMtUqMbUZKWCo+KU9E=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB8145.namprd04.prod.outlook.com (2603:10b6:610:f5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 08:50:08 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 08:50:08 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Mark Korenberg <socketpair@gmail.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/4] btrfs-progs: zoned: use cached zone reports if available
Date: Tue, 17 Nov 2026 09:49:44 +0100
Message-ID: <20261117084948.3848762-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117084948.3848762-1-johannes.thumshirn@wdc.com>
References: <20261117084948.3848762-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0401.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH0PR04MB8145:EE_
X-MS-Office365-Filtering-Correlation-Id: 333517d4-e81e-444c-cf47-08df4487c817
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|19092799006|10070799003|10067099003|56012099006|11063799006|261026121527099003|261026140227099003|261028144727099003|261021123027099003|261021121427099003|261022105027099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 yZs0iWNZ2FbiYFYrh4P1Sl7Lh1o7Rl/dU2y3BY93JwpjtLcmp0RuvmM7zbnOYmLgtvJiyn0cj66kdON19mNkwcb/JO+xhLOgVBIXW+13O+JiTZg02DIS4YjcNm2lKa7v7RphPZIVVQXvVDIjuwcjopGqhyPWMf6FEzPeeLjxlRqsfTj8X/1gowc0pOFO81saxwBZrPAJbVbxDC9dFb2QFjNCBklm6Wl0VwjUaxSI6DRnJ6+H6W1O6cBvjvChGZUavPKdSvJfjEfFL5pw89uYH/7/ofA9TM5asCsiKzrgX3kfF8nL0GDipnOmx5CA4O3hhCquz99WISSUdiJ8EVdtNni5GMbV7JD2M85hrfnpWNO7Taulh89YzSnmqY67ZtfVrbCg/rZM8v4DXoWldiFrHeGVb6+NEKF2lKNcmYn5P5mPciRjzsVwdAAyZq91JMluKd6fNuxyQnpQFPdLBI5S0vIc61sQtl4Cglbq15tNwZeVZAl+Iu9MHpjExVdhjgLRYdRVNhkl2iDIpy2DX2dLZbIcXqI55oVk2CM3Dr2d/0x7rbNv49NmNDdKcKYcKqlKXo2DtStJIhGllGVik5AvHszDvZnHC0JaefpvSWrj+AN2NJ+Oc5IjX9LKZhf0EsZfpng5wJ7ptHS5Tw7JzlOWqPboYp6NzCXDG6P/AWZnfeM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(19092799006)(10070799003)(10067099003)(56012099006)(11063799006)(261026121527099003)(261026140227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261022105027099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?hILSFQDPbzNgFdvVvcxj7PuDNuuMZjSsGWFqwaM34mlqvtYt/1tE4utM8C3T?=
 =?us-ascii?Q?OFyjXVojkQNVy3x4EatEsf+diiu5UyiM8PdA+ZjP1A0wCl+gL13zyTLwHIya?=
 =?us-ascii?Q?gieY/b/dADGxpM7ftMBeJM008KtCUUmjgEdZB0y4SzVTZHfTZr3qgJdQkYtk?=
 =?us-ascii?Q?k2TFyPvbALv0JIv9g3u36Uv4KSutYgOA81eYHgGQv6BqUjUIOWzsQSHnkHyr?=
 =?us-ascii?Q?SryZ1HwAiINWN3w0HrSX+UpCMxrkEBNhkM47NNFGoB3MCDE6Pr1W71W0oXcO?=
 =?us-ascii?Q?J0NSaust5byXXUaAQIwe3OLFlpc8aY0E867cJC3MTE+yol7CvGKFQQz84Olv?=
 =?us-ascii?Q?U3tcxyOMVa7Tv8HDGKKKInCB/NDGXEhZaMozSRIULKmc9WU06gRn/KLdOmIG?=
 =?us-ascii?Q?npg8SHJ4DCV3zAfN6VpSs5WxWKrL9gu8eRf7tFXhhEBEdJLAHn5SZTM7haBs?=
 =?us-ascii?Q?ryg0zEOqwvBvPb6a7gy4tJicyjxWzSe+MhI4W+jRVkK4Q6ocAbd6amv41ic1?=
 =?us-ascii?Q?Wg5liXNYjMlI86q18mMye98v5kMl9xpz4xVgAY/sUntwSULZ2yjb0/Ck2M3I?=
 =?us-ascii?Q?+U6Kr14I7akHwgsLfvUQG1VNSiGY1Gf8nUxjy136wlC41U0hIAkTEk/mlqV+?=
 =?us-ascii?Q?AZVIB/bz8wlIdtsQs/gxfV8XTorb71AQpIwMjVPeTc9knrFTufDHg39TolWA?=
 =?us-ascii?Q?SnY+VrpBj62BrNN65Ij98Bb0+rLZ+AQlBq3a+F68MZaP0LFugtpcuLb78Dcp?=
 =?us-ascii?Q?EmqvymnRspvZX48k8zJjO+MmOGkA1ESYiu9mwGSPl4azyZvheZedOiST0Q0E?=
 =?us-ascii?Q?pAhyxaeuWJvzFZ9vaXVKoF5Yz3CvESYXNqfWu6Hfh7IQqLpvKwAs98nR6J0n?=
 =?us-ascii?Q?jBF+412OYBPZsH/Bp1x6WyIsq6iY0WPX7ZXDhclx2gbhOTTE0s5TOIatFeKm?=
 =?us-ascii?Q?MifFnmD8NHp02SGHQPRnABIQDoR7XBw/pyccd53KAFUhoDEYQ64/kEEfCoWh?=
 =?us-ascii?Q?Tl/hLpo+KCYq5kY1tAODYXru1SXlgtjccrSbaWpsIkHneD9FRv2eMvSKMQHr?=
 =?us-ascii?Q?bmPFvpYvTEmj7kC2lMnYMoFOIB4kZuGLhQj0ItKsLuqDB4tcHG44nVLi30yX?=
 =?us-ascii?Q?ytxlwiXpn09gHk8oPM7ryoQ/Q3LmlSmBCCFhr1CJrCjW6cenunOuDmYADIzV?=
 =?us-ascii?Q?+QGtXzeDkKLPLMsP2VqZSmSD5HLt07MwDwRXfkQaJ+QHrYCOuT3h0ztbzdAK?=
 =?us-ascii?Q?9GAyLkLdNOp3Cfu/es31nzAmhcoJDf7ygyH+NFPfJrjO2dM8I+/wwiY7MQPj?=
 =?us-ascii?Q?TMhrUkE0Pj6NfCcX0l2UgN6E/45Jhr6Bd2qlusGRp4PvsbQUamqivtwK6ZpE?=
 =?us-ascii?Q?hRefVDMhbHr3TiZP57nrJQHY+/9VkyKffN0/D2zWCZiioj+ow2xO8UqQV0Ft?=
 =?us-ascii?Q?dN0fUApInHEq5Lfo8tNXWduGx+dEjQ2OHbMD3vOv9Nc7aOkS4Lv560QwC7OL?=
 =?us-ascii?Q?BwoEiBWVbxTcdTEPDPQ2gjK12qiLRAH71T4YWJEG6NwdbCwmioB/iNhK1XRY?=
 =?us-ascii?Q?c4Cx1pDBkKTtfl7l3/3hODjyVXGHddi0LK5MN1em8GF3jI5M48aYyY6OgOEt?=
 =?us-ascii?Q?jDvIoNy23Ip74WVF1SCerq7ztbmomXn4iwLdwbgwmNFcX0ToEtHk5rpHZADj?=
 =?us-ascii?Q?coECTwI4N3vzby1cb0Q9zHK5q4cE5bNNADOzMFKkE+wpZ7re/j4kYreO+6HN?=
 =?us-ascii?Q?Vxn/B/e9h4WefZEBr/c80iJ+uAD3YWMQBgP1R7H1S7UCyXNARkvSLRUEom5g?=
X-MS-Exchange-AntiSpam-MessageData-1: 6aL7ZytVM7ytlSLw14wpDGeUqqYpxAqn+vk=
X-Exchange-RoutingPolicyChecked:
	D0irDCHdWhTlo2g33/RnNLx6BoBDgTcEej9hKI51iO0WSEILu5/IIYsj/Ahc5OAY50WB7I/tnyL9kOb08/hIGwxhkz0lxiD5LZDsZXDkEai/FvzjYCJgwzqMI8XA84o6jUWabH1hJkfKg6sx09zUJXiwnMtQM9AT5yWYFuadUw3rL/YGwwJt54aM9i9W26uH6Z0FoiVZAvzmmm189XwcXldubw1B+X180PbkSar27z0PnBsAkPgBvcur0yQHXSHgdm8ZedtYvLccdo8bZCiugacG/j9qHMIR1tq+oc7JdgNRrehkOi3mIIDZgm5mwMxabkreurkiQbj9LbTMV2YP2w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cAxOPRwI6AgOYfD30awVeWhhsmNq49w1Q8YF/0vr8yQscq99vgrDCc4yJWJqPDvxgJXyaVDp/GmzBcT05EF87134GT/oxhJUjVkTu+AiOg1lRGK5su1+Ld/hzxl8inbncRbcJyS89yH7WW0VIjvyNhhZmQoa+weoQndlq8+FdOkeYgD4RbgwbqdKCBjkNGMOucrlRQ+NnFZoWlyM7FPlObmP2JPkcUds/+QElj6X5RP6EACfBuDhs0RZj8FeJD2TN/zEdOYfCZjHkTlnXrwVr3C165x9lUh+8kHfuXsPcdSZj39WqnbtLJRsKAy8ZBumcI0PZ/sRa+0X/1VmVa45twu5dFxl23ARmQpTA/xMCgkPl615d+aaeAQL12uDaExRIlfZPvlNIGa/J0Q5FgEiE9Y795JNvcNqzONoWhWU1/dPwLdw5u7RRKZrsWQWrfkDhWzFqJp73Q5KDy9fn/1V2wc8AgpIzxTtOWvBfpQtjau9SmiAkYERkohpp3Obm04FzcvxGfOqhbXGoxAMxhsGPMOFJF/I4Vy3Qzc1WDX3GDodSF7qUEwiNAlfY83RLAqa0IgIWFu/+olBpyo4jLljAiN/cPt0FOyV2C/DaHG/nSYg0ujmJnaXFrtQvovFGjVu
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 333517d4-e81e-444c-cf47-08df4487c817
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 08:50:07.9969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2LRenQKr4QfiM/gBIHz73X3XbyhpQpuAFKh5VmPArmFPyJHl/p6iGKe+Ny+I9L760KC1wDKcxE2oBGfWLdSSMWW1U16VXJHrC4xG/7MDck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8145

Since Linux 6.19, BLKREPORTZONEV2 with BLK_ZONE_REP_CACHED reports zones
from the kernel's cached zone information instead of asking the device.
Use it when the headers and the kernel support it, fall back to
BLKREPORTZONE otherwise.

Cached reports return open and closed zones as BLK_ZONE_COND_ACTIVE,
handle it where open or closed zones are counted, and provide a fallback
definition for older headers.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 kernel-shared/zoned.c | 35 +++++++++++++++++++++++++++++++----
 kernel-shared/zoned.h |  5 +++++
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/kernel-shared/zoned.c b/kernel-shared/zoned.c
index b4ed4702..a06abdea 100644
--- a/kernel-shared/zoned.c
+++ b/kernel-shared/zoned.c
@@ -272,6 +272,31 @@ static int sb_write_pointer(int fd, struct blk_zone *zones, u64 *wp_ret)
 	return 0;
 }
 
+/*
+ * Report zones from the kernel's cached zone information if possible
+ * (BLKREPORTZONEV2 with BLK_ZONE_REP_CACHED, since Linux 6.19), which avoids
+ * a device zone report. Open and closed zones are then reported with the
+ * BLK_ZONE_COND_ACTIVE condition. Fall back to BLKREPORTZONE if the kernel
+ * or the headers don't support it.
+ */
+static int zone_report_ioctl(int fd, struct blk_zone_report *rep)
+{
+#ifdef BLKREPORTZONEV2
+	static bool use_cached_report = true;
+
+	if (use_cached_report) {
+		rep->flags = BLK_ZONE_REP_CACHED;
+		if (ioctl(fd, BLKREPORTZONEV2, rep) == 0)
+			return 0;
+		if (errno != ENOTTY && errno != EINVAL)
+			return -1;
+		use_cached_report = false;
+		rep->flags = 0;
+	}
+#endif
+	return ioctl(fd, BLKREPORTZONE, rep);
+}
+
 int btrfs_reset_dev_zone(int fd, struct blk_zone *zone)
 {
 	struct blk_zone_range range;
@@ -285,7 +310,7 @@ int btrfs_reset_dev_zone(int fd, struct blk_zone *zone)
 
 		rep->sector = zone->start;
 		rep->nr_zones = 1;
-		if (ioctl(fd, BLKREPORTZONE, rep) == 0 && rep->nr_zones == 1)
+		if (zone_report_ioctl(fd, rep) == 0 && rep->nr_zones == 1)
 			*zone = *(struct blk_zone *)(rep + 1);
 
 		if (zone->cond == BLK_ZONE_COND_EMPTY)
@@ -410,7 +435,7 @@ static int report_zones(int fd, const char *file,
 		rep->nr_zones = BTRFS_REPORT_NR_ZONES;
 
 		if (zinfo->model != ZONED_NONE) {
-			ret = ioctl(fd, BLKREPORTZONE, rep);
+			ret = zone_report_ioctl(fd, rep);
 			if (ret != 0) {
 				error("zoned: ioctl BLKREPORTZONE failed (%m)");
 				exit(1);
@@ -441,6 +466,7 @@ static int report_zones(int fd, const char *file,
 			case BLK_ZONE_COND_IMP_OPEN:
 			case BLK_ZONE_COND_EXP_OPEN:
 			case BLK_ZONE_COND_CLOSED:
+			case BLK_ZONE_COND_ACTIVE:
 				set_bit(nreported, zinfo->active_zones);
 				nactive++;
 				break;
@@ -511,7 +537,8 @@ int btrfs_reset_zones(int fd, struct btrfs_zoned_device_info *zinfo, u64 byte_co
 			continue;
 		if (cond == BLK_ZONE_COND_IMP_OPEN ||
 		    cond == BLK_ZONE_COND_EXP_OPEN ||
-		    cond == BLK_ZONE_COND_CLOSED)
+		    cond == BLK_ZONE_COND_CLOSED ||
+		    cond == BLK_ZONE_COND_ACTIVE)
 			return EBUSY;
 	}
 
@@ -669,7 +696,7 @@ size_t btrfs_sb_io(int fd, void *buf, off_t offset, int rw)
 	rep->sector = zone_num * (sector_t)zone_size_sector;
 	rep->nr_zones = 2;
 
-	ret = ioctl(fd, BLKREPORTZONE, rep);
+	ret = zone_report_ioctl(fd, rep);
 	if (ret) {
 		if (errno == ENOTTY || errno == EINVAL) {
 			/*
diff --git a/kernel-shared/zoned.h b/kernel-shared/zoned.h
index 2d01da7d..7dd86e4c 100644
--- a/kernel-shared/zoned.h
+++ b/kernel-shared/zoned.h
@@ -31,6 +31,11 @@ struct btrfs_fs_info;
 
 #ifdef BTRFS_ZONED
 #include <linux/blkzoned.h>
+
+/* Reported by cached zone reports for open and closed zones, Linux 6.19 */
+#ifndef BLK_ZONE_COND_ACTIVE
+#define BLK_ZONE_COND_ACTIVE	0xFF
+#endif
 #else
 
 struct blk_zone {
-- 
2.56.1

