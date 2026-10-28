Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793211717;
	b=u/au0nBxtH14LkDeiI4h8q/fB7/ee8UP52YY/npwQqt9AvLvPjxTu0Q6uu9f/456tAf2
	 Jo+Czb0Y+/AGoR3T+akOmJT3NpPGxF2rIqS1uYQk84RGATCn/BAU7T86ZlitVn7NHSguK
	 pKiWbDAR6EhoIgB3HY/WWMsfPXLR5xJyTtsGB5u3BnnrurNPeC2xTAJ1LW5+Qsun9lTkv
	 WKEVAgvXPkMobXA23WWGNIIwsc581gTkCfm4h8WzP3xJAyzO9eX8KZIhZhaOwdFrIXWix
	 Hi93K5FarSewrVzcY1RzHY8Bwh2GJ69grswshNN5Fqnsi5fAe2bDQD572LuduIW9fjQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211717;
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
	bh=gTUNiIJGUpKiz10K3nmdV+WQivTtW3eXlME6cWdLv3Q=;
	b=B/OqeAMCwEXuCVIYoPPFFog7BqN4PY7y2XEyKDiB4kJhjZA8sVaduQICs91cwDSqiS1q
	 KvvQ+CPeHzD+c6/rKbUItVfV05eSLVmDIcpcAef1jcbhaPKdkDZtjWPc1815QGvFM6+f2
	 D7NXPr8Vi5c3aZ/GO3XA60FEfwecxeRf4uEQJFr8AlYkldA14yVbEr1B1QBcMmmHAVNfM
	 k6Z2Y5yJVNIhvJX/1XxySzMmJ6MSTSCOPMwIdPfbT8ParLNj0G753tq58v6sP3/qGogsJ
	 7FkZjhPLAC0FcZ2WqiTc1AJ04Ms5l6RDzeMCpI97+3LmCkITDgmlXkVzYgA14y9aMUg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=W2Vc5JNY;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="a6DS/i0Q";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9335E606A32E
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 18:21:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9335E606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=W2Vc5JNY;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=a6DS/i0Q
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793211716; x=1824747716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=DtHhLafiqT/sdXGqoTi9tcAb/9l5cjajFqyRpACl5vc=;
  b=W2Vc5JNYgGbHURN5zFepi/oH2lwrQJQftOpMciKnGFOlWSEJKTXwIV/A
   lBRpqo7cxpQLmSqNoi0/edP/eiKICbphHkPNsRXuS8Q/+Rg+uTD6EF8S/
   OSQ8em7+zNTUbnbc1Vb6BynAWbFGR0PrYVw+Zv5Hkchx8UGXpUSt7wCqJ
   T+BqBQ7VdB5R/C6vPJ3MyiGzm+lCQ7VtzC9M4LXd8Pmn6Oqh7dGfx5OyU
   lbIpNAmUzN9yHlfwoEXyOSZHAnPP+ewRmJM0mqRLfl3IjNO+w5iKDUgTr
   b+N2r2lQfJuPMUVcY+V5qFSMdGhmjYnJ6kihg1Lbny1CY737FQDZyu4LE
   w==;
X-CSE-ConnectionGUID: DzfxA0vyS4i6FDJSBfeEkQ==
X-CSE-MsgGUID: puuZirSISH6N3x/6pYkw1Q==
X-IronPort-AV: E=Sophos;i="6.27,183,1786982400"; 
   d="scan'208";a="155004269"
