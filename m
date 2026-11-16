Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794848151;
	b=TBuNsJ4zISR9TXq2sY1JPPzBMZd0ouwPDOWPIZ6lIbZ5t1fJQ2MdFHGgqGPXByhJO0v1
	 o3Nvw4Le8bvYqtFf9WnYpuPqeph/WlNBYUlCLEelMmenvZUhi7McSdZHiP1mBy/E/YPAp
	 Iyz6lKsT1coY85nIre1sMRD4doiltE/WCTGbN5h9Q6CdyBkjorfMhAjcZY/LnAmEgh8Au
	 xg/NC3KhpkyqKe61j4Ln4E+KXkiv6+4o9CMmGkr8El26ZR952xUiB5TDj5dzKgubeM41R
	 Gvcr06w1q3Bh50+xPvQEc78LiVBLyZQdlsgZnHjraBlzfifmNOd2SXdxxlXAhiGRZUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794848151;
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
	bh=mCWxSpGHKTfBHHzye7tA9hUwtBdGebHPFrm0cqjMZao=;
	b=TdLKWsx6vLKZYZf0Bmh4NAzjmr3HKlUZ0x8dGXK4x6CnkTnqH1DYLafZ2WeZr0eyY2NW
	 lu7qgz9hbUV2w6eMa9f+6ptmB9HB2vXb2mXxh+qpuLTvevLa6k/wrZkH2l/S+Q/ymHnpp
	 M+rM/y02zOFtp5ZTJ5poePUHBBV6fF1MUZVkbfZwoSVvW2jWcxtxptXqHNuuAmpVaTvlU
	 ztpSl9LXdnF1xDxEuVwPFb7ZT3crGEuX/vIPvbtQ8tn1mxdNnflRo/0HN5p8LFjCZIRbH
	 EzTLQreVhigjX00Db4ZUk3AOiRhRzwe0T1WfZD6+ogEq4kPRDEAzG484GkNzyVNlSWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Xtsdgw+n;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=XilbLetn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C1B606A33B;
	Mon, 16 Nov 2026 16:55:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77C1B606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Xtsdgw+n;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=XilbLetn
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794848158; x=1826384158;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mCWxSpGHKTfBHHzye7tA9hUwtBdGebHPFrm0cqjMZao=;
  b=Xtsdgw+nnUyUHHK4rWiemI9uU3VKOZ25prkw8DqS9/yLpTl6Z+92FuVc
   Cp8c//Sa4B4V1CKOK0h8GTQUNyay3PCKb9O9BgluG/Tu88PhuwbUzgJGK
   oBmbUiYyxQXbxqi/CzstkGxesgfZVpy0DR+n7Rp9+9hS6iDFpDOumjq1/
   Q+mEB6zZuQGORcaDU5g9G6vJxDUtZmA3Jtz9xCU6bMUGnmmM6oqAztl9o
   5mviCZorT4pyZEnYKsivjfIbiKBT0v3Gvfc7bduFpFQJTN96T7QHLz1VH
   HgAOqcc/PlhTvI/qaTDsXDq42jd96ZyZrQnnRAOiqmfkkaekCxzHadpFy
   w==;
X-CSE-ConnectionGUID: e2lP6tiHS1uXBXvoPrU1Nw==
X-CSE-MsgGUID: PidJ/hJFSeqdOYw1gFWGcA==
X-IronPort-AV: E=Sophos;i="6.27,217,1786982400"; 
   d="scan'208";a="160939474"
