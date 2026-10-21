Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590143;
	b=yO8JiRd2+DxotuiwEF8GyPivqtUpJaMscs3iZ5V8kimx5bXRW8v4KNItri4BLOf+wpHq
	 EuEvRQKeEM8JDH1x5ys1QxPAPS5sSRbSWwkbypBLIBl5VTrDGCEWXd7LZ0iiwiBagB8ut
	 KQG8V+hNplQZ8Et7UVyg+TUBeRTgs8DF5otltZwjqJzuzALxW/lNBiGaemHhdNMjKKvNs
	 iZSriQNKA7nHCKw+NJsYjIlfifeZr35N6I4w9YucYO+mn25bvPp6tiKj4GXbJajEfaTv/
	 D1RMi6d0womX44EwFpG23O1cTUpxxdAwttKa0xF7skdE7HYlsLzvDlrc2JoTEM0eA4A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590143;
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
	bh=SdRzaLSEEpi/QtF9R7/Ks0SDE7zkWltcXaKocADHa/U=;
	b=tZIVab6g9aSX0K2eVNBut+AaspJk/Mc5qpglfLyqIe0sO+HZLxUMicKPYZl5PX6f2U1l
	 UMydfJiWLEMTwmi8nKbnQKxvTmf51aauMIqxtyHJLhqo5qTDq4Dje/pvIoW3x1C4wL2c0
	 lBvL5ZWp44A2FzzK5yvxhIpmTLt48tCmUk9FzPOJzAf5tC284njCV7G0YxmQyYwaHnSkJ
	 svWhTRPi805ut/TWM0quGv5lsTjNA3w+1iluMlleL+Nc7sxfQ9oWXXBUfG5BeTtbRs8NQ
	 YZ0RpDSUV6XQ4GWt6LxKOGyOJ1LeenbHXPwh6D++ed5Ws1VUO5HJXuKBbxOzpIqpr8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=otgg4t4X;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=FWEK+hSg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23405606A324
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23405606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=otgg4t4X;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=FWEK+hSg
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590143; x=1824126143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=0lfUH2HOUf3AtlAauWXKo4My6NsMmjgBvp9oIrndX1Y=;
  b=otgg4t4X55aehVc98Vyr/9vj2kqNsCGyhqjjLpkxxLwC7ZYSmNB8Gwz+
   BD2PXx/j3jZzgOKpkTcb6V4CEmk/JWa/HxzDesK+0SsK3IFeMjdbdpgXN
   uMVFdbtEK39f8soaclPupWC9l9OdRdSIsB2Ka1a0f2PruYtUlbGQTuBKl
   i3K7fsITZgzAxdZxoUc7tNxAJLvX3own0Rgx/XQpjQLgterGBFxrHKveZ
   u30voOyYTvhTqmvKYdqgL8Bxbqxn60XkQxoedISfmkvnDI0l5yEU2VH1C
   Mx3+qWIo6frnAppxd5K+AXHDkID1I9vjIXkZUoYAPEXxZxnj3O8T1aaPn
   A==;
X-CSE-ConnectionGUID: 0+7HprS4QT6gF3Q+TKHK8Q==
X-CSE-MsgGUID: I8y5Z79pTyK8puu3sJseTA==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="159601516"
Received: from mail-eastusazon11012011.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ca1xGWQaJXx/sJ37DJCVU4+DHcEbKgzt976Tp6RM4iMvQMU47vFdcURf7bF4WjEJ4f3hy29JGg/sm852UmF5FLKQmBOLZtpj5jiqk6y6nDXefZxvZG9FLQ5DYIAQQZHJbD6huSMFNU7zEBhkr5Qpozod6G62YSh7BnsoeIEtZs3cINiq8eGSNTYDLRENvsFCmYaC0UIDrNDPzZZP27YVtsopcLkn5r8uHcdjBe0J6jye01tOO7EE2wM5HxWNuc7thdNNFw+OrWzHeVYtR3mJQZPDhLR8uLa7W08NUYnEL/tckOdQW5JwFN22B+UGAE3CUOIPeFMLHT7olin5yp1RXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SdRzaLSEEpi/QtF9R7/Ks0SDE7zkWltcXaKocADHa/U=;
 b=QBSwRg6Y9Ke2rSYN7zxxbvDPCvk40nqCYaIXSbDVZnVC6ktld1Y5mmVc2VcudZI8ne8gCeW0uHHXJ+LIkRY8e+KSiCK9WisrDA00ElPe7qbxXOw0KEzpKfWivaCgq4tL1hWifKQOmTdSjZOHFTmr5RfEhZbJyQX8h3c7olJsV0x2PFEouqHhyX9Rjt1VxNUgEpXZfHQSp2Ep0fRCGkW8RLVxGhAVIkrVAX9Tz8UMTnWPFsLyKhDLiX81/+RPPxjph4KxsEvM9Pk7JQakfFM7MuAGVbOo7ho98RMTl5nMeh0QiRghUzoux1US+RA6aytM4nxg94BOjlzOxL1prfHOjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdRzaLSEEpi/QtF9R7/Ks0SDE7zkWltcXaKocADHa/U=;
 b=FWEK+hSg5tJcXFEdsaK6Lti5BAsLioPZpqhGa2GWl44IcS9oYzRYvht5B6CX3A3UORQO+F7lv2e0hbGAJ/EdIhFiuuSZNeGqPBQIy9cq06lohDKef7g9dchls+HJBf/YOgs4vq12Zr7BS5d2uzTxiik6UVg/lML/0hJZI6zQiwY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL4PR04MB993834.namprd04.prod.outlook.com (2603:10b6:207:304::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 13:42:21 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:21 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 20/25] btrfs: zoned: return finished relocation block groups to the data space_info
