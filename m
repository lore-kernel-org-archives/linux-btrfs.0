Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A49835FF5B
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 09:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781860146; cv=fail; b=qazo6P61o+px1HoxBxjTjSJ+bJtnjZbLbFKw3N8/UlgvcuXYSJX91rNIjX51Vz4WQsfQkzMTk7ekvUvBiDA6JjhGwObjeflCVsN89GpUvO7Hx8R8ex7qgqN42Sxw/oSO8zdev+KH3xpcxyrUCPOfndpIGuSmqTSXzu1M2KvyCEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781860146; c=relaxed/simple;
	bh=Ji3TGhJzDny8rGT8CoH5M2xumaxfAigUvDKGoXJlaO8=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O1gSHHVSuU41gQfwrEZbAVQui/7mYsYNyPTAG4R9BGwjN6c9bBKpMIu2G8eChxl5F/IGhpt5/Tga1cNG7zSJmBtfYy6+nd0ygZHQp3+37JEqg+a/z+N3XZI8+2kBqx1EGlaqCmoBL24+xjaDPcflSvkIjHExVJjefImialTsl40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lejGOqMO; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=EAEa8V4o; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lejGOqMO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EAEa8V4o"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781860147; x=1813396147;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Ji3TGhJzDny8rGT8CoH5M2xumaxfAigUvDKGoXJlaO8=;
  b=lejGOqMOiz8eYWsTFz1qKmFwXJno8xPG7NrmpQKKKMYiMrgJER8yWtw6
   ++YopsF6KGMJIOebp1aF3kpCTnwK+w6neBKCbD+CkM4XIw7h8GIXOH9vh
   XWVPnFwhliYCJNx3hjVRXGvVwHfrWt+bnshIEnov7w9r8SUrrwVXPxF5J
   5mxW0jH08r6xDgWj4SOLh3YqMHNT6/NTDCfR+9gz8qBc4kXLNqWTRbdJA
   UkR6qMwKLUpEyEkn6B2mI8fs8mgdqyyGfx4rHRgDdQJEnSJqLDD8TarSv
   /U61Ut/YmN6UasU0bjYrARBYnDIYGOV3OHwB+5w5wYTyM46rSHfh5lE8Q
   A==;
X-CSE-ConnectionGUID: pbiOOulqTyuKAizjNledMQ==
X-CSE-MsgGUID: +/oau0lIRYq7t8mnWUERDQ==
X-IronPort-AV: E=Sophos;i="6.24,213,1774281600"; 
   d="scan'208";a="149463351"
Received: from mail-northcentralusazon11012007.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.7])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 17:09:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ctUT9L4VdMfB/cc/v17O9YrNw+zOkQAczb5XFVB+PRtITx7ZtQkmQgE+mytkFlsWYwdEN9JpfzzxRqw7elTkCEohJ2jjM21LxPPEJh9YubNsi67OHlIF5195bJICT1WoCi0gEDFeJafpoTv03t5nS331DBhqGkjI1nK1fXaAWYYBuJCRlwCv8Vuy47G5IEMd/Um0YisVz19WQ4X5u6rNNQ59iyKnBbDMuWAe8jK5e7jF1v/0MYZgYVHyt7KppSPZH7PEOPZRsu5hPJNHxPW0W2gA+Gsiw+nJkyvgmWgjgrYFRQ1slGSfe1sd/1CTiFgkYABNkIA4H/tgXhKD7PwcJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ji3TGhJzDny8rGT8CoH5M2xumaxfAigUvDKGoXJlaO8=;
 b=ZhlbP8sA4FQ8RI62QTl3kVRIcWPoPINY84TjqjieFIvPOXHB0ueLp+Pz3ZXX7AGI9p+2mrFzVXSToXuCsK/Q6qQEF2W39tjLd78vMDJlnP9rhO4QRoc0itvAJ394m4F6IaOIJFU/l2yHRnhEyIBxt268IpwV8SDiBeBFtRgDMFLs6g+FwqcmY6ZzHjayWFlBaq+kivwUon7ZklJz8rFDOt3tzLyzSXS0aGohbWjyJLn1TqL9yXx2NGkPK+fZu1XD9y0DVJj3B1tVpHA74Ega4S7r3gtNRdhxzzilPPsPyimuuyq9pKtzmYxfWd6Q+ulwFlaovH3glJQEi9CWEw34SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ji3TGhJzDny8rGT8CoH5M2xumaxfAigUvDKGoXJlaO8=;
 b=EAEa8V4oGRyKNuE08QQE6Yprtmf3+SBNNFLvjBiR8uveAk+dJbwvEtLbXouCs/TQ5FUUEdO9H25aZCHU7xn4h3IuBlKQ/HB/ZS8+9e/uxcf+tI7ZdmJI/negMcr3Mutw627rT+n5lV5SCjEWWtmfBOopnbpit1g+r2MVTo+f6l0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB7052.namprd04.prod.outlook.com (2603:10b6:5:24d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Fri, 19 Jun
 2026 09:09:02 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 09:09:02 +0000
Message-ID: <4ae943a8-c3e4-4ce0-adee-b2370e036dee@wdc.com>
Date: Fri, 19 Jun 2026 11:08:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] btrfs: allow any block size that is no larger than
 page size
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1781859111.git.wqu@suse.com>
 <501cf54f07025b6fa11a74baf0f7156684902391.1781859111.git.wqu@suse.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <501cf54f07025b6fa11a74baf0f7156684902391.1781859111.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::14) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB7052:EE_
