Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AB2157A5A
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 12:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979459; cv=fail; b=DketzOtMFgTF1FbyBdpnkBCLj5aCG/4WMY9nRRlnZ7zVKNk1OXRJn/A/Oo6eh49p6Y59XbdVLNtRVRn4+XDrhB03aGt3+w4WqroMGaiWdngVIjGM+Zu1LJBKCztoXfThHsG3nfBscGS3x4kM7QLC/wX1CsPbr5hD4VXcaqhNyE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979459; c=relaxed/simple;
	bh=iTaXXyircoxdRAa8RbgIxkd9U8OTeWxEnIq7yuulmQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VTEKZmMkd6PjJjllz93UC5ZAbKOPBrsn3D+mon8nqr2RlI5p6uQL0aB8R332qOAyyGc8/jV9gc1NKF/ribovWKPdHPTDwCJ9TbIEW/BxW342JUW0rewqd7/gyTgN02qds4Xj/1yYg/XHtIPnKRyejnSzmX8gcD3/+F8WCjGmYVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=XJs1M8O9; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=oqjKKvCL; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XJs1M8O9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oqjKKvCL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791979458; x=1823515458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=iTaXXyircoxdRAa8RbgIxkd9U8OTeWxEnIq7yuulmQI=;
  b=XJs1M8O9iPsXrkgg+1x5MxEQh+MwoqSnnnd5nwwHS4tug6b/Gg0f6qZ+
   e+E7dbCPpCfo97DhEt0xl6iNyt8CU+uVosMYyKXY1oRsizq0LuZIxZog/
   XYBSqWDBJWoKHz3+kSUK5sQQqNGt6PRAMlMZGFBlflrZNSDVZq9P4aWaT
   EkS5AP4JTBNbwIrlTj3U5e8nwiS0YM+JNAWXjONY9avNbZN93qvr0V/nV
   07hwAdkW/tJD+FhgUMzwY86LBLJO6bjlbaiq3orm9REL5SAr5mB5TlNE7
   Ec3GZEtQCF5nBTxV7nTuiWPXh1g6ytne152fO7OxrEx9r5soKRmN1FdUm
   g==;
X-CSE-ConnectionGUID: YBO0jGL1RnmGWIVQ0lzzIg==
X-CSE-MsgGUID: jxOeYNMtTL60Nh1ZGZ2AUA==
X-IronPort-AV: E=Sophos;i="6.27,157,1786982400"; 
   d="scan'208";a="158077252"
Received: from mail-northcentralusazon11012029.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2026 20:04:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=inY69us8ysn16sCMWKPqO79zDhi/e78/hdMJDuvQZJwKBPEf2GQ4p+LaUAGa2Msug2Ku8tH0ZQNYU7Po0zAM6e1aAv8bPB5QXqOL0rBKia814vDWF9KPxfTVIwMKz0CQpEQ16JdvxmfV2skCHoVSLiD8xI5fpAHUV0fNEDbjSmjsqh1kSzht7ILZ9W4RmWRS7+QGImd31XOqMU6AAm1E5hGDdWwWDdqCCQwkrBmccKVt0iEbXBvqIgdHKTFbgMuktOAFYFXzoYSpsG5hUrPdF1jor9coQ/jvOQGcQZ7Y3JahoYolimn+k2E7eaW2cY8noMqEhl7+xDa46Jm1wSDGtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLTLcfJ2uBffICuczM70nPvb1+EsDx+Wfy9W9VcXCoY=;
 b=CzXYoTcwo32VC7sMfVvgH54K7ujf3VPpVgek5P8l+ghzfe7nNXtYVEYNUQDQ2RmUDA7umqEazFGJ2PqRmnkfVt3VLPD9mbL2IYc/y1prcBRU2mQjDCjC4aqrl4qKKojZ/l1HdYrd+SWaNr7R641z4ulsg5HxABMb+j9sOXdrsrGHhhh2BklKUiDxppRNDsucLw2JCYdSkiZmpuAZmA4XIJjkhGWX+cPHroRSjMGLUiMkyRxm9AD6t+6/hgtmeYbZA027CoCTPXUzrsd6rb1lplffBm45nEeFnKz+Qlok7wH5vsSL0Q8NNHZb+KKkvaRBtETdxDlAK+oWGBhEWFguew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLTLcfJ2uBffICuczM70nPvb1+EsDx+Wfy9W9VcXCoY=;
 b=oqjKKvCLVyEfo9eVCplSJJsyJStC9LbOzpZa28MhmUFUKSEHMNWxfBPcqHA9oEfia3M6wOcL/FSIV0MYROZFEzHwEL89EhI8vgMIjZYF5yc+pMWclaSvpH95JXQBHjz39ozAdIKU/WYNSgK0EG3SF0DUeZ5YE39FS6MWfRxaF3w=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:04:15 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 12:04:15 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 04/13] btrfs: zoned: don't account superblock zones as available data space
