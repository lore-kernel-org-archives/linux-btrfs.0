Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D471125A0
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 17:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789839282; cv=fail; b=IUg/diJx6cHBygbalinx2amh57er11Jbw53EgZaWysbskAG5HHMu0paZ8XiaAfoXgJQRk1BLl306QMaeD02BUnGtWDUniaLhh5yXMr3/oPU2tO40q4xnFdvMuksaGa2HFnm0BloyCifpmvFuoyrN5bZ2m2NFfOqhuYNWvYd5wJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789839282; c=relaxed/simple;
	bh=XCCKgKS2ufnTdqqWNGXwsxKh9NkaA8MirTXepki4zsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kQnVr11Pg/CG2EXDFOXf6AzPA17xZzw07YfMOmf2KGrsHJ1lFoI7WPwSf66QQbUXr0+AtUBqcqZrwySVn+O4xGa00bYBYP+yVZYWN2PFEjVto4NEzXq6idyiVbz8UEMLWYedKhrkzywiaBL4H5DX2Lh9oJzQosR0KIjlvcZqtMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=M6WBzQQT; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=cdw9Ghzn; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="M6WBzQQT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cdw9Ghzn"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789839284; x=1821375284;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XCCKgKS2ufnTdqqWNGXwsxKh9NkaA8MirTXepki4zsc=;
  b=M6WBzQQTF/r8PCk5eHuRflsRGxq+py2IACJWukM3cRvprJRfP9s0wLkv
   CEKLNr3faQrD04Kfb5QVOVYiB9dHck3KgQtXBaQTdAB3Py0NGyBRZ0kNZ
   tRyalslDldJSdiL8Yt+VfAenSDqkA69BVk+cHKzy/y8mnHAAFhqZ552Yi
   /4WQ/7AQF2Ad3vNBBGTPXvMz6mQb9dNv+8Go13rjtco1Zaqnfkms9BkYc
   uzuodU9/KOxKqy8dSaEBuVAmU39ZHw4emLDL+GASkeVz5SYzIhc/pkI/s
   xZ70fVnAlrgx4p3lOxQ8rK+pjkn1HYNPFh1uCdifKKnv4nqJKOeC57/ln
   Q==;
X-CSE-ConnectionGUID: gK5Dh59xSGmhVUow/KVTDw==
X-CSE-MsgGUID: 09mRwNTzTZGUSjpjTFFJ0g==
X-IronPort-AV: E=Sophos;i="6.27,111,1786982400"; 
   d="scan'208";a="154482871"
