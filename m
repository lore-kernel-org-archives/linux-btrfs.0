Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A7C346771;
	Fri, 28 Aug 2026 10:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787914224; cv=fail; b=kr+pfTmohy7qkHGa/Qs/hU16EPYke8SzMi2PaiTgzMWegxdKxLaXsSae+tUQ4fgFmRqnmfmhrHz1cLJWkDefsSFyfBYHE8NoTxEieo+QW2a9vRH0zGLmFbwdI7l0WJdap/hzTA3eBSG4gFOwBRI9AGHmWPgji3MAxSNGXy1nDBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787914224; c=relaxed/simple;
	bh=AbB+8xGueSBn8FC6KVTirOAIRT4Egv84oNBpdU3c4ec=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jeL6FN5jlnLUoy8+ZSMoGiMv6xrQHnwN+j491Iwj5CQm75fJIxMmvGXuO4K/0FQwwWqFAgrerYrCu73tfUr3amr+K/+ZA66ynzxspesDA0VenZ1pd0BIRrGWFDbBCsIGM2Z7mHTIkeQ45OsBjv5olxq8LErodwVdbd12nLRWGU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=DcMRdGlA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=VgT4foSM; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DcMRdGlA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="VgT4foSM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787914222; x=1819450222;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=AbB+8xGueSBn8FC6KVTirOAIRT4Egv84oNBpdU3c4ec=;
  b=DcMRdGlAfD7jC63F2O8MCQTNeHWNopnkbxT9r0SIn9XcRIF62yJBiQC3
   feZ2aD7Eb/HgrOTRXrPakajnheRQV/NKMdpLW/sN4nKIIOGMSWKK0xmRe
   YCrT13atvYjJWabv1roqQJ49YxOQVOozbmMFJGsZF5vQmGFVs/4jy2YZY
   AHbqXhybo64bdptHq9OcBioaHI7vzlLDz5dq7zAglfc7mBdc8AkPP7NbS
   nrA6SH3RzfKYN1+5hrbBIgB1jwlaxbwEQH5aFL9it9g0+pVJWrSRUjhmN
   c8vdkAnmnr6gmjJdo9i2P81ExlU/jfcXZMkKs+C+MmrQ83w+RUqyp+TVy
   w==;
X-CSE-ConnectionGUID: d70N7YFWSE68mN4p0oCKKA==
X-CSE-MsgGUID: y8xx4v6mQqmsdATI4UUsjg==
X-IronPort-AV: E=Sophos;i="6.25,248,1779120000"; 
   d="scan'208";a="153499112"
Received: from mail-northcentralusazon11013017.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.17])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Aug 2026 18:50:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQqKbc3nZolTDXpOrJ0jvx9LMlvoGif9FxdepjB6VpJFXo7z6+TXe6Gj9VXDIAMI/RrelQam+lKK342lrzPaysdtwRn40ciy1QMRvU61oI2Bnwb2uQYlk0pcLtT9MzJWYg5s8eeyD3rYXPXaaYAlLH+7pcQiRJtfHunFtR9wx9e0ktt3y66JWcpR8oL7wbZ+NEymQ+Jyyhoe01Rl2dlweRDw8jsBcOvYHmTWxOPhHtNdxEJKe6YJi6flIfNx7HMz2DQjWnu9q15YAYtSz1t8CJBfzcPno23YEPWbeN6Tv9zbYwSIiPoARMmzLKYA6IczDVB25lSxvOIchjbuvTuWBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S1gZib/M+oonb2cr7W29+PCkJROAbSGQVVWuQ13P1Hg=;
 b=XD/zLT+pS3dD2tkmsGr3G4RTaE6tbLmCCFRaa55Sm+jv+/GpmkEWZwun3F2sN5BMkKAjA7eyK0t+/3iLZcOIP+4Mfe+gDiQarvSYtAPExEL9Zn0iMtRFq8Xkh7e+uBOIu93qtG5oplH7xX0FTpYwKNO6jclpvEsEHnjuUZjan1Sd5JiFKRVmNz5aP7aCYj1Q7eQk80HjBk6GHxEAqLoRtn4PYID01veqMNbrgNWgRYWmk795n+KX6lCcJah2cfJSOzPK9vxLNFuI9zxIpbEGcLsLWpHTfoH+CaneMFIA1iLH9OxfPPWw3YlhQXv7Pn/McLX1XzX9REi7tkuGfmsBFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1gZib/M+oonb2cr7W29+PCkJROAbSGQVVWuQ13P1Hg=;
 b=VgT4foSM2jWbkVgJT/8j9A+KuJYmZs5Flh17bsgJgMV7v+6JGpwCxubg9Inb3HfKlsHixBa5qcCJWLMsn6x3hGCjlMWJeO8WkKTmhwQB/ra2kxeDywF0IsJ4x3EKwa1r7K5aZw53aXk+7m/LGxe9Vdanh/5/Anaa417uuB51YkM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH8PR04MB10005.namprd04.prod.outlook.com (2603:10b6:510:3b2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Fri, 28 Aug
 2026 10:50:19 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 10:50:19 +0000
Message-ID: <dc1d9565-277a-41aa-9683-8a8e9364a65e@wdc.com>
Date: Fri, 28 Aug 2026 12:50:15 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] fstests: misc fixes for zoned btrfs
To: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
 <apBg3n-J7PP2nD0M@zlang-mailbox>
 <c14a1467-c813-48b6-982e-b877f4e5d843@wdc.com>
 <apFZlAt-u7T2dTEN@zlang-mailbox>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <apFZlAt-u7T2dTEN@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15)
 To SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH8PR04MB10005:EE_
