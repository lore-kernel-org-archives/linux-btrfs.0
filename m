Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62904480941
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 11:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784719854; cv=fail; b=Tj9sfb3szRJ7cBAeRStuyY8vlK0lRDSgPBjDWEhCmQoLF+Gy6EnJSIj6T7VzbjZFvu/xTG0fjMxDLNpW1kWvYJVIBeoMMNK790kU7blQ91zuq//ceAWh6+NFUGMBTk1QgHAkbyg+4cOjVrFBxqoVh/MFXxfR6ZyoYla/d3Dnt28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784719854; c=relaxed/simple;
	bh=l6ez+bCaU1kfsGhTpSZXkDmj01P68JA1cKoQdBA2UMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UXE5SsnE3QVq/a23dLF89In6kgogwb488o37SRUANb33U3F/ABcxNHaWozWuJhENKcaC35jIGLTDnHjnxfFHXLEzQ4QLdhTI2Gjgyhnaqfpge4vCPg3iG5cjKO2PRy0aS4RwH9eI958yCBDdjUVlW+rQIV0a2i9sZiiRJD0ib1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UoxjghNu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=upQfRgtb; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UoxjghNu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="upQfRgtb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784719848; x=1816255848;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=l6ez+bCaU1kfsGhTpSZXkDmj01P68JA1cKoQdBA2UMQ=;
  b=UoxjghNu8cr72KzXe6Y+TBP6nk2cUybbMpuViabYLD77LNPlG+kyjTAM
   WL4nTQCqYKCUv3e1mXJPpE6MlXfnJ5ioLvshb1uNSD1rRDDv2DY2cNu3J
   jgxpNmnBkTJathVs8hqYSJ/64lBwg7AhegsVjdF2ZMv4dSbcRpvHhBd3y
   HgZUCz1LBEztyAmlggxceErZR1zxx8ZEBDFmGI7hZqWmmqaa6OUHnPqMW
   9SessGbvwLMhhI/MCWcCwLQ63kGLjInPFroo36Is2nokZKO5y7mY4+qkO
   R8P05SiwYjo7L585VYmEDYiCiPxMDQxbzwDirXiAGqhdEowJtWqMb7lz3
   g==;
X-CSE-ConnectionGUID: 2rnAAKaBSdu7J8jEg9fWvw==
X-CSE-MsgGUID: TyQVJueiTWi7NkwLlla1QQ==
X-IronPort-AV: E=Sophos;i="6.25,178,1779120000"; 
   d="scan'208";a="152464646"
Received: from mail-centralusazon11011050.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.50])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 19:30:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RSQaxwAZOpztU5HsbOZJSrc6LcPVABzZLh/ZTOg7TBHdDqVFRBe7z9wb7ig7GuU88XXrJItBTDdNUgEa7543q1KW4kckFZKXsFJMCyQZi2eCGuMtNU4sUxxU+jWNORuz/rgaiwl0sTz8sngv/KCkEZuOJGdI+39mH6JMfV9Cg9x8qiWhhPDbOwjD6pKodUX37eC5XNYjOj/k8ZC53fQkHl+IHq2SBOjUtUJaA1SsU7EJvMyRx61yxx8Z64yTIIlIGpsvVPIHBU5NPUtfmWdyHOBs+vnPpuImkbwEh2bv0lOMJxyTAVmMXr0lbkZX3ta3hkvO4eLcPM6S93l/IBWDgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v01ntJcwqKaSNo1cM8tBxfDIA6nELvUPHpSyxodI2J4=;
 b=uScQ0LLI2pvbxIlkstK6wqoXOAeSKX3r4RnlIXwPV23J9M2Juu0FpSp1XnWvoqOLGHllhmZWXZ79ZoqgbbdnngiBtS1eueUw89nvmyMmUt6zSYZUYWgJyzxaeG/u/jZoByBWXjz4K2++4xZDsimEwe+sLdNs3tlthKSS7fnYaWpezEgYz3f+pJ2SojDPhGp2r0EjlkHRF1kh5xuN5bIavsdtgM4o6LajCZTwn4Ho7MdV/RjaL8/ialxNR2xXthZtGJvewXvPzldIihbFwYw/MAzUJCjLnUfGOgQMRKPV1K4Wyc55iyo6NVJt6n5FwgjJx0klMrqgcayVTrIlmQYrrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v01ntJcwqKaSNo1cM8tBxfDIA6nELvUPHpSyxodI2J4=;
 b=upQfRgtb0bIPcBzzLncYXiwkJAkZaZVP7sV44LonjMKJsbuz8KBEHb7ShLHmKcFbBiomgfJB4/pfVQVxKyvZTPrccy7wj+iy/cfEPFU1UXwH4CC8uPMInMGedmEPvzQlAUJPvT8X7prj3DEvWv92zBS2QiHAnY5OfU0ftDrG/Ro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6810.namprd04.prod.outlook.com (2603:10b6:5:245::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 11:30:37 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 11:30:37 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 4/4] btrfs: zoned: don't clobber the extent buffer when zeroing it out
