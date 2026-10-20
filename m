Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792490763;
	b=d16vhpFoDvbloa5S68AYn7C8Fg/dQrxMvhwkHEUIhS9kydyBMsJwsYXFGqqe+P9X86Ht
	 dO2mTP4lvQjQLkF8AD+I6BNDrllQKA1Fuzwjk4ccVnoyIM5hsX3wqlZqfSM/N0uStP3vJ
	 5LECsiNOWBG0pHHgEQEX+MCCJ8QIyrzFKaLoZhrutReRCzfvVZVtEzjucbwuxztUZCcy8
	 fctX5LuA60rOzQ/bLmPt5rjjYjvJu9sgSLsvWVXZc5YJMBh71vAXmL5tsO7iOq7vWc88J
	 GRGxPlkMmKFvR6JzALqKmj8SilQAmSIpFSfelWSx61z8QIkHWzQhXZURLqK7wRU/Trw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792490763;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=/LW2NN5NWox3Mhtlva55fMoLTAqIpsmR+uVD82GWMOo=;
	b=XFsqC4yLBa+YLpi20NiEm3TdGJPBp+MDb3uMqqrpHuiilK8l8/QC26q+jfsDp7YraT8x
	 8vwRGqAonuf7A01umbmt497HXLVsZitapfmfXq2eYQKxJGP36jDISKk/8YvpqozXYcGZW
	 JOZUhtAqwVmbV51otbxI2EBEnPhyfALGkZYzNIpal2ZVCIuhF5VZmeVxdoD0TNtcS3OWm
	 fdcmX7r47o/c3JIQDQC6j4Sx/DlrkWynectBPZgdkovM5TbxMpjD6OcCwLv633lI8hF2U
	 5NJnVwlDXck8+p3g+4EGZAzrPPWJ6mFYrsPAKSOuIaSSogDmooI9IZM5Sm7aLP2bvXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=hChZEzux;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=z2QxbliW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B35C606A319
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 10:06:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B35C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=hChZEzux;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=z2QxbliW
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792490763; x=1824026763;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=/LW2NN5NWox3Mhtlva55fMoLTAqIpsmR+uVD82GWMOo=;
  b=hChZEzuxvsImHI5/HBc3fvytA2nWhNr59K/rNEqtpwE5ZDpJKNMqp/EL
   d7vMKBtmlERqs+z7kAKA8qLjS4jcyCrNusgDf0OOaRwwotAuCXweK3Ix1
   3aoG5/x0RrgpzDYHjdHPJbsQJFKnIwRFMn0/5wD+KCuOtbcuTL/7O6key
   vRCSwzOjBxRdPdbcXZfmKzEWRI6Py8/x6Ah4p3GoB2cSeL3uFR02sej/o
   gC+xLPMGzi8bF5U1hIg6DnphpXOGLu+zAy0CcYNrCN9Vd4DDGxLyP3ZS0
   UGZu55Lgm9xVjFZrVHcKX9FqtRrSRiiwydDcQzcvCoAWPm5bLzKglbPvJ
   w==;
X-CSE-ConnectionGUID: e+OOIIMwTWOIZDC5ohLDJg==
X-CSE-MsgGUID: qUR1/gvQRoKPFT5fe2fo2A==
X-IronPort-AV: E=Sophos;i="6.27,168,1786982400"; 
   d="scan'208";a="158429966"
