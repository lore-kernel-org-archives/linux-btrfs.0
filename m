Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA60284883
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 14:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784815428; cv=fail; b=cT4dDtTzrIuhe43Tu/inv0OEH3ePWSuph7N6WSpAiC7LNjmTisTRE8SnG9uQ9L9KzXeoecx5sm8B/9Ro3XqF85WYKISun4IjIOx1Gr5J3vgfStngyvVxMrHiNOe5OsrDGntVwDZCg9xtg7d6KneKU8dVOyUVRg7d6sdTU16Qj3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784815428; c=relaxed/simple;
	bh=sURe/HnU8C4HQ9Fl52vdPcZT5gXS9rcczoVy6NMTw3I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fpXGEt8T4y0CbzSVnper+khpPFIfxk/W7ByxaNybocuJWr0g8HKMPChhldchcpMxRQbAh0ysOPwacJ77aogWozsOc26Ep7YUYoZGHwdVEmzv2mkIrQLxiwR2kW/N95OhchVmud/CqdvHpl8USRRZt2rgMf8Oib6TJXnprdSC0AQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=c6aYxOMu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=zoi4Xc/1; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="c6aYxOMu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zoi4Xc/1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784815426; x=1816351426;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sURe/HnU8C4HQ9Fl52vdPcZT5gXS9rcczoVy6NMTw3I=;
  b=c6aYxOMu2Y4qyQUe5A1wMN9OK+2LIrksk1Uxmc0YVIu68vpLrtjKgIGV
   awYqfKF3Lb5Klhor5swdbBNYShgKzrT8vZ4zxeFm6PzhcvC/GNsBEVuNx
   labqjwqsvmNbYEDsexh4u+4o2PodLUum5/DKfZaihv0Gv0FXNjDp9NPf+
   QO0PjjZcY3xOA70skNIZ0eMz5vgOCOAPyWrv/QV0ArmtOVSZWJfWnYUl+
   VGbHzs61q4979Wn/g6DMJz8ZgRJPAPBy2Qfr+hTlXg8nYlPCO7UtsPG/l
   DQwB0FHCieu+pk0KjXfoZmEQ2CZYDooS86iQHqFH9h6vJ/nqNO0/92NPs
   g==;
X-CSE-ConnectionGUID: UO3R6lT0SSKt9OhMDQEPoQ==
X-CSE-MsgGUID: ZZFWy6eIS0eWZhRVWLlskA==
X-IronPort-AV: E=Sophos;i="6.25,180,1779120000"; 
   d="scan'208";a="150087642"
Received: from mail-westusazon11012060.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.60])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jul 2026 22:02:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pvqQx2uJC7I3HjVqMdiSLRVais8d0tvHF3Dge/WdZ9AAMUzj1/vEiHyAy3vj7NfsdUPc1QaPSK69tkBOneXsZpPEImd42aBjN9yLkugaXxwpYYohrJln8rkAvBqRJJrZCPe8VAtM2RZhZqFw5X9K4CAyq0LbdxzCc8Ro+LcY7yxmzZR3tNJjsXNQ5ykxHiwWnApsTKZa3AesfCYDjxQfrClhGnuaPoQhOwcwUnvgGOdxNZEhIS+qRvRMeYGM5E0VgGH9zRpam5Dh+Xbvs0SgNsKnlY4mWMUkEWuCcIeVgCkAYSTYf6HsXKNWFZr3dNPv+r0aSVUgsNnBpCQMFMdXnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vo/+egeZpn/VHD6qduLZjetf2fSbOHpFAZ1OZg0DHDY=;
 b=SLZ+wh7hSousqPAJY48dzkSZlw3NWrioFNsWAiZl7Yn1QQxaCkQdEfRCFx8QTKvCYoXtlfMbRK9QMvfqw3vDd6tbqBTLUN5sWx+6DY/tSRZAXBXOY0bfBoFuzQFxaig0QPmjaN2e2SJ4773mtRUj41b1UbH2sCG1Chq3IEj1H34Qnqzh14jUaY9uUzNZZSnGT87ABLwniisd3RFYIo8iDayeDXUhjwJfw6uGstFpGtIbtxBZBKzV+hPSsh47wFXpyk/zwoHvGK21Tr6Xi3JGuO0faLyGMu7euj336RCay5r9wNbsUSNQ2RoJac6sI//wfIl2urwZZBP0FlmB1rntBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vo/+egeZpn/VHD6qduLZjetf2fSbOHpFAZ1OZg0DHDY=;
 b=zoi4Xc/1ochQCtb+Qg0oUlwZUSsfsVB/JCqE+DoKb2pbVB13L5mjg8wzMLYEh1oQZbH85VRMKgCZo3VxH0te0iIA9R1Um2NYFToWJ8CMDQf5EpxCmMDEHRREQ0/1nRreC9fTg9nzQj/oFruvBbSNzR4nYUK3PUR1vFcC75yKypM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH0PR04MB8180.namprd04.prod.outlook.com (2603:10b6:610:f0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 14:02:33 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 14:02:33 +0000
Message-ID: <a4d55d8d-c512-4e9a-af71-694437f50825@wdc.com>
Date: Thu, 23 Jul 2026 16:02:27 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] btrfs: zoned: flush active metadata block group at
 btree_writepages() start
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
 Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>
