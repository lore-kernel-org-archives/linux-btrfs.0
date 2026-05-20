Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C745B2DAFCC
	for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2026 07:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779262340; cv=fail; b=hm9GENQ/wc2z8poZexU/a/g7EuKJnvuZSTvEOK4XXWea8gCD3onzsFcQiPtrisxURPCghdlmquGQJRH6+3aEWrCCPAnpAkk0o4NJF+eyt4kf+l491sqlXjLOkM4hwymGpK4ElBifHZko9Y7fFGMmlLBUwFpxihjaKZTF8l8UuAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779262340; c=relaxed/simple;
	bh=xDTnqFjDAKXvtkZvVWv5JkIRd9BGyhC5a9F6eAAajHU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gBOX4KhzCo1yoUs7YxRdhCiwFw9NlFnBOUrmzSVvH6OlIwuocYE31kCW6gkhG3rbX1+o8RmPllW0eEbT32n7laL7tn8xCTSRHqzLB5vmwIdFi6YkqH3GZBjJb/ecyreHQ0SE5RzPC4mirQuA6hB14OmTsIP8MRIm1hs3O4nuLd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GCbgMhl5; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=snIvrR/I; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GCbgMhl5";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="snIvrR/I"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779262338; x=1810798338;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xDTnqFjDAKXvtkZvVWv5JkIRd9BGyhC5a9F6eAAajHU=;
  b=GCbgMhl5EeVTUuvcGHYppgXdQ91dKGNjgY2McxJ7hIBVKUoqCivgdgg2
   DM2zNjaG5GKYaF4SJn4VF+swCYJq8DpXR9Z1+t9NwStvf6mx6IMK2fFq/
   1qQjagTh6tzvjlJ9oe/Q3R3rhbDht0K3T27yR9QdtX6lyouAMh4olB4VJ
   TSBoLZKp55UDmxm2sR6QnnyxCIi4GQCPn/F+QoVK+uUahg/Famq7fUfyP
   T3yb1FJLcAvCebZ9QEtNt8X41JNRZba2Tlq/vr5yYfixDfu9mpM+9ZuNr
   EzkqLxCgZMCKtOyt31NZLAm8X3/NCfic54ZmLLXxKRIrMQ1UPMaXycho1
   g==;
X-CSE-ConnectionGUID: EKW3FCxmR02RxrAUucvuAg==
X-CSE-MsgGUID: XHPfSrZ/QiO8n5D0luc6zA==
X-IronPort-AV: E=Sophos;i="6.23,243,1770566400"; 
   d="scan'208";a="145810145"
Received: from mail-westus2azon11010012.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.12])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 May 2026 15:32:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lh4bSrWH2wC1Xv24nl2RrlFy4tYGTiSTReaJ6k+t1ztnR+S1MNKJeXrEUVS0z9McKK9z15JbepVAcAA0H3TPE/pBx04PQ4m9JNLs2EdAiEnSsmATgdOn+HCImWpFjZ8GD6TPIpdov8LmDuTonwd4G9MQBaXOF+y7ncZdW6vCZRg1hMZEua0eWEHPAfjR7GKQa8HaVu40sj6sQcyitfXaWhxrYa0Bemq7F4BQlxGiZlFOOYTYZ0KBqQ5tLXgekDmJfDD52QIJCmAntEL0qbbWS9CVcD1rRyayH7iUGBAn4nownfSmM+R6I5nn+6dKzyi+9Dti4Wzd04lOf+isN5DFcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXqLMkPnF5EDv65puPZIEJUMyOZYLAfgTaAgFMd5zG0=;
 b=Rw+QNCo+LrV5vYqKDFYuvXHdibCYVp7opXWqn93oQ3Ys7jBATIWSrx/H1E8WZeBH4WXjEbq8EwKjGB1LPpR/sR5kw3pyHTKjOUauAXeR01GRuU6d7cHZAUfacvLMcugzrECmIqjyqw5sBKb58s7kFhoutK+fpRRVK0KYhemNg9BHjOlPu0PRBvsWu8Dl8oV6B96PdLV2iTC8Qx/7yPGHfjaiF1bCvYVKFxml5EWsiG/kF1CSFpiVqr9+aNeGY1rOuHQOv4hV9skoR+uei7raNmpwN+TR0ifwgW49iHBDCwUtaCDjRVvhQAAaNv2wTXGQJpknb0qILkVCL82kikoAlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXqLMkPnF5EDv65puPZIEJUMyOZYLAfgTaAgFMd5zG0=;
 b=snIvrR/IhmIFLe3pbDG+dtkYS+4NGOkgNPGrWQGHd2snZbbXaI5/k4FoghREAt/Z0N8k40rCeUB8LxGQl/TuEr/4N+Bsu4lmNVuz1hyY3XX63+s+nGxunVMmBkAHanYcW1SI0sN272Xz+q0lCxaDAsDvf7FxY62e01vI5IzKKJE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY1PR04MB8752.namprd04.prod.outlook.com (2603:10b6:a03:535::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 07:32:09 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%5]) with mapi id 15.21.0048.013; Wed, 20 May 2026
 07:32:09 +0000
