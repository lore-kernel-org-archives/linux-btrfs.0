Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5EA301471
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 10:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783592788; cv=fail; b=rmDWZ4YTiqXrV7YJRXWm2EZf0TVqlBP6pFk+FNiFL+7X6/KHHo6n+WdcIXeP+XhA/YSf/gJC9Oc05rbDlXAii0erfCAxyDshvKbkAoo9IMJ55Yr4UNe/EfupQnS8w5H7vS065SnkYnkrlbhFmro/Uf5IurkSDIjLmf3MfIfMWcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783592788; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cSiNEE/uqQGHJZbKMd33oslTt4kJCAoQGXVOpQpJbrHFr9RjSwS0pFLUSAM7PYXEwMSJ38n4HtSNXFfOVox4cohSo53+l8sL6mrfWF58nf6g0ZYP3Ur2Ms25JIQvxQJ+YYyb53/vxAuEBHMDQunj0qXYrMxwId+n/5yv++uaTGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UH0XTJ6m; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=YCkEUYCQ; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UH0XTJ6m";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YCkEUYCQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783592787; x=1815128787;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=UH0XTJ6mcOoIFK7mXm+/KkQPwJkTi+swsH1QgFapxyvGg8ygpWbthjCK
   SGPWEHkC5m0ZTgrvAQoIb8iBmQdy0ZUiJCAJ7kNgIruvy5maW6PoPPoer
   INjpYsTzo8+4QSVoLFsX+RWGXuct+2M81HHglCjk892RkSn5WpV5VRhvQ
   u65aZ6qFLBEfcHcxJpmljLVz4F4+lNfDlcvlNwC9vz3tFyY/Bqng3qaw4
   Q7yMwBvadrfzvEzJLSm3OSQfBPf/U6rCGhmIEiSkqV//37FZ46on01zyy
   K4/2kk7VWpTyc993Aj/Scqs6epygR8d2lEtEpp9Pf8z3ZL5uQvY9QcvEr
   A==;
