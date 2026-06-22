Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7288735B646
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 09:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782118899; cv=fail; b=VdWHghc5mceJYsomw0zOrz7P6seXfERalwBwegSOH/1ceeqpkSLUW6esSDV0RTKuXohxz9GHv5xiES1ne60M5Y8npIN+MXGAkjNcXLPTxGco5VoyD8/j1UPIiBkEaLu0usSM1yDKxPg6BMf7qYDrls9IfLlffdh67LPrv0pfnFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782118899; c=relaxed/simple;
	bh=UtWgNtCY98B7CwBdmPHFKlXOyuJTNHjxtDGmbiuXDUY=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CV+SfUOsqIs5VqpiPpSPQA1+6alHnT7OtwfZUxjYQNWaHNuXSkZxzn03BJ1zJf4BDtV8XFCwSUN8Ss/hELPF6GKmCI6lcS3AhdqPAXXjEUqJYS6BMIp5t6fnM0oGSYa2ML5MAzFFkKGejN1dCpjhvnihINqi1y9ofYL/4xWrffI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=n2v0zw/G; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ljbm6Nef; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="n2v0zw/G";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ljbm6Nef"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1782118898; x=1813654898;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=UtWgNtCY98B7CwBdmPHFKlXOyuJTNHjxtDGmbiuXDUY=;
  b=n2v0zw/G0qAUsPf8UqYgh4o2GWb5A+pFEXovMYgekS5BValp/sKm0B+I
   RL8fnOPGEnyp/VNA6l1qmComgD/2r36cpvhxp0aYw6EjoiRMp1rudN7Gz
   fbr393gJtVb5+4ccXSWrsk6FrXvT4TdW3y+77Q7m9ar6M43v5JpffCme+
   MZk42/2XYnL0uFr1CVfJyT+Fy7SboAmlkiDQkbXf9vQiDHzYWYHSSNN8N
   rPO2AvUv5qTOIYb88tnZnVsDZKoz+NKHfOjfrg9c6xCx7OBXca8cvMVhx
   iZW22KfQjW/qR7g3VFBCtBCjX7PJP6tWmNPshG0JNAuUZD+nYYPLUpzP6
   Q==;
X-CSE-ConnectionGUID: RpMaSBC/RN6BnbvhBoe0Lw==
X-CSE-MsgGUID: 6j7gwIXyRj6LHJaOvyCJtw==
X-IronPort-AV: E=Sophos;i="6.24,218,1774281600"; 
   d="scan'208";a="145451563"
