Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031023;
	b=htyfsa/uY91wnvO0PiADUsefQTVcwyrVNh5eWXc+QXyxQfOSL6Djc7eoZzN4VB9jd3iG
	 w1kA61iSpgFEpBFuNSDDcnf3fGZZ00vHOFSPZt0nzAgySFknE2xBcU1E4cRnOEKd/M6iN
	 qHeNcDaK68tkyVdU/NY5F9XH9FBqHtOQgIy0OeTmyFsnr6bwd6OYNzvA3zTDLkRE6bgr4
	 z87MBthuITuwv7wGJict2EiS23uek8z2sSRlXHgjD5Qd02WnhJR48l1+Oum09GFHPBH/m
	 qDatUyh+CPhLETsAfDkM7aV1jxcLXhqqYGo0gQj0kGl86zUM9oawIoWHfRk09lFZcGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031023;
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
	bh=WdqndvYPojfnMz94LyRR9O/lNab0sqYH5upoF2VBI74=;
	b=V6jh+g0m9OSlEoslDpHaO/83MBnKBSyUATUrDcsGN9LNPeK3QdKhQ1FZtCUk5ICcnrpj
	 yWzgcAoWyUDD4yhrEcxWQAmlywnC7dVhy0zNujY6RTQcTqkqOHJlBoaRvlRPyH27V2hqr
	 fmnA8J6umZxHe8EAw6rVDX8WHC55BO+nPAZqba8k12EnJ/cUOLbP1q6/IFBFZakWklp9s
	 690gGpl9pwRDzdoY0/jPZ4v+A4ZripZ5Ur4i4o/0EO8P2L4mAO8eutGO9lET81NZrU9Tn
	 hGsCsdF7wAanTWdxdlmqqAY4uoK90IodBtQUas7Mwr0wNiASdMpvRzLZgcZC4YMZaqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=HV7AZCwQ;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="YSpZ0KD/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E99D606A32A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E99D606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=HV7AZCwQ;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=YSpZ0KD/
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031023; x=1824567023;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=zLBgV/RvNOiF8zu4UjmhYhpkp6ysuo5J7BrklZOQlRo=;
  b=HV7AZCwQyx0brspR0ykYiseVbRhwWD66jrd5zpRLRfiGGc885UeO564P
   jUvQjWkMqJpPob8KKyjvX00Yv2wFsB/vGp8gq6c7mXY0bHMm2oquxaUMD
   y812N42K0Xy9GIS24yH8zjwg7yjpG/9ynd4D4WBPBC5j0L1J4UI0NdiYQ
   BRu4KEvPCKOwdgrEz1bmdZgjCbd1Y7wezWkTj4B3rciVKTTO5DTEHZ+wp
   DMENgusQwnODz/AdnwRtthlUEXKUAoLny9ROY3VDvseVEi5noCNKXqfqL
   LyAAGR/YP3DGVESCpdiEbNJQiXrJj5uvJlIMs3Qdg8Bx6FfqwJ2SK1kFU
   w==;
