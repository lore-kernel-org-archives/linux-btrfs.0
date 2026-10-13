Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCD6397E86
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876640; cv=fail; b=rYOQTczMEX6LsbMCjkJr9Jgsb4EZqBrTglEk2wTySaogu74BJoQe/Bsh1WhO5rhCA8/BjQlfFkHHo/J20xXWfu9xwB9DZPcTj2ARzaV/qQqfmH4HO1DGxXSBOCCF/uLlX4mqh/L/dNz4rvDAbgvrEpd24b0R2d7QhpqRFK25QdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876640; c=relaxed/simple;
	bh=dK7zgVP3xA7cm7yCU0ESs3G9XPO7Ipasjh0ktjzkP6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EJGk0ZPoUH3P0bSjV9H8EvEOk6276Hbm3zYSQ5bGLdUwyiNZEfyZ2tMDcSszJwWeMUSTQA9vF3Uf0S/x06P7DEz4kBvfvAjFeg5aRotvRdaC2XN/q4GG5Ph2yMakv4fyf7WVcFHran/UUF8Dv2LPXs2KiB0NVz5G/Qnq246+nEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BJtSSvvl; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Fw7+7wip; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BJtSSvvl";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Fw7+7wip"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876636; x=1823412636;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=dK7zgVP3xA7cm7yCU0ESs3G9XPO7Ipasjh0ktjzkP6Q=;
  b=BJtSSvvlC24uXuszB5n5aRdmMMVx160CxOkigL6dIe1riV+dqNWjZ5SM
   095SBxfS3vCi/wTWlstQgCDZQT9JeG9p4GL0kYiHfnpaJMjuJpQnKInAo
   JoxXD4qZDaBZuInytviNq7OiWzCHLrDhnWnmozOQEqReezVaDOQM9Q2oi
   5wZZ3jAF6NJqPZ7w6lZ0hrsmzCYxdaH4p2CXRMhCpOYS/nf6Y41ybojea
   MOIVOyq0jrL9dph7zqhFk0Tc+ykvXsBQHqOM/ktOfg0+mbYd63ocEf1Mg
   u0CiTvftcL0T40gocuVcZzm2joDUR++uDlOgY9QVvTgmRF5pPaDKjnpzS
   Q==;
X-CSE-ConnectionGUID: 3J/ORKwGSKWlmDQdUiOvcQ==
X-CSE-MsgGUID: rFBOTTe1RI61fcNRe+j6wg==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="158917181"
Received: from mail-westus2azon11012056.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.56])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WNCwT57Tp/gMbd7OFH9poUPDs2+P4gcYaxSE/n6jSsazsXOTnlbTfWOR5mvgrj1bjYrIM9JZ9OTgGgNNgmTOXl3qpo0ZI7CREAYVXfRoCcqfFH+UmQ/NoEMZ3Qyop+nTi+HzW/xyHz8ivV/DOMF9ti2ge2OuX1pYR2iXvx9IA/v9B3fGw/fSs78IJxwhfMWWbWJZTk8elqTZVgSEdF9msb0mM/IoYvHSPdtLkYKYGaUmtCH3B+ugaOSTsovPRdKvmbaGQFHh9T+XbpzAsXJwHvjIAMiPHYOcmVS4ulfk+jcPdYZztyzM2GDMp6WlHGLeOAYM01B2EBORma/aGbv4eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lEFRqHIXYEQ4/qBtvtXsOuVo6IFlPHRI2QNyQK0xphg=;
 b=HMEoSe/3chAQASOEmGZrqJMS1ibljXCc6woSEhRK4EDgFxOw8M80MgZ1mfihJvkfNdO77YZw1LDB6U4YKBM0ASj1yNthePomTB5PIuZBvE6kmwL24dZAI7tvDs/gyPCDboiCpsdXjyom3x+T4XQB5d3nIUXOoV9a7sf2O4SjwPrBtYq7h6zvmL3B/vDIDWZWxy0ulPCxfsvi5BvHMgSQCZpwK7fNh1UCa8JHnfzLy2AB6hP00T82/FnGwMYww1xBRAWmbjbFlzSj/729mX7P/4UJAVr7wDtag7PJ4/FmEFqQEGTYbY1NCevzpwmdktM24p7hMN0ofF3XaQjwdK+uCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEFRqHIXYEQ4/qBtvtXsOuVo6IFlPHRI2QNyQK0xphg=;
 b=Fw7+7wipvgSdc7JuMWJZsISMT48vkJWQmCytbfQq4wNOmpH+gXQdbSNYNIK7RsPUfJgFdNgHb+oVxhK46NxWINcVIlXrUtmrsJV9xApC8WSq/BH86cqqUGko2zNn3Cswf6CzukAZU6wKvHv1RInQVIsoGTIWtXgkuT/l1cRVB1M=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:24 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:24 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 07/12] btrfs: zoned: allow restricting the dev extent search to a zone type
