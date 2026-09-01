Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57ADE366042
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 07:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788246692; cv=fail; b=KAuSJtRqWo4c6ZptSyA7yfrbOHMdkM8ZOnQtITh+YO4GIfY9pzTWiiYE8hO1XxvRoc0qAL+5/RjZpyL9DL/04Em4TDeb6nNH4Kx57It3t/Ew7ShdwZzkdyiWHBgmrWTtnThEECoNxP3Lt5OoVY5Smw9rr1m+hdfwj2MVYJ+7gec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788246692; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tG7/hj70VtoGXuenLzcACGaMHWwLxyZoSbkhxL1YICMnV+fgxT3SAXxz6ntN4vgN/KcSiInBNNSPuNPIWvwoDhWXUi/OWRM7qnyiThxR2dc61RJY5IAk64zFzu+383FjHCb2uKtYZyLkOpLDBQfXNmzXwbuVfbG9yZfB4Jmoa20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bOwhD8io; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=kfL8af+O; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bOwhD8io";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kfL8af+O"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788246695; x=1819782695;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=bOwhD8ioMtq/KLTvZAjwj8hAl5Ati8TNLVAUzlA76AJopVM9+RDERUFV
   8RFY7u3CPqqosUrGLnuXM8HSKJS0jUctU3xuxbkIx7loPXG5t2mcBtZ1s
   z8yQbaTEvbLz+PCH6UPoyB+JXD3At17H+IOqFCbhJy573JDKQQoaM5IQC
   LV03xeO6W4kZgJhIqzVxLcXSbbQAhnjTQ4QS4jjgFrK7ELaMIwhcn0W0B
   cy6p+hOEBRnjxQ6JawXHlKVlewXYtJ29gl9VGNKLgDVhh/+nHGklDxBIe
   hqvpLtB3cRfVfCXtfJhuAK5Xv0ddCQrIxNTxRDNBVmvMZPr8KTVq5i/nt
   g==;
X-CSE-ConnectionGUID: iaDeQduUT0CljKnd4G8oWQ==
X-CSE-MsgGUID: ZoI1iY/YQCaLUDck1Umfgw==
X-IronPort-AV: E=Sophos;i="6.25,255,1779120000"; 
   d="scan'208";a="153721102"
Received: from mail-westus2azon11012033.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Sep 2026 15:11:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DRU/RzZvQq6sTbUL9gQAdDA4K70pCXefZUiQbwCYLVxXOEpQQe+H6YGhwwxyWxE6DJsO1xyLVGl4Iyg+QLDjsLj2o2Up45RiFX3JoY2gEAXaHHdgxeCqSkRemybsF1gmaa2JPgbGyT0WjB1zis7iAYhrX03ZO+InCiC4oa/nO/AMmazHxEqHMyxu44D5khs79Z0c/bkmilgw6BsFIMNf72gZMD8g7m9fNjZzTX2z+7pCFWeQdKsexj5J5DEVZqrePARQe6dz/+ud32yXwyz29TYPOXf+X8f1d4anyUHCpKjxlGcgL/s9nbbYoDbZfvL2VvRmMM42Fapbp9KZxCYB/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=dthc3dUp9PIAs/P4kdBD375TzfijfmtppeVqUJkRsUXRxg6qYV5u7P3lM28/9Arb5gINyAXDGN6CQ55kYUDyimKBdDAatheRjICYYIWCJXhE99Rw9OyYmD7lRCSGTLJgQOJMvxL57bgfBpAkpQJdxZNN/hbpYcjIwVC8eBrSZOeOlA5KW2XSnwsNwl7kNJrMFsKOf+8kBqf0DLkf49wGRI7fMqYr5wfHf1QJGQE8lVxb2YHWL/EGKKzxsCZS5yoIbAIT3n8ugWW19rR9M3pSDqxxrE4sYgRZZcFuB/zX6DcsWERVP/24bqtNngKA9stOkOWgghvslUrX7Jeo48PX3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=kfL8af+OjV1ZsqjAkkq2X4VF+ehMd1hLe/tWd3zE+q6gDXubyV3ILkIg2SjBNc5Ts0bVEF2cLGso4RuKxQ3DQXsrbzDOPa/YK/1qhpnjkbOmy5cYHLMUsDTXJAwFlGVchbqI9x+KxUpJtjuYQp39R4Pn/izsI+JcFurP3Cb2dQc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB8809.namprd04.prod.outlook.com (2603:10b6:930:c0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 07:11:23 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 07:11:23 +0000
Date: Tue, 1 Sep 2026 09:11:15 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v3] btrfs: use ordered extent to grab the logical address
 for submission
