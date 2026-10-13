Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAC1397E85
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 07:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876724; cv=fail; b=rQYWALQLQa4hhtHBK50cHWPQpCrhaq6Bmq8QkyIRFyXbKZrvErYWFW5xVEYO0X0sU/u6ZWttfETuGrlAy/rbU37UHWtW0cS8PfdMYfX5TaEwR+odTxkybp901+Nk/J32tNXsGaeNyjTgNcQ9U9Q8EXX4Lfu1QHtrRlxWC5mcvS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876724; c=relaxed/simple;
	bh=vUixHDeqy/E7jzwG3itUX8ri26y02iRLBO1hpa766Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aFsVCMs9GAfaHzKzCvnGNEARubT0O3D2IFWqxHpe5YbkyMgG5lZNAv5kxHeAVzpI1Idwe6C+vQkqtGPJnB5YL98E0So+PTBKNy9a++LIlneixh409orf6upXepfaojKV5d5qrjxEGb1Y2T93Z+LXFW2s1rJ332VUTAi4I1q2cTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bcYEDkur; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=wBvVW6Mb; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bcYEDkur";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wBvVW6Mb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791876722; x=1823412722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=vUixHDeqy/E7jzwG3itUX8ri26y02iRLBO1hpa766Z4=;
  b=bcYEDkurOPTSPB44jMpQldYYZB9IDHPTKpNPhLgPep+Di5m3lMbFRFt/
   Wvi80urMloV8WkOIvE66NdWEE42QIrBNiEUKt/xgqL4qiuUUcMn4cEYJQ
   N1qjADmR04DtUAUG8NneTg6a2yuEVVoCF0A2iS6RhkztEcTZL0vf741ES
   vX/9xvS4X8PBEqd6swciUFTju1gYv0lAh6LOIEcpOPMznYfe5jFEglU1f
   ut03df9Q/QWHB6TsK1wvZwUF5S2ZhIdAZp9kYohZPgwZJZyKwexHbHWSR
   FVU4gxM9I78tpdYqoC/NE434kCVbbCrp8HyRhCN2FTkfpnlUsxChD9J3r
   A==;
X-CSE-ConnectionGUID: g3FvW61HSLKWFZQ7l/67/w==
X-CSE-MsgGUID: Iph0OwudSjOttiAhorROTw==
X-IronPort-AV: E=Sophos;i="6.27,155,1786982400"; 
   d="scan'208";a="156364548"
Received: from mail-northcentralusazon11013046.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.46])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Oct 2026 15:30:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHAkOCkZz86ZlXP1lw98E46RR3DoxQKAk7sQ8U9jlmnc3eISRKcV0DmVYnFfjwD2wxdL3V+X4aeg9X4kFJ0euUy1PyhYF/PWqNoCflV/cH+0XSc8aYL0ZfxDfGEj+VUEVZ5TTwrvNKvIu79yrWHMcQQocMZ2c+cV08OprkxqpzVsW9ZW+WHTLVj5cm/65eJ+ih86FaUvv1iBwDncLGTaCQPY6feX84yzzgG1IVsFwcbNexRFodmPc9b20t23+R6MXH7ibXh2oLcSjp2VeMrcvyLQ6qOQIwnLYsoC4x+/moa8pJy+sDtGFJ4e+9755W3WXZKNpTv4NZcJWvZGwAkMUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4T5YT8g0o8Aa0BEznAsRON2zHgU5wYY33z+tFXxdSM=;
 b=d6Vo8UHnF2t0QAiv1ghugd5YDdg+ZzF4bLUC5ZChbs437IvsDn3odZZhHad0HdpPNP+TKiUGQoVXQVA8Nnd01Mv9agXh+NfFDLjpzomutnvXVMhiuNkFWylyl+zroUgV9VuLuXrP2sw8PLMEALemMXIj0yiNJwDPTh9OHhmW/HRa0GsPh4v9bm3utPPKzxT5N4IlL+WA3u51K985GNLEUwpl6aFBZ0Ua4Oy7i7cMhhE7FKeyA8DXTFI3ihzt16wnJYanoheFsyPw5WT8UuGcueh702hDt9+lxyo8w5AR9M0g6PCZoopPnJO43tAtYnk1iuPKrI4EkfLe4w0SqG4Y5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4T5YT8g0o8Aa0BEznAsRON2zHgU5wYY33z+tFXxdSM=;
 b=wBvVW6Mb0/A7pc2AHzetK3EAfHRh0hBzwvIpGSqs/jOS5lxvU/+cxdAGwOcpLwRwqS5MuPRDXSnrhrXut2ssQNT4q+LmLXnyjJShDaSizDa0XcLQaSUCR/1078o+0tHvZTf+HW9fFzWo5PS0U698jIY3WrPv2950oQz+IhzMYfA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CYYPR04MB9031.namprd04.prod.outlook.com (2603:10b6:930:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 07:30:32 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 07:30:32 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 12/12] btrfs: zoned: prefer sequential zones for data chunks
