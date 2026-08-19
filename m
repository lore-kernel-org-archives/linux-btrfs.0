Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B603FC5D3
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 10:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787136257; cv=fail; b=hZD5+NJdT/9jCXw199gIlLl/tIeD7xnbiWxZZZNpkzshJHkF5/DpDrmljdAoeji2STmd8pwQjOhX0rhcC1n6BIUJiPVUUVXHbhyPPN9LmgxSFh74RfNDEkAUsGnJ5y7178o3J5X28wJZY4eNh7+GhRzF5i1fUWPj/rSSMVUjfgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787136257; c=relaxed/simple;
	bh=r82dcWD8c2bnqVhMmzq0gSJfZjeXIR1vPtzsgYOkG1w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PhaVBLRqUJpdP4BHB7KA7uwug1wfDAacP0GTIaKQ6vu4R2lrHkUpLB53hjPUp9hLDecMYxs5FnRE/zd80CoacvZ6AIKVrm/fh22BtJTTUuZHITr77MzOXXte+7pgoPncRVWnXffEksTJc+up4w0CCVlhEf6wL7HjqRuDyzEnqX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=C0O65qPd; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Irgmr/84; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="C0O65qPd";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Irgmr/84"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787136256; x=1818672256;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r82dcWD8c2bnqVhMmzq0gSJfZjeXIR1vPtzsgYOkG1w=;
  b=C0O65qPdZ0TINRKSMNSeXda59L4LCQVYAvMGxhv+F5UYIwQwurj7UhUu
   Z6/5m4zKJ0i3IEGAhT933R5+gwPvEdXrFwZZPFMG1YbsMhF92kK3jhepK
   EpZM6tmJ4e7Hlz2ptEceW9/tj6lq42BRuIe5j1E4+F5AOZWKMwmphczMR
   CS3sibAjRnpFR8009dDDjlW8iGA3BZ+uSLmA+zSaV0XsZ/WIWDl0m5cJ+
   jkodSaLhBrHvmSkokyVIXihe15FuxOO74fogu5E/RxNbRN8QCmIEjVSJ/
   7Q680GEb3nyqq5Q+1p7tgCvE80w+w3yVWsY4J6ZpNxm8xgFPQt2hvZhA+
   A==;
X-CSE-ConnectionGUID: HsjI+Q/XT3W6KlCIamucHQ==
X-CSE-MsgGUID: OxFch249TNqeSx1Z9asPhg==
X-IronPort-AV: E=Sophos;i="6.25,231,1779120000"; 
   d="scan'208";a="152876401"
Received: from mail-westusazon11010024.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.24])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Aug 2026 18:44:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yRMPEKvYtKQ2kJBU0SpLPKsxSdF2Cl6v4HK5QVmSuGxNLO2zp/YrnOpC4oWSxvl4ISzAkbo7UNgvasNehkcUqlKHqK0YTUm1HZkwoRI96fKfrMIb7NZBo14V+PSHqRivnVRYsoAkr0ybKN0JUtSW97n9w9XMt6yM79mS6Y8YyU376pKvpd3bB7jmcxsKzB2AtqZ/zx7noI5a5GcN0IG0duGASOzmPZOoV/3NiNCFNrF9QkxUUcDN5FkQuJ9oh4lDK//DWT6KQHxdwRVSdMNnwnZNx3HjD/17I0OnU5RIRwGbGqgaC6GNtzKSRNwyx/GLvHuA8wisN6/OkCXmpbanWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRXpvH3l5KoT52UmyfHAemZmPFL5WBHHkQ/h2kw4rl8=;
 b=sQbneqJsYXGDWMvIP8db7lX2TKxxi41G/ufG/8owIbSurC1QLuQ8VtWa+nnZvEYKZdZr3KMUma9z9kqu9/apSWJmSgWG2r5hXamJky23tVpv/VS8afVIDtmWIPVzRu+q0aiN2hfsGQKXDnX0jzg0us71ml8D9SUQy+D78sMeM9zj+Yn3a/shtAEK1uz5a/V25J5Scgd3kbNt/E20IVLUAbBYKgTQ5aZAwy/mCkrxo9KOAmaG0I93XMGrrgUFAHyQG2G0P4ajsezHPn0VbeGFNOlUA+Lsaz7yct1LWVjqxHHXJ9uSZDsJk7JRHoMD4VKoWn7IltEDEbgnA8d3cY7Hbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRXpvH3l5KoT52UmyfHAemZmPFL5WBHHkQ/h2kw4rl8=;
 b=Irgmr/84nesRcsuOwm5JCMeZnHG6ntizYu6dCd6F+CaK21RQ272nRri4NszlCBLSWP6Fr7gvIAwEutDVrQ+v/8uFDync3S5g/ac2IqMdVdc111f4jRE4WGf23oZk6uXmb47V6/dc2V/II3Pf9kZnt3dlZtPgpP9drm8aTO60Kd0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MWHPR04MB10284.namprd04.prod.outlook.com (2603:10b6:303:29c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 10:44:05 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 10:44:05 +0000
Message-ID: <9893c77f-eb82-44b6-bfe7-ac931be762b5@wdc.com>
Date: Wed, 19 Aug 2026 12:44:01 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: finish active block group cleanup if
 call_zone_finish() fails
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
 Naohiro Aota <naohiro.aota@wdc.com>
References: <20260819102636.1423347-1-johannes.thumshirn@wdc.com>
 <cd693c05-8b33-4888-a0f2-318183625633@gmx.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <cd693c05-8b33-4888-a0f2-318183625633@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::17) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MWHPR04MB10284:EE_
