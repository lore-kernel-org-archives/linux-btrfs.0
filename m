Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB09449B01
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634098; cv=fail; b=lvwFjKtrlST8GVJ1jiTvIj7coDE5uqe3r6naqJsncG8xkmiibmKW3tvA33dEMGFy98m2z1LNBqKTbSmHiISs2Ve+9xEfgij7j8NwI0/FwJ4WVN9fyJ8nm4bdVaYuJdPzZlag1R6WaGAoZdfwG1ogw/aOz8dRe1QvMxXcz+mr0ls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634098; c=relaxed/simple;
	bh=SEYQPsQ/HNRDAUeFKr4yZCqpUE+xjMj6BGYIbyft0yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QUQkR8Dp2YcVB8W9S04nKtolZIglTH1oherEtEsh+eNSJ12YdpfA20IuNZBKgqV8iYtyrnepPd1prsETJgUSWGucmIuUxqm5WARtF6EbK1D/EWOZPnl50Sbenf57Opg92ENgBAcYqqgdH45F6BUXQtSiuqCeiwfwO/w3jWxtmTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=raSErm9Y; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=xcobnKfT; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="raSErm9Y";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xcobnKfT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634098; x=1823170098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=SEYQPsQ/HNRDAUeFKr4yZCqpUE+xjMj6BGYIbyft0yY=;
  b=raSErm9YRp1rlxVLi2+9Epq+oo99CTSUHSk6ToC91RyArLwdyEfXieiN
   Ho3q4LyieSMTUoA46RzUDbkusth5j9wgzWwfK0H3GgKZL+mmUQIReW2W2
   ciicRjW/fujDc7SxvfzuQw7dlc0nBB2FXDUKjrwJS4d5fLtYvyrwknPYU
   qbrjHGajiYyr5dfIE0SS2Qv+APTDX0rL2TSVuE+IM0oXmfuBP0uNL16sb
   3JO2uS+qAUolrP+//0ExdHJpQkR5z71CePyhVzdKBl1A5t+mxInGwrBpL
   qbKoE6ap5eHdVibjonodwshxeyyo5vKVrnTgBTwdfySG1GidXk+4kU71E
   Q==;
X-CSE-ConnectionGUID: 6kUbIYENT+C/Mr1aI58LMQ==
X-CSE-MsgGUID: J4SsYJ+UQb27O1euLjqY9w==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="157785427"
Received: from mail-eastus2azon11011020.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.20])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u75ifhJEw4xm/dFlMK1C6HEhyCSaboCwizf6Y1tPOa1AgVgy2bN23gBaSdF8kP7zlyKKnd8KDqu/EKRgSCrm34BNhkOaLAhbkQNR3EXUnLGL8Ny7k/o/IvhFDnR2RdkcMEVpn2jKZl5by1pjwzzlTr+Oi63zj6WszxwLWAJyBCGK1BFDIwX61xhWloqs6R+mTeQAIY42rUcX6EJluu2hsyMS3N+j7F6YBwf2MyhdHFNWSyMSUiWiYvNgtKhdRBXntqOrKu7VKTu3Hvb3pTZzAlWP/cy7DefEzN24j+UxVP+7WfqGgO1nWpd9SFEQl+HXM2qasBGf1miWDo/bywq+UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OlZE03PKzZiW7cKt4l6tn0gUby5S/T4TpZeSgArkErQ=;
 b=Baclc2+LfzQhcZaw6Pzzpby6i1L6pFGfmxbkYt7dILcBG/RhZdR+yRXzYK911bZvTHI3rwXc8bjh0hmhu5HLsk9I64bd25f8IvvSUvRGyWJidul6yo8HPDe6BSconKONzSjUddWdFJ4LmAP4xoSC9zeIqzTvcnpFYHKuYIWFAcpVn17J54ewYZBKKn8FQiiCvw0qH2RKjSjHKidtPEUzkpxO2PpfzVj57QKPgilWMI7MDVBA1Mf+2OgSBh/OdM00HzNIXBIpoUZB0/PCzZloKieAfYj3+EPlz+WaDh7tkocp1kWhJbbHdmku6fywOnDlbRnlzq+fn3uhHf43smN4Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OlZE03PKzZiW7cKt4l6tn0gUby5S/T4TpZeSgArkErQ=;
 b=xcobnKfT2pCSVv1g8cMcUXDxj9KbZJriHh2ga1vMIUMl6ParQ5S7wCnNiEbU5t7i1KEFoyCE4Lg5awfwwvoAZfdW4JgN4YrtXeS4wwwzGjFQrOXTsnSZInJAroHHPOXNnY5zECrOKA725BPaterf9QevfPiwW1A1yBMUiDEJ1aw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:07 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:07 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 01/12] btrfs: zoned: don't activate conventional zones of mixed block groups
