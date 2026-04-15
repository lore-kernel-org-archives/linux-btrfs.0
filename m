Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10C921CA13;
	Wed, 15 Apr 2026 05:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776232446; cv=fail; b=bScVG728wl6twLRaY0Zj/9jjEr8KVQZEjGUfTx6xbnCXzXaDnMFjSNpIFyVfjrCNEXHoW+4c0HZKY/r1bvGCJX5vlpybB4QzCT6TpmbSngw+GXiAyPM8CpQ9qFX7umNUNmmvzBMEdZr8zao+LCYb2Sw2ffQnEOvtPQGDi3xbQkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776232446; c=relaxed/simple;
	bh=loLqMrefH3Ucu0BSOz3B+8jDpuDnJPZx1AwooO+rhw4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o1Cy4rum1iQusMyjh5BrYTQ0pBXhcHmY33Dj+TJBMDvRSD58CEBYp1j/ZyPapzZ15iZ8CQ9mKPoJfRHqolwbnwm3wVhPjxzztLN4VC5q4AqB+mZOkQgOry/nqOO2vXv61NqHenIB1ZCeewm5/8/yXuAnV+jtW5eGxhZUSkGEK3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HL0x0HB+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=A6rAf4wy; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HL0x0HB+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="A6rAf4wy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776232446; x=1807768446;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=loLqMrefH3Ucu0BSOz3B+8jDpuDnJPZx1AwooO+rhw4=;
  b=HL0x0HB+O4xI0dUVYuOklLoQUolup6PuRD3ZOCfVEupQ1uwn/HPVhnum
   IlDGF5ae9qVY8LJ+Nlkz6SqhPd6AsOraymu9Mymu0Q86PMbTDPnMZFn5i
   TEls5tCZnVhAd75SGGsIV4XWTrTbBQJXS7eNDN/BlKH47f/3XYPgyCor5
   9M9QrKlEf5KLYOUia8/8trtSru0YgOSPobHDwe3qSo+PPJ6PmRuCWNF6X
   NK3S//EKaogPP0EQ0NPCErAtHorXMve9nU1LSpWkPXMye/pYS7gzMG3xa
   MxUpXS1Pog1of5h+0/Gsj89D3adXZyk4bbyWF242m89DGtuu+GuyegCC6
   A==;
X-CSE-ConnectionGUID: 3wD+sI3qQFWwmKK4tZmXOw==
X-CSE-MsgGUID: MWfGgJZ7SZaVNhUtlLakUg==
X-IronPort-AV: E=Sophos;i="6.23,179,1770566400"; 
   d="scan'208";a="145005365"
Received: from mail-northcentralusazon11013031.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Apr 2026 13:53:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b6AVhT+5rBvrK27pCr2YejPnJyKOt3rJnL9aPPlcU6VnwRJuJxhWSaKtx96R0S/NO/c5sNHyQnXRauagO+aPntIUxL2A2O675GF54xnuSHemCayR+wmiQb1wj7qx47jVjINkYz2rBNltr4bzNu1K1c5HZ0Lf/TtbhtzWzciAL5wT1WfYUNUU3YHp0sTCI1YCUCZ04chWCFqF/11odpKW/NDYU15uhjBBKCEd9d70ALU/+KZTzWoYt78D+5PNm42VExXDn3W7uVylAgZWxkz1cFEvRoykYfXBCoZTFmi64s1ctGxsGAck6AqbEY8jkbVE9gYCa+93KMdsnEo6XW+xDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1K+FmlENNIawm0lkh4qilC+lSu81cEbK2ZHF647Yb6U=;
 b=ZCVdQ5WMXcBsp+v208KM47av8BUGS7BAa45eBOaMYXa2lnUp8tVNJ1ma/gJmcZ8X4gTGyITeTmv9Zk8vrMsAnOhLgUc+dSNH4t63A3lR+g67/qZ/t7gVtx3hPydcv0ljdXaRlMkWn576lvVfZxfAK6OGc8SugUVRh8xWhgVtHzL4/nNJlB/xoRhblcDAs6mcQwbERty8uywMFfbD3bmfhtFdgyox5sE8CbSv2Z3N01WKXjsg7cuRHCkgtnycl4wfwOs14zqqwflW1vKxOMOziu6LEuAvDuXSuOVG/LXhjTvTg3YSbtcMnn+POdwGnsI0g5RKl5U1JXTMOhWmnDBh1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1K+FmlENNIawm0lkh4qilC+lSu81cEbK2ZHF647Yb6U=;
 b=A6rAf4wyqucnOvGyvgWRcF4TtqorZGKSxGcEbO/YEXb5JCXDutt6+tuOuKHHkLgg5mEh2LILYy2WS2av/JtnE8cdQRtPgp+FsjS7nvOo17GHKE2zV4w1/GDJ89C419kub2A0N88Sxgayy8aMrwCJQlqtRdSLe654A+i7dgyxXnE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by SJ0PR04MB8514.namprd04.prod.outlook.com (2603:10b6:a03:4e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 05:53:55 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 05:53:55 +0000
Message-ID: <6cfca682-4f8b-49f9-ad16-21d90eb5f402@wdc.com>
Date: Wed, 15 Apr 2026 07:53:52 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] fstests: test premature ENOSPC in zoned garbage
 collection
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20260414143341.167875-1-johannes.thumshirn@wdc.com>
 <20260415052203.GB26443@lst.de>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260415052203.GB26443@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0268.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::12) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|SJ0PR04MB8514:EE_
