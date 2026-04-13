Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1261E30E84B
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 09:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776073854; cv=fail; b=fEu+8LJ+MZQ9Tfd7L9VAnTUhf5/QCvSeDjQvaNIaffYsMNaHa+llIq071+noNDpn4idupusCJ2Abqrza+MShwN+iGI0603VsbCNzz8ilQseh32PVKRhvbRDi7tUHthEXD+E8vJyjK10A4xDOj3cDo1+XyX1eWw/H4t05XYHhybw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776073854; c=relaxed/simple;
	bh=8c67BesPkhXxd4WXDUqk6YkyycK8tgLs4oOkYq59Pp4=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MmJOzZU/9KISQoxlRzMqEwFZERSxkAVKoaOTSZMmM8h6iVYxyIugNZyoYTMs8S1zUN53bt++5+QAHqQTUVofMo5c5s/NDIdkD2FoFbbfuKiK0QX5N+9zjqV3VZV2BRHgFpFN+GxpVbRR6Sp1hqGoqKJcaBnqT/7WT1zU1rraMJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nZufeoDl; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=KB4WwCoJ; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nZufeoDl";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KB4WwCoJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776073853; x=1807609853;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=8c67BesPkhXxd4WXDUqk6YkyycK8tgLs4oOkYq59Pp4=;
  b=nZufeoDlyfU7ydu3h2Zoalw8TQknl9i5i37rOX/F8vNNUaAmsSNLwmAR
   tQkYbqKR7FYszkbCvn5B4qOiCCitKsEev0tNF1F9H4oz/Wo/ZDE6Y9E8Q
   /v+CU2Rzt4kSyiYl8q+f2qEq+uJNXiKX7S05Km5gr6mEuUlU6uaRbTWT5
   o6cczKQ5DEQMuhW0DwVUYSSQ8mLuklv7kzv6sdsQWhtSe2JJe8sjG273m
   PywOZBymeX7USRtTp7g2XoeaES2SPLogOsxpwgBluh5BDCukQzNKnFuT8
   SEwWsxQ48EkyprB2NOOFEvwaFeyzhWqvkkLG/Rgq26rLLiT9RzQ1PlLBd
   g==;
X-CSE-ConnectionGUID: BJmbaliyQICq664ftgZIOQ==
X-CSE-MsgGUID: yDxe6k8fTZmAR1yl9Nt8Tw==
X-IronPort-AV: E=Sophos;i="6.23,177,1770566400"; 
   d="scan'208";a="143938484"
Received: from mail-westus3azon11011008.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.8])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2026 17:49:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lrUiFSrABZRDzLlaeHolcbaNBP2zo92bPaUnn5w3FPb+0uAfKSgyxtlv4f62P8vT0/aVlMpgKOpghlNnpahZnEzNbKV1Wjcbj9ZF0tKSsZKpIUM7JXRvTaxEp1bWMvDl1Fjq7vuChwrLaxwsBWWVYqjt2TXJe+mUuBbQWzQ2ZzlcnJTae1v4N409NZLt0s9+2VEYDZzQopDc7OJGn+vpIcD2e3LF8LpbHNFpJr1FSKT/epccuslAAyvzvqOUTnnqIVVudTt5GAcRlLi0BZb9b42sY5Zt/fml3hZYecbPz1si+T/qAyNl2ZjT2wZae/OsK/nFzVmDPzIabaTS1bc1+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8c67BesPkhXxd4WXDUqk6YkyycK8tgLs4oOkYq59Pp4=;
 b=wnuMlYhrkl7aSBGJmU8kENY7ve6BJJTgKs1UQo7UQpqS7Rqf87X0qFeP+aNyUZe7E1PelFKeLhyIid1pUonb6tMzRXVabyT4a/G4AgZnlYyC74dsg6PujbwombZ8wokzRUdWyU4pR33zgnfZXLXWCPYPDazuvx0Ohm2kKKFsXCjrBbN2UMfPVDr7qyjzVIGIKZl3sK6o+FvqU8QFuT9s2yDV/trbeU4Is2hs9uaqgM1NNVZkKWxLSQkuG9tpvmZxrGpfobsxUtqUBpJM1x28wVclpbw9dqlNQghvtrmcXZg83gmXdETkyzaMeFxgtrgA9S5bXVdwS6GD+xq7LmknNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8c67BesPkhXxd4WXDUqk6YkyycK8tgLs4oOkYq59Pp4=;
 b=KB4WwCoJgfNe5kdBpi+w+C94c+99duPjCpd2L25Q9tYCQQM5fnLRxsSOa9vuLlLGvrw4faTDMMUTYI6U0BPCkcJPZDHeTkPEVPjCIYVD0BKUxurGOuoVDWMkWQtakGypj/eXPiydE7Eq0QcnZvXtA7gftaz+K/2NXhb8pGcTEPc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by DM6PR04MB6892.namprd04.prod.outlook.com (2603:10b6:5:22b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 09:49:41 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 09:49:41 +0000
Message-ID: <b9ba7c62-8152-4d7d-857f-11b63c641f05@wdc.com>
Date: Mon, 13 Apr 2026 11:49:39 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] btrfs: replace ASSERT with proper error handling in
 stripe lookup fallback
