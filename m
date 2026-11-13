Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794580966;
	b=C5Ep+BmW3CFzI1GEH8KMP5BmMWAPBdyX0mIazVqXjEQaqVewTWYq1Y/8m3plNc3WW6NK
	 RB0RfIAS0yCSqs8nEziny9T9uovEKHhvabUajkG+jpSI5QdQLosVU/r/+E4jK16fE/+sS
	 TW1R7LhTuWlmlohnQ8x8AAInewoe3WO08J1r/N57mA+pC0nhZI9syGAcjotXHDJMKfrfB
	 yFXPapQRczo1DPL0f3tIAAkkHDLxsb1kJ/AnTBS+0/NNv6ZLgkPAORVDv0EBx0pV0Og48
	 ymLF8WjWp375JCRj92K1NseQP40r1gpERqGBe5t9zg2PwvRaL5PFPRV5noN2IlPiDMw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794580966;
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
	bh=rXSs09QVnHsjbamkgdEI1iPyU2e4lbAS5j99UOKJKXo=;
	b=4iSeCuZ+K1OwEcAcjlYf7mhaHz9pyTOsbJyC9QF+zkpU+MmZw567OBiMPKbCir8n1f1l
	 0dVLLILY/OpI7sJ+IYqTQZ+SQifKorqhRBbF/TqW9vti+EZp28x6/Iy217YDrAt0paDWr
	 n0A93QeBExhQL8g7tC9U5Dm1GgPTnoH5JccZxH3MGP0j8RlnpMaosQ4GXVyfeuFFRO0l4
	 3hLceaCCvcEYv6fqXAik/X6cuiFMc+daEpaIKd70zmkVZKRQMsl0XoJxbfzT4ybN7u34x
	 Uzx8A4ay7ADbauGh9g3HCOfcc9W3hHyu6HqgxdTGcDjyuRDAJ76klFixDWoZz7n5TiA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=kNBzpjsn;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=j+ItvXUB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C28F606A327
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 14:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C28F606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=kNBzpjsn;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=j+ItvXUB
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794580965; x=1826116965;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=J12+WIKiUxH+Z3d645tch+2ZCMik0mQdF5IlQaYo0js=;
  b=kNBzpjsnZILr/Isg3ugQHxGb6iV6lQumerBog+jNmLbIXY5AUa+eGh7I
   z3SCjc8R744LSg/3IUQdrwbLzLijJIlz7ZlzsMjUGC4syjpSKXIamSZCQ
   Cl0Ar6zxj6/SNyqr6ImWHdPHyG59mEaZFx46get5eO4tz1YsxJO6OqzrQ
   KlocEnDBCZo63xMnkH31dYBDauBbfsW71CI5Q9wSO7A0l8qTfwdVVhISD
   w4zeunFn/U1xw+TjpfLk5G9Rr2eB76B6Urscw9EYetNGowlIdt7Gg48C1
   6sxnjivKGOSTrEinYdgBiWQ9dYpKYviE7TQuUmvPoCSHYpcqDtjyU7I54
   g==;
X-CSE-ConnectionGUID: /moXHK95Q8G4LAiHFgTNkg==
X-CSE-MsgGUID: +/qNw29kTGCrVuM5G41YdQ==
X-IronPort-AV: E=Sophos;i="6.27,211,1786982400"; 
   d="scan'208";a="156575363"
