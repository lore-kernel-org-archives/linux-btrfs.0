Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941964;
	b=ZOIaRi7pzVf0eYB4WMlAQT0Wuy2UCSkF1kjDrtzxvbWjuaE0dw0148O8hJ4quJl4DsVm
	 MCoU/jhB54ocM21/9Txco4k99Bw8NO3br4TCvWKcXQ2Z93fPFQ4lWdKFS1E3HsJw2p2rT
	 nFBvA59vZ2BtUGzECW61ItYKxEURf/Jpxjiu9iN8acIux39pUboHDxugqT3OEcwJy1Ban
	 pryc6lpuaCpXe8DhiPEQSEOvSB6/oDuCw1X38BfrY/Qz/C8eDVrxoQv6VeMDFX29CIcEy
	 e2VClwEhOLrBas/rE3TcfXlajDMk9tR+gkmVhqEetF+2LdYIsVYP7jWJgoZso8mblwQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941964;
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
	bh=FE5dRlMlLFcAbVaASvJKLAaQNg6E04sy8xOKS4uF4T0=;
	b=E/Z7BLZzpYtPhCue5R/tzjfCbquQcLGAG7u98guzE7y50bdVIj0HBqyfCUkO9kBERU7M
	 KogL43Q1LeuqOBHbDkprJIZ2p4k9hFk3g/S2brnqVUOhNDaC+Sx9VmW5Cz94/J9E5RXor
	 XawGiwhmf3ZsN1Jw62bP9EbA2lrBRyc4nPcjiHecbRXMx+48/9XiHdOxI7+RDn9e3hXaA
	 9R5ggm6znortRwZae1FtcHuxiFpx/ZgFAAswINFqKTM9FzAERj1Oq1iydByABrrtb/2KC
	 FEnYmLwjx/Ow9IDNy47k9cYG/LAxl5G/iJI5M/+CcvTyets3eThVwlHj/kjnG5osmwQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=G11J0xFQ;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Nj9qkYtt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05282606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05282606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=G11J0xFQ;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Nj9qkYtt
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941964; x=1826477964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=5LxChnCDMz0FlXxPdmWs/BAAodrHgnUiS4Sn14miThA=;
  b=G11J0xFQi9OoFYvis1+zRLtN669ROQVPTneIz1ibQYTtGQaKBEZymTk0
   xKxrpYnLNVrb9cPV1NZzPIVHHmHQA7979eRxgqSib8p9/in5yF+SMHdWd
   Uk8m4ogCTXBqqtuyZPbJKWihv7UzRFdtXiLgOu7I0Qt9icMQiNkyQ9pdu
   jCPFjeTWApt0AesVU9hgQD7kRs8cYDSKGOvrBzo8IlyqVkwq61m83jqKm
   /4tqNNdOfgelYbVQsZW4WY5YZ6P42bHCg9SFcnzsgRZ8dWfqNm+1uve/m
   fiQydCKN9hx54TjFBK6dZ/aOUnW5EZbOF8/x10etjstp5Xhc8J0RMJQ5d
   g==;
X-CSE-ConnectionGUID: ecw/RuTvRmWVWdFki8RiBw==
X-CSE-MsgGUID: IGDwF9uIS2aEAW5UtzP3tw==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="156880106"
Received: from mail-westcentralusazon11010003.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.3])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vs0i/zj7qdENNLadCAWy0qJZ14H0HN5aiXivchpSst3e1LmDktRD7VaaVz6wtugValGmcsOEdSQ9+GvCsYrxvvT/TntmmrRE1YrHWduPPWru+wh02tL5ouOcv206uG8wVi5v2a8RVix88zujemuVj/AYe2EAWH+6ajYp3Lhqgti4gEPdg6bsBMJN11kCFIw1C4cnCBoVUJMRAs5vONwiLPtVWnYqK0sUPvWx1iOKPK3xRGS6+pWXJghunz8GV9rxBefi+NacA0iSa6yL+YZ7rFU2leDcLS7Yv+twog/GWffzYPxjMl6rC1k1okiKHJ6pOU2t0btrhLSxWsnNvSrgsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FE5dRlMlLFcAbVaASvJKLAaQNg6E04sy8xOKS4uF4T0=;
 b=D28eGohtZowLUpZI7IJy4PXJoTXY7a7uJoHcpEMGZup2E6Ephyfc9hZkQxLK+h4CsYyNrh5kwnTHwuFTIPZyYtUkQ8l9YVC5VPedyEvQ30FUMUsmLj49T5E1tzHeLOY91fA1NOmS0s5hmokLINklh1b+JI6u/iZ5UtFEKMXY/iQP/+s6qWIcLhexUOQDt9MiBDT4qOTE2Us4klZVOyJwBCj/Zwhx5Ug0wEyRRpDHEVckZntkbezLKjxtsgBLWk5VWaIeH82wchqamu0xLbCITSpfKOxlbt9tgLne2F8kcgFeW6CZg7fHsa/awCmJ4iDP3I9c2xCWTV81NuGwO5Pujg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FE5dRlMlLFcAbVaASvJKLAaQNg6E04sy8xOKS4uF4T0=;
 b=Nj9qkYttQOxYjFbNGf7r92ygugfUc7y0gPUFpofRgGrA1acFvzkVqeTU7Zl27ss/yG2Ez/O+kxGl9NGI2gLxAYRYvDrZ7coPddJQ+LHlRsIuYig62yjMZ/0jXaWeCb5Cyt550wkHRFwrZDWHhuW74fPp4y82N7y9X1BXUxTpavg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:20 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:20 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 05/27] btrfs: zoned: skip the append only metadata writeback path for conventional block groups
