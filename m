Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602658;
	b=RXLT4oNXWwlXcX77fQZLfTZqUe3Mzzd7973eojOAnS7Pzh2eySdw8YxOtT6a6+o7dN48
	 jnVfVOFHS/QYzQIbxeJcZizoJzggfT1zcDsZc3pirrzBfJSNjEdXw2GbaLsJ9hnJAxQRM
	 ohOQLfk9qsgUw/felxetsRCG3ORqdziloRJoRLC04XpBuaC+sbrdd3HfR82VJYMTRLGZ4
	 rOMv345IFg5bSgGsqa4H/gRQIGGC3fRlr1EphsBiEKNHkYWwoUnKpy2ijsEm7d8cbN/Lz
	 SfjTgJpjtVKVMqXnQy+HHPR80AMOHPZmPhwL8nwdVrpAPtKebJpFQsn1FeOA+f5br9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602658;
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
	bh=dYCLwCLuNRTRi1RvazLcTiLwNNHS57Y3gWoxwfy/TUI=;
	b=ZvcrJBcFGnQUBEF1EfJSG2aT13lirDiEMh3sZUwNeNbfWFKEOj0C6gXzgNRuQr5y7d+r
	 ZrtT5Ew9ANmg1WjDIDT0hn7oh4TaiBqFEnaVOgmF5lHcjhtELify/h40pKWeAfc1lssam
	 A4fW5FpgeenvUsBzqntkTa178aVbCmTGPu7vqsKbvPha3qngnIrS6zAbOIs92dmK6KAtf
	 4eO4SWBjsOb7Cy2N2FmUKNrE6zd5wGXIvoGO/O74uqlxSOtkfAHQ0hKsnse3Ab250KA2X
	 iSozFaNaYmb81Mt6gu28DUtXlGfPzulC/FqXyx7/h8Pecl2o+DBW8ZdCW36Mu/8mD/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZCiJ5Npn;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=k9EWCdmK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C388606A33B
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C388606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZCiJ5Npn;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=k9EWCdmK
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602658; x=1827138658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lujv+oaanoisgi5XRdWUolb0lcF77nT+0hnjIJlLCrA=;
  b=ZCiJ5Npnyv2r+nvhK1iPD+fOG3lnKEm50qpJe4LbS5Tym2FB4rKoqDoF
   s7QKqY89ipCqEqr9ID32PiwDNRRmKXZVHpEA0bL9JEHE/BqXCNPNLqiIr
   bLlwAcM1gBi+1OL41aaBdsU81vtxQ7TVi+bhj3dPgr8ElR+1fGL30HbNZ
   7oeD5y3hFLMDBfwCwT6cq99A5yJlnWgmAWAVwmlZzIIr6haqmT49jS/cf
   KYrw1alKgWL31NlRm1xDm5NXzALLKoNmeh37yODwZOLl8yLg7EGXUt+LN
   YWmp+F7rCQKoujZCvhsrN+YqljgZ3kgf8Xh6M9LV3kWA7/amu7NM/tB1a
   Q==;