Received: from mail-southcentralusazon11013028.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.28])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2026 22:42:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YtYFYqstqGYSzV7gLzJfZEuE2l06SHFKz6hRnKYtpMK6sLjNRn3KMizWMHmLxYDewPNXgZwrRODpr2jsTcE5HtiVeD/hdwsoE2YF4Zu/TmutPpBnUOe0OJkGJL5Jxa5JuYjHjdnHpib4lf0NtY8JGOt/fT7uspnrY3PcjKYgzddOx5psLCoNE1dEVvI6yYI4ePlS4EKvNOLcwzQJNTwb7AeLS6n6Pw32Gaz/LeLNNEZq1O2bzGzCqpBzYqJmQIpKrdWRhUJPnOF5Y/r+jviSrcZb/ruyFTiie3WIv/drcj0D4UJRdr179G+GQqccrm/8mHgrRB7EkaK4hwpzdOljsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXSs09QVnHsjbamkgdEI1iPyU2e4lbAS5j99UOKJKXo=;
 b=V/DccqTCdSfFNZ5scWqk92fDPon/aWPWexOG113+k3SlkR4MdY/jKcH5qeWuL8xNUwCsYicV6fiRJX6tW7oZsaTkAVsxVdTPhGEw8jpUXPStoKlzDE6KsIvfPJDme/mwhdS6TdXoOmxMRKM2aIwVDRxcN2t8+j1MQVgHfuXpt9sYCL+oSPtRa+83OjLjQyy/doXD6sK/GBBvgWiyjDIFIApy1RKovHBKOXjAG6FvxWVNpfdCQ0+YVB6lYsFMXMGjiKjCR9MxrNhZfHqh+iHFWEgmEnBKNXfHu/rLaMdQxT7FEC8wCHRRQ2hWAWwqUZI/rYCpshYEqVhrc9hAM2eGcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXSs09QVnHsjbamkgdEI1iPyU2e4lbAS5j99UOKJKXo=;
 b=j+ItvXUBFTcLdN0UoTr6aNQjAX4aQnlIVA9zzbZpAQyy30kigRhqbn2vk4dM6lw8S/PwRRVKJzTlvcjItyRNB16zih489JaFpFSgPMPYEeXq5g2lg8l5POVQik3BxFEde2gLjsEfLEH/iQxVCqra2Ri85FDxrbRfgTH3dhEyq+w=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO6PR04MB7779.namprd04.prod.outlook.com (2603:10b6:303:13d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 14:42:34 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 14:42:34 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4] btrfs: zoned: don't release active zone reservations for conventional zones
