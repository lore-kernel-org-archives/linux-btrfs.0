Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59211 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbaAGVH1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 16:07:27 -0500
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s07L7QSR015849
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Jan 2014 13:07:27 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1h81n75kt5-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 07 Jan 2014 13:07:27 -0800
Message-ID: <52CC6C8B.1080503@fb.com>
Date: Tue, 7 Jan 2014 16:07:23 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: bail if we find errors in the extent tree
References: <1389126861-31257-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1389126861-31257-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/07/2014 03:34 PM, Josef Bacik wrote:
> For some reason we weren't exiting if there were errors in the extent tree,
> which means we could have errors in just the extent tree and things like
> xfstests would keep going because we completely throw away the return value.
> Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>   cmds-check.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/cmds-check.c b/cmds-check.c
> index 689fe6c..cbabfdc 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -6409,8 +6409,10 @@ int cmd_check(int argc, char **argv)
>   		goto out;
>   	}
>   	ret = check_chunks_and_extents(root);
> -	if (ret)
> +	if (ret) {
>   		fprintf(stderr, "Errors found in extent allocation tree or chunk allocation\n");
> +		goto out;
> +	}
>   
>   	fprintf(stderr, "checking free space cache\n");
>   	ret = check_space_cache(root);
Sigh ignore this, it is causing other problems, I'm going to have to 
figure out a better solution to this.  Thanks,

Josef
