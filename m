Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031273;
	b=kld4Vrh/uO03SU6mZR7LfjeiqBYJ+j4gM5/abtYwgkgjYHo3CgpmXQbzQVpxaiApeQhV
	 i8XzvvRAdAdFLrMdZNO4HuMcd/V7OofBSRpWiOjsmJNomA11pANx9n7ml0opucZOnGzTa
	 EjYEtHHu4+i9MwY1qsaifWjMO3ZMJFKQSDwdkLbnmrtrDuKtsFJ1sIVfSgC41iVQkwvoS
	 jOkdrYVu7tOo762DjscE4wH9enJZ+zh1S5dPvA2y1kRnTcGxj+30exKEsV/ZH7SM/Ftow
	 +Zl4bvCXjCezWXDlIWVT2rXoiWBSgLO9OcFzYLWnxEPq/60nCiyqCUJYQKVlUL3OGyg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031273;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
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
	bh=oD676VdQvaG2SNygONwqf/JnkLTW2nXK9xgZuxLkaYk=;
	b=HnHXPudnfzxvqhYNSsMu3L4KAtdhU0RD1KSPTEHadxIwBugRWYq4brbviCDfZ96L855N
	 lGJrA7tVNGKvhzs5ifFkSwBhaSllb9oTf5hydqtLJIrbQ9MvePCSNYdBzWkMvhqBc9zJb
	 u8N9DWarCri13S3oFUbKQ9sSfQU+wCNIZqrcaIxEL/8BRLBlU6B0GdmKKfxb04mD+2OXQ
	 v/liNYTx+axtv7zI8inbsVGGmrHLaNW/aWTZ6wvka9r7ORc3Tb+rCww6rHRjgAQJj1WNr
	 vUtmGjNP2FvYtYnhxa3ZZmn22toggWo0STfgqUBV8zRRH+3kj2riYN3SDIl71Dh7HAg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=X18a2kPq;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=OpZ+Cu0N;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2868606A31D
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:14:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2868606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=X18a2kPq;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=OpZ+Cu0N
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031279; x=1824567279;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=n7Z3S3UVq77GFxPux0/6hqx9Zoiz0xtpnnqUlX9oMUo=;
  b=X18a2kPqzy3G7dtHyMp7vMrUH0u/PnkdnRKHV06jDUcXQZV5OGCRbkQ7
   ErGBzkTskDYXIDV824LoYypvGeYKWYJScEQs5jW7qL6b0Un1GLujh/2TW
   N6zdUZqfaGMjXyCdx6p4dNlbR8WPyO4VkCsUdULiMCXTC7bfVGaxV/RBg
   VXKyBqXyfhehY2eRsFPxD2Rgmi5MxA6zaDuNz9Cq4c334O/G2WvzFxQ/1
   AVk8Wj6HozjPOrRWQAMfQlk1KwJ92ecpqXUsaWrE+0SKvT66Vf/DAMtjE
   bTIii7IXAI4G6EHr/MhMEvlQvA6Bs6ZT2UgQRUlMlj8Y9rvVQ83p1wiOy
   w==;
