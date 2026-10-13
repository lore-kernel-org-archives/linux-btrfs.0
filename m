Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1AA4E325C;
	Tue, 13 Oct 2026 11:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791890589; cv=fail; b=PPBk4mAkaof7dU84tLbSt2RkQwNSKDzmdsqQU/Up2pwMM185u1l5qP3NUoiMwx6splv0hxcWVNvQWll9w6q0B47CepxDmEGvPHu0V/OYwQjDapvaAtPUyHdjsjTPg3e/WSbZJqKzksLWakt9PURwHgZn/TM6Z+o7mhhB0PY8ZZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791890589; c=relaxed/simple;
	bh=VVAYlUitkDDigUtrJZjqHpg24JFeHZpCvcqQiYTV/F4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d1J3wBtjL6yqWCCSTAIo9lKbFO+rXAZBQdlSzAQtQB+adn8dDtUYhTn0CsOPIm7nugvBAkuj0bXgdlZ8OYUGvfyGBfQsF1Ky6RAqWb/WHfp6UFXc9Mz+/NeGM7cz6yFPR/C+hYJlwnfWlUGWiLcsyDyitM4GOQDdofChOHxK7P8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qAFQUal8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=QRHaB8Gp; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qAFQUal8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QRHaB8Gp"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791890587; x=1823426587;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VVAYlUitkDDigUtrJZjqHpg24JFeHZpCvcqQiYTV/F4=;
  b=qAFQUal8NQm3MPTuXdAfKFesq66fX+7IHofFnuFPF1gh3RHi4Jr/ROr2
   Rl3pi7V4+WkpU6yQtklMlD34p2RsZw7B1jqP3rtGJRd0ErjG4QoVPwS4f
   TMxbrSb6zqfKmExLI/OuK8jE5I0MayxtzzULiYwtfaltrkTTrsC6udAUa
   mZ1Y3K0b8iX9zF5L47PQ9z7huwX6qejAeVTVUbzktBWcojqK3Rb8x3SnV
   ajmg5ivJzQJgeNsSdhTczcH8qqOX4oVqsKdX8i8ooHQcXj9IiEXfzYofq
   Al0zxrB44heezmzUK0QHl5cA892Q3XviedSDRu16JzrmhUm10Xmz/DRe4
   Q==;
