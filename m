Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6970C3DDDAC
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979461; cv=fail; b=jWo5C2FcbJF4rAnN6ZzZSX/A1ktqxhJnU5pqBNPhlA7NDPpp+2CblQWWS6P2X9ZpIpywqz2UeDqdmnvSHZwegHjQKQeShrDQGrCXDn8tomtN5uoEt1hhO8QxresV9g+pxrvN8L45k0BEJDO6vAIzmeVi5Arov0e5rYDQei+Em7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979461; c=relaxed/simple;
	bh=PfE4kVDbiB2dazXWxNrZl2d1vSIviKQEh+y7tfRt0+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e48zHjBnt76oGndtLo6+j4/ybZksPRkm/jDTsPXVm4JTnjZymy+iFGLJF0av8LMsuiURePFzNSdBjrogvz1n8NRdShnuiT+Lc/+KQUHQtjy8tREuqHZo3tCAxv5sl4FHB2RQiHKB2YZjnanQHr5I0+P+vQ0XvmtmneI+/QrBJS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nygFlYEP; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=h99u7W7K; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nygFlYEP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="h99u7W7K"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979460; x=1823515460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=PfE4kVDbiB2dazXWxNrZl2d1vSIviKQEh+y7tfRt0+8=;
  b=nygFlYEPbiZUU4cr3FepwWJiSl4Ze3uxlTHg4XXBLNW8iTlfVKCEuDp8
   2xo0tTCMEPzaFQScXe5Zos1FyrcK/6bNQqiDkFNC02GmPsoy3DNGMcntA
   1VTMa1W42XBu0tbX/Aet1eqJeEU0wXawoWAFYi6zkqRaXWnRzNqON1KqR
   hXzUOPx5hMQb9PR0win3P7vrue06iOimnrc5a42AJn0qHNUMCNXVH0PwL
   1d1Kk+13PXLeCtLaTRO6QmcY0gw19GiB4k238LSuDlTEu4mko/X01/JdS
   KlXP/do8HgiVrrN2J17Q+qDJT+4Oz8s/XZoE05aKzdcDTU4iHpYEJZV49
   A==;
X-CSE-ConnectionGUID: aORhAo6rTyydxXS6fJiaLQ==
X-CSE-MsgGUID: tsOy43CLQyuMmpfrJgfZYA==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077263"
Received: from mail-northcentralusazon11013013.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.13])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JVVRER1qUhJq4KBnpCKGGgOuzkRVPX1Ub6tHAojCEg0TILdWD8FvCycjxKTO8f5xWgy5YDvNuiiFBWBTFxt+Pspb2bKRjXXQi4VWEvEM30wM9mNtlfYN5yKu28YF0XqWq10A3iFjMZ9lpsVhjUlPYrRYk3QPCqKhyOQOSE9bflwfZJBbzA0mFHoyTWG0afFn3+0THoumXclJXNiArraDvFtxkn4YNsDHhwyHYZnMp/wspYWgY2eNLCL/R7gj0ddZ5SO7WegmzlIqp4QWqiak/pv5BKhxVCLQH1m4/OmwQ3CPIAEYDvcchEK0mBb13/At45gHunCiotXc8uFGxzCjCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kwpcudp1DopmgExHBZRKaDWKz4PXAjDvwShXPfwIVaM=;
 b=hqGW4DyC7KN+uP325jV3wKqD5unXT+FPUpklDKUDMeKoodQ4Hx1QWUzsz1v0kfGiSbJ5EgVgdxMoc4CJeHXQ4zfvmKLKdYPD4KvtuyOyDfMHxRsP5iy/wF8GxPO+YrC2wiDBVzZyT40mwVJwjKmZKrG3i1ZF25jGH9tOIGTGQDMaebxaQX3IxFSZQDkAgwotWcf41EXalAa/+BczpKMkkIh6SlCu67lQnAKR8FyU4yj2LCViiDTmMWk5PRqPKAsS5ZcmdU5csuDSpJN8e/tI+MVPEMAWm0R31+fTLfImd9PM/8S6vJQH9ZMSj96CFQHGHsw8eKIG3jh99LwTLNSe9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kwpcudp1DopmgExHBZRKaDWKz4PXAjDvwShXPfwIVaM=;
 b=h99u7W7KaRyvpfO/BJovCGMDqsHROQbHlwN/3keSSYmoYOJdBVGtqgQ+6TZOlAkdtBdDHBERYf1mxmJg37czmL7aazKkodYzEGrZGnHda4oF4uoNdv0bzx7NPYoFhN/UsiOXch0QL3LaTtqDrc1ZH+kSGCY1RKSE++HJPH3NS40=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:18 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:17 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 06/13] btrfs: zoned: prepare reserving the data relocation block group at runtime
