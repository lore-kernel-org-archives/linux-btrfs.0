Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BEE2DECC2
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 10:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787135227; cv=fail; b=empzK1FqzgBEJSdUViNpYNGyag4eznE3Z9GMaVQBVrXAPDW5uILf7dskH3uXscQWtuGxBskofyO76RW41W082kfDvB7W2WZKMiDZDq/hqjkK2jQ/JTIUyaIkL88koG+yNm5dRSvgQDl7pWrZfQbGvxta0L0+hsk9oefqwjeNyVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787135227; c=relaxed/simple;
	bh=FkOyK4kCGRmRftpK6IZDV3iZIGSBNrAI5BJVP4Z94go=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=getgxk8XYHrUofVBJwO6oDopt2rgy2qLPtC7P6vs83ikwOnSDDhWfewpQVBH7JW1AzeRIBWBH9OYTscfM3mjw20T+LIsFXHz0GXZSc7gF+wqul3nXXSjIerN+m28bAA8iO3RuE0p9WtFEhSMvTSKucHkATv3SfDp0c6wCSFdwZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fVkX1C+R; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=xyuv8Ufv; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fVkX1C+R";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xyuv8Ufv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787135225; x=1818671225;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=FkOyK4kCGRmRftpK6IZDV3iZIGSBNrAI5BJVP4Z94go=;
  b=fVkX1C+Rv8EUHT/aTbXD0a5ha6Dod9lzllpn9mredTbkPaVtxLP8WB8K
   2xU/ic5avLaz68KEirE5iIPgS0zIWR6jbjyGqXhpmBQfHuXAeCaDRAdsa
   tMU5xdc8zHucXwNeMd5cy/d3vXKTD2TzDmwzx/xjy2onad9yKIBwqgiX8
   Dm94vF/bfmKwopHk5yI1TR2L26DgfN+K6pu2ER0cCFKiJ6/xEEHKYvXR7
   dhnuT/+H6DVhUNhQa70VpGDp3U/4VIx+Wl6j14EN39PqhXxi6SitY4h29
   Tpv2yXGbMvSBalUZpa8QcKrUeL07NBZndFC9IxlFr5+LR8rnCzoOXa+Z1
   Q==;
X-CSE-ConnectionGUID: 8F3ITUvXSXigU4tlpbDxuA==
X-CSE-MsgGUID: suEOi4XXTC2+Vuh5lPUTvA==
X-IronPort-AV: E=Sophos;i="6.25,231,1779120000"; 
   d="scan'208";a="154751481"
Received: from mail-westus3azon11011049.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Aug 2026 18:26:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s0jd57JZFMBoGfmYnh4xoNvIfa0D9Ur9IAJ8BDtJB9DJfisa5NNHdCy84f5YTcyGBQ0yyRe6Oz2fT7kbrJ9DSAQdD6+GpGxwTpIoK9cmjpD4d50uiEJshQR8CHcagvMn4+tOqHpD8xv/Yam20iB4GRfKMJlPaIMPwhkF2TklnxcfvEEfdiVmKVtaE0bJE9y5jR5DQ57ob5kY63MOZ0hdqVm2ysNKGxUHVP/JKZ+Rha7WMguNV3LyERCaFkhKht89BvRBVbNPA5fyjPVVJ8CHnR0DLO2LNUBjDkcPJfcQDl5TnklyvT47Cwo+6TJ6vePOGhf9pKPiCcXgEmZdkxD+xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9TeUxh94yaozmbNS5b+kwWfIG7hMw4UAmAFRTfxMYy8=;
 b=gyJS0Q5T+OVYmDGlWe0rFtnjEsNBAZ9P5IJA2xHZBGdGVjZPU6VwDbSk5iEcrHjIUSSoZ8Cdqlai95PccwtzTPWM6hBPj0oC+K+zLxKwEX5vzy7LMvZ75it1ps4Tc/8Udr8e8CYK2s7dvoIdgBjdr25AZc5OE+/ORiL+nMo2Iw7jlcW7ze7sgMjZXp6sSroZipbhY31Iyx7b1MApoEMLNYYHuLN9O53xiUcuKMYHpwCHPhMquAzgEN9kxY4PmaazulzddN/paqcUbRQArDn//m1HMmj6l3uQq+FH0R0VzunfFztjalImC3dGulgPhlVepV8TtkADfTgiI97wjgyaRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TeUxh94yaozmbNS5b+kwWfIG7hMw4UAmAFRTfxMYy8=;
 b=xyuv8Ufvq5VpWMNUujYj2CU4EF7BbdGuxNqrEd5/+1hrrz/VThV6th8uig5k3WBOxHzOgs6mouVtHbQC+ksWIr1Fogbu4/NIE9EdzJYAKRxS3r+NBel2BoViV7tgI1OlbRihurm//gn+KOJZGYKA2fU3z82us+gcQHcD7CjuETA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL1PR04MB497530.namprd04.prod.outlook.com (2603:10b6:208:304::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 10:26:57 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 10:26:56 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: zoned: finish active block group cleanup if call_zone_finish() fails
