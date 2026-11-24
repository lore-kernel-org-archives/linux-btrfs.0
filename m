Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795502745;
	b=kjCBeikoy9HEdkTVFUN/PY7d5L0y//eDNdu67N5ni24nZF162wPl8NVv+lKIFTLih79c
	 XpDDWe8bbRQ4mno4kedtkwF4ba/FV0n9Q1XCAtqkU1grtL+YPYANBfQwX8wsCBXaLAfZP
	 RhUJGcZquMp54SVGDKsbIiXaez/GFo3nsRLkL+YCZivB612Bo1a7WyDlrdbgaWeeM57TU
	 PRCBYUCIVr+NdwVV94w9DYeHnujmCqvhX2DcecgTLC4zQ2wU/RGu/dVykZjRth9l0QDx8
	 6BHln79BuZ8A69oEyDlw3Duml/98dhZUBFns3DYIGLrZyGpqVLMb7fjRONAe9ka5UPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795502745;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=5y2PNvt6mI3pJuHMPYtA2afJg+868ZswMcSjKR+r+Wk=;
	b=jCYs9YD+8iVF3TPH0pUS6RvYVbH4AZKcwis+NYc57e7R6Hem8sNJ+/FEg1d+5SgOmWIe
	 Xgz5/q5u+QP/PPz0O9H0qFSZbnHct3jPxxB1eYNmywALT1eIgdvg9OnfLkpZbsJOz9cif
	 ey57k5Ir/g2Memezf8jyZqjQM4d+4/+SZFAQvsyRrhi9My9/Kae4FwUTzunkKQwJmpqJB
	 Sx1gIQtBYzT426Ep+isXAFNnOkRqGssdP433jvGblYbiVEmg0Ax874sO3jsKoZUdcquYW
	 EJ/sCv+M+Tkw7r5PsD4Tqc3nHkiTkdnXquiGvH+08jKET2g4bVnSc5Ns/S508N3eXmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="TIvthdP/";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=B0owvuc+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64964606A31E;
	Tue, 24 Nov 2026 06:45:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64964606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=TIvthdP/;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=B0owvuc+
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795502745; x=1827038745;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ewz/rTE0aWok6fA+/6oNvnCeYsBzA68aa8dwXkNQKNA=;
  b=TIvthdP/usWZxROk7X7sNwHYG8FoNS/vcX7cuU4YS98WVYjlyKGWXIdP
   tX9mk8XbnZgibEl2HfocpBZPJADk2yzprxu0CIp6y7LRthDXnBOpQK7if
   tf5eH42n57zUQ/fVxxz1ijqrFgk+voCfYZzmfwAgrOLiic2RckNzQ4jp1
   sUAT3wJAyQQrbFIsKDs7dwAvlI0Z0tFxp9+R99S6VRlsjXfE1bpciJe+X
   aAilNqzfbMMUs2T+F6p4vHzQbv6LX5vuARPIPItII5iTbjaAL/utvXHD9
   YhH8vU0JEjtNNOkNr2G2OlYV1nV8x1SI4NAYHcGRHnkLRo8i3XeSuqCAu
   A==;
X-CSE-ConnectionGUID: ryvJkkndRy6x4nEmBnW7lg==
X-CSE-MsgGUID: 1bisQq4gQcWcKk4oeVIUwA==
X-IronPort-AV: E=Sophos;i="6.27,230,1786982400"; 
   d="scan'208";a="160008528"