Date: Sat, 10 Oct 2026 14:06:11 +0200
Message-ID: <20261010120622.3781326-2-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5c5706b6-c290-4bd3-f3d7-08df26c70176
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	T9LiQLFCvkPdNnSiD1BA4u5rLuRO9JXm+tOAWI162OY5f7p4BE3yd49t1O0U/CGsNu4kyOvRxgwEovhKVVLlHccZ0fN0wC3k2f1lClQpUDMzuMF0zzq+44TT/KPdoibG/5q7Bq+bLuTEpT+caB9560G0Y72HVqRwjyeQBhl5SG2OybunIdHdpKYfkHWgGj2QMOMDxBnNJpog0WaRXV7iew3DnyAMSp3lI2mGoqEIBrJrNNXy6xVt0u1MOTBns3Rf1P+xgctselXYGqhgFRpgR4mcezJcgcn05C3pnav0wMUIMzvyHwbWRnG3AzMsmdrZ78eT+SLrW5rDOn+t8NBrINKuyr3BUYjuhRKxOFCvtRmlwnykqlIKTsr3c4DXiD49L8EIA9fSehvtqQwpXipcEYXzanA5eE0/XvsuFTbhLCa1tiIheXtzOaWRsgKZj4GWxfz0Ng8kcxdxqCDE/TMC505/pigRwWYM0fIFx227CSrq5YGJwfKRzmP15AWEB7kjNPAwK6Y3fBO4xRyLYpU4SRXnuLqfC9lSEBXOMcQQMmUnZtjO344QfTiA0mt5SW1SiXaHizWWik73btZBK5CPVZRwAWdn+fDQuQf3+qLOI3GB3TOsiw54KkPH41mwHf5qbmxKjuof+dQF8Q4oiRbNlY2ZpTGc3RMv59ZHMjpRVsc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f5CStG6p/Tq9AEaScbWsr7gLEiIFMSjsoeW0EB7nkg5UO9sHcBetty9cQOG8?=
 =?us-ascii?Q?kJ15Za3yle0WYsJUeUiYPcFxwhBG/CfpnJY5gda6YqyuTtJXcxIsoyvI2NBP?=
 =?us-ascii?Q?d6YlRD/2Lig6vk4BWyAF11v1h0XowyfhFSbOjkG3nnF7LHMxkUxuJUdtq/s2?=
 =?us-ascii?Q?M8Gi+xsXmGBc+ZvqmjDUVZIZof4LzMT7IpG1zhrYKy9uPzsgn26zMIs5FdBe?=
 =?us-ascii?Q?4VPrjUY+VEakQ0KIZ3WeG3sJl7nuOSSlQPuAzLYjRyzk2+Q31efpaXy0ksWk?=
 =?us-ascii?Q?Rfk0gvnLTkvsIOzheDC/2d6+kAIVUkPtiNqjdtfeKUZOrqIZlsfmG+HISTRR?=
 =?us-ascii?Q?XNawfZD38z+PFKy9EPYZfNyUpFGoTHSSL3aKqz0uk7bmzKGrjFwAytjRoNg6?=
 =?us-ascii?Q?E/Hnd0cpjleoqW9rkqaHxgp5GiGTI25pbglmyuUWr4d/1RS+vobOPp4sDMe3?=
 =?us-ascii?Q?cqjhc96Ly1czMjAjGfUGFAAWR7J3ueYqccfYosuoS+X9GOqR7EAR9OshhF8m?=
 =?us-ascii?Q?nFuJRUDdO767P8oa5qdjdR4HZZ/QkyNQKtYAc/uRQ2FXnuo1g4XnMTodx+Ox?=
 =?us-ascii?Q?ibNh4XKE6ZfiX3Ziej33tvtDYFgrfCpBTZ0YAbiH446cN7qd5srWTvw01mu/?=
 =?us-ascii?Q?TWcAQCiwngG7x8E+ydDOp9nTECuS3j4amldalS98zvVFnTPZYPqW41++wcno?=
 =?us-ascii?Q?UHzOvtcDWSNz9NFDvHvk6PGRZ64TsSrGsfrYzcMJUVmE4XUaZVnJkht8j9Ui?=
 =?us-ascii?Q?LQGiXidmA5hdM9Kq5h9rGQvNyWKptWVzrUloQmiiYhLdMCupzQV1Z+GJx966?=
 =?us-ascii?Q?cIMC9u8vldbpSu7my0snfOo0vyIvhRFCYUnh5zYF2Cr+CMPXluw2r/zttrEA?=
 =?us-ascii?Q?H68pAeVf2uufDVh6h630Rye45F04aeMxsYsUtMCxTTrm3an5CSWqTmjPESOw?=
 =?us-ascii?Q?m2KPqrwH6EViFQ3Ghulpna98UgByc8jSfRkl1az7DU8LMOJsff+9yY0s8eUl?=
 =?us-ascii?Q?WRKyWCm+y7zec1ISs6vHMjEksCvLgLSQagQHN7iCRWghwm9n1opjLx1v1JMJ?=
 =?us-ascii?Q?4hDHm0vv4V+4hX6M0l47VTpiS5cHbpQIzcAI0s1YJ+yG51DFGYYAV5alzVJq?=
 =?us-ascii?Q?nWaJrZQn+WyfqrCiOqHDtRMxw/zLBypmZkZBTEXaMqK4byKFp+hLFYD6t6+2?=
 =?us-ascii?Q?e64tX+m/XNdVijvWLYRjNubpVrpFzUHy9qFrFdLa6aVCBivx67oh42Phf1kE?=
 =?us-ascii?Q?4ukhfIkgX7XBfsDI04NJPTAq8PJww64TmnMiUYyplxn11Lw8cJFRBOJV9ML8?=
 =?us-ascii?Q?rXZILEPISxXWY7zdixvkgvXke6hZT95vlezgw+MsVIphHyOppEe+lqAlg/Tg?=
 =?us-ascii?Q?YsWGpWf/3ZDUnoC5MhuvGnTdZt2OCJ755aeMmJAhhrBOXIhhH8sdX7nbqAXC?=
 =?us-ascii?Q?u8GrKwsokDjkA5IZa1VLGlULTvCRNU7wk8VXxDGYRzefN5NTrYboNPU1WjVv?=
 =?us-ascii?Q?ZFkR4NUJ0H7YHP+por5Fl9ZY2Fmy2VzaUSkG7gkpJwIxcwe/fR5dmbWgIoTW?=
 =?us-ascii?Q?QBVpvT1cGtRqIqdVsspN5p+0IjmtGF415//BClzYUEIe0trK3RCZSRqOgqqz?=
 =?us-ascii?Q?k5CbRPNcDIIr7yGYrtRwWNMTF9x/KsQ/mWADmxfZOaF+IGYLy9wA9BQQgN0L?=
 =?us-ascii?Q?frmkqlgl/qeF1PdmOA0P8iWjDEE9EJ9/maUc5KRPGMAbL1goGWymrRQQSiQj?=
 =?us-ascii?Q?w637E6DhJap74ZgerKBxooRjSylAa9UeOEGwEQCbdYHnE8Lkwl4k/wtA5kyE?=