Date: Wed, 22 Jul 2026 13:30:16 +0200
Message-ID: <20260722113016.1896990-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
References: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: fd5377f6-8c3e-40d7-b8e6-08dee7e4a6e9
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|19092799006|376014|11063799006|56012099006|5023799004|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 Hz0H4N7VScaT4oDFSHuwn+6uNrFozH6cB8CRRy/GL1a7dA8MgQwG3IZJYE2XBt7CaWEEGZpuZsLRK6mi1PGR+ZSV5hP66gd6cHfwE4gfjadXu9GtFfnQIimjsrLWbzlZq0YiExv72yfmFBbWHRYZnyHmLp+vRqcMJ+H47lEUojHPpdjIzWHW6cGcvtGCEuCsxlBLbew9LQzjowO9CY6lqm/IC1zJcI+dVUakntPqJuEhhEh80ZdiksmR/Zp8Qjb9fk5apf4w0EVNpNP/Fqt9svGRrRZZe+DEex6xF9q0oVF7UaP6v0iWmvKhnObtrLsWDuE7Y4kZ9JR3ZnQZ8ek6y69mFD0UfsLo9yHz9byrtHHLLGIdS1iD20Gv5ISE8it2EvDVpjsTUVLiVQexM4K02onOw2qqSdKQhLNIw8SuCmRlNxPTx5n1LA37ohoPcXXLO2djxZuUiSth2lVWAEnNV+iA0WU6aKUk4S97WEEKdGK+FaB8Rc/649y/YzL5+A4x85OeWc5OovQQMEyHMuxsyhsVRHvVhnlT3pHF0mrHcO+SPSn3xxyUu0rUTXl69z4WyYqBLeEasBgv7E7oHJS8ceNKvaoDDojSrcEuQMbH3VkPxgMC4ytKSgFMRsCLedz8LtrX66wNy7hNNaQtOpUwe8dH6i7HRevkiLxrd9OEpMI=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(19092799006)(376014)(11063799006)(56012099006)(5023799004)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?N1koOZwG3cfqtjjD56TsdTr0rvzaPxNzme+PmB/mC6ozv/zPGt0xWOS2Le1k?=
 =?us-ascii?Q?myI7h1mYzWyRey4kCfMqgqNdZbusWdqsw8s/ghRInvsjBma8psIJn9h+IEGg?=
 =?us-ascii?Q?RIL+YQ+FcfWwilBvu2olMDv0XdZv6wpgyUnmd3nPPfhJd/LfpXXxrvPXNmX+?=
 =?us-ascii?Q?/YnwOvQL8o+qzE2e12jGi8VYvLTn9bbk0MslNwqOAOrNQ7bXUucdCev9+9pU?=
 =?us-ascii?Q?yRWh/Oiv00Ox2Tq9b01TDqEP5L+jTK8af3MhnDpfwK8WngyCTVISKu+2Ch3g?=
 =?us-ascii?Q?W5teKqZ7mYAZG+7I3n+ktikQNM1xag7PMl3Yz+3xBedbQnMoSWcBTvxnpHNV?=
 =?us-ascii?Q?qGGZDFCea0+T1LGQWevJ8eLCOkvlK/wbN/9F1iTN6s3830soq9cOYP/1ULDq?=
 =?us-ascii?Q?csO/jUmAhcMjCKn07hmeoQQ6jeXXY/SUl23DIOFd25RPnqfMfW4Qu0S9DdUr?=
 =?us-ascii?Q?iNIpIlhoyzrqg2eyuLdGCSiO34MlfWZkStMBIV1hS38gu4S0zbLCD8SK7d5s?=
 =?us-ascii?Q?Wdtq+Q+1VOYeb4brc9yibYDR251NiLG/1UGglakH09BOm52GizKM+/ybDp2K?=
 =?us-ascii?Q?z5/hTkBEgXr2NJqQFiXW/zsAkZQ607x8zfBZvfSfuGM16g9zsWMg7FRbe8V5?=
 =?us-ascii?Q?Gi9kr3CVqpQ8jtZL4gy6QyRBI4Du/ghPxgXedLdakvjehszcuymOpQ84qtQQ?=
 =?us-ascii?Q?JOpEB/cfTmEqJIeaIEqycmZrEiHVf7ZgJz+j7GohMeciUU6p9WrFS7whY28H?=
 =?us-ascii?Q?C710mr5+cRhIn07JQAw5W4b791B9ECMdVu4NVm44gyVGdjMCW7MMyB/1gGLo?=
 =?us-ascii?Q?a7BIL9SImYO1c4HoDDIG5KVclA9vp5u+J392G0vVVAIxTb3izJSrNoSRsXmC?=
 =?us-ascii?Q?6jj6bg5j5vuuhZ6KRSP7Zvl/w0M0BEUHTyrOtBIPNGfssv/hmQsX7fcLds9K?=
 =?us-ascii?Q?Lru4udto7KBi+rkvfMQeK8zQvuzhKqXvdaURhOPw8X1HkS7GNC6nAFApbBGH?=
 =?us-ascii?Q?DTErkNdAArISB+l+c9IxT06AmtEkVYtEa94GWP+miuAwQ8IH7sqXM/Ig7oz4?=
 =?us-ascii?Q?RxnJ98mHCPtYlt2cTlR+o/8HfJZoyZhLphednHFROUuwCpFAnp9/ReDLiNBu?=
 =?us-ascii?Q?lRETFBxRX+51yQuLWNwklXhW2YDMLEWLkiiMpiI/sfPZp9snJ+dly3BaOi8C?=
 =?us-ascii?Q?yXFhokjrvds6rI+ITY0uLsFHL7THhKd1kZoPZKudT+WVxFYIU5/aubhIP3SD?=
 =?us-ascii?Q?nYh9o0rbzFT1aQqkLokLvrynMJfWIPLfzDKfFoDm0NBqU+JcxpVhlA9gS3Ur?=
 =?us-ascii?Q?0zOkrLfzMEkEV+lwu44+4YlsBMoY6Ksg5h9VY29ubpWyZFejHdj5SqPCIhQU?=
 =?us-ascii?Q?8+MNmgs+AqN0IyqTbFFVlvGfHnfEt1HCas0eEIy9MNn8Kuzpsy4KFf99w6nH?=
 =?us-ascii?Q?HcaCoJ+FcgUgUvSNjzv4ybsE+BBLXMqOMK/6iS8bPA1VKIIgxSw6jy/lUUu9?=
 =?us-ascii?Q?2RCBw6BhA5EX6ESW31KGIgLVSLbCwGewXC0ZyvF7kHsEJWXqbiOPM3uvh9p2?=
 =?us-ascii?Q?oXIET9S6zvsZm0qWCsB/NplV845flvKRfUU7zseDcmvo0U1g7Ivw28R6Kitp?=
 =?us-ascii?Q?OzoK70HXFZ1ngpbV2xx6U9KZfxqmRoQoTQBUJyAoVLFUFZxIVPtc11DbWXG/?=
 =?us-ascii?Q?Ap0sS/k3XCJ8ZBxzhzae8nuBJafZbUNqd7IGyhGf9K//h4EW4+yjFzbhx05e?=
 =?us-ascii?Q?ww7y8BRWtzEvuTKBDZc5yy5RHEs1Jj41kyIHi8g0UAVDgYvMPR2yi8+VAtJ5?=
