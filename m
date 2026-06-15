Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8290C3F4840;
	Mon, 15 Jun 2026 14:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781532596; cv=fail; b=sbssUn8cZqyQgPdQ8c8/ef10i1r4i8O0zJ7rBUb7jcGFXjl7xEfgqOcCaQnEypKHeg8kc+Kya4zprTLfCVnyzCQqBEU0io2Dj/dvG3Nc2aV+3++8rDw8XLqoQ0lCuXZ/G9iw1KmstXuXOD8UFpsOvEClEL0Bs+2US2MVrQfyBzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781532596; c=relaxed/simple;
	bh=h4VhGB2uIEuBZWDGZfqHP2E1Wg473L6AOWt/73l2mWs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RrZwZTCrKHiGc/ELZenh6Db0gCgf95egKqWc993qf44d1+8yi4kKhI9bSZAwdBcayzmPwIdb+Fdx3EoS/2w5QmpU5STyjJz9sC81FZ6KN+xxav8c+CE/0abe93tys7Heo5tY1skWpzx1SfJ15KmVTQkMFSOEXfTU7kv8Vr7/juk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NlCT25TG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=qimFRhdd; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NlCT25TG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qimFRhdd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781532595; x=1813068595;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h4VhGB2uIEuBZWDGZfqHP2E1Wg473L6AOWt/73l2mWs=;
  b=NlCT25TG1eJSZBI5VM3aztKLYaDRfw3UNsUDQ3jAYvfMIPcE1vJRJO74
   uNLYccR11eYWZRjYRZOVIW1uwhqQbYXmYf/FxPELRq8QA2JxJbNjRPS0K
   3qhrFfYUf++eRreFlWtL4GlLk6TNZMXM6bEB1NGu0OgdDjLgONo2BWAgo
   0sucmnX+VvuvVgLt+01lbU3EylZx6cpkA/IE5VGCtHz7fueXG6VaC/Ruo
   tFcv42Z3Gqq/dydDHBWQbfUnlbwRS+7W+i1eiIsxE45mCNJC5wdk/OX8j
   OvNqS+AhoW76r/lmI3ViJNjkGKSCi5oxWoH+u8osCfqWogaimzPeUSmaT
   Q==;
X-CSE-ConnectionGUID: e5UuFPplSBylVngnKQC0Kg==
X-CSE-MsgGUID: PyJeWdcgRXaomq9jgblXjw==
X-IronPort-AV: E=Sophos;i="6.24,206,1774281600"; 
   d="scan'208";a="148824892"
Received: from mail-southcentralusazon11011031.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Jun 2026 22:09:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ntr3pT0AjD+QCHrNSOVsVoooUV+f0g4aZ63cjF3v/OHTSKqjd8PAk2RbB6ZtMJqu9W1K19kZeIodLw0p+km5ZVKuXGYicAN57DS8Z5E3Sjz6R7BezIURb6hm0lyPNWLTd+fpC6AFb8uovTOxBYOaTw7OeGbpVfHP9XKFlP9JVzWJpYfgg9QYwvbm4RlYZLhSBDQrB5iBWh1NFGuNoJp4zCF8QWNokmBMyeMfqmRwy1SPPSRxf5AL4nZONGKyzOfvsdy9CFvQQbmnXhmIE62WUM4x7lncfRN1FGldMG9QeDGMo67HnvFb4Whh06Bx3VdQwIGDLRRMrN/kKYuQFaGUYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFM43uTNNAc2hg5XElB+kVfYjZY4Fi3xyDtsw2KpG3A=;
 b=y5XlHb5/5zEBcG/N2P9RxMfyvtjCup/bWb3mPTKH3TxPfTD7Uvm6F7U+arAg8gz04EbfPl4UdHvJ9cm1EJbgGHkTKkECiUxePPRoUL3L9AIYSaL+/oI9MlTws65kruiAIJBKAP1MbWFaiLj9P458kZYDmiHu9lcCCOPsk7IkaqpI23p51WX7V5ntkqR0DwQrBi6kY014uwbeUWkiUJL9B1iZ3tsiIovtFcl0Y4xPVlEpxxpqKH7DIm2OWX0HN9KNftwgLgCtTV2YLfVvCDpqyQ0H4ZbdYx3t/0SxpaHvcJr9g14vFzkKWNC7c6OKsZJTnYvhpVxFKG34kWB0dBEtGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFM43uTNNAc2hg5XElB+kVfYjZY4Fi3xyDtsw2KpG3A=;
 b=qimFRhdd+TA+qtEiTTzdZ1Vocr1cA0lY9XfMXDv5nA8CnJcxZKj1HBoK8CWaZS4kQWCyHFD32iLh7PltROsSvJal20HbSGcuFmyyt9mPEhrTVZCN2maYN8L5cNqIxgrOFnojdRdxDbmtLaMwRrAk1Y/G4fp70sOa4pP2k2kvXhg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS1PR04MB9559.namprd04.prod.outlook.com (2603:10b6:8:21f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 14:09:46 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 14:09:46 +0000
Message-ID: <fc681903-f8cf-469e-9c11-d3a32960f9e2@wdc.com>
Date: Mon, 15 Jun 2026 16:09:38 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/6] block: split bdev_yield_claim() out of
 bdev_fput()
