Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590120;
	b=ukkYTNMnR36Iy27Jouys094N6Q2pSuQary8U7tGu1oknv8n877PXaWIPVQTGHnxNErKI
	 mEq3M7Iym+/wKdhfdg3Z4s9a+YB07Upn/50H4x2pEWLxm1vl9eI+nK9hFCfQnXw2vC7tK
	 m/41A/qBWOTREnKFVQL7Ua/VBASRXp5tqMlwuogvsojjGPr0wrWvD6LE+i22DpIZ6mg0+
	 VcpgKrguez4pJzUgi1RFVk4ZITxXGBnms25yXATSxoGA5dnN0+iVTBcdYj6acE6UfmH47
	 6on/0YuSD4YX9OPTelQ4sOfGbCmduYfetU9YENT6yLd0UXQomMx1lnniDB3PQMERXqA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590120;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:WDCIPOUTBOUND:
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
	bh=6Mkmq3CTBKDQmvvg7qF0LVNim0unYKQk5Qw7uv4EryE=;
	b=PZCNBbNenfdDOusIX4zDkSs/WEyrExweJfd3jPc1dVnmH0kn9g2XfgDTtdrQURnuir6n
	 cnztxoLddo4nH2rGTszT4zJ/VuKsh3e+VEaQIf7dGjAEcM8tf5kVAgHpIhNTfp/sciBuK
	 VVsWrH8S2OQtrFujqdp/jUlCHtHkMBl557saPiW7+nDPivrCr/OFr6Lm+0Py9BASxIOJ2
	 I+Zk6jhYFEAUI/jcmYKW4yI5amxNkMJ+BaFCwO1Y9oik4ke1/GJ5qT6CtEC2WFejs1+E7
	 jaRl3QBJZcAuibnFlieSthVU3Uh0aO7q5pAkG2NT+sEegRprMnf0eSVOVCoYXwT/BjA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=VPwk5T94;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uMsFeDv9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B99606A31F
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:41:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7B99606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=VPwk5T94;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=uMsFeDv9
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590125; x=1824126125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=VNvWVw+HY29ZNQeYe+kQJq9h8IH6UM1CPxQ+GmY9U1E=;
  b=VPwk5T94PpnUwznH1jjJsUwKFbd5wDzCEsuOc7rYLj0/k7PlCZ5K/AJ1
   k8oD4c3GiY90Ty/omi+21a63Z89jxbQUm3FhROWw7bLRssKDLECLNCiJ5
   kCJPfqpO8BPKogtUSI0tGqctUOnENyCHikGtasjvloVS/50p4taBY1BR2
   /yRI4XVsr2MXHwgi7mC3Qo1aRyJY1MhdhdPB1hagxxTtkTEuWLyZLe9eI
   /EChmJef/x1KQr9RDHlF0tL6g/I8oLZ4/ypeCA+Yd5fsFQmr19f4FwLq8
   XpKSDOCmS4KE3e/zJp6UaeDzbKJ8XolcdUOMy6atw/rary2CgkOm1rMN7
   g==;
