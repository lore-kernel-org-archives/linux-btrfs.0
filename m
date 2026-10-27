Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085784;
	b=vWVEvlSvvmKhjgUnlcJk0ApFSbjXICIG2Qr4gp3tCsc88IRROjdcvulHp5h+aQ17/uGa
	 b2lkwvb8Ehs3G4yJSQSuBA3+U6HNabkR7kDhgmpFlgK10vtMYpDDxRjzsDprCwwpME5kJ
	 Wi0BMd3CJ6r02J0YyxoKZR2gqwHPNDwCLG0QyaBFCwcCwprF+b+O2fFIHTN/L9PZb8uNf
	 DZmQ4BA59DmRllklAqLr3d7BaSTcFwXSio1yOhXM9vNchRaF54oNE829QENuaXXiLJiPB
	 iuHw1UYgvyloLAa8adR5ORcSBOboo331bHPQH+SMf2xdSsgOzhBL05Kx+o6g/wJ+rkg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085784;
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
	bh=i/xfG4hcr7fmzc92G7H8hZbNulOIC22oeAemrVUhjps=;
	b=nWWh4a6gV9hxyOSFfIKNl0qCmaSxgxUxjrg7MzBnXutL33QU/jw3TJrcyqA2TTKj2+qJ
	 2hNCo53o6ji8jDFAkzc2OKYPhKBbI6w5Xjfhw33MM2zrKahGp1ONbfEWqLYJ8N1qzErl+
	 tPD9Ds8UzkFSyQw8GjsjukDWV4GC1mKNTniQGwnqIkoQKDLd4U53VgzB9t3p3o+aexeb0
	 jb06vCgCvP0A0Ih0NhtRJc9xD7dCuU2nvP7BxJrukED/kuJvpHfzWlO76i3+cPDbEAzKG
	 cczrCRF59q0nnPqWZbvy+vagOEVlmamNvQn8GM1MigUA4/6ae7P0ILm0b+7TQZjeLKQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=oyJeJGGH;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="d+D4sQ+/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B21606A31E
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2B21606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=oyJeJGGH;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=d+D4sQ+/
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085783; x=1824621783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=IZzyHHJILAWV/TRgyxGCki/Q+MemZ2ms1EUqmrYFSw4=;
  b=oyJeJGGHw29Gw1uCKQIPgQ98sYxkMKAlo26vtTzH4+Wg3sHSP7O9Ola3
   hNIINZDdxVzG0Y33ZBw/wDjD/NBYwXGjAxn9xnxKST2fa2wyhOYBYBSJ+
   x3Bnyhvw4k9Q6ErSqqQE28/Vg2hnoHAJSZr1pT9vtTIbvRwPDyUQWCDIj
   Wyjdo5EOOQ5klhZNz0Nf8wnWKbiswO1MIzHdsbgcJdFr25voS7okaV3hh
   aAXzL4gg3zf+axNcNvrZMhuEBghItqMyPUGajE6P5TzvpO57RCpukM5N4
   zATItLYCgJEvRLmC3ZSy+MdswF8jO2mmfp4zOncPrbQvxouxme6vwAhQb
   w==;
