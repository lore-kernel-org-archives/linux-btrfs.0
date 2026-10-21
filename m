Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590123;
	b=vMPF3NIUKSEr5/o++1eMt49WHDJ96y4gaMTVH7zbMq6Cdnc7ufkGpaMew3VVcahQj1Cj
	 VZEcXQZU4NnCYizCSA9t9epMX0UyYHUd31Z0Z0YndWj+AIzNzk2HQj6KQVuxYNMAWv+Bh
	 RI+sMErih+AqyzoAJSc/Wuvaw/oXofASVcKtBlRAZ1b9veEVa174PX9RVGaZJ00igMk5/
	 5XMkivHv8w7NyPrqpeaTdwwnah4Ace6A5Mytc2tggcVRepW6Oj+JgqMsmP91Lhqa+TynD
	 as1CQt1L3a9Y17VFekxXR2CxjkYUunt4PWE8DkpQF9gA+tcOrsobxPMOIqFuqKRzYqQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590123;
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
	bh=WJlaeU81ZZR1uE5/yQKoPWayJ1YpKGs+Oap6pT3uZx8=;
	b=MAEwZCwG5oeQOoGEGm4H+7Wcn1N2GREMVYmNBROTK/SHcA+UuGItXx0BLOjyln3FsWRd
	 VJZ9vsPn0fpWi2+kBo76zl+YMqjYS2Ax9Q7SXEd9J3j/hRyGFKbHkuKBVUTanS8BWrKdR
	 +1S7Ig2nX2HZmKVv+NWUnfg2gtdrRMLp6GI1bljTuQvhWu838yu7XHC1CEkuyUjdLOln9
	 J6FVn8cpJnX3AruaVdMcuOq3R4Zy6Sf3KNPV7AOxvQWAutUXiRbBX7EiOHhZWFQ+sYQti
	 3Qed+fLHMnsEasOZwNT8TN+zNk47s7+L3WLNvxQ6Yjn68jwOtlK6FINJTlkRm/SJ7rA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=pvaFdKYs;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=yLuoZBYN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E08D606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E08D606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=pvaFdKYs;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=yLuoZBYN
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590129; x=1824126129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=vV7uTwbnL2Xi962H8HKrQSM2PsKcF7hodGI1MthiRaU=;
  b=pvaFdKYspR+jlsBINW/YGJPtZzpUW4/z/C7it9sHK4zuB1aE86cupvuC
   U87uLTao6SDR87fBXx2tgQkiLK969kRZKUcNQuL1wb9ouWAjScMoTA20g
   Qgst3uZ/PF9YbmsnIa44OhKKMKLdZemdNnk1BOfzli8Uqe31+dmrk8DLI
   SyQT4FLWLzALDiXs8zFAyekEen3I5LYLLPtYJil+dSqh6RTNJgCV9v0ku
   PIYSMEdqMbhIij4EiYlnQhjn+B675SaKUdzQmzmlVmd8PfLDmzGqylabQ
   c9ZV0AQaOV4f9Xuc/p/fLyH1wipaoWqI3DZ9T3/GiVsBKkgAYnmBQ/iZp
   Q==;