To: Christian Brauner <brauner@kernel.org>, Chris Mason <clm@fb.com>,
 Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>,
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
 <20260615-work-super-freeze_deny_upstream-v1-3-a6c72b840e7d@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260615-work-super-freeze_deny_upstream-v1-3-a6c72b840e7d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0181.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::8) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS1PR04MB9559:EE_
X-MS-Office365-Filtering-Correlation-Id: ccb0ba31-cb0b-4332-d9c7-08decae7c13c
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|366016|1800799024|19092799006|376014|11063799006|56012099006|6133799003|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	SFs1Y3W8mSytvat1jjHlYm8fK0gSgG2pzCn0e9B9v02r5kNvNQrMb5oBf99DRdvc6zuOsyewi7FduVRNUWigiS/hW/qei0r1mIfOLrUXAyBnLk+mvDlMwQ4ZUYV7wTACIcTumlog7axyNOCEqhcwhD9fnfqbSDppiIbDmhBSaVdZlK5Hp7EMcPKum0AiP5a/mn41Yw4ksJOU6f5m7hdNQGg6oBW0mF1j/ZFDJz6HXqIs2AW6QyhplkZchd0mXsRehds011drmdZiVR2VtnNir8de1EWYakVDA1HKbxSyzZsbT+rQi4KzQXHejwyjl9bnYDhJAaRt1alagb3n6L8VQnBuX62GBAvdLgPdOCfJa3LIxTCWMnEUA2UhWoarEFXwEy1w6rfrvWcWqgH21XsfZcq8WLj1d/jWSgY23WaaxPk2Kxd4SnNxEy2ohAwfrJ+wSjMQQjFjlzFW9VxJBuc7WmFvofn8IMq0rwBZ1kg2S5/CkBNBNPLHUJVuX1iaYS44IwHVEYSUoSAiRk2IVmjS+YvBV/HrmRSz9sgRbpx6xKPD+8/iy+I3/4lqjSHC6v4Qeo5wcT/a1TiNMIJBR5KsXdosPU3PH+qHYTWuIheBnPwn4F2FvusofydHgqYd4wjN5sTs5ifVe3H46l5Xg82CdCM/cogey2vvaQLTav5MtRePgTptd3PFrXySXHGC2c5E
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(366016)(1800799024)(19092799006)(376014)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0RRS2dWSEZ4S2RlSDF2cHVlL003cTZXWlVNd0ZtemNkbUFjRmFLUWRqcksw?=
 =?utf-8?B?S1FiWnV6MGFpQUhiTHNUZXdaNUlhWWdocUQ3bzBBTDhPTkpqMituZU4xdlJG?=
 =?utf-8?B?eTEwc1RrWHFvZGVxWGtKQXRzMnB5S1dZdFc5dmhxZFdWQ0VIY2k4OWZiMjU3?=
 =?utf-8?B?QTQ4N1hyZWJ5T3NHSjdVZUxjVXVDdTFrYmRsWXBLakFYODVGTHlBc1l4WGNo?=
 =?utf-8?B?YVQ4Z0txMnd3U09EUkdyVE53dlN0em5tVnJ1cTUxcUx3VDQvM0poaEFrS1Vk?=
 =?utf-8?B?UEVBV3RBckJHR015ZkNRdE9jOXU1bHdSdjdqclI0bDAwSEFPOEJsM1JlUWlN?=
 =?utf-8?B?eGdtZG5pWEhwZmQ2ckRLRGhjM3ZqaGlaNzBmcjg3NFZtaVJXVHZsQjBFUEZG?=
 =?utf-8?B?M1JtYm0yWDNndzArbVRtTGN6V1VFY2JieDVjYUlOTlBmQnNZMnNYdUdzMmJH?=
 =?utf-8?B?a0Q3emlkTmk2bnFhS0FIS3pvOUppV3psTUpBNmhtZ2NsWnZ2SFZtV0paWXR4?=
 =?utf-8?B?bnFwa2pHQ3BCZi9YcVlwL20yZTFBVVJGZ0daeDdGRG5LV2F5ZlljVjZIbmhC?=
 =?utf-8?B?SGtUNFBpNXpjd1FKSk5xaU4rZjhJalNyeHdGTjI1ODVzcTFaK295cStSTld6?=
 =?utf-8?B?WHd3dWNTZkwwR3hPZHh6MlhteTkrYklxZlI2U0F2ZW9rYWhBN0JwUGZrVXB6?=
 =?utf-8?B?OFFWdHVWTGF4V1dIRDkvU2NvajFaZ3pEanlVbi94SzhXNWhCR2JHYkE4UEs2?=
 =?utf-8?B?cW9rZTh6UUJDNnQ1R3BiYzZuOGVkaDZLU1NlL0cxWW42aWNkUnF2MTVaNnJt?=
 =?utf-8?B?UkZMd250NE85RDlDT2VxVlRZbEpFeC80TXdLa0daZy9uREFIMG5pc0dOK2U3?=
 =?utf-8?B?d1l1Qkx2emtCMkVLa3pJMDNNeHNaYVlnbURlbnJFdUhvZzNuRy95QUpZUzJF?=
 =?utf-8?B?V29IZ2MvV21sSUQ3aldEV2FiazNLNTFLLzVPdG1wWlNIU0Jqa0JYNVVqa2tK?=
 =?utf-8?B?SExYYTE5S0R6T0VaRnB6Q1N0REJ5ajllbnVZWTRBeHB6aHp1TTBtdjVSTFdw?=
 =?utf-8?B?K09MRFdFUzdROHFBYVYzNU9mS1VSNjhuSFRlVTF6d1l6aEUxbjcvODY0Uitu?=
 =?utf-8?B?ZGFOdUh1TDFNK3BSUFhxZkFnMzhrQXBBeEVwUklnM0t5NFlmb0V6MGJjZUg3?=
 =?utf-8?B?WCtyakZIMXJoUERFL0VCV1grREU4dzhqazlUM1pGRGJDVHFDYTlPb1J2MS9k?=
 =?utf-8?B?VG5pc25PdHBzNTRDVm5oMEk2aHA5K1JIR3ZJcVFLQzJXWWwvaGRIZk1QNzFB?=
 =?utf-8?B?c2ZhYk80TEtnNk43LzBjVnYyWGthZG0yZGRENnROc1JVblM3SGsxa2RhL0dl?=
 =?utf-8?B?aTh2b0d4OHlGYWFHckN3NzQ3N0dOelpPWXZ3cTFjYTJXQVU0cTFlb1pkaUh6?=
 =?utf-8?B?M0NHNDJjWnR2YUpaKzQrTlpuNDFPQ0RuZFdKaSt2RnNyVVFNeG1Rak81YjZ3?=
 =?utf-8?B?eVh0YnhIT1czZ3dvaVFvRzdHNTkzaTVDRzVjaFpkTXFySVpYbFpRUkNoWWhw?=
 =?utf-8?B?OVc4cVdHdzZCUVVEMjg4V2I2cngzMXk2S1p6Z1k2SG9xU0J4WnVtYVhnTEJV?=
 =?utf-8?B?cTR1MEorR2JRTVFLQzIycWRqTzkwc1gwUml5V25XZXNRc2dKSUFDWDAxRjFq?=
 =?utf-8?B?NDBjN3I1UHBVYk91UWpDRXA1MGhXQ0xrb21nbWhQRFViWUd6VXFxVFVlbEVv?=
 =?utf-8?B?alY5a29HY1diSVlZeXIrQlNNUzF6ekxadmlxbkxBM2FlQ3VKc1NJZ0ZtZWpD?=
 =?utf-8?B?RWcrZ0V4Qk1TRVNFd1B1S0xtbTlWQTBKanZudzV4NHpYbUZ5dC9sMm9zSDZa?=
 =?utf-8?B?NkZCZmFqSFJjWWJGcFptV0hpeHdPc3JrZkFNRFRVYzdlVVpELy9nUG5CaVJR?=
 =?utf-8?B?dEFJc0J4ZWR3R0J3UUl3OXNmWE9oWW84VDlmeDlyRXgxQm9RNHE5TkpURnU1?=
 =?utf-8?B?Ukl2SUVQWXBRajhBb0ZBK3dnT1gzNXFmd2g4c29Mend1dzJ4ODF1aFlja2tq?=
 =?utf-8?B?Z2NrR2Y5bXdGUnA1eE5SN3lwcVYvbDJwRzhPNnFsejR3OUl4RnNUazkrUkJD?=
 =?utf-8?B?ZkhBekF5MXlLWVl5UmE3WWtIWisyem5vOTlzSnlQZXFrUzBibCt3cXJ3MHVy?=
 =?utf-8?B?NHRZNEYyRE04ekxaWER2WTAySkZvempBNDZkNGlRVUE5dm93bnJnQmppY2ly?=
 =?utf-8?B?MkVLMms4VWFFSXhRNFhJVUg4RmYvZTR6bjZzOTEyOTFrOHhzOHNRcFVzeHBj?=
 =?utf-8?B?MVVJYkI0R2JSUDhjQm1GRnhLenBNQjZ0OG5IdHlaRlZVUnBiNUxLSjdQSXZK?=
 =?utf-8?Q?ASpiogXn/sjNdrk8LBnBtsOXvreyETEDqCgzf0tw9nqPL?=
