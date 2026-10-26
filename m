Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031010;
	b=CSllO3xRVJ5QcfPvaqNITt10jflsbdCaouyFz1jIVk1PRiD/VyXtJtd7XAQm1Hw8voSV
	 fvgxMv7TKOkErAsYF/cOySzEy6H8YpcUwnVethDFTWtLV3t0V4JlGPmxYrEpxa7mbQdT2
	 /PA3rr3AGuDfT7B6si6R3c80L0JWLotJwpoDZ2yk2Ana8GKWYH31bfVKNpd8xNeepEiZv
	 mxQzZgnsQgNRGhP+TI0OxrzMI8ahqavyjY+1wy/hEpeIMKWE0D72rlN/SrN5ZmAcO9uFB
	 QLciplVGijTzdLuCK3Qu7l5F94a8lmGmaAC28tAzpyPT+uRBOp5LGOewDPgtZUMGRUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031010;
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
	bh=Xkntgra5n3iNAAfjmxRpPvRSSiZzVBIEhC7SAy+r2d4=;
	b=N53CWzt20+eHth948xOLQ+s83Pc/qj/4OYrEbbmJJP5d5CGcPbC01GLpLZRi9ZuiAvtr
	 nTepiy9GGN9V8DAvOpzN8iovwpo0sYs8ZbwJbrGjqhYoxEJNIVEsWsLv2uOoN49SwXxeg
	 fATodu2fQRd8MFpcfPcAxKPX3VdVM54NJQRZ/yHS/se0C0k0LnPjwR4Vl4DzICWe6NQa/
	 e5VOorE0DWCXc8SaloYTJW7KvIPnmwJzj5iTJyKxnd5p0+OT221YxULUJxVx7VSpnTHMU
	 qEk/u5AC18o37+B9WQQ2Ax7WZm1GWhQWM43vV0WRLw4hdJV5GI+JtNL63OsstgTOpIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="mkDY/1WV";
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="wHT/g3k0";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117A4606A32A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 117A4606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=mkDY/1WV;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wHT/g3k0
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031010; x=1824567010;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=RlsNfnBuvTmle1A2/ey2Qw3OefmvjrjLmaxmF1ZYDmw=;
  b=mkDY/1WVl/IE0jGemhn41P+UAxuZFIUQpiAtbzgYZZYA8u7us04EdxCT
   PAewh008umWSmGtcfmtn77rjrjaNTD6XfnhM74ZqSX10E7ieUWZagocO6
   zv698JxhkvSffQhdDi/+nrJzG8wZ3urOjWkY1Qm9bYli40FU2MbqC4qhI
   fONtf9dOaWDxvdkUHQ7AXHNZRbkRBRQRC7JFI7t83eoYv2nFdm4z9koQz
   BdU+P1srgtqiD3/MNABbQpGNr3ouReUiVz2rGRMSiqQUiXYjBNZKeBjtg
   ynxuzY5hUL3AMLwEnA7eVBrrVFFWWpxnca8qA++++Lax5ThVk2nPb7c+d
   A==;
X-CSE-ConnectionGUID: ++gv6NZeSb2PYSKS5JwuRA==
X-CSE-MsgGUID: PVMD72VFSCirYuShWQ+82Q==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033912"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GqC5IO8KnPHm/JhsOBjJJbAchgx9F8nbDOLukUz9bLZVeXMpIFmD28e3e1NfSiildXeMrS8RfyzyAn8T7KkpVyKUv8JugK4aiL8IQ0f5pZ5gVCuQP07GV+eWkot0/fRk0Ghb0MOjui9C+6lJRi05kH3X+HFT1ZdQvG0QJgPjXMNeiz0dAUpRoMTN90G+AWSnpRjAi6yV6lAOtCebtbEzIXzICYKiSNyabIBNelDd0jC+T4W3d+kHY20iVMBYfVo3G1lKSEGAGtQZ3+TLca8v9Wg8nKg8qeSo2lL17Qet084zmz8P9HqN1gkXx9OhMXz/dRRdmY0Psv52i0JoSlnwUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xkntgra5n3iNAAfjmxRpPvRSSiZzVBIEhC7SAy+r2d4=;
 b=R1DrZFq5sKxrSPM5SYbq5i9EjiQS/rP7Tp4qpx6k+Cpvzf4LN/FCkjJtIxTAUgwaHBJB6cnEgCeRtdgfOXHaBAhUGfGny8TAikJn2wDlr9n5fboy0n4P8Vnk/GGhicW/ceK06WDWdAyRlg2i0rrjhgiFvE8e/ntKHcjZkcYiXqzhslIvf9jEmZNuP+2xDoseUZL9jOF1AM5/EsmP+51rWssC3nPd+JLk7o0p18YckH/S6VImQMaHVqZz+1eQtXqBbkTUl+FQ9rRfYzBSXmmySNES58nm32FyUKJ7I0v2fyCxxXCLwT9BR6qiNZY7mhh6HSnNpkpoX+C2nG/eWT1qFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xkntgra5n3iNAAfjmxRpPvRSSiZzVBIEhC7SAy+r2d4=;
 b=wHT/g3k04mVFQzShcSSDOMTbgVDSBm0SBVFcK/vzkQRqUoGvmkq9OkxSAluBlVA4VW6uLZgVHqeW9zLxT2rkQQZuIG7hreJX1U/wGtopPSCS65HHWO6FFw45W1dNZ2T0+VPOWpluC7xNQExK7DZANY9OTMO3RvXV+Jp4ANpw2U4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:54 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:54 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 18/25] btrfs: zoned: prepare reserving the data relocation block group at runtime