Date: Wed, 19 Aug 2026 12:26:36 +0200
Message-ID: <20260819102636.1423347-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0204.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::15) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL1PR04MB497530:EE_
X-MS-Office365-Filtering-Correlation-Id: 015aaf83-41ff-4c93-cc9f-08defddc6530
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|19092799006|23010399003|1800799024|376014|366016|6133799003|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
 7mHxlM8h/Qhr40mwuGaD4ZWmCM1EJ3cwtIhuk5h/FFNhs2Fh/f28ojkdiGqNRijGkp8dKgrGRyxAYqsnWm8CU9wgg7eBwNaJS2J0QgsBtOYIi7Ck9bRrRrsHKUMmZkLezHejoe+GF++wvKEDUzbi2AiW01amV5YEqsXCD9LTlYso/RyePfPoelDyDawM+IzYglveW1wHY2jywtLvED5qO+KWWf++NC+oulHKOWbHFJgdogEY3/KC55FVVJ9zHf+5TIBpAxsLPXYsQhjcakFWc4WQeE+CJLkSS5Oq5968N5EVPupnMIEozkjEQmCMNNkrCj5KA4UVMjNurW5ODY5OgnYixCdU4HB88X701PMuPW2TMGlem1faQk08eEyXah2OiWVTtQYJD9Eq00jZ625uisQ391C3sqmb3d+TdWnUNAMmgohHmJ8A32GNrezdWaOZqOUHTCJygReHCwaFhhUiux6NmkQCOBkmfuSNgZAsVoAajVrjOWST1pLPPlEnmmULN9EGH0Kdr92atLgK/ASIxuDyeqQBNEITzZ9Id0UPxUX2k9Oy6RcCgVM/FEAVMMKtOdvk9cAMwyTZfunfj/ktYA7IEgDh3ZhuKwNiH1x8XSY=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(19092799006)(23010399003)(1800799024)(376014)(366016)(6133799003)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?zT6EtpsoXGAZUfhS1thSkTZtJ32r6kAywOInEOkWxyKBxEr5VOP1XvXjKDfI?=
 =?us-ascii?Q?LLVziaO1x/dSu87JL0+20w2GY6AJpIGlQwTuJ6qn6rSbcGKEfnwj/R/V0J1Z?=
 =?us-ascii?Q?Gg9JE4pE7n9Uzr5d/Yg8b/pLwqpOuzuyxICy6weYhYheNrmxBg7rV/7MeaNX?=
 =?us-ascii?Q?dZElGg3cUo5YUBeYsBiRkHRwr23ZppcFiGsj3Wp5Ed/6RbaUNdAhDlZTzPUZ?=
 =?us-ascii?Q?xqp5GPvQi5AN7fn223ByTKlTL36haVralPhOUH0BkRX9BEJ7/RnugoeIHuN+?=
 =?us-ascii?Q?aPcUs6R2dprIAEJQ3NeRlAZVaHxdmEtAa43/XoTz4l0sjymAmR7lb2nAmaBM?=
 =?us-ascii?Q?T8A9nymHjoweuAgW499OObKViQbdcX+jIJAXOy1NrLaJ8fMmJkMlJ7ekXt/0?=
 =?us-ascii?Q?eMH8CPUT7izptWOUDYP7sO/YGPpTVRdLH2JzcwqaWj7GUeo/cDX5wsafro87?=
 =?us-ascii?Q?6Wip/G8J5m/F/hWtekeAfLYE59khCAsH0zgeNdb3zUODTre6u62Tvs/nu+U0?=
 =?us-ascii?Q?+Yooi6kNxouP028HajQr2lXu0hmucKSKzboE9K9eyf/9iTgdmJrSc6Nfm8yb?=
 =?us-ascii?Q?oX3NRuF/dWqRT0Fk33JOQK2oYaRcJ1QpQR3/jdTADdT0q6MFJv/EQWQjLmV9?=
 =?us-ascii?Q?EozpGn3MctS+pnxZYg8H1UFL7u3zgzskh9GCK07VDEwFiazt5Cxn/J3TFIvm?=
 =?us-ascii?Q?VV7hAEQozvZh159tsAl4EtGVOtNdTdR52nPXWKFTQSqXtw7FWpDaR6Fbrh+Q?=
 =?us-ascii?Q?QvNWmIfvhXY75G6Fy8bmK3AMcUfUmvqvpyq4k7gQrFY2YXBe7gGkuEPW3Ud5?=
 =?us-ascii?Q?/MEURzxYk+k0tcbREPakNXV0OF/1ztfVlb51p6xfsxCeDxoUkIHAW90w04kp?=
 =?us-ascii?Q?udU3cPojHzR5s6W5dqp1iHIdf7wvlhuPfrBQ/IGn/m7i+CIXETc3dqqSMx1Q?=
 =?us-ascii?Q?vVhZQPmQJvY5CFDyT4nREPzePoYduYvEnWEyiqJFDhPVrOWSt8UNi5RGzpRR?=
 =?us-ascii?Q?jbcA60X8PBVEXTLR/L4TkQKGA3kQv2HieBaVyu5jQ4rHqmfzX4r8Ts5poFo0?=
 =?us-ascii?Q?2gv6upJDTb3bnjo6aEIziC2VufujKywmsZSVIHBuSdDEacktF5DYBrYhjq5N?=
 =?us-ascii?Q?HIe+Lgo+xO/bS6IJXTKBMmdLnLGRwumnPakP+qybgnaWhwxircYn0SemnDQ4?=
 =?us-ascii?Q?ulvBew0xvfLUmeNYA9O9SfWYrhWK17YqlnnXMScmvQm0b4HJ9u/Tg8tAVwh+?=
 =?us-ascii?Q?buD9lasW7iNBjrAWHQ2ajFK20bzytPPQYRMMAWakPZjgYgFEvgC3k7gNpkuf?=
 =?us-ascii?Q?/zkLzKtGZbh7iE/2xmeq15a6Cf+aMIfx8TAbKuB7KLLbGG4Y0FzFwgSlRsZt?=
 =?us-ascii?Q?26GmaNc0wYOCEFAYDY3MBICwq2jg3tcPdN+SutXd9CCBzEeydXtG4PZG55Kh?=
 =?us-ascii?Q?IRZ6GpPEDEqJoB67LL5jSZx5ch5/ZjRshiAvtytA6y/ghR4wPy5j6OGsLV6p?=
 =?us-ascii?Q?J2Lq5ZwKzt5j1GwdMv+Tc7ukJVXTmHdUpvhiGTpsWHAS2U/+ouC8iunwyfEp?=
 =?us-ascii?Q?q5bBl8BTz0n7WRSwYzjelUtJDPt2th0MC+cr3Lmui2m6IV1DGnwWAT4o+ZZ0?=
 =?us-ascii?Q?W3K5KJCGXAEoIoEhY7DxIZGOw1LDWUEryXFJ6HIx3iSsiQ1n3YhysJWWIM+b?=
 =?us-ascii?Q?qPFqw7287cX8dcYcwkWabRtj6149Za8AQ8Nk/dljQYmRilNjObiuP/McQRC6?=
 =?us-ascii?Q?hJlQ2XX35OruDbZO7HpszVt/KPjqQJpOKu2Ix3kA20PvK/lcqK8YZtXAKZa6?=
