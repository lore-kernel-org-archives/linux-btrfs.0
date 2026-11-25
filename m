Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795619118;
	b=fkfmiAOdd8NJileLWSdBisvWSlXRqIrNOuAjEAXZ/4WtmNzqtzcrqtK0Xt7WMts78Sc3
	 4NvS3Y97fE987PrWLuB3HHUkzAeTMdZ3gnjezobcj3zQ2NIinYaD9hAJ3Y35+NrlvFTaW
	 3wA8u9dYhQyU3Sc8Ghi9tcW00tViUD94jaLbVw4UTJF6xkCt8FkTuD2bNZeg2j1mtehRt
	 h/CsTxRcS9qJe8iYFVr/iy/sA97cUXZM0WJAgFFaZowTz7nmfdhmqi4VW5VYDFlAAKCgC
	 ei2D5Q13PAnAhOEWUIQA3J2OrPxC2uTGArbdpQG5vhSDh8h2/a4AIQoZ8ivD6qypWxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619118;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
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
	bh=UN/9hQeBV44mWQPT7ITsTYa8OfKAgfbyTpJFUqiyWPE=;
	b=Jla9k9s0FFFcLIwDkLLtmt/rJ0vjMJlv0duXpBkUwaAhaBY2ZeGOU+Tk30JOsDkCBdnD
	 v71oUNBxLd0QxQK0PCfsWRIR9xjTGk1wntnnPIFmpQVQ6QWt6Nc5zf/BpzAsOkGmX6t/E
	 YOdFlzJ4aimCFwCFW5ZBZvIyFl1e4YQ1bZIi9JhCU2vxlM5fKP/Mym/vXV6GYs+/29B5k
	 2qGYobOIKp9iYUjFd+yCQBL3G1smT6nsRdLcXyAPHMK+IH7mBIUgpayxgciBRuMSU9eOC
	 BRH8V01sr9HR8Du9uYSkYZRG0pZc0Y2ROn40mkgq0g1h0A4nuZsW/GFc7u00H+yj0BQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="i/yhmrVm";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=v4gLvbld;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A152B606A31E;
	Wed, 25 Nov 2026 15:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A152B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=i/yhmrVm;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=v4gLvbld
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795619117; x=1827155117;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mspb08aqrKtuQvAjn+sRpH2OPd/GjeDRsnk+JcZGOTQ=;
  b=i/yhmrVm8IKaQFhhblL87B826deEUA03A0eqMrbyQDddugPjuQqy6IB5
   An6LSzxyp+V0WXbvaFu/PNQA4JErRZKEhPa5cxKJSwEyQoMI1igm7oylu
   Z3xAQwf7rlrTm+0Z2rP7lus25OqZikVMGvp+BcbptzKZM5ch74DkPXhFX
   A8FN76OF2EqBm1AYtlYyKjfw+XjtNuB1G+26+W9lhXqzeYDLnJfuY3KPV
   vzBXuE1TdbdT7fK0yiOBFHkILRDZlvnb5jaOBjolgvu6iNCkpozujKF1C
   OFUC6/qzvunDq8zKcdEdX4QswhEHqrDXjfnvI5EgMLNy43vg+jQ/wEIiO
   A==;
X-CSE-ConnectionGUID: JDZmAmYpQFC7nOjYwVcqQA==
X-CSE-MsgGUID: 3AOlrQ5pScqMVv6VIRzDtQ==
X-IronPort-AV: E=Sophos;i="6.27,233,1786982400"; 
   d="scan'208";a="160777620"
