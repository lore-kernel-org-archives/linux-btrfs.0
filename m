Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794942002;
	b=CrWtBngU8glvKxysYlXWNT8Lm6BN5w7+u3FnSPOdXo098/8If0OmA9QvVLxftEF02EQp
	 8qAib/RxPMpgtwaoMAinb4nD5l6cMxppCORUCYnsI8inskr8K2pt75cdGKJY6FzXzPzkz
	 d4nsvxaa2I5FnJ/eLbP5vuWz3Wv+jR8sgUCofsmZ5/5crPDJvSpcptxNB0/FwsYlNwm0W
	 3m67Q62WsuN3mhH6pylU/5SfJtYrhA47ro9UehnYcHwTBOnnEpVPbmiMw8K05CPBNHwXw
	 6jeXF417VWGIskhtSrWWqN2OEFUjtHBO1LMT8H1Fr9khqDiwRbiTXGkYnA0KlcDwhFQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794942002;
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
	bh=4356RS1tU+MCjh7uobkdFs1bo6Hr0Ovqd+ChGydohnM=;
	b=XdjZX/YE3GpdP5cVTmFAPc1/AW5QEdDvI9x58ae+2iWDNeMttB4kxsmhHGqmSLQ/mCZ7
	 xGKNvqI9EjSVG0dMR9Eebqhfdq5BYNOL5e0ORuONv2AvFOyUxprqQXGrK4gesrWy/83Dd
	 18TxdLDAjZFrP5B/9zAZrZNifYh1aDTYUFH7PnOdAqsneP9rQbreBQwj0IULb6h1B/+qT
	 7J5KgDkn7DDjqg5K+dyZgrOtLIK9pon0rGh3VSUCE2NnEIuXaReEdRVoSo19K+pebBmvx
	 B1mxbUWUFPjVXtqMPRvY2ECyrCfSyk0jObSvNYHK9N8FTdIJ5F8D+FBA8sJ16kftF7g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=fjFJRwGD;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b="oWLFJ/Vn";
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEC0606A33D
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 19:00:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FEC0606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=fjFJRwGD;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=oWLFJ/Vn
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794942002; x=1826478002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=G893qBlZn3S+jgwnVosko29J09nuroSRWB2j60kkNTM=;
  b=fjFJRwGDLUTYOysS/M80EVh1h0tfDDoIQ48ZUkNcS0mhojQX7pS8vLxL
   03xypWk1lJmxvz36URie1vAWJF7OwbuHLz8ys1WP9huVHSBdgcOJDnLxC
   XbXLVWdmb+wgP60Zh6TfnQo4VKFQDpv30kxt3YwlDx0MzGY+e4wcsO8lS
   /dhTMdFH74fqepLqpQiTVJu6payDbeCzUKQdFYV33rEQgzoq4Yg+TMGyI
   JZoLH1rPqEoIX4e68OPyp1/z+vxU8oloHvMU8uIS1ls8zb61vQcjouHBM
   vDes58oJtCky1UeqOyzhjAfnSqsORubz5VDrYpoOl24PKXuLEPUtjEYKq
   g==;
X-CSE-ConnectionGUID: A/hDSiJGRVmbiqcwIbTjiQ==
X-CSE-MsgGUID: u7GWfkdaQXKjvVTQ61M64Q==
X-IronPort-AV: E=Sophos;i="6.27,218,1786982400"; 
   d="scan'208";a="161122897"
Received: from mail-northcentralusazon11013038.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.38])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 03:00:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cpvX+ZmTECczC3q66sZRL/hgY9NQ5CzxLq8twmw2uxwv1J6qSPQPKKfNwQXj8sKyQyOc97rh+2RVyCOKy/f/sQirzCyxnWanpt/8OjKGv+MwY/yAU436PXmgs60aoHM7dDRiv12nM4yaPU7+73bLFAZuNsbjQ5so22K6q2jgDdCyWIr2GW8FD2r36+eehC+XMKoXoXOgd8mYb2Ug9d8ETLCRcF9OfOUWurjcgDUpiPO38eJbAEltRz4Sxro2MxMOuMj4nAJmYUQ9KVEOxH+PJ+Rl2jKADsOilTrHnxg+OqbNdO5pbwBg22OVzS90T0DPL0zgSvi8DTqH+LV9PCrKzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4356RS1tU+MCjh7uobkdFs1bo6Hr0Ovqd+ChGydohnM=;
 b=QN3D56RgwrUYa1QQQGCU53xhYU38B+o9VMkfYcChh3GMu7IHdpiSM3IfIjurKiD/5Lfr6olQElhbBfqpZPSPJr4fuKQT67MMN2qzjqVhAmqkSTlglYN64QN8xEkxFWRYvMw/WiKmkuvFNmbg0x7fEfce6QmjF2WyE7jCYTDtxgeyoMxXJPNb5MKosstPyR+i2Se+QmjQv/1ZyiYb8HGbTlnw0SnEm2v3zQ2ynbQs5KxZEnNrWdmkj+22nFXmMUNH38J77JFQYWrJbDUwiPtHcTtC3r/FSMPCjjZHT88MdAI1+BvW+YyFXoBJwAz75Jl5ce0dhSdqKZYQL6OCgeWihQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4356RS1tU+MCjh7uobkdFs1bo6Hr0Ovqd+ChGydohnM=;
 b=oWLFJ/VnphxbZbuFfcyg2i1GeZbhb/dYAkBkq2qOla7xGwAYlpIHac74tDbRCx3Kn6am3g0zH98rV9UDwXX4Weg9cMMfqNb9Lai0ODkEqgH7VR8DXe2rttaePaePXdBZl5LwkxakzlMbSgH/s6NZeU1p/jP34bi9gMghIJDu9kc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS0PR04MB9511.namprd04.prod.outlook.com (2603:10b6:8:1f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:59:59 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 18:59:59 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v7 22/27] btrfs: zoned: return finished relocation block groups to the data space_info