X-MS-Exchange-AntiSpam-MessageData-1: JEhxaG8tN9q5fdGW9SbjH++kWRIJzpmmNS8=
X-Exchange-RoutingPolicyChecked:
	K53gSkC0v1w7R2kUBlNh1q+ZOoF4F5QuwSlM1Eg1YNsZmgCShLg9DZVQHXk/V0bYMXpuvl5gsL30KeDM2KTXD7h5F4uLHxdfBckGig6s3/GG3qBmWa3ULAKVD1BO9cBuYwywcjnUNNdveKS268/SYwc+LMacFm+SmV8bBcK4x29bFUeitZJqQoBeDARkLNq9q82iQnt3hTTTLJAO68CvhdhQgHjU9p4NIgzZOx2/H8SbOEHsiGViR/WYb5/oMqFhIkZOIW4d4XlNDflvD7mjzhAmo0gu3DurzvXMkxIoHpEUJ3+GNP2QT2sB2MMjPhXyvpIFWPEvSZPAVJNq1zc0UA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1+oE/C6uP2aerPX6M/Q9VMoWro8x9SHhv6bhXvmp0kVZXuEIeFWoaVl5bx7HQYiKswGGBSArkSymgn0AXeh4/8jQp42+stipmy3DSBaIE90ZER65bi/NpA0rPB2xb5L9y0BObPparLEQlXYPGiEYcEO443haU33EtIAnskbiKCBIAq0CBeFzwtZb+YKkYtSlNELsK7v2vyakLG/BpYXyklN5Izq24kMJOSS/r+Ff+2CnqfBxpMLxKUm3binZJueUyv4wR6HNw8H5po3qicCbM18e/tUcYcuB+bDbaKjO6GKQUFQT6V88r6e0MZ5qUrrRwvUJmKEGk1C7tgCiUc8zDNzRNF3jsYHu106Xyovlefk7jzJOFYfckSGHIG02e27WVpjcq5aKghUbbB4Gjqj5Mx8p/07VYg29k5OpnVVVEYHcAxurMd7ax1P56SbuMB4DvsxBuelBgpLUL1gp0MgL+pswXARdFabpdbupmfBzLv/kuErrs98ZZ0MgRKeLwAcpSGmOgWRemTTpd0aFo5N52VGQ3EFZ+IsgYbQMBoRYvZO08awSenG6s5x1Bh65Gt0bSpfSfTA/UL3CO+yyNYB1gzuSiKXe5AnJZnsKxVhUg+J7UzlfRrDlbzIEYaBoQ/XX
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 015aaf83-41ff-4c93-cc9f-08defddc6530
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 10:26:56.6705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GhlVVf7L3p54278GJnKiNz+jGghnfZNZJZ7OYEV+CNQW0lXmqpM5Xx/NgYcd9h1J6J8fJUzG8Npo18dloeVuJCkrTvwm/NQkMxxbJ8ikTCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR04MB497530

