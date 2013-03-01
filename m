Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab3CARrx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Mar 2013 12:47:53 -0500
Message-ID: <5130E9C6.6000704@redhat.com>
Date: Fri, 01 Mar 2013 11:47:50 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: usage should match what is coded
References: <1362132602-29501-1-git-send-email-anand.jain@oracle.com> <1362132602-29501-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1362132602-29501-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/1/13 4:10 AM, Anand Jain wrote:
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Revieed-by: Eric Sandeen <sandeen@redhat.com>

But the curious side of me wonders how it got this way.

commit e43cc461550130494194201037590a2b1f0f6880
Author: Ian Kumlien <pomac@demius.net>
Date:   Fri Feb 8 01:37:02 2013 +0100

    Btrfs-progs: add restore command to btrfs

added the usage text below, but didn't change the getopt
or add code to handle them.

No idea where it came from, it wasn't in the standalone
restore either.  *shrug*  I guess nothing got lost.

-Eric

> ---
>  cmds-restore.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/cmds-restore.c b/cmds-restore.c
> index 9385042..4a14f93 100644
> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -763,10 +763,6 @@ const char * const cmd_restore_usage[] = {
>  	"-f <offset>     filesystem location",
>  	"-u <block>      super mirror",
>  	"-d              find dir",
> -	"-r <num>        root objectid",
> -	"-c              ignore case in regular expression",
> -	"-m <regexp>     regular expression to match",
> -	"-l              list roots",
>  	NULL
>  };
>  
> 

