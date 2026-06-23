Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3FB41C72
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 12:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782217021; cv=fail; b=l99nNymHKAowE8yWBrkE8qLUB+uvbfFfqbTVhX3Wc9y3NuvGlLrruKFaYfmOY8Cgq7ilPr9S42dKYmAEhKjVRjoUsTxp8VYD0jJvpcFVLtEouYG7cYm6QXU+p7/kIGoLbgGsFwz3Cuw5yokBTlDSKulcNLr234iFjbk7JaiyAOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782217021; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AtA6o2WoV1rXZGXN3WUJg0AkdAomsL5gsIHaENG2Uj+AbtLYx7WFS3Vgale2P0M3bHIrcv+FdtLE/fh0m9z/jA0Foq6+aEyOOmveI8PGimLtOrV22Wvb2KAcfMNk8AgnveJ0hnRfnHl6ZQf3yQaLz+4fB7gGIufFrlc16wx/cIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UreMhdpz; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fb2FgCC+; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UreMhdpz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fb2FgCC+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1782217020; x=1813753020;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=UreMhdpz5L71kp/T9i/uMEv0STNOiQvikZ+ZpecB6ZNzTL8rmGwaaZvk
   rw1hqAbltH6j8R/KxQXEokDxkRWZsXSTEJOg7epTaBNAk/xN/eltMYpZO
   WAEA5EUUI1U4F86MMU0CBKmyXOVsW0dJTOqtTQGsFumvF0UZWI0mNcpi4
   CkAsibhuRfnAc5TZVkDB9oxdxOzFcXOtuxTy/47Ae6YwPTQxMCajhnjVz
   L9Xhn8mRKmjLNGS69FKMwWbm+pszniyu22w2s94UdUMBxerq7Mef08bVF
   YCtMDZWfAZk+gQzcQHg6tv3t/Frn/EFxbMBwsSa9ondI089d5sleaK0ck
   w==;
X-CSE-ConnectionGUID: MSfRcv/ARo26fausa9+y2g==
X-CSE-MsgGUID: 83kfbM7wRh6J+IeG51Yvuw==
X-IronPort-AV: E=Sophos;i="6.24,220,1774281600"; 
   d="scan'208";a="149670292"