X-CSE-ConnectionGUID: 8iNaTfeETQ6abcNKqMdsXw==
X-CSE-MsgGUID: r+dJ1N2NQL2WZazqg9Ea/A==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="154804704"
Received: from mail-southcentralusazon11013054.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:14:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GNSeonOoz+7Jts9n94KYh4Y9V++/dXnfrIbTyUfXLkgGLwX1/l/va8bXkAb8nYpFrjP1y7gTypMt/EazhMRbPcr7MgVynQoU38B6jG9mqoIr4LGWgpwS3+lU4IGZYNbeqaSVZV22zBDQYtofMS3YmKdbqEelmhlYqLSiSMWUem9qEiaEx8fKHFNMIqBRHjDmaCzE5xc8Vhn0jlyZRQ962sFwIA4HZcljVwggr5Kt3EZFMaTZXVRCBOFkAUE2QWAEqrMcC4FS1PMfwAg0PcVIW9O4+kXg3XbDiLvtlBmMnjk+rT592IB6ftp6SGGbvp/JsUjAJQgSnU5BoLrDuesYEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oD676VdQvaG2SNygONwqf/JnkLTW2nXK9xgZuxLkaYk=;
 b=VYtnhJa4tl3mgtBMYXwx8ISOK1J2GczEIpsdmfYbpvn07p9ecKGRFmcTHprwAWNnPaOqbnvCHKZdGyRbZtqAL+/kuA/fjLIcX0M1zIJT2aPx3z8SoZqxbFPhuvP9vRb5QdBhtwmdGf7wLJ/NC1T72moSZo0Tydu12oKueikkWVbZgLC6bcyoXbymVv6m+GDpnEBjS0SEptIECwHBdvOskec/OE+IGed8DEmzzlvMg0TiFRcAVpzoMukH1DcZwdPXONNm1klqJcrKGXU3EO87Cyo5AXJzGwcp6IOGZ2TMzVb9H7vQOlZ38qZCk0p1LwzOzk3EX5LTvPEyvtFh72ul+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oD676VdQvaG2SNygONwqf/JnkLTW2nXK9xgZuxLkaYk=;
 b=OpZ+Cu0NTC3vI+IcRCo3/DYWcCH6j3iL2nx6ADh8uXO/PAQk9tqxJ7OSwoEjEhkXjIA03wyciVwYh4bxp/BxhCWRkGjjPBk5dPp7auNklb85cs7ed7MxrcTrGYhmUxQY+N5g5PaK6hQKpvyzcl666HLLj/LYUGlD7cpwjWGdBcQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:40 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:39 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 08/25] btrfs: zoned: prefer conventional zones for metadata chunks
