Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF73472795
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 15:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784822091; cv=fail; b=ubFYUg8E34Y1pZv3pIvnYZB9r/pX0ZRUmi0l8DvsMtdhv9WPCnREpT4CBxMXZ1X62L1UisoItOm8KFh8nFSjSYJgLDfRwIZTiL4ZVeGN21pxXJrmCqlBWc2lT1sJLdcOt2zVnSG0e6C2UPDEUFKyeT2P67d358o7q2nB71xfBck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784822091; c=relaxed/simple;
	bh=WktjGckFkeLsmwc/pTDA0w2NlK8w7ryBoTGzlG+Eu4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CpUNuu5CNbNHijbhfd+/Bwm1FpJNGDPFOTUqYXgokA5sg+IZVKvB/GYw8ajOToqEI6dByFHqNM77BAEasvUOJk9eQHIo13hIM5WuZTiz8kre1IIRl58RKPxawcoXgLI/ZAo5IlOEAX8Ajb1UxyqVVw6vSqMxX2xLfqR1BwnO2xA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=CCJAlxDu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=m5W53GM5; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CCJAlxDu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="m5W53GM5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784822090; x=1816358090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=WktjGckFkeLsmwc/pTDA0w2NlK8w7ryBoTGzlG+Eu4Y=;
  b=CCJAlxDuJsVI2n0OwdWCKEI9JTteBfom/YBpAo3O/4gKeDsI/mfJUib+
   JkiOO1yexUg3JbF78J2a5eROEP3htzbmz7fclk6fFVwtf5m0hZ+VkP/8s
   M29MqEKiqjkEs7p8ygrwxRAs9RB2VcQL2Y9xUF6rC6I+BOHlHWXrdTSPa
   NdWzmptA4gjP6mgUpD0dHiSZkREk9/XDwGaMeOImBb4RMA5bRl/DSjpoi
   zVMWcA6rz82mP97Sq8OftN7t5cjNR4jwcsQE/d5Ca5TU5iV3Hf/VQeBdK
   ldHIg5X4FSIix0BzQeD0dZsvdTfLoskGfDn0OdL7a1eGTiZjmfYTjMLXa
   Q==;
X-CSE-ConnectionGUID: +LsHZQi6T3q9ESF9yvWk5w==
X-CSE-MsgGUID: LpF78qdsSPukSoYFnRGkMg==
X-IronPort-AV: E=Sophos;i="6.25,180,1779120000"; 
   d="scan'208";a="150693713"
Received: from mail-eastusazon11012053.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jul 2026 23:54:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=reEs1w63iHP8ITwOg9Vs9AEGm3qbEB628T55pjNJhx6HjCf9dT9aIrEOB1AgB/3Pafb0kgheGT+YeJ4MgA77GA2xr4/RiOY2G0q0T7OzEFVLEgMD6cmAvhnGhtkZDWV3n0sOigOQ8WpvHHPR2edfsQeCH7m17rYGlnwj5B3s1jRiPzvYFqz5oFpyJm/ob54XCkz985dPE7pwrpCHLirra2011Bku1SYoNaKv9HJdo4oWJ2wlZ3lY3TD6tPRXb6pKbtOXVAr79OAF7A79QLlwgSJ86b0k4CqYO3Pp8s8/5qfS90z7mfUOrYttz0rnG/R+6inYIcMk2kA7om+ADZzzKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GqWLoQiRAuvur9FUCakpTwxrfQJPtkED3w15S5nMpnc=;
 b=s9PCStLqzB5bxzNLZMLJWmpKpI00JLXE0HVLn2qk3VXHZgJIUFWMUwb6oA3x8P3LRGQPr5SSZxlAOHtAMIqOxG+2lnDodRhhjF/MzmLwDnTe+YrreRMSueIRXEMbsECUm9vtIlGPgL8Ikoz+FF/K8k7eWdqmEsxq5YFP609DzHm+UgS73NL2YHNMxjFjSAf4XR+Yjw0bcLKsImP29ZSOC+s83Tro3YrY3SvOOBxurY0IPzxPY5oOHIboZTkD2/x6x4GPPsDl1xsehcYLYK3Gln1XrvOGK+PA0iGvQcqG+oxtvGwrfwA4VvW1FJ1uWvOjtUqQR7p7SiVMaQ4s+0PZvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqWLoQiRAuvur9FUCakpTwxrfQJPtkED3w15S5nMpnc=;
 b=m5W53GM5vHnXwmJ5aaFw2iqvOQz11P5iCHQZRXZ3+segiyah049qhWZD4BklQcYhbvAfnTxW7RP5yOQPDOsmJsqOt1t+Nn2xtoU6Aluno5oSHnMRDqMC0sx1tfq2JdPWzIE+pNtkuiH7TlQ4V/ILbktIjCq6foWBo4uQfBwXhEY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV8PR04MB9295.namprd04.prod.outlook.com (2603:10b6:408:25b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 15:54:46 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 15:54:46 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 3/4] btrfs: zoned: drop stranded dirty metadata buffers at unmount
