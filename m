Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602640;
	b=rZWRm23tKufWDEm+koKcOy1eJYVAoKnIFVZr8jHQBP/9AyZGWRiJMyNRzJbku7Lm743J
	 221PFS5/vN/e/XHcMFpDdwEEebZlnmWXDFP+gUu6jw/etGz8To/VEM8GeB3t2a0yxsi/p
	 q8/y5VLPXspht4ibUAze9PJGe8RGVG3fyGWueg8zumgvqieOChJgBOiozSTeRhhiiCxcH
	 G2fqpuDBbFtcmjAwYnCF3WyFywameyC+9v2F6HHp0eS8vyMwqOIx2LloZwtFh8WeTPhu+
	 bLZtGmv9Rm3IazKaXyt+n61j0dv7+/anTewKKX9O3PhMY7MBVGFNiDyn7QYOIVi3arQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602640;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
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
	bh=+bZfkaUAdwwzN5FVqU9f1vJ26CIjYcK0DzsNJECq9Rs=;
	b=K57K4DITpByZM64LduWZP3KX6kwd8qot3l+4z6MyrwA0jOxsp0SGBNoco+8ENJWQVtl5
	 yVR6syzWE4R/UDZl7avLvRdQoFIt3xOdvssbwlGStyFR37Fvfby0ApJuwow5Y2dj4qLpi
	 1RC9xiKIJJ8nxtnwilOl/oVZOr6ZGbfl/j2Zz67zRf3Cmmvl5jzs3yEqKSEGnl5pD6rVi
	 YWKDzbTW+FP2enSqpgVrX//2na/7ZKfnecpO85d8T45XWSyMrE33ig5WA7mOOgi8eM2QV
	 J1MLylC1yN6ePUeJeN6dC3Zh6LxO9p7jPyusyPttRBxGVfHkYWN6Mq4k07Ps0F6wrJg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=MJxbcW8z;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=km5RuE+E;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF1A606A32E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DF1A606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=MJxbcW8z;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=km5RuE+E
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602638; x=1827138638;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=QrhqDAlcSd68rNvLwj6Q/xFeSQ+Hd/pezk41lp6VNCg=;
  b=MJxbcW8zcHagMWZvjk7Kjl1UZvxyY8HNlEN52Gxg7qEiVkCLjxC2jo3R
   Oe+/ypuTrJqE2PE2V/Uuyvp+cIJ9/jh2MsDgwwxBSYwFUfN/PFlRnuXKR
   +eW1DqjYL2jT+UdZnwcm1O/923YxhuPHty5tE/62IeK6QHJfP9jEtny/x
   C00re5PWNPIVlTyVgY7YRs3zWRBXfga25pTyO7fycZnaweFF9xic6QxV2
   m5G0cb0/vzrTqLfukB0yufA7jjYKS8AIqBpj2xcX7WkNqJu/7ZwzHGc3D
   MS5ifunVPMk1JgGXWrrKtSxK0q+OD72Xw9ueLM7l0fshAavvbuZhfswn9
   Q==;
