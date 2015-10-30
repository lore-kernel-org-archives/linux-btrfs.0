Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758965AbbJ3NhW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 09:37:22 -0400
Date: Fri, 30 Oct 2015 14:35:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] btrfs-progs: free comparer_set in cmd_qgroup_show
Message-ID: <20151030133554.GF13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
 <2a8343f402a43c5332c7dcdbf8efa5aee9e49ae9.1446111097.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2a8343f402a43c5332c7dcdbf8efa5aee9e49ae9.1446111097.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 29, 2015 at 05:31:47PM +0800, Zhao Lei wrote:
> comparer_set, which was allocated by malloc(), should be free before
> function return.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  cmds-qgroup.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
> index a64b716..f069d32 100644
> --- a/cmds-qgroup.c
> +++ b/cmds-qgroup.c
> @@ -290,7 +290,7 @@ static int cmd_qgroup_show(int argc, char **argv)
>  	int filter_flag = 0;
>  	unsigned unit_mode;
>  
> -	struct btrfs_qgroup_comparer_set *comparer_set;
> +	struct btrfs_qgroup_comparer_set *comparer_set = NULL;
>  	struct btrfs_qgroup_filter_set *filter_set;
>  	filter_set = btrfs_qgroup_alloc_filter_set();
>  	comparer_set = btrfs_qgroup_alloc_comparer_set();
> @@ -372,6 +372,8 @@ static int cmd_qgroup_show(int argc, char **argv)
>  		fprintf(stderr, "ERROR: can't list qgroups: %s\n",
>  				strerror(e));
>  
> +	free(comparer_set);

Doh, coverity correctly found that comparer_set is freed inside
btrfs_show_qgroups() a few lines above. Patch dropped.

> +
