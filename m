Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786894399D0
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 07:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926344; cv=fail; b=hL4iFFBnmYEJU4chXsI4hiTPlXgJ40Fum9GD22j/QMJp3Z3raf1ZIH2pHx6mTWJ67plcmQuCMjzWmX91WBIZ1rjIQ9jhaW6FHhgKiK8OMpCCVx+hRqgS3Fh323KYeRoTSB4EOrwekgwCK8t6mrJp44BxELTCn5hDaEgpyqRu8zY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926344; c=relaxed/simple;
	bh=wAatctlN/3JBhd9O09hszosn8+a2kuYYdu1x6BeyHss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ELX69TTK7jQc1LfY5MRkkDkwEj768IFYNMmVyHzQEBYQAUkGrtoKOcqoXF3CeCOQal/xT10/HPbMpYL8mbYvyqFYOAwLzOOXiHr3tSJbz1s1g7BCidyQL8gG7zGTCxSGtqQ8EqTAooaRwUz1/k1zAhg7m8vsKR1002D9xYYR+8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eX8bXKCB; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Dd83skT5; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eX8bXKCB";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Dd83skT5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790926341; x=1822462341;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wAatctlN/3JBhd9O09hszosn8+a2kuYYdu1x6BeyHss=;
  b=eX8bXKCBMRr2RMflti/x/i5r3w5RqjfRTyjuqfNvqG1L8CVYH4HnyPfh
   g0MpJ5p0ZLr8olvIuivBcu7TJU2fvnFvGpwY5opkGnpB/i/u7eum5nDS2
   4AhO/CgTdNj+IbEcGtoTIO786eq1h2UQuz2AT0ja9OD0i3ACPRXXvgVBG
   nOd9G9IIc8eWpukIEvbwyDFPOPUXxbCswTKruq3bIHYgjuqe3GCQlHPI6
   NQeltSjvKLaeFvN0w2+OueDL6Kmy0pxGOQ1+cIvO824FP8xoVs5YzIUNf
   9DDbGfGk9qoB5Y3iP9/X9MaP06Qxf6rQPcLQxJIaCTB//h2CaOcTPoCER
   g==;
X-CSE-ConnectionGUID: rtib26v0RSOv7s1Vh1AQ1A==
X-CSE-MsgGUID: cI1zyQ6KSeigRDw2RenmYA==
X-IronPort-AV: E=Sophos;i="6.27,136,1786982400"; 
   d="scan'208";a="156152475"
Received: from mail-eastus2azon11011000.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.0])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Oct 2026 15:32:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mtkXvOA7FOPG9RCYjyXC35w+DNnr0xk2Ssdz6lc/6MG7azmzkBA68ExWLCzie9wahU5jmKUJxZw/mAt5nly44buJstkFXCSxSmMHZjI3Eguo3pPQ5e61bjR5rUP9tKw0BmrnOP48vOTGtTGbOrNnCB5lf5mqCrHx0IsQNe+aryxIDJaG3ADUkOF/8B3+Dkeo5tWkONUmxHVGKX75I1XaLSObY+uDKyXCQWOdES9BT9N43Zm8bBFBxqLSSzW8dBD0E+9tOUlVna/4HCTXEl+o0A7SD9KcEeOG3m2gXFs/57snfxru43TRPIdHoodjIsMsWpBhr2XoArCWlDEPhwTBKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bw5UlzGB9l1sfMKQznJw+QOJKhPEdtCVJ+lOyMOax70=;
 b=gSdynBGMMPPxKrb2nPdn1elPQSvd8rRkuFLlCbCtAjB749pg2i8QdvGueauTtYvxUDSaMHUw6dIxE2NrCs0SGOYMrBwpna8JIbYlm+VYLUtCoIIE5Mhh8yYeVTFxqxZyWe6+6lJQSl+9RUGh8/00hco3bSNIvORjePKtovjhkxP05FFQqDjB/OVYPTmdSL3j8+RfEFJjHdCFbDyP111Bm8Nqq9YHIo3kTnMT417ClKrlJrzNt+Aq/ulQ+u+NmY/mCnUKHKMtSzZBuG/+vQMHMvAPlSE5Bkt7zJs+RpRB39VBuFFaheUbBsxKH3sT9nLEQKqYRutG0cwfVqbJber/Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bw5UlzGB9l1sfMKQznJw+QOJKhPEdtCVJ+lOyMOax70=;
 b=Dd83skT5i2K0MP72dE49Ps/+rpnQXZ79wWVZsHUn4EYeL1YK5kvydpewoyIjhtSaJK4prMlC4MBNv7diDEiERvNCIlE6DWn1bJFRCWSuQAfpFyQuJcmcLL8OAeygD+CpEYsqLyuVUdplbTq94BPpor11cEq3r6cJd/cngFqZIK4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM6PR04MB6283.namprd04.prod.outlook.com (2603:10b6:5:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 07:32:13 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 07:32:13 +0000
Date: Fri, 2 Oct 2026 09:32:04 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>, 
	David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH 4/4] btrfs: zoned: avoid underflow of bytes_zone_unusable
