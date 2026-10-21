Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590145;
	b=Apz1/ucZITQUg3UvA+MYHrrLlmTzXBh6wdpr/i3D+e9k69X72neLNZHiHohdGKjI5efx
	 COpeCxRoC2B+zX89viYz45ZuAbpFmr3kypow9DC7T/NQJ82/aTyDOs0aRad2LWdZsPggp
	 bv00Pu3tlJYixaRll+vaYxrOB5IRTQt+IihtojIPDrm3mBA6RSyNSQSH99ehWMfOOoz1D
	 Varvm/xRoUHAOaCiY3vkYi78AsWqjMCDVGLYq99S03QxHuknQGppI4U9NsC+umkEqzjul
	 DdgULgJX2wnhSv8Vz+Kxgc+Sj/F6X7DWtunBHAhm2/mgukeTW0v/UGkeoZYYLpQMfVg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590145;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=BpWHXJxDngK0PGvRupV6TObhUKfRWUKTWGfLOykaIwM=;
	b=F26m0mYFwPCyeImw94pHz8+8bCkf9FCOgxyRZRtlKtHZ5HAo90BVxRR9/skvxyLL4uqD
	 Q49GEKpkwBXzEXWgXkiPlgwYexqlGUmsd7wLhyGmQDZrXnwyxIr2EOQ2RjvH5gZEbSQcM
	 xxmhoHES+G4g4Y+LQMOcYcallUS6SEXb1ZRs7Xzjvl6CDQYrcYkK07fVNZ+4jIIp3mOlO
	 I1sw5VTfTh2MakmR2LW0VBukpbATX8fTcgw5mlDmRb0oxRtcCaYu8Hwi5skrYOdzaxwCX
	 vPpxUgiZwNGM5vS/ITFgXelVQXosggqEAZ9Rw6hG5mf8xzujKzl2MYCL9KYS8QE3yTQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=bRhWQvuB;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=MJ9dMti1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C0E606A33E
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4C0E606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=bRhWQvuB;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=MJ9dMti1
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590144; x=1824126144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Cq3WlU4jimmQiU8v0iK62k0ot4FPUwSPn+UFsLjBTcQ=;
  b=bRhWQvuBCX1Dy2bY3YW9CCgAmI/iX2rp05VY5RQvT5Dh9ndJ+v+6AvdW
   EmlYgtjKjliFpTjSF7+PnGE1u8LC0X7fZjylT1thyO8fPMoQDMx7rg7sM
   q9Hk2aEiBM6HL1TmqWyPcgOBA15vV1Leb/CPulVxJ3NZuKyvx7Gr8xLRT
   RQND+2bz/PRhsyEuaAOz8qrBOmQ8EldthHyUJLZK3RQckWZc+1xqz09i+
   ByQVk7HpRMX2bxbKMkLlHatiLVmbzrVJG+UJn9kFW14EtMnkHCMjQi0VY
   8T8JepqkbDiFnWVZATD8p48KBYp+lcYARYMi54VrzHDD6AOdIDSEKG0Bw
   A==;
X-CSE-ConnectionGUID: P4wz+/ccSny6YkalJUxC+A==
X-CSE-MsgGUID: 8Un6v4yKQjSinTmbHfNr9A==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="159601520"
Received: from mail-eastusazon11012011.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eBTa6KssRiiE+xGBJ1qowX13POwt+lxDw2ErgFzB5lqlArmBcU00asxT1NC5ZnP83BokaOxzXABP9owfc5XOXg6i261D6gyMaoYgmA757pVR4FcVe+/nrV23sxaZT8DNbOBiEeV/m59R9xe9z7S2+rKhwATijBLdeHyBUuYkF8u6gwOH7gvgvZYZBKnxufthsekD7YMhyduL/yudHitrnzzxfhGCrT/JlbfCKoz0ugebUgGZBybCzixjFG+8vPHfZwBN5y02Skd/1ElYjPgZOT7LKXsU+5bQEsnOIyB1xQ+4tty42cDVKf2IjnBolseKIZTMXxoTbQVD+1HWsm8k/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpWHXJxDngK0PGvRupV6TObhUKfRWUKTWGfLOykaIwM=;
 b=wYVdzH6Gau7aA0u3Y4V0osdXCtqL3Cu195PHEczHSMLOSLibBK8M8Q6gkYdk1nyp9xOh9K09YUt9xwY+GN9pszSKHwGCq3JAcNuIV1c2eYj+LDZCKTKYvxCBNIqiIZdUCGH0hRQD3rsK6AYoOuPVjEAv0NA8UDU1c5xxHRBezf2aKS51FNFNUK8A1fw13jLL9O9Kpzys2NDBAWmLUU0f9iVKm1MtQjpGykelfCb+b6hxYPoXrSqKId4zRmj6KyKbv/D+nN5fqVrp+PQYAhY0Y+d9mBK7o8o0cgPHyy/ZRwxh7pCxhYah+yJJPQ7aC+x7Vv29F8HqQkT+gya26D9n9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpWHXJxDngK0PGvRupV6TObhUKfRWUKTWGfLOykaIwM=;
 b=MJ9dMti11iie968EvEQfnvCXOiOVkRDc7upnJxj7JHIlesi+Ju3RYiZewf7h/VHs5oDjJc1EE+WNri6ILN6GAIS40vCwcchJz5gWo65HtISDlf0Pi5Dk/S8ESwpShtFs9nyXAdKOnqRQC5j0lJiyWXyQEvARhng4rdqSiS1IySM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993834.namprd04.prod.outlook.com (2603:10b6:207:304::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:21 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:21 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 21/25] btrfs: zoned: reuse block groups emptied by reclaim as relocation target
