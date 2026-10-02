Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FCE3E4C61
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 07:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926395; cv=fail; b=fDtRWJJNrb3vgMyYZ63xZWGZNQG9xTaj78wKjQTY4tXShhJNZF8F/0VYVQH5UrThz9gTeX2bfPhbWoyrgnDM3wepzRhFTlKow3yv2i4PT9oQUwHjzWVWWRCi3vuDwfFCob75RVAmhULyBrFEu1541V6QgUsm6wr8L6yD0qWYibc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926395; c=relaxed/simple;
	bh=S9GmIiSIumNUF+raq+aRhgdbI9ALrh3vDNyyrLCkSpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cUIrY81Gvp4pHnWhH4583bQlyaVKnZj4UGygVHkW/S6vbDEfVEKKDc9itpU7ecqiwUixmRq+i0QqinAqN0+fPvNmieN0fDTDApVz97Qh1tdoBSKUK2SH6RDjY2H+kI6QdMrq1KELrUTfoU31EifbS1FM8io01ZndWrS1w8Wu7VE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cz1YC5fu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=qFalCLNW; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cz1YC5fu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qFalCLNW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790926393; x=1822462393;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=S9GmIiSIumNUF+raq+aRhgdbI9ALrh3vDNyyrLCkSpQ=;
  b=cz1YC5fuJe1vDUiAkPoEyoBk7441XsE/gTqloMkfTT3ViAj4qSG3Pu2J
   hjgS0cEO4ep8+S5RtMxrT+o7GWYfhWJCXT2h1ai0w3Pw0FIXsiXABEusg
   zca4U8kFFeDg+MqBci7WXrAh3xCnaUvMbbugDFlYydK64VAfuFa81w9M/
   kGWDzrGqaT71YctAk2WoQXn7NH4ABxrQA5lnPXJvxjRwLEuvhC6gLFJMf
   x9LPXIvOvh+f4fIhGCases4W2MnsrgeapvKnHnJgZKidd+Xw3OVF+UIWB
   1+SwCu+uD995LvTneuXQO1QmIcD9m3K0dXt+/PHXfAJEjbM+zOWsNuPQl
   w==;
X-CSE-ConnectionGUID: i5hf4m7sTjyEz1cAr/Gd8g==
X-CSE-MsgGUID: RypC2YHWSLqfXyLgmAV1tw==
X-IronPort-AV: E=Sophos;i="6.27,136,1786982400"; 
   d="scan'208";a="155512667"
Received: from mail-eastusazon11011049.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Oct 2026 15:33:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PnXVO/6ZbKf9RBoN9qrHushKXGlIKZbN1voQYUJVS7JtOgIM5MPHG4AM0ob4CI1ftJ42AzOwOtxwhXcfV57+6uhdXVfIFTD/DrtTPySMsVkgqozptcikmF4cDEQu93rzUK04Z+e4Y1ULx7J3ziN3IDLdU5oy3VQUFqhocza19kqu6y28JOd8dZaqSgRUQrNVicir5vLQutZD0lwCfuah2qmE9Jclrfj/6XcpSVN+xVEaSlYrrsKGQdrGuGXdwC7jaGLpcPLH3trDBDzZUc62YwwGChvoDKzRDf9Wv3T2hJfZoTTLYAcFwqZ5pRp1a8TCPBQLLOXB4EHTKrzwZ9tY/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTQR0Gr60WbLy5enJ+7XTt9Y4AAwKORoOuYpKZTz8sg=;
 b=m/a3iqTbJSostH49K40IUoNhgQOkFCo1zZeUfV2mT7OQsQs60nN4kRZvfO5lQIjAzJbNbnfCpZ8CkmC6WOuAmyMOr3pW6YEQyraCBggdpYZhSQF/4ux7MacRHOIPueEeLMkvvO9M4U4bv63+zMEtEqlJ0dggmC9Wrrq3bM8L/Ml7mXZCKdNRRFs44R8Rjv+5uUdTbPg0NBhPp1pSj81HzSqFQ1LWVQfY+q6rHI2Ue4hBcEh9q/CBAplpKW3pUDoTUtfeDVjQO3gGO8Cp2C9bwFLdLeMfSmyy0SE3p2AcRnz02SSdIZ3aAt6T8RdOELo5jWJsfMdG8bkAI8jcbWdS/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTQR0Gr60WbLy5enJ+7XTt9Y4AAwKORoOuYpKZTz8sg=;
 b=qFalCLNW4L+8REIVx7Sy/FpGAsB4277Yq5FAO2hRjqej51FD4sgmdshF3sWaOUxKaBzgHBfPws2Bod8rQUvcZzqyZkwgiUYOeA83dVBwcWfke3AMJFDf7GWOc8upnh3UAKWqJ99CgeCmY9ZpcZhS8+ebS6BQPWOcPESSiNMaugI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6283.namprd04.prod.outlook.com (2603:10b6:5:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 07:32:58 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 07:32:58 +0000
Date: Fri, 2 Oct 2026 09:32:52 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>, 
	David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH 2/4] btrfs: zoned: fix possible UAF in wait_eb_writebacks
