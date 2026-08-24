Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985AC42EED6
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 13:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787579778; cv=fail; b=m8BWH+u/r3+FYNNy0L5dIUUCpwHg816knmE0Hghkcq9EbhYPcE+MVoBnyXNTu8pqwVJSbopCzfWboq2m9toIhC76EkCh3KS7Ibb1BPpYj6uq1sE1NGTM3nM6iVyQsQxIvhhGbpWvoj/PWLlhFH/ojYfp9Q4gK6N0IMiWWVgJuWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787579778; c=relaxed/simple;
	bh=fi+etLDnMfE38fa1HxRgYvG6bHCQ/E+uE6l2gDkLNYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YYwpBBU6BrVSlz48tdPvVWJudsfOpFpguvtzUcJtl8qAu0WdxxXl68ETd5SZuAfm1LkR8NXm3EeaKTo7E2XAHMyT/Y2zEJw4Y92pjKAPjWyulmKp6S0YXfPPamiN60IlX/YVbvczu3JH/CFA4vz2uQoeJ9Wog2taYlonjmz/WoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kkOZz0/X; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Y7mqOsZX; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kkOZz0/X";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Y7mqOsZX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787579776; x=1819115776;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fi+etLDnMfE38fa1HxRgYvG6bHCQ/E+uE6l2gDkLNYY=;
  b=kkOZz0/XaI2zcPOtITgO4wqCAV2I8cD6S5NH+RgFqqX0rnJgS3lgv4wl
   J7qvo2RltA0KjYCK79jkpCZiEUJJasJwVAW16EOFENUNaf1QjGdBcAoxj
   Mg83HQ9vWqmN4mPGsvjWgou+Iep0v32YmSeLi1zWGI41J2+DH5YyGN5nG
   B7FlHjr7hpn7uq9ePP1RzrDI0vSdLseCs6VUx1Dbd/ycVfVA9b034stwH
   +e5NmCQHNAL51A0KeV+Q5cEvQcbQss7n+jpsCxLgHK43nyXwP6OuXM2dl
   64QBzYGhBpTD1dJvgPXyFL7Boyka8AMg0bvMhEKiPgtOXJMdZrBCMB7Jn
   g==;
X-CSE-ConnectionGUID: CT25tzioQJKi4OYEEBc7rQ==
X-CSE-MsgGUID: ipmd4FoQQua5pzYhEUbdlQ==
X-IronPort-AV: E=Sophos;i="6.25,240,1779120000"; 
   d="scan'208";a="153198006"
Received: from mail-westus3azon11010025.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.25])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Aug 2026 21:56:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M4qJeFnEsLyKyJv1QjqvgJqPKsQgYeJQhAWnYZ03gmLvb3DVctSou2vI1KO5oDmsyJKFUqcn7QunP74pX7EIDTHNXc/iEMBAURrYfxFt1F3AF8C5Zsp4hh/j4FPoCHf4gzKiLaoOdyZ0KHtXikkWzOLShfa+sn4Bj3Fmn3+JQw6sRyI47exrJAYDgZhOh608ZfFizeqimm4w58ZszTkQQxOXbClmQHKBF0ZxBaDmHaETNkzj94sDjKG9r7eTSn5vmDTjzDA6JFwK6WW2IVpIMIOauxkOu1z8jXsj2umhD5BsS2rB+DZrGnMSU6yKwACZ0O70o7B9dgmB/sNZMWAViQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3Mm9Zx1eG/Ss52ALQ6nHV79iFaX0jGP07HucMZwouw=;
 b=VX5aI15P2QUHAP55dpuvV7W18wfmcG9LZ49MTVk8p/fOePWQULpoBwI/0gEcnA34Oxh2vwcOlfiDzFIiroowBZUMvneDV8c2Iildv8IAmmXHETsUUHT6QaGe7UCwY+BN3V5aEerEFEMy9LOcn1AhUi85t+0pR3Abve7oSsw0Ixm/OSzi+RHJDjLXJ7iamzUnRM6SJqeXM5EKGzjcWlL3aj0rZiGoFZDdq1ALbbx1W/f1XcmgbHD8xmqJXOq0dVM4vVWE7OpJPk/XB1aq2hoCTelZJmmCPXwOnI1Pn1iJ5qUaJbHD+YjlRG7kQlgO+CZbSsHFozplzzTO9aLPLr96xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3Mm9Zx1eG/Ss52ALQ6nHV79iFaX0jGP07HucMZwouw=;
 b=Y7mqOsZX0sE2tDcB3IsOJlnbPfgtA39TnJVFjEbFadrAyrqEQn0msWcGCh7VGK8XVWMf//LoRJjI9XhIQ4/JL74W15wIPlsJvSk3O+cN+vfQUgZcXnGOeDGCbR841WQylF9aq981bqkvV0YHHVj0WR4RTnuzQeWvOJ3bDI3pW7A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB8279.namprd04.prod.outlook.com (2603:10b6:510:105::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 13:55:57 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 13:55:57 +0000
