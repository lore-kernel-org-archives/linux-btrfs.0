Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792590143;
	b=pzXPyWByvvSfc/E2J0aFNE4hVRyWOKgjx7eW2RVAS2FkNjRLLgaUkRWsAU72lSbWdIi9
	 OBiLioJAspR69wrZnrCHqHBKr53F8xbPEGmzh+96gIrcTujsCI2P7RXbcgO6TkqM3M1Rr
	 8mCqtq79b68FW52wots2yLVdKBznmGYpvuYKb1eVXGrSb3rEVUFHn7R+I6xFuHSrDkzXY
	 lMwUgDE8XSi+Pgf337MaCJE1b+YoXnx8zLlFWNfIrOScXhx/hrwmEDeOE0GFk3z9FJ8Ng
	 MVHFYNaAJ22r61fJzbokuTKSpD4GuEJUtfqFOT28CP8YWTW04JLAQHlNwBKrugYn+FQ==
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
	bh=Up1dhYeVOLBMl8aRMEN4pa2QU68oRhh58w6aPbXY8+I=;
	b=IQvYefC9Nlqf3vWvd8YAMrPr2MeMyrjgVhwJXTkMdD1bv++M2gLWOFzYnJsDll8/gXVF
	 Z63HZSNXfoaPK+RqyiPVX2wuLUJeIj4of6MuL+7VPiOM/NZA59W0ANjiHCEbs7QnA4TOX
	 I6GD9Jr9YYTaKv58bgtf9gJWH0hPKCOBnuMUvvXjnqczVVjJnmuz5zVwB39E/LsNIxDFC
	 hYmoIcWrGWTrfeclILXT+9UvdUkNTvLvbOiZSijweBeVPaafj4j1wvThf7vdVfqqy4XU7
	 1R4snj+POCQ0VSzj5Ejj8Q/49HIOZ811G/Df7Hje5DTkLl4/5w/SDj2ld7MQg3iLhLw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=peEG6kWh;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=QFpYiPCh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0620D606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:42:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0620D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=peEG6kWh;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=QFpYiPCh
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792590143; x=1824126143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=afhK6FxJWXJHnd7CSlEKLfLt3ktj0j82qFu6rH5H9HM=;
  b=peEG6kWhyiKfOUa0KolfCS8vokkvG+4jd/P7Z0ewihjInT/iesk+hNGJ
   cgfJkTSFSEgZCzWp9niwYzhf6snGPvpb3h8OfyLmdr2qByBHeVLuw5UJN
   3a9dbwhvI0z5lM4jSsZ9ZdUUgYrOA47ep+/6MDUd9niK23Lj0cCphVYpY
   fvOF0z8LmnQTGcRDcGqFu9n30rqcmy7HnUzkTO7iJv7Gz9bMlAIXPdBUK
   TQRMHZOuIW2gvXOwf8ig1cK2ONXR6Yyq+B1TrNYbnLuz07odNLl3SI8CV
   pu6z/QMlnVn7828c4jrSV7GOE7FXJPAaQ09hMG0o2ykmWmK3zWW9sPX+D
   A==;
X-CSE-ConnectionGUID: FwxC7A5BQbaAy3wxww9MkA==
X-CSE-MsgGUID: SOhvQdAtQcerWUgUZ+IhlQ==
X-IronPort-AV: E=Sophos;i="6.27,170,1786982400"; 
   d="scan'208";a="158647883"
