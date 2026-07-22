Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC20940F72F
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 11:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784720928; cv=fail; b=s8n7Xd6IYThWQyDJM7KDaxMWI3KvPZ+n3DvNeZvTSnBX2LzFJmjTUpL2k8TIVf09p36lyJlt5QkkQpiWqARStvahyOTsneeF9g8cjzB+GA2SgTofiy/YIrcSPcJHTME9e4LauD9v6ZX4RvX7Q78e3tMAsgAimSeb0TkFEBvRC/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784720928; c=relaxed/simple;
	bh=sEFxRmRQcI8pnXdpu3BctUi56HSJbULcagvpXFTPjp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sxNNHddmD0RNQbGw+epslpfK1mDKfx1ELklXDdkz+4XfW6I2TBCiIOiSO0bPyFneXsexmVDVw3pBx1pIENrLgk2hOIeGZ7wEnR4LXd8leTsz4fX9WpIZ+TXMCBYRkfGkfJXjGgc9OeRHdKAsseHVuGPuZvVw6lOAxqILLDp5bcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pcj7tjQz; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=NIS1B+M2; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pcj7tjQz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NIS1B+M2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784720926; x=1816256926;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sEFxRmRQcI8pnXdpu3BctUi56HSJbULcagvpXFTPjp4=;
  b=pcj7tjQzvcM8iQQtv3/CKeRQPilXJG+sYqu6d4264GMcWso0HwQwqGgt
   su69hFV60D8JoNPsIOKx9ka2w1shXovjY12o+XCmqhL1Q7rBPvDWylc+e
   g14kEQ9OLAhYHTzHPfiOeUkIu/LBJp7A0pvkP8ct/S0EmU/FBOFSZkWCm
   XeSKHYQbV1ZexfzpdKIrpXsscLUKCUOiYSmGfBBTLSfmxe2HOD0GWUrOH
   jCkNcZxfDAQn2zI0VmDIDiU9RP1cNKqR53PzszLoXUD7rfW5H0FduAHKd
   1jn3o8eWQEMEZ0+jV9aCRK8Okf7Tlelievxfwo4qxWyktKYul0GJVx1qH
   g==;
X-CSE-ConnectionGUID: mSkgVT+BRTa+3fetlBvGdQ==
X-CSE-MsgGUID: nJpvLtOgSYixVRp+KeDJzQ==
X-IronPort-AV: E=Sophos;i="6.25,178,1779120000"; 
   d="scan'208";a="147387258"