X-CSE-ConnectionGUID: Z3J2gEhARQy6xZIKbDbLjQ==
X-CSE-MsgGUID: C9hb1lWkQv+ZtkYEElGdNA==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="158068836"
Received: from mail-westcentralusazon11010041.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.41])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vqtqT5f6ExZuFaQ5GuPlKy3u7fGqyo3IFfRMTCDXYOc76fSrE3SBVrUkN9fkUFtlb+rS0BD6qd2Y/xFHXkru85vyO+YNI/w6J/DyyevlfKfIxCI7iFmsiUV94PwrYAmnch3SIUpEQQsMDzp++WXoO+xqjlFtqWHSYtSbCBimFOHdHhX/otE9IYEMscpVOBG6RQjEuPKDsKBLRnoNBkIbxEtzPd73OulCnyKsGmRJa+yjv2YTiPuEZRokXysF9CsolzKL+2cZ9O6HcaLPXJz1vmDtslXBc/QCi7o4RNtava3QZ7Hido9sXq+6Mup/Bf5lWXCId5ji7nYY1QlI2ufRXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WdqndvYPojfnMz94LyRR9O/lNab0sqYH5upoF2VBI74=;
 b=PPJ7PeE37gpPFQH0Uxx3qUzUSTqb+tEJ5Uhce1Yedskm9y2a+E1bmAdfgtg59ltJh4GtTZuq+WXCqzDk4jgycfl6HnLfZZkvhKW2/dASfZkwH9hS+rFGvNqx9JjHTuxDNPvXUu6m/YhCU/IHY6DM/wrlRY0200FnEo7SwjsROn8+F2Rc5duyvtWyxqIG77aOv5zquAzpbbBXOXq8KZeue59X9qQ8ezdAjpIOAv4mO+OWJHq4+Qra25cmopPOzZJua0ioyO5gR8fHrTecSiLASiPqG2rwz/zPO4Lf0I1OVPuls1Y88TCHByeNYkNKAbzokz6vBzFsA8dnWsWTuMO8dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdqndvYPojfnMz94LyRR9O/lNab0sqYH5upoF2VBI74=;
 b=YSpZ0KD/33fOAVrHW9GjogT3WcyUQr74FOWsPC3byfqayAnLSR45ArPml7tdxQBLbIjG9td0sRi3KqtYZ1OL55DmMIZ/5wSzLksCjnTOvNv4mOBdVIswyuwYrVvhx/CPN/lqdf2ZbfOMPe8vCP3RLIqmud63fkGcIaLM2AnnydI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB8472.namprd04.prod.outlook.com (2603:10b6:a03:4e9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:28 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:28 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 00/25] btrfs: zoned: fixes for generic/747