Message-ID: <ar9eCQDToxCdl5UP@mayhem.fritz.box>
References: <20260914085248.347198-1-johannes.thumshirn@wdc.com>
 <20260914085248.347198-3-johannes.thumshirn@wdc.com>
 <20260914150503.GI54722@twin.jikos.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914150503.GI54722@twin.jikos.cz>
X-ClientProxiedBy: FR4P281CA0213.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6283:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cf2cacb-181a-42bd-2351-08df2057619b
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|23010399003|1800799024|19092799006|11063799006|56012099006|4143699003|260925021311599003|260925022911599003|260925021911599003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 iZTdonBvfxVkIfM9pypMmw0D9Ca5PidfopKoWqCP5kDTpiBV+41/R8USJaV1FqZWQU1RRUMzCL4arNtRWMI76TiLGbqHDdujc4odvyTQvf1UgVZ/LRCLZp7MYV0pLBcerLryfk3T7rBOqFe/fMqZ6yzI26vBZCT93dE4rZbkg8hOVNuu7kZEj0c0yPCysV0UCr3r3TPlZs9tp7a8P+oN44ksj9kUGV8OOdplF0ZnO8bii8yqbJWqnh+1axDjrlDaJuFZB6fcIZIx5YISVatfPTRJDnC82Kle/aoJDbg5AutqEGt8unytVs/Pq39rmcjc95j89Xg9t6GK8d/HLP4nPgwug+QF/VqlIbxiKjXGG0O4OlYrkk4CDVS2YmjFSlq4s6OM2WA2qvr9Obl9pYrRK4ZGd//wI/kn5Rnot9ICrmRuD7CzGUNp3ty2g5JRzLJXcmmhibfEo5YPkh1+W+IYZRSrzOBWoH/S4N2oRmrqzcQ7DwZxoRCuR9426Lgk5vA0DSq8mqhV1+feHmpRk0zVBk8CO8Mzea/BgxPWRZfdRt8YdCnm5CWjItwJZ3fVPcVfgINUi+MSiHgePdBm7TkSKwVI0qmheye35P4W/aSFcRFJoc90B1TH24NKH36qqW/unajYWY1Kt2DJvLEmSvQXZ+HqLbEMENsHpLCwyST7uBM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(23010399003)(1800799024)(19092799006)(11063799006)(56012099006)(4143699003)(260925021311599003)(260925022911599003)(260925021911599003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?hit+n+dnY9aVyrjzmyb2N52jLCsKlMGIFpnF9gwgjGwbvr9jiFmNczbmj+Gz?=
 =?us-ascii?Q?jJD99A0gMfx1nW1CGrm8E/8ERS/QBQZUAM2e9qkJHrzMXmITdsWWWb391jG/?=
 =?us-ascii?Q?hlxbfHjf0iNmxe37cqLqmWlri3M/+ZaE+h2xtLKWG4193Ez+wopk49PhFi9H?=
 =?us-ascii?Q?LOIL7QKtwPALzqogbO8P+akos7vUB+C4BLHA4WxsGPSFyI4ydfebNXCMp2qN?=
 =?us-ascii?Q?5ELFlkQE0tpu62hxuB869jtbBw1h/I1e0UP2C7LJN4PsVzSdaecGpLn6FJ5v?=
 =?us-ascii?Q?BQY8rJHc58agem2YJx+kCfzzi9ev4+CJolG9XHIctwwNPOdfzl4pf1ISGzjt?=
 =?us-ascii?Q?hfAC82L+F9oqLqWO9Cc9170+6ISLYMr61wyt2PZNMHv0QzhnvihdIalWnfC1?=
 =?us-ascii?Q?/r9GtI+6UGAQnnEaAPVwHmhsK1UgX1edxt3n7MSvSRYqDOWqLEhNEDLk3QPS?=
 =?us-ascii?Q?9PY6d+brMfXMKcMWfJRchFoph95lM6VgjiOnh8cr++9OUBE6p0JBUs2nGhPL?=
 =?us-ascii?Q?5uovpszibbSTHoFDQI7PhREVZBXUmC8yErdRroN27RB8Cxt4q/iLvvYx+2/1?=
 =?us-ascii?Q?HbaM213jssjyyNDANV7MjlWOV/qPxe4iyF2Srq76xvwTcOLDJX7u3ox0eIqy?=
 =?us-ascii?Q?iyAatJaDQri9T7tz4dEx65he9ym1bT+XzT6aDMu++nA29dDogNOEFaLbpgYI?=
 =?us-ascii?Q?EkJN+8KiA1h/Hrq1f+/RAVGa/jfxaGKli54Qo9SFuPtqL2ou4ho8npUIc756?=
 =?us-ascii?Q?ZuCj5zyLMCkdKC4Jq3ny713zYaJkL5V2OG504/UVKJ8gkFSeFradCZJTUBsZ?=
 =?us-ascii?Q?yBf/IaLsHC5GteIfr9HdiqNPgRsCsPU4t+vw7p6HK99oQsr/pfbc59kuhvt2?=
 =?us-ascii?Q?CLmSzx12ITw3nS/N2LmIDLLx4d6I0ChoE+e/0GrM1Or5UvQ6l6C4pPL0lNgC?=
 =?us-ascii?Q?S0lJ8zPqorIo74U2ws4troYuSQqWbQ6enE+ITV+UHK+hfpb/NBBUdnehVn9D?=
 =?us-ascii?Q?s5oZCe6XufAX5Bu9VA1ojNy/7hIYbo8MDN5kIWt7pqji8/lkwjEeXrkdqZtl?=
 =?us-ascii?Q?xe51cqrXyEg74LFBI99ngbD+oeyN+gxxZ6xgdzqQpzR9dgE3ar6ZlHZqM/bt?=
 =?us-ascii?Q?CDLhOZeoKekYtNZSyYf6cekNidkUR02NfqqJLuYc0iib+UviWho4k6DeVl+j?=
 =?us-ascii?Q?zau3GSUaDZrJkITn37aRRsMoCmVSDkLnJVY5+qmyW0yjJDh9T6Pj+xkID2eY?=
 =?us-ascii?Q?isomV5FXY5vRoIGaVKEKSS7uosoq9gdpXnvqwtCpMdRFNZgWdvDtf69lOpEv?=
 =?us-ascii?Q?pJt39YLCb2Ub0o/EuZ5DQtiT//dV6cgfot8ytH3mXS52ybsNywGpex3j2wU7?=
 =?us-ascii?Q?2VuZuJXFBnEvQu1scMaWQftrEgj/V8wOSWIAEstR4leg4ddJuxqZu5m6Fwxa?=
 =?us-ascii?Q?XilO/VGug/4ZwF2I45gUrqEY9pfUN+SEseAcMSBLbr7DF9MN79j5I8sc+z5E?=
 =?us-ascii?Q?VhFV8bJNTBtGy6qhXeJ5A8TMF2gn1f4DrJ6V6puPLjc/QxrOdDSyKr5Hnqc2?=
 =?us-ascii?Q?osd3HL5hDEjHxoe4i9apTegFx8emB9aSSAL2j9/cAXRnOND6JmUPLerr42Bo?=
 =?us-ascii?Q?kMHmYjgIyo2wgiwD5uQaYtdfFpnlFyxUo8sC7ZAZI4xmA8HO3qlsucQR1LOv?=
 =?us-ascii?Q?YFfaSeePUwzjhe8OY0zcODGn9VwlKstAm9LtdCfof0R835jYZv0kMlLJxyyS?=
 =?us-ascii?Q?fPbr5XCfPc5+ZeMjyF2hD1ppsXBiICMPDG6/64472gqxYesFf5cu1fAbNR4m?=