Received: from mail-westus3azon11011053.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2026 18:05:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fs9tvbvNUCd9uNMUCRm08eMiJ9qvDd3fqrbitDJyMuHc03ZE6/tBlBDhROGqTfIAEdt22OK3+Lm60fc895uPnerHw0FpFJbwAWzgX4X3qN+reeHVxAlfXB/AdGwWbTZXG45CQYB46v9dP9Qx9TEym+7ZUb/UjY90IveKbwo5CArE1aDqKK27LmHodWFYKqlPJXuGwNp1J37jdpHmPic+RfrYFbklh3iheq/BX/QX861ueyaMrg0E2JChJYiXaeZe21AIF0QXAXU8hTEZlpCQApLNosQSW7JSMgz9X+n43ni3dH41q4Rah8rkg1lwDPx2M5mDFu/NhQHl+9tkacGIXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/LW2NN5NWox3Mhtlva55fMoLTAqIpsmR+uVD82GWMOo=;
 b=nI2LNDYw+VkHImYXbGdKT4fVN5m3k2tV3/inQTygz3sp7sgg4P1mhP7ricJopzcLslfuDQdar7ZZ8hSt9zymtcq9Ho5WUiAGyMQWqXFBCeRDaYKkmeQiR9uO3jkiDOXiYWvtdHi+ozCF9WIVyAA9pNWnS9c/01224Z6uUBbB7U82ooI/ZlC2M3zxSeXcwaXuzMs2+vYElO6pqn1gGeWIfqMiIT3vdF+ri+aQ/sSv8rxQhYBJX7wDUAR8L5O9q13bamByJ5CixnSSUrMsz4387VPFKtQEeungT5Ja2i/UP/00dQH4Nc2ePOE0vgBOeSsbZVepl450mdTKCK/fm4mP3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/LW2NN5NWox3Mhtlva55fMoLTAqIpsmR+uVD82GWMOo=;
 b=z2QxbliWxS+Oz3dxpr7yfbVy7EHr4OOjX0/eg4POTY+KP5LX+lzXgvAUkwmVVl505t4BwgQ4RS33BEObl7Eump3R2pWT9wy7rpfCHCvL4fonSkwn1mUehAsvTVZSvJdzFKjs99H3abforDYcTra9IAJF7e9oAPz/LwQ+DtkY5+E=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LY0PR04MB306006.namprd04.prod.outlook.com (2603:10b6:404:227::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 10:05:54 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 10:05:53 +0000
Message-ID: <4afdb749-95bc-4e87-84eb-2d9cd380bdd2@wdc.com>
Date: Tue, 20 Oct 2026 12:05:49 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] btrfs: add btrfs_io_context::stripe_len and load it
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792391732.git.wqu@suse.com>
 <2158f68d1a09a4d6c4b828a23c7e690a5a1c87b2.1792391732.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <2158f68d1a09a4d6c4b828a23c7e690a5a1c87b2.1792391732.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::7) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LY0PR04MB306006:EE_