Date: Mon, 26 Oct 2026 17:09:06 +0100
Message-ID: <20261026160913.207909-19-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
References: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV3PR04MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: 27135668-945a-413c-0c09-08df337b922a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|5023799004|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	eNT3oUp4SXBbfFJ/13AAFyXhxiyYgOkmwa0wf+Ou/nTqg8uz+UdqVlwbOYW2KZ4Udlpg1Rm5/HwOF3plyDyYQexVjxG7hNU9WnQUMCXSOlt6iOuZ+OG+ho8Ik8og0M9Qj0JGvxq9Bz4mPfx46Wrg4LFHUARprsdlH04lxnnkd8HvIQ+tZ++N39vMQYXnvbuv+O2tV21cSIIsXbQYUyDL52uguMiMP9QxJhpt5f872x5alA8fekaYldWaRl+YQ8lKikNovuvTtzq8laaAz3g6c4e1gs1R4WrVzeqay0RZgvi0rJoY7bkQNfo2ZmT73P4ZXW6hWJdnWI5r7qWPrXTrVMiyESMMTeKgJTDaJ+Nu6759tOvS5q8VPSRFMEWkfNH+MNqztVVq4p9QeqoEB8D+UnlLV7iqgMg7PmY5rRXibVS7nl6FYj94wqreXxxqyut6k5bMYAWRZ3OUNr1vhb+2IL6xkyoBczNOzzsad4+xYJEYP4spkY1I6O9DYpP+z2NWequ3RMahWAtuX1JqltZflBGY4ZmeJ0Y/rEUhatniwzI6d8xCf4apiY3vX+iCU9PmKcTzxl5KoLHjMlDwNaGCEMr3m79I9xmy745bjI8RMA1BVZ03qEIre6i3OlrXQzOAeNUFhr80Y/8GlukT4n0VNMpc2fcv63BxUEtU4YyKBU0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(5023799004)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gcNW4As/HvyqNODrtmB8t7O86E8qbMHRWYTYEy3EnUm0YzEHfQBGugACfGfY?=
 =?us-ascii?Q?Tt9lWbD36LFFgC8rJMdlro691Km7sFuQauWGpJJe3u9SfdwL+lbvPG1K+3DQ?=
 =?us-ascii?Q?XSeTJMqt2ReRIuIarQa8+5XzOi2AvyXVROwA8Z4SITBVzJZMr6jLwLR9dmZI?=
 =?us-ascii?Q?/8OK6YnEfK375cmMzD8Q8Igrmoi0mKJGqjLorvopoQxM2FcBALKWWzOFfKOe?=
 =?us-ascii?Q?NWvBLKSaoYGeBJ0Hqg/1dBrCxHDb1RCGEAC6nNMvTfA699lGwk8jMgIL2YQF?=
 =?us-ascii?Q?wJD5r93wESXwqJO3BCnQ/UDvm6vKlWd8404DljoLTZdFYJWW0ovCuILHeRpa?=
 =?us-ascii?Q?Bt6cRP1jXbQKdOv/bRozmwqqG/xKREln7CBvufGPlZronD/NzG62KFTF0him?=
 =?us-ascii?Q?aJCs/LhHQ/ARo5JA+iYQsc2mlyoPjpclLnE2v0PMg1vxyS0nt0PqYyMmglGN?=
 =?us-ascii?Q?1PLqP1ltDO7Az9nTgU6Ypz8x01WB2VG15y25BkAUdnfoCNEkIiiad89mjIwS?=
 =?us-ascii?Q?t/zVGr55dj7eflwXYsL6uHFz6Hh+UQUi/63LM3Zq+kaWv3ki0JT3sPUl18bW?=
 =?us-ascii?Q?OhymI/flhYjzZ8mfGeQBDm88pGOMv7fumBOvY97CaITAMuMlkRlL+LZBKqxd?=
 =?us-ascii?Q?7CGzADdjTe63uGNouOib4l1i4C/R1CrtTjDkSlkPHUW+Sn6jBy2PQETwl81O?=
 =?us-ascii?Q?Ve1x83dBlK3C7/LQGAvFecbVYpn4/Mr9ls5UqHDxRrhwSdEV53oaDzVL99xM?=
 =?us-ascii?Q?xdQ/672phiZiGeMJf6G0mSXhwh7XK7Cv+aLSTG22CbQC65Fly8Hh35UgejtZ?=
 =?us-ascii?Q?hWtFvVKI6roaYSrqu001EAocfTWrwXYw/h7h04wz6GnuSwNPBfRXK6rgQ2Ev?=
 =?us-ascii?Q?HxorVcUkfQXdA0GbNlx+/96zWpKPDfDgtjCkzM9RXef6PWfDQsDo9pH8gY7s?=
 =?us-ascii?Q?Kt+0HCWaEPsDoscNmeWWQyR6aose1S6GNVAh/HwO9nK35uThEYaKU5SYj+eC?=
 =?us-ascii?Q?RWqHQTdjvHp7LR/q5x3Y09LPAK0V18cH7M4wXSWuHODuP3levZc6jFOBeFFu?=
 =?us-ascii?Q?uU3gDLKe7Y4e70S6bTcOOWgjn69TtliXrvv2ahQLhqS50YXnkqgd8jAbSj0k?=
 =?us-ascii?Q?EfNv35U6JoqMVesq9tMUdQLGpGld3OY+fCh1FELRs5Ou9Kx7x6PgqWbwJbxI?=
 =?us-ascii?Q?GjK1+UoqVdKJNvuK4K6cfJCbXgT44GrgE7hMFYDKCR3CP4sxE9CYCuRBx+Hh?=
 =?us-ascii?Q?It321fAnGs4WpUG22WduJKGKRLTDZgtdNsXi+eQLQQq+VHQzUnq8L+dzYLgN?=
 =?us-ascii?Q?JzliL/4emMgMT6fo0QwMr75dbHOuPmIGjHczrpCix+oUJNhvMgkUryIjlFEO?=
 =?us-ascii?Q?kbyaMSDh/OOwClATFXe8uSmDH1Pm+IA11e97Q/uqMHN/KTGRNOhgPAFLu4D4?=
 =?us-ascii?Q?Ch7VXHrrqJo4fpl8Cel01TUR8eX4CupCsErLefqyt82hj1Vn7VhWE3xrY5DI?=
 =?us-ascii?Q?5LWRh/JDQJwBKbTZY3Jacej4vW4T/dk5TvD5LZ3hLK/G0f1YwXkt7XPmH3+L?=
 =?us-ascii?Q?UQwpCaCtFA0ba52cY+R9mn/i+zDEHCyOkU/QmOV6BOePiX0aYRq7YW7U4XqP?=
 =?us-ascii?Q?0c4z3bf8Gbvo/1hSXOnAB/tG8aMEKUQ3YF0WjFj6lKIHhki+RIlPKRbweAPm?=
 =?us-ascii?Q?G1FO3nXygMxIUQtVOzTsHrSzqiWhryXxmTY04P8w0LEzNPqQ1X/Xa7+NycyF?=
 =?us-ascii?Q?7NUx6tmE60OcCnyjRMMh/tKQ70tgoEFvTMcsRAK0qpjg+eWk9PT5j3z3ohPN?=