Date: Tue, 13 Oct 2026 09:29:41 +0200
Message-ID: <20261013072941.424029-13-johannes.thumshirn@wdc.com>
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
X-MS-Office365-Filtering-Correlation-Id: 93e11106-2f1c-4bb1-340b-08df28fbdcd9
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|19092799006|56012099006|5023799004|11063799006|18002099003|22082099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 ek0KZjKKtiDjMQwlflKLm/f2ucHIQz9LY8j+9Dqttcct8WQd6pY9txg88t0y0BilTQuKQeoW2u9PS1yj8vzDv5JJlfl2m7gBTFJkcqI/1/PFFu9DWX7EShNGHby0dD1SDwhW4G42nQ1PpdmfNJw/A3SuPX85hiCDkOra2Jxa6I66e5i7L1GWtwq5M8hGPTvyfHtDQqwFsml8gMGHEUP2YmyFEfxUXeHsxjoRDRXQveHTe/Q5dzLwMIRVTb8QKGWqQ5pvl0jBTOP8+/Va4WUf+M42VRcr3Qe+RrYY3tEBWubR5JeSGeIn6prxe4hQnqfIikdypAL438bUDCSyaPW4Uoe+JUPWebsUdcnCsRZIQB7mjBXE8YT20ggvrjiQ+8gdfwdPVTLU2oOIOriAG022X3PWhVzJyKTyrLDgyz5tdwJkU2z1GZeBuz59Vmi0nvtr9W6M35QsNd5DHdMZtue/pZb18HJpimQYZ1wmjN7x9629tGzdLcDqW9IU777heN/WlV9KsoryvAGykLaWzfOmuXGbCWCHUCIXrlBQx7f+6jGv+odDm8NTr4iwbzGf+KYxtwpot7AykK0nN3/WwUSZmfmjBdLh/1a4q0ucInF4JKc2JEZGd5ltd2Gb+V1AUKM4BqTE9zycCXE/LfHgMqd1UyoNrqY3dxxWI3BN9XxrHBM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(19092799006)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?4IWSJ+AJMo2Ti4N9bpZanEegeVD2kfRM2/7UqAcVxT9Y2hSKmfTY2G+QhprZ?=
 =?us-ascii?Q?xWJl29kvU5j3NyZxiTA6AcYedBs4NMsZrkhd9GFXpI6jevFmBwaJrvSvV9UF?=
 =?us-ascii?Q?VFsgHl/raWDJ32mJ9nPK1owdr3Y8cQenBkyzwgEx0YPZ82Y6NS9wBvSWCeKG?=
 =?us-ascii?Q?SEJkoXaLII3QNsds3mwuREb1mhBdPtXYa6866LLV5pA3/njZTVZG/aIwVAXD?=
 =?us-ascii?Q?miEBoJ7JH/TMrqBHUmDHhbiG4rdYmuakLl6j2L6clC8StvP3VeNr9txc+V8K?=
 =?us-ascii?Q?C+MhH6g6RCFFbHhXhG58sUDpn9O+bp0EmmMs/ZUHYvHTREOTAU2QihIbbn/1?=
 =?us-ascii?Q?5b4dz1h4QdC/UnoDpCM4BlQNaKXTWsR0ioZL9y+sx1VPHIQ5PEOIYB5PaUns?=
 =?us-ascii?Q?vKk1vfRaqxMKpViBITmwIqBDX9kCb4cktdkeFJmqrHvMv4Zx1TebdDHYQ+H1?=
 =?us-ascii?Q?WFh5BgcOPVa0OmMWR82A/h7J56fySLAG6dk6dUerNafEKV+AbMMsjz7Dii7M?=
 =?us-ascii?Q?PjrsXwcb/a+F9lF9oEZfd1PJgyJkz5/mLlfHNfvXFURb0ZTDl5w/635i/ary?=
 =?us-ascii?Q?X4RII86YQ+wYSZtv6iyFcqvJT8pkT1dfqxw2FA5aZzaqL6Bn+lDWhM6T140u?=
 =?us-ascii?Q?WBQdg8haYFn+nQ/D1XPnM9KbnpcXJux+yXYeZA7waJcj0UsXi/gJepbNHlV1?=
 =?us-ascii?Q?TJKqk2AN9ztgXD28X2aLyed2oTqqE+DQdZuh83HubqbXb5AVK0nQiGLLiFrU?=
 =?us-ascii?Q?H5s71Xt7qKnPcHTeUVuUp+fBFILktvHMainrexQRjXLGoI5EDJFY3LuD8JzM?=
 =?us-ascii?Q?THM5Qxm66LeZ2zF8xesIIoXT+ygvGofy/WlR7egiI7uOcYf3Xl+FIPffBvvW?=
 =?us-ascii?Q?+klovSTOYwBcMNmC1xsXIOHYQp4ZmJUhZQvcGtZoh1D1UVvHDPNQAL0+72XM?=
 =?us-ascii?Q?VUQyAZimlN1XTTHKzuplJACWKjnJub61fT3UegfgDTrFX56CbVXSj1cp1JIm?=
 =?us-ascii?Q?bP4zpdOLkloIdNru2eEp2R0X3QO4+dK88y6eYVeK2JJwMaz7zE9Y8waDlKjL?=
 =?us-ascii?Q?1jL7ydqGJo0gr21NDRK1zi6AGfODRkW1v+ZGaY1QBe8kjI374rZ7CMDJ1f/+?=
 =?us-ascii?Q?o94sKhCNwlJ6w1mudwL14xD7zrAjriAnXIXiAr2eZ66vX1EiGtFgtAM3qISY?=
 =?us-ascii?Q?IOIFjkDo3x5uw9u8mqtqffLVqEpDY6iY7080iE8AnI0qHHl8bjAIjzpW/Gbd?=
 =?us-ascii?Q?svStQGSBslWuANCJcGx6Rr2OAirobEa0B1F46ZoSB+hwy1NYAkzdHeXeD4iq?=
 =?us-ascii?Q?ZFgWVg1HWGF5JSbefx/L0kyNhPCIEOvefHteDPKYyLjPStR08qv0fVglGl+9?=
 =?us-ascii?Q?W6D/VF6XMejGCuuxLQqme5tpEGjd3IXRJvaC/lJaXXjnUuCAs59L+53P6av2?=
 =?us-ascii?Q?SgplqgPTM2WisJOXQmX9uBNTHbTEVUHsQuhW/2qpB+FRNWk7TTeH95JEex/w?=
 =?us-ascii?Q?1dz16RtOJ4vEzwDOKIjqda2C4Xv/Ubv5OL1xTD9hJAepJaA9QnQ3keDzPzei?=
 =?us-ascii?Q?GUQ/xOnnXW3uIiQBEng7xIdlrx66Q/ZYsMM83Gopq99Me94YlFPxFarTdY/F?=
 =?us-ascii?Q?mGcliHv9Lngn2ks0UAqCl+a9prZnmuWHw5rVoQG9sWPRMSnLKAoCBLaB6nmd?=
 =?us-ascii?Q?vmWMH/G8uE1Le12j21YUVKjLWtlyokYkAPpaNx1YPUMn2GYLOOUCvX2EEI+m?=
 =?us-ascii?Q?d2IiX6Jbjpqhpcng9y/LglI28c8SgV5TLXiI0M6x+XUTG9krDPki48zB+aca?=
