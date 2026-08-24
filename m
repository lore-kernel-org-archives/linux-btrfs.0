Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207FA430CD9
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 14:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787582571; cv=fail; b=OMmZIONVUpiJ3um3vwrb4zTfKbWCNEVdPGDYtuq8Y8HmjFsNqfu+hSfN6/ZsvE4hXcD9clnyv9NcMVu/eU0LCHhHZv+CvEkXoxU7at8/WY3BLgJaRVaJx8w3oHhypjDScBifDmbUCJ5ycuQ9WcAnk8HKQtP2X7wDxbUPBpuh1ro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787582571; c=relaxed/simple;
	bh=GL8qHRbA5a4UwMNAVPVg+ENEePt1je41MYyl9NfQGDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lhkixy4zhbhBnr8+B538JwWStVAJMNC3kviF7YVqDnJ6E9reP1XCPku9rAsuzDV7BEbBS1C8nQulo/kOApOrjt+5OXvBgOKY6MsoNz43HllMKsLbS3SXwZ+Bre+KIEzAv6EUOwQ8O0DnO157ClODUs/W1Ov4Mtip0RnsxR1lwVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UBTVWxsK; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=X95CIS+v; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UBTVWxsK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="X95CIS+v"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787582567; x=1819118567;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GL8qHRbA5a4UwMNAVPVg+ENEePt1je41MYyl9NfQGDc=;
  b=UBTVWxsKuHSI47KGzPRGKgrSEFkcDxmdXrdBbpg5XoIAsx/xWKmom/er
   aRnHKlbowbF6ghu7dWDVcLJsTnP0bCXgbFPB1dYWREwSbC7VltjwBcM+a
   qPBYiP7qhPd0fgt+WtAeXwImCbZ1hyrbcBLeeFYEq1qCk/0+XNzi1J2fM
   S5xNOFX5aQQzMR1Z8ndUpYNjPTk9Q4gd2BvY4/vzsJMdWoN7sskWpngY3
   vVeg6xepLW0J0nKwVboNC8GU9cIYyhFBeeUnRY/pbetWigJl5pjx5sDl/
   /mJEX1YY/yQTdD5+LhPY6rfX/Wi4Gnw0BpjXYXKDa4qlkYzHakLMo9qUi
   A==;
X-CSE-ConnectionGUID: XYC4oB25TeydaiJFkpoHHQ==
X-CSE-MsgGUID: F+vvl9z1TXGLFMzLCSdCQA==
X-IronPort-AV: E=Sophos;i="6.25,240,1779120000"; 
   d="scan'208";a="153200840"
