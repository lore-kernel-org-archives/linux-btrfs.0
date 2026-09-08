Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D3F560ADD
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 14:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788876918; cv=fail; b=mc6e4ZU/F65ZYX9MeOiNKNzTTmypqjvt8he2/JofotEMn88gJL5PNppseMK33VTuZ8W6T2MtkDPb0m53ZHYXgJMFCEa2rTUjB/gmo1ktDhUq4KuKSudzLVC+kcPL9+EsevLM/Mt1JexaaxNquLfUqCIbEIa1giSQGTGvAGFaKOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788876918; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C7j5O4CGY3CbJAj3yunoEElhHoR46xIKLv+t1fOB+GoPEQKMyJa1KBEl7qUKoDSg3LFYMBh/4Lg2alfHX35rl2CEWW6xIpRUn1wOKDpghIX7DSIA0QqPIlkAAfVaBGmq9Acc7yblBkA2pQjwzvMo1be89koZ47Fy1KgFuTyiv/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KIC7Jtbn; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=GhCD0yHr; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KIC7Jtbn";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="GhCD0yHr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788876910; x=1820412910;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=KIC7Jtbn2cX3wvU7Spzm/eW0GiBedh8uM59uQLN/LiZO6ieqpPs5GWPV
   UF0jeSxKI9qxqc822Ks+Yxo+yZr+pPdnTMn31GWwTS3tKETBU5AgaHPhZ
   6PHE5aUuPYpS4o3/RyyjpiVbmh79uw8Mn9n1jr60LbqDGrV5bP5UEQRya
   X6qaipgPTv8Xi/G9CVkGS7uLnlcupkkCvE2K8UwdIA/leZe24OtH1wU6s
   EkEshrup+wC7wEeeQdKagiWacEdEdJhxQl7sGma6Cp4+j5imKu21CkY5k
   QyQT+gWcXuiDTuyU7YGUtT867ThVXAiP1kjwgfEGBSx409wct9tl1UV51
   Q==;
X-CSE-ConnectionGUID: qIQTOpsYRdiA2V0LcjjgWA==
X-CSE-MsgGUID: 9+vTQL6tQoCjR2EslhBYng==
X-IronPort-AV: E=Sophos;i="6.25,269,1779120000"; 
   d="scan'208";a="156120185"
