Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602636;
	b=wkN+DewkXamka7Gqir2N/N7r0ix9j+zzQcG7iMjhrNmechjWE2/a14IGKMxliSSJjxQe
	 gj1YJPU88RP6IHLFk4YHBwKmqw6CMddahurr9F6+dT35M/nuCYoigU+R96KKMZ5L6ohfg
	 NJErJSClY7SJGLyjFqm8BBKBWMU/aLK0FA07IlHTZhq7t+HYsmUoVdO9eK1SH4n68y/8X
	 RNEpj34a5o672XxM+Rhaf9+Kbq6y30N8pd04y2i8YFsl2NEfXVhV4appygfcJcBZrfehr
	 Zb47mzwDtNK0fdpZO4iSTp+CUTQB1YAbVEfIHWieIcuXzg/Oqcz4OuP2rhh2QEW+bWw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602636;
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
	bh=pCX1JvMaqC19TjJrdkSd6TUrgVg2V9YPzQAinppnfwE=;
	b=hNGdaCRTrefrWq0eHGuuZllt1AzQhq6Az5iZ7K90jLY4MhWwxR9UehK1InCSkxiMxLgK
	 HeKCb5PlxdnhMoDkgyHNGpqpSkpqolxAGbphQ1YNCufwQ5xPpCeIZHBJ+GAyiI7KC+cFe
	 zhlVd0SEHxsj0t7cNp0uuSxMyQ34BgiTlrBFy5hv+LzpVjPsTlXhzOqfUcqlYMtxfCo0g
	 l2DbyuJ3nIvm+BnDmmw11DRNgqxViPZm84Uhe2nkk1Cm9Frtep/3pobOJWMFzvsMGfdAw
	 +Bkpv7BX2+QLnR5rG1GMEBJ7Ia2MHxV3p8z+ehNYQasGgzhEvH1chGMMw+ecX5V394g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=pDRJWnl4;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YSkQrjHJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76DC606A680
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E76DC606A680
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=pDRJWnl4;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YSkQrjHJ
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602635; x=1827138635;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=QDkU75Oc2u2eDUJa9WfeAQY5qdD1tO0x29mr99GV448=;
  b=pDRJWnl46exV4QnNuXG7dHU0TzOwmXw+TM9rNOYClH0c2hL+9AYYR+ld
   ++ZdBIgNR9YVlnj/Hz0nVuFUTg1Cz4pjoxxf+XpJ+RvuRkacWTsYJtg/0
   TvLm/eoK2Klh98CsvcPoL+Cgw4u0le36o7ql3fnuTGrUWGe67Ao9ggUd9
   yU90wIsZlbpILXE1SP4fPMTREWTNgYGpZ7KiamhTNE7M1FIMRCt4GM1rm
   8UiVXQzFt35ob86tYNs7Vw2nM/WS6aXtzDzYtvOjUCuCC8iI4xcez0d5K
   bxDwVGcMOpqNDHRsx//NCLiGYgrSB8JuDKCQLZdELsPKRCCbbKUbZLxOl
   Q==;
