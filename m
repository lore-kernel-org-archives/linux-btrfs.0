Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0965D3D5C1E
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 11:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781265551; cv=fail; b=WDnxil1CUbqwtJXUsaspmK3kU43Q8o3uSyDB2vemumpGUAOGhSq0/c2KKLyDzKKwW1jze5VCqna1qrlh0DSzGFZxNkmog+bCK5M4KdXmX29Zp1VsfI5x/EN6Jbuo9YQP0zBe8kr5fxq0msEX/ZALay5WHIPre2tX88w7PIyxdkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781265551; c=relaxed/simple;
	bh=CKW1zlcxdGVb5oeeNtOQziYdeMwMXr2exx5Qk1fDAII=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ROPvsOSjfl7femAOe9uIXk5pOAE50gM/wWHQDyIS/JINHl+JTcCN1g6lTJIrLBl9GC+woI0TXAcSY0VxXIXVZbI33BOadAW3O05GZ2Ke7JSRJVUUbNA3n8KOZ7Bx77h5b5KmgEfZQDKzwsApfQYumQOFh+p7jAc9foZCXLckumM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Zk884ysY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=viuT/ysY; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Zk884ysY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="viuT/ysY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781265548; x=1812801548;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CKW1zlcxdGVb5oeeNtOQziYdeMwMXr2exx5Qk1fDAII=;
  b=Zk884ysYCuqgTJtHDx++1Y1SWB6LJgOP4yyhtiLmVzQ0OatCbztnETVU
   Utp9oiCXKtzQhDIGmFdA3o+c3zHHdLN9B69Ymb8jXr9dz5MUVurXYjA77
   JVdtXbFvAnShLvDhS198Mo+O1mcDwx31rZZo5r+MR0H9ZHp+z0ZsuZ8rd
   xEtzov65/bb16+GJA90ujKJJ0kvdZp5dcGzt/dQj/dBxjP9s68n3hNLM8
   /mEA5ZS+UVbn+jrcx4KSFqS16RdcqJ52XNRRqFLTVWTaAOGKtpYdqP51E
   ctFNSuX3+/g+EWlEkPiA1uBgh9BtA1SpajEjiyOSLShs0mPxrB6te0Fd0
   A==;
X-CSE-ConnectionGUID: lrrfV6aASvSf/rClKWQNzA==
X-CSE-MsgGUID: m+QzNX5fS7+SCcV50gcpww==
X-IronPort-AV: E=Sophos;i="6.24,200,1774281600"; 
   d="scan'208";a="148037061"