To: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
References: <20260413065249.2320122-1-robbieko@synology.com>
 <20260413065249.2320122-5-robbieko@synology.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260413065249.2320122-5-robbieko@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0079.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::19) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|DM6PR04MB6892:EE_
X-MS-Office365-Filtering-Correlation-Id: 035cf177-139c-4ed3-13fa-08de9941fc25
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|19092799006|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7u5nT3DRCtLhvbq7OgmemhKcnveDItSwt74aUXu7mgSrvu/qwdnwdOuz/1yxV++H/7oXBT6YgfXXb/AQPwRXanwz726xM4Wbo1ZlAGc7+8ZKuI/EM+gPRJ4Q21zyKh15wWaGYrzE8rlLS8w70wdFf29J1IrLtPSapOp/uNEBoy3CJelMOwlTl2P5sKPnVVlcJ3LKwyEOzSyByPHWUyahvyRkIg1JtNHVJ2ClfrdlInegVeXcYmAd9mKfIqzBOHTeLq+D54t2edfZ24ndCGCIqarbpp3MIITm7F2RTSXysgKTz0QfWhJ88J3ZmcykULBeUSOaAGpKIGSEcm5pNp2pvu4SOB1kwYj7wBd9FJ+p0vLZCDunbPD4dfjxzYn6Q80ZETGp+IS7z0nbI0dBNB5vhZdL4MF8IJyVBIoFTKiQVcsInY1Rj/OA4yfizXljg8S3Bc2jE0aQP6Kn3kLwiLmF53i9Jf2/ECX1AHRFFmo09/Hj27BUC//NOJoQ3yQ3yTD24f6PIl1drncDHP3BRgH9nhckI7k9v9+K1CtBsuQQnjxZlT3GWWU8o4FGb7oziRxwG2CnCBCauaHLoZBxTcUZXJXvXR4qCFm/u8EnznFdeWsw24uPI7V2hPe+6OPR1JWy03DSNQwBSW4Ennlnf6pElibVO/CIjmCER2m2JDeuTN4GVuVHQf9iCAEwMoho8GbJRaqL91kBAE92MciYBDYYS0S//C4fMw0nbubhXmmA9c0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(19092799006)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkZZREtkbVlmNjU1RHBHVUprY1MzWUlxN1Y0TXpwRE10Q2FUOXgxeGk4NTBz?=
 =?utf-8?B?RzFuMlhBait0MFNFNjhCb2ZWbFFHUHV4cjVwZUR5dW12T0pVY2lHOEFlOTNo?=
 =?utf-8?B?MnZIK29WZG5Vd0pZblMwb1JWV0UvL2gzcmlJZmUxZW5JWnpBYy9kRVU0Vlhh?=
 =?utf-8?B?TTdsUk9TR2ZUN051dEFYOVhIWjFCUHF4SjlJaVdDKzk5WlZuN1c5S0pmZjQ0?=
 =?utf-8?B?bDNLMTVGNjhqODVvUDc1V1NTMjEvNHdaTWoxMnlTR0k1MUR2cDJDUzNmaGFH?=
 =?utf-8?B?TTdnclREb1B2eURGMEtkNzVrNk92eS9TTUFoYXpMYzdpUFdZWmtyVVhkLzBi?=
 =?utf-8?B?YVN4M2syb3RDSzlPdTBWenJwSllZekFRWWgrckR4YjhUZ2RhREs2enpzK1ZY?=
 =?utf-8?B?ZmxjWGtzdHpjRkRhVzhneW9ROENuQzd1RWdCUTJHeVZ5NnVTaEE2SEVmQ0cr?=
 =?utf-8?B?VGFIZnFSWUc2Q2Z6VmM5eDZJaWFOL21WZHpVbmVVV1JhTXRpeEk2cHQwbWJT?=
 =?utf-8?B?VlR3R3N2Q2paTjA0bG1aa09FUE12S0RHMWhHUldZTUo4dHlMSFNEWnl6VHJ6?=
 =?utf-8?B?bVlBNks2aEpBVTB6VzNId0g2MXZJWjk0SFllK2xWSDJjVndoVzNrNDlXK2Np?=
 =?utf-8?B?ZkFhdFFTVVZaYlVicUkxcTZjbk1aMzI2VkdKLzBMUzlkeTNHRzBTMlJoTzV1?=
 =?utf-8?B?dkVuMitFc0JRZzFaZ0dESkowMEtBZDJQWEU5Qk81YW1SVENzV0x0Q1RsUS85?=
 =?utf-8?B?VmJKOThUR2J6ekowUVhlRnhBQ0REVUhLYVBOWGlSWXhXL09pV3AwM2JiQ28w?=
 =?utf-8?B?OUJXNkpLeXFrbldEdng2S0ZleEYwMzJ4N0Mxc2YybHcvYXlESkRXRmZyNCt0?=
 =?utf-8?B?aGRCV1JrcVJ0bTVwR1hjQTE4R1E4dUpqZG44UzFPaSsweWhXdGlHMUNQNzhm?=
 =?utf-8?B?ZjBMV1hQUGkvMFRsTHdnMTVKVmpsSnIxTUU4M2g4RGhKajQ2Z2ZxZ2N3YjFZ?=
 =?utf-8?B?K3ZQU3cvK1FYNmhLMG5VeVJyNFRtWDJMdXpaaUF6RjNMbUZXeVVHMUpnQUpv?=
 =?utf-8?B?aExwRjdKa01na1VqZVBvYlhPcFpxN0JlV2lCQlFTOFhMRjVzeGN3V2ZsMUNM?=
 =?utf-8?B?RDlkS01Wa1V1WWZZa2FlM3UvVlZmNkZRNnZ4MEF0SGR1VVZKNzZ4SWZ6UG9i?=
 =?utf-8?B?bE1Va1dDazV2SWhmYVAwTHVwcGNER0ZJVk9JSkJBWFR2TVpIWVMvNy9aNEhR?=
 =?utf-8?B?QmozUTdZYzJMa1F6cEtGUlEzUVpHdlBEb1A0UzhBcXo4TTg1MzV6OHBRT0g4?=
 =?utf-8?B?Uzg3YlFYK1VISVdyVUdYalphN1FjMEZiWnhFNTcwQ0pHUW5RbThTaVgyK05B?=
 =?utf-8?B?VVQyNTZTbFo4U3BORHc3cVdqVWNkbHcxck5TVGlFMkVjYlhydkNmcjduR2RB?=
 =?utf-8?B?YUM4SnN5OWpETHRsOC93Z0lkdFMyc1JRN3NabENPamFvNkFKalY0aWhmOVlD?=
 =?utf-8?B?cXNkdjVZenlGM3dWamtVN2o3dFlYeE1BbnduNkJPaWhVWWZqanA4emhPbWw0?=
 =?utf-8?B?YVQzSFV5VkhEM0ttemlHRWtLVjJVYVB3TzFnWUR3OEpWdC9NME1GNUdQTUNX?=
 =?utf-8?B?WDBtUkVUVVpEbTM4N3NwODl2VEVFQnNUdUpISXg4QUpia1ZNemR2L2xac0dH?=
 =?utf-8?B?bkV0Ylc5QWZ5QWlLZWJ4eXMvRitTa0NZOHpNaUxTRnFZRW5tNVZIazZDaU9M?=
 =?utf-8?B?YnJaUENHcmVZZzdlbE9RVEtaNW83eTZFcHk1d3JtMEdYcFVvWDNUSHAxZmhs?=
 =?utf-8?B?T1Q0TVhNSTNNMUFLRjdCT3VMZlIrUDY2S2FOVFkvYjVZeGJ5K3FGRkxqLzIw?=
 =?utf-8?B?RDZUQ0VzZXRCNUlPckhzY2h5MmZqTHBZcHpSR0VRcldkeXdrdjUyVmdJK3Y3?=
 =?utf-8?B?N2xUNyt4cy9VaTNJbENucmlKcXNZZ1ZtVGFhQWNhSHZlazV3akdVSWRKc1px?=
 =?utf-8?B?VWFsbmwzVENwbElSODBpYVNtZ3hjMDc5QkNHTm9DZldVRXB4SkFIRUNpK252?=
 =?utf-8?B?VEtLQmFqOFJ1dHV2amYvUnZUcGxqaUZab1IvOWlFblRMc2NIMmxVc2R6L0Rw?=
 =?utf-8?B?N016UmpOS3BlVDJFUnBJWDBSYVY2dkl3dGVydFliR0xpalI1R0JRZk9QdUhS?=
 =?utf-8?B?Rm02UGZncUZqOFdJWUYrZDA0RmRSSlcyMzdpQTByVGR4QXdhRE0zdTFtTGFr?=
 =?utf-8?B?VmJ4TFhpWWdvY3BWQVRtc1ZtUFVJZ0hhdlNxaDlVQXU5SlBraytNZnZLdG9O?=
 =?utf-8?B?cXlicU5uby90WXYybWgxcVdaYW1BMHBITjRKbnVCaGp0bDJCMlRqZ3pOeWZW?=
 =?utf-8?Q?CQxBu0MDwpRFznCHfKal9vGY5TfGTb6zyoZiJ5PF8OkXr?=