Received: from mail-northcentralusazon11010001.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.1])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Sep 2026 22:15:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EJomLotKi8UnG6fmKs6OLvYQ6bZN2jM6B59qyeAhmMBr2AbJF/ZDx05Ecw2HrptC1iUykXNnCfzZzcd7bBTx0HsaLCMAA3oH8WsR2STX9Ut1Hf9N854aqYjDTOqxmkOGUqH59NTGWrXFpSNAvfRMDFLtZzrlHOCRGnQzXKT6tY15nRQivHnZBQ9RGPxGC8QPsIJYqZQ7dMVd6t9wTSRGnSXwU+Qar+Q2BLC81b5GpCCeuq3DtK2hOf1gkRH8/jX5Su5akf17W6t2aunYvYIQjUQW39RvjrQ2YfjJvcEv2H2dl+JBgVi7QUMfPz3Xz6qbYnI4OZo+9OsQ9ID0LamFiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=JyVtiSAgeh5bzY811qIqMmeFl+AFfe0ZlWSzMhPNla1ZqGbdCFiRWVG4C7th6o8uav6b181z/cRrvSxKMMIRZNrXOiKdadyFDeAzTIomxBJ73rPw3UGBRjxIGEsIGXbzi6xAt4clp8taOdT/HusDQsOwapcguZC//jrCb3Lf57bjB2ErQht3DcuQlJFzjRhqN29Xb2230c6FCJZv7EhvqHaO1P57Sss0kd53SMVFq+M9Df+28YDtqbH+wy+bN3N6Jz4jc+jA9a6ypvb2iZizfp+XESpuWRuI/YssIj6s6wa2XplkLfPtfNv6UnhhrdI5HyO0iDXKYnNQiePGY1/tKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=GhCD0yHrQwwF2jpQRPZqbl/4eY/BRS7MjB4IQxx9VbxZPSsQHur4ygudAJCs2HvJWJxHMylSHlxtUkjwmIsgL0UTijRKT7AYazsyCdmgRpwlWua6AoG7opv+Nhau19tQYBPQlUPefbvsRXC2NePFL6rwVflIlvGhkQCqjHRkkEM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA0PR04MB7164.namprd04.prod.outlook.com (2603:10b6:806:e2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 14:14:59 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 14:14:59 +0000
Message-ID: <bc298b64-9278-4935-929a-833a06f0087e@wdc.com>
Date: Tue, 8 Sep 2026 16:14:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] btrfs-progs: check: use correct generation when -r
 option is provided
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1788743334.git.wqu@suse.com>
 <17a30897f8886c136ea0597b747f8d3b2adfa6aa.1788743334.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <17a30897f8886c136ea0597b747f8d3b2adfa6aa.1788743334.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0120.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::8) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA0PR04MB7164:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b2d3db5-494c-4c13-2ada-08df0db390ca
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|19092799006|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 fPxAygSbhRJXgrEMgGngis5XbqUovAy/r9B5rV7jiMuW+6HGDD8T9ovgqPZuDxrosClCkDw8QkBuIRplhTx2elHtVk6Qc8FWxxM6lWm4UsyFHvU2VYXZWIKKSPXLjfESEQIRwqBLrDxmT428iVHBDV5itGnrZ0AlqA7DtlNxNbeXK9wtc/DO3Tzgyv4sJ66EVu1PwUjllornoWVRS1Z58RnUQLcmPy3lUXHJ2ogsMCVACqlU6oBQxxkJon3Re9u1UksbWduHRwcWTVTybMCGLF/bHMUTn09YvEIkyz9OhJSwGBv9fuh/pTQ1obxYeB1/f7cqje4Sfr8OxB0L+hQsKWLQsaC5owKlUHa9+Q0PY62dQfd0EHAEysdO+LbhHGqBVff5MoL5z5DLH+kJkkvKukTY4GdiuGSt2P0ldVT5p2frxCZchYSHQIHhbwNm2QV8J1T1orn/36kXXNtc4Z6Jcf6YnRE+zp0skDF075E+giyHoWImYAOMAY+sGz/hJNF0OPKeibWJVaXbEdzvmqdybD7Vjub2vZIG40C440XqeRVSrMokQLeLHz032cTR1qOSrVAagFY/9/US2QQztqyK4n3h0p98Y340m+Zz3xSkaC98DM+yA0ckDcUZs8YqpGVPn/QTcM5GBVvn7pSH9NmvdqA3hcODMBw6f+yN87UV3Eg=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(19092799006)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?K3c2RG9CYXNhK0VqeUNBSzBxRUg2YlJUaHI0SEx3U1dLaXdtbkF6amlGQjZO?=
 =?utf-8?B?UHJyaVkzTEcyTURFcHg5YmhYVFd0NkNQbndVMXViaU1zdEpvSEdaazRCajNB?=
 =?utf-8?B?bXlQeHZ4THV3WUpDVHBwK2dhVDV6bEpZNWs2ZmhoNEtBdkRRZ0tya3kxY2wv?=
 =?utf-8?B?dzBBL2E1R2hHd3poK3pUUFFNdFFqTzMxQkhhRDIvVy9CejhrSElQODFOM0JC?=
 =?utf-8?B?Vy9vYkdGWXV2OTJmall2emRhWGJFMWR6TTVHRHRHZmVUQ2hsQVdBeWZ5RTBp?=
 =?utf-8?B?L3pqWXMxbS85cGhIdnA0TnhvMC92SG9MN1ZrT04yKzB5TFZrR3JFWENwQ25F?=
 =?utf-8?B?d21qU1l1TkZMd083bW51bjQ1Q1ZWczhTUk9SYUZ5cldqQTY5bVdKZk1MOGJa?=
 =?utf-8?B?UGUzL2EzM2o4cXFXazdoZkZaQXFOS0lMR2NTdjJBaE9MVUZzcXpHVDkrQjFL?=
 =?utf-8?B?OTZaYllRZFAwYkJlMHpVbHNxUXpCc0V2SXUrZmRpZGJpa2cwUDZJeUhqWGs0?=
 =?utf-8?B?QkNoQ1E0aFYxWVRLSEtIK3l6RzVjZG8zdmdZV2NNUTB3aUluR3RKR1RCbEYy?=
 =?utf-8?B?ektSK3poWjA5N2RxdzRqMERXenZ1TzErRlFKektCYVBEbnJVOEJjSGllQ01i?=
 =?utf-8?B?TUtZMHcwc01POTM3eW96N1k4NVg0RGdobllnMUppWVB0bTFmSEJrMjhRdith?=
 =?utf-8?B?M0hhOURNYzhsMHczZXE0R08xRGxHU1lqS1JXcVBZZVlZSG5WTXcyMXhPNkpZ?=
 =?utf-8?B?Z1BMa0xQcE9uNHlKUkNWT0FFVUcxekFHTC9OZ3BHbER6d0pFL0h0QURRYSty?=
 =?utf-8?B?cFZKdUdYc0ZWM2tzZnl5UlFod2JLNzJzaWx1dFFKMU94Y2NBRjRyUHJacDM2?=
 =?utf-8?B?QTM4Z2Z2OCtDWExSVzhhcXNOa0JxREZoRUM0c1lZZURKNHVTWFRNbGtXcEpZ?=
 =?utf-8?B?NlpTdWZBU1lNQS9sOXE5SGxNMTl2THhQUmpiWVhrSVJ2emY5ckM0bDlUT0Mw?=
 =?utf-8?B?WjB5eXEyVjdtWDJaTWZxOFFGZnFoRXBxWTRRdEZqYm5wNW4zQzhsNlJ0WVRT?=
 =?utf-8?B?d2tvQTRYQkE1cC9BcnJpTFFGb0M0ZC9jYi9PYVJWakVGTEQwWkpBRFZyTWlB?=
 =?utf-8?B?UXMzZXYwYm00azYzN2tZamI3NC80N3hGcXd6M1lMRzBjRFdIcUhWaTdNVWxD?=
 =?utf-8?B?WDZUNjl4azJFSkhWaTVtcWN3cHRnYS9sbGtzQUNuMFJlZnNKOW51R2ZIbEV3?=
 =?utf-8?B?c29qUWozTmREbnhPUFlacWdGdG9FZFhjblpmd0cyVTN5TDh6Q3haN01IK3Vp?=
 =?utf-8?B?bHN1ZHBTSVhpNEZORjU3cTdLVHpuUk9LNWNFbHBac3F2bmN6YnUvM3gzUkZG?=
 =?utf-8?B?MS8rWjl0a3RTOENhTHRjWVdGMzZKU05Fd09tNkVGbHMxYlhVbWdnNmdzMW5w?=
 =?utf-8?B?M0hZNklycTVObERFS1gyUlY4QTg3SnFLa1ZsNm1WWkxoUDYva2hjN0R6bExi?=
 =?utf-8?B?d2EwcDNBNlJtNUpIdWlZMzJRclNVdlc5MEZiYXlVQm1yMEQwM1NVWXFzTlEy?=
 =?utf-8?B?WS94Mk1XV25pOVVCNCtwa0wwUUVTWGFBMDhtRkhHaDErM0I1NXBTWEJ3Q2R3?=
 =?utf-8?B?R1ZiYkVUSTNnVWhmMlZSdURrc0FRYUJteHU3bG9IRTg5WnE3NFNwbkxkVEox?=
 =?utf-8?B?eUF6TmVZN3Y5bWdIMHJ3Vm5zTWhCRDhrOXFYbmdGbEFvZTZBQVBQT2VhYnhI?=
 =?utf-8?B?TDN1ekw1bjJPZUg0VmMwTGpsNW9MT3VtQUJLOFg3eFpmQk1KMG8ya1VHVE42?=
 =?utf-8?B?VU9PRk9mVmNhcjN4d1c2SVBhSGRBTFF0TDJpT09WVU9IOFFqandNZ0Z1VzNZ?=
 =?utf-8?B?WHFGODN3V3Q0cmw1dk9qa3dzK0J1ck9MODBpL0J5SlZCRVZub1F4MDcveWth?=
 =?utf-8?B?WHlkbG9iRlpHdGpENExvN3dtREVrdVA3SDRpakFnZ1FRZ3VFV0Y1MmZiaXRG?=
 =?utf-8?B?L1RSMTlENnhiZExDdmZIb3pZT3NqQlZEU3ZGbVRXWmhEemsrT1I5VE04ajll?=
 =?utf-8?B?TDU1YXdmZW5RUXJwR1RFQml3UHZJTksrTHBrQnFWK3h2dGc2S0tVcGVHMTZ3?=
 =?utf-8?B?SXhoOHVINkU1cGNQL0YzS2NFc3pOMkZZZTJtOER5ZHViY1JaQ1Bsc0hhaGpv?=
 =?utf-8?B?dEhTdnAwbklDS3RSS0xhMElZTHlBMmtlbjcvZGFaeE5la3ZUblVnOGZ3dGkz?=
 =?utf-8?B?WkhlNGcxaEdkVzNwTy9mOTFDVTA5OFViS1pJSWE1M09OdklDOGZBOVU2TW8w?=
 =?utf-8?B?enJFMWgzT3NML1Vjc2FabDV1aWdvWFlvLy9zUktKVzRlNTV0TkVMd0xZMkdn?=
 =?utf-8?Q?y8P1gJkCHNJetS4U=3D?=
