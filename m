Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5143D6467;
	Tue, 17 Mar 2026 13:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773755972; cv=fail; b=LrF7Ez/w7ZKdR7yq2aKHwpuxIetnmg8a7qtKBSDQrkeb4WSYzGVzKmMdk+9oa9gRNRyiTCTS8T6kiJzuuba2m7FTjwd3ZD7fPIQkef5MmMtxdjecwO7ZJac54wp+Ipu4TsrZzYVseNkNdVvSIT5ThXAUs9R7BnbFOvpZolWz3QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773755972; c=relaxed/simple;
	bh=02fbXerAfzMdE7KxupaF8gDvhrfRJIUnWuZAtRNMHKc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=spBYHxK0yG1opgLtRIYZ/ZPjeZ9zYIdCs/Ec1G+SEdXZgoOqKgZy2pS+TBvCU6LRpQhnya9hAUfrH/eHKU10ZNEJcHiQThSClZ1IYhU4/lPKclDQhduXwTgGhN1zWrjw7osSQOIDH2phMfDF+uKxL6nCGW/EtoMvAjGOH6j4XAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pQesY0k8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ieIgvu8k; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pQesY0k8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ieIgvu8k"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H2aCY41257306;
	Tue, 17 Mar 2026 13:59:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=avMJCG3c9f5ATpmqg1YPOgVs/svmn5PM68+TP7tnHmc=; b=
	pQesY0k8uIPlhaFJU8BTHa5kJ4eOks+W4EQu886NrLXsCB2NCO/jxXpwmIijU3cg
	LYvX7TvrlXmOf5WH9Ajk9kLG4g6wEcz0rAzT9Iwkxz5LbLmpfCegu1+5GAzhaJOd
	3lac+WmqlbTbAoYHA4U/gdkCd5QIFVdDL3Dc+GlDKQZ6lmWSS0G46GzjtzDzbFd3
	bxVO2/n3YcJXE6yyO/My5I01tA4dvTD9rtNnxAw5WeLRxEzV+GgF1ZCFrzmbarCk
	dv1JgbFsYn5szFUox7omxuJ57knSj4VYROfpsdeKx722eKbqviqUUo011B4EG+At
	M+zyONP54AanPK2M2vJARw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyj644t5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 13:59:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HCZ3dh003515;
	Tue, 17 Mar 2026 13:59:02 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012011.outbound.protection.outlook.com [40.107.209.11])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4a4u9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 13:59:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=De2Jbt1koa3Pq2fSitF1xpdT3MuFoZhFM+IFcgDkPd08kJ1AtSKgMSxAEDPkChJyDhXnievRm4K0CLTTWMv/9zVZmpn2oW2JlhsWpAzeCUhDnWPlebqBvCt4Z4iTAOcyj06Dlay/9ebskRG2myxk8EfiYoevaVj3RN/GOe77TqixCz7h2/oUn5ued/a4z5dObxwnG5jnhhWurpoNcRvfjA7Pc2aWDygyNgvmykH4Xst6RlpqlmErd8KcIjeQtPH6JxYvhAR+ccdXmUelTf9v7268aqbtE9pr/kFYwuIIRV7W+jg5xovEq7eGeJfs/ru0GqrwuPObwK/QeOVEBBqc0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avMJCG3c9f5ATpmqg1YPOgVs/svmn5PM68+TP7tnHmc=;
 b=rkNPVcQoL9TEU+LOUf6xDS+dxvNdWtAJzU5WfMykMUr/ZsXUB4usNdEj3h6b7Bxmlr+NI8ntDWEttsQxsSwwoTb//Ha4od/1eK5dQK98qIr9J9MLGDDvYJAcULOtcqrbKWGQdLy00IyTK6v9gsYMRbrR3Otap75ZJMBz+iBeb0YgCLg/BABET1WsIHHEquq4nN21ojxEZNFj+iIKtfJvsNAmdwoF8FumB7ZUG417f8nC11WO4e69UyVX7Er/rg+wgLo1gQD+ma+B/5Bw3oeHCEJGp5gRyB7G/EOyZz8NWP6eGHkHGM3z7BeYyMDNBAQgC4uonMDr4X1X9jkZ9vSwxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avMJCG3c9f5ATpmqg1YPOgVs/svmn5PM68+TP7tnHmc=;
 b=ieIgvu8k0JxdZ4zFbXh5bJuysMTXp4NMwAqzjlgeKyDggxp4DbCXjHjyjfN7Xj1b55ElO2EFamByFYko7MSOXYV4iFwNHoq+JqhUorXL0G1uWj4y97PeSJNRNTq7/laFI4lTp7Xs1+S/csto6NjV6q3F88GtGWQqIJQTrJHsASc=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CO1PR10MB4643.namprd10.prod.outlook.com (2603:10b6:303:9c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 13:58:57 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244%4]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 13:58:56 +0000