X-MS-Office365-Filtering-Correlation-Id: f8181035-4fe7-4bbc-29bd-08df04f226db
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|10070799003|376014|366016|1800799024|56012099006|10067099003|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	50/451mqYJy5TMxkCW8P78BHlntdUMSgLaDB+DdZZ+vkXvFds/BjvkqG8V14h7LIdcp7QYX5dILoPWoVDrcw1OoJZnxM4uQZDv4F0xhWgtt0OX8ZfGawCdrxJfT3WnwTN+Wxknei/yy/GY3DodoPlkIdik3tJ6fIHEU8IFRIDz7ySShJeG/TKFCrf0od1yiFlRdZDU8f0dHrnNq3Fd3gxEtYa8GvxjRpR6QgRjzvr8/uIQNZ4rU6RYsZ3QJySGAVhQBJvqY13E0em77zNlq5MFeWq5JL8tOL6IKc/FnoQNBx/QkiHyPgwgRlFHksStlkMhBzD2Lm2V0WKIHe8Pdkvp4PQ66OmSs/g6YckO670CQUG91yuoOFJPQ2AGuCHGV6TEvsqbXL58kCuCBV/qu0qnqzeRkSnbqBPwdBF4HspC5cKK/MG5LGV2pAqOep6aJZVh45iRj5iz1Gr5vHAuvKGyn3PIVEjxOKNWf4UGbWtIuQBIvSjAvveFCrl0/0fideAr2kco0OcXPpWaoiCGyavA9SDGjYFvv5IMxTrOg7X9Gac9wt3RCW3bDhYjSNzYO/0A18Wl0oCdK1TqRyHo8fU92PtL+54LXaPu4SNu02NOJVA1oMc1nn8v3jEPFqXRx56W7qF0jbA1FOeNAOrkwfPYU83y1wM4N8DOXMQ1NM2+A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(376014)(366016)(1800799024)(56012099006)(10067099003)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1BoUGY5WnA4ekx3dlU1bU95WmFYb2w4ZjQra0JJbDNMektBMlVwMHpTS0RK?=
 =?utf-8?B?R1NlMXZUb21CRUt1T0pxR0h3RnVRWWtEblNUTjhOeVhmSVFKeW16bU5QSUpk?=
 =?utf-8?B?cFVmSnZ0bUdiaHNVTm1TTlJudGhZMG5pUjFoVHYzT1YvcmgrOC9RS1R5Y0V3?=
 =?utf-8?B?V1pENnJsNTBsdTBLK3VENXZkdmxKdEJLZXlRZ1RxRGprd2FybDF1TVp4YUZQ?=
 =?utf-8?B?ZUh1QVJQVTNoS1ZoUFRtUm8rdHBhc2NjTFNncHVhdGhYakVBcTMwQzQydjVi?=
 =?utf-8?B?clA0blB3cUhJMU1DUTNmVzBtTEw0N1ZJMmd1bHFMVUw1bG5kTEx2TE1kQ0tF?=
 =?utf-8?B?R0UvbGdXMWVYdzE2QUxBdEU4REFCTW1RK1dXVFFNVFp5emtnd0ZWTzZwTkJP?=
 =?utf-8?B?QmxaWG1xT0J3Z2VNL1lZdGh3c0lzb1pzdHJBSFNpN1NvU1I3QXNVUzVZRG5N?=
 =?utf-8?B?eEljMUNaTXdZK2NvaHF4NmY3akV6RnRWRnA0N2ZqcWZzTFNaQnJIZVE0ZThN?=
 =?utf-8?B?WFhTeFh2NHFnblVkT2x4R1lXOGpXaEloM1MySVdURHYyYlE1Z3hPS0FOUWR5?=
 =?utf-8?B?M3VDcGk4MFpwV2xQZ2ZkeUtlb0JqQk1tVjBVOUxqMHlJSHVXNFdxQkJjN0pG?=
 =?utf-8?B?NytML24wN3dKeHdxQm0rQXlrZXl3YUNhL3pyZ1JVL2t2OTFpZjVlTllRbUNC?=
 =?utf-8?B?Tjc1MzhzQkxSMVN5bDBvOUJmaStqOXVsTG5WVTNTNkRjaXRHNTVMVE9VeURZ?=
 =?utf-8?B?YUtLT0tteG1NdGcvRHBiTGtCWW11a2dwdFBnOUUvak5tQTJPbTd1SWd0NjJz?=
 =?utf-8?B?U1owS3dpVkxjZWk2QVl5bVhpS0tuZ1pDU3ptd2lCb2lKZnZBS0ltejluZ0hI?=
 =?utf-8?B?S2xiUEtneEd5WG0zS0VLMGJaY294SVpEVTdPM3RCeFdrNzR6TU9SdFZDNzha?=
 =?utf-8?B?bDNtaUc3ZHdXczJvNUoyVUhOUUM0NzYwMXVIQWJmc09yclVZQ1k3UXplVzRo?=
 =?utf-8?B?WFB1UlEza3pXZnIzN2NXRUlUNllFTWhST2Zjd0V5UHJMME9wUkdDRUJ2ay9q?=
 =?utf-8?B?ODFjZmp4K2xZckVONVBkWE11V0lqY29zdlNEdTVQQk5SYWdpb0xLOWtNcGNk?=
 =?utf-8?B?ZFAyOG5kNUZnV0xQK1owZ3IxaUVKSzZLZHR5MjJaeGszR2dXOWpGcng0bUhL?=
 =?utf-8?B?VWZVeEMrcnZSdnZ4YmcyVlVGbjJ5U3pGbGRNcVlwcDBXSEtSanM3UWJObWdq?=
 =?utf-8?B?czNvT1ZLZVY3R2RDU0ZQbWJTUjJ2Ulp4L0FsdHdKaGplbEt5RTR1d0ptMWti?=
 =?utf-8?B?VnNOS3FUdUhERVkrdy8rbDVtUlNRMzVXUmVoaGxwc2Vob25VYlVsZ05FdEZi?=
 =?utf-8?B?VDl0bFdqN0M3MTYyM0lNTGx6RjJaWXJXMllRdVhEM0Z2VDlZL0N5L0NmTm9B?=
 =?utf-8?B?RVRNNTlrbVhnalhCenRzclh1aEdyUENsdTlDblpxMU12MjN2WjdDbmIzK2Nm?=
 =?utf-8?B?NFZBWkNkd3gzQlZucFIvYk00OHhqelo5b1dZNU5aYUpLRGlnT1BZUEVRQUsx?=
 =?utf-8?B?QytNWk9WQ0RocDQ5S1dMb0l4UHI2T1lYT3FpbjRhWmdoWTI5QmtMa2p0N2xv?=
 =?utf-8?B?STkvV0ZtZWlLcWp4WHhxbFlKY0p3Um11dWFXNVpJK01VNmUyWXQzakpDUWxG?=
 =?utf-8?B?a0NzN3hyRjlGdjBkcEphMHVOQW13dEJzOS9hUHdWQU5pOWo1MldjM3diMGxK?=
 =?utf-8?B?eERjNHAwY3I3OEVZWVA2Zkw1RFlxMnh5UHJydGFMWGRHNEluYjVjSTdvSjhi?=
 =?utf-8?B?QUhJV2FHenpYY01yTWcxbXpoa2pScU9YVzNiRy8zdUNRZzVUaVEvL0FUYnhz?=
 =?utf-8?B?TzJ5WWttRkNOYmZkRDE0RkR3bXJweWgvQ0ZrT3hTa1pEYWpmUFhpZS8raTkw?=
 =?utf-8?B?c20wRmsyQk42cnNmYitvUHpPNEtSMzBuTTNqMTlWT0l3cTB2NFZnVFdDa3c2?=
 =?utf-8?B?UlJCdk5kK0thQkd3UWczT0hPeWpLNHpQVE83c1h0emZzeHdhTFhaVVNqUlR5?=
 =?utf-8?B?enZ3WlEyLzJzc3lUQ3FKa0l4ZGV4elFsYlNSVUdMeGpwWTNNODIwQzJjbCtP?=
 =?utf-8?B?bWdHaTFYK1FDc2ZTRk5aL2FNRng0bW9LY3BBYVZhc2JtT1Y0Z3IvR2Y3Mmdj?=
 =?utf-8?B?Q1J3WkpFdVdpZmxGWXRFY3U1Qm5Gc24zTUlsTTNScC9QNXBZTTVUY01VN29o?=
 =?utf-8?B?TmphQW83QlhrRkFrMVFjTUZBc1JMai8wYWVSOWFMNlRtNGRSMTFKZm02ZXJw?=
 =?utf-8?B?YWF1bk5sdWRob1ZkNXVMbDJXaU1mMHBUa1lLYVdtekg3d1FTM21Ddjl1andY?=
 =?utf-8?Q?ggy6U4hUKsmVJXRBLvOj/wc/EBig2+7dFN9JvAkweF8Y3?=
