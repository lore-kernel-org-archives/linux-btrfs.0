Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792645881;
	b=DX5pFXwXuJiuj4EJzbBuJysE7MlVvmBPIcUFqndRzzL63sAdLbdFQ0B0i4rDvhwkuocS
	 kH3OGEr/CvOGoU2CzeRXqYX6uQKN7PGKONpUeTH9RrIKuoHxWNqtUJGP4YtT9Bw0RYFQ3
	 3AgFjqh9noqPAQxNfozsrZflySsXLpTAeZ/SWGLzJcdQb6KLx3aGi9NPm37rqC7OuW+9C
	 wSgfV8AIF7SqTDJKte+SrtQKTfLt6g0bfzPHCwfQvhrpWCDXGni2R5mysVe2ufbHzUgzd
	 lOSml0On88lKVONV4iopKdS2iHGQZYd1s8o0bINkBvgousJsQ42H5rHg2cUHx6QI7mw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792645881;
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
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	b=4oiYRmUSrVbUnIj9GxRUrR14k0C2xL/dlaft7Sqq23LwMPGt5+UO0eHctlM/K5+vuyzW
	 xiW+T6vtqSrzZLbAv6Wt1SSPDM/OdCaO8lJ7wqPSG33nrLl0lr2m3Key1GpHCKTpINN/I
	 niH/jkqmMG7Cq23w1eL+W3unztioi3k36f8WBtOrlN65cxyV+Inbbp2cyWAsCJ2TuWyH2
	 WQBtzvYCOF/QV7FSu0H//aSXbMvkY8jHPlFtRo29kAdLWKR1w0/I+xXYCkIKeYNOVdpqP
	 XlMK3Djc0XR/Kc5u4AJozFnaxPF5/38y0rkVEe7sOkoAMjX4L3Lu2K/xnY498qhbzqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Kx0z6zsw;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Z4kPxtpT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DAA606A31B
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 05:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37DAA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Kx0z6zsw;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Z4kPxtpT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792645880; x=1824181880;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=Kx0z6zswQuH8pjJaR6GsnxmmO+A0i/nE4FcyvQN8LeaZQS8UssYCrgq2
   VIf0WzsGBb03D43lxnixJWcKZHC+DjnHnWVX+wsNtkoIcob0N5U/eV4cJ
   eecHsfZfI1FYjgcgzFqGvGUjPnhmdMB/mbva0B/8X9w4h3TPabAwe+pg5
   s2sSeB4n252uvIFYSp1yxmYZcnvkKcce2HsIU3MNkxJqJMkJ3dDUz/d2E
   4ejs4p4ZTVL4XnnoSGvSEO6cAzk1G7oCGs8ZJ7omC39xoVHiLiyX5TFhH
   44Pl7SxWMwVSc7B2PACVuIbik2TM9eL40uBUWe3sHuhGVKsOJoCr3GOrr
   A==;
X-CSE-ConnectionGUID: XQ3NhRmWSuu8LcUKI3Py7w==
X-CSE-MsgGUID: IrtsDGzkQRagTbImXvCvTw==
X-IronPort-AV: E=Sophos;i="6.27,171,1786982400"; 
   d="scan'208";a="154483948"
