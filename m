Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22D231960A;
	Fri, 24 Apr 2026 07:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777014090; cv=fail; b=NoYq4s0UWO7LkRwUjYCCbxKsmmLq27vWfvYXqtVuT0bD9sjGPwTrjLGWRaXcDT+QfewEp8qrD1ltzfR6qq3hJC0NRDDHcMVKvWt6nSIg59DTmoJ8dEDpDDN+mjBDar77MrQqmsZvL+ptdKAq9m/uAzn+7WYdlMcpNOXMMkTpE48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777014090; c=relaxed/simple;
	bh=o/44RF8Ont5vEzxu1TPU8lIa5KtsBIPZ0pqDvhGvhO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D7k03Dkg4vwqHuTSp4LIJsxwjcf/YQ/3cZpXmQ/hUbSsYD2Rg/ytLJoHT2K3EGim76Wdz7NtPb+bZp3SkLBenr+8H49VYRZBYQ1hhzbjwZxgQHMw9Ekr/IgSjCA8BUuNzTDLnsrV9qWEAeP/5DkQUvIReFvb8THocKi/tfkWaxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iBG+/fhv; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Psnp8yr/; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iBG+/fhv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Psnp8yr/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1777014088; x=1808550088;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=o/44RF8Ont5vEzxu1TPU8lIa5KtsBIPZ0pqDvhGvhO0=;
  b=iBG+/fhvQUCTYk70YtQEkTOK2fX1JD6ISHumbFY4UkWEuAUhXxLLOrHK
   L8fCH419Y2/i1hKcPWow56KylESZ0pi2pxr8Blxbjx19Corz/B0xB9amB
   Th/M1lZnEidWGDaaElyOgVaSmdJXi88rLxAxRpZClUW+OGHMqx1izRVqZ
   L1oLUe6yRKlUWbrMGFizIDYccwTlgcdaqmiOKhVzhRt0y5KiepglyXFit
   66KWDevJXSoc5CEt7OntFbZNJ0kR6UOCfXlbrAJE87OPKBt9TbNCuFvn9
   QvOF6eydBrfjvC+Uiy8AfWQrGuJ63jge1LeVBvVIFibdzuKZHsnpVJJ97
   w==;
X-CSE-ConnectionGUID: MBnN4KtUQXeKNPsV7GIo5w==
X-CSE-MsgGUID: DO1bHeTtSBq06aEhubNhkw==
X-IronPort-AV: E=Sophos;i="6.23,196,1770566400"; 
   d="scan'208";a="144046712"
