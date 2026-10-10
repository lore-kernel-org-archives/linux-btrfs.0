Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402F14968F3
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791634049; cv=fail; b=S6b5mN6oby0Vb/d+vAqhk6zeACnnzxtFBat4Ubj4NLkorcYkmc7JOUYk4fAHhwJ5Gk4IlizzlGG/OjUgy73JVSE0MgT2brmDRRCIUGUf9JY9ckJwN+zhrEmuMa2YzNDOl60FmSov4rEuKYnXpXxwCdu4ZKdV021LfbxGYYQsDFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791634049; c=relaxed/simple;
	bh=YeMp2GxzRlEyn7ArfJx3TRfyKNigrE2txJHca9phKQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sf37iyw2h2/CNqGi6mlTsPdx+fGJb/ukAK6YXZFTsvOCeOBs0qBwfj1NyHVMo3cCRYFAOT9hZutpUxOsO2lQMczm8ywWlnRIWKejH4hjaVUo0WBh9lYEDtXpjXpJ78RyusUO3wiDr6kHaBiitWLS5BY6fQGt4XJpxh4L691HSyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=a2OmsmGI; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fAOgyN4v; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="a2OmsmGI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fAOgyN4v"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791634048; x=1823170048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=YeMp2GxzRlEyn7ArfJx3TRfyKNigrE2txJHca9phKQI=;
  b=a2OmsmGIuDXT1zu7aZI0l31CVujGGywjB4h78dwcGQYwbD09ckuQn1hy
   5yZzGPC76qjKY4gERu9jtoHj3c9a9YY11bGib37c0NOX4cIyLgHlmqu7+
   FJ1T7EfxROoWZRjv+lRTAEK9lHoauOMjavhdgGseEqBi/N6ID2spgz8Pk
   CNfRshLmmtmoy4di2+joTMNuhox8qQs2fz+rhU2g6flU0Z25qVme4czRe
   +w3ogDfCEQs18Tb1Jhl/bb30gD2eEHzzVIKDMcdv9GRr4fNsalWHWoFrW
   8EBADLDWRteeS4m1jaf0xT4WtNuDZ1fBZTjSXOD0sPH6XRfSw0RbjiCVP
   g==;
X-CSE-ConnectionGUID: C2lMD168SXKjPmVOc7UCtw==
X-CSE-MsgGUID: LNr236XUQjq6Tm17wqJ9qQ==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="153560343"
Received: from mail-northcentralusazon11012008.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.8])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Oct 2026 20:07:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fDadnq6MgsqVS/2FXI7lLCVDue3Wg8V2i93eZbdpX9Iz4EGIl3inIaHMJEA6Oyi1bEteO6GBCq3WiWzw2Gx3tVYocxnbB6gphRFlqFcd5RCoxML/i8Es+qjrAEMqkJqPt25FkzX2elyJ6YK02cj4TDsa+dt0Ngh0VoYRmQh9TewXCjbfMrKiUN2G9VMrljNZ/QXK7KsEB7wmCIn/xYPRQJk6CJkzaW5u00toyec3HRv5rQplcLZUcsTjQ7KTc4R4zLP+mnNhgETPlJ61Tu4I+VohXTRtLVmWZYktA5TQBqG6L+kiOpy60WRn03+BAuJzESVYx/cmPTMUNbh/kjmyYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZAVvD22SGXqcpqqDt0vke7pz7VB9r5NyMQLKJYUluuw=;
 b=tFjnDy8ET5VIk8ydXslNx1NG8yon6PiHbSjfgyy8s486TchsUPKnPIkQBhw7WCRgj20aY/E6KuLQ2RWaylDiBZrey5rvctL/rwyXeK4lQx17+uMwpiuv7pcrQ9dn6DzXDdCvhd4fmhvUkCEukp4iZRXp+gGtOnLw9eYoEj1J6sa0f6XbKeX/80uwkd3nvmoMcqrlN8sURUOcr9HL5LGHINzHbWve7ZM6wbhonuFSSjXuSfHgDqCkxFkNz/ff2/lKFaawb2uCkN55dbqlDvZoz34reSjSprInyxvJEVHixd1f+caPCQu3uclmop31glrFeCv1BQtcdYZZ3BCYzGBJPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAVvD22SGXqcpqqDt0vke7pz7VB9r5NyMQLKJYUluuw=;
 b=fAOgyN4vLECfMKa+PUKuvCAr/Bqjo7eHgZ/tXkg5bONBD4fWunRnrvaWoxS+mDfm3lFOvh5h+7v+TfstY2TCAFSdFAjA3TOkBe9lRprpscchC6/ebgT03nv556w0t6A45qSMfOBbuwMqbuntPhRl4VPj3oUTXr2mxlCh96znQBY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7886.namprd04.prod.outlook.com (2603:10b6:a03:300::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sat, 10 Oct
 2026 12:07:18 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 12:07:18 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 09/12] btrfs: zoned: use plain mutex lock in check_bg_is_active
