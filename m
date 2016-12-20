Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36336 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934917AbcLTOKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 09:10:17 -0500
Date: Tue, 20 Dec 2016 15:09:55 +0100
From: David Sterba <dsterba@suse.cz>
To: "Xiang, Yang" <Yang.Xiang@Teradata.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Newbie question about linux-btrfs patch
Message-ID: <20161220140955.GH3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <D47D5796.10F84%Yang.Xiang@teradata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <D47D5796.10F84%Yang.Xiang@teradata.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 19, 2016 at 05:23:33PM +0000, Xiang, Yang wrote:
> We are interested in testing out and possibly contribute to the btrfs
> dedup effort. I¹ve been looking around the github at:
> git://repo.or.cz/btrfs-progs-unstable/devel.git
> And I couldn¹t locate any of the patch set some of you mentioned in the
> posts such as: 
> http://www.spinics.net/lists/linux-btrfs/msg53408.html

You can find general information about development at the wiki
https://btrfs.wiki.kernel.org/index.php/Main_Page#Developer_documentation

There are several git repositories, patches are also sent to the
mailinglist, optionally with pointers to the git repository where you
can find them.

> Can someone please show me the way as how to grab the latest patch set and
> apply to both kernel source and users space prog soruce for linux-btrfs?

The kernel module and userspace progs do not share a git repository,
although portions of the code are the same in both.

If you're interested in the latest development branches, they might
exist in developers' git trees and after review go to my tree [1] to the
branches named like 'for-next-20161212'. This consists of patches that
are likely to go to Chris' git tree [2] that gets forwarded to the final
destination in Linus' tree. Depending on the development cycle, the
patches stay in the for-next branch until their time comes. More on that
in [3].

[1] https://git.kernel.org/cgit/linux/kernel/git/kdave/linux.git/
[2] https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/
[3] https://btrfs.wiki.kernel.org/index.php/Developer's_FAQ#Development_schedule