X-CSE-ConnectionGUID: zRysKQkIQPKEtMqbHeqdfA==
X-CSE-MsgGUID: OSYZ3AgzR9iiko1lRvn3KQ==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="157492391"
Received: from mail-westus3azon11010048.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.48])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cV71OULdFDtJ5zKHPt7U5fmrSilSqVRZjhfaTR0qHJPp34eATPb7x3igp1Cxp4/1tluO0MSftNzSO4JvbPmhWW0DNyJfVjifL/QS+WXL7wdy13x1vw0d29AKQYkCQ/Lsbfj1N8jFUSvIDOaJffGtPHWEU5WtII9ZVCJlLoVTkKnUuzhhUPEiposqk/eCtGcMGfp6Pxws8WPuLFUNDw8juEVsSIi49eqQf2wgvK0zCPC29ILMfKeCU2zV6+Ymv3WAmrWmIFHGrF6BjZ4rrsXoExwL4O87hMeCAqQalYMLFA84+qYqBYmQcn/nkPmwCsjiNUBmk4APr+nOUugGaalGTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bZfkaUAdwwzN5FVqU9f1vJ26CIjYcK0DzsNJECq9Rs=;
 b=br5Gh4phAp4gjoyKGxWrwEjcQf43hQRmIj2+nIYf1EwoVqdDo62OhCuCbwAlK/q6O78g2JL5G6SI1HGLt7/lS8z6ZLMNzxeRMKhLXFALV5tM7NrSpq4EHVM7oN2CpW5eyLCW89JL2p1/JWFacWPkrvnffqDlz/mSX4xgcyu3tDjjWq+QG9bVeOrLa4v5yQafqahrZC5Kns0BD9NXzBbWvKuIv9Dnjvwd80566apVrxHfSqKL6jhmS6L9uimpaxPkgmWgi5chGeSpxJcxMsoVIQPq4ShwkBdaHCOO/vkJYjuHs+RCvbGYpWJEQ0zIr9vflFrpnqiXhBQ+RtDAMg5bsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bZfkaUAdwwzN5FVqU9f1vJ26CIjYcK0DzsNJECq9Rs=;
 b=km5RuE+Erpfl1z8jyugC8YI7ySaHkf17rMK89Bx216BuJEe6E6zz+0F0GdvYPJWgjWXN3bV78/RIaNrHloLpXQFWGek51JVUi2bI15Mcz+BdO/+cUZyS3p988v1AI3AiBcyyftqKD/1Vzv6BO1uUGZfe2BoOE4Ezi4U0P2KCbS8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:36 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:36 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 10/27] btrfs: zoned: prefer conventional zones for metadata chunks