Received: from mail-southcentralusazon11011013.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.13])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jun 2026 17:01:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EpByepnDM1ATAoI6GkwSgiESsc6rOqp90FeB4b0fx4+053yOUhapufgPimM7YZgbpLKOCfL73x7JPrtdDcEZb4db4DAuHKgWj16nYtt6DbhOnzhXEZeYV7A/aQJlJpPS8K5krAZEKnyD25Q2JFQDD9PiF1ltiIyMlsAyXHoGQ/ZWd+zRky6p6wiOST8rkx6w+taxN2otkBB9Rmep4hX7hwq3hmt2Rp6qzHskUdzerSmd8wGSZicmNPRodKDuSkvGgF17qjdhwlIwTIaCxPJihIxj4Sy5CxQQucj6D/RT03GXJV82K46j33YLjIxCJLn6mlO44WtnsPAP4mCWl8qVHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMK7wrYJ9h7+SU1uc+/hiASOEEjxVt76YLbcJG2NF1I=;
 b=seuSafDU7gSauFbRj2EpqkrwrNTGCQhp5rctydt0quhSD59hgcdVlz0vrImDGXjV0dExMjwTU37a02Xoksc37rei6rZNwZtou2QP29R475u4t6W2vCCwrVJPciOt4mupzuQpuXFhj5HeKee/OE/ls6Lv5pxApReEq6AYrwa2pYaOj7aHV4nrq8EtVxUzwNsaN7zMNIQP8aOZ5CIqP3ZUjreRlbYHEsFkeOW9MN9irs8J/ZWCOBnscPscBPRQhESBXhz3oX8De3c834Ync550NYdgSSOmSxGN/s9bmwmmZFGendE2ypVufmjRCqlV11zvF11fTnIBgSPgzUe16qJTZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMK7wrYJ9h7+SU1uc+/hiASOEEjxVt76YLbcJG2NF1I=;
 b=ljbm6Nef1M0CgShnNCxtXBP4e3Chr5CiEVw3tBNGvN+J9y612jQf+XGMVnItnOWCN8RmuiTW2oTj+10e4AQpCN032XrcD7reO4jdMVtQPGVdf/YQzKdxVxnSaH9VUaK5O/KtTgzADO2oEld7UQOyL6dakbt0QFB6OkCAqp6ouwg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MW4PR04MB7170.namprd04.prod.outlook.com (2603:10b6:303:74::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Mon, 22 Jun
 2026 09:01:30 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0139.009; Mon, 22 Jun 2026
 09:01:29 +0000
Message-ID: <63ce1669-7864-4d1f-a236-b6d24a571766@wdc.com>
Date: Mon, 22 Jun 2026 11:01:24 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/15] btrfs: RAID5 with RAID stripe-tree (zoned +
 non-zoned)
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
 <3b98816a-7115-48ec-adb3-27282e54af26@gmx.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <3b98816a-7115-48ec-adb3-27282e54af26@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0435.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MW4PR04MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: f53f0eae-c0eb-45a3-df43-08ded03cd8f0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|19092799006|366016|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	dYTuwSeUEUr80xQARqtxe3+77nrwV3iLaat9OctmiHCBqwkJr+0TfM3dpL9nOrQgvRAWEcyBAxTSH5CKapfHP9IZzdjNLUQtGrZf4o6FV/xYE0vV6pPNxWLF0NvO3j+RxyR/EEBCwa7gZmxsi790kc2AbhWB1wFUUFvhvSdKwt1GuEjLM58Bx6Ce6YS5HvOJS9foOJYhb7avf1fXIxjHMOTH+0VaDKY3Ncq//GlKQSjVl6P7HTgEGfvocVSa1stXSjFS5hv5p3zA7DP0GSWLfoScjZcNAhPtaHtj7wWuA/JW3VfYync5Z+XdRduULcQJaS3NcEmQDbTZxur5sIAx3rpLEsmcjjrYtGd1LuzwIqUAzOkrF5VSDmeWIai0rYMcE+xf/h11KtKQubbx4THnA8h7y1GKqKxvUkCvgGHMAZcYakCj8XR/YNTJht4AXyF3UmKwD6taXcacIYBrLOEH4vV0F63sD3UYpkt3lz7FV13I8H5zXUhRbF5LgIAPOCp4+3y7MfhJG16+12jqwHeqW0sI48XbWww2EXd8F3dOPuGFWiozecFE5nllDvh4Ag5yxxRXENuavRe36u9qUjcwMNcIfxSdMGp4REs7B0V2O4VbGZN7MPMMmp5lQZG5ItdXi4A+fc6+OeSDeVgX+Q9gEzJNY2E0CjSi/DE2B5NBO2A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(19092799006)(366016)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aE9RZXNGOVFrZWp1dWFhc0RJRHJrdjRYT0ljdWx1aEYzNVJxS1RJYVRhdjVH?=
 =?utf-8?B?cXJUNXN2UStrdVJYeTRMdERpQWtob241WDk1ZkdRK3VmUzVEZmxqRm9JTlcw?=
 =?utf-8?B?TGtlbDYxdkdBQUpGU1d2OW1Mb2R1UnJzdlJCOVNVZ0x1RHFNY0JsYk44MEcz?=
 =?utf-8?B?WFEzcHNNTG96Nk5aTzNoNG12RjhDcWFUWFhmeHprNmxOeWF4T2tDTTJwVmhL?=
 =?utf-8?B?MVhXWm5JYS9ETU84YjFyMk5udk9HQWRMcUxkM3lYL1k2QVVSVXUwN3diRXBO?=
 =?utf-8?B?Z29KYU5jZytyMjFYVFBZSGlSSnl1YU1jMGVLa2ZEUy9rSEtHRG42TnBMZ05Q?=
 =?utf-8?B?UXZoU2ZNOUYrSkdsSjJvV2F0cmx6REhLcjlWYy9qUG5MQVVOS0FDS1hJUHE1?=
 =?utf-8?B?c3hiTmRsMDJNYjFqMzYxcnhRVm5ZeCtCd1k3R3UwdlBnM0xYeHpwNUN2dU1J?=
 =?utf-8?B?QmxldTlCNEM4VzVJWjRkTWxSMW5qNGFTN0xpU1B5RG42UnpZMWp3TVhUQmRp?=
 =?utf-8?B?a0VEcnZuazlIcGcwZDhpRUZ1cUN4THdwQWUvMnpDdmswN1NqMjF1U3JaU0hU?=
 =?utf-8?B?cVhQRkNSYTAwbnE5SUx3cVk4ZHVpNE5YWkg1QlcyY3gzQmpqbXYyQUhvT1FH?=
 =?utf-8?B?aTBCUHkxK2wraGFYTmI3SE5xWEJVOHFCNGxqQ21ucWc0dEVJWHJ2MkRPTyth?=
 =?utf-8?B?Wno0djBtR0FrWlRvclRaUkI3cUIwRnZPUGJOTERKZDhmV1pMS2VMRFdkai9S?=
 =?utf-8?B?MVoycmlFbW85a09CTHp0aTY2ZU1CUDdUUkt2QnpxbkYyR3c2YXNKUE8wOUZW?=
 =?utf-8?B?WGgrTHpCRDA5bU5EaUp2MVJGeFJwT0IwaERFQnV5c2tGQk1aN28ydFNUWTVw?=
 =?utf-8?B?d1gwU2k5QjdxNzYxeTNLVXVBM3dGWjlvZkE2RGM1dHBXVy9zcHZ3NkJxZG5z?=
 =?utf-8?B?UXFZV2t3WHNua1p4MEg0UHRNSGhLNEZiMmFydDFINWZudkJZYmpQeG1aVEVW?=
 =?utf-8?B?Z0Uxd0NqbnAvdU14cUNqcG54cERhejhNWkFybVdsUTBQdVdvQnMwWllPOHJF?=
 =?utf-8?B?Y2ZVbk5uUUJyYUdXNjhBRkZibDJnNXRxSjNUNk02TC8zOTQrcHdET0x5RFhk?=
 =?utf-8?B?YWx0Mlc3M1ZqN1JiNlBKYTF2c0ZleGxJMFd3RitFYzJSaElVbWpySW1QQnIw?=
 =?utf-8?B?amt2bEVMUzdvL25UQ0VDM0pkU3JvUFh0ZjFvTDFwZjJMZC9aOTRaa0lVeW4w?=
 =?utf-8?B?ZmtXTXNiczI2T1o4SDBjSkkzNW8yUlRkTkR0emZUNjlKaWR1RFpOZW53V0pp?=
 =?utf-8?B?NXZQTnZNdGR0dkxtWXh2LzhISXZ6RnM3d3V0OGRnblAyVytieHFrSkYyUElN?=
 =?utf-8?B?b3BPS0crTGlRQmR0L0lyb3pDd2swRGZxNzROU2NpL0JmRGFNY2tQYWd1a1NE?=
 =?utf-8?B?SHF0QTV6ME1LK1ZkaWVBVG1KUEhFSjF5RVIyaU5ZdXRyeVV2RCswK2NpcGg2?=
 =?utf-8?B?TzFiR2U3c1g0N2RUc0QvOUZtUTNuYVQrRFBLbnJ0U2JFcHczQ0JYQlNkb1B4?=
 =?utf-8?B?RUJYOWd0UHhqZ0xFZEVMQy9UZWxLSGtQVzBETW5wU2tGR1JNcGhIQkxHWW1p?=
 =?utf-8?B?U1ZhcEJZMmtDM0hmUEZpcThVZEVpZ1kwMTk5RnFGeGNxQ1RIUzVLeUN2c25z?=
 =?utf-8?B?SVg4Tm54NUVQY3FlSzlSUWRGUm9SejU4aCtzRFNRQ0xKbXZIeWxwNEZVd0ZY?=
 =?utf-8?B?UTdRemY3LzRkWDc3TXA3YldjQVRZdFZweExaZ1g5QkhpTmV4Y3lBdHFsNDhQ?=
 =?utf-8?B?QVpjVG9vTjhLWFdVcC9zUldMMzBERGp0S0R2OXBJbzdDNUFnSVFQZ2p6R2lM?=
 =?utf-8?B?NitLNHdBY3p2K0dYcHUyTUQ0MHpkWStHQjgxSFhqRk96QmFiZCt2MWYwVVlW?=
 =?utf-8?B?Qk9RbXBwWVc5MUlMdUo2Rk1iRnhSeEZrTWpuT3p4VURzU0RYS0RBM3E1a3dX?=
 =?utf-8?B?NGxEQTIrKzVmbnc5Y04wbjZ3dWZ0K1BoR2RXWUlVKzd6ZlpBWlRpVzBPb0kw?=
 =?utf-8?B?VFQ0c2J5Nkw5a0czQUpsMlA2M2FtSUIzMEFDeDIzN3VFY1Mvb3Q3QnBNQ0xN?=
 =?utf-8?B?L2JiVWswTHcza3Z0U1F1Wm1OTmpHckZIcmtld2hHekREOGdrUHVKOFQvSkJn?=
 =?utf-8?B?NVA5REhOQzN2MFVlRVRFN2hQMU9HSXU5M2dzaU5LRmhOQzRhVUFBQkNEMk5Y?=
 =?utf-8?B?ZUpaZTJhNzRMRldXMFhxNVN4Si8xd1JQTmwzK1FqWkh6SUd5S2NHS0xZZVJS?=
 =?utf-8?B?eTZ3dmVYVmYxMjQ5cFNGZnNGZExrenlEYVhCb29KV2FaR1RlaFhFV1l0RTZC?=
 =?utf-8?Q?QjXkXR8SZR28sSnU=3D?=
