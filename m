Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35109 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3KGCqq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Nov 2013 21:46:46 -0500
Message-ID: <527B0119.7000001@oracle.com>
Date: Thu, 07 Nov 2013 10:55:21 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/16] btrfs-progs: fix test for return of realpath in
 find_mount_root()
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com> <1383779755-18228-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-5-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Reviewed-by: Anand Jain <anand.jain@oracle.com>


On 11/07/2013 07:15 AM, Eric Sandeen wrote:
> find_mount_root() tries to test for realpath() failure, but
> tests the wrong value.  Fix it.
>
> Resolves-Coverity-CID: 1125940
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>   cmds-send.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/cmds-send.c b/cmds-send.c
> index 39110e7..53e9a53 100644
> --- a/cmds-send.c
> +++ b/cmds-send.c
> @@ -98,7 +98,7 @@ int find_mount_root(const char *path, char **mount_root)
>
>   	ret = 0;
>   	*mount_root = realpath(longest_match, NULL);
> -	if (!mount_root)
> +	if (!*mount_root)
>   		ret = -errno;
>
>   	free(longest_match);
>