X-CSE-ConnectionGUID: vgCVuXSNQyK4AaINi3iheA==
X-CSE-MsgGUID: TULD5GMgQUSc2bI/fiBHQg==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="154863266"
Received: from mail-westus3azon11011044.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.44])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LCAB3WYL0RK9M/sFyo0mJw0jODrzCgvKINrz2KdndELENiuiQhf+nnchyan9U6ynqMWl9zlPT2eCyVN2x41kSO3znjexr2XK5dexVyA3RSA0VuhF4KZp0p5C06cuxFEcDZhrIm4Mpze/tqSZXrD8IC0N0QSYARQEvxiXv+d2RK6wMzYTz1jYsYnjHt5/lVWEaDXzZLEfmxMt2B1jy54VShMNfILe7t837K82arLKGYtsAtosqYv7GCCL6rPpQmJfw3om/ME5yfVSpIfvGoJAalyeYqI5/vIyjqESZGci/SNCrYlVmzFl5qx2UiNgHTMTSO3XjSCGaj7S/PzHZauhXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/xfG4hcr7fmzc92G7H8hZbNulOIC22oeAemrVUhjps=;
 b=eZO10mVjgKba/Sbws7uXIfJgITyqsTr5TjoTPlYLYVbQ+M5/+A0ie12i+b/U3WJ13xW4/yibSpROlg2/nusMbMTgQYLMWv/IZ5ANYwKKDiafBIeop0kGLBEoNHV2tRDRIFoLNFH1ranou0ukGgri1NPY+IloBY9VGV1ED7KvyjCz3uk2nV+kM2S/ByQUQqRnFFvcZ+HdT6ju2P8WMxIx+DhqzzAbRsqZZLp8oIgGbrDH55r1GlEI3PSDf7QjBjIfZclNJFFxgcimrQvMC9kcS1DTLKxUKMO7ncxyH/uDjdQrixUaFdR13/VSx2rItuvYWqFj022H4qVOYAvOpKojMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/xfG4hcr7fmzc92G7H8hZbNulOIC22oeAemrVUhjps=;
 b=d+D4sQ+/q3e8sbuINrEgR6IFtKqtgpMCWKduXafpK73M6WJi5VgltS6WWKBO98hO1w5y4W00d3TCHfxweqyy5pJ2FxuqUpso5I6s0c+Yzbegohkw4+umHFLGo3kK1BERryVx/1p40rtGJQ+F34RXUfYyIWAuaWByCCrp2aP51vs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6398.namprd04.prod.outlook.com (2603:10b6:208:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:01 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:01 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 13/25] btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