Date: Tue, 13 Oct 2026 09:29:36 +0200
Message-ID: <20261013072941.424029-8-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
References: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::27) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CYYPR04MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: d1c850ff-b391-4586-4071-08df28fbd874
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|11063799006|261009223027099003|18002099003|22082099003|10067099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
 sM4chL/B4c6NwY2hjGB6w4On1q288jaMl/JxBD6cYeCBFG8vCzRRU6CDdROln5eFfERqdwpSw5IwmpDFMGRiY8xGssZvsdYPEjRC14PeP7GmfUGoUEB+Cd1HKiMvw9CIQVZ8VB6h8UMCM/RB+BQNZC7/hjCr9IQe5P82N/BJBOWRbdiJCXuYE8TEM2sDtqA0tTK+5IPBnpaU1x8zK1uIP+CGsACBmW3Z/Nc+FRSoKUI8r5Y9wlZ7ZGSyC4g/0abHofA313FKTZFkJfjuo0xB9u8aRG3QmDjfargjmGg6KoJ2hLLA8awFEc+O+D3cL9xTE9Jo+WdF/I2BeK8vTGWuQ5cxE3/zIhSgKL0N7CGBDwq/qmiAeyuzjWP/JMMx1RJqatNh2RJBoIDQOwllnOuBHDpPWItR2+UnkghKIaiWkXKiQTaCXwXpQYru+mxHvUof3WZKGEsofueCIxd63NdfH4FaBca5MlKwErTI0RTYB5Jo2ZSNHdTXxhd13g2q8MakwxsD53QMxf4w5edQnsfwjTls1z77pfsf7Wx4zru0d0gAkyEXy/pi3O8AxGHxdb+e7XdQ8NZywJpL0iGUXlvqEyV8sIEp7AhN66hcIWeVd3BbVsVWo/8RpxgvhOmyuN2mW5ZbyxxNP7wfiIvfbt07yct6pcDWtXBe8Ooiuo2PFKI=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?wjcDocR7y7B/eH8Fz5xCMPrCZ1SO++hpQSpXn2pD/LisGl1w3VD3ko4e+iN9?=
 =?us-ascii?Q?pUXiC0mDULB42zWzBKmQt5j3xWR3FDw2Yy141dU/VisJ+4JN+U6DwU2OKxM1?=
 =?us-ascii?Q?yjPHWmL1635LHBwKrPL3N95IZPlP1sf2tA2AiDu09h6rQeeOR7xSUhGTYlSk?=
 =?us-ascii?Q?4N0SmUgnjem5hdA9kpbTFV7kK2V0d754PnjQ0ibljJGHwO0GnK9zWJYIYnIK?=
 =?us-ascii?Q?WVMZSI/q1KvFHmsL25N4etDDfqS1bKVVc6Wjqexv/j1ogI1g4UUyFRIb7wgW?=
 =?us-ascii?Q?oCuVC/tf7KB5nm3LFoKe3ni8h6AVvgT6IbbjJbkF3EzCjRDBf708GvWNd/jv?=
 =?us-ascii?Q?IoXJPdeSt0kSTkOQdbtPW8ZxTVyz475NjVlzaOJj2fLOyujYmb07pawD72l8?=
 =?us-ascii?Q?VB7f5y69PmDh4oMKomskxv6LSRtddAGHa5OKzO6PYDAJnWF6Mq4+g9nBsqtK?=
 =?us-ascii?Q?Z1ejAIEaFGGivTZHtDQNAaDUyeUeR0QV2N6iyenrv647w+jktBi/SotQCeyo?=
 =?us-ascii?Q?HX5iNYAOQTrU/Ul7edNdwk0snKKjGbb0UGxFLJh60mSuucpbFp1bBH9LDYro?=
 =?us-ascii?Q?74a/XH5apVV2EaSNnk9rXnbhBCt93V21pArataI4cWrBPsZNZV4bl+rXANpj?=
 =?us-ascii?Q?9qSSbWRfKDb1bIqQpkdumJ8JODg3SG3J2JS3CYzgHv5iWp+dmy6LyHQE9i1b?=
 =?us-ascii?Q?RAIyY/bUiNrl1sPG6W97zG4Gx2MrI/shoXuQRSfNVazP5Y7xrrOVDM71kze1?=
 =?us-ascii?Q?abmeBq/ei34eHsqPU4HPkEiRB4dI+YcUrPw9vU+6r03WtSU24l85DEE8A5fR?=
 =?us-ascii?Q?O8Z6SEe0Q9Ou32N9tFJooSfAjiL/pLl6K0Q02MReWBqVR7Y+xYyAbaBSz3ZK?=
 =?us-ascii?Q?FcrTgV3rH698YcK+5WLstLm9GLxFmWrzsxzrgZvWUV7WIUI8o24/Yt7eqktm?=
 =?us-ascii?Q?yWflFgWwlg+BfvLpt4h/uAKdaY6nepJOtlncZmFzCpWRxZE3slvZ4RFdAj5s?=
 =?us-ascii?Q?OoghVjHd99LFL91WyrM1Q4YBnADM3r5grs9TgamBL4GJlSWcs7KQOr0DqKEd?=
 =?us-ascii?Q?wmAeUBWembh2txW5Keaesq5h7z+7syoe4WiTHL4WhAR3rbKpLqbnVHCYvSZl?=
 =?us-ascii?Q?d1S3Rk/em2QQIoyBAFQMxQ81QDW2k9uz+bMZZGJlytbSf3CorwpdOvNHlk+q?=
 =?us-ascii?Q?qsN2met1leKzctJIaLyidXZX46Lsz1cL9RN0m9fbu19f1zwDIxzoEc5U48UF?=
 =?us-ascii?Q?PIs7FGJSe06hL8wC26T9ZrYkFbl/dQaEg/rpSLQaLV+GSmE62lNnGSFE2pcV?=
 =?us-ascii?Q?k+Z03AwkdxX3UThM452rD7933Sno7sj8djGagCWdhbbSmN/iSpJaZ3ladk0Z?=
 =?us-ascii?Q?/5m3tc8tr17sVI2FPBriUDYBvnIs1zn5dkuGnkvsqABP2xX33thMmKY7+yD3?=
 =?us-ascii?Q?C6RIOP0Q0pAv56TYclqE3qGIDMGb+3PO0IDcxNdhJoT7UiUY+cOcY6RdI1Se?=
 =?us-ascii?Q?pt0WhEp8Y6LHtj3KoeiLgTF1nDvEuBaXOuTa326WuY4u2X9oY/ZV1n6IZpAl?=
 =?us-ascii?Q?WtN9/dGBrhptAro14YiHq21NUwZPyMBm9eq3XuNgzKaHJ38+o4w7kY/N6gXP?=
 =?us-ascii?Q?HA9ixQE/6/Il21MvL4T2y4u56WKWbANgo/uf0ZV5VtM31fWIu3/X/DTOng67?=
 =?us-ascii?Q?hFxc06CJuCNSnLvFVaok9BqxGE11yUaRuTDAq7iL54x9KkJnIxdJarP2ospo?=
 =?us-ascii?Q?3I1DZ5g2zfZMElwLWFh2te5AUl3l82jHVwDG5Eb7xZ0rIHmNhqcdLRp3iGy2?=