X-MS-Office365-Filtering-Correlation-Id: 77ea2790-5755-4bd5-664c-08de9ab36140
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|366016|10070799003|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	BcUrXsMqcb+uDSsFyCVqubfQ5asx48U9D8mJYBbXj0tEaTNXAMiVWJtiQvtRJFnNQn+OgaruMXdmbsPxJVhoi/3zE1Jt6z6VMR4GhqKnMcBzba/yJ7/Ezc6lyn6wyWGwC04nU8Y/RjBpILOzNizJKdjb7OyrJuPW4WjaAdKEnm+yUCa9XFeSFhW05eOi5HroJJ2rOPfDbnYOEgsrNZ/H2YXf70ijo3VvMCxzDmbXjrrLcvGE9zpCMEJY1D6/U/ICZEovLIHY25QZBuszx5jMI5TOHZyOfd0AgIK+1dm0MCLCTEc7BJTncUwxOM1vV/cAPgAZHEutefayJfO9TfudVVIkQh4ICKULaVb5q964hJ21PYKci+Axb9ygPGK+fTsGYYCS1PFu6A92fF4Zt3EIf2TH6ALlH5x4KQBY9sH3/Kga2dxr51OcBJAsOsax8vwqBZp7LHP3kfx3K21/VOgmtOB/RuQccQYPyCZIOkjHns88qtXp7AEWefaa/MEoDdQtjXHSYSzuY9CQL3Bo0yp6EZIc7qhIpnXP7C4Ufgv7pNhFgwC0jCWdk53PUJ2xeNXs0OStVLy/nJGKaH/GupGIgrOQStM7y4N1m+Uf/QYYYJW+kUeGZ2ZzNUehfaMxwYFJ8NPvmJnVXvEygMKTbqehJ1VXdHSwBGtzA0kCNSLvIXU+Wo7ew6yJNJtiuHqGpzvoQvV6gUf6M3azcDgZvMuTZ76cpX2AmCoSncL/229/A84=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(10070799003)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFVwRVZIcmJwSTRLVlVGdVpWU21JbkgxOHNENCtpZTRwYVFkQStpbWl4V1B3?=
 =?utf-8?B?bFg5UXJycThIYWsybHg2VjNpamQwaWpiQU9EMCtnb1FKWHB4TFlIM3p1TEJU?=
 =?utf-8?B?TjJFc3Qra1M1UlZPb2dpV2o3T3c1R0hDUUpwNjZsSGpzRFBiVXhQRWFqR21Z?=
 =?utf-8?B?RUV3bVNsbE1ZRmVQOEtVK3JXbDk2dG1zT2M2ZGNzQVdBOTMxMXlhVzBSV0p1?=
 =?utf-8?B?OWxUWXRQZ1BDQmpsc0wyWlRHdUhaNHlXRFlMdXdnM1VoMkNWMmRHS3BERWt4?=
 =?utf-8?B?eFBaZ3FyZFJYWkdiSTUxdTlWMFpQbm85VDR5U0NkaFc0RHliN0hWUzR3ZkVI?=
 =?utf-8?B?OFM4Nnh3aW5lKzlZcHgrdVVqTzRPc25XamRzN3dYbmxJTkVOYzgzUVVzbndw?=
 =?utf-8?B?dkJWNDRId05sZXpkMEhUOVlNUDdLTnFyVUxOb2tXcU1pY1p2bUFhb1BlUk5P?=
 =?utf-8?B?eVY4Mkl2QlZzUThOdTlYck5Zdk43UWpUTzR1VlVqdkcwOU5kK2NXSjZVL1FK?=
 =?utf-8?B?TGh6RzhnVnFxRlN5aHlIZWlxOUZKdlZVWHArTXFiZlN2NGQzUC92RVJsaTEv?=
 =?utf-8?B?czAzWVNLd082b1lQNDZEK0o4N2Jva2djK0d0NzV6ZnZnbzVNL2ZyVTZsV1Br?=
 =?utf-8?B?bU93TitXaVRabzFSOUFraHdjTk1PK0xyL0JTSXF3V3BOQ3ZpMFQxR0EvYSs4?=
 =?utf-8?B?ejVnSVBrc2JYeDl3TEJRYU9HNTNvOWttemw3Yk5YZ09SWG4xVXBmeWR4UERG?=
 =?utf-8?B?alNXZVAxZ0tKVk4xbGRSam9WOGNiMExrandIRkxESUlWeDN4blp1ZGEyU284?=
 =?utf-8?B?UVB4Y0tHZzVHbS9QSWlTTGhMaU1ZSzgxUTBkLzNOd3JGT3IvU0FxNUxmWFAz?=
 =?utf-8?B?S29DZmZqbit5V0RZczVtZVdqa0ltSXlaVEpyRVpWL1BHdEM5N0V6ZUhDUWMv?=
 =?utf-8?B?bjEyWkllTWR6V0gzZ242RjhMdTZPdExhTkRBSk85ZDAyNU1tREJnMzgyTkJt?=
 =?utf-8?B?eW52SFZadGpIZUxLWEVCeW10ZTJ3Z24zNGRwekw1ZXR5OEEwV3JTRUE1OHFw?=
 =?utf-8?B?WW03bjdLdEVyWlVpMmNzWTl5cEk3T0xWVEdjUWFFcnY1VThrUHZYczQrc0pP?=
 =?utf-8?B?cnB1TDQ5TkxpN0ZzSEpRMEdocGMycTh0dE8zalhtS1VWb0YrY2NhWTl6QXZE?=
 =?utf-8?B?L1lmL0RWRlVFaStxelVuN3hvN3lyRkRsY0ticStmMEFrTVo0Q0VRV09HekJ5?=
 =?utf-8?B?d1ZuaC9hMVNWaVUvSlRvN2pFVlQvMTltcm1yRHNaZk5PcmQzZmNGN0ZBd0xI?=
 =?utf-8?B?TGdmY0kwNSs3UXVOclczQm1KbVVvS0FKdHphZkxTbnlmRGdtMkRYT2VYSTdi?=
 =?utf-8?B?bXhBay9vRFZZRitxRnoxNkhGb1hsZTBWbklGaTZreXlXWUxZWFRqZXhWNnNZ?=
 =?utf-8?B?YjBRQUZITDZsZzBGbXZlWjZaWjNXaGNUTXhkcWFFUWJUY2lvNEtNNGxRYU85?=
 =?utf-8?B?bWFSSXcwZjZ0MlRKV1lVcytsNVB1cEZFQ2RHR2t5OUlmU01IeDI2cm9vNW1C?=
 =?utf-8?B?dEs3MEZ3NGZoc3luL0VPaW9obE91amhtOTVkbFEzWTFOdWFyNi9KYXBlaGFC?=
 =?utf-8?B?R3dkd1piSmNTUWlvbE1Ic2Z6NzRGTkpMeHNvYzFtQVNrSzNVR3Z2SE9zbExm?=
 =?utf-8?B?RkN2NndCWTkwNHZXWFEvZmM0TTFwcVpVT1NjdW1uR1l1REE5QXZUMGhNSWNQ?=
 =?utf-8?B?RXZ5WFd2RXJMSE44NVVlRnFMMllkbHFCTlFHRkdVRzlMZ1BlNFZaM2FjOEVu?=
 =?utf-8?B?RnNsOTgxMUFjMWdpNnNFaUl0dGNoWjMyVGI1eEZ0TkxtRVAwVWJneXdQWmg2?=
 =?utf-8?B?MFZtbkxUWm8xc0EzQnhJT24rMDA1SGwyOHlmeElPZlp6SEN4MnFsblpaaVI3?=
 =?utf-8?B?Uk8rNjFBSUcxTytuL29hUVlPeGdPT3U0b2Y3NGF0ckxWeTV6L2dQT0ZGN21M?=
 =?utf-8?B?Vjc3YTZOakt3Q1B6M2RLUVFHcjFtSCtqWSthVG1yY3ByZkorZW1qeG1KMUo0?=
 =?utf-8?B?aDY1cDZuVHlZUXJpR0xvVTJ6ek5NWS9TaVJJTStxU2VDdTlqVkZsUkNXcklM?=
 =?utf-8?B?UEdOTjl5K1p0WG9DelZUNHpRVFNtSkgzVi9ENVpWTzQvZHllTDhhSFptZ1BV?=
 =?utf-8?B?QXF1MUUwVEJzV1RnMU9Jeit4L0NVaURvVHRTTGJGelpId0g1dEdvRDgvMUNP?=
 =?utf-8?B?YUlDU2UyVmIrbURvbHdYV2dXaGxRUkZqT0MzQXIxejdvTzVCU09pNkVVYXJY?=
 =?utf-8?B?V1hDOVlSQkFIZVlGa0c1b0dUeWtZZE5OQjNSUDRtVXBWQlViUThuN2FqL0Nk?=
 =?utf-8?Q?MMkkdAmtFXAobgDBq3Y5sVjFwcKWdtkUE8lY1GdT6Ta/N?=
