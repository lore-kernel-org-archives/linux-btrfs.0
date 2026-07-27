Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E99A33C19E;
	Mon, 27 Jul 2026 09:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785142851; cv=fail; b=CK1t6dl99AWQ58fN3DdFFlRwnb5XmJMkL/tVNJezJL+nsQrUPbAsJg64XbxHp3Rlz/896DWu6KV6sai6ohVA0Q5lOfbl+TF7NjtcAyoTEiIactNMqTCfvD4Ro+WnXXbI/doJUw6SDjAqnbiT5rpgROPxNyifFn7r2NnLYVc9c/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785142851; c=relaxed/simple;
	bh=A0LdnbZKWjpQFWhKSschFgWKqz5WVsLbUiT6KKIzEAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tHqyJl2AMjB9drMBUR0ahn1Rz/GN1u1nX1N+WSCeLXp2C1o2U+syGJVLi8TRFZg5wCRmkeCwCz2cMzuhYkDSylhNR2Hi791uZDkjWVAgoGLdxiwLRaV4V6LkcyLMbdQgR0y300gYDKjA/Q5SCNx4a1QFgNl+ejQYSEp6qidQ5go=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GP44KU7m; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=FL1PZvqH; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GP44KU7m";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FL1PZvqH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1785142853; x=1816678853;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=A0LdnbZKWjpQFWhKSschFgWKqz5WVsLbUiT6KKIzEAM=;
  b=GP44KU7m8bgkvat7DhK+aaXJS3tJGj7JJq9ucHhFXQ/vDoTM2IUUaEiW
   Yr61PYzI9o8CeLDgG0i+iX59haKvJQGc2cvNFtLLN77myUyz9KShZrNYW
   XskU0FqUU1v11Kfu8sJqiZOuGBcSB1Dbue1XLGJM5tmZv4JT6uqY2ZHy/
   5b2BR44rcmsuUCHHr7DvR++JqCt18NRYqn4KkFhm3OwUdxycvOcSMmfo7
   dgME31I6F1P4pOtyzTMKjT9/oWj+45rRJzcMprMD5BNc5bXYke8nqKPfV
   HYKAOaXduPeG5JrWCjHZPk0Lg+wd3KXiGoQsOi32D9zNWAb1jqDVPzv3D
   w==;
X-CSE-ConnectionGUID: whv6cmCOQOCMmJQCAa3/yA==
X-CSE-MsgGUID: tG2q4MIOQhi67GuJBfgylA==
X-IronPort-AV: E=Sophos;i="6.25,188,1779120000"; 
   d="scan'208";a="150303268"
Received: from mail-eastusazon11011013.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.13])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jul 2026 17:00:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GZxsP5NygtT8o2HmimhqVCUIutrED6dVoGLnwlJb5vcrLP37I70wpEwB7vJvQanoUlR6wNlbg6JOjRJLPzC6buspnwMJKWFWK2nGdozHFcOpNhxvJ99riDipMs6Pq6PYCnR8y3GqMujTzRQluJK2obZkUVHfT6CmnPEXmzNMNl1tyoMcNTXNdkk8QriiI1YVJFHl8UlRvxbuc7DheeTZTJdsb/qa8RfDTYOZ+JjZ2zAci3cjNgXdV9JCP1G1FMdsUEqIz4/UhN9a1S8v0dIu4K55qz0AlakDwqI49UI1OamxpRSDjdEVX2ACFRANb9L+d8Rg7NtKxsZuVtjAVt871w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7iAe4gU2z6sVwRESMi9H7Dqi/Kj8Augg9tBZYlEN6Y=;
 b=iN5HQY6q8dYQromkYb9pLKFgb2ZggrarRKNPACh+nZTnTs2XQyoEYtiA7muCp2rdnMCME/9iZavPtkOKuZnCogXlLuKRD0wFy45MPH+LvFGecoM5RIDSTJcf4D9XAYgHu3pvCUK6XOd7I8O0GYXI7YBRIa6+8gjxmb9BZtlCTfJv8jRGRlb/PwKwrvwpRpLyNFmOwhVxJc5q6YtTodQckgE5Ka+lCg3zQ/R0gjcBkZ+ELrEbDfh//fpeM/IBWoE311kfeGWVRwalS8mvjfK55LiKUcP3sUw4aC8SmjmiA/xnPU2a2/HV3brc82QMCyKZvVH3DuTGyVejVgtgPUdLVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7iAe4gU2z6sVwRESMi9H7Dqi/Kj8Augg9tBZYlEN6Y=;
 b=FL1PZvqH35qjw4/U7Vyow+a5VCE2RZ78IP6mHGLKIm8pPUC0hOvAvn9TFhIi77PzGCclo2AhDthPOo8pNbGuEsdp7oH94Ci6btNmTYQ1mKPfzRXlWjifNwpFQE6OK9jB7sDEA1CTneq5yhH0srnfEltMBFUtNe/TlSF2lIPM+20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB9853.namprd04.prod.outlook.com (2603:10b6:510:376::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Mon, 27 Jul
 2026 09:00:41 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 09:00:41 +0000
Date: Mon, 27 Jul 2026 11:00:35 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] generic/746: skip on zoned btrfs
Message-ID: <amcdDtFZ5pYz-nI0@neo>
References: <20260720111849.1659111-1-johannes.thumshirn@wdc.com>
 <20260720111849.1659111-4-johannes.thumshirn@wdc.com>
 <al5c4krF3A03HZ1o@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al5c4krF3A03HZ1o@infradead.org>
