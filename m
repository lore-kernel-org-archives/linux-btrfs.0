Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085796;
	b=AVGw8DYp2ie8PlfFX091KFVeNpnWdMPZSHro5SFyJctsvNUtH0Jmtuu1EFspuMEL/hww
	 tFmlu/tHgGWdCXMOE6q94i23RJSuxuEl4WUSUA/ozQL4pHwmsM8abYjUK1EUvRinc0SZo
	 0dVOaF4t1iGsVfMD3Y3xk1OYCXMOs1ZqMNbPYDxd1dDYOSNBJ80SuAA7d4FX8BCQvApY0
	 eS8w2dm60NbWxM6Yb4RA8nTM9952ySjF4LiDmNlFFTggeQkyxEwvsMQbJKXuekBqP38qQ
	 GZ0+6dNsD2SlmzXZJGQBmq07bJC+puNH44izmcdFBYSTLKGImdaP1wz7wogjfDBGqpQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085796;
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
	bh=/vEqJFhE0uqarUDTVezwOTCIVkJBQ+nOQfYna29KcEU=;
	b=os1B6sVBgLvG2FNEQgZXJdOqJTQwKjGVYuGG6qWDizDWLli6KgjiOemKaY399x5+J1Rx
	 jkBPEPcks/Xf9ZRT0bqDi/0uejXsFIHMW11QARqwsiXg6No0BU++zIlf+LcAv9+8fHD8I
	 YAI8UnfIQSuX6D38jFo3ackusr+EyF/SpmIjEr8W2GHMQqBbmT0TDKxnvP1lj68LgP0Cl
	 FG0vFKaXGtUdjA4T9w1GaLcqDIc1i4+YoykI7+6K+88vrPYnjRplKlUw8/q6g3Oxj/2XQ
	 w9YoUReUCDoFQmspFTMgJ0dFHCmCLOptIOAedfHp9gFhGXRoEkb+aSi+ZnJnCqMOObQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=N7g7378O;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="cA5jQm+/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DA2606A32E
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24DA2606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=N7g7378O;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=cA5jQm+/
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085796; x=1824621796;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=wbw7DS6pxoc3sA2jc2RCA/+zAMEhTIuxK5pcieUieaI=;
  b=N7g7378OSpz7gXmRqxdq/1z1Xt7mH5sWoV9Ti1nGlVjBrl2osxr3yIho
   g6K66YsPtqfNk8NhsyY0Ho3e5oHo83UL82pFY8u4q9NhtpbFxwmxXGRJz
   QkPwInXiMNYJF3U/J1jIzulwuHjhHwua9lckoxIF1XUpPh/I3K2mc3Tkg
   a5S7XrxSZI803bZ+6oQc8zSlIByyc2cVpkfTzYgwEaN/V6raZD1GfOsEO
   y6jONXEOXYOGpPN/porxqAvRBxp/+uTNXmL33JQVLdVkU9MV7P2lSwQ3l
   Wendk3ehbue01OSToFWG/SmsJtz0Rn1GBqQIrIjoUxHAAUKLFX0UmYSnO
   g==;
