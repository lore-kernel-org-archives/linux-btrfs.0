Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EF439657E
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 08:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774944906; cv=fail; b=kmBYE2FQrqUQFvOoBcve0v7sl+VWqrekxYcbsgYEFuD0hF1/jqh+HxP8LFOt0GDCc37JIWi+oaqRauD3TqKC/wjYCvn6z8lhX2+s3lh5XxyF+f1a8q5ygwLGo7VyKqMKqMfJwbVqoAvqyOQuEpxgoJR/aGWa0ZQAeFv+Iki7hp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774944906; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ss0jkoiQIeR3jpbAExH9W2kVRMWUlHTsVEJkKxKMym7YAOdQMqd52LHRvFb588YTDLUyIo5OxkHnOpbSWtH2TlGI/JWzLzC3y5PnrPuY5YdMBRiCpFs7JgGVmFv79abPTUX3Z3ynkSHfyhn7OMlOi8iCIBTpviA1+ExdUZKGMNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WjC7s5bW; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=C0IcTjIo; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WjC7s5bW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="C0IcTjIo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774944905; x=1806480905;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=WjC7s5bW3vtA9w3bAmjz2d603OC2+20NhNgYqeT6gyKVvrtOa5H1/iRQ
   t17W/bKQVm875+yitwk2q2Op9LTFJavjNXfKuAzwiwy0kajvS5SoFmA6+
   19tSNwLmWH8RoGIee3xz3gi7PfVSJ0PLK2YeUQOcajbgDOG7FaaHc2y2k
   6UzTAfhBbmitWpROuA5nyYPQ9DxoHGybfjok27eA7YYtkGo0Iy0CpTts2
   K7Mq4vp7CD5flg9ryvPngGxl4dJmJyCUS5ZUTla840X/HHmtnANpzzlKg
   EAg/9dpNW2eIwMPXscg0M4CYIsKbNJ12UjyG1TTVAGqkYOQX9Gjof9Pdb
   Q==;
X-CSE-ConnectionGUID: 4vlPrKx0RNSl1eagRC2nJA==
X-CSE-MsgGUID: cF7SnSn7SOKt1plIRK5gFg==
X-IronPort-AV: E=Sophos;i="6.23,151,1770566400"; 
   d="scan'208";a="143144151"
