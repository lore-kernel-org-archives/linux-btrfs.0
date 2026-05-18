Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B10637883C
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 13:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779112670; cv=fail; b=B+UiAXINDivE7ohW3t+1MBvuwfH3LUZgDafArCJ1FkUCVU4oPGj+uAqDl9vkH7ku3QFVW8WBpPFFvs8Qc+Ssz9p2sGEDp1PTZeUvzPjRSlqyd4NSgKXUi4+4IAJTI4g3KvaYb/7X4D6fFI57AZcngrrOM/gNo8TBWTXPZUbtbd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779112670; c=relaxed/simple;
	bh=c8Cq/JRUvsjTrq9UY6afTLW1zho2YMHBeGLHKKCtixg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dOpoGa1C6ssiI4z280OVJeyoGhTVEqImCZzO6IjE+hTLfuGsdJmvt5o+A+bW5Imq8a/f5Jap7dUpVwA4JDZdFeHQhNinzaTX+3Qa6yYmVNCJRMmCA+VO4kBOlKVacU6ch3IhHoO8vY6dtQ9eOgOfJRJkjy82colTBMfpdPzuGBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mmksB97Y; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=zVSdeZgs; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mmksB97Y";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zVSdeZgs"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779112669; x=1810648669;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c8Cq/JRUvsjTrq9UY6afTLW1zho2YMHBeGLHKKCtixg=;
  b=mmksB97YdNVWNpDBeR41RDgw3I+SzoypxoudHXwDkmIIEqtNti9OuxnP
   6HFi8r/noLvKzHDZ/OkPbE3lLEkFw1RifNuzTf36ugNnDhyJ6hDIUI0E3
   vbtK7W0njpYCu5VZ6BeCbVyG9hDOCbgHZam3XrrgQv4mWolbYNzB8CHAg
   Bxlgb5QR/jITEId7Y8ac6kSWTTVqqfud0HjrRA8Uk5U1jZurn5jNNE5Fk
   ZjhOxtglTXvNW8fUvMTeR0eYboGQ54tnJrupGUsQY8p4UO78hsZZBN+5G
   D3Rfif7wP1cF7IsgD+hbJYAGbAS/RIsIF8uJVaPPrvRJBPGqe0gva2Hq4
   A==;
X-CSE-ConnectionGUID: tqmJgOMLRIitTETC4ZCLSw==
X-CSE-MsgGUID: /EmOO5azTem5ZmUmzKXn2A==
X-IronPort-AV: E=Sophos;i="6.23,242,1770566400"; 
   d="scan'208";a="145678052"
Received: from mail-eastusazon11012043.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.43])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 May 2026 21:57:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O30tqlu0YTanXK5bWf5yZKLzZdOPuvsMUBa22JX9afhl8+7yj7EurFGxjIVZL3N6KNV+9hC7KJ3cHJf03w5i64g7LdsKToEu0anjokoDmkl6qiPgCb6KDC1N8q8T1MTAHFQAzE3CgU9/0z37bkF5XoNv0fQyM5M0dVsRtfZO0vV8ZqxkfpiXZx/b6eLpG0q1rSQerZUingNzZVkwbo0BjhiECNA3t9yy8JZscH4uozBAnXaVts5dTPR8LbGIPXbMfdrSqZB/GRDwgqilPRJYcx3Kej7fp365xoaShw2qhRkBf8NqIXdE57ZX8jzZaijZ7Y/cbAZd9EGqoV7sz+o8UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EpEe818LARGK7K0ndTX9RAE7Sfeqc6ntmWh/WoeOBEQ=;
 b=QTgMizwGyLrREyhlEvZ7QDdhVHiCQE9ZBEIIgkknYO1FD9NYD03iVkoqF9AKkkOLx7TEl6sosIkQrULzgzo/7dpFOH6uaP9DQY8scH13gMp+ROSmbZmpc8T/y4xC7z3+TgF3Y87sKN51ICkoH4wiF2IAlVOu6rBwS+cMfsrq8Y4T8PsBf6RBLtKnLcUfwF1vvE1fpWEXCAxLzKwX4fu7IZJTsJQPnRwnyCEiOMjwVBBWvOLA8yID5SfdxCTp8G1GUYRi6ZSo7dQDkLGDc7RNYGDPtvHaoHwxdaMs1B7SUFw5ykbwWLnIgtoU1//lXs70iUc/c02TjVFuwaKSSKIzfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpEe818LARGK7K0ndTX9RAE7Sfeqc6ntmWh/WoeOBEQ=;
 b=zVSdeZgs+GgnKa/gpIKogIy5dmOmWohU5zy61O6vLpDMbuToagbG9UcrWMpAFfT2tk2hOQi5o5mr0qSTNEIO3MDsJojZddq3rKr9VPmSEoiIYQQQPEw5Fo5R9LojFepxkXludZNPTmZKGB0QiNypsfJOPiCkdE1hqJ3pScXtU0Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB8527.namprd04.prod.outlook.com (2603:10b6:510:290::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.24; Mon, 18 May
 2026 13:57:43 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 13:57:42 +0000
Message-ID: <0403023c-2664-472d-8c93-5965dd63f0f0@wdc.com>
Date: Mon, 18 May 2026 15:57:33 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] btrfs: zoned: fix deadlock waiting for ticket during
 data relocation
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
 David Sterba <dsterba@suse.com>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Christoph Hellwig <hch@lst.de>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
 <20260513123445.43197-7-johannes.thumshirn@wdc.com>
 <20260515172604.GD1197064@zen.localdomain>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260515172604.GD1197064@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0041.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::12) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB8527:EE_
