Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD7D411672
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 08:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376095; cv=fail; b=szcenlmERyiEAa/imLUPNz6aQyIADgqXXOtrR9QN6JNe9V66pyx5ZyxO8x8uI6CGEwSs9wMBU9oPbhlmPjh/5sjkpKm7Y7XimAfqDZE5j4RGTSNTjoMLjL8mnRSwttmW/acDPY7QvfDU4icNgX4Y9znGhYdfPt2xiz7gCrJVVrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376095; c=relaxed/simple;
	bh=a9X2BXWWXP+G4BlnVd/9D+qh39AXTzM1JpKRadxYmFY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bvf36hmZtnwr71KGINRvBeOwBGJB2zcUWhM02SIwGumC66YHnk/dNVsFFUU7m4hdGD84XSZZsnrM92ZSJXhqySlfDPv7AxnEFIWZtLpJTExc4jsTbNh6mYYJYqPy+hTslVIgFQbo6Kpt44IOSIok63OwdSxF8qHzkteHJ2MRmFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WB45s1RS; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=h5g9iJz8; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WB45s1RS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="h5g9iJz8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789376094; x=1820912094;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=a9X2BXWWXP+G4BlnVd/9D+qh39AXTzM1JpKRadxYmFY=;
  b=WB45s1RSYCz+Cy8IIwatvy0cCwmIpynYVPjtKdWerXd9bsCwrZb9/3ZA
   OzlSHnsDBFXIcdpQGJkp6ISVsp+xGcRFNIDfrveuXX5OJgsVjrfFlqzH6
   gg5ccNosUFinsQctGrTErpyVi+00A8Qe5l9FK/M3KrAETnce8yit55U+h
   nZxUHv/hE+zPCCgSM4edN4nk8pg2TKksd8CV2M2Xfg3awtemevGe5/qT7
   oDx1cafhXfryFsTYmOR8CGn8H9K6MSZPiQp5KnvfhFL7x7iMXpeHa9dYe
   CitJBzOa00ybkJI5Z75ZkVzuE1yERJ4cqD+jInIeOKg2Qlv6b9kxix8xy
   A==;
X-CSE-ConnectionGUID: uqjGAFhmQq6w2jvW875lrw==
X-CSE-MsgGUID: zS8+3iAXQs6rfVaqeNgQ0Q==
X-IronPort-AV: E=Sophos;i="6.27,102,1786982400"; 
   d="scan'208";a="156538422"
Received: from mail-southcentralusazon11013037.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.37])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Sep 2026 16:53:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LzRd5vhQDMn/a0SRlC7Ov+KM2KeP/E6KG+zS6c/1G7q+CXWHt4TpFGKhuUDl0FZtfvi8Tox9XNywKE/JVUyYQRrsPjGHm6qGUq1iImnkDSR7/ZEQnQF6FWXe17uAGOP/XbQEu6VuwNiId1NbG0tiE8cpgXS6yAk+jXcCnzX5ixb1WVUFfzvkJaTXo0m/LHiu00czvzJFqYCLmyMcYq713FJXYI0eVl1l1/euWnaJMBlHJ7O4zmddgL7+yi6gRJE1XpOXDhNvrpJDbRXv3Kulv+m3J6vl17nGXv9gJJ+DF0rTFkqlwlPFiaghFF+LXd4s/VB+KrRUIxxFGSSqkpWZBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RWB+S8Jj6suVCBeJAknFhhFz0ksoPvWMeQqDBzJ2twY=;
 b=YNYdw7XqQOXjPN7WAjMizhe4JaQMB5sHO4P8i9SiYBrJiigJT9x3Vu+ecbl74Vq8csSbxPi6j5xGAuDr5EQnHFWSBCArZ6ZZozLpxf8l2bsJZAtBjKa7L8jmijlKBK/6kSUnLxEpV8F3ubWseArJN9cMrXXGD0w05kA+21ptnitb7OrsJf0Hmm+ta2BJ/j46sD0SnkuI0Pe+3+TkawD/3R9lcDzK4Vs2VKtCOC/wpn/B+v98oPF7448nkLCirgeqn4Wq29PtTki9/Wq6LrBXgLLYFmo0YB7ETZZ+5AWxly1tqqt40cDKa2aT9B5EI+HjpXdFeeT+3KRUvN9An6JApQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWB+S8Jj6suVCBeJAknFhhFz0ksoPvWMeQqDBzJ2twY=;
 b=h5g9iJz8NmISA7tj86OF7PaC2rhR1KG5cBPbw492ufpzw47HECMkddBKws2N9PTveXuuSSLkjFkLjVqWFFMy0B3W3RdguRVdqgMyg5XH5srL7o/pt91REWaKEN7CZwCVjCJOEPI3sxUL6lTohKb0arrOpSKrGblQ4ekIuaX0nn8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9263.namprd04.prod.outlook.com (2603:10b6:610:223::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 08:53:36 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 08:53:36 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/4] btrfs: zoned: LLM inspired fixes