X-MS-Exchange-AntiSpam-MessageData-1: 2OCCXSKJ7yQ73NQILgSlLQ7VBcGm206THPA=
X-Exchange-RoutingPolicyChecked:
	CmMi4lYtMdDyLMEIJZDlNd5Bm3IyXcDXpd3nPKqyibdfogB98jdNsksfkdl7yT3JyqFwEpRjtwlLevBLbi4n3D2R0LhmIR5YymmH0K/Pbs39tZKmtEDCCAhmfsu5qTTg4dFDTNfMNXjEseorqdfrX9NzV+j/EpXjaj8G6dvk0o12eXHDJ7H3utw4eacJ+791gvBDnDmcmNg2+8lwjBtBTeH8AzAIBkLlDRgmro+E11+M3sm3dGpkd7sf4Rfcxfcmvhyl3lHLsLOYhG5mbzLqgukZnKPPcOyH7Hn3bGnc9W1KJtGlcWHm7mPbwoafwgJdloB6HrgwEPDr/osTZHvZsw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q2t4zQVj9GmeyIIu+x2cZK8bKGbQISqDssQ1mEPz8sjua6Zx/BQ7CX2R94DRwaTcu0mivHDdTPOO3GHt29wZ4kLXnrDP45S3XI0hUA73/8QCXGtlpjUnNx24bC/00oOpi2N0w7PwYTzP5mXvUAM4oQmHcUnkDz1yf9W8J1otRONfx6znXzFpYdBqBpyICvJMOoRkPHkoin0PFRzKczRdgejga1qxK8tLrNnd8cORviLD9nRY3PiLD8gy+2M4vFj64coZx8E01HcFyl5DY629njLB6YYEH19odwugpROy8Qb8WAT/S8spH9LKEMkFt+lEJXjsn5X+6ZgWqHAkTkJdYWwdjvEUYxOKMFn4XFwufFeGf/FAcfK+Rnu+OOfqhsYVi8mQ0BzpMii5vYevevHX/D6Un9DnY+ROl5JSJ/UhsU0GdYDn83FUN329IWGVgwfLdALLCNlLHSa71MdWQuPTE/b/jGnjEvKcbnun/bVmj3MPzL3nHtBuZkyq+uMcPxt013XCjtHOf1A2GrZAU3JYzLRJMWeRuc0V9lBxODgeik31uJK0G6q8pWya4GHEfZFrXeJD48HAUSze+CMB7zEtv8AeRQO2Aa/cA1v+wp2BOqopPAfg2OfgeCol5c4TDwyF
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ea2790-5755-4bd5-664c-08de9ab36140
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 05:53:55.6916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 58BZqfUq/WmiSzE3L6ON73Qd9nqZBK5V26FizvZljhYwV1xuNy8nT3T13liMPm8Wq/86oQjXokZ1HV2fPR9ZaKJbwalApXcAIyawVdV6fG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8514

On 4/15/26 7:22 AM, Christoph Hellwig wrote:
> On Tue, Apr 14, 2026 at 04:33:41PM +0200, Johannes Thumshirn wrote:
>> This test stresses garbage collection in zoned file systems by
>> constantly overwriting the same file. It is inspired by a reproducer for
>> a btrfs bugifx.
> s/bugifx/bugfix/
Fixed
> I tried this on XFS, and it doesn't work as XFS uses SCRATCH_RTDEV for
> zoned data.  Manually hacking in SCRATCH_RTDEV makes it work, but that
> will break btrfs.  Maybe you can add a little:
>
> if [ -b "$SCRATCH_RTDEV" ];
> 	zoned_dev=$SCRATCH_RTDEV
> else
> 	zoned_dev=$SCRATCH_DEV
> endif
>
> end then use $zoned_dev to make it portable?
Sure, can I still use _scratch_mkfs_sized for XFS?
