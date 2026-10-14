Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F3538D41F
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979459; cv=fail; b=IPfXLx0rGxW9LZOewWLAh9WZL3l01Qs4hTMgKkyaXaIC1Yxugx9EfMiVctRb2TnfcKKRnd9OZcGSSZWD5+9al6wppJBZvgvnrvHg4EZ15hKY3I8tFK3RMi8/FA50uEeedKbpOXZ8kHBV0MaQwewd0nZ3MCA4Ef3f5xf8B/IhM6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979459; c=relaxed/simple;
	bh=4TsZ6IAEHx8KeCR9qDcoaP5ZDM+JBZxF0CC7XPFHbHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WYKQ9JwJ24n7pCGaEuxVzS3X05cSdmmeq8fCQxCjhWDhE52jXGvhcwaR8o/iB3NCASqmmMkOpt5xUMHfFPZOTKjtRANPzvmmYu3RshnuohjOoj0R47kYFPflClNV6+RLjLsIP75D12pNnq3E5dzJzvHqsENN2FpeBmw7ioycKGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MRd7Akkk; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ZGxyAroT; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MRd7Akkk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZGxyAroT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979456; x=1823515456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=4TsZ6IAEHx8KeCR9qDcoaP5ZDM+JBZxF0CC7XPFHbHg=;
  b=MRd7AkkkVNm4mIjHjsan75YZiPpxy1vqvour9lzMXOikvXDh+DdQzHAA
   wjSr2P82GWKsndMQHyLqoa60Oj3SAW13WaeXuC5GLp/rElYSqxqEATIhG
   qsvS3LWSGyiLVnLO7/j83jqwH2+fUAzOtsSlXH+xblZQKc6EPTDdUZ5Mq
   l4pFLcTwr7PpdVwhTb+4KglQHCPc+1eFcSZ6Mp3FfiqOHZpdAziINEuxQ
   lOGzGfIa3bYiHtYzmkOVTIN6kDKKVtKRC1Y4P5Lp8H+gzrCOwGRUrEus3
   47GcM7/NZxQbN+5DzCIvFQG2gn6pSuR7HFpZbgFizmTV2nwhBTJ9TG2lx
   g==;
X-CSE-ConnectionGUID: HOF1xK4zQUC+569K+fGr8Q==
X-CSE-MsgGUID: I8xh8uJ1TuurkUjKSgxn3A==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077245"
Received: from mail-northcentralusazon11012067.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xbh+B/8Odx7xC49i7Jt4Bg0yXYqNH4GwKiTwxsP2/rEdG5OI84TkqlXlKniRQKDCIuk/16gyla8D5bOtUR3Hyqe9pB0AoJZC9zgWZ3KgYtXeb6Vj+l9CgDFUcMUaR/9GBbaISOW3Yyz3IBNwSP8zeqi/rCWRoDubaLirRIPiZfj38QnK5mvg7kxKaMbxZw5kkaiXd/lK3LYpH3ZdMa8Co/ON599TpSPBjEoL0KPTH9fvfzKr2rETwBlj/tF1Xk5eQmdM6O44RVfbW9mKJDR1bghz5xk6Pu0dRTy/oWrT4QKzUQ1dBB5fqLYoI7lecSLh1wfmzC8vFm9CvHdg8LR/1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDRrim61NqaI/NmyS+j6hPzhyCbkPz+yhaoF/JE5od4=;
 b=hERPt4+KJPLPzDkyQvzdmsIvknOepsAKIlNFH1pJ5CUAW1CHD7qXTT88Fzjat4GQ0otSUwp4GArjdrsRwxFRa1yCsQfaiDJ+rjIjwqWzmoOtUCuiaXVi+Oi0EoajM/zLDtstqKpfNl2mcldo5wyTfgCPJrLof81HROkzjMHqixsH39MqeVJHokyLviQxkq8UOTKf+05ro7Yv9K8yTGTmWBVP84FAkeHxhY0YY0sjP7lbeDNVXxRJocAkLYIb7SoESqeWPFZR8LNPF+tGOq76WoGG4V1PtyHw4hHU4GVtkWaRMuV/skPuwb73WFbqeslH3vQiEdPDCQaAa32k4NTQXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDRrim61NqaI/NmyS+j6hPzhyCbkPz+yhaoF/JE5od4=;
 b=ZGxyAroTtIcZ2EvEOVI2tLm5JM/TBUoIyQnsRrE8Wa9gSAmHdM6IkNKMBPUjmk7mS/N5ANPfMiHhMlVaSNmOPDPMR2Xv4j+gwQuDQn+Rlufv7q7/cdJLAEp9CIDjb6QnhV+96ZHVPuMEHgjrIpB08/hcVGYGmfI23Yq0/YNA2VY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:13 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:12 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 02/13] btrfs: zoned: don't count in-flight data as available in statfs