Date: Tue, 17 Nov 2026 19:58:45 +0100
Message-ID: <20261117185850.4128157-23-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::13) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS0PR04MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: b3804a39-ad70-4ec2-d0f6-08df44dcfa66
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|10070799003|22082099003|18002099003|261009223027099003|11063799006|56012099006|261102123227099003|10067099003|261022075727099003|261022105027099003|261026140227099003|261021121427099003|261026121527099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	IEQn0yLw8NQe1GVcweXJCy/02Wjct/2h+CcsgS67KTuIudxCFlyYIxeOHo+kYOPVq7d0hB2wqnWgPopP4aEaqO6R+92LI0WoYGiN2ZtsOjzVKTlBctfY9uKlBCX/w8wmKKA1WFYTw1LbaMKsxRoCz2CkAItqxPYPWBUcdXN7b0TeSRsvxB28eJHGUORF/t/5sgK2duFO5/03gJyI9Vnvct49NIgUTYHkuUxDUBpPdQc5KZd+yc3ezyjF6yEFjIRpTWuZVS/TqJL1rVK3bZspc4c4JSXyMyn6QKI/GgzV+SXQYwDT4VvasKcs78QN/jnjKBCtKIGgUsezSpDadF7fi1jKTgA4z3xNZGjQArm0f5JQNamP4sMWW77Lhum/OHOxUea0vV3g1zbta2Urdshr1PNBA72SFMjxNuhMyBUB9Ub84TF8B5ug0VwkUxxrI9JZs+V7K9z9fjOtflE5GJIVqCEtF/noopWt30Ml4Rd1ygqXyq+RJJXmwxsj3tHuHal4ysOSK3FqUAtqz1so8HiMVe6u9Yt7EaJc/Gjy/24qGmjxCWmPlIGabAg5XkVBzHEjF10Dcgdffozia8QrBWjrDGYQbCDzYjt2zJlKMZMXH9dqhcMp7IMsJgIUYQU/Xi8zQkuSnS0S1HJxx3AIelC15XtnW5HU7pQduRpeRehk7uM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(10070799003)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261022075727099003)(261022105027099003)(261026140227099003)(261021121427099003)(261026121527099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ns0sMyqiSeVDq1RlUqORtUB1iBGueWNjgoZAGuvCUetPOpN6UKTvPW5mEhUc?=
 =?us-ascii?Q?pm+HgHSQhgx7kk6ounwIeCSqks+dVNCDGmn/WhoObdKAeZKf4K7pAbcYNnj+?=
 =?us-ascii?Q?L8+F6KRhIDAv984XX5IKMTzgbKvNw0N9mkPyUNt3OGy3z+9KK57vxHu9dZ/I?=
 =?us-ascii?Q?1PtfiJi/QgifCkOU4tbFwo0hG6nIc7IfMmmDVCY9j8LaakS3X3vvTAp6SJwl?=
 =?us-ascii?Q?1ijny7B5UjNL6DQSg3oaGvWYZPKWE01wY6BiFKf92TVF+GcYxf7/iPQXsEaz?=
 =?us-ascii?Q?cGsbFSsYRqJ+zRhLFA8V9MNG0vdSY/Mr1UjqUhYVvw5GaHXM0V4mSEoAzHBg?=
 =?us-ascii?Q?0jjG9YAAywa2+gPK5mgEnEq1AlzjwZRBsSpBz6B2t1WuSEVbgRcwUgB3e4pj?=
 =?us-ascii?Q?/098qXe6bfpqE9XGTGeSGRFSQEE4XkoLMfBsnvMDcWPl6nMzZAHrOL1K7/Ud?=
 =?us-ascii?Q?LiTQRoWo8GaX3z18l8XfXDPRL01ccB8ygJkN/bs6x5dGIXpKVJfMoaZRjXGg?=
 =?us-ascii?Q?t0uSsEkyBvvQcqiJJ9EdQq1Xoh2Q9APlXKjwL8MENd/knep4PCD9v+mCb2ul?=
 =?us-ascii?Q?cfN9fl/KNiB11AHfkFH0WfN2cKUWjOcPcfOWqrUJCsInbzQFW2ggC16ePbsx?=
 =?us-ascii?Q?dlg3y+0NCPA4FsBRxy6xLSw8+alTkufkrnfLWN3ZTbsEqSwrfjGnERPRgpku?=
 =?us-ascii?Q?Ooycb5MpjwBmrA8G0UVA8QKbIalO9B9hEYUh133sdhaRdRp/0EDsxD3aSQ3J?=
 =?us-ascii?Q?xt8E4K58bNCJBRk1ws5g1w/UoIzN8nues54BnLZdPuCv54hfQDYx+O6dnZV+?=
 =?us-ascii?Q?Ola2INr+lS30WC061HESXfiUhupVF0Nu3qKYUVjsUdLQdHcaZqw0AA4H/62V?=
 =?us-ascii?Q?t0SeKTjAXlrr5JVQQDPwN6SWCtRkcm+Os5lRTCvyYC9UkhDh6tqQxlneHoNG?=
 =?us-ascii?Q?AIXM+ZC6aBx+FKAfC4/wwlYOt75Yo2TjH5wBESGX6y1gvvATBaAZbhXw/Agc?=
 =?us-ascii?Q?oJiQzoKvJPbTuMokrMN7VdzOiKZXq+3jYqg9PL3jRFDaOAYSSKSt0hW5CKjL?=
 =?us-ascii?Q?vEmYrbLWKWFkZwsLZn/gbvuvy4KI7PK9JoMlR1k2G3IsPrG4T1GnwnuLG2uw?=
 =?us-ascii?Q?EUAUoFpVc/ftTjKWmt/fY+VoKMCeJOVpZ2oZ1nCPA6g7sEESwvYRlZLyQFfe?=
 =?us-ascii?Q?p1TtUwx15Ikwru3vTy4h5UWTe7YRU31XOAaxIjAJeqzw86q0eg0g0LZ4hKcW?=
 =?us-ascii?Q?jx3I3D4pk0/EvElb8mjB4yhJmkXSUj49y0/jyz23tQU+74Da0B4zPGKai9Ab?=
 =?us-ascii?Q?auG+QYzQnrWSok1NGCQ+83BxVoKBO2unWFtz1szFpzmC31C0xdo3QKSpDvl3?=
 =?us-ascii?Q?ASB9GWW0lL7mHJ8zvLuI8BEK9cuUUR8FQAWq/voklJNoRYM8zp/pQmB/2png?=
 =?us-ascii?Q?3QTtPg8Pmz1Zosq3nh9rOir0l9Rc70raYXhwSmZgy+n2V6rqW299YPXJCWNu?=
 =?us-ascii?Q?A6iMebALXXekyEf+wUyeoZLbd3PlFv2c/oV91nyF3jbD7ITctLlrzuIa2KPS?=
 =?us-ascii?Q?1aXLhOoxWIZoO+nnyZtqkzQj+Ylwr6dFWvpRjpG/NEDErvlsTusgPwMEsYO2?=
 =?us-ascii?Q?VMj7g844GZx6NPCHXwG4iqwtHzSFL/ilam+V/3Q+7b7HEGPFjwuvHhd/3vR/?=
 =?us-ascii?Q?0GiJdF52JrXuaWXRLPatvWdPUTglvR0TwFThzG00ifJMypbb/axwiLxZxqHK?=
 =?us-ascii?Q?LDzl3WGNIhL427X375Qz+F5q7+mQRACQF199zO5QITb6D5D/1K2FsmDGpIMv?=
X-MS-Exchange-AntiSpam-MessageData-1: HQKe6CGwA3u+8I+JiV0auG2lWKjZ+mLsf9g=
X-Exchange-RoutingPolicyChecked:
	FS8ic1dSoxIt1T0j4CbNxDbS9BJhUZ1DzOPrumUBTn/Pn1J6SECnn6qUbIBrUHU6JpKW2AZ1rxONYnlmhINqlfgynGhAmd+kV9Y0BNRXAUm/R2mal0GT7LZPxUpbMR7BDCH8Y+zNQLE/JBl+zpKkNU+7Y0QqUkvE4Z/a8ReJ9cG1F5q4mPeSC6iLFy9EQMrRJZq5/QvjvDkkgveaOPjIe9I+WuK4+JQwnTmuZk1sNppnd7G2zGwlwNBESn6k/ElywJGbBnxRvWMseKCrsDU3RXXOyEC5yTZlJGufljUMRxlQDYvSYATON2Z+BIFFmg1FGkpDEKPPf/1NY/UP7B3a6w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gn7bUJbAiPYwkqDo37IlzhbSnHSn+FZofa9pTLyTymNHM0Ucs2qtSJX2PBVMHkAWTKxNqZAEP+V1MTU12yM0QL/48gdIptdD1bor+FKTVr+hPj/ENtBjBV6X+FzW62tV+Sbl2Kn9/GmaMu3W4NcYqsOvuDfU/ueCvktV6GaAkSAvq6r8OcyHftcHcodVp++5d75B53sAOM7dxVev210W2U0VeJSSfjMLVHIRCX+1ISqkm96DFkyhcMYTM7ZDcSeGxiY1RD9pdIo80fkgPv1cY/2oEUeMJHulvnQaOxCX2JKQZNSuF7biKxSkyb+mZzrQ8UvGne7CaJpV2IWTu3Ui7HOnRVrHMQwzY+MVWUzHZxQX/By2Qw2tkzwAzXNCJaYz6BjWBnz0nFv25L00H+WUboLMrBlLxtBGyoqWF++k5M6ikXE9njrUlpi9oZVkHIytjMWMJcV3RJHHXZm2rGXH73GK3FYQbQn//CmKtaozyMNg3I5taJq3TZBhhpp15698bHJzD5fqY61d4hIFShx0EN02FQtLA6dv2i6Si/eZ2AqnMY9ctBaDue+fRJpkUuX1EJL0lXtc0TD8aptZEcoNSDAnaK7hBGmVqZbden0yMiuCsoqIpELs9s8IBb8yMgkP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3804a39-ad70-4ec2-d0f6-08df44dcfa66
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:59:59.6128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MGKBpK9P0sdgXuI2SRa8tuDudUoOKxZFxjn/8ViviDRpQDx8i+FN1+O0YbmFoIgxT/m5mQf8F2XJvnpcjovYSL1ewIaks3euJ0aaFSfwWtM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9511

On a zoned filesystem, the dedicated data relocation block-group lives
in the data relocation sub space_info. Once it is no longer the
relocation target, it stays there, so filled relocation block-groups
accumulate and their space is never available to regular data again.

After each block-group reclaim run, move the relocation block-groups
that are no longer the target back to the primary data space-info, and
reserve a new data relocation block group if needed.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  4 +++
 fs/btrfs/zoned.c       | 57 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  3 +++
 3 files changed, 64 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 88ed3609fe50..562ec70ff0a5 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2164,6 +2164,10 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
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
index dd05687f398b..027aa78cbb3a 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3006,6 +3006,11 @@ static bool zoned_move_bg_to_space_info(struct btrfs_fs_info *fs_info,
 		goto out;
 	if (to == reloc_sinfo && bg->alloc_offset)
 		goto out;
+	if (to == data_sinfo) {
+		if (bg->start == READ_ONCE(fs_info->data_reloc_bg))
+			goto out;
+		clear_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &bg->runtime_flags);
+	}
 
 	readonly = btrfs_block_group_available_space(bg);
 
@@ -3268,6 +3273,58 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
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
+		bool moved;
+
+		down_read(&reloc_sinfo->groups_sem);
+		list_for_each_entry(bg, &reloc_sinfo->block_groups[raid], list) {
+			spin_lock(&bg->lock);
+			/*
+			 * Only return written but now empty block groups that are
+			 * no longer the active relocation destination.
+			 */
+			if (!bg->ro && bg->alloc_offset && !btrfs_is_block_group_used(bg) &&
+			    bg->start != READ_ONCE(fs_info->data_reloc_bg)) {
+				found = bg;
+				btrfs_get_block_group(bg);
+				spin_unlock(&bg->lock);
+				break;
+			}
+			spin_unlock(&bg->lock);
+		}
+		up_read(&reloc_sinfo->groups_sem);
+
+		if (!found)
+			continue;
+
+		if (btrfs_inc_block_group_ro_notrans(found)) {
+			btrfs_put_block_group(found);
+			return;
+		}
+		moved = zoned_move_bg_to_space_info(fs_info, found, reloc_sinfo, data_sinfo);
+		zoned_dec_bg_ro(found);
+		btrfs_put_block_group(found);
+		if (!moved)
+			return;
+		goto again;
+	}
+}
+
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 02298f408102..1f5f62f7590b 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -110,6 +110,7 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info);
+void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
@@ -298,6 +299,8 @@ static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
 static inline void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info) { }
 
+static inline void btrfs_zoned_return_data_reloc_bgs(struct btrfs_fs_info *fs_info) { }
+
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline bool btrfs_zoned_should_reclaim(const struct btrfs_fs_info *fs_info)
-- 
2.56.1

