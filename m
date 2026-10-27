Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793096846;
	b=uf467sbOzRRcYn0DEMaAGbXk0PKwvFzg7scsx7Uf9qcEj5zYtAEmg8KEQGnkpKqNhXCR
	 927YJ0K5hJCKybyOx/PpGUVAfpt/C80wSA38zYk8pJ8yTBpDc1N4xCmS5FTN68CfpmtSW
	 8gj1uPsSbKQZCGmIWmEtysYNIlPwIXklKDgsfDA7UlkWTXS6Md8nIk1k7D32y3vrxhq5h
	 HPSk/+un3KtJ6qEBjMECGx/hL9OHrfOgZmrS5D35cwst/S0Ftaui3BYLinYtgiv4Pn56G
	 RJxyAMNNVGd/nZNZPoyELAdosPG3PEKh/q9KewQXNfas1WWGleN5lc10zRBeHNjX53g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793096846;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Content-Type:
	 Message-ID:Date:User-Agent:Subject:To:References:Content-Language:
	 From:In-Reply-To:X-ClientProxiedBy:MIME-Version:
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
	bh=ZvI5E4UP809rl5ujgXBrwXYgESRZQAls8wA3MDab+tU=;
	b=isWxVdHs/WEU3LzZgkftUvV19AdVU0eqj51mDfLHw7R+0RYU1DAayPbNYkQHkyOuXF94
	 jcxcFSHWHUp7iMTqHvgq5HPuyxRL8i2/ROCpnNx2Q8bPijHrNuBHR6iFfkP/IJRgYFWMH
	 xje6zSg0zWtrlXndNO80K2FcqGEz2V3mFqc4neTzKQc47rj5qzf8oqGcjfUu73CJo4895
	 21XN/8sQ4N2EIBebExk3toYQnbWnBEYVZIDAd6INliHoLKYLiFh9CbnAqXXK7B3fXbm7v
	 SRxvz7cOt9j1zwP2+Lz/s4K0c3gEVIyVAlHhTel8w5Tp23MsoCzxY23Dj0xIKPCrfOg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Bnlj37Qd;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="hYeS35/A";
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BADF606A31A;
	Tue, 27 Oct 2026 10:27:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BADF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Bnlj37Qd;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=hYeS35/A
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793096845; x=1824632845;
  h=message-id:date:subject:to:references:from:in-reply-to:
   mime-version;
  bh=KtVWywInVEPlrldvcAgyNCpa7fWz0uvwazRacVOZL3A=;
  b=Bnlj37Qd6FHt+pYS02eCQfRTrDj5QB9mQesLqjD+tH8cOyqikiBgb9tX
   VcAagDnPqMgppU0gg4lBYSD6zQxqTtRwIy3DCtDr4/TFGg/Jdzzna5p+o
   3GxgO4xuIPzpFgF49tHZI7dXLcOT4t9GdjRFIXYjgjesvUR8T/xN/7lie
   yeVtNFRQxfdp4Aw5ill7tcWtVKcBiv9IURw4GPiD4Tt/9fkZQyYfsziob
   Ik5BER7pXTKJZuYuXv0nkDDM5u6JTV15dzxaqjLaEKIaosxeWa6Z8UBt+
   ZGjYUYhtHzYBDi1FY+5kZe8myAnsjNrwSFO0sH+aVbfbq53TiuSpYxpx/
   Q==;
X-CSE-ConnectionGUID: 6sJJqhJDQD6OEMogrhofeA==
X-CSE-MsgGUID: cd1/TATTS4CFFqLfyONanQ==
X-IronPort-AV: E=Sophos;i="6.27,181,1786982400"; 
   d="scan'208,223";a="160060659"