Received: from mail-northcentralusazon11013039.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.39])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Nov 2026 14:45:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WbUfTCv3rr+CQnE/nrf/gNl8AftxyjkgvsS6356CExn+hhcW2GVmo3NbGzmhstGuRSgmR34xSWrQqgSdWU5CvGFxO97urgE58Ex3dfq3TmzyEVDRmt1RJbnCDxm2jUM05KCI90bTzdn6CORZ3FFaCM/uKQY9LICxWFFALJ5KGkNuHkdqdcJnCmW096QEQYFNRYZTRXsBxBCebEqEFRmubfLTomtM/ChAepe2jbOHK9xGNIvccLOW/p53h6Zm2ut0/cGlvfoPW02piZUBoBoiOfRjBGRvgqJDU5CI6gf4lx+LUyOb8haZffJbEOPz4N4lKjMiW3e4s1kd1a882JWfsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5y2PNvt6mI3pJuHMPYtA2afJg+868ZswMcSjKR+r+Wk=;
 b=Uc5yixwikDyaSBP/bb+f56eVLwdMClrvYeeMoaefoKkaXCWDTHiXnAaS/5WoGbPNWYILZX1YbLqsW6XAHw0MsDTqJZiAX+9Lxf52vYE6Q3YZ2/3505x8uBVYWBPSbsWLnAEqJa+ShrcG3T9D8CReqtbQlolmopMTjNHuzUU675uTt0nlYEJIzgcigHOZDAdBvum6c+Ryr5+/1PY1ID/8BYeG2m1SDQMp0YdpB5UVuy+uRkAk/nEMIT8959jlHx2WmYw3cdmjTIsphXfhCbjuyj/Hyh23q0Pnv2jAi7L0OnQB+lpgbxYUGT5pvVBAed7FB1P+QYhI2Iei/d/1XTJVcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5y2PNvt6mI3pJuHMPYtA2afJg+868ZswMcSjKR+r+Wk=;
 b=B0owvuc+cpcKfSzY31qPStEOCMnx+zXIK9R/tu/f0fMePHn+FULIFMOCh+JR8jmFVifyosJwSSLlUPSipF9UmJlDCkquEKhNpWJt2J+dt7psKYIIvxeuvKjiraeFZsbYrWu/PUehDpwH+wulXAQlglh3UMZKdOW2Vjo5jZstrgo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA6PR04MB9297.namprd04.prod.outlook.com (2603:10b6:806:41a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 06:45:42 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 06:45:42 +0000
Message-ID: <8c893023-3647-40f9-90dc-63ce977fe710@wdc.com>
Date: Tue, 24 Nov 2026 07:45:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: wait for block group relocation on remount
 read-only
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, linux-kernel@vger.kernel.org
References: <20261118125816.6878-1-mc@raidlab.org>
 <20261118202548.82001-1-mc@raidlab.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261118202548.82001-1-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cd::8) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA6PR04MB9297:EE_
