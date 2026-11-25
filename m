Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602637;
	b=oWp48c7fqvqNz1p6t8fwX5zHBcvdGfKRFL7fGq9aHzEqU+JC7il5lnGmu9e5+nx7diP4
	 yRT5MYsetYuesjBOkRGrbuEXsxjVkBOzdnrB9KbnhLGU0hFgdGZ1ayHqrRYwPboMiPkvY
	 8A44ENzh7ULZEX4vjJ084kjljIfspaQw4gWDtJTC+tH3owpi6pqtIf1X+RGsXR/mxqshh
	 B2ZIwTnMC5OvbiJGlG8AOi0VOVT9rz8zM+qt+x+/XPymsjgS168LcjB+Ubi/mkF+2FLfz
	 inhw6msjPMtJ1C8LTmNT2OmBXsHnPIYfsJbTsAwpWg5k1avFXh+XWTtGhSmA7zZjGZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602637;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
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
	bh=7ICeig2RvXSzakcwX3lMlpzdKmNZ+BnGhiaczIZpdgc=;
	b=sZ2WFMu0YGKrpGPTD1vBcvv/QbqfLLh8XLBCz/BO+fi8fmBbqgjFU43bQ/k8lydlyl+3
	 L+cPzrd46KGmfhfrh+mjoZUXFZ9rLnU4BBhLrRexHG6jNtIsdKAdLFG6Zw5oRyLU7DGkG
	 BjASt9j2kRaVFB1gOIYsnuVkL80Ge3kJxfR2X+UQXQRI4qSprXSZ7B09D6JqMjnvbEU33
	 7wSE0MF6KwbK3fhNKQTr9uGMqVmUk6mOoY4unp2agS+Dte0cDKXtzxQ26cvlhaVrKEM9v
	 RXWBg3FmT8eMe2pjt8J5KMFT/Gy5Q5X44hK+B3f9WU3NrOkqLOhSEyGl4D++c/qYESQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="Cafc/tXo";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wnv5ZR2H;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5602606A68F
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5602606A68F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Cafc/tXo;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wnv5ZR2H
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602636; x=1827138636;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=uPhvJhtBpmAN/Y9ykecAokmMdbJWNTZYxhZiN0M58Kg=;
  b=Cafc/tXoW6/kdQVyqpFuE1MkW/F+EczSVUlhayRdROYIi51lItU0gr8j
   XjUQUUf4uERl41/DVNKBJ5BWbfaVGBQT5NGjZHlQm1J/tm62cdbZcpRMR
   Wd6lSGD7zrRhMXQYnHsX+dwKPViKtkZuPboxPgZa71TUUANJL7VjSp8Ph
   Zi9aBrrFTbsMflCCq7Pz1w5kqgW+MM83RcbS11gv3f95qEgY29LHP0DSy
   xBXaPimY9JkEC/Whg4vly7ViyFUIfdZdfGOI/nRf52tbGpZFuW4JvYCWx
   cwqZuarVHRNGoCCjKY8h1Z7OIzd7Sv0CvG1611jZw2EuGt9krmyak1lLr
   A==;