Date: Wed, 14 Oct 2026 14:03:45 +0200
Message-ID: <20261014120353.757931-7-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: cdc290ec-e4d2-43dd-e42d-08df29eb45fe
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261009223027099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	W3XbDS74dGEgUKIEVPoQWjaH8gRd+XQOYa8WVCAUfx7la4rCHkd7aRB7jDJiqyENJQRHndqnwVByhzevq+4sSbm6+BSZtmaAubdyK4NysxPXml7iuukzE8CSOLHQOyyVJpJURgi818RLacKCCdqIFgSYeNxgiqDvwUyxQHfgQxSBH+JytMwX8nMyexUvvy5sKswUj44Bvdol9gqWJEYY/3WkG6J2OLL71qYogxQclxoruMj3RTci3hen7BHuCEmHD4ZfToj62EKaheQ5IInB5PnF1eO1q6ridqxso+LZTgIWfk7BdTbSVqwiu7RUELwbhwb3H50oFoGPupuL1iPRa6kX3pWPy26mOXiNttVlhBygfhtqZESv8tqJh/kwJgEPu4h7zTpszs8qB/fz1Bzkroktu50nS1we4bAA9N3OjOCYeDd5fYHlacWjWTnrBya9kjSvPhF6+Urr00sVCu34S0I7f1chXPtYdWGA1xcjvPxS+KdBN7Rae/i5PW+wB+BsY/SJhhRdo+Zil7ZZFgtnMrgfljtl5qEq386nRrOE11mDFf+a+1DBJKNMkJku95xOYlEYBYkN1qH/TqJUeR3BXSmlH7kHHhWyrZ1tZAJJJ3w58aOdx1ILmiwArHqKu8DOevDVPd8kEgoXPzdEUlWC4gtqd+CwHhnyL+W81liYGf0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cYUrTbn9KjzK59Mt0bEg6IDd6gnW+G1MWuHUq7pyJU/xo4Du3jUAWtA4v0O+?=
 =?us-ascii?Q?7g/n2bxZdazzsUeIgdNpf/wsL/XqNPNWdvvyeF6BvctkuK/CUHWrkeQ60DoA?=
 =?us-ascii?Q?cUNnoWoAMg12tGWp9ZFKjglRF/iiAV0cR06tZLFQmhxwGPsfRwfY7cjHXW4L?=
 =?us-ascii?Q?6BuEs3UOmihTg1Sn2eI1g2h5U+SzKocyrY2TYsAIc2w/unsJsfRteCDreX8R?=
 =?us-ascii?Q?r4py6qXeB7p0dh97wn4F+6drHR9nR71JP1Pjfiq6P2TeyHStPoJ2/fZPYMe9?=
 =?us-ascii?Q?IfAOxHDT1K6eJp6zbACGbTo8R+60cJGYIvFOaymxIMTP0jaLCD5K8hht1cyZ?=
 =?us-ascii?Q?e8og74hyp7ps2Oxy4d1nkj7Rh5OihFRG9n3QF9OT2OuYO96fsQKBY633ZoO+?=
 =?us-ascii?Q?XU6m64YrZEDZPmnw3oNb5qFQKLKCf6jkrwmIQsdamOo+lNCNf9kGSlh8i3DH?=
 =?us-ascii?Q?3rYAg53lW+pv5YnCuzmT2Y+3Ch3vQsXc9gbOVRC9O25daPX3pj22W5ufUMIi?=
 =?us-ascii?Q?oUZf2USKGfwAM0w8pMQ2HDh0caZFOeFPfWzSY9e6Qqv0Vze6LHomcOEN9kAC?=
 =?us-ascii?Q?+xYVm3VzAqvpw1brMToj0Hok2An3rZ19E+vMJod9APJ4Gi32qlcClldwxONM?=
 =?us-ascii?Q?kavcXJs6+A+Vms2TmtN3adGT9/aLitlXB57C4d8d52c/G2o+gyUjwIpHqKoc?=
 =?us-ascii?Q?425Lid54E3H3nU8nOiVxcHmOOBxkbIRtEg1At3aUWFLqr3ILouRbxMNZ4YjS?=
 =?us-ascii?Q?g5m6DvPgVH5yJOjwfCD+2/BTw4PY3GDeNYkcb3MauJ+yPmBaMfM9AJAZaolv?=
 =?us-ascii?Q?PKC3MX1yHyykRQ+AvMzyEUEM7WqcDDzW2fT6QYQcroNjTaQepNMNg0UaZguP?=
 =?us-ascii?Q?X73/m90b18i66dvjxi8DyP4T7ArUmsJaoQ/s63UemiWOldFZlQq8IffXIkNz?=
 =?us-ascii?Q?4Q2oB4EOjfg8bka4yFNbhjinT81tE0NhmJc7aVhqKy9yXcM6AgqauYajxg5h?=
 =?us-ascii?Q?UClGJRqmOygCI/Byo1DTujVJCHc3DVbUEVx92EOWdZC8RK+9N4CELY7YFcAR?=
 =?us-ascii?Q?/I39uKZdYf1rIy+qT3WwmYLmQL9anz4QbAdmqhRY9VVs1VGkf2EJ9BOl9Mif?=
 =?us-ascii?Q?/JZQsCV/T/pDuc8MkxU9CZk0NKrqcWC16uOcEq0FTPLe1ohfAdHHm9J9GzeH?=
 =?us-ascii?Q?KniQD4LV7cMFzI37ghRyp/em/OvOs9r/arN6hs5j3U1aqEtcYDkUqMMA1Jcr?=
 =?us-ascii?Q?w5YU1MLFxp++2MjStYKRfmUkjeYkyYvWMSBhxeIJl3Ad+BImDSfKNaLaDKE6?=
 =?us-ascii?Q?QNYFSxlGoHfz8rDOj9ZpxVlfbFJ+q+gYifzTygmsdps/epbOzKbutOsEfYN5?=
 =?us-ascii?Q?+fxcDh9X+jC0xGEOByPioaXYCT3G+fQ/+bv7H1LmZTubrxYf0KoIEENZpD/7?=
 =?us-ascii?Q?MOJwsFtmupno9iXQVvAHT2FI7lOxqD/SK2y7SWALnPyGoZ12Hi9Y5D8MqYck?=
 =?us-ascii?Q?j+qSR0tH0dSAchV3ZviPCxmfRQcYrFSFsxdH47y9x1gIWs3L+cu1jM5yRjGM?=
 =?us-ascii?Q?YuIH2/ov97iceXZNJ/wmO3LLKb9CJCY4TWXpAcoDRBDs5s6t7vpgdqzkPbFa?=
 =?us-ascii?Q?9HfW5Trt/zNOp1cg/ugAo+k3yWI+b/gEmUvI4dYGs+H6SQFUTX2DGYSyny0d?=
 =?us-ascii?Q?EKw+wXX7NRiQDAjbj9ROL4TGnb4pHl44K3NS2gJlSAnGV+cpgiihSFLwqMLu?=
 =?us-ascii?Q?u2Ws3D3r+I9r7iHuMow1TOoBrzlclgpbsPfjPblbuvQ9U/VoJ6QNb5Pmy+Cb?=
