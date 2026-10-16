Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73C9317166
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 07:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135464; cv=fail; b=REsK68xQhjwCBukqllJ8G9V49vs6Gw/hE7iCYjeCUg2JVfBjGu76oHO+HKtrPV1qtxa28kNfmzF5wIf8N+829jwDQIsx8cAHc/hrVfjP3KsiUg/ESQlcquijQiLv+jUUc03tjM8d4LdP9QmdjeanzBkyxtexcl6Xhx0Dahg48CY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135464; c=relaxed/simple;
	bh=pmx7aEDfiEJjNNl0DVVtAJ4BlRbD+sIN3Arj07WxZgA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DP5IvqCmfJf2aomdbufuBUl6K3sSnbWeyHS2A65YOWJa1WurkJVhvu5Byk7+xIlWZ7iMV+feCSgO6M1n95dFB5R7blGDsl7GAA4v6me3ZGwUBHLdJQf3QqzogWyM2X8I2JqUGyKFF9pGsdbQLcc/DcxTSJWeaVnKs51bBwXv2Lo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jG0jSvFv; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=AoRjdL70; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jG0jSvFv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AoRjdL70"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792135469; x=1823671469;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pmx7aEDfiEJjNNl0DVVtAJ4BlRbD+sIN3Arj07WxZgA=;
  b=jG0jSvFvtwbYu8AdnREdlR0odfSzXdMy0gFRJyUaK+k/cnVCfoGCKRFB
   KihRZKztbvSD5hWMH7ofOylYdR3P1V7r4+gXJ1gX3/phVejp7vSmPS/IH
   7MyycDrc+QnJ1edeLSOyumMNv1Xv5rTj+eRQGNusfMHPxHoLSgn0nvspb
   JJjkBmA9k6nEUpfCYPw6DxzhGD99xtRbXY9vdi4hsg1rHQsI3lAvLXDvi
   +KjWClXdxOuwCnvaQH1RaZZclJIr4fqp8qSzl/V/L4Xu8Trm1nwqD4F26
   7hQvFoD+/Ntq2o49tf2J/zjyrly6ooHocihXnGtmW5JY8C/30bTKHszQw
   Q==;
X-CSE-ConnectionGUID: 9CMo+ACATyqSH3HDDcxF+w==
X-CSE-MsgGUID: aBZHs0GcQHWcxlT+K3thdw==
X-IronPort-AV: E=Sophos;i="6.27,161,1786982400"; 
   d="scan'208";a="158134368"
Received: from mail-eastusazon11011065.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.65])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Oct 2026 15:24:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hSbcr2PXXu7pxAqg8R++M+uVrl5rEBMj/xoFbLXqO2JohVqCv0dzU7bt1TOpKDbIecWsYefsYurJLDVWnOoIBUq9F1YkiNtNfGsAFw/Vds1/NZNGrMhW0CqwZZ+0GxvxGG5Bjr7SNvYg0/QfVh7dglG0hXRtLOmidNosGDz9rqwBiF3ckY+qLLvasz8Z+xvI1Z4osphBABQ4xnNYS1RDRLTYxa3dxzcm1eV8tFmM6CJDzOBJLv9JqoQILVc9Tz1hNXFYn4RAwptP2WfMYbWe0E8gv2YdSGB5RMkPiSlDA/rFAaS+Q+efxUIXl2bAHNK4IHY1L3njW6bWVXSc9PdD/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R93R7jp7oFAHMEuhGWVY31rpirwRmucYt/1Bf3zxLPc=;
 b=qdt3fAWOoxUilA9RG7EYdCCIFsrko+hl2UiwXPzkYMCfo685aP1MuhtfOKvpq7YErLmtU0X3UTO+v8W7uSlD/Z+1hcUTWV6y+4L0sWyeL6hN+IYUlbEKvPYZOlEX/SE8yNLiC59giDqbf6B2F9FkTnjGEQULjdFWdc0WJP+hv4cQpU7To9D8lXoGmecvz85uv+6ob1fTTtiS3HG+O7VlRcNMWeLntbUfbKCFNdW3k+w8nmyOaV6s3FfAb1drexDEhQdqtfyK91tQ4c9vIVvLgSJoJmkOwtx+DfmaPVl8t7qvQVaaN7hJT8LsgqVVgvSCIBccoNsHAjhqW+ro+PgrVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R93R7jp7oFAHMEuhGWVY31rpirwRmucYt/1Bf3zxLPc=;
 b=AoRjdL70SmwoHyxN00nJrOeqh6olTuHWIacb0znKCXnNPF+vwZy6WQcIFUX9F81yH9l43BjlNDU7xecgZbsJWqIxEwijAsrm9vFj7lcCJNS4OsBbebrstwkUpR/rw7bMgHSmQi4w6eqTMKUrcl0n/TWv5kZbL+zZALy2jvwsHLQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7887.namprd04.prod.outlook.com (2603:10b6:a03:304::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.15; Fri, 16 Oct
 2026 07:24:12 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 07:24:12 +0000
Message-ID: <bcd570d0-898c-4b91-9146-f4cf3057916c@wdc.com>
Date: Fri, 16 Oct 2026 09:24:08 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] btrfs: zoned: don't count in-flight data as
 available in statfs
