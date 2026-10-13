Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0E53A16AC
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876630; cv=fail; b=lDMtNniyxJSd2II1aniSrwe/DnheqmCKeAEfc8V3vUWmo7/rnTWujyCpc7fFpgh2ryjrSik7NVePD81Dc5vfi5fHvMVK6FVXHeDdmCiMrq1pRenAMB6U3wBjZAuEhv2lzS6Qt7sk/hIxhNg4P0MdgQA0esHNcbySL3ETV+F1bHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876630; c=relaxed/simple;
	bh=f0rLNc4B9GCjzu2aI1ABNxeaoyFINBJUyY/RZERCbpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D1Axczoo8s/GmTZ4iDpjf3cS39Gwk73xYYiemu7L/E+LOptxoPuFx5tesQtxjima5q+5qxGSzkBje9Z3VZYNczrEmW9tOjL61awqm5ube0Ukcm8+hAkcM4Yob9YcURu0untt6JfDqhz76+1stztgTdRBYz5NBQBQ3Qycu06t/MQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PEoAuUD4; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ZqljN15r; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PEoAuUD4";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZqljN15r"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876631; x=1823412631;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=f0rLNc4B9GCjzu2aI1ABNxeaoyFINBJUyY/RZERCbpo=;
  b=PEoAuUD44O7KJfbJ3rcY3K3i910UoXNvSYnf39AwJmDwGaMQurb+5x1p
   QI8c/5V9zFAA78OC90CweEpZ1ph+PVktuP+uK8L7kLwC0k2/yqOVcgObM
   R1t5GO0a19rqSSgOErLLC5PdnjPifNmRQNQLkKzW2wQm+J1hsy9nnscII
   ZUxGZPXgPk1O4lFAesGykjnrf2YouoJigXB7+fuoOrnCTLTSD0h3vGPTu
   RcjxY3IbwMy8Lg53YuhazyAvLLSkr7yAhLLiv9yHdvP0Dqp4yJqx+DCu2
   1lS24DywI2JN5FqRUb8KJeTNw5MDBTIw/1EWFPdEZYVC5HNYLYumDo+PM
   w==;
X-CSE-ConnectionGUID: 8LvH6qybRzK4oFM2uEZCFg==
X-CSE-MsgGUID: o1NChrDSSn2AZ40dYGti2A==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="158917172"
Received: from mail-westcentralusazon11013058.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bGw5tb+eupSL/V0sac590mQD5Wzj/cvhNwa9AhU9ZiAgdCis9oXjzfYcA+pgD8knGaQPLTsTtULhpf4igQVZ/vHwhQviEf123Gkke8j2+YZdInlwxSh7uVlgQTcnMfZ90KCUKxw0oDpT/3cNCl01nwir9A7G9qHOjlW7JYE2sW9IL6QuyMpcvdqm8EWIWbhioThwuTMnrACte+KB9bVOfPMhCAAN/25PZ9wJGWmQM7L6LrezJsaXPQ41s9XI01xYW6f0HJ56zvO6BS9TXr8h2RTE3sXSY250IZirlQFipZwVjVfI7ys3o5LtuwqURMrgPdCTN7lAxIb+s+AWtSl58g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/r2dtDhs/X+36Uh8jiVuw6/GL89sFVjUnd3R+4LifII=;
 b=M45Yt6Re4RBs3r1cBlUp8MgakNiZkwPRJSHzHyL66FyShTCjdM30R2ZOqLwn/07TrnNvrrjAZ/rti6lLRTRHh5FmU+J08XvPrNbXzgTVUcLkgvN4pBqiAh10kXFUDqid7WbNDLsHe6pg9WEkz8+LvSF67w2xNIbdrIfU+Qed3WK2K/Q1RgPhN5BPHfzJqQGRSuNF/h8Q1riaJtZ+8DU4xybegwV8EB7ghQaODfQhePAAhTKCJu3CmCAYU5AoARkuBDvoRxbYoRzPIg2d/KQtIbaZadIXA/yb+xDKCNpWtU2iAlGTWuvRTWN8bO64xSLXR47wNBH+S9drx/oImPpsxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/r2dtDhs/X+36Uh8jiVuw6/GL89sFVjUnd3R+4LifII=;
 b=ZqljN15rub+W1Y+JM/RWACASn5tLnzOTuWjD2i+V70NAjjSqEg+Y0EHBKXIzbrDu+UwRaeTQtn1FPrZeZUqpxFb0wZ1TGEdw/XYXE8PFmuxPIzxRFLG/EAdQxasw1dOGgBpthpkJs82Bl/OIp94FlBTQDctI8FmqXDnU8lbH3fw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:20 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:20 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 04/12] btrfs: zoned: never activate conventional metadata block groups
