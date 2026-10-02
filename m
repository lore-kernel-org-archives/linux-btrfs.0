Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A0743FD26
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 07:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926656; cv=fail; b=jn8epjswBRJPsx5pOVdGc6a4sBPLWYb0maJULosYh7LCiqN3L+jIbwBNcNPrCEtZpgbEgtD3qXfwsUe0Jxn6Almk3Kv3pL+XYbGnTO1L68yXNWIO6daYeYDCEK7vriFWi9gx+rTCDZMuZYuMrO4SqNKw3P3vLxVd6Wwyy6NSb2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926656; c=relaxed/simple;
	bh=v1yvaV7lpmN5i+gmzsZY7wHAb32kzSrtSSNHrZyXAM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IzqBvgKeok014Qb7NxtceIcoE2ogqhXs2I5UGKfve3F75zYMKJCjBiRCMu9b1aV8YkxRgh16UiBQyx3CqV3B7e3+eTQCEzR4U5iERp3/MGUKSfcZ9vdvlzjaDhhSJ9VtFyjdzLRfJRzMHzzSwYolzDUqrfWxnCf0upaXxMmkl5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=g7dVCThJ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=oQPYA4vY; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="g7dVCThJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oQPYA4vY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790926654; x=1822462654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=v1yvaV7lpmN5i+gmzsZY7wHAb32kzSrtSSNHrZyXAM0=;
  b=g7dVCThJHZXl8Kr3rgrTWFh9dsf+UVwFl/12+oDswtgPgQaObEY3FyeK
   G0QxrWCcDuTsSqrt25QY8BsODNnQnw3AkEonFkFUWW64lRPxE6SaF4Ic/
   jih/S7KRIVc3IYZBCM/cA+IUaj+k66UfiG78UQlicCOR/6APRX0OonvWQ
   SzYgvAUP27y8llxPaczWUo3mrjY7O7ewGb+UrEr3EqNhLS0C6xQSUjp2E
   yiha4XiVxMbSd9FQWV+JTKZ3VLCt1xcNU6BGwyLpgO8LedEy9uiRCVhfz
   gASoUOSUbJI+JFOuVV/6Z7d47ayu3XIS122wShrHpFCYoWK3DM9WJ9bH6
   g==;
X-CSE-ConnectionGUID: 2rIknYx9TTa/VGo+hQyQPQ==
X-CSE-MsgGUID: 1O1O9oHkQMKUSwo8EjWRgw==
X-IronPort-AV: E=Sophos;i="6.27,136,1786982400"; 
   d="scan'208";a="156966608"
