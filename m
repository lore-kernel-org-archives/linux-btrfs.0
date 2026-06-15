Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F95D3BED63
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 07:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781509234; cv=fail; b=QXGH9ocYkhWtUmdchzYTpfqG8tkLiy+pR/BEMECN9cGtqMvWmf1ym07yygk5yY8mueb9OgJikGXpd7asc83uYfu6mpH3g0y7bLkTWgYgd6/P6rDqHohRb3AYHmW9iTRrks01GsHq5/X93jXFWq2cqxJXg6G2/KMnmhnplZEgV3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781509234; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r88dB6c4MrmbAq/Jj0UNQfyBluDmX3QYhfE+hWSf+/2zc5tIkEX46cLcqDxI2O4V4jILFjXBsSQnk+RErcD0+gEZdyKYVYV0U2PMOiqMumfoNgegSEakrgcpbvxryU0EMtxBbCuxI4/EQPkOtVvk0+ixY4k79rQWcd+TAhKZXtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Z1dYKFx+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=X/fTTt7T; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Z1dYKFx+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="X/fTTt7T"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781509234; x=1813045234;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=Z1dYKFx+DM5DwLlpYuBIjOXAUHPIjay0pi0sOexQOykJhH9RIaIxTuZz
   bJQxnp/YXNOJSzp7CsiOj/lld5WRyNcgAoKhFvqS6rwjk1eDHFz94Hwjn
   M/Osn8F2zQJ2xsCRIYFLGhj5YypXHMF58sGyCHlpTQLZrM/vh0u9EeDFe
   6tfwB2F5QFs/YwQ2o94ZUxm1dvjUDeBDOpQUy+tihbgF/oa6vImL3U3D6
   q3+lT9m6rT0bP5X/5GW0gKkAeJDJjxzwJzIDyNEwSBerG/cl+YpjI5WoW
   TrLx9XX/XZi5WSwo8EnFmmnzfoiLFyy/xryyXeKkDuHsI/pW4RxrrHltI
   Q==;
X-CSE-ConnectionGUID: WSt8H+tkT9+8KXRiNpS/eQ==
X-CSE-MsgGUID: D3Y4uLkVQmu+l/ihMYM3WQ==
X-IronPort-AV: E=Sophos;i="6.24,206,1774281600"; 
   d="scan'208";a="147654300"
Received: from mail-centralusazon11010012.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.12])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Jun 2026 15:40:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Znyj26klGYdWKWkEd+KcUQHX4JdQhSBMmngLA/L8TzHbCPFnd0QupHJgSp9qLBBlh6nySV2fk9S6tJ4FV0WZNyrTsH/lutHOq9ddBXVQYz6UiWkq3A586hByr9fc0kxvCL8k4mn8m93k0+eb9VqGdb0Bn13+37re1YYHPFOoHE4q7ZG8ens/3YrEcHmbUink7goQxwnO2cUj29qeEGKns32iZvlNqcztL+RXjn5n6kH1tzJlTqCiA0Hs84QJ8u7IqOPZvuegk7Iy2KK3skFQVUETOcR2FvW/Ni+1fLIzXJG66d1s8wz7wm6t/6QgTOnk3tFCxybXlDWjve6zwyFSSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=Gf+pljf0UthyKJcxtNBQNY9YJdKb1M91wic9Tdytmbzleh8DwvhDo+bVKj4+DKUMiy75qVR/uIZpYA1dpI3U2Uf342drUFJz8+GgBcY9ISWqKIKs2LrgacNQRl/9euuHZolZ1PLXdvgmo3DbUuFez0/zjbxd/p2dkh0X40Nd4Wrdwd8PUtkoWxMJxTzI6PeY2KzvPFGrjn3y3ZMGPso81zVZJrLd1rLWsvhWd2lQm5QT9H5bgxCgODAEljxxyo30p6mala44SrLYNdkNQQ1b+CIpRU9ZBYtTjuSwuHVIpVyAsc0etU+l8LG/cC4hgrbjyJFFMcqCOyi9coDoQ/6a3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=X/fTTt7TcKkOxkdir2eu4+uVT6dAQaPGxTRXCF6nKgWmBZ31B+ENjTjNtn4b8UzNijGmA0TrKipcdXlSM0p1J9HISsQ7gJbU9VhZMnTCa+Z4iQsLHkGxH2FrxefZG7Er8ljKVsoWrQoGA3+KUGI7F2i26HAKoGP4b412KRPw25c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO1PR04MB8284.namprd04.prod.outlook.com (2603:10b6:303:153::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 07:40:25 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 07:40:25 +0000
Message-ID: <36224307-d25b-45b7-b9e3-7dbf0d7ed10e@wdc.com>
Date: Mon, 15 Jun 2026 09:40:20 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix copy_remapped_data() to not allocate more
 memory than intended
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <c7e85e62aa6ce8b00509a8534e8ecd93cf1fd773.1781276386.git.fdmanana@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <c7e85e62aa6ce8b00509a8534e8ecd93cf1fd773.1781276386.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0096.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::9) To DS0PR04MB9439.namprd04.prod.outlook.com
 (2603:10b6:8:1fd::6)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO1PR04MB8284:EE_
