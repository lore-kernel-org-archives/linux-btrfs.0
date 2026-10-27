Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793085795;
	b=CsQGpR7Jm+j2gnlL6VOziJLB5hkzKbHRGHE9jJ8OPDA1Xx6IsRLaZJfoU7etjaWE0YuY
	 u6NftwLfKLCeByH4RLXZB4ACPovOfJkOsvBKgqDtjgsmyR4zgNaThCbGANX1Emr2lyz9c
	 jay8NWLnFCr7WFjrLZLlKFW2WLxcUfe4ugvQI6QPAMw8papxnOqzjyBOD3S+CxPKecIZ/
	 OgYNdTGNlCk8jjE8CPj7KLILnXbcuKyzEB4mPLbaRI9bc5P/tTu7QTZd63CL86uire1NH
	 l4BuBTmrlCKhyHD74ZwplTfAXLqLDTQ3Qc7kln1WOTLx0g5kbAZZYpWfSWnivd7IhIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085795;
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
	bh=F4N6TRJxnGlCakKL2QyAH2NNTjomVpVf2IdOroocM+c=;
	b=smgY8Mjkm5EI6Ei74LYWl2Ru+XlTAkANNspadzDGIVirOiFHRXkOV7a+XSuQ0FKUmpzd
	 c81OR1+C7wXlkbxEHRNzi2npynewcavXIcSgVqHz1NLTKjy5Bd4oAJhfYxq6RPs4GPc7M
	 sYToFAaeGQ82v4Lckb9zigFWCl9wlEp/r+OV+17byuSGTriPOPBSlxPDdOffclkFoj/If
	 +2YRRje8RDUAweNKB/7/a9IJ3fYH7hODS6WS6VbVwVkKpehh6exB3iDf9+BFRumEjHpw+
	 BTaCkTryXAUNa8x+nhaMjtQVlwty2ag9NrWy828dr1i0DPYduhiiZUkMPiKY9dTLX7Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BWb3nUCg;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=faFPSZLP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D285B606A334
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 07:23:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D285B606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BWb3nUCg;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=faFPSZLP
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793085794; x=1824621794;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=i9fpUtH5KobksE3oNf7jSnOZzCt3GKoNJ8zuzs2K/dw=;
  b=BWb3nUCg+Gyj+wBXoedtmvWt2Olxb5mE6+0eQQMEcMT0X2zokI/ydqdl
   p2FzXo0yOxtd/+zJJXarfifYMYES1lKpd1yT2JKyue59gb+aU7xDjERGv
   QFogfq6tVchQ4hOvuRL13/UYX4SPdMaBvxOkLfIRx5kFNQ/hzLS0ZbNGY
   VIQy9u1CGWHVah/jiXWvZy1y0JZ9mjgxc5nwnIBuxFWkYTX19oxFxonSF
   Kyg2/D1G4+u9OYk4NR/uaCwBS+5EgLZEjzlGev/74btwBHKe95SxRXOOT
   YfTuZISgvtNb6IldWyQZ+i4c/Q6fwHKY9I6WRQGn0I3qdd2jPIrvj0U9s
   g==;
X-CSE-ConnectionGUID: PnOQIx3TREyS5mn6kH76sQ==
X-CSE-MsgGUID: PVXJSVi9QYmiEEugRlkeuw==
X-IronPort-AV: E=Sophos;i="6.27,180,1786982400"; 
   d="scan'208";a="158990007"
Received: from mail-southcentralusazon11011041.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.41])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2026 15:23:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wHLXuyj/kJiSgCfyIfv664sP07GntxJExOQdIJ8R4fKNT045Gtiut4Y+xTCPrcr2pOI03BpWyk8T1ov0K/X5jk9o45LV44wG5RSacYWCPoxOPW3c7nuf/WinZXKxHm1MAcYJ8L7/8a/5tF7oryzLVMOwRWHShzoCAv25RQhv71OvPDxH3NCBpMg/p8NMsBjDp7u7XsX4gKYtLVzqkXONOM0SmkhfQSCRRBKLYmbnhTCkPk6WJEuaLYNPYYTS8KJ9uB7r/NEONkTmoW/zdifJVSg1in+WRTMsz1exh7PovHcjCL7engzIqCFAhzZR5nxPjRNWCojUR0sScEigeeiQ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F4N6TRJxnGlCakKL2QyAH2NNTjomVpVf2IdOroocM+c=;
 b=jIdsARScLu3lKb7tDM/aDP9j3RwIlOsQM2FFXJ52zSXeb4PTRGpleXLhIEZVej4rHvrRJWtYTXJUXjCkxbsV3W5VPLNiyjWHVVnHI6M6/ssCXQEO0cQ5G7Cbg3jcEiJoVu0Lct/p6NqdlfMd/V9y4lWFHkh5q7Y+Az3NTxrGTRGsUc59YalDEStCkHZYoEtY+TTqe0ZDuCiuLEBd4Czyzlj+KBaSl7sqn36y4N8WaAP3Ko3PgYFcVMfjYZlHKQGKnquauMZ58/Tyv6GmRPW8wosOptW+v+sDf5nN0lw1amiI2MU6L2QuRHf4FafpsgEAD7NzjP9XBDKOSLv/eUBLWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4N6TRJxnGlCakKL2QyAH2NNTjomVpVf2IdOroocM+c=;
 b=faFPSZLPdNzLOAJZgOExBx5djxuVBPIHvOC4EwgZb3X9rWOHYJ9n4dFk5AN4fGjSE85j2BJXlOFS/t0tb9wwx3ybd3d7RAC05hSNFlg2JhrScBSLcMisyN8acBmS9seqpaaSxPDFwiDCRoLGxWYh4Y/Nt3B1NXC867niwSpLjNI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH2PR04MB7064.namprd04.prod.outlook.com (2603:10b6:610:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 07:23:13 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 07:23:13 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 23/25] btrfs: zoned: keep a zone free for relocation when allocating data chunks
