Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031012;
	b=NFPfcATNKpQOXjcNuDbNd5Qu4Y5yLZBXlkpHNphuC50U6mBMcW7iqh8ohLEpDfIk3hvg
	 a1fyOzf3gcLS3MBtF6sr3h4gxMPF1bkocKhR7LrqU5tIpsjZzU2QqxZSXtU+MaAz7ew3/
	 8eQ7VwQLvrEaS5iPfdWFeMp32rWhXARy2XBptB8tknZSXEbTJX/U+f4yHIEvUBcl58KH7
	 dvAM8SFBU9CK968gYWAcJDtsPYiv7jEIc2EpDZRTi6RcPEK7T3S4gZ0KgaL3J+4VciS1o
	 M16dUPmz3hsP/If2y2en7p0a9BT1UIxPzuKurbE6psP7TU+/8pV8iImyrnzPm4O0yeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031012;
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
	bh=qTLxP19pVvB188JHRBi6HaF8sGMBJIGlX0W/4PgqUrA=;
	b=Wv4YlHlSBDyNwAU1Ol5WdjY/GgXG17HbDGILXyoXsbvzFxi4E/ypy9ynqyD296b94eBC
	 sJzmhD+5TeRBFsagVDwwmue1c/ov4eGrLCvSlVdM6zqy13b8Z+6NFX3amLBRbIcYYhQlV
	 qW68espdRU0JtwnHjG2tWvZLkPJrYrd1h7ElS+ChoWJ9ElA0FcbBryDgeY8Q26CW+WlOR
	 tMNVKZ/BkdNuXoox6TS2AP/Oc8+WnlGtuugJGNBhA3bd6isiFcS6fFllr7HjZLHNq/dNw
	 cVUJamwfOVcHYUyLCpzsVYyEEti7C4FvZ2ZKbALMsEnYL3M2HgUhAiFAywKxaMQuwoQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=E3jt+lvV;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=V4kFR3ok;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5EC60A2613
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE5EC60A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=E3jt+lvV;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=V4kFR3ok
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031012; x=1824567012;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BUlmkOaZlFUqoFiFPlkR8zE7D8lPPNdK1ua1Cq26suc=;
  b=E3jt+lvV7LxSpXpVe9fHjux8/XlPa2Jkh1BkpStGmgvBfg3VwkYHdEEw
   r4QAl64hD++p3z6wrBeVSzLj/4+z0ZZC7OwcxbbEWx17WqN0xvM+CT2+6
   JXztQJ1qHyl99zPIDaHrO7HMFPrx0WK3rddv6f9nCjogt/M2xuWYeeHBR
   DWgeXKQqGF25igQTwqtjdX1mY06v6V3wIWY3uYL/7gqs2iwVHE/2+NADz
   IVTe6gotatQi1yQwceeG1KR+Gj8jfMbEvqL4/c3MslCAaNxJVVkYKNqKI
   rpIMlnA3aRITuS/Lf+7MaHNeJhwKieom2gpR6KSOXT120/JkiaeyeV5RA
   g==;