X-CSE-ConnectionGUID: Xa7Rv/6ORB2oV00fVXLE9Q==
X-CSE-MsgGUID: ua8Oo3q6SXCnfnH5ahL1ug==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662164"
Received: from mail-westus2azon11012053.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XY6sYmcwIBLqQhtEjCkqJQX2IunJnTigmEoA/8wo7BF4lNY6rqoMh+IBKiJhyAXdVXf69iOyDKc+C0mjXM9BQ00q+SbOSEmJAhX0MwBCHJneOgNfrRsdgo4D2hS9mbmB3+gSUOtsVbqc5V6cY4+Kphw7rNGGex4rV4gNkmLAP6I5B6ah812dFMjAZtaKjLLurNty8CqaXDIDHrmBwKSpoKGLt4NzBuPGxIGFZrZy0GmexuU4y1LsDZ4LVOkm8qxBQJiiIsLhhhYKeU43Fpl5dt6/sLc7Ngsg9zUNaGr/iT9vbpze5tv8QTmFKILD3R0ZmqTgCELg7qXMDezQPplFyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCX1JvMaqC19TjJrdkSd6TUrgVg2V9YPzQAinppnfwE=;
 b=bbTsp/TWBfrHBIeNaeucEwvJX/2ibftjHqKJOc+rk1FIFK4QA6xVfKMG4r7oGTnOBnZypb3bFayT0o8yPdPZ1oDlJ+U3BVs4AYEa9tsuN+uY1+A4mnSpg7rNOc8O7uvbbht5AhUErvgToBURPnz+xDwY5ncEl4pWD+ruxF1DR+KzYQSEYuuwTLAqrmrCuNjbp1A0XPlJRz8xoT3ill8gAHUvyA02x/yJhcv0zRwxAJRxqWsP95QuNDqYF/DB/7lc7qSY7myQKlMimDNfLlBUiZ5WIADbWs9jhfda0N2twchuSDSabydP+uAwiVW60EPUaOEPgsdUct61AT2sHWVTzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCX1JvMaqC19TjJrdkSd6TUrgVg2V9YPzQAinppnfwE=;
 b=YSkQrjHJnPT7kc07sriVq/tpqPYlN2eTUHY+FB64h9m92AlQhiGPLYxHDUWn17Zjkx14zsYs1N5ZD6VGwbQsXdYnan1G/1RT1T5udd65SEAvNEW+EzR2W7yEmZ1J2nf/oGYMM/CMTpCTfrKJIoVKc1dGSatrRJ9iNl1+QJproXY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:31 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:31 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 08/27] btrfs: zoned: only take the metadata IO lock for append only block groups
