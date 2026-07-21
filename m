Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3B735DA67
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 15:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647762; cv=fail; b=Btka/FGqpYU2GameVpW98JMUC2QeSNACtAAZL91AP1jGW3N2UNebjN0ZhFEGx8+EUSXb2UEOJIy3Imyo+1G9Qwf504zuvsUEVr9AW5u5YLvbi/NYRhC7pToOCiTxdxxh2VppgJSGIKpDBfkipd/DlwjcLVMwmE/4SBotvR75fFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647762; c=relaxed/simple;
	bh=2WUHn8WY0VBOUiMNJsJ+t0pqlyzltcdzAtHvQuv13zg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qtsC2sxlElAtNFHI3eiINBhqlvB4UrDuSufdhflLcu949gxnbjZ1sXc9p8tXSnoNO7srRN04yCmFVZPteP4wQt/4l6+BBKBsT7jD0BZ1m+zulxqVVzHYbkE9QvnXbWF3TwlsRqCKuh/biQT90zRQ1yqwtlzBZijBCIOXbc8GoVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bYIt2+lG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=pU6E1otO; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bYIt2+lG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pU6E1otO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784647760; x=1816183760;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2WUHn8WY0VBOUiMNJsJ+t0pqlyzltcdzAtHvQuv13zg=;
  b=bYIt2+lG79ujU3TaUxjJ/UHyd3c1OwXwNpKcnn8TIVbOHezS26l9QL79
   MGujZKrwUiDSDy7SmPcJRXWwAqwJC4iBVtyC3DR1srCNhUkwaovRYWxqs
   E7HuiWGhln9liE8LxOI7JMjQFO2Q/oYn82m3XjSg2bPSFmtnGuAgUWAxc
   qxlkhsCP5yyeYwKrZBpHiunC74rnSlL0fmRjGboN1UBXUPajquZ1JSVJA
   b9K96jxIRy0+7r4PtL0jTNWvU44vxNfuxsrXHERuJ6lYAhjJsViLGy+t+
   cQcIsUKMsmD67r+1OUl1im0P6c5zN6d8o3G7vuwUE0Hd+x2xzskMAdHpC
   g==;
X-CSE-ConnectionGUID: eAzl6yKpRIiBDcQOraCJZw==
X-CSE-MsgGUID: F/bSOcQ0QtWt1Zyv+ysw7w==
X-IronPort-AV: E=Sophos;i="6.25,176,1779120000"; 
   d="scan'208";a="150531123"