X-MS-Office365-Filtering-Correlation-Id: 6567b187-e402-4594-bf9d-08defddeca55
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|23010399003|19092799006|6133799003|56012099006|10067099003|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 AqMkZzxq22eIfX2aQgFqW6NC+EhOMODLSQN6N9O7/AtIiSb/B8CXFftGZe8jJ6ZO8/QvsKU0fBVH5yzs9OzmsUcK13N5QnHMDemWPjQVW4GXH/QfLW+ipHnRs4XjclNq56a8L9AlOPb0hdQ6qJkPHzxNH475aolT6cM0mQiLUw1/+0Sh8X8UBmRYUABSuiEdtaeARxJB37ZvdOgo/LguXQDpVuXpi9hhHwYlwIOM3by9eHlGS4UyrA9ElxwUfuJR5+9l7NKbD8Xtf89oxKFEKueZGEKRqkpxaQB3OHlMZWpOHeTfYyicjGEUlFSgLpGlgHg8ARBjqw63kgQGeHgGAYoleLR2cQJR3T4NW0qQQacQ3QZll0j0Jr/0uLEe0/XVD/62nlExtJcBBwFepMm0/qdL+0itpmQMaBa1ESsa0bgS9lSgnBBsQYfbii0TSdOVXj+x9aPA2hOhlX4Hvhw7KrmnGVDGklFhFesc6uGG9Tfcd5Q7K+SMe3fy2Hj+NXHSVsw9/1YqkDQzQB+f8VqU/nt6/bZWmL4V/u52ZI8ta4yksRAb+Nl8WHkblLyPcxecDGTQThmxNiC3Dv+lJ+V8oBCOiqyb4ghI3Sl4uD3E7j4=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(23010399003)(19092799006)(6133799003)(56012099006)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?VFdFT1NkamxvZFRlL0RFYVNVbUlhR3BpeHRmR1AzMm1KRG9qYy9HWVZ5QlJR?=
 =?utf-8?B?cXNuZkJqWHpuSEJ5R2x3UFRVWlJQZU9kWjZ2UnlFYnRMb2pjSVpCZDVwZjgw?=
 =?utf-8?B?RXA5UDQrcU1xQllHYlB2QVg5NllEZFNPMWFaR1Uzb0xpZm9qd1kwU3JOdUZM?=
 =?utf-8?B?dkQvdE5aN2pham1iNEVlYVJONHNFV0R5a2xKSFpuNTBYb29wM3BaVTJLeVZy?=
 =?utf-8?B?UWpkemlQQXZXTTZhTkhIdFlyamF3MUJwaFNqcFpGVTNJL2VkTXB4LzlvUW5v?=
 =?utf-8?B?VjZXdlR4ZGpXWFBCcGI5LzBLamk2SlcvTHNxZUtZOHZhbnZnMmJydXZxRll6?=
 =?utf-8?B?WVdHc3FVckNHMlV6V2dEdkFHV0FUTFZHK1ZqSXdYSVh6RXhvTjJUQXZkVnJV?=
 =?utf-8?B?UFQyc0hDZ3JpOTJNRDZZbDh1TjBhQnpPK2UyUWFPdCtZT0lrMVZIaWQyejNn?=
 =?utf-8?B?VWN1cTRtd1NFaUhEWjJ3c2dYTW5DcjI0NTgvVFI3TnRaa2RzaTMxWnVPVlpl?=
 =?utf-8?B?WnBuSzl5NFphbG9DMk5lTERQaVBjSkZ4NTFKSWFnNUZaWXE3ayt1WmZFcW0v?=
 =?utf-8?B?VzJNZDZqTWdITXJNQlR0S096OEdZNmpNMVIzWGxjSk0zejUzYzhWMnpPRkxo?=
 =?utf-8?B?OFVkKzBmNy9Oa0FXM3FEYmVib214YmY3UzFNWURqOFY0TE1DNzB1ZGxpS0Jk?=
 =?utf-8?B?Rk92VUFQQmllNWZCMGFHL2tvN0tzbFJTdlFjRmdpTHFmNUoyYzdUalJzeGtu?=
 =?utf-8?B?U3MybVo2Ym1QN24zTE9ucFZ4anpTMHV2NmFUT3BXUHlQQW5JOVc2LytkL1Zq?=
 =?utf-8?B?dE12elB6UC9SazdwLy93SklkNHpEUXl6ZDFRanc2V0ZqR083RDBKMW5PVU5z?=
 =?utf-8?B?c0h5SnlzT2Z1U1Z4RmRDcG1JeG5Nb0N6Njh3NE5HL3Z5dTFkTjNMcmpIZisz?=
 =?utf-8?B?anBDOTczTTRrR1Rmb0pJVVB5dmtzMkZldTBwTnRqY1BXRGt4VWpKZEhqV1dB?=
 =?utf-8?B?QjFoN0tzNWlZaW9aUlpYUE5URCtqeEwxZjgrRE1MS2doa3dWQkV2Zjk5S2pK?=
 =?utf-8?B?L01GanFuVHJsYzE5UURENVlqZ2YxaEliaWFxMk01UlJYNk1zKzlGZGZzcUs4?=
 =?utf-8?B?M2J1dlBqSXhrVzFtR1MyejJOWWR0WFk2aS80dFZLSForTWlRZXRqVGJmanpJ?=
 =?utf-8?B?ZmFVc3dZU01OSC9qT3NvcEtzeU9yR1l1ejRZc08xa05rQlpsckN3enNZK1pN?=
 =?utf-8?B?M29kRGlZYm9aV3IrejhwMnlsdnFLSE1tOHZHNzFEcy9NNkcwZzZOZlBvd29h?=
 =?utf-8?B?VWZEM1l2blhIc0pEM3ZoWlZXMVVXRHdxaUE3dDhuZGhGTURISVRyRC9oSEN4?=
 =?utf-8?B?dmR1QzdGem5OdTF4UE82SjNOUmhCY09qMHhMdGMxVTlYRWJDUUQ2ck01bFVr?=
 =?utf-8?B?cENJNVVERzlUOWQ3cDhQRlcrWFdYVkpLb2ltRlUzK3dMN0NWd2s1ZHhVUFNK?=
 =?utf-8?B?RS95MW5tYktPejZHUmwrRjJUOWdKOVZDUXJPcnY1eCtZa3NRVGdNSjhkTkNR?=
 =?utf-8?B?VHNqTUNJU3NHQkc0bmt3NmxBV1Zzajhwd1dIOWZWL3dOa1JWZEoyamhXTjBl?=
 =?utf-8?B?ekZOZ2VZK3R5V0VmYTdabm4vb1ROSFUzMTBuZmo4MlpHbHg3dmRXMmpQZEdu?=
 =?utf-8?B?cnhnMU1kWUVTTHRDV1NNQUJ3bVNXN2FNOUo2dEl3RkhhNWFiMjIvSDlUSnF5?=
 =?utf-8?B?UXNGTlV3cHZYQ0tUVFVjWTV0SmY0dTZINHQzcFNFQmUvcmVMb1hHQytlaDJ5?=
 =?utf-8?B?cTZvcGtSbXI2MG05SkY0VGFacWowOEZwVjJidEtEa3VkL2xzL1A2THJublp4?=
 =?utf-8?B?V1ZTRWlmcis0Lzhld3JnYUc3S3BCWE9Rb3o1Z1NxK0RKOGxNR2FjWGpvOWdt?=
 =?utf-8?B?YmRlSC9GWW1KRFNwUjNXYTliVVJLellUWTFCNktnU3BzeHovcHJ0blNyUi83?=
 =?utf-8?B?SFRXR0NFam1sc0NkZ3J0ZDdRSndTMDQ0M1hOTU5lTXRJaGlwMzJjcFNFa0Ri?=
 =?utf-8?B?bjNyRHMxbWJSVDNkdUtGSldaR3prN3J2dG5BVUpYUDYwSm43cUszU2hFSUxU?=
 =?utf-8?B?aC9Xdm8rY0k2WmE2c3NibjhzK0FxMERHdzhlWmxKeEYxVUdlemJoZUwyQ0d4?=
 =?utf-8?B?UTczV3FzZjBTcjFWQzRZRCtUbmhMVXN0THoxS2VaNVF1TWY1d3Nja0xwS2NZ?=
 =?utf-8?B?ajFPT29JOE5VS085RWtzb2RhbEIrR0ZER1pGM054NWg0WEU4QjlZTVpaUVpM?=
 =?utf-8?B?QTQySnBnZXRET3l5TDNKeEhWY244U2NQakJ6VVdKYTNrYS9sWHJvaDBjRmNa?=
 =?utf-8?Q?iQtyjViDXQywk470BfmLCzUqhCGdqRKVjOxECTsg/2RY1?=