Received: from mail-westus3azon11010046.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.46])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Mar 2026 16:15:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J5JoMGfoSLZKceIADx16wdDPI3PW5Mz9Glz8qd2eO1FtQ61WJdWvH2Tv6j4HIHmVhegn/n2+Vls2BTPOHaaa8WjXU+M/+xTWoTHI1qPOG44KRaAubAfTWpmBGhLmDS89fzfMeTmbnkOfbiGV4PWwBJEM39+XLuv+oOsWLv7fRC8u7FN6Wq4Or9yyRjJd0XevBbuF03BcHBghPEILTHUa+AFHICyzU10igREKE55WWR18BMWzem37azJqu0u+QMjeLFMuIfOYtbO6LLsKtcdgbnQnBwYV2SpexJeYGDBhFSd2dMjM/NQFfwD++bwg+LeCHT57hIFWdQKzFdEYHkkGjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=D/ZUgX4FLaQrbRv0waJcHVWc0q0Qc/vgalNuFysaboGGMjO9W5ara7ExZBLxy5XSk/SzcPv6egnK2cGxVZ+ZWALKuwTBZd9/Aik1BLF0wgLvcUB8aL+Fa4QOGSHemudRUooL46P5YY5KliDaXYGUsaBe7PHiIX0K6aUvmwiw743Oj3ClPDf7uHpoNYah74j3WYkiixMQ6YXysx2AZirSikM8zn31k8aLeHOkQxgF9bct2HYmNHi6cP4qfjg+cnfOriKjBf4nu3NQWQyLY159tfPIxT1U3jzDtbhyidzDAcJKUFLckm3UH3oCTTFUsCZ/v2e1Y0KgquSO5MGSq4zDlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=C0IcTjIopXKtY8vjsU8uU+yOOt/tDPP5iOHC8mzIbwqRq24z5iAwQga0bCWns3sO1eqGoNpi8CQSel6Lr+E71KZqU8GYsBwIdAsxgO5txr5KSsH8NRv7hgxlSRPASCGgzMzqg46mHocmfm27o82WpK26noLrhX7/b3QKD4+EhJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by SA2PR04MB7722.namprd04.prod.outlook.com (2603:10b6:806:14c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 08:15:03 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9745.027; Tue, 31 Mar 2026
 08:15:03 +0000
Message-ID: <75349043-1243-4455-83d8-76ce43fdaae4@wdc.com>
Date: Tue, 31 Mar 2026 10:15:00 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: only invalidate btree inode pages after all ebs
 are released
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <90443bccdf0d1d7f93f945c0fc0c64cca438a82b.1774909310.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <90443bccdf0d1d7f93f945c0fc0c64cca438a82b.1774909310.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0058.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::14) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|SA2PR04MB7722:EE_
X-MS-Office365-Filtering-Correlation-Id: 56b9a68e-94e8-4472-4bb1-08de8efd9c44
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|19092799006|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 CYGDa3U5whNgPAdpzqx2KijoMEyv3JI4DpTCnCOeI4Nd6t7e0MXJfQTTxWYsmIRcHuJGyNrb1qcXwBhKdY4upbjoE65LJKc1QB+1DyR4sIbqEwyyFzqYJAAuQ8r+0h/hdghFmFlRaqJHJImK4jRT0cSSsrJKnZm6nDWhZEHaVV7ZEn9hSUsKUeDAuMWYjciYwbhVDd+zGXlgjCynr+w/2mcRCjvYxoExGU0wrFsQBmAY+sZ0m/r1WQhip5zprcDHDJDFpReOQOMoDs6ePIZg7pdfuqOAmtuNlytcGBpvvTyAPMHyEy1O0bYNXc6/aUztJbf69k7Ipe5+u7NYo15Cp1oY15wyqMKNUZXdCGW7rwsCpvA4WWWDhVLleGUDpBNH4b6XxGildIKiNcMQp1SWnN62S2Gb+vbjHxk+kmTzqWQs7mYoWQUZvJigQ/TAVSJXk05xdopfTafCj0xAruiXnrShUA24CDviWHx7QYg8OzbW36YjJTzoi6eJPg5wEmWj4HjSiI9MPDWNjzGbkzxH9PiE/ljfc40zV6JRO6zeeTZEXZus6pwzBNI2HU+k5FByfN4olsIY/zIDh2jYH3+UYPLJ93WmLl5wjqlMCXJMI+LvHhiNX7/98SmkQpSJ0MEcwCxwCdPmVzZjZ7kBN7AQI1ol3/nh7QZgwKs9w++BJ/k3ToYVnwIZGSQNDj7Fl1uv+Jr9UJet7QW0UO1xBbcAoHoME6NIY8/3KvpBNSQxCeE=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(19092799006)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?VWR5TVBqN2VPbS9aUFRTOVhxc0wrL3JEZmRnUy8vZ0tOTGtCbTB0TVF1TUVl?=
 =?utf-8?B?SWVvM2t4UmxJSmxsOWVpbkZvMmcrc2V4WlRGbGpyeDd2ekxBZWFnaXZ2aUd3?=
 =?utf-8?B?Sm9xNG03WG1CT3Z6eC9SQzJRbGdwYTc4ZW1ldksyQnVGRWJXenNFbysxM3pq?=
 =?utf-8?B?VGRETHJMcVNkMzdxbzFJbnVGVG9HdzJkRlBOYi9pVnR2YnRISDEvTEExTzdr?=
 =?utf-8?B?SGsrQzIzaVZhTS9IN1ZYUExVK3BmWWEvRTBBZVRUclAzclBydmttQVJEMWdz?=
 =?utf-8?B?Y3dSMnpoVElEK1dzQUpLL3dhZGhoZHpHNzRZazlpUXJlRnNQWExnUnlyZVJI?=
 =?utf-8?B?a2VkcmlVa1hzaUFKcXF2YzdrUXlaQXlhanlDQ1QzS3Ivd2lmSzBuNjU2NjBZ?=
 =?utf-8?B?NzVJNkhRRVBoTlk5b25GRWMrNllhYVVmVzUzUTFpQXpQZndHd1pjK3VYTWUy?=
 =?utf-8?B?SkFUWmtmYmZtcmJaVGF5RkU2S3lLYWEwdlVmNG5iZUJHUVdiSGlRSkh1WThU?=
 =?utf-8?B?VGlJbUNhNmpROSsrbHFreFMvSGlHR0w0ZG5QV3lKVkpXYi96N0JkUWdKclJy?=
 =?utf-8?B?cWhvblUyNE1FdGN3Y09FZTVFWXAzVU9qNGdkWTVrd0E3bnhKQ1JWQkFQZGZa?=
 =?utf-8?B?eUplYjVtSERFYWJjOGZkUWVjb2hHUnNjRGJyNWIrRUFVa3NHL25GOUdFSHE2?=
 =?utf-8?B?dlpyTmlHYWJ3azRadlNQVjdaMlQ3aHFySFhxTzlvSmhwL1QxaGhFbmRCbDZO?=
 =?utf-8?B?bGpyZXA2ckZVRGdVZkFZZ28yZExoY2pidUtiQ2M1SG0vMjZiTjFLekhHemY2?=
 =?utf-8?B?Q0tpelpRd3lEMVBtQ2N4My9wZGlHNmI0ZWtISi8xc1dUTkYvL0NrbHlMeXFG?=
 =?utf-8?B?bnYyck50eXNCV3lrRFY4UkZnbU9VRTdHM2U1eUlTNGFnNk5ma1lJNXUvUW01?=
 =?utf-8?B?aERNY0JiMkNGMlZTaFBpNURmMkJkKy9GYjNyVzlyOEdFQTZhZWE4dHkwSk9W?=
 =?utf-8?B?NWJHNmp2czN0MGdGeVFhSG1WcXVPZHJ1QkdoV3ZkY0gwajU3WmtxVUlTOGtG?=
 =?utf-8?B?dTYxMWZXS3BMUHhGdVZ2WWRMdDlXZXVYQWlOYm5vSDBMdSs1QjUzL3Npc1RY?=
 =?utf-8?B?eUVkMHZtaEp6VmZpOU5GTGM4MU56MG52OXpQUUp0WWdjWmdDVm9wamxHYTRq?=
 =?utf-8?B?VE5WZWkvL053RnR1MnFubUlSaXFFM2lCV0EyQS9lS0NJZlZYcDVERWJqbFFL?=
 =?utf-8?B?V3FtYkJ3Y3BqanF3Vm9saUxQSnhNVmFxZ0s3KzBmRm9DYXpoalVITVdJUGZT?=
 =?utf-8?B?VGdrcFpuRGJRS2lvOE9Fb29sVi9RSzhNSlhnKzE5YjYwdHl2QjE1dXoySHUx?=
 =?utf-8?B?N25pMXBKbHJ0bmVLNnk5NUNLbnRLMkF6MmpDN2w1bU8wTStBTitMbmVKVXUx?=
 =?utf-8?B?bFRVOE9lbWZCVUpaTW9iTUIxTlI1TFFqVis0UWpsakFwVHJoTmx4ZVFqdHFy?=
 =?utf-8?B?MmxKSGNBcHFTUkx5djZhN25RTHZ6K3FoVzhzK1dKSldLNGVOeTJzczE5S2tH?=
 =?utf-8?B?c3dSWmNvUmgvcjkzTFZhaEgvRHNlR0NrS0VTU1YyU21GQTQ2amtQUG1ueUpZ?=
 =?utf-8?B?OHo3eUhXankreCs0ZzEyRDhtN2czRVNKSVpIeS9UelIxYTVvOC95aGNjS0Rp?=
 =?utf-8?B?TGVTUWdPcUxVcHdqb2hPV3FPMzdEdEJHWjRBdkgrVFhycFk0bVN1OXRTTXFZ?=
 =?utf-8?B?T2VkbE9aZHZZNDJaK0ZyaEw5eC9PYzU5Ny9WQnhaR3RZWEN3aVpqNFg0eXdl?=
 =?utf-8?B?VERoZHJHQ3ZwZEpISVFWSHlUY3B4UDBCSlFSUEdiZVZ6d3dNN2IrcXZaN1NT?=
 =?utf-8?B?ZGFJRkpwcFJaYVlMMlpHZHRJekd4QmhDeXQ0U2NpcDN4WmtKL3Z3MjFzQngw?=
 =?utf-8?B?UmxIKzBaUDBpTGxON1kvZStzOE43RTFTY3VXZ1M2aERpYVNIVkNCQS9aZDVT?=
 =?utf-8?B?N1ByQkNMeTlqcU5OSm1iSXY4U3YyWXBmcEdBQ2FTZUJidTBSd0huQTBUeUVl?=
 =?utf-8?B?Q2Fnc3BZR3hzb2UzWTNscjhSWHMxdEJ3ejFaRkQ1bFJaUXNtQmtpRDRHem9x?=
 =?utf-8?B?L05RRlZHUy9TTC9OR1pwY1hrdUwvSGlMcWdjK3JjbkNjczFEbVROVi9wcGsw?=
 =?utf-8?B?dk04U0hnVHVSY3huNVY4NG1GeTJCWHlROHpqREUrYWl6NCtON0FxdlAzQ1dv?=
 =?utf-8?B?S29NMTBvbEVPamczZjFrU05Fc3BxdWF2SEFkZ2Jsa2x3aUJZeUhrdGIya3BI?=
 =?utf-8?B?V1lpZnpZODdFbXE1cjJ2M3B6VTZ5N3NHWGZuVm54WkcyQzhiUksyWW5qbXpv?=
 =?utf-8?Q?jUPz9kN9WUsSLU/5PdMQelSseriqGWvc3C+B7XQfJHaQq?=
