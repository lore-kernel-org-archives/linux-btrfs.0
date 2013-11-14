Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:55408 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab3KNVVZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 16:21:25 -0500
Message-ID: <52853ED2.8040606@libero.it>
Date: Thu, 14 Nov 2013 22:21:22 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: Lutz Vieweg <lvml@5t9.de>, linux-btrfs@vger.kernel.org
Subject: Mixed and raid [was Re: BUG: btrfsRe: Does btrfs "raid1" actually
 provide any resilience?]
References: <l62akc$ujc$1@ger.gmane.org> <528514CA.8080903@libero.it> <528536F7.6030503@libero.it>
In-Reply-To: <528536F7.6030503@libero.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

after some tests and looking at the code I discovered that the current
mkfs.btrfs doesn't allow any raid profile other than SINGLE for data and
meta-data when the mixed metadata/data group is enabled. It seems this
behaviour was introduce by a your commit [1].


mkfs.c line 1384 onwards

	/*
	* Set default profiles according to number of added devices.
	* For mixed groups defaults are single/single.
	*/
	if (!mixed) {
[....]
	} else {
		u32 best_leafsize = max_t(u32, sysconf(_SC_PAGESIZE),
				sectorsize);
		metadata_profile = 0;
		data_profile = 0;


But in another your commit [2] it seems that you check that in case of
mixed, the metadata and data profile have to be equal (implicitly
allowing that they could be different than single ?).

mkfs.c line 1373 onward

	if (is_vol_small(file)) {
		printf("SMALL VOLUME: forcing mixed metadata/data
				groups\n");
		mixed = 1;
		if (metadata_profile != data_profile) {
			if (metadata_profile_opt || data_profile_opt) {
				fprintf(stderr, "With mixed block
	 groups data and metadata profiles must be the same\n");
				exit(1);
			}
		}
	}


So I am a bit confusing: it is allowed a raid profile different than
single when the mixed is enabled ? Of course mixed and raid together
doesn't make sense (or almost make very little sense) but the code of
mkfs is a bit confused, and a warning should be raised when the raid
profile are forced to a default different from the one selected by the user.


Thanks for the attention.
BR
G.Baroncelli


[1] btrfs-progs: avoid write to the disk before sure to create fs
71d6bd3c8d70fb682c7fd50796f587ce1f1cf6f8
.
[2] btrfs-progs: mkfs should check for small vol well before
cdbc10729266c03aeb2eb812c17a3ef6c1ceae26
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
