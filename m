Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F56C36167E;
	Wed, 19 Aug 2026 13:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787145439; cv=fail; b=W39G3ZmA1/GFrIhkLB8RwNUHabBlpZyhIujPcc8DJhL3oedESpFogHZK44v/+cKLn0I7qwrvHVei7q/tubzZLzzKPo5CZLgu2r+quAp3c9Mr34vJDDGtjfmbq40fmTY6CRw8uKKwhhYS9SVvnlG9MenmXRpZWKmmMB3Kqmt35jI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787145439; c=relaxed/simple;
	bh=UnY6UZ5eHClSwacafxwmuhwqhMaYKEvTOOdmn83xvCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RfvK9osXPvQQkme1aCNwBdAg76Pg3Nuw8RtJioXAPjmri39ZZTqTGM+PRLfjbqtgO7XD+Ye/wzdZa9AlMgG4M4p9G7AQJAbT7HlXtnAZ8nXdEv2wPr+JwcEMl7X2tUNCvkVwpzlO9KIY3+lHKq8mPxDVQqkz2POJuxwaxMhSF+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fBuq12dd; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=tYT0+fBK; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fBuq12dd";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tYT0+fBK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787145437; x=1818681437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=UnY6UZ5eHClSwacafxwmuhwqhMaYKEvTOOdmn83xvCs=;
  b=fBuq12ddKCH8lVhlAmeJrzgoZQ7pMDVVUVEpcY7UXTpvsUkrdWgy0Hic
   ig148vALcd4oqGdQvd8+5j6GU1dLGRJESkaJc52H9P7QD8qGVhDNWUsb4
   JJ0/hGYVLRbgO/qm0HzjiJSmlvsnGt0cchkQ+tFcijHGXlgLqLqJf1Y+F
   +gO5fplQm2/zwki3NKx846rB2xSSLl8tc4esBXMGj4taXDFbmzNxSC9eF
   QNL1rULHoiua/BHcMklEimg9LMDVGxpv+4kekD2aBiltx7gASVE8Ru1NV
   qflrMcPcGjfW39omMVwh7RDjg9TPuL9IDeEo3ossQ17QmX4rYIQEFyaj5
   A==;
X-CSE-ConnectionGUID: o5H/sU8LQkuJmClN0wYtZA==
X-CSE-MsgGUID: K9a+I0VnSUiOdZvOsOa/4g==
X-IronPort-AV: E=Sophos;i="6.25,231,1779120000"; 
   d="scan'208";a="149653761"
Received: from mail-eastusazon11011028.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.28])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Aug 2026 21:17:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NqWmX2hWOuo8Ujro9PpVfBKhiTkgAzOSi/DVWo3j3jxuxrzqFqbNd4KoUPW3Sl9WroFHLlcZMcWaHD0L7DXv6yLGs9kafcDCFOQnv2AQMSREWgOd2DMs+UIMD2ILqMPIdgKmwBlYLg1PUcwFX3DxP4TQMAATQrIzuX3BSj3jXdO3D13OGfU8n45tieVKira0lo2UtwC4o3pi72e8QHTeRWEBMnZmBOBTbZldxDT+sXA50jUM4l+o6f0yFiw8hmTxP+2rob9zsA5dCRfjrWoxaEKKXAFm7IT2aa6E06KXfpUaTynKAZJKptqeUu+fJQW0aYqbRwy478XvL43Azt2Gug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFnkjEv9jV4NFN/V6ZJ/bBmRY+uR6swmTV1zeHAM3X8=;
 b=CVTVgwmgWRpjkiwZVcNSA7lAJfx73/dt2potgWajCprkj7p1oCsRxAFGHOkxVNbqliKugjCDtsXgAx6Wau8ETp2jEe4etVxpS8Vj4sXfe1GIGp1qS5Ahl68k1ySCwscKdUjD0tBLo02mahEPd6hidd/h8zJ20KPdWMFfgBht+nyd8HWuLIE9HxXpPaWEz7Q1T2su0HtXlnOgOgeyU1gFOFR6PlwNYHQhWgQcrYp0dpBH/spY4oteiN7GIQ+QLRwr+UKPYYkhFDfJ+tMUDMdkvbBAZKPIE+yppj1Uh+XV658d5yCKv0gGyT5HJYlrvH/FAsf3PDX18omYUJWLItKudw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFnkjEv9jV4NFN/V6ZJ/bBmRY+uR6swmTV1zeHAM3X8=;
 b=tYT0+fBKb9O0guHsdqCiOdA36EbpWkeYKDDWqBAqoKl3r9Mhbq4QSGx29QWRJrW0wratPkD+/99K8yEu1LzyEXL78AkLLVLS3Kcu0GZgx1iYnEfuvCSrQrwQbN2ePWi1NGuUnwyvp8jCUEajolS+B1SOBtE98N+QnuHGgN0Alz0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA0PR04MB7385.namprd04.prod.outlook.com (2603:10b6:806:db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 13:17:08 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 13:17:07 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 1/5] common/btrfs: fix awk field separator in _check_temp_fsid