Date: Tue, 27 Oct 2026 08:22:19 +0100
Message-ID: <20261027072232.419318-14-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b17ed39-69af-4d80-5938-08df33fb224e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|1800799024|10070799003|366016|22082099003|18002099003|56012099006|11063799006|261021121427099003|10067099003|261021123027099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	eKecNoM/Hjd5hBRVj9WrubDTZ21sCPbMonz1nLnQCBGzVqRTxXTf/4OEpS3v617S0ckOY8ESHfhEHAyxZN/2oCvRaK4/tLvJgdPUvsNIQt9KEN+//Pzr31WbC4dOMwqxa89O7PyDB46IePOw4KIF3maZcTvneyeWUryfByThNt58CsIUa84v/QNH6K8ITeC4LqMrMAvow/MrxWLFpyXZE/iP8ahyzgILuEQzx/WErU+sv3KNseA90dd1j5iAKbodegZKzz9pX4/8/kw4GkKKZIcUmyY2N5kBoWqFqwmI7LDy3Z039eQb+9OSTUtudo4+LMJQJ9Zv72ipq3xhY7C2gnoi7wk2dTluDohsL/T1+DdpFe+9FAbQqdg721NX6CH+llcDQ+yUeTAJWaj3HnMZQqzWrDx/ZXykzYifIkPW7J4Fn99wAFJa5N211KOgd8NZHMKFYbJzpiGjAdR9aMxdfrcMeTFqfL/oF8W1oL56mHGswO736O7M0oqJeyG68xB3+jlUeNhDbkRSS49y5a+P3BQ1CwC4C0M548ZJSJttm+xmSGtDn8ODjKWK+0timvfCIaFsoLaI1UbxiVxfXjxGunb8EKkbJFKZElw63F4d+h+DCybSHPfv6LO+O7ZB+0o4FQnOOFKw6MBDTBeCuQcdwkp5naH9ty7MDmSv1rE7JeU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(1800799024)(10070799003)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(261021121427099003)(10067099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QNyarTAsbjuk73b+UYBgXKavLy+RsAnFUoR821N7hNJ8pZEj74PGEQYQBl3G?=
 =?us-ascii?Q?dY9aFoArXhD52TrfHCtnsY0OLd4cURJLsyUYiHuXLHORhgFhzz180WgIf7w+?=
 =?us-ascii?Q?hoREtf65qHb8nTNBKAoczqmYmdITmVpNRHNx+DewyyJaan+z+xcRKBwWM9GI?=
 =?us-ascii?Q?n2eo5T7+sbg8q7+0lLbxoMcRZeyfxINHL/pXfomBngyRFrhmlW62Gwsbxc00?=
 =?us-ascii?Q?a0YtrRr2f0/1gUovQvITPptuhRsOnV7uPAQsAwobDr3yU/QTigo3DCciAVI/?=
 =?us-ascii?Q?hKPqO3+WYVxDuFvq48wIlBUR8/ArL5ofAk/wDUU+ZPm/UaTyqD2t1/o2ZSSw?=
 =?us-ascii?Q?3cZ/cRMCh22dMaoeLz5ibv8CiRKlo1UNS70D/DyS9oHgKyapf0z0DpX3hOrR?=
 =?us-ascii?Q?N8IgoX3tA/hpbeMXAWeOlYDfZPQGTulaAbPzBo+hrDQUwtXFp8Kck15l+L9p?=
 =?us-ascii?Q?HyL+6Q7ajYFuFsTShhlXHtlM2DIU/0bobKLHbrX0E68seT4EoT+E+FDLhy/m?=
 =?us-ascii?Q?mTjVmdGedZkS46DD30sgkItDaMEannC5W4JtIwbvd4bqEGR5y7swx80aSc/h?=
 =?us-ascii?Q?3sBlSKVbiVq4KcpsAFlCSqBiXs7iLPqpNePums0vPC7XA2Ikq9qm8uQRah5P?=
 =?us-ascii?Q?4DSkaCuzvN7q0AcM363ekx1bve7d3GZwP2Kn7yEJLBKqJHH7l/ixV3hDEjNV?=
 =?us-ascii?Q?GeJSFpoTRZBkONypbPR2cA4X3lvfiAevuvRw4fHN53XHFHjPkqA7guFXmNjh?=
 =?us-ascii?Q?z7GVCiRIFNLC57aFWjkk8qmZ5+snthGtndDZfKYWX3FHxU/LT/jq+M+2pEE+?=
 =?us-ascii?Q?uiFKMu3NNXBFpIvlVGbIV7/5duBaQ5Xf/7VQO8FRgXdDc0zenRBikntMKXrC?=
 =?us-ascii?Q?Y/nGxSs1lVTKzLYiNuIerrIHZGfRsOpthjrP+fiuWJ66CbQpXc/DAL5CJyAd?=
 =?us-ascii?Q?MX34YdyamHfuwAkCynUPjTcOsaXU0j0q1ajCns3mGKDSOOgbzpa/C1Xaf4LV?=
 =?us-ascii?Q?TRnYfyjzCix83/IPGsGmbZtPMxxCQgmXnSEy+31AnkIrx32BvbGQoYEecSKk?=
 =?us-ascii?Q?YgHEk5kKsuDvJjZWMwLoF0fLATUfotV7uQo+j5cLBDTL4y6un5jSs04cfKmq?=
 =?us-ascii?Q?dm2ZxAQb+PA76Rej9xVU9JEupj7YuBqr80LTDGxi7ftVtCqvfkRD/LulT2km?=
 =?us-ascii?Q?DuRmZKk0Qk/rHscI6rHEFni2ybpgFPY9HnpvDjEWvUDku2ILgFzd5TS2g59i?=
 =?us-ascii?Q?G7mbms+AMn3xqUuGyUENd26EWbvRaZc8wDJa9zxTHnOhgDsrjFM4gbOa0in+?=
 =?us-ascii?Q?WNeEJJmAAr9999UaUUzqUAd/vGXemTNLpu8XSuGYZXJQCMnBkdGIzot2r3k5?=
 =?us-ascii?Q?hddsf9u46pMCRzIpvgzkhNxu30+IbbhBacr6xJEQWO/mc1OYRsViKfFfPIFH?=
 =?us-ascii?Q?FSh3OONn7//6giwH9uULnEAFxmqoKWUKB6ldfqFrhrFXILW867PGkvPLgBcL?=
 =?us-ascii?Q?r8v4NiT8G46FVTN41tXFLC9rj3FrUtNljOUyz8mvAiuS1X1cpBujWUbWZfjp?=
 =?us-ascii?Q?xXbf7dUl2JkCXCUygn+0+Biax157rQw2z0dOjcF8JTqSIngJr4Xeq9UA+DbO?=
 =?us-ascii?Q?O9ritgcfD6CPgN3YBYs41ekd9n7/YsmbMAU3zePUmtAYFd/m+BB0Xkg2FKWm?=
 =?us-ascii?Q?9X8hk6B+egjVhlbYjR7QiMwCbkJbskQDAhfR8G+4T2pM0NeKtjhvEG8Hc2AE?=
 =?us-ascii?Q?ELgEINYCK7XNmfYWe1z5IBCGxLf4G6q73OoM1YOl30ZEDrJhkMTmTBpvX3sI?=