X-MS-Exchange-AntiSpam-MessageData-1: hem3BbQaILcg1foKgyQf4h+HCOJ3wPO6ZZo=
X-Exchange-RoutingPolicyChecked:
	IBOGbQyO1UYLMl1KKanjME0Y+vKHAgz0XFaE6xihf2WnrEyYe8Nx2pPnBGaZFlYD/PxpSrHksAGPmLZcGyzZqN3S3MRAWB2FsGvt6S/wtpUlrlNRD3gCy/NBh14k6/g+SvLjjYSOI8Ri2JRxpnHD8J25UN/706xvUBL3aGo9xPG08HNcnoNbbmznpQ4qJBR4hhK0Stxe38TVZ+QfMTjSYTVI4L8tQ+/+Ks/gENk6m0ReLwFBCo68RgruY2Qj1Wk8Xj4Blhk0szuwK5CwGh9mx6OuDWwdIJEj0jYiNmpk3odn7E6+uAdYW8qaAK8OpuJ/lkLqPDRQyuDXA6xRGUgRcw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L9MEmOmtwBJmjkAHb7K6TFeEFJSkNTml56bXvvwM1sgBE9xkg4nRwSmqvXhJXGcl2tegqGB2C1Fc+j3gqSrovmeiu+v5nxMGTGwmyTMk0Af7qCYSTfNMxHaQtpbQ/2QHf2HdN0O1ikScjVB1eqDJzUiiggjt1TKDYAdj6dLSpZdfXvQlnhVWB3oYzgdx6vLFbf8yhBfoHLFXw4MLGtIp3H11ecxESm32rEZqfwdWPocoWmpB3TTpdM0QAzHzTurFDonMwv2H8t5dNezd4/WkO3ZAs5oRE+wYPAUdw3jrKNNZ6BY7LtxLymsx8Z0CzT1OrPYpQM5umoW2XPKTkc2HlXDVF6gHNgkR1C+d3R1K6t9TEwIWyHCczW0a0ewc3RnGiwQ3lOUBNMOn+aV9bktsloGf9sDEfHF4IKkH95MXMtv432sZ7r4HEKzAH6nx9XLYaeEHnmqJdR1dioIQN8vbuVaBGY90RCs18u1nh0VGN1asBmxAK318iGWcLyxIw10m3GyFg7pTpeRZGCJeIiEIPrU/BsleO0uvUtYHwj+Y3TnW7m0AyrsvJlY8blIoI6yMPc62FGj9GyRU6BMGOW5DBDSJDXWMp1oWymOSFEcKOfqB7ewwcPPtBZagCFg3sYH5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c850ff-b391-4586-4071-08df28fbd874
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:24.4128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XUdnGcXX+9OwgxiVnJ5lRnvsIjv03s95AnADFsiNwc9/Cmj+ZAwZA/vAsZOIjI6IjlhUJ7AHYheMoIMZ200WYoaIm478jVqLvjCpa9ejYqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