Received: from mail-westus2azon11012070.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.70])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Oct 2026 15:37:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Idzdt4N8xB9HzZqmjk61BNSK4q/wgwoZ2xjy+MZVWCx2pJNBtITbAHTrlWvev4diZ2nWA0ePADimi9XnMjTNhau+ADz0gE0pDnDZBkQ+q1J+aa/QXrmlIPigSx0VJr8gKHv+RKQ4U9xAu6PXjypFFFXfVHVSmho7McSAjgrRPIWdkKaQgM9RBcb1h57w7rzBFI2hyuwrcv68Wp0NonX52HBG9LoyM+1bVS6H3Y/6jyCuLczbRQk3a/TsaU2kI5cXUUohsS9vdMt643KaDd5oPaDR/FZ7akT3SacfTvDTJ93Vx/ZFnbKFPkbOCizo5n6cVQ9S93zuJDgGVjyPE335iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFgLV2Xz/cax62CqR4urwoKM2zCMVbw4YzYoXZh1WHo=;
 b=rF+CDf5cyL2IiV+HXED9BFoyJ7R3egTvpenv6x3K53D8VhVTu/eJggUEwpPeLZWkEz2mUhHFa0U9HXDFJu+fObZZLnjLNYr09gMANC5Tt/aRd9uEk3U2YuKD7/uPgtUWVGFzWGaQMjoCVfWAqWLDyFXJTgTvBq5UvJ22jBOmjhT+TSNIty4ALObRpuqRxpiadWpDUvzfONYGrw76KD0mutzqrWiU5ZzHaq5iF4AbayjFd7nSDS+KVnPQfbTRpBrTyhq58AQ9VRg/4LIbRpz1sxtgT4XYnZ0Va5pQgo0rAmGlLI0X3TBfcy5G++a1OaOvEGwnyimbY53+JfhQpdWvMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFgLV2Xz/cax62CqR4urwoKM2zCMVbw4YzYoXZh1WHo=;
 b=oQPYA4vYUa+3yWOXQNY40j7BVg+Yi5ZdWhrHnXdUqWHCqPr2YpEyoeKuJfAjg+hDjA3LUPCokX+AHiQvbe1llnGgTdczTdcMAupVZYo0X9RCO90vUfg3hil2D+ieEhoScYRcSXzHRn9soBw2EImkTxm4m108VTR0Ydb/XLquZxM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6283.namprd04.prod.outlook.com (2603:10b6:5:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 07:37:27 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 07:37:27 +0000
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 2/4] btrfs: zoned: fix possible UAF in wait_eb_writebacks
Date: Fri,  2 Oct 2026 09:37:13 +0200
Message-ID: <20261002073715.2191177-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6283:EE_
X-MS-Office365-Filtering-Correlation-Id: 96759935-429d-41cb-a45c-08df205801df
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|366016|23010399003|1800799024|19092799006|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	uUtS+zucNrVe/jT9YdDA1lkdWrIC68jVmkmlXta1B+bVx/a/4vMEFBN9KwHB/uY3brkEWn84g79eCxEURxJbNPrmXVTouZAj09taJz2ZHgXZItBePw1xFXMNu4/1RB3ZfmBRxGdqYlGd1YDXgulLNIRJqEIvObgkMN9TIWc+g+wwXllIp4TnOaOFXlsq503BD7ZycL6lcF83pEErPlq8F4nHy7PSbtUORiipjmaw9y4kzjA90LioQq89qe1YaXr0/l+oBEK6rtiQNwat06qUC5xaI0UJv6hLbEm8Nn/VhLvBB4XG1Tc1dCb6NOPV959IUATMCODMgjquvSzbEr6SHX6l2YkQfTY19oA3sVwZi9rOyc9+8LqA/WCJkwMjfkEp03DjRJdhX3fJXYe+Raxj7UkZylnhWErp6wsJHz5vW/JAjw91cxqG6lAxsKGwzWBIV9zuL2qbmDEu9ubBAT8TLRcA1Xgw/gtyWbPTdwGGltkautTv82cTTRhk9pkYzM7P/9MqNZOJcdjOAe7rQK1zaNqGgWL2BfrlthJx+bY5ghfcl8Y1jLgLD47GK9h5ANVZec8XjFicxdNnOZCGNc1xlG6LakJVkp39K+XVxSUe/VNGchKQGD8wCkwhEnHKYpuW5qUDdaPH6OAZv0JhcaOXOw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(23010399003)(1800799024)(19092799006)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ONXq2TSXRpvxqVCDrx2kTHWwEvlwuYMab/Xt2TpJBMHNzRzTg+Gbwc5a/l+D?=
 =?us-ascii?Q?ZAHw9B11esuU1unHUb6uYa0VBoOjLjaBuJOKL3yzR154Pj3BUooe28PnwjaO?=
 =?us-ascii?Q?WU2Y/Ztjd9v/IoS2IJnuHD9N4NpVZkVkf93F2Uczo0BglwPjJMMUAs0ZFea0?=
 =?us-ascii?Q?uTT5fuUxkE5jFFtkcNu5V4lncSrDnB757KYiZaTmxeQPnBcjzujbN0QIWzKe?=
 =?us-ascii?Q?jYcHi+H7G0rLcH7mbe4LmVJMgg/b67ts+ClUg9TedXQU5G9xbQusY/md5Ajk?=
 =?us-ascii?Q?RBV8G8q41waNWgbAghehfIU3XXUuT76X/P+MjB/Bk2qrpEwYL5mW9tIsQG0d?=
 =?us-ascii?Q?j1baxYNI7HQm0/AH/yL3JT1U+Q9p1WZ3K4IYAqXvoUFZFrmD5utjlKlTdBXl?=
 =?us-ascii?Q?/rmH53CqNVK40LUM6ULVwGj/TL4/Izav/nvnNX/XrrLwWGn7GrNzHeEm07eX?=
 =?us-ascii?Q?Pno+GJ/YCNaTcpXjPMSyeCODhPFbGapMJyTqh5giS0Pn7D7LgD2IElKj88bW?=
 =?us-ascii?Q?F5+lonMDMNvDPPOwnvfzNGq5BIOXMPWTVUu28PLfzGgOhyBUfDXTDO+n9L37?=
 =?us-ascii?Q?IIEzRT5IxdLp9CbnTqLLtp5UUEd7Y76ppSpZDly7QJ6ZYhJDFaOMzvyfLP9g?=
 =?us-ascii?Q?VbXQY6Ck3ZrgAhLoZBm+CDtC4EP6hMOMIPb2H7uqyTWUQL1EeIugsaJV5jBa?=
 =?us-ascii?Q?+rb2Tfxfa4jkCVEFVLp+a8vKBIjsZStkXKr8U2m9W6yY6iTVoH/+i/4qq1wG?=
 =?us-ascii?Q?wb7RrLYTv1nc1pB3a9RhqT9g9e1J3LcZO4nRrv6TP3ZqPkJfIKh6B8gFFPPV?=
 =?us-ascii?Q?+XdK/bsE9Tts5lJrpEXwYrUKSWi9k+fNmsoQ2dVTJCiHRPxrWc9NwutCQ5XW?=
 =?us-ascii?Q?pcozo9kthW/Dfp5TS638enouKrYNZKX8mth6hyogJD4IqiZ3N1FeQxyAzJPH?=
 =?us-ascii?Q?AkfmItOkWvZnah6VNo00OhC7eK0wrqA9UVjbzxTRQqGoYuMxFW2SuoHUpvDK?=
 =?us-ascii?Q?Plx5cV3Yr2cFo8GFpQMPFvObvNG18gbaUiseywLob+srhHvVvgZYMKUV4wbF?=
 =?us-ascii?Q?L0klcXShQJRHXw3GyuORn2XhWiJ5cRsVUlg6WheATXedI2dMtLv2cv4JtQkI?=
 =?us-ascii?Q?4TFN/PjZhrJsHTbJjVg/uDU6O+DxOyFW6/yBgtmB+axulv49vW+Bs1OFFla2?=
 =?us-ascii?Q?FE89JVL5l77itZ4HUthqw/ODZETtmz3HONXapQWmpp+jPPFUmCfTIV7DIdYm?=
 =?us-ascii?Q?DKOI4s3wAD8AOuCAcAd+ZmCCQABTjUrxeNEwR5PEHDH9M9inMGYPeFIdAW5u?=
 =?us-ascii?Q?E1ePYectLKOWoZjJfh5S3Ujc4RuIMDAzMWMdVnACDpVdMhUIl0+EggXqEGST?=
 =?us-ascii?Q?1/ojiDETA8DOpGR182Su/yZqyXcOaxIZYanSR9VOlaXJtmWaKQiG2tv47HVw?=
 =?us-ascii?Q?7HC9x/4f2HGZC6j2teJuVloXxC2kpH+boCMFX/4otwgpjW3wQVd/nIkpCyuJ?=
 =?us-ascii?Q?bSmT2YNsRp98s/BumXvlfuU+HEUxgNSnY3dydo2HM46OHLgJEIEuzU7JXJFV?=
 =?us-ascii?Q?ZiCz11fR17v3QEYWcW+fH9boLCA1OtYxXIFWc/P9AKw9dT1dFVai1peFHI/H?=
 =?us-ascii?Q?2YIy6xgTape6xmHWk2xDPBZf7DFXTXDSl+wFhXJDMYWQWQMUlAC6mFJNcvqR?=
 =?us-ascii?Q?xVM8R9wg8yZ0RtspgKWW78yjwLMsr19ULKBd8jiy88cR2ku4NcKftKES+2Vz?=
 =?us-ascii?Q?x5M9E/YS7r6NtV+Lod0P1Q4LrbFUvP1CS73uaDW2J61PyBl5VCTUv2dJ49V9?=