Received: from mail-westus3azon11011040.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.40])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2026 02:21:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l/gBZNSC8kzrIbMu1pRLBbe1m21dF3GBjCd0zh3dRSjjfxMFU/WWZZAicFmgYNtFBkcvBrVuKB4hw674WIZQq64uk/mQBN9EN4E8dCG2jldObdTVnJ9hR60I/Ta4Vf84jFwe+LppBvGcZJ/gmnvhfIPfai4QPtNP5Bskjfkn127MaU/WvcKsD1WAOtskC6aw4SGA63s333FtoMK9K8Zsi0wrKOx0zJ1AuucEKpZfsvLGo2N2wqLME01NrV16xf0Q681W0aX7Xa2rDm1Z29BvOBcA7uRLIBHe+yEeUmNMVlV9uvoEjAHCzbntllGBIOGm/AdYOF4jlPpXhM5M6OefwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTUNiIJGUpKiz10K3nmdV+WQivTtW3eXlME6cWdLv3Q=;
 b=rb15g61q6ZawDiwIa1qiSu9PnqDphpwpIJRFhUf6+wy1sQyksHiOkVH+hXYnyka36MQzl3uGFEwCRKJvrdfefRXHp7Re3fs3yBiwwFUFlaR9In9CIvI5oA0Lue5xGbmjJ/o8FSyBP9LQrgjRJG3umSEjI85QcUHvo/HeS2i3FTTLZgJKyyyuoMXvsMbsKLc+8CQjXiPivyyE0ENW4fk+NPcsAOU82WbxbyUSQRdz94HOzxTTyP6O4p1kEO2K0yZB6zHgBkmbixWM+Vmc8AUQ6g0pN5RPhDLT7tAgGCG45bCyZOD+rxbiPfvjaGF3xMSAgAZnDYmGEpb9qyiE7tmiyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTUNiIJGUpKiz10K3nmdV+WQivTtW3eXlME6cWdLv3Q=;
 b=a6DS/i0Q/DVqdO5J5h+gSw/4WdrcP4YJPMu5ln6T/1G86JXN/PR0n/AeYnDcT278ojVbWnq614YAF1u2nYy1JNwKk0LRt2+bCCXuYoxmgqlmrIOrc/RcPYJ71BkJ3LolK/XC4en4Go2DiX3NdZXx5Fehb/ZAOUkPWJSHnBPJJUI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 18:21:48 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:21:48 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 17/25] btrfs: zoned: factor out resetting a block group in place
