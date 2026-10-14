Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2EB4BD794
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979472; cv=fail; b=VsHhNRO52gur+0APaPa9hL6n/cBlIPyn4QHylWZSgNNjcqWazsKTHId+7DRkYHMGW6MXGYpJYj/EHQ3hQwEm2Ornl0UFIZqBdF7kwDx50GlSuFrPI4/nK+r5d03aHwRDxxe3ZISANI01WQ+evTiiJghoda5otEKt1QD5bYvmU5o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979472; c=relaxed/simple;
	bh=Rzb2Kti6k2OM23zK8difs6WSLVxRcgAGO316qeG4HvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=paxfhFdPV+gLAFoqXwD+IaQs+SvH6YQFy46ev3m/MvA7XmsOMKnGbzuROHLISJaxH7jTlBDd/hWZK73YNLnq0unTYepAE3Lko5UOVH64YlytBE1GFZx2r+087mo7sgsARt9fNgj3NhAVJb9/AqxZonb7YRq6CXUEgR4wzl+NhcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lhpcqJM/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=LDNRa3I/; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lhpcqJM/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LDNRa3I/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979470; x=1823515470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Rzb2Kti6k2OM23zK8difs6WSLVxRcgAGO316qeG4HvE=;
  b=lhpcqJM/TdNr9edm/qqnucRqaE5PjyRr76dC3bkIjm1SqqQ9pDkNstUW
   ogV5k7cYYY35ZrkYatyLkE12BR/sOKfux9PxCLvURRvq3LxaAMnBaHfrS
   FbzgVUXaZxOpiWsbFBGk5vwSoDZdkECKtFdHgXkazhLUyoNBx70KlcSny
   Q/X2oO3E2IAzOHz6T9j1deukSYzffXeGOu2gpLC0nUOT8uttIjcn38fK9
   t8pIeDwN1nSbQIqcMa8K2RKxJStyPWBSv+WzCAQTU7aR1bQlt+tnL/15V
   +ojbTLIgvFEizyO8xBfIMhxz1JmiQ1x+sFAWWbDNNwZOZ5zI2QK7Q/cgM
   A==;
X-CSE-ConnectionGUID: mMg+o6C7TTeZmXVGbtjSiQ==
X-CSE-MsgGUID: muk0aM+CRfWh7a7P0zH7KA==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077298"
Received: from mail-northcentralusazon11013048.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.48])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qDUJtUt7QtoM/ZlTQcGTXQ2af5/BvB/kZFdPi5f216cLo7nw6g7PaFrNiJMFeGe4y7JNd2aF5WXWuwvXok7HIbJSAKLoY4pgA31aisdToyvdDptg5oEhJHcmv7bksRzvsx44vILr1gFTx3V4TuivlxprFHziVAStoSgW17AJLSofio4KaYPli7FbCaTKk1Rz0HAtUOh25hHAAdP1mFBr4pk/0a1lRZpciO1VZGS8lFUIOI00P1F7lbLbALUvcBIpfY01WmEpZihDHxSweWRbbws7h2pk974c5ivJiYSxohx+7fah/nalHSCMEhxjCVzkC+p3y484ykQD+5DMaYFtOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEB1tNIfRGMo5yTDCPokx4DFJv3vyoX70tKEvKMk/pg=;
 b=KWZa/Qg+dHZ0WMhJ4m1JTMzFnzgS9xLgk2NaVVPHagnK6bnxPbbp12sDmtrHK4pU5DnPbc8v+8Mxjcg1jOA6nH7AaWvphbZCeYnUpe+zflq5NpJQ0VNPebMjznqnClXLFw1a6pZglG3Mv8H9p9l9ssI4zreBB0qsxny0Tcu7t1ux/2Gx8dfeOc0QjHYG+V2bk9nt7kc4t0qWo/w1WUM1p1QxwY05cpaczmRinc7wBrrEAJbGSgYo2Zz9tua0CxRfla3WlsXxJ/Og83liJneG2jL+QjrDsRAigyMiQ1QrSaLkyDiMl8rccyJViTRXGyB7V5UJS8eVeiLkAimH3K6ERg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEB1tNIfRGMo5yTDCPokx4DFJv3vyoX70tKEvKMk/pg=;
 b=LDNRa3I/NldwMu7WI7nCwhfQkyby8PzC8k3xo6JMKE9e2ZT9FrwAc81vHD4aApOiRvNJ6hYScbJU9IKVgAnGOTXAr9FHTZ+UsjeLK3dml/nFFA9MJHPezGnaM10s0uniVFVIr3SCRBwgioTMvqwI+7kl0T3DriWqsOBOPIXZcOc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:27 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:27 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 13/13] btrfs: zoned: provide zoned specific reclaim sweep