Date: Wed, 21 Oct 2026 15:41:20 +0200
Message-ID: <20261021134124.2338902-22-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
References: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL4PR04MB993834:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d8c2db4-890f-491b-9cc6-08df2f791f55
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|10070799003|1800799024|376014|366016|6133799003|22082099003|18002099003|10067099003|5023799004|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 QzXnHGMN38p+vEqhA9e2Tpyy6wwYwCNRG/MIR/uMDoEU/az1JFUHHhhZh4MJzeoQ5twEFdlweJP8uwzpcPKorVJmYGoV6didoyChFic9YZyWFvX5qI6nINkSo322NkhIrHcpyex+MwOQBpv/qRpGmj0nm3c8IZkAFvKiyq+fZZDopslZ7JOFjZBgLbGGZcytWBOccHfnKGuJWfPLMrT6+anLTrLEWGiHcIX18nGojJfBPLp8KmYdbkXoPM2ce5ghmZ8tsSVHgEG/JpxYCodo3lC70htu8zwW2R6Py/xLvOAD4DP+rfNg9VFVo5MIM/WCVD4LkM6vGCYEl63jWHwvAC2D1b3ZVbHqrHv1V6bpcCKk/Tm3XGeLACG21rU1SF0D0t978iy3hYnfeKLVGbxX/btyrOKbE0Kgmtq/7/enueiyXIGU2c9Cbl6mD41mxddgoZrBDYCja1yNa8+E03Y7abtN5gtLgjSUDILjP4ihTalxPTxk49Ll3RfKo8NdweOLJUJ8fSerpaSoSIvIHzD8p6zEloWUnc6EDePNnnIyEm/L9FjVo0QOqJNcUbqeLHbRGxxLc6uj8xgTj1nhCa3JVz1xO0sRThtLYiae/Ys/HDuvL/NCOA3KXD0A+LdhD+Cu6bXXipAvvLwEBKh+R8S/mw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(1800799024)(376014)(366016)(6133799003)(22082099003)(18002099003)(10067099003)(5023799004)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?b1w7VClSLa3e3feu4rRiBg2trj2K1sckqwTWxKq1B5uRdjxkPm3GHfyOH/RE?=
 =?us-ascii?Q?n1go3bV6rQccO4MPxok6uENKJso0nuQu9bU6Mgy50enTX2W1q7RzmQt6rdWE?=
 =?us-ascii?Q?lRENai4mnMT+2S8S0DINIXhhQ2xwuI8Cy5BuCXWEB8d3d1+n0YpV2E1QURHj?=
 =?us-ascii?Q?QPNm2ISj0mprzEKfy7gKXlRcZeWtEVr6zqfhfnd0mZElBbeQPntoG0MRERY3?=
 =?us-ascii?Q?taZItjFFoYKY5lIxi93iHTBvEycJvzz3zvNs5LVCdePTdmqL24H3oSXahsDl?=
 =?us-ascii?Q?7WvuPv0li7eZyfdZLzk528r6LnRN2P3jvd9A0YLPnsjOPfEO/6WQHY6ZGpS4?=
 =?us-ascii?Q?0Z/h/brb+FPw/h7DQQKthME/qg+wCyy4dOucXtHtHBY2ONbBLG31/HqZ/IIx?=
 =?us-ascii?Q?rQxsiVX4FjxgTe1+1zoeFQKVMIB2VdmFww2vpsTncz0LrI07MZnZRbxfd9Ll?=
 =?us-ascii?Q?KgulY9ZE9aJ98MNXBqpZNrfyja+L2Rq2yKWiiMKzUsPNCw3yIdS7WLj1dcHG?=
 =?us-ascii?Q?qsCsRCfha+dBM15T5kKtbnN2oMYYVdo+0L+0vBao4bjj/rlbjLSE2TtpTSZS?=
 =?us-ascii?Q?xbftANhVMIk6WUKdShK/homyA3gBM9Q/jrVx0ttq6CRs327E8Yg/LLF3QrBZ?=
 =?us-ascii?Q?ge3cjJSUhyqdD+7yKnVUlPT6kBWXfizZcpfNYhaU7d5ThpKAjezW+ZBvsRyJ?=
 =?us-ascii?Q?CMxXEbGMWWtbfwS8w+gG5mcEVSJPOomGCEk9RP/9pvmAYZdN8eMdT0ftEMXn?=
 =?us-ascii?Q?nAFFkfnG0xGUGu5WCM8mIBZ4fB5S7YKI+jt3LR4BI4jsCHsbtWV3u2pFzfwZ?=
 =?us-ascii?Q?7/3r9VVrVWn8hulnHI1mwhlwPmLNnQk1L3Nd9meZf90dJ3AV6WogTKhkML+W?=
 =?us-ascii?Q?SfociNnLUv3tnkh67fNURjXMFlXH7ap1hitICwffZl1DjRCPi158tkzm+x+N?=
 =?us-ascii?Q?U5qvT77VCHyU8vMftYLMOuhnmMgPLlkU94x2PIve7wNwjIKNB/C6yCDidD/j?=
 =?us-ascii?Q?i9PYcfVhJxlPMDWt3MzpT05WjOcYLAybKT3fIkLKLuLzQaAh3PoTuDTkO/e0?=
 =?us-ascii?Q?x54Dh2KhNauq0LYOH0ncheYa0n+NO8MtQgnG1fJQ8zMwOI8XepH1MmH0GdpV?=
 =?us-ascii?Q?G+YhC+57tJfrYkjLIprOoh00/26wPjSmRJUUHKPyYnF6Sv2X5pAlclpTn47J?=
 =?us-ascii?Q?Lf+YSn+m9xx+14vHjbTXxyOKzxVXfBl95SQOGGp3PMvdqwXKuBQRJkGLEF5D?=
 =?us-ascii?Q?y0bsTHGOIhczapsP18mVoSqBssRJ+jfQj5rbHdBiJa8cwX8gZZN0eGRAjlJf?=
 =?us-ascii?Q?TzOToIJt4hhFCszFQ9Kjc8zDbsQDXit1wUcv+udEjJeLrq8YSM5MsN8lIdfv?=
 =?us-ascii?Q?l5+UZ+bgEkRh5/m2jO+igFvcNr+CtgnnJ+/Vwli34wEiKG/ruH5xFGMXwWsV?=
 =?us-ascii?Q?IeL94zNXx1kQWSUGQoo5rSuH1bnnbYHWbWG/Wt0sE6g66HUd37YXJBZktmGK?=
 =?us-ascii?Q?GjJLMuxM1k8uyhJzpDdqOBPybL0Seel6M+IiZfCO3AlwUVl05+CXqyhS95Ls?=
 =?us-ascii?Q?vEkGmzn4PyvDIhz4ELvPyyQU+QYjFi4nZbSoNY/p4eni8AFanuJIeqvkvQDW?=
 =?us-ascii?Q?DKOJZ8Gl0RTQdcwUOu5ecPEsbYFsHEWOPC4n5XJZLO8TUL6fFEIyaJ9su2qK?=
 =?us-ascii?Q?2/7PiMOe1IuwwQPT4rSLEEAV2o2rv20FwxPQYVfjeT86cmu+xRfBQygD5Do8?=
 =?us-ascii?Q?Jz5eFju1GYocPjQlDwiIjlu2+/IDTXXVtqWCNj333h/L+qvSEJ/iickArkpL?=
