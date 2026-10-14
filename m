Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B51D3CB55F
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979457; cv=fail; b=ZvowXU8L9lcrIKMoUuEfnCMgTa06IBPLuRFQqlQGtkBTxV90PYGihgCyRBmhTkJkmRCWP+8nHu1mLmFNjA9/k/nvqHB75tfSOWKsxQKewVFsEPaNq6BWUZZAehfnnCz1/cPo/HUp53GydeaK6vPVmtRVDn7A12D3qxrhxtEdRXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979457; c=relaxed/simple;
	bh=Q3LzjlTqgmPMyXnKTUEQFIq7TvzW+6GzSYLjPn6lvcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YeQM6L4LpoCiaUGOeqboDpKrp6OEECN05c73/9qmDj8Wfdc+d5cBLye7UsGxbBqX0t+IMxj3Am4DBnQTSIuqI+Ul75Gnwr1vgkWc5qfiM30kN+tAciex5r+NU0dbZEjUiC9Gh/XfPcipum6WuLjhnr3f/Qok/5yuE2ud/JJfJTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Gh7QAWWt; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=khL9/Zrv; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Gh7QAWWt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="khL9/Zrv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979456; x=1823515456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Q3LzjlTqgmPMyXnKTUEQFIq7TvzW+6GzSYLjPn6lvcg=;
  b=Gh7QAWWtI+1l7TDTHMJ1GquMUIBjZvVfga7ILuJ/ieQTXsrRzSfjAWFg
   BkCMjVkJtnpo3YbC6uqcoZUDqVGGn4lE/toK/oWd0WPuhLzmeLwTq1lpE
   WbcOjwyXX+4eoCVvbWUQn6SjwYhPb4VIwfnre9iMVPvsO2C23+4go6woK
   KlE99qOGlTvKwn6MbcCx28NLzANKfH+l33msC9Lh9gr7VMSLo3KyKd76i
   630knqRcnoYo//of1dcQ01+g+5eiwJRlJk0+eGt0c+8VejLsABuRe/aaV
   I9WJyycrI3Kw9hMC7J9k4NaJ3RTlfbN4K4sEAmJAjZJ+rryNlRMVQQ5Fk
   w==;
X-CSE-ConnectionGUID: REpoNeOJRK+nHA62nZEg5Q==
X-CSE-MsgGUID: W1J2gb+jRCeovl4velH5IQ==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077242"
Received: from mail-northcentralusazon11012065.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.65])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XtCX9gXxiFlr6auM8yR/hNSRLuP7dVshMmgomi/xUbRQKPMO6QswUXH8f4ZwSD38EV7y01ylDLL3hLVpqaPKngkMzSEOyZagGmuucBbHybXrJqkiALz/gvraRUmuXElfNLKnP74A9ltwxj03Qm+L6dDUmx35mvf2snwgjMe2ohydfa9jtsTmL0xQinjSaJDQ+ic06E8gQaX3ZEolzlc7Gd5tf60EHwMqiIgGFj1gefpcaXG8KsyAaqwnKWQ4+o625uh+s6DniJXqHctSZ2u6Qxl6q+Bj3CtTwq8yEqd7JnUbBDxm6cb8P3rTvGAwEDRN/3P+e9XUdH0prhowtwFWdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejRKHQEwYnz4HThMAfTkCz8wg3bAHOXaDSNXTSUi+Kc=;
 b=TL6O5OFoLSbxs9OyUb7go/gfYsNpDktdJiyvw6/bqCx2eGBp4wJh8zOO0m3v5h4iLE2p4X72APWeDaC1FowjQPY6G2iEX4WE91ImBoM7R88ct0u6CDLRguIgjQ0UK2vXLnWoU9pjaf5ptT26IIlYDR7+tgHZuZRXY5L+8TXKbdrq5KiwOTjPJtPH24wjxwqNM4PLE50+nV4uM3lbMaZniDEHaoAUTg4v53Px6tKqG/1PxybCx/KQk0ue5XdV2Wvwev+JzeNZT/Lo/zkTMVpbzF77OKJ/BvcFIWi/zElc/wwWhb1snTzvle/7eXzU/mX3AYMPfN/a8mPi0P+37cyF5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejRKHQEwYnz4HThMAfTkCz8wg3bAHOXaDSNXTSUi+Kc=;
 b=khL9/ZrvrFK2DQFr6tuqiXoNO3jYQ4JCUd0Hq+PwxdQbVnJjT9dXHkuK+e8Uzja0iIani0OmRxQO65bKHIkAR3WC8AzjqFKwwq1hkfI+tK2Tn5WmWz9oOC5FacPGCLQ1bzpO2ShQlTV9uee8Dkv69XGuHy2qX+/MKgeDfNtvZ/M=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:10 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 01/13] btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
