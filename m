Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968F23A381C
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 10:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783591363; cv=fail; b=TLy/Ml1BiWzooE4fW7JxBbDD8ZtTDx303xt9zm+Ix/PSmVBSmov6RjoHNHw0x5DWr9G5XxRg/kaBHRMAUibZJA9zOSg+uAf9+EYzl8Aj2XlAyJYQaiVGAvQG+VoKJRKhe4gKRRA5dYMCFSjWJnAuJiOr7wZVfOutPPeY1Gehrjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783591363; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eLJ5oot2tSoSJIvIyZjJT1sPzGyJqKzFiAls/FZn3mmb0V/ex1JzjNY0zMUWWwGo2PRFAN9hwcuRqLQnmevqbbOjm3I5eh+gkxkJo45oDRjnCHD6SvIHom9mprzuKnDQZ2XlC2AE27rtrZbs/YTtiD6F061gr5bAPwQKwDIFKfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=r8aExDgz; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=FtDjAcOx; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="r8aExDgz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FtDjAcOx"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783591362; x=1815127362;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=r8aExDgzvBm6G255DLe8EQt43oOg5Y7fLKxN09whwz5z6k3feLjXuDnr
   FSEBOe5M1FjBbolCWJXjGBt6vGP/QW8Ns6XnYx9cNnyCDUqB1lu0En+t2
   av/mo4KkoKi5eKlEoC2JALDXdqstA4s4RpQWPjfbnnK1SP1O64mpM7ObY
   o5F0ZjhSbtAYttug6c01H5tlnFC7NtvQRWXoFJqMZU2BDchqNYhHAHsHs
   jZZVMvl/rnGLhg5iGk/K9vOGB/XHkusGqeDxQjVdjKIjTpxI4hNMBD7WP
   cdm1NQWXJf9Iaj0uttHZnYKR9ACPdrDkiYIvojWvVW1UsN4xwrRy/4YrH
   w==;
X-CSE-ConnectionGUID: RYrBIHiWQgu9dzmhUU6ReQ==
X-CSE-MsgGUID: t79nJ9CbQCmVfjeUH4jrYg==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="150390660"
Received: from mail-southcentralusazon11012002.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.2])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jul 2026 18:02:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QBCak9aZOqDNzCB2FaQ3jZiM+R8RgEbyxo8BZwuIAWYeM+U8MarHDct9g8vmhs1px0nYCNhZa2v0tUzapjkjI4SFZlTuUQg1b24mKJezfrAYOl3ZeUm9wBFWFvsZ4FYOQ7fPX+YU58mDkPf7BrV3t0iG6RQcclmJN+HSRw1rJ4V6cTAir38dbqn31Q31vx0xPKqmJ0CRt6MWQEWQ7wp8mCuP1vVALcXbemIFFfTKGa8XNb2rG9Fm8ooPtCaMY/9o7Lz/5pVcE/GI3uKWjvOr+cCyzUUgZwfk/CyRHe5rBz4p9e0s3qSA1HOlDI8T7t1W9FA5L0S45EUd/jDrpsQsYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=Nhp7vcRzds7PHB6JHrTTEYguI1YnYuUPomZgiNTUybaWtvFLZrqag7W+JCSQYzyFDvmMsoFwdNXhl23+XY540PSoFonHhiNongNwgMpUTQ9Y5Kn0Nd76YHGXTvaorf9zISJZdILWrsskXKK05fZWJb/JsO6RXaB6Gk/91DMzrWaZrP31hD7GzCFjigmI7ukUb9Agy66/+anaSG4BHSZ1fJArikSolL/cDnkhzZxxct474pY2veHEFmW45AwwRAKx58L2z0a5ZkpBx/QIEulMghTrzByr3HXleybU2MkibUb7Bv/hwiJSqfp3IgGnIN7KjcaxPtmc2bNgey3XSIg46Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=FtDjAcOxLS0uviVm846uM5Geq9MlmIT/N75zgUzs/toHS7jWfspwXJoZS0c+j+xXrvRr+ASrHX+jsqnM/jGjigiqWzmsBIjmJLP6doe2FSISruMUg363mEjNUKXkjQe7xzhDvORi3Gx2BuxsjkSW3hFzOyUdFk7LjZiRsIdrk1g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB7079.namprd04.prod.outlook.com (2603:10b6:610:9e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 10:02:40 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 10:02:40 +0000
Message-ID: <89ab93f6-ff0b-48d5-9ce5-14e5a0d33e34@wdc.com>
Date: Thu, 9 Jul 2026 12:02:36 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] btrfs: remove SCRUB_MAX_SECTORS_PER_BLOCK
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1783252371.git.wqu@suse.com>
 <24d88759a0ad75c151decb7743fae65a6552f3e2.1783252371.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <24d88759a0ad75c151decb7743fae65a6552f3e2.1783252371.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0166.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB7079:EE_