X-MS-Exchange-AntiSpam-MessageData-1: VTw+v7SUdqThjVrPF5R0uZ0784sHt4e257w=
X-Exchange-RoutingPolicyChecked:
	q+8cb09Jd9c1GMPoa8rrVogI7Dvc11AALgpN0V5pOw4bAqWwRw7YtxV3iN/O97Te9F62dH6JpmKLLH/fCbkRHiQprgYtIeQ7kgOEjMhCMNWOwIRa2FVOoxWnbc3VkcHBRY2N23jYuVjsx2K5FaU3GTXdPPe87xcD30LREABnbyR3vMYnsK23t+yvO0vkdLl1pY9886YKMGPpbPAQWY+b6H9Q2ppTS86xADvlL8uboldI7Dd/4Qc70c5ut/qybNjffi6GlGKa7GLsToaw8X5RY6Wc7fZGljDjlgZtznfkYvRJtuHUE61+4QGoRkQ4EA/0hmXgz3RgiT0ShDA/aOl5zg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SIuR6jeCEJNAQ7piXouOjdiu84HElx+QQno3QCibZu+zq9IGQUt8FecVzDsP3W7jEJ7DsiZL8WgKlwme55v5wiKmavpZvykMpc7eACkzLwvIX1tqDG1zI2HvtiYhmo07nJiTHL00fpTELDTGqU1G9JrpM4r2xJ+kTId4uevk+MxCp1n7s0Nr0C2EVGL+TJIbU6Mn8swgXhx0MIzrlIqf5lqvifbkHqk6XxWRtQdVmULcZEAZ3zyEtijYXiIB3L16npZdbYVfFmd2u5o0sEaq4KyRiQRcBcWoR4i1tK8bnt4eurHJjcp/tHsm06mQ5lnceWjOfj9DtLHjuWbMIhkMAlCmZDOl8eUAftyck7ZXfEPxiq6abms8XM2LFtuk258MgI7xGP+pf0akJbzWZEqjTw4qT6HPxFSO0yK4/8QD/rNFlj+hFyQfJThFw58ml8Bve7AKO7WMduI7DOFf6Gg0L6rhjEc7SWlBIO60cHkkQIG3a2B0x6iFGFVpRRGdRJT+h4l1KTBvOhSb+eJqNJYxCdMzcLhvYCrTMzaz8UfbaeU03vswQpRpQ2rlHlFrWHc9m2KDYUEXIb+jQrNz6Qp15qahhYNt7ymie48zRVwRP3k1mne/MCRinBVyxbdWd8Fs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6567b187-e402-4594-bf9d-08defddeca55
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 10:44:05.3174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TLbVSqAeYMBNjDcD2gQ7DSCMQGG1TdQw4S5kofqCUp7mz1QncwRaYQpappHC/LhOaDWdPCIPIeO1rN3d3IvgMdif5AGSa+HsPulDYn3RFgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB10284