Date: Mon, 26 Oct 2026 17:08:48 +0100
Message-ID: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: 08e2888b-3fd5-49b3-4d19-08df337b8307
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|23010399003|376014|366016|1800799024|13003099007|261026140227099003|11063799006|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261009223027099003|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	dtb+Ac/l3f4XVOsAB3TkzZoBAOTLwFhpAI4t+Mcx5AAhPapp7eSgKbWISKSHLx1H+pqZVWM1Salo2Q2+wgZgYjF0hgktduFFoeMzbwU6kYe94h3bCVViz3xnYnKzDmt81d/wPIjPFPUVNi4SjR+r7n968IUpMVqZeOBRWyszJMUPdGfNgK9Lr2b4CwOVzDQaH2lhSSr4tuecyAE4L7Z+xBi7C9mYAXpbYMa/YzMh+M8p7O3HtwstH5g4/BvGJljsI4+3+C9K9fDILlTiVzpvoeGXMZEC5t8/UfnqN20HxAF/lQCNNTESzfOKwhSU4/AYA3l8kczfKqReWpycbg+B+ZPo4snPohUOMJ0bsFYs1BUu3tdoRIQ3+JANZtYAo+x3Hn4G7ufCsHDdDD2iCkmux4zp0bhEZCn0WoIU+j4Z3YsZaGnwopJ48iFKpEtZf7MlDpSxUeKnP5iM2g9MG5lKcGq/uUzbVitPNDnfnlT1po+htJRhLb0o3Jv3TaUNeFCPhVfNBQ48j+R33P1m6pugdC7RNnsvaGOmjq/KTg+GoBOBrzmb2IQd3KMEFtgDF5+h2M/7eYrlcvnbONWIcmt1w208HrNxyuJ55SH+w2V00PEmbi1K4n90jQXriv1HZVX2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(23010399003)(376014)(366016)(1800799024)(13003099007)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EOIKkoe77PT6lza+SAWC6Us4XiJsZRcGq1CQduIzHw+5ezR+X0qUkGRKqidi?=
 =?us-ascii?Q?1Vavv2BDD0kZ2fDOOMBGInd0/9ET0sVfZmY6iffGcZZry90We2SBAa1lCZ3P?=
 =?us-ascii?Q?9CxUH9GMCrC+DOn02gM1QYlC2fqc0bSsnHjMSUauHtjFNns2uIMm7CFKMblq?=
 =?us-ascii?Q?OH/nFeG7fMN02La9zoZnRqj/1Zr1na0Ys46WqD5rIbGhCxdYNnrvwY9IlcIN?=
 =?us-ascii?Q?Vm1Yk/iosiQghIhfi97k7cAdxoZ33/JnzlFrXSoTcBnbyPY5HYgL2ToxBUjq?=
 =?us-ascii?Q?uJFDUJxUtHU7Xbf816r5m3APfc9MVsAw/8kXQ8Ff2uT5y38kRwq5bVwzSvmC?=
 =?us-ascii?Q?zs+ZM5Vi2+ps4bLg/qSnyDhVtc/EE3Ckf1ziLlZUp0x2pPsPLnedYS1RGHIx?=
 =?us-ascii?Q?dtTkuCD0g63Nwn+0wQiMhqUQjfal1hx8UjhBYmRI6vJLGIR4eQRIk1TP61Eq?=
 =?us-ascii?Q?vEW+ucSw09h+8dIv7JwmwoT8lWMimKQZJ3b6ziFTM4P/LCZCmG5QBCuj98rM?=
 =?us-ascii?Q?G0DnGqoiiX52ckRYFatEAhsbShWjKeXAIcmGPYERpXkUL8J+jp/OyzfKRQ5A?=
 =?us-ascii?Q?KoWVPvzd0zATKq+IcCzlVsbTtxfu2kBv2rwbGX+rnPMQSszsGWcZaD1FPmks?=
 =?us-ascii?Q?PkrOvMuOh1WoSn8o3lzA3141+L61qK49xn8HlApwO/T3koQKwTdRki08wH0T?=
 =?us-ascii?Q?BSWGAX398K08zSqVEmkian0/nzaSrIIK+qk21RxYz9f8CZmkXvtWJ0zde6k6?=
 =?us-ascii?Q?5urOWoG82FQjQfEuZUr1+0Zc1xSFvtMHFa1CCzggnkgPhsEgokfSeVh3BUsL?=
 =?us-ascii?Q?a01CGNGi0fMXtC3sZ9by1hFcOCrgBdUjGEiPurZnRRi33S4WRxY09gS4rj5s?=
 =?us-ascii?Q?BAWuPjRf8ZvQMG3O7ckrmM726fE478p/eK77ON+NhuuK4gb8QasE6tx7D+V3?=
 =?us-ascii?Q?sVpHRdpKdBxzmD1/se0OTIr1uZrQ8K2Y8YJUqAC33WkTAjV6itkiMP+zAP4r?=
 =?us-ascii?Q?7Te043xfny0voW0iUjfjnhIwHrwLQFtWvUnFWy13L9zIuzNzYitlp6VW/PYr?=
 =?us-ascii?Q?U3w6+Zg4bNrwbq5eV5fwX8XmutBmtcjl+jwFnWIEYB5LwXZo5HGj4WqbWDHL?=
 =?us-ascii?Q?CoPvsL5S0oGsGfKpT546GB1GHwknxF16iWt0y7fS9eACYo256R+zyC9FFAKB?=
 =?us-ascii?Q?ZUGzEsk953yeeUx5nrQnEXSKTOyar+16lKP8JtFERSdrq3rn3GhoajrP+rFv?=
 =?us-ascii?Q?GjzstaguO5MaImCG4rtv05D+gn8eXOju2eIKkzX9Ib9vuPJkQ78dIU7+Z3E+?=
 =?us-ascii?Q?O6268m8RFB17V14w96x0DjqPx6HkFHinnr9WgBcVzYk6kHIgqsxo9yFKn9bw?=
 =?us-ascii?Q?O09h5eRnbjSaYI3wbCpHjkYNWkk2Orif4pdn4X+MajQMvl4BO/epGBSk77xx?=
 =?us-ascii?Q?5+PCu8oHbYXe5So3wM7pLPZqbEBCvd1/ieOndg9SucSWZzMUGkGdpLEN5cZw?=
 =?us-ascii?Q?G7lb9XVQbkMy0YfLkX93s8Km8jwwLQQQxfFd4z5ymQC8ECVrG28evTArf+Ba?=
 =?us-ascii?Q?uERuud7lZKwYpGMYHqLn9KN7GiWg0JxrPSh1np2SoJwD2RvfOYRLJxCSOK6J?=
 =?us-ascii?Q?2hxUAvhTR9vc+sdzTfhhtjY8VpKEdxcViHVErKytk4JE3rzYHwCYorWGhQP6?=
 =?us-ascii?Q?ie26t4m5WL+A9uHjJrIjAn7k/vdoBoAlPV9F5fKyCJqv/n826R9xDNqw8BEF?=
 =?us-ascii?Q?aFDcjhg47pnmDYOZM8TQHQgRfqetC8qqPFjDpHn7OXZyAAwpt0czL+3+bimJ?=
