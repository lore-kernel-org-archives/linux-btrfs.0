Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab3DOQVa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 12:21:30 -0400
Date: Mon, 15 Apr 2013 18:21:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 02/11, RESEND] btrfs-progs: no pending balance is not an
 error
Message-ID: <20130415162127.GE18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-3-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366007897-26567-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 15, 2013 at 02:38:08PM +0800, Anand Jain wrote:
> +/* Checks the status of the balance if any
> + * return codes:
> + *  -1 : Error failed to know if there is any pending balance
> + *   1 : Successful to know status of a pending balance
> + *   0 : When there is no pending balance or completed

The error code will become the return code of the 'btrfs balance status'
command in the end:

btrfs.c:main()

295         exit(cmd->fn(argc, argv));

and that's why I've suggested to return 1 or 2, though -1 matches shell
error code 255 but I'd rathe avoid using it.

david
