Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44622F549F;
	Wed, 19 Aug 2026 13:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787145433; cv=fail; b=lcONLzpGIBjZH+wYAhhVKD7jVbHF0jEp9OgLMWoQ1Gv3fgbtzUY6M/s9XO39q+tMxi03zNuzFo+crwzBaWmQ7aPMbfATTU+NwWIQRUZ4abCOwKoVZDpoYi2NOQRpUA3eCZryjrfTpn0Nq/KdH5dCeq0IsM4aF5ooPkVRqiwBlB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787145433; c=relaxed/simple;
	bh=AKwieqcg7IsdS8Hr1RsTzsUmwHjDulhAlRJFqb+8/+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=elBa81uB6vNGZGTPP8GmPWgihSC6LcihWvc6t4AF9mlJWAxroAwjdY3tgiSkkv/UQ+RCDgSzQ5sfrP8CKbqaiCpv0aAfPDV+CZZ+g/EmmLbFpKvagXuZ8aJkGS7u3SMHDEozeql64Cd1Ow/+yMD4TVagI8s06IhMxYyAmLDSkzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NfJSUw9W; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=VZ3MqZvq; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NfJSUw9W";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="VZ3MqZvq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787145431; x=1818681431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=AKwieqcg7IsdS8Hr1RsTzsUmwHjDulhAlRJFqb+8/+o=;
  b=NfJSUw9WbPaBKc6um/+NJADLUNH3wZsGRcg574evvLJvnIjVO6/zTrsj
   EvZDYJFPKd3NojcNRL5itAkvO+00f1lU/DQN38FN3FjJghPSTE5QSZ876
   2wvDyML4rQ77+mL8Aofjedgfuo/SE+3sN68FC7OSXA/rc45znWKuAzaE2
   3YQbPmpCp2HKpwf6J4ynkVhEIFCcxtslDJpI6PpL9zKK51XepgZ1ugnp9
   n/m19BsZZ2025fkf6MEGV/0NhwV3A/fLwY673ucN0rwEgC8zYWZnY4nBl
   Y5U2GTv9SRF60aDI+Ze0RxMO2DXVca7GUhDzT0VMTycYZBcfRcFgy9hjj
   A==;
X-CSE-ConnectionGUID: j75KS4ETSZyVdbIve5d0SQ==
X-CSE-MsgGUID: VyL3NIYiR4GSQzZWvTclgQ==
X-IronPort-AV: E=Sophos;i="6.25,231,1779120000"; 
   d="scan'208";a="154760875"
Received: from mail-southcentralusazon11012029.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Aug 2026 21:17:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c2er1RQlDrhRJ2RkalK9ts0trbN85zy8ajVDq0wBpF+JqVJpPeCqD1ZAVJDFyQxC4zje1YZSi5wneeFeLjjb1x9CbwhmbQyMthViG0JCC44g9JY+yLUWUKAplCl87ciaY6tsG3jtMjPcja+lnfE9aSVDXGOZ7D3QIXcVNfUBm/W/bJMYvmCCMyVeHSDVVDSgkTiBwccbyGwtZcQUv6yDB7iczIjrnzGRkvKdT7tsFxU1XThcqJ0N9D0yQUP8DhpL39zPGOgaK1VAgEs+tLPMgNluzECGFU9pVHiwWYmRP95SegdZDhWLhkRt9UycIOHTIXO1GlRGdpVgUBlD3Q+OkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7utXufXVNBc5BMxsIz2mywg9kh9PnE1sf5JRFwN4eE=;
 b=X/nKdC6FajvBkPdqiOpfzhYQd8dE9w9fhEaqht4J+oUUzUbNkhrh0GPU7pbejLS9J7dSQXGm/cePcIpPIJzv/WgGHj0SgZOJVAw+BgwTXo28etlqqZTSX1cBNpftqO9BqCPxJKWdD2KgUTbs5e5zFGfxKqp/b45hIpEh55Tnri2Y/a94TwO0sHf8jwt1RkopIuSmYIL7nbguXNkEmLxis0o91ADlnZc74EjFRFowHXHtbRGENAJnBvZalooVk7mggCmhpghvd7eGhqXFtYOrvhiDK1lI8R7t+H/K3MptCJJ8jPgGQNhw2gY68jTFZKpVE3FkbtN0eFxq08sn/oGhDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7utXufXVNBc5BMxsIz2mywg9kh9PnE1sf5JRFwN4eE=;
 b=VZ3MqZvq7b6s4RrQL5KkHFRwJegD/71gmSGrbX9+ogwys97chUJNo2kIUEyoXIInOkwu0WCAVZMquUwEBAvOFYScqcjHyX/YygeGyLg8rEWJfj8GmRI+u7ze9zPL2JNEg0TuigN4f0wBl07qc31dHmMKsiEjhUYCDgoolnUv0v8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA0PR04MB7385.namprd04.prod.outlook.com (2603:10b6:806:db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 13:17:09 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 13:17:09 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 2/5] btrfs/199: skip on zoned devices