Date: Wed, 14 Oct 2026 14:03:52 +0200
Message-ID: <20261014120353.757931-14-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
References: <20261014120353.757931-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12)
 To SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA2PR04MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a90b59b-982b-48a7-22df-08df29eb4bd3
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261009223027099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	wdiLKW4wrgvNLa6sy1+zubBKdzcS8fSZyG/14ZNIWvEXmEyfXurzMuMJBU1c8o2/nXfCAWSY9wJ4zepmtoZZsD1vy/mTrNxF0XSNwWLQt+fkK5zaSm34OyTZwsWlJlehbOm/2iqXu1W/2/eD9XQe8BkOgY14OSWi7LO+ht7MZrrUPH61UTHLyB+eMNkCkpS8l4fULv2hHhnXZ0LG7jz4LJpBNy9Kl/Hs3mcJ4j60iiOlgTrWQ/+BKWjUfOFcWak25sQwYByNFJjxvgMKr9fVJXuwkxSmoy0DyYDCbMaXrcmqAV+wztcTig0k/PcX/Jo6kBlv2sGWnUNmeH6IxEGQA3x0uTpje3BlUN2m/ru9awovtN/MxlniMaZbhYUsoTQJ3dzZ9p6OLfnW0AiQ52KTBW97eaOtX3pNj7Gmd/Ml25Q8w0a6i11EgKHK4wBfubUSCqMrU5cUi4DuSt/AhBeOPV+9/3R7YD+BqF6VTYNat6a2V5AocofIcNbEm4q/Ko3ofqN0rI22/qf2CNjIisc1ay1CtAOK+ZqRyFECaCyL+AQLdrg9IBHSkMQIreJg7hANxs3jPz+5KCsTPSNEOfn1Ksea757xZxEcaWWawITG3HpWQthBuad6rM7b+MBEqEETYiHyCkYC1Fmr9QqVR7kdBJvltYM8vBRLv9Yx9auEr1E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Py5T/QRLXTamq7L23hDxc+YyIDgXpRedtZ9cJu2DAMFypgYtOf9CjaKaQ9DG?=
 =?us-ascii?Q?dMmAks5fyAy+yDz4zzYJNtGyqIvN7hGUZ7QydlNfUsDtq8oJc2vbtADTF3T9?=
 =?us-ascii?Q?U00pDPBfBIdeqwav4wp5Jyi4rXmXvlZDFuy9mJSwkBKpxfYjJyGf4dakbXSn?=
 =?us-ascii?Q?8OMQYRnHkEeIRxb4p/8bCujAmP+UtfGwRGfj3JBI2X7xI1O2WcfVL3Pj1xdx?=
 =?us-ascii?Q?DJuC0ptklMiEABHCZiYNUL5/IHRGO2189Oa4gP4zRZ8JTq0RGq5C4g5sHII/?=
 =?us-ascii?Q?PX8AanhxWUBHVT+dCnlcy7FHEGlEzNH2RaBNrKhVnPJkx7hZpUX+oFv9IVIa?=
 =?us-ascii?Q?Hq1ZOFtullKIaVlE+wDTU75kKNIL5xJN1j0mvm1Sy/40OnHA6PCIS09G3k8A?=
 =?us-ascii?Q?FvyjKXbCK82SFJUm0jKzGvMQoalWSy5HmEnY3gKu7tt95w3gjLhGPhVORjv4?=
 =?us-ascii?Q?VRRq6ZOli7DIV9lKK1NCupyIpvtBYfJcmM2cUgfF0GvgzFrHkCZZptwz4yrI?=
 =?us-ascii?Q?sqscJfZ1esl1f2Ew+bauq6wFOuUN4wa/yRZ+iwqhABiryr6XByCpwvlPmSY/?=
 =?us-ascii?Q?u1hY0CW/Ces+9X2sHel+yPxenXM0Jtj4xQfTPivqTf8vmUZnR8TVI0PuI5Hi?=
 =?us-ascii?Q?q/UBnlyxYKIWZgCJ9H/ApbYeTm6js99eY16oPodviFLsA01qBd1RpsQeajPA?=
 =?us-ascii?Q?CGYRZ4Iv7vHno1SvH+I2v1LiFU/d2EQUsxbEEt6+SNAWDB1VS69ncCRAKe2k?=
 =?us-ascii?Q?VrA9r3PdGXjD6IDJLyLErSneGFxj/vQAhmNPyO+o46Vk6Hs2Rl4dH80wVtMC?=
 =?us-ascii?Q?Ooe/AytQdXgHeWiHN/KesYsW6tUUtQX0BGKteXFv6MamAzpPdtAPSxGLBsM2?=
 =?us-ascii?Q?2NG/FKuCR3z7ae39i4zPFqQnYbj7MBan6PddvTlzrdnOIg8E3IYQoALGiXnQ?=
 =?us-ascii?Q?+wFOUTMI1RyHwNaRYbiwoDoB9HpTEbhIQEIcd+cUm9O2uAwTji2trY/1hMYm?=
 =?us-ascii?Q?jGW8ef9kCy2DU11afzQ0SOPub2Rl8jGmE1iAJ7Lrd5RkUTl3kxzDH8j9rvXI?=
 =?us-ascii?Q?0Ty/I4/jQw+UqxJ1/p+eH+ljzLcz5mGq8+rVst1GIpBwEVDpjwGBUTc/HfMF?=
 =?us-ascii?Q?WjReVdLrTY1Lwyo8SxBStqOTn5zJrVS1ovhfWvZLMcMSVFINM+p164XUm+Zf?=
 =?us-ascii?Q?T80yjhPJIIeLrTl+PhoVRIBJYyeX3wQVf98zTRx8U8lLRaMVruFMDJd74P5r?=
 =?us-ascii?Q?QtR1FQM47shnSqoVYpIk6fjW/5gIXPz6C3nZWUThGe6yAjHeF7xIqagEervm?=
 =?us-ascii?Q?an3RkQABeNgNOvvl7oArEpbsRIMy7exESZGOaXVyO4q0ZrU2LJtBjy8yE2MJ?=
 =?us-ascii?Q?jyHuQeUcEqB5OTnfkiwzIWtikrJhVpLIar6zkoVal8a7pUVW9wkylMR8830v?=
 =?us-ascii?Q?FnR96U0btjOmy/ly2+gYGdDzQXDIempY07oEmXjI9wevxoTTiF01Nfa1X5Jw?=
 =?us-ascii?Q?zqMFSKxEabXD+HpenyX6AMlNm62P4g0JwkrotpDy8DADl8cYi05dxpqxlYtv?=
 =?us-ascii?Q?1/DLIzKvlUFWe9CLLBo6lUgZu7TCZ/JzO0qcgcXa995jyzcLSO3doDV1kmOW?=
 =?us-ascii?Q?dpITFI2m4vT/Sk26fSROExnOE29j+NZQIsisOiu8UK8cmPI6x590ISub5PW6?=
 =?us-ascii?Q?2VS+m3Gkm9zfV1RbVyNn3zSYGMCoh3Fz2gKni6aGwnHk+JpatKwcLyukdLSY?=
 =?us-ascii?Q?EKoNDWOygVwryBONuGLdX4LPBoDvAXYD3SlFvBIIaqqjfQWBC9RzctqGjjEt?=