X-MS-Office365-Filtering-Correlation-Id: ba4be8c0-32b5-4044-7923-08df49f68f2b
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|10070799003|366016|1800799024|376014|18002099003|22082099003|4143699003|11063799006|56012099006|261022105027099003|261026121527099003|261026140227099003|261009223027099003|10067099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	SJMR6VHChrjui3RpH1ll8THBT/Sc+eoxkoZwFMUSZu4feroiy31kCg8xBuFSH2+FT7/oG+nK81X0CXtjV4J5ipz0vU9rU9lWg8cqixY9kEXS4p+CTinxgfYjtfanDfiSSanZzgH+Uyz4DRtaAmQezxOAv/jcQwZtZCngdd11wmBXuAs8cel2yDeL0AJa2k+sV53/1i4pBBtY/Rh2oX7ymwW2kyVRJ3NxjEx+/+xeipX0MM/Ne3obA61J+e7U3ud07VMY7FtCGtIHj1VyD/HvfxJziu/FILIHWFndOsJQ1TPqNOxtlMcZzFSVn3i3WoER+0UdcW+9BDFxNGY52/00Puj7BTc1si2gyXtoOJWIbFkKCUNK1ia91KxGTNF0/rl3F3YXE7yei/GUUuJPoEhe0ed+ete+UkjMHro3PuAza8GBFiDHqUVRJ7ucPxJf/MwY/QK+H6rWCEee8IvM1CPa0FyN+K5zrLGPCUkn1BHYqgtgDRwtYm4ilXuFJWe6oBjwmynF6dWo24pGqkcZMTLyfw19KgN7AtL7XDDh+KFLKb035Ay5wYhfszQ2Kt7XI6g9WYavPQCM9mQwXLYgYK4m//VGuVlUaHXfnGCARGrSGMw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(366016)(1800799024)(376014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(261022105027099003)(261026121527099003)(261026140227099003)(261009223027099003)(10067099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUFpOVNRYmthdzVoZW1hRWoxa2dkemt3NzFKeThNbDZROUNUSmI4bHZNckw4?=
 =?utf-8?B?OGdDVVZSSEhKc2hGNGxpMXJhdDA2UHVKYk5yaWNFblZIT3Jnam5naHBaMGor?=
 =?utf-8?B?RkswMCsvWWFSVVdoUG52OWV5VWNrelRxOWFrdi8rQWcvKzFRMnJkOEpoWDZ2?=
 =?utf-8?B?Y2hwVDRTbUowcmpiVmd5UkhWa0hrZzJhQlhPWjFsR2NQTWY0MzJNMWc5WFlV?=
 =?utf-8?B?d1l1WmcyOHB6eGYwN20xaXJwNndMa0FtVTdsWEJpRFBhQjFhQTF3ZEovV0xl?=
 =?utf-8?B?WlVCdnhPcHFTZ2lqK3JSeldLNThqQ0JPY1dpZDRUYld2eGlTY1VOaExJQ3Nh?=
 =?utf-8?B?aVdKcmgwWnJYOHJUdFpqcTFZN29xaDJDSFJOS2pJOVR0MU02TnBtM2s2ME14?=
 =?utf-8?B?cUpMaGRQcHFwMlBDU0I5SHRRWFRRa0pxcUg1U3F1QWxwTWFpU1M5N2QyZVZV?=
 =?utf-8?B?RXFYT2x5M0JqV0taci9nL2tHYTNpZEtoL1BjaHBzZ0xyQ3JzWFlvQmIvMi9i?=
 =?utf-8?B?R2VCOGM5aVdoTERPN0Z0dlRvRlhuSmpmYVNQU29neTUrUDdYR3RBN1QzQTUx?=
 =?utf-8?B?c3dub21sZm81eE43WHJoVzZRQU5idzh4VUt5ZXBEd210RjlYK21ZK1ArN1BE?=
 =?utf-8?B?RUV3bGZJYmxOb1JhQzFxblo4d3BUT21Oa2hOd2Y4RnpXNmp2V3lSdTJGTTVZ?=
 =?utf-8?B?ZkdGSUhpcy8zOEE1VTVoVHl5NUtzN2VOYmpLMFlYZXNLTlZ3QzE1YmNIWXlX?=
 =?utf-8?B?RG5BT00rMHRpT0dTNzRkRTUxTzk5K0tYYUZGWUR5aGwzVEg5amp2aytseWFJ?=
 =?utf-8?B?NkFNY1RhK2JyMzFOTnpYTGhOTlM3aEtzbXdrenVzeXEreldJb29DU0tPNDNR?=
 =?utf-8?B?cGZ0SStJUGR6Y1NaZUxzY2xzR3dseXZnUTVKVUVEQTA4dmxuUTlqQ2QwZjI3?=
 =?utf-8?B?NGNvdVNpMEc5anJnM1B4SEo0TE9zNDlNaXhPdmRxRGdENUc5c0JVR3pjanNR?=
 =?utf-8?B?UnpzTGxxazQxK0JNTlBXVFpRNk9TWnNyUmxvN3lFZExod096YVJpN2Jtck02?=
 =?utf-8?B?TVBhMVZqVjFRbFpTUC9rd0dIQ0tiNGNFUFB5QzhlWmREMjhYZDdvcFkwWGk2?=
 =?utf-8?B?VUhIdFh4RVBuWjUrRU9OcXQrblRZdmU0UzF1UlJDS1pwUjFMMzVNMjFYTlNr?=
 =?utf-8?B?OUxJNEY3bDV4a0FSWmRsQnlsb2s0ZzlveFZUOVgrVVpoazlmTzFucXNhYjQ1?=
 =?utf-8?B?M0N4UDVUOTZ3Q2dyblcxSXBmbFp0Mks3V2FVZnVFNUJkZTVYQldvSjhQVFgy?=
 =?utf-8?B?clhJQXVWMEY5Q0JteWZBVE5oYkZOL20wbkhRTjQ2N0RxeEFQaXR5d0JOZnZL?=
 =?utf-8?B?QlE1c2oyRWpUcVNNT05rNWZYbW14K3dZbzdOTzdQbzhOczlBZVhKRCtNWTJK?=
 =?utf-8?B?YTZaRlg1enlNUHpDM25TM3d5ZnBaNEhBTEx1M0pDUHp3VENVVjNVakNsZzRl?=
 =?utf-8?B?UEh6REZFOXpjQllzSUk1VTB3M09VQmRFS0xOSkhIQ1dWaHl3NWdid09tVWpi?=
 =?utf-8?B?c0hPMmEzb1ZSOUE0SGVqdXJWSHZPalBJc0xtRWgvVjQzckUyNzJlbER2RTFI?=
 =?utf-8?B?ZmdTLzk1MW5ldTdxZ1FoemxwQ3lHWWlnSzZBc3g0R3FmMHNTSFBHYk93QmJS?=
 =?utf-8?B?ckE3UnlNYzZ0RkpoWk9ib0wxOXp3aE9pV29tZWhDdUFXTGRzUTd0alBWZi9u?=
 =?utf-8?B?cmlVNldqM0tXdEJoNEdBOUk0TXl6TG9HL2dNdEFzNGM2ZlBxSHRZVU50ZCt4?=
 =?utf-8?B?TllKTG1FSnZFVU5SaytiSW9RV0dyTW52TXkxN1UzUUwzMU1tWE1pVVRYcHI2?=
 =?utf-8?B?blJGWm95ZHFxTFFSZlY2Z2s1QlB6RktiTTFKaFlFR3Z0Y3hiT1J0NkkxaVAv?=
 =?utf-8?B?OHZINXVjU1JwVzlmbHN5bnI0NVlxd2czTVY5bGRNVWdpOEtOOTFSakpwbHdo?=
 =?utf-8?B?QUR3czlTSENKVGNHMExScDdjbUx4MFBaZXFpNmNKVkVMUVlSZnlrMmQrK0VP?=
 =?utf-8?B?VkFQdERRNzY0UGRTQnBjTXlrSUxMalBSZC9JT2R2VEtZSlIrWUZSMldleHY4?=
 =?utf-8?B?YmpGbEt1QldtcldjWGtuVFc1WkwvWWpucFRoWXFMeWY5aVdNWXJ6TUZaUU41?=
 =?utf-8?B?Z0YzR1VlMjI5bENqOEpqeFIrUkJiZ3E4RFBLWEpCck1xV0x0VHk2WUhXamh5?=
 =?utf-8?B?U0oxbUlVL3Fwdm03UUl2MEJhUjNRNDNBcExiZ2x4TGM4YlR2N1lyeXNDVmdZ?=
 =?utf-8?B?S2dBZTB4a3hjSno1STdGRGZ3aEN3S1Q4U0l0T2Z0OW1aZ3FLRDhpTXhtWDZu?=
 =?utf-8?Q?UICqrEIDqXoXgQSjdsU8TjzCvL9xEj8adxvBqdcNSWWif?=
