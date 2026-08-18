Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9784448388
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045077; cv=fail; b=HKfEVB1nm6pzLMe/LPgLdk41nj3bxPQs/IKfiSdwq4iXRlJyfOPq9HC3sL4hua0uKdlAranLqCvv3fj5BbeFQU8dF87+kLejEgJkONodyLHQWarHYRmyrkFyK/hyfuOorbfjmQd41iTvZN3R14Ila8by1UMY9xtNg+YfGQPZWPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045077; c=relaxed/simple;
	bh=nypzIjQR6TbMRMfT/GwUxhtfNYoDWnryjAJHSWVdtnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t3h11/zNJE+Lf6DI7IFtm8uF1N7iR/67OtFFEmVbW4qwrvXqyhJRy7zeO36sHsmTwDF0vDCANUnQUY+YMKHr1YRkiwc0BznxzjEaroPJcJ3SeH9SxsZsIEc2QbyTK0U7DFEYE2LtGUxKf2YOtqtwC6c/pH2sMPT/ys3O0JRaIFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hBCn6Oz3; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=hSpWSzG0; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hBCn6Oz3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hSpWSzG0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787045075; x=1818581075;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=nypzIjQR6TbMRMfT/GwUxhtfNYoDWnryjAJHSWVdtnE=;
  b=hBCn6Oz3zHiiK6ycD472Jlsy8P0oIhFqg3L1RGUQJH2Wq5S230XNsrFe
   RuUtrWPfWylSZkvl144Ufs/A6HbBht7z6+XhrVrfeRnkNXhU/eiuWp1Li
   mfHwhAxzazmKDihTBG09aWSo29ukxn2kCTltgZDXN3E8GX4j+oQ3PEuOl
   5LaREfm4z9mh+0n6rGh4wF4kvF7Dt6eTjoaMdcBCGQCw7/9zZnc2YtJBK
   MbULSOcBiqEp++QJZvQFdoczt/cSOa55/sq7jy9fbNjwxNMW3dil6oGHM
   qhgD1GngXn6wgaeLaBpHHBNRDnGWpX227aWRR9ON0RfSF1ESGsDsRgKm+
   A==;
X-CSE-ConnectionGUID: ZyzAYN0jRoGGlVX6ytwJew==
X-CSE-MsgGUID: DcTwznUfRSWydI71sWakDQ==
X-IronPort-AV: E=Sophos;i="6.25,230,1779120000"; 
   d="scan'208";a="151931453"
Received: from mail-eastus2azon11010051.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Aug 2026 17:24:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zdiplya3lMGZkuZbMf07jChSngQFc0LD3j4DMnCT+G2rPMcrBxGb8eiZnD9kK41nYv69cqBR5X4ePHtfMMd/FdXEwiN2fFbc1hsgsJmWZ3cRjsNSsQKRFVXrjWwiGW7PwSMtb/LZpz2IT2eIiXbSqdS7D1KX66LDUnjyA/GdP/j0pi4oGvp+3fyN0XWCS6Taf2TtgGDzyz5z2Vshfl1wOFdluGlqHw2dOm1BN5d5TX5a4qal0Y5KYEy8kdvzJN7ho+R+OdKcWL7haD94SHAMcc/dqjzLxbSuFW2nIbhqJBPtCV3+4H8vfQURrdcdDKm8pOL/mCGuIvlX+4werqZESg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihV/gcndn9ASFbK8NPZftRwmi9QDg9c4HTx7I2x+oUE=;
 b=CHTA1JLYAm6zPCHUAdTnTImKG+8wwm/xujmxGTL8ZGA9AUPk125h/3XtSUhmOCn8s38b+j1T7oPVLlLvSEH89LqYW6rKaKBEzSa/lpXA+wZqs9djXAYr0xMxTsI/e+nA8wgF2NpphlaNDGIqjFDIrjZcoILq/XEiGj2BDzMs+mjhbS4wNMkq++tSmPAPY4S8vJSU5ZkrGBOTwWWdkp2vWZHLpQGNTVCRfsLEdttBFnF9Fdef8BoPAr1+OmJ6EaqraSOqj2L3cYjSN80h1jf9393sk1s3Z5esrri9Lcw8S1LpvwINbXYxiqO/5vW5X/ldnV83dL37Elk6IqeLbs7aNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihV/gcndn9ASFbK8NPZftRwmi9QDg9c4HTx7I2x+oUE=;
 b=hSpWSzG09clVLhf9KnhnK/U9feVjuTF9h3TZfWN/K1QgpsbuiyQ8vzMsPPuwZvex7aEz8f3CgAz9eU0yulmgInJKS+4dPSN4Siaa3raIEUJWDHAKgReboDOfgtg8WeaNL29jaoZTSST2cDxKI8W6qXPWHyIUI4e0XVCSEVTH1TQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH5PR04MB9623.namprd04.prod.outlook.com (2603:10b6:610:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 09:24:25 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 09:24:25 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/2] btrfs-progs: check: detect leaked active zones on zoned devices
