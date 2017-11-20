Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41190 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752405AbdKTURd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 15:17:33 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 72EAAAB22
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 20:17:32 +0000 (UTC)
Date: Mon, 20 Nov 2017 21:15:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/7] btrfs-progs: mkfs: Reword --rootdir
Message-ID: <20171120201537.GG3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171020015907.25430-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171020015907.25430-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 20, 2017 at 09:59:00AM +0800, Qu Wenruo wrote:
> Can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/mkfs_rootdir_rework
> 
> And fetching from github is preferred method to test, as this patchset
> has 2 prerequisite:
> 
> 1) Minimal device size patchset
>    The image size estimate algorithm heavily relies on the minimal
>    device size calculation
> 
> 2) Rootdir refactor
>    To make life a little easier.
> 
> Both the prerequisite has no further modification in this patchset, just the
> version submitted to mail list, and rebased to v4.13.3 without any
> conflict.

FYI, this patchset is now under close review and is going to be merged
next. The patches look good so far but I still may have some questions
or comments.  The status of the patchset is in tracking pull request #66.
