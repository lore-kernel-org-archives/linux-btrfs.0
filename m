Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C663442B39
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045075; cv=fail; b=ffjWCHuGDCQa9m6gNw/NuW5OAi6QIJRFctwUIdf06a6oGnV3tneccD9DkPfTZQGYXPjFp5KKvgpt8WHz/tCDGPedalNAR+UEgEAWa8pdFcZVniAlUB05PFusEBQYJVbKFSE+ddJeUo6Adj0qh1QCLb9Hf6IBERefFUGRWlqFstI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045075; c=relaxed/simple;
	bh=Kp5eFudHo7+Z9YjAnBDA7dIOdwLOw5y1DYhvRxPt4uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IZCdYA1eqP+GewJOgvtSOkkhmZJnUYDUrZoe0GPq6SbZS0LDFQjuHSetJhg33Gut3z8rT5jVE+iqDqLcWu+V/2TZXJuopGGZv4MT6rlUDzkYLFAagvlYqUPVAzcQ7qQAASM1NrRVMxJYlbZiiH7QX2/k7xtZuSQnpWs9v3rMqnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NPJhmkZg; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=PreWBhH6; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NPJhmkZg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="PreWBhH6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787045073; x=1818581073;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Kp5eFudHo7+Z9YjAnBDA7dIOdwLOw5y1DYhvRxPt4uY=;
  b=NPJhmkZgpJnhUbbLUeXB1eJWiJR4GnVQLZk4k+Kpn04mRn+yPT1vL/Is
   IaIOEM0mlwTgjyFf17dznAaMsWexdw8HGXOq92cwhgmrdjMJ6JewBFcCr
   dbuIFwP/f4X5tTKxfaT6Y+WA8ui8tClkp1vnGViXXBrW7UtbE2dVJWAQr
   fwNdsRGSNCi/rFKCtVH4UrbqUlduyatQu9l5HGB1gIVY+mmXizroGO3mE
   pfToIKIpEXswUe++FQoXEPW2YofF9wj9LhfxMnD3jwgPx5hJ4MXcjawD+
   hD3z0yMRaNTZYLaQt6kyH8h5dUGI4GlCoLaDKtRkCxuTWYMaG3NVmk+oB
   g==;
X-CSE-ConnectionGUID: ZPNB2I68S9mSiHR4mdkCJA==
X-CSE-MsgGUID: z7GVgTMZRSeaM5TgZwU0zg==
X-IronPort-AV: E=Sophos;i="6.25,230,1779120000"; 
   d="scan'208";a="151931444"
Received: from mail-eastus2azon11010051.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Aug 2026 17:24:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nHQQ1I+ivs6dT5Cbw1Nl6GXrY4EOqcsguixTLvPRIIYv0X9I92yA7ViGZZ/dVVqZcYRH/P5darVlLjx2ZqAG4yakY7vXy8ijHke6wEbxhtBi9UhXxV0ekiAGoPRdim2YKABwAStkWgWsOOWNma7Q77p+o7aBcfT8te9E5KRHY/28bXgZhS9IT520qwYwL+6g6OT0Y14SJ+j2pHKdQ7WvZMjMavCBboGE/1vWW1wmGiVHUgMgAeFvaLCTS86qNOzKiDwXd4vkLzWnkEv7HkP19YKN7Pyo4CyQmR0bj82q0XGliXweJsheSO7VeDKRKE3GkwKcJPnSejjGPnNMziEerQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ORFDoL7bPUsodzwzPd9D7PvvS+D+AeY/IZgDFwRnSU=;
 b=IspDYCzuB6Usj57cLLCaZ5gyQKCwBxbgrau3LOq9KxZNMEoMY/yqOK6sDgUIZWg1jR5PIoLa2BcTHygCTyCPMiCFL8aepnbXjdY71i+ubBiUtVibsDvLnP4nnBqO1U3l11U8lzfADi7FNZoQ7Kk9LHy8O92XWCp7DxVcbJtcbXlTj4spGMrS/5SV2YERL4BlIPE7i9es64Ej9nlZtlaWGaF0TNlLBozSAeaJKTDdoA+H87Wfuory6sjozr/1/fnzTleV32wLf9+3TSm7C1oucRaEkGf6U7EAcIz8qWURnNDk8ijDu4uKUbSSv4URs2vDeOc/9o3txn/vVSu95I9XAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ORFDoL7bPUsodzwzPd9D7PvvS+D+AeY/IZgDFwRnSU=;
 b=PreWBhH6LFytH4lX3vl/Kmk6mK0E58J9gXK3d+rQPJVVf7DAyoc4CoR6tGJuhOr81rgqDFN/bxXhpzkhqSKAw3EPi4QWmWmNuxxEArSwhulfczHnU3PdIsXPl02pkMw03LREabG3fsRbkxU2x/d1Fsuyqn+ho/343eeJWl689es=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH5PR04MB9623.namprd04.prod.outlook.com (2603:10b6:610:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 09:24:24 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 09:24:24 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/2] btrfs-progs: zoned: refresh stale cached zone state in btrfs_reset_dev_zone()