Date: Mon, 14 Sep 2026 10:52:44 +0200
Message-ID: <20260914085248.347198-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0314.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH4PR04MB9263:EE_
X-MS-Office365-Filtering-Correlation-Id: 1df931d9-3013-451c-f69a-08df123da99e
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|19092799006|10070799003|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
 0BeQJ22UxUcb/GN3iRC06MrCOgJngcbIQkExNSc5JvlCsxPg/lA72yrBn2ZQVDqF/3qWEMgnz32rKNU8HNJpVq0FTGBnT8Nuh/kCCAFOqtEO60oYM/XIoEflZ+3NVDob5hGZcUBJq1yvm+VHR4zp/zBWSyKq3Ced4BTKarPZQ/xDLsVP6z4TLJJEnepxKk0tG0+JbPvRzJ5QZ0Dw3u/tS4JN3o3jn+kVryJsjv9U27Fji5vPFTUqUOGMrKVl5gZeuhNBflsxxN+t//A+4GoDW/FjZlK/84XEU8flk1N2J0wmNDe5UdSMNA133Qbp0KjrDTDzmFsxFJmZA6GLWir6jIM/WoKk2m/indKcT5QaX5NBES8dwiHlBqpDfsmtEv5uyXkFs/iH3CF9ZMxjp6w2wFAioE7CEm9pL1ocL6+b0LM7YgY/Zsv7tT7L2iGQDtRamoDNhQA23znywIJs/B7t7/eAQgYwGyr8Sa5eebA/rC/dK4ZQe/PjiTNxXQjxYqAPZisi7mh1wITWYTHRbB5O+dlbtDHSXgUe19k54Lq3wY6bb4o6hycIBXa+HSoxEpzZUsMRIpnM1MLEijVt0VbmpUWb9oR68RUwXtN9Ed95hYTBoK/npdXIEeviQnIdI6s80boQdsA6Wu90tiiqWidkYfNDX9hzGd03qQgvJcujtAQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(19092799006)(10070799003)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?XP52WjmDUp0MoPR0KwwkXLxtjmll9TiWYNGkxC/PS+E6zK93xgBM6NdrPY1j?=
 =?us-ascii?Q?O5BPCtdHXVUIExRK7Ag+TwlIr2NOq3HWYZDZtHEdRi5rwbXjLtW18LoXveXM?=
 =?us-ascii?Q?7drh0JfeEZwZy23aR2x5KxHzrZFLHKfzdcuXQ7HGDlOrtnofYoFuq2hImGu9?=
 =?us-ascii?Q?O53iNTprkwVmyREJ1rnvimgN3TIBGPRYzZzqSkghFVKIj+8rE/IG0Fr3mD4c?=
 =?us-ascii?Q?35cs5vgUTTjZwUho/5H6ufNS/lrP0knoidTkLb8mPwxDfOAfuDa1eaB7aYv+?=
 =?us-ascii?Q?u7lme4OcBp7n6/zFnFRpaFplV0F7aZv/M1WhfM+Hqxm+f+BbEFd9y7rDczds?=
 =?us-ascii?Q?q1oAz9E8mwF1IYFPDZEa09QtXOQuMuD3B/8/sN7PPUICZF0ILjMWkPdwbEJa?=
 =?us-ascii?Q?3uUGSU2wlLdt4qSx7MsaR3ZAVd0lnmb3HrdNRkVQm4mbCIqcIVyvxk4B2of7?=
 =?us-ascii?Q?oov6EBDd9hIhKE98rKnLrQ6aimvueY5GrxfBylYUNzBn2IIt5WFEAvSS4Aox?=
 =?us-ascii?Q?YYZfLwjnsV/uB5j6pvLfEuDD2Y6veiTy8QNuLzyDKXaCIKuih7shY8ZgnGMp?=
 =?us-ascii?Q?7gbrxvsKchGvSnW/u2e7eppTcewREmbKeSpeoCqMGuXfco5FOUFmTsTgKxiL?=
 =?us-ascii?Q?+bxtDvl0UFL+HIPj0NA9zlR9Fx9OSahZYJfUrGx43HaPx+Aow0lGfLPgyVrv?=
 =?us-ascii?Q?WRpmLOZM23OLBkmPO7aWa1K1voN+Acssoq+dhRaIkDfCMAygxRoMhuQ5W+0e?=
 =?us-ascii?Q?v7CmPn2vU65M3dYhSAMzztfYjZKASFRuOr7bvOZhUTbYnMtINpH51tcSWUsv?=
 =?us-ascii?Q?lycbXrS4sYmVvmWyxgI5Yx/nuDhI5gViklwm7V9dgJp9PWm6CyvHflx78kWv?=
 =?us-ascii?Q?5Y49eftp3u7OK+u/ZLVCThWRhSogPs/cm9xy0XQxTwfayoaxmt2Emg5RHo9U?=
 =?us-ascii?Q?cEv4kaMIWGtz273AxvpHFcGYe1XLVEqAxC0HTir1y+M3CUiE7ZQxTPyryoSt?=
 =?us-ascii?Q?5hSd0ZHWztQFW54mt1jlLvZrdQjaaWJGNaiw6xkuzrVElvX9/z3440PbV3Jp?=
 =?us-ascii?Q?XOUUoZo7dpAhX5GO4aIsncnqpNjE3VggURecREB+NibhsBXipSoIe9HBWmAx?=
 =?us-ascii?Q?emHnussY8gU7HuWhYlOcUUbOb6xWsarxuLz9Jj6T+tXVmX4Ky3FBUTU/eOTi?=
 =?us-ascii?Q?DYkEbpFi/8sYNDEjQyioV5qq+0AlF6fzkAF/7c9rabShqz1cSQVaK2vsWF6W?=
 =?us-ascii?Q?TAOCyR3qxukZjqAgzEaO5Q3Zf+4uxFZoZDYF3XQM1JUvzcNJSmuNKzUqD6+c?=
 =?us-ascii?Q?SdUc4IMvABiZCTwNvwaBnoKGd9borqmIjrUTYm/PMUR8jBpOpI4g2KjS0+/R?=
 =?us-ascii?Q?SvNWHBZDkUUsc1CpGnN0662ZxGxa3QqCrrddKJzktExkzjpczS8YM9Nqhzrg?=
 =?us-ascii?Q?59xRiBYLGwi4zALC9cX4TEJFeMCcGtdhoe+85QJj8LS6BlNnUgqbZTz1HcHi?=
 =?us-ascii?Q?Pm7whYAca5da92SQ2o5JWA8u6raQqxQRUYqliMbTRZV4bZLXJgVc/9lBk+Nj?=
 =?us-ascii?Q?5tXiAZc4Oh9QsU+ofSCT1pQ4DfrXmTFZ+nhEi2KUjbglBhFsX1a+gP9oAtJU?=
 =?us-ascii?Q?ErlKJpd1RCAhpYftO9MiSjy8+Xu4NDyxZlMzfaO8k2Lb0GvJzwD0UT3dRyCo?=
 =?us-ascii?Q?zfPF01dKlNZGaNhIhjE1btsk9haiM/MAFpO0MVy5knRjDKTpOtolO1KTL6AE?=
 =?us-ascii?Q?cb5J46WxGFTDc0n2p1QUdKtUgRtTyDgifTP//7k/KseGQ8bYiGUPsK8xidXf?=