Date: Tue, 27 Oct 2026 08:22:29 +0100
Message-ID: <20261027072232.419318-24-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
References: <20261027072232.419318-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SA6PR04MB9447.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH2PR04MB7064:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c5faf11-e28e-4488-22fc-08df33fb2914
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|366016|1800799024|376014|261026121527099003|11063799006|56012099006|261021121427099003|261021123027099003|261022105027099003|261009223027099003|10067099003|22082099003|18002099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	7U+L0cbrv/8hZHS5FM/TUH8kICD3hBrVOcECPCrd+4fgksN6iLqJvV98+QjI8T7/AZXXiU/GEV4nbtC7gDX5tppXE8HRqedNAFhyOSmqozaT4ft0AL/AIm/7+jKyWu/tYXmolb8z6C7EwZ3wjotZoXBCKB9/hHv1Vn0/reO1L3TI2uhP6laXaxllnaZ4gShFYghag8Vq9SLSnm+GjN/diDeWn5biAFilmwi6DRFWB72Uu+g99cgVkA6tgho9JzFhlr8lMfAY3GSXimQyV+Cr/RYsej8i97TekUBn1qr9ASCx1Q7TWzZWgJ2WCUd4IbUeH0zAZ5RvC7n/3Ad3P1ambOypVOlDmnldKnzvEQYkdamsRo0j5wuqNaJ/dUplFSvLui4ELrVZB5AUBuzIqVypOXSLL4DgVpMWaIjWmXtImO7pLv9o3hci1q1fPkibQ0lPV2vijj+P6hYwaI5QfqR5sPRBBtoSLM/FEIqys+Zvbtclybda77FcCDwKWzN99MgQKqKUACwGdMjITRtpndYS6S5GVKXdZLmA5Taisuy4njYd6YKRGEwi8KBKCNgMmi/5oU1wnrQwXa+vQHl7SRuWXehxU+NKolCFku9mTVGdGiIWEuokfaJjGptXufSC5RMuW1BvyM45Oc5/2GHgvy+XjWsiZmT61dsX98OzazBaYKo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(366016)(1800799024)(376014)(261026121527099003)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261022105027099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RnSDNWg1tqS/M4Hu2M7m7JK/KD/guQPnfGZxl24mgScLMvBef/uetrPZ4AIF?=
 =?us-ascii?Q?71QZecXkwwHfl1yX+KAsH+uqMUSudIMrVyWWhW/TE1YHNaYuM8ooz9GzjgqQ?=
 =?us-ascii?Q?BwyUESVwhOM2EuiMA71pHW8IkwAFz4Uw8/tEiVBDpMsbh+a4F5uoCGjTt6ZX?=
 =?us-ascii?Q?aURDCM9zGPTTaNugb/DZ0bzr0E8mJ8W9oBR0OFgjNeaO1lhqTDMHO9NvZ4V+?=
 =?us-ascii?Q?vsnmdSIoQ/zF+YdeYXAO7sZBT6t7iLZWdI1ufU9tv67OsA7Ekqg1UbsETA/T?=
 =?us-ascii?Q?KrEqLnjR/LKXYcJ6I/2LXEcCcMfPYKCB84+dMgvNNWpMx7/7lIVVX+D+DU7Y?=
 =?us-ascii?Q?ZQvWQeFXgmfd3JdyC1Ya7+njF/YOq4ydHqvQX3Ta6JeQZ85eCHynCVxC6SNo?=
 =?us-ascii?Q?CeNHiSXL/a/qzXLxjf3yWaWpGnr1I6Hwq7PSEiUDuoKEasQ5VV8QYwFM6/bB?=
 =?us-ascii?Q?o1nbH3phZWXgL4gW9HZ2IP91yONQeXB78mPiV9eGBkFI+4z8JU7gfUoV8J2U?=
 =?us-ascii?Q?wKQW9HLNnmKRcMz6ON0z+mVuKTayThuk68ozBnvwRJN098slS1JFu0ljQLiy?=
 =?us-ascii?Q?ioOrxjsGPhexUNmrSIp/Zdj1okhifo9XpGcRpN1DBmUEWkxSi+U3K2S/wYKK?=
 =?us-ascii?Q?dFsUL9nPuulZp8VyuVSobP3jmUPpbNpQxIJwKWF7nUo7y4RNdMPKbx2ON5l0?=
 =?us-ascii?Q?eRJeY1eZdIHkpRFpFiSUNoqvn9uZCm2lTH6BJhWoFLF4uaNf1Bd8JVpIcp6v?=
 =?us-ascii?Q?LdS/6UCTzKDdx2pPqjtUGiaSOXLXi9ciEgI/H5+3bmtMANth/qYwciL/MM5O?=
 =?us-ascii?Q?C15MZlcym1ifU/bFfh5YesIKQQQQSvXqxtIsZzUQQpDSkLCXvmsi8NYEjkyI?=
 =?us-ascii?Q?YUmHpYI7mYq0TKKPQS/qtV+gvy23L3kevV6VNElOnBcyn6QSnz6pOVVqea0N?=
 =?us-ascii?Q?QuzhbaSLxxvvFqALNmM7Lh7Ix3gFdC43zPFEhaSct24n/s81VwKkVG3uzUz+?=
 =?us-ascii?Q?ALzWsAq+ciL5err5sqDwCZkAEsywIYd7ZRrj2ZFIP3KG6VZnDPNFfhH7KcaX?=
 =?us-ascii?Q?pa9QvbiHZ2Juu2USQ9Yj+rDSUP841AA6BMG78QjkjIcFd9o3A33J5E+j13+6?=
 =?us-ascii?Q?17J4EPrRVbpJbWndimZTYIMS91BSyc18LwjEzPPlJ4FsP3s71qhgtFoTj/t/?=
 =?us-ascii?Q?lGh9EYZ1kNkHTMu0QG/gayKZ9bfEDwBxQf/CkWxLYLCoAe08WB/LrHa4BQ25?=
 =?us-ascii?Q?qYtKPca9NJDCfD8tOHr6c7w6r4ahd7BPZSh2pfhNkicOFXJ1+7fZ8VT0ayWm?=
 =?us-ascii?Q?hQF8iZsfFtD2+YVYlZ7RYy2e2kfZlz1XJCQ+ibiVkKLtMFA0GzKOh5QBY6KH?=
 =?us-ascii?Q?XzE9+MYT9SbKe91h9EdC3vx5WKj9L1cvswr5Z1vUPTGL5DhlKImsOwbDd5n6?=
 =?us-ascii?Q?4qpmQ83RM3WBr7WXpQLzVVGDQAaIkaNeofoPH3Ij46iyNn9QeBR870BUfgY7?=
 =?us-ascii?Q?eO/835483Y+H3tdFgBKaAoRjK3x8tUCpJ+IgOXUtml9O0T9yMZ+95c+DuE5/?=
 =?us-ascii?Q?daKQ3RTX0vq0JqssbBxKrJiiW7UVylrtexUiAUZawMVgerl/SXRKHznRsgSo?=
 =?us-ascii?Q?OsMrhNfe0o6cUB+BvZ8GtmBmAE5UYImvgh0cIaC2yk7ETmk5+5vOUKjxuZj9?=
 =?us-ascii?Q?WQ/Dt1htjfdIpobYvcPzr0XAGhupU93R0mvbWiVY9j3lX83VRL871kKGswZd?=
 =?us-ascii?Q?1aYQ7ZS/dmEHHdYJxqt5dhJl2+KpRw6EqpH6an44iQqVwpbwbCZxZGcoCn9X?=