Date: Tue, 17 Nov 2026 19:58:28 +0100
Message-ID: <20261117185850.4128157-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: 77246f9e-23d4-4cdc-7edc-08df44dce2f5
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|6133799003|261009223027099003|260925021911599003|5023799004|260925021311599003|260925022911599003|11063799006|56012099006|261102123227099003|10067099003|261022075727099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	2aydKaDwq8G72WF2TGAz2O7DoXSIMqAeSxq604usk6kMhphYy/Izj7sZhIBqLa1HWhwbxqUQhbf+Bmm7SUnKmjJn1B1GGnGomjvmYNJInSKj6IUlOKYAU3A2zJbIjaM14fgjsc+kB3lL+cqOlCx/safbrEtSc/0hhY3Eu+C6L8B5HyPOp/+rx1pHNcI0FVRmBgkcEDkik/VS8q18KHhjmK2aRI1hauR6ll3d4WGwM4entqB9s8syIps/+2IGgqj9LtzPy5xFifX0NYwpYJO7CNnqKXqG6pT9Fwxt1mVjbc1wwUrX/6qarwhcpEUMaGhhkG2FVo40j3KQy8Ai7czzvW9hHiaUSff3xsKXwIwGBs+cmkFl/AOUqGovwyvgBTYXmWJIZB+xD3cS2yakL1K61gXGyCYwq8O8mE+OEMpVn+TBCSbujH8iTf06mOvrIWkwmnpf8KbjnJDLIfEAN621664VjTWL7eAezMjMNfX4s99ZcQISk+KE0fMEW4afNYQ/sFIvJuLaJo67idQXthUxQOYXRWcDs2aq8baMFcqGvn8OjCDy5zHZflsOHl9iFUFjtzf8h/RQpiQ+/WjxrX6v3iij1vjuYNxdcPpG3LW4URqX0WjXUfY2j3hZQUbpqvkvImaN4uo7et5Oldb9DrYrmzkVnMRtuZQuUmmDX0IoLh8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(6133799003)(261009223027099003)(260925021911599003)(5023799004)(260925021311599003)(260925022911599003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022075727099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vbhp3QGHatIV5xACO2MlzrqZ8WShPuyaqDkmVBeTyWY6HL1on0jHV5HEQljc?=
 =?us-ascii?Q?ChBhIqsZljuWnAcq9ZjNro6j5yGtHauHa/+I9z54Ig3JvWw0YsPzKhEozZIP?=
 =?us-ascii?Q?Kln81ubdtGijFPQ77FrQmAEpKEoqcYejh7tx4YSWqW3NCAuUUBSmkvXoP1eg?=
 =?us-ascii?Q?KjYC0LeQMiEYHVhKacBpnb+NBxVpJXIidH1HO+ubF8GsVQkhItZ+g2zwf7uE?=
 =?us-ascii?Q?5708a80wOCcXkCAGjQpP37w2I+G7l/i+s6CFupQtQNwfR2KsT1fOPPaV4rvz?=
 =?us-ascii?Q?DUv1p/0CB8Fnn56qRpQC57Lsh+awq+QQpzL7+ANhBAmH243GN97p8nKTz5VZ?=
 =?us-ascii?Q?r5Llt0QE3dSwvKhgfo45iiXbP3TBGWQvz160VoseICYUZHkbRlMAxPe0nAc3?=
 =?us-ascii?Q?xKlsPPNsivLmId6ByRbPT59FRJyJUrO9aTPvP/UV4HP28UjQFwigNa/KtJjJ?=
 =?us-ascii?Q?Ww35NHo1TCrDi865komQbphuVjPus6lYo59DNkK5gqwNEJcsA/7i8U8wbL/l?=
 =?us-ascii?Q?nComcTRR0foSRkw1iBMyWmYq6tsv1qLTcEzN500qOJvflcv4s/BkdYM4i3DB?=
 =?us-ascii?Q?eFK3mHkQlosYw5aTMJ+cpG1yjkwvGsvPfSf9EqXui60UTAGSwhHpY+JTUjVa?=
 =?us-ascii?Q?vlxfYIwRNuCrKuQbJ7zqiLxtppQ+kpMM87uAfGHP+DZW83Zo8e2mP913LQf6?=
 =?us-ascii?Q?qvLaA4dykQivfiSPClpI5QXoSj/XVUNnlZM4K7434m2zNvR36LGub5Y1aAUw?=
 =?us-ascii?Q?rCMFCUAlTcYkz6b2c8l6xpzJfXw07yo/7RVPGuTEriqRm/sEL0eVMxSCyinK?=
 =?us-ascii?Q?baHnzz0lSY8EApPb39AodwBrHUjep+Ioo8/DIX49C30g+j+ea9hgSK30g9i7?=
 =?us-ascii?Q?6+ptJb+Y20zQcYpyHphP7813s3C5JeeRHclNNq/tozPBBLfBjU1ks3tFQZYT?=
 =?us-ascii?Q?VzTj1GOlAmhTyMoT0cCoKFeH+CbxIzzo3p3XT3fd+1+dgl0IpPOhxM8g4CDr?=
 =?us-ascii?Q?5eIBWRp6PtBV6O2zHVBn9r1s91bxYhCIwONW5UQ4D+zJwp0dIB98Naowkdkc?=
 =?us-ascii?Q?oNv0cVpJxavnK8c33978V2r7B+1yzs4/MhusZOO2go4r4wyzdMJGCSYHegew?=
 =?us-ascii?Q?s3w3/Ys1YHK1vaGVPbav5iSgQ+8JsvMk02x4skynnbVXVkkAhJg+BwuQb4Yc?=
 =?us-ascii?Q?dgb8Gtml+nUItyRcA+qZOkJf49t0bWw5hUEISlLHMngf6qR4omOEEhNf/GkX?=
 =?us-ascii?Q?d6mSZ46Cn9muFtIY/EUoUQpBoEfkT9EVi9k/wVA0WHzbBwaj+ISfo7vKj5fY?=
 =?us-ascii?Q?KzqWcU7xrjjNz/wAD6RU+4/gTaiOB2KMTZAj4rtn4zYtegxzRPY8UhJzNzkg?=
 =?us-ascii?Q?2T5e8BJuZvqtSMgtoCt9pKQjBIgQvvyM887JZIdxKfhtYLjukmY+kDpUrCyY?=
 =?us-ascii?Q?zCnZpt1jHbK9of8ESBb0HZr6dc6exZURc46khxW+QI4DAV0M2yTYEQgDeoZV?=
 =?us-ascii?Q?PUlWlUnnWZPs9yM/hSSH7liuCRRNtAhUjWKDzlv9ChlICZ1nfFbRCRgR7BjU?=
 =?us-ascii?Q?Z6nx5bcO2vOSDSlVUDlyo4eCk1wYB6d6Oh5iYSPCsfskArLktHSDKelfOLGU?=
 =?us-ascii?Q?MH96QeTX0koeLW5NiTUg4GhuovTNzBzVViHPTmu3/fleMqZs3TblhSShKZM0?=
 =?us-ascii?Q?ejp/nVvq8KCs31FjZd8LyMR+Gyvc9WbXySQ9UMiQv8V/k5akTv3Wy/HGyxmf?=
 =?us-ascii?Q?KOjzBCu/Cvm4QBG6YqXfKRYgV0Nj9GsbIdHivIsdjhrtDG5IZoJVOIkH+UUk?=
X-MS-Exchange-AntiSpam-MessageData-1: q9iiJte21Y61EXpo+MSxvr7DUC6V39+jsXk=
X-Exchange-RoutingPolicyChecked:
	ZtyM2kPHXQeQiiz3AEh11VEFOntzMd77GmxKbNgoTc6PoxXoIHUwPHiWGqbDtvqjOA7zE21rYzKKlZssi92gO6GijI3R5+Ahix8mwzzKfcVgI3FCILD/9cppzNW5u8rU/efmVcnz/gu1hD62SZmfLoZ+3wlJHO/G6Hio/J89hRpoanub2o1SoDeq2GjmqR8YFIvw0lbfabQqpsmGcppegRrksLpHzUBrnMItGir5omcODbGND75up4HVYnAnH/VAsZZ2Mlkf6TdyOw2lMOXkkgupNUj241kE8/OPGIiDI5RePgaoHdxGO3Gz+19cqwyEAED/+KNm6HkLaSZ5QYSlsQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cF1TydrgB4nVRSivUAi/R9vH3YSQdvFPbCEiXMXLlyGHCQcjAFUW7+1iz6zLNU0LPz7h5DDL1Z46rGFq/OjIKx4g4TmD/pQVpAUSFkwlhmNQX1fKhV4w/GucSjRBv0uRwqkifm9aMlKqG/d/WAiN3Czdt0d8NxffUqBI2jTD0p9xlH0uj/H9YlxCDmRC4MjHlcWn1ty6MvrP0WJjwcf2Uv2kGy+/4mK/7arFs7ROk6MKrdods5LE+5t1WBXM7Ud71onG4rYAMkXRBAVo/wKTZYW1zfasl0j40qbj9Kgj4z8nEPJ3faMAsv3XtYSBqWXZ0xpTjzH5/qqLonxaezq3tENVljweD9kekmlAxzJCUemV+Qr7wKcfS2OcotvX5RkIghrkm+FsAu0et0mzoICGiXgZ/STBIWinIP/ap8EyWB3b4LLnSN6YKGpEE5gMrQi8feQfmNlqB4IZ19oVc4YWwujeIl49j3wqY6XZF7yD0IE6WE3OIuLk0/m3jMWi8ABE6X5TjeuIlQLZh5eojLD5Nlfef+T5RGgilgL/qOTdnTrFyWcV+eztWEwgZcQPjYh75tLy+E74XpLxVr+9jmjOkO8F7vc8bmH9fk2ohwuwGqfMnu9QqaqyDUmdBwiMRE30
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77246f9e-23d4-4cdc-7edc-08df44dce2f5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:20.2992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 54U3xFOuwSZIFMmYQOiuVYWGRBnpUsOzDsQETJq7OULgHN5P5ORETubho/6rtGmweusK9MkHcO6UUnnOGRcP1fVMY81hKcXwof9eEvn/w7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

Metadata living in a block group backed by conventional zones only can
be overwritten in place and in arbitrary order. There is no write
pointer to honour, so there is no need to serialize the extent buffer
writeback against block_group::meta_write_pointer, to keep a zone
active, or to write out a freed tree block as zeros just to advance the
write pointer.

Add btrfs_zoned_bg_is_append_only() and use it to bypass all of that
for such block groups, which lets metadata writeback proceed out of
order and with a queue depth larger than one.

Freeing a dirty tree block needs to know whether its block group is
append only. Count metadata block groups with and without sequential
zones, so the block group lookup is only needed if both kinds exist.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  7 ++++---
 fs/btrfs/extent_io.c   | 10 +++++-----
 fs/btrfs/fs.h          |  2 ++
 fs/btrfs/zoned.c       | 29 ++++++++++++++++++++++++++++-
 fs/btrfs/zoned.h       | 34 ++++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a40eedc65dd2..7853d227a204 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -64,11 +64,11 @@ int btrfs_should_fragment_free_space(const struct btrfs_block_group *block_group
 
 static inline bool has_unwritten_metadata(struct btrfs_block_group *block_group)
 {
-	/* The meta_write_pointer is available only on the zoned setup. */
-	if (!btrfs_is_zoned(block_group->fs_info))
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
 		return false;
 
-	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
+	/* The meta_write_pointer is tracked for append only block groups only. */
+	if (!btrfs_zoned_bg_is_append_only(block_group))
 		return false;
 
 	return block_group->start + block_group->alloc_offset >
@@ -1204,6 +1204,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	rb_erase_cached(&block_group->cache_node,
 			&fs_info->block_group_cache_tree);
 	RB_CLEAR_NODE(&block_group->cache_node);
+	btrfs_zoned_account_meta_bg(block_group, -1);
 
 	/* Once for the block groups rbtree */
 	btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b2739838c646..6ba202b312b5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2535,8 +2535,7 @@ static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
 	if (!lock_extent_buffer_for_io(eb, wbc))
 		return 0;
 
-	/* Implies write in zoned mode. */
-	if (ctx->zoned_bg) {
+	if (ctx->zoned_bg && btrfs_zoned_bg_is_append_only(ctx->zoned_bg)) {
 		/* Mark the last eb in the block group. */
 		btrfs_schedule_zone_finish_bg(ctx->zoned_bg, eb);
 		ctx->zoned_bg->meta_write_pointer += eb->len;
@@ -4169,13 +4168,14 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 	/*
 	 * Instead of clearing the dirty flag off of the buffer, mark it as
 	 * EXTENT_BUFFER_ZONED_ZEROOUT. This allows us to preserve
-	 * write-ordering in zoned mode, without the need to later re-dirty
-	 * the extent_buffer.
+	 * write-ordering in append only block groups, without the need to
+	 * later re-dirty the extent_buffer.
 	 *
 	 * The actual zeroout of the buffer will happen later in
 	 * btree_csum_one_bio.
 	 */
-	if (btrfs_is_zoned(fs_info) && test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags) &&
+	    btrfs_zoned_meta_is_append_only(fs_info, eb->start)) {
 		set_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags);
 		return;
 	}
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 84a6eb2ebf83..401a5fcf45d5 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -919,6 +919,8 @@ struct btrfs_fs_info {
 	u64 max_zone_append_size;
 
 	struct mutex zoned_meta_io_lock;
+	atomic_t zoned_seq_meta_bgs;
+	atomic_t zoned_conv_meta_bgs;
 	spinlock_t treelog_bg_lock;
 	u64 treelog_bg;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 169afbcd8be7..a8762033e44d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2019,6 +2019,7 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	}
 
 	if (!ret) {
+		btrfs_zoned_account_meta_bg(cache, 1);
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
 			spin_lock(&fs_info->zone_active_bgs_lock);
@@ -2300,6 +2301,9 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 		ctx->zoned_bg = block_group;
 	}
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return 0;
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
@@ -2327,6 +2331,29 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return -EBUSY;
 }
 
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical)
+{
+	struct btrfs_block_group *bg;
+	bool ret;
+
+	if (!btrfs_is_zoned(fs_info))
+		return false;
+
+	if (!atomic_read(&fs_info->zoned_conv_meta_bgs))
+		return true;
+	if (!atomic_read(&fs_info->zoned_seq_meta_bgs))
+		return false;
+
+	bg = btrfs_lookup_block_group(fs_info, logical);
+	if (!bg)
+		return false;
+
+	ret = btrfs_zoned_bg_is_append_only(bg);
+	btrfs_put_block_group(bg);
+
+	return ret;
+}
+
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length)
 {
 	if (!btrfs_dev_is_sequential(device, physical))
@@ -2594,7 +2621,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	}
 
 	/* Check if we have unwritten allocated space */
