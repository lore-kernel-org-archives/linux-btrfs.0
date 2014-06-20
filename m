Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17457 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933086AbaFTUaH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 16:30:07 -0400
Message-ID: <53A499B8.5050107@fb.com>
Date: Fri, 20 Jun 2014 13:29:44 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Chris Mason <clm@fb.com>,
        Jiri Kosina <trivial@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: fs/btrfs/tree-log.c: Fix closing brace followed
 by if
References: <1403293903-17696-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1403293903-17696-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2014 12:51 PM, Rasmus Villemoes wrote:
> Maybe "else if" was meant, but because of the goto out_unlock, it
> doesn't make a difference. Anyway, I chose the "only whitespace" fix.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>   fs/btrfs/tree-log.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 9e1f2cd..50af2b9 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3980,7 +3980,8 @@ again:
>   		if (ret < 0) {
>   			err = ret;
>   			goto out_unlock;
> -		} if (ret) {
> +		}
> +		if (ret) {
>   			ins_nr = 0;
>   			btrfs_release_path(path);
>   			continue;
>

Nope that's right, thanks,

Reviewed-by: Josef Bacik <jbacik@fb.com>