Received: from mail-westcentralusazon11010001.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.1])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 21:42:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RjsEwNVAXaAcwocaXdQmTvTJg6oiFzxIJ03d+ufWPzj4r6lnO0TB6FGgqPCc+Q0SssJp8XBSfw4VeJHN3ZDnYB7mBolDuWqGA6AFYD923pGC7ZZnUFhNsiACVbp7xUxOpKudFjFIQt3PJGgOxAgAh7AwZLdoIRTJ62/E1UDVob4y6OBlXkyOXAZqh5otE75zm/o6Py1K3pjgLxgsKGLrGR0WNoQ+p8fxY2RoRPpG2USNUjeNTdUGKtIJ8iANlt6eY54XJf9FGt++Kt73ezMRjtbjPo0w5RKG01OmIcJQJ4mxpn4PfJRf0scN3id7nZ7Ag4b8Glk9QC2uIbtDVxTJqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Up1dhYeVOLBMl8aRMEN4pa2QU68oRhh58w6aPbXY8+I=;
 b=sapzVUSr9ICva3hqcdg5qB/++mHgZ76gLQ8rwKbQPHMcz4JLWtBiZBDMLJsOU/OyV7WHXwtrTbFlfKMwbJHJk9uJ1OYivZy4h19HGOMuxJsiI7ePRonO3r8F5pzaA0+QYJWayr3Hjpt7FOPkP+okdnxqbNiubFkyfAoZ68EdW0ZDBAiYT/wxzxIkcbRdmqIhir+v29XpJw88nVOmutml8Ku8EwOikzeovI/8AcuFChY9vZN4NPJfYeU/fDUthd3rOz98sqSsfFEbrubPzXdhrusiTSf7sMYh5Lh8mlc7SwAnFR4Idi/fkgb/6hUao+LkctCN+SoY4gm8LDtYQ+F0hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Up1dhYeVOLBMl8aRMEN4pa2QU68oRhh58w6aPbXY8+I=;
 b=QFpYiPChJTHiTazAe9ngzvwRgmm+ACKgsN90aFXzAqZFjMNJnPpPW/YjpU82aETM5GXmiqnQ0Onc1SIjp3gqF8xiOhOx7VoxZcYhmECjN7RUiSOgh1yHk3ThoSjwFpxV1k8ncjqwgoaIWWZxqwXINCebpR9xzusOscivZyRPSeo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH8PR04MB994203.namprd04.prod.outlook.com (2603:10b6:510:704::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 13:42:20 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 13:42:20 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 19/25] btrfs: zoned: promote reset data block groups to the relocation target
