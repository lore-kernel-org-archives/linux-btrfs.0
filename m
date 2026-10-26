Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031009;
	b=zAlpkrHd7g3JvdSOz0cjQDlyOiFvc4FQj6TpEoxi1KFSC7NL3IuY7WwSR3eW2lIcXVDb
	 QHmP5cAkf7I3jcSr9mfsZoFBbpNwrRKmzRng8Pa/gdQxMg2rNEDieytzA9tLJuEHRI57n
	 cRpff8fsHAqyiBQlAbT1NKMD6rZAWvG3QTB29f+gsf2MKVNQkAwZ3ZOmhWV6hVZiNHALY
	 Z/M/TBYSH2qxXtPYJ6qyLEUpf0Jj3WcIzf30+dBue+KvFrS+1LidyW5U0MQXq4K7Mfabp
	 mZe5gyDxOjC2ckqm2OmlLueFpYhFFUHodgDVawCBED8Rn8uN7kbYtl9CfuusqRoXvug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031009;
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
	bh=tha+WJ88v90u4wnu31N1Q+EjWf/k907YoxKM2ztYjBo=;
	b=o+vI8t1SOjOTZAAP76Q6cwXc4YG4KdJdZ1NirBKj+61Q6AAgqkvrLUuO6VZ1/3EiHQnE
	 trJM++Hk7i4RiWAFir8CjoIJSL19LZ/sMdL340js0dJ14NiOTU8Onde3WAlnpaf//NThs
	 RJhIPLxsRYuzbE8roWwDR5b0XTE7IbnE3YnsQ9ioANisabr5xEQbRq4jKpGW+1C6WW/kM
	 Im+ns0Em2Uqx2PlZrVep/b763nGCd9wFmtW7kBLzFXhsMkESs8tQlswgS++wsA3TBnCNJ
	 bh9kwo2XF/sWrEgGsK0eYtWgZYJ16BA3VXAMfeolTQIxbUU133hYRBup9qaoldfSwuQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nFSM8xIo;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rjLDjC6b;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60DC606A329
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 16:10:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D60DC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=nFSM8xIo;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=rjLDjC6b
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793031009; x=1824567009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=NwTd84DPjZV0/gk3FhMZ5Cg71csCwUIZO3iTRnLgB9E=;
  b=nFSM8xIo0d/Ok1EJI8W4D+wFVF2Sh35oIJsUoQF12s6zmFcMzywyeJNs
   /GU99iCTZ/nizem6iDKa+KCsYalXiJQaz1D2VqLM0nJJUyChPA7pJOpyS
   GjMB6b6jCkIBkW7sYoZSB6UtyA07NOnmislGpUFPSqOA92eQmNp+Bab0D
   rmbrz8IjHShVMan5ZLfFXt6pUrbu3BauFKoJV/HzK50yaDgLlq5XFY5ax
   eqg2wbOR+0OKjBHJ+UupE8+B1emXgGAIfNerHnSTG+FyALsx+/+3ewvBQ
   GTkTH6KFp945AiixW8e7geXAxX05o/YTUdt+RBGYeYW0BuiQ3blEqSC9M
   Q==;
X-CSE-ConnectionGUID: pV2YZi/6T5ON+2G9wQh6Pg==
X-CSE-MsgGUID: e5wNk1vrS7WRlXzkJlUlsA==
X-IronPort-AV: E=Sophos;i="6.27,179,1786982400"; 
   d="scan'208";a="159033907"
