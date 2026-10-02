Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EFC4CEE45
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 16:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790958510; cv=fail; b=ESEyN5jEMtKCRt5vXcqJSzZj2UBJoIJOyyegCicsFaOQcLvGRErKiLiSZZ3w+8c5ABpNZB5Y/lmjMhxSMDO43WdNh8Q+7gqRMJQdeRbdEtc7UsgieszzpVrdLRsKjka1XybreEydLoZ2xw8QLDCyxFRawxTvfW/IM6p7PvYEOOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790958510; c=relaxed/simple;
	bh=xkeSx4dr+5t0/MP+hj4OlxtNRlVXSj52nIIq0X91Ue8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=U/p9QZWsxgmlnlJeHZiVhH6fN/bQT7W32Yh52kqs3GlRuABjnskZVN5ENxmNPQU8GwnPu76vAuza7ZzyeGA/Wav7dOcdku8FPw6zpo+PsVaDXlM8C3SjuRNrnxTXWzDjCFKVepCBneynOufrpSTZKSyQfRibjdS+gep8MNFe138=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZRXCAopj; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RLluOrMK; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZRXCAopj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RLluOrMK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790958509; x=1822494509;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xkeSx4dr+5t0/MP+hj4OlxtNRlVXSj52nIIq0X91Ue8=;
  b=ZRXCAopjejM2t1H0TnBx1+PCUqhh9WMuTuHXWrPoiVwIf3DNuXOCEeK7
   NIZNCdjEcKmpy4rWMOnhwXKlGSd3bzsZ7AtrDN+R78bGiHvQQhG2wFNCK
   sn8UdZYVv4saiNr+dqOBbMyjuwyE3b4q6hC6DriBM+oSNhRyhbuVVRez3
   UwjEkrOjXOamqQwzBhDnPOvJMcEfrZWWRj7W+rAECKsk242xV+fRFTd8r
   l4ZAM5a6oW1ItdXTC2qB9Cu6aZdwa75H+dZU+OsQh6H4JyqcxmA3YPrfD
   9jBCSikMUAGlzM279jIRuxj2gGlf8+87+0e28wttroVfXJmzAYCU9xjq3
   w==;
X-CSE-ConnectionGUID: 7DrojHNxS1mTBJhE0oCGSg==
X-CSE-MsgGUID: lCVnRBPUQi6fFptz/ZHatw==
X-IronPort-AV: E=Sophos;i="6.27,136,1786982400"; 
   d="scan'208";a="155543973"
Received: from mail-northcentralusazon11013032.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.32])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Oct 2026 00:28:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JCACyzDqhzpce9tBLLEINNSVl0mT9Xy/wWUaopJ01B1pZckbgOaFE6ZomUB2doN2/VGu9FZBlmJ+YYkppjlxc/oUyt+6Cq+xSHi7pYmnDDNyYPHxnd0X34Z+pj1swtHkwVG7INAKCFSVqjubIebvuyB0FFuh4l/unh20vAPswJvGtLG/zdLGxExqaC5cFDNahl7NzwUFdhDC2Jrrq4UE9g5kXjR9Y8Ixy0jyM2IMy/SmEPoJy9JTjmlt/Nb5p3Xc8jNXN5tu3CldCTgTI5mF9S0vyvsqtan0NvSQkCmb/Nw6sE9hK1wrvz1sbs3mt3w1H1vTs/FntArDK4FuQNQlXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDbIn9Ss7G9PUzgUo3gnfS6Wft2twon4LxtsVsZKyJs=;
 b=TR4w2MCsNQk3CZOUX0C61XsPu7wk5iZ+ClLjdHBtnZxlWWLl/PyeQbgG1kmN8v7M8BVGamrt3nxV4/hDO1/9dIAcOkSgK+T6/A+LwFf6CSiLxwBsLymHQy3/jOaWCHFEWVY+2nt1usOxpkVn+2+gA1EW3cS3t1ddCFaYQTSG7EHr5fn/br0zxPR7blb4ZH/OBdHGmiBRVpN0UJ7dEUrxZkFBhItkeAJgi5skKJR5cVe70UA9LebrxY11x26In7S3asFKfzyWexOqil2sk8Q+fh3rSOA6eKzS2F8b0upRqtt8UUdLKEuyrsDtPq3LUP8sD7KOxIn0Ih2HQcILWwAVDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDbIn9Ss7G9PUzgUo3gnfS6Wft2twon4LxtsVsZKyJs=;
 b=RLluOrMKD2siB752vmwzL0K9S7ajULQiqFQip2xw/hVWDehv70vioAG1gSEGaZIs2tueZd+zTPIwBygbC/wChcgREE6A6wFJ6b/pOXTHeEcbBBW2lkRr9xbt4l6kpJAaTDm0fEs47KYwIxMuLAIAul7AOhmp99NkKm/QoB556b0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7344.namprd04.prod.outlook.com (2603:10b6:a03:29f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 16:28:25 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 16:28:24 +0000
Date: Fri, 2 Oct 2026 18:28:20 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v2 1/4] btrfs: zoned: only change active zone counter on
 successful (de)activation