X-MS-Exchange-AntiSpam-MessageData-1: YiLLSZ5oMZddnmVtK9+9Y1+JH7nDXcWYLsY=
X-Exchange-RoutingPolicyChecked:
	2S3IgnQy24EcLyQPzsP++8UR18kUwxORfccxT+18VYidLXkb/goLh+yObq/0bFFfi8c7iMGTkH3jMiupwzEIwTPlZjl6oV9TGEJd9a34ahfw27fqtDbEUDOdjt9PXppmPiNUA9aMH/+R77KNIWCn5J7JoertdK45Y7I7ox1ShnANdl8FIXYUvuNqT9Yi1FLPaXy6EcwhFCmhEnG1fOWJrpvqYjeDP034GafqOShzPsKNSD+ZkkkxiyUug3VHg4PpuaA4s3gWU6XpT0xmAe9k9isCa3pw2iF17LWF6phlOn7Dcnj0TMBTzUZ8D4TAl/aa7LfIwWc2OpdzLdi2sQXdTA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lbzdpvsD7zAlKbN7aFf/WiYS4Xn1deqY3pySymZqiJ+EtH+IZAbmI1mm0Qa2apB7rVHl/WmTFL0zJuMgsOteVifzJSxrVxfHNOh6NtFSJgMDqbdRUc30vIGESfSzHfM76nvXlNDQ4nGLhkri5swiV6i2JG9Grs96/2ePLucyNbpgqDq7wgKRS9AiQlBK3ePvca35vKuNzQU/0YK1EC+qzbSa1wXJA/vgtGAR6irS60IDNQFDy0cv/Frvi1XBQVhh2jojcxDBiSRaQj7iKRYj9UlwZtPEtWiMcCqwJJAALJ68tnhJMAAxG6XalUEa7W+WQgMaugC70J+QXsz5tLkuHT8VUtTWPYc7sNWeKxqLLdKJOAGbinlKLNT8vn3bz+Brzc8rBOFQTry7sNsEDOosIkcZgDbRPgbL06uU6AC4kGkegA7ePl8wCKo+DI5005Sn2dSE04+rkRmL3PW+m+l3rAFI7zQgXadz0nkUDjMb9N0reQ642mSwd8Cz4ATAlOgDDFWWoB/S+DozythQPSPt2lv63QXPbT5ld2fLYosdUAGZTVBJ326wr9iBFYPYAGgi5RAybRRjZxa6bjfH8I8yTiTb6+SqXykKvufiMin24hkmSBve/CuCp1v5jSKhxP0+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e11106-2f1c-4bb1-340b-08df28fbdcd9
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 07:30:31.7802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YkI+RHLlJrsHuNQHzU5Pjj6r5huryJ2YoYWz/ZRxrnk064PmUd9dbrXJUPf1cIWlgskaprVdI9fEMIJqB1PX2z3l8DfVxsmcje5Hx8/dnhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9031