X-MS-Exchange-AntiSpam-MessageData-1: E86pWy6jfDEYqYEkMls58O/Va7RWKer3E+I=
X-Exchange-RoutingPolicyChecked:
	yS/Rt7spY1Bb7/dvM0X07SLHurq0Kf3/UbqE+ODTIzLcsVDUUTrlmUzazk8PATxeduPhQEPkXp4BsIf17tbO4qu3lauXLWyVw4pRN6ygrLo5ocRv/fJVlbjNeHl5FsA8r92wU3TM2IEDPpIzz8cdez6/DYBUvYFuA2FSImS/V9PedNwBdg/8OLhNaLl4kAdmr6gT0u7ADCmVwVuYH839SsHMxcZsnCxeRV1QwTwWozhLuHbgjQZf+4nvXAwYhESAey1nWCKT69i6YwyEkdujpjro0skLmYTO9ZhjPS/xxS7wi9Ko6USGfQoXnWQziR/YuxeCTTvD7Dl56AvhwahInA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YSvVhvbfPUxLNdKtiJ5rX5qMgoG8+4qeHVQlf4McCd2k1gYkZIVfFyFsOtOz2hL3yate2t2DslpX0Zca2ggIqjPFEvkSclJ3NruZFb34uFNn8oXBq2fKYVzXMkm3AjJBXr8z3ER8WL9BbYz3EdaSi74gQU0lWU2SqW3Jj6vIZTbYVDX+RTZ+igTGVkRuJkrNIcUzC/5fcLKvDjyZN5STLgdTZCMGGRIwRA9Xstcm7G0jBTrvpQ3/20etHI2jU3YT5DXA807nL/U9voFr5I0jaRXM2uK3POFohaRYdjyXDc7ym74pp+w13XsRtl9mszCHWCIKxSBlXQbCpavXwIlte7o+HFIlYSGoAQHJ5xuUI74nvkOE2LH2Pz9EuhlGOnkVcR8mCTS36RbQctIHWVg2QRKsamLhMgUgSRoNS0PNrIZtNC1n/lxbeYJCEx7e6wIVxbSADq7eLfa+7jLzP82ldCArDeJ6I6Sq3iy3q6uHv5+f/lT4Z03o3JjbnGR0IbahQ6XuFplBRQfWxCMfzUzsVgvk0Qaw6KfwSM1r7KfjPQAjZL2mNKo+rITD1QA6cpEpcboPynrfqeUFWP+atI2NDTLUg4djnlIz/vst7bVlJPpAGN+weAmqROS1Xvo2JTce
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc290ec-e4d2-43dd-e42d-08df29eb45fe
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:17.9190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yez+AW5Qkjl57iEBQGF1NGinxnWmiTFA3+u1F4lEixw+P1DjgA04CeZRwK1t8tQTPdXD8aocicuY2JbQhyL2iB966D5zkZirfA4Hopo1mHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