To: Naohiro Aota <Naohiro.Aota@wdc.com>, linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, Damien Le Moal
 <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
 <20261014120353.757931-3-johannes.thumshirn@wdc.com>
 <DM62IP78U8F2.SBLRTEQNLPQ6@wdc.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <DM62IP78U8F2.SBLRTEQNLPQ6@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0328.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:eb::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7887:EE_
X-MS-Office365-Filtering-Correlation-Id: a536646c-0240-42a8-dafa-08df2b5679c0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|10070799003|376014|1800799024|23010399003|10067099003|22082099003|18002099003|4143699003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Bj1iIBAZM+XNzDuB6zwLGo2/+wYHJ7LP3rkuMj9huv76aOOp18E3QVhg3iI3sjrMzuuakIIJCa9ijn0VE6lY1PNIwj36QhUzfPtpUUqI/DGS6RN0ZXBTZCarmtbdgb2YGyBDIFeV7Gr/1qDrysSu64C3qd8ESz4+YC+4GScA054ck9Ew5WmctYORnmJxiXEbIdVMPBM7BV4J2jMknuV+l+KWkDYrOBNd8BckoLt57JzJrfhoTn30xqzxoR0721PE+9VxyTxMr1pvu8/pQqq+zkeZmcCMeHG1qSlwd6nYhMd5wrmIG3T2eiiEjMaM9UrJahBYb8+P8dWvhHzXyMQ2hm9f8Rd1vNEvMzvpc4BfE/zlh6x9e5aLm5O6AY/rV5uVx/e0Bh64TRsYxGgU74W/wgpo1b8yXsH1aGHV1WPkokgaqlATcwSL2fKxGFdLClZ+Kl1BRSWiTHC2owMFmqgoKfMgJpGCC2Y2TpzdJyWwqUR1mr0T5Vgb5FbxbN5r070gwi7ktC/G9ZZkiJZzNbYbnM6joJ8J5fi6f3IOAmOd27eyQSB3aVVuTQOvut14xzj1lkKpzhOeDrazdr6Uk3o8ghV5asaK4Ga26w+ctmjstcoize3jq7QtEI1lVC7I2T3b42ZOJpdsGWUxKdfgW5I1NzpyvjwkQRMNWF+jaPa9ckw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(10070799003)(376014)(1800799024)(23010399003)(10067099003)(22082099003)(18002099003)(4143699003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1dDbTdHaGp1ZjMrdlQ3L2IwYU5Gb0lKMXFwMlNVRDBLUThLWWZXSUh2WGhU?=
 =?utf-8?B?WUxpNnJ2RnFsSjZGNkVrdjBNQUthU2NlUTN4c2FZYXloN0oxajN5T3kzS2VQ?=
 =?utf-8?B?YVN3ZmptWTE5ZDFsSlFRTGl2RVE3VGZFaWNmK0JSK01pelVUbE9WTEZsYTdm?=
 =?utf-8?B?SHhNN1IzVllOMGh1T3A3WW1jWVlIVEpxb1dXdDhZM2RMMXp3VGFPVDV1ekRO?=
 =?utf-8?B?Sjd3K0Y4SzNDRGk2WXlmamZqMFRydlBwcHdoV0NOZmQ4S3VTZ1ZaQTFLTHVa?=
 =?utf-8?B?VDBqd08vV0IvaU5pMVYxdHlENjRlNC9lbSt5N2tEM3FkRGZpVjlLemtqcENx?=
 =?utf-8?B?dm8xTU12MHN5YUJGYm1xRGlNOXczSGd3MGlhaU5kRnVGdEZ2V3RuTTJ0QW5w?=
 =?utf-8?B?SVlFTUFlUnF6SEpJbTBhNDNIajJkaXljTWRuVXRJYjViWUZpTkpxWEtpK0E0?=
 =?utf-8?B?Qmc4YnY1elYxZW9PcFpucFFFQzR4VG9zQXdOdWRrc1ZvZ0U2MWVxTWkvRHJZ?=
 =?utf-8?B?ak5vQ2U2TXVXd3dnMTZkRkJmOXl5QmMvN0t0dEVLUDhBMHRiTnJNbVZjdXhl?=
 =?utf-8?B?eUdtVDlqb3VCQ2UxeU1JTUdGR1NaUXVSQ2xkc1Z5bzBMLzdqUEJQUEZNMVBh?=
 =?utf-8?B?Vk01blM2UVZEMTBCcVVpMjArSERkVWgxMHJDeWRMUityQnkyWTBIY21xeHM0?=
 =?utf-8?B?aXpyanlaVm4zT3NzdFE5Y2dmdnloaDNPNHBKOTVRYVFVQWdKWGkzaXhLT2U1?=
 =?utf-8?B?S2hmSHp0c3ZKcDhGbFJSMVF3Z2FNYUdTakVzbWJNcWRFR05mOFlweVpWTlh1?=
 =?utf-8?B?MjJVSUE3OFFLcHkwYWtkUzRRY3FOMXEyQXc5SEJTcUpRTnJDNEpxK1NQcnJE?=
 =?utf-8?B?aC9KTzd2YWdhejNpcDIrcXBFSHRYQ1I4YlU1bVBnek8yUk5DQTAralVMZDkw?=
 =?utf-8?B?eUZjTFZvbkVpekcwRlUyOHpXTitwUHMxSExWUWNkRUJOSWRIc0JaSGpvdFBt?=
 =?utf-8?B?VmlwdEppaG1UaDNwcGZtdTR5cTdwazhTdG5ROXgyK2tPd0cxaHBMNGdkZkE4?=
 =?utf-8?B?ZWFnWktqcXhaOVNCd1I2Y00weUFMWmhLVVEyWjNtOWlxZUdoN0Q1cUlNZ1hh?=
 =?utf-8?B?RWlhelhtME95WWpKWGRwU1d0MGVmeGtKQW1nbFlEa0VWZTk5QzlHTnZxNEhi?=
 =?utf-8?B?aTNzbm8xU29QQkFUUEFVWTM0NjFyV3BrSm0zRFREZjMyZGZta3BSZUJxRkVh?=
 =?utf-8?B?ZmRQQnlZSG5HQ1FyOTFlY1cybDJiZm8yTXhoRXRBOUhJTVBJRHQ3d3o0UkJ0?=
 =?utf-8?B?VDR3ZzYweXFGN3ZQbUVlU2dCVURYUnE4RXRFMVZRUi9Sa1pua1c0elR5b3JU?=
 =?utf-8?B?TWNFUUFtYlh6R0xGK0hEYUw1TE0vOW5qcHg0N3dFTm5zNm9lOUN3dXVGOXpL?=
 =?utf-8?B?WmxmMk95eU11dlE1dUxCeVVvN1dMa0pDM0lTVVFTc1VVbkVqZzBsREx2WTA2?=
 =?utf-8?B?UVVRZjR4Vk1tMTBBNUtKR2dVVFNLdGFSQ2JZdVJqRTFQcVVoTDRFb2E4NGJr?=
 =?utf-8?B?SUJJU3JVMCtYcTNpa1Y2eUxrNlY2amF2VFJxcXpqY1k0Slp5MS9aTnZDSFAx?=
 =?utf-8?B?VXV6a2JmZldOS0lKMnB5YTdxM2RjOUg0ODIvOW5NNzBZOHVYQnB1VHI4Q1ZG?=
 =?utf-8?B?UjZZa01hQmlMWnNzWFBZZGRnMGljRVFCN2QxWkR6TkFVR0NyQTJET0wzdGVB?=
 =?utf-8?B?ZHgvQ1lZaklFYUtjd1pEcnNLc0ROY3VDUW9SSFNvaGRwNlFnazBCRzlkSG1L?=
 =?utf-8?B?Z2NpVXdXYmdhajBXYlM5NVBSR3ZraFFoR1pmd0xRTHVaS2JPVlo5cE56aVE4?=
 =?utf-8?B?UXhWbXVJNjN2eEp5OUZqbm5JSnZUOTEwRUJQNWxSc0ZwZG1NQWZXRkQyY3BF?=
 =?utf-8?B?OFFsTG5XczF6ZjBncUJyRyt2RmE3OU1DQ3M3bXdxdjU3NzJYTG9neWdaYis2?=
 =?utf-8?B?d3lEM2h6QmFWUHBDNXdDVDFzQWM3TnF6b3oxVmFXeXYyMytubStBSmRvMlFt?=
 =?utf-8?B?SEtiZXFQYVBqc2VORUFESW5KbS9vcGNuV3Y4S0JkQXpxeWlIR2ptdjhuNUpW?=
 =?utf-8?B?ZGk5UFRpL1N1WFNxajFPbm9nWHB1ekhQakVxb1pmemE5bG5BWUxPMjk4SG1h?=
 =?utf-8?B?MUxvM2wzZXhaT3I2Zkx4Z3FTSENILzlGNE1ZTVlUWmRnZ3hUTEFRd1RrbmpL?=
 =?utf-8?B?N1RzY0lTZjZTcFNiMGNzMFhiU0k2NHFQNitNVm5HV0QvYzhCMUlVS2pYWmUx?=
 =?utf-8?B?RjVBOFIweE1GdStPb0EwMmFHOWhmQ2JJYlFxSkJQeWtmYVptbnBFdTV1eVN2?=
 =?utf-8?Q?skPut78TsjJKs7HbEEK1k4PnlHN/bbiFIyWtP6jX1lo3b?=
X-MS-Exchange-AntiSpam-MessageData-1: l4/DxefY+dsoPFWILfknQpE+GmfEcYdSP/Y=
X-Exchange-RoutingPolicyChecked:
	PTqCFZbFldeCM5o7svsppPBgQgZh1mgBeE3ya/Ra03d+9FBTnA1vj6ck0nVqFIEOWZuX5RYd5k8Is9PeQnoCNUwIij7Lr6v2j7/UFAv9EOawvJIAfvTv4eUDAPZdc+P5myV05oAbwoJquDQUahwDdtnbGmEksgn8cnT+yqvn/G1FZfB3uebgkeIrKXjQ7l3JtbP6tPsBfwZEGR0Nuo3zXOPPkeYOUjLoNH/jhcGVCuLB0ESl2zt1w4LgJLRHQxdfuTYkrilmjYMMsXZf0snP5q3lySpZ1qm86oj9VVDA3DRti0RjJPpdUZs3dza9HXnJ6Pg6lgEiOY4xh7YBQBQumg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rWAcCPocJ2P4wpKS5GIqg70X7b4U6+YHYUaSRf8mUCuAUe/cKN2lSXbJU+Kv/WT/Xnk9Zmd2szu/d/VRXNHBsIGgAcMG7a/nYR5XMRLBNQNjUX2cL4LV3+GcwarTwTilpnLThucC4waDynHmvRtEb+k2FRKHDo/4VPo0Uuqm+IFB3pZXyx1/zd+QQZ2KlSPMe6vyRHkOyTUXUVzLjpwcB/w/E8vTx/8RgE2WeBR9wJkCBiBbsKuuBTdmDQt1hh5mO+oa4vkAZTU2bt2d3pP037yzhJ1MgDMpb29i9e+sDF+SAGM/T5j7WbDqhIqjG+pk/snAJM96AxTEqQA0Dw1YQRdm2eAjOH4f/dqwPySyMpNa1hkzRZPN0DqFCd2afS0HrO9K8KzdF8G5FqLqoVWDd9tc+gaJ/htn2N7yVagUz7eEdJLj8bc3SXyvX71vmoYlSNNEc97axsM7hHjjmt2mAHPKLCLEOP/x/hFP/m+3CgJomOYPnFvx3PVkHzXTMqh7rycOGrR9P3sbnEeIGxUVXZLSiawJoQvTxazaZ+X6yjPmhOkg/Vp2Ipz4G7+HIuW0D8eb+RLyWA3pgf6p4YIH+oz8mrEkpnCUjVpqTJIzz4+6H9EfS9OhAp+EI0FiRwTi
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a536646c-0240-42a8-dafa-08df2b5679c0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 07:24:12.0895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/9Zd2g9LT3v7pOTWxCdtWGXBVAt9LBk8H7eBB/fLYcxkGsykbuiVbi/yHt5OLxnzS9ZTmxGXQIx9p3bzc6Nve/jvjfW05u7OOXGTj9b7U8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7887

On 16.10.26 09:01, Naohiro Aota wrote:
>>   
>> +static u64 btrfs_zoned_calc_inflight(struct btrfs_space_info *space_info)
>> +{
>> +	u64 profile = btrfs_data_alloc_profile(space_info->fs_info);
>> +	u64 inflight;
>> +
>> +	spin_lock(&space_info->lock);
>> +	inflight = space_info->bytes_may_use + space_info->bytes_reserved;
>> +	spin_unlock(&space_info->lock);
>> +
>> +	inflight *= btrfs_bg_type_to_factor(profile);
>> +
>> +	return inflight;
>> +}
>> +
> I'm not really sure of this. The bytes_may_use can take a lot bytes for
> the worst case tree update scenario. And, that is not really an inflight
> amount...

No not any more for zoned filesystems, see 7bcb04de982f ("btrfs: zoned: 
cap delayed refs metadata reservation to avoid overcommit"). We're 
capping it now so we're not running into premature ENOSPC on metadata.
