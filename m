Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A0539D6FC
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788854191; cv=fail; b=Y8yXCSlOk1vCVik8/gt1GeMBPsVEYm8OJGt8bL6suBA5Uo/egA0liDmEoSUN4W6AbVzegOHMwDzIMi7vhna5+JULVSOp1gcnr1hE0HPMFeKM1LFu5KskGwZEuctYUEoUZqQ1NZTdzFcgNO6BZso+iZRCIzvM3uBLGcBdUXc2eFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788854191; c=relaxed/simple;
	bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jeTyFaJUrlZXGBXjzKmocCHP2rhMIQdzJaPgxXt16sS9d38yhu4R1pbhwlJt8rcenZqgYIrJy/J5Qj1F7I1LoCcW4aVWvPUPT5TzAmCgg5JmoQKU/gjdel2ScfqK7RSFiNphpKNrX+ComCatDNSdePGzQmw8BfOonEyOA+hqstM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=TwlbLU5w; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=xsjQ7kul; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TwlbLU5w";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xsjQ7kul"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788854194; x=1820390194;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
  b=TwlbLU5wI9TlQT/TTihMlLF2SujG5b9AJ+KHmk9vv8r8iM/oeqUecVI3
   eAwpTuhP+TSkb0b7TlaWPg34bZ47W+QYx+qwpGXSYYDOxJA9YabE6kLh8
   rbUaJtXfpqZkBoX34U2gWdpy8Ej/a4RmMpdLB1Nn2MY63OUBFJi4NEr6h
   9ABho0kkOIhhZ74knGl+VS0YGn4aWDI0Q7fuQw5yuHRmtc2wnHKeO0oak
   Waq15wV7VdGoQlk0rzF0l6iLc7tD3E8KvMrFrK8YA1HR5C8PgCyafyKIA
   B7QQfh6c67DlV1vfn+E+qqpXzxxN0SM+rLjsABCuVYtUDglNi9In3/sY1
   w==;
X-CSE-ConnectionGUID: +U6+Ar/RTAS2LZfU7m+DbA==
X-CSE-MsgGUID: /fxdzuhXQ4mTfWGGtoqGgQ==
X-IronPort-AV: E=Sophos;i="6.25,268,1779120000"; 
   d="scan'208";a="154976118"
Received: from mail-westus2azon11012047.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.47])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Sep 2026 15:56:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y4YKig/WSTISWrZarg3HOJaKMlzW6Z0qdgTXAAzro0/57hrtRazqHPD3CetJG3Q0WFiPhiUGU2CEZuJDnFMjp7oHtkQbKGAzTMOqeJPcPulfAxSxON59pLS/SriR2RKGNLqmjgQrPa5l8LVL2PuMKKsE0yT1MKAujR+zxvNWI8U2xh94Zo7gbe7mK76pPss14qxvln7xvhY3zNQoG9K+ROEm6d3wK8E3jKp1jkfcxifK8HXIH/DZWWFSt+MKIntKi/ybJr3nwYZgX8foj7ptr2rfm82BPPaZ5EKUydo5JzUJ9BHHHtkE57avNkNUfUcqy6FzkPQMw271auXsLc5Jrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
 b=ptUQMpC/e4F75vMItbgTwAuzr5L0Qg3VAdIq7xK6ojVx8gd+ASy5ezeXLuoWWaxSghXpIsRVUYwutN8TkPzIPnzUCsOVToe8iPItNDUKrGGbVzvf0QjQzRsno7IdKittJAaW7nhB/HJU13xq0+++HeJIom3i44m3Z1bIuyCYAO4KpTV3JR1s/nRvVy+FzWElZO+IbTU7Yoi1XhxrjQT01gxn1XE9ONpUjAaVeRWUdG/nhXb6G2/FsHKhES+/0rNKF4gRmHF/pG2hgTbdv80sN0udOWbw5mbCtXvIXAJpRia3XSaOTudXsIXrL3Yzo6cn/HoSZTx9WL7DgOnEv1yr/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPnPSBeHPQ2OlGYMnlc8/srUIGCZfnDvtSR2n57yAOQ=;
 b=xsjQ7kulHu/7UNdHjy/n7FwjrUxtWvRyYINBSZDfuUTnHOsirMioufE84GQiiuguvhwlk4Naj4BuTecvaxTZNrtYzM86isK4WKtXNgv8Dbc8aV1BuCDRa0u7LMBC6Rftf/xC+utG8rAfSbwJz4UkaghQAcHAKHT5FXB3pflters=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA1PR04MB9042.namprd04.prod.outlook.com (2603:10b6:806:388::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 07:56:24 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 07:56:24 +0000
Message-ID: <536f53a4-51ca-4129-a79b-e2196e39ba15@wdc.com>
Date: Tue, 8 Sep 2026 09:56:19 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use kvmalloc() for split_item()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>
References: <2ab022c5c7e07345a9fc91915836cbd4ab2d25ef.1788819456.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <2ab022c5c7e07345a9fc91915836cbd4ab2d25ef.1788819456.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0247.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::16) To DS0PR04MB9439.namprd04.prod.outlook.com
 (2603:10b6:8:1fd::6)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA1PR04MB9042:EE_
