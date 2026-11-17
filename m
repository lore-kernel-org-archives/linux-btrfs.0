Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794898762;
	b=Y+Pkw/X024OLh7MaSqtclZd9rkPOiQbUM21B9ldaQIVknfQpLEwsUw7migZclPtOyKg3
	 Q15DJIR7HENphN7dUPu2brOTle1w/Jzc/P2yl2IE8SgIhwTx8iBwlEt2arfVlVeC18Sil
	 9Qo1+rRGob/wdZLmrUvoau0lpQs3wgfdI6psaNZIpQVasPQ1GgpbwULnD8sjUrkPnyyMw
	 rz0PRtp21LAlRTRCjQsENLGwCmCFrpLDmwcQWbDBV0nx8EWE+Ke5MW8PqlE8l8oIuoRzk
	 7ePslgm5Nu2Zha+lsKSXajE1G5fWo8pQOMVfs1Rkow4gXfEldRY2Spd6qOpzY7le96g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794898762;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
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
	bh=55ebT/AJQkKCt8bjtwNqIGuv9KfCqDqOOTtGU0q0ngg=;
	b=SEDfN2vVjsOglHNUL7NOWioUSPajQeYJf0CmePfrd5ZRJr1DGa9xALQR6Z+v0+WQHhLs
	 DRGqSlOa5XrcEa6WOX2oxBElc1hLoZU5bQeNLw5WIhoGPWx2ANVXFCflceW7j4hbcvI26
	 0pkQxn7iO2RyiSfX/oo21BpbyR0y+5yGGHOXBBzqzsDF5gknC7mXO1j/etsXbGunY8eTs
	 ccYQxMeX++NMbOruhFbrapCoJbF+BLFscCkb8bsdKBODLrZDRkJdBfbLfI6au8TwumODj
	 lB2axuVeD0FyhDQ9eB54Hh7CtDVkJQapsRC5GaexIHTYU6MiejSQmdYxLJSzvZepXbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=N7oDV2CX;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=sCInpkYA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15ED606A31C;
	Tue, 17 Nov 2026 06:59:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B15ED606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=N7oDV2CX;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=sCInpkYA
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794898769; x=1826434769;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=2b09vOfJ/NxtmutnwSqcLpd4iD6vL2o6ejvxejgKTqw=;
  b=N7oDV2CXy3c73jpRSrV+nEVpI0rgX3Qw8OvkB9PAndI07hKvgSIsxfI7
   mbTzx7yaZcSM0+ZK8IJfFO6Cxy8a3rEOG5lvKYMsKh/Uiq15uuuR8UsVD
   +9V40eUFuhb+uIcukhMMvENSnd+x/QPb6q6ERslpF6p/L48ea//R8Vx7m
   eM3xKrURQbQC8XNJs7bs4sRywoWI37G3HdqptgQ7B24GGPJjlhpHpffho
   cr+D61KjFRw4K5zUIGGHa337lbma5qb0k9FRmmJ61+pyBJpQDXLAgrDfb
   ejoiWlywp9KRwdHjjUNW0TzSZPm5HKaTWZA4dKvK2JRUaOqeFs6DQK7YH
   w==;
