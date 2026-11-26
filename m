Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795686524;
	b=0tj6fBIIhZPUW42UB2RD4zm0RK8WqORx3/s7VsmfpKvvTZ5gIFGoNHAwAvZOIp9K5Wf5
	 stsoULV1kWEcNwjIbeAN37/63D2yCAKOc/y215xAe5m92y07R8aXvhtjAo9BnjEY//anc
	 pcNWd2nbadmhThYLu0iyZnAbXGIysXBbLxUkyh3gy7jB0fM3zl2A3HxTcvDqcc1U4ecK8
	 ZlXzAKSRL3PZqy19/1Zaj/G6/jjaIH6Tpof5cC60oWx2mU0Ol7IrVPE8L8uGGNYXNcTX8
	 GZIqT3WIZwF+Y6AXrD/N7TDzdsKFaKQ5MOGKhIhv6BccR7uqwKWIGvqnfRtBAEJCXJQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795686524;
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
	bh=YhNJUWEbjgDvWySPa5Sqt8s9pnUKgboJsXpJneu1H9A=;
	b=KCPf2RoaDw/uAF4iXC7GGW2voSgOCRnEXdbN3dhuwvDGYeOi20ryqRdIe7r1wmP2pgWb
	 YclRXGoSuC3SUIwxctlnHk593N60QgpfGctrI3RSggphGN/cs0q3NkNxU0ZS4kG/w9P+8
	 43WNFkfDgW5RP4hvzUVQo0oPTLu9MrLMHkUpE1wbbonhfSysHfiQfl0fKZR/CMMgvnGiF
	 DRk/tb5Lq6z2xn0PSXvqxE0FEN/VKrM3adCnwBmK9zXT0+vNThVKlhpPaQCPMIcXUWhW2
	 TGqu6eMrIhBvirxtWh8HtyG0tP+DeMvOLYAYOIv6a4DZSeu7N8duJ8BDU85DXDPgUUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=E2dFsdfy;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=vHQ1qJ2G;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D029A606A31E
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 09:48:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D029A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=E2dFsdfy;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=vHQ1qJ2G
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795686523; x=1827222523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BxnPLnZe1RaBKRFePzOtaYvgfqacsCBbX79jAhyLF1Y=;
  b=E2dFsdfyoXKDwTKVSybc0AsHxQ8u8soTLIEKwnw03g+/ENjctwBy/mhK
   SgOpRYNUZYEqPV+YeazEAqenRxPQDrcFzdKEwNU0MWNWUgOjxTgbzHij4
   lQF/E+j3r1nVeztwXuk58+2EUh+6dkvf2y273Rty1VNQ6WEITf352HgMM
   aKteSgBjLn7B6GpAzp9205oarSS4CNoj/gtpVyDdQEL+JfyMBibYQ/fPy
   H84WAOn+qBY4lyN7BucXdU3E23vZbmQiDS22t6lEKW/j7Qku4UTwh+9VX
   1lNHyxwtQyCHI+hd8ormBvl4dwHdKYew3tncJL16GgEH8kSt+yfvOSzds
   w==;
X-CSE-ConnectionGUID: rsae1Yk7SEWYm4RGWFBeTw==
X-CSE-MsgGUID: 7R9HOuDTQ62oooPASRI/Wg==
X-IronPort-AV: E=Sophos;i="6.27,234,1786982400"; 
   d="scan'208";a="161749081"