Date: Wed, 21 Oct 2026 15:41:18 +0200
Message-ID: <20261021134124.2338902-20-johannes.thumshirn@wdc.com>
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH8PR04MB994203:EE_
X-MS-Office365-Filtering-Correlation-Id: 838b2984-38b0-4d4e-8bd5-08df2f791d85
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|19092799006|10070799003|366016|376014|18002099003|10067099003|22082099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 VlkhWA+jJoiqZ5pSht9KsUIvk1iFFHjilTiQi4MXmoDgfIhb81vE2FKhl8YxlzF8YcTuMw62M6z+ggCwZlFdnJrrB/IkxtE0sgeKnXdPU32YitNpsPdc/+rpX2qfHlNklhCIpNKqYl0PFoPUBw3SBDpxEYaLLDViw/Fcwer2sXu2bnBFU/kncV7ApnzKsoCN6ncXEMaAyq6dV+xEzJ77DpQ3v5zhL+rEQy2PfoEGwC/ThoCZewE8FZm0nvnJU4CsFdy/xf8s/GyHwMuwP2dD+/IoECIAtketxNB7g+erLabLMslgdUSL+S5PCEENlKuGg1X4xwol4hJf91Mu2dEqWQhDg9TBjhe2GAvQQWGy1T5rS7apPjJuDbDz4yx/M/MxloviOuyJLqENpiOeBPPN1v5dUVtamO1mmREzqKNRIUpIfvkw2kQwrVAm7Yz+YTspysfvjbPSy1jAQVA81pOYTEIMqdKjg1jcWWGRw46FyEfO0B/a/axOwtadr2ngLhkHNKtgrSRu3SfxG+7/URJi9z0ee5/wAhx6DS/fUQph+y72ZsRudjZrPagttJlSi7TwmgXxUJb5m+JTbXSYBUwIdilF5M5NvuRD3dy145Zii2JMx92S8fSALnCoRI0v7/hf5f1mku/nT7emnRv93MQSm+PbjAOugEKvzRjm5EMVkcQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(19092799006)(10070799003)(366016)(376014)(18002099003)(10067099003)(22082099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?f9HOFy3joXwfprzUTJpmMwlkFhZOQfFLiS2Mqk6KJflP2imwCm5oSI6OX1Ri?=
 =?us-ascii?Q?narxdiSECxuaQ4qOnVYhw/a/NfOg2X4Tn3zdlPdBxqjJbPHb6tNRj9wpiQv6?=
 =?us-ascii?Q?7HECAmp5euq8gikftHgYNcEjZ1bLb2DiezkanE2cubtrRkNHq29Wvyl/qIQK?=
 =?us-ascii?Q?+PIsVBawP8Mfp/Xa4xhpQOkjnoK6teO4esGPQ+PdbKTZ9eXFIn4Ydnyw1VPY?=
 =?us-ascii?Q?FjOrL8L0GfNM5Az/X7u1fkDp+bi3cps3F/KEfk17urYqF6PZCrLyEFMX9nea?=
 =?us-ascii?Q?cDzVj9kUUdeRB6LzBcJH4UoWqLMNLBA9Zj95yejf5O6tGGiDBwxTVlyCmLxT?=
 =?us-ascii?Q?tsrJBqlpYoDgAWGB0v+Edgo772H7Hlx0D6K/babNi91ZEfwv6nw0n6dq6ndg?=
 =?us-ascii?Q?9XZ4qbsA6gSOWLuAixz0fXRnFEQg00vr9UzPLLmMNaxGyzQfsVz+ZJqtM6D9?=
 =?us-ascii?Q?wODuw6D+hOFRK7uwdtIKxBWFddIfNhg7b87tL/szEhK1gD54KN5EyoCV0rLa?=
 =?us-ascii?Q?WDRyYfRYpfvSZwMTeQWFP4LOsTFWEUjBA/QanihxmkcMTTC1TB0TUtQ6NkVf?=
 =?us-ascii?Q?RbMOXWXJLhhNGjv6iEu21e5Wuggw40XmAWl/XyB3496ChEC8kt83AGaNw1hE?=
 =?us-ascii?Q?3stAyXU3371cncpTZS4c5bUFVVLqhtESgf8T7PE2cPTef9hNrwoe8fMMQMaa?=
 =?us-ascii?Q?dw3+msyiJ2lC4415O3JbK9Z32oPkyg0/9j+GFlT0mj65cI5P+sZ5kNQX2dWh?=
 =?us-ascii?Q?q37DTa3VMTwuslUOhgY7FFrBYxR5ISuHY9QyzocfbRtY6tKlV7M2N7Km+dHu?=
 =?us-ascii?Q?4NFCjGNxELADuAKQuKEGSTVVIBG2CqWxlyUvsr9WdRbcZtH8R0MdMqj9B0Nw?=
 =?us-ascii?Q?Dt7MRcVja/QqXerZBw4ByJhjBa6vRzGM2ZgTJNXLTMRAzzJMiqd4QcJ5AwHM?=
 =?us-ascii?Q?959623Mwq8cXO6u41gtiIpeo23lb6qGh6N+SeOdfrzQCnEBC9sAAYSXdi67f?=
 =?us-ascii?Q?aZxB3Dv5hBTL/BN7Y4LiInk5M6eDIg5PHSm5XiXG9mxSQEB+LJbPhdO+g4YU?=
 =?us-ascii?Q?NyDfNOLpNPn4wE7n9PE3tHtaZLzIUp3Tp3x1p98vKoJVSeuYLPan26Crzxu0?=
 =?us-ascii?Q?tfjJRbDMEOBB0nzoMrE6PxNw7L9hGr7aTe8D1pS8VAgHZT8Q0OlLryBardOF?=
 =?us-ascii?Q?r4J3VEHJeNkKJ/i8XpKjGzHVNtHdnXGqhyVzkfgz6GHCMeL3uuvD62eAKip4?=
 =?us-ascii?Q?v+Cxa4jeibPX/HCFmz+kaocD5LRnGRLMxY8gz2AB8BsbvDQNgwOaaST4xf5+?=
 =?us-ascii?Q?dqo8lsDO97Z4ZxAGirdfcrYbKdDB8CTdNfRNECozk7FJfNkWfA3vYJDxWW5R?=
 =?us-ascii?Q?DBHITXpTrDO1nZ7oFRcIvwhoy3/UUQ1wWTYobbxA6pzv/QnAaZ5nJXxo7sDJ?=
 =?us-ascii?Q?ja6p7G3eH984pwPXW0ZirbaohtrpPeEpNmNXQwYwQbsa1tuXNe2dUTlTBk/j?=
 =?us-ascii?Q?gIiMe6IoiWeGvZneEajUBcfcSnnnhNhYxaP81s9lhDMOvllHyxZDZBN08kEt?=
 =?us-ascii?Q?TRVNuIq6JbDcNr+7x02YZgmt7CZGUdq7qu6j6M/lvGGlwH5zikubZ5pUNfXW?=
 =?us-ascii?Q?30p5dbcin8pKybzdgRjVFRa2JAbzwmIcmzd9RI+kUTtcNnWlzQbXf1ucrjHr?=
 =?us-ascii?Q?YFFzor6Ox8Ngr3rvJ73fOCGW/BWjfURFTlywv8HO/fQ914KrEObFw3UhHGvT?=
 =?us-ascii?Q?P5B0VQb5z35P3VuDybAUDJPGsfA7cOCz6R4XjaWA/76czVvWMIoz6x5uxDvX?=
X-MS-Exchange-AntiSpam-MessageData-1: zlhprgnH57TTKu+SpImy3Ue3uDZsqip9wgE=
X-Exchange-RoutingPolicyChecked:
	zm/lmEBwW7Nt4tmy7qQJSKgRhihE3LREbZYC8+zTumvf97ujF1frNdOsdfiFYU6oE9t5eBjL1huUrt2wHF6FMbmAEr9lbm3m6a0FkpBVdhySTrCXlLX9fIBs8us6m1gEk6hFXp2WDqkiscznUweesRPgrx19lTa7+r0mL1M7JXs9MekV93EeWvZGuNo8vQGc64rj+lG0AGssyX5nMR0SwJC0RHxPkovnQrxge2KkEmhlIRsa9e2XaobA/B6Gr697GcLZR75I0d3g72gEIu6eNVFyMiWms93h//1HTdWd+FILRcsWhmjVkgxgnb3BL2eYNlB7X8+3fu7pLpaZeBRJ1Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9znyUQLCvTlZV4V7GQXv0YiTa2MFzuP/Q1uo0tA5F1QK2V2vQ2LgazAdIzF54MrpYnhZd/AnYUAqvuD3fFt3m6c3O0VAKqYa6Hccg5+XmG/EhOsakYpM7RMryp6Zmuv4pSCWWJOuuIdQJNS474lpe/Jkb7XBaOcnDvXxKOR12svhphwT9N9lX56U1K4wTiJNecp63V3h2TnTKWDGAc4rz6D2u816Y4m0NWh1vPsZio+aITzjMFeG3GNs8rpQkUHluITQ/IBZXmbYSMVb0dwCWYnAZZkYicC2WHc8Hq5oxzcPe4GzCsnOKSEhYGuQwycUjPRIAEu50XcLffVYKe41qwWWIQPETTBiVdHO+h+CVBkcituGG9K2KJJHc+YMafnddnHsR+XnoXoEqxzVnM8/S7fSF/RjjuVarG4uofHUFXkJi2UVQGYWMjGOIJvb47Xzy3/UVRpelGhSoHpJIPYrZ8Ngp3+Qll5Z3J2kWxT/ItDsc6IBGq7T9tgikwaj1fWdfuJR+KFRffFfx5HIlSvgrTq0JaLg5bYJc+5GqQFaJ/rGin5gyQRTGqHuZZy8K63tHk9hBIEcMaKWKpRx0QkQlSBmefVBTbUwVTQp2jRUArfPqFcr6lnufcKOi17k96Lt
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838b2984-38b0-4d4e-8bd5-08df2f791d85
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 13:42:14.3648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QVNPjmNUnAZTsKCLno0wHvm11/0lHM5Ndc8Q8jvCfR6oS3268nUl9SJldlFR3LINIbiaYVPsaX481SvZ01Odk62o53JS2BLH+J8beFhYaI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB994203

When btrfs_reset_unused_block_groups() resets a data block group in place
and there is currently no data relocation block group, use the reset
block group as the new data relocation block group, instead of returning
its space to the data space_info.

Returning the space first would let a waiting data write take it, only
to have the block group moved into the data relocation sub space_info
afterwards.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 62a5cd1c9de2..331313cf01f0 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2990,7 +2990,8 @@ static bool btrfs_set_data_reloc_bg(struct btrfs_fs_info *fs_info,
 	return true;
 }
 
-static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
+static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, bool promote,
+				   u64 *reclaimed)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 	struct btrfs_space_info *space_info = bg->space_info;
@@ -3050,9 +3051,26 @@ static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
 	bg->free_space_ctl->free_space += *reclaimed;
 	btrfs_space_info_update_bytes_zone_unusable(space_info, -*reclaimed);
 	spin_unlock(&bg->lock);
-	btrfs_return_free_space(space_info, *reclaimed);
+
+	/*
+	 * If we need a data relocation target, promote this just
+	 * evacuated and reset zone to be it directly, instead of
+	 * returning its free space to the data space_info. Otherwise the
+	 * returned space could be handed out to a waiting data write and
+	 * then yanked away by the migration into the relocation
+	 * space_info.
+	 */
+	promote = promote && (space_info->flags & BTRFS_BLOCK_GROUP_DATA);
+	if (!promote)
+		btrfs_return_free_space(space_info, *reclaimed);
 	spin_unlock(&space_info->lock);
 
+	if (promote && !btrfs_set_data_reloc_bg(fs_info, bg)) {
+		spin_lock(&space_info->lock);
+		btrfs_return_free_space(space_info, *reclaimed);
+		spin_unlock(&space_info->lock);
+	}
+
 	return 0;
 }
 
@@ -3430,7 +3448,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		list_del_init(&bg->bg_list);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
-		ret = zoned_reset_bg_in_place(bg, &reclaimed);
+		ret = zoned_reset_bg_in_place(bg, !fs_info->data_reloc_bg, &reclaimed);
 		if (ret || !reclaimed)
 			goto requeue;
 
-- 
2.56.0

