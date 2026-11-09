Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794245365;
	b=lVPOoeiqoJRIviYU8OiYt77fVRk8EUKekRnDb+/ac1ZPRFZJNfGTy7o+tsHaDWkLhi5I
	 KZV0R2HxoWTmBa0xqFytm2iHE+waCz2R0aiKQOPKmYBuWq11aJyuJtlcVxaFBztyqc2hE
	 8++lDBBKop3FwAz3/C88WMIosTSS2xbNLkSRRXpY9FpAEoSYkIITZZRLYzgI6sKl5L1TM
	 WEGeZ3YuX/Amf8p4xfucM1IvgB7/iYEWOPXRCDbyPPSpRfGyD5OyGzspewNucuecs8gga
	 bsdJgPKKn9G6/Rz+fvmW66Lbxv0fgGU2YZhB/qpEShgKx4d4cOFnozA7dmVaVqF01lw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245365;
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
	bh=ly5khcu5kyGSkylXy3U0zXMnTa/eJ0YyielPLeUgiwQ=;
	b=uMp6YJljlQlKgqve1G8lIA9wouKGE2Xe+V2D9/JYC9dOcXqLkaLBWCcAj9dXYEfDacTR
	 wTHRwgiURQmu3U/QS9VSNKtt2UmjbaLKWbyYkSpn141OejhYvnDwiB/w7EH3Yq+Tz6yWq
	 olLAoO8ZL5UmFYmm58sqK8/PZrgq0H8Kg/6phuoGcTdNSb8XASrwTX3OTBT5RkHS8WRGp
	 2s7t4xt27Kle/QxLJjkwTQinUl0SIlSbMh5XuBUqzls60eMhEixbfpVMRwwJ/JsR6bcMd
	 Em721gi5/HNJk1n3BvGqsyfE7a2P69hVRewpRhZ64L3g4RkQfyamhDhfqi63EsrApGg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=esh3gUY7;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=EHg2vRXj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDC7606A31C
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 17:29:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFDC7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=esh3gUY7;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=EHg2vRXj
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794245372; x=1825781372;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=VlnUNxmIwoOxPQ/lshEkMXAhclTrB9VBhSzfoAaKpHA=;
  b=esh3gUY7ss/YM8Q4q+TewW9MlrEMYVfnxXYbjVjPZqnBH8+fYgOrecLp
   P5FehMvDncJefhmQzNMwAc/lxOOzds8Jnf3DKlQIb5QsfgfMXV1NyZTYa
   4jmFNf2l2ibxGuPhH3aJ5+ba0TiqaG09aSbHsjxvVPNQtFypw/uwQW/nr
   uGGJpukYNWESCt5lpgDjHZMmyhFCdt1hVtO3+nos5GlY/mKNcKKLw01Dy
   ldZpfPglWtZxz+JYnc5fjWNjNha8UUNNAsd/+DqIjPV4sT8Dz4+ve0bQZ
   spBNkgSTpJM4dFY2rAYR5mCwwWFIj1rHaoNcZYgBR3eCfLOfL1TQ06Flh
   w==;
X-CSE-ConnectionGUID: APp+GGC3TNutBFlj/uAJxg==
X-CSE-MsgGUID: jgVHWZ8vSxutl0vzmE7ayw==
X-IronPort-AV: E=Sophos;i="6.27,204,1786982400"; 
   d="scan'208";a="156146509"
