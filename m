Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794942011;
	b=M6FTwJWiwtQMBAzJpJsUm1kYBXbaos8JkF1NvHksoXqjMv3xDbzITrSLSjIYvDwpxlGO
	 rKjczWimcPFym0pXRHe/qttFa9uz2qoubfOgNHz/DD46dTdgXwwpc8EJkun4yjKA0bJCf
	 r9uFjtumBpi3U3EQxh1G38CmxWe8clkc/uTzRN/p2m9AfP2P2LL3O0UL2/kzg7qhP/yyR
	 b8MvUT9VwbIJJYoak9gjsV8fA/Gcu30ilDkk6MvEmZFuzKuNDOSJ33OyqvPqwfuw+qmUX
	 SDgQjGr5DBaFTqh9fxa6O4MFPSmW62/VfA8hEpn1e4IAgfq9+3eq52xhjEXndT2XShg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794942011;
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
	bh=GTQtMqDnqpC6flU4UsQBzdomuvG6wbYXTX8HuJj0+zE=;
	b=XAtTamzXEHfnCJIw+DDIqgD3ddrJTVW2VnPtkWXT1K3EoAeRlXwlROgyblEkrCSQm06f
	 scOwRG5MyQ/kOhI+brF0dsMWq9kYwH3Y8K3gonD/9KkfHZ+dS4dSIwBFZCzT27cBRvn3F
	 n7/Nd11zfXMNbk1jneegMckcyzGc6lgsMgJt9SQuMHCftSQQEs38Or0BuqvEZGlzkGfY2
	 MYrvBafZbxZ+MDMw30wtF0RGd96tc75uh9mwTWshNMf9k3VKyI4HOjx8tNKg20ds0RMmN
	 S4RMWmzVfWfZQjQo1G2gYKXoB4a4LP4pBjQTvlskA5s7AFkeHSUsmRsCRHN3VWQtMbw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XeHEJY4e;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=WtU776Ys;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDA1606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 19:00:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FDA1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=XeHEJY4e;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=WtU776Ys
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794942011; x=1826478011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=nlaOx5bcwuPpDzINybpB/Wlu1NtIOFgq106tPINmu7g=;
  b=XeHEJY4ea+29yscatvw0DhHlhIiE65Ki30GWeRaZf4COBPmiQV17ASEx
   m4KwLoiPZ952eyIqkide3iVikzoZ2wQsUTpxs77kZoyHXnDcb6CwCUQ3v
   q4pIQ+aQXUNdXLpOi1kpBLmoihmUZd092IMIJXmYveiOPpvxNmVl7jgzi
   A+K+O+JxA4ID/IWxnhiak3hom5SzFqG2ufGuBrXviiAf3WuJsQWyhK+kh
   0I3Jjhv8INBQHbKEJhzML7iVzN0CBRw3abvMqWvGJU7q40IRM0RvH443F
   SsMInuIKu+l0KyI5dfrc9BSFfGTWXp5Sv12uGxSBoUjrxiMxEZUdvB1Ce
   A==;