Message-ID: <30adaf6c-657c-41f1-9234-79d807d74f02@oracle.com>
Date: Tue, 17 Mar 2026 09:58:54 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
To: Breno Leitao <leitao@debian.org>, Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, puranjay@kernel.org,
        linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Michael van der Westhuizen <rmikey@meta.com>, kernel-team@meta.com
References: <20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org>
 <6b952e7087c5fd8f040b692a92374871@kernel.org> <abk6PMrSDcb-yXZ9@gmail.com>
From: Chuck Lever <chuck.lever@oracle.com>
Content-Language: en-US
In-Reply-To: <abk6PMrSDcb-yXZ9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH5P222CA0006.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:610:1ee::27) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|CO1PR10MB4643:EE_
X-MS-Office365-Filtering-Correlation-Id: 3671cda7-2e46-4c35-07af-08de842d54de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	pqDRI0EtgExMr8cmr34BvZmILBnG27gvmPStMZFv0tlmD0U90dy1L/loY7PlgI5YnerfI00K84Z7smxrUKKJRjE6A0wg18BWvSGBl0lrQk2YqRzdT2L2Wz7kkSTFQFkwj7tUeuRIb0AfmdM4ubR69lxu0RIYYUppWlBdJpfAyM4Tdi8xw7AdXHoJZeb5qvOXB2V0Ewo+YqbK6PirlDwoSgKZFhnC/+XyrZXb4JX1AlhHjqJRgTloLFNaW+kTlPi89DW5gzJwsqvhogawlJFvpBObEmgmd4SIW92hqan7veeRQbcuS+uJeF2NYuf/BhM5E6DZxZlt30BdC1ipx0I1CIAwrWajCoGEZCI76QlYsp6x1GR+rNh5ToSvB3oNo8hvALLclAECVPkyUV5zwZ+D4O73TZyf9JbnTW93D7CJ5wq+Bw0ToRuOZUM/5h1XhsxxRsFH68LP55osu+6amVCHH0jSa2SOdc+z5QBmswV1uxFto/MJWiNtKv0WU1iYmwWScOcwExIRMtt0roH/v5XNVfCoAKflMJ68NKc3rYZnYO4rLzgOffc6gs+PlK9DkD9rjehcfCwS2sWGY0joZuqFXrSzWP3qzlsM9woXy2pS6Tst31HjuXMiprnKwovijU9CAuCrFUVTQfLzWx5y5czSt42l5NzPk7U94nNXSDFHgHqCIXX3f3P5MQ/ExtRLePpzXqe7/O+eCLstqh0bc0999XFxVMY2ObIjq0sawrezCqo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzREVFpQZnFuY2x6cVZRQW1PTmpnTnRiaktJNDhnQm9qam10R0NVa01PWUV5?=
 =?utf-8?B?WXZYcFk5S3N6U0FBUFFLdzZoeG1CY3R3UkdwR0pqWUE0QklkdVlHc1YrczBU?=
 =?utf-8?B?V2tBdVFCWjZrRTFUcDhxbDN5SGZKNk05SkllVHRCQUVJV3d3eVBUOUpJd3d4?=
 =?utf-8?B?ajd2MnNlYmdHYy8yRldvYjVGNkpTK3NCYU04RTNMT0hUMzdGQitLZjFGZlFY?=
 =?utf-8?B?dVZBNHVVL1NCNHBjTG95Rk53RU5oN1NnNmVpY3V2RTcrRFJDR2U3eWJ2L1pP?=
 =?utf-8?B?Q2FxS2FpaHR0Z0owUWpxWHl3dHIwMzRIeW52SW55SmJIaEMyVi9Dam1jZTBL?=
 =?utf-8?B?Vm5YOGxMRkdpb1YvcWp0blYxM041R3lPT3pLblp6TTd2SlE1ZkpwNzNsU014?=
 =?utf-8?B?MmxOamFUa1hFMGR2U2l4cnBQZXNtR0FzTzB2VDk3YllTTjg4YnRESDhOb1ZE?=
 =?utf-8?B?bEErL3JyaDE0THQxM3RVdlZUSXAyL1hvQy9zNUNOdU5BMnlmL21CbDVneUN6?=
 =?utf-8?B?MnZhYzRSRGhCRXZ0ejMvSnRhT1N1Qm1Va2JjaGJiejFPUVp2VU1KdFIzV1VW?=
 =?utf-8?B?RDZUcllaODNZOGZpT3gxczB3U01ESSt2RXNrcUppMXZsbzBEMjMrb1dmTnFE?=
 =?utf-8?B?cFZGNnh2M2Nhc05RZXd2Q3NyREVRcHBudzBFS2FNRUFUdFJOa3J5RkxoSzhu?=
 =?utf-8?B?SW9RR1ZGM2QrQlc3UGJuK2dEM1B4V0J1YXZiYmZZUkdVWVZ5T1Y2VmdBeXQ3?=
 =?utf-8?B?UVFsSVZ3cVQ1ank3VW9IWEJuSlE3L0pTMVVzNTkzSkw4YkZ1NVRPSUVvQVdE?=
 =?utf-8?B?akhTaWJKOUxrOEJoZ1pHSzE0SDUrUjFKUzM3TkFsc0JRS2lUNVNGdDRqRzhC?=
 =?utf-8?B?L3MzcmtDelVtbWN6WXlkajQ3ZVBSckRRdnZWc1duWnpHQlMva015UlFobUJ6?=
 =?utf-8?B?WW9ML0NRU2VKNmVNQVYrNUZHMm43M2xQUHljK2R0WkphK1FqWDE0amM2OTVx?=
 =?utf-8?B?ZERaaXVMTmZyTllKMDJNTStWaVBvNVIxNUV2NjhMeW9EWmZ3WkJpbThqTHdM?=
 =?utf-8?B?eVkwYi9uQ0wrWFZZZjUveWh2ZVFSZzY5WllSc2ptanFyTnJ2R0R4dkorakgz?=
 =?utf-8?B?Q2d4U29DSzRWQTVvSE9yc05BQXVDaDNlYkVPcXRLL21YU0EwZVNZdXd5cW13?=
 =?utf-8?B?RTBZNFFndzhtV0VJaVVML1R2OFRrNWhKaVI0OFZrQzVQOHB5aTZrS1RMZTJF?=
 =?utf-8?B?UmsrekdVL0pSc1ArWEsyZnYxWE93K3YwWFBTVHFneG5GS1BKNkw3cmM3eHA2?=
 =?utf-8?B?bTczNDBnUzJZcmpWSm45bWMzZmhaVVF2YXFVZW03d3I3TnZtcjBaMjEzWGJs?=
 =?utf-8?B?VXA2Y2hPdlptMXRYL1Z5Njl2T0t2Nm9rUlZHY3Q2N2svcTc4Rkh2NVJxSlly?=
 =?utf-8?B?ak9UL2hCVUdSVmg0QVNYbmR2a1dqVmFmUUtyL1FiN053V3VMQVE3cDgxZU5v?=
 =?utf-8?B?ZjRJcm9tSmV6MjRjbDh3SjRvV2NuWEU0dkk3Zkl5aUZZM2RmU3hlSHd3aG9D?=
 =?utf-8?B?MVJCekEyQW5JZTUyT1RyMTg1Y1RMU2FPYnQ4eEthaW9pckdmVSs4Uml3QlNp?=
 =?utf-8?B?Q2QvSUNBTmV5Y3ppVXc2NGFlaEsxMWc3SVZNS0xwcnZJb0VhWWFyZTBRNVFQ?=
 =?utf-8?B?UXJsY1RXcTdUTTh4MklPT1g4emRmMkJ0Q3ByK1p0YVNlaUdzaXhPb1IraEVY?=
 =?utf-8?B?VzByQUxkcnRzWENuTFU5SEF5ZWhxcGhhdUV6aUlhd2w1dHhWK2ZvYXVmZU5L?=
 =?utf-8?B?QjE4WHBQeHpBdTJLM01EVDBxbXlHT0l4Rnc3TEdZVFk3K0podlR6V0RERlo5?=
 =?utf-8?B?MFZNQlFwOXFodWY0aG9SQkRFZ0VYOFN5NGIweUJub3JzRTlCTkI2cGV6QTVo?=
 =?utf-8?B?UUxqUmMzTTk5RW5WczVqcTJ3SGxMeGRVYm9CbmhQZUE1eGJFVWgzQjRpSVJk?=
 =?utf-8?B?TU9ocDEzOVVvSlZkTHZpUTdIMUEvSUd5YjM0RHJDWFZaYzBUZFVTeGllSFRh?=
 =?utf-8?B?N2czVmhwRW12b01BOUxjUVRkV0E4MUdIWUxxYUUzVWdnY0xsbG9XZ0ZkUUNS?=
 =?utf-8?B?Wmdaam52dks4eUhlT0F4NUsxaW1KSjViazhDRXF4YXRzK0w0cWFkSmtGL0Fr?=
 =?utf-8?B?NWJtQWVMZWo4b2ZlQkRBL3Vma3RNcHNXemxXQzVhbFF5eWpxdVJldzgvTTFx?=
 =?utf-8?B?cnFibThIYnd3VXVaRCsrVjZKdGZwaS9nWXMzSDFjTTZ5MWRZRVJldzVZVDZq?=
 =?utf-8?B?RC9JVERndmo1THZ3ckZpWTZiVjVtRG5HN0tRczI4bTA1N3NvbFRiQT09?=
