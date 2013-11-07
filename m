Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41460 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab3KGBvl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 20:51:41 -0500
Message-ID: <527AF15A.5070409@cn.fujitsu.com>
Date: Thu, 07 Nov 2013 09:48:10 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/16] btrfs-progs: fix resource leak in scrub_start()
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com> <1383779755-18228-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-9-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Eric,

On 11/07/2013 07:15 AM, Eric Sandeen wrote:
> In the "nothing to resume" case we return directly and leak
> several bits of memory; goto out to free them properly.
>
> Resolves-Coverity-CID: 1125934
> Resolves-Coverity-CID: 1125935
> Resolves-Coverity-CID: 1125936
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>   cmds-scrub.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/cmds-scrub.c b/cmds-scrub.c
> index 605af45..5f3eade 100644
> --- a/cmds-scrub.c
> +++ b/cmds-scrub.c
> @@ -1261,7 +1261,8 @@ static int scrub_start(int argc, char **argv, int resume)
>   		if (!do_quiet)
>   			printf("scrub: nothing to resume for %s, fsid %s\n",
>   			       path, fsid);
> -		return 2;
> +		err = 2;
> +		goto out;
Thanks for tracking this problem, but
i intend to return 2 in such case originally.
return '!err' will revert to return 1 rather than 2.

Thanks,
Wang
>   	}
>   
>   	ret = prg_fd = socket(AF_UNIX, SOCK_STREAM, 0);