X-CSE-ConnectionGUID: aKDXWiW5RomrpNM1maDsTw==
X-CSE-MsgGUID: Yi9Kom6YTgebxDGKbHzsAg==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="158990009"
Received: from mail-southcentralusazon11011030.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.30])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FM1NjAlic50Pdi99SSiPB+EEP7w+5B4D5mpvLrOGKj/4yhtwggjdvmLVeUzA74phZTtshjmfgYa5240oMzxSz5UT5bpsVoFBUh8vDbxtJ+qdga1xZNla35jVLqhDVLD4iK39ALC6XEz0zYA4htVt45Ot6hmE4REN3iAwLZMUBuREM2XLEBHfTiGjYH38Xh+pYPX2n5Xmg62jyBHabT+tJXVKtF3nhfeyF3wp5TPbeipZywDgtXvFcoZSZSbCAnu0rFFhwiYXyU2nceNlqq5If+GxPYTS9eUo407TDy4L1eUe5rw+xvquVcJgpSxQZeu7tDBfpEQqDCInTVjFEkBwnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vEqJFhE0uqarUDTVezwOTCIVkJBQ+nOQfYna29KcEU=;
 b=LcuVpyFPaCLi9zMkp2baFr1/B2GJhnlMiuIosAG5DHKGj0y77b7wBIG+BkArfq2n5mEBbE8V8ZFOlPadD92ULRZGPRUN5xHxeHN2cX9F8NECUKMo2i2+LQKgjPQ2ocNJZTN5Li2WXdkcFl6+Hc6QivgtEM1KZ+jHpco/vn+k/+sCSygVerm2kGbNr/52wOaXwVPqz07rUKqejiibH/O9xZg9ro3fiBi+zPOeaKot6BiUmYmfDUmIgWGJpp7lKdnxMyjK0RAFanb8nl/cE+fhTNeCqhp026Tg8jyM1zf+2GtuxGM4Y2p3Vzkm+N616hHCPJPuBAmJDVYMyXowTmecKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vEqJFhE0uqarUDTVezwOTCIVkJBQ+nOQfYna29KcEU=;
 b=cA5jQm+/WF5DCZ7/YMBO2TKJkp9PHPErSjCSNtyo7sc4b+BF7e1C51NrY2f/hPraCZlrg6aJS4+tb7eQSRoOJ99+xBsrgmAqqaOkcOOLeI0nQmTFFmgW3Y8+m7fQ2UE4p7AEF1FGTRViHWJlwfUgZLOyyq2GlPtSle6Y6yqZqtA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB7064.namprd04.prod.outlook.com (2603:10b6:610:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:14 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:14 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 24/25] btrfs: zoned: don't count the relocation zone reserve as available in statfs
