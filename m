Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11173A0B24
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876627; cv=fail; b=mKbQ6G4ApDB853vaDzXzeOmqeqRXaPQgc/Wi+nkI39xgms5QtSDyh3CDtGDsd09lbyO/nZIm67rviV5TlFjHV4Z1WoNfmgUrW+ubLvx6oFdDA4pX6QUVHDepwo5IgAhkwmbuOu5CJ3Gru9O8cIFiKO5n5moz5Wwb267RCEdV9Gw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876627; c=relaxed/simple;
	bh=B0qwOrFDZ/kn9oey85ZbMWc1mh/ZZJiRKo5hUyByy+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t+ONtXUMFSzTUDqT/OPbF+nQFanB6Vb+N4sFEKLY2f5943rbCcNKfNSBYrL0mbA/tlDLTHm9G0sVxJBeoGHqowY/wU94McAWmOpOCRHBk+fa1SjrOVrGm+l/IV71jyXloWSXaeWle2QCXIysg37QqTboa4hIFzy7MGP9kkvQkxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=e1Rzi8u1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=WH/PBuyC; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="e1Rzi8u1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="WH/PBuyC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876631; x=1823412631;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=B0qwOrFDZ/kn9oey85ZbMWc1mh/ZZJiRKo5hUyByy+8=;
  b=e1Rzi8u18H05P43e+1jMJFBcaFEI0Afq1lIXSIN/TUP8gp9wSUqfFzHQ
   Qn995srZAWONenjWJorL04RCXgshj99rgnv+UjvK3ri9nVVn9aZAQJuqL
   YVt+wPC9grAqfR4/pSlJDgLNBHL7EhOBbmEwSVhqXASFw9fHwHgZsXgjK
   HJBG27ytv4Pyiat3DUbj69RA+9KhiXvd0tL33CQwVAda9mxAlmE63zp/d
   s9GZVWc1btio4/9Nl1tD3dLMwhE3zxoaDG7E9Cj9dcdRdZ1LvEiTfN0DD
   OIJvqvaTKGTwY94sh7EE+i+G/JMdYSnNA5UChFz4eRS30yQXX4Hr+5wdA
   g==;
X-CSE-ConnectionGUID: /Bjc4oW/Q2myCQC77be/Kg==
X-CSE-MsgGUID: sSDY5Zz5TsipHrk+ihEMBg==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="158917168"
Received: from mail-westcentralusazon11013025.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.25])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=js0ZjXfxxYR5UMGr/MrxdcFx38OQthdgHpYnWpVoFHth7wdcGIc9xyjNSN/muPfIcmLOX2Ql43NvBlgk4c187+nQuA993mhvNc2cAEZ6+WUyrAfPmGBLmQ4hCcQPyOuqIwyxB69P/Lub6tA9yulD46i0xT8ETBWThCNhZGNQWoxh6a6wYcIEhN8iGwoXGL3W778S3aZn84zAUyb5nsxBTXUS5tSgII1qOVxhFwSqsiIcqu2IMAK6rKoEx/R8vEhk/tZ+Lm5Lq+rOgwhKHVBShUe59kVDq+qT9xnbOr9wHEpfPM8dVEkYRfH7IYuyb3KmOFMLy/sspNbKlBKRnxkR/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Tt2tdWXSWwpDYQPjcuYsNW+tu+ZlJwc1OSZxKHDGUk=;
 b=YKRNG4G9Ragqb+NUHq8yxuO3n5FvGI5OZCWP3TPmKH+nK0IphLyFz7kshxVumDW1gfZ7RaVxsumFAFnMKgd8Y7uylYs6iF+RuT32RZZjIVFbQSm8QG2k6iuxYBaiOc9aM7+8maBauRia7B3/+CCLGgDkcr831iDjvONy/OoPX4STdHxXMXvAGlQquode6m+vYiuHw8A3QdGaUczfa8pOIt84ZO6X68zUgPZ3TfPkBePodAWVhT8hzwQStAuU5WyZq3uDZZCX67Z3HwcwxdQHrNOrsuB2F58vaibDmCBTXXxH/PqM4goECVbcqvRqhEas4UtTkLxgIk+rDtSRKtmE2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Tt2tdWXSWwpDYQPjcuYsNW+tu+ZlJwc1OSZxKHDGUk=;
 b=WH/PBuyC3trS1mEeI7uL48n8P7ZKXJg5yTGTGetA5PmfaynYdeTmLebJSKgNmcmjFRwhFiwLijBJO1MLYGDnqOqBPa9VyyDcNiiKxmNv+a4+GrtUGGxLV5fc5PAeZHxMS32fnO0QTS4KdQcKTUsxRAm57so2GQK2O06YKoj96FM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:19 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:18 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 03/12] btrfs: zoned: skip the append only metadata writeback path for conventional block groups