Date: Wed, 28 Oct 2026 19:21:03 +0100
Message-ID: <20261028182111.160492-18-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::10) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: f06b07e7-a26b-4cf8-1578-08df3520548b
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|10070799003|19092799006|366016|261028144727099003|11063799006|56012099006|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261021123027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dqgZKJUrCeXuNLAoDy7+GfF+M2lAzLdgqwRsDpBR8tqIrK1hO5L/HN1HB/uy3COVpffRwDu+QpmmWzBWDr2kCORxDt0Rxy80doQRO6+4valmTMMue582oeRBQ5Poe9Av3WTaZH5OtuzTzc5bfo/FM2p0ysuyacpwstIfbJY5OTEhcb7JQGSj3pJ1ToQ19aXnMveC3TbanL4QF0MzCzsflOUCTvMDy3UkBQ1Dq3BQrr76B0fGIfcW3/ogwix0L0bLA+L+EyVZeN7AyTCeCbFfMJOUtjRtyETPsdSoIU7yhQxEwlNfA3ycsEWJbZhOY/54yxbnAW0NVp7RDRm/nQMdum/miC3QbbZaVap86K4TAQFhRoPvQNixDvpABS4DdXee87nMzKG8G00cPZAs7zVsstLM0c29QT1bWfeltXFGHE4ah5wOf4ExzLky3r5k8Sce2fPtOIF3EAnUl76A3PVHV1qU/ptUEMk67OpUbSo0bExICwbA1SL86wo2GeV+bE2xHSOODfrieln/AKqixwVo3CP4ZtphJfOM1fFk3bLHG0/TlZ8nLFhXgRj5BdgRYnNh6GfwVfYrbEi9ZWsbH3gXXYR03E6FU8asRhx0N23hTK2HCnvGiZKoULzV4myKv+GiPifvYAIB+so4e2WpLaMGiXspSKIt2eAJSMZAAdn54CE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(10070799003)(19092799006)(366016)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261021123027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mV4xzbsDRq7MLb1jq0JgP5q7n7wcLH0eNCU7Q4tz7iwpf12Wfxd1zVgfoVXE?=
 =?us-ascii?Q?ZbvHeP7Et10tj8TNW8lBVBmiMIUYaq9hhMoObgD6x11ykeoojFG/e90bY5Zl?=
 =?us-ascii?Q?Ydcy3zl0/Y+OgwQKwZM01cedWQL5mMEGysHeWgribV7OxplZmYRG6YsEmdov?=
 =?us-ascii?Q?hrLkMZAvI2WO00Jyv2o1VWGAiFKD6qKlZw4b4GnCsLFviJaTcEuPFgMyT0D/?=
 =?us-ascii?Q?7/FXJQYRm0zaAfKWAj1+4iQWF/8Erg4lDvnokCiHegcOtCojeCB/6Vo8Q0s4?=
 =?us-ascii?Q?MjIMRs4yHcHwTnYifKWsFdsBltjS0zCgRl+QShmyZzI7CStmGcqSbcDaOrmL?=
 =?us-ascii?Q?L0w32k+FSKJIaf1VeE2gSysIvZqTbPMu9ZdmfLm6cV18OlJhEsO2HwtxHG5u?=
 =?us-ascii?Q?5h9YZoyYSUGogADus9Zzq3y3eChhHacPdnfQcdWE8OAxxZFQjrMeBrXkFecS?=
 =?us-ascii?Q?gaalf6fky32ShN1Eg6OWOK2eBAUmkFS/Npo1jcOlgtDByJnYfQy4Bge9VrJR?=
 =?us-ascii?Q?FuLlneGiGST8glEKMOMUvD3BaO4Rn3tp1wAlT2+qC1daiNlTSR4dXU0UEBOa?=
 =?us-ascii?Q?0NuNuHF+oAAA6A7Y5xYRRsZemfzw2OZnOlgw7dbKt7Uqa8slvrKcok+7QMUG?=
 =?us-ascii?Q?Xu7tpEtzF8mfaMP1QMWlg9xQBIJabVHDRBdpwZKIt7y6E8THiwlCz5VnvUQF?=
 =?us-ascii?Q?ebq3ZqDNSWdBYByx8bR8uyBx/7cWqBn5veS675umjplywLpX6tf02oy//wTI?=
 =?us-ascii?Q?/tM9lzxKZKFl2F36WGKSgknQdneKvudxBDOFKZtbD96Zgu20K4ZzJ1j8vZpw?=
 =?us-ascii?Q?F7nr1whHZO3s4F5GJ4N167T9z7kSj6dsCbx/832lMAjkit4DPJk2wg1Uq0KU?=
 =?us-ascii?Q?zCYqoa1e4AqMtGlvYjzRz2sPsj8voha9vCAcG1jguGIJmTznFzADtbUNYcim?=
 =?us-ascii?Q?q6mJDf5YPGqQ3fLaF9rjGdCXKGSeWXxUCwfhMaUm8Mmhw96UuIz9TtQw7aa1?=
 =?us-ascii?Q?jGYE2P+icPZfQblOfv8wvD8QfNYvl/futghB0Vv8au4EfagdySJjrmCqdnhI?=
 =?us-ascii?Q?BSJ2Ii0KAqb+cxl28Lddx0OyGxltMkSmBZIwIfE60GmbpvANZiCAY/9yqdDn?=
 =?us-ascii?Q?Dj2miENpfG/N+5M2HWRoGvN77mnoc25m7SzUiMIOg9I91C/3IkvltXEo2ypR?=
 =?us-ascii?Q?SWmREcHyMlb+pJVCed7as6lAZ7YB0WuaifXzkxbDCH1KfBbqSUpoKkA1OenN?=
 =?us-ascii?Q?NTq7xAKS7qQaw8wMSiECIeQ6Uc/mdo5aJwRrUBXrDo+T1POS1dlLKk5CN40W?=
 =?us-ascii?Q?zqZX7i0okIKl3XnFykOECLwzuBvCaaFp9M1hHR7kw+qwKSfiweu5nFoKzYFW?=
 =?us-ascii?Q?2syoCslDITLsY/y4eW+H3e00jX4J78Xm8OqxXHf1Dh79YaYk/2mDuIxKQgXN?=
 =?us-ascii?Q?OaTg4c7vIA5bpkuKtqxHMzH9tuFGnGVU1SRVTU+gOQTRdHhMkcRPaaS2lKrX?=
 =?us-ascii?Q?0AWs/c5GMfvkNri3hI7AfSaUKZzRmpVdpVJ8Ha4DyabH3SfX3ef2xkHWx+fG?=
 =?us-ascii?Q?wgdKKrFfsSpkU+J1bM+O97Do9aypih1J5XY7OzDGQVn50EqKEYK8eR+6SUdT?=
 =?us-ascii?Q?xTYqoMWwu3I51TCjd/mdjT0+p5IzeiLZKhPt7xz9NorvA16RD3W12TeLDvdK?=
 =?us-ascii?Q?7Q49+gPH1oPgInJ2O7TEAIVGTwu/bIN8BJXPiW9XAyh1tMDIrU9KFcJGQ4xa?=
 =?us-ascii?Q?QI8ZheIulQajjpH+eh/981FpQep9l247ekZsFfP1/aVtcqlifuaywI0fkTNP?=