Received: from mail-westus3azon11010022.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.22])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 19:48:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pEZ9uuTwGkwT9d/5E1bu4FbNurPojXFaC1hw1Zw/wPmkQ8DpLm7Y3HVtCdkecJP+ljdhHkh/XAUAabNM8zjA3ZQ5WzWAua1RFVbxN7UStmTFs9FyYe+hzg5aDRB0rBEXVpn/0smJ6sSuF4K+9Mjb7kIcFJsb/tvbRamc/bLN0tJKb7Wnb5/3BBS/N3MyD8x+TBqx2+yhBLQyRYPNMFBqKyLGryLwIBo5gF63pkdYpA4UmPzxUoRErCAX+TCJWR848MDJR6m/Eld/z3irUhzXs4FF4q/OCEAiQgoNuma10e7GD1id6mO29NYjfMvcSBt2Uo8sM7HPOSxbiFsjBjqlSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UTT+pN9sb05m5AGq0/OWyovvidoh1ymtZdNAigNx24g=;
 b=MVJSfvsqOd0VKNHGaVgg6+xVicj1DOkh15+ptLxzvAxrYv/5JOTBRi3CclHB2C3aTNwvMraSpMwzFiIgGfyrvuDP0OsVAJ9qx5bU/UhvxCCljUmzftDQUw/wcI74F68QRpklQpQ8DJbuLBemJxeL/h50qJqgDARTVco6MgI685GaaD+JAKVm22DoWaiqsWAHLPuvGMN+D5nEh6lnxbgtfn4lREJV1qfeVGG2rUVL3FsEETsltV394jOJDSrmJ+Jr7IXB2Uht+t1HEvZxP1hvaK46b3/sBM+goyqhxTcMuxRDH516vYVX5u7MSmSLKD1SOXWMs4k79cpZfiG+AIaMng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UTT+pN9sb05m5AGq0/OWyovvidoh1ymtZdNAigNx24g=;
 b=NIS1B+M2BSwcMwGtclTy5LY0xdqfFKxBMZgc+AwXGeBABLnbaTmYgkLTDEgo9Cix5iegb3euOj4N7brCbk473YHCXh/12L15kYGuyV2+5MFuRtNNtseLiiqI0pseMHZrbbBVwW+YNoJbz/S6h0Z5EHGF+cu+c2JhylBxfqrQD/A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH0PR04MB7269.namprd04.prod.outlook.com (2603:10b6:510:1c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 11:48:44 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 11:48:44 +0000
Date: Wed, 22 Jul 2026 13:48:35 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: use %pe for error code output
Message-ID: <amCttaG3DV6T30dz@mayhem.fritz.box>
References: <4ada48c6c1ae4978d6e6be44008b0060a7edaeae.1784705640.git.wqu@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ada48c6c1ae4978d6e6be44008b0060a7edaeae.1784705640.git.wqu@suse.com>
X-ClientProxiedBy: FR0P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH0PR04MB7269:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a9134fa-72c9-427c-b668-08dee7e72eac
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|10070799003|19092799006|23010399003|366016|1800799024|22082099003|18002099003|56012099006|11063799006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
 fAhWzgnOH1JjsM/3FDKGkvDhSUZw/OtRu+NkY3C/wnPHdZnNi91DuqZfMDp8Vkv8Ai6sjUgCbFnBbr8mcza/5Q3I3w6qseRJ9d2G4M7GANY1hc40steDbpSiVhQq3gBNuhbZT5BIUSXkDzuGiCFEi6js4/4OEue8VCh+/LtZgkJjH0JLoJ8fD6b63B2grVaG2kGGtlSAx9KQ16kesxeCHMoYfTlhzd/uHXoN+eDB6HQVVoH4Rl0bm/o9tjUYINFIAbUlW/zT4A84tA1bILHBY4F+5+MhtWG+Qcnha6iQvI8mAhu3FXqzEV8WJxZ04qnKq6vCxi9XPHseIMt89HtQg/zSVt53yDE1rSZt/x7n+FaFQT2bfWMd8E8JG4LzAB40wS1xUk0cD0JSvisGoSN/cSHiVCItdsDbFEyTcXzxiJEnY9zpfT/JvDYsvQgLDD9MykeN2uFro2ix+fG1DowMVpn+3ku+ogLwL5G6kIQL5gZv9gwcCYCMB7RLr4s7UYmmSM32dXPRa5VHbBD879DCNx44MMGr5Npo0EuAlZMnT7nfX8C/7WtprS5UBl0LXHctNDgvzKaYuSvKBIHxFqFFnBN2bB0DvViReJEkOdPhQxkB9PT0kX/qIqAgVXgVNoY11awHlFDJFFUR3BGc1ErJLklYm4Ntu7ccnq0cksw/MhE=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(19092799006)(23010399003)(366016)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?hV22PIcwLkiB8qj1Nbs3Avam7ymjKGZ7FH/YvkhwL0xq6Mzqi62maDrGLwWW?=
 =?us-ascii?Q?3OgCHQpbJd95gRKZFqnBx/NDNq67WkatiHkigVeBueGoTrUsoEoRrgiUD6Ha?=
 =?us-ascii?Q?Sd0EeziCNr+rz2ctLnL+r0RbWCKtDxYM4noal8D7PBxBp+sEi9vJ/Hw5EdUZ?=
 =?us-ascii?Q?7LICmjhLCXbcW3VPIfn4jL+gPqnKVfHZ5dmFvUg9d060bDc6IPeAputlD6dG?=
 =?us-ascii?Q?7k1O6JM/z0Ya45aujJEXlYfNqS6s7fyNMudLeojfJIIiNeq70g4SEvQJzy2L?=
 =?us-ascii?Q?eV001pfBcgq0n+pU8xAPM+LatthHFGCn4afShraj3DL+lfHM9QUcIPwATxA8?=
 =?us-ascii?Q?sHTIVUkj26ascRQ5nlTBCkvWvu9SZWiRtmpMSlzmFA08KJdvfY0BZ/DKqE0g?=
 =?us-ascii?Q?Volln4S+uOdHBPohI/vPwwPwwb53HWaiwbrF+VE8MZaFvDSfb43/1oVYjomr?=
 =?us-ascii?Q?r0ed5rDjs2oxbaYiRSo1R7fDSt2bKGdNBes6PsqBNnNM14H8H71r6I7xnrQE?=
 =?us-ascii?Q?Uo0Z/I2d66udPkIVfiQJogCuOWFrKs+quNM3LLML9DaNciomE+2VI4R4MBVU?=
 =?us-ascii?Q?p6oyVWGx0tCni3RMWvOg5mZ3a6cmSmoiy8CWW+YTxPj+0nlQPsr8vT/SbuXs?=
 =?us-ascii?Q?8a68Esh+A7DlckE5cSrKst0HwB3rKGjyWRZk5pwI+Cx/wTYiZq1kpURC+/8z?=
 =?us-ascii?Q?+759wOpc/3f/yyU7fiFfGnDXDoG9mfYn2m+FyjcqcCBCkdurtubg+h5sRP02?=
 =?us-ascii?Q?RpwicVBHub04Xhr0rnLfDQ6F48AzvW8bM1bKYUyYj3Rcr+e9xO08VT5cNVDd?=
 =?us-ascii?Q?4AJT7W2G9OSvyivjxLhy39btu+3KNmeFC+XPWgMFcffyZVQTXmLIOwG8JjnI?=
 =?us-ascii?Q?1+VL8ok67MWPeG5NX2wI0Ve85y0toDYgaWshaZr9RIQvrjGsbUd1xUNHvF2G?=
 =?us-ascii?Q?TqvWzuW53axWNl5clCZV3lGeRLGlSL/zNcQFSPLEv8fRJ90PladzZSxuoPvL?=
 =?us-ascii?Q?VMpt6OYGr3kNfqqS2v9jisFf16IOkQxEhL5A/HSXUIQPlDHx5cj6UuGppY3M?=
 =?us-ascii?Q?wQPSO8SlY4RpMqNTJelVFIi27k1CRX/A3PN+QTjlyP0jCtAzayEklWNlSre/?=
 =?us-ascii?Q?iI/wunZPUBj6u/IqeRL7501ZIUed24eX1rnUPkn7GPxu69v0uIzB+zwwVJI1?=
 =?us-ascii?Q?PjZN075lNIRKFHpSftaMr/znTomMD9xvz+v2TbGE9SEqV1B80xguhcqzvoWP?=
 =?us-ascii?Q?+F/ZXav2mAk5Jlq+pebnkilJ2/wT3QEUbw5zU75HwlS7ARkQ5AmjNN/AIz2S?=
 =?us-ascii?Q?OACZxZvOAqubvXFhR9gReaSxUJkCqkSEyjDGa3aH88a96dGqy5krkPqXqa1B?=
 =?us-ascii?Q?lDIXZuCLRoboiGXZA4anZur2wAWEggNoP9iR9HSJ9l3fSv0Pb48sdx2nZTXt?=
 =?us-ascii?Q?SuqXD0GQLpOv1SRMx/LwbcJUZQf9ZbI17xb29Hh1cMC8qKdM09j+cNw7X3T3?=
 =?us-ascii?Q?1MMrxIk+GL+9H6qxb3jvW9EIWxAR2SJ9Sns2l1QhsJwPHhAvRfXDWfwzbZtJ?=
 =?us-ascii?Q?DqUHRtLfjasuGAfbEiVovcgrVAXvIswxtbBG2TR5QmBusCHo5pwBCwmd3/Wr?=
 =?us-ascii?Q?kRGZzFU4QWFaAk0wbr10PeT3UdppZ7X2UtmqCr0w35wU2PNjO7uy7zbQyW8P?=
 =?us-ascii?Q?GdlpdWS4wU+2sBhJ4jZ2MEGpc8Du5JdYNyHmGdGUqE2BNt7gC/ATKlc15s3F?=
 =?us-ascii?Q?s5OpDktM/oyGl5MJIqGzBBfKnrQqAgPURGphsERs8CuM3DJaXlL4u9WD/IQT?=
X-MS-Exchange-AntiSpam-MessageData-1: w9dxKRIhM1jxBX05VVhJHKcHTrz7ah/OKsU=
X-Exchange-RoutingPolicyChecked:
	F7uYtAeUXm//P/lsmj6VfJTwwbT+6mkOmmodDxRjX2VxUdUiE7F8+hVwK1MEyUqSX5o3AdNvA4AU70s75BrenjOIkhUJ3MXf2WUn5Po9Q834BUqhc7eWgvix9iF3KE8K37PkGLKYvvDNwX/Ya9rOhQXaniGLBneapT4jv/FEl+vy7BbP6XHhvMcVXzysP4Xe6YlnpfaLGJCi/w5U/c7o3msm5a0ocCtb9vbCaWeLYAumjKHnNkYeeRXIURMUAV/yG8ad9zx4QP+9iS3/pqwWpmZ3ptYKTVuEbjFpIv2SYefIADMHIF+TN//90tcR0m8MvSbZ+34EAVFPhxbKknAmiQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UGTdy2qxnumVzND60HTJCAdDhebsUao6AIEmnpz7pB1o/CWrkJAhXLheDF+t0dnDqqaGYoR5PTgiceLobXSFO+NUmEjzqQHWe5A14LewY1naRw9Zii9GsfY4phMPR5bSPfjJVzVamc08GQ1rsQx1qe7aCdYQZpzDJInvjKwDu/WmejCRqvvy4pN5slFvbII6ge/ncTDZ8+CVrVxbmL7XD6QKtNaA7mRSKLFaOfkcvwubyacTt08/QZMUgwVjpVapwdi2S/0Mk1HGluTi2GDrwdliNQT16qlzd1M8xpSMGLMMgfU9v4F0Kwvwi83DD7kJn1sLyfyUhkJjzPfX59SKdSRSPu7oF3C+SgZuLTZQWsBmtsJ8oi7vF6aCXAGuXR8sKNT1gzikk7AX731PmS/UOYuc1fBQSL6xJeHQ2Sx8H51jB9KwSJMZ9q9HUdDXUjiLSDTQ+oXhaZrqzVSMzJ8li3fEjd6iNW43eqWn59k1rhYpH+Na88p0XRx+c9yqL3Hkmv8sRr8g5KkHFbiDWCcygI/qfWH7mRjYwzcM28lWjGSiJSn9qbNjLOBRBeIg0EWVlK98wJ5LI4jTD7SIcxhAYD78bHoiVmf0fQGJOtm4PL7X9erzJv/H3YoxZKQspOXH
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a9134fa-72c9-427c-b668-08dee7e72eac
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 11:48:44.0661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G0G+qlltn8rZLz5sAoukAvh61lqk3Ut14lm07nJrMTSt3pOEkmpQMsLaueR8zBcBJ4+wzGOEg89vStppk560tdg/emYjyqGL4/+Z4dJS4l4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7269

On Wed, Jul 22, 2026 at 05:04:07PM +0930, Qu Wenruo wrote:
> During an interrupted mount, I got the following messages:
> 
>  workqueue: Failed to create a rescuer kthread for wq "btrfs-qgroup-rescan": -EINTR
>  BTRFS error (device dm-3): open_ctree failed: -12

Awesome, I didn't know we have a "strerror()" in the kernel now :).

> Workqueue code is outputting a human readable error string, meanwhile
> we're still using a numeric error code.
> 
> So follow the workqueue code to use "%pe" format, which will
> automatically convert an error pointer to the human readable string.
> 
> However this is a minor pitfall, if the return value is not an error
> code, e.g. a positive number, "%pe" with "ERR_PTR(ret)" will output the
> pointer as a hash value, e.g.:
> 
>  ret=1 %pe out=0000000019414716
>  ret=-22 %pe out=-EINVAL
> 
> So we should not use this "%pe" output for callsites that are known to
> return positive values.

Or not blindly print return values that aren't errors.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