X-CSE-ConnectionGUID: sJPaUvhnRpy0iyh83+1GLw==
X-CSE-MsgGUID: 5JjF26U8RayyO8vsX6MjZg==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="157020572"
Received: from mail-westus2azon11010039.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.39])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 19:23:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NtTNRu/VKUUJURn15P0cUG8r6OzZ0+0DAeicnheH3sIPumg6rngQoy8C5eHN9w79+hsHQcwxNdzFLukZZTk55dAgtul25y5BIJBfhvZW1XF8xcNhAnL2VgG9SQomuSFypeqFSX6lxsQcDpy1rpaGl6GY+b8GDkjBqK0p6bI+4Gk3GmsaoUX1nhR0va+eqU/S8xnv31qPYACyzgHesOeJTmUa9JLun2QLRCnGU2l3rXCjJRirgz2FdknbSQQEmLfLfpYhERrdf5nKZ8tsllAzzf87H8ZNjbeE5aGdvb9NEaBvdqf+cWtnB9jhCzdcSADyJWKwjSHHuVjlXK38oS1wHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0waonraQXI2fPFIJ11QCQsEcOfTR3WxuvcdJDM8S6A=;
 b=K0m31Pfv9iZDVxam4Y2z5Dr/WyfN9EK6SE4tdlNHTFlkLLNdQOdte10pqYxkdMXmv31fcscpKUdWxieXwSl16rjQfaze1sz9BwyJvo90MriKqR0JpAHG6ZmHnkiYTu6FBRZIvr5ENQEgsq8Z3taiE6PmeAQZeCeHFX4pCvrj5GHCPIlg6CjXXXtVAeJzDphpkueoB8t//P0KyE1SKQPNU0bj0cdD0EARXQPslsGW6HKTa2HsV+MXtGJj3gcDW6goTgF6FF+iQWB5cxqQlid3za+DOSxUvsTr+B0AjH/0IRihqxsdU9LNJpYP5kWKqbD+vpZ/VDcUa5kwCoekugJrwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0waonraQXI2fPFIJ11QCQsEcOfTR3WxuvcdJDM8S6A=;
 b=QRHaB8Gp/7c5AMQoVaGRWlSS1a97c5RbFpBrC6Dh6owvtM4nUuJT2g5ZJ18/AZ9v+xAiTpQFow3NeBqAKHI6QLu23IsgteTsBILDvTjRRmjQ6XZAwrTnuG5aEVWKPwJXh+zahyqbJVxIjSC+kHSpsasuCLkZnWFWsOjBogy2OdY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6527.namprd04.prod.outlook.com (2603:10b6:5:20e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 11:22:56 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 11:22:56 +0000
Message-ID: <ffd0d208-d6e3-41b7-81c1-914fd1e48de4@wdc.com>
Date: Tue, 13 Oct 2026 13:22:49 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: unwind device add when sysfs registration fails
To: Daniel Vacek <neelx@suse.com>, Adarsh Das <adarshdas950@gmail.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, mason@kernel.org,
 syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
References: <eb63c9f9-a158-4a70-b3ed-30046b15de11@wdc.com>
 <20261007160349.22411-1-adarshdas950@gmail.com>
 <CAPjX3Fd-MEY5mMk9eu_3ukhZ7yixhWSqECEALCAVFHA0P6HYDg@mail.gmail.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAPjX3Fd-MEY5mMk9eu_3ukhZ7yixhWSqECEALCAVFHA0P6HYDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0246.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 99b44a5c-3451-4b7d-2b48-08df291c546c
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|10070799003|19092799006|366016|1800799024|56012099006|11063799006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lZNxpKknLFqI3d4bW9bdaqJ1OxtypLdAvc8V3XOHq9ekhMIg12v+KKzoBg0Uf0N6BNiqA2Qd/UrEvG2BmIGe/FJhCJuo/Gpyzk+B0BwMNz/ZoymRPXDhsNCgBAP3MmjWXH+Mx9u+74LkiESEzIXHPSYaOfR5KMAlicLilW4aWqLdgQ57ir6SttU+Pp8nAKF4MO4lxW2EHFYdZX0cRdf7QdA1jteNIA+Jf4+j7qS3bNJTKA1k5OqvHp7GaLvawRhmp/JBvD+cRHV2LjH4HZBcZ1JH3o9hB2IkBuJh0/uIu2gmazrdutH8gaF8DnG2Is8jVckUKGv+XMESXa28DqFel7Z8g8lFVwFpZkwLqexpORb6kx6+NGLzA7C3gw0tUI5J1YugLYqdTdyso42MojLRHGvWg+B9VZGP4qXFLcMSqc9xP0OcqVMOBhbjYLiqIvaF4f1Aj8pT6S1It0o8GBzynh5fZj8QhVlvpt80UtTATBfXYUspgE5lhsgubzf8I4byM1Ur34+2SniI4isMRg6hYIZGVg//bjI8ZFwcPT5bmoA+D49eGdN+sajBf/j4j1OsqwCmGuDTUaF40r67TBpFcitfC7tNoFrCpZ+QT0PoNARdHRIvhBWoQypIeA94yikd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(10070799003)(19092799006)(366016)(1800799024)(56012099006)(11063799006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWkvUnpSY3JYSkVoNDJGMkkxTkMzczNIejdyUStqdDMwMGwrMHpGMlZ2Q3lz?=
 =?utf-8?B?cldzTXh2ZFNKM2p6cVNSNkVhYVJkZ2IraGRRN3Nzck9JKzFGdS9kME9OK1NH?=
 =?utf-8?B?cVpFTWJpbkU3bXVTcVNaczZsNERjazRlYTJVN1dwdHZzblE3bk1JTFhUSlFi?=
 =?utf-8?B?WXVRUWhXYjVDcXRLb1J3RG5tRFQrUXh2eGR3T29TUU0vV1FQY3FMbDNRSTla?=
 =?utf-8?B?cVRMaDhKbEtBdzhKQXNBQXR1b0hoaGFOaWh6Yno4SERmU0EvUDZxSWFtbU9I?=
 =?utf-8?B?b04vVUhkZ05WcEpOTnUzelJqTHo2NjAzd1VoUnVSaUM2RlZDaXg1UVF4MThX?=
 =?utf-8?B?M0ZOU0w3SDI0aE5OUll5NmgxM0VQSmdoRnVIbEh2dHlyZkJzRjVwd0l2L05F?=
 =?utf-8?B?aVdobU5aK285Z2hncHhkVWRId1htemVPY1dXVXluSitGYXFSOGVGK3BEWndv?=
 =?utf-8?B?SExRdTcraHcrVUlyUE5JRFFnb0dQSElIZ2NCZzg1MVlOSUxGYTlVTkFTSWVl?=
 =?utf-8?B?MUpaOVZOZDU4bTNMS3ZXK2Q3NUVxZCtodGhGdTk0b2I1ZmV2UlpteG1VZHRM?=
 =?utf-8?B?U1VaSitkd2swQk1UbkJhaFZZZWtjVk4rRW9id1N0bUEzVEpxMW9yK3g2VmdO?=
 =?utf-8?B?L2lxY0U4M3M0d0tYK3oxcmx4bzMyMDJ0UCs0WGorWlNRT3hDL29TakxnL3RE?=
 =?utf-8?B?a3FwZ0F5OVB4YU9nSCthT3ZRUGxkekJjd0NFZzZrbXQ5ZEFIMGhVZTB6cmwv?=
 =?utf-8?B?dGNRaG11RnEzd1p0dmYzMHdseXZqYklEY2dwdW9hZG5BNEhtcTY5WGtMUW1o?=
 =?utf-8?B?TmdGQ1QrUkdiU1lNeWs1NURrRGRjc1QxUnBaUGdFMGJVMlIvLzRJRkYwSjJN?=
 =?utf-8?B?ZmgzL1BZMzRMdkVWa2VFd0s5NDVjdGUzSXB5QmhYRjUxN3l6c1p5Z3ljY0Rj?=
 =?utf-8?B?QnZHMFRLcXF6RlRxdWxRYTM0elBmazBBVnFyRURsT00xWGJaQVM0SlAvbFVS?=
 =?utf-8?B?ZDIxOXhFTVlnQmVKVE1zemZwZkJraWd6UGhQRVhtNDV0WTFISDdaaUdKWUFp?=
 =?utf-8?B?VFpRT2JoVnpjM2I1ZVBvaGNveEtjcGhLb1J6Q1RuVGhaNXllUG83TjhBM2pS?=
 =?utf-8?B?MCtEcDFzZFdBTUpJMGpGYVdnR21OT05GYndOSzIxdHNLR1Z1eUV5VFh0ZWdw?=
 =?utf-8?B?OFBpSjk2NTRjNDBKRkpzc0xvUENXRHJWall4WUFraVdRNzhQZHpQQmRZbTBO?=
 =?utf-8?B?YXN5L0lqSHNGdE9HemNQRzJPYlhXcTZoaVo0QmtWbkNsdStZTC9VUlBBR3ln?=
 =?utf-8?B?cDczbDgzQ3lKME8zdjZGK05zRnlVeUlPdzdObjhQdEpYQndjRlc3djlGbVBr?=
 =?utf-8?B?dTJ5SmUvN2JvaW1yUG1tdUJ5TG56d1JDbTB1WUNwR1czU3JzNFJQdGpsZFFr?=
 =?utf-8?B?cjc0Ti83cmRMdm9pbENQMXl3aEM3dzlIYTNoT25jdnVZWVpSZFkrTVA2WjNa?=
 =?utf-8?B?a1NWR2lZR1YrN1phcnV5b3BpQWVYSUg0SlQyR01leDl3UEh1bVRaem4wZkk2?=
 =?utf-8?B?M3lheGYyL2p5UEhCRHJxYkJudXJpNnA1Tm1PMG8zQnFsdFYvZ3NMdGN1bEFl?=
 =?utf-8?B?RkhZaTcxZjY1cDFyekRkaFpmdk9UaGY5NTlLeXVnRldFU0t3Tk1sZlJ1dGFY?=
 =?utf-8?B?aUs1Z0dyYW9GeDRQZGIzajZBMWlTa1VrM1g5Um1EZUFnL0ZHb09FZVY0L3Fa?=
 =?utf-8?B?WUFjeERNMXVlTHNYOTdVK1F4STZYemltV2cxUmU5aW1ZeC92NTY2dVh5cnRX?=
 =?utf-8?B?MHZUeW5FOHpZK0d4YjJmSnk0Tno1TDY2dDlRenpnVGdxUnBuU0p0OG5vRGpa?=
 =?utf-8?B?dGQzYXJLYjVSa01BOGFicHhVRFg2UHptd0FCVG1mUVg2ZXI0YTVLVDRoeGRi?=
 =?utf-8?B?MjJHRGRXVmxXQnVhMHlSTzlvY3JrTk1jLys0ZnFXdndkWWJRZ0hjbURXa0Nj?=
 =?utf-8?B?WUY4L244ckkvVFFSUFBUeVpnTzA3Ynp5bEtwdFlJb3FXYlB6Y0JnbHczRmNW?=
 =?utf-8?B?YTQ1Y1ZCaXY2NDRnNG5YR2RjL3llelpjdHJHYXFmQnMyYmxNc2pnT0xMVkpK?=
 =?utf-8?B?TWJweTd2MWw0RmpkamZvWFNHS3dkWS82eXY0NS9ORFlabjJoSWV0UVFCSDdL?=
 =?utf-8?B?ZUJQWDJOU1FxYThHbUd0NGdJdzNnNjRBN0owV0VjME8rdjhaYVo5TXhBbXkw?=
 =?utf-8?B?QkZ6bjN4bXZmUDlIaHM4cit4WHZTdmlud2kzdEM5MFBCRUt2NUovVHh3TGhv?=
 =?utf-8?B?ZSttYkRPTDhQVlFWbGZBK3FySEh2bENkWkE3SXVaQTB2T1VXanF1S3AvbndW?=
 =?utf-8?Q?K5vnz/o2lxnA2uHv2ltKH4c52obcQ87o6msLL5b4U1YNw?=
X-MS-Exchange-AntiSpam-MessageData-1: WDWvnwG9bf2o2Gv+frWWbb+//fwuzIh6RDE=
X-Exchange-RoutingPolicyChecked:
	nsEn7jDnYTEy23FOwz2kwENxdfdYNugVeEpdBeyMmQ8NQ409eP12djrzlY7BcMNVvtUyly9eXHWhJphsu2DAAa/h3U9s57I1s4P2wMSGf6RTpM5IKL6bQ8iWA6fn8G+WzsOCB8u3YLk9ulXUqSBn7WdRT8euFGq+qLwf8L5Qh8KWH6jYqMMvYr+SmrjXaLdqqBJzu/58AnHSyNuNiGwaroC/6386/3XSXlI8T4IfQLZ8kMBVKJiGKVTA4m1G9j1O7poGEs3x9C0kirHqzBEPYYCFy2Kk6hlYCaO1ZUT4MaMHli1aglxS4DykO00E0wvfHaocgPgyOuFGSBc56QHspQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JjccZCBHuGVNrs6ZY2Xk+J7sPY5FaWtk/Q2yaTPkjlZ5Eiuhs2ZbrsTL7pmHTpML/jWWF9wRqaI049fNFHfRppdmhbyz8ux451TSuX/QyiyDGDwfu7OIid4RDCrB7mxNv7Q7Qwrql4SKiwQH5Oc6cg7nA+auGXp6jo+lbfq7PZt7t8l/LvBqM3FhTBjJNcptiKqCCyjuhf9m7RQhPVgA5v5NTQAn4Hbao+/Kjk0qvgoE9IIX22ooZOjI2fG6yenscwi0+jIh5duM6MBXJ0sj6DnjMszTFgZucZ7xVLaeQHIXDD+eWI2rQOXvv75elpWpC9KYJty21ZvlgRXWDK7PKVc6wdGuLBbyfS1SRcyxXehGUyU6HdTnFSOSgVDiLrfcZFY6iVMFXvV/P9glFUcu2reBiMMaWTlu101MQIuoW1CqlIZE/PYjEk1dOvBy4Pd3L7l7p6ggsHnFk3Q6OpfEwaRcOn58VUzRc0y8GD9IFmFOGLuFYTuWvY7CqbPtjw2DA2k4m7/K2RsmqCPa9woJ5ztWyGLORL4VYj4CI4IWz4oIizVleqoWD0ZzAsXEHXPkCO598ekTGMWIr7TFNLoX+Fno+s74kQ0J4PdakvFZYSYUR1fZGnWO19cWuQUD0ald
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b44a5c-3451-4b7d-2b48-08df291c546c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 11:22:56.3958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4iXwoll4LTwbtfKx9GIc+zC+s/AlN96m6f0QKP+VXtzOp0RDxT/CKe5TAkvwHlzGJXDalgD/quuRqvgHUVC2qLKML+BHZl8kEPC1eIQTydo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6527

On 10/13/26 1:13 PM, Daniel Vacek wrote:
> On Wed, 7 Oct 2026 at 18:04, Adarsh Das <adarshdas950@gmail.com> wrote:
>> btrfs_init_new_device() ignored the return value of
>> btrfs_sysfs_add_device(). When sysfs link creation failed (e.g. -EEXIST),
>> the add path continued, aborted the transaction with the same errno, and
>> tripped WARN_ON(btrfs_abort_should_print_stack()) while leaving the device
>> half-registered in memory.
>>
>> Check the return value and unwind when registration fails, without
>> aborting the filesystem for errnos like -EEXIST. If add failed before
>> anything was published in sysfs, tear down the in-memory device state only
>> and do not call btrfs_sysfs_remove_device(). When the block-device link
>> was created but devid kobject registration fails, drop the link inside
>> btrfs_sysfs_add_device() before returning the error.
>>
>> Reported-by: syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
>> Link: https://lore.kernel.org/all/6a791c94.01d0871a.3a0d52.0099.GAE@google.com
>> Tested-by: syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com
>> Assisted-by: LLM
>> Signed-off-by: Adarsh Das <adarshdas950@gmail.com>
>> ---
>> v2:
>>   - Unwind without sysfs remove when add failed (review on v1)
>>   - Roll back block-device link if devid kobject add fails
>> v1: https://lore.kernel.org/all/20261003111951.24527-1-adarshdas950@gmail.com/
>> ---
>>   fs/btrfs/sysfs.c   | 3 +++
>>   fs/btrfs/volumes.c | 7 ++++++-
>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
>> index 39cb01ee441a..2f034689e71b 100644
>> --- a/fs/btrfs/sysfs.c
>> +++ b/fs/btrfs/sysfs.c
>> @@ -2165,6 +2165,9 @@ int btrfs_sysfs_add_device(struct btrfs_device *device)
>>          ret = kobject_init_and_add(&device->devid_kobj, &devid_ktype,
>>                                     devinfo_kobj, "%llu", device->devid);
>>          if (ret) {
>> +               if (device->bdev)
>> +                       sysfs_remove_link(devices_kobj,
>> +                                         bdev_kobj(device->bdev)->name);
>>                  kobject_put(&device->devid_kobj);
>>                  btrfs_warn(device->fs_info,
>>                             "devinfo init for devid %llu failed: %d",
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 85ea9c5d4536..56b38f012093 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -3066,7 +3066,11 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>>          mutex_unlock(&fs_info->chunk_mutex);
>>
>>          /* Add sysfs device entry */
>> -       btrfs_sysfs_add_device(device);
>> +       ret = btrfs_sysfs_add_device(device);
>> +       if (ret) {
>> +               mutex_unlock(&fs_devices->device_list_mutex);
>> +               goto error_unwind_device;
>> +       }
>>
>>          mutex_unlock(&fs_devices->device_list_mutex);
>>
>> @@ -3147,6 +3151,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>>
>>   error_sysfs:
>>          btrfs_sysfs_remove_device(device);
>> +error_unwind_device:
>>          mutex_lock(&fs_info->fs_devices->device_list_mutex);
>>          if (seeding_dev)
>>                  btrfs_assign_next_active_device(device, seed_devices->latest_dev);
> I'm wondering why not this?:
>
> @@ -3066,7 +3066,9 @@ int btrfs_init_new_device(struct btrfs_fs_info
> *fs_info, const char *device_path
>          mutex_unlock(&fs_info->chunk_mutex);
>
>          /* Add sysfs device entry */
> -       btrfs_sysfs_add_device(device);
> +       ret = btrfs_sysfs_add_device(device);
> +       if (ret)
> +               goto error_device;
>
>          mutex_unlock(&fs_devices->device_list_mutex);
>
> @@ -3148,6 +3150,7 @@ int btrfs_init_new_device(struct btrfs_fs_info
> *fs_info, const char *device_path
>   error_sysfs:
>          btrfs_sysfs_remove_device(device);
>          mutex_lock(&fs_info->fs_devices->device_list_mutex);
> +error_device:
>          mutex_lock(&fs_info->chunk_mutex);
>          list_del_rcu(&device->dev_list);
>          list_del(&device->dev_alloc_list);
>
> --nX

This would remove the need for the lock of the device_list_mutex indeed.