Date: Wed, 25 Nov 2026 11:29:39 +0100
Message-ID: <20261125102956.266389-11-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
References: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0411.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: 196bb82b-685c-4f1e-bf59-08df4adf247a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261022105027099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	dHF/DiHuTK/bCGQId890VSusxd1mc43t8ioAaocuoiXHGs+X6Z7ZlORs4HixjcMx2O9oiix9U5mVeAqkwznnrrlRWnqxwvknd9PRjmHr579gu/eUfBMJ6MLY+zemtcdDJF7qsT5muvytIjTORe1/zPmlM76IDuTkJ2NqUhUdPU67FiJ8oJy5jro3uI+TzSyCHYFvA+ZwHY4h+Ew/xfTGvkMXSCGbTYXW6udtoVP7Oi9bpjDC1kMHohmWpuGmqCASsjafMZ4aHy1y3IQwrvcQ4qbKpip+a4NvDeqRPyWr2hzXv33NEwKFTon8s+4ZsXxiZTTfS6aRITXIflDHN2OMgl2B4FELwhgpCTmAVmAlQLWdteA0hpGkq9K9kd5qDqYVOiUJq0ACjaZSBqX5rK1834jsj3v64P9Vb+/M53NuddSg5Afs844MMyzsfs+LEfLAzt9Vmr/kXkw9naN6RtCISxlCMJHYpoPCQCwjrAEba8ENmcmvGpQv8Yxgg7SheHZ4KVPkwlIjroSykoLFG7vWLcvFBrE8ny9AuvIBHWOZkQaGg0RODFSwQSK4RHVF5teDcfVQTUKyJHoB8+Uhn5DO7Nl9rv1DTj7ktQ7MwpMON/bh4HNJIfB4zYIFyebZBtqzlPKjFX1Xj1kKw+nfxDmaelBG/EZrVGfjDFJvIKvoj3c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I3H1lmL+FtBZRCliuv+KmhHB8yMVkEr946idVqQ88uuvTQXUK7wGJeEfQ3gG?=
 =?us-ascii?Q?SMr8NQpWBcPLaDvB9R7UMGX1c5t8E612oSehkuOwLE2/j7f7uhKNixuS65b9?=
 =?us-ascii?Q?w0Ln0ouAiHSOWLGVle3vBei9x0HtgbHi184Q6BJ2vCSIbHeJ/X1EAjsj3CNM?=
 =?us-ascii?Q?5YCe4/8ua6483N9qx4I1aZh5z2Wd2YXo5MLkQxDEHCuchaTrP9khwHK6E0KF?=
 =?us-ascii?Q?zSzJHKTyyJiQBvK3JS7YUJKG+lFo4+MlnljHu9hnHIYBxasMV0TFeEHrz7EI?=
 =?us-ascii?Q?y0fznD/bnI66SsT+73utZP68uKabDUiRU2kez05fbHXwaiIOFnT0eBUuaV4/?=
 =?us-ascii?Q?tgUfREz0yuBszHDHRZZ8pWEqeH0G4Dc/vA9+2xjgdbbXgSGd4F+G4S5UVq6x?=
 =?us-ascii?Q?hQl5ZcYS1188F1/UeUUOtMCw5TxEvD88iYkLPrjGVaYMOdGVxGcZtpObXzPw?=
 =?us-ascii?Q?duMZWmNCyFdcfoe9KbHFFLv4tgsvm1vd53DjnjvMxN4VvF22mdfeNANxQNxf?=
 =?us-ascii?Q?qu0pyYvFcgIWWWxt0vqW/H9mqC7WElS3n5WYe1uEe75so5WHfNLSAg0Hd0WU?=
 =?us-ascii?Q?uer4s4ICFl2WvYU2ksBJ/FPeVjayB9nBuMZLcuOAN/XVnBhDeZ8ZtaZ1YOJu?=
 =?us-ascii?Q?iClIZ4LCfzrtZMWBpdrL4iyhQdV/Q95NFDb6BqEvTyzRJBMitt/Z007cqN3h?=
 =?us-ascii?Q?2R/tKp5aV6SUFST45U306UMUw3J1pVJAB75Ntq4p123bfeGMN6qgESCQCdtx?=
 =?us-ascii?Q?d5c+C0I2r7ELjM7UZIh88rO9bVeZ/SX0Nb7KvpU9qmOEWvJkkqCRcSVCyW8r?=
 =?us-ascii?Q?46dLL/93vvB+5aZVWAOwQf418axq3XMx+fWtmAksQU8cLW1E0YjkuduCZABo?=
 =?us-ascii?Q?+F4K93KyqrNH9lzNl5Kjygg/b1Pnql+dCiOdnvilBVKLPTWoKvwQeMasMEeo?=
 =?us-ascii?Q?zDF5VWkOUGHIODm1PDS2StfbS46zUVMYcGtxI5EMncMsjR7bnBjLwblLHze1?=
 =?us-ascii?Q?1T32trkxipftcstq70lHxQGD5HDToommU1KE2bxTzDHwkq4baTSizA/XZ8hf?=
 =?us-ascii?Q?mUnX+SuhdigqeHpnntR7CddwyXfHryp/or8d/xUz6BLdj83J2KbNbEFwp3jw?=
 =?us-ascii?Q?ZHDpaDouzn1E2adT34HWkwSPIPGq/JU8IcGq8GDbgkyzNsuCmrd8lLnrL3S5?=
 =?us-ascii?Q?Vfqd1GHZvxS1s0QeSkV+aFj0UR7QQvDzoeCMxQ1UCvu60ARKScVsH6j91Elm?=
 =?us-ascii?Q?IqvpIiRwI3woiSsiCqy2DkaHi1F1SIlmNeTMUt8ELnUMGGoj6L9HHbl00g7X?=
 =?us-ascii?Q?Vh5YhkOMUKQTze7FR+Dau2B9Wyiz9TtZBeHBu3+uaDUeQwF3e4YVtt1+wsWI?=
 =?us-ascii?Q?1QjRkwzg9gvP5sR4f3TfyEj59YLPS5kwszXelIIjVKn1gWXvaucr32S1mzMu?=
 =?us-ascii?Q?D/QX4Uo/jBpm5rEi2VpmeCzxutXJnaanb4tbhLyVcWaX6/P6WkSZTsHRB+Qo?=
 =?us-ascii?Q?4MrKfYaSu02DK0UnnW5oDzoHUNQieEhYNx87AGKpR0N7KV8GCfF4e/lKVLcU?=
 =?us-ascii?Q?ZERHbFFPPUrKhZxV1FntEy4974yw4saPZfaXfFixNlePpRUVRQgfc5ghzugp?=
 =?us-ascii?Q?51++oFw3nOxodnetWbWcNHQcL/gb1WPMNxaV+AkLDuxz/HMs4oBRnpBEOPi0?=
 =?us-ascii?Q?i321LmP8DnXou2r1qiEncZ+nu/fIdBzuj3ELsl3aodKWGmtu9fD/TUz0LGUO?=
 =?us-ascii?Q?/7QJenisyeAZ4dgrUcUSR4tjhH3pkN7kFrDYPA6ZfPEJRc02G/9VaZAkYjIs?=