X-MS-Exchange-AntiSpam-MessageData-1: FFq/dLsxFqqebg==
X-Exchange-RoutingPolicyChecked:
	lCfrapx2tGfAhIb4u5o+fUUPpooSKVV/1eb3SQB71Yuq/rPDjAEK5IZ5ixLrgg+xdCtderICEpUTgtC9qhV1W3MORO93Q7bkK8PSr9erdBFIbt5yZOED/MNe6oJs+6iFl3oGngI01OSt4gkowqX/FuJcp6PIOgE7lGBM7MbsMRqJQanEm6JdXhN5LS5ESXVq6ZLAn/jqN67xk/rItRzW9+mOYxBnKpns4LTRG8PjyeDWPLVSRc/+1JdC3XAxwh4AGW2GRXbk4f2UyUN0WmjpZffot+NgsccOg/42HIRko5PNaFLxvn8ezVUiUa5lu+oUl/grGTN3opLogo6cOqTMZg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kdPyjkzwlh4Dr0hSbbZ4jpZYZbfM04F3rSXKPruvdfDuQBjaus+xLI4jrp5Pi+wtLvfvysDgle0YZOdTcWZD86OwvbWBCbbrZlF0tZ4MEhxzZEaOWasf89TS3aKb1PrszSTpDNlDq0s9xP3nB5wchwBfsKCm237OU4icLS820zVCdNjlC5i7Xz95SPswb4iEKQsWFfUiBwzg44LIwWnWk2+I5KevX47CPhiCPURu2xkqFGhD3H2rm58QtGeE0cDtHhi2qmfU2sIkZlKOFZvgJsh1ol7flmoTxxeKx2B4CAv8mKF61UVAdwVaJUa+1Kse9SLfgDlNhUkYSkvxFq/8WunDE3YXPVGkp7Kt5678XH7/8UNGGCSadIMlCX5cZeJXKHAzoWqReJt5Qa6Ih8lhfjMGPNR1iAr4KjgvlMn+Bszkx2aPO8hr8a50L3Gr0sDe/4KB5481WTMBne91KPJ0Iagy+E0/RiS1b0cS2xPjXNDgGqhZSRAEvfkeo1eYFzV8T+RNroE9ZgD7FZuMPCkyNIy0vzZPLFtJw9gc8PqHUkZSp5/yI02iWv/eIKfz7cTjzI1Yyd02lWUqsUy+5uWyWSMADP4dQ2PPrQvbxP3I9Coi0tlYqvVZO7QvU7ixC5R/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27135668-945a-413c-0c09-08df337b922a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:53.8411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7bsnwC/9MQQCTJnCXm3OexxsPYff0QRWh0x7qERzfpW0k5zaWgwStjH7z0SgXBRzBwbj0CtSpTbgDsiV5Wvd1tQcfKTsAXc4aidZUT/vQWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