btrfs_zoned_reserve_data_reloc_bg() is only called at mount time, so it
walks the data space_info's block group list without locking and does not
expect the candidate block group to change underneath it.

Prepare it for being called at runtime, concurrently with allocations:
walk the block group list under groups_sem, pin the candidate with a
reference and recheck that it is still empty under the write lock before
moving it to the data relocation sub space_info.

Factor out setting the data relocation block group into
btrfs_set_data_reloc_bg() and transfer the complete accounting of the
block group, including its zone_unusable bytes, to the data relocation
sub space_info.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 133 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 96 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 5a431dc929b0..cf3a7f675e53 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2906,6 +2906,75 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+static void zoned_move_bg_to_space_info(struct btrfs_fs_info *fs_info,
+					struct btrfs_block_group *bg,
+					struct btrfs_space_info *to)
+{
+	struct btrfs_space_info *from = bg->space_info;
+	int factor = btrfs_bg_type_to_factor(bg->flags);
+	int index = btrfs_bg_flags_to_raid_index(bg->flags);
+
+	spin_lock(&from->lock);
+	from->total_bytes -= bg->length;
+	from->disk_total -= bg->length * factor;
+	from->bytes_used -= bg->used;
+	from->disk_used -= bg->used * factor;
+	from->bytes_readonly -= bg->bytes_super;
+	btrfs_space_info_update_bytes_zone_unusable(from, -(s64)bg->zone_unusable);
+	spin_unlock(&from->lock);
+
+	bg->space_info = to;
+	if (!to->block_group_kobjs[index])
+		btrfs_sysfs_add_block_group_type(bg);
+
+	btrfs_add_bg_to_space_info(fs_info, bg);
+}
+
+static bool btrfs_set_data_reloc_bg(struct btrfs_fs_info *fs_info,
+				    struct btrfs_block_group *bg)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	const bool migrate = (bg->space_info == data_sinfo);
+
+	if (migrate) {
+		bool still_empty;
+
+		ASSERT(data_sinfo->sub_group[0]->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC,
+		       "subgroup_id=%d", data_sinfo->sub_group[0]->subgroup_id);
+
+		/*
+		 * Recheck under the write lock: an allocation may have started
+		 * using this block group after the caller found it empty.
+		 */
+		down_write(&data_sinfo->groups_sem);
+		spin_lock(&bg->lock);
+		still_empty = (bg->alloc_offset == 0 && bg->used == 0 &&
+			       bg->reserved == 0 && !bg->ro &&
+			       bg->space_info == data_sinfo);
+		if (still_empty)
+			list_del_init(&bg->list);
+		spin_unlock(&bg->lock);
+		up_write(&data_sinfo->groups_sem);
+
+		if (!still_empty)
+			return false;
+
+		ASSERT(bg->bytes_super == 0, "bg->bytes_super=%llu", bg->bytes_super);
+	}
+
+	spin_lock(&fs_info->relocation_bg_lock);
+	fs_info->data_reloc_bg = bg->start;
+	spin_unlock(&fs_info->relocation_bg_lock);
+	set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
+
+	if (migrate)
+		zoned_move_bg_to_space_info(fs_info, bg, data_sinfo->sub_group[0]);
+
+	btrfs_zone_activate(bg);
+
+	return true;
+}
+
 static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -2977,7 +3046,7 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
 	struct btrfs_space_info *space_info = data_sinfo;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_block_group *bg;
