Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76798405C4A
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 10:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783591622; cv=fail; b=KmiC77J9UFYJFF/zXaSKqbr4YhmveiMGuMLMLyUnf53t5PPxLP91gtXp0FInYVVNVbJ8+tPqszHo18aM6qiZOk0LJoeP4/V5f6AOVOwB/ynGzodw995QEHGSSE9LI4kzevCkljL5rANVkxrUQY8M51h7OWfYBH1YRGzCAkdJLow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783591622; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YMGkJIlJB/gp4wechB0qLXHw/yE3gcESJ7E96flMzKks8PCHeMawlxkIi6aXisgx5HzDnJnx/Z8Dkp90beGcPsxsGHNnIqIPgDExhAhZzjMz4Y3gLYgPwLurtI+WVtFqXjCp17ss2LdchzTlD0WkRKE64LVxbAf+Vt/cyWr/AxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=io82IjDX; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Q54JSN+1; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="io82IjDX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Q54JSN+1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783591621; x=1815127621;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=io82IjDXsiO5xjhKhV7p2IAVvOcu4K6zjVzPTf2IFyKXSubncRji4CMC
   TVNaHHlp3Gr7dniV31+VsXNwXhj3I5TYAbAQnDDbE1v1VYWzIERY7nJPx
   fH5aPQgcmvSk9sKTXnGt1hqXN9tY3KvLFDXZsbyFYePyHl5GPlgxW/nPp
   QotblMA32FLzV7eeWngFAvFX79lenNtBEe7dt4CpjvDsT8J31chPbzUQW
   rOe8xGbscw9jBVCVFEUsHmcBDeXdgVTSmXmwGNNgbG76vw06a7+7sJdQt
   euv+aQ2QhEv747pZbbFsrtl0CavMFUMLFJ7WunVaUsIdAd6tb9ncoi6q7
   Q==;
X-CSE-ConnectionGUID: jEK/fG6BR/uV91G7ljpBnQ==
X-CSE-MsgGUID: inU31sw2QSWbDYeAFZ6EmQ==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="149154672"
Received: from mail-westusazon11012054.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jul 2026 18:06:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tpWlH42oDInuk7YU52MnAu59t21zS0JenWSYvB0ejUTJTIq/w5zMNSZHnTcuSJosOrLtTKNnbUalUoDz12isYm6gpwA0S/D2t3dlGyk6/1enzzg33hbz5+Oc3AvAo8k9IGkhN04avgfELRpiZ7DonzblUCW1+0EgBroBXy5qPB2d3vanWsttbZsvvOS00skgE6D1IMFbuiJV4JpGuFZqnMhlJnBI6LxbTh/P+9pnidXRzXyz0J5NLs7ZdjYZA00gGXmLuHVvL8OU6IJPXQUqiCDKw2ecnjUc4wemwzL9EXmVoB1AFzWlms/Jk2XMcXYNpMzN6/Hav92xfaAGoGJwKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=PbO2KD3Fy2hF0W5PWjeTnAnG8d9MFdte3d9tmh3ImJa4RCLrBoVbJ0W9ixa5fT2KZP3GgLnEvlp5MD5sLeDALMZqYojYlCqHON2iHLHDDcgBGxyxLPU6PWTfu07J9f+ADww0PBdFjs7IiOidy83sab228IaQXGfTW74uDkp5JViGTmoch5e1a+Tuir/IK/SYYQ9lsvnyDgIdzFFyUvLX0T0dRBGg3C87kNjMF+XWMmWdrGsfbI+b+WH3DW6i18cV3J6enId3ZYzpq5eXnN+lVHAODZEHbyQm5VG+eT0ygXJp4i6ZmjFwCrDLO4ZcfdEDAf8g56Rz9gqpfu7xHZDHpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=Q54JSN+1gVlknUb26uTwekFtOXpGCnRDzHalgBL6Rh/QL2cUhavlPF5da3C8xpngqCJBoTPz7OieVuXSuvMJ9IBTU9Fl0v7ru6+HXJCt2b93NgsZ1+FB+j9ixLsy2af6z9FSkg34S/5jcRQ6uGWJUs+f23VFb+dWY4X51SbKg6k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB7079.namprd04.prod.outlook.com (2603:10b6:610:9e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 10:06:53 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 10:06:53 +0000
Message-ID: <776f896b-f642-44fd-be40-220d151fe728@wdc.com>
Date: Thu, 9 Jul 2026 12:06:49 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/4] btrfs: extract the common scrub read endio into a
 helper
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1783252371.git.wqu@suse.com>
 <8e8f62c681bc0208796eec03ae161f3d62925eb0.1783252371.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <8e8f62c681bc0208796eec03ae161f3d62925eb0.1783252371.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0164.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::11) To DS0PR04MB9439.namprd04.prod.outlook.com
 (2603:10b6:8:1fd::6)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB7079:EE_