Date: Wed, 14 Oct 2026 14:03:43 +0200
Message-ID: <20261014120353.757931-5-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0f53e246-0f93-448b-602b-08df29eb445e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|376014|1800799024|18002099003|22082099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	SEU/w7Njpq73cUtXiU5F/QUmxLxsRlGudwIkEKYXEUoLdDN8YJGX56J1ob0Oh5h1GKCt25TgRLcakyPw6/6zh2Fbjut/vx5P8KxY21TmBqbS5hmwmaCdBhZyBdBgRevfTeIGkQLbCaNQd7mtI1ylULPEj+bPjlVQ1DIt5ev+4j+kVZEimVSfDKnmYVN4KYFI7SbgDbWMi8oAP86g2yQgP74XOayaY9RD6xOElAG9GaVsdJXJOg8UNLYkEAt338WzAmeF7EnwqNm6wKLuMOboFx7aDN/Fkv6EgDChOyBs32vSQ1fRfnkng2vErw/zaJKq5Fe9+oQVXJHqafdu6Wgc0VgK5I7SrUqnlv/Js6I3ZpRi7+D/xkGBx6j3CHFEMvJYg+5BSL95klHwlR8bqbpEKgcRs7+thu5qDgWOhFDZ2NGpWzOrUUJvLd85TPuwQoRKb82LQ28EUnnmeygLyZcC81wn2CVr0XIsb11AlQSSgAE79HO0my85z2Vs6rfW31APAnTxNyu/YODmvD0NQNkjgCUlpSh1HltIq4j8VBbHPeI5gK3qc6zVrqMp/++1EubU5vXmuKpViRPgklMX2BA1DHYy8UcwaIVwPiiABobs6/xrKW3gBOj2fcywWh62jbrZmy8QuqATOA5YDHFPd9ayp+DdcHJFNNMnSaVyPZtpHms=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+l+ZVtdf+Kuij33u8A+9x7eLUemWbKqN7BnODBcy6neU3KBtktsSQNNVEE4h?=
 =?us-ascii?Q?/3H7Gp3wpi+dj5mOE4mqAd5mM66OsAFcyX85W14M037YmqGC9AjITr8+1Vrn?=
 =?us-ascii?Q?HqPSnWQBycWR71GnEK6s34vC5Jqa+G5zPpTPKCBthfxk1NGP9/7nh45cZyK3?=
 =?us-ascii?Q?/J6EnzxpSDq2hPw4+VtIjEK8TyWjDoi95OgD8JyYnOHzI4tlgtizRXhasKeY?=
 =?us-ascii?Q?E/EaWM3KbqQ2nz0CVge62iAqTiEplDW8JEvdDRMTHgMUXuGB6lopANWl12JG?=
 =?us-ascii?Q?rH1Rthc/S9PQMBuMyA2KTHoiqUR5G7GxR1wCgoPosbsmG+bdKm/xjSJ8O2AM?=
 =?us-ascii?Q?wvkF6mM0SeyViJq2+GzrGZefhqWQVH5r/AiQXKn88X01vOTgEEh4mqX+9TOU?=
 =?us-ascii?Q?HbKXxPIsPjW2jg1QCMit7f1bU+skLT27obNlv3y5bzR9hB+KDtKqGDxvnuPq?=
 =?us-ascii?Q?JAeCPSZVuWQOhfd4syUNgIEy9dP9mPdaZ71b2jnEuebPBhVBpP1oIRZFtesk?=
 =?us-ascii?Q?PvD9eyAmFxZ0rY4nC0V4stKOKvF4QK6IANF9F2ojQ6LmP8INMXYlVoex23Iy?=
 =?us-ascii?Q?9NAcJUFdN9jbD5x6uFRlMrHIkQvt4s3UDEAz/MTTTDowOSSADXaq+T8h56NL?=
 =?us-ascii?Q?85Y4CBBcizLd8CXvx4b9i4EmalwY7VgunLyYZGvHWCLSbDBxE3AdrLpyjzf5?=
 =?us-ascii?Q?GKYjpxxid+EKCHH9qSngV6HaGeGHHtgi+/X8OWzP1GZcBuiVR5aaSuHfx9X2?=
 =?us-ascii?Q?jrA1GqHEZSRnqgR1CmVaoDOjJASSIz8XW66/riUYb/D44GTxq+BUduxlCJ0n?=
 =?us-ascii?Q?tzxgP7m5CxHAexq6uaAp1Vkrj9CWWc1R1+CzA+NP7EqZelMIj/RZGhz70aS4?=
 =?us-ascii?Q?84tztYTWq+2lp2DVZQCDSsPr7wSELUIqkOHjUpWDmNUy13Ur93oYKAxDFe95?=
 =?us-ascii?Q?Q203Fej94S/1tlwQwOYaHaAN2dcEADZa0LI6C5olQ9amaKP2MrN1iB1WTwRS?=
 =?us-ascii?Q?tLavcA2QVKOYuLuaA1kntn6Gf28aCC43Kqsv+avaLD4MOFNivtjDPBwD9yyz?=
 =?us-ascii?Q?u1NDqREEuR+6pJw2Jv+BMCusFVUKJsUaNDA8n3tLYnuetsgwEpWUzGmtUxJv?=
 =?us-ascii?Q?qF0ZjkKAr6Pi73d+a1sDlMuB9SHBWV/KXzbHb1FKL/iOKGXzoAApNdSVx4jq?=
 =?us-ascii?Q?xB5loRoDyuaj6y8Tv+xP3DgBorAIolI+6q1Ng+S71fulAwed0auJ4K1ApyFi?=
 =?us-ascii?Q?6u52Zhtx2Jr25B6TdZHXCB1W9KsMeb72zxi3wlQbXKlxEUNrbqFTQujU533E?=
 =?us-ascii?Q?hEASLdcJLzbYxRh1uTVCetl0Atuhli5R9eJ7rZwjDqovw1af3zUb+HDevDC/?=
 =?us-ascii?Q?UaSZLdeXZHGYCbeFwuvRIc4B0XWpYeWw/t3RWVCjqey2hO9wuAc6O+C1REKG?=
 =?us-ascii?Q?XHqqEblQLQwvrIRwQaRgv8VcWkOvwc7kJnCPBxrR120L357UteXPeoZHnji3?=
 =?us-ascii?Q?fA4hOLGAcWK23wUjzsSmwN79EpHrX2nTo2Z+VqNYBqeYEG6Gw0IgZi8enKc/?=
 =?us-ascii?Q?YdTlHLQf5InG4NVIj4PTQf4JfOeHokfxmwOsEshNsLfWxrCNqAnaw+r/AxhO?=
 =?us-ascii?Q?cIDF++qm4I5vtOZ/WhmmNw92Kf4GnZkaWBsjMyzMhNFOwqeyb7Un4OLx3VP1?=
 =?us-ascii?Q?Hr2J3xjgPogHcmVpe2z+rVNE9ohmR8e1aCZ4J8o90iR/HbaitMohuFNKvPrM?=
 =?us-ascii?Q?MOaPeXWiYL7BPL93rWgoyhdggVxbcQDqMhUCRrycTs15VO9QiVoPfxHik7v+?=