+	struct btrfs_block_group *bg, *tmp;
 	struct list_head *bg_list;
 	u64 alloc_flags;
 	bool did_chunk_alloc = false;
@@ -2997,46 +3066,36 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	index = btrfs_bg_flags_to_raid_index(alloc_flags);
 
 again:
+	/*
+	 * Find a completely empty block group. Unlike at mount time, this can
+	 * now run concurrently with allocations, so iterate under groups_sem
+	 * and pin a candidate with a reference before dropping the lock and
+	 * operating on it.
+	 */
+	bg = NULL;
 	bg_list = &space_info->block_groups[index];
-	list_for_each_entry(bg, bg_list, list) {
-
-		if (bg->alloc_offset != 0)
+	down_read(&space_info->groups_sem);
+	list_for_each_entry(tmp, bg_list, list) {
+		bool usable;
+
+		spin_lock(&tmp->lock);
+		usable = (tmp->alloc_offset == 0 && tmp->used == 0 &&
+			  tmp->reserved == 0 && !tmp->ro);
+		spin_unlock(&tmp->lock);
+		if (!usable)
 			continue;
+		bg = tmp;
+		btrfs_get_block_group(bg);
+		break;
+	}
+	up_read(&space_info->groups_sem);
 
-		if (space_info == data_sinfo) {
-			/* Migrate the block group to the data relocation space_info. */
-			struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
-			int factor;
-
-			ASSERT(reloc_sinfo->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC,
-			       "reloc_sinfo->subgroup_id=%d", reloc_sinfo->subgroup_id);
-			factor = btrfs_bg_type_to_factor(bg->flags);
-
-			down_write(&space_info->groups_sem);
-			list_del_init(&bg->list);
-			up_write(&space_info->groups_sem);
-
-			spin_lock(&space_info->lock);
-			space_info->total_bytes -= bg->length;
-			space_info->disk_total -= bg->length * factor;
-			space_info->disk_total -= bg->zone_unusable;
-			/* There is no allocation ever happened. */
-			ASSERT(bg->used == 0, "bg->used=%llu", bg->used);
-			/* No super block in a block group on the zoned setup. */
-			ASSERT(bg->bytes_super == 0, "bg->bytes_super=%llu", bg->bytes_super);
-			spin_unlock(&space_info->lock);
-
-			bg->space_info = reloc_sinfo;
-			if (reloc_sinfo->block_group_kobjs[index] == NULL)
-				btrfs_sysfs_add_block_group_type(bg);
-
-			btrfs_add_bg_to_space_info(fs_info, bg);
-		}
-
-		fs_info->data_reloc_bg = bg->start;
-		set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
-		btrfs_zone_activate(bg);
+	if (bg) {
+		bool set = btrfs_set_data_reloc_bg(fs_info, bg);
 
+		btrfs_put_block_group(bg);
+		if (!set)
+			goto again;
 		return;
 	}
 
-- 
2.55.0