X-MS-Exchange-AntiSpam-MessageData-1: grFZeI3l6jPK0lv8FiwtsBv8GswgfwLNRBY=
X-Exchange-RoutingPolicyChecked:
	Zzr2FOPhW37IWqVQ7VX242NZtD1C1rvrg5ODLN2dKwzhKskXMS394dXzn+suROm3odz1eLniWRNbNRbEm+JUJ4S66HOUXj3UDtqUoVL07DHx1I9Rmxmt8dimiMI5HiAk78oQy5nh/VfP4JXFabWdlDl8bBJvfe7jtMOlLiOT0okWBGQW9uHFF6mmrdIAJdzbc2BBxAf0fqh5X+a9xZkTOsJQlgZd3rRdzge0+/ZX8OZgLsNEFXrgIh+39QR2Zk7GKAU50FEiXHcmO6Y25iWyW2p9JO/jwoatZxzvYQeS9Cqmh032v0Hn4WooBXqpTZOBo6spWKOWPPOENrU79fuacQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nSQT6cnthK9Mfzo+2Gwe3BrUkrx3gaz5Z7eKsEKCjLayUOBrtOInhD8f7GXjSUCcMIjbwhfsHiW6z1j7wEGw4Dx2pTRhrJ9mB+lXHSk5jRI+cGXz9ek2AZCwH9Vmfh5KVsOJKahnDOcxrhxWvgRhoKGHmoCcy3vaV2ddmgLA3/sAACY9RYA8dS7HSMWSt2+U/jXsxGKdiGvnOVJPCrtof8F49Jzk8OKj5L/+Vu3o+IZihIfaNfG4Qll7AbfwN9wv4JOa+VHf7YVmmNQKMlCbNNdwxDe5vkF5BTZbzWQ4DjeStaQSIYhJNSFd6pus8JGRVIkWVWu00zfFpa5ZENBIIqKhFhnbMSEc3/lVbA4Ezdoo6j+Sc+eetRD5a7yDM5lafXa34IFJbcvUmg6sg0ercu5zoxCr8zOIJdgvsoLyqFK4mixt3qYPHSeJ84plkldN4q2xUcaPe8HyTcMuuFAw9jJsGFhEmxar6KqoX/Uz4HQ/+mnyoZlO2WoG22Awf0WIur7bZC9F/9Gtg0l5sI5odayFFlEQ6HixRJwtaTUTfnJQj87murIJZC3l4sJA7qSwmlqB/ZgdLTww1VXsnJDGu/FqNgm32aqWjw8pJ78pzN11Hre1QSo/KklV0whnan5H
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f06b07e7-a26b-4cf8-1578-08df3520548b
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:21:48.5839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sifQ7jfwiCLpc5E/GHbQjER/xXg0+elZ0+CImPUtbTiFPxvL4A88D92YHvEfsjER1z18DsvCoZzNDmeV9HKVWkvZCxTpVPWSi6LT0LGgyHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605

Move the code that resets the zones of an unused block group and returns
its space to the space_info out of btrfs_reset_unused_block_groups() into
a helper, so it can be reused.