X-MS-Exchange-AntiSpam-MessageData-1: 4ofPilf4o5roxooYhWratoRzgyYVVL36y/g=
X-Exchange-RoutingPolicyChecked:
	lHoweCYo9KCM1XC83gVmnTXnQZNDGfuBPlXSeI9ul+eG+zoClRBHhSqnadzNDvJYAJIpUjr9MKOjX7eyW1bWQGD3M6O7+z7hdRQPxc15cFYi174+bfqpSWqgG4ZdmOZho+TJtPsb2sOWbQtRM04a81HW/X1gNQ09bJVibX4S+sZ7ueVLsJ/fQxX28z+7hLBFuRHp4fvjd9cdbg7wDVo6zKblAkDS1KUggVf/kJdoc6wffBswDDlfKiO98ZwQZkwyORHyJGhqDJHR6tF8p6eezKB4r8mxwJonsRHqjyuq9pCZHq+g26vdTnn4tzKcpbuSjQFZJTzh755NRoHIa4xFlA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JdoX4buKhDGLxKBoLCIfLHOd8I9xLNWTDqHRjCfQqcNirKXwmiuVbGfVua7oVFYzE/NI8efspwJtEPsnQfaLXKzjp8rYlV36tw1FpFmmKWpzVf7v9sSMKzdq0e4H/wTueWH8d1vIhoUDguU4kUBNJtaF4sBsUU9SK+2voq3i1fuXNdrjR6+r9WBcxwziwRHF+U4r7HD7lmcvK1bcmXZ5prctxHH8nb/FvYXCHqthzwhsKDUdXpciPTcaJ3tit7lUfR0l7u1DymnEnTPOQubII5bpVTuRMo6czR9UlojF8U2nHW11wBM/CKOCSW74QxSb+LZ7jGeG8azgz8paGuqrrUl6fjX6DtEjS/B7DftEC2GNC+aF6VylhmDajqlmkIWSBIgG+UmVDcZWSZs1udFAkSZHmiMDcEXPzG5UNjOrOZniR3ZAsb65pv1IzCBAJkqY8IyDOAa4NtkVWMPXCtHkc6nbcSZpiiydIMGAZofUaKdZtnOeua9UYjxPGGz8v/FtLVl9R5biWWyDNmCJ3G62idQnk/ZeraHpBdwoEx4zNCNalsqV8tWU09z+foQv1AQxe8D0QmA1D+XbJuu+sbYNi7F+iYkvLGz3YB95nr8iEsNhBIX4Ox0V9swj1KWaH1Lh
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 196bb82b-685c-4f1e-bf59-08df4adf247a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:36.2059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lML4Ep6HLQwvb0th8NblUEgKkjwIQEFrRiaEm0JV9vAVAQnyZ8f9SgXeowOtZNeR1d8cN8f84V0P1joOw4wyhzna8usfByfBXULXvH0iSR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

On a zoned filesystem metadata and system chunks are allocated from
both conventional and sequential zones. Metadata landing on a
sequential zone has to be written append only, in strict order and with
a queue depth of one, and freed tree blocks cannot be reused until the
whole block group is reclaimed.