Message-ID: <ar_bh6Ju5kSXYn3n@mayhem.fritz.box>
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
 <20261002073715.2191177-2-johannes.thumshirn@wdc.com>
 <20261002233856.C191.409509F4@e16-tech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002233856.C191.409509F4@e16-tech.com>
X-ClientProxiedBy: FR4P281CA0031.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::15) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7344:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eac7966-b006-46a2-acb1-08df20a22e82
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|23010399003|366016|19092799006|1800799024|376014|18002099003|22082099003|56012099006|11063799006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	oNEq4rNqNYlUAO2ShGYqS5ZsVRrguWXAdD14o5NiILa2yfp51GVUMlCTu7bCYBP415Jsuv2F9aSh+sXVC1+SXTA1W1jSsUh/+LZHWm8ANf/IFaUmr5aM1h+fDoQ6KZ/vbZyRc/xELapEP8RGPCdd/6VlfzgGg5Y3oSHR1FOKEtFrOfuN4Eo97iMtXcd1hGtARC5GTZJljzrO3Ey9NTJTogKQ2+SKP10DIOkGtzaqmeeMJVDDpJv1l7NBrz9Ck9SGWMBfA7UBDvI5i8t3LSnNSiVUe5Ov/EHTMXsUEISkamFEhWelwHqS8tzG6TPhCZi0/iwBxgu8xOulu0gbxMIEPkqvnwlm9HakrGc82dUjpAocykJ0OBui64kGtn1Pye8t7Y9EMkv5kSVI10CIgfKulEUZOE5aYe2tIOEqzGOOnxYmb4uyqNXrqpTm8PWfetu+uqn2zdKXGr1kzJp25fRMDoJWKygVJue7p469kZ7/j98NY7101Y+9DO6U3ie5d/eoE5gUu6/dMC2q7k1L7ZIb0sKYKOMKb8L6BAs0jNYLYFNeQG3ZCb6vccHZWLA9UdNh3Z2SdmqbTtwEbTpbXYfhevUPKYvkU4cJycMB+NUSOm39JYZoagB2gWz0E/prlwq6rNMDTAzLsQ6HpivOANRHBXHmHuHn2TaN8VWI6xUBGhU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(366016)(19092799006)(1800799024)(376014)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jkOAMxEcGbfFOBTffKmZU/WI5TlFxB5WaBxHMq6uWCNgqbyp7rgfibJSCYy3?=
 =?us-ascii?Q?QoQboLvGm3EEdTdO8Upnp2/Bc2cPGoWobz9jdgh+xVDH4Chu6AACtOcqEc/e?=
 =?us-ascii?Q?CRiSw8kfHhsOJkHOBelCpi9YmJURlR0qkNo1qg9y4rU/Ze2gzYzx0RMcA45k?=
 =?us-ascii?Q?saYpCU73/4t5KCgjRq2dd/pIy7fFgn9Le8QvxFOp3n6191csKjf5TlLdFInp?=
 =?us-ascii?Q?mSKyPN8D/QJUMpNRgqRceHJ+AqUpjh6JsZVRXeCLGEChfRM2mt2mS2cDDg9N?=
 =?us-ascii?Q?wERQI4F6e/ook/OfSaIb8hsA1HJYZQM11y8LdHvioNbM39Bw5qF+1L65JumP?=
 =?us-ascii?Q?KDtUhHMBb0T634r+lwOoLkal4OvFj+8OKfh24Ul7iBnd12BNr4KuZmM6xItc?=
 =?us-ascii?Q?w3tVHtilXxgGToBaePejtLh/OqrLlwHgJ6BWUOTyugXvTncI6xlJflCjjSZ9?=
 =?us-ascii?Q?5KvIE4FP9B6urgLayX7716t/cx16Mgx7BbDaBU1Ri3nwo+7YFavzNjQsomcj?=
 =?us-ascii?Q?JaRiNMgAwCsXR2ABYcT5PgYk58U5BXgP6NxhUtE2wPrSfCWje9t0FCfg9h6c?=
 =?us-ascii?Q?HOFGFO7dFfo5b/6CZtZmLlBinB+LI5My6UfXBOpfUXph97fRdefpo3MveBFQ?=
 =?us-ascii?Q?2csgPrbGsiGSrj7xOp2pF4n+goe6B3kUN/NzXoUozsTrx/lK8LWCEQHgeBPr?=
 =?us-ascii?Q?V3x7RbFjb6eKk3DgmAbzY52EWnmIoTVKVSG/G7WGr4O5Jna4z9FIWwH2SNO9?=
 =?us-ascii?Q?Z2ScppTK+0qB0chzf7QT9YsjAt0rNTzZsqRsFKXJlitPQNNGKNBS0TgYdSe2?=
 =?us-ascii?Q?LQoGW70pwxd1PdK/T6NFBdtcdGYVrTlVK6eRkvvRtRIr47owj9tQFRD6D38r?=
 =?us-ascii?Q?BrtHojYS4xtQPDOvYvxD0W7DP4p3vVaGPtKUPYkNj937GoLMoYHG7eEcGyXc?=
 =?us-ascii?Q?IoJfXjhJxXL7FeG9e3vpsRitwe9a+aI/othv1lH5ly9andnkznYhV0ym/O6U?=
 =?us-ascii?Q?A8lqwqPI7h6sJ37SshPIIeHAK13hEexNqf8q5SgDYCGexhONEs/OIQlsAHnU?=
 =?us-ascii?Q?T3gZZihcNvsFVkluviYQUrShoaM6arYFUlm4KVJKKqxwPIagsaM5jQFnkaVB?=
 =?us-ascii?Q?MQMR03i3fWih1+OMCvzziPaJN6ozB/HadPIDff9BeAN7HViqrZjb4VLUVOe+?=
 =?us-ascii?Q?XefO7Ln03rTFDOwOnrjGlNe0ZuOIr5dZm9rD+JbSLMrWL3EdpP0ve0s8WgXa?=
 =?us-ascii?Q?WS7xoXOPtluZEA8UASig5zSgOWY75P1GFvo6kvCYhudLw6/wrJ9JQM/21oVE?=
 =?us-ascii?Q?ljpad9tLQckvLBJ6m2w1CwPvDjLusJq4ZKRxjft+FE7kNYSTSA+K9sjlMEu8?=
 =?us-ascii?Q?qBs+KysGncYTIcTR29KnuYtOcI+XSWZotb51sHy9cRMkCjo8vNhl5dhxnomQ?=
 =?us-ascii?Q?TpDv7tjYa131JCjNu8ZnG9lUgD3Tyu/2+G6k8ii0yrdvl+DYWhKj6/eowz7g?=
 =?us-ascii?Q?s3WWp/jeh4ibT1lnSoL6ALgPVUhVh9p/iPtQK2hoavRU8FykCVDOuGl/yXnx?=
 =?us-ascii?Q?UjqrDqQQ/vHl0YpbB+hYXryNc/6p6t/dNMvkyYFbv2yPGzP8APM0F4vS0v97?=
 =?us-ascii?Q?wGDcZakDJrqX21ZaGR1WbxFzAr0hDsWZsriBKVtEYCbs14dVLQaHd39xGME8?=
 =?us-ascii?Q?sXp7gxsg3euhOhlyqkjcueLveVrK9CoBsxigWOnR0vD4Oqjwp2Foo/qanGpH?=
 =?us-ascii?Q?vtFZckcrtOPuToM5t9QyKWVLe9EMz0Qe8K2avDzh/TW/bGWhSJFHQljljST9?=
