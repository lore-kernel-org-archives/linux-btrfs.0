Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941976;
	b=fmC911FLVP3clpnVs0N2X4cRbUse7CRN1tZxJseP3KptKrRcj7nAks5CL1OLXZmOyr3v
	 TGM2DMyEikXFyNRcDjNhKISW/o9ujWay1zGs2Z/hQcHymRJVWtExEzmTZcNptm4V0fno/
	 jilS7o8qzLrnA7iLGssDN6aOXQqC2g6coZqOVda1IIc4zL2ugxX/sMq6GeaPu06FOajBI
	 PzkjoNFaBpCmMAjc05Kg9aphQXQPRgnDVbUMN7XRWg0BttBEGma++e2E62iEtv12qExez
	 6exZYIwBuoiQ3pr5sU7mbvAi7GbWS8NGMKM0GiGsvGdLwov3PIV0fw8Jhpl0HaJhKOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941976;
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
	bh=uCmw5G0FmaeZI35vdGrCCzxtPBmJwCdFWvWBfh8Yd5c=;
	b=rsRSdJeVLQ+3AoK7kP9zLOwQWng0beu8p/vQ+vZmSs4SgoCZ0O11aQ4sRFOL/9HGp536
	 oRU8tjjd9rIVolZkYMXvHTu77vo5QONOb/JotTmRci0y0ZMUl1lezMMkPMiEOoLTB+U5N
	 mBQJIMJzQjtm+1GV7fy4zSDKW8BoYvhgV3MnGzR47RjLMj+fIG399Jd9b6GqZS+pM5uC/
	 +Oyz6b/tGqNZrXJ2ifBSgu6qh+/h7M+Y37zi1Ey3kw9c6ZJtcJvSiMY/Y3IcczmlkaQ8R
	 pME1Hk3aQo3thmGmoWcBHGMpsXKnQonKXywlar6I1K/Q+4Wk7RvNQf+fc865VEJ/xDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=fdpWjfZX;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Ph+wqFxg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75761606A337
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75761606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=fdpWjfZX;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Ph+wqFxg
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941975; x=1826477975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ouGjzmCA4bEcmQ/xdJPiODKQVZMF4ABXWt0Myi7Mgl4=;
  b=fdpWjfZXAjcQCBYnTNOmDbxKLDgChJ8CZWt4ekFyyDzGN7NBcHVxsHfV
   Qp8Wl6guYAoVenoTOkb1CnkLXHmKU5kgJoHP4XXZocDCRyEoX0p6WFLGk
   St+1oHOc8R49n5MjGQ593l4R9liXggCE+Vln6cmQqGK3hkdMOE+IRRHvM
   1sBkkp1XEesWUGqp0d56xJWGzM2V7fVPqjtq0ZXqAZmQngTM7ymRmc+o/
   rHo+HFW/4FKewtvHRjE2ONixjtDYL0SB4FWZizrZVwVQoSFgZaHghyICy
   lSIUQxzzQwSDMjewkNZyn4DiTf2QCifWhwznOHHbb7JqInymfNdQjqVkG
   w==;