X-CSE-ConnectionGUID: DC6b9d0IQFumje8mceKW2w==
X-CSE-MsgGUID: N8j56t9rSJKhNOGXyCnNzQ==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="156831353"
Received: from mail-eastusazon11012012.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.12])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Nov 2026 14:59:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EFwqd6oNsJGC++qJ7Pj2IeTo9aXnNCOQfZNenHedZOUX1hhTiWIaD6ze6qUjqDnjdpsbhpNlkOaT7Zrb12teFN2actBjNBuJqhDc0avcKolME/QPAtJUldqCLJZv3fpQ+7Ri9FBvTfZ99VpVCyNuFi+JsOOtFaQDenOd7ggWi08NvUsgZfHgerylTkpvyUPgdadApY8pJeo+ROWz5udfP6xT4manquv0ltxYPdWt+oMoEkgfYiw7ZPQF9pp+BGn8MUklmbnuFBjBXSGa3HTWpIqU8lWrkPXopLntC+k0mb+QTInECA8SmcaIr9ToRo7ZmFO/tcA2V8ZSjIKtjCKHlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=55ebT/AJQkKCt8bjtwNqIGuv9KfCqDqOOTtGU0q0ngg=;
 b=YhDLAEm58AUk7i2Cso/LDUyfd+lASMtSS9NTqbR9QLl2WnuMo0sao4wE7qSXyW92QL39+khGdd12jPzbWDi5Q4rirWhOfn2JlgeqseFEe5XicmESnujujCkhtP182butYcKklY5rB0BxERPB/pL5a5FSEMusgLMQh8uKAV/1wweXpfPp7AdKsCAxeUVINStwSFh27pFeF06AoFqgEA2JPNflZbTEC/7Lr7BPehrkdNqkIq9AUtFZgv2WFCKdiAJrZdjkDkKFal3G5269q0BUQ0VjAA45tnAv6qWoLzfO9XNMHxDKvw4ZW+Gx5IFM3FPrH5u3MZN3mBEEDN17MpaBrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55ebT/AJQkKCt8bjtwNqIGuv9KfCqDqOOTtGU0q0ngg=;
 b=sCInpkYA0z6z0OPMNcZ4bp3BjnY3YjLCTZWg/3iyY3hil1RIppITXnkUG0m1MT7XVR4vIVgTo1mh1p1x0sTa4GvPYVpwzdPtDeXCKhi78xHbIJaNREAeU7+fL4pR2p1or2SNL5eo+MKL2Gi7YwydhVZDpOm4FmVanL3OmXQv5Z0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CY5PR04MB994377.namprd04.prod.outlook.com (2603:10b6:930:125::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 06:59:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 06:59:11 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@kernel.org>
Cc: linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	fstests@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] generic: test that fsync on zoned doesn't fail with -EAGAIN
Date: Tue, 17 Nov 2026 07:58:48 +0100
Message-ID: <20261117065848.3825371-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0293.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::6) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CY5PR04MB994377:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e7d3a40-dc43-4075-eb4c-08df4478485e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|376014|19092799006|366016|23010399003|261022105027099003|261021121427099003|11063799006|10067099003|56012099006|261026121527099003|261026140227099003|261028144727099003|261022075727099003|261022113327099003|261102123227099003|261021123027099003|261009223027099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	lr/13GKltwLoBUQwf1ESiVGOlrftm722CUreNOUmzDK2hMfoaWEQTGfuUgESIpWJNqyDyIQTxAs5jrrwPe4NDr1wArdHPhtdGryTwFPnHDhZQJ9Ci5zoEcNMvdc2gVLDsqoMpkfsG4M4sMSMkdvMWBxlYaNt3MceVsycFtvj9Vx3zH3WCKEp3iGuqtFVxAiUDSm0fKAE09tJAemgh2312kVisM59WZSF298uQsV4ZQH6Hch+8yfOU9Lryacp8r5jkTmh4wKs3PIB/dzHA22SDSYSVOZhH4fGEIQKbdkdf4fGUlspvJaZFiZ2ncQerUUZOpVJCt16v7mVhOgIesw94VwZK8o8KElXeC9f/Lo/wJ/DeOK2pFggUXsDuoUOf1HjpLE9hvIDF6ROMoK1OeDEF9McL3SaU+Daqvm5DFRfzft27+x4zIgOU3PeVClG0LTEYOkF+v/Q5Q76Ujm3t5BbPr//P2z3LLsaF5ysRCKjMkVJY+CaN2e4k5JMpZe1bH3f3V+L6rEauWrugD2s+09GH0INCnNfjYxNYuyIltkeR2cv6LmYrZr1Wl3YJolQyfpcHAy2TJXGThXTrhfqifXLcAZG2JHcY4w99B9tzjlsVmYONuZlhwUkMS4SInNNNaDR0dl88HhSIc8k2Qa0oiE2wRPYHAtflYUp+KF2o5rVd1Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(19092799006)(366016)(23010399003)(261022105027099003)(261021121427099003)(11063799006)(10067099003)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022075727099003)(261022113327099003)(261102123227099003)(261021123027099003)(261009223027099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DWlAq4JLAccJUlpJ6mO5QULzpMNzi7oPHi/XqzdOWCH4tEVAMxVc4hGe+WpH?=
 =?us-ascii?Q?ZWe9N1fRq5HVmKJI9zTQHN5U18wQ6TQAYZHR+iJbiGaOursVAXrjxkcT3f0B?=
 =?us-ascii?Q?PR6gIYvX6O60aaG4Fz1Yps8leB93bmMrg264vPDdun2kekX71aXWNns7f9jD?=
 =?us-ascii?Q?KYOdeHB2UbyZ4CU0TGKn1KbDkXayZL/wd7G8pqDdLB1g/FFktX5dZq0+ktFS?=
 =?us-ascii?Q?HhZzF1TBlwDFIWyW6Mjyr509IIC2O19p0Q7oNN/YeihBxBcHWW+63TXprsjR?=
 =?us-ascii?Q?sZ0mwLD7gdUzwMH40bbH7yDEvaO55+tZARMMDrKjC07lM3a35QQziFvDo9PY?=
 =?us-ascii?Q?4ocv8oc6OlNNMO3KLWjThKlHdOPAdIKipqfDFCVLs8650SO6NTxt9+WBlXQ/?=
 =?us-ascii?Q?Ex2wL4BeuHxkBCCyL+av/MBi8HajfvfNI/1bRubud3Dbt2z1+MayuH0+cr3L?=
 =?us-ascii?Q?K3gA6yxhAGwhh2riOGrkDM7tIQHEh0OP3B7TrqgzUa/qyCvIYuNb4EGrIFrj?=
 =?us-ascii?Q?xE13D4cQbBTMpHTOn5lSSm4w775Y/hFPgYcgD5ac031LTwj8Tx2r+Pnn9u1m?=
 =?us-ascii?Q?rcUOPyV3ToL/lmQ0v74GckfI7yQkeex43AaTXSFOYkI35j8M0WxDbKddpZ2a?=
 =?us-ascii?Q?W5trNn12mYs7poptmt43E4tcc+UTAe2CELVQYcmtOFPXm7nZY2xL0mMwQoHM?=
 =?us-ascii?Q?buUe6oMWBapDytgogHN5fbJnfNkDiav9V6q186DOhjxDNNycxZrfft8jfF7y?=
 =?us-ascii?Q?W6FOKZga8URv7xu2j4G382jMchnvOfzoDJPhXhdHK0DAt0QRI6Ptnd3KaGSf?=
 =?us-ascii?Q?7YlirQViERq/c0Yx1PnogG4uDo4rdIK31PqgE1hHeqq69e1w6Dy6EAURL/Qy?=
 =?us-ascii?Q?ef3z+V7Pz9HNP0bImYru0kl060ktHqURGScA/qfSsUKlc4eDI5QuQEgWP5wd?=
 =?us-ascii?Q?+9L747X2sfN8UOv+LjfVqOqhDrm3wRpU9okbihr7Gy0SoQYxH2JhhOaqaGRB?=
 =?us-ascii?Q?jLkr6utoZf6ILe9LIgaXWXsnr8T34P4w4Lg3J4h7aGsTM37T/cxcW90ywRRh?=
 =?us-ascii?Q?Bt221HyrsTGjrKWX4wIB+mboRJfTkMEmiM8RawKjhf/jFX/Tko+pjUDo7tsn?=
 =?us-ascii?Q?tf/U6ruIUHirPUJQsCwJXA+PeEnSbI7WRe0jkKswqyzFtV+Cr06DGRfMLBr7?=
 =?us-ascii?Q?yslBDa8VP9JQhq0kMrjjzYxO8rxpcLOAeEF+2E/czcb0H4ptOQU3yedn6O47?=
 =?us-ascii?Q?+4TMDNQ8gz2rpXLU0FOC4pn/KOUHjZVgiaT2qgj/0lRJrYaPqy4ZTHwl8Q0R?=
 =?us-ascii?Q?YIS9UFXgGjpJAUSBDo+UJI/mMmN4x5d7PL2ztwT9NaYeBrPz5aO3pjVA0Tqi?=
 =?us-ascii?Q?drtPphd2pQ0vsAVdop9/EpC5VOXAyWpZCcypMgS0GEHn5JGEgn8bbB8+UlkC?=
 =?us-ascii?Q?+0iQsvVvyTlxZ95+wyBOVbsYrmxsrC8H8i/juwF6LHTgiYrZbRA/6n5GGeyx?=
 =?us-ascii?Q?TBK5ZQ4PkHKtn1c4vb/GfomZ021ZRWOctYeUTq8QGidx2DlbblJMlRZS7LaO?=
 =?us-ascii?Q?JOYTQiqA60gdmc1ZvMBidWMYnWXKEeJZ/MXvb/AT8GFCJezow0WXsG9a30Vn?=
 =?us-ascii?Q?QshakxGtzMhHeJAsxJiMhzraZW1PQBCoQN2APq3R8y08SPp9FVBIzhDzA9fK?=
 =?us-ascii?Q?ZD8IqT31KRdGuNKTaRBwUw3MJAtTiF7+h52JIknrk3HeVOQLJRR/0mifnNGQ?=
 =?us-ascii?Q?0hdadZn+/hO+4xQUgFqz+tteLYQdE+qWsfc7AZUkb0v2B/DNADq8vvFh6NGN?=