X-MS-Exchange-AntiSpam-MessageData-1: 5pHvt9/UptBNGmIbVWRgLVfZXdgMtAXScWU=
X-Exchange-RoutingPolicyChecked:
	E66an4smDpPxejP8dJD/8EUCEZ4gXlmUhNu9GcjsCc96gMQH3uVyYjZg+SrxH4VFSgBZK9W+U5cbprRY3tVSmTnfgXN96gCr25tXjZaO+8t6TkJ2xRYIm+5p5y4QI7s3BIibKyBIJpONw+DXBKnFmK4MhZToSJ1Bf4blhs3ZHg7yyT/KPlI5TubZZQVxPyl8LfkaXJR39xEsPKsEMEzBJYtCpR9XFbYwTxIsIMSfgnhbGqUHlkidjU8IIxSWgkBeb9otiYdXNmpG3i0yfC22vzUhmuwt8cueV/0EKag8JrQs8J23Bg6NoJnJV2LwarCFfOjV1GjzFXPB4tXD7v7d/w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p9pWyWPSNEjKA9OAA+puuLV4MoMmcWkPGchJRQOW5aU+9sh21cynaevlG4tJR1e6Bj2ZYj9C/pB8WzXlNx+XOPbXh0bN+6zbzQhSXuTj7CAV3oM5fH+Cq68VV40XMqBrv0mmNWnHworb0vMsN8kPxp5kx4Lo5s+7uCVlsXFweqUgn2UZYAwtkxZKxWhBmJuDIQA8KVHXazcSxSwrWlGkBEtRqw1kv1yv5ySynqa1RbWd7Eq+dCSx8Kqzb3FoC0XHkJ2ODHm9PIEYn1wn1CvMhYzpSfJrnXJYzdILleFy3NQw0cArKAc0oX15YyWdEQpzWdtZe1vPu4SK+K04z21JgE3ZI0diaKG65id0ETKNKI15vtFRpGdFM7sIhFSfI8aGf6Wkamnr1ZZcuqVU7DDUKaJ7xgy2bG9K+YygTED4sIYI1AHzbNPcC+1NiRnJH4ksKzC7lRECFjnP21nMNyEPja5qAjeZtledAqG46SNY4ysXcloYJLmEJLUxswGvOimD3PU3wdPJLlK7VfaDhYxDl2D8wbbuzlngWOK7DzjiX2/C5oYhHd8+o9+fNY4ZRrqWvL6vnEFa/k1WuFSEsXqGzAHwGdHQBkioPIXlJjnpWlhw3dYBJ+2BKaQ7dTNEDgOn
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5faf11-e28e-4488-22fc-08df33fb2914
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 07:23:12.9705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X86yErZTrSQpRsZknKkIpSpoB8s+ONMYx0QpzgmHDya9gXdFHXlnuGu2B6os/aZgAJXcJ3kWGPzk2iNLZiCkBfsn/Ci49BEC46QYdAu/IN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7064