Message-ID: <ar9dTrpxbbJ2ha9D@mayhem.fritz.box>
References: <20260914085248.347198-1-johannes.thumshirn@wdc.com>
 <20260914085248.347198-5-johannes.thumshirn@wdc.com>
 <20260914150811.GJ54722@twin.jikos.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914150811.GJ54722@twin.jikos.cz>
X-ClientProxiedBy: FR4P281CA0232.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::13) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM6PR04MB6283:EE_
X-MS-Office365-Filtering-Correlation-Id: e63f2227-0ab6-42af-721e-08df205746da
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|23010399003|1800799024|19092799006|11063799006|56012099006|4143699003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 g7D3aSVbgOOcQFYFl6iZiHO9v6dG70GZEnkFb8mgsV6fLCOOcERspU3D1WFyAQlpHUAbAQCQR6kFdYLOXTEmZYF8RDcHWDl6bWzVwMgoj/mlfVDA2GUr+uAeyWy20BVwGjf1rNBI07VUBwFowWYol+IuAuKgxLRZNWcOGfQJZ/tJPG3n+9/gYGYBgjr4HeBqDfuPfIxzR69u6KDiH4b6piufcQIEt+psytEHlJ8zc2Q1SwvpEPLVfzhPqF5ovJ/v0ImlxAE65SI+IAk5p/2Szd660qjRJoGO4wtv/i8UmeuSsorT6T4nRW11RTKLEiVXhfT2rFlwZKnFUsfo2n/QCt21SrV6X6GZT+FQL9/tIhrTyGh9OIhuY0FCgoHYd130S3W0ZCkntcno07JNI5AQ4KE99m3v74SbJ/grLqIePIiaorKwqWKi5f4U94Mx6/uzXwhYFchkY+R7ufmOFDQshmvrBRx9cfW81Nc18TcESFqzBICdFjP5zjocZ5HBs5VH+5GN6UDoM5JByESW//JDUw/L8ew0jWkgSa1TiI1UNouwKjoi4mIxoCH7hJc5CyrU2ak9KYLCzJ8SydHx38DMKZpi+xZakKr5sBqvRsMOeg0RDaIjdSJHSebUriPNy99kyfiWbH+sTpXz5KnxlSlVvL/szIS5muMBOp+gVar4BgQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(23010399003)(1800799024)(19092799006)(11063799006)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?EY3TouCJ7mJCADWaxMswbLUOx1f13NuTO5l6wJIAfPMNkQwM1dX24CLC/NzO?=
 =?us-ascii?Q?IKRgsjxrNTXR4OGH/SwOoBYMU3FPUr/KWBrFJoU4JGxJbvb/WZAZ7gv0kqYS?=
 =?us-ascii?Q?Df5qBuEXUSQA6GXUFp6OrYUx5nkZsi8Vb44P87IEBzNxPX7vNf4Un9owjW6i?=
 =?us-ascii?Q?q04Pm5r+ce9VdwYTuKDI8iwmyT3BWA2xCi8O0GySTI3b1yKfJTqLyOOg4xNt?=
 =?us-ascii?Q?aSP2CnZxgQw6+6oG9dBu5nKu5ttlGIN1heIf8CS8FlVQ6UpbL+GOoymPjo7z?=
 =?us-ascii?Q?XoAosOtBWt+D3dXpeRTBFtDwKXqDUoIqxjIeWNQzXp93OvNtCD4+e5H0b072?=
 =?us-ascii?Q?/ZtYjEqmepNK02ngS7/FHYHS3dSXle7G1ERfn54FAtFBlaF76zGCBq3shn/E?=
 =?us-ascii?Q?Gfx73ioJzpAmUFOQXYJMZZ1aLJ+i4S5zwFAB3x3EKNAJGTdHK1CvRdQTDLTU?=
 =?us-ascii?Q?i1QA2O2kz1OoAdZYQTwmHHYEApUgg6B9VPwQwC8iMRS4+vC4kkML5Z7fHCUY?=
 =?us-ascii?Q?hTK98yI3iO2sJlMkwEwM0QzXlExL6ao3Y3ljDy40QqojtMm5w7PmtFmBw/o2?=
 =?us-ascii?Q?pHLTpTvkyUwT/NML9Sh4HHiRPUiMTOVgPaZ1PCQMS4IIm7k668SEx4w3327v?=
 =?us-ascii?Q?5XLxtRnYtDXfLGWPxNi2ZMxFlwZtX21hOgggeMDkPl4gT+nCjikNBz9DWzWV?=
 =?us-ascii?Q?VNlCfe4rtP5s3XQRT+splhaXwUCQrb5tSW7ejBHHhqdANftbDq9eEiq5mWhr?=
 =?us-ascii?Q?QsqG2445eo0Mz+Z7d2FoV2ReDWVMxvR/OMnufoSJHi/KCR/2cT6UbT1Uk5H5?=
 =?us-ascii?Q?18P1WdrTNTdPD5NE+/5wrBBG3FdkUXJ1AwxPTx7JvGjltHBSRWXGWtk3jVwi?=
 =?us-ascii?Q?mnAgXTdmGl0mCcgzH/bjVT8sXjd22WuCcl1DUH0qpZ4ie2vt5L9XSqve7dhP?=
 =?us-ascii?Q?94djgs4GuBQwm9YQGLU19Oibs2Lxgd/Js1dIK0fZNMrt5An4sVFObC7np2gU?=
 =?us-ascii?Q?4tZyRePq5QX8PdPOkBpV0hPasjEg3n9gFqVYj11zw1DtuD6eigZqWKkIKZhC?=
 =?us-ascii?Q?Eb3ZGJS1j82ok0EhLTzHP+J7TFtZ8MLEwdEb/10g7e2Rid3WYjSE0f83EXk2?=
 =?us-ascii?Q?CH31M/F9amJ8Vt3STmsL1Deh4p/JncwnhmXOifSDdFFWNYSmz1Ze5lDgpjnN?=
 =?us-ascii?Q?ZJfqIe2GE+08Zza1SW1v2kouijGiMCyYxjyxvoqlUrxwFTE1qS25mWUmW7mX?=
 =?us-ascii?Q?0AbQvy2Ni2G3O249ZYhnWPEN7qzTiEEQyvSK2YdU+U+t8jzNM/BbM2P7s5qk?=
 =?us-ascii?Q?IUWz7au+Gcb2xWUa3GJUrSLYtoQ0y3MIY4JYKNF8cd+jAkWz6s/wQO9Q1S9/?=
 =?us-ascii?Q?SlDQ8/mNbE4m6gkHLTOTrC/DJE0o5KglUK691HHRRSTvBS0iT1dera4Vg4YT?=
 =?us-ascii?Q?L6ZfzDlgIfDLWoWXLRrZeFmBydUoJ2bDwmUWksK7DISqXieRoxL+SjmzBfnv?=
 =?us-ascii?Q?h47Uz8NkcU5IFnoIHSqVKYPSEJRX4FzicJDIUguriMkYnMwCdrWSpqvV4g92?=
 =?us-ascii?Q?Nub+ZHLJRIYi116p3Oj99zaIBZV/WwbV6i+pI92VWz8l0mR9HGcbfM0InpP0?=
 =?us-ascii?Q?OkLVkBbimVsE026JQe0Ypp3nxdakBVdiNohpg7933SyJLUvOt0wnIszBcEWa?=
 =?us-ascii?Q?hCldUj5WoaWeqePjOGIJbDNJ6bl4UaCgemAQpOitU8U9k3HQltzFIZFSkaoC?=
 =?us-ascii?Q?otOEBQQVyxA30Qz/z3Qu3JNaNmkUe6I1YmBlDU7TB8dTU38nZOsZxc6cLVv1?=
