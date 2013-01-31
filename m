Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab3AaPc6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 10:32:58 -0500
Message-ID: <510A8E7F.2080407@redhat.com>
Date: Thu, 31 Jan 2013 09:32:15 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix parallel build
References: <1359636652-20586-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1359636652-20586-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/31/13 6:50 AM, David Sterba wrote:
> Parallel build may fail due to late creation of version.h, fix the rule name
> that does not match the filename.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>

Look good, thanks.  surprised I didn't run into this.

Reviewed-by: Eri Sandeen <sandeen@redhat.com>
> ---
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 6df402c..bef1e13 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -52,9 +52,9 @@ endif
>  	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
>  
>  
> -all: version $(progs) manpages
> +all: version.h $(progs) manpages
>  
> -version:
> +version.h:
>  	$(Q)bash version.sh
>  
>  btrfs: $(objects) btrfs.o help.o $(cmds_objects)
> 