X-CSE-ConnectionGUID: w66pgYIPSqmhEokV1BcKxQ==
X-CSE-MsgGUID: cGLJK1ZKQfGPpzVYFv+04A==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033920"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LQNiZUN8L4oGFCjmKvoLHMS9VcICQA184wNDciUx5NffA+1GOjIi4EGxU4wp1UmtCvSMIQkF95ieB86NkWBkfVdo3xIdqktqtT7OvkLz/1qxIB28RqWAQB6hrJyWog7o+Tek5wvZPEb8OboJGiOp9QolQiabYd7XjDIPSRtPHJM5FWYWCs2W3tWA6CXrC41kG3MSP0QdODBNSAdN5mDg5SCq2XEjJIYoQAl6tANiPIdeM/zwxRLzXMsBu541k//h1+jOZV5TpmCZYqXSynOA8ztnkdHaBhP6+JGKl2JoYWA5EqDxjzaW+QIPig0553yiGRB9Akl0TnKk8ionvG1EXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qTLxP19pVvB188JHRBi6HaF8sGMBJIGlX0W/4PgqUrA=;
 b=vCdMZW/OyUyTZpphWVCiH4hbCPiAX8MA0LJK0h3iuoIKYIBDmsnglrRyl5dX6DWrDAHqZ2i/GT6kvEtCMHsuicVY9YTaIG33CYyT0BKsONdefv//gG67D7/EZ59Az+tceeW0IoN9uRzt7X1JhcpsU5qYjjEzFyv+sR7hA7bHKxBpR9wc26xiWDsdlFbDp8Pf8EveuVFz0VuPCccpdcerGQBao+hEqzIwgojZRpkxzmKHzY8E1DHKG4NeFjSN+cvvHiqcdF015oMqseEtrDGlVW5fIFeE66jmZQvX7sFmOBsTZ2f8TRwpKLlUZkHb3EFtUDh7su2tUOmdjtQfLZAD5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTLxP19pVvB188JHRBi6HaF8sGMBJIGlX0W/4PgqUrA=;
 b=V4kFR3okDebdLFHADj1VZsaOb6ECerg/eWi21VvPvjvhl7n1nqkFakN7Zp5zApn7PaZSZcKW5lLoyXSj0pI93y6vlbWO6pSZCkcBGLTLAb2Ud/HlN3tDMo/sjysD/wmWtzwddJ0oFy3xxKSebnj6Svi78n+28LPcUzXliqh4a7U=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:59 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:59 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 21/25] btrfs: zoned: reuse block groups emptied by reclaim as relocation target
