Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012024.outbound.protection.outlook.com [40.107.209.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A9E357CFC
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 17:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786556156; cv=fail; b=dpy1laWXzlGnvgEUm7RolEV+g6ukB7ft+9eobDhfq0ECjuynzXDf3e/Y+7HMGbbYsVQ5mmBepPRpfL/N9kXc10Tu5Txxp0G9o0+UIbJwdRTs3NobWqkO2cQ0KqEoxULFwIhI4ndrtjnYeumwGbERto9HNxws+DIBE7mMGNKl1tM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786556156; c=relaxed/simple;
	bh=Zf3RvEa0bp4HYR1QwmSCVLNIqC4cOKsF7rEaC0b2M0M=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fKrYPvjY6ftYdot/NGnl+A3dUuBsP4JtpN3O1xoiVJi5zoVH8frJ8Nn1Uc61byyp38TxiNO6zWV+hH2/dpF/WhoS9W+mD0ldDAGHTptnfOZMrwDKGxzVFcl2rSaZjwToKN/HqCI3f+NAM4G6nSWxKZneeaCzCwZjU/Mp4r7t3Ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=selinc.com; spf=pass smtp.mailfrom=selinc.com; dkim=pass (2048-bit key) header.d=selinc.com header.i=@selinc.com header.b=pGOwubN8; arc=fail smtp.client-ip=40.107.209.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=selinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=selinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=selinc.com header.i=@selinc.com header.b="pGOwubN8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cptrziDD4JHOX4Ykf4mYOzrrsndXJAfytegyP1l0wauWM7Y2n0GEZ4m+3vsrYDjxSzDX8Nv8Yn0NGaBmbfmjiulur3nhXd48mlmfEFJs4hAfN62dIELGg2ifFoDFIOZSompOQPqD5rBdYEc8r119hJEY79SJ4HqxdvuqLTb4TjjA002Hx3aL6dLUPR37YddWj2ekQAt+FKygaN8LdBzQnRzQ4R873r4AiMBwKvI5S9NyVLswFoOrTqbDhNYMmr0GUx17NFUz5QiCm/8pd206VgK9f9Jnf188KAZHdYZTB3LWtu1yINwz16sMticni7XrTwn2Kci6jBc1DCLIXEhHdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05DCUV8I1t6+bNFBT4CVyWxIqr8kPgHm/A4+3PjJiiE=;
 b=MybW5K/mY9wHkO6t9VnkgbTllg/J506gWfodca8iQz8ifGmvlPNwArJ/VKlgTkTfm6PTo4veRpRYLYmqm1YpGhpAqUZfva2ZTqsKjSZsG4rUqNr81tBNE4k6xCK+YvguxFxy1ZDvnI6Kipb7NCBdwUA9ARjf7HFN3M44Hti9ji7EwvA4thukgSVISmRc2wnPNoACv79Iqm3F1Zk5qUP9/Km6CJjJvbAExtHI5U6iG/VHs74k01eNTER2j52cx/o+dcb028EXa7qKkq25j1IdMzWRD5254q6moZUn2TdI0cN9jTfzUYeNOZNFidc/7taKhL3aS29XRuDY+Wmkeo/MYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 74.117.212.83) smtp.rcpttodomain=suse.com smtp.mailfrom=selinc.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=selinc.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=selinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05DCUV8I1t6+bNFBT4CVyWxIqr8kPgHm/A4+3PjJiiE=;
 b=pGOwubN87w6nDete3aNbXvCFde3F7kZ8ohWZNHEWKYIfXaOOFCr57S6agUQrMXg4BsGoSjUWUXkOpLrvRVjrAXjOSo+97Mgvp8VUYYm2Rt3qrr91n25yUWuOnkKEajqHS6C3FOCatBEnouFPYZ2oUjJdGBcsDlVyVD1EkwKHrxUgagn4fw+jBg1x6RmygGvgDQZmWm5/DG8B5tWQFb+6XSauS71PVvmdE7jvffMpm9wbvbIeQk3mMVgqcR/M7VN1I1mW+NmJR3R1z9u2D3dFXH+EaAgUDhxV+/gsgAvol2zocU76Nc2+8Z5o1aww79B3lKWk01Aox8HEOOxiOFLr9g==