X-MS-Exchange-AntiSpam-MessageData-1: 7guJeEIBP20Nvs3LDHslNqBVzlpgTuk2994=
X-Exchange-RoutingPolicyChecked:
	eFXa7MG6TsxnEla/qy+iUSvMz25KRWM1EnZpFgtwCCZNgozoULWVRhExZ45OSVj+bYHznY8BDuS2zIE4CQeTDSdCZ8l4B9nVGpZNfcj5bXFDJWpZh2Ti2j2MkHQF9LyIPPPa05XwfOb/hkGBGYmZpmHGCXkequKuB0IT5zxciBk/1MnCnEy6AJHxyzYOAo++a6op/Ue2jlEUoC3TdtSwe/45+XV3vtD+Y6GFkXLufgdRtRF/uukMXAylzkcYDrNZPY3bTcdM2OZlVZHUGJSHY6DDovDK0c4XVADIwp2GPtX4yM8fhoG+20R1mmZ182a333a2cL5/xv2i4U3et1QX9w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NjKj2i0eS+rKZoyybcSJ70vgTE0ROX/xDWw3ir7oJQtXn3SvIy09K/0lEunzwzqIZ3EQnMm+SeVmkSn7b41iI7zcwC0s0wyUjsa9JOrRa+h8hz6qFhggHMi0hdqhZaeJRqPsPPtWX+7a/QisNlE0PXK90w3K4XAN4vAMZwvxI+jaPA2AX+DTEBfxKMb6oTcACFJqQtYewIy6oPwTsB0c/qurWHj06/mZTu6YT5wpY1tw9/zQoyHXouFOUnidWiFW21i9mLx81SlWUxBxcadpvTfx7Z9DIYW6z5ahIU7CwzG0VfGPFxt9hn8w9b7HtkWY9Ai/uhfMimUsxKWm6YWQI/NccfunnmCdcmJa/xcsQYUKeY1Wc5E2wZtnQ7qWCI1qu3cMcW8ThWWmYYU6RjIEpq/zKjSpCPBtxb0tfDdBEcf25OxJiiy0+XpUWshUtzNIZhJf/XbY4sF9keXD84nQSMBkTknBILRuha32zO47ez4KbFItfN2879vTsJP5pWlIKHFykb8+8qlfX9Gb5ShknKmcNboMHHWW9A3piL1NA8YePs9cF5UIfkcKJHdz/VHV0WCDD+zeieRx4LajugSFISrRsm98DPk1g3+htNIhPkfcz1wiZWx88pmuwrb7Fwru
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 035cf177-139c-4ed3-13fa-08de9941fc25
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 09:49:41.7352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CABlITx/wBvtRqgMJLNvdmFjVuZupG3Hbk8cn0UQcA979SIb3ZaFZT6CCfdRKl2sObTXTGQYVTdAq237i3YF//3l/ehOt9//l88whkcSEBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6892

Not sure if ENOENT is the correct error here, wouldn't EUCLEAN fit better?