X-MS-Exchange-AntiSpam-MessageData-1: bD6wRX88Qy1vXl1BtzlJDPtczWLcXTG+dw8=
X-Exchange-RoutingPolicyChecked:
	0KfSVRykDneom0mwikGXNRIjEnDnaZ+6Xlxk4fUDl9JDwYHmGOHinTC5HpWH0eGlvjODpODU9cunPEaBAeI2/sfyxjzDAJ9c2mS3K9lV72nijmFKjFBTbmNS0+ft6lIxHF7fjg5Mb2Gq7jkGFMbrutYBmwD7JtV39SMEtE1o5nirdOOh3b8Efot5v+LTwhj+dlS1JzAkt25xhhgqdLA5X5aj9E+y79ToNfAV7PRR6PKbCrl0JQIn4pR4lERMfk2FX3HXuXH4INMljGWD5QL8xeuRaSmtXilzbpBKaem5bZcyZU4wG7n79pFBr95TJKe3noRA9vZkKl14i+swAEfMRQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OOmryV6/K9DeopxdK4SYycuKuv/5qmNXncX8H7fh2og67DcrrDftArQZxwn2My+cXc/wTGQpXQnl527njzClrAllT71NdhqC40f4h2rOhqL9NF2sZ8vYpz9hfH2z6FcwvxFccpUTmeAKoiIsEqwC4pGpgdhpgBJ74z1Oo6jw4buKvZ9xdL7Jy7Bee8lRiNJ/t1UyysPqRyRiMl2aFug5kGkJzgMnb+JFipt8fVm+FCfxwSFxFsF1t5fXzD/jnp8x8Zw69wVCphn9Ue/iaA4rIa8aIQ3icoutSuUNg/WQe9JIXLDvFrJd3gTP2kWT5OsjLKO0AeyFhmfNehR6vVX7vGxDTpYeF5dogzZn5RQRG5Cw2c5hqnzIr3EsdcLkcMATXID4t2L3Boi5VZiOp66Cu2Qr0l30bo6TuV4v/hTvJxdLm8jJGRHqoikR7K3IrZsVcF5t3yuslC5yzbf7iUOAT063v3+dNUyLYxJgAIO9w+SMubReHG5zgUpnuhr9353Ervos0HjVzQsNQNy2rZkMyh9+8vEWoMRQQBdVsG50s0De9BqX5z4E/3krpwonU3C3Xk1BaKD3+SKRJ/J2t4MB6gluKKPk7rE+/2XiYEDsdeh0Yw++b/fWvI5RGex+s4dN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eac7966-b006-46a2-acb1-08df20a22e82
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 16:28:24.7966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /rbXVWZja2xZfYUPMzzPHz/uOzoT84KwDBPFrhhAqph2OTMeKU8jVWmqf0Yf83Q0t177rhevCWad5Z8zJxZxXIg+TgT9VyG7+fqzpXu/sxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7344

On Fri, Oct 02, 2026 at 11:38:57PM +0800, Wang Yugui wrote:
> > @@ -2411,6 +2420,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
> >  	u64 physical;
> >  	const bool is_data = (block_group->flags & BTRFS_BLOCK_GROUP_DATA);
> >  	bool ret;
> > +	bool new;
> 
> 'new' is not a good var name because it is a keyword in C++/Java.
> 
> 'is_new' just like above 'is_data'  maybe a better var name.

But this is C not C++ or Java.
