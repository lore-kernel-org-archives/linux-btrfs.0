Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794812453;
	b=UG0dvVPjZFe5gVpqb1Sc86ioRNJpSdQCWh2H5R4MuI3j2XNXixi+taB6WmQ2wTpyXxnm
	 H43R8U4KTn3O1X1ABeMEmtA+jgAhjKNZABM0/NekN+LaHCq0eroStYXXwc/H/Ka9qcmtX
	 WzlAA8giYHyY/ycRz43JnEbIIrxMRcNM0uWvYWFhzrqv9cFjjvcWEa5Kdst2m+0d/2XN8
	 yqMWO5FKjqVzWicJcVOqodGREggPN7cartFQSl8lXenrpXqxrb2bXz0IbNYoMC2dGRi58
	 8EtEgRpwfMk+W0gzHqCSXWd2bd9n2SdwqfhnXoB99TDvEHQg1ZD6IVhujhQWcTLAuLw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794812453;
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
	bh=UtsigD/F4yqPovMLiXIJb2ip7TI1gpN1EsD1XTj1Fu4=;
	b=LhVNHrmAKwjTT/Ozv9l7DZeu7Uu6HmgWNZ3Z60sHnCMX0QbQoR5+gnvr7b29YdOH3YkF
	 JXC2S93AsrB/ocF0ukH7NvmtF119bAZy8cVceomgD2Nc9DbN5VAi4p/3X6uA4Hc5ea1re
	 KZbrs9xR92dbTC36JxRcwA7Jw0CA7aOzeMKDuu25VBk/NwFFAbTHsdoWBOTUiD7aXABtM
	 u1unhOXgHzx8iYQCx/uAJ6RNUzb6tVjutYdg3amt8liz+UpzsB6fetUbUnpvo31yMwj9S
	 RjC5jn6ZfCC/ZoKaIT2WjTnd+WkmDfc6gCB09RbG71CT7P6beA7Mq/H8c87ZsNrd60w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=c+iG8LzW;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YDzFiobA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BAF606A31C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 07:00:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3BAF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=c+iG8LzW;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YDzFiobA
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794812452; x=1826348452;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SQa+gw5irsfNAzTzJE7aAFCYMYZIa581ekv5qNo/fkA=;
  b=c+iG8LzWzVMP5WeB3zznu9oIHEfSWwn0d3sDycq0hYewhqc0tK2yejH8
   f5w8g3yeJ+7WzMc+95AjjGHtkiSQ1e4dWpQljSaoy5EoHr1NvK1wPZjqV
   cde8KuCZJwBxkJcUeTjGX6ctcqFTEu9nBnYZRDY4ca/AQFNQHkvxvVKKW
   XKMjuRbMbFsZiIv7B66/SClpYAOsqW5MGtPVHdq0dDwXtHE5bkxdPNf9y
   ngoax47KY+UKzpVOLxUSK3fjWBW9rNTc9rpUTZ+euGwLDx5mAlCvU6fuT
   YBxPEPOII77aIxKIloIKdS2/FCY2gYdm6UEZisMrOUtcf3gL8PSLBqJUe
   Q==;
X-CSE-ConnectionGUID: a8WcTBw8T62uJirgq7cciw==
X-CSE-MsgGUID: 1k8JWPBOSFGGGT6bJpexPA==
X-IronPort-AV: E=Sophos;i="6.27,216,1786982400"; 
   d="scan'208";a="160978698"
