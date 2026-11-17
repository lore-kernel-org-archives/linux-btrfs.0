Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794905418;
	b=iUxxIHUuRQeTsUgQX8RVNexvChNOy8yIoLy2QKmbsl6LWdgMuEe22hG+Jo725oWnYIZx
	 g8VQsyHdtQYTMTSyZ2pe9nsJTZ9fCojUARd+8ziFJ/Zwf1ASv1psIkLgkSQtFhRX3tzz/
	 lCcyEq2E62rdyLkLi9hTaT2btzHSj04g5TJxF11c6Z2UiB84ZPWrzDC9gxdQSm/QB9eOz
	 8qH8qXUWajjqz3HQ6xgGbzW9uq3tFxHA3+cz+3t258xi0hgDcs6g1MFVk9A7wKqD8r+Jv
	 TpqiQBGsBych0/Fa5eFZkLfQwsRsf+u5Pe0pSk8hIAt9KL2KiEms80FipjtfrmblhPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794905418;
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
	bh=lTxTZXD6FJ5+Bd5RsmFr4HcKarXsHRbroX4VoCfEyBs=;
	b=mG5KOYOW/RtRYhI60io75w+JLn62JH/hq7R7SJL8LpZzfn8tOhvEM+0jQhSzS0O/tLGl
	 dMzh84tKUT/s2wV3bz+opn+LdAUL7OwFbwtLauTSGxOfO9RtUbKehCLWOzsBkznk/KYdn
	 jdzr+ujuGxDRYsuld/lfWSZml55ef38kWNttnFhjvzSEeO8AIbSVT4fsFGhfP7QosS4+I
	 ot47fc01GvqbEiQ2AHsAMNkhKEFFgnnit2mY6p4+lhbsb9mjHCCKDC/Ijkq+b9VvRfqOW
	 z6AKm52sNoCc3oRrSF5947S6fzm5z6myBbm+P7Mhi+u358aLjFRlAWgiXa0rHvAI9ig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=bTe3yxmD;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=KdWlcETw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E341C606A323
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 08:50:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E341C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=bTe3yxmD;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=KdWlcETw
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794905416; x=1826441416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=HMcoKP2QRQU4dBdKxU8+s57trZqB3ysqYUXAej35NtQ=;
  b=bTe3yxmDul7ZX79wfJxtOtl8jhIvKT1YrfGvdTGggTeEbak/SVx1cEiG
   7rlfStIDbdq9x7dSszWYjBgl2ZGSMTZChWBwncDVlKmSO0PygvJ0NgWba
   Vdg2qNjSixSAlQGndw/iwE71vNzsUVPEyeHrsoZVefxXUXUJYgFl8qEYK
   xRNAODU+19b6GrNviIgck6tgQWLZZ/cmBVxJvPQ4ZZo0HM7NLEZKUuYhP
   T3tCUERGiXYlmnm/lcZSLNr0Wt7OfoWhoZ4oKjrsyidwzlwr4daw/lyCk
   nc20BphO272ToPP9M72qaZ83uquTGenoANqMcwdE8Jt5K1UjUnlNj+e5p
   w==;