X-MS-Exchange-AntiSpam-MessageData-1: fk1OcewgY72xJduv6QhByWPGdVwBawTx/o4=
X-Exchange-RoutingPolicyChecked:
	IgIkTSw2xAWL6xnuW0A9z4eE2WpTvC9Faru6gEIV7b8p1x/xgmOXYOd2i9sFVp4OZWOAQB23DWGolCffDvd4nkwXUW/ChnW1bmwIxYVzap5IGU8j2EwWbjoYwhH1M3v3dRCgeN2tS8XuW1/UQJRWDT/I21J5BQ+Fie4JMYMLgkz6zJ6mTLfz+JViiqz4Ys6V8MKYK0QXzW/lv+wrFTWGtVuWjTiccU1X+DP7sJbQWbYxKOxVrat+FB+lzxdULZQOtepxbEGoFhnGRxdNwdeVWzyNujECxwG1MxoUWLj25a++PjpTOxbZxigW+r/ErVYEsbXBVI2Es36ZleAuKy6HuA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JF20opSNARnLHE+09D8piT5Aj+KtB6XA2u68nt1iqfnwFKl15QAoY/Y/pFsBEqYXR2/I4rOYKZHP0SydEyVwTIY2ouiheiBU58YUu/dZdPo4m7gwbDzjWLO3ir4uqF2X75I3RueGbgE1pqtHNdGE917IuP3y0/HkH77igqGRD6C3csm89jiUoXWtosGgZ9OqjFCPNg3yYrWYpyNvHzuSNQWw8Pnz8NVTSlRWTqPLrsDlz/YR7d/bEWdWXC1kJk8sZgxyROs5YOnuD/LFmy7N2YBECXosFjvwAT3dWd9/CALwg5ZkgAYvcx6CfvZvKOswwauzIKyB6wch5VxGlmy/itNLpNgt9IXKJZzeIoHoCVwxTG8Tm00gTIZxbK6bjoffADrVvLc20he6TA1mJxdgr+QH2xfQPErvC3nHez5ErLLjMCq9VMRiRYzAiECs/s1yxes2USli+eEFQOpSrWMsO11KwGwoMHBDaAHznJq3gOeW1haB+NksT9o/Q6wE4p3ZmSfbvR5+my+zOItYtmuTGBTHedLC5CXoYZmGPm1m/qhmHECPnpqg2MhJLkaUB4ny38mYFMQhaHbFtxZijME2QLUKdIn47kc9gO9KNykASlD7SlWWltytNkXNdfxT0ghB
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8c2db4-890f-491b-9cc6-08df2f791f55
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:17.4048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMd25SnqtDrHs9g5YodOvPLBMVbURT1JRphfRgPBAg/RUe+vxRneoKMNRek8sN9B6/7Fc2o5pMeiImjhYz0uW7EZmpUJHeZ9WcnGlQuWSAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993834