When allocating new data chunks, make sure there is one zone free as a
relocation target.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/block-group.c |  7 ++++++-
 fs/btrfs/zoned.c       | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  7 +++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 68844f26e2c0..6130bd3c26ca 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4118,7 +4118,12 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
 			force_metadata_allocation(fs_info);
 	}
 
-	ret_bg = do_chunk_alloc(trans, space_info, flags);
+	if (!btrfs_is_zoned(fs_info) ||
+	    btrfs_zoned_data_chunk_allowed(space_info, flags))
+		ret_bg = do_chunk_alloc(trans, space_info, flags);
+	else
+		ret_bg = ERR_PTR(-ENOSPC);
+
 	trans->allocating_chunk = false;
 
 	if (IS_ERR(ret_bg)) {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 703851d2b77a..4b24f602afda 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3635,3 +3635,35 @@ void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
 	}
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 }
+
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags)
+{
+	struct btrfs_fs_info *fs_info = space_info->fs_info;
+	const u64 chunk_bytes = fs_info->zone_size *
+				btrfs_bg_type_to_num_stripes(fs_info, flags);
+	struct btrfs_device *device;
+	u64 avail = 0;
+
+	ASSERT(btrfs_is_zoned(fs_info));
+
+	if (space_info != fs_info->data_sinfo)
+		return true;
+
+	lockdep_assert_held(&fs_info->chunk_mutex);
+
+	list_for_each_entry(device, &fs_info->fs_devices->alloc_list, dev_alloc_list) {
+		u64 total;
+		u64 used;
+
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) ||
+		    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
+			continue;
+
+		total = btrfs_device_get_total_bytes(device);
+		used = btrfs_device_get_bytes_used(device);
+		if (total > used)
+			avail += btrfs_zoned_dev_avail_bytes(device, total - used);
+	}
+
+	return avail >= 2 * chunk_bytes;
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 74c9a4c70d26..ef5292ec771d 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -116,6 +116,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
+bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info, u64 flags);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct zone_info;
@@ -335,6 +336,12 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
 	return 0;
 }
 
+static inline bool btrfs_zoned_data_chunk_allowed(struct btrfs_space_info *space_info,
+						  u64 flags)
+{
+	return true;
+}
+
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
-- 
2.56.0