X-MS-Exchange-AntiSpam-MessageData-1: 7toFdckUS5OySPQ5BfnwlZ0LYQuL5M/+PZg=
X-Exchange-RoutingPolicyChecked:
	GdDeGrFSc88QwSejRLPV1e0+OBg3ACu/5KXjII/xCTG5BAxn6BbQ4im20PJu3U6WID0iXX5JLI7Nohttrb2r7HKpEx3vGTUt6y86HEUQ8n4/xVZt1MVv5e0aIFHnj42TDpym+3Urul4Uv4tg+Qkn5xpQjY+l4UumsIiFMP/OSrNwskwtxrCASxi21lZ+DR6Ddg75MMMaKj6Hdzq53GJo3VVFDgK27hDr0ETHgx9i9a2ceDARgJSh7yTv1Xwj02N1l4DYG1H2O+q+A0GUq9AyYDYcjl9zi5MlLAld10ybj0jlYkJoDRAaNphunKNerXElzfJ2NfiSDuHwlgYf77EP0g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	miMSrgXDfDYPigw2mgrP+Q/tYbMLCeDR713VH+BEo85AYet53D/6Y5AlZLwZp8Grv/dmVZ6zELofmuWQXSoCtVEPnQFIw+lZU+T8HHAZMlP2oV85GcfiK0sbIfuZy8oOH4Dhgkv6SV+CuLOt8CvXnGAsLwDZse4WmvgBLA91v2a+w5MkJe/+EzVNOBXcI3lPC85XjmtOJZR66SMYsug+I+7N1fYmkEHjAoAPDw08Ja9EbZWZR0FxI0UUoUN7tldS6KyBW6JjmAJsZ34zPwulTGfwcLZK7I6hCgX5Jmxr9gX/7qZtXvi0WT1rFGx0Z78l1D+0ILK/Sc8eCSpWVYOaJ4iQOOHFeRGOTQFDS4bLYUofRHSw1HSg4BMg6RCRudC8QpaWYWDUp3l+7847rm+sgkF6upluFlcNElcK+L/Bg6xsF6Lxa0f8VjgfULASSJruFy9j5h3k9PIDXdRG21clwxRHLCqFtqABlg/yEuI4Bho7ZGqff8zhlCGTkninF1Purw5ZuNt1Sf8C4LLE68luNxxwx8HY6t5kg0Gk6Wk20imLWmzAozXE6L1ZkV/UGhRU/S4iHNvp6cGoRiHBt0Bln/RUJvoHdS03blwYt6Tgv8bcPzhn8SEvAQjkS8zlSTJG
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f53e246-0f93-448b-602b-08df29eb445e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:04:15.1830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Swk/L4F5Y/dIS4odZpkNihsO/0yM9QSeNxKwvxGMoATCbm9hyPV1HepH529rOB7yllJ7HEjLRkZp7EHCnnDuvbsIlFy5fhKhKMXgl4kPLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

