Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab3A1QQo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 11:16:44 -0500
Date: Mon, 28 Jan 2013 17:16:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org, Danny Kukawka <danny.kukawka@bisect.de>,
        jeff.liu@oracle.com
Subject: Re: [PATCH] Btrfs-progs: v2 Fix minor problems in  btrfslabel.c
Message-ID: <20130128161641.GB16977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1359223796-8132-1-git-send-email-gene@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359223796-8132-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 26, 2013 at 01:09:56PM -0500, Gene Czarcinski wrote:
> Fixed indentation, replace spaces with tabs.
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> 
> Rebased; fixed compiler warnings; added space after "if"
> Signed-off-by: Gene Czarcinski <gene@czarc.net>
> ---
>  btrfslabel.c | 57 +++++++++++++++++++++++++++++----------------------------

Jeff Liu has sent a series that updates the code and also fixes the
formatting. And I'd prefer to take his series as a more extensive
update.

Also, btrfslabel.c is another file to be removed and its contents placed
into the right locations, like cmds-filesystem.c or util.[ch] . I didn't
realize that during reviewing the label series.

Jeff, I suggest to add a new patch that moves the functions out of
btrfslabel.c, so you don't have to rework the whole series again.

thanks,
david