btrfs_zoned_reserve_data_reloc_bg() is only called at mount time, so it
walks the data space_info's block group list without locking and does not
expect the candidate block group to change underneath it.

Prepare it for being called at runtime, concurrently with allocations:
walk the block group list under groups_sem, pin the candidate with a
reference and recheck that it is still empty under the write lock before
moving it to the data relocation sub space_info.

Factor out setting the data relocation block group into
btrfs_set_data_reloc_bg() and transfer the complete accounting of the
block group, including its zone_unusable bytes, to the data relocation
sub space_info.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 133 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 96 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ceb7f54e838c..d275568cfb35 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2905,6 +2905,75 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
 
+static void zoned_move_bg_to_space_info(struct btrfs_fs_info *fs_info,
+					struct btrfs_block_group *bg,
+					struct btrfs_space_info *to)
+{
+	struct btrfs_space_info *from = bg->space_info;
+	int factor = btrfs_bg_type_to_factor(bg->flags);
+	int index = btrfs_bg_flags_to_raid_index(bg->flags);
+
+	spin_lock(&from->lock);
+	from->total_bytes -= bg->length;
+	from->disk_total -= bg->length * factor;
+	from->bytes_used -= bg->used;
+	from->disk_used -= bg->used * factor;
+	from->bytes_readonly -= bg->bytes_super;
+	btrfs_space_info_update_bytes_zone_unusable(from, -(s64)bg->zone_unusable);
+	spin_unlock(&from->lock);
+
+	bg->space_info = to;
+	if (!to->block_group_kobjs[index])
+		btrfs_sysfs_add_block_group_type(bg);
+
+	btrfs_add_bg_to_space_info(fs_info, bg);
+}
+
+static bool btrfs_set_data_reloc_bg(struct btrfs_fs_info *fs_info,
+				    struct btrfs_block_group *bg)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	const bool migrate = (bg->space_info == data_sinfo);
+
+	if (migrate) {
+		bool still_empty;
+
+		ASSERT(data_sinfo->sub_group[0]->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC,
+		       "subgroup_id=%d", data_sinfo->sub_group[0]->subgroup_id);
+
+		/*
+		 * Recheck under the write lock: an allocation may have started
+		 * using this block group after the caller found it empty.
+		 */
+		down_write(&data_sinfo->groups_sem);
+		spin_lock(&bg->lock);
+		still_empty = (bg->alloc_offset == 0 && bg->used == 0 &&
+			       bg->reserved == 0 && !bg->ro &&
+			       bg->space_info == data_sinfo);
+		if (still_empty)
+			list_del_init(&bg->list);
+		spin_unlock(&bg->lock);
+		up_write(&data_sinfo->groups_sem);
+
+		if (!still_empty)
+			return false;
+
+		ASSERT(bg->bytes_super == 0, "bg->bytes_super=%llu", bg->bytes_super);
+	}
+
+	spin_lock(&fs_info->relocation_bg_lock);
+	fs_info->data_reloc_bg = bg->start;
+	spin_unlock(&fs_info->relocation_bg_lock);
+	set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
+
+	if (migrate)
+		zoned_move_bg_to_space_info(fs_info, bg, data_sinfo->sub_group[0]);
+
+	btrfs_zone_activate(bg);
+
+	return true;
+}
+
 static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