X-CSE-ConnectionGUID: c362JASrQzWKsT8oXnsDAg==
X-CSE-MsgGUID: XY9J9geNR1iV/8OHVUVvhw==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="157492431"
Received: from mail-southcentralusazon11013026.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.26])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qGmR44buvV2Wb6QkYQYFiHtXj53HuUIR4qLoYqIOsY0+A25MVrKQdCc+cjzDW80eZtPqg/v03T+/ViXpalbDJ827eu9CTmn2VpANDKlUQZ2mRu04ZE+6QfF36E486AlTKN99yAoG1F2h7wXO2RKHAge+2xNOJqCXSsWmi8spYB1sRu+A58c+ypdmsQ2Sm5QdZ79EiNMVcU8w3P97GGMbZduWp3TobzlEYI/BNAyb8uEHXUbr8tv1ftcvmprBVoqOnTgFa7UGOTIRj1eerJi5HdJpBtrgI5T/de2ZQEWVGKZ3SvjtJIDy3sW00OrY5p/EJU1MvD2RYjPrXC9C0gwrZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYCLwCLuNRTRi1RvazLcTiLwNNHS57Y3gWoxwfy/TUI=;
 b=xZG3ib5lSsYGypmfZH1guWIcmttpveoBEE0zEG+pLf0tSAxv7KaHEwhMLrs3mA2EcXJ0XXul40Ipg9YirLSG0sFXTR7fwD0Poco+KsikC+HBG5cTHKB42IPfHBcqMnF8CmoYL81vaoXYKRzNI4na5DjqbShN6F/Di+IN2011V/gKmsdOkkXSPZzrURwCBXQ5qcfJpIXOeZFCIhxhrIl0GUzHcNzdo8tfNIG3qa6l9iigW8U4Ok5b0WP5eKusnDJWD7hp85qaFt6t8z8FB4Mo00szYz0kkh05j6zDNP5L+ixp1lrD8dYX+RMntq89CQIkasPXsTm4hxOnZLNECfanNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYCLwCLuNRTRi1RvazLcTiLwNNHS57Y3gWoxwfy/TUI=;
 b=k9EWCdmKQ10/ejKH2n4hAqGXK+XI8wcKGJ1Y+7vIGOXhMh571TdA0G7mTuBIL3iTnP5AV1ahNpLOur0AJ5dIyPLAy9ZUpVD1GwgGPsttDlD6jgCYV9afUbixbRn0orlxQXwOalFTVDir9TTMkYomQLJezgQJImFO/XwYv6JtnDw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS4PR04MB9868.namprd04.prod.outlook.com (2603:10b6:8:2fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 10:30:55 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:55 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 18/27] btrfs: zoned: don't account superblock zones as available data space