Received: from mail-eastusazon11012008.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.8])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Nov 2026 15:00:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W9L1AHNV+6IQgGwj0HZaIwt8g5mwfJ/4ZdO1C0eZ5Uvv65DsMhWVpLjj8H2ADBLQwyeta73vKvonvKsNc3EHCMOz5ZQfytwaT3puPZcImsSQ/baA6jRpB953bb/52HgsT39EHZXibN/04QBV3BOaZ7PSDUuxAs3RIQ/7eSgy1GeW9rSh5lAylLAzB2yO/QkK77xdVUwBCu+WnF92TO1EFkWutz/7RX0jn07qu4rif7+/x9zZqpQZ9lRPCaw/hLPbwhvHP6fcWj83GZ5JE53PUGgs2jPn4hvjYzNV5gUvkG7vAH8asEoBVFzHmNQOBOysesN9DTG9zNFg4GoE9fnIAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UtsigD/F4yqPovMLiXIJb2ip7TI1gpN1EsD1XTj1Fu4=;
 b=prkAJJTHpHlCS2AsKalXda4fI9YaByIto0Rv6lEAdIJSE8P269ti9PyeSe/vwohpcBJjxzfnpZRmEMZfdkvWE8KPl3AyNddAugvlqbtP+h5GSiXqFKi3w706FdGBDFkjNNgc/K0AhCwV+CuFDmlGd7csaCcUbqItgKoHw9AjkTnx2QyanaZmWMQrAmzDRqMkzhnHYcPDh2M9mJBVVNJRczCzEp4olEYFkehlrqt2Fwb1uv7eNVfDT49gTaoseKzmsW+t6gQe+JZ9rtRcdxkhznPA2DOt5zepsx/cuTz6uoNQKv4T1iiHoYD8/WsqrOPhLDAkUn7cLX1eys0UCjJ2Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UtsigD/F4yqPovMLiXIJb2ip7TI1gpN1EsD1XTj1Fu4=;
 b=YDzFiobAAp/1fbSLFdszJyRb3RPK4Np5gVhSv28ckEuQZsAvrLu35/l4Nu5xRak+HmUXGo8+ceFQ0/EYlezSyLOAhzQAF/4Td4pG2CZEpY6PSSPp77QYrlEJtDIEjh+A9yC/5gfHO5yLZ/VwQZJBOWYYRRiCrSVe42jEXhOXjAU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA0PR04MB7322.namprd04.prod.outlook.com (2603:10b6:806:e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 06:59:42 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 06:59:42 +0000
Message-ID: <18ce5468-92c5-4247-aad0-bbea25d8ef70@wdc.com>
Date: Mon, 16 Nov 2026 07:59:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: zoned: don't release active zone reservations
 for conventional zones
To: Jochen Philipp <a2jphilipp@gmail.com>, =?UTF-8?Q?Martin_=C5=A0koda?=
 <mar.skoda@gmail.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org, naohiro.aota@wdc.com,
 zhudongjiang@fygo.io
References: <20261110080932.1205332-1-johannes.thumshirn@wdc.com>
 <e3261fe5-4b98-47e6-ae66-d4af05caa621@gmail.com>
 <CAD=K2o8W085XSBeTYXjvaTRxgnx6y0_fVrNRH18-At=EUtWOUg@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAD=K2o8W085XSBeTYXjvaTRxgnx6y0_fVrNRH18-At=EUtWOUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0154.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::11) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA0PR04MB7322:EE_