X-MS-Office365-Filtering-Correlation-Id: b9092c05-3d31-4ff2-04a0-08dedda1ccad
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|23010399003|366016|10070799003|376014|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
 FY3VVtAflydXrjPvd0Ovb5eosm1AeIdiJgtc+r/95Y2HzRPrVaiSJPR9PVaxIY0Afdchs1H2ls5VRM9PjUSA+03QHu6oJc7Qq5s+Q1RvbdOncfoNIwByLMFo9uaC+JD0Qe5mMH+vyQoS9+Hh3GNlwmu8AltA6EolZlSiJSUTsoUPIQEVxg0ceTPy4dbyB3lj3ctxpYcMPCSuaei0Kn0BgJ337RTKioBfLcIktAHyed0an/Oi0k1mykAc0sIPW19yPJdRpukt5mxzIOj9NK8SlIJ3wbXnHFZDwoQA8gTUBXeNL0z9YvwmOyb+/rsQk1hUPQzy1nV9AXvdXD21AmWLC/MT2R193VYd9R+8F2TEiDXmXAY0aSZT/JtOtvOcwUqh7bVsp+gXFvZJrymshOCOAmoonNH2exqVzy+EZEivCvlrAjQSBhn/DMU5M1JcMCsR4E//y+FGwBpxUpZOI3ukbxJP4z4Naqszgm9P+x+YZ2SJGYZta1t95UKWg2Cbk7z3UH5affSi99PxzkzQ5uzzwYU8whzx5bVCGaQHSXUda1Mxxa7QwlSYAPk/n4asfyrtcouvtes0xv2IZsP8sDogOFgxvLaRuqYOd1aP5kwanOY+HqRoTG25Z6FZRA3rwOUMYq7HLMXER/dEz3dRZgvfYIY14U9iMcZX+LAn29w5kSA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(23010399003)(366016)(10070799003)(376014)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?bVpuaW1nSGl3NGJ2VUs5dUhoN2FpcldYZ3BTY3pJREF5V3c1OG5meFZJTWxl?=
 =?utf-8?B?RUVObXBRa2VGcTllOXFVUWJ3RUxscWw3Z2d4S3duV05NMFpyZ2x1RGZ6M01h?=
 =?utf-8?B?T25DcjZwcXNpeGM2ZEVzMWtPKzd6cmxsL2Z4NjVoM3RDMHY3Y0E4eVBEek9F?=
 =?utf-8?B?R3lmeGdlcjJZd0lQOEtOUk5vdCs3THk3SWFOczZMMnNVR1U0K2ZJM0R5RmRj?=
 =?utf-8?B?dHdTSEorU3dHK0s1bE95QTM0TVlKT3E3S0ZsNHN2VGwrMlVQQ1M5aVhHSHV4?=
 =?utf-8?B?dXFpNFNnaEtkV09ZTnRoSTlsNWtRaHBNSDNrazV4TmY5TEhDNXhtejNiT0dB?=
 =?utf-8?B?ZnNna0RNNVAzNUxuL01KV2pCS3diYm9VNnlhWURGMG9GTzUxTkZHWkRvTnh0?=
 =?utf-8?B?TFV3UTZkWEJYaTRmbklZSnEwWldTZVFiZzh2bnZ3eCs0NHp6c2RhemNJalZy?=
 =?utf-8?B?djlvZmNHR1hvT3ZnblJZWjVjaVJXcXhlM1phazlkRytzUXVCR055NkkvYk1x?=
 =?utf-8?B?cW9EN3lTRTluNlp2ampQMURKSTNNWVRiaFRMQ0E0SjdIRFR1Yi9iSXRzZFVY?=
 =?utf-8?B?VVVNS29YRVlIam9MQnFKbFB4Y2o4YVU2MkdTczlqUmFNbkplTy9Qb3NGUzll?=
 =?utf-8?B?cDcwMDEyaytsRll5NDFnQkhhaGtlSmUrelFQVEVPbXNONWEydzYrWVdRN1da?=
 =?utf-8?B?TzFqQWwrUnBKM0RCeDBQZ2FGa2F6Z1Q0R1lNb0x6VlZ6Rm8zdUVpanRrU1Ft?=
 =?utf-8?B?UlBmTVJ0UDNnaksvaUJIZkxvSmFRK1YwM2ZQQmJsbUJQdWd1bGU4VnBibndq?=
 =?utf-8?B?UmlCaDFSWGhYcVcxNkRkN05mbXVkVFhsREZObnFiaWd6ZWlXdnF4VUZDSnY3?=
 =?utf-8?B?Z0N5a3p2RWdZWThMU3dLSXZQZDUrRmJLZUc4YUtReFhFVGQxYzVsTllmUkF1?=
 =?utf-8?B?eHdqZUhEdVVZTzNuMzVHMUczamo2U3JaaGVDQTVnNHVyTWJVRnYwRjhVU01u?=
 =?utf-8?B?T2J0UDNvbjN1OTI1WTZyb0ltREY0ai92WWx2Y3FxSjhoOU5ZOUpPSEl3bnd6?=
 =?utf-8?B?VFV2VzVneHdpWTZqbFBnRThGanhQazlnSm1BMDRVRFUyK2JVeWdVaXFPRWVv?=
 =?utf-8?B?UmI2Z0R1Q0ZXVU9Wd3dIeTBSbUIxQUpudUx2RWVuUWRWMVBFcEFyMnBkbXRQ?=
 =?utf-8?B?TXRKSzBsOWxiTlZMeGQ3eTBtbWl0U1BJczUvOEhkMzA2VFBKaVpzblhEdHp6?=
 =?utf-8?B?clU2VC91bmM4b3ZRYU1iazYwR0Ywa1FXcnVZSlRHRVRidDd0NXpCOEpZUlJN?=
 =?utf-8?B?NmRhT2VmV3FDUndQbTZLMkRmSmpGMHdTelRObS8wbXUwWjV0RWVSTldaZmJN?=
 =?utf-8?B?dGkwWVRjcysrcnpxTGh3bGx3bWgwdmw1bkN5QkwzNUZhTEtWOWtyVDlzNU15?=
 =?utf-8?B?NnhvdGxEQlBLUTM1V2ZpdGFCV0pXUnVHbUZZeThpTzRMbi9EK1p3bU9vNktu?=
 =?utf-8?B?NFlFRlpuQUhEMVQ3UW5ueVNFeXkvMlZMYXVZMUNValRWM0xBcnkzdzEzVUpK?=
 =?utf-8?B?NUx5bWhkMWQ1Tmt0RnpKempvdnkxbjIzUWNkZVk5Zjhpb2w4YWsvMStKRWRD?=
 =?utf-8?B?NXQvQnJ0amtrYjVjRkNHQWZEVHZMUVFUZ1Bldm9LK1p1Q0N0dUpTaHBIVXUz?=
 =?utf-8?B?V1lpMWZ2TEFIMDk2OEI1U2F2R0kxTHRCT29RL0JaNElaMkt3LzdxMzJjNjAw?=
 =?utf-8?B?UndTT1llNFhjTG5teUV1WC9SVS9NV1NvNXFXQXl0a2R1a3ZVSHlNR0ZJQjFE?=
 =?utf-8?B?aG5Hb1VPdTdXUzBJV283bWFyYjY5UTIvK0R0TGZ1MVpqNWM2dW1PTEZ1aU84?=
 =?utf-8?B?eGhPSEU2Z20vOWZNZ0drV0k3Y2IzRmc2TSticG13WHRPK292QVZ2YTZlRDZ1?=
 =?utf-8?B?YmQ5SWpGaDhrOVZhRzJNNjFpWDBNR29UcGN3NjdxaGl0dnVrRXNaVURsT2Jv?=
 =?utf-8?B?WTlPNzhOOUhXVmcyRmJLeVVTbjhxZXZVcllON1VNazZSS0dhZVFlTDdvYk1a?=
 =?utf-8?B?Ukg0Z2J4Sm9FUG92Nm9xbEZoWU5WWmY1TkMrbGVFRkVTeUl3b09MVlFFV05q?=
 =?utf-8?B?U3E5VUNMQ3Q0M1A4ZURvNmtBVERuUzZ4cm5SaitXdkVQY21KUDJRWElGZXlJ?=
 =?utf-8?B?dHRlZWUwU0poSzQ4YWt5a25jNDBXcDZEbW5QQU1tZXhqYUd0cXZxREpNWDhI?=
 =?utf-8?B?ZHhCNkRPWm1sSWsvVUVnWTBLVE5tRDZSZDQrbWVNZllaTXBZdUJZcjA5R2pM?=
 =?utf-8?B?STBvcHdjM0JrUENrcGdSSWQxU0hieFZiN1dmYlBUM0IyMkVvS0lpQVhvODE3?=
 =?utf-8?Q?HsN1ShZvq3gshQGmc7SZmkmgmjKRNPEWbA2kaev11JnQ1?=