Date: Tue, 18 Aug 2026 11:23:52 +0200
Message-ID: <20260818092352.1364853-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260818092352.1364853-1-johannes.thumshirn@wdc.com>
References: <20260818092352.1364853-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b9::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH5PR04MB9623:EE_
X-MS-Office365-Filtering-Correlation-Id: fd5c1f79-5187-4330-9088-08defd0a7ef5
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|19092799006|376014|10067099003|56012099006|6133799003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 WQV90Xxy+iADqfV/mnVgYU51ckZMWKqkCikYOZp5W9amiKqEf8TzIXN7QfWxhSNB57tZIu5vp/2qt9U/G+8zqSs2lQlI+GiVk8tAJ9L1YIx3crQ8IKuYGIxFQ6uX5/a4+1zFkIF8sOzCERu6fTeu+gB0K0d2X24J3VsDLvE5MgWskQOy0Tzk0bwc400GZV+WcIiW5K4PXlXxd8HOle2v27XpkVshjhY1GAbcIzPrfZGeJazX9YMJi1ajY5kWOzPymcWzNflqlfgEzw6B21tzJ/PeBiCIB7iLSzAvKDYgNVbqSPaA66wiYZ9hM8mZheKjhNdzJMYabesOvYl3iAcXp4d+glBhS4mv2bSVSxmUhLUdCgOw+Iv8YQwxiEqXwCacBFVRwMkrN99VaFKTh+xIPG/nr+XvSxDYLpF8/yNxXzY6qeHElbTKWohED+5Dhl0TpiFvGV/tVLxFEYAMr0NHLpGSs6mpqSym1OU+Jv5q1Wz7vxwopymx3PO9JKjnpxRpnptsWW9WeZasj+3N766O0vXx2sqy3kl3Mf490zL9/db0CVJd+V1elnL1LCGEQOxWMYvwiZ56596YeKEGEysc/uj9BUyDqIDrdFzwIgiAJRNgStMxzo1JaOs0f7OYMa8jBkxt65ItR7GEacb54WTcN4fGwrB726Rdss5/AD83Als=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(19092799006)(376014)(10067099003)(56012099006)(6133799003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?pmOKyegLPWQV5O+P97LtUr2NhXDSB2jdUCxtiSJamjCXsvS57ehQ40+Yb1oR?=
 =?us-ascii?Q?cqtzYn1N8C8kwOrIkIF3H9K8i0m9wfP6v7S42lzZll1gV53t5gj6zqQKVp0I?=
 =?us-ascii?Q?VfPxnFx9JIxfy9Jf2XUI1qQNiinGY55Rd1+xbL0fdzOKQJjaMLqH50e0MYgA?=
 =?us-ascii?Q?UUgCOzlwx2kQZRhuIUh+9DFepoBl+JbtrwqB5zcPB5vJaAYzxsKflf9BuRaD?=
 =?us-ascii?Q?SjywpnjH4tA0mrBtbUaPa8Fmfwyx0HrQhmNT5VjeM5lmVLhuvWtE/02PG/YW?=
 =?us-ascii?Q?BmaX4UsTrS5iCFrK5hZG9sUoj4Cu7Ph6J90amdH6egUaCIdtHUkYaR9dNiBX?=
 =?us-ascii?Q?f7N36lNEVBOx1aDmtI0o52P3zUTGDKhVHBsog3OnDBVEv5pTttCxyVs23otS?=
 =?us-ascii?Q?qGfvS26Ldt+OZJL78Cy4pzk28/FEagB1s5NfTSiDGGgfevGeTIZNcZU0283Y?=
 =?us-ascii?Q?C3t+5Rl5HFRLiI9RQlf9C6sY3xQYK/JgI6QDpsJdgCifGcRJNt2F3dYzy4Ae?=
 =?us-ascii?Q?YXmbNtQDyYwkB24LYesvyDsYBuY+5/X9gCYlLMUWjdr4GVOGcTGwN/LPGLNB?=
 =?us-ascii?Q?Wb2xhREkluvtCkDAgyTrt09gwWjehF9xtVPpasPxeNLQFJTX5G8JwtOCETc/?=
 =?us-ascii?Q?O14GKTmk23r9wq5Xs4S96EJ0MXKDtI4D1s3ftHCNBDXVe2oUn5rQIWr0Km7a?=
 =?us-ascii?Q?45TfQq5tM5xYuxO9T7ykXqE5fg8t51jCGAKCt40dqM0qG0yZvijQ1ZcM2zGV?=
 =?us-ascii?Q?kOy6UxIO8utg7e+op9GBT3+4CwOLE+sqLnhWFwxutBuCX5dN8J0nlBOn//b0?=
 =?us-ascii?Q?SY/ettDVeP2nK4gTUdrmts++5qSKCb1yrv91CykkE6zv6YBQ1/MEJOUf4a+e?=
 =?us-ascii?Q?pzrje9m0m+WlFbiwydOXrKPd0iv3wGyPZUibLzGxj6oDwmh6aRxq/o5Sn+v6?=
 =?us-ascii?Q?bP8ykXRFgQdSSR9rU+/FHXbaNceEXf5HU5h2Dq2EzUUoun6Ef9VZE8AXhkti?=
 =?us-ascii?Q?wRcC8OLioqLvTj1sn2S+K/w3PEpyzj7wqPLB7tztnf3g0Dl1jE0BPft0wnq3?=
 =?us-ascii?Q?znLW0FV9i/DVofr+nFD2QqoJK2Z2ZzcgmR/QEqRLnRWVOx9HHBHs37UO+yPl?=
 =?us-ascii?Q?nbjdU9CuCC2k5SBZGUHan/sNe59o7UnGCsEjmDRNCKcZg5uuSZq3olkNGlr1?=
 =?us-ascii?Q?f99Qplvu7mR1DJe8U7P49b+JUnZkXI/jI6EUh6DEaiyhmqhuyT6lWnAet7nP?=
 =?us-ascii?Q?3fjnVgT7lmThA0Jtwf+Rtg3W2H+2Y/oi3QFTLuMvonGATpkR0Z7wW80xgdri?=
 =?us-ascii?Q?/GRT5uCRDuH1V0InfJ74wMTdzCYUT7YNwbkT1pjSDsPRFNXdRbhEzvZqf2/o?=
 =?us-ascii?Q?wOVVxz6hSLlDAPpvTO7BTyA01rHDoJ3pMccU6hpBCeEZeDX6HAxm/gNAWjDR?=
 =?us-ascii?Q?viimseEeCghaoEcWQqjELD9I0Ldn2BY7imyDmXfYcy6UasFY7Ni0IVjwzjA6?=
 =?us-ascii?Q?AtP8Tu3xkoK0H8p2cJ3y2hdWX5L8jF3v3VR2Ru+l9rVgvSv4Yp1TggPiYcCX?=
 =?us-ascii?Q?ohXsIjbuuxilYYQVC1NNuoCszYAkWqG6bV167DSj2X5jGu3H3Q/uRFz/t4BU?=
 =?us-ascii?Q?3DOkjl0+47jukmBfieQWoIvCDeHiltXaCDIlNVSFyX5Cwn4Osl9treFXGKsy?=
 =?us-ascii?Q?+h/WbMZ35epEBRBlVyCyS1kBQKp3si0aNKZ7muRDBrp2j3KOnm9iT55x0Qri?=
 =?us-ascii?Q?xRjV55Xe19YY/RMVm8edIArqJBfTXt2Os+Www7veojA/nuaSBbVG0vmYX8Se?=
X-MS-Exchange-AntiSpam-MessageData-1: Ujqv438hSHu3HvsWfpYxLTadzOW1ppLGg0o=
X-Exchange-RoutingPolicyChecked:
	QpEtGIvVamtohV2iOdwId/j7YKEViKnpWnkI+M2/htLRNkNy8GjIXnHSCAPPVCbJ35RZZv8uTSnGdxnhRFswtGaoP/8et7DP6W7Ydwsiqz52zc3crGAGXMqzfnmoG0JSgfRquzyjQUc1sW3KpPtKPPcRqSd70xv5By7vwoepuTDwpRwAmtFB4+SOokjjYZMLljruXBChlbLBDSIAPaC4dTlYnbEJ4S/uMIAFVGO3tHcILs15z8vegAQdQHzwUostPcxoPLNYqG6MUGpK43VoU8ip6vo28yjUxO2ckVoTEU0kE94R3b2WrY8hWrCT9Jb3mj20fVEaNWyjZyGG2R5u7Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O8HAx7JYy+CO4A05ZG7JoEGyn8p7SuI2N+ocQ4Emy6oEI4k6p+1SPDCT3LWeWDx00wrj+Xegb/mwItFiH8zTNFpGMREpefOeOFurVqWkK66be2Z73ouLoO7+BOPn5Zu5hSxU00MuOEvjiDc04x32b8Ltyusxx0Ye1hyrnBbwYxXTQLeBJucp67M7qsn1ah5ppCkiTNC8pXwBhdBi+0iGlYmwkeGPz63FIXpnuNV2roBqMJkdx630qeK9RYCKS5lSR3Ci0sU5ThkFCyrSAUQ18yGALkc6u0EOnRIhFwaYsGI7PlwTLspTlmTROtJCdV36Lced2uSgqUg/oEaUBLEDbMZ03AHUggqgmu0TcYbv+09WTNjjeaNpH8681U19PcJ6jLWHn07H9XWzfzG5jw5/5ona6WE7lHPMU0eZuakQWIAysq7EzzVbZ79raQd8bg1XuFZyXqi0dLIlEvoEqK/KAlPDxesCDipg5xAYW3sDrMYQ5PCsZLmuMGwQ+xuOxz7oo2P6HSVPyiZX0Lz1cPnVOVH1Jv6/DtN0ROl0BJqviR4fN5fPfIX5gr4meS3FZbrMSFE8W4zXWL1iDK58JXOjhjhc9lJcJZz5ff3ijFFDqTqM+UuZBLcNUUFcetAqNCGd
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5c1f79-5187-4330-9088-08defd0a7ef5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 09:24:25.8090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BpRsvCiYUIpdZ39g1ZJCy1vCa/Lkn7BcSKrlqAa2wuXIxwIUPnwg6/IfLcSHK2JuObV5eLUPNolFVvh6gCkzSpFYJJ5xvWtFat8HmRgUrPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH5PR04MB9623

On a zoned filesystem a sequential zone can end up open (and written) on
the device while it is not referenced by any dev extent and is not in a
sb-log zone. Such a zone is unreferenced - its space is free according to
the device tree - yet it stays active on the device, permanently consuming
one of the device's limited active zones. On a device with few active
zones this can lead to premature ENOSPC and/or allocation hangs.

One way to end up in this state is a mkfs that failed to reset a
temporary chunk's zone before finishing (fixed in a preceding commit).
Existing filesystems created by such a mkfs need a way to detect and
repair the condition.

Add a zoned device specific check that cross-checks the on-disk metadata
against the physical zone state of the device. It flags any written,
sequential zone that is not backed by a dev extent, and in
--repair mode resets it. The check is a no-op on non-zoned filesystems and
runs as part of the extent/device checking rather than as a separate
numbered check phase.

Introduce check_zoned() as a entry point for future zoned device checks.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 check/main.c | 154 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 153 insertions(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index a60b9b0b..37de9a36 100644
--- a/check/main.c
+++ b/check/main.c
@@ -47,6 +47,7 @@
 #include "kernel-shared/ulist.h"
 #include "kernel-shared/file-item.h"
 #include "kernel-shared/tree-checker.h"
+#include "kernel-shared/zoned.h"
 #include "common/defs.h"
 #include "common/extent-cache.h"
 #include "common/internal.h"
@@ -9124,6 +9125,150 @@ out:
 	return ret;
 }
 
+/*
+ * On a zoned filesystem, find sequential zones that are open/written on the
+ * device but are not backed by any dev extent and are not superblock log
+ * zones. Such a zone is unreferenced yet it stays 'active' on the device,
+ * permanently consuming one of the device's limited active zones. This can
+ * cause premature ENOSPC or, on filesystems with a small number of active
+ * zones, allocation hangs.
+ */
+static int check_zoned_active_zones(void)
+{
+	struct btrfs_root *dev_root = gfs_info->dev_root;
+	struct btrfs_device *dev;
+	int ret = 0;
+
+	list_for_each_entry(dev, &gfs_info->fs_devices->devices, dev_list) {
+		struct btrfs_zoned_device_info *zinfo = dev->zone_info;
+		struct btrfs_path path = { 0 };
+		struct btrfs_key key;
+		unsigned long *covered;
+		int shift;
+		int i;
+
+		if (!zinfo || zinfo->model == ZONED_NONE)
+			continue;
+
+		shift = ilog2(zinfo->zone_size);
+		covered = calloc(BITS_TO_LONGS(zinfo->nr_zones),
+				 sizeof(unsigned long));
+		if (!covered)
+			return -ENOMEM;
+
+		/* Superblock log zones are written but not backed by a chunk. */
+		for (int mirror = 0; mirror < BTRFS_SUPER_MIRROR_MAX; mirror++) {
+			u32 sb_zno = sb_zone_number(shift, mirror);
+
+			if (sb_zno + BTRFS_NR_SB_LOG_ZONES > zinfo->nr_zones)
+				continue;
+			for (i = 0; i < BTRFS_NR_SB_LOG_ZONES; i++)
+				set_bit(sb_zno + i, covered);
+		}
+
+		key.objectid = dev->devid;
+		key.type = BTRFS_DEV_EXTENT_KEY;
+		key.offset = 0;
+		ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
+		if (ret < 0) {
+			btrfs_release_path(&path);
+			free(covered);
+			return ret;
+		}
+
+		while (1) {
+			struct btrfs_dev_extent *devext;
+			u64 pstart, plen, zno;
+
+			if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
+				ret = btrfs_next_leaf(dev_root, &path);
+				if (ret < 0) {
+					btrfs_release_path(&path);
+					free(covered);
+					return ret;
+				}
+				if (ret > 0)
+					break;
+			}
+
+			btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+			if (key.objectid != dev->devid ||
+			    key.type != BTRFS_DEV_EXTENT_KEY)
+				break;
+
+			devext = btrfs_item_ptr(path.nodes[0], path.slots[0],
+					    struct btrfs_dev_extent);
+			pstart = key.offset;
+			plen = btrfs_dev_extent_length(path.nodes[0], devext);
+			for (zno = pstart >> shift;
+			     zno <= (pstart + plen - 1) >> shift; zno++) {
+				if (zno < zinfo->nr_zones)
+					set_bit(zno, covered);
+			}
+			path.slots[0]++;
+		}
+		btrfs_release_path(&path);
+
+		for (i = 0; i < zinfo->nr_zones; i++) {
+			struct blk_zone *zone = &zinfo->zones[i];
+
+			if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+				continue;
+			if (zone->cond == BLK_ZONE_COND_EMPTY)
+				continue;
+			if (test_bit(i, covered))
+				continue;
+
+			ret = 1;
+			error(
+"zoned: devid %llu zone %u is open/written but not referenced by any block group",
+			      dev->devid, i);
+			if (opt_check_repair) {
+				ret = btrfs_reset_dev_zone(dev->fd, zone);
+				if (ret) {
+					error(
+"zoned: failed to reset leaked zone %u on devid %llu: %m",
+					      i, dev->devid);
+					free(covered);
+					return ret;
+				}
+				printf("Reset leaked active zone %u on devid %llu\n",
+				       i, dev->devid);
+			}
+		}
+		free(covered);
+	}
+
+	return ret;
+}
+
+/*
+ * Zoned device consistency checks.
+ *
+ * These cross-check the on-disk metadata against the physical zone state of
+ * the underlying zoned device(s), as opposed to the tree-internal consistency
+ * checks done elsewhere. They are a no-op on non-zoned filesystems and are run
+ * as part of the device checking, not as a separate numbered check phase.
+ *
+ * Return 0 if clean, 1 if a problem was found (and not repaired), or a
+ * negative errno on a fatal error.
+ */
+static int check_zoned(void)
+{
+	int err = 0;
+	int ret;
+
+	if (!btrfs_is_zoned(gfs_info))
+		return 0;
+
+	ret = check_zoned_active_zones();
+	if (ret < 0)
+		return ret;
+	err |= ret;
+
+	return err;
+}
+
 /*
  * Check if all dev extents are valid (not overlapping nor beyond device
  * boundary).
@@ -9409,7 +9554,14 @@ static int do_check_chunks_and_extents(void)
 		return ret;
 
 	ret = check_and_repair_super_num_devs(gfs_info);
-	return ret;
+	if (ret)
+		return ret;
+
+	/*
+	 * Zoned device consistency checks. Not a separate numbered phase, run
+	 * as part of the extent/device checking. No-op on non-zoned.
+	 */
+	return check_zoned();
 }
 
 static struct extent_buffer *btrfs_fsck_clear_root(
-- 
2.55.0