X-MS-Office365-Filtering-Correlation-Id: 2780b99d-1537-4299-d6a4-08decab15c57
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|376014|23010399003|10070799003|1800799024|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fUH5PYlNPtMhnw7fSEvL71N42UbhysV4mYiiTntiCjP7TJUPvkAW9pVMLmiRHdes6/7Zm1CswyvnjNsfeUHrJiKE9wsf5CQ6lNv8pMoc+vdAbDxpYlVynlu4xEFN6ou+ozF138BhMrlUBo2fc9C8NC5ziDI6suvxkV+FDcrnIIivALotbBinQYDEOzMBwPhBUKWDLEpz297SzgCr/zHEAWhf9cqrNzvrjBN6kIJMsKHo+frRr2C+QH7vQ3iCthGGBNoBWQ82qh2FubYoY3vpP5cbxdcmQvjcb19hP2cREUSaVzCMEXhf4ucphLqDkVjPTWwtgyBjpqUwPISb6OIrYjSbsaHJH16nDwesPFo14Gh3IT8PTyCS/vqE9kE+RZpGvySdyTz0vdohoHARSWJZwxT09cYoitMHxQOjUzKZlIT9lSXLhnGqgKNfGSWiXU66sd28HTbscvr484ZgFFFu/NwCGn9LP26nFOD9vXZntmKazT6BnTv3y8SK31suAVohkBXumr2iyYHp627TUCrDckynwdRj/dBGkl1qB4oslZYBQxviXNwF+sNekVHTChpItIHF5FTBQXD71ADmr87PH1en5D5LclZq1CbOjmAAy04zKwtPlN9NVabCk8qJuP/yymR3AUDNA/ktTvQU3LLlKjcOWYvAPOzxUcey/C6QQIEqOcOUxohrHi+7UKagb81t
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(23010399003)(10070799003)(1800799024)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVlLV3QrSjEzN1ROcXBiUGVxNkF2Vi9SNGZxRVlPcERjMFdBTlZCRjVGeDcx?=
 =?utf-8?B?YW9FUnEwekwzaXNNT1dLYUxWaUpITEFmVmdyNUV5Z0d1SFZ6ajhNaHVhR0pD?=
 =?utf-8?B?VTdWL0FoOTJ5M3VCSFFsWGZ5OUtNM081RktNNzQ4WFBOSHc5UkJCcHVJRlc2?=
 =?utf-8?B?b2p4SEtlb0NCWVlweFVnWjNjVjZNRndML1c4b2hkTHBJY0ZMTVNHSXpVeXQz?=
 =?utf-8?B?QkVaVlhoYVdtOGRTTGJiWE5uemVhQUQ0aGhaVXFpV1o4akhGMFppVS9tLzVp?=
 =?utf-8?B?T01UTzZrbFpvbjhuRG53UloxN1lEVHRvZlRzcmFxYjFUcytCTEZDYXlmdjZh?=
 =?utf-8?B?TEgvOU9IRm9mNEhXYlZFc1JaQTBPMWFabGM4UlFqaTluUUh0ckJSeUFkTktx?=
 =?utf-8?B?VGVxbTE5QUZ6Q3BZR09Yd1VLaEQyOERRY3VNaWw4U3J5cTBqeXlySFZHNFdX?=
 =?utf-8?B?cWpDV0RvWGRZU0l6UUpZWUVZTDdpQ3ltTmtaZVNBNzM4K2JyUGtqVU14R3Z1?=
 =?utf-8?B?RG5BRjkwUTVjY2M2WFhTb3R0SVpqWER0Q3lWNmhRYVhQZVV6L3JMSTdIa2pH?=
 =?utf-8?B?eWFOODNSQkRlZDB1ZzltUzJTZ3ZCTWd4Wkl0R0h6NEdybUEzVmFFMW40UVVr?=
 =?utf-8?B?c1VFdDNKWVA1dVRCWEh1R2RNcjd2SGZ5MkNoT3I2a2dhbjQvajZiZHduR1Nx?=
 =?utf-8?B?cXZUMWlkQW81b2Q1WjVESU92QjVZdkVvQjVJWDdBQXQ3a3IxSWNSRytiZlJq?=
 =?utf-8?B?ZVJFczhCa090TWg2Y3NsN3BDRnQyN1lzTUF2MStpdS9JZ3EycjZ6N2xiaUpK?=
 =?utf-8?B?SlVqclZmUE0vSjMza1g1ZE1KZ0pIUFZHa2xtV3FNanhTYXY4aDE1SGl6ak5s?=
 =?utf-8?B?cGFkZzhoTkVKT2dpRWw5MjhleUh6VU1VUzZlOTBzTlNBb29zTXpKNEhFOW1Q?=
 =?utf-8?B?NzFqcnNHZlVqb25USHhHNVdIS3lTQ016eWVtRGJib29ab3M5b01meUFUSGtO?=
 =?utf-8?B?K1hJUCtoNk9oWFozc01iZ2NiZ2w4N2JCdG41RzJQTitJbk1hazJUK2pML0t6?=
 =?utf-8?B?dERVS0pWMko1eCtyd1NUR0Fvb3lkTFllK3VzR0tnRy9aVUp3QmNWRXJ6QUNL?=
 =?utf-8?B?TTdVd1hXTzd4YjN3VTBiUDNvRGdwNHdUT3FiT1BORXZrUzhKLzNZbGZMY09j?=
 =?utf-8?B?Rzd4OWNJZHRwZEpQdmFEK0NBZW01YTBzMnpuZHV5VjNVc0Q3MzFRYzQxWVdn?=
 =?utf-8?B?RzJFOFFQOXFlbkN1UjJGV09xeWI2NlVRMXhhWmF1NEc2bmkrWHUvS3NCTGtO?=
 =?utf-8?B?NGp6d1R2Tks5Q3dLUjBraEEwcmpwVE9wK1FJREExTll3bjZMNmx6T25EMzVD?=
 =?utf-8?B?ckZsNzdTWldmZlExM2xFYStnRFBLVmJuV1JQMHY5UEdxWlFPSm8rTk5DZDhv?=
 =?utf-8?B?MHp2aDkrd1VJY3RtSXRRdlpHMFBTVEpLbXJ6TUFzQnNBdWdWYTkxTGtrV0Rr?=
 =?utf-8?B?OWNrSms0WHJiY1hxdWs1QjNFbmdRbjJLYWs1a0Y3OFNpaTFqSXJ3K0F6Zlhx?=
 =?utf-8?B?SWZCTFRZRFpadEkrVWdOaFlBa1VXZllpaXhwa1cyTlVxS3FPYS9la0UyTSs1?=
 =?utf-8?B?ZmppWmZ0WnJkUk5VZ2p6V3h0V2FlKzFJUzV2R2FXNWJiREg5TFZ0RHlqN0VF?=
 =?utf-8?B?UmZLcUNDOG9MLzN5RVlUWGhmNjRoUXUrdW9mRG9XcWZrbEZDOEFzajd6TE9J?=
 =?utf-8?B?N3NWclBKNUozMGdEcDIwSVJIUG03bEx4WWkrandteFJ1L0JXS29mOTY2Q25T?=
 =?utf-8?B?aS84TWUwTmRPWGlhN2lCb3UvaHUwT3RpQlZMNzcrWkd4OXlrdW5ha1ZsMG9Z?=
 =?utf-8?B?OWNQSHZHdHBiYTJWNG5yaFNINVZLMlpmZGR6S3pSNThIWHlSMTRyVTFUS2ZW?=
 =?utf-8?B?M1hPVk5RcHlqenNVL3h5MkpESkNoaGloQ05NK293YUkvQ3B2c3pjd25YK1Ru?=
 =?utf-8?B?Q3EwRXpjZC9JWDAzRVBwQ2hIWmdpSVJZVDIzQ0JpR1UrdGxhakQ5bTVKb21u?=
 =?utf-8?B?MUovYWdNd1hvNjVvVkRtcVFHdVRvSVphdDRWeWFVb0h4V2VhOTFnWGNuWFpB?=
 =?utf-8?B?bkRUOUhMazNqVmlPU1pYaVdLOUNPMzRibEhobjF1aEx4UDUvNGE3WVZsanly?=
 =?utf-8?B?c2VrWUNXQk44dDAzNHZFOWlnNjVDbEVoa2tYWWFzY0VtaStVdmZJN2NGL0xI?=
 =?utf-8?B?bUdkTUFDRzlEcVVEblhVV0JXZGtTWmovdTB2WUE3Rk8xVUxXNVFBWTIyMVFP?=
 =?utf-8?B?QXJGN2pidGU4QzVmWXl3OWM0NTRVQWhmbUN0anRmd1V1MHpLaHU3MHVjek12?=
 =?utf-8?Q?BFdbg9zDIQB9UWl3PquHCguswYT42L/U/ecYn8HpLQ+wA?=