Date: Tue, 27 Oct 2026 08:22:30 +0100
Message-ID: <20261027072232.419318-25-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB7064:EE_
X-MS-Office365-Filtering-Correlation-Id: 21b5f260-0c7f-4c98-f9ae-08df33fb29b6
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|1800799024|376014|261026121527099003|11063799006|56012099006|261021121427099003|261022105027099003|261009223027099003|10067099003|22082099003|18002099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	6aYo5P+ogxj8pKFe6PA/nqamnViQS7+L3W9rurL6yomJqU+BG4efRH5rp/SWCUt1a/CjDjaXjXVS5MwHpCsPLOHWBms86KKhJsfFttcai7l4YIXLv6BuiNdM+U5wbKbcyqHiAvuT9r6iBZjtdMI/KlU7jHJxHcgKmQHSPoaunkL7wGQnX5lw6Dzty6xpi19EJV5vkYOX0UKbvFIlQFpCrzLF17B44GMZJFEIiV0hudOlH+ax6eh9po3zEO2u4MqdUE2Rp98KJEWp7yBwEin7vKXPXsl+RoYwqKB7FwhhfN72OvfasDIHbWEeKfcE5WOFhhipiZUWxM+BUuczKwM92HYN2szHTDUXEtR1h7S544Ld9KYl5Hcuaa6qQGt6oTpfHbJ3xJDhsgM3iuCnXc2FeYLzLXo6aYUO3sUnSGvHbBnpQl3VPM/A86d2H3yBzqYmXIzvJbuE8R4bfPdLyyhM/fGnb8AIvHISnFHyQ4XFtIKZ3S3M1Jm5TDIbN4qMgAkBI7spnQ2+EOqtBtONDpPjETW17Ztn/HlvzgqtYZ8WZZbq3Z8yUP/z4QsVM3YHCuBP0rHiuyt35B/2gBIgtADGiNjMohRIVIQDmr/aOIFhiFi6+EThgb26CpbNTsjVF29Usigqu6uinJInpar6Ag8NmoWAuz5YWvN2Kj9X1mFI3zU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(1800799024)(376014)(261026121527099003)(11063799006)(56012099006)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G9ZdiROuKF0p8P7xUhL7pzZ/h0dT2fYH9aSL8u0LrVZ+vV9s5Hr9jdW1woIm?=
 =?us-ascii?Q?HE0/l1f+Tl9g68q/leec5EtisJ7Gjzrhp7Uem2ZJX76BLyuaO5p7pmXwrhxD?=
 =?us-ascii?Q?K8p2I6QFpfiCpE3q4MLW+X/VPGTZ932CDp5OO+K/FlprisY2Qk2y304Tma3z?=
 =?us-ascii?Q?FbHJjRqksZQQqmd5MPKU+hJ+jtFMmr4pMkaE6RJIAUcWGYu7k6KDOWpvK5Tw?=
 =?us-ascii?Q?6w9DpHZm8T8ejqn8kVciiexnQv448rx4Oe2vSLUXf5++NvIGmksBrFLgUeFv?=
 =?us-ascii?Q?FNlPLIheQTrjxNb8GWuEEnYwA72CXNt13UUIlQNocevZuZoYouJxJ6S+Y87i?=
 =?us-ascii?Q?r+6eTetwkUiMUzQPzg1+rYUtlan7ffYct/P+2blgnSGoHKjkNFh+5/saMzyx?=
 =?us-ascii?Q?z4uPG8ReTAyGrrJOlkj8HfiVofh7jaIM01q7SrzfH9Ao4SnNycGJZrTX3Or0?=
 =?us-ascii?Q?h+5ppbQcVXGJs45IOW5aY9x7yVnNH+qrB+8mJiP5nuJD72NbdzIYudtosFlM?=
 =?us-ascii?Q?3rrmr5Oze17h4jeqbWUSoywVCVNSYBhZRqCKkYDdLiuwPYGLQtO0QmSJtNUd?=
 =?us-ascii?Q?efRlOIico5+voxJV19LMuTsXtHXWRsb8D0SvnfXv5vmzol3bNSwaGR4mExOq?=
 =?us-ascii?Q?Q8PInjyrqi0hDTEvYrplK/NTYT4KzV41EhkF5wbVkzf3YWH0fJZwW3jD+ZYb?=
 =?us-ascii?Q?DvZRcKSk7W52g9CXwKrSC7FO6a8Pdreo03f3vtSvuJ08HBe8ACix8QjmX7Pp?=
 =?us-ascii?Q?AbSXDQB64MU9k/G1BMeGXffQvpp37TSP7eesAIjpRjCZY5dFDm0xbC27TiDE?=
 =?us-ascii?Q?QShTqRthDun05H7XSBpbV92oGOWrOD2t1gIgkpNqVvE02AkS4JQH2IE35QYi?=
 =?us-ascii?Q?agXWxlryLnqUYJLFJU0LwL9BV41IOKK702KztdnVAoVI18Adhsz8z98boxK8?=
 =?us-ascii?Q?ji2Snbct6ZHsLxU5OuzEuumqd6JyqKMkvq2PY0MqO23vx5WqeTyFQm2q9iy6?=
 =?us-ascii?Q?AQmQsjM7fe7oUfIc/svn804xsszmVW0G2LyjelC4oQyXHMaFD7MC4MZBqgW7?=
 =?us-ascii?Q?CiTrm8FFVYaAOdtNATwUlSJX2fMQWD/zXoEtC5oWG2J5YWNG2tSWM4m6zDnH?=
 =?us-ascii?Q?fWb1KvaTlJTh89jkLsoNuc80/eCvT6scvnTQS2VhaT1bKdFBA/+ajJtCx5I1?=
 =?us-ascii?Q?8x1tmbfGnbXHnzu+P2iP+oJc7gwG5QGcVcp64Mvr7e7k3Px5kmdxQjay+8JA?=
 =?us-ascii?Q?KncA3ee1gf3hF/gBJhk8YQo2qfWbXw5JnCWIIK+CCail3qsrIJUMKwDKWXgX?=
 =?us-ascii?Q?Uw8avy7KV//yqbRAHYijLvEXRumfinrgV+avF6jrBt6m0q2LrIEIeqHBG24P?=
 =?us-ascii?Q?y7WLQrPk0j9HaTgTIZfKaEX5lnFSCS4X94jYbdYBfT3oKxC3l7MTtIedSMXh?=
 =?us-ascii?Q?HpnyO1AatqyETQDZTUSREux4emR73hlCkFm5qk8madkO5A8OBzfrQ1BWvFrW?=
 =?us-ascii?Q?g71iVgUhmGvqYFJBmUZVXZoMLtRQokElrgAjtdW0ys5weCtYh4sA4PX42NN9?=
 =?us-ascii?Q?Dc9VhLHgx7sbisoKXmkY4M3P4xvZIXfIWHAQIwADNug6FEpWBQOnzKqJxgc1?=
 =?us-ascii?Q?Bdlw/KZZW4e4uJ6bSvdN2P5c0go4M4h0Dn4m19VoDEt5NMesS5jOs9ez8XMz?=
 =?us-ascii?Q?TZfoN8acGVJuBgNdXX+DBFQPmt+wPyp9Sw+xHiOVxqFWYBpO4AEf/lF3cZNQ?=
 =?us-ascii?Q?laim1o/UexA2wbJ2cfsA0EWA7afcMACQu66CnoC4ba01bd/wbfBul77ThDLw?=
