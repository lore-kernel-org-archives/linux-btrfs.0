Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC4A494833
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634100; cv=fail; b=uCnxRYfVrIICRbCvaoa5v2Mpy5YN4Y0lQfkGHkPcPBAiyqHGTsPjy9UN6a4YeyocmXOKyKPm2cOTraPzdvbXKS7YZywiaU4SkpXyt3OOievvfhZR6euAqYuWTWSMJFIu/uZzzcUZZ3z0Q+yqMW6QpKSh3Hf2BpOcWLz+y9oSXgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634100; c=relaxed/simple;
	bh=n3MF6og1eIW4IkqVNzvoimUwH0mNjfncsqKZtyFPG5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t9ubuuriJmNAEBEfftY6pX16aaDsiiSJx7tzpOZCZR0T/syz7UKquYGM50j7MVBqvwDuifaGhMeAvOn7M13dlkiS0QxpqIuD0pDL+m7HoR2pCaK1uZVtb/wY7JZ8FqjpT4n36tPYObGkQq47XXdWL2NflTczniN9b990W7aEolc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AywAazCV; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=pVSqXXgM; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AywAazCV";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pVSqXXgM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634099; x=1823170099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=n3MF6og1eIW4IkqVNzvoimUwH0mNjfncsqKZtyFPG5A=;
  b=AywAazCVf+mFLbFuF4vbajWuiFlzQDA6pr/EnPplLb8xWSYaCto5HUn3
   tuDzgPG5pTtTJA+qoKVz9T+GufDic0OT+oXDS9O3QFiiiAx552QRhUNLI
   oRK5EFqsWWjh2I2iJuUQDKfXDEBReh0yXc5PxNBKwBmz+ovtML71ukqM2
   ft+qf7tMQ3kQn6DiPRMkMxyZkgzB7rQVNpyscQjKvuML74rvpRjwlABDy
   50wGiVPgLtaRRKip60VZFqcaof6J/Z3va8QBjb//EjMuM+twWGNeoSoju
   BbKvS24ddE4juMr3tuculeeMNUXga1HAK0JSyGOhMwB4tdzccBu8H/6bv
   w==;
X-CSE-ConnectionGUID: 41/ATZ4zQkqp1pgc7jg34g==
X-CSE-MsgGUID: SO4vVdOCRfefZFISUSgUSQ==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="157785433"
Received: from mail-eastus2azon11011020.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.20])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q3fjZW91tXsHZXMPGhZ+tiPNGcOnO9pXHe94uExTcELj5RpbWAs5zgDiM4iwIPY2gqA5WCBIzSe60WlsVJlXHhDdElQugs+FiHiQl3LGOla5KHMZmJQmlLEw+wQ1SzoGFdEGOXKYjfIHJOQ6e3GUXodgw/vu8OmSNV5fPWrKM4lp3uomCEhdkxYQOeBABsw7Df9jZP2PTYeajC/9Viv5uUoyX79Y6pWhyWhL4e1x9bNZ1iZtlHsFKGgfka9RuczilEzZdCl0mfEJvU+XyJpmn13vf692EbdzI+5Mtntlmi5u9UtM1IJkxSnHW9eTCWBML0C0B84s6vS9u9LFx11nvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z1m6v4VIHVLMQuPMHHERsiiiMd8zj2KM0Qsr5eaqRi4=;
 b=r95fLxa8EiMqW931SEfalq0FpZI/rBqZZgbf+9MwPV1ryR82YQ2Ta8h8bNiVFdKeoFCOF7WchMAH0u7a8pHLGcZatfzELg7QQ6R+f1bHTD7SCMRH8x0J/6lPFwZp4TT24ltCLtQwRZotMm22tutDK4mpOs1dgq53R+1P5HhvuKM4vzzfXxoF9OpEmERgHOP1d2U7KfPfd6N1PxRTBJ7B8+KopYXILvcvOaa7rNq64WT9BOGQINJ95BCl6ygy+UtxkTLKPAps73YABoASuAlvQsVaQ/hUXGtONZbMOhD5Z4D0OiTAgAIQWP6gyYDKjLuvzkKC2grSI3OHuALBwwimrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1m6v4VIHVLMQuPMHHERsiiiMd8zj2KM0Qsr5eaqRi4=;
 b=pVSqXXgMoRkxptHPFYOtEkzm7RWblvLlUyRRkcDapYePhghbrPBKrBaYNh/WpBi/oP2rdttpz1LoLxfaQ0AQTbYHYTgW7LHyYVEbuSwLT0KEU8Dc0ycbtxeOSXDnbGvMbHK4Y4RnU0HWTFzSJdeQxk60J75N1THQqoa0vAqiHJM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:10 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:10 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 03/12] btrfs: zoned: skip the append only metadata writeback path for conventional block groups
