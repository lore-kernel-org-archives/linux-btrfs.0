Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab3DLP5m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Apr 2013 11:57:42 -0400
Date: Fri, 12 Apr 2013 17:57:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/9] btrfs-progs: no pending balance is not an error
Message-ID: <20130412155739.GY18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1365141303-10571-3-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365141303-10571-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 05, 2013 at 01:54:56PM +0800, Anand Jain wrote:
> --- a/cmds-balance.c
> +++ b/cmds-balance.c
> @@ -662,8 +662,12 @@ static int cmd_balance_status(int argc, char **argv)
>  	close(fd);
>  
>  	if (ret < 0) {
> +		if (e == ENOTCONN) {
> +			printf("No balance found on '%s'\n", path);
> +			return 0;
> +		}
>  		fprintf(stderr, "ERROR: balance status on '%s' failed - %s\n",
> -			path, (e == ENOTCONN) ? "Not in progress" : strerror(e));

I'm not sure if we want to change the error code if balance is not in
progress. That's the only way to find out if it is so.

Let's say that I have this shell code as a balance monitor and expect it
to finish when the balance finishes:

while btrfs fi balance status; do
	sleep 5;
done

not possible after your change. What we can do is to differentiate the
status by a different error code number, let's say 1 for an error and 2
for 'not in progress'.

> +			path, strerror(e));
>  		return 19;
>  	}
