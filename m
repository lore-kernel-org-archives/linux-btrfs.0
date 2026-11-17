Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794941978;
	b=udzj+TMiF6+CLB+G3WT9dpGHG6HiIJXbGYptWl6zliaFIh/iKXHXtFsAVCfvB714f6M4
	 YxgtD4Enol7TElHRCVwxbMnrsLZj2wUDYcw28BgvIKqGVzfYExqnlCMnycHNX8Zfnx9ad
	 1s9wdRZzCvLT+hKCCLzr3d0JHYU62AgttugjaSJIiGxNEzpxo47Cae8w5DsqwmohtdEGd
	 yuWsVYeb9I5BrzjACxHqux8y2I0rx6bMOJuSnf9LLCNQAPV6aQC7ublt5wtQFGBa+Izka
	 4QlMieMaZE3eJhx1en/YQQW4tstFmVD1lv08Odlzl6j+YnMKMevyIRl9IgSt9vBO8jg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941978;
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
	bh=BU6ArtL1LBczcCiYT8xbdulfFlJq0BA+A54JN4zT89M=;
	b=4xY7Yz/5bfjQpHXmC3oTKoMvHuwJCL2/iC3hPO0S8hWclfO/6EY3nuys/kEwCnolYVeJ
	 QuOpfUexyrYHGCgGqyGdzFL6s8DtCWM0RHlZ9Lz6mbXVFKHCUHVQnX50i6EIrteR3Xc+Y
	 7SE98rGS0u2J2ekDY2/BvIzSO5sdrGOXRCENaacQWhtKqENWmdl/+tYtLlisAhYOnuf4v
	 k92xZJ3kCNMJq3wKqHPecSDM1tN5jAHzems9ldm3bm805xRzFly2ROCDdgBjBC95wjeeL
	 /GIv9qxS396aGupJy8fv6Yd7AQoSqvqMAxHZ8HAplUj9br4MYhyiZ1qp6/QjWUNP8nA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rIl36vgt;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=QgMBA9HY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC750606A32F
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 18:59:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC750606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=rIl36vgt;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=QgMBA9HY
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794941977; x=1826477977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=2KXojoIUgnoKaFJppudjrDlLtHzH9gkEFerOhCgO3Wo=;
  b=rIl36vgt9X982FHqhuFhywE/RiIYmNAmfE9fw3Piap473VZZr94iWZsK
   6++YW8IPr0kxPkOPfL+AFwT2eQAzCutOXo5mUf08OO+ebPkNEL57vQdEK
   n7mTs4Z31kqdTGnFRhc9DfB92ln64Tf5tivGxF37dydEujcWY/m3tnFTK
   lD7pad/xoV/uNWfNBWjDQCoTfh9kuCn9qgirBx77yxaPiwKiCSmbkG9pw
   jXCvfVahnCvxal8h63wXtFLHCGGImgM8YYQ/Ue8cnE7TjdDwBU98Qs1ja
   k7jIL3LD24amrJLQ+SxtnpbSde8tg1d9EQKV3Tyyb+zm6MLMQV9kCYz1T
   g==;