X-CSE-ConnectionGUID: ol0XeAoXTamnaf3YDDgaiQ==
X-CSE-MsgGUID: Z7t2+QyLRIGv0VJk+Nn58Q==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662167"
Received: from mail-westus2azon11012053.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UuQwmpfhsIN4dqABHVVfZkoUf978M6ZPobEGyGf3sT6g4NzUmwLnNLtiHK5O+cMDrdYwfmwhqXdcwUimIRc8CVw9iWs3QSnc8Lobrb5pCYGvD8Vw7uwowH+ADJ0/i/jQVzLS6qjW9QjyG8ze11p75q6ihHqhjTK3/cvDBD7+KjUJW+gS/jL6Y6VMV0jWBhdUkmEHC9Y76Qc7qRbWFZoJhvhNnALL+VxBtzS1wr3/NaKlnYUe/OKAgCAEshUOeV6D/dgcqrcreanQymwgqoJ/6x9MpJwqVJufpZWVABqeo7JAvbjEcIdxavIlE89hyYutWVU/rH+yW7nlMEBDV9J3Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ICeig2RvXSzakcwX3lMlpzdKmNZ+BnGhiaczIZpdgc=;
 b=j5jZRSf77aOb3NMR56G7aVsLykgrXwhXN8Uqnd78XmBgvVHW/PK3doRgDx9Vc1BWSTmVpMZQcC6DqTXZez9uWLRCl7eEAgGq+70rVJ4MsN3s8JQkJZZ3N5QMijjWkKEppv9HPw3pTig5T4Ao+pIGG0qKsvq6JLy3BjdtAgvI/FgYzsfXN0EMGxph8Wd3rEAwr0+7v6M+U6In0UzHbDUw2B39yd/176xa/3G/w5YD6ozTCDn+1ya2QuSqo9r1AWT5k42T5gAMI2FZh7wIiSrT1y1hC5aNVOLtiAuMQnLAAkJhLopGQX/QGUdWKDru4uwHgcUnT5Mt+wWstuFGwMtDtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ICeig2RvXSzakcwX3lMlpzdKmNZ+BnGhiaczIZpdgc=;
 b=wnv5ZR2Hp3WU/97Zz8AkNIaUmZ3Xk5bPax/RcaU40yfdH3IlLtcpKwBZpU5xU3OAka1252iZN7XW5UwSuCxwrCCdlcd14OIB76n1VfQb7qUld8/K3YSzOKfLgsGJAbPMKjJ4ZPAXGgq96ceEkbl0c0CqqEHzg2KHOIDv6JZFDjo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:34 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:34 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 09/27] btrfs: zoned: allow restricting the dev extent search to a zone type
