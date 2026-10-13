Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD2B396D0D
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876641; cv=fail; b=TF5edv7MNsf1cKibbBqRH4gJURQVdcKZG1DeTZRdA8JSbWsF8EgzNai4zF0JdF4MxSPAYfk5ky08P/O5/zPzzV4ERan/XhRUGDNEELHsPwxD9HxZgL8NSphP+eQnva9PgOi57wsVvm837S5d/CspFAoA2reE3ChJwEbX5uT0sz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876641; c=relaxed/simple;
	bh=U/Dm4eu+6vHrwmJIQBlAeH7c2aRcXxLXgV75KT2zIr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iEL21D7ZYeNz+nNkF4gmo0wbs+e5bEMc3mym7LLOVWZOQ6VfBzECCuzjRt0bdwO8FRsPRWrdzVJC+vIPIwSmR06q6qJ/9RU0WiZILVQNMaZ6H5odxhIXG/67ixa7PEtlUkxjEgS9zcqn+/ZmD7aUt9T82npFI11LCy4B6K5UlX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=S7EuDW6E; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=w/xwOWPK; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="S7EuDW6E";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="w/xwOWPK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876636; x=1823412636;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=U/Dm4eu+6vHrwmJIQBlAeH7c2aRcXxLXgV75KT2zIr4=;
  b=S7EuDW6EX1QIjQUu7sDRD2mKAOw5PHb8bvtcxZ+qBaZ6r/BmRwhHg7xo
   Wn4xdukzcMXo+R0PyATH/l+mJlbcfQOHbTqaEHw2NpnBFl107ThlAvS8X
   MbvXTNageth9mkcM5GmVTMctrLHsLkVrU15lncVqti8QNl9AjG9RWwxuy
   ZXvJj7XCUVRM9ioRqN4Yeig08C1+8lUI6/hf+iCkOKKL1ccG/EZlWh5R+
   zPFTl6ph9kTNFnwUTiO02Rib1WRVyyLGYqRtLfYWlAXBucpZGFPvDoJWc
   f6VaK2ny+yayiqFKDYf0/BuQh9Xr0t3J9r4r/95vwwmxQzWmh0Kqcg/Ux
   g==;
X-CSE-ConnectionGUID: ppkq71IaRUeATgfUdhgnXA==
X-CSE-MsgGUID: w8McV9DUQUuOe7/KcpKc5A==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="158917183"
Received: from mail-westus2azon11012061.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.61])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lh9DVxstGIN6ac4jDz3PTy2x0h5Knrp9HQdKlpltMBQAKwYwWJODU7rNhc4NNxgz7nKig0mBSvhwjyK0b1RBaUjrE1ARTdEOc0DGg+RbJ4dkjNMy+D2T9YZ8FJ+1BYIjJ+wk1Iee3Sp/FH10psR6gfNzNjvJQHUG7TPLpfofuVsDywj8NLjTWREGSmZQXv/xC7tBmnoSZgyAY8/6GPZBmbkvURSfCHlFmm6JBoTVPEqRF/vKWl+KVeernOF2aAEz+A9Va4xaM25fTUPykRM0iWSucdkudGJl3z663PBOdc7l5WFVnbBK+gpRLE/27O8FkzSJBFA5UiTZ8jAfRV1VPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZGe2/62/SAXPfeFsPfbvcnoWsc5hCk/LKoJ0+B+6jqU=;
 b=jMWm6Z2Fx3Um0EBcX0jfaAZ51RhpT1ePa8s0uSX8zU4CUNrL/Ppxu2UKXfFwlFRNPxSjiMbxfRdwKtTvHQ4ih2T22kYqnWUGq8RJRI/5C8dJnyu5kreW5lsHaePXsC3a+6Z5w/3MYwX820LLDh11XH0GRHL9j3sqnWI+2zgkdSTQQB38e6W97gTM3zLkJMd5JTyNjb+baJ3fq7m3R+8ez1pEiHEJy/O5Q+Ga0yglVgRhQhXdQFkABGSNBdUTOE4BnrQDOgoBZfMF/MlCa/i7h+wgB7z6JnDf3PUPA022Bsk7rUjjlHMDdaZikH4JWtX7jtmCeeIgrm3ERcqytGjcmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGe2/62/SAXPfeFsPfbvcnoWsc5hCk/LKoJ0+B+6jqU=;
 b=w/xwOWPK9+OjSXMmInyZfqCBNc/nsIYzfoxmnGIbI5r3chwexN2p9bDxh2Jzd4ev5ignvuC1UnB2ghipg06x4cToZx3fZz1LuvYNz7tlg7ASC9xLz9NM/GmimheYRTaCEnUluWNUmOP6fnMXGqcXSTDJC2sd3PrIndbwmvDG3Kc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:26 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:25 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 08/12] btrfs: zoned: prefer conventional zones for metadata chunks