X-ClientProxiedBy: FR0P281CA0109.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::9) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB9853:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ef4b5db-0fcf-46c6-53cd-08deebbd88f8
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|23010399003|19092799006|56012099006|11063799006|5023799004|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AOw1/37M7DCKuXZX92Z8NvJyuzdFHstyAaqDF2VsNlnuKUCxbfDrz7O6FwFP+8Ogxa3EIpS3L1UimXMNZ1cuKBy0jB+j2ws7/7YKbDi0GPZP/jjUn7NSg7nF4fVeC1w1JE7sfb9KHYFqzonjupC4jDMHIaxyeX6scKrNBM3N4KLPEqH08Ufsx4NnPcorbkf/MT/Sp2KKqiQnwACKU6OHSiqCOglQgTzvTUbvJkZkNkbOe7aMVVKHXZXh+fNxQN9J4sFidoop9h02gtlp6YYy3c7b1xRxhze7DbnDVFp3BbdCN6Rh0HZbJzqXv2qRwCtwjzavVCVkeK7LXCmJMQzjq4kFFux7+0odxZkemc5ZCA+PHAZmpEM8QN2fzuVi9UloMa2tbuEbC+UBWn2jU+MScBPo5NTCxqAdm/taQU5cnkl8HjGYoMqVwLbMKCceygaISNEtwoz1SYEZhMPppj7ipZX5lSUJtpaajPtMM/5RYp3EH/aNHtxeLByU+mYMM7hY4wRdX8RC2E1FkunYitCIXHF2qrgcH9Ndjd6jNPMQnsreH+n3v0BPRd5PqHkehtz6uMQh9T1XDv+0DAQf/BacuY/lBXI+ao8j6FKvGINCUh5OY8xy7Xvq8aLo+teMDdv4ZCsXLVk5oSwLnB4k8ze19RF0BKiMy3mc1ZlqRyemr/4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(23010399003)(19092799006)(56012099006)(11063799006)(5023799004)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5n3cPzxDNPxLaBeOPXzcWG7PT5VI1B9XRfIRrVdzNIc2JYdQeoimGnC8Vpes?=
 =?us-ascii?Q?6r68wvHdd/sh7hrdZ35s5WNq+CLbKCw9NDpoCM+US1LgkQMp57e58XQVdxz5?=
 =?us-ascii?Q?SUX5LBZKLo5CPZ1ikrSo+N2W7INS8mS+VbuQsfOJqaW3D/pGtxx//mtTnk+k?=
 =?us-ascii?Q?hnFAY9H4km6NsGradrbtXAEOU/0svj2lONqfy22JhRBjBYCEFYXsyV2ODPOm?=
 =?us-ascii?Q?STotbB9AV16ytO6nYvRGueaODzXKxUfNgWa574mXoCJiTZbVUJn543Md0xmk?=
 =?us-ascii?Q?trgDlIgeoKZF5XRUru5EMSYX8Cf/jrYYtS9GcStUY45dcJ6yu4EzIo1HBr30?=
 =?us-ascii?Q?Fpnpt6z0wQeA2VbmgswbPF7g9TorKJnHAq01HtWOTu+4AAv8To+LOTzdBHK8?=
 =?us-ascii?Q?XerN6sFoYHIy5Ma6zHpNxTKUfwNvoxBAlmfFkRRbG9AiZVjDL8qvx2d3IqwP?=
 =?us-ascii?Q?UvLSrpO+dy82Bs2LRUUQQgbsUKTAN1Q1oSbQLazBXJa5KpyoaiVTAbr8t7Ga?=
 =?us-ascii?Q?Id1PMgH/y7QQdmh7SCNas0SwfHJy1ssP8rVD0y44j9anabZE4OcdMAi+OTJ3?=
 =?us-ascii?Q?p7UPZCrpdTVZ+paxngqz9HwN1rBiCqEVraBPQgpI+M1tuqh8BCvbJElUk7VY?=
 =?us-ascii?Q?a8/9r1kuUbxXdDHbQUwsXfkBb3Z07ysGBPqTztrRfx2HjASqlrfBmM7stv5E?=
 =?us-ascii?Q?USvoCakEvaX2Zkxjud1SSC+MMxP1vNUG0QEDdpe5/ov94Xi3njgyVa4hiMSs?=
 =?us-ascii?Q?+uNkaPFThKIgW0CUABMiAO2A4O445AMRUrRlx7/Cl9tCBwpRxDj6VTdxxn4R?=
 =?us-ascii?Q?js9I6ktoYpW4r23+pHReNyNlDgc83o5KIQTfle79AJLt21XOG9qlIcEwlv5w?=
 =?us-ascii?Q?7YM/9bNcNaTFdqvjlrKBx70WCw/FItL9MgYGT1Htf2fzGLnDRJRW+Q+AMhDj?=
 =?us-ascii?Q?klNZp2nwaaGfDFk/HsmImtDAj8wDasXUtswtRnFgv2VtIk7tCeei29ef5ggK?=
 =?us-ascii?Q?nj4w4XSan67+JPiNeHA16kUdg6N6dYmwRcMAUBr28nRWru/gN3jEokt1mfIQ?=
 =?us-ascii?Q?2p6dnbXVaYsWVEY5Wb9ro3mDt7z9+MZHmOSpMJtdJ7fqGZ4YBxS6oDi7qUWH?=
 =?us-ascii?Q?C5DVIFERGDLqn7WaMfN3+c3QnSdEnfIIBwH5R6az7zvt9DxTvJTloMNdggLU?=
 =?us-ascii?Q?MvWZ0gNkfymjyr2YTtIrGduDrm/kabASAI24Q0TjAAdB5suL3BRvgtC7cwJl?=
 =?us-ascii?Q?rkgGBX9I/AfyW71uUTVlaf/McwdxoLAml9Ojwc7XoOdDK1+atKM+Veras/wQ?=
 =?us-ascii?Q?xTzmEMibek70H33zwjsKKkyeM/KxSOIYzMS4zaAi023Bwl5YGfVq4k0MHX1z?=
 =?us-ascii?Q?VTBEixJv7f+72kQa5xNbUjiXMW6ANgHtuGRUu68W0vesWtMMQ5X6NWNQTlzE?=
 =?us-ascii?Q?S+50wxqmnVOPtpUejPrHmwjTSrrs/bgUyBb/g3ZxdC5DiBOO6BSzn2If1hQo?=
 =?us-ascii?Q?IaKjVmB/6kz2OhvRlApq4rUnq9uuhs2Gr+E9HzsUaJMlmmh46Nw9kOiTspga?=
 =?us-ascii?Q?RETFNp3WHc7UJ2bniZU2y5wRXltxnt7FresZQ8xM6mz5sIh55EnY7I2uUYaM?=
 =?us-ascii?Q?S/lCPyhS06uT51/UOLhp/fzauc6/94LnsqwXptivsxkTApp9LlxFtX+rHTQg?=
 =?us-ascii?Q?w1C2fOWdiGr3VCOfhjaOsLOzrsQT0jcy3HABwQsYBx1bJ7eeNYB2d8bjxUqV?=
 =?us-ascii?Q?idI5kEPsUyi1ODZUyL8wZY32VP81kEXgsafQTCffSQpQlrxo6A+xLDhgYuKO?=