Date: Wed, 25 Nov 2026 11:29:38 +0100
Message-ID: <20261125102956.266389-10-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
References: <20261125102956.266389-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0411.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: 550c0a78-c22e-4d68-634d-08df4adf2333
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261022105027099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	xhGURjrjMYjsZ0uKw69EKtPccNfi94fqjn41QlUUbvSUF8GcSG+ZXvH6+8BIMLbFXg9CHwiOYw9U4d/xeH8CvbOKEaAU24kC8hi0fm9yY21GeW8G0++uxnRxB8/E95sPr3KREmNNC/qfLotnTzlYFt9sXryQd0frgMNkYMhxa+AqjbxROIH0dw6AuYVz1oyVWsGLA+FFfL6lSkWhbPZ08YRcjXWz56LT6k3keS7SjWPT9DJkTA0eAECwzmvOXjyEaeOTGPevNzQbDeaLx3MZY37WIYwkCcJWN0vA/3zdTne9+mO0B4u/wpLubJzBD7DJvAi10J+pwT0OkJ7SaJEYz1/WM2X5iIN5ekv8gp0ywKBiiT1q3orCuhnAGnuPvSMFoB/CDUdr2qx3zZsyK0y83hlMHAnR79J8UdVKKksxW3QK1TmFa/q56aN5iDr8JDwfGJV+w6t63AS1HnqorEKmXcbFRMobm6QRww1VYAInDT5oSq1mnTD3hKTj6BCukt8LMrdpbJlSdiZHxjOxgt9Ag6XlI1ZULH/1JaT8FHZaVFOsXbxQGjf9CE5dSQX9wDOBoymmX+Uqkho1DApdBbYi+VuHVKBdPLt3dLBa2CNROGz7GGUmHoJIylZIbkvnUJwFS3r0wZ3inFRVrvXhqBbvcogOWqlwb0oo9xBPYOEF6og=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kJKcL3jASqNYafewzpPrJ748Z2FRWIqh4q1lgl75q92xokJsBqWNW11Vs5Hb?=
 =?us-ascii?Q?z3Zsz56fjme2dLL3T5ypf5ld04eQtj8Y+X5NAkRNepMcylzTcyvT7nrmkRFV?=
 =?us-ascii?Q?zS92vr6bBeeQnzGJFR51sNMs6caCbUXtMRvMpYX/8QpzXR3+hiLRlJ3yPRaM?=
 =?us-ascii?Q?Q6lmPQIdhLNvByHaJF+ftY2bcMPuvMbAhofYr8duueEfz5A5ftI2C+nyKy5K?=
 =?us-ascii?Q?sD0aDCKaOcxpiiNoNQZc8wBYliQ0AmB3v8bF+k59U3Kpt1RJUyHW8YZkpo+g?=
 =?us-ascii?Q?AEBzRyBTziJUsSXrj6IdEeIydLfvNKJNwnZQyEPYCF9kUiNLCdorhvPoJxgy?=
 =?us-ascii?Q?iKMCVs4rx4bH94eg4FkZIf5cFgnoDzcWQNSw2obm7ikJ/vi7l1jQ6rp+9rl7?=
 =?us-ascii?Q?WiuvJm6kUIuv7ixN0LZN3PJjFjg8cjRmL8BizvJT5oDCBK1tPCaJavufb9ev?=
 =?us-ascii?Q?7EpD8XbElXwfgz5kS7jYB3JpcEsmFcgMWu+TbmcI4iPr1wUR9rxD302YGPZz?=
 =?us-ascii?Q?zQoQuinfvEeOpnQ2fnIjHDNY5phxWu77RIL2cDqoWvWn+JW/oEc8BdVohRH3?=
 =?us-ascii?Q?yPEPSV3gzRgwpKDb5Byqg3CAWyiGYwPNhvg4Rh02l5eBzGNrbAQxLVeJxy9B?=
 =?us-ascii?Q?CsXzY9YTpoqdLdvlBPWwEk73xnbaVahAjTbgWtEdpDB/SudxKzljhxcLkmDG?=
 =?us-ascii?Q?1zLoz/MVAi+kLyeZdKFcLGro1+DlbN2+2zH2laZagM+XTF74i9MYNDRLnmFp?=
 =?us-ascii?Q?mvc6XoWbmK/hxsRWfc+Y9gtv2bXxZjBRAAdLK7uFAuGFSMhzU643bXcpgsPy?=
 =?us-ascii?Q?L5pDlO+uNU4cGUkKNl8dlSY9MD0jxuM5tZFiiLKORmYlTJOL0ldiwHPfOHtg?=
 =?us-ascii?Q?0OoOExJNe6oNjDyH4NHjDT7dpfvqA41CiWi/azNmdi9dNpgAaD9IA0ttKbj1?=
 =?us-ascii?Q?+Qe1+3Z3L7BKGl51ou6+xrDJ8AuLvMxfVwb3P+x7TTstupCR58ZRAhpx52AI?=
 =?us-ascii?Q?AmuOF8jeqqcvwoXe92xlW7lugIyx+zlTcKkZBzf65IxOVLJ4mUzRAZ8I37Rw?=
 =?us-ascii?Q?K91P3b64IvvRJvbmPoOdR0qWOBxqV+aYn2VnJ3Q+m1MC1InzPDU+Dmwby4Oe?=
 =?us-ascii?Q?Akje2R4bgy0Q9kkdgD7hHcv5lUw6sE0RJO9dZazJP27ev3XgwGW+S8tBud0c?=
 =?us-ascii?Q?AX3GOICOSzuyHw7wyRFFIVqueqz+ORFK+R3ma7I3LxWasUXQhmdWqc310e4W?=
 =?us-ascii?Q?ujDDtk3uEhf4WElrivj0R8681te6iV7TER2EZ52upDZ0RA5XpnOvjtXzodq9?=
 =?us-ascii?Q?U+cTDGBeBXLMy3lJh45NzNhBjcRHuj3Ds1VN3OD4TjFCxVBSgoRK5KbFAKkW?=
 =?us-ascii?Q?QR7L72hAgFaIDU45slYHN7BTydDPKiAfG1sumehsMAfV06FZKOd3nf5Hx0oz?=
 =?us-ascii?Q?4fT2s7qHFKDPOZYnT8N2jAlvYR34K3B4V8+MM6uc9dJ06Ci/mykWmUVZaEDA?=
 =?us-ascii?Q?l7Gr1OO3oPG5t08myVrSL1ACOM5F0ZbxRT3pKJD2fWNUd6SOk3RnkE3SMrI6?=
 =?us-ascii?Q?Dl2mRPC3Z/J+FbDo92VArknpSaI7jv6wSmEUYW6PimbQnS5f0AijtoWz5VuO?=
 =?us-ascii?Q?mTLc7adE/O8tezVf3VTwFMBNb7lIhYKGq2v6rMLilFonNJ1PIP200TkXY9nq?=
 =?us-ascii?Q?2Dlu6RDICWwBtU0nf6ddDNmzMd+UJj+hKtdvBj5nnwTcJsE3v8jDDVXIwb6R?=
 =?us-ascii?Q?DMwbFJqIG//IeZ3BcY/DtDCCpyNhXdTFQchAVwuMbITsLzOpSi6mBIj27dr8?=