Date: Tue, 13 Oct 2026 09:29:32 +0200
Message-ID: <20261013072941.424029-4-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 91011d85-b31f-437b-9944-08df28fbd52d
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|5023799004|11063799006|261009223027099003|18002099003|22082099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 aebF6igSELNX5fFRXw1Omk5s1VJ3V2g5q1hQLFa8L9WcTBFEmKqbM95vbIpzJJddNDCPIWb1TXEl7P8MLwqVdv92o7jEkvTjlt6/KqVLp2eQZwrWnrLTngQI2A4FGZY50YCL6Upysj+Z5UM05sLGSUDFmF/gcXNJ/hKRHJJoG6w47USiag1uxBZDVbqu149fum18kE7P3MjCwTldkJvHIdM7GtxPts/q/8vg01Md5Ro4KBHBczW9YNOgW1/Tww1byMf/Q9/2rTdF+Noo8941Er+OYYlLJNc0//fb89Mbz5tT/TO5x9OvfzZfCyZa+uF5/IRJqzjtTuz8dOe3q+PAQ5eGXM5D4GzV89pMIE11r3cqCc3nWlmwU8pm5OGO6PCr863/MHAkcmBCHVHbhBwpBwYy7EHMJajAt0fghHruw1gRVKOvAmgfGTDP14k8q8LN7EQomvFRLw/xPW9it4fT0MdZ8qU81cB4JHM0m22AYGUS8qBIldh+2zI+Fbu6mATTYiYrFkhVIt/VFJ1d0iClzev1kwlO8oc2C6uOJpsgrycWRGzA12+/tMBSAsC8uU/pDV/7xAMNa1m5vt+dBkVhC6VCVCpQIT1Xg6U7klz5B1/wCQ4jhuZqm2uEqHRiA3GWuEqzHL+El75fGZ5bWPIaBF+XFFEbQ2XpSAUFW1adwZM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(5023799004)(11063799006)(261009223027099003)(18002099003)(22082099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?/9BdxQ5/6agK3xgYht6//Z84mNPSHg/NPQhp97PXRbIO1SFnPzLCEa1a01Eo?=
 =?us-ascii?Q?OCyEAMKCvIRZcpen7PQ7zT5aG3pm7/2QGqAvQTygLgY4ZuUEBUIIpMlXWoC4?=
 =?us-ascii?Q?OhQs7ugl/sE+lY+aQvz4yT75GB/SEuZaCmEkEpzYNZfdVhwoJINF3EuO/Esd?=
 =?us-ascii?Q?lyGk9/oJ54PLbLvMHQZe8XINQpwU7OH5KBoCwXh57XRpqnytdbgrp+zo+NHS?=
 =?us-ascii?Q?rlEdoO4lvgBOJgm2S6WGkkD1JSTZWGCCz1XxpRikaW0ejK72OzHBu+ajBjWF?=
 =?us-ascii?Q?m93a5RQRBhuDzQarOFxIl/03U56zvM7sn5RUPqqFnFylf75RN7+X2DEkpr1A?=
 =?us-ascii?Q?Yi1e0Sjabkxq8jTkYgETBUDZ5KV9ampwgcT2G7rFMc2IwHDxpiWpdGg5iHKS?=
 =?us-ascii?Q?O5xgQRs+iC6PpQ/V8PfFwen1GF8KhT5j9HLXHRsO5/RaDkJgUBrbocVZhLKE?=
 =?us-ascii?Q?NpIGlnSNtDH71g1FAQPqQ2Ysn2HjYxaU9GRs47g0/V57SZxthm5PVYHiq5kU?=
 =?us-ascii?Q?mRW3KVC2Rgb+ERXBcdUwx4NQ9Ve2T3kNzezPcS0io5ja5QugHr2zTuisvA6I?=
 =?us-ascii?Q?UCdd7gd0XAW86kLFq3cNCoc/YccEAe1b9rvOYpI+YrvUyqY7yUft8LoNBSa3?=
 =?us-ascii?Q?3Y/XNnsPRDL06WZsOVEIAvvSgehx2BzBQ1AyAy6dESxJK/UpaAPA5FDaSfZ4?=
 =?us-ascii?Q?C1+elhfTHm3OoVLhhOEeeb/vLHoOEjkCwVw1muApJwgcnSqC2FMzfsuNMOdN?=
 =?us-ascii?Q?lDIn/R8UWr2Njq+FKxYGEfwJ90lYtiAwXdAeeMt31+sOtNG/uUJiwbJzWLm1?=
 =?us-ascii?Q?M5RUQaqJdwwV3u1g2p/kxcMg94uK3eQfh1ydDjQgLgqFqLoUQUb+8csgmo3a?=
 =?us-ascii?Q?Nc1sQ1cTcMhyE/4xwcisfDUfM8aT9q1TykOAopqQ3XREearQFibn8kQlE9cV?=
 =?us-ascii?Q?hgLuQaRahLF6NhqPsRA4EcEU/aSAZOOT1wm4F8e+IU2Gn889EnNrAuANIQ2+?=
 =?us-ascii?Q?ct46URj9qEDpjhCqEbHa0BKREa9Jyl1t2XfF+cRV6va7tVlCATDs8Bxndd/M?=
 =?us-ascii?Q?F2Gwty+/WTZ2EpowttPbCfk03PiB95aYn1weVCK8q/Bu1O5GBsOgi4QqMMoq?=
 =?us-ascii?Q?6eRfrHSgyc/cWTx11sS/mWEMg1wTP4VJ18xeV4oG/05r/WUSPiyevWFNzqbn?=
 =?us-ascii?Q?vBwArEhFutAhPCChnXPCNKu1AD9y3xIH0a7jDJprTg/uN+J/qW8n/pD9pqpB?=
 =?us-ascii?Q?H38dQ1OEHIzqK5+PEzT2+9nfIqSolWKq8ozjd5rRtlGx2p+6rZI+pZSWt2yC?=
 =?us-ascii?Q?mcp4UeoPds23hAmFv2egg5ukf2R2s7JlljBFF4Hhkq17ek0yB8xdBErj6ljj?=
 =?us-ascii?Q?MPfrT4vvRN6VCn3QfFckoxqXlzvRyu8ti+OcOjnsry3O5bLN9bmO+EY7ZljK?=
 =?us-ascii?Q?DO7sk2hWIEacGKYy6jdjRbAnJ8eQ9/VhtD6k7OBD3E/XpDH3/nTwJiZthXNS?=
 =?us-ascii?Q?oiN+XSzfh1tmqb80hEEs1UF5V0/FZq9Rye4QLkQvWV5WQODMCZvUrR+Kgj2f?=
 =?us-ascii?Q?V038DOH8kKo4IEMCszBpdokZtK0/PjGvkbdxJPp2T9OKtIxCVaO7IsUR1B0y?=
 =?us-ascii?Q?q0iUDG/Up2IoHO8uftPFZzmeXO4MQK4bE+xB+yvcHjEWH1ejppjrWrU6lvPJ?=
 =?us-ascii?Q?j724EWH/fkx8+GlR9+EYXOAeR0RjmPgszaNsI5GX3780e21F4kBk9Lf8cGny?=
 =?us-ascii?Q?cNvibZjgj2x7l9jps5y2CmQ7ljOi+9D+zoaPlFpkTM5O1sZkQNNdQ7QgcbSQ?=