References: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
 <20260722113016.1896990-2-johannes.thumshirn@wdc.com>
 <20260722170835.GB26033@zen.localdomain>
 <20260722190138.GA107842@zen.localdomain>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260722190138.GA107842@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0197.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH0PR04MB8180:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b279d0d-17be-4891-e018-08dee8c30a58
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|366016|19092799006|10070799003|376014|1800799024|6133799003|11063799006|56012099006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 PFM5Og2UIq9xqfvibR6dAx5bGfxk1HCwuy53ksn0cQzJzULwh7tw8RdOztjb/8SB98QlathYptmvA+Oo5bnie2hz3Jki2qHIwGnoVQdaxzc/Oi9ChgMih4o78vnoohQ+K4v4tZCirSD5W2Tmv2gTRxjYe7TqxrgvsvnnaMelUqGQru/hGAQx2165ZtWu8x2QZizYkP/HZLcOjDK6N8MRF7B8hme6hdLsySvpZGZI5IfFlgg54uiAmLaYT0aKTcm7rbmbOcslLtIiMq4Gax82afdJ87CsZrIiKWEh9r4rVCEpGrLc4N30HYr8gvQUA75j7iAOPdKy+ZZUKgixy+mK2wuu49DFWMJVgWj7yMrbJFn2/3IwdGKRwMrzhfGauksfII7axpBnuOJ1NFvWjw8etGsbHVx7UPDK8BzCwhTvEozwhMcF33VIkSAYIDN3LK0YRK8MeudHYRWNr/cDSKW/PUl/UT6Cr912hytWyc/D5k6JPzDlEaCWlNnExG9So33tEhtfEzTL02la6etBGPFDovmF/YrMDYuw7wAP31ORNcyxKOQiE+SLcomBf6SwWUjQ18Boc1RlYXfn7v8XadU4pPrTAbqe8+sWKfVhih88vBH0w9OCbipixIMZ/dqUmQY0tUVbQ/KptECuBGBqOgEHakKvDpe1bvhTMWDmWR0r4WI=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(19092799006)(10070799003)(376014)(1800799024)(6133799003)(11063799006)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZGFnYnRNUHoxZ2E3SXBYbWtBbDFaVkNyM0xHN0JGVlJoeC9nZWlqcVlnYk5E?=
 =?utf-8?B?Q3FDeEhtYlNYb1d3MERqWnFnOGdDSlB0WnEyaFkrWE1STFozR0l0eWg0U0pa?=
 =?utf-8?B?MjRJZVR6VUJ6cmV3Mnl6K2FJQTREWk1GTUI5aHRYL2I5bUVVOHBpOUxVWGsv?=
 =?utf-8?B?dkdkMm51dGtFSFBiUk5UcGozWVJWa1NOalJKWXpHN0JpdGo3ZFNVazdKZHpH?=
 =?utf-8?B?N3c4M2NaYjRvQlZLQnVkUURnV0JwMW9LRXVEZ3dvNHdVZnJsOW43VS9xUnNr?=
 =?utf-8?B?WE1TMDNxWVpadTVndUt2RkhaeEpoc1dBcVExUGlOQTM3UWZPTEgyWnNTd2x3?=
 =?utf-8?B?VHJFY3pTN0dBTUFqZThpNFBTeUVRVlRxQ2l2bWNLZE5SL1ZoUFlBaFhncDlM?=
 =?utf-8?B?Y1dBU1pEQTRTWFJRaWZ6M2F3RTlvMUxXL0VOR3RDSGt5TWRoZzMzcW5pRTZH?=
 =?utf-8?B?emt1WW5pUlRmdVRmdmZzT0dFUTE1YlhqbklUNjBpdmJyM0t6dk04R2dlNHcx?=
 =?utf-8?B?R2tFYVlPeDBJL052K0h4Um1JTEM5ZXVSVllYU3Z6a2ZEV0JEUXhjS0cyYW83?=
 =?utf-8?B?c25qaTFNeWE3YXlPUi9SclNkZWUzSnk1SzVwUXJlNjhYOTluTnFVOXdwMU9i?=
 =?utf-8?B?UkRnbzh4TWp2WVhyTG9RVVhhcHVKU3puMjcyQzk3enNzTmQ2MFc4SDdWQ1JU?=
 =?utf-8?B?aTJNSCtuOS9TWnRFWGh2ajlvVVpndnlnN2xsbkJLNkY4RW5jQ05vRldPN253?=
 =?utf-8?B?Rm1UcVFiZCtSc012dk9zekhDZGsxNzBGcWZYOHVZUGpOd2dBRjBYWXh4cTIz?=
 =?utf-8?B?L1BsSnJIcjFKNThobU8zMVBvUVp2OWFUb1RmU29jRDhKUGp1bENUNkJmbEtw?=
 =?utf-8?B?dTJ6dTM4RTU2SEhabStuZzdobW93QVZyNWpnUHgyUXhKakY1UW9MUVpoZGZ3?=
 =?utf-8?B?MWZRV09JZEo5SlVpS3Y3bUcydzQyY05vekYvWVoyQkhmWU1SQURIeTM1Tm4z?=
 =?utf-8?B?cSszdVVOTTkxQXZGbTNtTzRlUlZrMDNzL1ZIK3FrYmozbHhxSm9Jd1dqZ1c5?=
 =?utf-8?B?STZIb2ppcGlCOEFkVXRiWmdLYUppcjEzZEt6TndDZFZLT3lURUVoSVhpWXQ5?=
 =?utf-8?B?WlpLRFpGWDI3QlJDdFFFNmhLeTdrN0Fta0I3T0xGRmVsR2YrZDdHSnlGUlNx?=
 =?utf-8?B?Q2ZDRThqTGcyaXBSdkpRdDkwNnJZdHJJRmtoaVZyQ0JpNGdUS2xjc0FiaFVI?=
 =?utf-8?B?M3JKckpzdytoTnJKTFAxYnBGNkhITElqOXhYVmV0YWllVXNSUk82Q24yZklG?=
 =?utf-8?B?c1lqdHlvNGpJVWNOL2VUa215aTJvTXNoVEQzUVFUeUh6RHl1V1F6aWt3d29m?=
 =?utf-8?B?OUNHWjBZaWl2V1BrNzZKZEordWFqNjRzMEdlMHNkRnQydjhlK0s5QysrQm9x?=
 =?utf-8?B?TkQxNm9ISTJ0dXk5alN1OHRDUjJxcVhwbU5GN0k3Nkx5MmxRWFFYRHlZOHBY?=
 =?utf-8?B?RDZpc1NGQ1JyUEwwWjVrZWd3dEtZTGdNK2tDM2FyaVhnK0F3S1l1ZnNRME9N?=
 =?utf-8?B?MVFyZ0RYclo4RmtuOWtYWWxIdmMvZytpcHVsTG92OXY2SHBlMFFjL2ZiUnYy?=
 =?utf-8?B?UWRhM0Fvalc2OE1seHZkRTZuMzNXbXA2UzVDaHk4KzJPZXkxSlhWZGpkQUtF?=
 =?utf-8?B?aVlxV0VtdnAwUU9MREVocXZFTnZVYWRhYWhWNHNOZUdET3BrcGJGVkl4cDdJ?=
 =?utf-8?B?azN6Z1FrNVNURk5Zd2Q2NHhvOVJnZHc4V3ZQSGdNc3BienZVOUxsRk1wSnBW?=
 =?utf-8?B?Y0o5NEsyL010aTJGSFIvUitDd1hIREUvcDFLbE5qbGJQaTVPKzJKZndrTlBZ?=
 =?utf-8?B?N3p3U2tLYWY5eWkrOXNOb1h5R21zV3JmR3M5NmdaSVNtS2xtcWc2TzdPNkhq?=
 =?utf-8?B?UHIwV25lM2hBSTl0Sm5xVkdRUTRqeU9DaVA5REd2S3l5N0FNT1ZJZGJjMGI4?=
 =?utf-8?B?WkN3RkdSVC9NY2I2VGhJeDgyL0hxZXd1Z3pNY1lDZ0ZXRlFiMnY4NmNvUlpK?=
 =?utf-8?B?LytYRzhFZEs4RzM0VVozVEFsN2tpT0t5S2lsa2pWcGlPZlJzWDhReS9yU1JZ?=
 =?utf-8?B?bVBpelNxVXlJMUVTMjkwNm5YenNxK0xkQkh0VVhNdjBCWkFvUTJ3Tk0wdjFO?=
 =?utf-8?B?UkdZWTZOVXZlbnpjVS8zS0NMN3dKK1d3Skt1RC9rTVQrZ2lPMDE5eEJRMlNO?=
 =?utf-8?B?QW4rWFg4Rmk3UDdDN2Z2azdUbFJ3NDJXcWNYcm9DUW9PUEd0b1ZveUlTa0ln?=
 =?utf-8?B?YkN1R1k3aG5FbUhJUmdlOEEvWG02V2dWOVk5L09pM1ZhMzhzaGlTVm10Tld4?=
 =?utf-8?Q?OQOe/moEco/TGxXS+tKN8pv4MkseSEdFwhwCg+na9vplj?=