On a zoned filesystem, the zones used for the log structured superblock
are not usable for the allocator, so don't account them as available
data space.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c |  6 +++++-
 fs/btrfs/zoned.c | 22 ++++++++++++++++++++++
 fs/btrfs/zoned.h |  6 ++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index cbc1662abbff..98e103d4d7bc 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1682,6 +1682,9 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 
 		avail_space = device->total_bytes - device->bytes_used;
 
+		if (btrfs_is_zoned(fs_info))
+			avail_space = btrfs_zoned_dev_avail_bytes(device, avail_space);
+
 		/* align with stripe_len */
 		avail_space = rounddown(avail_space, BTRFS_STRIPE_LEN);
 
@@ -1692,7 +1695,8 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 		if (avail_space <= BTRFS_DEVICE_RANGE_RESERVED + min_stripe_size)
 			continue;
 
-		avail_space -= BTRFS_DEVICE_RANGE_RESERVED;
+		if (!btrfs_is_zoned(fs_info))
+			avail_space -= BTRFS_DEVICE_RANGE_RESERVED;
 
 		devices_info[i].dev = device;
 		devices_info[i].max_avail = avail_space;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 37f98894899b..d0140893d4da 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -972,6 +972,28 @@ static inline bool is_sb_log_zone(struct btrfs_zoned_device_info *zinfo,
 	return true;
 }
 
+u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail)
+{
+	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	const u64 total = btrfs_device_get_total_bytes(device);
+	u64 sb_bytes = 0;
+
+	for (int i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		const u32 sb_zone = sb_zone_number(zinfo->zone_size_shift, i);
+
+		for (int j = 0; j < BTRFS_NR_SB_LOG_ZONES; j++) {
+			if (zone_start_physical(sb_zone + j, zinfo) < total)
+				sb_bytes += zinfo->zone_size;
+		}
+	}
+
+	if (avail <= sb_bytes)
+		return 0;
+
+	avail -= sb_bytes;
+	return round_down(avail, zinfo->zone_size);
+}
+
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror)
 {
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index c17177a52c60..1959abf448a3 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -76,6 +76,7 @@ int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
 int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 			  u64 *bytenr_ret);
 int btrfs_advance_sb_log(struct btrfs_device *device, int mirror);
+u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail);
 int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror);
 u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 				 u64 hole_end, u64 num_bytes,
@@ -182,6 +183,11 @@ static inline int btrfs_advance_sb_log(struct btrfs_device *device, int mirror)
 	return 0;
 }
 
+static inline u64 btrfs_zoned_dev_avail_bytes(struct btrfs_device *device, u64 avail)
+{
+	return avail;
+}
+
 static inline int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 {
 	return 0;
-- 
2.55.0