Date: Thu, 23 Jul 2026 17:54:27 +0200
Message-ID: <20260723155428.94187-4-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: d92da4b1-d7ed-46db-7530-08dee8d2b860
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|19092799006|376014|10070799003|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 snx0ZmvdS0XFsJALZ5dUb5vXMM8CAvXXeJR3e1KwBUJGxtRhJ9c1a9a0yuWN97h9ehAUAjfFG/qVMXqvueVXYC1A0drL1owuvX2+R40adgu6CguZXztnVEC2tZw6K04cl8cZZ7TCJvvqvyTzc+uDEpHj8z6LLhfbv/oHYrGpTYLPYxFzjt6MOLZNgb8duVk8KHRYk5Xd1XfM73RbtDbKlLJj7hi2BGDlMRbJy5j3Kj/0jNnst2zeQOdWVm4HhoYuEv9O4EEg5RN7q04S8WXPAiA2HPyD40W7ugfG9cap13VvPrB1BLneJOcTVQmvA8DzfS39LZE2J2RrPBSTB1vCuSXKNb7s1iU1RwDz7PIsaecwqD79ASgj0r1z/CSn58LDa2GoTpt1+ifTEDXzDQ9siv8uOg0/at1Huqe52DxllgUgTCuEP2iIo+MZvbmHFqyL5Rx04Jzzm5Y3KmkIq1hCk4wX7UkJyn4TQE6wq3znecxXWn9h9youL3d7jhmF1ql/uyfys6oLksIdUlBEbpt93kvy0WvVHhOm5myk4eMFWSMqennI2+pMWkbmXCTsY2u6QmTiK2o6GinfWYj491QryCKVn//v2JHqb9VXrDDcVEyX/U3XMKS4/1EOyjZNGIV9nrHrjb+AUUIAQATrxJHBMdxdLli7/PU0NOe8D5ufdYg=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(19092799006)(376014)(10070799003)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?dYJZ1+PWo3v5mhLGkTInIxreHk//h8HTb4M+VR88lfvQqRtCpQRIvYLTCSLG?=
 =?us-ascii?Q?C8XfzMKe70pTDq1BUID6BbwE4+86jVKK8i4o2zWNLICSMDeMdoDsI/sUyt9f?=
 =?us-ascii?Q?tH1v89D6ywCQJCCBNQ1sDvRCklhHxz+QJEy4rfrVq3v+GnEuE0+Ta7qCieCT?=
 =?us-ascii?Q?9SCeoJWfoa0KdA+HxGUEDf2m/+l+P2Cu3iuS1N7JxnnsTQ2lBOpbSSA9cZG0?=
 =?us-ascii?Q?unKhykCRN4MeoSkap2TGywFT50y7iaD1KiaeukXjsO/v3uufrwtv8xPzq/Mh?=
 =?us-ascii?Q?ep1F/4VM98iIN/yig1uYydasI02Me6diUan+UpPoa+0FYNtSawxmyukTPNYY?=
 =?us-ascii?Q?gU5Qo/xVV5AdQoPm1kYI6aOMPAUoIg4IB6a8Ome7ZPLJXXhK54ex/6E4zfLA?=
 =?us-ascii?Q?LuXCFVBr2ijNEjyd9I7Xpe6Hpzc/SVibNjClFJ3JLFNn76QEDwKPCf545Id2?=
 =?us-ascii?Q?opR6hRgNdRINnD6D4i4bJ+CxjrRQLGFp7GPy1+ICu57ZUVkAv9jJL8APGmW3?=
 =?us-ascii?Q?Z5X4dwlmCWic1DXqF72tm7bVup9u/MgrV38aVGgkp7n3ro8Xda+/7mvRpGwA?=
 =?us-ascii?Q?90YGkqvWJW/QUGvZar+8Qe8USp7Xn09KP5eGFD1Ps+Ghp/hi9AsNPXv0J18T?=
 =?us-ascii?Q?CBgkPvL1WMAsYifJjXdTy5gRrBQQ5jBEgwKl1+Vjl2dx6G1rC3DtMYYbDaZ1?=
 =?us-ascii?Q?nbsa9JB/KiDv4/lW5i87V5d3xPo3Yn53/yTjzCUtNS+zIBWXRZ13xZBBar3m?=
 =?us-ascii?Q?HA+4lKO5n5TyNgIYqUg7nGLn6g8ag9WKu2JH559wKT/lZlaODHZBAhKy1rkh?=
 =?us-ascii?Q?FRu/CAcHmWbOqA5dAnre5kYOpmCVp5+f01BATBY+nRcWzQeevosWIWpEAVC6?=
 =?us-ascii?Q?g/qHy3CSpmROxKtRC42ndZg8BwTohuaXhlP2xDZDtUPUE2hMqfo7LsSzb+ts?=
 =?us-ascii?Q?SGVRvE0bdpH5xzIexexLjv6E+JblWOgSvnmjNyh9g24bdUg2QZ4kmDtTkltI?=
 =?us-ascii?Q?4IjsOUdr0khghSdkCGQuk6UMHNykrDngdX72ClLnJc7SB1G7RROtUlcKv5S7?=
 =?us-ascii?Q?KnXM87B6mimA3AddLww6NjAMtxkKzvml7ZfTQcN2078LWYv8GxqfpLh4jfn+?=
 =?us-ascii?Q?Bmi/awb8D8uGptGggm1UerQy6o8uNWncwD64Me0k9Hh4oty3+Q9izIKEkFV3?=
 =?us-ascii?Q?CVhSdnKFbjaU5/QbJIlqaocfSlucAwCqgfW4qaLWf+q0WTgMJ1XmkZJ46zzU?=
 =?us-ascii?Q?ZSkPQst4MFq0N/VamN5V1EUhyijsZKQe4aGiL+ih6RCdtIDUBOgqTgzOvftE?=
 =?us-ascii?Q?Gy5JmHRQCo2O/nLKCaUcFJecq5M4UTET3CNmfkmSsW5KL1hEnbIf6ov8+726?=
 =?us-ascii?Q?Iu9t85f4ek5NF6P96ZhCaG6Li/xFdVZ9obLmYCT2nTHhsAswjqbpY3dXvww1?=
 =?us-ascii?Q?Z9S+W0/Kd6G2k9Hs1lo7kOE0V4Tb4pzEX00nQuUVzswRwbrsB6NhWeM4WZWA?=
 =?us-ascii?Q?NqCbCW8sm1floM+rBj2bXCI82JUwR0zICOoCxyaLwzBaVkGccw5GXc8Bm2mt?=
 =?us-ascii?Q?QlaLO4EaV7WoXFohqquVtRnlK9KX7tSe6InUe3HfeLOuCw6toD1IG0eMmm0T?=
 =?us-ascii?Q?xpxIUC62A8K0tTXyopQS5MMlVOmZh4z/TJjakpT7eDcr8jWugqFk7+uXBa5f?=
 =?us-ascii?Q?57qLGXTX/h82hcI5Zwzbc2c6VyCLwonKyMY1MFe7Y0f6EX7meriaivMoXrsE?=
 =?us-ascii?Q?mFC9Pdku5bfgE5LxuwKny7qWGf3mr3fhdT9/G5P2ijzuKMfY57FHdDVGf6gq?=