Date: Sat, 10 Oct 2026 14:06:13 +0200
Message-ID: <20261010120622.3781326-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
References: <20261010120622.3781326-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: bd822b2a-aa40-46fb-14cb-08df26c702fb
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|5023799004|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	AcZY3dptgaBmS7WrEEmK9iWxvx9Ei/OHhZ/hDhcESZmIhynj8QhiStZf5vyN2rUgTZtCG2EHnwTmJsh213RJS3iXm508IhaDmB+UtAjbRW9oDLTYXTFAP88DMlzuuvwWtHx1nVgOU822lteq2UzkBOzU6NPg6aWqf1wVTgc7QfhN1P8avEKDOirxsLiREptpEEfvd2hiJRhwKtJ9JMRQCFWGaSc16fWG/SQ/ZJbcm18fo6FXQazKZYjwPiTeFeIXemuEX8/6Vcl9ZvDgoxEzzuDATXfB+4JYAq5cqpRxGx7g89RhFiRwPL+m33pNWWvWKdUmeHB3K8akvmjgid+ZfZM7PEj7LJpNHCNefuyKIh97+lyD65TxZ9HJJotXGZkTdvkyQnn66jWHTslt76qKC1ZYrvb0SfEUk+BUW2JnzUv/EfVINIYCPdlyyibN9Rt/uVwfj/J98xcSCKqYg3cYynWD0vLcUxazOwTziYshIootMGwKfGJjRZE4kcA1WZu/FhVqe/O2+T8ZbkoMijt2maUt+mB5yPD9KdWXo0glLh5DytDTEfk17uPgUl61HLADMXrG/nW/4USspEdQa+Ak1mMnwIqRlJGfSkFQfw5Eh3Z0ZxHlztwC/Js4hpJokdCpQwoaRevNxkmw1nKsWVUBeev2zqKxzoptaD1MZ/xfOJ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(5023799004)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2hLY0lPwEBBeeU76Ep4o3WsSms71b7tLJKmUQSGB4hXtl5hl5xV0C0yNTMg5?=
 =?us-ascii?Q?izUglMLbtRiHqRpcjjSpAgH9e1/lm+Hm+5D8n/wXs4BDlglNfidLleqT1MD3?=
 =?us-ascii?Q?d/gYKFLaBi7n9St+pOZirOYGUEYlZZfnnlomZ0Wlp8vCFHwuJ/YcKuvV13JL?=
 =?us-ascii?Q?cbOD1YkZeJMOATuIHltA14tP2hFIATwuardQWvzjQ86Ct9Z8f6/2UBYAM8x8?=
 =?us-ascii?Q?OeyH68ky4NJ6faDwIi+NRLwPTyt3HLY3+5D6C598ogaM+RJZdHgMGevAEME2?=
 =?us-ascii?Q?u4btnwKe4muJ9kvTL31Nbj8iaGEMAanAN6Nx7UnmUdfSLS3VpCcqkt8lOWiV?=
 =?us-ascii?Q?Xe6i+9E086qHRbnUDuN0W1WgmDWRRgI2NNVQJFSczw99pLg3+JohFGWWFkBv?=
 =?us-ascii?Q?0lBZTkm8HXbTsmAWsmhHZqLcz15ansMPcrTerq7mANbtjXL6A+ijloR4yplt?=
 =?us-ascii?Q?q6Bb0WtWjgZKIOUaxF/j2kpywhKSkftHEVaM8Q4wzG8bOooa69bntMt5e+t5?=
 =?us-ascii?Q?RM2VSoQvjXPV8qZWfswNN7wxYZlM0GIIni5tKgux2MGCa19bTzQyEyf1/Sc/?=
 =?us-ascii?Q?nJ+J4Qs+YOx1lcyeGopKsyD0e2G0c9sN2Gad1fClNN48UeMtzRgDu0D4DkWz?=
 =?us-ascii?Q?wmvtOoYIeMiRFFDLFut+SK9vP0Mq9wfI58CXqV60xWgtD6zre4J2266HY6BF?=
 =?us-ascii?Q?UeK3DJHAEG6gQqgo5WWefPzU6jcN8Bz82efvFOf2kyoLF2Wa5ABmSVJaQxjR?=
 =?us-ascii?Q?GWWZsfDWPMuDljw2JE+Tj8JyKIHCq1W5P1tR1TgTcJg8XH/73UxzcuIm8hil?=
 =?us-ascii?Q?h0aszgzfnFdYVFLCkFGvVehFQjv7HaNxD9oU+o9JQnQL5OofK74usookrbOg?=
 =?us-ascii?Q?UEpdcCeeZUS+WF6GeGwOvs/GQQVIGpTPUA3RBzsSFXHq4BtiskZ6ZdQm3CTf?=
 =?us-ascii?Q?eQPIxo/7zfVE9ilHLSJpNby1VJjtXKGkOpd016i5tZm8193Gww7wQfoCDbmr?=
 =?us-ascii?Q?rj8uSv/8g8EQFEk0xavvG7EtRTsjTRtOcAPElL1Q/X18rlatGgeaAGLXfSmy?=
 =?us-ascii?Q?ptttowjMY2Q3aB7zFt7QWN0UP5tI0CFPg55S9xVfgylF9Qk2w4YBIu5UtJVE?=
 =?us-ascii?Q?7n2KqWor4VozO7Nor5jta+FlqB73ab8ZjbnrxSuIB6u/THGzDvlwdHv0Pr7s?=
 =?us-ascii?Q?FG25UHFsTEOJ2JdJ2A9UZwQh6ri0OZjQ9xbwmpScuN/RR/CJugYbkxG6kiqy?=
 =?us-ascii?Q?RuO7JAZOnGocU1dno6qhN/OHMX0ecSFb3kRqrLvlz7v7+5JBp7g4c1JcJ/6P?=
 =?us-ascii?Q?XuzV7mvjmvHI4qyx+zooqRdLzdpeVXmI2sdHoFeSz9lstz9Vi6CWVGktsZNd?=
 =?us-ascii?Q?Y59Lj+Eiq9FfxJRle2OGjnEnaMvZOAWwY7Fzgm1EpvcpgUVdzyFiGP0Rlq79?=
 =?us-ascii?Q?fDwVyM4vq0+0zqyDGwawv1Mdjg3ayQ8zLKl5CYTbr0OHtg8EVHe14Kl8c4oR?=
 =?us-ascii?Q?ylgZuTrtfYtIYyy3Zu0ihf3nNQP1sZjCmO12t97LlSDenaLMLECTbjk4swWf?=
 =?us-ascii?Q?vrSa5TIwVIXMCb/dqV6lurH7Jur42Rth8rxPsZ6lYeeZjP7x+cIYBkoFHmN+?=
 =?us-ascii?Q?+ofSCRS5r3UmDZrrMD2niAnodJ/bfNxERcaHRwuYkp/2l1FlB8jlVUivWxrt?=
 =?us-ascii?Q?R+SGASMSdadOuYEBXkTFML8CHgWweRKJW2LF7vGN2T8BUCuUloFFLykh+nnM?=
 =?us-ascii?Q?3jkh2CSQULkn5LF8PYZ0XC8LXK7FqOkCWkKPIxUADi0OlsdhP96F/8pVXq0u?=