-	if (is_metadata &&
+	if (is_metadata && btrfs_zoned_bg_is_append_only(block_group) &&
 	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
 		spin_unlock(&block_group->lock);
 		return -EAGAIN;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 2225090839f3..3c561f6ad228 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -81,6 +81,7 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
 void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
 int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 				   struct btrfs_eb_write_context *ctx);
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical);
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length);
 int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 				  u64 physical_start, u64 physical_pos);
@@ -220,6 +221,12 @@ static inline int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info,
+						   u64 logical)
+{
+	return false;
+}
+
 static inline int btrfs_zoned_issue_zeroout(struct btrfs_device *device,
 					    u64 physical, u64 length)
 {
@@ -439,4 +446,31 @@ static inline bool btrfs_zoned_bg_is_full(const struct btrfs_block_group *bg)
 	return (bg->alloc_offset == bg->zone_capacity);
 }
 
+/*
+ * Data is always allocated append only, even on conventional zones. Metadata
+ * only has to be, if the block group has at least one sequential zone.
+ */
+static inline bool btrfs_zoned_bg_is_append_only(const struct btrfs_block_group *bg)
+{
+	if (!btrfs_is_zoned(bg->fs_info))
+		return false;
+	if (bg->flags & BTRFS_BLOCK_GROUP_DATA)
+		return true;
+
+	return test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags);
+}
+
+static inline void btrfs_zoned_account_meta_bg(struct btrfs_block_group *bg, int delta)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+
+	if (!btrfs_is_zoned(fs_info) || (bg->flags & BTRFS_BLOCK_GROUP_DATA))
+		return;
+
+	if (test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags))
+		atomic_add(delta, &fs_info->zoned_seq_meta_bgs);
+	else
+		atomic_add(delta, &fs_info->zoned_conv_meta_bgs);
+}
+
 #endif
-- 
2.56.1

