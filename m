Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE1C3D3D09
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2026 06:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271430; cv=fail; b=kUTGsjf2QdN+rp4Zea8HxKwrJANPY9Ljirkv8k+VQczmoH0IK4NM/OInuG3QGOy6qolkugkd9KBmNj1//2F2Jcr1NT4xpS+t+33KIs9ueftNXrpL2l75/sIO5yDvF+ioSvvz5IG51h92R4ZtxzqzhU0+EXXWSlgG6bzuiutEOeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271430; c=relaxed/simple;
	bh=zNUGrzffMC2OayZgqOF0GT2khzisF9TRf652CxM3R1A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Iz3lnI7HGMXyLUNDZR3gobEw01p/t9qJC5oI12aporDeJQMUwQyN1vGu+xDVcKMpttGuTOdFhaq+wTr9Qt8ssswv5S40vOw7g2mEsDyCidy1aagDmB1hg7VwinaSAVxMi25tIixyEq8i3dRryrxClgzRamnVSamrWC3nPF1Zdss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VPs9NSDo; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=LTgSgDc3; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VPs9NSDo";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LTgSgDc3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784271428; x=1815807428;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zNUGrzffMC2OayZgqOF0GT2khzisF9TRf652CxM3R1A=;
  b=VPs9NSDooCaelNUg8VxhuhAtUtDN/YwHAep5W33nKNfWWoSMej2S4m/R
   EjsysE3XdX+kTuubCMTtc9kP7BYoMLsdpm8arYMstBMXD6/5aOt0nsqql
   RhWbGecNmKzCmOyJP84EDiK9xU0oBQCN/uDpodmPLgfpOrKND1rV/Z+wH
   1FwF8jVh1gNruOg5YQTyBJtArpe8aMbL7IR8AaSUfrQJBqwnGnSPPkx9z
   rQAP2hIr2g+53fiosrePcquYqCNG4DFKsDt8Tb44OozlXL0HP5y8qpwZ5
   nfaJry2Rphl1E48PkktnHJ/h6ak6DakicSrl/1lbL5fi5SBGNZ9m3CvGG
   w==;
X-CSE-ConnectionGUID: ml1zVG5dS/C38UFc23XPjQ==
X-CSE-MsgGUID: FsVIOAvqQGOqo74f6pymAw==
X-IronPort-AV: E=Sophos;i="6.25,168,1779120000"; 
   d="scan'208";a="150255731"
Received: from mail-westus2azon11010040.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.40])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jul 2026 14:57:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sJpLxgP0XEAHm1G7Ot3l6SvhUke3S9i0b0fnNQy3J/uBXEtpx51FYlPs7D2bOF2ST78w6oDhWzk/pWRcZTylBWiMvlwd/NDyJnKfo/Wd1jYzdG9gj3b9DazfKwUnSp44DNu1whnDuus0QDRpgxytLpCIR8H+IaftwsoIAFukN0+9XCBxcDq8hYL+bZZU3+75iSXnG+eJDoFsyiTn+ZW/+SiMCt36IF8CFr8UkQ5t/2uxR7mRHGyWnX0pYOA9tNZ5ubfkuqcpxNUFPRHsR21kZPlaNISEw2LfZoH8P4jJG5SySFRCYxbprMB2Aajm795WkoKEXBz4DtohRQPITMzgAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ViayXkULjlubWHdKrhOAmJVLNz92cBlIfIVPOfT6iBw=;
 b=sSZyvKOspHT65hFo7KvxFZcD9rQGaD/7Q9UAIPStOoy+qMZukscHtT6oY2I6a6H0qt1oegEGe1bNFsMPiyZftxF7Ibd1awNdr/XI3mzA+o7XzlUsbBcNejhZQ/rLo+PJ+axhKFQwZT/9+iRUA5+lPav29foTYPQbRXvxQzB0MtU/3T7JcdwhV13ZYQBWc8vgWYWJiihtGqrwKzGRdLwOgOqFIl499qxXhDvnJtybSeUi89ENsXpv5+wVEbWlGBenxjyR+0vVWe988ffBa4Fmhy1gMBZv/J64Ymz8+6n2K946+4A17Y7rJ9UaSmk4nAZ2CmaFUiaJ1T2vlJpnY48d4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ViayXkULjlubWHdKrhOAmJVLNz92cBlIfIVPOfT6iBw=;
 b=LTgSgDc3MXXoSqdEcm5NiSXHczbyPVsCMmDnroniq9fgyMB3E6Qapl6WZ7rKXMhg0VPQkQQKDaP+CifdWaa8bN2SvnLRBpdCzsAAsZkg1ypT9yRTOCZKbNa7YVWMe/Zan5CXXeqZRfwVGK8zVSSmZ0kw06MvXTRjMRsqmNb/wGg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7400.namprd04.prod.outlook.com (2603:10b6:510:13::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.13; Fri, 17 Jul
 2026 06:57:03 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 06:57:03 +0000
Message-ID: <c65d3e19-fd97-4e88-9a66-30dc77a6d17e@wdc.com>
Date: Fri, 17 Jul 2026 08:56:59 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] btrfs: zoned: drop stale dirty btree buffers at
 close_ctree()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Damien Le Moal <dlemoal@kernel.org>