X-CSE-ConnectionGUID: LAZKBXYZQSKBdSeVVEhR0w==
X-CSE-MsgGUID: DyUfEcYSSCaPLqedoJTSHg==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="157685351"
Received: from mail-southcentralusazon11012056.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.56])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yFndDCM+ma15uLStqN8LIfLwac5z4zpAxeXnEasg7Uw2KaJ4u2vkT/eDiNgRlxDKAM5QIrpwf0n/VYZlGlZ3n69e1xBdA0CNPD38thYbkrlkCDMVghceSXCI9DbQP08kpNYS6+h/gpsPdXfvjJwaG8LTn5zVVkumjaIedmh/xV1hBu1NHqUhwf9jBKZFopl4clLwyKyIM77kJ0iItM4tWZO/n8cifn4E9DYU6L9qhYgsNwnOwtdLtLDgfViCYI4fxlH75VjIX7V/xEV92IFInJ8hsSGXVc3g0mPOY6Wl6YUmLSpU7cSFx6+WbRfzZQTwTsM7i/D1WI0E+qptZUtr8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJlaeU81ZZR1uE5/yQKoPWayJ1YpKGs+Oap6pT3uZx8=;
 b=K32OuG3Mvi4bWka1kMvj8Zuga6xsN4SVC+gOUXLGnlKj3Qb0jL2/QfBJVdXMyH97Uqit88UhN89E8G8dnnWx+4ihaRTMn6eqK/pTG0zdUj2kEKrRNJP2UWAX2a5Ujd6/CuhsFBXKirKxUBAbr1g7mmS7sWSC5YrcfmPArtQCQYht02rndLg9JHyN610PmwBwmD1m++86XlA4BBXVXZUeemUKQaMTipwJA9WNo5TitL/C3qO5gWGozj1oBbw8FnpyCCUVaf2SQxC0ybuYyfMJHQSqf8ujt9vXagBv2aS4RWgJuttzxqpfyrfZSoYJw8CMAdB93ILfxbECPTLHW4jXow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJlaeU81ZZR1uE5/yQKoPWayJ1YpKGs+Oap6pT3uZx8=;
 b=yLuoZBYNtxLLEAX/8EtouMhuSFbRitA5IQ1BFzW7TYF47yr33QsSZFEAORQ5efxzj50D3r+jjXyZJEtjdwvseZ1xBd0GnTIVrJuCQTanM78aJlJ4bWF6P6vIxonPys8OGoSx2TS/6nI8Eo6smzT2sQgcG3sodaQ/JNa42C4am4s=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH7PR04MB8609.namprd04.prod.outlook.com (2603:10b6:510:240::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:41:59 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:41:59 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 10/25] btrfs: zoned: use plain mutex lock in btrfs_zoned_release_dirty_metadata