Date: Wed, 25 Nov 2026 11:29:37 +0100
Message-ID: <20261125102956.266389-9-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: f72334d6-f566-436a-01d6-08df4adf218e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|11063799006|261022105027099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	nHpco6UJoCY3DcoQXu0XioYld6l+dtVmUKrv/6KDZfYWiGnoxFqlelVJ0y6D9ICMk9dQqP2mz5+C7pSYUGXSyJ+SLPhOR5kqJoe2kgtzfNn0TDJcTbY8Dwnaelhb3kATh4wWX7JRcZpEUUNejjAOz2tiJLtsr5P4zY/vLTzI/C7HeW1b54aLybJ78LyP2DTTxIb8yCM7fLNATHNvhy6N/ieYIlB4upt9IW9wVNKrjS9obUYnc++pNuWVyO8xrjROFwsny93gaZUka3GzVniUC5WRMQRDx8FunvL2MBAlpbDRpZnSmA3Usb91X+S3E20IDotERW80Jw7tztCdongIWpu8dhomveSRnfSi63dtKu3gSugJMrA6qBlOVbegC71bazN6hzAoTNIpqyaONyyhexpi/AScucKnVYZm6LiHIQ/lssRCP9eNnCsgVkWyL5/10kz0qK6z9wqzQOI8tXkACfM4BZQilQCStr2TcqmP3ZPIiYbd74SqNmkz9GpNcVoM7wLfj3YRLLM6c2OQjuEDnh+AXz1KV3cWPNW3SX5SetqHSCz1E9FrUj9gMh731oYt9CWmuQqnYPMgiZF3RMakdQfxivQs/ZETH08zlrQjA+U9a24QkqxW73IyQmHr0TslVg2DqVP3tlbaD5vC3oylg0JI16wBWmcmy1q00P3IFJw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(11063799006)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UGmCg5V/WqypmnA7yz0i0n6Pugz1qjSxHC/UNDiax8PwacTBDl/RBeqssCsq?=
 =?us-ascii?Q?IsRt4XRX6Md3qjPHtvrAm0D4OJXmKN9XBC2daqkV1X1OSUe73Kd7cxjnaEXE?=
 =?us-ascii?Q?4zBc94DT9XUYhSBzdIoF0m+nHrmi5+ACiEfx7YM8NhPWmxN+3FwKhGmc+qmB?=
 =?us-ascii?Q?ny/bcQUJtFMtHW85bjIwCy7FkZES1IIbm7X48x2QhjMn1xsoqduxgvK4arU8?=
 =?us-ascii?Q?p+57zs7G4Vk0BLn1WJuXxO9Ip26NjkYYieENCae1ofq+5k2aPQKzj7FdaARi?=
 =?us-ascii?Q?sHcXvv9lDtbOd5f7joXy94loXYJbCEMJ/wuz3qPHLQqeDeHmihWy4DrCs4/x?=
 =?us-ascii?Q?G458bNATPX2YPurj4ZqjTWViaLE4mH/xR7luNFAFLuFmx8dvSKqXvq0JhIBL?=
 =?us-ascii?Q?lJMjcHha4Lt3CWXbcd4/6Bln+DwIQZdrP1YwoG/rvF04ekNQHn9DAnMiAQwN?=
 =?us-ascii?Q?rjyA6WB1g9f5Muc4gbcRCHaaIq87jN2PB5hnXFtYALrf1ib5sAtHp7lNaKKM?=
 =?us-ascii?Q?y9MQZJ4Mq7vM28kZHuVoVG59ARIDa/NDjv7ilRIGVivpLHzwU0YMEkTddz/X?=
 =?us-ascii?Q?jbOlNJKHE2o7LOj9yBfkEWJnv1n/KzJaoHkZYyR8rxmtDVdgX3WQsGpgZ4rc?=
 =?us-ascii?Q?CmzA+KzXMbJE84CQh+ScWQSYs1EBaWomIg+qKq8xZFpq+3lXL8j13haVurTS?=
 =?us-ascii?Q?07fP7BiOXp7sK6aRvOCCiSosCRpS6xpGH14R/aRalrf8urDyjdduyQq/dJk5?=
 =?us-ascii?Q?rGKN7/50E+M72PrtLaVKdG+BrEqJwnTq9eprTnfGrolsIcOlSVOWCpmffq0n?=
 =?us-ascii?Q?z4v7x3wG+wTRq37ghwnKZ9MNiWkHOA8o6CxqGUp2nm5BBh359pnYLW0A9DCF?=
 =?us-ascii?Q?6BbhcRS6s/UHAvI9D+6/OlwfA2kr0hj2KkSBgLCAsNorw0dtZ68wZGunF74o?=
 =?us-ascii?Q?7YhXgUR71H1A28PvEN4x+FG9PlYgWjXVCoz9g7iefEQKoL+m/Ri1MY9IJQlh?=
 =?us-ascii?Q?k/ht01dYJ7rLvfiwVI7IJUKeEQJXhC5T3pSccu5I0IyxL81+4HAZsUl+IK8q?=
 =?us-ascii?Q?wXbjzsyw5KlYd866DWqlyy8HoaXyJfbbEiCK2DLxadbmM+Ti0oWOjt7BMAxt?=
 =?us-ascii?Q?11UcqEexPkukBvj+TuleCZXEmx1BWENgAvWpwYtliCcurgdr3lcMLTWnJUl4?=
 =?us-ascii?Q?tMMt+PSyyP3T5Yua9Us1BvXW00iUBJQZf4b57ORCYO9fhVsXQ5yx7/Ngb42F?=
 =?us-ascii?Q?GByojXx8S1r4r0q1anmMKuh44YNVa1ZzvNohqVumjxadUJBRlI3ROmPdgZYh?=
 =?us-ascii?Q?PawukNW9SzO7SzZ4H4oQ3xx6JMCM0V3goW6+vDIT3fLkHddS7wTpP8vnLp3p?=
 =?us-ascii?Q?CsN2t0LVvPZBh5/9ftbvQpKtH2WqHE+fDDa3/n7h/gCw9/djqB2rc1Sm1Adm?=
 =?us-ascii?Q?pvb1vLYSQiZp+vT4QJbDC5+FFMMeUtnhCWCHQF6D24WbQ1IpL9GYLwCOyOjx?=
 =?us-ascii?Q?JXq67XzVBEfQPs/S0BMwyMrJdQqpfnXSAAGoFzkTyDKOesgfv/OPhRM7SpLG?=
 =?us-ascii?Q?q45bAWgQBSBcPPVA5ZCHC9l2Frm2bjOPiCitN458Fyi+WciTxGv0Dh1I2ky8?=
 =?us-ascii?Q?62u19OTAnRFSXvQ4wIXhlJMlVR5B4/MfpRQwjvNMln9CP+j2WXdd6x1oJV8C?=
 =?us-ascii?Q?3iRONePzC3RioiYmC/dLbXd4K7g5cSG/5QQwIEpBN90vL9DSNjzSqUhFJkyj?=
 =?us-ascii?Q?9nwwPoU4nhyuX+dsFsN6O3JoHPV4OBfHHdyBa4iDe9fjSQvoo8sEsQcDPXPZ?=