When the block group reclaim relocates a data block group, the emptied
block group is removed and its zones are reset. The next relocation then
needs a new data relocation block group, and if none can be allocated the
relocation run has to be aborted.

After a successful relocation there is a free data block group anyway.
Instead of removing it, reset its zones in place and use it as the new
data relocation block group, so the reclaim always has a zone to relocate
into.

Mark block groups that are relocated by the reclaim with
BLOCK_GROUP_FLAG_ZONED_RECLAIM, so only those are reused.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  4 +++
 fs/btrfs/block-group.h |  1 +
 fs/btrfs/volumes.c     | 22 +++++++++----
 fs/btrfs/zoned.c       | 73 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  6 ++++
 5 files changed, 99 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 47143c64d763..b3749df5ac86 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2062,7 +2062,11 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	spin_unlock(&bg->lock);
 
 	trace_btrfs_reclaim_block_group(bg);
+	if (btrfs_is_zoned(fs_info))
+		set_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags);
 	ret = btrfs_relocate_chunk(fs_info, bg->start, false);
+	if (btrfs_is_zoned(fs_info))
+		clear_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags);
 	if (btrfs_is_zoned(fs_info) && ret == -EAGAIN) {
 		btrfs_dec_block_group_ro(bg);
 		btrfs_debug(fs_info, "deferring reclaim of chunk %llu", bg->start);
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index d567ed822e55..ef7d9d04898c 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -88,6 +88,7 @@ enum btrfs_block_group_flags {
 	BLOCK_GROUP_FLAG_NEW,
 	BLOCK_GROUP_FLAG_FULLY_REMAPPED,
 	BLOCK_GROUP_FLAG_STRIPE_REMOVAL_PENDING,
+	BLOCK_GROUP_FLAG_ZONED_RECLAIM,
 };
 
 enum btrfs_caching_type {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 631ebfdb5185..14857421a0e9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3711,27 +3711,35 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
-	u64 length;
+	const u64 start = bg->start;
+	const u64 length = bg->length;
 	int ret;
 
 	btrfs_discard_cancel_work(&fs_info->discard_ctl, bg);
-	length = bg->length;
-	btrfs_put_block_group(bg);
 
 	/*
 	 * On a zoned file system, discard the whole block group, this will
 	 * trigger a REQ_OP_ZONE_RESET operation on the device zone. If
 	 * resetting the zone fails, don't treat it as a fatal problem from the
 	 * filesystem's point of view.
+	 *
+	 * A block group emptied by GC is reset in place and becomes the next
+	 * data relocation target instead of being removed, so GC always has a
+	 * zone to relocate into.
 	 */
 	if (btrfs_is_zoned(fs_info)) {
-		ret = btrfs_discard_extent(fs_info, bg->start, length, NULL, true);
+		if (btrfs_zoned_reuse_reclaimed_bg(bg)) {
+			btrfs_put_block_group(bg);
+			return 0;
+		}
+		ret = btrfs_discard_extent(fs_info, start, length, NULL, true);
 		if (ret)
 			btrfs_info(fs_info, "failed to reset zone %llu after relocation",
-				   bg->start);
+				   start);
 	}
+	btrfs_put_block_group(bg);
 
-	trans = btrfs_start_trans_remove_block_group(root->fs_info, bg->start);
+	trans = btrfs_start_trans_remove_block_group(root->fs_info, start);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		btrfs_handle_fs_error(root->fs_info, ret, NULL);
@@ -3739,7 +3747,7 @@ static int btrfs_relocate_chunk_finish(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Step two, delete the device extents and the chunk tree entries. */
-	ret = btrfs_remove_chunk(trans, bg->start);
+	ret = btrfs_remove_chunk(trans, start);
 	btrfs_end_transaction(trans);
 
 	return ret;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 74cebb23e6ce..1394b7740b18 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3074,6 +3074,79 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
 	return 0;
 }
 
+static bool btrfs_zoned_can_reuse_bg(struct btrfs_block_group *bg)
+{
+	if (!btrfs_zoned_bg_is_append_only(bg))
+		return false;
+	/*
+	 * Only the read-only references taken by btrfs_reclaim_block_group()
+	 * and btrfs_relocate_block_group(), nobody else (scrub, balance).
+	 */
+	if (bg->ro != 2)
+		return false;
+	if (bg->used)
+		return false;
+	if (bg->pinned)
+		return false;
+	if (bg->reserved)
+		return false;
+	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags))
+		return false;
+	/* Once read-write again, nothing must be allocatable before the reset. */
+	if (!btrfs_zoned_bg_is_full(bg))
+		return false;
+	return true;
+}
+
+bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_space_info *space_info = bg->space_info;
+	u64 reclaimed;
+	bool reuse;
+	int ret;
+
+	if (!test_bit(BLOCK_GROUP_FLAG_ZONED_RECLAIM, &bg->runtime_flags))
+		return false;
+
+	if (space_info != fs_info->data_sinfo)
+		return false;
+
+	if ((bg->flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) !=
+		(btrfs_data_alloc_profile(fs_info) & BTRFS_BLOCK_GROUP_PROFILE_MASK))
+		return false;
+
+	spin_lock(&space_info->lock);
+	spin_lock(&bg->lock);
+	reuse = btrfs_zoned_can_reuse_bg(bg);
+	spin_unlock(&bg->lock);
+	spin_unlock(&space_info->lock);
+	if (!reuse)
+		return false;
+
+	spin_lock(&fs_info->unused_bgs_lock);
+	if (!list_empty(&bg->bg_list)) {
+		list_del_init(&bg->bg_list);
+		btrfs_put_block_group(bg);
+	}
+	spin_unlock(&fs_info->unused_bgs_lock);
+
+	/*
+	 * Drop the read-only references taken by reclaim and relocation. The
+	 * block-group is full and empty, so this leaves it entirely
+	 * zone_unusable, just like the block groups that
+	 * btrfs_reset_unused_block_groups() resets in place.
+	 */
+	btrfs_dec_block_group_ro(bg);
+	btrfs_dec_block_group_ro(bg);
+
+	ret = zoned_reset_bg_in_place(bg, !fs_info->data_reloc_bg, &reclaimed);
+	if (ret || !reclaimed)
+		btrfs_mark_bg_unused(bg);
+
+	return true;
+}
+
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 31d1fcb6303d..74c9a4c70d26 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -106,6 +106,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
 void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
+bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -294,6 +295,11 @@ static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_in
 
 static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
 
+static inline bool btrfs_zoned_reuse_reclaimed_bg(struct btrfs_block_group *bg)
+{
+	return false;
+}
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.56.0

