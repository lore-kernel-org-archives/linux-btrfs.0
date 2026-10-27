Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085793;
	b=Igww2pCYUS3cwkL6wauOixFGkp3dyr8w3qIKnyH4yWCTXI7mBRqef/XnYPZMtaS2hvwC
	 YAxIsR6Wmo2xxKhQKuhZUpkif28nNEFuNpYxCLCWuFpyMMswSNCsQQXD2mUclHvlDSmFN
	 HPJgRz3sIFXDmllwGG5JmeDOoShg0mRPCTrM6C78oZp+utOlPurssr35ln2lwGIYeDNCP
	 mz+ZBzYLuq+ED3s/INJfwMMfrDY6r97GT7oHiCmC2NrCQqHMFjgrcgcycAQI/RwVc/Cbt
	 3Kmw23OdimYRoFoB7BueRb8ZU3mmjCMVY1kYQ4b7xVj/OB9UoAISahvg0dPhCLM5B4A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085793;
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
	bh=D5l9RZDBBkgxt7C3CrUGCuP1XjLu3cuDqQaANpA73O0=;
	b=hM8fDCxJjYq+YrvKTs5hqDj/9kkMc80Ed29mwTD8Ga2TBaDl7uNcpeI1iTMwFeUJNjQc
	 22LiGTBi52qao6TpfvkEdKR48chBfEspV4N69OYudMNXbJQjRNFAT3pZmFLOnVJqEuLAR
	 se2YTsfkKFmG7Q4x9UBLX20O0Ek8XwscfT2mZdslzGHSC0YbNZ3rX9CcCMsqWtGkDcC/P
	 uAkAA+of14tNZCPSgwRVGv8rOg8c0HRcMLIyOe/IG4ggZp1W8WgnnP8+6z6n7ARAoFHbY
	 rDEk9X8OgIwbwB91G0UNHrxzdFjA3jD9deJkIm2x4RyeHU4OpYZvPPH1M12RYJ/SzgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=TM6WGoYf;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=H5o6XPT6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DDC606A32D
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5DDC606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=TM6WGoYf;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=H5o6XPT6
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085792; x=1824621792;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BnpctNCll3sK8Dv8xytANz5y50rMUFX+EwkoyXWHAXE=;
  b=TM6WGoYfb1IlTxeq4Ep4R6cvoDRUiNaHTZwXvgIrsRRH2wKg92O1/sGK
   fIR1kzu/ZvBNm6Fc8A2PHxAXcZIKktfNKiDc5F8cKjic0b/jWRvINI3ct
   C1yxxfSe3xADrPThzB6waNThn6AI1ngxy5jMQ+VG34Hh5O7Yj5d6TqJ8q
   g86zM4NGTmGqubQc4M3ZR3aK2PnDesY2Jv25XVtszdHiSdsjAGGJYuBhM
   HNQRyvoH6GHkKrLtWImX7dCC0rNzYqtG6ZnY5NjqQEBIeeKjg2z6IEEam
   UTsxPgL9H3+eVG4/sWMwqJi2IaQ1tduuyKIGbCoEAXpAaCZZlFNZYPNIl
   g==;
X-CSE-ConnectionGUID: uu4VZ5mxR42MADh0E2ep3Q==
X-CSE-MsgGUID: 12+JYKQIRGKSWfKvIhXHEg==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="158990002"
Received: from mail-southcentralusazon11011033.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J69FDf5LJ0uNFFg3uZ9EBI7sBoL0QaXlV1oM7R+oW6UfAs/zjLItj89w0yHWcS3Qsl9z4TGa/9meWc+/YH4cXRWv8ddqxEWsTUKv8FcDMWxvMUXe3xt6uSe6Plx1vnegnxblauKNN/ug553MPJoZugRQI9DYk4UB/j86/IGGd0CO2HEptw/Kks0pWaQswD0sjhmf22qxlAvWxpjaStPbZHa4EVLsMDcB9mV4R2yG/sfIFyj5up572Zkc3gXCaFHoomCxSjr7apUSgfxrgLmgClWofLA4sTayVnSMqV2BSFaSCK+sXO93FMCDIgCWuk49OVJwT6UypW9OxSeLj+5k0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5l9RZDBBkgxt7C3CrUGCuP1XjLu3cuDqQaANpA73O0=;
 b=LhceDcV/awgdNxyc/7Bj+/4h0W8IkGImF8LHs3fqyeKrMGecsMswFqiT3AfDVsccz/Q6HoID1UC28Z+aNdF7kT87QxA2iRs0H2V8JkLoBL09ujOAS+Dl2kpECC3EHrAOGcIKF+t9N6zLImMM1XO7d0oV17ij/4KCBIp4Nxm7NUPs7V9cQxHZl0CmSr1el01HHzIY7Z0Y2nclxJPPX6WJA+TebT0DIv0Rb+ZhZNp12Hciy3JgoiJV2pVb3KjXSgGGpanyVshakK4IJ9ELHzrr712VGGjTx04ataDYHeC7xUw/NqzqzT93AIMptlNZYqv8fLQE8zLZeQh7ZUAv++yIGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5l9RZDBBkgxt7C3CrUGCuP1XjLu3cuDqQaANpA73O0=;
 b=H5o6XPT6ARA4h5B8Umuojj1HejO+zd242H7E03QF3jbyoy+tzQGPZqKaBybJJg9Jeo9w8/ZU92/HL74lLyRChp1gvskfhyT9OEUbAp9lrn+t+jqQ2vlk4LtHrfpk9cJ4V9VSOF6lIVGV2GNpsnyYqDIDKw8EFiGXE6J/CkRQvhQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB7064.namprd04.prod.outlook.com (2603:10b6:610:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:10 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:09 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 20/25] btrfs: zoned: return finished relocation block groups to the data space_info