X-MS-Exchange-AntiSpam-MessageData-1: XLF1vgTOBPKJsjg3p6C5bpfhXyoHdaISnKA=
X-Exchange-RoutingPolicyChecked:
	xgBWAFQOVO329sqUJeRYGOCmvUtBJgxYEKge6h59US9jQoUTJNOldo/hcy0P/WVhNYEOaoulLY+Rn6gPSXQR+gn4Bf5pll7mTzYJwCBOyC6Yg1vrjE5ZcRzFJYQgMFAq/sFpqhhjzJ3nfhS/RQ50BZbUuEB8aBEq0sNnMIsZP6fDYGqPdV4EYeV8PeLamgRsYZBnKQo+6gKOCWrXL2gvNh57r3MHgpIbzSXmAIuEKc0CTL3Spg6+VImCswg3mrZUfjWpgxTxc4Wn7khQPgkSFSt7OjyprmreRRZR150yxYa63HMaygbDgf4C4zxzsjVpT/Zar0h0G9IRKUbueYyOcw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0sSSuMLQnFJhiourwJds61v6pKw+b16ZRGQBMR++BeXfqM8+6QaMTI7wb1CZqXTwt1C2lv0hXAKJkQTX55I5/p03+RLuJcBMOqxkR47XiB0S3TOXicSDWIwI6oaLn/oUIF9fygbz39bOv5tbnwN9TaLIMXsuXs7xpHHPnADttAfCflm1Md72Hn/8qxoA+y4obJwvIyojb7KIrfdSV7uVx8+s3hOMWMvl3n91aqG7j+KuqqyAW9LyDWY/+xAByhXcXLVDRut0api3vE+1ft9jwzbWxPOlPAeYaDiJ0H6yQkOzVD1tXSAbU4AhULcCnrKo44SeW6VkWYh08wTci0mOnFyPwO7Ete4BPtcDs6mLxSxxYM6Na6nS505pXA7mL960F4EOhKqtMFHx2YL4eaPHYH0/3XpArw+I7zncFRYWuFY56xAXK5hVBFMCxRlP5w4ljM9GLX5rss372rjkX5f1zxrC5eZNwCSLO9k/s/D6wEDQfzfwDuf0TJospTB9B94ucBbxrDhDHyIMx5oQSZBGAoEbOWA76/FQdgL0JXYwdcOPqKnjoJaOQpt0z3pVsdqJEnjgHfrc5TMTwXXNqeO6J3PIZGzSoEejMbbzwj8Y+zRyoefrI45mCxMisu1P30Ul
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e7d3a40-dc43-4075-eb4c-08df4478485e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 06:59:11.1837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QlVOHS1poVx5ikYKJSyKRpxXU96ZaWRYPB2VGzcOQrQraX3xbmUHAsqNPIRkuqg/CuxTtZEhsKyVTYIzV71KpWLykGnyaZi6TRbe4oabPHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR04MB994377