X-MS-Exchange-AntiSpam-MessageData-1: agwgLFUIQ9nS4iXEh5hhVNJQHxKZppGNxuY=
X-Exchange-RoutingPolicyChecked:
	Z9fbozbADd3HfDVKTji0g/IUYkA+2pvUANiRSN/7PUBAIew4QAfpKgNYcSvnVgXvr9kIZiKhwTOCrFYZ7PYh4gTP056ZBdWf9+YdTZFeR9Y7KytF92Vhwu1xu4GqZ0EhDZ9COC7WEK91tIQMrRHDo1sY89OCljipzAjJfCuYmMfduyPAp1hABL7nbm0MrkkGV/bnjfpSkyjlms3t2+bEeg75i94JUIhWo6Rh85o+r3pbhyNIRfGDmKHeBcHUl2iv7L7ThWikBhk6a52k42D+XVg9MUAVhk9Dwo7QwwurEd9oqEQhEiOunRVqzrbLJ1BZcQ2uCiLZrXU2Emimz4jtPg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AQEF1W3cSzZqZzilmS5fs+0itZf8iZL++fOzpJ/8t+JRWJEI44Kco6J7dsB26vq30TCNNp6s70vlxC68kxe+hAdP+ABaCBqn4mfJcdDsBD27OiaNC2HOg1ABzVAPu7PRd/BbtidcR+KKu/mVn2DrnWObgU/X8+0yXZZnuoDXhVusIrXS8JOHU58oc60Ax30XoVk+uV/Dkv90awvc3VsUyPDgqVX610sgK+Xda+NqyaW8EaMAE/oTlyZdvPkCGDXeq37l++6k5ltdJyUz9wJlnq0Z8kXKPMNQe6kxnTofnX158gnyPwhMkbap0e1rurpvqgEWJLEu4L9wih74Ua5cY6aGT994yRsNrXeocn73N1XZqPvB7foZSalBIKq0p5rMWi+QfKRS1DmC0yO4ESoM5CYPCsaH+lfaVNOJTPvkn4k3bON94nuU36cSqLTQRnhC9nZjFuu8L02G4rHDWuAuw7sp0xtddQCMS2qMD7Ez+6Bn2v3zYGh475CEDQNCxSDiIXL1he9BfnKp/koQ7+pjMmnxMYCsQAPukPJ+oFrHTH0SuDMuFnGUPvJ9s1xJrcZqyqdutK6NOAn4N457LEEZpSx7bKnCjlLivM7EbToaQUM5tbRqtpfBEg6Q70ZPd5kx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9092c05-3d31-4ff2-04a0-08dedda1ccad
X-MS-Exchange-CrossTenant-AuthSource: DS0PR04MB9439.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 10:06:53.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ezMxSUit9qB5pxlUBZiZZiYqzqIltAW7g15N8kC9p8teB0nhJ7M9sUr0JUGxDkg0BsLb6e79LkzQsqgJpr/Yf7CRDIGyAYiMgmHKcveDwY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7079

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