Date: Fri, 13 Nov 2026 15:42:15 +0100
Message-ID: <20261113144215.3277479-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0026.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::36) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO6PR04MB7779:EE_
X-MS-Office365-Filtering-Correlation-Id: b0ac3511-db4c-4ac8-61ae-08df41945abb
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|10070799003|376014|366016|1800799024|11063799006|56012099006|261026140227099003|261009223027099003|261021123027099003|261028144727099003|261022105027099003|261021121427099003|261102123227099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gB9HrXy8vTdtiyWfAY82FkAE4sUbK+rIs1d+3bhnhOvjzEJb/EEfHeWR7GRaDZ2xbMJWdRG3KAAwJTcN0VM34/5KLlaNKOokxba+RInE/fc8zISKVU1crRa215jwjcgmlw11iNikqw4Ik+kfZaaZ+g5LHCwgWkCh8WHKH54XjMMJoFyDnQTR4gweaexR+JBEtLRhs9vt8+aMTGMMJKlq2g4uRbFs32wITZ6J+PBN70kBHyjuKL1i5lJxAf05j7YvKPpH/JJ3m7AjMmdsC1lLncYllFVPwiniTx+WaWXR1MzuTdjO4L+uPICKfIXOpoIRh6OISl2FliPLKGMBuwSWkdKlvv2bLwEexwJkij38NJIE4V79Rm/vBTSXpakfp7REsZirDrfk00laeZqM5aqJhLYRj3eDmNp++V2zqklY5Dju7SoTBzTkRna0Ldds/EJDHMvhmG/6iYr37MRhEmlFd26JU7heEplmco/wppjCmH8W2dyDe1Cdkn+uGr3TXHjLrP0birpRFzyCw4gv9njmbZVkHISJ76X5V5bHDXFz5zSXcUwWo+LJ+5AZCRU7yMOd8P3FbnjyemYqhhR4iwSdP0/kGgDasFKHhcKTmZTGWN7Kq+RHjdN4icW3IbA2G2tH00BadhBpqK6PpfBDCNd928YcFW62mOo8pq3cfYONeBc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(376014)(366016)(1800799024)(11063799006)(56012099006)(261026140227099003)(261009223027099003)(261021123027099003)(261028144727099003)(261022105027099003)(261021121427099003)(261102123227099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SGcmsn2phRHg9RR9I1lpZNeM4yrHVOvTfALjxGKw46b2XpTyD7kfrwxpZwlk?=
 =?us-ascii?Q?P7+lcbTnx6lOKtQAhDey1wrhXf/aVutzXs0HgXiRz0PPoCQPzd8qw5z2FiBH?=
 =?us-ascii?Q?GiyIVKptBbCAz2+qMvZPBHX0ZnmRe5unO9QqvnQdfXG+mmKcdmK9SV9sc2jF?=
 =?us-ascii?Q?P3A3Z2lO2+0gJh6tn/FqeBE1Sc9WKevJfGvNn+Pvw7zIHPUAMfUEPYAoE6I4?=
 =?us-ascii?Q?qKcsuCK58cr8hQBAG76UzLhheQuwuS0TRD5DNsqOy+/TJoYqAHOpGhwD6jYu?=
 =?us-ascii?Q?9rRp+8gid8nrE8M2C2IPWs+6Lb7pcuazUQ2b1HytIx8F4Pj6pQYB2y6wsGSl?=
 =?us-ascii?Q?MOvjn8Oyxu0qbyC77dS9h9KIBkWnVDtOEnLxaBJNLfCbERJeIzKY7EjskJXX?=
 =?us-ascii?Q?2KJlxq9gt6yi4NMnO0BU9WJbmr/4blltVL8QtNnysT97jZoldEDK74/MFriz?=
 =?us-ascii?Q?nbVT99148UfpxxbfudbEKSNzAlJkBTEcvJ+V+PfZx1VG4xXrgGVi0B+P4WDT?=
 =?us-ascii?Q?HIUdS8tPRWwg/SkJrxKLBxcD6JADWOitZiG6/SAweEvbHqHdH+a4BYUU3vE8?=
 =?us-ascii?Q?IO51WqXH7kkbmWwh3XQNAShJh7XYripTIegqUJWqRLKGaN5MfSJittQBnlNN?=
 =?us-ascii?Q?gjjCXylewsfmWVaY7Jg/+tSdtcIr5iOsAiKZwJHuafa+E5GSk0c14/dbvqFn?=
 =?us-ascii?Q?72wgdMaBnp5eAn8BkM0PdIp/ZVGQ/c0KXHS+Kg8ZYMQpgfHSPiNoiuM7yVrY?=
 =?us-ascii?Q?nqmwxUfkFXmYC7y4vWzEFh9/doHCSo1NUfJxqK6vU0XkCNmTUYNgPPgIDn13?=
 =?us-ascii?Q?l9UNCKW0qT8JJuNuy2fe9PEDa5HPk0c6jGUBOpeDzJ/qP6fj+uM8IF3byfm2?=
 =?us-ascii?Q?th3IP5yZjoz/74ipfAiJJrlYqLDSQlFS3Jwu9K3C+rNeHuTxLiAedSnlgOsr?=
 =?us-ascii?Q?A20rz326fO/jLreTHOaJPsTdttal44KkiTFnGkljQSwWODIbIFX0DnppJ62U?=
 =?us-ascii?Q?tLwvIlXbCqpFfmPMau8siSEA6939tC4em25vj6Pht8kGkLUq0IvSp0xsGcHg?=
 =?us-ascii?Q?/r34QFoXeF80rJE2aYWEjK0UPvaQ3CU0fTnGc78YehPZTviNqh9aZ0F+gopL?=
 =?us-ascii?Q?NH1R+CbHFXrG+z0GTe6VtKwPGqSq5j1HmS860bITNhkpPcFaaPCL3Y5GKfTE?=
 =?us-ascii?Q?TcARIDb+rdIfgVYPR6/NCkLgKvvvAMH2zQw5MC1OO0H8wsRvdrQjsiUKOkLK?=
 =?us-ascii?Q?XzbVNJbxgT2I6IEIxTPFDjSF93YBrrF7q6yHzj7H7k7vkMiANHHAmtcU8n8f?=
 =?us-ascii?Q?powtEsiJ+1T0xFZArasFP/c8sVa1SWm1MZJpoJFYc/oVia57SL5hoaFHOwPM?=
 =?us-ascii?Q?49R+F2gDwqerYlmIpqS4d0cKUdT+Ytd8/Fp2J/o+K9HADTdGE8gAyOoLmOdv?=
 =?us-ascii?Q?TJP+u0vL13uh4nd6KwJ0xrEVtf4uBPZR7y+MUSTwij5SksfvHMdP2BPRkvqa?=
 =?us-ascii?Q?VuBVrEh1NI46w54TDxGF8OMtWb0jQEDiqU0IwAeTMB07Pz0a6eEpbT0DBC8u?=
 =?us-ascii?Q?zHjGmSL4VySHh2+IWLj58BOkrtkVn2g+63+JEbGiGo4GRSkdLediy6ZSVq23?=
 =?us-ascii?Q?0KWERv5nPuuriz0N2+TK/WqCZciZTVMlcQUzE18LWZO+oBy4oYO5/2/vpFDr?=
 =?us-ascii?Q?N/tvysBZMFO5e7HQMmwEBkPdrCg7YqazaHl6GibfSY48VaZWJGKiY27XxSWr?=
 =?us-ascii?Q?ruFOpBgdphwcpIsOZDNl1cS2bzFAQnYCgonSo8mZaMIjD2yHVJpR633A9Dro?=
X-MS-Exchange-AntiSpam-MessageData-1: 5JeCGAxTVzsN1rTGj8k80+L4Z2FhsQwWweM=
X-Exchange-RoutingPolicyChecked:
	RMLEzk38rus4mMqPbtQDm8dvb/gGcOP/sE20i7TUzcQM4FMO36lEsPLSJVeTz+X3FrKGbgKquzfrgdgq/ilRYPgX1JUjhK9/Gt8DzMY55Cj3HydxARiyHDsehzSepi+Aq2Uh0zOcvcQfjRQV53O/3Hab7Tvb/+euiaE6u2mijpu+6YRXJkAuWSYmPbP6kwbqxaBZUunM5VIyOkjvMoVjbLbpRBVvtGkzCTLORIAtu6tCUqIZw8xdEWF45b2CFNalM06FrAysqVOXDzazYxBC62ehsESTonaZT+Ru63AQmAV7+4Z7feZkWVaWBt+wIuq23wpLXg2gcgG3RIP3IyAM/g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4WewNfA6myLVqFItNYAxIRG+VSmnik5JVCFMrj8yyT3LlY0mBU2PgCw0QUSHZ+p1VSJ4wBYm0gT/jb45E8qQuRDvCJ1dPlOgQa6wJrcZ+UJ/dqBX6tGZQiZ5ieq+MsAlzSZbM26+bXUUBP3HNOsTKkwp2sYLf4k9/62cFDIkjLoaOKIvH02WJtthou4i/pDt/XlpKTCed3cRlMzDDrSANkFPZmTezOoviCXCvrDkZfvcgDT32W3sp91qC+twzzeZb82/MkyQH8qbiECWs6gQ5L4ckcmBx18OEmX7+b/7z9KFRTM1W6oZ6gbXPagN4KFNTGiIaTumNYJKyufmATbPX3F3cb7NocHPufkweSmdttcTmhCwDmiuOIVFDvk0mw1DI6FC9aipcs4qi9j5SiZObQIJmQRclUlTrORS6OVwHEqMX8HCMvN4k1lXX3uSJ6MQJqlzMqRO47ptwh4Og6PDIiCtUvdHO+AogTN60UVpsVgZ3lb3DZLbYdQIGos2jMHV2w2kigi9oaqPMeij1QLBbupHmf4QeLBegC1qdLLhElg3sr4g5+UFAUJcOt3EJ3+p13MNyp2xCjTMcRcaGDMs0qk4VekTrAAiFZ/DNq6kxOkL1+pPnL8fr8YVp+BsKAmw
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ac3511-db4c-4ac8-61ae-08df41945abb
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 14:42:34.4511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0DB+S4hvWTVHYk9vhbhaz7OaaLlKQdqJxRb4e/c+E+aTM986bjEn8Vym5+49hR2vzF/z3OrHg3gPPjqG0hRclwAlgtS3sQvWOg+VZpswAtw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7779

On mount, btrfs_check_active_zone_reservation() releases a reserved
active zone for each stripe of an active metadata or system block-group.
Stripes on conventional zones usually hold no active zone on the device,
so they use up the reservation. Once metadata moves to a sequential
block-group, its activation fails and the transaction commit aborts
with -EAGAIN.

Only release reservations for stripes holding an active zone, matching
what finishing the zone gives back.

Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---

It's not the bug that was reported, but a problem anyways and I have
submitted a fstest for it to prove it, so I think it is still worthwhile
to merge.

 fs/btrfs/zoned.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 3192b86669b9..81489fa4a42d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3115,8 +3115,15 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
 			continue;
 
-		for (int i = 0; i < map->num_stripes; i++)
-			map->stripes[i].dev->zone_info->reserved_active_zones--;
+		for (int i = 0; i < map->num_stripes; i++) {
+			struct btrfs_zoned_device_info *zinfo = map->stripes[i].dev->zone_info;
+			u64 physical = map->stripes[i].physical;
+
+			if (!test_bit(physical >> zinfo->zone_size_shift, zinfo->active_zones))
+				continue;
+
+			zinfo->reserved_active_zones--;
+		}
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
-- 
2.56.0

