Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590134;
	b=DxApKkmdsZH5xyr+6+jQKZaJxmYyTNuqIiv9MwIbrKpwddkr8amWRLMy+6HeAdIJteQx
	 LHwko/TGlgVPis8qtY7yI3uO02LWASQJlkG4dN57yXEPW4hYQ56FohcXsoFV8Zytg6rcz
	 Fc3MU8FmHkm+zEbvR9bwqZBf0FgqM5OVZsiD92q2eb3UegV54pxS6JN+htGHuJpoGacon
	 TSKMoU65XHhs+xtmkmb0LkSJT2wm/Ql3bkyT/TraBDympoRu32uPu2enJS29MaBjFi9HN
	 OE0TTdXy1Wu/r7zEal+S1eCeIPYuGe8kzKlv7ea6AeGdA9xcaaEOZaWZnXD0WE8oVOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590134;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
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
	bh=Dv9d56TNTYzFL8SD+4yK3m4ZYl0j11//kpB2LABKPAA=;
	b=SKk4oL2bauBjdhToCRNKSPvAMRRxyI1X7QAUvuYp5EUJagN+qO+/bY49SwcZwQN6P0rq
	 0f047st+weGQObgIQJ9dAvfUYs7SOzmpJv48yqdN7/d8lfpTFps40WZVC5Q09UKbZKikd
	 cWMkAuyJyNlN3J/+FnhsloXthQwqEr/S84AyBHGaPKiDBM/T4ZBBgErE67AMdTLEQ2wVZ
	 O3RpC0dtrxoahzlfhcKSta2ednBSLn3BGWRej7yg6FLBbCN9A3yw0AuB3IpoGWX1NCpk3
	 qiIdmXma4EIeQzvd5m/4OFI5wTY3fCUxYQb0/iTF6TvlsdSl8IkSzS0UudawV96mHGA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BrMN5BBe;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CHOgldsW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7096A606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7096A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BrMN5BBe;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=CHOgldsW
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590133; x=1824126133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=uKGwrG9PdH/lWXPEJeYcQt1QFToXbYwJz+lJEzRvmC8=;
  b=BrMN5BBexICsld5X8CrKpWUwBvXhV/vSXxX5Gln5UhoZGwiAlHFd69Bk
   7hhHjWPXD58Xt0zd5UmivvikF5zPRdVs0C/9QnpmsO65xeF5Ir90y1iO3
   QFHMWrmvHKOB4ip7MBXaOQ8l6DHuOPQgV3SZ2LEONtqWDYVuDexsyyg9K
   86gkIGAMFVcFZJQTg4s1uNKrOdgyUohR5cysnwUe5I7ythzQsl2yjPNRX
   xIzWgiMyP27GTU5EvvR5kx+d/lUYxL80oaFKwppviwA35/v5yr1eUSUFR
   q/mqUgWYE2eqF4NHnBqtMN7Gsub3UqsRZLcMwIT7JnMjeLPQTkrgD0QXO
   A==;