Date: Wed, 19 Aug 2026 15:16:01 +0200
Message-ID: <20260819131606.1478488-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0396.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA0PR04MB7385:EE_
X-MS-Office365-Filtering-Correlation-Id: fc89ac3a-4388-4e81-d326-08defdf42b7d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|23010399003|19092799006|6133799003|3023799007|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Wbct1vnJlC7SyZNulLLLcEbZjLvuCius/6q/y/1fPOTs8bj/4aM/ObtdOyVFEHaBnudBVat6H04fnTwDBlVmdDi7y9TgDOKVzC2vxr4hf2xfHSW0regsfygMvcl0yThfubVxVwOK6idW+IZrEG+Nax+scZyaRhprdK5yTzfm1cLsEB9xB/uIr4KdKlYl5855lUu81V4k1Wv2X3ruVu+0WW+7hAz9UhKn7xzlGa+zYsAHL3zf11uRHeTsE8QJyaQD6/DiJEmPfcN8BCEZjalW28hZbZqfz9T2NGXRMoms5igpNJFylDxOSu+Uds+Cfjd/SZP2ihZyiJVC6GhjOwnJ9cL4N5Ljw/exfSHBbKVauBBMmB3lwpuKh+f2Zs+iZmmPc3mC7xINfxkjzZs3jfgYdtXWm7DG3gD54QM25tx8t9Lb4vxbvbSEBJYQuT6OEpxpXl7CM4QP0zJGe2b+I6k6LVRT5kQVv0x8BzcwsBCRVeEP63ovcS4uhkYGbncIR6wtfAmnilYSrwkhtKLHiaueikRYuLuA3pf85BaaiCViHTMs+QYsLLr52Bi5Avyn6YwAeo1QyMVlTogID4d0BJCWy2K0aMFE8ORT4sbdSnB9Sx52INZVKYKJQwYoYfAQaarmTQpK9PAyF3XPPboX829sZ/fxyV3hq3bXQkLdx+KWxro=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(23010399003)(19092799006)(6133799003)(3023799007)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kKyJx8spgbP56li5z/j+2kCbVGgDiuHTC/hG3JUodpYuJj57SlgD3vqP0n+m?=
 =?us-ascii?Q?Eba/tmkVOkz4hhoA1GZV73gxlzAjKfV40dgFfkiqETC7BDU7nQf0ru+OLKiD?=
 =?us-ascii?Q?dr5+rY4HOTrwTdaUKTP3Y7VvNMTvKfZo69dBpBeS+30gfi2JiZOwuA9hBt+v?=
 =?us-ascii?Q?0qUAl9u0oxv7Ad8SZ2UhWN+3V5L5NSBr0eWxX7eVn/eAFAso9Xp0QZ2upiNW?=
 =?us-ascii?Q?LZ8pYkLzhN/5DKzqEJFfubcf+pkwHaMOjV6IaUEVrQZfdtkAR5coXPYeRFa1?=
 =?us-ascii?Q?VfSSuMIdlMkjsLN9D/CIh/viaC1BFzTr8TND1lB6qsslmjXsr9SyfwEld543?=
 =?us-ascii?Q?KntV1pawH0JMYmkgLxPCPUooHJSK4Qy2jQcul3UPPuPJhCgEdcYorgisLf6m?=
 =?us-ascii?Q?XtlYxGSg3jHZpFjbhQpR1mK7U+43EZXKpO9QeFLvSyHx6VMu4vHFpoZ2zrvU?=
 =?us-ascii?Q?JE7dMrnk/UiJbFWzajImzqIWNqrcX+lvoEoQP1Dht9E/FaOzkvPlLCKTVm3R?=
 =?us-ascii?Q?MbGC/MXFd3bLX1Pqtncd9EUtqHt19EXAMGzuwI2Uzx7jmpsH7BXCikMeMNo6?=
 =?us-ascii?Q?6PwbrciZ0Yfh647n7VxUv+OFln6mNoqolJXTPZSeraKJEtRoTgUslj/joehL?=
 =?us-ascii?Q?Nb9fdSKZgTF/9A6AZCyYaEx1PFtdiDufbILF7LEABRzCZ6pqLDSggld0FBVW?=
 =?us-ascii?Q?s91FqsGY8dUh983erT9VwaIbf/8EtgEtzCly9tOJByU7aCtieUub6VSM9BFt?=
 =?us-ascii?Q?oUhCBhMEwHlYU99CKo2Ol88k4KUHo0Tz1FXw87GszJFl3cpgSg4HgcSpqeQ3?=
 =?us-ascii?Q?O6GrdLihtkk+rSyrBHoQJrC1gte24MEfMHPEdhzBqC6VhMNbvRYv20q1DOsy?=
 =?us-ascii?Q?b0tmMkNMfPuC05EUD+E1+jkZR5aYjTKRdVHFOcZKCoAOH+OLtMuD3M9taeen?=
 =?us-ascii?Q?R3gvsynZXQV8UCDWp/+tftdjr+xznll3Bg24799lZTix4k1np2w+8iK0S5C6?=
 =?us-ascii?Q?hSgKta4xsd+abLjpqiDrGXsmxxHqLDO7W+ffgift6x7PftTGUcAbIRt7NdWV?=
 =?us-ascii?Q?R5omFQ90qqs+n+IWmxAik1TCG3XwK7CC6+2cxyaSOpgfvY8ToWrEY1wa4Gx3?=
 =?us-ascii?Q?XvA4WiCKZRD2gtfH4l5k9FmLG5VHuZF76Y9Y9hPr8A0DHaT0jo6ZdMqb/zze?=
 =?us-ascii?Q?3Tr6wjKCxQ2bagkPQ4zb6NN5TuRMf+qpJ8L8wTTJgUm2ryCtsUsXpEIn+YtO?=
 =?us-ascii?Q?njjGsHxadhDL9Y7xr5m5wiVuogbXh4snAqE2xC+KdGaprVq1f+2FR7tOs+nr?=
 =?us-ascii?Q?+wMwuKnYV/xcxTh/mVANEom5rhnczI3AVgZHKTocWq+pUE3Iirqj5xuvd6A/?=
 =?us-ascii?Q?yEESkR73oy+4HaSACKPLWAXHSQv5XbN9W3EKeDgECPbhUQqrQXBb6w5opLhX?=
 =?us-ascii?Q?0jQKJOYmYrn0fB/7yv5jA0AmYYgaPZ6al/R/L8U2AUVjOdx2z0shGhrLpTKn?=
 =?us-ascii?Q?q4ExbjtHckR5jWCLZDCq6BzAY3yiUNxF90asXugS2pU70sD6iC4AIlNDon2s?=
 =?us-ascii?Q?ybgRpbcl29xfwTI4A/oZ6gg1kSHV0foUmkQoEUtYzjjv7hgkoflh1canPgyQ?=
 =?us-ascii?Q?1556Hv9uqJ8tfA4Olt2y8Sxhu4zZSYnzRjm32XneF83oBHadc6BFJSi+bGJe?=
 =?us-ascii?Q?AT0BtQyLEs7pBGkRdnftfVD+17dHA6ikm31/j3Ez28Hr9eX4sEu30cXJSdK4?=
 =?us-ascii?Q?31kXQ5ESQaB5jx+V0UBmniuEUfj34NE/9XVvMzlZAFXP3okAvKRlIuY8qGv0?=