Received: from mail-southcentralusazon11012012.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.12])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 23:05:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yy8FEd9iNvi2W7feANUVr+KiPj0IZpgFIfWMjElWXIH7LBLVOF+4eADmeGZ7MbKedcJSuthZtWGen96Lxkfq6easFReMipU1G4Trw28NJwOBSZ1yAcE2jx77RGy5Ga0ygOY1v41/HJ2fIvgAiHTl+bOhs9MioBA/U/uw8leqhXN0eTQoKm1i7WklKRh36VyfXfrZ7pVxFHlJ35U624ah4H1262alroBrYTLG02PlO/K2hqCsyMWiSgTMm3/1oLtyM/ajICpYB5yVNNgoGNDemj/ghQD9jw+ZkTK7WAUD/7cKYTQ8XLj3jDfiw1pDY7pXhCkJ2QkLbea6+4xSig05Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UN/9hQeBV44mWQPT7ITsTYa8OfKAgfbyTpJFUqiyWPE=;
 b=OR2sIQ36r46ZPMeWcAZYoPUmObSArOHenWogaPQl431C38kUg26HK4PTfdlThTGIYmB2pvxg0Rl9Q9mxqXNFxWOgxr3PeJ8OkKkku8IBVu/r6kFHsSIE/7AqGZpKFrew2cSfjmzxvkCX4R+vpZy/0kAOMD1uA1Kmg+/V0exmTaYStumv4o+OK1+NPvb+DVugOx2WVJjuVWRCUrI2+ZYpq2cO2qomikFUTxSbjWBHenyITVJXSNNODKQCUP/4FW6oVBoPYVG413TYGoSfnT4e6zLadkindGB2yAZYmHHaCBwUpqe3jo9bYnoLdoeQR7dN3eUWSWh6Wx2ssZ5lsvfJ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UN/9hQeBV44mWQPT7ITsTYa8OfKAgfbyTpJFUqiyWPE=;
 b=v4gLvbldX8WyFdq15NrfZMDZ3N0SBwuKGd9szNzlft32hqjJYtmHksoF1IKsgsqJc5g/s6OVZAeydgYWwLnXBG6BLyWyQ9EXBfXcfLj6nrwAr50GNS2fP70u/GPICt5Y9W/GVvpd7wl9YHduoUDxUdcUR+RjWKFYuZG6alMUOf8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO6PR04MB8347.namprd04.prod.outlook.com (2603:10b6:303:136::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 15:05:06 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 15:05:06 +0000
Message-ID: <55094de0-c0d5-4dee-af89-49ed1c7220b5@wdc.com>
Date: Wed, 25 Nov 2026 16:05:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] btrfs: zoned: RAID1 block groups with missing or
 stale stripes
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Qu Wenruo <wqu@suse.com>,
 linux-kernel@vger.kernel.org
References: <20261121134550.216217-1-mc@raidlab.org>
 <9-2mnnEeWtv9IB6_6WebTlE3yFWPBLEtc94ilVb2gMhId8z8pMjeVRwAhkniDIESZEJhl7xNsZ6KCwe759zYLm2asBJrtFbeJpWM-TVCU1o=@raidlab.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <9-2mnnEeWtv9IB6_6WebTlE3yFWPBLEtc94ilVb2gMhId8z8pMjeVRwAhkniDIESZEJhl7xNsZ6KCwe759zYLm2asBJrtFbeJpWM-TVCU1o=@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0281.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO6PR04MB8347:EE_