Received: from mail-eastusazon11012045.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 00:10:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EthuDBeOWQ3Glns7Ob6HqUqKHbuXvT0xYjNXyt1ZwkCRReGjjgqpxAhzjeC+U/Cxb3Va4P622drO4bJeDh+wM3InMXlUW/bv7+V7uIhJR8VXp0Crc9OWupDLuhhEQpIsY8+2oeoVhzOQqRK0SvpVU+LdvQj4OQolPVPbHS8lRGiGpZBz21kJuKNRibPVpHcoj8Tf4c0aTmiKUJpe/2ZBksxqL8s8zdhiafDsBwruSFw/jDfYyzMb8twEaJ96N77zfbdKhjeiqZ8Ely2CHA/cEL+Nv06Pxvr7mKqlV2UQlZ+4X92FwqE9mdDXQlk12HyWqnrnAxqbymE/Lka1dzlsSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tha+WJ88v90u4wnu31N1Q+EjWf/k907YoxKM2ztYjBo=;
 b=LXcU9+tZeQ21DAo9kKuje56PRoVGDzpFveD+mee27bLynOLJHY5qn2V27CZ7rVyFJMpr8yQSgKC7djcvtyD1Zk7gzpHUU6e/MCTaWe2B5oY4utGqcb/UaO7xnVatL5O5Ntp8iu8YC305Gqz5gotA5HKJEa/7Jc7qRtFy9icPsxNnILoSK/PrKv5EG0nY/3g8M2yebjzylKag9wGl6Vx0U4vT5R09yVZrQD4uXf2q6DUPrkEZ4czxhrCKMDCAiCoIcHOrp9pzHZMz7+di+kkPfTvxLnlfpZCLPnRdtxR002Zi0pJluS/BeCEJyvLYs5hI82GlD8VL4OzwSl2dzgf9rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tha+WJ88v90u4wnu31N1Q+EjWf/k907YoxKM2ztYjBo=;
 b=rjLDjC6bM4azdAYBBUIGHM/S1mGmG8A4SiAJiU7QAa2Cd472xqAl6lbFI5xKK2uxIoD2EJKyWVHVcO7JBkL9kc8M2630rqYQVYpC/ejdklVrBH8jixtb3R8sjyTkWJLd6FPqlFfqUZMh4Z1QswwcYvqy4C6d1ze4faLmEjD08yI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by LV3PR04MB9220.namprd04.prod.outlook.com (2603:10b6:408:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:09:50 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 16:09:50 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4 15/25] btrfs: zoned: don't recheck the reclaim threshold of full zoned block-groups
