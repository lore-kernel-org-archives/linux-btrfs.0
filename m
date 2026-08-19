Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9AC36212F;
	Wed, 19 Aug 2026 13:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787145437; cv=fail; b=eFjk8AYHMudz7ljYnQP251dUTFEaLcGZPMw8uAoZgsknI9LlWWwm67eXbjCse7vRtxfRJEXctq1klPcofZAqYK/EK1cFwPZyHzePdQgaYeTVpNeiALOB7LWvi2+602MsQzDuRI8lXtxREjpSxEGkNbl50X5wwNAJY+x+tqs2SUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787145437; c=relaxed/simple;
	bh=ULnSxiXZCaXgTvptff+OmqeujFONvnVN3wVnc6/JXBU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DPessWf9EoYzJUHIiAsgerAMtbYa90EkVkXbwnDhN+KMxnCweHcBj8kIsyN/jz7SMJk9WEh+oK+K+yNVAYR+OTGe56fymbsTAz0IlrSYkVivfSGNSR37nbmXQxgXuIWCdjrljYzedou7uZIZL+fs+5r50lFHt5NXMP/Va2pAQsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ODWybw2m; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=i0gjIlOl; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ODWybw2m";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="i0gjIlOl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787145435; x=1818681435;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=ULnSxiXZCaXgTvptff+OmqeujFONvnVN3wVnc6/JXBU=;
  b=ODWybw2mgcZ0y/dtC4VWeFvR1/O0TXG7Dx/CVPDi5OGFwP2MK/POoDyR
   7O+cGshGgHMnlUMZVp5VRsLAzkXUOJQnJvC8IEGPWL2b2w65BeBd+Bdl5
   +M6oyKKPamN5E6Y5bee7bEt2Tna8g8ON6Gi7vwGmPf4FG0NwGAZDjcfJY
   ODMu7Tw2TPYH+wJWp3v5znVMGYE87b9viuxQSW1KSy9LwyMqzP9EdLJfR
   BUjHj9CrMIWCLLfatjvFM5+ztmSeWJy17aEeEe4ZStPwWsKEMmmcVyHuO
   G9LZ+QrUd6rlmYaRdFKTeFOpJXzTIq40snohRg+aqKpWRl08M8HLDfQ2k
   g==;
X-CSE-ConnectionGUID: WuoePZV6SJStfcfdp6ZR1g==
X-CSE-MsgGUID: v0S6Lf5GRaKn4q75Q3GgAA==
X-IronPort-AV: E=Sophos;i="6.25,231,1779120000"; 
   d="scan'208";a="149653759"
Received: from mail-eastusazon11011023.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.23])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Aug 2026 21:17:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q/1HJIBwoi4/uiSvAErVIJPRJfL73fPwUoP12wSxy7ieYxpV644NIMQkKzU6g/eOaB7Nnpj3kXf34ZcbeFFLrBsBe1F1vzDrU2Io/tNUB7BI56TbVwXeJiFGJoBvozVRqMrDr7TT9rmE9AcccDg4iFgcdj1yjzx8Z5UHfVEHgUtvD0qzlkMVr77KQ02l5aMBmCwMyuE2w5MxXjoUBE2BmBvryQd7egkstl9TyOs7jEkWhxXXwsCD2F7ubwGv9N2jhIkrkYOZD72kKqIfopRrrSXgKn/lh2psJrsIeNfMhp6BdRlZW58bbKBoo/kiEMWWVMhpfMD28cJQgFbD9k+WmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8pVoqSivOhB1078vvUWqw6hCcbeAM3KRV5rff/fw8C8=;
 b=lfgNJiCuEp84M1iFzLLgJLu9Om3djUTsN7t+x7AssgQbDiQX2TK8ZtfQ+HknR9GLU8IY73CIvCyE56kyQ+4biNM1pd4JRPR0ZkFsdDS5Rz6B3oYn8+C1O34pNIBJca77n7Yx3zGTdZLcDl6ii3FtOUdvWjKSF54DA/A3U7AzWc9WEvJoPU8WJE9DIQJTRXLyesW5MKmQsIJT9XDndazZ2JSthX/OKfwluCd1Z07vjCR/OQUp5Pgzz1TcU1CUZPpO56Q+ywEleTOcDvNAocx+EAsR7AIHtqWPjpVmwDKEloYkphGUaNKDmgUfzVJcmyyHK59+mykBCziBmL1Qw8Fl8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pVoqSivOhB1078vvUWqw6hCcbeAM3KRV5rff/fw8C8=;
 b=i0gjIlOl/ika1dXBPM59wthA5PPHpqXuNq6RVXo5QN5o216s2J54rVp7Vt7v04KyuoEk6ihpudCipYCz8uZcauAP4RETjcOFMuw6vpPdlflhglKYpi4Qhz/+twj4+Mk2Tcn7X7lYkQRdH9TVlXCa0SqGKdbEMHcA8tiPcvRqwtE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA0PR04MB7385.namprd04.prod.outlook.com (2603:10b6:806:db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 13:17:06 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 13:17:06 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 0/5] fstests: misc fixes for zoned btrfs