Received: from mail-centralusazon11010003.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.3])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Aug 2026 22:42:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WhbMn31WPtq5unWJ5IMofKsK9XYt6f2d0ojmbtWkl/zK54eR28B+QOQSUXXTTyxHQYN+qud+C4lyZ5zqVOYI/EcY6l4lHOpRw5hM6m272YPP665VKbFieDKDX9+at5B4+BXFIQhSBzSolP4ZQK8xV9X86QIVJQuxNA7kLyHB32uhtSInnjvEDRw4CGUzIZwGUBwJz/rFZ2e1NDuqheQwYe2O3XIrzQWyalQ4bZNOWpg3OLVDkEqSsiHTKdj7QyLgJ30WOxdaIXo14oXSbiOa43jwV+3Xz7tBZ1SRNgv3GwuntqDDO/9B3oMOUcYfarh6FyOyghD+ydQSBvLSSitvAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBLDalWgRTzpPu7ycesFYuCHs5RN6QdXd7+FZjBufYA=;
 b=Xe+JRg50v+cP01yvAws13oaVO8YXjoHCRwgwtHpHUeLzacg5H/Td2bUiL3suLx+PICnj4m2iH+r9f+8ANqXKl5NS5d4Q3dr+74SpUEnzqDiuUzwN0hGUa8PoOQtGXQ/dw0ArMsVbErv3jsYrqCoVzr9SxiDNHh8Omv6VovG70UCXWH+2GoCGITIlmucqyRZE/1iCP+1TkQwZXlsyduk48eBvcj6YRFhFDUzQ13YfcxsF7cdSdUem4WgeSvV8k5247vFSCtrfHSlTnDF3wLNmkjdeg4iTBxCfdr3UufYoFrbptG3xH0mt8KLmMeThI993NDlgVhi5KLrSTflbZ4hNSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBLDalWgRTzpPu7ycesFYuCHs5RN6QdXd7+FZjBufYA=;
 b=X95CIS+vMWpZ/ZMzpOh2/ffYkoMRtvD9V9HIdwi/pS+3KjT34nqIlvRc/n4sE2Yrcv8BMPMKGXBYpJV88crnSS9EDLHtwcGawhUQncCmv+aa4gq8bDWXBGhorZsGzcedPYu3Y7UW48EPj1RXPWAA0/t4sqPcBgLTtiI91lqCIHg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6623.namprd04.prod.outlook.com (2603:10b6:5:1bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 14:42:42 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 14:42:42 +0000
Date: Mon, 24 Aug 2026 16:42:32 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: linux-btrfs@vger.kernel.org, naohiro.aota@wdc.com
Subject: Re: [PATCH 2/4] btrfs: zoned: recover active non-data block group
 roles on mount
Message-ID: <aoxPwPbpoad66hrG@mayhem.fritz.box>
References: <cover.1787551793.git.zhudongjiang@fygo.io>
 <8956aae5225383d3c9ec3b08a3a9d42da1396eb2.1787551793.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8956aae5225383d3c9ec3b08a3a9d42da1396eb2.1787551793.git.zhudongjiang@fygo.io>
X-ClientProxiedBy: FR4P281CA0293.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::6) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6623:EE_
X-MS-Office365-Filtering-Correlation-Id: 4154e105-b755-4ae9-0b16-08df01edf3bc
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|19092799006|1800799024|23010399003|366016|56012099006|10067099003|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xE2exkkP+172lo7KMPNAcPlWUuyRbJfzvSxJpwkk5wX7eOkF6/Td/ZB/0pCL7/ZOI+LBOy4eilgPWdxiupZhVWn18h2dkNhS5U8UEaMXs12CLhgjfD13SYgYRXDq6WhUsbx+fJYJjWOFRYZwXl3MWfUNE/s/IOqwurTnn++mFCKNLbTiA2R4C3nuwKqJsTpeX3gxcklJxUZiPZ7tbH27c1v2bSNI/5Ssn3wTRm89wWOIjTb3XEw263C415T2zAVe7lBPmb48mUBtj/LYhjY5HD80oFzskwQHJpDSK+N8SKcck/Omvi182jb0/xkXzhA/wPlik5FPN/aWm3DtLpyxs+ghu6Im4FNd0fFL2RTS3lxxdPyXqKHW6bVztxWfq/+pauEFLXDjIMZZ3LtY7BuDGbcHcvjQqHsCQsGhzuL7nXGnzoUFpnf6vSzwS3kv+xtu0qpu/h2bErJrBVFCLNwkB4D5TpOwNmV7N38jPpla6h68HDvyZ7LXi+iqyOMGCvQ/c9jD49+q+v1agqig4rTIFhnvreb59j+qo6KnO6fl2qPUV07my7qI5AxEiHYOwgcL1sValMib07wm+dr2eKbaRRyWtebq65SOltPOTG4DMeVWFDMA8cIrj1O1SrPv7nqisEZnyLF4Z/ICk3sJeZp8Z6Hem0ysgUJOOTaE1OafElI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(19092799006)(1800799024)(23010399003)(366016)(56012099006)(10067099003)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xRTXqfTJt06EJnzRbDR19NZ4c6Z9cvzpbvfHlK3V4BkJq9FNovMmvGdB3+7u?=
 =?us-ascii?Q?AUdy9O1wXrZyaSDnFy/eLF6ga5Bh5XKVX98mBd0CsaRLydCnD6bx9JbVzZfI?=
 =?us-ascii?Q?0cK+yb3pwtUIv4eDTGhtqJRaKQJU5btkhYmTAEUu6dAMuKmH4Jrbv/ievlcR?=
 =?us-ascii?Q?HuUk0lMJgv3UnirPbiDFRBkiD67V5iAk0Mrlt5YaVt3WNO/JhsSfI7towxEF?=
 =?us-ascii?Q?sQNmHOetTfjLvszEFXAo1/61HMMsB8anLOyPHcR7THTniXJQsBN6FOe9GxuS?=
 =?us-ascii?Q?hn1LyVsQxxbfvdNes0ESigU3Pzs4R7NDYbMF6Y5PF4kJJGM5+g1CyaJ4lD4J?=
 =?us-ascii?Q?XOrUKtTASY2QaYT9Lbuc4B0HLXfetwe1oegLqXHR7mtwxifmfkNyXGS0POFZ?=
 =?us-ascii?Q?pvw1sDfhyK5FNHb9BZNwc/U4p9h9rY84Lyd7vOLeUgKZzAaw0GSJKDM40eH1?=
 =?us-ascii?Q?38S0ozQXLRdCtTsTlHwaGH1dBgQcF6wUI3NuwTsMTnRd3B4P38OT9746egb9?=
 =?us-ascii?Q?UHBYd9KjLPPkfO4ddSI6Zo1JcK6mcehNxrtmGNCpAy//tP3m/MI14LTEKNEO?=
 =?us-ascii?Q?Qt+mxFCG506y6/P1/RDBfQEMLiJecSOT7KYinYtOhv9XmktVPcJ6eQC3fvCu?=
 =?us-ascii?Q?4LjF4PGZuWcI4qXcDYituruiJg0o8uYyjwlAMe6ToD0fxA1D5O0y5eNKw2CK?=
 =?us-ascii?Q?vGV1Xbfa3cbiX+qWkFV8G+g+64/XBRpuqRxwMT9DtjJ9ear5nJxvu2QUQZCJ?=
 =?us-ascii?Q?182Unqs+goisB+hq0YuamGSxMz7R54cV5htrSj17Pw/OUr17Rz1f/jEoSHEI?=
 =?us-ascii?Q?ZdZSSv843R67AOXtt6rzlskov0mXq0J73tF0sslQbGmv2vZzc4/MwK3Td9D3?=
 =?us-ascii?Q?McaJCdVR6XbBVUlHl4HwjjCeZZ2wUIYPNA7IYfokTCqun9E3IM6CFvKng2XJ?=
 =?us-ascii?Q?jMJtGjpE1pPL1icVE19DkJFY0P3u6MG5u8nQxrxdelNMQ2lrMCi7mwoDw4uF?=
 =?us-ascii?Q?EVShhguF+H59ctmhZjD3LuwLk1eeek8Mkht3aySPVyJ6DoG3Xr/I4kYnYf0r?=
 =?us-ascii?Q?072YX773burhXZcwzMrUppT/zt6ZOzl4v7W7fDcje+nydRpPE+k/8Ev+Ya5e?=
 =?us-ascii?Q?s3lHFavY4XIoEzS+2eXpO48EPHMqpgklH/LS+uPHoSCXSOoZ/z3adQuufe82?=
 =?us-ascii?Q?NFqA/12G1SydiXpdhuNqD+cV+0MMrOJVpfv34WAs2fCaVA52489Llg/lE/ub?=
 =?us-ascii?Q?iIphl0twHi4lsemEMEDRZqQLKC8hmxJ9aLC2wgJGwYsHe3Av5nrYczU6zYRV?=
 =?us-ascii?Q?/cao/RL46cqHvj0YhxA9hUo58E8ADFXBXEK6mMJVJe0ZXiDFBO5/PZOhN1YD?=
 =?us-ascii?Q?5zW71c5cjKZZd4lj1X2UbxIl9W01kOTEdLI1eH86SFVDFM5tB2rDipBuTJ1+?=
 =?us-ascii?Q?1F6ViiWmTZ2x4H+6t415nMZJkl+c8sexJ6djU8VGpOGb8ZChdKcKEEekF6Oa?=
 =?us-ascii?Q?hwYp1z/KpYW6Om4IdxSY6pexZskkghgtUja9p8MSd7zwmUieY0/mmtCteiAU?=
 =?us-ascii?Q?bTQxp1TTuCpDcd4B2SMbXudlGllRz5DnLIudU/fYbTYP17Dh57cFGJswoRwd?=
 =?us-ascii?Q?SRmBiZuv1bAeK/Yclv01Dxeqiaexa1oeuN39S+0+dirhZec44cj3NxIpIewD?=
 =?us-ascii?Q?07n/WD7+HrHN2t8rJQr60iGv3KgJPL4flhwGfnFk7AUH3cJDUfT4bBRkSQro?=
 =?us-ascii?Q?KfaviViSi//OejnbcFI/xFFrn5LGnp7DeUtwszwObABIV7yUUWdMgCw9KJF1?=