Message-ID: <d20b97b0-3d83-44e3-8132-edf8f2b7ddc7@wdc.com>
Date: Wed, 20 May 2026 09:32:04 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] btrfs: zoned: always set data_relocation_bg
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
 David Sterba <dsterba@suse.com>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Christoph Hellwig <hch@lst.de>
References: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
 <20260519154902.223445-4-johannes.thumshirn@wdc.com>
 <20260519232345.GA718937@zen.localdomain>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260519232345.GA718937@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:802:2::46) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BY1PR04MB8752:EE_
X-MS-Office365-Filtering-Correlation-Id: bb966b92-e41e-468e-81c7-08deb641e6a7
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|19092799006|22082099003|56012099003|18002099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	TMOBdHUB3oSdLIbBux2cNA0NlADwFlffd2h8C0swYyAqAwQs6AUdaY+JXuyslv92GsXL4UCCuFUhpGf/5E1JsuKYQH1jgL6Y2l2I9ePqnmmiBixWeCxMZ9UIyDrBqC4xq9McXqa37XR44XjxOe/c8LXL42H2JFvF9161yEYKmLk3DJg6AUKDkLdxw1spv0zlLHO5wsm+hBhFws6j2JXI+ccBLVtDrju7KiVhBBpcnG61b6qgZzpwkEFNYyqclBswOSBzKInvH6P+dJzk6360xZnsFyh30i1dMw7S3JkOtVSHvsg+hd5fbZ+xhDN8PllJsbFzsw41SOk/Gz7xUIZ924udEU22bSedx193Dq1Wd3Cg4ZyNARwhau4R4amfI/zp1E4Chl9NFRglDp36j1CA5OfZ5i17dcB3ebajhxinYNQNzWrNAjjp3Vmr33djcsS+zqp3wPIxsqAoopeB4VMijSIOlk6PwsX31fxS0PtbWZBa6+wylXXnS3FDYNzd4heyQjkeKAO4atMbuQApVhcOK9ZFrY+gBKuzOO0Zw1Xam0jg5zcBOlXX5Pve7JyD/4dGRTPWfi2ZTvECv+lee6CuXoPgPRZrawd+Sw/f6aEBeYJYRwNYbMra++daoWxqTqPvTbqacUgNujl+zosLBW2PEPwLRqWmQ2KI1OU9yCU1KzfkUO2BGevc+svupDYNIgpC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(19092799006)(22082099003)(56012099003)(18002099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3RJa0Z6K1dVdkcyQ3RiVmJYbmlqZnViSnBjeDVETnkvTEd2VFN2dHJNSmpi?=
 =?utf-8?B?QVNIbi9oRDJBaGQybjVuUDlIRTdrOWtuWDRWQ0RSd00raHlVSnNGKzNSNW9V?=
 =?utf-8?B?OHZYMHo2bzdLYit3dnVKOHc5am94U25uK3V2SmxqUDNKNUZBUUpuQ2hJWlZT?=
 =?utf-8?B?OVdRNkUzQTkrMmZPajlvdHFzcXhPSzJ4Mk0zZmU0ZjRRZDVVNHZpTWdCcjZJ?=
 =?utf-8?B?R2xLV29ldDlERU95SEc5SFgrS3A2NGFyNFBwbzZCdkpHa2pjUVlqRjhKSzRJ?=
 =?utf-8?B?MTZaNEJEUVpJVWZEU25VSW5kRmQ4ZHQrRXlMNDFvOW9TM0piKzBqVFc5OXQ0?=
 =?utf-8?B?MmdHKzJSZkFLd0J4NnNhQjcvMmNmYTFRTlR3dWVVV3hZZkRVOUZ3K0dYd1d0?=
 =?utf-8?B?OTRjQ1U3cWR6eVorNm5jNmkzcEQyNEVGNGttUWRKa01wcnVSU1JEcFJwQmpo?=
 =?utf-8?B?b2VMN0dRKzhuU0RmVXoyOFJEK0h4UTFXMjQ5NEhXL3ZzMnlOSDdDY3B6VC9L?=
 =?utf-8?B?cldmSEtZSTladWRsRnMxMkNzbllBSnBBZ2pNZFVuUXZSeThIdVUwdzhmTDg0?=
 =?utf-8?B?eW5VbUVVUFhMNGJtZ3ErbFdsa216VGNZQmJzSm5oZFdSKy9VYkM5bHVkZ3Nw?=
 =?utf-8?B?bTZMTVlTM2Viamw4S3pMZng4d1B1SE9WN2dvMjVrZ1ZWeUkrU2hjUTdISitp?=
 =?utf-8?B?azBYOGxGanRnSkVBUzVRWTB3K0V2N1dWeUNxaFpZd29DRzE4UjRVWndjNWZv?=
 =?utf-8?B?REEvWHRDZ3lhdHIxMHp2QkQvNUdsUmJYb2QxZUtqUXE4bHJDUkUrVjJmTUpW?=
 =?utf-8?B?dGY4bGZvbHU4VVd3VU9MRC9XVG9UUGdGNlNZTHZONzFFcUZ4K0VEZHQyOHRB?=
 =?utf-8?B?MGUvZDZxVnZiVTh3clNLR2NyTW4wdFlSVDh1VmIwQWlJQ0RweWtqYjJTdE5j?=
 =?utf-8?B?cEVwLzRBMWRTRXdLMWRERk1DR1BQOWNXdm9WZzlxTWwxRzdLTUtVcjFLTE1N?=
 =?utf-8?B?Mkw3ek9mU1VyN0dUNTFzRzkzWXpTRVp4RVFiNi9HQllNTStMajkwaDNmdHor?=
 =?utf-8?B?QkhlTkJQNFdBNkRSRWhwVVZwTERhWkpzSERjd2FYeWprenJMZGoxOTB0dGJL?=
 =?utf-8?B?K3VXeVRra0s0eFpZY05tWHkvWit2R1B5RFk4VDhZUUwvZUlDUWZYQy9Xejhq?=
 =?utf-8?B?dCtZdmxqazVpRmhmelpzV2puOGliTk5PbFdjVUp4Q2dNK1o0a25CcnBGeVZI?=
 =?utf-8?B?K2t0RFBRTW9Od0ZkMnYzS215VG9wQS9BcWlmNWVpZmx2SFFCOUVMOExjWHlP?=
 =?utf-8?B?K3NSWnBoOTBzeTk1bzZmRmp1RzNUMU5NN29uNFlBd0M1UWNJTkY2ZitTNTdD?=
 =?utf-8?B?VGloVGhQaTRoQ3lRS0ozMXlVVnlyMDNTOE43cHE1RUtWcEJJWFZ5c0UvSVVz?=
 =?utf-8?B?UXlzQS9mUlRRTEloY1hjNVFzaDNmdCtCdldnRkpnZU5sbDNoWlpCNnMzSVd3?=
 =?utf-8?B?eEpLQjNieVFFZEovTGhwYXFDTUF6cXZleEIzRmN0OUo1V3JxUE9wdGZzZnFm?=
 =?utf-8?B?MEVTcWYxMFdKTXh3Y3grQVpKaFBPdWlxekE5SHJxZ01zRzVVN0NiUkZWQVVX?=
 =?utf-8?B?enk2cmppem1LVzNpZUdmcERYUWlEYm0vQjhpelQxaWM5YUFUSmNjVkI3bzJy?=
 =?utf-8?B?eG5KZVFTNkNVNEd5TXNLWWlqODdHTnVBVE15VnIxOTdmZ0FRRjREbnNGVVMx?=
 =?utf-8?B?elVmVmRNcy9yMDVMdG5Wa2U2ZWFWVmZTeGdTWjJKQjB1ZlNML0hvWnQ1ZlRk?=
 =?utf-8?B?VTN3SktnZXFwNHlWVkxVR1JGOFlmajNUYlloQVQ4WnNRZXVBV01hQy9oUHhH?=
 =?utf-8?B?a052L0VTd2RFQk96US8yYXR4ZEJ2Vy9YZFRiVENINXozQ0xaVSsvR1NVQlNE?=
 =?utf-8?B?K01OSFMyUldhYVY5Vkw4WlVhMVZjVWlIdm9SSTFUYnM3WWhhYUVxSE5ISWdB?=
 =?utf-8?B?SjY3YTJFVGI0YmplVE9rSUJQRExnbDl2ellGNW1RRG50cEhBcTROS3dzMXhK?=
 =?utf-8?B?MGFkQlI1a21iRk1laXhOVlc5WkRRd25YOENETzhxZFZIZnAvWVpnRElkOHNp?=
 =?utf-8?B?ejFpMTRuVFZqd3VqakVqWmJzZjJ1U2RsUE9wMWZ1c3dyK2VlZEozc3lxdTkz?=
 =?utf-8?B?bEI4RjhLbkpmZHF2WFl6S3JSc3orTkxNSkdUcDdJbWVDS0NzRU5iNnlRa0Mz?=
 =?utf-8?B?L0VFSzlENEUyYkdHb293ZGJZZG55TzhodldjSnhCNndIZ0x3ajl6SVBQQkpj?=
 =?utf-8?B?RHlzeUI1aHpvczYyeVBucmNoajFtWmYzenVOZ0xCRDlPN1JjRDJHS2hjNitU?=
 =?utf-8?Q?r2hBMcpLom0iMH1g=3D?=
X-Exchange-RoutingPolicyChecked:
	QUgnSNZLMo8CmO8ITuwzNdHGmactBko+pvVuAkIVG+J/4eUT4elVga6Mh2Pik1T4fxkm+OCCxZuKW5KbjeBckMH6zNaYkESvuopn0s55y80PgCeQLkX5t1T4fIDqpqS4iHfDzKdYdql8ckf6ISO72iZdptN19gA8m0Oq4d8Fes+vG2iPeGFrHUq+1zmW9VvcXNklSwVjllbcQ67fV+ri3xLbT/eg/7PBITqknTzmWtmrMVq4wUn6yP9k4ljM6vLYHwqganNAQCzVAzwl8D6YacZKF94dgoz/O/ngBrBHeKt1UaInaUtyxIdyQ5V/ZPPoeC00Ycvi2Yp4XSwyvhh/7g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PYE3rHIPPiKfJfePJjeRiyf9KMI/byUU5sMShgotfxHxnZ0yDPnUqEnuEsncCqga8kfBq/osdAPoxcMMH+0EZEwJAz5SmA98QE4CJaOhtlOK12wzjfF30N8vnnOCadUVeq8wKizRu+hG69ZofBEJNudmm7QanvVxQG/HBWQVn3Rns8KdZdPgrue7ST5dW6fPoUHjH6YpaAle1Du4svAZeiC9hq1a4YCr3XW7bLLumsgtrq/3fT61DaS8jWUcXO4u1luw2x0RlnDesyot6XNP8bxelVrvcxUHacBUCt+zVsSC5SvPcArmfTn2IwxcKl1ucV496DjP8li6wJKd8KB5xUJDx4eOsum2X+a4P77MphwMKG/D6k0N2SkdHCTCXOcxzsuBz5qlxTRWShhO29692jzLYJPWw+Ozho0556GBIQbJX06SoyAZJiS0+G4XuFru4zoggY6Xa4odHggiHzIIHcp32JCDMaJf1VmoZa1xDrPxAEqyhEGVTzMJ1ARRno9xu0gbuJDmq2u4EcOt0D4Wb5pycIFqICNnr3SzAwTLOYdTfdgik1TjM6+RQ4b8q51aTBFF0A7+vracWdI2lGEvSbtB5oCVcRkZ70RM+CWUGRK93Dygh8oWTfvGHCqkrBDk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb966b92-e41e-468e-81c7-08deb641e6a7
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 07:32:09.4364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzRT0d4YrXfAYf68A5OhV91rS9nBYl1vCT4WeznlGoVr6abaX0m8B5psIn5p5xFosMIg7L4ngCpUsl67WojIoXNcDu0x3AIWQizBMo7HK2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB8752

On 5/20/26 1:23 AM, Boris Burkov wrote:
> On Tue, May 19, 2026 at 05:49:00PM +0200, Johannes Thumshirn wrote:
>> When searching for a data relocation block-group on mount,
>> btrfs_zoned_reserve_data_reloc_bg() is looking for the first empty DATA
>> block-group. But it first checks if the block-group is empty and if yes
>> continues the search, and then checks if it is the first DATA block-group.
>>
>> Reverse the order, first check if it is the first DATA block-group found
>> and skip, then check if the block-group is empty. This enusres that there
>> is always a DATA block-group set as data_relocation_bg in the filesystem.
> Can you help me understand why you want to skip the first one? Is it bad
> if the next real allocation just has to allocate a chunk? Why does the
> data_sinfo need a fully empty block_group rather than just one with some
> usable space?

I thought so as well, but I there can be a situation where you pick a bg 
with enough usable space to house only one extent. All other bgs are 
mostly unused. So you relocate one extent to the reloc bg, but it is not 
enough to free up the source block group. Then you have to allocate a 
new chunk for a new relocation block gorup. So if you're now  out of 
chunks you end up with ENOSPC.

> Now aside from the general question, I still don't get what this change
> does or is for, it kinda still feels like a no-op. Can you be more clear
> about the case you are fixing?
>
> Previous logic:
> if non-empty: skip
> else (empty): if (first): clear first, skip
> So you skip until you see the second empty bg
>
> New logic:
> if first and empty: clear first, skip
> if non-empty: skip
> So you also skip until you see the second empty bg?

The problem I saw (and I hope I recall it correctly) is:

The FS had lots of GC activity then remount.

All the non-empty BGs where skipped, then the first empty block group 
was skipped as well (and used for data allocation) but the drive did not 
have enough free zones so the FS could allocate a new chunk, resulting 
in no relocation BG to be set at all.


> Is the relevance once you loop around after allocating a chunk or
> something?
>
> Assuming I'm not missing something, I think it would make sense to simplify
> this algorithm to something like:
>
> 1. Try to steal the first empty bg.
>
> 2a. If stealing succeeds, do some arithmetic on the data_sinfo.
>      If zone usable is 0 (or < a chunk?), allocate a fresh bg into
>      data_sinfo. If no arithmetic could ever work, do a second pass?
>
> 2b. If stealing fails (no empty bgs at all), allocate a fresh bg into
>      the data reloc sinfo.

Yes actually I can just skip the whole 'first' step and any data 
allocation will create a new BG. And if we're out of zones to allocate a 
new data BG we need to GC anyways.


> Also, when we do have to allocate something in the reloc sinfo, I don't
> really see the value of going to again: with the space_info set to the
> reloc sinfo instead of just setting data_reloc_bg to the freshly
> allocated thing directly.

This is to search the newly allocated bg. btrfs_chunk_alloc() doesn't 
give us a nice interface to get the newly allocated block group.