X-MS-Office365-Filtering-Correlation-Id: a5b2e9c3-4f6d-4d8d-d345-08decde267c8
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|19092799006|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 hFYORYUNTpK8eBudqNwRW1MGHj/a3YDITbUpkGwoPXcW0iX4py+Oov6NzzwtfZXizwA6oHdhuHibzxtH0I7jLbjPcdo92YBJHU9EKMrq5+a3eAlf5W5V1QMC3GSj21RQCIwj+Oat3Cdb2eW8W4/z3fFWO4kPsW8bb941HiY5EC8zZnz6ex1JBGSMzzLx5RWOeOK4biiOqEKofEqGjPimfXlDJKHGH3HNKTSHAimqmYmIACQEURmwx8H9CciITSpkLCUFf4dg41p3RC5iU0w7xtQWawtImaasAmLyKwC7g7hxLmm91p1Jkuu6y7TmKd/Pn42NQvFofBbh1PjZ7f2jVbNIbCKqHulyWhtZeEckF8aUkTu+VQQPX6gT/hnWu/Fj87S9BoWrVuLBsZzlV81GhE0wh5zbh8BUShID//cAi2cv1O1VLiP5R2QOoitGoonZ9IClFUKxP0/wZcjNrKuviEeYiN1kEcCWd0m/FDygJUDVk04UcOCDe7fhSbMM7VEDEIuKMIqypmR+Q35GwrsWPUPnVrqb4yKInlpXb6J4X0PEyjtQGC5KCi4RMgdgIExzK6XkSFZR3+WNDtXHWfD4fy6jZrT8uiYWtyPCtjzIP+dxL9OdZ0bR8c/xAHSUK+bDiLDwXpg7QrVOfCPxjxHzhEEEXXhu3cGhOY82SECWf+s=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(19092799006)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dDNwNnpheTVQR3R5TlhvNlg3MEdkclQ3b2JlUFpBMGdYSDFBaWFYWTI3dzJi?=
 =?utf-8?B?V0JBT3NVK21nQkE5OG1qeU5GVi9zam9SWEFwcHg2TDdMenM4ZStxNzgwNElJ?=
 =?utf-8?B?SkIxamJMR3pYMVJxMWJ3MVRXVndiTWE1ekk1Y0tVRE1lYmswbmVTSGtkaXNY?=
 =?utf-8?B?UWhSc1d5QVZiKy9jVHVZK3R4dWhpWiszNVV3TERtM2cwVjNZMm5RUXNuZWlt?=
 =?utf-8?B?VzliZnZ6MTNOa05iWTVYMm1oT0t6T3Z0N3RwWm5rb0NTVTFMNXlIRjZJbVlK?=
 =?utf-8?B?dFNxdW1TTU1tVm9ERmh4NE9OUVkrT3lyTnMrcjhCS1JqVlVmdkFEQ3dseTk1?=
 =?utf-8?B?bzF6UVh1VTNCZnhCSXhzdjVuaGRtS3VOREN3YlZVOFlKRVhadXRUaVE2aEdr?=
 =?utf-8?B?Uk5DMzFJZUcrWFBIUkhyZlR1Sk5kQnljSFZabzFxOTdJTTd0T2RYa041QzY4?=
 =?utf-8?B?M1VxNUxTbGFsUG1HbzNHTDJubWdLQ2F2UzF6dkdwcUpzSjVKenRzM1Y3eFgy?=
 =?utf-8?B?VnJhLzRQYmYzVlNuUitReFdhUHRUeGQ4MGlSdVUvbzNoNjRHMXlZS2ZiS0Rm?=
 =?utf-8?B?N3VwUWFTNzJyWjJiTkFMV043cytXVml6d2ttZ0psYnNLM3RnaWhGTmtIYkVI?=
 =?utf-8?B?YVlodzRHVlBLWHJPcStKMXN1Vm56NE5oODcrL2NRcnMxL0p3TDQzUU1UdFhO?=
 =?utf-8?B?MHFBTzJDT0lEMWxZbEhleXc2YU5mdmVNR1ZocER4SndjVUE0WWtpWjU2QnZr?=
 =?utf-8?B?NnZiOTdaZWYzSVovUHJFbXdLQWtmZjVVdDBEYzRGcmtiWjBVK0hFbXBJY3Zm?=
 =?utf-8?B?QW1zTUpDUjhhMEtscGtyUFR1WmRVK2s2ZXlTYllsNzB4ZzF6eEZHWXRFaXlS?=
 =?utf-8?B?UVppbmZXaEFJdUNrSmtXMEVqcDZQazFlT29WSXNIcFdsWkcvYlkyZkMrRm9o?=
 =?utf-8?B?ZE5NUmo4d2NGT3F3LzRUaDRxWU5uT3VzelNYSGVRdlRBMERKUGpuQVhFRHJy?=
 =?utf-8?B?ci91ZmJ2bHRWc0ZSMjMvbXhHeVFFai9hb0RPVXByWEVmcW1wRFVIanlpT3Ni?=
 =?utf-8?B?RENHN1JPM0hjbWFmUVBoeWtNUkxHTWtMNXVqb1VmajVMd3dvejVNcERHVTNC?=
 =?utf-8?B?dXY5bGJLSkM2YVBLak5FZWQ2QllRMFd1b3JGc0tMNGk5dWJEMFNHZGJtb0FX?=
 =?utf-8?B?VllvSXgwTjF1MUVFR2xrenZjZW52VVdZMnVMdGhDbXA0eDNJRlZlMStRWHFh?=
 =?utf-8?B?ck9PU3VtZjc1N2ZQSE82UTlXM1NuOVo5Nlk3MjR4SytLK0p2dnlqcFRVdzNT?=
 =?utf-8?B?TDRlZnJuL0xJbXNJU053M1RTcUUvbE5LRDJoTW4zRXhFSVp3VERzaHRnQUF3?=
 =?utf-8?B?eHdSQUpNSndBcHY2ZkYwWk0vQVJua0JRY2NJWVhoS0tjMFVvaGNQcklNYW9j?=
 =?utf-8?B?OW5ZTE1UNGxkNi9iWGVJbjVyOW9BOGsrTVR2cmRkaStuWG9OL2xWU05pT3ow?=
 =?utf-8?B?aUdVSDlXR09SaXhNWFMxT1lJcUQ2YzZneEdEVEkvUzRvK0YyeVpPMTk3dlRm?=
 =?utf-8?B?OVlLVmxjM0Q0SU1PbExCbmdDc3RNZDMwZXU4Y0l1amprbjg5SU41VVE0aE5B?=
 =?utf-8?B?UDhRY1dmL1UyVHl3VW5keWhVRlk2YjUwTTFPZ283eGNTZi9oY0lHOXdsRW5X?=
 =?utf-8?B?dWp2LzhCakxUbUZkQlo0ODNrV0daMW1JTGtCc0owbzlnZ1QwY0ZSRmIwSEl0?=
 =?utf-8?B?K0s1dmJTVFZ5MlYrdWUrTkpIZ200dXJ2ZUx0eGtUMVhTNnNoY01Nck5Ra2VK?=
 =?utf-8?B?T2Q3ZnRpYlVkMDZMYldLN1AxMjZ2R0tyNzBoSkNxd1F0bzc1RkJKaC81cXFS?=
 =?utf-8?B?K29RQ1pINTQ5ZzY5dk9GUjByKzFBN0tlRSs3aDl0KzB0UnFERnJoUWwzVEsr?=
 =?utf-8?B?a3RLdVdSUDBleVZYWkJoVUdlcWpkK0Z6VDRhV0tMWU9uWTk2OGRHa2szbTJ2?=
 =?utf-8?B?M3dRMjVJQ2swSmRRamF4Z1V6anBHZjRyeUZoR0Z2QkRmd0srQ08rVE5pK0w0?=
 =?utf-8?B?TXpKYk5VdWVJNW9ONTg4MFN4U1BUL3orMThER25mTkJiVTNOUHVWc256ZkpX?=
 =?utf-8?B?K0pQYmJuRVlrZTd2R0ttTlkvSGVySWxpa0RCWmxVNUpvZ1RYNHNvcWlTV3hS?=
 =?utf-8?B?cUt1eUJOdHNxQmlJVXZWMVFkeW9qV1NiMlFPT1NHWndrRjB3WmNVVkQxNnVG?=
 =?utf-8?B?RnkyekJRVU45d2pqcTJ5K2VsektYYXBnYUtFYW1tcmRVY0lmTDlYLzNNMEFu?=
 =?utf-8?B?U042dUhEZzllZW9FT1JHQ1pGa1ZiTzg3NHNlMm1XQ0l1WExIbEFUQjdxalZL?=
 =?utf-8?Q?mgQpwyL9uEnpslic=3D?=
