Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCCE2F8EB7
	for <linux-btrfs@vger.kernel.org>; Sat,  9 May 2026 14:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778337966; cv=fail; b=P4Zflfe///gXVFfkgA0raJN+9MJCe4tQNe8N0BDySqvyuEIMxsdukq+oQ48IrAK7FY1xnigR0idZzsOvcr/kFUyrijCfjPD6uxS3wcFM8Ia8ieeuC1DFGODSF/Sl4vun6TY6TOSVEFny9cSwfywFBqukEqXh3W7ORZ5hwLe12Qs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778337966; c=relaxed/simple;
	bh=AwpTTCxPCAMla8kXzC6VBfC9MzAL0GEvqWeDUqtCSiw=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=tYpDiLNkg01Zttrh74IEYT5FQWPbjlhi8xqlbT6nhLa9/4rhUz3LluCO4nV17e2jT/P/C7ghqv3mTekhbj0y2F7ktC8plBH6WFqYV8Ti1lQMGTPBZXWZiWl/DC0BfX8p++FEYKMJmC6yktwB7P2Zj13jRzLVvIhtLvPcPM5mtys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QG26lXSo; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Jaenm7yt; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QG26lXSo";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Jaenm7yt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1778337964; x=1809873964;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=AwpTTCxPCAMla8kXzC6VBfC9MzAL0GEvqWeDUqtCSiw=;
  b=QG26lXSolxvEruKxe/+miIU/UG343ZhA86RKVWCyT7J2uXIkYiA7xGvG
   d0P2t+GQklPQYEzSVxfXPvvM7I+U6UbInpTmxGYzhMi4XPmNRrSFdJ4+M
   jLZAcgbIObldVeb3KcF5CZrbgAFXFtQsGUWlIjPn48X182zPWgT6tGOZm
   xvtVsvWmoHX0Y7IAagYZPNs/lWwu7zLrxRpCZACYEZxwRjnih+t9jwB3x
   jt+1YnrCDXSUiRxA7/Wzbj/UL0RmNRb5YmmOcuUBoUhh5Ogk8j72t6uwW
   12OSeVVsgwqtnkmBqJHFFe2MUC3guoAM0VUu+dkGxyNoUNH/sncl9KP5X
   A==;
X-CSE-ConnectionGUID: Lc//tvr8QL6zcsXnJ+nohg==
X-CSE-MsgGUID: 8gz+Jp21Q0G5ENws3TOGqA==
X-IronPort-AV: E=Sophos;i="6.23,225,1770566400"; 
   d="scan'208";a="147396918"
Received: from mail-eastusazon11012009.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.9])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 May 2026 22:46:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OVAcoQjsy33+nmJF/gnV0COPCbe87xDcL0Q10pbspcHhX4GkRnYbjXLzyx40ayqxm1X0UANndFb2izyrcveRbgvR6FBBe2aEDXrCHTmuY3oZWvyOSSPvyG7l5ooLCG9PrXK7SGS6MxtAHiz2G/GLOSFCbrI8jr6k0NyD6ZZ5z0JMdAiUNRfKJuxm19DmI89MTYC9bszoc6oPnAWrLdAxALPYdmquJO8bDIMbLOZx8ZBLmt8hpgqP9zQXA2in+0asD8SyAS96QXNtk9Su9ObYJOjHRn4A29mTXBxS0etXsWgyuOxm268Cc4nyS1o6p8CQ1fnhL3U4Rvb8Ey2f3ayHwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xy7dqyObqH2hskmUCpqthjnt26d9ZSPgPsLz2Qrl/6s=;
 b=R/tj7gEiaK+tKfGBQx1HWy2wH+G4OFS5f8GmBUuBFzgb2jbshWgyRBTTBo28Z+GhYPUdwOrF2H3cuc4rD9ew7Uri3RooiGiQKpyQscBnNH9HKLNz2zre3AMDtuj9eOAdMrHmI3I/hOT1b7gRtzA3W43M1is0LI7qlvErpvHeQpb8+sFOUwRC+Dz0KdyM2pZ4jvkC+MPYm2bMIviQGu1/bP7bl8A3Vc5V0ji7z3zIU1KtMDNiV/MJB6CrZoyaLLyDwfG/J0Vxz9zXaIvivPnjQXsvlYsHKHEWyJMgO15y+RWb7N/TxAct9A2GQDedcwNpxSADJIu+IFU6+U5/vzMf7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xy7dqyObqH2hskmUCpqthjnt26d9ZSPgPsLz2Qrl/6s=;
 b=Jaenm7ytzsyGLm8/q//m+LYc4K524vP1LmmXaAQb196UoAqin8oRHJPGuUx62PHDoU9qbBh4t5sowaxaiR+tYTA7462oibjYtCvv8uS1GXFGfsYuCZHq8+aU4XHsHCbZMM5EqQ56XYqYYi4+wXsmLqJ0BEq/8n7cqDetRdFNomM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CH9PR04MB10093.namprd04.prod.outlook.com (2603:10b6:610:341::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Sat, 9 May
 2026 14:46:02 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9891.020; Sat, 9 May 2026
 14:46:02 +0000