Received: from mail-westus2azon11010055.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.55])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 00:55:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x+1Dq4NTSd9JwZihMBGksxeeWqQZP48P3pyeAPWGRu6blJtVMQwQmMoSbqEgRuuc2usvO3RsKs4/1bzT53mbUWGdjlQMSosL8EjFhHBW0b+XPdl3KR4eZZY+FIeFlgZ2XofgYGIzWLRBJg1MIp3svnVl2nqbI8MkaUoRQabIP6GdZYq39Gp7YFI+cXNndPoVzK6Y4UYkkh12/an9ETi3ilc9lHzPO067lkfhUeRhDkC8hGMfNYIf1xxuUegS+06QhJTeyR3ulH615tHZXN+VeRQdcuWqjla1AhyE+TcyLvrY/zhuQYpTpoofOzwappUjLn+p20nA1m0U/BKmhh5TiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCWxSpGHKTfBHHzye7tA9hUwtBdGebHPFrm0cqjMZao=;
 b=AYcsmz7AzFKNThg5hOCZJcnNMBUoqSwki4bxJgO2/0E5h8WlHFrFqHDrc/orBPSIyaiOtj020+TGhx1uXZ2GA9oWJppSlF2ZrUxucvV3PpBVrNacw8vDxfItvkxkkyM7+9byuRqK9Ey93vDuXK43wByrLoGf8PoAaWGqccTWBD7IytXn5sUiBhNwAkHzvDkBtwVKTirjMnbFDdAndbAtTbNjveiVwwITstxEpYHred7VbSxm6Pq6fML0fSfjMHB/orUBZZRK3FSb2iu0uU2+bhBi9iFOHFuuXn4xyiUauDM7oU+1VCZSMppQySbzVf4qb8gqrL0lJp4jS/mxLIBMxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCWxSpGHKTfBHHzye7tA9hUwtBdGebHPFrm0cqjMZao=;
 b=XilbLetnl0aQrNkzE9YELJvpTaP2XpJhQBTojvu/K2ZJrI8Pqhqm47EDzvfVDWl6+l147Xr8VLxqNlqrZGitgSUZW7FXf1/j59HXHEmeStzjpdGk4O6qrULmmafhljf2k8dJo/XspOe5CZVtGKiMmzmR6PS2kZfk1C9GnDF3hK4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB8161.namprd04.prod.outlook.com (2603:10b6:610:f5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 16:55:42 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 16:55:42 +0000
Message-ID: <5a1144ad-a773-4851-8832-78e46e065653@wdc.com>
Date: Mon, 16 Nov 2026 17:55:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] btrfs: zoned: fix silent data loss from leaked
 active zone reservation
