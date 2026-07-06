Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28E737FF66
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jul 2026 15:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783351187; cv=fail; b=EBV6irJyU9nEwn+ugkwezTLGua6HStBC6TWQmRuzgS8obk6wYDqe0eIsHIk5rC2RHDxVxTv1o7jKVp65/h3lp2tqUErcM4jUaw8k0EEYrvdDHqC8nQYe8OR5QPH4RXq4TUuEYi7zEcQ8wqL/jWvZIdVDqQ05paEiPjTvhGehxTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783351187; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d1Tk83BuDmsCb+ZIvMxsWVI97BTugPipKB4KDcHaw6vX3EzBvL/2umEMQk5IEbElyV6aBSi4CeNI/LdJtrOXQb5Nj17VucSEOlgvR0I0ODNdkbFDyjEflJwKe/gX8ffqYJMdJgRsiYBDedLmAgB6JzbEkt4e5bthaJy4OlT36qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JbYttP4n; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=HaOvjNz+; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JbYttP4n";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HaOvjNz+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783351186; x=1814887186;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=JbYttP4nRcwfPxYzLnFgz3IDD4p8iO4arkLPCjo0MG9zy4nLX0Jkpfjp
   7I5FZ4XlxNKuKF1gh6+YxCAP8lzN/M66GURvU9Lbkn7+ERwjn2wBpVjeG
   em+7Mj9rP/2R1eBwhqnjr02cd/jqL7oX2cK0fnvQ6d8geDJxBAwqFqqxJ
   RDHWvX7uOwbPVaK3JSO/LLrsp596hfqn+H9Xn5bMinCde+UBxwPkuB9D9
   fSiupFoHwksbzlAUerhmJxmZPvJe1wTg3SQGsIZWLgeRk9I++lRLv1K81
   PH36JGLFYUDgPy/uJLKXYucQJhrVBh7dCGcgvqWipev9BdLy9X1HLxQQA
   w==;
X-CSE-ConnectionGUID: lFDNyik3QVOcMQJgbA2SMA==
X-CSE-MsgGUID: JJPyZUTjTQKnNNortH/jDQ==
X-IronPort-AV: E=Sophos;i="6.25,149,1779120000"; 
   d="scan'208";a="150483578"
