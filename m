Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508023B8921
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jul 2026 05:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317435; cv=fail; b=KOOJhpNbOzy0LBy7EcAeeABXMhuqvHW2MaDimT6ZBSnuLGxlVDvFhAwqivKhTolJ8i634Vv/05kwKEjQosCuYlCEqPI9SKveOtn6NQzRyA/js4GjnXBzQIs20b7ft99hRaJ0QSGDN9DSSuY4LoYK4b7yPDbdXM5UQEwEQZDzFQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317435; c=relaxed/simple;
	bh=B4AF7r02V7Z82d2uGnOmwliRhGUSA31iZGd4aHsYqJ0=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EHA51tADL51b8pSCahFXfcuYlcxbIu0kh09KeVqVWysyUcXZLv6Qb1mmY9dOHxMk7UMUaUnk9Tto/viLajo0yyQbhcs7e12f1Nv/ewJ9G4MAJICVQEc6hDkJVASTa3Tyq7SSxElmYrSW07gL6xPNBmKuwsupiUrRZj80M6ETMe8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YvsllcZG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=n9u+0S5U; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YvsllcZG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="n9u+0S5U"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783317433; x=1814853433;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=B4AF7r02V7Z82d2uGnOmwliRhGUSA31iZGd4aHsYqJ0=;
  b=YvsllcZGwpvpgZ/LIVIEaNk9GUFLCW7PRTCKV0nHGK31dCnVmuu6fzJh
   4dn6GwpNOTf9zjTCFcCh4Gw4/1/n4xXvrsB0QDAuRnGV+BJSj9C88JaY9
   xJlOWLNouGigUkXgXflqshLXc/Avc3YGH8+3uK/EDyKrFuylvThD97VG3
   G8oK2J2k5y8kiCXGnbzCFbdsEj3JNgJJP1XgdXRIb6xmlIgaO/zfoqxug
   1v3nble6GLXJH1nqb12i+gg2iKUs/kKg8+2FgEl5O3vpNUSMme/e+1jRI
   pGu4gGtVKYOGlGZLuWhG/YJPSX8t1lY7GlUM3uF8q/1W69bCII35haEjM
   g==;
X-CSE-ConnectionGUID: BX8TueMpTNmxXPysE90ZOQ==
X-CSE-MsgGUID: OAcIvoCaQ6634sjjcVA0yg==
X-IronPort-AV: E=Sophos;i="6.25,149,1779120000"; 
   d="scan'208";a="150137002"