Date: Mon, 26 Oct 2026 17:09:03 +0100
Message-ID: <20261026160913.207909-16-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1ae50d33-0043-4417-44be-08df337b8f9e
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|23010399003|376014|1800799024|261026140227099003|11063799006|5023799004|56012099006|261026121527099003|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	g3ljHCUXAB0pmwnjTKhNZfV4tLTU0B9bpVkJjom6TN42+HIJs1hLuZ6hekTgggAGVETkNHnoMALYhPxpb+2mPlJSK47TlBO3Mlf3iMl+y2WAgbr5pZ/tO6mS1GeqDHQtoJxot+9o53J4Hd7+lZaDu455RODiCiXJgZ/GUuq68DmdSHXKVQiDYM0aMifIRX5NwQrK1acUhIEkNtgegq7d5mypgLv3HV1OzxJMuDKvwGoI88+r1Pmg8kRrJrHiEg5T+kJWfjTiUDAFyLcEURuZPaBcMXpoxcegJOTZLGKfutWz5XLGWJeV6809iRis7OZq22kzKJUGe8wjwZe60OjqegBUrNPd5sPPQYZd4EoT5P1cClMNKCNYcO496c1R9swAL8ZOau651gC9N9iWp8XwNXHThXI9Pwc/LU0Sim3sTT7VhMah+bW6v2mvY3dym0J7xj3e3p+kPRlSLgYt+w9h5uWuF0Kb7i9q8D+tTBxTjwscBjzsYB/eJvCPwUegJcWG8OA19GlZHzP8ER825iuFPHgH8p4MDHU8dM8LokSgwPkNY9VngGHsZ7APjTtWFI4rYa/8/QvacmjKC+QbHB1LAMHKDWTMTIXjQCQSnEjrWYumX6kc0wiKMEm99puvipbl2PVQjUEtGPqvAdeMtElvnACR0n8pTIW2iKVnVkI/xNU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(23010399003)(376014)(1800799024)(261026140227099003)(11063799006)(5023799004)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+YNJengZBN6K8fyxKIluV3vLF8Am/i+cWr5N1ip3tXeRhWF2sYK0y0gZi8xh?=
 =?us-ascii?Q?4lBkGBgDs6gf2emkGC6jjjtEF6RTyP7VfaSeSnkZkDD4jWb7guLAScEuc970?=
 =?us-ascii?Q?WIEXzrA+t5GqyvkMUvoRrF/8H/5rk617AbbHMYMiKvsqVV1EaX3m1Tk9R6kl?=
 =?us-ascii?Q?oa0NurYrg67Qd/7awZKwEIx3ZbKtFSfDxEcpIBe1jwj482bZfJjx9R11qvzW?=
 =?us-ascii?Q?s3nlrw4UUM+bpGlLGv8Dbf8jYaanB19vytFKNLGBbYa6WwXnT+L2/8W7bhwu?=
 =?us-ascii?Q?mKqKxsHOyKaeaaTULnMcPN2pJpmftEgqJGF7nFlrU7+szO5F+fKo8jAg6ejY?=
 =?us-ascii?Q?tYKvKvw2JmbQu3yALW9HymAeTfVTleDwTu02CssYWjcPcfTx+ut7PY2JQfpZ?=
 =?us-ascii?Q?Emcf86z4P64rQcDztcanLAjUP3/74pFr3F+4YDBsA0xiMErNIdrfGlpgi9+D?=
 =?us-ascii?Q?Cd+C3acdmyEtrmcWt/7tafqDCKLjXKxs1Kvf/VAKkVPxUmgndGhmGO2w11vM?=
 =?us-ascii?Q?T4B08lgxvIBo8WarH3Ze5kw/ADekiOAf4dkpJl5iq00Z72EOUYEYNgti6sLi?=
 =?us-ascii?Q?7HgIfTDtIeWW5OzI/nyPXLe0vLgWkfzFAOhwHVtvEC0xbcTRFofZC5kA9iJq?=
 =?us-ascii?Q?u3kAIDWI+gM9MZIcafTvJIPBgOZyi7+G+7777AJYe1XSaeEuQdaETeP9+Pb2?=
 =?us-ascii?Q?oeNqPoJSGhrpK38XbSUYXav4ZLnAoWHjz2G4HhzuAjxFFsIBUGC2HZ+nPIMe?=
 =?us-ascii?Q?gF5dINs6vJUEK21MwrMHFg7VKIgJhf1WZGLeNQ/JTC57r38qCZxbAdK1bq+T?=
 =?us-ascii?Q?5mkJ7WbHtjtFILBbdA8AOfNQ3uUdgnHcHtxBkNbJx6HM5rDa4MWQVaI2i1O1?=
 =?us-ascii?Q?4c7fXq9vQ+x2Ym3W+7O2HC16xvHJ0GcAD88rFWpkNnibCykoWvJOsqOa/00v?=
 =?us-ascii?Q?27yjLq7q4+RswjzhLgtIx9w2i29c74TN1LtVCaCyIBQsMDpPuYuo6FeXUOwE?=
 =?us-ascii?Q?I0mBcgx1EIcSSfgBSRoXQmgPlE/XhdiLAavhhtZVI0tfvHJSczQG7s5fSzRl?=
 =?us-ascii?Q?HwclG7NIGZLv8rZfpkuDljlgiR7SfpslrbAgEczsbgJ7jNxbmZ2ztPK0qMk5?=
 =?us-ascii?Q?iNj1c1NpyNddHpwUgi9EK9kgh6DAhXNEsMsqPse49fl5JM8ZJFaxxAs4/w+a?=
 =?us-ascii?Q?kMS3MY2sVZBiImgq8XlgKeYvlwV1a/vxMm9Y6cr+Esz5Viqu0Jgjzx2jdIvq?=
 =?us-ascii?Q?5wMMWMSvW5leo4ff5cG9EzJSyoy+U+7ESmyduNY9kRiIFxnx5Vv7djBVPCRj?=
 =?us-ascii?Q?AnFC0kaSGf2x3Mw8shpOnFxCl2GryoTS9KKwukAlRtDm/u2mzUa1VNoGhZPj?=
 =?us-ascii?Q?Y/jg1rbhcXGNFbjmllCIz+j31eoJJ17EbpW4FeriVSA0B5MJnN4f85DBMGCZ?=
 =?us-ascii?Q?3ahg2fCZPBC5rI9UsstWTuMKUv61JiGgm1PCvJrgZ04IkJ6vAaGbShvpFnB9?=
 =?us-ascii?Q?0075aqmGt9R/DHLFIcOJbsv87R6mhrjn9oz+63w+yhjQ4lTkc9BZabk6E5sj?=
 =?us-ascii?Q?a844ZLddERwX9XX/NQZnVoYQzgSMrroYT3+YCrkfSeXyOOB2sKQYvVnbxG+u?=
 =?us-ascii?Q?BDpiOLuJonw2qIw4Ej94gAfLyEdGe/1f2peOodPkhSvGphKLpJj21qYxxDDP?=
 =?us-ascii?Q?eotU23uPKG68wcK20JCLznHN5JQ4iwQ8ugnxrnCwcklg88Q1loVS3iLnbKVf?=
 =?us-ascii?Q?2dprC0bqAVI7D3hhrBEq2EmGOkFBQ6Egh3SS4Li3YsLcDOj+mvgx7QoAhNLS?=