X-CSE-ConnectionGUID: TfephBI/QhWiLkJ0DyGhsA==
X-CSE-MsgGUID: OUI2P3IDRzKxK3WW1euctg==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="159601498"
Received: from mail-westusazon11012046.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.46])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SzCvwtPpIfKORedGN3cR5he0uGCsrzLDmN2/K6YS76HyIKcrHHTAXVmIm3+K1UJbKu3bxuwbacqNiEWuCRcwmFc+EpEJ3a9f0QfVihCnJqEDMm9QkZBUXO+jjeyEnwk+g9JJuIk7I1I5xVJ7ht+QxxmQg7dZZkFdJzSCWk9ssx9JRNn88KiQQdSOEOakQYvFmaGNDulTxVeyayTNjHnc9g55kb3jeYKUOcmdPZ6vQzCSWZvnhQEmmE0hov48cPk35ECgxgdMmQub10TQWp3VvfP9iUnmMS6RKRHEs8OmLcYZHCgmaxS2HAanAEkJrniYcdRc/6UYZT7y/FDV+uYGzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dv9d56TNTYzFL8SD+4yK3m4ZYl0j11//kpB2LABKPAA=;
 b=L0WxKnlnOBaPSHqc2fpMcIvM3LkpcOc6DS9mHF6kR4gzOLrxdMyzRHi9SjR4+//8Oj9oFU1okBMxNnpNQUZJsWNl2b9aK6G9a/8F9GOyD3xeColGMQ8zWYBiCFXpbY5k87NSYzr4aal1dfj3r4o6HdS+cy87+iPwqX2TOT6Og4onzNlS+7QE9+hPSWJeDx/X9TJN0Jeka0EYvyfOQ/T7ZBDsFJqnAQBwa729BgLZWGh4G45GhXsfrCXAo8NPa1Gkm8OTR8V6CG3/OwFFwbjsGkTFgdUW25jVS53MY2bs2oskDz3sREAEfKQV29F+d7DkShkqnFueQlKKBP434KL8qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dv9d56TNTYzFL8SD+4yK3m4ZYl0j11//kpB2LABKPAA=;
 b=CHOgldsWj6kZv56bV00D4lvkAyJnXw0NoBEcSCwNYprepz5V7Ne7qIhPAlZC1H/ZstrctXH83UVE1Y6uASySfaQutBwXD7rLOq0Ht6povI0Z32mBc5cV/JJReF/D4mxlMV39sNMs6mqlIXJ7omcw3JQOTYXeCUoUTBZVm0vGnJo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by IA4PR04MB446465.namprd04.prod.outlook.com (2603:10b6:207:13d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:41:49 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:41:48 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 03/25] btrfs: zoned: skip the append only metadata writeback path for conventional block groups