X-CSE-ConnectionGUID: usJniQp6Qg6eBuu7VyP1hg==
X-CSE-MsgGUID: KL7hHd8xS9+R0PFPXIfqRA==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="157685334"
Received: from mail-southcentralusazon11012023.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.23])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:41:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XTy/c/hY98ZXTDztBzGS8/UErzK9xoB5/vIRw6+PPQXUhA2QrF22uftm+wepGQKLMXkGu6SWadzDfGjuVEDB94PMgZVBnpdG7uS1u7aUX2jHoiFNYfpTxemQ/tG6SUf9GuPryUvN/4Z2422yvg9OjfCMbI8o34/kv2UCNQhX56rW0wtMFGKoDiw6hSE6U82+k19Ry7k5RtOTE+yA+R7wJ0Xa6vEt6DKlIvLuPjx6MmlFp82p2G3q39k/8hr3QBc2JycmVwz/TueYkZW7uVn7Ld7RW9JHilMXGMJ7C2h/x/4+QSVlA02ebt1W/g1VnVJwDxrRWGfUXMO/sCFeN5o8kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Mkmq3CTBKDQmvvg7qF0LVNim0unYKQk5Qw7uv4EryE=;
 b=NJRPclxPQGf/m8sc0W4/tiM07iOTy32R9SsbvguTwM6lCnR4Eh8ZYamr5kAyJbF/+wXpgIMgb7jnBLbKP5MYhnTCNKaAlzjeQm0tLuzoV1wfA5szuiYIueJS22i/A6aooYIXWXfjhyFm+N8pIaRRXRypsuftdp4Oqps6EFcCrNBtLUnfY43PDQDww72cYKxVRDYPXgaIRDIxaWwDBpzJSOBLMKp2yRas7dF7l02zP7UWrURw34zFXf6RIpFTdrwSGYMEfVimP3cvnrLS1u827UtzKVJ6dZZ3k9VWVCj/2slY7KPsoSA4b3E8EqmpqRX253sZ4RSLwj9L01Q0nKQFlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Mkmq3CTBKDQmvvg7qF0LVNim0unYKQk5Qw7uv4EryE=;
 b=uMsFeDv9YzuxE32xiFonwL6NY8PPyXpMrVuJSgdam4Ntf5mXHEV9yQkgH+cycWn5M9/LrixwZtc62Q4uBlH8GcDjvNwyTfzuiIo9gGrRifBELp9fYeujehRzpfStdxifIpWDyVhqch++ilHIElRMeRTHTPhUv2gnJKUQGnD/SIU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993834.namprd04.prod.outlook.com (2603:10b6:207:304::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:41:51 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:41:51 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 05/25] btrfs: zoned: use the regular allocator for conventional metadata block groups