Date: Wed, 25 Nov 2026 11:29:47 +0100
Message-ID: <20261125102956.266389-19-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS4PR04MB9868:EE_
X-MS-Office365-Filtering-Correlation-Id: 769c95f5-263a-4685-9e80-08df4adf3002
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|23010399003|19092799006|261022075727099003|10067099003|261021123027099003|56012099006|11063799006|261009223027099003|261026140227099003|261102123227099003|261021121427099003|261022105027099003|261028144727099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	V63HM5fn7cbQYkD1DmU9mTTZ1t2AVyy6YF55a/hPh9K8pk3qlthZm7h5xKkRgMKiZaeJy7W7h+fUlGSR/CDxQ72szuxQkZP/GsrdWJK7NhIPBCMTQIry7fEX656SCFK7cOb4/ikIxUEo9adHa/ye9HvAC8oruAEOZQ0eKze6KvEGQR7pRmRWkX7fg3fce5jHj+86uX7G83Mgz5yZJE9RT2gNysy7GiJFoVxJq+pcD7JsoOalxGK13OaWi/wG7BoqdJe58Q6XdG1BJxCPWdeqUKaxKuVFuqJEeNQk8RUr3dXGCW0ZVrtE5sj1SfTMdguExS6/U1SRj9MVGBjM3YZf8r0cVZhj6fgRys3Vzjd5Hj2QqPYBA0idJQIQwSlxm0EkoIbrm52WJaq3fMlR97GJCvJZqpneaJAdi1zn3ZSeWmlg/y7UZdS3e8fDFDfYnf6Wk7NHMbmUhiGtvRTo4SNTZgGzJPjWTMfQ2cqeiEjWR9WWWvvys0s7MpoX8whp08bbNCigpWHdgrdw8Be2vEvYT7qDcqwnKCbQoYlvuG3L4VfZEFEUjzeDlTSdC2DO4EzmT4LcI/gELEPf3/IfCfCxb9fXCrL+yyDNxcW/PmaBfoDGgKuMwFfzUF5oZzA1mavcthHWA8aUSdnAJCx4Jf3JlSUtTDREWLH5XEfmLzs3SZk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(23010399003)(19092799006)(261022075727099003)(10067099003)(261021123027099003)(56012099006)(11063799006)(261009223027099003)(261026140227099003)(261102123227099003)(261021121427099003)(261022105027099003)(261028144727099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/1C8rJgF7Ushk3rv58xJPM2UUlluFKn/mk9HliWImZFa+Mozra7As1/OH/0x?=
 =?us-ascii?Q?7pn+qhx62JG6zQxPfhBGmkrOcugW2/RbhQioyYBxLPWd7Y/uL4+cnZBNrDR7?=
 =?us-ascii?Q?WjLxGC+4FrUMvrQU0nYIVDUZnb/5eaFtAZy98iKIqcQ5Sqh0sdmRqpp0RR9y?=
 =?us-ascii?Q?A/DL7buCURQMHGWVxtM0eK4njVMDplazo+0a58iARrcgeHrN3GYLAFu9pT/x?=
 =?us-ascii?Q?60eh04J51faY2iD1gcfxajpdlqU/kh8/ECLg/cYFCiakLi8DwIHbd05u+9/T?=
 =?us-ascii?Q?bUSZhfcveLr8T96hWdwqDdCqLA1JM1FY+OpGkuaIWsqJW6izZAY3CeHLnOqD?=
 =?us-ascii?Q?LABDQiR9TGVUtzQW27lTl7ELIMSEHJnK5FpJG8EB+/UI6KN96qvs9zhSQA/V?=
 =?us-ascii?Q?FNKLQSLBUV3ky4ooEyM2/vLsmJvkkNJ5h8Qaybv+Ky/ZekyPhtGMvPlpth1S?=
 =?us-ascii?Q?/OFVEn7oPpVGaSRHu3UNoC6Kv8FV6ybGaW91i6+KzzpfmfHMJf/h9jqepPE6?=
 =?us-ascii?Q?y74QEV+iW71xesO3UpiHOd9s32Ycrw4TUl7zOuuWXzjkrDp/nQud1/v7btJc?=
 =?us-ascii?Q?cUQxs2TONzMsxWAcI9o31RXINtVZ48b4+InbYzPj39iJWkPc8cewWGTihyQS?=
 =?us-ascii?Q?t8Z1do+F9LHCBYQ5C35DPjgUOUh0Il7Rtr69LnEiHboAGATYsGbxkVQHZin2?=
 =?us-ascii?Q?iuN8SC+1b3bkgekavRq7kph0mvdxj37vDNxFw1bExmiKq5ok8fcZvqjSZmMh?=
 =?us-ascii?Q?r2Unm2isPIEYisvcUjZUTV6vLf6XDjftTAujgiLsPlUMtjhpW2+aVYw4OBZr?=
 =?us-ascii?Q?LhFzLphBMviwXRW3bR4yal7vPGI6MZKAYg6gsFojVqJMr+jNVsqElIaA/X8V?=
 =?us-ascii?Q?RCLONhwxGa2aDEvnHQJ13zxCmNbZ8FGbzawv96sApQPDAR9wFxYcbbxugTQG?=
 =?us-ascii?Q?4iqr76OlHj53+UeDINvyIk7fFRyXmUABQf/v+O2S+4rlv7S3zeyMJbwio2zl?=
 =?us-ascii?Q?u7x7wp6aJ3a6MeV49OEa5bwOkaSra6NEFFu9ghCeEGPtVPGYMkOwqaqqR5hT?=
 =?us-ascii?Q?ZKPNMIFiiMqma9LTMZqRMf+RMtHW0SnFyhxBBYHITacJryET0jEYK1e5cKD2?=
 =?us-ascii?Q?aXRBQQA6PCz0+RYOm62ZFJOP+uNSgZITpzSOqHpZ4+d09yX1i87VQNZXqhbt?=
 =?us-ascii?Q?WptY5rwfItZwz+RIdVDpHqq7e+2BVh4Sm4V7LBgMQUvolxY0ro9czKRjMwip?=
 =?us-ascii?Q?1pkiYFlvLBfdf28BHfMUAO/YLndmlu5vww4P+w3keT4s7WoPpybbvyhjJ7Ak?=
 =?us-ascii?Q?DYJsUEr9Ys4rntfzBviV39fqJ0HTKyVkiMixzQ7/4VDJv5SQcFj/pciPENL6?=
 =?us-ascii?Q?Qb/e9ww1CEQPUZEz/ShZvxePUZkYAxy4D4luWxyRLfhAIXcJXbIiaeDQwEXU?=
 =?us-ascii?Q?PeHxTveZqS/QRozxPZ4jtiUek95PkrEFBL1v5JTeP30e6RPtwNJpAbMZssxl?=
 =?us-ascii?Q?8wAPgGCEdTp3AmB3GkRvOWlRuOtuFhbYeaBjQHrCBxgnOUaU3UQrM/PzOrh+?=
 =?us-ascii?Q?/ZGBMz6SLVpDmEv44C7L2FC6ihQUTHpFIvONf9DQ8KFTuPY/cmCggxGGRnpI?=
 =?us-ascii?Q?GAwaAd42RkkVMWxgkkgFBCXtQsIUMh7F8xj1xZBl+QkMrFIsrlk2KWOx9UMY?=
 =?us-ascii?Q?mbP/bDyl3WtVgVXczH3NIgoLStmGBbsAja1U/dX4kVnNCWTmHCxZJYWLDBi2?=
 =?us-ascii?Q?OADDu6gfsJoYZYGdH3eMyeP72wrr4YWptbVG+JfXrH+33iy4vetqzW5qH+1W?=
X-MS-Exchange-AntiSpam-MessageData-1: Nz/oo/tngQx0kiz8FyjN4Uu3W0PIO5fjcsY=
X-Exchange-RoutingPolicyChecked:
	cvgTlM0esYYbivPmHBu79kPthgsgzbhqwd/1IM2Zdr/q6MDv2ziugbwQW7qz3MbzSMdF8oeSzhWVXgbu3B5N+VFFHUQb2aeJf2Z+/5dnG+gw9RMp07wnTcp+BgO0QLJrxBnAiEOHdV6egbrNcpRmXXFcmkbJXGpspWeqxGSLI5n+MdqJ0PNx+fS1snwdJJ0LMq+y+61jvy8W1Dt8q5h59CtYXkmorn7LPuwJJLWc7fY7CMUkNtBu7gdwmLu+eGFpxjWJ8oP2swDQeaY99uOMyYz4KTM9w9wWgPfOl3iAMENXfAQfFuRxpOPDkaYMUldlxANIxCUf41ISIwWkkU9mvQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zp+cThjtRdc/R9gdFNro2IOwJSdtv+hvGm4hF+ydAMyHoZVqjqwV8GaVPNamHvlFlsQslnHut9B3a8S1V43IfhKFP220GAVaocn8q+QyrzIJEHB8r/pPmHTweerA+F6rbJGxacpGYmWktNh9Av/DJh1rMoLmVUC4XSP1Uyu7/DUAPg+ykImHYMF2OIc8YbZKRcmjuqVI5G/h/971mh9rl3P2gwPmPt20YNo/yx4AJlfwF5uzOxv4a0iGQBXq4DKRSvawUTzGOT7I3IvmL02rFE9eEZF49u+NSs/sJW80efi7VL9+wCajSCbQea6OMWpI2V7azjEdxUZRyDZblbUEMX/aQHT8si6T1aGDoCz/9vejvoK/JfN1M+6PquDI6L5gcbMEYmHWdtUnh0vSb9wAomrgWN5wYfJL92Ukk4Dc2zn1d2t+DfgS3JKqezvmZgWmY40Zs5ypHOFLqWPU2j7/YogEHdqnPoVmtMBM/wMXE5zL93eA0lzk3BVJa7Rgrnr5FsnU5M1mJtwHy3RR7bPgFWdBUL813gHWRy5f4kyZ3RvTB5lQcs2Of41jDGOhItdULDzA6XUoWDJUhKS7l7BWQglyUCLpKVjw+Lj73m6+ALj4nczT/ujKd4Ri8vZKR34t
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 769c95f5-263a-4685-9e80-08df4adf3002
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:55.4373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q/NdswtxSKDg1Kd3dFHFZnBYal7sNNquC0NardFRf66zWOCwy4G4R43xMC/2HC7h+Zg3PkBNkNQXK/l7zlCGOvUC7e55zVgjeTNeXWjSGnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR04MB9868

On a zoned filesystem, the zones used for the log structured superblock
are not usable for the allocator, so don't account them as available
data space.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c |  6 +++++-
 fs/btrfs/zoned.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h |  6 ++++++
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index eeaef816025a..36d352e4116e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1646,6 +1646,9 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 
 		avail_space = device->total_bytes - device->bytes_used;
 
+		if (btrfs_is_zoned(fs_info))
+			avail_space = btrfs_zoned_dev_avail_bytes(device, avail_space);
+
 		/* align with stripe_len */
 		avail_space = rounddown(avail_space, BTRFS_STRIPE_LEN);
 
@@ -1656,7 +1659,8 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 		if (avail_space <= BTRFS_DEVICE_RANGE_RESERVED + min_stripe_size)
 			continue;
 
-		avail_space -= BTRFS_DEVICE_RANGE_RESERVED;
+		if (!btrfs_is_zoned(fs_info))
+			avail_space -= BTRFS_DEVICE_RANGE_RESERVED;
 
 		devices_info[i].dev = device;
 		devices_info[i].max_avail = avail_space;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index bd3e9203a650..7a70cb30b358 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -968,6 +968,54 @@ static inline bool is_sb_log_zone(struct btrfs_zoned_device_info *zinfo,
 	return true;
 }
 
+u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail)
+{
+	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	const u64 total = round_down(btrfs_device_get_total_bytes(device),
+				     zinfo->zone_size);
+	const u64 total_zones = total >> zinfo->zone_size_shift;
+	u32 excluded_zones[BTRFS_SUPER_MIRROR_MAX * (BTRFS_NR_SB_LOG_ZONES + 1)];
+	int nr_excluded = 0;
+	u64 sb_bytes = 0;
+
+	if (!zinfo || device->bytes_used >= total)
+		return 0;
+
+	for (int i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		const u32 sb_zone = sb_zone_number(zinfo->zone_size_shift, i);
+		const u32 reg_zone = btrfs_sb_offset(i) >> zinfo->zone_size_shift;
+
+		for (int j = 0; j < BTRFS_NR_SB_LOG_ZONES; j++) {
+			u32 zone = sb_zone + j;
+
+			if (zone < total_zones)
+				excluded_zones[nr_excluded++] = zone;
+		}
+
+		if (reg_zone < total_zones)
+			excluded_zones[nr_excluded++] = reg_zone;
+	}
+
+	for (int i = 0; i < nr_excluded; i++) {
+		bool dup = false;
+
+		for (int j = 0; j < i; j++) {
+			if (excluded_zones[j] == excluded_zones[i]) {
+				dup = true;
+				break;
+			}
+		}
+		if (!dup)
+			sb_bytes += zinfo->zone_size;
+	}
+
+	avail = total - device->bytes_used;
+	if (avail <= sb_bytes)
+		return 0;
+
+	return avail - sb_bytes;
+}
+
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror)
 {
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index af03ea8e1754..02298f408102 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -80,6 +80,7 @@ int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
 int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 			  u64 *bytenr_ret);
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror);
+u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail);
 int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 				 u64 hole_end, u64 num_bytes,
@@ -187,6 +188,11 @@ static inline int btrfs_advance_sb_log(struct btrfs_device *device, int mirror)
 	return 0;
 }
 
+static inline u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail)
+{
+	return avail;
+}
+
 static inline int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 {
 	return 0;
-- 
2.56.1

