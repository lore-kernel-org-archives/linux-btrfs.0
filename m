Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031025;
	b=cKE2J5q2KtsL2qCn1k/DYyo8oVS36M+133WsfLRY2OYODRz8udQINsJPT0l8jBgFI29I
	 42VGAKoIe7VLV2lX/CPYk0drHzXkxTS3WaDM3c4cbEZOvcsoFGVjsNzBd0TLkAADJYSTp
	 39O/xHiZJVXZzjWluKW/0oTC2k5Gyk6trJEaD6h/rxAbIqNpWiI0N1RcotDraGemPBScs
	 maJE7+pHDOBppY8wykOz10DzP9/UeF4ihcZUeuq+EHfsSonfZaZwhCvSg20vCy8f/o14H
	 0QEU+tUC9OJAIhtAGnmJx9NNYgLOYGM6M8EypMfUb4v9mRe+02nKkkun6oGQtCbJ1ww==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031025;
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
	bh=/vEqJFhE0uqarUDTVezwOTCIVkJBQ+nOQfYna29KcEU=;
	b=B+tlzMHgin94dcsjXu3tvQOdxGWlAbsBrTlP95ew9EO3zxIsmcn6o2faKnWJpDeD8oDo
	 jeZeeXICm1Vf1qytiXV/BZ5AKvMcxI51UCRAHyo09FhtHRS6P8Q5q7FzNyacE8GqX4aOU
	 RAMNpMC58IZPYV01mfY9P9F6VJ2vBJiTayMNzZxQ9VWscTkACNq4mOw6IysCWpXCkBCIg
	 FM14FK3CfEWk914xmDGBP9MjweluzASGUbzjV/ZTbJTkxiWLAxpqOlQvu9fha66exKktt
	 OEiITrD3GMFzc7llyOprprfof1Ei4dgtanAepcw7xap8+SmnqTkUHHfwU6T+BFUZegQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=AVFzlcpe;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=UifBLzKu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBE3606A330
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BBE3606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=AVFzlcpe;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=UifBLzKu
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031025; x=1824567025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=wbw7DS6pxoc3sA2jc2RCA/+zAMEhTIuxK5pcieUieaI=;
  b=AVFzlcpemNVxKenIwuRj2WornEFpg699Jx/0hEgN6ifj8nHlSor/lRyL
   13bgdWNdiR+4sfaEOQ33a3kkj4wR4OjaQPruLciUij9ldOef1ZpZZBzDB
   eKLe0WW5tbdrdK9bxk4I6TRhpuGcE6ApzJLeYv7TUicGMkU/GXiHPVrmD
   O2r4qITUzxiyab3k5sMInOVCQbVk2fVXFCg/R68jmUmVF4KFMtcvXHnKU
   WTnRUqhe/LaPgTg8t39CpPICavjrfAjoZOKbCmmBObfMzG6QsK0AvvHfw
   wyECv4AI4fx3OPTMXdU5kzGcAFgml6Vnwtx+RHn+wcSKxXo2fxZyR9K9k
   g==;