Date: Mon, 26 Oct 2026 17:09:09 +0100
Message-ID: <20261026160913.207909-22-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 49a5355b-e7d1-425f-969c-08df337b94b3
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|5023799004|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	8st+BxkJSsusKA4dpCd7dPu8BeCINRaGXwtLKmeqJYS/hnr9qBnUAFu/FSDalmbqxDu8JoI++65g1VxsPB8USCULBuJj2VIT5r1YlO+C9sncKi97mcsl86l/6xcd0qAoUHllZvWwe+94HFZiyOeD6dw/bkhLkT9kTbrywwAn9810lkpXrEam4Jjb0JU7kZ3n6FL2FRed8Y1xv9OVsPiUBGJiCrRiX1kF2cOxQFbr5K/T3o/c7xuZXIhVlj8Ey4w7ecghlbth8S1Doko/RHEMYE67omEl2n1QqY+LtNpqmusPbT2d8Postd9tnCPcuYjwfqO1N7H6E8LTRki+FJMa+dBOuw69LgDRy5z6kw/ohgtpGi76dbsOmfZlP+xRVrqY4UTb5CC1pG3xNyWcEDukyn5nNvgHPFyPbh62M0Hy1rDGawhnXYGWkvE9xMhDdmedvXyQFd/T60veeDCYR1820vJqU1ScZZSlUDZK2CyB81V8FZ8IVerN4L/UVUY1R7xgvDrKDJm5zzoFd2Fa+k75laONfcvX+1pthSLyKnUHHc7UgPCmjtMZLA65ElvLcs1vjyjJ2Uq5p2+MqGWISKzJ4Yf07NW2X/0nwWZ0aQk7Jm4Z2Yv8JeTiPSrPX4ZhptwJBB2XIpwtZI/+KOxcoy96Ow==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(5023799004)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/oOIsdLPkkcEuoLdgDb0FvpzgwAgmovYbhetv8wD+cbvFerwVZigfEkRxgra?=
 =?us-ascii?Q?/WMC7OJIznSe9vQZDBhxCcc/IBgL/lPk80kTV4Eu/o0o+U52SVuBL8b8Gpl5?=
 =?us-ascii?Q?trMYKQssV7GYJ+lf434SC8oNRuwZLq0ySQYBQiH/NSlooVE0X/MLW43anJrp?=
 =?us-ascii?Q?qr11/h1yj+BSQ1HWqNcenb45Ur3KlOvMe/mIdEZsUPpbmpV1i5TqOT3Icizm?=
 =?us-ascii?Q?5kxZpwklb2x3sdnvc1rO/Id+xH9gCDa4S1qK5WqFCCmR2O628QWPZnaCcdhc?=
 =?us-ascii?Q?6XFZogjd7qehNV5dgcm0zw8HxlzBYJBSsEYwuIxjun7006HDqPMs2SCO2Kfy?=
 =?us-ascii?Q?LXlJ9vhA3j8Zs9oDZ9IeIgc5CnWEErHsZNZgPBMMUE4d6KvUrPF/miFS2+0U?=
 =?us-ascii?Q?pMsEoUEozxhwBMohF/RTy/Zy3KBFZYFz+dqJI8yC0riob5/Ii0p/p1nAAvLG?=
 =?us-ascii?Q?H6sQDP4F47it8h0j+hdZVo0yHcrzyZ6dIEFsL9WI9gpJOGIXc80MUxElWUzd?=
 =?us-ascii?Q?pKZ31gncjaQZRlUeCIu/vRqE+BJzM2T9fatnGu1Aj9IeRK0Ze9rfPsiEOcKo?=
 =?us-ascii?Q?YegI4uKOFvUDL7q9CzcFMxuw3bwEjCxbmvJNOaRg9ZtZ6VgA/soS2meFMYfs?=
 =?us-ascii?Q?JQdaTXxhkhKLC8FiCGgJLHdZhz2cNClY522UAHECNmp/mUFkrdFfG8u4NTP5?=
 =?us-ascii?Q?bUBPQ5RUE7moSUcDsAKYS34EqQyBY7VlDhpDinHxoW0YOQPmvtM+m+gBd0pZ?=
 =?us-ascii?Q?4rKFWy+HkKbPeT8uKLYPSbYgXuM20uLqDLwDzcqhYvKpHNgJF/r3316gfv/W?=
 =?us-ascii?Q?zHniypAzUEHg3b37FEEzGxsYpMibfhGqAPVkzrj045ZeNc3I9Wnii87mguf+?=
 =?us-ascii?Q?SvvyJW5wxTSsHc3KUsfo6QtmNuAdOuU/AbkA2r84EeyOZNz0NflhuQLvWgfB?=
 =?us-ascii?Q?plhSYTQkkXwS7puzJq5oixJ6izaXMHewUclAQROhFv+TeZmFc98zuoOAsXAv?=
 =?us-ascii?Q?rP1IoUUCIhK3FqeLAjE93L0hhGNaVqcIFGcSZ8ebJoHO7gp7q0JFyvNmlXrQ?=
 =?us-ascii?Q?Pt1lLq20Pib4gkF4mPbSggFIN4fCB1RY04SEzg+Hk2r1oXwLLqqufF0YHoJZ?=
 =?us-ascii?Q?jo9uJbSJYw1emhXE0EWQEB+tM+dYF/u9+yBUNHwOX93IMjcIQijSEQfR9rTq?=
 =?us-ascii?Q?o/HLqFwQpIV7N9iQwiVW19ldp2SEXjZi17GCXOMrgw7wVJD1KR7Shi4xX5OJ?=
 =?us-ascii?Q?hjM6rgREfFWaREFPlgGh7xC693kPO/JYPLTXldfJKNnDRRXiDHOqOOK5F+mi?=
 =?us-ascii?Q?ne6oOh7yz+p3vKdthCD4Zk9+AJFxGgmAdfHbjK2jh3i6nF2tfxChmEf07vkq?=
 =?us-ascii?Q?p061zB9TL5kUBRh35Cj/T1/ePY5w1YQ6cKnATNwrKKZ+l7cH12GUXQ5VQ/u7?=
 =?us-ascii?Q?hIiiML/ljpC4pPMoe0TwqvCvXvgGt8zHYgXg1rGv/5ThYeP5uLbDSmqwailJ?=
 =?us-ascii?Q?EGuX5LrLdXSTb3Ly6I90GixjKANAbsVHna3nz0CzaUULTZXS9eJOjPVBxQz+?=
 =?us-ascii?Q?typnNvn0tKXHXxUZcWhcRgH3R7qg+sIVqY2YySZsM1761DJkA4o/IdChr57b?=
 =?us-ascii?Q?TL1GZG9jBNgO1ZhqtovXetrpef9EV7ZuaB9UFjoaWJKWGiiKGj+/BmjY4DCP?=
 =?us-ascii?Q?mvIsmvs2l97cwtsOEBiHvyWfJaRyRxrddE+gQfjFLFJf+BMM0OeJ+FEJKkYS?=
 =?us-ascii?Q?TWS1rBJFucbmno0D6b+1DlLTi/xkNLR1DqrnXbVrP52F6U9aHoWEPRgK2mBk?=