X-MS-Office365-Filtering-Correlation-Id: 06bf1c6b-fbd4-4cec-75c0-08df0d7ead65
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|376014|1800799024|366016|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
 H158Q+sytxs6ytW2c4nu2uUthQ5kaiRbUb/Dq0I0CUxEuu9W2FD+lojfR2G10yEhJwvqhEIn1FTBgMw/6KGmWBX5i6n+riDf9IBEWWTkaAT67ilfC9b/rcIoDo0lrWZv/FXNoMg8q4QurdhuKSoOUjPdEqldAscPdUqlXrZGiK8BjYNy8uy4dItNOGLBovcU/8uNRaloYqy3RrfGMg6udV41CiX1SLpttTvRzArUHWxB6P1pXkogxbswo+74rhVseMLG8h2X3KJCwmrxW4GDiuo3nA3hIMG/+xrVgDJrlLAmqja+EoP64wwItzWePC7DedxFqcLAaFOgdG4J+YS+WX4Dd0Z2KsWC10JC8MpB3gNxZcp+QuyAVkarcurp1ikScO2FJaZhqN6M4asp+//2Q3UbTun557XtU2UZ9pU+f1hrVUXN9NQDb7eWS6cPlU+5z+k6v/Zs7/B/FtKP6mradfpr8P6yNpJwCZC4zYtR02jaqKiDUEv0G77gx2IjTf1dnrU89hcBJ3hFClTfwqwBwBIYg1M5O+lh8UxnFRH2jsJHo+gG9hVniM7Mg35sqCr/cws8VT3C+x2g6iyjFwuLKxpZHkdteP8tfvmtXtza5thri+bsPfp1BjK9HRppx48GbJukoK7D7H2+OMWYYROvWlflDikANcaTRrNwYKLQ03Y=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZFUyNlpEbVNBVnlTeWc3d2N6bkNVUmxKWU1KT002eTdSZzh1MHZMczFjZ2pX?=
 =?utf-8?B?cmJRT25qV0F6Ull5MGUxS1hlSmxNdGlHZFlCeFhTdEhDTzR5eHNOS205SHJT?=
 =?utf-8?B?czRNMWpHajE2aTRETDVzTllXMTR4VFcvbG9SV1ZoeWU3U2s1bjhhUDFtbjY4?=
 =?utf-8?B?MC9ralAvaDRmTHRaWTJROG5Qb1lkTjBrbUZ2QnFhUGtVMW9yclFyKzAxSTJP?=
 =?utf-8?B?YVJIU1cyS0VEeGdsWDM0d1JVOEZ3VzNkVnlIQTdtZVlUVy9DS2hBT3RObWJT?=
 =?utf-8?B?TFQ2VkZZdGREcTZjVFV2dDNld0I0dTBZYXJFL1hVTUFOWWtZd2pLamphUXJk?=
 =?utf-8?B?K251bGx4emt5Q0p5Wm9ySnJVUzJ1OEloR3lDaGpmK05VcThVanE5WTBiZ0pW?=
 =?utf-8?B?eFlCN2R1SDhtSFBOb3gzdWQ4ZWtKMmVnclpBeFR0ak95ZGo1S2k4a2Z0N1dz?=
 =?utf-8?B?Y0hBR1RlMUFMTGxUK1g0UWdJYkpxRC9OTUMxeUp6MjhEbXlmb2plVnhuRW5x?=
 =?utf-8?B?K1huNEQ4N0x2eC9TU3doaGtNR3E1OCtEZDlGZXk0Y1N5ajhLcklWUjBERyts?=
 =?utf-8?B?M2JpRXg2WFJIUXh0ZGI2a3VZZkNpYmkyV0FmQWszczhud2x0N3NpUmJVcnRE?=
 =?utf-8?B?dTlvL0JnbjNhNTdqeVdLYnNBVHZZcUkxbmd6UStjemFtdHhEOFpSYkJtSHFn?=
 =?utf-8?B?Yk11ekp6V3NSMWJxbDRUQlBiVjVvUDVCWlRpOVY2a2ZxQ2ZtaTVGT1VqT0hB?=
 =?utf-8?B?ZmJxRERPOWtKZ1pjOXV0SmhlcndvUVZPcXhEN0tiUVpEZVZ0SFNOa0ljOUtx?=
 =?utf-8?B?OUc0T1lQSDYvVUZ5aUE2cEF0MWpjYmdvTEdzd1MxUHBOekJPVlJLblR4OUlR?=
 =?utf-8?B?SDlXbEVwUzJuQklNWndCcTdnemFWWTNOT1ppVUNiM1hJWWhFNzdiV3dubGV3?=
 =?utf-8?B?ZzIrT0lBSE95UytMOHEzTlZWQlZJVStKcE5CS2hIdE5sT2JFR0tKYjFISlEw?=
 =?utf-8?B?T3RPVnlYRXoxbnozeWRLVFdhdHBaS3NjVTUwSXB2NW9aN0NHbk1oOUl6M3hU?=
 =?utf-8?B?MkZUa1VOcWkzV093NEh3NWpKVmJBNXhvdk5KRjdVWU9GTDVydXFJUDVvVEF0?=
 =?utf-8?B?djFFODNBNnBqb2FpR08zSlI4bVNhSXp2dFpOT2JpTE1IcUlMbURrcWhDYWtw?=
 =?utf-8?B?cXo0bkg1RmNmYk9hK2hXWTA3eG5pQTlBeVo1SStEdC9Eb2d4Z3ZDT08wYjd4?=
 =?utf-8?B?ZjhpTXBLTE1GR1IxVGZZU0ZmSEpqT0F3WmpGOXpCTGplT1IrbHhzQWVCNTBa?=
 =?utf-8?B?SWcwaTJOc3krRUFDUWQvUXRBeGNQZm1aTkZQK1NTdjFCdEUwcmw0TGtnWWxO?=
 =?utf-8?B?K2xQL05zK2YvVVZNVmExR2N2QTRhYTYrc2R6bjV4Tk1Qa3lGSGlPWURQeUxI?=
 =?utf-8?B?dmVYbnpkVTdTREc2NjI5amJKbnFqVFFkQ1NJYnowMCtUeG82MGxJdkpFYzJQ?=
 =?utf-8?B?aXJpd3E2QUt0YU5XMTZzdERpQzNRZklIOGtUNW1uTy83Mlc1ZmpOM2xkK0Ez?=
 =?utf-8?B?Tmt3aUtHYXIxYTR4RmtTVFhyNXp5VnlaWCtUcnBTalVTYjRkR3RpYUZaRE9I?=
 =?utf-8?B?SDVxS1NhN0lReVhJb3psOWgyc1M5NzVTL1cyemMzUk5YQ1JZbmhkNS9KT3Jy?=
 =?utf-8?B?QW9lUFhIOUdXUXZEMlBsMUVIOW5mWjdqOFNGb1lhLzFoSjZRM0NobHdzdllH?=
 =?utf-8?B?dlZsUmtwSVR4NWJXN1lXSUdFNG1WSEdDVWRXL3g5Ni9qTlkwelRSTktYYXgy?=
 =?utf-8?B?RVhjSDBmV2FTWTVlZ1FnbjMvUjVHL0lpOWlrYWVxNi9ZbTBzbFBIbE51R0cv?=
 =?utf-8?B?VnJIQ1o0blZGTzJWVE1pQXM4Rmd3VFFXa3U4VGE5bjVFSDFSci83RGxQaGRl?=
 =?utf-8?B?NUY2TUFWZUJ3M1BVUGdJMFR2dmxZR1ptWi9yd0JUS2pENmkwVkcvYWtQR3lP?=
 =?utf-8?B?akh1dy9jTzY5QnZpKytrZ2NYcWkwNkJWU0ZnVlg0ZmluOXI3ekx4czU0RDBM?=
 =?utf-8?B?ZGQzQ2Vob0l6dlExSDBZMG1sZUVwOCtXeW1FOXJjT2dTTXppUTk2TS9XdnhT?=
 =?utf-8?B?MGJiUnhzM3hwRWVjZW0vUTY0MG1OTlNvZmtNRzNOekxHcnJheVNzUTZFR3ZD?=
 =?utf-8?B?QkVDVzVIczdZNHoxR3FCaUVEYUFVMEF5U21qWlNleHJkZ1JEb1o0VTJvd29P?=
 =?utf-8?B?WDh4NkpRTXFEUjk1VWF2d3pEQkRucDJYSkxpdDRjVnJCejNJY240cU80Z1pm?=
 =?utf-8?B?djBhL3BWMmN4TmxwTWdPT0E2NWZ1cFFrTU4yOUtDL0JidnoyM1BMVU5jb0xh?=
 =?utf-8?Q?X2hYQSw8ame++tiE=3D?=
