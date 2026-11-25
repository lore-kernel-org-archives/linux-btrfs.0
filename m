Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602649;
	b=yjz2prpedsTcjco86t7j4HUogK3dwHibTIY3oiN2/71PT+82fNCgO1JrONCV0XImD1kn
	 RcW/r8uYCXmuyP8HfYRXTgPQYKpxzhKTdJZ5E4ESle4GoHDHXngNIrbRp3BKK26R+T/eL
	 2LWuQuHAoczfc7CL72eDZ6neBdifYkoEBrNYMLms/+0pCeWtdGWOgZ554l0EVHhc4z6Ec
	 Fk5OgGKrZriJcU9Zmq2u5IU8blC+d8cqfff34KzonBcR72ct23f5S3nqoDmO0GNWB4jF7
	 Y1UrYek+pMw7e6C8jEr9FdTsPGjiZfyHSTInw3uBm6RAEGEBm8+2Dh9gEuymDN9RNcA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602649;
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
	bh=LRQSDOayboSFOh5d2P2NsgF6FU2A0K6acc56xTMg9sw=;
	b=VgAZtritYbzJOCGRLW0DoDTdZVl4oESoY9t3Xux1G/SMDx1migq+eCVDIdofwu/ty4c/
	 riR0maEUL+OABrcSDmVouiWQSZgbI//1sSsW/sEYfa/RwPIWo+J6ufykiO0Mpkofa7h35
	 k4bOL6siJz4qn+vWh/cuqUsZGpp0XHzP9q8NDm0W8kagpa6fNWm/jGFV3ot0ioThrjEoB
	 FpPSm6r5w18XGq2odbJOYJJ/r/gcTcuU30z2LD6atcNC8pZv5MqZMP9otEa7NQe9Vtb4V
	 bmE3256i+n6aTTAGAjesa6TngUTvS6MoGuK3YQht+mGg/fMMxCUK4+RRnB2KoX1oAbA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=AZ2wLHSm;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=yN+IePSZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28CE606A323
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 10:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F28CE606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=AZ2wLHSm;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=yN+IePSZ
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795602648; x=1827138648;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Ka07cbMM7Y72pU+5GPypby/ePv2yncUmimdjiIcnc5E=;
  b=AZ2wLHSmTvRzLwFXTHUdMlqTDCsELJhAFd89IdVrL3o8KK2XL38FuSJu
   gAbc+0NyaBdjQ7weUL7V1sjQOSmc4IVnxOprmKTks/c6wqjdo9OGl9ZjG
   xbh/ggpw+FE6KanK5sQKRXuMRMhd6cjLxYpEoOwm0fWjSsWUPhGyt1UpS
   POt99ARQtijmbsP8KHRdEeY/ko+nrrfy0imlCbcmR4czE63EZpvmJO6Nd
   FnpQLC9VNAdvzL38XJP0UNxZ9flNmiZf7iOZsAoaSXF/lL9N79F9WQz39
   ThiUDM3J5VEVcxuuxnc0iV88wuX3IruJasxKtpQZk9adiOZH4SSChH6YL
   A==;
X-CSE-ConnectionGUID: Dew55PwGSV2p7pBy++6wvw==
X-CSE-MsgGUID: YpnBpYj9SgChyGZgWd/hiw==
X-IronPort-AV: E=Sophos;i="6.27,232,1786982400"; 
   d="scan'208";a="161662190"
