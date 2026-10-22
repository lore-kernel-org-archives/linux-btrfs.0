Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792660088;
	b=GGvLXO4g4Y7a8cZYrRqS7brGgUG+ZN2fXIwFjg8CshMSEbm7kTLgMyUrlBBPEDKuDIyJ
	 TtXB0d54yxsLP2+o+2oCIWPgDZhz+Mlh7fopNXz2gMnGEK9OoHjXG7cVoaKBoerzJm9Xv
	 Shq9SJuM8gLqBsgREwbVLszisUTR0EJTzvPYN5QSkTJvW8e8Gs3KRbyJE+woTgLQIT7sd
	 HaVq7L6zdYljn87a1E6bdM5lZpy0eacSnnGfNqieXjHp0luYKM1ZQsBduHciDkNnJttFr
	 +XcQz42CwZmKulAOLTldzKnWe2b5ShwQUoDKGJUUpPS+rNwRwmRlgHrk0ylkPokxMgw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660088;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=LPpHRkHJRPGxtmhPIaW0P72HzDsuAUoKiXPOfYk+zPY=;
	b=sbqSCYd0OmbHK2fBwM6fb5/jvIUcPp9QGWWgbXlgtSYgkN50VtBnyO5w1vhGqWyXGPOc
	 kQAhlrFqlWws+Ducdvb6uZsP/Ur6i7uIffcF0Pm7ZMdPKGhsZerpGVu/u6YS5KoSqaveu
	 rQQg3qxKjuzbqcO6/160gJMDihMqAIiwvZCgHUdGbzTUBfWJ29lO43J2Kq+Jon8e1ilvh
	 YBsWudh50qmoOs+7uf2OIcIkLY5I76bL9Ap7+9uoAJeDdr4IReHdoBGBA6nvdZqGb55xp
	 es/kouO6dVh1XS/8Td7DEhS7WG9AO5g+s/Zie+sJbwhNgUFn7FVhE6nGJ24UKmsKdhw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="L/rHanHi";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=r3M7Ei4H;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9E2606A31B;
	Thu, 22 Oct 2026 09:08:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA9E2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=L/rHanHi;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=r3M7Ei4H
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792660087; x=1824196087;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=gikLVabHfPGdpptacCWcEWrxRlZgR9V5RtKl6LfcIgk=;
  b=L/rHanHiGLfQbqw6VHIbb0Xb/JEm+/QILS+qVmOH60/pvIw/U5Q+461F
   ugnG2ARRYa20uMvpELcpT84BuFtyHeZ4QQoeg1cg4RzpxuFcJp1PkMEjC
   neS/TltHMv7qQK8tNYX6fwhTiSN9iZ9dr8729xUsJ+DL30hdWzn/86KtY
   MpZGSU27naiTheB5p4AI+Sitj6iQzulCeBC0W7sBKoGaTzyEj6l5D3Rox
   d3iwAGl5UZIOTZdyakzgiVbm5ffF5Iy1SMqDxkQLCc7KIFtC4+RSAmIz9
   gGYI8WgGxV4D7nTrvrlTAWcEuGFHlOLd2G9ZcKjgfHUWR6NRCs2rggP0y
   w==;
X-CSE-ConnectionGUID: hmY9vjkwTC2zx8qYwKG5Dw==
X-CSE-MsgGUID: /WuvOX98Q96+AzSeJCeCrw==
X-IronPort-AV: E=Sophos;i="6.27,171,1786982400"; 
   d="scan'208";a="157763378"