Date: Tue, 18 Aug 2026 11:23:51 +0200
Message-ID: <20260818092352.1364853-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260818092352.1364853-1-johannes.thumshirn@wdc.com>
References: <20260818092352.1364853-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b9::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH5PR04MB9623:EE_
X-MS-Office365-Filtering-Correlation-Id: ff6dbc2d-b0a6-4577-108e-08defd0a7e0a
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|19092799006|376014|10067099003|56012099006|11063799006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 MOxFI7RYEvc4pvVOQZb8cNz5Mwz+YjASu5SG59s3za2Gqn/Qzr6btO184oLCLfNAeGAEB0KirdFhT68A4PreLLQoTpZqE+x5SuDZNVlsnSSAHlgelvy+DYALPeGPeW/GmI9lZMY3gZVVn1obawxsX0fSGwlCxI7MQMAC5VtoSHZ8cbwgtRaTJr0tMk/BP5WyAR5SQUAXzkZAjbc6cF9iezZNUyxvyj8X2gdI0BRvYcrmE3pyXqO7fJHIqs61UbZrsKJRTQWvuXbtMi+AafrBj0ymBu/0E4u3DTOJjX2wjDtKTDiybMLInSlw9lzJE2rPBEg1VOaeXmThJdB8XWRDBRb3kC71Jo9VQTgeZLNjpVERId6lhv/Dl+xFNROlFfX2a9EfogpA7VaEKlhkTZGmhBu/JazxNjXVFwplHsTatIstQN9B834OiG5LTMAKqnwj0wDE+v2kh/rlAP4SBcqLmo7W58DJ69ai70jM+4PoAUyy03UGvh6f/O3iEwnwnAuJ7K/5R/fHAsIXjg0Rn2Ig4lqOGj4fH1q8mWk7XwJBSBT7rTSk4z1l360VP4AmdvLy0VA3k9kjLrLxRUc3f7VaOxNTzUuT6t5RCt5tW5fc1aQq/mxzKQritK7oQlhBPGaYMCaiacJ0+3sqlRKpDtNJuKYDTzehNR53/vGJ1BaVuEs=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(19092799006)(376014)(10067099003)(56012099006)(11063799006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?zml5U8yW0z3MoWikc58a9MLarrT3wnpZA8aAlnnVLwaximq3nXHCL0vdcZVT?=
 =?us-ascii?Q?Aq7n0ei5tAlCWwcsLbaj/cCQLcy1dQVWp90rdqJYZ6yfYZ3we4e/23pvldAS?=
 =?us-ascii?Q?Bn1ZaQ0nBgObIzCRBs2iWe0BvhPsFLdT8DJqM3uc+4CHORcSq4KkHQ3ADbCs?=
 =?us-ascii?Q?kMqjOTsQcaA7YLXD4mtBIIJICO1yi5GtVa9aTTxxUCbeqhYaq86Y0ksavUyo?=
 =?us-ascii?Q?xCmgqPFyo6NLa1ZPj9oGWKNlmzg01YRkbz46zWMPeFfBaHcDxzAsWKXk2+OZ?=
 =?us-ascii?Q?rq0K+rU6mb7CIdqRYUAxhNqy1zgNkZbLiMPFre55LYKdneVJ12Jw1KCDRi6F?=
 =?us-ascii?Q?KX5Ou9/0ACDasZzpPvOj/YYHYErqHTKEfsK/bRkT8SKrJ/IxRKQ7hyQFx8EA?=
 =?us-ascii?Q?6yjqxi3VP53o88ig9s3YglcsYcrF0mYC56CU4rFf3DTDGdGgne6HShr5bY96?=
 =?us-ascii?Q?PKm7hcwO/7K7a7taDZMibAk+EeLpOW23PqTWsOH8G2jOJuCLNSyrg1c5Zr2p?=
 =?us-ascii?Q?iJ6Us4PLdilM2A7rbrsU+scrfFVCk/U5mDPbj/O4VzcVbP4DntYmLn+dNtL8?=
 =?us-ascii?Q?mpyH+e88KeiSfkFsgFyv5m5gHcZx9g1EV0sCgosXOV1IIJh5L8jBCTqvvlsk?=
 =?us-ascii?Q?zvzZ4ITnZyqwjTN4XV7mXH+DEOioCSWX0Bhw/ZqCDRXsWldRoavDzjtxcKWp?=
 =?us-ascii?Q?3+A+c41CKTWVUiBWu+Il4riAGKb9/IrGpG4Nyspec43SOnyROqBaxLxsZZvz?=
 =?us-ascii?Q?2fA44P6KXCx1FYWv4+g3ljFaGMbT+R9W1O4orr0nV4F8ewHPq+VRi1/eu1VR?=
 =?us-ascii?Q?EaLsuif6Yo8aLCFBcB24PnDMK4FJ0XFAWjE9QRTwBRf0V67eXZg4QhAPr561?=
 =?us-ascii?Q?YTJUizWxgMwK0VI2b6rYLHpyWaR10uYTkfkABS39Zm6d+I+2mWt/e4kq6ZsT?=
 =?us-ascii?Q?PaBufiwrVjBrA9SCqQWqJvIG5Fl8/7Ez5OPtH2BLKi3xSMQ6FSvZu8Dqi8JS?=
 =?us-ascii?Q?0fu7DH6DldFizh80vKgyxrEMMc7xLhnT5yQyumAypndrFmeuAxMRSj4XzXjo?=
 =?us-ascii?Q?J96rmDVshUUKWxWzy+XGzRGvvFmVjDK//BMMrPxjoAUbZQtw5dj9u49yD750?=
 =?us-ascii?Q?lC5meLUuGzseN1yM85JatbqplvieGkixy+4FhNStAXL/mXcPNv1HTjxI8PiM?=
 =?us-ascii?Q?H3g+JYz+UZfwGtV60U8J6stRa5peDsYO/j0qER8Bvy5sRH0hk/7s+X9JlYoA?=
 =?us-ascii?Q?m9KzUcwZgr0Ab215hMB4fjmfAQOXIzGRv55qrWeKLC2jqPpyyF+TlIkRQk7h?=
 =?us-ascii?Q?s1pcq2iezE7i15SOUtTWJYKPIAx6pfnvsGgkBvoGhs4HVGtJLwam6ps3kMOk?=
 =?us-ascii?Q?Rsj/o7WhzFBHBrb9qp6BYlDEJl9yIVLaGzJ6ou4D7m0OiYWjE9xaxNKhQxEB?=
 =?us-ascii?Q?VoWVBnywTpQ2h0d4ZP2W6hCMlqJOiBzurNW6p4/lLcFMn2xQd90/UBRiaFX8?=
 =?us-ascii?Q?lQeKomFr1KMlpxHtdYx0ipBLQuI4ADUmCozvHJG51IDuY6lvGIpwADAYDFjM?=
 =?us-ascii?Q?aNvD5/HwXesOWr/do2DJs19isVMCD4JPRWPks8KZjQpWd3xi/9zD49uGqk/c?=
 =?us-ascii?Q?W9j7yE0gQ+15bDXMi8j5JBkErft4jq6wM8bev+uRH097DvQJOWJlRyBRJNtp?=
 =?us-ascii?Q?1KdADg5oazpuB/R/a1ALGgcL27CcLLjC2YVunEmcRd2jYXCr4hGkXxUybj+R?=
 =?us-ascii?Q?jcnA9ZwTYf/dOCxBvJQc3nX58NPyEu80PH2Vm7y29aE7dAe4SU3la58G4piw?=
X-MS-Exchange-AntiSpam-MessageData-1: /65M0Nis3MBphh6WHDrZ0A0fmhG6/ezg0As=
X-Exchange-RoutingPolicyChecked:
	XZ5HT5RLswI8krST/zeCzenxBwjrOxswW/+GErJXBrKbcfDvKJ/zAZvbQxAZ3s3buss1nSignoC45TdzWlEtv0bm/mDVIrM2wa8qFN+pQx7haWIliInQq+BP6cAaHr6/hJWv6TOa/FLmjQix20mMDckKbQAgZEW6vpYZ5y+leymJp/dZRey4IWioVHYjSP0TvlaqBkKtTOBhFELfFF0wWZdu5zm7ha0LqklNzMq8/LbkQmVndVb90TRcACLIsa/jMdWWRxuEsBRGwN7MlUwWOeU443Ok7Dh+25ToqKtEQJRsIa4ozVn0YJK+UGKHNbflUHSSuSBDbUpEoYFU66G/Xw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3X0zk95pfXPw36kqkWXYOw5WyTUKsinB+/2UorhyCpTA1msCA2qmQsCUnP2wJVqRRn5sYmtlilpJjOx416/Sb8jdxXJq5UINsqv2JdvM6NzG9kp/98ZaYcjPE/ldj0GYwVz7L9YKcL4dkbVSjGitirjBI24d200SFlm+XgbulJhxRwB44brIX27E+hALeNi03phhVmK/ilREHKBDWk7hc1KMP9sZ5+uXosSPFaoAxOE3gM5KNZvUIYBprz12l/QLFg9CyV6P/D4h9j+YXXsR3DmTZhgtAjYbhdKFUbCAusFV8ug7eRds2utbcyWrLfvd36Y3A5BTPLjDBuraEsnp7ITWmrhntfVqqVoOAJ8hqfjq88SXbR71w/+CoNidky3d3jP62EeodA6qGXbw+KxpMLJRFOK+0Erad3xT6D1wwQ369dIiTdU6OQr4gTTVcFo1fvKwAui3VnB6Fe7KjK6cJ8YMUZbccjzSRzHDxj464K8a1XLrdnyfHdJGnuw0CQP+ryzU6IftY9GIgS6RNgWklLOBthufYgKrj3JowZUOlHGbqfBnwvo+ezF1AusWiGnr+Xhm+0XgAUftmouN+SUXOwEjFzXr1hoNqVSKl07yz1hFKXnPRIekkV35AR4uoc7v
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff6dbc2d-b0a6-4577-108e-08defd0a7e0a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 09:24:24.0136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zU18q9Ico7jTkcyLQ2WjmFM4mbfy7Xi0AzgFeDV8PwNmE87GOjbojpzgHkH58gsfPIu4JoEmEcqdZ+RmX0DiW5/unrMyP6thm6gTfF0HU9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH5PR04MB9623

btrfs-progs reads the device zone layout once, in btrfs_get_zone_info() ->
report_zones() when the device is opened, and caches it in 'zinfo->zones[]'
without ever refreshing it afterwards. btrfs_reset_dev_zone() skips
resetting a zone whose cached condition is EMPTY, but that condition can be
stale: a zone written after open, for example a temporary chunk that mkfs
writes and then removes, can still be cached as EMPTY. Its reset is then
skipped and the zone is left open on the device, referenced by no chunk nor
dev extent, permanently consuming one of the device's limited active zones.
On a device with few active zones this results in premature ENOSPC or an
allocation hang.

Before skipping the reset of a supposedly empty zone, re-read its real
condition from the device and only skip if it is really empty.

Fixes: bfdb3ae23713 ("btrfs-progs: zoned: reset zone of freed block group")
Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 kernel-shared/zoned.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel-shared/zoned.c b/kernel-shared/zoned.c
index 3a4c0e9c..c891a983 100644
--- a/kernel-shared/zoned.c
+++ b/kernel-shared/zoned.c
@@ -276,11 +276,23 @@ int btrfs_reset_dev_zone(int fd, struct blk_zone *zone)
 {
 	struct blk_zone_range range;
 
-	/* Nothing to do if it is already empty */
-	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL ||
-	    zone->cond == BLK_ZONE_COND_EMPTY)
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
 		return 0;
 
+	if (zone->cond == BLK_ZONE_COND_EMPTY) {
+		char buf[sizeof(struct blk_zone_report) +
+			 sizeof(struct blk_zone)] = { 0 };
+		struct blk_zone_report *rep = (struct blk_zone_report *)buf;
+
+		rep->sector = zone->start;
+		rep->nr_zones = 1;
+		if (ioctl(fd, BLKREPORTZONE, rep) == 0 && rep->nr_zones == 1)
+			*zone = *(struct blk_zone *)(rep + 1);
+
+		if (zone->cond == BLK_ZONE_COND_EMPTY)
+			return 0;
+	}
+
 	range.sector = zone->start;
 	range.nr_sectors = zone->len;
 
-- 
2.55.0