X-MS-Exchange-AntiSpam-MessageData-1: GIfxTAtNEGZmXlxT8qjrRNhGAlQQrifQI/c=
X-Exchange-RoutingPolicyChecked:
	O9S7BUdxZ+iRJNatlexYuYFr2kORI+lhIdJ13jhFuTbhtz0uzAGZhowX0u5NEEjL0wVwH4oFsPBkVd7XnXsG8+3tBDsK2MYy6cVnuOtXVQ/zT6EeTRdOhy4If/9Zrnatn/jCMpMAh7lL+MczYZwVP4LMs3rjbVusyt4jGgKytRgtgu/4XINT/0sFU4jiFj0sq2ffvwSSYGNOJPpfRZpYTybxJ5+dGgFdB9DhjtCniHZJBsh1OU5ujzNLJdIEzgvtIg08lEj8TZUONmT5XTvXW497diTY7CGy2BFvyNIeGXdSsjhOiOiLuX14Ny7UwZpHyaHKcm9sfecfqPTTxV3FNg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xXXqtWW6JvZd6Qz3cgK790h+fCIHqBn/vqLa5Wb2IJhMDWnpNnMpZLOqzAnbx6QtMapOcYej/DYxZDqLFwxlltYbnydXFUp7EdSKU7pw5U2ICKYt9WRyMey4RQzctAYAMkCEYJclaH3ij/p1ISlsZatanzHTl/xdbZS0r1exTbOCxKZ44fMBz2wX1qgC1JuUBS1+4PNDPFbDCA7AkjvO3nzYH4C9afQvH2fwkIIyfBgyNZziGypPCDR7h0L5LgM5ZqYXReKpHSE9y6W+8pcRMlv4GjcDZuCaXjFw1ZvNsDMaoPyMhYmYPJeZHX4NYahh/UoChs2hG5k5dlVaMIbqKAZOyf8rtVaQsFEVR5+zyz754bRU4KnVHjUVcl4Z6EwLWUr4JTtmlwmsfmzEeBqfOqUob7JdEDbIt+Jpu95fvrOUU9SChnrDBLybSFtKoWWl4+aLvbfze1G8AjYcKXNSIOnvbjoTC9KM3iVSDcuAiaVgIMb/gm0mfju93m5+j2WuybvnC0HZ01UK1rM2PoDiYHJNYT8U2lyF2K0qP8FMUcVucwzZA9swC43H0iWNsypP1d8WaU9DbxV3Dfz19eqrYGVsFdCuZnkaYFjyg7Bh0wmo7fRTSAxW1tCQrf9hziQs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a90b59b-982b-48a7-22df-08df29eb4bd3
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:27.8004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ppOPI5eNcUVNKCO5WvP5F/cKp9ot5/2213H53zgsf3sXqOy8KCuE+JQI2RvfApAV5AS5Lm+D4/YpCvpjhLdWhPAjerFSAlMhM1tPpKDRA2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