Received: from mail-southcentralusazon11012007.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.7])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Oct 2026 17:08:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQH++ODMzxu69QkF4kJC4gMY4BgAxMMWWORUK2uyMcFca+r/gmi4TtJnQ1VHwdJIaYTPbwxsMWyWwauCMkOAppI17NNcxZkqVCK7JyBYUQO1On8HOXiI2baPy8MvZIv2I7W+FEUivY4rbBCdf7iU57aQal3IYkxaeU+JlDNVuHh8aR4oU/g4Vse8RVMkv3OcdMFVkHgne2k8jLnFbMTUslR8Ypn2cD/cXVyDlymE/pHd5akOWbtL3ZvCnmaPk7S/O1nj5qfYQpHrVPYcjkFCPa/Bmkn8NWKtORzjuhnDZDnI7ld8s/OMILf2G4nS49AvkAWEBrh5XKJ5H+85Se3fSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LPpHRkHJRPGxtmhPIaW0P72HzDsuAUoKiXPOfYk+zPY=;
 b=piHYvGD/HG+1nyZaAVs1NmvidJ4FvleHiFHCRkbr/ZbGQsO0eCB1AMpAwnVnA2mwnYcGLIioOw9WNOjsEAtMo90BNu4ykh2ga5kOgjnI4qUZqsHaPyagzTtUvPxOU5vHo5IcYBmuIac5FzcHmzGCpDn8dJ7TuEHrqZ1Rem6EMCH1AkxO5BH2Kcug9tSW/sWyvmYxvlwYSAh3+wccEsJcF3w6dji1dI66bGGb2ASYBv3cCpwUIHZwmmSKZW9zQxsftUr9/2MiuF5z0ptbCkoC4Dw0QRzmk6py6lfpZuroa4XDxc8MytoRY09N25pDbUW0N5MkCwCfiusej10I/Fb8QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPpHRkHJRPGxtmhPIaW0P72HzDsuAUoKiXPOfYk+zPY=;
 b=r3M7Ei4HUJcHV0f2+hz83g2vKM3mkstpqVDKNqPtDLDEP2YDcUeDwDvnYqZP85I3mm8pKpdxjH49SaFvviZHnGXG0ZLdYiLJ0Cwr6I3tCV8ZM/UhiSUCZaa7Mya+eDyOxRzQ3LGfRQl4Wev1jYJM1b2K756rmdFzvH/RRP9yg0g=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH8PR04MB993982.namprd04.prod.outlook.com (2603:10b6:610:2ec::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Thu, 22 Oct
 2026 09:08:05 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Thu, 22 Oct 2026
 09:08:05 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Zorro Lang <zlang@redhat.com>,
	fstests@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] btrfs: test that fsynced data on a RAID stripe tree survives a power failure
