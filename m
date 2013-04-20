Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab3DTEs6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 00:48:58 -0400
Message-ID: <51721E3B.20905@redhat.com>
Date: Fri, 19 Apr 2013 21:48:59 -0700
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Jon Nelson <jnelson@jamponi.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: minor patch to cmds-restore.c
References: <CAKuK5J3LnB41=qKdDFrpQ2jPU+=fE2jPT-Da+NP3iBy8Xx8hmQ@mail.gmail.com>
In-Reply-To: <CAKuK5J3LnB41=qKdDFrpQ2jPU+=fE2jPT-Da+NP3iBy8Xx8hmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/19/13 7:11 PM, Jon Nelson wrote:
> The following is a minor patch to cmds-restore.c
> 

Hi Jon - just a note -

When sending a patch like this, it's best to follow the standard
patch format, which closely mimics the kernel patch submission
guidelines:

Subject: [PATCH] btrfs-progs: <descriptive summary>

<longer description of change, if needed>

Signed-off-by: <you> <you@your.email.com>
---

<patch itself>

i.e. like:

Subject: [PATCH] btrfs-progs: fix btrfs restore command usage text

The built-in command help for btrfs restore was incorrect;
some options were missing and/or incorrect, and the destination
argument was not shown.

Signed-off-by: Jon Nelson <jnelson@jamponi.net>
---

That way it's clear to the reviewer as well as making the source
control history more descriptive.

Hum, it'd be nice to have it in the manpage too...

Thanks,
-Eric

> diff --git a/cmds-restore.c b/cmds-restore.c
> index c75e187..273c813 100644
> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -917,14 +917,16 @@ out:
>  }
> 
>  const char * const cmd_restore_usage[] = {
> -       "btrfs restore [options] <device>",
> +       "btrfs restore [options] <device> [destination]",
>         "Try to restore files from a damaged filesystem (unmounted)",
>         "",
> +       "-l              list roots",
>         "-s              get snapshots",
>         "-v              verbose",
>         "-i              ignore errors",
>         "-o              overwrite",
> -       "-t              tree location",
> +       "-r <rootid>     root location",
> +       "-t <treeid>     tree location",
>         "-f <offset>     filesystem location",
>         "-u <block>      super mirror",
>         "-d              find dir",
> 
> 
> --
> Jon
> Software Blacksmith
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