Received: from mail-southcentralusazon11012038.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.38])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jul 2026 23:29:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gU+zP++J0mSYaSk0mDOK0NBhDVyhvPrmAJCDYwhMu1GjauG2+0roDV131fqcG7OcuUJ56x6yuQenJ0ajOIjDabq1Gfmz7GzPARbWmBN5n9H4eUC5B9MZ0EK4cwC3BxYjIMB8JSbtVo2JJuZGhiNZLPgyuC2vlbMb1RaC64eFFPwn4lIy8ZuYjOuD9HEVPXNKO6ryQQ7eX23fftEfvoam6orjNXSXoDTHYT/pMV2i4vra529+qQikAqwjM4pb25uGoJVTXOE+bXXgaRzTEj++ZsP+eV4XL4TdHNvfr/hazxztAtY9raqXSE913zXm+EC92fDDl34KE4sVGcDOB6JlSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuoYyPLuecJ+dzukwJxz945aMWyXlF0Xjaarp0LMzDk=;
 b=lN9Z7ZtF6YtCML5zkkpXXqa+eKT9tTjpyNu+LyxSAellWW/rWHw6AgyCWDygNsNJYxgGfC1ztxckyKTWSArI3C80jatU3Ck2fgBDJQaM+koSYzbRM4g06u6QUVwsin/hlfrxa6ARYRI7o07Nzm1iFzYVI/wPOQS1KFt/bjt6ol1BLKcG3O1pw8NdgrP6XLChhFZ69h9QiwnsZa1rlwJq43QK08SbfpDEk4TxHiqvb7qRMVlrwBPSwATmwH2oLF87HJUcVxX4NCcHuk81IQI51s+QfYajiXkgU87Xg/MpBfU+nf40TKG5RkuGqWn+829Szj+G23l+NIm8D4FiGDMGZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AuoYyPLuecJ+dzukwJxz945aMWyXlF0Xjaarp0LMzDk=;
 b=pU6E1otOFbsRud7tio4n4BCWBtRHZKx2fAcx6QJ+uEz0xU943Qm4Fqvo/mbWp8W83NgF3D0N46o+vIj0reZ99yL14gMJ0zu9qc0Rg9Q0glIqaOqX3gyNuFnhCnamIqO56kNa11b6pboiOmJ0rr32ZDiw/DUY9i+EIw2yxMb3xMA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7901.namprd04.prod.outlook.com (2603:10b6:a03:305::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 15:29:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0223.017; Tue, 21 Jul 2026
 15:29:11 +0000
Date: Tue, 21 Jul 2026 17:29:06 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: HAN Yuwei <hrx@bupt.moe>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [BUG] cow_file_range failed and kernel panic on zoned device
Message-ID: <al-O9D1Pv6S8mfsy@neo>
References: <FC0DE3FDAD40B4C0+924da345-6000-4644-9b0d-0439e63f3381@bupt.moe>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FC0DE3FDAD40B4C0+924da345-6000-4644-9b0d-0439e63f3381@bupt.moe>
X-ClientProxiedBy: FR0P281CA0180.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7901:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c60f633-20bd-49c1-cf36-08dee73cd07b
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|10070799003|366016|1800799024|376014|11063799006|5023799004|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NQVeZF6nEtuPE80pzmCMiD3gRtONtHuZaVuK/hyrFAxAvnUVNyJOc7GqH0yZuzKprJzEcQ/g1Pb9bFfvLE0JGlemQxK8oHvFPtkktAgKeDQNP1KdEpZD+7fyQR85wDfXtcBOeAHbu97CZZElm5SObwWtFC4Wu2lVAgDKCoTOZZNrpT++n6p2J1xGJ4UZ2UYK5Lcn6yMYHdQ1tOzAtXeXMLHnkg1qg/uSuVlWSVcYRwvqXamoH79vDcm8ap/MaK4q5jyl6jhc/A2RvwmuaTJcSp1AzdICUTEtHXDveeFCGMwrg/1xPTxEO/f70OIqxn5KPxHXmcm3F9+fOYsSLOMSIkB543bgjI5vYHeleBbyvyO6lRb7ZK5cEhXajYAlj8ui2lJaiF5vr/3ixTVk8YV+tWFEnIrg4pz/nfeFwqBGA3czcCjWOw7kTFCZZYxAh0TRyd1Ds270dDgCEBtRSmZCRMBknLsqSchCiG1gOqlB0Pqlr/R6tqVgZDw299KNd/YdTDLhUPLnYrTwatEc2JIdczCqa//8r9lz8oeE3w6HlbDKVOoazfJuo+4r+Q/cbNLfSY2F3dkJnNJ2zvzNhL6tCE3h6vqdS8e9Is157X2HMnyii8hSYw4IfrkkViHSyfed0a4lbwKpQPpU+OcgKlgNgaQ6d3aJNckzdFllhMe8/m8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(10070799003)(366016)(1800799024)(376014)(11063799006)(5023799004)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+Z6ge53D/lntthxZ5e9oH/NZtrkV6huJsY3n3aCAuB0Ml+iMqQy+1cuHM0b2?=
 =?us-ascii?Q?HMVWQa6guwtp+kKLya0d9+r7LNKNIaXNas6YwjYD5faTgtyA+31leikJ2XUS?=
 =?us-ascii?Q?pK3v6xmW3SjRr2k+4jU34rHCwB6Xb2FkvAH93pA9FPGjV0/LRpxUoX1Os1Ov?=
 =?us-ascii?Q?NXiiEjV1r85geZHx/teg2z4y+X22YJqIJ3YOWsyolVCHpSqjcpxTfFRqF84P?=
 =?us-ascii?Q?dOrMgjogEeqkmFfHVaoU7xSS8vOMGkIkISozah7wV1rrIQ5/7OrMTIMihDY7?=
 =?us-ascii?Q?Hjmf+1ORNcWP82/HlkbTKlnDWYjEv7qeOGsmtNwk6Wyq1i6zAgVLeYHlkfNM?=
 =?us-ascii?Q?fqtkXORsA3oSyBShMUzBQOXOHBQWvPi+w3rnU23O3x3P+/vopblyKB3ssGc+?=
 =?us-ascii?Q?37fnQiSzq27nCTqhqAObCy0QubtuVdIqzNJHjGThvwhrDOYUlcRLiHeCmV9U?=
 =?us-ascii?Q?WAgdahwjm+kV76WdtP+f4d8+qBWWA/iZ1+MnbyciLT7KOG4IJNCFrP2p2N91?=
 =?us-ascii?Q?2bLMsvjJjPlJcBSw4C7cAQg2ncvm0J7UVs/9/BlsQrMcUO1bu/JSPy/pRtye?=
 =?us-ascii?Q?rGzHqKMCANP1+vHsZvGaOX25W5ms+M+Lsjoj1SP4aT81ri+4EuvKtAsGSudx?=
 =?us-ascii?Q?XYAlgqgHZGDgPK/Cq66TaNyi0F7c5v15GuL0YJqMyDPcSGXbOl9y2r/MnaYB?=
 =?us-ascii?Q?13PgGYN4SEPWKnYdZ4o2+9Fk3X9RgNZGeJ5RsH9w1vMU+jDU9ju92ykjhl5j?=
 =?us-ascii?Q?S8saVEdScpNwKr7JPQwZj0peHud2SpOPFxjPSbAKPUGgwZM9IDrMdxO0vxTd?=
 =?us-ascii?Q?1pbIYtTrL8uE0zSZOVC2gVMPqN+Goy5KR2VyT9Wr4RF+Osv0MIbV8SCDym5P?=
 =?us-ascii?Q?yDHs5ZQTEuySUaGUe33QhDK0DPTfMJcaYA3jpQEUU0ttucCif97WJ4lp7z0m?=
 =?us-ascii?Q?0FJ3gI3Ty2JEn4moSU3TqGPL1p+UDZ3tDrbfLJudtASF8okU5CBMbQlr9idU?=
 =?us-ascii?Q?ylFcT6S+ZsJ/4EIrsEQ7BfxVJG76RFvG2UNq5YifAl5LOHtA0ctWbnS9Neqa?=
 =?us-ascii?Q?COsFTVhD/jaFqWLiC0XwgBL6+JUFI5cCfaFz/DWkQdZpDw6VAOCm3ep67tZY?=
 =?us-ascii?Q?8QXq9j9pJQvZdHXdmZhRHfu3EUXyn0HrkZzKFEd5XImK9O18yyIYhIGv1szy?=
 =?us-ascii?Q?qePOR5vElmJLo/vCVOgWVGgbd8xH2FbJQ213XM5Z789VCrTDrtOin87x5ENW?=
 =?us-ascii?Q?3g+NCTdjF5JlSkkmhcXcHn0XSk30pHPcsG1zhk+TBG41dVOuTDiy8uf5hREX?=
 =?us-ascii?Q?pb37A7bkEhcPYt/bij/cvkgF5O4wqPHYPSLeU/zguRF/YBTpnXNoDFu7wYxk?=
 =?us-ascii?Q?STDzKsYhybsIUao3NGcopvt9teWrUDRwTDIxoUHnopmTOqnS9+kmRRuTuqEP?=
 =?us-ascii?Q?bcaCXBCWZyoeh5uELMZaEZQZhI65jvosysSdhMK7KHmawcl3cwIAhaqszFM8?=
 =?us-ascii?Q?14EX40ReLG7JUFWTh0Wi2KV9ECxA5Pr6iNURQnHI5IROUCegfBlOMZ2azHKV?=
 =?us-ascii?Q?qGnPMBoy6Cy6l5d07QzLK1q3pEwYHfFzhk26aIUnzIHAxdxOaRUFYh7OKCd7?=
 =?us-ascii?Q?GF/trH9qkWkjI7e7eU7srYhc0VFUCSwfdEgJsTYdJIZv3uxpbctYyPMV8WIV?=
 =?us-ascii?Q?POPfx5WNAKQBkbTie36iRDtIjidGZVmhwM72flR0kaJecNWvmWlrt3h5qnz7?=
 =?us-ascii?Q?pMnOsNW9/ZSpnqo5Hy132UGzpjZOc6Gz4QPXd4+QLWrlvwjjpqEVpxZNT5e0?=
X-MS-Exchange-AntiSpam-MessageData-1: dav8ZSF6+ceITA==
X-Exchange-RoutingPolicyChecked:
	kshDfGLQjta5OJEyd667FONqsjkJuhi/HV34zQM372clPTro4iOKitKb6MZ5pPhHD4eWNZHGF6zT9I5ZodCiyEmGhEELEyVQgPks9f7/UB7qFcI1Vb5xalrKhDlPlzAJLsrBM4DDi97/GnYyWNPaj79MafevyiJUYXk5oQrF9nLIS9V1+u9PaEgFYSUbSOQL9Fj1OIOazQuBZmU+/PWbj3i14iWnpZQlvcOitbWbLWwTSH4Lx9WO1b7T5/tePuEYBZQdgVGN9G4BPhR2ivpWuX7RYkJwFkBGAJokDELZeARNO5b1y2afCJSs4MBcE6nS9aM3brlof4ewDPF8z8zrLA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H2nFJpxEB2EbnbYkeZenJbuD3K6mtnMJE5+ASljiOqHf4kZOFi2wNqB8w7734HqDM93zSc1HXrJO97iiAjxNktNKpQH5rVuss7RPVEhRxXBTgMwSyMDSrPpW+/5LWThZI4cWtIgFuxKMzU5i1dhvBhvNN5HO/9U/1LK94cLDEL5+Dmmgo6tv3/HY9tWo3SMRkZucfqkwEa0Pi4Bp9W6QYkU/wjNosmJGNnCwbcYmc3sGym7xt5CGvaZeyhCJiBLasbGmmmEEO++KolURfrMOQ+Xpc0ie9D4w2ok+S5mKPi/TLeR5Ps+J7GCGOS9HXQwMtB0l4+tzSn2xYDXz9JwCDubotr70oeLzr8ipEENbY22hKyISFI8KLQUImUlSWuoBgV6iM+gjw8e/+Se6v1up96SU6rOY1uYOHYx1UChF6kPn7uqDZ8vMSKn11uxHDiENcfUnXzZF9kA1tYpQ6itRhQNKBsRHQnqr7F6W64IZBKrB/e9G+3lmFN3gW29KU8XMCcSdZUU3FYD/fTdreHAHQIjhPW++sxvFsLwsz4Jg+RRRpubkijqOxiIuCRN/7+XWVxCWrxBdDMstTkBikYYZEd5L279ItrWgKWVTt8cr7RkTaoaI+wpwZG8rY4L+YYhb
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c60f633-20bd-49c1-cf36-08dee73cd07b
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 15:29:11.6255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g7PZk+SNaZErLyWvccOV6lXykKu9XF4Z5nKuqsNGFkF2kzqebtg4d/z5xll9qotCf3W93Md8biKxQifGgzN3s/8m3s27y8k5KdjguY8zimM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7901

On Tue, Jul 21, 2026 at 07:46:53PM +0800, HAN Yuwei wrote:
> Hi all,
> I have received a report from a user stating kernel panic when writing to
> HM-SMR HDD in 1TiB. The user used "mkfs.btrfs -f /dev/sdX" to create a new
> volume. And he tested xfs on the same device without any issue.
> 
> Reported-By: LUO Xiang <luoxiang221@mails.ucas.ac.cn>
> HDD Model:Seagate ST18000NM009J
> uname -a:Linux pro69 7.1.3-arch2-2 #1 SMP PREEMPT_DYNAMIC Thu, 16 Jul 2026
> 17:41:28 +0000 x86_64 GNU/Linux
> btrfs-progs: local/btrfs-progs 7.1-1
> dmesg:
> [redacted]

[snip]

> Jul 19 21:28:37 pro69 kernel: BTRFS: error (device sde state A) in
> cleanup_transaction:2067: errno=-11 unknown
> Jul 19 21:28:37 pro69 kernel: BTRFS info (device sde state EA): forced
> readonly
> Jul 19 21:29:08 pro69 kernel: BTRFS error (device sde state EA):
> cow_file_range failed, root=5 inode=268 start=68295892992 len=688128
> cur_offset=68295892992 cur_alloc_size=0: -30
> Jul 19 21:29:08 pro69 kernel: writepage_delalloc: 383 callbacks suppressed
> Jul 19 21:29:08 pro69 kernel: BTRFS error (device sde state EA): failed to
> run delalloc range, root=5 ino=268 folio=68295892992 submit_bitmap=0
> start=68295892992 len=688128: -30
> 
> the full dmesg can be retreived if interested.

I /think/ I know the source of the problem. Errno 11 is EAGAIN and from
writepage_delalloc() it means we've hit a "hole" or out-of-order
metadata. This is exactly the kind of bug I'm trying to fix for 2 weeks
now. Not sure why it surfaces now but I see it failing in my fstests
setups as well.

There's some hotfix attempts to it and I *hope* I have something
upstream acceptible as well soon.

This is a BTRFS specific sequential metadata thing XFS will not see
because XFS is not putting metadata on sequential zones. 

I hope I can give you something to try by the end of the week.

Byte,
	Johannes