X-CSE-ConnectionGUID: kBLYMmvbSjOdEqDOHVABrw==
X-CSE-MsgGUID: s2WnJOniRxK2SKILc/KPUA==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="156880194"
Received: from mail-eastus2azon11010067.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 03:00:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gqFRSS72mfLYxoTlLPJissB300qCyOZlBym2txyNSS+9rX/s0ft+hG+AIxVPVGlSYvuoUZvtc5vIveuR5NKaHFRc6odHDRJcKLc2CU/vM3wr+P68kVool6Sjh66ax73Bv1gldtS9gSH8ztVCb30Be6zYyqCOGqfV7nN1C+c9vuRQHBV/pzQBnGB5P8phHPHuqIUxd47QN59eG9dl+bQzEJUab2NZVjNh5A3fad5IEyyBdxFHqgTo5lPp6I6OI+qGl911fvpETuWIbNnC+FlEMe6/7+TmwaK9syCKKKL8h3s5ell84FbRAxe6YEOXa/6mH+uVp7lDG54ekf8YAouoXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GTQtMqDnqpC6flU4UsQBzdomuvG6wbYXTX8HuJj0+zE=;
 b=rrup1O017o23agqF7LcUA6owm5wTnYhUpufugBb0IlP79m9cwCRFijJwucfy29YFhyBGhCe7wyEIZn5O+ygBYpRPQwzEYtiAbRmHjRh+Wt9+f6cqJ5pYgi4QDVL/anv9r5CnchuG6E0h115PcH7OdjzYGD+gCzaPyExt6kIt0MrR+YeqsrLjla3OMfBej6f3nE9ijPGgzbCv+nJ//SpF4MPzzNR0O/jdxV0OTJOsjmnbMiW7eihsxZOZhq4eCGnjq1knTm5+ByEcooinP4f2ja04H2j9kopdCwVVPrs16WTn0r2jwZb2fIee6pX/q5bI4pEdz2fPb0nW6jKGHz9+Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTQtMqDnqpC6flU4UsQBzdomuvG6wbYXTX8HuJj0+zE=;
 b=WtU776YsXoc6N0LbjhhIE1hSVwXeLJjn0pA+qj2kkAJ7V8xujrf2ELnF8Y8SitscA4UwrJcVtj62O/JIwJJ68gb0MDZeSwHFbQJ2npzH6YhlHdBrtwpbZ7zI5KyySu8qGtZFDS5jWFjakt2kNHTbufoYcX4yzZyEFXU4zLgAlbo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7483.namprd04.prod.outlook.com (2603:10b6:806:146::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 19:00:08 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 19:00:08 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 26/27] btrfs: zoned: don't count the relocation zone reserve as available in statfs
