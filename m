Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbcFAMV5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 08:21:57 -0400
Date: Wed, 1 Jun 2016 14:21:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Feifei Xu <xufeifei@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, steve.capper@linaro.org, chandan@mykolab.com,
        jbacik@fb.com, dsterba@suse.com, chandan@linux.vnet.ibm.com,
        feifeixu.sh@gmail.com
Subject: Re: [PATCH V2 5/8] Btrfs: self-tests: Support testing all possible
 sectorsizes and nodesizes
Message-ID: <20160601122118.GV29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201606011120.u51BJXQB005621@mx0a-001b2d01.pphosted.com>
 <201606011120.u51BJVGc003246@mx0a-001b2d01.pphosted.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201606011120.u51BJVGc003246@mx0a-001b2d01.pphosted.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 01, 2016 at 07:18:27PM +0800, Feifei Xu wrote:
> To test all possible sectorsizes, this commit adds a sectorsize
> array. This commit executes the tests for all possible sectorsizes and
> nodesizes.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
> ---
>  fs/btrfs/super.c | 54 ++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 32 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 5b0b354..c49d7ae 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2318,32 +2318,42 @@ static void btrfs_print_mod_info(void)
>  
>  static int btrfs_run_sanity_tests(void)
>  {
> -	int ret;
> +	int ret, i;
>  	u32 sectorsize, nodesize;
> -
> -	sectorsize = PAGE_SIZE;
> -	nodesize = PAGE_SIZE;

This does not seem to apply to any branch I'd expect to be relevant
(master, for-linus, chandan's main patchset), please clarify.