X-CSE-ConnectionGUID: 1I+p9bxuTcO6K1+zD8yuBw==
X-CSE-MsgGUID: c2sdvraYRT+bNC7hyw2Jcw==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158929289"
Received: from mail-westcentralusazon11010070.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.70])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TgcJuqpXg81PM7eOp3z4Mhi0Y7jB8uB3Rm5UILMfTVgPOiYCI2U6pqVuCUeeR/k9S3T9LjsHxffQqMYRR02Upv8LHG1n6HNlBVdHV2FJiXYpzRntTTTBhuya/Mc+Rhb+vkMwrptnj1uN/S3sxC6HUljw7LEQvVDuMVfi/jrRYi2GI6n2JmGkL5PqapU4fbk24BfUDOS9EwJsRpTSFzTGdeXYwU4kX9v8tZVknZwkIn7RKWk8Xv87cG8wbo7SgYReQ3KyfRzRjToP+1s4tEIL8C9u7Qzp9KDBj5BhXqDOfQnKhum5fWoJzD7OJGfsjzpcXcN03SXNU674Jy37r2pr9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vEqJFhE0uqarUDTVezwOTCIVkJBQ+nOQfYna29KcEU=;
 b=UBVD1JOrtXuBz6Xi3u67HhyYWP98RVsZEHoXrHokBqA1p5yiRelR6NruWPgrCS5oL1iMg4LyPkG16KKucmRsHPjtAiaE+SFqJhXKN+wEfykNMhidRzBUq7qVspctCCKVJIQNRa58kcOaFmhw5ujqAd1m+NiM/DdDwGcen75d5c9+K8SVZJW3RiVcfwbXCuT3v5I3dzN8Eac0g39IxDzl7MmLgq7e9ZC7SR0Amxzx3XVKDON4C0zF7SOb8slBHDvYunZ1KQItDRTHKH+WY653eagGlxWWgKt0sxNhr2aqgYD+ZgPTu1GT77Z5Sq9mD3OztFelEsIzKkcif3UlwMD/YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vEqJFhE0uqarUDTVezwOTCIVkJBQ+nOQfYna29KcEU=;
 b=UifBLzKuX4zxPTReUbzNVEyawU5zBP8whtpzB1XzoiYjFhPmH1sv0ADLG9GV8+kcjVXQbgXg/TuM1buaF2Hn+WHTL4bbXIwbgiP5gJGRu9S0SdWY0Klcl7LEEPDqvS9OiWamZqV5pFsMAt7Yb3WxagKk1sifKl+mHKb20uKuLsk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:10:02 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:10:02 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 24/25] btrfs: zoned: don't count the relocation zone reserve as available in statfs