Date: Tue, 17 Nov 2026 19:58:49 +0100
Message-ID: <20261117185850.4128157-27-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7483:EE_
X-MS-Office365-Filtering-Correlation-Id: 284578eb-cd03-40ee-482f-08df44dcff67
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|19092799006|23010399003|366016|18002099003|22082099003|261009223027099003|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	6MdFyiG6QipF5/tvvCFIPzn0mdO8vunMRIpevx8DlvnC7j0u2OMGdDISmYQOpQKETHGUYoHF69wEfY3MM3V5xLV3b550+e6tnZ86CjZMRY+SGzCtGlRZpbwns/r6k5MVNDbrTjyl8te5Vy1r7q4FAuOIxDzp3rIiUYx/VTC3ZFMewwITxJXOs7OhDUzmwKW2lfSd5xY6s4tpSnCPi5JLlRU9rqlQY7TOd3/VOJTvDhiVEwhWdLxwNdF/vTkE9TdaP/GrGtlx77mzIqtaAKNpKi71jzXI59b1T2AUj8o9j4sBhRPf8ZFUvnPQSIGTa/gpBHpntEkCmWpBSPfkp82R0Dw+I/MLzKwUFRfgXzTd/TcF/nHpW8ASNitHamK84xFs48jOYNbZNICkqTkT3EEA+utYL5A4lZkEaha5dSz1gVfobkzKqkbbSm5quHVS3iJt83UkUP0DOmoBxnn6etXpn/qmOLU43tDR4kSemObDDoYUT+sl2ey7Xd/veB0bXSlHl/L1Q+OqU/qemEEJ5VOnYIAGnjHvhO7yRDFEQhvU29BkNMXvSergdu6k4NPAhNeVnGFh1JvqqnBjHXDt1j2CKFquMJa+dSs40twOHkbw8aBz/MBLn9qM+fDxiOYZA/GcxactdnGrNmkC7uzo4cgMNZqTzMRZBRTxKo5h0qILDug=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(19092799006)(23010399003)(366016)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X4ibbmq7uIxhFo7SdvLGT1g3IRW+9F/zMFWLDfTkTzbWobrvxjpy102UcI8j?=
 =?us-ascii?Q?xDX/pgvm4LYvAEssNIc9hEYbTzfRI3T1hzhIn695e6KZcS6SlxvRpSlsCiZm?=
 =?us-ascii?Q?Wq8DBdnx2ogIBWXvBvllbcmcGCcIfHBZu6PRCf7bme3gXiYSkE1asfaeSm2B?=
 =?us-ascii?Q?Gd5aLZh8wVvDTMPqH0WCI/tBMvCEyHhT0MeJEGmZqUZaOVkiBsgomVB9UfEy?=
 =?us-ascii?Q?SxNp6qbhJcL7Rm0IJ0CjM2QtAv2EzCW2sfcPH6GGTDNXDPGVUBLks9jKJesv?=
 =?us-ascii?Q?5x1YguMMcNUzYcbNXLjE7ILT0JQtVnw/AH2UzW0x4rxLzGqD9YIV/fl0kqjD?=
 =?us-ascii?Q?iRbQmPNoBo/9S19YUQA6hEAefhss/fFryMi327dgNaOqPzE5Q93COY7o5+fC?=
 =?us-ascii?Q?S9tk7GTBlVvcRGt2XtIsnh9eH49nCORK73vjVyyWA02O0AEQcDkQaedWdsm4?=
 =?us-ascii?Q?hFsua6Ec1Daw/0GT8O0Vfp9vDwPkHG8hYPlX3bwDQ2Kjw/Op4C7qlsqiB1HX?=
 =?us-ascii?Q?kM7bwivZZIngxmHz6SB6T1TaDstLN0vHNsqOORLWqAhiKb+1p3zOZGBU2fge?=
 =?us-ascii?Q?rjju0wKjofIbojFSZ2MfuVWbCX03mui8Jos4mMS9sGjSBt1msrf74UKtPHoI?=
 =?us-ascii?Q?OWdtf4Pab1IfHOWnbWCYgTfsFJPDr+Cv9PY2nc4zMHNPE4xBXuTt140EUymi?=
 =?us-ascii?Q?Zsy/6uzFRVXJHmyvhp0+X+D8VsGCpbCffX0Gxyo0xS1p4UnvHbvEzXIpRB88?=
 =?us-ascii?Q?gFJDsrYVKpKRZ2c4RfTe7xU/4mceKT7t6lJ2711lmgh94bAGav5b82GxN+bp?=
 =?us-ascii?Q?QOya3cuTKW4fbj1fDrJQTFdauvUlbVLdzAO9AL/dgDyWEcXutWWmTb+sKuhi?=
 =?us-ascii?Q?lnbelAWbrGQwGp/Ov1TTvpUBbmWY5/9mMthGa7u7ypSlEN4w1itNHhckTuyx?=
 =?us-ascii?Q?a6T0hh/JfW45l9NMb0+GOiJKPnM8wKKUJY14MNxCl5Ti29bSaplJtTscgYir?=
 =?us-ascii?Q?ri4zIs2Vljq8Wy+PuoSVoACp7j6Rjns6eipVvBMUmcv2HExQUIrhE65y1SMw?=
 =?us-ascii?Q?6pC74rXOYpGpjaixXEt/pNPMwRjywABUm0kmpA9z//ispboI540CQdIW/BZA?=
 =?us-ascii?Q?0syVlED/+YFZcQs8h1sfNcZTrwRFPI6ZiSb0aSXwHLxREmngrhjDyYGu6skk?=
 =?us-ascii?Q?eDhLqtmtpHkjrUwwx/RTQYPW3wlEO6R/TcSea/Q3JcX4Pni+s26W2tDoJbru?=
 =?us-ascii?Q?rdXjTibw/6/fknjYIjz0Nx6Qi7s+bBskoCNfGR1f4EXS1NpowmQ5Pftzy/cc?=
 =?us-ascii?Q?cUDrfs22ElJ0tMk6511rR/E8egKVkOkWs3tyzMTclczIvOXq9Fw7AQQQ7Eec?=
 =?us-ascii?Q?2mH+8FMdDuIoVuRSAq0tDcIxaXWo262muMwYSDLrz4VY5z7Q0GIWs5u1a178?=
 =?us-ascii?Q?AWXoPto8N1uXvy8DNsURI8+GxgcghPqf1rBHvBJO4xjZM0mAVR3E7S7mqhEq?=
 =?us-ascii?Q?47xoUNUko67dvY1IaEZmF9wPnOxT1xYCFJtzIMhhT+2zJVwRfiw/z21oRv+X?=
 =?us-ascii?Q?KKRU60Gsdr3Xd11KGuhKM69qD0OLl0Wwwq5WTeiZApFBdrT8Nr4am8OCPWWF?=
 =?us-ascii?Q?pA0+MRPjdUcySIUbsdznjzfNhCBMsn+BR7VhqRuRWNa1bhgVgQ700XD23F4r?=
 =?us-ascii?Q?mrMQFleYaoFU7zvb7ixoCsjTb6/OaiCfsojJcWVAGLxZYgcv90rJ5LwxLg++?=
 =?us-ascii?Q?VlJsk/M+jqkrRPa/klWF2ny2tihWiWtvQAxhpy6/svHzOwQBYB84XAX7kCS7?=