Date: Tue, 27 Oct 2026 08:22:26 +0100
Message-ID: <20261027072232.419318-21-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB7064:EE_
X-MS-Office365-Filtering-Correlation-Id: 2215baa3-441a-4432-a18d-08df33fb2733
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|1800799024|376014|261026121527099003|11063799006|56012099006|261021121427099003|261021123027099003|261022075727099003|261022105027099003|261009223027099003|10067099003|22082099003|18002099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	KdWm7hT3XNyYMRzDEzV84zXh77e20vTxZ5XDjRwDChctND/KythFkPLNnsxT/oTVU/XWy/8A5WjbcWi4Cupk8TYpAL4/2ovI1fVqwUdqpMBcCNF5hvZvRDHG9ksWK8dNB6mPzf6Ph6+jjdacWfi8nYDja5QIBhnHjpq6GVB0DaODgas/O/7eXYYQJoBsak//yVOLrtXPAsK89JkwO4Dqzem0lSb50E2YK3t3qxe+iOs0g1EiZmMjwTQDPp9HC9WWhuqGCp9/UmMC23+lDduDxkxaSfAJ5NA5Sy3Gvn8BwNFvjX/VTJC4dgoEFwMVRN4fas3EjlhTwJFJVGWrcGUa/4sKMp4su6Xh0XhgYy5zncu1OboIW0BIZinS8E/JyyKIzxh0Tb/EpjrN+2NYnkd9bxxsSJYQ+GIqHCuQpX9wqhoRi2PfohYWWplPhg9piogoNYCbCCtLPDCepc1+mCz5Pl3mGw2/6NsJ4o/8ty7MXYSt5LuO7l39APa97eC1QRyNjGI6/xgfwt3yUxLrq52wJBXq1w8K4qeJVNqmaQHO43jJL9MRHAKe58Tnb/z6EgOwRIdWW8XR12BtyYRvQcyspnJEtDkL7ApLLLx+vorWSU6DzAtPODFNwz9/TOGz3vsdm0yEMblUJIaIyxHAAbmb84e5W0Wi/KhuaVNW06Muh0I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(1800799024)(376014)(261026121527099003)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261022075727099003)(261022105027099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9PQtDyLV8FY07Mr1NwOUHzh1kgmbEIF+8oYfMWEToFb8FBjF+yWEkbPv6Cp9?=
 =?us-ascii?Q?wYZR/cmOLJw02a4Pzys+Z2rVHOQKjP4fnLz3zxGnkN29LjMPRLgp+smss0aG?=
 =?us-ascii?Q?Iep7hJAnNPNagS3v21/SQOR/TV0RsMGgHy7A18sPhNUDgPiHtOkQf1stCax6?=
 =?us-ascii?Q?4Cs9mkA1VyyfLBL1vTH4/k60S7eKpyQ3B47Te3tQl8hF6zJLiqsonHtDOKpn?=
 =?us-ascii?Q?3gUymxYzaFlBt/4mCq1iqIicLCb1wxfT/mdmuKt+Daw9iL6+0/QsZpJVI0FA?=
 =?us-ascii?Q?HIC9nQDeJJ/zNgl+M4zoEQ/i6qHAGdCi3ehxruC8U3xq9Vu0u4GCBWi/H4LO?=
 =?us-ascii?Q?eMqSc4REDBGd5ZaYsuTq4u57rVMwL8VPtERMu5kEuVqTj7yb10X0jN0I2idU?=
 =?us-ascii?Q?edu7ajI45QMN8E5m/bJO+foHzq0GYcD12uwjv539/w3+M2vxWyDyO4BMzrCx?=
 =?us-ascii?Q?m2ImRnqam/MhkHBE4Ecyswm51h+1P0NJWAHMVVpxhBkKT9cVwhVbUZx6B+Zp?=
 =?us-ascii?Q?rZd+4ivchyIyVK7TEOMeEGljl4N9Rh3mb/lEsX2Z3fcoQAUJhMVnpErRZsSs?=
 =?us-ascii?Q?H5WqNzTkKFOK103D2X9IHD71b1tgzT3I9OcpLxLhLmyGvkPPv95lshZtas/F?=
 =?us-ascii?Q?ef42FlFbsQlzS8RgcHgCgg+bJ6qjwkL+xXG4e5RgcNIuKhUtKAHyzsJGqt3S?=
 =?us-ascii?Q?ePWNqvxP5USsIqItQI7uAOp+hsjAsqyDWhKXBNFpW2dEA7HGqrwGtEjO0t+c?=
 =?us-ascii?Q?NX99Wo+gfWBGJ3Ab9KAiwiNs6JY4niGeLgULDtXpC5bmSFkER+F/JWUkAD8c?=
 =?us-ascii?Q?EYgfXKovc82YUxdQa0O8wK44pLcmct4UygJlKXkU1GkItCzr+39m0T579zl4?=
 =?us-ascii?Q?Ew2R6u71qUX8z9oj8NSe9CRIGPNhl8RFFZz2Oea33F7b4ksbw5hjmcKe073p?=
 =?us-ascii?Q?Oza5FPXIL428LGtAzoGfA2n+RaAZf0IaD879AsmK+VwYAWWNtQpF4jNNClrf?=
 =?us-ascii?Q?LbAg0CoPvxu/qswftl7nt3qeKA3qKbsOw3oRnEbcpCMTtzUtlAGWBbJ8FZvg?=
 =?us-ascii?Q?898/J56Frbsr+z9F9wNXKpaTZtYdtMhouw5xDFDztCQsHyruyLurry1K1BqX?=
 =?us-ascii?Q?Pj+NuJU38BST5imVpBowMTnCfg9AGSk1FJutlhMhsMrqXGjXTrMbCQqwpib0?=
 =?us-ascii?Q?bamFqE7+oHZNxoIMUkkSy6fjTY4/CAyySOZ/Y17wzQQNQ0to97199llMEedH?=
 =?us-ascii?Q?gLx/wwrYIv2JLAG7VaLqco0hXsEQpj8ZbvXWD62GWwPkESjx0bbRz3aBgaKG?=
 =?us-ascii?Q?DCIp5lgR34ixq+LRgHaNnWujDU6g9RIKovRh27Qtl66Iy1RLW0bbVMFUdWNG?=
 =?us-ascii?Q?G8MRg/Ziup5ZQhMpvgpvdUsf1ztkaD1D3x+Ke9QVjZJB1yzXjS57l0aeD/Vg?=
 =?us-ascii?Q?l6Tr0B+wYkRzjcMwA8k1W8vKB5lnktBlsU8AMphQMxcFHQ+ibUBfmf7h1vEu?=
 =?us-ascii?Q?fj9KYYYsYUuRvmTgeDY0ddgX68iCKv4kokOgdOtfq77JCUWDMWsOWhRHYYdB?=
 =?us-ascii?Q?luIWnipoeIXGpn8Eirxk9Dgo9LEzMkPEVLVU7yJe0lUiEmXW99o5hAQqFSnO?=
 =?us-ascii?Q?/614x+/aQsuxsemsrK5Ie24W59t4m+eDKUVk/T5vimjgrgd5u1cBzSnVaOoz?=
 =?us-ascii?Q?tRQ/h7+Qf+Wt7NNQJ94z4bod2cC7A8LLhOu9hMawTsWc7dFL58F7W7mLl0Vy?=
 =?us-ascii?Q?GAh+mDPNILxnjX9YG0wfULAnVS5yoQKo4SuXwuIJg+Ba3VNXs/7ZcvoOghrr?=