X-MS-Exchange-AntiSpam-MessageData-1: ZL3p2Shut/Aaow==
X-Exchange-RoutingPolicyChecked:
	Emuwpl6w0K3c8AGweg4SLhx9C3Ca35lopkKPnweV7J/r4n0jc4Bq/uERfZkKx85QVwfjN2J7EFA5DhrZEU9NHbaVh6HilcadyDchkAX4lvnjvdcq882jK8S50sXKp9GumkrTm3bMxH1dvjaK5x7CxsGAATaajjXrIqrPkbsVbgfcUkwaFGwrmTsGTd1kr/reK35hUGXuZHrWhryjgAXtmgUwYMqii6MM8+2zyLmXlwlyS0sRLMlo5JXQ6tqCRTVYjDDRWCpZwalj56xNU04BES1fcoHWW8i+W6OLV5sNYq4nrYF4du5wfoYc2qWGRZektGnpMr6iQcL68ZIg9Fb/YA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ouaD8b2aM0vN8k5ByHWORij9hOdv84DxCEwBjOn47cnicCtOaBejxsyhS3leq6m3ZB4x4IVHbKzoMlFF52mirkBXCabiIZMV/BcMerreIJ2EgLw0hgkPdHdhNKEGKGHiLbIhukeR6GHjY198csJApvaAhQr1Eb0DUwyhyIbtUN6/qqmoO13WCPnusJ8KwUny45nWjX++vmYV7XD+lAyQ7XLokk0MJRRfyBEPt7+jbMZQyxdaUFtZV40aCOPosQntyYezCjDQ+C4EJ9UrfgUmO7Wm+rzw3/EzNTILmaa73bCkryKQMf12JGXrRBoPcrNThMZENwBk1q4rpyUXXQzKnNMdMH53qlDW7JDV/sxZ/ygOlhGh+iOo8ErQGNCmiGarL9qyEdyxP2UGMlN3tXhvWi1MwOVwb/4ZNbfxfhqe7SSAVPFZBdh2L2PmGrDiKQxMDAQof8NsBjAjyQv0eSL9Rhi4q+gpBmUtt9HpGDREAhNRnVMmy8P0LfoT96a7UYYDXH0q5YP+6TrehFbeL17Sk49BA3njYiyeskc+kFvrdXT9CverDFnHcWcNyBiAA32AYdFleSENYyPpf50ZlZZmfisngzAOckREDdd7MaxL+N2MVOk3CwzeFcuIx2hOPfnP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb0ba31-cb0b-4332-d9c7-08decae7c13c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 14:09:46.2921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Bhi9SdSTA4eSpJyG0IDOogEEwCGf12nj2GR4tM/767y3W99zHH9wR9EfdW8LYf0PU8YyicwNRwAvF4Q7b+lXFyXyDX7iUJ9PZ5Kzmhgizo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9559

On 6/15/26 3:18 PM, Christian Brauner wrote:
> -void bdev_fput(struct file *bdev_file)
> +void bdev_yield_claim(struct file *bdev_file)
>   {
> -	if (WARN_ON_ONCE(bdev_file->f_op != &def_blk_fops))
> -		return;
> -
>   	if (bdev_file->private_data) {
>   		struct block_device *bdev = file_bdev(bdev_file);
>   		struct gendisk *disk = bdev->bd_disk;
> @@ -1226,7 +1224,23 @@ void bdev_fput(struct file *bdev_file)
>   		bdev_file->private_data = BDEV_I(bdev_file->f_mapping->host);
>   		mutex_unlock(&disk->open_mutex);
>   	}
> +}
> +EXPORT_SYMBOL_GPL(bdev_yield_claim);

This now operates on 'bdev_file->private_data' without verifying it's a 
block-device (unlike before) and the whole function is now below the ' 
if (bdev_file->private_data) {'.

I'd negate the check and save a level of indentation.