X-CSE-ConnectionGUID: ppQ0btCXSs6tNJsHG2X0NQ==
X-CSE-MsgGUID: ohUqDPcWR3ewT2V1bSDCjA==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="156880127"
Received: from mail-northcentralusazon11010029.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lIeTV9Rrh72YsvylNfAtY4OEXzqjGscyYmIcVpVhksn/1OQyFG/GkxI/IHptt8Tvv7qgUYbulTUVEiINuQqAo3FCGLoBpWFrDUOUg92OwGg2xWp/UEUwXaAmTiq0+8B/sv+iA6Yy0mWOTJ7dToqwh7bZhLqW1gWkIm+Z3UXIwbf4fUbPABYDkXb0CWT765JcfkPPoUFfdRGFFCzj+qqwOAMS6N88K37OLXb8OKXL0CfNgWkC1dXLkkU7D/DQe56KraqiZTITJ1bdohAShj7YI8RlQhkU28FMxWIdPu/YrA8pmJQz+V8UnONawnTOaPbjP9hBx0mcZuQEQlgZVN+LOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCmw5G0FmaeZI35vdGrCCzxtPBmJwCdFWvWBfh8Yd5c=;
 b=Ir1pQ/iOXYmxGe29N2rmKwpeWt3z5b8KbVAmUH/TKQ8B727mbxCkey+cmYlV42A/YmPVg+K7F/RxufwYntrXJkX1PPQ0DpvaNMxgIBFrRA/bBtax0QjtMXcX6HkovgI017HI1/RKHG3zshR2YQDnh0P6IFHxkK1RWmCu6trRxgbeZABW+k2xE6n4kUGOowoL9TQWVAk+sau0XQHBs6r78scBgRWNihpiNzMNSGIyuYHPxJXbv3esggYfr86qOGfeElzdacKvZzX7GVMAaNOiS689MtzDr3p/lB3gUaxoNtasHF+Q9150rxRTxv2faARMNZhzlCUGcBFfSHVEU8sZnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCmw5G0FmaeZI35vdGrCCzxtPBmJwCdFWvWBfh8Yd5c=;
 b=Ph+wqFxgeRQ7KwskJrJR0CjIjeOFqQtbXH40gaopzhkijHLSINAGuZ3WlrYqlLTerjpDy7TVsw3UECc2mNfugNT8fIUCvLpfBdqKcfKsSQZzQWxf6BNLKQ7f0xnwNzFCxn+1pYNWMbwS1eLGX3BJh+0+gHs6seuzAWo2wYVxpp8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:31 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:31 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 08/27] btrfs: zoned: only take the metadata IO lock for append only block groups
