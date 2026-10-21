Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792601124;
	b=qzuxUu/s30GLkDWOqWQWuon2sTgXWgXyQnc1hmGCKkNWAhkJ5bMTJpnNhNW8pWQxmOZa
	 wmM7ZztCY/n8sOxZ5aEEMSeokxFip7FxwEClivzsxCVPE1024gI4CiQOGi0DkHTusnNkE
	 W7l6CKpIhIsJzD7wzn/QmilWZbnfP8cqOO+9eXqzKDo+gjPvBMpVhEFa/DP4y0xcACCPt
	 Hk9n21fJ5r7xyL+Vy+iRzxO70tKkDf4U/bQqa6WmCeCjaunjYbyCkhoR0dId6RSaHM2/6
	 DtzQo2S8k2RTO0eFXuLn6PlY8JizQsfkc1591oFSRVyVPcDwGmkiRe9K8thWIcmS1MQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601124;
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
	bh=2T0m0VTQaYMo/gILJCs1MTRKJ+rukQU+vzyLCfcFwz0=;
	b=uD08dlnh9oHPBhD9TcvPOHs1z5hYk/5ygebehpvjWXFDcV+99XApEkiGaFndSFhmmXzs
	 PaJX99QakNm7A9gUBsXSKYY6/b1Qyzb0vutJ04CCqM5tJ9xq2BlXSOmg3c18fEj0QqvfA
	 FUKHP3ZGbLNGUxTlY3LvYF4V8eu9MSApkgL9x46a3IMpR9btbXFWFLN/uclPxe0RdIgMP
	 DlfHragByzqRZYIUYiSOdwoSs6ayzTdq1ynXeo3Nk6t+Pq8fatZwQGnivAgrh/RY7iDzy
	 rQ5sn7RZn6SA7cFnlGUXK9QS/xdf0Eg7icovvoPr6YNpF+K1XCDRothk6TSqdPtVzZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZYOH5hzU;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=b9tPlyyL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6D4606A323
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 16:45:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A6D4606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=ZYOH5hzU;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=b9tPlyyL
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792601124; x=1824137124;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=8B2/m+h8V1Gl5KbweO+MDShGLTU81+FLtjPlhl+XER0=;
  b=ZYOH5hzUAhnfFHZD5xt9f91wkIV2EpUB1NyrNwvciBB38Ws6e4q5JoZg
   3bTvZ0k7xgXYt4EGdA/AvsQK9uoEsGkky4f8QvXv1NP3lJzK/FMk3G8nc
   k+BH1BN60RTD/seusdc94WT8bZQy8MqIYhJ3VzFe+hjbrw0E5wTophBoU
   KtmuBm/ljQkDF5Fn5m7Jn6v7aQyR1F5w38T+j6q4osgu8SqS/5KNzclHa
   2weQ6mdhPVE7mjvtokuKMD9FD7sHZnE00C7Ttcwolre6gkxlT4DCDnqsr
   9RVnddG5N2cYlzSawvTfrys2ih8LhdLRkMJrXhkCA8Fg/k5bnoxTZ21Ux
   g==;