Received: from mail-westus3azon11011016.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2026 13:57:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gs9ck+Fmu2coS/v9fMbDgEr2NxIx7IOH4pQ6o+fJtyZv9lsZANPDt+z656nxo7oVU7lK6TB0deAFXmqbbS4D7+Mho3AygIrWHcHPYv45Ed4L2gTjmnGfZdHCe1XjCXDX8vaTTIZ69HZhq47K0qkJE+wJy2rMT1iB8+GSFntfYmQnKE9vi0r3c+lNbfkPQO3U6+jWb+M/nHekoME7e+gAmzzXzVSUXF9B/EVYvDcZkDHRuBodwAXpsgyyD+ChJQlQFysIOEa/PCTFAV0UEIUNkIL/vwIkUYeO0doeGzHLp37WVYnS+zfGO5nTaCgbnzZiQx8aKJG2gdTri7tY7yWtbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4AF7r02V7Z82d2uGnOmwliRhGUSA31iZGd4aHsYqJ0=;
 b=oQ5x/Ac1PyNADYKRuUzuj5zA6KxFuZYE2SHiX0nDTvAGrE7UzYPDWD6kdU0xle9II5KVFLf+G5Ey0zYAnkHTwji/4V9ic/SUsbaRjquh0TtWNO+GTbVc6BUfFUTjvZehprJiHnE813U77PLdnjpCOmKb6yQWAzOg6O37kCE1SAhaZskSN/gonHBy1U5Kp2yE3kxnp4CPLF//HV26hv/px+zYOC7u5MHRq6adiHbU2TJ5QtCjRk0RyMiLkiNTu976yzgfhODKtbL2E0sm5dE4cTs2ZYiSolqSMkWHoASTwuGW61FZAEOJx3AQYUSsSo5CXwMyOG+P4vleN2DXS8Qzew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4AF7r02V7Z82d2uGnOmwliRhGUSA31iZGd4aHsYqJ0=;
 b=n9u+0S5UAxxbUGtdyEJdoPBObjfpRaeIOamK8a4C4FEDy1xTcny9hE6urYxbIRCGyLpaSOj0GTrpx/v6ianwhZHFucV03kGLBeFs60yLZM9gY7X1qJ6W/x7V/B4lbDWL+AzZ7YTk+k1g7NIDXqsQhXxe/sYhE8g6DLh3KSzIcCs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL3PR04MB8041.namprd04.prod.outlook.com (2603:10b6:208:344::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.13; Mon, 6 Jul
 2026 05:57:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 05:57:11 +0000
Message-ID: <0ca2b2c9-30d4-452a-bdca-e7e551bbd14c@wdc.com>
Date: Mon, 6 Jul 2026 07:57:07 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs-progs: docs: mark "usebackuproot" mount option as
 removed
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cbb4fd969d5f07477adc09449c609084cbd14c33.1783155928.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <cbb4fd969d5f07477adc09449c609084cbd14c33.1783155928.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0068.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::13) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL3PR04MB8041:EE_
X-MS-Office365-Filtering-Correlation-Id: 84852fe6-845f-4d33-b644-08dedb236bed
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|19092799006|376014|366016|10070799003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 zfAS+jxmz4hjVdxEx6RpFemfj3LwyGyZ/rNP8gwJ/0jiMOFhjT4H6TJ9kWUSWkyTIUsujtQblSn03M2WbSPjM55ac7hnmCvWwtWzueSBADhS/BMBFisGhRXyMBTYdaNfq93xF3qevo4fjKXhnT1+jvqeI6udSEQTVeqgPgOLz7UMIqPaojTLIznYsoPjxlhOA5w0fi4rS4uqJzjGFUxOVCKH96i3M3bOqNw4TqnFIjGbM+oFcbuMBG7pFbThURHtz+RX+xE/gxY38IaRuXaAQ/4g/1Yny0mRdhRFJKfz0ChjqE7o0lhEn3NwDGL4AL7oamFyFdbCXnYDhS1ol6oRRz47G7ebgkMypdZGp3O3SJac+dkzP3KTVwNATV7KftsN8Rp1r+ynn3kpOSlvq5YcIH8XgPrhB4Ep5opUkq0Sh1XZn4P174jsDiuosqnnZAIFFlAd+HgaDMR7No6+W2VNPuZxTnjEhJA2BPYHnOOR2zP3J+2Kmrz808Jtz5sxX1AgghdtppkcNrqQ3aNyjZyhukM0ePRlu3aOGlEzt43W/ochkmwh0E2fwHKNn3V1VnnMtr3bgubrGts5hWO2zS6Q1hYKZ1/u8dXA3Pxi86ll5lJotmWPj6YOIi8EzZ8qLab4V8md/VBNqiyqtE+nwc9xcDgOTCaJQL8F1WP1UxO4VZo=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(19092799006)(376014)(366016)(10070799003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TDdIL3JOandCYktaQnV1SVR4cVV6R09UbDFEOEt5bU9MK05YREQ1S3l5SWd0?=
 =?utf-8?B?UDMxMXBHOEpqZERIZS9mdTdCSFRoVkRzVTRaMmxYTDNCOUs2WjNBbm9sSTJz?=
 =?utf-8?B?UGI0NVFwNGNvVWt1NWQ1YXVsZVVjRW9wcURpaE9yQStxai9HRm1hT1gzZ2JE?=
 =?utf-8?B?MTE4YzdOK25tNzlNUHhaZ1dnNkFaTUE1OWFNQnIwcUd1RkVobklYNERVM2Nl?=
 =?utf-8?B?SzZzOC9zMnB0UlI3TURLVWMyY0xDYmdKM290RjF4MkU1S3htTlMzKzlGQ1ZQ?=
 =?utf-8?B?aDVyNHRzTWZHWjVENU5HNVFSRmU4WlJpZjgzQ1ZTRDJEcE8xejIvUmhDWXgx?=
 =?utf-8?B?TkNaUklucUkvcjFJSFFCREJLQVIydlFmRUZTRU11eEpIRUNUb3BxYXdGRzNZ?=
 =?utf-8?B?dmM5Z3MrZEtPTjA0VUliSU52M2xLbUF6eUpjU3hWakJVNFh1VEFxYXdNVUY1?=
 =?utf-8?B?VFNYNmVHc0k3R21EUEs0WjRlQzBicjA0c1ZjR2xlTVJsakQwdFpvM3lRbnF1?=
 =?utf-8?B?WEpzUDZSbTBqVUdlT0tPZTJReUNhSXdwNTRnOHgxL3l0QjVHeURabGI5OGZI?=
 =?utf-8?B?YXBsTUhXYkZ2blFMUHVjbUhrTFN3d2VzWjVsaDBqMGgzaWx5OVhPRVZlV01v?=
 =?utf-8?B?R0dhMUZNWW1Sa1lybHhCQkpVR2gzenRnQ3JsZFMvZDM5Umc4WE1tNDdxMTVv?=
 =?utf-8?B?Y3RyN3pQSjIrZ1lhdzBNd1ZZZFM5UGZMU3B6ZFhFQXBpUGI3eXBVK0VJdUVI?=
 =?utf-8?B?TmJhR1hrQUsrcjh0NFVhejhXQ1pXTm9tazlndkY0Y1ZNL1ltRVZGTFh0WG5z?=
 =?utf-8?B?SEdPbTFvbHNhV0VJcWlPTGlRTzF6U0VRYXBuMS85ZFZxVk9OM0gwTzJYekdl?=
 =?utf-8?B?bk4xQldtck1tV3ZQems0KzBUVUs1VUlsZDBUWFdFK0lKVW1jNEVlRytLUVFL?=
 =?utf-8?B?dTQxdEpDc0lDTyswTFZDdzhDVmZtNDdxWXFxNzFmOEwyV3pXV05JVkRWVURu?=
 =?utf-8?B?OTNNS3QvRGNsZnJ4eTBFNGltU1MxYnN5UVJuQzhwUG9BemxyMm1GYVFwVDVP?=
 =?utf-8?B?RVI4bGxCa0hsdUVjN3FhY0lSZ2pZVElOYnBnejlKZURlcnFmM0U5Q0V4cUpG?=
 =?utf-8?B?dWpUWUdSd1NzZ3U4YmRNQnpQYlpXRlZJNlBWTTJkaS9FWHNLSXJLRWIwUllj?=
 =?utf-8?B?alFUMlJVRWsrNXF0Vm5ZaDBoWmI5QXlNWGpLaVhKNjlJRmpIWUY5UTNwVVZV?=
 =?utf-8?B?L0J2NDYvdkpyMXRCU2ZqcXdwdk5nc3AzZ0R0cVJaWkx3WVI3L3pBeVBWMVZI?=
 =?utf-8?B?NUZvYzVvaFB4bEIxTkxNbUVPRnVINzdYeU1ESWc3a01EaUs0ZFhrT2lSUWJM?=
 =?utf-8?B?RlhPaGZkK0phZWFBUnpIeVRMV2VVdE9mWXQrMDZCd3NKeFNaalhaMWI4bTRY?=
 =?utf-8?B?cGEyMFZ2YmRpb29hNEFZajl0SkgxVWNaNjM0c29jMjRxK1NrT1dod3pQS3hq?=
 =?utf-8?B?cTArcStjUncrb01BTDZEVXdGODBMYUhlK0dUZHYxeWZnWU1YZ0tHUmFWMHMy?=
 =?utf-8?B?a3lpU20zTEpHQVZYRGFFK3lEZXlKdUJFdlNKYkJZYktMVTJrZjUwMXVoZ1pF?=
 =?utf-8?B?ZHJHVlFwdVU2Y1YydEhKODZNWWU4cW1VdU02RGRzdHdRcDNCd3pYM1l5M0l2?=
 =?utf-8?B?dU5KNUY2c08xdjhDWCtEclVSMkRNL0FnZHd1ZXo0WUkwOVVDRUxzSVdOMCs4?=
 =?utf-8?B?a2kzdzNaSlRsNnhwVU1VOFRjRjlDWkJ6WHVwdjArZUhtempqeVJwZmkwemls?=
 =?utf-8?B?S05HL0FzL00zellkM1ovOGwyNGZxdkkzU3prT3dPTjdlR3NZaFZ0UHdMMVZq?=
 =?utf-8?B?cnZwbnFUcXQzWFVFOXUrakpTL2VWVWoxeXpDdjhtYjcvamV0R21Gdm93R1d3?=
 =?utf-8?B?OVNBMmJLUXZlSXNJdDA1ZjZhZVlsY09rWThDOFFsamFoOUh2NGVlRnZ5Ty92?=
 =?utf-8?B?WDdtbWhTaDQ0bVJHMjlNZ0s0N0lCTWJtZXNwWER1OWZGYUoxRWdvQXZBTC9X?=
 =?utf-8?B?SHVYZGtlSjNMVjd1U1p5Qmt3elVJS0RLSXo1SVNDM1hRNG9nQmlqTEZ5U0h4?=
 =?utf-8?B?M0gyRW9jSHBhQitiUUduQWRVaGZTeWd1c3FWMElobFIxNzFxdWFjTk5BZm1V?=
 =?utf-8?B?Y0pmU1dSdTNKZklERmZUL1A4SytGeXhKcHA2aW03eVFjcm9NTDBpVk43NWcr?=
 =?utf-8?B?ZDlYMUwraUdlcXN1eW0zMXNFT256N2V0MWZqV1p6WWttZVVuN2FrTFY2OVZ6?=
 =?utf-8?B?V2Z1RHQxcklhMEV4RnpXaWFvTUdkb1pEUERVeW1lcHdDVXRnMlRYTmNwRWN3?=
 =?utf-8?Q?dEWUzsHZ794H0DBufam6uNrsn92Y4AyGCCekyDq/absQN?=
X-MS-Exchange-AntiSpam-MessageData-1: vHhlKGLSms75rg==
X-Exchange-RoutingPolicyChecked:
	ZsM/RZt66a0l3gWDe5OGLr1Wj+f477OiCax536fm/qkeE4v2B4UxAHVwvvNul9asUFhG7jx8a9zZ0B8pDXmplZfqapzcgpvgnXDd2U9j4YID1iBUoY3b21RptAOgwndzH7xbQfpBqMIFp1I4wWEscDaDWLHofJ0NVWZOTJ6cFloYPn6uZ7/ivHRsWipZzsedyy/jU5/elnjnP/hyWz0vckVczog9/OHGKc2kVMZSxkS0X8CV/M96/H248F257VGusmj1dBWlO+Fz2qlaiGtVIDCq/LPbUpyviZM1hB6G7+K14H1ArmCNRlzhJkSltqtl0amnXp6/BU2kF5F4RDYn6Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6SzHuKGRYtdOdvkY6dvI0CbyJK3oVFBrfoDlAuGXXg7bO3vIrwFjbI6Lo0o+rVkfDsFPARfUWKz9gRLmhoWbhFaSQRj7VFWK1Bo9DEdHnuobW6D46YlmIVKYnrkxodxjT7IVNvjIez3G5nATvRNPgYQhPTn0eL+meaJndzUFqKr7zWdJavse/tsLU3sKmLsUMi7KqT//9dGNF/LjRTa1+IkqTKR9lV9pUtyeEaIaHFj2P5gFcFjrZ2QFNcYD0XrwmONs8ZruX6gO/a9nlllrMxVdkEnzn2jeC7zBZ7DOz+u6cZDg9+eWkJODQ1M9uq1Ew+JYip0JwQY3Y5HAgId8spOVOf+0Pvunu89vFtIa2EpQdZeWZl25EYY3wOfSEMeje15HJtqlK9QWxqz9h0y/C2IdVCTcaZk8OFU4uaC7x7BGnCv9qETeZbSZvpypdJuRoesV8aGjJuSQftok+QaXflXNwOKI4onPhbxpdq0VyFR//Xu0Ly/QUjklJHOplxouVcjTjGckR2DJYz0qBADi/CMKn37LZ26taA7EIIC5QpseyNVaaTSW9rln7GEafmfLSNYi9tWFzCWKELZhK5s17fwTFrjsOpofBlP3UaatSJKkdXP5Hc3JN6GQbKxBbu04
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84852fe6-845f-4d33-b644-08dedb236bed
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 05:57:11.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4cItDWJ3LbIeHSpfQG1Y9NFcBZp6PWZ3thkZjeZXsYzXP5A5xWvSyymxTLJUfNDBDnaVKBFxDoe20bBnaWtfC691ErhE0t3GNBrc+8SijdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8041

Looks good,

Reviewed-by: Johannes Thumshirn <joahnnes.thumshirn@wdc.com>