Date: Tue, 13 Oct 2026 09:29:37 +0200
Message-ID: <20261013072941.424029-9-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
References: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::27) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CYYPR04MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: a22a6f82-7a98-4f02-6ef7-08df28fbd941
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|11063799006|261009223027099003|18002099003|22082099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 fX0n+buXA0FkOi1xHDYWiCF1PNiHOlUTDUq8zUHD03hIywXyA2AATx1PrYaj/04TkHOATyqTA/4XPCn7UtGkOlNaE2J7g/c7OBBkTzSrTPP+gwzUFEoBER9p8ZjNVSIEJBs7MEjfsG1OwjMJnspxne07HdLDFoS/UDNdviNYYKFLt5qq/1kiUmdBTo1zJeRAy+L4YYRmcYaCtrivO5sQtUFO34uiu72HH/7plSzQ1YjXTZ9TDot3WIT2brqje32+dw+I5vfsO4w/FzrdZVNWrTJ04mCZdRBX25gKRNhGv3+JOxTW4dpvx7h3vzv4JkX/57T09nDQikrAx30+TQaXWeJHzDJUp+oiCAyICtF+8afkRsRcE7PdGf8hjwuvZyX2jFPnd89qw8bnjr3WvnqsQIJ920zNoYUT/I7VGTVfu3UsgQF1rIASgDyRxRS/KGkAdhLF3rtNSSvZKXD39xxSwK5KL6eL6+sB2vmf8imQOZKvHhi3ZTf9Lqha1ArRJhGhNC3UIGNxWmfEI47rZWk3z8fZdUZq+3CpQf4AntZ0Qd9OIIxfb4Wqv9IGxc2j+uuDwqMqqVWXAV6oa3pzhiTsU2X+VzA+Byy2RchrmeV6TMQWqfouvGzKev4GavdaixC1sJToInG4uzQb9dZYdRV7FGpUTvytjD5ajLaZqVrFpfA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?+hzL611Oi+PHHjvlB9SzXKKl+5NC9+uLeLlr8j0F44GcFGdDSsIPOoCsCGN3?=
 =?us-ascii?Q?0b4ue9nb9oLOiEJYzjnphsUBEs89eceRecIQt0hwf2nxR681R631o6UtvnmX?=
 =?us-ascii?Q?rT8Ik8/VuqsxeGT980NNh1Kg1GWeXeTX+CjcNBO+YeeVytVrLdTl4Rn9A21X?=
 =?us-ascii?Q?bML2e/UIEDn9cKAwehCBBqJ3a8F7/Ng/PtIC08uPDqBoAg+CgTqR76Uec8Xp?=
 =?us-ascii?Q?aH54dyar6oHJbyKICZnIdpKlVj3MVTzncXMeu8MHN5iGw4aGj7JoP0C7lOLN?=
 =?us-ascii?Q?UJnjUT8xj1RZcOYsfuYN0w5qtdupZWxWJ6T8rOkWMJYxYLBY2HLX50WRjQ0z?=
 =?us-ascii?Q?Znbfr9Ik0ikUtL2dKFGBvGPMlMpMUqdv2pMxWiNEi5yM9AG/EW0BIiJOdj1W?=
 =?us-ascii?Q?3ah8DNQ3xzVCw3cOjn1xtNFTrVYIEr/F0e4uzBNPWPq5OhvOgHnpqkbfOEvs?=
 =?us-ascii?Q?jZYIUutRQmr5GNSq4IFMMIvE7RupKmHOtZe7L0rMm85ifE40tcZDp7zQ4NTc?=
 =?us-ascii?Q?Q8DvZwjokj0Mpx3hjuFNXoUoMXmGkvSZvqRzl5e/Km14lla8PdD78nYPsgbt?=
 =?us-ascii?Q?Itn/kaalCQKUhaKDrwCHO4Mx7ubaS5MsjL28CCXu5R0Di+jLDEDoXwv4Seuv?=
 =?us-ascii?Q?POKCeQY3qvj2vOpr6eFQdoaM6551Qcr1pIq83KOYTTvEYlAqagoogt+3iE8B?=
 =?us-ascii?Q?MGc8GzQ9QSb5jkPHqqn9hlOU27BXlN9F8aDo9N/hI63dhdxZ4OwpTOpYVPge?=
 =?us-ascii?Q?7UF88eCkXPaLcMmKpm1m17NyGHvtC787IUGAc0o6VdINJBJn2jPxDmhcHcWs?=
 =?us-ascii?Q?cQXVZLfdBnOaCxR/nmcbzd9wd4YqE11D2gffT/Zy4aQ0Rvab3i8ARuBUwITt?=
 =?us-ascii?Q?7l+EAmA3hma5ZtAfZFskhVFmliaJgIOrdcJJ+oqqMTr1LWYnhfihzFDG/4YC?=
 =?us-ascii?Q?/iObYLVkKYGPcSWaS5IsGSxT8VhBHj2yYL+2e6kp2FBa+ovbTnuidlg1wnGx?=
 =?us-ascii?Q?2ugN/kr9VPpJJ9hVjevG926IrAE5GbFVn70cbfmHyMEdX591flvYP4bn68r6?=
 =?us-ascii?Q?7Ejnzrxrr7wTGKO5KDQIJwmelZP/KsSWLqoacgYZ0b0o156fN3vwq7f/5OHf?=
 =?us-ascii?Q?CaeLiRoVaLcV+7CaQRofL0Y+FWJwu7nudwY7cgn7biKzNowzo58yOPWk5lr9?=
 =?us-ascii?Q?5xrjiK4LKBwavfZg7WX9clv4C68/fwsZLF2N2mr3zn3TQUQqEeCwXsn/AHNI?=
 =?us-ascii?Q?1Hoo5gk9mrmkm2TjFiwrxtN+hYPru2NwEHRF/Mp9zr01U/8j3Jm/xOvRebMe?=
 =?us-ascii?Q?0HgoPRg8n9fYYDD2J1kQKvZeCJlsNpQ63EWzzCjIKGtkpHNd17KQlMw8gw+d?=
 =?us-ascii?Q?P7yv0sh0luh59XWbjMnGxFcNK9H70WYgsAY7m2a3knWWcn/uY/hBXJJEvc46?=
 =?us-ascii?Q?8BeC8CTRy1ZUbSwIBKkC2SMLCQVem5wcYfouKisTMIyGTTXaCNkfO7TBbYZZ?=
 =?us-ascii?Q?FFq2gSU+8yNjMnvwYTSsb2gVjKmCKGDYTLCMjzS4YfvE3Lmxyat39+kj0aMt?=
 =?us-ascii?Q?+vyU6obpdmQ/GK1nLwo6ym2ortLUsYu7uXvIV7UxGG+y0hnZNWg/Cn51c8wR?=
 =?us-ascii?Q?2am8SRWTAlshnq3+wEt0mliS1vLpwsxWAKs4t1re8ecBU0y/zloQKLi+tlEl?=
 =?us-ascii?Q?tOTwuMX/N+OCEGRx8Su6a5f2te0Eg7OWoPkznGWhbZ29EY15djmE5jE0Ib4f?=
 =?us-ascii?Q?KuXheHp5jJo/8al3SxVYvRzdPKP5avknsBMe1QtzrQ8pCx3iHJw645mknPcg?=