References: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
 <20260716115656.1319295-3-johannes.thumshirn@wdc.com>
 <062d26d5-c340-4e3b-bf56-a38d1f98a546@suse.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <062d26d5-c340-4e3b-bf56-a38d1f98a546@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0197.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7400:EE_
X-MS-Office365-Filtering-Correlation-Id: 33a06914-5cb2-4bb8-f058-08dee3d09b77
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10070799003|19092799006|18002099003|22082099003|4143699003|10067099003|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
 QN+aoNqVbejQJYeO0nxFIdtmglhmk6YP9FyfJKqFVXJO9z2xuPayfGN0/xtDN12F6dVkld6C5BMwvK325KN+/muqyeiga2v5W0TTEoOqOTclavfMaQ5Kx6PA9Zxo27TcrCBBbk73Dvwfpp19Z9GN8q2QmlvpLwv5xf+D52a4wxredJeLpWVDIlD3bqWu/UAfv6qIvgjgm02gWgVLFA78hKXMHXBR4SwYP21APMrPuBlxL92GWeID2D0s/ILJJ6bac6IVXavda+nRczElQn7LDX30sFumSKgp7vnnNl+ijLKWgaAND6jauZ6uPU/trrW/NSuYbT/OvnC0xBH/xqbaQkrdqP4aLt071J8kj7+u9XzWui22C2G9q9AnL06ACglybGi3nIBpO2PKhVmw3FOX1rGFKOIwn6JJ+IwtwH/0PSxNTB8TNKABU/2zP3KnDlGnkOlw6n/ZEq6Bqm+7ayzd0CIdlmCDJK/utRJpN7o6R7362Kh4U/If3c18Ul2dRfkkkvOnzHwZz/RvON/HGLA/A4fHXMo5KE+Z+E5toLLJ+MOOuiBDdI1HWbcL8b/iDtGChy/mx0HemXjq0iMlsTzPtFY53x/HGBx6bYjUCEqkfLIdLbPQJ5P/LZ4cVt2RoRY/vfYBBeKVdoIUx9RMCf0OML2U2FisgSrPFnE8oeV6eO8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10070799003)(19092799006)(18002099003)(22082099003)(4143699003)(10067099003)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SE9RNFEzZXcyY3RyNm1uWERNUkFERmZoSnVjTzJNdWhNeStVQ3VzUy9RZ3ZT?=
 =?utf-8?B?cDFNSExFbXhyYjBSVHZ5U3BCaGp3OGZDd0tmQ2x6RzQ1NHgxUnJ6OFpMU3kz?=
 =?utf-8?B?YndibVpzUHdGWUtNNE1rQ1dHbHdqVjVpTkg4blVlMUppSng1Q2M3dmI3NStu?=
 =?utf-8?B?SmdhMTAxdzNjSmRSbWFEL0pCOVd4YVNCaEVLa05EYURpcU55ekx0UTRJNE9a?=
 =?utf-8?B?U0ppTjVIRGlBbzJ4azVSTVZBMHpTYmI0UVdiQ3Z0aVo3OWg3TmJlbWNJWE11?=
 =?utf-8?B?RVY4d3VNeG9zYzRFUGJHbmpJdjJCd1lQUnpiY2ZDdjE3UVFhaFc3clpsczFx?=
 =?utf-8?B?NHhqcU03dFF3QkR0YjhvbWFOYnhKUjJWTFBiMVMxcTB1b2tWOFZ1b21PTE9s?=
 =?utf-8?B?cURlMjhnZVhTVElsODVia3ViQWhtNVBHSXZpR095YlI2K0JiSHNTMm5LcjVs?=
 =?utf-8?B?K0duK2ZDUm95YlR0VDZGRXFIaHJtRFEvbGNOb0JQcHJ5WXV6V0xsVkJyOURW?=
 =?utf-8?B?ZlZveFhXVlJNajZBRmFsVHpkcmJNUnh2ZUY0cE5aZ2Z3MmY1WlN2ZGhEMGxl?=
 =?utf-8?B?UkZteFhRemJFSmRMcjkrVWlGdEFVZGFGZW96MFhSQ0Q4Ym05aWFIUEZ0SmxE?=
 =?utf-8?B?QzdPRTNCakova3hkdWRsK2hmbjdid1lYemFGaVZEaERUaFZLZVo0YlYybjU1?=
 =?utf-8?B?ZGZzTXRpeHhKSDJLckJSYUNBV05ZTXdKeEJmcGN3VzVXUnRGcnVZVndicHpF?=
 =?utf-8?B?aGtJc1BBQUpCaGtyVjd0bExoUWZ5VmJCaUp6KzJwc3BpL2tBZDRQcHpkM2lR?=
 =?utf-8?B?ejdMOGNKM2RMZXNTU3lLNzMwd3J5eEQwUnBpWWQ1MTQzaysrR284Nll5Qmp0?=
 =?utf-8?B?RkUydzFaL3JLdXB2dGlRYWppaURPREphL2tzMWpSeDdRakltd1Z1TU1pSWdC?=
 =?utf-8?B?Zkx3ZlA4QWxqRjByd3FBWmVEK1NBaUI3ZnpkV3ZjNWt2N3V1QlNFam5EcXRw?=
 =?utf-8?B?MTZNd0F3UDRlNFBYU2xPS0NWTUhZdTZHdTlnMjZQVmVocWNrN2NSMUZZb1RC?=
 =?utf-8?B?K0hCVG9OZ0pmcS9abWVvcnR1ZUxRVWpnNjBXTEFrVW94QkdlNmMwcGJhSUZ1?=
 =?utf-8?B?RHhURmZwcVBaeHpKSGJtaDJuTUtJeDVXUzVNYnZ2azNpSU9MU2VOcE96b0Uy?=
 =?utf-8?B?NElicnprTkVvME9zYkxUQU82UWpuMCtKMUt1N0NuRTkxTmw3ZG95aWUraFhV?=
 =?utf-8?B?RnA3RmtsZEsveWttT010a1RYTXl0WkNIa0RDZ1QrOWFqa1JESi84ZlFWV0li?=
 =?utf-8?B?dGJRUUxSSXk5TDBMdzlCYVBsL2dqSGxycEVrQkoySWFSeE1yNENpektka1cx?=
 =?utf-8?B?enlEa1Q5ZWk4WlJTNkRsVHdIKzFINkRLaFpTUzBXMU9KLzVodkxIOU9rN2tv?=
 =?utf-8?B?Y3d6UkhkTG5hZ0Z2K2lxdEJWMk5pWXI3NWpFZjRUamhaZVF4eFU1clh0a1lJ?=
 =?utf-8?B?QXQ0OStrQUtVUUpvSDUyenVzNFNGQXNNTjA5a2pPMHd5K0RYUXVpTStFNVVU?=
 =?utf-8?B?d0xyYXNCNjRKUXdEcnpoYWdTVUFIb3VyRkVGVjcyUzYyZWFBVjE4bXNQOXhT?=
 =?utf-8?B?N3dNMmpac1Fsb05FUlN6aW80RUc1dVY5Vmp0N2N1ZVFrbWxEcEowL3VvVFlK?=
 =?utf-8?B?bUJ4RHlxQ2NSclQxMzJuRVFydkhIVzdnWk9yTklGNmpITjZRTSt5ZTBFTDZV?=
 =?utf-8?B?RUVtQk5EN09Hc3hxYkN6WG50djU1NkZkOG5USGQ1OEpFNnNQOVZGWjNxUDZR?=
 =?utf-8?B?VjQ4ZEFIdXVRQlF3bzJpTXVUZE5aUVZ0MU9zSEhYUVJDSk4vcmw1bERrR0Qy?=
 =?utf-8?B?dWFVSDhuOGY2TllXUWFDcVhGYzhqVEl2dnNmbUFXYUNoSU5weTFuZDZEc3cx?=
 =?utf-8?B?OEg2Y2x3SlZldmJFVUo0UGV2d1BwbzVXenZjalorcmlGOGFTZTNnYkQzUUVD?=
 =?utf-8?B?Y1FmdWNLazA3YVR5QmZQWmMvdlBjd1M4Lzl0aTVjbmY3dUpRWFBFclVhdUY5?=
 =?utf-8?B?TFVmNVhXUW9aV2lXMUhGUm9FUEZONEdGMDJ2elBhazVmSHJXK0NOWW5qZVhF?=
 =?utf-8?B?cVowejJra1hNV0tSeEk1L05VbDB4TVNNa0pQQzJYU3JQYVJvdHR1MXl0S2Y5?=
 =?utf-8?B?THVidlpoK2dSTEp2ZGhNOUdpYVVPQmlVU2JsUUt3WjBZVzJldGk3OTdFZkhY?=
 =?utf-8?B?dkN3NVFvenVaSVJpd2doVkttaFdlTVFsRnlPT2NCaEdiMTNDV0FYYlFhT2sw?=
 =?utf-8?B?Mnk2dUoxQjhRb1hDRlI0WXhCRDVxZXROYXczWFZsYVBZVnpCeHo3b1EzQXJi?=
 =?utf-8?Q?ZsXNfjIYGQtK6n2+jZbJxnbveWPgaECQVZF/OdsgP6zf3?=
