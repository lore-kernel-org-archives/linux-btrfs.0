Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:38208 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946891Ab3BHSGE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 13:06:04 -0500
Date: Fri, 8 Feb 2013 19:05:50 +0100
From: Ian Kumlien <pomac@vapor.com>
To: kreijack@inwind.it
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-progs: Merge btrfs-restore, btrfsck, btrfs-select-super,
 btrfs-dump-super and btrfs-debug-tree in to btrfs
Message-ID: <20130208180550.GM15780@pomac.netswarm.net>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <51153892.5030601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51153892.5030601@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 08, 2013 at 06:40:34PM +0100, Goffredo Baroncelli wrote:
> On 02/08/2013 01:36 AM, Ian Kumlien wrote:
> > Hi,
> > 
> > This patch series moves some of the commands around to reflect that
> > they are now subcommands of btrfs.
> > 
> > As a stage in this we also add support for btrfs being called as 
> > btrfsck which yeilds the, now(?), starnard "btrfs check" or 
> > fsck.btrfs which is a noop to avoid complications with distributions.
> > 
> > We also merge Josef Baciks btrfs-dump-super in patch number 4.
> > 
> > This patchset has been rebased on top of David Sterbas latest WIP changes.
> > 
> > Comments? Ideas? Suggestions?
> 
> Se my other two email for the specific comment. However I can ask you to
> update the man page with these new commands. Any way I really appreciate
> the improved help for these commands.

I'll most definetly look in to it - =)

> > 
> > Please help me with all the help text and verify that it's correct enough ;)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> -- 
> gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