Date: Mon, 26 Oct 2026 17:08:56 +0100
Message-ID: <20261026160913.207909-9-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
References: <20261026160913.207909-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::18) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|LV3PR04MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: a3b70f7b-0b47-463f-cb47-08df337b89d5
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	7/sg/6n0PRbHdBCVDZ9yLaQuHWDNTa1GyBwtIW96yvNWCbeZXZh9W/3iD0x7BVV6gRBxvaYrqih33Zjy2c8e9IkbvxHwrVDVu91bzN0V4CK+h+9wEQ6iGaPPw3CC8srn1J4dlkzxyfA40oY/8W/cI/zncyA16RVOsCSlIR/rS7/myynHA3ylOJg67CMdIATcY8+HSeXK/GNDICsnpuBBIecxLqBA5uQLyyN6xocdbMUe0WliCZ7dyLm7GxjvGnhDmzt1Ut99oWjqquy3FFQOuD+yPZ4Xoq5l8HVVtHecPqNwCk6zExpeKf4gPjsdndRNCLnZ5zcqmeO6SVkL6RJeIT0mFtwpf941Wd1GElAoCHaJQ46w78xWpwtdGpSnn4xYkM89QXKg6n+Rx9oklIemLILakn7KpsXbbE8U0LBjYK6qJYIN69LXuqlBM7Y6fyIt4PceiaZIMi11ziacUtXqa57wruSGL9gGSsoyyVXk68XE4F/Li6g/h6RnN3f3yzcbmYM0asS8ASqfFgWZtRT010VKRzJsE2IpEYUYsCm/jUdrJ8NX+/qWsg9IIL7hAOO9MlNQyy1BUBxaz3RF86sNJM3euST/HMYewe4N9u2qK9nNIR4J8xvCR3bCIMVE7ovseCw30RE3kGzlgAAv+JcR+nCsPCCe+iDyexP68Xr+V0w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iLy0OQIK3lUfJjisTkCZm5f9l9If0yGsUb4LlO0v19KpxmTrbOHofWpf22d7?=
 =?us-ascii?Q?6/Iue5m5FRf0ufumqzo+t0hC0n9CBfpUi+xPvswS0Pn8FXNChK3atZw7i7/h?=
 =?us-ascii?Q?+MZ+HSvww/dj/q+PhuH1Zy5RaKvxrtA/rdwnDoqi3a1DqmiqCW6HjovHjkRO?=
 =?us-ascii?Q?lzMqVGOM/iIsWWCgoOU79x3UNXvFpLABXoyPiNRNA/zlj5kwX3iOQSqEgaAf?=
 =?us-ascii?Q?yhINVBfGQW4fCChKOCUfRgfw/kGuAXd3PMnSX5x9DP0uB2gNsbDqg4rERyBb?=
 =?us-ascii?Q?ypHkGUcBN6odYkbiihWD/xcunc72xZ2X01nVnzymKXxk4Luq2Lrx9vg7Z+3U?=
 =?us-ascii?Q?/cOGFohrfA5fxhRbV6il7IDVChmW24RPnvFc5XTwLHF75XQLTvpZJ2yPkqwA?=
 =?us-ascii?Q?BqPU3jneCqyXRUaiNQxVig2ic0hB/6b0jHflW6lvdqXWfJkP0SVWIzfB5bmd?=
 =?us-ascii?Q?Zfpa51yBQ8MViwuRajjNDyyaxGaTrMuGRyVTj5+q/Vk+o9jkw5VGmiIvfGjs?=
 =?us-ascii?Q?QwQ8IBP4rf/wZUV3lck6BJbtq6f+7vn/OdYiqbuEIvbZx8XIg9RA1mm799Xf?=
 =?us-ascii?Q?KGgPBaWXVA7AxdwIDpKKHJXxkUtaLdHAdEONtghdu0y+79eqGZA+amvoHzsg?=
 =?us-ascii?Q?9ike9dF3z2JPoRT9HUiXRSsP973gLenODewuYziD09ykpZy8D6Y/91hrTR89?=
 =?us-ascii?Q?7PV7uIypwfB03f7TRVvQVpFNtPbnDCCwK/V5045jwO3l4GY5dHMeSSCH9/aM?=
 =?us-ascii?Q?P9iCl7I5Ps5G+Ryw3fp2PDbNAuLyQNLtYXwDw+JHBMTpiqdjgEvfCyoCx2ym?=
 =?us-ascii?Q?7LNPe/5ViLmXgtc75izsk9uPpK+O8FKTJ7PMxn77QHkpjHIdUtuw0wvA/BgD?=
 =?us-ascii?Q?H8ETUoCk96KC7RpIZAvvWjFJLY2T6vZw6L0Dbgv7/39Ai5n///thDEGdg++N?=
 =?us-ascii?Q?wHC8kkK1r9a86euWpfI/vdjCsgDKclEPIH2Me7H99vV+nAnCn3dFEw5tNzrs?=
 =?us-ascii?Q?Uck4Tm2f3omeBpIbdd0IVs1QcsQ11RT5Dj8bAXnN7qmDz9puT1Ke4fx1vA9w?=
 =?us-ascii?Q?bf/fKfGO0fmlfVmrHUVb0mIAwfP6o0QIsAMnIvzsO/gnOKlCulMfcPFBuYuG?=
 =?us-ascii?Q?hM63A8qmjYO7A0y94LHui2ez9dA7+FZovy0I3GhWBs9mVDf6sRzdoW76pJGG?=
 =?us-ascii?Q?Z8qmfLFbRs0Nuadhq5OVAGGB95UIJnMCAyYY93O3gchzrH16qWZeEsa80a4/?=
 =?us-ascii?Q?bTmtLBDfG1dwayGXYc4RcNSgKGZYgl3xzIpHcqfpI0FWhlRldWqwxvVUQXzm?=
 =?us-ascii?Q?9vdnwzvpZAFUjkVZUbX+V8Lq7sQ8xxZcEG6KbQOVsD7AlpTei7k9fseViyrR?=
 =?us-ascii?Q?QXVv+hpAPEia2geUCLFdiQYfmK0/lEocnSl8Z+4x0+Zaz43wjvZ4qdFxIv1f?=
 =?us-ascii?Q?4YdUelXCffxS2lDZ5NBrQkEYzGjpN1VavYsrDN26EbY9lZ9l/NRl4ZGeOOan?=
 =?us-ascii?Q?WHMhF2OrNBpSNTTTJf2MAlzxaXEX6RmQ3rXb5mknSZt0uDPVqLjnbOGoiZ3G?=
 =?us-ascii?Q?QJEfMGuGecsojRzkeg3dfNtt8tpPKZL4jdSDWULslvVEGWw9jXt4jmHapNgw?=
 =?us-ascii?Q?W6z+f48dlu4hkxkRKnFOn226nbp9Y1BFEeKgo/4wOAiO3oQpHn1I2SqTjCbd?=
 =?us-ascii?Q?aZdBItp9BMPRTjbfcu+TPbBsJNNGxTOfW2KjvUAm0c0tzcy/kBiPENp3VKfH?=
 =?us-ascii?Q?lepBWLnIdElFAMu4xvynWvyBSSmubnfH0ghzj4QjUypOEG8EEkO4Ejpzk2Uj?=