X-MS-Office365-Filtering-Correlation-Id: 34db1643-44d1-4aa9-b32b-08df43af30c0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|10070799003|1800799024|19092799006|10067099003|4143699003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jrsjJG53D+yFndeTZdWqMqtN2byDewhXGJU3X0oynb16ui3+11Cqpa8ThUtvY6GMTcZU8akkBKWzMijuT3eZ3nN9998RTXh7Nzhv72BpKLYRfF5BiQwOtABDWkL/8TZBOaLqGmPehjYae4tWVSv2yywXZgTDBE34aaCDUTyopgZGSEYu0n30f48v+OVuyyeulNk1eYKbkmPHDv5YLMreWfnqE+0jy9qE3Al47WhvUHRq+meu53DRS1SFVd2qPnfoDGCYc7rBFnWRVbWX5oHo3C/ahU2+wGGihAxXMzT8P5U7+LoLN0QdbLn7OelJVE84hxbHn5iLg1jqaa63Wry91k4ueFvfEqhN4oE5zzUXjXfvglV5+Qpk7mO8JSdBiCWPPN0jAAIPcD/8/e60yiC/LluH+cY2LxC1P6lxIa9nMZCl8cLUyBBwncYySJQkMxVpJZ1eARlPdVV6uwx5H4CBHAYypcOX5tORnzPoGoaSA0/b/zNg+l97GaEEftUKsaJ6Bvu0k/VEXIvF9GMn8Q62PSdeB4WloyqEcwfMWmc3z4cFbBMZ/AOAbP+/+0nA5alhL/4K7VjymJ8CpPVOLK9wlScmV86MF6RSnVewB0qmUA0/hRWtC6QYxPkXtS1oo7eKW0Qa4/sdo88eTUw/FTFRCjdY/3Q17XDnBpyOTBuHXVQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(10070799003)(1800799024)(19092799006)(10067099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZG1LTHNXMXZiamJndGZ3bWszdHYrQ3ZzbVpnWjBrMjRiOEt2VG9hWUcrNTZn?=
 =?utf-8?B?dHdoVFJ2NllRNit4MTNTbEh1SCtHYWRUWk1RVjVnWWJNVEgvNXlDVEJXeUFJ?=
 =?utf-8?B?VTFvZGtyQUpyZk44SXQ5bXFVM3c2Znl6NG9zbERSbUhxQ2h1NHFMZzZOdG5j?=
 =?utf-8?B?ZjlhVHdIZGhRRURIUm0raUI4RWZjNHlHYkpUUU90NjQwRmdPR1JvL2FNS3JI?=
 =?utf-8?B?MFZ3TjR0R2RUZ0ppeUk4U1czRkZHZkRNV2xFTEJyNFh4aTNIankvbDFCcS9a?=
 =?utf-8?B?UVFKa00zSks4S0EzZERheWlkTXp5amZKM3ZuU3dzRnZVVkk3R202ZWw2TnZH?=
 =?utf-8?B?UU50bGRPMFFyL2NvUEJ5NjJUWU9hQzlBNWFHWHNzazQ2T3VIZjZtZW04T1pY?=
 =?utf-8?B?Qm9lcDRjYUNjdmx5bUZOanlvaTR3NmZnSW02OVhiOW1STEk4WjVzQnlaa1dR?=
 =?utf-8?B?U0RhQ21qb0lHUGdFdllic0tYQkM3K1ZwdEFvaTNBbkV5UlNlY21rSDFrNEp3?=
 =?utf-8?B?Tmwvd2t6eGtWQnVPcHRaRjluYzFuS04wQkdLZEMzaWFQY3VOTkxRMlJPRTVW?=
 =?utf-8?B?TE9MemtPQmoycUlMcm9qOGJpa0NJUThhWi9RNFZidXN0Q3AvOEYyRFdtemRQ?=
 =?utf-8?B?U01QNUV6eVQ1ZWJUZ3BuVmd5bGo2RWpPWGx1dkQxZ0k3YVRVSDdkUlNKQ1d1?=
 =?utf-8?B?SktZczZROGVlTnNvSkxmdlg2aUUxU1dIQkx6QkhyM0g1L3ZQdnFnZzlkMlV2?=
 =?utf-8?B?WUN0dDBlcnlZV1RUOFYySVo2MXlUd0tVdC9mMWJsSUZyemFxTjNTZWZNMy9J?=
 =?utf-8?B?bG1vc1BVS3pIb3UybTVDK3VXS291dVhwZEZneVJKYnBabXhHYnVMd3hPNDVM?=
 =?utf-8?B?S25xZTVvYmphZXVZdXN4MEZhc2RUUEw3N1RxVzkvR3hsNVhUMDdMY05iN3U3?=
 =?utf-8?B?WmxoZW9HUzA5dm1lbHNpQ3h1alo3UXlEYzFqMU5meHlxRVdjelFBZEdpV0t2?=
 =?utf-8?B?OG80NUJYbEgrbnNXM0xacEQ2Z2g2VlhsMU9Xck5nZXpFd0wzVXc0VEhta1BW?=
 =?utf-8?B?ejEzbnhBZko4QUdTK0hhSENyZzBBU1FQbHdlelVmRFhlSndlSkpKWWc5TWpr?=
 =?utf-8?B?M2RieU9BSjIwVkVwc0NqMys5Y2ZhK2w3bzA0SnltTVFIbjY3SE9wc3JBVkxF?=
 =?utf-8?B?M3M5NnZ2M2RoTmdHekpwNzFTTlR1U0F1am9PYU1lRy9IUkRRUzBpYXlVYmxW?=
 =?utf-8?B?ZzdtVk5yQUUxUm1VWE96NXMwNS9UYkZpZTJ0UTJZUGs0d0t4NUoyckxkeVRv?=
 =?utf-8?B?WUg5RmtXRVp3RFdoQVR4ai9uVzUydmRWcHZKOXlsY2t0ZE82a2d0R3Y1c0RW?=
 =?utf-8?B?RWJVM3doOUZrL0VQZDFZengxZEhhRURLVFlLMzZWVGowZ0JRcVAxdlZHd004?=
 =?utf-8?B?eVV3ZE15UmNWdGRDTjc2UlY4TW5Gbk5SbkJmQ2I1YWR0M3prZmRab3I4VUxE?=
 =?utf-8?B?VS9FM0pWMEI1dDUraDhkNGN1Q3ZlZEhWQXlkZkNzR05PNVVLRzJTejFpOHJw?=
 =?utf-8?B?M2YwWk94SHlOWFZSYUJCL2ZqL2JZbTBTUEJtOWsvZTluNVhWYmFjZzc5M0F0?=
 =?utf-8?B?WmJ2NTdTTlBvN09FUlMzQ2lBSXphYzZVMjNNQm1rSlpGQm1ob3I5bjBKdFRv?=
 =?utf-8?B?UHp6YUJPbVlncTk5dmMwanFMZkhzQkNHekx3V0dtK1ZRR1FKMUR0UVZVRzRv?=
 =?utf-8?B?V29YdDZsRmVmODNJYUZUTkRqUTI2WUc5K09LdzlJWHA0c1lISmQ0ZUw5S2RS?=
 =?utf-8?B?NVp2eVJ5VW5EaHdCSkw0VXBBdytpUldva0psY29vQUkwek40cEpTeGx5b0hM?=
 =?utf-8?B?TUo2emtubWJUNkFMZFpoOFh5YndWU01wR3l3ZDFqRDIydGkrNkFCOU02dEVH?=
 =?utf-8?B?OTM3NnFPNmZNc3JrZWxoelpqRWxneGkwN3FXenNMNmcrYUFrZkRLZUZQdDM4?=
 =?utf-8?B?UTRqSUU5SXZ0d0EzcFJBNGlkTm0rdFpJUTJTVjNoV0hzOUJtc3I4NEJZcUZK?=
 =?utf-8?B?YWZLeVJHQ25QNi9XL2ZOMVJDVWxoaUkxSmZTUU5wNGRpakdSZXJsT1pBbWdG?=
 =?utf-8?B?TkdXcklORnRTRHNTR1hIODlLWVRjc1J4WGNaVENYZ3d3NkdGWTZiSHhRUHZ5?=
 =?utf-8?B?cUg3cUFpbTlOUDBpcmw3Y2Z4R01QcFc1UDBLZUl5R0ZXTkpRanR5QU1COEtt?=
 =?utf-8?B?SG9oMjFBTVBwMDZ2WXZMWm9aUDdPWmUxUzIwWHBUTXpUWHgva2dzTVhJZU4w?=
 =?utf-8?B?N1hxaVFsZUVsWWFyeFVicU5vTGNGRFh1M2JTMXRiMXpVNWlOSXdKUWRvcklr?=
 =?utf-8?Q?z2yGdLTcPMbExLOBWAUxdTIE4qny5LYk+yDnzue2fSvIP?=
X-MS-Exchange-AntiSpam-MessageData-1: CeuHVW1Dh+flBrwmXnsSwW///FtTSvImdKA=
X-Exchange-RoutingPolicyChecked:
	aMNi5muNOOkdrVtwjbRh6bWGa7xSjtbuj4IX5X3r3ai/aM8KS6LoAQYDGDvFTQXjF5mbsfNHEV8dUO2hm+64YkpoQExQWJC65GNTkALy7ncsjDSKZmqGK6L+GXs9QBfW+MVzMelD+cJJD2aHq5XgLRTqIaFgbKWl3RL+2Q2su11oek0i3Z8hiCOfhv57knVbfRSivwbPgFCcftzQPzZORqarWNTXW+v4xujkNOj5EnSI26fyporzskXwETa3hg4vtuX5wbL/TzA4aGwmLhLApmnZxH+FTaTj4Qs7jNLKyoxRi55fka3YS8+8waBBjh4mUbzJD8wuuBJ4J92/tlPPgg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DZ0cX+yMNdLBfejsVjlsOv/FidZC24XtgmoFscdAoocejr9I9kQxavnzYqNkKCL4bZe7548ZMMNNeYs9pog3sB8iZvFyVF6OzHdqOrmXxPOYOxJ+7C66fQOo04abmjRmFWVzGLhHfajE0ST2KE2CranQ1AeVFmP9HyV7uHw2JXxbgB03XvC8kLrQTj31ZZy3rQL/5KveebWmPyg+4/GG2QSMCVK6V8vAdLdSWXREkwWhvaeq/0EyAkrIixXyq0mdro1H88yeVkhJNUXwjspA94t5O1pimyp3yy9pwwwRxA//VXvOeZ36HECwpHqtR4DlcgtSZYxG1E/W1KZP4Fxfw/6SdLkK4RMY4knfPoWM9qdi3XAl/B3ZM+Uk5CjHAoChRrClnam7nO43mRewcWrxSGh4cNFk27NRGVSMIuwMnriMNB78LRPGYmiZqQXZ7NsVnG1B1xhiLarEMWMAHJgE3MwfUZKgMAekeDN94tLYu1hZJXB/e4jDonACeGkp4E85M+zMxTQVi2mLnPBdIS1FU/Y+O0inh9+Vg7Xo6Djpi2ZSM2p6wQ97YCEaSRfBxRSR95zDhTUMGqZH5Lyh/9aBxIDbiupLV09ULIqtvRg88NqSEmL/L1CmL7QY1eGxRhyR
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34db1643-44d1-4aa9-b32b-08df43af30c0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 06:59:42.8077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wH0aVrcCnGkaVC/TfyqNcmONQsDwqlpsbThK3lHUAjy2aoGskpk3eIqHNWBVBOVPzNbeQVMZlacyet5mDPG1xccr6ck8blYfH/sMQwFXYSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7322

On 11/13/26 6:13 PM, Jochen Philipp wrote:
> Hi all,
>
> results of the larger write test with Dongjiang's
> zoned-fixes-testing branch (7.4.0-rc1-zhu+, untainted):
>
> - ~2.3 TB written via rsync in ~3 hours (~200 MB/s), fs now
>    holds 6.7 TB total (the first abort back in October happened
>    at ~4.3 TB written)
> - no btrfs messages at all during the run
> - closed zones: still 5 after the run (124 before the first
>    mount with this branch, 128 on the broken fs)
> - clean unmount, no "unable to release extent buffer" warnings
> - btrfs check --readonly: no error found
> - mounted again, stays rw
>
> So for me the series fixes both the broken on-disk state and the
> problem itself. If it helps, feel free to add:
>
> Tested-by: Jochen Philipp <a2jphilipp@gmail.com>
>
> Johannes, I'm happy to test your patches as well once they're
> out.

This sound very good.  Martin, can you also test Dongjiang's patches?

Dongjiang can you resend the patches in your branch?