X-Exchange-RoutingPolicyChecked:
	0sQmysEPPUBWiDxzZNCRfRv3qkPsBaKQhntedJLCVwlHr8i44vC++/cRGcW901cbj044w5iL/FyOC0xjCI7fqO1Aez8XAqSNU6ZYoPbFlgOVzt4Ga889pEED8JNe/Jy/hkbPNPVS9EQ1M6tLVE1F2bogI7XSlpD9FAV7vzVhJlWqNUqVF11kpOZP0vpwAJ+iS75I3NymeQyyI4kOYiyi2Ctn7kygM8cFz8enRRe8s6tbpbkpZ/ykUBVVe1X7FLOw8x7iRm2WyQxaV6SsBECPviVsVUVNw6Q08j4I/jks5Hda5ub2Xgncs2sSurTbe7CnGRj0UWFuDANovcQ3E6MCig==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sTdNyyhujkXHQDxPCBlVJYkIGrs4Y0tySRtfyy6MIoyKtTUoW80o3U9O2OyZ0ZpHyWJkfWPmSk3642ZSNbNfK/RXxr2S2NyNVg3P2ILIMUDMKNV3AQ6tMmpcW1c94VCxA3eILOL0yBRWnCAP1OnrNE126UoLZMt2JzUEru9UFBs3Qfuhdff/hH8yyU2LUZZh/ve86Ku+7tMFrJmHi0ii3cgQNAdXbh2k0OkzoGPdWLOZKc5sWZDEWdNULP91S1k3j/Tj+Jk6t63ClTQriZcuWg715/dsbLNnMp2CIz3G6JTCETTJKUrBjYK2UQpEMgyd1HYpcDxs57d/+kzdxTvOYClWcxG2wVcTN2ou5zOy90NqTrI4uaOGGYkQmeYSJe9sE8GfRV6QhXTeOzGdUxhbg87QpRL8BgOBfYhJ9FrZ3W1H9GW3COv3dsPwX/JetsgNyrNy84YciNBVkJcOAiQ8kMbhAQT3fJ9s0JhvzIaCy7i7kpJiQDjNTvPdC9Y/znXiucrKLdr5KdGjq5Hy5O5qJYyq0DxCstGOm/4wP6lL/S2oQxwW5QgEMjQ9PZo2f7mQzfZAbw65OmBTmVWwTm0kTR03nbBE50Ndy0kNbyqNh3R5OtWIhhY6WuZRiU7RDaFI
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b2d3db5-494c-4c13-2ada-08df0db390ca
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 14:14:59.2203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iym5loxQFNF5/4g8XA0znJPu/NHv6BMdwJdlTfp11jeMIQfovsAChdQT+w7xQ9tlpYMa2cAWRUJtRtaZ8+nLleuzrNvUFm/kMPX9rkuJpxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7164

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