X-CSE-ConnectionGUID: bf51K+u/TZS1IwSAKSvtzg==
X-CSE-MsgGUID: PQ+8OySDQye0TDhpl4gf4Q==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="156880139"
Received: from mail-westcentralusazon11010009.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.9])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 02:59:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sL8i859+IHTZ4UcFOO+ebB7RSzS8Zn0qETL8tw9yHXcEtv1O/7Zcu8MKCPCJXIUDRakhQnZnatWCklFGGQNPmBaILhLx4OWccfvfJG5qJKLc6C20KZT3vv3HOXCa0k4nzgr4DnJmsdwFlDbM8ORiloHqAIBHDRvWrUZCms6qPhd59jOBoFdwP9yauB8ssQvrd1Yox2QHUferg/4cbjCbBE/yLnWWVZVfjn+c9LKkzV9z18rPfzQRo9BLdHM6RdUdMcCMr9/INAhOgfOFEE7QqsvBua4n+qFR02UkFN50yGnBeExZyXUmHBNGerCV8SH4jlMIgC3oDnhfjdRJtsV6Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BU6ArtL1LBczcCiYT8xbdulfFlJq0BA+A54JN4zT89M=;
 b=nEsHOFPqQbQ2izvmwD7x3sGMTgkKIv6WBlJcnOs/SOJl9e3YhHReuzbeCxWzVtWw3uM0QFjxcZdmlXcaSBNYZSgskDuIC5em2qLhrOXRTZEyKMu6nwiqyqXJbRcPFobtuNlopoQsF9dvFHYSxCSORgUA4pepI8B+OWUksHHDArJicpgSJVktvbMBswF6Z12voouEjoiyBBeRxYu4nc4VAxqVyZNuUdbwlDBehqhVK6dvCYrOcIW0oACMmZQ4z4BKCJhmrJ9VKpXEkfOzfEPSBCc9tXF8vxkUT30hV+MXmu5FKNbuqQDl3JBbk8RzvtpAPGDv3MoDJy4olaNK5dJsvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BU6ArtL1LBczcCiYT8xbdulfFlJq0BA+A54JN4zT89M=;
 b=QgMBA9HYTQRpkPtNdVwsyOgpvXnsuVGPyblIj+vTCEvnm8Ti9ZYl5FYfN5yPfBmB+GudfUZSS8spbmNSO832P/XEy8K/mx4KB2SJhZxI7pqQ5hVcKXWTxgsEpubooWdlmeR31LiC+6O5ypPZa+10CiPHrTJ4i7tCxdhW7DeTtcc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:35 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:35 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 11/27] btrfs: zoned: use plain mutex lock in check_bg_is_active
