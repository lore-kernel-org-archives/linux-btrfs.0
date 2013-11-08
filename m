Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35611 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab3KHXxS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 18:53:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VevrY-0005j1-UP
	for linux-btrfs@vger.kernel.org; Sat, 09 Nov 2013 00:53:16 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Nov 2013 00:53:16 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Nov 2013 00:53:16 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: progs integration branch moved to master (new default leafsize)
Date: Fri, 08 Nov 2013 23:53:06 +0000
Message-ID: <l5jtgo$6q1$1@ger.gmane.org>
References: <20131108220135.3802.39092@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20131108220135.3802.39092@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/11/13 22:01, Chris Mason wrote:
> Hi everyone,
> 
> This patch is now the tip of the master branch for btrfs-progs, which
> has been updated to include most of the backlogged progs patches.
> Please take a look and give it a shake.  This was based on Dave's
> integration tree (many thanks Dave!) minus the patches for online dedup.
> I've pulled in the coverity fixes and a few others from the list as
> well.
> 
> The patch below switches our default mkfs leafsize up to 16K.  This
> should be a better choice in almost every workload, but now is your
> chance to complain if it causes trouble.

Thanks for that and nicely timely!

Compiling on Gentoo (3.11.5-gentoo, sys-fs/btrfs-progs-9999) gives:


 * QA Notice: Package triggers severe warnings which indicate that it
 *            may exhibit random runtime failures.
 * disk-io.c:91:5: warning: dereferencing type-punned pointer will break
strict-aliasing rules [-Wstrict-aliasing]
 * volumes.c:1930:5: warning: dereferencing type-punned pointer will
break strict-aliasing rules [-Wstrict-aliasing]
 * volumes.c:1931:6: warning: dereferencing type-punned pointer will
break strict-aliasing rules [-Wstrict-aliasing]

 * Please do not file a Gentoo bug and instead report the above QA
 * issues directly to the upstream developers of this software.
 * Homepage: https://btrfs.wiki.kernel.org




> --------------------------------
> 16KB is faster and leads to less metadata fragmentation in almost all
> workloads.  It does slightly increase lock contention on the root nodes
> in some workloads, but that is best dealt with by adding more subvolumes
> (for now).

Interesting and I was wondering about that. Good update.

Also, hopefully that is a little more friendly for SSDs where often you
see improved performance for 8kByte or 16kByte (aligned) writes...


Testing in progress,

Regards,
Martin



> This uses 16KB or the page size, whichever is bigger.  If you're doing a
> mixed block group mkfs, it uses the sectorsize instead.
> 
> Since the kernel refuses to mount a mixed block group FS where the
> metadata leaf size doesn't match the data sectorsize, this also adds a
> similar check during mkfs.
> 
> Signed-off-by: Chris Mason <chris.mason@fusionio.com>
> ---
>  mkfs.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs.c b/mkfs.c
> index bf8a831..cd0af9e 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -46,6 +46,8 @@
>  
>  static u64 index_cnt = 2;
>  
> +#define DEFAULT_MKFS_LEAF_SIZE 16384
> +
>  struct directory_name_entry {
>  	char *dir_name;
>  	char *path;
> @@ -1222,7 +1224,7 @@ int main(int ac, char **av)
>  	u64 alloc_start = 0;
>  	u64 metadata_profile = 0;
>  	u64 data_profile = 0;
> -	u32 leafsize = sysconf(_SC_PAGESIZE);
> +	u32 leafsize = max_t(u32, sysconf(_SC_PAGESIZE), DEFAULT_MKFS_LEAF_SIZE);
>  	u32 sectorsize = 4096;
>  	u32 nodesize = leafsize;
>  	u32 stripesize = 4096;
> @@ -1232,6 +1234,7 @@ int main(int ac, char **av)
>  	int ret;
>  	int i;
>  	int mixed = 0;
> +	int leaf_forced = 0;
>  	int data_profile_opt = 0;
>  	int metadata_profile_opt = 0;
>  	int discard = 1;
> @@ -1269,6 +1272,7 @@ int main(int ac, char **av)
>  			case 'n':
>  				nodesize = parse_size(optarg);
>  				leafsize = parse_size(optarg);
> +				leaf_forced = 1;
>  				break;
>  			case 'L':
>  				label = parse_label(optarg);
> @@ -1386,8 +1390,21 @@ int main(int ac, char **av)
>  				BTRFS_BLOCK_GROUP_RAID0 : 0; /* raid0 or single */
>  		}
>  	} else {
> +		u32 best_leafsize = max_t(u32, sysconf(_SC_PAGESIZE), sectorsize);
>  		metadata_profile = 0;
>  		data_profile = 0;
> +
> +		if (!leaf_forced) {
> +			leafsize = best_leafsize;
> +			nodesize = best_leafsize;
> +			if (check_leaf_or_node_size(leafsize, sectorsize))
> +				exit(1);
> +		}
> +		if (leafsize != sectorsize) {
> +			fprintf(stderr, "Error: mixed metadata/data block groups "
> +				"require metadata blocksizes equal to the sectorsize\n");
> +			exit(1);
> +		}
>  	}
>  
>  	ret = test_num_disk_vs_raid(metadata_profile, data_profile,