X-MS-Exchange-AntiSpam-MessageData-1: AbwERROFIMdDVOkJQDzvhbDzRty0ou6kv9I=
X-Exchange-RoutingPolicyChecked:
	Bq2eo7kwN4PS1j2DuAdNCp33n6aRWKjLafq+WJbj/4s2ObEw6xoIzm9ev2F01DbggfggGR+v76QUVAx5U11LxP172wE3i8a07Dt813gqt8srYz0uEwfqxvD9KxtOeyDA3nIgUMpXVh1cJym9ECNN7RFUIuIfFJyvliKJyaPLuMr5KHI4KVlvhTXakf+gEU/GL7+o62Jz3YOmzaUr2u/XkOKcP+iXN0ns4+ffh4LPa3vM41fUEioCsrvyqYLynLKIId+hadZQ3wysKCv5sxnB906237rN37yZuRGCG63hm/jniY+Fn6prTkmsVvwmVab9tzJ220A70mPqWJ77lpKALQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uHLLkImIhm2sZBsBWQhxuxYa7E002EOAdLbUNEpIZCUui753nh/y/jXfYM5u9BQNCYz5H1LrXNf3xb8bCO1TMBZdI91FfQPk0u/xWzNBUbF88B30PbbmISBLHV+U9/E5bn6juT1P58daLA2Rif+/1tMLoq5vGWHCcwBQCcwXzJZ0m3r03HLX82MHOQj3+GGxCc1KAaQSQ9IyR7miXIZkn8ephSPTDDQu516BXwEFiM1YothOs6eHgONE+dsN9KiMiZXnV+b7eDQn7Y+en2/BD9Ehcv92rOPm7Poh+AG9OgThqRC0xzF/rvCENGaLSljZcwuO9RbgBqqZQPGuWoFJj5ryDuCA2aSbC15Y8fFJVWJPyeiqgM2/kwTHPCJGgzssS7qfuDrLSNEp0lXWhCoWy9VrIFMiFN3+Idrhbk2LdowbTbp8dSgI7kMS76z5COkGxv48powB+m1BXtG5SgKRBmYj6fKk31QKZDQUB6hZAiU3cDFM62x4e4XKfU9RUrPiwhfYk2L/jDcv/QlcpnLiYa6/nQ81VtvJo39CxGFLji2yEicjkQbdJgnfLD2DwMEHqUuw7rP6NVCIJjEzipljZZ6n2Z5rLjmTDxl9qVFz/dE3nBJ9H57FSiP24My+2Hk1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91011d85-b31f-437b-9944-08df28fbd52d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:18.9139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g5+Si4cOi6kGJ+wgL5FcP1ZcxwpCCDZ06K2XJCjrPCyK/bZaPT5Xmeh31xTPU3duAQahwEvtRVHAolWPrMa0e6m/s+cbPk1DDu6CBmbyaFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