Message-ID: <apZ6eX7g_4FhUkuX@mayhem.fritz.box>
References: <ba5fc3c9b2de187169552786c1fde4e2ebcef0f6.1788220853.git.wqu@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba5fc3c9b2de187169552786c1fde4e2ebcef0f6.1788220853.git.wqu@suse.com>
X-ClientProxiedBy: FR4P281CA0002.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CYYPR04MB8809:EE_
X-MS-Office365-Filtering-Correlation-Id: 830034c5-f02e-40dd-41c4-08df07f83ad7
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|376014|19092799006|10070799003|23010399003|1800799024|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 nOwuBgexcuDYThdadZ9XYGjHd63oaq/8l0wWWWtVD357Y+zfweZ/0LpwB5NtV4ufocF3G0IbYOVzOoE4ozeaqbFbKMEjyEY++rR7BFOqVNbQkXkcBrEulG7iy0L8yjlAg+L2XDbCml+635Len7saWjuhMvWWRYJFna81xD/43wNWzu76J+4rX+DxB2ymjVyNVQikcd3I3uj7Zf2ul1OHZZOSvdSJru5xpTpTU7lAJ/Y8t9SVdr2kACqGKMFBVmdExI2Gis1UW3u6BxDdQo12hQVuBqHP1WHu4AVkw9Ghyh3Olp0g2YFwg6Eu8nYZbnu6GJeWxP3BO8yUWoBH2QRXLzka0gZoFFly7yCxvHoVvIMtg2macc0oJ1zC+VKE6+uh1sPP7H6J5/PWeMq4dKuj8T61A+hHTrEd56ZDBHGEbIHlaPmLTls0WTdUkJXfb7692hRNAFk60dZEVM6L5kLpLv8y4aBsd/I6pM0GWWmrpBYfEXhMwe9K0B0HKDzfJfE8Fx8jSctZE/3jdNjdjVd5kTGOmRQeceAVo2Y4/FNuw2Jqm6no0CrlLSZSvBjTjSPoiGXgzbe6hJCgHI5mJ862u9CXarzqJCz+HXlDcrg/EPVWbPD/PwsDmlHuOYbBgpn0xa7ljafKNaK20dQXUBGF4NhggZ3pxzz+PbUM2CQ3ffg=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(19092799006)(10070799003)(23010399003)(1800799024)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?fKUNqFsHO40osZElLSJ23HpBI7QdoIehO4/uWIufL+a6B5WQEanlG39ImTiZ?=
 =?us-ascii?Q?f3Cx/N/ynxnbiRYE2IrqTtk+YnAcSAkSRTVfA8+eXy6wz+b7AJ1FHUT57Liy?=
 =?us-ascii?Q?+rsJZZHr2zM9ahohXxQcjhnnvzMNvzLlyOxpA7qKIPXb8M04mBCiGlKQWTa3?=
 =?us-ascii?Q?NYU6F/u8sV8DDAru45FB5YhElmxTf0U4hRsuSLsUIbutfolxDeB2lhdzTwRU?=
 =?us-ascii?Q?Gl1MtFE4VfKljwaNwNfe3oTvi3TJ/5gAIqRW3e/E88T5csglFCv6nS435PS0?=
 =?us-ascii?Q?A5/c805JdzWck8AroTxSqMWgEUXsW6WvhwPlYj61qXMCsadsg6cFB5ahwBD3?=
 =?us-ascii?Q?lAZ2CZ6fJfOLCgMp46svQi3n2uAdHThT5md8rzz8C9tgndeaURcg3ym9fveR?=
 =?us-ascii?Q?IywYvAfS9q0DFr/FFHcgLHc5TRXd0l7L7brzo3/v0rQyd2bqZ9UOSn5Gh+Au?=
 =?us-ascii?Q?v7mgekQ5f2M/XDdrEjt0ZaIf4I7+HnrZYC1+6qJC7F9arUh6m2qvc3VJrT8B?=
 =?us-ascii?Q?m3UUkLLelkkMIFxWv6WkU60J0XfQxtqDp2ZDgbxTgGgFktifPId/AYKYj/7f?=
 =?us-ascii?Q?YqKwcNZ1XJBE2muW7zATozFNXIdnx0a9b76X0yOgoPRmnNhKDUNvPbR+xlCS?=
 =?us-ascii?Q?Z26C5pE0xJ/ODbnOq+0rtQnye2eqGAhaa7DAHazF5PEBrrrx+KaC/sJIY5r0?=
 =?us-ascii?Q?4SK1lYaG13fu2JDo+5XJdiwANfIR33H9KteC4roAlS0VO9yi7mNoHj1XWKdQ?=
 =?us-ascii?Q?aMPYdZFzrKcC/7i3bUcEspxPoXXqf8Ub15dYu4wDswolEYCW1PXZ2XnfWL+8?=
 =?us-ascii?Q?2tF3ZXGVMwxRPRXX59vhcj3FVSgYC9jnip3/AkYjzYl8H1VQFIDgELqwRnZs?=
 =?us-ascii?Q?hdzx9HKMNrUR+uSBrSVDCVm3IZfCQVM+vTz4knUnwxQ/JOAbgQ6zcCiQDlgi?=
 =?us-ascii?Q?w920yoAgG08awgYh3w63kHRkZmZK2gCYxOqCpsisBWFmh465s7KWpDA5nT83?=
 =?us-ascii?Q?m8Uy8NKMkFNEimrkMLucwhWvWDl1bzG8Rw2L7kwhQoYMcvl3HxpHST2SoeqJ?=
 =?us-ascii?Q?fuJcoI9w0qyAvpQXh4grLgOxgt3xnaBY3erJT+Q+i2pewDaCov+j1edI+IGl?=
 =?us-ascii?Q?yJvJEhqybVlEYT3oGxflHeE1O8tam3qtiJ8N6uX8m9+J/WuRMGUvumIZwrrG?=
 =?us-ascii?Q?iZ51SMbjKPA86HbWCKaWIe/FKrJcWlYntmhRLbMGHIyTafi0hO8VxX3OaRrY?=
 =?us-ascii?Q?XGTt1WJBiJHA/lk9mZCVcdZ2yB3dCWBKFpmnNt2eYRsrQEwjwJOt+eF+qeHG?=
 =?us-ascii?Q?kUxVIqvMbSCh6tjIeImGEVuPKEvqox5f5QzSk3Uh9CUlb0uwA926m++wGY/M?=
 =?us-ascii?Q?iuzcSTbyb321/yYI49yPXtdwRVeIyrBGI4c+Aia4wswLCHYhoOKjePPJGp6c?=
 =?us-ascii?Q?UbzFmnKrPQUrjAjzki4RVeXS7cYIkHNlp8hu55yXdTEQuVEY5UGEUiC7ENxa?=
 =?us-ascii?Q?u+w1ljjlvn1tL9LuWSn6NBjQ85KK0i+SIwzz7hMnykSpzMfmFPyVvDLWfkGQ?=
 =?us-ascii?Q?bZs4NTQtN6r1sDKjH8q9thngHvzvkWvKuVdjZ1nlwGlADJS8bUz9JgbYkVAj?=
 =?us-ascii?Q?s2MNz7NqG+QJV7IAAEYVWxMYLgq5peeVxt/Xf67TWlL2P5oc6BFJzI1qDPzk?=
 =?us-ascii?Q?oiuLN6ZPDSYoAr5iBbIkgDWtkzSdYcjMHJC+7HDLERTRw1y/kv6dqR9xFvBy?=
 =?us-ascii?Q?2n3sJ+JTn22ZSoyb/JRkql1FqAibU5EQByaUhJApF76ESH9e6jLkn967trz/?=
