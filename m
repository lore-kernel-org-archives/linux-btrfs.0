Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794896106;
	b=nJ4Ht91B3oj6rwfH/QbXYC4wVNdEQvt6NgPK5u6mRa8gbV+06gJS/L8waS10L6DRQDuu
	 xcs9aFON/Yr+GBfwNsy77Z/5QhPpSkvIWNTStsAiBRXWEg95+09/b5APpeU0Z7Zulc13t
	 bhDxspdatKgP4OGOI5flANHTQSjp5Tls8WCxHj7/MPtuKfGrYdoaNl+wahJpijljfWR24
	 jFEP3Bc3FRmfePLeIb2jbobO1RqV7J1DP2b8YvDJCx5RaG+DhGgjiLIyCBs6X4BTgwVfA
	 PZ/Y+JXQgsVPmaNlkBEKLGgRfUTi0iqrG4yg3saH96YVvYfZ0JPIt7qrxOnJwYqXJoA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794896106;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
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
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	b=1ieT8k9dIC4c0HRdD9M0duzJwPwFIUuJ4zsq7/bA5ix0/ZMg729hqmVTfInGab8erL0b
	 6MmPTH4Bvqn2QyRvFT2dIBqZ2tuE0nIraBavNKiA1XfqiA2xSWtjt1KzcY8Wx82JnhCu0
	 Qt99S8NStkPWOFxbJ1Jzfum2kZnQXl9kJl3V/6KytdPlfWS+Xkg4vBCVgrS7wtIDfU82H
	 2ap5dwSDyqRy2NJl1uwWDWrd5vd+fhmT/fkUhUF8ioplc5DdM/ohUhhIg9gC54ld+X3mn
	 LZ1uMYaT2nFaWArD2jYrI11QmmEc0CV1m0z94fCfGTivq81RBgJ54B94UDBJn25kFhA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=abUHYdaW;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=XyQ8iL03;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DF2606A323
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 06:15:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80DF2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=abUHYdaW;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=XyQ8iL03
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794896113; x=1826432113;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=abUHYdaWKUl0pMGFvmknu88aCm100hL1uthFEnoqcUy5MWQMySKxbh0C
   NTWGcnwXS9YoBrGccNND7PRg9MpOzx/2OMql483hv/hPNWJly1J53DE+j
   jLEe4zbJH9niHJdYuUyaAutsI64g4oArdmAO3QN5m+33OazTtKWPx/sgT
   v6eDjOybcdsEZ+WUr8LHOcaAfHLzXgHQavzriWspfCd75YeL00x6C8NwZ
   7+KbJHXlUFbI9mZjFTL/0WP6cUNPiGrBvWleQwjl5a+7OxalRxgwq/pZj
   0XyPlxcB1LVm6AbhLqaCCea+dJrHxAIXD8w6Oyyb3kGbY8N+FngYnyzQe
   g==;