X-MS-Exchange-AntiSpam-MessageData-1: heaAJI0/Z/i1wg==
X-Exchange-RoutingPolicyChecked:
	VGAFYO4We5PPQfP1pXxpqD1ra7RTxYfBuyScG3/j44esN5o0/yzipPzTaWLhibXbR63QYfbp2fEyvM0jaBQVALxRwJnLJf/NZ2gwrKuD94z27Mzu78JmhFPf+J7/777rL8xuRp4zLJ3ji7saJ7htAtqdY7NLf5vkjpLL7FlQXO4vUxEg72Bn7IAQdB0rmm6tA2K+Wqcc+Q3tZfU0O5kjzaYdUXxOOIy99jErfJfSVK5UqBi2HHKGJz978XyqnoU8L11SZAKvrCODXyPr1HyZTll5TUV15QeUcYW4AyAl2aBcs81IkiyMv31ncZO5fLbNYo8cRVY4FIf0EeICFNCTMg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lIykd6AC0ECXeCV+fd/TqES0XWTLb8y4DR4gWXgOc67gCL8Dwp00JUxifSAr4EtwsdC1Fg1F+Yl/jNrtSVM5QyASJQJZMfhRpPdRdwdSGEuiQsrW9KsaBpCBMH1kT3FYLdmPnII9hZJnRbW1hfn+V+J1F4M+xFhfelQ63r3boSbA4wzph6A/DHjTT/UKqdZQtceGAhitIm1BhiK4I452SfcIzzjjKoVA7Qyr8D4Bhs3e+3bso+5UHun4Bo2iS8APepyIfMkSdXqjXmmdQpiewQtWrGeTsd16AZjw0xQSNzAQfm5G5nT/R4y1sbw1t3CKP9Oaap+MrqL6b8Nsdkn6SZa44omCSFka6d8CG0WgM3fDRgtFpTfNrUfp3N0ccrEJz5z1skzxyoT0jKrXXTsKvoCv4RuqsRAjUQ3mCSfZ26lMRPa0rKMScLcfBj0kWReG8uTop0IHjP+r4vvEj/fqMn1XJbRib3VZGyEZEdSZ59kwIqKFfmSjiaVSsnousi6eqE9kzr1mHJY8EAFeavTvVvZ0DTyBhcfniFzW3C84CL1wy5YCCdg6dqjEsDd+vxprgKyOGcDiMcEfuejzOCQ1DscrGlg7ya4hk9m9YsfTLx3axLjmlhFA0mncc4+OW/0Q
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5377f6-8c3e-40d7-b8e6-08dee7e4a6e9
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 11:30:37.3833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APFbTS/LyInMmuWPvk+drr+LdqV7AmWqa6FB6vghvkaxTYsO5xmnz2Iqkskc8DykrbPB0yg83hLEKYQS30fLFFAyAeoSrvcAE8kSVRTGkHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6810

