Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53526 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758007AbcLTQUx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 11:20:53 -0500
Date: Tue, 20 Dec 2016 17:20:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] btrfs fixes and cleanups
Message-ID: <20161220162036.GM3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1481786012-18586-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1481786012-18586-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 14, 2016 at 11:13:32PM -0800, Liu Bo wrote:
> This is the collection of my patches targetting 4.10, I've
> dropped patch "Btrfs: adjust len of writes if following a
> preallocated extent" because of the deadlock caused by this
> commit.
> 
> Patches are based on v4.9-rc8, and test against fstests with
> default mount options has been taken to make sure it doesn't
> break anything.
> 
> I haven't got a kernel.org git repo, so this is mainly for
> tracking purpose and for testing git flow.
> 
> (cherry-pick patches might be the only way at this moment...sorry
> for the inconvenience.)
> 
> Anyway, patches can be found at
> 
> 	https://github.com/liubogithub/btrfs-work.git for-dave

Thanks, I've added this branch to my list for-next source branches. Once
the merge window is closed, your branch will be part of the published
for-next.