The RECLAIM_ZONES flush state calls btrfs_reclaim_sweep() to find
victims for garbage collection. That sweep does nothing unless periodic
reclaim is enabled for the space_info, which it isn't by default. And
even when it is enabled, it only queues a block-group the second time a
sweep sees it below the reclaim threshold.

Apart from that, block-groups only get queued for reclaim when their
usage drops below the threshold while space is freed. Block-groups that
were already below it, or whose garbage comes from many small frees
spread over the filesystem, are never picked. With data tickets waiting
for space, RECLAIM_ZONES then relocates nothing and fails the tickets,
although relocation could recover zone_unusable space.

Replace the call in RECLAIM_ZONES with btrfs_zoned_reclaim_sweep(),
which:

- queues every full data block-group below the reclaim threshold,
- then adds the full block-groups with the most garbage, until the
  queued garbage adds up to two zones. As soon as the data relocation
  block-group fills up, relocation uses the zone kept free for it, and
  the waiting writer needs another zone on top before a new data chunk
  may be allocated,
- also considers the block-groups of the data relocation sub-group, as
  relocated data turns into garbage there as well.

The periodic sweep keeps running from the cleaner, adding an additional
layer of garbage collection.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/space-info.c |   2 +-
 fs/btrfs/zoned.c      | 125 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h      |   3 +
 3 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 4ab18d8f5333..c27574d5895f 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -917,7 +917,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
 			flush_work(&fs_info->reclaim_bgs_work);
-			btrfs_reclaim_sweep(fs_info);
+			btrfs_zoned_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
 						   BTRFS_ZONED_SYNC_RECLAIM_BATCH);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 9e857af69e76..6efb02d9e64e 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -6,6 +6,7 @@
 #include <linux/sched/mm.h>
 #include <linux/atomic.h>
 #include <linux/vmalloc.h>
+#include <linux/sort.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "zoned.h"
@@ -3622,6 +3623,130 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
 