X-MS-Exchange-AntiSpam-MessageData-1: Q2v7fVZyCwD2YrBoyGQ6toirarHwHgDAra0=
X-Exchange-RoutingPolicyChecked:
	HgJnA2p+6tiHU4+USehXZrrN4FAz/3R+9rb8LIhfFuxee2lJT+XpkiIRggg9t1ezJbCVCkZfBxTaQEsmnP16X5L04FGRLQMLPdxIlYvT5fN0a6n1pI9okjJAZeo7E2H6hqJQ6oeDT5vXW5xYroGfTIXUEJi8+iXEdfj/MsuJmUwacPmTmOXFRdhYxzqanTNHiU4otUw9s1NgpubRtia0xWrgluH+rOBN4Av1AenzmotSf75u0dDDTLHC+dLk3qernc6a6cwhZgkiFYV311GSObqq1HFkkjKE9/NAnabyvCEyQyyBZoNcmbrEKkjBOQv+Y2/ZLSW2zOmLcP6MHg313g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N3FQ6R232DxmvZOcVhCZVnUKsheaG+aBJvXRefNI7/40bYACQPI8rOn3c1J5o7+bI7/SfhSYsI1nIT36MA1tgdFk89cwYlaCuY/EYEmZL3U/TCS87J1TxOnjcyER7s3Znc49aYyDOClNWaD7vlxc+5OmQSlV4yjpul8uKPvl36jMmNLkj9XleCwxMEJHrmGECKyWyAWFlZZDwHLsDOo+vnDXhJi1pgt+b/rXb+GYrVc0E404sNeyPSJ4n4/zTq6IkCN5bZaiEUe1Rg0/SfKeIb1TCbNO1GaUWeg9LVGLAgJuN6Cf7IYewJKrXd1eKkcmCPLvtgtKFiLjDMqbhalM8cRZZwqla7N5aYapmcbyWFtMQNqrxLX/r8YmqovqRNiB4xwBS3AYiUl0S2/WQcoTC/qnTanbJHpbpSDbwm0ootLuCS8QqM6ATeLaRVh1U4VkCKpPKrI7seVWzxqLb8ZYuwvS/04EqlXz+SMNScWjryGRCigxCCa+dPAVDy6MTvnqD6JURrNDX7vmEIyUehybB4Vj6OUvxOwLYUWXatZxwEpNKF4OCt4NZakvf3fhhfB7XhlWLqXG9rnTQ39WGJ8gDhnYzM1PvIFX1rqGteuWNo0EXotIvO+JEBmjJs+zugkj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96759935-429d-41cb-a45c-08df205801df
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 07:37:27.1293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wOVMwslRsvFRFqVZbEj4fjfMlRjLQEkWRAGCIfuu2RGPIubu0tCjIidYraFxQw8E2i0Pw5u1sjoi4t9JFlSlbgsOqqfDIHbrGj42/sxvdwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6283

