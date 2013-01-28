Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566Ab3A1SIZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 13:08:25 -0500
Date: Mon, 28 Jan 2013 19:08:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: Re: [PATCH 01/10] Btrfs-progs: move open_file_or_dir() to utils.c
Message-ID: <20130128180819.GF16977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1359350559-25671-1-git-send-email-anand.jain@oracle.com>
 <1359350559-25671-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359350559-25671-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 01:22:30PM +0800, Anand Jain wrote:
> The definition of the function open_file_or_dir() is moved from common.c
> to utils.c in order to be able to share some common code between scrub
> and the device stats in the following step. That common code uses
> open_file_or_dir(). Since open_file_or_dir() makes use of the function
> dirfd(3), the required XOPEN version was raised from 6 to 7.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Original-Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>

I'm taking this one preemptively because Stefan's dev-stats also depend
on it.

Please address Wang Shilong's comment in 05/10. Unless there are
objections against adding this new subcommand, I'll add it to
upcomming integration branches.


david