X-MS-Exchange-AntiSpam-MessageData-1: xrb7gh3Epk7cnrPlHlqm1vpiuzuHUutelik=
X-Exchange-RoutingPolicyChecked:
	SE2OOb6AInJtfB93mFQpcYuUaJk3F4wKOooRY5Sg6boHk2REVwOysC5KqHlCrDl9tti7S5xhARS0OtoHpWWtSti7YxHEaZRPKb9Ej9AOl2df2Op6APNzMIHT8Vmj+VXIWSe6q57z03FGqEXUx6Doql6alHCW5c++gwefDkyHzQBmLw5H6LKubpHARURve7i1umG3xctzhIwmb5/A6iBqgsSG9bWS9tg4mC5+9lg3SlPTHC3+6Xuu8gHWtkn25NqyK7bcBtMM/LOkUvZv7wUPZC+5JEH5njuF5QNGYvApNTjbIi6sybmgDOqZqne/ii62eL8MTzqcFSy22RNfodosKQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FOfsOV3EQyTG4dyxAsmsyZiMnMrnUet6kYnnGbQbokDQBlJMrWtOOCv3wWfXYBYFqNRCJhMUqUEBe4CXgoPReIo70rQX2XDDgLflYXEb0+CIWhuhkrci+/VtBmhpZBV9QSFrA/8aaBZa3qTiDMOnx7mf3qqN3+KD7L+oSO+Tp/nDf8Hh96lAr904JIjhqIe0qEG5IunYwL89aYa3pNFraSiZh4zH8lY80lZLuG6CS7QghskKWyjEAsOKADOFswaPe2+Jgxcm63L716EtnTvoX6rhgwtNX2AodYKTmbR21yKkTibOH8hhg6aHSZysIqwbdEzJv6YMMvzPxC2n4uPdk0fOXXZAYO+CXSFquuBO0sCysNjlbHedW5CrdNF0Tbcl4cQAz37FzZdCCSjUwKf89ii5rfvsHHclUCP0/8pSv8V3StZ+G/Mv7ojFOKBFCraELLwWOIcenTX6mXgtca4jHjiqprr6rOFfGi4tPQ49y0dJ7XmbJG870Rh5lpl4E5RNXh5U0xKcaxHKrkaN0LPVlO3Vuql+AlWJ1ubbZoynsQdAZ+K2HvaKGYEgV6wLrXabdw/4fgPPICASwLzx/WM8sk+36+iDTwZ/ZcfcIg9yRaHRWjTJeev0MbUcCrroNAsg
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f72334d6-f566-436a-01d6-08df4adf218e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:31.3686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tT0tRG6Rc2q9usTR5xoiZqKjyjJ3NHiHjb+RHrh6JjT+NLucRggYB3oAUHnzR17sCp5CyCSK2whkejPqQ1ovLH5UcLYGEmcKeswV5CMb5VY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

fs_info::zoned_meta_io_lock serializes the metadata writeback against
the zone write pointers and protects fs_info::active_{meta,system}_bg.
Metadata in a block group backed by conventional zones only is written
in place and in arbitrary order, so none of that applies to it.

Acquire the lock lazily instead of around the whole btree_writepages()
walk: take it on the first extent buffer that lives in an append only
block group and drop it when the walk is done. A filesystem whose
metadata is entirely on conventional zones never takes it at all.