X-MS-Exchange-AntiSpam-MessageData-1: P/dTqY9mCTBtFIbbK+4T80bMLorjgCx5y1s=
X-Exchange-RoutingPolicyChecked:
	V9BqHJZQorYRyGtAIV0Yl6+M4erfUKcq0l3uG9az2n5cm2HzkMqtFr3VhXCeLK5lrbMLaJWAq9JjA1CgT7FI56ZDOnBAkNgRvyzeYxYyoJvw5tkuC3xl61VgNMYENz5Y/ltGONe5iNmVg2seGI68DWB1CoWhSzPbHg56xlqos2dhVRc0XA0I+vR6tJwwH6NMFqhZPAhLMLqJjDspin7zzYSioJORev2cGYssPtnsInj2NIkkN5ouVn1mm5nOk2tM1h1FT5c0marqMm5q7ZYCh8fQc7LLYfUSJBjrwTrR+Pu0jDsfepHhIMhItH/UdXXD7aLToWPGRFe+y8T9MLubYg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r1s9EAi49YAeb7m7WS9ZZAhXoIxoAW/4Gs+Dw5pARiyZKhr54AB3J8++qCZjkti3aKu2zBUZbe3u/rQa09I0h+SvzpN0R5ZlfdJA3C7q87BdVLErKPPAGmeaE0oGXR4PBbOGNgcGIdpatcxoqgnoURo+VbhvkHsaZyeCz3MAIabgMFhiZ7uF058Kcw4ic+0xcczJYsuXf6TDzEr9St1+Vpu9aTNYsmd8BF9AjjPKpV/7yQRvmRneHql+o1YQwCZwQvOAnQEb10w1rr6jq4QmPKGq7XoI5oufc2XZwfDTzYinRFvUH3gfZlQxGLJo9e2+DbxTzkLc0cp85Hu6MK8+sc30QjXOmZbW9bXhDXZLOnPRr6qtw5L8IGCIp1aQmy+kNqoDYxqJ0OAv3WCXMT2M1UOHxoqC9yNiYHAOHHPcBw3wLnvjEDGdAyeBMQmPUffOH5/Y/mC5Zgn4Kjdkl94FjvMofsts2chJtYMWGaI1wberHnrsPS0JrUl5Fhgr4hbqGEGpEacv1l/OhrmgTY/zJUyWsyAtWx6DTAaoHg81igq1s+7OgJtFuu+ntW0QhjGLojo2VUsMC6Inn1KHOW10eyZgavcRO0/gpI2a7MhXQt86oE9CTUk7DWjSPiEjmuvI
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4154e105-b755-4ae9-0b16-08df01edf3bc
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 14:42:42.0204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VbYNXeuoYasP/kfIBmYwr50Mp40C67EpnNRneIcpsdprJxksZcl7NFOdjN/5N4nUkm2YiixvmKz3D6uAo/q/9tnC/H7ynsBRHJVqL+h9SB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6623