Date: Wed, 21 Oct 2026 15:41:02 +0200
Message-ID: <20261021134124.2338902-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
References: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|IA4PR04MB446465:EE_
X-MS-Office365-Filtering-Correlation-Id: e09a8416-7711-4880-9988-08df2f790db8
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|366016|1800799024|376014|23010399003|10070799003|6133799003|10067099003|18002099003|22082099003|5023799004|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 TI/v9qMnWFerYavb/yxQhX6Jkus/SCxpZZ7N21ZPlTIuoHYL5yBslz9oJfN+nYJV/R34zbfP2THmENsZAz3yT05lanAUjG3rJNQedrkkYnHrQ8QFuT9MekLLaBnrtMt3asmp/CviDTrSZbu2ivmlTGPwPpKeB5KtvV8wm8VhTdGP7KD4Z6c0OQy0Ypi3xvT61+Avcgsru4UWBRDTVwKRNq/vtjKqAiVkehxcPfwYk6fZ1oEqRgsQGBao18plAzY/6ZcAzSU3S1TRp8yPy2oxM4tqHKbwkr++yNhqex81xNKdRDc2bxIQxJ5MXJx29E5ZtD2uePuDQ6+8lHETPeJ34x07aRwiNzRnDcMhYmKRv3g6VlrJ7Fw1tRfkDovaW66JVCox1k0gt0f/8ZmzkspCxVhdx6e6zO1x4Dzn61zTu58GETa+gqcgnMTlQOHfrluShYWLEMmWrXG06YnexlRNMoFw3m1huyFie/k7k/sezEN3BYk2bhJqgNsfeHWi11mHPrmGrq41txXKjvIlylV5hnb7jZELOKVpEwgaUHenIRFri0GSPH0oGMgPcJx+GginOdT9Jno+IQ+Y05x6iMVYp1gGfYM6E7n69Pn+t/c6hTQjA6CR2ifArlhFI3X9S9E9qmjP27Yht0YvpHK+PcBLs0gFeBpepZU6zkmVDlcjJMo=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(376014)(23010399003)(10070799003)(6133799003)(10067099003)(18002099003)(22082099003)(5023799004)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?ZMQzOcXdE4quj3SbpbPC+2uAouBfHVm1f/iveBToRsgupXHxTxyk7Xsnf9tU?=
 =?us-ascii?Q?fGti/y2p1/PTKMFDER8nvWWx7Aq2hdCH/27EIS/lvI88gf3/KY3AooiPDoHY?=
 =?us-ascii?Q?eYGQk7QS3uAk1l5wPj5mYIfaXJe5awleZnAF1Nzhd/CYfyqcCLQMKJqDN6iD?=
 =?us-ascii?Q?FEHLU8Ib+pjCXcWnHYMrSLfQ6KffJlSuv/tQFYUT59DAD9BSAhRnxGje2LMh?=
 =?us-ascii?Q?bkM0PU+uOqc1I/A0POEkH4MC081bGDDZEfq3SPKZ9v38PRbUVLRBl9V1w8Np?=
 =?us-ascii?Q?KlSVr1+Ca2UszI1nU90NtAdqr4IcIqSqQDEdiq6i66/KUM9IJYrlu3oIZW60?=
 =?us-ascii?Q?5f52MgS9+u598YtlUpmkgyy/Dik6yoFYbtnCd8AcDQB22iCY1ljv98KErJNq?=
 =?us-ascii?Q?mNuHD6aqeb8Y7RXJUoGSeLwAraQq8o0ZV+3U0MAby+u7ZN/bd3QDBUFJt5Gy?=
 =?us-ascii?Q?TgC2eys/W29VzsgiDmEQ1GQADsiXprKsh1w4XBEMJkpNwyf40STiXj+rqTt7?=
 =?us-ascii?Q?ePpsFlUzBJ36uKiNvOIvl+wOnXPe7GPPer/MFk/Hr/FyTowXU1vJWAVxicUy?=
 =?us-ascii?Q?/cPd5DQOi5ey/ssUwWFWVx6de7YVIhj0ktwIZy8oCeFPNUe9F/RXNIdSd+Ck?=
 =?us-ascii?Q?zla2LudN2hp8ROmQzdwRbqjOd4B3+QyzhPEZdxjh9QTO6vuEegoGEhnUb+ro?=
 =?us-ascii?Q?gqq0Aly5IxF7TLPZQUFqZHrx6FwLYTLfDLrNXi5AyUyO6F2W7wF0DL09/GCg?=
 =?us-ascii?Q?WpdgJVClYfELurbQSPNVH3GJuUm2Ogq1PLysVx7m0Y3YXoi8JKB85/ZwI8eg?=
 =?us-ascii?Q?boeVdzh5BltjG5W4fQn8Tg9ZsLZFbvCRVTF8scQqf2G8kHEE0LDmYUsZqe48?=
 =?us-ascii?Q?T6C4UhUJ0CY1No84eBfCFNOJ5uRz2IdG9j2sshOUy6kHI6sJ9EyeAmXwdy7p?=
 =?us-ascii?Q?8AifZbaDL5ainRiKzRCx6JVFAkr/bIlo/MneGj3B7m9Z20oaDi4xzOpFbTl7?=
 =?us-ascii?Q?b+Aka0wunR1SdhmNibu8mSbbh7unDSI2DlBIbTvOWifDR7XH7UZpsgMWBGX8?=
 =?us-ascii?Q?EXp26Kqaj1irnT9DHHCITVpc27N3k7ZKdg+pXqWlnrQfi9+5sPD6wWRmAsfS?=
 =?us-ascii?Q?D0XQjzdfVBazrZDDhrpcFKudoQnokdVPYmBSsB10lZVF/9YLcfCEj42QdaBq?=
 =?us-ascii?Q?lLA0Pz3Ra7hWGynJjAjWF+aUriiznaIvGLId7J1CwRIT7uscgQPlLKLLqN51?=
 =?us-ascii?Q?7H1jp7MZ3EcjA0azunDfvzfljPNURdKMfAvyzEO5Pz9MUbrqlvosACOBQ63h?=
 =?us-ascii?Q?gUCCG4xgk8NjPS0SNSCbG2429JvHbEUP00hosvzzNtH9G0afEYUXrGU1Hysi?=
 =?us-ascii?Q?w4K0Nvf0UokNLt79tcRPUHr6ZoMpIbKA9uaFgBYdOdbsba63H5UxXvdJmtBZ?=
 =?us-ascii?Q?WOF2C+i9K3WPWZSaO4Wdxh7m7yjocp6GuKL2nX+j/1ovjO1YdM5mTo7aOEgF?=
 =?us-ascii?Q?Mo95wZXqnfx+vCbtMfB8AO/qtnBzsK04jfBIm4mATnOj/1YxWPdUFHvarTzH?=
 =?us-ascii?Q?tItzRnZI5htriKi0M/DY8D8XgGaS+VlcemaGw8rb6tTYwloMrPkNaWBz4KVu?=
 =?us-ascii?Q?7YOKxct4o60IR4ifeetAcdfMLVhUZRWmh2GpALTir0Ak8R1I0aPETZHE8Q9r?=
 =?us-ascii?Q?+QQg7xvo89Nvp2p4a86B+ubVnplP11pGUGdpl3oGHIzXeilR4TESIPTMlYBq?=
 =?us-ascii?Q?UECsrcaix6mBCrBtqvGuRPu8a5DskarvvVyqfwkbGEdb49xbaayQvuYAED/O?=