Received: from mail-northcentralusazon11013066.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.66])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 17:48:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DHZEOLq7Yaj65mTa7jzjg5i3T5+sAFUKNhLrz2ukSCSTMim2l4pTQz5arRyYI8EYlNnWofh8eM5EVnlQYOS+xNPCvQlKF0vwGDukrbXjrrMUAoEHkTNugVtHySd/bqYqUt/vGbJbAZ1/Cdohh0QxT1N7l+7qZfheI4wqQDCnBXjubhAfqNE8wbwMjV0EbSZ+7cvW51OVZkGFxIgIiDhuwi+MZfTJaQXCzXBMmQlvAJBXg1p/3jmxD1Fl93fPbJqIzeOgL8D4Lv0DEcZ3vOqprEqMtYLcSyPL3/9WQUMtcDfuMzcd6EqemP1+wmIISpYpwZCCyJfG9CHIO0HgB6HtiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhNJUWEbjgDvWySPa5Sqt8s9pnUKgboJsXpJneu1H9A=;
 b=ALPhlvWr5Zp4mr5Wy1HOoV6vzY+HCg8tTrjGf60mJ8pA710HkIS4KPhPIV3YMCu9yoYpH3BZ+Zs4Oy77TPQKYNqEtk7PkTvEFeQcRfu7biVEh62/pTCNmJ0bKxTyNRwgVMj0bPZqnJjN+IvX0MXRknq5SSgo+8vSQo6f+AtW1fMOC6g3c8bcJCHp9wd+Jyeo6+yoLoOAf7VnxEVqyDPH/qg3YrlPV6XFby3aild+cOTCZPVE/B3HfLWEXtppK3Lp01MOXTZJPk9woAMltchRKDqrxtmr+IApLr8qa0vsc3FtSHP0NAr/2mjWecF7uJBwsCizMnFLY/I0CY8P2KRjtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhNJUWEbjgDvWySPa5Sqt8s9pnUKgboJsXpJneu1H9A=;
 b=vHQ1qJ2G+cYlxIjlFbLJMqC9fUOSHccSXMbi9DV9sn77F9JMNj+2VWsgfBuTW0PZol6m83YhmDNIqF5CqxPE0OOx4dRjMUXI969NmoZZkuVfN3C9Lz3fPyj/5nus5YAgylfAmTGpdYtbob0Q9+JlQVcpFpaS2rA8HtfzKSWDCC8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY5PR04MB6883.namprd04.prod.outlook.com (2603:10b6:a03:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 09:48:39 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 09:48:38 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Dongjiang Zhu <zhudongjiang@fygo.io>,
	Mark Korenberg <socketpair@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 2/4] btrfs-progs: zoned: add btrfs_finish_dev_zone()