Received: from mail-eastusazon11012069.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.69])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jun 2026 20:17:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UiTXA8btB0mUFnq4IG/Cn/3Ztl668DreO2wIHc30FJBajLQ0vd4/UIQyDBfYo7AVsilZvwoWwmPHXKruTOLi78x8oeyNwCHeGWJHJKUIsKCmJdn4hzmO0/vwOnHdRg/RTHw5auVbVwPc6bTTgkHpwGJW+Ezn9EqMimiYqOHIhJgaBc+OhYyxnKeMz4RGQrAt3bCs9xIiP3W2lKGzEXFFU92BSm0k/wWPU1iQjape/t3lFsvWGQQ2cJeOcCGOiJW5KKqoRwSaMumvPJgm/J0eqEMIhzclkCy/tgKxNriQX8Q13AJpWfmrs1rXRqV1GtkpB2HpSE5fMvfBQ6wi+m97Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=yhrccXaBQylhU2BGYtk3Ja2slrqp1h9FZTq0XZ1FYhIK5VuwLsOradblQdjLsSaD4vUzplAxuJ7bHfJoFgCzMGrC3t99aWH8GwdXX6v8Qjpm7XIIjnX22IXWoyYLbWcKL9Fs8Y/9gfCsEcmHjslloGvmdX4RaiD7CweYuHn8qBR6GiW29YZ9PCimC4pGPVgPjv2JH8aXnmbao98hyrmeN1+2sreRyRztUzlfIgFqwpOeHvXwSVLZjmeg6Yke9wA6tY+5bS9qgAK4BoQqnXr2TcOUndOspVmpGYNW3OmL7I4lXRJudIsUe87zDBmIfTyzSMSKZ9jndLPp+e/ouMBDeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=fb2FgCC+lG1eOQz1nwx4MMam8OYOdgWC/DUnve6J0wnuz7q7kBCLbEfNJZOs0aNeqzrTVUpXozOaTc4B/wD4+bBHUyu6QII9Qg+E6q575rrt4egZsvu2tOV5K3S9gudg3Rc+v9G9yDhffDIIPl+9nTyErCO4qCorHXtMyMuQLQs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6383.namprd04.prod.outlook.com (2603:10b6:208:1a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Tue, 23 Jun
 2026 12:16:56 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 12:16:56 +0000
Message-ID: <da0e3820-b2d4-4451-9abe-e2b1c11de27e@wdc.com>
Date: Tue, 23 Jun 2026 14:16:52 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: send: fix is_current_inode_path() to avoid path
 resets for common prefixes
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <4402ee2dd45308bdcfade989e0fb5a917cfc3f6a.1781541942.git.fdmanana@suse.com>
 <ef59cdc332942f989bda1448b95007c6c2d55f82.1781543363.git.fdmanana@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <ef59cdc332942f989bda1448b95007c6c2d55f82.1781543363.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0195.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6383:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c970bf1-3718-4b98-06c0-08ded1215174
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|23010399003|376014|366016|1800799024|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	X/PNswtp66w6X0AWNS7UuQ9HJijNdeAvXfMRW7KSW62lSs2m0H40gkc2OsUhNZdflFk9t3etzI/d5CtIcHaSgY/8DUtqLp49LG8sOymPZRl3eSdseopo5rs0eSLhUPcuAiDzR5a3haFpdgvkpIBLRu6zHNhuqEe3NsxuPNe08/v7Y3Jabi22FIIQJ3KLrDz6BRkVrmRdZctJFKGHFs30gtJ2M3cqPU+Kv/rQircKVW9kQ0mmRVXj2WiLVxPwsi6/j4rqr/tkHgMF7KvNTpxP/SM02G2KAObzJ4sraYKzCJNOjwihGNZngxIP2M/fQHj4fWp9xPgcRYhN+Vy0sI3nZiieAs4mNQ3bONZw+f44/GFj8v1jFn9K/hFFSUqqUV+xopdPc4bshXKvttKCAMJs4+xdFmvGQSgtpsgO/pAJXhb6lMlYN4gReSm2sgTesgNBg810MYNgfnkLoLZtNOtrpP3z3OsSSJD8iglrkFirkN462+Kbgu7ckUqYDYfYm2GJmuA9GOaWm/LGzR3pkfh6LwqsMYVXTj54/FAFRKrjv/SEzJ83+2V/yeRbahzCgp687rj9CeaWfs4WVFIasPnXY2xkWgAlFNpoZUlcyxmw+FTPTX1HsPpWPyGx+UuyZpkV1y0lUbms+e+DcA9vAMmbeRtwL5gbNoZRAtWY80aHHXc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(23010399003)(376014)(366016)(1800799024)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEZtMkxGQTRsbTlMUFFRbnZQYW9QelZnTkpZelc2c3oyblM4SFA3b0hxV1Rq?=
 =?utf-8?B?WmJ0VjNURGkwYjFhdmYyY3dXQjI0M0VqRkZ2bGx6R29nZEw4TzRCZWczcUpk?=
 =?utf-8?B?SHFVZEIwdVpxTjQ5Kzh4dWNpVER5amxySEZvTmc4K3ZSVDhRRkprbm52OThh?=
 =?utf-8?B?ZDArbmFQR3dhMWtDL3p0L2pjN093MXl4TWExWVVTSEhPcnJrRzk3UDZiNW8z?=
 =?utf-8?B?VHAxb0YrdEFvYUJkZXM0MzV6L3dpQ2ZYWmhOYkpucHYvOEd4UzhlZUVTdU1Z?=
 =?utf-8?B?ellFTWRXK2ROTjRmN0hnVTZIdDhsWXhRTy8yTXhjS0pIT3VQT0JCQWcxYVUw?=
 =?utf-8?B?ZjFVZWxSK2Y3TnJqUjY1R0VLcG1BYmZpZlMvR2lSbmlmQUc3U3o4SWFQc0c2?=
 =?utf-8?B?dG5ZczR3eXZLNk4xbEViZkIvbTU4bER3T0Z3Q0VuYVRyNGNBRXFIYWpQZHZE?=
 =?utf-8?B?U2UxTHNzRDVwck1HMHdlUURpakYwc1FtY3daVkljV1hTZ3owUzNBVy96ejY0?=
 =?utf-8?B?T0R5WWZJWnhOekJQV3JuWWxBV2hrT2UyRFZaTXFYSC9yMnp0aUlBaXpGK3Ir?=
 =?utf-8?B?dCtkanptNGV6TXdBeWhlaHhkV0h6V3pxTVMzaHUvNTV0dU4vcHEyU2xMZ3dh?=
 =?utf-8?B?TE1GRm95ZUs0UGlSVnA4cTNaZmJRZHBBb0syNndpeFVYaHh0VmMwYlZva0lj?=
 =?utf-8?B?dFkxUUVmSTNEbWl3cWpoMVRzdDlqaEFabEo5MXZkTmZETkRXMVVWVzRVUkk5?=
 =?utf-8?B?ZXRWMTYrZHVTUG1PZVhhcFluN1F0OVorblg3bXVrZzl2RkhzbVZFT2QyazUz?=
 =?utf-8?B?bWErUUJ6L3NDeDNocHBpeUNZTnM5QWVOUVQzUjFadEhKUm1KTnUySVRVYXU1?=
 =?utf-8?B?bFNPY3VsTW1JZS82cEk4VlVLN2lYY3lsY1BsL0NKWmJ4anN4RDVqU3ljcUlm?=
 =?utf-8?B?QzFoWEFTS1hCY1FyOU5yTHV4RG0rejgzZHNNK0VHNHlmZWtMM0pkTGJya3ow?=
 =?utf-8?B?ZW4xeTI1S2dWa0xKSys2aUVFOFZuc29KcHNzNmNIWW5DN1VuMTFDbzU1emdU?=
 =?utf-8?B?VjNFS1BKZTFaaWdKZ0pGK0YvTnZkNnRFSEVOSHlFbWdwanU1ZnI5bXZEZFV6?=
 =?utf-8?B?Nmp1WE43Ykh2R2UzSkJ2TEx1T0hWeHN2Rk0xUjBTQ25BSE1iMHFPanZRdTZY?=
 =?utf-8?B?eWNVc0NPY25IMkEwUlQ1L0tiUEt2WFNEQzRzcmJCOXZUYXU2MDZQaXFiS2RU?=
 =?utf-8?B?anpwbmJZRTk4NGpTanV0WXNmTGF2RllmRllDcDYwTEltUkxhQmRpLzg0NmRQ?=
 =?utf-8?B?ajIwQit2V2pKc3VMT2lkcWFSeXJwcTVvNmZCN2lQU2wvckRaY3ExZnhlZFAr?=
 =?utf-8?B?ZW92enNqMlI3VHV6STd2bldvUmVqM3l5THAzWUdFdzZpNkpYVklwQ2owbGsw?=
 =?utf-8?B?ZTdtRUtQa1RkYm9HNXFQYWxNc0NjS1hOWTMvbEZTRGlDcFg2cHoxQVljZm54?=
 =?utf-8?B?Tjg0Nk1PbUkrRTkyOHU5RjJNdVhFV1JDNzBpVkg3NzY3OU1wUVZXanZnNDdy?=
 =?utf-8?B?RjYrc0VPdERtUkRPeXhNY0pNaHVtS052TWs1ZlY2Z1djUENLTktrVnBkVnVh?=
 =?utf-8?B?K0Jmb2JxWXRWYWZhdUZKZ1hBQUlVUDExeWFGcFl6V3YvMDEzRVBsM3lpZGlk?=
 =?utf-8?B?LzBSc1FvRXFxRjAzVURaV3YxQlNSRXhrTVRDRGRkcHJwSXhOS3FVRWRhNVVU?=
 =?utf-8?B?MkJ0akFNdkx1ZHhqTW9lWVNGcUtzYkE0Ujh3V2RuQzVhWlBLUnVYaEI2QmYw?=
 =?utf-8?B?N01aLzJaQ0xPNFJIcnpaUXRNRGFUVzh3UWJ0VWpEMzk3QW80aVFIR2dmT0xa?=
 =?utf-8?B?cUxwOE9BNVBwQjdIekdoelRIeVFFT1MwazBGaWpJY2F3NGhJK005U0hwdlhv?=
 =?utf-8?B?aVcwNVpkNkp0bUNaaVkyOWFjT1hYb2grYUVBQm56bkt6NzlCSWh1ckdGYWx0?=
 =?utf-8?B?aGt6V0lkcDJNNktJUHIySnZKMTIzR25pRythYUdreUxOdStUKzFyODFKR2VO?=
 =?utf-8?B?N0ZYNDVJSmkxVnVEMFdacDYwbTVxTFRsYmlqT295bUxXWWVUR1laZW1FOFJ5?=
 =?utf-8?B?akgrc1ZqT2tpQXFIdlE5M1ZpalNSUUNSQlBudmdqS25VRmttUFQrRXdOeXYr?=
 =?utf-8?B?Y1RtL0JiR3NzRFZqQlo4UWNBeUhrVWdmajlFQ216L2RHNThnV0Ixdm5URVVJ?=
 =?utf-8?B?S09iUEhSeHR2dlJuTmhkN040OHJqN3dxOTEwdTdMRUVCNE9NK043UzhpYnps?=
 =?utf-8?B?aEFuY3JESDZHakJVYVRYbW9hNFNIRmpRN1lLY1FGRGdLZmhvVjNURXEwTTNk?=
 =?utf-8?Q?KUcQhgQ7iB7goj80CTETY9unlwfiPoLEKanRSoFO0LFec?=
X-MS-Exchange-AntiSpam-MessageData-1: xFp+/HCiVKDD4w==
X-Exchange-RoutingPolicyChecked:
	JwtoGytiWkpHRHekpJiGleG9f2Qi1DWoK7kW57yZ4forMqcH/pK7TGNsgg8Mp6y9EkiCc0N+jzSL8cFoZb00kQvVyQkXc9nl7eHqdWwWS3vXPwsyyiDcl5N1BY2SjNc7EmxmSkGc+xeYnqNiBD9qpgqb47HiPkygB1zVzuAFt7g2KKgSv5Rkk5HC/VWuNLhUGH/LiCWt3IX1TfUTaU8eLMzzy6x+BpkaFWyx2PE4WxoNmd9hdrta/tpwks5y+oVhWGcGsPuGKHbujltm8VIiIaVz3ViodyesGqxqCYxxNPcFhD9F9q7K3+Tos6yV4Z9zB7Ewgqsv84sM6gOFFy23Nw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I2YAXmV8Ydptpet63Ef6FOTmIkO8jVGMnzjfaSlWrp3VatBK0BGYbN1CyGEzKsQ5qNLaBVdROM6XIo5WY9kliMc7B17BnN2pbYiPf71M+2PAlSZ3pnHsZC91cGjychyk7E59TXsKSja2rXLG4A/vYg0pBgTohpVMWg/Sd4PDTzH//DaYiKcmgMiLbfeGDQ6uBmoTbvEQIA12oAzcWLLBnYWL8bAFyfTlBV/rBqALLitrHgHMjFbEemrNi0pp7dFhY0CZDL3taxVAzn1FC/plYpCZT66AlgfN8RSlESqexdN2fQlQAw9ZL3JmFtrYgjonl9w1kiJKfarQI3yIbljVP0UjWXbKmXTJ2I3hXkp7Yfhxm78SNjv+mDI5HM5OG14JVnBNjAGWKU+QQSIdZpdvRj/FSi/8hyFaTFpVCsiLaP9/2MtLg+r3UpLHZO30Vvod5+If+GS6ZAiL+hUv/+Ng6+II1LJRGxKcPOoMoh2cwmZe6R3gToH8TMjyhIYzKo9yoNSpB+Y8/tGMtGhW3wAF/TX5RDSSlYhaLwI/23BSrquCOtFNhfRWoXdSP8IgR/s4hIWZY3gCrCER8sjxVWj/qUYbplddxK/SI7Bo0UKL2+W1rmuOuOMJhiLKD5Ffawex
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c970bf1-3718-4b98-06c0-08ded1215174
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 12:16:56.6070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWP1XBK0hQh4kpgDky0HZ2jP91Mu3gfCBaxJoPeb2OKm54a173HOauvgw6Qbhat05JH8V/tCIvMLLaFemsfVhYalTRNERmRR2MHJ+Y6WSBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6383

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