X-MS-Office365-Filtering-Correlation-Id: 078ddcee-4ae3-4921-ffca-08deb4e56e70
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|366016|376014|56012099003|22082099003|18002099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	4Y63xwzuhAIni0TDBRdufPqYw5FkVr5pnvMUga51ca4sYLqpBLN9ni3F3cfXL5yRTcZtF1zrXdR+1MgEc+hA3VEr5TkTuqG1TCkir3yRGx667arVdlTt+fctPkaPb/VbjxbT/6NOp6IRyZd5Q8fVCr4riBBySvfUhb92NAMt9W4P2aeyMsq9qdaNQeQlo3C53+mr/oK9u8xCaotR748Y37KZSlVuaijODPTECAH801bl2V/NOuFE4LcJDu3vW8y22qH0yaQmroBVdIWRmeFo2eriSap2ldDOFglMqP2jhPz6IxnhjOcJ7bEmFoec+B6zdZSgpiudHU6ZFj1TP3G1DD1OflCzPE1a2iT5BXPe48GUEn6NAOW/itpMTelMd6NVasCl837SC1gaT/3GY3/epqPqPzY8o2n3RAbcuI+rp8lZCudAc00SDuqdRRcM/89wfjwNF0Ri3Kl8XTZX/Xc2OeDAkDpLLq0Hi1yqSujleWgPScOkoCOmBo8cOxHge/mQRvVOIuto0pd1ONwN0uUR6d+bk6natAxSME4NJIZd8A6o7KOY/M9Dn7Ov0LneFR8EQKI0JF0BH8UTye1hJ668pOjWcA18j01QGDtXXl89jdNrYqjlSslTvYvYsCfiyCHOJ1h+oRMnN6lO9FenKGgCdAe35/08562q4tD2Y7g37hLcRAfldRtiXeb3Ml6E+kgI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(376014)(56012099003)(22082099003)(18002099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1BrSWZKTmpyWmFZNWVhZzVyV2t1eXJVbnFIaFJTb05DcTczdXVKN2dZNWxD?=
 =?utf-8?B?WjlkbXUyL3dURTNIMUk5VWNnbThoRi9aZytTNlVyUVEyQTJYSFJFdXV1ZzVD?=
 =?utf-8?B?cUQyRDA5V1krZW1idzhUTUkreXYrRzRXMFZOeS9lYmUrUVg2UWkzNS9aUG1u?=
 =?utf-8?B?QWtaS0p0UG9hV1kzWWhkM3BhdVg2VmRGU05HNnp4Nm1NMm1VMDh0cnU4M2k4?=
 =?utf-8?B?QnplUkMycjJaTTlRd3ZtZ2tFc2dXSTU4WWszTE5Rd3R1SXA3UVUxRUt3aUIz?=
 =?utf-8?B?dC9sTmRZeUVrbkNqdGhFaHBKbVhmMThINEwrYTdjZmVLZ2dZZFVyUm5DSUlZ?=
 =?utf-8?B?S3lRWENZYTF4MDNlOHFrZXFLWHJWOFIxbkNkWCt1dU43dUI5OFhGTG91Y3A1?=
 =?utf-8?B?QWdoc2h6U1A4WllyVmlyaUYwL2QyVkxnanZjTGZIVFRVUHJhRXpvNkFJMFRV?=
 =?utf-8?B?NldyU3RBYWMwZ3ZicTNaTFVMNG5jS1JId0k5ZHcvSlcyUjNxMkVWQ1RIWk4y?=
 =?utf-8?B?TFdNZFhLUFY4QlNQL1poakFBT0FSdlc2K3ZnZy9YZlB5YkJYcGlUcGtvMlpa?=
 =?utf-8?B?L3JqdkVLTVpxa2NRakhMWm92STVJMXZrRXdwbTVhdzV5UWZudXNhLzlZLzg2?=
 =?utf-8?B?MWZZTk5XV1V5Ny9ORjhlMjdUWm9sVk9qNktYWTVCYnNaUHNJcmtlY2R6V0d2?=
 =?utf-8?B?dHdoSGVmZmZRY1VIdThtdWNqaEVPMTZxc0RMVDRwQ0E5bVZ0SC83blFVdDZv?=
 =?utf-8?B?ZjFZakN6WHdrMjdWak1oR0czMjQrNmJ0am9vZjkxdjdDTWRlL1ExcUxpUmtQ?=
 =?utf-8?B?bVRSaURmQ3JxTTJzN0pWRy9jMllwd1VwVUJveks4TGVUQW1nQVZ4djRMSnNI?=
 =?utf-8?B?RTlnNlFNYUtlLy81YXViZ1MvVUxjcDIxdnFqblkvNWVSeXd0cS9iejZ5QWs5?=
 =?utf-8?B?STRsUVlXclZ0ZW1zZjdaYk1EeHZNR3MwMDlsdnRWOU9XOGFqK3IyTnA5b1Fh?=
 =?utf-8?B?MnREaVJ5dGc2bnNtSFpjemludmU4TGdCTXErdmh5amdVVU5HNEtGdllrZno4?=
 =?utf-8?B?eE5vV3p0RW9OSEMzWVduS3VFSktZWllzeDlmM3UvMXJGTkRYVGZCZlliaGFy?=
 =?utf-8?B?NHlYQTBtQzJtUlV6dnQ4UmZqZnFQRldSWXRMQWZYeUxLWkdVWjNQYXlXOUFM?=
 =?utf-8?B?YXBxQmQ3Ris0S3l0dG5oYkh3NFh4SnZta01kenQrU3h0Ym5vMGM4R3ZsNkkr?=
 =?utf-8?B?cEVEcHV5L1JlMFBYNCtvWUo1bjZFd2VuTk9oT3ZFbEtuZU5lcDJBNzFVMDAv?=
 =?utf-8?B?NE85UzJmcXQ1cnRVNFgvWFF6VXgzREJ2RHFqaDRRNW9udE9EYlZYbUNRUHZG?=
 =?utf-8?B?RnU3NXZBOEswNGRJM1BhcS9oa3NKd05IeGI1SWZiR0pmV2pQc2VZMDQ0V0hF?=
 =?utf-8?B?akZGeFRDdE9NRDRENThJRjZuL3ExYk5WK2xSRjNqMnNMZ25WUVhzcEI0Ry9P?=
 =?utf-8?B?Tkt4ejFIZDZvM3BDR3MzSG9BWlBkRGRmd0NlK3RWK1FHMWRldm1WV2Y2ajV2?=
 =?utf-8?B?MEhITGl6UFVtLzViazk3emNUYVl5eHVDMWc0MTVodko3SDVyNnVwN2lOc0xI?=
 =?utf-8?B?ckhpcXMzS1RYMkZubEFhbmtxWk9jbjN6bXVYb2YxN0VWWnBrSGlURWtoTXBj?=
 =?utf-8?B?enRMVUJqMzhYbE1wZ0hlWXNRSzhtclpoVjIyWklra3cwMitRem94dm9zbFpl?=
 =?utf-8?B?WC81TWNyYzlLL1l5S1lhdEZmK3ZxSUtzU0ZabVRDVVFBUFVKL3YwLzVVa3dx?=
 =?utf-8?B?L0xTZm4wN3YzTUF5RUQ4Q0hEeG1TTUtKMzRLUk9ZUUdHSkg0RURnZVRNMDJt?=
 =?utf-8?B?eUY2bUtFNmVyRGVqQy90eXNMa2d4c0E1ZEUvajJWa3dIVTYxQ29ldlZ0Y2tD?=
 =?utf-8?B?ZU55amtjOXJScGlIVjNEZ3V3MytIREYxV1pKSFg1UGZZT1J1bU41ZXQyRlp1?=
 =?utf-8?B?cktHRnRXSUtxRGg4NUJpcG9rWkpUSzF2WVkrVWM3R0FqN3hkakh5L0huNHY0?=
 =?utf-8?B?dDRpdzZKV0ZMcHIxZG04Nmx1Y3cvUGJzeFhYL3NXdGFRVFA4aFAxa0F2cFNR?=
 =?utf-8?B?WmFHWTFjZWlodFNBejhLRVI4TTg5Ykc1eTRNMXpvLy95eHk2UHhRZVpSblAz?=
 =?utf-8?B?cE9RUlVhdm9PaStIeFdkbUQ0WGM0U0s0U2FpSVdHdzUrRWRlcHNjeGlwR011?=
 =?utf-8?B?cWt5VTBzMCt6UUNSMVA4RVF6ck1vM1k1cUI3clhuYUlDMEhLYmVYU3RRSGJa?=
 =?utf-8?B?bDExYXpFTnBabXV3Q21CdjRqYUw2eUlLWThvV2VrVEZzQXVxTThyaE01VTdn?=
 =?utf-8?Q?TuJdfMNWAjWxKp7A=3D?=
X-Exchange-RoutingPolicyChecked:
	egAiAuOBBHfVdm2XDAW7fJuBZoxLnA30orBo4WvDPsjteYjTLCqe9fQqBs0aNSfxPvYqBhM3+eyuEam6siQ3rllIrYkEum3cxCwWrVfEr5cxHOcPiCIWxmFe5FKtc6S8d1eV0hGmqS9X2qkRWL2ZLwgoOVhCcgTr8Ar3F59/ptmJs46N8+i+ml97gXMNwkDJkQc4xddZe0mTjPc8j+VRNnXEiDAn0KgoP+KacxEBbKHSI0M96Z6117GFbw6JubtFG/jSbdgGINW6mcqZZekSXkVGjA/sndw4kbGwoCxP0BA0RL3ih/XPlAAI3norNPNkryvsDzsyMnZu1sbHm0CUkQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ASYuW+0egWPI0zynn5OVBlYb/68YmvhzjUBBNPAaV1kVuKRoCdfsPLw6r7PxewBbc6NEiqItrgaV8UoiuAFon+8fcP+qLkhJTDzFw9L9lQmb2NJuVW4Qro9FOLTQU9VopIcTFDGBGWIKNH8kDZkW0vHz14LQmMA6a2icrArAj/ru92FqbyGUcxeop3q0Na7GymtepfLcEk/E+Wx2CMRrWQU+E9GdmdIn5zeKD6+FuzaHOByqqyJio9qX9SOj7uddK73xRfE9Gj33DFqtJa3BWc/PhMvZJMygvwdJAJ4LwRJMVjGlVncCF9KEPwOTZiEX+pkAABmTCEQmzS2hjNzdz5vuVonTTbdzM0MMgRlGZlV9tJiXFlE8Eak7+mOX8E7iUTNLeo1aymuhv5d/etvYlKgnatdYUG0kaKDdDk741ic9wykz4zr8p3Ak97u6V+cvDqttHzgI5fvyGlDc3lStl+Uo1u+Uk1DjT9vbeKqDsemuAp1g4PJrCC5Z+b21URu6EBRhau3XSQ+FyymgINawvv/EC/HNNAZHLbaMqFkEX1FIupybYKnQ2Z1jJ48XEmv176CjLiqBh3P8GHvbPfTN12iE+es3rGg0zbMKvalqQMyzwLvBc8SdvcGyJnzr5hOs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 078ddcee-4ae3-4921-ffca-08deb4e56e70
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 13:57:42.8783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2L6uPAIo6W6DK1FnQiAzLQovk4Nf6ASlk9IXy9cN4VlmyBpdRFeCdIu767VPS/suKjhRg4fdo/+lys8yLk6ZPTjq+lNDCZP9RpGda6eISCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8527

On 5/15/26 7:26 PM, Boris Burkov wrote:
> On Wed, May 13, 2026 at 02:34:44PM +0200, Johannes Thumshirn wrote:
>> When performing data relocation on a zoned filesystem, BTRFS can deadlock
>> in handle_reserve_tickets(). The relocation process is waiting on a space
>> reservation ticket that can never be fulfilled, because the relocation
>> itself is the operation responsible for freeing up that space.
>>
>> Fix this by introducing a new flush state,
>> BTRFS_RESERVE_FLUSH_DATA_RELOCATION, specifically for data chunk
>> allocation during zoned relocation. Like
>> BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE, this state uses
>> priority_reclaim_data_space() instead of the normal flushing path, which
>> avoids re-entering the relocation code and breaking the deadlock cycle.
>>
>> In btrfs_alloc_data_chunk_ondemand(), select this new flush state when the
>> inode belongs to a data relocation root on a zoned filesystem.
> This looks good, but a general question: are any of the other data
> flushers valid to run at this point or only chunk allocation?

 From how I understand the code, no.

> diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
> index 24f45072ca4b..f2b8be2af5c3 100644
> --- a/fs/btrfs/space-info.h
> +++ b/fs/btrfs/space-info.h
> @@ -77,6 +77,17 @@ enum btrfs_reserve_flush_enum {
>   	 */
>   	BTRFS_RESERVE_FLUSH_ALL_STEAL,
>   
> +	/*
> +	 * This is for relocation on zoned filesystems only. We need to use
> +	 * priority flushing for this, because otherwise we can deadlock on
> +	 * waiting for a ticket, that cannot be granted, because we cannot do
> +	 * any allocations.
> +	 *
> +	 * Apart from being specific to zoned relocation, it is equal to
> +	 * BTRFS_FLUSH_FREE_SPACE_INODE.
> +	 */
> Should it be named ZONED_RELOCATION then?
>
Probably yes, will do in v2.