To: socketpair@gmail.com, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261104-btrfs-zoned-active-zone-leak-v2-0-0cee2ef72171@gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20261104-btrfs-zoned-active-zone-leak-v2-0-0cee2ef72171@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0345.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::6) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH0PR04MB8161:EE_
X-MS-Office365-Filtering-Correlation-Id: e0c46e7a-b257-4270-0461-08df44027316
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|376014|23010399003|10070799003|366016|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Sc8N3yQ+FNkZ1LN+cATJ8mIQxh5+7cvPxCzu+4NAP1jG2zkITO05jZ9iPCBjOZIcSW1I7Lcgw5JW7qtc+uHp0RhAg6AMWUVkKXC8R6ZqwPiA0eiHjIpKF78YeEWgPEYxIkOLPOypJVFld4n09Jh91sRFNu6x4TCCGTrcbvgQGQqaReiSndC/BmU79/J/hqrXCHc8BjB723TNMbOJjgFdOA995LmYyG++vaA1yAR/MV2G3Yc7yfU+0N1VNQHhUhqiE5QmKKD5mz9XbC107CQVRqKX7J7/rtb3NHPspTgQmKn7/STUcIBVhVDdj+DxZazgwxBoX2HXMF8fD8wvNho7hbMcgheDHQqQdXMFq6RK9tILUfgD0bRa7rHeO0RmFGIUrFIgGR6BUmyYXTJF1L2CEenTNSxZ10C6/uIbDHY8K+3NFgCoxrMdMhoDNZzZRUTD4hMbEuEc2mq4t6FTCzmuGcxBtkWGRcfZSTKQcKVcbnKRWltIgyokLCHds0BqgZZEZmqevyMGEchEymY+agUiFT64nd3afYr5eZI7yJnGUJoLnX/kSSICDqa2f53OP6N7ctcTA2DtXE3Dq+ug+xNyY7qYL9ig6onwiW3ArTxNWx96ZKOCTVaEfEcAykjMPX/Wu0SfZVDAW/bLWKYqenvqyZhaiorMGQG8r6wO0emeKSg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(376014)(23010399003)(10070799003)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTJkMEorVVM0SXljVlZmbzhqTHg1b0hyaDJQS3dCblFMSVNnbFdYYmxNUmdV?=
 =?utf-8?B?cVdpb0xIUE9wamp3VmFOZGRNT1IwQXMrNmlHMmF3cUxwM1l4VE8yWXJXaHNS?=
 =?utf-8?B?YlJ3VGoxRUtqejdBWFlGWHl3U0o2MDNEN0Z2RkJoVlFmY2VyZjZ2TTZtUTJE?=
 =?utf-8?B?RTlYb0o2SzlYVVpKc1ExSnd1cTZsTDBmWFF4ekdoZHpDOTBYMWlhWnF6OVp6?=
 =?utf-8?B?VG1XV1RIZngvS0IxemlPNDMvdnV6NlV0WkREblBOYTM5d1FHb1kvNHBQcVpy?=
 =?utf-8?B?cnBwUHRlRmVwWnlYcXorQjdDY3RDQkF3eHRqTS9OZzNkbkJWRlBIUWliemUy?=
 =?utf-8?B?c0ZaZTFMUndnU0JRM3ZRR0ljN1VFNzc5ZGtkRVducmxpVTYrVFlrY0Y5U0I4?=
 =?utf-8?B?aDZrVFJkNGptbnlidEpFaE1JbXdzSXllNXZDOUN1TTM1NmEySEhkaGZXVmNJ?=
 =?utf-8?B?N1RuY2NnUDhRN3NjTDVzdG96bER1K0JGQTdTSWllZ3VSVkFMNzdJdnFSc2FC?=
 =?utf-8?B?Q3BBSkowWnpnQVhUQkt6NW0yYW9RdHNFY0J5SENxZDlmMS9rbldLd0ZzOGpZ?=
 =?utf-8?B?VTYxVzUwTlRwaUUvVC9UU1pUU3RjbUMzdUNrNWs4djRyV3RaQzQ3Rjkwempn?=
 =?utf-8?B?WGpWeXdZNnh4Q3VBVkFxQmlIcTEvZWlpUjYrYTRkdTVEb2t5L1V2RnduTUty?=
 =?utf-8?B?ZGdXdDlKWHN2S04yMm0yMGtpRjRoVkFQM1R3NEgwajNhclQzQWsxalhPcENo?=
 =?utf-8?B?UmljVFNJOXk0eGlTMGh3aDRMVWtHbGFWbndKWUhxVUxRL0RqWnFVcXlvRnlu?=
 =?utf-8?B?Y0JIbWswNjVCMTNyWk5MUzNrZDZ0dUFOSTRIMDVwbFEvNXNvTC8yUG5vTjEw?=
 =?utf-8?B?TVpFQ2t3aEVuWnF6ZjM3a1hLN3J6dFVMMlpNbUNEMHREZDYvTjc5OENrM3N4?=
 =?utf-8?B?Q0Nld0FEazVid3EvZEVHQ0dXTjNESnFRUW5TNm9RcHpuL2lnUVBoUEt3V09u?=
 =?utf-8?B?STFPb2dEYnByK3lzaDA4QUE4Wk9odWR4V1JWTmwwc3Bpb21uZ3F5Sk1QQlpa?=
 =?utf-8?B?ZVVRcE9Oc0FITFNkd3lXRW80S2UraEVEeGQxeHFyUC91VUhxQVJUWlNPQWJq?=
 =?utf-8?B?TVpDWVZ1eGxwZ3BIdFdxVGo3V3plY3BRUXRtSVUxdDNmdlhjT21ZR0Z3eFgy?=
 =?utf-8?B?SDcyQTk5VDdUVEJmbVR4OFdNNytya1VMMHBWRW5PaFd5NTV0NXRuN2JFWndW?=
 =?utf-8?B?T0Q4NUhNUE9kWHdiNlVNY2lKdDZnV1ppUzdMdjExZVNQYVlIM2VhVFRyWGUw?=
 =?utf-8?B?RUgvSi9hNVcvbFk1THVsZXpuOXhlYmFicnFETkszV0VGVXQ3NkZPNHNiMFor?=
 =?utf-8?B?bE5NSGhGR0V1RHp5Uk1jc09aSXdtNFlOamhvdUdsWFN3Mm5WS2NBVVdHNGM5?=
 =?utf-8?B?YktlQXJCU1RMb0p2bDdHUXp5dElPK2Ewck5SdUpDT1RvcUhqZjJ2NHVmdGlh?=
 =?utf-8?B?Qkt5MFpzNkY4Z0NtTWIySE1DOEd3NER6ZnpPTFpvL2kyRllSZ3IrWmJiSHdO?=
 =?utf-8?B?cDJLd2oxbDFVNkpSWCtJSWw3YWI0WkVVSmVtSzJ3Nnl5TTVTdmtudE42R0RZ?=
 =?utf-8?B?a3NZQUhNanJnaFFJeTh6U2VibEVvUWpiRittRGpzZmE2M0dkMXhHa2c1dnlC?=
 =?utf-8?B?RkNKVDRYdVl3WmRYbWYzZ2ttZ1ZKVzNZbkk0ZWhBeUlZWWw5VG1CVGJRbXd5?=
 =?utf-8?B?RGVtbGhQdmNhY1dXMTdzRC82WlNwSVN6U3NBczJyaEp1M2xSSUs1a1l4VjdE?=
 =?utf-8?B?OVJZbHdqQkRTZGJ3ck5yTzNiWUlwU2FoTnBIYm92SDVjakFUV2UzcHZEdjRB?=
 =?utf-8?B?N2FlYm55MlJZeDJRMnNSdHdsNFRoNGRiSkk2SldTbW56dnoyZ0EwY3oxek9Y?=
 =?utf-8?B?SkxiYTg5YVZvbk1JU1RLcER3aHNHb21qenZ4TTdWbFB5N0oxODNOeE9IMnYw?=
 =?utf-8?B?Q0dSaEc2Y1Q5ZjIzV2lhaWdMVXBsaERKN2RzeWNpbGdUcm5YTmptY2hEQUhy?=
 =?utf-8?B?S2xoSldoYjBJOWNWMXZYcDk1QzNOVHZXcmJUVGVLK1NMQ0t5VGEvQmRxWW82?=
 =?utf-8?B?ZmlOdWZwQ3Fmak92RUtSYUtZSEFHVHJHb29hN1hScWJjZkM2UkY1SjVyT05j?=
 =?utf-8?B?clRRVmlnUDhDVmdGZ2hoVEJHbDRjK0dnRVg2Z2duQ2J0MDUzQWJyYnM3dE9Q?=
 =?utf-8?B?MEJvT3czVWlUaG84SmxIMWVTNlhsNFpHMDV3M0pLVXB5TUhyTlRCNjczZ2N6?=
 =?utf-8?B?T2hzdCtQNFh2T1M1blo4Q2pZNGN4OVNoNm5zSEpRV242UkxRYURDbENBM0Vl?=
 =?utf-8?Q?k9mBva+WsyHrVRHRyW+zxRWeN/cG4O92HicOXmnZiap4G?=