X-MS-Exchange-AntiSpam-MessageData-1: 2u+6ebK9zhlLLQLTjaHK7d0aZ20xN25dKMo=
X-Exchange-RoutingPolicyChecked:
	xZk+l/WoaIdJhJFJqc3PwzTmMqha2WQKZIfP3QBpQGtlbfV+4gNsXO3MIXk8AQkhlEIQ3P/1V24ikFwyOu9wdd9xAO/xYPNmO5T7VZmkuZ+BzfZBiDxi2bqV/h1DjY+Y90vhAKf2XuJMH0Ruu9g2K2JzdPMKAdyHaQ/cQPe9U8MfO/VdpBp8yK8CrkNOHknQar+xAnMiXvlnwFWdbAAOQmXIsupQgAjk6kQkvKQ7uY7KDZAl3ZryLhds/xClurssUPn/jDGwQsnr7k6hP6QIcI1l94nsDX5dVjsSCt+Oi6rOU3TZjVxUMYX+fKgDa5gVobBBd/KHoBbwlTCViKlFZw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DjI13bBDjYuOzeTkv1lkiUGQ1jXAWY2UY6xFweUCJV66hOWG4uvyyx6TvZpe3ZnCgNFkAygRZujHjhE5QCVSj1/5nPXjB3RYbZ7HuztLNTnvY3T3R4t9PJcLsI3CdjaxdSW3bHhxFq+oho1xayWbX3VBFErJmXUSpAiOhj4tSy2xWy3E5IaFnlN6QTehNRL5Vj4nxfi+3hUyHotc6fDeH5YIknZURMDHTvPiTn91tyfDSRTEetSrDAwIJ8VOGKl2zZMtej8PMgWyU2o2aIDpqsrnHWH/9ospQiEI7abXmZdsZBqxDnu4U1Oja+stofYmiXbc6fyMr4qJxXzBVUZoHoHTo8kyYuRxu1on8mjaKYxq6HU50xVZiD6xNZoBKhFP+qvFW+xK+wU0ZajPOIikrQGD81SdBR22N1X9KEXGMRAvQbbJ8EIyp22UJRpg07/pox4sTtKxBGj3WxUYDck8EmQW6svPeXJswVMlIwp+Znm+h3XkaWhue9K0gvuE0w7nKCrjem2xDInNWAYx9VyTWOU8Y8iE/IldKJ0vLsKRPdcPbuwGFqAo2FEjNXrY0lRNMVq/HaeDmuyh5zgCIfOal4JzY8wSjsRWbJdaBni6Bn7jrWqjtAEMJQn6CLthA98S
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c5706b6-c290-4bd3-f3d7-08df26c70176
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:07.5546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8bJMWxqXHZ1Bqw137+JlLyYvy/LDNMcgLlqINNASg22GWYurjfYks5R9BilZehrQOHE2gQr0HNk3WjgIeoAihTyE6vnIxmMZNSacXDUGmC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