X-MS-Office365-Filtering-Correlation-Id: ebeffae2-b8da-412d-1cb5-08dedda1360d
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|366016|10070799003|376014|19092799006|1800799024|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 tX/buWok2BAS2T1opxFda1PwZNuUTTlLQIS0qA4c4PNUi8C+aouFzgCq/A3369muyVHMFMxYvB8TeUGJeGe7/MyrnRZqdTM4TPycrhvXtWIzyMwTDBkyU5pBfG00riCQX3FpnxBuriKGF4UUcaxj6aOyR6pE3BXH5irVGVOzSByqsHNxjmBFiXO8dDrOsdCVbzDKfj4XT34rPvNEJxd6StQtwklFlCpyvkj6XSBHfdpmxnqje4pk1OBQSfbv9YviUv7o18vhI8DlRzBxPasaSRh5x8amIn1Pza5n98gW7+cy0yaYksMprQl8W6tsruihP8cZNXghkok4gQa896AvW0r52BYfVe42gW3g7B2che9HO+Y+lB9LVaJX/GrUtXT7nCtPoGHJzW1nI8rNGUAc8BMsz6gJl7FwVN0ya5s5/9jAJ/ZiZliCaVJyuEmwIBGIGGxfTlEwo+i37HDA4F+S7guxMw7FtBO0YZGn1HAs9g4gYMD7pwny9oHJEeNvi5EtqqLJ1gxP80Vpc/Xe4bPu+JJr4PfK4GXjTo8u19MQl29EnX/Uh6mndzHw3C48jgFxtdwOmINYIlwmnhocsCsJS09s7o54PNIQlSQnXgsaKA6WVx3INKOXWh8Mz7UwJn+OWoX1yA1VN2QE5L/gTfmWm4FRyr1/PmQxTqXi8tHklAQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(10070799003)(376014)(19092799006)(1800799024)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?MHhGQzAyclZrWjB6SGgwVi9GRjZPMG11Y2xqRDU0cTZDYmhpQlVWRHVZcWor?=
 =?utf-8?B?NU5mbWJFWE16NjQ2T3VnT1ZxclhHN1k5L2h6K00yZFZ1Zi9PTGdjejNjZEJV?=
 =?utf-8?B?MDVNUllSZ3FEakwwQ00zWWUweUMrVVcxVW5wUytHNjlQQnhsMWhwL244cHJU?=
 =?utf-8?B?OGN3ZE9zL0F2MjN0NlN0TmtZNzQ4ajUybndXTFdtOGZpQTdjZGRQdHB3WGRy?=
 =?utf-8?B?Y1NvRWdTZk8raG8zZUszWTAxSWh6Y08rQzNGbitvYU03NUlMQy9sdHBiUS8w?=
 =?utf-8?B?OFk2ekZxQXVaMnQwYkpnY0l3WDlYenlranhXbzZ5aHl2S21ocE5HYjhUNW02?=
 =?utf-8?B?TVNPdDRNdEZjamdPU2VWY2xaTFNWYk5Qb0FVSWJlTjM4ZTZCaTBWYmZSd0dw?=
 =?utf-8?B?MSs1bnArZDNyVWg1bUllM29GQ3NVY0x6YStzZy92V1JqUmJaZFRlSWwrL3NS?=
 =?utf-8?B?YUg0S21aZkoxd1hLMkFFWnlYU2htM3RmcFM4SUhkNlhuOEgvSnFWcGdnZE9y?=
 =?utf-8?B?dzRFcytlVUNBYndKbUk4NGtQV1lrRzhKWndvT1lMQ1ZSMjBXcmJYdWpzbFl6?=
 =?utf-8?B?KzR1a2dsSWxITTRIN3Y0bzVwMzNUUCtMZVBpUjNMaXA0WStUcGMremt4c1Rw?=
 =?utf-8?B?Z3NPUWkva3oyejZJUytpVkZKREZhUUFOaTM2Z01HUVNvMkhlYVplU08yWWtt?=
 =?utf-8?B?NUdSczRXcUZNNVRXdE9KRUdnN1J1VEN3VEVYV3FNUjVQOHNvV0hsL3B3ZEcw?=
 =?utf-8?B?cFFOc0QvZ2Uxb01JMEd3bUJhbVFCbTlWK01ibURVZUo4REJMbkdYL1VYZUF3?=
 =?utf-8?B?SENCR2p4WDF0cXRQbXBDU2FzSENWUzZwRDFIVkpWbDdjUlVqcEdVZmtZbCtG?=
 =?utf-8?B?K2w0OENjUGV2R3ZKS25kMzlvOGtWTytvSFIwclErcm9KVlhHL256TWVPZ0s2?=
 =?utf-8?B?cGxxc21KYzdiRFpacngzMjhGN0hmTjFmSFpkUzhLUG4wY3ZHUTJPdVVTQTlG?=
 =?utf-8?B?c2dhenE1NXRWd0owKzdHWG1Ea2lHdFZZZ3djeTRTRERiaE5yVXkxUWdYdzlC?=
 =?utf-8?B?WjJFQmRhdWVNTTZtQlF6TGZzemI3eTZ0ZmdmdmVsSHNqczlaVlpSMFIvVzVQ?=
 =?utf-8?B?djkycmJmYWdXZlhoUzVzZ3ZwUUtRbEZPL1JqS2oyN0RacmpabytDQ1hTZ05U?=
 =?utf-8?B?M05GL2NxRFZJN3NYb0V1c3pYcENueWpoVVpVU1NseUxjR2drUXl6THpkMlla?=
 =?utf-8?B?cndmWFVjR1g0MnUrbVNxenRwMU1YVU9xUEYxdyt3YXJ6NGhMVFlLbXpGdDhY?=
 =?utf-8?B?OU1MM0N5SDBRRkhzUDg3N0FwbXN4aEZyQjNIdjB4NkhrQlVrdGMwaDhjaGRV?=
 =?utf-8?B?ZVRCOXYvOUowYk9KbVNVOE9BeFRya0RlVjdacGhqZlRhb1Zwa0pYc3RnWFlD?=
 =?utf-8?B?a2M2M1E5UXoycERDNC9Ya2htVFRxdUFyMmZHb0dESTlCcG5JTFU3OUFRSEhn?=
 =?utf-8?B?WENWdnJQS09SQy80eGt6cTd2TUNnZ2JmU3VjMi9lYmtqWDloOHdtU1VXUFZ0?=
 =?utf-8?B?N0xnV3luVGIrSE83VE5YRGJPY0hIWHRFZTR2VGdINS96V0laayszdnBGTFFD?=
 =?utf-8?B?aXkzODZxVklZWXhvbkx6QmlENjZ5WEpabTFVSlBhNC9obHVPL01TVXFoQWQy?=
 =?utf-8?B?MlJPRnh3eTVCaXNzelYwQStZQjFnRUdRakUwM2xKYXdSR3VjaDlTY2MwOHJW?=
 =?utf-8?B?U05lT2hIbHZKVGdBZUhkWXFhWHo1a21DMXFaM0o1M1MvOWxNK0pyUVd5TTJy?=
 =?utf-8?B?cDR0MEdQOENoTm9ld1REWEh2blZNTmNBellXVjJMNGFreTFxclhaWHdjUFl2?=
 =?utf-8?B?cEVBbUFRdWlyeVFGUTk3cVk1bEVKU2lsZHZoYjRQQWNHZVlEa1VVSlNMdmJT?=
 =?utf-8?B?bXR1T08zdllqT3VjM3p0QXpvSllyOTZOQWcrUDJydk1VZW1QRW1WaDZhZ1NT?=
 =?utf-8?B?TDZ3eWlUcVJDVkNMMk5RNTMrMGNEOXJKYTd5MXg5WE9qKzl4MTMzN04wM2J6?=
 =?utf-8?B?cjhyMndVTFlnWFBtZU1iTVNtaDRtcnpEQkNwVEpPY01GVTZFYXowcitHclht?=
 =?utf-8?B?UU5qakFlRGxxN0NvazlzaHNmc2lZaWd6QkVrYUNjUnM1ZkNnVlBBdnIwaTMy?=
 =?utf-8?B?RWdBc2FicFROOEx3am9IQ0xRTjZiS0lZQnJLUGNFY3c0QjFoSTBESEdzYjcv?=
 =?utf-8?B?amNIOU54TDdEVnVyTU01NXB6Mzl3ek1kY2VaeXBIeE90V0luNkp0SDU3b3pX?=
 =?utf-8?B?MnlkMVk2TGVUaG9qS0JEZFVZR1pzZjZFUnVpS3NzRUpLSXNMc0VJOUI1Nmcx?=
 =?utf-8?Q?p6oy9XbeaR+NCDHcEJYX7rhoEdsH0ewYrXp2KOHAtiJ/g?=
