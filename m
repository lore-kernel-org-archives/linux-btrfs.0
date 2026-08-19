Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF67364E89;
	Wed, 19 Aug 2026 13:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787145442; cv=fail; b=TsDTPigoGKDurShOdShd0x1lByUAQQTSEZM607gurcmI+LQ6dStaPsYbhRLuJ2Q+b4z/WrSOTLbb4YeOAxzBhqaeJaj6VvB88Hc+q7CTJDFv/GefSQ9a+0FZqoCqQ3zV+SObK+KNLTvg/3kmIlL9KyuadTIKlkY7QgLxYnT1lmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787145442; c=relaxed/simple;
	bh=VkfCwTaf9jtj9QWZToQ0AQHddGlXhjhmp4pP++ESI+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FkPgQH7I3uzRBKVALkBmVZp8mXZtICvAqO8iFGXE8JDs0os3+4rqD21Gc50F/LgNz3moKEAZiQ/v8Ar6O1DVsjagnzD9x+P7t6+Povy6V5rOR2hBYDxa0xxqbN99goXE7WUWyEZ0ZNJY4Uw43hKmx1IKj7yNOQSzqt8Zi1ujCGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dS2zoyn+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=qFz6Vcfy; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dS2zoyn+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qFz6Vcfy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787145440; x=1818681440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=VkfCwTaf9jtj9QWZToQ0AQHddGlXhjhmp4pP++ESI+o=;
  b=dS2zoyn+64HLa5hLKqg1ngaubvd/6uDX1PS0mDHA4oNQfR8hXTaTbXfz
   hSrEz5uytCMbxMXiDWRcKGlxvolbEWXLO3qcWjRaB9qpk+zrRGuzAJYuk
   NUe4yQK5wWGN1hmFAX/h+84KaJYeZ5jpptxF6s+spWtVdesjTpJwLfWof
   0/Jvv2UTK9XcN9t7KK4zeIsgqAHoFNu11r9s5piiUCg9mhX4pvPGQVz0/
   ic9haZDua0NNCu7A3d3zkIzPWWMIqJ23u5Gnfs0HcDZzaUL0xqo7miZY0
   Zp+PXS0TSMKiqW3M9wrnPlvMxzAgWuBp4/BQARpbvGdsnjdCkqdoPbI/z
   Q==;
X-CSE-ConnectionGUID: PXv46in2Ttypjv5Udcy43A==
X-CSE-MsgGUID: WRd2mPMKSOC/Io6mlY45LQ==
X-IronPort-AV: E=Sophos;i="6.25,231,1779120000"; 
   d="scan'208";a="152276628"
Received: from mail-westcentralusazon11013060.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.60])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Aug 2026 21:17:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E75cYddBsHC1wIm1y2UTFhRNNvEI85yx+HuzniAv3AeNtdsd/6V/4x79QTbQgCHfOeaKAmtM4mOOWDznnZztJjYmUXOUXo+mUSjOb3+Ex6pixEqg61eyxIV91gfA6jiMskgqETOO9sYzzEz8ylFo6+JsofcAqs5DSz/U3nsmdKL5yxmDzX02+WUBqtjL7bh1rh0e4kZv5bNnPQjTZEB0dNr6RJ+0M2/f5hKvFMt1G4Uq35jF5Wn5fXI50IPM4bcYg4VRagC2keSO5cuBEl6uXGcyOciVkaIMsRDNSccDCfgh9iUFB6uTNikpW0cq+yuVtqDVhjBvS48ZRG81oUCbOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQnQQ6QikJJkr1bRLoRHeEYI8Z/+zuumQ0rIYWdS9SI=;
 b=lmvDEYifpZp4kgGdXF7nD8IFRd7snL8eveT/t0viz6xlJezOMcRftD2HkY0lKAfQ0J/+W2h6iDekoNWG8nz0UYEO3maLkLMkuXmnjIhRSH/tXzf5QwPSA0rnbCYPpgRNJ6h5LxpxqTMQcwXW46aD7GuloUHHlMcgQvUz/tFWFZ0BLxp/yDjtWRVOiarSpx5V5h50RG62LjCT/4dTHlUNiTtIbCJoYRsslwTSRdmQUxukpbuaVIU6uHTqedG/D0mnRX8suqBmdKpsWLqd6bw0el1mpoywnvuO+EbYVaHhczvDRadk8md7rMkfMQxwzhY5bxuGAYRiiPAe2VVvi4MFRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQnQQ6QikJJkr1bRLoRHeEYI8Z/+zuumQ0rIYWdS9SI=;
 b=qFz6VcfybxlKTA8q8TtyiQDlOpzmm4gY6wzyigX/GK76dbiPF2/l/e3AbG7EgqlLeyZivYSeMxAXwvkw3642QTIDEe3GBnYnH+A3VT52NYRS7o4C5QS74MRQB37ly9uWNYc3A2GcbEMoTATnsNzWfwmiqoNPIlaDLmzS0zDA7RY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA0PR04MB7385.namprd04.prod.outlook.com (2603:10b6:806:db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 13:17:12 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 13:17:12 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 4/5] btrfs/284: skip on zoned devices