X-MS-Office365-Filtering-Correlation-Id: bdaff483-980d-4ef0-0f8b-08df2e91b9e7
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|10070799003|19092799006|366016|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 OaGLCDsCKOmv+7bXlcXHrbgvUyzL14llP9AgDLCT75qr0e3FP9YXckv0G5XuySVwQlyayNvJUsKGFJ3KlcmYxwqj7i8ZTLjZ65MsptK5W5xtUXYnZGVSjRUhxsCEMGEG19O8+n4wg07WfH3MVXb8xRjXCEyD3qIrG+IaZA4w1jT/bz2YpnaMKYLRwiVK3q9HW4/855h9xJ7Rzq2RRH/rUC3cX9xqt99EQMOm7Oj/PS+0Xqo1dkzWpNX4h5Aku4jzNnbqpnkCoUYCX6Jk4PB0CO9Mb89hwNtQWsu/JcQrkEyKFGFKvClGOtC39KSeuScfNWZDGSgMP1Y7xPup2RlLEZnt/OnT5qw1mnqqngzJKq9cLb+FbRGNyeeF62DTNft42ykm5ChVTZWxk9iketv4/vxyvhRLGWV2kI5iLtpn1Rx/FsHVupe8CYpnZ4GpAMnEVkGgkMVl3TQGgZdzwMW2mb0Ee7o2Fc0112dC9uu+Q8kIxG5Y32rqH/ETMmcuV8OwHgDAWDUAwnsPMRmz6ka8octLYLNsAVgtKqy3zoTJuMuwEnLLr8ZmuvBGBw6uX50Mg50lA6kiz7d4qXz2/EiQJVBttgsYqGVuiV6U5pxBHK11RaF1M+jDl8subEAfP7SziIRsQHbRS7ncABwo3GKQnetK50wsH3/qtWVUepZtFno=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(10070799003)(19092799006)(366016)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?cHZ3Y2p6MmljT2tFRk9DN1lLcjVWZkxXOEJoS1M3UkRTS2JpWlh6OTZMNlFW?=
 =?utf-8?B?Y2JMeDVRTlZpK1B0YU01cHY5c05QZUNqUFIxdFBoeFlYbFFNSUMrOFFNZXND?=
 =?utf-8?B?K1ZWY2Nmc0ovblNwYXVBdDNleFJxVDVjL3dWb1h1ZUZ1alN1NVc5N1JJVzV5?=
 =?utf-8?B?S0NkNzVBaWk1aDNEcFVwbndkSDRvUWNibDB5WTNjMHNkY3ZRSlBaSUFiMjIz?=
 =?utf-8?B?dDVFRW53NFJxWlMyM1NjYlNvYlVwUXdyYWt2TFNVcWtsdktKRnkra3lKbUFJ?=
 =?utf-8?B?NWI2N2o1TFlVYW9KdngvalNWelRjNm1DQkhFbkNQaDhRc0tmZitSTG9xQmNa?=
 =?utf-8?B?NEJ1YTQwaVF6NXVGK3JwVHZUUFhPWThBRHY4dmRlUjdsUXoxSVdMZy9LTWlr?=
 =?utf-8?B?VEJKUUlkOVdwMEkwSVhZdlltRzVPQkNXQlQzd3FxQ0RPdU5mN0l4NGVhc2g0?=
 =?utf-8?B?VjAwbDdKZ2VmdjdGTGpMd3ZFY2ZLcFBvbm5BNlZieGxjTm1WdnF6MEY0bmlz?=
 =?utf-8?B?R2NKcU45eDFOclZZb2pHTkJjTEliTE1sTFRHRGlXemgvaU9OdmFQQ053MFZh?=
 =?utf-8?B?Q1hQYU1xZmQ2Z010cDhVMnFwTXZvMGhpZkJLNmVzbFBPNTVSbG1qL2hKUmpX?=
 =?utf-8?B?cHRsbHB3TXRmSkNwRWhlU2hjRmhIT1plQTNkY0JWVy9PMUVPMG5ubUhSVEo5?=
 =?utf-8?B?M2FnQlRQcXU1NVR2Wi9ZYUdERzF2QUdkVzNFSTRVQmpYRFJLRXh0eGlyM0VM?=
 =?utf-8?B?aFpxMDhzcEFWM0Z0Z09HbDF5ckpXeFBOWm1aWWJwSG9Hc2Z3dFRIUlc4a0t3?=
 =?utf-8?B?SjNUN0tHSStXVG14KzlXMGZZanQ3ZVh6eW5icEpTYXUySTREZjBNK0NSZ0pr?=
 =?utf-8?B?Q0wyMThoMVAzUkNxT3cwWnc1TXMyVStYWmN5Nlcvc1c3VU0zZEd5T3NNOFpT?=
 =?utf-8?B?NVVFYitPVFdMNUw4WDJPZnpQT0hpNVc4WWkrY2s0elZiTk9OcDA4bUdlOGNw?=
 =?utf-8?B?QW1pNjdlcExZVU1tRS96SndkYmlYMXlGLzJBNml6bVBCZVRuaHQ5U3JxNjFG?=
 =?utf-8?B?VGFvNkRoWXcwMEtaUjNrcm54NlFZVk5yekZncE42K1hIVDdIdUtaNlU5SFNW?=
 =?utf-8?B?eUNGYUdHTkIwVTA1LzhuMkxJbUQ5S1ZKQk54WDVTUkd4c1MrRFl2TXFlVm1W?=
 =?utf-8?B?OTdBTUV3ZVRYaGpkOUxub21zK2YyeDg4b0RxeGNaYUJUQlZGK3I3ZVBoRkRC?=
 =?utf-8?B?REcyNTl2RitrejBFazQwUzl3aVJnRWR6c0RrY2IzOFZpNUNUcVlNNHhPUy9I?=
 =?utf-8?B?WUZRS3J5QUM4MnZqYUoyLzFWdFZDNDdjbmw5MGFKeWhMdXdpOW0xcFJsNFF6?=
 =?utf-8?B?YzVLQlA0MEZSMWNVZWFIMEVrREljNzVOQ1cvdW80RERVY0cxNVlpUmt5Z0Nk?=
 =?utf-8?B?V1ZKcE1YQm9zNHJpcFgxaHNMMkRHOXF6bkI1clQvUUNkVU1FazZ3akZ6UGda?=
 =?utf-8?B?VGozbjBJeXluSS94SEVaZ3h1TUNVZUVidVU2RnQzNTB6RkphNUovR01lb1hw?=
 =?utf-8?B?Mm4vVzNTOFVBN0RFeVhxaEVWSm9VK2R1UnZtTW04V00zOFdMK1lHNmcrdXBL?=
 =?utf-8?B?Z256cWk5dFgxZyt5UXFmNUFLVHRYMVR3cWV4RWk2ektYTkVPcThXcnpSWkh2?=
 =?utf-8?B?RXo3cGFjbmg5cFEyUGtaN2g1eGhVV2hrYTBtRFZxTXFkUnMwclJlalJWVGFR?=
 =?utf-8?B?ZjY4TWNsRVdHbkpHdDBFUWZKU2NCQTJsNWRKRUhacHhPNlVTcWFYaW5tMCtW?=
 =?utf-8?B?aGtTVTlJS1Y4TWIyMENvWllLQXFYZWtEWXBpbWM1ZWNLWlF4d0dKWklaT1hj?=
 =?utf-8?B?dnp4a04vMGc4K2N3ZlF0c2pjemNwK296Mmhxa0p0U25SUHI4MlZnbDdEWTdz?=
 =?utf-8?B?bDVxL2h3Z0lyZktkd2tzbkF6U2k3cFRCVTB0SzMrcXljbVJjaGFxeHRLVHdR?=
 =?utf-8?B?c2JOc3RKb2g5bmo1S2x5a0d2U1F1cU9uSERiNzVzMFpldUxzWmZkRHU1UDNu?=
 =?utf-8?B?ZWFlQjFhaUs4U21PdXdBYmRwVHZHTkVwVjJzYjZlTGlZRHFFNFBHcHc3VnVn?=
 =?utf-8?B?MEJBMTYwUm5odG95a3YrbzdlTXRYbGo0SWpEYXFlNmc3RFZSdFlMbWFWMDht?=
 =?utf-8?B?SUNPc3FHUlVOeUhZL1NwbDVqS1dRemxHK0tUbHc1MCtHcFI3dHRGZlJNV1FI?=
 =?utf-8?B?ak04WThtY0NNbU8wRm5xd2dtYmRVK21Ld2NDOG9UMTFpcDVKY3VBLzM5c01w?=
 =?utf-8?B?K01GejByajhnNWR2YUZVNVR4d1J6bzNTU3l4aHVIU2FFMFRkK0hybXhNVzdN?=
 =?utf-8?Q?OKUYrBEA/I2xN+nEeZbjnJJb0wJymLNKBJOK8EZcZDe/m?=