Try to place metadata and system chunks on conventional zones instead.
The device extent search is first run with the conventional-only
restriction. If that does not yield enough devices for the requested
allocation profile, the search is repeated over all zones, keeping the
previous behaviour as the fallback.

Skip the restricted pass if none of the allocatable devices has any
conventional zones, e.g. on ZNS SSDs, so the device extent search is not
done twice for every metadata chunk.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 41 +++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/zoned.h   | 20 ++++++++++++++++++++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9540885f01e0..9462e8adfbaf 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5921,6 +5921,29 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
 	}
 }
 
+static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *fs_devices,
+						const struct alloc_chunk_ctl *ctl)
+{
+	enum btrfs_zone_filter filter;
+	struct btrfs_device *device;
+
+	if (fs_devices->chunk_alloc_policy != BTRFS_CHUNK_ALLOC_ZONED)
+		return BTRFS_ZONE_FILTER_NONE;
+
+	if (ctl->type & BTRFS_BLOCK_GROUP_DATA)
+		return BTRFS_ZONE_FILTER_NONE;
+
+	filter = BTRFS_ZONE_FILTER_CONV;
+
+	/* Avoid a pointless first pass if no device has such zones at all. */
+	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
+		if (btrfs_dev_has_zone_type(device, filter))
+			return filter;
+	}
+
+	return BTRFS_ZONE_FILTER_NONE;
+}
+
 static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			      struct alloc_chunk_ctl *ctl,
 			      struct btrfs_device_info *devices_info)
@@ -5929,11 +5952,14 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 	struct btrfs_device *device;
 	u64 total_avail;
 	u64 dev_extent_want = ctl->dev_extent_max * ctl->dev_stripes;
+	enum btrfs_zone_filter filter = chunk_zone_filter(fs_devices, ctl);
 	int ret;
-	int ndevs = 0;
+	int ndevs;
 	u64 max_avail;
 	u64 dev_offset;
 
+again:
+	ndevs = 0;
 	/*
 	 * in the first pass through the devices list, we gather information
 	 * about the available holes on each device.
@@ -5960,7 +5986,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail, BTRFS_ZONE_FILTER_NONE);
+					   &max_avail, filter);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
@@ -5987,6 +6013,17 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 		devices_info[ndevs].dev = device;
 		++ndevs;
 	}
+
+	/*
+	 * Not enough free zones of the preferred type to satisfy the allocation
+	 * profile, fall back to searching all zones.
+	 */
+	if (filter != BTRFS_ZONE_FILTER_NONE &&
+	    rounddown(ndevs, ctl->devs_increment) < ctl->devs_min) {
+		filter = BTRFS_ZONE_FILTER_NONE;
+		goto again;
+	}
+
 	ctl->ndevs = ndevs;
 
 	/*
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 174528e2c312..ecce74f67a5d 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -339,6 +339,26 @@ static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
 	return test_bit(pos >> zone_info->zone_size_shift, zone_info->seq_zones);
 }
 
+static inline bool btrfs_dev_has_zone_type(const struct btrfs_device *device,
+					   enum btrfs_zone_filter filter)
+{
+	const struct btrfs_zoned_device_info *zone_info = device->zone_info;
+
+	if (!zone_info)
+		return false;
+
+	switch (filter) {
+	case BTRFS_ZONE_FILTER_CONV:
+		return !bitmap_full(zone_info->seq_zones, zone_info->nr_zones);
+	case BTRFS_ZONE_FILTER_SEQ:
+		return !bitmap_empty(zone_info->seq_zones, zone_info->nr_zones);
+	case BTRFS_ZONE_FILTER_NONE:
+		return true;
+	}
+
+	return true;
+}
+
 static inline bool btrfs_dev_is_empty_zone(struct btrfs_device *device, u64 pos)
 {
 	struct btrfs_zoned_device_info *zone_info = device->zone_info;
-- 
2.56.1