Date: Tue, 17 Nov 2026 19:58:34 +0100
Message-ID: <20261117185850.4128157-12-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 956a0119-31f0-42e3-1742-08df44dcebb6
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022105027099003|261026140227099003|261021123027099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	NjrLu+Ru7A3v98lzS6ljQpa7YeAyfUbneN49lPbGSyw8UmyHCCYlpFSXRxZcXGG1BTJxQ7ku9Hz7qM1VzGHFbLReNOYnpRbuTA9UdvYwBRzq83vHWJm7cdBU9UVSMhrvrClbnc21+p8JCwxeoi0DJnjoBse694NnaEUcCd7Ci2lM2fsOO1KmKLGUVVADFJs+F4MP/WjGNPTt6NINCfSsnobGBIGS/TiqFcCAgsCEubvXJ9tNNp+uCR4V2GsGU+bKfPnhfFNEwRhPnhu2Zlf0SJW3F0aZ1qPIlChecXcrn3Bl1NFNvApcnAvOPd/lStCYhHmiTfdNqxuOKhZosCoWFSTZBVGJjAIr3iHi9KfyuzcYc9yVyC6nSE635uZZmRQ2u2CBdYY73f3KruWbu4j14bvB+rop/GUelw7oy8f0xkI17ltSu0tH0dlaj40+hLR7ahB493ah8ZT1+6TrTYw5i4tW97bQ96M13ukKY26L997r/b9S86IWwKCDrlSa7ZBZO9EL0/xtiEwuCXbE3O8GrPVgMGKoLBinlsfP1xWvzihfAjbSmvtgYXnSKCSRxBMljLupuljs9GHIsJSrODXcLYrRDyZRvNlciWv8/o8jjdIGess83o5YArjVWm1fH9Kxfq7mmSodL8UxYBeyG8cD/50/CIncWR6mTgtEr7kHZmI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NiBG0u2Qa2sXh07qaiDGttVQZH9njwcjXyke94WTKCzcer2KualZFZRocD/9?=
 =?us-ascii?Q?3hHZNvNyxeZDf6Pl4bLunmPm0hU0dAfJx+akBjuCnjBBDLiRw7+wMlvKxMP2?=
 =?us-ascii?Q?FtA4uErH1NTxxz5k+s/q2nNtt7sl/JSDPc9sB24ixA0U4xinx6XWq7mGBDQN?=
 =?us-ascii?Q?I4u++DNZHfFY7zzwJsr+NMrP6ufkNvCpE64oaTcBvhora23Q1tehHomQaHjQ?=
 =?us-ascii?Q?RPb3GFPqTBRwi8dHNF3jcepU68fWZmg8uryyVDzpff3vwPZBsJjwzsU832Fj?=
 =?us-ascii?Q?sB9nIcl5gw3L2NNJ2beUIOjEaguszbWl2Ke4xbS+irHm9a7lECT2uBbihUxn?=
 =?us-ascii?Q?NAcKwD2pOQBMxZ0PZp5AxvLa7DqgANIPebcAo9fg1UZd72URoJ0yO9r94wWy?=
 =?us-ascii?Q?E8WGDjIUXfP5c6xXB7HvRhShxtpxMhG1VvrkwQ4ETomiEkMLUBZBY/FFYZvs?=
 =?us-ascii?Q?vf5jDk0u8zmr+jCCc1ZZKbIBkNwm4EnUinWOeVD/s6rQjVaxqTcn2QnQm9YV?=
 =?us-ascii?Q?zNfQZUbHEhxWraWMrRUg7pwjw20BPdapI1uPTlm/jeVnyjl5Sjt2vC5DhhTz?=
 =?us-ascii?Q?9+WGmfkdpbKIlg86Og6ZtpjDzkZQuUOoTbgWxihQ3qK8mmp90ng+l2RvH6e3?=
 =?us-ascii?Q?q2/17ppBWW/c4N5oZx123hEUosA6slDq6Fsfg6T10hgZ8GJteQ/Fj1MhjUou?=
 =?us-ascii?Q?SfYjm3JJ6NbLh59xZBaRZphpSL5zlHQ/PgoYj+DwR6dTSD+Ki6rNLza4+2sU?=
 =?us-ascii?Q?p5aLZlgUjHnuhmG+MZ5qyfSPUXoSPp7n7W9IIjHI2kZg+SKhhDWVRixLDROu?=
 =?us-ascii?Q?tjKi+IhTI0m3m5Cy5ILzfFYr6eQ68dIuhWgWTUbRwAQNoLf8rhj+xtw9kuoj?=
 =?us-ascii?Q?Vtf5LMc7w98SNZ8I1yY2sqJoksYY6PKq2U3Ph75+cymvkVQ1uKuEL39miVEO?=
 =?us-ascii?Q?j8f7oAnvTVbxVSl70z63PsCh1Mw5gtbXd2c2VD83Mf+M5x9bZWsMIEvlPzH6?=
 =?us-ascii?Q?5BmEa++zi6pMMHZw4GQSXckXJihOXaTFQbzy0488vekPiTH1wOtUBQHFXEi2?=
 =?us-ascii?Q?JHlkekHiI75kb0vwNfPgYD3usVdkNAeU63LqgyYxkpYFM4q5vWrqmoiDc+gF?=
 =?us-ascii?Q?zWOzvSukHp1xdZwBQ67IFXswyKUajIn3ufX67FxkXVI6jlpSGj93BNxtYZG/?=
 =?us-ascii?Q?8GXq3o4s6R2LQu2zQI+LMAzRadwAetwKX3nRzVlJsvUhXC+xeE3PcdbAyrqh?=
 =?us-ascii?Q?jiSV/bnAxJjS9MiM8cs3OSvC5YC7KQU6wS9BOAHfBKsnPA690E0mkaVYCJXc?=
 =?us-ascii?Q?2te5UwTmFGMmeJg6+9gSItDa47CLzzUJeLjSXRgkYwr7TeBDAEd7D2mccHUk?=
 =?us-ascii?Q?c37op3SErtoqyuiDdk6W7tXI9mMaMhL2EXGAsBHkn5hYz+nDGA9lBxuKt/Ov?=
 =?us-ascii?Q?TT0JMZ4DpO9yLgiTy88EwFkorSdeg0qZehgdVHInvIIr6wvSNI7KOtYpGTWp?=
 =?us-ascii?Q?XNBe0msD0kHtHrtRswFkNX8tYL/roRMxKr5kduZdI+RyuEbTtf2InAW9b8Bu?=
 =?us-ascii?Q?RNHP7+ovFbwkhHCE+r9LnmlhbK/Dt2URdvna4rUrUIiZ2kaRC2BLN1695unM?=
 =?us-ascii?Q?qSWs7aGRSrhrqf9N8Sfk6U18c/jzSUF+7rVUyC6qtX88gGj6c5mojNpueI7F?=
 =?us-ascii?Q?7rQnB8WIFxOTcc12uu+p12PMLffws6p8dE2ON43vaRvEu6VPgswupYOGseW5?=
 =?us-ascii?Q?yr3nUQhW7hYuq0wqJ4vz+TQ0s8SbH7JJSR/0AWHNTK0w7vBrZMErfTohMY3x?=
