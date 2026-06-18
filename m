Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E462328255
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2026 17:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781804511; cv=fail; b=XrlzJbyonCYbXzBmb5WwjqMGw3vK+eDLJF4+FC+OYjqXPQSEHCAt6yYHe7Ym5XZoLZT9zIa+8weFIW7+IYWVnvv+54HJluN6N28JK5zg2mX8DBtQ+/78Knjvmk4euowITRIUf8qKEYb97RrJgnhWNLPqO+O6D25aKnPkk18rI/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781804511; c=relaxed/simple;
	bh=D5mj+8+TITmxueIKyTOo6RcuA/tjXF16N27WL/BcqTA=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JZWz1C2IV1G9kVy+JT+U3JCGqDhxO2TEImH+3o4ux0qchKBdXwji++KrmhfVskvFjezlieQqtILib0cy6c+yUCYKOmQYliV4xQ93vM7FOv4Sol57q0Z6bRya9P1W9uvBrjM7PaX3RwXbjsf7/58Bj69p4PLBRwyUN6sz7x0E/c8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=agcpC/1s; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fRv6OeF0; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="agcpC/1s";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fRv6OeF0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781804510; x=1813340510;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=D5mj+8+TITmxueIKyTOo6RcuA/tjXF16N27WL/BcqTA=;
  b=agcpC/1sLO4rxL/XVLgboAw35rEnuH6nod9KWKgolRloSZXelS0wk1RY
   2APkjaPxyaW9OT4tOIGjvhrQ9UpsyhSiQ+FVbSIQ5oglyEWxWLD8jQJwn
   4FvMfviZ4AhsBuR+90vyUJIW6y0JgxHQ8KAP2CUqb9z4Hu5XNOo5oqZcG
   wRxXC46wGcKsukaMJ/CK9352iaPLS3zd54IWf9TnmB2AzmPOYgr7ZY32E
   8LjfWWS5QxF1zgvvUlTQW4ji00TST9Yrn86jGxicGYfSuY+KAN7kZ+PfE
   ldRuMjeZUZBoF6Z4neVfJot5lVHKJKmAnzV9SaKNZU8vgSLql7FmNAo14
   A==;
X-CSE-ConnectionGUID: YojhQtqoSlKR+n8rSAQ1Nw==
X-CSE-MsgGUID: S93Hr+ahQg6y2l7p0XGyXA==
X-IronPort-AV: E=Sophos;i="6.24,211,1774281600"; 
   d="scan'208";a="149077615"