Date: Wed, 19 Aug 2026 15:16:02 +0200
Message-ID: <20260819131606.1478488-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8a0d9882-22fc-4ebd-7966-08defdf42c61
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|23010399003|19092799006|6133799003|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6I+2lIjaaByHoX04fsGPZlrUaw93/c1E3GZoUzZE88k958nBqRGRY5nDj7Iiw+Zsn9XnZ8ZOW31V9cBjKfhYXOI9wTNQVQcXKcotL2HlgpjTjeVSgYRaC6hrx5WkJs4b3Rwy02vqviDpo2mRbF+2W2xAkSB6Whgab7aWtRINAxHFIS/Sf/0vGJcvgaUbkml6V4xf2Pio9/iX/GFPp0B8HbyB5/spNeU+RsMNIjooH75w1fSOD3LcDZHuaqB3SuMuAG/7N9/rxc0KmaGnHH9rvr12UA3gPe4vjSVMEwbC7XGnRpnCIfvxDdm4FoUk2tTQxVKKnXQ7tYyOEOPRmiuZMloId7paq037v2j9p2mbAaWksFh/i0in3mc2cU34WLmJpnJo0+xG7drpSKPkuf1mPJrsLxNIDMemsvbCgVFnNnkGwK4mTYr3vUyrpwAmPT+eIBlcgfcv8xyDnPnWXv2UlmEXngfUAlawqFth/s0KlwjLxWk39gOEtr0v59a04d/0tIyBODPVQpMUpGe16koGHlBxhixQ2DR3n1C2p2l0GROvJPgysByP3j0cQ1UF2iHEv4PFBBeo3zIEQA5dNSTeB36CPInrdvosgPpNd4EEnHto5mF+1XoB3Xz+ceRIpr9S8tXSVau9QJrIQ2ZbNFMA7X27wjeb8qXrskq4t2gEFrs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(23010399003)(19092799006)(6133799003)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8MmkfZSPBWlcbNHvwdQwqi7IIc4b9JGVXsn1nbX0qXuXLa7jhDMMYpHiEZwU?=
 =?us-ascii?Q?MCkj38AlDF4X8qwWycCIqjaa6bL2aEds5m3bXA/3vcSnKJ+aofWy3xV6PxrW?=
 =?us-ascii?Q?gZ/x+Rk9lq355Fg/ISKPASvUO8FSElO39l95NEN7ES0/TGgbsVTioWdrRTmj?=
 =?us-ascii?Q?YnippuGUtMNHgxknzkUfNbo6v5gc3BgL+XZMSyZeGe75BMqXsGERMwC9I8Wp?=
 =?us-ascii?Q?aeq/DoUfz9fpzs/7R4hxGrngMRcOb4JXr7tNlvexMTWd1wrRB69qPr2utewb?=
 =?us-ascii?Q?pCB2KPsEH2llQZY72JOLICuTP77ujCsVjHGCFVWB1EOWz5kP4MCxY9hJMpvm?=
 =?us-ascii?Q?Loxg5naZqMoPrk9IWW1m6m3w/vzB0cDqosYNASnuh/dTi7YRYgUBqFKVbCSo?=
 =?us-ascii?Q?lPfCQnjZPRUDLpCcKnPkVA1dQQDezijD+82vNMFFsuRaQSzBkW7qycQQYhXD?=
 =?us-ascii?Q?kZK6C6ZLSK9ME/HbdettGVp9moSnxBlt57Gl6OCAdMOKfEvYTSPPKSEcmnwh?=
 =?us-ascii?Q?sLNHbEayzmKu6awyeZDMptFIO4x4u/L9VAIzHVvhtL/8Bn5BZXesr80h4VCc?=
 =?us-ascii?Q?0Iixk2xpRHKNAvzAuBdbsbPmMSs7QQ7/Grw4U6ox952l7+sjVxoiR54eN6eA?=
 =?us-ascii?Q?Sf0pGUHDVq1f1ewBsl+sqyrFzuAOlTeh82v5Yb9fugWEQvRtP6eWQmOVS7QR?=
 =?us-ascii?Q?7UpQLU+mUNmX4tXgAfO5TGPWyMPtJRiVV7J4IKOAYUA3kVLZAbPWSvYrNiV1?=
 =?us-ascii?Q?4Brm7nI+V7yW07WupAIjvOIm2nruhr0Sv6ssjNh8aCJCgYG+ShzST5m+36HY?=
 =?us-ascii?Q?tBjw0nZ/Nd6pBrqdYOvcmLZis/b7A8Fr9WjPIQt5nZB3jVpVO+0c6VLAUxaH?=
 =?us-ascii?Q?9wEuZthduZVCREepfbS3yIlCyr6siN2AIxWGxlGmwL3RDkXOWbtmXj26BfTN?=
 =?us-ascii?Q?JyFSjhbKaaPZa6QVa2QOmENfUH9IiPhT96utX507lzp+DSvUDeS2Rml1HuTE?=
 =?us-ascii?Q?UwxxYlsK52qplHxXJByQR/NcI2YE2dTOFwogYbg1IWEMavZ8FkpGcuYErHRF?=
 =?us-ascii?Q?5+YIfwutp3TwU0nkhtW8eaO79AbOjxY5r3m44ARkv2MRk8ZTmfeZxCGuNx0W?=
 =?us-ascii?Q?SW4K9fp/7E5rrPjV+eYDEqkcVV8VKXm7XxO/CRsRpvW8STjDylflBCZX4ptS?=
 =?us-ascii?Q?VqTYfoyF5PF/Vccez7BjF6du71H0fEkzyhsjO/gavZYz2Tjosi80kdlxd+m+?=
 =?us-ascii?Q?vNLWTMq4Q2sK8VtbwQqBKlet2vdUrsKyA+RI+HZH1fUuJxks4fHJrxNS0Rrs?=
 =?us-ascii?Q?xJZPTnkyEOwvxgatYSNeSPStT9Txx3vRds402sfAZtQ5OdhvylgVO+GWo1pZ?=
 =?us-ascii?Q?8hnX5im/drsgNhhYVUOgzIaiX4RlL11CMZ6EksN1ha0hR0EeDwtIhfGZYboG?=
 =?us-ascii?Q?OvBbQNOjezDGcQve1kUNDQ2zk0go2GshSw4tm0cKRmDDD4SK9NsboE12bbB7?=
 =?us-ascii?Q?ip8VXcmKOcOYjnnDUb5PCuKAkpZWslQXQbMeARurcW+ZlqI0JaaZ2rHXYxkS?=
 =?us-ascii?Q?Q9M8ni+Jp144lCaYvaTKRvyb/9iX2B7uQqBbwmWpOnhmUbMMEZQQbmAyuApL?=
 =?us-ascii?Q?WmDUB0Tf+RA6BoteB7JFiu+okOHKtJFbSYMsTatFUK9CftQU/XvJOdWmnha8?=
 =?us-ascii?Q?aEygkjE7c0vy3UN0KnFO+sBBfmSUJTpIwAvDWCDr8YAiSYopvzFgYtKy0+Hx?=
 =?us-ascii?Q?YFCF9efS7HUtxeJaG9hUUz4wtvXwUaF4xJ57gWfLzLykHG3YcsOP0i7m+2rP?=