X-MS-Exchange-AntiSpam-MessageData-1: Ygvkjyfcv4Ys8XL/5a/zvZygg1mc6nTA4HM=
X-Exchange-RoutingPolicyChecked:
	xXBV2VFRUA/oucLt5njrhZIW0Sr5Hy99623kV6BHwtMnbOnuxD9GRsHlnm6uNLaAFHWr6sIeB/1a17TvLxBpApCpNTBxdhcAUN6cH9EB64tuGoBqc1hdXUncyEY3rC3vLkNcGuxZuDFmlSfLqwIcrTHbrGfChIEsoJAm5CfuKoZY0MgoD5yu7+DEP+/ijYr8srsfUeuIvaCdkzXhvBwm+1IdnrQFlq+Iyg3fPDOFPKzMZXz7YoAXOUA3OIHu3bJ83F+eBd7t5eoanr6gPyuXekGaszZD/Jmaa2Mictb4XVpaOY96k//JZyVxBLRnVQOm8MpoWM1L05jVl8jVg0LQwQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BaZLHjkB+nfK8C11Tix3UT8yW0JUanmoS1Sefm5kUWOHxZ5l4TChDJH2fcRX9pWqxI4zCjN75gdUfvNjleHKe52biyTc/kRBm8Aqv7IDcfmZL5t1VqaZkXMtDiql+K9lnoSUahmUMLg6mdy2OHWMfnuLyLVDYG0rwwI+EAa99CbYSI4RysdFvXbbH72t33P9QLpFsObxdTOlmF3adiWbVPzp2EwLDoi4wcRCaBzK50HnmpgcHeSGa3u8O5YoeYlIVyb8wenCqbojNmYAsSxgnI2XUVTx8qu2PE2Un7aSF3wrfxnR2YmsqD5nfmEtszkVPCxxkh8xk6SEZwmIknN31ETlgj7b6bMNHxARf+C7Cq2tiSkuYC1OduOsQTw9LOQ6zue2GhRNw7YGv9OreULQUQ5nZXz0yF1wlZ+5B+rpUgJRy0p2TaRaXZwu4LG5sPR87SLMYzcjBUWJ4xPDfD0ALus/SOIDViACTKuZLUEPTNxXnksHoYcHMQNBEPnQlxS1hEM8ojm1VI/O63FM+Z49/HdHDQTlQ8/d3A3tFHHURMu4nt6oiNRm5APcg0eqth345vMHggbiqUvql9nsKhgupuyQKQs19zXeu5hnWFTk6WQUBGDyZS0rJXUeck2beyVb
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd822b2a-aa40-46fb-14cb-08df26c702fb
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:10.1227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0TI1x2y2ybhkfAgx1RVYRajqmWpDtX2FYvC/+NvrF+8RUbbfsz09uqye8p+M01oYZk6HUsNF6Y7Z7+OtocTO1VPHwCEkedQdY7BzL8SY5oU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