On a zoned filesystem a freed-but-still-dirty tree block is written out as
zeros (EXTENT_BUFFER_ZONED_ZEROOUT) only to keep the zone write pointer
advancing. btree_csum_one_bio() implemented this by memzeroing the extent
buffer's own folios before submission.

That destroys the in-memory buffer while it may still be referenced. In
particular btrfs_free_tree_block() can run on it afterwards and reads the
header to add a delayed reference; once the header has been zeroed it frees
bytenr 0 and corrupts the extent tree (the btrfs_header_bytenr(buf) != 0
ASSERT in btrfs_free_tree_block(), or an "unable to find ref" abort). It is
flaky and reproduces under fsstress, e.g. generic/461 and generic/013.

Write the zeros to disk from the shared zero page instead and leave the
extent buffer content untouched, so any later reference - including the
delayed reference from btrfs_free_tree_block() - still sees a valid header.
end_bbio_meta_write() now clears writeback on the buffer's own folios, as the
bio no longer carries them.

Fixes: aa6313e6ff2b ("btrfs: zoned: don't clear dirty flag of extent buffer")
Assisted-by: LLM (debugging, commit message)
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/disk-io.c   | 13 +++++++------
 fs/btrfs/extent_io.c | 31 ++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 48374cec77d8..4583adb50367 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -271,14 +271,15 @@ int btree_csum_one_bio(struct btrfs_bio *bbio)
 		return -EIO;
 
 	/*
-	 * If an extent_buffer is marked as EXTENT_BUFFER_ZONED_ZEROOUT, don't
-	 * checksum it but zero-out its content. This is done to preserve
-	 * ordering of I/O without unnecessarily writing out data.
+	 * An extent_buffer marked EXTENT_BUFFER_ZONED_ZEROOUT is written out as
+	 * zeros to preserve ordering of I/O without persisting the now
+	 * unnecessary block. The bio is fed from the shared zero page (see
+	 * write_one_eb()), so there is nothing to checksum here. Crucially, the
+	 * buffer's own content is left intact: it may still be referenced, e.g.
+	 * btrfs_free_tree_block() reads its header to add a delayed reference.
 	 */