Date: Tue, 17 Nov 2026 19:58:31 +0100
Message-ID: <20261117185850.4128157-9-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4223c931-a896-4f03-a522-08df44dce732
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|6133799003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	EPm4u7g+fEhfBbbtsVl8WR1hUoe5Kq35+McTcQH0JXU5YXS8Hgix3MckLGGJsjD+2nVJKmCJmEsJo6PUyIoI9K9fpbwHX1dda+YncSHmU4WbgWEk4vrqKElwwrPDkQBV6Fy0O1Ja45VWvBoCOl+b7f0+9NflgnH7yGQ/HWg9/4spfiGTkxP1BTVJ2d2QE2/1OLjmsqjwfPvgIEL+c9m+tKavEFK/7mGDv0Y3sjrIFFv1VGxno2PQqDyk97c3eLgapeI0nrmcjC4KGn8OPdnTKSwlRP0vPhSEUE49FDQLGNl7h4H/3m7OMxz17ZuNkUl+5AjxP8Z8xeBwDs2FNX/hBNGAtt0EneaIAQIzVXbceAQByj1he5YTWSfijvgVCEPo29SL2OtnSckPM8hBDobcvORoJZUn1XA1qo29Fy/UHchAnT7LjBwqZBZeSo7cyU8DP5L0yyB5OAOEI3b67/5p8gl991LKOVX2KZW4KsqV7SHeYcE6i/QlxtUb2A20oa2Yii3hHOAP8hsevOB7iz8cOdOzFcukmmZlKMMbk7gi1UQBZr+QmRUOYso9kcjkJpUdxjqWmz2upRFsb1EWxAnfnUdXPThraPLgM3y57lJxAJ4BuCega4nLg6nhnA58mcqsTQI7R5eOpDqTl+608Y3ZzyhdZW8fz9v7p8kUoZHUImo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(6133799003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+HdyxAp7zVFQ1H5ZgPNJqJPUK0G94aw2feXizqQQsFWwD2rKJU98Kfnrrp7s?=
 =?us-ascii?Q?Zosj5TDVoesR60eHUHqTNE80kO2TIiwQAcsQdGwhVs+3ktER0eByjKDdu3Ux?=
 =?us-ascii?Q?VDKz/VysDS2qegg/qk6+ZIpVThNC0nbdwfoJQxSaMhkYHGO+w0CZLvwap0N9?=
 =?us-ascii?Q?kdLYHCDSBxcMIjnzAzVmYqLjM5yARQ+WmIVB/YtZ//PL+ith9xK8+RfjIUb4?=
 =?us-ascii?Q?TM8Ij0jMQfq3WUNnvM29rc3f72vyTKipKRXVp0BcxWqrTHix7n9gg/RVLeGM?=
 =?us-ascii?Q?Hg45/fvKdxpcvQfgaS5gA37T5Foojn43WndZc8yyz7wmTipRYi0mu3VWvbwu?=
 =?us-ascii?Q?VSROnCL2vnTwVpVKAHYEf2NrlUE7XglLfUccUCZ2wekdI9SPUcfKUEeD2XcI?=
 =?us-ascii?Q?0FTRvWbiZDKdjdvHC7eLCYvzwOQkuFBK5PiIKaYUXkYgse5B3sDpcbjsx8iZ?=
 =?us-ascii?Q?BT0OZb8AteipKaLYWd6fFwvxlpj1s8aN1UkcEwGBmit+Tr55ylzjU/iwigDu?=
 =?us-ascii?Q?rYQD7O8tvkFgnRi66ybN6LK/jU7/94V4oajH8TBzB/P7PJDQlv5r2V/uAtq5?=
 =?us-ascii?Q?+iyruuhiiLom8Iq47Yg0PksEA+5XOiJLhl4nfb97c9gbqIzmsbc3zOFrNCBC?=
 =?us-ascii?Q?h9FbPpRfkcLvq/MU2sxvxwWsGSlUYj8ksdc0TrQZMfZZGrHGsta8PpOzV2sK?=
 =?us-ascii?Q?7HwZN3GTADhhe+PNmVBQiug5sMO6fNQSHfUgnUEFK1g1YR9juPpex+yYtEfx?=
 =?us-ascii?Q?m581V14G59MT71qsWtx7TUSYrr2kHnU7Gxo8Lw8aBqwxeijIUFvkiyZnxPxg?=
 =?us-ascii?Q?F3CyBIi9VOQzkolNRCgEM5u9usEtN97SH3jV3hpFhf+F5A3jFCVhhhub9kXD?=
 =?us-ascii?Q?ZQN+/t5XFWsVaG7IG7E/EmUlrQOqSr0NLG81DKvJYDa7rYJSDDAWolvo6V3s?=
 =?us-ascii?Q?uQYFsz/hBaIo7H7AkKSoepOYKLqJfSHUQ4a6AX3haMAHWk7t9uUYUjSe2Oaf?=
 =?us-ascii?Q?Q39k5lOoZWJpsVI19kliQ6IpzenE/R6sC+ujp1xmGIeHDB13Kc42BuULwuD9?=
 =?us-ascii?Q?3OBCYcI2TAIX9CAcTOcJvkiSZXkrCuXRhMI6OegFL3yzbU1/DzDCJa5GV4Rl?=
 =?us-ascii?Q?B9QJVf3Q4GorPwMpaV245mwgzyj6GE+gwwSHOMTK/e/taA5M7vl2usHQ5UoZ?=
 =?us-ascii?Q?ulXTxqFRbwfrlbipW73QmyvMkMI670znEHfCX4NoRIRjpJf7rj2BY6rlCW1x?=
 =?us-ascii?Q?O80uln9hlLvQeLOP/93We6NCV6IdtMVXkSxWl/I+F8m5LdJcHenjUkD0+Zvw?=
 =?us-ascii?Q?Xc+jS8hHUgKBGZEh+RFDjGTk8QxORABK1bTiARc7+A2qvST0a844eWFISjLs?=
 =?us-ascii?Q?qKQTVEX3sTASR5e8+xbPC9SdvimsGlfuUDZFipyTEsBM+qimFbrL7OJ+Yj+C?=
 =?us-ascii?Q?AoAPsTox1wlnkop5iOl30KSEnKGlE805FyDYp6fGDLMFGgXqvYVTxkpnVgsx?=
 =?us-ascii?Q?GP31D0acaU5HEHL2dHcf1/9Tvs9+3Apguji9hzB+DsKQ/Hcsw8gYkWez8vJk?=
 =?us-ascii?Q?YCXInX6fcqCkQqlHoa2WAHjn3xmpfK9y6aSqaO+wB/eY1eMMe7xJKt4BkMNm?=
 =?us-ascii?Q?gOV5tDGfVg+jkzAhhdrBQq+NpbpzmlMuECR8ZJ/7vgHkgArX1bHL85QUY5Cb?=
 =?us-ascii?Q?dSz7kKhvirZyFVTCcB5Kt7NbXISRiIQVtfzhYPhNu1ck4Z1zzdU80Vc3b3mP?=
 =?us-ascii?Q?7LnR0QggRKWpopBo4tKw0Vi5/+FCY7GzC+pm9vw8fPnRchIoMThW0b8K/pPy?=
X-MS-Exchange-AntiSpam-MessageData-1: P7myYlVtSuFcX+t0X1VX8Hptbxnl2vs+D8U=
X-Exchange-RoutingPolicyChecked:
	tiqRybXWjVOW2pwIhufGyl7VQbsvNGXQYDW0oy27OuLNGiRcFCBjeqr+BgtxtpaCpk38w7ooY0USnzTvWlzD7ug6i/uGEK1vbdmU3R4rahjB+4AZLkRs7uobBZ8wtX5fvneQkDXmLZMWC0gYzZwxfHCiI0AvFOHRlEfIdiA6qOyZkqdTbYBnoeG4/50zR/xxlyBrEKyubIHsdgoPR698ifqLxTmJA+1NGXw/jpJyxFEb/fEzMQs64wZYr6fpoJRRzWBwM1tfA5Hx2dBNS9WxjRnyoL3aRkOKVXvvL0znMZWqaZvlufCsb/Zgg585+9PEWs3YWq6EclbKKgjiGl+yDw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p5KMn1hxrylE8VnliOr1vg+qeDwilLS4ILGoDpNVDqK49aG2pE9xVF4y3aCHv5M9RZ2R0fEf1V3iYPZlRVNAJc9qBf4xfPEHTk1eivMNNsx3Jg8jTXMf007LbKPAl3ht+9tWvg7vUkD/U4zaRQUBkEmL3T8TAmqeHTv6Wy8bd1WYQBB0yjkF+xHdxBDwhG5SShFfiNF9hjwHC2BJT1UDtz1M+bSGF7lZUYRpzukB76uryep6ZIA2x50OPy46q5w/y3TSGcZG69fXOoeGML1JxPnVobEgME4gF6JCOAL4+H1YhRVHceFJ10uT9PkCduSXRzlsjVnpgIPWYAJeVnJ1e5HQnnVdCI5khyukwY99LFQHWCJkQCJtJlmO5elJrOvtiNYvziVtA5cd8MICzcpk7uVv9cwvqCwpK5Ivi8WAXU4iF5pYagEYptSLKAahwU8V/ctYRZceLi+rktpuZLKA+cHCbbiF7XGJu078DndWUktOhHgxbJncUvHyqjZHKhagtfSPm5XdM/OLU164A0A2bqVORJiQcv8QShr7d5dv7clnm2dnCiYZZyQ88+KcQxIwu7i3DPsoBkBYQZfnCGY1lNoW9GarfOYX5Ys5F4JKUDpAa3IZ2ADJ4tK3jRZ59Wd1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4223c931-a896-4f03-a522-08df44dce732
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:27.3434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x5hqkiEan7HPfeVM5H/TQax2rAz0s4M9S/vFsuz5yjDd7sF/0aTbzmJjhTXpkUrhhXQyDfdOMDWQQpmcbOotltVFYIsWZsebTiES3Y/P50M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

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
index 9a617842574f..b1a364030fe6 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2274,22 +2274,17 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
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
@@ -2303,13 +2298,34 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
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