wait_eb_writebacks() iterates the fs_info->buffer_tree xarray and waits
for the writeback of these extent-buffers. Waiting for writeback needs
to be done without the rcu_read_lock() held (because it can sleep) and
thus the loop drops the rcu_read_lock() before calling into
wait_on_extent_buffer_writeback(). But extent_buffers are freed through
RCU, so if btrfs_release_extent_buffer_rcu() is scheduled while we're
still waiting on the writeback, the extent_buffer will be freed causing
a use-after-free.

Similar to what is done in find_extent_buffer_nolock(), get a reference
to the extent_buffer before calling into
wait_on_extent_buffer_writeback() so a sucessfull writeback does not
free the extent_buffer while we still have a reference to it.

Fixes: 2dd7e7bc0282 ("btrfs: zoned: wait for extent buffer IOs before finishing a zone")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index d68b91008e76..261e7991c1d1 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2513,8 +2513,16 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
 			continue;
 		if (eb->start >= end)
 			break;
+		/*
+		 * Skip if we can't get the refcount for the extent buffer,
+		 * i.e. because it was already written back. Otherwise an eb
+		 * disappering underneath us can cause a use-after-free.
+		 */
+		if (!refcount_inc_not_zero(&eb->refs))
+			continue;
 		rcu_read_unlock();
 		wait_on_extent_buffer_writeback(eb);
+		free_extent_buffer(eb);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
2.55.0