No functional change.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 128 +++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ffb5b6663914..cec160d03806 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2915,6 +2915,72 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_space_info *space_info = bg->space_info;
+	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
+	struct btrfs_chunk_map *map;
+
+	*reclaimed = 0;
+
+	down_read(&fs_info->dev_replace.rwsem);
+	map = bg->physical_map;
+	for (int i = 0; i < map->num_stripes; i++) {
+		struct btrfs_io_stripe *stripe = &map->stripes[i];
+		unsigned int nofs_flags;
+		int ret;
+
+		nofs_flags = memalloc_nofs_save();
+		ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
+				       stripe->physical >> SECTOR_SHIFT,
+				       zone_size_sectors);
+		memalloc_nofs_restore(nofs_flags);
+
+		if (ret) {
+			up_read(&fs_info->dev_replace.rwsem);
+			return ret;
+		}
+	}
+	up_read(&fs_info->dev_replace.rwsem);
+
+	spin_lock(&space_info->lock);
+	spin_lock(&bg->lock);
+	ASSERT(!btrfs_is_block_group_used(bg));
+	if (bg->ro) {
+		spin_unlock(&bg->lock);
+		spin_unlock(&space_info->lock);
+		return 0;
+	}
+	*reclaimed = bg->alloc_offset;
+	bg->zone_unusable = bg->length - bg->zone_capacity;
+	bg->alloc_offset = 0;
+	/*
+	 * The zone was just reset to empty, so alloc_offset went back to
+	 * the start of the zone. For metadata/system block groups the
+	 * write pointer must follow it back to the start of the zone;
+	 * otherwise it stays stale at the previous (finished) zone end,
+	 * and metadata written into the reused zone would sit behind the
+	 * write pointer, could never be written out in sequential order,
+	 * and would be stranded (pinning its folio) until unmount.
+	 */
+	if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
+		bg->meta_write_pointer = bg->start;
+	/*
+	 * This holds because we currently reset fully used then freed
+	 * block group.
+	 */
+	ASSERT(*reclaimed == bg->zone_capacity,
+	       "reclaimed=%llu bg->zone_capacity=%llu", *reclaimed, bg->zone_capacity);
+	bg->free_space_ctl->free_space += *reclaimed;
+	btrfs_space_info_update_bytes_zone_unusable(space_info, -*reclaimed);
+	spin_unlock(&bg->lock);
+	btrfs_return_free_space(space_info, *reclaimed);
+	spin_unlock(&space_info->lock);
+
+	return 0;
+}
+
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
@@ -3251,7 +3317,6 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
-	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
 	LIST_HEAD(retry_list);
 	int ret = 0;
 
@@ -3259,7 +3324,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		return 0;
 
 	while (num_bytes > 0) {
-		struct btrfs_chunk_map *map;
 		struct btrfs_block_group *bg = NULL;
 		bool found = false;
 		u64 reclaimed = 0;
@@ -3301,65 +3365,9 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		list_del_init(&bg->bg_list);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		/*
-		 * Since the block group is fully zone_unusable and we cannot
-		 * allocate from this block group anymore, we don't need to set
-		 * this block group read-only.
-		 */
-
-		down_read(&fs_info->dev_replace.rwsem);
-		map = bg->physical_map;
-		for (int i = 0; i < map->num_stripes; i++) {
-			struct btrfs_io_stripe *stripe = &map->stripes[i];
-			unsigned int nofs_flags;
-
-			nofs_flags = memalloc_nofs_save();
-			ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
-					       stripe->physical >> SECTOR_SHIFT,
-					       zone_size_sectors);
-			memalloc_nofs_restore(nofs_flags);
-
-			if (ret) {
-				up_read(&fs_info->dev_replace.rwsem);
-				goto requeue;
-			}
-		}
-		up_read(&fs_info->dev_replace.rwsem);
-
-		spin_lock(&space_info->lock);
-		spin_lock(&bg->lock);
-		ASSERT(!btrfs_is_block_group_used(bg));
-		if (bg->ro) {
-			spin_unlock(&bg->lock);
-			spin_unlock(&space_info->lock);
+		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		if (ret || !reclaimed)
 			goto requeue;
-		}
-
-		reclaimed = bg->alloc_offset;
-		bg->zone_unusable = bg->length - bg->zone_capacity;
-		bg->alloc_offset = 0;
-		/*
-		 * The zone was just reset to empty, so alloc_offset went back to
-		 * the start of the zone. For metadata/system block groups the
-		 * write pointer must follow it back to the start of the zone;
-		 * otherwise it stays stale at the previous (finished) zone end,
-		 * and metadata written into the reused zone would sit behind the
-		 * write pointer, could never be written out in sequential order,
-		 * and would be stranded (pinning its folio) until unmount.
-		 */
-		if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
-			bg->meta_write_pointer = bg->start;
-		/*
-		 * This holds because we currently reset fully used then freed
-		 * block group.
-		 */
-		ASSERT(reclaimed == bg->zone_capacity,
-		       "reclaimed=%llu bg->zone_capacity=%llu", reclaimed, bg->zone_capacity);
-		bg->free_space_ctl->free_space += reclaimed;
-		btrfs_space_info_update_bytes_zone_unusable(space_info, -reclaimed);
-		spin_unlock(&bg->lock);
-		btrfs_return_free_space(space_info, reclaimed);
-		spin_unlock(&space_info->lock);
 
 		btrfs_put_block_group(bg);
 
-- 
2.56.0

