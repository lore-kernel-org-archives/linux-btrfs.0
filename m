Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FCA2E0B71
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776956292; cv=fail; b=n1LHOuKVfKvJr+A1PP7T+g33syqIcBLrV4H1P5UPaXbIUMmjggZVdgEASrW9/wMM7XSDMK3EzKufyprjSKk6XI4QkuVadjk6/QbqSfT4iOzQALYGO0NhL3DGj8K+blkVYhjflR6ieMnXuAm31M0OWTW2etEfoaC/SGVoi93YGU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776956292; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DONfODdbVe8Z+CkQwd3bXqG74sSv7MhIi4KJqcX5E3JMlsr+UKlZZDAdafgArAwzwIousLezaDlK38tCC3borvyq986e/urj5FfnDImMv+bbZkdBfaMl8zzJMeZ8F7hkrq0WH5EmbqSzXdV/V+PSOvRjGRGNYwJqbvclcEY0w3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HXb0MVJg; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Cka0jorR; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HXb0MVJg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Cka0jorR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776956291; x=1808492291;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=HXb0MVJgrkUnWrYTB/y4g1HRVXwnCzr2uO0yFe1EXzPHqmubeZ8zY9YC
   sY9ruF3MwRs2PrwdwCfZrFXtdgNxonYGmuMUdo8sgTyS0HTfnMrJhEHpy
   PiTmJoSgnaR1TxCj1Y6RyhILJoTV0CdPM+oZzT3hEUv4ElYPDhrwzzYo8
   cpDeVc6eUClqW+teI2btHAMJsimTUgSUsKsf5Y1gi24VTEGeqaGQ4TyPd
   5gYWds9TFRBwOuegHrozsF6G7RyGNBbzs5eb14wTWi5w580hh7fEHuLYP
   6Ar9zTZ19BYpsjqEAAE5I2Fg00zDUkQSpWGA18r9S4oc9DtqVguh/JcYC
   g==;
X-CSE-ConnectionGUID: K/ByaaWfQ9eCmEC2/703zQ==
X-CSE-MsgGUID: 1u9hmMxYR8eH92e5cgWvlw==
X-IronPort-AV: E=Sophos;i="6.23,194,1770566400"; 
   d="scan'208";a="141353333"
Received: from mail-southcentralusazon11013034.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.34])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Apr 2026 22:58:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Db46UW9f0tTFh9ko+u7Nb+lUfPPgx1XFmeglDvcLzZmCP0FFcVcGK1f/wjSQIdZEDqfdfpe/9GKzAAyPLgvnrYyiSwDCtakomqH5IdnlafbpeTs9bM9q4BhrPfP+pzJFtol18/qobcFExzRFxBkavC6ueHJavrACyDlAW8bE32eeQiWXh/j8AN7RIQSU8+vvvstzZg6Aafjd5RZE+UiT9cnsoYIPbSqZKaCQdG2rZBYTA4wK/lzYDWz4vEFVcjt4nminmR9UWeaDn2N/E1lr5JQvuCekp7cBELlxmL/4I2YUbOteW0KEwNAYfx4c4IKAOxEYLvzY62kAIbCkJ4RbHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=GcV/xjwGo25VHzl+6pN3lTn/zBegDjxfocyV+cDLia6RhP7qjav7sxxrfVwM/nnq0j7tBVtdMUMzH1yGEJodv7fbUPRxQOC/QjnWyijjdP4WkeYJ5CyY9LYWG8SDf6z9hj9idxGk6KrDp+WujN+67ectx1dMcIGR8VoKUGxREcWc50m5Y2+OGQIGo1g1kDZVnNO3zrPwr+CI5lIfnssrxQyHvFodERHpYSgztSWZRtAkE0qaohroEhKKZBHYOEL6N8lPCDrZVRzr1Ii9XZLcecRriQLt0x2qZEdMbbumDG6n/Imms1WzGp1ly+/BryjuRfu1MHskIWHq/F9uhPaPnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=Cka0jorRsemmOXhM17H2VAZXPrGJd/kfULiwitel1RcvQcudQDi9FucvjN31C52oT7YyXgHoX7UYcd8j6As6fgr7Qu+eDRZ/K7va5i5XvR4nOuBRB4er2IUjFii8KKAXfbHUgpb26COM9+W5oR+XU+PoGWvpu9hDi01Vo7HHtQQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by LV2PR04MB9926.namprd04.prod.outlook.com (2603:10b6:408:37c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Thu, 23 Apr
 2026 14:58:03 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 14:58:03 +0000
Message-ID: <9eacb0f9-26a7-4ff6-9e34-7609f58c1a1f@wdc.com>
Date: Thu, 23 Apr 2026 16:57:59 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: change return type from int to bool in
 check_eb_range()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <1a69f68aedf5ea12277401b8ad5d0a17a3ac4a25.1776952936.git.fdmanana@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <1a69f68aedf5ea12277401b8ad5d0a17a3ac4a25.1776952936.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0448.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c6::15) To LV8PR04MB8984.namprd04.prod.outlook.com
 (2603:10b6:408:18b::13)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR04MB8984:EE_|LV2PR04MB9926:EE_