Date: Wed, 21 Oct 2026 15:41:04 +0200
Message-ID: <20261021134124.2338902-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
References: <20261021134124.2338902-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL4PR04MB993834:EE_
X-MS-Office365-Filtering-Correlation-Id: ac71a961-f44e-46af-480a-08df2f790f8c
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|10070799003|1800799024|376014|366016|6133799003|22082099003|18002099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 7yFTHN5xe5KtvyU/ghFP70KVqMXP0Lp+IutqHq5FEPyOe1XeFsXZdKX8uvI7zpMvdfYsvrTgEim0Kzhm9kXikpvznLezfG2eVoPb5JF7Sb0mM21JXiublL2SUO8xeUClmUzEmUyV7Iv8mDVN7TexRS+LqYOdm262QRD8EGDfh/MIcdj9qON7My1EXI417U3MszpB7Izt4+2p+2bF+nVC26jrdzwB7ZGryhQhq+zZttsgu62bvXaPg3hkQLlQn/JDah1e3ae3eVUltHYS78hloGiWYbHMQEn/RnnMJlHEW2QzLhG5Mk4Jx8yDOtOoNGa26htx+wIw9kybOVY02OR7vjSKW7dSeHTdkivXtA4dBNwAp7K7IFt3YNsoQGIPkLVsOt9VWF0SwaR2TqqDkG9N6PibYP/8S7EkeDLwcd5P8kwHD9JqB2/upIHTafmjAaHuv1KYH0qowvj4qJMIH3mHGl1qy7XLgfmqIqi15B6ygO8ME20OSdRgfVDiliGNMCqfnFCVBX8B1f/ZNqIdX44m7hey+XhmNhPFRu5XKoX5TuAl5PRcnlViyqGZTDSdCYt9fwM4xuD7IKbqTllJj2iiIRe/eMbMExVSQb5NhHqBLE9h9T+uFW5sKYarWn1gR1SzAb6LjZgAUBeojJ1jWxrV1T3Z2dWTyEgPpqbHqzGTPxM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(1800799024)(376014)(366016)(6133799003)(22082099003)(18002099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?JOcqRnp7j/kY8DXl4yutosa20jkoUjL6fGmoTLY+EbbLyqeA3Jczsb8AE6FO?=
 =?us-ascii?Q?Btv2TzabUKk7UUGXQQoScDWnK2tcanX7oFHlg+1Gd3qKhU+/Q6OEOKB5/2Ua?=
 =?us-ascii?Q?G258xD6nfPyRuGDlgEHh72H05t9p1piawFt9zBC3y3AU7c4rvu+SHV5ioJfC?=
 =?us-ascii?Q?2Z826IRF2xaJ/vgl2Qd8HnwEHwYuFzjp/g7GbW5aAZSt06pSBa6rh7C1YUNt?=
 =?us-ascii?Q?JcNv3NiwYLLFJISyxbIEeN8d/2jkPcgfV0EYSv0sR/NbLHXJcYWuvc4XSEKR?=
 =?us-ascii?Q?2d7WCf6HTkxZNJXaMQurkYwCfTHFyZwkUeMnudxaZn2HVdO7GKXxDavoYA8Z?=
 =?us-ascii?Q?KvUkwRVeRAmKSHcB4rYgIw9iWYAb36kS1fMoZv6X7WCRjcnkyWiskCUmRPpT?=
 =?us-ascii?Q?npSEjVuQRx+jRC2e4bCaC2nA7DO3Mc9d0rHsy/pp1mKad/YuQejVdIT++9YK?=
 =?us-ascii?Q?dMpkrOAYzZAIlLJnrsUdFLXvi0hO8Gbhae8HpZj47JF3vMet9yrP6LN14/az?=
 =?us-ascii?Q?aYGcxyp0ZaY6KN7EytO86YfB540S8ORZKpwHST/RoWQpQNNuvfdSqAn+iCGs?=
 =?us-ascii?Q?26Vabi+smrEM2CxvZ5gBjJUwso6Jz3PBpNee1TtuG6PjhD0wIU53DErK8+i5?=
 =?us-ascii?Q?Ul71zH9YevgVxzvTi4QnT9ZLs1dOhwtyGWKg1BYSFsGiLCoDvNM1P2GqC2cn?=
 =?us-ascii?Q?ot1aJ0GlCM9h6sHS6CMK6nFyAZuDaDxPSa/O1s5Oq0oX8+t98QjQV1QbxNxw?=
 =?us-ascii?Q?Yu7cjQTJTCG99UmiEy+CN2qPMLT00rFP/8AOFchjdRLj3AplncUGk6MnSziJ?=
 =?us-ascii?Q?zxRQzuHgQ9hBRhnSZIPEkiNs7REf0J5ne4NevcKD0jhg+H4QfPKlAQZsxCg3?=
 =?us-ascii?Q?xqLA9nQaGNBncaa42AD/m82Jy7rZMiGEc404LrSJGbjm7ZjaeTBpEIQQMHaH?=
 =?us-ascii?Q?gvvULknrnqfAltURswrWS7qe8GAn/KZCK2OG83cjMfx3LW9hInqrQsbRo487?=
 =?us-ascii?Q?C17vbumPBffweuLYiAjUKsWSWhaYNKJh8YcmebS7nlw4SwbIGjOOjUiIE5fN?=
 =?us-ascii?Q?8OBIHZMgvnn201UV9mJT987FbZfxoJ1hD+dz0cSj2TzlJL1t+1R2DO7lL0UA?=
 =?us-ascii?Q?/7lVJKpf709irP3zfu86xMu+R2nHsVcZ03eJgwvrmaeFmRLQEGfraaKAM40L?=
 =?us-ascii?Q?ar8xIfc8/5ztLjsvs4Ft8G/yWhMa5P+t4HKKIhaGGvr3KHZgM5f2O/nVliIO?=
 =?us-ascii?Q?Q90j2rU/LuRqt+KoiPIVVL2UgBgObsNN1FVHnMWAiFDudE+rSmLxbAnX3M7I?=
 =?us-ascii?Q?lzy4dZCldIga90FxAWeYlb4K119Kbi2XrT4WWSaD5GkWvEq8qQxeD8KRHIAh?=
 =?us-ascii?Q?ND0HW6Cb9J/m1y+1/ITxmJRNNMkhz24pO9E05S6fACmjkezQbtzFFf7JWdIF?=
 =?us-ascii?Q?SqyvnNso+gSixSSAhXaAQCVzv2xNhR4GQdIK2ETm7Dn0dqFymFQK6QT5NGnB?=
 =?us-ascii?Q?GfQBlpiYxtSPp1bcVZDI1aAPO3vzOZMcvsMTDTGBBLXyCSYevHZBEDBUkUEC?=
 =?us-ascii?Q?MtiAhE2vTa+vT3uXtbpHFuXNg5UmYmCyMBqZnFuZs1I42yqMpxHYxikcs9OE?=
 =?us-ascii?Q?KU0Ot/S6JckpTFtJCwKq3m6SV74S33WZU049uVYQKctysb/J5AdJJbLx9cIv?=
 =?us-ascii?Q?sm0V0VfLvgi4r2NkSGftSjcKU2+e/YMu/WGa/74TrS+8bVa/R41NFgrZsji8?=
 =?us-ascii?Q?RFEvMS9N0JN9aD2K9wu5lCKMLeHQjaOfL5rkLR7LODMiHwl5174wZi6KXpyu?=
X-MS-Exchange-AntiSpam-MessageData-1: K5lE7BOjyqOXMs7wU7+PvLr9rkOklSii/UA=
X-Exchange-RoutingPolicyChecked:
	wCBmInvOP7O+WoKZSqb8RyErcGbb1lBxgn6eY13waXXPRXTkIp17RYbSLtU3bRa1SwCuexLgbiLf88Vq8ZP2C70d9V7wqDf3u4QdqBcCZsBmDA1Z2qyVdhnTK1SFKwIgt5dZre4ttJJPYcXlSB46NwdzBeNGltwmWiwXRyFbd0y2+ZMRqtgnEvNeXMZqAC2eiwPuEZ+H/fmngv4MZcILWHTfn7Mbai9A1hPh1AKp/Su+Ejo16L37AFg0t57mwNyTQABQ3RciKCUgXWxtwsXrSzbkrTp7js996KfnPxE8MpqiwegV4V6e446B+CimrIggDz521B5Tx72e9BIrktdGYA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+tku1BtVq8NMKCMqn1dNa5JPyEa9X7gJfyL1L6K3VtbC5C/z8ESGmVSgqd8CKwdNRDtbdT/XiyCydyfHwi8+zTLDTZl0nvqhMqppealE/v65TEjkcKCBG9fNK2U1+ctEhLX3uc6uuNnauPaJdg8nIwdubINuM+b0xfwNV4fBme/zv5y0BttVRRoUiYexoT97TVm0ImsABjku6cOalF27CntlHR105iLnjoYZzdEJm3T3Bger0aVecgQHmqGeb+16AOfsCyB/Ju8KKspxGbyvaXj81gyi7z/3DqaRqZqUOgbHkoEybWQQB88cUdtAQzf5VXW57blMRjFuFJpNrIrFJqtdUYeqfA6MA8UJ/iOJTZYX3pEOYMEMremCIFixoWWVOS72QIYgsuDKml9K16+g4VFpi2kYYlFdOw37RKTC0b3lVPiIIGZbEjAaUiYKbE2MeAvY7Zj/IGsUsl8SSJPcJU5O1P0xQrHiv9MJvziHAntTw6vFkIXXHGbfcNLSurBqJgAW9cYeBLPpQW03GSFQtMUcBSneNFOk4ve/oySAj7NB3kQ/EKJZVS82wQt5HTEGB9oaAEMxxpz+QEuaEoTSQcRkbsAdDnMdZFHws5LpzCWrdVWW+glcDk7mmb6zemo6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac71a961-f44e-46af-480a-08df2f790f8c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:41:50.9205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2vQj/Rkp/mUAO1v6gFnulRFQOThRGl1R/Z2DVpYrBINeGs9/nNfDK2PE/SmGT/u/+TtcE8iUpt+4i67ghGpfbH8BnwB54ruu6Ip4I38nssM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993834

The zoned allocator hands out space strictly sequentially from
block_group::alloc_offset and accounts everything freed below it as
zone_unusable, so freed tree blocks can only be reclaimed by relocating
the whole block group.

A metadata or system block group backed by conventional zones only can
be overwritten in place, so it can use the regular free space cache and
the free space cache based (unclustered) allocator instead, and freed
tree blocks become immediately reusable.

Pick the allocation scheme per block group rather than per filesystem:
replace the filesystem wide btrfs_is_zoned() tests in the free space
tracking, the space accounting and the extent allocator with
btrfs_zoned_bg_is_append_only().

Such block groups no longer need an allocation pointer either, so skip
calculate_alloc_pointer() for them when loading the zone info. As a
consequence they are no longer marked active and put on
fs_info::zone_active_bgs.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c      | 16 ++++++++--------
 fs/btrfs/extent-tree.c      | 29 +++++++++++++++++++++++------
 fs/btrfs/free-space-cache.c | 23 ++++++++++++-----------
 fs/btrfs/zoned.c            |  6 ++++++
 4 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 93f3251f93e6..e38c728a503b 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -953,8 +953,8 @@ int btrfs_cache_block_group(struct btrfs_block_group *cache, bool wait)
 	struct btrfs_caching_control *caching_ctl = NULL;
 	int ret = 0;
 
-	/* Allocator for zoned filesystems does not use the cache at all */
-	if (btrfs_is_zoned(fs_info))
+	/* The append only allocator does not use the cache at all */
+	if (btrfs_zoned_bg_is_append_only(cache))
 		return 0;
 
 	/*
@@ -1455,7 +1455,7 @@ static int inc_block_group_ro(struct btrfs_block_group *cache, bool force)
 
 	if (!ret) {
 		sinfo->bytes_readonly += num_bytes;
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes to readonly */
 			sinfo->bytes_readonly += cache->zone_unusable;
 			btrfs_space_info_update_bytes_zone_unusable(sinfo, -cache->zone_unusable);
@@ -2552,8 +2552,8 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	}
 
 	/*
-	 * For zoned filesystem, space after the allocation offset is the only
-	 * free space for a block group. So, we don't need any caching work.
+	 * For an append only block group, space after the allocation offset is
+	 * the only free space. So, we don't need any caching work.
 	 * btrfs_calc_zone_unusable() will set the amount of free space and
 	 * zone_unusable space.
 	 *
@@ -2563,7 +2563,7 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	 * in and be done with it.  This saves us _a_lot_ of time, particularly
 	 * in the full case.
 	 */