X-MS-Exchange-AntiSpam-MessageData-1: sVmv/xD023wBy2deEuj0NGdz5860c1UOgyo=
X-Exchange-RoutingPolicyChecked:
	uCNqb0AP0B62qSusNUnJPITvNZe1axmAHclIT3YLZE4B8kQwn7pChL7/gjLYRO4dti8eveHQNd6rn7TRUxK8MBcw6inWoHaB/Yo539jiH1d0xHH1mTJvT/MAb61d0b/f4tlb0dx284M2GdRTEA8MP+D82V+2V22hT40FqW++MdY5RmNX6D0cwkbQ20H1j7ZfrymwQB2sAhXXFkZQFn/8aIKscdJLvwcUyUYAo1o8wZqC1zmq3Z1ABR066Ml1fQ1Js7zOvebZ75ijIDU3ETbOYgLVySIWyHCIBlMWTMqTCwSIArJoi0VDweq2FyAMPMXMTGZMEEgGKGUKdLHDzkc37w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UN3XGF0Cw7U+pBA9yYv43J6+IsRRA3gYPlcFPzofHysYGru84VDt7Gd7VJxURJ/l74NpiKzJZslsgITHf3kCboOaf78PK8EoINk2L2+JJ7kNAOLslOiCOgtuG1K2U7BmuQVvMYxCaqytdykemeeCIA9Dc/6L5SKyB53NYDp/slRdoMKMDyn0Wbx7zMhOD+cznh3U/HPQW+Bxxe/FVviD2KC+8Ks/KXBA7iUP5KPznlGSX9BBvQl8ra1pRu3WMKwEG/V/+KbNKKyTdrOtVLPXxPK+QUUGiz0GzQO0M3BQg/lmrvUid/xA8IBaVOkxE+rKqSJEaEhLj14BPY5rZcV67npJptaBVQehbwi3T0BymxFwKOoZ4vZNrT0apidGUvBLWhPUQ2LECVonTwfHajZafRgqygT1E5aTJFs6azF0zE+HLX6ALSxLtJzLYi3VImIiEx4LGA61bxaClsqEMvh3+N6vgWwT5XAUTfIRVRypSIjrguxSNA3Kp/yhL5RoBKXioSpqijLFQc5eWPRY11mD8FEn0dX6F3QoZeE2qoO8oxxReItVVlt4Zh8raGz58wsazaDZG+XkotFW+I38c0UVne2cPcIKmjbWaoC7AmGXIoYwWxnkAO0BwxrRPb0BRN/l
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e63f2227-0ab6-42af-721e-08df205746da
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 07:32:13.4683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8BJaVFA+oPyuM7n3ziviyPhlfY5bBXQO+gzwcFeoRHw6+3Pwbdrf3w6dmI3ILDt8aH0IYiW3/YYeQL42qd6frmdoTebW8voVd3Owxsn46qk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6283

On Mon, Sep 14, 2026 at 05:08:11PM +0200, David Sterba wrote:
> On Mon, Sep 14, 2026 at 10:52:48AM +0200, Johannes Thumshirn wrote:
> > The two functions btrfs_free_reserved_bytes() and
> > btrfs_reset_unused_block_groups() both manipulate
> > space_info->bytes_zone_unusable without using the accessor function
> > btrfs_space_info_update_bytes_zone_unusable() potentially risking an
> > underflow (in case of btrfs_reset_unused_block_groups()).
> > 
> > Use btrfs_space_info_update_bytes_zone_unusable() in both function, in
> > the case of btrfs_free_reserved_bytes() it is mostly for documenting
> > purposes.
> > 
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> 
> The two cases cover all modifications of the bytes_zone_unusable, it
> could make sense to force using that wrapper, eg. renaming the
> identifier and providing only a get/set helpers.

I have a local version of this, but I don't really like it, sorry. It's a lot
of churn.
