Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44257 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759Ab3KOEfu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 23:35:50 -0500
Message-ID: <5285A6AF.8090607@oracle.com>
Date: Fri, 15 Nov 2013 12:44:31 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: kreijack@inwind.it, Lutz Vieweg <lvml@5t9.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Mixed and raid [was Re: BUG: btrfsRe: Does btrfs "raid1" actually
 provide any resilience?]
References: <l62akc$ujc$1@ger.gmane.org> <528514CA.8080903@libero.it> <528536F7.6030503@libero.it> <52853ED2.8040606@libero.it>
In-Reply-To: <52853ED2.8040606@libero.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi G.Baroncelli, Lutz,

  Thanks for the test case and heads-up on this. The code missed
  the check if the user has provided the option before default
  profile for the mixed group (due to small vol) is enforced.

  I have sent out the following patch to fix it.

[PATCH] btrfs-progs: for mixed group check opt before default raid 
profile is enforced

  Kindly let us know how it performed if you could.

  Thanks,
Anand


On 11/15/2013 05:21 AM, Goffredo Baroncelli wrote:
> Hi Anand,
>
> after some tests and looking at the code I discovered that the current
> mkfs.btrfs doesn't allow any raid profile other than SINGLE for data and
> meta-data when the mixed metadata/data group is enabled. It seems this
> behaviour was introduce by a your commit [1].
>
>
> mkfs.c line 1384 onwards
>
> 	/*
> 	* Set default profiles according to number of added devices.
> 	* For mixed groups defaults are single/single.
> 	*/
> 	if (!mixed) {
> [....]
> 	} else {
> 		u32 best_leafsize = max_t(u32, sysconf(_SC_PAGESIZE),
> 				sectorsize);
> 		metadata_profile = 0;
> 		data_profile = 0;
>
>
> But in another your commit [2] it seems that you check that in case of
> mixed, the metadata and data profile have to be equal (implicitly
> allowing that they could be different than single ?).
>
> mkfs.c line 1373 onward
>
> 	if (is_vol_small(file)) {
> 		printf("SMALL VOLUME: forcing mixed metadata/data
> 				groups\n");
> 		mixed = 1;
> 		if (metadata_profile != data_profile) {
> 			if (metadata_profile_opt || data_profile_opt) {
> 				fprintf(stderr, "With mixed block
> 	 groups data and metadata profiles must be the same\n");
> 				exit(1);
> 			}
> 		}
> 	}
>
>
> So I am a bit confusing: it is allowed a raid profile different than
> single when the mixed is enabled ? Of course mixed and raid together
> doesn't make sense (or almost make very little sense) but the code of
> mkfs is a bit confused, and a warning should be raised when the raid
> profile are forced to a default different from the one selected by the user.
>
>
> Thanks for the attention.
> BR
> G.Baroncelli
>
>
> [1] btrfs-progs: avoid write to the disk before sure to create fs
> 71d6bd3c8d70fb682c7fd50796f587ce1f1cf6f8
> .
> [2] btrfs-progs: mkfs should check for small vol well before
> cdbc10729266c03aeb2eb812c17a3ef6c1ceae26
>