Date: Mon, 26 Oct 2026 17:09:12 +0100
Message-ID: <20261026160913.207909-25-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
References: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV3PR04MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c87b6a2-bd15-4028-193c-08df337b9711
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261026121527099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	unvzTx4P67EanE7H9Atf2u97lOJ2/5dJZKt6UShHK2yyPjIIY8K3rNz+iejsbmp6SypGNOEme/w1pa2Ki3SYPfU2lfNppNtE3qliZZFLwLW2dRmWzrUtvLONVXpSeWST/woQDtOn1CQJZLdQJciR5u7XqA2VbWSP4mff4NeYYEsO0BsA70dFgMe/ZMcaO9loS0TNiX2d29n36Zc3YvJ3w9MraEGeAmWwI/9o/2Faa1aHZ28dNP9O5HfimcD4w42SwPNuyZsl4sBpIouW+DX0V4TV5g1Sr2cR9KQrDEorZoZBazA7V6Q8eWbCESOxhub7lc8THowfCYQtvMMUQk/QSebltns7V80eXob0Eo6SCIgzcOB9F4BNShXVOQVRWSl2eOSovfgkTXtrGWCUiKSvVmv4tawKBAuBcWlF5MdyR0/uVYZ+8fGyOeDcp8TxUpsynPOF/zJIT4G7yfZ9/IGXcffgNbc+0RKk7CyB+RZp3I5aPTrZBe9B9s0/J1poAuyfDoR0LRX2rCEbYmzwuRUFt+bWzwDsqDpbilJeECEw720o/1uahZKow94+Wv0Tq8d5bjDuS555Z44uLaRg6dioYYaOvvg/ncd3nO1nyWfTfG1sQX0W+GLY5IGjV6gOQgLWLF1A7DGRZM8uj9nvIwU7xhe6xZ0a06isEE1tj4gSM68=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SNHW9QAQXQ7QETzoQky47WqVfw8QV51MyPo1I2F5v1yBvDkph6Ra/MAV/8Jk?=
 =?us-ascii?Q?cPa8LFZtAawU3wqdLJ1O3krKUdG1cvQeqXlKmqwSFfOI4CqOrBTKeyYD7J1x?=
 =?us-ascii?Q?fmzjzBdWued6pWGUgKNjEzUHJp/xELgPo3ld234z7UVTSuSNS6LuhPf/aGZq?=
 =?us-ascii?Q?3iOV8rswYkmKVe5r9aLnzDSDylerwX6vmRqnz7qm6pLEZ6mTbAWublbVVKjm?=
 =?us-ascii?Q?nCw0zk/iyAsmPo7AnrWPoeQLBCUDNFXNK6qWeyfgWowYcIFTTvFN7jM1Xx18?=
 =?us-ascii?Q?f6mzb2hADFqeqNZuZTW71FvPuM25q25qUeXHSCQlY4e7wVJNT87cHCfmIhWI?=
 =?us-ascii?Q?uAz+9aX9t2s5cWAT97QqILydsAD/oT+0102FVoRPz0bGKW3YHriQiKYWNeW+?=
 =?us-ascii?Q?SXMTl+NZ73lb5tJz7xfTfi0pB4hWvBB5mf/ID3yO7E4AT+/FiT6i/zpkSsCB?=
 =?us-ascii?Q?NmouzfmXZdU5NeOpCeMsIoGXh8Uvctc43Hn4x/+L2he1WNbqL3z2nrFxaBp0?=
 =?us-ascii?Q?BOsjlpagupF7POGxvJwdJFyH3iwMsFTXQrz0YXaYWO6RtQsTd8rCsJxUwfUe?=
 =?us-ascii?Q?iKzlVQCDj7yIlC21Y4oC1gA2sNksb5d1HshArWQiJ248RbztKZOBLWLtIJ6A?=
 =?us-ascii?Q?XFzOCXrnZ/EhRLSEZ2qPun/faHup99X/KzcLi+Erm385SKDBf/Xdazv/Ucpp?=
 =?us-ascii?Q?6rVX4p2a7wtPDbG3VXMIBT2G/XTj4fnYzaX3pXt7nJ+n4FVfvA3aOTjD6vtL?=
 =?us-ascii?Q?UPU0nWmtbJ/ik/0dat5FIHBsbuWTS3RrnBOk5rMtqHQweCWHa/7YKYfzcaFW?=
 =?us-ascii?Q?alu2p7S7SnLdCt141Wt0MkV1uAxSkc83Z4Um6vCt4brLTrqZUGC5CDtNugLF?=
 =?us-ascii?Q?ejTZVy+TSJdBekAgwN/QYp1LZoJ7HokvJ172mlWizUY9KMg8M/ARZbV0eTAR?=
 =?us-ascii?Q?G2Xtr+mZc/2OmmT6LZoaVO1s3vc43SkQ7jQzXINLKtZoc2uCxqHvuxZ+aXOL?=
 =?us-ascii?Q?SXWDmjjYYQcWbokRTMZxk7mWSlOgBvw5zFVQTuBeZOeIpdWKWaql3X0cYZL9?=
 =?us-ascii?Q?mBVfq0qqz/criTiApKule59vAFuBACOILu6KRjPod0xpYFWM9vB4KijnzpOA?=
 =?us-ascii?Q?n7qlIiV9fPmETBG/C9SZZxVeG8ADsVvUPjssYcMhYlOEiQsoYpV2pURmKz5Q?=
 =?us-ascii?Q?atoJnrnjYWMKYCllLHsNNuPUkTeak19nCKn/isTrMA54DzMNlkFpmlTj5jTf?=
 =?us-ascii?Q?B6Essv9yVCxTCwslr3LLDek8rSlVXYQeFzpVFcWJhCgLEL6oLx8/JFlzKTPq?=
 =?us-ascii?Q?fa0h3ZCW8LvwUd2J733NAWPvtSMhtsaIudqmzECRejAdjVEeA0OFaXzpFIcA?=
 =?us-ascii?Q?2h3yp5TlABIg45FWr6GkZLcOfUSOgaQiHG/7nk4jY2f+whyVXfabBZEsH1Au?=
 =?us-ascii?Q?m4E/lHThutvWbtCuTFJ7R5eyUfq+qCd3xyD5eKl2oV2NCAm0jmIYaRaTZEBi?=
 =?us-ascii?Q?DHlv14swdRhGPBBtryrp0nKSDpBzJLg4pgPEewQFr5XSB/f+8m5Czs0iEFyz?=
 =?us-ascii?Q?8QRCxR9aVx4Ms1S1IPsdUmvPGwvZkYqr4WrgGJzOPG+WQ504aWEuWfAGPxhd?=
 =?us-ascii?Q?/ebcUO7zrcMAyZg5XcrnA7DLzBMKDGpfN/irkxhtJUxObxLS+qk1cw9Vxb5K?=
 =?us-ascii?Q?Vh0pZ1JoiO3qSN6wpkMW86Mk5NPv51JFNU/FiVJbECHACycSJqXuJmjxK60B?=
 =?us-ascii?Q?bEh7OqCL6d5K1Wu/0E4rdJNDxTCESler2nvhEXbQUAdZ12gA+l64L3EX6tx+?=