X-MS-Exchange-AntiSpam-MessageData-1: 9jY466PcEv3uHQ==
X-Exchange-RoutingPolicyChecked:
	DRyom6th7etfPkNT/Ay9ZyTmISkIp1PvR42yvjWRI8dmwNfv9l7nBEqJm7TlWGxMUyDisGnX0yTQZFEZygL84F43Qi3iGak6BWmX5fhHJq2oCX036doqFjmXC8jKZoiHEw7qz+XQ9Yixmv/HBy/7LSoTSm2URjqo/GiuLINk4eYPfmGZrQBO3bHH/EhuWEMRDTg8AAgeQ09ETFtIV9qgtmTIai24x/6+BpDhwXsXKoIarZbnYX7ztmQyEeIXQC+2NPNmlCpSKyOjr51tapeg8HfjlCm2xfAbOmHzfEBDq3BdVgrRmcyYt7YOzq/6kFGkPH2CSHyXnmNtnTxRzmjhlg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zpsRC85b1QVT6zkndorMaYxIvJMZPCoujQDwKcebaujPUKeU06HU49vvvxHb/aPLtjZgiIUwLEifP+ILNrpLPKqk2mrbVEf4CDpZjVTFNoG4h33PEXDsyMm0DFfM3mXMGAQWyxUXVM3quheVxszb2uNpqhkpX1Wq993rwTHv4Q6jO3Tp+ZMJGFdduTG695K+a+cuIbmztiQfpIq3omSYdv1zlXvSbnRx2NBcLjIKSfKrUVP01fCXETbQssrHktViCBhdePvKcqw5vWUSfDNgJsNK7JysGRvzkBg++lJBYOktZNvt6DvUXknPf7y2duRA5T5bKJaUG/kXevb3jfD5k939lV5WU+BzByT1rOgsv/k/kT28V6HjJNJq9Hu4Vha9AsC/ctMptTYx1gFIVWUWJebf4pG0lbF/zT2ga8+C6KKb8ok5YIZZ0ww61dFc27Az017hYKfZPvFqV+OlQf1rIfAJgRZW1I5hpQyu7tfPP4aYg+yqCFB7i8QPUKjlYqi5sQtXQJVcnDTfT9WV40++biK6+KqzjI4ig/IxaIMOkuEu/SoPBtum9lT7sgbwNqXPVB9Fh/5Q5ahwXFkUFuFM+Azrhp+/az+UNIAlgPIEQaH2I/vQAt9oAm+3tHaeK4d7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebeffae2-b8da-412d-1cb5-08dedda1360d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 10:02:40.2026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: haLbTEXZXWMfSQRojbBdesBsazH9Qrr8GWzpeJMunZGYKvJmXfcapOPiHlvspgLsDjZQlEphuZStkdbpDwVTCh1Wfbt8738HlkebVMevSEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7079

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

