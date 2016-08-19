Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49180 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754170AbcHSKxn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 06:53:43 -0400
Date: Fri, 19 Aug 2016 12:31:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 00/13] btrfs-progs: check: check fs roots in low_memory
 mode
Message-ID: <20160819103130.GF16983@suse.cz>
Reply-To: dsterba@suse.cz
References: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160817170018.GA16983@twin.jikos.cz>
 <57B6D818.5020501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57B6D818.5020501@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 19, 2016 at 05:57:44PM +0800, Wang Xiaoguang wrote:
> Hi
> 
> On 08/18/2016 01:00 AM, David Sterba wrote:
> > On Thu, Jul 28, 2016 at 03:08:12PM +0800, Lu Fengqi wrote:
> >> This patchset implements check fs trees in low memory mode, and fix the
> >> return value bug of the function cmd_check().
> >>
> >> Lu Fengqi (13):
> >>    btrfs-progs: move btrfs_extref_hash() to hash.h
> >>    btrfs-progs: check: introduce function to find dir_item
> >>    btrfs-progs: check: introduce function to check inode_ref
> >>    btrfs-progs: check: introduce function to check inode_extref
> >>    btrfs-progs: check: introduce function to find inode_ref
> >>    btrfs-progs: check: introduce a function to check dir_item
> >>    btrfs-progs: check: introduce function to check file extent
> >>    btrfs-progs: check: introduce function to check inode item
> >>    btrfs-progs: check: introduce function to check fs root
> >>    btrfs-progs: check: introduce function to check root ref
> >>    btrfs-progs: check: introduce low_memory mode fs_tree check
> >>    btrfs-progs: check: fix the return value bug of cmd_check()
> >>    btrfs-progs: check: fix false warning for check_extent_item()
> > FYI, I'm going to promote this series within devel and schedule it for
> > the next release. The preparatory subset will be merged, but I might do
> > some modificaions to the command line interface.
> In current low memory fs trees check, it dose not check whether
> node or leaf is shared, which will casue btrfsck much slower when
> fs has one or more snapshots. I have prepared a patch to improve
> this issue, if you have some free time, please check it, thanks.

The low-memory mode has an experimental status (and thus is not on by
default) so the improvements are welcome of course.