Date: Sat, 10 Oct 2026 14:06:19 +0200
Message-ID: <20261010120622.3781326-10-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 34f114ae-1177-46b1-c4b6-08df26c707ce
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|23010399003|19092799006|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kLyooE08X5mYm/HgYB2sZlr24i1SZXFmWQVnckXSnXg22VHaNw23CG8/0EcvnKrDwC6NF6+WfbroiKJJ9ZrSf3D0XErDN5BsgGx2YY9AtG8aqoVwk+YGdcS4cB0xnxNERvx038XCWaKZAhs847PBiVPGKH47bFbHszWlLTyMaJef7nVQOCM3zVgAqvKXR3ty+hCHg09tI/LQqZJqQ8tbxKiKzcbqvjB3On7XjaCXRihAhhw9r1zUp5uGOE0Se30l9tm7+OCtKngZ/7lXfl4Bimfr70RaCLMm600H62j7iBYjVO1VBdi49Ad5N/qDiHI/YduLsn0uwiWiYGdpdNRB9Ym95XBpgwD3TSNP9m8+BqQEcXF9qDa5mwzGYBqhR4bHaIjOwpaSKoq+HtivAJ+4+A2KzpNYIzYyPsy7kpKeE/BeX55b7ukBzD/0cKfBwhHUaCz1ueqdAvllTxAuKlSVHOppwMuQO3ZCSnZ+w+6Sogs7wombZ2Z6QZnLQRB9oAyGG8yRSvuRZpkF8DXaqmDxn3uGKLNxqGUaXVr0yA6AKpbZLTpDQStUVzbpATBhGfV8EzCfL73025RZrs78rBlVlbwmZk6Vz+Rk+jQQwV6ng6xfZlI8toK0DGi/EJLXpwneX2zrgBbK5jEIRBivlcyOepIAPeGV6FF1w6amMuzclrg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(23010399003)(19092799006)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z/M80OhcASVfZhWTvD7+yE/6+K2oRGy86jq6Qabj17XtD/yt4hUR5gQ16Cw0?=
 =?us-ascii?Q?W8n2LZyNg9ZynzvbS00Foz4XhuOgWrn8i06xGhCo8nsrfuZNbAsqRPTcRHzb?=
 =?us-ascii?Q?8Z+V9kN3VWfG2oz+pZzkUA866vvgXaNqayadph2EJzp87nxPy3XPKYxAAf4T?=
 =?us-ascii?Q?gGmjYhxUsY+MOfwc6VmOcdZ0ZxzwjV253KbnDM6fPPXKCKaxVXJz6hAxRvxk?=
 =?us-ascii?Q?Yxftx0EBYJ5uqi/w/VxLsFwM+HHy7Jp67YKP5f2e1ap/3PAAvJfS4Fyhdocx?=
 =?us-ascii?Q?1tkGKmnHLroj8gQV8QYDaupSly6yZrY/LttsS30Eaiyf7usG1SnudXF7GIq1?=
 =?us-ascii?Q?L/c8ICRYPEeHAk63EqdW1Fb3kDRgLsz3qONiUCIEQ0pRCf2lwUXltALAT67+?=
 =?us-ascii?Q?NvjLSjwFpExHuTItN/kJP6LgUdSQHQERm2pe/JjA/2TVJY8mauXMabyvFhvk?=
 =?us-ascii?Q?PTegWOMnWHkB9h+pJxhLU2247OdHmNAhxw8NezzjemkA6HEvBhrDlZCiJOYX?=
 =?us-ascii?Q?5uCBMFQ/z9dtqh0DoOVVGA69WBM2o0ciqnr31BdtGcvEvzqDvVlUWZVx7AVn?=
 =?us-ascii?Q?b3LhnY44RQyOJrhs7o5o2qTDOseLhaodzj0Cxvb38BhqvKfIGShak6dM5+83?=
 =?us-ascii?Q?PrqMcONPPTLKc7UnvqrUU+fjdkZz5gsqHgwzKtGvmqnHhrIE6BhKzGbPeLoL?=
 =?us-ascii?Q?psJFdN1b9s92HupHa6DCL3cu7bPkakQilgWAgXn3qxZxlWBj8v2OO7/oQmgc?=
 =?us-ascii?Q?N4uQq/VkALrcvdgJ2e1ZkcNJPTjlpd/TVPPBx+Y21uqYM5o92l6pU9QwkWMV?=
 =?us-ascii?Q?JuVqOhdmYsAg2Dgj5PGnfjvn1/UwsylbYb5i+F6KNZE74Q5+8NSRdq7p6DLh?=
 =?us-ascii?Q?G6heWa3e/7fNDQWQ8/mxEvqWM9pqc0KGXPcvL6PlRrPuneB2geKj6I9cNXGS?=
 =?us-ascii?Q?Q+DwIQSSw/ge39GLZdLTcnBri1tLo5HISpK0jsIEQYa7Ckf6WXPybR2iyG1P?=
 =?us-ascii?Q?qKN99hBoOypCJoJJYXNHA044wjDJTBR/J+xM+1E+ekHsWiCLrao5h0gOoa0f?=
 =?us-ascii?Q?txy0M4fx9KDKc1fo4eLMWsCGZCXTsumMBWVAufviimCg0MphM4Qm/7HftTOM?=
 =?us-ascii?Q?x3SCBNU5tNum65L+JH0JMZIUzXI2x37qINWFlTyCDo/0JufBk9lvfFw0VhBA?=
 =?us-ascii?Q?boDkQbtEbeP92aSeF2Dc/inxfTdR/50H7fRbfGPWHHaarPFlbFkm/u1/GnVu?=
 =?us-ascii?Q?R6JbVmtGPeAsHGXEqUakMRzR2IBVVu0xhocGI2sY4cswJvo2BZV+uXEjnLeI?=
 =?us-ascii?Q?V42aqk1v8t/lYs2rG7W0gYg09B3hmFtdzOQTx9Kdfs5UZ5y5ndMx0NE5+roh?=
 =?us-ascii?Q?SOQ8TjqkSJubCF6V9y+EZ4s1YWq6eHaiQ0Ag8M9CE77p0F5ZkNOT6hKWxQPb?=
 =?us-ascii?Q?FY4cegDGLzTQEdRYHm7W+Ut0/elulwERn3v7e1uejXv1k5H13qffdflaBVnx?=
 =?us-ascii?Q?Ds1TETVjqjwd72VExumCgYDfCP0sIrnhbVKYvm6m4X1jdxrLLvbftSeaWUfO?=
 =?us-ascii?Q?w5bDD6B7sB70M/OzWm7ZyboVWB7c/gGf2KuHy3sptVPyMRCo27vBcw2UCn7M?=
 =?us-ascii?Q?GtmRV+YPKHas/cxpAaoBsiT5MAdbuZYiX/o6QgUuKxxaK0tbpapz5m4CoJeW?=
 =?us-ascii?Q?o+EMztX7+qjHPv9jQUj+OjQEirHqEr7ISKvjEXWoxNv3990DYZSXli2NvwsF?=
 =?us-ascii?Q?nfMO8TYaKAIoG/0WrzqNaSoLTwQ1RHtnekJr+fR1kRjTEZt1I/YVwxCMvkwm?=