X-MS-Exchange-AntiSpam-MessageData-1: e/9fh/qWcwTogYAw4IWH1ciL+TRrzmMO1oU=
X-Exchange-RoutingPolicyChecked:
	QNfvP7RCibTLcYsBDzOSLl8fzOabYUwcw23dUVa6UJUKkd2rPNMubSmnOAeeCmsEf0rUrKjs5NM1JaAbxfAi7H4SicRNQpCt0V+ifhYnb6S4FfnqDWP8UtHLdgoYAnsHlzR4zWkzcRcKSJUBkwyzKFH36yKads/3OcykZq04OiiYxUkgK8XF7yf/fL40HoCvB8Mkyl7nXnb84az5xwPuSIWOIJZ09XbJhfYMciNAkHz33ZAX6sBUcwpLnnU65Gxd+u83J4fvIRofNqSHebv23ad9qB2LMHKBxYv4yCS9UcQrNUr+T76wtSeNPrsxlVucMurNVSnF4i6qwvcrZ1Nzsw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WR2yHoK/7wpQwKH+ITFqdN8e+EUHzacD8rQuXbMQa+jDS18Q0oIznOExC5/JAq/WfZMbM0sgQoKh7fz2oY7EL2THwAbDnRvbiWt6INmJusU7ryettPg1dQSd5kZzcHb3hTvF0BG0Cx6pxpxBKaHgKyueC1p0OPeCzoNjmdhaNdnS8t6ZwkK+9/L4Hz414GL/qGjPFkJP6B7QcL91EHwreXLwGXrMGjEz7ZcIz+yo49B4Bv24iCm5DVDY2+5ThLkjW0E/nD5PSmv9M7F8VMNgmvTNs154QsbrKLsfProrTjEMxFwlxLEgP8Nqe2s/ef3jvIy3mhNUrZDQc++vDBberXueK30OI2QDqis/D3eaVbH5/+6dF7Jn2QNIImYhzTj/R6VMZBBKigeb9WbCDfDOs7q/Ns0oDJXyZ4qcDFGnRWWDC9a0xRidAeXzVI5Lfmyah3WTl7l9KL+tCJEn6CavPN520JwU/IoHQT6h9zQ5q5DS60Ob/DyturTI1st8EYyIsgXFIM+XROM4SMH+zil9ifbMxNree2MV8GtxnnnfNXNGTZp80ZTsRDYuYh5cxCAIkGC95QtX6IPCao+m5VBKWBZ9CHB5F2T4wj6Zky5FKaTrrHP2tj6EK6UfiHjs1+3m
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0c46e7a-b257-4270-0461-08df44027316
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 16:55:42.4066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jq5AmEgJTE6ob5yNch6tOj7DwFYVFEd0GxhpfKeRE1kntw31nmxJ5GnFD6ldTe7vX7TMpCiWfZS6q7rjwlpTv3e/QqUOpqPx+2QdAi6j3j8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8161

Looks good to me,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


And applied to for-next.

