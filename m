Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE7137F729
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 13:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269707; cv=fail; b=NZtInTeoHZ6vK4s1LNv8H/TGLvkQFhUjVwu8t9NwrD7LWMXPRIt0LFa+fV1BmsGWNxwTM/loHLFWNAgrMxvlg4XKnF92MVcWnt9CkG4thSgE+KbVeUfXdR4P3uVbNC2E5t6hvrPZFMfuyxENk4OPZFegj61Q412NbC86OhpWe1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269707; c=relaxed/simple;
	bh=+eIidBh48DLLjq0DnFjtEmSDwnMd+fk3EKsGP3iWzqk=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nRGwe9VNl1jRg1eudh/+Sp2XgowHm2B62fPzlb1rqZ46GOrbbcuD4+XyWgZ0xQc9TDJRL0cUx+/lwSlrlOD4NrOq0pogHYDGhoE8m0BB601rzGG7uGJlkUA0wL4RI8h4sjZUKyl+DcOLvvK8yyjnZMH39wsc00o9Z7IsJKwlDr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ThnBldUU; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=bgbbqO9w; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ThnBldUU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bgbbqO9w"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781269706; x=1812805706;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+eIidBh48DLLjq0DnFjtEmSDwnMd+fk3EKsGP3iWzqk=;
  b=ThnBldUU+pPzHTLzOuaczxpzfFWUEERrcvmKjcN2jMCKTCGVTA75ZwjC
   R31YWEWbVsZlImRD7kE84nYB/06WYbPwbYlGYviCcV5+6GVFl+KyN7v35
   scVlDghN7NVP+QnnyNURdLp1rJLe0DZYE4Lj2Dt7EjWbK8BuXe4ZjqLw4
   yYmVkDFDcWfkUa1dj855RkG0DyWKzEckj9ka++fOFrHmpQnbHFSVZ/cXT
   JrqrdWRgXXjpz0gNPg/uLwt+5SO4RNgFW5ImdiYQXuMHYX8lnu3L1yn1j
   AyEIzqQoG1gzaoEaB2vqTetMUMR+yS9hg9egA8XSE6XDc9whZUNV6/JGR
   g==;
X-CSE-ConnectionGUID: qdeJQY8gSc6mPcnbZKWfKw==
X-CSE-MsgGUID: 1/3ZCUPaT8qL7FYzTMUkwg==
X-IronPort-AV: E=Sophos;i="6.24,200,1774281600"; 
   d="scan'208";a="148041042"
