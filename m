Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56444 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751994AbeAaS3H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 13:29:07 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6E4C2AB40
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 18:29:06 +0000 (UTC)
Date: Wed, 31 Jan 2018 19:26:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 00/16] btrfs-progs: Split lowmem mode check to its own
Message-ID: <20180131182654.GJ18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180119053731.10795-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 19, 2018 at 01:37:15PM +0800, Qu Wenruo wrote:
> The long planned cmds-check re-construction is finally here.
> 
> As the original cmds-check.c is getting larger and larger (already over
> 15K lines), it's always a good idea to split it into its own check/
> directory.
> 
> This patchset do the following work:
> 1) Move cmds-check.c to check/main.c
> 2) Put codes shared by both original and lowmem mode into
>    check/common.[ch]
> 3) Put lowmem code into check/lowmem.[ch]
>    With minor renaming to get rid of unnecessary _v2 suffix.
> 
> The modification looks scary, but no functional change at all.
> 
> And considering how much the file structure changed, it's a good idea to
> put PART1 as quick as possible, and there will be less pressure to
> rebase new incoming fsck related codes.

I agree with the way you split check, my attempts were going along the
same lines. The question whether to split first and then add fixes shall
be resolved as I'm going to merge the split first. This would need
refreshing the lowmem fixes but the other way around would not avoid the
merge conflicts anyway.

The patch 15 does not apply cleanly to current devel, the conflict did
not seem big, but I did not try to resolve it and merge the last patch.
So, 1-14 goes to devel, please refresh 15 and 16.

> The real move work happens in the 15th patch, which due to its size
> (500KB+), it may not be able to reach mail list.
> So please fetch the whole patchset from github:
> https://github.com/adam900710/btrfs-progs/tree/split_check
> 
> There will be a part 2, mostly moving original mode to its own
> check/original.[ch], along with extra comment explaining how the two
> different modes work.

I'm going to do a few file renames, eg. original.c -> mode-original.c
and similar. It would be better if you send part 2 after that. I'm
expecting more patches that would do no functional change so we can
settle down with the new check/ structure.

As 'check' is the 1st level command, the cmds-check.c will need to be
restored at some point, but it will be only a simple wrapper around the
commandline handling.
