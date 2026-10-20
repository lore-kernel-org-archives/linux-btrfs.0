Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792488378;
	b=rv9aPS5DhWTiV7vu9vUK4SC8es639VN/+i7uNcZ5oK+pIhAdoZCr1mnjj+3Q6FXbBrCB
	 WItfz9X5dxb81zLYypIrfymxPsuMHNi48c+xv1Vagxnvd056QFZIErGiCZPlZ2SDSqw8L
	 Ownh0QgWez8y5bnevZ0ViWX5ewX80w+Swm72vJeK9j7Dz0wA2N79lVNbAdhuciaNJevvm
	 0GBgLq2+Xe4q3AxHlEb9DsXXejOXHf1tm88iQPUy46If8I2gGeZ+mMHO7SMRxW0VA+cWG
	 UhQAAsba8FwAsrtDWs51JV4/dB4iYFzC+ns28BGkOKcOL2WzFqiNDamFzJAItKO+0Zg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792488378;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:References:Content-Language:From:
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
	bh=7yge9Bae/taZcyM8A9GLX6oA4fwWISuM4iXymNHPu9o=;
	b=Cy2udHwO7Jv2d1EJZ+CUDWhdek8V9v/BP3rnMugDcMWmoIlkTpYtO76FHWQ6FG2k0XFN
	 Hikug2uR6SqcccP76K1A8r47Srjuxomie0NsBvIDcQHPsfGUIYmFuPuzeaLIfyP+e+n33
	 adKjervX7JrY2W4EA3QmLSYgeM8ciq0WCUa8Ok+UudqRaoXPlsq5RbjOFK+qhZAPqUeOh
	 lzWyD20UpQmgcMndkmcK50gw2+w8fQpnOA8QKqui/bMf1+TiK+sb4GGrmmQMY6CRRZIn2
	 ebvgiL44w6X0iiKD5Xo6JdAstefpfijFxLPK6vTaluAY6JKh0irFpWK8FfyCMK79lkA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=TV1ssq8N;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=XUDq0zMB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F57606A31A
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 09:26:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91F57606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=TV1ssq8N;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=XUDq0zMB
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792488384; x=1824024384;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=21eemjj29BW0wYFt5JsZd4wx2dV7vzJLU8RZ5RDsrT0=;
  b=TV1ssq8NBICP7KiH14uuA21PiN0g1+6cvCGpLDJbY/JUT4YtJH/kXx1c
   HPOnhdAwfDTbMy2M4NVjhpdNWEaNuVVImTJapBwiXKOZfXlf1w/tU4yqi
   N0ZPA0olXQ6WCztt3TFu/x3toyS4zHYUOXKXrKN4yo9iXaykZclSE+8dG
   mB1HURoZzSWjUni81swXdZH0+HY4aHzJrQB3Tn0ikPivj5gfYnjD0QnRg
   Pno+9lij39ti6Af99+9H/TJwpy/4AuWXwmcrA7UPeJw+sCTtsK+5ChzB4
   c8xg+Wd6UBy5OHqnCNlvmkNlziI6I+/EGjtTn0MYk2LV0YaAELmNQJ6fg
   Q==;
X-CSE-ConnectionGUID: lb/cMuB/S8S2zhLFMLFthQ==
X-CSE-MsgGUID: 5El+xFF7Tqaax+zNXptkCg==
X-IronPort-AV: E=Sophos;i="6.27,168,1786982400"; 
   d="scan'208";a="154307676"