To do so, split the block group lookup out of
btrfs_check_meta_write_pointer() into
btrfs_zoned_eb_write_is_append_only(), so btree_writepages() can decide
whether it needs the lock before writing an extent buffer.
btrfs_check_meta_write_pointer() now expects the lock to be held for
append only block groups.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 70 +++++++++++++++++++++++++++++---------------
 fs/btrfs/extent_io.h |  2 ++
 fs/btrfs/zoned.c     | 40 +++++++++++++++++--------
 fs/btrfs/zoned.h     |  8 +++++
 4 files changed, 85 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6ba202b312b5..8b58482e62aa 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2547,16 +2547,15 @@ static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
 /*
  * On a zoned filesystem, write out the currently dirty metadata extent buffers
  * of @bg. Used to flush the active metadata/system block group before the
- * ascending-address walk in btree_writepages(), so that walk can pivot the
- * active block group away (finishing it) instead of aborting the commit; see
- * the caller for details.
+ * ascending-address walk in btree_writepages() writes its first append only
+ * extent buffer, so that walk can pivot the active block group away (finishing
+ * it) instead of aborting the commit; see lock_zoned_meta_io().
  */
-static void flush_active_meta_bg(struct address_space *mapping,
+static void flush_active_meta_bg(struct btrfs_fs_info *fs_info,
 				 struct writeback_control *wbc,
 				 struct btrfs_eb_write_context *ctx,
 				 struct btrfs_block_group *bg)
 {
-	struct btrfs_fs_info *fs_info = inode_to_fs_info(mapping->host);
 	unsigned long index = bg->start >> fs_info->nodesize_bits;
 	unsigned long end = (btrfs_block_group_end(bg) - 1) >> fs_info->nodesize_bits;
 	struct eb_batch batch;
@@ -2591,6 +2590,43 @@ static void flush_active_meta_bg(struct address_space *mapping,
 	}
 }
 
+static void flush_active_meta_bgs(struct btrfs_fs_info *fs_info,
+				  struct writeback_control *wbc)
+{
+	struct btrfs_eb_write_context ctx = { .wbc = wbc };
+
+	if (fs_info->active_meta_bg)
+		flush_active_meta_bg(fs_info, wbc, &ctx, fs_info->active_meta_bg);
+	if (fs_info->active_system_bg)
+		flush_active_meta_bg(fs_info, wbc, &ctx, fs_info->active_system_bg);
+
+	if (ctx.zoned_bg)
+		btrfs_put_block_group(ctx.zoned_bg);
+}
+
+/*
+ * Take fs_info::zoned_meta_io_lock once the walk in btree_writepages() hits the
+ * first extent buffer of an append only block group, and keep it for the rest
+ * of the walk. Metadata in other block groups is written in place and in any
+ * order, so it does not need the lock.
+ *
+ * When writing back for a transaction commit, flush the currently active
+ * metadata/system block group(s) first, under this same lock, so the walk can
+ * pivot the active block group instead of aborting the transaction commit with
+ * -EAGAIN.
+ */
+static void lock_zoned_meta_io(struct btrfs_fs_info *fs_info,
+			       struct btrfs_eb_write_context *ctx)
+{
+	struct writeback_control *wbc = ctx->wbc;
+
+	mutex_lock(&fs_info->zoned_meta_io_lock);
+	ctx->meta_io_locked = true;
+
+	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync)
+		flush_active_meta_bgs(fs_info, wbc);
+}
+
 int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	struct btrfs_eb_write_context ctx = { .wbc = wbc };
@@ -2625,23 +2661,6 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
-	btrfs_zoned_meta_io_lock(fs_info);
-
-	/*
-	 * On a zoned filesystem, flush the currently active metadata/system
-	 * block group(s) first, under this same lock, so the ascending-address
-	 * walk below can pivot the active block group instead of aborting the
-	 * transaction commit with -EAGAIN.
-	 */
-	if (btrfs_is_zoned(fs_info) && wbc->sync_mode == WB_SYNC_ALL &&
-	    !wbc->for_sync) {
-		if (fs_info->active_meta_bg)
-			flush_active_meta_bg(mapping, wbc, &ctx,
-					     fs_info->active_meta_bg);
-		if (fs_info->active_system_bg)
-			flush_active_meta_bg(mapping, wbc, &ctx,
-					     fs_info->active_system_bg);
-	}
 retry:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		buffer_tree_tag_for_writeback(fs_info, index, end);