X-MS-Exchange-AntiSpam-MessageData-1: zxLLvmaKWxPnfM4IXO5Rs7r8R5EFYRXigik=
X-Exchange-RoutingPolicyChecked:
	UXzgBNtTrLrsqEWJ9d/6r1WegM/0YZRh9k/FxLfFZO59dHqKr59eLtd3Mt74TaU4lZFq+MQciYH77k2FAHZPJzWKR56nDztMPQzqAZ/gdK3Zrcj3V7v9vEdH6n6OO7hYb4ztelR95y6gS0nNmkWeE3L9CACxF3qDJZ15bkuxCaZgCQ0Y8fpARdBk+m9RACGcWGWm6iHM7aXi5nVQZVJanQErglyhgya5MY1545aS1XqPOUecGes/l9UdI2lmfahnuwIFH46oigVE8qgllwhnUxD0LoPEzPiYXWR06dCN8kNWzHt0acbwy2etSqfeym76t834Xk49erH1eErePYcZDw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f8VJb/5GcKP90jZLHxqPeE+Ig108l87yZR4jLvKgS/E8vRREAufwAgb04HZiB99CgFfvp9Ba5IUHEgCiW/XIG68CbcWo+wAYMsslvzyTZvpnm5AptArmyehXf6jKf2sC27SqOLQJrn00znkiBAVZNa0GKjSsgrNZwllbftkfmzWEd7wsP8dXTuKldhWu45QcJy8VWXSuojK8+shZCQSQDocJxjSJWO0vk7HWFqOPkgsESmVJo2Cie9D9tPaDBUNdN91YNvAHJhvCQ3kXoTSJSbyBluVEvXhCHNQ/TC5gwP64BN9BQbdK3skyr1mnRGz7wkxhxskq2cy+jy/ofec1zcnyi43melHZKOm3Tah622p3auYrnIt9bs4BY3yiqg7jex6PtLh8PiQQTrLqdH61R4C0YsJKTU5Uv5ewd/SEGFIZjqVGGRisyP4VPn3x51m8vMJ82fP9mbfoP4SXFejOo+zgz7IMhuNPvkLCZd9gijh9kHH8kOHqYzIvg4rCDQ07FftG2nv+fg5HYN/xM+7X+ni3MwvV3NjnGNh5ekI2lP8cQVtK7PF5B6HqFWe6yIqIU92uoEYXAQuu6O6h41ijCYl2Kv95+qONWxxFZIoEKnHSH/sOttddygqdGhZpJTIn
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2215baa3-441a-4432-a18d-08df33fb2733
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:09.8088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sINWZ3HTMl9zdFp7GcRyQV84Cp7rR1ORXZuYvbUl/SPoVUV+UMeCyBNnUrlBGjX25+UqnDa/uIBWXe71R3Flx7OpSbx6INevONcW0NYTuig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7064