Date: Wed, 14 Oct 2026 14:03:40 +0200
Message-ID: <20261014120353.757931-2-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 64b4e57d-fc7d-4d75-3b0e-08df29eb41b5
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	V3cgNNpCwpO1xnF4G6KcDbrcq6J+AAnehC6DcuK6cp5mCFo9xs1m9QBNGXHVeM/edX/OTzz2edWkbJZZSHmXKtH8THJ0TgxDSkEWsPiXe8HUID/R24Gp11/29Uxt7p2vRgwsfFUwg5i2bjrDB/TH2E/YLL3HY6mZK2rVftvJQfex4D5fZcRnH2V0DYpv60qB2FtfQUqb/e4LgN2U/GmYZCekz+x9SCzcveRLi1xl7/Juti7Kw3ptkp3eMWkWxBTJ7CaQ/D4Vb10jL/hEz858IQ8Yuf1uy8CqqRqqpAKm7OLlfrIW47BOWieHtVgYsfKbKcN7lKkyyxHljWrnGsraVenzwHNlwPHFmBj2Br0NvbOUSSn7Xu8RWiG3f1bdP5Efb8HdfvhoJTQVEeeLvy6HZvxPYiDLXC2F/+5SgQ3n1Qu0U+nLZuPvTi33l7RRcq3Yn8cO5wtw+LQYlHCec1UyPRJsoau/E8xDhZMMK2Yv+DELMR2tSDYMQ3L5ZaGyKkE1CuyBs/vHeE5V/v+kBwEU7fIhVO77lUrVxkHDTR5/vM4ZsWQHWUbuvq6LaFORjqQwHA7ErzA3IL3f1J5Q5rg2CcTEbUUj1RPuvf9PHgyR9UrhL29W2/SuAUm/8TETd9BtDiHiQsJ0oIaOYjSmi85QSXRvMz6NCUTc+NWtIEfciDg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VzgWHyG88pWSDBDtwgXAjKFDtoasxiv5sIBJ7iJJDvqP3Ap6tLVPE9Jd9kpu?=
 =?us-ascii?Q?XsTseXBAOCiuXF24acznclt3HJj9XDq6AqPS54XHfpfn7AQIer1bXGGb0zLY?=
 =?us-ascii?Q?EI8mNDQNBNrSiy1D1LVTG5D+w4ek9cJkzCXg6BMfCMVjCXS5/jooMI236+YN?=
 =?us-ascii?Q?DqDJnv/pin0Ilor0uOfu/cYa218PdIB50qZfO95EaBf7sghqKqTnSJ4P6qce?=
 =?us-ascii?Q?4llEetgU8OXYkRiNDEjxgT/DFeUfUprPVt3BGPBY4wRnYj2Dl9YWC+qX4wk1?=
 =?us-ascii?Q?JRXdEYSAKLPFosWuNEHB0CBJvvtJKpstQ1f5hYse9pODWi/CZIHoulnikboS?=
 =?us-ascii?Q?aIGfmGccvEpQKHmRB3SMfPuPEXuxTIXiOE0mnoUbx3JnajoMpvKSMTIZP3Gv?=
 =?us-ascii?Q?3moRCba6xFSMkdO8tJdmaOW6kEo541XpxVa5NsYeylzzu0/UED/H1k1h5XQ0?=
 =?us-ascii?Q?L6zZ+z/lZ7ath204CCnTH0FI4KkO0C5o5QH9vwI5znogPmNnHMlCBQ0aT3So?=
 =?us-ascii?Q?vZ5gjb7CLiBSoQauhRMfLFRlTR9aMgRk1kXhXB7+RsZyp/EjbpWi5IJGgdSo?=
 =?us-ascii?Q?9jfoS2EF5CqVVCo0AiX5RbXgiEb3nLEB0RyBw5M99oWyHyYnryqYwAps6LYN?=
 =?us-ascii?Q?F5wdlslUorYyVKYAy4dPa6Ezfqv+4aJGeeZn2XKG6V1AV/0GQCcDVm0z14hC?=
 =?us-ascii?Q?9vf4yb9iVtUusnUaxQhxx7jkTcz6gEZyobePLY7FSrtyQeVGiN6OXJpIMtKw?=
 =?us-ascii?Q?aWtdsf852k33a6i7jUJZCjkWPFphX8215Sh3TcYJFbJ1D6bZKoZmuE0kVMlO?=
 =?us-ascii?Q?DdVVKvK3xxsF2JOBAXV082Hodgyr5JVMYxEB4IVKUgHH6OTfp+gIxl2NYbnI?=
 =?us-ascii?Q?9z2vQkAeFhhPIZ0j3ZR1EnyQJ9g2EbHcGVgrBWG4IA/HqF5yWNEi4FQtfx3a?=
 =?us-ascii?Q?XBVAzpb4JHKrqhRY7qfwAwNei09YIz+XF4qz/ISAQ6ox8bREr6SoBQ8QtHJc?=
 =?us-ascii?Q?OmwOluNmbnDJf7/fYjG/VkSiun7+AyQX6PXloefcFB98HPxlGNvWEiKXoBkI?=
 =?us-ascii?Q?7uNL5fp3ZkCUScfr+FjfenSg4HMP/nbP8fH/rjFhtf8DMaTTOyr7IJfShxeb?=
 =?us-ascii?Q?ZooofvRJ5AzkoakrVG1laImoMTyyhIUc2nGm0NxvG2q+1XpGHylwEOOoxcyQ?=
 =?us-ascii?Q?1Z8/Sv9UDSn7jetWH9Wv2ApdBqVXfKjLeVeUORqiBa80nJEujWHIH4LpQu79?=
 =?us-ascii?Q?ZQJrynf7JGLIoyTrFiQvWozh7RWT5f9igHbNnli42H/fa+CgHaPYitkwIGAn?=
 =?us-ascii?Q?x5LxuCi1iWJ28rqPdYlcFq8KyCqRlmHVPuTtGyrOgdpdvMffsVS4KVsnywLY?=
 =?us-ascii?Q?VBSIXbSkxS1/i+SukOK2ErpeElA+9Rq4uU4a+pbzFhwOYSG+ZZS3DElzF/FN?=
 =?us-ascii?Q?rpfUChydmaecEDCby4rzaCmrvfoINaxAZdm68tnNLzuxuvkdzx1KzkbFby+B?=
 =?us-ascii?Q?VJ4qG1QSUmCFU/AgjjbJh8avoi29ScdKJF0xLVt9Zjt8zXvq82OJ+EeZagjb?=
 =?us-ascii?Q?x3N+4FwmzuAsdr2LJVsS5j0MnweD+1gpLoEKwblpU/sXT9O9B8Y6hJKWbd+Y?=
 =?us-ascii?Q?lilIKLdZpwiDuBJIw3obFWdICXZj1z5orwY1OwWImKj9Co+3J630BLc81iVM?=
 =?us-ascii?Q?3QSy2qgS3HX1IdHul4bnIFmAvCeVokLmYohaoQx6iFFMVjiabMpz/o2L5rb9?=
 =?us-ascii?Q?NergQE9ZY4urjJs/ojMX1Ot/ArYvmfMSCx94YM3UH7oTpWJBY9NYOOu9Y0gW?=
