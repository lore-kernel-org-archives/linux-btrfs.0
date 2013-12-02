Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48448 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3LBGM7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Dec 2013 01:12:59 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rB26Cwue024083
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 06:12:59 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rB26CwI3001955
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 06:12:58 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rB26Cw9A001948
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 06:12:58 GMT
Message-ID: <529C24E7.5040309@oracle.com>
Date: Mon, 02 Dec 2013 14:12:55 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: fix backref after init-csum-tree
References: <1385964715-23355-1-git-send-email-anand.jain@oracle.com> <1385964715-23355-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1385964715-23355-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Further this needs your review. How should be a complete use case
  of this init-csum-tree feature. mainly how do we expect this work
  in the real scenario. what problem does this solve.

Thanks, Anand


On 12/02/13 02:11 PM, Anand Jain wrote:
> btrfsck reports backref error after running init-csum-tree
>
> btrfsck --init-csum-tree /dev/sdc
> btrfsck /dev/sdc
> ::
> ref mismatch on [29474816 16384] extent item 1, found 0
> Backref 29474816 root 7 not referenced back 0x1101d30
> Incorrect global backref count on 29474816 found 1 wanted 0
> backpointer mismatch on [29474816 16384]
> owner ref check failed [29474816 16384]
> Errors found in extent allocation tree or chunk allocation
> ::
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   cmds-check.c |    6 ++++++
>   1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/cmds-check.c b/cmds-check.c
> index afad8a1..6a8d351 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -6161,6 +6161,7 @@ int cmd_check(int argc, char **argv)
>   		} else if (option_index == 2) {
>   			printf("Creating a new CRC tree\n");
>   			init_csum_tree = 1;
> +			repair = 1;
>   			ctree_flags |= OPEN_CTREE_WRITES;
>   		} else if (option_index == 3) {
>   			init_extent_tree = 1;
> @@ -6234,6 +6235,11 @@ int cmd_check(int argc, char **argv)
>   		ret = btrfs_commit_transaction(trans, info->csum_root);
>   		if (ret)
>   			exit(1);
> +
> +		ret = check_chunks_and_extents(root);
> +		if (ret)
> +			fprintf(stderr,
> +				"Errors found in extent allocation tree or chunk allocation\n");
>   		goto out;
>   	}
>   	ret = check_chunks_and_extents(root);
>