X-MS-Exchange-AntiSpam-MessageData-1: Q2G6YVIQUCfYeQ==
X-Exchange-RoutingPolicyChecked:
	w0FiP5i40/J3sZJ5hEsnYb7EexNH47DsWbkdVjFRB7IIWVOI4d5Hdr5VqUtkMdyj+FcFM6rnihA/ySpHzXstl9/9n/AlP0SSp40jkYYd786+JsI0VY7b2E/oSpb/bzgHd9Ym5Dnppkc0UFpgeo4ao5mqSEaqcejWpHE5PvY4jWNMYGnUMck1JWbdpqWcwr+yF+rBw64RW1/85+gRq8Z/speEQiT5Nrdrp2dawlKZ+hvQmZZR5/ZHFrVi/IMfTc/3fNqQ3lrO45Fx8uq9YIurXTG+fTLE+BErrTbDUUtJNfT3K1zSGIdCKud1QlLULKUwp8Tk7L/NEvK1xnqXI1EKrg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U2XDARFK5JT4EvNYC9wz2MHY1G88zGHGbT29pGBgDOjnFj6pglnjen7YYJffsTrEZeL+nLKWIDNXGxei8pynGr4pGoJNJ4aP9ooCf2fjT6IKA+UDFMnGPe27AXTZURwSE0a4MZuqMikBGG0xDIKazAdHsjolRBKCVA+cWDGsX2HfHrGTiyhJBBZq9upKeiUX+7oKvWsXccxyeGa2Hu8xVTe8vo03s1jB5SKAz3xEmM+nhyjWIOUWXLBtwSg0IsvOs5A1f1t/kuA8GrCQe8pVHQ8B2Y8otrwH58oDgYoNh02SAxy8ncJqj0Ol27XhEZ9rmL/GIznGhfWz4Me6pSZlLrF6lpUO79azvxUcTfF8a0K95V8fSGUOa6r36QdrGPXa/Lhh4re6ihVWra2nrpcHZgRDRqXd982RAsykqQwNldBpdi5PC/n9ZznP64OGDhWhh9bt698KFYyypZh9Pk0+6B00+B6q+N0BLim4DN221GfckJUjgn73/SM5KfdRwLtYm5nViskPHEbcntnVBUQ3htoqH3ueU+BbudwVckPZeC4xhLNC53C3JCX5TjPVZO49KvKAJbjkBMgRIgeiC9FptLnnmtSenO6+L5+1lZYDMe4BtAhoZ68L5rIraf9+y7u4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ae50d33-0043-4417-44be-08df337b8f9e
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:09:49.6923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uHfwy1oKCr5x1L/X4cJemQlEsxWzXIpkRFmDaLXpx6bRPmqFBcoBlxF/qPv3l81Yi9bZyHRaiVeFCQ9SW0LDgWYx6O+/ruAr8y6Akr2PEb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9220

On a zoned filesystem, nothing can be allocated from a full append only
block group anymore, so its usage can only go down. There is no need to
re-check if such a block group still qualifies for being reclaimed, once
it is on the list it needs to be reclaimed.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 83d62228e5ad..4878a2377de9 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2004,8 +2004,13 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
 	 * being freed, pass in a fake giant value to skip that extra
 	 * check, which is more meaningful when adding to the list in
 	 * the first place.
+	 *
+	 * On zoned, the usage of a full append only block group can only go
+	 * down, so it still qualifies.
 	 */
-	if (!should_reclaim_block_group(bg, bg->length)) {
+	if (!(btrfs_zoned_bg_is_append_only(bg) &&
+	      btrfs_zoned_bg_is_full(bg)) &&
+	    !should_reclaim_block_group(bg, bg->length)) {
 		spin_unlock(&bg->lock);
 		spin_unlock(&space_info->lock);
 		up_write(&space_info->groups_sem);
-- 
2.56.0