X-MS-Exchange-AntiSpam-MessageData-1: hwzan/iLXEQfOw==
X-Exchange-RoutingPolicyChecked:
	WhALWoUpHEIKzQu64M+3KFAZvbzqGPJ/+hBswfauDsncBlpJLgxqBHvlfZwTJbjuP8jsDLHSTevjTsHlGCdzHKkuqz1h1NentCUzvbJAanJgslmGQabgoZnulgU8Ot0wPxbbFWTZL/tvGBa/e8St9ml58dOGV9rXWYdg8IljeGPKFEF23ovWRhdhhC0Y1aJcAnCmSPzTezEywnF6Zu7dBWpgsQl014vWuwQlQR9tQ0YzMQfwYDotqoDbB5HyM48sHd3OifPghj29VxqrbMsSpV95Jd94xYyFyLWy2reRXce3CL+AgDqmNw9it2eaLC2qJLT8oI0tv4ovzP7wWG7l2g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	41VxvEk5DgMIZnNjolqZ6q7GK32RKeP3g0xZRAMluruWnFRoT5B3tpm5bVZj4fkNl3biuCA9rps6KkzFLYOCovywYoToCMdUbgxifxY8sQ2nEnkX00AEt6yZwJsOk+H8env7L8tzVgvdHmAbf4LVdJB4gwznOGHfjLYa2g/sl1MwmWuKzh2MsjLy/HQzEOvh2+NkL4c3kXoU9qVN3tb3qya6ashvOGJchF7xu87c6kB9zwSqyb9d0FWNovdpwp1ZUv1Fc+vm0jPUDo8AaNoaw8pQZUn9bpPHB94iRiOdFbWkYl8V9+wG8nr0j8jcumeb7vdmVBH6D2ozzZbTGXH7+e8iDfcoudlcCkwi+tLReLLPrJLF9anZbTSpkAVkKL0yRpxZnpDf5dGCn4AIvF5+IxkEZT6QO1TEw52PgpiWdLQaAhEzrHsrdsHYhFleWyj99aBOp55WATla9oJurB11yLBD7CpbvwiTq/FuOZGxIZazeXom92Qxgfz9u2JJBTyg6+fuzJ51hFd2cI4Is520UpX9ctefVERtIBth/uI6xKPA+M/IPeomN2VRiXsA4mix7ixue4nnnIP/ca3VuXcHx7HHm5unwNdNebH345PD5Ebdfmq53q579gFfyu94+9IH
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e2888b-3fd5-49b3-4d19-08df337b8307
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:28.3904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYJCUVZrVIw8muPZM5KIW3gf7H4MCNt224DRt2Os8dQ2VocTPNekaiXrAzC6+rUDpb0AYmCi2yjjtXV9D6WuzoM8MrsCh4VnqshGqwirw7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8472