Metadata living in a block group backed by conventional zones only can
be overwritten in place and in arbitrary order. There is no write
pointer to honour, so there is no need to serialize the extent buffer
writeback against block_group::meta_write_pointer, to keep a zone
active, or to write out a freed tree block as zeros just to advance the
write pointer.

Add btrfs_zoned_bg_is_append_only() and use it to bypass all of that
for such block groups, which lets metadata writeback proceed out of
order and with a queue depth larger than one.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  6 +++---
 fs/btrfs/extent_io.c   | 10 +++++-----
 fs/btrfs/zoned.c       | 23 ++++++++++++++++++++++-
 fs/btrfs/zoned.h       | 21 +++++++++++++++++++++
 4 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8ff21dde9a46..bd17880039d3 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -64,11 +64,11 @@ int btrfs_should_fragment_free_space(const struct btrfs_block_group *block_group
 
 static inline bool has_unwritten_metadata(struct btrfs_block_group *block_group)
 {
-	/* The meta_write_pointer is available only on the zoned setup. */
-	if (!btrfs_is_zoned(block_group->fs_info))
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
 		return false;
 
-	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
+	/* The meta_write_pointer is tracked for append only block groups only. */
+	if (!btrfs_zoned_bg_is_append_only(block_group))
 		return false;
 
 	return block_group->start + block_group->alloc_offset >
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 55e9144d4759..bd745b913d15 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2535,8 +2535,7 @@ static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
 	if (!lock_extent_buffer_for_io(eb, wbc))
 		return 0;
 
-	/* Implies write in zoned mode. */
-	if (ctx->zoned_bg) {
+	if (ctx->zoned_bg && btrfs_zoned_bg_is_append_only(ctx->zoned_bg)) {
 		/* Mark the last eb in the block group. */
 		btrfs_schedule_zone_finish_bg(ctx->zoned_bg, eb);
 		ctx->zoned_bg->meta_write_pointer += eb->len;
@@ -4170,13 +4169,14 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 	/*
 	 * Instead of clearing the dirty flag off of the buffer, mark it as
 	 * EXTENT_BUFFER_ZONED_ZEROOUT. This allows us to preserve
-	 * write-ordering in zoned mode, without the need to later re-dirty
-	 * the extent_buffer.
+	 * write-ordering in append only block groups, without the need to
+	 * later re-dirty the extent_buffer.
 	 *
 	 * The actual zeroout of the buffer will happen later in
 	 * btree_csum_one_bio.
 	 */
-	if (btrfs_is_zoned(fs_info) && test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags) &&
+	    btrfs_zoned_meta_is_append_only(fs_info, eb->start)) {
 		set_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags);
 		return;
 	}
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 3af234dea6f5..fef7cf390425 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2301,6 +2301,9 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 		ctx->zoned_bg = block_group;
 	}
 
+	if (!btrfs_zoned_bg_is_append_only(block_group))
+		return 0;
+
 	if (block_group->meta_write_pointer == eb->start) {
 		struct btrfs_block_group **tgt;
 
@@ -2328,6 +2331,24 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return -EBUSY;
 }
 
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical)
+{
+	struct btrfs_block_group *bg;
+	bool ret;
+
+	if (!btrfs_is_zoned(fs_info))
+		return false;
+
+	bg = btrfs_lookup_block_group(fs_info, logical);
+	if (!bg)
+		return false;
+
+	ret = btrfs_zoned_bg_is_append_only(bg);
+	btrfs_put_block_group(bg);
+
+	return ret;
+}
+
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length)
 {
 	if (!btrfs_dev_is_sequential(device, physical))
@@ -2586,7 +2607,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	}
 
 	/* Check if we have unwritten allocated space */
