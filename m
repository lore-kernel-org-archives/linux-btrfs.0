Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:41301 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3CVMek (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 08:34:40 -0400
Message-ID: <514C4FD9.30504@jan-o-sch.net>
Date: Fri, 22 Mar 2013 13:34:33 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org, koen.de.wit@oracle.com
Subject: Re: [PATCH] Btrfs-progs: fix overflow when printing qgroup info
References: <1363953208-2342-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1363953208-2342-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Fri, March 22, 2013 at 12:53 (+0100), Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> Since btrfs quota rescan has not been implemented yet,
> a user complains that "btrfs qgroup show" lists qgroup
> referenced/exclusive be negative. However, this should
> not happen even if overflow happens,because the type for
> qgroup referenced/exclusive is u64,fix it.
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> Reported-by: Koen De Wit <koen.de.wit@oracle.com>
> ---
>  cmds-qgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
> index 60ca33d..fc4cb13 100644
> --- a/cmds-qgroup.c
> +++ b/cmds-qgroup.c
> @@ -105,7 +105,7 @@ static int qgroup_create(int create, int argc, char **argv)
>  
>  void print_qgroup_info(u64 objectid, struct btrfs_qgroup_info_item *info)
>  {
> -	printf("%llu/%llu %lld %lld\n", objectid >> 48,
> +	printf("%llu/%llu %llu %llu\n", objectid >> 48,
>  		objectid & ((1ll << 48) - 1),
>  		btrfs_stack_qgroup_info_referenced(info),
>  		btrfs_stack_qgroup_info_exclusive(info));
> 

I don't like that change. Seeing negative numbers is what you should expect in
the current situation.

Once anyone come across negative numbers with a volume holding more data than
what can be tracked with 63 bit, I may come to agree to your change. For now, it
will confuse more than help.

-Jan