Date: Wed, 14 Oct 2026 14:03:41 +0200
Message-ID: <20261014120353.757931-3-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 488ea9b7-6c64-4deb-f28f-08df29eb42a2
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	RdI1hFQU+5SWWtCyuVGr6dd4+jc1U8xKNmL9HfZsVU2g+o9x2MqDZCamwEdHQemzHiurjiV4cw57HTiyEWnsasUQGTToU7qchrJRB2DGXnmUP4FnCb03vqFO7iN/q0INKrN/M156QQdwLis0Vs8gFArIMsKn2bmTmDimTTFaGTHtun/LYp6E2tn6oNgBWDqQftXYAwTr6lMtAuPxLRiDPPSyvVuOqrkMk9cqJ5L3FOwsjh/v30X48oqDwH5PNY5uha0SvF63uNBylvL/mmtabPnnzLPeDZEf4+kBhfl/Vc6evzMx+A29Rpuej9UsdqiQ87hZqrDzfsa+EcFa+c/1L3G52dU/jN/IP+xukhNkKfs070CEAHaPJ9IPLWs8ZgP1+aZQ1at23dvvZU7RfqoWXuE7mOhe8znnoosIR3QQ6AVDHLGoUvZp1uSvRdZyIxXdFLbUq+xvYnMfXTw3ObWtK1oB0j4QkdtWTcu7qogojl+nZCg2OavUqj+CgBaDLnrPTHCRvRhK17H6csJCeQE11h0gL0zV6BPxfSFpsZFf8zyRj2hZL0KgLR4c7zQqrHLG/HSztucb2rl8YHKOmumnxzlowD7UdDiTuklo5GSQ9nB3fy/+jQUwl3IVnXSatS+mpRbKKGVjJU8aF/4PsV/JzWVIQ7t35lF7+YYeOZPrtGQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Nk13QWg4rEPcKVjzcltWgF8ERV8+SOoXK09lrS5m8yom7hWIZSv0Xbl7gs3s?=
 =?us-ascii?Q?iDv0ln/UJy1dQKPy9mfSIRgrg4tw1hhT23V3F2zwL8+8e2Gw7TRgi9/i/p4u?=
 =?us-ascii?Q?IxoMpRw8L2rN+gBfZrxtTW7sONOfA2DoorTetSLULLA4dTU2bHL25lhvP8uQ?=
 =?us-ascii?Q?2umuYPQyM6ibJFiwiDS6zsvQkDpZIt86iOB82Lam3Kw+aTDJ6nyWI963Tmsc?=
 =?us-ascii?Q?Yd5WYa6hoAzHbkockIiZkTOJbCUpXlS2R7JKio7G1xIBj522FSrpHRLZVGgz?=
 =?us-ascii?Q?vVare79IM0a/cSW3Ov7OzszW3QMXc/Um28u0k50zPoe9hHBRizpuq6NA2Cb5?=
 =?us-ascii?Q?97Dgr1Qr1ilMPbbcaTpIKfqu+YiyC56dLI4iTzSF2KWusu5kKMtr7wpiOPJO?=
 =?us-ascii?Q?bGU5FPHdcJbuHIhgecvfYZyfBvX9QM4n+CR0towqZkEJpMJHKvb0IQgCEecR?=
 =?us-ascii?Q?F9ktjcLv7Sbw+QBAa56X4dCi8WvKzJNuOmNqHOTaToNTiiYgBQOXIgT9RtqQ?=
 =?us-ascii?Q?lJUbY0z2QPiUN9yaGpcUbNuHg4AYzWp+ZIZj9vrya5a3rEJj7frQ+WtUTLoi?=
 =?us-ascii?Q?WDuTgZnx9kmXrRJeSEBGtYOO1pcrT5yEuoAlZ8QfkKPdToCpYEujCArE83g+?=
 =?us-ascii?Q?WhrbjCxfD/erM5YYy79D/MfluT+gIRBIUoZcejNG9T7OpZ6O7oRLTYyP6H1U?=
 =?us-ascii?Q?NYHCIWLTY2bWkbFofPXEVbXj13Rr/4LLnf2huJb/I0n3tV/b51jjQE14BOkn?=
 =?us-ascii?Q?GkFjx3nNgl3nEp2I41OeJa/vgcS2nCd4GuwdWlS5NXyo9CkOk+9px8M4mt40?=
 =?us-ascii?Q?0ZwJv93QnM9r1DNNbfYMvkqcSP/+LerNPfoiZoaYQCRuTvmGtSctO2Qr1SJb?=
 =?us-ascii?Q?0mUSEQfbTo5QhSTQIyQbPilr94NBFrxMn6p5iQ3B+u81C9tAMOZuub/txIFR?=
 =?us-ascii?Q?yklJWUYdUF8REMEbd+uU8s2VZnxbKa0oZewmsLHqtvTCBidfxDoWkHGYCx4B?=
 =?us-ascii?Q?LImqM16oMrMucIPVBt2nqdvaP8EwKfCifxS4CNUQY+I9vAmFJEbdN0LDZUmy?=
 =?us-ascii?Q?gacgvODVghbDWOf9jdPkmm+R+92iSg1yN6+WPxZdUV4ht/5BfYIRkWZoFU4v?=
 =?us-ascii?Q?yd8i3qXSeSmAoW0Pc/6wWDEFEksvXPK8uU+Ab/NZ7X3GorXxK0WF4eNhBifb?=
 =?us-ascii?Q?a63F4L3EhP+NOiHohObqHWyv90YmH8tP/shJXxVpa1tckJou33m9eJjwlGLv?=
 =?us-ascii?Q?2kmnzOaTl9o587syGJ2qnpL6mZ3PIM7vpYZlvS40yIVNlFthyb5KJI2Ks+l2?=
 =?us-ascii?Q?5OKsEbHlsZORgyazi9itLEZJDX3N9OIe3W3UHw223TTieI7fFZ9IkwsykMw9?=
 =?us-ascii?Q?MUyvkTWuE6FDUgfbAw1Iw7ZXe+kzPinjf8GqDyYv0MuUEQWEwZwf2dlzmC0q?=
 =?us-ascii?Q?4WPfTJW+Xkyu4/hWB2AMdt4JH32cddNhc4THoNxx8IYgYkgV5ZhiFNEuU5IY?=
 =?us-ascii?Q?D6gyQc4X9VDlAZ7qnGBRsDD5E+ujo1XMc7BzUmCFF7tTcQLMYxTicToFKD4M?=
 =?us-ascii?Q?zI6wo+Ef5H//I8GQOdad2J24K2rHZmYx0D8lQERRYA6dHDbXRT4Dt7PmuCLh?=
 =?us-ascii?Q?8FuaEuXWP5JgHh5+kUPg/rpvIDO9o2Ci8Cn87M4S1s71wM5SaUT/m1WMMI3n?=
 =?us-ascii?Q?MVGbUZwJXev1gghDrGQwj9ezfEDXX8DgglB7R8jk4x02AoewbIXfejEAKZe8?=
 =?us-ascii?Q?2yWa7J9X7qrWfAxxmeA5urDcjqJ8RGGJh9VjRFQUQ35UJQTZA9pJWLT8O4A6?=