-	if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags)) {
-		memzero_extent_buffer(eb, 0, eb->len);
+	if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags))
 		return 0;
-	}
 
 	if (WARN_ON_ONCE(found_start != eb->start))
 		return -EIO;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 042093470312..f1579633a996 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2266,14 +2266,17 @@ static struct extent_buffer *find_extent_buffer_nolock(
 static void end_bbio_meta_write(struct btrfs_bio *bbio)
 {
 	struct extent_buffer *eb = bbio->private;
-	struct folio_iter fi;
 
 	if (bbio->bio.bi_status != BLK_STS_OK)
 		set_btree_ioerr(eb);
 
-	bio_for_each_folio_all(fi, &bbio->bio) {
-		btrfs_meta_folio_clear_writeback(fi.folio, eb);
-	}
+	/*
+	 * Clear writeback on the buffer's own folios. The bio may carry the
+	 * shared zero page instead (EXTENT_BUFFER_ZONED_ZEROOUT), so iterate
+	 * the extent buffer folios rather than the bio folios.
+	 */
+	for (int i = 0; i < num_extent_folios(eb); i++)
+		btrfs_meta_folio_clear_writeback(eb->folios[i], eb);
 
 	buffer_tree_clear_mark(eb, PAGECACHE_TAG_WRITEBACK);
 	clear_and_wake_up_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
@@ -2314,7 +2317,8 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
 	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_bio *bbio;
 
-	prepare_eb_write(eb);
+	if (!test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags))
+		prepare_eb_write(eb);
 
 	bbio = btrfs_bio_alloc(INLINE_EXTENT_BUFFER_PAGES,
 			       REQ_OP_WRITE | REQ_META | wbc_to_write_flags(wbc),
@@ -2334,8 +2338,21 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
 		btrfs_meta_folio_set_writeback(folio, eb);
 		if (!folio_test_dirty(folio))
 			wbc->nr_to_write -= folio_nr_pages(folio);
-		bio_add_folio_nofail(&bbio->bio, folio, range_len,
-				     offset_in_folio(folio, range_start));
+		if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags)) {
+			u32 off = 0;
+
+			while (off < range_len) {
+				u32 add = min_t(u32, PAGE_SIZE, range_len - off);
+
+				bio_add_folio_nofail(&bbio->bio,
+						     page_folio(ZERO_PAGE(0)),
+						     add, 0);
+				off += add;
+			}
+		} else {
+			bio_add_folio_nofail(&bbio->bio, folio, range_len,
+					     offset_in_folio(folio, range_start));
+		}
 		wbc_account_cgroup_owner(wbc, folio, range_len);
 		folio_unlock(folio);
 	}
-- 
2.54.0