Received: from mail-westusazon11010064.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.64])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jun 2026 19:59:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rBxCoJmByHwrwt9UfLnXcvzoXKAeeruPuqjhQb0nAow10lZAovwM1JFQqYnGZzAcQKJw0yzbozTP2sBifAm1NpTYVMz+IrUetLKBkvswnXsoWPWesOPPa1Z+4l+XbZCo/fD2VejlEbfbR9Ltv8Gq+MGUgHVJM82pO7+3g0g6Fqam12iUB/D5YbuaHDxvcmp0h6JeVyHjAHAZhSupj4xY3mg97WQxkz8tvnMlIbAwn2RvKmS11uifiZbN5uqq+mKPDFz4dS0NCy6G+28JQypKNzid+DHTgZNPXKmylDa35ZF73yPzLB1B9KOFZs61CXjo7JHddXT1k4oUcsS9PnJw5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cio83ilAGPSfvCjhnySTfZs6H0vRxSLJUF5pTkCwkpA=;
 b=R/Ie0iEmvCRyZ/fz85m/JCPlcHZJt+L48VsMaMjxhY7QagLTqrGTmXUFike6Yj9l1dO9jk9Yu7bpD1cMH6amXL5U5zbNljSOxSYnrdaGyCv98J1PZs6tH+RMnsQ7qGpJkO5QCu8661O+Uhm3Bm7IfwZczsJck7EEbMzBRQQ4ALX2JOD2XHDUZu5/hxsNgTfmobEUhAG9lwi1Fung3zWglnAZMRw4fx2gDNgrxTklVjOrQxbKFplDhPlCQXgwrT6s8LOZ1vRNAzN02SKrYHeAju0n1Y+rZcHzmXXywNBtf7FQsrfJ83gkPKr+1bA86tDAelpOk8Lbh6R5yvk3JEuCwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cio83ilAGPSfvCjhnySTfZs6H0vRxSLJUF5pTkCwkpA=;
 b=viuT/ysYrXlXTzl3oH1r6O/ebasSRVrKw+HfrD1r4LDqPvNCmxUemWYqgTCLM7AY9w85bFUr5MdXV5cZcmd5te4FVy9nLLhQy88hoizIOHDCP6moBDuZ9OnzGd7Rxupx0IsNaZfLtljyLByeiRHEnlpa5H/smxLPMQPToIGH9TI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7261.namprd04.prod.outlook.com (2603:10b6:a03:294::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.15; Fri, 12 Jun
 2026 11:59:05 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 11:59:05 +0000
Message-ID: <8c330fc3-69a0-4e92-a0d4-f9e6492cea0f@wdc.com>
Date: Fri, 12 Jun 2026 13:59:00 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: don't force read-only on transient -EAGAIN
 from reloc merge
To: Damien Le Moal <dlemoal@kernel.org>, linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>
References: <20260612100429.214341-1-johannes.thumshirn@wdc.com>
 <3e3b0ed7-85d5-4461-95ec-b9a387db7553@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <3e3b0ed7-85d5-4461-95ec-b9a387db7553@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0450.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c6::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7261:EE_
X-MS-Office365-Filtering-Correlation-Id: a5bde128-7cca-4f41-cc4b-08dec87a002d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|19092799006|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fn8B9OcaAno9ZGO4OylyFEbWnJoy6Z6iyR8yN3+dnYYezoNsdC/mHE+TmdLTQVX6pxOzvjCD+S4zTOJTjVIqOrbZ20fSzbOWLOPRwEo9NBWW1JQLSP2KEmn6D1Xwt+0wEQfh4Bf4iJFhKJUqBqapxykjN6L073Qd2CSEy6ghdOlHLS0rVOSF+9FreWGmAuhf9ixnXQUje36/sfF1i+SrvIbeKo9Gc+ADeQTvZnrXev1YMh/gWFvONdGVODWbsIwb6WbLUhdbM1IKUnBaHjIXMQa/Gik9TWxQ/Wq6lVch8fNfEe27zaP4VC6fHcE3OVxwrMsyF6iynQyNjjg15jBTz07zs5394oIuP7ODShZ9om5QbaIIVvkABuUGxv3wW1/s0RqZq22tOXWGvREVrv1bZEo06ISYhHA/4FXxZlKiF2cneD8yN1v0pkjH7fg6c8B9e3awoYKUPTe1vnTaCSFrksmrCpCOLzsWNbmFpKz4Wd7ASh8YqJD+Cc128K4ClWKY/Nu1HHwhPZbXf8LBE002SWf38uLq4HADbZqFFzLiINhIyBkYZH9hlVo8hrkpQcUqBkWre9SBWFsqw1ytaRN7xdy7oEh4yzgkC7ukSXaLKxLwAto6PM7u/C4bnIMaMXjLzGC7GjdEUQsRPRYjewpYk7Idmt7bN4425yRJm3JHN55WjBXiqW6IvDSrOZ/zV5mX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(19092799006)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2xFaXBjUkcxQ0FGeHc2ZmtPcWw1YnFRenUraCtJZEkrN05UcGJ3cU5zcnFB?=
 =?utf-8?B?UnJpdXprNkY5UGlERStHLytibVdMQmdWOFE0NWlmUVFzckw5S0FWSTQ2dEdn?=
 =?utf-8?B?UkhFMWhXS3lSRXEyU1V4Z2lXRmR3V1JqZDN6QWxBTnNUalFwbTNHU1JUMWNV?=
 =?utf-8?B?MG01R3d0T1oxVERUTDcvbnNJVXJ1UnBZOEtRMWNHWHh5WlRrNWxZVXYxcUk4?=
 =?utf-8?B?ZUR2M2xxMmlGVzZWT1JiVi9sQjNUaGVoM21yVVdpK3NFUXlhRUY3L1pUS2d6?=
 =?utf-8?B?ZnREMmNwNHhxeUc4Rjdua3ZvSEtCWitIN3o3S2t3NVZUYStHeWpacGsvdTN6?=
 =?utf-8?B?UmhBQVJnOSt3dC9wOUF5blpsMVNpY3NnU0FHR3hjTG5DamdRZGhML3diMnhR?=
 =?utf-8?B?U25sZzRMMDhIREVYZ1FYeFJpaHRFVWRnVGs3U0hNekFLYlFpUEF5Q1FxWkht?=
 =?utf-8?B?TW1ZaUxTZkpsek5hRzFLUXpMQmxMTjF4ZFNCUFpNL3FWV0NhNG1VWUtPM2Zi?=
 =?utf-8?B?TGJ2T1BhbENuaFpodGd1VnFuSURkVWJRUnRBWjdNeXFVRjg5S05vODQ3UGNT?=
 =?utf-8?B?WVY2Vk12c0tmcjhUTlREWXlITnNLbDRQVjMraFhLaFRIbk1PNG9kSDh6emxn?=
 =?utf-8?B?S1daOXVnU1NScXlSR250eGdFUFJEZE5XT1dweEFVNUZYa1FJVVZ3YW9HZ1Ny?=
 =?utf-8?B?WUgvamdrQ01lbTVEYTJHandhTm9tbGpUZXR5ODM0ZkVMQ2k4YmNtcmEvMUhj?=
 =?utf-8?B?NEdUU1JuVHg5YWpVYnZoM1ZkME1JN3ZNaWVFTUhWYmx2RWdmWmszZkEzSWpK?=
 =?utf-8?B?SXc5QnUwQjNvSkE3bVIvNnNtMmNWc1V6c3JFb3dJRkxFMTRuV1N1NUtVTjVi?=
 =?utf-8?B?SW5jM2J1ZFl1c281Mk81TDZmU2MwTXRYRHlTRXFhVlR2OU1qR1dkaWo1Q0Za?=
 =?utf-8?B?czYrRGR0Umd2WTJPc1pUOFZnWmMxTXMzUktNazdUUEtPaG1LMC81RTZHUWQ3?=
 =?utf-8?B?YUtWbW5KY3JNQ2VLQXBocFFvbk5YYUU2eVMyNVY5UTAxTFA2b1RONE5uczhT?=
 =?utf-8?B?dWtqUjJXTGtNZjhMTm1FZkZQUkNZMVIvV0tzdlptQ2lBNWtMRkV5MmRuQmww?=
 =?utf-8?B?SitucHYvdTV5b3FvT2RydFZZNlkvRVFDeVprQ2s4dnlwMUs5dWtoODY4dy9V?=
 =?utf-8?B?WFdKUXZpb01HSFdPN2ExdG9rVGdGMWFGTk0zZ0dzaHl1eENadEdJcFQvV1NE?=
 =?utf-8?B?dFpsZjdHdFgzSThBc1RoejI2Ym1pK2oweHRvS3BvWFVaVWtDYzNjQllnSDJz?=
 =?utf-8?B?WTNma0IxMG12WGVpZzRmZTVWM1RpYXFIUVVzRDMzNllOL3NhVitXZ0dQVitF?=
 =?utf-8?B?ajlDN3FzRlZSZUY1Y0dCVzlMNVE3Z29mdUVBMDVYZmFjT3V0OVdYYm1NZkJD?=
 =?utf-8?B?NFpKZVl1ZEczV0pmTjg2WTgrUUhkaDNDZVhuY2NWTXJLY1hoSytQajFYNi9P?=
 =?utf-8?B?aWRsd0szWnpiaTh5UUhoYlFiQUtxL2ZMcTRoeEQ5T1hzR20xaURUcjlZV29j?=
 =?utf-8?B?ZnpmOXp5WS9UT0dKQzQyL3FhRnpWVGx6R1RQajVXb08xYVhoN09lL1JmUnZq?=
 =?utf-8?B?a3FKcHpVZnhTVmhSNGN5ajlRNThMRlVwbUtNSGFiL1hRbGNreUJZaCt0ZHhB?=
 =?utf-8?B?RzNkLy91YU5LTDlzL3ZqUEZwcVZzTytmUlpBa29EWkhjWVpuUU94cTN1enhl?=
 =?utf-8?B?WndsN0pBZ0hCWkJpYlA2MTIra2dUTDVyNEZ4MkJJOHJCREJNTTdjU3gzUFpy?=
 =?utf-8?B?c1FsQW1vVUo1SkhUM3JNSTBnMWk5NkN6RW1ucGlHaVJ2ZnRFNTkzYm1Ta0s1?=
 =?utf-8?B?UHRGVGdrUm1uRGQzLzl1TFlJMnBDaTE0U2RKQ1FkeXlCV3MxS2VXR2RvSTZ5?=
 =?utf-8?B?c3pnLzRKSHJJc3pPa3FRQ3R2Z3d6bnhBSlJMSEdsNXE4WXZ3dXVDRlFCZ0V4?=
 =?utf-8?B?TTNXclBQcTF1dTN4WWxGR3VVdEpxa1VHNGY1cHgvbGRNOHppY0t5RUMzeTA3?=
 =?utf-8?B?WlVxdDRtNVFnQXlNYmRwQjRYVDdaenVoZmdyUGZoWlBYR1Rtc1FSTXRzTkFj?=
 =?utf-8?B?NTNMR25wekllQ09ZZThlNGcyWW5YbStVZEoxVjAvYTU0bzR1dkEzYzEwTEJu?=
 =?utf-8?B?RDE5SHBMUWVCZXdvWlFsSmFyejUrSU15MHBZTG1yblhFaVYxOThiNFBMdG55?=
 =?utf-8?B?T1ZEanlRdFpjYTNmTHpmKzF6Zloyd1BKTzY4S3Z4RXVxM0txb2pWWmZ3bDZZ?=
 =?utf-8?B?VHNQYzdiN1YrS3pRZnBRcTNsdndWRElKVjBldUs5bGs4L1ZCK3JRSU1zTndp?=
 =?utf-8?Q?vq/TRmWUnn9XgQkWxzIMrB2z+rOD4qFj0EF7uc259LN30?=
X-MS-Exchange-AntiSpam-MessageData-1: Ks4xF7jrtgfcxq9BuY4pRzdngfjS0vlKd84=
X-Exchange-RoutingPolicyChecked:
	ePnJKOg/l+6ge5/Wo37q1NF0DYtcKUyB3Makacg7dob1tAyNoialoaClaWMPhKxpcIlys60npT8dBRRJTVg/qsL1zK4KechpZblYgeMhXpN0wlz3xmZ9S3OM171S1mhD/4jGnDTGZeICCVyBMIMrXLGPNeSXlzkMwVWlYqpEhnyt2YbkDvIjxiBxFCA1OWejsiNvsP0EU0Uz0XGq0TL5si2Iv844H575orv4j5XwlTibFC7+Zg1TZeunS9/oOGEsHjbEnongJZoTyfkWGISJWsrP7guBU5BRTANpy7wxgDRyrm3FUPva4TrOP4s1SLuPMw18QNRFK0E+VXsJ0FKp2Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nAkY3T/EiUVWo7KkZ2UzegSMfD7JWqy4cTnNWyaKzKfuJV1FPrty+Mc9MIiKxNwWptFCq7mjLeTd9OmlD7ERTXDbs7nXhjZz9+gCSBz3JWNksObTUuDE+xc1Ig5xZB6xC8Uz9sMaSaNVQk7mHJaZsqxeb5jtfnskaEcsqRa8LWgKmvaOkeAnItNwqdO1QbCs7Pbg8Bjdxee8BsPtPJh2fogCxQXRZVNjlqKcRfbh5m/2pTeWDSH8b4qxkeO4B7MD1xyI8PLszJ3Y5fBI8gVl8I7nxPuUPD6t7veDh1F+qoLknF2ppozYq6Ga/evuzPrt+q+vsOKCPWh2kLnysY0gDWC22DOkjt+AH7Ap6oHfq2CzcUZaknyOCHmjUtHyOPQvd+n4sr902N60RdI5AnAftW0wriA2tnbEQOAkib2fdqPrCG4i/ZATBE6eO2/N6UrFpVVcJ6xlpoI+ZMBwD1rmzqXxMmsFD4U6IhEm5h0QUW3nCoF7y8TJsC8hXCgfr4C9BeIZ1n8Zmier8t9zlWbppZTCw5+VQRAIST2Xh7Li70Rbq9pRMYpKgKKjySRl2TCmqlC4LUV6T5RFkZhbR+VGTOMa2aBMWMqLnNRr1OJct5/6b7kTZuO5Ixfzwmdarok3
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5bde128-7cca-4f41-cc4b-08dec87a002d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 11:59:05.0128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XXS0a7JwG7x7MBjMfoyDp/qkW8dTuGjSHPXJFSy8ci8FN9hdlAGJQXm62dLYDyQs+ZX6Y2k17O2jhYLJzDah7sAfvD++PQdBskpVKnJOyvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7261

On 6/12/26 1:56 PM, Damien Le Moal wrote:
> Why not:
>
> 		if (ret == -EAGAIN ||
> 		    (ret && !READ_ONCE(space_info->periodic_reclaim)))
> 			btrfs_link_bg_list(bg, &retry_list);

Good point, I'll send a v2