X-MS-Office365-Filtering-Correlation-Id: c1a02e08-b6cd-4822-a925-08dea148b811
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|19092799006|10070799003|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iK/TgFZ2hb/dQm0eMA+kfX+iSUqFg7BifXHTbBJIP0IQnN+r0yYgZknFlWXZZYxKGmsWODgEQdym5NmLRJZ3vUHPSQunbKGlLSzEzlnhp3irad12WwB2s8Ph1vbacudcnAFCF6neRDXAUcQO1F1YAl/i/VyyPlJqNsqBpOKPKyeS+YadDstt4an8s8xn1GdHUWqHp/3Y4PTKUNqhjgmfBlS3h8ImZCufmHcYQeBaJKSqgwD8TO5xl80Mczc0LfZSgYokfAVLrdog9bj6pE9SjSW65BLP7w+smm3TLd2ROYV8B11KHTD5vCb2zd80sCgmRXe+hWrkX/ONJZkWe+J5v6MynLizJFxHKTd8jgU7Qc/5xt5Ct5aT9SY4zxxp8Cd5X25xzcEeSI0Hzk9BSkScuQBb0JHY5u1w+fIoGx5MOhAIUkVdSrK032XEqnDcqjb+0V8V6DSmKs5a+czZf8SF29HNvL/T1MoUWhtBTm8U9DLXk0qZzaDFZxyu8iMhmeDK64tiw3pNpW/MQLMDmOXeHKxClUvxOKJ75gyCuKauBGe9FzLZuh7TaUmD0dQv8DqVmw9nfj+iPKAb2XC17bqcxyXbrsnKtSPdC0U5ujftTT5acIuFzmtv7uoiMcrU21/aV+sfTtFlsDh8bd/dJ/S9qLCSbsXGOpB5W727P7Y2er9CCcECSZIn52rkWdf/SvoU0xf15EX4xRMcvBY9KyIJRwhG0RXJUHHqH8xxtqZeDJQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(19092799006)(10070799003)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a09Jak50SGpwRzEzZXVadmFZSzQ5Vk0vZ3YrZmtUc3ZFa3hjKytoS2tndFpJ?=
 =?utf-8?B?dHR3dTF6WVpLRmlnWXJncXdzdFlMWklmRXhyVVVoQkcyU204dlQ0NjhZdEE2?=
 =?utf-8?B?a0ZyWjRLcGhqbDkxTk1FZGNLQ0NQVzhYL3ZxTW9UeVc3V2RYMkhGMFVkRmxp?=
 =?utf-8?B?VHZCMGkxbldhZDV1b0liQnZ3YnJhSWZCMDdCb2hkR2k1YktkQllFTnFiaFEx?=
 =?utf-8?B?U2NtOEVFak15c25rVytaQlBIRXJ6Uy9PQnVDcXVROE1qcXRlZWVhTXhITkdK?=
 =?utf-8?B?ZHFoWHFLdEtWd0lOR3M4djRHWlA2WWlNZVR2YWU5MjJjc0lkeXB5UUFubjVK?=
 =?utf-8?B?eTlEbzZ1MGRycDRRdWQ1bGlhZ05vQWNTM040UFd4UE5ZTXZmbDQrZzhpOXo2?=
 =?utf-8?B?Vmtpc2lXYkM2ajVKc3dHN25NQkJHMDNod0ttanVVeEhkc0VRNXpEdzRHNXdB?=
 =?utf-8?B?Z0RkeS93WHNLWERYblZlaGtOM0dOMjZ1YkI4UXp2WkJmdlo3MGVRMUZUTnIx?=
 =?utf-8?B?UUc3M0drMitxKzN5K0FBWlJGSXpqRFdtcksySGgvMnNIOHJReldMN3Byckps?=
 =?utf-8?B?Z1ppU1VvMFRVTVMwY01qZk9oS0hydmlyY3FKNlRiL2tFR1YwaUtPRVl3QTc1?=
 =?utf-8?B?QVZ3dzJQWk42VjkxNloxb2pYdHVXMzNYV25UYUZhTTZRdUtPdjhqNWhod1Ry?=
 =?utf-8?B?WUkzc1ErLzRvVVFmS0JwRUZvanlMMDFndnU3SEhVeGdmUVpYaFRYY0RWR2dH?=
 =?utf-8?B?K2ZUQUcrSkxKQVJoMjlPSUN4R3FpV3czZ2VRWnlVT2Q1aFJxd3BUVGZtQXZm?=
 =?utf-8?B?U2FWZ05Yb1BrV25VQXhSSHkzWWV2cVlCZ2lmcGVDRlBlSXZqN2IvOTJKS0FP?=
 =?utf-8?B?dlVvSUxycjJwTFJ2Wk5JbTN6RDk2bTlXOENRaHE2OHoxT3JHYVJGT1M5MkZM?=
 =?utf-8?B?ZzZXMnZCaUkvV3VqcHduWG1FUkdkRjdjTmxEdkFLV0JmTVMzNW9ZcU5KK25i?=
 =?utf-8?B?QStKS2R6MTVwaGFvQmVEelZ1TzB4S1J4Z2RzRTZObkRHMzlzL2YrNlc5RExt?=
 =?utf-8?B?LzFlN1VGTkFiSDVhQWR2Tk1maGJ5YzdhaHI4SU4vMFFCRE9QS0hodUhtYmY4?=
 =?utf-8?B?cnY4TGtCemo1VEdlL0pVekZ0Y2hzdEdGSDBkZlBvWGp6elpNTnM5N0l4bmxs?=
 =?utf-8?B?QUk3MThKOFdzYTBpSkpNOEJvV3lwQzdWTnBZMjhnalkzdml3eXZZSjlURUto?=
 =?utf-8?B?WDZ1NDNCR1lKV1hpUDNqNHp5MmN5cG8raWNSeGgyeHhoc3ZScDRmUlVjMUk2?=
 =?utf-8?B?a3NzOGJMUEhSbG5CZ04rajRHdUd2Tjc0UjBqSkg0aDZUSmxBNkdJaXQvcGx3?=
 =?utf-8?B?bWNzWmVJbHJOL0RlaThDWjJPTDdkWHY3ejFJWlFJUkpaYTBKWmFkN0NJa1Jy?=
 =?utf-8?B?MjFwSkJ4Z3RYREhmeDNxTVVreG10c2hBdnJpd2FBbSszQXBkQy9sdnF4TzJw?=
 =?utf-8?B?VWhSVVhaMkwvc2lESDBqaFJ0Y2MvN2MxZHFkOURNemVueVJhTUtCeDh3UjJB?=
 =?utf-8?B?cFg5VXQydGl0dTgyQ0I3SWF4dXVXcE9SNFRGRlRpcHg3TUFCUnZ1VjU1NXZL?=
 =?utf-8?B?Z0pOcTRRMk82VnJMeXkzaThrNnQzZXJSVWJDcmhCb3RuYWFsWXFDVXg2bmM5?=
 =?utf-8?B?TytySytROVNxZTIvZHVmZkIzZjB5ck5KQnFNMGlXRm5xYitGcjE4SExXcVVo?=
 =?utf-8?B?R1BXQlJPZjQ4VlRtdVZUQjBFTUR1SU12dDQ0MGZTZlgzQW41d0Fhc1pVdlZv?=
 =?utf-8?B?SldneUZFMzBNamM0V2MzVnFURm5QT2JEcUdIaTZDZkNad0htcEtKUUFBclRl?=
 =?utf-8?B?YkpuZUo3SjlkOHUrWnZ6OUR5WHFIOXo3MG10MGpnSnptbXVpQVFubXFOMWtl?=
 =?utf-8?B?anRqdkZKRjc4VnRHNlFMMEM1OGNVR29lY1dxWjd4eE1ITTlhVFRxWU9xRzAy?=
 =?utf-8?B?YjExTml3MlN1NHkyYk92cXYwRzU3aUNYcExXVTIzN09SVHkyalZiYjEvc3Qx?=
 =?utf-8?B?WVFrSEJJWDYwMHp0YmJWckZ1cEkvRWdjQWNlQS94bGt4eXJhRWlCTHQ4STUv?=
 =?utf-8?B?SXNwY1N0SVZ2MEp0bTQwVXVSMXlRcUREVUtWNWswOUQzc1RKaE9HUzJndjB3?=
 =?utf-8?B?VkRjeWFocnZ5Ny8ya09ZSmg0VlpmaGZ1VVB4MS83dXVzZDVvcE02NEhsby85?=
 =?utf-8?B?NDdmNEpnZVdMSGZNTUdnbldjRCtGN2ptK1FiZ004Q1MxeU02NkZoMjlZR3Q3?=
 =?utf-8?B?TVNBNU9GMXJhellDRVduTkxuYk5GWXdTdUFBMko5bUpieERQSmdSQzhmWkxp?=
 =?utf-8?Q?c9wAjN/kWeP9SPWRdgsq8+f/T1muX7RyDwia3d4eVXFlD?=