A block group can be backed by both conventional and sequential zones,
e.g. a DUP chunk straddling the conventional/sequential boundary of a
device or a RAID1 chunk with one stripe on a conventional zone of one
device and the other one on a sequential zone of another device.

On a device with an active zone limit, btrfs_load_zone_info() never
marks a conventional zone as active, as there is no zone condition to
derive it from. If the sequential zone of such a block group is active,
the DUP and RAID1 loaders see an activeness mismatch between the stripes
and call btrfs_zone_activate(). That takes an active zone from the
device's budget for the conventional zone as well, although conventional
zones never consume an active zone resource.

Let the conventional zones of a mixed block group inherit the activeness
of the first present sequential zone.

Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 9f562cc34e38..e184d851240e 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1959,6 +1959,23 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	if (num_sequential > 0)
 		set_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
 
+	if (num_conventional > 0 && num_sequential > 0) {
+		int ref;
+
+		for (ref = 0; ref < map->num_stripes; ref++) {
+			if (zone_info[ref].alloc_offset != WP_CONVENTIONAL &&
+			    zone_info[ref].alloc_offset != WP_MISSING_DEV)
+				break;
+		}
+
+		if (ref < map->num_stripes) {
+			for (i = 0; i < map->num_stripes; i++) {
+				if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
+					assign_bit(i, active, test_bit(ref, active));
+			}
+		}
+	}
+
 	if (num_conventional > 0) {
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
-- 
2.55.0