Metadata living in a block group backed by conventional zones only can
be overwritten in place and in arbitrary order. There is no write
pointer to honour, so there is no need to serialize the extent buffer
writeback against block_group::meta_write_pointer, to keep a zone
active, or to write out a freed tree block as zeros just to advance the
write pointer.

Add btrfs_zoned_bg_is_append_only() and use it to bypass all of that
for such block groups, which lets metadata writeback proceed out of
order and with a queue depth larger than one.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  6 +++---
 fs/btrfs/extent_io.c   | 10 +++++-----
 fs/btrfs/zoned.c       | 23 ++++++++++++++++++++++-
 fs/btrfs/zoned.h       | 21 +++++++++++++++++++++
 4 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8ff21dde9a46..bd17880039d3 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -64,11 +64,11 @@ int btrfs_should_fragment_free_space(const struct btrfs_block_group *block_group
 
 static inline bool has_unwritten_metadata(struct btrfs_block_group *block_group)
 {
-	/* The meta_write_pointer is available only on the zoned setup. */
-	if (!btrfs_is_zoned(block_group->fs_info))
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
 		return false;
 
-	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
+	/* The meta_write_pointer is tracked for append only block groups only. */
+	if (!btrfs_zoned_bg_is_append_only(block_group))
 		return false;
 
 	return block_group->start + block_group->alloc_offset >
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 55e9144d4759..bd745b913d15 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2535,8 +2535,7 @@ static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
 	if (!lock_extent_buffer_for_io(eb, wbc))
 		return 0;
 
-	/* Implies write in zoned mode. */
-	if (ctx->zoned_bg) {
+	if (ctx->zoned_bg && btrfs_zoned_bg_is_append_only(ctx->zoned_bg)) {
 		/* Mark the last eb in the block group. */
 		btrfs_schedule_zone_finish_bg(ctx->zoned_bg, eb);
 		ctx->zoned_bg->meta_write_pointer += eb->len;
@@ -4170,13 +4169,14 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 	/*
 	 * Instead of clearing the dirty flag off of the buffer, mark it as
 	 * EXTENT_BUFFER_ZONED_ZEROOUT. This allows us to preserve
-	 * write-ordering in zoned mode, without the need to later re-dirty
-	 * the extent_buffer.
+	 * write-ordering in append only block groups, without the need to
+	 * later re-dirty the extent_buffer.
 	 *
 	 * The actual zeroout of the buffer will happen later in
 	 * btree_csum_one_bio.
 	 */
-	if (btrfs_is_zoned(fs_info) && test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags) &&
+	    btrfs_zoned_meta_is_append_only(fs_info, eb->start)) {
 		set_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags);
 		return;
 	}
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index f69c03a3b42b..5d1bf158b7b6 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2301,6 +2301,9 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 		ctx->zoned_bg = block_group;
 	}
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return 0;
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
@@ -2328,6 +2331,24 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return -EBUSY;
 }
 
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical)
+{
+	struct btrfs_block_group *bg;
+	bool ret;
+
+	if (!btrfs_is_zoned(fs_info))
+		return false;
+
+	bg = btrfs_lookup_block_group(fs_info, logical);
+	if (!bg)
+		return false;
+
+	ret = btrfs_zoned_bg_is_append_only(bg);
+	btrfs_put_block_group(bg);
+
+	return ret;
+}
+
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length)
 {
 	if (!btrfs_dev_is_sequential(device, physical))
@@ -2578,7 +2599,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	}
 
 	/* Check if we have unwritten allocated space */