Date: Wed, 19 Aug 2026 15:16:00 +0200
Message-ID: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0396.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA0PR04MB7385:EE_
X-MS-Office365-Filtering-Correlation-Id: 228e6e92-3e59-432a-56ab-08defdf42a97
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|23010399003|19092799006|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	x2RAPfPbXvtOUXVRLEdZVFBPyj6iYwJeZzJjd97qKie7SbRgS5pzraRbd1FJM0xFcYslywKYQUvvGjkxtZSq+pZQtp5/VkVHfAsL8NKDKf0vulkrkTU4Blg33lpgPSAJOx7QQR1ai1aRHDHv/rclzeoUT51Rha4Ov/2SiyzHZ945WQoHzFAv8GCeJikxc3ya9h7m27Pdzixr4wvLvdvbv+Q/HXA4FNemIKKG2Hf8JGMKLf8zGOp92AB/3K8pqjvJlCCwt8J7IkhGlPL9h1PfQitAAuFEaJcswDyiwsvl9nnd9ZSGychLLuW2X5h188+2ibOB8lna5+ISsXCRIPnkneWrypXO6Mn5MyRDqdhmNyMT5umHCie5d7OdnQBoU5BRMJpYwJ6qcMmvYYYAPt2mhgnY2s2Gem4BobZ896ztvCt/J/O7HdbEC/0+fuVRWcGfSGG1zc0p1oatr4+GWFgPp68yMtpS5xHftWHLCsKIuC4qZ/C0qBvBYK2MGbQqOo32lNWk++tvHI5j2qxeqxxfYnUv9MWcAqWOMJZHK5MUBFdAHwYkPvIEpglvzfx5SFGVKtg3npshEyILvJRL4CI8AZLveX4kfnnY8hle9iky0xMGLWplSTuqS8tpKgYkpy8b3UfQDwL+LO5QA9N9pfJLb57qdKoupw2wsz4Q57zUeMg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(23010399003)(19092799006)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sfg+iV1bE2t7aMQnJNN+tQnTN/G0NHizsyKio6sFz9bDBD/osWVgrSh+fGqc?=
 =?us-ascii?Q?KwpZLwu4Uh4XOjStdpvnnn2P3/wM0FMl+WBJf+TXjI5BYhSQO9zzTY4eVhnT?=
 =?us-ascii?Q?pYBplH1pqZjrg+iXOOVcQRjwzLEUKi4/aP/Nvpd1j1gfX9na8eeTTtsMRkZm?=
 =?us-ascii?Q?Wio3e99TZfS04InrvN4O4m4q8fwera+cdTEQcCW27449+lqDkcG9MtMqi+aF?=
 =?us-ascii?Q?FD+sJH0kfIXUBtbYvB2HyHZ9SvYF9Q7tF5LWVh7TJnUjhpKk3LIBh6vJMcZ/?=
 =?us-ascii?Q?ThKR+v3mDLSaH5KBaa/oIXVhamqsnGwVa/BIVvzpyBIiLMz3xQuXZ72GXia9?=
 =?us-ascii?Q?Fk8BvoGBtNeTXywZ4fO8C/Ku6IwJCf6xXenxMoFFPud2911h4Fcx2nOvZWJa?=
 =?us-ascii?Q?E2Z13RKfOdUjIZ+KP1OcQyt1m9u6QW4TJhLjs/1JemSoLbAz6F8WazodnyrQ?=
 =?us-ascii?Q?rbJ95LWPw79xlrMMvmq0wA5uQzsplFZU6MK5IeaO/obH23CoCkc/axUOnHUl?=
 =?us-ascii?Q?mzzPcgxGX8X6JkMRmMtpcZWLsllNf+qIGbnAVwN13H5RmQuaqCOtk27mMEAp?=
 =?us-ascii?Q?8juoWEFiv+NIZXZRvxU+lMU4HIQ7X8bT6GWUzKaxskJslh2YaJzdIIvi9HSz?=
 =?us-ascii?Q?NB4/scVRlYUGpmqF9wcCoFHHGMBcFLTr72MHOoly8V8bCvIDffoh3ziViLBt?=
 =?us-ascii?Q?BkhcPm33ohsEa+xH1hRDX6tkepmoVrXrlO/rdNvUlGs//IfdpfNr9tMRBewZ?=
 =?us-ascii?Q?b2Ja8k/q6LYdunZz5bSlCuS6E2IgBXEhvd7/0SLA3cFoiaiELcpiVLH0qujS?=
 =?us-ascii?Q?nATsebZVZCOBvJ2RDp9ICL6D4mlJ2nee1mA6ZZhXwUOiRzAmPIRk4zH3gXqK?=
 =?us-ascii?Q?n8LXO7SOIQtUlJGtdt7c2Kd/hVtiEe26qC+8y2VqGrjJS2cP5KchHSQP+CAF?=
 =?us-ascii?Q?xaBWXx4rvySrKE8fiCpAqxZOBChjhv7pBngC5M38A52rMw6jEr054fi90qwM?=
 =?us-ascii?Q?Y2JCZBIP635Wt0yAZ9/i8KsEDSN25vii8weuRm4oGZUwApm6hY5bTXiPc4Ev?=
 =?us-ascii?Q?1Twt1BK5o3nAgkW0rQ06lP0rS1jEf364GicMKMtHsn3Ir9eAuFM8hCJa7Nv2?=
 =?us-ascii?Q?JGJp9s+/29NGqivvnFznbJvfbPB8rS+gj5P4cXTCNSGZPFSQCWsiRY5IGWxn?=
 =?us-ascii?Q?3U9mGRBcdEo60cwq2D16IbGuNISivAfCHqYZ5l3B7qu+Q6hpSuypdbHRN580?=
 =?us-ascii?Q?3Q7gnmRaR6fzcQy/m6RVJF4jZf5e9M3oa+xbNfIfzf/MU2LT0FMbktOrwsXK?=
 =?us-ascii?Q?gDBS976EHw6BmM8e9c/c7VdH5RzREtQHQ1Rckv9arZFwxViWrVchprh9/Ev8?=
 =?us-ascii?Q?DRAbaS4lBlmvt+oqldejrZ2cOUHmEASx1ztsboPrqkiZIOLCZHxdBiW07+SJ?=
 =?us-ascii?Q?c4gwYJYzAKE4KQ+7Fz3ke4FyEmPT+eXcIXV3uNNs5D7pGH7X2jSpKIxI7Y/G?=
 =?us-ascii?Q?j13lBlQLYYvGOIdidfsj/2D6k8w+m6+wTpGTyc/JONS9eqecn4sakeYxtT1N?=
 =?us-ascii?Q?Eg2lmKAvGxq2tP1if+qI5Bj3cc6pG17rdG9ipbyelqPOg/NEh88gmVbKd+Ct?=
 =?us-ascii?Q?aT6YCccgsn3mFn4NkiQJ3NwQoyGf6HIvR/kPnUfnw7QmJF/EZwNbjXvzr2U0?=
 =?us-ascii?Q?Vp1tpWnFgz57KjIPAS9rF2H/tzGeZr5ilRxzRRlkYVngOR/yEsyDisLwA5M5?=
 =?us-ascii?Q?O26ViCfodnfah1G5LdUBe7sE8HBSZ0WGgSkFt4U60qonzIA+2E6w2AFjqw0W?=