X-MS-Exchange-AntiSpam-MessageData-1: 4hNa5rCe4SfLO04M6b8BQUpXDoHCGo2KoGU=
X-Exchange-RoutingPolicyChecked:
	aY0133D6OMDSatjopVERiVCdopV8jzD9j91oJQbceZNyYKF3nC72OUIoZ+9wTrsZhpmez7rMdb5AB908sTJ9sfnTOXSoIoGmpDclMENxoXpvxWRdrDzYvoVq/HuGeZxFEQIRS0GaMiikcjwGP/348eR6Ud5ndGPvwT4eBX1HW6/Mf9D4Bb+xJUWprgc1TRSnuSZP39cbnjVoRFVsRZUf7WASfUJQY+5xKfsOvm28XTNDmDzdjGwxP6OeYxOAtf8zprNmkJHOfRcXW2x5QCP472TOxUNHc2BfCd75VOUcSqUnIon6+sTWJJllZ1N0I4SyKCz4ZZ6Ya1FTfUXjizEgPg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Iu2KVngEw1kt8aj090tvnnTaXtu0GpOrwyouNPQ92id10jnpy97ByX2HcTSIqbBEXNO9vUsGEQdQaws08Cc0/yELJI1ww4s/vpBpR3kF6KT2IXq0Vg+Y1tYoSqy+bAwwnOQL4FkwkxJCR41mVj139x8GEFTMx0R/uxMu4IFBjsJcG7w2JHxl99EvCXpTpOrURV0c/FN/K66zK4q0cb71+26Cels5M1Cs7UrLQxhOxDpgo4AjtWEt+W6Wv7LF3VgpZxe7IfT2zzlLQC8uE0mXojs9Tn0Z6E5k9m73ARC0mML9xN+QKaIoaTgFrT1IzEzXW0pPqQxITkba3QPNFIDWjX8bCWEnCFNYPfPXhr4Y2mzgrDcaM1HvzAKviS3pm72OMkHkwRdiacDMMCfoPp7KmsG6JW39HamblaunE+GuXgiyd/xdM+S5fZw5i7/Nkb8h+emPDpgCCaNBIOaQ/+Gnv2TB82d5XkVkwo9sqW7jpM9rbVvuUpiD5WOWo2SQMTZsi3MA1haBqUWSynmKR4cVL89ostJdk2LYYU/tpdiPX8/73QVlYJqTB/LoQ9ojGi6GIJ0V8TXfAlgW8JItcLtbF7F9KjlzQm/NRb4fsq2rTn1SnGPdHaTbJp3GZb3waUJp
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550c0a78-c22e-4d68-634d-08df4adf2333
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:34.0829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QjJlWJtLiUc3OzzmuTm9mhsaOefJcfl24/r+AoxltTpK1tlBpzI9kdzJK2tdVp5U11Zb5wnCcaDE7Vd5DugZeESk5Kba4PJBD0B3yV4z81M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

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
index bfc1b85f4b03..9540885f01e0 100644
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
@@ -5952,7 +5960,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail);
+					   &max_avail, BTRFS_ZONE_FILTER_NONE);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a9d86d5c0204..09e8346dc418 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1050,6 +1050,22 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
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
@@ -1057,12 +1073,14 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
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
@@ -1084,6 +1102,11 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
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
index 5195d3d6f541..174528e2c312 100644
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
@@ -71,7 +82,8 @@ int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror);
 int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
-				 u64 hole_end, u64 num_bytes);
+				 u64 hole_end, u64 num_bytes,
+				 enum btrfs_zone_filter filter);
 int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
 			    u64 length, u64 *bytes);
 int btrfs_ensure_empty_zones(struct btrfs_device *device, u64 start, u64 size);
@@ -182,7 +194,8 @@ static inline int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror
 
 static inline u64 btrfs_find_allocatable_zones(struct btrfs_device *device,
 					       u64 hole_start, u64 hole_end,
-					       u64 num_bytes)
+					       u64 num_bytes,
+					       enum btrfs_zone_filter filter)
 {
 	return hole_start;
 }
-- 
2.56.1