Date: Tue, 13 Oct 2026 09:29:33 +0200
Message-ID: <20261013072941.424029-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
References: <20261013072941.424029-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::27) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CYYPR04MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: ed51e862-f1e2-43cf-3d48-08df28fbd5ff
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|11063799006|261009223027099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
 RXTYlUJypbJXChgR9jwFhKS+wKGq+Dqocv5WP3Vx/5aImHwYEXr1P4SNpleaHojqdcK7ZkYh+tE5W7kleqkkUU1rd1SCvJRnSo/EctPLkD7DUE6SEMgnfUc6I1xsKG/h0ziTXSmLV6ais+7Z251NqARNyX5EH3L41R2oJkU6dsUpuZPZWjUK4BN+0RjkGcft4hdvou3ISnwlIy00wVQq1l+K6wAnBnkQd6TvLFNh7XHWhQJfIvZB3bFKVbqnsQuppBHmb6mDYSBXkXhVoDiptkL+lZMyb+sq5rfm/cses+Q2ZPpBYY4cBNBTqnCpL8QdOFpBY+or8J07eB11GJVjI4WAMkDxrfOrqvq08XO5Zmpz6cfG0zDnUcb+CW5o01OESpz1IfZsxiGsyy+hwdmchQ5awChBSwRGV2wB3+5z/Vx1iyUPRRsxheJfyHSJBK+ThI/j781xVgp+ycZ4eTYbmYlxVK1EgGX9lerldb73vfQ0aOGGBP6byTxRMHhdt2iFRZtSM9F0M+bp9sfjzM6MLJuDBPtijyniZk+9NlU2TXAjK+Kxv4yEZUkL3vxQHVm6Qc9SnPi4vLKlHeoyPfZsmmYCM4JcH+1e7vqw1qf9KfpyUmQf7Tak8DczwfffEd7ygveJDB5tc3g3RGdcwaJTJm+gFVE8Js1YWTs55zZhy00=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?xs/z69qkx4SZIabJNsz0O7eX2c1fA37qdEVTbjaMEBow2QPV3CV16jbVha6e?=
 =?us-ascii?Q?T3EvQV22dhkFFEIZIAgHlu8iotCwFWCmUklSYkjIgOJwP++/wc1fEjf7ODbW?=
 =?us-ascii?Q?x7jss4rPrnNcd65HXkrbOT9s58rbyAhDiovin+g2dvRY5s37CSXlltJwP7iO?=
 =?us-ascii?Q?YrxdUAPEPd40bP0i40lKzYPFVlMHkygaXEel/3t2J7PPqLXOusJD1NPvKQD4?=
 =?us-ascii?Q?+9ZFSm8A9TbdiL8MOGttyHFSO1q5A0N86kq1AKVpQ6tgR5T6WtqQQ1gZpxJi?=
 =?us-ascii?Q?f4sWwLWlZKY6kLIn1Xke4a3JVSx26MhMB3Nyj+izPfhBBWxf5Rnkg8XTcm5r?=
 =?us-ascii?Q?qv4BvxQX84k1OSsbUfDWxV26DoFhEz3CmRdClzHAgl7oFJeLqk5Hm74GF+AJ?=
 =?us-ascii?Q?RaRfmyCVBlDGUxgCZj5raZt6kPZMYEbuqigj8jXLe0KTsNTPMlOFepnSgtdB?=
 =?us-ascii?Q?sWfbeMdBiAu2fSSoxrg8ml7WuK4ACcod0As5Rok7pvbGMW0QJUj25I+wfDnm?=
 =?us-ascii?Q?/zbjWemGtaNx5aA/dgafHEI9JSWq+TkPpKQDOOpzZlDByNiLnHtCEK0KjNlk?=
 =?us-ascii?Q?6L1X9zOsNWgHcrS2hZEpzeCyRg9UAP71m92GUGpWJvVyNxLJ8hlQwQtIVU9u?=
 =?us-ascii?Q?egq+y6S6qWOJtciJcdylOU5AC4vxDtqXMFn3RN5uhXWNzREnM7gMvdgQF/b3?=
 =?us-ascii?Q?Ygm20H52VMFOI4d7plTeitTS2zsCJ9YKp5UTQYBS1m4SHFnG2rEviZJ7SCML?=
 =?us-ascii?Q?rEpnG1mZWMuSQnbOTjQztGakrigEL9SePr9DtRCmAzwRUJbdPGnyKlFpC1az?=
 =?us-ascii?Q?Vo7bAYSfW0yXFMXLvQVr/SYlQP6kPXpMKt4LgTCarVK4Pcj6nt4DloHNjb+X?=
 =?us-ascii?Q?UJ8s51EKgvhtm2FqnXVnD+tWFZ10gDIiFS1sQCpi82VeLD/Wqmo8bfl+3nDp?=
 =?us-ascii?Q?BeUTQgXo5Hx19+BPWkPJjMTTK4Ive5u34ggoAlF/ZIruQ415bdwxvAUfqlKQ?=
 =?us-ascii?Q?G9JF5r2xFe6Er1ZYjh2LzJXo0MQe7NdlvU3zfpeK0afha73hUgS77XjQvBTe?=
 =?us-ascii?Q?QBrQxKal/QqdWeB0cLKpssl8EkZLN14ydwHbVkrb84NlCBbRhXfDE+C63QIi?=
 =?us-ascii?Q?weKiub6N3Zk4RifOUiSq3es7HeyiRSdO+rIQkKGm/uKtc7/g1dfuS8uEH0v8?=
 =?us-ascii?Q?2mpp8I4urMMzSzw6crG5falRLOvLLdOo+eIcBEDSo4R5ixsvpvcADUstYNAX?=
 =?us-ascii?Q?hEWWqIkEdTD2PzXO8CG6plnAMkSvU4qod16njijHEFaivNRw18esa8dgAbV5?=
 =?us-ascii?Q?D0VjdVlRJei0aSHNpU2MENM4Y2HWYuaOTnggaz4zv0y5J/9A6Nl6B+gNX9m9?=
 =?us-ascii?Q?AWkVrR3VK1KXRBp1Kw7rmZfY3Mv6o0JyS6k0hDv6bRSst5X8/VMmihFI+JvD?=
 =?us-ascii?Q?b/RpVvl5rull9xIx+uqRoAQ+r+Ok6IZB/FomzYnRNWvOTA0XGfKCfV8WjMcG?=
 =?us-ascii?Q?8mSlsC8YRY7t2zuN8sPbzTYJY3T6AlrPwXUsB4niOL6Mzf2YpG49n7lm8grp?=
 =?us-ascii?Q?yRjlsvOtKuELTJL6zabVLcjKO4zBe9LkQ/zPErTsJUueRERtySCt0v0yNC+9?=
 =?us-ascii?Q?wBa3qWG6iBVINqjTORyAZ5fl0r5M32G5wcAs3QD5qWihsWtIyCrrJ87BTjjW?=
 =?us-ascii?Q?CpfHOHCqsAdADYz8Ik/vgajCI3l08IqrbXqZPO6s09eXnXg+/QxJ2rvtHon5?=
 =?us-ascii?Q?Tms9wpB40rwtxp/+488PVpZ9/eI/KAMHsVfkItdOGTc9YF/Ftdo5HOtCJbXp?=