Date: Mon, 24 Aug 2026 15:55:40 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: linux-btrfs@vger.kernel.org, naohiro.aota@wdc.com
Subject: Re: [PATCH 1/4] btrfs: zoned: track only sequential zones as active
Message-ID: <aoxL1ZK42wn7VIwQ@mayhem.fritz.box>
References: <cover.1787551793.git.zhudongjiang@fygo.io>
 <9b86d2db35ad9afc13069d6ee8fcf421c85ef030.1787551793.git.zhudongjiang@fygo.io>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b86d2db35ad9afc13069d6ee8fcf421c85ef030.1787551793.git.zhudongjiang@fygo.io>
X-ClientProxiedBy: FR4P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cd::16) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB8279:EE_
X-MS-Office365-Filtering-Correlation-Id: cd5f59ee-201f-4352-e387-08df01e76bd8
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|10070799003|366016|23010399003|376014|10067099003|56012099006|22082099003|18002099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	8m8VG5m5c0mtPKLjQHlPfTzYVfMnpp8RaYO5KMLk69iCRb8K8+ECvHDTZnJ+kmGoMfTarg7A/Hw4EkvadwLaGYCF/PWpxVTLqD3DjkhazvqUc3frCQq4z4VXnc5qYdMAjcxijU7qtjlwji3Oe9NX1syvqtugk27mm9b603B5A4D5QjY1g4cRGKUJ/yLPM2GchsXSM1BJx9byYAHb72Bdg4DP8axckv6OdGWHyZNBuXS/5UCrD/UXHkNnJazP7USLa2ffYN5b7uDTetgJ5DtBNt3qQUWIjCXhzGxI05BMsU7ekimm/R165HGl6TZrHy4IlOo4ZCsvgGIbY14XmYLTP90VfSzQesSZVreqhPelOZRgSv0IKY+xNoMfjriRohmszKhaehTKQHBkqNekiYVn7X3zOj/qDIdn1LLFPjR5VJBKDUnPYbFZoalg3TDbgPiP948Ot/l6gFU/xpOHcbT/2f8i+c+uc9uAoze883ohtGjyqtpCaLNPOC9jNCdg2guymQKc4BeQId/6YnR31rlpi37X+C4YM2xvsvjCvaRbM+Ddfjw56WWOLWrPcBzzTXbzGDr3AmVcOlv8pHispIeR8ZrCw2ygwGdjbafNq4gv2glf1S2A7B/0WOUWwSIhuvr7xFi6aXjVr+Hdb4WQPTV4+PY33h8wkE20HRKAPFfam80=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(10070799003)(366016)(23010399003)(376014)(10067099003)(56012099006)(22082099003)(18002099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UCVRNe63YMYruZ9TBbusb5yEiLQ5uCxIovwB9XWqELjupwt192bz+O++tHOw?=
 =?us-ascii?Q?hcE+13d0qCmd5a4/EGkhHjXMNY6wTqo/ef41krCmdnAO0OWkPZkYd8KdgFI3?=
 =?us-ascii?Q?T2uh5cndZLF9s57cdRubwQ89zFfD+rERwHsiQ7eXRlxuC3SGzUcbhCvq8SnV?=
 =?us-ascii?Q?k3s43rWZace+Q/zFQLHAh03iRvnWOkaK+OGomMRy5303pvhnLXpPfIFJDQ/V?=
 =?us-ascii?Q?Ky8KKqP6EkObSmeHHOaqgN3ex8AtR4MIKladRO6j5jQeKfZgKmsocGyByRKz?=
 =?us-ascii?Q?pIzRXWB1SmRUtZoO4snwvpVn1eXeO9zQPr+OIpYzFUyBAZ+sJ7fl2gR6rWQ4?=
 =?us-ascii?Q?DRD11aAP1+UXGmx4dWB4usLlJyJ7BzDc0ur3kqsAx5wlk23A39oBaRo0J+dz?=
 =?us-ascii?Q?6D4yxfWZ91IBAvdccT1GjgPL0xY39+QYmZn26Ft6I5WFYolhioRIAFzwaCxH?=
 =?us-ascii?Q?+db1gYoT0srA0EHfS32eCLDYDhisq95+rcRtBi1s8R/CzrxE+80S1kTYTciT?=
 =?us-ascii?Q?hTemeWz5d6Qo16qt+MHh/cIsvYAZe8yMUGaT/Lh5Ku88e2qQQKjMqNhl1YtN?=
 =?us-ascii?Q?zoGhgYK4iCaUJIpoJIFUooFdaSbimQ9tXgbbzcvJuxUH6Mjz5zthajnh3UGL?=
 =?us-ascii?Q?yVPlZwrOPk9O/tMeo6i9s+8lnq2dfHWqtc9FedXlqedPdNwJWp4IbCdRl8sE?=
 =?us-ascii?Q?vu7g6o7y7MTiCfH1qGswxKYmwH3YHIeL8GSDEdMo58u9df+s44F0bGHEe6BM?=
 =?us-ascii?Q?I91bayu7kbVVAkAC4fSUSwiNbn+6JC3iL3LpHh9YAbRBcwJ3Id5+1XIQgxD3?=
 =?us-ascii?Q?Rpy+Ct3qALWIJcetJQOo0LxwTMepRTlRgkUaJgyR7mbMTDczJ6pMc55dhQJI?=
 =?us-ascii?Q?6k8P/FX9KdztirVCeV0UYVjH7acqZnt5EQl0YxsQ4Uxah1Vh3arPw7dt24Uv?=
 =?us-ascii?Q?zE+9DgO4mlv7ensBuJrBoww8fYJSE68g5fzsLFONilgJVONuTgHOEt6kHDqB?=
 =?us-ascii?Q?S3IZV0G/irPgcORLcicVKiESvO+LL+/DuP5u+3gg+OkSpeBKI9dQD4vE33YC?=
 =?us-ascii?Q?zDBA9fvpeBSqIFE+4Odk1ujr+47fsb2KtCP/Awe7S+Sup9xUbXq+g15dE7Um?=
 =?us-ascii?Q?+0UYd21PxRZL2ZOHIajp1qAXV3cYEYonGJJMJmhcW2NTHI3q1FGod7vIFl48?=
 =?us-ascii?Q?w+U3/gT+vQ8TOTyctezMKYadmIfHjqGmAKu2C+Hky1LwbsXpifJWXQOoGZaG?=
 =?us-ascii?Q?FapymOruJa8iF3xiQyQevQ88Mp2keA0lLUrUM3RpaPPYkD+s0nFplFtkFkWq?=
 =?us-ascii?Q?P6Af/qmfonTkDeZIiB/VF4LbArRMxhxQFqnY6U7t+Vulpch/vl4EbSueIQRz?=
 =?us-ascii?Q?PUswpLQWLnsV5Jdt2tvmoHR02NIFVHelCvsdDEoVmOzxiK5klQLojP/3yzQH?=
 =?us-ascii?Q?WUoDiEGN/lCa8km9MmAI4jKAByf71ixopZHR2pIqFw+mGdJKMpyzpoYW42CO?=
 =?us-ascii?Q?q8yBCU6nGFYiz5pawcArb+dt2zQwW/uvPWZP4ng5T1dleIGj+tEfkeho/t1g?=
 =?us-ascii?Q?xcpyL5S6spnxtF9GspLrLiQk9Abu4hvZ/Bh48yoI2hvDXKYaJH9eiZ6+E9mY?=
 =?us-ascii?Q?n8kLsfkQObKZHpR46GC5kCg0xSEUEokera8eb1EkrW+TPJQr/TJx2J0vz68q?=
 =?us-ascii?Q?i2h7HtQGekUACvmPn010jM1a8b9c7cGc/4SuYy6yrzhaEAYoKtgO4wpPPLZV?=
 =?us-ascii?Q?xvN3pVz5eupT1kQw4pPJ2JrEKYeZokoiiaMJMvtH3YqWtZR4/tmFVBRZ/1IR?=
X-MS-Exchange-AntiSpam-MessageData-1: GNGPdLGVnySiA3LdcKR4mNGhkpi8j3YbK6Y=
X-Exchange-RoutingPolicyChecked:
	NPz7CZtBGH6a4LYcepHgW8OoJWnbLaTWTvGpa+HnsPYJ6I0QxBazgxE5fupWJ4BwIBERsJTYkS5cZhkfGyPddOsWs+2jG0wjq96dSLz3lWuTeRgJZuSiiOsFkohBKzfwSyXTBTefz0QEuTlpHrZgYFWbMYVjg4wR+n2U7q+1jQgX1mLDtYnBf7vsbFkyRUYY1CDrR8miLG1J0BKQH4fVVjuhhtAOLQ36anJdW6f2ja+ucb/y2YMRUy77VqwBtC4Tb9nJb0kzrrLNMAakHZCYxbYvodSBJ74uv17pfdMD7wC+X8SIvnSABryoDEcn07+fTF6Ki1/MGYkY13MWhf5lCw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nQOFKLsC7zZx21CuWjfWk0z9dA7ehhdobDDE9bb9GuDRMJ7/bCTRNCbZiOxm6n59nbV6t2K5nLHOif1jjSmu0gMyeszKZbIjGx5m9YiPepxl5J0EOapM3Gc2oL+CrzmJotRXNDQksQFgSan7195snjT3ToiIbgU49/IX2JLgvMm71RhyAdDyqxMXajqlu/519b7izq7vRoG/S5XUMYuQY+g9qblfnTKXC8/MXR61La7T+oAAwWutkJsVyIEdzwi+l6P5weOfPm/05brB/TSdE961rhWIhGWDVb+1f15mdKSnIRwopldb7pZ8Yw2X5k80rDZh8ZFSoyEO8gCtDl3WE2v6dWlrTaf+OsuGdDTUqUGUMRvhjin5InrmDPbqFWtXQc3FPxWbWIwUXNGIIgYKzAuXs4rbktl6b9vRa/AVLSixD6Bd/AVI5EYCgmCrQWZ5hwFrmFj7UvkYDUAAmMTQzMwRjBynyJBCtERJKwpRbSoNoLuEOHnZHv/xhRCw47DlVPw00M38ErVVx8dT0/+LjG4rBnt82wfZtTA3ydATGmI4MmjrW8ofvzqdqis9+d/fo55r/bpo6jfiJeNt0XjvfGR5Zp0Q0HJdZcxfnauyZ4M3QVaGMJ4bYszdt7OpGI+C
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd5f59ee-201f-4352-e387-08df01e76bd8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 13:55:56.9508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qUWWb+TIDD3DJ6u+QmDN4qvDKmvvMg6w7xCL8g2AdBnojmmPtqevZsj462h3zRhKS+e9bWJSe/m/9OHw3hsvqnv3Sgpsoq/KLm1HGbGakV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8279

On Mon, Aug 24, 2026 at 02:49:53PM +0800, Dongjiang Zhu wrote:
> [CAUSE]
> The runtime activation and finish paths apply active-zone accounting to
> both conventional and sequential stripes.
> 
> At mount, however, active_zones_left is rebuilt from device zone
> conditions.  Conventional zones report NOT_WP and are therefore not
> included.  Meanwhile, all-conventional block groups are marked active
> and added to zone_active_bgs, so mount recovery still decreases
> reserved_active_zones for their metadata and system stripes.
> 
> The two counters can therefore diverge across a remount.
> 
> [BUG]
> Each unmatched reservation decrement lets data consume one more
> sequential active-zone slot.  Once the reservation becomes negative,
> data can exhaust all such slots.
> 
> A later transition from a conventional metadata or system target to a
> sequential one can then fail, because finishing the conventional target
> does not release a sequential active-zone slot.
> 
> If this happens during synchronous transaction writeback,
> btrfs_check_meta_write_pointer() returns -EAGAIN.  The transaction is
> then aborted and the filesystem is forced read-only.
> 
> The reservation mismatch was reproduced by creating small files with
> large xattrs in batches, syncing them and remounting an HC620 filesystem
> using SINGLE profiles:
> 
>   active_zones_left:     126
>   reserved_active_zones: 3 -> -8
> 
> The active list contained one partially used conventional system block
> group, nine full conventional metadata block groups and one partially
> used conventional metadata block group.
> 
> [FIX]
> Use sequential stripes as the unit of active-zone tracking.
> 
> Do not mark all-conventional block groups active.  Only sequential
> stripes update the active-zone bitmap and non-data reservation during
> activation, finish and mount recovery.
> 
> Assisted-by: LLM
> Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>

Looks good, two small nits though in case you need to resend the series:
1) Please don't do the [CAUSE], [BUG], [FIX] thingy, I know Qu does it but
noone else does that.
2) We now have a repeated pattern of:

  if (!btrfs_dev_is_sequential())
	return
  if (max_active_zones)
        return

Maybe have a helper for that? Something like

static inline bool btrfs_needs_active_zone_tracking(struct btrfs_device *dev,
						    u64 physical)
{
	if (!btrfs_dev_is_sequential(dev, physical))
		return false;

	if (dev->zone_info->max_active_zones == 0)
		return false;

	return true;
}

Otherwise looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