Received: from mail-eastus2azon11010047.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.47])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Sep 2026 01:34:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xj1LzYfEKzyW0T1vE4qs0mfP4dxbhbZ47CTmZLH4bVWNm8xqCxAwTtUCepa5hRrPcN8cDP/VCsduWLmc6zK5sOoVeZHYu9R5XwygT4D4gyZlFrx0mWIASn+qz/cap6uUe+6qmCcaixBC2ftC7q0IE4RBzP6PLLC60Ej7nGMVprTwvpAaIoDTdKGWLFgHX2Uut/By/hBJPfJACuLSlVQoEOhWX56YVnnHdQOtDswbUqT/pw0PSFHZpIGroLNZ/q0o15HiDsS0V628P0fGufEEZa2MnTS0ilnP17v6dkzVb5MKa3w3R6jRR4Gf3d04IlkV6w0/QWYYUTTD+uVesETEyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ScpDkY05EMjxsAqugtAIxZ7fztR6DWLpvyPI/X/bVzE=;
 b=qD0ifK4Xn9qiSDAfX3/WRlWsGRrPlMQ89DiUMLQ76j6iexRNigMVMbq2mIt3ClqtzrTHzGmz3MGNV0hlsN3iR/IHj5VgoLEkqOwvur/uHKDmWMyidt/7dwfe6G85dQ8fD/ll1z7BJ+2pfBIO4W2Ltn+pKt9UdhVlY5F4Y23ctj1gaWIGGaHI6ww3M/RCIYZ7UiVsDHr2FJCacDdXHpkOMS2UmsHXmQ1La69ns7D70y/lQMXC68wLxxJJHh8M/2C8EXo6qMtYpA5GZJjQh4OwP5ytyuwc80M+hOBlU5bYMADMGbRqZlEX92sVJJCXbY5TQ60NA4qQ+ee7l1hOio5pAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScpDkY05EMjxsAqugtAIxZ7fztR6DWLpvyPI/X/bVzE=;
 b=cdw9GhzncPaX8BrZV1iDmIsvFDykg4IVH67UjfGYqk196ZsCM6jAH7AaA1LCDoTvtDy7GbmUYM+AHOYEqslSI9yriHvA4y/fxfKtNGT5vN3fducIrmFXu63Ey4l6bVQt5OM2oKMP80Ga+WKvSqsMZTmB3FBR1wwk232pcoEz478=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB6742.namprd04.prod.outlook.com (2603:10b6:610:9d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.15; Sat, 19 Sep
 2026 17:34:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0428.011; Sat, 19 Sep 2026
 17:34:21 +0000
Date: Sat, 19 Sep 2026 19:34:09 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: qgroup rescan worker makes suspend fail
Message-ID: <aq7HYO9SKdIaqvr_@mayhem.fritz.box>
References: <mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5db853d61536@nod.at>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5db853d61536@nod.at>
X-ClientProxiedBy: FR4P281CA0094.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB6742:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fcd3e85-bfad-452c-4cbe-08df16743d3f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|1800799024|376014|366016|19092799006|10067099003|56012099006|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	ona/WA8IRHRHinKdS3IJlsMV6B768KxWmR5yZScbS1XSTMzBPJIa3j4mHQdhNBhpX+16a7s05Yzl2Yf5BhDn6FVHNizTricUMyNhkSpIT1IBld0r5cxtMGyx5DKLXMTWIrdfvsEt3gsWudIoUax/SiMl3pDR2GQVO+2HbO/KOPlp+9uYqq9mE/aehpzUCw8UsbH7ziuWZ5JVmPAHphmbqFbh3Mo8kShPHhlF5X2ZNBFEgQSOXx1BLNSxeOH4rbv/3WXVWecIZUS57INjmA89bG9+haVNbi4xOEP3dABkBIL33vSt1qemi3SRGXXeUvBrd8qjU2WKO23j16MXh0yutYXG4ao8n3sXAF3piiTSomK2vWDssdmVtrL887t00oJzegD0DTst/QQu8auZFPGKk/PxtQWafQGb9H2U0tIp1/wPJhGL5BjQ3HYKxv2Ly1vVJ/7ceoO5Y08KKWjQZ1+lqzQRw1XiXX/ZFZWeVhY5Ep2/Kd0XSBNSja4RVjkctqje2p1HXC9A4KG/Uz3fyShsyceh7FscayNoI3LlS3PdL/8C855moHrulU2CPfgpLUgNiYOFy62axZAzLvip69MrfeTBvVk0y82MPVVyCvTgDnsTmeWWAxE+6Y6npU7otRVDFnIv30R/MOk8r6adv0TqGV8npEGcJWkWfovObsxJZd0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(1800799024)(376014)(366016)(19092799006)(10067099003)(56012099006)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j0BcgqjAh2Dh1TTEg8tLD6GVcIxhyk2SLh3sK3RWqH1mcN3r2h0/OpQzNoDR?=
 =?us-ascii?Q?ZheLYK9YDN/iHkUcmuJ/ctsNGlKLEnenaJcpfg8S9kjPDhDrwsmv4CaXxI41?=
 =?us-ascii?Q?e3bYQvAhGrZfaE1/4bnfHwiz3zAASggt9nMMNFCcHvsxya1TMt9ezEl6enOj?=
 =?us-ascii?Q?eJ+iQVcjn79tkXgJrn/0wQeTwoe1P0r0E6ay4ScoSJNL1ojRSd72LRStixa0?=
 =?us-ascii?Q?gqXxNOHqVF/77s4Qhx8/+oj+t6wxwteOR0f0EFw1lnhbzLFVGcGc38FMbwap?=
 =?us-ascii?Q?1FMWdACy0vnOQ9yUvwz9Zj3HspDRH/2jAggVYmR+cmnbZe0od6CLwi0j/GK0?=
 =?us-ascii?Q?Cnbf0nP0d8DVUD2uxmc6t/n1TFcMwTv4c5Incxj8LDpiL/qBD/qZIs0G+arI?=
 =?us-ascii?Q?1RqdLYPjB+f+r+ShcPkd7X3BAQ8n5x4zyqoMNeMpzSKRNEyIzxlS0dQiy8E3?=
 =?us-ascii?Q?9vt1lkHhD+1cZd+ViWSI7qcz1cq+TUGTRPkJADiaJYWWcEfE9fLasXLC461A?=
 =?us-ascii?Q?HCancOm+hUc4J3Ygk9584ZHOxeNy8P770VrcURe7AZkciExWh6XdrudtYl3W?=
 =?us-ascii?Q?YesuT4s5htjKp0IB1mzTrqrZzKJdac8e6qU5Q0bIB29uEdO3wBtloMx0v6v/?=
 =?us-ascii?Q?Elm4EyNW7Prpqj58XzpxVYuOFtbUISY24hLYGQY8YPEjCXlcRuHCqHWwY8An?=
 =?us-ascii?Q?l3OL3kcG3Mr93v1X8NujUBzWww1RxkAr9DoOMQeO55vYlAx8R1ushsv29yi1?=
 =?us-ascii?Q?N74r7HC2dyH2gr+dNNUttoTpF1tPmFXaNqHiJSLFNvfPXqRd+SnDOSDDlvSt?=
 =?us-ascii?Q?vqlrIn0oKuCZDEbNzZtA5YrmcyHgOOoak39KoxJDtyGjzu2qWpt4oLSCGBXT?=
 =?us-ascii?Q?Y0M+9XnIYZtHulEef5XMx14+yKnjPGHdnXl/ucW3cPC3zSFM5Ww7I0BArwCS?=
 =?us-ascii?Q?H/kvDfsfOrRgK55013SpzX4BafY9M+ycr9FosasJmkzjlxTRA5XSpUXi/SGx?=
 =?us-ascii?Q?xZAtmW1QLAfn4GKEdq+0fSB9hTLDhqgBl7tTpEk1rl8sBLYgmRfXjepHRbcJ?=
 =?us-ascii?Q?d9Fzc1w0/UjAbZ6moIT9xs8JcW8Pa4zJrJJgNVQJrClzqH5aUJr7gVYYvH8V?=
 =?us-ascii?Q?3oO46MsA1wdkF2G8e5xatuMGorWcH3kBswd1A/39bZVX5CZcIK443luEMM49?=
 =?us-ascii?Q?j476VWhNQ8UJey9l2NUQHJ3I82J2soPTrLeBiAr3mwq6p0+N9h6cryNPo0DP?=
 =?us-ascii?Q?teEwjp+6R+mRlNljDYtb/q+S7jFYQRTRxriina9hfKIvrwcGphphdrtnjMcC?=
 =?us-ascii?Q?2TrPclw6mUtJiqV9G3fuU/ZKBg3mR508MSc+8ZVhzoxNzGsvg2l68z5e/BFZ?=
 =?us-ascii?Q?CagiCy2ypPvZYmfClim0wqyEou+5RTfKbyZ7Caa7CrTXHsKzN3am66FoF6HH?=
 =?us-ascii?Q?HMvf4prD7ytnCMAaDtl6rPOy0Bu05jBCDU7SY7a1d9iOL85kCOEN8M7f/3ie?=
 =?us-ascii?Q?ic9Q+vXGv9u44Cs0OIyVhstSyQHQEa3SO4ZO7Aj+2DWQJGlnzCXEZpOf+mxS?=
 =?us-ascii?Q?BYXnqENQInWN5w6ZQl2UEYgIZFvaIynCY7FvdbhRp9QHoCefx/sV/772Ygzh?=
 =?us-ascii?Q?FNPQ3f5gxYjQbsErgiSx/vGl1+eolDA4sXPDdMm10DBWUS9CMkZDxxnHCkFi?=
 =?us-ascii?Q?oLBepj4IstGw9wDMP6AKiI3VS0NHC2AXaZrfaH69P2JvHgLikvsIOGbyLoaq?=
 =?us-ascii?Q?FXs7QMlk6UatDZSuNE1QIfn89iSZ9CIF1cNM0dhQ3XhHvGuQ27ekQhPy5Trd?=
X-MS-Exchange-AntiSpam-MessageData-1: +W77QPzBjOkFoKpqOtuuP+f/shjPWVDWHbY=
X-Exchange-RoutingPolicyChecked:
	JWIgyPr4tpdeO5XlzQe07bR0/HE4rVMfHK30vcZ3GIFERu2mwsoQEB10ypraghXb3hB860I065XeiDxnMMz+LM57a7uD6bPSbnRmh9ISF8394Dyw+sqgWOyrLuiEzAzdEkTTWE0M2FycPdvE8nk5GqN5E+pSuWEgm6wgQkyl/soK9B2veqFZ1+QJ9Is/b46EKaUKNYqYiB3WCBdiRni94YcugmRmPf3mVmdfA2/IQlsRDbxaR7FwQj6x4H9TW0jhUTpiG6LxdI321r26RojjdnOC3G7f+/T3J9Z7tjSUfpfdv+v1wU0GOAJb5ZVC880vpC6UkORMY7IOz120QSCEDQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bHbij+6iLYal+G2TirPeJlO3oG7QnEvIilDmxp/HBfKfuFBIKx1q9CnrPFTn6M5ticTypW4CFsOpL5wxLmyBK9Wjoh5hmWy35mzjQWkvO06wO9LOpwZgZY+e23YziOdPcCUFsSJzxbG65uOU8xjSNo9yu6hRRk5Hl0CZ9SH8HHzZceVJLsyvPPt7cwCCkWaBMqufUcRjV6V/4VJSyCGOkiNygaOn5hCy0+SNCDNPrICK2U6M0a3lpaciD1wGfqm/e/uHXKsCX1/SbDeoTp4aR0IV8LOM8iqwKH39x2NubGEaarEM3m0X+HVPH1byx7QY78hFlSuVWZEJy0T5VmxaOjhNL40q5Swm1gSEnArPwND5h2/TItVg5rsp5w3nT2fk/s3aBvhnzv9gHhubXKRUdrU63MDrrmCwrykLelC3zCWnILolimjC7vgDqnb2wF8BuoLnAivL4qjWj7dXWXa20jGjLVMwVPvqGPcHLTR6hQI5WDxfhYKihjBbGL82zzWgSMfNgGhOBT3TwctnQLYrsTajNHxV4/sjf8xz2UYJDbgXbpBgilcXWmjwxqSUxHgh1A67igAFNyhhCTCeKSA28n3FFbJzAZdbnlI0aKLA8YMUGBt+9hFEJ8gXyOKNjGFN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fcd3e85-bfad-452c-4cbe-08df16743d3f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 17:34:21.2660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdZB48BSn+RnSbtEO+pfOmHEqDpqoY5wagI7eNwqZk6+/y759i6oXR6HuY2MQHz3u30xC4x456mKA95dOyZCKylpCKi7Oz6OcKcSApnrTYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6742

On Sat, Sep 19, 2026 at 01:40:27PM +0000, Richard Weinberger wrote:
> Once in a while, suspending my laptop just causes the screen to freeze.
> Initially, I thought Linux had crashed, but it usually recovers after 2 minutes,
> though the suspend doesn't actually happen. You can imagine this can be very
> unfortunate when you just close the laptop lid and pack the laptop into your
> bag...
> 
> After the problem started occurring more frequently, I investigated and found
> that the qgroup rescan worker is the problem. In dmesg, logs like these can
> usually be found:
> 
> [246013.777637] [ T278489] Freezing remaining freezable tasks
> [246033.780538] [ T278489] Freezing remaining freezable tasks failed after 20.003 seconds (0 tasks refusing to freeze, wq_busy=1):
> [246033.780576] [ T278489] Showing freezable workqueues that are still busy:
> [246033.780582] [ T278489] workqueue events_freezable: flags=0x104
> [246033.780590] [ T278489]   pwq 10: cpus=2 node=0 flags=0x0 nice=0 active=0 refcnt=2
> [246033.780609] [ T278489]     inactive: pci_pme_list_scan
> [246033.780642] [ T278489] workqueue btrfs-endio-meta: flags=0xe
> [246033.780649] [ T278489]   pwq 57: cpus=0-13 node=0 flags=0x4 nice=0 active=0 refcnt=2
> [246033.780660] [ T278489]     inactive: simple_end_io_work [btrfs]
> [246033.781183] [ T278489] workqueue btrfs-qgroup-rescan: flags=0x2000e
> [246033.781189] [ T278489]   pwq 56: cpus=0-13 flags=0x4 nice=0 active=1 refcnt=16
> [246033.781199] [ T278489]     in-flight: 205929:btrfs_work_helper [btrfs] for 111s
> [246033.781721] [ T278489] workqueue wg-kex-wginterproc: flags=0x6
> [246033.781726] [ T278489]   pwq 57: cpus=0-13 node=0 flags=0x4 nice=0 active=0 refcnt=2
> [246033.781736] [ T278489]     inactive: wg_packet_handshake_send_worker [wireguard]
> 
> My first thought was that the worker is likely not freezable, but it is.
> The problem is that the whole qgroup rescan is a single work item.
> In my case, such a scan can take up to 10 minutes, even though I have a
> fast NVMe SSD installed...
> 
> Wouldn't it make sense to have rescan_should_stop() return true when
> suspend starts? I think using a pm notifier could help here.
> What do you think?

Something like this (completely untested):

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a1d83ad9a4c0..541735d8fdb6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -17,6 +17,7 @@
 #include <linux/error-injection.h>
 #include <linux/crc32c.h>
 #include <linux/sched/mm.h>
+#include <linux/suspend.h>
 #include <linux/unaligned.h>
 #include "ctree.h"
 #include "disk-io.h"
@@ -3198,6 +3199,29 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
+static int btrfs_pm_notifier(struct notifier_block *nb, unsigned long action,
+			     void *data)
+{
+	struct btrfs_fs_info *fs_info = container_of(nb, struct btrfs_fs_info,
+						     pm_notifier);
+
+	switch (action) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+	case PM_RESTORE_PREPARE:
+		set_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags);
+		break;
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+	case PM_POST_RESTORE:
+		clear_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags);
+		btrfs_qgroup_rescan_resume(fs_info);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 /*
  * Do various sanity and dependency checks of different features.
  *
@@ -3794,6 +3818,9 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 
 	set_bit(BTRFS_FS_OPEN, &fs_info->flags);
 
+	fs_info->pm_notifier.notifier_call = btrfs_pm_notifier;
+	register_pm_notifier(&fs_info->pm_notifier);
+
 	/* Kick the cleaner thread so it'll start deleting snapshots. */
 	if (test_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags))
 		wake_up_process(fs_info->cleaner_kthread);