Received: from mail-westus3azon11010037.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.37])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 01:41:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qiamoPzdHEa8ISSIrVUJGlWCaFtEjncEZJG9askPNKnFawG4GVA8RwrDGt7KKFbjzHqyVVa2CiZ1yhFESxTHAyFBp2D3S1Wg6TJ78S4M8anb4VhR9irGMu7he24ZjKvv1tvzU035Q4Ht8JBAAMIjctnX+3DerAKm0EypttoluPurNSXG/rqHkbCwRYPDrLdEEErH+p8DP+63IhUTIVmsr9UqdnTLBlwJlz/CK+z4jPegXxdK8QfbMhhezFmY5UsEpnucE+AzOmS1mDW3IpdklSgDmYNx4M0F6IoUdnJCnRUlGZFfBu2KrxstVU0N0lR4+c7pGW/+m9tlv7gcHO2TSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5mj+8+TITmxueIKyTOo6RcuA/tjXF16N27WL/BcqTA=;
 b=kcYZ2OKB3aD5TJC4ij0mFatAAm6ZKWyI9bX1IwCHbKU4LlnXq1aztUih8/z7ojTX6PfulhpJgrDin8YRv9t8ryzyn9GL0AbgvIL1fjQXCkPt19ApIap+s9EW9V3PQR19JtWlkmJ25Tap+LEcVUOxrXhkv1uAenWKzmqCx7jUjGISrPsD7W6OsCAvrABxVLHruf0q2ddc1OoO0iHCI7mU/LGAn8qUFpmln7ARKxuAVDLnKL+8AchMq+9Xpd8SrVYzvASc42UROZzwCBi5fLQJiMqPZDrblgwlC6PZvYA+4g8M3Z5Hg8WY+F03y1CsPO5pM1+mxkwiw0U3fcn2NA4msw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5mj+8+TITmxueIKyTOo6RcuA/tjXF16N27WL/BcqTA=;
 b=fRv6OeF0hHqLkNvP4nWCppPUWQEIJGnbdx2cEuVzWzdtIdaVYkhQfrBIc2+MUlhTdKwoHL6OL+O/PTxI24/iPAaN5RUnipqy3zXI7CPBubr2ochsWy0T2qKOpTEtLTg2HFMD5ZLwvJItgRKAcdz3h6+NZQEskyd++acMDUA1bmA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7303.namprd04.prod.outlook.com (2603:10b6:510:1a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.16; Thu, 18 Jun
 2026 17:41:46 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 17:41:44 +0000
Message-ID: <d01b2e26-5b9d-474e-b34e-ffe9bf304a48@wdc.com>
Date: Thu, 18 Jun 2026 19:41:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: zoned: don't force read-only on transient
 -EAGAIN from reloc merge
To: Damien Le Moal <dlemoal@kernel.org>, linux-btrfs@vger.kernel.org
References: <20260616065129.318703-1-johannes.thumshirn@wdc.com>
 <e8ad1491-5b18-49c8-9cdf-39833afd91a9@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <e8ad1491-5b18-49c8-9cdf-39833afd91a9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0191.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7303:EE_
X-MS-Office365-Filtering-Correlation-Id: 560a435d-09ca-4702-f545-08decd60dd52
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|19092799006|1800799024|23010399003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ltkfX2roqvCj4nJs6Y+uKhQ3Tcm9R4ALASXZRXD60VSykK/LLwcB6ugqVOT/U1efqBVhPcXMctmAxMP66sFIgb24aCu0gScQ2EiSTXQhWNiO02kPqfKiruupmK+C8AS4P8u3TJjHU5XNccXK3DQDi2VahRcbx0pElIe4xeqZOGVgc76K9lgapbPFpBoE8C6hwyuK5+qRrf5hlZgNMqutUvcwRmHRKbS/qRqtGIeYqU1za8OrbqQcNWpOskdpoUta3Csg/GG6I8onK6QeSrwvDCaDipKcvKn1snaaqR/bdgtwBV//pwTiC8SGeXfTrXZcrMOCvk2fPABjBGfVwOMVJYav6VE0JoXNCi9DF9/onfT4U98J/ezOEZm5vvhsY3DVMVZLNwVCPxCnV0+M7TQ33bMq+F2IRKsy1Of1tIPSHqpI9D23sZ5MNDhmkvIt2VyQoeakcock+qslv3wS96v7Am5T+4za5nryJOGVqVOowLZ2qlX535k+zwQpHJB/q/xGb62PnRZ7ibgrTH3O7cJATDLBUYeqtLy6Ts1QM4vu3TlUbm3tvGlRT9sAXz1mJ1quDIOjUNQsG/Pso3iJtyYOx7olF2ye1Zvs7Y0hZOBY8IMWjFpROjeD88a2IibvmqPI7jx1eNvNkMnstDP2T/Yc/BPRMp8STOMij0/Df1SWDmoQGktYK/fjQDvHlKAgPNyz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(19092799006)(1800799024)(23010399003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVAwZFJGLzhlQVVNNHhqL0hZL0dHdXpoTGo4K2lBb2pHODMzZCtCZHp2WEtQ?=
 =?utf-8?B?Qkd1b285TCs2eGxnVm9tSWcvWXRUbTVyTFRhSERnZ3krTWxyK0RzVjlHa2dn?=
 =?utf-8?B?dk1GWkNQWmhyQWhWSVFoT21lMEk2ZTltOHFsaGVlYW5UTFhyT1FEM2JOKzhq?=
 =?utf-8?B?TjZ5VUxneWk2a0dLZ3VpN0x1TlJHbDdVVERSaWhHUjRwUXN5cWgwTU1SL0pU?=
 =?utf-8?B?N0RuNU51dEdiZ0FKNEpkYlZaSklpQXAwcTBkcGNhZGNnRUlMZm1Zb1AwcGly?=
 =?utf-8?B?UTVvY25ROGp5WjVtemR5OXVHMFFJdDVsYnNGcmJrRU51RkJzR3MyTkt1bE1u?=
 =?utf-8?B?Q2tqbDNPeE5qMnBXWHVNSGtJRXpPVHdReXhtWDZxT1l5dTdGaUx4VGJCTFN3?=
 =?utf-8?B?QW1QcVNTbFBTMkptVFhIa3czS3RONlJxbHdKUzZkNmRSQXBYN0dWanJJUk5B?=
 =?utf-8?B?dHhUV3FzQWlsQ29pQ3RvdGljak80a3Bad2tjU1Qwd1JialEwVG9sM2VxSDd4?=
 =?utf-8?B?S0lIUlM0ZzdPSEtKci9EOHhIcXc5SWZlVVlLYnZvODVmNnJuR252eWIvdkVk?=
 =?utf-8?B?NHczbDV4b0FkVWtSTnBDNUJHRnpJYnFzY0V1Y05VUGtFcGtjaTRocm9KdHVF?=
 =?utf-8?B?VGZSaTcyVHNVdCt2WHRNZEE2NlJPc3VubTBlbC9PRzFWb0dPVkZaOXowcVFk?=
 =?utf-8?B?OEhXZ3R6Qjd5RThEckkrMkJGbndqMDJPR01NT1ladGZKMm5DUzRybjBabmxR?=
 =?utf-8?B?UFFxbTNNSmhMQ3E5RlVhaHg1d0wxZHQ2ZDBLT1hCS3BYa3VBTGRHWWtoUDJq?=
 =?utf-8?B?OFZmNVQ3Q3EzdG9TRDVwZDBaSnpxdHptcWdLM25XY2tZQnM0Q3RaK1lJTXFh?=
 =?utf-8?B?eUxjNnBYaDNsYVdLdWUwRTl3VE4zaEhWZy9iVWNEK2FBcUx4ekR1cjUzMTBs?=
 =?utf-8?B?d0NhTmRHVkhWbTVDamFwN00reDk4UmRCYnoyMEJNdGt3RGNFd05kK3ZCVEU4?=
 =?utf-8?B?ajhFYyt5QllBZWhweUdqZFBFcUFFQnRZWUl4Qkl0c1BtV3lmYm5XNWZ6TEdO?=
 =?utf-8?B?S2JSSGp1Wlk3TEkwM1FydnlKcXdwV1E4Y2Z1SitlVWRXVDJucFIxS1dpWVRH?=
 =?utf-8?B?ZnZlVXNsREE0eXJ6Tm9KcTlEa3hxWGEvSmRCT1h4UGpzeElLbGhFL25wdkNx?=
 =?utf-8?B?NXF4ci9nSlIvYnE1Ym94YWFaZ3RWbVZMV2pNRTJOVUMxYU1ma3dHdDNiUnY2?=
 =?utf-8?B?YzVVd0JFY0llRVJOWndySmtRNUg1UzZQVk5meDIvQTNUWDdzeFZEN3B0L0E3?=
 =?utf-8?B?OVNPRlJncGhxMW9KS2FyQ2lhZm5OYm8wRTRabVEzOWk3eUFKdWltYUMzL09C?=
 =?utf-8?B?YnF2YVlRbFZoczRZalhHd21LRzZ3Rzd3RzhGZFlGelorWDlHNW0yMUY0d1Fa?=
 =?utf-8?B?cmRLVnR4a3J0dDF3Z3RCUVZKNUVyTnNvUDRhOEFmR3dSNldvVFBvN3U2dlpm?=
 =?utf-8?B?T29LT2pNTlBkVytJOUR6UE1VRHdMU3Nxb215K3lYamFIaksvZDdTOWZ5bW9E?=
 =?utf-8?B?QzB1aHozYVZ2MHVhUEY5U1JHdGcvLzV6ZGszMXZYNTgvYVlEWnA2bVVuWFh5?=
 =?utf-8?B?NTdOQ29SS2dGU09uMGtWUU1UYTBhZlQyTmJEM3pxRDhFQ3BHd3diOWRkOGtj?=
 =?utf-8?B?SXhENmx4ZjBHMDlPa0VsMVZYbHIzcEZJN2t2cUdLcWNEUTFmcDYwWlRZcm5J?=
 =?utf-8?B?bDhLS3RFUWg1Yi9VaE4wRmg3YlBneWhTbUV6eDlTcnFTTHN6Vk1ZcnBpNGRI?=
 =?utf-8?B?dmd3WmdBSjRETURxN28rZElwNVdnVmYwZS9vcXUzemgzOHdhWVhqbjkra1VQ?=
 =?utf-8?B?TkFRWG9xZk9VNUs0aWVLQlJ2Z0Z6Y1ltTi9ObG9QTk1BakFIMDVGNERzS2pC?=
 =?utf-8?B?WXliNFR6ZmxPdEZYWVlOeDJsNDQzM2RVWHVsS3prT3R6Z0hEc01PaDFGc1p2?=
 =?utf-8?B?YTB4VlB4a2ZKbUE3allNajlqV05FdGIwWEw0V0JOb3NQRXhsbURKWngzUGpm?=
 =?utf-8?B?NndFOVZNL2lTK1pkTy9uSlNvWW91VmVHaC9kQklQc1Q5MjZxdFpqNGdrN3dt?=
 =?utf-8?B?YkxpMTlQamo0RzA4Y1Nqd2VOUFBWTHJmcWxqV2kvb3UvMVVjeTBGSTE4YUJQ?=
 =?utf-8?B?OG9hTmIxZzBUQTQ0YVFWZy8xN0piMUFEM3NPd3dGK0dsY3hGWnRCTmpFZXVV?=
 =?utf-8?B?WG8rQlh6WUJTUVA3NHRxenJybTJ6aUNCNTRxRS8yWlA2UzdpL293QnlsdUp2?=
 =?utf-8?B?WGdoOVRPZStwZ2RueGhnL1RDZGxSemtqSXZ6NTdnT0tpLzVGd1BKMnVnYkQv?=
 =?utf-8?Q?9/xVvuQdQXvm/fNgRzqjVu8NodjREMFCaykh0ujfkIM1H?=
X-MS-Exchange-AntiSpam-MessageData-1: YFY8TbG03XDgPg==
X-Exchange-RoutingPolicyChecked:
	hTSMWJhhXB14oGPK4x7JsX57wLSnI5Vhv4OGpaVGd6Y6FP6W0EJiRa/PXpIRVjunP7qVZ1Bqg3vBX2YcnvotZ65mEQUHMVsf2yzT6TFkysWzrCNpRDtKgITJUt10ANj4gjHWY+kTL+e3f0YNNrvqAvQItXwr6+l1kCINbHpWti/ly3wi8xqqk/nBT+tg1QMup/POI8/EJMXK3kmcwCViYaOkFItQCcfK+emC8qPI5QdQrgNUeBpvg18kf7+tkYMGIM6Q3uvcNdId/dYCy3TiBtrLp2ZFTAiQ016oHD12LI8orVjGYVi8+Sulb8QXiIr7/uDkzukPi1z/g1Hn47WnUw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	60IjUt1iaeZZy5DrIkEJ6XZUuLgNYI7yGPKDr0ugNuCgi1VMXuSb3kiv2OJYOt73QWBC5CxhoFqchTxISa1PiYZWkjT5pebs/+925DOHv4EUNzdItGVTCTUqHFL6Li9qtBrzmAy9j1z3NbiCvDUN88M3qfJAPTEpc/Ltobk+uQs+2Hi+x8tzaGCElg1nrY5TmJT3lzd57fOr6UAEcJF9eztueesB+xMTsz27rbHz9cgks8SSRHf9VAgca58sJ0i7to1Gnv5ycGBJQ3TAtuJ1WKe3aCTReNzW47Q/mSH9NwD1Y0BMePtVVXIv/UVBoXXj6z2Ns79e3rpFKzePUx87ee3Ig+7Wb1DEVR3d9JWoNTjQ0ATbyTHIAoFxxfAG5y5IRxcIF3btO7Vpa2NnhEgWwFXYw7QI8OnjsFMoHOFqcRjGUOdFyqjy+AEVD4dLaZy5Ikk+7rRBQCS0LNt3ecOueRwd1nYR0MEZDTORXEE6FBKuz+xa6NWGrmpVW0WqJyGWTr8Sk0FJ1lIBTxCbqlHltFXCV6yvla+bL9cRjvLXCC1LfZRbBxoXd0CS0XWcGQaO8uk1nAhwK/8NYDYuGc2au7IGfo6vmnz/TWUzlvvGsxOOVxE1CR9SeB3u0DjYzV0T
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560a435d-09ca-4702-f545-08decd60dd52
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 17:41:44.9015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bt49ATq2PUH/2c3nFHJBhDanYuIJAeOfAZ+YjX+s5/AwusRje209Si4oMsrhyQhrGYaf6cXM5I2Bo6ibzQQq5DK2f5DcldJNYA2uNKR5Bk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7303

On 6/17/26 1:55 AM, Damien Le Moal wrote:
> On 6/16/26 3:51 PM, Johannes Thumshirn wrote:
>> On a zoned FS, btrfs_delayed_refs_rsv_refill() returns -EAGAIN whenever
>> the over-committed metadata plus the zone_unusable bytes exceeds the
>> usable size in a metadata block-group to avoid heavy over-commit of
>> metadata and early ENOSPC in one transaction.
>>
>> If this happens while doing reclaim, the transaction is getting
>> aborted.
>>
>> Treat -EAGAIN as a soft, retryable condition in case of block-group
>> reclaim.
>>
>> Reported-by: Damien Le Moal <dlemoal@kernel.org>
>> Fixes: 7bcb04de982f ("btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit")
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Looks OK to me.
>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
>
I found bug in there, I'll send a v3 once sorted out.