Received: from mail-westusazon11010013.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.13])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2026 23:19:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lFIfjVQX+mziTPbQ2WbrlRheKqiF9z3KKrRNJWVtjjTW0rMMHRvXzh0Bw8E1SthGp7hmWkVMPO2FALMURmXTkquuPhVoMNrkUd+KKoKolApoOfrshcGQpagliWzCunw0YNemFd/Wv4SRoE9wo7/6iqlGFd2tZJslEDeFdeptKrsOkK3xcchiQZ/ofsi/eGW/G5tFDuTnoOENKrj9ZskxV1KUxOoV2hskIag6hllOnjnUWYycBN/hxKFU4an2EN81TZq8gyD8t8+HAhakPhXhxYvu3Tgep8yxzxgG8zk2Sw0MI/NDtjfAaxcLn7Lz8F8gc3rPo0RqTT19SoQuxpauYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=bV1/6wsmpdJeptge3/ZH5OCBAW0SoaKQkY3uYkvzJ1l441KrfkBdE0zAWN5wRLcO/4yxNODRcy6qB4rs/1WVW54nSwPBd3Tda7e2kdxHi9hessJI2/8RbMD4W2IvQSTJ/rq1/z7NAeyy7q2o4JaUFBQFU4Tf8iyMUPvKg6BvAnwYkmtGvG3P8y0/hFoBuKGySKrhL9OpUC2sGbTWz1gQ/iwnTJtJyiRwHHYHtDrP8jO8SplRf2cqO8e6gLfpJnIfYyLBqI2Qlf5FPb0iuu9WaqtoNkG3GTKgRkzJTyqI2Eujbw+BgTrfVAaKT5GLf0H2YDBO7rbgKlIHmhZCxey4tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=HaOvjNz+Wqk804V1Cqi69hJQMYCV1ZhLYYPw29Vg1LBc97OP4Afrq2rwnGzo3dz6klsNetZRLujfQGcSO4nFv1Z8rwOF1VCgTikv1CkEdjAz9nAmKkUb/+dyjPbflpRpUkB3YSmZY7ac3cLgHlOrkYjoI/ZbV5BrEU8iEx2gbl4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB7082.namprd04.prod.outlook.com (2603:10b6:5:24d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.13; Mon, 6 Jul
 2026 15:19:36 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 15:19:35 +0000
Message-ID: <34ead4db-9ff2-4446-bd6a-c0c1962d6131@wdc.com>
Date: Mon, 6 Jul 2026 17:19:31 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: get rid of useless label in
 btrfs_create_dio_extent()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <74bcf9563b76639f84210fb5ee006d5a865280c0.1783338152.git.fdmanana@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <74bcf9563b76639f84210fb5ee006d5a865280c0.1783338152.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0029.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::13) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e2bf258-b2c3-4ba8-dfa7-08dedb71fcff
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|19092799006|23010399003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	l2dmjhjsHaS0cspR4mqdfCaaLT6EBLmFcyew4x7fITE4O+unKvmqliH9XxQe4D1mxxExJjDO3Ui38YakPv4tnq813GBtI/kNucyCu/LHBHG22R19yewd4WtE6NOX7k1wh0Opy6V7kUxXdytATIxYnY3bVtQ++SpIYAeRdkrFLhY+4s87w+RrU3gHi+VkeAW+oXukWa/g7e7DA96KI7uRLqgMMNFYQmfFJCDQmSg1/+tsN8dk59E4RNTqYI4EIe8jrZ/KMCKjWnemRp3GsT0JI5hMYzlsWT8FyySXm5oYQskZ9NueE+uBHUgTq9LpijXCXjVFxRynm9Jcc7TDyGmks8b5Eh+6NSV+N3MqkWJQxVaoP7nM4eo8TPTa8b7TXG8nneHIi+8Lgkfp2VXf6RcEDS9zSgavy4WgJd4zoDbtxlPR0+p80HTZN6U52+ez/eFNbl2Hy7kFXjZXdJ/Dcsa6UaMTsrOOqqRZJ5Is3ID6sXu/OiFNqC1FXQ84IXkru41IgsI2Ixp0b7UnjX5MM6dSio4BsM1iggumo0ggcNRXAOkApUT/xCwkyY3o/I0hyoCWOwtX0UV87elSKoFvYEJNwblv70rFKQViSD3eKTcBYZxvc+oaEztTd5hj2Kpiviw2vdac7pElczC3tNyo5VzX69CdgTOe3ey66OLiMb0fQtE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(19092799006)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ny84TklZS0c0aXRNbmdKM2xqZ1NGRndYK3M2VFYzT3BjRFQvbDlHY2IvU2k5?=
 =?utf-8?B?WTNIUWQ1eWdaZ0R4T2VTbURsY3V6ZHg3U3JTdkpvSXY4S01KcmtkK1dBUkdX?=
 =?utf-8?B?NWVqNmhvODdlc0NDaHYyWEVWWEo1eFY5eVAvWVJaaWhKVTVWamtkYzRINkdi?=
 =?utf-8?B?Z0l2VlAyb1hrcDVRQUx5QXpYTVpDMEptUjhHblhFbkIxSm5Ya1p1OVpJTlpL?=
 =?utf-8?B?L0NtRXB4enZoRWN2cDVlODBtbUlrNEI0SEZJSk53U2lOMmdmSkZndTVnVVpq?=
 =?utf-8?B?dmFibUVZWWFaVGZ3YzBtOFNOMzV4YlNsNE9tZlZjSGxxN2FHMTBjenl0Q1Vq?=
 =?utf-8?B?T0pBVUZySW1vWjFKQmpmeEpMVlAzcU4vMHJYMjgzeTYyUjY5bWFDamhrVng5?=
 =?utf-8?B?Q2c4WTUvT0ZLVHV2NllRNm9YYVplTHhNblBOQllzSkZCS1pnQmo0THVYUDBH?=
 =?utf-8?B?Yjk1YkIrcmFmZzZ2Ym1Ia042Y2JreGg3SkdxT01CMVV5ZXErNGdKYkQ2RWxD?=
 =?utf-8?B?WWVjUVVjQndSNGJld2hYTWhYYXBGbUxXZ1lOank5VytGdDNDT1FpbWN0bU84?=
 =?utf-8?B?UzZoZVFORkZWWm83SVNJTVhEMGYyYmV4RjVJVHFWSG5RWnFBdnJzb0w1dysr?=
 =?utf-8?B?bUZ2a2lweGtyN1JtMVNqckpSbEMwOFBmRHJPenk5NGwrQWlZTi83UW5zQWdP?=
 =?utf-8?B?ZVFXOXgxYnE5cDVtK0hDZHRyd3ljb2JHV0lLcklIL21PUzlKTHp2OVl6ZHZT?=
 =?utf-8?B?OVlia1RzVWFGeDFqRzJKZ2hFNnQvOEdKV0luZ3J0ZkJJaVhxUjJUYlk3NTd5?=
 =?utf-8?B?TTZrRkw5cnFST0FIVERGRFo0Q05RaXA1LzhyYmJJd3psR00xR0hlQS9YdE5q?=
 =?utf-8?B?VDVhTEt1cGI3ek4vSUphUHJIc3JNWXVJZW9mWENSeEd3REtSblVSUnlmR3cz?=
 =?utf-8?B?S0tjSVN4UDN0cHErRkt0M3F2ZTcxNVkzS2xrNVdNazJ4UGJrNWlzcXlwd3li?=
 =?utf-8?B?a2VoZTJVTFNqWWphNXlwZkU3N3lrc1l5Q0xsYkIxTWZLVWdoQzR3dHl3UEZv?=
 =?utf-8?B?ajh0OXVMZG14dDJydXNDYkJyZHNMRXRLN2pHYzF6b0xQZnZ4eDhyV3RYWS9u?=
 =?utf-8?B?U3VQMW1KV1JKVTNpSnNFdVhMcjdZaXNjR3prZW1jY3c4bUNyZ240dU9UdGtK?=
 =?utf-8?B?Z21JdkhTTHFEcUtaMTdCazRIWFdycDVFQ1FxM2QwMFlmNEYwNFNnZXF3MjVI?=
 =?utf-8?B?WWhZTDJOT0lpTnViMlVmMXVLSWkrRUNyRm0zMDBLTXJVbkNEdExaSTVOWGo0?=
 =?utf-8?B?THhTekVhbjV4emtOeGJtRG1xdDR6UzNVQkc3Ym1iTklqWm5ZdDJJU2g5emE4?=
 =?utf-8?B?WjhSeWlsWVVrY1ZtNGFYL0lkcElOWkpmcWhheTVMQ2pmS2UwMTU2RjdjaG9p?=
 =?utf-8?B?V29JbzBSOC9LZG5SVjVYbjN5UDFYbWp3TVNnNkZ0aFlwdko5OUFVSTNjMnZh?=
 =?utf-8?B?NkgwVTFxM3pEMnNrNFZDRjJYSTVsbnIzMjhyMDZjbFlpc3B2OVpaOUxaWVd2?=
 =?utf-8?B?T1l1NzUzcGs1WkFwN0g2emp3S3ZTZGNZMVRCVkxKaDRsU0VmYm5sNGVDcXM5?=
 =?utf-8?B?MlBRbHdMcW91cDAxV1VnTklIZnA3dmVINUgzOE1uU3prakl1VGltQlZTVVBt?=
 =?utf-8?B?ejV1TWUzODBRK1pUYXJ3dDZCSkVqV2hmSjdEV0RFNTNTUVZUMk1aV1I3Y0Iw?=
 =?utf-8?B?U3RXV3h3L3k5RlRseWxhdnpKS2ZOSkJEN29nYmVtd0R0U3plSkZybzExZnk1?=
 =?utf-8?B?LzN5eENhRXMzRmQvMkllUmZRTENIY1pYSTZFRGNyV0piU2hpekxqa1dLdHU5?=
 =?utf-8?B?azlUWHp0blMvQ3BGZUV6QzFyT0lyMEd4U1orVjk1S3MxampSUnB2KytndTFQ?=
 =?utf-8?B?MHA4RlgrNzkydFJBeGVOV1hneklacG5nWXBFMlVwVHBhRjVxUVFIY3FBS0dS?=
 =?utf-8?B?UjlhZjkyU2VNT0N1VGk0VEdLWFMxR0NuZk84MjhrMXFFeGtheDhSNm1aN3dm?=
 =?utf-8?B?K3pCUmluWVlMc2dsa3lodUM5ODZpOFBCcEFhUnR6ek5nYytzencyODhBRFNa?=
 =?utf-8?B?SFNaclYyNCs1YUJ3NmpERHZPUEJzN2VXUjJpWTZhMmRHU3loSVQ2T21RSm1R?=
 =?utf-8?B?OFQ5VUVpWnZySjE4aHV2WUtFZDMwUGpnT1J1RWZTU3EzM01GTjJIUnRYNXZD?=
 =?utf-8?B?WHpzZFV3Mk4rajE2Sk9mM2p6NE0xcm9mSElpZmNxUkJDRllDdC9PSXllYTRK?=
 =?utf-8?B?WUgxb2FzTmRnSGxLWjJFQ3BNVUlLeUxCT1FXTkVCTkdEaXRhNUxOQ0k0eDRG?=
 =?utf-8?Q?Bh1iBoGhrVwHmKrBuhIsecAxF9D87ZWuWFtgv+8S8onhE?=