X-CSE-ConnectionGUID: 8Z1z7pwmSnqwY5MV+oR24Q==
X-CSE-MsgGUID: oFoOrtb2S+m/xnH+9d5DbA==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="162044878"
Received: from mail-eastusazon11011033.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 14:15:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qw2vHMsT7u2t1yiwXhdHXM+GdXRccdnN4Rx0n/TpgqOP2iNK05kC/2oQpm6CPixar4qaniruL5QV9LqZN9ASZSxkqq+MPv7DU91uaCRSw21NVc5ibMJnfz+X0KddJJOrjYpFebpU24S924/JcahHLioqXOCzkNrLIHYZyw/sbsnADOiIeIk+4vTUkm811tEgor3+dSDkEjam5FxdFvJHBItXl/IoWnKBV+hORALMwEwH3LMDUz2hYfrb4tr3diqWEGP/d1OxGgnWe0lz4d7SIQf94QAxpcl0h273YvHYaRJ5HRUSPDfw4WLRTI2LnpEbYTkOTsb/ZqpNv2M+5i/r5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=Mb6DGtjObCFuVbI/k2xP5iQkErg5jo9AKghv4Csfht4GDS7HBCU4iVhv7jXlyHb4cnmniYGeYbvBv6jz0IDhjvrafM7v8qqinGfl6nKJOABAXa454HyG8uHwvogT90OzrJJKuLg8IkybjQiCAJ3F9GEknlwLGpHxlnr7ovnOtdo9SA4Qv67A1aV7jW2l+1KuVO1rmPtL8AV7GH4jK1QIAllH3a8Etq5jXscv5YeBg02D2ffTnMVDLP8wHuu6yX3Cxe60b7TEL78/MYmaSSU0NtQNKYf8yhtI6VYXzgrA5fgAZCmXmJm41P/OaMnAbCmMkcy1QeeliEcOwwoEZzeqpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=XyQ8iL03xObEL997IUBpO/lpg+NR68c0Kwcs6ElHVIxsFua/M1aT7X7dGsKhNs5cgbIMtCO7rNOyZMOFCXEWCCWRhbUmGYYeCornrooWu35RrnCHF+O81iJHqc1GZr5YUpNJDoBV8btpn3v5G3ewVVDyX/RdpYEt6L6gOGgbwdQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9844.namprd04.prod.outlook.com (2603:10b6:8:2f8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 06:14:54 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 06:14:54 +0000
Date: Tue, 17 Nov 2026 07:14:49 +0100
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] btrfs: relocation: release path on copy failure in
 move_existing_remap()