Date: Wed, 21 Oct 2026 15:41:19 +0200
Message-ID: <20261021134124.2338902-21-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 38240b19-1b9c-4a9b-7419-08df2f791e6d
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|10070799003|1800799024|376014|366016|22082099003|18002099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 PeYBdQxqJUiLjRYu0fH33o3wdOBf5vAeu4rL/rSTukE2gfEMgyXGRcjNCp+VRxc8d7RsX0Zws8Y0UhJTjnsi+OetBKMxTSLTQ6UxukjRd1NtCdVILCjC5Pg3CIxKaUoQJ735z37klNlXccVkvtJVY1T1li7uh2o7EnAQH/eH8mtoIBGY/RsrT8FwBKJ6dAmCzDQmpHbdU6A0rccUpY4tQvXl3WG8dEIVQL7cPTqRgO/8bki3324q+EbO7fmjKSWfosaBPZoeyfEqNROG89D/hKty0q0yRhavqdXZZxlhhlCjSJ8e1yGh0sG+nHkzk+zVUwbu4cN3b+Fqw9vGObmakNMYJiIzGp3v0b5culWQrvz/jL37MElCPYVcM2bdlyJxF9POpH5vINTZ/SXsPiKZbU4z15+5s54NKm2O9OxYml9PLz0RYO5nnfhD71M8Rx6k75b0cjqBR+b+G96efWkn5Q1a9CCCSsvwpohrjGWcHea3SBppvltpF9uPexIHra0FVgQLzIrT1Cw8gYYm31/ZjSR8nwvNn8jMwHqMsRMJ7g+BNekCUW4PtXlKuCd+edqYZcuYiB7Jo6YUJAij/v4QrzR/trEX3hQ1ax8purNhcL+N8cNnpSSzYG2l2IaolX44/VS//2ZcNRkoIzFxjhDKpIfQZektxjFdVYl0CVWl8cI=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?qyUItpC3Z+fxtQjY9GS3iLCQV6DZXS97t1o0+nB0L/Eq2CxYHL035O/txMR4?=
 =?us-ascii?Q?ayumJ7kLgNmp4gKohA3EfSkzdfQwCCBHRWhPrbKj2aTp4hGIO7ex7rHOGkQl?=
 =?us-ascii?Q?LS/7+PhhfBdWqbspcBBhN53yRMDC9E0LG7rgofSIwbdka82olPh5vUR4Xgkl?=
 =?us-ascii?Q?i8ME12Ha7+vCW23LGOVpYo8rGTepnAUZ8/yRMAY5iDf5oGkzV+G/BUD+gbWs?=
 =?us-ascii?Q?E95/GMEVI6TEYYR4DmD12R3crH6hYcNOfB5Fqrv6ArluzhA0hUI004bQVCL+?=
 =?us-ascii?Q?rZ6HfFJhi/EVuxNhyl6P401OpG/f25ItlqnXZs5dmshAsFzbxYTmR1PDa9R5?=
 =?us-ascii?Q?2GAvnncsjx3oNwjNB0AuSgJz/MWZFA6x0NK8JuDxHymODfKindWFJgHfCQvN?=
 =?us-ascii?Q?viA99ZO4/I+m8K5b5PM5RjqksyvrpuGFJSZMkxW235RDeMF+8Ap7g3SqC81G?=
 =?us-ascii?Q?nsc1DXnN+oKI000X3njgTUlVN68YX6wTca8KvPElNSL0zOsY0b2DItj7y9YH?=
 =?us-ascii?Q?QN0mvGtWvCQsdxYil3FZ92LHazt4GaKHziBwXS0DBSjyrj8bNx53PDMIeEX4?=
 =?us-ascii?Q?+aEBcryGKSnZ6x/DhQQivmKN7/35JUl/HmwWDCs9lfc/8M+cGl9L7fc7TYXm?=
 =?us-ascii?Q?9b0GYYyTTHiD3+DlOCTz6yzJw8VSkFRRryvI4ZtDwiZHDCHUt1b+Vd5whi7o?=
 =?us-ascii?Q?9nWrEug1kGfX6PvCF15iNcpQ4k7HDsadJOBxIcCN7UwKhR4RWI4UfAt/iori?=
 =?us-ascii?Q?ymh0uzDuwYTcbUct0Tud5lb5qB+ETUyNUdPwSrFwhuGoeDSTCsv1tae6y7xd?=
 =?us-ascii?Q?KVJncOHfZSe1hxHAXvyJtFSS0Iqg6KZXFpKxj8Sk60w1FWB9N4EGX5s3iuAy?=
 =?us-ascii?Q?b4nS/2ZbJDFTRUwn9ej+MUUZHJ0CzHtfrYmpxCx+kcPAV6nOwFApJe9bXNaW?=
 =?us-ascii?Q?o1w6rFf5+YY3RhP6ybL0AhL6/B2tWpR0+fxTI6K8wt5xSeFsT1yG+8/y+twJ?=
 =?us-ascii?Q?rLsXHPkxOD77y67/pgtf/gp0DxRsg+zk+CSk8JvTyJMTp6RitplPvhCVuxhi?=
 =?us-ascii?Q?XASTxkDHl033FT0nUvxyhqEU3rZwO5EuZog3scknnyJuQ+h3qdN+wQLNbM2h?=
 =?us-ascii?Q?oMzhSdZ8anZojviSLcAEwswVEZGZGSS0NgD604Mb1Z7PsitBw7AG/4fNkSi/?=
 =?us-ascii?Q?Pjq06kynA78MIlZ2uJpTLtDhmosDE+YQHqL+L8EYre7hlkIRIgdJN2MJWcZh?=
 =?us-ascii?Q?Jr19XCbhuJspOyNeZi/MJ7J+YiIYVeVhuRRLQoDJ2tcw7TcNFOB1tjTZQMiq?=
 =?us-ascii?Q?LDFXb0yLaIcd/pJGyRmCSOG1ZmzMq64zYHC2cvgUwYBGKWvMRveymxul52qk?=
 =?us-ascii?Q?SmXRMrWCbYyJC3ccU2tN0vM6os1aw7ZgaGX8scYZmgABV3C+ghS+Ip9a+g4E?=
 =?us-ascii?Q?B9q8kBwE/sK3/upBQNpaI8ST3/TwDWN7iYvnO3v8eFOTArNTJBnOZ2KbXrIp?=
 =?us-ascii?Q?0Wde5VOd38xFcxRElrSQ/i4BO4xkBw/mukAFu0I+9YyPfc+OXgxT+J3hezLR?=
 =?us-ascii?Q?d6+ire9X6jNLLtlovYYmYfN01DGJ/udZPOi8whnpTw+vOB08MkK5DD98WPtP?=
 =?us-ascii?Q?iEM/7Gp/BZqyTjMYC1PNYZ0vexzNa9XQ93KOqcTh9hhIF8vfyLcLOkDufALK?=
 =?us-ascii?Q?aJWFF5lWSRwiNVRvb7A1cwosaMjpL669KfdZxBPTEarLRefTJ9iJpNMRTgn6?=
 =?us-ascii?Q?IrMiUlLU+5Ldp0lLyMmvsRAm8W7s6bz2VS3VBOXruLK6WZxb1LkjATVxriAl?=