X-MS-Exchange-AntiSpam-MessageData-1: ojPWxMPxIUEkvw==
X-Exchange-RoutingPolicyChecked:
	QjtTvcy9yvhOxzVp4UB3f6gCvCOtRgsuHgTnXuGGE94ewXlOzHXb04ZttqLcRAaj/LnWx5dhlvrqymXwWDx3WWU4HOBq5BBuF3WlZEtAY1apJ2p5IVtKHcAlHS2yEeiwAloB9Wp7aVR19W+1/uRTPXM9ZbI/6O9Apiga8Pd7ODdK86YG7gVmdLwEG393Z3lcchv4tZQ5j7sngwBpXpeUPb4KtGHUCmUSiH3ljpf0n1nOC0fnyOCmvXwfC/5t5ojRJ4SOCV0Nc+CgjnnLMPLahHxA1YW7UWNZK3zsh/WmhKL83JoGIFJ2YsLRwEPv/5jXrN9K6nWGdM+vqxKJJ5/L/Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DvDyF9ijLhxANLDv/34xKKNzh9QwPfOtJlecocUOSlaj+tTWo8e7iFk2vGiTAar9Dcdw4P3wcn4RweGbhcXzhoGUFRQStgMMUjfW/KZUn4dQ1IkhoekXkNf6OzsXh6FsEAu3+ZE8SQ+ttBiU9NM7Mu2dW+VToMG+jPxj50RIpQbOFrENHkxHvUDG6wr9hEGhP01CmdqiM94YrOaxr79TfM2fSmkSefkoIZpdZMQkU0JAerlrKea8w+YDBSB9UXWMothLtBSUtKbktHl5dpZm5hTwsXYmMX/LYtls8l5PBL6A1G+U9NGGhX7OltPxloN9KSfBX87XsxmL87awtD33d8rawLOHAxFTjA+aEMQ23yx0UkGD3nNltZ+K8hehwxdQCrVjrhDXDKei+m9r8aBgvVdOrdJZk5FyyeXfckth5npL7qJgnJ7fha6rM6LYaNBbzfrC0Jbio4o5OhP9YinW9S9YfL4USG0gWlaOLUUiylRm96EBR7C1MENo1979gjeZvTSnNYZVv60tfbp+A49mW/4LdHp5wEZ1J7JN7z2E3xbHFVzv1tjHsCcd6DCFOwYoGLzMWtyCWTk6bBf0dNYzgmw2PP4yFWtrom5SDLilRcReR6eIP4vx2bTGdEYhw4Qs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2780b99d-1537-4299-d6a4-08decab15c57
X-MS-Exchange-CrossTenant-AuthSource: DS0PR04MB9439.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 07:40:25.1353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3e4FPppyKLaZI0k+RWpmEYZJdvynstkKk3upJcSuhWVnrn4/7A+SxlrtE6vjqhP6pAA+HsutQ+9u1ddQl0yp/e/2Vuvqswbmifwc0mZKUAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8284

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

