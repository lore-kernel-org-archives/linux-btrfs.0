Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:51289 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab2JIPIu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 11:08:50 -0400
Date: Tue, 9 Oct 2012 17:08:44 +0200
From: David Sterba <dave@jikos.cz>
To: Dieter Ries <mail@dieterries.net>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs-progs: btrfsck: Print which filesystem to be
 checked to stdout
Message-ID: <20121009150844.GT4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1349723270-12773-1-git-send-email-mail@dieterries.net>
 <1349723270-12773-3-git-send-email-mail@dieterries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349723270-12773-3-git-send-email-mail@dieterries.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 09:07:48PM +0200, Dieter Ries wrote:
> --- a/btrfsck.c
> +++ b/btrfsck.c
> @@ -3540,6 +3540,8 @@ int main(int ac, char **av)
>  	} else if(ret) {
>  		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[optind]);
>  		return -EBUSY;
> +	} else {
> +		printf("Checking filesystem on %s\n",av[optind]);

This could be extended to print the UUID of the filesystem as well.
Otherwise ok.

david