X-MS-Exchange-AntiSpam-MessageData-1: 4s/UOxIJS/W4dm6S6+fsTqKM470JbT13HUo=
X-Exchange-RoutingPolicyChecked:
	zlARB0OiKn/B5TUbrG7uR5ambMzWhnX6ZaItANvRcaU81g+uvnrLHWMZuaAOVICvJNQACf+JYV7/8KPxZPHnqMa+DXzs+4Q6RcSoa37OauIzqHa1L3rI4yOEN8JUCx+dKTqmSlZwVe5fhWXQM2sdNPyzbK5pwY114+CO2Rvxpj4E4M4OBW+QzszOkisjRx5E3ILlT5xxnU1eBgeWAUA+c+6d/FHfi1IA3wCZ95b09fPehLMZ0m2LhFNYO+0EOGk5gi23sm0tMdQlS7uOo7OKjUlf53yKAWjGIfmrMx0tDgtsyq7pgVNt5aDNvXhZoyxRu8nhdnpPxbv5iAoT8cv5hg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e5Z/Z1B3StXE2H3joIYWjDmTigDBSBbl2PhFGj3FgOgsKk9Lc3gdsCTEpAA67STBjeg2iaor0aj3syi3FvBDIVrw+rJWUn1KPwKX9P/Kn33WaDcTIfG5wReu0Vzc0i+TlQkDEsEFugJecRkCzSCDflynSLkoVXWEtNt6+1I30g/Yj/q6CaCVgmmY1aOdP/+OT/IYmpKnaXtW1ZP87Nf4hrZiwMBWPrzyEOZPVHvxneli2PEXja47TOuNUEZooXf8OnBX65RAwucR6w6kLzli06Y1Ay1C6fGLVY8kRc0P06iiOgJJf6gHI93ZKmLiZUF24MH1IqMUDy07gNQ3SLrZB1ZpeMSihDtsLkNOuSnOGxzyaciMGG4Gik0xSDtFG5loJdz6Mlnd2QJjrnatlGlM2uFHEsHTC0KEhI1lW5hRNesMmKofvnaOhOCYvaAko0SkwQAP+zfMRA5QCssJYZQm0iP2OdKjEGa5RhOzet2QGBwTJhB2D47BICqB81V+Qjp4uT4qChhdQleoSzSfxnE/JUaoxDjGCRx/Jw9m8Xh6nMBxm3rKzjBQrsEnZxSxTSHUeQ6aDnJaTPWPNtv23hyTqD8LPDqxg7Yn+4p4jP/PdBX3cQTyj0SRhtGKBc+/Aa/j
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b5f260-0c7f-4c98-f9ae-08df33fb29b6
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:14.1757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2yOgu+xUIMtEKt6bk6PlL/T+TXvZoAqAkaEwvAnYtuAd6MlAA1Htee5qMX6hE/Ld3rY/UfR7l6YMPsDnUx3QL4+Jel8tjPRE3WSjcA3WNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7064

Don't account the space reserved as a relocation target as user
available space in btrfs_statfs().

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0c8b8e392c84..16d4bd5c2d9d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1731,6 +1731,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u32 bits = fs_info->sectorsize_bits;
 	__be32 *fsid;
 	unsigned factor = 1;
+	u64 data_alloc_profile = btrfs_data_alloc_profile(fs_info);
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 	u64 thresh = 0;
@@ -1790,6 +1791,11 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	ret = btrfs_calc_avail_data_space(fs_info, &total_free_data);
 	if (ret)
 		return ret;
+
+	if (btrfs_is_zoned(fs_info))
+		total_free_data -= min(total_free_data, fs_info->zone_size *
+				btrfs_bg_type_to_num_stripes(fs_info, data_alloc_profile));
+
 	buf->f_bavail += div_u64(total_free_data, factor);
 	buf->f_bavail = buf->f_bavail >> bits;
 
-- 
2.56.0