Date: Thu, 26 Nov 2026 10:48:13 +0100
Message-ID: <20261126094815.479691-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126094815.479691-1-johannes.thumshirn@wdc.com>
References: <20261126094815.479691-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0182.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BY5PR04MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cd510a3-d958-410d-8b39-08df4ba27278
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|23010399003|376014|1800799024|10070799003|11063799006|261009223027099003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
 DCgAhtx4x+44TJdf6XydsEGFG3inG+JNRY2JQae6/saoTPWz31KOoWEf5IHeH0xZuFMusjsv7PbemThzgDxYvF6sdrKzDOe4ej83qyqn05LPw0/bv6hZzu6E8MkOERobsZLDKaQ2WBicJrg5ZQDmudJ1t+7YqhQUYhyHkD199YjsZWSP/qVQOTtVlcAOCOQxINFsbbAXELoY7UW0PQl1Pf8NXeW+nElNqdEANj853wVEJKBzP4wB8piOn5yGEmi6u0xmSDpFot1ve+W3b+YKF1tqw9DrHNULaOcNL9g8S3EN4zCBOE8Q9FsXX9wXuGlEVlLfYohfFhf6RSmEqz9/AHQ8pO1qJzvLPMJVfOaYqxUUp3cOa0qDHFJ1mh6cY2HTI0X7bnviQDm4ZfSBiDZ9MMPLAXfCR5UShTgZGtEZpz5CqB5gWLfWldXmlRM1SKl4qkWB8pRN7sDmZs7bWRWhX18Esj6n8khCgMmrktOWib4+GVRdW9sZH8WjMK5/8Bkhn/QVW0Sc8mvwAb+7dnGEwZgziHZEclq2L7BjfwvaFdlcoGY6cwAbiOCkga7flL84F3v4WdbTUoJIwwfzld5ktgvrKWrgZGW2oZ/470QdfT+/SiKdAyv8OfsrY3eYtezNZGWbrhbyZas+e6dorzSh+IKqmLEsvyDVJ1jW2th1wwY=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(23010399003)(376014)(1800799024)(10070799003)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?f0aT3LgyyW3nBE76o+hq6rGK99oy9ZsT1czu2sDDepsyRCeOaOe8LMpTdlmq?=
 =?us-ascii?Q?+soQX0CpqmPffT96MscmjcSGMeSs12H128f3y0lHBgPJSNxFYAHFFGUBGfSM?=
 =?us-ascii?Q?XlPYmrf7niShqQMOYVQU+LZV/wPFb3mNdGgsPpopR1+OcCzSWf7M5UKNEvVr?=
 =?us-ascii?Q?LdVach+UHFuz43+HITqup2oD9tVSQM29cAZsaEJcvYDYTj+0hjtwrmuBYTxh?=
 =?us-ascii?Q?DSwekP6nf1qen4IgNYJsH5u6mHDZxmgvXOH71Cr+A0XHGAFhggwmTuDRnskf?=
 =?us-ascii?Q?VBwTGMevgXgtoRtVeMq8UmtQnPmiXHSk6e7oEVqUZmPJjdF69qEAhOmD4r+2?=
 =?us-ascii?Q?nsb+ZLpESDn8Q8JMbtuBlhT2i3Hqt0HHsfsz1Z85R1TdkJlZ4nVVL7X4IJlo?=
 =?us-ascii?Q?z0cPOidu4eMa618Kct9mCpg9vGJ6tc8AoeuAHC3r8MZkxo84zDuA5K4Xga3N?=
 =?us-ascii?Q?JxQK9G8lnmOBptZILpfx46cX/2/yWO3vgDFAf8bAuAqHHFOCZMhpj9fVyl5Z?=
 =?us-ascii?Q?AzNlOk+HVeYOQG/bwqNk4HLyBt7zeJ243xb5nw3OCsABNU12DhxrRgIfdLbq?=
 =?us-ascii?Q?DpapdqDBqbVKnin8OMuDAcmtvRvILPVTrk13NORtrKlaCW/oy+OTyZdzOZZR?=
 =?us-ascii?Q?3xdKIWCMvbv9F9fnkayKJcxF6OdziRbRIiWo7yLUB8XqrDdyNXmUB+wV6xJZ?=
 =?us-ascii?Q?7jv9yFO1uldY1AAMiqLCG9TlTfQljFzwfYhwNgFSIPghWQ76C3sV4q/2vxoS?=
 =?us-ascii?Q?5uIKtt0Q82LTshmJza7yYkg7i/9M7tAr5fgu/GiksA6WlHbe5Q8Pyde4IvQI?=
 =?us-ascii?Q?pxUJcymbMCKuOlZ++6O14Ep8HYLwUvl6EukpxDgskjebV/fDRxoZgkXNSJe4?=
 =?us-ascii?Q?PlFXgEsCsHI3LiRnmXzleaQdmBpwXcSRpYbQ7Qo7rlBLUhXJ80KvIDQSaPG+?=
 =?us-ascii?Q?YQyDR0BPBm4vP9OvbWPhYm7g7E+u/kJWuIyW0fDYk/W9sBfidWyURTxkG/nh?=
 =?us-ascii?Q?peR5u/BmmhocT0RLibLXMY4GpfuGSbSPGZ7iKVwoO9Gro0A78YdRKMz6qina?=
 =?us-ascii?Q?53pbcH5fX3YwxysGBevgNzvsNFYfCKwgw8idHYbEYY2d5Vd2mAiaJsj1/VL7?=
 =?us-ascii?Q?iAFnEVn4JmuRnqO9dKsmsoWA4b0YVkHmcPkIXIq+GbrCPKzyJj1hKpUgZIKr?=
 =?us-ascii?Q?M4G6GqaUQyF8vEuttvCrXidv2lRFNnx1b7u22j0InpFSX9jOPJpzhxu2ibwn?=
 =?us-ascii?Q?VHjKa/eCAsc+vZrviZvPl8czmXm/XTO1kF1KDQ8CcG7Sf7naeaV6wj29rYbX?=
 =?us-ascii?Q?B23twlpy+8JqURengB5/MOMGap6vxY+Xy8ykVWWz5TUryEYIo9LBLMEqFj9D?=
 =?us-ascii?Q?5UJmtOEet9FU5pB359PtVyOxIzmnQKDIZ1PWQQgaNlQUUbSuOXxmTDcu+TiL?=
 =?us-ascii?Q?I6Ju7xzHLZpnxF7gP88SOzjGcN8QyIip2LLYLwpp77+6IGbqWxezqUzOlXF5?=
 =?us-ascii?Q?dtbl9bj3GuFqwtev+Mbc/GKODssf7AsV9rdI1pEqsFY/R95fxml4D2Mzt4Mz?=
 =?us-ascii?Q?ecEHYyPC1eCUBsFHyQfyNna1BSS3AgSEc8PVbH69V2yYCm0im4ijjvtIPDIY?=
 =?us-ascii?Q?AXgjsQ5/04xn0yYZieNCZEky631KnUQqPHqTjUjLVDko4WhHRLGXALfhdBNZ?=
 =?us-ascii?Q?oWuKu3D4ApzGE0Dv0vAORM9Eg21WgwbWhRBW9ZTnp1u06/cPGWX9jrSSv2Iz?=
 =?us-ascii?Q?KkVc93mt3IWVMQ+jA93K7pwsVzgckRjK9NnQ8ravmub7Gi/cQ+G/WhvMr+yi?=