Date: Wed, 21 Oct 2026 15:41:09 +0200
Message-ID: <20261021134124.2338902-11-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
References: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH7PR04MB8609:EE_
X-MS-Office365-Filtering-Correlation-Id: 46f60980-f67f-4ffe-5b67-08df2f79144b
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|10070799003|23010399003|376014|1800799024|18002099003|10067099003|22082099003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 NUCuj+oETMJdRgr05opW/UR+4434W2yNJ2JVQ8ylBnIgDX419kmWDWpSdYV2FToycOvfI1sQQ0RNs+gCxA9UeQ3xBwUnD4bstSMF+yz+xW/BkACOreGRAur6qHIh6qS7sLld3rl2/DDV6DgXDoISoPRJtdtild+Fy1oW4uirc7AryC7lwebESF/AYmXNjbkLFR4HbtLCbNAAqbYWThNWPSEtyy5i1a4vUjhTajV5coICVYwM5nbDvJlo4rU6EQuI6f0yeGxFEeXmlK6aTbIOsHHO0bjmQCJjRWhs4HsUiP0qd3wwqHoJ6uyspKvJJt9erKi7JW2+wm3pDLNWHFPjvA67F8By1NUycntQWuKWHNldHvNSqIlMFMqs2pUocn+QYw7azbvDKgWSY1ELcQYo45wUVcXwZIeIoVzNX3JPUJS67d6lbU0kroTDP7wR/IbWtywq5n+eLTy22HmoyV/7NR7ncxsdT//gRheTyoUeZb0FdkDf6Y/HK4cZNbWQZ6c41GcwTIkmMB460akFKf42SY+8SE37toSw9QXgZVX9CEuNsljiaWaLIc5EWkpUXEs8qhzJU/nUZtcOwZXex6jh6eIDmDHBfF4fv0B2sAcd3HSW13CdKeXbYhn9tOyzukF8oqRc7RLBvXdgmXfEMe8Yrh7MuT2+HAsbLfTkXVEyiik=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(10070799003)(23010399003)(376014)(1800799024)(18002099003)(10067099003)(22082099003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Dn2nnNmyp4odQ84y8ObECwe0DvcR80XV36ChnlJSO1dQRWql/aBs68AGoqg0?=
 =?us-ascii?Q?2eZiUkGnUXlIzSdRZKxpsgG7fl4xorVM0fTPJ61ol0Aeb+VCCGa+UBSbFNs/?=
 =?us-ascii?Q?5tgJqiH15yO7MaXnZxEwzkxklssp4hnVU3C1O1ua3zRPEIvHgwcgbMA0jaS/?=
 =?us-ascii?Q?EDHM2mPZ1T+/lhfAzc3T2hKG/lpvM66SiqAs5fRVHITybNMekdZqBXqVHPIE?=
 =?us-ascii?Q?JVcwgFhXXhDV/kY4LooYZCkTDf8QJt3H0z3GenoREWoQBvnfqoyW9HFLEUw6?=
 =?us-ascii?Q?zYrR3i+6eUuduX/RvVvbIZp4hzXMKxnK+PlBi7R2mJWYCB1+BIc6UhtsI2JK?=
 =?us-ascii?Q?RHFrSdmexpvJd2aBEhHpf9O7BQaYIXQ0XxpQTGvmhHw4CwtOBseb6BevsOhn?=
 =?us-ascii?Q?+PhU+FxQOkvdp1ckJex/VKP9NiVJhczTqaJRUYO/E7eaqtAjpi19XtDKLY6i?=
 =?us-ascii?Q?Mh29+Y29X3TIlaPsLVa+9NYkMRkpMfM/ipmX8+n4OSXW4VUKgU6GI/EyJU0y?=
 =?us-ascii?Q?woMyLEFy5WsZbSENEkfH4EwzqJKNuPDUIQZE8qO5c2lfNfcGsHlR5+dVKh/N?=
 =?us-ascii?Q?YeN1RrAarF5l7fX5bRWw966uQku/eAXmfJzGt1feS5kp076XIv//fAXkm+iw?=
 =?us-ascii?Q?9HF49phVo6qSNazbG9dHa2iMaRglTxrePZ9pm/pn/jGDl1xI7M5C39Q7SbbI?=
 =?us-ascii?Q?IcyOor6ALnwCdO31GtRDClXOr4xzUikibm63CIdRHTHvIA9Enk837xixOqh2?=
 =?us-ascii?Q?141hSVs6nNENxqdpyIjP4YbbQO/WjiSeeCZQHZ5d6U39zrVKVs0j7aICAYJj?=
 =?us-ascii?Q?2cNL92v30N3TsmkQiRNr5DTX7nD3k7J2Zw8udOl0f0vxDqk9i4znF1HlrxFv?=
 =?us-ascii?Q?uHub9IAKEzS8q+EzFx8fxMwFEVdIulmOKpYBcYibrltx0pyL9mm4/Udwu4Hl?=
 =?us-ascii?Q?CqWxfmZQtTU3shJMHQ4rcoQwAFZ11QtXY0lorlcBlNuKeENF4FW3x0kj1vJ/?=
 =?us-ascii?Q?fNxSvbRKP4RUAFKgvoPskkvi3rdSjbbB5WyCJHfNCyyRCP/AJwFut8R2FQzm?=
 =?us-ascii?Q?ZcoLa/EJdOjxBBMKEQyR4syAJ5qcq3f75ydHhfAVTcvX+85QWnuYyu6jTimz?=
 =?us-ascii?Q?k+k7gjMvkwCQ1rY7iUYCJMbZyH9SOAqcxHFK+2u/549INiG5A0Fs6ZVHALQs?=
 =?us-ascii?Q?WKfOA38RaZUNubLUIcqu3S3+uXEpUHL7z6eZuztl31gjCNhxQ/lXpX32fJll?=
 =?us-ascii?Q?VB+eRz4r5lYrcHRDosK39rIFWEer5a9UpAq5aS69k0puLdh+JTjYTUE2fdKm?=
 =?us-ascii?Q?Bx1q+miJZwK72hAatU69U4LceZkZo27fml6LwjyiGIx3EnRhquKXddNScthW?=
 =?us-ascii?Q?bOTmYTnrAaaw2MHTtV9Dzio9BJkPGauVOQdRpZu7Upp2c77lmIsGjH0Pntl0?=
 =?us-ascii?Q?D4/MghUWDMPVCenvHvATiEdy0IOQF/4B05uatIyhoNCvhNp/rM+fmUwdmAuk?=
 =?us-ascii?Q?k9Vtnw+cFqVYbZ4/GJaa/NdfJm5RhKEebucVs6Aggf2AOPfcFaS2YrV3P48E?=
 =?us-ascii?Q?49JbJXw7wCMPh/Uep2t+ZABkaxPPc3XkCqipFJIZYwfwsUcUSgjFoS8S4Igi?=
 =?us-ascii?Q?LeOdOZOmxKajRHTkLBZIWOS6ZftH9WIN8u+PwqV2GblSDIHq+K1HsGEy4Ftz?=
 =?us-ascii?Q?ktaVgR23snGTRkbA2d8T1zLHrZZOg+9i8CUe7pkGHEnf3R1AztXkb0//CJZU?=
 =?us-ascii?Q?AHUkoLfaF5+/igO25STrUcH42d2dUIL8IjVN3MYkpxz+vgt2JUgJ6la8Rlpf?=