@@ -2652,6 +2671,10 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		while ((eb = eb_batch_next(&batch)) != NULL) {
 			ctx.eb = eb;
 
+			if (!ctx.meta_io_locked &&
+			    btrfs_zoned_eb_write_is_append_only(fs_info, &ctx))
+				lock_zoned_meta_io(fs_info, &ctx);
+
 			ret = write_meta_extent_buffer(&ctx, wbc);
 			if (ret == -EBUSY) {
 				ret = 0;
@@ -2684,7 +2707,8 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 
 	if (ctx.zoned_bg)
 		btrfs_put_block_group(ctx.zoned_bg);
-	btrfs_zoned_meta_io_unlock(fs_info);
+	if (ctx.meta_io_locked)
+		mutex_unlock(&fs_info->zoned_meta_io_lock);
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c55b37cb24b7..d7e34930a43c 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -143,6 +143,8 @@ struct btrfs_eb_write_context {
 	struct extent_buffer *eb;
 	/* Block group @eb resides in. Only used for zoned mode. */
 	struct btrfs_block_group *zoned_bg;
+	/* Is fs_info::zoned_meta_io_lock held for this writeback? */
+	bool meta_io_locked;
 };
 
 static inline unsigned long offset_in_eb_folio(const struct extent_buffer *eb,
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 554c383adde1..a9d86d5c0204 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2273,22 +2273,17 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 }
 
 /*
- * Check if @ctx->eb is aligned to the write pointer.
- *
- * Return:
- *   0:        @ctx->eb is at the write pointer. You can write it.
- *   -EAGAIN:  There is a hole. The caller should handle the case.
- *   -EBUSY:   There is a hole, but the caller can just bail out.
+ * Look up the block group of @ctx->eb, cache it in @ctx->zoned_bg and return
+ * whether @ctx->eb has to be written in write pointer order.
  */
-int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
-				   struct btrfs_eb_write_context *ctx)
+bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+					 struct btrfs_eb_write_context *ctx)
 {
-	const struct writeback_control *wbc = ctx->wbc;
 	const struct extent_buffer *eb = ctx->eb;
 	struct btrfs_block_group *block_group = ctx->zoned_bg;
 
 	if (!btrfs_is_zoned(fs_info))
-		return 0;
+		return false;
 
 	if (block_group) {
 		if (block_group->start > eb->start ||
@@ -2302,13 +2297,34 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	if (!block_group) {
 		block_group = btrfs_lookup_block_group(fs_info, eb->start);
 		if (!block_group)
-			return 0;
+			return false;
 		ctx->zoned_bg = block_group;
 	}
 
-	if (!btrfs_zoned_bg_is_append_only(block_group))
+	return btrfs_zoned_bg_is_append_only(block_group);
+}
+
+/*
+ * Check if @ctx->eb is aligned to the write pointer.
+ *
+ * Return:
+ *   0:        @ctx->eb is at the write pointer. You can write it.
+ *   -EAGAIN:  There is a hole. The caller should handle the case.
+ *   -EBUSY:   There is a hole, but the caller can just bail out.
+ */
+int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
+				   struct btrfs_eb_write_context *ctx)
+{
+	const struct writeback_control *wbc = ctx->wbc;
+	const struct extent_buffer *eb = ctx->eb;
+	struct btrfs_block_group *block_group;
+
+	if (!btrfs_zoned_eb_write_is_append_only(fs_info, ctx))
 		return 0;
 
+	block_group = ctx->zoned_bg;
+	lockdep_assert_held(&fs_info->zoned_meta_io_lock);
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 3c561f6ad228..5195d3d6f541 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -81,6 +81,8 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
 void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
 int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 				   struct btrfs_eb_write_context *ctx);
+bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+					 struct btrfs_eb_write_context *ctx);
 bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical);
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length);
 int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
@@ -221,6 +223,12 @@ static inline int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static inline bool btrfs_zoned_eb_write_is_append_only(struct btrfs_fs_info *fs_info,
+						       struct btrfs_eb_write_context *ctx)
+{
+	return false;
+}
+
 static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info,
 						   u64 logical)
 {
-- 
2.56.1