X-Exchange-RoutingPolicyChecked:
	ai9dNwpKq8JPyL87IWDx+rOnNOIuCrravIJZS8UZRdyeYuV3xEWCCq6cAStoRq0oesOZR0rXJO7wyVPP/Hn++KftFS5CM6kLZlF4kVSNrO6EpDtL7ZR6FVqrizKsZPvcoH1qMwDKk5MXZYXhOxUifJxrw+Tx1nlTxCMQxQiVOhqj+DgXNp7fQ+6reE5GN23YXusBCSRlrr+gcs7XNaAJCHDl81JvBGm/a0+OYQveBLfisSZSSxO9Ws83J3mFK0lK7eVgGan7B07UDENEOOoIT9jyMuJIvYnJtcrRbl1tPfoAEDFQbvrKBpFQ0YeOYikV7gt5GSC/zBpYd4midUQf0g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BjJdu8P5MegtoT2lcQupyniXaV8N4XbnMAp2YUp98V9dLBbRmnkkGKxYQqxTa//P64XFryae8n3Oa6tAx8Ubkvb6S9AqOKNuSDol5ZKs+Iyzj14mUDiSZ/kfC8wAXzQUSR95QJGNpwg4EAdIl5UxAYScY9kVaEWQUtYcrYYaCA3AntVaGuae85HcrtvkAPX4MJIdsQD5R+n0RtIlK1MEf+9rRN4j52p9d+xzmJVKG6WhbjJioqNwci3IgnuDKboflEBKdX1+KH4yw/9FKIcgdY/bQNL9sQuVjRuI29Wya1FBYTc5p446vBsrflKwlxmw/0aVFNVoPY94jOfxUpiWFn7T99FyyFcoU9US52ThyYdFYTjsyrWLVMrL4iOK4hjxr57V3C7CT1P5F4exYerHIQPuLx6E7zDi7VN+HVfEVS8wE+PyAdSykOH4vS1FqJWqdLbDuQ2/LjAQItJ1BAuyg8Pm1XL/VrhNEl164AnAhZO/cALF9x6zUERafIUWUSe76k+vTJfNSXhtbZD7pUZEeeOWb2LCmz/doMxxSd2rH2hEs23WzghbP2jsjKsEc29oYGhB0vn1d2EeVQOCgPa0+Oytzw4FMAJoNOXeOpax1ro=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3671cda7-2e46-4c35-07af-08de842d54de
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 13:58:56.7488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+9T+EMTYQj5EiuBU+hANRwagMc2OppOg347i/yBIAvRp2E/UA8+E4zvj5haWg+lQlG/IjmZHDVGvSXAJfJxhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4643
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603170124
X-Authority-Analysis: v=2.4 cv=LKFrgZW9 c=1 sm=1 tr=0 ts=69b95e26 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=ROK7AcxOToVZeOjc18MA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEyNCBTYWx0ZWRfX0I+gRZKyt3TS
 yAq22XrqQa/R6IFRKfeRynI7Dol4UPyBB8EVeld+owk6tV+8j4wvF3wqeQlp+Jg0szhYyRqQWe4
 TpuPPHlanLEC+ZWNwQJflzrqRD8hZ+SQcWSUktmvKjcpXbx1aR7sPCJ4FkPCNxKZUm0U341SkQL
 ib88Ycbgg8ntgmwRQBWzB5NZp+u57E2u/955dS8iIm2o5QCRrbO5yJVUSBCfwYCrvGPVzvhje5+
 HbWTBlBMTn2XT4Dxf4oYhsPYwcAlyY8nuw/8tIV4noHkeBlZEzyeSsVypBcpNVuxh622uRzR42q
 OpFHJyJLJy3mywD4rHN8P+mlEEGneIbuFAmoKnuSjuOBpzc2ZmdyK2GrmOejIH+EyuC4NXU4inK
 OiJpKeMs/Yf/WK3R/dbSr7CNpJ1yNDubmKhWcoEvQHE+X/LJ4c8Iuw39S+aq4FInPlPMmOQA2+P
 fu+PHRgGFNpwJv1P9Pg==