Data on a zoned filesystem is always allocated append only, even when it
is placed on conventional zones, and its volume dwarfs the conventional
area a device typically exposes. So there is nothing to gain from placing
a data chunk on a conventional zone. Doing so does hurt though: it
consumes the conventional zones that metadata wants, and metadata is the
only consumer that actually benefits from being able to overwrite in
place.

Mirror the metadata side and search the sequential zones for a data
chunk first, falling back to all zones if that does not yield enough
devices for the requested allocation profile. Devices without
sequential zones, e.g. regular devices with emulated zones, skip the
restricted search and keep working as before.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 250859087e57..0c8bc47a8d2b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5891,6 +5891,15 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_devices *fs_devices,
 	}
 }
 
+/*
+ * Metadata and system chunks are preferably placed on conventional zones.
+ * Those can be overwritten in place, so such block groups do not need the
+ * append only allocation and writeback paths.
+ *
+ * Data is always allocated append only, even on conventional zones, and dwarfs
+ * the typically small conventional area of a device. So keep it on sequential
+ * zones and leave the conventional zones to metadata.
+ */
 static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *fs_devices,
 						const struct alloc_chunk_ctl *ctl)
 {
@@ -5901,9 +5910,9 @@ static enum btrfs_zone_filter chunk_zone_filter(const struct btrfs_fs_devices *f
 		return BTRFS_ZONE_FILTER_NONE;
 
 	if (ctl->type & BTRFS_BLOCK_GROUP_DATA)
-		return BTRFS_ZONE_FILTER_NONE;
-
-	filter = BTRFS_ZONE_FILTER_CONV;
+		filter = BTRFS_ZONE_FILTER_SEQ;
+	else
+		filter = BTRFS_ZONE_FILTER_CONV;
 
 	/* Avoid a pointless first pass if no device has such zones at all. */
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
-- 
2.55.0

