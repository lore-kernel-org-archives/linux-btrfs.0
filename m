Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:38164 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3KOHQv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 02:16:51 -0500
Message-ID: <5285CA5E.6030003@libero.it>
Date: Fri, 15 Nov 2013 08:16:46 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: for mixed group check opt before default
 raid profile is enforced
References: <1384490079-19872-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1384490079-19872-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

On 2013-11-15 05:34, Anand Jain wrote:
> This fixes the regression introduced with the patch
> 
>     btrfs-progs: avoid write to the disk before sure to create fs
> 
> what happened with this patch is it missed the check to see if the
> user has the option set before pushing the defaults.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  mkfs.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/mkfs.c b/mkfs.c
> index ec717be..2156150 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1359,17 +1359,13 @@ int main(int ac, char **av)
>  	if (is_vol_small(file)) {
>  		printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
>  		mixed = 1;
> -		if (metadata_profile != data_profile) {
> -			if (metadata_profile_opt || data_profile_opt) {
> -				fprintf(stderr,
> -	"With mixed block groups data and metadata profiles must be the same\n");
> -				exit(1);
> -			}
> -		}
>  	}
> +
>  	/*
>  	* Set default profiles according to number of added devices.
> -	* For mixed groups defaults are single/single.
> +	* For mixed groups defaults are single/single
> +	* however if metadata_profile_opt || data_profile_opt is set
> +	* metadata_profile and data_profile must be same
>  	*/
>  	if (!mixed) {
>  		if (!metadata_profile_opt) {
> @@ -1387,8 +1383,13 @@ int main(int ac, char **av)
>  				BTRFS_BLOCK_GROUP_RAID0 : 0; /* raid0 or single */
>  		}
>  	} else {
> -		metadata_profile = 0;
> -		data_profile = 0;
> +		if (metadata_profile_opt || data_profile_opt) {
> +			if (metadata_profile != data_profile) {
> +				fprintf(stderr,
> +	"With mixed block groups data and metadata profiles must be the same\n");

Please prefix the error message with "ERROR: " otherwise is not so easy to 
understand that this is an error message and that the filesystem was not created.

> +				exit(1);
> +			}
> +		}
>  	}
>  
>  	ret = test_num_disk_vs_raid(metadata_profile, data_profile,
> 


It works for me (see below), however I suggest to prefix the error message 
"With mixed block group..." with the "ERROR" string, otherwise it is not so obvious that 
something went wrong.

-------

# test: make a raid1 filesystem in a small volume to force the "mixed" mode
# expected results: the volume must have a Data+Metadata, RAID1 chunk
# result: test PASSED

ghigo@venice:/tmp$ sudo ~/btrfs/btrfs-progs/mkfs.btrfs -K -m raid1 -d raid1 /dev/loop[01]
SMALL VOLUME: forcing mixed metadata/data groups

WARNING! - Btrfs v0.20-rc1-595-g9f0c53f IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Turning ON incompat feature 'mixed-bg': mixed data and metadata block groups
Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
Created a data/metadata chunk of size 8388608
adding device /dev/loop1 id 2
fs created label (null) on /dev/loop0
	nodesize 4096 leafsize 4096 sectorsize 4096 size 202.00MiB
Btrfs v0.20-rc1-595-g9f0c53f
ghigo@venice:/tmp$ sudo mount /dev/loop0 /mnt/test
ghigo@venice:/tmp$ btrfs fi df /mnt/test/
System, RAID1: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Data+Metadata, RAID1: total=64.00MB, used=28.00KB
Data+Metadata: total=8.00MB, used=0.00
ghigo@venice:/tmp$ sudo umount /mnt/test




# test: make a filesystem in a small volume to force the "mixed" mode 
#  with different profiles for data and metadata
# expected results: mkfs must fails with an error message
# result: test PASSED

ghigo@venice:/tmp$ sudo ~/btrfs/btrfs-progs/mkfs.btrfs -K -m dup -d raid1 /dev/loop[01]
SMALL VOLUME: forcing mixed metadata/data groups
With mixed block groups data and metadata profiles must be the same

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