Add a zone type filter argument to btrfs_find_allocatable_zones() and
plumb it through the device extent hole search. When set, only regions
consisting purely of conventional or purely of sequential zones are
considered.

A caller expresses a preference for one zone type by first searching
with the corresponding filter and retrying with BTRFS_ZONE_FILTER_NONE
if that does not yield enough space.

No functional change, all callers pass BTRFS_ZONE_FILTER_NONE for now.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 24 ++++++++++++++++--------
 fs/btrfs/zoned.c   | 25 ++++++++++++++++++++++++-
 fs/btrfs/zoned.h   | 17 +++++++++++++++--
 3 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d3e6a9b429dd..f41a3e9c30f2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1704,7 +1704,8 @@ static u64 dev_extent_search_start(struct btrfs_device *device)
 
 static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
 					u64 *hole_start, u64 *hole_size,
-					u64 num_bytes)
+					u64 num_bytes,
+					enum btrfs_zone_filter filter)
 {
 	u64 zone_size = device->zone_info->zone_size;
 	u64 pos;
@@ -1717,7 +1718,7 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
 	while (*hole_size > 0) {
 		pos = btrfs_find_allocatable_zones(device, *hole_start,
 						   *hole_start + *hole_size,
-						   num_bytes);
+						   num_bytes, filter);
 		if (pos != *hole_start) {
 			*hole_size = *hole_start + *hole_size - pos;
 			*hole_start = pos;
@@ -1754,6 +1755,7 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
  * @hole_start:  input/output pointer for the hole start position
  * @hole_size:   input/output pointer for the hole size
  * @num_bytes:   minimum allocation size required
+ * @filter:      on a zoned filesystem, restrict to a given zone type
  *
  * Check if the specified hole is suitable for allocation and adjust it if
  * necessary. The hole may be modified to skip over pending chunk allocations
@@ -1772,7 +1774,8 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
  * and *hole_size is set to 0.
  */
 static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
-				  u64 *hole_size, u64 num_bytes)
+				  u64 *hole_size, u64 num_bytes,
+				  enum btrfs_zone_filter filter)
 {
 	bool found = false;
 	const u64 hole_end = *hole_start + *hole_size - 1;
@@ -1793,7 +1796,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
 	case BTRFS_CHUNK_ALLOC_REGULAR:
 		return found;
 	case BTRFS_CHUNK_ALLOC_ZONED:
-		if (dev_extent_hole_check_zoned(device, hole_start, hole_size, num_bytes))
+		if (dev_extent_hole_check_zoned(device, hole_start, hole_size,
+						num_bytes, filter))
 			goto again;
 		break;
 	}
@@ -1810,6 +1814,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
  * @start:	  store the start of the free space.
  * @len:	  the size of the free space. that we find, or the size
  *		  of the max free space if we don't find suitable free space
+ * @filter:	  on a zoned filesystem, restrict the search to a given
+ *		  zone type
  *
  * This does a pretty simple search, the expectation is that it is called very
  * infrequently and that a given device has a small number of extents.