Date: Wed, 19 Aug 2026 15:16:04 +0200
Message-ID: <20260819131606.1478488-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0396.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA0PR04MB7385:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fcc2a12-8793-4875-f63b-08defdf42e25
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|23010399003|19092799006|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hsR7FJOf/iBYpOOU1CR+g0AxdC9zyX6pCm5V7aPdOwyfC0wmFFKp6KNDpVdncc9vl+U6G3Z9HepUKejd8RkLvG+tkL1ZrVL+L4835MXrmTNSxsoC0LlxFIacjrzyDw8JJwn7HQYOF1Hd/c+itif6anPRpqcN0rGIe1gz+sn2BKJQZQy1/guTaTyFH8m01q4M8Hw1ZZZ0nJ4IPsT6ydfgf/+Jl973XjMTM4ZM8TCe48CL84rQHLEb6qZK8PMons+u+RKTbBP0EN6TdvnGLNmQEitjcth+FDhcvm2WXTWhVmkpzZ+ZYBAoZkhyJRPTn5nnQrCb3wNfvuDFFUQyU26LFWojVyhvX1EXbLfRQjinWv6VUybSG9Z9DPFrhJqXqWWJ026ABlbmdiWxGBq8HgWnhxzM4DdGrFe51T9R6xRMMtBCAyziHh7RHchjiIM0XrhXoYVcgkRW2kXNy4/wmuGU4GnVGJ48wXKPO3HyigR04mh5/asifNkCxnm9Hrgwlx/BZGYoyVCdB/9xpYm/XBsl62cRNt7J4/4LSeKOD7o+M9VlFdLiyPb45p44zaJz9Mj5nzU5rCrFhnKSoQp704Y+MnTXNClOGkFTy5Fie+DTzu8IXljjd2cN+Yo7QPq5ebVjD5FYwvCJUEtDeOy9tnwzaW8ke/XeNFYLTqeyzmcXBt0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(23010399003)(19092799006)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O5NXuPhw8VLCDiFmrZjHt/vjTgS2McPHepcXN6k0M6c/rEMbttTqvPQefCDQ?=
 =?us-ascii?Q?YA3RdKhPL1T/IBq3tuMkPL0w3bVpYcC+/p70FF7bz86GYBqXkE5ZeBMsqWG7?=
 =?us-ascii?Q?9RRT9nqjMAfJMVV5d+c5yekeQeeKHZDpS4CouzT3fLtmvQwUr82r7+3PiRsV?=
 =?us-ascii?Q?m5Lh52DfVLdSKBNo+Qp2bG0BvUDK0buWWYYxakCfyFpsnoleYm6bi4pIkzFH?=
 =?us-ascii?Q?52L6yG6bQzs4fvg6HLB/2VT7nY2RgV0jLsU8b2nuSyBcBXtiIvAYv1n38Bui?=
 =?us-ascii?Q?Ho2SNPk9cY0McX8/2dUPPhZaKYwtB6W0a0Iik4CsPuj5ZH0bSkuhQWS/NpJD?=
 =?us-ascii?Q?1bxKl6Os/woFWWtFQA15GyGY3vddGZcYXpsoyTxnubyYV5evW/jLTKf9TUbQ?=
 =?us-ascii?Q?j4W8w4YZDIxnjH/w02tTjqBNSLJEV6AW91OW8Mo2iM6cwAy1LAJWfnYWkmVj?=
 =?us-ascii?Q?TEmJ6AeXB2sfehk3QXhncahSjSnl1b3tzfkJsA9XR6JHkPNdT9x/9fDUSNRI?=
 =?us-ascii?Q?Jbvst4LREQMkAc1Crad7F4uvRQKfr82SRa+VbjinFFbPpITLacIllIOM0dxk?=
 =?us-ascii?Q?FuIhOuoCbzYsc0muPIK/vLKh4pDhGoCf9X6wE4gWyDRSFRro0JbmhFSaWfoJ?=
 =?us-ascii?Q?ZbgsPh6Lf8P3mmKIqK0oAgxUz2cEGBy2+0ZW0yVI0BQe6Cfijquzvxwj7zAN?=
 =?us-ascii?Q?/hJNkipK8BGXA5XQxA/Ie6BgE4uyqN3C/Ncj7jHRRNjRPPQg58dP20S5Y/nf?=
 =?us-ascii?Q?li2lAen+OnrfqDFzq4un3p70L26rROf45BnKb3YkaLfMrAZ8uUqaidg9hdaT?=
 =?us-ascii?Q?L5e9k3idvVIAW/y6066w0aBT/4tClkGwqqNn761OAKN6Ft8DAT5TyNZ5JzZQ?=
 =?us-ascii?Q?7qDIBo6BLbRTlD8875NiOqmSop+1y7VSCUTHbHf/2otbXfXyFuqfonkdHip+?=
 =?us-ascii?Q?3CbOryouFqlidslRsqD2yDqhPdFPAQ1N9WNGDshDYCyulyIFctDvPvd324zl?=
 =?us-ascii?Q?bf0dHKouv0XbJsjJRWSg1VnvI3nOGXQviiP08xKI6QqDRfM04La/2gtiuSTF?=
 =?us-ascii?Q?tYtgTnXyuTfS20hz0IzrbSJCUCep1kVmKcPAOVkUeaf4QbtiaN4OL5JFAew7?=
 =?us-ascii?Q?PC8S3gCfShR7zyQ2NbfxRPdXGA1W48jvwOobgx3H4CrhcuaQdhGOv0+c+OhP?=
 =?us-ascii?Q?y4MiwAFBTrvg7EWfK93usRSK80BW+yaaEOc95cWX34csl6g0K8QhkSxkrMJh?=
 =?us-ascii?Q?5iYrPSCAXRcsKMOv+CPqaVvao2/dVNdNmDkzpYZ28+zHkXiuwyIDJdfGDAAa?=
 =?us-ascii?Q?HmM/mDehzSSdzYCDyyuVP+yG0TzYYJKd6oA9qIe9DBNTreV3or0kXnsm/qxM?=
 =?us-ascii?Q?RbYSza0O2Sb8KdoVYWdoMUENMUJi9XVzimOftn09hUW5+c6zP810Bpe3ibkO?=
 =?us-ascii?Q?vpC6yM2uJjed5/lGHxEMLlRXflWOooe1+E/KCX8Xw2TNBjmpJ+G04Sp3ULHa?=
 =?us-ascii?Q?TcQ9dnSOfilZvFPhQ3rx99GNLjio6wTqKyV1G6zj02kbO+YQYNG4tsFUdrHA?=
 =?us-ascii?Q?ejkB8C/i1FzEFLyGxS+pzgM0SG7f176mHYU8gPP9TiuNzNxeX6nHqVA381qH?=
 =?us-ascii?Q?yguSCd4+dObESThlPA5prpHZJm4H2jmaroWMaam25CYYmyLpwkiKzff0L/N9?=
 =?us-ascii?Q?akotPHtmOdZbIr5FbKwOTomXwgmF10PwgQDr2h7jnXcVMWcmSJu9IgNE6aOK?=
 =?us-ascii?Q?dX1gkrGlxigPNcQtcJvt/od7Kv7tYjVrrJmw+YAl2NrlnRO/4nLDSTHwcdU4?=