X-MS-Exchange-AntiSpam-MessageData-1: aB7vDcdnKt8NiQESD49iU4dpobkGrYEZ7zk=
X-Exchange-RoutingPolicyChecked:
	FQkFL0613S17RYe+0pXIzNGZGdRO7YLXW1JXMckevIwRdWgFYd/Wk17rS1I5uMzWWSUI3+avcKUSH5YEOiYUvCnrefddPY2J0v6Ri0ns4zaQYyCiRHxSHVL27Ey+cj1CcYGsMDOaEe+0T4sAZJxWE5pNA43bR0J2IdqtZc3XuVSAoz+bNdiGbnqaTSndFdmfMJK8EfXc8W7RLixYHLGCX5oD8oCCKRVikyuyA6GEncFt0CXmsiejQDaw2fuknRe2B3sAq1M/RbLdLQ9hLUFHKF2/OIgflhOLy6rMhQmSwPIVy1+YTQnTBITYyvbVWDI7/lV+TUJqNxVWLdUtbRKSpg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UcDNmxieASHfViA0SGdgXA0MmbHkgAGbn4wyB/WwHBfTTuLlJjlZp3nGOIo5+SeKyBeVQkSYvcM2NY//haTVoZgjUNWZYDUxERg2JK3vTDIRd7aoh78RvLVSXUL7ugYfzkaG3ICPCMw1ZD8fzZcYz5anziN8oN74mqOhR+qp2R+0FjQkAxurzkKrsrFln6V/fcKP0N7C41FwtNiE4fMLKohYK/SK3mip6R8e3hZGWd/+CDehd/fotUegwVXTHbFkM73oX2URMtoKTNtbP8QMEdsETMPQrZfGJSXXe92l7Pl8Ai+rz4mBWMeXbbxsiNGW2ZG50Tcp7r5o7jBFz5xmhUcAJyup2aIblmOXQAMNOWJ/LifZ5UsIdedyHp8VRryD2VuTZRFbPtaknpckoM0zP41ooUdQczrCxEbBo3DYcA0a1bVYV2cSqxVXx6ksCOnyhMYAZpsvx6tk8kNYVoF6Y9MzPKFAkIiYsx7ofjvSZEtZXCoGtm1z0OHCgWjJLZu4tZgUZ++ETtWPSpRF8L+CZSADdE1z2dILaAEJdoI6eyJKFOy7PFORqdUASFXSwAtq7cIB9MzVnejuv86f6MyPmQWHksNZeo3KcyMphPvhmn5/QX7/PpJ2QqxbS5MdQz4f
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b17ed39-69af-4d80-5938-08df33fb224e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:01.7938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NvBLbcmo9gMqMm9Fu3PMMqIU6NlhODKeRfw3/gTF+Hy0NvbhIARvWZQqeY+cNxM4ziJ16jB4no+ISdqNyhSwnkpZ7+PTimGaaKGQNTJeX/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6398

If the reclaim worker is relocating right now,
btrfs_reclaim_block_groups() bails out, because it can't either grab
the reclaim_bgs_lock or blocks on the exclusive operation.

Wait for it instead of failing the tickets while it is about to free a
zone.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/space-info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index d5a84fa97462..bb08294cbf9a 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -913,6 +913,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 		break;
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
+			flush_work(&fs_info->reclaim_bgs_work);
 			btrfs_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
-- 
2.56.0