-	if (btrfs_is_zoned(info)) {
+	if (btrfs_zoned_bg_is_append_only(cache)) {
 		btrfs_calc_zone_unusable(cache);
 		/* Should not have any excluded extents. Just in case, though. */
 		btrfs_free_excluded_extents(cache);
@@ -3245,7 +3245,7 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group *cache)
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
 	if (!--cache->ro) {
-		if (btrfs_is_zoned(cache->fs_info)) {
+		if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Migrate zone_unusable bytes back */
 			cache->zone_unusable =
 				(cache->alloc_offset - cache->used - cache->pinned -
@@ -3727,7 +3727,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 
 	if (bg_ro)
 		space_info->bytes_readonly += num_bytes;
-	else if (btrfs_is_zoned(cache->fs_info))
+	else if (btrfs_zoned_bg_is_append_only(cache))
 		btrfs_space_info_update_bytes_zone_unusable(space_info, num_bytes);
 
 	space_info->bytes_reserved -= num_bytes;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b0a5c6b96f3..4539a775cdcc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2896,7 +2896,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 
 		if (readonly) {
 			space_info->bytes_readonly += len;
-		} else if (btrfs_is_zoned(fs_info)) {
+		} else if (btrfs_zoned_bg_is_append_only(cache)) {
 			/* Need reset before reusing in a zoned block group */
 			btrfs_space_info_update_bytes_zone_unusable(space_info, len);
 		} else if (return_free_space) {
@@ -3685,8 +3685,8 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	 * contend with.
 	 */
 
-	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags)
-		     || btrfs_is_zoned(fs_info)) {
+	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags) ||
+	    btrfs_zoned_bg_is_append_only(bg)) {
 		pin_down_extent(trans, bg, buf->start, buf->len, true);
 		btrfs_put_block_group(bg);
 		return 0;
@@ -4037,7 +4037,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	int ret = 0;
 	bool skip = false;
 
-	ASSERT(btrfs_is_zoned(block_group->fs_info));
+	ASSERT(btrfs_zoned_bg_is_append_only(block_group));
 
 	/*
 	 * Do not allow non-tree-log blocks in the dedicated tree-log block
@@ -4191,11 +4191,28 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	return ret;
 }
 
+/*
+ * On a zoned filesystem ffe_ctl->policy is BTRFS_EXTENT_ALLOC_ZONED, but block
+ * groups that are not append only are allocated from with the regular free
+ * space cache. As prepare_allocation_zoned() does not set up a cluster, this
+ * always ends up in find_free_extent_unclustered().
+ */
+static enum btrfs_extent_allocation_policy
+bg_alloc_policy(const struct find_free_extent_ctl *ffe_ctl,
+		const struct btrfs_block_group *block_group)
+{
+	if (ffe_ctl->policy == BTRFS_EXTENT_ALLOC_ZONED &&
+	    !btrfs_zoned_bg_is_append_only(block_group))
+		return BTRFS_EXTENT_ALLOC_CLUSTERED;
+
+	return ffe_ctl->policy;
+}
+
 static int do_allocation(struct btrfs_block_group *block_group,
 			 struct find_free_extent_ctl *ffe_ctl,
 			 struct btrfs_block_group **bg_ret)
 {
-	switch (ffe_ctl->policy) {
+	switch (bg_alloc_policy(ffe_ctl, block_group)) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		return do_allocation_clustered(block_group, ffe_ctl, bg_ret);
 	case BTRFS_EXTENT_ALLOC_ZONED:
@@ -4209,7 +4226,7 @@ static void release_block_group(struct btrfs_block_group *block_group,
 				struct find_free_extent_ctl *ffe_ctl,
 				bool delalloc)
 {
-	switch (ffe_ctl->policy) {
+	switch (bg_alloc_policy(ffe_ctl, block_group)) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		ffe_ctl->retry_uncached = false;
 		break;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index bff6e5b372d6..5d830a827cda 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -26,6 +26,7 @@
 #include "accessors.h"
 #include "file-item.h"
 #include "file.h"
+#include "zoned.h"
 #include "super.h"
 #include "relocation.h"
 
@@ -1370,7 +1371,7 @@ static int __btrfs_add_free_space(struct btrfs_block_group *block_group,
 	int ret = 0;
 	u64 filter_bytes = bytes;
 
-	ASSERT(!btrfs_is_zoned(fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	info = kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
 	if (!info)
@@ -1499,7 +1500,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
 	if (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)
 		return 0;
 
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    true);
 
@@ -1512,7 +1513,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
 int btrfs_add_free_space_unused(struct btrfs_block_group *block_group,
 				u64 bytenr, u64 size)
 {
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    false);
 
@@ -1529,7 +1530,7 @@ int btrfs_add_free_space_async_trimmed(struct btrfs_block_group *block_group,
 {
 	enum btrfs_trim_state trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 
-	if (btrfs_is_zoned(block_group->fs_info))
+	if (btrfs_zoned_bg_is_append_only(block_group))
 		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
 						    true);
 
@@ -1548,7 +1549,7 @@ int btrfs_remove_free_space(struct btrfs_block_group *block_group,
 	int ret;
 	bool re_search = false;
 
-	if (btrfs_is_zoned(block_group->fs_info)) {
+	if (btrfs_zoned_bg_is_append_only(block_group)) {
 		/*
 		 * This can happen with conventional zones when replaying log.
 		 * Since the allocation info of tree-log nodes are not recorded
@@ -1663,10 +1664,10 @@ void btrfs_dump_free_space(struct btrfs_block_group *block_group,
 	int count = 0;
 
 	/*
-	 * Zoned btrfs does not use free space tree and cluster. Just print
-	 * out the free space after the allocation offset.
+	 * Append only block groups do not use free space tree and cluster.
+	 * Just print out the free space after the allocation offset.
 	 */
-	if (btrfs_is_zoned(fs_info)) {
+	if (btrfs_zoned_bg_is_append_only(block_group)) {
 		btrfs_info(fs_info, "free space %llu active %d",
 			   block_group->zone_capacity - block_group->alloc_offset,
 			   test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
@@ -1838,7 +1839,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group *block_group,
 	enum btrfs_trim_state align_gap_trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 	bool use_bytes_index = (offset == block_group->start);
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	spin_lock(&ctl->tree_lock);
 	entry = find_free_space(ctl, &offset, &bytes_search,
@@ -1971,7 +1972,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 	struct rb_node *node;
 	u64 ret = 0;
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	spin_lock(&cluster->lock);
 	if (bytes > cluster->max_size)
@@ -2789,7 +2790,7 @@ int btrfs_trim_block_group(struct btrfs_block_group *block_group,
 	int ret;
 	u64 rem = 0;
 
-	ASSERT(!btrfs_is_zoned(block_group->fs_info));
+	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
 
 	*trimmed = 0;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 81e211316971..9da4709a6608 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1976,6 +1976,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	}
 
 	if (num_conventional > 0) {
+		if (map->num_stripes == num_conventional &&
+		    !btrfs_zoned_bg_is_append_only(cache)) {
+			cache->zone_capacity = cache->length;
+			goto out;
+		}
+
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
 			btrfs_err(fs_info,
-- 
2.56.0