X-MS-Exchange-AntiSpam-MessageData-1: fqhIwqihdnKeyw==
X-Exchange-RoutingPolicyChecked:
	ILwvmSfNuVWBYJsEeuTaI6pMBRcPDFgAQc/xbfGAtEW5fG81UEA8SIXQILliV3fr3t50FnjjJORpamBwUBPmQuhI8oxyF/ve8OYo4pNjLjHHo4v/3jJZncVQB0KxTMF238YEqYzImLUp1It9AqDOY+3sQIbP0pZ6ien19tCDEyzMp7zUPBM1AROA/zt1TEdRUj9ra3gio5lFRljeo2sC8GcbZ0NbYzvLJlyxUi69/QE3/O93qJ3WeJjexUYsutxYe6sCAWCMWKm0b5Z6FwQK6wrTRBPxRRGfAGX1jHNH1lPmn2ozeTq8/g/bLhKUcGiTp1Fj3XDSl+K4IunGuNGjyQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o/9h1NMsazPzmBIQssHjp119bMiiwHw8PfIRbj/3kFxyy88JI/4QzSyttRKRjTBePqUdXjC3eSr2YTo7TAMZJYdSuCgdeuFFV80Xn6umexJ+FSsmGQv9K2vk4AEePugBEdWkwEdI+BEsJERek8dtuaT5D5Sq+SdDBLZ0FwI9AnkYKG02HYtVRMZotxe0yXL9jJHb/JKxnAyrRcHy1gYeK80dBx050uHUEomY2JSc+QUlvaahFcKzVI9HtbP/0MXU9wAq4aeI7yKLKXb5enVwJRoRKhWUZbc1KmJ2xT0dXjKaSKS0OPXct2+V2oKyS/b7XALtVJEmRBMDEyU9SlXiWx+A+cd8YLqVTqsWivjHbdvi/Js5HF1fMzPiezKsyZQg2SiRa52cXM2GoZ3x5zCW0eC+XdocFi6TR4VikO/nOGqL7IRFCQOIBv36GeMwYpFtuBnXpQA/SJ83lBQXWNNZsjjEQjrd7X7gXPz3Z8JA6jNH8SBcbsF6qmvCowLE3ARutmXmSfcut02yPrrheW29vjVnGw548OqBvh2X+0cNeE9JUQR9XxJEZlcKEWRWdzXAIA3Io2vu92DS33beHGbDp255PcvoeMsCoRf37Q8PBRMSiyI0gzeevAjuZAE7gcvR
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d92da4b1-d7ed-46db-7530-08dee8d2b860
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 15:54:46.8302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M2sZ+Jje7/zLkpkdzNCL0jMxXvtMuC7GMxL2wBAREiBI7leCsScH9Fev2Rwp66fcsiP1u3bK1tvQdHIjuywrpgLa0tedPxsAuz88Fqt/M6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB9295

