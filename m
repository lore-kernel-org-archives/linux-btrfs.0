Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:61489 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3DEJFo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 05:05:44 -0400
Message-ID: <515E93E9.9090306@giantdisaster.de>
Date: Fri, 05 Apr 2013 11:05:45 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 9/9] btrfs-progs: fix btrfs scrub start help
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com> <1365141303-10571-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141303-10571-10-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri,  5 Apr 2013 13:55:03 +0800, Anand Jain wrote:
> a very trivial fix
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  cmds-scrub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cmds-scrub.c b/cmds-scrub.c
> index 5922361..ebb0dc9 100644
> --- a/cmds-scrub.c
> +++ b/cmds-scrub.c
> @@ -1465,7 +1465,7 @@ out:
>  }
>  
>  static const char * const cmd_scrub_start_usage[] = {
> -	"btrfs scrub start Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>\n",
> +	"btrfs scrub start [Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>\n",
>  	"Start a new scrub",
>  	"",
>  	"-B     do not background",
> 

The '\n' at the end is also wrong. In cmd_scrub_resume_usage[] as well.

If you happen to send a V2, you could fix these two '\n' merge issues, too.