X-MS-Exchange-AntiSpam-MessageData-1: C/Rwc8DmebWdGnU/VSkZirttJqMcuZW+1SM=
X-Exchange-RoutingPolicyChecked:
	iTjOuXrN+urJEhYAwegsVr/SGPO87Ugshwib0ChlXNkP9SLn3+3G9LiA5cVNBLdWS4TxIEEKNwlSF505psJL66RkK92UDK6+/5CZ912dXqoCAGhA+nJ//FllXKHk2MnUCX/fPb1564ZR5J4kYlG4FiRvms+JZN3nFBn8OXUfqUxHHYPc+bisdYGAP2SGGOejP33dHWBTfaXJtrOGaZQtvfwqFr1yM3d7l21fhvjsDY3oCtLQM+jj/5Q+uYKFIb7GgyGpi8zIgYA2ZybOFO+yZg/31aUd0zlYZw1XPg9/T9IhO9ZQKeQspz86iiBvjU3zWXTKtNPQke8OijHCIFxq1g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BBfM7bgw+6L64CnM/V/BzZ5rEU4K5aRaMFDFiX2dITssu10/jMzBtsB0peFAITh9Wqg+t1s572vCZ7TriynZoMF5eF8651ihKj5Y+qgMtecMZAMpbiZkUbK6SrszidkBLkQKO905BaclAJY6RbksAYWNGI51tuJB6GPHtd7LVQdqpFIfMRbmCGx9+PtgQ2hB/t0b8oR0tSold8OqDnLrswyJHIcfsB5dnxcxyOvtSHe7qMfruxnvSqfSNs9uE471K9iTEph3dU8QMnarJoriB9DX8fk4HdjedkhUGVz8jbw19U3n6WTPIGEwx3IxPvDBAMKZkQOFdnU9evT4RGRK29wHpnlvY+6zbhuVLilDpxAIZ+eonURUyCfMkQxeXpOfkNKEizUXe5SelvVb3qiQB/40XnoCDw0W7/QtdCDWUmkkv1tU13Xt/3M4zGGz5OD45mej14UvmeiuooedeQqrhhI4309h2hyBoG15PpHthnOekq6zhNpNiuXZ/k4FJnPg3xZe+3kfbcusIC/IpDyahFwNJjLvU1h+lOurYoIt7K7eHlSh3IRrg1hyY8frsraCJs0LwOv2V6hg9NPWq6kSFdt6Eu3K55YyQ1jWIhq0sqf1N8CoEQZbl0IRQsgIwEfO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cf2cacb-181a-42bd-2351-08df2057619b
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 07:32:58.2426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qr8k6qbIFca73KoNFzPOHMIR+6lqTwc8dQ3pLjAJVRgFNxSRbHdg1h7jySbe6rhepJG5QuY0xsdeTzW6f2TNSrIDo40kJOIgdn3cZo+lps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6283