Received: from mail-centralusazon11010030.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.30])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Apr 2026 15:01:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PwT47bhDrC7rL7GEDhWmzSKRKfAsSOt9T7Ku4R2qrOU8XlbwRC7E8TE3TRhC1MSHxYTo5lzKxn2EPXirugxLdFivHV73Sl7BJylwla2GMDZyedxi1oiMWq3AX7YWtFUiYdTrxZyYE5StkAvzFC0jswrkxHuWQKWG2BpzgAFn8gYorx+gb4r4nmb6ZCfs+YXgt9lvcu+wq8IpQy4pRWyRV4mkqdJuPad/0tD8bzhZmL39SEnnoe78MHHfNaNpFSwhUA1dcgMQ6IxlFOf9H+wUUpPGbEvC5RTn9bN2+fJYuclLSJKOKIL19S3CzzJTMGxU7xSnk1NQaZ4IqGw1wjaWAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIXM/tPf5nECtZ07TsM+/kGdNGDW86FAbJNbT/rLbZw=;
 b=hrxoRtIDlDF6aiRZ0JTFxlDvT15/mJspK03+1H596z0tTwaDQnsCYFBaiMBSl4L+LrtM4qtYJKZO6edSVd7utAv3fbp+toMbHyk40aKsPALqcMiLIS3hSTFCbMLKO1mNbMhnW/Vt6c7zSJz5xOk1FlJ4OynqX+oFFDekgpZeGwoKlgMIZLrzo919L7BRC5rqPH75Eyn/xLEQ5P9Z+ItiTm0Qf+/zCWs+q8IwKQ/aJp79otDLbSb2KDXUtDB6poIhj/YiQb5DocFq8GjM/Y+wXLFWoKuNONq/sX0nygZy0SNxQW/DIvo32DrV5BhBRqU6b+IT8wC7XnBkmypYe4asrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIXM/tPf5nECtZ07TsM+/kGdNGDW86FAbJNbT/rLbZw=;
 b=Psnp8yr/zDvS0k6JBpO5XGyfp+mTqRZcVd3doARP33KvGr+H2wKYiwJdRpclqtWQjNyyVvi0yL8OuVWRHW+8k2hY6/JYv4I0y9nINm1YjhSC5jHejDunBHuEujr5MDD4bMFA5KnSoYoevxvDYnsPOM5A6N9gtWR7MebShpFZEQ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by DM6PR04MB6970.namprd04.prod.outlook.com (2603:10b6:5:244::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.22; Fri, 24 Apr
 2026 07:01:20 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 07:01:12 +0000
Date: Fri, 24 Apr 2026 16:01:05 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>, 
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] generic/793: limit number of overwrites
Message-ID: <aesUG04ZDkcyGqQ-@shinmob>
References: <20260424062222.87298-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424062222.87298-1-johannes.thumshirn@wdc.com>
X-ClientProxiedBy: TYCP286CA0191.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:382::16) To SN7PR04MB8532.namprd04.prod.outlook.com
 (2603:10b6:806:350::6)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR04MB8532:EE_|DM6PR04MB6970:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a84752-9267-46c9-5123-08dea1cf4461
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ScAdvtMKtTooEos3Aj/0TKH/ToWcxJUTOm3xwBQq443rKSKSxj/ZDlgYPCCjMRGgFyJ4+dCMl4TwutYQC4dvG8JVSu4AIzU7OAheDnNo1MJGjzUN8f3OISVzaaXE/07Ixp9aJlxtoGnUKFpveWtVUkvRoHXcACm2wRfZVbtLy1tvNw21iuuDYtYSse02VXP7oZ8y8XnFxyd7wOYahoMaTyPZx+bBkf4V/s/8Mx2qt48niTpjD/FF8uqbMZUudo40KVA0mtP1OSjqAVcKXdI8on/74AaaiUjtl/P567OYbeEBTy6Wcl18eHcBeUSJe4Z5gUDkCVw5X8BT7UQlMMD1AjmNtzhNB7Zo8sPJd7jPBOlwh6RgIISWVQJuqe6zKzv5uvUG2a58HuVUO3HC2gMv7PTXt0I8tRmCzacNSLT0eAePnGfK8ZrNY+zA6+/BS2R7EvezrJB+Un3bU95Nchp51C1ChMs6S32k+Q3t1LuLKVjKYuLX0kbVD/el138O+p2/wB8IsxlT/4L8TjqWSoUuLwJRFV18tmoMMe0I3Li0OYK1R2soRhF6H8YmSfXrqmWZ2W7geOcU8g5KcBBDWPEzLeevWh7gvZn6Hgpkq4KGBfxoe4dhgUNyv5ksRX8JSOi7rYyAAFtpwB0Q8dz9j3un+1s91Oy7ztrf3QUb1+/IuqmlBx6gULLzcr8k3f6bBV3HfV+Dg+s097NJNZOhINebXTKzwJ4dyGPnyKJ5LJLSRiM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Nm9F7WwlEthch4WaU1wa87kT4JB8/idomL7r2i9XbehxHisFfYHa3obhlPT7?=
 =?us-ascii?Q?A7Ez0qxbNF5kabzs9oQ42DKQey2/kAeRqv7vLQRJ2w999rW8e98YS38at5li?=
 =?us-ascii?Q?HJjCfqMmOtcflbsFpizPvBbCfgtkY6V1QONyUupR5SZrDH3Nu6I9dlHKj2oo?=
 =?us-ascii?Q?ok0EPpB823jW9A3X3XwkgbrPs12vTJE7+uIWJhbBCYOmpSOPeMPAz4M3K93C?=
 =?us-ascii?Q?uYlp5pQaVPjTFSpOWC64s4groNv5JhMSfxRj9XZwiUoQy1BukE08pPHZN50e?=
 =?us-ascii?Q?9QEfnef/Kny3GTWo71fBuJGvcLr1hptxTWYLm/9gg8c8v++y/XaZCkRVe0RW?=
 =?us-ascii?Q?Ui+YDQI906WPEbDrub7ZUkHIx02eeMFlsp2MgTT0Z+ycQx+ayCJjBKXo5JWQ?=
 =?us-ascii?Q?2FlgutfKB7Y/84d4Kt9rOIZj0GfkA+IZAsy5FPqtnESGDnYxSxJASCoaO/UZ?=
 =?us-ascii?Q?3uvvS52rpwwyfrj0wHtDqsaNJAsuoPQ92w1esiviOtYaCSok8qjqHXektDSL?=
 =?us-ascii?Q?Oe7dcLpSiHyFY5Vs2nT6tSAopejUO0xgulo8U0stLsOwb5IryGYO/Mq0Gk1+?=
 =?us-ascii?Q?wTH1q1Byw8rT/f6GDLWldW9q/bfRFTDM39vvO9ZFl9foyMm4lrI91K6isElV?=
 =?us-ascii?Q?UZvgJQ1s23cLycdGRHaMOeHhfRmsULbXu6brJ/2tDoQ7HWh+IAUPf3f4mnKA?=
 =?us-ascii?Q?SQVrtatt0hqFjQNLrOMCAiVD/wgd0tFa73/O/F8za3rfgp14dsVq/Gz7TdcS?=
 =?us-ascii?Q?mvI65/9k7062gm3TaMN71h0DzBHJkMS47D4LI1XDYda0AovoNqotsFN6GI3Q?=
 =?us-ascii?Q?Bi0vdkUNtd234GbA7fn658pt9GjXk7A1YINswg4XCaMW5HjVNGIh3oia2jwy?=
 =?us-ascii?Q?8lP76RG2CoufJQ95cRcM8suKq3TuvIFC8W1RMz5k0+wB4O9QtkknParkbHcn?=
 =?us-ascii?Q?PdrBec9kRG6ETVmpoijdllH+k3Ae3y52kI7Y+S2T1tVeQAg2Gm9bB76qxmoE?=
 =?us-ascii?Q?9ZbnhiF6z+1CirjeOeSKptDGS0NPu+Mf9OekgZMxFiwHqU+wRq23CqRl13me?=
 =?us-ascii?Q?og9hMnUt9RQAvn/6JBKIMiU0vznlX7h/gNWtcZU+U4sTMAfrEStunOoY2XoX?=
 =?us-ascii?Q?VinIZp2ZYyi9f4qBKmpHRm0nuXcWWEI64RTtTJAT1x3acsY244YYXN+Pgy5h?=
 =?us-ascii?Q?XfFnKQNIbYY96tzDkHpXN0gZcHGg6cPWSzYRAO/0+cBHjTJHXbDJ8NJnYsBB?=
 =?us-ascii?Q?m5s/7uu/lzMs1xfBACh/nRbKRw1G0JaBOGL4MWMXl2NHRpbCwOwbEQLHnuf3?=
 =?us-ascii?Q?kRbd/LSNN4c98yL8cYqRIjeDKPJD79gF5sPjwo8tacsf0WRaw96J9IvrSRs/?=
 =?us-ascii?Q?kVLOBFqJhvFa8HcZOf/ZKmNNjLsV2i0kgkpdvsa7G4vXQe1fXQFrCDqOup1U?=
 =?us-ascii?Q?ACv1BwI95zMVOAAAMU29MUDQaCwZZA9np949+zFwJ/t6n3cZV+x7jACQCm6m?=
 =?us-ascii?Q?ckPTLAQelSP8UjFtP0CKhd/MXwF1/doErkMX8eCb3/eHazmt5dIkiYo4s2Af?=
 =?us-ascii?Q?gluUufHw/6R25Xsdht1LFaPnc4njUhKlCYgZVRu34qvLbUtL0T1sW57CDww/?=
 =?us-ascii?Q?Q0PySDMzXHprqRTT8tO3wQ6Be6gUcl56oXYwROy+qW3YH0glsOslIiXUBpDF?=
 =?us-ascii?Q?iV6cAerSjU1QiFafWyibsX41fsGYYG1Zg2ei0rudgABAPUaWzKfpgtpPuO6H?=
 =?us-ascii?Q?ogUETPOkaLe7qzdcuZPS/XsNICdRZXI=3D?=
