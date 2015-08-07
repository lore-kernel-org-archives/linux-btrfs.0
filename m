Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137AbbHGOBG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Aug 2015 10:01:06 -0400
Date: Fri, 7 Aug 2015 16:00:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Robert Munteanu <robert.munteanu@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] Fix for infinite loop on non-empty inode but with no
 file extent
Message-ID: <20150807140043.GA10756@suse.cz>
Reply-To: dsterba@suse.cz
References: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150805164057.GC31669@twin.jikos.cz>
 <CAC8ULPad3LTcegecjV6s-HxK8Yn-k72Eh6=AN5VayeraUO4GzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAC8ULPad3LTcegecjV6s-HxK8Yn-k72Eh6=AN5VayeraUO4GzQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 07, 2015 at 04:05:44PM +0300, Robert Munteanu wrote:
> >> Qu Wenruo (3):
> >>   btrfs-progs: fsck: Print correct file hole
> >>   btrfs-progs: fsck: Fix a infinite loop on discount file extent repair
> >>   btrfs-progs: fsck-tests: Add test case for inode lost all its file
> >>     extent
> >
> > Applied, thank you both.
> 
> I tried to find a git repo with these patches applied but failed.
> Based on the information at [0] I looked at
> 
>   http://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git
>   http://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git
> 
> but did not find them.
> 
> How can I build a version of btrfsprogs with these patches applied?

The patches are collected to the branch named devel. The branch master
is updated only at release time so the recent patches cannot be found
there.

> [0]: https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#btrfs-progs_git_repository

Given that you came from the wiki and still was not able to find the
answer, I'll update it. Thanks.