X-Exchange-RoutingPolicyChecked:
	sT2VLN8wYWOHfkebALiFZPOW9CauSIJvYJaQgHaXUWKOzAevQA2pNICKgn0XH4SWcyYCv1h5F/qqkRt9g9H3OmC02o0wzF10gbwu+FFcgmzeO0PaOm9E7OxOjuPdfh6aSu+Qtq0i+4CzwxGtAQRMgCcCK/2IpD1UfaZ+jS6SxijumJPNBpZmWcdpJIg4gg2+lvtIF+lxOsUMyDIisrJcuOuZG3RcgAMToeSW9IgRXM7N81mZuphDC9mXfiHrS/0wt4zi1RuYjrjYJ4Q/MNQMF4UHlw9KMjQcRHWs+9gN2EQlf0aveq2qUijPHfzhjRc8VzLLxnzs+HcxYVOUPlQjVQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tEVVMxUWQ1hMEcWbxaW90Qz1PB3mb7RfiFIPofK1rifHqgldfh6rZ9t/bGDlh/irp2M8XU1XlaQBf2b0YXRLW4fNSB52o04ZEEUXLjjMinaFO4QxtSittsZiGVDrqO965tTJeIXkGaMmcEF4sRjFogBm1iVlAU07QIGB8zr5fpNilbMzKEZ+JtOM++jteghTD465Ac6kfZ9hf1Hbg9rKtflY8YhHmfLna30RVVW371nNGPL1XHgVMXwr2hzIeP8M9rcxmx6Rx5vkYHEZl9k5qtw6YCMrycCEiPNuoD9ZR7NDfxVPDs980tpP6vfXWZ9LUe1V4u0Ndl723wLJ8i9Q5KzYs6b0dPBqGlrR4epgHU+7KaaMsSWTDIt3BNUjt93SNuOm0p8ua3VJs9/GZrsyx7SL+qs0ArCq9edTNHrTwzDBN+5DoKo2sKNbAAGWaT18kMqy4Ik9jZS09wHV+iP3g2DRRyyMrNeSnW4a4eRFrL6qc9p0D+ca2HefQxFR5hZ8FGPVkXORRHjPvHNqHc0XcIS2KbdZq3ae/DDNu90JiHq4zNmXmEiZIxW8MF+V8o1WVCRfExzGHH6Ut5I+gUvzd1AOCe2H6RQMZ+p0Cwvq1Dt9lPglC41PbmD2tTFHB3DH
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b2e9c3-4f6d-4d8d-d345-08decde267c8
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 09:09:02.2876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 19zcRyp0tmY/3h7DrhOuiZWDAEoGjnmn4zLNrcqxY1hMVIo5+LWfXiy8l9DF0wXrh+MRrDiQnAS07kPCobtvcBmbsU6D/RNjHS2ESADVgLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7052

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