Date: Sat, 9 May 2026 16:45:55 +0200
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [bug report] fstests failures at btrfs/003 and other test cases
Message-ID: <af9EHC5b-aBdr1zn@shinmob>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: TYXPR01CA0043.jpnprd01.prod.outlook.com
 (2603:1096:403:a::13) To SN7PR04MB8532.namprd04.prod.outlook.com
 (2603:10b6:806:350::6)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR04MB8532:EE_|CH9PR04MB10093:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f69a720-224b-4732-ec9e-08deadd9b0de
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|1800799024|366016|56012099003|18002099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	+OMP/xTVHeykFewuPZO6W1w3/dyX0lJs96NDQ6r2/Zg4CjRhhTIau/dxWItyMDMI9RsJyTGQzeyE5eo5UW8VB1T+3bOYKL5HK3PmjFrJnf8ijZSKvj/0zZC7iOCe8NPQm7ZRPTrJIna04DjRF2f34Jbz3H46NFgXwLzPN6M13EEc1BSo6l+RXQveVevpU/gbXbdHWT1Asf8iwPMcqEqPzaVruIcrl/UdPtcmvCFLWs6jsOo4TulzSrtxFDwJuIF3GJ/WvKGK+m/lh48M46cMbfjyrxHMCw31H7pgnA4fU27tb9xaI3rUGeho3f0Av4uJd/OukcytREOMs+ySdp1+7uAgu/gY0iLeY44++CiODfQ2IelNVM2p0lrcM6iNWI6GMHi3NlT26GrTshYkdIA5CrHuYcHlJhARSh0vVZuD94DXeBplhgcGydnJWkTm9qDyJwTxQJTHtDfs2p9tptyipXq3a3Wwv/lKnOletSDZLBuXnKPa9Ur92MeJvpy9fi7JdXGr9ZVgZzA63XXgVawMI93d58B6fs6pNvk/jRi35x7BjpHEuFRSVLzAO0XTVdqoVnMLDqPiPbtWDGOVF63/jDaZMq12Oh2caMiNVAvamHnk7blg6JRxRNVjjrut77bJK+zKs2C47d1bJrHHwF5Cms9K/x687DBlOEY3tni/Pxq0q4P9NjXYXzELP+pAFROpcO9m8Urm92qZuEQg1trH4g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(1800799024)(366016)(56012099003)(18002099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y/YeGjZ1Rqh2NapbxjGBODivqZWcJA+yC2g7cXE3+qd5GhxlOFqn4iPeog1U?=
 =?us-ascii?Q?G5qwIiepMJCbGpDLv0yMCHafZ67kSAqvDtEagtn5pv8Fuz2youP6TuDMf5lR?=
 =?us-ascii?Q?eXDlKES3H041zSA9EJTr3Vl4MfW8dvPd476Ez/2MnR4wyHGdY9Z/h+0uRDc9?=
 =?us-ascii?Q?BJR+KftoYnzMh8v43SmA3AYpqHKxjm7ojfaxkOD/bvD853qUbfzyg/sGKiou?=
 =?us-ascii?Q?6WF5V/eQjK6GazBC8aI39Ki9nRmuuj9ItjuPWUW3Apmt24AEmXsqc4UvdAU2?=
 =?us-ascii?Q?ouHUrnah0QGuWGZSYRI/ejVFH1ePzUp9+cZe4iaN+9F84iFmEPdLgiIN2obj?=
 =?us-ascii?Q?4c3WqMdZM9ZzdqqCF4efSZhnTRbjeko54U3/b6HwPkwECJWC+E3H47cun91/?=
 =?us-ascii?Q?fxhc7By+NL+Gbg8Ez6bhf7q50cVP7heANblMY7G+UOgnx6Gym1GA0F33LBfC?=
 =?us-ascii?Q?kz9M0UyIp5nYCb6iIL2CFXAYEUjUApizWT3Vx0rgtHX+vavYd9eCVbgs16zv?=
 =?us-ascii?Q?yw0AK0kKlIaIajZ+2WPZi8V6sb9Wv4anunuvR0HCs/QIU72KZi8TNGIU4GS/?=
 =?us-ascii?Q?Ykv2V3NxnaCcO8as811A9+xC4/R2IOlDBhnGh5i9QwkWyvPvYExdmDY/pe9s?=
 =?us-ascii?Q?RlLS8eZumji69yKuAbhwDRjcD2qxwmc3uwMSe02DNixYQpQLSCdOsnA9IrjA?=
 =?us-ascii?Q?z6bPEbKqlLa1VliUzkr2zGN/RthZEmOGXYMK9JIG4z/hUe4o43KiYeou1kOO?=
 =?us-ascii?Q?Up77LPJuklpRR5jEZIlZWDX4/e+BInnjVrbzq/0rp18i4qNMtbFGcoV53JvO?=
 =?us-ascii?Q?Xh2tfocqO1ngV3yfyJHtrme5Du5i+pSZ0Pkp52YN+tru5P3MzcOkFMhKdbG5?=
 =?us-ascii?Q?fYMo2ziqj8hZ0fHKt7uR534cq03tG6talom/1c7fdqeIMI3jQIiol+5OEE3b?=
 =?us-ascii?Q?Xn8NX1/nb8FvmKIS/cVdzS4ueKyqJg0djCZYoxTT2RBsVXrHd4D6BImzulEz?=
 =?us-ascii?Q?sD6ZAgP9KRvPEBskWznvFlSY88BnBBm/pHWlDEK+jQuUqKfx/YwHg5OkNq/d?=
 =?us-ascii?Q?QdPla5r4paTx6Jw+Xu84LpuIGjlQG8Mm/OoGUWvuhbAcsw2eBJrAtHUJafcX?=
 =?us-ascii?Q?3ncPwoLnDKanIs3rJHd4O4xwDzhyLe80F69w4s30YH6CYUtBGd9892vMp+Rk?=
 =?us-ascii?Q?3SZekLGTLreH6FuaGMrt3xONtuIhAOIHXhHpaCIHxF7cwAECV+zTzE66dpzP?=
 =?us-ascii?Q?vCXjcWCR4NsisaIHYzdtgfgQY2uhUW92pm2ZKCYG4VTqSRzWqAxsIgCXBm7I?=
 =?us-ascii?Q?C7pbQTOQtReo6i6zFIejZ6woJ60Zoc0GvD+HadXZjc2VAyyoE8219LIg0sTA?=
 =?us-ascii?Q?Xty6zawg5exEx2QjS5txtOBRkMotR1kLrVX0bd53MA6AtQ/BI7Tuj0Ix/Tqm?=
 =?us-ascii?Q?2aAdB9L6+mPvYd4hXy4fNfezAkG48mc3YtZnlkFvvgfywQCMbH0YdjYOUzCv?=
 =?us-ascii?Q?USYpBJT8SYaw7BfkzVBdVoUmyVost4rhLm0OcPYDU6tI8gLOUwjmUPf1Tlwj?=
 =?us-ascii?Q?quS027pTYmyu3F+ICq/jjNxJeMhSB9+QpWMl58e/x83iGVgxlIQQi8aRc+z8?=
 =?us-ascii?Q?/912JPGSj9QBUZu+wP7yJiZc1h32zgdfuX0sKeHe0WwYvfnIMFpGDCkdWKai?=
 =?us-ascii?Q?caIWtxZQ8PYLoiBwwI41GWnQtzXqYbiLwJNGEP+sq2MNSxo6a6rfQlCLgZ9i?=
 =?us-ascii?Q?UyEMssG4bWoy/pacQNWHczfrAZd8EJw=3D?=
X-Exchange-RoutingPolicyChecked:
	eDmnbKTmGowJ0Kfz8VlpuiVcfaschCjMnP/bL0UxXCUGQPpDi3+mC4EWdt5fQ3v6s9Ay9DVzJPP4Isy8LAmccHyxCwzgAU86pFNZ6pKIx4IH628ffG6TuyNWNaBDwDpay6NZr2cZ0EsF+WgKTnTVNahDMn4gjgCYTzeS6wftwgPRJ1z1JCYhNJklNX5vivgi8+wehuye84Zh8Xr2QYbbX/q/50V0O5QferBaEigEkylwrG6oTtr/Vr0Uo+776wQ+N7UgdVKC+Pky4jqB6uKRjq3HMf3exq3ySstER4/HFjex6bbD/uVGEB499WS3yyZ4yjJk8c8HrjfbSKm3ne4hNQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WmAyC1MvcQ/l05VKmZAnXOabe44mrOEX2QDCE4nQGJLBUKF6KJGCDXTjuv9bF9oUzuKqwI1O6DBLKPgt1Bo0d6bHwQimi8F3OqBwEdc4vEHixN4zWfVdGN/j8yriyRiCwlwWAxF2MR5X7jngE654QzScYK3xltMkyoBf9ldgzxV4VKB32LjWyBMvVnzScOiu8WqC69ryqOJ1TjFsdFaGAktXKitFyobYPGV87O0Cd5t+uFNdzQqAnIFhqSsl+o/Z0mGLwKl+q4nceHh1hSWe/dE9F9VWBMW77ArUxTK18/JCBAMryq38vZXntc4A/itNfKgI62cpZ1ww3EoayoULHpvssBw1YqB4OUehdPWFiT0QvVxTJxTHGwVfloL9dtEzevc+C9K0TYxixLk6dpO9Gb10Io3u4IZ5cCNEec6yoOk5Nx95jlLAnbjOrKVmVHe8hPEwH4egUZYf+dcwwZz0EDF/lAPs3/ldq/zM4L21zPn8ZcImg6ltzuICRdlhNLKs9Ep5Du5CApIMC3EFkqSKVdl+/X5fjUdoKNKxrcLtmRx+79uIEmsEOopIJ3aLMHB8+TGWMDM7dmJIpDgoSnxYAe0/wVpsSnUwB8LvbKAoVeE9dnd/C7cCSbPrPpPWVlFm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f69a720-224b-4732-ec9e-08deadd9b0de
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2026 14:46:02.3334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aFRjGW9GEntoWIjk4IbD7IwNG9fC5XIT1tRwpULd/LUA+kVu0LchymnKvez+Zrdmhe/0BFukyb2HHFt7d9RoBKI0ZPxSJkzGGNftuoZFAWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR04MB10093

Hi David and all,

I found btrfs/003 and other test cases of fstests fail with the latest btrfs-
progs at the devel branch tip. The message "mkfs failed" is observed at the
failures [1]. I bisected and found the btrfs-progs commit below triggers the
failure.

    ec8324cc4b8b ("btrfs-progs: help: adjust alignment of text")

This commit modified the help message of mkfs.btrfs command.

I found fstests checks the help message and greps with the pattern
"[[:space:]]-f[[:space:]|,]" in set_mkfs_prog_path_with_opts() [2]. The grep
succeeds before the commit, since it had spaces before "-f".

$ mkfs.btrfs --help |& grep -e "--force"
    -f, --force               force overwrite of existing filesystem

However, it fails to after the commit, since there is no space before "-f".

$ mkfs.btrfs --help |& grep -e "--force"
-f, --force               force overwrite of existing filesystem

Then, fstests no longer adds -f option to  not add $MKFS_BTRFS_PROGS.

Is this a known failure? If not, actions for fix will be appreciated.



[1]

$ sudo ./check btrfs/003
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 redsun115 7.1.0-rc2-kts-btrfs #1 SMP PREEMPT_DYNAMIC Sat May  9 03:03:55 JST 2026
MKFS_OPTIONS  -- -f /dev/nullb1
MOUNT_OPTIONS -- -o enospc_debug -o context=system_u:object_r:root_t:s0 /dev/nullb1 /var/kts/scratch

btrfs/003    55s ... [failed, exit status 1]- output mismatch (see /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad)
    --- tests/btrfs/003.out     2026-05-09 03:07:52.952213772 +0900
    +++ /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad     2026-05-09 23:32:17.595751435 +0900
    @@ -1,2 +1,3 @@
     QA output created by 003
    -Silence is golden
    +mkfs failed
    +(see /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.full for details)
    ...
    (Run 'diff -u /home/kts/kernel-test-suite/src/xfstests/tests/btrfs/003.out /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad'  to see the entire diff)
Ran: btrfs/003
Failures: btrfs/003
Failed 1 of 1 tests


[2] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/common/config?h=for-next#n106