On 8/19/26 12:36 PM, Qu Wenruo wrote:
>
>
> 在 2026/8/19 19:56, Johannes Thumshirn 写道:
>> do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE before finishing
>> the zones. If call_zone_finish() then fails it returned early, 
>> leaving the
>> now inactive block group on fs_info->zone_active_bgs, leaking its
>> reference, the BTRFS_FS_NEED_ZONE_FINISH waiters are never woken, and as
>> its alloc_offset equals the zone capacity btrfs_zone_finish_one_bg() 
>> keeps
>> selecting it, spinning btrfs_zoned_activate_one_bg().
>>
>> Fall through to the cleanup on failure too and return the error, but 
>> keep
>> the block group read-only as its zones are left inconsistent.
>>
>> Fixes: d70cbdda75da ("btrfs: zoned: consolidate zone finish functions")
>> Link: 
>> https://sashiko.dev/#/patchset/20260818100037.1366563-1-johannes.thumshirn%40wdc.com
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>>   fs/btrfs/zoned.c | 10 ++++------
>>   1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>> index 82c2394dd43c..9d448cdd60c4 100644
>> --- a/fs/btrfs/zoned.c
>> +++ b/fs/btrfs/zoned.c
>> @@ -2628,14 +2628,12 @@ static int do_zone_finish(struct 
>> btrfs_block_group *block_group, bool fully_writ
>>       for (i = 0; i < map->num_stripes; i++) {
>>             ret = call_zone_finish(block_group, &map->stripes[i]);
>> -        if (ret) {
>> -            up_read(&dev_replace->rwsem);
>> -            return ret;
>> -        }
>> +        if (ret)
>> +            break;
>
> I'm wondering should we continue to finish the other stripes instead?

But then one stripe would stay active, leaking that HW resource.


>
>>       }
>>       up_read(&dev_replace->rwsem);
>>   -    if (!fully_written)
>> +    if (!ret && !fully_written)
>
> Not familiar with zoned code, but if we hit an error, the block group 
> will stay RO.
>
> Is that the expected behavior?
Yes. If zone finish fails for some reason it was probably a hardware 
error on that zone. So my take was to leave it RO to be safe.
>
> The branch for bg with FLAG_ZONED_DATA_RELOC case, we return -EAGAIN 
> but decrease the bg RO before returning.
>
But in that case call_zone_finish() hasn't been called yet, so we don't 
know if we have an error from the block-layer/hw side.


Hope that makes sense.


> So it looks like we should always decrease the bg RO even for error case?
>
> Thanks,
> Qu
>
>> btrfs_dec_block_group_ro(block_group);
>>         spin_lock(&fs_info->zone_active_bgs_lock);
>> @@ -2648,7 +2646,7 @@ static int do_zone_finish(struct 
>> btrfs_block_group *block_group, bool fully_writ
>>         clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, 
>> &fs_info->flags);
>>   -    return 0;
>> +    return ret;
>>   }
>>     int btrfs_zone_finish(struct btrfs_block_group *block_group)
>