X-CSE-ConnectionGUID: Fy9Kbqi3TuSErRsxypCrgg==
X-CSE-MsgGUID: X0GZDi71STeqGl6Oy1cf4g==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="154434913"
Received: from mail-centralusazon11010049.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Oct 2026 00:45:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qlbZ9JolK80c34KLsRubg2o2SSU03PmEUhMDOz8AV7Q2aaQmoq4mnkyKAIfOFl0uWE6V+VfEhMKJRXg7l/S1+js5HYKp38WJCE8bjl3uOo9ZCtwi0QD1JUm01lMJOhUyO4eV+Zwzrpb6yISpH7eCQ7segHihH/drn16EUn9uAA1SZD+kYGX/mQC9dWFwz4cb7eNKg73qQUVoXIcRI1MT6L8NXMPHEvmnvypKhpErtsayJ017tQTdJQSgYvy31nTufZ8duMn6ZO1+QYuvdP/2Jdv1UQDahOsmg+EE2psDNJyWuVv4xJJR6hvptotUnmoW+ivnDW9PLdoWOiEMl5eq6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2T0m0VTQaYMo/gILJCs1MTRKJ+rukQU+vzyLCfcFwz0=;
 b=gx2W1AIBQ2Wvrc5PZqtwfvpKLjJah4htv3O+5BIftqyJ+JckBqV89Ag/mIAGYHsx+w+15FAPoT09HNu+RvXt1+eEmJ5TTLNvZ1ZWSR3JGjphiq3nrEkSbj4FYTYnAW2HSHfatdiwzgxsfE0EFfbeYciXF4EtGHqpEUrAsItmD4AImUFHz2Md3BA88qcIvfufgxrW0AWgHp/gb1ZaIq6ANRgwGLaEO6vWfQS8SEnndtou5f4sxKsdMz8y8zE2+O1tLHAVWDsDWJIiHGSLn3olgHSYfu+AgK+MfBYrMkhl3LBHpi40aXgasyQts8O/GoBgSQqiRP7NYghqa3L9SUxd5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2T0m0VTQaYMo/gILJCs1MTRKJ+rukQU+vzyLCfcFwz0=;
 b=b9tPlyyLLvKRs2hNfQmwgOFdCQe9Y2vDv4XD5IKirPKsd3Mn/PaHYyCKvVmQq5iHK3ShqWjhQNKj67XFvxevryXCm45vdrZ6AaEnE9E94P+rrJTgxF3Z4S5TmwLMOyjjRnxLl6KTRX9IMJolJW7mZKHC+5hb1fm/nSplaXmCMmo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB870614.namprd04.prod.outlook.com (2603:10b6:5:2f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 16:45:14 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 16:45:13 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: force a transaction commit when fsyncing stripe tree extents
Date: Wed, 21 Oct 2026 18:44:52 +0200
Message-ID: <20261021164452.2439333-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0169.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM8PR04MB870614:EE_
X-MS-Office365-Filtering-Correlation-Id: da3c83f2-9157-4830-4fbd-08df2f92ad67
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|10070799003|366016|1800799024|376014|18002099003|10067099003|5023799004|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	orZc4tNsRNd933FfcG54+cV4PIgUPVqDn2umvsrs9cvu7lYaxY60uZtYXqFC4s6PTp3WmRGFyB2KnD6SeTACX3uCpaVNZnF4a+5Dm5ya8FOfck7IFhiKPpQ2ibJfts3Kvlyrd54GdDnSWVLwNHrKVonauXGG9Dv4/IdtUZrjHKa7zes4NR1oOyHs1zQ2j+aFwgjfoDiIJj5bjIBMCDiL4HVql7f3M2HPoIA2TH+cXLD+Ph9b+08xJpYf1/aWmDPgqOXQ4ytwgqq0/NbK8MTIvqIwIK2T3PNDMBvSmvsBvZzaLM+f/WbhoOExWVn135MV2nFDLc9jhug75EBM55VqHYfbzYXbYTlKwHB8C5Z5prpWcA1bIEb7koyzG9Ah/qG+Aq1Sw07K6i2XLFfZBSWlYcFvh5gyuQ8qxVSIEIEg91QERVIoXZffZ2MB0+2YT1RhRRwZTDDdD2uiGxKeMSMrZ2KWEPg91sBSaYAfTaxUsSsoI2YQ2pPqyudwCB1bzCJm6RZRFEZC7z2KVcymWX9CQDSsJA5pAIXa92sUEBnLkviMw5eiNiwddBw+wTEWHEgivATL/y6vKsDynbYZV+7/z6hMObOZicbaISu/50rQoGnRZFpPWQoEdDicxQLpQR/PYpDEVws0XKcO2fOloa50neUNxNyeKJoAzRLuOwi70Ak=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(366016)(1800799024)(376014)(18002099003)(10067099003)(5023799004)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JG6bBzbfOx7SMTPw6/7VV5nl5hvtnmG1UdcXomg7EaWZsxphZ8slKYJ+eGir?=
 =?us-ascii?Q?+Zvw27Fuu9roz/AgrP0fQXQqj/pZiwaqLHm9jpVwLiDJcvIaCTgnwjHIg7XU?=
 =?us-ascii?Q?EoCR93cdNCvkD26H2yMeKREC2CZm+VLbxhgeOWljF5I5P/kDSfxlqZ94eZBu?=
 =?us-ascii?Q?v6hrIL+2ZY37rJYD35+rDNKJD17abbPcRY8qHFuE2a0EH9YuC7MueZRaglLc?=
 =?us-ascii?Q?R2VYfWiyO5QVPFg6gqc+EYCKA3MNoEG+TdH/6dEDF7uvV0GV9vXhnFI3xcee?=
 =?us-ascii?Q?9QmGkyfRPauC30wP061qXkKj/FVgGQINmJQROya6E5f9Vif4sclg1xZzspj+?=
 =?us-ascii?Q?9ey5l8rG5Ej7HrAV8i71rPT7MVdKRy/U+jlFzGeKpQvOfz5GasYHS9ZIRlF2?=
 =?us-ascii?Q?O5Fc1h40ZYlXv0SgiDQ8KWYd6ELZXQOYQZFh3sLfuN2rVosVNVYXSrwd5eL/?=
 =?us-ascii?Q?n9rpLZIS+Dm7jDv4XhMUz5vPKt7GxoxHiQ+LxgcGctPtvvKt6V2rt0o15WQ0?=
 =?us-ascii?Q?7+XJsZN9qFkn/9sXIgd3j2Z4AlzgUbWdtcXVEBpFiug2YTEIMydp3uFv1auv?=
 =?us-ascii?Q?3nS1q82eYJhIAIx4EYclV5MDaJhWwQc79ssytPhz8hfWYDsmDy+DTBBKSIzz?=
 =?us-ascii?Q?3cTJIbIJ4aa4qo0bE3OZK/6WIrG/qjyiExXDQNOchurAJoxnhTTwX3lGnd3C?=
 =?us-ascii?Q?iT+J/Pjz79CsIykCmIZyCUqlIRr+XQ9zii34ANQlUVKH5a0XQJyNKaszn0Wu?=
 =?us-ascii?Q?7waG6ZnZN+dJtYPFmN1GQTFJsPUorlthRMT9J+Y6YvYRU1i4fO6Lu0Bmd2eK?=
 =?us-ascii?Q?EvwqXAE+n16linuZaR+o+zGHbDKLqX+KGjmv0j0z70xRz8zf+AnvUwnnpzFJ?=
 =?us-ascii?Q?7uXFGd+kVAVQ+dyght5FKEqMNSMEqR9quEbebdbjfzGID92F0iGmhMqG+7MC?=
 =?us-ascii?Q?J0quTttH5p+isgBQZlnXx4GNh6vSS5cRH1eOkNRuwRNsJqhHr2YNgw/gJkZV?=
 =?us-ascii?Q?urvjvGZiFXEBBe0UzINgtM5ugM1KS1fJm4qbhY0vHlogeJCpVLMQrZ3cPvse?=
 =?us-ascii?Q?vrf8vwWvQjqND+jo+TlTdbuGc8gsPYtwxNFFgaYGk/xIow4K3UtctYP5HxKK?=
 =?us-ascii?Q?5S9hMHxJercsDQsIvWoIg7YNAyTxPkm+xhPVkovrFkFbRkPf+tmO6tBZ+F61?=
 =?us-ascii?Q?ETpGffr42P021sFgMQpLUKQtBerYKSxXGUysFITkXuOV/d88uBUZkrv6TqAr?=
 =?us-ascii?Q?oG8Q4mjOkZOg4qhqTeZw0U5F2mu48Eapw36nPuyR96yYSzOuvZB29iJcXgU1?=
 =?us-ascii?Q?ivEG0OhBwEokeyriCrzETdTZgPyIsu9GHQF5tSeyRHTjZ6e03RnaxB9z8GRX?=
 =?us-ascii?Q?RJ7RnFckDfM1koTHEdpEQ82WR6Vw0tBav0feQJ9UfGHEpOC6k4q3jcRuV8IH?=
 =?us-ascii?Q?pqSbKq0Vlc9yBbAPwIkxTCFYnjN7/f+6zzt4Ff2aGihiaSgrb7YHQfModMuI?=
 =?us-ascii?Q?SDaZVhgI5fSO3hE9dT05AHp8yQ4E719JfxqZNznExY0tfDbzwTm8fSBRge6i?=
 =?us-ascii?Q?JdWO30Wdh1hkGtlT4BCj72akap6TwP07flRUHMrZNZpAdUtjc7XJFeNiHTVk?=
 =?us-ascii?Q?tusChRcsRXuH/9SVGCWgtrrA8MpeztGZKjJiOPLjF2pT6Uv5OUCiFyEKmdQS?=
 =?us-ascii?Q?rSlr18hpgPFMuYeVKP3wQnFg9yy+GFYs2L7SU+Q3UBF9liYFWJV6zFz3ncSu?=
 =?us-ascii?Q?JssWDX0R6I0MIWhC1HZJx+3aYU5guF2MGR/hxJPVQBFXdcwfG+uwPsNwaxzV?=
X-MS-Exchange-AntiSpam-MessageData-1: G7deVoyfs3G8A67gMqpMqEAtc83umECGb+c=
X-Exchange-RoutingPolicyChecked:
	HsbD19DbQzWdqgQT2742rsJ2zIn8Avlu8+8geMToGQ+pMjXAkx51N/LaL45SgFWEzIIVy159VhEHebzjvTjsUZPa/gJeGPx+z/1kwtIAAp7BaewyQpJTAzYYxXH8cH9XLrbuUcW69pAOiGOLcC6gZbm8t5vEd9ZNdIerZMk0tfjAsPGkfB1Hb7P3bJfdjVHDsOrSICZ+oiEUhgqXkiazepEnUciFcnXSBh91dfNEUzLH/LmwmhJMjx7MPACKPNZs328Eo+fv7T0BAxQkZEhZ0k7uz41zvy/Z5PRF+rzWcoUIFdh8TopGmejihElXKpgFBGWR4IHCSAcaOVPfwVxvNg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IBbpeu8epRIAwVCHzThbybafz4F/LtbMVq4wCEY5YCDlAFctkqRV5ANabzwtRHsPwhUi7fNK3Da/boJ0Ubg7G5E0ckUswGBbJKAhvZVTd/5QanqhbXdlcaLYOCS3tBY/Q/sMnEdpVx4YqFXBhjp1Lk+LemaBUJja+NOCe63LohUIGCsYOJfac3TIpA2RnA3T71viQuFKiPGIlwc2UwGj2X74TegZQ93YqC5bESqgHY333WwA4FQhptLIgq7jKvhpHduh6t6WG+NBLI0cBql3eeToSP2F8HJF3V373HQKRW4oYU45ERKMWZxuAqqJnLHyIacP504NztEblsG7mQzGMsqPtnxqw5rQpXrwXzYUhMgqAuN4IUB2zEK11KrySIZFNcGHMK7xXa7lIunb62KAFATU7zbpTnFnuhcji/EiEfthAmBB/1sFjFjr4nR7N9H+YvSlM9aC1BaNMDHdthN4u/UiIAOMhdX6ndq15DWJThyU9euWjgWBKLlkt8rsSMvJHZwI4JXuoU5JAFb/q+RVxcGbu9vJqbyjvVQmorNRotI/XcNkLv1dH34WqELJOW6p6FPTsrBeCogQKDMIux135OdpzO56kC19HnMEUooqzrekh+PUPkkt8H7s4Cr4RjFQ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da3c83f2-9157-4830-4fbd-08df2f92ad67
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 16:45:13.2214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OvjEZoXcq3c2S5rylk90V6MpgWYOhtIfQKD3qKzgZTif0Ydij6NSE9WZvZUJ6wuKNCx2fJ0jSMkY1sZYw8TlG3GovzKm4I+Gx8qFZxplWxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB870614

An extent in a block-group that uses the RAID stripe tree has its logical to
physical mapping stored in that tree, which only becomes durable when the
stripe tree is written out at transaction commit. But the RAID stripe
tree is not logged in the log tree.

A fast fsync therefore logs a file extent item whose logical range cannot be
resolved after a crash. Replay restores the file extent item and the file has
the correct size, but reading it fails with EIO and nothing is reported.

Force a full commit when logging such an extent instead.

Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe extents")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/tree-log.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1d9dfb63fc5a..b758eea6ee5b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -30,6 +30,8 @@
 #include "print-tree.h"
 #include "tree-checker.h"
 #include "delayed-inode.h"
+#include "volumes.h"
+#include "raid-stripe-tree.h"
 
 #define MAX_CONFLICT_INODES 10
 
@@ -5107,6 +5109,24 @@ static int log_extent_csums(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static bool log_extent_needs_stripe_tree(struct btrfs_fs_info *fs_info,
+					 const struct extent_map *em)
+{
+	struct btrfs_chunk_map *map __free(btrfs_free_chunk_map) = NULL;
+
+	if (!btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE))
+		return false;
+
+	if (em->disk_bytenr >= EXTENT_MAP_LAST_BYTE)
+		return false;
+
+	map = btrfs_find_chunk_map(fs_info, em->disk_bytenr, 1);
+	if (!map)
+		return false;
+
+	return btrfs_need_stripe_tree_update(fs_info, map->type);
+}
+
 static int log_one_extent(struct btrfs_trans_handle *trans,
 			  struct btrfs_inode *inode,
 			  const struct extent_map *em,
@@ -5124,6 +5144,9 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	u64 block_len;
 	int ret;
 
+	if (log_extent_needs_stripe_tree(inode->root->fs_info, em))
+		return BTRFS_LOG_FORCE_COMMIT;
+
 	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
 	if (em->flags & EXTENT_FLAG_PREALLOC)
 		btrfs_set_stack_file_extent_type(&fi, BTRFS_FILE_EXTENT_PREALLOC);
-- 
2.56.0