X-MS-Exchange-AntiSpam-MessageData-1: ja4Gdi0u4JOF2U89nche/ASfBd65OR+8k7E=
X-Exchange-RoutingPolicyChecked:
	CsBZhfj82efGF+OZ//JlaBkvbcaPVqipsZueWE/pD5B0seHfrfUGSjoxuVoi+kP+upyh1kVf8fUSfY2Jb+PAYUcaAGvwdYmJ0sZilXNmjtHuUP/QEIFERokxHs5OfYatN5n6kwuO1IqgMyUUjnXahrZwlku9Q1k7gEwQu8ulZGO9GGcgWa8Bfa6LHi3hCxeefAu5WqTYfNu2XdXooTL76qdsXLjMtr2xOQiCrrScmHwWlr08PDz9jzzBbz9UHj9Wv0w0U4W3cZq4KMpSPeii7HccuXlRouvpct+71Kx3IAO+sgI7yK212n2Q+Qq0a0gDKgyKWoazLUacUFA+lwIjcg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t+AXXyul2Q+5tvT41L7NI9lt4qbz39e/BrLCO6Px3/Tcy92naK9OWVvCvF/CTErTtxWJMJxeVXV66dLLnRue59DptgJfLbWsxbfi+lbq/moWr8hit4Y05n9paBjCTDYJC7q4DsI4FWaOTf0fq2IY0LbTA9IUpUm6jY58Ll+IyzbCJvsn9/2M3mDQVk/ijknfBeXV7HvZWGsto3Jl+50vIyPMHWJvnRXVEky526ybu+7of7OFnV0Z0q1d22vai1Lym3yAPk+/U9hivAZu0SPGFcjSDL2uwpPLqMmI0dRh8Ca7o/MJneHgBnVtoOkD4wB/6qWjLQRhaUOQpfFJXJqF1EF2v9EQrso+HDZyNydvIFgjfyxkF6P1cAzsuG6Ttt/zElYInzLLKD+uQDPnqqfEp4YvVdlcFkzkRongLs2rbOqjEAtK+FxD+pqtysW4EyG4Dx+jKOYQG5/Zb1Cf8ecOAfvW9mX9jt+NudG/ber5maTt8fzmoL6GQZaHwSl+FvLEnqQ6QyJVJx6u38rAev/PaRfBaeBDVPsZooLym+Yx3RWWD4ChmpDqkrpj8wB/7Rd++nmT0ILDaLQoC3E6hpGB4Uhdl65/FS1EquECcUuWgJsrF9Y7pO4M1YEgRAmlLnPF
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdaff483-980d-4ef0-0f8b-08df2e91b9e7
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 10:05:53.6239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ovNhWVR7XsazNhmfFacinm2+j7coY8jp4bTQrhPVK7+CsAOAAvdiSK70M7WuT8HEJ6dkigboNOJqcPqNHT5bkrJFsDRM29za4TAcPOd3oQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR04MB306006

Oh that one's handy for RST as well,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