X-MS-Exchange-AntiSpam-MessageData-1: L0QS9qZr7YkuRhzspHloB1I1D+jtLJe1Z4Y=
X-Exchange-RoutingPolicyChecked:
	Vd6K0cU6X7ZSZvW1my2a4WBf35eY1MouCAJEJ7AUXN+Y1C80ljfq81FSf9GEzENeuNl7tqKbSTx6OCOb+d0Xc8N9aLgd0XAAGGJ6qKfYdzFTxuxtpbN1JuSfiei8IAM1kndV2/BfL6OvrVQ0iIaHvz+cBeVdj94N5P+85+5nQY/lGGtSrUM5RvJ4BwD4jTJ9icSI5ETwpnpfU1wwfFwVmpxvHu5TQ2BYyxf/X1y6K3PaPiGp0pmv12xhm8ygdOjRLssCCpmTSTCkLVII/mH+5IQ4Q7g7xJqbBQ3qR5W86gGAcHZJlR4mEoYRPvg4l9hsBwEsekLY1cds6yMigZtfhQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7oyyPns95XY62jKEW34gO3MOeZ5Z1hmau/1rlZnCJ5ZNePPjO1lh9eRI8a+rjLg+lt/XMaI/er6OUgjGoBnyQ4/atxnDrh5b+eVB6rrcsDFK/Lhl6WQZh3Nr4za9T2eL11HLrYv8wypa0wCtohSYMjFiPPYTrJOdCbno/tzfGgBzfD3/At0P6V/R4zQDPg25IFB8HILFKhwECKmg0M9z7eXNJPBFl18KQnxn9DEic/LcFr3PwWekO7l49cbVtM3dOEmFOEnD2Bm16W/VR9rufECPMK17ORVRocSYpoIzSGnmTymjQMvqoEBvK5jthDHI9rNc7bLJ+kED1Hc2sOzl0CbzAGx5Lx2pTO38TTvRGjr7QxUxZVLrlvL+TtzvFP3cHGocGglSpSYSuk1LDRNA6ABwknoBBSjo+kYSTjBR/zzffLw6zxKYHSYRNuSmBkncrHrnSwqBGr0X5EsNjW1/kjUDAHd1XZsyjPBKF5r+RtAl5/tTUMQ2svF80PF/ZwBCRfYjEaQ1XhE6dn71OrMxWqRRTPkI0GasFQuQ/iGRQbhO7UrkWvdY18FIXz7w5VmjgG+QfR4DZ2DPVVrPtLbNLFvvnTa6gABWfjKyEXB+kk7eTzoxpibRYwsbBtL8YI2i
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38240b19-1b9c-4a9b-7419-08df2f791e6d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:15.8877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bl5SWfiLv21Q/pgA+7U+DlHr+ftbb7zhAAWk88IEShyxlOq7ze5JpAi/A8QZWywianvfD0SYOOI/0YpV1B8EA1Stc6oJU/gAmPB4/nT2G1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993834