X-MS-Exchange-AntiSpam-MessageData-1: QVQ9QiVzI+t6Lahm13seqSB37A/Mji/mlJ8=
X-Exchange-RoutingPolicyChecked:
	dPU/WvGczOUJwOAKlVcjHJ6p4Qd4YGRrlidfKwWwBPfA1f8Getwv59IA/CRVaKhJvVzdi2gc+oNtkFf+C8FIY1f09VHrDO21f07A4Rc+kCaTlfTiNvsRLD21wfw5ch2UpDLxKsWwT2BS/S7lgbxa1o/iB6xJ+lU6V67oM4PHr9d+wzLMO3f0xasosz0UH0bpFLHnD1sABf+FHsYtEmtFOelhADAmTTf+99oYQ15ivjrnYzWaN45kyQyqIsAr+0p7n8NnbbjoQAkopo4ZzQgYYLyToKBz3FYXNQBBVouRSB4DEGFHzGh6LxNmoHpWCxfUZyxuBGDAimeXfXRQXGcacg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hNXK/doRSseC6o2zptOgutBdCEoC+C+Em6YkJpMj3a92HZpZbQPEV9QeeOP62uf7bb6OjknEGvGyxsgSK6CfpJgruD6D+pUNxPvd9tBA3OUFy7vGhmzJ5V86rtF/ElKQV7gt3xiq7Om6ZldqOgo65IO2MEfNQdlo/ONp48w6yfL7rdb/aanTgCh9Way6LJSSX2NUbaX1VE6Z6OurKkG/W9JqTI3zVW1yOw9Nf4tpN2fLBmlVGvwBYZkaVEQWkuW6e2yibrIJvXtzgZ5+d/hatJRHlUZZzSWhPZw38KanJYUY2gRCbR7xrmUg+lKm1N2jF63gJKJTZNz495En4pXoNXsVqzL9F7PscJs7QaTn8HiCQflYE2z32y/ECTuec1dyT/ew3wS/hO/OjfRQoVgiUiLFsf/YuJreoUwnEfQJJhgGjp2WOds0OJBBjkMpEg3fb8E208eEYQjFCi+5/l3hbLkJ/6a5oZ1k/Di6dWu/458ZIoJFedA016lUEzJk6zQv4d+8Jqz27vYTdYai0JUFMASNFnDbFg5rErR0rduWyUrpwpnD+E5VS+rSCzlN1UWM8nrdkD3oWQ3xz+QeXqmm70dqOJ0/Dy4OHbLvh0pdS770qNInwHcrcIPcVuprrYof
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 488ea9b7-6c64-4deb-f28f-08df29eb42a2
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:12.2764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nvffNc/n9Uw09q2Nh/DUahC4rujdq9A/fU5Gm6iUJDipbwnKThthmNGO04uZqqNzNEharPssKe6zV9deYEPgbtoOorgDARZxmHLfNn10poA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

