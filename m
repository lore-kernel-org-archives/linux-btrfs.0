Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ABA3C1D44
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 10:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787047258; cv=fail; b=gsJAgSCdBv5N3aopP6LLDTyRQkT+Oq5PQrvXpM0TRDTJZsR2QuxTKgPcdxrs96foP8Opdw2Lg3jhwXam8+LQdQY8l4Q/AeSybTEWl7H1SZA8evliKQUt1Wk9YfKFNy+XY7B8D9hieSAUX+wHxNZcZ/aaxpeFQuz443YkgqqcSwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787047258; c=relaxed/simple;
	bh=/B7IcAnx9riy9eUSb5gX2pOBDff27enooi9y2iZySeM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Noejlzd9sTmy3EhTdaCFZT1YfizxpgQuvzPpF+yq8Hlds/9ASwZ6Yk7FdXTfQ0GMhXOtaCibuo/fr0/K8T2PTWovhaii5kSffM3OHwLwH7MRrUyTJi3mFPGFcn9Uoq6iKufmBOIWA+gYouNhGlRSqnotSBCgH+QlRXdANzaFPDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=OMM7klVL; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=AzIl+D9Q; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OMM7klVL";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AzIl+D9Q"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787047257; x=1818583257;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=/B7IcAnx9riy9eUSb5gX2pOBDff27enooi9y2iZySeM=;
  b=OMM7klVLzH26M2JEnmiYxQ/Xtb/rLTFKOQjfYMrJbJMi7urQm0I2wNqt
   WlLH9dxwynOif1tccXIRXq+9LBC9ooFBaKP6vYRMPNz8Y5hLAFXwx92cC
   0IBj0GKmTUdKr0OkChgY4/UDNjVZM6jR04Pd1OSWOCj/4mYfLkGoXu5Ye
   RDcQpwBJL+b60tbBhD0qgAm9mPHaDXvQ+dCVf1lIW2bdiulMGXS1I+yOL
   P+y6Of5ixLjBPonlmqi/ZvBRhR8ejySAreQMUisIJ2MVr/G3je0ZfEhK1
   LHnHhCclCaWuGV537wElc1dCh570HGUdLEW/KyXfZ4XfSNFwk0hAP+k7A
   w==;
X-CSE-ConnectionGUID: gileLyKmQfOTsnXcvbcaLA==
X-CSE-MsgGUID: IjflAvHhSyG6zYvG6HJrAg==
X-IronPort-AV: E=Sophos;i="6.25,230,1779120000"; 
   d="scan'208";a="154420488"
