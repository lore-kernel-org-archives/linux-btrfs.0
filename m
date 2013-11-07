Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51487 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3KGFEu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 00:04:50 -0500
MIME-Version: 1.0
Message-ID: <527B1A69.8050708@oracle.com>
Date: Wed, 6 Nov 2013 20:43:21 -0800 (PST)
From: Anand Jain <Anand.Jain@oracle.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 11/16] btrfs-progs: pass positive errno to strerror in
 cmd_df()
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
 <1383779755-18228-12-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-12-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Reviewed-by Anand Jain <anand.jain@oracle.com>

On 11/07/2013 07:15 AM, Eric Sandeen wrote:
> get_df returns a negative error number, but then
> we pass it to strerror, which wants a positive value...
>
> Resolves-Coverity-CID: 1125929
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>   cmds-filesystem.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index df9d1ff..b1291d6 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -173,7 +173,7 @@ static int cmd_df(int argc, char **argv)
>   		print_df(sargs);
>   		free(sargs);
>   	} else {
> -		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(ret));
> +		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
>   	}
>
>   	close_file_or_dir(fd, dirstream);
>