X-MS-Exchange-AntiSpam-MessageData-1: 69XeUKUXjIEB1SjCea9MIVFuWNNnFEzxiW0=
X-Exchange-RoutingPolicyChecked:
	t/zJGIhY772kKcnn7CZ20UG63PTMnG6RCh78OWYtU4RkwLpS9pNzRKntawD6BSB/iAyqM71zHOau0mUPPzDiyeF+n0h7x/dNyKAcSunL46PWX0RhUHfc9Fp1kwvuloTp/a5HaLuFCjLBiNqssCyI9YWePGRnPlbqPdZ/KbAZFk8/pYrqZhyAINImMaUjpCNtAbH+EfbEhNN417jaXiD5ItPoYiz5bdVanyypd4E/fro9kBenPpYNfeIUDznNG+Vhs3RkCR2muFypGiSZeLG3TFZwW0dzFH/mC4Iu4FwGT4QneeP6MwaYIPYCMquP6aDiyPit9Ypn1aCqxmUYHINrZg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mbeT12pSuJaZnBUp3NUZvvVaZD5wwcSLO24lBEmCZrP9e/fCSUrMMQZYpYLuxuDvc9dwyNvG2AL4Wjj0xgAje1azbIV7P7e1UfKu8JXLVrBZJKOcNq/tqyz941MX4HZvP8bEGBbHH+TakEG3Ts8ltTSX9WSJENajINnP1ba9xsUrFHOXO4o70vyJZpmubEVlu5zgyvzy1zFyRtzpsDkyxgNzr99ZPD04S43waMjomS9rLbGKtYxplA2dGXHJ9xBMaouAgqUx4+JqEoV2A0dON2fWPEjIRc3p0antdolWZ/kS949qfLJ350LexwE+PQ38yfwPPbaLSHeKMks2xTVOXZ72+ah5dFWKL6AX8doTocD2pkE35sdrdJtiCIoQqfRZysWSo9mNXXHw86vsvCr6N1cyRSlmI5YRBESgRcjKsUfG30CgJpHl6ERTc3h9pjHUz56JUVSRPcawTHm3PnBoGvmOt3yeiM4xv6JnhBG8hl/ER5Nzl4Gs9q+zwNiNzoNuZ74NZbO4dp7IlfnDK+nb+NQNm+5Y1Dk0aCqltAyLByou9kFblnZz+27nvt6D836sQ/NJmwDkUcw1J7dTnvjYMf+WDOVQ7v6j+JIf2Fd8xz3ac3el89B6+wnkCC/pCt/V
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b9a68e-94e8-4472-4bb1-08de8efd9c44
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 08:15:03.5169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MwUxzC3+nEzM0ArpLNJp/3jB9D20ifG8wkaMCmhMGEX8bsE+sC3/SM2rqAdXyFQOMAP2v//gmAzCx+gcAXrGMcVFuV0EhJLye8gqMhuGHlI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7722

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