Received: from mail-southcentralusazon11013054.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Aug 2026 18:00:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YtpgBc8grTVoXFdSKdnWaxX9mXQEqweDgELr70lPQwrjHczvM454cNMBJ9jerO91WMbEICjEuulPI6BVOgtOsAk2JO1ZmubvyqCj7Vaq+lN/A2M4NRHBio/uJqk6RnueyPCCr9QxCJ7cXMTRK/prwwTbvE2RA3acDIqCS0n41YXTG6mG0mgHUPTlDmtkIBw22BLqLTI4c8+pPC5dXd1qQjoRE5pyW11rx/ZVTZPJS6dC6QAqx7se9+FgxzGaRUb18U6kRodxOdqsytuhfflQ88sWd6zjbdiviAFjgs6poN61tFWxD5nd8Fym2Y4ZjxbMgVW10gEEjLeuVkQ3Mjx2xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14WKvetWb7d7YAp5TfM2mQ1G/GdSeQlQ6e2atVi9eUc=;
 b=n1oj0HQSyjWZfeRoWfPojJ6kcXCyqZ9EfnEBoKEdOpXH9X0ogtrm4ozoqA7Eezypt2mVukQRT4k4nkrc1FlQzQGMb4N+RC6bBwEXcGRdjdmYbzAoeKBxlMXLLtWe333VjEsnoLb8r1kX20fYfaBhDONtnLkBs284nvLaepYcRhfvIy50BtIR/RcoRE141dmb3Y5UyuI/crb4wDzXCFtws/nds0k2Y34Yrgr+0myGufxYMfSjKMWNeYZvYqNSDA+rAfz9wEy+c3ceSYPpJRQ25IgbvLDEv6dosHShaUd37m/n+7nm+pOP+L2UQ62C4uh1cc3PQCT14QjyiYK+Mr5Dkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14WKvetWb7d7YAp5TfM2mQ1G/GdSeQlQ6e2atVi9eUc=;
 b=AzIl+D9QH/tpDC8AALs9fESPWF7W0jgtJMZRbS4sl1nMttNAovAdkWyG0ekG9h0AXRSK8Hz/IMpXkzHWfLxqY3w8qte3JdzZa1Z0BALll7hcmla8/DLx/5gg4pYpWNyOuTTxTDJ/kAplmcd5reYRHGeVAiJ0IA6hIYy0m1A4bhs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MW4PR04MB7330.namprd04.prod.outlook.com (2603:10b6:303:71::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 10:00:53 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 10:00:52 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs: zoned: propagate do_zone_finish() error in btrfs_zone_finish_endio()
Date: Tue, 18 Aug 2026 12:00:37 +0200
Message-ID: <20260818100037.1366563-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0344.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MW4PR04MB7330:EE_
X-MS-Office365-Filtering-Correlation-Id: c8b0573e-2ab7-49a1-bd77-08defd0f9629
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|19092799006|23010399003|376014|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	uQBaZsZu+vdpbe6a/g1XRAjRoNQBuLN+b9l+wNt8IUYp1zB+wQkWvvGNJRPu+Ba/OTrc72KE1mYMe+l2SK5ffKX67jpM4ZrUZw+Gmb+IX2K7Dzo7AOxWkWBjXkWUO77YrjjV3OU5kBWx97N1ySiCkszcfoRHXgSDL6HhR8CaE9pBYB8JmW9NoWUAfssVYhga/9Run6OylZFoLhkwGkBTJN6YrmDR3euc/zl13fPBjMjBdodlLVopmhoxvwItlaiiyMYxxb8WanN2yVoZEsWIWEbB0ORq61KXkEq64uG8ANnHB8O1S9O6YwPuUzH2+/URXgwrxNjceDUiTqlfE2GnWM8M6Hnb00fbQN7GG7Gp0JFREkYudMgVlnG/riPl7eRwSV5NWf554w2xyRLBhZZplFeKl2tMceYIm6JF+MePRzrfTsP4yIvBQ5nSKWHHiGib0AxDz9xqztLa+fSswSQUxTUKXgIIBTWuYKkoHEkB6Mx1FpPNypt8i5E7FLE40gD84N38HhkLOfrFtmz0emwipqZaRhS8uf1tuBPl7rw+o2/IQt764NQczyLTG2UtB0teguIonbFdyS5ML/WUhjiSAkzkFu7L7gaZFp/yaq/jPFWLIHazKXkGGgGYYIHR2lhk5yZkeVctIsohfLPf16chTEfXSn40NACOnTJPIai7L2A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(19092799006)(23010399003)(376014)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cQ60JIW1GirYigteVPxapB2i6SH5C4YcyC1TbwFXXnhQwBfs1TBNem9yNCpz?=
 =?us-ascii?Q?w2zdL8KylFw2j5r0svfe0b6vkUUeuTdX7G32TlUlBwW2z54+pNYZpSfi5jj+?=
 =?us-ascii?Q?tU61sjghnJ0VCYtiCjuXwOLL7niIPXfHfIWjXxKmC3VObNa9d4AFJ8U/wM3j?=
 =?us-ascii?Q?cn4yFRz2DqSlfF6ZbWGus+MDePsMy9i6GIkbrODYezNJM9pmuAs0W8kifLPY?=
 =?us-ascii?Q?ZjXK0/UBw7fzSD/KnMv79Du4Wd6kFvgNGYaVH4xsdfjC/gKS83cfCF7bmjfC?=
 =?us-ascii?Q?1Gq95WWpOuNDGXNPgh6nSK3heCq/muM2S77KlZDwD/2HiEOzro3IUBZ8p5so?=
 =?us-ascii?Q?DPglSTbBC13ollDPALrsAZzT3hW/lAe6n5xmOG1qHDuxO/KoUuob9AEpi5xO?=
 =?us-ascii?Q?JyA4c3kCo7iZ+sDFWQjVuVqFXpyOCj5JA40/mP5XaiNqbP+774OUzqtST2Za?=
 =?us-ascii?Q?ADoua7l4a4cFr/bm+CDrBAksoTMBtgnuz5kHwTicSlbMZrB/Bbx4zEHj2pm6?=
 =?us-ascii?Q?Btrt/r0209xNhRzf2KTu53tHGJiT0uNDwtDJNsVOG5MaFDc5C6Trk4lQVl1v?=
 =?us-ascii?Q?nYnwgDapEWDmZFTzcF4KtWA2skxbcQzGf8uxbOcqNYHtXiY3eKMRz87K2orz?=
 =?us-ascii?Q?p7QVFaIFoDlo6LiVo+nkO8CrnOqhi+3DkDVm/02BvrWl9OemC347ZGzhSJSk?=
 =?us-ascii?Q?lyBHAEBBLVrv2/YoCl4tUdY2/Iu7h/zh45iPpWDaPW/iMPGkPcw5Tqm5tcDs?=
 =?us-ascii?Q?NsIE/yZtoYxwCSVd75y57vAlpWYn1Ecsbb21twOhrj8HNxk1GHkWp70DUQFO?=
 =?us-ascii?Q?ebPAc2TCMfA6EdRDo8gRabuB+7lbz7It37XZZrjEsFBmHK2sc/uMfXFsYv51?=
 =?us-ascii?Q?+2hDK3nID/1HLq8WMJnEdAMIDmWMOyfJkfr7LWVFmxvEQliDpUY4piFrhEEX?=
 =?us-ascii?Q?827R+tfoKiZFgMiztwRJc4+Zt1BlNA5KSBWprE13KoOn/rorLDtgzHgBYLd3?=
 =?us-ascii?Q?gtAyMqGpGskYz4azFlY8Eeu//DWmxwD1s+SF7zY/xvpov7itCxi7gOELhqnH?=
 =?us-ascii?Q?HlCg1kjEuxW8Qlm+XA8IulIwBDKKbnlfwK+Y647JidGPnM4TK0Z+ZFTFINQ3?=
 =?us-ascii?Q?gC/todeuyGAwnMb9uCrsSeJ0lUO86ukxLdLkYGpXoXroHji6AMHOOD95E5mu?=
 =?us-ascii?Q?DBkCurAQURprbSZeBqIIKOkQeVFLMOPV7tB+ahVpiZsk8wbbWbgzpvZb8sCW?=
 =?us-ascii?Q?BKYzqw0G5ZHUuRRj2NYTXe6OdwlLoTMFR3P8DITd9HN5lfef5yI9piHmMPTh?=
 =?us-ascii?Q?/xKgE3igsUGacbUjWZ3qBSrumg+OBCeMeGHTC9ITOxIQSkYqgwXWxTc+rkyw?=
 =?us-ascii?Q?H2OCDSRPM3BpTz4fh3A4Bp4U+eacJ2Q5yA4VcJVNsOv2h+szqlifaJpKl9+B?=
 =?us-ascii?Q?bdseVSAfhp00t9KJiRh+qX63oPSsj7DZ56uR8lBfhJKPc+njorpChXBrD80B?=
 =?us-ascii?Q?UI+z2rlbUdxafjmjP3yLavbcA3gvYMBQQVvWI0UPfTdBI1Rvt59LKdoOVnBZ?=
 =?us-ascii?Q?cH+kkj1NTdSzQwjKuAmkYS2y0iqqziCKSx5m7ywhUEjNLIJ+D3s1MHogDC5i?=
 =?us-ascii?Q?EyfUCAIdWC4csugTI6aKIa6rZgidDyaWeZ6BNWXinre6Rpfmy0DJfnJ1KdTG?=
 =?us-ascii?Q?a3KJA/h5V0SHbe/nIoSD/xUuRbj5MOY3zko1LvEdA/0TpxG9frfMqgB6hvkH?=
 =?us-ascii?Q?/ilySj1jlgtIVcVWHbKFG+eg0akDhNDn9i3E96A7JbmDNEhqFnQMcadh3ghA?=
X-MS-Exchange-AntiSpam-MessageData-1: smjWF52ZR+iJ9ekAIUxy0vv6Mkaf94vKqUo=
X-Exchange-RoutingPolicyChecked:
	s6lqeBHkHeQ/9ADaF9NWjIudQ/kLywuZDh+uZ8czBvKmgshPUKMgQ3k0h2It/ugqSpFhfJZvqYuMmxA6pGdWvbG4bBD6F4QdCTePWAQ3ITRZwBjslBvF7jBlPYt2uK9us3fLIa6nelIgIsKBzJnLlQUO4BleYCUP3w49qtLrw+QAFQUlFBDIdiDSoXH/sj0ZZuWKz56YCJIdaGBtZWgp7wHIczrgBC5an3d4PNtPi1AspzO2IrbKaQFwGTIvjX3j3nBXP6NeTP3MFOJVvbAMXtRPoQR8P7e+dmCsL2LbYfdjpTC+H7Unfg8RSoYrvfBy+V4iS0WALbcugIQRJsOj7A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	14VoIChPLAZZJpto+5m5l2/0yJiX1EUzuYdtljhbPov5hehKrc4WePPc78D9JUdSpKFiJRnkDk1SEHl2mnmRSKLDv7zkpVu3xUSHiObZX8D2ENrOcZP87R/jqpZASlu7m8md5ez7WaqXK1UgMkzuTL0wSSGNdvbf+pEANzmJWfztNu9XMdpD/YefxfljLICBKDScjXqG1lLa5ZBK8wM60BTNkmWTHIDjC+6CRv+MqdEmkti8+IgIeTR2INDhtA59yIBlVrvUdRTssoB0SwYMOpPz/oVzMHT99RpceJnBI3daalshmXVPn/NMgpaVTon9/Qze8kR6uQKUzJhe4/O5OkEb0leSGwZTDfVPXbVySiCaz0fmWsBpt72GGySPW3iNBaQBDIE9qyIyi8TDI3/KDm7ZG1+LPMzxefDIBbOKFw1mdl1hivUYz73F4Wczlbd2f3Dg2vfI1dLJZ+MlM81FsF2dZUAY/gRYfXcQzD5HEFc6ZsCxE5RPu+TVQ5UwgUmqr3NtmxXWWeqDy4giIfyEFnKmdcpX9Dw2n4byzFpgdw6zE11fcYdMbQi0kfVeJoDFKqVbkL+a3eHpZyz3MWtg5XInlYHMVew/aSBVc6wsqWRNyeYutudo3ceQ9mfWJ3BF
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b0573e-2ab7-49a1-bd77-08defd0f9629
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 10:00:52.1912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TsYFQDfB98Q3DMDJBsUauaJCrkt6r0tLUf7JrYk5ofXYC/xbp8f5j/XT3TIUEC4UOhFHtC7kYFME96Jc3xOKTJEN2P5i0/0X3/AoxeyHOig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7330

btrfs_zone_finish_endio() ignored the return value of do_zone_finish()
and always returned 0, silently dropping a failed zone finish.

Instead propagate any error from do_zone_finish() as the caller
btrfs_finish_ordered_io() already handles it.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a016cb471beb..82c2394dd43c 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2713,6 +2713,7 @@ int btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 leng
 {
 	struct btrfs_block_group *block_group;
 	u64 min_alloc_bytes;
+	int ret = 0;
 
 	if (!btrfs_is_zoned(fs_info))
 		return 0;
@@ -2732,11 +2733,11 @@ int btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 leng
 	    block_group->start + block_group->zone_capacity)
 		goto out;
 
-	do_zone_finish(block_group, true);
+	ret = do_zone_finish(block_group, true);
 
 out:
 	btrfs_put_block_group(block_group);
-	return 0;
+	return ret;
 }
 
 static void btrfs_zone_finish_endio_workfn(struct work_struct *work)
-- 
2.55.0