On a zoned btrfs, btrfs_start_transaction() forces a transaction commit
when the delayed refs reservation exceeds its zoned cap. If the cap is
still exceeded after the commit, it returned -EAGAIN, which fsync passed
on to user space.

Run parallel writers creating, overwriting and deleting small files with
an fsync after every write on a zoned device with a limited number of
active zones, and check that no fsync fails.

Assisted-by: LLM
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes to v1:
- Move to a generic test

 tests/generic/814     | 83 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/814.out |  2 ++
 2 files changed, 85 insertions(+)
 create mode 100755 tests/generic/814
 create mode 100644 tests/generic/814.out

diff --git a/tests/generic/814 b/tests/generic/814
new file mode 100755
index 00000000..316925c1
--- /dev/null
+++ b/tests/generic/814
@@ -0,0 +1,83 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
+#
+# FS QA Test 814
+#
+. ./common/preamble
+_begin_fstest auto quick zone
+
+_cleanup()
+{
+	cd /
+	[ -n "$pids" ] && kill $pids &> /dev/null
+	wait
+	rm -r -f $tmp.*
+}
+
+. ./common/zoned
+
+_fixed_by_fs_commit btrfs XXXXXXXXXXXX \
+	"btrfs: zoned: don't fail start_transaction() after a forced commit"
+
+_require_scratch_size $((4 * 1024 * 1024)) # kB
+
+if [ -b "$SCRATCH_RTDEV" ]; then
+	zoned_dev=$SCRATCH_RTDEV
+else
+	zoned_dev=$SCRATCH_DEV
+fi
+
+_require_zoned_device "$zoned_dev"
+_require_limited_active_zones "$zoned_dev"
+
+nr_writers=$((8 * LOAD_FACTOR))
+nr_files=250
+nr_rounds=$((4 * TIME_FACTOR))
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+# Every other file is deleted per round to churn data and metadata.
+writer()
+{
+	local dir=$SCRATCH_MNT/w$1
+	local r i sz
+
+	mkdir -p $dir
+	for r in $(seq $nr_rounds); do
+		for i in $(seq $nr_files); do
+			# 4K - 256K
+			sz=$(( ((i + r + $1) % 64 + 1) * 4096 ))
+			$XFS_IO_PROG -f -c "pwrite -q -S $i -b 64k 0 $sz" \
+				-c fsync $dir/$i || return 1
+		done
+		for i in $(seq 1 2 $nr_files); do
+			rm -f $dir/$i
+		done
+	done
+}
+
+pids=""
+for w in $(seq $nr_writers); do
+	writer $w > $tmp.writer.$w 2>&1 &
+	pids="$pids $!"
+done
+
+ret=0
+for p in $pids; do
+	wait $p || ret=1
+done
+unset pids
+cat $tmp.writer.* >> $seqres.full
+[ $ret -eq 0 ] || echo "writer failed, see $seqres.full"
+
+find $SCRATCH_MNT -type f | sort | xargs md5sum > $tmp.md5.before
+_scratch_cycle_mount
+find $SCRATCH_MNT -type f | sort | xargs md5sum > $tmp.md5.after
+diff -q $tmp.md5.before $tmp.md5.after > /dev/null || echo "data mismatch"
+
+echo "Silence is golden"
+
+# success, all done
+_exit 0
diff --git a/tests/generic/814.out b/tests/generic/814.out
new file mode 100644
index 00000000..95532d3d
--- /dev/null
+++ b/tests/generic/814.out
@@ -0,0 +1,2 @@
+QA output created by 814
+Silence is golden
-- 
2.56.1