X-MS-Exchange-AntiSpam-MessageData-1: 2UmF9SMj4UsGWh6XEtYioD3Q3u0xg+j+tQI=
X-Exchange-RoutingPolicyChecked:
	mFqiL5WyKu1M7kABQn/G8cLdalCmBHPco7/mOQyFW9hbwzBlwbNamXVKAT72fgAVgNqoOx+bR8qoUxVDYNbHS8FHldH0mYMZeE1m90o6CwKIJYHyFfh4vu6y9cLXj2kX1fE7A8ZTFzlf8sGa1S1WjEJAC9lWltyNvVnh/5feN9iUNY1U3T/pQpVf1tIy7nCdmT/4+r4BR1dhI7stlWBQeg+2vMlZdimN9WEd9foQFiPr+cjvLu42gq+IHpMudge19raAFpsQI1sqhzp5zo8QJQ1LLONNer5P/1Iyhg+KfCqeGc+WlDOWEB9BOnqK84Sw6WC/kaMIUHKY1EEOviUX1A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a8NVVdVXT2BpfVHXcq1uum/oV1RSVmyNMxVz3ham+pTyy3IvE+libKKKN3DLf2tbttpcYsTrHKD0ggvl87Re6sEGfsyvTX6t8VJNOUNfmc07KU0Wq/29ZYuHjR1xwWaKNLw0uwPouRIgRKVES7a/fNa3EppPOST+8ZPWz7YA2wqeE8qgK5pe9AVgRyOjuoRAZjRuRNIK4Xp9S7nTtWTqL628Ewu88BDnfYXBRtve5EZPciIzJVgxaQHCP6KkKeOBuy5BzbtdTK9wWqqs5PGUG9EiN8bOlE4MGhPzixSvYPh4Knxf4XsiI1KVsn+7Tj8Ve835zveli0RfDgAot489Nh9yeMnrhkp/s2c75kJMevhQqQ085ZEwRDPk8L0kV68qdBg64k7sOxSmMEVFM4kjmfNHB4r4AoXXVSiujfTmo54qt7VjcETpnJKGEe8fUJoEqUVXJpqdyNHDZ+E56gX6kdxLWAebHm6zBuuFwLX4BPyLq/68NKdF7wwSZZYBtWUDfPW14IWkNuC0Bn+0ChKMX4cYWen+YVicRr3rtwSaqh10J/VPsC/sbJh23vYk8zG6tnbv4NbvKilhjP0f6adTupwquJHzRMBeHy7uLnoy2gC1pettlTiWkKejmx+YGUX4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd510a3-d958-410d-8b39-08df4ba27278
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 09:48:38.8377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J/73v7eWDr26CBEw+a2s1J2mqKmUGDCEW1rDoN8jEf9YY+VHE7bQyhbcfuisSBE84p1vnffEJgqO50M8jh0Mbyxljc7or9ZqRiDVV37jLG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6883

Add a helper to finish a zone with BLKFINISHZONE and update the cached
zone state, the counterpart of btrfs_reset_dev_zone().

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 kernel-shared/zoned.c | 19 +++++++++++++++++++
 kernel-shared/zoned.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/kernel-shared/zoned.c b/kernel-shared/zoned.c
index a06abdea..48313ccc 100644
--- a/kernel-shared/zoned.c
+++ b/kernel-shared/zoned.c
@@ -329,6 +329,25 @@ int btrfs_reset_dev_zone(int fd, struct blk_zone *zone)
 	return 0;
 }
 
+int btrfs_finish_dev_zone(int fd, struct blk_zone *zone)
+{
+	struct blk_zone_range range;
+
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		return 0;
+
+	range.sector = zone->start;
+	range.nr_sectors = zone->len;
+
+	if (ioctl(fd, BLKFINISHZONE, &range) < 0)
+		return -errno;
+
+	zone->cond = BLK_ZONE_COND_FULL;
+	zone->wp = zone->start + zone->len;
+
+	return 0;
+}
+
 static int report_zones(int fd, const char *file,
 			struct btrfs_zoned_device_info *zinfo)
 {
diff --git a/kernel-shared/zoned.h b/kernel-shared/zoned.h
index 7dd86e4c..363ef4a7 100644
--- a/kernel-shared/zoned.h
+++ b/kernel-shared/zoned.h
@@ -158,6 +158,7 @@ static inline bool btrfs_dev_is_empty_zone(struct btrfs_device *device, u64 pos)
 
 bool zoned_profile_supported(u64 map_type, bool rst);
 int btrfs_reset_dev_zone(int fd, struct blk_zone *zone);
+int btrfs_finish_dev_zone(int fd, struct blk_zone *zone);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 				 u64 hole_end, u64 num_bytes);
 int btrfs_load_block_group_zone_info(struct btrfs_fs_info *fs_info,
-- 
2.56.1