@@ -4370,6 +4397,8 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 */
 	kthread_park(fs_info->cleaner_kthread);
 
+	unregister_pm_notifier(&fs_info->pm_notifier);
+
 	/* wait for the qgroup rescan worker to stop */
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 3eba8438593c..caa90dc98e59 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -26,6 +26,7 @@
 #include <linux/wait_bit.h>
 #include <linux/sched.h>
 #include <linux/rbtree.h>
+#include <linux/notifier.h>
 #include <linux/xxhash.h>
 #include <linux/fserror.h>
 #include <uapi/linux/btrfs.h>
@@ -234,6 +235,8 @@ enum {
 	 */
 	BTRFS_FS_UNALIGNED_TREE_BLOCK,
 
+	BTRFS_FS_PM_SUSPENDING,
+
 #if BITS_PER_LONG == 32
 	/* Indicate if we have error/warn message printed on 32bit systems */
 	BTRFS_FS_32BIT_ERROR,
@@ -841,6 +844,8 @@ struct btrfs_fs_info {
 	u8 qgroup_drop_subtree_thres;
 	u64 qgroup_enable_gen;
 
+	struct notifier_block pm_notifier;
+
 	/*
 	 * If this is not 0, then it indicates a serious filesystem error has
 	 * happened and it contains that error (negative errno value).
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 05e35eb126dc..b4f1290d1e14 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3883,6 +3883,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
 	bool stopped = false;
+	bool pm_paused = false;
 	bool did_leaf_rescans = false;
 
 	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
@@ -3900,7 +3901,18 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	path->search_commit_root = true;
 	path->skip_locking = true;
 
-	while (!ret && !(stopped = rescan_should_stop(fs_info))) {
+	while (!ret) {
+		if (rescan_should_stop(fs_info)) {
+			stopped = true;
+			break;
+		}
+
+		if (test_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags)) {
+			stopped = true;
+			pm_paused = true;
+			break;
+		}
+
 		trans = btrfs_start_transaction(fs_info->fs_root, 0);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
@@ -3963,12 +3975,17 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	complete_all(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
+	if (pm_paused && !test_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags))
+		btrfs_qgroup_rescan_resume(fs_info);
+
 	if (!trans)
 		return;
 
 	btrfs_end_transaction(trans);
 
-	if (stopped) {
+	if (pm_paused) {
+		btrfs_info(fs_info, "qgroup scan paused for system suspend");
+	} else if (stopped) {
 		btrfs_info(fs_info, "qgroup scan paused");
 	} else if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags)) {
 		btrfs_info(fs_info, "qgroup scan cancelled");
@@ -4142,13 +4159,20 @@ int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info,
 void
 btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
 {
-	if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags)) {
-		mutex_lock(&fs_info->qgroup_rescan_lock);
+	if (!test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags))
+		return;
+
+	if (btrfs_fs_closing(fs_info))
+		return;
+
+	mutex_lock(&fs_info->qgroup_rescan_lock);
+	if (!fs_info->qgroup_rescan_running) {
+		reinit_completion(&fs_info->qgroup_rescan_completion);
 		fs_info->qgroup_rescan_running = true;
 		btrfs_queue_work(fs_info->qgroup_rescan_workers,
 				 &fs_info->qgroup_rescan_work);
-		mutex_unlock(&fs_info->qgroup_rescan_lock);
 	}
+	mutex_unlock(&fs_info->qgroup_rescan_lock);
 }
 
 #define rbtree_iterate_from_safe(node, next, start)				\