On a zoned filesystem a freed tree block is kept dirty and flagged
EXTENT_BUFFER_ZONED_ZEROOUT so a later writeback zeroes it out and
advances the zone write pointer. Unsynced tree-log updates (e.g. from
rename or link) leave such buffers behind when the log is freed at
commit, and across log generations they can end up ahead of the write
pointer behind a hole, so btree_writepages() can never write them.
During normal operation the space is later reclaimed by a zone reset; at
unmount it is not, and the buffers survive to the final iput() of the
btree inode, which hangs in folio_wait_writeback() once the endio
workqueues are stopped.

They cannot be written back from where they are freed (free_log_tree(),
inside the committing transaction) without deadlocking against that
commit, and they are stale anyway, not referenced by the committed
superblock. Drop their dirty state in close_ctree(), before
btrfs_stop_all_workers().

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/disk-io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8d0afc2842cc..01d01e10d000 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4549,6 +4549,13 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	free_root_pointers(fs_info, true);
 	btrfs_free_fs_roots(fs_info);
 
+	/*
+	 * Drop metadata left stranded ahead of a zone write pointer while the
+	 * endio workqueues are still up, so the final iput() of the btree inode
+	 * below does not hang submitting a write that can no longer complete.
+	 */
+	btrfs_zoned_release_dirty_metadata(fs_info);
+
 	/*
 	 * We must make sure there is not any read request to
 	 * submit after we stop all workers.
-- 
2.55.0