Received: from mail-westus2azon11012034.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.34])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 18:30:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xSwugRlsMUMaCbHEyBQMSQQK5RCMpCRPaE/tfTaYBctNqM4pkbapFXcCBbkJwDRGA+11josHd5EEQnhIIuRwf7/PJKOppIralAoealDC5EfxqClDg/6ceuIWztgmas9WD37NslNU6Pdj9Wc+qhhthqOvvc43wOOelWMNwCGQiuar5xL11G+HWmzkma20WuBZZFwGKvcUlRy4Snss5qvqEel2kPq6RbLNUuEcAiPn08Vb8Xd9g8Utl7AdbqFIttb/iuZX6dlwr20wSL2n/tIDFmZEwiN30aPVY8pKsCZPF/i5soZzEH9Ot34SzrPzAeNpTC8H1WawanwQmwcn/pg/OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRQSDOayboSFOh5d2P2NsgF6FU2A0K6acc56xTMg9sw=;
 b=t7xQXiTJEqhPmyyq20rNSJ+7B6KaQAoqQnMRRLb8mK0avv3eq3hnGUUioaHqcmMtUQys7JF/KmxG3xNtne8XZIO02UhnA0w4PLa6N7NgIFM93l6gsAL6b9lXWYXvrDp75WSKjdbnSv4BLBl2Z77qULLbFSXN1T3aeUcelKCM/EyE1BWBvrdrOhIJJK65jsTzDWY3faQb4vdBPw1BCNNobu5ivitHPizQjJ8trXi/6xD7mMP2NpxYPdeS4OsfhRfQJutLWYNaQyw3bFJ1FRCCDUO6xRJQVT8fNjRqPRSCChiHzrk07aaxgwBZiCIJWXnFds3t3+nBMSjoTWRdUBfcXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRQSDOayboSFOh5d2P2NsgF6FU2A0K6acc56xTMg9sw=;
 b=yN+IePSZdlU8+d3erDa3DA6neA2E3KrgM6ffo3CkYLn0/yEc6SgWkFLh+Zkk/OrqRR17sFf2UVKHJW/a6u9c71iD2EZQNKxLrfz9zHub1i2N60uFiizRSBXifmwQw7Kq7NUwzETtjxIwbHKHCsTrL4qKWrRwq+SukH/EG/EZLXU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7870.namprd04.prod.outlook.com (2603:10b6:a03:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 10:30:46 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 10:30:46 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v8 14/27] btrfs: zoned: prefer sequential zones for data chunks