@@ -2976,7 +3045,7 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
 	struct btrfs_space_info *space_info = data_sinfo;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_block_group *bg;
+	struct btrfs_block_group *bg, *tmp;
 	struct list_head *bg_list;
 	u64 alloc_flags;
 	bool did_chunk_alloc = false;
@@ -2996,46 +3065,36 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	index = btrfs_bg_flags_to_raid_index(alloc_flags);
 
 again:
+	/*
+	 * Find a completely empty block group. Unlike at mount time, this can
+	 * now run concurrently with allocations, so iterate under groups_sem
+	 * and pin a candidate with a reference before dropping the lock and
+	 * operating on it.
+	 */
+	bg = NULL;
 	bg_list = &space_info->block_groups[index];
-	list_for_each_entry(bg, bg_list, list) {
-
-		if (bg->alloc_offset != 0)
+	down_read(&space_info->groups_sem);
+	list_for_each_entry(tmp, bg_list, list) {
+		bool usable;
+
+		spin_lock(&tmp->lock);
+		usable = (tmp->alloc_offset == 0 && tmp->used == 0 &&
+			  tmp->reserved == 0 && !tmp->ro);
+		spin_unlock(&tmp->lock);
+		if (!usable)
 			continue;
+		bg = tmp;
+		btrfs_get_block_group(bg);
+		break;
+	}
+	up_read(&space_info->groups_sem);
 
-		if (space_info == data_sinfo) {
-			/* Migrate the block group to the data relocation space_info. */
-			struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];
-			int factor;
-
-			ASSERT(reloc_sinfo->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC,
-			       "reloc_sinfo->subgroup_id=%d", reloc_sinfo->subgroup_id);
-			factor = btrfs_bg_type_to_factor(bg->flags);
-
-			down_write(&space_info->groups_sem);
-			list_del_init(&bg->list);
-			up_write(&space_info->groups_sem);
-
-			spin_lock(&space_info->lock);
-			space_info->total_bytes -= bg->length;
-			space_info->disk_total -= bg->length * factor;
-			space_info->disk_total -= bg->zone_unusable;
-			/* There is no allocation ever happened. */
-			ASSERT(bg->used == 0, "bg->used=%llu", bg->used);
-			/* No super block in a block group on the zoned setup. */
-			ASSERT(bg->bytes_super == 0, "bg->bytes_super=%llu", bg->bytes_super);
-			spin_unlock(&space_info->lock);
-
-			bg->space_info = reloc_sinfo;
-			if (reloc_sinfo->block_group_kobjs[index] == NULL)
-				btrfs_sysfs_add_block_group_type(bg);
-
-			btrfs_add_bg_to_space_info(fs_info, bg);
-		}
-
-		fs_info->data_reloc_bg = bg->start;
-		set_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
-		btrfs_zone_activate(bg);
+	if (bg) {
+		bool set = btrfs_set_data_reloc_bg(fs_info, bg);
 
+		btrfs_put_block_group(bg);
+		if (!set)
+			goto again;
 		return;
 	}
 
-- 
2.56.0