X-MS-Exchange-AntiSpam-MessageData-1: cBJoTIJ25R6I0H0V4o2xoIezwVh3UjcELJk=
X-Exchange-RoutingPolicyChecked:
	TCU+qMDBGShpDlqMHPA3Wq8Mk5A6xvXlEwzif1KrZApdCHhlBtxiQcKFRrku/BGQZ1XISqtDD3EY5NxTH/GN2h7I1UVnTMaqdzsomDa9pDHfsjFJ8T/cKgSmzLDdwDfTT/SOIA47HPenEh4qTCc5UHknddiaNBjZypXrdaoQpL1AkSAlCjQwLIKAxP2fO1H1Ycgp2ezCmDSYxZqiyHbIrFB/XluJKjXso2NQpl6tEBnBRwIKCx5zLj8ITFLcZXCQxDaWPFKOup1GPJ0Yn1xquyWJKCnA2G60cV/JnIxAjBzV9QP1j+GOxkxSIrF+RuZbhW4ga/fCgXP8wafTG7nQzg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j13UUN61hcQID/U2/cE5miz/OHj4PKm6gZb9H827PZ2JDWOJuJOTlw4vedFhdFNcMopqtz/OdBvggEP9Rd2oL6lkPd0fzaWNXeO6hn+tgwycn1cW+ATdaxJVcS4HtJiKASrF3BhriAETyw7sxxHzRNu19b0I7QffSoTXZyBEK/JGpDM0e46/8wDLEt1mkybuBQnJ9ok6KAqX4zGMbFKr53NgkjeUGWZKuB+CSUBHTghI2w06WlMDRE10cq1EN/8pC0KyBkDm4jotawvG6+X7PVDrptW2AI2F3TExDZAe29TSKdtMddcaSLhTOfHxEqBa7Mkq6ZrOs3rgy+/LkQvPIpYxeL7D5xFm0Mf6ofjjDu7iL6SxiAi/VlCVE8hrNSJ5g9Py3Scn++yjH2hmCbHvXIvh6pKjRuewyceMOZwCVQDNPOA1WrbaIxb/YPWQEaFC0x4Kx6IYACI3klUn6H2IN7/ah63dlsZL7Ra9n61u/FQ8iptntU5T9QpBYijQ7K+PKUYUPbIRYqHqZYh9wCwvODZoPj+3eUKuWXfCjtXLX+h/J+rLLGQ+h1lGC6l7fxVMpXZmkmBFR5mtdGzRBEzqD3B9q+fkP76azOrXd2RDwiTMCqDEUHhDJ/KCwLHsFNCX
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df931d9-3013-451c-f69a-08df123da99e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 08:53:36.0198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ruOVBvog0sQLDPYDf2hDvJPL1ClMTHpvDf97TB10dSxf2gJPCLaXySX+nlaXMpAfvg4US4NXJiXFwnUhWpGKXpNNzanHD6cNBuk17ClP/w0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9263

I got inspired by Darrick's "LLM inspired fixes for XFS" serieses and
told $LLM to have a look at zoned.c and find some obvious problems.
After sorting out what I think were false positives, here is what I came
up with.

Johannes Thumshirn (4):
  btrfs: zoned: only change active zone counter on successful
    (de)activation
  btrfs: zoned: fix possible UAF in wait_eb_writebacks
  btrfs: zoned: requeue block group if zone reset bails out
  btrfs: zoned: avoid underflow of bytes_zone_unusable

 fs/btrfs/block-group.c |  2 +-
 fs/btrfs/zoned.c       | 62 ++++++++++++++++++++++++++++++++----------
 2 files changed, 48 insertions(+), 16 deletions(-)

-- 
2.55.0

