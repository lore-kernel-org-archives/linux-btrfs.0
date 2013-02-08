Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:34794 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946582Ab3BHRjm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 12:39:42 -0500
Received: by mail-ea0-f171.google.com with SMTP id c13so1729828eaa.30
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2013 09:39:41 -0800 (PST)
Message-ID: <51153892.5030601@gmail.com>
Date: Fri, 08 Feb 2013 18:40:34 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Ian Kumlien <pomac@demius.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-progs: Merge btrfs-restore, btrfsck, btrfs-select-super,
 btrfs-dump-super and btrfs-debug-tree in to btrfs
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
In-Reply-To: <1360283822-23452-1-git-send-email-pomac@demius.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/08/2013 01:36 AM, Ian Kumlien wrote:
> Hi,
> 
> This patch series moves some of the commands around to reflect that
> they are now subcommands of btrfs.
> 
> As a stage in this we also add support for btrfs being called as 
> btrfsck which yeilds the, now(?), starnard "btrfs check" or 
> fsck.btrfs which is a noop to avoid complications with distributions.
> 
> We also merge Josef Baciks btrfs-dump-super in patch number 4.
> 
> This patchset has been rebased on top of David Sterbas latest WIP changes.
> 
> Comments? Ideas? Suggestions?

Se my other two email for the specific comment. However I can ask you to
update the man page with these new commands. Any way I really appreciate
the improved help for these commands.
> 
> Please help me with all the help text and verify that it's correct enough ;)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