On a zoned filesystem, the dedicated data relocation block group lives
in the data relocation sub space_info. Once it is no longer the
relocation target, it stays there, so filled relocation block groups
accumulate and their space is never available to regular data again.

After each block group reclaim run, move the relocation block groups
that are no longer the target and are quiescent back to the primary data
space_info, and reserve a new data relocation block group if needed.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  4 ++++
 fs/btrfs/zoned.c       | 48 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  3 +++
 3 files changed, 55 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 25b44932d0c6..3f7bee1b15f5 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2161,6 +2161,10 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 	spin_lock(&fs_info->unused_bgs_lock);
 	list_splice_tail(&retry_list, &fs_info->reclaim_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
+
+	btrfs_zoned_return_data_reloc_bgs(fs_info);
+	btrfs_zoned_reserve_data_reloc_bg(fs_info);
+
 	btrfs_exclop_finish(fs_info);
 }
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 40d1cf799d64..a42d4fb8d0b7 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3139,6 +3139,54 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	}
 }
 
+void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *reloc_sinfo;
+
+	if (!btrfs_is_zoned(fs_info) || !data_sinfo)
+		return;
+
+	reloc_sinfo = data_sinfo->sub_group[0];
+	if (!reloc_sinfo || reloc_sinfo->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC)
+		return;
+
+again:
+	for (int raid = 0; raid < BTRFS_NR_RAID_TYPES; raid++) {
+		struct btrfs_block_group *bg;
+		struct btrfs_block_group *found = NULL;
+
+		down_write(&reloc_sinfo->groups_sem);
+		list_for_each_entry(bg, &reloc_sinfo->block_groups[raid], list) {
+			spin_lock(&bg->lock);
+			/*
+			 * Only return block groups that are no longer the active
+			 * relocation destination and are quiescent (no in-flight
+			 * reservations or pinned extents), so the accounting
+			 * transfer is exact.
+			 */
+			if (!bg->ro && !bg->reserved && !bg->pinned &&
+			    bg->start != READ_ONCE(fs_info->data_reloc_bg)) {
+				found = bg;
+				btrfs_get_block_group(bg);
+				list_del_init(&bg->list);
+				clear_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
+					  &bg->runtime_flags);
+				spin_unlock(&bg->lock);
+				break;
+			}
+			spin_unlock(&bg->lock);
+		}
+		up_write(&reloc_sinfo->groups_sem);
+
+		if (found) {
+			zoned_move_bg_to_space_info(fs_info, found, data_sinfo);
+			btrfs_put_block_group(found);
+			goto again;
+		}
+	}
+}
+
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 20180934aff6..31d1fcb6303d 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -105,6 +105,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
+void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -291,6 +292,8 @@ static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
 static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info) { }
 
+static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.56.0