-	if (is_metadata &&
+	if (is_metadata && btrfs_zoned_bg_is_append_only(block_group) &&
 	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
 		spin_unlock(&block_group->lock);
 		return -EAGAIN;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 8d3c32f29e65..bd1ffbb62805 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -77,6 +77,7 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
 void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
 int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 				   struct btrfs_eb_write_context *ctx);
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical);
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length);
 int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 				  u64 physical_start, u64 physical_pos);
@@ -215,6 +216,12 @@ static inline int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info,
+						   u64 logical)
+{
+	return false;
+}
+
 static inline int btrfs_zoned_issue_zeroout(struct btrfs_device *device,
 					    u64 physical, u64 length)
 {
@@ -437,4 +444,18 @@ static inline bool btrfs_zoned_bg_is_conventional(const struct btrfs_block_group
 	return !test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags);
 }
 
+/*
+ * Data is always allocated append only, even on conventional zones. Metadata
+ * only has to be, if the block group has at least one sequential zone.
+ */
+static inline bool btrfs_zoned_bg_is_append_only(const struct btrfs_block_group *bg)
+{
+	if (!btrfs_is_zoned(bg->fs_info))
+		return false;
+	if (bg->flags & BTRFS_BLOCK_GROUP_DATA)
+		return true;
+
+	return !btrfs_zoned_bg_is_conventional(bg);
+}
+
 #endif
-- 
2.55.0

