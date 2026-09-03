Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FADA4A0EEA
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 12:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788438840; cv=fail; b=UqrFS7Lkgw0w5odAF4lRvqjLhoEFyVZdkT+Z/O9Wpja7mcXlXBbm9iVEcP1b1dpkOOewbdfSk++lZua06gyueEETp5oj9VOU+WBMHl2R8uzAuzPbwANS0e3xgNQ/Gss3vXWaq5x8lRrWRpzKHlH51VTU6C8Ut1MzN05CEAE6B9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788438840; c=relaxed/simple;
	bh=yP8CeGDzAn+ntQXhYJHNKfFJK3EOJccwVldnzZ0qKH8=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=njB6Feo1ouys3o5n49suAoDMTIeGEngqVwUNdG+3W8MOo9A5WukJC+EazQDUSgmkXNNWVcQN/GIOwUKi6nRpyabaeeEN/cvOGAGNTEfmiAsGVCLxjxiAML+jYsPOpgxHOyZVHayzdkWUGdkWQRFQwdBkPvLdubZCnLk1yYD4GO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cnm8EuYF; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=T5s3uuQT; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cnm8EuYF";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="T5s3uuQT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788438838; x=1819974838;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=yP8CeGDzAn+ntQXhYJHNKfFJK3EOJccwVldnzZ0qKH8=;
  b=cnm8EuYFbHNxMcJ5q80EyoGOTtUNdUEub/smw/DfNhQbJxdLHv/HHsOk
   smgmQ0ymGzucQjfYqgZc/qcWag37uCuLOQQ5l7uWhn/EmlaMDOZLK7kaJ
   5qkDuyh0DDJqRO68afeHEeXEorWb8wCQYwjesiaXCRP4VzKhP0y6cRG+N
   GDoixWrqkgJhsSJWDl/1R5snbsCZYj2A3tvSJ/uW+SwrtioALAdGbKSl2
   Bn35T3Xv87xJcwnf/G8MGsAveLNsgsGDlcbYPVsh7fCscIeR102UVyjlY
   C+UlvHEZK1uKIPa3VXcr6Grio+a3354q5m4bqK4vpAO7eUIGgaGCoyJFi
   A==;