X-CSE-ConnectionGUID: V5GwZZOqRby7w5OdezQqsg==
X-CSE-MsgGUID: aIHSNzDeRTac2MxNL9zrHw==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="161007169"
Received: from mail-eastus2azon11010038.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.38])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 16:50:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e7lElj1fJM2JJqCr/+/UqSuA/10oveB7HGQT+WijYgBszFHeoIplV+cjEtLtpXLZe3b3TM+iVu0mCuZKxENaLCr5PVd1MwdRgoALzDTK3j76f69thgSafiZ2e4rFzLfz9KKbyPEoQynmHe1g/Y2REEEaCLJRtxkZ0+b01pOm3Nd/QcHMsxVOXxBHfaxCvHZ5UOxA5hVCjOkNoX8rT1vR4xWfh9CtROHLcBjCtDvav+QWmRsAzPiMugtrdX2e7NBGa/52ERGapCvY6ChzFDSZWXKeeigHV8IYOrlNDsmXbz2HfofjaTGDd6saMtv92MhWmR4A+DUPSZ1xCfHkMx4U3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTxTZXD6FJ5+Bd5RsmFr4HcKarXsHRbroX4VoCfEyBs=;
 b=EwIe6ONQm/pvnu8AVrPrMUCnhTGNhcaX3l8WpHu0X7H6AuQ8sodcLpZlaXo/J1VmMSFsxhY82p11PzECsfB85JK4Y36oLXSdSHP28tRIlrAEoK1U/uQXfsrYcSecjfG7kPoKkt3BhW2jKXQ51HdfaQe1wyulBlsY3aD6GdNTQMYaI2KQkF4sCNISSd1dthHAuZcYZ7tDVPsExrBU1+khnYbN5aY3TTvtYSZKD30+9wqT837nSdPCtVGdaDIuqiH89FpS56V1G+Cf/E+/xlLMEW1FAzuep27/ybYsTSK5pmTexF4qaZKKsaVwmfcpdVqwovnV2qDhe67xY3PyP14zOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTxTZXD6FJ5+Bd5RsmFr4HcKarXsHRbroX4VoCfEyBs=;
 b=KdWlcETwbtP5kg0+6InmwEeou8iJ7fP3wro+j5zVlJ2m/f8IkPjLgZLOWGJdNJWq1/d5yn5WVyOxuewnMkGHjJTz1H9l/bbhrgoH7bcBsEbA3lp4yx7MVGkE+k9SWXVfi3kCywgmweXw2NYuSojM81UzJO72rji4mi3FF2NYjkI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB8145.namprd04.prod.outlook.com (2603:10b6:610:f5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 08:50:14 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 08:50:13 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Mark Korenberg <socketpair@gmail.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 4/4] btrfs-progs: check: detect and repair exhausted zoned active zones