X-MS-Exchange-AntiSpam-MessageData-1: TY+U/pbloa7auMIEkF7bdhNq/OzFQeZO91E=
X-Exchange-RoutingPolicyChecked:
	mqzx+W77Kh2UUazeSJLdXesZm+4m/LCJuRyOXFRW1HmQwTEnQ1mK0wFwkAoC4cyznbcVuclUsYZEuHjluMEpMZ8+5OKXTCWjTdPifSaJByROI859mfmNzhVUVymNMilPbWrQXSXU2EqstKr0WAH3+7KG0uIMXggp5FyQ3g9aYhyn/885oBpx1veCRu0cZEeWmRAaN1KL5xyYS0LUJjcixWHK6Ec2O2427i+QD74biSUF0JI6KrSOe+KrSoLzjVfAYOqqPKK+zSOAuMopRfoI+bdLphvAJWiOZlQFC5j1hRR2djx62oKWd3zu4rDLC7M4+Dsb+cSCQxKYxzbDsPUe6A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8b4K0jx3zGkZHANC1rLb4KRgk5rGYDHtqIGfohlO7DaptQQs6Py8LI6WomdiNW5I9ytiP9+UsIiZU2vtBXJpU3U6pjsmq0ssNSsc/DPotYNpxP8lNS1UokaCv3/T7WGCQyXaXd6CSIW409u6v92Hf9qpk0rlvz16udKCKz89V5gkaB+lFiqrTP54ohKHuguSmCe1ZPdzckGW1JQme54XdR5sGEp31XXbpWmlCeTwlqITH+G7ERWw+pCWo11ryLeiDOsGrCfmR4V8xStvKZvn0iiwYdtFgTQQcnHws+9nsnb1FaJ0PFqcHEW43QRaFdZbdWTaULr8YpXN43UO4ciMxkhO89GlahUQWuIAXi9f4Gwi9fK0spI4R5mKhMbIgFLHPJCjcSLjVbw/oychWsLSGwxoaejKzddd8n46KAoPrrD5OceMEI7TIr5uxm0eyqt+BMEOm+fvISayw9Yrx7jLn7icED2WWeRkKxCzoD5Wvs+622+K5EmUyXw5sDqHoFRs9m4a8R6sDOxwvQalM5AxkXFxeMC6t3gbn5jNcIf0Ilphl5l63de7jAxMnoTBdhzDPQ+ValekLXd3JfRiZgB2sMLfPaBgHr5ypB9J2TRzS3ouCZoqeZIIcVRd4Oksjrpz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 956a0119-31f0-42e3-1742-08df44dcebb6
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:35.1166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGUxAAiw5Vfq9O2uhT4xI5oQcimhumVkEROrB3sHDvZ4gOpyFLhV1lWcPa/4Jo0BfGVtkSwr2xhdY4qjzpoKpR7X8PCMHheQwmbWFZ2nTT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

check_bg_is_active() is only called for zoned filesystems, so there is
no need in using the wrapper for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 8794c3c74c49..c4dcd8d1bdd2 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2250,9 +2250,9 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 		if (!btrfs_zone_activate(block_group)) {
 			int ret_fin;
 
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			ret_fin = btrfs_zone_finish_one_bg(fs_info);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 
 			if (ret_fin != 1 || !btrfs_zone_activate(block_group))
 				return false;
@@ -2275,10 +2275,10 @@ static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
 			}
 
 			/* Pivot active metadata/system block group. */
-			btrfs_zoned_meta_io_unlock(fs_info);
+			mutex_unlock(&fs_info->zoned_meta_io_lock);
 			wait_eb_writebacks(tgt);
 			do_zone_finish(tgt, true);
-			btrfs_zoned_meta_io_lock(fs_info);
+			mutex_lock(&fs_info->zoned_meta_io_lock);
 			if (*active_bg == tgt) {
 				btrfs_put_block_group(tgt);
 				*active_bg = NULL;
-- 
2.56.1