Received: from CH0PR04CA0024.namprd04.prod.outlook.com (2603:10b6:610:76::29)
 by SA1PR22MB4724.namprd22.prod.outlook.com (2603:10b6:806:3d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Wed, 12 Aug
 2026 17:35:51 +0000
Received: from BL6PEPF0001AB71.namprd02.prod.outlook.com
 (2603:10b6:610:76:cafe::4b) by CH0PR04CA0024.outlook.office365.com
 (2603:10b6:610:76::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.13 via Frontend Transport; Wed,
 12 Aug 2026 17:35:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 74.117.212.83)
 smtp.mailfrom=selinc.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=selinc.com;
Received-SPF: Pass (protection.outlook.com: domain of selinc.com designates
 74.117.212.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=74.117.212.83; helo=email.selinc.com; pr=C
Received: from email.selinc.com (74.117.212.83) by
 BL6PEPF0001AB71.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Wed, 12 Aug 2026 17:35:51 +0000
Received: from LOGAFINLPC.ad.selinc.com (10.100.90.200) by
 wpul-exchange.ad.selinc.com (10.53.14.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 12 Aug 2026 10:35:48 -0700
Date: Wed, 12 Aug 2026 10:35:47 -0700
From: Logan Finley <logan_finley@selinc.com>
To: Qu Wenruo <wqu@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.com>, <clm@fb.com>
Subject: Re: [RFC PATCH] btrfs: Write as many copies as possible if the
 current RAID1 profile is unreachable
Message-ID: <20260812173547.dmy7yqby3jsx3lmq@LOGAFINLPC.ad.selinc.com>
References: <20260811230427.4059275-1-logan_finley@selinc.com>
 <02b9630e-b575-4c45-ae87-d2faea53b72f@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <02b9630e-b575-4c45-ae87-d2faea53b72f@suse.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB71:EE_|SA1PR22MB4724:EE_
X-MS-Office365-Filtering-Correlation-Id: a32d9c06-a95f-4a5e-1849-08def8982769
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|376014|6133799003|56012099006|10067099003|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	isEJRNCWWHYScASeGAkPkBrt8MWs6E6MhHEL3uXLEGh3sQiIS0SCWDtbHfz6b9K34skEfIXIF1hMU4GNPWvDW1kSvPSZCJC/0wCtKvxhvQP5GvWMXqADCi62t/rXt3p5+XzuAFsMhd+WlLgsFBNdOKFnibR2P4zb4TZl3YVaJB1fMG+74AwM1fdOwWhGjaz5DUirfVOPIHAGh0DAnkP/cWunzrSqPFHm6/EGPkeQ9340ew6a8vEx6n1IYsbKsB+csAQbofLiX2SwN7TqHQz1unmz3e5VbBu9RBZuSw294usRgSFHw4KIzG4nllzI99giHgCNcu52VBoruHfK5AO7I/SsQiPfSXtSJdGfV+AviyZodyuKIFAnfI6Kasl6VMi0gSQc2t018pvyVg6qXfS9ifPn/rTvjUeq01C+yQsGf4VmsCZAPn0pATbssBwD2tSzPDdXjMva05YckQVgNOwjEBH31erdFGxm7LKGwX7j47wj/Ri7S2znn/EpsgXV5c5RniSnM5atk/M02iywdeeNpPsXWLHaQ7IQ2Y+OP20pPnMa0zIIc0M15jJo/xavltoD8Ctq6qMP/FGsyQOcFqieG1A1nZsgdc8ol4/egMVgvUD+N+93eJTm/9+nAQ3HQ5SgZDTDAd1YucmjGlUdzpNEZwIHE87W2FWrCf2PludNLd7pMcAkNaeQlQtCmdvYvimjZ1CuIWcfGk9vtcqfG9LolQ==
X-Forefront-Antispam-Report:
	CIP:74.117.212.83;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:email.selinc.com;PTR:wpul-exchange1.selinc.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(376014)(6133799003)(56012099006)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NlL61RTeCjoS6kB+bsTw1rLwyWUe6IqrElm6VB1Doe0+YOl1wp0fRjsFeNFf7AaIHkRpQcMsLaRukt/U/0cud94KqTrWR4B0ZHM5TTms5eGlot7sKMRcmUl/xHzSZSp7M/ofq3ZXsEepMa5lIWit9/VTnzcr7/h+O7qK0EnJVEfioNOb77x3tGVJxMrZrILGb3dy7MwxvU1t1u42b1bC1+sJv9wqH0f6ZUsC8CEoQ/AikOJ7v51A9K9O6tmymvyJrLUPtciCfWXPckwlW7iWEw14qXd2Sloyxy8eT2gJKiAdQt4cz6N3+z/IVoeDopWK5DI9JHKbmfu9YLenJWWjKsLK241JRlWbtg5tKoOfLNfbf7BbmO0jFbHHE52p9CwQuLM7oXb//6VmEFAYTOGGpYi8WVJxgMlrmBv96AK2aLrBKPXCyqlsteymSo7FMuE8
X-OriginatorOrg: selinc.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 17:35:51.1529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a32d9c06-a95f-4a5e-1849-08def8982769
X-MS-Exchange-CrossTenant-Id: 12381f30-10fe-4e2c-aa3a-5e03ebeb59ec
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=12381f30-10fe-4e2c-aa3a-5e03ebeb59ec;Ip=[74.117.212.83];Helo=[email.selinc.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB71.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR22MB4724

On Wed, Aug 12, 2026 at 09:02:24AM +0930, Qu Wenruo wrote:
> > I'm not sure of a good way to fill up the System and Metadata block groups
> > enough to trigger a new chunk to be allocated, so I wasn't able to see
> > whether they also allocate "single"-profile chunks.
> 
> For meta, go fill a subvolume with inlined data, that will easily bump up
> the metadata usage.
> 
> For system it's harder, but you can still use fallocate to take a lot of
> space, which will trigger new chunk allocation that will increase system
> usage.
> But it's very hard if your fs has limited space.
> 

I was able to get a "single" profile metadata chunk to be allocated using
inline data. I don't think I have enough storage to do the same with
the system block group, but I'll wager the behavior would be the same.

> > This (admittedly naive) patch modifies this behavior so that the RAID1
> > family of profiles writes as many copies as possible in a degraded state
> > when there are not enough disks present to write data in the configured
> > RAID profile.
> > 
> > Signed-off-by: Logan Finley <logan_finley@selinc.com>
> > ---
> > What I'm looking for is feedback on whether this sort of patch is
> > desired upstream, whether the approach is valid, and whether or not
> > there are any gotchas I may have missed in the implementation.
> 
> I think this downgrade from RAID1C4 to C3/C2 and from C3 to C2 is safe, and
> it's a good middle ground solution.
> 
> Although it has the side effect that there will be new RAID1* profiles which
> will require balance to remove after the missing device is dealt with.

Good to know, thank you. I think for now we'll go with maintaining this
mid-term patch internally, since it seems to do what we need. You're right
that it requires a balance be performed once the missing disk is taken care
of, but I can live with that.

> The root problem is in how we handle chunk allocation in degraded mode.
> When a device is missing, it's very instinctive to assume we should not use
> that device for new chunks.
> 
> But that may not be the case, we may still want to allocate chunk on that
> missing device, and rely on the chunk's mirrors/duplications to handle it.
> 
> There will be extra problems involved for using such missing device, e.g. we
> should not use the missing device for profiles without duplication on other
> devices, like SINGLE/DUP on that missing device.
> 
> In the long run, that would allow us to still use whatever profile even if
> there is a missing device, and requires no extra balance after all devices
> are online again.
> 
> 
> Now the question is, should we go the long-term solution directly (if some
> one is going to work on it), or go the middle ground first?

In my free time I would like to spend some time working on the long-term
solution you proposed and eventually send it upstream.

Thanks,
Logan Finley