X-MS-Exchange-AntiSpam-MessageData-1: z/vMJIf59ZFkjQlQMyTY0j5TisU5mY+gICE=
X-Exchange-RoutingPolicyChecked:
	qe3jpCcL90W5OiqwrrdpHGNaPSuYPCg/bFOIvmgMuTZKOhMgpu1QBQPIc1oBJz+h30EAWVfSo7wDLWmxcv9hrpDS803V5MNb2x6LsWM7KO8vwPlaqHVm87+IZyE/qaK07ClPi5uBAM3G2S+F8WAEkmkaqd0+Zq/tEsmmcTGjzbvhrrfQKLkYTiqpJITWHgC0K1WTfhCGfbR6udArFxgcSy+3lPEgnPUghPlTZf1irlZmIg903sj5azyUffhL0po7ypLuWLzvXHEpSwTYUzQNRPQkxc7SbCXAY/qy0l+BACqz7JP38lLXdgmOx+eywee/vix2xnfbJmnYV/PTuDHXZg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pMELwuDLNytLnWYoUj084RV6rDypUH7x+n4dqLMzPttWcyt0VpsOEAW1pNilXIkevQvkfm679aqr+Ygjy+RlV/Fa+m6qzTbVJAgWWaEyHFziJGIVOaWrVvoVXNCBsUU1FFq3mNgOOsY/1B6IXu6iSYSAOF8JAE2iQcFQ5suVTv+V6vf1ivEG6ZYFcOPGtWiX3YMuteLCp0oXuvgnh81+snMwunwbf+9qqQ5/OjZeI7En2KU7sasyiLjdmtJVya1wavaGk/rQjBPea2YxT2QO1V23CNJ8eaQ3Lcv6XzNU/agbSQ2D4MLsb8vd71GGWLk24YB6igtn/7Q5DcJgCnuOStIA00V5fYVe/8JTrvIS0mWgG7Kz6KWmzdLrNH+JsBkZvrez3jDv6nUPuAp3RmyzHQEILGiCNUQvF98IMjxtVdIPk78tftB9ITMpDKtD++u/FRJPL1QSflEZHJeu+eIUcMLv9FDHwco4oZV19STbjSSx6nsiZr1KHQi6AnVbvZXiTPNGLMSVqtqaBJ32VQd7eoEtoh5dQlyejnwIPtpsQBAQR+YFCapf0MTGE+ldLtSXPtRMVaDDNA+q5JfASUXN+0kceCVcAvU9TrwTBjWDw+U494eTKwfq8D5iB1CFeWIY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e09a8416-7711-4880-9988-08df2f790db8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:41:47.8835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8jjbe68vA3DreVobr5grqnhx5ay7LLCFzzNUwMzkNXJtfeHn603gDc3pZvPkPUlvdnsAwgk38pgUwAZrcwqK15aJk2Ao2YYMdtECKnlX3hU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR04MB446465