X-MS-Exchange-AntiSpam-MessageData-1: REcyuAxT8As/eg==
X-Exchange-RoutingPolicyChecked:
	f0cEDCQbIH0++ZpgqldQesattRmLqEtDiJLOs9KOs4+br8vcmuvDqSeFCN96IdQhweYd9upf1dPpt99+ay05YGxKQ/Ar9JIQWDWR3q7qbEN8zTq7PFqFKtxyH2ZZfCm6shjhdkP2MI3uE7Sa3i5evdKcFRlV7M367BMdLcfZ2lIorDDKYMam1eH8H/bZeXY4h2plixuDh2LITtnkI5Ad5oEADn0aqPXaKjrRnZ0E2oGuhQXZD8OIzAphO40NATtq0h2WyJBpjr9Z/rsHzDDdP/XkzJzvCp7agn3Tmi4uVb+kod/ZEQsZT3BLScId+xE2ZNeYZ4ekJ3JZhdYQFAnwvg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ztkWsMIaHHdRo0S/y0kice11V+iKFhAkyZoRkDbDUMr3Ktctgrvp6+oEz/sTmmL+CiWwTQVWO+mMPHJy6iudV6lqUoCHN+2ppU2Cx5Id2UUbN92uVMKTTxvWSmWpEKVNIVoNGnRtti2ruqKzSgRQCwiBlDse4Hf3+LjmJbjK/5Milmt8lTyYIFF96T+HbSWLyUIiO4e2x1TQEwcGfHrF1hBNWoJQIX8wYW7Itc//Fi8T6HE9J578lTUU6OJRqrqM3v/KRm/AnrL2WnRazWxcr509EndB+rUNViuyr0E1Hdd5akyXQ90XzsF6pApjb1U6WBrFg9b4LNDtpLSFqQpxKhu2SaeqbKiFR7xrxMUhFSofq0GsipOZXBfP/qUKwFyt6B9chQ9ozysTrK39Whqo62hV8bTZzsfneeLxpJBaKPyW68tWtq2sIccBsoIYM7Pdrwu8miV4vtYSVgBoNyefAF8pnCK5jN7r/Zo3MP8m+XkFtTMAguD55JBec9JgMwdQzMydGLr9GUU+MlP+r7rLbt2eLOGQyBPfbiBq0L+BOpXd+5hU97h8pBsMY1DkyYE6YxIZOlLc1utKoft/MLbGbyvhCsEHxqofnNxGjKI9auowLJPVMRWB4BJIhWvode7D
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2bf258-b2c3-4ba8-dfa7-08dedb71fcff
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 15:19:35.8869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RhiLaRHBXdwaXjVYo0vjV4SR3pGFVMDIL6g7JxyRejkf0nJX3rSInrDlrhw/Y2DQUgP1s9JXSU5dl2O+7FdkIOKEU02nrTNtfBXvWS47768=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7082

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