X-Exchange-RoutingPolicyChecked:
	py5FMTcM7DH3JaFrObGPcgS4B//ytasg4+Aypsl0SA4rij55G/t0sJJw3aaAaYFpF9FitUc66Esl4zs9+QhA+YQ5ee4EayqPj0IqNVFk3cvaDvYosP9Bz61yomjs/9KaSTGu9TdGgsSWOPTzcf6SY2wI6ShVf21qSr1vXU4nJdVG7jnQSdTzhCv1ezOftqWRSV9c7AStbXMlY+UKpbdJTHtpyWlc7fQSYYtKDx6q6zcpaykYPsizS1vkT/DDMsELpeR35C2M6An219xwd5qlJBWa6SclLSmVGgk9LUY2QmlcUOXwsI1Y8vdrIFXGa6v0/gr7FzbeaDHeCIWump3o9A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eBWvNSa4dCThdtbyEvee9gk5lDJlOm8dnFxRQUQgyyo3znUDjkQ6ZHGymevpl13TbbWDwz+kBKk1Vm+BjPLj1je9MHCPL6vR9ItdsRITJ7hTs/o/lX8LuDVV1WKipDYTCkjSztLk4mcUd2j4XeHgIk5mM26VF7vJfXSv06FGPnR6UREgYXvG0kJ/cNwSxH64VpD0eq3IvEsy3BFCr8bMLOKsg05lJH0+sNjRr14B26hp9aN1twGjcuYZKOcuwgcD1ZGiI7aFjZuyxWHgc94vQfBhsNjth++obo6X/aWTIZJxOBcMaKd2F+ze9IfiZE6yVNeVupnA5o8Uf0khgU77W24fXtz+mnalYHTmgaV13DxvjkW1h1f+vzD1fZ2YgpMxnQLCRgxHCrgNz06YLLA3vKwE7JdLeGrsxIMdPoZBUowGgsLtsE2Vw4Eo0MHSzYGSqMRalXObVx7vMY4Pb8rlGSBDVQrvaAeI7ekjkwfxp14byxAx+0yJ1HPFQeeGMg7UjpG8tkW4ioQxuv5mDfghZxM1JZRkVurZ30Jbv6Rh6W7JznIY9Wn8LIHIadrpZZxFBFdGL7SUER7etYg1b5kpWSat0YRCuUkAaLw7VG50cbJ7f3e1rQBwPLYEP9C+Xgo7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f53f0eae-c0eb-45a3-df43-08ded03cd8f0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 09:01:29.1806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VP+hE5zgqyvz6p0fUlczciiwoPTD1GzHDcIX6NoV0JgWWPjHRygr2W/GGhgfcRT2+WIhwqxTIkHPP89gEoimt7dC7BfwXdGNQ6u6MLVYB5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7170

On 6/21/26 1:35 AM, Qu Wenruo wrote:
>
> And that in theory removes the need for RAID56 rotation, or the need 
> to have a fixed stripe length.
>
> One of the reason that RAID56 needs rotation is to avoid sub-stripe 
> writes causing too much workload for the P/Q stripe, but since we 
> never over-write in this case, we can even skip the rotation part.
>
> Without rotation, it can further improve partial writes, mentioned below.
[...]
>
> One thing I'm not sure if, do the RAID56 RST still requires the 
> existing 64K stripe len.
>
> E.g. if there is a partial tail that is nr_data * blocksize aligned, 
> but not reaching full nr_data * 64K.
>
> In that case, we can just map that partial write into all devices 
> without extra padding, aka variable stripe length.
[...]
>
> Then limit the RAID56 chunk allocator to always allocate power-of-2 
> number of data devices.
>
> This completely removes the need of partial stripe handling. 
No we can definitively do that. We could also ditch the RAID5 rotation 
(as you said) and go to a RAID4 style parity device (or more for higher 
order parities).