Message-ID: <avvwwrA7omxBriEm@neo>
References: <ea3810fb56f15af9878aafcf4632eb82d2245003.1794520632.git.wqu@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea3810fb56f15af9878aafcf4632eb82d2245003.1794520632.git.wqu@suse.com>
X-ClientProxiedBy: FR4P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::8) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9844:EE_
X-MS-Office365-Filtering-Correlation-Id: 995d90d6-9aba-42e5-7b8f-08df447218b3
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|19092799006|10070799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 3QOtEDZbL65CziD28sbAbvxStzvcNgChcdhRw+rq9iQTrYltoDPFwYtN1OE7DzuaQXrtyXb9uhCFpZUBYUXZWUZiVz4FNBmM353o+Z7kMY0ofkMgsFZvoeVfPyakNm+eKbau9+8EWYOIUtTHfOWMFN+NWaEVSW1FrXScOkRdJwr9hER1dhAAf/xjXL5sKHhs+pUgROupY4R3V9wtt02ER2aZArk8hk3vnef2IGk/QB/cH9K5pJCOSnj34gOtOBi+btwmZngswkTaqxa3ZH6meTnuzw9WZfjCSvgtYMFLDj08BPqtL8XE8u4bpG2Ehw5TmOPAuCTBpLbqYWgJRlczpW2+zY3GQ8x/XKDQenAr7LAfg8oRVDzsFu4u7Jl+4MEiW1EeKt3hDMsvqt0UviFmGrVLy48YHZK0gq8K6iIUS+pTg0TpZTdIXqMXTAa0qJQOeCV8xrn/fbQ9JoQtFKMb/vm5mzRdLyVD6eMijkJtcR1aCS5en+vrs8GoeGGfNwF4Ms4RWF40O0f9hy9PDXcqR+zFndkv88xMxA2MdbYqq0NR6t3ANp329nGyLrnsdleRp91bDHoMIGG1qTYpzehBqIzp6Id/UJ7sUZqlMyQ6kHSiygIhDrjlcOZ+lvcvaXg9LEm/JWYHjdSOUZkdLBGQGS/6OE/jUNPqgi5fh4m3R5I=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(19092799006)(10070799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?CNKtEibduGjRhM+JbwHOtPgWFU3NA6hyXq0zClD4LDqiuzEN6P4MhnePwma4?=
 =?us-ascii?Q?G2FTdnNp/Lc5CPk8f1YXnV3PWOCJBysWWsMn2jJS4viE4NvwlHyalj5nptkl?=
 =?us-ascii?Q?RUrhHM6v33oqLPAn3hdX6lsnwZaPYLIPNsOfl2+COmSi1cHjV5bfdEVgsxen?=
 =?us-ascii?Q?/lmSUsLYCUD9kA4DfInavSsPN/Px5WaTBXzk3SzvGzmfU0N1pAuhQBbE9UF+?=
 =?us-ascii?Q?wHdmwP9Or9QESVGkrU/echQSp8FTpB6dFeqE8mrQrAOw0tk2L7ZBbdRyyD9r?=
 =?us-ascii?Q?41sDHcizwOMMK6Vwh1lXTa2e9afNaMqlESARss0FdQgGQBr1jIsUKtdRlQXv?=
 =?us-ascii?Q?9hLRkj7eZRxLUDf+RZDl7v/cp1VjpNtSQfHZPo8198k1xfuydJeDas+NUHj1?=
 =?us-ascii?Q?J3lUdpZkXTzQspVgOFTjmnrUbl6IRDplN9EdvCaHpFAapjay0bEc0uEPd+PE?=
 =?us-ascii?Q?L2LI4tISc8qzpEqvB92ARtGP9CBEYL/WvxrXyTo8TUAK/191vIUFDwnUaSuL?=
 =?us-ascii?Q?Fml04DmaHAmf7GLne5oIk8XkqDxHVEqNgGVRmiiYcm0XvW3fRbx2Yo/kKG+7?=
 =?us-ascii?Q?Xc0n5iX+Lx6KSA1JGGvYuOS7cQpinwf2GvST6qzBK49LniB3ww13+UpUa/p5?=
 =?us-ascii?Q?S9QO+pGBLms+rrkwcPwVmDZHO6hxlxdO2r0VhDyucne/XZgtqL+md/FV9Tr7?=
 =?us-ascii?Q?8IugJRVggf2EtGp8Iu0+hw4T61dMtC38zPw28UqExooCuDzUSugQKqJ2CZ0p?=
 =?us-ascii?Q?gmK3r8f1VonYQjPZX2v4zXGI1Ckt2k8jm7F3vJ1R1L2rK/zrsnX5Ec9F0XEd?=
 =?us-ascii?Q?dp3OgrWDYYIAWSMnddaZ4krbBCNOopKCZFuD15PDha3cvuDn/K7ZxN9cAOUF?=
 =?us-ascii?Q?OJQnPoxd1zBRttBYU4v3OMnTdGkvshWgyynwS5wWLCeK29Nf0frZDhN1tlTr?=
 =?us-ascii?Q?fSr+sWdt5dVIqurXBMr2RLOa4yeJ3mN4cp34gNMS609Px85QIoOM2E6J/DPi?=
 =?us-ascii?Q?CwKtxH/LTaGVSU4ewSN+BKb+bmcjwZ3V6D0gKORCfs08WOZL8MRA4xYppUiF?=
 =?us-ascii?Q?X4ZDQcLNFzL7JckGEl+FReus4+RSEIPFhx/SjnlgjmGOFpQkoaE38aHCxL26?=
 =?us-ascii?Q?0qP42mXgjGCRYmj0DlIZhZAns0Js5N49KjsQRGOV6KOsh0IgVKtpVgfJvHb0?=
 =?us-ascii?Q?1D6RjmTdmuVjdSkt5Dnj/Xy7Y7dH2YMvU9rbh0bBbvTj5dsHFhhnm1HU0fRI?=
 =?us-ascii?Q?pWNM4p2XzMOK/FiLIxFvGGO0im1a30yWkkFOnWXFtJJx+zh3PDeJVzbDeRoK?=
 =?us-ascii?Q?jeHsNUIvbHwS2a8uv4rbmpMPAAuxx/QVKGLJCoa2gmVH74iIRH/KxchIdS4v?=
 =?us-ascii?Q?YNzSYvlZgFbIHJxLVKgAl0tMxfQie95K7abAnV/dF3z02Ph8FT95QAFR/wd6?=
 =?us-ascii?Q?tZvJB9QkTjnDaiVgi/0ZLtpOSpajPRvCtn9S1JVJ9kvftooETfodetqVDy26?=
 =?us-ascii?Q?1Qo45508gM3SkwGZSZb8b/arncD2OnNiGmTT8oVzD+xXwYVcU6G97kggddbO?=
 =?us-ascii?Q?EbWaQZg5CJy5ZKBZVmI8gMDaXhWf+jWiAkKxk/ECfxFdMs/LdQa64fEnSUYU?=
 =?us-ascii?Q?Nsl7A9g2qCyz/XSjWc/+nyI/G3OBNlnIX7ZvbqdEwPi7udBVlsSJwVmWUuCB?=
 =?us-ascii?Q?9bhAWvitUhMWYYRuFgffHmg8rSw64505SlNbVGKiQon24o5+lDBYoO4aSYjJ?=
 =?us-ascii?Q?33RmJ8IikEtdM9D3jNKJHeb1uUZB6ePOIMOCIyPB7nPszbD5xm5UqkbrcGi2?=
X-MS-Exchange-AntiSpam-MessageData-1: jB51l24avneb/jrYGoXkBuuEza+VHqpSRFk=
X-Exchange-RoutingPolicyChecked:
	uYjFbrcbJIzJGKEh0zviFsU13++3h3k7TphYnaCXetVAanqe2Cqfkn58No5jHb7JskmHI1jc2m7C3WkpufpYB90bZxk5D2h+rIu/pSVXKjAszezLBu5m/mPt2B3TFzSFivBSOT37HkAPxaBFc4n9BZQGgtPLLC6Qlf2gJ2zabd+ZWmhJyxPIMEOhetEHor7M5aSoN7ibe3eSoN5QQyI7IvttgavTlrrrhUlDNqT6BeNHcTYeI6XJyWV1nxbP8xrrOo6hGgYotxt22OsDINBdPi/vuy/M9WkjUOput7yasw5RutAPmy4wMpSt8mL/sA0ZNOQKO0mRk0zl5hH+y3BZpg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ubLCb/+uE5DRF15/u6UQmdtGrihf+38d9RWzZhM4I9qdBO5jzFcYqRPamn6yii6SuOdbSB5/2Qas25XtlSyIL9iLLJdwvkVNGRD8qdPWPkZKZ6IeXbssPPdBmFOboicfOxn8wPCU+mo36kDnQZd8C/ba8JLET+mM+7d1/LyEg67fNFy4UqBrQ+stHxD0ux5aL1NotMkRgdJ/Lu3rowuEi1KhrLxzsuGS5KQyiXUi7E5f2dgCAQt8P2Chr3AigWfTzj5f+dNsLKxVIL8OthX5Fogs00jZhAGSY3cyt50dSWaj31bwLOp0Z1HyYLutTI4IKuZvpEv2u0a3STNqJWuiuO4btuVMzGpjOQROYNm0gvoXgJ8t/gRA1SLEamN9bkTMS8cQxe5vRR19nMUnxafb1VHox6gBcmLxMSWsMOWZHydqDSTfwOymHvVtsrTC/+ShPFAGH/T/dcuv+wElfQ0aeyghUcEMMhampZWNz4tLe5HA5aF0ItmHtPlp47GAA6HlZ7dD2sff/dpVCwaOY0JCIJ+mPIxlZj7MYXVaydWUcIJW8/ZGi+1ECOzSw/V/cUZLLoTHM/rTN3kBQrb9yALshAfM51spkoyWuToXnLR2D3+pT3x4fcKUyhDr+FRbwbmx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 995d90d6-9aba-42e5-7b8f-08df447218b3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 06:14:54.2784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q2PRKeapkmuCKBm5yjpnzM0FlEynMHp6uVKtJ5R/4vn4AxEE7/ck9PkIGhRFOAww1C8+4ULI39uIOh2Kbs/+Zq5V9Lff5aZr9e3uURBAJQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9844

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