X-Exchange-RoutingPolicyChecked:
	j96EsHt2wSmjmAb1f+jN9w0vMEfhrNPfzoLhLxOubR+jDAite9ZLHbqQdAJrm4WwZAi+R5C7P0vFWqp52mhwzJBXXr86JfaFlyGiDIUSsVLwFJL2lHQX934P53sqhvHMCQzcOex9xjlhGgz9kYShEQxtElERcIyhigaxU1Xp9xIrnoBOllXt9fklfwIq4KXb6KHmw6VazhkTUjcJMSUGvYrHkttU/BXsIymUJgd1gN7tUP3iDkK1AfSPMLBS5Woknf5i7kqP8jwtQ6/+EkkwXWuKYqRQY4YYitEUihuHbg6wQWhWyvbWqEXDpzEg7x2WcbxXJdKpGITpqlGjQZMngw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1bqG8Uguulsv6WxqFaxOACAf84k6nTWm0tKfVLqOcJOvu6pNPpPvi0e/XrAdNxSvKyVIeDHJAOzBAooIqbpnIpq+nq/MY+pbVynCAdYCOwr4xSHtcT+Mo5dvU59GQ9itGmKCb9DhubAqeOKbf5jQR7v4ykIUWLg8vUmPxuX+ZgzM8/9nUTbU28XPN6WOtbZZBUBmMJd2JlAkEd3J6lraykDF3h5DsGUqyA2KAPkXBUztKFzi9t/d0hZlJFB4JxXpu0UWkJL4VNQxB1BmJekk1X/UduZCFXdBoLTwwZf+YTBvK7UYI2WPHnA5qsd4ViZDqMbPr9j058hN8ytIih0+BZzZhLETjMH8N4CCyTiL1RRxJ7JgX2ZrI10BOK7qJH3IMM+Hn4FeMeRdsPje4uOE3bZaR/W5ZQf0ZZ12WSZuGdHMeXb8KQMnehnOW4FXME3yLvrcwJvULkRsAgej9TZLNX8oaFqdYXR3F7JDnk06wgCCD1SAlFbgNE0izHRr+K9SSUtu4AXucrywtTmoEEdhmKcfm/Yoh6S3IHP1UY4TcIv8KT3bD4QA2xbJy53tEMYlKJjIxeBSpneCWrc59YhOasXUIFLSS8CjoTQSlBL2NoWH7rvh6OnNe94Fycw2M8Dq
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a84752-9267-46c9-5123-08dea1cf4461
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 07:01:12.4984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F6R1vJns6/2b8x4jI00nPARVS3G2h2nO4VzIk8OJjJgZvDQBLe1hBYnWd8lwcoZx5O/IZ6oH3maspUu5dt+oa2TPBYtkPdjiRVq0hRaXO9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6970

On Apr 24, 2026 / 08:22, Johannes Thumshirn wrote:
> Testcase generic/793 overwrites a 1GB file "number of sequential zones"
> times in order to trigger a bug in zoned BTRFS' garbage collection. But on
> scratch devices with a huge number of sequential zones (like SMR drives)
> this can cause very long runtimes.
> 
> As the testcase also limits the filesystem size to 16GB, constraint the
> number of overwrite loops to the number of sequential zones in the
> filesystem. This still guarantees that the file will be overwritten often
> enough to trigger the bug while not exploding the overall test runtime.
> 
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Thanks for the fix. Without this fix, the testcase run for SMR drives did not
complete even after 10 hours run. I applied the patch and confrimed that the
testcase completes within 7 minutes or so.

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