X-MS-Exchange-AntiSpam-MessageData-1: LmBsg1Ig9HcXhgDOpDd2kCCXZmg2lA3QIYs=
X-Exchange-RoutingPolicyChecked:
	0RPIvcVrCr4uRWeUnsGYwcW1OBxoKaWmfyHBhucRbmbYZKj1/3b+L+ZZY7Ywcpums9RGz/WGe7/Bt85ZUc4HlP3g4FdPG6fWmXlifnm4ili1RJECjuB1R1mOfEhnYQ+Em0zV6JV3Tvu3ogzhXQzwM419wFdeaAeMSMo7akLeft4KB+Vwwii/CjPgFIa7GW6h0O5bmjAoMzHI0UuazmJlbkSbByBYpJZn1WOY5ECF7o5MujyUUkrV0sunU9u4RFsSvwVrEn7DsOvvmmuELVg2Lao0POrrbzy75r98wTBa1DgUtALO6Q+2Gmewp6KxVeE0nn8Og0WdZjjYy9KkFKfZ9w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OixIitMrQt7tPSmfNp0H7amZueGL5Vnd058Jo31svUrP6M9dl8CdBcNGNbulpxYNLsPaBQoeCDPXVJuZUjm1PV5c7Z0NrgvyQtTKi41HkkQauoJIcmUhA9kwCJtTpOv4Nl0TVCvPre+mVy0sei0uGjvT6jVhQc6xcsoyz4Znc8WiIjwywh3n8zJVP6I1jT9dziOE92VVmuLpS9rB768EvJUZ/e6l6WVBZ+SWUiY1m3i88DaWOJRfI6jEv2Ttu6ugioEg0SLNwhwNDg9s6jlXCwXNCQ0StMQcrjdTAZ6zM9CxJkqmVI67Nb2sc6ngRYSJl/GDtmCFygmYn60zCt89OoKW1t4WGZGlWCGSWWOTFQyWV+1cG8NIerLXb0sXIs/bhULbzI6gCcdaatrh3XAjZ56C7SLfyTjlI7VR/1+LE6VCMWm4zmz5E2FoFDE2781hxeOJXf0rBOoMniF/kIFxoVNn4N6UM1+GosmhSeYvhIhQCrh7eAakQnTs2C6aAF9Il+370hgD6Up7dPydWsKg7iRTMoVdeacI7H6EEohZnc2hPga8PYfkAHDtif5UepDeaeIk1gCq+i1nViLNAUMhYZ2ltbzbYajgbEbH9727iU4RVx+hJUZrjhZd+g2YMO5c
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f114ae-1177-46b1-c4b6-08df26c707ce
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 12:07:18.3454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: axy5vOl3lnwASHZ2mJDjJmr5XLWo3HZm6bG1hYIX9cC3fAn2uYuw87P9KJ8yDKLnujF89+C+/PfkEF7PegrZDKtAB900YSynjLsgNqLJFds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7886

check_bg_is_active() is only called for zoned filesystems, so there is
no need in using the wrapper for taking fs_info::zoned_meta_io_lock.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index f85b549e5a77..957f737cbe51 100644
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
2.55.0