X-MS-Exchange-AntiSpam-MessageData-1: hEpiw/jysIayhQ==
X-Exchange-RoutingPolicyChecked:
	jg4iUNCo2xhtjqMwmaRBgQnLHKo0AQeQZxLt2QBoE8MRZdVfYOQW7eYBN7Elmg8TFEdyzaRhNim2Hoc04OR/PtD9gQGm7PkvjxdHU+ZcTTYE45kOiQgcJwOllj2fTipmD0ZRCJZkwFWJwTFUYe2dj+2P8IKXxQpYwIMmMyVHsRECPt2U4efNcdlh82enpcD5cG92PE4m4QUqA1C02zDl8FNWhBfu6QDdhh/LVhIKcfUhcmEwqwvZvwo7G4O2GGxC95lOfyInivBIBLwW3yCRru63dl9wOO58UDJ0ZROptDtmOEBQyyApFd1sKWoN/IM5Ptm24c7VyiXj2KyAsvxrBA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zGuSaP8t5emkE1n7t119OmI12gVGbMQG1bHb0Fae6V0NM+EpJm+vCGLwOSiYh22iTQpmEy73/qPa0M6SmGLlXzmjPoAMOvzwFl9H+CdeQIIZ8+pju9Ua2ZiIt37OlrwqM+kG6v43NAG57rod6bDjZYXxWcGijmGJbZYKu9Tb+GnV0+wzBMFsEmAhUoyrkeYL+bEk08CyAyNlxz+5DnNog7728JnOyhYnsFe2wtDor+hWgzTOBshPqVecg58UZVZjwyNMW2pl5Ojw06ErI+Mryyte5FWowzmFDQvFMjALdx/B8o4gcirYlkmXu9xy0xQdlvHEqs8tH/WOKMdz7SbDMydidIgV7DmpBSdC+ffzGTchJ8dXkbCAk5Hu8EqIpHZgehED+ItXQlbdblSpw8y/0Rck4eyPx8fdRV7mzM0X36kQnwJTEly9O96k8Ndu+TnzXTBFUai2TY4kFHcnJjMeQiV5vIodsnJtY6j/wIChO2GNPr9eKHpv2tYDzUE6Ah+EvtdjD30CoAxFZ2GmaBWAujR8ZaUwqVHKGauyL9iKndwkTvsltthq/STOw0/wmoiZU9cEQMCq0sww+LANjjb3JTqB4Bb2BGe2T2aTYBkhT9q1hWeueo1DNoy5tJXupHaS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c87b6a2-bd15-4028-193c-08df337b9711
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:10:02.1011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQnYLnh9OqVokqtUBrhaanlArpThZ8x9TaoLajZeGNXFHwyseA+IixCzrimhgvQcbW3kzWdwDOtjw9w3Z9lY77Gp7jBEhpqY61djAPMknl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

Don't account the space reserved as a relocation target as user
available space in btrfs_statfs().

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0c8b8e392c84..16d4bd5c2d9d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1731,6 +1731,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u32 bits = fs_info->sectorsize_bits;
 	__be32 *fsid;
 	unsigned factor = 1;
+	u64 data_alloc_profile = btrfs_data_alloc_profile(fs_info);
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 	u64 thresh = 0;
@@ -1790,6 +1791,11 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
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
2.56.0