X-MS-Exchange-AntiSpam-MessageData-1: uE3iKHUpaiVqkfWxXGFyXtaZMCK64ejvjgY=
X-Exchange-RoutingPolicyChecked:
	hUF8tL4cMu932bu0MKgAMThR2rHZrpnF2Bi7fAoptFDPxDCkvwOS+7nRRctcDQ9Z9SMaBVhz5dh1sdFtWFLdhNXSzaM606NEJsNRH0DdhsVlMrjsATgPXbqG3ofDrmXA2ae5GzXoYFl08tdJ48wFcelpUvXiAufMNx48Dxhi5d1UvWQLIa0vPPv7evPI0XNd1gVidkFE+Bv4yaxLFchM8q5cPd5m75FaQTAJBtcomPGUmbUbPVvd8cvDRcHsv5DK2XGa4lPMKih/VVeCTocSZtJTPQwFgL+KlieiwLSk1EZ4rSjZtwrzk4R/VrXyaOG2BtVkVJ3LEu7d3cn5NCpB6A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tUNBL7W3u4cx5Aeq4FVfI4DO3u2rG1vVP5AEsP3p+zfOrCxdUUl1nGewjtPYfl10uJwCRLRd1bL2jqTpSvGvAz+gGCoDDvcTfOUwDEl8iVhRUCNMhpGF4bIU9f5QhEbwNl9nKM9Fhhl8apUVIqS7957/heGxXiShjpI+sZaZKtpC8zSnEW3gj+I0Rv3zWdLVNgSSIfO7qNLKNOA2msCEzRq3bwIvJXfh/wdkkoGOl7qDlkMjOU5tUCWky/uHPYSnC6XEadBEsIG/bVBFnXoeH3sFA298H7FIacTXX9lLXPXjBeYTIde6OYZvnJfZKS+tbSVjSaMbyQHZjMpBqZdOyUcQkDmUfjVJnInKNri7r21sWc40kK1Ri4W7JPFv4xNKF3gYyrCN29KSDAUYhmshFT6sh//YopcRNt9NsC+x4QzdEF6SwvJPjyarOcHaT8G3PJ0n9mCNGXK8P59NS+s2MidiFu9i/YHshZed7vj+G3xZigiDzlGGSR8jSC1I9ZX18/11PRZuygDNA9FlZorS8nJTW3KNUu3JcDproNUsVi/xeIYsPEVVx6mZZ844hHxqg9bof6sZrRPUnhGRGqeDI3ziQAvKGziz2CD8aueuh8YnAvQfv2JawYkHYzha22/n
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fcc2a12-8793-4875-f63b-08defdf42e25
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 13:17:12.3915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TufiyAWaaFX7KB/O9M55GMhOn1uExEMtE9Np7FTwVa9vSncKBaKFAleOhBwexRQl8Yv+f/XDq/BRQxyihv1ssqtEYE/podsBBy5nxkrLiYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7385

Incremental send stream v2 uses fallocate(PUNCH_HOLE) to represent
holes, which btrfs receive replays. Zoned btrfs rejects all fallocate
modes, so receiving a stream with holes fails. Skip on zoned devices.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/btrfs/284 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/btrfs/284 b/tests/btrfs/284
index ec3bc272..fc34df88 100755
--- a/tests/btrfs/284
+++ b/tests/btrfs/284
@@ -17,6 +17,7 @@ _require_test
 # least $LOAD_FACTOR * 1G, just to be on the safe side.
 _require_scratch_size $(($LOAD_FACTOR * 1 * 1024 * 1024))
 _require_fssum
+_require_non_zoned_device $SCRATCH_DEV
 
 _fixed_by_git_commit btrfs-progs e3209f8792f4 \
 	"btrfs-progs: receive: fix a corruption when decompressing zstd extents"
-- 
2.55.0

