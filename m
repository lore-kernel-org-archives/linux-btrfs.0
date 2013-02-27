Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab3B0PpI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 10:45:08 -0500
Date: Wed, 27 Feb 2013 16:45:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add correct indentation
Message-ID: <20130227154504.GH27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1361516364-25810-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361516364-25810-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 02:59:24PM +0800, Anand Jain wrote:
> --- a/utils.c
> +++ b/utils.c
> @@ -1192,12 +1192,13 @@ scan_again:
>  		return -ENOENT;
>  	}
>  	/* skip the header */
> -	for(i=0; i < 2 ; i++)
> -		if(!fgets(buf, 1023, proc_partitions)){
> -		fprintf(stderr, "Unable to read '/proc/partitions' for scanning\n");
> -		fclose(proc_partitions);
> -		return -ENOENT;
> -	}
> +	for (i=0; i < 2 ; i++)

	for (i = 0; i < 2; i++)

If possible, It's good to fix these issues in one go, I'll fix it locally.

david