Date: Tue, 17 Nov 2026 09:49:47 +0100
Message-ID: <20261117084948.3848762-5-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0b48328e-6a5f-46c3-ebeb-08df4487cba9
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|19092799006|10070799003|10067099003|56012099006|11063799006|261026121527099003|261026140227099003|261028144727099003|261022075727099003|261021123027099003|261021121427099003|261022105027099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 JAivscZ8q6DwpIP9YTmnWewq4DCtc/eT/+yVhSizRVIKdsgLZLqtAMnqJW0JSuxrt/m32cJ/AdSdI8TKbn+oDFS6JyF3jZjMMLRiHAWeyQnxiiE+NAZv8CvzNomKYjWgJtcRVTVrjZJg+57wPLHozOpFZ/1RF25yTdEBqqx1HEGfXqxd8JPBQRnBBdJFgBA8eC5tmvb2ukBiQ6ILt/EKVOeatccSNa8McQJ5wdYudMLcJuYKvc2FqkBSMZuC8BbvrP8rtmq9alDm3tQI5cSYPmTHAQwdjLRQ4rADzEx44Cnl+Ec1LoqGPAi3htxGcqxJzndecxDGLk6CAS9vmV6fOqnHCD/Q8WGoAL2mnH5POC7plAVbhBOIPtDvYaLKQnROJ8V4sogCkt6eT4ADw63cVCPoCpxFybCrHNeVlEa+JVdXHN+0rHhxL0p7276r1zEBd69sIibJu0ZF+/qiA5TRAGccvilIiwxQQ7cWvNcMa0okcNd7Ro5u4Gx0lErYdjh4rrmYnM64K5w0s7TvQupZ7UE/tj94uEckg19xDZUg4GP8wdIIQKSpUZQVgiCmWgE5uM9xXsCa5Vnp/qI4NUHxOz4r06iskep8GmwRMJCBXKY7cQamC+DKOEnQnn79+N5llVFykgzBnVRHA1sI0Z2NKd6jjzso0+fCx3nKp5H2PDg=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(19092799006)(10070799003)(10067099003)(56012099006)(11063799006)(261026121527099003)(261026140227099003)(261028144727099003)(261022075727099003)(261021123027099003)(261021121427099003)(261022105027099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?3qN1OEm6BiFAHkNTUb4AMKqjm+SLEcuP0keCzP4cewjd97K2Pq0S+QnEM+jY?=
 =?us-ascii?Q?yzjLkMtB7zirTKZRuBisEaJu+gTc26b8QGNmC/xebSgXvQKFYb2nLmdoFSX9?=
 =?us-ascii?Q?UWxP1EIJJDPQbSQqq8u6EVSQ7+6cIRteK5q3cUYBWrw0VOInjKAxWrjx5nBt?=
 =?us-ascii?Q?gFL7KkvUCI3GfMRjrsd0blyVa9k5zK0QWpo6LUXsgsnPNL1+xFMc0abYfPSS?=
 =?us-ascii?Q?jKGV/slkg28T1QHt63pbio7VSM+4KwmxAJCO07v1TpPJDrffOtR858luLU7l?=
 =?us-ascii?Q?g/iFmd6rXssv5DwdstogfPuoi6zgCUkF2LODPSQrZ2CEcs5oYb9sPkHeqBDN?=
 =?us-ascii?Q?ZknyMqujfEu3k9cBXYnKTZzjMp4A+JP9p8EKl2DcUrGpHJ1M5WUo5zsauZJN?=
 =?us-ascii?Q?VD0eklTsfyHdIASn/ZpBn3BB7k7XY+LcvNQAl1GGgbJBuefvXXc+LSk81WNa?=
 =?us-ascii?Q?Y/yh3g2gShxh71jDTi2yqJNKdhI7k2fV4eOGAsnSQwoDTCnm5iBKPpAosC2L?=
 =?us-ascii?Q?wnsJ20eAm+97tLVRE1xIlqGaWm4+7jN15cBhgCTAb75gMK4fzzZrhEu56yAn?=
 =?us-ascii?Q?3PrTRalfeIxpA9Jj93B74qV2d9xRi07JYsmOG8X6dq6PxknsgcirVrEojC3J?=
 =?us-ascii?Q?aPxPfuk8Ig4wAhVAJWxzhRlE4ytXTHzUiyx/a3FZb8CjEHetNPqF/9wZO9xE?=
 =?us-ascii?Q?+nXlcDTExzE0/yXsXGEsrV5l836417XPv8Pppq+Qz9Ps00myKFtvHDzYG0DH?=
 =?us-ascii?Q?VHzzPl0rVj71eLjQRSWnb3TGjoPxspVka6hANPJ+8XKxXnH3Fl9CX3YE1eSE?=
 =?us-ascii?Q?XtfbZCH74ynv97klqEn6q5fBykkKyQ14XbiXep84RbbHbOH19CYWBdRkjilj?=
 =?us-ascii?Q?P1qVcRwyl1HB6Ohs2iSwJ2jXF8Bkv9CJQJ1X+dCp42704YmaN0r1dEH36h8s?=
 =?us-ascii?Q?3echX5IMkOSDBOQChMG9q269LZqSSNtrczzxlZLqgHoLtZhB3TZd0L3MyQaB?=
 =?us-ascii?Q?AYckz2Bf984v++l1HmNCHWiefbkbJlEbPmbfVpwryFb9qfuBPU066vldRpqz?=
 =?us-ascii?Q?ya2OB32sbJyDCdZhp5VAw2mjKSNTDrjlMTANB43KBi6pa6P8FPE6+SjA0s8Y?=
 =?us-ascii?Q?Nol4/FtjX9goCzecnqN2cf8Ko8LLOC2sMK268enYh39Qdyz1AgXz/M4w1gp8?=
 =?us-ascii?Q?278uZPNCXGGkIWDJydc5e1d+9ScJiaUCDjjPntqFGOV1LcoyCHTjiCeo43hb?=
 =?us-ascii?Q?ASrVTN5uc8rDqOual4pPLkAvogOVjLbErNXzxLaXTLCMq9NKKVz6BH3IAWZq?=
 =?us-ascii?Q?yuaYAEep+dx3tLxKbCy5KpNa3iXir4BDH6kjyA02pXeQPZLNFfGjsJ1YF6tL?=
 =?us-ascii?Q?rsRWhiH8mUveZFgxoY4PVBygQa2LEP0I8x4kckD8WcoFbjIQs3AbDXjJjCv/?=
 =?us-ascii?Q?6u8bR8Er8v03kPvy5Ba9XuQfpJy5mtnNjmnEbnY/zG86DOSmM+aADdlXhfFo?=
 =?us-ascii?Q?LfjQq5/uBlwbwJphUidVVLPHS2lg8TGP20NrPPewSCkkSWmXEnflZt7KHt6g?=
 =?us-ascii?Q?h2AXDGWxlS7kGiD2NOqrS/k2YSrCh8FjpU6rrnDkZNGqwfQ3l/6bMYgnTQ68?=
 =?us-ascii?Q?PFErC+/kIiZtEyguAKCTCI6hC9TM5+PP2BjOBislbiJfRx6uYyd4HbvsJp+t?=
 =?us-ascii?Q?Qf0a0R4345GeIGSWOTOGDgWE6eSmPQPB15p5CVitsqnPxJ7Nn6+txgxHnDKW?=
 =?us-ascii?Q?g8XgAtVV+c9DdPDn4T6pfneJcTlkrMVppyyYFoDWhET0S9n/zMbGDohvN3Yw?=
X-MS-Exchange-AntiSpam-MessageData-1: m9ot9gVJj7dQEPuJu42K2a335zs3GVqkm9g=
X-Exchange-RoutingPolicyChecked:
	4f3T289fvnyljis598+T3CFfXX/K49Cn9iJ7gxfubFKa5y975F/n35JlJNbs4hqxcWAT8hLhRlpLUVEvtRdobA2w0LVrkCV5MfZznOB+ahRNtirCAqAzU5tgditTOjm+pxCYav43gThuHsiKByMp+PZZfZ4KR0+Ve/GBMWntJMC/fy+9yrwRLPC7iVPE3Uxk/9G11Hv0r/OIUHf4rYn4bKjzTvDmXIPu4NmI+77rt/2dINPx2Bl9KFNCX4O2u6zrmDDF2sVr+keO1gS/ib6JlISBB7Vb550JxyY84UcoDr+NcxShTi/4ioECFOgx3ob7sKkBlW/0kEZkxjTPn1zirQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gJ64z6bZG3+TCPw8+dg2Q7xKbZX5sSytEiA1LaPsowV96P/tn0uC2Yp9Oo5tffbVmTU7hSM3NIzfKL6HwysfYk+jslUQnc7F3pgucHiiizM6CeOksNr/nc2WkraXgPFtnSnKo81g8pWPS6jsf48FEvT02yTb1FriEZeoB6FjPn4sfdsIZvnzf9lwQxO1+CjakLqKvvSERI0f2aKIGnEjORTs9eLC/HOsCQb0yNseJwHonmjn7fIiLBFydVVK1BKcApWptkkwzJJc+kZxDtN1aUvqIKEdABK0mE+Lb9HQo+F+Qph44PrbsoJrLHQ6xkHzF9u4twUrJ0pJRgJWpuaP7aiufcp7UncO1d3w6MX83+6kAu4rD5c3d8PmTVcidcHywQNOZoaQdkX802gRk+Fv3uG2ELjUre98I6XrdYHN6ErzXCPBF4lYhn56Nu1B+7mpRVg2/zOqiyfQnpDosykuYhtXJDIQoEf82529WdmqdEEcaEWZ3xIf1EsqHLwXIUEIQn65FQuHXh5t7alheiZyZriQgkMS+aJM79uURZhX1O0ec4ZA3yyXfgSJ2qQhcgW1aoAYvehHVeG5XDCtI1+JGVySm+NoNHGWOKiIawq6Hspth3JuOCs6/S+lsAiIB96f
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b48328e-6a5f-46c3-ebeb-08df4487cba9
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 08:50:13.9330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBqnZvwW+ZV9KS+0JnhSxj/b7nBgC+TUXNbpwSyL/SjRYEWuuTeAjhunvqDj8A0c213b0xWSgiREZVqBH6+q30jSwlSm05VUfRlCfA2Kt2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8145

Kernels before "btrfs: zoned: don't release active zone reservations
for conventional zones" can leave all active zones to data. The first
transaction commit after mount then can't activate a metadata
block-group and aborts with -EAGAIN.

Report when the active zones in use exceed the kernel's limit minus its
metadata reservation. With --repair, finish the fullest single profile
data zones until it fits again, plus one zone for the relocation
block-group.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 check/main.c | 187 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 187 insertions(+)

diff --git a/check/main.c b/check/main.c
index 717d576f..f065555f 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9203,6 +9203,188 @@ static int check_zoned_active_zones(void)
 
 	return ret;
 }