Date: Wed, 25 Nov 2026 11:29:43 +0100
Message-ID: <20261125102956.266389-15-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 94983ecd-8b94-459c-a997-08df4adf2a83
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|10070799003|23010399003|1800799024|19092799006|10067099003|56012099006|5023799004|11063799006|261022105027099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	nTZLJOCqiWf7usg6RcxB6jGGmUaomZZr0FQi+b0RAuAHJtA0FnDAG1HAO36HkLa0ic4nIEM0Jy+4IlsEuA4zq7J6hTr7IjgWx8WDNJqyXS3uFzGWXDvPM21doZhrZo3NFZJ7+PDd86yZiBvG3FOYyHpWbg8bbHsR3xRPwhTdROQzInKN2tlyXLbsc5zQMZKd+gVPaqPOmhuwWDvC/LPQv6AlB0AadWBXII9ckFLjNQASJ9dpgxgV7MP3KxVPU3NjLRqmwfSgz54MAd+kVuY5ZL0QvBAnc7hwYAmemmUNg0enNPUMvn4MKTJfbg2gkLm7395qoK0+IlhPkwZTVkC8Mmao8Oy77nTbIzuA5rAIGuk+i+2FeZNH7wFzzxVg92qkxfx/jqYgaAWnnJ5Et1Z+Vxl/mny3fXjDgxQyGEnG0j//tYWYGdrf5Ou3EgyeZio9kwi7qT8UWqHyAd7YE7Aqhx076+its9zz2k5r6AWI0oKKQ18kkeIay0nG4jlIbAn4/0svWdPsgEmNX6dMSnjWs6Y8LADk5Ov+WMLs+TZtGHsCkWDlnN5XSX8CYwivljtxPu8CWaR8uDO/PKefW6MaVYjR2ff0wV2QLR7yTFDLvfhqStCYBJw0ELbZwjiXxjCmiCf8//WJXiZs4gwBO2piBiY2pUCzqLKRnlQk18U7RFw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(23010399003)(1800799024)(19092799006)(10067099003)(56012099006)(5023799004)(11063799006)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mTS+tzQisg4EkMwa2fyD9kk441mBPtjaic+mf8c9lTLcPI2DLXdMNMfaAX6y?=
 =?us-ascii?Q?5Xml72inTdxox+8/soCqdWm0AIM5PsTx4YvZc8wOJ08+mUG2JS8Gcmgd1s++?=
 =?us-ascii?Q?083qu17jywzbkuoyAbPNdDHaBBKUhmXoqcPWb5iwRp5UcARCIT9DRMPGnOvE?=
 =?us-ascii?Q?VbJrkA744y2oJpgpRQPzCNVyzLT0mHtJO4S9RKpStvRvUdojuyo7fj/NJD1x?=
 =?us-ascii?Q?DGlqckYb/LyCTpzWLX61BcTubOQZfjhO4VlvUkFt8hkAWVTx4Zdx+AZim9Rs?=
 =?us-ascii?Q?z7QuuVZaajV7TwPeqhHTZ6bNPQQO38rqGgQF/zYTX4czoHG5gwjKSd89FJbW?=
 =?us-ascii?Q?zse9he1hhykbqowIKQ89qwS/itskDqIRgLpq9adUArFWSVhvKYYmynrivK3W?=
 =?us-ascii?Q?4PPmckDXKo2+ODvXmxxCDS9gyCSA97JnNuPuEw5bQGQU6WYy0uw0WukgsBc5?=
 =?us-ascii?Q?oG89xtj+6EL2ikl1kxPGzcw3UzyqgS34tOsSELy1YQKpw/KfX5mk/5yuhpJY?=
 =?us-ascii?Q?FvrWYqtlaiZc3YPMz/xyieT2TGG/mLhdxQwejvMjblXXfCIpIExxEdmgQFab?=
 =?us-ascii?Q?yJB28KrcBjCHv1GTltC657D0JQ89wSGuzprTah93fURhq1VjOy1EZtI+y3Nu?=
 =?us-ascii?Q?+aESGuAZXWfAXibugbfjogGCXrXhz9D9BuAMzug7raCPPI5VMiG/BvDeH2Bx?=
 =?us-ascii?Q?CQQOLbCcA8UgceAKAunJ+P/GxUDkOiXt1Dcvo2HDmeq/frju3lsxRt0DNrcp?=
 =?us-ascii?Q?n/U21IOkQm4tbwGqUqBFjvZQJNFvq5OHApwp7ZKc7RvvqP8d2U0ssx64aPIC?=
 =?us-ascii?Q?ILYknjsiFo8b8+xesaG/9427MYe6PdxKfad1CyvqmrvPadnLHzIN+43ipAoX?=
 =?us-ascii?Q?j5O268Uj2+VvRQXJc0tVIeGSB+XbvVPoVE3PqhS3LfK9LOPk7prFo8tPEVos?=
 =?us-ascii?Q?3SiEkSA/ZlMYkcBON7AM+jLpx3Es5MNq/OAMoEhIsxkDSPWV4f/MwTQIPd74?=
 =?us-ascii?Q?eGSyHVioCLW+SM4nFGBc0mn0oAEXeEGylDGM2jp8HdaGFk5dc6/O/ANQihpQ?=
 =?us-ascii?Q?pt5DsydmqG2y8mHSkaJXPTTNpXmt4985gHR3GLly91xytxB82znKbFMBylqE?=
 =?us-ascii?Q?iNQi1Kq7EmskqsEPycPW4r37Zp5r66WCkffp45g9GFXoe7A09+HfM8yLt7V6?=
 =?us-ascii?Q?7c4c1ONsFZvEj9+2UJsnSRQyiEfWS7Es+vxzTiARGDSFZJNj9G6XQCGuqOHf?=
 =?us-ascii?Q?KmwmXEKR5Ws8lg1mUrLRVe6UwYtBOUTgfJNwmgnscr3CLeyCqw3oN/u/VW47?=
 =?us-ascii?Q?ZMSW5Xy21hLsPOJXqlzzwlE/AIP7EXKfll57giurwOk2YEKeTPKf7jCok+8U?=
 =?us-ascii?Q?1mZ4T8Er5qGc9/Od1b0OOXemqJjFfKuYsGa0QP/9QY0ZxrTXKyYYGnahxMVl?=
 =?us-ascii?Q?T7as/1cf1XRoF7lcRB6tYWvN9YFDBRZQE9KwVLL4I/mL4uLAHb0i8OWxV8Qi?=
 =?us-ascii?Q?yypHBeMnJm2MuKlWbbDd5wnEkJ5ns8CX+MZTj3nz9zbN+Q2h4IWJYZjG5LqY?=
 =?us-ascii?Q?QAnBHm/Kj7gqlw89Veel5Ycfq4m+Bz8MY8LUYMJZYPlVEXH2tDXVzxIY4C7w?=
 =?us-ascii?Q?FuhagzIUo0RxGyzUksnRaJgdtCOR796pm1cVoSVLMvCej+jghhofRL3HeUKC?=
 =?us-ascii?Q?YGf1VG1WYKzKm3xIeUacpPx8ZiaASYateom1/wnUu1/GDQ40gmXhppmxkahA?=
 =?us-ascii?Q?MiMYwyN9Tl0OJUfHXg9UcGcPD62zZYf2rzOSE05mQsD2GvTdP9O0gDPNjZQI?=