X-MS-Exchange-AntiSpam-MessageData-1: zCgJmFQKzyLGo4JPgCMl3pxkNQIePS8nB6s=
X-Exchange-RoutingPolicyChecked:
	GXyLleIcKk1rv90Ygt+xZkp7VRDgtnAfUvxVrNCXmRXyAigRpEcamuen7znSEVDAErZFxyMVzheWgCg6T7lqe6UbP1/K2jsyPHeuzhvjyxP5wmh6C8uEg8T5Nqc2xcH9elbMhUpUK5gV7lfj2fHZYrp6hKFpEJV9lcyu7ZCRB37AoAuJu1FRlCr8sZhjlYR8h5tKrB7JXNRY2ESscWqqYqYMUYEY1O9hOstjbLOqcXvms6m7WR8I4hWNWNDaVYs//49U+IZkM+nWz+hBWLatw86Gzl6FKiiIIoO3teJjDUhNciUceYogAgy9OUkcWd/La6mWbdUj6bgcVzMo69hV/Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lzSKhQPnjq3QGqBYdy6Uq+vU9uk4xMaC91s/X1MpFjO2AnKhmK/cuBgwOqoQXtjfWMHMTcqUav3PTZKwfIx5NVb+or5aVAFqqj9Z/i9QUDM9rx/7RXgOVFcwA5O8QH580QYjEn9fW1q5a3NzoC3Ivk/hwVvDK6oGXfHfqZR9WLCnE4tK1BNCawt2HfU7uHdytJEpz1/cAsH0ExWjqBzCblZgHHUnnjPzJHX0QztaTYQV8KaFIKA0HAayq9rvHOCvjqeBmbVcahJNfPKfzEj0eBsJKYM7omygJuXti1+HppL5jiWyan/zvNIsUEg1m/EFjXPUZomW75q4XSwKfgWqAhnJ55ChiPOX0JA0BXObEav9YlJ1YvN5UFRD1sUsknSf2Muu5AHFCRnw17Eu7gL9cpbgTQOrYZ70CCKQf7pLxv33q/klvKWSJwOcB5SyVEdA7nmpj1oX79KMxZMYJUxJSVmaYwFEQopuQ78t7kbDle5cRn7jZItXWHw2AS1ms5UeQOQZUARSTqzr7q5ZlHUnRSPgBT10hDtJ7pY8kqsauo8d1ss8Cx6+84L1+LYgs4gzIpcnOiK0KynZFALF/KcvehsNaWWuj6wASmApHFh91qp8my76zA+GFmydnkd9bZd0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ef4b5db-0fcf-46c6-53cd-08deebbd88f8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 09:00:41.3230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cxMvjq6pi42q/aYaNiJYKlroib8+5mgSEM+cHOlkPBnttiPtk9oZLdCVTnmO5J6iw8WUR99g1CWaKdYXHz9HpYENaBmS91DVnbq+6X4O344=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB9853

On Mon, Jul 20, 2026 at 10:37:38AM -0700, Christoph Hellwig wrote:
> On Mon, Jul 20, 2026 at 01:18:47PM +0200, Johannes Thumshirn wrote:
> > The test relies on loop device discards punching holes in the backing
> > image file (holes are then detected via fiemap on the backing file).
> > Zoned btrfs does not support fallocate/punch hole, so fstrim on the
> > loop device cannot free space in the backing file and the test cannot
> > work.
> > 
> > Skip the test on zoned devices, but only for btrfs so that other
> > filesystems (e.g. zoned XFS/f2fs) can still run it.
> 
> This should use feature detection and not hard code file systems.

I didn't find anything for that. Only using _require_xfs_io_command
"fpunch", but the test is not using ot so it felt wrong. 

> 
> I'm also a bit surprised that zoned btrfs doesn't support hole
> punches.  Unlike classic unwritten extents there is nothing in a
> zone model preventing them from working.  Did you try just enabling
> hole punches in btrfs?
>

It is not the zoned device model that prevents us but a desciccion we
did in zoned BTRFS when doing the initial support for it. I can look
into hole punching but I got a lot of other more urgent fires to put out
and features people are waiting for first.