do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE before finishing
the zones. If call_zone_finish() then fails it returned early, leaving the
now inactive block group on fs_info->zone_active_bgs, leaking its
reference, the BTRFS_FS_NEED_ZONE_FINISH waiters are never woken, and as
its alloc_offset equals the zone capacity btrfs_zone_finish_one_bg() keeps
selecting it, spinning btrfs_zoned_activate_one_bg().

Fall through to the cleanup on failure too and return the error, but keep
the block group read-only as its zones are left inconsistent.

Fixes: d70cbdda75da ("btrfs: zoned: consolidate zone finish functions")
Link: https://sashiko.dev/#/patchset/20260818100037.1366563-1-johannes.thumshirn%40wdc.com
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 82c2394dd43c..9d448cdd60c4 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2628,14 +2628,12 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	for (i = 0; i < map->num_stripes; i++) {
 
 		ret = call_zone_finish(block_group, &map->stripes[i]);
-		if (ret) {
-			up_read(&dev_replace->rwsem);
-			return ret;
-		}
+		if (ret)
+			break;
 	}
 	up_read(&dev_replace->rwsem);
 
-	if (!fully_written)
+	if (!ret && !fully_written)
 		btrfs_dec_block_group_ro(block_group);
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -2648,7 +2646,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 
 	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
 
-	return 0;
+	return ret;
 }
 
 int btrfs_zone_finish(struct btrfs_block_group *block_group)
-- 
2.55.0