Date: Thu, 22 Oct 2026 11:07:54 +0200
Message-ID: <20261022090754.2584747-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::17) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH8PR04MB993982:EE_
X-MS-Office365-Filtering-Correlation-Id: a1522aee-e0e5-4c97-05dd-08df301bfb84
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|1800799024|10070799003|23010399003|376014|6133799003|10067099003|18002099003|3023799007|261009223027099003|11063799006|261021121427099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	WcuPKouk2jHuASrVuYLKlXIAU3BGUaLmDb6BeZKG4UTOwFrDDfPRBwiMQfXFeynLmgQnvONE9Is2cXEFi1CGHuSl4SBzg2N+lAMB4geLkoTckiqCCAJRAgcx74EDAQVgO3OT11CjmD1nJFRKJuSIWE+YJl8G6tmcK1FG6aEPLHv8lrN6pqGUM3UCbSwAGabjvUuW/pzjK/6O1bAJ3u8cQnUTzrrAdvB8rQshepu4lqxUkykYQ+Vx0EiKPJasL+d+V6RZ2he/Hh77HVg+BFTBP5N9ADg5oTWykUPDBbszqg/sYcPlx307Foryw/Btkk0VfxpO1tH9Zbw4MT1oIwkPCheZwy2VAEYSK6SvZuW/LK642FrvJtjMT7YYRv3slkJi3d0p+7tVO6a8TanFJmFTumac+ghM+xZr9KGDNtSuu6W9QH1J+H3EMqIogTTKruXIEDHyAVxW12YP01UzZPU7A4Cmk/w2uYW1aimQSE0KSRu6JTM4cjqYQSAMoxFqMv0AHn/HgfWnF84TRhGugz2CjAOCJJZNAWIFHow8lDTx6yNG9UicK6kNUXymhZpd0ABUwe9kYOfCgvGAxkl0Nd8pmMUaDB8t40b6INbHg8kqvASFMaRMT3H2iyFTFosrmW2xmAwHwKwv4Xy1fvjlYRZ4gzMBtmAe5TPXD2atRE0DtCU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(10070799003)(23010399003)(376014)(6133799003)(10067099003)(18002099003)(3023799007)(261009223027099003)(11063799006)(261021121427099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9czaqwArdUGhr320AsJiYpA2VcwCqa5dMoN9v6SXy1EXCiNk7RIo2rOq/aNV?=
 =?us-ascii?Q?4Nr6p3o77QXbsxy7ACMRlvs/+/hbGsrdSy4lCfFzx1AgBG9pKTkd46oxHQQT?=
 =?us-ascii?Q?9VoxbYwK9g+1HzUANiaX1MH0EGfX2iGpsity+QxMQwSy10eWdO/akLxU08cJ?=
 =?us-ascii?Q?LRT3nucs4Pr9J79WibfgrI4rPevmEogf8unagpJGvlQxYJdONJC/zyJ9s5IL?=
 =?us-ascii?Q?7HUjn7m7vIkhBQAbLsk5b9UDyNc+33ZszMXqhOmpGc/RP+TUrZXP9iGjjjtu?=
 =?us-ascii?Q?fkkI7BEkLyuPvCqwF/6A+nRo/CDvVoTnJfFipPplklV9AjpWHOonsevYu4Iu?=
 =?us-ascii?Q?EhubDvibVE7Em2UiyauKnMX5g/ghlz0lMWJfuHa8KxHKC9BVmUUdAqESUnlX?=
 =?us-ascii?Q?aCilqnISwtWEJiN3If0Ot7O8psYtI80XRmj+JlqL2J0g6zUI3tyLjcl/6lR5?=
 =?us-ascii?Q?hOXDT/9uRRcV1qBKsTiE9bpq91294J69MUj4zeTC5eIi6CxdX3q3gYNhp4wf?=
 =?us-ascii?Q?CrbXkLvUMLJd+IiLjYysI+z/vvFvmBL//T4/P02xrfQTcbTNKNohHvrTumrj?=
 =?us-ascii?Q?TdtcA4lUbz7KSxycH2un/Pymaow6e99mnO7lJ0JOJxMOcq8JMtdIo8CRt0di?=
 =?us-ascii?Q?J5BasU3Qtqm//GvfHQliCjSlUD/uxT5cEV5f16+qfensRN46gWJbawoMxUwA?=
 =?us-ascii?Q?AfPfTXjriHd+BM/ZklsVziBw4y1YhQtpHqtBr93OCD9cUUhj5IJlsKAus4jB?=
 =?us-ascii?Q?5EExRa+fwWaAGW37OHROMnMLPATMjedlP2AEhT+nWVtetMJgHQMHpq3Tsob5?=
 =?us-ascii?Q?RBTxlqzdPhff2E84sOgIIRPVxjfkHUaLTVaiSe+XQFbCXfo+I9J3ItFFJYyY?=
 =?us-ascii?Q?z4NBsqfo4AoNZKpROGQsOcMwkQyJsSyZIdqWOTMV+m9e/qrrz6CwbYLl2apG?=
 =?us-ascii?Q?+uoV7whZgkXOC/h6uuTi235Np826FBJ5m+WUtDWf9JVPe571niE5Xo9roroJ?=
 =?us-ascii?Q?oR2tBJh0ReVavIE2RAScp6R1PdzKFhBvpPssonNtHWQjJtkyOWw1vOqfbYcA?=
 =?us-ascii?Q?w9Djj1SMcrzUsAZZe0Kh5m+LU+l50XwtXEtgxQL+IUO1tQkl0sOMRPjLqR1E?=
 =?us-ascii?Q?M6srMay2Edz6s8S8tgZ/6xUMEuwwtarJdpJoapCJkO2HHsOli/r2seU8gpC9?=
 =?us-ascii?Q?EOV/OLUnWMJzPm0LG3lp6LAtMTwxtOifUCtsx17ML7eo8hUb+6r4yaxJDSiN?=
 =?us-ascii?Q?BVZZUHUVDt1yCFhPJFBDPSKGfwc9aZSvbm9WRU7yGeP3R5NeThuJyvni+wQl?=
 =?us-ascii?Q?w9q2PuCc02hvIUeNLa0QuiCutil6O1bjRSO6wSsUj8GH6030Od6j6LkeQxJJ?=
 =?us-ascii?Q?qbaWdhY4piPXep0jzY65aeZs5V3OhbCZpg/qBRei72z5Hv6E/JFlRuVsCXRn?=
 =?us-ascii?Q?N20divFY8Ni/gAT0p8wkJcLyRDEPAqcMfV+/tKOx0ZXmtD29XrI72LX01Brf?=
 =?us-ascii?Q?++EHSz4KSYXDeG1IKRKQHodKZ8UJOMEQbxis4sqJ4WwvELMYrWo4+s4geCCs?=
 =?us-ascii?Q?O/cQ2HgvWiz5ZbLUy99MfNwqVBV/zh+nha6g9ieuFC/bi4ZS9XqjCPT3sfDO?=
 =?us-ascii?Q?6X6rmB2RhYfkYlYvEEL9BpJ7ieDMH+L7Oh5lv9BPK72llAqJrzX/eatMKVtV?=
 =?us-ascii?Q?AaznT+8QYdT5NLZlYv9cCI2cCE5HzXoMuAyJS5afpEHPmHoVxrW/IIt4/9H6?=
 =?us-ascii?Q?PLwOQPXxvtoqAELmlFdz2bJSSIWNqxzx2Nk3gS5LiW5eAkTLTXG5pXuMqHI/?=
X-MS-Exchange-AntiSpam-MessageData-1: GJ+1UE1alBNhdTJOX+t4bQjGLv8vPMOZHK0=
X-Exchange-RoutingPolicyChecked:
	l5zbLXr05Y8bruA7S3vm3NjYOAo87n35v6QIlfxCaA3WM1tlJz+z1a4x1PdJFSnDHf33xQl/S78nIwmzTlbYlwJXoZf+wMOphK3Z7FHNBTKZBpOqFNcPnobUdzCQffojstLVjM+9S75esF0CiGsZuHoSC4wsjvtP+k8eP4zKJ86nW8UhPyJX6QaOGDxyl8ETn15+sf9FX/Jla9C8vBZLOi7v/4UOg1wSsXhVuzski6KjEP4+Ss0uq8rHS+i2lqCvIxC9A7EyAMKjVBNotrmaR0CSGxhUk37m7Iis0FS2UGo25PufLp7GmOUqtfwMf2Tb+y/4W8qlkrBTQrwlbh5h2A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZaFo4b3W6bsfXraRke5RsjkMzwsyMUKl3N/bYeDf2otuDk8oJt2AXGePoGqBTNue7jhKImk+3oLO8JmAGjum6yLOp237tNRh8S7ii0tFz/belHJFEQGQsLDevROYF7M+sSr3k9AThiFdrxHawHrMHy/GO54YMghv5g+lLEdGw5BjxUMeBRYV2ArfsRDZpP7LHXCVxPCaOMA0s6kkKf4SCwMBP3VIwZsWMlYugE1YCdYNRTTH41d5LJ3LwAa9UOyHHR89fhwnjk9RVek7MRRm3YBJhVyCuytsTIicU3xbWGlO/3QT1bROa4MaGOSRVivRaLZarCXijKxFnQbE/d/XlwN/pJobBYaaOW70rhOsT7wF81tfCvbtyinuoBT74mrXBKXTaUhpn0lK9dMlSu4cvY8RpQM9Iw8MbYkLyJ3kafHxGlpjFwEQfap5T96f0vhn3Yyq7NO6ubPh8HMzxnKyf8BrgfPa2HYfgzZ7ucXfUAmrS6qXylxQv/Lmikuxoacmzjd3b2zdmp03a9lQ7xNst6lnN+EOpW3tnH/Sjf0EUAryUFeA7xPHVCPuPQ9fCP6Jl59PTQ6LS4lAf6Blz0Vc6lkPdQDDOfHoYsKQcIf6/Lg1IvwlzdnTCfD/QLafxMtI
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1522aee-e0e5-4c97-05dd-08df301bfb84
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 09:08:05.3777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mGC9Fwe4blTP2D9IuLw6GWFhNZ4xXrJyJZpO2G4DYCgv/y4PHDWewBOY9fOLFOcwrZexPCVWHqj7Vy72YjaTBVORxDWPH7x29gDM4YtfH00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR04MB993982

A data extent in a block-group that uses the RAID stripe tree has its logical
to physical mapping stored in that tree, which only becomes durable when the
stripe tree is written out at transaction commit. The log tree cannot carry
that mapping, so an fsync served by the log logs a file-extent item whose
logical range could not be resolved afterwards. Log replay restored the file
with the correct size, but reading it failed with EIO.

Extents reach the log both from log_one_extent() and from copy_items(), so
cover a fast fsync and a full fsync.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes to v2:
- Also test full fsync


 tests/btrfs/363     | 67 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/363.out | 15 ++++++++++
 2 files changed, 82 insertions(+)
 create mode 100755 tests/btrfs/363
 create mode 100644 tests/btrfs/363.out

diff --git a/tests/btrfs/363 b/tests/btrfs/363
new file mode 100755
index 00000000..834f2673
--- /dev/null
+++ b/tests/btrfs/363
@@ -0,0 +1,67 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
+#
+# FS QA Test 363
+#
+# Test that data fsynced on a RAID stripe tree file system is still readable
+# after a power failure, both for a fast fsync and for a full fsync.
+#
+. ./common/preamble
+_begin_fstest auto quick log volume raid-stripe-tree
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"btrfs: force a transaction commit when fsyncing stripe-tree extents"
+
+_cleanup()
+{
+	_cleanup_flakey
+	rm -fr $tmp
+}
+
+. ./common/filter
+. ./common/dmflakey
+
+_require_btrfs_mkfs_feature "raid-stripe-tree"
+_require_btrfs_fs_feature "raid_stripe_tree"
+_require_scratch
+_require_dm_target flakey
+
+# DUP keeps its mapping in the stripe tree, so a single device is enough and
+# dm-flakey can be layered on top of it.
+_scratch_mkfs -d dup -m dup -O raid-stripe-tree >> $seqres.full 2>&1 || \
+	_fail "mkfs failed"
+
+_init_flakey
+_scratch_mount
+
+# The first fsync of an inode is always a full fsync. Do one here and then
+# commit the transaction, so that the second fsync of this file below is a
+# fast fsync.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 128K" -c fsync $SCRATCH_MNT/fast | \
+	_filter_xfs_io
+_scratch_sync
+
+# Fast fsync: only the extents changed since the last fsync are logged.
+$XFS_IO_PROG -c "pwrite -S 0xbb 0 128K" -c fsync $SCRATCH_MNT/fast | \
+	_filter_xfs_io
+
+# Full fsync: this is the first fsync of this inode, so all of its items are
+# logged.
+$XFS_IO_PROG -f -c "pwrite -S 0xcc 0 128K" -c fsync $SCRATCH_MNT/full | \
+	_filter_xfs_io
+
+# Simulate a power failure. The log is replayed on the next mount and both
+# files must still have the data they were fsynced with.
+_flakey_drop_and_remount
+
+echo "fast fsync:"
+_hexdump $SCRATCH_MNT/fast
+echo "full fsync:"
+_hexdump $SCRATCH_MNT/full
+
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/363.out b/tests/btrfs/363.out
new file mode 100644
index 00000000..fcf6e0a7
--- /dev/null
+++ b/tests/btrfs/363.out
@@ -0,0 +1,15 @@
+QA output created by 363
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+fast fsync:
+000000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  >................<
+*
+020000
+full fsync:
+000000 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  >................<
+*
+020000
-- 
2.56.0