X-MS-Exchange-AntiSpam-MessageData-1: 02hBg4WKxUUip3GQNNHdw5uKuSGDd/5Eemw=
X-Exchange-RoutingPolicyChecked:
	f3Mc0Q9K1SPX+r6JQ8y2MZf7+ZOFiRBHKUPIhnKdKP44LrDH3axmbU9ROTYt4DfwPCfmsrMoiBvttFPKFnuKrY/eUWS6KFbEIUNjqyOMyAanDm6raIqG8zbo/OLhjvYjFEqC3rTzFCXjiB4xEdFAsJqZ7yMF45YM80bbaMOtoGKiCyyK0c1vvz1n17pg6BS4abl25c1HOAkIO/Wz7hXUwJf3J18xhp8QaOso2z2ZShGg+A/x/LFPkFszSmn2hNy+CLuJ0zVubjHzP6MiUqx+6TfVh/SejLYx8L5u7BuzrVvBqOgroybVK35WA/FYegTOYbg2Q1kpd+soGRr11FqfEg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NWBm3VyZu6elWXjhct3JHqKzZ+v8SKKFzji/MhC94Imphn1eI0GZCkElQww5AAgAJL4LN+n54YzrlZJ6qX72EEBn/FMb2LexNazrepiYDD7289IJ47seCKc1sbcnivEbBxRiX4w/BgyGfx2SvVWgI1UD0aYW/S0w9S9kUpu+TQ45KUWWYgraxb/YtoKPY0GUaPkKcoAsDwPTIvS7+QIYVweL0wzEoNmOKUpxVMXyHZmVOTzPxRuy4EIzqH3yQxBEl+/gxy89EPuC8DfpV9uTGU+dY26YRktQiYgVTBqJZ4uGVRlPVXKGq/4bMwb5KZHn8Gjy5pB/G7Ls0xrMuXvj9IpV94QMZY2B2destxDUIae9vF/ZZ799AIKpgNbAl3xsSSFKDFpLpoYTJql0nFjRXe/ONNROifmr29xy3wo5mw7fiiTyCWVPSNx/gGQFbQg4FihkriDzHSICKnmEBLq0kenQb7aqAv6KWHIESKz9jk2E2ev510S0rgX7R5Hyb4UE7qF6J7lbeNkHX1S1lkVQlobvo5aAVEY40zefu6oV3JKbkawL/PRXYVEhUv2wIEkUu4Y6omhCShmGre8WRq3QbyT1+11Z7LFWA/UpOr923FykulJoYbvQek+mipAjB54P
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 228e6e92-3e59-432a-56ab-08defdf42a97
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 13:17:06.4725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PNcCNA4Db1UIBTBK3zTedNXX5BcH6I+3Ll1mO07k36Ut6xoJPZQobkdco5gktrTA2ICgOIdxjMYp+dKoPpAgXzDQpaYNs/YrRcZLGpvIqaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7385

Misc fixes for test failures (and a typo) when running fstests with
zoned btrfs.

Changes to v1:
- use _require_xfs_io_command "fpunc" 

Johannes Thumshirn (5):
  common/btrfs: fix awk field separator in _check_temp_fsid
  btrfs/199: skip on zoned devices
  generic/746: skip on zoned btrfs
  btrfs/284: skip on zoned devices
  generic/781: fix copyright

 common/btrfs      | 2 +-
 tests/btrfs/199   | 1 +
 tests/btrfs/284   | 1 +
 tests/generic/746 | 1 +
 tests/generic/781 | 2 +-
 5 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.55.0