X-CSE-ConnectionGUID: NJK6tcBcTAqsScdfV9s2Qg==
X-CSE-MsgGUID: WSq4GvbsQTmeBuPoA/X76w==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="150694376"
Received: from mail-westus2azon11010065.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.65])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jul 2026 18:26:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RFlFd0OfAPPAJGkOjLklM9crkUQJwkuLfURD6hbg6EZRkO77E4M8C66/EG9ha/6WdU0HQXt/ISVeCkMN5TtfIApA4wRE7eqo05eIkGmwcplbe3Vcfa8EBt9g6FebLr0v+yOtA63gGrT00b9x3RjBRKptlNiKRhutFWggmLDTuOLQ2PfJnzk/hpav9iSVZ+l5krvTDTK5BZoAws5lSPrsfPS/TF/Sq+cGFOKybYKwo4RhoINrK1WCT+Dl0jjOtQbjNLdjjGAPbXCLfQF9aOldoUE+Gb/G4p9eJaDAo13sTi+yn2SV9ogv9mO3jpdncBMvp2gepdCQRs6E1gVEtB5rGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=va6k9rGkDZK70bVgGfRq0T84pjAwZqPNvdI5ut2vXRQBvLvD/Qx+ojwgppG/wJqhoylVw6HYQdVoangzcM4zx8aKNBsthdL00UC348QCFe2USdiomUtLz7GAZWs4sBmcG80PTjXWQxZHOAKfC2VG9zP1uCCFqmsCOMmsv7C1MbrHpauG+hUrghoCaHV3CvHK7+Q97skmDKi4X/CeOf+DWSvPDN5/haIXOSRnt4u/ZSU1lwNn8vYRqFvu8qCv8VtMFAor18m9RfS8pndm4wNL2dtV6X1LqqV9GVYSHqU0DJfNfq4O317aoy6JBQdVPHfp5y+Lyp58H5BSlQTkfZ3alQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=YCkEUYCQdebK3uYSieZ5ncJhzV9LpvHZHyDtjt+xEewY5FJNyVgQt2nvVuEzeGMuFeF9h5lCklaSk0gkSkKCyZ0Fc8kflYGW08h71W4rDgXIXCEoq5HhDC6K+ZC9ETzVgAEjZ5pjMP3h4/1pC9kY0t6CDutOCwDY997RudD3hC4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA3PR04MB8669.namprd04.prod.outlook.com (2603:10b6:806:2fd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 9 Jul
 2026 10:26:17 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 10:26:17 +0000
Message-ID: <0e0da77e-e39f-469d-b457-2e363256d428@wdc.com>
Date: Thu, 9 Jul 2026 12:26:13 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/4] btrfs: scrub: implement calc_sector_number() in a
 faster way
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1783252371.git.wqu@suse.com>
 <b761a5ecf46388d29c3d4c1eee434bd1c9108dab.1783252371.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <b761a5ecf46388d29c3d4c1eee434bd1c9108dab.1783252371.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA3PR04MB8669:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fec0860-b25d-47eb-63aa-08dedda482b5
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|10070799003|23010399003|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 unT37h9xtfACI21t/p3gcpmHbEtJ5RmaVklWb3VHoZ19G4GBZxPTQf2CpRE+Hl4QQkLHy/iP9/7fLR8OpkTj40vZY9ussFlMYpeBUmJqi9jsbNVNQCaiLRfI7H0i7kg8PMJEuX1BHe/Y10wxNK8d28UYGnyoy0EJqra+zzvTA13p+TUMelDWgJ/l7igBFEFnp40uqbS69Z++WMSOymD6PRtzN+CNkvEPzQiqrhNcUnDY1UXI8jxdzwMsItp1YRvRJpAltWUGjtsqC+ufGZWNIglzl9F3M7sNNeRjB+fLG0dJ+K+RRz8OfVN8DxcM4AM5XsgB+cM+qX6PIru3SQ9h/2qKvIiJ7HPRHGqM0DlyGOSjES2ZBNzvwIEnltsqFHuqFW17YGA5CtmwXGyMkCztJj6pXt5z3RBwjjuiWO/ehNuYVZQjtyvciG4jZ6Hr39050EwpZKerKrYOG8p5HkgSdGjoIB/i/GJW7hsC0ZT/nRJ1W0SeylZAEkJ1KR5KimQU2jDfcx37UgbEFZCO4re/+YN9chTa/WVbFGqJ8ML90k+nDMwhbcXtg9tiiTzJFjUyY/FWV02qNq1S5nAodPvmVsRQl954HgwcDX5lAszpZCM0yWcsvzZGCmC3KhWLjGt5pthp1Zqk8i0wIs52Pvfv+bOjFd2hDe5APuBOY2WeiRM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(10070799003)(23010399003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?K1AvbW9JV3Y0MFdsWXhmN05Kem1zZVp2bEo4dGo0Sk0ycUlIZlI3ZlJTaTJj?=
 =?utf-8?B?cDk3SlRHcnhZalhZKy9VTEwrSGZOSHZsQ0xyait1RWpWUWVtSmhoUEZYV3h2?=
 =?utf-8?B?aU9oalVwY2d6TnpQN2Z3cE1LaUY1dm9PUHkwcTFWbm1lUmNGSWJ5Mk9JWWo4?=
 =?utf-8?B?b01MSnoxMHRKYitmcml1N0ZyaTZ5TmJvaitnVXpXWEhaWEpRUGp4NjlkRnlX?=
 =?utf-8?B?NVNrZnRKQ1MzbVZET2RDS3NNU3dMNkhNV1psbnhoM2FwbkROL08xVGZxbW1E?=
 =?utf-8?B?VEN2Mm0zdCtQNlpua1JSaFgxYk55ZzVvSkhUUFlsMlhRa0hCOHkwMVk1V0V1?=
 =?utf-8?B?STloS0ZjaFdZazROTUpxTVdYRUJ1K2JEVFhZTUhmWkoxR2J4S1pLNnprT3dU?=
 =?utf-8?B?N3h5eHZPQzRmZFNXT3JVTGhISkpHS0g4amRkb0pnL1RMN2VzU2FHNnVqem8z?=
 =?utf-8?B?b09idFBpN0RGblN2dHFiay82YUU2VVVvdXNBZEtRQVRHRjhCKzFPOWN3clBt?=
 =?utf-8?B?NDBxVE14Y203VzhSM1hPdXZBSHpCY0pvSEY0TzNja2ZQRUVLMUFzN2RjSk9M?=
 =?utf-8?B?TFlha1lUaUF4Qi92cnphTDhzTjFpK2NXMVdKUU1LVEtMVzlaWG9NWkhWcXp1?=
 =?utf-8?B?dnVieW9qMHZtS0tjcTh5dk1SKzlaVEJIZnlyVm01RDcxazZHLy8zQ0pWN0pV?=
 =?utf-8?B?UWhUSG5Gck9HWmIzcEpxRzc0VC9aU0xINE1ya0FMMWViUTVKQ2ZIR3lvdVcr?=
 =?utf-8?B?ZHlNUkZ2cTZaTHY1SnB6aE9Cd09Vd2VIM05PWFpyWG5iMU9QU2R0b3lNVGVJ?=
 =?utf-8?B?ZnliTlpTdzI1R3FQbjdUTnFSeXBlczZhQU1RMFNSckZQNGtvYzVuWHBzdS9L?=
 =?utf-8?B?d0RYMEpGZUVPNlIrWVkwcUhDSmpOeDVOZXBCbUxocFA2TlNUR1NlNFE2M0J5?=
 =?utf-8?B?N3E2UTVkbGp6a01UTDFSb1ZaYkVudWpHZkRra1BsUzd1WXA4cEc2c2Q4ajY1?=
 =?utf-8?B?NDhqYjdMVUx5L3B2SmVGZE9rSEwyMnJERTcwMVBRQ2dEUUFDdis5Mlc4Nkpa?=
 =?utf-8?B?bnAvT2h0aXIwODRkU1VXQkhvQjBScjYxcVVCUXA4cG1sWTZxd25qZDdTM3NC?=
 =?utf-8?B?WFIwMUkyNHhndGZkcy96c1YxYTlWSzJUbzJUSUphUERtOEg5dGxMNmZ6Vis3?=
 =?utf-8?B?RFNoYmxYOTJiRUpuWmxEZ1EzOGlnM0Y2eW50ckg2N3QrMGRsQjJTczByU0M2?=
 =?utf-8?B?MHZ1WlVReG9XNDJWeXh3dFE3aUc4UXp0NHFaQjgydGJKWS85S1Z0ck9xSjlx?=
 =?utf-8?B?a1RjM2V2VHE4cGJLazZhenV0alZkOFo5dmt4Y2dtU1IrNzE2Vk1KcDNjZ3dZ?=
 =?utf-8?B?cWkzQ2pTSnVrTW4va25CWVc3U0oyT2xNMG9XcHdDQlpUQWFzdDhaQkU3SWR4?=
 =?utf-8?B?MXZEbENyV1dkTStrN1JDcitkTzJ2WWlaOVdhOG5nM1hwZnY1Q3RyK3FNYnFH?=
 =?utf-8?B?N1o0Y1lyYVlib0tITi9zK0VtSHhGdXJzQWl3YTllUHpnOHIyVHNNNHZPZE9I?=
 =?utf-8?B?WW5MSWQ4VlUyQkx2TEVJMzluNGVCa0VZMjBReWhwWEowMHRUdmQzajk5V2pS?=
 =?utf-8?B?U0JNM0lpUFJtTERITkQ1eVppYmFQdURUWXQ4dFVYN1ptTStkUTBmTDFyNCtU?=
 =?utf-8?B?cUV3LzdKYjc3ZFMwY0IvakRmTFJCazFlMGE5NDUzMkxnVUxvdnJacVB2Q3dZ?=
 =?utf-8?B?TXhNWEVRWEpWQzJkVkIwcGE2VzFITlpqT2tiSUxoY2I4aDVVYkJUMFF3dktk?=
 =?utf-8?B?Vk5NU0RaVkJoV2VqcllMZ1ZYb1FMNlpuZ0h0RTM1R2c0UkpZL2Z6VDZab2Yw?=
 =?utf-8?B?TDc2VE1YN295aTRoWU9PQ3VpT1dHdnZ3bXRubFpFN0tHOVoyUnRNNFBGT0VZ?=
 =?utf-8?B?RCswTzFET21zOCtMb0pBU2JvNWpoV1hWTU5aMU5OZFYxRkhjb2h6V3h0NWIv?=
 =?utf-8?B?ZTZQRTR3aVhFN2JrdjdlVTlHSldrcjM5ejJEdzhsZE9vcGkwemJnUXBJMXJp?=
 =?utf-8?B?dGFMQkNQbGZ4cHZmQWpkSnJTOTBsdjczT21FQnJyeUZHYjY4MjlabXlGOVFs?=
 =?utf-8?B?SFJHRFBEeG9xRnFDWjhmVlFpc2RheXVya3VpV2MyN21HR1U4K2ZacUN1cCs4?=
 =?utf-8?B?VUg5ZlJncjNOaGtLS3Z6cTVmNnIwR293U2NDaFI0SzFTenZmckRKMVJ3TTUv?=
 =?utf-8?B?cHdVcGFtVFcyMXFHcmFSWmJENTdsTVNWRVlyZHNLajBzNlpTdUU1UnZ1SXdU?=
 =?utf-8?B?dDRnTjViYkhKYW1tSUROQnV0YzdOWlgvWXMweWczODBDNWRhN1pKdm9UT08v?=
 =?utf-8?Q?mmF2T+K4dPzR60gUsiEsyq7tfi+C3nJleAQtJfgHgUo8N?=
X-MS-Exchange-AntiSpam-MessageData-1: UL1gGj2ZNiIDHzBxVkq6u23lmumYVEK/+7Y=
X-Exchange-RoutingPolicyChecked:
	Wec1K5rky4SVdBgbZ0aONq66jIFHgS2WaShkgpN0q8FJLAYBHFbgP9Ywql5GUNFdR4sSivw5kK4PmZRwUAaqhCIgL+ydR9U2e8JNau8KjSs3+9cGREbK86PhMaF8URE/eGZJZUhlXswp283a6DTe7w6gJYRC421E+T+x+oKu+z99ke/i4trEmFU16vwGXsG/7qICjtF5eQrkDCT/LchWp5voagezS/8Yf9xpaTVe75z/AOqLpRLdAZbIGUVu+X7pWZVcyh/gVtzAm8eLUQh24UaYoxea66XmeXv/XM4vGkwwji1UFfzhfDfgK/EyL+56SRo0FlWZnDSsqGVVC1z4/w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/9tgwTz7PpSzqvZwiACQvlLWkPYb7k2w2RlFmFuLwiMcCCgUINbuzvXj69P4+cWLIDYZ0XXFhRBEpqVGHSWzDSgCAYbuU1xOrnofxNhGLzXt9YQxtN1K/rMx3p+xNpald1iL76EcwLB9tBuUhNHZAG1P6tOWyAWUel2KbdRBNoAokW7LOdiT93iDNS1KHWbaKkCZSALP4dKowuLJD4dAZ2wgBL0pAh9vEghiG4/H/imnliUTAy6fekOfYj1MxsWSI6zZ1gJpB1Z/DTqmI+17+9jUNRy96dmuy1JXOe9L2iwAUZv3ZzzaRRtUSMjILunxLfHrMHQHtQkuV53SQxMlAFCJJeuLVZnzsEf0XngCc9KDDHZ4Xak9ONT9KkZ+/hwxkp+Vngf5cdvrJlfCQm9R86tMEhQB/O/6Yy7uALzVvYVJAPqnOgsPuCZKzRhWrZn4ZgF7PJLgbkeN3febrnjwjpBnblrK+9meIpOSRzJVZl8t4ljC6MwZMWN1YviE8XyQGZsYsdzxZ5uBaWzNJpsxu7vJNQnXvvHq970Nm1UtczT+U5R9i83ltqxxl1BECQKLoYISl5D/vElBIbzqiJOo2VAVHxssJypFQJT6JeilXt0pYj8191PJvCo9sbPr7ccN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fec0860-b25d-47eb-63aa-08dedda482b5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 10:26:17.1572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Z4Yx79oMH8pnd3mvXEuKebuVwodK3RtW04fmBnY0/hGaWtcWLa//4+//nel7wnS3iz7eBUCOidrWap8oFpiIkQqhbMaVzJ+EoafUHk1UVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8669

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