X-MS-Exchange-AntiSpam-MessageData-1: sipo5lF2u63kKqSRBXTkLoLu1qwol6UMPOo=
X-Exchange-RoutingPolicyChecked:
	vPEpOFXlTfDpzPIHfxM0nAhcL0tkRmi1S1vfabgSjpdO00K03nDOzSBu9xo2XvZOCc0N0eQsRESIG+xP9upkxFCC14no1Zl2DDICqTlCrOzETgtQ/yu5D5hguWRNR7SnD11mRK5w97E1dxsRSf6pn1ood4cK+dPJgBVLdeZXKwKe0QSWCHVAMv3o6xpDc7zQ7nJs10ly2kIoFGd3HVV3SnVqxheQYW6dW3Q06jM3KO+mhaxq1veVzPNfAz+knkc5usv4f5A83/FK1lg969b0l0i7Ja5dxGtRAYgpWHpMkHAGbQoiu0H/ZLRiMnlitcFtg9rcSlkn175xvt4UeUcCZw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JWg31V+2bOHg/kq6ZlYoQEi2/da4Qget9rxnGMYzbS+aOfND4PROqVR0+UT5bUkAqX5FFQ0r/Hrj8x36ndvuBKqp79k3mOyiZJZtnk/mF/L1t+QAi8yYEf30RllYSurOMGxETr+dOrowodJ2VG/ob/rt7AZXMCXGuHhyIzc8WgAQmpZY9y/NaEm/IYfG3xNkmgXdpv2ZHRdi4xEyw6qukD8ta1H1Roiz/a3EIgrWVCCJ8L/Eneh9rbnJ8jZv8ywcuYDxiH4bpzAk58JPF+WeRrnhN46DwJ+CEwCR3uq32AuL7hpsMGddVgC11k+3MnRFqdaOL2mAPiswffu4d1+LeooJhFqGj7sLp60Q5FgEmItiPlfBU7NJqv3rzh6RRUwC7/QE4sCe+Qi4QFnGNUi7ON0zrd5+iwrK+HiSUCOY3IDLyiYOR66hpfagDHnyUruzAlF/oMBiLRd/jqDg0j2GeBNt//9WPt1+6BS7iYDiB2oFQTKjdUn/Dt9jzNoXRh21k7f5GEfsTwT3raGrqP3UMQEKh41/gtaKX10TYVhFmWO48k7oMwezbXuI7k/M869s9pckGopnarCLx297a1IBqyT0UAUDFliepbIvZjt73JXRNHHWCJbJjjK6Bczx/j1w
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 830034c5-f02e-40dd-41c4-08df07f83ad7
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 07:11:23.1510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhll2IXRPQHWl28liIXAyYT1fmv1gLICB5FEQ1otMenQn0wQYS88nqe2u0LfGCLESI7jC/5DYI6PlRfcbh5vf/+kVJiOOniTjG3x5vZAt4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB8809

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