@@ -1829,7 +1835,8 @@ static bool dev_extent_hole_check(struct btrfs_device *device, u64 *hole_start,
  * is not reported as available.
  */
 static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
-				u64 *start, u64 *len)
+				u64 *start, u64 *len,
+				enum btrfs_zone_filter filter)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_root *root = fs_info->dev_root;
@@ -1905,7 +1912,7 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 			dev_extent_hole_check(device, &search_start, &hole_size,
-					      num_bytes);
+					      num_bytes, filter);
 
 			if (hole_size > max_hole_size) {
 				max_hole_start = search_start;
@@ -1944,7 +1951,8 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 	 */
 	if (search_end > search_start) {
 		hole_size = search_end - search_start;
-		dev_extent_hole_check(device, &search_start, &hole_size, num_bytes);
+		dev_extent_hole_check(device, &search_start, &hole_size, num_bytes,
+				      filter);
 
 		if (hole_size > max_hole_size) {
 			max_hole_start = search_start;
@@ -5922,7 +5930,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail);
+					   &max_avail, BTRFS_ZONE_FILTER_NONE);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index dd6b0c68b376..cee4cc5da5d2 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1054,6 +1054,22 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 	return ret;
 }
 
+static bool zone_filter_match(const struct btrfs_zoned_device_info *zinfo,
+			      unsigned long begin, unsigned long nzones,
+			      enum btrfs_zone_filter filter)
+{
+	switch (filter) {
+	case BTRFS_ZONE_FILTER_CONV:
+		return bitmap_test_range_all_zero(zinfo->seq_zones, begin, nzones);
+	case BTRFS_ZONE_FILTER_SEQ:
+		return bitmap_test_range_all_set(zinfo->seq_zones, begin, nzones);
+	case BTRFS_ZONE_FILTER_NONE:
+		return true;
+	}
+
+	return true;
+}
+
 /*
  * Find allocatable zones within a given region.
  *
@@ -1061,12 +1077,14 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
  * @hole_start: the position of the hole to allocate the region
  * @num_bytes:	size of wanted region
  * @hole_end:	the end of the hole
+ * @filter:	restrict the search to a given zone type
  * @return:	position of allocatable zones
  *
  * Allocatable region should not contain any superblock locations.
  */
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
-				 u64 hole_end, u64 num_bytes)
+				 u64 hole_end, u64 num_bytes,
+				 enum btrfs_zone_filter filter)
 {
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
 	const u8 shift = zinfo->zone_size_shift;
@@ -1088,6 +1106,11 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 		if (end > zinfo->nr_zones)
 			return hole_end;
 
+		if (!zone_filter_match(zinfo, begin, nzones, filter)) {
+			pos += zinfo->zone_size;
+			continue;
+		}
+
 		/* Check if zones in the region are all empty */
 		if (btrfs_dev_is_sequential(device, pos) &&
 		    !bitmap_test_range_all_set(zinfo->empty_zones, begin, nzones)) {
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index c9e9b221681e..aff68b3af229 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -28,6 +28,17 @@ struct btrfs_fs_devices;
 
 #define BTRFS_DEFAULT_RECLAIM_THRESH           			(75)
 
+/*
+ * Zone type restriction for the device extent search. A caller expresses a
+ * preference by first searching with a restriction and retrying with
+ * BTRFS_ZONE_FILTER_NONE if that does not yield enough space.
+ */
+enum btrfs_zone_filter {
+	BTRFS_ZONE_FILTER_NONE,
+	BTRFS_ZONE_FILTER_CONV,
+	BTRFS_ZONE_FILTER_SEQ,
+};
+
 struct btrfs_zoned_device_info {
 	/*
 	 * Number of zones, zone size and types of zones if bdev is a
@@ -67,7 +78,8 @@ int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror);
 int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
-				 u64 hole_end, u64 num_bytes);
+				 u64 hole_end, u64 num_bytes,
+				 enum btrfs_zone_filter filter);
 int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
 			    u64 length, u64 *bytes);
 int btrfs_ensure_empty_zones(struct btrfs_device *device, u64 start, u64 size);
@@ -177,7 +189,8 @@ static inline int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror
 
 static inline u64 btrfs_find_allocatable_zones(struct btrfs_device *device,
 					       u64 hole_start, u64 hole_end,
-					       u64 num_bytes)
+					       u64 num_bytes,
+					       enum btrfs_zone_filter filter)
 {
 	return hole_start;
 }
-- 
2.55.0