X-MS-Exchange-AntiSpam-MessageData-1: 3Kxc90R6rfLkrxQ80yUfdzAvswho7n1ceB4=
X-Exchange-RoutingPolicyChecked:
	P55PmtPmf9gQtB1OTvI+ROKyM/Gmx2QJhQXIZReETJh9BHaLp1igcGgD8YIHwYZIzG7mKrQkGPLRozQTTZ6/199YXQlO8CSLVKV781oLZKcwtOuPUf8pWft1VU/I9VqIhKayESRaf8JD7+9+diuxQg7DTUgUqGz3q/sIySUI10xcxNnJS5dHO3J54Hm0rkAGi+vLOUco4vCJ8Wis4XgH96sHdfZvLhimBwnH9Z+eHwGJa0AU5PFhFB6DYMMB9TYEB7MiAv/VhMhsXVbigu9JILKE6n6yV5qBVbCpeFr/V0Z+/3SKxZHFz2bIAdwWtQ3JXo7ZlCIcUFiU6AQcBmGooA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Mm67vZfK3GeKmi1FpqUrI5ePx32FNxAaE4TA11YYBPeFoaQf2Eg5o29V1+5jzEEiM9p1bgTmq343iybtfSxWUjvNOhjgmnn/vwoiTn0z0Phz7SPiAZg2MtThgwZ7zqxfyXCdYKBCdVrIlt0jCi/OwJZMGeGlt1XHVptnh/M6uRs3rRTIHhkCFSFuPAsKw8RqwzvSWWRwgYfw0ndZtuA34Kord3MM6jIHRZXI7HiUC+PX1t5Y9qTWqhTimgcJ/4g2S9Q/BRMzv8g0OZCGmWDjC3+LosYrJzZBEA6tOzgQerIku7Edq9mrca3W/qZICWudETJqFTE0Ar3mf89Y5clVxsqNxJsElagjPVIo4pwqwqfKHK5NPcf9iOVe4z+bJP46TpxWq5xl6L21kXeo9Go1U9Cgbii8wFNKeT0WVygvGy+LJ+CbMAWbqFfD/lt3qLaojfDY+CeJZzGPjYqwWlZ4GknbQG3fYsDB+gYbiuq08rqq7B5cJA67amKysc/Huhh7ATkM3aFBnKbBZNSCPvGdJtKK3T7uYjzt9sutzCSeclgAkdqJHNWMwkPYX+tFzoKuqeDhe4FhLxyoLGM7MqJ4qPzorvOuDU42jjjXh7J5nM0RA3MGZBSg3Z0RT+ZvMfLJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a02e08-b6cd-4822-a925-08dea148b811
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 14:58:03.3652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fc9dvNXFVPzh+aDiLWs3P9/bM65mK/sIWf5wCifz+p0yVeNVj52yN233rOhF77eri/LQVOkxrVnekcTb3dfu62BqTe/cMwyK1lWPTI0XROE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB9926

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