X-MS-Office365-Filtering-Correlation-Id: 81ba1655-5ea2-4192-fc33-08df4b057d94
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|19092799006|23010399003|10070799003|18002099003|22082099003|261026121527099003|56012099006|4143699003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
 WxJjOd8PJboK0vhAZC8+zaeF5TI0cDtRqHGy9+xCdkcd8z2naENxN+pNpvs8VtvxEdMyz1Uj2n5fHkX0yb9yAKfuTAPStQtvuQf+m5MJX0jpx8MWtERdQZfdinN7uB/1XZX0w+rTM0ILtTDBX2KSRNIKWmH0VqmEAKFVcs0lSEEpKwMMw78cOH3wqJgs0fT2d2qHsU94wUotQsl8YSKfMjhs1RGP6lrdiETwpDKZnadsmH16tmRxJ6cGYaXtMw+9j2sxhavbCtgcqMwvRDswgQ5rWnjbAbqOf70c/+Z9dYe0celbgQjHagEGGywi+1T/TKdEn2v3Qe3rv5ZegwahYUtNvApyEdUZtFOxlNnowZZaWhyoiQYqmsGawfRiXQS1uKMaj3Ec8U/4wxmb6rTn46ruNCKrW7NmOZng0gcQ0EgEGi7/EnOXN9SljwHt7dO/j4nC4Om+wbld+lNk0pNjs/rkno3OC9uodDh2zR3FtUlS4zeSBSivx7h2tLvSHef9ClmgJL7hNq7m2sihA2QEiFFZpktMtBGO4mmWqegc6VUR6cmE8ZAVai/iO0nE3c40YeiOQoGr1quu7mNFZSGVyG+1L/JAwUNP+yUiXDakPExg3hgUy+wzWRPy/UY+yeipNDaArwtVUFzvGUjZU+vX0HXUlOG6utd5JwnEldX8urI=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(19092799006)(23010399003)(10070799003)(18002099003)(22082099003)(261026121527099003)(56012099006)(4143699003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?STRrR0NoQ1J5ODAxWEQ2VlByaHVUZnRucTBwa1Y1YWh0QUNnZDQxM21YZDNo?=
 =?utf-8?B?MUtlWExsZlowZkRHWVB4anQyaCt6eGtJVW5ZZVkrOFNXUHZESXdNMWV4cHRO?=
 =?utf-8?B?MlNQZG5SdjFHN1VObG85dzJrWDJMY0w1dWt1eVRCOHBFeGdieWppc3ZOaXJ4?=
 =?utf-8?B?dlVnbHdEbUd4ck8wZGJ4TWluZnlCN0lmMXlMUnE5VHU0Skd6djhhYUswT1hQ?=
 =?utf-8?B?b2pPWU4zbHYzNEtmZVZIeXVNaG8zYmtNK3BKVVdreFJyRWtTOG8wblN4RTdD?=
 =?utf-8?B?ZExZVmEwQ096Qy8zS1l6cUQ4b2FHaVpDMnF5dGJDekZHaTN6aHlYWUM0dk0w?=
 =?utf-8?B?Vys2SE5MRmsrSU8xTkhKaUszbHNpS0ZHb3E3aWNTUThRcmN2RUNITnFRYmYz?=
 =?utf-8?B?SXJ0T1Q5Y1hFZFBTWnM0YTRxbnllV1orL3BBWXlncE84L2JsVExaUDgxakdV?=
 =?utf-8?B?RDZzakRHVHJOTkVoTlVnRlhJMFMwd1hla2xwcVhPWTdGUEdYbW03eFpxaWxD?=
 =?utf-8?B?OWtvRDY1QmlHeDdseGFPbk5oTlZrQVk0azU3M0VNUERFaGUrUUNLaU02VFlK?=
 =?utf-8?B?Z0VjTkl2SFFmQURNQm9QYnlCdlIwU05QdWx3SVlHTThleWFZc291OUwya2Zn?=
 =?utf-8?B?YjZsWnoyZ3IvWENQeHFJc1lNa3paWDNBMUZHRzNkVHUzMXZNbzNxdmhlVVZl?=
 =?utf-8?B?YnhPZS9lU0JoRXBiUUhZc0lNaTNmVkluL251ZllvMVpEcnlEVC9GK052azk3?=
 =?utf-8?B?L21qRjJZZnZHV25TbHFvWHB6bHZFcGp1ZlM5dE1JcUFIdm5DRzE0eEg4OXc2?=
 =?utf-8?B?NmcwZjhVWk1aZHpZNVVkaGpYUzVBMHpvdHdQY3NPSEt2dFEyYUxvN094RERL?=
 =?utf-8?B?eHVIYTc3eEQ1TUZXWkdUWW4ycG1QL0R6MGxaZFFlcjRJb2gzdnM0dFd5VEZ1?=
 =?utf-8?B?Q2krODBmejNxT3RvSFp5aHRYcTljTEpielZyYzFRRElyWG1zbktzRG8zQ2Vh?=
 =?utf-8?B?UUtMN0czTmFSUk9VSU0yaHpXMEpYRmczTEdEUi9VMVMwem5OMklMSS9XRFZk?=
 =?utf-8?B?TUFBOFo0TEtJUS9yVU00UG5ib1M2MFdhYUJxd0hmdEVVcEs0K3BJUTIyRXlK?=
 =?utf-8?B?UzRDTlJzM0x1em11MG5WUlZFMXB4YlNqcG53R3JiUzBsMFU5YUhpZ1lua05M?=
 =?utf-8?B?RmJCYU1aSmtrUFkvR1pBUDcyT3E3cmhvd0tGSzRxUy8rZWExNVJCZlEzS1F4?=
 =?utf-8?B?U2EwV1lSbjVuTVdHR0N5R2NhdDB1NWVPWUhPZW5lZkhTTU1mdFVWS2E3RDhZ?=
 =?utf-8?B?ZXhLUkxZcjl0bjVWYVlWWTA5VnFnSVBJVHlBZUVNSEhHcU1WS3JKd3NYWnIy?=
 =?utf-8?B?bVhHaWQzTzA0K1lnOVRLU3I3cWMwcERGMWpZNVlLUDJsWVNBdEdVZzJiTHUy?=
 =?utf-8?B?VnlyZWQvbHBqYVFzU2sxOWdia1NGSzExUnAvaEthZ3hKZW12TjF4SWgwQkQw?=
 =?utf-8?B?OTdBK05hdEhpUWVDZ3RoL1NkNFNkYmpxeDRDNER0NU1KWjBOYUFyMVJ3Z0xL?=
 =?utf-8?B?NTUzNnc0OEVxQlYzWDdVM0Ixc21hMnZ0Y2pXaXpKeE9qTUwzTmhCMkJKNFFH?=
 =?utf-8?B?dXVKZzRqV1AwVTN4VWFoS1lHT0gxOU9SL1dFQkprUGtZZGdUUnJwTHJzeVhz?=
 =?utf-8?B?ak5vNldCSG1EWFFyeFA3ZUZyM2tkd2tLZnhIc1ZMUVNqWEY2ZUN5NlI1ZnRy?=
 =?utf-8?B?OUhlRnBWaFFQejZyOSsrSk4wZGdhTDY0ZHE4NjFrdG1RZDJ3UUpQY1Rhbkxj?=
 =?utf-8?B?Uko4S3hsN3BaamtJcXhiR0NwY244aWtXVWE1V3FIWEU5TG55T0xUY1VXK3Bj?=
 =?utf-8?B?cHlqWW1SMk4vOXVBdWNULzhPSzNzYUpaeUR0K0xIZm1IN3BWRDZWUCtVSWNV?=
 =?utf-8?B?aUMrQ2xNeUhpU2RYenI1NkdkbEFvWmF1QWpTUU1ESTZ3cnpaWDVYSFh2MDVK?=
 =?utf-8?B?cktobHZaMEJsbnZndXRveHUzbjJ0citURkdxNnhFcTdYUVRuRHNvTFkxUXh2?=
 =?utf-8?B?amx4em5URlJtdWl5ZGJrUjF2YUtvSTFCTTI5OE9vMnRSekhvTVBuVFZ5OWVz?=
 =?utf-8?B?cWtjUHlyZHZaUzUzdmhLZ1BtalV3MlJLc3FveG5DRzl2OUI4Y1hycjFQQzRP?=
 =?utf-8?B?RFJlblE4bUt3V0RadmdVNVVTQU5Ea3hVZmZlQmNaQjMyQlVtZ3BSYmF0L09p?=
 =?utf-8?B?eVh5dElycHRvTEZDSml2bUtDZHBNaS8rU0R3Z0tvVFlqVmViejdhay9UTzZ4?=
 =?utf-8?B?SERLZ3dOUitic0pVOEx1eUJjQTFsU2xQZTRORk1CUThEZHpYc3R2YVBqejJh?=
 =?utf-8?Q?n0uROgMAl/pSjeQJVZFf4n9/loc4jhZkljVsOuNX2wjai?=
X-MS-Exchange-AntiSpam-MessageData-1: 4gLMXzJkhsjvU5OwaFIOaASapwYcBLzlBq8=
X-Exchange-RoutingPolicyChecked:
	NIWaD+uykXb/VoxUwMArQxD51O66nKNIILY+LgNg9gIfpVVIRhMvNRl9SAOq5NUgUqZhVjdheGoQ2qxX9gTesyaUKOkecp4xunqHn+PgapUNi8Ekj4ofwR/oXXQy+SueWswxKG7cRPBRbQhmpMP/Xs5AwzqkyOwThAeTmBWyFdNTQyGIT2GfhHI/4wR32k6HatpMRb6nHXvbUiO8Vgv7W38wsUmrGxBGLAUhBJaThYcKd5JClPywR/SM3rV/gBwHyfPrPqlqRv0f3BT/NkH/tzz/hMqcL1pRHTpD+L0DQfjd6BqsLflSpkYkYqoOSli83CctNNyGcu0Orrk+KfQdgw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q4ccYvBCUaJvqQMc8bnrBg1fDdrdxwAnUeC8uJExjH6bLqJdGwNkLUgvm9jpu1qidthA8u2YFNzbob69BBA1Qw4A0D3wHkqgnPaet0xvbYmV5vDFbmpsJyXAVotkr4XmncbaG5ng/EE//6i4gJGVKnBvoX5RdFpX2XFKl5OsNc0qywcvU/aaQQv9OGRgt4bEEP/QA3ewhJ2juZzkIGY9BrS32bInzq3zWGZoq93vI0QT1JEbQ2dOHKSAY/CpB9oR1VaLOsrmor8Jt1nFA2NeCBfj3F6i7lO70UuR/7NTWpdu2OreE8m0PqXMqAsZihqqvF3Og0GgCuf7jKvCqimjevFW1ObFJQV2MmT8iYdYOVjZrqJVhk8efCq+cHow5gNACbncohNN/KDNfhziN8llU8RHcPy53Xsf1sKJUiCHOj75FJNcxbm0Xs8pBmxyIZToyA2+kMnOMES/hTyrGxdOWmQL0n7Dr9eqjz/8Q/zEnuaLJVgbhRnYOv2XXWp6jZZjWXiwtt/X/EmsfRABADgTPZM3XPO0/ibelrwOI0GQpBPEhtBd0JeaaR+L99xzzXWj7ssePm7E7SDBnFFU/fR1fGvMYHJ/PGv3++VWfaydx7XxUGRXHCZnjUSorrHod1C7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ba1655-5ea2-4192-fc33-08df4b057d94
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 15:05:06.6790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cvJzZOYdFeHnyOVIn94zuaX8vCLB1lSNNdhR6rz2AkYcWwgNNcgA6bRftJ2InFXvpYxemoXzZwj5lzaM5uowLPpaLX3O7pILFdxRlT+hBS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8347

On 11/25/26 2:02 PM, Miroslav Cimerman wrote:
> A note on this series:
>
> Johannes' v8 "btrfs: zoned: metadata and GC updates" covers 1/5 and the
> active flag of 4/5 (04/27). 2/5, 3/5 and the highest write pointer of 4/5
> are still needed. I can rebase on v8 if it goes in first.
I doubt mine goes in first and the less patches I need to carry I'm 
fine. I'll review your series later.