On Mon, Aug 24, 2026 at 02:49:54PM +0800, Dongjiang Zhu wrote:
> [BUG]
> After a remount, a later write can activate a new metadata or system
> block group without finishing the recovered one.  Repeating this across
> remounts consumes additional active-zone slots and reservations, and can
> eventually exhaust all active-zone slots.
> 
> Once no slot is available, activation of a metadata or system block group
> fails.  During synchronous transaction writeback this propagates as
> -EAGAIN, aborting the transaction and forcing the filesystem read-only.
> 
> A remount/fsync/remount reproducer on an HC620 left two partially used
> sequential metadata block groups active while active_meta_bg remained
> NULL:
> 
>   bg=343865819136 alloc=176095232 cap=268435456
>   bg=344402690048 alloc=3260416   cap=268435456
> 

Can you submit a fstest for that please? Maybe even in generic/ so XFS and
F2FS also get coverage?

> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index 10e15a319b93..aa3d6b66495e 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -931,6 +931,10 @@ struct btrfs_fs_info {
>  	u64 data_reloc_bg;
>  	struct mutex zoned_data_reloc_io_lock;
>  
> +	/*
> +	 * Active block groups for normal metadata and system writes. Mount
> +	 * recovery restores one block group for each role and finishes any extras.
> +	 */

I don't think this comments adds any value.

>  	struct btrfs_block_group *active_meta_bg;
>  	struct btrfs_block_group *active_system_bg;
>  
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index bd079d3b31ba..7d91c074a24a 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -3050,22 +3050,73 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
>  	return 0;
>  }
>  
> +static int finish_extra_active_nondata_bgs(struct btrfs_fs_info *fs_info)
> +{
> +	struct btrfs_block_group *block_group;
> +	struct btrfs_block_group *next;
> +	u64 tail_unusable;
> +	int ret;
> +
> +	list_for_each_entry_safe(block_group, next, &fs_info->zone_active_bgs,
> +				 active_bg_list) {
> +		if (!(block_group->flags &
> +		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
> +			continue;
> +
> +		if (block_group == fs_info->active_meta_bg ||
> +		    block_group == fs_info->active_system_bg)
> +			continue;
> +
> +		btrfs_get_block_group(block_group);
> +		tail_unusable = block_group->zone_capacity - block_group->alloc_offset;

Shouldn't these be accessed under the block_group->lock?

> -		if (!(block_group->flags &
> -		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
> +		if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA) {
> +			active_bg = &active_meta_bg;
> +			active_avail = &active_meta_avail;
> +		} else if (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
> +			active_bg = &active_system_bg;
> +			active_avail = &active_system_avail;
> +		} else {
>  			continue;
> +		}
> +
> +		avail = block_group->zone_capacity - block_group->alloc_offset;

Same here, don't you need the block_group->lock?