Received: from mail-westus2azon11010031.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 18:27:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Md762Y5efasedvWPN4aOmN25wUA0bXUn6WmfqWy1NHNgqFw0Je1gg4o6xLgNDZfzACRIoNlCyKhRcB8sguWy1aP8oR4GxogCZVPuSUbfSwVh8qbmJUKrRlcAsOH6nmV25ynBUjTEqGCmVr5bOwDuQH0yPBvSZV+SxiKLexV+noLnb7LWfWWhz1CGlUFG8qFxwb3G3tX1VOEKg1KezcRbGdu7axnY+7e4C8uHKN2dn8jKtw9NqFqOOMpfXwwH7xRBc5kWhH5ZtcFxtRrgWRGFgbSCKD6obknEd1RBHek5JdwPgPY4aXsO9parOMY4QN17lL/x0cXuKBLM5vpS0C7mRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZvI5E4UP809rl5ujgXBrwXYgESRZQAls8wA3MDab+tU=;
 b=DhpNe/06bqA+WFtWDw5fqEkjCYebqtW0bJhmpKfpUl3RC7fmfrmm+M5RJ27ceLTcZTqyG43ZvA7fTcb8ryPSOUV4OP3g8LdpwA2tknoRba5lo0NauwnVmWzZvTP1fZtbNAuy69uqWIJX15dSwRqzFruKr2CeXsv2BwlO60hDc2fXnBgQJ4EyGRjiLmpCmdj1NZrDbss3pfRuOQgxYYhaMFDYyLnfA6QJGla24pjFkSE5I6dBgNC6eWr/01h8uNvwBfsLI0DFr4Qlr6B5BmLan+tyfSnzS2MJJlpaLcB72qiAnUgNSesAz8nCqxHnobikeKA1AzypDRv/1cwxE2Gpvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZvI5E4UP809rl5ujgXBrwXYgESRZQAls8wA3MDab+tU=;
 b=hYeS35/AwDCg9rAfQCrfx602PjTgvybuYzaDAuKK6Kot6uHRn+GFk1lDCy92yNVAH5GSoFbVrmxGcrbvEP0XSd4O8wAID2Z5HvKerXE0uKTX9ErzE5V62KR/AGHR2Ox+PIDLRSbRF6lfrABs87niGu4Utn9vI9SKlVnN93OeCo8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CY5PR04MB994137.namprd04.prod.outlook.com (2603:10b6:930:12c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 10:27:18 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 10:27:17 +0000
Content-Type: multipart/mixed; boundary="------------oo70T0IKPyYp2UZG1fSrl0Tv"
Message-ID: <52925d79-4dce-4621-b9e1-fd062b47e35d@wdc.com>
Date: Tue, 27 Oct 2026 11:27:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] btrfs: zoned: reset stale zones in unallocated device space
To: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>,
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAEmTpZGu5x9PS7vFwgc_dFH80rL3cFD4-geuuL_w8i=vFDo8AA@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAEmTpZGu5x9PS7vFwgc_dFH80rL3cFD4-geuuL_w8i=vFDo8AA@mail.gmail.com>
X-ClientProxiedBy: FR2P281CA0114.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::6) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CY5PR04MB994137:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f1008ee-e327-44a1-4479-08df3414e060
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|6049299003|1800799024|23010399003|376014|366016|4053099003|261026140227099003|11063799006|56012099006|261026121527099003|261022105027099003|261009223027099003|261021121427099003|261022075727099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	mrIlESXMd39oHyhXyA7eAx9v5+zU/L35sbojNph4AH4nIqA0WjNWYv/jBWblYLsrC8NOQ/sBdcwTK36ZhXudtBuRJQncqRhS9EK+GDnFL++Tv7OvwP4WGnhcubGSA9HTldZM7V/zHvOhXDzKPIkhDK5jxsMXXYpN0DfrgMBpAEISF4Z/jksQiBGVRmIEORP+ILSQW7b1WGzFLrYswNOg93PxQaOsKR9KZbhsdgOSoWxawSZIbWojN3ZCSCFT9Zpv4BJRZriMFKA6HFqqqCFi4cawCzdEd4oAYldVjq1MjoCZqg78b+4nGIg+EBb7I8gd3uELpVAlu4GEwndJ0xdVBp8v6xBWhMUmb0Xzl4NdtiEZzlFNNsFpzPqYebhNgJMbdSOFXUedxcuewyYCbFCfm7PCMbprC1H+u29nQq1NFH7p6vlqcuMc0tOiKMCKceCyh9HjTsjyHOZMlKq+e044xuq8LflPVo1Ha4NEz2+5OxNF+yVA5LrxuI/RJ2OATTlb2/8mDnntaTCvaU9ryPcpoozWqjnfhXBjqMYA0OeZOjXiR+R3akyfHtQm1KK3z99BErnZuvu6OA4rkmpYqFC7SyoqSOVwqn6Ue2WPPx5P8LdWtL+SbG6SWGFe2wyARxYr/ksafF4sZY7GdJx1Sj5zI/s83/rWkuF/enHXj4LPCPw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(6049299003)(1800799024)(23010399003)(376014)(366016)(4053099003)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261022105027099003)(261009223027099003)(261021121427099003)(261022075727099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bzMwOW5mdXAxVnBURWVEdGtHN2dTcEkzSEMvVmJZSnJqdm9BVkFIbXBCdytn?=
 =?utf-8?B?M0hvUkhudGd1NHdVdlBTcEhTN0JaZHFWVThzRm9KMDUrWis4OWh0VnE0OXVy?=
 =?utf-8?B?QkNqRTh4MjRQaG13SDBCYVpOQVBwSlZ3UzBDTmdNSmtTS05WTFNnalJ2UFgw?=
 =?utf-8?B?eDFMSk9sVDhyL1N5Q3lhcWJMS00zdmp1a0FGdk1YRUcxMmdvb005UWtMaGRk?=
 =?utf-8?B?dmZvY3NsVVFlbGJKaktVOGlXTEpMVjQ5bjdvaTk3bUZVcjdjSjFyb1VBcWF1?=
 =?utf-8?B?UHFZS2h1VWgvRlF5bCtva0xsdDJIK1g4NjZ4Wll4MVp4WXdMbW5WMVRsbzdQ?=
 =?utf-8?B?bk9VM3RmQVFaZmkvMXczakVabzFodldnTW0zOXJnZjVoU3ErMElMTXVzRTZl?=
 =?utf-8?B?dlVjNVZzcFVNajBPR2hVQ2ZFUGZCS1VLbmtPTGJleHM1bzNDRWRZY005SEkx?=
 =?utf-8?B?cUxXOFhac2lWb3NpVlM1T3g4WFdNN1FobmczOExkcnRWd2ZzaWlKVmczakpQ?=
 =?utf-8?B?SUh0QWJCZ0NMN3dFYjZNZC85aERCc28wNWdsdStWWlJqSDdwR3VFNmJxSHBE?=
 =?utf-8?B?aWZ0dWhuekJpbXRNSi9rR1JmZUtkY0owa2pPQ2pXbi92MUNXbCtBcW93WDFh?=
 =?utf-8?B?N2o1QVBpZXJaR1NLRHRsdmJWTFR4dnJyTGJqNjNyVHV5Tys2UGFxbzdZQlpu?=
 =?utf-8?B?OTB4bVZybnZJQVN0UHpDMXlNQk1qa0RpZ1lqSlgvcHJZRjhSMDB6NG50Wk1E?=
 =?utf-8?B?U3FUcHBnSHRCL20rYVlLK3l1OFlqUlB3bnVUUVNORjdOQnhHOVJweUZSNXdr?=
 =?utf-8?B?cEx6SittbXUzMnV2aTROL0xqL25vNTFMWEN1Ymxpci81c29sdkhqVmFzQ0Rw?=
 =?utf-8?B?b1hadVNQNjl0Yjg1Y0V2RE9PcVkwejdMRjdTV1Y0ZWhZR1BVNC9CdDA5bHhK?=
 =?utf-8?B?ZmdVZ05YNldFM1FlUEZhdHJyd1ZxaFAxUDJ6S0JBYjlSTW1oTUlwN0NQTGMy?=
 =?utf-8?B?bHZRNFRsZUY0b0N6M2FoNFkvbEZUOUlhampCdWh6cm9QVVYzNiszNjZrRDVp?=
 =?utf-8?B?ZE1SblBMOWdPWHFqTExRUkN5bThEUnY3NzlwR0FsdXZjemIwdDdwUWVXVkl3?=
 =?utf-8?B?MWVQRDNUN3gzRC83NmFyVnZDSUdjVzRIcWt1aXNuSk9FcVFyTlF4TTJBVzNj?=
 =?utf-8?B?ZVhPc3UvMFprc2tVUmxpcUZaekRuWlV1RVhOV0RibUtqY1dJai9FTkZvbGVX?=
 =?utf-8?B?UTZyd1cxRmdmQU05RjNySTFRS0xtK1pGR2ZqQWR4L3ZwTkwxRU0yV1ZaU0xQ?=
 =?utf-8?B?MjFpTUpOTG5DbXpzb3J3VUxKYUZVVnNMbDlCZzF2WGpEa0hyb2ZmMWJYKytL?=
 =?utf-8?B?MGxkaW9WRzUyS0NtVzNjMTFqWjVaRCtSeDRadlJ2bm9QR09JRzhQbWs1M0tI?=
 =?utf-8?B?enlsUHlXTTBuNFRJQnN2YTkrZUZBOEZDT0oyNUt4RkVveUJKM1RzakV1L3Fy?=
 =?utf-8?B?VlQzdUlGdTFjL0lOTzhSUWNkMGJsS0FJK3paN3NTb2dYaE1qbmpJWDlGc2JW?=
 =?utf-8?B?NWV6TGYrTXg5OWRtUnpCMXZmazBNZ04zUGRQcmRkcE1kL3BkVzFOTnpKRHB1?=
 =?utf-8?B?RFBEWGxaNE45SWVHZkk4cnR0SU1SY0ZnZktzd29TdzQrSXNGUW5qczV1eUQz?=
 =?utf-8?B?ZThyQmN4QmlUTHpRZTJ6VWI3UDBPazlBYjhjRWVXRHU5N2lwK2g0NmdaeDlI?=
 =?utf-8?B?NldRMWFSaEsxT21HYUJwNWw4ZjBmUXVWSDAxdUJ2VzAvS25xalR5UnUxZW1V?=
 =?utf-8?B?VzNnRnB0eG92M1JiVjJsdm5wTUdqeTlxVWM5NVducWhIdThnQ1Jlb0g0ZXM0?=
 =?utf-8?B?Z2pwNGpIUHVXWGFtMHRjd3ZKU24vRC85WVFtNzNXdUFLcnlrWm1heUtCSW5P?=
 =?utf-8?B?RzVCUmVjMXBiUW1oRis4cDFCNTkxSjEyWmsxV2ppS2txUVg4Vk9qNnhVMG9y?=
 =?utf-8?B?bE56QmtVOEN6M1kyNlR4NHdXbzRGMGtPdzlaWHhOOUhHZkpmc3FiVFZ3VnY4?=
 =?utf-8?B?bGRxZDRJbDY4N1dIVmh2c2xUdkxuc1V1WDNyUnVPenNXb1JXM2g3dzI3VlBk?=
 =?utf-8?B?NnNwWTdkdGRZaitYd2xZTWJiUFZQckJFMFNCaEFhOVFUVlFTTXQwUjZzYzl4?=
 =?utf-8?B?RzBqTEFabXdNcklDQzhnTThGakRlVEg1UzV3WkR5bmdienUxL2w4V2c0U25J?=
 =?utf-8?B?U2xKd1BKL2pyRGh4Tm05OG5HOE12VkorR1AvZko2V29JZUpIc3lSRWZPZEs0?=
 =?utf-8?B?SVJUSyt6UHRZYkFwUUV3bGUwb045WHVLaUxBOE9IVWxzK2ZhUllVdUxyWnll?=
 =?utf-8?Q?jzqFTfNAr7Gqr3Qy/Wt2tKYHq5tk4GfmX9R61ynuecHp6?=
X-MS-Exchange-AntiSpam-MessageData-1: qEDme3XKLl+bGfBWncqWXe5iCFniZJjN2iM=
X-Exchange-RoutingPolicyChecked:
	nnakxa5dPXywc6lTfoclewOynA5cKNqUz05CmpzmBs0CEpBWcG52qASaenFDGJdhJ+0kpe5V68fJoYaZGEERG9ddwcZ4/2UOR8Zgv4dELwG5plJVgLkCowCUb+189M8EmUI9epOqWWcWaT5cNtlpN7thpOWSkJpQHLTSq2Tw3YBgLxNxGdy6G1ohVTaTeZVm/EOJhDmu4rvuIquWmyMZSdu6e3O71bFV/44BO8UHcXIo0jF5orx4hVlLOOWRtRx+cwoh0JRekStSsjBplVtk6FanHPMwWTwHPphnZX7C/Q/Nd2XCAc1ehaoDFUK/QBVTlmxX/bgEWaLe9rPiBjX8WA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DPANPrcGFbNTAWL79u8wOa+5e3zCVxE+0nBnjn6cYWplnSCA7oUYun5eLqROjYb13CQKHSAmT3bXH15VnXjmDZWmJXwRdwqrA44bOAWjQh4dR5dHF9AQp3FahP26fcIUT8/vF1xSxfBGiux3cwdlgmTxn4Qv66uY1TtfNJdMJnehHIFnW1LNX+hXmHI4tECYouRK3wxkDbRUbtGQKmg2F4BG2X5jA7He3owJwdgSN+N5hNRkn0vollt5QoVjPf9rEQUmW1dypUN4vtSQb9KQKVcwYr+kL3T09g3HLVI9VmztAH2pstkRCI/WCfarfFyYgjrbvGQprsCgPcB09T00CS0xEZfh4ot40vd+FPJgUSBQFvlpeIprxsY184Jj+5DEr4OSXEbGqWQZa3Btb1pjg+eTJoLYcOKbBz2Cq6+DCKSJMra3zywEgXJmctKQs/jlvKuJOajrISLUtqQC8uHN4eJLuHDrn7m4krndBPF8hzgoRI1k26s02GhwjxNZekkoKWsY10e8nT08dzr1y00sSBHKZtYKwNn2hRnaGmidEEr+p9b1Jx5ppYsK7v/gd/3PhlUEOBR0iEtL/XQg89p2W5dtLq03Z85GiHFbQFyFBTkydMCiJ3IivlBBMsMmiS/P
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1008ee-e327-44a1-4479-08df3414e060
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 10:27:17.9067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E4i4xQ8oDKk5jLxYeMnBB+qJvphASZZB7VqVksqnBmNAaIBtERYcFaGQ/LKEBMXpLkGW5oZxrpDEj6H3YzGpkKaq+LQWoBuJDQf6TUYWWak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR04MB994137

--------------oo70T0IKPyYp2UZG1fSrl0Tv
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/27/26 9:36 AM, Марк Коренберг wrote:
> Hi,
>
> I'd like to propose a feature for zoned btrfs. I'm not planning to
> implement it myself, but I'd like to get feedback and, if the idea is
> considered reasonable, have it tracked as a TODO / project idea.
>
> Background
> ----------
> I maintain a host-managed zoned block device implemented with ublk,
> where each zone is backed by S3 objects. Storage cost is proportional
> to the amount of data actually held in zones, so zones that contain
> data but are not referenced by the filesystem are a real cost, not
> just lost capacity.
>
> Problem
> -------
> With a long commit interval (e.g. commit=300) and heavy buffered
> writes, btrfs may allocate new block groups and write a large amount
> of data into their zones before the transaction commits. If the
> filesystem then goes down uncleanly before the commit, this is fine
> from a consistency point of view: nobody called fsync(), and after
> the next mount the filesystem is consistent at the last committed
> transaction.
>
> For a virtual device like mine, "goes down uncleanly" is more likely
> the ublk server crashing or losing connectivity to S3 than an actual
> power loss, but the effect on btrfs is the same: the running
> transaction never commits.
>
> The device extents of those new block groups were never persisted, so
> after the next mount the corresponding zones belong to unallocated
> device space from btrfs' point of view, while on the device they are
> still non-empty (write pointer > zone start) and hold data.

I have a patch lying around doing this in an old stale branch. I've 
attached it, but not tried rebasing it onto latest for-next. If you're 
brave enough to test it I'd be happy.


> As far as I can tell, btrfs currently handles this lazily: such zones
> are reset only when the allocator picks that range for a new chunk
> (btrfs_ensure_empty_zones()). Until then they hold stale data
> indefinitely. On SMR HDDs this does not matter much, but on ZNS SSDs
> (where a reset helps the device's internal GC) and especially on
> virtual/cloud-backed zoned devices it does.
>
> (Stale data past the committed alloc_offset inside *existing* block
> groups is accounted as zone_unusable and can only be reclaimed via
> relocation; this proposal does not try to address that case.)
>
> Current workaround
> ------------------
> The only safe way I see today is offline: unmount, walk the dev tree
> to collect allocated dev extents, and issue BLKRESETZONE for every
> non-empty sequential zone not covered by a dev extent. Doing this on
> a mounted filesystem from userspace is unsafe, because it races with
> chunk allocation (a dev extent may be allocated in the running
> transaction but not yet visible in the committed dev tree).
>
> Proposal
> --------
> Let the kernel do it, since it can serialize against chunk allocation
> (chunk_mutex / device->alloc_state). The operation itself: reset
> every sequential zone that is fully contained in unallocated device
> space and whose write pointer is not at the zone start.
>
> Possible interfaces, in order of my preference:
>
>   1. Automatic background cleanup, e.g. once after mount (after the
>      dev extents are loaded) and/or as part of the existing
>      reclaim/discard workers, possibly behind a mount option or sysfs
>      knob. This requires no administrator action and covers the
>      problem completely.
>
>   2. FITRIM: on zoned filesystems, apply the reset to unallocated
>      device space as part of fstrim. Many distributions already run
>      fstrim periodically (fstrim.timer), so this would also work
>      without extra configuration in most setups, and it fits the
>      "release unused space to the device" semantics.
>
>   3. A dedicated trigger: a new ioctl (exposed as a btrfs-progs
>      subcommand) or a sysfs knob under /sys/fs/btrfs/<UUID>/ that
>      starts the cleanup on demand. Least convenient, but still much
>      better than the current offline-only workaround.
>
> Risk
> ----
> With corrupted metadata (a dev extent missing from the dev tree),
> this could reset a zone that actually holds live data. But the
> allocator already makes exactly the same assumption today when it
> resets non-empty zones before reusing them, so this does not add a
> new class of risk; it only performs the reset earlier. If automatic
> cleanup is considered too aggressive, options 2 and 3 are explicit
> and opt-in.
>
> Questions
> ---------
>   - Does this sound like something you would accept upstream?
>   - Which interface would you prefer?
>   - Am I missing a reason why the reset is intentionally deferred to
>     allocation time?
>
> If the idea is acceptable, I'd appreciate it being added to the btrfs
> TODO list so that someone interested could pick it up.
>
> Thanks,
> Korenberg Mark


--------------oo70T0IKPyYp2UZG1fSrl0Tv
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-btrfs-zoned-reset-leaked-zones-on-read-write-mount.patch"
Content-Disposition: attachment;
 filename*0="0001-btrfs-zoned-reset-leaked-zones-on-read-write-mount.patc";
 filename*1="h"
Content-Transfer-Encoding: base64

RnJvbSBhNTEyZGUxZWZjYzEzZDk5N2Q1OGRjNzE1MDlhZTNkODE3MWQ0ZDVhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRodW1zaGly
bkB3ZGMuY29tPgpEYXRlOiBUdWUsIDggU2VwIDIwMjYgMTE6NDI6MDUgKzAyMDAKU3ViamVjdDog
W1BBVENIXSBidHJmczogem9uZWQ6IHJlc2V0IGxlYWtlZCB6b25lcyBvbiByZWFkLXdyaXRlIG1v
dW50CgpPbiBhIHpvbmVkIGZpbGVzeXN0ZW0gYSBuZXdseSBjcmVhdGVkIGJsb2NrIGdyb3VwIGhh
cyBpdHMgem9uZXMgYWN0aXZhdGVkCmFuZCB3cml0dGVuIGR1cmluZyB0cmFuc2FjdGlvbiBjb21t
aXQgd3JpdGViYWNrLiBJZiB0aGUgY29tbWl0IGlzIGFib3J0ZWQKYmVmb3JlIHRoZSBzdXBlcmJs
b2NrIGlzIHdyaXR0ZW4sIHRoZSBibG9jayBncm91cCdzIGNodW5rIGl0ZW0gYW5kIGRldmljZQpl
eHRlbnQgYXJlIG5ldmVyIHBlcnNpc3RlZCwgYnV0IHRoZSB1bmRlcmx5aW5nIHpvbmVzIHN0YXkg
d3JpdHRlbi4gQWZ0ZXIKdGhlIG5leHQgbW91bnQgdGhvc2Ugem9uZXMgYXJlIHdyaXR0ZW4gYnV0
IG5vdCByZWZlcmVuY2VkIGJ5IGFueSBibG9jawpncm91cCBhbmQgbGVhaywgd2hpY2ggYnRyZnMg
Y2hlY2sgcmVwb3J0cyBhczoKCiAgem9uZWQ6IGRldmlkIFggem9uZSBZIGlzIG9wZW4vd3JpdHRl
biBidXQgbm90IHJlZmVyZW5jZWQgYnkgYW55IGJsb2NrIGdyb3VwCgpUaGlzIGxlYWtzIGhhcmR3
YXJlIHJlc291cmNlcywgbGVhdmluZyB0aGUgem9uZXMgYmFja2luZyB0aGUgYmxvY2stZ3JvdXAK
b3Blbi4KCk9uIGEgcmVhZC13cml0ZSBtb3VudCwgb25jZSB0aGUgYmxvY2sgZ3JvdXBzIGFyZSBs
b2FkZWQsIHdhbGsgZWFjaCBkZXZpY2Uncwp6b25lcyBhbmQgcmVzZXQgYW55IG5vbi1lbXB0eSBz
ZXF1ZW50aWFsIHpvbmUgdGhhdCBpcyBuZWl0aGVyIGEgc3VwZXJibG9jawpsb2cgem9uZSBub3Ig
Y292ZXJlZCBieSBhIGJsb2NrIGdyb3VwLiBBdCB0aGF0IHBvaW50IHRoZSBpbi1tZW1vcnkgYmxv
Y2sKZ3JvdXBzIHJlZmxlY3QgdGhlIGNvbW1pdHRlZCBvbi1kaXNrIHN0YXRlLCBzbyBzdWNoIGEg
em9uZSBpcyBrbm93biB0byBiZQpsZWFrZWQgYW5kIGNhbiBiZSBzYWZlbHkgcmVzZXQgYW5kIHJl
dXNlZC4KClNpZ25lZC1vZmYtYnk6IEpvaGFubmVzIFRodW1oaXNuIDxqb2hhbm5lcy50aHVtc2hp
cm5Ad2RjLmNvbT4KLS0tCiBmcy9idHJmcy9kaXNrLWlvLmMgfCAgNCArKysKIGZzL2J0cmZzL3pv
bmVkLmMgICB8IDc3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysKIGZzL2J0cmZzL3pvbmVkLmggICB8ICA2ICsrKysKIDMgZmlsZXMgY2hhbmdlZCwgODcgaW5z
ZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL2Rpc2staW8uYyBiL2ZzL2J0cmZzL2Rp
c2staW8uYwppbmRleCBhMWQ4M2FkOWE0YzAuLjdiZTA5MDI4OWI0OSAxMDA2NDQKLS0tIGEvZnMv
YnRyZnMvZGlzay1pby5jCisrKyBiL2ZzL2J0cmZzL2Rpc2staW8uYwpAQCAtMzA3NSw2ICszMDc1
LDEwIEBAIGludCBidHJmc19zdGFydF9wcmVfcndfbW91bnQoc3RydWN0IGJ0cmZzX2ZzX2luZm8g
KmZzX2luZm8pCiAJY29uc3QgYm9vbCBjYWNoZV9vcHQgPSBidHJmc190ZXN0X29wdChmc19pbmZv
LCBTUEFDRV9DQUNIRSk7CiAJYm9vbCByZWJ1aWxkX2ZyZWVfc3BhY2VfdHJlZSA9IGZhbHNlOwog
CisJcmV0ID0gYnRyZnNfcmVzZXRfdW5yZWZlcmVuY2VkX3pvbmVzKGZzX2luZm8pOworCWlmIChy
ZXQpCisJCXJldHVybiByZXQ7CisKIAlpZiAoYnRyZnNfdGVzdF9vcHQoZnNfaW5mbywgQ0xFQVJf
Q0FDSEUpICYmCiAJICAgIGJ0cmZzX2ZzX2NvbXBhdF9ybyhmc19pbmZvLCBGUkVFX1NQQUNFX1RS
RUUpKSB7CiAJCWlmIChidHJmc19mc19pbmNvbXBhdChmc19pbmZvLCBFWFRFTlRfVFJFRV9WMikp
CmRpZmYgLS1naXQgYS9mcy9idHJmcy96b25lZC5jIGIvZnMvYnRyZnMvem9uZWQuYwppbmRleCAw
OGExNTQ2NWEwODcuLmZlZjg3MmZkNDM5OSAxMDA2NDQKLS0tIGEvZnMvYnRyZnMvem9uZWQuYwor
KysgYi9mcy9idHJmcy96b25lZC5jCkBAIC0xLDYgKzEsNyBAQAogLy8gU1BEWC1MaWNlbnNlLUlk
ZW50aWZpZXI6IEdQTC0yLjAKIAogI2luY2x1ZGUgPGxpbnV4L2JpdG9wcy5oPgorI2luY2x1ZGUg
PGxpbnV4L2JpdG1hcC5oPgogI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KICNpbmNsdWRlIDxsaW51
eC9ibGtkZXYuaD4KICNpbmNsdWRlIDxsaW51eC9zY2hlZC9tbS5oPgpAQCAtMzIzMyw2ICszMjM0
LDgyIEBAIGludCBidHJmc19yZXNldF91bnVzZWRfYmxvY2tfZ3JvdXBzKHN0cnVjdCBidHJmc19z
cGFjZV9pbmZvICpzcGFjZV9pbmZvLCB1NjQgbnVtCiAJcmV0dXJuIDA7CiB9CiAKK2ludCBidHJm
c19yZXNldF91bnJlZmVyZW5jZWRfem9uZXMoc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmZzX2luZm8p
Cit7CisJc3RydWN0IGJ0cmZzX2ZzX2RldmljZXMgKmZzX2RldmljZXMgPSBmc19pbmZvLT5mc19k
ZXZpY2VzOworCXN0cnVjdCBidHJmc19kZXZpY2UgKmRldmljZTsKKwlpbnQgcmV0ID0gMDsKKwor
CWlmICghYnRyZnNfaXNfem9uZWQoZnNfaW5mbykpCisJCXJldHVybiAwOworCisJbXV0ZXhfbG9j
aygmZnNfZGV2aWNlcy0+ZGV2aWNlX2xpc3RfbXV0ZXgpOworCWxpc3RfZm9yX2VhY2hfZW50cnko
ZGV2aWNlLCAmZnNfZGV2aWNlcy0+ZGV2aWNlcywgZGV2X2xpc3QpIHsKKwkJc3RydWN0IGJ0cmZz
X3pvbmVkX2RldmljZV9pbmZvICp6aW5mbyA9IGRldmljZS0+em9uZV9pbmZvOworCQlzdHJ1Y3Qg
YnRyZnNfYmxvY2tfZ3JvdXAgKmJnOworCQl1bnNpZ25lZCBsb25nICpjb3ZlcmVkOworCisJCWlm
ICghZGV2aWNlLT5iZGV2IHx8ICF6aW5mbykKKwkJCWNvbnRpbnVlOworCisJCWNvdmVyZWQgPSBi
aXRtYXBfemFsbG9jKHppbmZvLT5ucl96b25lcywgR0ZQX05PRlMpOworCQlpZiAoIWNvdmVyZWQp
IHsKKwkJCXJldCA9IC1FTk9NRU07CisJCQlicmVhazsKKwkJfQorCisJCWZvciAoaW50IG1pcnJv
ciA9IDA7IG1pcnJvciA8IEJUUkZTX1NVUEVSX01JUlJPUl9NQVg7IG1pcnJvcisrKSB7CisJCQl1
MzIgc2Jfem5vID0gc2Jfem9uZV9udW1iZXIoemluZm8tPnpvbmVfc2l6ZV9zaGlmdCwgbWlycm9y
KTsKKworCQkJaWYgKHNiX3pubyArIEJUUkZTX05SX1NCX0xPR19aT05FUyA+IHppbmZvLT5ucl96
b25lcykKKwkJCQljb250aW51ZTsKKwkJCWZvciAoaW50IGkgPSAwOyBpIDwgQlRSRlNfTlJfU0Jf
TE9HX1pPTkVTOyBpKyspCisJCQkJc2V0X2JpdChzYl96bm8gKyBpLCBjb3ZlcmVkKTsKKwkJfQor
CisJCWZvciAoYmcgPSBidHJmc19sb29rdXBfZmlyc3RfYmxvY2tfZ3JvdXAoZnNfaW5mbywgMCk7
IGJnOworCQkgICAgIGJnID0gYnRyZnNfbmV4dF9ibG9ja19ncm91cChiZykpIHsKKwkJCXN0cnVj
dCBidHJmc19jaHVua19tYXAgKm1hcCA9IGJnLT5waHlzaWNhbF9tYXA7CisKKwkJCWlmICghbWFw
KQorCQkJCWNvbnRpbnVlOworCQkJZm9yIChpbnQgaSA9IDA7IGkgPCBtYXAtPm51bV9zdHJpcGVz
OyBpKyspIHsKKwkJCQl1NjQgem5vOworCisJCQkJaWYgKG1hcC0+c3RyaXBlc1tpXS5kZXYgIT0g
ZGV2aWNlKQorCQkJCQljb250aW51ZTsKKwkJCQl6bm8gPSBtYXAtPnN0cmlwZXNbaV0ucGh5c2lj
YWwgPj4gemluZm8tPnpvbmVfc2l6ZV9zaGlmdDsKKwkJCQlpZiAoem5vIDwgemluZm8tPm5yX3pv
bmVzKQorCQkJCQlzZXRfYml0KHpubywgY292ZXJlZCk7CisJCQl9CisJCX0KKworCQlmb3IgKHUz
MiB6bm8gPSAwOyB6bm8gPCB6aW5mby0+bnJfem9uZXM7IHpubysrKSB7CisJCQl1NjQgcGh5c2lj
YWwgPSAodTY0KXpubyA8PCB6aW5mby0+em9uZV9zaXplX3NoaWZ0OworCQkJdTY0IHJlc2V0X2J5
dGVzOworCisJCQlpZiAoIWJ0cmZzX2Rldl9pc19zZXF1ZW50aWFsKGRldmljZSwgcGh5c2ljYWwp
IHx8CisJCQkgICAgYnRyZnNfZGV2X2lzX2VtcHR5X3pvbmUoZGV2aWNlLCBwaHlzaWNhbCkgfHwK
KwkJCSAgICB0ZXN0X2JpdCh6bm8sIGNvdmVyZWQpKQorCQkJCWNvbnRpbnVlOworCisJCQlyZXQg
PSBidHJmc19yZXNldF9kZXZpY2Vfem9uZShkZXZpY2UsIHBoeXNpY2FsLAorCQkJCQkJICAgICAg
emluZm8tPnpvbmVfc2l6ZSwgJnJlc2V0X2J5dGVzKTsKKwkJCWlmIChyZXQpIHsKKwkJCQlidHJm
c193YXJuKGZzX2luZm8sCisJCQkJICAgInpvbmVkOiBmYWlsZWQgdG8gcmVzZXQgbGVha2VkIHpv
bmUgJXUgb24gZGV2aWNlICVsbHU6ICVkIiwKKwkJCQkJICAgem5vLCBkZXZpY2UtPmRldmlkLCBy
ZXQpOworCQkJCXJldCA9IDA7CisJCQl9CisJCX0KKworCQliaXRtYXBfZnJlZShjb3ZlcmVkKTsK
Kwl9CisJbXV0ZXhfdW5sb2NrKCZmc19kZXZpY2VzLT5kZXZpY2VfbGlzdF9tdXRleCk7CisKKwly
ZXR1cm4gcmV0OworfQorCiB2b2lkIGJ0cmZzX3Nob3dfem9uZWRfc3RhdHMoc3RydWN0IGJ0cmZz
X2ZzX2luZm8gKmZzX2luZm8sIHN0cnVjdCBzZXFfZmlsZSAqc2VxKQogewogCXN0cnVjdCBidHJm
c19ibG9ja19ncm91cCAqYmc7CmRpZmYgLS1naXQgYS9mcy9idHJmcy96b25lZC5oIGIvZnMvYnRy
ZnMvem9uZWQuaAppbmRleCA4ZTIxYTgzNmY4NTguLjJkZmE2MzM3YWUyZiAxMDA2NDQKLS0tIGEv
ZnMvYnRyZnMvem9uZWQuaAorKysgYi9mcy9idHJmcy96b25lZC5oCkBAIC05Nyw2ICs5Nyw3IEBA
IGludCBidHJmc196b25lX2ZpbmlzaF9vbmVfYmcoc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmZzX2lu
Zm8pOwogaW50IGJ0cmZzX3pvbmVkX2FjdGl2YXRlX29uZV9iZyhzdHJ1Y3QgYnRyZnNfc3BhY2Vf
aW5mbyAqc3BhY2VfaW5mbywgYm9vbCBkb19maW5pc2gpOwogdm9pZCBidHJmc19jaGVja19hY3Rp
dmVfem9uZV9yZXNlcnZhdGlvbihzdHJ1Y3QgYnRyZnNfZnNfaW5mbyAqZnNfaW5mbyk7CiBpbnQg
YnRyZnNfcmVzZXRfdW51c2VkX2Jsb2NrX2dyb3VwcyhzdHJ1Y3QgYnRyZnNfc3BhY2VfaW5mbyAq
c3BhY2VfaW5mbywgdTY0IG51bV9ieXRlcyk7CitpbnQgYnRyZnNfcmVzZXRfdW5yZWZlcmVuY2Vk
X3pvbmVzKHN0cnVjdCBidHJmc19mc19pbmZvICpmc19pbmZvKTsKIHZvaWQgYnRyZnNfc2hvd196
b25lZF9zdGF0cyhzdHJ1Y3QgYnRyZnNfZnNfaW5mbyAqZnNfaW5mbywgc3RydWN0IHNlcV9maWxl
ICpzZXEpOwogCiAjaWZkZWYgQ09ORklHX0JUUkZTX0ZTX1JVTl9TQU5JVFlfVEVTVFMKQEAgLTI4
Nyw2ICsyODgsMTEgQEAgc3RhdGljIGlubGluZSBpbnQgYnRyZnNfcmVzZXRfdW51c2VkX2Jsb2Nr
X2dyb3VwcyhzdHJ1Y3QgYnRyZnNfc3BhY2VfaW5mbyAqc3BhY2UKIAlyZXR1cm4gMDsKIH0KIAor
c3RhdGljIGlubGluZSBpbnQgYnRyZnNfcmVzZXRfdW5yZWZlcmVuY2VkX3pvbmVzKHN0cnVjdCBi
dHJmc19mc19pbmZvICpmc19pbmZvKQoreworCXJldHVybiAwOworfQorCiBzdGF0aWMgaW5saW5l
IGludCBidHJmc19zaG93X3pvbmVkX3N0YXRzKHN0cnVjdCBidHJmc19mc19pbmZvICpmc19pbmZv
LCBzdHJ1Y3Qgc2VxX2ZpbGUgKnNlcSkKIHsKIAlyZXR1cm4gMDsKLS0gCjIuNTUuMAoK

--------------oo70T0IKPyYp2UZG1fSrl0Tv--