X-MS-Exchange-AntiSpam-MessageData-1: /3ANDiu8QC1uRi3aBIa/eNoyCORaFmgzmOk=
X-Exchange-RoutingPolicyChecked:
	d+NBht1KsDnB7nwxJiOi/MPuGxh+HMMCCxudJFe501eGvX5KlRgVafnyCmnOS8lXAUhGR7ksX8jmS5zU45HcZQNeNoWxfkAMt/Nz7O86NAuEO+VGqMm1U2q9YO7FqsZGRJIrf4YghLWza0PeHJUyC9ZT3/sEm0hLyUzuq3Qv+x2dpaK2cQh+xlFDVlSET3jg60eTNT0MF4y0cppQ8H4t4GrdSvT25XzF5bFQx1imewcPaFDcG+NZUEk14tBqMzINk2VkdN2yMG5yHvCy+ouDMzH1TUjSEC85Q3mUUMjT7rd/MEAIxTYyw7AEo04qZ8D5qnYnQ5Y3LoeC9L6cufu2CQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LXGQCK6a4rMHJ9vmKLqQmHKm7acf70NZYx+DavKsyUIchcM++gnbxqrGr1fYKjJ296/OhSeCETl30EQA8kN2C7KHrrPrHadBto1dW5CJnQ5A7BMX9HQichZD2ZDe/Dmu0m0moG68hgzFwOeMDpDqKmQ8dDYd/k608qntHaZ9z4a1moaC4Y15vMzefr0BFKZ07vAWEpzXM9ZSi/YbXjaeu6fOLTHoPwO0eNRvR6XdZGSZVmkyZtecAJHa27Q687zUbeES/qHRwaZR0BBV0eVtmsSNPkkrCOsHVL+4FUCuXmMdLJ0Z3mCSMHllmpSR5q3GbUpO8T9hO2FCiAeFkQ91p/dNDOFAsEU7bVY3EWmFi+G+pft1EVo2beZV6QP/uLuGgVO1an7pFYD7C2qLgQiI7VXxDmW6sOG/e1RPVfUxLcdPSP6bgoxXQ9kvx5Pok+rstP29baOfajwsy6cLTj7yH8tOdsCynbTRej98wZ45hmKEb4JkhDEFuncAAkMxWkMdYeh1vi9/fUlztQDp/FlfVQ/bR1OUTXi3+gPlCUhbkIdYv4bPMEoCC05gzZCrcQzl8Fqup+AcSupJydcisSG+SQw/YESaie9PhIV4DELsefnNKies8vRBQI8oAoiXqDYX
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4be8c0-32b5-4044-7923-08df49f68f2b
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 06:45:42.4756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9d1M9bF1dylxJ0Sn2e4Kv9Xo0aN5f7GGWS9VMWZOEKYlgx4h9wh51FnXBs7lNahdAtpmg6anwvkEIAkp2iR4AU10klP7q2f5VACNxJdzZsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9297

On 11/18/26 9:25 PM, Miroslav Cimerman wrote:
>   reclaim work                       remount read-only
>   btrfs_reclaim_block_groups()
>   |-btrfs_relocate_chunk()           btrfs_remount_ro()
>   | Still relocating                 |-btrfs_set_sb_rdonly()
>   |                                  \-btrfs_commit_super()
>   |                                    Returns, read-only
>   \-Keeps writing, leaves its last
>     transaction open
>                                      unmount
>                                      close_ctree()
>                                        No commit on a read-only fs
>
>    BTRFS warning (device nb2 state I): transaction 65 (with 98304 dirty metadata bytes) is not committed
>    assertion failed: !found, in fs/btrfs/disk-io.c:4378
>    kernel BUG at fs/btrfs/disk-io.c:4378!

The bug looks real to me, but Sashiko has another complaint, that looks 
vaild:

https://sashiko.dev/#/patchset/20261118202548.82001-1-mc%40raidlab.org