X-CSE-ConnectionGUID: /UzctYpHTeaaupCXqEkewg==
X-CSE-MsgGUID: 5qpPmlPNSR258Frutxs6tg==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="154872975"
Received: from mail-westus3azon11012048.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.48])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Sep 2026 20:33:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RWjvZzCVavcCLy/D1ux58wwuVr/oeA/wdhNPwS38deLc+awMVh5vibMHHp74C73W4FvjJ2FQrZWcZOIxbgkjTvCkDxl91frcKNGFtpbw9JJphlLaeagdMr5Tsh+VI0z4beu8BJrb/2lqdQGhcsLKeJHUJLK7pK+uDfpf8Ovmhc1yT75gSH1i5UoCPe8ow1XWL6UZLmer3Qt3kT39qdQob2wh9zj9hsXthuhQnQTHH3mqlumVEoU8uI0VuxEdzNe7q5Q7jdfYLbuHXd9LQxWNNnEnTy6AFR5Fa64/TQEm4jLLSVERWwX+zakd/D6HZreDQWBLrjRvbRWJQVnxJBCecw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/IEVL5DMOhva7JnXIHA/OOiy2E0BzlInLPmObeNAKI=;
 b=IGw6Zr1k/labNhfBFO0yHe7OmZiFMhWehrNaoTiBoAbo0kxFJKt5rKKnAKA/PsCaK+QBZievLnCMx/4R17Js+Vw161P6SMwcmLCCO4Ned2eJTyeYi/1mADt+TzykfmKjy37YVoEMVXEHx8cKO1ItW5iH76I6Qs5fkri60clZUaSjqdklaoVwuS4MpQCHvHVRAKtPZlUB1y6Za/Voj5fspHuY0PG0fmmFhe6K6q7WAxFWJTnhWyKveM2kZKuhjYcgSvPtrVpHxssDZo368IAxSE9uvHj+TieU4gVjrKoJUXkR0JZq4AnpDrXWh8WojhEre/HSl4qY4xiMw6CPNz+pUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/IEVL5DMOhva7JnXIHA/OOiy2E0BzlInLPmObeNAKI=;
 b=T5s3uuQTIFOsAFYU+icYNXc5xwkTHoT8wbruSO1ljcSNcQeVZwQSahFjRztTCQVEBI26fWb57nA8zecnxNQTaxy4EGgGrVN3yKkbu6+SudPJDA4XLs1Gme/r2zLa+fbHBo/PAsackAxeJnfeV2UqSg+NuMCk6Ywoc96bIKa1t9g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7656.namprd04.prod.outlook.com (2603:10b6:510:54::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 12:33:56 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 12:33:55 +0000
Message-ID: <459e721d-cbb1-4646-8f64-d9a28e50613f@wdc.com>
Date: Thu, 3 Sep 2026 14:33:52 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] btrfs: introduce a new experimental feature,
 RAID56_VSL
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1788417288.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1788417288.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0227.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7656:EE_
X-MS-Office365-Filtering-Correlation-Id: f0d20c67-a139-49f4-68eb-08df09b79eb5
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|10070799003|1800799024|19092799006|23010399003|366016|10067099003|56012099006|11063799006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 hCsHyRSYMC9xqHEzIMfoy74DTnjG4t91GZ0SK0/DV7hNbGZZTxSfBSJmUTquU0sp5DyRqfUXASDwHZtbU112xAjRRLnCNH3jT7mDFUsU7kYd9cQaYgQFbiMUM06PSKrUoMQt2q6M7LqPmydK7mhUkszW5v5YerQ504zML0h4d07whXCI8MAgS2V7v3r464dPzWli8315ARkFrmeZ7mjlRxGnKQJagV9NMqFHggoNYyugqFTHn9uDVZUrduKjm2oGhmW+9B9Zxm55EvIVjNErswNQA8E0ZDcU9yKqR1JpLP/HBkdJ7irwHoc049YG/CzUBl3Sw6o7gLC3INM5u90d95+nnJ73zoHN9HjDZT/j7e/mq330AS3h5vbV0yLt8DFAetOGlP7YALTRp6tWVY3YNPd9TigiiNATPhKkfBvWLpTWvN4eQoGyDB16f9FdXJhBL2bN3rWlF7K9FN46cUdmdtbXqVikD3nODO/x4oXd8P4nmdJ7Qo6t9CfjGhkB+ilijaFJEd8h8jy23dUYqipEapqRczYpX6h/QrqiDl0JpBJZoCg8MMxM+8+SjgrGJaWiI/JJMIJCXkWtH8hgv809wmP/8Fnc/y/WRcHE6ws/ebpX/2p94eyGS5l1AG6tOHNbGISGnmsy0gH/qybStXHhtq1tWzbavHZg3EkKd6LPKhk=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(19092799006)(23010399003)(366016)(10067099003)(56012099006)(11063799006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?MUF2V3V6VTV5LytrTHZFaERQREVaY1o0QXhSaDhLaGpiUkViWWMwTnVlbVZJ?=
 =?utf-8?B?VnBXU2treTBSazFwVFFHdHVsQnU1ME5kT1ExbUlvWDlSaHBTNDc0blpXMVNk?=
 =?utf-8?B?aHNUZ3hwOTdxOEoyNEowb0JSWlZjU1V2eXNQUldKN1ZwUENoMlJIbUNVeDAx?=
 =?utf-8?B?RFh6Tjh1b2NuODdwVnZwZ05rOTFKRzJScjNoVnFYNHlmL01SMHBYQ3R6NUR2?=
 =?utf-8?B?NE9TMWsvL3A3R2NKaG80d3lteEhpeUNBczI2dlh5UWlJRWZzWWFwaWpEV0J4?=
 =?utf-8?B?cFlVaERPL2d3cXJNNUJhaXBDUGJMczVVWHVjVHJ6V1lvWnREQTRocnN2N3VO?=
 =?utf-8?B?ZmIxditQMGhlK0w5dGhRckJ2djR4aHdQMFNuMXkyNVc2cjUrRDEvNlVxV1k1?=
 =?utf-8?B?T1pqeldpVjlLSkQ5NFY4cUxlSnhFQkl2RlQ4U0NkQ1cxcmNhMkJwNWtKZ2ZI?=
 =?utf-8?B?ZUk5bVdEVTdoY1J4QkdLMFF6b0p5R3gyWllIV2dDbm5GY3pKdTRFSHFxMEhs?=
 =?utf-8?B?akFFMkxkNmxIZWx1YVJnVkYvbmFIRzlMa2ZGM2JmUW9WL0ZhdVZmMThBYU1x?=
 =?utf-8?B?Q0pyQm5CYnhqN01GeXV2NE1mLzYxUGdvRkNmVlp3Nzg3S3RBa2F1WVZzKzFL?=
 =?utf-8?B?NnZ6L3pIRlcvM2E0WE02V3FHYzE2MW9Fem5yUGE4YVNZbVAydVNaNlZ5bG12?=
 =?utf-8?B?aWxBWVhpa3RFb3FEWGdVM3BXR3lkaVR4cW1Yc1lSeS9GVHlXVmgwS0RTZDJ5?=
 =?utf-8?B?Yk1Sck5veTAyblNibndITUNtWVMyTTJJeCtCanU0WExFbllBa0xjbDZ0S1FX?=
 =?utf-8?B?TENOVzJwR1lVYzBYVU55YTRWN3NkZHVkYnd3S1RrTVhENGhHMUF2MmRHMWFE?=
 =?utf-8?B?QlM1TDl6N0tydEV5ajdTakFGL0pPZW1sL1MwTDRSZkw4dG1ud1ZOVkV5SVJs?=
 =?utf-8?B?cWpNdjBzVzRhYTgrMmFKT2lrRHAzSmFVZ1NBOUNwZCs0YXpVOUVYS0MvdzZS?=
 =?utf-8?B?TmNBcWsvWXkzdTM3UFRlbWVRT3l0OWI0UkFDRzQwZnZwcyttSXRpeXU1aUpy?=
 =?utf-8?B?QmxiUHdRVFdhRVBENE5hcVdtY21RQkMvL2RJaGlicnJJdkdRbzNEZFU4R012?=
 =?utf-8?B?cmg4ZFN5eVJ4OVB2MlVCdzZJYTY2R3Z1Z3F1TTYreVhMS1V3cXJVdTJOeVQ5?=
 =?utf-8?B?NEtKWWhmMkZxVUFlT0VVY0Q3Mm9QV1FhbThTWCs4RDR3NWs4NzdxKzl3ZlRP?=
 =?utf-8?B?a28xSVlwak90aFZQOWJpSEd1Z0NrWmUrYmZVSCt5U3VuZDVGdUE3OEMwcTU1?=
 =?utf-8?B?TGJQN3pLRkhLVmFHZTg5VmhiaUJycExYRjJKUGRTa1A2OHJ0MEQ3TlFhZndy?=
 =?utf-8?B?aFFpbU5LWCt6MjFKb2pqTE1vekFXSmozMFJITGprRmJ3aG52alU3RkJSL0ZC?=
 =?utf-8?B?c0RnZi9MUy9sZys2dlV5RVFMZUxHempUSUZGUnR2TkN6WGk1cjk3b3R6YUZP?=
 =?utf-8?B?aTZhdkNrbm8rSG1VYTZ1NG12dGNyYXIyT0JxZGtPTVplejNiSER3ZDNkTHpW?=
 =?utf-8?B?azJ4Vmc3cmJNclprMkNoVkdJRTlaUXJQaWdtNVRMY1hVVzJPT201V1ZhVVBs?=
 =?utf-8?B?MXBWOEZXRHQ1WmExQ1huMVV2azU5UUZEb2d6TWtLTlFZMzNuK0NiaWJTamhB?=
 =?utf-8?B?UTBJZXY1d3ZjekppSThxRTAxUlZQeWpONDlyUi8vT3QwbzVWQi85cXBpc3Q0?=
 =?utf-8?B?QUlMb3A3NW8vZncxb3BaUXlERDl1U3FiZGMvN1N4ek5sRUR3b054Wno0Vjg1?=
 =?utf-8?B?T05ZRnJDVEc5MXhEQkJJK3hoRUJyQlRoM29Vak5kLzNic2krLzlyaE1lS2Vl?=
 =?utf-8?B?b0huWlZzclcrcEFjYU04M0hoR1ptSmtlUm1oRkFSRFpVcmxuVzlYRlZabG8z?=
 =?utf-8?B?SEZvSHVERkJmaE9vRjhJbDNHcE1DelhKUGJZbkp3WkR3VDNSdGczY1ZpVVAy?=
 =?utf-8?B?aHJxbzR5cnIzUHhnbDhva3R6R3VpbWpoclNxbCt1aHVML2V3S2ZYVzRRZHFk?=
 =?utf-8?B?aGFmU2hCd1VSMFVNYzdSMStIKzVWcnQwWU1NcHA3My9iWCtXSlIvQk1RelE0?=
 =?utf-8?B?VnhWNXpldldnejVyV2FLWG1RbmhKS2svR2FwSDRTV3N4eHJuU3VEOGF6Zllv?=
 =?utf-8?B?eFArYlZTWmMzM2NFOVo2ejJGbk5EaXArQWtpbzdsUnhNTEUwZkFXUUI3SEI3?=
 =?utf-8?B?NERDR21SVlpRYjlTVDVmSFJJdHhxQ2poUFdGZWVMRHBJZ2w3QU1ITzhObWxU?=
 =?utf-8?B?Szc4Qks0YXlwc0V1dUJZU2VMdjhvK0c3Skxpcm1PaG9JZFErN2dIOE9QaVJV?=
 =?utf-8?Q?H1Yy8AWpTrNqLsH8Q9LpClE4TijwYB55MSPzoUvKbZRHf?=
X-MS-Exchange-AntiSpam-MessageData-1: msCLIf0ohTZScsjkXlncyRMXoLaXb+oTjnI=
X-Exchange-RoutingPolicyChecked:
	B/TZh2KpbhytusvR0EOj8NLK9ot2YOMGVUYaLZw2Yjw0rPaH2fo6cwS3+meCFx5FvKZF4bSsZmbRJeZmraC10oog9SJrzBoKSPL9LfhQ+NyvJvUZgVOmXbhvV9nsvGAB3+O+UYt2nuAwzoRYHRf01vfQVyhKxsdu9nwx5Q88kn7FdaiR8qOCKD4qo38guYc1ZdDntJf6Dn7OpARrll+DJ/TAXPSmIHQx/f13Dzycn0Un7epXsOuUoSgyjn7DesPX4R9MJnfaaONMFWuhrhokjuHVLS+P01bP3+GitrU9wRGpT4dzuMk2tzesvReG0aHbcBLVog9FxT4dQ2i0lIXOxQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V86/hHEP/GsKl5zN/EQLSgZ1Yn90zW1ZgIDVlJfuF6Z/Rmtcw2a/z3Y9IXGeipZlPKNCg2D0EK1I7+hvkohq+/BL8Ff5ulxWInkwL77SFpC/0NJydUO/NKdOkhB3hGP2P50y0Nhubt+i60WcFMI+QQkR2b5QtUdC+ILEsB7FpXPtur6Ou2odhqwKfrX+lXNTzgY99MwffJKaSEBpowtx9YmOykQ47XTarafvBqfZfGgbEIjMEAPFOgSqsZIctqyBjdmPA4M1CnRXC/K57v8A4XRsw/PsOXmK8yTShBBcmTMHvjfk5uaXxW/uG39JOZ2whgYnfmlS87QCGEgRBw/oFOKutI63V9/7mZgCB9SakTJ1NccUnb465lRLAmlkeLfEnYBe79F88W/lNaNQTA/DcgLkBqiJVatqCBwc9vQz1M/8UEHk6N/Fujrqo43RhCdgL9EXPncumDuEaWE4ym60g3HeCtEjb8Ys4XvxBmMgECopd6xvMLNf0MwlypWk51fzRtDR7ZdF+jfcfL7uAARpCi7WL1JlNQXMqiG+QGqre3VkSPqKLA6z22JYYU0Uar0SDztchebqvnX6H6j2REAZ7WN28TAOBHj6oTbstTOGioXyD8H3s22akVW0mjDUexjY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0d20c67-a139-49f4-68eb-08df09b79eb5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 12:33:55.8376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cUaJYfg3i4W2SNLXe3wYzgbFBGhQPHItj2V1IK1gbPVZxRaX4od5XofFZFPl5FYieJCwUMQfnxTD8TUoPnXtVphd5C/wEPNFJ5xKURnKUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7656

On 9/3/26 8:49 AM, Qu Wenruo wrote:
> The new feature stands for RAID56 Variable Stripe Length, however the
> VSL part is not implemented yet, thus the whole feature is still hidden
> behind experimental, and there are definitely works left to properly
> split the 1st patch.
>
> But for now, this series can pass most fstests cases.
> The failing ones are all related to mixed block groups, which can not be
> created nor mounted with this new feature.

Why not make mixed incompatible with it then?

>
> The roadmap for the full RAID56 VSL implementation is split into two
> parts:
>
> - Introduce a new datasize member
>    This series.
>
>    An fs with data_size 8K and sectorsize 4K will act like a fs with
>    sectorsize 8K.
>    Meaning the minimal write size is 8K for data.
>
>    However the checksum is still calculated based sectorsize, meanwhile
>    we can still recover each corrupted 4K sector inside a 8K data block.
>
>    The idea and implementation is not that complex, we're just reusing
>    the existing bs > ps support to handle it (on 4K page sized systems).
>
>    But the challenge is the details where some part of the code still
>    requires sectorsize (checksum related), meanwhile every other location
>    goes datasize for data.
>
> - Introduce a new RAID56_VSL chunk type
>    It will have the following requirements:
>
>    * Can have up to (datasize / sectorsize) data stripes
>
>    * The number of data stripes are always power of 2
>      This is only for every RAID56_VSL chunk, users can still have
>      whatever number of devices in the fs.
>
>    * The full stripe length is always datasize
>
>    This allows every data write to be full stripe aligned.
>    And for read repair/scrub, we can still locate and recover a single
>    sector inside a RAID56 stripe.
>
>    This is less flex than the traditional RAID56, which has no limit on
>    the number of data stripes, but has the write-hole problem.
>    And will require users to determine the maximum device numbers at mkfs
>    time, without any way to change to another datasize.
>
>    But the second part is pretty easy to implement.
>
> As the digest shows, the biggest problem is the first patch, which is
> touching over 200 sectorsize users, and is definitely the source of all
> bugs I hit and fixed so far.


But this is still all !zoned RAID56, isn't it? Or did I miss something?