X-MS-Exchange-AntiSpam-MessageData-1: d0XV6t409s4rWw==
X-Exchange-RoutingPolicyChecked:
	Oe/UuZTs84wA0DMS4HZTBJ1FtLBE3czrjM8aDutxi38eo3Gib1fxhmpaUFu5/tyzIhj2KrDuj9K768tldirYyk5y5uZbIvt2nXakRo21NrG2VJ0VHh023x0I4hMThR42igCtPviQqNkQ7UccXYz49TQoVwH1w2LTI2o2v5GNLWx3LhforVp1dISa5g4ENj8p/9ZGOaXHY3SCuFlHdaQWoRkejwfFGcxcW0TrrYWvjl9JnFom8z0ApQOldUBGJ72kMQQiXJz6xmehCmOW8LhhIR5FTaKqJ13zc8uy1/7whHT2H054jkwaqEVyl1pbQgu4Zp9/Y1e5V3hqzqlfM4bKvw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EC5q/dfBj+2kfxBl0Cvep+9DJhv726lxa22eN5akxD3bs27HolmNCwLRAwVVgR02mD5KI2jh1aHvPZ1fyi6rjkr5RsX/Nn+UOk03ISBegDbG5H20eOXGMSfVGMfmJpPQKcOCEzx4Yxx7AVsw8zVJLQU5MVMgMqXywBSEnCh6xG5s8xCB5z7yqbIe3Rto1sbSrqoeWfWwx9/SRcwykqvwtp+UXYp5XzPBPDy4rh4PU/9/4FIIdVn90x2E8MurBoLmYb48TM4EA2Sdutsstvu6DgCNBG0l3ECqc24KkuedFQRHGqBCKtOp59iyWIGoaOudTfCs2cVYKBohlsaEeWw1mkyhbiLnkJWPwyqpoXHJ0T8JUtu8uUnR2C0/ONTC/Sgfpwa2KccFeOWBm3goSeqgLT3DAN2fFvyb6XkuHesxgg3CWQqSJkOd5p0HnMdnDnXoB0Ow3SpRc9ZwKjKd9NAwvcCpOLBfnwvXmjHm1JVduS5bZq94lghVhqnkP5AFg2ey/lnDp2qYg4JVeEA6yPIAl2W++v7HGal/IFS0WByP0L7fImDCXyiy0gphIcBfs+JvdT0gjFlIb64ZWV6bYXFe/8wJH4Fm8L5rTFshFc2u2c325Lyg9GS/D3RTuZR/VCVD
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a5355b-e7d1-425f-969c-08df337b94b3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:58.0337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NYW1qPfY5jPeppuFFIfTMgqEnQJ49AJBrFXBd5hp+fhY5NojR6Cus1e8z0ftvc6YvsnKyJKmUCAi5xEZ7aaf6lqt67N+VB/ar62jAdkKUAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

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
index 195d299c8401..a527dc1b90d8 100644
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
index 09449381fe2e..9721efec4e45 100644
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
index 7c28527f8b59..26177eedc010 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3058,6 +3058,79 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
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