X-MS-Exchange-AntiSpam-MessageData-1: WJUxcM8ubK1TkkF7lLCFcfPmq3Iqj6lRda0=
X-Exchange-RoutingPolicyChecked:
	qNsh9lUjFothkFjcRwhn9tbE/oCvvbGgFWDeaOVTsThFwuMFnRTO2mF28KQ6IHclgxam/9JwT3strMf2D9Lmg03ty/nj8uEt4j6gn5fw/gBCjH2ymxJwzu664PV5pADU98uHuD7Urwlnv9wfTgjV+OKhi3aw56JWoRfBEvzERWAwkT17i4dLuqijcVdQ9s+QgFoQbKvTx8I4I2pATorrrpZQq1x/UrIbrdwGwzsVQN460K0mK+0v32dZoaPzBKuDlABqrTCgMdd0Pkdq5nP4cZVPhW2CxwVgeTbMEPzGUaMbvh3+WmAEXMuTn+fT5/1Hy2jwAtqxTV742mGqWyugxw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0yGqX6jgLfZKXPdG6XxoYjiFYXZXmEpoMlUKmRKGp5hXW8n52H6iecmEa6rGmIvzJmsMnZHWJ8Zu2PKkaulEWbLsOW0uFpaUoMDkJIxh2V0xCO68Y9yoxW5vQIxJUBBuRCCTP1+/9rxpNuPkskuu7j7oKLh29ZIhq7eLAwWaz+1mgo3tYwwbhZf8P6DS4Og1Bp7A6567KqwxN0ekRXBQIehe7rCa2LIf9TE6m6A0yccicBGEt3LYXZmlPZH87xcY7+DubUAbcQtImEKQSYJace5xgBzGw/M15qwTQgdmSh+SmCwzQ6aJ5XtX48mwb9lvxdrJoZBxg3abIgp/TbNCVGbnw0eKVPq7I/wxQfxMgYQcrrSW+YvZusE0faN6u5hcidjXV7BTasJ54hEW+dvomr1DiL9HICuk3u5EDuV8ixFKqFKRNzSRcr6AyrIQsM1mYWXEJ0OE5tv0iGTSnLWbrzCRTxUmYSYqu0hoX6qV/XQr5/JCtNcW2WhYbwdmb8YxHsuLLpHoIstSQSsWhIMe9qkLqz+ex0eTKCFSp76WjWOO6SPGXfV4RKdjTHN6dERd+9ZSEM01cNP8tylkPOnH9zXmfcjjpZCAQQ1p7DOkqwJth6483JLm1bK919rZgWTj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a22a6f82-7a98-4f02-6ef7-08df28fbd941
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:25.8631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AklhZ6Nhu9NkaKJSi1JWALJyJshR+UjvExdEpMAutBUfo7VQQbop6FZYHRHNrVDfzzs2JlGKGbPWixeGItdz9wXCh43BdBXo6hfcv0eGwtw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

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
index f41a3e9c30f2..250859087e57 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5891,6 +5891,29 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
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
@@ -5899,11 +5922,14 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 	struct btrfs_device *device;
 	u64 total_avail;
 	u64 dev_extent_want = ctl->max_stripe_size * ctl->dev_stripes;
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
@@ -5930,7 +5956,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail, BTRFS_ZONE_FILTER_NONE);
+					   &max_avail, filter);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
@@ -5957,6 +5983,17 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
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
index aff68b3af229..6d35e9f0dfd3 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -332,6 +332,26 @@ static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
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
2.55.0