+static u64 zoned_bg_garbage(const struct btrfs_block_group *bg)
+{
+	const u64 slack = bg->length - bg->zone_capacity;
+
+	if (bg->zone_unusable <= slack)
+		return 0;
+
+	return bg->zone_unusable - slack;
+}
+
+static bool zoned_bg_reclaimable(const struct btrfs_block_group *bg)
+{
+	if (bg->ro)
+		return false;
+
+	if (!btrfs_zoned_bg_is_full(bg))
+		return false;
+
+	if (test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags))
+		return false;
+
+	return zoned_bg_garbage(bg) > 0;
+}
+
+struct zoned_gc_candidate {
+	struct btrfs_block_group *bg;
+	u64 garbage;
+};
+
+static int zoned_gc_candidate_cmp(const void *a, const void *b)
+{
+	const struct zoned_gc_candidate *ca = a;
+	const struct zoned_gc_candidate *cb = b;
+
+	if (ca->garbage > cb->garbage)
+		return -1;
+	if (ca->garbage < cb->garbage)
+		return 1;
+	return 0;
+}
+
+static u64 zoned_sweep_space_info(struct btrfs_space_info *sinfo, int thresh_pct,
+				  struct zoned_gc_candidate *cands, size_t *nr,
+				  size_t max)
+{
+	struct btrfs_block_group *bg;
+	u64 garbage = 0;
+
+	down_read(&sinfo->groups_sem);
+	for (int i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+		list_for_each_entry(bg, &sinfo->block_groups[i], list) {
+			u64 bg_garbage;
+			bool below;
+
+			spin_lock(&bg->lock);
+			if (!zoned_bg_reclaimable(bg)) {
+				spin_unlock(&bg->lock);
+				continue;
+			}
+			bg_garbage = zoned_bg_garbage(bg);
+			below = bg->used < mult_perc(bg->length, thresh_pct);
+			if (below)
+				btrfs_mark_bg_to_reclaim(bg);
+			spin_unlock(&bg->lock);
+
+			if (below) {
+				garbage += bg_garbage;
+			} else if (*nr < max) {
+				btrfs_get_block_group(bg);
+				cands[*nr].bg = bg;
+				cands[*nr].garbage = bg_garbage;
+				(*nr)++;
+			}
+		}
+	}
+	up_read(&sinfo->groups_sem);
+
+	return garbage;
+}
+
+void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *sinfos[] = {
+		data_sinfo,
+		data_sinfo->sub_group[0],
+	};
+	struct zoned_gc_candidate *cands;
+	const u64 target = 2 * fs_info->zone_size;
+	u64 total_bytes = 0;
+	u64 garbage = 0;
+	size_t nr = 0;
+	size_t max;
+	int thresh_pct;
+
+	spin_lock(&data_sinfo->lock);
+	thresh_pct = btrfs_calc_reclaim_threshold(data_sinfo);
+	spin_unlock(&data_sinfo->lock);
+	if (!thresh_pct)
+		return;
+
+	for (int s = 0; s < ARRAY_SIZE(sinfos); s++)
+		total_bytes += READ_ONCE(sinfos[s]->total_bytes);
+
+	max = div64_u64(total_bytes, fs_info->zone_size);
+	cands = kvmalloc_array(max, sizeof(*cands), GFP_NOFS);
+	if (!cands)
+		max = 0;
+
+	for (int s = 0; s < ARRAY_SIZE(sinfos); s++)
+		garbage += zoned_sweep_space_info(sinfos[s], thresh_pct, cands, &nr, max);
+
+	sort(cands, nr, sizeof(*cands), zoned_gc_candidate_cmp, NULL);
+
+	for (size_t i = 0; i < nr; i++) {
+		if (garbage < target) {
+			btrfs_mark_bg_to_reclaim(cands[i].bg);
+			garbage += cands[i].garbage;
+		}
+		btrfs_put_block_group(cands[i].bg);
+	}
+	kvfree(cands);
+}
+
 bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags)
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 022f78b6991e..c26cfca5763c 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -116,6 +116,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
@@ -336,6 +337,8 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline void btrfs_zoned_reclaim_sweep(struct btrfs_fs_info *fs_info) { }
+
 static inline bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info,
 						  u64 flags)
 {
-- 
2.55.0