-	if (is_metadata &&
+	if (is_metadata && btrfs_zoned_bg_is_append_only(block_group) &&
 	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
 		spin_unlock(&block_group->lock);
 		return -EAGAIN;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 8e21a836f858..c5116db8cb0f 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -77,6 +77,7 @@ bool btrfs_use_zone_append(struct btrfs_bio *bbio);
 void btrfs_record_physical_zoned(struct btrfs_bio *bbio);
 int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 				   struct btrfs_eb_write_context *ctx);
+bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info, u64 logical);
 int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 length);
 int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 				  u64 physical_start, u64 physical_pos);
@@ -215,6 +216,12 @@ static inline int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static inline bool btrfs_zoned_meta_is_append_only(struct btrfs_fs_info *fs_info,
+						   u64 logical)
+{
+	return false;
+}
+
 static inline int btrfs_zoned_issue_zeroout(struct btrfs_device *device,
 					    u64 physical, u64 length)
 {
@@ -432,4 +439,18 @@ static inline bool btrfs_zoned_bg_is_full(const struct btrfs_block_group *bg)
 	return (bg->alloc_offset == bg->zone_capacity);
 }
 
+/*
+ * Data is always allocated append only, even on conventional zones. Metadata
+ * only has to be, if the block group has at least one sequential zone.
+ */
+static inline bool btrfs_zoned_bg_is_append_only(const struct btrfs_block_group *bg)
+{
+	if (!btrfs_is_zoned(bg->fs_info))
+		return false;
+	if (bg->flags & BTRFS_BLOCK_GROUP_DATA)
+		return true;
+
+	return test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &bg->runtime_flags);
+}
+
 #endif
-- 
2.55.0