X-MS-Exchange-AntiSpam-MessageData-1: 0evs99Axj4DIFW5UjApZaP9U40uDhW9IySU=
X-Exchange-RoutingPolicyChecked:
	SHWaDtkXzLYZOcacJ8AD90PLAkWOEx1JDjNIL35xqqC/ex43+Hr93OU+Aa6Jlo6pr2n7a5lmSNHnnyrval8nRXEtkDVZJsFd7gUmV3Vu6AYRfxZRtwsOOBxVxfeN8GfRSdUfNXvl6C+gQcqDYmxyOc8QPbSFoFiwVdMnXMAiQQRBGurZrdD9xlCmLL1OxkUY5m6/n//wv0Z789otNR+BtLaTbaPq41dO8bIdsHt46XbYYAUPnJCoJXUSzNTs6CmLy7ieQmhN8NufE8YBcPexVCukAlPmZDoXicl5jrjvd5NLeD8mdUg4QJN33wP0VKBKLxUFZ8UFUDbtpQPld139AQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RoeK+7HR+pUMNXwxJwl1Mx83IH0z8JLBxz8+I7X/S5OmV4K6EAyu+Quzv3Pps0qTwWnHIU55Ji54TTLd9ymQoU8JaaYTDfDlgAK7J42pcZxatGLc7+kMSzPTkNHV8dUqcyCfnE+kzGvGDJmZYJ4EVJXPMERI9zFFR/4SdGL74G/E7nPfZjWDLAdto6aHMPD0YTpgQ4A3sdd0scy0WNVzyFDHWe9scPDb1PNQ/PPHsRuDDAU0nDSSaI65E0V5FUqvMMPhebuaCtudEy8tPHdnGEostHMte2sLPnnWkhYGO54eXoKgUZsXFwdE6wK98QGBk7zFgLDPWT5+Y25hlUujbNuu4XB1vKTtrtyxtNyGLGLTvU08xrmwxI8erzOtMD7r9EIs2TCelv1EIacmnpEvW+LhxPo5P78OnR0zLmlGR449yaRf7tgVtRAhhThqI7PcwxFkKCEDW2ag9gAVJaC4tiKUXZDr6exsuE/juejkGR0hDvgNBdjCGaJ/7gQswMSeyzwSgO/5FN/aXqg8//Cl/MpnPVvQkZsk2O3ea204/RflFt4NYAx1S5mpNJKhMCW/IL9UcEt5zD+oKHvZpuRgD00gLK0NL1RGOhJ8SjHlOQ27y8K4I68PvdDxBfIlmmQP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc89ac3a-4388-4e81-d326-08defdf42b7d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 13:17:07.9150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/7vNNaDT/P7uU/3W6rpXICSj9+DehjGqI66btv5CQg8auISo3KhpWD4kcVXj9KjYjmFnDb+Cwcub/HLS6tLYTqV+rW3XWZ02humGmH5TfM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7385

_check_temp_fsid() extracted the on-disk fsid with "awk -d\" \"",
but -d is gawk's --dump-variables option, not a field separator.
As a result awk tried to open a file named " " for writing and dumped
its variable list, polluting the test output with messages like:

  awk: warning: could not open ' ' for writing: Read-only file system
  awk: warning: sending variable list to standard error
  ARGC: 1
  ARGIND: 0
  ...

which made btrfs/311 (the only test currently exercising this helper)
fail. Use -F" " to set the field separator as intended.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 common/btrfs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/btrfs b/common/btrfs
index fb7c8378..926f56e5 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -1014,7 +1014,7 @@ _check_temp_fsid()
 
 	# on disk fsid
 	fsid=$($BTRFS_UTIL_PROG inspect-internal dump-super $dev1 | \
-				grep ^fsid | $AWK_PROG -d" " '{print $2}')
+				grep ^fsid | $AWK_PROG -F" " '{print $2}')
 	echo -e "On disk fsid:\t\t$fsid" | sed -e "s/$fsid/FSID/g"
 
 	# Print FSID even if it is not the same as metadata_uuid because it has
-- 
2.55.0