On a zoned filesystem, the dedicated data relocation block group lives
in the data relocation sub space_info. Once it is no longer the
relocation target, it stays there, so filled relocation block groups
accumulate and their space is never available to regular data again.

After each block group reclaim run, move the relocation block groups
that are no longer the target and are quiescent back to the primary data
space_info, and reserve a new data relocation block group if needed.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  4 ++++
 fs/btrfs/zoned.c       | 48 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  3 +++
 3 files changed, 55 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 396783c49a88..47143c64d763 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2161,6 +2161,10 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
 	spin_lock(&fs_info->unused_bgs_lock);
 	list_splice_tail(&retry_list, &fs_info->reclaim_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
+
+	btrfs_zoned_return_data_reloc_bgs(fs_info);
+	btrfs_zoned_reserve_data_reloc_bg(fs_info);
+
 	btrfs_exclop_finish(fs_info);
 }
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 331313cf01f0..74cebb23e6ce 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3155,6 +3155,54 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 	}
 }
 
+void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
+	struct btrfs_space_info *reloc_sinfo;
+
+	if (!btrfs_is_zoned(fs_info) || !data_sinfo)
+		return;
+
+	reloc_sinfo = data_sinfo->sub_group[0];
+	if (!reloc_sinfo || reloc_sinfo->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC)
+		return;
+
+again:
+	for (int raid = 0; raid < BTRFS_NR_RAID_TYPES; raid++) {
+		struct btrfs_block_group *bg;
+		struct btrfs_block_group *found = NULL;
+
+		down_write(&reloc_sinfo->groups_sem);
+		list_for_each_entry(bg, &reloc_sinfo->block_groups[raid], list) {
+			spin_lock(&bg->lock);
+			/*
+			 * Only return block groups that are no longer the active
+			 * relocation destination and are quiescent (no in-flight
+			 * reservations or pinned extents), so the accounting
+			 * transfer is exact.
+			 */
+			if (!bg->ro && !bg->reserved && !bg->pinned &&
+			    bg->start != READ_ONCE(fs_info->data_reloc_bg)) {
+				found = bg;
+				btrfs_get_block_group(bg);
+				list_del_init(&bg->list);
+				clear_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
+					  &bg->runtime_flags);
+				spin_unlock(&bg->lock);
+				break;
+			}
+			spin_unlock(&bg->lock);
+		}
+		up_write(&reloc_sinfo->groups_sem);
+
+		if (found) {
+			zoned_move_bg_to_space_info(fs_info, found, data_sinfo);
+			btrfs_put_block_group(found);
+			goto again;
+		}
+	}
+}
+
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 20180934aff6..31d1fcb6303d 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -105,6 +105,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
+void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -291,6 +292,8 @@ static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
 static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info) { }
 
+static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.56.0