X-MS-Exchange-AntiSpam-MessageData-1: bKAShV3aoCnShlMArMVCSjN3Sz+SL53sTfA=
X-Exchange-RoutingPolicyChecked:
	r1TGYCOaotob+t/2Y6RX04Zdr4S6nm39lxQZGPOU1RorhpyttEqfwRoLlXL63xaB6SF+TWWD30sYYW6ZAy4TCl8Sdn8B2953wc4zG471F5DRUTNN9d0MGuv9sjr4gvMrwMjnwXyBFGQkW6TYBtWv276F8Cyh2pFEIRLO9QeNZZ8RnrWCDlwxdMWUwRFz79030SgKiPP/E9L0kpTxDW5qaj7i/qH0Xy7mz/eVPso8ArWUZL9hQotulNHt6shINlOyd55Gxs4/zirgoq2x3vH2h+EuSVPWmBTSoSw0Dvs7a3YdtesGA5R5XZ8Al2vTofD8v7NUed5i8ekfXX/AgpjHTA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jZlKJF4t/ur9bXwuBc7WbZmk0EfLTxrq8w1vy9koRUo9MdRzTKak/+UBtaKGCvRnxD3P/hy/XuXAMbevliGts2/swEojad7eO/1T7lFEBLtnV9FHy+Ys3DSLSEzrYNyLop/ondAS1Vdf2sdMJeMJqi9rBT2dxBLWmvcTdWTbZ66z+1ihDK3/3oIHI/I/L5OewJ/WebKfoXJ8C3W8/M+CeqUzpOdLna318N7687pVv2SLNGgwvJSwz/+EH8tj/Kmor8Vy02NTTa+EqeF/KqrtQ7hULZ1P1OmDVeQNX57tDQ0QEdjByrTPAruiUJrOw3sGqnQn2cLO66muA8X7zuFyy8PRayn1xwMNR2iKkngNdkKLEX77JT9S0G1UstasRkxuW/NuSJSN8va/jQAvjpOgICyyTioUJlmuIJlM9Z3mMU6r3ahh4Ociz9dfHSAufLxdZfJ2Ev5RLhH2l+WTOuTUSJDROs4umcQhZTf4wU/Esxd99xibq8XAgsg+WckjwF8TQu5su1k2vKXCXtzUzzqKgDzVy05qoKjJvh6CO5EiaY6+PkNOO8LsLCV/PnWvwznFRbbL51AxwkcfR8Qa9WJ75QRbAPvRTYEDXqWlXlikCU/noVyEoUPDHtxShUdQ1/Wt
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8181035-4fe7-4bbc-29bd-08df04f226db
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 10:50:19.2399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AT/oJAKfeMr/mQ2YjMGkFp2e4jQM3CVO+2NQtY6J37/39fDB2rcowaAS5yu78wyFJgitSa6csLGSRiwFq6LEuOxDH9JlBhSOVWaSmaobdo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB10005