X-MS-Exchange-AntiSpam-MessageData-1: 244Xyv5aSy8esg==
X-Exchange-RoutingPolicyChecked:
	KSs35k/q91b0/qlw0AAZBYb+YG88PxXKoGz2F69OAOniw94kTN7aV3eeuLTSYEr+UhSbIQtetygq4f2o1sld8L6yOPY2FL0lcE1z11QsI6CGpKU9pB/rVrwK2pFV3KSFLsbKrmxqI4u2L4u1hE+8zeZ8hAPoQJR1zU63fZrA+E4IpUhin9ixaKK9Rc+N1o1upXQ81kvDfWmeTAJrF25L+iLofErSiqtYiMQDhaWhkzOuF+iMCsPqK8NRTyIdvioEDjWRpENrUZ/+zBUvvBsWOuwNwDP4SnweuXTA9sQBUR6QTgHWjB3kmT7PNE+GO7AOcknn3C/ESpnoxNzbKa9rnw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7oga81frDQFIrpYZVXro/KcNr2G3eOKy6xSTzsGZbGxPexsMB8KOEQEqyOvx+S5FpsNHv5ItLjMezhcFb6s5N/VVfq1/BNMlwCnrzd/By+KMu5IfVRl1D77d4oKiL97X6dPIbScOx/WdAL+24pColq3OKdxJN/8Pm2ok9irTWgOLgbY5R1nSGOkQSVtLFuTIScD8pEBWFtqpwtGkZRPOdmdTQlIsACl4tEp2+I9NNdJfeec8rjnrjhCpORXRXhBK03IrHR1IjPZEB+/BBGa3JcW2dWoWuIXh42nfZigp07E/TrEJDo2BZ2BA+XsPowCk98XffefmY5uqKJuFOM+bciGTfgzoR4DHjAl4sD3SnqYgUUZGsQPWnHOoLoekiG+Lp7YeTBknZGKd2bZY9ITAL4gkA1Pu9fE09X6hwiIi7wreC9GCJSt6uBDX76M/9LKmMbiM+1uAHDiYZroUYMRoSQf5GLkMLvFv7+fgwDy5Gwmkyv7Jf78UbImGWa9I3Ru0ToFLmBykS7KkVrF3s0ZfgpIhb7kUKlcj21qOvUxnVe5g/tI4LasIAbkZ8tIifoFU/UTAsQHzi3+jsvWTMyO57Z8AtNSBwBk+UsrAdl/pOvHZRCjOw7XiDfMn2U1jUnH9
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a06914-5cb2-4bb8-f058-08dee3d09b77
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 06:57:03.6915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ix+00hkatDyfZK/YUMPuUc970OxKbna1WJ0tuVxGjL5H6r9OHYrkSgXqrW7nfaUxxovxxS9MOqytEg/2A/JORTLVrkzr+cPnMDwZ+tmBQpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7400

On 17.07.26 00:49, Qu Wenruo wrote:
> 在 2026/7/16 21:26, Johannes Thumshirn 写道:
>> On a zoned filesystem btrfs_clear_buffer_dirty() keeps a freed-but-dirty
>> tree block dirty (EXTENT_BUFFER_ZONED_ZEROOUT) so its zero-out keeps the
>> zone write pointer moving. A block left ahead of the block group's
>> meta_write_pointer (e.g. a tree-log block freed before being written) can
>> never be written by btree_writepages() and survives to unmount.
>>
>> close_ctree() stops the endio workqueues before the final iput() of the
>> btree inode but frees the block groups only afterwards. Once the block
>> group is gone btrfs_check_meta_write_pointer() no longer defers the 
>> buffer,
>> so the iput() submits it for writeback; its completion can no longer be
>> queued on the destroyed endio_meta_workers and umount hangs on writeback
>> that never finishes.
> 
> Can we just trigger a btree inode write back for zoned cases?
> 
> That sounds much simpler and less hacky.

Let me see what I can do.