X-MS-Exchange-AntiSpam-MessageData-1: Sr3//J4miSOhKbpkayQ/Go0OCny4GMWGNRk=
X-Exchange-RoutingPolicyChecked:
	Md16jdNmPNlKOFGWY7RshNw1hfK7g63ubgSiA3hEQZAdxYCs3CcqaIWGWa3R2zOny6PY3mtjzR3iCnrBCASct6ZqAvwU1CG29TMRzK/dBuhze2mvZMRJy+Ywf9QdJkE1PMyKg0IwLSjdIDQBn3CMkk8apdCqQ3Bk5bolh4T0vJYrhbBcjLQ6ttx6V9vCUQcLv0M1KZbbi+xRLHWovVdosGqF6AwFdcsXrRyfo0mKg2qrTi7/ydDRHKUUV5x5rxrmNHMQRf4HQPLi4YkjlVkTP7h4KTZGucui15phqROdQfCO4dV7DURXZ9Dr9EJpgjzMNvPQyJ7HpxHppb7C6lK/hg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bXgB64KNFe4JcVuiaqH0UDdSHKeyoFK61HCbGvXV+yJX9zOvhNvcnP6E2httwg3DeN5zaf/tM5nTW49TEtMjFwEkcKm7cR5dnUzd9py48MVkPQLmMkqZ5FHnyFh3W963/Mki0whvKMLLECviyYYW9RfiqENaLt0fl1yYeGiLtM35f2ZnYxIUz1MogieVdbcwgtB8mk851rUpP8CoC8FscGSxpW3jp8sU98zgqs8adhsw5B8KjIi+xVdK3Bpvmtz236gTFEG+Q356wRdjGvar6HNNgxR8e556/5S+ON2zdniIVUNziEwO9LR+W5LbMxIYoYg9JvQJXdtJ5FLuIaCZysT0Fw6+/7xxm7oFHMNykAljQi719PIZgQBM2r34FSH0l3PDMSwNXXfufW3/44zpSR+NqddRMUS65zdXqJ8cwnLXXAD3TJm09iFGCRfAPArAAwvQD++Nmmz/ShXgJEuhIeAguFQq3c2YE/KCAmJZpwliGU8JiAqxMneZhtYm/KTzme9yWDyFcWM9OE8FCi054GMbyDC3vN+c1G6jU96t5AMDlgos/N8ZowHfIGGuQulN1TvFjrj9vV6b6QHTwdGZmvJP0scPsHZ4PQWVvDOHnfjTauteJQjS5WjadWfV5zGK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46f60980-f67f-4ffe-5b67-08df2f79144b
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:41:59.0398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hLrigj9DYrgvnwXJ9SV/+WAY8pu1bSNEfJEUuSUr9JAeO5Fo0B7wa5FTuMFyh2RLZJvy8RG8MNnWaQP6jCC8UrOjDg6EJsh7GxAVERm+Vc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8609

btrfs_zoned_release_dirty_metadata() already bails out if it is not
called on a zoned filesystem, so there is no need in using the wrapper
for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9a85fd478d0c..492e1bc83d49 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4224,7 +4224,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 	if (!btrfs_is_zoned(fs_info))
 		return;
 
-	btrfs_zoned_meta_io_lock(fs_info);
+	mutex_lock(&fs_info->zoned_meta_io_lock);
 	eb_batch_init(&batch);
 	while (buffer_tree_get_ebs_tag(fs_info, &index, ULONG_MAX,
 				       PAGECACHE_TAG_DIRTY, &batch)) {
@@ -4240,7 +4240,7 @@ void btrfs_zoned_release_dirty_metadata(struct btrfs_fs_info *fs_info)
 		eb_batch_release(&batch);
 		cond_resched();
 	}
-	btrfs_zoned_meta_io_unlock(fs_info);
+	mutex_unlock(&fs_info->zoned_meta_io_lock);
 }
 
 void set_extent_buffer_dirty(struct extent_buffer *eb)
-- 
2.56.0