Metadata living in a block group backed by conventional zones only can
be overwritten in place and in arbitrary order. There is no write
pointer to honour, so there is no need to serialize the extent buffer
writeback against block_group::meta_write_pointer, to keep a zone
active, or to write out a freed tree block as zeros just to advance the
write pointer.

Add btrfs_zoned_bg_is_append_only() and use it to bypass all of that
for such block groups, which lets metadata writeback proceed out of
order and with a queue depth larger than one.

Freeing a dirty tree block needs to know whether its block group is
append only. Count metadata block groups with and without sequential
zones, so the block group lookup is only needed if both kinds exist.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  7 ++++---
 fs/btrfs/extent_io.c   | 10 +++++-----
 fs/btrfs/fs.h          |  2 ++
 fs/btrfs/zoned.c       | 29 ++++++++++++++++++++++++++++-
 fs/btrfs/zoned.h       | 34 ++++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index f1c663e81d9d..93f3251f93e6 100644
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
@@ -1204,6 +1204,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	rb_erase_cached(&block_group->cache_node,
 			&fs_info->block_group_cache_tree);
 	RB_CLEAR_NODE(&block_group->cache_node);
+	btrfs_zoned_account_meta_bg(block_group, -1);
 
 	/* Once for the block groups rbtree */
 	btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5ff630630490..8b49581eeffa 100644
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
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d61..1597bd4512d6 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -919,6 +919,8 @@ struct btrfs_fs_info {
 	u64 max_zone_append_size;
 
 	struct mutex zoned_meta_io_lock;
+	atomic_t zoned_seq_meta_bgs;
+	atomic_t zoned_conv_meta_bgs;
 	spinlock_t treelog_bg_lock;
 	u64 treelog_bg;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ee5998b8e269..c65f1b4f6dbe 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2019,6 +2019,7 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	}
 
 	if (!ret) {
+		btrfs_zoned_account_meta_bg(cache, 1);
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
 			spin_lock(&fs_info->zone_active_bgs_lock);
@@ -2300,6 +2301,9 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 		ctx->zoned_bg = block_group;
 	}
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return 0;
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
@@ -2327,6 +2331,29 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
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
+	if (!atomic_read(&fs_info->zoned_conv_meta_bgs))
+		return true;
+	if (!atomic_read(&fs_info->zoned_seq_meta_bgs))
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
@@ -2595,7 +2622,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	}
 
 	/* Check if we have unwritten allocated space */
-	if (is_metadata &&
+	if (is_metadata && btrfs_zoned_bg_is_append_only(block_group) &&
 	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
 		spin_unlock(&block_group->lock);
 		return -EAGAIN;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 8e21a836f858..3a2ca8bd68e5 100644
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
@@ -432,4 +439,31 @@ static inline bool btrfs_zoned_bg_is_full(const struct btrfs_block_group *bg)
 	return (bg->alloc_offset == bg->zone_capacity);
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
+	return test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags);
+}
+
+static inline void btrfs_zoned_account_meta_bg(struct btrfs_block_group *bg, int delta)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+
+	if (!btrfs_is_zoned(fs_info) || (bg->flags & BTRFS_BLOCK_GROUP_DATA))
+		return;
+
+	if (test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags))
+		atomic_add(delta, &fs_info->zoned_seq_meta_bgs);
+	else
+		atomic_add(delta, &fs_info->zoned_conv_meta_bgs);
+}
+
 #endif
-- 
2.56.0