X-MS-Exchange-AntiSpam-MessageData-1: yoHzD8+QErumRufGjSyjbovJh1+N9cG8iQU=
X-Exchange-RoutingPolicyChecked:
	hZlCHO13FlhSwBMgWp2osJ5zruo8YDwGDFYPqkM4T+yZAmWqWpCk59coFD4bC/U9PH35+Y9yNoRR216i9B5xte4b5m9WuuZZVZHb59VwR/pUgOYhcQ7MA+apxlDApKQ7k8euGt9ia3Ss/52TLlp6BQ2+Vs93RwUTMX/5TpInqr2pFOfWVu0cJtxuwesyd3654tI1aHhxj9gS2aERoNg31J7N6j5cu8/x+nppa0ZvURmMozjyILz31MCOfnYGXawxepzrWgjpzFPcjfBEmC6Wf2Es0RZx2Zmlnk+5rH8NEPmPNegcp2qoTiZYSzggwTets/r9NVmNF6ciMPtA29TbQQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Rz7PQzFJVKSK6KH74wKB8fWJYXt/60+tncMjBpl8HgdJCTvBNsjB8f9Qu1jPpOcA68Xuyf0mc+jLsqFcWJfWo/JhXM66RsYG+6CAjFpGJDuUF22I6EvHWdRtn0PwGALyXGtBWnmVl6PdqWkvJIooJtJhseJvzEYdNi7KzdmYGmLQPN3/ijTh1pqMDuZfOT5F3Zu8FZRYKP5WEbePBuXWcnSwLW5c6OsEF0fU2KskvGuWDpFOSKsAtdgpKaMNy4iT3G/Yf+YCdVwB8Z4mLXqBpcEoYsXfIETSqTuItaBvBRSw3qc0+Z+0xZqfksgPyB1TpY1IOunnnaWHkAhAOvoPiv9ve3TqIAmq7VT/EIrZqa63IIqzf4WEmZYrgUVA3gcTSVBJN2zRwct87s2181X7s2t2Db8BlMJlU2rvdxpm+wygyhfg0XbKXO80YzEljzgmEe1eI7E7nWLyoTK/+q/uONJGDIB2jV+mWqyMUD6u5M2m2MOwWJjjLGjOPN6A6+Ye+0zulgPVFVHzeZLA6li130SmjS0/Gvki1k0r3MpLJAzVofZ3t90RFkkzIGxKZMVMO3iKl9120DUfss2l6L9XZ8bpUYP1u0+ExymaAodsVsg1PqMfJxMQ9E8y92oNbCh6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94983ecd-8b94-459c-a997-08df4adf2a83
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 10:30:46.2544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xiBymSm/ygfz/wKD6f8UIR5/8Z96ZhkhQXgUhpPdNL5g+mYsUlnx/VRBzEijBL0nGWjeIYpTKJKhR7Ons9aa0QD847ZvUiaM1PhqTtcugw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7870

Data on a zoned filesystem is always allocated append only, even when it
is placed on conventional zones, and its volume dwarfs the conventional
area a device typically exposes. So there is nothing to gain from placing
a data chunk on a conventional zone. Doing so does hurt though: it
consumes the conventional zones that metadata wants, and metadata is the
only consumer that actually benefits from being able to overwrite in
place.

Mirror the metadata side and search the sequential zones for a data
chunk first, falling back to all zones if that does not yield enough
devices for the requested allocation profile. Devices without
sequential zones, e.g. regular devices with emulated zones, skip the
restricted search and keep working as before.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9462e8adfbaf..b9b5f32c4362 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5921,6 +5921,15 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
 	}
 }
 
+/*
+ * Metadata and system chunks are preferably placed on conventional zones.
+ * Those can be overwritten in place, so such block groups do not need the
+ * append only allocation and writeback paths.
+ *
+ * Data is always allocated append only, even on conventional zones, and dwarfs
+ * the typically small conventional area of a device. So keep it on sequential
+ * zones and leave the conventional zones to metadata.
+ */
 static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *fs_devices,
 						const struct alloc_chunk_ctl *ctl)
 {
@@ -5931,9 +5940,9 @@ static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *f
 		return BTRFS_ZONE_FILTER_NONE;
 
 	if (ctl->type & BTRFS_BLOCK_GROUP_DATA)
-		return BTRFS_ZONE_FILTER_NONE;
-
-	filter = BTRFS_ZONE_FILTER_CONV;
+		filter = BTRFS_ZONE_FILTER_SEQ;
+	else
+		filter = BTRFS_ZONE_FILTER_CONV;
 
 	/* Avoid a pointless first pass if no device has such zones at all. */
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
-- 
2.56.1