X-MS-Exchange-AntiSpam-MessageData-1: jxitMnNuOv0kuhd1O7nEK7XhI2dTEWi4VI4=
X-Exchange-RoutingPolicyChecked:
	vmtb54KkwzDCIZ8U84LW9+wU/imBfBUP2Pvs6d8iNrPQFRB2A7B9MDHFCu3LNC7zv8qrom7IzP+gqquefI24BtHKwrBJ+J2rIpW6dYxfcL292IxQ7KUETf9EHAyU3WVJWnfKfOa/MWrqRYona1DqSFI03deYMF8irPBWSqWzOu1ya9b1UDmxJQR9GBDDrUEkvxph3cdvcYwF+zHy6ZX6+BslobIveglpRqGSNPmD6105DLJadOkqT3kw3QhEq1OOcCQL0BuqLS1WmO/icXKKWfNwHUATFfHbMAQCOgi2x0my9WVmBYTf0sqsLb3g/IY0ueajskswaUnAyAp99U6aBg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O5rL1+v88T5UoBoxI4WQXchThrGAnhX1FC+vqsL+0igAJTyiLzcHUUDDS9Z3bF1lat7r2n7jlc2SPzhl/N7E8/DchlJ6KjG6oJxfyvfsAW2uRBoMPWFcidNUd//Syj+zkJvFOhsdX7qvM3saPs7QzeNwd2UXbMRBJ92Xq9fC+h8keZrNaH2fnqf+qLTfDWbyG/l1aR9XK04EC6DndrEeAkvxH/ahxxCLdibC2cNAWd80JdDk+gWJ9MSgGTkZiiN6aFVdl5l68mHGIfODVoH3N5iuXw2UVbP22Mxo+i9jYhYp+ih3nA/maCLmFIlriYAoaUAoPwEoDzbTvWC4+ffkzAtGwKyUYR8k3s8Gn/PnkH0uJ08r4Rsg4rgZgvN+DGwqscYOQGq5+a3zYe6XHxoYJOs2doC0gGZpa+IEWLokh/oivMT1kxkpR+afN5Dp94jwHsumUrtEu1/c8b4Jf2tWp7IsR07sKjfprk+MrWC6H78nRKODY1UBFiL47dgYzWw5Ftg2tAusJHtnG59m95SbomMLg3fNbzMKgdxYdO8EPU4/WyW+F/kn4w7g6lZqV9Dm8vYJ1Qqh7N2d6vA6G52ZXzxGfh1kWgoeVYR6umtT5llfPjKlzkXqKHr1vovZWQb7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b4e57d-fc7d-4d75-3b0e-08df29eb41b5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:10.8962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hhln2gu4svIJ7JanjS6lQumiwTGnTtQ7RFR2HKM3xQYFbnvLxEiX+iksctWfNgaQ6KUxdrXNqbXRg6eDxg1L/xf8avhA64Ey8+cWU9opY+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

If the reclaim worker is relocating right now,
btrfs_reclaim_block_groups() bails out, because it can't either grab
the reclaim_bgs_lock or blocks on the exclusive operation.

Wait for it instead of failing the tickets while it is about to free a
zone.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/space-info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 72fa01502461..4ab18d8f5333 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -916,6 +916,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
 		break;
 	case RECLAIM_ZONES:
 		if (btrfs_is_zoned(fs_info)) {
+			flush_work(&fs_info->reclaim_bgs_work);
 			btrfs_reclaim_sweep(fs_info);
 			btrfs_delete_unused_bgs(fs_info);
 			btrfs_reclaim_block_groups(fs_info,
-- 
2.55.0