Received: from mail-eastus2azon11011002.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.2])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Oct 2026 13:11:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BTccrsC/yRtLrZxDl/YNAFKjaRZhxBF+ZrtKBu6ZDZE5RB5wE/b4Iyw6RXZ8qRWqe9TuTDp5ttZhrtzQKelWSmCv56IbPz+lcVTsFhR9Xkwhvg5G1UWlt3dGx7vUYiH+Wdm+kjepbYAwCdtPoDGY7kIKQIZkp4NNLym+FpgdKfZmc73t21GF+09PvFO3KZEx3RcaAnIEeY20oDXm3VCIEVWYVeI+qrfVyE19hcZlh4BIMDlSQdZ2mvKchqWLRXbRv5J64ZOUwww+VIWNTXkKCWXeg4jw8XSltbGk2Z0vBkyAvnop8MruxY2a8MzttNbUhtnBRt+RWl/18FebvIGYOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=cTX+ndjTpXvcM7jYPl0ZScI0EtQoAEvpbthN3vkUNS90B5kwLVY/7bvYdZA4EVjyn3UflYDrLvwsQPQLzi7ypDqNrXTgv6mjq6JAaD3DMOiMOGWToTwNMbazr3cQLupw7/XlC4MiJtmkmojYvgUri8jx7vbJFAIhorknwOuW1EAhbNfUVBoODfaDy3rO/3vxBYuRYTUXad+sfnNgjycjbqjqvvcASZf1ftlOfeV2srxQi2wOZ/VR5thTXU0A4dizP9IsqYjApmCeh+hDb3lUbimWs5FJ7Q6bFykL4iETLgWxS71aiHewgWFT0fNUmDY+C6pkldHY5Mlu7Guvk1c9Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=Z4kPxtpT2uNmUbCHNJ2hXiQPfYaFKdZipHOIZcOtRjhvYvLqK32rwumKVKt28t34gTW96BYWSDJoFY1hitymbJRcurYwbSdMPaTOeGOmRJuwH9CYlaxmLK0wfzvygSdlwVVuvvPs3VAMmp3V/jsvBzfkgtIsi/8rNLWzBGkgURY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB7066.namprd04.prod.outlook.com (2603:10b6:5:242::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Thu, 22 Oct
 2026 05:11:16 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Thu, 22 Oct 2026
 05:11:16 +0000
Message-ID: <bde22b72-549c-4cee-8fb7-4bdbd29541f6@wdc.com>
Date: Thu, 22 Oct 2026 07:11:13 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: remove BUG*() from raid56.c
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <9ecefaae0a4bcb001d1fd8ed3c73b3fb2f5a7062.1792622924.git.wqu@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <9ecefaae0a4bcb001d1fd8ed3c73b3fb2f5a7062.1792622924.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0198.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f094d9e-3c89-44bf-86cd-08df2ffae668
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|366016|376014|10070799003|1800799024|18002099003|22082099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 MIloDvFGLNQEGZwhZ1OeY/qoA+AH2mT7CP8GLCOZOmEVQUJpfyqIrkp+K1imp8pKCYVsOaciZXHV+SLQXbwvg1anFWzWZGxpM2lVchsfo9q/Q2x3HEDYRdmnjMbro9v7ed43RadnTRo1e8hV5e80Vy8qPN/RfwZzcXCNh1ZFchd4z5Ij0HggOalVS/eObZKJPfo/sdBeJXu9xvq5sBRD0ffCCVk5QA2OpgkmJXyI4sNurYSYa6yqAcjYqKwPyuvWcXP2NER99NvEGIO+cp1NaQMxso5CsPW+MIE1P206Cut/GdgC2r9DOrKQzGa2yuaNzKbwwEEOgIdVGMI+snPVwKKpoedhxUc4qg/BeKnE9BIrdVK28J2r/DATk00uQHnPbxKPfmABaE1SZgMuVKT4IV+TTXoOHlLRAtYrFO+GGczEPyTmuxUELUaIAJONJTTLvw1yt2NFJv0+Jx7Qv0urDlfErTYRumLtS/79Ew1Yo0bx0Jjb0rdyYDyRIv4CqBuOAzHhJSj3dlWyqllRRT/oZ5JnlQxOeI9Ir/X7bSCM3puZpSoesFC9FyRMRYSH4iGo11ElGOXnNWtNPEhw8fXFjMWsc+VnvgNA/ojWXF+a9jgZ60BA+uQCGEKjuCijPjsLiiFPCD3be+ESrQeLg5mjTMT5jLz3UkDo7HX6mlUNbxM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(366016)(376014)(10070799003)(1800799024)(18002099003)(22082099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?c25YUExlWWhqZmNPYWYyVmtGdDVtNmQ1NURzYThmMzI5UHlEaGo3Uk9OY1dS?=
 =?utf-8?B?eHh3MzNORTF3K3h6ZGczV0pBMjhNS1dPV1dCSnpzTVphbHN5K09ZRnVoODEv?=
 =?utf-8?B?bW9zOWhJK1lmM2wxVGhxWS84SWhmQ2FGWUV4YmtNK1BmYmtOQ2k3Kzh5TEJy?=
 =?utf-8?B?Yy9FNXZBc1JTdlJZc3U1ZjFod01QVjlJMmtvWmQ4S1Y4Y01Dd255Y0I2Z3Fp?=
 =?utf-8?B?emhUTVJaSVgvNUdmOGM3OUVrSU52eld0Mnh2aG95c29nY1UwREhlQjV2NWtK?=
 =?utf-8?B?ck4xTE9vSXloVVNLVVJadi9zUFF2elJZU3FaVGZNbnJIMkZtNE1xbHptNXNU?=
 =?utf-8?B?aytKYXd4RDA4WjhvdDR6OGhZSHp0bmxiaEhPQ2ZEcFd0ZjM1eGYzRHNzNHFS?=
 =?utf-8?B?cVBHd3ZBSm44UCsyWG82ZGFRVVcwbys3VXM0UU9yTjVJc25TQUR1VnJFMGM5?=
 =?utf-8?B?bnZTd3dTRUJDdnhHc0RPYTZFMGRBdzlhM3F0czljNjV4UjFuN3RzRUEzVjhz?=
 =?utf-8?B?NjBxOFlkUEhMMytoYXd1M052dmNqa3VvRkxsSUdCckFMZWlneTkxbUZialg2?=
 =?utf-8?B?SVZ4L2ZKUzRyUmNwTnpiUnA1eGVLZHl6OStDR2ltSm8vV2lid1lGdnNwUS9u?=
 =?utf-8?B?WkZDUWlSWGdmNHBBTS9yUzd4cy82a29vV0VveFR6czBPT0puUVVhRU9QNW9n?=
 =?utf-8?B?bjNvaXVyQnJyOUwwQmNZTk5KWmdMRlNOWDJvdjJXTDZFWE0xYmdaanRxdENZ?=
 =?utf-8?B?WXZrVGxncHFKbzhQcXlva3NqR01xRU1kM2JtaTZuMFUxTFBzbVUwV25ybmJU?=
 =?utf-8?B?c2xaWDFIbUJzeStBSmFGYnU2UTNGN2dkdEpVUVpQcENyTVc4V3lPRVJZTXVv?=
 =?utf-8?B?OHNlVDVtN0FacEpnaWExQWJBTVRIdlNIWE51UWpRTzZSb20xZWhHZnZHbFc5?=
 =?utf-8?B?M3ZuN3YyVzh4c1J1QjJsS1AxQStMOHVacTZKU0FWZkptanprb3NyUEJRTEYr?=
 =?utf-8?B?RnVuMFo0SS8yMkUzOEp6a25vRWNscHVNTk54YVNWZGVlSDJnYVpzTThzMGdP?=
 =?utf-8?B?SDhmVGc2N3kwR25ZTW84cjVob0w3UXpRZ2NQK3pkRVVQSGxTc2d5Nm9uRG1R?=
 =?utf-8?B?Z2Q2c2UxMFp3aHBKNnE5RHMrb1I0YWNZbWQ0SHBmMDUwVlI5eTNzZDc0M2dU?=
 =?utf-8?B?akpYUTNlYllZemRvVU5rWVVqYXdZM0xmSmEwR2N6ZzVSd2pUb2tKbk8rLzdG?=
 =?utf-8?B?Y2ZOK1EzcDF0ZXNiaDZMcEpkNXo3dFB3WnZCVWJQcHZBTUd0TUVkWkpWSzhU?=
 =?utf-8?B?c1MwQysvNVZmb3daQ25TTXBld0NjK0FlT21RempaeXBSUjhsZ21xZnUxdVho?=
 =?utf-8?B?M2hpaXV5NUppS25yYVRIclRrd2kwM05uUjNlUHdjaXVSOVVMSThkNEdLY2dp?=
 =?utf-8?B?Unp6d2xENmhVU2xnWU5PU1NaMmdOYVJrdnhnT1I3Q0FJWGJoeEY1NkFMUk1M?=
 =?utf-8?B?RWtTL1haQVE0L3JZRFJDaXVFb3RxczIyOG9JbVA3NmFLOXZjbytoYzgwc0dh?=
 =?utf-8?B?dUk3WHJyRmk2SEF5a3JWei9wWEtEN281RTUvandLdGRtbllaZkZ1b3BmQUs2?=
 =?utf-8?B?cGlweTI3Q3gwREhwdHRWaGh4eHZWNU1UUlpWR3BYdVZVZXhHNWZoU2tldDNB?=
 =?utf-8?B?djVuaXpkQjdwajNwUm0zRnY0WjNPWjJVYmlQd3d4MXFpaGhoRDM5Qk5jcTEx?=
 =?utf-8?B?MVJhRXlrZXMvd3pQd29yU2psOUZObm9pWlJXQ0owdmJNRjBxWVZKSlhiZ0NI?=
 =?utf-8?B?eTBxcTBuWjRucXpOTzYwaEw5MWMxdGFYd095a3lOdm05dTFhV1dmVkx4THlv?=
 =?utf-8?B?dFp6M3ZkUjU3dXZLdmdTV0tGYVZ6bjBtU3JmMDZlZTQ5ZlFKaGZMVUNjOHNn?=
 =?utf-8?B?ZGdTemNPdXZJeXIzNUxVaHdOa2Y3cVczRlA4bVR1VlNKMXVpNm0xOUtUWTZ1?=
 =?utf-8?B?WlM5aEdUTU9hRk1YRjNvQ2ZmcFNVcm9EZTJsM29XSjgwNkFmaytLZXlpWlIz?=
 =?utf-8?B?T1VKQkJ6dWFsUEJFYlYwQjk0UXppNm4zMTEyZDJhaEJCVWVmWXZIdXRCcU1n?=
 =?utf-8?B?NGtVc1dOYWxETXZmZHdVRVNwVXN1ek5tNnJ2djRWQmJ4OFJ5dHNGKytMM0cr?=
 =?utf-8?B?cVFGakdJUHA1WHl2YkdMd2Joc2JmMURYN3pSeXExRWhoS0RhdHE5V1VNZzRq?=
 =?utf-8?B?cGJTL0RXaTVZREN5STdCOFRTVTVMaDJzdk1EVWRYN1ZmMEFIVE1ERG9Bbml4?=
 =?utf-8?B?aHJFUkpVUTJFK3F3QlowVHQzTHBqcHdIWjNiOGRMTzBlZ2dvQkttSXFwVVcz?=
 =?utf-8?Q?JFxZd0Yl59jwVQEwW9qiZl8ACbTiO4C+UYxmOczO1Mdo3?=
X-MS-Exchange-AntiSpam-MessageData-1: y7O7ZXH+oUCcbIwVyBw9LdWOd40ZVkGLyTo=
X-Exchange-RoutingPolicyChecked:
	kyepkfxqjIsa6umx3ZcqUlrQMI0HtStket2FczPGKi4/4usBGmN62HZmYsKwMMWJsPfKc0flYFzlDG77RYI1qBVKjs2EtOm+CgwbOiWjjNH8H1mdpPBEfBCaJZFkt9rfWEg9z0sAMoTLqBC1LMx4MYLG2fniJtrdzATGLcNd0c16QJGEZtOv7vRZvA31aUKlqTgYT7zPVVEmPaftBgYGvV7XYv/P7sa/wfb2bYvp2RamgnWReDnJt5RHpMbiU3L3SaM1c2D+N9aP1joNEeQK+I8+5LidrY8yECqbOavcv59095owgUVsFJshVeARCf7Iuf7wttFRSctHFlnBr/I1yQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TzNcrg/jJ6Z0CUXtcFPJ1WUub8z4x/Mk4NxpHqleaAv23+Ldc0In3rm1pboKPdTnQLEuQrXHGSXEzv9PIOnWtlQid2zUS7055eyEKh9d2JieiOA1Tq5m6iHm2BwMTwAV30Su4XZsgwTrV1ZvNhA8sJ5ZpWz4Z+gkoP/rVI+A3HO8vg6v+U2cmm5KDg7QU1FFcWwJa1ugtd7WfjzwKab86Hd2dBq0rRhLQdbEusJu9F8nJY63lAnq+GiPIYtF9L2pFTdTZV9HBleKoOb87orDQ7jmJxh23Ur0EghIOCpk2qYdNW1XE0anuIUpBALaQKPU5In5nG8xqNOyo6StAFJZg9E+cuDUhr5nj6jYW8fjwQ1YCV1zaoWGlZyVjNyn0ZnmsheykF7hnXwORvC3Oo/LIb0284bdQsv7fFx+1CKqZgnEE3WwYKD4CfzDSWDchKC2aKeVK5NjeyhM6NCPL+MxdtdqQSBXEc6vuSllWNQkKWuIVjV8bbMIADvlejUoXuO+99kRBZy4v+b2nAfz7muFNpnNbu3M6i7kHkDQWx75jMuQMvr6xNRbswuhjWcSBRxgmokzYrQCNGcSyo0/9yFPfw5F2ah/5VBUsn9DQKdKUd5fJoyJOtxQ5WmYbqdv/RO7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f094d9e-3c89-44bf-86cd-08df2ffae668
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 05:11:16.6633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zS8BDfbfctLwSejdW9VVELL+1mhD4kI5s8eO3T5kVbkgvfPuu4GpTzp72P1XgH0CxOU3HQtJgIcG2j9B9u9L3VxN7rsFYbb7GglCEr+r898=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7066

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