+
+static bool zone_is_active(const struct blk_zone *zone)
+{
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		return false;
+
+	switch (zone->cond) {
+	case BLK_ZONE_COND_IMP_OPEN:
+	case BLK_ZONE_COND_EXP_OPEN:
+	case BLK_ZONE_COND_CLOSED:
+	case BLK_ZONE_COND_ACTIVE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+struct finish_candidate {
+	u32 zno;
+	u64 left;
+};
+
+static int cmp_finish_candidate(const void *a, const void *b)
+{
+	const struct finish_candidate *ca = a, *cb = b;
+
+	return ca->left < cb->left ? -1 : ca->left > cb->left;
+}
+
+/*
+ * The kernel keeps active zones in reserve for a metadata, a tree-log and a
+ * system block-group, and only activates metadata block-groups when writing
+ * them. If more zones are active on disk than the kernel's limit minus that
+ * reservation, the first transaction commit after mount can't activate a
+ * metadata block-group and aborts with -EAGAIN. Older kernels could leave
+ * filesystems in that state.
+ *
+ * Mirror the kernel's limit and reservation, see btrfs_get_max_active_zones()
+ * and btrfs_check_active_zone_reservation(), and finish the zones of the
+ * fullest single profile data block-groups until it fits again. Leave one
+ * zone more, for the data relocation block-group activated on mount.
+ *
+ * Return 0 if fine or repaired, 1 if a problem was found, <0 on error.
+ */
+static int check_dev_active_reservation(struct btrfs_device *dev, int reserved)
+{
+	struct btrfs_root *dev_root = gfs_info->dev_root;
+	struct btrfs_zoned_device_info *zinfo = dev->zone_info;
+	struct finish_candidate *cand;
+	BTRFS_PATH_AUTO_RELEASE(path);
+	struct btrfs_key key;
+	int max_active, nactive = 0, ncand = 0;
+	int shift = ilog2(zinfo->zone_size);
+	int left, need;
+	int ret;
+
+	max_active = btrfs_get_max_active_zones(dev);
+	for (int i = 0; i < zinfo->nr_zones; i++)
+		nactive += zone_is_active(&zinfo->zones[i]);
+	/* The kernel disables active zone tracking in this case. */
+	if (nactive > max_active && !zinfo->max_active_zones)
+		return 0;
+
+	cand = calloc(zinfo->nr_zones, sizeof(*cand));
+	if (!cand)
+		return -ENOMEM;
+
+	key.objectid = dev->devid;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (1) {
+		struct btrfs_block_group *bg;
+		struct btrfs_dev_extent *devext;
+		u64 pstart, plen, chunk;
+
+		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
+			ret = btrfs_next_leaf(dev_root, &path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0)
+				break;
+		}
+
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		if (key.objectid != dev->devid || key.type != BTRFS_DEV_EXTENT_KEY)
+			break;
+
+		devext = btrfs_item_ptr(path.nodes[0], path.slots[0],
+					struct btrfs_dev_extent);
+		pstart = key.offset;
+		plen = btrfs_dev_extent_length(path.nodes[0], devext);
+		chunk = btrfs_dev_extent_chunk_offset(path.nodes[0], devext);
+		bg = btrfs_lookup_block_group(gfs_info, chunk);
+		path.slots[0]++;
+		if (!bg)
+			continue;
+
+		for (u64 zno = pstart >> shift;
+		     zno <= (pstart + plen - 1) >> shift && zno < zinfo->nr_zones;
+		     zno++) {
+			struct blk_zone *zone = &zinfo->zones[zno];
+
+			if (!zone_is_active(zone))
+				continue;
+			if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA |
+					 BTRFS_BLOCK_GROUP_SYSTEM)) {
+				reserved--;
+			} else if (!(bg->flags & BTRFS_BLOCK_GROUP_PROFILE_MASK)) {
+				cand[ncand].zno = zno;
+				cand[ncand].left = (zone->start + zone->capacity -
+						    zone->wp) << SECTOR_SHIFT;
+				ncand++;
+			}
+		}
+	}
+
+	ret = 0;
+	reserved = max(reserved, 0);
+	left = max_active - nactive;
+	if (left >= reserved)
+		goto out;
+	need = reserved + 1 - left;
+
+	ret = 1;
+	error(
+"zoned: devid %llu has %d of %d active zones in use and %d reserved for metadata, the first commit after mount can fail",
+	      dev->devid, nactive, max_active, reserved);
+	if (!opt_check_repair)
+		goto out;
+
+	if (ncand < need) {
+		error("zoned: only %d data zones on devid %llu can be finished, need %d",
+		      ncand, dev->devid, need);
+		goto out;
+	}
+
+	qsort(cand, ncand, sizeof(*cand), cmp_finish_candidate);
+	for (int i = 0; i < need; i++) {
+		struct blk_zone *zone = &zinfo->zones[cand[i].zno];
+
+		ret = btrfs_finish_dev_zone(dev->fd, zone);
+		if (ret) {
+			errno = -ret;
+			error("zoned: failed to finish zone %u on devid %llu: %m",
+			      cand[i].zno, dev->devid);
+			goto out;
+		}
+		printf("Finished zone %u on devid %llu, %llu bytes left unused\n",
+		       cand[i].zno, dev->devid, cand[i].left);
+	}
+out:
+	free(cand);
+	return ret;
+}
+
+static int check_zoned_active_reservation(void)
+{
+	struct btrfs_device *dev;
+	int reserved;
+	int ret = 0;
+
+	reserved = (gfs_info->avail_metadata_alloc_bits & BTRFS_BLOCK_GROUP_DUP) ? 4 : 2;
+	reserved += (gfs_info->avail_system_alloc_bits & BTRFS_BLOCK_GROUP_DUP) ? 2 : 1;
+
+	list_for_each_entry(dev, &gfs_info->fs_devices->devices, dev_list) {
+		int err;
+
+		if (!dev->zone_info || dev->zone_info->model != ZONED_HOST_MANAGED)
+			continue;
+
+		err = check_dev_active_reservation(dev, reserved);
+		if (err < 0)
+			return err;
+		ret |= err;
+	}
+
+	return ret;
+}
 #endif
 
 /*
@@ -9219,6 +9401,7 @@ static int check_zoned_active_zones(void)
 static int check_zoned(void)
 {
 	int ret = 0;
+	int err __maybe_unused;
 
 	if (!btrfs_is_zoned(gfs_info))
 		return 0;
@@ -9227,6 +9410,10 @@ static int check_zoned(void)
 	ret = check_zoned_active_zones();
 	if (ret < 0)
 		return ret;
+	err = check_zoned_active_reservation();
+	if (err < 0)
+		return err;
+	ret |= err;
 #endif
 	return ret;
 }
-- 
2.56.1