On 8/28/26 11:54 AM, Zorro Lang wrote:
> On Fri, Aug 28, 2026 at 09:20:34AM +0200, Johannes Thumshirn wrote:
>> On 8/27/26 6:09 PM, Zorro Lang wrote:
>>> On Wed, Aug 19, 2026 at 03:16:00PM +0200, Johannes Thumshirn wrote:
>>>> Misc fixes for test failures (and a typo) when running fstests with
>>>> zoned btrfs.
>>>>
>>>> Changes to v1:
>>>> - use _require_xfs_io_command "fpunc"
>>>>
>>>> Johannes Thumshirn (5):
>>>>     common/btrfs: fix awk field separator in _check_temp_fsid
>>>>     btrfs/199: skip on zoned devices
>>>>     generic/746: skip on zoned btrfs
>>>>     btrfs/284: skip on zoned devices
>>>>     generic/781: fix copyright
>>> Hi Johannes,
>>>
>>> Except for [PATCH 3/5], which still has some open points to discuss, the other
>>> 4 patches have all been acked. Given that this is a misc fixes series, would
>>> you prefer that I merge the 4 accepted patches first, or wait to take the whole
>>> series together? Either way works for me.
>>
>> Can you merge the other 4 and I'll try to get around and incorporate the
>> feedback to 3/5 ASAP and send as a standalone patch?
> Sure, you can take a look at those 4 patches in the "patches-in-queue" branch
> first.
Thanks :)