X-Exchange-RoutingPolicyChecked:
	sX+5Blq2LJkTn22U0zdTLXKenejgDYJSmgXct7h/Dsm3wQAp7sigS2MKf+oBN0beUH+SrgC3xca4+KI3N98ryfLYAPcYxJ58Y2f7vV7/wqX7C7fNzavYQ6sxqU0EBruXR5TjLDoC9ysbiNaLcV9q22mRIknAnSwD1fOT33P4/z/w7AffluLA49xPXmznKwkyNCkLvwUOXLaJjJlN5UOPo/x33Q0E55HXyFRpQUw906zToaWl7RRseu5u7gW1z2bWJ2Muie54bnv+zOvkCaWS4cZAt0cbjCa70zs0J37KGzYmcwPueCh5riquEe+CyvV1/sN1Um1m6ZMTczgz/HLv6w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zoZIOyPppcg9rYHRy2IifDpzo1CZrzQxSYg4/WPbJWAv+8fL6UqbH6msico6qVIOqC/rN+aRTiYMjpEhdmnvNvTWScQyh3LdQnv3jWRUOp/a3nrp0Lhj4CpGQJU6kZCtTzmJPrhY34gz4zoLs2bzCUExzG+hHmRYh7rl7z7h0kwBOLwbXhmc2jK8XDbW3nhXqhBBBbbmLZLl7s1oPrmQ5ICkLfAjbyLB7bt4FgM4RiWX06Ndu0YIF1LOWVYsRYC8yvJaJ4mJCw5FIMs4n3Tngsg0g4T2jztRXxJ46fgOZlxBpmRAAd6TtO57eLkMVHxGpBYnV8wKboIWuE4msnmEFlk0iKAECUARhwG0CkmrzAwR6T+kVE1N2fAG52xrIYrkxnBWwcWlnYGa9w+LRVqqso2693TM+QcdMVmxCK6yN/GJpZR6uYvkq1dud19F0w8LPRUGC2kdWkh92bFVD9L2R9X9ffMkCnqZFUFMdlIjz690M82iuz733i2q4iGShXP75axWyVBpz9QaJDB8QGWA3wCoOEQvb0/nzOevOcuxa/iTHMDimXWWmCN/dkkrb9mWgYQFU1s2GCr7rj7HpfJnWT0pOBStjB08KT/ubsUXJX7i/Pkd930qnwUG5+E/3WYW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06bf1c6b-fbd4-4cec-75c0-08df0d7ead65
X-MS-Exchange-CrossTenant-AuthSource: DS0PR04MB9439.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 07:56:24.3588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x2rk/8elK5cC+1UaC2lAbqoV1evIn6HglONY0PtSjS5nCbAY4Y7B8iHdSqA6yhue5FKFegXPV17Tc+rRfMBSDuOxZjx1zgvZm5GIxMCGjI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB9042

Looks good to me,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