On a zoned filesystem GC makes freed space usable again only at zone
granularity and after the in-flight writes landed.

Don't promise space that is already reserved by delalloc or for extents
being written to the user in statfs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7fabb775d4e3..cbc1662abbff 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1727,6 +1727,20 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static u64 btrfs_zoned_calc_inflight(struct btrfs_space_info *space_info)
+{
+	u64 profile = btrfs_data_alloc_profile(space_info->fs_info);
+	u64 inflight;
+
+	spin_lock(&space_info->lock);
+	inflight = space_info->bytes_may_use + space_info->bytes_reserved;
+	spin_unlock(&space_info->lock);
+
+	inflight *= btrfs_bg_type_to_factor(profile);
+
+	return inflight;
+}
+
 /*
  * Calculate numbers for 'df', pessimistic in case of mixed raid profiles.
  *
@@ -1766,6 +1780,12 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 			total_free_data -=
 				btrfs_account_ro_block_groups_free_space(found);
 
+			if (btrfs_is_zoned(fs_info)) {
+				u64 inflight = btrfs_zoned_calc_inflight(found);
+
+				total_free_data -= min(total_free_data, inflight);
+			}
+
 			for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
 				if (!list_empty(&found->block_groups[i]))
 					factor = btrfs_bg_type_to_factor(
-- 
2.55.0