X-MS-Exchange-AntiSpam-MessageData-1: 5jeO6nLZR7N4MNc7DvQ5H4BycwTdlYlTV5I=
X-Exchange-RoutingPolicyChecked:
	b41EwAAeFLvfzQt+W9i7CO8zVRVAd67ml6ii4pcb7OyOUFw/V4+euDOHtGBXFaha6oTb10qS4gEETeBCKQopGuyIm17LkqobfohHGdPb9xPvND3VEHb/JnjMUOUvBwU2bi0qFqRuhrj1Ve3yPU4rtgvThKncmcQM2iRC9WIdkkBJnR5ZklAS6oUfxUO97E4XqLOfaUB7YBirIWAXSf8ZUmadSYeRS+Hh3yCFdi+mktVSOrTxXpL4aIGWEP07zNWJc3oeYFDGnntaaW7QSiEYUGzSlLTXdxuhWymhaPIozJ/1AqeKO4mhvroAlu9619OeYyHpdU26saNrJ0X9H8d31A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mnTZSZWq5LHs/pco5FwGYbZcV2NLkQ018orS6S+Uvt43gbU2Cb+3XBbMaiSQaFkNPGJ0BOpL6z/VdYhv3kXnYeSJvSDP9XDBie0xKXk5SE6yjTP68Ux/+oRkIDhJbt8Bbr88Lyj3Op2eSszLYD5/u1gZH4fUDwZNORu5qO5/kkXTxRtLzy6t8SxTen10AKJXQxTj+k4gdG63960ezJUrx44OT2yFTmM/LLmMpc8oTrISHb/MnJiu7Z8MDcjil7wyiPQGFIZUESqGHa23PMLK1ZCzFY39oF3Cwe5ofJ6d7K9y83/Y2xFNSYHQe0CBdZRfxk2FXJdeVd6inhYxzdiTg30jT2KGDud4XXySgv7lTOCy598KU60wXtnwwCXa2n1kVgbgbpjdatDbOrs4mB/OTerxzsUpNSrcbIZq3yy87ayuH5gKQq6Hu6V2xj9vk0oCOEKGX6RYo8Ti8heg3i/GMTc2PT59iO1ZFEIkaitQVIIvePimHBEiJjbjUwk4NBhZBQeccbhL+rXuZczXVI6el2Afg9KqXuNzo3QgUH02nUcF/K/T7vVbbP9V4PeCwM27eoqHK0IVqNLxXoZ2YBfgUevodGUVbepcV72dYDLS6sLhUCOaXMOghyaN8fnr+3P5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 284578eb-cd03-40ee-482f-08df44dcff67
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 19:00:08.2380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCCE0RUC2ULSFMrjzXP28ViL2kvGU+HntWtPG4+dJjaJXqeBSFDnLiDChcA8nviuFx2ekKyt0/MNk4J2eMaMzyIQLaxU3D196ZAYsCflKIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7483

Don't account the space reserved as a relocation target as user
available space in btrfs_statfs().

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 99cb01788315..10280863b3da 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1734,6 +1734,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u32 bits = fs_info->sectorsize_bits;
 	__be32 *fsid;
 	unsigned factor = 1;
+	u64 data_alloc_profile = btrfs_data_alloc_profile(fs_info);
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 	u64 thresh = 0;
@@ -1793,6 +1794,11 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	ret = btrfs_calc_avail_data_space(fs_info, &total_free_data);
 	if (ret)
 		return ret;
+
+	if (btrfs_is_zoned(fs_info))
+		total_free_data -= min(total_free_data, fs_info->zone_size *
+				btrfs_bg_type_to_num_stripes(fs_info, data_alloc_profile));
+
 	buf->f_bavail += div_u64(total_free_data, factor);
 	buf->f_bavail = buf->f_bavail >> bits;
 
-- 
2.56.1