X-MS-Exchange-AntiSpam-MessageData-1: 26Gisy7BVVzJwBxAvJuhZqIL4/iCNWJza4w=
X-Exchange-RoutingPolicyChecked:
	KKPDuasCXV6r4HvydCbSYHOxkMVUc4dfHergZTXWzGnDbsVx/jdwQ0bamqpP1VQsfXlVWd/aGWNJKWfpT1cxIJYeq4YPuZQbTQ6HmeVZVkwZ8Utwbd2GjoKcOv4n9z3ATLAt6/q9lYXgOG1Hy1nJ+rQZOM7kJ8jXdnXKZB0XvwSt6o/P3t7y8LoJmwr2KsCSUbs5zPHvSywtWmxJ7YWrCf2xrUgDVP5Dr/Amno1X0iPK+sUftLbEhBeiyqdnbOgce7LJ4fsdNwunoIo20KU+A5nZo8EIl7fAK/vE2QV3psu6GGVfO8Sww8UFTMeTkgR89MLj6LVeClBcMCXCgxBtSw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4qLvXy2DEEihhxX/ilrHP+3sIQbsROpBWoKRCZusF0UWMLDoMVhDfRjpTLoXvKGjoGvtvERI3X3LM4BJoLGlNqcT5I+qUagcdzJpYhU0gkH79LX6VF7fctIrZOHzoDot4xJFgSa3J+7TupokBWTeZMmhFw35VjNPxNneQOlzdA1zMZoG47twfC4voTujTTIqxERuMEo2BOQsvnmhXoZ9yJhlzMlLeuCOHGjFCZo7flh+SvmdlD8ALdwHeeZpncyvLK1MqEZBkc5ENmRBVTLGDe1i/mCQXA0eNX24Zj4vdc5CEFWsNGMfwWGe+c4fmhX0snyHu5iVGQg8r//k3qMiKv9kfrResTN5yOmmR02hwWJisru1kCcd25GaEw4a3aVlGbO4OlaFaPOgzFFFpvO8S8kfSayVSE2w48t/9z8Fsu464xKUCR//+OLwdMn5qng4LXMTwy1NzCLWO4fFtJkCl0zqrl/H4REheJSv/5r6MJW6/WlJP5WzCHBD9k19sBfSZ2Fh3MBAIUtt+Il2CfI0hk6cIeY4baDoIuveKKfNmQv1o3ypcYVP62VqcnL5JJioufTCpuKbE6AOXQeoF4030gn2oVoG8AITqd1FfXGqeiG/NQLQfs5KelHOMJQIs1l5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a0d9882-22fc-4ebd-7966-08defdf42c61
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 13:17:09.4838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXJmGZ6aF8bnuTO4MxnjIT5KbfN5U7UjsQ/hejhJTYI27wNrxeYw1sJ7ysrjFnXXtl1LIm9qQAj8w+pqgtxVXjkikTXyPstCA3+PROD+FI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7385

The test detects trimmed bytes via the used space of the loopback
backing file, which requires the backing filesystem to support hole
punching triggered by loop device discards. Zoned btrfs does not
support fallocate/punch hole, so discards to the loop device are
rejected ("operation not supported") and the test cannot measure
anything meaningful.

Skip the test when the scratch device is zoned.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/btrfs/199 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/btrfs/199 b/tests/btrfs/199
index f161e550..ec9f3783 100755
--- a/tests/btrfs/199
+++ b/tests/btrfs/199
@@ -31,6 +31,7 @@ _fixed_by_kernel_commit 6b7faadd985c \
 
 _require_loop
 _require_xfs_io_command "fiemap"
+_require_non_zoned_device $SCRATCH_DEV
 
 # We need less than 2G data write, consider it 2G and double it just in case
 _require_scratch_size	$((4 * 1024 * 1024))
-- 
2.55.0

