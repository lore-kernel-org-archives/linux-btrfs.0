Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55339 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751639AbdABQry (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jan 2017 11:47:54 -0500
Date: Mon, 2 Jan 2017 17:47:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Subject: Re: [PULL REQUEST FOR NEXT PATCH 00/26] Patches from Fujitsu for
 next version
Message-ID: <20170102164738.GK12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161230010036.28099-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161230010036.28099-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 30, 2016 at 09:00:36AM +0800, Qu Wenruo wrote:
> Hi, please fetch the following branch for next branch:
> https://github.com/adam900710/linux.git fujitsu_for_next
> 
> This branch contains most of Fujitsu unmerged patches for for-next branch.
> 
> Latest David's for-next-20161219 branch can cause kernel panic so I don't
> use it as base, but v4.10-rc1.

The for-next branch will be reassembled again as we're past rc1 now.

> I ran the full xfstests test cases, with both default mount options and
> compress=lzo options.
> Fixes are working and no new regression.
> 
> So I thing it should be good enough to act as a base for for-next branch.
> 
> This big patch set contains the following fixes:
> 
> 1) Wang's fixes for compression ENOSPC

AFAIK, the patches have been reviewed only partially and used to be part
of for-next until the merge conflicts became unbearable. Patches
touching space handling need review before merging and at least some
sort of ack in case of for-next.

> 2) Qgroup reserved space fix and WARN_ON

Similar situation here.

> 3) Inband dedupe work

As this is a new feature, I'll postpone it for now until the for-next
branch is settled after the merge window.