Received: from mail-eastus2azon11010032.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.32])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jun 2026 21:08:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ON4K8Ralku/j7fw9ROjHXstThmK9/5IhEG6rug1u4avRypjUdedDSZ/t2UNwls6Sgs/uKXDgLN+UynXVhgy465FYGUkXe35/L0iBm0zJo4QQTmq+cDQPOe9nQtCmGcW5oX5MwQy+ksL6wd1+llk2FKCrCEa66bmKFfyD5rA6IzGqsCKck0sJ2lF/H51LMR0H1gLmZJoQotehmRbiN86EIKKyzrlsnzsCp8mfrdtA+ncKynGLg2Co/s2j7T3rrwCNpY1URo2JLWy5sKg6xTF0LGd7DejHdDX0Q6cijjlgsRRfGdMoNBYbk/jQHa9gdgcxYwjZuRWS6oRfFc2oB0v9HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+eIidBh48DLLjq0DnFjtEmSDwnMd+fk3EKsGP3iWzqk=;
 b=KqMJ6S64v5GWCfxgbfN7XNenm+QatR+CiS64VZ+9BPAl+dZ3W224yd+FvEIjDiA4EzWe0+KRC9GxmsCS2Qqo+bNUZwdzb/X1Ne/L251jqxSTPgleavEenHWyADufaGsRZOn99eecp1b5YYqngOA+rQIFqBfAJmMt6IkmsQG8GWOh+syXvy2tqMesOmKocOJiGY+R/m5ldYXuSOWvIZS0Aq49itp9IdxZoV1mhJfulTlNlLK9n0GqnUv4rL0aMF8c2dv3KwOx0kL2/d8f0uan0TsAtpQO8I9dph1s8zpSGpEdlskQwQ2JA92yQKbvjsfpq1/nsj179VW4Pf2ufJYMcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eIidBh48DLLjq0DnFjtEmSDwnMd+fk3EKsGP3iWzqk=;
 b=bgbbqO9wSfWKk0MgIytzxVIQldIJttW2SKkMjAxp8WL6DI5FblV1qxuqk5PIZKA9qJb/zwifvJcwd5hYUQWKUhEpKdNHoI2UIO2737pE69j1qgCEjw2/4SkOgteVNEsffSI7KanAzVdskFjkJitDBRICUg881rUm14eVmoA/Bxg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS4PR04MB9845.namprd04.prod.outlook.com (2603:10b6:8:2ee::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.14; Fri, 12 Jun
 2026 13:08:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 13:08:22 +0000
Message-ID: <b0b34349-2eb3-403e-a541-5c2441c8d3a3@wdc.com>
Date: Fri, 12 Jun 2026 15:08:18 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: don't force read-only on transient -EAGAIN
 from reloc merge
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>
References: <20260612100429.214341-1-johannes.thumshirn@wdc.com>
 <3e3b0ed7-85d5-4461-95ec-b9a387db7553@kernel.org>
 <8c330fc3-69a0-4e92-a0d4-f9e6492cea0f@wdc.com>
Content-Language: en-US
In-Reply-To: <8c330fc3-69a0-4e92-a0d4-f9e6492cea0f@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0239.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS4PR04MB9845:EE_
X-MS-Office365-Filtering-Correlation-Id: 65b5a4b6-8450-47b6-8257-08dec883ae2a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|23010399003|376014|19092799006|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	V23OkUs+4x301H9dVOA72qEq584EJ0MUyawDdASNQPnK4MLDU0U+GskCF83yR6cH8qEDlo+WwnWUuC9ejlsx+cXlkLQEILClI5DbCegA3m0+oJDnAJXd7FPEqnr6WoF5J4SaKfAUOmZ2YhSX0uMqLXWPUX4UF/fqQApB1n3esVI7rTxqJ5R07iY+QKwL8GuPlRJefIRm6JyZa4rtV3keCArtYAcJtJD0iV3bdimt4at4f2g4imo00f0kBxoCVJoMXXYW17NNmJw1t9KKHUVtAx/4WcHRkgMvP4pwKbbMDveai6py+77SnJ/LglQLPZpuZy1DAY/Fn515IC8FIQ4JAmxiheL3WYCUU5pHrSZf5MxI8WKVipdA3On2uKjd+5wMEblDFLipnVCsMUSQqLX1V+YI1+pyRYwa1SMBd1S8DBLcVszpDjzpcm58riVMN73hYyIpxGhd0Tgni9fh9LvC+M9gV0k3mxFZFmj4P3r4onlOyxa2vzPEJu9ivsYame70ClR0kfIDA2oTXRewKHXDl+YuVSXEWHhXTD3svEJtYDlwfKd5wqGsGHg2LLUNmMQVNwOzqwgdG7pwDtqUkrVK5NNV4e1HRO2rWoXvJ1VRQEi+7CI8tI30SdrhRNR0ATAIJaQPh0Kd52D+GBOPsI0AoA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(23010399003)(376014)(19092799006)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTBXcXZ2bzMrVWFYMzRrWGMrVmxpRFdhOExIbGd1VU9BNHN1KzZTVVBCZ1Vy?=
 =?utf-8?B?TndJeUMxYW4rbnR1bzNLSkFST2ZPNm1JUVJCSWRoRjQrbWx5bCtTMEUrN2NU?=
 =?utf-8?B?dG5va051T1NQTlVZcEowZnp4ellKQVBUaHQzN1dndHZmY2J4RDFqSHBEYnE2?=
 =?utf-8?B?WUlCOEU3R2tIYVN6dDRDTjk5WjVaQmNwR1h0M3R3bXJudldreUdDakJZTmV4?=
 =?utf-8?B?OUpadUFQRnJ4cXJYVW1HMW9QczZJWCsyUmNkVkJoSzkzMjRjQ1Uzajh2b2E3?=
 =?utf-8?B?S3lHM09iRkdzMVplSnZUeHJna0hCTUFpU05vYWpHck5EUXZydGwxcFYrODNQ?=
 =?utf-8?B?UWVGUU9ZWXdSRnByeVhaa2dnbGQ3cEFpSHNqS1ZubFlpN0xSRnR1aG1QOEFE?=
 =?utf-8?B?aGo2ZGRjcGNVU1J5UjJKeDN0ZkdpbDA3dTB1cElnQnJnR1FZa08zS05YQ1gv?=
 =?utf-8?B?T1pscEtRMkJlbThLSzgyVk1wb0g3dFdwSWxQblpRTU8vdXQ0a2NtUUNPdEVZ?=
 =?utf-8?B?ejYvWVNSY1ZvUGNKNi9mR1hQYkY1d0FjMzJvTnV6TTZURTNadkc5Sm5YN2Y0?=
 =?utf-8?B?eGRWUk1uaUVBSm5LM2JmUUpHcWJKWlAyN0tpZ044NzBUOTJMTkhiaWtDMnUz?=
 =?utf-8?B?M28zNm1HWEZ0SExVZXg5TU9xMDUrUGxFTU5HajdDKzh6YmVYemtZNVZ1RTF2?=
 =?utf-8?B?WkxVRHE1RGcwbVRMVG1pekdRRHVIb0E0WDB6WENvUzUzblNzM3IxdkxLS2lJ?=
 =?utf-8?B?a3YwcFgzZDFKaC8yYmMvdm14eDNwSGRKd2xZOGVMUE1panJnNk96ZmdIS2tq?=
 =?utf-8?B?eGduYm1wZTREb3dvOHFPNG1iYjA2d0x6UGIwV1NsS2VUNnJma3RlOWdHVU9D?=
 =?utf-8?B?M1VPR0Rwb0pWb1RGckFLMHpVSmQvbG9rcFBPUWJ3RFRoallQSHVoVTBvRllm?=
 =?utf-8?B?WkdlSW96bkZIbjBJMEhRNW9OcElqUHhYMEFkeXlFSUxtUGxNdzl4cVRPT1hk?=
 =?utf-8?B?TVBhU2gzTFNFOVdyQnVLc0kwb2hyTkp3RkNLSzRsOFlDSVJKL25xSlIybW9i?=
 =?utf-8?B?KzYwd0gwTHpjaW1lWTdsUy9CcnFZeW9lb0dRSmFvVGh0UUF3TnE3c3hTTE1t?=
 =?utf-8?B?T1FGeVJEL3dVQTVqWjAvNjhBdVk0REJCSEZSRm5mVGhhSHJ0eFJBUnhLaGpC?=
 =?utf-8?B?bWZFRGhQZjIyQ3F4eHNKQmhUb2ZQdnBTL3hNRkdkTy95ZVM0MnlsOGw5dGVF?=
 =?utf-8?B?TlhwVE0wVXdleU5OaTZ2Tkw0TGEvL2JMbG1UN3ZObTkvKzRPaXhjTENMOWs3?=
 =?utf-8?B?R0ZKRWtncXU3YklXeTlOcDZpeDFadjNZTHdDaEtiaW53L1BOZ3JCbjRFM1Vv?=
 =?utf-8?B?ZWxGdkNJYW13RnNWbldPUSt6dG5KcnhVRXZHWEVLaitTR00vVG5LbWZBOEVM?=
 =?utf-8?B?Y3ZIMHMreWRoN2FDazMvY3VxT2QwR2xFSzhUUlpzWnBXNXJOSHBvQUFkM0I2?=
 =?utf-8?B?bFhxdWdMT29meUlWM0NSZThOaVMybk1vRC9ZUVUyVEEyNnRjcUI4TG41SnZ2?=
 =?utf-8?B?bDFteDV1a3A2YWlXSFBXY0JXUnJRdEFKZk5VSE1NSXIyanNKYThsemRDY2ZF?=
 =?utf-8?B?SWJWK01xQ0tadW04RzEycDROaUFKTkoyQlRnRnBYZFdQUWpJMnJ1QkJYZWVw?=
 =?utf-8?B?bE5rbzZoLzBxNkNabHFXSmFSTVF6UERzZnFlYXoxZVNiNlJnS1ovZUR4K0px?=
 =?utf-8?B?KzBPN01FYnVvOUJtVlZOaGNvK0p5dEs4cXkrTFh2eFdhKzBMUFh1NXhjYThB?=
 =?utf-8?B?YVNKQ1RnRzRKdXREYmMrZ0RzcVJCVnBJMUluNkgxWW44VkdHcVZVaVAybjl3?=
 =?utf-8?B?Y0pram11bUNRQVZSSFBpdGZTSFl6RWQrWlE4U1BtWXhRM3JkSTl3MUFPd3p5?=
 =?utf-8?B?S1lhWjZPc1NTUk8zamU1UHRVTXV3d20zM0g0d0dqOVN4cDBTTENvQUU2cG9x?=
 =?utf-8?B?T0NES1dRS1owbUt1NVVSQkZTY3hWVzlnVXRXem5pVnR0eG5uTWRUNmJsWXJI?=
 =?utf-8?B?U2kwWVpxSThkTUVxQjdqem5Bb1k5M043OWp6S1JhdFcrZ1lKbThDYXNUei9Q?=
 =?utf-8?B?S1Q3dFcvZ2ZkaWN0dTRSbTVabFNsZGY0ZXptNjVabFFuRWxIbHg1aXFmVi9v?=
 =?utf-8?B?REpTZU5qU3c4Ujc5NS9tVHpBMVB1OWJaYTZLU2VkdGdHandpUjhQejhBN0JP?=
 =?utf-8?B?R0tqa2dpSHhWU0lqK1lRUWpBb3hwV0lLYkNOR3MvdEw0L1R6U1pnSDhnSWsx?=
 =?utf-8?B?L1hwUmp3cy93aUMvK08rVTRML3ZZWkpEZ1JKZ2orUW5DR2FFVWN5YVhvT2JQ?=
 =?utf-8?Q?pl3XvxEJbzL2uiShGK3XzchMG/d5DCQTdk/JVaOyBOFl5?=
X-MS-Exchange-AntiSpam-MessageData-1: lEyAULYpl8XuniWqaVmcwufLDAp8Vm68+eI=
X-Exchange-RoutingPolicyChecked:
	Lzw9FKqxWO+faotoe/6lkPKSET4k7V1rFWw33tweDrN0R75PCINrYE+JpWnIOOzzzKyWlHtUv9fixE8oEmVa7vgF96Va7CNw++oGyxkuSzvIntduoJYK13XvoMNlPz+SvVsXNFzSGo//TobMqWg/93CsqvKwxeh8x9wdoH/L3WLDwitL376+S4dZ1sN/sHtpQM2olGM0FLu7bjiazoRSdOQwwMBwGBDKaIuRI6yYNpd6u+ElQRxgjRV0JBSv5e4ZES7GMw1VNtjvEKJFkgRoEfp3L77E+FB225czIzKn5iw7yZqTSJViBh7ntdJCEhtkOqQWgK+DTxvzW9NlrEiv8Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ewc8ZADltbHkzwIjgoOJBZT9mhPXujHhLXxaHBuARadUT+s1DGWGoI1ZNiNajox6OF4TNx2sZQ6qRcg/DYr5/teuOpetQIRiTTrBgtz6fSbaFexFSDjbdq6k+k2BT9rdttm+XFKF3yt5xkPg2mvUXJaEXUNYX78WL0f1xic0+mSb7DJPYVAkbic7+/muP/Z/66pUQoMQk0uIZ9apASm27loe48x61iw6jLYlO2dn0H02ruLHqxrtBPBuk2Z4cPpSs0ZbCZb/CmAYIqwBCJRKb71ovXuQn8FW22hGSr28RG0ygTBzP8U5bd4ei6ZSpdHW7CqxNqlYeBlzjNYclEtIouHrby655UOmDuzrP3UnFTCLBzdloID6Lk20msUHECkel+3Bw+MIRqNp3AEi4LxRCf5eyp0U9naUfeFvdUwLp6LpLz+1Tg4WZ55w6rY0FyBubszahpvp+PgMPyBXwad+oEgVQLXMTAUioJnEnrGQcrJLN7yWlQR3ukYp3naq26vek5yR2bd0UGi6tWXmzE0W+du77RocxXcaQzhVp7/ZAWm86KdzdCr+lmNE7SBaoVmzyMJodQ3EmEHQCDtoPaOmJzi70u28MzwoAGiHFr7v/OogG6voMZoogad4al5wHlbz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b5a4b6-8450-47b6-8257-08dec883ae2a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 13:08:22.4089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IdM4yQJgSe43Le9zZwNimhTEH3j4tMWqkDhxrAfUdWdAHnsZFeBkBqB3evQkw68ssS9+68BRFET+LW+F9TU0Zs24YYEoVEe8KNkCjK9RmXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR04MB9845

On 6/12/26 1:59 PM, Johannes Thumshirn wrote:
> On 6/12/26 1:56 PM, Damien Le Moal wrote:
>> Why not:
>>
>>         if (ret == -EAGAIN ||
>>             (ret && !READ_ONCE(space_info->periodic_reclaim)))
>>             btrfs_link_bg_list(bg, &retry_list);
>
> Good point, I'll send a v2
>
>
Sashiko also found some stuff which looks worth investigating:

https://sashiko.dev/#/patchset/20260612100429.214341-1-johannes.thumshirn%40wdc.com