On Mon, Sep 14, 2026 at 05:05:03PM +0200, David Sterba wrote:
> On Mon, Sep 14, 2026 at 10:52:46AM +0200, Johannes Thumshirn wrote:
> > wait_eb_writebacks() iterates the fs_info->buffer_tree xarray and waits
> > for the writeback of these extent-buffers. Waiting for writeback needs
> > to be done without the rcu_read_lock() held (because it can sleep) and
> > thus the loop drops the rcu_read_lock() before calling into
> > wait_on_extent_buffer_writeback(). But extent_buffers are freed through
> > RCU, so if btrfs_release_extent_buffer_rcu() is scheduled while we're
> > still waiting on the writeback, the extent_buffer will be freed causing
> > a use-after-free.
> > 
> > Similar to what is done in find_extent_buffer_nolock(), get a reference
> > to the extent_buffer before calling into
> > wait_on_extent_buffer_writeback() so a sucessfull writeback does not
> > free the extent_buffer while we still have a reference to it.
> > 
> > Fixes: 2dd7e7bc0282 ("btrfs: zoned: wait for extent buffer IOs before finishing a zone")
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > ---
> >  fs/btrfs/zoned.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> > index 12391063304b..c09e32904caf 100644
> > --- a/fs/btrfs/zoned.c
> > +++ b/fs/btrfs/zoned.c
> > @@ -2511,8 +2511,11 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
> >  			continue;
> >  		if (eb->start >= end)
> >  			break;
> > +		if (!refcount_inc_not_zero(&eb->refs))
> 
> Please add a comment with the reason for that, several other uses of
> inc-not-zero also have it. It makes it more visible and noticeable, also
> a disappearing eb during some operation is disasterous.
> 
> Unrelated to this patch, the LLM reviews take the comments into account
> and sometimes point out a pattern that is not followed in some case. It
> can be either valid or a false positive, we can verify that. For humans
> reading the code it's also useful as a drive-by knowledge.

Done.