Received: from mail-westus2azon11012051.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2026 17:26:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WM0WWeX228qxWOh6R7uFQiPANftx6TG2ez63dPw9aTj5Pw0rt+spfYA9+0YWcZH1fWLmH6Ck+hNlzQbFjCAi/pF2BVpUFx2j4STj1JvFgX4vOtPdKpcAwkT9cj4We6Xn5MA6EtPr63FrJGJCInYLmPTlRWE6XeSS0fAN3hFdNNXn/i8Q8ePJQgD0O7HPEipkdAHLZj2hvpnaXc6OXdhGlWkZzO3z84YKWyeVX2n3vipfxJ4s5yrCFXnRiIPI+ldOngYPRuHHlooQmnmhjZuAfr22xftc8RPcGimu9hE5BQCUYhjULncTqIetV41UFm+Ek600EfinuLYoWO3VH8krUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7yge9Bae/taZcyM8A9GLX6oA4fwWISuM4iXymNHPu9o=;
 b=SNHzJ4TlGnV3Mvm0kr/7ObAKTf4512vHQfPKdTUlbc457cRKZkpdTkXceGHuWY3T0GAHtFFNxPMO/wB4p6TCpzMHLN1i821Y4jiygZzXWWYZekDpwSeh7tfG+XMtBNhVDRG8/2P4qwbL5h8vCl1jTTTLi8l4YEa4SCSi7NTjTf09KHRtqB+8jb8oj3Qs67GPVvrYjvy3MySl1bn5Ft3GaPaSBCDjxAYcJtQZ/FT0t4u6RyFEsRJOgeoL8KVuHgLE0iokDR21955IQqv7EGWAG4CQqvpnu8HnDjlzT6fBI2mXUipfwywumiCRwXuNk6SXcdiZiaXsBt/7JGElpQAOfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7yge9Bae/taZcyM8A9GLX6oA4fwWISuM4iXymNHPu9o=;
 b=XUDq0zMBqbAQmBWNphyp0wkt3S9ft4McUbofxsiJN02RSFtsk/kfsko42+EK+mNXSDUeJktUFz6N99vCPPtyfY7RREYncWvJTvmaO0TO/b14HzPu7yB/qrZbyDqiHptXD5dKIyCoLni8PAHzm9p7BhUII83CCuC1vRzgPXb67hs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL3PR04MB8139.namprd04.prod.outlook.com (2603:10b6:208:34a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 09:26:08 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 09:26:08 +0000
Message-ID: <ca6f02ee-8b39-4e90-9006-a6f0606e26f8@wdc.com>
Date: Tue, 20 Oct 2026 11:26:03 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
To: Jochen Philipp <a2jphilipp@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0089.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL3PR04MB8139:EE_
X-MS-Office365-Filtering-Correlation-Id: 7df860c6-405b-4317-6dbe-08df2e8c2c24
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	eTLy8HHOiauIfUeqKWF8gmUVCZUMBy+8U79DtyBIKtfV3PcOO4ZlhT0o0yx7z6qbb0X0pviocnJP+03OmvDT58ipaxdkknasYCJwjPVVWURBgde0eOyKqEAA3+lSYb42NTKCM6medzfcufcVAqjCHNvAGHRtUWA/WfLYJNJXcK9+NqMVJU1TSl9ub/jVCLsEJBKRrkVKhq19A0PbnXqZt1908PFWPs2NOBPESuY3XuEdH/aMMQvTUv8wsp9xZy08a16H/kWoy2lQg+RzQZMIpj60jG43t++51/4OJHI84Pt+aJAYnK3BDRStdXagjRXqKxpBULRQOAsn/jgOoq+mQRUiSc5ZMBv4YJE1ydYnh1uCy56dFKqGjgGoUqm9DE+koFXeQDs/2qhOGy2VjVFaExcCKOtUVZgP0Kix9HZS4UIJaDwMcOWYyRgHIuJoyib3ybAvg+tm1jGPb9F5eUvKhTPFgP9CPIpobFfZW6MpDbt/AXNcgyoMP15y8BhQCvJavx9F+Maq8gepPGyIUvoRaYu5zkWqdieDsCzhKR8TKpOxwgq035ioEFdYshKm9FWRTciGPH8HnqO7UCl2GfkTnpDdAlXILl/mO+rxylpRikIg0rcgYsVyhh3xFhhomctlauiJTqeVfbq6cgKb702QUJqYgw1sQZvbtACSFXgbIGI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDc5Q215TXA5ZHpFdGtHQlVkWnVoQzJtc1lGTDVxZVNOdGtwYW5sZEZOVkpD?=
 =?utf-8?B?dzhjRjRSZGR1blN3bWdiRXVwTW4rMVNCVHFkU0drM1VPbVF5MGc4aS81WGh2?=
 =?utf-8?B?aXJjK0Y4WnRBeDU2SEF2SElnWUJyaEFVSEJhblVvNGhtbURmVjQzcys5R200?=
 =?utf-8?B?UXZqMnpGaGZsaVlkelV3a0VHQ2gzR080NlVjTlRwOGhYcnFMWmV6QW9ZaEhl?=
 =?utf-8?B?UlIwNlgxZVBheGM4SDFUbjBsNVJGQTYvYlJzQWdCR1pTY2VjS0grUmJYQUNz?=
 =?utf-8?B?bytmVjdYamJIWDAwSk9WbnMzM3ZKckRZQ3ZFWms5aGJCWHlkNEVuMENEYzdD?=
 =?utf-8?B?OXdCUzZzVFBrUGVaTVJBQXh5R1pwRys3U1YxekJoaytJWE5xVEZvRjd1c2FO?=
 =?utf-8?B?a3Njd21zbnJESS8yd1EwU3lLUEZkd0FUakdGeGNQQnRoUi9ua1NoazZjWUJG?=
 =?utf-8?B?aWhyMUhCU3hGSnNzcWgyUjlyYnRkTWxaQ0dnUXJ6SVhPcCszQ2lJNG1BL1pO?=
 =?utf-8?B?bXlOSTNzbDgzRGVVdzRTSkJBQmtZeVNKNkRWTDJsc1ZlUGthU0cvUWYwLzlS?=
 =?utf-8?B?MkJzTlkxdlJLUzQ4aktIYmg0YTQrQWZVS1JsRzgwR3p5TFN1V3EzN1NuMS90?=
 =?utf-8?B?QStnQkJPaEJKcFM0dG9ENVIzRDlrdXNTQ2xWaEduQ3AzYlhPTmJzbDE2aFRU?=
 =?utf-8?B?a1BoM2R0Mm1IQ2wxb0FoOFFzZmJKZGI1V1JNMHcyQTBvbG5jN1FxM3p3ZlJD?=
 =?utf-8?B?UXJ3MnNVR3BhVUl6TmlPbFNsK2ppSmE4RUQwbHB1K0dpcDVNRG9SWC9wV0Qv?=
 =?utf-8?B?RVNoczBhUWIva0p0NStHc29YT3RzNFhVcFhIcVIwYjJ5TXNWM2NPMmUwOVBl?=
 =?utf-8?B?TFJnSHhDVTcwL0dSQW1oWW9ialBxTng0M1piVlZRRjkwalJnWW5nQWVhZU9H?=
 =?utf-8?B?SDluTExSNk1sVkNDZXl0UHVEMWlCUUVpeVJIWXZVRnovN1JhUW5lTnJXVXR6?=
 =?utf-8?B?V0NjMUljanpKV1laR1o4UFYxTmxnL3BGbXFGVXJRc1dEaTFhM2RGbGJFMTNN?=
 =?utf-8?B?b0RCQ3dlemRzRXZTcm5SOFAydGZKcDV2OEQ1NC9nTmVsTTZPUHdrNE90Q0Y3?=
 =?utf-8?B?R3B4eitNU1VRRW1nKzlCVFl3dlo2ZDl5UGtsQitaUHJFRFdqaHh1T0tabWVG?=
 =?utf-8?B?dkVoeGx6STZFRThyZTloOHJqR0dnNVdjVmk0bEY5WE5zYVdjSTgxeStMeSt0?=
 =?utf-8?B?M05TOWZCajRxdGVoZWRhNmMwUFhjU2F6OXNxWER2d0RaSDVkTUZwSXJOSU40?=
 =?utf-8?B?QTczOHJ0Z0ptSVVWYnlVVTBlRWk0WW9tZEVNVzNwQ3dXSi9wclg0ZjR3bXkv?=
 =?utf-8?B?SnNDOFlIK1BMUmVGd2V2dm5Pb2J6Q3RSQ2xQNGFXZ04wbnpzbS9qaDRLcENS?=
 =?utf-8?B?M0pZUGNRQ0VhVFhNVjR5Q1IxNzNpY1JyalFWbWhTUjlTMnVrdEo5QzBCYWtj?=
 =?utf-8?B?NzF2aGJSTDlQNFVlSDF6RGtHT0p2QWRmWm1pOEFqWlBTbjEwVHozcHZhdjlw?=
 =?utf-8?B?UEJYTWNqRGtBcHpQdEwrSWFGR2w3RTE5YU81YVpJdEErTExkOUNQZnNBRHpo?=
 =?utf-8?B?WHN0cEgveW1QZ3hqOFp3aFlvUGdUbGFBOGw3YnFjVTVVNlRXeHdvWTNwaUpT?=
 =?utf-8?B?RG9JZmR5Z0NNOVlPcElrUUVLejdUQ3REdGZrKy9KcmhpcjNYY25xdzVKVzE5?=
 =?utf-8?B?N2NOOCsyd3E4bnRHTG5wYzZ1Zjgwc3FES2lKUnhvWENDNWRhbk5JM3FrU2VV?=
 =?utf-8?B?dnBHRWpPUnJibnNNSW0ySC9GdVBTbEd1dkNML3ZUN2ZiM05GdXlpaksxby9K?=
 =?utf-8?B?SFZJdldtdmRWaEpkY1d5ZW9LRlNuZjNML2lJS1MzV2pRb01qR2RvOTlyTGZU?=
 =?utf-8?B?WlV5WHE1N3N2VmN2UTRiSnBuL1hUbmx2R1ZJcG1VK25KSkplU3pWYnlYc1gx?=
 =?utf-8?B?NjVUODNzbmhWRTIxVE5SQkgxT3lZb1BKTVd0YTQrOGliaVFGbTlJaklBdlpX?=
 =?utf-8?B?czhrcUtmRWlkdGRJYTlnQVZ3WktWMW5UTVZrRUJqbGhrQUI1MEZzMXlxS1g0?=
 =?utf-8?B?bW5rK3dYVzk5QStwMldwRHJWZklPL3JJRm1NOUc1YTg3ZzNjVG5hU0VhUE5p?=
 =?utf-8?B?YlgzQkV0U1hzT3l3aDVHbkljMzRBWXlUS0ttVU1EWUJaQ1R1VGw2Q0pxQXdN?=
 =?utf-8?B?UG9pem9OZnZ0cjJTUmJIdXAvL1BMMmZlZnNyelVkcEwvVjZxbTlpaHFIbmNj?=
 =?utf-8?B?MDBhVDhMSUdjaWFxQmxIVWhJYmVqTkVVSk5tSXpUNTIwS0E0TElOaFVmbGxV?=
 =?utf-8?Q?xVqIK3FJxf6b5qpySr8pvLbQONmtkOPvD1L2mXpePqQqn?=
X-MS-Exchange-AntiSpam-MessageData-1: qs4lsLW+cOj1fU6y/JKkZ06Tm7Q2tlMJvTY=
X-Exchange-RoutingPolicyChecked:
	wtDmWufqFqJ0IJOZeaLIMz6adJ9u3q2eFXcB7g+4NtYwZmmxGAD5XRzizLy5hOuLbycFaNvX8XqucexIMGHM2bOdMIcc3eo/5LnTloV4RDSk+GXnX1uxftfxOykEeiz80VvDcOcJYa7z009NMygURzr2YKmoTI+QOlixFg6THPgIWKNHDT/ymplKGOHC+Zm25Hlqq4qr/d+lqC4H8ZcxSLkOrMg1nHWtemj3uL6QApGFW3Nlf2sfLm2wtd6LpVwgr935I82NIxeYrWZ8aOrgDk7O/SN/9MmrJBxOSWdODTnCkYosnHYN3DEDZFhpvP86YPTF2Q8hh4bAx9+8DUYukA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EYV/qL4DGYALj0XIyTIoHUL7UGbS1Ly6rmxoRICf8x4fM5g3Qbi/zrdIN3MBNlzaKoQCuM453amTsnAU5aJTrBIe7EKS+J4svPn8quoyeBd32+nxfyp7lqYwyKkwlxweWpU4ISljz/6PwiBezRgyQjEskNa6X2FUGH0oiR/lvLF/VXyls2Qvpk2TtUsHoE/RGkdnNuBxaEbNlZ96t0X++NgtlW48k7pstgL+XqLnqsnaX6rI+ToUuwtWyUw6AO48jNBWV+BiVFD/Rjjx8L7faUsWDsCBAJH4nFr+5pqbwBZc+rjFljIWH+VjqWwWSpVC4TDdfudvz/sT8iXDTSWRHDe/KtGarVpiXfQkOD89biImatvbWGPYhtS1Imcanbfza+rdvbUK8HoOs6zNISoa2T6mlSvrmhgOMpZUyBqNRmDIJylGkJzf66JB7OUXe+bil4iJi1k1wYVtwbxny2bCsCxDDfUxtpeb9eHRAxjf8eeRJeXBoj8n6PhZXL54jC6VlnOf/2dse3Mc0RoJ2VoN+Hdt8/V4EudrNN6Xv6Maju0ANPJbKe22T5aDLankp7FebgLYMrc/MQ07Qn0xMp6hyjmzdNUHT+X1epKljubeiyZPKyMsv9lP5YQ7RbRADEB0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df860c6-405b-4317-6dbe-08df2e8c2c24
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 09:26:08.2953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K8CjUzSs8i7aV3HF2ORXH0fNNRB7UxIZVH5KbBExIXxxtff+kZmTu/iQ/4l1udIX3JprgEoS3X5VcIIwSW4YK5HaRflnIfUuepI/B/mN68w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8139

On 19.10.26 16:31, Jochen Philipp wrote:
> Hi, I'm hitting a reproducible transaction abort with -EAGAIN on a
> host-managed SMR drive. The filesystem is forced read-only during
> plain sequential writes. Hardware: - WDC WSH722626ALN607 (Ultrastar DC
> HC670 26TB, SATA, host-managed) - connected directly to onboard SATA
> (Intel X99 AHCI), 6 Gbps - drive reports write cache disabled, no
> DPO/FUA support Software: - Kernel: 7.2.11-200.nobara.fc44.x86_64
> (Nobara/Fedora based, tainted by Nvidia out-of-tree modules) -
> btrfs-progs v7.1 Zone info ( NAME ZONED        ZONE-SZ ZONE-NR
> ZONE-AMAX ZONE-OMAX ZONE-APP ZONE-WGRAN
> sda  host-managed    128M  191776         0       128      32M         4K
>> max_open_zones / max_active_zones from sysfs: <128 0> Filesystem created with default options: mkfs.btrfs -L archiv /dev/sda (zoned detected automatically, metadata DUP, data single, block-group-tree enabled) Workload: Single rsync job copying large video files (2.5-4.5 GB each) sequentially from a USB drive, ~160 MB/s. No other writers. The abort happened twice: first after ~4.3 TB written (with Dolphin, possibly two files in flight), second time ~10 minutes after remount with a single sequential rsync. What I checked: - no ATA/SCSI errors in dmesg around the abort - SMART clean (no reallocated/pending sectors, no CRC errors, no command timeouts, error log empty) - btrfs check --readonly after the first abort: no errors found - plenty of unallocated space (19.5 TiB of 23.4 TiB) btrfs filesystem usage: < Overall:
>     Device size:                  23.41TiB
>     Device allocated:              3.96TiB
>     Device unallocated:           19.45TiB
>     Device missing:                  0.00B
>     Device slack:                    0.00B
>     Device zone unusable:          7.79GiB
>     Device zone size:            128.00MiB
>     Used:                          3.95TiB
>     Free (estimated):             19.46TiB      (min: 9.73TiB)
>     Free (statfs, df):            19.46TiB
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
>     Multiple profiles:                  no
> 
> Data,single: Size:3.95TiB, Used:3.94TiB (99.76%)
>    /dev/sda        3.95TiB
> 
> Metadata,DUP: Size:8.12GiB, Used:5.46GiB (67.18%)
>    /dev/sda       16.25GiB
> 
> System,DUP: Size:128.00MiB, Used:3.31MiB (2.59%)
>    /dev/sda      256.00MiB
> 
> Unallocated:
>    /dev/sda       19.45TiB
> 
>> dmesg of the second occurrence: < Okt 19 16:09:07 nobara-X99 kernel: BTRFS error (device sda): error while writing out transaction: -11
> Okt 19 16:09:07 nobara-X99 kernel: ------------[ cut here ]------------
> Okt 19 16:09:07 nobara-X99 kernel: btrfs_abort_should_print_stack(__error)
> Okt 19 16:09:07 nobara-X99 kernel: WARNING:
> fs/btrfs/transaction.c:2606 at btrfs_commit_transaction+0xf6d/0x1000,
> CPU#12: btrfs-transacti/35530
> Okt 19 16:09:07 nobara-X99 kernel: Modules linked in: overlay uas
> usb_storage dm_crypt encrypted_keys trusted asn1_encoder tee loop
> nvidia_uvm(OE
> ) snd_seq_dummy snd_hrtimer mlx4_ib mlx4_en ib_core ptp pps_core
> uinput nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet
> nft_fib_ipv4
> nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
> nft_reject nft_ct rfkill nft_chain_nat nf_nat nf_conntrack
> nf_defrag_ipv6 nf_d
> efrag_ipv4 nf_tables qrtr sunrpc nvidia_drm(OE) nvidia_modeset(OE)
> intel_rapl_msr intel_rapl_common intel_uncore_frequency
> intel_uncore_frequency
> _common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp vfat
> snd_hda_codec_alc662 snd_hda_codec_realtek_lib fat
> snd_hda_codec_nvhdmi snd_h
> da_codec_generic snd_hda_codec_hdmi kvm_intel spi_nor snd_hda_intel
> nvidia(OE) mtd snd_hda_codec kvm snd_hda_core iTCO_wdt
> spi_intel_platform spi
> _intel gpio_ich intel_pmc_bxt snd_intel_dspcfg irqbypass
> snd_intel_sdw_acpi r8169 rapl snd_hwdep intel_cstate realtek snd_seq
> phy_package snd_seq
> _device mdio_devres intel_uncore mxm_wmi
> Okt 19 16:09:07 nobara-X99 kernel:  drm_ttm_helper pcspkr libphy
> snd_pcm i2c_i801 ttm snd_timer i2c_smbus mdio_bus drm_display_helper
> i2c_mux snd
> lpc_ich cec soundcore video mousedev joydev mlx4_core mac_hid dm_mod
> zram 842_decompress 842_compress lz4hc_compress aesni_intel gf128mul
> psmous
> e aead wmi serio_raw crypto_user
> Okt 19 16:09:07 nobara-X99 kernel: CPU: 12 UID: 0 PID: 35530 Comm:
> btrfs-transacti Tainted: G        W  OE
> 7.2.11-200.nobara.fc44.x86_64 #1
> PREEMPT(lazy)  8032c1cc6f4c3d56dc9ce283429b1ba1085d0235
> Okt 19 16:09:07 nobara-X99 kernel: Tainted: [W]=WARN, [O]=OOT_MODULE,
> [E]=UNSIGNED_MODULE
> Okt 19 16:09:07 nobara-X99 kernel: Hardware name: MACHINIST /E5-MR9A
> PRO, BIOS 5.11 08/05/2024
> Okt 19 16:09:07 nobara-X99 kernel: RIP:
> 0010:btrfs_commit_transaction+0xf6d/0x1000
> Okt 19 16:09:07 nobara-X99 kernel: Code: 8b 43 60 f0 48 0f ba a8 88 0a
> 00 00 02 0f 82 cf 4c 6f ff 8d 45 1e 83 f8 19 77 0f ba 01 00 04 02 48
> 0f a3
> c2 0f 82 92 4c 6f ff <0f> 0b e9 8b 4c 6f ff be 03 00 00 00 4c 89 ef e8
> ef b6 2e 00 e9 44
> Okt 19 16:09:07 nobara-X99 kernel: RSP: 0018:ffffcea7c8947e28 EFLAGS: 00010296
> Okt 19 16:09:07 nobara-X99 kernel: RAX: 0000000000000013 RBX:
> ffff8ca04ec27078 RCX: 0000000000000001
> Okt 19 16:09:07 nobara-X99 kernel: RDX: 0000000002040001 RSI:
> 0000000000000000 RDI: ffff8cac607e1bc0
> Okt 19 16:09:07 nobara-X99 kernel: RBP: 00000000fffffff5 R08:
> ffff8cafbff4b801 R09: ffffffffb2bd32c0
> Okt 19 16:09:07 nobara-X99 kernel: R10: ffffcea7c8947bd0 R11:
> ffffcea7c8947bc8 R12: ffff8ca21087e000
> Okt 19 16:09:07 nobara-X99 kernel: R13: ffff8ca21087e468 R14:
> ffff8ca0f9973200 R15: ffff8ca21087e470
> Okt 19 16:09:07 nobara-X99 kernel: FS:  0000000000000000(0000)
> GS:ffff8cafccfe0000(0000) knlGS:0000000000000000
> Okt 19 16:09:07 nobara-X99 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> Okt 19 16:09:07 nobara-X99 kernel: CR2: 00000edc094d8000 CR3:
> 0000000fd2a22005 CR4: 00000000003726f0
> Okt 19 16:09:07 nobara-X99 kernel: Call Trace:
> Okt 19 16:09:07 nobara-X99 kernel:  <TASK>
> Okt 19 16:09:07 nobara-X99 kernel:  ? start_transaction+0x337/0x8b0
> Okt 19 16:09:07 nobara-X99 kernel:  ? schedule_timeout_interruptible+0x10/0x150
> Okt 19 16:09:07 nobara-X99 kernel:  transaction_kthread+0x152/0x1c0
> Okt 19 16:09:07 nobara-X99 kernel:  ? __pfx_transaction_kthread+0x10/0x10
> Okt 19 16:09:07 nobara-X99 kernel:  kthread+0xe4/0x120
> Okt 19 16:09:07 nobara-X99 kernel:  ? __pfx_kthread+0x10/0x10
> Okt 19 16:09:07 nobara-X99 kernel:  ret_from_fork+0x292/0x330
> Okt 19 16:09:07 nobara-X99 kernel:  ? __pfx_kthread+0x10/0x10
> Okt 19 16:09:07 nobara-X99 kernel:  ret_from_fork_asm+0x1a/0x30
> Okt 19 16:09:07 nobara-X99 kernel:  </TASK>
> Okt 19 16:09:07 nobara-X99 kernel: ---[ end trace 0000000000000000 ]---
> Okt 19 16:09:07 nobara-X99 kernel: BTRFS error (device sda state A):
> Transaction 860 aborted (error -11)
> Okt 19 16:09:07 nobara-X99 kernel: BTRFS: error (device sda state A)
> in btrfs_commit_transaction:2606: errno=-11 unknown
> Okt 19 16:09:07 nobara-X99 kernel: BTRFS info (device sda state EA):
> forced readonly
> Okt 19 16:09:07 nobara-X99 kernel: _btrfs_printk: 50 callbacks suppressed
> Okt 19 16:09:07 nobara-X99 kernel: BTRFS warning (device sda state
> EA): Skipping commit of aborted transaction.
> Okt 19 16:09:07 nobara-X99 kernel: BTRFS: error (device sda state EA)
> in cleanup_transaction:2077: errno=-11 unknown
> 
>> The trace only shows the abort in btrfs_commit_transaction, not where -EAGAIN originated. I'm happy to test patches, enable debug options or try a different kernel if that helps. Claude helped me with this message I'm German  Thanks, Jochen
> 

Hi Jochen,

I made a couple of fixes for -EAGAIN returns on zoned FSes that landed 
in 7.3. Can you check 7.3? There's two possibilities that might bite you 
here. One is a hole in the metadata write stream and one is a transient 
relocation error. Both will bubble up as -EAGAIN without these fixes.

Thanks a lot,
	Johannes