X-MS-Exchange-AntiSpam-MessageData-1: lJmWwmIM8XR3yw==
X-Exchange-RoutingPolicyChecked:
	VEDhaSLq+gauU+7jmPHYFtT0Lgx4weHZesqeMfT6azp21aWiVt2b5APHUSKWSmSopmjkCVQxTk63ufEVbqge/KYkWLwV1NCzEDbE9dZrYLiVSHVx/qOX/UzADY0RU5RALJmvWecnKleGbfMo381q23uMGgnvLhr60leohW126SrKTv9nGuzw04klIgIQ6NSCaql/buh0w+xwli64sJzuAoHLBoaIV+CeMc2BBeKIffXILPzPYzggm60cfrQ5JLcgnEsUbPLyGxBJhjYspriBbJJlDAj+k9CmDVGFjg2smOWR/b+pkhaxJPSQM3lQgWuOdgVO3aUG18ffR2Sjxf80Tg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ptFl4xfD7swazLAE+NgfDtYjvE10CwZazA4R7eGf9stQ5ld8cUEiPgWoxgRSS5elPNhOtJtU1fSZxzsJkOseq3wEa8PwHNLWYP83Gk5gDkQXkloptE9P89C8XmKNg/PAFbm4/QFWfG+tjypn64sts0IbbhGCJTKw2GzfAenWVOUo/W6+ECOSZCIay5BCPU1w8isqxB2gMrfFeScxgsPAw2fWVmbmt1tnj3KQbOVgxdvm1vA/rh5Y+z2nyaQKD7pa5fiyK1lkuc1KqtLiYljJ7owYlUl5zbHV2fHrWXD2SIyTsyZakkBrho+aZ72dVt4gVDf82U2Knnz638uWEdtgIh06DBvNn0wcmfZ/Dkt+LJvnf9QgcwMdDQ5MMDgMFtxG9slq1JBTMcEpq6xSV7Jp4yTKiP9o0wvqted1sbnmoklNr3elqGGsJNhcqBGHWYP7CJrKu+GAc9qnXq9WqIhDpEJ7VrUMRVW4WLr8SMlcUzi0/HHD5Z9LKatk0q2tvt7k+to+eKvpAxzQgNWc7IEraCQxm2MHKWTu7d7IpP2m2hSvpksOfUfl8aZ7Fpme9ZLtYXZuCoTz+fI6tc+oCZT2Hw/xWgHovNMGA9YUrH9GWu6BOHX3bTyzTDP7ZyNcUw5Y
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3b70f7b-0b47-463f-cb47-08df337b89d5
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:39.8123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJnNhK5DqOkY8oYsq5gTbGgtaRbWHPUdz6iFQ+fZpS6gO5kaqzwkV0O90j8kwqiMP4Dcji5TZSwwfpdh5bQWiCin4Goci3S1b/kPjeHqVWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

On a zoned filesystem metadata and system chunks are allocated from
both conventional and sequential zones. Metadata landing on a
sequential zone has to be written append only, in strict order and with
a queue depth of one, and freed tree blocks cannot be reused until the
whole block group is reclaimed.