X-Proofpoint-GUID: LxnWP0tvjIrVCiWexfvBMChQQsq7wqmA
X-Proofpoint-ORIG-GUID: LxnWP0tvjIrVCiWexfvBMChQQsq7wqmA

On 3/17/26 7:32 AM, Breno Leitao wrote:
> Hello Tejun,
> 
> On Fri, Mar 13, 2026 at 07:57:20AM -1000, Tejun Heo wrote:
>> Hello,
>>
>> Applied 1/5. Some comments on the rest:
>>
>> - The sharding currently splits on CPU boundary, which can split SMT
>>   siblings across different pods. The worse performance on Intel compared
>>   to SMT scope may be indicating exactly this - HT siblings ending up in
>>   different pods. It'd be better to shard on core boundary so that SMT
>>   siblings always stay together.
> 
> Thank you for the insight. I'll modify the sharding to operate at the
> core boundary rather than at the SMT/thread level to ensure sibling CPUs
> remain in the same pod.
> 
>> - How was the default shard size of 8 picked? There's a tradeoff
>> between the number of kworkers created and locality. Can you also
>> report the number of kworkers for each configuration? And is there
>> data on different shard sizes? It'd be useful to see how the numbers
>> change across e.g. 4, 8, 16, 32.
> 
> The choice of 8 as the default shard size was somewhat arbitrary – it was
> selected primarily to generate initial data points.

Perhaps instead of basing the sharding on a particular number of CPUs
per shard, why not cap the total number of shards? IIUC that is the main
concern about ballooning the number of kworker threads.


> I'll run tests with different shard sizes and report the results.
> 
> I'm currently working on finding a suitable workload with minimal noise.
> Testing on real NVMe devices shows significant jitter that makes analysis
> difficult. I've also been experimenting with nullblk, but haven't had much
> success yet.
> 
> If you have any suggestions for a reliable workload or benchmark, I'd
> appreciate your input.
> 
>> - Can you also test on AMD machines? Their CCD topology (16 or 32
>> threads per LLC) would be a good data point.
> 
> Absolutely, I'll test on AMD machines as well.
> 
> Thanks,
> --breno


-- 
Chuck Lever