X-MS-Exchange-AntiSpam-MessageData-1: rQQEade0x765tud1exBt4NSbic9SRB0+EFk=
X-Exchange-RoutingPolicyChecked:
	p1M7vArVuwSqO8xVeZLWrwjqjyY0x/BX2PGxjVvrrZDVhcmFeomYhaefuTEay4yEF3VWQTDFnk19tGGn9X0dQiOAxNd3m+JzDBiU7QpsYMiK50u7U9X53HUWHSCm96GcAHmCDmNy6OoP47URzkWuwTEF3Zpxh1swRB8XXiVw9/6sN5KoYVPKZOe6S0Mwa6YONUvyuGIV8dexPUorLMjWk4BI9Z/3hsy5108jl7Z9y/ljdjFnJnbtG5lDox1ERJ9Kc8x1L5O167YB3ZBET6uJETvcct1cnS/PQ4CA0d+d9Ps+4irLf0KeW1hXyZrcAnxb9+iasESUSyYox5uQBZalBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1mxl7XEOsd0mMzfkBtfffgzm0XlJZu30vAGfT9jtdNlUL/xRVAOKEGr/iuFIt7E5JOwF9B2/vbK9pDU9+d9bI3RNJFE17GVhMPeN5lwebmuLJc+wvWtIVGvoA4M/1Mii5gmWl8ExVY+cYewD+5zLLr5H1oR7JOomtqFm07IwhyVZECtZ2+vHycAxdByA4w7Z/PDmp5h7+DwAX7+AQu1r92zpjKcgmqa63BwpD/U+ixX/TC/+PcxcwhA6+RTWEEAI/0XFwJO+9dG1tpvHFGzqZou20Q97x+j48Nca1MTL/RdhbFY3jcE1DfxtX4rTnhJLExloKrxXOEFPwPjmdZjixo1MAECawiz5WqyjD4gQm3jv+UegwBlNt1IsxEXUD8G+yy5JbXAfGiAb2Lh8UYFyuDMNa2s2qJw4hgPXqc6K2QTLwVqmKdwwnjkwkcWpOij9GQlQMxaTpBjq5fVKMZliK8xLDJ0RD3lH2rnbbM6yxTSAE5XLcdhv6UdTwmoEt1mJK0PZ5QbQD5iNjcx5AxMlcaNnhEq2tIt6Jn0GFgMbL8KxorqET4gRqF+kekRHGC+mNkxmToJh+Wais9DrTTYnSbw2kB64+8SZnks5v+XKVii9kDHoyhwuDGyfNqtxNqcr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed51e862-f1e2-43cf-3d48-08df28fbd5ff
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:20.2962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eudczt9pCnHHvhj840+BnIvvvny8GKXRIUS7SlVLo0M72fWv1n9IQF/6n890pfOuSvPyRqKhnKlUoG88CmbeXEzvIJ5X15QzexEqO2rKs7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

Metadata and system block groups backed by conventional zones only are
written in place, so they do not need a zone to be active and they do
not consume any active zone resource on the device.

Make btrfs_zone_activate() a no-op for them and skip them in
btrfs_zoned_activate_one_bg(), which would otherwise report progress
without having activated anything.

Such block groups are still marked active when they are loaded. That is
dropped once they stop using the append only allocator.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index fef7cf390425..76633d88cb48 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2457,6 +2457,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	if (unlikely(btrfs_is_testing(fs_info)))
 		return true;
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return true;
+
 	map = block_group->physical_map;
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -3060,6 +3063,8 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 		for (index = 0; index < BTRFS_NR_RAID_TYPES; index++) {
 			list_for_each_entry(bg, &space_info->block_groups[index],
 					    list) {
+				if (!btrfs_zoned_bg_is_append_only(bg))
+					continue;
 				if (!spin_trylock(&bg->lock))
 					continue;
 				if (btrfs_zoned_bg_is_full(bg) ||
-- 
2.55.0