At the moment, zoned btrfs places doesn't distinguish between DATA and
METADATA/SYSTEM block-groups, when allocating a new chunk. Therefore
METADATA and SYSTEM block-groups can end up on sequential write only
zones of a drive. This adds a lot of complexity, as we can only append
to these zones (and not perform random writes) and for METADATA we need
to write with a queue-depth of 1 using the btrfs_zoned_meta_io_lock().

Also the write stream for METADATA is not allowed to have any "holes" in
it and must be aligned to the write pointer, which was a source of hard
to fix bugs in the past.

This series introduces a split in the block-group allocation path on
zoned filesystems. For METADATA and SYSTEM block-groups try to place
them on conventional zones if the device has them and enough are free.
Then change the allocation in these block-groups from the zoned
allocator to the unclustered allocator. The reverse is done for DATA
block-groups, which can be trivially written on sequential write
required block-groups as we use REQ_OP_ZONE_APPEND for writing DATA with
a high queue-depth.

In addition to this, this series reworks how garbage collection works in
zoned btrfs by a tackling the remaining accounting problems and
relocation still being triggered not timely enough to evacuate the space
the user write needs.


NOTE: this is a combination of
https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/
and
https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/

Because it makes more sense to see both patchset as a single feature.

Changes to v3:
- Fix the active-zone reservation race
- defer RAID activity publication until all stripe write pointers and
  capacities have been validated.

Johannes Thumshirn (25):
  btrfs: zoned: fix possible race for reserved_active_zones
  btrfs: zoned: don't activate conventional zones of mixed block groups
  btrfs: zoned: skip the append only metadata writeback path for
    conventional block groups
  btrfs: zoned: never activate conventional metadata block groups
  btrfs: zoned: use the regular allocator for conventional metadata
    block groups
  btrfs: zoned: only take the metadata IO lock for append only block
    groups
  btrfs: zoned: allow restricting the dev extent search to a zone type
  btrfs: zoned: prefer conventional zones for metadata chunks
  btrfs: zoned: use plain mutex lock in check_bg_is_active
  btrfs: zoned: use plain mutex lock in
    btrfs_zoned_release_dirty_metadata
  btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
  btrfs: zoned: prefer sequential zones for data chunks
  btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
  btrfs: zoned: don't count in-flight data as available in statfs
  btrfs: zoned: don't recheck the reclaim threshold of full zoned
    block-groups
  btrfs: zoned: don't account superblock zones as available data space
  btrfs: zoned: factor out resetting a block group in place
  btrfs: zoned: prepare reserving the data relocation block group at
    runtime
  btrfs: zoned: promote reset data block groups to the relocation target
  btrfs: zoned: return finished relocation block groups to the data
    space_info
  btrfs: zoned: reuse block groups emptied by reclaim as relocation
    target
  btrfs: add btrfs_bg_type_to_num_stripes
  btrfs: zoned: keep a zone free for relocation when allocating data
    chunks
  btrfs: zoned: don't count the relocation zone reserve as available in
    statfs
  btrfs: zoned: provide zoned specific reclaim sweep

 fs/btrfs/block-group.c       |  45 +-
 fs/btrfs/block-group.h       |   1 +
 fs/btrfs/extent-tree.c       |  29 +-
 fs/btrfs/extent_io.c         |  84 ++--
 fs/btrfs/extent_io.h         |   2 +
 fs/btrfs/free-space-cache.c  |  23 +-
 fs/btrfs/fs.h                |   2 +
 fs/btrfs/space-info.c        |   3 +-
 fs/btrfs/super.c             |  30 +-
 fs/btrfs/tests/zoned-tests.c |   6 +
 fs/btrfs/volumes.c           | 107 ++++-
 fs/btrfs/volumes.h           |   1 +
 fs/btrfs/zoned.c             | 810 +++++++++++++++++++++++++++--------
 fs/btrfs/zoned.h             | 118 ++++-
 14 files changed, 998 insertions(+), 263 deletions(-)

-- 
2.56.0