Try to place metadata and system chunks on conventional zones instead.
The device extent search is first run with the conventional-only
restriction. If that does not yield enough devices for the requested
allocation profile, the search is repeated over all zones, keeping the
previous behaviour as the fallback.

Skip the restricted pass if none of the allocatable devices has any
conventional zones, e.g. on ZNS SSDs, so the device extent search is not
done twice for every metadata chunk.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 41 +++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/zoned.h   | 20 ++++++++++++++++++++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1fa4ee803251..76bd54af8720 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5897,6 +5897,29 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
 	}
 }
 
+static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *fs_devices,
+						const struct alloc_chunk_ctl *ctl)
+{
+	enum btrfs_zone_filter filter;
+	struct btrfs_device *device;
+
+	if (fs_devices->chunk_alloc_policy != BTRFS_CHUNK_ALLOC_ZONED)
+		return BTRFS_ZONE_FILTER_NONE;
+
+	if (ctl->type & BTRFS_BLOCK_GROUP_DATA)
+		return BTRFS_ZONE_FILTER_NONE;
+
+	filter = BTRFS_ZONE_FILTER_CONV;
+
+	/* Avoid a pointless first pass if no device has such zones at all. */
+	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
+		if (btrfs_dev_has_zone_type(device, filter))
+			return filter;
+	}
+
+	return BTRFS_ZONE_FILTER_NONE;
+}
+
 static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			      struct alloc_chunk_ctl *ctl,
 			      struct btrfs_device_info *devices_info)
@@ -5905,11 +5928,14 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 	struct btrfs_device *device;
 	u64 total_avail;
 	u64 dev_extent_want = ctl->dev_extent_max * ctl->dev_stripes;
+	enum btrfs_zone_filter filter = chunk_zone_filter(fs_devices, ctl);
 	int ret;
-	int ndevs = 0;
+	int ndevs;
 	u64 max_avail;
 	u64 dev_offset;
 
+again:
+	ndevs = 0;
 	/*
 	 * in the first pass through the devices list, we gather information
 	 * about the available holes on each device.
@@ -5936,7 +5962,7 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		ret = find_free_dev_extent(device, dev_extent_want, &dev_offset,
-					   &max_avail, BTRFS_ZONE_FILTER_NONE);
+					   &max_avail, filter);
 		if (ret && ret != -ENOSPC)
 			return ret;
 
@@ -5963,6 +5989,17 @@ static int gather_device_info(struct btrfs_fs_devices *fs_devices,
 		devices_info[ndevs].dev = device;
 		++ndevs;
 	}
+
+	/*
+	 * Not enough free zones of the preferred type to satisfy the allocation
+	 * profile, fall back to searching all zones.
+	 */
+	if (filter != BTRFS_ZONE_FILTER_NONE &&
+	    rounddown(ndevs, ctl->devs_increment) < ctl->devs_min) {
+		filter = BTRFS_ZONE_FILTER_NONE;
+		goto again;
+	}
+
 	ctl->ndevs = ndevs;
 
 	/*
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 5f21a360f23f..e99786b29587 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -332,6 +332,26 @@ static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
 	return test_bit(pos >> zone_info->zone_size_shift, zone_info->seq_zones);
 }
 
+static inline bool btrfs_dev_has_zone_type(const struct btrfs_device *device,
+					   enum btrfs_zone_filter filter)
+{
+	const struct btrfs_zoned_device_info *zone_info = device->zone_info;
+
+	if (!zone_info)
+		return false;
+
+	switch (filter) {
+	case BTRFS_ZONE_FILTER_CONV:
+		return !bitmap_full(zone_info->seq_zones, zone_info->nr_zones);
+	case BTRFS_ZONE_FILTER_SEQ:
+		return !bitmap_empty(zone_info->seq_zones, zone_info->nr_zones);
+	case BTRFS_ZONE_FILTER_NONE:
+		return true;
+	}
+
+	return true;
+}
+
 static inline bool btrfs_dev_is_empty_zone(struct btrfs_device *device, u64 pos)
 {
 	struct btrfs_zoned_device_info *zone_info = device->zone_info;
-- 
2.56.0