Received: from mail-westcentralusazon11013037.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.37])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 01:29:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=USz2qjvnO4nxqqPW75zf+jLnQ1q1uSGzIlF5NYriQqRZ036FDyDyriq/qZBSmOFoNbfA1ntcQ/AvoaXQrcDQtdCk+S+8osnQ5WNEQ3eZTUYI0yDUpAViWD6VwTOe5m2n86TBFsVp0DEVA1qLHE8e2e3PcSLoollCgNnDNsUAPSniKLEdB8ncvJNoE8A1VreAsPB4nzE1Vv4evuC1/VZbmhFnpNjEjdwM6ULtkyajpuEqhiXE/vzArUyJhYX+2oebCkeFZ72aEtDzgzUkcsWx+QRAZONOZhxJmpW6+fLQ6RwuDs/Stb6c2zUeaAog3uHhmhUFnCblmo/aJrFu5yxrJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ly5khcu5kyGSkylXy3U0zXMnTa/eJ0YyielPLeUgiwQ=;
 b=N04jpJ6MfzQ+xklvfbJNK0jJF7t8RQOxtvPnTK/50neC5TrwmgabqgHojr6g4zLdlUE0kKCbo7rCR0tfGLMTC5WBxoDdebx0hovPM7q4Z92r6KZSK0V/zJOBDYSeCwNSy+reRTqkWNJEUy2nOMJh3eeHi7+hGLUAmZpMCm02ARcDd+sUdXrMz+glzpUsWEKCYgAXTpYvUHTjSwFQsJRGVLu+9zSXpfMb9zzJxAgz95uWdIbelOVdF8qSQ+tg/5iLApVFHgOd/uwp5twnhOLqJqw90uk2HnnSxdf3jgvdqrKrdJa/GY887mxpM0F4Rzju+Uh6JY32K6waJ5gBVpOY/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ly5khcu5kyGSkylXy3U0zXMnTa/eJ0YyielPLeUgiwQ=;
 b=EHg2vRXjV5jeCDpUhkDTb1CGBt93u7Ji3me6AlVU8ASsYWyqcwg35FLYQFFfDUTzr9+W75WoVZsNbEjC70POAzBORDtKOKQjOYjLmw+oitxRrMYsA+hFlYZX3N1LFkDrX7VnrilG6jo4NyJu2CDmwnVgWs+T+kBJLyuZeN0BU9Q=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB7907.namprd04.prod.outlook.com (2603:10b6:610:f1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 17:29:16 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 17:29:13 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Jochen Philipp <a2jphilipp@gmail.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: zoned: don't release active zone reservations for conventional zones
Date: Mon,  9 Nov 2026 18:28:39 +0100
Message-ID: <20261109172840.1142171-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0188.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::9) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH0PR04MB7907:EE_
X-MS-Office365-Filtering-Correlation-Id: 90599284-8458-42d8-32f9-08df3e86f8ab
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|23010399003|19092799006|366016|376014|1800799024|18002099003|4133799003|11063799006|56012099006|261028144727099003|10067099003|261102123227099003|261022105027099003|261021123027099003|261021121427099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	HbWB2qNtOgPZAM/bkOOh8RA3KbH/4CvUsBRFUHNm8UxHinqOYPXIttXrhQ7GO2zeVht+Bu29vrQzIPCuvqQ2RoIaI7qad0F5WTagfxWXJcsw0igDCloLFfTjymaKFQlVG0F/siM3wvQD7pBDx+OnREEaSx1bld6XJ8q4XRg1NAtGnFquGNoLaYI++8rJYxBHAGL/Ax+QTqLxKyxeBfOBIUkv0yu21zA8CvEqRQm8Fjny9v62yEV0PLdRYESJoo747dIMiO/ssEDZKldYR4uPS/pNYj2KnRTR5wx1H9kee13n2/M6Xd81KqMGiR9fxfv+fBbMisNCEwqbAFACBjYS0MJh8ZCvB6PibpvTlf7X8cRbuy61Y8OHll4PS408N0gi98SR1qxHPm5VEgdV/iu+I70/6Cw5DwRAIWIjx6im4dExvpdbNkrg2koIC0pVfPq0rEwIPJZjNtd/1IkoQCFDd0eaHg7vtcNi32NlmY591RwlYLLNXKjvi4cXgRzFA27wmpPny6cyNiAgoMtEXtH1gVpXJ2HaICkgxj0F3Ka0Th83jOQ/5ts4SPw76I5HOUFOgB1BpfiKHWzjchUufuu+pXeVFq0YIjK3rTngT8u90wo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(19092799006)(366016)(376014)(1800799024)(18002099003)(4133799003)(11063799006)(56012099006)(261028144727099003)(10067099003)(261102123227099003)(261022105027099003)(261021123027099003)(261021121427099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2Xxyq4medL9MW/szmhuuATD2yCau0vzmGsMcFUh4P+CvfaZ16ByXq1v46CYd?=
 =?us-ascii?Q?8s82W0eSvFUbXBLBeBny+w3jagcaK/DC493x2OMkjhsR927rZfMQ/pnt5yhW?=
 =?us-ascii?Q?QNKeg7td+gHc8j8XVYLTl5vO00TkKLtzXZcQZQ2b+MHu62XO4QZ38DT4tsh/?=
 =?us-ascii?Q?NSNl6uxIN2/aMHeKQl4vKrg3KmCE0n2J0RN3P0lf0uyWZIitF9FnPleyQM/M?=
 =?us-ascii?Q?CKYtz1sx1U3BmsBTxd/BR8qYiY7CKidmvYymLQrx+hz9k1YUC7p/V38I4yqi?=
 =?us-ascii?Q?0/gGZhnT+mym24h4366ui71SoNmCnGrBK3gr8vJBilytRBM7O64ouMahoGFa?=
 =?us-ascii?Q?IvXdRFhsazOdOXcRbR9TEo5kt264vNKZkHPhLA1yRMFpE8HdvCTiIySb5iXa?=
 =?us-ascii?Q?isFxxxyTFATzkNz0InUpp+wY4ZSBZB32HbL1NuYqDpB32YD5/DlsQ+d/rOzl?=
 =?us-ascii?Q?lmA81n2tYzpmH08adKuP5S1xruIrWBdgcNVSO8BiCKtGBvjvBnh5xrK6a19c?=
 =?us-ascii?Q?wZcx3W/cMM3H5bb/yxwSEFijpdfK5OYLEIMbaHCvURT/M4BnICh+dCpQ1N8Q?=
 =?us-ascii?Q?FMsCD9U4Ms6Jv0WTEPQ3jxHBSTI26qyEWowznFkUq3v9rbIcoL68oVpE2eHo?=
 =?us-ascii?Q?bHJ7+WRSiqtAxkClX7VijplZw9+tObF4o/DGpogfyynmW8V0ONqnwlw8GXTZ?=
 =?us-ascii?Q?gwX7CMS+fKM6DKWTWLA24bYgHhvHdB/MUCdu6bOnjvHzue3BBIruhWaPJQEt?=
 =?us-ascii?Q?/tQyzJ21cvcJ3Dg25f+uZTR2a5/xwkesXTXcZBhyqf7D3z/XI9Q1CtmEaKEj?=
 =?us-ascii?Q?KUR085swMBbnSK7Y4LBixuS8LHKkjTxM5Vm3l9yOFFhYuwb6ea+ZJ89Wsg1O?=
 =?us-ascii?Q?uk3kohK+UYizZtw7pWkTsMOTAwnlf9O5ZGlzFfkDsHr5V5cQLJlRHR9uZ+th?=
 =?us-ascii?Q?NbizRgxk4WiUdgRfhVi8S7G5JsH2em7VYnjfpSr5zJxL3wMZRxmBL60uzJg4?=
 =?us-ascii?Q?TZTev7xEK3pwve/mM48NYvsmunkJxNNqbf/9EoaXYbRQIqH5fnk0aiGUOKl4?=
 =?us-ascii?Q?0VYX89LvQGQOkSXoS3XaO6DWOkO2G5KVc7VNGmt3pux2j4aUu1XhHwI9R8XN?=
 =?us-ascii?Q?rx58+gZbh3npOaSTz41mMNJMmtzQZ5J3R1TS9BnE54O9saqpUDvOHlHy9S4z?=
 =?us-ascii?Q?2c0tt4KZrVoeuk5XKF1T3hAEczC+tfiGUjnNjLLeTpZUd8kQmTUU2jmtMD/9?=
 =?us-ascii?Q?6bul2QxfcU11YBryo+TEa/Bx856paAcidCdqOJAA9l3WjqW9k8rA0/UUD35o?=
 =?us-ascii?Q?Y8jh0SV8KG+SXZjpUT9w3DkrpHsWUQxhHoypPESj0UQ6QxnG2bvVgAwlu0Lg?=
 =?us-ascii?Q?fHTUhpzLAPHA/EHMm+th/VPlUXzHLPozxFb5RacLGGcWBS2oFGIgLilj4fmS?=
 =?us-ascii?Q?VeXp4keRJzLgf3WwpeUsQ11tYO+mczehTbxjJ9NkvhOspYb8DNllSpb5NTHr?=
 =?us-ascii?Q?t4BpcLXMpOAa6/YQUNewIbPjqXSjbJkjyeIu2VBy0brHb74aXaqbRJfVPmti?=
 =?us-ascii?Q?Fwtk1k420OxGkIP6+RXwkTPf7XWF2PlEXD6UGeOqYgEumFIMKCiZLeyDbhNq?=
 =?us-ascii?Q?b+1WvmC0Q33Fnr+vI2VYgbogwqPGQc66x/GE/uqMo59fwF2znvhQoWtUqhGI?=
 =?us-ascii?Q?oCg5BXl5siPuD4xcQdnUrsR6wJO40QtywSnhu2UrvJe7KFMqsJh4iX76p+7K?=
 =?us-ascii?Q?tOx/bVnVq4P+Djphj1wAfbJOegOUxY8ZtBpeM1x8HERCRzSBK7i447Nzusnj?=
X-MS-Exchange-AntiSpam-MessageData-1: /EbVgmsm+iInisA2gQh0Np3VDB9eKJERKr4=
X-Exchange-RoutingPolicyChecked:
	4kWI/g0nk/8E1r77XnB5hne0VoxAMYMrwXD1moya2hv65CZMVzhSzIto6yKmqeLFDI+tEM/mXIc70rTO8tHgkHca7XZ4A60nBYPv/eUrsy595eM1cBWmEVgPwzFee2KjI+hhvM0/J2zNNt9Pg95tRRFPozjzZFj6UNxOjJoPsNEjdoQSX/g42thqtpm15WA+3F+PacfVaXz3N8jhMeSnQflZzpra4U8tBY06BvclbNm7abm19NwgQsAnTmF6qwBthiAnrNgSDNYDH1t/g2k5dC4bk+2wRVS2KJEG0ZKrooFsz7BaCqiS9s/sjraUxUeTvkoZpYXcBJiGZNJ8H5MVGw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	29xOHvLSjtPpk2vykmD3WPYcSIB6VBi9MgUHOXzOXrXL+hNdYz16kbDScc1ZfgQ9ejthG4CEU8ycIGFei5YJ9KeLN0v+XSdlqw26B3JxKgpbs26yytK+1dKKj4e4Yk0ZZSM+Lpqzw0VA9zUy9pLgAxUxFLhPwbHfm1KVuXyhKGM9aD1qdC0RBXrOnYIorsbc5N43OMXRx1yEeJTXtI+3dpgJVa0SJ+1S2okHfL97vsXBQAEJbOop5aUaiaFSShCcxogMFg/GF6j1RWQHMYFrbSfamnyu4OHEzie7rT/LLDhM24GvLycTjTPbapzHuTVFZoZjrNdOrlAn1PXNw/UviX/oYAiETECaK74LgQ8Tv2Wz4/wRcxmZYhgDXDzpJYMOSDG+EvQ0j7b+7+I2TWi5cwiDvxTQH/r6sr+Mg2Md3j98ujiDPd0soYNgBwmcTuqlOpc6qwrdc63g+zDOAqrwWmXX3AAoy7g6dTJl0bTIFhkGk1B47cJHIvMHXapobjYHbPXSkIEWMYWiEf2Mof+r7WQ/Oy420d90BYIzLgK221w0rq6xc0K2rjK6fKJ9zrPMDampRWd53Jb4DMH6+VGishDS1FUJOIIeYA7bEx0VDloGlvptAuhRkASkpoir6EZo
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90599284-8458-42d8-32f9-08df3e86f8ab
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 17:29:12.9583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FOFcEWGatP9DxEZteMBpdAehlAvJqHl9PxSPQfPwhnfFqPZiw3mWQXPNWK6X/f/6IckRliT7vKxwEUlXvRl6c7NbMlxr1wM0qrGVy5sX07g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB7907

On mount, btrfs_check_active_zone_reservation() releases a reserved
active zone for each stripe of an active metadata or system block-group.
Block-groups on conventional zones are marked active when loaded but
hold no active zone on the device, so they use up the reservation. Once
metadata moves to a sequential block-group, its activation fails and the
transaction commit aborts with -EAGAIN.

Only release reservations for sequential zones.

Reported-by: Jochen Philipp <a2jphilipp@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com/
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 3724cc0120d9..7058f712936d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3118,8 +3118,10 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 		for (int i = 0; i < map->num_stripes; i++) {
 			struct btrfs_device *dev = map->stripes[i].dev;
 
-			if (btrfs_dev_is_sequential(dev, map->stripes[i].physical))
-				dev->zone_info->reserved_active_zones--;
+			if (!btrfs_dev_is_sequential(dev, map->stripes[i].physical))
+				continue;
+
+			dev->zone_info->reserved_active_zones--;
 		}
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
-- 
2.56.0