X-MS-Exchange-AntiSpam-MessageData-1: nl9HYDHcXbp8CA==
X-Exchange-RoutingPolicyChecked:
	YT50Jrq/TQMuDFTortfUlTuMhlZSCbjr4pV+0asqbeSUpigVGLlaBd6SN1WfQN5fPYCbuaigFv3Z5+8gTMc+Ot6NCtvYN02tm0ZDxMHoshANUYiUjGgoViuTehVweOLfvJ2f7taJX4Toup0Oje77WQSD0L8zV6wVTS0e42nZQ2q2uYkG3eVsaCXnVxAKtIKS5bHlSMiyyuPE0PzO9tIKHFUOmCxLa6SJDkK/iwNcDQRr4dQtvyCIYvISPhfP/Sr0SJNudcegGUswWeKmsTnLZjBHg97Fmjkv8O2A38sX9Z0yR8EGz+B8a9EvAsMrer69tQ2L8yRd7JMEm1wKJpenHQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dHmuDVHs9yrZZ8bsXCENYRi35Olf80y9o8zGTgn1U4WP+IXVlpwhfWDqD8Tg7J4swJFN9ux6hkIGCMXh/RVp9J7ql4F8ZdyLXR+Nr6ZweA1RwIiN8BKljq0XduMylA5xSlieHsGgcA8fa2fEmRj3tfMxwLeA46q7MavJD8lI/+iwut3FqFsCGUrHDV9e18ItuLCRkhN0w5eJwHp8gT6c3c8fmeLfce5PYCiVQCXxVg5hdu8NfaqOdaCQyUzSaLfjTvkXQZbpfUtpE+r5AN8Db0LmnbOGA52ayOOF8ulcn48kslMv1f3yJajREIsowIZI7Z1KxHfzR2tW4j1OM12XGSZ0SVTaRGXsrI72AHTU0QpEGC+pK+Zx2N/FaG+S8bRgvRXhtIepHkAu9bcWo8t6jpURqB3rYoUpwrUPPqN/3VONzCsNwfPqv1eYnOeNb7zwgQ7S+cMDIfbq84sxW9ZsU2b3XRklxAqWYIMrzJMLSsogW7zMxpv2y6y5NRxgvIs6pzBHSajk760UxmO6hBURiWp6fPLqLO3pT5btghLXDemfCRdEu14lXFKz1BNILJnI9jGBCYXpfSqlfFRw7YUfRm+GOGeUTCjaQIA9ONmG8nbVly6tdIYUXFmRqzGJXYKk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b279d0d-17be-4891-e018-08dee8c30a58
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 14:02:32.8583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +yUlfiFrq9kREnPrBSps1VOLiC+FLdkSnypElT58EmqSQt9R1ASuJ3v1BYka0Co7a17Feft8TAKSlfZD5EoZlKbCy57HMfoCzmBpBrIcnpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8180

On 7/22/26 9:01 PM, Boris Burkov wrote:
> Furthermore, I feel like this is actually quite redundant with the whole
> EBUSY pivot logic.
>
> So for random reclaim writeback, we walk the ebs in index order and skip
> any not in the active bg if the active bg has dirty ebs. Then we reach
> the active bg and flush it, submitting everything. Subsequent tries to
> writeback the non-active will now wait on that submitted IO and
> ultimately win and get to become active, and do more submission.
>
> But we could save the bother and make things more direct and simple if
> we just had btree_writepages() always write out the active bg first then
> the rest. I don't know if we could fully delete the EBUSY, though, maybe
> there is some racy case where it would still happen a bit, even if
> mostly it didn't?

I got a v2 with your comments (and Sashiko's) addressed. I can look into 
that as well, but that feels a bit more involved and we're seeing random 
hangs in our CI system due to these stalled folios and we have one 
report on the list because of the hole -EAGAIN, so I'd like to get it 
(hot-)fixed possibly in this cycle and take care about that once the 
hotfix is there.

How does that sound?

